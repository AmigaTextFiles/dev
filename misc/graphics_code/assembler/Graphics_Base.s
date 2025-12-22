;-------- Initialisation routines ------------------------------------------
;	Graphics_Init()		
;	Graphics_Close()
;	Open_Screen(d0,d1,d2,d3,a0)	width, height, depth, viewmodes, cmap
;	Close_Screen(a0)			screen
;	Init_Mask(d0,d1,d2,d3,d4,d5)	x_min,y_min,x_max,y_max,sreen x,screen y
;	Free_Mask(a0)			maskplane struct

;-------- Drawing routines -------------------------------------------------
;	Fill_Polygon(a0,a1,d0,d1)  	screen, vertex list, npoints, colour
;	Draw_Polygon(a0,a1,d0,d1)		screen, vertex list, npoints, colour
;	Draw_Line(a0,d0,d1,d2,d3,d4)	screen, x1, y1, x2, y2, colour		
;	Write_Pixel(a0,d0,d1,d2)		screen, x1, x2, colour
;	Screen_Clear(a0)			screen

;-------- Fade Routines------------------------------------------------
;	Fade_To_White(a0,a1)	source screen,source colourmap
;	Fade_To_Black(a0,a1)	source screen,source colourmap
;	Fade(a0,a1,a2)		screen,source,destination

;-------- IFF Handling routines reading and writing of bitmaps -------------
;	Save_IFF(a0,a1)=filename APTR, screen ADDR
;	Load_IFF(a0,a1)=filename APTR, screen ADDR

;-------- File handling Routines -------------------------------------------
;	Load_Data(a0,d0,a1)		filename, buffer length, destination
;	Save_Data(a0,d0,a1)		filename, buffer length, source

;-------- Text handling routines -------------------------------------------
;	Write_Text(a0,a1,d0,d1,d2,d3)	screen, text, x, y, colour, length
;	Num_To_String(d0)			word

;-------- Copper  handling routines -------------------------------------
;	Add_Copper(a0,a1)		screen,copper list

;-------- Input Handling Routines ------------------------------------------
;	GetKey()


;-------- Initialisation routines ------------------------------------------
;	Graphics_Init()		
;	Graphics_Close()
;	Open_Screen(d0,d1,d2,d3,a0)	width, height, depth, viewmodes, cmap
;	Close_Screen(a0)			screen
;	Init_Mask(d0,d1,d2,d3,d4,d5)	x_min,y_min,x_max,y_max,sreen x,screen y
;	Free_Mask(a0)			maskplane struct

Graphics_Init
;	sets a high taskpri, opens the graphics library
;	and loads a null view
;	returns 0 if failure
;	        1 if success

	move.l	#0,d7

	OPENLIB 	_graphics_lib,0,_GfxBase
	tst.l	d0
	beq.s	G_Init_Failed

	move.l  4.w,a6
       	sub.l   a1,a1         			Zero - Find current task
      	jsr     _LVOFindTask(a6)

       	move.l  d0,a1
       	moveq   #127,d0				task priority to very high...
       	jsr     _LVOSetTaskPri(a6)

	move.l	_GfxBase,a0			get GfxBase
	move.l	gb_ActiView(a0),a1		get the current view
	move.l	a1,_oldview			store the address

	move.l	#0,a1
	CALLGRAF	LoadView				load a null view

	CALLGRAF	WaitTOF

	moveq.l	#SETCHIPREV_AA,d0			set chipset to AGA
	CALLGRAF	SetChipRev			call SetChipRev

	move.l	#1,d7
G_Init_Failed
	move.l	d7,d0
	rts

Graphics_Close
;	closes the graphics library and restores the view

	tst.l	_oldview
	beq.s	Graphics_Close_1
	move.l	_oldview,a1			get the previous address view
	CALLGRAF	LoadView				load it into the view

	CALLGRAF	WaitTOF				wait a bit
Graphics_Close_1
	tst.l	_GfxBase
	beq.s	Graphics_Close_2
	CLOSELIB	_GfxBase
Graphics_Close_2
	rts

	
Open_Screen
; opens a view
;	d0.l=pixel width
;	d1.l=pixel height
;	d2.l=depth
;	d3.l=viewmodes
;	a0.l=colourmap

; 	d0.l=returns screen address

	movem.l	d0-d3/a0,-(sp)		store inputs

	moveq.l	#0,d7			set d7 to failure
	
	move.l	#Screen_Store_SIZEOF,d0	the screen storage structure 
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	don't care about the memory
	CALLEXEC	AllocMem			allocate it
	
	tst.l	d0
	beq	Screen_Failed		failed to allocate my screen
	
	move.l	d0,a4			base of storage structure

;	moveq.l	#0,d7			

	move.l	#18,d0			size of a view structure
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	don't care about the memory
	CALLEXEC	AllocMem			allocate memory for view struct
	move.l	d0,SS_View(a4)		store the address

	tst.l	d0
	beq	Screen_Failed		failed to open the view structure

	move.l	SS_View(a4),a1		init view structure
	CALLGRAF	InitView			  	

	move.l	#VIEW_EXTRA_TYPE,d0	set up a view extra 
	CALLGRAF	GfxNew			structure for the view

	move.l	d0,SS_ViewExtra(a4)	store the viewextra structure

	tst.l	d0			
	beq	Screen_Failed		couldn't allocate one so off we go

	move.l	SS_View(a4),a0		associate view extra
	move.l	SS_ViewExtra(a4),a1	with view
	CALLGRAF	GfxAssociate

	move.l	SS_View(a4),a0			tell the view struct
	move.l	#EXTEND_VSTRUCT,v_Modes(a0)	that there is a view extra
	
	move.l	#0,a1			open the monitor and
	move.l	#DEFAULT_MONITOR_ID,d0	get it's default spec
	CALLGRAF	OpenMonitor
	move.l	d0,SS_MonSpec(a4)

	tst.l	d0
	beq	Screen_Failed		couldn't allocate the monitor

	move.l	SS_ViewExtra(a4),a0		put the monitor spec
	move.l	SS_MonSpec(a4),ve_Monitor(a0)	into the view extra

	move.l	#40,d0			size of a bitmap struct
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	don't care about the memory
	CALLEXEC	AllocMem			allocate it
	
	move.l	d0,SS_BitMap(a4)

	tst.l	d0
	beq	Screen_Failed		couldn't allocate a bitmap structure

	move.l	SS_BitMap(a4),a0		set up the bitmap 
	move.l	8(sp),d0			NPLANES 
	move.l	(sp),d1			WIDTH	
	move.l	4(sp),d2			HEIGHT
	CALLGRAF	InitBitMap		

	move.l	(sp),d0			WIDTH
	lsr.l	#3,d0			/8
	muls.l	4(sp),d0			*HEIGHT
	muls.l	8(sp),d0			*NPLANES
	move.l	#MEMF_CHIP!MEMF_CLEAR,d1	chip mem
	CALLEXEC	AllocMem			allocate the memory

	move.l	d0,SS_Screen(a4)

	tst.l	d0				
	beq	Screen_Failed		couldn't allocate a screen memory

	move.l	SS_BitMap(a4),a2		get the bitmap struct
	lea	bm_Planes(a2),a2		address of bitplanes
	move.l	SS_Screen(a4),a3		screen 1 :-prev alloc

	move.l	(sp),d0			WIDTH
	lsr.l	#3,d0			/8
	muls.l	4(sp),d0			*HEIGHT

	move.l	8(sp),d7			NPLANES
	sub.l	#1,d7			-1
.bpl_loop
	move.l	a3,(a2)+			put bitplane into struct
	add.l	d0,a3			add plane size
	dbra	d7,.bpl_loop		loop round 

	move.l	#12,d0			size of rasinfo structure
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	don't care about the memory
	CALLEXEC	AllocMem			memory for rasinfo struct
	
	move.l	d0,SS_RasInfo(a4)
	
	tst.l	d0
	beq	Screen_Failed		couldn't allocate a rasinfo struct

	move.l	SS_RasInfo(a4),a0		
	move.l	SS_BitMap(a4),a1
	move.l	a1,ri_BitMap(a0)		rasinfo into bitmap

	move.l	#40,d0			size of a viewport structure
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	don't care about the memory
	CALLEXEC	AllocMem			memory for viewport struct

	move.l	d0,SS_ViewPort(a4)
	
	tst.l	d0
	beq	Screen_Failed		couldn't allocate the viewport struct

	move.l	d0,a0			viewport address into a0
	CALLGRAF	InitVPort		initialise the viewport
	
	move.l	SS_ViewPort(a4),a0
	move.w	14(sp),vp_Modes(a0)	viewmodes into viewport
	
	move.l	SS_View(a4),a1		viewport is already in a0 
	move.l	a0,v_ViewPort(a1)		associate the view and viewport
	
	move.l	SS_RasInfo(a4),a1		viewport already in a0
	move.l	a1,vp_RasInfo(a0)		associate the vport & rasinfo
	move.w	2(sp),vp_DWidth(a0)	WIDTH
	move.w	6(sp),vp_DHeight(a0)	HEIGHT
	
	move.l	#VIEWPORT_EXTRA_TYPE,d0	gfx extra type
	CALLGRAF	GfxNew			make a vpextra struct

	move.l	d0,SS_ViewPortExtra(a4)	store the vpextra address

	tst.l	d0
	beq	Screen_Failed		couldn't allocate a vpextra

	lea	vctags,a0			the vctag structure
