
; Listing13k2.s - Optimierungen beim Blitter
; Vorlage: z.B. Listing9f1.s
; Zeile 2157
; Vorlage: z.B. Listing9f1.s
; Routine copia: 5060 Zyklen
; Routine copiaopt: 3796 Zyklen
; Routine copiaopt2: 3862 Zyklen	; (es könnten Zyklen eingespart werden)
; Routine copiaopt3: 3782 Zyklen

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
	move.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	moveQ	#3-1,D1				; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	move.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
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
	bsr.w	copiaopt			; optimierte Kopierroutine ausführen
	nop
	bsr.w	copiaopt2			; optimierte Kopierroutine ausführen
	nop
	bsr.w	copiaopt3			; optimierte Kopierroutine ausführen
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
	
; ************************ KOPIER ROUTINE OPTIMIERT **************************

copiaopt2:
	lea	$dff002,a6			; a6 = DMAConR
	lea DataBlit(pc),a5
	;move.l	DataBlit(pc),a5	; dann zeigt a5 auf eine Wertetabelle
	
	;move.l	#$09f00000,$40-2(a6)		; BLTCON0 und BLTCON1 - Kopie A nach D
	move.l	#$ffffffff,$44-2(a6)		; BLTAFWM und BLTALWM wir werden es später erklären
	;move.l	#(20-160/16)*2,$62-2(a6)	; BltBMod
	move.w	#(20-160/16)*2,$66-2(a6)	; bltdmod		
	;move.w	(20*64)+160/16,d0			; $dff058 - BLTSIZE

; Laden wir nun die Adressregister

	lea	$40-2(a6),a0	; a0 = BltCon0
	lea	$62-2(a6),a1	; a1 = BltBMod
	lea	$50-2(a6),a2	; a2 = BltApt
	lea	$54-2(a6),a3	; a3 = BltDpt
	lea	$58-2(a6),a4	; a4 = BltSize
	moveq	#6,d0		; d0 Konstante zur Überprüfung des Zustands
						; des Blitters.
	move.w	(a5)+,D7	; Anzahl der Blitts
	move.w	#$8400,$96-2(a6) ; nasty enable
BLITLOOP:
	Btst	d0,(a6)		; Wie immer warten wir auf das Ende einiger
	Bne.s	BLITLOOP	; Operationen.
; Bevor wir nach unten schauen, machen wir eine
; Beobachtung, wenn ich in a0 den Wert $40000 habe
; führe ich die Anweisung in drei verschiedenen Fällen aus
				; a)move.b #"1",(a0)
				; b)move.w #"12",(a0)
				; c)move.l #"1234",(a0)
				; Ich werde die folgende Sache bekommen:
				;           (a)	(b)	(c)
				; $40000	"1"	"1"	"1"
				; $40001	"0"	"2"	"2"
				; $40002	"0"	"0"	"3"
				; $40003	"0"	"0"	"4"
				; Wir werden jetzt so etwas tun...
	move.l	(a5)+,(a0)	; $dff040-42 das ist Bltcon0-Bltcon1
	move.l	(a5)+,(a1)	; $dff062-64 das ist BltBMod-BltAMod
	move.l	(a5)+,(a2)	; $dff050 - Kanal A
	move.l	(a5)+,(a3)	; $dff054 - Kanal D
	move.w	(a5)+,(a4)	; $dff058 - BLTSIZE... START!!
	Dbra	d7,BLITLOOP	; Dies für d7 mal.

WBL4:
	btst	d0,(a6)
	bne.s	WBL4
	move.w	#$400,$96-2(a6)	; an dieser Stelle kann auch das Bit blit nasty
							; deaktiviert werden.
	rts

DataBlit: 
	dc.w 3-1	; 3 Bitplanes
	dc.l $09f00000	
	dc.l (20-160/16)*2			; $dff062-64 das ist BltBMod-BltAMod
	dc.l BITPLANE+((20*50)+64/16)*2					; Quelle Plane0:
	dc.l BITPLANE+((20*190)+80/16)*2				; Ziel Plane 1
	dc.w (20*64)+160/16							; $dff058 - BLTSIZE
