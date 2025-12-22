-> clonescreen.e - clone an existing public screen

MODULE 'intuition/screens', -> Screen data structures and tags
       'graphics/text',     -> Text font structure
       'graphics/modeid',   -> Release 2 Amiga display mode ID's
       'exec/nodes',        -> Nodes -- get font name
       'exec/ports'         -> Ports -- get font name

ENUM ERR_NONE, ERR_SCRN, ERR_LOCKPUB, ERR_GETDRAW, ERR_MODEID, ERR_FONT

RAISE ERR_SCRN    IF OpenScreenTagList()=NIL,
      ERR_LOCKPUB IF LockPubScreen()=NIL,
      ERR_GETDRAW IF GetScreenDrawInfo()=NIL,
      ERR_MODEID  IF GetVPModeID()=INVALID_ID,
      ERR_FONT    IF OpenFont()=NIL,
      "MEM"       IF String()=NIL

PROC main()
  DEF pub_screen_name
  pub_screen_name:='Workbench'

  IF KickVersion(37)
    -> Require version 37
    -> E-Note: E automatically opens the Intuition and Graphics libraries
    cloneScreen(pub_screen_name)
  ENDIF
ENDPROC

-> Clone a public screen whose name is passed to the routine.  Width, Height,
-> Depth, Pens, Font and DisplayID attributes are all copied from the screen.
-> Overscan is assumed to be OSCAN_TEXT, as there is no easy way to find the
-> overscan type of an existing screen.  AutoScroll is turned on, as it does
-> not hurt.  Screens that are smaller than the display clip will not scroll.

PROC cloneScreen(pub_screen_name) HANDLE
  DEF my_screen=NIL:PTR TO screen, screen_modeID, pub_scr_font_name,
      font_name, pub_screen_font:PTR TO textattr, opened_font,
      pub_screen=NIL:PTR TO screen, screen_drawinfo=NIL:PTR TO drawinfo

  -> pub_screen_name is a pointer to the name of the public screen to clone
  -> E-Note: automatically error-checked (automatic exception)
  pub_screen:=LockPubScreen(pub_screen_name)

  -> Get the DrawInfo structure from the locked screen
  -> E-Note: automatically error-checked (automatic exception)
  screen_drawinfo:=GetScreenDrawInfo(pub_screen)

  -> E-Note: pub_screen.viewport is a structure in C and (as usual) a pointer
  -> to the structure in E
  -> E-Note: automatically error-checked (automatic exception)
  screen_modeID:=GetVPModeID(pub_screen.viewport)

  -> Get a copy of the font
  -> The name of the font must be copied as the public screen may go away at
  -> any time after we unlock it.  Allocate enough memory to copy the font
  -> name, create a TextAttr that matches the font, and open the font.
  -> E-Note: pointer typing needed to multiply select from system objects
  pub_scr_font_name:=screen_drawinfo.font.mn.ln.name

  -> E-Note: allocate and copy all in one go
  -> E-Note: automatically error-checked (automatic exception)
  font_name:=StrCopy(String(StrLen(pub_scr_font_name)), pub_scr_font_name)

  -> E-Note: use a typed list for initialised object
  pub_screen_font:=[font_name,
                    screen_drawinfo.font.ysize,
                    screen_drawinfo.font.style,
                    screen_drawinfo.font.flags]:textattr
  
  -> E-Note: pub_screen_font is a structure in C and (as usual) a pointer to
  ->         the structure in E
  -> E-Note: automatically error-checked (automatic exception)
  opened_font:=OpenFont(pub_screen_font)

  -> screen_modeID may now be used in a call to OpenScreenTagList() with the
  -> tag SA_DISPLAYID
  -> E-Note: automatically error-checked (automatic exception)
  my_screen:=OpenScreenTagList(NIL,
                              [SA_WIDTH,      pub_screen.width,
                               SA_HEIGHT,     pub_screen.height,
                               SA_DEPTH,      screen_drawinfo.depth,
                               SA_OVERSCAN,   OSCAN_TEXT,
                               SA_AUTOSCROLL, TRUE,
                               SA_PENS,       screen_drawinfo.pens,
                               SA_FONT,       pub_screen_font,
                               SA_DISPLAYID,  screen_modeID,
                               SA_TITLE,      'Cloned Screen',
                               NIL])

  -> Free the drawinfo and public screen as we don't need them any more.
  -> We now have our own screen.
  FreeScreenDrawInfo(pub_screen, screen_drawinfo)
  screen_drawinfo:=NIL
  UnlockPubScreen(pub_screen_name, pub_screen)
  pub_screen:=NIL

  Delay(300)  -> Should be the rest of the program

  -> E-Note: exit and clean up via handler
EXCEPT DO
  -> The first two are freed in the main code if OpenScreenTagList() does not
  -> fail.  If something goes wrong, free them here.
  IF screen_drawinfo THEN FreeScreenDrawInfo(pub_screen, screen_drawinfo)
  IF pub_screen THEN UnlockPubScreen(pub_screen_name, pub_screen)
  IF my_screen THEN CloseScreen(my_screen)
  IF opened_font THEN CloseFont(opened_font)
  -> E-Note: it is not strictly necessary, but tidy, to free the font_name
  IF font_name THEN DisposeLink(font_name)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_FONT
    -> E-Note: it's helpful to say which font went wrong
    WriteF('Error: Failed to open font "\s"\n', font_name)
  CASE ERR_GETDRAW; WriteF('Error: Failed to get DrawInfo of screen\n')
  CASE ERR_LOCKPUB; WriteF('Error: Failed to locked public screen\n')
  CASE ERR_MODEID;  WriteF('Error: Public screen has invalid mode ID\n')
  CASE ERR_SCRN;    WriteF('Error: Failed to open custom screen\n')
  CASE "MEM";       WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC
