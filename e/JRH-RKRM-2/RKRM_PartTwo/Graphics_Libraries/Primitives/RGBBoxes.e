-> RGBBoxes.e - Simple ViewPort example -- works with 1.3 and Release 2

->>> Header (globals)
MODULE 'dos/dos',
       'exec/libraries',
       'graphics/displayinfo',
       'graphics/gfx',
       'graphics/gfxbase',
       'graphics/gfxnodes',
       'graphics/modeid',
       'graphics/videocontrol',
       'graphics/view'

ENUM ERR_NONE, ERR_COLMAP, ERR_FINDDISP, ERR_GETDISP, ERR_GFXNEW, ERR_MONI,
     ERR_RAST, ERR_VIDEO

RAISE ERR_COLMAP   IF GetColorMap()=NIL,
      ERR_FINDDISP IF FindDisplayInfo()=NIL,
      ERR_GETDISP  IF GetDisplayInfoData()=0,
      ERR_GFXNEW   IF GfxNew()=NIL,
      ERR_MONI     IF OpenMonitor()=NIL,
      ERR_RAST     IF AllocRaster()=NIL,
      ERR_VIDEO    IF VideoControl()<>NIL

-> The number of bitplanes, and the nominal width and height used in 1.3.
CONST DEPTH=2, WIDTH=640, HEIGHT=400

-> RGB values for the four colours used
CONST BLACK=$000, RED=$f00, GREEN=$0f0, BLUE=$00f

DEF bitMap:bitmap,
    displaymem=NIL  -> Pointer for writing to BitMap memory
->>>

