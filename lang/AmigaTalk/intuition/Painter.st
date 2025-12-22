" ---------------------------------------------------- "
" Painter Class implements simple graphics primitives  "
" ---------------------------------------------------- "

Class Painter :Glyph 
! ownerWindow private fPen bPen oPen drawMode linePattern x y !
[
   setAPen: pen

      <primitive 200 0 ownerWindow pen>.
      
      fPen <- pen
|
   setBPen: pen

      <primitive 200 1 ownerWindow pen>.
      
      bPen <- pen
|
   setOPen: pen

      <primitive 200 2 ownerWindow pen>.
      
      oPen <- pen
|
   setDrawMode: mode

      <primitive 200 3 ownerWindow mode>.
      
      drawMode <- mode
|
   setLinePattern: newPatternMask

      <primitive 200 21 ownerWindow newPatternMask>.
      
      linePattern <- newPatternMask
|
   getPens

      ^ fPen @ bPen
|
   getOPen

      ^ oPen
|
   getDrawMode

      ^ drawMode
|
   location

      ^ x @ y
|
   ownerIs

      ^ ownerWindow
|
   movePenTo: newPoint

      <primitive 200 4 ownerWindow (newPoint x) (newPoint y)>.
      
      x <- newPoint x.
      y <- newPoint y
|
   drawTo: aPoint

      <primitive 200 5 ownerWindow (aPoint x) (aPoint y)>.
      
      x <- aPoint x.
      y <- aPoint y
|
   drawLineFrom: fPoint to: tPoint ! xt yt !

      xt <- tPoint x.
      yt <- tPoint y.
      
      <primitive 200 6 ownerWindow (fPoint x) (fPoint y) xt yt>
|
   drawBoxFrom: fPoint to: tPoint

      <primitive 200 7 ownerWindow (fPoint x) (fPoint y) (tPoint x) (tPoint y)>
|
   drawCircle: cPoint radius: r

      <primitive 200 8 ownerWindow (cPoint x) (cPoint y) r>
|
   drawEllipse: cPoint minaxis: a maxaxis: b

      <primitive 200 9 ownerWindow (cPoint x) (cPoint y) a b>
|
   drawPolygon: borderObj         " borderObjects are NOT necessarily Polygons! "

      <primitive 200 10 ownerWindow borderObj>

      "or <primitive 187 6 ownerWindow borderObj>"
|
   drawPixelAt: aPoint

      <primitive 200 11 ownerWindow (aPoint x) (aPoint y)>.
      
      x <- aPoint x.
      y <- aPoint y
|
   drawText: text at: aPoint        " Sorry, no font control for this "

      <primitive 200 19 ownerWindow text (aPoint x ) (aPoint y)>
|
   initializeArea: numPoints tmpXSize: xSize tmpYSize: ySize

      " You MUST use this method BEFORE using any of the Area/Filled methods
      * down to disposeArea:y: (which MUST be used after you're done
      * with the Area/Filled method(s).  x & y should specify the dimensions
      * of the largest rectangular area that will be drawn:
      "
      ^ private <- <primitive 200 33 ownerWindow numPoints xSize ySize>
|
   drawFilledEllipse: cPoint minaxis: a maxaxis: b

      ^ <primitive 200 25 ownerWindow (cPoint x) (cPoint y) a b>
|
   drawFilledCircle: cPoint radius: r

      ^ <primitive 200 26 ownerWindow (cPoint x) (cPoint y) r>
|
   areaMoveTo: newPoint

      " same as movePenTo: method, only for Area/Filled methods "
      <primitive 200 27 ownerWindow (newPoint x) (newPoint y)>.
      
      x <- newPoint x.
      y <- newPoint y
|
   areaDrawTo: aPoint

      " same as drawTo: method, only for Area/Filled methods "
      <primitive 200 28 ownerWindow (aPoint x) (aPoint y)>.
      
      x <- aPoint x.
      y <- aPoint y
|
   drawFilledBoxFrom: fPoint to: tPoint

      " This uses the RectFill() function: "
      <primitive 200 29 ownerWindow (fPoint x) (fPoint y) (tPoint x) (tPoint y)>
|
   floodFill: mode at: aPoint

      " If mode is 0 (outline mode), every pixel surrounding aPoint that is
      * NOT the outline Pen color will be changed to the flood Pen color (or
      * flood pattern).  If the mode is 1 (color mode), whatever the color is
      * at aPoint and all surrounding pixels of the same color will be flood-
      * filled.  Returns true or false:
      "
      ^ <primitive 200 30 ownerWindow mode (aPoint x) (aPoint y)>.
|   
   areaEnd

      " Complete the Area/Filled polygons.  Use this after
      * areaDrawTo:, drawFilledEllipse:minaxis:maxaxis:, 
      * & drawFilledCircle:radius: only
      "
      ^ <primitive 200 31 ownerWindow>
|
   setAreaPattern: patternWords size: size

      " patternWords is a ByteArray that is divisible by two.  Each pair of
      * bytes in patternWords is interpreted as a UWORD value.
      * size is a power of two, indicating how tall the pattern is, 
      * which means that the number of elements in patternWords must 
      * be 2 * 2 ^ size.
      * (example: 0 = two ByteArray elements (1 line), 
      * 1 = four elements (2 lines), 
      * 2 = 4 lines, 3 = 8 lines, 4 = 16, etc).  No checking is done, 
      * so get it right (or write your own method!).
      "
      <primitive 200 32 ownerWindow patternWords size>        
|
   outlineOff

      " Part of the Area/Filled methods (turn off outlining areas). "
      <primitive 200 35 ownerWindow>
|
   outlineOn

      " Part of the Area/Filled methods (turn on outlining areas). "
      <primitive 200 36 ownerWindow>
|
   disposeArea: xSize y: ySize

      " xSize & ySize MUST be the same dimensions that were used in the
      * initializeArea:tmpXSize:tmpYSize: method:
      "
      <primitive 200 34 ownerWindow private xSize ySize> 
|
   new: newOwnerWindow

      ownerWindow <- newOwnerWindow.
      
      ^ self
]

"----------------------------------------------------"
" Image Class implements Image graphics primitives   "
"----------------------------------------------------"

Class Image :Glyph ! private ownerWindow !
[
   ownerIs

      ^ ownerWindow
|
   getStartPoint ! left top !

      left <- <primitive 200 14 ownerWindow 0 private>.
      top  <- <primitive 200 14 ownerWindow 1 private>.
      
      ^ left @ top
|
   getImageSize ! width height !

      width  <- <primitive 200 14 ownerWindow 2 private>.
      height <- <primitive 200 14 ownerWindow 3 private>.
      
      ^ width @ height
|
   setOrigin: aPoint ! x y !

      x <- aPoint x.
      y <- aPoint y.
      
      <primitive 200 15 ownerWindow 0 x private>.
      <primitive 200 15 ownerWindow 1 y private>
|
   setExtent: sizePoint ! w h !

      w <- sizePoint x.
      h <- sizePoint y.
      
      <primitive 200 15 ownerWindow 2 w private>.
      <primitive 200 15 ownerWindow 3 h private>
|
   setImageDepth: d

      <primitive 200 15 ownerWindow 4 d private>
|
   drawImageAt: aPoint

      <primitive 200 16 ownerWindow (aPoint x) (aPoint y) private>
|
   drawImageAt: aPoint inState: state

      " Valid values for state are:
      *
      *   0 = IDS_NORMAL:           // like drawImageAt:
      *   1 = IDS_SELECTED:         // represents the 'selected state' of a Gadget
      *   2 = IDS_DISABLED:         // the 'ghosted state' of a gadget
      *   3 = IDS_BUSY:             // for future functionality
      *   4 = IDS_INDETERMINATE:    // for future functionality
      *   5 = IDS_INACTIVENORMAL:   // for gadgets in window border
      *   6 = IDS_INACTIVESELECTED: // for gadgets in window border
      *   7 = IDS_INACTIVEDISABLED: // for gadgets in window border
      *   8 = IDS_SELECTEDDISABLED: // disabled and selected
      "
      <primitive 200 22 ownerWindow private state (aPoint x) (aPoint y)>
|
   setImageDataFrom: imageFile

      <primitive 200 17 ownerWindow imageFile private>
|
   saveImageIn: imageFile

      " true indicates that the Image was saved: "
      ^ <primitive 200 18 ownerWindow imageFile private>
|
   getImageDepth

      ^ <primitive 200 14 ownerWindow 4 private>
|
   getImagePlanePick

      ^ <primitive 200 14 ownerWindow 6 private>
|
   getImagePlaneOnOff

      ^ <primitive 200 14 ownerWindow 7 private>
|
   getNextImage

      ^ <primitive 200 14 ownerWindow 8 private>
|
   setImagePlanePick: pp

      <primitive 200 15 ownerWindow 6 pp private>
|
   setImagePlaneOnOff: po

      <primitive 200 15 ownerWindow 7 po private>
|
   setNextImage: newNextImage

      <primitive 200 15 ownerWindow 8 newNextImage private>
|
   grabImageFrom: windowObj startPoint: s endPoint: e ! x1 y1 x2 y2 !

      x1 <- s x.
      y1 <- s y.
      x2 <- e x.
      y2 <- e y.
      
      ^ <primitive 200 20 windowObj x1 y1 x2 y2 private>      
|
   pointInImage: testPoint

      ^ <primitive 200 23 private (testPoint x) (testPoint y)>
|
   registerTo: newWindowObject

      ownerWindow <- newWindowObject
|
   addImage: width height: h depth: d

      private <- <primitive 200 13 ownerWindow width h d>.

      ^ self
|
   eraseImageStartingAt: aPoint

      <primitive 200 24 ownerWindow private (aPoint x) (aPoint y)>
|
   disposeImage

      <primitive 200 12 private>.
      
      ^ nil
]
