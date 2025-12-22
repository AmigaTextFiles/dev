
; Listing13d2.s - Tabellen	- nimmt Bezug auf Listing8n2.s
; Multiplikation durch vorberechnete Tabelle einsparen
; Zeile 1033

LargSchermo	equ	40	; Bildschirmbreite in Bytes

start:
	waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;

; WIR PRÄPARIEREN EINE TABELLe MIT DEN VIELFACHEN VON 40 ODER DER BREITE DES
; Bildschirms, um eine Multiplikation für jeden Plot zu vermeiden.

	lea	MulTab,a0				; Adressraum von 256 zu schreibenden Wörtern
								; Vielfache von 40 ...
	moveq	#0,d0				; Start mit 0...
	move.w	#256-1,d7			; Anzahl der Vielfachen von 40 erforderlich
PreCalcLoop
	move.w	d0,(a0)+			; wir speichern das aktuelle Vielfache
	add.w	#LargSchermo,d0		; Bildbreite hinzufügen, nächstes Vielfaches
	dbra	d7,PreCalcLoop		; Wir erstellen die gesamte MulTab
	;....
;------------------------------------------------------------------------------
	lea	bitplane,a0				; Bitplane-Adresse, in der gedruckt werden soll a0
	lea	MulTab,a1				; Tabellenadresse mit Vielfachen von
								; Breite. vorberechneter Bildschirm in a1
	move.w	#34,d0				; Koordinate X
	move.w	#116,d1				; Koordinate Y

	bsr.s	PlotPIX				; Punkt auf die Koordinate X=d0, Y=d1 drucken					; 18 Zyklen
;------------------------------------------------------------------------------
	move.w	#34,d0				; Koordinate X
	move.w	#116,d1				; Koordinate Y

	bsr.w	PlotPIXP			; Punkt auf die Koordinate. X=d0, Y=d1 drucken					; 18 Zyklen
;------------------------------------------------------------------------------
	rts

*****************************************************************************
;		Routine zum Plotten eines Punktes (dots) normal
*****************************************************************************

;	Eingehende Parameter von PlotPIX:
;
;	a0 = Ziel-Bitplane-Adresse
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)


PlotPIX:
	move.w	d0,d2				; Kopieren Sie die Koordinate X in d2							; 4 Zyklen - gleich		
	lsr.w	#3,d0				; In der Zwischenzeit finden Sie den horizontalen Versatz,		; 12 Zyklen - gleich	
								; Teilen Sie die X-Koordinate durch 8.
	mulu.w	#largschermo,d1																		; 46 Zyklen - Unterschied	(40 bis 70 Zyklen)
	add.w	d1,d0				; Offset vertikal bis horizontal								; 4 Zyklen - Unterschied

	and.w	#%111,d2			; Wählen Sie nur die ersten 3 Bits von X aus (Rest)				; 8 Zyklen - gleich	
	not.w	d2																					; 4 Zyklen - gleich

	bset.b	d2,(a0,d0.w)		; Setzen Sie das Bit d2 des bytefernen Bytes d0					; 18 Zyklen - gleich
								; vom Anfang des Bildschirms.
	rts																							; 16 Zyklen
																								; Summe: 112 Zyklen	
*****************************************************************************	
;		Routine zum Plotten eines Punktes (dots) optimiert
*****************************************************************************

;	Eingehende Parameter von PlotPIXP:
;
;	a0 =  Ziel-Bitplane-Adresse
;	a1 = Adresse der Tabelle mit Vielfachen von 40 vorberechnet
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

