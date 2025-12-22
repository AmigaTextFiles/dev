-> publicscreen.e - open a screen with the pens from a public screen

MODULE 'intuition/screens'

ENUM ERR_NONE, ERR_SCRN, ERR_LOCKPUB, ERR_GETDRAW

RAISE ERR_SCRN    IF OpenScreenTagList()=NIL
RAISE ERR_LOCKPUB IF LockPubScreen()=NIL
RAISE ERR_GETDRAW IF GetScreenDrawInfo()=NIL

PROC main()
  IF KickVersion(37)
    -> Check the version.  Release 2 is required for public screen functions
    -> E-Note: E automatically opens the Intuition library
    usePubScreenPens()
  ENDIF
ENDPROC

-> Open a screen that uses the pens of an existing public screen (the Workbench
-> screen in this case).
PROC usePubScreenPens() HANDLE
  DEF my_screen=NIL:PTR TO screen, pubScreenName
  DEF pub_screen=NIL:PTR TO screen, screen_drawinfo=NIL:PTR TO drawinfo

  pubScreenName:='Workbench'

  -> Get a lock on the Workbench screen
  -> E-Note: automatically error-checked (automatic exception)
  pub_screen:=LockPubScreen(pubScreenName)

  -> Get the DrawInfo structure from the locked screen
  -> E-Note: automatically error-checked (automatic exception)
  screen_drawinfo:=GetScreenDrawInfo(pub_screen)

  -> The pens are copied in the OpenScreenTagList() call, so we can simply use
  -> a pointer to the pens in the tag list.
  ->
  -> This works better if the depth and colors of the new screen matches that
  -> of the public screen.  Here we are forcing the Workbench screen pens on a
  -> monochrome screen (which may not be a good idea).  You could add the tag:
  ->      (SA_DEPTH, screen_drawinfo.depth)
  -> E-Note: automatically error-checked (automatic exception)
  my_screen:=OpenScreenTagList(NIL,
                              [SA_PENS, screen_drawinfo.pens,
                              /* E-Note: try uncommenting next line (see above) */
                              /* SA_DEPTH, screen_drawinfo.depth,               */
                               NIL])

  -> We no longer need to hold the lock on the public screen or a copy of its
  -> DrawInfo structure as we now have our own screen.  Release the screen.
  FreeScreenDrawInfo(pub_screen, screen_drawinfo)
  screen_drawinfo:=NIL
  UnlockPubScreen(pubScreenName, pub_screen)
  pub_screen:=NIL

  Delay(90)  -> Should be the rest of the program

  -> E-Note: exit and clean up via handler
EXCEPT DO
  -> The first two are freed in the main code if OpenScreenTagList() does not
  -> fail.  If something goes wrong, free them here.
  IF screen_drawinfo THEN FreeScreenDrawInfo(pub_screen, screen_drawinfo)
  IF pub_screen THEN UnlockPubScreen(pubScreenName, pub_screen)
  IF my_screen THEN CloseScreen(my_screen)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_SCRN;    WriteF('Error: Failed to open custom screen\n')
  CASE ERR_LOCKPUB; WriteF('Error: Failed to locked public screen\n')
  CASE ERR_GETDRAW; WriteF('Error: Failed to get DrawInfo of screen\n')
  ENDSELECT
ENDPROC
