/* dto.e
 * Come racchiudere un oggetto DataType in una finestra Intuition
 * Scritto da M. Talamelli 24-09-95
 */

MODULE 	'dos/dos','exec/ports',
	'datatypes',
	'datatypes/datatypesclass',
	'datatypes/pictureclass',
	'intuition/intuition',
	'intuition/icclass',
	'intuition/classes',
	'intuition/screens',
	'intuition/gadgetclass',
	'graphics/displayinfo',
	'graphics/modeid',
	'libraries/asl','asl',
	'utility',
	'utility/tagitem'

CONST	IDCMP_FLAGS=IDCMP_CLOSEWINDOW OR IDCMP_VANILLAKEY OR IDCMP_IDCMPUPDATE

PROC main()

DEF 	win:PTR TO window,lock,oldlock,dto:PTR TO object,scr:PTR TO screen,
 	name,class,code,iaddress,modeid=INVALID_ID,nomwidth,nomheight,
	usescreen=FALSE,dtf:dtframebox,fri:frameinfo,done=TRUE,response,
	message:PTR TO intuimessage,fr:PTR TO filerequester

	datatypesbase:=OpenLibrary('datatypes.library',39)
  	utilitybase:= OpenLibrary('utility.library',39)
	aslbase:=OpenLibrary('asl.library',37)

	    /* Prende un oggetto DataType */

 fr:=AllocAslRequest(ASL_FILEREQUEST,
			[ASLFR_TITLETEXT,'Select a File...',
			ASLFR_POSITIVETEXT,'Show',
			ASLFR_REJECTICONS,TRUE,TAG_DONE])

WHILE	response:=AslRequest(fr,NIL)
	lock:=Lock(fr.drawer,ACCESS_READ)
       oldlock:=CurrentDir(lock)

  	dto := NewDTObjectA(fr.file,TAG_DONE)
	    
		/* Prende informazioni dall'oggetto */
		GetDTAttrsA(dto,[DTA_OBJNAME,{name},
				DTA_NOMINALHORIZ,{nomwidth},
				DTA_NOMINALVERT,{nomheight},
				PDTA_MODEID,{modeid},
				TAG_DONE])

	/* Mostra qualsiasi informazione noi abbiamo ottenuto */
	IF (name)
	request('aperto \s\nmodo ID $\z\h[8]\nlarghezza nominale \d, altezza \d\n','OK',[name,modeid,nomwidth,nomheight])
	ENDIF
	dtf:=New(SIZEOF dtframebox)
	fri:=New(SIZEOF frameinfo)
	/* Chiedere all'oggetto che tipo di ambiente ha bisogno */
		dtf.methodid:=DTM_FRAMEBOX
			dtf.frameinfo:=fri
			dtf.contentsinfo:=fri
		dtf.sizeframeinfo:=SIZEOF frameinfo

		IF DoDTMethodA(dto,NIL,NIL,dtf)
		   request('PropertyFlags : $\h\n'+
		    'RedBits       : $\h\n'+
		    'GreenBits     : $\h\n'+
		    'BlueBits      : $\h\n'+
		    'Width         : \d\n'+
		    'Height        : \d\n'+
		    'Depth         : \d\n'+
		    'Screen        : $\h\n'+
		    'ColorMap      : $\h\n','OK',
				[fri.propertyflags,
				fri.redbits,
				fri.greenbits,
				fri.bluebits,
				fri.width,
				fri.height,
				fri.depth,
				fri.screen,
				fri.colormap])

		    IF ((fri.propertyflags AND DIPF_IS_HAM) OR
			(fri.propertyflags AND DIPF_IS_EXTRAHALFBRITE))

			request('HAM o ExtraHalfBrite','Continua',NIL)
			usescreen:=TRUE
		    ENDIF

		    IF ((fri.propertyflags = 0) AND (modeid AND $800) AND (modeid <> INVALID_ID))

			request('ModeID=$\z\h[8]\n','OK',modeid)
			usescreen:=TRUE
		    ENDIF
		ELSE
		   request('non posso ottenere informazioni','Continua',NIL)
		ENDIF
		IF (usescreen)
		    request('questo oggetto richiede uno schermo privato','OK',NIL)

		ELSEIF scr:= LockPubScreen(NIL)

		    nomwidth:= (IF nomwidth THEN nomwidth ELSE 600)
		    nomheight:= (IF nomheight THEN nomheight ELSE 175)

		    IF win:=OpenWindowTagList(NIL,
					     [WA_INNERWIDTH,	nomwidth,
					      WA_INNERHEIGHT,	nomheight,
					      WA_TITLE,		name,
					      WA_IDCMP,		IDCMP_FLAGS,
					      WA_DRAGBAR,	TRUE,
					      WA_DEPTHGADGET,	TRUE,
					      WA_CLOSEGADGET,	TRUE,
					      WA_AUTOADJUST,	TRUE,
					      WA_SIMPLEREFRESH,	TRUE,
					      WA_BUSYPOINTER,	TRUE,
					      WA_ACTIVATE,	TRUE,
					      TAG_DONE])

		/* Assegna le dimensioni dell'oggetto DataType. */
			SetDTAttrsA(dto,NIL,NIL,
				   [GA_LEFT,	win.borderleft,
				    GA_TOP,	win.bordertop,
				    GA_WIDTH,	win.width - win.borderleft - win.borderright,
				    GA_HEIGHT,	win.height - win.bordertop - win.borderbottom,
				    ICA_TARGET,	ICTARGET_IDCMP,
				    TAG_DONE])

			/* Aggiunge l'oggetto alla finestra */
			AddDTObject(win,NIL,dto,-1)

			/* Rinfresca l'oggetto DataType */
			RefreshDTObjectA(dto,win,NIL,NIL)
	WHILE done
	    Wait(Shl(1, win.userport.sigbit))

	    WHILE message:=GetMsg(win.userport)

		class:=message.class
		iaddress:=message.iaddress
		code:=message.code

		SELECT class
		    CASE IDCMP_CLOSEWINDOW
			done:=FALSE
		    CASE IDCMP_VANILLAKEY
			SELECT code
			  CASE "Q"
				done:=FALSE
			  CASE "q"
				done:=FALSE
			  CASE 27
				done:=FALSE
			ENDSELECT
		    CASE IDCMP_IDCMPUPDATE
			IF (GetTagData(DTA_BUSY, 0, iaddress))
			   SetWindowPointerA(win,[WA_BUSYPOINTER, TRUE, TAG_DONE])
   			ELSE
			   SetWindowPointerA(win,[WA_POINTER, NIL, TAG_DONE])
			ENDIF 
			IF GetTagData(DTA_SYNC, 0,iaddress)
				  RefreshDTObjectA(dto, win, NIL, NIL) 
			ENDIF
		ENDSELECT
		ReplyMsg(message)
	    ENDWHILE
	 ENDWHILE
Dispose(dtf)
Dispose(fri)
			RemoveDTObject(win, dto)
			CloseWindow(win)
			ELSE
			  request('non posso aprire la finestra!!','OK',NIL)
			ENDIF		
		    UnlockPubScreen (NIL, scr)
		ELSE
		   request('could lock default public screen\n','OK',NIL)
		ENDIF
		DisposeDTObject (dto)
	done:=TRUE
	   CurrentDir(oldlock)
		UnLock(lock)
ENDWHILE
	FreeAslRequest(fr)
	    CloseLibrary(utilitybase)
	    CloseLibrary(datatypesbase)
	    CloseLibrary(aslbase)
ENDPROC

PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,0,body,gadgets],0,args)
