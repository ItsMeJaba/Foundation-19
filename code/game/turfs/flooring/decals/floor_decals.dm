/obj/effect/floor_decal/reset
	name = "reset marker"

/obj/effect/floor_decal/reset/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	var/turf/T = get_turf(src)
	T.remove_decals()
	T.update_icon()
	atom_flags |= ATOM_FLAG_INITIALIZED
	return INITIALIZE_HINT_QDEL

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

/obj/effect/floor_decal/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown_edges"

/obj/effect/floor_decal/carpet/blue
	name = "blue carpet"
	icon_state = "blue1_edges"

/obj/effect/floor_decal/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2_edges"

/obj/effect/floor_decal/carpet/purple
	name = "purple carpet"
	icon_state = "purple_edges"

/obj/effect/floor_decal/carpet/orange
	name = "orange carpet"
	icon_state = "orange_edges"

/obj/effect/floor_decal/carpet/green
	name = "green carpet"
	icon_state = "green_edges"

/obj/effect/floor_decal/carpet/red
	name = "red carpet"
	icon_state = "red_edges"

/obj/effect/floor_decal/carpet/corners
	name = "brown carpet"
	icon_state = "brown_corners"

/obj/effect/floor_decal/carpet/blue/corners
	name = "blue carpet"
	icon_state = "blue1_corners"

/obj/effect/floor_decal/carpet/blue2/corners
	name = "pale blue carpet"
	icon_state = "blue2_corners"

/obj/effect/floor_decal/carpet/purple/corners
	name = "purple carpet"
	icon_state = "purple_corners"

/obj/effect/floor_decal/carpet/orange/corners
	name = "orange carpet"
	icon_state = "orange_corners"

/obj/effect/floor_decal/carpet/green/corners
	name = "green carpet"
	icon_state = "green_corners"

/obj/effect/floor_decal/carpet/red/corners
	name = "red carpet"
	icon_state = "red_corners"

/obj/effect/floor_decal/corner
	icon_state = "corner_white"
	alpha = 229

/obj/effect/floor_decal/corner/black
	name = "black corner"
	color = "#333333"

/obj/effect/floor_decal/corner/black/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/black/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/black/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/black/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/black/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/black/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/black/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/black/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/black/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/black/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/blue
	name = "blue corner"
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/corner/blue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/blue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/blue/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/blue/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/blue/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/blue/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/blue/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/blue/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/blue/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/blue/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/paleblue
	name = "pale blue corner"
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/floor_decal/corner/paleblue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/paleblue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/paleblue/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/paleblue/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/paleblue/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/paleblue/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/paleblue/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/paleblue/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/paleblue/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/paleblue/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/green
	name = "green corner"
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/corner/green/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/green/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/green/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/green/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/green/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/green/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/green/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/green/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/green/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/green/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/lime
	name = "lime corner"
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/corner/lime/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/lime/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/lime/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/lime/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/lime/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/lime/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/lime/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/lime/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/lime/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/lime/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/yellow
	name = "yellow corner"
	color = COLOR_BROWN

/obj/effect/floor_decal/corner/yellow/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/yellow/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/yellow/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/yellow/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/yellow/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/yellow/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/yellow/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/yellow/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/yellow/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/yellow/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/beige
	name = "beige corner"
	color = COLOR_BEIGE

/obj/effect/floor_decal/corner/beige/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/beige/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/beige/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/beige/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/beige/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/beige/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/beige/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/beige/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/beige/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/beige/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/red
	name = "red corner"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/corner/red/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/red/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/red/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/red/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/red/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/red/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/red/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/red/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/red/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/red/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/pink
	name = "pink corner"
	color = COLOR_PALE_RED_GRAY

/obj/effect/floor_decal/corner/pink/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/pink/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/pink/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/pink/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/pink/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/pink/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/pink/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/pink/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/pink/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/pink/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/purple
	name = "purple corner"
	color = COLOR_PURPLE_GRAY

