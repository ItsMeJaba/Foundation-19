/decl/environment_data
	var/list/important_gasses = list(
		GAS_OXYGEN =         TRUE,
		GAS_NITROGEN =       TRUE,
		GAS_CO2 = TRUE
	)
	var/list/dangerous_gasses = list(
		GAS_CO2 = TRUE
	)
	var/list/filter_gasses = list(
		GAS_OXYGEN,
		GAS_NITROGEN,
		GAS_CO2,
		GAS_N2O,
		GAS_PHORON
	)

////////////////////////////////////////
//CONTAINS: Air Alarms and Fire Alarms//
////////////////////////////////////////

#define AALARM_MODE_SCRUBBING	1
#define AALARM_MODE_REPLACEMENT	2 //like scrubbing, but faster.
#define AALARM_MODE_PANIC		3 //constantly sucks all air
#define AALARM_MODE_CYCLE		4 //sucks off all air, then refill and switches to scrubbing
#define AALARM_MODE_FILL		5 //emergency fill
#define AALARM_MODE_OFF			6 //Shuts it all down.

#define AALARM_SCREEN_MAIN		1
#define AALARM_SCREEN_VENT		2
#define AALARM_SCREEN_SCRUB		3
#define AALARM_SCREEN_MODE		4
#define AALARM_SCREEN_SENSORS	5

#define AALARM_REPORT_TIMEOUT 100

#define RCON_NO		1
#define RCON_AUTO	2
#define RCON_YES	3

#define MAX_TEMPERATURE 90
#define MIN_TEMPERATURE -40

//all air alarms in area are connected via magic
/area
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/obj/machinery/alarm
	name = "alarm"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm0"
	anchored = TRUE
	idle_power_usage = 80
	active_power_usage = 1000 //For heating/cooling rooms. 1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
	power_channel = ENVIRON
	req_access = list(list(ACCESS_SECURITY_LVL1, ACCESS_ATMOSPHERICS, ACCESS_ENGINEERING_LVL2)) //ACCESS_SECURITY_LVL1 added since mapper air alarms have it configured.
	clicksound = SFX_MACHINE_BUTTON
	clickvol = 30

	layer = ABOVE_WINDOW_LAYER

	var/alarm_id = null
	var/breach_pressure = ONE_ATMOSPHERE * 0.5 //Pressure below wich vents are shut off, set negative to dissable
	var/breach_cooldown = FALSE
	var/frequency = 1439
	//var/skipprocess = 0 //Experimenting
	var/alarm_frequency = 1437
	var/remote_control = 0
	var/rcon_setting = 2
	var/rcon_time = 0
	var/locked = 1
	var/wiresexposed = FALSE // If it's been screwdrivered open.
	var/aidisabled = 0
	var/shorted = 0

	wires = /datum/wires/alarm

	var/mode = AALARM_MODE_SCRUBBING
	var/screen = AALARM_SCREEN_MAIN
	var/area_uid
	var/area/alarm_area
	var/buildstage = 2 //2 is built, 1 is building, 0 is frame.

	var/target_temperature = T0C+20
	var/regulating_temperature = 0

	var/datum/radio_frequency/radio_connection

	var/list/TLV = list()
	var/list/trace_gas = list() //list of other gases that this air alarm is able to detect

	var/danger_level = 0
	var/pressure_dangerlevel = 0
	var/oxygen_dangerlevel = 0
	var/co2_dangerlevel = 0
	var/temperature_dangerlevel = 0
	var/other_dangerlevel = 0
	var/environment_type = /decl/environment_data
	var/report_danger_level = 1

/obj/machinery/alarm/cold
	target_temperature = T0C+4

/decl/environment_data/finnish/Initialize()
	. = ..()
	important_gasses[GAS_STEAM] = TRUE
	dangerous_gasses -= GAS_STEAM

/obj/machinery/alarm/warm
	target_temperature = T0C+75
	environment_type = /decl/environment_data/finnish

/obj/machinery/alarm/warm/Initialize()
	. = ..()
	TLV["temperature"] = list(T0C-26, T0C, T0C+75, T0C+85) // K
	TLV["pressure"] = list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.30,ONE_ATMOSPHERE*1.50) /* kpa */

/obj/machinery/alarm/nobreach
	breach_pressure = -1

/obj/machinery/alarm/monitor
	report_danger_level = 0
	breach_pressure = -1

/obj/machinery/alarm/server/New()
	..()
	req_access = list(ACCESS_RD, ACCESS_ATMOSPHERICS, ACCESS_ENGINEERING_LVL2)
	TLV["temperature"] =	list(T0C-26, T0C, T0C+30, T0C+40) // K
	target_temperature = T0C+10

/obj/machinery/alarm/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/alarm/New(loc, dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir(dir)

	if(istype(frame))
		buildstage = 0
		wiresexposed = TRUE
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -21 : 21)
		pixel_y = (dir & 3)? (dir ==1 ? -21 : 21) : 0
		update_icon()
		frame.transfer_fingerprints_to(src)