PlotPIXP:
	move.w	d0,d2				; Kopieren Sie die Koordinate X in d2							; 4 Zyklen - gleich
	lsr.w	#3,d0				; In der Zwischenzeit finden Sie den horizontalen Versatz,		; 12 Zyklen - gleich
								; Teilen Sie die X-Koordinate durch 8.
	add.w	d1,d1				; Wir multiplizieren das Y mit 2 und finden den Versatz			; 4 Zyklen - Unterschied
	add.w	(a1,d1.w),d0		; vertikaler Versatz + horizontaler Versatz						; 14 Zyklen - Unterschied
	and.w	#%111,d2			; Wählen Sie nur die ersten 3 Bits von X aus					; 8 Zyklen - gleich
	not.w	d2					; negieren														; 4 Zyklen - gleich
	bset	d2,(a0,d0.w)		; Setzen Sie das Bit d2 des bytefernen Bytes d0					; 18 Zyklen - gleich
								; vom Anfang des Bildschirms.
	rts																							; 16 Zyklen
																								; Summe: 80 Zyklen	

*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256	; un bitplane lowres 320x256

; Tabelle, die die vorberechneten Vielfachen der Bildschirmbreite enthält
; zur Beseitigung der Multiplikation in der PlotPIX-Routine und zur Erhöhung
; ihrer Geschwindigkeit.

	SECTION	Precalc,bss

MulTab:
	ds.w	256		; Beachten Sie, dass der aus Nullen bestehende BSS-Abschnitt
					; nicht die tatsächliche Länge der ausführbaren Datei verlängert.

	
	end


Wenn Sie aufmerksam waren, wir haben in den vorherigen Lektionen bereits einige
"tabellarische" Listings aufgeführt, eine zum Entfernen eines "MULU.W #40",
sehr häufig, da 40 die Länge einer Lowres-Bildschirmzeile ist.
Überprüfen sie das Beispiel, es ist Listing8n2.s sorgfältig in dem beide
Versionen im Vergleich optimiert und normal vorhanden sind. Überprüfen Sie auch
die Listings um die normalen und optimierten Routinen selbst zu sehen.
Das Problem war:

	mulu.w	#largschermo,d1		; d.h. mulu.w #40,d1

Hier ist der Trick, um das Problem zu beheben:

; LASSEN SIE UNS EINE TABELLE MIT DEN MEHRFACHEN VON 40 VORBERECHNEN,
; dh mit der Breite des Bildschirms, um eine Multiplikation für jedes
; Zeichnen zu vermeiden.

-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-	-.-

	lea	MulTab,a0			; Adressraum von 256 zu schreibenden Wörtern
							; Vielfache von 40 ...
	moveq	#0,d0			; Start mit 0...
	move.w	#256-1,d7		; Anzahl der Vielfachen von 40 erforderlich
PreCalcLoop
	move.w	d0,(a0)+		; wir speichern das aktuelle Vielfache
	add.w	#LargSchermo,d0	; Bildbreite hinzufügen, nächstes Vielfaches
	dbra	d7,PreCalcLoop	; Wir erstellen die gesamte MulTab
	....

	SECTION	Precalc,bss

MulTab:
	ds.w	256	; Beachten Sie, dass der aus Nullen bestehende Abschnitt
; bss nicht die tatsächliche Länge der ausführbaren Datei verlängert.

;------------------------------------------------------------------------------
r
Filename: Listing13d2.s
>a
Pass1
Pass2
No Errors
>j			

;------------------------------------------------------------------------------

>d pc
00026b00 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00026b08 66f6                     bne.b #$f6 == $00026b00 (T)
00026b0a 41f9 0002 6b70           lea.l $00026b70,a0
00026b10 7000                     moveq #$00,d0
00026b12 3e3c 00ff                move.w #$00ff,d7
00026b16 30c0                     move.w d0,(a0)+ [0000]
00026b18 0640 0028                add.w #$0028,d0
00026b1c 51cf fff8                dbf .w d7,#$fff8 == $00026b16 (F)
00026b20 41f9 0006 a4d8           lea.l $0006a4d8,a0
00026b26 43f9 0002 6b70           lea.l $00026b70,a1
>f 26b0a
Breakpoint added.
>fl
0: PC == 00026b0a [00000000 00000000]

