" ----------------------------------------------------------------------- "
" Console Class implements control of the console.device.                 "
""
"  WARNING:  You should know what you're doing to the Amiga OS before     "
"            messing with this Class, or any other System Class!          "
" ----------------------------------------------------------------------- "

Class Console :Device ! private myWindow !
[
   dispose

     <primitive 222 0 0 private>.
     
     <primitive 250 5 0 private>.

     ^ nil
|
   initialize: consoleName for: aWindow

     private  <- <primitive 222 0 1 aWindow consoleName>.

     myWindow <- aWindow.
     
     ^ self
|
   backSpace 
     self putChar: (8 asCharacter) 
|
   formFeed
     self putChar: (12 asCharacter) 
|
   lineFeed
     self putChar: (10 asCharacter) 
|
   carriageReturn
     self putChar: (13 asCharacter) 
|
   bell
     self putChar: (7 asCharacter)
|
   crlf
     self carriageReturn.
     self lineFeed
|
   cursorToHome
     self putString: (self csi, 'H')
|
   moveCursorTo: aPoint ! moveCode x y !
     x <- aPoint x.
     y <- aPoint y.
     
     moveCode <- (self csi, y asString, ';', x asString, 'H').

     self putString: moveCode
|
   nextLineStart   " Go to beginning of next line: "
     self putChar: (16r85 asCharacter)
|
   prevLineStart   " Go to beginning of previous line: "
     self putString: (self csi, '1F')
|
   moveCursorUp: numlines
     self putString: (self csi, (numlines asString), 'A')
|
   moveCursorDown: numlines
     self putString: (self csi, (numlines asString), 'B')
|
   moveCursorRight: numChars
     self putString: (self csi, (numChars asString), 'C')
|
   moveCursorLeft: numChars
     self putString: (self csi, (numChars asString), 'D')
|
   insertLineBelowCurrent
     self putString: (self csi, 'L')
|
   insertSpaces: numSpaces
     self putString: (self csi, (numSpaces asString), '@')
|
   deleteCurrentLine
     self putString: (self csi, 'M')
|
   deleteCurrentChar
     self putString: (self csi, '0P')
|
   deleteCharacters: howMany
     self putString: (self csi, (howMany asString), 'P')
|
   normalChars
     self putString: (self csi, '0m')
|
   boldChars
     self putString: (self csi, '1m')
|
   boldCharsOff
     self putString: (self csi, '22m')
|
   italicChars
     self putString: (self csi, '3m')
|
   italicCharsOff
     self putString: (self csi, '23m')
|
   underlineChars
     self putString: (self csi, '4m')
|
   underlineCharsOff
     self putString: (self csi, '24m')
|
   invertedChars
     self putString: (self csi, '7m')
|
   invertedCharsOff
     self putString: (self csi, '27m')
|
   invisibleText
     self putString: (self csi, '8m')
|     
   visibleText
     self putString: (self csi, '28m')
|     
   cursorInvisible
     self putString: (self csi, '0 p')
|
   cursorVisible
     self putString: (self csi, ' p')
|
   textColor: colorNumber
     " Valid values for colorNumber are: 0 to 7 and 9 (default color): "

     self putString: (self csi, ((colorNumber + 30) asString), 'm')
|
   backgroundColor: colorNumber
     " Valid values for colorNumber are: 0 to 7 and 9 (default color): "

     self putString: (self csi, ((colorNumber + 40) asString), ';>',
                                ((colorNumber + 30) asString), 'm').
|
   enableScroll
     self putString: (self csi, '>1h')
|
   disableScroll
     self putString: (self csi, '>1l')
|
   autoWrapOff
     self putString: (self csi, '?7l')
|
   autoWrapOn        " Default is autoWrap ON "
     self putString: (self csi, '?7h')
|
   setPageLength: rasterLines
     self putString: (self csi, (rasterLines asString), 't')
|
   setLineLength: charPositions
     self putString: (self csi, (charPositions asString), 'u')
|
   setLeftOffset: rasterColumns
     self putString: (self csi, (rasterColumns asString), 'x')
|
   setTopOffset: rasterLines 
     " Take care, you could end up in the window Title Bar! "
     self putString: (self csi, (rasterLines asString), 'y')
|
   clearTabs
     self putString: (self csi, '5W')
|
   clearTab
     self putString: (self csi, '2W')
|
   setTab
     self putString: (self csi, '0W')
|
   backTab
     self putString: (self csi, '1Z')
|
   tab
     self putChar: (9 asCharacter)
|
   forwardTabs: numTabs
     self putString: (self csi, (numTabs asString), 'I')
|
   reset: devName " Override parent method "
     self reset
|
   esc                       " Return ESCAPE as a String: "
     ^ <primitive 96 16r1B>
|
   reset     
     self putString: (self esc, 'c')
|
   clear
     self putString: (self esc, '2J')
|
   clearToBottom
     self putString: (self esc, '0J')
|
   getChar
     ^ <primitive 222 0 2 private>
|
   getString
     ^ <primitive 222 0 3 private>
|
   putChar: aCharacter
     <primitive 222 0 4 private aCharacter>
|
   putStringNoReturn: aString
     <primitive 222 0 5 private aString>
|
   putString: aString
     <primitive 222 0 5 private aString>.
      self crlf
|
   csi                       " Return CSI as a String: "
     ^ <primitive 96 16r9B>
]
