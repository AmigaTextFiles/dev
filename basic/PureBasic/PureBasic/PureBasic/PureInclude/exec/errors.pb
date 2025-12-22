;
; ** $VER: errors.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Standard Device IO Errors (returned in io_Error)
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

#IOERR_OPENFAIL  = (-1) ;  device/unit failed to open
#IOERR_ABORTED  = (-2) ;  request terminated early [after AbortIO()]
#IOERR_NOCMD  = (-3) ;  command not supported by device
#IOERR_BADLENGTH  = (-4) ;  not a valid length (usually IO_LENGTH)
#IOERR_BADADDRESS = (-5) ;  invalid address (misaligned or bad range)
#IOERR_UNITBUSY  = (-6) ;  device opens ok, but requested unit is busy
#IOERR_SELFTEST  = (-7) ;  hardware failed self-test

