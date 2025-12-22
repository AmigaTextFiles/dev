OPT MODULE

MODULE 'intuition/intuition','intuition/screens'
MODULE 'graphics/text','graphics/modeid'
MODULE 'exec/lists'
MODULE 'exec/nodes'
MODULE 'exec/ports'
MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'gadtools'

SET DD_SCREEN_FLAG_LOCK

EXPORT ENUM
  DD_SCREEN_DUMMY=TAG_USER,
  DD_SCREEN,
  DD_SCREEN_PUBNAME,
  DD_SCREEN_TITLE,
  DD_SCREEN_CLONE,
  DD_SCREEN_DRAWINFO,
  DD_SCREEN_VISUALINFO,
  DD_SCREEN_BORDERLEFT,
  DD_SCREEN_BORDERTOP,
  DD_SCREEN_BORDERRIGHT,
  DD_SCREEN_BORDERBOTTOM

EXPORT OBJECT dd_screen
  screen:PTR TO screen
  drawinfo:PTR TO drawinfo
  screenfont:PTR TO textfont
  pubsignal:CHAR
  flags:CHAR
ENDOBJECT

EXPORT PROC getAttr(attrid,storageptr=NIL) OF dd_screen
  DEF result=0
  DEF attr=0
  IF self.screen
    SELECT attrid
    CASE DD_SCREEN
      attr:=self.screen
      result:=TRUE
    CASE DD_SCREEN_DRAWINFO
      attr:=self.drawinfo
      result:=TRUE
    CASE DD_SCREEN_BORDERTOP
      attr:=self.screen.wbortop+self.screen.font.ysize+1
      result:=TRUE
    CASE DD_SCREEN_BORDERLEFT
      attr:=self.screen.wborleft
      result:=TRUE
    CASE DD_SCREEN_BORDERBOTTOM
      attr:=self.screen.wborbottom
      result:=TRUE
    CASE DD_SCREEN_BORDERRIGHT
      attr:=self.screen.wborright
      result:=TRUE
    DEFAULT
      result:=FALSE
    ENDSELECT
    IF result AND (storageptr<>0)
      PutLong(storageptr,attr)
    ENDIF
  ENDIF
ENDPROC IF result THEN attr ELSE 0,result

EXPORT PROC new(taglist=NIL) OF dd_screen
  DEF pubname=NIL
  -> we need a pubscreen pointer to lock or clone
  IF pubname:=GetTagData(DD_SCREEN_PUBNAME,0,taglist)
    -> are we gonna clone this screen?
    IF GetTagData(DD_SCREEN_CLONE,FALSE,taglist)
      self.clonepubscreen(pubname,GetTagData(DD_SCREEN_TITLE,0,taglist))
    ELSE
      self.flags:=self.flags OR DD_SCREEN_FLAG_LOCK
      self.screen:=LockPubScreen(pubname)
    ENDIF
  ENDIF
ENDPROC

EXPORT PROC clonepubscreen(sourcepubname,clonescreentitle,clonedepth=0,clonepubname=NIL) OF dd_screen
  DEF sourcescreen=NIL:PTR TO screen,clonescreen=NIL:PTR TO screen
  DEF sourcefontname=NIL,clonefontname=NIL,sourcetextattr:PTR TO textattr
  DEF sourcefont=NIL:PTR TO textfont,clonefont=NIL:PTR TO textfont
  DEF modeid=0,drawinfo=NIL:PTR TO drawinfo

  IF self.screen=NIL
    self.screenfont:=NIL
    IF sourcescreen:=LockPubScreen(sourcepubname)
      IF drawinfo:=GetScreenDrawInfo(sourcescreen)
        sourcefont:=drawinfo.font
        IF (modeid:=GetVPModeID(sourcescreen.viewport))<>INVALID_ID
          sourcefontname:=sourcefont.mn.ln.name
          IF clonefontname:=String(StrLen(sourcefontname))
            StrCopy(clonefontname,sourcefontname)
            sourcetextattr:=[clonefontname,sourcefont.ysize,sourcefont.style,sourcefont.flags]:textattr
            IF clonefont:=OpenFont(sourcetextattr)
              self.pubsignal:=AllocSignal(-1)
              IF clonescreen:=OpenScreenTagList(NIL,[
                SA_WIDTH,sourcescreen.width,
                SA_HEIGHT,sourcescreen.height,
                SA_DEPTH,IF clonedepth THEN clonedepth ELSE drawinfo.depth,
                SA_OVERSCAN,OSCAN_TEXT,
                SA_AUTOSCROLL,TRUE,
                SA_FONT,sourcetextattr,
                SA_PENS,drawinfo.pens,
                SA_DISPLAYID,modeid,
                SA_TITLE,clonescreentitle,
                SA_PUBNAME,clonepubname,
                IF (self.pubsignal<>-1) THEN SA_PUBSIG ELSE TAG_IGNORE,self.pubsignal,
                TAG_DONE
                ])
                self.screen:=clonescreen
                self.screenfont:=clonefont
              ENDIF
            ENDIF
          ENDIF
        ENDIF
        FreeScreenDrawInfo(sourcescreen,drawinfo) BUT drawinfo:=NIL
      ENDIF
      UnlockPubScreen(NIL,sourcescreen) BUT sourcescreen:=NIL
      self.drawinfo:=GetScreenDrawInfo(self.screen)
    ENDIF
  ENDIF
ENDPROC self.screen<>NIL

EXPORT PROC end() OF dd_screen
  DEF fontname
  IF self.drawinfo
    FreeScreenDrawInfo(self.screen,self.drawinfo)
    self.drawinfo:=0
  ENDIF
  IF self.screen
    IF self.flags AND DD_SCREEN_FLAG_LOCK
      UnlockPubScreen(0,self.screen)
    ELSE
      IF (self.pubsignal<>-1)
        WHILE (CloseScreen(self.screen)=FALSE) DO Wait(Shl(1,self.pubsignal))
      ELSE
        WHILE (CloseScreen(self.screen)=FALSE) DO Delay(50)
      ENDIF
    ENDIF
  ENDIF
  self.screen:=NIL
  IF (self.pubsignal<>-1)
    FreeSignal(self.pubsignal)
    self.pubsignal:=-1
  ENDIF
  IF self.screenfont
    fontname:=self.screenfont.mn.ln.name
    CloseFont(self.screenfont)
    self.screenfont:=NIL
    DisposeLink(fontname)
    fontname:=NIL
  ENDIF
ENDPROC

PROC getcloneinfo(screen:PTR TO screen)
  DEF di:PTR TO drawinfo, clonedepth=0
  IF di:=GetScreenDrawInfo(screen)
    clonedepth:=di.depth
    FreeScreenDrawInfo(screen,di)
  ENDIF
ENDPROC clonedepth,screen.width,screen.height

EXPORT PROC backdropwindow(screen:PTR TO screen,idcmp=0,flags=0)
  DEF wnd=NIL:PTR TO window
  IF (wnd:=OpenWindowTagList(NIL,
    [WA_LEFT,0,
     WA_TOP,0,
     WA_WIDTH,screen.width,
     WA_HEIGHT,screen.height,
     WA_IDCMP,idcmp,
     WA_FLAGS,flags OR $1900,
     WA_TITLE,'',
     WA_CUSTOMSCREEN,screen,
     NIL]))=NIL THEN Raise("WIN")
  stdrast:=wnd.rport
ENDPROC wnd


