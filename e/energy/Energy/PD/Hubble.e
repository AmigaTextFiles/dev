/* 	Hubble V1.1b - 1996 - © Marco Talamelli
	E-Mail: Marco_Talamelli@amp.flashnet.it
 	Data:18 May 1996
	A Simple lens
*/

OPT PREPROCESS
OPT OSVERSION=39

MODULE  'intuition/intuition',		-> window
	'intuition/imageclass',
	'intuition/icclass',
	'intuition/screens',		-> screen
	'intuition/gadgetclass',
	'intuition/classes',		-> object
	'exec/ports',			-> MessagePort
	'commodities',
	'libraries/commodities',
	'reqtools',
	'libraries/reqtools',
	'gadtools','iff',
	'libraries/gadtools',
	'graphics/view',
	'graphics/scale',		-> scale image
	'graphics/gfx',			-> bitmap
	'graphics/rastport',
       	'other/ecode',
	'devices/inputevent'		-> for inputevent

DEF 	innerwidth = 200,
	innerheight = 100,
	scalefac = 10,
	cxsigflag, scrdepth,
	waitmask,x,y,
	ie:PTR TO inputevent,
	leftoff, topoff, bottomoff,
	sizeiw, sizeih, winleft=100, wintop=100,
	signal=-1,visualinfo,
	broker_mp=NIL:PTR TO mp,
	broker=NIL,
	userport:PTR TO mp,
	cosignal=NIL,
	mywin:PTR TO window,
	hires,view,
	filereq:PTR TO rtfilerequester,
	filename[34]:STRING,
	scr:PTR TO screen,tmpscr:PTR TO screen,
	sizex, sizey,
	menu:PTR TO menu,task,
	item:PTR TO menuitem,
	srcbm:PTR TO bitmap,
	destbm:PTR TO bitmap,
	scrbm:PTR TO bitmap,
	jump = FALSE, mm = TRUE,
	customcxobj,
	propgadget:PTR TO object,
	pubscreenname[MAXPUBSCREENNAME]:STRING

PROC setupscreen()

   IF scr
 	IF NextPubScreen(scr, pubscreenname)

         tmpscr := LockPubScreen(pubscreenname)
            FreeVisualInfo(visualinfo)
            UnlockPubScreen(NIL, scr)
            scr := tmpscr
         ELSE
	    RETURN FALSE
        ENDIF
   ELSE
	scr:=LockPubScreen(NIL)
   ENDIF
   visualinfo := GetVisualInfoA(scr, NIL)
ENDPROC TRUE

PROC getoffsets()

DEF 	drawinfo:PTR TO drawinfo,sizeobject

   hires := scr.flags
   IF hires THEN (sizeiw := 18) ELSE (sizeiw := 13)
   IF drawinfo := GetScreenDrawInfo(scr)

      IF sizeobject := NewObjectA(NIL, 'sysiclass',
       			[SYSIA_WHICH, SIZEIMAGE,
       			SYSIA_DRAWINFO, drawinfo,
       			SYSIA_SIZE,(IF hires THEN SYSISIZE_HIRES ELSE SYSISIZE_MEDRES)])

         GetAttr(IA_WIDTH, sizeobject, {sizeiw})
           
         GetAttr(IA_HEIGHT, sizeobject, {sizeih})
 
         DisposeObject(sizeobject)
      ENDIF
      FreeScreenDrawInfo(scr, drawinfo)
   ENDIF
   topoff := scr.rastport.txheight + scr.wbortop + 1
   leftoff := scr.wborleft
   bottomoff := scr.wborbottom
   scrbm := scr.bitmap
   scrdepth := scr.bitmap.depth
ENDPROC

PROC allocbm()

   IF destbm THEN FreeBitMap(destbm)
   IF srcbm THEN FreeBitMap(srcbm)
   innerwidth := mywin.width - (leftoff + sizeiw)
   innerheight := mywin.height - (topoff + bottomoff)
   sizex:=(innerwidth / scalefac)
   sizey:=(innerheight / scalefac)

   srcbm := AllocBitMap(sizex, sizey, scrdepth, BMF_CLEAR, scrbm)
   destbm := AllocBitMap(innerwidth, innerheight, scrdepth, BMF_CLEAR, srcbm)

