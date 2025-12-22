;/*

	flushcache
	ec gadgetinfo
	iconsASgads.e
	quit

*/


OPT MODULE

MODULE	'workbench/workbench',
			'exec/ports',
			'icon',
			'intuition/screens', 'intuition/intuition',
			'gadtools', 'libraries/gadtools',
			'graphics/text', 'graphics/gfxbase'

CONST MAX_GADGETINFO=50, INFO_TICKS=5

EXPORT OBJECT gadgetinfo
	text[MAX_GADGETINFO]:ARRAY OF LONG
	win:PTR TO window								-> The main window
	infowin:PTR TO window						-> The little info window
	max, id, ticks, x, y:INT
ENDOBJECT


EXPORT DEF info:PTR TO gadgetinfo, fontx


/*---------------------- gadgethelp stuff 
										---------------------------*/
EXPORT PROC init_gadgetinfo(win:PTR TO window)
	DEF n
	NEW info
	IF info=NIL THEN Throw("MEM", 'init_gadgetinfo: Could not allocate object')
	FOR n:=0 TO MAX_GADGETINFO-1 DO info.text[n]:=0
	info.max:=0
	info.ticks:=0
	info.id:=-1
	info.win:=win
	info.infowin:=0
ENDPROC


EXPORT PROC end_gadgetinfo()
	DEF n
	IF info
		FOR n:=0 TO MAX_GADGETINFO-1
			IF info.text[n] THEN DisposeLink(info.text[n])
		ENDFOR
		END info
	ENDIF
ENDPROC


EXPORT PROC add_gadgetinfo(id, text)
	IF (id<0) OR (id>=MAX_GADGETINFO) THEN Throw("info", 'add_gadgetinfo: id out of range')
	IF info.text[id] THEN Throw("info", 'add_gadgetinfo: id already used')
	info.text[id]:=String(StrLen(text))
	StrCopy(info.text[id], text)
	info.max:=Max(info.max, id+1)
ENDPROC


/*- handles pretty much everything... -*/
EXPORT PROC do_gadgetinfo(id, x=0, y=0)
	DEF msg:PTR TO intuimessage, class, str[100]:STRING, gadget:PTR TO gadget

	IF id=-1
		/* we have been sent a message by IDCMP_MOUSEMOVE that we have moved and are not over
			a gadget, so set the ticks to zero, and exit. */
		info.ticks:=0
		RETURN 0

	ELSEIF id=-2
		/* we have been sent a message by IDCMP_INTUITICKS that 1/10th of a second has passed,
			so we should increment the curtime IF we are over a gadget */
		IF info.id>-1
			info.ticks:=info.ticks+1
			/* have we gone over WAIT_TICK? */
			IF info.ticks>INFO_TICKS
				/* yes so reset curtick and pop window */
				info.ticks:=0
				StrCopy(str, info.text[info.id])

				/* Now open window over the gadget using coords previously supplied */
				info.infowin:=OpenWindowTagList(0,
								[WA_WIDTH, (EstrLen(str)+2)*fontx, WA_HEIGHT, info.win.wscreen.font.ysize+4,
								 WA_LEFT, info.x+info.win.leftedge, WA_TOP, info.y+(info.win.wscreen.wbortop+info.win.wscreen.font.ysize+1)+info.win.topedge,
								 WA_IDCMP, IDCMP_MOUSEMOVE OR IDCMP_MOUSEBUTTONS OR IDCMP_VANILLAKEY,
								 WA_FLAGS, WFLG_BORDERLESS OR WFLG_REPORTMOUSE OR WFLG_RMBTRAP,
								 WA_AUTOADJUST, TRUE,
								 WA_PUBSCREEN, info.win.wscreen,
								 NIL])
				IF info.infowin=NIL THEN Throw("win", 'gadgetinfo: Could not open infowin')

				SetRast(info.infowin.rport, 2)
				SetBPen(info.infowin.rport, 2)
				SetAPen(info.infowin.rport, 1)
				Move(info.infowin.rport, fontx, 8) ; Text(info.infowin.rport, str, EstrLen(str))
	
				SetAPen(info.infowin.rport, 1)
				Move(info.infowin.rport, 0, 0)
				Draw(info.infowin.rport, info.infowin.width-1, 0)
				Draw(info.infowin.rport, info.infowin.width-1, info.infowin.height-1)
				Draw(info.infowin.rport, 0, info.infowin.height-1)
				Draw(info.infowin.rport, 0, 0)

				SetAPen(info.infowin.rport, 0)
				WritePixel(info.infowin.rport, 0, 0)
				WritePixel(info.infowin.rport, info.infowin.width-1, 0)
				WritePixel(info.infowin.rport, info.infowin.width-1, info.infowin.height-1)
				WritePixel(info.infowin.rport, 0, info.infowin.height-1)
				
				/* wait from a message from win NOT infowin so we don't have to deactivate win */

				REPEAT
					Wait(Shl(1, info.win.userport.sigbit))	
					WHILE msg:=Gt_GetIMsg(info.win.userport)
						class:=msg.class
						Gt_ReplyIMsg(msg)
					ENDWHILE
				UNTIL class<>IDCMP_INTUITICKS

				CloseWindow(info.infowin)

				/* set curid to -1 so we have to move the mouse to get the requester up again */
				info.id:=-1
			ENDIF
		ELSE
			/* nope, so just reset curtick to be sure */
			info.ticks:=0
		ENDIF

	ELSE
		/* we have been passed a gadgetid by IDCMP_MOUSEMOVE, so we are over a gadget... */
		info.x:=x
		info.y:=y
		info.id:=id
		info.ticks:=0
	ENDIF
ENDPROC


EXPORT PROC set_gadgetinfo(win:PTR TO window, x, y)
	DEF gadget:PTR TO gadget, quit=0

	gadget:=win.firstgadget
	WHILE gadget

		/*-- check whether we are over a gadget AND that gadget has a string allocated for it --*/
		IF (x>=gadget.leftedge) AND (x<=(gadget.leftedge+gadget.width)) AND
			(y>=gadget.topedge) AND (y<=(gadget.topedge+gadget.height)) AND
			(info.text[gadget.gadgetid])
 
			do_gadgetinfo(gadget.gadgetid, x  /*gadget.leftedge*/, y-info.win.wscreen.font.ysize-3 /*gadget.topedge+gadget.height*/)

			gadget:=NIL
		ELSE
			quit:=do_gadgetinfo(-1)
			gadget:=gadget.nextgadget
		ENDIF
	ENDWHILE
ENDPROC