>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 3405877 Chip, 6811754 CPU. (V=105 H=3 -> V=105 H=22)
  D0 00000244   D1 00002440   D2 0000FFFB   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00022538   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000000
00026b0a 41f9 0002 6b70           lea.l $00026b70,a0
Next PC: 00026b10
>m 26b70
00026B70 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026B80 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026B90 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026BA0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026BB0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026BC0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026BD0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026BE0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026BF0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C00 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C10 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C20 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C30 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C40 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C50 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C60 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C70 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C80 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026C90 0000 0000 0000 0000 0000 0000 0000 0000  ................
00026CA0 0000 0000 0000 0000 0000 0000 0000 0000  ................
>d pc
00026b0a 41f9 0002 6b70           lea.l $00026b70,a0
00026b10 7000                     moveq #$00,d0
00026b12 3e3c 00ff                move.w #$00ff,d7
00026b16 30c0                     move.w d0,(a0)+ [0000]
00026b18 0640 0028                add.w #$0028,d0
00026b1c 51cf fff8                dbf .w d7,#$fff8 == $00026b16 (F)
00026b20 41f9 0006 a4d8           lea.l $0006a4d8,a0
00026b26 43f9 0002 6b70           lea.l $00026b70,a1
00026b2c 303c 0022                move.w #$0022,d0
00026b30 323c 0074                move.w #$0074,d1
>f 26b20
Breakpoint added.
>fl
0: PC == 00026b0a [00000000 00000000]
1: PC == 00026b20 [00000000 00000000]

>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 3342 Chip, 6684 CPU. (V=105 H=22 -> V=119 H=186)
  D0 00002800   D1 00002440   D2 0000FFFB   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00026D70   A1 00022538   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0006 (OR) Chip latch 00000000