ENDPROC TRUE

PROC openwin()

DEF resolution,bw,rh,wx,wy

wx:=30 + topoff + bottomoff
wy:=60 + leftoff + sizeiw

  resolution:= IF scr.flags AND SCREENHIRES THEN SYSISIZE_HIRES ELSE SYSISIZE_LOWRES

  bw:=IF resolution=SYSISIZE_LOWRES THEN 1 ELSE 2
  rh:=IF resolution=SYSISIZE_HIRES THEN 2 ELSE 1

   IF menu := CreateMenusA([NM_TITLE,0,'Project',0,0,0,0,
    NM_ITEM,0,'Jump','J',0,0,0,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'Save Screen','S',0,0,0,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'Info Screen','I',0,0,0,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'MouseMove','M',(IF mm THEN CHECKED ELSE 0) OR CHECKIT,0,0,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'About','A',$0,0,0,
    NM_ITEM,0,NM_BARLABEL,0,0,0,0,
    NM_ITEM,0,'Quit','Q',0,0,0,0]:newmenu,NIL)

      IF LayoutMenusA(menu, visualinfo, [GTMN_NEWLOOKMENUS, TRUE, NIL])

         IF propgadget := NewObjectA(NIL, 'propgclass',
          [PGA_FREEDOM,    FREEVERT,
          ICA_TARGET,      ICTARGET_IDCMP,
          PGA_NEWLOOK,     TRUE,
          PGA_BORDERLESS,  DRIF_NEWLOOK,
          PGA_TOTAL,       20,
          PGA_VISIBLE,     1,
          PGA_TOP,         scalefac,
          GA_RELVERIFY,    1,
          GA_RELRIGHT,     bw - sizeiw + 3,
          GA_TOP,          topoff + rh,
          GA_WIDTH,        sizeiw - bw - bw - 4,
          GA_RELHEIGHT,    -topoff - sizeih - rh - rh,
          GA_RIGHTBORDER,  TRUE,NIL])

            IF mywin := OpenWindowTagList(NIL,
      				[WA_GADGETS,	propgadget,
       				WA_MINWIDTH,	wy,
       				WA_MINHEIGHT,	wx,
       				WA_PUBSCREEN,	scr,
            			WA_TITLE,	'Hubble v1.1b',
            		WA_FLAGS,	WFLG_CLOSEGADGET OR
					WFLG_SIZEGADGET OR
					WFLG_SIZEBRIGHT OR
					WFLG_DRAGBAR OR
					WFLG_DEPTHGADGET OR
					WFLG_SIMPLE_REFRESH OR
					WFLG_ACTIVATE OR
					WFLG_NEWLOOKMENUS,
            	WA_IDCMP,	IDCMP_CLOSEWINDOW OR
				IDCMP_NEWSIZE OR
				IDCMP_MENUPICK OR
				IDCMP_REFRESHWINDOW OR
				IDCMP_IDCMPUPDATE,
            				WA_WIDTH,innerwidth + leftoff + sizeiw,
            				WA_HEIGHT,innerheight + topoff + bottomoff,
             				WA_LEFT,        winleft,
             				WA_TOP,         wintop,
            				WA_MAXWIDTH,	-1,
            				WA_MAXHEIGHT,	-1,
             				WA_AUTOADJUST,  TRUE,NIL])
               SetMenuStrip(mywin, menu)
               userport := mywin.userport
               ScreenToFront(scr)
               RETURN TRUE
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDPROC FALSE

PROC closewin()

   IF mywin
	ClearMenuStrip(mywin)
   	CloseWindow(mywin)
   ENDIF
   IF menu THEN FreeMenus(menu)
   IF propgadget THEN DisposeObject(propgadget)
   IF srcbm THEN FreeBitMap(srcbm)
   IF destbm THEN FreeBitMap(destbm)
   srcbm := NIL
   destbm := NIL
ENDPROC