;	lea	12(a0),a0
	move.l	SS_ViewPortExtra(a4),12(a0)	vpextra into vctags

	move.l	#88,d0			size of a dim info structure
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	don't care about the memory
	CALLEXEC	AllocMem			allocate memory for diminfo struct	

	move.l	d0,SS_DimensionInfo(a4)
	
	tst.l	d0
	beq	Screen_Failed		couldn't allocate the memory

	move.l	#0,a0
	move.l	SS_DimensionInfo(a4),a1
	move.l	#88,d0
	move.l	#DTAG_DIMS,d1
	move.l	#DEFAULT_MONITOR_ID,d2
	CALLGRAF	GetDisplayInfoData	get the diminfo struct

	move.l	SS_ViewPortExtra(a4),a0	link these bits together 
	lea	vpe_DisplayClip(a0),a0
	move.l	SS_DimensionInfo(a4),a1
	lea	dim_Nominal(a1),a1
	move.l	(a1)+,(a0)+
	move.l	(a1),(a0)		

	move.l	#DEFAULT_MONITOR_ID,d0	get the display ID
	CALLGRAF	FindDisplayInfo		for this display!

	lea	vctags,a0		
	lea	20(a0),a0		store this in the tag list
	move.l	d0,(a0)			

	moveq.l	#0,d0			clear d0
	move.l	8(sp),d1			set bit number for no of colours
	bset	d1,d0			
	CALLGRAF	GetColorMap		allocate a colourmap structure

	move.l	d0,SS_ColorMap(a4)

	tst.l	d0
	beq	Screen_Failed		couldn't allocate a colourmap struct

	lea	vctags,a0
	lea	4(a0),a0			stick the vieport into
	move.l	SS_ViewPort(a4),a1	the tag list structure
	move.l	a1,(a0)
	
	move.l	SS_ColorMap(a4),a0
	lea	vctags,a1
	CALLGRAF	VideoControl		

	tst.l	d0
	bne	Screen_Failed
	
	move.l	#100,d0			size of a rastport structure
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	don't care about the memory
	CALLEXEC	AllocMem			memory for rastport structure

	move.l	d0,SS_RastPort(a4)
	
	tst.l	d0
	beq.s	Screen_Failed		couldn't allocate a rastport
	
	move.l	d0,a1
	CALLGRAF	InitRastPort		init the rastport
	
	move.l	SS_BitMap(a4),a0
	move.l	SS_RastPort(a4),a1
	move.l	a0,rp_BitMap(a1)		bitmap struct into rastport

	
	move.l	SS_ViewPort(a4),a0
	move.l	16(sp),a1		colortable into a0
	CALLGRAF	LoadRGB32		load the colortable into the viewport

	move.l	SS_View(a4),a0
	move.l	SS_ViewPort(a4),a1
	CALLGRAF	MakeVPort		make the viewport

	tst.l	d0
	bne.s	Screen_Failed		couldn't make the viewport

	move.l	SS_View(a4),a1
	CALLGRAF	MrgCop			build the copperlist

	tst.l	d0
	bne.s	Screen_Failed		couldn't build the copperlist

	move.l	SS_View(a4),a1		all done so
	CALLGRAF	LoadView			load the view up :-)<-<

	movem.l	(sp)+,d0-d3/a0		outputs back out.

	move.l	d0,SS_Width(a4)		store the width
	move.l	d1,SS_Height(a4)		store the height	
	move.l	d2,SS_Planes(a4)		store the number of planes
	move.l	a0,SS_ColorTable(a4)	store the colourtable
	
	move.l	a4,d7			screen store base address
Screen_Failed
	move.l	d7,d0			return value.
	bne.s	Screen_Done		not zero so out we go
	movem.l	(sp)+,d0-d3/a0		pull outputs off if we haven't done it
Screen_Done
	rts				all done!
	
Close_Screen:
; Closes a view
;	in:-a0=screen storage structure

	move.l	a0,a4		

	move.l	SS_UserCopperList(a4),a0
	tst.l	a0			have we got any user coppers ?
	beq.s	Close_Screen14		
	move.l	SS_ViewPort(a4),a0
	CALLGRAF	FreeVPortCopLists		free the user copperlists

Close_Screen14
	move.l	SS_View(a4),a0
	tst.l	a0			have we got a view structure ?
	beq.s	Close_Screen12		
	lea	v_LOFCprList(a0),a0
	move.l	(a0),a0
	CALLGRAF	FreeCprList		free the copper lists 

	move.l	SS_RastPort(a4),a1
	tst.l	a1			have we got a rastport struct ?
	beq.s	Close_Screen12
	move.l	#100,d0
	CALLEXEC	FreeMem			free the rastport

Close_Screen13
	move.l	SS_View(a4),a1
	tst.l	a1			have we got a view structure ?
	beq.s	Close_Screen12
	move.l	#18,d0
	CALLEXEC	FreeMem			free the view structure
Close_Screen12
	move.l	SS_ViewPort(a4),a0
	tst.l	a0			have we got a viewport struct ?
	beq.s	Close_Screen11
	CALLGRAF	FreeVPortCopLists		free the viewport copper lists
Close_Screen11
	move.l	SS_ColorMap(a4),a0
	tst.l	a0			colour map structure ?
	beq.s	Close_Screen10
	CALLGRAF	FreeColorMap		free the colourmap structure
Close_Screen10
	move.l	SS_ViewPortExtra(a4),a0
	tst.l	a0			vpextra structure ?
	beq.s	Close_Screen9
	CALLGRAF	GfxFree			free it
Close_Screen9
	move.l	SS_MonSpec(a4),a0
	tst.l	a0			have we got a monitor spec ?
	beq.s	Close_Screen8
	CALLGRAF CloseMonitor		close the monitor spec
Close_Screen8
	move.l	SS_BitMap(a4),a1
	tst.l	a1			bitmap structure ?
	beq.s	Close_Screen7
	move.l	#40,d0
	CALLEXEC	FreeMem			free it.
Close_Screen7
	move.l	SS_Screen(a4),a1
	tst.l	a1			have we got bitplane memory ?
	beq.s	Close_Screen6
	move.l	SS_Width(a4),d0		WIDTH
	lsr.l	#3,d0			/8	
	muls.l	SS_Height(a4),d0		*HEIGHT
	muls.l	SS_Planes(a4),d0		*NPLANES
	CALLEXEC	FreeMem			free the memory
Close_Screen6
	move.l	SS_RasInfo(a4),a1
	tst.l	a1			have we got a ras info structure ?
	beq.s	Close_Screen5
	move.l	#12,d0
	CALLEXEC	FreeMem			free it
Close_Screen5
	move.l	SS_ViewPort(a4),a1
	tst.l	a1			have we got a viewport structure ?
	beq.s	Close_Screen4
	move.l	#40,d0
	CALLEXEC	FreeMem			free it.
Close_Screen4
	move.l	SS_ViewExtra(a4),a0
	tst.l	a0			have we got a view extra struct ?
	beq.s	Close_Screen3
	CALLGRAF	GfxFree			free it.
Close_Screen3	
	move.l	SS_DimensionInfo(a4),a1
	tst.l	a1			a dim info struct ?
	beq.s	Close_Screen2
	move.l	#88,d0
	CALLEXEC	FreeMem			free the memory.
Close_Screen2
	move.l	a4,a1
	move.l	#Screen_Store_SIZEOF,d0
	CALLEXEC	FreeMem			free the screen store memory.
Close_Screen1
	moveq.l	#0,d0
	rts


Init_Mask
;	allocates a maskplane to be linked into
;	a screen for the polygon filling
;	operations
;	d0.l=x_min
;	d1.l=y_min
;	d2.l=x_max
;	d3.l=y_max
;	d4=screen x
;	d5-screen y

;	returns
;	d0=maskplane address

;*** Notes This could do with some better error checking!!!

	PUSH	d0-d3			store the inputs

	move.l	#MaskPlane_SIZEOF,d0	enough space for a maskplane
	move.l	#MEMF_ANY!MEMF_CLEAR,d1	any type of memory
	CALLEXEC	AllocMem			allocate it
	
	move.l	d0,d7			store base address of the mem.

	move.l	d0,a3			get memory address

	PULL	d0-d3			inputs of stack

	move.w	d0,MP_Clip_X_Min(a3)	store min clip x 
	move.w	d1,MP_Clip_Y_Min(a3)	store min clip y
	move.w	d2,MP_Clip_X_Max(a3)	store max clip x
	move.w	d3,MP_Clip_Y_Max(a3)	store max clip y

	lsr.l	#3,d4			the bit size of the mask memory.
	muls	d5,d4			times the height of the memory

	move.l	d4,(a3)+			store the memory size in the struct

	move.l	d4,d0
	move.l	#MEMF_CHIP!MEMF_CLEAR,d1	chip memory
	
	CALLEXEC	AllocMem			allocate the mask memory

	move.l	d0,(a3)+			store the memory area
		
	move.l	d7,d0			return base address of mem.
		
	rts

Free_Mask:
;	Frees a previously allocated maskplane

;	a0.l=maskplane address returned by Init_Mask

;*** like above this could use some better error checking!!!

	move.l	a0,a5
	move.l	MP_MaskPlane(a5),a1	
	move.l	MP_PlaneSize(a5),d0
	CALLEXEC	FreeMem			free the mask memory
	
	move.l	a5,a1
	move.l	#MaskPlane_SIZEOF,d0
	CALLEXEC	FreeMem			free the maskplane structure memory
	rts

;------------------------------------------------------------------------		

;-------- Drawing routines -------------------------------------------------
;	Fill_Polygon(a0,a1,d0,d1)  	screen, vertex list, npoints, colour
;	Draw_Polygon(a0,a1,d0,d1)		screen, vertex list, npoints, colour
;	Draw_Line(a0,d0,d1,d2,d3,d4)	screen, x1, y1, x2, y2, colour		
;	Write_Pixel(a0,d0,d1,d2)		screen, x1, x2, colour

