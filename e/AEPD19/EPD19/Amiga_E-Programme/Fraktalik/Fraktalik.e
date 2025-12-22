/* =========================================
         Fraktalgenerator "Fraktalik" 
   -----------------------------------------
         geschrieben von M. Bennicke

         begonnen        : 25.04.1994
         letzte Änderung : 02.10.1994

                Version 2.03ß
   =========================================

--------------------------------------------------------------
Es wird ein gemeinsamer IDCMP-Port für alle Fenster benutzt.
Dazu wird das Fenster mit IDCMP-Flags=0 geöffnet, so daß von Intuition
kein IDCMP eingerichtet wird. Dann werden der Userport des Fensters
auf einen selbst initialisierten Port und die IDCMP-Flags per
ModifyIDCMP gesetzt. Ein so geöffnetes Fenster muß mit
RtCloseWindowSafely geschlossen werden, da Intuition sonst den
IDCMP, der ja noch von anderen Fenstern benutzt wird, zerstört.
--------------------------------------------------------------
*/


OPT LARGE

MODULE	'reqtools','libraries/reqtools','intuition/intuition','intuition/screens',
		'exec/lists','exec/nodes','exec/ports','exec/memory','exec/io',
		'graphics/text','graphics/view','dos/dos',
		'devices/timer','devices/printer','devices/parallel','devices/serial',
		'utility/tagitem','mathtrans','intuition/preferences','workbench/startup',
		'graphics/displayinfo'

OBJECT rastport
	layer:LONG
	bitmap:LONG
	areaptrn:LONG
	tmpras:LONG
	areainfo:LONG
	gelsinfo:LONG
	mask:CHAR
	fgpen:CHAR
	bgpen:CHAR
	aolpen:CHAR
	drawmode:CHAR
	areaptsz:CHAR
	linpatcnt:CHAR
	dummy:CHAR
	flags:INT
	lineptrn:INT
	cp_x:INT
	cp_y:INT
	minterms1:LONG
	minterms2:LONG
	penwidth:INT
	penheight:INT
	font:LONG
	algostyle:CHAR
	txflags:CHAR
	txheight:INT
	txwidth:INT
	txbaseline:INT
	txspacing:INT
	rp_user:LONG

	longreserved1:LONG
	longreserved2:LONG

	wordreserved1:INT
	wordreserved2:INT
	wordreserved3:INT
	wordreserved4:INT
	wordreserved5:INT
	wordreserved6:INT
	wordreserved7:INT

	reserved1:LONG
	reserved2:LONG
	reserved3:INT
ENDOBJECT


OBJECT bitmap
  bytesperrow:INT
  rows:INT
  flags:CHAR
  depth:CHAR
  pad:INT
  plane[31]:ARRAY		/* 8 Plane-Zeiger je 4 Byte = 32 Bytes */
ENDOBJECT


OBJECT diskclass
	done: INT
	ydone: LONG
	width: INT
	height: INT
	xmin: LONG
	xmax: LONG
	ymin: LONG
	ymax: LONG
	it: INT
	flinterrupted: CHAR
	flstarted: CHAR
	pad: CHAR
ENDOBJECT

OBJECT class
	succ: LONG
	pred: LONG
	type: CHAR
	pri: CHAR
	name: LONG

	viewlist: LONG
	data: LONG
	filename: LONG
	path: LONG
	pattern: LONG
	done: INT
	ydone: LONG

	mainwin: LONG
	width: INT
	height: INT
	xmin: LONG
	xmax: LONG
	ymin: LONG
	ymax: LONG
	it: INT
	gadgets[35]:ARRAY			/* 9 Gadget-Zeiger */

	flsaved: CHAR
	flinterrupted: CHAR
	flstarted: CHAR
	flgot: CHAR
	nr: INT
	lock: LONG
ENDOBJECT

OBJECT subclass
	succ: LONG
	pred: LONG
	type: CHAR
	pri: CHAR
	name: LONG

	window: LONG
	viewtype: CHAR
	x: INT
	y: INT
	rport: LONG
	bitmap: LONG
	class: LONG
	nr: INT
	lock: LONG

	req: LONG			/* <>0 wenn Ansicht gerade gedruckt wird */
	printwin: LONG
	printgad: LONG
ENDOBJECT

OBJECT bitmapheader
	w: INT
	h: INT
	x: INT
	y: INT
	planes: CHAR
	masking: CHAR
	compression: CHAR
	pad1: CHAR
	transparentcolor: INT
	xaspect:CHAR
	yaspect: CHAR
	pagewidth: INT
	pageheight: INT
ENDOBJECT

OBJECT cycleinfo
	direction: INT
	start,end: CHAR
	seconds: LONG
	microseconds: LONG
	pad: INT
ENDOBJECT

OBJECT rgb
	r,g,b:CHAR
ENDOBJECT


CONST	E_RT=9999

ENUM	E_NONE,E_SCR,E_WIN,E_MEM,E_MTRANS,E_VIEW,E_GAD,E_TASK,
			E_BITMAP,E_WRITE,E_READ,E_FORMAT,E_NODATA,E_OPENREQ,E_SIGBIT,
			E_TIME,E_OPENFILE,E_PALFORMAT,E_EOF,E_PRINTER,E_VIEWBUSY,
			E_CHECKPRINTER,E_NOCYCLE,

	 	D_OK=0,D_SAVE,D_JANEIN,D_READY,D_CHECK,D_SIZE,

		M_READY=0,M_INTERRUPTED,M_SAVE,M_OVERWRITE,M_WRITTEN,
			M_IFF,M_DELVIEWS,M_START,M_PALWRITTEN,M_MORECOLORS,
			M_NEWSCREEN,M_CHANGE,M_WBNOTCLOSED,M_WBNOTOPENED,M_RUNNING,
			M_REALLYQUIT,M_NOCYCLE,

		VIEW_FARB=0,VIEW_3D,

		WIN_BACKDROP=0,WIN_PROCESS,WIN_VIEW,WIN_PRINT,WIN_CYC,

		DO_NONE=0,DO_ABBRUCH,DO_AGAIN,DO_EXIT,

		WL_LOCK=0,WL_UNLOCK,

		CH_CHECK=0,CH_UNCHECK

CONST	STDFL=ITEMTEXT OR ITEMENABLED OR HIGHCOMP,
		MENUPEN=2, MENUANZAHL=3,ITEMANZAHL=30,IMAGEANZAHL=10,
		TEXTANZAHL=30,

		IDCMP = IDCMP_MENUPICK OR IDCMP_WBENCHMESSAGE,
		WFLAGS = WFLG_BACKDROP OR WFLG_ACTIVATE OR WFLG_BORDERLESS,

		PIDCMP = IDCMP_GADGETUP OR IDCMP_MENUPICK OR IDCMP_GADGETDOWN OR IDCMP_CLOSEWINDOW,
		PFLG = WFLG_NOCAREREFRESH OR WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR WFLG_ACTIVATE,

		VFLG = WFLG_NOCAREREFRESH OR WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR WFLG_SIZEGADGET OR WFLG_ACTIVATE OR WFLG_SIZEBRIGHT OR WFLG_REPORTMOUSE,
		VIDCMP = IDCMP_MENUPICK OR IDCMP_CLOSEWINDOW OR IDCMP_NEWSIZE OR IDCMP_MOUSEBUTTONS,

		REQ_IDCMP = IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_CLOSEWINDOW,
		REQ_FLAGS = WFLG_NOCAREREFRESH OR WFLG_CLOSEGADGET OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_ACTIVATE,

		CYC_IDCMP = IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_CLOSEWINDOW OR IDCMP_ACTIVEWINDOW OR IDCMP_INACTIVEWINDOW,
		CYC_FLAGS = WFLG_NOCAREREFRESH OR WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET,

		STRACT=GACT_IMMEDIATE OR GACT_RELVERIFY,

		PROPACT=GACT_IMMEDIATE OR GACT_RELVERIFY,
		PROPFL=AUTOKNOB OR PROPBORDERLESS,

		ZEHN = $A0000044,ACHT=$80000044,ZWEI=$80000042,
		INCH=$A28F5C42,TAUSEND=$FA00004A,

		ID_START=300,ID_STOP=301,ID_PRINT=500,
		ID_CYCTEMPO=700,ID_CYCCHANGE=701,ID_CYCDEFAULT=702,

		PROPADD=70,
		PTRSIZE=64,STRICHSIZE=60,PFEILSIZE=28

ENUM	NO_COMP,BYTE_RUN		/* IFF-Packen ? */

DEF erlist:PTR TO LONG,declist:PTR TO LONG,msglist:PTR TO LONG,
	printmsg:PTR TO LONG,ioerr:PTR TO LONG,prtstate,clistart,

	scr:PTR TO screen,win:PTR TO window,
	clist:PTR TO mlh,oldreqwin,portIDCMP:PTR TO mp,idcmpmask,
	tattr,depth,winlock,horizrand,vertrand,lockstate,
	ende,printmask=0,

	identify[14]:STRING,versionstring[60]:STRING,

	wbitem:PTR TO menuitem,wboffen=TRUE,
	iffitem:PTR TO menuitem,iffcomp=BYTE_RUN,

	xsize=$A0000044,ysize=$A0000044,unit=0,


	xmenu[MENUANZAHL]:ARRAY OF menu,
	item[ITEMANZAHL]:ARRAY OF menuitem,
	txt[TEXTANZAHL]:ARRAY OF intuitext,
	im[IMAGEANZAHL]:ARRAY OF image,
	ubuf[30]:ARRAY OF CHAR,
	busy[15]:ARRAY OF INT,
	pfeil1:image,pfeil2:image,
	maus=NIL,pfeildata=NIL,strich=NIL,

	cdir=1,csecs=0,cmics=0,				/* Color Cycling-Parameter */
	cyclemask=0,cycleport:PTR TO mp,cyclewindow:PTR TO window,
	cyclegadgets[1]:ARRAY OF LONG,cyclereq:PTR TO timerequest,
	colortab[255]:ARRAY OF LONG,cyclebis,

	picpath[400]:STRING,palpath[400]:STRING



PROC main()
	DEF msg,gotbits

	clistart:=IF wbmessage=NIL THEN TRUE ELSE FALSE
	IF openall()=FALSE THEN JUMP errende

again:
	ende:=FALSE
	REPEAT

		gotbits:=Wait(idcmpmask OR cyclemask OR printmask)

		IF (gotbits AND idcmpmask)<>0
			IF (msg:=GetMsg(portIDCMP))<>NIL
				handleIDCMP(msg)		/* Message muß dort Replied werden !!! */
			ENDIF
		ENDIF
		IF (gotbits AND cyclemask)<>0
			IF (cycleport<>NIL) AND (GetMsg(cycleport)<>NIL)
				sendCycle()
			ENDIF
		ENDIF
		IF (gotbits AND printmask)<>0
			viewPrintCheck(clist)
		ENDIF
	UNTIL ende

	IF cleardesk(clist)<>DO_NONE THEN JUMP again
	IF request(msglist[M_REALLYQUIT],declist[D_JANEIN],0)=0 THEN JUMP again
	IF closeall()<>DO_NONE THEN JUMP again

errende:
	CleanUp(0)
ENDPROC


PROC handleIDCMP(msg:PTR TO intuimessage)
	DEF class,code,qual,iaddr,w:PTR TO window,
		menux,itemx,subitemx,g:PTR TO gadget,id,cl:PTR TO class,
		type,view:PTR TO subclass,ga[8]:ARRAY OF LONG


	w:=msg.idcmpwindow
	class:=msg.class
	code:=msg.code
	qual:=msg.qualifier
	iaddr:=msg.iaddress
	ReplyMsg(msg)

	SELECT class
	CASE IDCMP_MENUPICK
		subitemx:=Shr(code,11)
		itemx:=Shr(code AND %11111100000,5)
		menux:=code AND %11111
		SELECT menux
		CASE 0
			SELECT itemx
			CASE 0
				windowlock(clist,WL_LOCK)
				cl:=readclass()
				windowlock(clist,WL_UNLOCK)

			CASE 1
				IF w.extdata=WIN_PROCESS
					windowlock(clist,WL_LOCK)
					saveclass(w.userdata,TRUE)
					windowlock(clist,WL_UNLOCK)
				ENDIF

			CASE 2
				IF w.extdata=WIN_PROCESS
					windowlock(clist,WL_LOCK)
					saveclass(w.userdata,FALSE)
					windowlock(clist,WL_UNLOCK)
				ENDIF

			CASE 3
				windowlock(clist,WL_LOCK)
				IF (cl:=newclass(clist))<>NIL
					cl.xmax:=strtoffp('2.5')
					cl.xmin:=strtoffp('-1.0')
					cl.ymax:=strtoffp('1.5')
					cl.ymin:=strtoffp('-1.5')
					cl.it:=60
					cl.width:=PROPADD
					cl.height:=PROPADD
					putgadgets(cl);cl.flgot:=FALSE
					dispstate(cl,0)
				ENDIF
				windowlock(clist,WL_UNLOCK)

			CASE 4
				cleardesk(clist)

			CASE 5
				request('Fraktalik V2.03\n'+
						'~~~~~~~~~~~~~~~\n\n'+
						'Mandelbrotgenerator\n'+
						'geschrieben von\n'+
						'Marcel Bennicke\n\n'+
						'Speicherbelegung:\n'+
						'-----------------\n'+
						'Chip: \d[5]KB frei\n'+
						'Fast: \d[5]KB frei\n',declist[D_OK],
						[AvailMem(2)/1024,AvailMem(4)/1024])

			CASE 6
				ende:=TRUE
			ENDSELECT
		CASE 1
			SELECT itemx
				CASE 0
					IF w.extdata=WIN_PROCESS THEN clearviews(w.userdata)
				CASE 1
					IF w.extdata=WIN_VIEW
						view:=w.userdata
						IF view.viewtype=VIEW_FARB THEN zoomin(view)
					ENDIF
				CASE 2
					IF w.extdata=WIN_VIEW
						view:=w.userdata
						IF view.viewtype=VIEW_FARB THEN zoomout(view)
					ENDIF
				CASE 3
					IF w.extdata=WIN_VIEW
						windowlock(clist,WL_LOCK)
						iffsave(w.userdata)
						windowlock(clist,WL_UNLOCK)
					ENDIF
				CASE 4
					IF w.extdata=WIN_VIEW THEN printerdump(w.userdata)
				CASE 5
					type:=w.extdata
					SELECT type
						CASE WIN_PROCESS
							windowlock(clist,WL_LOCK)
							view:=newview(w.userdata,subitemx)
							windowlock(clist,WL_UNLOCK)
						CASE WIN_VIEW
							windowlock(clist,WL_LOCK)
							view:=w.userdata
							view:=newview(view.class,subitemx)
							windowlock(clist,WL_UNLOCK)
					ENDSELECT
			ENDSELECT

		CASE 2
			SELECT itemx
			CASE 0
				SELECT subitemx
				CASE 0
					windowlock(clist,WL_LOCK)
					RtPaletteRequestA('Farbpalette',0,0)
					initColorArray()
					windowlock(clist,WL_UNLOCK)

				CASE 1
					cyclecolors()
				CASE 2
					setcolors(scr)
					initColorArray()
				CASE 3
					windowlock(clist,WL_LOCK)
					readpalette()
					initColorArray()
					windowlock(clist,WL_UNLOCK)
				CASE 4
					windowlock(clist,WL_LOCK)
					savepalette()
					windowlock(clist,WL_UNLOCK)
				ENDSELECT
			CASE 1
				IF changescreen()=DO_EXIT THEN ende:=TRUE
			CASE 2
				handleWB(IF wboffen THEN WBENCHCLOSE ELSE WBENCHOPEN)
			CASE 3
				IF iffcomp=NO_COMP
					checkitem(iffitem,CH_CHECK)
					iffcomp:=BYTE_RUN
				ELSEIF iffcomp=BYTE_RUN
					checkitem(iffitem,CH_UNCHECK)
					iffcomp:=NO_COMP
				ENDIF
			ENDSELECT
		ENDSELECT

	CASE IDCMP_CLOSEWINDOW
		type:=w.extdata
		SELECT type
		CASE WIN_PROCESS
			deleteclass(w.userdata)
		CASE WIN_VIEW
			deleteview(w.userdata)
		CASE WIN_CYC
			closeCycWindow()
		ENDSELECT

	CASE IDCMP_GADGETDOWN
		g:=iaddr
		id:=g.gadgetid

		IF w.extdata=WIN_PROCESS
			cl:=w.userdata
			IF (id>=100) AND (id<300)
				IF id>=200 THEN handleprop(w,g,PROPADD)
				cl.flgot:=FALSE
				IF clearviews(cl)=DO_ABBRUCH
					putgadgets(cl)
				ELSE
					IF cl.data<>NIL
						FreeMem(cl.data,clsize(cl))
						cl.data:=NIL
					ENDIF
					dispstate(cl,0)
				ENDIF
			ENDIF
		ENDIF

		IF id=ID_CYCTEMPO THEN cmics:=1024*(255-handleprop(w,g,0))

	CASE IDCMP_GADGETUP
		g:=iaddr
		id:=g.gadgetid
		cl:=w.userdata	
		ga:=cl.gadgets

		SELECT id
		CASE ID_START
			start(w.userdata)

		CASE ID_PRINT
			enddump(w.userdata)

		CASE ID_CYCCHANGE
			cdir:=-cdir
			
		CASE 100
			ActivateGadget(ga[1],w,NIL)
		CASE 101
			ActivateGadget(ga[2],w,NIL)
		CASE 102
			ActivateGadget(ga[3],w,NIL)
		CASE 103
			ActivateGadget(ga[4],w,NIL)
		CASE 104
			ActivateGadget(ga[0],w,NIL)
		ENDSELECT
	
	CASE IDCMP_NEWSIZE
		IF w.extdata=WIN_VIEW
			view:=w.userdata
			view.x:=0;view.y:=0
			SetAPen(w.rport,0)
			RectFill(w.rport,w.borderleft,w.bordertop,w.borderleft+w.width-horizrand,w.bordertop+w.height-vertrand)
			disprast(view)
		ENDIF

	CASE IDCMP_MOUSEBUTTONS
		IF (code=SELECTDOWN) AND (w.extdata=WIN_VIEW) THEN doscroll(w.userdata,msg.mousex,msg.mousey)

	CASE IDCMP_WBENCHMESSAGE
		IF code=WBENCHOPEN THEN checkitem(wbitem,CH_CHECK) ELSE checkitem(wbitem,CH_UNCHECK)
	ENDSELECT