/obj/machinery/alarm/Initialize()
	. = ..()
	alarm_area = get_area(src)
	area_uid = alarm_area.uid
	if (name == "alarm")
		SetName("[alarm_area.name] Air Alarm")

	// breathable air according to human/Life()
	TLV[GAS_OXYGEN] =			list(16, 19, 135, 140) // Partial pressure, kpa
	TLV[GAS_CO2] = list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["pressure"] =		list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20) /* kpa */
	TLV["temperature"] =	list(T0C-26, T0C, T0C+40, T0C+66) // K


	var/decl/environment_data/env_info = decls_repository.get_decl(environment_type)
	for(var/g in gas_data.gases)
		if(!env_info.important_gasses[g])
			trace_gas += g

	set_frequency(frequency)
	update_icon()

/obj/machinery/alarm/get_req_access()
	if(!locked)
		return list()
	return ..()

/obj/machinery/alarm/Process()
	if((stat & (NOPOWER|BROKEN)) || shorted || buildstage != 2)
		return

	var/turf/simulated/location = loc
	if(!istype(location))	return//returns if loc is not simulated

	var/datum/gas_mixture/environment = location.return_air()

	//Handle temperature adjustment here.
	if(environment.return_pressure() > ONE_ATMOSPHERE*0.05)
		handle_heating_cooling(environment)

	var/old_level = danger_level
	danger_level = overall_danger_level(environment)

	if (old_level != danger_level)
		if(danger_level == 2)
			playsound(src.loc, 'sounds/machines/airalarm.ogg', 25, 0, 4)
		apply_danger_level(danger_level)

	if (pressure_dangerlevel != 0)
		if (breach_detected())
			mode = AALARM_MODE_OFF
			apply_mode()

	if (mode==AALARM_MODE_CYCLE && environment.return_pressure()<ONE_ATMOSPHERE*0.05)
		breach_start_cooldown()
		mode=AALARM_MODE_FILL
		apply_mode()

	//atmos computer remote controll stuff
	switch(rcon_setting)
		if(RCON_NO)
			remote_control = 0
		if(RCON_AUTO)
			if(danger_level == 2)
				remote_control = 1
			else
				remote_control = 0
		if(RCON_YES)
			remote_control = 1

	return

/obj/machinery/alarm/proc/handle_heating_cooling(datum/gas_mixture/environment)
	if (!regulating_temperature)
		//check for when we should start adjusting temperature
		if(!get_danger_level(target_temperature, TLV["temperature"]) && abs(environment.temperature - target_temperature) > 2.0)
			update_use_power(POWER_USE_ACTIVE)
			regulating_temperature = 1
			visible_message("\The [src] clicks as it starts [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click and a faint electronic hum.")
	else
		//check for when we should stop adjusting temperature
		if (get_danger_level(target_temperature, TLV["temperature"]) || abs(environment.temperature - target_temperature) <= 0.5)
			update_use_power(POWER_USE_IDLE)
			regulating_temperature = 0
			visible_message("\The [src] clicks quietly as it stops [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click as a faint electronic humming stops.")

	if (regulating_temperature)
		if(target_temperature > T0C + MAX_TEMPERATURE)
			target_temperature = T0C + MAX_TEMPERATURE

		if(target_temperature < T0C + MIN_TEMPERATURE)
			target_temperature = T0C + MIN_TEMPERATURE

		var/datum/gas_mixture/gas
		gas = environment.remove(0.25*environment.total_moles)
		if(gas)

			if (gas.temperature <= target_temperature)	//gas heating
				var/energy_used = min( gas.get_thermal_energy_change(target_temperature) , active_power_usage)

				gas.add_thermal_energy(energy_used)
			else	//gas cooling
				var/heat_transfer = min(abs(gas.get_thermal_energy_change(target_temperature)), active_power_usage)

				//Assume the heat is being pumped into the hull which is fixed at 20 C
				//none of this is really proper thermodynamics but whatever

				var/cop = gas.temperature/T20C	//coefficient of performance -> power used = heat_transfer/cop

				heat_transfer = min(heat_transfer, cop * active_power_usage)	//this ensures that we don't use more than active_power_usage amount of power

				heat_transfer = -gas.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

			environment.merge(gas)

/obj/machinery/alarm/proc/overall_danger_level(datum/gas_mixture/environment)
	var/partial_pressure = R_IDEAL_GAS_EQUATION*environment.temperature/environment.volume
	var/environment_pressure = environment.return_pressure()

	var/other_moles = 0
	for(var/g in trace_gas)
		other_moles += environment.gas[g] //this is only going to be used in a partial pressure calc, so we don't need to worry about group_multiplier here.

	pressure_dangerlevel = get_danger_level(environment_pressure, TLV["pressure"])
	oxygen_dangerlevel = get_danger_level(environment.gas[GAS_OXYGEN]*partial_pressure, TLV[GAS_OXYGEN])
	co2_dangerlevel = get_danger_level(environment.gas[GAS_CO2]*partial_pressure, TLV[GAS_CO2])
	temperature_dangerlevel = get_danger_level(environment.temperature, TLV["temperature"])
	other_dangerlevel = get_danger_level(other_moles*partial_pressure, TLV["other"])

	return max(
		pressure_dangerlevel,
		oxygen_dangerlevel,
		co2_dangerlevel,
		other_dangerlevel,
		temperature_dangerlevel
		)

