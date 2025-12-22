"----------------------------------------------"
" Font Class implements control of Amiga Fonts."
" Font in this class is equivalent to TextAttr."
"----------------------------------------------"

Class Font :Glyph ! private myFontName diskFont !
[
   openFont: newFontName size: fontSize style: theFontStyle

      self    xxxNew: newFontName.

      self fontYSize: fontSize.
      
      self fontStyle: theFontStyle. 
      
      diskFont <- <primitive 188 8 private>.

      ^ self
|
   closeFont

      <primitive 188 10 diskFont>.

      ^ self xxxDispose      
|
   fontAttributes

      ^ private
|
   fontName

      ^ myFontName <- <primitive 188 6 0 private> "return ta_Name"
|
   fontName: newName

      <primitive 188 7 0 newName private>.   "set ta_Name"
      
      myFontName <- newName 
|
   fontYSize

      ^ <primitive 188 6 1 private>          "return ta_YSize"
|
   fontYSize: newYSize

      <primitive 188 7 1 newYSize private>   "set ta_YSize"
|
   fontStyle

      ^ <primitive 188 6 2 private>          "return ta_Style"
|
   fontStyle: newStyle

      <primitive 188 7 2 newStyle private>   "set ta_Style"

      "NORMAL=0, UNDERLINED=1, BOLD=2, ITALIC=4"
|
   fontFlags

      ^ <primitive 188 6 3 private>          "return ta_Flags"
|
   fontFlags: newFlags

      <primitive 188 7 3 newFlags private>   "set ta_Flags"

      "ROMFONT=1, DISKFONT=2, REVPATH=4, TALLDOT=8, WIDEDOT=16"
      "PROPORTIONAL=32, DESIGNED=64, REMOVED=128"
|
   xxxDispose

      <primitive 188 4 private>.

      <primitive 250 5 0 private>.
      
      ^ nil
|
   xxNew: newFontName                " example:  'topaz.font' "

      private    <- <primitive 188 5 newFontName>.

      myFontName <- newFontName.

      ^ self
]
