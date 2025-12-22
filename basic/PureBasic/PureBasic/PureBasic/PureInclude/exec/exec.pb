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

XIncludeFile "exec/types.pb"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/alerts.pb"
XIncludeFile "exec/errors.pb"
XIncludeFile "exec/initializers.pb"
XIncludeFile "exec/resident.pb"
XIncludeFile "exec/memory.pb"
XIncludeFile "exec/tasks.pb"
XIncludeFile "exec/ports.pb"
XIncludeFile "exec/interrupts.pb"
XIncludeFile "exec/semaphores.pb"
XIncludeFile "exec/libraries.pb"
XIncludeFile "exec/io.pb"
XIncludeFile "exec/devices.pb"
XIncludeFile "exec/execbase.pb"

