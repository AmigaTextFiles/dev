
;  Listing11l3c.s - Wir schwenken ein Bild mit einer "Live" -Bewegung.

	SECTION	coplanes,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

NumLinee	EQU	53				; Anzahl der Zeilen, die der Effekt enthalten soll.

scr_bytes	= 40				; Anzahl der Bytes für jede horizontale Linie.
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
ham			= 1					; 0 = nicht ham / 1 = ham
scr_bpl		= 6					; Anzahl Bitplanes

; Parameter automatisch berechnet

scr_w		= scr_bytes*8		; Bildschirmbreite
scr_size	= scr_bytes*scr_h	; Größe des Bildschirms in Bytes
BPLC0	= ((scr_res&2)<<14)+(scr_bpl<<12)+$200+(scr_lace<<2)+(ham<<11)
DIWS	= (scr_y<<8)+scr_x
DIWSt	= ((scr_y+scr_h/(scr_lace+1))&255)<<8+(scr_x+scr_w/scr_res)&255
DDFS	= (scr_x-(16/scr_res+1))/2
DDFSt	= DDFS+(8/scr_res)*(scr_bytes/2-scr_res)


START:

; ZEIGER BITPLANEs

	LEA	bplpointers,A0
	MOVE.L	#LOGO+40*40,d0		; Adresse Logo (ein wenig gesenkt)
	MOVEQ	#6-1,D7				; 6 bitplanes HAM.
pointloop:
	MOVE.W	D0,6(A0)
	SWAP	D0
	MOVE.W	D0,2(A0)
	SWAP	D0
	ADDQ.w	#8,A0
	ADD.L	#176*40,D0			; Länge plane
	DBRA	D7,pointloop

	bsr.s	PreparaCopEff		; vorbereiten copper effekt

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2			; warte auf Zeile $110
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $110
	BNE.S	Waity1

	BSR.W	LOGOEFF2			; "dehne" das Bild mit den Modulos
	bsr.w	sugiu				; bewege dich runter und rauf
	bsr.w	lefrig				; bewege dich nach rechts und links

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$11000,d2			; warte auf Zeile $110
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $110
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts							; exit


*****************************************************************************
;		ROUTINE DIE DEN COPPEREFFEKT ERSTELLT	    *
*****************************************************************************

;	_____________
;	\         __/____
;	 \______________/
;	  |_''__``_|
;	__(___)(___)__
;	\__  (__)  __/
;	  /  ____  \
;	  \ (____) /
;	   \______/ g®m

PreparaCopEff:

; copperlist erstellen

	LEA	coppyeff1,A0			; Adresse, in der der Copperlist Effekt erstellt werden soll 
	MOVE.L	#$1080000,D0		; bpl1mod
	MOVE.L	#$10A0000,D1		; bpl2mod
	MOVE.L	#$2E07FFFE,D2		; wait (von der Zeile $2e beginnen)
	MOVE.L	#$01000000,D3		; Wert, der jedes Mal zur Wartezeit hinzugefügt werden soll
	MOVEQ	#(NumLinee*2)-1,D7	; 53 Zeilen zu erstellen
makecop1:
	MOVE.L	D2,(A0)+			; Setzen Sie das WAIT
	MOVE.L	D0,(A0)+			; Setzen Sie das bpl1mod
	MOVE.L	D1,(A0)+			; Setzen Sie das bpl2mod
	ADD.L	D3,D2				; Warten Sie eine Zeile tiefer als die Wartezeit
	DBRA	D7,makecop1

; Multiplizieren Sie die Werte in der Tabelle mit der Formel,
; wird als Wert zum Einfügen von BPL1MOD und BPL2MOD verwendet.

	LEA	tabby2,A0				; Adresse Tabelle
	MOVE.W	#200-1,D7			; Anzahl der in der Tabelle enthaltenen Werte
tab2mul:
	MOVE.W	(A0),D0				; Nimm den Wert aus der Tabelle
	MULU.W	#40,D0				; Multipliziere es mit der Länge. 1 Zeile (mod.)
	MOVE.W	D0,(A0)+			; den multiplizierten Wert zurückgeben und weiterschalten
	DBRA	D7,tab2mul
	rts


; Tabelle mit 200 .word-Werten, die mit 40 multipliziert werden 

