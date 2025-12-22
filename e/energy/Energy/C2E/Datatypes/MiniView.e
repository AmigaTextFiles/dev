/* MiniWiew.e
 * Come visualizzare un oggetto DataType in una finestra Intuition
 * Tradotto da dt3b.c di AmigaMagazine  da M. Talamelli 28-08-95
 */

OPT PREPROCESS

MODULE 	'exec/ports',
	'utility',
	'utility/tagitem',
	'dos/dos',
	'datatypes',
	'datatypes/datatypesclass',
	'datatypes/pictureclass',
	'intuition/intuition',
	'intuition/icclass',
	'intuition/classes',
	'intuition/screens',
	'intuition/gadgetclass',
	'reqtools',
	'libraries/reqtools',
	'graphics/modeid',
	'graphics/displayinfo'

#define PROPH	(window.bordertop -4)
#define PROPW	(PROPH*2)

ENUM ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL

PROC main() HANDLE

DEF 	window:PTR TO window,
	dto:PTR TO object,
	pho:PTR TO object,
	pvo:PTR TO object,
	imsg:PTR TO intuimessage,
	lock,class,tg,code,
	oldlock,
	name[34]:STRING,
	dtf:dtframebox,
	fri:frameinfo,
	tstate:PTR TO tagitem,
	tags:PTR TO tagitem,
	tag:PTR TO tagitem,
	tidata,fname,
	fr:PTR TO rtfilerequester,
	scr:PTR TO screen,
	done=TRUE,
	modeid=INVALID_ID,
	nomwidth,
	nomheight,
	usescreen=FALSE

	datatypesbase:=OpenLibrary('datatypes.library',0)
	utilitybase:=OpenLibrary('utility.library',0)
	reqtoolsbase:=OpenLibrary('reqtools.library',37)

 fr:=RtAllocRequestA(RT_FILEREQ, NIL)

