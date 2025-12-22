
; Lezione11l5b.s   - "Zoom" Animation, die nur 40*29 pixel misst.
;		     Die endgültige Auflösung beträgt 320 * 232, also das Achtfache.
;		     VERSION DURCH TABELLE OPTIMIERT!

	Section ZoomaPer8,code

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern interrupt, dma etc.
*****************************************************************************

; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

		;5432109876543210
DMASET	EQU	%1000001110000000	;copper,bitplane DMA aktivieren

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

scr_bytes	= 40	; Anzahl der Bytes für jede horizontale Linie.
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
ham			= 0	; 0 = nicht ham / 1 = ham
scr_bpl		= 3	; Anzahl Bitplanes

; Parameter automatisch berechnet

scr_w		= scr_bytes*8		; Bildschirmbreite
scr_size	= scr_bytes*scr_h	; Größe des Bildschirms in Bytes 
BPLC0	= ((scr_res&2)<<14)+(scr_bpl<<12)+$200+(scr_lace<<2)+(ham<<11)
DIWS	= (scr_y<<8)+scr_x
DIWSt	= ((scr_y+scr_h/(scr_lace+1))&255)<<8+(scr_x+scr_w/scr_res)&255
DDFS	= (scr_x-(16/scr_res+1))/2
DDFSt	= DDFS+(8/scr_res)*(scr_bytes/2-scr_res)


START:
	move.l	#planexpand,d0	; Bitplanepuffer
	LEA	BPLPOINTERS,A0
	MOVE.W	#3-1,D7			; Anzahl planes
PointAnim:
	MOVE.W	D0,6(A0)
	SWAP	D0
	MOVE.W	D0,2(A0)
	ADDQ.W	#8,A0
	SWAP	D0
	ADDI.L	#40*29,D0		; Länge der Bitplane von 1 Frame
	DBRA	D7,PointAnim

	bsr.w	PrecalcoTabba	; Tabelle Turbo mit vorkalibrierten "erweiterten" Bytes erstellen.

	bsr.w	FaiCopallung	; Erstellen der copperliste, die mit den Modulos um * 8 streckt

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPER,$80(a5)		; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$11500,d2	; warte auf Zeile $115
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $115
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $115
	BEQ.S	Waity2

	bsr.w	CambiaFrame	; Erweitern Sie den aktuellen Frame horizontal
						; 8x: Im Grunde wird jedes Bit ein Byte				

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts					; exit

****************************************************************************
; Routine die "ZoomFrame" alle 7 Frames macht, um zu verlangsamen
****************************************************************************

CambiaFrame:
	addq.b	#1,WaitFlag
	cmp.b	#7,WaitFlag	; wurden 7 Frames übergeben? (um langsamer zu werden)
	bne.s	NonOra
	clr.b	WaitFlag
	bsr.w	ZoomaFrame	; wenn ja, "erweitere" den nächsten Frame!
NonOra:
	rts

WaitFlag:
	dc.w	0

****************************************************************************
; "Erweiterung" der Bilder: Jedes Bit wird getestet, und je nachdem, ob letzteres
; gesetzt oder zurückgesetzt ist, wird ein Byte $FF oder $00 eingegeben.
; Dies ist eine OPTIMIERTE-Version, die eine Tabelle verwendet, die die
; Werte "erweitert" für jedes mögliche Byte (eines von 256 Möglichen).
****************************************************************************

;	    .----.
;	___ `-/\-' ____
;	\_ \_/  \_/ __/
;	  \___  ___/
;	   _(_\/_)_
;	   \  `'  /
;	    \``''/
;	    :\  /:
;	    ! \/ !
;	     _|l_

ZoomaFrame:
	move.l	AnimPointer(PC),A0 ; Frame klein aktuell (40*29)
	lea	Planexpand,A1		   ; Puffer Ziel (zu 320*29)
	MOVE.W	#(5*29*3)-1,D7	   ; 5 bytes pro Zeile * 29 Zeilen * 3 bitplanes
Animloop:
	moveq	#0,d0
	move.b	(A0)+,d0	; nächstes byte in d0
	lsl.w	#3,d0		; d0*8 um den Wert in der Tabelle zu finden
						; (d.h. der Offset von seinem Anfang)
	lea	Precalctabba,a2
	lea	0(a2,d0.w),a2	; In a2 die Adresse im 8-Byte-Tab
						; "Erweiterung" der 8 Bits.
	move.l	(a2)+,(a1)+	; 4 bytes erweitert
	move.l	(a2),(a1)+	; 4 bytes erweitert (total 8 bytes!!)

	DBRA	D7,Animloop	; Konvertieren des gesamten Frames

	add.l	#(5*29)*3,AnimPointer	; Zeigen Sie auf den nächsten Frame
	move.l	AnimPointer(PC),A0
	lea	FineAnim(PC),a1
	cmp.l	a0,a1					; War es der letzte Frame?
	bne.s	NonRiparti
	move.l	#cannoanim,AnimPointer	; wenn ja, mit dem ersten beginnen
NonRiparti:
	rts

AnimPointer:
	dc.l	cannoanim