// Returns whether this air alarm thinks there is a breach, given the sensors that are available to it.
/obj/machinery/alarm/proc/breach_detected()
	var/turf/simulated/location = loc

	if(!istype(location))
		return FALSE

	if(breach_cooldown)
		return FALSE

	if(breach_pressure < 0)
		return FALSE

	var/datum/gas_mixture/environment = location.return_air()
	var/environment_pressure = environment.return_pressure()

	if (environment_pressure <= breach_pressure)
		if (!(mode == AALARM_MODE_PANIC || mode == AALARM_MODE_CYCLE))
			return TRUE

	return FALSE

/obj/machinery/alarm/proc/breach_end_cooldown()
	breach_cooldown = FALSE
	return

//disables breach detection temporarily
/obj/machinery/alarm/proc/breach_start_cooldown()
	breach_cooldown = TRUE
	addtimer(CALLBACK(src,/obj/machinery/alarm/proc/breach_end_cooldown), 10 MINUTES, TIMER_UNIQUE | TIMER_OVERRIDE)
	return

/obj/machinery/alarm/proc/get_danger_level(current_value, list/danger_levels)
	if((current_value >= danger_levels[4] && danger_levels[4] > 0) || current_value <= danger_levels[1])
		return 2
	if((current_value > danger_levels[3] && danger_levels[3] > 0) || current_value < danger_levels[2])
		return 1
	return 0

/obj/machinery/alarm/on_update_icon()
	if(wiresexposed)
		icon_state = "alarmx"
		set_light(0)
		return
	if((stat & (NOPOWER|BROKEN)) || shorted)
		icon_state = "alarmp"
		set_light(0)
		return

	var/icon_level = danger_level
	if (alarm_area.atmosalm)
		icon_level = max(icon_level, 1)	//if there's an atmos alarm but everything is okay locally, no need to go past yellow

	var/new_color = null
	switch(icon_level)
		if (0)
			icon_state = "alarm0"
			new_color = COLOR_LIME
		if (1)
			icon_state = "alarm2" //yes, alarm2 is yellow alarm
			new_color = COLOR_SUN
		if (2)
			icon_state = "alarm1"
			new_color = COLOR_RED_LIGHT

	pixel_x = 0
	pixel_y = 0
	var/turf/T = get_step(get_turf(src), turn(dir, 180))
	if(istype(T) && T.density)
		if(dir == NORTH)
			pixel_y = -21
		else if(dir == SOUTH)
			pixel_y = 21
		else if(dir == WEST)
			pixel_x = 21
		else if(dir == EAST)
			pixel_x = -21

	set_light(0.25, 0.1, 1, 2, new_color)

/obj/machinery/alarm/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption)
		return
	if(alarm_id == signal.data["alarm_id"] && signal.data["command"] == "shutdown")
		mode = AALARM_MODE_OFF
		report_danger_level = FALSE
		apply_mode()
		return

	var/id_tag = signal.data["tag"]
	if (!id_tag)
		return
	if (signal.data["area"] != area_uid)
		return

	var/dev_type = signal.data["device"]
	if(!(id_tag in alarm_area.air_scrub_names) && !(id_tag in alarm_area.air_vent_names))
		register_env_machine(id_tag, dev_type)
	if(dev_type == "AScr")
		alarm_area.air_scrub_info[id_tag] = signal.data
	else if(dev_type == "AVP")
		alarm_area.air_vent_info[id_tag] = signal.data

/obj/machinery/alarm/proc/register_env_machine(m_id, device_type)
	var/new_name
	if (device_type=="AVP")
		new_name = "[alarm_area.name] Vent Pump #[alarm_area.air_vent_names.len+1]"
		alarm_area.air_vent_names[m_id] = new_name
	else if (device_type=="AScr")
		new_name = "[alarm_area.name] Air Scrubber #[alarm_area.air_scrub_names.len+1]"
		alarm_area.air_scrub_names[m_id] = new_name
	send_signal(m_id, list("init" = new_name) )

/obj/machinery/alarm/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_TO_AIRALARM)

/obj/machinery/alarm/proc/send_signal(target, list/command)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = command
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"
	signal.data["status"] = TRUE

	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)
//			log_debug(text("Signal [] Broadcasted to []", command, target))

	return 1

