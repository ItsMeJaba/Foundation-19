/obj/random/scp
	name = "random object's for scp map"
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"

// Light contaiment zone random objects for lazy mapper's and munchkins

/obj/random/scp/wall
	name = "wall-type random objects"
	desc = "Random objects for plasing on wall. Place on the floor"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "scp_loot_wall"
	spawn_nothing_percentage = 50
	var/list/wall_objects = list(
		/obj/machinery/vending/wallmed/light,
		/obj/structure/closet/wall/hydrant)

/obj/random/scp/storage
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "scp_loot_storage"
	var/list/lootplace //variable for list of places where loot spawned
	var/list/spawner_at_plase // variable frot list of spawners or objects for spawning

/obj/random/scp/storage/lcz // random objects for small storage room's
	name = "Random objects for little rooms"
	desc = "Random objects for side-rooms"

	lootplace = list(/obj/structure/filingcabinet/chestdrawer,
				/obj/structure/table,
				/obj/structure/table/rack,
				/obj/structure/closet/crate,
				/obj/structure/closet,
				/obj/random/trash)
	spawner_at_plase = list(/obj/random/toolbox,
				/obj/random/powercell,
				/obj/random/tool,
				/obj/random/tech_supply,
				/obj/random/firstaid,
				/obj/random/material,
				/obj/random/soap,
				/obj/random/advdevice,
				/obj/random/storage)

/obj/random/scp/lcz/papper // random information about scp's in that zone
	name = "wall-type random objects"
	desc = "Random objects for plasing on wall. Place on the floor"
	icon = 'icons/effects/landmarks.dmi'
//	icon_state = "scp_papper"

/obj/random/scp/wall/spawn_choices()
	return list(wall_objects)

/obj/random/scp/storage/Initialize()
	..()
	var/placeofloot = pick(lootplace) // variable for choising of plasment
	new placeofloot(src)
	if(placeofloot == /obj/structure/filingcabinet/chestdrawer || /obj/random/trash)
		return
	else
		var/lootatplace = pick(spawner_at_plase) // variable for choising loot
		new lootatplace(src)
