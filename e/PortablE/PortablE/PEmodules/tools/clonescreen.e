-> clonescreen.c, from RKRM libs.

OPT MODULE, OSVERSION=37
OPT POINTER

MODULE 'intuition/intuition', 'intuition/screens',
       'graphics/text', 'graphics/modeid'
MODULE 'intuition', 'graphics', 'utility/tagitem'

PROC openclonescreen(pub_screen_name:ARRAY OF CHAR,clone_title,depth=0,clone_pub_name=NILA:ARRAY OF CHAR)
  DEF my_screen:PTR TO screen, screen_modeID, pub_scr_font_name:ARRAY OF CHAR,
      font_name:STRING, font_name_size, pub_screen_font:PTR TO textattr,
      opened_font:PTR TO textfont, pub_screen:PTR TO screen,
      screen_drawinfo:PTR TO drawinfo, di_font:PTR TO textfont

  IF pub_screen:=LockPubScreen(pub_screen_name)
    IF screen_drawinfo:=GetScreenDrawInfo(pub_screen)
      di_font:=screen_drawinfo.font
      IF (screen_modeID:=GetVPModeID(pub_screen.viewport)!!BIGVALUE!!VALUE)<>INVALID_ID
        pub_scr_font_name:=di_font.mn.ln.name	/*GetLong(di_font+10)*/  -> node.name
        font_name_size:=1+StrLen(pub_scr_font_name)
        IF font_name:=NewString(font_name_size)
          StrCopy(font_name,pub_scr_font_name)
          pub_screen_font:=[font_name,di_font.ysize,di_font.style,di_font.flags]:textattr
          IF opened_font:=OpenFont(pub_screen_font)
            IF my_screen:=OpenScreenTagList(NIL,
              [SA_WIDTH,      pub_screen.width,
               SA_HEIGHT,     pub_screen.height,
               SA_DEPTH,      IF depth THEN depth ELSE screen_drawinfo.depth,
               SA_TYPE,       IF clone_pub_name THEN PUBLICSCREEN ELSE CUSTOMSCREEN,
               SA_OVERSCAN,   OSCAN_TEXT,
               SA_AUTOSCROLL, TRUE,
               SA_FONT,       pub_screen_font,
               SA_PENS,       screen_drawinfo.pens,
               SA_DISPLAYID,  screen_modeID,
               SA_TITLE,      clone_title,
               SA_PUBNAME,    clone_pub_name,
               NIL]:tagitem)
            ENDIF
          ENDIF
        ENDIF
      ENDIF
      FreeScreenDrawInfo(pub_screen,screen_drawinfo)
    ENDIF
    UnlockPubScreen(pub_screen_name,pub_screen)
  ENDIF
  IF my_screen=NIL THEN Raise("SCR")
ENDPROC my_screen,opened_font

PROC closeclonescreen(screen:PTR TO screen,font:PTR TO textfont,window=NIL:PTR TO window)
  DEF r
  IF window THEN CloseWindow(window)
  IF screen THEN r:=CloseScreen(screen)
  IF r THEN IF font THEN CloseFont(font)
ENDPROC r

PROC getcloneinfo(screen:PTR TO screen)
  DEF di:PTR TO drawinfo, depth
  depth:=0
  IF di:=GetScreenDrawInfo(screen)
    depth:=di.depth
    FreeScreenDrawInfo(screen,di)
  ENDIF
ENDPROC depth,screen.width,screen.height

PROC backdropwindow(screen:PTR TO screen,idcmp=0,flags=0)
  DEF wnd:PTR TO window
  IF (wnd:=OpenWindowTagList(NIL,
    [WA_LEFT,0,
     WA_TOP,0,
     WA_WIDTH,screen.width,
     WA_HEIGHT,screen.height,
     WA_IDCMP,idcmp,
     WA_FLAGS,flags OR $1900,
     WA_TITLE,'',
     WA_CUSTOMSCREEN,screen,
     NIL]:tagitem))=NIL THEN Raise("WIN")
  stdrast:=wnd.rport
ENDPROC wnd
