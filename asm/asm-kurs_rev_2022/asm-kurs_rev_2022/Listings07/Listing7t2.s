
; Listing7t2.s	Langsame Sterne

;		In diesem Listing machen wir einen Sternenhimmel,
;		der sich jedoch in 1-Pixel-Schritten bewegt

	 SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop


	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Pointen auf die Sprites

	MOVE.L	#SPRITE,d0		; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	bne.s	mouse

	bsr.s	BewegeSterne	; diese Routine bewegt die Sterne

Warte:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; starten die alte COP

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)			; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; Diese einfache Routine läßt den Sprite weitergehen, der die Sterne
; darstellt. Er agiert auf jedes HSTART mit dem STERNEN_LOOP

BewegeSterne:
	lea	Sprite,A0			; a0 pointet auf den Sprite
STERNEN_LOOP:
	CMPI.B	#$f0,1(A0)		; hat der Stern den rechten Rand
							; des Bildschirmes erreicht?
	BNE.S	nicht_Rand		; nicht, dann überspringe
	MOVE.B	#$30,1(A0)		; ja, setze den Stern nach links
nicht_Rand:
	BCHG	#0,3(A0)		; agiere auf das Byte VHBITS
	BEQ.S	Gerade
	ADDQ.B	#$1,1(A0)		; bewege den Sprite um 2 Pixel
Gerade:
	ADDQ.w	#8,A0			; nächster Stern
	CMP.L	#SpriteEnd,A0	; haben wir das Ende erreicht?
	BLO.S	STERNEN_Loop	; wenn nicht, wiederhole den Loop
	RTS						; Ende Routine


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$38			; DdfStart
	dc.w	$94,$d0			; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

	dc.w	$100,%0001001000000000	; Bit 12 an!! 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste	Bitplane

	dc.w	$180,$000		; Color0	; Hintergrund Schwarz
	dc.w	$182,$123		; Color1	; Farbe 1 des Bitplane, die
							; in diesem Fall leer ist,
							; und deswegen nicht erscheint

; der Sprite verwendet nur eine Farbe, COLOR17

	dc.w	$1A2,$ddd		; COLOR17, - COLOR1 des Sprite0 - weiß

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	-	-	-	-	-	-	-

; Wie ihr sehen könnt wurde dieser Sprite ganz schön oft wiederverwendet,
; um genau zu sein 127 Mal. Er besteht aus vielen Word-Kontrollpaaren, die
; von einem $1000,$0000 gefolgt werden, also den Daten, die einen einzelnen
; Stern ergeben. Die vertikalen Positionen gehen in Zweierschritten, es gibt
; also einen Stern alle zwei vertikalen Zeilen, bei einer immer anderen
; horizontalen Position. Die erste Wiederverwertung des Sprite ist
; $307a,$3100,$1000,$0000
; die zweite $3220,$3300,$1000,$0000
; und so weiter. Die verschiedenen VSTART gehen in Schritten zu 2, also $30,
; $32, $34, $36 ...
; Die HSTART sind zufällig positioniert ($7a, $20, $c0, $50,...)
; Die VSTOP befinden sich natürlich eine Zeile nach VSTART ($31, $33, $35,...),
; da die Sterne ja 1 Pixel hoch sind.
; Die Routine agiert bei jedem Fotogramm auf alle HSTART, und verstellt
; somit die Sterne nach vorne.

