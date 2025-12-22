/* dt3b.e
 * Come racchiudere un oggetto DataType in una finestra Intuition
 * Tradotto da dt3b.c di AmigaMagazine  da M. Talamelli 28-08-95
 */

OPT PREPROCESS

MODULE 	'exec/ports',
	'datatypes',
	'datatypes/datatypesclass',
	'intuition/intuition',
	'intuition/icclass',
	'intuition/classes',
	'intuition/gadgetclass',
	'utility',
	'utility/tagitem'

#define PROPH	(w.bordertop -2)
#define PROPW	(PROPH*2)

DEF 	w:PTR TO window,
	dto:PTR TO object,
	pho:PTR TO object,
	pvo:PTR TO object,
	imsg:PTR TO intuimessage,
	tstate:PTR TO tagitem,tags:PTR TO tagitem,tag:PTR TO tagitem,
	tidata,myargs:PTR TO LONG,rdargs,
	done=TRUE,
	vertmapping[8]:ARRAY OF tagitem,horizmapping[8]:ARRAY OF tagitem

PROC main()

IF rdargs:=ReadArgs('FILE/A',myargs,NIL)

vertmapping:=[PGA_TOP,	DTA_TOPVERT,
		PGA_VISIBLE,	DTA_VISIBLEVERT,
		PGA_TOTAL,	DTA_TOTALVERT,
		TAG_DONE,	NIL]

horizmapping:=[PGA_TOP,	DTA_TOPHORIZ,
		PGA_VISIBLE,	DTA_VISIBLEHORIZ,
		PGA_TOTAL,	DTA_TOTALHORIZ,
		TAG_DONE,	NIL]



	IF (datatypesbase:=OpenLibrary('datatypes.library',0))
	utilitybase:=OpenLibrary('utility.library',0)
		IF (w:=OpenWindowTagList(NIL,
					[WA_IDCMP,	IDCMP_CLOSEWINDOW OR
							IDCMP_IDCMPUPDATE,
					WA_TITLE,'dt3b - DataTypes example',
					WA_CLOSEGADGET,		TRUE,
					WA_DEPTHGADGET,		TRUE,
					WA_DRAGBAR,		TRUE,
					WA_NOCAREREFRESH,	TRUE,
					WA_AUTOADJUST,		TRUE,
					WA_MINWIDTH,		50,
					WA_MINHEIGHT,		50,
					WA_WIDTH,		500,
					WA_HEIGHT,		250,
					TAG_DONE]))

         IF (dto:=NewDTObjectA(myargs[0],
                     [GA_LEFT,    w.borderleft,
                     GA_TOP,     w.bordertop,
                     GA_WIDTH,   w.width - w.borderleft - w.borderright - PROPW,
                     GA_HEIGHT,  w.height - w.bordertop - w.borderbottom - PROPH,
                     ICA_TARGET, ICTARGET_IDCMP,
                     TAG_DONE] ))

            IF (pvo:=NewObjectA(NIL,'propgclass',
                        [GA_LEFT,       w.width-w.borderright-PROPW,
                        GA_TOP,        w.bordertop,
                        GA_HEIGHT,     w.height - w.bordertop - w.borderbottom - PROPH,
                        GA_WIDTH,PROPW,
			PGA_NEWLOOK,	TRUE,
                        ICA_TARGET,    dto,
                        ICA_MAP,       vertmapping,
                        TAG_DONE] ))
               IF (pho:=NewObjectA(NIL,'propgclass',
                        [GA_LEFT,       w.borderleft,
                        GA_TOP,        w.height - w.borderbottom - PROPH,
                        GA_HEIGHT,     PROPH,
                        GA_WIDTH,      w.width - w.borderleft - w.borderright - PROPW,
                        PGA_NEWLOOK,   TRUE,
                        PGA_FREEDOM,	FREEHORIZ,
                        ICA_TARGET,    dto,
                        ICA_MAP,       horizmapping,
                        TAG_DONE] ))

                  AddGadget(w,pvo,-1)
                  AddGadget(w,pho,-1)
                  AddDTObject(w,NIL,dto,-1)

                  RefreshDTObjectA(dto,w,NIL,NIL)
                  RefreshGadgets(pvo,w,NIL)

                  dojob()

                  RemoveGadget(w,pvo)
                  RemoveGadget(w,pho)
                  DisposeObject(pho)
                  ENDIF
               DisposeObject(pvo)
               RemoveDTObject(w,dto)
            ENDIF
            DisposeDTObject(dto)
         ENDIF
			CloseWindow(w)
		ENDIF
		CloseLibrary(datatypesbase)
	ENDIF