/obj/effect/floor_decal/corner/purple/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/purple/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/purple/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/purple/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/purple/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/purple/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/purple/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/purple/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/purple/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/purple/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/mauve
	name = "mauve corner"
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/corner/mauve/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/mauve/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/mauve/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/mauve/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/mauve/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/mauve/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/mauve/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/mauve/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/mauve/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/mauve/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/orange
	name = "orange corner"
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/corner/orange/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/orange/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/orange/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/orange/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/orange/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/orange/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/orange/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/orange/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/orange/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/orange/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/brown
	name = "brown corner"
	color = COLOR_DARK_BROWN

/obj/effect/floor_decal/corner/brown/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/brown/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/brown/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/brown/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/brown/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/brown/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/brown/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/brown/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/brown/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/brown/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/white
	name = "white corner"
	icon_state = "corner_white"

/obj/effect/floor_decal/corner/white/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/white/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/white/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/white/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/white/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/grey
	name = "grey corner"
	color = "#8d8c8c"

/obj/effect/floor_decal/corner/grey/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/grey/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/grey/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/white/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/grey/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/grey/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/white/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/white/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/white/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/white/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/grey/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/grey/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/grey/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/grey/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/grey/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/grey/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/grey/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/lightgrey
	name = "lightgrey corner"
	color = "#a8b2b6"

/obj/effect/floor_decal/corner/lightgrey/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/lightgrey/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/lightgrey/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/lightgrey/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/lightgrey/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/lightgrey/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/lightgrey/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/lightgrey/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/lightgrey/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/lightgrey/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/b_green
	name = "bottle green corner"
	color = COLOR_PALE_BTL_GREEN

/obj/effect/floor_decal/corner/b_green/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/b_green/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/b_green/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/b_green/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/b_green/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/b_green/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/b_green/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/b_green/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/b_green/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/b_green/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/research
	name = "research corner"
	color = COLOR_RESEARCH

/obj/effect/floor_decal/corner/research/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/research/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/research/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/research/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/research/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/research/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/research/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/research/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/research/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/research/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/spline/plain
	name = "spline - plain"
	icon_state = "spline_plain"
	alpha = 229

/obj/effect/floor_decal/spline/plain/black
	color = "#333333"

/obj/effect/floor_decal/spline/plain/blue
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/spline/plain/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/floor_decal/spline/plain/green
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/spline/plain/lime
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/spline/plain/yellow
	color = COLOR_BROWN

/obj/effect/floor_decal/spline/plain/beige
	color = COLOR_BEIGE

/obj/effect/floor_decal/spline/plain/red
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/spline/plain/pink
	color = COLOR_PALE_RED_GRAY

/obj/effect/floor_decal/spline/plain/purple
	color = COLOR_PURPLE_GRAY

/obj/effect/floor_decal/spline/plain/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/spline/plain/orange
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/spline/plain/brown
	color = COLOR_DARK_BROWN

/obj/effect/floor_decal/spline/plain/white
	color = COLOR_WHITE

/obj/effect/floor_decal/spline/plain/grey
	color = "#8d8c8c"

/obj/effect/floor_decal/spline/fancy
	name = "spline - fancy"
	icon_state = "spline_fancy"

/obj/effect/floor_decal/spline/fancy/black
	color = COLOR_GRAY

/obj/effect/floor_decal/spline/fancy/black/corner
	icon_state = "spline_fancy_corner"

/obj/effect/floor_decal/spline/fancy/wood
	name = "spline - wood"
	color = "#cb9e04"

/obj/effect/floor_decal/spline/fancy/wood/corner
	icon_state = "spline_fancy_corner"

/obj/effect/floor_decal/spline/fancy/wood/cee
	icon_state = "spline_fancy_cee"

/obj/effect/floor_decal/spline/fancy/wood/three_quarters
	icon_state = "spline_fancy_full"

/obj/effect/floor_decal/industrial/warning
	name = "hazard stripes"
	color = "#d2d53d"
	icon_state = "stripe"

/obj/effect/floor_decal/industrial/warning/corner
	icon_state = "stripecorner"

/obj/effect/floor_decal/industrial/warning/full
	icon_state = "stripefull"


/obj/effect/floor_decal/industrial/warning/cee
	icon_state = "stripecee"

