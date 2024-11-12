/datum/brain_trauma/mild/advert_force_speak
	name = "Advertisement Echophrasia"
	desc = "Patient always feels healthy, regardless of their condition."
	scan_desc = "advertisement echophrasia"
	gain_text = span_notice("You feel great!")
	lose_text = span_warning("You no longer feel perfectly healthy.")

/datum/brain_trauma/mild/advert_force_speak/on_gain()
	src.owner.AddComponentFrom(REF(src), /datum/component/advert_force_speak)
	return ..()

/datum/brain_trauma/mild/advert_force_speak/on_lose(silent)
	src.owner.RemoveComponentSource(REF(src), /datum/component/advert_force_speak)
	return ..()
