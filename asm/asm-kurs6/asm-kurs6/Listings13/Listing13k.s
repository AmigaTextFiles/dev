
; Listing13k.s - Optimierungen beim Blitter
; Vorlage: z.B. Listing9f1.s
; Zeile 2110

; Routine copia: 5060 Zyklen	(Zyklen können schwanken)
; Routine copiaopt: 3796 Zyklen
; Routine copiaopt2: xx Zyklen

; Listing9f1.s	BLITT, in dem wir ein Rechteck von einem Punkt zu einem 
			; anderen Punkt des gleichen Bildschirms kopieren
			; Linke Taste, um den Blitt auszuführen, rechts um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"//Sources/startup1.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse1:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1				; wenn nicht, nicht abbrechen

	bsr.s	copia				; Kopierroutine ausführen
	nop
	bsr.s	copiaopt			; optimierte Kopierroutine ausführen
	nop
	

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; Wenn nicht, gehe zurück zu mouse2:

	rts


; ************************ KOPIER ROUTINE ****************************

; Ein Rechteck mit der Breite = 160 und der Höhe = 20 wird kopiert
; aus den Koordinaten X1 = 64, Y1 = 50 (Quelle)
; zu den Koordinaten X2 = 80, Y2 = 190 (Ziel)

;	   .  , _ .
;	   ¦\_|/_/l
;	  /¯/¬\/¬\¯\
;	 /_( ©( ® )_\
;	l/_¯\_/\_/¯_\\
;	/ T (____) T \\
;	\/\___/\__/  //
;	(_/  __     T|
;	 l  (. )    |l\
;	  \  ¯¯    // /
;	   \______//¯¯
;	  __Tl___Tl xCz
;	 C____(____)

copia:

; Laden Sie die Quell- und Zieladressen in 2 Variablen

	move.l	#bitplane+((20*50)+64/16)*2,d0	; Adresse Quelle
	move.l	#bitplane+((20*190)+80/16)*2,d2	; Adresse Ziel

								; Schleife Blitt
	moveq	#3-1,d1				; für alle bitplanes wiederholen 
copia_loop:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie A nach D
	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir werden es später erklären

; Lade die Zeiger

	move.l	d0,$50(a5)			; bltapt
	move.l	d2,$54(a5)			; bltdpt

; Diese 2 Anweisungen legen die Quell- und Zielmodulo fest
; Beachten Sie, dass Quelle und Ziel innerhalb des selben 
; Bildschirms liegen das MODULO ist das gleiche.
; das Modulo berechnet sich nach der Formel (H-L) * 2 (H ist die Breite der
; Bitebene in Worten und L ist die Breite des Bildes, immer in Worten)
; das haben wir in der Lektion gesehen, (20-160 / 16) * 2 = 20
; 20 words - (160 Pixel / 16 Pixel/word) * 2 = 20 Bytes

	move.w	#(20-160/16)*2,$64(a5)	; bltamod
	move.w	#(20-160/16)*2,$66(a5)	; bltdmod

; Beachten Sie auch, dass Sie, da die 2 Register aufeinanderfolgende 
; Adressen haben, können Sie eine einzige Anweisung anstelle von 2
; verwenden (denken Sie daran, dass 20 = $14) ist:
; move.l # $00140014,$64(a5); Bltamod und Bltdmod

	move.w	#(20*64)+160/16,$58(a5)		; bltsize						
								; Höhe 20 Zeilen
								; 160 Pixel breit (= 10 Wörter)
						
; Aktualisieren Sie die Variablen, die die Adressen enthalten, damit sie in 
; den folgenden Bitebenen darauf zeigen

	add.l	#40*256,d2			; Zieladresse nächste Ebene
	add.l	#40*256,d0			; Quelladresse nächste Ebene

	dbra	d1,copia_loop

	btst	#6,$02(a5)			; warte auf das Ende des Blitters
waitblit2:
	btst	#6,$02(a5)
	bne.s	waitblit2
	rts

; ************************ KOPIER ROUTINE OPTIMIERT **************************

copiaopt:
	move.l	#$09f00000,$40(a5)		; BLTCON0 und BLTCON1 - Kopie A nach D
	move.l	#$ffffffff,$44(a5)		; BLTAFWM und BLTALWM wir werden es später erklären
	move.w	#(20-160/16)*2,$64(a5)	; bltamod
	move.w	#(20-160/16)*2,$66(a5)	; bltdmod
	;move.w	#(20*64)+160/16,$58(a5)	; bltsize						
	move.w	#(20*64)+160/16,d0		; 160 Pixel breit (= 10 Wörter)							
									; Höhe 20 Zeilen
	
; Laden Sie die Quell- und Zieladressen in 2 Variablen
	
	; move.l	#bitplane+((20*190)+80/16)*2,d2	; Adresse Ziel
	movea.l	#BITPLANE+((20*190)+80/16)*2,a1				; Ziel Plane 1
	movea.l	#BITPLANE+40*256+((20*190)+80/16)*2,a2		; Ziel Plane 2
	movea.l	#BITPLANE+80*256+((20*190)+80/16)*2,a3		; Ziel Plane 3
	

WBL0:
	btst	#6,2(a5)
	bne.s	WBL0
BLITZ:						; die Register wurden bereits aktiviert
	move.w	#$8400,$96(a5)	; einschalten blit nasty
	move.l	Plane0,$50(a5)	; Zeiger Kanal A
	move.l	a1,$54(a5)		; Zeiger Kanal D
	move.w	d0,$58(a5)		; Start Blitter!!!
WBL1:
	Btst	#6,2(a5)		; hier muss die CPU auf das Ende warten...
	Bne.s	WBL1			; also muss der Blitter maximal gehen!
	move.l	Plane1,$50(a5)	; Zeiger Kanal A
	move.l	a2,$54(a5)		; Zeiger Kanal D
	move.w	d0,$58(a5)		; Start Blitter!!!
WBL2:
	Btst	#6,2(a5)		; wie oben
	Bne.s	WBL2
	move.l	Plane2,$50(a5)	; ebenso
	move.l	a3,$54(a5)
	move.w	d0,$58(a5)
WBL3:
	btst	#6,2(a5)
	bne.s	WBL3
	move.w	#$400,$96(a5)	; an dieser Stelle kann auch das Bit blit nasty
	rts						; deaktiviert werden.


Plane0:
	dc.l	BITPLANE+((20*50)+64/16)*2			; Quelle Plane 1
Plane1:
	dc.l	BITPLANE+40*256+((20*50)+64/16)*2	; Quelle Plane 1
Plane2:
	dc.l	BITPLANE+80*256+((20*50)+64/16)*2	; Quelle Plane 1
	

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$100,$3200			; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$0180,$000			; color0
	dc.w	$0182,$475			; color1
	dc.w	$0184,$fff			; color2
	dc.w	$0186,$ccc			; color3
	dc.w	$0188,$999			; color4
	dc.w	$018a,$232			; color5
	dc.w	$018c,$777			; color6
	dc.w	$018e,$444			; color7

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

BITPLANE:
	incbin	"//Sources/amiga.raw"	; Hier laden wir die Figur	
	
	end

;****************************************************************************

In diesem Beispiel kopieren wir mit dem Blitter ein Bild, das aus drei 
Bitebenen gebildet wird. Beachten Sie, dass die Schleife, in der die Blitts
ausgeführt werden, strukturiert ist.
Die Quell- und Zieladressen werden in 2 Datenregister des Prozessors geladen,
die als Variablen verwendet werden. Bei jeder Wiederholung werden sie
modifiziert, um auf die nächste Bitebene zu zeigen. 
Dazu wird die Formel verwendet:

ADRESSE2 = ADRESSE1+2*H*V

Das hatten wir in der Lektion gesehen. In unserem Beispiel ist V = 256 (die
Anzahl der Zeilen) und H = 20 (die Breite des Bildschirms in Worten).

In diesem Beispiel sind Quelle und Ziel der Blitts auf dem gleichen Bildschirm
enthalten. Deshalb ist die Form für beide gleich und wird nach der üblichen
Formel berechnet.


;------------------------------------------------------------------------------
r
Filename: Listing13h.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
00025fc6 0839 0002 00df f016      btst.b #$0002,$00dff016
00025fce 66f6                     bne.b #$f6 == $00025fc6 (T)
00025fd0 6112                     bsr.b #$12 == $00025fe4
00025fd2 4e71                     nop
00025fd4 6174                     bsr.b #$74 == $0002604a
00025fd6 4e71                     nop
00025fd8 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00025fe0 66f6                     bne.b #$f6 == $00025fd8 (T)
00025fe2 4e75                     rts  == $00025ef6
00025fe4 203c 0006 ad10           move.l #$0006ad10,d0
>f 25fd0
Breakpoint added.
>fl
0: PC == 00025fd0 [00000000 00000000]

>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 5011643 Chip, 10023286 CPU. (V=210 H=0 -> V=105 H=37)
  D0 00071D38   D1 0000FFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00C029BA   A1 0006A514   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 00DFF000   A6 00C00276   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6112 (BSR) 4e71 (NOP) Chip latch 00004E71
00025fd0 6112                     bsr.b #$12 == $00025fe4
Next PC: 00025fd2
;------------------------------------------------------------------------------
>fi nop
Cycles: 2530 Chip, 5060 CPU. (V=105 H=37 -> V=116 H=70)								; 5060 Zyklen für nicht optimierte Routine
  D0 00072510   D1 0000FFFF   D2 00073AF2   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00C029BA   A1 0006A514   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 00DFF000   A6 00C00276   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6174 (BSR) Chip latch 00006174
00025fd2 4e71                     nop
Next PC: 00025fd4
;------------------------------------------------------------------------------
>t
Cycles: 2 Chip, 4 CPU. (V=116 H=70 -> V=116 H=72)
  D0 00072510   D1 0000FFFF   D2 00073AF2   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00C029BA   A1 0006A514   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 00DFF000   A6 00C00276   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6174 (BSR) 4e71 (NOP) Chip latch 00004E71
00025fd4 6174                     bsr.b #$74 == $0002604a
Next PC: 00025fd6
;------------------------------------------------------------------------------
>fi nop
Cycles: 1898 Chip, 3796 CPU. (V=116 H=72 -> V=124 H=154)							; 3796 Zyklen für optimierte Routine
  D0 0007050A   D1 0000FFFF   D2 00073AF2   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00C029BA   A1 0006C2F2   A2 0006EAF2   A3 000712F2
  A4 FFFFFFFF   A5 00DFF000   A6 00C00276   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 0839 (BTST) Chip latch 00000839
00025fd6 4e71                     nop
Next PC: 00025fd8
>
;------------------------------------------------------------------------------
>H 100																				; zu Beginn nicht optimierte Routine
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00025ff8 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00025ff8 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00025ff8 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00025ff8 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00025ff8 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00025ff8 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00025ff8 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00025ffe 66f8                     bne.b #$f8 == $00025ff8 (T)
 0 00026000 2b7c 09f0 0000 0040      move.l #$09f00000,(a5,$0040) == $00dff040
 0 00026008 2b7c ffff ffff 0044      move.l #$ffffffff,(a5,$0044) == $00dff044
 0 00026010 2b40 0050                move.l d0,(a5,$0050) == $00dff050
 0 00026014 2b42 0054                move.l d2,(a5,$0054) == $00dff054
 0 00026018 3b7c 0014 0064           move.w #$0014,(a5,$0064) == $00dff064
 0 0002601e 3b7c 0014 0066           move.w #$0014,(a5,$0066) == $00dff066
 0 00026024 3b7c 050a 0058           move.w #$050a,(a5,$0058) == $00dff058
 0 0002602a 0682 0000 2800           add.l #$00002800,d2
 0 00026030 0680 0000 2800           add.l #$00002800,d0
 0 00026036 51c9 ffba                dbf .w d1,#$ffba == $00025ff2 (F)
 0 0002603a 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026040 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026046 66f8                     bne.b #$f8 == $00026040 (T)
 0 00026048 4e75                     rts  == $00025fd6
 0 00025fd2 4e71                     nop
 0 00025fd4 6174                     bsr.b #$74 == $0002604a							; optimierte Routine
 0 0002604a 2b7c 09f0 0000 0040      move.l #$09f00000,(a5,$0040) == $00dff040
 0 00026052 2b7c ffff ffff 0044      move.l #$ffffffff,(a5,$0044) == $00dff044
 0 0002605a 3b7c 0014 0064           move.w #$0014,(a5,$0064) == $00dff064
 0 00026060 3b7c 0014 0066           move.w #$0014,(a5,$0066) == $00dff066
 0 00026066 303c 050a                move.w #$050a,d0
 0 0002606a 227c 0006 c2f2           movea.l #$0006c2f2,a1
 0 00026070 247c 0006 eaf2           movea.l #$0006eaf2,a2
 0 00026076 267c 0007 12f2           movea.l #$000712f2,a3
 0 0002607c 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 00026082 66f8                     bne.b #$f8 == $0002607c (T)
 0 00026084 3b7c 8400 0096           move.w #$8400,(a5,$0096) == $00dff096
 0 0002608a 2b79 0002 60da 0050      move.l $000260da [0006ad10],(a5,$0050) == $00dff050
 0 00026092 2b49 0054                move.l a1,(a5,$0054) == $00dff054
 0 00026096 3b40 0058                move.w d0,(a5,$0058) == $00dff058
 0 0002609a 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 000260a0 66f8                     bne.b #$f8 == $0002609a (T)
 0 000260a2 2b79 0002 60de 0050      move.l $000260de [0006d510],(a5,$0050) == $00dff050
 0 000260aa 2b4a 0054                move.l a2,(a5,$0054) == $00dff054
 0 000260ae 3b40 0058                move.w d0,(a5,$0058) == $00dff058
 0 000260b2 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 000260b8 66f8                     bne.b #$f8 == $000260b2 (T)
 0 000260ba 2b79 0002 60e2 0050      move.l $000260e2 [0006fd10],(a5,$0050) == $00dff050
 0 000260c2 2b4b 0054                move.l a3,(a5,$0054) == $00dff054
 0 000260c6 3b40 0058                move.w d0,(a5,$0058) == $00dff058
 0 000260ca 082d 0006 0002           btst.b #$0006,(a5,$0002) == $00dff002
 0 000260d0 66f8                     bne.b #$f8 == $000260ca (T)
 0 000260d2 3b7c 0400 0096           move.w #$0400,(a5,$0096) == $00dff096
 0 000260d8 4e75                     rts  == $00025fd6
 0 00025fd6 4e71                     nop
>
