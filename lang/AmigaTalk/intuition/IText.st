"---------------------------------------------------"
" IText Class implements control of Amiga IntuiText "
" except for actually displaying it, which is in the"
" Window class.  Class Font uses the same basic     "
" primitive number.                                 "
"---------------------------------------------------"

Class IText :Glyph ! private !
[
   getPens

      ^ <primitive 188 2 0 private> @ <primitive 188 2 1 private>
|
   getTextLength

      ^ <primitive 188 9 private>      "Text length in pixels"
|
   textSize

      " Answer with a Point Object for the length & height of the Text "
      ^ ((self getTextLength) @ (<primitive 188 2 9 private>))
|
   getTextString

      ^ <primitive 188 2 6 private>
|
   getDrawMode

      ^ <primitive 188 2 2 private>
|
   getITextOrigin

      ^ <primitive 188 2 3 private> @ <primitive 188 2 4 private>
|
   getFontName

      ^ <primitive 188 2 5 private>
|
   getNextText

      ^ <primitive 188 2 7 private>
|
   getNextTextObject

      ^ <primitive 188 2 8 private>
|
   setPens: newPensPoint

      <primitive 188 3 0 (newPensPoint x) private>.
      <primitive 188 3 1 (newPensPoint y) private>
|
   setDrawMode: newDrawMode          "JAM1=0, JAM2=1, COMP=2, INV=4"

      <primitive 188 3 2 newDrawMode private> 
|
   setITextOrigin: newPoint

      <primitive 188 3 3 (newPoint x) private>.
      <primitive 188 3 4 (newPoint y) private>
|
   setFont: newFontObject

      <primitive 188 3 5 newFontObject private>
|
   setText: newString

      <primitive 188 3 6 newString private>
|
   setNextText: newNextTextObj

      <primitive 188 3 7 newNextTextObj private>
|
   dispose

      <primitive 188 0 private>. "de-allocate the Object"

      <primitive 250 5 0 private>.

      ^ nil
|
   new: newString

      private <- <primitive 188 1 newString>.

      ^ self
]
