/datum/computer_file/program/lifeline
	filename = "lifeline"
	filedesc = "Lifeline"
	extended_desc = "This program allows for tracking of crew members via their suit sensors."
	transfer_access = list(ACCESS_MEDICAL)
	category = PROGRAM_CATEGORY_CREW
	ui_header = "borg_mon.gif" //DEBUG -- new icon before PR (classic)
	program_icon_state = "radarntos"
	// requires_ntnet = TRUE -- disabled to be constistent with the paramedic's crew monitor
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_LAPTOP | PROGRAM_TABLET
	size = 5
	tgui_id = "NtosLifeline"
	program_icon = "heartbeat"

	// Tracking information
	var/list/sensors = list()
	var/mob/living/selected
	var/last_update_time

	// UI Settings
	var/sort_asc = TRUE
	var/sort_by = "dist"
	var/blueshield = FALSE

	///Used to keep track of the last value program_icon_state was set to, to prevent constant unnecessary update_appearance() calls
	var/last_icon_state = ""


/datum/computer_file/program/lifeline/on_start(mob/living/user)
	. = ..()
	if(.)
		blueshield = istype(computer, /obj/item/modular_computer/pda/blueshield)
		START_PROCESSING(SSfastprocess, src)
		return TRUE
	return FALSE

/datum/computer_file/program/lifeline/kill_program(mob/user)
	sensors = list()
	selected = null
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/computer_file/program/lifeline/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/computer_file/program/lifeline/ui_data(mob/user)
	return list(
		"selected" = selected,
		"sensors" = update_sensors(),
		"settings" = list(
			"blueshield" = blueshield,
			"sortAsc" = sort_asc,
			"sortBy" = sort_by
		)
	)

/datum/computer_file/program/lifeline/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("select")
			selected = params["ref"]
		if("sortAsc")
			sort_asc = params["val"]
		if("sortBy")
			sort_by = params["val"]
		if("blueshield")
			blueshield = params["val"]
	return TRUE

// Copied and modified from "code\game\machinery\computer\crew.dm"
/datum/computer_file/program/lifeline/proc/tracking_level(mob/living/tracked_living_mob, z)
	// Check if z-level is correct
	var/turf/pos = get_turf(tracked_living_mob)

	// Is our target in nullspace for some reason?
	if(!pos)
		stack_trace("Tracked mob has no loc and is likely in nullspace: [tracked_living_mob] ([tracked_living_mob.type])")
		return SENSOR_OFF

	// Machinery and the target should be on the same level or different levels of the same station
	if(pos.z != z && !(z in SSmapping.get_connected_levels(pos.z)) && !HAS_TRAIT(tracked_living_mob, TRAIT_MULTIZ_SUIT_SENSORS))
		return SENSOR_OFF

	// Set sensor level based on whether we're in the nanites list or the suit sensor list.
	if(tracked_living_mob in GLOB.nanite_sensors_list)
		return SENSOR_COORDS

	var/mob/living/carbon/human/tracked_human = tracked_living_mob

	// Check their humanity.
	if(!ishuman(tracked_human))
		stack_trace("Non-human mob is in suit_sensors_list: [tracked_living_mob] ([tracked_living_mob.type])")
		return SENSOR_OFF

	// Check they have a uniform
	var/obj/item/clothing/under/uniform = tracked_human.w_uniform
	if (!istype(uniform))
		stack_trace("Human without a suit sensors compatible uniform is in suit_sensors_list: [tracked_human] ([tracked_human.type]) ([uniform?.type])")
		return SENSOR_OFF

	// Check if their uniform is in a compatible mode.
	if (uniform.has_sensor >= HAS_SENSORS)
		return uniform.sensor_mode
	return SENSOR_OFF

/datum/computer_file/program/lifeline/proc/update_sensors()
	var/turf/pos = get_turf(computer)
	if (world.time <= last_update_time + 3 SECONDS && sensors)
		return sensors

	sensors = list()
	for(var/tracked_mob in GLOB.suit_sensors_list | GLOB.nanite_sensors_list)
		if(!tracked_mob)
			stack_trace("Null entry in suit sensors or nanite sensors list.")
			continue

		var/mob/living/tracked_living_mob = tracked_mob
		var/sensor_level = tracking_level(tracked_living_mob, pos.z)
		if(sensor_level == SENSOR_OFF)
			continue

		var/turf/sensor_pos = get_turf(tracked_living_mob)

		var/list/crewinfo = list(
			ref = REF(tracked_living_mob),
			name = "Unknown",
			ijob = 81, // UNKNOWN_JOB_ID from crew.dm
			area = "Unknown",
			dist = -1, // This value tells the UI that tracking is disabled
			degrees = 0,
			zdiff = 0,
		)
		if (sensor_level == SENSOR_COORDS)
			crewinfo["area"] = get_area_name(tracked_living_mob, format_text = TRUE)
			crewinfo["dist"] = max(get_dist(pos, sensor_pos), 0)
			crewinfo["degrees"] = round(get_angle(pos, sensor_pos))
			crewinfo["zdiff"] = sensor_pos.z-pos.z

		var/obj/item/card/id/id_card = tracked_living_mob.get_idcard(hand_first = FALSE)
		if(id_card)
			crewinfo["name"] = id_card.registered_name
			crewinfo["assignment"] = id_card.assignment
			var/trim_assignment = id_card.get_trim_assignment()
			if (GLOB.crewmonitor.jobs[trim_assignment] != null)
				crewinfo["trim"] = trim_assignment
				crewinfo["ijob"] = GLOB.crewmonitor.jobs[trim_assignment]

		sensors += list(crewinfo)
	last_update_time = world.time
	return sensors

//We use SSfastprocess for the program icon state because it runs faster than process_tick() does.
/datum/computer_file/program/lifeline/process()
	if(computer.active_program != src)
		STOP_PROCESSING(SSfastprocess, src) //We're not the active program, it's time to stop.
		return
	if(!selected)
		return

	var/atom/movable/signal = locate(selected) in GLOB.human_list
	var/turf/here_turf = get_turf(computer)
	if(tracking_level(signal, here_turf.z) != SENSOR_COORDS)
		program_icon_state = "[initial(program_icon_state)]lost"
		if(last_icon_state != program_icon_state)
			computer.update_appearance()
			last_icon_state = program_icon_state
		return

	var/turf/target_turf = get_turf(signal)
	var/trackdistance = get_dist_euclidean(here_turf, target_turf)
	switch(trackdistance)
		if(0)
			program_icon_state = "[initial(program_icon_state)]direct"
		if(1 to 12)
			program_icon_state = "[initial(program_icon_state)]close"
		if(13 to 24)
			program_icon_state = "[initial(program_icon_state)]medium"
		if(25 to INFINITY)
			program_icon_state = "[initial(program_icon_state)]far"

	if(last_icon_state != program_icon_state)
		computer.update_appearance()
		last_icon_state = program_icon_state
	computer.setDir(get_dir(here_turf, target_turf))

//We can use process_tick to restart fast processing, since the computer will be running this constantly either way.
/datum/computer_file/program/lifeline/process_tick(seconds_per_tick)
	if(computer.active_program == src)
		START_PROCESSING(SSfastprocess, src)