Fill_Polygon
;	a0=screen to draw onto
;	a1=list of vertices
;	d0=npoints
;	d1=colour

	PUSH	a0/d1			store the screen and number of points
	exg.l	a0,a1			swap the screen and point list.
clip:
;	clips a polygon
;	internal routine called by Fill_Polygon
;	DONT CALL THIS PROCUDURE YOURSELF

;	d0=number of points coming in
;	a0=points coming in
;	a1=screen structure

	move.l	SS_MaskPlane(a1),a6	get the maskplane address
	lea	clip_out,a2		temporary variable

; the source buffer is already in a0

	lea	MP_PointBuffer(a6),a1	initial destination buffer
	move.l	a1,a4			store this address

	clr.w	(a2)			clear the clip out variable

	move.w	d0,d7			get the number of points
	beq	clip_end			no points so jump out
	subq.w	#1,d7			sub 1 for the loop
	
	move.w	(a0)+,d5			get the first x point
	move.w	(a0)+,d6			get the first y point	
	move.w	MP_Clip_X_Min(a6),d0	get the clip value
	cmp.w	d0,d5			compare the point to the clip value

	bge.s 	xmin_save		point is in so store it
	bra.s 	xmin_update		point is out so update the temp var.

xmin_next:
	move.w	(a0)+,d3			get the next x point
	move.w	(a0)+,d4			get the next y point
	move	d3,d5			store these values
	move	d4,d6

	sub.w	d0,d3			subtract the clip value
	bge.s	xmin_x2in		the point is in so check the other

;	the point must be outside so check the other point

	sub.w	d0,d1			subtract the clip value
	blt.s	xmin_update		do this if both points are outside

;	if we get to here then the first point is outside but the 
; 	second is inside so we have to clip the line

	beq.s	.yint_out
	
	movem	d5/d6,-(sp)		store d5 and d6
.yint_in	move.w	d2,d6			store the first y coord
	add.w	d4,d6			add the second y coordinate onto this
	asr.w	#1,d6			divide this by 2
	move.w	d1,d5			get the x difference into d5
	add.w	d3,d5			add the first x onto this
	asr.w	#1,d5			divide this by 2
	beq.s	.yint_end		if this is 0 we have the intersect
	bgt.s	.yint_loop		greater than 0 so off we go
;	less than zero
	move.w	d5,d3			the x value goes into d3
	move.w	d6,d4			the y value goes into d4
	bra.s	.yint_in			iterate backwards
.yint_loop:	
	move.w	d5,d1			the x value goes into d1
	move.w	d6,d2			y into d2
	bra.s	.yint_in			iterate backwards
.yint_end:
	move.w	d0,(a1)+			store the x value
	move.w	d6,(a1)+			store the intersect value
	addq.w	#1,(a2)			increment the counter.
	movem	(sp)+,d5/d6		pull the contents off the stack.
.yint_out:

	bra.s	xmin_update		update the temp variables.

xmin_x2in:
;	the first point is in so check the second

	sub.w	d0,d1			subtract the clip value
	bge.s	xmin_save		the point is in so save

	tst.w	d3    			check if d3 is 0		
	beq.s	.yint_out		it is so jump off.

	movem	d5/d6,-(sp)		store d5 and d6
.yint_in	move.w	d4,d6			store the first y coord
	add.w	d2,d6			add the second y coordinate onto this
	asr.w	#1,d6			divide this by 2
	move	d3,d5			get the x difference into d5
	add.w	d1,d5			add the first x onto this
	asr.w	#1,d5			divide this by 2
	beq.s	.yint_end		if this is 0 we have the intersect
	bgt.s	.yint_loop		greater than 0 so off we go
;	less than zero
	move	d5,d1			the x value goes into d3
	move	d6,d2			the y value goes into d4
	bra.s	.yint_in			iterate backwards
.yint_loop:
	move	d5,d3			the x value goes into d1
	move	d6,d4			y into d2
	bra.s	.yint_in			iterate backwards
.yint_end:
	move.w	d0,(a1)+			store the x value
	move.w	d6,(a1)+			store the intersect value
	addq.w	#1,(a2)			increment the counter.
	movem	(sp)+,d5/d6		pull the contents off the stack.
.yint_out:

xmin_save:
	move.w	d5,(a1)+			store the x coordinate
	move.w	d6,(a1)+			store the y coordinate
	addq.w	#1,(a2)			increment the counter
xmin_update:
	move	d5,d1			move x into the other x
	move	d6,d2			move the y into the other one
	dbf	d7,xmin_next		loop back.

	tst.w	(a2)			check if there are no points.
	beq.s	clip_xmax		no points so jump off.

	subq.w	#4,a1			check if the first and last
	cmpm.l	(a4)+,(a1)+		points are the same
	beq.s	clip_xmax		if they aren't copy the 
	move.l	-(a4),(a1)		first to the last point and 
	addq.w	#1,(a2)			increment the counter.

clip_xmax:
	lea	MP_PointBuffer(a6),a0	source buffer
	lea	MP_PointBuffer2(a6),a1	destination buffer
	move.l	a1,a4

	move.w	(a2),d7
	beq	clip_ymin		no points so don't waste time
	subq.w	#1,d7			decrement the counter

	clr.w	(a2)			clear the temporary variable
	
	move.w	(a0)+,d5			get the first x point
	move.w	(a0)+,d6			get the first y point
	move.w	MP_Clip_X_Max(a6),d0	get the clip value
	cmp.w	d5,d0			compare the point to the clip value

	bge.s 	xmax_save		point is in so store it
	bra.s	xmax_update		point is out so update the temp var.

xmax_next:
	move.w	(a0)+,d3			get the next x point
	move.w	(a0)+,d4			get the next y point
	move	d3,d5			store these values
	move	d4,d6

	sub.w	d0,d3			subtract the clip value
	neg.w	d3			negate the distance
	bge.s	xmax_x2in		the point is in so check the other

;	the point must be outside so check the other point

	sub.w	d0,d1			subtract the clip value
  	neg.w	d1			negate the distance
	blt.s	xmax_update		do this if both points are outside

;	if we get to here then the first point is outside but the 
; 	second is inside so we have to clip the line

	beq.s	.yint_out

	movem	d5/d6,-(sp)		store d5 and d6
.yint_in	move.w	d2,d6			store the first y coord
	add.w	d4,d6			add the second y coordinate onto this
	asr.w	#1,d6			divide this by 2
	move	d1,d5			get the x difference into d5
	add.w	d3,d5			add the first x onto this
	asr.w	#1,d5			divide this by 2
	beq.s	.yint_end		if this is 0 we have the intersect
	bgt.s	.yint_loop		greater than 0 so off we go
;	less than zero
	move	d5,d3			the x value goes into d3
	move	d6,d4			the y value goes into d4
	bra.s	.yint_in			iterate backwards
.yint_loop:	
	move	d5,d1			the x value goes into d1
	move	d6,d2			y into d2
	bra.s	.yint_in			iterate backwards
.yint_end:
	move.w	d0,(a1)+			store the x value
	move.w	d6,(a1)+			store the intersect value
	addq.w	#1,(a2)			increment the counter.
	movem	(sp)+,d5/d6		pull the contents off the stack.
.yint_out:

	bra.s	xmax_update		update the temp variables.

xmax_x2in:
;	the first point is in so check the second

	sub.w	d0,d1			subtract the clip value
	neg.w	d1			negate the distance		
	bge.s	xmax_save		the point is in so save

	tst.w	d3     			check if d3 is 0
	beq.s	.yint_out		it is so jump off.

	movem	d5/d6,-(sp)		store d5 and d6
.yint_in	move.w	d4,d6			store the first y coord
	add.w	d2,d6			add the second y coordinate onto this
	asr.w	#1,d6			divide this by 2
	move	d3,d5			get the x difference into d5
	add.w	d1,d5			add the first x onto this
	asr.w	#1,d5			divide this by 2
	beq.s	.yint_end		if this is 0 we have the intersect
	bgt.s	.yint_loop		greater than 0 so off we go
;	less than zero
	move	d5,d1			the x value goes into d3
	move	d6,d2			the y value goes into d4
	bra.s	.yint_in			iterate backwards
.yint_loop:
	move	d5,d3			the x value goes into d1
	move	d6,d4			y into d2
	bra.s	.yint_in			iterate backwards
.yint_end:
	move.w	d0,(a1)+			store the x value
	move.w	d6,(a1)+			store the intersect value
	addq.w	#1,(a2)			increment the counter.
	movem	(sp)+,d5/d6		pull the contents off the stack.
.yint_out:

xmax_save:
	move.w	d5,(a1)+			store the x coordinate
	move.w	d6,(a1)+			store the y coordinate
	addq.w	#1,(a2)			increment the counter
xmax_update:
	move	d5,d1			move x into the other x
	move	d6,d2			move the y into the other one
	dbf	d7,xmax_next		loop back.

	tst.w	(a2)			check if there are no points.
	beq.s	clip_ymin		no points so jump off.

	subq	#4,a1			check if the first and las
	cmpm.l	(a4)+,(a1)+		points are the same
	beq.s	clip_ymin		if they aren't copy the
	move.l	-(a4),(a1)		first to the last point and
	addq.w	#1,(a2)			increment the counter.

clip_ymin:
	lea	MP_PointBuffer2(a6),a0	source buffer
	lea	MP_PointBuffer(a6),a1	destination buffer
	move.l	a1,a4

	move.w	(a2),d7			counter into d7
	beq	clip_ymax		no points to do ? so jump off
	subq.w	#1,d7			decrement the counter

	clr.w	(a2)			clear the clip out variable

	move.w	(a0)+,d5			get the first x point
	move.w	(a0)+,d6			get the first y point
	move.w	MP_Clip_Y_Min(a6),d0	get the clip value	
	cmp.w	d0,d6			compare the point to the clip value

	bge.s	ymin_save		point is in so store it
	bra.s  	ymin_update		point is out so update the temp var.

