
; Listing11l4.s	 - Welle der Figur, erhalten durch Ändern jeder Zeile
; Zeiger auf Bitplanes sowie die Nuance von color0
; fließt nach oben.

	Section BITPLANEolljelly,code

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include "/Sources/startup2.s"	; speichern interrupt, dma etc.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

scr_bytes	= 40				; Anzahl der Bytes für jede horizontale Zeile.
								; Daraus berechnen wir die Bildschirmbreite,
								; Multiplizieren von Bytes mit 8: normaler Bildschirm 320/8 = 40
								; z.B. für einen 336 Pixel breiten Bildschirm 336/8 = 42
								; Beispielbreiten:
								; 264 pixel = 33 / 272 pixel = 34 / 280 pixel = 35
								; 360 pixel = 45 / 368 pixel = 46 / 376 pixel = 47
								; ... 640 pixel = 80 / 648 pixel = 81 ...

scr_h		= 256				; Bildschirmhöhe in Zeilen
scr_x		= $81				; Startbildschirm, XX-Position (normal $xx81) (129)
scr_y		= $2c				; Startbildschirm, YY-Position (normal $2cxx) (44)
scr_res		= 1					; 2 = HighRes (640*xxx) / 1 = LowRes (320*xxx)
scr_lace	= 0					; 0 = non interlace (xxx*256) / 1 = interlace (xxx*512)
ham			= 0					; 0 = nicht ham / 1 = ham
scr_bpl		= 1					; Anzahl Bitplanes

; Parameter automatisch berechnet

scr_w		= scr_bytes*8		; Bildschirmbreite
scr_size	= scr_bytes*scr_h	; Größe des Bildschirms in Bytes
BPLC0	= ((scr_res&2)<<14)+(scr_bpl<<12)+$200+(scr_lace<<2)+(ham<<11)
DIWS	= (scr_y<<8)+scr_x
DIWSt	= ((scr_y+scr_h/(scr_lace+1))&255)<<8+(scr_x+scr_w/scr_res)&255
DDFS	= (scr_x-(16/scr_res+1))/2
DDFSt	= DDFS+(8/scr_res)*(scr_bytes/2-scr_res)


START:
	bsr.s	SetCop				; copperlist erstellen

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper								
	move.l	#COPPER,$80(a5)		; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.w	PrintCarattere		; Drucken Sie jeweils ein Zeichen
	BSR.w	SistemaCop			; Kopieren Sie die Werte aus den Tabellen in den Cop
	BSR.W	RoteaTabOndegg		; Drehen Sie die Werte in der Wellentabelle
	BSR.W	RoteaTabColori		; Drehen Sie die Farbtabelle

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts							; exit

;***************************************************************************
; Diese Routine erstellt die copperliste und gibt die ersten Werte ein
;***************************************************************************