ENDPROC 


PROC checkitem(it:PTR TO menuitem,mode)
	ClearMenuStrip(win)
	SELECT mode
		CASE CH_UNCHECK
			it.flags:=it.flags AND ($FFFF-CHECKED)
		CASE CH_CHECK
			it.flags:=it.flags OR CHECKED
	ENDSELECT
	SetMenuStrip(win,xmenu)
ENDPROC


PROC handleWB(mode)
	SELECT mode
	CASE WBENCHCLOSE 
		IF CloseWorkBench()<>FALSE
			checkitem(wbitem,CH_UNCHECK)
			wboffen:=FALSE
		ELSE
			request(msglist[M_WBNOTCLOSED],declist[D_OK],0)
		ENDIF

	CASE WBENCHOPEN
		IF OpenWorkBench()<>NIL
			checkitem(wbitem,CH_CHECK)
			wboffen:=TRUE
			RemakeDisplay()
		ELSE
			request(msglist[M_WBNOTOPENED],declist[D_OK],0)
		ENDIF
	ENDSELECT
ENDPROC


PROC getVMode()
	DEF vp:PTR TO viewport

	vp:=scr.viewport
ENDPROC IF KickVersion(37) THEN GetVPModeID(vp)	ELSE (vp.modes AND %1000100010000100)


PROC sendCycle()
	DEF time:PTR TO timeval,io:PTR TO io

	IF cdir>0 THEN cycleAhead(4,cyclebis,scr.viewport) ELSE cycleBack(4,cyclebis,scr.viewport)

	io:=cyclereq.io
	time:=cyclereq.time
	io.command:=TR_ADDREQUEST
	time.secs:=0
	time.micro:=cmics
	SendIO(cyclereq)
ENDPROC


PROC cycleAhead(von,bis,vp)
	DEF i,savedcolor

	savedcolor:=colortab[bis]
	FOR i:=bis TO von+1 STEP -1
		colortab[i]:=colortab[i-1]
		SetRGB4(vp,i,Shr(colortab[i],8) AND $F,
					Shr(colortab[i],4) AND $F,
					colortab[i] AND $F)
	ENDFOR
	colortab[von]:=savedcolor
	SetRGB4(vp,von,Shr(savedcolor,8) AND $F,
					Shr(savedcolor,4) AND $F,
					savedcolor AND $F)
ENDPROC

PROC cycleBack(von,bis,vp)
	DEF i,savedcolor
	
	savedcolor:=colortab[von]
	FOR i:=von TO bis-1
		colortab[i]:=colortab[i+1]
		SetRGB4(vp,i,Shr(colortab[i],8) AND $F,
					Shr(colortab[i],4) AND $F,
					colortab[i] AND $F)
	ENDFOR
	colortab[bis]:=savedcolor
	SetRGB4(vp,von,Shr(savedcolor,8) AND $F,
					Shr(savedcolor,4) AND $F,
					savedcolor AND $F)
ENDPROC


PROC initColorArray()
	DEF i,vp:PTR TO viewport

	vp:=scr.viewport
	FOR i:=0 TO Shl(1,depth)-1 DO colortab[i]:=GetRGB4(vp.colormap,i)
ENDPROC


PROC cyclecolors() HANDLE
	RAISE 	E_TIME IF OpenDevice()<>0,
			E_WIN IF OpenW()=NIL

	DEF io:PTR TO io,cm:PTR TO colormap,vp:PTR TO viewport,i

	windowlock(clist,WL_LOCK)

	IF printmask<>0 THEN Raise(E_NOCYCLE)

	initColorArray()		/* sicherheitshalber */

	vp:=scr.viewport
	cm:=vp.colormap
	cyclebis:=Shl(1,depth)-1

	cyclewindow:=OpenW(scr.width-140,scr.height-74,140,74,
			0,CYC_FLAGS,'Farbrollen',scr,$F,NIL)
	cyclewindow.userport:=portIDCMP
	ModifyIDCMP(cyclewindow,CYC_IDCMP)
	cyclewindow.extdata:=WIN_CYC

	SetAPen(stdrast,2)
	setAfPt(stdrast,[$AAAA,$5555]:INT,1)	
	RectFill(stdrast,cyclewindow.borderleft,cyclewindow.bordertop,cyclewindow.width-cyclewindow.borderright-1,cyclewindow.height-cyclewindow.borderbottom-1)
	setAfPt(stdrast,[$FFFF]:INT,0)

	doubbevel(stdrast,8,16,124,52,FALSE)

	cyclegadgets[0]:=createGadget(cyclewindow,'Tempo',GTYP_PROPGADGET,PROPFL OR FREEHORIZ,255,19,35,100,10,ID_CYCTEMPO)
	IF cyclegadgets[0]=NIL THEN Raise(E_NONE)

	Colour(1,0)
	dispprop(cyclegadgets[0],0)
	setprop(cyclewindow,cyclegadgets[0],0,255-(cmics/1024))

	cyclegadgets[1]:=createGadget(cyclewindow,'Umkehren',GTYP_BOOLGADGET,0,0,(cyclewindow.width/2)-40,49,80,14,ID_CYCCHANGE)
	IF cyclegadgets[1]=NIL THEN Raise(E_NONE)

	IF (cycleport:=getport('Fraktalik Timer.port'))=NIL THEN Raise(E_NONE)
	cyclemask:=Shl(1,cycleport.sigbit)

	IF (cyclereq:=getioblock(cycleport,SIZEOF timerequest))=NIL THEN Raise(E_NONE)
	OpenDevice('timer.device',UNIT_MICROHZ,cyclereq,0)
	
	OffMenu(win,Shl(1,11) OR Shl(0,5) OR 2)

	windowlock(clist,WL_UNLOCK)

	sendCycle()
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],0)
	IF cyclereq<>NIL
		io:=cyclereq.io
		IF (io.device<>NIL) AND (exception<>E_TIME) THEN CloseDevice(cyclereq)
		deleteioblock(cyclereq)
	ENDIF
	IF cycleport<>NIL
		cyclemask:=0
		deleteport(cycleport)
	ENDIF
	IF cyclewindow<>NIL
		FOR i:=0 TO 1
			IF cyclegadgets[i]<>NIL
				delgadget(cyclewindow,cyclegadgets[i])
				cyclegadgets[i]:=NIL
			ENDIF
		ENDFOR	
		RtCloseWindowSafely(cyclewindow)
		cyclewindow:=NIL
	ENDIF
	windowlock(clist,WL_UNLOCK)
ENDPROC


PROC closeCycWindow()
	DEF i

	windowlock(clist,WL_LOCK)

	cyclemask:=0
	WaitIO(cyclereq)

	CloseDevice(cyclereq)
	deleteioblock(cyclereq);cyclereq:=NIL
	deleteport(cycleport);cycleport:=NIL

	FOR i:=0 TO 1
		delgadget(cyclewindow,cyclegadgets[i])
		cyclegadgets[i]:=NIL
	ENDFOR
	RtCloseWindowSafely(cyclewindow)
	cyclewindow:=NIL

	OnMenu(win,Shl(1,11) OR Shl(0,5) OR 2)

	windowlock(clist,WL_UNLOCK)
ENDPROC


PROC windowlock(list:PTR TO mlh,mode)
	DEF cl:PTR TO class,viewlist:PTR TO mlh,view:PTR TO subclass

	SELECT mode
	CASE WL_LOCK
		IF Not(lockstate)
			IF win<>NIL THEN winlock:=RtLockWindow(win)

			cl:=list.head
			WHILE cl.succ<>NIL
				viewlist:=cl.viewlist
				view:=viewlist.head
				WHILE view.succ<>NIL
					IF view.window<>NIL THEN view.lock:=RtLockWindow(view.window)
					view:=view.succ
				ENDWHILE
				IF cl.mainwin<>NIL THEN cl.lock:=RtLockWindow(cl.mainwin)
				cl:=cl.succ
			ENDWHILE
			lockstate:=TRUE
		ENDIF

	CASE WL_UNLOCK
		IF lockstate
			RtUnlockWindow(win,winlock)

			cl:=list.head
			WHILE cl.succ<>NIL
				viewlist:=cl.viewlist
				view:=viewlist.head
				WHILE view.succ<>NIL
					RtUnlockWindow(view.window,view.lock)
					view:=view.succ
				ENDWHILE
				RtUnlockWindow(cl.mainwin,cl.lock)
				cl:=cl.succ
			ENDWHILE
			lockstate:=FALSE
		ENDIF
	ENDSELECT
ENDPROC


PROC handleprop(w:PTR TO window,g:PTR TO gadget,sum)
	DEF p:PTR TO propinfo,m:PTR TO intuimessage,idcmp

	stdrast:=w.rport
	Colour(1,0)
	p:=g.specialinfo
	IF (p.flags AND KNOBHIT)
		idcmp:=w.idcmpflags
		ModifyIDCMP(w,IDCMP_GADGETUP)
		WHILE (m:=GetMsg(portIDCMP))=NIL DO dispprop(g,sum)
		ReplyMsg(m)
		ModifyIDCMP(w,idcmp)
	ENDIF
	dispprop(g,sum)
	WHILE (m:=GetMsg(portIDCMP))<>NIL DO ReplyMsg(m)
ENDPROC getprop(g,sum)

PROC getport(name) HANDLE
	RAISE E_MEM IF New()=NIL
	DEF gport:PTR TO mp,sig,node:PTR TO ln

	IF (sig:=AllocSignal(-1))=-1 THEN Raise(E_SIGBIT)
	gport:=New(SIZEOF mp)
	node:=gport.ln
	node.type:=NT_MSGPORT
	node.pri:=0
	node.name:=name
	gport.sigbit:=sig
	gport.sigtask:=FindTask(0)
	AddPort(gport)
EXCEPT
	request(erlist[exception],declist[D_OK],0)
	IF sig<>0 THEN FreeSignal(sig)
	IF gport<>NIL THEN Dispose(gport)
	gport:=NIL
ENDPROC gport

PROC deleteport(delport:PTR TO mp)
	RemPort(delport)
	FreeSignal(delport.sigbit)
	Dispose(delport)
ENDPROC

PROC getioblock(rplport,size) HANDLE
	RAISE E_MEM IF New()=NIL

	DEF block:PTR TO io,tm:PTR TO mn,node:PTR TO ln

	block:=New(size)
	tm:=block.mn
	node:=tm.ln
	node.type:=NT_MESSAGE
	node.pri:=0
	node.name:=NIL
	tm.replyport:=rplport
	tm.length:=size
EXCEPT
	request(erlist[exception],declist[D_OK],0)
	block:=NIL
ENDPROC	block


PROC deleteioblock(block:PTR TO io)
	IF block=NIL THEN RETURN 0
	Dispose(block)
ENDPROC


PROC request(body,gad,args) HANDLE
	RAISE E_NONE IF RtAllocRequestA()=NIL

	DEF e,ir:PTR TO rtreqinfo,w:PTR TO window
	
	windowlock(clist,WL_LOCK)
	ir:=RtAllocRequestA(RT_REQINFO,NIL)
	e:=RtEZRequestA(body,gad,ir,args,
			[RT_UNDERSCORE,"_",
			RT_REQPOS,REQPOS_POINTER,
			RTEZ_FLAGS,EZREQF_CENTERTEXT,
			RTEZ_REQTITLE,'Information',
			TAG_DONE])
	RtFreeRequest(ir)
	windowlock(clist,WL_UNLOCK)
EXCEPT
	IF (w:=OpenW(scr.width/2-90,scr.height/2-40,180,80,IDCMP_CLOSEWINDOW,
		WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR WFLG_DRAGBAR OR WFLG_ACTIVATE,
		'Fehler',scr,$F,NIL))<>NIL
		TextF(w.borderleft+5,w.bordertop+12,'Zu wenig Speicher für')
		TextF(w.borderleft+5,w.bordertop+22,'   Dialogfenster.')
		TextF(w.borderleft+5,w.bordertop+42,'Programm wird beendet!')
		WaitIMessage(w)
		CloseW(w)
	ENDIF
	cleardesk(clist)
	closeall()
	CleanUp(0)
ENDPROC e


PROC built3d(view:PTR TO subclass)
	DEF colors,x,y,cl:PTR TO class,rp,dat,wert,wid,hei,
		w:PTR TO window,groesse,farbe,x1,y1,y2,hei2,xkorrek,ykorrek,
		xpixel,ypixel1,ypixel2

	w:=view.window
	SetWindowTitles(w,-1,'3D-Ansicht wird berechnet...')

	colors:=Shl(1,depth)-4
	rp:=view.rport

	cl:=view.class
	dat:=cl.data
	wid:=cl.width-1
	hei:=cl.height-1
	groesse:=hei/2					/* =Berghöhe */
	hei2:=hei/2	
	xkorrek:=wid+hei2+groesse		/* Korrekturwerte für Skalierung auf Fenstergröße */
	ykorrek:=groesse+hei2			/* = Anzahl Pixel, die über den Rand hinausragen */

	FOR y:=0 TO cl.done-1
		y1:=y/2+groesse
		x1:=wid+y
		FOR x:=wid TO 0 STEP -1
			wert:=getxy(cl,x,y)

			xpixel:=x1*wid/xkorrek

			y2:=y1-(groesse*wert/cl.it)
			ypixel1:=y1*hei/ykorrek
			ypixel2:=y2*hei/ykorrek

			farbe:=IF wert<cl.it THEN colors*wert/cl.it+4 ELSE 1

			SetAPen(rp,0);Move(rp,xpixel,ypixel1);Draw(rp,xpixel,ypixel2)
			SetAPen(rp,3);Move(rp,xpixel+1,ypixel1);Draw(rp,xpixel+1,ypixel2+1)
			SetAPen(rp,farbe);WritePixel(rp,xpixel,ypixel2)

			DEC x1
		ENDFOR
	ENDFOR
	SetWindowTitles(w,-1,view.name)
ENDPROC


PROC getxy(cl:PTR TO class,x,y)
ENDPROC Int(cl.data+Mul(2,Mul(y,cl.width)+x))

PROC builtcolor(view:PTR TO subclass)
	DEF colors,cl:PTR TO class,rp,dat,
		w:PTR TO window,wid,hei,max

	cl:=view.class
	IF cl.done=0 THEN RETURN(0)
	w:=view.window
	SetWindowTitles(w,-1,'Farbansicht wird erstellt...')
	colors:=Shl(1,depth)-4
	rp:=view.rport
	dat:=cl.data
	wid:=cl.width-1
	hei:=cl.done-1
	max:=cl.it

	MOVE.L	rp,A2
	MOVE.L	dat,A3
	MOVE.L	gfxbase,A6
	MOVEQ	#0,D0
	MOVE.L	hei,D3
	MOVEQ	#0,D5
	MOVE.L	colors,D7
bcy:
	MOVE.L	wid,D2
	CLR.L	D4
bcx:
	MOVE.W	(A3)+,D0
	CMP.L	max,D0
	BLT		bccolor
	MOVEQ	#1,D0
	BRA		bcdraw
bccolor:
	DIVU	D7,D0
	SWAP	D0
	AND.L	#$FFFF,D0
	ADDQ.B	#4,D0
bcdraw:
	MOVE.L	A2,A1
	JSR		-342(A6)			/* SetAPen */
	MOVE.W	D4,D0
	MOVE.W	D5,D1
	MOVE.L	A2,A1
	JSR		-324(A6)			/* WritePixel */
	ADDQ.W	#1,D4
	DBRA	D2,bcx
	ADDQ.W	#1,D5
	DBRA	D3,bcy
	
	SetWindowTitles(w,-1,view.name)
ENDPROC


PROC getgadgets(cl:PTR TO class)
	DEF g[8]:ARRAY OF LONG

	IF cl.flgot=FALSE
		g:=cl.gadgets
		cl.xmin:=strtoffp(getstring(g[0]))
		cl.xmax:=strtoffp(getstring(g[1]))
		cl.ymin:=strtoffp(getstring(g[2]))
		cl.ymax:=strtoffp(getstring(g[3]))
		cl.it:=Val(getstring(g[4]),NIL)
		IF cl.it<3
			cl.it:=3
			setvalue(cl.mainwin,g[4],'1')
		ENDIF
		IF cl.data<>NIL
			FreeMem(cl.data,clsize(cl))
			cl.data:=NIL
		ENDIF
		cl.ydone:=cl.ymax
		cl.done:=0
		cl.flstarted:=0
		cl.flinterrupted:=FALSE
		cl.width:=getprop(g[5],PROPADD)
		cl.height:=getprop(g[6],PROPADD)
		cl.flgot:=TRUE
	ENDIF
