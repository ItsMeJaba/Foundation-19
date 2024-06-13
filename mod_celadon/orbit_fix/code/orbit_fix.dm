// Перегрузка метода, убираем мусор и лаги
/obj/screen/ghost/orbit/Click()
	var/mob/observer/ghost/G = usr
	var/list/A = list()
	for(var/mob/B in GLOB.living_mob_list_)
		if(B.client) // Только активные мобы
			A += B
	for(var/mob/C in GLOB.SCP_list)
		A += C // Только играбельные SCP
	A += GLOB.player_list // Госты и прочие
	var/mob/fh = tgui_input_list(G, "Choose a player to orbit", "Orbit", A)
	if(istype(fh))
		G.follow(fh)
	else
		var/turf/T = get_turf(fh)
		G.ghost_to_turf(T)
