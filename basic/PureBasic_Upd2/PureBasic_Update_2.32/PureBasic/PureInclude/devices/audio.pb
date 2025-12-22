;
; ** $VER: audio.h 36.3 (29.8.90)
; ** Includes Release 40.15
; **
; ** audio.device include file
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/io.pb"

;#AUDIONAME  = "audio\device"

#ADHARD_CHANNELS  = 4

#ADALLOC_MINPREC  = -128
#ADALLOC_MAXPREC  = 127

#ADCMD_FREE  = (#CMD_NONSTD+0)
#ADCMD_SETPREC  = (#CMD_NONSTD+1)
#ADCMD_FINISH  = (#CMD_NONSTD+2)
#ADCMD_PERVOL  = (#CMD_NONSTD+3)
#ADCMD_LOCK  = (#CMD_NONSTD+4)
#ADCMD_WAITCYCLE  = (#CMD_NONSTD+5)
#ADCMD_ALLOCATE  = 32

#ADIOB_PERVOL  = 4
#ADIOF_PERVOL  = (1 << 4)
#ADIOB_SYNCCYCLE  = 5
#ADIOF_SYNCCYCLE  = (1 << 5)
#ADIOB_NOWAIT  = 6
#ADIOF_NOWAIT  = (1 << 6)
#ADIOB_WRITEMESSAGE = 7
#ADIOF_WRITEMESSAGE = (1 << 7)

#ADIOERR_NOALLOCATION = -10
#ADIOERR_ALLOCFAILED = -11
#ADIOERR_CHANNELSTOLEN = -12

Structure IOAudio
    ioa_Request.IORequest
    ioa_AllocKey.w
    *ioa_Data.b
    ioa_Length.l
    ioa_Period.w
    ioa_Volume.w
    ioa_Cycles.w
    ioa_WriteMsg.Message
EndStructure

