
;  Listing11l3b.s - Wir strecken ein Bild in vertikaler Richtung "um zu winken".

	SECTION	coplanes,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include "/Sources/startup2.s" ; speichern copperlist etc.
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
	MOVE.L	#LOGO+40*40,d0		; Logo-Adresse (etwas abgesenkt)
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
;		ROUTINE DIE DEN COPPEREFFEKT ERSTELLT		    *
*****************************************************************************

;	 :        __
;	 : .-----'  `-----.
;	_:_|______________|___
;	\                    /
;	 \________/\________/
;	 : |  _        _  |
;	 `-|  \________/  |
;	   |              |
;	   `----,,,,,,----'

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

; Multiplizieren Sie die Werte in der Tabelle mit der Formel
; der Wert wird verwendet, um in BPL1MOD und BPL2MOD einzugeben.

	LEA	tabby2,A0				; Adresse Tabelle
	MOVE.W	#200-1,D7			; Anzahl der in der Tabelle enthaltenen Werte
tab2mul:
	MOVE.W	(A0),D0				; Nimm den Wert aus der Tabelle
	MULU.W	#40,D0				; Multipliziere es mit der Länge. 1 Zeile (mod.)
	MOVE.W	D0,(A0)+			; Den multiplizierten Wert zurückgeben und weiterschalten
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
;			ROUTINE COPPER EFFECT DES BILDES		    *
*****************************************************************************

;	           _
;	       .--' `-.
;	       |     .|      
;	       |  /\__|       
;	       `------'____ __
;	      ./ (_________|__)
;	      |         |_|__)
;	      |         |   __
;	      |_________|  |  |
;	 _____/\_     `----'  |
;	|       (_____________|
;	|   _______/         
;	l__|g®m

; Der copperlisteneffekt ist also so strukturiert:
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
	MOVE.W	(A1),(A0)+			; Kopieren Sie den Wert bpl1mod von der Registerkarte auf den Cop
	MOVE.W	(A1)+,2(A0)			;  "	  "	  bpl2mod	"	"
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

	dc.w $180,$0000,$182,$134,$184,$531,$186,$443
	dc.w $188,$0455,$18a,$664,$18c,$466,$18e,$973
	dc.w $190,$0677,$192,$886,$194,$898,$196,$a96
	dc.w $198,$0ca6,$19a,$9a9,$19c,$bb9,$19e,$dc9
	dc.w $1a0,$0666

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

