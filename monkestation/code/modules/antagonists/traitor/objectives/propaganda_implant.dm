// Category

/datum/traitor_objective_category/propaganda_implant
	name = "Propaganda Implanter"
	objectives = list(
		/datum/traitor_objective/target_player/propaganda_implant = 1,
		/datum/traitor_objective/target_player/propaganda_implant/heads = 1,
		/datum/traitor_objective/target_player/propaganda_implant/nt_rep = 0.5,
	)
	weight = OBJECTIVE_WEIGHT_UNLIKELY

// Objective

/datum/traitor_objective/target_player/propaganda_implant
	name = "Implant %TARGET% the %JOB TITLE% with a propaganda chip"
	description = "%TARGET% has been too confident or something. Implant them with a progaganda chip to upset them or something."

	progression_minimum = 10 MINUTES
	progression_maximum = 50 MINUTES

	progression_reward = list(3 MINUTES, 6 MINUTES)
	telecrystal_reward = list(0, 1)

	var/spawned_implanter = FALSE

/datum/traitor_objective/target_player/propaganda_implant/heads
	progression_reward = list(6 MINUTES, 12 MINUTES)
	telecrystal_reward = 2

/datum/traitor_objective/target_player/propaganda_implant/nt_rep
	progression_reward = list(8 MINUTES, 16 MINUTES)
	telecrystal_reward = 3

/datum/traitor_objective/target_player/propaganda_implant/supported_configuration_changes()
	. = ..()
	. += NAMEOF(src, objective_period)
	. += NAMEOF(src, maximum_objectives_in_period)

/datum/traitor_objective/target_player/propaganda_implant/New(datum/uplink_handler/handler)
	. = ..()
	AddComponent(/datum/component/traitor_objective_limit_per_time, \
		/datum/traitor_objective/target_player, \
		time_period = objective_period, \
		maximum_objectives = maximum_objectives_in_period \
	)

/datum/traitor_objective/target_player/propaganda_implant/generate_objective(datum/mind/generating_for, list/possible_duplicates)

	var/list/already_targeting = list() //List of minds we're already targeting. The possible_duplicates is a list of objectives, so let's not mix things
	for(var/datum/objective/task as anything in handler.primary_objectives)
		if(!istype(task.target, /datum/mind))
			continue
		already_targeting += task.target //Removing primary objective kill targets from the list

	var/list/possible_targets = list()
	var/try_target_late_joiners = FALSE
	if(generating_for.late_joiner)
		try_target_late_joiners = TRUE

	var/nt_rep = istype(src, /datum/traitor_objective/target_player/propaganda_implant/nt_rep)
	var/heads_of_staff = istype(src, /datum/traitor_objective/target_player/propaganda_implant/heads)

	for(var/datum/mind/possible_target as anything in get_crewmember_minds())
		if(possible_target == generating_for)
			continue

		if(possible_target in already_targeting)
			continue

		if(!ishuman(possible_target.current))
			continue

		if(possible_target.current.stat == DEAD)
			continue

		if(possible_target.has_antag_datum(/datum/antagonist/traitor))
			continue

		if(!possible_target.assigned_role)
			continue

		if(nt_rep)
			if(!istype(possible_target.assigned_role, /datum/job/nanotrasen_representative))
				continue
		else if(heads_of_staff)
			if(!(possible_target.assigned_role.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND))
				continue
		else
			if(possible_target.assigned_role.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND)
				continue

		var/mob/living/carbon/human/targets_current = possible_target.current
		if(HAS_TRAIT(targets_current, TRAIT_SPONSOR_IMPLANT_SYNDI))
			continue

		possible_targets += possible_target

	for(var/datum/traitor_objective/target_player/objective as anything in possible_duplicates)
		possible_targets -= objective.target?.mind

	if(try_target_late_joiners)
		var/list/all_possible_targets = possible_targets.Copy()
		for(var/datum/mind/possible_target as anything in all_possible_targets)
			if(!possible_target.late_joiner)
				possible_targets -= possible_target

		if(!possible_targets.len)
			possible_targets = all_possible_targets

	if(!possible_targets.len)
		return FALSE //MISSION FAILED, WE'LL GET EM NEXT TIME

	var/datum/mind/target_mind = pick(possible_targets)
	target = target_mind.current

	replace_in_name("%TARGET%", target_mind.name)
	replace_in_name("%JOB TITLE%", target_mind.assigned_role.title)
	target.AddComponent(/datum/component/propaganda_target, src)
	AddComponent(/datum/component/traitor_objective_register, target, fail_signals = list(COMSIG_QDELETING))
	return TRUE

/datum/traitor_objective/target_player/propaganda_implant/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!spawned_implanter)
		buttons += add_ui_button("", "Pressing this will materialize an eyesnatcher, which can be used on incapacitaded or restrained targets to forcefully remove their eyes.", "syringe", "propaganda_implanter")
	return buttons

/datum/traitor_objective/target_player/propaganda_implant/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("propaganda_implanter")
			if(spawned_implanter)
				return
			spawned_implanter = TRUE
			var/obj/item/implanter/syndi_propaganda_slow/implanter = new(user.drop_location())
			user.put_in_hands(implanter)
			implanter.balloon_alert(user, "the implanter materializes in your hand")

// Target component

/datum/component/propaganda_target
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/datum/traitor_objective/objective

/datum/component/propaganda_target/Initialize(datum/traitor_objective/objective)
	. = ..()
	src.objective = objective

/datum/component/propaganda_target/proc/implanted()
	objective.succeed_objective()
	qdel(src)

// Implanter

/obj/item/implanter/syndi_propaganda_slow
	name = "implanter (mindshield)"
	desc = "modified to tap into the syndicate propaganda network, won't work through thick clothing"
	w_class = WEIGHT_CLASS_TINY
	imp_type = /obj/item/implant/syndi_propaganda

/obj/item/implanter/syndi_propaganda_slow/attack(mob/living/target, mob/user)
	if(!(istype(target) && user && imp))
		return

	if(!target.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		return

	if(target != user)
		target.visible_message(span_warning("[user] is attempting to implant [target]."))
		if(!do_after(user, 10 SECONDS, target, extra_checks = CALLBACK(target, TYPE_PROC_REF(/mob/living, try_inject), user, null, INJECT_TRY_SHOW_ERROR_MESSAGE)))
			return

	if(!(src && imp))
		return

	if(imp.implant(target, user))
		if (target == user)
			to_chat(user, span_notice("You implant yourself."))
		else
			target.visible_message(span_notice("[user] implants [target]."), span_notice("[user] implants you."))
		imp = null
		update_appearance()
	else
		to_chat(user, span_warning("[src] fails to implant [target]."))
