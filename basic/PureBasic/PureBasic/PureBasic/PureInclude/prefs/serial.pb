;
; ** $VER: serial.h 38.2 (10.7.91)
; ** Includes Release 40.15
; **
; ** File format for serial preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************

#ID_SERL = $5345524C


Structure SerialPrefs

    sp_Reserved.l[3]  ;  System reserved
    sp_Unit0Map.l   ;  What unit 0 really refers to
    sp_BaudRate.l   ;  Baud rate

    sp_InputBuffer.l  ;  Input buffer: 0 - 65536
    sp_OutputBuffer.l  ;  Future: Output: 0 - 65536

    sp_InputHandshake.b  ;  Input handshaking
    sp_OutputHandshake.b  ;  Future: Output handshaking

    sp_Parity.b   ;  Parity
    sp_BitsPerChar.b  ;  I/O bits per character
    sp_StopBits.b   ;  Stop bits
EndStructure

;  constants for SerialPrefs.sp_Parity
#PARITY_NONE = 0
#PARITY_EVEN = 1
#PARITY_ODD = 2
#PARITY_MARK = 3  ;  Future enhancement
#PARITY_SPACE = 4  ;  Future enhancement

;  constants for SerialPrefs.sp_Input/OutputHandshaking
#HSHAKE_XON = 0
#HSHAKE_RTS = 1
#HSHAKE_NONE = 2


; ***************************************************************************


