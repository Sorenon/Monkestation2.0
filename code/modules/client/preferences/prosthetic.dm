/datum/preference/choiced/prosthetic
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "prosthetic"
	savefile_identifier = PREFERENCE_CHARACTER


/datum/preference/choiced/prosthetic/create_default_value()
	return "Random"

/datum/preference/choiced/prosthetic/init_possible_values()
	return list("Random") + GLOB.limb_choice

/datum/preference/choiced/prosthetic/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Prosthetic Limb" in preferences.all_quirks

/datum/preference/choiced/prosthetic/apply_to_human(mob/living/carbon/human/target, value)
	return

// ####################

/datum/preference/choiced/prosthetic_severity
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "prosthetic_severity"
	savefile_identifier = PREFERENCE_CHARACTER


/datum/preference/choiced/prosthetic_severity/create_default_value()
	return "Random"

/datum/preference/choiced/prosthetic_severity/init_possible_values()
	return list("Random") + GLOB.prothetic_severity

/datum/preference/choiced/prosthetic_severity/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Prosthetic Limb" in preferences.all_quirks

/datum/preference/choiced/prosthetic_severity/apply_to_human(mob/living/carbon/human/target, value)
	return
