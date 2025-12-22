
;  Lezione11l1.s - ändere color0 und bplcon1 in jeder Zeile ($dff102)

	SECTION	coplanes,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO" 

*****************************************************************************
	include	"startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

scr_bytes	= 40	; Anzahl der Bytes für jede horizontale Zeile
			; Daraus berechnen wir die Bildschirmbreite,
			; multiplizieren von Bytes mit 8: normaler Bildschirm 320/8 = 40
			; zB für einen 336 Pixel breiten Bildschirm 336/8 = 42
			; Beispielbreiten:
			; 264 pixel = 33 / 272 pixel = 34 / 280 pixel = 35
			; 360 pixel = 45 / 368 pixel = 46 / 376 pixel = 47
			; ... 640 pixel = 80 / 648 pixel = 81 ...

scr_h		= 256	; Bildschirmhöhe in Zeilen
scr_x		= $81	; Startbildschirm, XX-Position (normal $xx81) (129)
scr_y		= $2c	; Startbildschirm, YY-Position (normal $2cxx) (44)
scr_res		= 1	; 2 = HighRes (640*xxx) / 1 = LowRes (320*xxx)
scr_lace	= 0	; 0 = non interlace (xxx*256) / 1 = interlace (xxx*512)
ham			= 0	; 0 = nicht ham / 1 = ham
scr_bpl		= 1	; Anzahl Bitplanes

; Parameter automatisch berechnet

scr_w		= scr_bytes*8		; Bildschirmbreite
scr_size	= scr_bytes*scr_h	; Größe des Bildschirms in Bytes 
BPLC0	= ((scr_res&2)<<14)+(scr_bpl<<12)+$200+(scr_lace<<2)+(ham<<11)
DIWS	= (scr_y<<8)+scr_x
DIWSt	= ((scr_y+scr_h/(scr_lace+1))&255)<<8+(scr_x+scr_w/scr_res)&255
DDFS	= (scr_x-(16/scr_res+1))/2
DDFSt	= DDFS+(8/scr_res)*(scr_bytes/2-scr_res)

START:
;	 ZEIGER BITPLANE

	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTER,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper	
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	move.w	#11,ContaNumLoop1
	move.w	#2,Contatore1
	clr.w	Contatore2

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2	; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $12c
	BNE.S	Waity1
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $12c
	BEQ.S	Aspetta

	btst.b	#2,$dff016
	beq.s	NoEff
	bsr.s	Mainroutine	; färbt die Farben und rollt den bplcon1
NoEff:
	bsr.w	PrintCarattere	; Drucken Sie jeweils ein Zeichen

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************

; Diese Routine ist nicht optimiert. Sie könnten eine optimierte Routine erstellen,
; die eine copperliste erstellt, die am Anfang aufgerufen wird, dann eine 
; andere welche nur die Werte von color1 und bplcon1 ändert.
; Es ist langsam, weil ein System verwendet wurde, was es noch schlimmer machte, aber
; in bestimmten Fällen kann es nützlich sein: Um durch die Tabellen zu 
; "scrollen", wird ein Puffer verwendet, in der die Tabelle selbst gedreht und
; kopiert wird. Dann werden aus dieser Tabelle die Werte wieder in die Starttabelle 
; kopiert. Aber wurde es vorher ohne den Puffer gemacht? Ja!
; Stellen Sie sich eine Routine mit vielen Tabellen vor, die Werte der verschiedenen
; Phasen der Rotation enthalten können. In diesem Fall könnten wir "vorberechnen".
; In vielen Tabellen wurden die Werte in jeder Phase gedreht ... aber vielleicht 
; würden Sie bekommenso, wenig Optimierung das wäre es nicht wert ...
; Kurz schau dir die Routine an, es ist "seltsam" und verwickelt sich wirklich 
; umsonst "alternative" Techniken zu zeigen ... (übertrieben .. das wars!).

*****************************************************************************