Sprite:
	dc.w	$307A,$3100,$1000,$0000,$3220,$3300,$1000,$0000
	dc.w	$34C0,$3500,$1000,$0000,$3650,$3700,$1000,$0000
	dc.w	$3842,$3900,$1000,$0000,$3A6D,$3B00,$1000,$0000
	dc.w	$3CA2,$3D00,$1000,$0000,$3E9C,$3F00,$1000,$0000
	dc.w	$40DA,$4100,$1000,$0000,$4243,$4300,$1000,$0000
	dc.w	$445A,$4500,$1000,$0000,$4615,$4700,$1000,$0000
	dc.w	$4845,$4900,$1000,$0000,$4A68,$4B00,$1000,$0000
	dc.w	$4CB8,$4D00,$1000,$0000,$4EB4,$4F00,$1000,$0000
	dc.w	$5082,$5100,$1000,$0000,$5292,$5300,$1000,$0000
	dc.w	$54D0,$5500,$1000,$0000,$56D3,$5700,$1000,$0000
	dc.w	$58F0,$5900,$1000,$0000,$5A6A,$5B00,$1000,$0000
	dc.w	$5CA5,$5D00,$1000,$0000,$5E46,$5F00,$1000,$0000
	dc.w	$606A,$6100,$1000,$0000,$62A0,$6300,$1000,$0000
	dc.w	$64D7,$6500,$1000,$0000,$667C,$6700,$1000,$0000
	dc.w	$68C4,$6900,$1000,$0000,$6AC0,$6B00,$1000,$0000
	dc.w	$6C4A,$6D00,$1000,$0000,$6EDA,$6F00,$1000,$0000
	dc.w	$70D7,$7100,$1000,$0000,$7243,$7300,$1000,$0000
	dc.w	$74A2,$7500,$1000,$0000,$7699,$7700,$1000,$0000
	dc.w	$7872,$7900,$1000,$0000,$7A77,$7B00,$1000,$0000
	dc.w	$7CC2,$7D00,$1000,$0000,$7E56,$7F00,$1000,$0000
	dc.w	$805A,$8100,$1000,$0000,$82CC,$8300,$1000,$0000
	dc.w	$848F,$8500,$1000,$0000,$8688,$8700,$1000,$0000
	dc.w	$88B9,$8900,$1000,$0000,$8AAF,$8B00,$1000,$0000
	dc.w	$8C48,$8D00,$1000,$0000,$8E68,$8F00,$1000,$0000
	dc.w	$90DF,$9100,$1000,$0000,$924F,$9300,$1000,$0000
	dc.w	$9424,$9500,$1000,$0000,$96D7,$9700,$1000,$0000
	dc.w	$9859,$9900,$1000,$0000,$9A4F,$9B00,$1000,$0000
	dc.w	$9C4A,$9D00,$1000,$0000,$9E5C,$9F00,$1000,$0000
	dc.w	$A046,$A100,$1000,$0000,$A2A6,$A300,$1000,$0000
	dc.w	$A423,$A500,$1000,$0000,$A6FA,$A700,$1000,$0000
	dc.w	$A86C,$A900,$1000,$0000,$AA44,$AB00,$1000,$0000
	dc.w	$AC88,$AD00,$1000,$0000,$AE9A,$AF00,$1000,$0000
	dc.w	$B06C,$B100,$1000,$0000,$B2D4,$B300,$1000,$0000
	dc.w	$B42A,$B500,$1000,$0000,$B636,$B700,$1000,$0000
	dc.w	$B875,$B900,$1000,$0000,$BA89,$BB00,$1000,$0000
	dc.w	$BC45,$BD00,$1000,$0000,$BE24,$BF00,$1000,$0000
	dc.w	$C0A3,$C100,$1000,$0000,$C29D,$C300,$1000,$0000	 
	dc.w	$C43F,$C500,$1000,$0000,$C634,$C700,$1000,$0000	 
	dc.w	$C87C,$C900,$1000,$0000,$CA1D,$CB00,$1000,$0000	 
	dc.w	$CC6B,$CD00,$1000,$0000,$CEAC,$CF00,$1000,$0000
	dc.w	$D0CF,$D100,$1000,$0000,$D2FF,$D300,$1000,$0000	 
	dc.w	$D4A5,$D500,$1000,$0000,$D6D6,$D700,$1000,$0000	 
	dc.w	$D8EF,$D900,$1000,$0000,$DAE1,$DB00,$1000,$0000	 
	dc.w	$DCD9,$DD00,$1000,$0000,$DEA6,$DF00,$1000,$0000	 
	dc.w	$E055,$E100,$1000,$0000,$E237,$E300,$1000,$0000	 
	dc.w	$E47D,$E500,$1000,$0000,$E62E,$E700,$1000,$0000
	dc.w	$E8AF,$E900,$1000,$0000,$EA46,$EB00,$1000,$0000
	dc.w	$EC65,$ED00,$1000,$0000,$EE87,$EF00,$1000,$0000
	dc.w	$F0D4,$F100,$1000,$0000,$F2F5,$F300,$1000,$0000
	dc.w	$F4FA,$F500,$1000,$0000,$F62C,$F700,$1000,$0000
	dc.w	$F84D,$F900,$1000,$0000,$FAAC,$FB00,$1000,$0000
	dc.w	$FCB2,$FD00,$1000,$0000,$FE9A,$FF00,$1000,$0000
	dc.w	$009A,$0106,$1000,$0000,$02DF,$0306,$1000,$0000
	dc.w	$0446,$0506,$1000,$0000,$0688,$0706,$1000,$0000
	dc.w	$0899,$0906,$1000,$0000,$0ADD,$0B06,$1000,$0000
	dc.w	$0CEE,$0D06,$1000,$0000,$0EFF,$0F06,$1000,$0000
	dc.w	$10CD,$1106,$1000,$0000,$1267,$1306,$1000,$0000
	dc.w	$1443,$1506,$1000,$0000,$1664,$1706,$1000,$0000
	dc.w	$1823,$1906,$1000,$0000,$1A6D,$1B06,$1000,$0000
	dc.w	$1C4F,$1D06,$1000,$0000,$1E5F,$1F06,$1000,$0000
	dc.w	$2055,$2106,$1000,$0000,$2267,$2306,$1000,$0000
	dc.w	$2445,$2506,$1000,$0000,$2623,$2706,$1000,$0000
	dc.w	$2834,$2906,$1000,$0000,$2AF0,$2B06,$1000,$0000
	dc.w	$2CBC,$2D06,$1000,$0000