ymin_next:
	move.w	(a0)+,d3			get the next x point
	move.w	(a0)+,d4			get the next y point
	move	d3,d5			store these values
	move	d4,d6

	sub.w	d0,d4			subtract the clip value
	bge.s	ymin_y2in		the point is in so check the other

;	the point must be outside so check the other point
	
	sub.w	d0,d2			subtract the clip value
	blt.s	ymin_update		do this if both points are outside
;	if we get to here then the first point is outside but the 
; 	second is inside so we have to clip the line

	beq.s	.xint_out

	movem	d5/d6,-(sp)		store d5 and d6
.xint_in	move.w	d1,d5			store the first x coordinate
	add.w	d3,d5			add on the second x coordinate
	asr.w	#1,d5			divide this by 2
	move.w 	d2,d6			get the y difference into d6
	add.w	d4,d6			add the second y coordinate
	asr.w	#1,d6			divide this by 2
	beq.s	.xint_end		if this is 0 we have the intersect
	bgt.s	.xint_loop		greater than 0 so off we go
;	less than zero
	move.w	d6,d4			the y value goes into d4
	move.w	d5,d3 			the x value goes into d3
	bra.s	.xint_in 		iterate backwards
.xint_loop:
	move.w	d5,d1			the y value into d1
	move.w	d6,d2			x into d2
	bra.s	.xint_in			iterate backwards

.xint_end:	
	move.w	d5,(a1)+			store the intersect value
	move.w	d0,(a1)+			store the clip value
	addq.w	#1,(a2)			increment the counter
	movem	(sp)+,d5/d6		pull the contents off the stack.		
.xint_out

	bra.s	ymin_update		update the temp variables.

ymin_y2in:
;	the first point is in so check the second

	sub.w	d0,d2			subtract the clip value
	bge.s	ymin_save		the point is in so save

	tst.w	d4			check if d3 is 0
	beq.s	.xint_out		it is so jump off.

	movem	d5/d6,-(sp)		store d5 and d6
.xint_in	move	d3,d5			store the second x coord
	add.w	d1,d5			add the first x coordinate onto this
	asr.w	#1,d5			divide this by 2
	move 	d4,d6			get the y difference
	add.w	d2,d6			add on the first y coordinate
	asr.w	#1,d6			divide this by 2
	beq.s	.xint_end		if this is 0 we have the intersect
	bgt.s	.xint_loop		greater than 0 so off we go
;	less than zero
	move	d6,d2			the y value into d2
	move	d5,d1 			x into d1
	bra.s	.xint_in 		iterate backwards
.xint_loop:
	move	d5,d3			x into d3
	move	d6,d4			y into d4
	bra.s	.xint_in			iterate backwards.

.xint_end:	
	move.w	d5,(a1)+			store the x value
	move.w	d0,(a1)+			store the intersect value
	addq.w	#1,(a2)			increment the counter.
	movem	(sp)+,d5/d6		pull the contents off the stack.
.xint_out

ymin_save:
	move.w	d5,(a1)+			store the x coordinate
	move.w	d6,(a1)+			store the y coordinate
	addq.w	#1,(a2)			increment the counter

ymin_update:
	move	d5,d1			move x into the other x
	move	d6,d2			move the y into the other one
	dbf	d7,ymin_next		loop back.

	tst.w	(a2)			check if there are no points.
	beq.s	clip_ymax		no points so jump off.

	subq	#4,a1			check if the first and last
	cmpm.l	(a4)+,(a1)+		points are the same
	beq.s	clip_ymax		if they aren't copy the
	move.l	-(a4),(a1)		first to the last point and
	addq.w	#1,(a2)			increment the counter.
 
clip_ymax: 
	lea	MP_PointBuffer(a6),a0	source buffer
	lea	MP_PointBuffer2(a6),a1	destination buffer
	move.l	a1,a4

	move.w	(a2),d7			no points so don't waste time
	beq	clip_end			
	subq.w	#1,d7			decrement the counter

	clr.w	(a2)			clear the temporary variable

 	move.w	(a0)+,d5			get the first x point
	move.w	(a0)+,d6			get the first y point
	move.w	MP_Clip_Y_Max(a6),d0	get the clip value
	cmp.w	d6,d0			compare the point to the clip value

	bge.s	ymax_save		point is in so store it
	bra.s	ymax_update		point is out so update the temp var.

ymax_next:
	move.w	(a0)+,d3			get the next x point
	move.w	(a0)+,d4			get the next y point
	move	d3,d5			store these values
	move	d4,d6

	sub.w	d0,d4			subtract the clip value
	neg.w	d4			negate the distance
	bge.s	ymax_y2in		the point is in so check the other	

;	the point must be outside so check the other point

	sub.w	d0,d2			subtract the clip value
	neg.w	d2			negate the distance
	blt.s	ymax_update		do this if both points are outside

;	if we get to here then the first point is outside but the 
; 	second is inside so we have to clip the line

	beq.s	.xint_out

	movem	d5/d6,-(sp)		store d5 and d6
.xint_in	move	d1,d5			store the first x coordinate
	add.w	d3,d5			add the second x onto this
	asr.w	#1,d5			divide this by 2
	move 	d2,d6			get the y distance 
	add.w	d4,d6			add on the second y coord
	asr.w	#1,d6			divide this by 2
	beq.s	.xint_end		if this is 0 we have the intersect
	bgt.s	.xint_loop		greater than 0 so off we go
;	less than zero
	move	d6,d4			the y value goes into d4
	move	d5,d3 			the x value goes into d3
	bra.s	.xint_in 		iterate backwards
.xint_loop:
	move	d5,d1			the x value goes into d1
	move	d6,d2			y into d2
	bra.s	.xint_in			iterate backwards
.xint_end:	
	move.w	d5,(a1)+			store the x value
	move.w	d0,(a1)+			store the intersect value
	addq.w	#1,(a2)			increment the counter.
	movem	(sp)+,d5/d6		pull the contents off the stack.
.xint_out

	bra.s	ymax_update		update the temp variables.

ymax_y2in:
;	the first point is in so check the second

	sub.w	d0,d2			subtract the clip value
	neg.w	d2			negate the distance
	bge.s	ymax_save		the point is in so save

;x_intercept:
	tst.w	d4			check if d3 is 0
	beq.s	.xint_out		it is so jump off.

	movem	d5/d6,-(sp)		store d5 and d6
.xint_in	move	d3,d5			store the second x coord
	add.w	d1,d5			add the first x coordinate onto this
	asr.w	#1,d5			divide this by 2
	move 	d4,d6			get the y difference
	add.w	d2,d6			add on the first y coordinate
	asr.w	#1,d6			divide this by 2
	beq.s	.xint_end		if this is 0 we have the intersect
	bgt.s	.xint_loop		greater than 0 so off we go
;	less than zero
	move	d6,d2			the y value into d2
	move	d5,d1 			x into d1
	bra.s	.xint_in 		iterate backwards
.xint_loop:
	move	d5,d3			x into d3
	move	d6,d4			y into d4
	bra.s	.xint_in			iterate backwards.
.xint_end:		
	move.w	d5,(a1)+			store the x value
	move.w	d0,(a1)+			store the intersect value
	addq.w	#1,(a2)			increment the counter.
	movem	(sp)+,d5/d6		pull the contents off the stack.
.xint_out

ymax_save:
	move.w	d5,(a1)+			store the x coordinate
	move.w	d6,(a1)+			store the y coordinate
	addq.w	#1,(a2)			increment the counter

ymax_update:
	move	d5,d1			move x into the other x	
	move	d6,d2			move the y into the other one
	dbf	d7,ymax_next		loop back.
	
	tst.w	(a2)			check if there are no points.
	beq.s	clip_end			no points so jump off.
	
	subq	#4,a1			check if the first and last
	cmpm.l	(a4)+,(a1)+		points are the same
	beq.s	clip_end			if they aren't copy the
	move.l	-(a4),(a1)		first to the last point and
	addq.w	#1,(a2)			increment the counter.

clip_end:
	lea	MP_PointBuffer2(a6),a1	the final resting place of the polygon
	move.w	(a2),d0			get the number of points
	cmp.w	#1,d0			only one point ?
	bne.s	clip_poly		no so jump off
	move.w	#0,d0			if yes we don't bother drawing it.
clip_poly
	PULL	a0/d1			

	tst.w	d0			check if we have any points
	beq	Fill_Poly_Done		no then don't bother drawing

	move.w	SS_Height+2(a0),y_min	this section is used to calculate
	move.w	#0,y_max			the boundaries of the polygon
	move.w	SS_Width+2(a0),x_min	
	move.w	#0,x_max

	move.b	d1,-(sp)			store the colour value.

	move.w	d0,d7			number of points.
	subq.w	#2,d7			subtract 2
	
	move.l	a1,a2			store the base address of the points
	
	move.w	(a1)+,d2			first x point
	move.w	(a1)+,d3			first y point
Fill_Poly_Loop	
	move.w	d2,d0			move the points into the other pos
	move.w	d3,d1
	move.w	(a1)+,d2			get the next x point
	move.w	(a1)+,d3			get the next y point
	
	cmp.w	x_min,d0			this section is used to calculate
	bgt.s	x_great_x_min		the boundaries of the polygon
	move.w	d0,x_min			it works by checking the maximum
x_great_x_min:				 
	cmp.w	x_max,d0			and minimum x and y values and
	blt.s	x_check_done		updating the variables accordingly.	
	move.w	d0,x_max		