/obj/machinery/alarm/proc/apply_mode()
	//propagate mode to other air alarms in the area
	//TODO: make it so that players can choose between applying the new mode to the room they are in (related area) vs the entire alarm area
	for (var/obj/machinery/alarm/AA in alarm_area)
		AA.mode = mode

	breach_start_cooldown()

	switch(mode)
		if(AALARM_MODE_SCRUBBING)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("set_power"= 1, "set_scrub_gas" = list(GAS_CO2 = 1), "set_scrubbing"= SCRUBBER_SCRUB, "panic_siphon"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("set_power"= 1, "set_checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_PANIC, AALARM_MODE_CYCLE)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("set_power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("set_power"= 0) )

		if(AALARM_MODE_REPLACEMENT)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("set_power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("set_power"= 1, "set_checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_FILL)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("set_power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("set_power"= 1, "set_checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_OFF)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("set_power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("set_power"= 0) )

/obj/machinery/alarm/proc/apply_danger_level(new_danger_level)
	if (report_danger_level && alarm_area.atmosalert(new_danger_level, src))
		post_alert(new_danger_level)

	update_icon()

/obj/machinery/alarm/proc/post_alert(alert_level)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(alarm_frequency)
	if(!frequency)
		return

	var/datum/signal/alert_signal = new
	alert_signal.source = src
	alert_signal.transmission_method = 1
	alert_signal.data["zone"] = alarm_area.name
	alert_signal.data["type"] = "Atmospheric"

	if(alert_level==2)
		alert_signal.data["alert"] = "severe"
	else if (alert_level==1)
		alert_signal.data["alert"] = "minor"
	else if (alert_level==0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal)

/obj/machinery/alarm/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/alarm/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, master_ui = null, datum/topic_state/state = GLOB.default_state)
	var/data[0]
	var/remote_connection = 0
	var/remote_access = 0
	if(state)
		var/list/href = state.href_list(user)
		remote_connection = href["remote_connection"]	// Remote connection means we're non-adjacent/connecting from another computer
		remote_access = href["remote_access"]			// Remote access means we also have the privilege to alter the air alarm.

	data["locked"] = locked && !issilicon(user)
	data["remote_connection"] = remote_connection
	data["remote_access"] = remote_access
	data["rcon"] = rcon_setting
	data["screen"] = screen

	populate_status(data)

	if(!(locked && !remote_connection) || remote_access || issilicon(user))
		populate_controls(data)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "air_alarm.tmpl", src.name, 325, 625, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/alarm/proc/populate_status(data)
	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	var/total = environment.total_moles

	var/list/environment_data = new
	data["has_environment"] = total
	if(total)
		var/pressure = environment.return_pressure()
		environment_data[++environment_data.len] = list("name" = "Pressure", "value" = pressure, "unit" = "kPa", "danger_level" = pressure_dangerlevel)
		var/decl/environment_data/env_info = decls_repository.get_decl(environment_type)
		for(var/gas_id in env_info.important_gasses)
			environment_data[++environment_data.len] = list(
				"name" =  gas_data.name[gas_id],
				"value" = environment.gas[gas_id] / total * 100,
				"unit" = "%",
				"danger_level" = env_info.dangerous_gasses[gas_id] ? co2_dangerlevel : oxygen_dangerlevel
			)
		var/other_moles = 0
		for(var/g in trace_gas)
			other_moles += environment.gas[g]
		environment_data[++environment_data.len] = list("name" = "Other Gases", "value" = other_moles / total * 100, "unit" = "%", "danger_level" = other_dangerlevel)

		environment_data[++environment_data.len] = list("name" = "Temperature", "value" = environment.temperature, "unit" = "K ([round(environment.temperature - T0C, 0.1)]C)", "danger_level" = temperature_dangerlevel)
	data["total_danger"] = danger_level
	data["environment"] = environment_data
	data["atmos_alarm"] = alarm_area.atmosalm
	data["fire_alarm"] = alarm_area.fire != null
	data["target_temperature"] = "[target_temperature - T0C]C"

/obj/machinery/alarm/proc/populate_controls(list/data)
	switch(screen)
		if(AALARM_SCREEN_MAIN)
			data["mode"] = mode
		if(AALARM_SCREEN_VENT)
			var/vents[0]
			for(var/id_tag in alarm_area.air_vent_names)
				var/long_name = alarm_area.air_vent_names[id_tag]
				var/list/info = alarm_area.air_vent_info[id_tag]
				if(!info)
					continue
				vents[++vents.len] = list(
						"id_tag"	= id_tag,
						"long_name" = sanitize(long_name),
						"power"		= info["power"],
						"checks"	= info["checks"],
						"direction"	= info["direction"],
						"external"	= info["external"]
					)
			data["vents"] = vents
		if(AALARM_SCREEN_SCRUB)
			var/scrubbers[0]
			for(var/id_tag in alarm_area.air_scrub_names)
				var/long_name = alarm_area.air_scrub_names[id_tag]
				var/list/info = alarm_area.air_scrub_info[id_tag]
				if(!info)
					continue
				scrubbers[++scrubbers.len] = list(
						"id_tag"	= id_tag,
						"long_name" = sanitize(long_name),
						"power"		= info["power"],
						"scrubbing"	= info["scrubbing"],
						"panic"		= info["panic"],
						"filters"	= list()
					)
				var/decl/environment_data/env_info = decls_repository.get_decl(environment_type)
				for(var/gas_id in env_info.filter_gasses)
					scrubbers[scrubbers.len]["filters"] += list(
						list(
							"name" = gas_data.name[gas_id],
							"id"   = gas_id,
							"val"  = (gas_id in info["scrubbing_gas"])
						)
					)

			data["scrubbers"] = scrubbers
		if(AALARM_SCREEN_MODE)
			var/modes[0]
			modes[++modes.len] = list("name" = "Filtering - Scrubs out contaminants", 			"mode" = AALARM_MODE_SCRUBBING,		"selected" = mode == AALARM_MODE_SCRUBBING, 	"danger" = 0)
			modes[++modes.len] = list("name" = "Replace Air - Siphons out air while replacing", "mode" = AALARM_MODE_REPLACEMENT,	"selected" = mode == AALARM_MODE_REPLACEMENT,	"danger" = 0)
			modes[++modes.len] = list("name" = "Panic - Siphons air out of the room", 			"mode" = AALARM_MODE_PANIC,			"selected" = mode == AALARM_MODE_PANIC, 		"danger" = 1)
			modes[++modes.len] = list("name" = "Cycle - Siphons air before replacing", 			"mode" = AALARM_MODE_CYCLE,			"selected" = mode == AALARM_MODE_CYCLE, 		"danger" = 1)
			modes[++modes.len] = list("name" = "Fill - Shuts off scrubbers and opens vents", 	"mode" = AALARM_MODE_FILL,			"selected" = mode == AALARM_MODE_FILL, 			"danger" = 0)
			modes[++modes.len] = list("name" = "Off - Shuts off vents and scrubbers", 			"mode" = AALARM_MODE_OFF,			"selected" = mode == AALARM_MODE_OFF, 			"danger" = 0)
			data["modes"] = modes
			data["mode"] = mode
		if(AALARM_SCREEN_SENSORS)
			var/list/selected
			var/thresholds[0]

			var/breach_data = list("selected" = breach_pressure)
			data["breach_data"] = breach_data

			var/list/gas_names = list(
				GAS_OXYGEN         = "O<sub>2</sub>",
				GAS_CO2 = "CO<sub>2</sub>",
				"other"          = "Other")
			for (var/g in gas_names)
				thresholds[++thresholds.len] = list("name" = gas_names[g], "settings" = list())
				selected = TLV[g]
				for(var/i = 1, i <= 4, i++)
					thresholds[thresholds.len]["settings"] += list(list("env" = g, "val" = i, "selected" = selected[i]))

			selected = TLV["pressure"]
			thresholds[++thresholds.len] = list("name" = "Pressure", "settings" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = i, "selected" = selected[i]))

			selected = TLV["temperature"]
			thresholds[++thresholds.len] = list("name" = "Temperature", "settings" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = i, "selected" = selected[i]))


			data["thresholds"] = thresholds

