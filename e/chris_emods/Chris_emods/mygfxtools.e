OPT MODULE, PREPROCESS, REG = 5

MODULE 'graphics/rastport',
       'graphics/gfxmacros',
       'intuition/screens'

->> myscrollraster(myrp:PTR TO rastport, x, y, x2, y2, deltax, deltay)
EXPORT PROC myscrollraster(rp_ptr:PTR TO rastport, x, y, x2, y2, deltax, deltay)
  DEF rpx, rpy, rpx2, rpy2, width, height

  IF (deltax >= 0)
    rpx   := x + deltax
    rpx2  := x
    width := (-x + x2) - deltax
  ELSE
    rpx   := x
    rpx2  := x - deltax
    width := (-x + x2) + deltax
  ENDIF

  IF (deltay >= 0)
    rpy    := y + deltay
    rpy2   := y
    height := (-y + y2) - deltay
  ELSE
    rpy    := y
    rpy2   := y - deltay
    height := (-y + y2) + deltay
  ENDIF

  ClipBlit(rp_ptr, rpx,  rpy,
           rp_ptr, rpx2, rpy2,
                   width, height,
                   $C0)
ENDPROC
-><
->> mydrawbox(rp_ptr:PTR TO rastport, x, y, x2, y2, type = 1)
EXPORT PROC mydrawbox(rp_ptr:PTR TO rastport, dri:PTR TO drawinfo, x, y, x2, y2, type = 1, recessed = FALSE, light = FALSE, lightpen = 0, darkpen = 0)
  DEF gap, black, white, grey
  DEF oldrast

  white := IF light THEN lightpen ELSE dri.pens[SHINEPEN]
  black := IF light THEN darkpen  ELSE dri.pens[SHADOWPEN]
  grey  := dri.pens[BACKGROUNDPEN]

  oldrast := SetStdRast(rp_ptr)

  SELECT 8 OF type
    -> Normal box
    CASE 1
      drawbox(x,  y,
              x2, y2,
              IF recessed THEN black ELSE white)

    -> Bevel
    CASE 2
      drawbevelbox(x,  y,
                   x2, y2,
                   black, white, grey, recessed)

    -> Smooth bevel
    CASE 3
      -> Left white
      Line(x, y2 - 2,
           x, y + 1,
           IF recessed THEN black ELSE white)
      Line(x, y + 1,
           x + 1, y + 1,
           IF recessed THEN black ELSE white)

      -> Top white
      Line(x + 1, y + 1,
           x + 1, y,
           IF recessed THEN black ELSE white)
      Line(x + 1, y,
           x2 - 2, y,
           IF recessed THEN black ELSE white)

      -> Left light
      Line(x + 1, y + 2,
           x + 1, y2 - 2,
           IF recessed THEN darkpen ELSE lightpen)

      -> Top light
      Line(x + 2, y + 1,
           x2 - 2, y + 1,
           IF recessed THEN darkpen ELSE lightpen)

      -> Fill upper left corner
      Plot(x, y, IF recessed THEN darkpen ELSE lightpen)

      -> Bottom black
      Line(x + 2, y2,
           x2 - 1, y2,
           IF recessed THEN white ELSE black)
      Line(x2 - 1, y2,
           x2 - 1, y2 - 1,
           IF recessed THEN white ELSE black)

      -> Right black
      Line(x2 - 1, y2 - 1,
           x2, y2 - 1,
           IF recessed THEN white ELSE black)
      Line(x2, y2 - 1,
           x2, y + 2,
           IF recessed THEN white ELSE black)

      -> Bottom dark
      Line(x + 2, y2 - 1,
           x2 - 2, y2 - 1,
           IF recessed THEN lightpen ELSE darkpen)
      -> Right dark
      Line(x2 - 1, y + 2,
           x2 - 1, y2 - 2,
           IF recessed THEN lightpen ELSE darkpen)

      -> Fill lower right corner
      Plot(x2, y2, IF recessed THEN lightpen ELSE darkpen)

      -> Fill upper right corner
      Box(x2 - 1, y,
          x2,     y + 1,
          grey)
      -> Fill lower left corner
      Box(x,     y2 - 1,
          x + 1, y2,
          grey)

    -> Embossed
    CASE 4

      -> Outer black edge
      drawbox(x,  y,
              x2, y2,
              black)

      IF recessed
        -> Inner edge
        Line(x + 1, y2 - 1,
             x + 1, y + 1,
             darkpen)
        Line(x + 1, y + 1,
             x2 - 1, y + 1,
             darkpen)

        Line(x + 2, y2 - 1,
             x + 2, y + 2,
             lightpen)
        Line(x + 2, y + 2,
             x2 - 1, y + 2,
             lightpen)
      ELSE
        -> Inner bevel
        drawbevelbox(x  + 1, y  + 1,
                     x2 - 1, y2 - 1,
                     darkpen, white, grey, FALSE)
      ENDIF

    -> Ridge, Wide ridge
    CASE 5, 6
      gap := IF (type = 5) THEN 1 ELSE 2

      -> Outer bevel
      drawbevelbox(x,  y,
                   x2, y2,
                   black, white, grey, recessed)

      -> Fill middle
      IF (type = 6)
        drawbox(x  + 1, y  + 1,
                x2 - 1, y2 - 1,
                grey)
      ENDIF

      -> Inner bevel
      drawbevelbox(x + gap,  y + gap,
                   x2 - gap, y2 - gap,
                   black, white, grey, IF recessed THEN FALSE ELSE TRUE)

    -> Smooth ridge
    CASE 7
      -> Outer bevel
      drawbevelbox(x,  y,
                   x2, y2,
                   black, white, grey, recessed)
      -> Outer bevel
      drawbevelbox(x  + 1, y  + 1,
                   x2 - 1, y2 - 1,
                   darkpen, lightpen, grey, recessed)

      drawbox(x  + 2, y  + 2,
              x2 - 2, y2 - 2,
              grey)

      -> Inner bevel
      drawbevelbox(x  + 3, y  + 3,
                   x2 - 3, y2 - 3,
                   lightpen, darkpen, grey, recessed)
      -> Inner bevel
      drawbevelbox(x  + 4, y  + 4,
                   x2 - 4, y2 - 4,
                   white, black, grey, recessed)
  ENDSELECT

  SetStdRast(oldrast)
ENDPROC
-><
->> drawbox(rp_ptr:PTR TO rastport, x, y, x2, y2, col)
PROC drawbox(x, y, x2, y2, col)
  Line(x,  y,  x2, y,  col)
  Line(x2, y,  x2, y2, col)
  Line(x2, y2, x,  y2, col)
  Line(x,  y2, x,  y,  col)
ENDPROC
-><
->> drawbevelbox(rp_ptr:PTR TO rastport, x, y, x2, y2, black, white, recessed = FALSE)
PROC drawbevelbox(x, y, x2, y2, black, white, grey, recessed = FALSE)
  Line(x, y2 - 1, x,  y, IF recessed THEN black ELSE white)
  Line(x, y,      x2, y, IF recessed THEN black ELSE white)

  Line(x + 1, y2, x2, y2, IF recessed THEN white ELSE black)
  Line(x2,    y2, x2, y,  IF recessed THEN white ELSE black)

  Plot(x,  y2, grey)
  Plot(x2, y,  grey)
ENDPROC
-><