PROC refresh()
x:= scr.mousex - (sizex / 2)
y:= scr.mousey - (sizey / 2)

   IF (x < 0) THEN x := 0
   IF (x > (scr.width - sizex)) THEN x := (scr.width - sizex)
   IF (y < 0) THEN y := 0

   IF (y > (scr.height - sizey)) THEN y := (scr.height - sizey)

   BltBitMap(scrbm, x, y, srcbm, 0, 0, sizex, sizey, $80 OR $40, -1, NIL)

   WaitBlit()
   scale()
ENDPROC

PROC scale()
   IF scalefac >1

      BitMapScale([0,0,sizex,sizey,1,1,0,0,
		innerwidth,innerheight,scalefac,scalefac,
		srcbm,destbm,0,0,0,0,0]:bitscaleargs)
      WaitBlit()
      BltBitMapRastPort(destbm, 0, 0, mywin.rport, leftoff, topoff, innerwidth, innerheight, $80 OR $40)

   ELSE
	BltBitMapRastPort(srcbm, 0, 0, mywin.rport, leftoff, topoff, innerwidth, innerheight, $80 OR $40 )
  ENDIF
   WaitBlit()
ENDPROC

PROC processmsg()

DEF 	intuimsg:PTR TO intuimessage, im,
	msg,
	done = FALSE,
	msgtype, msgid,sigmask, itemNum,	
	code
REPEAT

         sigmask := Wait(Shl(1,userport.sigbit) OR Shl(1,signal) OR cxsigflag)

      IF (sigmask AND cxsigflag)
         WHILE (msg := GetMsg(broker_mp))
            msgid := CxMsgID(msg)
            msgtype := CxMsgType(msg)
            ReplyMsg(msg)

            SELECT msgtype
             CASE CXM_COMMAND
               SELECT msgid
                CASE CXCMD_DISABLE
                  ActivateCxObj(broker, FALSE)
                CASE CXCMD_ENABLE
                  ActivateCxObj(broker, TRUE)
                CASE CXCMD_KILL
                  done := TRUE
               ENDSELECT
            ENDSELECT
         ENDWHILE
      ENDIF
      IF sigmask AND (Shl(1, userport.sigbit))
         jump := FALSE
         WHILE intuimsg := GetMsg(userport)
            ReplyMsg(intuimsg)
		im:=intuimsg.class
            SELECT im
             CASE IDCMP_CLOSEWINDOW
               done := TRUE
             CASE IDCMP_NEWSIZE
               allocbm()
		refresh()
             CASE IDCMP_IDCMPUPDATE
               GetAttr(PGA_TOP, propgadget, {scalefac})
                  INC scalefac
                  allocbm()
			refresh()
             CASE IDCMP_MENUPICK
      code:=intuimsg.code
      WHILE (code<>MENUNULL) AND (jump=FALSE)
        item:=ItemAddress(menu, code)

        itemNum:=ITEMNUM(code)
	SELECT itemNum
	CASE 0
	 jumpfunc()
	CASE 2
	IF filereq := RtAllocRequestA(RT_FILEREQ, NIL)
		filename[0] := 0
		IF RtFileRequestA(filereq, filename, 'Save as...',0)

	view:=(IF scalefac>1 THEN destbm ELSE srcbm)
		IfFL_SaveClip(filename,view,scr.viewport.colormap.colortable,scr.flags,
		0,0,mywin.width/8,mywin.height)

		ELSE
		RtEZRequestA('No Save screen!', '_Continue', NIL, NIL,[RT_UNDERSCORE, "_",NIL])
		ENDIF
	RtFreeRequest(filereq)
	ELSE
	RtEZRequestA('No Memory!!', 'Aargh!', NIL, NIL, NIL)
	ENDIF

	CASE 4
		RtEZRequestA('Title     : \s\n'+
				'Width     : \d\n'+
				'Height    : \d\n'+
				'Flags     : $\h\n'+
				'BitMap    : $\h\n'+
				'Depth     : \d\n',
					'_Continue',
						NIL,
					[scr.title,
					scr.width,
					scr.height,
					scr.flags,
					scr.bitmap,
					scr.bitmap.depth],
					[RT_UNDERSCORE, "_",NIL])
	CASE 6
		IF ((mm = FALSE) AND item.flags)
	  	  mm := TRUE
   		ELSEIF ((mm=TRUE) AND item.flags)
	  	  mm := FALSE
		ENDIF
	  	  ActivateCxObj(broker, mm)
	CASE 8
	RtEZRequestA(	'Hubble V1.1b ( 18 May 1996)\n\n'+
   			'written by:\n  Marco Talamelli\n'+
   			'  Via Massa di San Giuliano 440\n'+
   			'  Roma\n  00010\n  ITALIA\n\n'+
   			'EMail:\n  Marco_Talamelli@amp.flashnet.it\n\n'+
   			'This program is CardWare!\n'+
			'if you like it, send me a postcard of your city!\n'+
			'see you soon!','_Continue',NIL,NIL,[RT_UNDERSCORE, "_",NIL])
	scale()
	CASE 10
	 RETURN
	CASE 7
	 jump:=TRUE
	ENDSELECT
        code := (item.nextselect) AND ($FFFF)
      ENDWHILE
            ENDSELECT
         ENDWHILE
      ENDIF
      IF sigmask  AND ((ie.class = IECLASS_RAWMOUSE) AND mm) THEN refresh()
