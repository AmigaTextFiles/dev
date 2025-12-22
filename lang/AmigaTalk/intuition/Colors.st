"------------------------------------------------------------------"
" Colors Class implements control of Amiga Color registers         "
" Chances are that Glyph is the wrong parent class for this class. "
"------------------------------------------------------------------"

Class Colors :Glyph ! private parentObj numberOfColors !
[
   dispose

      <primitive 184 0 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   loadColors: howMany from: colorMapFileName

      <primitive 184 2 parentObj howMany colorMapFileName>
|
   getColor: srcType from: srcObject which: n  

      " srcType 1 is WindowObject, all else is colorMapObject: "

      ^ <primitive 184 3 srcType srcObject n>
|
   setColorReg: n red: r green: g blue: b

      <primitive 184 4 parentObj n r g b>
|
   setMapValue: srcType from: srcObject num: n red: r green: g blue: b

      " srcType 1 is WindowObject, all else is colorMapObject: "

      <primitive 184 5 srcType srcObject n r g b>
|
   copyMap: sourceObject to: destObject sourceType: srcType

      " srcType 1 is WindowObject  (dest is ColorMap)
      * all else is colorMapObject (dest is WindowObject): 
      "

      <primitive 184 6 sourceObject destObject srcType>
|
   saveColorsTo: colorMapFileName

      <primitive 184 7 parentObj colorMapFileName>
| 
   makeColorMap: numColors

      private        <- <primitive 184 1 private numColors>.

      numberOfColors <- numColors.
      
      ^ self
|
   new: windowObject

      parentObj  <- windowObject.    "cmap <- Colors new: windowObj"
      private    <- nil.             " makeColorMap: will initialize this"

      ^ self
]

"------------------------------------------------------------------"
" LargeColors Class implements control of Amiga Color registers    "
" using full 32-bit values for red, green & blue.                  "
" Chances are that Glyph is the wrong parent class for this class. "
"------------------------------------------------------------------"

Class LargeColors :Glyph ! private private2 parentObj numberOfColors !
[
   dispose

      <primitive 184 0 private>.
      
      <primitive 250 5 0 private>.

      (private2 notNil)
         ifTrue: [ <primitive 250 5 0 private2> ].
      
      ^ nil
|
   copyMap: sourceObject to: destObject sourceType: srcType

      " srcType 1 is WindowObject  (dest is ColorMap)
      * all else is colorMapObject (dest is WindowObject): 
      "

      <primitive 184 6 sourceObject destObject srcType>
|
   saveColorsTo: colorMapFileName

      <primitive 184 7 parentObj colorMapFileName>
|
   findColorMatch: red green: green blue: blue
    
      " Find the closest matching color to the RGB values given: "

      ^ <primitive 184 8 red green blue private> 
|
   obtainBestPenMatch: red green: green blue: blue tags: tagArray
   
      " Find the closest matching color or allocate one.
      *
      * Valid values for the tagArray are:
      * OBP_Precision - specifies the desired precision for the
      *                 match. Should be PRECISION_GUI, PRECISION_ICON, or
      *                 PRECISION_IMAGE or PRECISION_EXACT.
      *                 Defaults to PRECISION_IMAGE.
      *
      * OBP_FailIfBad - specifies that you want obtainBestPenMatch: to return 
      *                 a failure value if there is not a color within the
      *                 given tolerance, instead of returning the closest color.
      *                 With OBP_FailIfBad==FALSE, obtainBestPen: will only fail
      *                 if the ViewPort contains no sharable colors.
      *                 Defaults to FALSE.
      *
      * NOTE: be sure to use the releasePen: method on the
      * returned value from this method when you are done with it! 
      "
      
      ^ <primitive 184 9 red green blue tagArray private>
|
   obtainPen: red green: green blue: blue flags: flags
   
      " Obtain a free palette entry (if any are left).
      * NOTE: be sure to use the releasePen: method on the
      * returned value from this method when you are done with it! 
      "
      
      ^ <primitive 184 10 red green blue flags private>
|
   releasePen: whichPen
   
      " You MUST use this method for each pen Number returned from
      * obtainBestPenMatch:green:blue:tags: & 
      * obtainPen:green:blue:flags: methods when you are done with
      * them:
      "
      <primitive 184 14 whichPen private> 
|
   getRGB32: firstPen howMany: numColors into: colorArray
   
      " Get a series of color register values & palce them in 
      * colorArray.
      *
      * WARNING:  The size of colorArray MUST be at least 
      * 3 * numColors in length or this method will
      * fail with error messages:
      "
      <primitive 184 11 firstPen numColors colorArray private>
|
   makeColorTable: firstPen howMany: numColors with: colorArray
   
      " Create & format an Array that can be used by the 
      * loadRGB32 method (This is NOT the same as the colorArray 
      * found in the getRGB32:howMany:into: as far as I know!) 
      *
      * The colorArray you supply to this method consists of:
      *
      *    red1 (32-bit), green1 (32-bit), blue1 (32-bit),
      *    ...
      *    redn (32-bit), greenn (32-bit), bluen (32-bit)
      * Triplets
      "
      ^ private2 <- <primitive 184 12 firstPen numColors colorArray>
|
   loadRGB32
   
      " Set a series of color registers for this instance using the
      * colorTable obtained from makeColorTable:howMany:with:
      * method:
      "  
      <primitive 184 13 parentObj private2>
|
   attachExtraPaletteInfo
   
      " Allocate & attach extra palette info to the ColorMap
      * (The dispose method will take care of this): 
      "
      <primitive 184 15 private parentObj>
|
   makeColorMap: numColors

      private        <- <primitive 184 1 private numColors>.

      numberOfColors <- numColors.
      
      ^ self
|
   new: windowObject

      parentObj <- windowObject. "cmap <- Colors new: windowObj"

      private   <- nil. " makeColorMap: will initialize this"
      
      private2  <- nil. " makeColorTable:howMany:with: will initialize this"
      
      ^ self
]