ENDPROC


PROC putgadgets(cl:PTR TO class)
	DEF w,st[10]:STRING,g[8]:ARRAY OF LONG
	w:=cl.mainwin
	g:=cl.gadgets
	setvalue(w,g[0],ffptostr(cl.xmin,7))
	setvalue(w,g[1],ffptostr(cl.xmax,7))
	setvalue(w,g[2],ffptostr(cl.ymin,7))
	setvalue(w,g[3],ffptostr(cl.ymax,7))
	setvalue(w,g[4],StringF(st,'\d',cl.it) BUT st)
	setprop(w,g[5],PROPADD,cl.width)
	setprop(w,g[6],PROPADD,cl.height)
	cl.flgot:=TRUE
ENDPROC

PROC clsize(cl:PTR TO class)
ENDPROC Mul(Mul(cl.width,cl.height),2)

PROC finish(cl:PTR TO class)
	DEF w:PTR TO window,st[35]:STRING,g[8]:ARRAY OF LONG

	w:=cl.mainwin
	g:=cl.gadgets
	cl.flsaved:=FALSE

	SetStdRast(w.rport)
	SetDrMd(stdrast,1)

	delgadget(w,g[7])
	delgadget(w,g[8])
	offgadgets(cl)

	SetAPen(stdrast,2)
	setAfPt(stdrast,[$AAAA,$5555]:INT,1)	
	RectFill(stdrast,10,w.bordertop+170,w.width-10,w.bordertop+184)
	setAfPt(stdrast,[$FFFF]:INT,0)

	StringF(st,'Speicherbedarf: \d Bytes',clsize(cl))
	SetDrMd(stdrast,0)
	SetAPen(stdrast,2)
	TextF(w.width/2-(StrLen(st)*4)+1,w.bordertop+181,'\s',st)
	SetAPen(stdrast,1)
	TextF(w.width/2-(StrLen(st)*4),w.bordertop+180,'\s',st)
	SetDrMd(stdrast,1)
ENDPROC

PROC start(cl:PTR TO class) HANDLE
	RAISE E_TASK IF AllocMem()=NIL
	
	DEF length,viewlist:PTR TO mlh,view:PTR TO subclass,g[8]:ARRAY OF LONG,
		erg,mess

	g:=cl.gadgets
	viewlist:=cl.viewlist
	view:=viewlist.head
	IF (cl.flgot=FALSE) AND (view.succ<>NIL)
		IF request(msglist[M_START],declist[D_JANEIN],0)=0 THEN RETURN DO_ABBRUCH
		clearviews(cl)
	ENDIF
	getgadgets(cl)
	offgadgets(cl)

	length:=clsize(cl)
	IF cl.data=NIL THEN cl.data:=AllocMem(length,$10001)

	cl.flstarted:=1
	cl.flinterrupted:=FALSE
	cl.flsaved:=FALSE

	IF cl.done<cl.height
		OffGadget(g[7],cl.mainwin,NIL)
		onbutton(g[8],cl.mainwin)
		mandel(cl)
	ENDIF

	IF cl.flinterrupted=FALSE
		finish(cl)
		mess:=msglist[M_READY]
	ELSE
		OffGadget(g[8],cl.mainwin,NIL)
		onbutton(g[7],cl.mainwin)
		ongadgets(cl)
		mess:=msglist[M_INTERRUPTED]
	ENDIF		

	IF (erg:=request(mess,declist[D_READY],0))<>0
		view:=newview(cl,erg-1)
		IF view<>NIL THEN RtUnlockWindow(view.window,view.lock)
	ENDIF

EXCEPT
	request(erlist[exception],declist[D_OK],0)
	IF cl.data<>NIL THEN FreeMem(cl.data,length)
	OffGadget(g[8],cl.mainwin,NIL)
	onbutton(g[7],cl.mainwin)
	ongadgets(cl)
ENDPROC


PROC doscroll(view:PTR TO subclass,x,y)
	DEF msg:PTR TO intuimessage,w:PTR TO window,
		xe,ye,xmax,ymax,class,cl:PTR TO class,
		x1,y1,x2,y2,rp1,rp2,end,dx,dy,oldidcmp

	w:=view.window
	oldidcmp:=w.idcmpflags
	ModifyIDCMP(w,IDCMP_MOUSEMOVE OR IDCMP_DELTAMOVE OR IDCMP_MOUSEBUTTONS OR IDCMP_INACTIVEWINDOW)
	
	IF (x>=w.borderleft) AND (y>=w.bordertop) AND (x<w.width-w.borderright) AND (y<w.height-w.borderbottom)
		SetWindowTitles(w,-1,'Inhalt mit der Maus verschieben')
		SetPointer(w,maus,15,15,-8,-7)
		xe:=view.x
		ye:=view.y
		cl:=view.class
		xmax:=cl.width-w.width+horizrand
		ymax:=cl.height-w.height+vertrand
		x1:=w.borderleft
		y1:=w.bordertop
		x2:=w.width-horizrand-1
		y2:=w.height-vertrand-1
		rp1:=view.rport
		rp2:=w.rport
		end:=w.topedge+w.height-1
		class:=0
		WHILE (class<>IDCMP_MOUSEBUTTONS) AND (class<>IDCMP_INACTIVEWINDOW)
			IF (msg:=GetMsg(portIDCMP))<>NIL
				class:=msg.class
				dx:=msg.mousex;dy:=msg.mousey
				ReplyMsg(msg)
				IF dx>32767 THEN xe:=xe-dx+65536 ELSE xe:=xe-dx
				IF dy>32767 THEN ye:=ye-dy+65536 ELSE ye:=ye-dy
				IF xe<0 THEN xe:=0
				IF ye<0 THEN ye:=0
				IF xe>xmax THEN xe:=xmax
				IF ye>ymax THEN ye:=ymax
				WHILE VbeamPos()<end DO NOP
				ClipBlit(rp1,xe,ye,rp2,x1,y1,x2,y2,192)
			ENDIF
		ENDWHILE
		view.x:=xe;view.y:=ye
		IF class=IDCMP_INACTIVEWINDOW THEN DisplayBeep(scr)
		ClearPointer(w)
		SetWindowTitles(w,-1,view.name)
	ENDIF
	ModifyIDCMP(w,oldidcmp)
	WHILE (msg:=GetMsg(portIDCMP))<>NIL DO ReplyMsg(msg)
ENDPROC


PROC disprast(view:PTR TO subclass)
	DEF wind:PTR TO window
	wind:=view.window
	ClipBlit(view.rport,view.x,view.y,wind.rport,wind.borderleft,wind.bordertop,
			wind.width-horizrand-1,wind.height-vertrand-1,
			192)
ENDPROC


PROC mark(view:PTR TO subclass,xa,ya,xe,ye)
	DEF msg:PTR TO intuimessage,mx1,mx2,my1,my2,mxa,mya,w:PTR TO window,
		class,xmin,xmax,ymin,ymax,mxs,mys

	w:=view.window
	SetWindowTitles(w,-1,'Bereich mit der Maus markieren!')
	ModifyIDCMP(w,IDCMP_MOUSEBUTTONS OR IDCMP_MOUSEMOVE OR IDCMP_INACTIVEWINDOW)
	SetDrMd(w.rport,2)
	REPEAT
		IF (msg:=GetMsg(portIDCMP))<>NIL
			class:=msg.class
			ReplyMsg(msg)
		ENDIF
	UNTIL (class=IDCMP_MOUSEBUTTONS) OR (class=IDCMP_INACTIVEWINDOW)
	IF class=IDCMP_INACTIVEWINDOW
		DisplayBeep(scr)
		RETURN DO_ABBRUCH
	ENDIF
	class:=0
	xmin:=w.borderleft;ymin:=w.bordertop
	xmax:=w.borderleft+w.width-horizrand-1;ymax:=w.bordertop+w.height-vertrand-1
	mx1:=msg.mousex;my1:=msg.mousey
	mx2:=mx1+1;my2:=my1+1
	drawbox(w,mx1,my1,mx2,my2)
	REPEAT
		IF (msg:=GetMsg(portIDCMP))<>NIL
			class:=msg.class
			mxa:=mx2;mya:=my2
			mx2:=msg.mousex;my2:=msg.mousey
			ReplyMsg(msg)
			IF mx2=mx1 THEN mx2:=mx1+1
			IF my2=my1 THEN my2:=my1+1
			IF mx1<w.borderleft THEN mx1:=w.borderleft
			IF mx1>xmax THEN mx1:=xmax
			IF my1<w.bordertop THEN my1:=w.bordertop
			IF my1>ymax THEN my1:=ymax
			IF mx2<w.borderleft THEN mx2:=w.borderleft
			IF mx2>xmax THEN mx2:=xmax
			IF my2<w.bordertop THEN my2:=w.bordertop
			IF my2>ymax THEN my2:=ymax
			drawbox(w,mx1,my1,mxa,mya)
			drawbox(w,mx1,my1,mx2,my2)
		ENDIF
	UNTIL (class=IDCMP_MOUSEBUTTONS) OR (class=IDCMP_INACTIVEWINDOW)
	IF class=IDCMP_INACTIVEWINDOW
		DisplayBeep(scr)
		RETURN DO_ABBRUCH
	ENDIF

	IF mx1>mx2					/* ---- Sortieren */
		mxs:=mx1
		mx1:=mx2
		mx2:=mxs
	ENDIF
	IF my1>my2
		mys:=my1
		my1:=my2
		my2:=mys
	ENDIF
	drawbox(w,mx1,my1,mx2,my2)
	ModifyIDCMP(w,VIDCMP)
	SetDrMd(w.rport,0)
	mx1:=mx1-w.borderleft+view.x
	mx2:=mx2-w.borderleft+view.x
	my1:=my1-w.bordertop+view.y
	my2:=my2-w.bordertop+view.y
	^xa:=mx1
	^ya:=my1
	^xe:=mx2
	^ye:=my2
	SetWindowTitles(w,-1,view.name)
	WHILE (msg:=GetMsg(portIDCMP))<>NIL DO ReplyMsg(msg)
ENDPROC DO_NONE

PROC zoomout(view:PTR TO subclass)
	DEF cl:PTR TO class,w:PTR TO window,mx1,mx2,my1,my2,
		deltax,deltay,scl:PTR TO class

	w:=view.window
	cl:=view.class
	IF mark(view,{mx1},{my1},{mx2},{my2})=DO_ABBRUCH THEN RETURN DO_ABBRUCH
	deltax:=SpDiv(SpFlt(cl.width),SpSub(cl.xmin,cl.xmax))
	deltay:=SpDiv(SpFlt(cl.height),SpSub(cl.ymin,cl.ymax))
	IF (scl:=newclass(clist))<>NIL
		scl.xmin:=SpSub(SpMul(deltax,SpFlt(mx1)),cl.xmin)
		scl.xmax:=SpAdd(SpMul(deltax,SpFlt(cl.width-mx2)),cl.xmax)
		scl.ymin:=SpSub(SpMul(deltay,SpFlt(my1)),cl.ymin)
		scl.ymax:=SpAdd(SpMul(deltay,SpFlt(cl.height-my2)),cl.ymax)
		scl.ydone:=scl.ymax
		scl.it:=cl.it
		scl.width:=cl.width
		scl.height:=cl.height
		putgadgets(scl)
		dispstate(scl,0)
		RtUnlockWindow(scl.mainwin,scl.lock)
	ENDIF
ENDPROC

PROC zoomin(view:PTR TO subclass)
	DEF cl:PTR TO class,w:PTR TO window,mx1,mx2,my1,my2,
		deltax,deltay,scl:PTR TO class

	w:=view.window
	cl:=view.class
	IF mark(view,{mx1},{my1},{mx2},{my2})=DO_ABBRUCH THEN RETURN DO_ABBRUCH
	deltax:=SpDiv(SpFlt(cl.width),SpSub(cl.xmin,cl.xmax))
	deltay:=SpDiv(SpFlt(cl.height),SpSub(cl.ymin,cl.ymax))
	
	IF (scl:=newclass(clist))<>NIL
		scl.xmin:=SpAdd(SpMul(deltax,SpFlt(mx1)),cl.xmin)
		scl.xmax:=SpAdd(SpMul(deltax,SpFlt(mx2)),cl.xmin)
		scl.ymin:=SpSub(SpMul(deltay,SpFlt(my2)),cl.ymax)
		scl.ymax:=SpSub(SpMul(deltay,SpFlt(my1)),cl.ymax)
		scl.ydone:=scl.ymax
		scl.it:=cl.it
		scl.width:=cl.width
		scl.height:=cl.height
		putgadgets(scl)
		dispstate(scl,0)
		RtUnlockWindow(scl.mainwin,scl.lock)
	ENDIF
ENDPROC

PROC setprop(w:PTR TO window,g:PTR TO gadget,sum,wert)
	DEF p:PTR TO propinfo

	stdrast:=w.rport
	Colour(1,0)
	p:=g.specialinfo
	wert:=wert-sum
	NewModifyProp(g,w,NIL,p.flags,wert*p.horizbody,p.vertpot,p.horizbody,p.vertbody,1)
	dispprop(g,sum)
ENDPROC

PROC getstring(g:PTR TO gadget)	/* gibt string-Adr zurück */
	DEF s:PTR TO stringinfo
	s:=g.specialinfo
ENDPROC s.buffer

PROC getprop(g:PTR TO gadget,sum)	/* sum = Summand wenn Beginn<>0 */
	DEF p:PTR TO propinfo

	p:=g.specialinfo
ENDPROC	p.horizpot/p.horizbody+sum

PROC dispprop(g:PTR TO gadget,sum)
	TextF(g.leftedge+g.width-30,g.topedge-7,'\d[4]',getprop(g,sum))
ENDPROC

PROC setvalue(w,g:PTR TO gadget,fill)
	DEF	s:PTR TO stringinfo,i,l
	
	s:=g.specialinfo
	FOR i:=0 TO s.maxchars DO PutChar(s.buffer+i,0)
	l:=StrLen(fill)
	IF l>s.maxchars THEN l:=s.maxchars
	CopyMem(fill,s.buffer,l)
	RefreshGList(g,w,NIL,1)
ENDPROC

PROC ffptostr(float,komma)
	DEF wert,vork[20]:STRING,nachk[20]:STRING,
		minus,str[20]:STRING,st[20]:STRING

	IF SpTst(float)=-1
		float:=SpNeg(float)
		minus:=TRUE
	ELSE
		minus:=FALSE
	ENDIF
	wert:=SpFix(float)
	StringF(vork,'\d',wert)
	float:=SpSub(SpFlt(wert),float)
	wert:=SpFix(SpMul(SpPow(SpFlt(komma+1),ZEHN),float))
	StringF(nachk,'\d',wert)
	MidStr(st,nachk,0,komma)
	StrCopy(nachk,st,ALL)
	IF minus=TRUE THEN StrCopy(str,'-',ALL)
	StrAdd(str,vork,ALL)
	StrAdd(str,'.',ALL)
	StrAdd(str,nachk,ALL)
ENDPROC str

PROC strtoffp(st)
	DEF float=0,punktpos,vork[20]:STRING,nachk[20]:STRING,
		zs[20]:STRING,i,minus,s2[20]:STRING,exp,re:PTR TO LONG,zeichen,
		nofloat=FALSE

	i:=0
	WHILE (nofloat=FALSE) AND (i<StrLen(st))
		zeichen:=Char(st+i)
		IF Not(((zeichen>="0") AND (zeichen<="9")) OR (zeichen=".") OR (zeichen="-")) THEN nofloat:=TRUE
		INC i
	ENDWHILE
	
	IF nofloat
		float:=0
	ELSE
		punktpos:=InStr(st,'.',0)
		IF punktpos=-1						/* integer-Zahl ohne Kommastellen */
			float:=SpFlt(Val(st,re))
		ELSE								/* Dezimalbruch */
			IF InStr(st,'-',0)=-1
				minus:=FALSE
				StrCopy(s2,st,ALL)
			ELSE
				minus:=TRUE;DEC punktpos
				RightStr(s2,st,EstrLen(st)-1)
			ENDIF
			MidStr(vork,s2,0,punktpos)
			MidStr(nachk,s2,punktpos+1,ALL)
			StrCopy(zs,vork,ALL)
			StrAdd(zs,nachk,ALL)
			exp:=punktpos-EstrLen(zs)
			FOR i:=EstrLen(zs)-1 TO 0 STEP -1
				float:=SpAdd(float,SpMul(SpFlt(Char(zs+i)-48),SpPow(SpFlt(exp),ZEHN)))
				INC exp
			ENDFOR
			IF minus THEN float:=SpNeg(float)
		ENDIF
	ENDIF
ENDPROC float

PROC drawbox(w:PTR TO window,x1,y1,x2,y2)
	DEF rp
	rp:=w.rport
	Move(rp,x1,y1)
	PolyDraw(rp,4,[x1,y2,x2,y2,x2,y1,x1,y1]:INT)
ENDPROC

