/datum/computer_file/program/lifeline2
	filename = "lifeline2"
	filedesc = "Lifeline 2.0"
	extended_desc = "This program allows for tracking of crew members via their suit sensors."
	transfer_access = list(ACCESS_MEDICAL)
	category = PROGRAM_CATEGORY_CREW
	ui_header = "borg_mon.gif" //DEBUG -- new icon before PR
	program_icon_state = "radarntos"
	// requires_ntnet = TRUE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_LAPTOP | PROGRAM_TABLET
	size = 5
	tgui_id = "NtosLifeline"
	///List of trackable entities. Updated by the scan() proc.
	var/list/objects = list()
	///Ref of the last trackable object selected by the user in the tgui window. Updated in the ui_act() proc.
	var/atom/selected
	///Used to keep track of the last value program_icon_state was set to, to prevent constant unnecessary update_appearance() calls
	var/last_icon_state = ""
	program_icon = "heartbeat"
	var/datum/crewmonitor/crewmonitor = new()
	var/sort_asc = TRUE

/datum/computer_file/program/lifeline2/on_start(mob/living/user)
	. = ..()
	if(.)
		scan()
		START_PROCESSING(SSfastprocess, src)
		return
	return FALSE

/datum/computer_file/program/lifeline2/kill_program(mob/user)
	objects = list()
	selected = null
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/computer_file/program/lifeline2/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/computer_file/program/lifeline2/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/radar_assets),
	)

/datum/computer_file/program/lifeline2/ui_data(mob/user)
	var/list/data = list()
	data["selected"] = selected
	data["sensors"] = objects
	data["settings"] = list(
		sortAsc = sort_asc
	)
	return data

/datum/computer_file/program/lifeline2/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("select")
			selected = params["ref"]
			return TRUE
		if("sortAsc")
			sort_asc = params["val"]

/**
 *
 *Checks the trackability of the selected target.
 *
 *If the target is on the computer's Z level, or both are on station Z
 *levels, and the target isn't untrackable, return TRUE.
 *Arguments:
 **arg1 is the atom being evaluated.
*/
/datum/computer_file/program/lifeline2/proc/trackable(mob/living/carbon/human/humanoid)
	if(!humanoid || !istype(humanoid))
		return FALSE
	// if(trackable_super(humanoid))
	// 	if (humanoid in GLOB.nanite_sensors_list)
	// 		return TRUE
	// 	if (istype(humanoid.w_uniform, /obj/item/clothing/under))
	// 		var/obj/item/clothing/under/uniform = humanoid.w_uniform
	// 		if(uniform.has_sensor && uniform.sensor_mode >= SENSOR_COORDS) // Suit sensors must be on maximum
	// 			return TRUE
	return TRUE

/datum/computer_file/program/lifeline2/proc/trackable_super(atom/movable/signal)
	if(!signal || !computer)
		return FALSE
	var/turf/here = get_turf(computer)
	var/turf/there = get_turf(signal)
	if(!here || !there)
		return FALSE //I was still getting a runtime even after the above check while scanning, so fuck it
	return (there.z == here.z) || (is_station_level(here.z) && is_station_level(there.z))


/**
 *
 *Runs a scan of all the trackable atoms.
 *
 *Checks each entry in the GLOB of the specific trackable atoms against
 *the track() proc, and fill the objects list with lists containing the
 *atoms' names and REFs. The objects list is handed to the tgui screen
 *for displaying to, and being selected by, the user. A two second
 *sleep is used to delay the scan, both for thematical reasons as well
 *as to limit the load players may place on the server using these
 *somewhat costly loops.
*/
/datum/computer_file/program/lifeline2/proc/scan()
	var/datum/crewmonitor/crewmonitor = new()
	var/list/jobs = crewmonitor.jobs

	objects = list()
	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/humanoid = i
		if(!trackable(humanoid))
			continue
		var/crewmember_name = "Unknown"
		var/job = null
		var/jobTitle = null
		var/ijob = 81 // UNKNOWN_JOB_ID from crew.dm
		var/obj/item/card/id/id_card = humanoid.get_idcard(hand_first = FALSE)
		if(id_card)
			crewmember_name = id_card.registered_name
			job = id_card.get_trim_assignment()
			// var/datum/job/job_ = SSjob.GetJob(job)
			ijob = jobs[job]
			jobTitle = id_card.assignment
			// command = job_.departments_bitflags & (DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_CENTRAL_COMMAND)

		var/turf/curr = get_turf(computer)
		var/turf/pos = get_turf(humanoid)

		var/list/crewinfo = list(
			ref = REF(humanoid),
			name = crewmember_name,
			job = job,
			ijob = ijob,
			area = get_area_name(humanoid, format_text = TRUE),
			dist = max(get_dist(curr, pos), 0),
			degrees = round(get_angle(curr, pos)),
			zdiff = pos.z-curr.z,
			jobTitle= jobTitle
			)
		objects += list(crewinfo)

//We use SSfastprocess for the program icon state because it runs faster than process_tick() does.
/datum/computer_file/program/lifeline2/process()
	if(computer.active_program != src)
		STOP_PROCESSING(SSfastprocess, src) //We're not the active program, it's time to stop.
		return
	if(!selected)
		return

	var/atom/movable/signal = locate(selected) in GLOB.human_list
	if(!trackable(signal))
		program_icon_state = "[initial(program_icon_state)]lost"
		if(last_icon_state != program_icon_state)
			computer.update_appearance()
			last_icon_state = program_icon_state
		return

	var/here_turf = get_turf(computer)
	var/target_turf = get_turf(signal)
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
/datum/computer_file/program/lifeline2/process_tick(seconds_per_tick)
	if(computer.active_program == src)
		START_PROCESSING(SSfastprocess, src)