tabby2:
	dc.w	0,1,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0
	dc.w	0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,-1,0,0,0,0,0,0,-1,0,0,0
	dc.w	0,0,-1,0,0,0,-1,0,0,0,-1,0,0,0,-1,0,0
	dc.w	-1,0,0,-1,0,0,0,-1,0,0,-1,0,0,-1,0
	dc.w	0,-1,0,0,0,-1,0,0,-1,0,0,-1,0,0,0
	dc.w	-1,0,0,0,-1,0,0,0,-1,0,0,0,0,0,-1,0,0
	dc.w	0,0,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0
	dc.w	0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,1,0
tab2end:

*****************************************************************************
;			ROUTINE COPPER EFFEKT DES LOGOS				    *
*****************************************************************************

;	         _
;	     .--' `-.
;	     |.  _  |
;	     |___/  |
;	     `------'
;	    ./  _  \.
;	 _  |   | | |
;	| |_|___| |_|
;	|     | |_||
;	|_____| (_)|
;	      |    |
;	     (_____|g®m
;

; Der copperlisteneffekt ist so strukturiert:
;
;	DC.W	$2e07,$FFFE			; wait
;	dc.w	$108				; Register bpl1mod
;COPPEREFFY:
;	DC.w	xxx					; Wert bpl1mod
;	dc.w	$10A,xxx			; Register und Wert bpl1mod
;	wait... eccetera.

LOGOEFF2:
	LEA	coppyeff1+6,A0			; Adresse copper effect bpl1mod
	LEA	TABBY2POINTER(PC),A4	; Adresszeiger auf die Tabelle
	LEA	tab2end(PC),A3			; Adresse Ende Tabelle
	MOVE.L	TABBY2POINTER(PC),A1	; Wo wir uns aktuell in der Tabelle befinden
	MOVEQ	#10,D0
	MOVEQ	#(NumLinee*2)-1,D7	; Anzahl der Zeilen für den Effekt
LOGOEFFLOOP:
	MOVE.W	(A1),(A0)+			; Kopieren Sie den Wert bpl1mod von der Tabelle auf den Cop
	MOVE.W	(A1)+,2(A0)			;  "		 "			bpl2mod		"			"
	ADDA.L	D0,A0				; Gehe zum nächsten $dff108 (bpl1mod) in der Coplist
	CMPA.L	A3,A1				; War es der letzte Wert der Tabelle?
	BNE.S	norestart			; Wenn noch nicht, geh nicht
	LEA	tabby2(PC),A1			; Ansonsten wieder gehen!
norestart:
	DBRA	D7,LOGOEFFLOOP
	ADDQ.L	#4,(A4)				; Überspringen Sie 2 Werte in der Coplist (wenn Sie #2 setzen
								; "verlangsamt" es den Effekt, indem er alle zum Lesen bringt
								; die 200 Werte der Tabelle).
	CMPA.L	(A4),A3				; Ende Tabelle?
	BNE.S	NOTABENDY			; Wenn noch nicht, ok
	MOVE.L	#tabby2,(A4)		; Andernfalls starten Sie erneut
NOTABENDY:
	RTS

; Zeiger auf die Tabelle zum Lesen der Werte

TABBY2POINTER:
	dc.l	tabby2

*****************************************************************************
;	ROUTINE DES LOGOS HOCH RUNTER (lässt Sie vorwärts oder rückwärts zeigen
;   die bplpointers, nichts außergewöhnliches)
*****************************************************************************

SuGiuFlag:
	DC.W	0

SUGIU:
	LEA	BPLPOINTERS,A1			; nimm die Adresse, auf die gerade gezeigt wird
	move.w	2(a1),d0			; bitplanes und lege es in d0
	swap	d0
	move.w	6(a1),d0

	BTST.b	#1,SuGiuFlag		; soll ich rauf oder runter gehen
	BEQ.S	GIUT

; Ich gehe nach oben

SUT:
	MOVE.L	SUGIUTABP(PC),A0	; Tabelle mit Vielfachen von 40 (des Modulos)
	SUBQ.L	#2,SUGIUTABP		; Ich nehme den Wert "vor"
	CMPA.L	#SUGIUTAB+4,A0
	BNE.S	NOBSTART
	BCHG.B	#1,SuGiuFlag		; Wenn ich fertig bin, ändere die Richtung (gehe runter)
	ADDQ.L	#2,SUGIUTABP		; ausgleichen
NOBSTART:
	BRA.s	NOBEND

; Ich gehe runter

GIUT:
	MOVE.L	SUGIUTABP(PC),A0	; Tabelle mit Vielfachen von 40
	ADDQ.L	#2,SUGIUTABP		; Ich nehme den Wert "nach"
	CMPA.L	#SUGIUTABEND-4,A0
	BNE.S	NOBEND
	BCHG.B	#1,SuGiuFlag		; Wenn ich fertig bin, ändere die Richtung
NOBEND:
	moveq	#0,d1
	MOVE.w	(A0),D1				; Werte aus der Tabelle in d1
	BTST.b	#1,SuGiuFlag
	BEQ.S	GIU
SU:
	add.l	d1,d0				; Wenn ich nach oben gehe, werde ich es hinzufügen
	BRA.S	MOVLOG
GIU:
	sub.l	d1,d0				; wenn ich nach unten gehe, subtrahiere ich es
MOVLOG:
	LEA	BPLPOINTERS,A1			; und an die neue Adresse gebracht
	MOVEQ	#6-1,D1				; Anzahl der bitplanes -1 (ham 6 bitplanes)
APOINTB:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	add.l	#176*40,d0			; Länge einer Bitplane
	addq.w	#8,a1
	dbra	d1,APOINTB			; Wiederholen Sie D1-mal (D1=Anzahl bitplanes)
NOMOVE:
	rts

SUGIUTABP:
	dc.l	SuGiuTab

; Tabelle mit der Anzahl der zu überspringenden Bytes ... natürlich sind sie ein 
; Vielfaches von 40. Das ist die Länge einer Zeile.

SuGiuTab:
	dc.w	0*40,0*40,0*40,1*40,0*40,0*40,1*40,0*40,1*40
	dc.w	0*40,0*40,1*40,0*40,1*40,0*40,1*40,1*40,0*40
	dc.w	0*40,0*40,1*40,0*40,1*40,0*40,1*40,0*40,0*40
	dc.w	0*40,1*40,1*40,0*40,1*40,0*40,1*40,1*40,1*40
	dc.w	1*40,0*40,1*40,1*40,1*40,1*40,0*40
	dc.w	1*40,0*40,1*40,0*40,1*40,0*40,0*40,1*40,0*40
	dc.w	0*40,1*40,0*40,1*40,0*40,0*40,1*40,0*40,0*40
SuGiuTabEnd:

*****************************************************************************
;	ROUTINE ZIEL DES LOGOS (benutze das bplcon1, nichts besonderes)
*****************************************************************************

DestSinFlag:
	DC.W	0

LefRig:
	BTST.b	#1,DestSinFlag		; soll ich nach rechts oder links gehen
	BEQ.S	ScrolDestra
ScrolSinitra:
	MOVE.L	LefRigTABP(PC),A0	; Tabelle mit Werten für bplcon1
	SUBQ.L	#2,LefRigTABP		; Ich gehe nach links
	CMPA.L	#LefRigTAB+4,A0		; Ende tabella?
	BNE.S	NOBSTART2			; Wenn noch nicht, fahren Sie fort
	BCHG.B	#1,DestSinFlag		; Andernfalls ändern Sie die Richtung
	ADDQ.L	#2,LefRigTABP		; ausgleichen
NOBSTART2:
	BRA.s	NOBEND2

ScrolDestra:
	MOVE.L	LefRigTABP(PC),A0	; Tabelle mit Werten für bplcon1
	ADDQ.L	#2,LefRigTABP		; Ich gehe nach rechts
	CMPA.L	#LefRigEND-4,A0		; Ende Tabelle?
	BNE.S	NOBEND2				; Wenn noch nicht, fahren Sie fort
	BCHG.B	#1,DestSinFlag		; Andernfalls ändern Sie die Richtung
NOBEND2:
	MOVE.w	(A0),CON1			; setze den Wert in den bplcon1 in der
NOMOVE2:						; Copperlist
	rts

LefRigTABP:
	dc.l	LefRigTab

; Dies sind Werte, die für bplcon1 ($dff102) zum Scrollen nach rechts / links geeignet sind.

LefRigTab:
	dc.w	0,0,0,0,0,0,0,$11,$11,$11,$11,$11
	dc.w	$22,$22,$22,$22,$22
	dc.w	$33,$33,$33
	dc.w	$44,$44
	dc.w	$55,$55,$55
	dc.w	$66,$66,$66,$66,$66
	dc.w	$77,$77,$77,$77,$77,$77,$77
	dc.w	$88,$88,$88,$88,$88,$88,$88,$88
	dc.w	$99,$99,$99,$99,$99,$99
	dc.w	$aa,$aa,$aa,$aa,$aa
	dc.w	$bb,$bb,$bb,$bb
	dc.w	$cc,$cc,$cc,$cc
	dc.w	$dd,$dd,$dd,$dd,$dd
	dc.w	$ee,$ee,$ee,$ee,$ee,$ee
	dc.w	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
LefRigEnd:

******************************************************************************
;		COPPERLIST:
******************************************************************************

	Section	MioCoppero,data_C	

COPPERLIST:
	dc.w	$8e,DIWS			; DiwStrt
	dc.w	$90,DIWSt			; DiwStop
	dc.w	$92,DDFS			; DdfStart
	dc.w	$94,DDFSt			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste     bitplane
	dc.w	$e4,0,$e6,0			; zweite	   "
	dc.w	$e8,0,$ea,0			; dritte       "
	dc.w	$ec,0,$ee,0			; vierte       "
	dc.w	$f0,0,$f2,0			; fünfte       "
	dc.w	$f4,0,$f6,0			; sechste      "

	dc.w	$180,0				; Color0 schwarz

	dc.w	$100,BPLC0			; BplCon0 - 320*256 HAM

	dc.w	$180,$0000,$182,$134,$184,$531,$186,$443
	dc.w	$188,$0455,$18a,$664,$18c,$466,$18e,$973
	dc.w	$190,$0677,$192,$886,$194,$898,$196,$a96
	dc.w	$198,$0ca6,$19a,$9a9,$19c,$bb9,$19e,$dc9
	dc.w	$1a0,$0666

	dc.w	$102				; bplcon1
CON1:
	dc.w	0

coppyeff1:
	dcb.w	12*NumLinee

	dc.w	$9707,$FFFE			; wait Zeile $97
	dc.w	$100,$200			; no bitplanes
	dc.w	$180,$110			; color0
	dc.w	$9807,$FFFE			; wait
	dc.w	$180,$120			; color0
	dc.w	$9a07,$FFFE
	dc.w	$180,$130
	dc.w	$9b07,$FFFE
	dc.w	$180,$240
	dc.w	$9c07,$FFFE
	dc.w	$180,$250
	dc.w	$9d07,$FFFE
	dc.w	$180,$370
	dc.w	$9e07,$FFFE
	dc.w	$180,$390
	dc.w	$9f07,$FFFE
	dc.w	$180,$4b0
	dc.w	$a007,$FFFE
	dc.w	$180,$5d0
	dc.w	$a107,$FFFE
	dc.w	$180,$4a0
	dc.w	$a207,$FFFE
	dc.w	$180,$380
	dc.w	$a307,$FFFE
	dc.w	$180,$360
	dc.w	$a407,$FFFE
	dc.w	$180,$240
	dc.w	$a507,$FFFE
	dc.w	$180,$120
	dc.w	$a607,$FFFE
	dc.w	$180,$110
	DC.W	$A70F,$FFFE
	DC.W	$180,$000

	dc.w	$FFFF,$FFFE			; Ende copperlist


	SECTION	LOGO,CODE_C

LOGO:
	incbin "/Sources/amiet.raw"		; 6 bitplanes * 176 lines * 40 bytes (HAM)

	END

Dies ist eine Fusion von Listing11l3a.s und Listing11l3b.s, die zum "bekannten"
Effekt des Logos im Intro der Disk 1 führen.
Wie Sie sehen, ist es ganz einfach, obwohl Sie sich wahrscheinlich Gedanken über 
wer was weiß was für Routinen machen.
Beachten Sie, dass das SuGiuTab aus einem Vielfachen von 40 aus der Tabelle 
"tabby2" bestehen muss: 
Während tabby2 Werte wie 0, 1, -1 hat, die dann mit einer Routine mit 40 multipliziert 
werden, zeigt SuGiuTab die bereits multiplizierten Werte für 40, in der
Form 1 * 40, 2 * 40 usw. an.  Sie könnten auch in diesen Fall nur die nicht
multiplizierten Werte setzen und sie mit der Länge einer Zeile multiplizieren,
dh das Modulo durch eine Routine berechnen. Auf diese Weise könnten Sie leicht
ein EQU definieren:

LunghLinea	EQU	40

Wenn Sie zum Beispiel eine Figur in hires schwingen möchten, reicht es aus
das EQU auf 80 zu ändern, und die Werte in den Tabellen wären richtig
multipliziert.