;-------------		
	dc.l $09f00000
	dc.l (20-160/16)*2			; $dff062-64 das ist BltBMod-BltAMod
	dc.l BITPLANE+40*256+((20*50)+64/16)*2			; Quelle Plane 1
	dc.l BITPLANE+40*256+((20*190)+80/16)*2			; Ziel Plane 2
	dc.w (20*64)+160/16							; $dff058 - BLTSIZE
;-------------			
	dc.l $09f00000
	dc.l (20-160/16)*2			; $dff062-64 das ist BltBMod-BltAMod
	dc.l BITPLANE+80*256+((20*50)+64/16)*2			; Quelle Plane 2
	dc.l BITPLANE+80*256+((20*190)+80/16)*2			; Ziel Plane 3
	dc.w (20*64)+160/16							; $dff058 - BLTSIZE
	

; ************************ KOPIER ROUTINE OPTIMIERT **************************

copiaopt3:
	lea	$dff002,a6			; a6 = DMAConR
	lea DataBlit2(pc),a5

; Laden wir nun die Adressregister
	lea	$40-2(a6),a0				; a0 = BltCon0
	lea	$62-2(a6),a1				; a1 = BltBMod
	lea	$50-2(a6),a2				; a2 = BltApt
	lea	$54-2(a6),a3				; a3 = BltDpt
	lea	$58-2(a6),a4				; a4 = BltSize
	move.w	#(20-160/16)*2,$66-2(a6)	; bltdmod

	move.l	#$09f00000,(a0)			; BLTCON0 und BLTCON1 - Kopie A nach D	
	move.l	#(20-160/16)*2,(a1)		; BLTBMOD	
	move.w	#(20-160/16)*2,(a3)		; BLTDpt
	;move.l	#$ffffffff,$44-2(a6)	; BLTAFWM und BLTALWM wir werden es später erklären

	moveq	#6,d0					; d0 Konstante zur Überprüfung des Zustands
									; des Blitters.
	moveq	#3-1,d7					; Anzahl der Blitts
	move.w	#$8400,$96-2(a6)		; nasty enable
BLITLOOP2:
	Btst	d0,(a6)					; Wie immer warten wir auf das Ende einiger
	Bne.s	BLITLOOP2				; Operationen.
	move.l	(a5)+,(a2)				; $dff050 - Kanal A
	move.l	(a5)+,(a3)				; $dff054 - Kanal D
	move.w	#(20*64)+160/16,(a4)	; $dff058 - BLTSIZE... START!!
	dbra	d7,BLITLOOP2			; Dies für d7 mal.
	
WBL5:
	btst	d0,(a6)
	bne.s	WBL5
	move.w	#$400,$96-2(a6)			; an dieser Stelle kann auch das Bit blit nasty
									; deaktiviert werden.
	rts

DataBlit2: 
	dc.l BITPLANE+((20*50)+64/16)*2					; Quelle Plane0:
	dc.l BITPLANE+((20*190)+80/16)*2				; Ziel Plane 1
;-------------
	dc.l BITPLANE+40*256+((20*50)+64/16)*2			; Quelle Plane 1
	dc.l BITPLANE+40*256+((20*190)+80/16)*2			; Ziel Plane 2
;-------------	
	dc.l BITPLANE+80*256+((20*50)+64/16)*2			; Quelle Plane 2
	dc.l BITPLANE+80*256+((20*190)+80/16)*2			; Ziel Plane 3

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

;*************************************************************************



	
;------------------------------------------------------------------------------
r
Filename: Listing13k2a.s
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
000253c2 0839 0002 00df f016      btst.b #$0002,$00dff016
000253ca 66f6                     bne.b #$f6 == $000253c2 (T)
000253cc 6120                     bsr.b #$20 == $000253ee
000253ce 4e71                     nop
000253d0 6100 0082                bsr.w #$0082 == $00025454
000253d4 4e71                     nop
000253d6 6100 0118                bsr.w #$0118 == $000254f0
000253da 4e71                     nop
000253dc 6100 019e                bsr.w #$019e == $0002557c
000253e0 4e71                     nop
>fl
No breakpoints.
>f 253cc
Breakpoint added.
>fl
0: PC == 000253cc [00000000 00000000]

