/*
**
**	Id: EasyExample.e
**	Author: Marco Talamelli
**	Date: 20/02/96 21:30 $
**
**	A simple ILBM file viewer. To compile with Amiga E v3.2e
**
**	THIS IS PD. NO WARRANTY. USE AT YOUR OWN RISK.
**
*/

MODULE	'libraries/iff','iff','dos/dos','intuition/screens','reqtools',
	'libraries/reqtools','graphics/view','graphics/gfxbase'

PROC main()

DEF	filereq:PTR TO rtfilerequester,filename[80]:STRING,name[80]:STRING,codice,
	iff,bmhd:bmhd,myscreen:PTR TO screen,ns:ns,count,colortable[256]:ARRAY OF INT

IF iffbase := OpenLibrary('iff.library',23)
IF reqtoolsbase:=OpenLibrary('reqtools.library',37)

  IF filereq := RtAllocRequestA(RT_FILEREQ, NIL)
    filename[0] := 0

     WHILE RtFileRequestA(filereq, filename, 'Load Picture...',0)
       IF StrLen(filereq.dir) THEN StringF(name,'\s/\s',filereq.dir,filename) ELSE StringF(name,'\s',filename)
		
	IF iff := IfFL_OpenIFF(name, IFFL_MODE_READ)

		IF bmhd := IfFL_GetBMHD(iff)

			ns.type			:= CUSTOMSCREEN OR SCREENQUIET OR SCREENBEHIND
			ns.width		:= bmhd.w
			ns.height		:= bmhd.h
			ns.depth		:= bmhd.nplanes
			ns.viewmodes	:= IfFL_GetViewModes(iff)

			IF myscreen := OpenScreen(ns)
				setoverscan(myscreen)

				count := IfFL_GetColorTab(iff, colortable)

				/* Fix for old broken HAM pictures */
				IF (count>32) THEN count := 32

				LoadRGB4(myscreen.viewport, colortable, count)

				IF IfFL_DecodePic(iff, myscreen.bitmap)

					ScreenToFront(myscreen)
					REPEAT
					codice:=Mouse()
					UNTIL codice=1
				ELSE
					
					RtEZRequestA('Can\at decode picture.\n', 'Aargh!', NIL, NIL, NIL)
				ENDIF
				CloseScreen(myscreen)
			ELSE
				RtEZRequestA('Can\at open screen.\n', 'Aargh!', NIL, NIL, NIL)
			ENDIF
		ELSE
			RtEZRequestA('This file has no bitmap header.\n', 'Aargh!', NIL, NIL, NIL)
		ENDIF

		IfFL_CloseIFF(iff)
	ELSE
	RtEZRequestA('Can\at open file \a\s\a\n', 'Aargh!', NIL, [name], NIL)
	ENDIF
	ENDWHILE
		RtFreeRequest(filereq)
	ELSE
		RtEZRequestA('No Memory!!', 'Aargh!', NIL, NIL, NIL)
	ENDIF
	RtEZRequestA('IfFL_IFFError value is \d\n','Ok', NIL, [IfFL_IFFError()], NIL)

	 CloseLibrary(reqtoolsbase)
ELSE
	RtEZRequestA('Can\at open ReqTools.library V\d+\n', 'Aargh!', NIL, [37], NIL)
ENDIF
	CloseLibrary(iffbase)		/* THIS IS VERY IMPORTANT! */
ELSE
	RtEZRequestA('Can\at open iff.library V\d+\n', 'Aargh!', NIL, [23], NIL)
ENDIF
ENDPROC

PROC setoverscan(screen:PTR TO screen)

DEF	cols, rows, x,y,vp:PTR TO viewport,gfxbase:gfxbase

x:=screen.width
y:=screen.height
vp:= screen.viewport

	cols := Shr(gfxbase.normaldisplaycolumns,1)

	rows := gfxbase.normaldisplayrows
	IF (rows>300) THEN rows:=Shr(rows,1)
	x :=x-cols
	IF (vp.modes AND V_HIRES) THEN x :=x-cols
	y :=y-rows
	IF (vp.modes AND V_LACE) THEN y :=y-rows
	x :=Shr(x,1)
	IF (x<0) THEN x:=0
	y :=Shr(y,1)
	IF (y<0) THEN y:=0
	IF (y>32) THEN y:=32

	/*
	**	To avoid color distortions in HAM mode, we must limit the
	**	left edge of the screen to the leftmost value the hardware
	**	can display.
	*/
	IF (vp.modes AND V_HAM)

		IF (gfxbase.actiview.dxoffset-x < 96) THEN x := gfxbase.actiview.dxoffset-96
	ENDIF
	vp.dxoffset := 0
	vp.dyoffset := 0
	MakeScreen(screen)
	RethinkDisplay()
ENDPROC
