/datum/quirk/monoplegic
	name = "Monoplegic"
	desc = "One of your limbs doesn't work. Nothing will ever fix this."
	icon = FA_ICON_HANDSHAKE_SIMPLE_SLASH
	value = QUIRK_COST_MONOPLEGIC
	hardcore_value = QUIRK_HARDCORE_MONOPLEGIC
	quirk_flags = QUIRK_HUMAN_ONLY | QUIRK_CHANGES_APPEARANCE

/datum/quirk/monoplegic/add_unique(client/client_source)
	var/body_zone = GLOB.limb_choice[client_source?.prefs?.read_preference(/datum/preference/choiced/limb/paralysed)]
	if(isnull(body_zone))  //Client gone or they chose a random limb
		body_zone = GLOB.limb_choice[pick(GLOB.limb_choice)]

	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(new /datum/brain_trauma/severe/paralysis/limb(body_zone), TRAUMA_RESILIENCE_ABSOLUTE)

	if(client_source?.prefs?.read_preference(/datum/preference/toggle/limb_missing/paralysed))
		human_holder.remove_bodypart_painlessly(body_zone)

/datum/quirk/monoplegic/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/severe/paralysis/limb, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/brain_trauma/severe/paralysis/limb
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_ABSOLUTE
