-> clipping.e

->>> Header (globals)
MODULE 'layers',
       'graphics/gfx',
       'intuition/intuition'

ENUM ERR_NONE, ERR_LIB, ERR_WIN

RAISE ERR_LIB  IF OpenLibrary()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST MY_WIN_WIDTH=300, MY_WIN_HEIGHT=100
->>>

->>> PROC unclipWindow(win:PTR TO window)
-> Used to remove a clipping region installed by clipWindow() or
-> clipWindowToBorders(), disposing of the installed region and reinstalling
-> the region removed.
PROC unclipWindow(win:PTR TO window)
  DEF old_region
  -> Remove any old region by installing a NIL region, then dispose of the old
  -> region if one was installed.
  IF old_region:=InstallClipRegion(win.wlayer, NIL)
    DisposeRegion(old_region)
  ENDIF
ENDPROC
->>>

->>> PROC clipWindow(win:PTR TO window, minX, minY, maxX, maxY)
-> Clip a window to a specified rectangle (given by upper left and lower right
-> corner).  The removed region is returned so that it may be reinstalled
-> later.
PROC clipWindow(win:PTR TO window, minX, minY, maxX, maxY)
  DEF new_region, my_rectangle
  -> Set up the limits for the clip.
  my_rectangle:=[minX, minY, maxX, maxY]:rectangle
  -> Get a new region and OR in the limits.
  IF new_region:=NewRegion()
    IF OrRectRegion(new_region, my_rectangle)=FALSE
      DisposeRegion(new_region)
      new_region:=NIL
    ENDIF
  ENDIF
-> Install the new region, and return any existing region.  If the above
-> allocation and region processing failed, then new_region will be NIL and
-> no clip region will be installed.
ENDPROC InstallClipRegion(win.wlayer, new_region)
->>>

->>> PROC clipWindowToBorders(win:PTR TO window)
-> Clip a window to its borders.
-> The removed region is returned so that it may be re-installed later.
PROC clipWindowToBorders(win:PTR TO window)
ENDPROC clipWindow(win, win.borderleft, win.bordertop,
                   win.width-win.borderright-1, win.height-win.borderbottom-1)
->>>

->>> PROC wait_for_close(win)
-> Wait for the user to select the close gadget.
PROC wait_for_close(win)
  REPEAT  -> E-Note: use built-in WaitIMessage()
  UNTIL WaitIMessage(win)=IDCMP_CLOSEWINDOW
ENDPROC
->>>

->>> PROC draw_in_window(win:PTR TO window, message)
-> Simple routine to blast all bits in a window with color three to show where
-> the window is clipped.  After a delay, flush back to color zero and refresh
-> the window borders.
PROC draw_in_window(win:PTR TO window, message)
  WriteF('\s...', message)
  SetRast(win.rport, 3)
  Delay(200)
  SetRast(win.rport, 0)
  RefreshWindowFrame(win)
  WriteF('...done\n')
ENDPROC
->>>

->>> PROC clip_test(win:PTR TO window)
-> Show drawing into an unclipped window, a window clipped to the borders and
-> a window clipped to a random rectangle.  It is possible to clip more
-> complex shapes by AND'ing, OR'ing and exclusive-OR'ing regions and
-> rectangles to build a user clip region.
->
-> This example assumes that old regions are not going to be re-used, so it
-> simply throws them away.
PROC clip_test(win)
  DEF old_region
  draw_in_window(win, 'Window with no clipping')

  -> If the application has never installed a user clip region, then
  -> old_region will be NIL here.  Otherwise, delete the old region (you
  -> could save it and re-install it later...)
  IF old_region:=clipWindowToBorders(win)
    DisposeRegion(old_region)
  ENDIF
  draw_in_window(win, 'Window clipped to window borders')
  unclipWindow(win)

  -> Here we know old_region will be NIL, as that is what we installed with
  -> unclipWindow()...
  IF old_region:=clipWindow(win, 20, 20, 100, 50)
    DisposeRegion(old_region)
  ENDIF
  draw_in_window(win, 'Window clipped from (20,20) to (100,50)')
  unclipWindow(win)

  wait_for_close(win)
ENDPROC
->>>

->>> PROC main()
-> Open and close resources, call the test routine when ready.
PROC main() HANDLE
  DEF win=NIL
  KickVersion(37)
  layersbase:=OpenLibrary('layers.library', 37)
  win:=OpenWindowTagList(NIL, [WA_WIDTH,       MY_WIN_WIDTH,
                               WA_HEIGHT,      MY_WIN_HEIGHT,
                               WA_IDCMP,       IDCMP_CLOSEWINDOW,
                               WA_CLOSEGADGET, TRUE,
                               WA_DRAGBAR,     TRUE,
                               WA_ACTIVATE,    TRUE,
                               NIL])
  clip_test(win)
EXCEPT DO
  IF win THEN CloseWindow(win)
  IF layersbase THEN CloseLibrary(layersbase)
  SELECT exception
  CASE ERR_LIB;   WriteF('Error: could not open layers.library V37+\n')
  CASE ERR_WIN;   WriteF('Error: could not open window\n')
  ENDSELECT
ENDPROC
->>>

