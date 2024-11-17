#define TURF_DECAL_COLOR_HELPER(color_name, tile_color, tile_alpha)		\
	/obj/effect/floor_decal/corner/##color_name {		\
		icon_state = "corner_white";					\
		color = ##tile_color;							\
		alpha = ##tile_alpha;							\
	}													\
	/obj/effect/floor_decal/corner/##color_name/diagonal { \
		icon_state = "corner_white_diagonal";			\
	}													\
	/obj/effect/floor_decal/corner/##color_name/three_quarters { \
		icon_state = "corner_white_three_quarters";		\
	}													\
	/obj/effect/floor_decal/corner/##color_name/full {	\
		icon_state = "corner_white_full";				\
	}													\
	/obj/effect/floor_decal/corner/##color_name/border {	\
		icon_state = "bordercolor";						\
	}													\
	/obj/effect/floor_decal/corner/##color_name/half {	\
		icon_state = "bordercolorhalf";					\
	}													\
	/obj/effect/floor_decal/corner/##color_name/mono {	\
		icon_state = "bordercolormonofull";				\
	}													\
	/obj/effect/floor_decal/corner/##color_name/bordercorner { \
		icon_state = "bordercolorcorner";				\
	}													\
	/obj/effect/floor_decal/corner/##color_name/borderfull { \
		icon_state = "bordercolorfull";					\
	}													\
	/obj/effect/floor_decal/corner/##color_name/bordercee { \
		icon_state = "bordercolorcee";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name {		\
		color = ##tile_color;							\
		alpha = ##tile_alpha							\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/line { \
		icon_state = "trimline";						\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/corner { \
		icon_state = "trimline_corner";					\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/end {	\
		icon_state = "trimline_end";					\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/arrow_cw { \
		icon_state = "trimline_arrow_cw";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/arrow_ccw { \
		icon_state = "trimline_arrow_ccw";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/warning { \
		icon_state = "trimline_warn";					\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/warning { \
		icon_state = "trimline_warn";					\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled { \
		icon_state = "trimline_box_fill";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/line { \
		icon_state = "trimline_fill";					\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/corner { \
		icon_state = "trimline_corner_fill";			\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/end { \
		icon_state = "trimline_end_fill";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/arrow_cw { \
		icon_state = "trimline_arrow_cw_fill";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/arrow_ccw { \
		icon_state = "trimline_arrow_ccw_fill";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/warning { \
		icon_state = "trimline_warn_fill";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/shrink_cw { \
		icon_state = "trimline_shrink_cw";				\
	}													\
	/obj/effect/floor_decal/trimline/##color_name/filled/shrink_ccw { \
		icon_state = "trimline_shrink_ccw";				\
	}													\
	/obj/effect/floor_decal/spline/plain/##color_name {	\
		color = ##tile_color							\
	}													\
	/obj/effect/floor_decal/spline/fancy/##color_name {	\
		color = ##tile_color							\
	}													\
	/obj/effect/floor_decal/spline/fancy/##color_name/corner {	\
		icon_state = "spline_fancy_corner"				\
	}													\
	/obj/effect/floor_decal/road/line/##color_name {		\
		color = ##tile_color							\
	}													\
	/obj/effect/floor_decal/road/line/edge/##color_name {		\
		color = ##tile_color							\
	}

//opaque
TURF_DECAL_COLOR_HELPER(opaque/neutral, null, 255)
TURF_DECAL_COLOR_HELPER(opaque/black, COLOR_TILE_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/blue, COLOR_BLUE_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/green, COLOR_GREEN_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/lime, COLOR_PALE_GREEN_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/yellow, COLOR_BROWN, 255)
TURF_DECAL_COLOR_HELPER(opaque/beige, COLOR_BEIGE, 255)
TURF_DECAL_COLOR_HELPER(opaque/red, COLOR_RED_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/bar, "#791500", 255)
TURF_DECAL_COLOR_HELPER(opaque/pink, COLOR_PALE_RED_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/purple, COLOR_PURPLE_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/mauve, COLOR_PALE_PURPLE_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/orange, COLOR_DARK_ORANGE, 255)
TURF_DECAL_COLOR_HELPER(opaque/brown, COLOR_DARK_BROWN, 255)
TURF_DECAL_COLOR_HELPER(opaque/white, COLOR_WHITE, 255)
TURF_DECAL_COLOR_HELPER(opaque/grey, COLOR_FLOORTILE_GRAY, 255)
TURF_DECAL_COLOR_HELPER(opaque/lightgrey, "#a8b2b6", 255)
TURF_DECAL_COLOR_HELPER(opaque/bottlegreen, "#57967f", 255)

//transparent
TURF_DECAL_COLOR_HELPER(transparent/neutral, null, 75)
TURF_DECAL_COLOR_HELPER(transparent/black, COLOR_TILE_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/blue, COLOR_BLUE_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/green, COLOR_GREEN_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/lime, COLOR_PALE_GREEN_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/yellow, COLOR_BROWN, 140)
TURF_DECAL_COLOR_HELPER(transparent/beige, COLOR_BEIGE, 140)
TURF_DECAL_COLOR_HELPER(transparent/red, COLOR_RED_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/bar, "#791500", 130)
TURF_DECAL_COLOR_HELPER(transparent/pink, COLOR_PALE_RED_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/purple, COLOR_PURPLE_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/mauve, COLOR_PALE_PURPLE_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/orange, COLOR_DARK_ORANGE, 140)
TURF_DECAL_COLOR_HELPER(transparent/brown, COLOR_DARK_BROWN, 140)
TURF_DECAL_COLOR_HELPER(transparent/white, COLOR_WHITE, 140)
TURF_DECAL_COLOR_HELPER(transparent/grey, COLOR_FLOORTILE_GRAY, 140)
TURF_DECAL_COLOR_HELPER(transparent/lightgrey, "#a8b2b6", 140)
TURF_DECAL_COLOR_HELPER(transparent/bottlegreen, "#57967f", 140)

// trimline

/obj/effect/floor_decal/trimline
	icon = 'mod_celadon/decals/icon/decals.dmi'
	icon_state = "trimline_box"

/obj/effect/floor_decal/road
	name = "road decal"
	icon = 'mod_celadon/decals/icon/decals.dmi'
	icon_state = "road"
	alpha = 180

/obj/effect/floor_decal/road/edge
	icon_state = "road_edge"

/obj/effect/floor_decal/road/stripes
	icon_state = "road_stripes"

/obj/effect/floor_decal/road/stop
	icon_state = "road_stop"
	color = COLOR_YELLOW

/obj/effect/floor_decal/road/stop/white
	color = COLOR_WHITE

/obj/effect/floor_decal/road/stop/red
	color = COLOR_RED

/obj/effect/floor_decal/road/slow
	icon_state = "road_slow"
	color = COLOR_YELLOW

/obj/effect/floor_decal/road/slow/white
	color = COLOR_WHITE

/obj/effect/floor_decal/road/slow/red
	color = COLOR_RED

/obj/effect/floor_decal/road/line
	icon_state = "road_line"

/obj/effect/floor_decal/road/line/edge
	icon_state = "road_line_edge"

/obj/effect/floor_decal/industrial/caution
	icon_state = "caution"
	color = COLOR_YELLOW

/obj/effect/floor_decal/industrial/caution/white
	color = COLOR_WHITE

/obj/effect/floor_decal/industrial/caution/red
	color = COLOR_RED

/obj/effect/floor_decal/industrial/stand_clear
	icon_state = "stand_clear"
	color = COLOR_YELLOW

/obj/effect/floor_decal/industrial/stand_clear/white
	color = COLOR_WHITE

/obj/effect/floor_decal/industrial/stand_clear/red
	color = COLOR_RED

/obj/effect/floor_decal/industrial/caution
	icon_state = "caution"
	color = COLOR_YELLOW

/obj/effect/floor_decal/industrial/caution/white
	color = COLOR_WHITE

/obj/effect/floor_decal/industrial/caution/red
	color = COLOR_RED
