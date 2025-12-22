-> doublebuffer.e - Show the use of a double-buffered screen

MODULE 'intuition/screens',  -> Screen data structures
       'graphics/rastport',  -> RastPort and other structures
       'graphics/view',      -> ViewPort and other structures
       'graphics/gfx'        -> BitMap and other structures

-> Characteristics of the screen
CONST SCR_WIDTH=320, SCR_HEIGHT=200, SCR_DEPTH=2

-> Exception values
-> E-Note: exceptions are a much better way of handling errors
ENUM ERR_NONE, ERR_SCRN, ERR_RAST

-> Automatically raise exceptions
-> E-Note: these take care of a lot of error cases
RAISE ERR_SCRN IF OpenScreen()=NIL,
      ERR_RAST IF AllocRaster()=NIL

-> Main routine.  Setup for using the double buffered screen.  Clean up all
-> resources when done or on any error.
PROC main() HANDLE
  DEF myBitMaps=NIL:PTR TO LONG, screen=NIL:PTR TO screen
  -> E-Note: E automatically opens the Intuition and Graphics libraries
  myBitMaps:=setupBitMaps(SCR_DEPTH, SCR_WIDTH, SCR_HEIGHT)

  -> Open a simple quiet screen that is using the first of the two bitmaps.
  -> E-Note: use a typed list to get an initialised object
  -> E-Note: automatically error-checked (automatic exception)
  screen:=OpenScreen([0,           -> LeftEdge
                      0,           -> TopEdge
                      SCR_WIDTH,   -> Width
                      SCR_HEIGHT,  -> Height
                      SCR_DEPTH,   -> Depth
                      0,           -> DetailPen
                      1,           -> BlockPen
                      V_HIRES,     -> ViewModes
                      CUSTOMSCREEN OR CUSTOMBITMAP OR SCREENQUIET,  -> Type
                      NIL,         -> Font
                      NIL,         -> DefaultTitle
                      NIL,         -> Gadgets
                      myBitMaps[0] -> CustomBitMap
                     ]:ns)
  -> Indicate that the rastport is double buffered.
  screen.rastport.flags:=RPF_DBUFFER
  runDBuff(screen, myBitMaps)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF screen THEN CloseScreen(screen)
  IF myBitMaps THEN freeBitMaps(myBitMaps, SCR_DEPTH, SCR_WIDTH, SCR_HEIGHT)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_SCRN; WriteF('Error: Failed to open custom screen\n')
  CASE ERR_RAST; WriteF('Error: Ran out of memory in AllocRaster()\n')
  CASE "MEM";    WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC

-> setupBitMaps(): allocate the bit maps for a double buffered screen.
PROC setupBitMaps(depth, width, height) HANDLE
  DEF myBitMaps:PTR TO LONG
  -> E-Note: an immediate list in E takes the place of the static in C
  -> E-Note: initialise the two bitmaps to NIL pointers 
  myBitMaps:=[NIL,NIL]
  -> E-Note: NewR raises an exception if it fails
  myBitMaps[0]:=NewR(SIZEOF bitmap)
  myBitMaps[1]:=NewR(SIZEOF bitmap)
  InitBitMap(myBitMaps[0], depth, width, height)
  InitBitMap(myBitMaps[1], depth, width, height)
  setupPlanes(myBitMaps[0], depth, width, height)
  setupPlanes(myBitMaps[1], depth, width, height)
EXCEPT
  freeBitMaps(myBitMaps, depth, width, height)
  -> E-Note: exception must be passed on to caller
  ReThrow()
ENDPROC myBitMaps

-> runDBuff(): loop through a number of iterations of drawing into alternate
-> frames of the double-buffered screen.  Note that the object is drawn in
-> colour 1.
PROC runDBuff(screen:PTR TO screen, myBitMaps:PTR TO LONG)
  DEF ktr, xpos, ypos, toggleFrame=0
  SetAPen(screen.rastport, 1)
  FOR ktr:=1 TO 199
    -> Calculate a position to place the object, these calculations ensure the
    -> object will stay on the screen given the range of ktr and the size of
    -> the object.
    xpos:=ktr
    ypos:=IF Mod(ktr,100)>=50 THEN 50-Mod(ktr,50) ELSE Mod(ktr,50)

    -> Switch the bitmap so that we are drawing into the correct place
    screen.rastport.bitmap:=myBitMaps[toggleFrame]
    screen.viewport.rasinfo.bitmap:=myBitMaps[toggleFrame]

    -> Draw the object
    -> Here we clear the old frame and draw a simple filled rectangle
    SetRast(screen.rastport, 0)
    RectFill(screen.rastport, xpos, ypos, xpos+100, ypos+100)

    -> Update the physical display to match the newly drawn bitmap
    MakeScreen(screen)  -> Tell Intuition to do its stuff
    RethinkDisplay()    -> Intuition compatible MrgCop() & LoadView()
                        ->   It also does a WaitTOF()

    -> Switch the frame number for the next time through
    -> E-Note: this is exactly what the C version does...
    toggleFrame:=Eor(toggleFrame, 1)
  ENDFOR
ENDPROC

-> freeBitMaps(): free up the memory allocated by setupBitMaps()
PROC freeBitMaps(myBitMaps:PTR TO LONG, depth, width, height)
  -> E-Note: freeBitMaps() can be safely if written carefully
  IF myBitMaps[0]
    freePlanes(myBitMaps[0], depth, width, height)
    Dispose(myBitMaps[0])
  ENDIF
  IF myBitMaps[1]
    freePlanes(myBitMaps[1], depth, width, height)
    Dispose(myBitMaps[1])
  ENDIF
ENDPROC

-> setupPlanes(): allocate the bit planes for a screen bit map
PROC setupPlanes(bitMap:PTR TO bitmap, depth, width, height)
  DEF plane_num, planes:PTR TO LONG
  planes:=bitMap.planes
  FOR plane_num:=0 TO depth-1
    -> E-Note: automatically error-checked (automatic exception)
    planes[plane_num]:=AllocRaster(width, height)
    BltClear(planes[plane_num], (width/8)*height, 1)
  ENDFOR
  -> E-Note: exceptions handled in caller, which frees memory
ENDPROC

-> freePlanes(): free up the memory allocated by setupPlanes()
PROC freePlanes(bitMap:PTR TO bitmap, depth, width, height)
  DEF plane_num, planes:PTR TO LONG
  planes:=bitMap.planes
  FOR plane_num:=0 TO depth-1
    IF planes[plane_num] THEN FreeRaster(planes[plane_num], width, height)
  ENDFOR
ENDPROC
