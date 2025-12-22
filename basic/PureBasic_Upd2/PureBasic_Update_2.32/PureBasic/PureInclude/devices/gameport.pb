;
; ** $VER: gameport.h 36.1 (5.11.90)
; ** Includes Release 40.15
; **
; ** GamePort device command definitions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/io.pb"

; *****  GamePort commands *****
#GPD_READEVENT     = (#CMD_NONSTD+0)
#GPD_ASKCTYPE      = (#CMD_NONSTD+1)
#GPD_SETCTYPE      = (#CMD_NONSTD+2)
#GPD_ASKTRIGGER    = (#CMD_NONSTD+3)
#GPD_SETTRIGGER    = (#CMD_NONSTD+4)

; *****  GamePort structures *****

;  gpt_Keys
#GPTB_DOWNKEYS    = 0
#GPTF_DOWNKEYS    = (1 << 0)
#GPTB_UPKEYS      = 1
#GPTF_UPKEYS      = (1 << 1)

Structure GamePortTrigger
   gpt_Keys.w    ;  key transition triggers
   gpt_Timeout.w    ;  time trigger (vertical blank units)
   gpt_XDelta.w    ;  X distance trigger
   gpt_YDelta.w    ;  Y distance trigger
EndStructure

; ***** Controller Types *****
#GPCT_ALLOCATED    = -1  ;  allocated by another user
#GPCT_NOCONTROLLER = 0

#GPCT_MOUSE    = 1
#GPCT_RELJOYSTICK  = 2
#GPCT_ABSJOYSTICK  = 3


; ***** Errors *****
#GPDERR_SETCTYPE   = 1  ;  this controller not valid at this time