/obj/machinery/alarm/CanUseTopic(mob/user, datum/topic_state/state, href_list = list())
	if(buildstage != 2)
		return STATUS_CLOSE

	if(aidisabled && isAI(user))
		to_chat(user, SPAN_WARNING("AI control for \the [src] interface has been disabled."))
		return STATUS_CLOSE

	. = shorted ? STATUS_DISABLED : STATUS_INTERACTIVE

	if(. == STATUS_INTERACTIVE)
		var/extra_href = state.href_list(user)
		// Prevent remote users from altering RCON settings unless they already have access
		if(href_list["rcon"] && extra_href["remote_connection"] && !extra_href["remote_access"])
			. = STATUS_UPDATE

	return min(..(), .)

/obj/machinery/alarm/OnTopic(user, href_list, datum/topic_state/state)
	// hrefs that can always be called -walter0o
	if(href_list["rcon"])
		var/attempted_rcon_setting = text2num(href_list["rcon"])

		switch(attempted_rcon_setting)
			if(RCON_NO)
				rcon_setting = RCON_NO
			if(RCON_AUTO)
				rcon_setting = RCON_AUTO
			if(RCON_YES)
				rcon_setting = RCON_YES
		return TOPIC_REFRESH

	if(href_list["temperature"])
		var/list/selected = TLV["temperature"]
		var/max_temperature = min(selected[3] - T0C, MAX_TEMPERATURE)
		var/min_temperature = max(selected[2] - T0C, MIN_TEMPERATURE)
		var/input_temperature = input(user, "What temperature would you like the system to maintain? (Capped between [min_temperature] and [max_temperature]C)", "Thermostat Controls", target_temperature - T0C) as num|null
		if(isnum(input_temperature) && CanUseTopic(user, state))
			if(input_temperature > max_temperature || input_temperature < min_temperature)
				to_chat(user, "Temperature must be between [min_temperature]C and [max_temperature]C")
			else
				target_temperature = input_temperature + T0C
		return TOPIC_REFRESH

	// hrefs that need the AA unlocked -walter0o
	var/extra_href = state.href_list(user)
	if(!(locked && !extra_href["remote_connection"]) || extra_href["remote_access"] || issilicon(user))
		if(href_list["command"])
			var/device_id = href_list["id_tag"]
			switch(href_list["command"])
				if("set_external_pressure")
					var/input_pressure = input(user, "What pressure you like the system to mantain?", "Pressure Controls") as num|null
					if(isnum(input_pressure) && CanUseTopic(user, state))
						send_signal(device_id, list(href_list["command"] = input_pressure))
					return TOPIC_REFRESH

				if("reset_external_pressure")
					send_signal(device_id, list(href_list["command"] = ONE_ATMOSPHERE))
					return TOPIC_REFRESH

				if( "set_power",
					"set_checks",
					"panic_siphon")

					send_signal(device_id, list(href_list["command"] = text2num(href_list["val"]) ) )
					return TOPIC_REFRESH

				if("set_scrubbing")
					send_signal(device_id, list(href_list["command"] = href_list["scrub_mode"]) )
					return TOPIC_REFRESH

				if("set_scrub_gas")
					var/decl/environment_data/env_info = decls_repository.get_decl(environment_type)
					if(env_info && (href_list["gas_id"] in env_info.filter_gasses))
						send_signal(device_id, list(href_list["command"] = list(href_list["gas_id"] = text2num(href_list["val"]))) )
					return TOPIC_REFRESH

				if("set_breach")
					var/newval = input(user, "Enter minimum pressure for breach detection, preasures lower then this will cause vents to stop.", breach_pressure) as null|num
					if (isnull(newval) || !CanUseTopic(user, state))
						return TOPIC_HANDLED
					if (newval<0)
						breach_pressure = -1.0
					else if (newval > 50*ONE_ATMOSPHERE)
						breach_pressure = 50*ONE_ATMOSPHERE
					else
						breach_pressure = round(newval,0.01)

				if("set_threshold")
					var/env = href_list["env"]
					var/threshold = text2num(href_list["var"])
					var/list/selected = TLV[env]
					var/list/thresholds = list("lower bound", "low warning", "high warning", "upper bound")
					var/newval = input(user, "Enter [thresholds[threshold]] for [env]", "Alarm triggers", selected[threshold]) as null|num
					if (isnull(newval) || !CanUseTopic(user, state))
						return TOPIC_HANDLED
					if (newval<0)
						selected[threshold] = -1.0
					else if (env=="temperature" && newval>5000)
						selected[threshold] = 5000
					else if (env=="pressure" && newval>50*ONE_ATMOSPHERE)
						selected[threshold] = 50*ONE_ATMOSPHERE
					else if (env!="temperature" && env!="pressure" && newval>200)
						selected[threshold] = 200
					else
						newval = round(newval,0.01)
						selected[threshold] = newval
					if(threshold == 1)
						if(selected[1] > selected[2])
							selected[2] = selected[1]
						if(selected[1] > selected[3])
							selected[3] = selected[1]
						if(selected[1] > selected[4])
							selected[4] = selected[1]
					if(threshold == 2)
						if(selected[1] > selected[2])
							selected[1] = selected[2]
						if(selected[2] > selected[3])
							selected[3] = selected[2]
						if(selected[2] > selected[4])
							selected[4] = selected[2]
					if(threshold == 3)
						if(selected[1] > selected[3])
							selected[1] = selected[3]
						if(selected[2] > selected[3])
							selected[2] = selected[3]
						if(selected[3] > selected[4])
							selected[4] = selected[3]
					if(threshold == 4)
						if(selected[1] > selected[4])
							selected[1] = selected[4]
						if(selected[2] > selected[4])
							selected[2] = selected[4]
						if(selected[3] > selected[4])
							selected[3] = selected[4]

					apply_mode()
					return TOPIC_REFRESH

		if(href_list["screen"])
			screen = text2num(href_list["screen"])
			return TOPIC_REFRESH

		if(href_list["atmos_unlock"])
			switch(href_list["atmos_unlock"])
				if("0")
					alarm_area.air_doors_close()
				if("1")
					alarm_area.air_doors_open()
			return TOPIC_REFRESH

		if(href_list["atmos_alarm"])
			if (alarm_area.atmosalert(2, src))
				apply_danger_level(2)
			update_icon()
			return TOPIC_REFRESH

		if(href_list["atmos_reset"])
			if (alarm_area.atmosalert(0, src))
				apply_danger_level(0)
			update_icon()
			return TOPIC_REFRESH

		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			apply_mode()
			return TOPIC_REFRESH