PROC newview(cl:PTR TO class,typ) HANDLE
	RAISE	E_MEM IF New()=NIL
    RAISE	E_BITMAP IF AllocRaster()=NIL
	RAISE	E_VIEW IF OpenW()=NIL

	DEF wi: PTR TO window,view:PTR TO subclass,
		sv:PTR TO subclass,viewlist:PTR TO mlh,
		i,id,name=NIL,tit[420]:STRING,wid,hei,found,
		bm:PTR TO bitmap,rp:PTR TO rastport,pl[7]:ARRAY OF LONG

	wi:=NIL;bm:=NIL;rp:=NIL;name:=NIL;view:=NIL
	FOR i:=0 TO depth-1 DO pl[i]:=NIL

	IF cl.data=NIL
		request(erlist[E_NODATA],declist[D_OK],[cl.name])
		Raise(E_NONE)
	ENDIF

	name:=New(420)
	view:=New(SIZEOF subclass)
	bm:=New(SIZEOF bitmap)

	InitBitMap(bm,depth,cl.width,cl.height)
	pl:=bm.plane
	FOR i:=0 TO depth-1 DO pl[i]:=AllocRaster(cl.width,cl.height)

	rp:=New(SIZEOF rastport)
	InitRastPort(rp)
	rp.bitmap:=bm

	viewlist:=cl.viewlist
	i:=1;id:=0
	sv:=viewlist.head							/* find next ID-number */
	WHILE (sv.succ<>0) AND (id<>i)
		found:=FALSE	
		WHILE sv.succ<>0
			IF sv.nr=i THEN found:=TRUE
			sv:=sv.succ
		ENDWHILE
		IF found=FALSE
			id:=i
		ELSE
			INC i
			sv:=viewlist.head
		ENDIF
	ENDWHILE
	id:=i

	StringF(tit,'Ansicht #\d von \s',id,cl.name)
	CopyMem(TrimStr(tit),name,EstrLen(tit))

	wid:=cl.width+horizrand
	hei:=cl.height+vertrand
	IF wid>scr.width THEN wid:=scr.width
	IF hei>(scr.height-vertrand-1) THEN hei:=(scr.height-vertrand-1)

	wi:=OpenW(scr.width/2-(wid/2),scr.height/2-(hei/2),wid,hei,0,VFLG,name,scr,$F,NIL)
	wi.userport:=portIDCMP
	ModifyIDCMP(wi,VIDCMP)
	WindowLimits(wi,PROPADD+horizrand,PROPADD+vertrand,wid,hei)
	SetMenuStrip(wi,xmenu)
	SetWindowTitles(wi,-1,name)

	view.lock:=RtLockWindow(wi)
	view.name:=name
	view.window:=wi
	view.viewtype:=typ
	view.rport:=rp
	view.bitmap:=bm
	view.class:=cl
	view.nr:=id
	view.req:=NIL

	Enqueue(viewlist,view)
	wi.userdata:=view
	wi.extdata:=WIN_VIEW

	SetAPen(view.rport,2)
	RectFill(view.rport,0,0,cl.width-1,cl.height-1)

	SELECT typ
	CASE VIEW_FARB
		VOID builtcolor(view)
	CASE VIEW_3D
		VOID built3d(view)
	ENDSELECT
	disprast(view)
EXCEPT
	IF wi<>NIL
		ClearPointer(wi)
		ClearMenuStrip(wi)
		RtCloseWindowSafely(wi)
	ENDIF
	IF view<>NIL THEN Dispose(view)
	IF name<>NIL THEN Dispose(name)
	IF bm<>NIL
		pl:=bm.plane
		FOR i:=0 TO depth-1 DO IF pl[i]<>NIL THEN FreeRaster(pl[i],cl.width,cl.height)
		Dispose(bm)
	ENDIF
	IF rp<>NIL THEN Dispose(rp)
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],0)
	view:=NIL
ENDPROC view


PROC deleteview(view:PTR TO subclass) HANDLE
	DEF	bm:PTR TO bitmap,rp:PTR TO rastport,
		cl:PTR TO class,w:PTR TO window,i,pl[7]:ARRAY OF LONG,e

	IF view.req<>NIL THEN Raise(E_VIEWBUSY)

	e:=DO_NONE
	w:=view.window
	ClearMenuStrip(w)
	RtCloseWindowSafely(w)
	cl:=view.class
	rp:=view.rport
	bm:=view.bitmap
	pl:=bm.plane
	FOR i:=0 TO depth-1 DO FreeRaster(pl[i],cl.width,cl.height)
	Dispose(bm)
	Dispose(rp)
	Dispose(view.name)
	Remove(view)
	Dispose(view)
EXCEPT
	request(erlist[exception],declist[D_OK],[view.name])
	e:=DO_ABBRUCH
ENDPROC e


PROC onbutton(g:PTR TO gadget,wi:PTR TO window)
	stdrast:=wi.rport
	Box(g.leftedge,g.topedge,g.leftedge+g.width-1,g.topedge+g.height-1,0)
	bevelbox(stdrast,g.leftedge,g.topedge,g.width,g.height,TRUE)
	OnGadget(g,wi,NIL)
ENDPROC


PROC dispstate(cl:PTR TO class,y_yet)
	DEF w:PTR TO window,prozent,x,y

	w:=cl.mainwin
	x:=w.width/2-100
	y:=w.bordertop+190

	bevelbox(w.rport,x-2,y-1,204,18,FALSE)

	SetAPen(w.rport,0)
	RectFill(w.rport,x,y,x+199,y+15)

	prozent:=100*y_yet/cl.height
	SetAPen(w.rport,3)
	RectFill(w.rport,x,y,200*prozent/100+x-1,y+15)
	Colour(1,0)
	SetStdRast(w.rport)
	SetDrMd(stdrast,0)
	TextF(85+x,11+y,'\d[3]%',prozent)
	Colour(2,0)
	TextF(84+x,10+y,'\d[3]%',prozent)
	SetDrMd(stdrast,1)
ENDPROC


PROC offgadgets(cl:PTR TO class)
	DEF w,g[8]:ARRAY OF LONG,i,ga:PTR TO gadget,saveg

	w:=cl.mainwin
	g:=cl.gadgets
	FOR i:=0 TO 6
		ga:=g[i]
		saveg:=ga.nextgadget
		ga.nextgadget:=NIL
		OffGadget(ga,w,NIL)
		ga.nextgadget:=saveg
	ENDFOR
	OffGadget(g[7],w,NIL)
	OffGadget(g[8],w,NIL)
ENDPROC


PROC ongadgets(cl:PTR TO class)
	DEF w:PTR TO window,ga[8]:ARRAY OF LONG,g:PTR TO gadget,i,saveg

	w:=cl.mainwin
	ga:=cl.gadgets
	SetAPen(w.rport,0)
	OnGadget(ga[6],w,NIL)
	OnGadget(ga[5],w,NIL)
	FOR i:=4 TO 0 STEP -1
		g:=ga[i]
		saveg:=g.nextgadget
		g.nextgadget:=NIL
		RectFill(w.rport,g.leftedge,g.topedge,g.leftedge+g.width-1,g.topedge+g.height-1)
		OnGadget(g,w,NIL)
		g.nextgadget:=saveg
	ENDFOR
ENDPROC


PROC setAfPt(rp:PTR TO rastport,muster,zeilenexponent)
	rp.areaptrn:=muster
	rp.areaptsz:=zeilenexponent
ENDPROC


PROC openClassWindow(cl:PTR TO class,title,s:PTR TO screen) HANDLE
	RAISE E_WIN IF OpenW()=NIL

	DEF w:PTR TO window,g[8]:ARRAY OF LONG,i

	w:=OpenW(s.width/2-120,s.height/2-100,240,225,0,PFLG,title,s,$F,NIL)
	w.userport:=portIDCMP
	ModifyIDCMP(w,PIDCMP)
	SetMenuStrip(w,xmenu)
	SetWindowTitles(w,-1,title)
	cl.lock:=RtLockWindow(w)

	SetAPen(stdrast,2)
	setAfPt(stdrast,[$AAAA,$5555]:INT,1)	
	RectFill(stdrast,w.borderleft,w.bordertop,w.width-w.borderright-1,w.height-w.borderbottom-1)
	setAfPt(stdrast,[$FFFF]:INT,0)
	SetDrMd(stdrast,1)

	doubbevel(w.rport,w.borderleft+2,w.bordertop+2,w.width-w.borderright-8,93,FALSE)
	doubbevel(w.rport,w.borderleft+2,w.bordertop+100,w.width-w.borderright-8,64,FALSE)
	Colour(1,0)

	g:=cl.gadgets

	g[0]:=createGadget(w,'X-min',GTYP_STRGADGET,STRACT,10,20,w.bordertop+19,80,8,100)
	IF g[0]=NIL THEN Raise(E_NONE)

	g[1]:=createGadget(w,'X-max',GTYP_STRGADGET,STRACT,10,120,w.bordertop+19,80,8,101)
	IF g[1]=NIL THEN Raise(E_NONE)

	g[2]:=createGadget(w,'Y-min',GTYP_STRGADGET,STRACT,10,20,w.bordertop+48,80,8,102)
	IF g[2]=NIL THEN Raise(E_NONE)

	g[3]:=createGadget(w,'Y-max',GTYP_STRGADGET,STRACT,10,120,w.bordertop+48,80,8,103)
	IF g[3]=NIL THEN Raise(E_NONE)

	g[4]:=createGadget(w,'Iterationen',GTYP_STRGADGET,STRACT OR GACT_LONGINT,4,20,w.bordertop+80,32,8,104)
	IF g[4]=NIL THEN Raise(E_NONE)

	g[5]:=createGadget(w,'Bildbreite',GTYP_PROPGADGET,PROPFL OR FREEHORIZ,2048,20,w.bordertop+119,200,8,200)
	IF g[5]=NIL THEN Raise(E_NONE)
	Colour(1,0)
	dispprop(g[5],PROPADD)

	g[6]:=createGadget(w,'Bildhöhe',GTYP_PROPGADGET,PROPFL OR FREEHORIZ,2048,20,w.bordertop+149,200,8,201)
	IF g[6]=NIL THEN Raise(E_NONE)
	Colour(1,0)
	dispprop(g[6],PROPADD)

	g[7]:=createGadget(w,'Start',GTYP_BOOLGADGET,0,0,10,w.bordertop+170,70,14,ID_START)
	IF g[7]=NIL THEN Raise(E_NONE)

	g[8]:=createGadget(w,'Stop',GTYP_BOOLGADGET,0,0,w.width-w.borderright-76,w.bordertop+170,70,14,ID_STOP)
	IF g[8]=NIL THEN Raise(E_NONE)

	OffGadget(g[8],w,NIL)
	cl.mainwin:=w
	w.userdata:=cl
	w.extdata:=WIN_PROCESS
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],0)
	FOR i:=0 TO 8 DO IF g[i]<>0 THEN delgadget(w,g[i])
	IF w<>NIL
		ClearMenuStrip(w)
		Close(w)
	ENDIF
	w:=NIL
ENDPROC w


PROC closeClassWindow(cl:PTR TO class)
	DEF g[8]:ARRAY OF LONG,i,w:PTR TO window

	w:=cl.mainwin
	IF w<>NIL					/* Window überhaupt offen ? */
		g:=cl.gadgets
		FOR i:=0 TO 6 DO delgadget(w,g[i])
		IF cl.done<cl.height
			delgadget(w,g[7])
			delgadget(w,g[8])
		ENDIF
		ClearMenuStrip(w)
		RtCloseWindowSafely(w)	
		cl.mainwin:=NIL
	ENDIF
ENDPROC


PROC newclass(list:PTR TO mlh) HANDLE
	RAISE	E_MEM IF New()=NIL

	DEF cl:PTR TO class,w:PTR TO window,title=NIL,scl:PTR TO class,
		id=0,found,i=1,t[20]:STRING

	title:=New(15)
	cl:=New(SIZEOF class)
	scl:=list.head							/* find next ID-number */
	WHILE (scl.succ<>NIL) AND (id<>i)
		found:=FALSE	
		WHILE scl.succ<>NIL
			IF scl.nr=i THEN found:=TRUE
			scl:=scl.succ
		ENDWHILE
		IF found=FALSE
			id:=i
		ELSE
			INC i
			scl:=list.head
		ENDIF
	ENDWHILE
	id:=i
	StringF(t,'Prozeß #\d',id)
	CopyMem(TrimStr(t),title,EstrLen(t))
	IF (w:=openClassWindow(cl,title,scr)=NIL) THEN Raise(E_NONE)
	cl.filename:=New(50)
	cl.path:=New(400)
	cl.pattern:=New(30);CopyMem('#?.FRAK',cl.pattern,STRLEN)
	cl.name:=title
	cl.viewlist:=emptyminlist()
	IF cl.viewlist=NIL THEN Raise(E_NONE)
	cl.nr:=id
	Enqueue(list,cl)
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],0)
	IF cl<>NIL
		IF w<>NIL THEN closeClassWindow(cl)
		IF cl.filename<>NIL THEN Dispose(cl.filename)
		IF cl.path<>NIL THEN Dispose(cl.path)
		IF cl.pattern<>NIL THEN Dispose(cl.pattern)
		IF cl.viewlist<>NIL THEN Dispose(cl.viewlist)
		IF title<>NIL THEN Dispose(title)
		Dispose(cl)
	ENDIF
	cl:=NIL
ENDPROC cl


PROC cleardesk(list: PTR TO mlh)
	DEF cl:PTR TO class,e,m

	cl:=list.head;e:=DO_NONE
	WHILE (cl.succ<>NIL) AND (e=DO_NONE)
		e:=deleteclass(cl)
		cl:=cl.succ
	ENDWHILE
	WHILE (m:=GetMsg(portIDCMP)) DO ReplyMsg(m)
ENDPROC e


PROC clearviews(cl:PTR TO class)
	DEF vlist:PTR TO mlh,view:PTR TO subclass,e

	vlist:=cl.viewlist
	view:=vlist.head
	e:=DO_NONE
	WHILE (view.succ<>NIL) AND (e=DO_NONE)
		e:=deleteview(view)
		view:=view.succ
	ENDWHILE
ENDPROC e


PROC deleteclass(cl: PTR TO class)
	DEF e

	IF (cl.flstarted=1) AND (cl.flsaved=FALSE)
		IF (e:=request(msglist[M_SAVE],declist[D_SAVE],[cl.name]))=0 THEN RETURN DO_ABBRUCH
		IF e=1
			 IF saveclass(cl,FALSE)=DO_ABBRUCH THEN RETURN DO_ABBRUCH 
		ENDIF
	ENDIF
	IF clearviews(cl)=DO_ABBRUCH THEN RETURN DO_ABBRUCH
	Dispose(cl.viewlist)
	IF cl.data<>NIL THEN FreeMem(cl.data,clsize(cl))
	closeClassWindow(cl)
	Dispose(cl.name)
	Dispose(cl.filename)
	Dispose(cl.path)
	Dispose(cl.pattern)
	Remove(cl)
	Dispose(cl)
ENDPROC DO_NONE


PROC createGadget(cw:PTR TO window,name,typ,flag,slen,left,top,wid,hei,id) HANDLE
	RAISE E_GAD IF New()=NIL

	DEF g:PTR TO gadget,pinfo:PTR TO propinfo,sinfo:PTR TO stringinfo,
		t:PTR TO intuitext,buf=NIL

	g:=NIL;pinfo:=NIL;sinfo:=NIL;t:=NIL

	g:=New(SIZEOF gadget)
	t:=New(SIZEOF intuitext)

	SELECT typ
	CASE GTYP_STRGADGET
		buf:=New(slen+1)
		sinfo:=New(SIZEOF stringinfo)

		sinfo.buffer:=buf
		sinfo.undobuffer:=ubuf
		sinfo.maxchars:=slen
		g.gadgetrender:=NIL
		g.activation:=flag
		g.specialinfo:=sinfo
		t.leftedge:=-6
		t.topedge:=-13

	CASE GTYP_PROPGADGET
		pinfo:=New(SIZEOF propinfo)
		buf:=New(8)

		pinfo.flags:=flag
		pinfo.horizbody:=IF flag AND FREEHORIZ THEN $FFFF/slen ELSE 0
		g.gadgetrender:=buf
		g.activation:=PROPACT
		g.specialinfo:=pinfo
		t.leftedge:=-4
		t.topedge:=-13

	CASE GTYP_BOOLGADGET
		g.gadgetrender:=NIL
		g.activation:=GACT_RELVERIFY
		g.specialinfo:=NIL
		t.leftedge:=wid/2-(StrLen(name)*4)
		t.topedge:=hei/2-4
	ENDSELECT

	t.frontpen:=1
	t.itextfont:=tattr
	t.itext:=name

	g.flags:=GFLG_GADGHCOMP
	g.gadgettype:=typ
	g.gadgettext:=t
	g.gadgetid:=id
	g.topedge:=top
	g.leftedge:=left
	g.width:=wid
	g.height:=hei

	SELECT typ
	CASE GTYP_STRGADGET
		bevelbox(cw.rport,left-6,top-3,wid+12,hei+6,TRUE)
		bevelbox(cw.rport,left-4,top-2,wid+8,hei+4,FALSE)
	CASE GTYP_PROPGADGET
		bevelbox(cw.rport,left-4,top-2,wid+8,hei+4,TRUE)
		bevelbox(cw.rport,left+wid-32,top-15,36,12,FALSE)
	CASE GTYP_BOOLGADGET
		SetAPen(cw.rport,0)
		RectFill(cw.rport,left,top,left+wid-1,top+hei-1)
		bevelbox(cw.rport,left,top,wid,hei,TRUE)
	ENDSELECT
	AddGadget(cw,g,id)
	RefreshGadgets(g,cw,NIL)
