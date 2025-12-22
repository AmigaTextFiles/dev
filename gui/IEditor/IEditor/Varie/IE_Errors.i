ErrStrings  dc.l Txt1,Txt2,Txt3,Txt4
            dc.l Txt5,Txt6,Txt7,Txt8
            dc.l Txt9,Txt10

Txt1        dc.b "Couldn't open ",0
Txt2        dc.b "Couldn't open a diskfont!",0
Txt3        dc.b "Setup Screen Error: ",0
Txt4        dc.b "Couldn't open the screen!",0
Txt5        dc.b "Couldn't get Visual Info!",0
Txt6        dc.b "Open Window Error: ",0
Txt7        dc.b "Couldn't create a context!",0
Txt8        dc.b "Couldn't create a gadget!",0
Txt9        dc.b "Couldn't create a menu!",0
Txt10       dc.b "Couldn't open the window!",0

OPEN_LIB    EQU  0
OPEN_FONTS  EQU  1
SETUP_SCR   EQU  2
OPEN_WND    EQU  SETUP_SCR+3
