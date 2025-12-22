
;  Lezione11l3a.s - Bewegen Sie ein Bild nach oben / unten - rechts / links

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
			; Multiplizieren von Bytes mit 8: normaler Bildschirm 320/8 = 40
			; z.B. für einen 336 Pixel breiten Bildschirm 336/8 = 42
			; Beispielbreiten:
			; 264 pixel = 33 / 272 pixel = 34 / 280 pixel = 35
			; 360 pixel = 45 / 368 pixel = 46 / 376 pixel = 47
			; ... 640 pixel = 80 / 648 pixel = 81 ...

scr_h		= 256	; Bildschirmhöhe in Zeilen
scr_x		= $81	; Startbildschirm, XX-Position (normal $xx81) (129)
scr_y		= $2c	; Startbildschirm, YY-Position (normal $2cxx) (44)
scr_res		= 1	; 2 = HighRes (640*xxx) / 1 = LowRes (320*xxx)
scr_lace	= 0	; 0 = non interlace (xxx*256) / 1 = interlace (xxx*512)
ham			= 1	; 0 = nicht ham / 1 = ham
scr_bpl		= 6	; Anzahl Bitplanes

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
	MOVE.L	#LOGO+40*40,d0	; Logo-Adresse (etwas abgesenkt)
	MOVEQ	#6-1,D7			; 6 bitplanes HAM.
pointloop:
	MOVE.W	D0,6(A0)
	SWAP	D0
	MOVE.W	D0,2(A0)
	SWAP	D0
	ADDQ.w	#8,A0
	ADD.L	#176*40,D0		; Länge plane
	DBRA	D7,pointloop

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
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

	bsr.w	sugiu		; bewege dich runter und rauf
	bsr.w	lefrig		; bewege dich nach rechts und links

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts					; exit


*****************************************************************************
;	ROUTINE DES BILDES (Punkte weiter oder weiter zurück)
;	die bplpointers, nichts außergewöhnliches
*****************************************************************************

;	  _________________
;	  \               /
;	   \_____________/_
;	    | \___________/
;	    |__  ..  _:
;	    | \_____/ :
;	  __`---------'__
;	./               \.
;	|  _           _  |
;	|  |           |  |

SuGiuFlag:
	DC.W	0

SUGIU:
	LEA	BPLPOINTERS,A1	; nimm die Adresse der bitplanes, auf die gerade 
	move.w	2(a1),d0	; gezeigt wird und packe es in d0
	swap	d0
	move.w	6(a1),d0

	BTST.b	#1,SuGiuFlag		; soll ich rauf oder runter gehen
	BEQ.S	GIUT

; NACH OBEN

SUT:
	MOVE.L	SUGIUTABP(PC),A0	; Tabelle mit Vielfachen von 40 (des Modulos)
	SUBQ.L	#2,SUGIUTABP		; Ich nehme den Wert "vor"
	CMPA.L	#SUGIUTAB+4,A0
	BNE.S	NOBSTART
	BCHG.B	#1,SuGiuFlag		; Wenn fertig, ändere die Richtung (gehe runter)
	ADDQ.L	#2,SUGIUTABP		; ausgleichen
NOBSTART:
	BRA.s	NOBEND

; NACH UNTEN

GIUT:
	MOVE.L	SUGIUTABP(PC),A0	; Tabelle mit Vielfachen von 40
	ADDQ.L	#2,SUGIUTABP		; Ich nehme den Wert "nach"
	CMPA.L	#SUGIUTABEND-4,A0
	BNE.S	NOBEND
	BCHG.B	#1,SuGiuFlag		; Wenn ich fertig bin, ändere die Richtung
NOBEND:
	moveq	#0,d1
	MOVE.w	(A0),D1				; Tabellenwert in d1
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
	add.l	#176*40,d0			; Länge von einer bitplane
	addq.w	#8,a1
	dbra	d1,APOINTB			; Wiederholen Sie D1-mal (D1=Anzahl der bitplanes)
NOMOVE:
	rts

SUGIUTABP:
	dc.l	SuGiuTab

; Tabelle mit der Anzahl der zu überspringenden Bytes ... natürlich sind sie ein Vielfaches von 40,
; Das ist die Länge einer Zeile.

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
;	ROUTINE Ziel LOGO LINKSSEITIG (benutze das bplcon1, nichts besonderes)
*****************************************************************************

;	    ____
;	____/____\_____
;	_)_  _  ______/
;	\_(·)(·)(¥__\%
;	 \(___ ¯    //
;	  \V V\_____/ st!
;	   ¯¯¯¯¯¯¯¯

DestSinFlag:
	DC.W	0

LefRig:
	BTST.b	#1,DestSinFlag	; soll ich nach rechts oder links gehen
	BEQ.S	ScrolDestra
ScrolSinitra:
	MOVE.L	LefRigTABP(PC),A0	; Tabelle mit Werten für bplcon1
	SUBQ.L	#2,LefRigTABP		; gehe nach links
	CMPA.L	#LefRigTAB+4,A0		; Ende Tabelle?
	BNE.S	NOBSTART2			; Wenn noch nicht, fahren Sie fort
	BCHG.B	#1,DestSinFlag		; Andernfalls ändern Sie die Richtung
	ADDQ.L	#2,LefRigTABP		; ausgleichen
NOBSTART2:
	BRA.s	NOBEND2

ScrolDestra:
	MOVE.L	LefRigTABP(PC),A0	; Tabelle mit Werten für bplcon1
	ADDQ.L	#2,LefRigTABP		; gehe nach rechts
	CMPA.L	#LefRigEND-4,A0		; Ende Tabelle?
	BNE.S	NOBEND2				; Wenn noch nicht, fahren Sie fort
	BCHG.B	#1,DestSinFlag		; Andernfalls ändern Sie die Richtung
NOBEND2:
	MOVE.w	(A0),CON1			; setze den Wert in den bplcon1 in den
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
	dc.w	$8e,DIWS	; DiwStrt
	dc.w	$90,DIWSt	; DiwStop
	dc.w	$92,DDFS	; DdfStart
	dc.w	$94,DDFSt	; DdfStop

	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste bitplane
	dc.w $e4,0,$e6,0	; zweite   "
	dc.w $e8,0,$ea,0	; dritte   "
	dc.w $ec,0,$ee,0	; vierte   "
	dc.w $f0,0,$f2,0	; fünfte   "
	dc.w $f4,0,$f6,0	; sechste  "

	dc.w	$180,0	; Color0 schwarz


	dc.w	$100,BPLC0	; BplCon0 - 320*256 HAM


	dc.w $180,$0000,$182,$134,$184,$531,$186,$443
	dc.w $188,$0455,$18a,$664,$18c,$466,$18e,$973
	dc.w $190,$0677,$192,$886,$194,$898,$196,$a96
	dc.w $198,$0ca6,$19a,$9a9,$19c,$bb9,$19e,$dc9
	dc.w $1a0,$0666

	dc.w	$102	; bplcon1
CON1:
	dc.w	0

	dc.w	$9707,$FFFE	; wait Zeile $97
	dc.w	$100,$200	; no bitplanes
	dc.w	$180,$110	; color0
	dc.w	$9807,$FFFE	; wait
	dc.w	$180,$120	; color0
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

	dc.w	$FFFF,$FFFE	; Ende copperlist


	SECTION	LOGO,CODE_C

LOGO:
	incbin	"amiet.raw"	; 6 bitplanes * 176 lines * 40 bytes (HAM)

	END

