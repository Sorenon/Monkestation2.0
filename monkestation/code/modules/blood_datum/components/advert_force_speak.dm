/datum/component/advert_force_speak
	dupe_mode = COMPONENT_DUPE_SOURCES
	var/next_time = 0
	var/mob/living/speaker_implant/speaker_implant

/datum/component/advert_force_speak/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/advert_force_speak/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/component/advert_force_speak/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_LIFE))

/datum/component/advert_force_speak/Destroy(force)
	. = ..()
	if(speaker_implant != null)
		qdel(speaker_implant)
		speaker_implant = null

/datum/component/advert_force_speak/proc/on_life(mob/living/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER
	if(world.time >= next_time && source.stat < UNCONSCIOUS)
		next_time = world.time + rand(4 MINUTES) + 1 MINUTE
		INVOKE_ASYNC(src, PROC_REF(speak), source)

/datum/component/advert_force_speak/proc/speak(mob/living/source)
	var/syndi = HAS_TRAIT(source, TRAIT_SPONSOR_IMPLANT_SYNDI)
	var/implanted = syndi || HAS_TRAIT(source, TRAIT_SPONSOR_IMPLANT)
	var/bad_speak = !source.can_speak() || HAS_TRAIT(source, TRAIT_ANXIOUS) || HAS_TRAIT(source, TRAIT_SOFTSPOKEN)
	if (!bad_speak && !source.can_speak_language(/datum/language/common))
		bad_speak = TRUE
	else if (HAS_TRAIT(source, TRAIT_SIGN_LANG))
		bad_speak = FALSE

	var/list/ad_list = syndi ? GLOB.advertisements.syndi_ads : GLOB.advertisements.nt_ads
	var/ad_idx = rand(1, ad_list.len / 2) * 2
	var/sponsor = ad_list[ad_idx - 1]
	var/message = ad_list[ad_idx]
	var/spans = syndi ? list("red", "syndi-propaganda") : list()

	message = replacetext(message, "%name%", source.real_name || source.name)

	if(implanted && bad_speak)
		speaker_implant_say(source, message, sponsor)
	else
		source.say(message, language=/datum/language/common, forced="sponsored ([sponsor])", spans=spans)

	if(!implanted)
		return

	var/datum/bank_account/bank_account = source.get_bank_account()
	if(bank_account)
		bank_account.adjust_money(syndi ? -20 : 5, "[sponsor]: Sponsor Payment")

	if (HAS_TRAIT(source, TRAIT_SPONSOR_IMPLANT))
		return

	for (var/obj/item/implant/syndi_propaganda/implant in source.implants)
		implant.uses -= 1
		if (implant.uses <= 0)
			qdel(implant)
		break

/datum/component/advert_force_speak/proc/speaker_implant_say(mob/living/source, message, sponsor, spans)
	if(speaker_implant == null)
		speaker_implant = new()
		speaker_implant.loc = source
		speaker_implant.owner = source
		speaker_implant.bubble_icon = "machine"

	speaker_implant.body_maptext_height_offset = source.body_maptext_height_offset
	speaker_implant.say(message, language=/datum/language/common, forced="sponsored ([sponsor])", spans=spans)

/mob/living/speaker_implant
	name = "speaker implant"
	var/mob/living/owner

/mob/living/speaker_implant/GetVoice()
	if(owner == src)
		return ""
	return owner.GetVoice()

/mob/living/speaker_implant/get_alt_name()
	return "'s Implant"

/mob/living/speaker_implant/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null, message_range = 7, datum/saymode/saymode = null)
	. = ..()
	if(.)
		var/ending = copytext_char(message, -1)
		var/sound/speak_sound
		if(ending == "?")
			speak_sound = voice_type2sound[voice_type]["?"]
		else if(ending == "!")
			speak_sound = voice_type2sound[voice_type]["!"]
		else
			speak_sound = voice_type2sound[voice_type][voice_type]
		playsound(src, speak_sound, 300, 1, SHORT_RANGE_SOUND_EXTRARANGE-2, falloff_exponent = 0, pressure_affected = FALSE, ignore_walls = FALSE, use_reverb = FALSE, mixer_channel = CHANNEL_MOB_SOUNDS)

GLOBAL_DATUM_INIT(advertisements, /datum/advertisements, new)

/datum/advertisements
	var/list/nt_ads
	var/list/syndi_ads

/datum/advertisements/New()
	nt_ads = load_file("monkestation/strings/advertisements.txt")
	syndi_ads = load_file("monkestation/strings/advertisements_syndi.txt")

/datum/advertisements/proc/load_file(file_name)
	var/list/advertisements = list()
	var/list/lines = world.file2list(file_name)
	var/name = "Unknown"
	for (var/line in lines)
		if (length(line) == 0)
			continue
		if (line[1] == "-")
			continue
		if (line[1] == "\t")
			var/delimiter_idx = findtext(line, ":", 2)
			if (delimiter_idx == 0)
				stack_trace("No delimiter")
				continue
			var/key = copytext(line, 2, delimiter_idx)
			var/value = trim(copytext(line, delimiter_idx+1))
			if (key == "name")
				name = value
				continue
			if (key == "desc")
				continue
			stack_trace("Unknown key TODO TODOa")
			continue
		advertisements.Add(name)
		advertisements.Add(trim(line))
	return advertisements
