G4C

;       A gui to add Amiga guide effects
; ========================================================

WINBIG 385 20 241 68 'Add Effect'
WinType 11110001
winonmouse 40 15
resinfo 8 640 256
BOX 0 0 0 0 out button

; ========================================================
;       start up & end
; ========================================================

xOnLoad
setgadvalues addeffect.g
guiopen addeffect.g

xonreload
guiopen addeffect.g

xonopen ; reset
update addeffect.g 1 0
update addeffect.g 2 0
update addeffect.g 3 0
update addeffect.g 4 0
update addeffect.g 5 0
fg = text
bg = background

; ========================================================
;       effect gadgets
; ========================================================

XCHECKBOX 84 6 26 11 "Bold" bl 1 0 OFF
gadid 1

XCHECKBOX 84 18 26 11 "Underline" ul 1 0 OFF
gadid 2

XCHECKBOX 84 30 26 11 "Italic" it 1 0 OFF
gadid 3

TEXT 128 4 22 14 'Foreground' 10 NOBOX
XCYCLER 125 18 108 14 "" fg
gadid 4
CSTR Text text
CSTR Shine shine
CSTR Shadow shadow
CSTR Fill fill
CSTR FillText filltext
CSTR Backgnd background
CSTR Highlight highlight


TEXT 129 33 22 13 'Background' 10 NOBOX
XCYCLER 125 47 108 14 "" bg
gadid 5
CSTR Backgnd background
CSTR Highlight highlight
CSTR Text text
CSTR Shine shine
CSTR Shadow shadow
CSTR Fill fill
CSTR FillText filltext


; ========================================================
;       Do it.
; ========================================================

BOX 15 46 88 18 OUT BUTTON
XBUTTON 19 48 80 14 "Apply"

SendRexx $cedbar.gc/cedport cut

; apply start of effects which have been chosen
if $bl = 1
   SendRexx $cedbar.gc/cedport 'text @{B}'
endif
if $ul = 1
   SendRexx $cedbar.gc/cedport 'text @{U}'
endif
if $it = 1
   SendRexx $cedbar.gc/cedport 'text @{I}'
endif
if $fg != text
   SendRexx $cedbar.gc/cedport 'text @{FG $fg\}'
endif
if $bg != background
   SendRexx $cedbar.gc/cedport 'text @{BG $bg\}'
endif

; paste selection back
SendRexx $cedbar.gc/cedport paste

; apply ending of effects
if $bg != background
   SendRexx $cedbar.gc/cedport 'text @{BG background}'
endif
if $fg != text
   SendRexx $cedbar.gc/cedport 'text @{FG text}'
endif
if $it = 1
   SendRexx $cedbar.gc/cedport 'text @{UI}'
endif
if $ul = 1
   SendRexx $cedbar.gc/cedport 'text @{UU}'
endif
if $bl = 1
   SendRexx $cedbar.gc/cedport 'text @{UB}'
endif

