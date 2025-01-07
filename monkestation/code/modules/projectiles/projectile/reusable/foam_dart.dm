/obj/projectile/bullet/reusable/foam_dart/handle_drop(cancel=TRUE)
	if(cancel)
		return
	if(!dropped)
		var/turf/T = get_turf(src)
		new ammo_type(T)
		dropped = TRUE

/obj/projectile/bullet/reusable/foam_dart/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if (. != BULLET_ACT_HIT || blocked != 0 || (def_zone != BODY_ZONE_PRECISE_MOUTH && def_zone != BODY_ZONE_HEAD) || !iscarbon(target))
		handle_drop(cancel=FALSE)
		return
	var/mob/living/carbon/C = target
	if(!C.has_mouth() || C.is_mouth_covered(ITEM_SLOT_HEAD) || C.is_mouth_covered(ITEM_SLOT_MASK) || C.has_status_effect(/datum/status_effect/choke))
		handle_drop(cancel=FALSE)
		return
	if(prob(def_zone == BODY_ZONE_PRECISE_MOUTH ? 15 : 5) || HAS_TRAIT(target, TRAIT_CURSED))
		var/item = new ammo_type
		visible_message(span_danger("[src] inhales [item]!"), \
			span_userdanger("You inhale [item]!"))
		target.AddComponent(/datum/status_effect/choke, item, flaming = FALSE, vomit_delay = 10 SECONDS)
