"---------------------------------------------------------------"
" BitMap Class implements control of Amiga BitMaps.             "
" ------------------------------------------------------------- "
" See BitMapFlags class after this class for valid values for   "
" Flags "

" Test file:
  bmap   <- BitMap      new
  bflags <- BitMapFlags new
 
  flags <-         bflags bitMapFlag: #BMF_DISPLAYABLE
  flags <- flags + bflags bitMapFlag: #BMF_INTERLEAVED
  flags <- flags + bflags bitMapFlag: #BMF_STANDARD
              
  bmap setBitMapWidth:  540
  bmap setBitMapHeight: 90
  bmap setBitMapDepth:  8
  bmap setBitMapFlags:  flags
  bmap makeBitMap
  ...
  bmap dispose
"
" More methods to obtain data from the system have to be added, "
" such as reading IFF files & transforming them into something  "
" that this class can use to write it's own custom files.       "
"---------------------------------------------------------------"

Class BitMap :Glyph  ! private width height depth flags !
[
   dispose

      <primitive 189 0 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   getBitMapWidth
      ^ width <- <primitive 189 2 0 private>
|
   getBitMapHeight
      ^ height <- <primitive 189 2 1 private>
|
   getBitMapFlags
      ^ flags <- <primitive 189 2 2 private>
|
   getBitMapDepth
      ^ depth <- <primitive 189 2 3 private>
|
   changeBitMapWidth: newWidth
      <primitive 189 3 0 newWidth private>.
      width <- newWidth
|
   changeBitMapHeight: newHeight
      <primitive 189 3 1 newHeight private>.
      height <- newHeight
|
   changeBitMapFlags: newFlags
      <primitive 189 3 2 newFlags private>.
      flags <- newFlags
|
   changeBitMapDepth: newDepth
      <primitive 189 3 3 newDepth private>.
      depth <- newDepth
|
   changeDataTo: longWord at: offset
      ^ <primitive 189 10 longWord offset private>
|
   readBitMapFile: bitMapFileName
      (<primitive 189 4 bitMapFileName private> == false)
         ifTrue: [ ^ nil ].

      width  <- <primitive 189 2 0 private>.
      height <- <primitive 189 2 1 private>.
      flags  <- <primitive 189 2 2 private>.
      depth  <- <primitive 189 2 3 private>.

      ^ self
|
   writeBitMapFile: bitMapFileName
      <primitive 189 5 bitMapFileName private>
|
   setBitMapWidth: newWidth
      width <- newWidth
|
   setBitMapHeight: newHeight
      height <- newHeight

|
   setBitMapFlags: newFlags
      flags <- newFlags
|
   setBitMapDepth: newDepth
      depth <- newDepth
|
   makeBitMap
      private <- <primitive 189 1 width height depth flags>.
      ^ self
|
   getBitMapObject
      ^ private
|
   stealBitMapFromWindow: windowObj
      private <- <primitive 189 6 windowObj>.
      ^ private
|
   stealBitMapFromScreen: screenObj
      private <- <primitive 189 7 screenObj>.
      ^ private
|
   stealBitMapFromWindowTitled: windowTitle
      private <- <primitive 189 8 windowTitle>.
      ^ private
|
   stealBitMapFromScreenTitled: screenTitle
      private <- <primitive 189 9 screenTitle>.
      ^ private
]

" ------------------------------------------------------------------- "
" BitMapFlags Class is a Singleton class that allows the user to      "
" reference BitMap Flags' hexadecimal values.                         "
""
" ALL singleton classes MUST contain the following:                   "
""
"   the methods:  isSingleton AND privateSetup     AND                "
"                 uniqueInstance Class instance variable.             "
" ------------------------------------------------------------------- "

Class BitMapFlags :Dictionary ! uniqueInstance !
[
   isSingleton
     ^ true  
|
   bitMapFlag: keySymbol
     ^ (self at: keySymbol)  
|
   privateNew ! newinstance !
     newinstance <- super new.

     ^ newinstance
|
   new
     ^ self privateSetup
|
   privateSetup
     (uniqueInstance isNil)
       ifTrue: [uniqueInstance <- self privateNew.

                " flags for AllocBitMap, etc. "

                self at: #BMF_CLEAR       put: 1.
                self at: #BMF_DISPLAYABLE put: 2.
                self at: #BMF_INTERLEAVED put: 4.
                self at: #BMF_STANDARD    put: 8.
                self at: #BMF_MINPLANES   put: 16.

                " the following are for GetBitMapAttr() "

                self at: #BMA_HEIGHT      put: 0.
                self at: #BMA_DEPTH       put: 4.
                self at: #BMA_WIDTH       put: 8.
                self at: #BMA_FLAGS       put: 12.
               ].
               
     ^ self    "or ^ uniqueInstance??"
]