/obj/effect/floor_decal/industrial/warning/fulltile
	icon_state = "stripefulltile"

/obj/effect/floor_decal/industrial/custodial
	name = "custodial stripes"
	icon_state = "stripe"
	color =  "#c900fb"

/obj/effect/floor_decal/industrial/custodial/corner
	icon_state = "stripecorner"

/obj/effect/floor_decal/industrial/custodial/full
	icon_state = "stripefull"

/obj/effect/floor_decal/industrial/custodial/cee
	icon_state = "stripecee"

/obj/effect/floor_decal/industrial/custodial/fulltile
	icon_state = "stripefulltile"

/obj/effect/floor_decal/industrial/fire
	name = "fire safety stripes"
	icon_state = "stripe"
	detail_overlay = "overstripe"
	color = "#c90000"

/obj/effect/floor_decal/industrial/fire/corner
	icon_state = "stripecorner"
	detail_overlay = "overstripecorner"

/obj/effect/floor_decal/industrial/fire/full
	icon_state = "stripefull"
	detail_overlay = "overstripefull"

/obj/effect/floor_decal/industrial/fire/cee
	icon_state = "stripecee"
	detail_overlay = "overstripecee"

/obj/effect/floor_decal/industrial/fire/fulltile
	icon_state = "stripefulltile"

/obj/effect/floor_decal/industrial/radiation
	name = "radiation hazard stripes"
	icon_state = "stripe"
	color = "#d2d53d"
	detail_overlay = "overstripe"
	detail_color =  "#c900fb"

/obj/effect/floor_decal/industrial/radiation/corner
	icon_state = "stripecorner"
	detail_overlay = "overstripecorner"

/obj/effect/floor_decal/industrial/radiation/full
	icon_state = "stripefull"
	detail_overlay = "overstripefull"

/obj/effect/floor_decal/industrial/radiation/cee
	icon_state = "stripecee"
	detail_overlay = "overstripecee"

/obj/effect/floor_decal/industrial/radiation/fulltile
	icon_state = "stripefulltile"

/obj/effect/floor_decal/industrial/firstaid
	name = "first aid stripes"
	icon_state = "stripe"
	detail_overlay = "overstripe"
	color =  "#00cd00"

/obj/effect/floor_decal/industrial/firstaid/corner
	icon_state = "stripecorner"
	detail_overlay = "overstripecorner"

/obj/effect/floor_decal/industrial/firstaid/full
	icon_state = "stripefull"
	detail_overlay = "overstripefull"

/obj/effect/floor_decal/industrial/firstaid/cee
	icon_state = "stripecee"
	detail_overlay = "overstripecee"

/obj/effect/floor_decal/industrial/firstaid/fulltile
	icon_state = "stripefulltile"

/obj/effect/floor_decal/industrial/defective
	name = "defective machinery stripes"
	icon_state = "stripe"
	detail_overlay = "overstripe"
	color = "#0000fb"

/obj/effect/floor_decal/industrial/defective/corner
	icon_state = "stripecorner"
	detail_overlay = "overstripecorner"

/obj/effect/floor_decal/industrial/defective/full
	icon_state = "stripefull"
	detail_overlay = "overstripefull"

/obj/effect/floor_decal/industrial/defective/cee
	icon_state = "stripecee"
	detail_overlay = "overstripecee"

/obj/effect/floor_decal/industrial/defective/fulltile
	icon_state = "stripefulltile"

/obj/effect/floor_decal/industrial/traffic
	name = "traffic hazard stripes"
	icon_state = "stripe"
	detail_overlay = "overstripe"
	color = "#fb9700"

/obj/effect/floor_decal/industrial/traffic/corner
	icon_state = "stripecorner"
	detail_overlay = "overstripecorner"

/obj/effect/floor_decal/industrial/traffic/full
	icon_state = "stripefull"
	detail_overlay = "overstripefull"

/obj/effect/floor_decal/industrial/traffic/cee
	icon_state = "stripecee"
	detail_overlay = "overstripecee"

