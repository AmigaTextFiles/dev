"--------------------------------------------------"
" Border Class implements control of Amiga Borders."
"--------------------------------------------------"

Class Border :Glyph ! private parent !
[
   dispose

      <primitive 187 0 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   registerTo: parentObject

      " Valid parents are Windows, Screens, Requesters, & Gadgets: "

      parent <- <primitive 187 5 parentObject self>
|
   setStartPoint: sPoint " Set the LeftEdge & TopEdge parameters: "

      <primitive 187 3 0 (sPoint x) private>.
      <primitive 187 3 1 (sPoint y) private>
|
   getStartPoint

      ^ <primitive 187 2 0 private> @ <primitive 187 2 1 private>
|
   getBorderPens

      ^ <primitive 187 2 2 private> @ <primitive 187 2 3 private>
|
   setBorderPens: newPensPoint

      <primitive 187 3 2 (newPensPoint x) private>.
      <primitive 187 3 3 (newPensPoint y) private>
|
   getDrawMode

      ^ <primitive 187 2 4 private>
|
   setDrawMode: newDrawMode

      <primitive 187 3 4 newDrawMode private>
|
   getCount

      ^ <primitive 187 2 5 private>
|
   setCount: newCount

      <primitive 187 3 5 newCount private>
|
   getNextBorder

      ^ <primitive 187 2 6 private>
|
   setNextBorder: newBorder

      <primitive 187 3 6 newBorder private>
|
   setBorderPoint: thePt to: newPoint

      <primitive 187 4 thePt (newPoint x) (newPoint y) private>
|
   draw  " Only if parent is a Screen, Window or Requester: "

      <primitive 187 6 self>
|
   new: numPoints

      private <- <primitive 187 1 numPoints>.

      ^ self
]

"---------------------------------------------------------------------"
" Line Class relies on Class Border to implement a lot of its methods."
"---------------------------------------------------------------------"

Class Line :Border ! private !
[
  makeLineFrom: fPoint to: tPoint

    private <- <primitive 187 1 2>.

    super setBorderPoint: 1 to: fPoint.
    super setBorderPoint: 2 to: tPoint.

    ^ self
]

"---------------------------------------------------"
" Triangle Class relies on Class Border to implement"
" a lot of its methods.                             "
"---------------------------------------------------"

Class Triangle :Border ! private !
[
  makeTriangle: v1Point vert2: v2Point vert3: v3Point

    private <- <primitive 187 1 4>.

    super setBorderPoint: 1 to: v1Point.
    super setBorderPoint: 2 to: v2Point.
    super setBorderPoint: 3 to: v3Point.
    super setBorderPoint: 4 to: v1Point.

    ^ self
]

"----------------------------------------------------"
" Rectangle Class relies on Class Border to implement"
" a lot of its methods.                              "
"----------------------------------------------------"
 
Class Rectangle :Border ! private !
[
  makeRectangleFrom: fPoint to: tPoint ! x1 y1 x2 y2 !

    x1 <- fPoint x.
    y1 <- fPoint y.
    x2 <- tPoint x.
    y2 <- tPoint y.

    private <- <primitive 187 1 5>.
        
    super setBorderPoint: 1 to: x1 @ y1.
    super setBorderPoint: 2 to: x2 @ y1.
    super setBorderPoint: 3 to: x2 @ y2.
    super setBorderPoint: 4 to: x1 @ y2.
    super setBorderPoint: 5 to: x1 @ y1.

    ^ self    
]