EXCEPT
	request(erlist[exception],declist[D_OK],0)
	IF g<>NIL THEN Dispose(g)
	IF sinfo<>NIL THEN Dispose(sinfo)
	IF pinfo<>NIL THEN Dispose(pinfo)
	IF t<>NIL THEN Dispose(t)
	IF buf<>NIL THEN Dispose(buf)
	g:=NIL
ENDPROC g

PROC delgadget(w:PTR TO window,g:PTR TO gadget)
	DEF s:PTR TO stringinfo,typ

	IF g<>NIL
		typ:=g.gadgettype
		SELECT typ
		CASE GTYP_STRGADGET
			s:=g.specialinfo
			Dispose(s.buffer)
			Dispose(s)
		CASE GTYP_PROPGADGET
			Dispose(g.specialinfo)
			Dispose(g.gadgetrender)
		ENDSELECT
		Dispose(g.gadgettext)
		RemoveGadget(w,g)
		Dispose(g)
	ENDIF
ENDPROC

PROC doubbevel(rp,x,y,w,h,mode)
	SetAPen(rp,0)
	RectFill(rp,x,y,x+w-1,y+h-1)
	bevelbox(rp,x,y,w,h,mode)
	bevelbox(rp,x+2,y+1,w-4,h-2,Not(mode))
ENDPROC

PROC bevelbox(rp,x,y,w,h,pos)
	DEF tl,br
	IF pos=TRUE
		tl:=2;br:=1
	ELSE
		tl:=1;br:=2
	ENDIF
	SetAPen(rp,tl);Move(rp,x,y)
	PolyDraw(rp,4,[x,y+h-1,x+1,y+h-2,x+1,y,x+w-2,y]:INT)
	SetAPen(rp,br);Move(rp,x+w-1,y+h-1)
	PolyDraw(rp,4,[x+w-1,y,x+w-2,y+1,x+w-2,y+h-1,x+1,y+h-1]:INT)
ENDPROC

PROC mandel(class:PTR TO class)
	DEF videox,videoy,deltax,deltay,x,y,tiefe,dat:PTR TO INT,
		mix,max,miy,may,tiefmax,wi:PTR TO window,
		msg:PTR TO intuimessage,ende,g:PTR TO gadget,
		xx,yy,xkomplex,ykomplex,xwert,ywert
	
	ende:=FALSE
	wi:=class.mainwin

	videox:=class.width
	videoy:=class.height

	dat:=class.data		/* ARRAY für Daten */
	mix:=class.xmin
	max:=class.xmax
	miy:=class.ymin
	may:=class.ymax
	tiefmax:=class.it

	deltax:=SpDiv(SpFlt(videox),SpSub(mix,max))
	deltay:=SpDiv(SpFlt(videoy),SpSub(miy,may))

	xkomplex:=mix
	ykomplex:=class.ydone

	dat:=Mul(Mul(class.done,class.width),2)+dat
		
	y:=class.done
	REPEAT
		x:=0
		REPEAT
			tiefe:=0
			xwert:=0;ywert:=0;xx:=0;yy:=0
			WHILE (tiefe<tiefmax) AND (SpCmp(SpAdd(xx,yy),ACHT)=-1)
				ywert:=SpSub(ykomplex,SpMul(SpMul(ZWEI,xwert),ywert))
				xwert:=SpSub(xkomplex,SpSub(yy,xx))
				xx:=SpMul(xwert,xwert)
				yy:=SpMul(ywert,ywert)
				INC tiefe
			ENDWHILE

			PutInt(dat++,tiefe)

			xkomplex:=SpAdd(xkomplex,deltax)
			INC x
		UNTIL (x>=videox)

		IF (msg:=GetMsg(portIDCMP))<>NIL
			IF msg.class=IDCMP_GADGETUP
				g:=msg.iaddress
				IF g.gadgetid=ID_STOP
					ende:=TRUE
					DisplayBeep(scr)
				ENDIF
			ENDIF
			ReplyMsg(msg)
		ENDIF

		xkomplex:=mix;ykomplex:=SpSub(deltay,ykomplex)
		INC y
		dispstate(class,y)
	UNTIL (y>=videoy) OR (ende=TRUE)
	class.done:=y
	class.ydone:=ykomplex
	IF ende=TRUE THEN class.flinterrupted:=TRUE
ENDPROC

PROC emptyminlist() HANDLE
	DEF lmem
	RAISE E_MEM IF New()=NIL

	lmem:=New(SIZEOF mlh)
	MOVE.L	lmem,A0
	MOVE.L	A0,(A0)
	CLR.L	4(A0)
	MOVE.L	A0,8(A0)
	ADD.L	#4,(A0)
EXCEPT
	request(erlist[exception],declist[D_OK],0)
ENDPROC lmem

PROC ownrequest(ownwindow)
	DEF save,process

	process:=FindTask(NIL)
	MOVE.L	process,A0
	MOVE.L	184(A0),save
	MOVE.L	ownwindow,184(A0)
ENDPROC save

PROC disownrequest(save)
	DEF process

	process:=FindTask(NIL)
	MOVE.L	process,A0
	MOVE.L	save,184(A0)
ENDPROC

PROC closeall()
	IF cyclewindow<>NIL THEN closeCycWindow()

	Dispose(clist)

	disownrequest(oldreqwin)
	IF win<>NIL
		ClearMenuStrip(win)
		RtCloseWindowSafely(win)
	ENDIF
	deleteport(portIDCMP)
	FreeMem(maus,PTRSIZE)
	FreeMem(strich,STRICHSIZE)
	FreeMem(pfeildata,PFEILSIZE)
	IF scr<>NIL THEN CloseS(scr)
	CloseLibrary(mathtransbase)
	CloseLibrary(reqtoolsbase)
ENDPROC DO_NONE

PROC openall() HANDLE
	DEF succ,i,proc,launch

	versionstring:='$VER: Fraktalik Version 2.03 by Marcel Bennicke (Apr-Sep 1994)'
	
	erlist:=['Alles OK',
			'Screen konnte nicht geöffnet werden!',
			'Konnte Fenster nicht öffnen!',
			'Speicherplatzmangel!',
			'Benötige "mathtrans.library"\nim Verzeichnis "libs:" !',
			'Ansicht konnte nicht\ngeöffnet werden!',
			'Zu wenig Speicher für Schalter!',
			'Zu wenig Speicher für\nein Bild dieser Größe!',
			'Zu wenig Speicher für\nDarstellung der Menge!',
			'Fehler beim Schreiben!\nLösche Datei wieder.',
			'Fehler beim Lesen!',
			'Die Datei "%s"\nenthält keine\nberechnete Fraktalik-Menge!',
			'Es sind noch keine Daten\nin "%s" berechnet!',
			'Dialogfenster konnte nicht\ngeöffnet werden!',
			'Interne Kommunikation konnte\nnicht aufgebaut werden!',
			'Timer.device konnte\nnicht geöffnet werden!',
			'Datei "%s"\nkonnte nicht geöffnet werden!',
			'Kein IFF-Dateiformat.\nPalette nicht enthalten!',
			'Dateiende erreicht. Erforderliche\nDaten nicht enthalten!',
			'Printer.device konnte\nnicht geöffnet werden!',
			'"%s"\nwird gerade gedruckt.\nSchließen nicht möglich!',
			'Device zum Auslesen\ndes Druckerstatus konnte\nnicht geöffnet werden!',
			'Während des Drucks\nFarbrollen nicht möglich!']

	declist:=['_OK','_Sichern|S_chließen|_Abbruch','_Ja|_Nein',
			  '_Farbe|3_D|_Keine','_Nochmal versuchen|_Abbruch',
			  '_OK|_Abbruch']

	msglist:=['Berechnung ist abgeschlossen.\nWelche Ansicht soll\ngeöffnet werden?',
			  'Berechnung wurde unterbrochen.\nWelche Ansicht soll\ngeöffnet werden?',
			  'Die Daten in "%s"\nsind noch nicht gespeichert.\nWas soll ich machen?',
			  'Die Datei\n"%s"\n existiert bereits!\nÜberschreiben?',
			  'Menge erflogreich gesichert als\n"%s".',
			  'Ansicht als IFF-Datei\n"%s"\ngesichert.',
			  'Wirklich alle\nAnsichten löschen?',
			  'Die Parameter wurden verändert.\nNeustart löscht alle\ngeöffneten Ansichten. Weiter?',
			  'Palette als IFF-Datei\n"%s"\ngesichert.',
			  'Die Palette "%s"\nenthält zu viele Farben.\nNur die ersten %ld laden?',
			  'Wechsel des Bildschirmmodus\nlöscht alle geöffneten\nAnsichten! Weiter?',
			  'Bildschirmmoduswechsel\nnicht möglich.',
			  'Workbench konnte nicht ge-\nschlossen werden. Evtl.\nauf der Workbench lau-\nfende Programme beenden!',
			  'Workbench konnte wegen\nSpeicherplatzmangel nicht\ngeöffnet werden.',
			  'Dieses Programm wurde schon\ngestartet und arbeitet zur Zeit\nim Hintergrund.\n\nMöchten Sie es noch einmal starten?',
			  'Soll das Programm wirklich\nbeendet werden?',
			  'Für den Druck muß das Farb-\nrollen abgestellt werden.']
	
	printmsg:=['Ausdruck von\n"%s"\nbeendet.',
				'Druckvorgang wurde abgebrochen!',
				'Der angeschlossene Drucker\nunterstützt keine Grafik!',
				'Invertierter HAM-Druck\nnicht möglich!',
				'Fehlerhafte Druckgröße!',
				'Zu große Druckgröße!',
				'Nicht genug Speicher für\ninterne Variablen!',
				'Nicht genug Speicher für\nDruckbuffer!',
				'Unbekannter Fehler beim Druck!']

	ioerr:=['Vorgang konnte nicht\ngestartet werden!',
			'Vorgang wurde abgebrochen!',
			'Gewünschtes Kommando\nexistiert nicht!',
			'Falsche Länge!',
			'Unbekannter Fehler!']

	prtstate:='Druckerstatus: (%s)\n'+
			  '~~~~~~~~~~~~~~\n'+
			  'Bereit: %s\n'+
			  'Papier: %s\n'+
			  'Status: %s\n\n'+
			  'Bitte beseitigen Sie alle Fehler!'

	lockstate:=FALSE			/* Windows gelockt ? */
	cyclewindow:=NIL			/* gleichzeitig Flag, ob Cycling läuft */

	identify:='FRAKTALIK2.00'
	
	tattr:=['topaz.font',8,0,0]:textattr

	depth:=5

	proc:=FindTask(0)
	MOVE.L	proc,A0
	MOVE.L	184(A0),oldreqwin

	IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(E_RT)
	IF (mathtransbase:=OpenLibrary('mathtrans.library',0))=NIL THEN Raise(E_MTRANS)

	IF FindPort('Fraktalik:Shared IDCMP.port')<>NIL
		launch:=request(msglist[M_RUNNING],declist[D_JANEIN],0)
		IF launch=0 THEN Raise(E_NONE)		
	ENDIF

	IF (portIDCMP:=getport('Fraktalik:Shared IDCMP.port'))=NIL THEN Raise(E_NONE)
	idcmpmask:=Shl(1,portIDCMP.sigbit)

	IF (clist:=emptyminlist())=NIL THEN Raise(E_NONE)

	/* alle Images ins CHIP-RAM kopieren */

	maus:=AllocMem(PTRSIZE,$10002)
	busy[0]:=0
	busy[1]:=%0000000100000000
	busy[2]:=%0000001110000000
	busy[3]:=%0000011111000000
	busy[4]:=%0000000100000000
	busy[5]:=%0000000100000000
	busy[6]:=%0010000100001000
	busy[7]:=%0110000100001100
	busy[8]:=%1111111111111110
	busy[9]:=%0110000100001100
	busy[10]:=%0010000100001000
	busy[11]:=%0000000100000000
	busy[12]:=%0000000100000000
	busy[13]:=%0000011111000000
	busy[14]:=%0000001110000000
	busy[15]:=%0000000100000000

	FOR i:=0 TO 15 DO PutInt(maus+Shl(i,2),busy[i])

	strich:=AllocMem(STRICHSIZE,$10002)
	FOR i:=0 TO STRICHSIZE-1 DO PutChar(strich+i,$FF)

	pfeildata:=AllocMem(PFEILSIZE,$10002)
	CopyMem([%1111111111110111,		/* Plane 0 */
			 %1111111111110011,
			 %1111111111110001,
			 %1111111111110000,
			 %1111111111110001,
			 %1111111111110011,
			 %1111111111110111,

			 %0000000000001000,		/* Plane 1 */
			 %0000000000001100,
			 %0000000000001110,
			 %0000000000001111,
			 %0000000000001110,
			 %0000000000001100,
			 %0000000000001000]:INT,pfeildata,PFEILSIZE)

	IF opendesktop(320,256,5,0)=DO_ABBRUCH THEN Raise(E_NONE)
	ScreenToFront(scr)
	succ:=TRUE
EXCEPT
	succ:=FALSE
	SELECT exception
	CASE E_RT
		IF clistart
			WriteF('\nBenötige "reqtools.library" V38+ im Verzeichnis "libs:" !\n\n')
		ELSE
			AutoRequest(oldreqwin,
				[0,1,0,10,10,tattr,'Benötige "reqtools.library" V38+',
				[0,1,0,10,20,tattr,'im Verzeichnis "libs:" !',NIL]:intuitext]:intuitext,
				[2,1,0,6,3,tattr,'OK',NIL]:intuitext,
				[2,1,0,6,3,tattr,'OK',NIL]:intuitext,
				0,0,320,70)
		ENDIF
	CASE E_NONE

	DEFAULT
		request(erlist[exception],declist[D_OK],0)
	ENDSELECT

	IF maus<>NIL THEN FreeMem(maus,PTRSIZE)
	IF strich<>NIL THEN FreeMem(strich,STRICHSIZE)
	IF pfeildata<>NIL THEN FreeMem(pfeildata,PFEILSIZE)
	IF clist<>NIL THEN Dispose(clist)
	IF portIDCMP<>NIL THEN deleteport(portIDCMP)
	IF reqtoolsbase<>NIL THEN CloseLibrary(reqtoolsbase)
	IF mathtransbase<>NIL THEN CloseLibrary(mathtransbase)
ENDPROC succ


PROC opendesktop(b,h,t,m) HANDLE
	RAISE	E_SCR IF OpenS()=NIL,
			E_WIN IF OpenW()=NIL
			
	DEF s:PTR TO screen,w:PTR TO window,e=DO_NONE,
		breit,hoch,tw:PTR TO window,msg:PTR TO intuimessage,
		m2

	s:=NIL
	w:=NIL

	disownrequest(oldreqwin)
	IF KickVersion(37)
		m2:=0
		IF (m AND V_HIRES)<>0 THEN m2:=m2 OR HIRES_KEY
		IF (m AND V_LACE)<>0 THEN m2:=m2 OR 4

		s:=OpenScreenTagList(NIL,
			[SA_PENS,[0,0,1,2,1,3,1,-1]:INT,
			SA_WIDTH,b,
			SA_HEIGHT,h,
			SA_DEPTH,t,
			SA_TYPE,CUSTOMSCREEN,
			SA_DISPLAYID,(PAL_MONITOR_ID OR m2),
			SA_TITLE,'Fraktalik V2.03',
			TAG_DONE]) 
       IF s=NIL THEN Raise(E_SCR)
	ELSE

		s:=OpenScreen([0,0,b,h,t,0,1,m,CUSTOMSCREEN OR SCREENBEHIND,
			tattr,'Fraktalik V2.03',NIL,NIL]:ns)
	ENDIF
	w:=OpenW(0,11,s.width,s.height-11,0,WFLAGS,NIL,s,$F,NIL)
	w.userport:=portIDCMP
	ModifyIDCMP(w,IDCMP)
	VOID ownrequest(w)
	w.extdata:=WIN_BACKDROP
	initmenus()
	SetMenuStrip(w,xmenu)

	tw:=OpenW(0,11,100,50,IDCMP_MENUPICK,VFLG,NIL,s,$F,NIL)
	vertrand:=tw.bordertop+tw.borderbottom
	horizrand:=tw.borderleft+tw.borderright
	WHILE (msg:=GetMsg(tw.userport))<>NIL DO ReplyMsg(msg)
	CloseW(tw)

	breit:=w.width*2/3
	hoch:=w.height/5
	stdrast:=w.rport

	doubbevel(stdrast,(w.width-breit)/2,(w.height-hoch)/2,breit,hoch,FALSE)
	setAfPt(stdrast,[$AAAA,$5555]:INT,1)
	Colour(1,3)
	RectFill(stdrast,(w.width-breit)/2+4,(w.height-hoch)/2+2,(w.width-breit)/2+breit-5,(w.height-hoch)/2+hoch-3)
	setAfPt(stdrast,[$FFFF]:INT,0)
	Colour(2,0)
	SetDrMd(stdrast,0)
	TextF(w.width/2-60,w.height/2+3,'Fraktalik V2.03')

	depth:=t
	scr:=s
	win:=w
	setcolors(scr)
	winlock:=0
EXCEPT
	scr:=NIL
	win:=NIL
	winlock:=0
	IF w<>NIL
		disownrequest(oldreqwin)
		ClearMenuStrip(w)
		RtCloseWindowSafely(w)
	ENDIF
	IF s<>NIL THEN CloseS(s)
	request(erlist[exception],declist[D_OK],0)
	e:=DO_ABBRUCH
ENDPROC e


