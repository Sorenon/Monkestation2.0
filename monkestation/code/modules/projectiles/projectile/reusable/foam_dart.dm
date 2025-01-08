/obj/projectile/bullet/reusable/foam_dart/handle_drop(cancel=TRUE)
	if(cancel)
		return
	. = ..()

/obj/projectile/bullet/reusable/foam_dart/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	var/mob/living/carbon/ctarget = target
	if (. != BULLET_ACT_HIT || blocked != 0 || (def_zone != BODY_ZONE_PRECISE_MOUTH && def_zone != BODY_ZONE_HEAD) || !istype(ctarget))
		handle_drop(cancel=FALSE)
		return
	if(!ctarget.has_mouth() || ctarget.is_mouth_covered(ITEM_SLOT_HEAD) || ctarget.is_mouth_covered(ITEM_SLOT_MASK) || ctarget.has_status_effect(/datum/status_effect/choke))
		handle_drop(cancel=FALSE)
		return
	if(prob(def_zone == BODY_ZONE_PRECISE_MOUTH ? 15 : 5) || HAS_TRAIT(target, TRAIT_CURSED))
		var/item = new ammo_type
		visible_message(span_danger("[src] inhales [item]!"), \
			span_userdanger("You inhale [item]!"))
		target.AddComponent(/datum/status_effect/choke, item, flaming = FALSE, vomit_delay = 10 SECONDS)
