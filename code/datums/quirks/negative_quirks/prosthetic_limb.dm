/datum/quirk/prosthetic_limb
	name = "Prosthetic Limb"
	desc = "An accident caused you to lose one of your limbs. Because of this, you now have a surplus prosthetic!"
	icon = "tg-prosthetic-leg"
	value = -3
	hardcore_value = 3
	quirk_flags = QUIRK_HUMAN_ONLY | QUIRK_CHANGES_APPEARANCE | QUIRK_DONT_CLONE // monkestation edit: QUIRK_DONT_CLONE
	mail_goodies = list(/obj/item/weldingtool/mini, /obj/item/stack/cable_coil/five)
	/// The slot to replace, in string form
	var/slot_string = "limb"
	/// the original limb from before the prosthetic was applied
	var/obj/item/bodypart/old_limb
	var/limb_type
	var/severity

/datum/quirk/prosthetic_limb/add_unique(client/client_source)
	limb_type = GLOB.limb_choice[client_source?.prefs?.read_preference(/datum/preference/choiced/prosthetic)]
	severity = client_source?.prefs?.read_preference(/datum/preference/choiced/prosthetic_severity)
	if(isnull(limb_type))  //Client gone or they chose a random prosthetic
		limb_type = GLOB.limb_choice[pick(GLOB.limb_choice)]
	if(!(severity in GLOB.prothetic_severity))
		severity = pick(GLOB.prothetic_severity)

	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/bodypart/surplus = new limb_type()
	if(severity == "Missing")
		old_limb = human_holder.get_bodypart(surplus.body_zone)
		if(!isnull(old_limb))
			old_limb.drop_limb(painless=TRUE)
			old_limb.moveToNullspace()
	if(severity == "Paralysed")
		var/trauma_type = new /datum/brain_trauma/severe/paralysis/quirk(surplus.body_zone)
		human_holder.gain_trauma(trauma_type, TRAUMA_RESILIENCE_ABSOLUTE)
	if(severity == "Cheap Prothetic")
		slot_string = "[surplus.plaintext_zone]"
		medical_record_text = "Patient uses a low-budget prosthetic on the [slot_string]."
		old_limb = human_holder.return_and_replace_bodypart(surplus, special = TRUE)

/datum/quirk/prosthetic_limb/post_add()
	to_chat(quirk_holder, span_boldannounce("Your [slot_string] has been replaced with a surplus prosthetic. It is fragile and will easily come apart under duress. Additionally, \
	you need to use a welding tool and cables to repair it, instead of sutures and regenerative meshes."))

/datum/quirk/prosthetic_limb/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/severe/paralysis/quirk, TRAUMA_RESILIENCE_ABSOLUTE)
	if(old_limb)
		human_holder.del_and_replace_bodypart(old_limb, special = TRUE)
		old_limb = null

/datum/brain_trauma/severe/paralysis/quirk
	random_gain = FALSE
