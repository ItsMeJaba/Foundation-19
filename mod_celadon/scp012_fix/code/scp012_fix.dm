// Перегрузка базового метода scp012
// Возможно изменение параметров стана в дальнейшем.
/obj/item/paper/scp012/memetic_effect(mob/living/carbon/human/H)

	var/obj/item/paper/scp012/A = locate(/obj/item/paper/scp012/) in GLOB.SCP_list // Находим объект
	if (!A) // Уходим, если объекта нет O.O
		return
	if(!H || H.stat == UNCONSCIOUS || H.blinded || !H.can_see(A)) //Unconscious individuals cant keep hurting themselves
		return

	if(get_dist(H, src) > 1)
		step_to(H, src)
		H.Stun(2)
	else if(((world.time - effect_cooldown_counter) > effect_cooldown) || abs((world.time - effect_cooldown_counter) - effect_cooldown) < 0.1 SECONDS) //Last part is so that this can run for all affected humans without worrying about cooldown
		H.Stun(60)
		if(prob(60) && H.getBruteLoss())
			H.visible_message(SPAN_WARNING("[H] smears [H.p_their()] blood on \"[name]\", writing musical notes..."))
		else if(prob(50))
			H.visible_message(SPAN_DANGER("[H] rips into [H.p_their()] own flesh and covers [H.p_their()] hands in blood!"))
			H.emote("scream")
			H.apply_damage(25, BRUTE, prob(50) ? BP_L_ARM : BP_R_ARM)
			H.drip(50)
		else if(prob(30))
			if(prob(50))
				H.visible_message(SPAN_NOTICE("[H] looks at the \"[name]\" and sighs dejectedly."))
				playsound(H, "sounds/voice/emotes/sigh_[gender2text(H.gender)].ogg", 100)
			else
				H.visible_message(SPAN_NOTICE("[H] looks at the \"[name]\" and cries."))
				playsound(H, "sounds/voice/emotes/[gender2text(H.gender)]_cry[pick(list("1","2"))].ogg", 100)
		effect_cooldown_counter = world.time
