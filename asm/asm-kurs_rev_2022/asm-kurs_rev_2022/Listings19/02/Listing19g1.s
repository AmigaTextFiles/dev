
; Listing19g1.s
; Sprite - Ripping
; mouse-pointer sprite-ripping from workbench screen
; (WinUAE 4.4.0 A500 configuration)
; Console-Debugger

; sp <addr> [<addr2][<size>] Dump sprite information.

;------------------------------------------------------------------------------
																				; normal workbench screen
																				; mousepointer is in the upper-left corner on screen
																				; Shift+F12	open the Debugger

>o 1																			; list memory as copperinstruction from copperlist 1
 00000420: 0180 005a          	;  COLOR00 := 0x005a
*00000424: 00e2 0000          	;  BPL1PTL := 0x0000							; info: the star marks the actual COPPTR
 00000428: 0120 0000          	;  SPR0PTH := 0x0000
 0000042c: 0122 0c80          	;  SPR0PTL := 0x0c80							; Copperpointer 0x0000.0c80
 00000430: 0124 0000          	;  SPR1PTH := 0x0000
 00000434: 0126 0478          	;  SPR1PTL := 0x0478
 00000438: 0128 0000          	;  SPR2PTH := 0x0000
 0000043c: 012a 0478          	;  SPR2PTL := 0x0478
 00000440: 012c 0000          	;  SPR3PTH := 0x0000
 00000444: 012e 0478          	;  SPR3PTL := 0x0478
 00000448: 0130 0000          	;  SPR4PTH := 0x0000
 0000044c: 0132 0478          	;  SPR4PTL := 0x0478
 00000450: 0134 0000          	;  SPR5PTH := 0x0000
 00000454: 0136 0478          	;  SPR5PTL := 0x0478
 00000458: 0138 0000          	;  SPR6PTH := 0x0000
 0000045c: 013a 0478          	;  SPR6PTL := 0x0478
 00000460: 013c 0000          	;  SPR7PTH := 0x0000
 00000464: 013e 0478          	;  SPR7PTL := 0x0478
 00000468: 0c01 fffe          	;  Wait for vpos >= 0x0c and hpos >= 0x00
                        		;  VP 0c, VE 7f; HP 00, HE fe; BFD 1
 0000046c: 008a 0000          	;  COPJMP2 := 0x0000
;------------------------------------------------------------------------------
>sp 0c80																		; sprite information
    000C80 2B3F 3B01 
 43 000C84 1111110000000000
 44 000C88 1333331000000000
 45 000C8C 1222231000000000
 46 000C90 1222310000000000
 47 000C94 1222231000000000
 48 000C98 1221223100000000
 49 000C9C 0110122310000000
 50 000CA0 0000012231000000
 51 000CA4 0000001223100000
 52 000CA8 0000000121000000
 53 000CAC 0000000010000000
 54 000CB0 0000000000000000
 55 000CB4 0000000000000000
 56 000CB8 0000000000000000
 57 000CBC 0000000000000000
 58 000CC0 0000000000000000
Sprite address 00000C80, width = 16
OCS: StartX=127 StartY=43 EndY=59
ECS: StartX=508 (127.0) StartY=43 EndY=59
Attach: 0. AGA SSCAN/SH10 bit: 0
;------------------------------------------------------------------------------
>?$0cc0-$0c80																	; used memory part for sprite data
0x00000040 = %00000000000000000000000001000000 = 64 = 64
respectively. 58-42=16Bytes*4=64Bytes

; 64Bytes/16=4
>m 0c80 4	; 1 line = 16Bytes 

>m 0c80 5
00000C80 2B3F 3B01 0000 FC00 7C00 FE00 7C00 8600  +?;.....|...|...
00000C90 7800 8C00 7C00 8600 6E00 9300 0700 6980  x...|...n.....i.
00000CA0 0380 04C0 01C0 0260 0080 0140 0000 0080  .......`...@....
00000CB0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000CC0 0000 0000		; 0000 0000 0000 0000 0000 0000  ................
;------------------------------------------------------------------------------
mousepointer:																	; converted to dc's
	dc.w $2B3F, $3B01, $0000, $FC00, $7C00, $FE00, $7C00, $8600
	dc.w $7800, $8C00, $7C00, $8600, $6E00, $9300, $0700, $6980
	dc.w $0380, $04C0, $01C0, $0260, $0080, $0140, $0000, $0080
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000 ;, $0000, $0000, $0000, $0000, $0000, $0000
;------------------------------------------------------------------------------
>e																				; to get the colors
																				; this shows the actual values from current reasterposition	 	
...																				; (maybe a better way is to view in the copperlist)
0B6 AUD1PER	0004	1A0 COLOR16	0000
0B8 AUD1VOL	0000	1A2 COLOR17	0D22
0BA AUD1DAT	0000	1A4 COLOR18	0000
0C0 AUD2LCH	0000	1A6 COLOR19	0ABC
...
;------------------------------------------------------------------------------
spritecolors:
	dc.w	$01A2,$0D22	; COLOR17
	dc.w	$01A4,$0000 ; COLOR18
	dc.w	$01A6,$0ABC	; COLOR19


;------------------------------------------------------------------------------
; sprite colors:

092 DDFSTRT     0030    180 COLOR00     0000
094 DDFSTOP     00D0    182 COLOR01     0E60
096 DMACON      07FF    184 COLOR02     0300
098 CLXCON      0000    186 COLOR03     0644
09A INTENA      4038    188 COLOR04     0964
09C INTREQ      17C2    18A COLOR05     0A86
09E ADKCON      1500    18C COLOR06     0CA8
0A0 AUD0LCH     0003    18E COLOR07     0B6D
0A2 AUD0LCL     0B26    190 COLOR08     0EA4
0A4 AUD0LEN     0001    192 COLOR09     0C00
0A6 AUD0PER     0168    194 COLOR10     068E
0A8 AUD0VOL     0028    196 COLOR11     0466
0AA AUD0DAT     1F1D    198 COLOR12     047A
0B0 AUD1LCH     0002    19A COLOR13     0880
0B2 AUD1LCL     2426    19C COLOR14     0AA0
0B4 AUD1LEN     0A80    19E COLOR15     0ECE
0B6 AUD1PER     01AC    1A0 COLOR16     0000 ; Sprite 0+1
0B8 AUD1VOL     0018    1A2 COLOR17     0468
0BA AUD1DAT     3934    1A4 COLOR18     069B
0C0 AUD2LCH     0002    1A6 COLOR19     08BD
0C2 AUD2LCL     8B26    1A8 COLOR20     0866 ; Sprite 2+3
0C4 AUD2LEN     0001    1AA COLOR21     0B66
0C6 AUD2PER     011D    1AC COLOR22     0D98
0C8 AUD2VOL     0040    1AE COLOR23     0ECE
0CA AUD2DAT     0A02    1B0 COLOR24     0EA4 ; Sprite 4+5 
0D0 AUD3LCH     0002    1B2 COLOR25     0E60
0D2 AUD3LCL     8B26    1B4 COLOR26     0E00
0D4 AUD3LEN     0001    1B6 COLOR27     0420
0D6 AUD3PER     011D    1B8 COLOR28     0644 ; Sprite 6+7
0D8 AUD3VOL     0020    1BA COLOR29     0A00
0DA AUD3DAT     FCF2    1BC COLOR30     0A60
0E0 BPL1PTH     0007    1BE COLOR31     0C82