;	    ______
;	  .//_____\,
;	   \\ ¦.¦ /
;	   _\\_-_/_. dA!
;	  ( /  :  \ \
;	 / /   :   \ \
;	 \,_,_,:,_,_\/`).
;	   |   |   | (//\\
;	.-./,,_|__,,\.-. \\
;	`------`-------'  `

MainRoutine:
	move.l	a5,-(sp)		  ; speichern a5
	subq.w	#1,Contatore1	  ; markieren Sie diese Ausführung
	tst.w	Contatore1		  ; 2 Frame Vergangenheit?
	bne.w	SaltaRull		  ; Wenn noch nicht, nicht rollen
	move.w	#2,Contatore1	  ; beginne erneut und warte 2 Frames
	cmp.w	#15,Contatore2	  ; letzte 15 Frames?
	beq.s	Rulla2
	addq.w	#1,ContaNumLoop1
	cmp.w	#30,ContaNumLoop1 ; sind 30 Schleifen zu tun?
	bne.s	VaiARullare		  ; wenn noch nicht ok
	move.w	#15,Contatore2	  ; andernfalls Contatore2=15
	bra.s	VaiARullare
Rulla2:
	subq.w	#1,ContaNumLoop1  ; sub
	cmp.w	#3,ContaNumLoop1  ; sind wir bei 3?
	bne.s	VaiARullare		  ; Wenn noch nicht RiRulla
	clr.w	Contatore2		  ; andernfalls wird es zurückgesetzt contatore2
VaiARullare:
	lea	coltab(PC),a0		; Tabelle mit Farben
	lea	TabBuf(PC),a1
	move.w	(a0)+,d0		; erste Farbe in d0
CopiaColtabLoop:
	move.w	(a0)+,d1		; Nächste Farbe in d1
	cmp.w	#-2,d1			; Ende Tabelle?
	beq.s	FiniTabCol		; Wenn ja, ist die Runde beendet
	move.w	d1,(a1)+		; Wenn nicht, legen Sie diese Farbe in den TabBuf
	bra.s	CopiaColtabLoop

FiniTabCol:
	move.w	d0,(a1)+		; Setze die erste Farbe als letzte ein
	move.w	#-2,(a1)+		; Und setzen Sie das Endezeichen der Tabelle
	lea	coltab(PC),a0		; Farbtabelle
	lea	TabBuf(PC),a1		; Puffer Tab
RicopiaInColTabLoop:
	move.w	(a1)+,d0		; Farbe kopieren von TabBuf
	move.w	d0,(a0)+		; Legen sie es in coltab
	cmp.w	#-2,d0			; Ende?
	bne.s	RicopiaInColTabLoop
SaltaRull:
	lea	BplCon1Tab(PC),a0	; Tab mit Werten für bplcon1
	lea	TabBuf(PC),a1
	move.w	(a0)+,d0		; erster Tabellenwert in d0 gespeichert
RullaLoop:
	move.w	(a0)+,d1		; nächster Tabellenwert nach Bplcon1
	cmp.w	#-2,d1			; Ende Tabelle?
	beq.s	rullFinito		; wenn ja springe voraus
	move.w	d1,(a1)+		; Kopieren von BplCon1Tab nach TabBuf
	bra.s	RullaLoop
rullFinito:
	move.w	d0,(a1)+		; Setzen Sie den ersten Wert als den letzten
	move.w	#-2,(a1)+		; Flag Tabellenende setzen
	lea	BplCon1Tab(PC),a0	; Tab wert bplcon1
	lea	TabBuf(PC),a1		; Puffer
RicopiaCon1:
	move.w	(a1)+,d0		; Kopieren von tabbuf
	move.w	d0,(a0)+		; nach bplcon1tab
	cmp.w	#-2,d0			; sind wir am Ende
	bne.s	RicopiaCon1		; wenn noch nicht, kopiere es!
delayed:
	lea	CopperEffect,a0

; erste Schleife, die der ntsc-Teil ist (erste $ff-Zeilen)

	move.w	#$2007,d0		; Position wait start YY=$22
	move.w	#$4007,d2		; position wait step YY=$22
	moveq	#7-1,d4			; Anzahl der jeweils $20 Schleifen.
							; $20 * 7 = $e0, + $20 initial = $100, dh
							; der gesamte NTSC-Bereich
	lea	FineTabCol(PC),a1
	lea	BplCon1Tab(PC),a2	; Tabellenwert für bplcon1
loop:
	move.w	ContaNumLoop1(PC),d3
main:
	move.w	(a2)+,d5		; nächster Wert bplcon1
	cmp.w	#-2,d5			; Ende Tabelle?
	bne.s	initd			; wenn nicht, weiter
	lea	BplCon1Tab(PC),a2	; andernfalls starten Sie erneut
	move.w	(a2)+,d5		; Wert von bplcon1
initd:
	move.w	-(a1),d1		; Lies die Farbe und gehe zurück
	cmp.w	#-2,d1			; Ende Tabelle?
	bne.s	initc			; Wenn noch nicht, setzen Sie die Farbe & bplcon1
	lea	FineTabCol(PC),a1	; Beginnen Sie andernfalls am Ende der Farbtabelle
	move.w	-(a1),d1		; Lies die Farbe und gehe zurück
initc:
	move.w	d0,(a0)+		; YYXX von der Wartezeit
	move.w	#$fffe,(a0)+	; wait
	move.w	#$0180,(a0)+	; Register color0
	move.w	d1,(a0)+		; Wert color0
	move.w	#$0102,(a0)+	; bplcon1
	move.w	d5,(a0)+		; Wert bplcon1
	add.w	#$0100,d0		; eine Zeile tiefer warten
	dbra	d3,main
second:
	move.w	(a2)+,d5		; Nächstes Bplcon1val
	cmp.w	#-2,d5			; Ende Tabelle?
	bne.s	doned
	lea	BplCon1Tab(PC),a2   ; von vorne anfangen
	move.w	(a2)+,d5		; nächster Wert Bplcon1
doned:
	move.w	(a1)+,d1		; nächste Farbe
	cmp.w	#-2,d1			; Ende Tabelle?
	bne.s	done
	lea	coltab(PC),a1		; von vorne beginnen
	move.w	(a1)+,d1		; nächste Farbe in tab
done:
	move.w	d0,(a0)+		; YYXX von der Wartezeit
	move.w	#$fffe,(a0)+	; wait
	move.w	#$0180,(a0)+	; Register color0
	move.w	d1,(a0)+		; Wert color0
	move.w	#$0102,(a0)+	; Register bplcon1
	move.w	d5,(a0)+		; Wert bplcon1
	add.w	#$0100,d0		; eine Zeile tiefer warten
	cmp.w	d2,d0			; sind wir am Ende des $20-Zeilenblocks?
	bne.s	second
	add.w	#$2000,d2		; bewege das neue Maximum um $20 nach unten.
	dbra	d4,loop
	move.l	#$ffdffffe,(a0)+	; Ende Bereich ntsc

; Zweite Schleife, die den PAL-Bereich unterhalb der $FF-Zeile bildet

	move.w	#$0007,d0	; Ich fange an zu warten, in der Zeile $00 (dh 256)
	move.w	#$2007,d2	; Beende die Zeile $20 (+$ff)
	moveq	#2-1,d4		; Anzahl Schleifen
loop2:
	move.w	ContaNumLoop1(PC),d3
main2:
	move.w	-(a1),d1		; vorherige Farbe
	cmp.w	#-2,d1			; Ende tab?
	bne.s	initc2
	lea	FineTabCol(PC),a1	; Verlassen am Ende der Farbtabelle
	move.w	-(a1),d1		; vorherige Farbe
initc2:
	move.w	d0,(a0)+		; YYXX wait
	move.w	#$fffe,(a0)+	; Wait
	move.w	#$0180,(a0)+	; Register color0
	move.w	d1,(a0)+		; Wert color0
	add.w	#$0100,d0		; eine Zeile tiefer warten
	dbra	d3,main2
second2:
	move.w	(a1)+,d1		; nächste Farbe
	cmp.w	#-2,d1			; Ende tab?
	bne.s	done2
	lea	coltab(PC),a1		; Farbtabelle - von vorne beginnen
	move.w	(a1)+,d1		; nächste Farbe in d1
done2:
	move.w	d0,(a0)+		; Koordinate YYXX wait
	move.w	#$fffe,(a0)+	; zweites Wort des wait
	move.w	#$0180,(a0)+	; Register color0
	move.w	d1,(a0)+		; Wert color0
	add.w	#$0100,d0		; eine Zeile tiefer warte
	cmp.w	d2,d0			; sind wir ganz unten? ($20-$40-$60)
	bne.s	second2			; wenn noch nicht, bleiben
	add.w	#$2000,d2		; Stellen Sie das Maximum 20 niedriger ein
	dbra	d4,loop2
	move.l	(sp)+,a5		; a5 wieder herstellen
	rts

ContaNumLoop1:	dc.w	0
Contatore1:	dc.w	0
Contatore2:	dc.w	0


	dc.w	-2	; Anfang tab
coltab:
	dc.w	$000,$000,$000,$000,$000,$000,$000,$000,$000,$000,$000
	dc.w	$000,$001,$002,$003,$004,$005,$006,$007,$008,$009,$009
	dc.w	$00a,$00a,$00b,$00b,$00b,$01c,$02c,$03c,$04c,$05d,$05d
	dc.w	$06d,$06d,$07d,$07d,$07d,$08d,$08d,$08d,$09d,$09D,$09C
	dc.w	$0aA,$0aA,$0a9,$0a8,$0a7,$0a6,$0a5,$0a4,$0a3,$0b2,$0b1
	dc.w	$0b0,$1b0,$2b0,$3b0,$4b0,$5b0,$6b0,$7b0,$8b0,$9b0,$Ab0
	dc.w	$Bb0,$Cb0,$Db0,$db0,$db0,$db0,$db0,$da0,$da0,$d90,$d90
	dc.w	$d80,$d70,$d60,$d50,$d40,$d30,$d20,$d10,$d00,$d00,$D00
	dc.w	$C00,$B00,$A00,$900,$800,$700,$600,$500,$400,$300,$200
	dc.w	$100,$000,$000
FineTabCol:
	dc.w	-2	; Ende tab

; Wertetabelle für bplcon1. Wie Sie bemerken, verursacht es eine Welle.

	dc.w	-2	; Anfang tab
BplCon1Tab:
	dc.w	$11,$11,$11,$22,$22,$33,$44,$55,$55,$66,$66,$66,$077,$077
	dc.w	$77,$77,$77,$77,$66,$66,$66,$55,$55,$44,$33,$33,$022,$022
	dc.w	$22,$11,$11,$11,$11,$00,$00,$00,$00,$00,$00,$11,$011,$011
	dc.w	$11,$11,$22,$22,$22,$22,$33,$33,$44,$44,$55,$55,$055,$055
	dc.w	$66,$66,$66,$66,$66,$66,$77,$77,$77,$77,$77,$77,$077,$077
	dc.w	$77,$77,$66,$66,$66,$66,$66,$66,$55,$55,$55,$55,$044,$044
	dc.w	$33,$33,$33,$33,$22,$22,$22,$22,$22,$22,$11,$11,$011,$011
	dc.w	-2	; fine tab

; In diesen Puffer werden die gedrehten Tabellen kopiert, die dann in die
; Tabellen selbst kopiert werden... eine seltsame Art zu scrollen, oder?

TabBuf:
	ds.w	128

*****************************************************************************
;			Druck-Routine
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
	SUB.B	#$20,D2		; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG
						; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
						; (Das $20 entspricht), IN $00, DAS
						; AUSRUFUNGSZEICHEN ($21) IN $01...
	LSL.W	#3,D2		; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
						; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2	; FINDE DEN GEWÜNSCHTEN BUCHSTABEN IM FONT...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adresse Ziel-Bitplane in a3

				; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)	; Drucke Zeile 1 des Zeichens
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile  2  " "
	MOVE.B	(A2)+,40*2(A3)	; Drucke Zeile  3  " "
	MOVE.B	(A2)+,40*3(A3)	; Drucke Zeile  4  " "
	MOVE.B	(A2)+,40*4(A3)	; Drucke Zeile  5  " "
	MOVE.B	(A2)+,40*5(A3)	; Drucke Zeile  6  " "
	MOVE.B	(A2)+,40*6(A3)	; Drucke Zeile  7  " "
	MOVE.B	(A2)+,40*7(A3)	; Drucke Zeile  8  " "

	ADDQ.L	#1,PuntaBitplane ; wir rücken 8 Bits vor (NÄCHSTES ZEICHEN)
	ADDQ.L	#1,PuntaTesto	 ; nächstes zu druckendes Zeichen

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
	dc.b	'                                        ',0 ; 1
	dc.b	'    Questo listato cambia ad ogni       ',0 ; 2
	dc.b	'                                        ',0 ; 3
	dc.b	'    linea sia il color1 ($dff184),      ',0 ; 4
	dc.b	'                                        ',0 ; 5
	dc.b	'    che il bplcon1 ($dff102). Notate    ',0 ; 6
	dc.b	'                                        ',0 ; 7
	dc.b	'    come si possano "unire" listati     ',0 ; 8
	dc.b	'                                        ',0 ; 9
	dc.b	'    visti in precedenza in un solo      ',0 ; 10
	dc.b	'                                        ',0 ; 11
	dc.b	'    effetto. Si potrebbero cambiare     ',0 ; 12
	dc.b	'                                        ',0 ; 13
	dc.b	'    anche altri colori e i moduli per   ',0 ; 14
	dc.b	'                                        ',0 ; 15
	dc.b	'    ogni linea, se avete voglia         ',0 ; 16
	dc.b	'                                        ',0 ; 17
	dc.b	'    provate!                            ',$FF ; 18

	EVEN

