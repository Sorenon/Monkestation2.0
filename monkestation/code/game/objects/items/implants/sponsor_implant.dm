/obj/item/implant/sponsor
	name = "sponsor implant"
	desc = "Protects against brainwashing."
	actions_types = null

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

/// Kit

/obj/item/implanter/sponsor
	name = "implanter (sponsor)"
	imp_type = /obj/item/implant/sponsor

/obj/item/implantcase/sponsor
	name = "implant case - 'Sponsor'"
	desc = "A glass case containing a sponsor implant."
	imp_type = /obj/item/implant/sponsor

/obj/item/storage/lockbox/sponsor
	name = "lockbox of sponsor implants"
	req_access = list(ACCESS_COMMAND)

/obj/item/storage/lockbox/sponsor/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/implantcase/sponsor(src)
	new /obj/item/implanter/sponsor(src)

// Traitor Varient

/obj/item/implant/sponsor_emagged
	name = "hacked sponsor implant"
	desc = "modified to tap into the syndicate propaganda network, limited number of uses unless paired victim already has NT implant"
	actions_types = null
	implant_color = "r"
	uses = 7

/obj/item/implant/sponsor_emagged/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!.)
		return FALSE
	target.AddComponentFrom(src, /datum/component/advert_force_speak)
	ADD_TRAIT(target, TRAIT_SPONSOR_IMPLANT_SYNDI, REF(src))
	return TRUE

/obj/item/implant/sponsor_emagged/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(!.)
		return FALSE
	target.AddComponentFrom(src, /datum/component/advert_force_speak)
	REMOVE_TRAIT(target, TRAIT_SPONSOR_IMPLANT_SYNDI, REF(src))
	return TRUE

/// Kit

/obj/item/implanter/sponsor_emagged
	name = "implanter (hacked sponsor)"
	imp_type = /obj/item/implant/sponsor_emagged

/obj/item/implantcase/sponsor_emagged
	name = "implant case - 'hacked Sponsor'"
	desc = "A glass case containing a hacked sponsor implant."
	imp_type = /obj/item/implant/sponsor_emagged

/obj/item/storage/box/syndie_kit/sponsor
	name = "hacked sponsor implants"

/obj/item/storage/box/syndie_kit/sponsor/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/implantcase/sponsor_emagged(src)
	new /obj/item/implanter/sponsor_emagged(src)