00026b20 41f9 0006 a4d8           lea.l $0006a4d8,a0
Next PC: 00026b26
>m 26b70
00026B70 0000 0028 0050 0078 00A0 00C8 00F0 0118  ...(.P.x........
00026B80 0140 0168 0190 01B8 01E0 0208 0230 0258  .@.h.........0.X
00026B90 0280 02A8 02D0 02F8 0320 0348 0370 0398  ......... .H.p..
00026BA0 03C0 03E8 0410 0438 0460 0488 04B0 04D8  .......8.`......
00026BB0 0500 0528 0550 0578 05A0 05C8 05F0 0618  ...(.P.x........
00026BC0 0640 0668 0690 06B8 06E0 0708 0730 0758  .@.h.........0.X
00026BD0 0780 07A8 07D0 07F8 0820 0848 0870 0898  ......... .H.p..
00026BE0 08C0 08E8 0910 0938 0960 0988 09B0 09D8  .......8.`......
00026BF0 0A00 0A28 0A50 0A78 0AA0 0AC8 0AF0 0B18  ...(.P.x........
00026C00 0B40 0B68 0B90 0BB8 0BE0 0C08 0C30 0C58  .@.h.........0.X
00026C10 0C80 0CA8 0CD0 0CF8 0D20 0D48 0D70 0D98  ......... .H.p..
00026C20 0DC0 0DE8 0E10 0E38 0E60 0E88 0EB0 0ED8  .......8.`......
00026C30 0F00 0F28 0F50 0F78 0FA0 0FC8 0FF0 1018  ...(.P.x........
00026C40 1040 1068 1090 10B8 10E0 1108 1130 1158  .@.h.........0.X
00026C50 1180 11A8 11D0 11F8 1220 1248 1270 1298  ......... .H.p..
00026C60 12C0 12E8 1310 1338 1360 1388 13B0 13D8  .......8.`......
00026C70 1400 1428 1450 1478 14A0 14C8 14F0 1518  ...(.P.x........
00026C80 1540 1568 1590 15B8 15E0 1608 1630 1658  .@.h.........0.X
00026C90 1680 16A8 16D0 16F8 1720 1748 1770 1798  ......... .H.p..
00026CA0 17C0 17E8 1810 1838 1860 1888 18B0 18D8  .......8.`......
>
;------------------------------------------------------------------------------
>d pc
00026b20 41f9 0006 a4d8           lea.l $0006a4d8,a0
00026b26 43f9 0002 6b70           lea.l $00026b70,a1
00026b2c 303c 0022                move.w #$0022,d0
00026b30 323c 0074                move.w #$0074,d1
00026b34 610e                     bsr.b #$0e == $00026b44								; bsr 1
00026b36 303c 0022                move.w #$0022,d0
00026b3a 323c 0074                move.w #$0074,d1
00026b3e 6100 001a                bsr.w #$001a == $00026b5a								; bsr 2
00026b42 4e75                     rts  == $00c4f7b8										; rts --> from asmone
00026b44 3400                     move.w d0,d2											; rts  == $00c4f7b8 adress is correct here!
>d
00026b46 e648                     lsr.w #$03,d0
00026b48 c2fc 0028                mulu.w #$0028,d1
00026b4c d041                     add.w d1,d0
00026b4e 0242 0007                and.w #$0007,d2
00026b52 4642                     not.w d2
00026b54 05f0 0000                bset.b d2,(a0,d0.W,$00) == $00029570 [00]
00026b58 4e75                     rts  == $00c4f7b8										; rts --> from bsr 1
00026b5a 3400                     move.w d0,d2											; rts  == $00c4f7b8 adress is wrong here!
00026b5c e648                     lsr.w #$03,d0
00026b5e d241                     add.w d1,d1
>d
00026b60 d071 1000                add.w (a1,d1.W,$00) == $00024978 [3030],d0
00026b64 0242 0007                and.w #$0007,d2
00026b68 4642                     not.w d2
00026b6a 05f0 0000                bset.b d2,(a0,d0.W,$00) == $00029570 [00]
00026b6e 4e75                     rts  == $00c4f7b8										; rts --> from bsr 2
00026b70 0000 0028                or.b #$28,d0											; rts  == $00c4f7b8 adress is wrong here!
00026b74 0050 0078                or.w #$0078,(a0) [1234]
00026b78 00a0 00c8 00f0           or.l #$00c800f0,-(a0) [27b027d8]
00026b7e 0118                     btst.b d0,(a0)+ [12]
00026b80 0140                     bchg.l d0,d0
>d
00026b82 0168 0190                bchg.b d0,(a0,$0190) == $00026f00 [00]
00026b86 01b8 01e0                bclr.b d0,$01e0 [00]
00026b8a 0208                     illegal
00026b8c 0230 0258 0280           and.b #$58,(a0,d0.W[*2],$80) == $000294f0 (68020+) [00]
00026b92 02a8 02d0 02f8 0320      and.l #$02d002f8,(a0,$0320) == $00027090 [00000000]
00026b9a 0348 0370                movep.l (a0,$0370) == $000270e0,d1
00026b9e 0398                     bclr.b d1,(a0)+ [12]
00026ba0 03c0                     bset.l d1,d0
00026ba2 03e8 0410                bset.b d1,(a0,$0410) == $00027180 [00]
00026ba6 0438 0460 0488           sub.b #$60,$0488 [00]
>
;------------------------------------------------------------------------------
>t
Cycles: 6 Chip, 12 CPU. (V=119 H=186 -> V=119 H=192)
  D0 00002800   D1 00002440   D2 0000FFFB   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00022538   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 43f9 (LEA) 0002 (OR) Chip latch 00000000
00026b26 43f9 0002 6b70           lea.l $00026b70,a1
Next PC: 00026b2c
>t
Cycles: 6 Chip, 12 CPU. (V=119 H=192 -> V=119 H=198)
  D0 00002800   D1 00002440   D2 0000FFFB   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 303c (MOVE) 0022 (OR) Chip latch 00000000
00026b2c 303c 0022                move.w #$0022,d0
Next PC: 00026b30
>t
Cycles: 4 Chip, 8 CPU. (V=119 H=198 -> V=119 H=202)
  D0 00000022   D1 00002440   D2 0000FFFB   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 323c (MOVE) 0074 (OR) Chip latch 00000000
00026b30 323c 0074                move.w #$0074,d1
Next PC: 00026b34
>t
Cycles: 4 Chip, 8 CPU. (V=119 H=202 -> V=119 H=206)
  D0 00000022   D1 00000074   D2 0000FFFB   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 610e (BSR) 303c (MOVE) Chip latch 00000000
00026b34 610e                     bsr.b #$0e == $00026b44
Next PC: 00026b36
>t
Cycles: 9 Chip, 18 CPU. (V=119 H=206 -> V=119 H=215)
  D0 00000022   D1 00000074   D2 0000FFFB   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 3400 (MOVE) e648 (LSR) Chip latch 00000000
00026b44 3400                     move.w d0,d2
Next PC: 00026b46
>t
Cycles: 2 Chip, 4 CPU. (V=119 H=215 -> V=119 H=217)
  D0 00000022   D1 00000074   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch e648 (LSR) c2fc (MULU) Chip latch 00000000
00026b46 e648                     lsr.w #$03,d0
Next PC: 00026b48
>t
Cycles: 6 Chip, 12 CPU. (V=119 H=217 -> V=119 H=223)
  D0 00000004   D1 00000074   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch c2fc (MULU) 0028 (OR) Chip latch 00000000
00026b48 c2fc 0028                mulu.w #$0028,d1
Next PC: 00026b4c
>t
Cycles: 23 Chip, 46 CPU. (V=119 H=223 -> V=120 H=19)
  D0 00000004   D1 00001220   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d041 (ADD) 0242 (AND) Chip latch 00000000
00026b4c d041                     add.w d1,d0
Next PC: 00026b4e
>t
Cycles: 2 Chip, 4 CPU. (V=120 H=19 -> V=120 H=21)
  D0 00001224   D1 00001220   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0242 (AND) 0007 (OR) Chip latch 00000000
00026b4e 0242 0007                and.w #$0007,d2
Next PC: 00026b52
>t
Cycles: 4 Chip, 8 CPU. (V=120 H=21 -> V=120 H=25)
  D0 00001224   D1 00001220   D2 00000002   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4642 (NOT) 05f0 (BSET) Chip latch 00000000
00026b52 4642                     not.w d2
Next PC: 00026b54
>t
Cycles: 2 Chip, 4 CPU. (V=120 H=25 -> V=120 H=27)							; bset	d2,(a0,d0.w)
  D0 00001224   D1 00001220   D2 0000FFFD   D3 00000000						; D2 0000FFFB
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF						; A0 0006A4D8
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000						; D0 00001224 
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 05f0 (BSET) 0000 (OR) Chip latch 00000000
00026b54 05f0 0000                bset.b d2,(a0,d0.W,$00) == $0006b6fc [00]
Next PC: 00026b58
>t
Cycles: 9 Chip, 18 CPU. (V=120 H=27 -> V=120 H=36)
  D0 00001224   D1 00001220   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 3400 (MOVE) Chip latch 00000000
00026b58 4e75                     rts  == $00026b36							; rts  == $00026b36	is correct	
Next PC: 00026b5a
>t
Cycles: 8 Chip, 16 CPU. (V=120 H=36 -> V=120 H=44)
  D0 00001224   D1 00001220   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 303c (MOVE) 0022 (OR) Chip latch 00000000
00026b36 303c 0022                move.w #$0022,d0
Next PC: 00026b3a
>t
Cycles: 4 Chip, 8 CPU. (V=120 H=44 -> V=120 H=48)
  D0 00000022   D1 00001220   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 323c (MOVE) 0074 (OR) Chip latch 00000000
00026b3a 323c 0074                move.w #$0074,d1
Next PC: 00026b3e
>t
Cycles: 4 Chip, 8 CPU. (V=120 H=48 -> V=120 H=52)
  D0 00000022   D1 00000074   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 001a (OR) Chip latch 00000000
00026b3e 6100 001a                bsr.w #$001a == $00026b5a
Next PC: 00026b42
>t
Cycles: 9 Chip, 18 CPU. (V=120 H=52 -> V=120 H=61)
  D0 00000022   D1 00000074   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 3400 (MOVE) e648 (LSR) Chip latch 00000000
00026b5a 3400                     move.w d0,d2
Next PC: 00026b5c
>t
Cycles: 2 Chip, 4 CPU. (V=120 H=61 -> V=120 H=63)
  D0 00000022   D1 00000074   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch e648 (LSR) d241 (ADD) Chip latch 00000000
00026b5c e648                     lsr.w #$03,d0
Next PC: 00026b5e
>t
Cycles: 6 Chip, 12 CPU. (V=120 H=63 -> V=120 H=69)
  D0 00000004   D1 00000074   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d241 (ADD) d071 (ADD) Chip latch 00000000
00026b5e d241                     add.w d1,d1
Next PC: 00026b60
>t
Cycles: 2 Chip, 4 CPU. (V=120 H=69 -> V=120 H=71)
  D0 00000004   D1 000000E8   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d071 (ADD) 1000 (MOVE) Chip latch 00000000
00026b60 d071 1000                add.w (a1,d1.W,$00) == $00026c58 [1220],d0
Next PC: 00026b64
>t
Cycles: 7 Chip, 14 CPU. (V=120 H=71 -> V=120 H=78)
  D0 00001224   D1 000000E8   D2 00000022   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0242 (AND) 0007 (OR) Chip latch 00000000
00026b64 0242 0007                and.w #$0007,d2
Next PC: 00026b68
>t
Cycles: 4 Chip, 8 CPU. (V=120 H=78 -> V=120 H=82)
  D0 00001224   D1 000000E8   D2 00000002   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4642 (NOT) 05f0 (BSET) Chip latch 00000000
00026b68 4642                     not.w d2
Next PC: 00026b6a
>t
Cycles: 2 Chip, 4 CPU. (V=120 H=82 -> V=120 H=84)							; bset	d2,(a0,d0.w)
  D0 00001224   D1 000000E8   D2 0000FFFD   D3 00000000						; D2 0000FFFB
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF						; A0 0006A4D8
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000						; D0 00001224 
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 05f0 (BSET) 0000 (OR) Chip latch 00000000
00026b6a 05f0 0000                bset.b d2,(a0,d0.W,$00) == $0006b6fc [20]
Next PC: 00026b6e
>t
Cycles: 9 Chip, 18 CPU. (V=120 H=84 -> V=120 H=93)
  D0 00001224   D1 000000E8   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 0000 (OR) Chip latch 00000000
00026b6e 4e75                     rts  == $00026b42							; rts  == $00026b42	is correct
Next PC: 00026b70
>t
Cycles: 8 Chip, 16 CPU. (V=120 H=93 -> V=120 H=101)
  D0 00001224   D1 000000E8   D2 0000FFFD   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0006A4D8   A1 00026B70   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 3400 (MOVE) Chip latch 00000000
00026b42 4e75                     rts  == $00c4f7b8							; rts  == $00c4f7b8 is correct
Next PC: 00026b44
>

Die Angabe der Rücksprungadresse rts  == $00c4f7b8 ist im Einzelschrittbetrieb
richtig. Bei der disassemblierten Ausgabe ist die Rücksprungadresse 
nur bedingt richtig. Aufpassen!