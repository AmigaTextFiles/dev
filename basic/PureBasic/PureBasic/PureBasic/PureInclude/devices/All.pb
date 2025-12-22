;
; ** $VER: exec.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Include all other Exec include files in a non-overlapping order.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"

;XIncludeFile "dos/all.pb"
;XIncludeFile "intuition/all.pb"
;XIncludeFile "graphics/rastport.pb"
;XIncludeFile "graphics/view.pb"


XIncludeFile "devices/audio.pb"
XIncludeFile "devices/bootblock.pb"
XIncludeFile "devices/cd.pb"
XIncludeFile "devices/clipboard.pb"
XIncludeFile "devices/console.pb"
XIncludeFile "devices/conunit.pb"
XIncludeFile "devices/gameport.pb"
XIncludeFile "devices/hardblocks.pb"
XIncludeFile "devices/input.pb"
XIncludeFile "devices/inputevent.pb"
XIncludeFile "devices/keyboard.pb"
XIncludeFile "devices/keymap.pb"
XIncludeFile "devices/narrator.pb"
XIncludeFile "devices/parallel.pb"
;XIncludeFile "devices/printer.pb"
;XIncludeFile "devices/prtbase.pb"
XIncludeFile "devices/prtgfx.pb"
XIncludeFile "devices/scsidisk.pb"
;XIncludeFile "devices/serial.pb"
XIncludeFile "devices/timer.pb"
XIncludeFile "devices/trackdisk.pb"


