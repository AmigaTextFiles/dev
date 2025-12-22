
; Listing19b3.s
; search and find

1. s "<string>"/<values> [<addr>] [<length>]
                        Search for string/bytes.
2. fa <address> [<start>] [<end>]
                        Find effective address <address>.
3. fi <opcode> Step forward until PC points to <opcode>.
4. fi <opcode> [<w2>] [<w3>] Step forward until PC points to <opcode>
5. f                     Step forward until PC in RAM ("boot block finder").
 
;------------------------------------------------------------------------------
s "<string>"/<values> [<addr>] [<length>]										; 1. 'string'
                        Search for string/bytes.

s "ALCATRAZ"
Searching from 00000000 to 00C80000..
Scanning.. 00000000 - 00080000 (Chip memory)
Scanning.. 00000000 - 00c80000 (Chip memory)
 00C27086 00C2801E 00C28078 00C3476A 00C35702 00C3575C
 
00C27086 414C 4341 5452 415A 2044 6563 656D 6265  ALCATRAZ Decembe
00C27096 7239 3220 203C 3D2D 002A 2A2A 2A2A 2A2A  r92  <=-.*******
00C270A6 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A  ****************
00C270B6 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A  ****************
00C270C6 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A  ****************
00C270D6 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A 2A2A  ****************
00C270E6 2A2A 2A2A 2A00 0020 2020 2020 2020 2020  *****..         
00C270F6 2020 2020 2A20 5072 6573 7320 6172 726F      * Press arro
00C27106 7773 2075 702F 646F 776E 2074 6F20 7265  ws up/down to re
00C27116 6164 2061 6C6C 2069 6E73 7472 7563 7469  ad all instructi
00C27126 6F6E 732E 0020 2020 2020 2020 2020 2020  ons..           
00C27136 2020 2A20 5072 6573 7320 6C65 6674 206D    * Press left m
00C27146 6F75 7365 6275 7474 6F6E 2074 6F20 7265  ousebutton to re
00C27156 7475 726E 2074 6F20 636F 6E76 6572 7465  turn to converte
00C27166 722E 0000 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D  r...============
00C27176 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D  ================
00C27186 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D  ================
00C27196 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D  ================
00C271A6 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D 3D3D  ================
00C271B6 0020 2020 2020 2020 2020 2020 2049 4646  .            IFF
00C271C6 2D43 6F6E 7665 7274 6572 2056 312E 3335  -Converter V1.35
00C271D6 2069 6D70 726F 7665 6D65 6E74 7320 3A00   improvements :.
00C271E6 2020 2020 2020 2020 2020 2020 2023 204E               # N
00C271F6 6577 2069 6E74 6572 7275 7074 2068 616E  ew interrupt han
00C27206 646C 696E 6700 2020 2020 2020 2020 2020  dling.          
00C27216 2020 2023 204E 6F20 6372 6173 6820 6966     # No crash if
00C27226 2073 7461 7274 6564 2066 726F 6D20 776F   started from wo
00C27236 726B 6265 6E63 6800 2020 2020 2020 2020  rkbench.        
00C27246 2020 2020 2023 204E 6F20 6372 6173 6820       # No crash 
00C27256 7768 696C 6520 6465 7061 636B 696E 6720  while depacking 

;------------------------------------------------------------------------------
>s "ALCATRAZ" 27000 100															; 1b

;------------------------------------------------------------------------------
  s "<string>"/<values> [<addr>] [<length>]										; 1c 'bytes'	
                        Search for string/bytes.

																				; from EAB:
																				; This s-command is a basic search for a hex value in memory.
																				; It will search for a certain value but the value needs to be quite unique or
																				; else too many results are returned. The hex-value could be an instruction or
																				; a value.

>m 1000 1
00001000 3F00 033C 3FFF FF3C 0000 0000 0FFF C000  ?..<?..<........

>s 3F00033C
...

>s 3F00033C 2000
Searching from 00002000 to 00C80000..
 00080D98 00081000 00100D98 00101000 00180D98 00181000Scanning.. 00c00000 - 00c80000 (Slow memory)

>s 3F00033C 0 2000
Searching from 00000000 to 00002000..
Scanning.. 00000000 - 00010000 (Chip memory)
 00000D98 00001000 
 
 >s 3F 00 2000
Searching from 00000000 to 00002000..
Scanning.. 00000000 - 00010000 (Chip memory)
 00000C81 00000CF1 00000D78 00000D7E 00000D85 00000D89 00000D8D 00000D91 00000D94 00000D95
 00000D98 00000D9C 00000E30 00000E36 00000E3A 00000E4C 00000E50 00000E54 00000F31 00000F35
 00000F41 00000F45 00000FE0 00000FE6 00000FED 00000FF1 00000FF5 00000FF9 00000FFC 00000FFD 00001000 ....

																				; If you found the adress you can replace the value by: 
 >W 1000 FFFF																	; Now set this address to hex FFFF (dec 65535):
