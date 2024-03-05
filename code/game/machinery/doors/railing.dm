/obj/machinery/door/blast/railing
	name = "\improper retractable railing"
	icon = 'icons/obj/doors/railing.dmi'
	icon_state = "railing1"
	use_power = 0
	atom_flags = ATOM_FLAG_CHECKS_BORDER
	opacity = FALSE
	open_layer = CATWALK_LAYER
	closed_layer = SIDE_WINDOW_LAYER

	var/datum/shuttle/autodock/ferry/supply/linked_pad

/obj/machinery/door/blast/railing/opened
	icon_state = "railing0"
	density = FALSE


/obj/machinery/door/blast/railing/Initialize()
	. = ..()
	if(dir == SOUTH)
		closed_layer = ABOVE_HUMAN_LAYER
	layer = closed_layer
	var/static/list/connections = list(
		COMSIG_ATOM_EXIT = .proc/on_try_exit
	)
	AddElement(/datum/element/connect_loc, connections)

/obj/machinery/door/blast/railing/Destroy()
	if(linked_pad)
		linked_pad.railings -= src
		linked_pad = null
	return ..()

/obj/machinery/door/blast/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!istype(mover) || mover.checkpass(PASS_FLAG_TABLE))
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/machinery/door/blast/railing/proc/on_try_exit(datum/source, atom/movable/mover, direction, list/moveblockers)
	SIGNAL_HANDLER
	if(!density || !(atom_flags & ATOM_FLAG_CHECKS_BORDER) || !(direction & dir))
		return NONE
	if(mover.throwing)
		return NONE
	moveblockers += src
	return ATOM_FLAG_CHECKS_BORDER

/obj/machinery/door/blast/railing/open()
	if(!SSticker || operating || !density)
		return FALSE

	operating = TRUE
	flick("railingc0", src)
	icon_state = "railing0"
	layer = open_layer

	addtimer(CALLBACK(src, .proc/do_open), 12)
	return TRUE


/obj/machinery/door/blast/railing/update_icon()
	if(density)
		icon_state = "railing1"
	else
		icon_state = "railing0"

/obj/machinery/door/blast/railing/proc/do_open()
	density = FALSE
	operating = FALSE

/obj/machinery/door/blast/railing/close()
	if (!SSticker || operating || density)
		return FALSE

	density = TRUE
	operating = TRUE
	layer = closed_layer
	flick("railingc1", src)
	icon_state = "railing1"

	addtimer(CALLBACK(src, .proc/do_close), 12)
	return TRUE

/obj/machinery/door/blast/railing/proc/do_close()
	operating = FALSE