x_check_done
	cmp.w	y_min,d1
	bgt.s	y_great_y_min
	move.w	d1,y_min
y_great_y_min
	cmp.w	y_max,d1
	blt.s	y_check_done	
	move.w	d1,y_max		
y_check_done

	movem.l	d2-d7/a0-a1,-(sp)		store lots of variables on the stack.

Fill_Line
;	Draws a line for filling a polygon
;	internal routine DONT CALL!!!!
;	d0,d1=x1,y1
;	d2,d3=x2,y2

;	a0=screen structure

; *** 	This line drawing routine bashes the hardware quite violently.
; ***    It is not my work but is taken from the How To Code 7 manual.
; *** 	Thank you to those responsible for it!

	CALLGRAF	OwnBlitter
	
	lea	$dff000,a6
	move.l	SS_Width(a0),d6
	lsr.w	#3,d6				
	move.l	SS_MaskPlane(a0),a0
	move.l	MP_MaskPlane(a0),a0
	cmp.w   	d1,d3
        	beq   	noline
        	ble.s   	lin1
        	exg     	d1,d3
        	exg     	d0,d2
lin1:   	sub.w   	d2,d0
        	move.w  	d2,d5
        	asr.w   	#3,d2
        	ext.l   	d2
        	sub.w   	d3,d1
        	muls    	d6,d3       	
        	add.l   	d2,d3
        	add.l   	d3,a0
        	and.w   	#$f,d5
        	move.w  	d5,d2
        	eor.b   	#$f,d5
        	ror.w   	#4,d2
        	or.w    	#$0b4a,d2
        	swap    	d2
        	tst.w   	d0
        	bmi.s   	lin2
        	cmp.w   	d0,d1
        	ble.s   	lin3
        	move.w  	#$41,d2
        	exg     	d1,d0
        	bra.s   	lin6
lin3:   	move.w  	#$51,d2
        	bra.s   	lin6
lin2:   	neg.w   	d0
        	cmp.w   	d0,d1
        	ble.s   	lin4
        	move.w  	#$49,d2
        	exg     	d1,d0
        	bra.s   	lin6
lin4:   	move.w  	#$55,d2
lin6:   	asl.w   	#1,d1
        	move.w  	d1,d4
        	move.w  	d1,d3
        	sub.w   	d0,d3
        	ble.s   	lin5
        	and.w   	#$ffbf,d2
lin5:   	move.w  	d3,d1
        	sub.w   	d0,d3
        	or.w    	#2,d2
        	lsl.w   	#6,d0
        	add.w   	#$42,d0
bltwt:  	btst    	#6,2(a6)
        	bne.s   	bltwt
        	bchg    	d5,(a0)
        	move.l  	d2,bltcon0(a6)
        	move.l  	#-1,bltafwm(a6)
        	move.l  	a0,bltcpt(a6)
        	move.w  	d1,bltapt+2(a6)
        	move.l  	a0,bltdpt(a6)
        	move.w  	d6,bltcmod(a6)   ;width
        	move.w  	d4,bltbmod(a6)
        	move.w  	d3,bltamod(a6)
        	move.w  	d6,bltdmod(a6)   ;width
        	move.l  	#-$8000,bltbdat(a6)
        	move.w  	d0,bltsize(a6)
noline: 	
	CALLGRAF	DisownBlitter

	movem.l	(sp)+,d2-d7/a0-a1		values off the stack

	dbra	d7,Fill_Poly_Loop		branch back till all lines are done

	move.l	a0,a4

	move.w	x_max,d0			calculate the offset into the bitmap
	lsr.w	#4,d0			of the polygon in terms of the 
	move.w	d0,d2			calue that the blitter wants
	add.w	d2,d2
	move.w	y_max,d1
	mulu	#40,d1
	add.w	d2,d1
	move.w	d1,bltstrt

	move.l	SS_Width(a0),d6
	lsr.l	#3,d6			byte width of the screen
	move.l	SS_MaskPlane(a0),a0
	move.l	MP_MaskPlane(a0),a0

	add.w	d1,a0			this is the address of the first word
					;of the polygon

	move.w	x_min,d1			calculate the width of the polygon
	lsr.w	#4,d1			in terms of a value that the 
	sub.w	d1,d0			blitter likes
	addq.w	#1,d0
	move.w	d0,bltwidth		

	move.w	d6,d2			calculate the blit modulo
	add.w	d0,d0
	sub.w	d0,d2
	move.w	d2,blitmod		

	move.w	y_max,d0			calculate the size of the polygon
	sub.w	y_min,d0			for the blitter
	addq.w	#1,d0
	lsl.w	#6,d0
	add.w	bltwidth,d0
	move.w	d0,blitsize

	CALLGRAF	OwnBlitter		This section fills in the polygon
					;using the blitter fill mode
	CALLGRAF	WaitBlit

	move.l	#$dff000,a5

	move.l	a0,bltapt(a5)
	move.l	a0,bltdpt(a5)

	move.w	d2,bltamod(a5)
	move.w	d2,bltdmod(a5)
	move.w	#%0000100111110000,bltcon0(a5)
	move.w	#%0000000000001010,bltcon1(a5)	
	move.l	#$ffffffff,bltafwm(a5)
	move.w	blitsize,bltsize(a5)

pln_copy:
;	This section copies the polygon from the maskplane 
;	to the desination plane memory using the blitter.

	move.l	SS_Screen(a4),a0
	adda.w	bltstrt,a0
	move.l	SS_Planes(a4),d7		
	subq.l	#1,d7

	move.w	blitmod,d0

;	Get the colour off the stack into d6

	move.b	(sp)+,d6
	extb.l	d6

; 	Set the initial values for the blitter
	
	CALLGRAF	WaitBlit
	move.w	#$0002,bltcon1(a5)
	move.w	d0,bltamod(a5)
	move.w	d0,bltbmod(a5)
	move.w	d0,bltdmod(a5)
	move.l	SS_MaskPlane(a4),a1
	move.l	MP_MaskPlane(a1),a1

	add.w	bltstrt,a1
	move.w	blitsize,d2

nxtplane:

;	The loop for the plane copy

	CALLGRAF	WaitBlit
	move.l	a1,bltapt(a5)
	move.l	a0,bltbpt(a5)
	move.l	a0,bltdpt(a5)

; 	shift the colour bit right
; 	if the carry bit is clear we want to clear the destination memory
; 	else we want to fill it


	lsr.w	#1,d6 
	bcc.s	bltclr

	move.w	#%0000110111111100,bltcon0(a5)	11011111100

	bra.s	bltcopy

bltclr:
	move.w	#%0000110100001100,bltcon0(a5)

bltcopy:
;	do the copy to destination memory

	move.w	d2,bltsize(a5)

;	increment the plane pointer

	move.l	SS_Width(a4),d0
	lsr.l	#3,d0
	muls.l	SS_Height(a4),d0
	add.l	d0,a0  

; 	loop back to the number of planes

	dbf	d7,nxtplane

	CALLGRAF	DisownBlitter

;	clear the section of the maskplane occupied by the polygon
;	using the blitter

	CALLGRAF	OwnBlitter
	CALLGRAF	WaitBlit
	move.l	a1,bltdpt(a5)
	move.w	blitmod,bltdmod(a5)
	move.w	#$0002,bltcon1(a5)
	move.w	#$100,bltcon0(a5)
	move.w	blitsize,bltsize(a5)
  	CALLGRAF	DisownBlitter

Fill_Poly_Done
	rts
	




Draw_Polygon
;	a0=screen to draw onto
;	a1=list of vertices
;	d0=npoints
;	d1=colour

	move.b	d1,-(sp)		colour onto the stack

	move.w	d0,d7		number of points onto counter
	subq.w	#2,d7		decrement d7
	
	move.l	a1,a2		store vertex list
	
	move.w	(a1)+,d2		get first point
	move.w	(a1)+,d3
Poly_Loop	
	move.w	d2,d0		prev point onto first coords
	move.w	d3,d1
	move.w	(a1)+,d2		get next point
	move.w	(a1)+,d3
	
	move.b	(sp)+,d4		colour off stack
	
	movem.l	d2-d7/a0-a1,-(sp)

	bsr.s	Draw_Line	draw the line.

	movem.l	(sp)+,d2-d7/a0-a1

	move.b	d4,-(sp)		colour onto stack

	dbra	d7,Poly_Loop	loop back to all lines

	move.b	(sp)+,d4		restore stack
Poly_Done
	rts

Draw_Line
;	Draws a line
;	d0,d1=x1,y1
;	d2,d3=x2,y2
;	d4=colour

;	a0=screen structure

; ***	Unlike the fill_polygon procedure this routine uses the bresenham 
; *** 	line drawing algorithm.

	move.b	d4,-(sp)

	moveq.w	#1,d6		d6=IC
	
	cmp.w	d1,d3		(y2-y1)=dy
	bgt.s	ascend		branch if slope>0
	
;	the line must be descending so swap the vertices

	exg	d0,d2		exchange x1 and x2
	exg	d1,d3		exchange y1 and y2

ascend	sub.w	d1,d3		dy is now +ve

	sub.w	d0,d2		(x2-x1)=dx
	bgt.s	pos_slope	branch if the slope is +ve	

;	the slope must be -ve so make ic -ve

	neg.w	d6
	neg.w	d2		now dx is +ve

pos_slope
	cmp.w	d2,d3		test dy-dx
	bgt.s	HiSlope		slope is >1		
	
