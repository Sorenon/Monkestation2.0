/obj/projectile/bullet/reusable/foam_dart
	name = "foam dart"
	desc = "I hope you're wearing eye protection."
	damage = 0 // It's a damn toy.
	damage_type = OXY
	icon = 'icons/obj/weapons/guns/toy.dmi'
	icon_state = "foamdart_proj"
	base_icon_state = "foamdart_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	range = 10
	var/modified = FALSE
	var/obj/item/pen/pen = null

/obj/projectile/bullet/reusable/foam_dart/handle_drop()
	if(dropped)
		return
	var/turf/T = get_turf(src)
	dropped = 1
	var/obj/item/ammo_casing/caseless/foam_dart/newcasing = new ammo_type(T)
	newcasing.modified = modified
	var/obj/projectile/bullet/reusable/foam_dart/newdart = newcasing.loaded_projectile
	newdart.modified = modified
	newdart.damage_type = damage_type
	if(pen)
		newdart.pen = pen
		pen.forceMove(newdart)
		pen = null
		newdart.damage = 5
	newdart.update_appearance()


/obj/projectile/bullet/reusable/foam_dart/Destroy()
	pen = null
	return ..()

/obj/projectile/bullet/reusable/foam_dart/riot
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	base_icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot
	stamina = 25

/obj/projectile/bullet/reusable/foam_dart/on_hit(atom/target, blocked = 0, pierce_hit)
	var/dropped = src.dropped
	src.dropped = TRUE
	. = ..()
	src.dropped = dropped
	if (. != BULLET_ACT_HIT || blocked != 0 || (def_zone != BODY_ZONE_PRECISE_MOUTH && def_zone != BODY_ZONE_HEAD) || !iscarbon(target))
		handle_drop()
		return
	var/mob/living/carbon/C = target
	if(!C.has_mouth() || C.is_mouth_covered(ITEM_SLOT_HEAD) || C.is_mouth_covered(ITEM_SLOT_MASK) || C.has_status_effect(/datum/status_effect/choke))
		handle_drop()
		return
	if(prob(def_zone == BODY_ZONE_PRECISE_MOUTH ? 15 : 5) || HAS_TRAIT(target, TRAIT_CURSED))
		var/item = new ammo_type
		visible_message(span_danger("[src] inhales [item]!"), \
			span_userdanger("You inhale [item]!"))
		target.AddComponent(/datum/status_effect/choke, item, flaming = FALSE, vomit_delay = 10 SECONDS)