SpriteEnd
	dc.w	$0000,$0000		; Endlich ist der wiederverwertete Sprite fertig

	 SECTION LEERESPLANE,BSS_C	; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

In diesem Listing bewegen wir die Sterne jeweils um 1 Pixel. Das  Programm
ist  identisch  mit  dem  vorigem,  nur  erhöhen  wir hier die horizontale
Position um 1 Pixel statt um 2. Das Problem ist nur, daß das niederwertige
der  horizontalen  Koordinate  in einem anderen Byte geschrieben steht als
die restlichen acht, deswegen können wir  den  Sprite  nicht  einfach  mit
einem  ADD verstellen. Eine Möglichkeit wäre, die horizontalen Koordinaten
als Word separat abzuspeichern, also mit allen  Bits  zusammen,  und  dann
immer  1  dazuzählen  und  sie  in  das Byte HSTART und das Bit im vierten
kontrollwort schreiben. Dafür könnten wir dann die selbe Routine verwenden
wie in den letzten Beispielen, UniMoveSprite. Das würde aber bedeuten, daß
wir 127 Word abspeichern müßten, eines für jede horizontale  Position.  In
der Routine haben wir eine bessere Methode verwendet.

	BCHG	#0,3(A0)		; agiere auf das Byte VHBITS
	BEQ.S	Gerade
	ADDQ.B	#$1,1(A0)		; bewege den Sprite um 2 Pixel
Gerade:

sehen wir Schritt für Schritt was getan wird:

	BCHG	#0,3(A0)		; agiere auf das Byte VHBITS

Dieser Befehl arbeitet genau gleich wie  das BSET oder das BCLR.  Nur  daß
das  BSET  ein  Bit  immer  auf  1 setzt, und das BCLR immer auf 0, dieser
hingegen vertauscht seinen Zustand: wenn es auf 1 war wird es 0, und  wenn
es  0  war  wird es 1. In unserem Fall ist das Bit genau das niederwertige
der horizontalen Position. Weiters kontrolliert BCHG VOR  DEM  INVERTIEREN
DAS  BIT,  also  ob es auf 0 war, genau gleich wie ein BTST. Also wird die
Anweisung

	BEQ.S	Gerade

einen Sprung machen, wenn das NIEDERWERTIGE BIT VON HSTART  VOR  DEM  BCHG
AUF 0 WAR.
Die folgende Anweisung verstellt den Sprite um 2 Pixel, wenn die  Position
"ungerade" war:

	ADDQ.B	#$1,1(A0)		; bewege den Sprite um 2 Pixel

Diese drei Befehle lösen unser Problem. Denn es können 2 Fälle auftreten:

Wenn das niederwertige Bit 0 WAR, dann wird das BCHG es auf 1 setzen,  was
einer  Addition  von 1 gleichkommt. Da in diesem Fall das BEQ einen Sprung
vornimmt, wird das Byte HSTART nicht verändert. Wenn wir praktisch gesehen
im  Byte  HSTART=%0110010  hatten  und  das  niederwertige Bit =0 war (was
zusammengesetzt die horizontale Position %01100100=100 ergibt), dann  wird
nach  der  Routine  das HSTART unverändert sein, und das niederwertige Bit
auf 1 sein. Das Byte HSTART  wird  immer  =%0110010  darstellen,  das  Bit
hingegen 1, zusammengesetzt ergibt es die Zahl =%01100101=101. Wie gewollt
wurde die Position um 1 erhöht.

Wenn das niederwertige Bit aber auf 1 WAR, dann bringt es das BCHG auf  0,
was  einer Subtraktion von 1 bei der horizontalen Position gleichkommt. In
diesem Fall aber wird das BEQ KEINEN Sprung vornehmen,  und  deshalb  wird
zum  Byte  HSTART  1  dazugezählt;  und  das entspricht einem Sprung von 2
Pixel. Wenn wir  nun  die  Subtraktion  von  1  und  die  Addition  von  2
zusammennehmen,  dann  ergibt  sich  auch  in diesem Fall ein Sprung von 1
Pixel nach rechts.

Auch hier können wir ein praktisches Beispiel annehmen.  Das  Byte  HSTART
=%0110010  und  das  niederwertige  Bit  =  1 (zusammen  ergibt  sich
%01100101=101). Nach der Routine wird das Bit auf 0 gegangen sein,  HSTART
wurde  jedoch  um  1  erhöht:  %0110011.  Wenn  wir  nun  die beiden Teile
zusammensetzen ergibt sich die Zahl %01100110=102.  Auch  hier  wurde  der
Sprite um eine Position vertikal verstellt.

