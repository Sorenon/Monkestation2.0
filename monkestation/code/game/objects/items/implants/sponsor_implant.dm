/obj/item/implant/sponsor
	name = "sponsorship implant"
	actions_types = null
	allow_multiple = TRUE

/obj/item/implant/sponsor/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!.)
		return FALSE
	target.AddComponentFrom(src, /datum/component/advert_force_speak)
	ADD_TRAIT(target, TRAIT_SPONSOR_IMPLANT, REF(src))
	return TRUE

/obj/item/implant/sponsor/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(!.)
		return FALSE
	target.RemoveComponentSource(src, /datum/component/advert_force_speak)
	REMOVE_TRAIT(target, TRAIT_SPONSOR_IMPLANT, REF(src))
	return TRUE

// Kit

/obj/item/implanter/sponsor
	name = "implanter (sponsorship)"
	desc = "Makes you say ads for a small reward. NT Advertisement service." // yup
	imp_type = /obj/item/implant/sponsor

/obj/item/implantcase/sponsor
	name = "implant case - 'Sponsorship'"
	desc = "A glass case containing a sponsor implant." // yup
	imp_type = /obj/item/implant/sponsor

/obj/item/storage/lockbox/sponsor
	name = "lockbox of sponsorship implants"
	desc = "A locked box. requires command access to open. contains sponsorship implants which Makes you say ads for a small reward. NT Advertisement service." // yup
	req_access = list(ACCESS_COMMAND)

/obj/item/storage/lockbox/sponsor/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/implantcase/sponsor(src)
	new /obj/item/implanter/sponsor(src)

// Traitor Varient

/obj/item/implant/syndi_propaganda
	name = "hacked sponsorship implant"
	actions_types = null
	implant_color = "r"
	allow_multiple = TRUE

/obj/item/implant/syndi_propaganda/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!.)
		return FALSE
	target.AddComponentFrom(src, /datum/component/advert_force_speak)
	ADD_TRAIT(target, TRAIT_SPONSOR_IMPLANT_SYNDI, REF(src))
	for (var/datum/component/propaganda_target/objective in target.GetComponents(/datum/component/propaganda_target))
		objective.implanted()
	return TRUE

/obj/item/implant/syndi_propaganda/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(!.)
		return FALSE
	target.AddComponentFrom(src, /datum/component/advert_force_speak)
	REMOVE_TRAIT(target, TRAIT_SPONSOR_IMPLANT_SYNDI, REF(src))
	return TRUE

// Traitor Kit

/obj/item/implantcase/syndi_propaganda
	name = "implant case - 'hacked sponsorship'"
	desc = "A glass case containing a hacked sponsor implant."
	imp_type = /obj/item/implant/syndi_propaganda

/obj/item/implanter/syndi_propaganda
	name = "implanter (mindshield)"
	desc = "modified to tap into the syndicate propaganda network"
	imp_type = /obj/item/implant/syndi_propaganda

/obj/item/storage/box/syndie_kit/syndi_propaganda
	name = "hacked sponsor implants"

/obj/item/storage/box/syndie_kit/syndi_propaganda/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/implantcase/syndi_propaganda(src)
	new /obj/item/implanter/syndi_propaganda(src)
