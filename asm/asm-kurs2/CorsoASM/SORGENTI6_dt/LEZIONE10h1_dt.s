
; Lezione10h1.s	 Kollision zwischen BOB und Hintergrund mit dem ZERO-Flag des Blitters.
				; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0		; 
	LEA	BPLPOINTERS,A1			; Zeiger COP
	MOVEQ	#3-1,D1				; Anzahl der Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + LÄNGE EINER PLANE !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse:
	bsr.s	MuoviOggetto		; bewege den Bob
	bsr.w	ControllaCollisione	; Überprüfen und melden Sie alle
						; Kollisionen zwischen Bob und Hintergrund
					
	bsr.w	SalvaSfondo			; Speichere den Hintergrund
	bsr.w	DisegnaOggetto		; zeichne den Bob

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.w	RipristinaSfondo	; stelle den Hintergrund wieder her

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; Wenn nicht, gehe zurück zu mouse:

	rts
	
;****************************************************************************
; Diese Routine bewegt den Bob auf dem Bildschirm.
;****************************************************************************

MuoviOggetto
	addq.w	#1,ogg_y			; Verschiebe den Bob nach unten
	cmp.w	#256-11,ogg_y		; hat es die untere Kante erreicht?
	bls.s	EndMuovi			; wenn kein Ende
	clr.w	ogg_y				; ansonsten von oben starten
EndMuovi
	rts

;***************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG
; angegebenen Koordinaten.
;****************************************************************************

;	 ||||||||
;	 | =  = |
;	@| O  O |@
;	 |  ()  |
;	 ((\__/))
;	  ((()))
;	   ))((
;	    ()

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
	move.w	d0,d2

	or.w	#$0FCA,d0		; ... rechts, in das BLTCON0-Register einzugeben
	lsr.w	#3,d1			; (entspricht einer Division durch 8)
							; Runden auf ein Vielfaches von 8 für den Zeiger
							; auf den Bildschirm, also auf ungerade Adressen
							; (also auch für Bytes, also)
							; x zB: eine 16 als Koordinate wird zum
							; Bytes 2
	and.w	#$fffe,d1		; Ich schließe Bit 0 der
	add.w	d1,a0			; Summe zur Adresse der Bitebene, Finden
							; der richtigen Zieladresse

	lea	figura,a1			; Zeiger Quelle
	moveq	#3-1,d7			; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)		; warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffff0000,$44(a5)	; BLTAFWM = $ffff Es passiert alles
					; BLTALWM = $0000 setzt das letzte Wort zurück


	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	d2,$42(a5)			; BLTCON1 (keine Spezialmodi)
	move.l	#$0022fffe,$60(a5)
	move.l	#$fffe0022,$64(a5)	; BLTAMOD=$fffe=-2 komm zurück
								; an den Anfang der Zeile.
								; BLTDMOD=40-6=34=$22 wie immer
	move.l	#Maschera,$50(a5)	; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirmzeilen)
	move.l	a0,$48(a5)			; BLTCPT  (Bildschirmzeilen)
	move.l	a1,$4c(a5)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Blitter starten !)

	lea	4*11(a1),a1		; zeigt auf die nächste Quellenebene
						; jede plane ist 2 Wörter breit und 
						; 11 Zeilen hoch

	lea	40*256(a0),a0		; zeigt auf die nächste Zielebene
	dbra	d7,PlaneLoop

	rts

;****************************************************************************
; Diese Routine kopiert das Hintergrundrechteck, das mit den 
; BOBs überschrieben wird in einen Puffer
;****************************************************************************

SalvaSfondo:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0			; Adresse berechnen: Jede Zeile besteht aus
							; 40 Bytes
	add.w	d0,a0			; zur Adresse der Abfahrt hinzufügen

	move.w	ogg_x(pc),d1	; Koordinate X
	lsr.w	#3,d1			; (entspricht einer Division durch 8)
							; Runden auf ein Vielfaches von 8 für den Zeiger
							; auf den Bildschirm, also auf ungerade Adressen
							; (also auch für Bytes, also)
							; x zB: eine 16 als Koordinate wird zum
							; Bytes 2
	and.w	#$fffe,d1		; Ich schließe Bit 0 der
	add.w	d1,a0			; Summe zur Adresse der Bitebene, Finden
							; der richtigen Zieladresse

	lea	Buffer,a1			; Zeiger Ziel
	moveq	#3-1,d7			; wiederhole es für jede Ebene
PlaneLoop2:
	btst	#6,2(a5)		; dmaconr
WBlit3:
	btst	#6,2(a5)		; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
					; BLTALWM = $ffff setzt das letzte Wort zurück


	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.l	#$00220000,$64(a5)	; BLTAMOD=40-4=36=$24
								; BLTDMOD=0 Puffer
	move.l	a0,$50(a5)			; BLTAPT - Adresse Quelle
	move.l	a1,$54(a5)			; BLTDPT - Puffer
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Blitter starten !)

	lea	40*256(a0),a0		; zeigt auf die nächste Quellenebene
	lea	6*11(a1),a1			; zeigt auf die nächste Zielebene
							; Jede Blittata ist 3 Wörter breit und 
							; 11 Zeilen hoch
	dbra	d7,PlaneLoop2

	rts