PROC setcolors(s:PTR TO screen)
	DEF vp,i,col

	col:=Shl(1,depth)
	vp:=s.viewport
	SetRGB4(vp,0,10,10,10)
	SetRGB4(vp,1,0,0,0)
	SetRGB4(vp,2,15,15,15)
	SetRGB4(vp,3,6,8,11)
	SELECT col
		CASE 8
			FOR i:=0 TO 3 DO SetRGB4(vp,i+4,Shl(i,2)+3,0,Shl(i,2)+3)
		CASE 16
			FOR i:=0 TO 11 DO SetRGB4(vp,i+4,i+4,0,i+4)
		CASE 32
			FOR i:=0 TO 11 DO SetRGB4(vp,i+4,i+2,0,i+2)
			FOR i:=0 TO 15 DO SetRGB4(vp,i+16,15-i,i,15-i)
	ENDSELECT
	initColorArray()
ENDPROC


/* txt: ARRAY OF intuitext */
PROC newtext(n,next,str,left,top,f,b)
	txt[n].frontpen:=f
	txt[n].backpen:=b
	txt[n].drawmode:=0
	txt[n].leftedge:=left
	txt[n].topedge:=top
	txt[n].itextfont:=tattr
	txt[n].itext:=str
	txt[n].nexttext:=IF next=0 THEN NIL ELSE (SIZEOF intuitext)*next+txt
ENDPROC


PROC initmenus()
	DEF i:PTR TO image

	newimage(0,1,0,32,170,1,MENUPEN,strich)
	newimage(1,2,0,57,170,1,MENUPEN,strich)
	newimage(2,0,0,72,170,1,MENUPEN,strich)
	newitem(0,1,0,0,170,10,STDFL OR COMMSEQ,0,'Öffnen...',"O",NIL)
	newitem(1,2,0,10,170,10,STDFL OR COMMSEQ,0,'Speichern',"X",NIL)
	newitem(2,3,0,20,170,10,STDFL OR COMMSEQ,0,'Speichern als...',"S",NIL)
	newitem(3,4,0,35,170,10,STDFL OR COMMSEQ,0,'Neue Menge...',"N",NIL)
	newitem(4,5,0,45,170,10,STDFL,0,'Alle löschen',0,NIL)
	newitem(5,6,0,60,170,10,STDFL OR COMMSEQ,0,'über...',"I",NIL)
	newitem(6,7,0,75,170,10,STDFL OR COMMSEQ,0,'Beenden',"E",NIL)
	newitem(7,0,0,0,170,1,ITEMENABLED OR HIGHNONE,0,0,NIL,NIL) 	/* Striche */

	newimage(3,4,0,12,170,1,MENUPEN,strich)
	newimage(4,5,0,37,170,1,MENUPEN,strich)
	i:=newimage(5,0,0,62,170,1,MENUPEN,strich)
	pfeil1.leftedge:=154
	pfeil1.topedge:=65
	pfeil1.width:=16
	pfeil1.height:=7
	pfeil1.depth:=2
	pfeil1.imagedata:=pfeildata
	pfeil1.planepick:=3
	pfeil1.planeonoff:=0
	pfeil1.nextimage:=NIL
	i.nextimage:=pfeil1

	newitem(10,11,0,0,170,10,STDFL OR COMMSEQ,0,'Alle löschen',"V",NIL)
	newitem(11,12,0,15,170,10,STDFL OR COMMSEQ,0,'Vergrößern',"+",NIL)
	newitem(12,13,0,25,170,10,STDFL OR COMMSEQ,0,'Verkleinern',"-",NIL)
	newitem(13,14,0,40,170,10,STDFL OR COMMSEQ,0,'IFF Speichern...',"F",NIL)
	newitem(14,15,0,50,170,10,STDFL OR COMMSEQ,0,'Drucken...',"D",NIL)
	newitem(15,16,0,65,170,10,STDFL,0,'Neue Ansicht',0,17)
		newitem(17,18,80,0,150,10,STDFL OR COMMSEQ,0,'1:Farbbereich',"1",NIL)
		newitem(18,0,80,10,150,10,STDFL OR COMMSEQ,0,'2:3D-Ansicht',"2",NIL)
	newitem(16,0,0,0,160,1,ITEMENABLED OR HIGHNONE,0,3,NIL,NIL) 	/* Striche */

	newimage(6,0,0,2,142,1,MENUPEN,strich)

	i:=newimage(7,0,0,22,150,1,MENUPEN,strich)
	pfeil2.leftedge:=134
	pfeil2.topedge:=0
	pfeil2.width:=16
	pfeil2.height:=7
	pfeil2.depth:=2
	pfeil2.imagedata:=pfeildata
	pfeil2.planepick:=3
	pfeil2.planeonoff:=0
	pfeil2.nextimage:=NIL
	i.nextimage:=pfeil2

	newitem(19,20,0,0,150,10,STDFL,0,'Palette',0,21)
		newitem(21,22,25,0,142,10,STDFL OR COMMSEQ,0,'Einstellen...',"P",NIL)
		newitem(22,23,25,10,142,10,STDFL OR COMMSEQ,0,'Farbrollen...',"R",NIL)
		newitem(23,24,25,20,142,10,STDFL OR COMMSEQ,0,'Standard',"T",NIL)
		newitem(24,25,25,35,142,10,STDFL OR COMMSEQ,0,'Laden...',"L",NIL)
		newitem(25,26,25,45,142,10,STDFL OR COMMSEQ,0,'Speichern...',"K",NIL)
		newitem(26,0,25,30,142,5,ITEMENABLED OR HIGHNONE,0,6,NIL,NIL)

	newitem(20,27,0,10,150,10,STDFL OR COMMSEQ,0,'Auflösung...',"A",NIL)
	wbitem:=newitem(27,28,0,25,150,10,STDFL OR CHECKIT OR CHECKED OR COMMSEQ,0,' Workbench?',"W",NIL)
	iffitem:=newitem(28,29,0,35,150,10,STDFL OR CHECKIT OR CHECKED OR COMMSEQ,0,' IFF packen?',"B",NIL)
	newitem(29,0,0,0,150,1,ITEMENABLED OR HIGHNONE,0,7,NIL,NIL)

	newmenu(0,1,'Projekt ',0)
	newmenu(1,2,' Ansicht ',10)
	newmenu(2,0,' Spezial',19)
ENDPROC

PROC newmenu(n,next,name,first)
	xmenu[n].nextmenu:=IF next=0 THEN NIL ELSE (SIZEOF menu)*next+xmenu
	xmenu[n].leftedge:=IF n=0 THEN 4 ELSE xmenu[n-1].leftedge+xmenu[n-1].width
	xmenu[n].topedge:=0
	xmenu[n].width:=StrLen(name)*8
	xmenu[n].height:=10
	xmenu[n].flags:=MENUENABLED
	xmenu[n].menuname:=name
	xmenu[n].firstitem:=(SIZEOF menuitem)*first+item
	xmenu[n].jazzx:=0
	xmenu[n].jazzy:=0
	xmenu[n].beatx:=0
	xmenu[n].beaty:=0
ENDPROC

/* item[n]:ARRAY OF menuitem */
PROC newitem(n,next,left,top,w,h,fl,mut,fill,com,sub)
	IF fl AND ITEMTEXT
		newtext(n,0,fill,IF fl AND CHECKIT THEN 16 ELSE 0,1,MENUPEN,1)
		fill:=(SIZEOF intuitext)*n+txt
	ELSE
		fill:=(SIZEOF image)*fill+im
	ENDIF
	item[n].nextitem:=IF next=0 THEN NIL ELSE (SIZEOF menuitem)*next+item
	item[n].leftedge:=left
	item[n].topedge:=top
	item[n].width:=w
	item[n].height:=h
	item[n].flags:=fl
	item[n].mutualexclude:=mut
	item[n].itemfill:=fill
	item[n].selectfill:=NIL
	item[n].command:=com
	item[n].subitem:=IF sub=0 THEN NIL ELSE (SIZEOF menuitem)*sub+item
	item[n].nextselect:=0
ENDPROC (SIZEOF menuitem)*n+item		/* --> ^Item-Struktur */

PROC newimage(n,next,x,y,w,h,c,data)
	im[n].leftedge:=x
	im[n].topedge:=y
	im[n].width:=w
	im[n].height:=h
	im[n].depth:=2
	im[n].imagedata:=data
	im[n].planepick:=c
	im[n].planeonoff:=c
	im[n].nextimage:=IF next=0 THEN NIL ELSE (SIZEOF image)*next+im
ENDPROC (SIZEOF image)*n+im


PROC selectsize(x,y) HANDLE
	RAISE	E_WIN IF OpenW()=NIL

	DEF xs,ys,succes=DO_NONE,w:PTR TO window,g[3]:ARRAY OF LONG,i,
		ende,ga:PTR TO gadget,id,st[5]:STRING,
		class,iaddr,msg:PTR TO intuimessage

	w:=OpenW(scr.width/2-60,scr.height/2-65,120,131,
			0,
			WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR WFLG_ACTIVATE,
			'Druck',scr,$F,NIL)
	w.userport:=portIDCMP
	ModifyIDCMP(w,IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP)

	SetAPen(stdrast,2)
	setAfPt(stdrast,[$AAAA,$5555]:INT,1)	
	RectFill(stdrast,w.borderleft,w.bordertop,w.width-w.borderright-1,w.height-w.borderbottom-1)
	setAfPt(stdrast,[$FFFF]:INT,0)

	doubbevel(stdrast,6,w.bordertop+2,108,94,FALSE)

	g[0]:=createGadget(w,'Breite [cm]',GTYP_STRGADGET,STRACT OR GACT_STRINGRIGHT,9,23,w.bordertop+20,74,8,1001)
	IF g[0]=NIL THEN Raise(E_NONE)

	g[1]:=createGadget(w,'Höhe   [cm]',GTYP_STRGADGET,STRACT OR GACT_STRINGRIGHT,9,23,w.bordertop+50,74,8,1002)
	IF g[1]=NIL THEN Raise(E_NONE)

	g[2]:=createGadget(w,' Gerät Nr.',GTYP_STRGADGET,STRACT OR GACT_LONGINT OR GACT_STRINGCENTER,4,23,w.bordertop+80,74,8,1003)
	IF g[2]=NIL THEN Raise(E_NONE)

	g[3]:=createGadget(w,'OK',GTYP_BOOLGADGET,0,0,w.width/2-30,w.bordertop+100,60,14,1004)
	IF g[3]=NIL THEN Raise(E_NONE)

	setvalue(w,g[0],ffptostr(xsize,2))
	setvalue(w,g[1],ffptostr(ysize,2))
	setvalue(w,g[2],StringF(st,'\d',unit) BUT st)

	REPEAT
		ende:=FALSE

		IF SpFix(xs)<=0					/* fehlerhaftes Gadget aktivieren */
			ActivateGadget(g[0],w,NIL)
		ELSEIF SpFix(ys)<=0
			ActivateGadget(g[1],w,NIL)
		ELSEIF unit<0
			ActivateGadget(g[2],w,NIL)
		ENDIF

		REPEAT
			IF (msg:=GetMsg(portIDCMP))=NIL
				WaitPort(portIDCMP)
				msg:=GetMsg(portIDCMP)
			ENDIF
			class:=msg.class
			iaddr:=msg.iaddress
			ReplyMsg(msg)
			SELECT class
				CASE IDCMP_CLOSEWINDOW
					succes:=DO_ABBRUCH
					ende:=TRUE
				CASE IDCMP_GADGETUP
					ga:=iaddr
					id:=ga.gadgetid
					SELECT id
						CASE 1004
							ende:=TRUE
						CASE 1001
							ActivateGadget(g[1],w,NIL)
						CASE 1002
							ActivateGadget(g[2],w,NIL)
						CASE 1003
							ActivateGadget(g[0],w,NIL)
					ENDSELECT
			ENDSELECT
		UNTIL ende

		xsize:=strtoffp(getstring(g[0]))
		ysize:=strtoffp(getstring(g[1]))
		unit:=Val(getstring(g[2]),NIL)

		xs:=SpDiv(INCH,SpMul(xsize,TAUSEND))
		ys:=SpDiv(INCH,SpMul(ysize,TAUSEND))
	UNTIL ((SpFix(xs)>0) AND (SpFix(ys)>0) AND (unit>=0)) OR (succes<>DO_NONE)

	FOR i:=0 TO 3 DO delgadget(w,g[i])
	RtCloseWindowSafely(w)

	IF succes=DO_ABBRUCH THEN RETURN(DO_ABBRUCH)

	^x:=xs;^y:=ys
EXCEPT
	succes:=DO_ABBRUCH
	request(erlist[exception],declist[D_OK],0)
	IF w<>NIL
		FOR i:=0 TO 3 DO IF g[i]<>NIL THEN delgadget(w,g[i])
		RtCloseWindowSafely(w)
	ENDIF
ENDPROC succes


PROC checkprinter(req:PTR TO iodrpreq,printertype) HANDLE
	RAISE E_CHECKPRINTER IF OpenDevice()<>0

	DEF io:PTR TO iostd,status,success,
		typ[10]:STRING,select[20]:STRING,paper[20]:STRING,busy[20]:STRING,
		selectbit,paperbit,busybit,
		parreq:PTR TO ioextpar,checkport:PTR TO mp,
		selreq:PTR TO ioextser

	REPEAT
		parreq:=NIL;checkport:=NIL
		selreq:=NIL
		success:=DO_NONE

		/* Beide Schnittstellen werden über das entsprechende Device
		einzeln überprüft, da Status mit printer.device nicht lesbar
		ist (Fehler des Betriebssystems ???)
		*/

		SELECT printertype
		CASE 1
			IF (checkport:=getport('parallel.port'))=NIL THEN Raise(E_NONE)
			IF (parreq:=getioblock(checkport,SIZEOF ioextpar))=NIL THEN Raise(E_NONE)
			OpenDevice('parallel.device',unit,parreq,0)
			io:=parreq.iostd

			io.command:=PDCMD_QUERY
			DoIO(parreq)
			status:=parreq.parstatus AND %111
			CloseDevice(parreq)
			deleteioblock(parreq)
			deleteport(checkport)

			typ:='parallel'
			selectbit:=1
			paperbit:=2
			busybit:=4
		CASE 2
			IF (checkport:=getport('serial.port'))=NIL THEN Raise(E_NONE)
			IF (selreq:=getioblock(checkport,SIZEOF ioextser))=NIL THEN Raise(E_NONE)
			OpenDevice('serial.device',unit,selreq,0)
			io:=selreq.iostd

			io.command:=SDCMD_QUERY
			DoIO(selreq)
			status:=selreq.status AND %111

			CloseDevice(selreq)
			deleteioblock(selreq)
			deleteport(checkport)

			typ:='seriell'
			selectbit:=4
			paperbit:=2
			busybit:=1
		ENDSELECT		

		IF And(status,selectbit)<>0
			select:='OFFLINE oder Power-OFF'
			success:=DO_AGAIN
		ELSE
			select:='ONLINE'
		ENDIF

		IF And(status,paperbit)<>0
			paper:='nicht eingelegt'
			success:=DO_AGAIN
		ELSE
			paper:='eingelegt'
		ENDIF

		IF And(status,busybit)=0
			busy:='druckt gerade'
			success:=DO_AGAIN
		ELSE
			busy:='empfangsbereit'
		ENDIF

		IF success=DO_AGAIN
			IF RtEZRequestA(prtstate,declist[D_CHECK],NIL,
							[typ,select,paper,busy],
							[RT_UNDERSCORE,"_",
							RT_REQPOS,REQPOS_POINTER,
							RTEZ_REQTITLE,'Drucker nicht bereit',
							TAG_DONE])=0 THEN success:=DO_ABBRUCH
		ENDIF
	UNTIL success<>DO_AGAIN

EXCEPT
	IF parreq<>NIL
		io:=parreq.iostd
		IF io.device<>NIL THEN CloseDevice(parreq)
		deleteioblock(parreq)
	ENDIF
	IF selreq<>NIL
		io:=selreq.iostd
		IF io.device<>NIL THEN CloseDevice(selreq)
		deleteioblock(selreq)
	ENDIF
	IF checkport<>NIL THEN deleteport(checkport)
	OpenDevice('printer.device',unit,req,0)

	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],0)
	success:=DO_NONE
ENDPROC success


PROC printerdump(view:PTR TO subclass) HANDLE
	RAISE	E_PRINTER IF OpenDevice()<>0,
			E_MEM IF New()=NIL,
			E_WIN IF OpenW()=NIL

	DEF vp:PTR TO viewport,sw:PTR TO window,
		preq:PTR TO iodrpreq,pport:PTR TO mp,io:PTR TO io,
		ios:PTR TO iostd,cl:PTR TO class,
		prefs:PTR TO preferences,g:PTR TO gadget,br,ho

	windowlock(clist,WL_LOCK)

	IF cyclewindow<>NIL
		request(msglist[M_NOCYCLE],declist[D_OK],0)
		closeCycWindow()
	ENDIF

	cl:=view.class
	sw:=NIL;preq:=NIL;pport:=NIL;g:=NIL

	vp:=scr.viewport

	prefs:=New(SIZEOF preferences)
	GetPrefs(prefs,SIZEOF preferences)

	IF selectsize({br},{ho})=DO_ABBRUCH THEN Raise(E_NONE)

	IF (pport:=getport('Fraktalik Printer.port'))=NIL THEN Raise(E_NONE)
	printmask:=printmask OR Shl(1,pport.sigbit)

	IF (preq:=getioblock(pport,SIZEOF iodrpreq))=NIL THEN Raise(E_NONE)
	OpenDevice('printer.device',unit,preq,0)

