/datum/shuttle/autodock/ferry/supply
	var/away_location = 1	//the location to hide at while pretending to be in-transit
	var/late_chance = 30
	var/max_late_time = (30 SECONDS)
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	category = /datum/shuttle/autodock/ferry/supply
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	knockdown = 0
	var/list/obj/machinery/gear/gears = list()
	var/list/obj/machinery/door/blast/railings = list()

/datum/shuttle/autodock/ferry/supply/short_jump(area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if (at_station() && forbidden_atoms_check())
			//cancel the launch because of forbidden atoms. announce over supply channel?
			moving_status = SHUTTLE_IDLE
			return

		if (!at_station())	//at centcom
			SSsupply.buy()

		//We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
		var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(away_location)
		moving_status = SHUTTLE_INTRANSIT

		//If we are at the away_landmark then we are just pretending to move, otherwise actually do the move
		if (next_location == away_waypoint)
			attempt_move(away_waypoint)

		//wait ETA here.
		arrive_time = world.time + SSsupply.movetime
		while (world.time <= arrive_time)
			sleep(5)

		if (next_location != away_waypoint)
			//late
			if (prob(late_chance))
				sleep(rand(0,max_late_time))

			attempt_move(destination)

		moving_status = SHUTTLE_IDLE

		if (!at_station())	//at centcom
			SSsupply.sell()

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/autodock/ferry/supply/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send forbidden atoms on the supply shuttle from centcom we don't care

	for(var/area/A in shuttle_area)
		if(SSsupply.forbidden_atoms_check(A))
			return 1

/datum/shuttle/autodock/ferry/supply/proc/at_station()
	return (!location)

//returns 1 if the shuttle is idle and we can still mess with the cargo shopping list
/datum/shuttle/autodock/ferry/supply/proc/idle()
	return (moving_status == SHUTTLE_IDLE)

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/supply/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/600,1))

/datum/shuttle/autodock/ferry/supply/proc/eta_seconds()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/10,1))

/datum/shuttle/autodock/ferry/supply/shuttle_moved()
	. = ..()
	if(current_location.landmark_tag == motherdock)
		for(var/j in railings)
			var/obj/machinery/door/blast/R = j
			R.open()

/datum/shuttle/autodock/ferry/supply/attempt_move()
	.=..()
	if(current_location.landmark_tag == motherdock)
		for(var/j in railings)
			var/obj/machinery/door/blast/R = j
			R.close()
		for(var/i in gears)
			var/obj/machinery/gear/G = i
			G.start_moving(NORTH)
	else
		for(var/i in gears)
			var/obj/machinery/gear/G = i
			G.start_moving(SOUTH)

/datum/shuttle/autodock/ferry/supply/New()
	. = ..()
	for(var/obj/machinery/gear/G in GLOB.machines)
		if(G.id == "supply_elevator_gear")
			gears += G
			RegisterSignal(G, COMSIG_PARENT_QDELETING, .proc/clean_gear)
	for(var/obj/machinery/door/blast/railing/R in GLOB.machines)
		if(R.id_tag == "supply_elevator_railing")
			railings += R
			RegisterSignal(R, COMSIG_PARENT_QDELETING, .proc/clean_railing)
			R.linked_pad = src
			R.open()

///Signal handler when a gear is destroyed
/datum/shuttle/autodock/ferry/supply/proc/clean_gear(datum/source)
	SIGNAL_HANDLER
	gears -= source

///Signal handler when a railing is destroyed
/datum/shuttle/autodock/ferry/supply/proc/clean_railing(datum/source)
	SIGNAL_HANDLER
	railings -= source