/obj/effect/floor_decal/industrial/traffic/fulltile
	icon_state = "stripefulltile"

/obj/effect/floor_decal/industrial/warning/dust
	name = "hazard stripes"
	icon_state = "warning_dust"

/obj/effect/floor_decal/industrial/warning/dust/corner
	name = "hazard stripes"
	icon_state = "warningcorner_dust"

/obj/effect/floor_decal/industrial/hatch
	name = "hatched marking"
	icon_state = "delivery"
	alpha = 229

/obj/effect/floor_decal/industrial/hatch/yellow
	color = "#cfcf55"

/obj/effect/floor_decal/industrial/hatch/red
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/industrial/hatch/orange
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/industrial/hatch/blue
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/industrial/shutoff
	name = "shutoff valve marker"
	icon_state = "shutoff"

/obj/effect/floor_decal/industrial/outline
	name = "white outline"
	icon_state = "outline"
	alpha = 229

/obj/effect/floor_decal/industrial/outline/blue
	name = "blue outline"
	color = "#00b8b2"

/obj/effect/floor_decal/industrial/outline/yellow
	name = "yellow outline"
	color = "#cfcf55"

/obj/effect/floor_decal/industrial/outline/grey
	name = "grey outline"
	color = "#808080"

/obj/effect/floor_decal/industrial/outline/red
	name = "red outline"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/industrial/outline/orange
	name = "orange outline"
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/industrial/loading
	name = "loading area"
	icon_state = "loadingarea"
	alpha = 229

/obj/effect/floor_decal/plaque
	name = "plaque"
	icon_state = "plaque"

/obj/effect/floor_decal/asteroid
	name = "random asteroid rubble"
	icon_state = "asteroid0"

/obj/effect/floor_decal/beach
	name = "sandy border"
	icon = 'icons/misc/beach.dmi'
	icon_state = "beachborder"

/obj/effect/floor_decal/beach/corner
	icon_state = "beachbordercorner"

/obj/effect/floor_decal/asteroid/New()
	icon_state = "asteroid[rand(0,9)]"
	..()

/obj/effect/floor_decal/chapel
	name = "chapel"
	icon_state = "chapel"

/obj/effect/floor_decal/ss13/l1
	name = "L1"
	icon_state = "L1"

/obj/effect/floor_decal/ss13/l2
	name = "L2"
	icon_state = "L2"

/obj/effect/floor_decal/ss13/l3
	name = "L3"
	icon_state = "L3"

/obj/effect/floor_decal/ss13/l4
	name = "L4"
	icon_state = "L4"

/obj/effect/floor_decal/ss13/l5
	name = "L5"
	icon_state = "L5"

/obj/effect/floor_decal/ss13/l6
	name = "L6"
	icon_state = "L6"

/obj/effect/floor_decal/ss13/l7
	name = "L7"
	icon_state = "L7"

/obj/effect/floor_decal/ss13/l8
	name = "L8"
	icon_state = "L8"

/obj/effect/floor_decal/ss13/l9
	name = "L9"
	icon_state = "L9"

/obj/effect/floor_decal/ss13/l10
	name = "L10"
	icon_state = "L10"

/obj/effect/floor_decal/ss13/l11
	name = "L11"
	icon_state = "L11"

/obj/effect/floor_decal/ss13/l12
	name = "L12"
	icon_state = "L12"

/obj/effect/floor_decal/ss13/l13
	name = "L13"
	icon_state = "L13"

/obj/effect/floor_decal/ss13/l14
	name = "L14"
	icon_state = "L14"

/obj/effect/floor_decal/ss13/l15
	name = "L15"
	icon_state = "L15"

/obj/effect/floor_decal/ss13/l16
	name = "L16"
	icon_state = "L16"

/obj/effect/floor_decal/sign
	name = "floor sign"
	icon_state = "white_1"

/obj/effect/floor_decal/sign/two
	icon_state = "white_2"

/obj/effect/floor_decal/sign/a
	icon_state = "white_a"

/obj/effect/floor_decal/sign/b
	icon_state = "white_b"

/obj/effect/floor_decal/sign/c
	icon_state = "white_c"

