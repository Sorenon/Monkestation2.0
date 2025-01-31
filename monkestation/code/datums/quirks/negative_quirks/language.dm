
/datum/quirk/language_holder
	abstract_parent_type = /datum/quirk/language_holder

/datum/quirk/language_holder/proc/recreate_language_holder()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.language_holder = new human_holder.language_holder.type(human_holder)
	human_holder.update_atom_languages()

/datum/quirk/language_holder/add(client/client_source)
	recreate_language_holder()

/datum/quirk/language_holder/remove(client/client_source)
	recreate_language_holder()

/datum/quirk/language_holder/uncommon
	name = "Uncommon"
	desc = "You don't understand Galactic Common, instead having learned Galactic Uncommon."
	icon = FA_ICON_LANGUAGE
	value = -4
	gain_text = span_notice("The words being spoken around you don't make any sense.")
	lose_text = span_notice("You've developed fluency in Galactic Common.")
	medical_record_text = "Patient does not speak Galactic Common and may require an interpreter."
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/language_holder/outsider
	name = "Species Outsider"
	desc = "You don't weren't taught any of your species' languages."
	icon = FA_ICON_LANGUAGE
	value = -1
	gain_text = span_notice("You can't understand your species' languages.")
	lose_text = span_notice("You've remembered your species' languages.")
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/language_holder/listener
	name = "Listener"
	desc = "You are unable to speak Galactic Common (or Galactic Uncommon) though you understand it just fine."
	icon = FA_ICON_LANGUAGE
	value = -2
	gain_text = span_notice("You don't know how to speak Galactic Common.")
	lose_text = span_notice("You're able to speak Galactic Common.")
	medical_record_text = "Patient does not speak Galactic Common and may require an interpreter."
	mail_goodies = list(/obj/item/taperecorder) // for translation