/* Parameter prüfen ------ */
	io:=preq.io
	preq.rastport:=view.rport
	preq.colormap:=vp.colormap
	preq.modes:=getVMode()
	preq.srcx:=0
	preq.srcy:=0
	preq.srcwidth:=cl.width
	preq.srcheight:=cl.height
	preq.destcols:=SpFix(br)
	preq.destrows:=SpFix(ho)
	preq.special:=Shl(prefs.printdensity,8) OR SPECIAL_MILCOLS OR SPECIAL_MILROWS OR SPECIAL_NOPRINT
	io.command:=PRD_DUMPRPORT

	DoIO(preq)

	IF io.error<>0
		request(printmsg[IF io.error<=7 THEN io.error ELSE 8],declist[D_OK],0)
		Raise(E_NONE)
	ENDIF
	
/* Druckertyp feststellen ----- */
	ios:=preq.io
	ios.command:=PRD_QUERY
	DoIO(preq)
	CloseDevice(preq);ios.device:=NIL
	
	IF checkprinter(preq,ios.actual)=DO_ABBRUCH
		Raise(E_NONE)
	ELSE
		preq.rastport:=view.rport
		preq.colormap:=vp.colormap
		preq.modes:=getVMode()
		preq.srcx:=0
		preq.srcy:=0
		preq.srcwidth:=cl.width
		preq.srcheight:=cl.height
		preq.destcols:=SpFix(br)
		preq.destrows:=SpFix(ho)
		preq.special:=Shl(prefs.printdensity,8) OR SPECIAL_MILCOLS OR SPECIAL_MILROWS

		OpenDevice('printer.device',unit,preq,0)
		io:=preq.io
		io.command:=PRD_DUMPRPORT

		sw:=OpenW(scr.width/2-90,scr.height/2-32,180,64,
				0,WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_ACTIVATE,
				view.name,scr,$F,NIL)
		sw.userport:=portIDCMP
		ModifyIDCMP(sw,IDCMP_GADGETUP)
		sw.userdata:=view
		sw.extdata:=WIN_PRINT
		SetWindowTitles(sw,-1,view.name)

		SetAPen(stdrast,2)
		setAfPt(stdrast,[$AAAA,$5555]:INT,1)	
		RectFill(stdrast,sw.borderleft,sw.bordertop,sw.width-sw.borderright-1,sw.height-sw.borderbottom-1)
		setAfPt(stdrast,[%1111111111111111]:INT,0)

		doubbevel(stdrast,6,sw.bordertop+2,168,26,FALSE)

		SetDrMd(stdrast,0)
		Colour(1,0)
		TextF(20,sw.bordertop+17,'Druckvorgang läuft')
		Colour(2,0)
		TextF(19,sw.bordertop+16,'Druckvorgang läuft')
		g:=createGadget(sw,'Abbruch',GTYP_BOOLGADGET,0,0,sw.width/2-40,42,80,14,ID_PRINT)
		IF g=NIL THEN Raise(E_NONE)
		
		view.printwin:=sw	/* erst, wenn alles geklappt hat, zuweisen */
		view.printgad:=g
		view.req:=preq

		windowlock(clist,WL_UNLOCK)

		SendIO(preq)
	ENDIF
	Dispose(prefs);prefs:=NIL
EXCEPT
	windowlock(clist,WL_UNLOCK)
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],0)
	IF preq<>NIL
		io:=preq.io
		IF (io.device<>NIL) AND (exception<>E_PRINTER) THEN CloseDevice(preq)
		deleteioblock(preq)
	ENDIF
	IF pport<>NIL
		printmask:=printmask AND ($FFFFFFFF-Shl(1,pport.sigbit))
		deleteport(pport)
	ENDIF
	IF prefs<>NIL THEN Dispose(prefs)
	IF sw<>NIL
		IF g<>NIL THEN delgadget(sw,g)
		RtCloseWindowSafely(sw)
	ENDIF
	view.req:=0
ENDPROC

PROC viewPrintCheck(classlist:PTR TO mlh)
	DEF cl:PTR TO class,viewlist:PTR TO mlh,view:PTR TO subclass,
		preq:PTR TO iodrpreq,io:PTR TO io,tm:PTR TO mn

	cl:=classlist.head
	WHILE cl.succ<>NIL
		viewlist:=cl.viewlist
		view:=viewlist.head
		WHILE view.succ<>NIL
			preq:=view.req
			IF preq<>NIL		/* Ansicht wird gedruckt -> schon fertig ? */
				io:=preq.io
				tm:=io.mn
				IF GetMsg(tm.replyport)<>NIL THEN enddump(view)
			ENDIF
			view:=view.succ
		ENDWHILE
		cl:=cl.succ
	ENDWHILE
ENDPROC


PROC enddump(view:PTR TO subclass)
	DEF sw:PTR TO window,req:PTR TO iodrpreq,io:PTR TO io,tm:PTR TO mn,
		err,msg,endport:PTR TO mp

	sw:=view.printwin
	req:=view.req

	IF CheckIO(req)=0								/* noch in Arbeit? */
		IF AbortIO(req)<>0 THEN RETURN(DO_ABBRUCH)	/* dann abbrechen */
		WaitIO(req)
	ENDIF

	io:=req.io
	tm:=io.mn
	endport:=tm.replyport

	IF sw<>NIL
		delgadget(sw,view.printgad)
		RtCloseWindowSafely(sw)
		view.printgad:=NIL
		view.printwin:=NIL
	ENDIF

	view.req:=NIL
	IF io.error>=252
		err:=ioerr[255-io.error]
	ELSE
		err:=printmsg[IF io.error<=7 THEN io.error ELSE 8]
	ENDIF
	request(err,declist[D_OK],[view.name])

	IF io.device<>NIL THEN CloseDevice(req)
	deleteioblock(req)

	printmask:=printmask AND ($FFFFFFFF - Shl(1,endport.sigbit))
	deleteport(endport)

	WHILE (msg:=GetMsg(portIDCMP))<>NIL DO ReplyMsg(msg)
ENDPROC

/* Save & Read  ----------------- */

PROC savepalette() HANDLE
	RAISE	E_WRITE IF Write()<0,
			E_OPENREQ IF RtAllocRequestA()=NIL

	DEF cmem=NIL,handle=NIL,fr:PTR TO rtfilerequester,select,
		name[50]:STRING,path[400]:STRING,file[450]:STRING,
		size,formsize,mode,bmhd:PTR TO bitmapheader

	fr:=RtAllocRequestA(RT_FILEREQ,0)
	RtChangeReqAttrA(fr,[RTFI_DIR,palpath,TAG_DONE])
	select:=RtFileRequestA(fr,name,'IFF-Palette Speichern',
			[RT_REQPOS,REQPOS_POINTER,
			RTFI_FLAGS,FREQF_SAVE,TAG_DONE])
	StrCopy(path,fr.dir,ALL)
	RtFreeRequest(fr);fr:=NIL

	IF select=1
		StrCopy(file,path,ALL)
		StrCopy(palpath,path,ALL)
		IF EstrLen(path)-1>InStr(path,':',0) THEN StrAdd(file,'/',1)
		StrAdd(file,name,ALL)

 		IF (handle:=Open(file,MODE_OLDFILE))<>NIL
			Close(handle)
			IF request(msglist[M_OVERWRITE],declist[D_JANEIN],[name])=0 THEN RETURN DO_ABBRUCH
		ENDIF
	ELSE
		RETURN DO_ABBRUCH
	ENDIF

	IF (size:=allocCMAP(scr.viewport,{cmem}))=0 THEN Raise(E_NONE)

	bmhd:=New(20)
	bmhd.planes:=depth
	bmhd.xaspect:=1
	bmhd.yaspect:=1

	IF (handle:=Open(file,MODE_NEWFILE))=NIL THEN Raise(E_OPENFILE)
	formsize:=size+50

	Write(handle,'FORM',4)
	Write(handle,{formsize},4)
	Write(handle,'ILBMBMHD',8)
	Write(handle,[20],4)
	Write(handle,bmhd,20)
	Dispose(bmhd)

	Write(handle,'CMAP',4)
	Write(handle,{size},4)
	Write(handle,cmem,size)
	Dispose(cmem)

	mode:=getVMode()

	Write(handle,'CAMG',4)
	Write(handle,[4],4)
	Write(handle,{mode},4)
	Close(handle)
	request(msglist[M_PALWRITTEN],declist[D_OK],[name])
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],[name])
	IF handle<>NIL
		Close(handle)
		DeleteFile(file)
	ENDIF
	IF fr<>NIL THEN RtFreeRequest(fr)
	IF cmem<>NIL THEN Dispose(cmem)
	IF bmhd<>NIL THEN Dispose(bmhd)
ENDPROC DO_NONE	


PROC readpalette() HANDLE
	RAISE	E_READ IF Read()<0,
			E_OPENREQ IF RtAllocRequestA()=NIL

	DEF handle=NIL,fr:PTR TO rtfilerequester,select,
		buffer[10]:ARRAY OF CHAR,i,l,ol,
		vp:PTR TO viewport,max,
		name[50]:STRING,path[400]:STRING,file[450]:STRING

	fr:=RtAllocRequestA(RT_FILEREQ,0)
	RtChangeReqAttrA(fr,[RTFI_DIR,palpath,TAG_DONE])
	select:=RtFileRequestA(fr,name,'IFF-Palette laden',
			[RT_REQPOS,REQPOS_POINTER,
			RTFI_FLAGS,FREQF_PATGAD,TAG_DONE])
	StrCopy(path,fr.dir,ALL)
	RtFreeRequest(fr);fr:=NIL
	IF select=1
		StrCopy(file,path,ALL)
		StrCopy(palpath,path,ALL)
		IF EstrLen(path)-1>InStr(path,':',0) THEN StrAdd(file,'/',1)
		StrAdd(file,name,ALL)
		IF (handle:=Open(file,MODE_OLDFILE))=NIL THEN Raise(E_OPENFILE)
		Read(handle,buffer,8)
		IF StrCmp('FORM',buffer,4)=FALSE THEN Raise(E_PALFORMAT)
		Read(handle,buffer,4)
		IF StrCmp('ILBM',buffer,4)=FALSE THEN Raise(E_PALFORMAT)
		l:=0						/* CMAP-Chunk suchen */
		REPEAT
			ol:=Seek(handle,l,0)
			Read(handle,buffer,4)
			Read(handle,{l},4)
		UNTIL StrCmp('CMAP',buffer,4) OR (ol<0)
		IF ol<0 THEN Raise(E_EOF)
		max:=Shl(1,depth)
		IF l/3>max
			IF request(msglist[M_MORECOLORS],declist[D_JANEIN],[name,max])=FALSE THEN RETURN DO_ABBRUCH
		ENDIF
		IF l/3<max THEN max:=l/3
		vp:=scr.viewport
		FOR i:=0 TO max-1
			Read(handle,buffer,3)
			SetRGB4(vp,i,Shr(buffer[0],4),Shr(buffer[1],4),Shr(buffer[2],4))
			colortab[i]:=GetRGB4(vp.colormap,i)
		ENDFOR
	ENDIF
EXCEPT
	request(erlist[exception],declist[D_OK],[name])
	IF fr<>NIL THEN RtFreeRequest(fr)
	IF handle<>NIL THEN Close(handle)
ENDPROC


PROC saveclass(cl:PTR TO class,named) HANDLE
	RAISE	E_WRITE IF Write()<0,
			E_MEM IF New()=NIL,
			E_OPENREQ IF RtAllocRequestA()=NIL

	DEF handle=NIL,e,samem=NIL,name[50]:STRING,
		select,path[400]:STRING,file[450]:STRING,
		fr:PTR TO rtfilerequester,pat[30]:STRING

	IF cl.data=NIL
		request(erlist[E_NODATA],declist[D_OK],[cl.name])
		Raise(E_NONE)
	ENDIF

	IF (named=FALSE) OR (StrLen(cl.filename)=0)
		IF StrLen(cl.filename)=0
			StringF(name,'Menge\dx\d \di.FRAK',cl.width,cl.height,cl.it)
		ELSE
			StrCopy(name,cl.filename,ALL)
		ENDIF
		fr:=RtAllocRequestA(RT_FILEREQ,NIL)
		RtChangeReqAttrA(fr,[RTFI_DIR,cl.path,
						RTFI_MATCHPAT,cl.pattern,TAG_DONE])
		select:=RtFileRequestA(fr,name,'Menge Speichern',
				[RT_REQPOS,REQPOS_POINTER,
				RTFI_FLAGS,FREQF_SAVE OR FREQF_PATGAD,TAG_DONE])
		StrCopy(path,fr.dir,ALL)
		StrCopy(pat,fr.matchpat,ALL)
		RtFreeRequest(fr);fr:=NIL
		IF select=1
			StrCopy(file,path,ALL)
			IF EstrLen(path)-1>InStr(path,':',0) THEN StrAdd(file,'/',1)
			StrAdd(file,name,ALL)
			IF (handle:=Open(file,MODE_OLDFILE))<>NIL
				Close(handle)
				IF request(msglist[M_OVERWRITE],declist[D_JANEIN],[name])=0 THEN RETURN DO_ABBRUCH
			ENDIF
		ELSE
			RETURN DO_ABBRUCH
		ENDIF
		CopyMem(path,cl.path,EstrLen(path)+1)
		CopyMem(name,cl.filename,EstrLen(name)+1)
		CopyMem(pat,cl.pattern,EstrLen(pat)+1)
	ENDIF

	StrCopy(file,cl.path,ALL)
	IF StrLen(path)-1>InStr(cl.path,':',0) THEN StrAdd(file,'/',1)
	StrAdd(file,cl.filename,ALL)
	samem:=New(SIZEOF diskclass)
	CopyMem([cl.done,cl.ydone,cl.width,cl.height,
			cl.xmin,cl.xmax,cl.ymin,cl.ymax,cl.it,
			cl.flinterrupted,cl.flstarted,0]:diskclass,
			samem,SIZEOF diskclass)

	IF (handle:=Open(file,MODE_NEWFILE))=NIL THEN Raise(E_OPENFILE)
	Write(handle,identify,EstrLen(identify))
	Write(handle,samem,SIZEOF diskclass)
	Write(handle,cl.data,clsize(cl))

	Close(handle)
	Dispose(samem);samem:=NIL

	SetProtection(file,%0010)	/* nicht ausführbar */
	cl.flsaved:=TRUE
	e:=DO_NONE
	request(msglist[M_WRITTEN],declist[D_OK],[cl.filename])
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],[cl.filename])
	IF handle<>NIL
		Close(handle)
		DeleteFile(file)
	ENDIF
	IF fr<>NIL THEN RtFreeRequest(fr)
	IF samem<>NIL THEN Dispose(samem)
	e:=DO_ABBRUCH
ENDPROC e


PROC readclass() HANDLE
	RAISE	E_READ IF Read()<0,
			E_MEM IF AllocMem()=NIL,
			E_OPENREQ IF RtAllocRequestA()=NIL

	DEF handle=NIL,cl:PTR TO class,ident[14]:STRING,
		sa:PTR TO diskclass,mem=NIL,length,samem=NIL,
		fr:PTR TO rtfilerequester,select,
		path[400]:STRING,name[50]:STRING,
		file[450]:STRING,pat[30]:STRING

	fr:=RtAllocRequestA(RT_FILEREQ,0)
	RtChangeReqAttrA(fr,[RTFI_MATCHPAT,'#?.FRAK',TAG_DONE])
	select:=RtFileRequestA(fr,name,'Menge laden',
			[RT_REQPOS,REQPOS_POINTER,
			RTFI_FLAGS,FREQF_PATGAD,TAG_DONE])
	StrCopy(path,fr.dir,StrLen(fr.dir))
	StrCopy(pat,fr.matchpat,StrLen(fr.matchpat))
	RtFreeRequest(fr);fr:=NIL

	IF select=1
		StrCopy(file,path,ALL)
		IF EstrLen(path)-1>InStr(path,':',0) THEN StrAdd(file,'/',1)		
		StrAdd(file,name,ALL)
		IF (handle:=Open(file,MODE_OLDFILE))<>NIL
			Read(handle,ident,EstrLen(identify))
			IF StrCmp(ident,identify,ALL)=FALSE
				Close(handle)
				request(erlist[E_FORMAT-1],declist[D_OK],[name])
			ELSE
				samem:=New(SIZEOF diskclass)
				Read(handle,samem,SIZEOF diskclass)
				sa:=samem
				length:=Mul(Mul(sa.width,sa.height),2)
				mem:=AllocMem(length,$10001)
				Read(handle,mem,length)
				Close(handle)
				IF (cl:=newclass(clist))<>NIL
					CopyMem(name,cl.filename,StrLen(name)+1)
					CopyMem(path,cl.path,EstrLen(path)+1)
					CopyMem(pat,cl.pattern,EstrLen(pat)+1)
					cl.data:=mem
					cl.done:=sa.done
					cl.ydone:=sa.ydone
					cl.width:=sa.width
					cl.height:=sa.height
					cl.xmin:=sa.xmin
					cl.xmax:=sa.xmax
					cl.ymin:=sa.ymin
					cl.ymax:=sa.ymax
					cl.it:=sa.it
					cl.flsaved:=TRUE
					cl.flstarted:=sa.flstarted
					cl.flinterrupted:=sa.flinterrupted
					putgadgets(cl)
					dispstate(cl,cl.done)
					IF cl.done=cl.height THEN finish(cl)
				ENDIF
			Dispose(samem);samem:=NIL
			ENDIF
		ELSE
			request(erlist[E_OPENFILE],declist[D_OK],[name])
		ENDIF
	ENDIF
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],[name])
	IF samem<>NIL THEN Dispose(samem)
	IF mem<>NIL
		FreeMem(mem,length)
		cl.data:=NIL
	ENDIF
	IF cl<>NIL THEN deleteclass(cl)
	IF handle<>NIL THEN Close(handle)
	IF fr<>NIL THEN RtFreeRequest(fr)
	cl:=NIL
