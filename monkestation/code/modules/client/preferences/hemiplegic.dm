/datum/preference/toggle/limb_missing/hemiplegic
	savefile_key = "hemiplegic_limbs_missing"
	quirk_name = "Hemiplegic"

// ###############

/datum/preference/choiced/hemiplegic_side
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hemiplegic_side"

/datum/preference/choiced/hemiplegic_side/create_default_value()
	return "Random"

/datum/preference/choiced/hemiplegic_side/init_possible_values()
	return list("Random", "Left", "Right")

/datum/preference/choiced/hemiplegic_side/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Hemiplegic" in preferences.all_quirks

/datum/preference/choiced/hemiplegic_side/apply_to_human(mob/living/carbon/human/target, value)
	return
