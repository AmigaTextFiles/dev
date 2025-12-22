;
; ** $VER: keyboard.h 36.0 (1.5.90)
; ** Includes Release 40.15
; **
; ** Keyboard device command definitions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/io.pb"

# KBD_READEVENT        = (#CMD_NONSTD+0)
# KBD_READMATRIX       = (#CMD_NONSTD+1)
# KBD_ADDRESETHANDLER  = (#CMD_NONSTD+2)
# KBD_REMRESETHANDLER  = (#CMD_NONSTD+3)
# KBD_RESETHANDLERDONE = (#CMD_NONSTD+4)