; Die FONT-Zeichen 8x8 (in CHIP von der CPU und nicht vom Blitter kopiert,
; so kann es auch im FAST RAM sein. In der Tat wäre es besser!

FONT:
	incbin	"assembler2:sorgenti4/nice.fnt"

*****************************************************************************

	section	graficozza,data_C

COPPERLIST:
	dc.w	$8e,DIWS	; DiwStrt	($2C81)
	dc.w	$90,DIWSt	; DiwStop	($2CC1)
	dc.w	$92,DDFS	; DdfStart	($38)
	dc.w	$94,DDFSt	; DdfStop	($D0)
	dc.w	$100,BPLC0	; BplCon0	($1200)
	dc.w	$180,$000	; color0 schwarz
	dc.w	$182,$eee	; color1 weiß
BPLPOINTER:
	dc.w	$E0,$0000	; Bpl0h
	dc.w	$E2,$0000	; Bpl0l
	dc.w	$102,$0		; Bplcon1
	dc.w	$104,$0		; Bplcon2
	dc.w	$108,$0		; Bpl1mod
	dc.w	$10a,$0		; Bpl2mod

CopperEffect:
	dcb.l	801,0		; Platz für den Effekt (Achtung! bei
						; Änderungen kann der Effekt
						; größer oder kleiner werden)
	dc.w	$ffff,$fffe	; Ende copperlist

*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256	; eine bitplane lowres 320x256

	end

Möglicherweise haben Sie bemerkt, dass Verwicklungen und viele seltsame 
Schleifen durch Zählern in den Routinen reguliert werden. 
Dies wird verwendet um diesen Farbeffekt zu erzeugen.
Es ist ein einfacher Bildlauf nach oben oder unten, aber "das Durcheinander"
wird durch verschiedene Passagen erzeugt.