->>> PROC main()
PROC main() HANDLE
  -> E-Note: a lot of the globals are really local to main()
  DEF view:view, oldview=NIL, viewPort:viewport, cm=NIL:PTR TO colormap,
      vextra=NIL:PTR TO viewextra, vpextra=NIL:PTR TO viewportextra,
      monspec=NIL, dimquery:dimensioninfo, depth, box, rasInfo:rasinfo,
      modeID, colortable, boxoffsets:PTR TO INT, gfx:PTR TO gfxbase
  gfx:=gfxbase  -> E-Note: get the right type for gfxbase

  -> Set the plane pointers to NIL so the handler will know if they are used.
  -> E-Note: this needs to be done *before* anything that may go wrong
  FOR depth:=0 TO DEPTH-1 DO bitMap.planes[depth]:=NIL

  -> Example steals the screen from Intuition if Intuition is around.
  oldview:=gfx.actiview  -> Save current View to restore later.

  InitView(view)  -> Initialise the View and set view.modes.
  -> This is the old 1.3 way (only V_LACE counts).
  view.modes:=view.modes OR V_LACE

  IF gfx.lib.version>=36
    -> Form the ModeID from values in 'graphics/displayinfo'
    modeID:=DEFAULT_MONITOR_ID OR HIRESLACE_KEY

    -> Make the viewextra object
    vextra:=GfxNew(VIEW_EXTRA_TYPE)
    -> Attach the ViewExtra to the View
    GfxAssociate(view, vextra)
    view.modes:=view.modes OR EXTEND_VSTRUCT

    -> Create and attach a MonitorSpec to the ViewExtra
    monspec:=OpenMonitor(NIL, modeID)
    vextra.monitor:=monspec
  ENDIF

  -> Initialise the BitMap for RasInfo.
  InitBitMap(bitMap, DEPTH, WIDTH, HEIGHT)

  -> Allocate space for BitMap
  FOR depth:=0 TO DEPTH-1 DO bitMap.planes[depth]:=AllocRaster(WIDTH, HEIGHT)

  -> Initialise the RasInfo.
  rasInfo:=[NIL, bitMap, 0, 0]:rasinfo

  InitVPort(viewPort)      -> Initialise the ViewPort.
  view.viewport:=viewPort  -> Link the ViewPort into the View.
  viewPort.rasinfo:=rasInfo
  viewPort.dwidth:=WIDTH
  viewPort.dheight:=HEIGHT

  -> Set the display mode the old-fashioned way
  viewPort.modes:=V_HIRES OR V_LACE

  IF gfx.lib.version>=36
    -> Make a ViewPortExtra and get ready to attach it
    vpextra:=GfxNew(VIEWPORT_EXTRA_TYPE)

    -> Initialise the DisplayClip field of the ViewPortExtra
    GetDisplayInfoData(NIL, dimquery, SIZEOF dimensioninfo, DTAG_DIMS, modeID)
    CopyMem(dimquery.nominal, vpextra.displayclip, SIZEOF rectangle)
    -> E-Note: FindDisplayInfo in a the tag-list later

    -> This is for backwards compatibility with, for example, a 1.3 screen
    -> saver utility that looks at the Modes field.
    viewPort.modes:=modeID AND $0000FFFF
  ENDIF

  -> Initialize the ColorMap.
  -> 2 planes deep, so 4 entries (2 raised to the #_planes power).
  cm:=GetColorMap(4)

  IF gfx.lib.version>=36
    -> Attach the color map and Release 2 extended structures
    VideoControl(cm, [VTAG_ATTACH_CM_SET, viewPort,
                      VTAG_VIEWPORTEXTRA_SET, vpextra,
                      VTAG_NORMAL_DISP_SET, FindDisplayInfo(modeID),
                      NIL])
  ELSE
    -> Attach the ColorMap, old 1.3-style
    viewPort.colormap:=cm
  ENDIF

  colortable:=[BLACK, RED, GREEN, BLUE]:INT
  -> Change colors to those in colortable.
  LoadRGB4(viewPort, colortable, 4)

  MakeVPort(view, viewPort)  -> Construct preliminary Copper instruction list.

  -> Merge preliminary lists into a real Copper list in the view object
  MrgCop(view)

  -> Clear the ViewPort
  FOR depth:=0 TO DEPTH-1
    displaymem:=bitMap.planes[depth]
    BltClear(displaymem, bitMap.bytesperrow*bitMap.rows, 1)
  ENDFOR

  LoadView(view)

  boxoffsets:=[802, 2010, 3218]:INT
  -> Now fill some boxes so that user can see something.
  -> Always draw into both planes to assure true colors.
  FOR box:=1 TO 3  -> Three boxes; red, green and blue.
    FOR depth:=0 TO DEPTH-1  -> Two planes
      displaymem:=bitMap.planes[depth]+boxoffsets[box-1]
      drawFilledBox(box, depth)
    ENDFOR
  ENDFOR

  Delay(10*TICKS_PER_SECOND)  -> Pause for 10 seconds.
  LoadView(oldview)           -> Put back the old View.
  WaitTOF()  -> Wait until the View is being rendered to free memory.

  -> Deallocate the hardware Copper list created by MrgCopy().  Since this is
  -> interlace, also check for a short frame copper list to free.
  FreeCprList(view.lofcprlist)
  IF view.shfcprlist THEN FreeCprList(view.shfcprlist)

  -> Free all intermediate Copper lists created by MakeVPort().
  FreeVPortCopLists(viewPort)

EXCEPT DO
  -> Free the color map created by GetColorMap()
  IF cm THEN FreeColorMap(cm)
  -> Free the ViewPortExtra created by GfxNew()
  IF vpextra THEN GfxFree(vpextra)
  -> Free the BitPlanes drawing area.
  FOR depth:=0 TO DEPTH-1
    IF bitMap.planes[depth] THEN FreeRaster(bitMap.planes[depth], WIDTH, HEIGHT)
  ENDFOR
  -> Free the MonitorSpec created with OpenMonitor().
  IF monspec THEN CloseMonitor(monspec)
  -> Free the ViewExtra created with GfxNew().
  IF vextra THEN GfxFree(vextra)
  SELECT exception
  CASE ERR_COLMAP;    WriteF('Could not get ColorMap\n')
  CASE ERR_FINDDISP;  WriteF('Could not get DisplayInfo\n')
  CASE ERR_GETDISP;   WriteF('Could not get DimensionInfo\n')
  CASE ERR_GFXNEW;    WriteF('Could not get ViewExtra/ViewPortExtra\n')
  CASE ERR_MONI;      WriteF('Could not get MonitorSpec\n')
  CASE ERR_RAST;      WriteF('Could not get BitPlanes\n')
  CASE ERR_VIDEO;     WriteF('Could not attach extended structures\n')
  ENDSELECT
ENDPROC IF exception<>ERR_NONE THEN RETURN_FAIL ELSE RETURN_OK
->>>

->>> PROC drawFilledBox(fillcolor, plane)
-> Create a WIDTH/2 by HEIGHT/2 box of color "fillcolor" into the given plane
PROC drawFilledBox(fillcolor, plane)
  DEF value, boxHeight, boxWidth, width

  -> Divide (WIDTH/2) by eight because each CHAR that is written stuffs eight
  -> bits into the BitMap.
  boxWidth:=(WIDTH/2)/8

  value:=IF fillcolor AND Shl(1, plane) THEN $FF ELSE 0

  -> E-Note: slightly re-expressed to read a lot better...
  FOR boxHeight:=1 TO HEIGHT/2
    FOR width:=1 TO boxWidth DO displaymem[]++:=value
    displaymem:=displaymem+(bitMap.bytesperrow-boxWidth)
  ENDFOR
ENDPROC
->>>

