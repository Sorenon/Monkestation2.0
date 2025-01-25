/obj/item/clothing/head/helmet
	var/has_sec_hud = FALSE

/obj/item/clothing/head/helmet/equipped(mob/living/carbon/human/user, slot)
	..()
	if(!has_sec_hud)
		return
	if(!(slot & ITEM_SLOT_HEAD))
		return
	var/datum/atom_hud/our_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	our_hud.show_to(user)
	ADD_TRAIT(user, TRAIT_SECURITY_HUD, HELMET_TRAIT)

/obj/item/clothing/head/helmet/dropped(mob/living/carbon/human/user)
	..()
	if(!has_sec_hud)
		return
	if(!istype(user) || user.head != src)
		return
	var/datum/atom_hud/our_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	our_hud.hide_from(user)
	REMOVE_TRAIT(user, TRAIT_SECURITY_HUD, HELMET_TRAIT)

/obj/item/clothing/head/helmet/sec
	has_sec_hud = TRUE

/obj/item/clothing/head/helmet/alt
	has_sec_hud = TRUE

/obj/item/clothing/head/helmet/space/hardsuit/sec
	has_sec_hud = TRUE

/obj/item/clothing/head/helmet/examine(mob/user)
	. = ..()
	if(has_sec_hud)
		. += "[src] has a built-in security hud."