/obj/effect/floor_decal/sign/d
	icon_state = "white_d"

/obj/effect/floor_decal/sign/ex
	icon_state = "white_ex"

/obj/effect/floor_decal/sign/m
	icon_state = "white_m"

/obj/effect/floor_decal/sign/cmo
	icon_state = "white_cmo"

/obj/effect/floor_decal/sign/v
	icon_state = "white_v"

/obj/effect/floor_decal/sign/p
	icon_state = "white_p"

/obj/effect/floor_decal/sign/or1
	icon_state = "white_or1"

/obj/effect/floor_decal/sign/or2
	icon_state = "white_or2"

/obj/effect/floor_decal/sign/tr
	icon_state = "white_tr"

/obj/effect/floor_decal/sign/pop
	icon_state = "white_pop"

/obj/effect/floor_decal/solarpanel
	icon_state = "solarpanel"

/obj/effect/floor_decal/snow
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snowfloor"

/obj/effect/floor_decal/floordetail
	layer = TURF_DETAIL_LAYER
	color = COLOR_GUNMETAL
	icon_state = "manydot"
	appearance_flags = 0

/obj/effect/floor_decal/floordetail/New(newloc, newdir, newcolour)
	color = null //color is here just for map preview, if left it applies both our and tile colors.
	..()

/obj/effect/floor_decal/floordetail/tiled
	icon_state = "manydot_tiled"

/obj/effect/floor_decal/floordetail/pryhole
	icon_state = "pryhole"

/obj/effect/floor_decal/floordetail/edgedrain
	icon_state = "edge"

/obj/effect/floor_decal/floordetail/traction
	icon_state = "traction"

/obj/effect/floor_decal/ntlogo
	icon_state = "ntlogo"

/obj/effect/floor_decal/torchltdlogo
	alpha = 230
	icon = 'icons/turf/flooring/corp_floor.dmi'
	icon_state = "bottomleft"

//Techfloor

/obj/effect/floor_decal/corner_techfloor_gray
	name = "corner techfloorgray"
	icon_state = "corner_techfloor_gray"

/obj/effect/floor_decal/corner_techfloor_gray/diagonal
	name = "corner techfloorgray diagonal"
	icon_state = "corner_techfloor_gray_diagonal"

/obj/effect/floor_decal/corner_techfloor_gray/full
	name = "corner techfloorgray full"
	icon_state = "corner_techfloor_gray_full"

/obj/effect/floor_decal/corner_techfloor_grid
	name = "corner techfloorgrid"
	icon_state = "corner_techfloor_grid"

/obj/effect/floor_decal/corner_techfloor_grid/diagonal
	name = "corner techfloorgrid diagonal"
	icon_state = "corner_techfloor_grid_diagonal"

/obj/effect/floor_decal/corner_techfloor_grid/full
	name = "corner techfloorgrid full"
	icon_state = "corner_techfloor_grid_full"

/obj/effect/floor_decal/corner_steel_grid
	name = "corner steel_grid"
	icon_state = "steel_grid"

/obj/effect/floor_decal/corner_steel_grid/diagonal
	name = "corner tsteel_grid diagonal"
	icon_state = "steel_grid_diagonal"

/obj/effect/floor_decal/corner_steel_grid/full
	name = "corner steel_grid full"
	icon_state = "steel_grid_full"

/obj/effect/floor_decal/borderfloor
	name = "border floor"
	icon_state = "borderfloor_white"
	color = COLOR_GUNMETAL

/obj/effect/floor_decal/borderfloor/corner
	icon_state = "borderfloorcorner_white"

/obj/effect/floor_decal/borderfloor/corner2
	icon_state = "borderfloorcorner2_white"

/obj/effect/floor_decal/borderfloor/full
	icon_state = "borderfloorfull_white"

/obj/effect/floor_decal/borderfloor/cee
	icon_state = "borderfloorcee_white"

/obj/effect/floor_decal/borderfloorblack
	name = "border floor"
	icon_state = "borderfloor_white"
	color = COLOR_DARK_GRAY

