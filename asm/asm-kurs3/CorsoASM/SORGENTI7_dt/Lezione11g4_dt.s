
; Lezione11g4.s	- Horizontaler Bildlaufeffekt von Farben mit dem Copper

	SECTION	Supercar,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s" ; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:
	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0		; warte auf Zeile $130 (304)
	BNE.S	Waity1

	btst	#2,$dff016	; richtige Taste gedrückt?
	beq.s	Mouse2		; Wenn nicht, dann LineCop ausführen

	bsr.s	LineCop		; Effekt "supercar"

mouse2:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0		; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts

; Diese Routine führt Farben zyklisch aus der Tabelle in die beiden Zeilen 
; bestehend aus 54 "dc.l $1800000" ein. Der Effekt ist wie immer möglich da 
; der copper eine aus 2 Wörtern gebildete Anweisung liest und die notwendige 
; Zeit zum Lesen 4 Pixel pro Word benötigt, das heißt 8 Pixel für jede 
; vollständige Anweisung. 
; Wenn wir das für einem 320 Pixel breiten Bildschirm berechnen können wir
; die Farbe tatsächlich 40-mal horizontal ändern (320/8 = 40).
; In diesem Fall gehen wir jedoch von der vertikalen Overscan-Position aus.
; Das ist außerhalb der Ränder des Monitors (die Wartezeit beträgt 
; dc.w $2901,$FFFE), und Sie kommen auf der anderen Seite nach rechts raus.
; Theoretisch würden wir einen 54 * 8 = 432 Pixel breiten (Monitor erlaubt) machen.
; Beachten Sie, dass wir uns auf 8 Pixel LOWRES beziehen. Bei HIRES bleibt die
; Größe unverändert und erscheint natürlich in 16 Pixel Abstand.
; 

;	      /////////
;	     /       /_____________________
;	    / ___ __//                     \
;	   / ______//  eY! fig sta rutin!   \
;	 _/ /  ® \©\\_ _____________________/
;	(_  \____/_/ / /
;	 \ _       \ \/
;	  \/    (·__)
;	  /        |
;	 /_____ (o)|
;	   T T`----'
;	   l_! xCz

LineCop:
	lea	TabellaColori(PC),a0
	lea	FineTabColori(PC),a3
	lea	EffInCop,a1					; horizontale Bar Adresse 1
	lea	EffInCop2,a2				; horizontale Bar Adresse 2
	moveq	#54-1,d3				; Anzahl der horizontalen Farben
	addq.l	#2,ColBarraAltOffset	; Niedriger Balken - Farben  
									; nach links scrollen
	subq.l	#2,ColBarraBassOffset	; Hoher Balken - Farben  
									; nach rechts scrollen
	move.l	ColBarraAltOffset(PC),d0	; Start Offset (1)
	add.l	d0,a0		; Finden Sie die richtige Farbe in der Farbtabelle
						; entsprechend dem aktuellen Offset
	cmp.w	#-1,(a0)	; sind wir am Ende der Tabelle? (angedeutet
						; mit einem dc.w -1)
	bne.s	CSalta		; wenn nicht, mach weiter
	clr.l	ColBarraAltOffset		; sonst wieder von der
	lea	TabellaColori(PC),a0		; ersten Farbe gehen
CSalta:
	move.l	ColBarraBassOffset(PC),d1	; Start Offset (2)
	sub.l	d1,a3					; finde die richtige Farbe
	cmp.w	#-1,-(a3)				; sind wir am Ende der Tabelle?
	bne.s	MettiColori				; wenn noch nicht, dann weitermachen
	move.l	#FineTabColori-TabellaColori,ColBarraBassOffset ; andernfalls
									; Neustart ab Ende
									; Tabelle (seit dieser Bar
									; rückwärts fließt!)
	lea	FineTabColori-2(PC),a3
MettiColori:
	addq.w	#2,a1					; überspringen die dc.w $180
	addq.w	#2,a2					; überspringen die dc.w $180
	move.w	(a0)+,(a1)+	; Tragen Sie die Farbe in die Coplist ein (Balken 1)
	move.w	(a3),(a2)+	; Tragen Sie die Farbe in die Coplist ein (Balken 2)

	cmp.w	#-1,(a0)	; Sind wir am Ende der Farbtabelle? (Bar1)
	bne.s	NonFine		; wenn nicht, mach weiter
	lea 	TabellaColori(PC),a0	; ansonsten erneut starten (bar1)
NonFine:
	cmp.w	#-1,-(a3)	; befinden wir uns am Anfang des Farbregisters? (Bar2)
	bne.s	NonFine2	; wenn nicht, mach weiter
	lea 	FineTabColori-2(PC),a3	; ansonsten fange am Ende an (bar2)
NonFine2:
	dbra	d3,MettiColori
	rts

*** *** *** *** *** *** *** *** *** ***


ColBarraAltOffset:
	dc.l	0

ColBarraBassOffset:
	dc.l	0



; HINWEIS: Um das Ende (und den Anfang) der Tabelle anzugeben, wird überprüft
; wenn Sie bei dc.w -1 angekommen sind.

	dc.w 	-1	; Ende Tabelle
TabellaColori:
	DC.W	$F0F,$F0E,$F0D,$F0C,$F0B,$F0A,$F09,$F08,$F07,$F06
	DC.W	$F05,$F04,$F03,$F02,$F01,$F00,$F10,$F20,$F30,$F40
	DC.W	$F50,$F60,$F70,$F80,$F90,$FA0,$FB0,$FC0,$FD0,$FE0
	DC.W	$FF0,$EF0,$DF0,$CF0,$BF0,$AF0,$9F0,$8F0,$7F0,$6F0
	DC.W	$5F0,$4F0,$3F0,$2F0,$1F0,$0F0,$0F1,$0F2,$0F3,$0F4
	DC.W	$0F5,$0F6,$0F7,$0F8,$0F9,$0FA,$0FB,$0FC,$0FD,$0FE
	DC.W	$0FF,$0EF,$0DF,$0CF,$0BF,$0AF,$09F,$08F,$07F,$06F
	DC.W	$05F,$04F,$03F,$02F,$01F,$00F,$10F,$20F,$30F,$40F
	DC.W	$50F,$60F,$70F,$80F,$90F,$A0F,$B0F,$C0F,$D0F,$E0F
FineTabColori:
	dc.w	-1	; Ende Tabelle


	section CList,code_c

CopperList:
	dc.w	$100,$200	; BPLCON0 - 0 bitplanes
	dc.w	$180,$000	; Color0 schwarz

	dc.w	$2901,$FFFE	; warte auf Zeile $29
EffInCop2:
	dcb.l	54,$1800000	; 54 Color0 unten in Schritten von 8
			; Pixel vorwärts jedes Mal, wenn sie die 
			; volle Linie füllen

	dc.w	$2a01,$FFFE	; warte auf Zeile $2a
	dc.w	$180,$000	; Color0 schwarz


	dc.w	$FFDF,$FFFE	; Wait speziell, um in den PAL-Bereich zu gehen

	dc.w	$2A01,$FFFE	; warte auf Zeile $2a+$ff
EffInCop:
	dcb.l	54,$1800000	; 54 Color0 unten in Schritten von 8
			; Pixel vorwärts jedes Mal, wenn sie die 
			; volle Linie füllen

	dc.w	$2B07,$FFFE	; warte auf Zeile $ff+$2b
	dc.w	$180,$000	; Color0 schwarz

	dc.w	$FFFF,$FFFE	; Ende copperlist

	end

