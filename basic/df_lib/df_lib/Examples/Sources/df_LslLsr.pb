;
; LSL/LSR example
;
; by Francis G. Loch
;

InitRequester()

a.l = LSL(2,3)          ; Should give you 16
b.l = LSR(32,3)         ; Should give you 4

body$ = "Logical Shift Left (LSL) result = "+Str(a)+Chr(10)
body$ + "Logical Shift Right (LSR) result = "+Str(b)

req.l = EasyRequester("Information", body$, "Okay")