>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 8384062 Chip, 16768124 CPU. (V=210 H=0 -> V=210 H=44)
  D0 00071D38   D1 0000FFFF   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C029BA   A1 0006A514   A2 00000000   A3 00000000
  A4 00000000   A5 00DFF000   A6 00C00276   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6120 (BSR) 4e71 (NOP) Chip latch 00004E71
000253cc 6120                     bsr.b #$20 == $000253ee
Next PC: 000253ce
;------------------------------------------------------------------------------
>fi nop
Cycles: 2519 Chip, 5038 CPU. (V=210 H=44 -> V=221 H=66)							; 5038 Zyklen für nicht optimierte Routine
  D0 00072510   D1 0000FFFF   D2 00073AF2   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C029BA   A1 0006A514   A2 00000000   A3 00000000
  A4 00000000   A5 00DFF000   A6 00C00276   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6100 (BSR) Chip latch 00006100
000253ce 4e71                     nop
Next PC: 000253d0
;------------------------------------------------------------------------------
>fi nop
Cycles: 1904 Chip, 3808 CPU. (V=221 H=66 -> V=229 H=154)						; 3808 Zyklen für optimierte Routine
  D0 0007050A   D1 0000FFFF   D2 00073AF2   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C029BA   A1 0006C2F2   A2 0006EAF2   A3 000712F2
  A4 00000000   A5 00DFF000   A6 00C00276   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6100 (BSR) Chip latch 00006100
000253d4 4e71                     nop
Next PC: 000253d6
;------------------------------------------------------------------------------
>fi nop
Cycles: 1948 Chip, 3896 CPU. (V=229 H=154 -> V=238 H=59)						; 3896 Zyklen für optimierte Routine
  D0 00000006   D1 0000FFFF   D2 00073AF2   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00DFF040   A1 00DFF062   A2 00DFF050   A3 00DFF054
  A4 00DFF058   A5 0002557C   A6 00DFF002   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6100 (BSR) Chip latch 00006100
000253da 4e71                     nop
Next PC: 000253dc
;------------------------------------------------------------------------------
>fi nop
Cycles: 1895 Chip, 3790 CPU. (V=238 H=59 -> V=246 H=138)						; 3790 Zyklen für optimierte Routine
  D0 00000006   D1 0000FFFF   D2 00073AF2   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00DFF040   A1 00DFF062   A2 00DFF050   A3 00DFF054
  A4 00DFF058   A5 000255EE   A6 00DFF002   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 0839 (BTST) Chip latch 00000839
000253e0 4e71                     nop
Next PC: 000253e2
;------------------------------------------------------------------------------
>fd
All breakpoints removed.
>

; Achtung (Zykluszeiten sind mit Blitterzeiten)
; im Fall ohne Blitter (nur CPU) 
;------------------------------------------------------------------------------
; ;move.w	(a5)+,(a4)	; $dff058 - BLTSIZE... START!! diese Zeile ist auskommentiert
>fi nop
Cycles: 265 Chip, 530 CPU. (V=124 H=154 -> V=125 H=192)
  D0 00000006   D1 0000FFFF   D2 00073AF2   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00DFF040   A1 00DFF062   A2 00DFF050   A3 00DFF054
  A4 00DFF058   A5 000253D0   A6 00DFF002   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 6100 (BSR) Chip latch 00006100
00025236 4e71                     nop
Next PC: 00025238
;------------------------------------------------------------------------------
; ;move.w	#(20*64)+160/16,(a4)	; $dff058 - BLTSIZE... START!! auskommentiert
>fi nop
Cycles: 217 Chip, 434 CPU. (V=125 H=192 -> V=126 H=182)
  D0 00000006   D1 0000FFFF   D2 00073AF2   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00DFF040   A1 00DFF062   A2 00DFF050   A3 00DFF054
  A4 00DFF058   A5 00025444   A6 00DFF002   A7 00C5FDB4
USP  00C5FDB4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 0839 (BTST) Chip latch 00000839
0002523c 4e71                     nop
Next PC: 0002523e
>
