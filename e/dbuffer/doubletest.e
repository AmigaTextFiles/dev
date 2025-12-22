/*rewritten from doubletest.e in RKRM*/

MODULE 'other/doublebuffer','graphics/view','intuition/screens'
CONST SCR_WIDTH=320, SCR_HEIGHT=200, SCR_DEPTH=2
PROC main()
  DEF ktr, xpos, ypos, ds:PTR TO dscreen
ds:=opendscreen([0,           -> LeftEdge
                 0,           -> TopEdge
                 SCR_WIDTH,   -> Width
                 SCR_HEIGHT,  -> Height
                 SCR_DEPTH,   -> Depth
                 0,           -> DetailPen
                 1,           -> BlockPen
                 NIL,         -> ViewModes
                 NIL,         -> Type
                 NIL,         -> Font
                 NIL,         -> DefaultTitle
                 NIL,         -> Gadgets
                 NIL          -> CustomBitMap
                 ]:ns)

  SetAPen(ds.screen.rastport, 1)
  FOR ktr:=1 TO 199
    xpos:=ktr
    ypos:=IF Mod(ktr,100)>=50 THEN 50-Mod(ktr,50) ELSE Mod(ktr,50)
    SetRast(ds.screen.rastport, 0)
    RectFill(ds.screen.rastport, xpos, ypos, xpos+100, ypos+100)
    dswitch(ds)
  ENDFOR
closedscreen(ds)
ENDPROC
