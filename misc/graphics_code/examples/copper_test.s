
;	Simple Copper List Demo coded in asm
;	Coded using devpac 3.
;	Probably needs tweaked for other assemblers.


	include	system.gs		Include all of the system includes
	include	graphics_base.i		Include My graphics Data

	bsr	Graphics_Init		Initialise the graphics system
	
	move.l	#320,d0
	move.l	#256,d1
	move.l	#8,d2
	move.l	#0,d3
	lea	colortable,a0
	bsr	Open_Screen		Open a new view screen

	move.l	d0,screen		store the screen

	OFF_SPRITE			Turn off the sprites
	move.l	screen,a0
	lea	Copper_List,a1

	bsr	Add_Copper		Load a new copper list into screen
pos
	CHECK_CLICK
	bne.s	pos			Wait for a mouse click

	ON_SPRITE			Sprites on

	move.l	screen,a0
	bsr	Close_Screen		Close the screen
	
	bsr	Graphics_Close		close the graphics	
	rts

screen
	ds.l	1
colortable
	include	palette.s		palette data

	include	graphics_base.s		My graphics source		

	Section 	Copper Lists,DATA

Copper_List
	CWAIT	200,0           	wait for line 200
	CMOVE	$180,$0f0f
	CWAIT	15,0
	CMOVE	$180,$fff
	CEND			end of list

	
