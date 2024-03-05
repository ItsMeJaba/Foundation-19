/obj/machinery/gear
	name = "\improper gear"
	icon_state = "gear"
	anchored = TRUE
	density = FALSE
	acid_resistance = 1
	use_power = 0
	var/id

/obj/machinery/gear/proc/start_moving(direction = NORTH)
	icon_state = "gear_moving"
	set_dir(direction)

/obj/machinery/gear/proc/stop_moving()
	icon_state = "gear"

/obj/machinery/elevator_strut
	name = "\improper strut"
	icon = 'icons/obj/elevator_strut.dmi'
	anchored = TRUE
	acid_resistance = 1
	density = FALSE
	use_power = 0
	opacity = TRUE
	layer = ABOVE_HUMAN_LAYER
	var/id

/obj/machinery/elevator_strut/top
	icon_state = "strut_top"

/obj/machinery/elevator_strut/bottom
	icon_state = "strut_bottom"
