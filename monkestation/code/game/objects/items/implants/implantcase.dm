/obj/item/implantcase/emag_act(mob/user, obj/item/card/emag/emag_card)
	if (istype(imp, /obj/item/implant/sponsor))
		balloon_alert(user, "retuned for the Syndicate Propaganda Network")
		imp = new /obj/item/implant/syndi_propaganda(src)
		update_appearance()
		return TRUE
	else if (imp_type == /obj/item/implant/syndi_propaganda)
		balloon_alert(user, "retuned for the NT Advertisement Network")
		imp = new /obj/item/implant/sponsor(src)
		update_appearance()
		return TRUE

	return ..()
