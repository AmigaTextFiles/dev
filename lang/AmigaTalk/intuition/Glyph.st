"-------------------------------------------------------------------"
" Glyph Class is just an abstract class that ties together all Amiga"
" Graphics-related Classes & answers general questions about Glyphs."
"-------------------------------------------------------------------"

Class Glyph :Object
[
   glyphType

      super subclassResponsibility: 'glyphType'

      "self error: 'This message should be implemented in a SubClass!'"
|
   isDisplayed

       super subclassResponsibility: 'isDisplayed'

      "self error: 'This message should be implemented in a SubClass!'"
]