UNTIL done
ENDPROC

PROC set()

      waitmask := waitmask AND (Shl(1,userport.sigbit)+1)
      wintop := mywin.topedge
      winleft := mywin.leftedge
      getoffsets()
ENDPROC

PROC jumpfunc()

DEF returnvalue

   IF returnvalue := setupscreen()
      closewin()
       set()
       WHILE openwin()=FALSE
	 RtEZRequestA('Unable to open \a\s\a Screen!','_Continue',NIL,[pubscreenname],[RT_UNDERSCORE, "_",NIL])
	 setupscreen()
	 set()
	ENDWHILE
      waitmask := waitmask OR Shl(1,userport.sigbit)
       allocbm()
	refresh()
      jump := TRUE
       IF (returnvalue = 1) THEN RETURN TRUE
   ENDIF
ENDPROC FALSE

PROC cxfunction(cxm,co)

   ie := CxMsgData(cxm)
   IF ((ie.class = IECLASS_RAWMOUSE) AND mm) THEN DivertCxMsg(cxm, co, co)
ENDPROC

PROC initbroker()

DEF cxfunc

   IF broker_mp := CreateMsgPort()
      cxsigflag := Shl(1, broker_mp.sigbit)

           	signal:=AllocSignal(-1)
  		cxsigflag:=Shl(1, signal)
  		task:=FindTask(NIL)
  		cosignal:=CxSignal(task, signal)

      IF broker:=CxBroker(
           [NB_VERSION, 0, 'Hubble',
           'Hubble V1.1b', 'First E Lens!',
            NBU_UNIQUE OR NBU_NOTIFY, 0,
            0,
	    0, broker_mp, 0]:newbroker, NIL)

         	cxfunc := eCodeCxCustom({cxfunction})
 		customcxobj:=CxCustom(cxfunc, 0)

                 AttachCxObj(broker, customcxobj)
  		AttachCxObj(customcxobj, cosignal)
  		ActivateCxObj(broker, TRUE)
      ENDIF
   ENDIF
ENDPROC

VOID '$VER: Hubble 1.1b (18.05.96) by Marco Talamelli'

PROC main()

IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
 IF iffbase :=OpenLibrary ('iff.library',21)
   IF cxbase := OpenLibrary ('commodities.library', 37)

         IF gadtoolsbase := OpenLibrary ('gadtools.library', 37)

            IF setupscreen()

               getoffsets()
               wintop := topoff
               IF (scr.height > 300) THEN innerheight:= Shl(innerheight,1)
               IF openwin()
		    allocbm()
			refresh()
                      initbroker()
                        processmsg()
			 IF broker THEN DeleteCxObjAll(broker)
   			 IF signal THEN FreeSignal(signal)
		   	 IF visualinfo THEN FreeVisualInfo(visualinfo)
		   	 IF scr THEN UnlockPubScreen(NIL, scr)
                  closewin()
               ENDIF
            ENDIF
            CloseLibrary(gadtoolsbase)
      ENDIF
      CloseLibrary(cxbase)
   ENDIF
  CloseLibrary(iffbase)
 ENDIF
 CloseLibrary(reqtoolsbase)
ENDIF
ENDPROC