ENDPROC cl


PROC allocCMAP(vp:PTR TO viewport,m:PTR TO LONG) HANDLE
	RAISE E_MEM IF New()=NIL
	DEF size,cm:PTR TO colormap,farbe,i,mem

	size:=3*Shl(1,depth)
	IF (size AND 1)=1 THEN INC size		/* ungerade Länge vermeiden */

	mem:=New(size)
	cm:=vp.colormap
	FOR i:=0 TO Shl(1,depth)-1
		farbe:=GetRGB4(cm,i)
		PutChar(mem+(3*i),Shr(farbe AND $F00,4))
		PutChar(mem+1+(3*i),farbe AND $F0)
		PutChar(mem+2+(3*i),Shl(farbe AND $F,4))
	ENDFOR
	^m:=mem
EXCEPT
	request(erlist[exception],declist[D_OK],0)
	size:=0
ENDPROC size


PROC iffsave(view:PTR TO subclass) HANDLE
	RAISE	E_WRITE IF Write()<0,
			E_MEM IF New()=NIL,
			E_OPENREQ IF RtAllocRequestA()=NIL

	DEF	iffname[50]:STRING,iffpath[400]:STRING,ifffile[450]:STRING,
		handle=NIL,select,fr:PTR TO rtfilerequester,
		bm: PTR TO bitmap,pl[7]:ARRAY OF LONG,vp:PTR TO viewport,
		cmapmem=NIL,mode,author[20]:STRING,packlen,
		bmhdsize,cmapsize,camgsize,bodysize,formsize,authsize,ccrtsize,
		cl:PTR TO class,i,packbuffer:PTR TO CHAR,zeile,zeilesize,packpos,
		bmhd:PTR TO bitmapheader,xasp,yasp,zeilbuffer,bitstoclear,
		clearword,lastword

	cl:=view.class
	StringF(iffname,'Mandel\dx\dx\d\s.ILBM',cl.width,cl.height,depth,IF view.viewtype=VIEW_3D THEN '-3D' ELSE '')
	fr:=RtAllocRequestA(RT_FILEREQ,0)
	RtChangeReqAttrA(fr,[RTFI_DIR,picpath,TAG_DONE])
	select:=RtFileRequestA(fr,iffname,'IFF-Speichern',
			[RT_REQPOS,REQPOS_POINTER,
			RTFI_FLAGS,FREQF_SAVE,TAG_DONE])
	StrCopy(iffpath,fr.dir,ALL)
	RtFreeRequest(fr);fr:=NIL

	IF select=1
		StrCopy(picpath,iffpath,ALL)
		StrCopy(ifffile,iffpath,ALL)
		IF EstrLen(iffpath)-1>InStr(iffpath,':',0) THEN StrAdd(ifffile,'/',1)
		StrAdd(ifffile,iffname,ALL)
		IF (handle:=Open(ifffile,MODE_OLDFILE))<>NIL
			Close(handle)
			IF request(msglist[M_OVERWRITE],declist[D_JANEIN],[iffname])=0 THEN RETURN DO_ABBRUCH
		ENDIF
	ELSE
		RETURN DO_ABBRUCH
	ENDIF

	vp:=scr.viewport
	bm:=view.bitmap

	mode:=getVMode()
	bmhdsize:=20
	bmhd:=New(bmhdsize)

	bmhd.w:=cl.width
	bmhd.h:=cl.height
	bmhd.planes:=depth
	bmhd.masking:=2
	bmhd.compression:=iffcomp
	bmhd.transparentcolor:=0
	xasp:=44;yasp:=44
	IF (mode AND V_HIRES)<>0 THEN Shr(xasp,1)
	IF (mode AND V_LACE)<>0 THEN Shr(yasp,1)
	bmhd.xaspect:=xasp
	bmhd.yaspect:=yasp
	bmhd.pagewidth:=scr.width
	bmhd.pageheight:=scr.height

	IF (cmapsize:=allocCMAP(vp,{cmapmem}))=0 THEN Raise(E_NONE)

	camgsize:=4
	ccrtsize:=14

	author:='Fraktalik V2.03 '
	authsize:=StrLen(author)

	zeilesize:=Shl(Shr(cl.width+15,4),1)

	packbuffer:=New(zeilesize*depth*2)	/* wird später gepackt, lieber größer */

	zeilbuffer:=New(zeilesize)
	bitstoclear:=(Shl(1,Mod(cl.width,16))-1)
	clearword:=$FFFF AND Shl(bitstoclear,16-Mod(cl.width,16))

	IF (handle:=Open(ifffile,MODE_NEWFILE))=NIL THEN Raise(E_OPENFILE)
	Write(handle,'FORM    ILBMBMHD',16)

	Write(handle,{bmhdsize},4)				/* Bitmapheader */
	Write(handle,bmhd,bmhdsize)
	Dispose(bmhd)

	Write(handle,'CMAP',4)				/* Colormap */
	Write(handle,{cmapsize},4)
	Write(handle,cmapmem,cmapsize)
	Dispose(cmapmem);cmapmem:=NIL	

	Write(handle,'CAMG',4)				/* AMIGA-ViewModes */
	Write(handle,{camgsize},4)
	Write(handle,{mode},camgsize)

	Write(handle,'CCRT',4)				/* Color Cycling (Commodore-Version) */
	Write(handle,{ccrtsize},4)
	Write(handle,[cdir,4,Shl(1,depth)-1,csecs,cmics,0]:cycleinfo,ccrtsize)

	Write(handle,'AUTH',4)
	Write(handle,{authsize},4)
	Write(handle,author,authsize)

	pl:=bm.plane
	Write(handle,'BODY',4)				/* BODY (ByteRun1 - gepackt) */
	Write(handle,[0]:LONG,4)
	bodysize:=0
	FOR zeile:=0 TO cl.height-1
		packpos:=0
		FOR i:=0 TO depth-1
			/* über den Rand hinausragende Bits löschen */

			CopyMem((zeilesize*zeile)+pl[i],zeilbuffer,zeilesize)
			lastword:=zeilbuffer+zeilesize-2
			PutInt(lastword,Int(lastword) AND clearword)

			IF iffcomp=BYTE_RUN
				packlen:=packIt(zeilbuffer,packbuffer+packpos,zeilesize)
				packpos:=packpos+packlen
			ELSE
				CopyMem(zeilbuffer,packbuffer+(zeilesize*i),zeilesize)
				packpos:=packpos+zeilesize
			ENDIF
		ENDFOR
		Write(handle,packbuffer,packpos)
		bodysize:=bodysize+packpos
	ENDFOR
	Dispose(packbuffer)
	Dispose(zeilbuffer)

	Seek(handle,-bodysize-4,0)			/* BODY-Länge eintragen */
	Write(handle,[bodysize]:LONG,4)
	formsize:=52+bmhdsize+cmapsize+camgsize+bodysize+authsize+ccrtsize
	Seek(handle,4,-1)
	Write(handle,{formsize},4)			/* FORM-Länge eintragen */
	Close(handle)

	request(msglist[M_IFF],declist[D_OK],[iffname])
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],[iffname])
	IF handle<>NIL
		Close(handle)
		DeleteFile(ifffile)
	ENDIF
	IF fr<>NIL THEN RtFreeRequest(fr)
	IF cmapmem<>NIL THEN Dispose(cmapmem)
	IF packbuffer<>NIL THEN Dispose(packbuffer)
	IF zeilbuffer<>NIL THEN Dispose(zeilbuffer)
	IF bmhd<>NIL THEN Dispose(bmhd)
ENDPROC


PROC packIt(buffer:PTR TO CHAR,packbuff:PTR TO CHAR,len)
	/* ByteRun1 - Algorythmus */

	DEF vergleich=0,bytes=0,pos=0,i=0,unpos=0,ungepackt=0,c,
		packbegin
	
	packbegin:=packbuff

	DEC len
	WHILE pos<=len
		vergleich:=Char(buffer+pos)
		i:=pos+1
		bytes:=1
		WHILE (Char(buffer+i)=vergleich) AND (i<=len) AND (bytes<128)
			INC i;INC bytes
		ENDWHILE
		IF bytes>=3
			IF ungepackt>0
				DEC ungepackt
				PutChar(packbuff++,ungepackt)		/* code<128 schreiben */
				FOR c:=unpos TO unpos+ungepackt DO PutChar(packbuff++,Char(buffer+c))
				ungepackt:=0
			ENDIF
			PutChar(packbuff++,(-bytes)+1)			/* code>128 schreiben */
			PutChar(packbuff++,vergleich)
		ELSE
			IF ungepackt=0 THEN unpos:=pos
			ungepackt:=ungepackt+bytes
		ENDIF
		pos:=i
	ENDWHILE
	IF ungepackt>0		/* am Ende noch ungepackte Bytes */
		DEC ungepackt
		PutChar(packbuff++,ungepackt)
		FOR c:=unpos TO unpos+ungepackt DO PutChar(packbuff++,Char(buffer+c))
	ENDIF			
ENDPROC (packbuff-packbegin)


PROC changescreen() HANDLE
	RAISE E_WIN IF OpenW()=NIL

	DEF g[5]:ARRAY OF LONG,w:PTR TO window,e=DO_NONE,i,
		m,b,h,t,vp:PTR TO viewport,
		ga:PTR TO gadget,id,msg:PTR TO intuimessage,
		iaddr,class,maxloresdepth,maxhiresdepth,maxdepth

	windowlock(clist,WL_LOCK)

	IF KickVersion(39)
		maxloresdepth:=8
		maxhiresdepth:=8
		maxdepth:=maxhiresdepth
	ELSE
		maxloresdepth:=5
		maxhiresdepth:=4
		maxdepth:=maxloresdepth
	ENDIF

	w:=OpenW((scr.width-178)/2,(scr.height-140)/2,178,140,
			0,REQ_FLAGS,'Auflösung',scr,$F,NIL)
	w.userport:=portIDCMP
	ModifyIDCMP(w,REQ_IDCMP)

	SetAPen(stdrast,2)
	setAfPt(stdrast,[$AAAA,$5555]:INT,1)	
	RectFill(stdrast,w.borderleft,w.bordertop,w.width-w.borderright-1,w.height-w.borderbottom-1)
	setAfPt(stdrast,[$FFFF]:INT,0)
	
	doubbevel(stdrast,8,16,162,100,FALSE)

	Colour(2,0)
	TextF(23,28,'Breite      Höhe')

	g[0]:=createGadget(w,'320',GTYP_BOOLGADGET,0,0,15,33,60,14,1)
	IF g[0]=NIL THEN Raise(E_NONE)

	g[1]:=createGadget(w,'256',GTYP_BOOLGADGET,0,0,103,33,60,14,2)
	IF g[1]=NIL THEN Raise(E_NONE)

	g[2]:=createGadget(w,'640',GTYP_BOOLGADGET,0,0,15,50,60,14,3)
	IF g[2]=NIL THEN Raise(E_NONE)

	g[3]:=createGadget(w,'512',GTYP_BOOLGADGET,0,0,103,50,60,14,4)
	IF g[3]=NIL THEN Raise(E_NONE)

	g[4]:=createGadget(w,'Tiefe',GTYP_PROPGADGET,PROPFL OR FREEHORIZ,maxdepth-3,19,82,140,8,5)
	IF g[4]=NIL THEN Raise(E_NONE)
	Colour(1,0)
	dispprop(g[4],3)
	setprop(w,g[4],3,depth)

	bevelbox(stdrast,15,95,148,14,FALSE)

	g[5]:=createGadget(w,'OK',GTYP_BOOLGADGET,0,0,w.width/2-30,w.height-20,60,14,6)
	IF g[5]=NIL THEN Raise(E_NONE)
	
	b:=scr.width
	h:=scr.height
	t:=depth
	vp:=scr.viewport
	m:=vp.modes

	REPEAT
		Colour(3,0)
		TextF(17,104,'\dx\d \d[3] Farben',b,h,Shl(1,t))

		IF (msg:=GetMsg(portIDCMP))=NIL
			WaitPort(portIDCMP)
			msg:=GetMsg(portIDCMP)
		ENDIF
		
		class:=msg.class
		iaddr:=msg.iaddress
		ReplyMsg(msg)

		SELECT class
		CASE IDCMP_CLOSEWINDOW
			e:=DO_ABBRUCH
		CASE IDCMP_GADGETUP
			ga:=iaddr
			id:=ga.gadgetid
			SELECT id
				CASE 1; b:=320;m:=m AND ($FFFF-V_HIRES)
						IF (t>maxloresdepth)
							t:=maxloresdepth
							setprop(w,g[4],3,t)
						ENDIF

				CASE 2; h:=256;m:=m AND ($FFFF-V_LACE)

				CASE 3; b:=640;m:=m OR V_HIRES
						IF (t>maxhiresdepth)
							t:=maxhiresdepth
							setprop(w,g[4],3,t)
						ENDIF

				CASE 4; h:=512;m:=m OR V_LACE

				CASE 6; e:=DO_AGAIN
			ENDSELECT
		CASE IDCMP_GADGETDOWN
			ga:=iaddr
			IF ga.gadgetid=5 THEN t:=handleprop(w,ga,3)
			IF ((m AND V_HIRES)<>0)
				IF t>maxhiresdepth
					t:=maxhiresdepth
					setprop(w,g[4],3,t)
				ENDIF
			ELSE
				IF (t>maxloresdepth)
					t:=maxloresdepth
					setprop(w,g[4],3,t)
				ENDIF
			ENDIF					
		ENDSELECT
	UNTIL (e=DO_ABBRUCH) OR (e=DO_AGAIN)

	FOR i:=0 TO 5 DO delgadget(w,g[i])
	RtCloseWindowSafely(w)

	windowlock(clist,WL_UNLOCK)

	IF e<>DO_ABBRUCH THEN e:=changemode(m,b,h,t,clist)
EXCEPT
	IF w<>NIL
		FOR i:=0 TO 5
			IF g[i]<>NIL THEN delgadget(w,g[i])
		ENDFOR
		RtCloseWindowSafely(w)
	ENDIF
	e:=DO_ABBRUCH
	IF exception<>E_NONE THEN request(erlist[exception],declist[D_OK],0)
ENDPROC e


PROC changemode(mode,breite,hoehe,tiefe,classlist:PTR TO mlh)
	DEF vp:PTR TO viewport,cl:PTR TO class,
		ow,oh,ot,om,fehler,e,cyc=FALSE

   
	e:=DO_NONE

	IF request(msglist[M_NEWSCREEN],declist[D_JANEIN],0)=0 THEN RETURN DO_ABBRUCH

	IF cyclewindow<>NIL
		closeCycWindow()
		cyc:=TRUE
	ENDIF

	vp:=scr.viewport
	ow:=scr.width
	oh:=scr.height
	ot:=depth
	om:=vp.modes

	cl:=classlist.head
	WHILE cl.succ<>NIL
		IF clearviews(cl)=DO_ABBRUCH THEN RETURN(DO_ABBRUCH)
		closeClassWindow(cl)
		cl:=cl.succ
	ENDWHILE
	disownrequest(oldreqwin)
	ClearMenuStrip(win)
	RtCloseWindowSafely(win)
	CloseS(scr)

	fehler:=FALSE
	IF opendesktop(breite,hoehe,tiefe,mode)=DO_NONE
		IF openallwindows(scr)			/* =TRUE, wenn fehler */
			disownrequest(oldreqwin)
			ClearMenuStrip(win)
			RtCloseWindowSafely(win)
			CloseS(scr)
			fehler:=TRUE
		ENDIF		
	ELSE
		fehler:=TRUE
	ENDIF

	IF fehler
		disownrequest(oldreqwin)
		IF opendesktop(ow,oh,ot,om)=DO_NONE
			IF openallwindows(scr)
				e:=DO_EXIT
			ELSE
				ScreenToFront(scr)
			ENDIF
		ELSE
			e:=DO_EXIT
		ENDIF
		request(msglist[M_CHANGE],declist[D_OK],0)
	ELSE
		ScreenToFront(scr)
		IF cyc THEN cyclecolors()
	ENDIF
ENDPROC e


PROC openallwindows(s:PTR TO screen)
	DEF cl:PTR TO class,fehler=FALSE

	cl:=clist.head
	WHILE (cl.succ<>NIL) AND (fehler=FALSE)
		IF openClassWindow(cl,cl.name,s)<>0
			putgadgets(cl)
			dispstate(cl,cl.done)
			IF cl.done=cl.height THEN finish(cl)
			RtUnlockWindow(cl.mainwin,cl.lock)
			cl.lock:=0
			cl:=cl.succ
		ELSE
			fehler:=TRUE
		ENDIF
	ENDWHILE
	IF fehler
		cl:=clist.head
		WHILE cl.succ<>NIL
			closeClassWindow(cl)	/* achtet auf noch geschlossene Windows */
			cl:=cl.succ
		ENDWHILE
	ENDIF		
ENDPROC fehler