;****************************************************************************
; Diese Routine kopiert den Inhalt des Puffers in das Bildschirmrechteck
; was es vor der BOB-Zeichnung enthielt. Auf diese Weise kommt es auch
; löschte das BOB vom alten Standort.
;****************************************************************************

RipristinaSfondo:
	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0			; Adresse berechnen: Jede Zeile besteht aus
							; 40 Bytes
	add.w	d0,a0			; zur Adresse der Abfahrt hinzufügen

	move.w	ogg_x(pc),d1	; Koordinate X
	lsr.w	#3,d1			; (entspricht einer Division durch 8)
							; Runden auf ein Vielfaches von 8 für den Zeiger
							; auf den Bildschirm, also auf ungerade Adressen
							; (also auch für Bytes, also)
							; x zB: eine 16 als Koordinate wird zum
							; Bytes 2
	and.w	#$fffe,d1		; Ich schließe Bit 0 der
	add.w	d1,a0			; Summe zur Adresse der Bitebene, Finden
							; der richtigen Zieladresse

	lea	Buffer,a1			; Zeiger Quelle
	moveq	#3-1,d7			; wiederhole es für jede Ebene
PlaneLoop3:
	btst	#6,2(a5)		; dmaconr
WBlit4:
	btst	#6,2(a5)		; warte auf das Ende des Blitters
	bne.s	wblit4

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
					; BLTALWM = $0000 setzt das letzte Wort zurück


	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 Kopie von A nach D
	move.l	#$00000022,$64(a5)	; BLTAMOD=0 (Puffer)
								; BLTDMOD=40-6=34=$22
	move.l	a1,$50(a5)			; BLTAPT (Puffer)
	move.l	a0,$54(a5)			; BLTDPT (Bildschirm)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Blitter starten!)

	lea	40*256(a0),a0		; zeigt auf die nächste Zielebene
	lea	6*11(a1),a1			; zeigt auf die nächste Quellenebene
							; Jede Blittata ist 3 Wörter breit und 
							; 11 Zeilen hoch
	dbra	d7,PlaneLoop3
	rts

OGG_Y:		dc.w	0	; hier wird das Y des Objekts gespeichert
OGG_X:		dc.w	100	; hier wird das X des Objekts gespeichert


;****************************************************************************
; Diese Routine steuert das Auftreten einer Kollision
;****************************************************************************

ControllaCollisione

	lea	bitplane,a0			; Ziel in a0
	move.w	ogg_y(pc),d0	; Koordinate Y
	mulu.w	#40,d0			; Adresse berechnen: Jede Zeile besteht aus
							; 40 Bytes
	add.w	d0,a0			; zum Anfang der Adresse hinzufügen

	move.w	ogg_x(pc),d0	; Koordinate X
	move.w	d0,d1			; Kopie
	and.w	#$000f,d0		; Sie wählen die ersten 4 Bits, weil sie 
							; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0			; Die 4 Bits werden zum High-Nibble 
	lsl.w	#4,d0			; des Wortes bewegt...
	move.w	d0,d2

	or.w	#$0AA0,d0	; ... rechts, in das BLTCON0-Register einzugeben
						; nur Kanäle A und C sind aktiv (kein D)
						; führe ein AND zwischen A und C aus

	lsr.w	#3,d1		; (entspricht einer Division durch 8)
						; Runden auf ein Vielfaches von 8 für den Zeiger
						; auf den Bildschirm, also auf ungerade Adressen
						; (also auch für Bytes, also)
						; x zB: eine 16 als Koordinate wird zum
						; Bytes 2
	and.w	#$fffe,d1	; Ich schließe Bit 0 der
	add.w	d1,a0		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

; wartet darauf, dass der Blitter beendet wird, bevor die Register geändert werden
	btst	#6,2(a5)
WBlit_coll:
	btst	#6,2(a5)
	bne.s	wblit_coll

	lea	Maschera,a1			; Zeiger Kollisionsmasken
	moveq	#3-1,d7			; wiederhole es für jede Ebene
CollLoop:

	move.l	#$ffff0000,$44(a5)	; BLTAFWM = $ffff Es passiert alles
					; BLTALWM = $0000 setzt das letzte Wort zurück


	move.w	d0,$40(a5)			; BLTCON0 					
					; nur die Kanäle A und C sind aktiv
					; (nicht D). Führt ein UND zwischen A und C aus
	move.w	#$0000,$42(a5)		; BLTCON1 (keine Spezialmodi)
	move.w	#$0022,$60(a5)		; BLTCMOD=40-6=34=$22
	move.w	#$fffe,$64(a5)		; BLTAMOD=$fffe=-2 komm zurück
								; an den Anfang der Zeile.
	move.l	a1,$50(a5)			; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$48(a5)			; BLTCPT  (Bildschirmzeilen)
	move.w	#(64*11)+3,$58(a5)	; BLTSIZE (Blitter starten !)

	lea	40*256(a0),a0		; Zeigen Sie auf die nächste Ebene auf dem Bildschirm

	btst	#6,2(a5)
