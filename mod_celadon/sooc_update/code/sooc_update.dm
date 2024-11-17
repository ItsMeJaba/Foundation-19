// Чат для SCP
/client/verb/scp_say(message as text)
	set category = "OOC"
	set name = "SCP say"
	if(src.mob in GLOB.SCP_list)
		for(var/mob/A in GLOB.SCP_list)
			if(A.client)
				to_chat(A, SPAN_DANGER("<B><strong>[src.mob]:</strong></B> <span class='message linkify'>[message]</span>"))
	else
		to_chat(src, SPAN_WARNING("You must be SCP!"))
		return