;	           ° o·
;	___   _)))  .  °
;	\ -\_/ (_.)  ·°
;	 \-     ___)o·
;	 /-/`-----'
;	 ¯¯ g®m

SETCOP:
	LEA	COPPER1,A0				; Adresse coppereffekt
	MOVE.L	ADRCOL1(PC),A2		; Zeiger auf die Farbtabelle
	MOVE.L	#$2c07FFFE,D7		; Wait (erste Zeile $30)
	MOVE.L	#BITPLANE,D0		; Adresse der bitplane
	LEA	TABOSC(PC),A1			; Tabelle Rolle
	MOVEQ	#39-1,D5			; Anzahl der für diesen Effekt verwendbaren Tabellenwerte.
								; (Anmerkung: es ist es nicht leicht zu verstehen
								; wie viele Zeilen in der Praxis entlang des Effekts sind,
								; warum es notwendig ist, jeden von diesen zu berechnen
								; die Schleife kann die Zeile mehrmals wiederholen.
FaiEffetto:
	MOVE.B	(A1)+,D6			; nächster Wellenwert in d6
	TST.B	D6					; müssen wir die Linie schon schneiden?
	BNE.S	RipuntaLinea		; wenn nicht, zeigen auf...
	ADDI.L	#40,D0				; oder addieren Sie die Länge von 1 Strich - Spitze
								; zur nächsten Bitplane-Zeile
	DBRA	D5,FaiEffetto		; und die Schleife geht weiter
	BRA.w	FineEffetto

RipuntaLinea:
	MOVE.L	D7,(A0)+			; das Wait in die Coplist eintragen
	SWAP	D0					; austauschen Bitplane-Adresse 
	MOVE.W	#$E0,(A0)+			; BPL1PTH
	MOVE.W	D0,(A0)+			; Zeiger hohes word
	SWAP	D0					; austauschen Bitplane-Adresse 
	MOVE.W	#$E2,(A0)+			; BPL1PTL
	MOVE.W	D0,(A0)+			; Zeiger niedriges word
	TST.W	(A2)				; Ende Farbtabelle?
	BNE.S	SETCOP2				; Wenn noch nicht, ok
	MOVE.L	ADRCOL2(PC),A2		; Ansonsten: Farbetabelle -> Neustart
SETCOP2:
	MOVE.W	#$180,(A0)+			; Register color0
	MOVE.W	(A2)+,(A0)+			; Wert color0
	ADDI.L	#$01000000,D7		; Lassen Sie eine Zeile unten warten
	BCC.S	SETCOP3				; sind wir an $FF angekommen? wenn noch nicht ok
	MOVE.L	#$FFDFFFFE,(A0)+	; ansonsten Bereichsende ntsc ($FF)
	MOVE.L	#$0011FFFE,D7		; Und Sie müssen diese 2 wait setzen .
SETCOP3:
	SUBQ.B	#1,D6				; Sub-Wert der "Zeilenwiederholung" aus TABOSC.
	TST.B	D6					; Haben wir die Zeile oft genug wiederholt?
	BNE.S	RipuntaLinea		; Wenn noch nicht, legen Sie es zurück und wiederholen Sie es

	ADDI.L	#40,D0				; Andernfalls zielen wir auf weniger als 1 Linie ab
	DBRA	D5,FaiEffetto		; und lassen Sie uns den Effekt fortsetzen.

FineEffetto:
	MOVE.L	#$01000200,(A0)+	; eintragen bplcon0 = no bitplanes
	MOVE.L	#$FFFFFFFE,(A0)+	; eintragen Ende copperlist
	RTS

;****************************************************************************
; Diese Routine dreht die Farben direkt in die Farbtabelle!
;****************************************************************************

;	 ______________
;	 \    \__/    / 
;	  \__________/
;	  __|______|__
;	__(\___)(___/)__
;	\_\    \/    /_/
;	   \ \____/ /
;	    \______/ g®m
;

RoteaTabColori:
	LEA	COLORSTAB(PC),A0		; Farbtabelle
	MOVE.W	(A0)+,D0			; speichern der ersten Farbe in d0
RoteaTabColori2:
	TST.W	(A0)				; Ende Tabelle?
	BNE.S	RoteaTabColori1		; Wenn noch nicht, ok
	MOVE.W	D0,-2(A0)			; andernfalls wird die erste Farbe als letzte Farbe verwendet
	RTS

RoteaTabColori1:
	MOVE.W	(A0)+,-4(A0)		; verschiebe (drehe) die Farbe "zurück"
	BRA.S	RoteaTabColori2

;***************************************************************************
; Diese Routine dreht die Werte in der Tabelle "TABOSC"
;***************************************************************************

RoteaTabOndegg:
	LEA	TABOSC(PC),A0			; Adresse Tabelle
	MOVEQ	#63-1,D7			; Anzahl der Werte in der Tabelle
	MOVE.B	(A0),D0				; speichere den ersten Wert in d0
RoteaTabOndegg1:
	MOVE.B	1(A0),(A0)+			; Werte "zurück" verschieben.
	DBRA	D7,RoteaTabOndegg1
	MOVE.B	D0,-1(A0)			; Gibt den ersten Wert als den letzten zurück
	RTS

;***************************************************************************

ADRCOL1:
	DC.L	COLORSTAB
ADRCOL2:
	DC.L	COLORSTAB

COLORSTAB:
	DC.W	$FC9,$EC9,$DC9,$CC9,$CB9,$CA9,$C99,$C9A,$C9B,$C9C
	DC.W	$C9D,$C9E,$C9F,$B9F,$A9F,$99F,$9AF,$9BF,$9CF,$ACF
	DC.W	$BCF,$CCF,$DCF,$ECF,$FCF,$FBF,$FAF,$F9F,$F9E,$F9D
	DC.W	$F9C,$E9C,$D9C,$C9C,$CAC,$CBC,$CCC,$CDC,$CEC,$CFC
	DC.W	$CFB,$CFA,$CF9,$BF9,$AF9,$9F9,$9FA,$9FB,$9FC,$AFC
	DC.W	$BFC,$CFC,$DFC,$EFC,$FFC,$FEC,$FDC,$FCC,$FCB,$FCA
	DC.W	0					; Die Tabelle endet mit der Null

;***************************************************************************
; Die Routine ist nichts als SETCOP ohne die Teile, die die Register schreiben
; und das wait: nur das notwendige steht geschrieben.
; Diese Routine wirkt auf die copperliste, die jede Zeile die Zeiger auf die
; Bitplanes neu definiert. Lesen von einer Tabelle, kennen Sie jede Zeile der
; pic wie oft, um es zu wiederholen, das heißt, um es zurückzugeben. Sind zum 
; Beispiel in der Tabelle die Werte 1,2,3, dann zeigt es auf die erste Zeile 
; in der ersten Zeile des Bildschirms (einmal), dann zeigt es zweimal auf die 
; zweite und die dritte Zeile 3 mal. Hier ist eine "Zeichnung":
;
; Zeile 1
; Zeile 2
; Zeile 2
; Zeile 3
; Zeile 3
; Zeile 3
;
; Beachten Sie, dass sich die Lücke verlängert...
;***************************************************************************

;	 /) ________ (\
;	(__/        \__)
;	  / ___  ___ \
;	  \ \°_)(_°/ /
;	   \__ `' __/
;	    /      \
;	    \("""")/g®m
;	     ¯    ¯

SistemaCop:
	LEA	COPPER1,A0				; Adresse coppereffekt
	MOVE.L	ADRCOL1(PC),A2		; Zeiger auf die Farbtabelle
	MOVE.L	#$2c07FFFE,D7		; Wait (erste Zeile $30)
	MOVE.L	#BITPLANE,D0		; Adresse bitplane
	LEA	TABOSC(PC),A1			; Tabelle Rolle
	MOVEQ	#39-1,D5			; Anzahl der hierfür verwendbaren Tabellenwerte
								; für den Effekt. (Anmerkung: es ist nicht leicht zu verstehen
								; wie viele Zeilen es in der Praxis entlang des Effekts sind?
								; weil es notwendig ist zu berechnen, dass jeder von diesen 
								; Schleife die Zeile mehrmals wiederholen kann.
FaiEffetto2:
	MOVE.B	(A1)+,D6			; Setzen Sie den nächsten Schwankungswert in d6
	TST.B	D6					; Müssen wir die Zeile schon schneiden?
	BNE.S	RipuntaLinea2		; Wenn nicht, wollen wir es anzeigen...
	ADDI.L	#40,D0				; Oder addieren Sie die Länge von 1 Zeile
								; zur nächsten Zeile der Bitebene
	DBRA	D5,FaiEffetto2		; Und setzen Sie die Schleife fort
	BRA.w	FineEffetto2

RipuntaLinea2:
	addq.w	#6,a0				; Überspringen Sie WAIT und BPL1PTH
	SWAP	D0					; Tauschen Sie die Adresse der bitplane aus
	MOVE.W	D0,(A0)+			; Zeigen Sie auf das hohe Wort
	SWAP	D0					; Tauschen Sie die Adresse der bitplane erneut aus
	addq.w	#2,a0				; überspringen Sie BPL1PTL
	MOVE.W	D0,(A0)+			; Zeigen Sie auf das niedrige Wort
	TST.W	(A2)				; Ende Farbtabelle?
	BNE.S	SETCOP22			; Wenn noch nicht, ok
	MOVE.L	ADRCOL2(PC),A2		; Ansonsten: FarbTabelle -> erneut starten
SETCOP22:
	addq.w	#2,a0				; überspringen Sie das Register color0
	MOVE.W	(A2)+,(A0)+			; Wert color0
	ADDI.L	#$01000000,D7		; eine Zeile tiefer warten
	BCC.S	SETCOP32			; sind wir an $FF angekommen? Wenn noch nicht ok,
	addq.w	#4,a0				; Überspringen FFDFFFFE
	MOVE.L	#$0011FFFE,D7		; Und Sie müssen diese 2 waits setzen 
SETCOP32:
	SUBQ.B	#1,D6				; Sub den Wert "Zeilenwiederholung" von TABOSC 
	TST.B	D6					; Haben wir die Zeile oft genug wiederholt?
	BNE.S	RipuntaLinea2		; Wenn noch nicht, wiederhole es

	ADDI.L	#40,D0				; Ansonsten setzen wir weniger als 1 Zeile
	DBRA	D5,FaiEffetto2		; und lassen Sie uns den Effekt fortsetzen.

FineEffetto2:
	RTS

;********************************************************************

; Tabulator mit 64 .byte-Werten. Zeigt an, für wie viele Zeilen dieselbe
; Zeile ist. Bei einem Wert von 2 zum Beispiel wird die Zeile 2 Mal wiederholt,
; d.h. sie wird in der Höhe verdoppelt.

TABOSC:
	DC.B	1,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9
	DC.B	9,9,8,8,7,7,6,6,5,5,4,4,3,3,2,2
	DC.B	2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9
	DC.B	9,9,8,8,7,7,6,6,5,5,4,4,3,3,2,1

	EVEN

*****************************************************************************
;			Druck Routine
*****************************************************************************

PRINTcarattere:
	movem.l	d2/a0/a2-a3,-(SP)
	MOVE.L	PuntaTESTO(PC),A0	; Adresse des zu druckenden Textes a0
	MOVEQ	#0,D2				; d2 löschen
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	CMP.B	#$ff,d2				; Ende des Textsignals? ($FF)
	beq.s	FineTesto			; Wenn ja, beenden Sie ohne zu drucken
	TST.B	d2					; Zeilenende-Signal? ($00)
	bne.s	NonFineRiga			; Wenn nicht, nicht aufhören

	ADD.L	#40*7,PuntaBITPLANE	; wir gehen zum Anfang
	ADDQ.L	#1,PuntaTesto		; erste Zeichenzeile danach
								; (überspringe die NULL)
	move.b	(a0)+,d2			; erstes Zeichen der Zeile nach
								; (überspringe die NULL)

NonFineRiga:
	SUB.B	#$20,D2				; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG
								; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
								; (Das $20 entspricht), IN $00, DAS
								; AUSRUFUNGSZEICHEN ($21) IN $01...
	LSL.W	#3,D2				; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
								; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2			; FINDE DEN GEWÜNSCHTEN BUCHSTABEN IM FONT...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adresse Ziel-Bitplane in a3

								; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)			; Drucke Zeile 1 des Zeichens
	MOVE.B	(A2)+,40(A3)		; Drucke Zeile  2  " "
	MOVE.B	(A2)+,40*2(A3)		; Drucke Zeile  3  " "
	MOVE.B	(A2)+,40*3(A3)		; Drucke Zeile  4  " "
	MOVE.B	(A2)+,40*4(A3)		; Drucke Zeile  5  " "
	MOVE.B	(A2)+,40*5(A3)		; Drucke Zeile  6  " "
	MOVE.B	(A2)+,40*6(A3)		; Drucke Zeile  7  " "
	MOVE.B	(A2)+,40*7(A3)		; Drucke Zeile  8  " "

	ADDQ.L	#1,PuntaBitplane	; wir rücken 8 Bits vor (NÄCHSTES ZEICHEN)
	ADDQ.L	#1,PuntaTesto		; nächstes zu druckendes Zeichen

FineTesto:
	movem.l	(SP)+,d2/a0/a2-a3
	RTS


PuntaTesto:
	dc.l	TESTO

PuntaBitplane:
	dc.l	BITPLANE

;	$00 für "Zeilenende" - $FF für "Textende"

		; Anzahl der Zeichen pro Zeile: 40
TESTO:	     ;		  1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'  * * * * * * * * * * * * * * * * *     ',0 ; 1
	dc.b	'  * MAMMA MIA MI BALLA            *     ',0 ; 2
	dc.b	'  *                    LO SCHERMO *     ',0 ; 3
	dc.b	'  * * * * * * * * * * * * * * * * *     ',$FF ; 4

	EVEN

; Die FONT 8x8-Zeichen, die in CHIP von der CPU und nicht vom Blitter kopiert wurden,
; so kann es auch im FAST RAM sein. In der Tat wäre es besser!

FONT:
	incbin "/Sources/nice.fnt"

;********************************************************************
;				COPPERLIST
;********************************************************************

	section	cooppera,data_C

COPPER:
	dc.w	$8e,DIWS			; DiwStrt
	dc.w	$90,DIWSt			; DiwStop
	dc.w	$92,DDFS			; DdfStart
	dc.w	$94,DDFSt			; DdfStop
	dc.w	$100,BPLC0			; BplCon0
	dc.w	$108,0				; bpl1mod
	dc.w	$10a,0				; bpl2mod
	DC.w	$182,$000			; Color1 (Schrift) - SCHWARZ
COPPER1:
	DCB.b	4000,0	; Achtung! Die Länge des Effekts hängt von 
; der TABOSC-Tabelle ab und es ist nicht einfach, es zu berechnen...
	DC.L	$FFFFFFFE

;********************************************************************
;	die bitplane
;********************************************************************
	section	bitplane,bss_C

BITPLANE:
	ds.b	40*320

	end

Wir haben schon früher einen ähnlichen Effekt gesehen, als wir die Modulos
wechselten und jetzt wechseln stattdessen die bplpointers. Dieses System
ist langsamer als das mit den Modulos, da sie für jede Zeile die Zeiger
vieler Bitebenen ändern müssen. Jedoch könnte es für jede Ebene anders
definiert werden, um seinen Geschäften nachzugehen, wenn der bplmod alle
geraden und / oder ungeraden Planes einbezieht.

Eine Besonderheit dieses Quelltextes ist, dass die Werte der Tabellen für
die Planes und Farben nicht "gewirbelt" werden , indem sie von der copperlist
erneut gelesen und bewegt werden, sondern indem Sie die Werte in den
Tabellen selbst drehen, kopieren Sie einfach aus der copperlistentabelle,
nachdem die Tabelle "gewirbelt" wurde.

Dieses System ist schneller als andere, wenn Sie sie so wie sie ist im 
FAST RAM haben. Wenn Sie den Wert aus der copperliste lesen und später neu
zurück schreiben würden, wir sollten zweimal auf den CHIP-RAM zugreifen, mit
den damit verbundenen "Verzögerungen".
In unserem Fall greifen wir in FAST mit Minimum Zeitverlust auf die Tabelle
zu und wir schreiben nur einmal pro Farbe / Ebene in CHIP. Auf Computern wie
A4000 wird die einzige Verlangsamung durch Lesen / Schreiben in CHIP RAM 
gegeben, daher verdoppelt sich die Geschwindigkeit der Ausführung der Routine.