WBlit_coll2:
	btst	#6,2(a5)		; warte auf das Ende des Blitters
	bne.s	wblit_coll2		; vor dem Testen des Zero-Flag

	btst	#5,2(a5)		; testet das Zero-Flag.
	beq.s	SiColl			; Wenn das Flag nicht Null ist,
							; eine Kollision war, berichtet.
							; Ansonsten überprüfen Sie die nächste plane

	dbra	d7,CollLoop		; wenn für keine plane die
							; Kollision, verlasse die Schleife
		

NoColl
	move.w	#$000,$180(a5)	; keine Kollisionen aufgetreten:
							; schwarzer Bildschirm
	bra.s	EndColl			; Springen Sie zum Ende der Routine

SiColl	move	#$F00,$180(a5)	; eine Kollision wurde festgestellt:
								; roter Bildschirm

EndColl
	rts

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; WERT MODULO = 0
	dc.w	$10a,0		; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200	; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000

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
; Der Bob ist im normalen Format, 32 Pixel breit (2 Wörter)
; 11 Zeilen hoch und von 3 Bitplanes gebildet

Figura:	dc.l	$007fc000	; plane 1
	dc.l	$03fff800
	dc.l	$07fffc00
	dc.l	$0ffffe00
	dc.l	$1fe07f00
	dc.l	$1fe07f00
	dc.l	$1fe07f00
	dc.l	$0ffffe00
	dc.l	$07fffc00
	dc.l	$03fff800
	dc.l	$007fc000

	dc.l	$00000000	; plane 2
	dc.l	$007fc000
	dc.l	$03fff800
	dc.l	$07fffc00
	dc.l	$0fe07e00
	dc.l	$0fe07e00
	dc.l	$0fe07e00
	dc.l	$07fffc00
	dc.l	$03fff800
	dc.l	$007fc000
	dc.l	$00000000

	dc.l	$007fc000	; plane 3
	dc.l	$03803800
	dc.l	$04000400
	dc.l	$081f8200
	dc.l	$10204100
	dc.l	$10204100
	dc.l	$10204100
	dc.l	$081f8200
	dc.l	$04000400
	dc.l	$03803800
	dc.l	$007fc000

Maschera:
	dc.l	$007fc000
	dc.l	$03fff800
	dc.l	$07fffc00
	dc.l	$0ffffe00
	dc.l	$1fe07f00
	dc.l	$1fe07f00
	dc.l	$1fe07f00
	dc.l	$0ffffe00
	dc.l	$07fffc00
	dc.l	$03fff800
	dc.l	$007fc000

;****************************************************************************

BITPLANE:
	incbin	"amiga.raw"		; Hier laden wir die Figur ein
					; RAWBLIT-Format (oder interleaved),
					; mit KEFCON konvertiert.

;****************************************************************************

	SECTION	BUFFER,BSS_C

; Dies ist der Puffer, in dem wir den Hintergrund von Zeit zu Zeit speichern.
; hat die gleichen Abmessungen wie eine Blittata: Höhe 11, Breite 3 Wörter
; 3 Bit-Ebenen

Buffer:
	ds.w	11*3*3

	end

;****************************************************************************

In diesem Beispiel wird gezeigt, wie Kollisionen zwischen dem Bob und dem 
Hintergrund erkannt werden. Um Kollision zu erkennen, verwenden Sie das 
Zero-Flag des Blitters. Die Technik ist die Folgende: Wir führen eine
Blittata durch, die ein UND zwischen der Maske des Bobs und der Maske des 
Hintergrund macht, aber ohne das Ausgabeergebnis zu schreiben. Wenn die 
UND-Verknüpfung als Ergebnis eine Null für alle Bits der Blittata liefert, 
nimmt das Zero-Flag den Wert 1 an. Die Tatsache, dass die AND-Operation
ein 0-Ergebnis lieferte, bedeutet, dass in keinem Fall ein Teil der Maske 
mit dem Hintergrund übereinstimmt, so gibt es keine Kollision.
Wenn stattdessen mindestens ein Bit der Maske mit einem Hintergrund 
übereinstimmt, bedeutet dies dass eine Kollision auftritt. In diesem Fall
wie beim UND zwischen diesen 2 Bits ist das Ergebnis 1, das ZERO-Flag nimmt 
den Wert 0 an und von diesem können wir verstehen, dass es eine Kollision 
gegeben hat.
Beachten Sie, dass die Maske für den Bob zwar vorhanden ist, für den 
Hintergrund jedoch nicht. Diese Tatsache zwingt uns, die Kollision zwischen 
der Bobmaske und allen Ebenen der Figur zu überprüfen. Mit einer 
Hintergrundmaske könnten wir die Kollision mit nur einer blittata zwischen 
den Masken testen. Machen Sie es als Übung.
Beachten Sie auch, dass Sie vor dem Testen des Zero-Flags auf das Ende 
der Blittata warten müssen.