/obj/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
	switch(buildstage)
		if(2)
			if(isScrewdriver(W))  // Opening that Air Alarm up.
//				to_chat(user, "You pop the Air Alarm's maintence panel open.")
				wiresexposed = !wiresexposed
				to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
				update_icon()
				return

			if (wiresexposed && isWirecutter(W))
				user.visible_message(SPAN_WARNING("[user] has cut the wires inside \the [src]!"), "You have cut the wires inside \the [src].")
				playsound(src.loc, 'sounds/items/Wirecutter.ogg', 50, 1)
				new/obj/item/stack/cable_coil(get_turf(src), 5)
				buildstage = 1
				update_icon()
				return

			if (istype(W, /obj/item/card/id) || istype(W, /obj/item/modular_computer))// trying to unlock the interface with an ID card
				if(stat & (NOPOWER|BROKEN))
					to_chat(user, "It does nothing")
					return
				else
					if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
						locked = !locked
						to_chat(user, SPAN_NOTICE("You [ locked ? "lock" : "unlock"] the Air Alarm interface."))
					else
						to_chat(user, SPAN_WARNING("Access denied."))
			return

		if(1)
			if(isCoil(W))
				var/obj/item/stack/cable_coil/C = W
				if (C.use(5))
					to_chat(user, SPAN_NOTICE("You wire \the [src]."))
					buildstage = 2
					update_icon()
					return
				else
					to_chat(user, SPAN_WARNING("You need 5 pieces of cable to do wire \the [src]."))
					return

			else if(isCrowbar(W))
				to_chat(user, "You start prying out the circuit.")
				playsound(src.loc, 'sounds/items/Crowbar.ogg', 50, 1)
				if(do_after(user, 2.5 SECONDS, bonus_percentage = 25) && buildstage == 1)
					to_chat(user, "You pry out the circuit!")
					var/obj/item/airalarm_electronics/circuit = new /obj/item/airalarm_electronics()
					circuit.dropInto(user.loc)
					buildstage = 0
					update_icon()
				return
		if(0)
			if(istype(W, /obj/item/airalarm_electronics))
				to_chat(user, "You insert the circuit!")
				qdel(W)
				buildstage = 1
				update_icon()
				return

			else if(isWrench(W))
				to_chat(user, "You remove the fire alarm assembly from the wall!")
				new /obj/item/frame/air_alarm(get_turf(user))
				playsound(src.loc, 'sounds/items/Ratchet.ogg', 50, 1)
				qdel(src)

	return ..()

