
; Listing13d1a.s - vorberechnete Tabellen
; Zeile 988
; Tabelle eingefügt

start:
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	move.w	#15,d0																			; 8 Zyklen
;-------------------------------
	lea	Table,a0				; Adresse der Tabelle										; 12 Zyklen
	add.w	d0,d0				; d0 * 2, um den Offset der Tabelle zu finden,				; 4 Zyklen
								; da jeder Wert ein Wort lang ist
	move.w	(a0,d0.w),d0		; Kopieren des richtigen Werts aus der Tabelle nach d0		; 14 Zyklen		; 00219fe 3030 0000                move.w (a0,d0.W,$00) == $00021a2c [000f],d0
																					; Summe: 30 Zyklen
;-------------------------------
	move.w	#15,d0																			; 8 Zyklen
;-------------------------------; optimiert
	add.w	d0,d0				; d0 * 2, jeder Wert 1 Wort, d.h. 2 Bytes					; 4 Zyklen
	move.w	Table(pc,d0.w),d0	; Kopie von der Tabelle, der richtige Wert bis 256 Bytes	; 14 Zyklen		; 00021a08 303b 0004               move.w (pc,d0.W,$04=$00021a0e) == $00021a2c [000f],d0
;-------------------------------
																					; Summe: 18 Zyklen	
	; move.w	#15,d0
	; move.w	Table(pc,d0.w*2),d0	; Anweisung von 68020 oder höher
		
	rts


table:							; Tabelle mit vorberechneten Werten
;	incbin "table"
	dc.w $0000, $0001, $0002, $0003, $0004, $0005, $0006, $0007
	dc.w $0008, $0009, $000A, $000B, $000C, $000D, $000E, $000F
	dc.w $0010, $0011, $0012, $0013, $0014, $0015, $0016, $0017
	dc.w $0018, $0019, $001A, $001B, $001C, $001D, $001E, $001F
	dc.w $0020, $0021, $0022, $0023, $0024, $0025, $0026, $0027
	dc.w $0028, $0029, $002A, $002B, $002C, $002D, $002E, $002F
	dc.w $0030, $0031, $0032, $0033, $0034, $0035, $0036, $0037
	dc.w $0038, $0039, $003A, $003B, $003C, $003D, $003E, $003F
	dc.w $0040, $0041, $0042, $0043, $0044, $0045, $0046, $0047
	dc.w $0048, $0049, $004A, $004B, $004C, $004D, $004E, $004F
	dc.w $0050, $0051, $0052, $0053, $0054, $0055, $0056, $0057
	dc.w $0058, $0059, $005A, $005B, $005C, $005D, $005E, $005F
	dc.w $0060, $0061, $0062, $0063
	

		end

;------------------------------------------------------------------------------
Table:
	dc.w	0*c
	dc.w	1*c
	dc.w	2*c
	dc.w	3*c
	.
	dc.w	n*c
	.
	dc.w	100*c

Zu diesem Zeitpunkt ist es einfach, auf die Tabelle zuzugreifen, da der Wert 
für d0 multipliziert mit c angegeben ist, haben wir das:

	lea	Table,a0				; Adresse der Tabelle
	add.w	d0,d0				; d0 * 2, um den Offset der Tabelle zu finden,
								; da jeder Wert ein Wort lang ist
	move.w	(a0,d0.w),d0		; Kopieren des richtigen Werts aus der Tabelle nach d0

Einfach, oder? Der einzige Nachteil ist, dass wir die längste 100 Wörter Liste
haben um die Tabelle zu erhalten. Wenn diese Tabelle nicht mehr als 256 Bytes
wäre könnten wir schreiben:

	add.w	d0,d0				; d0*2, jeder Wert 1 Wort, d.h. 2 Bytes
	move.w	Table(pc,d0.w),d0	; Kopie von der Tabelle, der richtige Wert

Wenn das Listing für 68020+ wäre, würde nur eine Anweisung ausreichen:

	move.w	Table(pc,d0.w*2),d0	; Anweisung von 68020 oder höher


;------------------------------------------------------------------------------
r
Filename: Listing13d1a.s
>a
Pass1
Pass2
No Errors
>wo
FILENAME>Listings13da1
Sorting relo-area
Writing hunk length..
Writing hunk data..
File length = 296 (=$0000128)

;------------------------------------------------------------------------------
r
Filename: Listing13d1a.s
>a
Pass1
Pass2
No Errors
>j		
		
;------------------------------------------------------------------------------
>fl
No breakpoints.
>d pc
000219e8 0839 0006 00bf e001      btst.b #$0006,$00bfe001
000219f0 66f6                     bne.b #$f6 == $000219e8 (T)
000219f2 303c 000f                move.w #$000f,d0
000219f6 41f9 0002 1a0e           lea.l $00021a0e,a0
000219fc d040                     add.w d0,d0
000219fe 3030 0000                move.w (a0,d0.W,$00) == $000216a3 [0000],d0
00021a02 303c 000f                move.w #$000f,d0
00021a06 d040                     add.w d0,d0
00021a08 303b 0004                move.w (pc,d0.W,$04=$00021a0e) == $00021a1d [0700],d0
00021a0c 4e75                     rts  == $00c4f7b8
>f 219f2
Breakpoint added.
>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 5897252 Chip, 11794504 CPU. (V=105 H=3 -> V=105 H=22)
  D0 0000000F   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021694   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 303c (MOVE) 000f (ILLEGAL) Chip latch 00000000
000219f2 303c 000f                move.w #$000f,d0
Next PC: 000219f6
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=22 -> V=105 H=26)
  D0 0000000F   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021694   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000000
000219f6 41f9 0002 1a0e           lea.l $00021a0e,a0
Next PC: 000219fc
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=26 -> V=105 H=32)
  D0 0000000F   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021A0E   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d040 (ADD) 3030 (MOVE) Chip latch 00000000
000219fc d040                     add.w d0,d0
Next PC: 000219fe
>t
Cycles: 2 Chip, 4 CPU. (V=105 H=32 -> V=105 H=34)
  D0 0000001E   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021A0E   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 3030 (MOVE) 0000 (OR) Chip latch 00000000
000219fe 3030 0000                move.w (a0,d0.W,$00) == $00021a2c [000f],d0
Next PC: 00021a02
>t
Cycles: 7 Chip, 14 CPU. (V=105 H=34 -> V=105 H=41)
  D0 0000000F   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021A0E   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 303c (MOVE) 000f (ILLEGAL) Chip latch 00000000
00021a02 303c 000f                move.w #$000f,d0
Next PC: 00021a06
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=41 -> V=105 H=45)
  D0 0000000F   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021A0E   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d040 (ADD) 303b (MOVE) Chip latch 00000000
00021a06 d040                     add.w d0,d0
Next PC: 00021a08
>t
Cycles: 2 Chip, 4 CPU. (V=105 H=45 -> V=105 H=47)
  D0 0000001E   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021A0E   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 303b (MOVE) 0004 (OR) Chip latch 00000000
00021a08 303b 0004                move.w (pc,d0.W,$04=$00021a0e) == $00021a2c [000f],d0
Next PC: 00021a0c
>t
Cycles: 7 Chip, 14 CPU. (V=105 H=47 -> V=105 H=54)
  D0 0000000F   D1 00000032   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00021A0E   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 0000 (OR) Chip latch 00000000
00021a0c 4e75                     rts  == $00c4f7b8
Next PC: 00021a0e
>