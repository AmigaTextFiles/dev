;
; ** $VER: io.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Message structures used for device communication
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/ports.pb"
XIncludeFile "exec/devices.pb"


Structure IORequest
    io_Message.Message
    *io_Device.Device     ;  device node pointer
    *io_Unit.Unit     ;  unit (driver private)
    io_Command.w     ;  device command
    io_Flags.b
    io_Error.b      ;  error or warning num
EndStructure


Structure IOStdReq
    io_Message.Message
    *io_Device.Device     ;  device node pointer
    *io_Unit.Unit     ;  unit (driver private)
    io_Command.w     ;  device command
    io_Flags.b
    io_Error.b      ;  error or warning num
    io_Actual.l      ;  actual number of bytes transferred
    io_Length.l      ;  requested number bytes transferred
    *io_Data.l      ;  points to data area
    io_Offset.l      ;  offset for block structured devices
EndStructure

;  library vector offsets for device reserved vectors
#DEV_BEGINIO = (-30)
#DEV_ABORTIO = (-36)

;  io_Flags defined bits
#IOB_QUICK = 0
#IOF_QUICK = (1 << 0)


#CMD_INVALID = 0
#CMD_RESET = 1
#CMD_READ = 2
#CMD_WRITE = 3
#CMD_UPDATE = 4
#CMD_CLEAR = 5
#CMD_STOP = 6
#CMD_START = 7
#CMD_FLUSH = 8

#CMD_NONSTD = 9

