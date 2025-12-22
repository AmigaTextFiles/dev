" ------------------------------------------------------------- "
" Curses.st - Implementation of Curses library functions for    "
"              AmigaTalk.                                       "
" ------------------------------------------------------------- "

Class Curses :Object ! windowCount !
[
  new
    windowCount <- 0.
    ^ self
|
  initialize
    <primitive 124 1>. " initscr() "
    ^ self
|
  closeDown
    ^ <primitive 124 0> " endwin() "
|
  initializeWithColors: depth
    <primitive 124 7 depth>.    " StartColor( depth) "
    <primitive 124 1>.          " initscr()          "
    ^ self
|
  initWithStdColors
    <primitive 124 7>.    " start_colors() "
    <primitive 124 1>.    " initscr()      "
    ^ self
|
  openWindow: xStart yStart: y width: w height: h ! temp !
    (windowCount < 50)
      ifTrue: [ temp <- <primitive 124 2 h w y xStart>. " newwin() "
                windowCount <- windowCount + 1.
                ^ temp
              ]
|
  openSubWindow: parent xStart: x yStart: y width: w height: h ! temp ! 
    (windowCount < 50)
      ifTrue: [ temp <- <primitive 124 4 parent h w y x>. " subwin() "
                windowCount <- windowCount + 1.
                ^ temp
              ]
|
  refreshScreen
    ^ <primitive 124 9>            " refresh()  "
|
  refreshWindow: winNumber
    ^ <primitive 124 10 winNumber> " wrefresh() "
|
  closeWindow: winNumber ! temp !
    temp        <- <primitive 124 3 winNumber>. " delwin() "
    windowCount <- windowCount - 1.
    self refreshScreen.
    ^ temp
|
  drawBorder: winNumber hChar: hc vChar: vc
    <primitive 124 5 winNumber vc hc>. " box() "
    ^ self refreshWindow: winNumber
|
  moveWindow: winNumber x: x y: y
    <primitive 124 74 winNumber y x>.  " mvwin() "
    ^ self refreshWindow: winNumber
|
  beep
    ^ <primitive 124 83>
|
  flash
    ^ <primitive 124 84>
|
  cBreak: status
    (status == true )
      ifTrue:  [ ^ <primitive 124 65> ] " cbreak()   "
      ifFalse: [ ^ <primitive 124 66> ] " nocbreak() "
|
  enableClear: winNumber status: status
    (status == true)
      ifTrue:  [ ^ <primitive 124 71 winNumber 1> ] " clearok( TRUE  ) "
      ifFalse: [ ^ <primitive 124 71 winNumber 0> ] " clearok( FALSE ) "
|
  enableCursor: winNumber status: status
    (status == true)
      ifTrue:  [ ^ <primitive 124 72 winNumber 1> ] " leaveok( TRUE  ) "
      ifFalse: [ ^ <primitive 124 72 winNumber 0> ] " leaveok( FALSE ) "
|
  newlineMap: status
    (status == true )
      ifTrue:  [ ^ <primitive 124 67> ] " nl()   "
      ifFalse: [ ^ <primitive 124 68> ] " nonl() " 
|
  echo: status
    (status == true )
      ifTrue:  [ ^ <primitive 124 69> ] " echo()   "
      ifFalse: [ ^ <primitive 124 70> ] " noecho() "
|
  enableDelay: winNumber status: status  
    (status == true)
      ifTrue:  [ ^ <primitive 124 73 winNumber 0> ] " nodelay( FALSE ) "
      ifFalse: [ ^ <primitive 124 73 winNumber 1> ] " nodelay( TRUE  ) "
|
  hasColors
    ^ <primitive 124 6> " has_colors() "
|
  setColor: number red: r green: g blue: b
    <primitive 124 8 number r g b>.
    ^ self refreshScreen
|
  setTextPenColor: colornum
    ^ <primitive 124 85 colornum>
|
  setBackPenColor: colornum
    ^ <primitive 124 86 colornum>
|
  setDrawMode: mode
    ^ <primitive 124 87 mode>
|
  enableScroll: winNumber status: status
    (status == true)
      ifTrue:  [ ^ <primitive 124 76 winNumber 1> ] " scrollok( TRUE  ) "
      ifFalse: [ ^ <primitive 124 76 winNumber 0> ] " scrollok( FALSE ) "
|
  enableKeyPad: winNumber status: status
  " This will allow the following key values to be received:

    KEY_BACKSPACE   0010          /* backspace character */
    KEY_DC          0177          /* Delete character    */
    KEY_DOWN        0400          /* The down arrow key  */
    KEY_UP          0401          /* The up arrow key    */
    KEY_LEFT        0402          /* The left arrow key  */
    KEY_RIGHT       0403          /* The right arrow key */
    KEY_HELP        0404          /* Help Key            */
    KEY_F0          0405          /* Function keys       */
    KEY_F(n)        (KEY_F0+(n))
  "
    (status == true)
      ifTrue:  [ ^ <primitive 124 75 winNumber 1> ] " keypad( TRUE  ) "
      ifFalse: [ ^ <primitive 124 75 winNumber 0> ] " keypad( FALSE ) "
|
  scrollWindow: winNumber
    <primitive 124 77 winNumber>.    " scroll() "
    ^ self refreshWindow: winNumber
|
  setScrollRegion: top Bottom: bott
    <primitive 124 78 top bott>.     " setscrreg() "
    ^ self refreshScreen
|
  setWindowScrollRegion: winNumber top: top Bottom: bott
    <primitive 124 79 winNumber top bott>. " wsetscrreg() "
    ^ self refreshWindow: winNumber
|
  windowNeedsRefresh: winNumber
    ^ <primitive 124 80 winNumber>
|
  printChar: c
    <primitive 124 37 c>.            " addch() "
    ^ self refreshScreen
|
  printWindowChar: winNumber char: c 
    <primitive 124 38 winNumber c>.  " waddch() "   
    ^ self refreshWindow: winNumber
|
  printChar: c at: thePoint
    <primitive 124 39 (thePoint y) (thePoint x) c>. " mvaddch() "
    ^ self refreshScreen
|
  printWindowChar: winNumber char: c at: thePoint
    <primitive 124 40 winNumber (thePoint y) (thePoint x) c>. " mvwaddch()"
    ^ self refreshWindow: winNumber
|
  printString: string
    <primitive 124 41 string>.
    ^ self refreshScreen
|
  printWindowString: winNumber string: string
    <primitive 124 42 winNumber string>.
    ^ self refreshWindow: winNumber
|
  printString: string at: thePoint
    <primitive 124 43 (thePoint y) (thePoint x) string>.
    ^ self refreshScreen
|
  printWindowString: winNumber string: string at: thePoint
    <primitive 124 44 winNumber (thePoint y) (thePoint x) string>.
    ^ self refreshWindow: winNumber
|
  setAttributes: attrs
                 " attrs is one or more of the following:
                         NORMAL    = 0
                         INVERSE   = 16
                         UNDERLINE = 32
                         BOLD      = 64
                 "
    <primitive 124 53 attrs>.
    ^ self refreshScreen
|
  setWindowAttributes: winNumber attr: attrs
                 " attrs is one or more of the following:
                         NORMAL    = 0
                         INVERSE   = 16
                         UNDERLINE = 32
                         BOLD      = 64
                 "
    <primitive 124 54 winNumber attrs>.
    ^ self refreshWindow: winNumber
|
  addAttributes: attrs
                 " attrs is one or more of the following:
                         NORMAL    = 0
                         INVERSE   = 16
                         UNDERLINE = 32
                         BOLD      = 64
                 "
    <primitive 124 55 attrs>.
    ^ self refreshScreen
|
  addWindowAttributes: winNumber attr: attrs
                 " attrs is one or more of the following:
                         NORMAL    = 0
                         INVERSE   = 16
                         UNDERLINE = 32
                         BOLD      = 64
                 "
    <primitive 124 56 winNumber attrs>.
    ^ self refreshWindow: winNumber
|
  removeAttributes: attrs
                 " attrs is one or more of the following:
                         NORMAL    = 0
                         INVERSE   = 16
                         UNDERLINE = 32
                         BOLD      = 64
                 "
    <primitive 124 57 attrs>.
    ^ self refreshScreen
|
  removeWindowAttributes: winNumber attr: attrs
                 " attrs is one or more of the following:
                         NORMAL    = 0
                         INVERSE   = 16
                         UNDERLINE = 32
                         BOLD      = 64
                 "
    <primitive 124 58 winNumber attrs>.
    ^ self refreshWindow: winNumber
|
  invertColors
    <primitive 124 59>.           "  standout() "
    ^ self refreshScreen
|
  invertWindowColors: winNumber
    <primitive 124 60 winNumber>. " wstandout() "
    ^ self refreshWindow: winNumber
|
  revertColors
    <primitive 124 61>.           " standend()  "
    ^ self refreshScreen
|
  revertWindowColors: winNumber
    <primitive 124 62 winNumber>. " wstandend() "
    ^ self refreshWindow: winNumber
|
  emptyScreen
    <primitive 124 45>.             " erase()   "
    ^ self refreshScreen
|
  emptyWindow: winNumber
    <primitive 124 46 winNumber>.   " werase()   "
    ^ self refreshWindow: winNumber
|
  clearScreen
    <primitive 124 47>.            " clear()    "
    ^ self refreshScreen
|
  clearWindow: winNumber
    <primitive 124 48 winNumber>.   " wclear()   "
    ^ self refreshWindow: winNumber
|
  clearScreenToBottom
    <primitive 124 49>.             " clrtobot() "
    ^ self refreshScreen
|
  clearWindowToBottom: winNumber
    <primitive 124 50 winNumber>.   " wclrtobot() "
    ^ self refreshWindow: winNumber
|
  clearScreenToEOL
    <primitive 124 51>.             " clrtoeol() "
    ^ self refreshScreen
|
  clearWindowToEOL: winNumber
    <primitive 124 52 winNumber>.   " wclrtoeol() "
    ^ self refreshWindow: winNumber
|
  deleteChar
    <primitive 124 31>. " delch() "
    ^ self refreshScreen
|
  deleteWindowChar: winNumber
    <primitive 124 32 winNumber>. " wdelch() "
    ^ self refreshWindow: winNumber
|
  deleteCharAt: aPoint
    <primitive 124 33 (aPoint y) (aPoint x)>. " mvdelch() "
    ^ self refreshScreen
|
  deleteWindowChar: winNumber at: aPoint
    <primitive 124 34 winNumber (aPoint y) (aPoint x)>. " mvwdelch() "
    ^ self refreshWindow: winNumber
|
  getChar
    ^ <primitive 124 13>                                 " getch()    "
|
  getWindowChar: winNumber
    ^ <primitive 124 14 winNumber>                       " wgetch()   "
|
  getCharAt: aPoint
    ^ <primitive 124 15 (aPoint y) (aPoint x)>           " mvgetch()  "
|
  getWindowChar: winNumber at: aPoint
    ^ <primitive 124 16 winNumber (aPoint y) (aPoint x)> " mvwgetch() "
|
  getString: buffer
    ^ <primitive 124 17 buffer>                          " getstr()   "
|
  getWindowString: winNumber buffer: string
    ^ <primitive 124 18 winNumber string>                " wgetstr()  "
|
  getStringAt: aPoint buffer: string
    ^ <primitive 124 19 (aPoint y) (aPoint x) string>    " mvgetstr() "
|
  getWindowString: winNumber at: aPoint buffer: string   " mvwgetstr() "
    ^ <primitive 124 16 winNumber (aPoint y) (aPoint x) string>
|
  readChar
    ^ <primitive 124 21>                                 " inch()    "
|
  readWindowChar: winNumber
    ^ <primitive 124 22 winNumber>                       " winch()   "
|
  readCharAt: aPoint
    ^ <primitive 124 23 (aPoint y) (aPoint x)>           " mvinch()  "
|
  readWindowChar: winNumber at: aPoint
    ^ <primitive 124 24 winNumber (aPoint y) (aPoint x)> " mvwinch() "
|
  insertChar
    <primitive 124 25>.                                 " insch()    "
    ^ self refreshScreen
|
  insertWindowChar: winNumber
    <primitive 124 26 winNumber>.                       " winsch()   "
    ^ self refreshWindow: winNumber
|
  insertCharAt: aPoint
    <primitive 124 27 (aPoint y) (aPoint x)>.           " mvinsch()  "
    ^ self refreshScreen
|
  insertWindowChar: winNumber at: aPoint
    <primitive 124 28 winNumber (aPoint y) (aPoint x)>. " mvwinsch() "
    ^ self refreshWindow: winNumber
|
  insertLine
    <primitive 124 29>.                                 " insertln() "
    ^ self refreshScreen
|
  insertWindowLine: winNumber
    <primitive 124 30 winNumber>.                       " winsertln()"
    ^ self refreshWindow: winNumber
|
  deleteLine
    <primitive 124 35>.                                 " deleteln() "
    ^ self refreshScreen
|
  deleteWindowLine: winNumber
    <primitive 124 36 winNumber>.                       " wdeleteln()"
    ^ self refreshWindow: winNumber
|
  moveCursorTo: aPoint
    <primitive 124 63 (aPoint y) (aPoint x)>. " move() "
    ^ self refreshScreen
|
  moveWindowCursor: winNumber to: aPoint
    <primitive 124 63 winNumber (aPoint y) (aPoint x)>. " wmove() "
    ^ self refreshWindow: winNumber
|
  addToRefreshList: winNumber
    ^ <primitive 124 12 winNumber> " wnoutrefresh() "
|
  updateWindows
    ^ <primitive 124 11>           " doupdate() "
|
  flushKeys
    ^ <primitive 124 81> " flushinp() "
|
  moveCursorFrom: aPoint to: newPoint " mvcur() "
    <primitive 124 82 (aPoint y) (aPoint x) (newPoint y) (newPoint x)>.
    ^ self refreshScreen
]
