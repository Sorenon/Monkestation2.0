/datum/brain_trauma/mild/advert_force_speak
	name = "Advertisement Echophrasia"
	desc = "Patient repeats catchy phrases they heard on the TV or something."
	scan_desc = "advertisement echophrasia"
	gain_text = span_warning("You feel suseptibly to consumerist slogans.")
	lose_text = span_notice("You no longer feel the neeed to repeate shit you heard in ads.")

/datum/brain_trauma/mild/advert_force_speak/on_gain()
	src.owner.AddComponentFrom(REF(src), /datum/component/advert_force_speak)
	return ..()

/datum/brain_trauma/mild/advert_force_speak/on_lose(silent)
	src.owner.RemoveComponentSource(REF(src), /datum/component/advert_force_speak)
	return ..()
