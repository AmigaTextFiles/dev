
OPT OSVERSION=37

MODULE 'gadtools','libraries/gadtools','intuition/intuition','gcc/imagegadgets',
       'intuition/screens', 'intuition/gadgetclass', 'graphics/text','exec/memory'

ENUM NONE,NOCONTEXT,NOGADGET,NOWB,NOVISUAL,OPENGT,NOWINDOW,NOMENUS

DEF pause=0,win:PTR TO window,glist,infos:PTR TO gadget,scr:PTR TO screen,offx,offy,tattr
DEF ip1,cip1,ip2,cip2,image1: image,image2: image

PROC setupscreen()
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN OPENGT
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN NOWB
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN NOVISUAL
  offy:=scr.wbortop+Int(scr.rastport+58)-10
  tattr:=['topaz.font',8,0,0]:textattr
ENDPROC

PROC closedownscreen()
  IF visual THEN FreeVisualInfo(visual)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC

PROC init_images()
ip1:=[$0000,$0200,$0000,$0600,$0000,$0600,$0FE0,$0600,
       $0040,$0600,$008F,$E600,$0100,$4600,$0200,$8600,
       $0401,$0600,$0FE2,$0600,$0004,$0600,$000F,$E600,
       $0000,$0600,$0000,$0600,$7FFF,$FE00,
       $FFFF,$FC00,$C000,$0000,$C000,$0000,$C000,$0000,
       $C000,$0000,$C000,$0000,$C000,$0000,$C000,$0000,
       $C000,$0000,$C000,$0000,$C000,$0000,$C000,$0000,
       $C000,$0000,$C000,$0000,$8000,$0000]:INT
cip1:=AllocVec(120,MEMF_CHIP); CopyMemQuick(ip1,cip1,120)
image1.leftedge:=0
image1.topedge:=0
image1.width:=23
image1.height:=15
image1.depth:=3
image1.imagedata:=cip1
image1.planepick:=$0003
image1.planeonoff:=$0000
image1.nextimage:=NIL
ip2:=[$FFFF,$FC00,$FFFF,$F800,$FFFF,$F800,$FFFF,$F800,
       $FFFF,$F800,$FFFF,$F800,$FFFF,$F800,$FFFF,$F800,
       $FFFF,$F800,$FFFF,$F800,$FFFF,$F800,$FFFF,$F800,
       $FFFF,$F800,$FFFF,$F800,$8000,$0000,
       $0000,$0200,$3FFF,$FE00,$3FFF,$FE00,$301F,$FE00,
       $3FBF,$FE00,$3F70,$1E00,$3EFF,$BE00,$3DFF,$7E00,
       $3BFE,$FE00,$301D,$FE00,$3FFB,$FE00,$3FF0,$1E00,
       $3FFF,$FE00,$3FFF,$FE00,$7FFF,$FE00]:INT
cip2:=AllocVec(120,MEMF_CHIP); CopyMemQuick(ip2,cip2,120)
image2.leftedge:=0
image2.topedge:=0
image2.width:=23
image2.height:=15
image2.depth:=3
image2.imagedata:=cip2
image2.planepick:=$0003
image2.planeonoff:=$0000
image2.nextimage:=NIL
ENDPROC

PROC remove_images()
 IF cip1 THEN FreeVec(cip1)
 IF cip2 THEN FreeVec(cip2)
ENDPROC

PROC set_text(gad,text)
 Gt_SetGadgetAttrsA(gad,win,NIL,[GTTX_TEXT,text,NIL])
ENDPROC

PROC mainloop()
DEF disk1,disk2,disk3,hide,textgad
DEF id1: PTR TO image,id2: PTR TO image,text[20]: STRING
DEF mes:PTR TO intuimessage,type,ende=FALSE

  id1:=image1; id2:=image2; StrCopy(text,'Welcome!',ALL)
  IF (g:=CreateContext({glist}))=NIL THEN RETURN NOCONTEXT
  gcc_InitImageGadgets()
  gcc_InitDiskImage(1,0); gcc_InitDiskImage(0,1)
  IF (disk1:=gcc_CreateGetFileA(1,60,20,0))=-1 THEN RETURN NOGADGET
  IF (disk2:=gcc_CreateGetFileA(0,20,20,0))=-1 THEN RETURN NOGADGET
  IF (disk3:=gcc_InstallGetFileA(2,110,20,0,0))=-1 THEN RETURN NOGADGET
  IF (hide:=gcc_CreateGadgetA(177,20,id1,id2,0))=-1 THEN RETURN NOGADGET
  IF (g:=textgad:=CreateGadgetA(TEXT_KIND,g,
    [offx+14,offy+45,186,11,'',tattr,17,0,visual,0]:newgadget,
    [GTTX_TEXT,text,
     GTTX_BORDER,1,
     NIL]))=NIL THEN RETURN NOGADGET
  IF (win:=OpenWindowTagList(NIL,
    [WA_LEFT,112,
     WA_TOP,67,
     WA_WIDTH,offx+214,
     WA_HEIGHT,offy+66,
     WA_IDCMP,$24C077E,
     WA_FLAGS,$100E,
     WA_TITLE,'ImageGadgets',
     WA_CUSTOMSCREEN,scr,
     WA_GADGETS,glist,
     NIL]))=NIL THEN RETURN NOWINDOW
  DrawBevelBoxA(win.rport,offx+14,offy+17,132,23,
    [GT_VISUALINFO,visual,NIL])
  Gt_RefreshWindow(win,NIL)
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(win.userport)
      type:=mes.class
      IF (type=IDCMP_GADGETDOWN) OR (type=IDCMP_GADGETUP)
        infos:=mes.iaddress
        IF infos=disk1
         set_text(textgad,'KIND: GetFile TYPE: 1')
        ENDIF
        IF infos=disk2
         set_text(textgad,'KIND: GetFile TYPE: 0')
        ENDIF
        IF infos=disk3
         set_text(textgad,'KIND: GetFile TYPE: 2')
        ENDIF
        IF infos=hide
         IF pause=0 THEN pause:=1 ELSE pause:=0
         gcc_SetGadgetAttrsA(disk2,win,GA_DISABLED,pause)
         gcc_SetGadgetAttrsA(disk1,win,GA_DISABLED,pause)
         gcc_SetGadgetAttrsA(disk3,win,GA_DISABLED,pause)
         IF pause=0 THEN set_text(textgad,'gadgets enabled') ELSE set_text(textgad,'gadgets disabled')
        ENDIF
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(win)
        Gt_EndRefresh(win,TRUE)
        type:=0
      ELSEIF type=IDCMP_CLOSEWINDOW
        ende:=TRUE
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      WaitPort(win.userport)
    ENDIF
  UNTIL ende=TRUE
  IF win THEN CloseWindow(win)
  IF glist THEN FreeGadgets(glist)
  gcc_RemoveDiskImage(ALL)
ENDPROC

PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er
    erlist:=['get context','create gadget','lock wb','get visual infos',
      'open "gadtools.library" v37+','open window','create menus']
    EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[er-1]])
  ENDIF
ENDPROC er

PROC main()
  IF reporterr(setupscreen())=0
   init_images(); mainloop()
  ENDIF
  remove_images(); closedownscreen()
ENDPROC

