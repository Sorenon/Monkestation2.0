/datum/quirk/corporate_sponsorship
	name = "Corporate Sponsorship"
	desc = "Become a living ad break with a neural connection directly from the NT Advertisement Network to your mouth or an implanted speaker. Each ad is roughly 5 mins apart and has a revenue of 5 whole credits!"
	value = -2
	icon = FA_ICON_MONEY_BILL

/datum/quirk/corporate_sponsorship1
	name = "Corporate Sponsorship1"
	desc = "Become a living adbreak with a neural connection directly from the NT Advertisement Network to your mouth or an implanted speaker. Each ad is roughly 5 mins apart and has a revenue of 5 whole credits!"
	value = -2
	icon = FA_ICON_MONEY_BILL

/datum/quirk/corporate_sponsorship2
	name = "Corporate Sponsorship2"
	desc = "Become a living ad-break with a neural connection directly from the NT Advertisement Network to your mouth or an implanted speaker. Each ad is roughly 5 mins apart and has a revenue of 5 whole credits!"
	value = -2
	icon = FA_ICON_MONEY_BILL

/datum/quirk/corporate_sponsorship/add()
	var/datum/brain_trauma/mild/advert_force_speak/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)
	var/obj/item/implant/sponsorship/implant = new()
	implant.implant(quirk_holder, quirk_holder, TRUE, TRUE)

/datum/quirk/corporate_sponsorship/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.cure_trauma_type(/datum/brain_trauma/mild/advert_force_speak, TRAUMA_RESILIENCE_ABSOLUTE)
