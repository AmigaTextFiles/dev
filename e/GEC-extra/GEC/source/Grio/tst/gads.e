

MODULE 'exec/ports'
MODULE 'dos/dos'
MODULE 'intuition/intuition'
MODULE 'gadtools','libraries/gadtools'
MODULE 'graphics/rastport','graphics/text'
MODULE 'diskfont'



ENUM OK,ERR_LIB,ERR_GADS,ERR_WIN


RAISE ERR_LIB  IF OpenLibrary()       = NIL
RAISE ERR_GADS IF CreateContext()     = NIL
RAISE ERR_GADS IF CreateGadgetA()     = NIL
RAISE ERR_WIN  IF OpenWindowTagList() = NIL



DEF gad:PTR TO gadget,ng:PTR TO newgadget,win:PTR TO window
DEF vi,text


PROC main() HANDLE

DEF glist,scr,gadid,type,minute,mes:PTR TO intuimessage
DEF ds:datestamp,font

   glist:=gad:=win:=vi:=scr:=type:=NIL

   diskfontbase:=OpenLibrary('diskfont.library',0)
   text:=['ibm.font',8,FS_NORMAL,FPF_DESIGNED]:textattr
   font:=OpenDiskFont(text)
   IF font = NIL THEN PutStr('zero\n')
   gadtoolsbase:=OpenLibrary('gadtools.library',37)
   scr:=LockPubScreen(NIL)
   vi:=GetVisualInfoA(scr,[NIL])
   gad:=CreateContext({glist})
   ng:=[25,30,100,14,0,text,1,PLACETEXT_IN,vi,0]:newgadget
   makebutt('fuck')
   makebutt('Off')
   makebutt('_Blaaa')
   makecyle(['To ty','Co ty','Kto ty',NIL],1)
   makebutt('check')
   makebutt('co')
   win:=OpenWindowTagList(0,[WA_LEFT,100,WA_TOP,60,
            WA_WIDTH,150,WA_HEIGHT,135,
            WA_TITLE,'Grio',
            WA_GADGETS,glist,
            WA_DRAGBAR,TRUE,
            WA_DEPTHGADGET,TRUE,
            WA_CLOSEGADGET,TRUE,
            WA_SIMPLEREFRESH,TRUE,
            WA_REPORTMOUSE,TRUE,
            WA_ACTIVATE,TRUE,
            WA_RMBTRAP,TRUE,
            WA_ZOOM,[100,60,150,11]:INT,
            WA_IDCMP,IDCMP_CLOSEWINDOW+
               IDCMP_REFRESHWINDOW+
               IDCMP_GADGETUP+
               IDCMP_INTUITICKS+
               IDCMP_MOUSEMOVE,NIL])


   Gt_RefreshWindow(win,NIL)

   bevel()

   DateStamp(ds)

   minute:=ds.minute+1

   WHILE type<>IDCMP_CLOSEWINDOW
      IF (mes:=Gt_GetIMsg(win.userport))
         type:=mes.class
         gad:=mes.iaddress
         gadid:=gad.gadgetid
         SELECT type
             CASE IDCMP_GADGETUP
                 SELECT gadid
        	    CASE 1
			PrintF('gadget "fuck" clicked\n')
	            CASE 2
            		PrintF('gadget "Off" clicked\n')
	            CASE 3
		        PrintF('gadget "Blaaa" clicked\n')
                    CASE 4
			gadid:=mes.code
			SELECT gadid
				CASE 0 ; gadid:='To ty'
				CASE 1 ; gadid:='Co ty'
				CASE 2 ; gadid:='Kto ty'
			ENDSELECT
                        PrintF('cycle gadget "\s"\n',gadid)
	            CASE 5
            		PrintF('gadget "check" clicked\n')
	            CASE 6
            		PrintF('gadget "co" clicked\n')
            	 ENDSELECT
             CASE IDCMP_REFRESHWINDOW
            	Gt_BeginRefresh(win)
                bevel()
            	Gt_EndRefresh(win,TRUE)
            	PrintF('refreshed\n')
             CASE IDCMP_MOUSEMOVE
                PrintF('mouse moving\n')
             CASE IDCMP_INTUITICKS
                DateStamp(ds)
                IF minute=ds.minute THEN type:=IDCMP_CLOSEWINDOW
         ENDSELECT
         Gt_ReplyIMsg(mes)
      ELSE
         WaitPort(win.userport)
      ENDIF
  ENDWHILE


EXCEPT DO
IF diskfontbase THEN CloseLibrary(diskfontbase)
IF win THEN CloseWindow(win)
IF scr THEN UnlockPubScreen(NIL,scr)
IF vi THEN FreeVisualInfo(vi)
IF glist THEN FreeGadgets(glist)
IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
IF font THEN CloseFont(font)
IF exception
   SELECT exception
   CASE ERR_LIB
             PrintF('can\at open library\n')
   CASE ERR_GADS
        PrintF('error in create gadgets structure\n')
   CASE ERR_WIN
        PrintF('unable to open window\n')
   ENDSELECT
ENDIF

ENDPROC




PROC makebutt(name)

   ng.gadgettext:=name
   gad:=CreateGadgetA(BUTTON_KIND,gad,ng,[GT_UNDERSCORE,"_",NIL])
   ng.topedge:=ng.topedge+16
   ng.gadgetid:=ng.gadgetid+1

ENDPROC gad



PROC makecyle(names,activ=0)

   ng.gadgettext:=''
   gad:=CreateGadgetA(CYCLE_KIND,gad,ng,
        [GTCY_LABELS,names,GTCY_ACTIVE,activ,NIL])
   ng.topedge:=ng.topedge+16
   ng.gadgetid:=ng.gadgetid+1


ENDPROC gad


PROC bevel()
DEF itext:PTR TO intuitext

   DrawBevelBoxA(win.rport,10,20,130,110,
                            [GTBB_FRAMETYPE,BBFT_RIDGE,
                             GT_VISUALINFO,vi,
                                        GTBB_RECESSED,TRUE,NIL])

   itext:=[1,0,RP_JAM2,32,17,text,' Bevel Box ',0]:intuitext

   PrintIText(win.rport,itext,0,0)

ENDPROC
