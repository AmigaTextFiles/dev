" ------------------------------------------------------------- "
" Graph.st - Implementation of graph paper class for drawing    "
"            functions in a window.                             "
" ============================================================= "
" scr    = Screen object.                                       "
" win    = Window object.                                       "
" ts     = Screen title (String object).                        "
" tw     = Window title (String object).                        "
" x      = Left edge of Window.                                 "
" y      = Top  edge of Window.                                 "
" w      = Width  of Window.                                    "
" h      = Height of Window.                                    "
" xscale = multiplier for x-coordinates (derived).              "
" yscale = multiplier for y-coordinates (derived).              "
" xinc   = increment size for x-coordinates.                    "
" yinc   = increment size for y-coordinates.                    "
" range  = Interval for x-coordinates (Xmin to Xmax).           "
" domain = Interval for y-coordinates (Ymin to Ymax).           "
" ------------------------------------------------------------- "
" Killed a bug by adding '.' to scr open in open:from:to:       "
" ------------------------------------------------------------- "

Class Graph :Painter
! scr win ts tw x y w h xscale yscale xinc yinc range domain !
[
  initialize: scrTitle winTitle: title  "First method to use:"
    ts     <- scrTitle.
    tw     <- title.

    super new: tw.     "Necessary since we use super Methods."

    range  <- Interval new.
    domain <- Interval new.

    xinc   <- 0.0.
    yinc   <- 0.0.

    xscale <- 1.0.
    yscale <- 1.0
|
  setSizeFrom: orPoint to: brtPoint     "Helper method for open:from:to:"
    scr setOrigin:     orPoint.
    scr setScreenSize: brtPoint.

    win setWindowOrigin: orPoint.
    win setWindowSize:   brtPoint.

    x <- (orPoint  x).
    y <- (orPoint  y).
    w <- (brtPoint x).
    h <- (brtPoint y).
|
  open: screenMode from: oPoint to: brPoint   "Second method to use:"
    scr <- Screen new.
    win <- Window new: tw.
    
    scr openScreen: screenMode title: ts.

    self setSizeFrom: oPoint to: brPoint.
    scr  setDepth: 4.

    win setFlags:     16r11800.  "RMBTRAP | ACTIVATE | BORDERLESS"
    win openOnScreen: ts
|
  refreshGraphPaper
    win refreshWindowFrame
|
  setPen: pen
    super setAPen: pen   "<primitive 200 0 tw pen>"
|
  setXAxisFrom: xmin to: xmax by: deltax
    range from: xmin to: xmax by: deltax.

    xinc   <- deltax.
    xscale <- ((w - x) / (xmax - xmin)).
|
  setYAxisFrom: ymin to: ymax by: deltay
    domain from: ymin to: ymax by: deltay.

    yinc   <- deltay.
    yscale <- ((h - y) / (ymin - ymax))
|
  plotPoint: xpt y: ypt ! p !
    p  <- Point new.

    p x: ((w + (xscale * (xpt - (range  last )))) rounded).
    p y: ((h + (yscale * (ypt - (domain first)))) rounded).

    super drawPixelAt: p "<primitive 200 11 tw (p x) (p y)>"
|
  drawLine: x1 y1: y1 x2: x2 y2: y2 ! p1 p2 !
    
    p1 <- Point new.
    p2 <- Point new.

    p1 x: ((w + (xscale * (x1 - (range  last )))) rounded).
    p1 y: ((h + (yscale * (y1 - (domain first)))) rounded).
    p2 x: ((w + (xscale * (x2 - (range  last )))) rounded).
    p2 y: ((h + (yscale * (y2 - (domain first)))) rounded).
    
    "<primitive 200 6 tw (p1 x) (p1 y) (p2 x) (p2 y)>"
    super drawLineFrom: p1 to: p2.

    win refreshWindowFrame
|
  drawXTick: xp y: yp ! p1 p2 ! "Internal method only."
    p1 <- Point new.
    p2 <- Point new.

    p1 x: ((w +     (xscale * (xp - (range  last )))) rounded).
    p1 y: ((h + 3 + (yscale * (yp - (domain first)))) rounded).
    p2 x: ((w +     (xscale * (xp - (range  last )))) rounded).
    p2 y: ((h - 3 + (yscale * (yp - (domain first)))) rounded).

    "<primitive 200 6 tw (p1 x) (p1 y) (p2 x) (p2 y)>"
    super drawLineFrom: p1 to: p2.

    win refreshWindowFrame
|
  drawYTick: xp y: yp ! p1 p2 ! "Internal method only."
    p1 <- Point new.
    p2 <- Point new.

    p1 x: ((w + 3 + (xscale * (xp - (range  last )))) rounded).
    p1 y: ((h +     (yscale * (yp - (domain first)))) rounded).
    p2 x: ((w - 3 + (xscale * (xp - (range  last )))) rounded).
    p2 y: ((h +     (yscale * (yp - (domain first)))) rounded).

    "<primitive 200 6 tw (p1 x) (p1 y) (p2 x) (p2 y)>"
    super drawLineFrom: p1 to: p2. 

    win refreshWindowFrame
|
  drawGrid: xticks y: yticks color: pen ! tsize t !
    self setPen: pen.
    tsize <- (range last - range first) / xticks.
     
    (1 to: xticks by: 1)
      do: [:ix | t <- ((ix * tsize) + (range first)). "Draw vert' lines:"
            self drawLine: t y1: domain last x2: t y2: domain first 
          ].

    tsize <- (domain last - domain first) / yticks.
    (1 to: yticks by: 1)
      do: [:iy | t <- ((iy * tsize) + (domain first)).
            self drawLine: range first y1: t x2: range last y2: t
          ].

    win refreshWindowFrame
|
  drawXAxis: y0 numTicks: nticks color: pen ! tsize xt !
    (domain inRange: y0)
      ifTrue:  [self setPen: pen.
                self drawLine: (range first) y1: y0 
                           x2: (range last)  y2: y0.

                (nticks > 0)
                  ifTrue: [tsize <- (range last - range first) / nticks.
                           (1 to: nticks by: 1) 
                            do: [:i | xt <- ((i * tsize) + (range first)).
                                  self drawXTick: xt y: y0
                                ].
                          ]
               ]
      ifFalse: ['X-Axis outside domain!' print].

    win refreshWindowFrame
|
  drawYAxis: x0 numTicks: nticks color: pen ! tsize yt !
    (range inRange: x0)
      ifTrue:  [self setPen: pen.
                self drawLine: x0 y1: (domain first)
                           x2: x0 y2: (domain last).

                (nticks > 0)
                  ifTrue: [tsize <- (domain last - domain first) / nticks.
                           (1 to: nticks by: 1) 
                            do: [:i | yt <- ((i * tsize) + (domain first)).
                                  self drawYTick: x0 y: yt
                                ].
                          ]
               ]
      ifFalse: ['Y-Axis outside range!' print].

    win refreshWindowFrame
|
  drawLabel: labelstr at: aPoint
    "<primitive 200 19 tw labelstr (aPoint x ) (aPoint y)>"
    super drawText: labelstr at: aPoint.

    win refreshWindowFrame
|
  tellScales
    ( 'Scales are:  xscale = ', xscale, ', yscale = ', -1 * yscale ) print
|
  tellRange
    ('Range  is ', (range first asString), '<->',
                   (range last  asString)) print
|
  tellDomain
    ('Domain is ', (domain first asString), '<->',
                   (domain last  asString)) print
|
  xScale
    ^ xscale
|
  yScale
    ^ -1 * yscale
|
  range
    ^ ((range first asString), '<->', (range last asString))
|
  domain
    ^ ((domain first asString), '<->', (domain last asString))
|
  close
    win close.
    scr close.

    ^ nil
]
