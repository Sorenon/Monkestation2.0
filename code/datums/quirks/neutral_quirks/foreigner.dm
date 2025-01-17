/datum/quirk/foreigner
	name = "Foreigner"
	desc = "You're not from around here. You don't know Galactic Common!"
	icon = FA_ICON_LANGUAGE
	value = -2 //Monkestation change 0->-2
	gain_text = span_notice("The words being spoken around you don't make any sense.")
	lose_text = span_notice("You've developed fluency in Galactic Common.")
	medical_record_text = "Patient does not speak Galactic Common and may require an interpreter."
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/foreigner/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.grant_language(/datum/language/uncommon, understood = TRUE, spoken = TRUE, source = LANGUAGE_QUIRK)

/datum/quirk/foreigner/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.remove_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.remove_language(/datum/language/uncommon)

// ###############

/datum/quirk/foreigner2
	name = "Foreigner2 no species lang"
	desc = "You're not 22 2222 here. You don't know Galactic Common!"
	icon = FA_ICON_LANGUAGE
	value = -2 //Monkestation change 0->-2
	gain_text = span_notice("The words being spoken around you don't make any sense.")
	lose_text = span_notice("You've developed fluency in Galactic Common.")
	medical_record_text = "Patient does not speak Galactic Common and may require an interpreter."
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/foreigner2/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/old = human_holder.language_holder
	human_holder.language_holder = new human_holder.language_holder.type(human_holder)
	qdel(old)
	human_holder.update_atom_languages()


/datum/quirk/foreigner2/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/old = human_holder.language_holder
	human_holder.language_holder = new human_holder.language_holder.type(human_holder)
	qdel(old)
	human_holder.update_atom_languages()

/datum/quirk/foreigner3
	name = "Foreigner3 no speak common"
	desc = "You're not 22 2222 here. You don't know Galactic Common!"
	icon = FA_ICON_LANGUAGE
	value = -2 //Monkestation change 0->-2
	gain_text = span_notice("The words being spoken around you don't make any sense.")
	lose_text = span_notice("You've developed fluency in Galactic Common.")
	medical_record_text = "Patient does not speak Galactic Common and may require an interpreter."
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/foreigner3/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/old = human_holder.language_holder
	human_holder.language_holder = new human_holder.language_holder.type(human_holder)
	qdel(old)
	human_holder.update_atom_languages()

/datum/quirk/foreigner3/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/old = human_holder.language_holder
	human_holder.language_holder = new human_holder.language_holder.type(human_holder)
	qdel(old)
	human_holder.update_atom_languages()
