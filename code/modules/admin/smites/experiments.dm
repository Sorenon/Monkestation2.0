/// Throw an immovable rod at the target
/datum/smite/omniman_special
	name = "Omniman Special"
	// var/start_from_edge = FALSE

/datum/smite/omniman_special/configure(client/user)
	// var/loop_from_pos = tgui_alert(usr,"Would you like this rod to force-loop across space z-levels?", "Loopy McLoopface", list("Yes", "No"))

	// var/loop_from_pos = tgui_alert(usr,"Would you like this rod to force-loop across space z-levels?", "Loopy McLoopface", list("Yes", "No"))

	// loop once
	// from edge to loc
	// from loc to edge

	// give temp invuln

	// start_from_edge = (start_from_edge_input == "Yes")

/datum/smite/omniman_special/effect(client/user, mob/living/target)
	. = ..()
	var/turf/target_turf = get_turf(target)
	var/turf/end_turf = spaceDebrisFinishLoc(DIRFLIP(target.dir), target_turf.z)
	new /obj/effect/immovablerod/ridden(target_turf, end_turf, null, FALSE, target)

/obj/effect/immovablerod/ridden
	var/mob/living/rider
	var/turf/rider_start_turf
	icon = null
	var/heading_back = FALSE

/obj/effect/immovablerod/ridden/Initialize(mapload, atom/target_atom, atom/specific_target, force_looping = FALSE, mob/living/rider)
	. = ..()
	src.rider = rider
	rider.SetUnconscious(0, ignore_canstun = TRUE)
	ADD_TRAIT(rider, TRAIT_BOMBIMMUNE, REF(src))
	ADD_TRAIT(rider, TRAIT_GODMODE, REF(src))
	ADD_TRAIT(rider, TRAIT_NODISMEMBER, REF(src))
	ADD_TRAIT(rider, TRAIT_NODEATH, REF(src))
	ADD_TRAIT(rider, TRAIT_NOHARDCRIT, REF(src))
	ADD_TRAIT(rider, TRAIT_NOSOFTCRIT, REF(src))
	ADD_TRAIT(rider, TRAIT_NOCRITOVERLAY, REF(src))
	ADD_TRAIT(rider, TRAIT_STUNIMMUNE, REF(src))
	buckle_mob(rider)
	rider_start_turf = get_turf(rider)

/obj/effect/immovablerod/ridden/zMove(dir, turf/target, z_move_flags)
	if (heading_back)
		return ..()
	. = ..(null, spaceDebrisStartLoc(DIRFLIP(src.dir), rider_start_turf.z), ZMOVE_ALLOW_BUCKLED)
	complete_trajectory()

// /obj/effect/immovablerod/ridden/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
// 	. = ..()
// 	var/turf/open/space/s = loc
// 	if (!istype(s))
// 		return
// 	if (s.destination_z && s.destination_x && s.destination_y)
// 		say("test")


/obj/effect/immovablerod/ridden/complete_trajectory()
	if (heading_back)
		qdel(src)
		return
	heading_back = TRUE
	special_target = rider_start_turf
	SSmove_manager.move_towards(src, rider_start_turf, home=TRUE)

/obj/effect/immovablerod/ridden/is_buckle_possible(mob/living/M, force = FALSE, check_loc = TRUE, buckle_mob_flags= NONE)
	return force || rider == M

/obj/effect/immovablerod/ridden/unbuckle_mob(mob/living/buckled_mob, force = FALSE, can_fall = TRUE)
	if(!force)
		return
	. = ..()

/obj/effect/immovablerod/ridden/post_unbuckle_mob(mob/living/unbuckled_mob)
	. = ..()
	if (unbuckled_mob == rider && !QDELETED(src))
		REMOVE_TRAIT(rider, TRAIT_BOMBIMMUNE, REF(src))
		REMOVE_TRAIT(rider, TRAIT_GODMODE, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NODISMEMBER, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NODEATH, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NOHARDCRIT, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NOSOFTCRIT, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NOCRITOVERLAY, REF(src))
		REMOVE_TRAIT(rider, TRAIT_STUNIMMUNE, REF(src))
		rider = null
		qdel(src)

/obj/effect/immovablerod/ridden/Destroy(force)
	if (!QDELETED(rider))
		REMOVE_TRAIT(rider, TRAIT_BOMBIMMUNE, REF(src))
		REMOVE_TRAIT(rider, TRAIT_GODMODE, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NODISMEMBER, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NODEATH, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NOHARDCRIT, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NOSOFTCRIT, REF(src))
		REMOVE_TRAIT(rider, TRAIT_NOCRITOVERLAY, REF(src))
		REMOVE_TRAIT(rider, TRAIT_STUNIMMUNE, REF(src))
		rider = null
	. = ..()

/obj/effect/immovablerod/ridden/Bump(atom/clong)
	. = ..()
	if (!rider)
		return .
	REMOVE_TRAIT(rider, TRAIT_GODMODE, REF(src))
	var/zone = pick(list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
	rider.apply_damage(5, BRUTE, zone, wound_bonus = 40)
	ADD_TRAIT(rider, TRAIT_GODMODE, REF(src))

/obj/effect/immovablerod/ridden/penetrate(mob/living/smeared_mob)
	if (!rider)
		return ..()
	smeared_mob.visible_message(span_danger("[smeared_mob] is crushed by [rider]!") , span_userdanger("[rider] crushes you!") , span_danger("You hear a CRUNCH!"))

	if(smeared_mob.stat != DEAD)
		num_mobs_hit++
		if(smeared_mob.client)
			num_sentient_mobs_hit++
			if(iscarbon(smeared_mob))
				num_sentient_people_hit++
			if(dnd_style_level_up)
				transform = transform.Scale(1.005, 1.005)
				name = "[initial(name)] of sentient slaying +[num_sentient_mobs_hit]"

	if(iscarbon(smeared_mob))
		var/damage = 10
		playsound(src, 'sound/effects/splat.ogg', 50, TRUE)
		smeared_mob.apply_damage(3 * damage, BRUTE, BODY_ZONE_HEAD, wound_bonus = 7)
		smeared_mob.apply_damage(3 * damage, BRUTE, BODY_ZONE_CHEST, wound_bonus = 21)
		smeared_mob.apply_damage(1 * damage, BRUTE, BODY_ZONE_L_LEG, wound_bonus = 14)
		smeared_mob.apply_damage(1 * damage, BRUTE, BODY_ZONE_R_LEG, wound_bonus = 14)
		smeared_mob.apply_damage(1 * damage, BRUTE, BODY_ZONE_L_ARM, wound_bonus = 14)
		smeared_mob.apply_damage(1 * damage, BRUTE, BODY_ZONE_R_ARM, wound_bonus = 14)

	if(smeared_mob.density || prob(10))
		EX_ACT(smeared_mob, EXPLODE_HEAVY)