FreeArgs(rdargs)
ELSE
WriteF('No args! usage <NAMEPROG> NAME/A\n')
ENDIF
ENDPROC


PROC dojob()
DEF class,tg
   WHILE (done)

      Wait(Shl(1, w.userport.sigbit))

      WHILE (imsg:=GetMsg(w.userport))
		class:=imsg.class
         SELECT class

            CASE IDCMP_IDCMPUPDATE
               tstate:=tags:=imsg.iaddress
               WHILE (tag:=NextTagItem({tstate}))
                  tidata:=tag.data
			tg:=tag.tag
                  SELECT tg
                     CASE DTA_BUSY
				    IF (tidata)
                                       SetWindowPointerA(w,[WA_BUSYPOINTER,TRUE,TAG_DONE])
                                    ELSE
                                       SetWindowPointerA(w,[WA_POINTER,NIL,TAG_DONE])
                                    ENDIF
                     CASE DTA_ERRORLEVEL
                                    WriteF('Error: Level \d, Num \d, ',tidata,GetTagData(DTA_ERRORNUMBER,NIL,tags))
                                    WriteF('String \s\n',GetTagData(DTA_ERRORSTRING,NIL,tags))
                     CASE DTA_SYNC
				    RefreshDTObjectA(dto,w,NIL,NIL)
                     CASE DTA_TITLE
                                    SetWindowTitles(w,tag.data,-1)
                     CASE DTA_TOPVERT
                                    SetGadgetAttrsA(pvo,w,NIL,[PGA_TOP,tag.data,TAG_DONE])
                     CASE DTA_TOTALVERT
                                    SetGadgetAttrsA(pvo,w,NIL,[PGA_TOTAL,tag.data,TAG_DONE])
                     CASE DTA_VISIBLEVERT
                                    SetGadgetAttrsA(pvo,w,NIL,[PGA_VISIBLE,tag.data,TAG_DONE])
                     CASE DTA_TOPHORIZ
                                    SetGadgetAttrsA(pho,w,NIL,[PGA_TOP,tag.data,TAG_DONE])
                     CASE DTA_TOTALHORIZ
                                    SetGadgetAttrsA(pho,w,NIL,[PGA_TOTAL,tag.data,TAG_DONE])
                     CASE DTA_VISIBLEHORIZ
                                    SetGadgetAttrsA(pho,w,NIL,[PGA_VISIBLE,tag.data,TAG_DONE])

                     DEFAULT
			   WriteF('? tag.tag = \d ',tag.tag)
       			     IF (tag.tag - DTA_DUMMY<1000) THEN;
				WriteF('(DTA_DUMMY + \d) ',tag.tag - DTA_DUMMY)
                             IF (tag.tag - GA_DUMMY<1000)
                                WriteF('(GA_DUMMY + $\z\h[4]) ',tag.tag - GA_DUMMY)
                                WriteF('tag.data = \d\n',tag.data)
                	     ENDIF
                  ENDSELECT
               ENDWHILE

            CASE IDCMP_CLOSEWINDOW
               done:=FALSE
            DEFAULT
               WriteF('COSA?? imsg.class = \d\n',imsg.class)
         ENDSELECT
         ReplyMsg(imsg)
      ENDWHILE
   ENDWHILE
ENDPROC