;	the slope is <1 so increment x each time and check y
;	d0=xs, d1=ys, d2=dx, d3=dy

	move.w	d3,d5		dy into d5	
	add.w	d5,d5		error1

	move.w	d5,d7		2*dy into d7

	move.w	d2,d4		dx into d4
	add.w	d4,d4		2*dx
	
	sub.w	d4,d7		2*dy-2*dx
	
	move.w	d7,d4		error2

	move.w	d2,d7		dx as the counter
	subq.w	#1,d7		dx-1
		
	add.w	d3,d3		2*dy
	sub.w	d2,d3		(2*dy)-dx:-initial value of D
	
	move.b	(sp)+,d2
	
line_loop1
	tst.w	d3		test error		
	bpl.s	inc_y_and_x
	add.w	d6,d0		add ic onto xs
	add.w	d5,d3		increment error
	bra.s	point_1
inc_y_and_x	
	add.w	d6,d0		add ic onto xs
	addq.w	#1,d1		increment ys
	add.w	d4,d3		increment error
point_1 
	PUSHALL
	cmp.w	#0,d0		check x minimum
	bmi.s	no_line_point_1

	cmp.w	SS_Width+2(a0),d0
	bpl.s	no_line_point_1

	cmp.w	#0,d1
	bmi.s	no_line_point_1
	
	cmp.w	SS_Height+2(a0),d1
	bpl.s	no_line_point_1
	
	move.l	a0,a1
	bsr.s	Write_Pixel
no_line_point_1
	PULLALL	

	dbra	d7,line_loop1
	rts
HiSlope
;	the line slope>1 so increment y and check for x
;	d0=xs, d1=ys, d2=dx, d3=dy

	move.w	d2,d5		dx into d5	
	add.w	d5,d5		error1

	move.w	d5,d7		2*dx into d7

	move.w	d3,d4		dy into d4
	add.w	d4,d4		2*dy
	
	sub.w	d4,d7		2*dx-2*dy
	
	move.w	d7,d4		error2

	move.w	d3,d7		dy as the counter
	subq.w	#1,d7		dy-1
		
	add.w	d2,d2		2*dx
	sub.w	d3,d2		(2*dx)-dy:-initial value of D
	
	move.b	(sp)+,d3
	
line_loop2
	tst.w	d2		test error		
	bpl.s	inc_y
	addq.w	#1,d1		add ic onto xs
	add.w	d5,d2		increment error
	bra.s	point_2
inc_y	
	add.w	d6,d0		add ic onto xs
	addq.w	#1,d1		increment ys
	add.w	d4,d2		increment error
point_2
		
	PUSHALL
	cmp.w	#0,d0		check x minimum
	bmi.s	no_line_point_2

	cmp.w	SS_Width+2(a0),d0
	bpl.s	no_line_point_2

	cmp.w	#0,d1
	bmi.s	no_line_point_2
	
	cmp.w	SS_Height+2(a0),d1
	bpl.s	no_line_point_2

	move.b	d3,d2
	move.l	a0,a1
	bsr.s	Write_Pixel
no_line_point_2
	PULLALL	

	dbra	d7,line_loop2	
	rts
	

Write_Pixel:
;	Duuuuuuuhhhhhhhhhhn
;	
;	input:-	d0=x,d1=y
;		d2=colour
;		a0=destination screen struct

;	probably not as tidy as other write pixels but it has
;	to be like this for clipping

	PUSHALL

	move.l	a0,a5

	move.l	SS_Screen(a5),a0

	move.l	SS_Width(a5),d3
	lsr.l	#3,d3		byte width of a screen

	muls.l	d3,d1

	move.w	d0,d3
	lsr.w	#3,d0		byte offset into the bitplane
	add.w	d1,d0
		
	andi.w	#%0000000000000111,d3	
	subq.w	#7,d3
	neg.w	d3		bit offset of pixel

	move.l	SS_Planes(a5),d6
	subq.l	#1,d6
	add.w	d0,a0		the destination byte in the bitmap
pcol
	lsr.w	d2		rotate the colour right
	bcc.s	clrpoint		carry clear = clear point
			
	bset	d3,(a0)
	bra.s	ploop
clrpoint
	bclr	d3,(a0)
ploop
	move.l	SS_Width(a5),d0
	lsr.l	#3,d0
	muls.l	SS_Height(a5),d0
	add.l	d0,a0		increment onto next plane

	dbra	d6,pcol		loop back

	PULLALL

	rts

Screen_Clear
;	clears a screen using the Blit Clear routine
;	Should be self explanatory

;	a0=screen structure

	move.l	a0,a5
	move.l	SS_Screen(a5),a1
	move.l	SS_Width(a5),d0
	lsr.l	#3,d0
	muls.l	SS_Height(a5),d0
	muls.l	SS_Planes(a5),d0
	move.l	#1,d1
	CALLGRAF	BltClear
	rts

;---------------------------------------------------------------------


;-------- Fade Routines------------------------------------------------
;	Fade_To_White(a0,a1)	source screen,source colourmap
;	Fade_To_Black(a0,a1)	source screen,source colourmap
;	Fade(a0,a1,a2)		screen,source,destination

Fade_To_White
;	Fades the screen to White and sets the colormap
;	a0=screen
;	a1=colortable

	move.l	a0,a5		store the screen
	move.l	a1,a2		store the colortable
White_Main_Loop
	move.l	a2,a0		get the colortable
	sf	fade_flag	set the fade flag to false
	move.w	(a0),d7		get the number of colurs
	ext.l	d7		extend to longword
	subq.l	#1,d7		-1 for dbra
	addq.l	#4,a0		point to first colour value
White_Fader_Loop
	move.l	(a0),d0		colour red component
	cmp.l	#$ffffffff,d0	full on ?
	beq.s	White_red_done	yes, so don't increment value
	add.l	#$01010101,d0	else increment red component
	move.l	d0,(a0)		store the new value
	st	fade_flag	signal that we have made changes
White_red_done
	addq.l	#4,a0		offset to blue value
	move.l	(a0),d0		get the blue component 
	cmp.l	#$ffffffff,d0	full on ?
	beq.s	White_blue_done	yes so don't change
	add.l	#$01010101,d0	else increment value
	move.l	d0,(a0)		store the new value
	st	fade_flag	signal change
White_blue_done
	addq.l	#4,a0		same here as above but for green
	move.l	(a0),d0		components
	cmp.l	#$ffffffff,d0
	beq.s	White_green_done
	add.l	#$01010101,d0
	move.l	d0,(a0)
	st	fade_flag		
White_green_done
	addq.l	#4,a0		point to next full colour

;	loop for all colours

	dbra	d7,White_Fader_Loop

; 	If this flag isn't set we are all done so exit out

	tst.b	fade_flag
	beq.s	White_fade_done

;	else load the new values into the viewport

	move.l	SS_ViewPort(a5),a0
	move.l	a2,a1
	CALLGRAF	LoadRGB32

	CALLGRAF	WaitTOF

	bra	White_Main_Loop

White_fade_done	
	rts


Fade_To_Black
;	Fades the screen to black and clears the colormap
;	operates in a similar way to the above procedure
;	but instead of incrementing the colour values we decrement them.

;	a0=screen
;	a1=source colourmap

	move.l	a1,a2
	move.l	a0,a5
	
Black_Main_Loop
	move.l	a2,a0
	sf	fade_flag
	move.w	(a0),d7
	ext.l	d7
	subq.l	#1,d7
	addq.l	#4,a0
Black_Fader_Loop
	move.l	(a0),d0
	beq.s	black_red_done
	sub.l	#$01010101,d0
	move.l	d0,(a0)
	st	fade_flag
black_red_done
	addq.l	#4,a0
	move.l	(a0),d0
	beq.s	black_blue_done
	sub.l	#$01010101,d0	
	move.l	d0,(a0)
	st	fade_flag
black_blue_done
	addq.l	#4,a0
	move.l	(a0),d0
	beq.s	black_green_done
	sub.l	#$01010101,d0
	move.l	d0,(a0)
	st	fade_flag		
black_green_done
	addq.l	#4,a0
	dbra	d7,Black_Fader_Loop

	tst.b	fade_flag
	beq.s	black_fade_done
	
	move.l	SS_ViewPort(a5),a0
	move.l	a2,a1
	CALLGRAF	LoadRGB32

	CALLGRAF	WaitTOF

	bra	Black_Main_Loop

black_fade_done	
	rts

Fade
;	fades between 2 colourmaps
;	a0=screen
;	a1=source cmap
;	a2=destination cmap

	move.l	a0,a5

	move.l	a2,a3
	move.l	a1,a2

	move.l	SS_Planes(a5),d1	allocate a temporary colourmap
	move.l	#0,d0		for the fading
	bset	d1,d0
	muls	#12,d0
	add.l	#8,d0
	move.l	d0,d3	
	move.l	#MEMF_ANY,d1
	CALLEXEC	AllocMem
	move.l	d0,a4		storage for temporary cmap

	move.l	a2,a0		copy the initial colourmap to the
	move.l	a4,a1		temporary one
	move.l	d3,d0
	CALLEXEC	CopyMem


Fader_Main_Loop

	move.l	a5,-(sp)		store the screen structure

	move.l	a4,a5		temporary cmap into a5
	
	move.l	a2,a0		both cmaps to temporary areas
	move.l	a3,a1

	sf	fade_flag	clear the fade flag

	move.w	(a0),d7		number of colours
	ext.l	d7		extend to longword
	subq.l	#1,d7
	addq.l	#4,a5		update the cmaps to first colour
	addq.l	#4,a1
Fader_Loop
	move.l	(a5),d0		source colour
	move.l	(a1),d1		destination colour
	cmp.l	d0,d1		compare the 2
	beq.s	red_done		if they are equal we are done
	bcs.s	decrement_red	less so decrement the value
increment_red
;	if we get to here we want to increment the value
	add.l	#$01010101,d0
	bra.s	put_red	
