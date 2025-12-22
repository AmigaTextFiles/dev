
; soc29f2.s
; zeigt die Animation des Schachbrettmusters
; inkl. Modulo-Loop

; *************** PARAMETER DES SCREENS 0 ***************

;NbPlane0=5
NbPlane0=1	; hier im Test
SizeX0=320
SizeY0=160

PlaneSize0=SizeY0*SizeX0/8			; 160*320/8= 160*40=6400

; *************** KONSTANTEN ***************

BobSizeX=16*16						; 16 Bobs mit je 16 Pixel breite
BobSizeY=8							; und 8 Pixel Höhe

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6					; Execbase
	jsr	-$78(a6)					; Disable
	lea	GfxName(PC),a1				; Libname
	jsr	-$198(a6)					; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop			; speichern die alte COP

	; Bitplanepointer in der Copperlist
	MOVE.L	#BITPLANE,d0			; wohin pointen
	LEA	BPLPOINTERS,A1				; Bitplanepointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	
	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106
	
mainloop:
loop: 
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00010100,d0				; auf Ende des-Rasterdurchlaufs warten
	bne.s loop
	
	bsr chess						; Schachbrettanimation aufrufen
	
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mainloop	

;------------------------
; exit
	move.l	OldCop(PC),$dff080		; Pointen auf die SystemCOP
	move.w	d0,$dff088				; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)					; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)					; Closelibrary
	rts

;	Daten
GfxName:
	dc.b	"graphics.library",0,0
GfxBase:
	dc.l	0
OldCop:
	dc.l	0
	
	rts


chess:
	; ----- Schachbrettanimation -----

	movea.l Screen0_adr,a1		; Anfangsadresse der Bitplane	
	add.w #(NbPlane0-1)*PlaneSize0+(SizeY0/2-8*BobSizeY)*SizeX0/8/2+12,a1	; (5-1)*6400+(160/2-8*8)*320/8/2+12=25600 + 76*32=28032
	lea Check_adr,a2			; Anfangsadresse des 8x8 Feldes mit Werten
	moveq #8-1,d0				; Schleifenzähler 8	Anzahl Reihen	
Check_loopX:
	moveq #8-1,d1				; Schleifenzähler 8	Anzahl Spalten	
Check_loopY:
	move.w (a2),d2				; aktuellen Wert der Tabelle nach d2
	subq.w #2,(a2)+				; -2 vom aktuellen Wert subtrahieren und zum nächsten Wert wechseln
	bge Check_NoLoop			; wenn >=0, dann überspringen
	move.w #15*2,-2(a2)			; ansonsten 30 an die Position des Feldes kopieren, (Startwert)
Check_NoLoop:
	lea Bob_adr,a3				; Anfangsadresse der Bobs
	add.w d2,a3					; den Offset hinzu addieren
	movea.l a1,a6				; Kopie ermittelte Anfangsadresse der Bitplane wo das Muster gezeichnet wird
	rept 8						; 8 Widerholungen
	move.w (a3),(a6)			; erstes Wort der Bobdaten in die Bitplane kopieren
	lea SizeX0/8(a6),a6			; Offset 320/8=40 - 40 Bytes dazu - nächste Zeile
	lea BobSizeX/8(a3),a3		; (16*16)/8=32, nächste Zeile des selben Bobs
	endr
	addq.w #2,a1				; 2 Bytes weiter in der ermittelten Bitplane - für nächstes Bob
	dbf d1,Check_LoopY			; wiederholen 
	lea BobSizeY*SizeX0/8-8*2(a1),a1 ; nächste Anfangsadresse in der Bitplane ermitteln 8*(320/8)-8*2= 304
	dbf d0,Check_LoopX			; wiederholen

	rts


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart	$38 
	dc.w	$94,$d0				; DdfStop   $d0
	dc.w	$100,$1200			; BPLCON0
	dc.w	$102,0				; BPLCON1
	dc.w	$104,0				; BPLCON2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$180,$005			; Color0	; Hintergrund Schwarz
	dc.w	$182,$666			; Color1	; Farbe 1 der Bitplane

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste Bitplane
	
Modulo_Loop:
.pos1    set     $3201
.pos2    set     $3301
	rept    80                  ;  (moveq #SizeY0/2-1,d1   ; 160/2-1 Wait-Positionen)
    dc.w    .pos1,$fffe
	dc.w $0108,$ffd8            ;  BPL1MOD := 0xffd8
	dc.w $010a,$ffd8            ;  BPL2MOD := 0xffd8
	dc.w    .pos2,$fffe
	dc.w $0108,$0000            ;  BPL1MOD := 0x0000
	dc.w $010a,$0000            ;  BPL2MOD := 0x0000
.pos1    set     .pos1+$200
.pos2    set     .pos2+$200
    endr

	dc.w	$ffff,$fffe			; Ende der Copperlist

bitplane:
	blk.b	10240,$00

Screen0_adr:	
	dc.l bitplane				; hierfür wurde zuvor Speicherplatz angefordert

Bob_adr:	incbin "square-half.raw"	; 16 Bobs kleiner werdender Rechtecke

Check_adr:									; Offsetadresse zum nächsten Bob 
	dc.w 0*2,1*2,2*2,3*2,4*2,5*2,6*2,7*2	; max 15*2 - für letztes Bob in der Reihe
	dc.w 1*2,2*2,3*2,4*2,5*2,6*2,7*2,8*2
	dc.w 2*2,3*2,4*2,5*2,6*2,7*2,8*2,7*2
	dc.w 3*2,4*2,5*2,6*2,7*2,8*2,7*2,6*2
	dc.w 4*2,5*2,6*2,7*2,8*2,7*2,6*2,5*2
	dc.w 5*2,6*2,7*2,8*2,7*2,6*2,5*2,4*2
	dc.w 6*2,7*2,8*2,7*2,6*2,5*2,4*2,3*2
	dc.w 7*2,8*2,7*2,6*2,5*2,4*2,3*2,2*2

	end