****************************************************************************
; Routine, die die copperliste erstellt, die das Bild um das 8-fache verlängert,
; Modulos wie folgt: warten Sie auf eine Zeile und setzen Sie das Modulo auf 0,
; die nach der Zeile einrastet, dann die Zeile darunter erneut abwartet und das
; Modulo auf -40, so dass die gleiche Zeile pro Zeile unten "repliziert" wird.
; Nach 7 Warte-Zeilen setzte das Modulo für eine Zeile auf 0;
; Klicken Sie auf eine Zeile darunter und setzen Sie das Modulo für weitere 7 
; Zeilen auf -40 zurück um es zu replizieren.
; Das Ergebnis ist, dass jede Zeile 8 Mal wiederholt wird.
****************************************************************************

FaiCopallung:
	lea	AllungaCop,a0		; Puffer in copperlist
	move.l	#$3407fffe,d0	; wait start
	move.l	#$1080000,d1	; bpl1mod 0
	move.l	#$10a0000,d2	; bpl2mod 0
	move.l	#$108FFD8,d3	; bpl1mod -40
	move.l	#$10aFFD8,d4	; bpl1mod -40
	moveq	#28-1,d7		; Anzahl loops
FaiCoppa:
	move.l	d0,(a0)+		; wait1
	move.l	d1,(a0)+		; bpl1mod = 0
	move.l	d2,(a0)+		; bpl2mod = 0
	add.l	#$01000000,d0	; springe 1 Zeile
	move.l	d0,(a0)+		; wait2
	move.l	d3,(a0)+		; bpl1mod = -40
	move.l	d4,(a0)+		; bpl2mod = -40
	add.l	#$07000000,d0	; springe 7 Zeilen
	cmp.l	#$0407fffe,d0	; sind wir unten $ff?
	bne.s	NonPAl
	move.l	#$ffdffffe,(a0)+ ; Zugang zum Bereich PAL
NonPal:
	dbra	d7,FaiCoppa
	move.l	d0,(a0)+		; wait Ende
	rts

****************************************************************************
; Routine, die alle möglichen 8 Bytes in Kombination mit möglichen
; 8-Bit vorberechnet. Für alle $FF bedeutet es, das heißt, 255.
****************************************************************************

PrecalcoTabba:
	lea	Precalctabba,a1	; Ziel
	moveq	#0,d0		; Teile von Null
FaiTabba:
	MOVEQ	#8-1,D1		; 8 bit die sie steuern und erweitern möchten.
BYTELOOP:
	BTST.l	D1,d0		; Testen des aktuellen Schleifenbits
	BEQ.S	bitclear	; ist es zurückgesetzt?
	ST.B	(A1)+		; wenn nein, legt das Byte fest (=$FF)
	BRA.S	bitset
bitclear:
	clr.B	(A1)+		; Wenn es Null ist, setzt es das Byte zurück (=$00)
bitset:
	DBRA	D1,BYTELOOP	; Überprüfen und erweitern Sie alle Bits des Bytes:						
						; D1, abnehmend, bewirkt, dass der BTST jedes Mal auf
						; ein anderes Bit zeigt von 7 bis 0.	
	ADDQ.W	#1,D0		; Nächster Wert
	CMP.W	#256,d0		; Haben wir alle gemacht? (max $FF)
	bne.s	FaiTabba
	rts

****************************************************************************
; ANIMATION: 8 Frames Größe 40*29 pixel, mit 8 Farben (3 Bitplanes)
****************************************************************************

; Animation jedes Frame mist 40*29 pixel, 3 bitplanes. Tot. 8 frames

cannoanim:
	incbin	"frame1"	; 40*29 mit 3 bitplanes (8 Farben)
	incbin	"frame2"
	incbin	"frame3"
	incbin	"frame4"
	incbin	"frame5"
	incbin	"frame6"
	incbin	"frame7"
	incbin	"frame8"
FineAnim:

****************************************************************************
;			COPPERLISTE
****************************************************************************

	Section	Copper,DATA_C

COPPER:
	dc.w	$8e,DIWS	; DiwStrt
	dc.w	$90,DIWSt	; DiwStop
	dc.w	$92,DDFS	; DdfStart
	dc.w	$94,DDFSt	; DdfStop

	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste	 bitplane
	dc.w $e4,0,$e6,0	; zweite    "
	dc.w $e8,0,$ea,0	; dritte    "

; 8 Farben

	dc.w	$180,$000,$182,$080,$184,$8c6
	dc.w	$186,$c20,$188,$d50,$18a,$e80,$18c,$0fb0
	dc.w	$18e,$ff0

	dc.w	$2c07,$FFFE	; wait

	dc.w	$100,BPLC0	; bplcon0 - 3 planes

	dc.w	$108,-40	; modulo negativ - Wiederholen Sie die gleiche Zeile!
	dc.w	$10A,-40
AllungaCop:
	ds.b	6*4*28		; 2 wait + 4 move = 6*4 bytes * 21 loops
				; Diese copperliste verlängert, was
				; Verwendung der Module 0 und -40
				; abwechselnd alle 8 Zeilen.
	ds.b	4*2		; Für die $ffdffffe und letzte Wartezeit

	dc.w	$100,$200	; bplcon0 - keine Bitplanes
	dc.w	$FFFF,$FFFE	; Ende copperlist

****************************************************************************
; Puffer mit der Tabelle für den vorkalkulierten Zoom
****************************************************************************

	section	precalcolone,bss

PrecalcTabba:
	ds.b	256*8

****************************************************************************
; Puffer, bei dem pro Frame "erweitert" wird.
****************************************************************************

	SECTION	BitPlanes,BSS_C

PLANEXPAND:				; Wo jeder Frame erweitert wird.
	ds.b	40*29*3		; 40 Bytes * 29 Zeilen * 3 Bitplanes

	end
