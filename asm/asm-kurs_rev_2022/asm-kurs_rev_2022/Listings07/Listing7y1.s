
; Listing7y1.s	EIN SPRITE WIRD ANGEZEIGT, INDEM WIR DIREKT IN DIE REGISTER
;				SCHREIBEN (OHNE DMA)
;	Dieses Beispiel zeigt, wie man einen Sprite erzeugen kann, indem man
;	direkt in die Register schreibt. Der Sprite wird unter anderem auf
;	zwei verschiedenen horizontalen Positionen angezeigt, gleich wie
;	bei der Wiederverwendung.

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf das "leere" PIC

	MOVE.L	#BITPLANE,d0	; wohin pointen
	LEA	BPLPOINTERS,A1		; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Wir pointen NICHT auf den Sprite !!!!!!!!!!!!!!!!!!!!

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; starten die alte SystemCOP

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

				; 5432109876543210
	dc.w	$100,%0001001000000000	; Bit 12 an: 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste	bitplane

	dc.w	$180,$000		; COLOR0	; Schwarzer Hintergrund
	dc.w	$182,$123		; COLOR1	; COLOR1 des Bitplane, das in
							; diesem Fall leer ist, er
							; erscheint also nicht.

	dc.w	$1A2,$FF0		; COLOR17, also COLOR1 des Sprite0 - GELB
	dc.w	$1A4,$a00		; COLOR18, also COLOR2 des Sprite0 - ROT
	dc.w	$1A6,$F70		; COLOR19, also COLOR3 des Sprite0 - ORANGE


	dc.w	$4007,$fffe		; Warte auf Zeile $40
	dc.w	$140,$0080		; SPR0POS - Horizontale Position
	dc.w	$142,$0000		; SPR0CTL
	dc.w	$146,$0e70		; SPR0DATB
	dc.w	$144,$03c0		; SPR0DATA - aktiviert Sprite

	dc.w	$6007,$fffe		; Warte auf Zeile $60
	dc.w	$142,$0000		; SPR0CTL - "deaktiviert" den Sprite

	dc.w	$140,$00a0		; SPR0POS - neue horizontale Position
	dc.w	$146,$2ff4		; SPR0DATB
	dc.w	$8007,$fffe		; Warte auf Zeile $80
	dc.w	$144,$13c8		; SPR0DATA - aktiviert den Sprite

	dc.w	$b407,$fffe		; Warte auf Zeile $b4
	dc.w	$142,$0000		; SPR0CTL - "deaktiviert" den Sprite

	dc.w	$FFFF,$FFFE		; Ende der Copperlist



	SECTION LEERESPLANE,BSS_C	; Wir brauchen ein leeres Bitplane,
							; denn ohne Bitplanes können wir
							; keine Sprites anzeigen.
					
BITPLANE:
	ds.b	40*256			; leeres Bitplane Lowres

	end

In diesem Beispiel sehen wir, wie wir einen Sprite verwenden können, indem
wir direkt die Register SPRxPOS, SPRxCTL, SPRxDATA und SPRxDATB verwenden.
Als erstes wird euch aufgefallen sein, daß wir den Sprite NICHT anpointen.
Es  gibt  nicht  einmal  eine  Spritestruktur im Speicher (Chip Ram). Denn
diese Struktur wird vom DMA verwendet, und in der  Praxis  tut  er  nichts
anderes  als  diese Daten in die obengenannten Register zu laden. Wenn wir
die Daten selbst in diese Register schreiben, dann brauchen  wir  den  DMA
nicht.  Sehen  wir  im  Detail,  wie  diese  Register verwendet werden. In
SPRxPOS kommt die Position des Sprites. Der Inhalt  dieses  Registers  ist
praktisch  der  gleiche wie der im ersten Kontrollword der Spritestruktur.
Der Unterschied ist aber, daß VSTART die  vertikale  Position  der  Sprite
nicht  beeinflußt. Die Sprites werden aktiviert, indem man in das Register
SPRxDATA schreibt. Wenn er einmal aktiviert ist, dann  wird  er  in  jeder
Zeile  neu  geschrieben,  auf  der  selben  horizontalen  Position  wie
eingegeben. Er hat also in jeder Zeile die gleiche "Form". Diese Form wird
in  die  Register SPRxDATA und SPRxDATB geschrieben. Die höherwertigen Bit
kommen in DATB, die niederwertigeren in DATA. Diese zwei  Register  werden
bei  jeder  Zeile  wiederverwendet. Wenn wir also wollen, daß die Form des
Sprites von einer Zeile zur anderen wechselt, dann müssen wir diese beiden
Register bei jeder Zeile verändern.
Das Register SPRxCTL hat den gleichen Inhalt wie das  zweite  Kontrollword
der  Struktur.  Auch  hier  ist die vertikale Position ungültig. Praktisch
gesehen haben nur die Bits 0 und 7 von allen einen Sinn:  Bit  0  ist  das
niederwertige  Bit  von  HSTART  und  Bit 7 ist für die "Attached"-Sprites
notwendig. Durch Schreiben in das  Register  SPRxCTL  werden  die  Sprites
wieder deaktiviert.

Die  Sprites  ohne  DMA zu verwenden ist recht unpraktisch, weil bei jeder
Zeile die Register SPRxDATx verändert werden  müssen.  Normalerweise  wird
diese  Methode  auch  nicht  verwendet. Sie ist aber vorteilhaft, wenn wir
einen  Sprite  brauchen,  der  in  jeder  Zeile  gleich  ist:  Um  Säulen
herzustellen,  sonst  fällt  mir  nichts  ein. In diesem Fall ist es nicht
nötig, in jeder Zeile die Register SPRxDATx zu verändern, denn  es  bleibt
immer  das  Gleiche. Des Weiteren sparen wir viel Speicher: wenn wir einen
Säulen-Sprite machen möchten, der 100 Zeilen hoch ist, dann bräuchten  wir
mit  dem  DMA  eine  Struktur,  die  100  Zeilen  lang  ist,  Kontrollword
ausgeschloßen!

Die Prozedur, um ohne DMA Säulen und Kolonnen herzustellen, ist also:

1) die richtigen Werte in SPRxPOS, SPRxCLT und SPRxDATB schreiben.
2) die gewollte, vertikale  Position  abwarten,  ab  der  man  den  Sprite
  starten  will.
3) Den Wert in SPRxDATA schreiben. Damit wird  der  Sprite  aktiviert  und
  gezeichnet,  für  jede  folgende Zeile gleich.
4) Man wartet die vertikale Position ab, an der der Sprite enden soll.
5) Man schreibt irgend etwas in das Register SPRxCTL

Es ist auch möglich, wie in diesem Beispiel vorgeführt, mehrere Säulen auf
verscheidenen Höhen anzuzeigen, indem diese Prozedur wiederholt wird.  Man
könnte auch die Palette zwischen einer Säule und der anderen verändern.


