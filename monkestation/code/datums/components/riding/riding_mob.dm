/datum/component/riding/creature/human/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = NONE, potion_boost = FALSE)
	. = ..()
	if (HAS_TRAIT(human_parent, TRAIT_FEEBLE))
		human_parent.Paralyze(1 SECONDS)
		human_parent.Knockdown(4 SECONDS)
		human_parent.emote("scream", intentional=FALSE)
		human_parent.adjustBruteLoss(15)
		human_parent.visible_message(span_danger("The weight of [riding_mob] is too much for [human_parent]!"), \
				span_userdanger("The weight of [riding_mob] is too much. You are crushed beneath [riding_mob.p_them()]!"))
