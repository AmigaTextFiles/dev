
; Lezione10e2.s		Löschen und Zeichnen mit coppermonitor
			; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#3-1,D1			; Anzahl der Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0		; + LÄNGE EINER PLANE !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	move.w	#0,ogg_x
	move.w	#0,ogg_y

mouse:

	addq.w	#1,ogg_y
	cmp.w	#130,ogg_y
	beq.s	fine

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$0d000,d2	; Warte auf Zeile $D0
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $D0
	BNE.S	Waity1

;	   \\\|||///
;	 .  =======
;	/ \| O   O |
;	\ / \`___'/
;	 #   _| |_
;	(#) (     )
;	 #\//|* *|\\
;	 #\/(  *  )/
;	 #   =====
;	 #   ( U )
;	 #   || ||
;	.#---'| |`----.
;	`#----' `-----'

	bsr.s	CancellaOggetto		; lösche den Bob

	move	#$0b0,$180(a5)		; dunkelgrüner Bildschirm, wenn der
						; PROZESSOR die Löschung abgeschlossen hat 

	bsr.s	DisegnaOggetto		; zeichne den Bob

	move	#$b00,$180(a5)		; dunkelroter Bildschirm, wenn der
						; PROZESSOR das Zeichnen abgeschlossen hat

	btst	#6,2(a5)
WBlit_coppermonitor:
	btst	#6,2(a5)	 ;  warte auf das Ende des Blitters
	bne.s	wblit_coppermonitor

	move.w	#$000,$180(a5)

	bra.s	mouse

fine:
	rts


;*****************************************************************************
; Diese Routine löscht den BOB unter Verwendung des Blitters. Die 
; Löschung wird auf dem Rechteck gemacht, das den Bob umgibt.
;****************************************************************************

CancellaOggetto:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0			; Adresse berechnen: Jede Zeile besteht aus
							; 40 Bytes
	add.w	d0,a0			; zur Anfangsadresse hinzufügen

	move.w	ogg_x(pc),d1	; Koordinate X
	lsr.w	#3,d1			; (entspricht einer Division durch 8)
							; Runden auf ein Vielfaches von 8 für den Zeiger
							; auf den Bildschirm, also auf ungerade Adressen
							; (also auch für Bytes, also)
							; x zB: eine 16 als Koordinate wird zum
							; Bytes 2
	and.w	#$fffe,d1		; Ich schließe Bit 0 aus
	add.w	d1,a0			; Summe zur Adresse der Bitebene, Finden
							; der richtigen Zieladresse

	moveq	#3-1,d7			; wiederhole es für jede Ebene
PlaneLoop2:
	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)		; warte auf das Ende des Blitters
	bne.s	wblit3

	move.w	#$0f0,$180(a5)		; coppermonitor! grüner Bildschirm während
								; Löschung

	move.l	#$01000000,$40(a5)	; BLTCON0 und BLTCON1: Löschung
	move.w	#$0004,$66(a5)		; BLTDMOD=40-36=4
	move.l	a0,$54(a5)			; BLTDPT
	move.w	#(64*45)+18,$58(a5)	; BLTSIZE (Blitter starten!)
					; Löschen Sie das umschließende Rechteck
					; des BOBs

	lea	40*256(a0),a0		; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop2

	rts				

;****************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG
; angegebenen Koordinaten
;****************************************************************************

