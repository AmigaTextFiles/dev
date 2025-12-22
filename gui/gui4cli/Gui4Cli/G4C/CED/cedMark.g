G4C

; This is an accompanying GUI for the cedbar.gc GUI
; --------------------------------------------------------------

WINBIG 361 30 81 35 ""
WinType 00001000
winonmouse 30 15
resinfo 8 640 256

varpath 'cedbar.gc'
BOX 0 0 0 0 out button

xonload
setgad cedmark.g 99 hide ; hide resize button

; declare this dummy gadget & hide it, so that the
; gui is resized correctly if on an interlace screen
xbutton 0 0 30 10 resize
gadid 99


xonrmb
guiclose cedmark.g

xoninactive
guiclose cedmark.g


; --------------------------------------------------------------
;       set/go buttons
; --------------------------------------------------------------

XRADIO 23 2 18 9 cedMark 2
RStr 1 1
RStr 2 2
RStr 3 3
 
XBUTTON 45 2 30 15 Set
cedSend = "mark location "
AppVar cedSend $cedMark
SendRexx $cedport $cedSend

XBUTTON 45 17 30 15 Go
SetVar cedSend "jump to mark "
AppVar cedSend $cedMark
SendRexx $cedport $cedSend



