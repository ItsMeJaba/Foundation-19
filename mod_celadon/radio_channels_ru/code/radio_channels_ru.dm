// Перегрузка метода
/mob/parse_message_mode(message, standard_mode="headset")
	if(length(message) >= 1 && copytext(message,1,2) == get_prefix_key(/decl/prefix/radio_main_channel))
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext_char(message, 1 ,3) // Меняем, чтобы парсить.
		return department_radio_keys[channel_prefix]

	return null


// code\modules\mob\living\say.dm - изменения в каналах


// Очень жирный метод из кор кода:
// Перегрузка
/mob/living/say(message, datum/language/speaking = null, verb="says", alt_name="", whispering)
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (Muted)."))
			return

	if(stat)
		if(stat == 2)
			return say_dead(message)
		return

	var/prefix = copytext(message,1,2)
	if(prefix == get_prefix_key(/decl/prefix/custom_emote))
		return emote(copytext(message,2))
	if(prefix == get_prefix_key(/decl/prefix/visible_emote))
		return custom_emote(1, copytext(message,2))

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
		if(speaking)
			message = copytext(message,2+length(speaking.key))
		else
			speaking = get_default_language()

	//parse the radio code and consume it
	var/message_mode = parse_message_mode(message, "headset")

	// [CELADON-EDIT]
	if (message_mode)
		if (message_mode == "headset")
			message = copytext_char(message,2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext_char(message,3) // Замена copytext на copytext_char

	message = trim_left(message)
	// [/CELADON-EDIT]

	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(speaking && (speaking.flags & HIVEMIND))
		speaking.broadcast(src,trim(message))
		return 1

	if((is_muzzled()) && !(speaking && (speaking.flags & SIGNLANG)))
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
		return

	if (speaking)
		if(whispering)
			verb = speaking.whisper_verb ? speaking.whisper_verb : speaking.speech_verb
		else
			verb = say_quote(message, speaking)

	message = trim_left(message)
	message = handle_autohiss(message, speaking)
	message = format_say_message(message)
	message = process_chat_markup(message)

	if(speaking && !speaking.can_be_spoken_properly_by(src))
		message = speaking.muddle(message)

	if(!(speaking && (speaking.flags & NO_STUTTER)))
		var/list/message_data = list(message, verb, 0)
		if(handle_speech_problems(message_data))
			message = message_data[1]
			verb = message_data[2]

	if(!message || message == "")
		return 0

	var/list/obj/item/used_radios = new
	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name))
		return 1

	var/list/handle_v = handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2]

	var/italics = 0
	var/message_range = world.view

	if(whispering)
		italics = 1
		message_range = 1

	//speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		if(!speaking || !(speaking.flags & NO_TALK_MSG))
			src.visible_message(SPAN_NOTICE("\The [src] talks into \the [used_radios[1]]."), blind_message = SPAN_NOTICE("You hear someone talk into their headset."), range = 5, exclude_mobs = list(src))
			if (speech_sound)
				sound_vol *= 0.5

	var/list/listening = list()
	var/list/listening_obj = list()
	var/turf/T = get_turf(src)

	//handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & NONVERBAL)
			if (prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & SIGNLANG)
			log_say("[name]/[key] : SIGN: [message]")
			return say_signlang(message, pick(speaking.signlang_verb), speaking)

	if(T)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		get_mobs_and_objs_in_view_fast(T, message_range, listening, listening_obj, /datum/client_preference/ghost_ears)


	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	speech_bubble.layer = layer
	speech_bubble.plane = plane
	speech_bubble.alpha = 0

	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M && M.can_hear(src))
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
			SEND_SIGNAL(M, COMSIG_MOB_HEARD_SPEECH, src, message)
			if(M.client)
				speech_bubble_recipients += M.client


	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	var/heard_message
	var/list/unique = list()
	if(whispering)
		var/eavesdroping_range = 5
		var/list/eavesdroping = list()
		var/list/eavesdroping_obj = list()
		get_mobs_and_objs_in_view_fast(T, eavesdroping_range, eavesdroping, eavesdroping_obj)
		eavesdroping -= listening
		eavesdroping_obj -= listening_obj
		for(var/mob/M in eavesdroping)
			if(M && M.can_hear(src))
				heard_message = M.hear_say(stars(message), verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
				SEND_SIGNAL(M, COMSIG_MOB_HEARD_WHISPER, src, heard_message)
				if(M.client)
					speech_bubble_recipients |= M.client
					unique[M.client] = heard_message

		for(var/obj/O in eavesdroping)
			spawn(0)
				if(O) //It's possible that it could be deleted in the meantime.
					O.hear_talk(src, stars(message), verb, speaking)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, animate_chat), message, speaking, italics, speech_bubble_recipients, whispering, unique)

	if(LAZYLEN(speech_bubble_recipients) && !whispering)
		show_sound_effect(src.loc, src, soundicon = SFX_ICON_SMALL)

	if(whispering)
		log_whisper("[name]/[key] : [message]")
	else
		log_say("[name]/[key] : [message]")

	flick_overlay(speech_bubble, speech_bubble_recipients, 50)
	animate(speech_bubble, alpha = 255, time = 10, easing = CIRCULAR_EASING)
	animate(time = 20)
	animate(alpha = 0, pixel_y = 12, time = 20, easing = CIRCULAR_EASING)

	return 1
