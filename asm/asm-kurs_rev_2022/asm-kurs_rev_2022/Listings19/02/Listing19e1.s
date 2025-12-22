
; Listing19e1.s
; save a part of memory as bytes
;
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

 S <file> <addr> <n>   Save a block of Amiga memory.
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger

>m c80 5																		; view part of memory
00000C80 2B3F 3B01 0000 FC00 7C00 FE00 7C00 8600  +?;.....|...|...
00000C90 7800 8C00 7C00 8600 6E00 9300 0700 6980  x...|...n.....i.
00000CA0 0380 04C0 01C0 0260 0080 0140 0000 0080  .......`...@....
00000CB0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000CC0 0000 0000 0000 0000 0000 0000 0000 0000  ................
;------------------------------------------------------------------------------
>S Debug 0c80 5																	; save 5 bytes
Wrote 00000C80 - 00000C85 (5 bytes) to 'Debug'.
;------------------------------------------------------------------------------
																				; I found that saved file here
; the file is here:		
; C:\Users\Public\Documents\Amiga Files\WinUAE

; open the file with a Hex-Editor
2B 3F 3B 01 00
;------------------------------------------------------------------------------
>S Hand $5ac2 !16000															; bitplane data (WB 1.3 Hand)
Wrote 00005AC2 - 00009942 (16000 bytes) to 'Hand'.
>


; note
S "df0:debug" 0c80 20
Couldn't open file '"df0:debug"'.

S df0:debug 0c80 20
Wrote 00000C80 - 00000CA0 (32 bytes) to 'df0:debug'.	; C:\Users\Public\Documents\Amiga Files\WinUAE
														; file: df0
S DH1:Debug 0c80 20
Wrote 00000C80 - 00000CA0 (32 bytes) to 'DH1:Debug'.	; C:\Users\Public\Documents\Amiga Files\WinUAE
														; file: DH1