decrement_red
	sub.l	#$01010101,d0	decrement the value
put_red
	move.l	d0,(a5)		store the flag
	st	fade_flag	set the status flag
red_done
	addq.l	#4,a5		next component
	addq.l	#4,a1

	move.l	(a5),d0		does the same as above but for the
	move.l	(a1),d1		blue components
	cmp.l	d0,d1
	beq.s	blue_done
	bcs.s	decrement_blue
increment_blue
	add.l	#$01010101,d0
	bra.s	put_blue
decrement_blue
	sub.l	#$01010101,d0	
put_blue
	move.l	d0,(a5)
	st	fade_flag
blue_done
	addq.l	#4,a5
	addq.l	#4,a1

	move.l	(a5),d0		does the same but for green components
	move.l	(a1),d1
	cmp.l	d0,d1
	beq.s	green_done
	bcs.s	decrement_green
increment_green
	add.l	#$01010101,d0
	bra.s	put_green
decrement_green
	sub.l	#$01010101,d0
put_green
	move.l	d0,(a5)
	st	fade_flag		
green_done
	addq.l	#4,a5
	addq.l	#4,a1
	dbra	d7,Fader_Loop

	move.l	(sp)+,a5

	tst.b	fade_flag
	beq.s	fade_done

	move.l	SS_ViewPort(a5),a0
	move.l	a4,a1
	CALLGRAF	LoadRGB32

	CALLGRAF	WaitTOF
	bra	Fader_Main_Loop

fade_done	

	move.l	SS_Planes(a5),d1
	move.l	#0,d0
	bset	d1,d0
	muls	#12,d0
	add.l	#8,d0
	move.l	d0,d3
	move.l	a4,a1
	CALLEXEC	FreeMem			free the temporary map

	rts

;---------------------------------------------------------------------

;-------- IFF Handling routines reading and writing of bitmaps ---------
;	Save_IFF(a0,a1)=filename APTR, screen ADDR
;	Load_IFF(a0,a1)=filename APTR, screen ADDR

;	These procedures use the IFF_Library v23.2 by CHRISTIAN A. WEBE
;	For more information please see the distribution along
;	with this file

Load_IFF
;	loads an iff into one a screen
;	a0=filename
;	a1=destination screen structure
;		
	movem.l	a0-a1,-(sp)

	OPENLIB	_IFFLib,0,_IFFBase	open the library
	
	movem.l	(sp)+,a0-a1

	move.l	a1,-(sp)			store the screen structure

	moveq.l	#IFFL_MODE_READ,d0
	CALLIFF	IFFL_OpenIFF		open the IFF file

	move.l	d0,a4			iff_handle

	move.l	(sp)+,a5			screen structure into a5

	move.l	SS_BitMap(a5),a0		destination bitmap into a0

	move.l	a4,a1			
	CALLIFF	IFFL_DecodePic		decode the iff picture data

	move.l	a4,a0
	move.l	SS_ColorTable(a5),a1
	bsr	Full_Palette		get the full 24 bit palette data

	move.l	SS_ViewPort(a5),a0
	move.l	SS_ColorTable(a5),a1
	CALLGRAF	LoadRGB32		load the colour data

	move.l	a4,a1
	CALLIFF	IFFL_CloseIFF		close the file
	
	CLOSELIB	_IFFBase			close the library

	rts


Save_IFF:
;	save a screen as an iff
;	a0=filename
;	a1=screen to save

	movem.l	a0-a1,-(sp)

	OPENLIB	_IFFLib,0,_IFFBase	open the library

	movem.l	(sp)+,a0-a1

	move.l	a1,a5

	move.l	#IFFL_MODE_WRITE,d0
	CALLIFF	IFFL_OpenIFF		open a new iff file
	move.l	d0,a4
	
;-------  Write the BMHD chunk to the IFF file
	
	move.l	a4,a0
	move.l	#ID_ILBM,d0
	move.l	#ID_BMHD,d1
	CALLIFF	IFFL_PushChunk		make a new chunk
	
	move.l	#20,d0
	move.l	#MEMF_ANY,d1
	CALLEXEC	AllocMem			allocate temporary memory
	
	move.l	d0,a3

	move.l	a3,a0
	move.w	SS_Width+2(a5),(a0)+	width in pixels
	move.w	SS_Height+2(a5),(a0)+	height in pixels
	move.w	#0,(a0)+			x offset
	move.w	#0,(a0)+			y offset
	move.b	SS_Planes+3(a5),(a0)+	number of bitplanes
	move.b	#0,(a0)+			masking bit
	move.b	#1,(a0)+			compression y/n
	move.b	#0,(a0)+			pad bit	
	move.w	#0,(a0)+			transparent
	move.b	#$2c,(a0)+		x aspect assume lowres
	move.b	#$2c,(a0)+		y aspect assume lowres
	move.w	SS_Width+2(a5),(a0)+	page width
	move.w	SS_Height+2(a5),(a0)+	page height	

	move.l	a4,a0
	move.l	a3,a1
	move.l	#20,d0
	CALLIFF	IFFL_WriteChunkBytes	write the chunk to the file

	move.l	a3,a1
	move.l	#20,d0
	CALLEXEC	FreeMem			free the temp memory

	move.l	a4,a0
	CALLIFF	IFFL_PopChunk		finished with this chunk

;-------- Done writing the BMHD chunk

;-------- Write the CMAP chunk

	move.l	a4,a0
	move.l	#ID_ILBM,d0
	move.l	#ID_CMAP,d1
	CALLIFF	IFFL_PushChunk		set up a new chunk
	
	move.l	#0,d0			clear d0
	move.l	SS_Planes(a5),d1		nplanes into d1
	bset	d1,d0			ncol
	muls	#3,d0			*3
	move.l	d0,d3
	move.l	#MEMF_ANY,d1
	CALLEXEC	AllocMem			allocate some temp memory
	
	move.l	d0,a3

;	Here we want to copy the colourtable data into our temporary
;	storage and pop it out onto our IFF file

	move.l	a3,a0
	move.l	SS_ColorTable(a5),a1
	move.l	d3,d7
	subq.l	#1,d7
	add.l	#4,a1
CMAP_loop
	move.l	(a1)+,d0
	move.b	d0,(a0)+
	dbra	d7,CMAP_loop				

	move.l	a4,a0
	move.l	a3,a1
	move.l	d3,d0
	CALLIFF	IFFL_WriteChunkBytes	write the new chunk data

	move.l	a3,a1
	move.l	d3,d0
	CALLEXEC	FreeMem			free the temporary memory

	move.l	a4,a0
	CALLIFF	IFFL_PopChunk		done with this chunk

;-------- Done writing the CMAP chunk to the file

;-------- Write the BODY data of the file

	move.l	a4,a0
	move.l	#ID_ILBM,d0
	move.l	#ID_BODY,d1
	CALLIFF	IFFL_PushChunk		make a new chunk

	move.l	SS_Width(a5),d0		WIDTH
	lsr.l	#3,d0			/8
	muls.l	SS_Height(a5),d0		*HEIGHT
	muls.l	SS_Planes(a5),d0		*NPLANES
	
	move.l	#MEMF_ANY,d1
	CALLEXEC	AllocMem			allocate some temp memory
	
	move.l	d0,a3

	move.l	#0,d5			compressed size

	move.l	a3,a1			temporary memory

	move.l	#0,d6			y counter
Comp_Height_Loop
	move.l	SS_Screen(a5),a0
	move.l	d6,d0
	move.l	SS_Width(a5),d1
	lsr.l	#3,d1
	muls	d1,d0
	add.l	d0,a0			

;	set up for the compression loop
;	compressed image data has to be interleaved

	move.l	SS_Planes(a5),d7
	subq.l	#1,d7
	
Comp_Plane_Loop
	move.l	a0,-(sp)
	move.l	SS_Width(a5),d0
	lsr.l	#3,d0
	move.l	#IFFL_COMPR_BYTERUN1,d1	compress the current scan line
	
	CALLIFF	IFFL_CompressBlock

	move.l	(sp)+,a0

	add.l	d0,d5

	move.l	SS_Width(a5),d0
	lsr.l	#3,d0
	muls.l	SS_Height(a5),d0		
	
	add.l	d0,a0
	dbra	d7,Comp_Plane_Loop	onto the next plane

	move.l	SS_Height(a5),d0
	subq.l	#1,d0
	cmp.l	d0,d6
	bge.s	comp_done
	addq.l	#1,d6
	bra.s	Comp_Height_Loop		onto the next scan line
comp_done
	move.l	a4,a0
	move.l	a3,a1
	move.l	d5,d0
	CALLIFF	IFFL_WriteChunkBytes	write the data

	move.l	a3,a1
	move.l	SS_Width(a5),d0		WIDTH
	lsr.l	#3,d0			/8
	muls.l	SS_Height(a5),d0		*HEIGHT
	muls.l	SS_Planes(a5),d0		*NPLANES

	CALLEXEC	FreeMem			free our temporary memory

	move.l	a4,a0
	CALLIFF	IFFL_PopChunk		pop this chunk off

;-------- Done writing the BODY data

	move.l	a4,a1
	CALLIFF	IFFL_CloseIFF		finished with the file

	CLOSELIB	_IFFBase			close the library

	rts

Full_Palette
;	Gets the 24 bit colour information from an iff file
;	needs IFF Library
;	Internal IFF Routine used by load iff

