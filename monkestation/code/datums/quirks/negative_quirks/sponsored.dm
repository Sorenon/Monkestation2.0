/datum/quirk/sponsor
	name = "Corporate Sponsor"
	desc = "Hooked up to the NT Advertisement service. Could be to pay off a debt, for easy money or part of a coorporate rehabilitation programme."
	value = -2
	icon = FA_ICON_MONEY_BILL

/datum/quirk/sponsor/add()
	var/datum/brain_trauma/mild/advert_force_speak/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)
	var/obj/item/implant/sponsor/implant = new()
	implant.implant(quirk_holder, quirk_holder, TRUE, TRUE)

/datum/quirk/sponsor/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.cure_trauma_type(/datum/brain_trauma/mild/advert_force_speak, TRAUMA_RESILIENCE_ABSOLUTE)