DisegnaOggetto:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0			; Adresse berechnen: Jede Zeile besteht aus
							; 40 Bytes
	add.w	d0,a0			; zur Anfangsadresse hinzufügen

	move.w	ogg_x(pc),d0	; Koordinate X
	move.w	d0,d1			; Kopie
	and.w	#$000f,d0		; Sie wählen die ersten 4 Bits, weil sie
							; in den Shifter von Kanal A eingefügt werden
    lsl.w	#8,d0			; Die 4 Bits werden zum High-Nibble 
	lsl.w	#4,d0			; des Wortes bewegt...
	or.w	#$09f0,d0		; ... rechts, in das BLTCON0-Register einzugeben
	lsr.w	#3,d1			; (entspricht einer Division durch 8)
							; Runden auf ein Vielfaches von 8 für den Zeiger
							; auf den Bildschirm, also auf ungerade Adressen
							; (also auch für Bytes, also)
							; x zB: eine 16 als Koordinate wird zum
							; Bytes 2
	and.w	#$fffe,d1		; Ich schließe Bit 0 aus
	add.w	d1,a0			; Summe zur Adresse der Bitebene, Finden
							; der richtigen Zieladresse	
	lea	figura,a1			; Zeiger Quelle
	moveq	#3-1,d7			; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)		 ; warte auf das Ende des Blitters
	bne.s	wblit2

	move.w	#$f00,$180(a5)	; coppermonitor! roter Bildschirm während
							; Löschung.

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
					; BLTALWM = $0000 setzt das letzte Wort zurück


	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	#$0000,$42(a5)		; BLTCON1 (ohne Spezialmodi)
	move.l	#$00000004,$64(a5)	; BLTAMOD=0
								; BLTDMOD=40-36=4 wie immer
	move.l	a1,$50(a5)			; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirmzeilen)
	move.w	#(64*45)+18,$58(a5)	; BLTSIZE (Blitter starten !)

	lea	2*18*45(a1),a1		; zeigt auf die nächste Quellenebene
					; Jede Bitplane ist 18 Wörter breit und 
					; 45 Zeilen hoch

	lea	40*256(a0),a0		; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop

	rts

OGG_Y:		dc.w	0	; das Y des Objekts wird hier gespeichert
OGG_X:		dc.w	0	; das X des Objekts wird hier gespeichert
MOUSE_Y:	dc.b	0	; Die Maus Y ist hier gespeichert
MOUSE_X:	dc.b	0	; Die Maus X ist hier gespeichert

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; WERT MODULO 0
	dc.w	$10a,0		; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200	; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000

	dc.w	$0180,$000	; color0
	dc.w	$0182,$475	; color1
	dc.w	$0184,$fff	; color2
	dc.w	$0186,$ccc	; color3
	dc.w	$0188,$999	; color4
	dc.w	$018a,$232	; color5
	dc.w	$018c,$777	; color6
	dc.w	$018e,$444	; color7

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

; Dies sind die Daten, aus denen die Figur des Bobs besteht.
; Der Bob ist im normalen Format, 288 Pixel breit (18 Wörter)
; 45 Zeilen hoch- und im 3 Bitplanes-Format

Figura:
	incbin	copmon.raw

;****************************************************************************

	section	gnippi,bss_C

BITPLANE:
		ds.b	40*256	; 3 bitplanes
		ds.b	40*256
		ds.b	40*256

	end

;****************************************************************************

In diesem Beispiel verschieben wir ein Rechteck auf dem Bildschirm, das wir 
löschen und dann neu zeichnen. Wir haben eine Reihe von verschiedenen Farben 
für das Markieren der Geschwindigkeit der Routinen und die Arbeit des Blitter 
und des Prozessors verwendet. Wenn die Löschroutine beginnt, wird der Bildschirm
hellrot. Jetzt sind, sowohl der Blitter als auch der Prozessor an der 
Löschoperation beteiligt. Wenn der Prozessor die Abbruchroutine beendet, ist
der Blitter noch nicht mit seiner Aufgabe fertig geworden. Aber der Prozessor
ist bereits frei für andere Aufgaben. Diese Situation wird hervorgehoben, indem 
der Bildschirm am Ende der Routine "DeleteObject" mit einem dunkleren Rot 
eingefärbt wird. An dieser Stelle betritt der Prozessor die Routine 
"DisegnaOggetto". (während der Blitter immer noch beschäftigt ist) Bevor der 
Zeichenvorgang beginnt, ist es notwendig, auf den Blitter zu warten. Wenn der
Blitter endlich fertig ist, ist der Bildschirm hellgrün.
Am Ausgang der Routine "DisegnaOggetto" erscheint der Bildschirm in dunkelgrün,
das darauf wartet, dass der Blitter das Zeichnen beendet. Wenn dies geschieht, 
wird der Bildschirm wieder schwarz.

Beachten Sie außerdem, dass das Löschen und Kopieren (ungefähr) dieselbe 
Zeit erfordern.