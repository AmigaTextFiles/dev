
; Listing5f.s	"SCHMELZEFFEKT" ODER "FLOOD", HERGESTELLT MIT NEGATIVEN MODULO 

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes

;	POINTEN AUF UNSERE BITPLANES
 
	MOVE.L	#PIC,d0			; in d0 kommt die Adresse unserer PIC
	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)		; kopiert das niederwertige Word der Plane-
							; Adresse ins richtige Word der Copperlist
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)

	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, -> nächstes Plane

	addq.w	#8,a1			; zu den nächsten Bplpointers in der Cop
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1=n. bitplanes)

	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; überspringe die Routine

	bsr.s	Flood			; Effekt des "Schmelzens"

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts


; DATEN

GfxName:
	dc.b	"graphics.library",0,0	

GfxBase:		; Hier hinein kommt die Basisadresse der graphics.lib,
	dc.l	0	; ab hier werden die Offsets gemacht

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystemes


; Effekt, den man als "flüßiges Metall" definieren könnte.
; Erreicht mit Modulo -40

Flood:
	TST.B	RaufRunter		; Müßen wir rauf oder runter?
	beq.w	GehRunter
	cmp.b	#$30,FWAIT		; sind wir weit genug oben?
	beq.s	SetzRunter		; wenn ja, sind wir oben und müßen runter
	subq.b	#1,FWAIT
	rts

SetzRunter:
	clr.b	RaufRunter		; Durch Löschen von RaufRunter wird das TST
	rts

GehRunter:
	cmp.b	#$f0,FWAIT		; sind wir weit genug Unten?
	beq.s	SetzRauf		; wenn ja, müßen wir rauf gehen
	addq.b	#1,FWAIT		; gehen nach oben
	rts

SetzRauf:
	move.b	#$ff,RaufRunter ; Wenn das Label nicht auf NULL steht,
	rts						; bedeutet das, daß wir rauf müßen


;	Dieses Byte, vom Label RaufRunter markiert, ist ein FLAG.

RaufRunter:
	dc.b	0,0


	SECTION GRAPHIC,DATA_C


COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	(Register mit Standardwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210  ; BPLCON0:
	dc.w	$100,%0011001000000000  ; Bits 13 und 12 an!! (3 = %011)
									; 3 Bitplanes Lowres, nicht Lace
BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT

	dc.w	$0180,$000		; Color0
	dc.w	$0182,$475		; Color1
	dc.w	$0184,$fff		; Color2
	dc.w	$0186,$ccc		; Color3
	dc.w	$0188,$999		; Color4
	dc.w	$018a,$232		; Color5
	dc.w	$018c,$777		; Color6
	dc.w	$018e,$444		; Color7
FWAIT:
	dc.w	$3007,$FFFE		; WAIT das dem negativen Modulo
	dc.w	$108,-40		; vorangeht
	dc.w	$10a, 0
 	
	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	BILD

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	end

Zu Bemerken ist, daß -40 als $ffd9 assembliert wird (probiert ein "?-40").
Versucht, die Routine zu stoppen, indem ihr die rechte  Maustaste  drückt,
ihr  werdet sehen, wie sich die letzte Zeile bis zum Ende des Bildschirmes
fortsetzt. Wir haben festgestellt, daß mit einem Modulo von -40 der Copper
praktisch  nicht  voran kommt, er geht zwar 40 vor, kehrt dann aber wieder
40 zurück. Aber wenn wir das Modulo -80 setzen, was  passiert  dann??  Wie
lesen  rückwärts!!  In  der  Tat, er liest 40 Bytes, geht 80 zurück, liest
weitere 40, geht  80  zurück  etc.  Er  hüpft  also  jedesmal  eine  Zeile
rückwärts. Dieser "Spiegeleffekt" ist auf dem Amiga recht häufig zu sehen,
eben  weil  er  sehr  einfach  zu  erzeugen  ist.  Es  reichen  ein   paar
Copperbefehle:

	dc.w	$108,-80
	dc.w	$10a,-80

Probiert die  zwei Modulo von -40 auf -80 abzuändern, und der Spiegel wird
erscheinen. Auch wenn diesmal das Problem  ist,  daß  einiges  dargestellt
wird,  das  sich  ober  dem  Bild befindet, wir gehen ja nach hinten. Eine
Kuriosität: ihr seht sicher die erste Zeile des "Schmutzes", die nach  dem
Bild  beginnt.  Gut,  seht ihr auch, daß sich einige Pixel bewegen? Es ist
auf das Wait in der Copperlist zurückzuführen, das sich  bei  jedem  Frame
ändert!  Denn  was  befindet  sich  im  Speicher  vor  unserem  Bild?? Die
Copperlist!! Wenn wir also rückwärts gehen und unser Bild am vorderen Ende
verlassen  (mit  dem Modulo -80), was wird dann wohl angezeigt? zuerst die
Bytes in der Copperlist, und dann was vorher ist..

Wenn wir den Negativwert weiter erhöhen, werden wir  immer  "zerdrücktere"
Spiegel  bekommen. Es ist ja das gleiche wie mit den positiven Modulo, nur
seitenverkehrt.

	dc.w	$108,-40*3
	dc.w	$10a,-40*3

Für ein speigelverkehrtes, halbiertes Bild, etc.