/obj/effect/floor_decal/borderfloorblack/corner
	icon_state = "borderfloorcorner_white"

/obj/effect/floor_decal/borderfloorblack/corner2
	icon_state = "borderfloorcorner2_white"

/obj/effect/floor_decal/borderfloorblack/full
	icon_state = "borderfloorfull_white"

/obj/effect/floor_decal/borderfloorblack/cee
	icon_state = "borderfloorcee_white"

/obj/effect/floor_decal/borderfloorwhite
	name = "border floor"
	icon_state = "borderfloor_white"

/obj/effect/floor_decal/borderfloorwhite/corner
	icon_state = "borderfloorcorner_white"

/obj/effect/floor_decal/borderfloorwhite/corner2
	icon_state = "borderfloorcorner2_white"

/obj/effect/floor_decal/borderfloorwhite/full
	icon_state = "borderfloorfull_white"

/obj/effect/floor_decal/borderfloorwhite/cee
	icon_state = "borderfloorcee_white"

/obj/effect/floor_decal/steeldecal
	name = "steel decal"
	icon_state = "steel_decals1"
	color = COLOR_GUNMETAL

/obj/effect/floor_decal/steeldecal/steel_decals1
	icon_state = "steel_decals1"

/obj/effect/floor_decal/steeldecal/steel_decals2
	icon_state = "steel_decals2"

/obj/effect/floor_decal/steeldecal/steel_decals3
	icon_state = "steel_decals3"

/obj/effect/floor_decal/steeldecal/steel_decals4
	icon_state = "steel_decals4"

/obj/effect/floor_decal/steeldecal/steel_decals6
	icon_state = "steel_decals6"

/obj/effect/floor_decal/steeldecal/steel_decals7
	icon_state = "steel_decals7"

/obj/effect/floor_decal/steeldecal/steel_decals8
	icon_state = "steel_decals8"

/obj/effect/floor_decal/steeldecal/steel_decals9
	icon_state = "steel_decals9"

/obj/effect/floor_decal/steeldecal/steel_decals10
	icon_state = "steel_decals10"

/obj/effect/floor_decal/steeldecal/steel_decals_central1
	icon_state = "steel_decals_central1"

/obj/effect/floor_decal/steeldecal/steel_decals_central2
	icon_state = "steel_decals_central2"

/obj/effect/floor_decal/steeldecal/steel_decals_central3
	icon_state = "steel_decals_central3"

/obj/effect/floor_decal/steeldecal/steel_decals_central4
	icon_state = "steel_decals_central4"

/obj/effect/floor_decal/steeldecal/steel_decals_central5
	icon_state = "steel_decals_central5"

/obj/effect/floor_decal/steeldecal/steel_decals_central6
	icon_state = "steel_decals_central6"

/obj/effect/floor_decal/steeldecal/steel_decals_central7
	icon_state = "steel_decals_central7"

/obj/effect/floor_decal/techfloor
	name = "techfloor edges"
	icon_state = "techfloor_edges"

/obj/effect/floor_decal/techfloor/corner
	name = "techfloor corner"
	icon_state = "techfloor_corners"

/obj/effect/floor_decal/techfloor/orange
	name = "techfloor edges"
	icon_state = "techfloororange_edges"

/obj/effect/floor_decal/techfloor/orange/corner
	name = "techfloor corner"
	icon_state = "techfloororange_corners"

/obj/effect/floor_decal/techfloor/hole
	name = "hole left"
	icon_state = "techfloor_hole_left"

/obj/effect/floor_decal/techfloor/hole/right
	name = "hole right"
	icon_state = "techfloor_hole_right"

/obj/effect/floor_decal/stoneborder
	name = "stone border"
	icon_state = "stoneborder"

/obj/effect/floor_decal/stoneborder/corner
	icon_state = "stoneborder_c"

// trimline

/obj/effect/floor_decal/trimline
	icon = 'icons/turf/flooring/decals.dmi'
	icon_state = "trimline_box"

/obj/effect/floor_decal/road
	name = "road decal"
	icon = 'icons/turf/flooring/decals.dmi'
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