/obj/machinery/alarm/examine(mob/user)
	. = ..()
	if (buildstage < 2)
		to_chat(user, "It is not wired.")
	if (buildstage < 1)
		to_chat(user, "The circuit is missing.")
/*
AIR ALARM CIRCUIT
Just a object used in constructing air alarms
*/
/obj/item/airalarm_electronics
	name = "air alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/*
FIRE ALARM
*/
/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/firealarm.dmi'
	icon_state = "casing"
	var/detecting = 1.0
	anchored = TRUE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON
	var/wiresexposed = FALSE
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone
	var/global/list/overlays_cache

/obj/machinery/firealarm/examine(mob/user)
	. = ..()
	if(loc.z in GLOB.using_map.contact_levels)
		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		to_chat(user, "The current alert level is [security_state.current_security_level.name].")

/obj/machinery/firealarm/Initialize()
	. = ..()
	queue_icon_update()

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	RegisterSignal(security_state, COMSIG_SECURITY_LEVEL_CHANGED, /atom/proc/update_icon)

/obj/machinery/firealarm/proc/get_cached_overlay(state)
	if(!LAZYACCESS(overlays_cache, state))
		LAZYSET(overlays_cache, state, image(icon, state))
	return overlays_cache[state]

/obj/machinery/firealarm/on_update_icon()
	cut_overlays()

	pixel_x = 0
	pixel_y = 0
	var/walldir = (dir & (NORTH|SOUTH)) ? GLOB.reverse_dir[dir] : dir
	var/turf/T = get_step(get_turf(src), walldir)
	if(istype(T) && T.density)
		if(dir == SOUTH)
			pixel_y = 21
		else if(dir == NORTH)
			pixel_y = -21
		else if(dir == EAST)
			pixel_x = 21
		else if(dir == WEST)
			pixel_x = -21

	icon_state = "casing"
	if(wiresexposed)
		add_overlay(get_cached_overlay("b[buildstage]"))
		set_light(0)
		return

	if(stat & BROKEN)
		add_overlay(get_cached_overlay("broken"))
		set_light(0)
	else if(stat & NOPOWER)
		add_overlay(get_cached_overlay("unpowered"))
		set_light(0)
	else
		if(!detecting)
			add_overlay(get_cached_overlay("fire1"))
			set_light(0.25, 0.1, 1, 2, COLOR_RED)
		else if(z in GLOB.using_map.contact_levels)
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			var/decl/security_level/sl = security_state.current_security_level

			set_light(sl.light_max_bright, sl.light_inner_range, sl.light_outer_range, 2, sl.light_color_alarm)
			add_overlay(image(sl.icon, sl.overlay_alarm))
		else
			add_overlay(get_cached_overlay("fire0"))