;	in:- a0=handle
;	     a1=destination colourmap
	
	PUSH	a0-a1

	move.l	a0,a1
	move.l	#ID_CMAP,d0
	CALLIFF	IFFL_FindChunk		find the CMAP Chunk
	
	move.l	d0,a2			store this memory

	PULL	a0-a1

	addq.w	#4,a2

	move.l	(a2)+,d7			number of colours to 
	move.l	d7,d0			amount of data to strip out
	divs	#3,d0
	move.w	d0,(a1)+			number of colours into colormap
	addq.w	#2,a1			onto first location

	subq.l	#1,d7
_col_loop
	moveq.l	#0,d0			
	move.b	(a2),d0			first value
	lsl.l	#8,d0			shift up
	move.b	(a2),d0			get value again
	lsl.l	#8,d0			shift up
	move.b	(a2),d0			get value again
	lsl.l	#8,d0			shift up
	move.b	(a2)+,d0			get value again		
	
	move.l	d0,(a1)+			write colour data
	dbra	d7,_col_loop
	
	rts	

;-------- End of IFF Routines -----------------------------------------------

;-------- File handling Routines ----------------------------------------
;	Load_Data(a0,d0,a1)		filename, buffer length, destination
;	Save_Data(a0,d0,d1)		filename, buffer length, source

Load_Data
;	Loads data from a file

;	input	a0=filename
;		d0=byte size of data to read
;		a1=destination buffer

	move.l	d0,-(sp)

	PUSHALL

	OPENLIB	_DosLib,0,_DOSBase
	
	PULLALL
	
	move.l	a0,d1			filename into d1
	move.l	#MODE_OLDFILE,d2		type of file
	PUSH	d0-d3/a0-a1		store registers
	CALLDOS	Open			open the file
	tst.l	d0
	beq.s	Open_Failed
	move.l	d0,d5			store the filehandle
	PULL	d0-d3/a0-a1		restore registers

	move.l	d5,d1			filehandle into d1
	move.l	a1,d2			desination for the data
	move.l	(sp)+,d3			size of the data
	
	CALLDOS	Read			read the data
	
	move.l	d5,d1			filehandle into d1
	CALLDOS	Close			close the file
	
Open_Failed		
	
	CLOSELIB	_DOSBase

	rts

Save_Data
;	saves data from a file

;	input	a0=filename
;		d0=byte size of data to write
;		a1=source buffer

	move.l	d0,-(sp)

	PUSHALL

	OPENLIB	_DosLib,0,_DOSBase
	
	PULLALL
	
	move.l	a0,d1			filename into d1
	move.l	#MODE_NEWFILE,d2		type of file
	PUSH	d0-d3/a0-a1		store registers
	CALLDOS	Open			open the file
	tst.l	d0
	beq.s	Save_Open_Failed
	move.l	d0,d5			store the filehandle
	PULL	d0-d3/a0-a1		restore registers

	move.l	d5,d1			filehandle into d1
	move.l	a1,d2			source for the data
	move.l	(sp)+,d3			size of the data
	
	CALLDOS	Write			read the data
	
	move.l	d5,d1			filehandle into d1
	CALLDOS	Close			close the file
	
Save_Open_Failed		
	
	CLOSELIB	_DOSBase

	rts
;------------------------------------------------------------------------


;-------- Text handling routines -------------------------------------------
;	Write_Text(a0,a1,d0,d1,d2,d3)	screen, text, x, y, colour, length
;	Num_To_String(d0)			word

Write_Text
;	writes the text to the screen using the current font
;	a0=screen
;	a1=text
;	d0=x
;	d1=y
;	d2=colour
;	d3=string length

	exg.l	a1,a0			get the screen and text into the right reg

	move.l	SS_RastPort(a1),a1	rastport into a1	

	movem.l	a0-a1/d0-d3,-(sp)
	CALLGRAF	Move			move to the text position
	movem.l	(sp)+,a0-a1/d0-d3

	movem.l	a0-a1/d0-d3,-(sp)
	move.l	d2,d0
	CALLGRAF	SetAPen			set the colour
	movem.l	(sp)+,a0-a1/d0-d3

	move.l	d3,d0			text length into d0

	CALLGRAF	Text			write the text

	rts

Num_To_String:
;	converts a word value into a hex string
;	string returned in a1

;	d0=word

	move.w	d0,d1
	move.w	d1,d2
	move.w	d2,d3

	and.w	#%0000000000001111,d0	get the lower byte value
	and.w	#%0000000011110000,d1	get the successive bytes
	and.w	#%0000111100000000,d2
	and.w	#%1111000000000000,d3
	
	lsr.w	#4,d1			get these values to the lowest
	lsr.w	#8,d2			position by shifting
	lsr.w	#6,d3
	lsr.w	#6,d3

	cmp.b	#9,d0			if we have a number
	bgt.s	do_char_d0
	add.b	#$30,d0			add the '0' onto it
	bra.s	done_d0			all done
do_char_d0
	sub.b	#10,d0			else subtract 10
	add.b	#$41,d0			add the 'A' onto it
done_d0
	cmp.b	#9,d1			do the same for the four other
	bgt.s	do_char_d1		registers
	add.b	#$30,d1
	bra.s	done_d1
do_char_d1
	sub.b	#10,d1
	add.b	#$41,d1
done_d1
	cmp.b	#9,d2
	bgt.s	do_char_d2
	add.b	#$30,d2
	bra.s	done_d2
do_char_d2
	sub.b	#10,d2
	add.b	#$41,d2
done_d2
	cmp.b	#9,d3
	bgt.s	do_char_d3
	add.b	#$30,d3
	bra.s	done_d3
do_char_d3
	sub.b	#10,d3
	add.b	#$41,d3
done_d3

	lea	num_string,a0
	move.b	d3,(a0)+			write the data to the number string
	move.b	d2,(a0)+
	move.b	d1,(a0)+
	move.b	d0,(a0)+
	move.b	#0,(a0)+
	
	lea	num_string,a1

	rts	


;------------------------------------------------------------------------

;-------- Copper  handling routines -------------------------------------
;	Add_Copper(a0,a1)		screen,copper list

Add_Copper
;	Adds a copper list stream to the specified screen
;	a0=screen
;	a1=copper instructions
	
	move.l	a0,a5
	move.l	a1,a2

	move.l	#12,d0			enough space for a user copper struc
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
	CALLEXEC	AllocMem			allocate memory for a user copper structure
	
	move.l	d0,SS_UserCopperList(a5)

	move.l	SS_UserCopperList(a5),a0
	move.l	#5000,d0			allocate enough space for 5000 entries
	CALLGRAF	UCopperListInit	

.Copper_Loop	
	move.l	(a2),d0
	cmp.l	#$fffffffe,d0		check if we have a copper end instruction
	beq.s	.Copper_Done
	move.w	2(a2),d0			
	cmp.w	#$fffe,d0		else check if it is a copper move
	bne.s	.Copper_Move
.Copper_Wait
	move.w	(a2),d0			we want to feed a copper wait
	move.w	#0,d1			into the copper stream
	move.b	d0,d1			so decode and write it
	lsr.w	#8,d0
	move.l	SS_UserCopperList(a5),a1
	CALLGRAF	CWait
	move.l	SS_UserCopperList(a5),a1
	CALLGRAF	CBump
	add.w	#4,a2
	bra.s	.Copper_Loop
.Copper_Move
	move.w	(a2)+,d0			decode the move instruction
	move.w	(a2)+,d1			and feed it into the copper
	move.l	SS_UserCopperList(a5),a1	stream
	CALLGRAF	CMove
	move.l	SS_UserCopperList(a5),a1
	CALLGRAF	CBump
	bra.s	.Copper_Loop
.Copper_Done

	move.l	SS_UserCopperList(a5),a1	all done so write the copper
	move.w	#10000,d0		end instruction to the stream
	move.w	#255,d1
	CALLGRAF	CWait
	move.l	SS_UserCopperList(a5),a1
	CALLGRAF	CBump 

	CALLEXEC	Forbid			latch the copper list onto
	move.l	SS_ViewPort(a5),a0	the viewport
	move.l	SS_UserCopperList(a5),vp_UCopIns(a0)
	
	move.l	SS_View(a5),a0	
	move.l	SS_ViewPort(a5),a1
	CALLGRAF	MakeVPort		remake the viewport
	
	move.l	SS_View(a5),a1
	CALLGRAF	MrgCop			merge the copperlist
	
	SHOW	a5			show the screen

	CALLEXEC	Permit

	rts

;------------------------------------------------------------------------

;-------- Input Handling Routines ---------------------------------------
;	GetKey()


GetKey          moveq.l         #0,d0           clear the register
                move.b          $BFEC01,d0      get value from CIA chip
                not.b           d0              manipulate it to form raw
                ror.b           #1,d0           key code

                rts

;------------------------------------------------------------------------


	Section	System_Data,DATA_F
;	Data required by the above routines

_DosLib
	DOSNAME
	even
_graphics_lib
	GRAFNAME	
	even
_IFFLib
	IFFNAME
	even
	
*TagItem structure
vctags:
	dc.l	VTAG_ATTACH_CM_SET,0
	dc.l	VTAG_VIEWPORTEXTRA_SET,0
	dc.l	VTAG_NORMAL_DISP_SET,0
	dc.l	VTAG_END_CM,0

	Section	System_BSS,BSS_F
;	storage required by the above routines
_IntuitionBase:
	ds.l	1
_GfxBase
	ds.l	1
_IFFBase
	ds.l	1
_DOSBase
	ds.l	1
_oldview
	ds.l	1
clip_out
	ds.l	1
line_flag
	ds.l	1
fade_flag
	ds.l	1
x_min
	ds.w	1
x_max
	ds.w	1
y_min
	ds.w	1
y_max
	ds.w	1
blitmod
	ds.w	1
bltwidth
	ds.w	1
blitsize
	ds.w	1
bltstrt
	ds.w	1
num_string
	ds.b	5

