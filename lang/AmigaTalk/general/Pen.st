"-------------------------------------------------------------"
"  the following use the primitives interfacing to the plot(3)"
"  routines.                                                  "
"           pen - a simple drawing instrument                 "
"-------------------------------------------------------------"

Class Pen :Object
! title x y angle width height fpen bpen !
[
   movePlotEnvBy: deltaPoint
      <primitive 169 2 title (deltaPoint x) (deltaPoint y)>.
      ^ self
|
   setLineType: bitPattern
      <primitive 179 bitPattern>.
      ^ self
|
   drawText: text at: aPoint
      <primitive 178 text (aPoint x) (aPoint y) fpen bpen>.
      x <- (aPoint x).
      y <- (aPoint y).
      ^ self
|
   drawBox: fromPoint to: toPoint
      <primitive 175 (fromPoint x) (fromPoint y) (toPoint x) (toPoint y)>.
      x <- (toPoint x).
      y <- (toPoint y).
      ^ self
|
   drawCircleAt: aPoint radius: r
      <primitive 174 (aPoint x) (aPoint y) r>.
      x <- (aPoint x).
      y <- (aPoint y).        "Leave us at the center of the circle."
      ^ self
|
   circleRadius: rad         "Draw a circle centered at current location."
      <primitive 174 x y rad>.
      ^ self
|
   drawArcAround: pivotPoint for: angleSize
      " angleSize is expressed in Radians. "
      (angleSize isKindOf: Radian)
         ifTrue: [ <primitive 168 x y (angleSize asFloat) (pivotPoint x) (pivotPoint y) > ].
         
      ^ self
|
   drawArcAt: startPoint around: pivotPoint for: angleSize
      " angleSize is expressed in Radians. "
      (angleSize isKindOf: Radian)
         ifTrue: [<primitive 168 (startPoint x) (startPoint y)
                                 (angleSize asFloat) (pivotPoint x) (pivotPoint y) > ].
      ^ self
|
   drawTo: aPoint
      <primitive 172 (aPoint x) (aPoint y)>.
      x <- (aPoint x).
      y <- (aPoint y).
      ^ self
|
   goTo: aPoint
      <primitive 171 (aPoint x) (aPoint y)>.
      x <- aPoint x.
      y <- aPoint y.
      ^ self
|
   drawLine: fromPoint to: toPoint
      <primitive 177 (fromPoint x) (fromPoint y) (toPoint x) (toPoint y)>.
      x <- (toPoint x).
      y <- (toPoint y).
      ^ self
|
   drawPoint: aPoint
      <primitive 173 (aPoint x) (aPoint y)>.
      x <- (aPoint x).
      y <- (aPoint y).
      ^ self
|
   direction             "Which way are we going?" 
      ^ angle
|
   direction: radians    "Set the direction to go."
      angle <- radians.
      ^ self
|
   erase                 "Blank out the Current PlotEnv Window."
      <primitive 170>.
      ^ self
|
   extent                "Tell User how large the Plot area is."
      ^ width @ height
|
   location              "Tell User where the pen is."
      ^ x @ y
|
   titleIs
      ^ title
|
   center                "goTo the center of the Plot region."
      self goTo: (width / 2) @ (height / 2).
      ^ self
|
   tellPens              "Tell User which pens are being used."
      ^ fpen @ bpen.
      ^ self
|
   setPens: penSet       "penSet is of Class Point (front @ back)."
      <primitive 176 (penSet x) (penSet y)>.
      fpen <- (penSet x).
      bpen <- (penSet y).
      ^ self
|
   go: anAmount ! newx newy !
      (angle isKindOf: Radian)
        ifTrue:  [newx <- ((angle sin) * anAmount) rounded + x.
                  newy <- ((angle cos) * anAmount) rounded + y
                 ]
        ifFalse: [newx <- (((angle radians) sin) * anAmount) rounded + x.
                  newy <- (((angle radians) cos) * anAmount) rounded + y
                 ].

      self drawTo: newx @ newy.  "go: leaves drawn pixels as it moves."
      ^ self
|
   turn: addedRadians
      angle <- angle + addedRadians.
      ^ self
|
   new
      title  <- 'Unknown Plot'. 
      angle  <- Radian new: 0.
      x      <- 160.
      y      <- 100.
      width  <- 320.
      height <- 200.
      fpen   <- 1.
      bpen   <- 0.
      ^ self
|
   new: newPlotTitle            "We want a unique Plot Title!"
      (newPlotTitle isKindOf: String)
         ifTrue:  [ title <- newPlotTitle  ]
         ifFalse: [ title <- 'Unknown Plot'].

      angle  <- Radian new: 0.
      x      <- 160.
      y      <- 100.
      width  <- 320.
      height <- 200.
      fpen   <- 1.
      bpen   <- 0.
      ^ self
|
   openPlotEnv: sizePoint ! nx ny !
      nx <- sizePoint x.
      ny <- sizePoint y.
       
      (<primitive 169 1 title nx ny> == true)
         ifFalse:  [ self error: 'openPlotEnv ', title, ' did NOT open!'. 
                     ^ nil
                   ]
         ifTrue:   [ angle  <- Radian new: 0.
                     x      <- (nx / 2).
                     y      <- (ny / 2).
                     width  <- nx.
                     height <- ny.
                     ^ self
                   ]
|
   closePlotEnv: whichPlotTitle
      (<primitive 169 0 whichPlotTitle> == true)
        ifFalse: [self error: 'PlotEnv ',whichPlotTitle,' did NOT close!'.
                  ^ self
                 ].
      ^ nil
]

"----------------------------------------------------"
" FormPen - a collection of lines                    "
" I don't think this class will work as written (JTS)"
"----------------------------------------------------"

Class FormPen :Pen
! lines !
[
   new
      lines <- Bag new
|
   add: startingPoint to: endingPoint "Methinks this is broken:"
      lines add: ( Point new ; x: startingPoint ; y: endingPoint ).
      ^ self
|
   with: aPen displayAt: location ! xOffset yOffset sPoint ePoint !
      xOffset <- (location x).
      yOffset <- (location y).

      lines do: [:pair |

         sPoint <- (pair x).
         ePoint <- (pair y).

         aPen   goTo: (sPoint x + xOffset) @ (sPoint y + yOffset).
         aPen drawTo: (ePoint x + xOffset) @ (ePoint y + yOffset).
         ].

      ^ self
]

"----------------------------------------------------"
" SavePen - a way to save the drawings made by a pen "
"----------------------------------------------------"

Class SavePen :FormPen
! saveForm !
[
   setForm: aForm
      saveForm <- aForm.
      ^ self
|
   goTo: aPoint
      super    goTo: aPoint.
      saveForm  add: (self location) to: aPoint.
      super    goTo: aPoint.
      ^ self
]

"-----------------------------------------------------"
" ShowPen - show off some of the capabilities of pens."
"-----------------------------------------------------"

Class ShowPen :Object
! bic !
[
   withPen: aPen "aPen has to be init'd & open before using these methods."
      bic <- aPen.
      ^ self
|
   poly: nSides length: length
      nSides timesRepeat:  [ bic   go: length.
                             bic turn: (6.2831853 / nSides)  "2 PI"
                           ].
      ^ self
|
   spiral: n angle: a
      (1 to: n) do: [:i | bic go: i. bic turn: a].
      ^ self
]