;------------------------------------------------------------------------------
																				; search for an instruction
>s bfe001
or
>s 0839000600bfe001
Searching from 00000000 to 00C80000..
Scanning.. 00000000 - 00200000 (Chip memory)
00023656 000A3656 00123656 001A3656Scanning.. 00a80000 - 00b00000 (Non-autoconfig RAM #1)
Scanning.. 00b00000 - 00b80000 (Non-autoconfig RAM #2)
Scanning.. 00c00000 - 00c80000 (Slow memory)

or
>s 0839000600bfe001 20000 30000													; with adress range
Searching from 00020000 to 00030000..
00023656
>

then disassemble
>d 23656
00023656 0839 0006 00bf e001	  btst.b #$0006,$00bfe001
0002365e 66de					  bne.b #$de == $0002363e (T)
00023660 23fa 0092 00df f080	  move.l (pc,$0092) == $000236f4 [00000420],$00dff080

																				; and set a breakpoint on adress after the mouse routine
>f 23660																		; set program breakpoint after mouse routine
Breakpoint added.
>g																				; run program
																				; press left mouse button
Breakpoint 0 triggered.															; if breakpoint triggered

																				; You can watch the last executed instructions with
>H																				; up to H 500

																				; or list the dissambled memory part from a previous point
>d pc-100 100																	; d <adress> <lines>

;------------------------------------------------------------------------------

fa <address> [<start>] [<end>]       Find effective address <address>.			; 2. 
																				; where a memory adress is references in memory

>d 32426
00032426 41f9 0003 99d0           LEA.L $000399d0,A0

>fa 32426
Searching from 00000000 to 00C80000
Scanning.. 00000000 - 00200000 (Chip memory)
0003002A 6100 23fa                BSR.W #$23fa == $00032426
Scanning.. 00c00000 - 00c80000 (Slow memory)
>

;------------------------------------------------------------------------------ 
fi <opcode> Step forward until PC points to <opcode>.							; 3.

																				; fi <opcode> is usually the best method to set a breakpoint for UAE
																				; in your code,	if you select an opcode which appears nowhere else,
																				; like exg a7,a7 = fi cf4f.
																				; This code would also have no effect on your program.

>fi 4e71																		; stopped at the next nop
>fi nop
>fi cf4f																		; stopped at the next exg a7,a7

;------------------------------------------------------------------------------
fi <opcode> [<w2>] [<w3>] Step forward until PC points to <opcode>				; 4.

000227e6 4e71                     nop
>fi 4e71
>fi nop

000227de 0640 0001                add.w #$0001,d0
>fi 0640 0001
>fi add.w #$0001,d0

0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
>fi 0c80 0000 5000
>fi and.l #$000fff00,d0

fi 
0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
>fi 33fc 0050 00df f058
>fi move.w #$0050,$00dff058

;------------------------------------------------------------------------------
 
f                     Step forward until PC in RAM ("boot block finder").		; 5.

																				; load configuration that shows the hand with the disk (disc ejected)

Shift+F12, >f																	; open debugger and enable "boot block finder"
>x																				; close debugger
F12																				; open GUI
DF0																				; insert disk and press Start-Button

																				; the boot block finder (breakpoint) opens the debugger

>d pc
00001564 48e7 fffe                MOVEM.L D0-D7/A0-A6,-(A7)						; first RAM-adress	
00001568 2c78 0004                MOVEA.L $0004 [00c00276],A6

																				; also look history data (from ROM to first RAM-adress)
>H 5
 0 00FE85BE 4680                     NOT.L D0
 0 00FE85C0 663e                     BNE.B #$3e == $00fe8600 (F)
 0 00FE85C2 43ed 002c                LEA.L (A5,$002c) == $00c014e2,A1
 0 00FE85C6 4eac 000c                JSR (A4,$000c) == $00001564				; last ROM-adress
 0 00001564 48e7 fffe                MOVEM.L D0-D7/A0-A6,-(A7)					; first RAM-adress		
>

																				; also Reset is possible

																				The f-command is usefull to found the first RAM-adress (eg. boot block)
																				If you want analyze the bootcode (bootloader) you can use this command.

																				After a reset the Amiga is waiting in the ROM. If you now insert a disk, the
																				bootprocess is starting. The f-command stops at the first RAM adress. "until PC
																				in RAM". Now you can trace the bootcode step by step to analyze or modify the
																				code. The f-command is a breakpoint command so you can also look with H the
																				previous instructions. 

