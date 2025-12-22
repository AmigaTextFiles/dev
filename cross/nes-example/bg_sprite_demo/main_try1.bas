// This demo ROM allows the player to move Sack of Flour around the screen,
// as a demonstration of sprite drawing. Pressing the select button will
// toggle displaying him behind or in front of the background layer.
// The start button will toggle very simple physics.

//the program starts here on NES boot (see footer)
start:
	gosub vwait
	set $2000 %00100000
	set $2001 %00011100 //sprites and bg visible, no sprite clipping
	gosub init_vars
	gosub vwait
	gosub load_palette
	gosub load_background
//the main program loop
mainloop:
	gosub joy_handler
	gosub vwait
	gosub draw_sack
	goto mainloop

//set default sprite location
init_vars:

	// We need to know where on the screen SOF is. These coordinates
	// define the top left corner of the sprite set. This is 32
	// pixels above his left foot, even though he is only 22 tall
	set sack_x 120 //top left corner of SOF (left foot)
	set sack_y 110 //top left corner of SOF (32 pixels above feet)

	// We need to know which direction to draw him. The attrbute
	//bytes also change, based on whether he is behind the background
	set sack_facing 1 //right
	set sack_r_attrib 0 //attribute byte when facing right
	set sack_l_attrib %01000000 //attribute byte when facing left

	// Status telling whether the select button has been released, so
	// that we don't constantly turn the feature on and off every frame
	set select_still_down 0
	set start_still_down 0
	set behind_bg 0
	set use_physics 0
	set ground_height 135 //for physics (based on his head, not his feet)
	set gravity_dir 0 //downward
	set gravity_index 0
	return

//routine to draw a sprite
draw_sack:
	if sack_facing = 1 goto draw_sack_right
	goto draw_sack_left

//move sprite based on joystick input
joy_handler:
	gosub joystick1
	if joy1select = 0 set select_still_down 0
	if joy1select <> 0 if select_still_down = 0 then
		if behind_bg = 0 then
			set sack_r_attrib %00100000
			set sack_l_attrib %01100000
			set behind_bg 1
			goto joy_handler_1
			endif
		//else behind_bg = 1
			set sack_r_attrib 0
			set sack_l_attrib %01000000
			set behind_bg 0
		endif
	joy_handler_1:
	set select_still_down joy1select
	
	if joy1start = 0 set start_still_down 0
	if joy1start <> 0 if start_still_down = 0
		set use_physics & + use_physics 1 1
	joy_handler_2:

	if use_physics = 1 goto joy_handler_physics
	goto joy_handler_no_physics

joy_handler_no_physics:
	set sack_x + sack_x joy1right
	set sack_x - sack_x joy1left
	set sack_y + sack_y joy1down
	set sack_y - sack_y joy1up
	if joy1right <> 0 set sack_facing 1
	if joy1left <> 0 set sack_facing 0
	return

joy_handler_physics:
	// We don't bother with horizontal collision
	set sack_x + sack_x joy1right
	set sack_x - sack_x joy1left
	if joy1right <> 0 set sack_facing 1
	if joy1left <> 0 set sack_facing 0

	// Handle parabolic jumping
	if joy1a <> 0 if sack_y = ground_height then
		set gravity_dir 1
		set gravity_index 26
		endif

	// Handle rising (falling up)
	if gravity_dir = 1 then
		if gravity_index > 0 dec gravity_index
		set sack_y - sack_y [gravity gravity_index]
		if gravity_index = 0 set gravity_dir 0 //now go down
		endif

	// Handle falling down
	if gravity_dir = 0 then
		if gravity_index < 25 inc gravity_index
		set sack_y + sack_y [gravity gravity_index]
		endif

	// Ground Collision
	if sack_y > ground_height then
		set sack_y ground_height
		set gravity_index 0
		endif
	return

// Draw SOF facing to the right
// We have 4 sprites for him. up-left, down-left,
// up-right, and down-right. They are all 8x16
draw_sack_right:
	set $2003 0

	set $2004 sack_y
	set $2004 32
	set $2004 sack_r_attrib
	set $2004 sack_x

	set $2004 + sack_y 16
	set $2004 34
	set $2004 sack_r_attrib
	set $2004 sack_x

	set $2004 sack_y
	set $2004 36
	set $2004 sack_r_attrib
	set $2004 + sack_x 8

	set $2004 + sack_y 16
	set $2004 38
	set $2004 sack_r_attrib
	set $2004 + sack_x 8

	return

// Draw SOF facing left
// Note that, since he is made of 4 sprites, we have
// to flip the horizontal drawing order, in addition
// to flipping the sprites themselves
draw_sack_left:
	set $2003 0

	set $2004 sack_y
	set $2004 36
	set $2004 sack_l_attrib
	set $2004 sack_x

	set $2004 + sack_y 16
	set $2004 38
	set $2004 sack_l_attrib
	set $2004 sack_x

	set $2004 sack_y
	set $2004 32
	set $2004 sack_l_attrib
	set $2004 + sack_x 8

	set $2004 + sack_y 16
	set $2004 34
	set $2004 sack_l_attrib
	set $2004 + sack_x 8

	return


//load the colors
load_palette:
	//set the PPU start address (background color 0)
	set $2006 $3f
	set $2006 0
	set $2007 $31 //sky blue
	set $2007 $1a //dark green
	set $2007 $29 //light green
	set $2007 $28 //tan

	//set the PPU start address (foreground color 0)
	set $2006 $3f
	set $2006 $10
	set $2007 $31 //mirror sky blue
	set $2007 $0e //black
	set $2007 $30 //white
	set $2007 $10 //grey
	return	

//draw the simple background
load_background:
	gosub vwait
	gosub load_grass_top
	gosub load_grass_bottom
	gosub vwait
	gosub load_bottom_bricks
	return

load_grass_top:
	set $2006 $22
	set $2006 $65
	set y 0
	load_grass_top_1:
		set $2007 2
		set $2007 3
		set $2007 0
		set $2007 0
		set $2007 0
		set $2007 0
		set $2007 0
		inc y
		if y <> 4 goto load_grass_top_1
	return

load_grass_bottom:
	set $2006 $22
	set $2006 $80
	set y 0
	load_grass_bottom_1:
		set $2007 22
		set $2007 23
		set $2007 24
		set $2007 25
		set $2007 22
		set $2007 18
		set $2007 19
		inc y
		if y <> 5 goto load_grass_bottom_1
	return

load_bottom_bricks:
	set $2006 $22
	set $2006 $a0
	set y 0
	load_bottom_bricks_1:
		set $2007 4
		set $2007 5
		inc y
		if y <> 16 goto load_bottom_bricks_1
	set y 0
	load_bottom_bricks_2:
		set $2007 20
		set $2007 21
		inc y
		if y <> 16 goto load_bottom_bricks_2
	gosub vwait
	return

gravity: //32 bytes
	data 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1
	data 2, 1, 2, 1, 2, 2, 2, 3, 2, 2, 3, 3, 3, 3, 3, 3