/obj/machinery/firealarm/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(src.detecting)
		if(exposed_temperature > T0C+200)
			src.alarm()			// added check of detector status here
	return

/obj/machinery/firealarm/bullet_act()
	return src.alarm()

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50/severity))
		alarm(rand(30/severity, 60/severity))
	..()

/obj/machinery/firealarm/attackby(obj/item/W as obj, mob/user as mob)
	if(isScrewdriver(W) && buildstage == 2)
		wiresexposed = !wiresexposed
		update_icon()
		return

	if(wiresexposed)
		switch(buildstage)
			if(2)
				if(isMultitool(W))
					src.detecting = !( src.detecting )
					if (src.detecting)
						user.visible_message(SPAN_NOTICE("\The [user] has reconnected [src]'s detecting unit!"), SPAN_NOTICE("You have reconnected [src]'s detecting unit."))
					else
						user.visible_message(SPAN_NOTICE("\The [user] has disconnected [src]'s detecting unit!"), SPAN_NOTICE("You have disconnected [src]'s detecting unit."))
				else if(isWirecutter(W))
					user.visible_message(SPAN_NOTICE("\The [user] has cut the wires inside \the [src]!"), SPAN_NOTICE("You have cut the wires inside \the [src]."))
					new/obj/item/stack/cable_coil(get_turf(src), 5)
					playsound(src.loc, 'sounds/items/Wirecutter.ogg', 50, 1)
					buildstage = 1
					update_icon()
			if(1)
				if(istype(W, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/C = W
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("You wire \the [src]."))
						buildstage = 2
						update_icon()
						return
					else
						to_chat(user, SPAN_WARNING("You need 5 pieces of cable to wire \the [src]."))
						return
				else if(isCrowbar(W))
					to_chat(user, "You start prying out the circuit.")
					playsound(src.loc, 'sounds/items/Crowbar.ogg', 50, 1)
					if (do_after(user, 2.5 SECONDS, bonus_percentage = 25))
						to_chat(user, "You pry out the circuit!")
						var/obj/item/firealarm_electronics/circuit = new /obj/item/firealarm_electronics()
						circuit.dropInto(user.loc)
						buildstage = 0
						update_icon()
			if(0)
				if(istype(W, /obj/item/firealarm_electronics))
					to_chat(user, "You insert the circuit!")
					qdel(W)
					buildstage = 1
					update_icon()

				else if(isWrench(W))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					new /obj/item/frame/fire_alarm(get_turf(user))
					playsound(src.loc, 'sounds/items/Ratchet.ogg', 50, 1)
					qdel(src)
		return

	src.alarm()
	return

/obj/machinery/firealarm/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/firealarm/interact(mob/user)
	user.set_machine(src)
	var/area/A = src.loc.loc
	var/dat
	var/d1

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if (istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon))
		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>Reset - Lockdown</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>Alarm - Lockdown</A>", src)
		dat = "<HTML><HEAD></HEAD><BODY><TT><B>Fire alarm</B> [d1]\n<HR>The current alert level is <b>[security_state.current_security_level.name]</b>\n</TT></BODY></HTML>"
	else
		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("Reset - Lockdown"))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("Alarm - Lockdown"))
		dat = "<HTML><HEAD></HEAD><BODY><TT><B>[stars("Fire alarm")]</B> [d1]\n<HR>The current security level is <b>[security_state.current_security_level.name]</b>\n</TT></BODY></HTML>"

	var/datum/browser/popup = new(user, "firealarm", "Fire Alarm")
	popup.set_content(dat)
	popup.open()
	onclose(user, "firealarm")
	return

/obj/machinery/firealarm/CanUseTopic(user)
	if(buildstage != 2)
		return STATUS_CLOSE
	return ..()

/obj/machinery/firealarm/OnTopic(user, href_list)
	if (href_list["reset"])
		src.reset()
		. = TOPIC_REFRESH
	else if (href_list["alarm"])
		src.alarm()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/machinery/firealarm/proc/reset()
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		GLOB.fire_alarm.clearAlarm(loc, FA)
	update_icon()
	return

/obj/machinery/firealarm/proc/alarm(duration = 0)
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		GLOB.fire_alarm.triggerAlarm(loc, FA, duration)
	update_icon()
	playsound(src, 'sounds/machines/fire_alarm.ogg', 75, 0)
	return

/obj/machinery/firealarm/New(loc, dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir((dir & (NORTH|SOUTH)) ? dir : GLOB.reverse_dir[dir])

	if(istype(frame))
		buildstage = 0
		wiresexposed = TRUE
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -21 : 21)
		pixel_y = (dir & 3)? (dir == 1 ? -21 : 21) : 0
		update_icon()
		frame.transfer_fingerprints_to(src)

/obj/machinery/firealarm/Initialize()
	. = ..()
	if(z in GLOB.using_map.contact_levels)
		update_icon()

/*
FIRE ALARM CIRCUIT
Just a object used in constructing fire alarms
*/
/obj/item/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\"."
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