WHILE	RtFileRequestA(fr, name, 'Select a file...',0)
	lock:=Lock(fr.dir,ACCESS_READ)
       oldlock:=CurrentDir(lock)
	fname:=name

  	dto := NewDTObjectA(fname,TAG_DONE)
	    
		/* Prende informazioni dall'oggetto */
		GetDTAttrsA(dto,[DTA_OBJNAME,{fname},
				DTA_NOMINALHORIZ,{nomwidth},
				DTA_NOMINALVERT,{nomheight},
				PDTA_MODEID,{modeid},
				TAG_DONE])

	/* Mostra le informazioni che abbiamo ottenuto */
	IF (fname)
	RtEZRequestA('aperto \s\nmodo ID $\z\h[8]\nlarghezza nominale \d, altezza \d\n','OK',NIL,[fname,modeid,nomwidth,nomheight],NIL)
	ENDIF
	dtf:=New(SIZEOF dtframebox)
	fri:=New(SIZEOF frameinfo)
	/* Chiedere all'oggetto che tipo di ambiente ha bisogno */
		dtf.methodid:=DTM_FRAMEBOX
			dtf.frameinfo:=fri
			dtf.contentsinfo:=fri
		dtf.sizeframeinfo:=SIZEOF frameinfo

		IF DoDTMethodA(dto,NIL,NIL,dtf)
		   RtEZRequestA('PropertyFlags : $\h\n'+
		    'RedBits       : $\h\n'+
		    'GreenBits     : $\h\n'+
		    'BlueBits      : $\h\n'+
		    'Width         : \d\n'+
		    'Height        : \d\n'+
		    'Depth         : \d\n'+
		    'Screen        : $\h\n'+
		    'ColorMap      : $\h\n','OK',NIL,
				[fri.propertyflags,
				fri.redbits,
				fri.greenbits,
				fri.bluebits,
				fri.width,
				fri.height,
				fri.depth,
				fri.screen,
				fri.colormap],NIL)

		    IF ((fri.propertyflags AND DIPF_IS_HAM) OR
			(fri.propertyflags AND DIPF_IS_EXTRAHALFBRITE))

			RtEZRequestA('HAM o ExtraHalfBrite','Continua',NIL,NIL,NIL)
			usescreen:=TRUE
		    ENDIF

		    IF ((fri.propertyflags = 0) AND (modeid AND $800) AND (modeid <> INVALID_ID))

			RtEZRequestA('ModeID=$\z\h[8]\n','OK',NIL,[modeid],NIL)
			usescreen:=TRUE
		    ENDIF
		ELSE
		   RtEZRequestA('non posso ottenere informazioni','Continua',NIL,NIL,NIL)
		ENDIF
		IF (usescreen)
		    RtEZRequestA('questo oggetto richiede uno schermo privato','OK',NIL,NIL,NIL)

		ELSEIF scr:= LockPubScreen(NIL)

		    nomwidth:= (IF nomwidth THEN nomwidth ELSE scr.width)
		    nomheight:= (IF nomheight THEN nomheight ELSE scr.height-scr.barheight)

		IF window:=OpenWindowTagList(NIL,
					[WA_INNERWIDTH,	nomwidth,
					WA_INNERHEIGHT,	nomheight,
					WA_IDCMP,	IDCMP_CLOSEWINDOW OR
							IDCMP_VANILLAKEY OR
							IDCMP_IDCMPUPDATE,
					WA_TITLE,'MiniWiew - DataTypes example',
					WA_CLOSEGADGET,		TRUE,
					WA_DEPTHGADGET,		TRUE,
					WA_DRAGBAR,		TRUE,
					WA_AUTOADJUST,		TRUE,
					WA_SIMPLEREFRESH,	TRUE,
					WA_BUSYPOINTER,		TRUE,
					WA_ACTIVATE,		TRUE,
					WA_MINWIDTH,		70,
					WA_MINHEIGHT,		70,
					TAG_DONE])
         SetDTAttrsA(dto,NIL,NIL,
                     [GA_LEFT,    window.borderleft,
                     GA_TOP,     window.bordertop,
                     GA_WIDTH,   window.width - window.borderleft - window.borderright - PROPW,
                     GA_HEIGHT,  window.height - window.bordertop - window.borderbottom - PROPH,
                     ICA_TARGET, ICTARGET_IDCMP,
                     TAG_DONE] )

            pvo:=NewObjectA(NIL,'propgclass',
                        [GA_LEFT,       window.width-window.borderright-PROPW,
                        GA_TOP,        window.bordertop,
                        GA_HEIGHT,     window.height - window.bordertop - window.borderbottom - PROPH,
                        GA_WIDTH,PROPW,
			PGA_NEWLOOK,	TRUE,
     			GA_BOTTOMBORDER,TRUE,
     			PGA_BORDERLESS,	DRIF_NEWLOOK,
                        ICA_TARGET,    dto,
                        ICA_MAP,       [PGA_TOP,	DTA_TOPVERT,
		PGA_VISIBLE,	DTA_VISIBLEVERT,
		PGA_TOTAL,	DTA_TOTALVERT,
		TAG_DONE,	NIL]:tagitem,
                        TAG_DONE])

               pho:=NewObjectA(NIL,'propgclass',
                        [GA_LEFT,       window.borderleft,
                        GA_TOP,        window.height - window.borderbottom - PROPH,
                        GA_HEIGHT,     PROPH,
                        GA_WIDTH,      window.width - window.borderleft - window.borderright - PROPW,
                        PGA_NEWLOOK,   TRUE,
     			GA_BOTTOMBORDER,TRUE,
     			PGA_BORDERLESS,	DRIF_NEWLOOK,
                        PGA_FREEDOM,	FREEHORIZ,
                        ICA_TARGET,    dto,
                        ICA_MAP,       [PGA_TOP,	DTA_TOPHORIZ,
		PGA_VISIBLE,	DTA_VISIBLEHORIZ,
		PGA_TOTAL,	DTA_TOTALHORIZ,
		TAG_DONE,	NIL]:tagitem,
                        TAG_DONE])

                  AddGadget(window,pvo,-1)
                  AddGadget(window,pho,-1)
                  AddDTObject(window,NIL,dto,-1)

                  RefreshDTObjectA(dto,window,NIL,NIL)
                  RefreshGadgets(pvo,window,NIL)
   WHILE done

      Wait(Shl(1, window.userport.sigbit))

      WHILE (imsg:=GetMsg(window.userport))
		class:=imsg.class
		code:=imsg.code
         SELECT class

            CASE IDCMP_IDCMPUPDATE
               tstate:=tags:=imsg.iaddress
               WHILE (tag:=NextTagItem({tstate}))
                  tidata:=tag.data
			tg:=tag.tag
                  SELECT tg
                     CASE DTA_BUSY
				    IF (tidata)
                                       SetWindowPointerA(window,[WA_BUSYPOINTER,TRUE,TAG_DONE])
                                    ELSE
                                       SetWindowPointerA(window,[WA_POINTER,NIL,TAG_DONE])
                                    ENDIF
                     CASE DTA_SYNC
				    RefreshDTObjectA(dto,window,NIL,NIL)
                     CASE DTA_TITLE
                                    SetWindowTitles(window,tag.data,-1)
                     CASE DTA_TOPVERT
                                    SetGadgetAttrsA(pvo,window,NIL,[PGA_TOP,tag.data,TAG_DONE])
                     CASE DTA_TOTALVERT
                                    SetGadgetAttrsA(pvo,window,NIL,[PGA_TOTAL,tag.data,TAG_DONE])
                     CASE DTA_VISIBLEVERT
                                    SetGadgetAttrsA(pvo,window,NIL,[PGA_VISIBLE,tag.data,TAG_DONE])
                     CASE DTA_TOPHORIZ
                                    SetGadgetAttrsA(pho,window,NIL,[PGA_TOP,tag.data,TAG_DONE])
                     CASE DTA_TOTALHORIZ
                                    SetGadgetAttrsA(pho,window,NIL,[PGA_TOTAL,tag.data,TAG_DONE])
                     CASE DTA_VISIBLEHORIZ
                                    SetGadgetAttrsA(pho,window,NIL,[PGA_VISIBLE,tag.data,TAG_DONE])
                  ENDSELECT
               ENDWHILE
	    CASE IDCMP_VANILLAKEY
			SELECT code
			  CASE "Q"
				done:=FALSE
			  CASE "q"
				done:=FALSE
			  CASE 27
				done:=FALSE
			ENDSELECT
            CASE IDCMP_CLOSEWINDOW
               done:=FALSE
         ENDSELECT
         ReplyMsg(imsg)
      ENDWHILE
   ENDWHILE
Dispose(dtf)
Dispose(fri)
               		RemoveDTObject(window,dto)
                  	RemoveGadget(window,pvo)
                  	RemoveGadget(window,pho)
	CloseWindow(window)
			ELSE
			  RtEZRequestA('could open the window!!','OK',NIL,NIL,NIL)
			ENDIF
	  UnlockPubScreen(NIL, scr)
		ELSE
		   RtEZRequestA('could lock default public screen\n','OK',NIL,NIL,NIL)
		ENDIF
                  DisposeObject(pho)
               DisposeObject(pvo)
            DisposeDTObject(dto)
	   CurrentDir(oldlock)
		UnLock(lock)
done:=TRUE
ENDWHILE
	RtFreeRequest(fr)
EXCEPT

IF datatypesbase THEN CloseLibrary(datatypesbase)
IF utilitybase THEN CloseLibrary(utilitybase)
IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)

SELECT exception
	CASE ERR_LIB
		WriteF('could open the library!\n')
ENDSELECT
ENDPROC
