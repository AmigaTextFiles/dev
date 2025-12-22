;
; **
; ** $VER: stdio.h 36.6 (1.11.91)
; ** Includes Release 40.15
; **
; ** ANSI-like stdio defines for dos buffered I/O
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
; **
;

#BUF_LINE = 0 ;  flush on \n, etc
#BUF_FULL = 1 ;  never flush except when needed
#BUF_NONE = 2 ;  no buffering

;  EOF return value
#ENDSTREAMCH = -1

