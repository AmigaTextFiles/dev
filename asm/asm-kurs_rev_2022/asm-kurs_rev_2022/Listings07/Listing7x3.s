
; Listing7x3.s	- Kollisionen zwischen Playfield im Dual-Playfield-Mode
; In diesem Beispiel zeigen wir die Kollisionen zwischen zwei Playfields.
; Das Playfield 1 bewegt sich von oben nach unten.
; Wenn sich Color3 des Playfield 1 mit dem Color1 des Playfield 2 überlappt,
; wird eine Kollision ausgelöst, die das Ändern der Hintergrundfarbe zur 
; Folge hat
; WinUAE: Chipset/Collision Level/Full

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

; Verwenden 2 Planes pro Playfield

;	Pointen wie immer auf unser PIC

    MOVE.L  #PIC1,d0			; pointen auf Playfield 1
    LEA     BPLPOINTERS1,A1
    MOVEQ   #2-1,D1
POINTBP:
	move.w  d0,6(a1)
	swap    d0
	move.w  d0,2(a1)
	swap    d0
	ADD.L   #40*256,d0
	addq.w  #8,a1
	dbra    d1,POINTBP

	MOVE.L  #PIC2,d0			; pointen auf Playfield 2
	LEA     BPLPOINTERS2,A1
	MOVEQ   #2-1,D1
POINTBP2:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP2

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!
	
	move.w	#$0024,$dff104		; BPLCON2
								; mit diesem Wert sind alle Sprites über
								; den Bitplanes

Warte1:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	bne.s	Warte1
Warte11:
	cmpi.b	#$ff,$dff006		; Immer noch Zeile 255?
	beq.s	Warte11

	btst	#6,$bfe001
	beq.s	Raus

	bsr.s	BewegeCopper		; Bewege Playfield 1
	bsr.w	CheckColl			; Kontrolliert die Kollision und greift ein

	bra.s	Warte1

Raus:
	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte COP

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; Diese Routine bewegt ein Playfield nach unten. Es ist die selbe wie in
; Lektion 5, nur daß wir hier nur das Playfield 1 bewegen, also die
; ungeraden Bitplanes.

BewegeCopper:
	LEA	BPLPOINTERS1,A1		; Mit diesen 4 Instruktionen hole ich aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und gebe es in d0 - das
	move.w	6(a1),d0		; Gegenteil der Routine, die auf die Planes
							; pointet! Hier nehmen wir uns die Adresse
							; anstatt sie einzusetzen!

	TST.B	RaufRunter		; Müssen wir rauf oder runter? Wenn RaufRunter
							; auf Null steht (TST also ein BEQ ergibt),
							; dann springen wir auf GehRunter, wenn es
							; hingegen auf $FF steht (und TST nicht 
							; eintrifft), dann steigen wir weiter

	beq.w	GehRunter
	cmp.l	#PIC1-(40*90),d0; Sind wir weit genug OBEN?
	beq.s	SetzRunter		; wenn ja, sind wir am Gipfel und müssen runter
	sub.l	#40,d0			; subtrahieren 40, also 1 Zeile, dadurch
							; scrollt das Bild um 1 nach unten
	bra.s	ENDE

SetzRunter:
	clr.b	RaufRunter 		; Löscht RaufRunter, beim TST.B RaufRunter
							; wird ein BEQ
	bra.s	ENDE			; zur Routine GehRunter abzweigen

GehRunter:
	cmpi.l	#PIC1+(40*30),d0 ; sind wir weit genug UNTEN?
	beq.s	SetzRauf		; wenn ja, sind wir ganz unten und müssen rauf
	add.l	#40,d0			; Addieren 40, also eine, Zeile, das Bild 
							; scrollt nach OBEN
	bra.s	ENDE

SetzRauf:
	move.b	#$ff,RaufRunter	; Wenn das Label RaufRunter nicht auf Null ist
	rts						; bedeutet es, daß wir steigen müssen

ENDE:						; POINTEN DIE BITPLANEPOINTER
	LEA	BPLPOINTERS1,A1		; pointer in der COPPERLIST
	MOVEQ	#1,D1			; Anzahl der Bitplanes -1 (hier sind es 2)
POINTBP3:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP3
	rts


; Dieses Byte, an der Stelle, die RaufRunter markiert, ist ein FLAG.

RaufRunter:
	dc.b	0,0


; Diese Routine kontrolliert, ob es eine Kollision gibt.
; Wenn ja, verändert sie die Farbe des Hintergrundes, indem sie auf
; das Register COLOR00 in der Copperlist zugreift.

CheckColl:
     move.w	$dff00e,d0		; liest CLXDAT ($dff00e)
							; das Lesen dieses Registers bewirkt auch
							; seine sofortige Löschung, es ist also besser,
							; man kopiert es sich in d0 und macht dort dann
							; die Tests
	btst.l	#0,d0           ; das Bit 1 meldet eine Kollision zwischen 
							; zwei Playfields								
    beq.s	no_coll			; wenn´s keine Kollision gab, überspringe

    move.w	#$f00,Kollisions_Sensor	; "anschalten" des Signales (COLOR0)
							; verändert die Copperlist (Rot)
    bra.s	exitColl		; Raus
	
no_coll:
	move.w	#$000,Kollisions_Sensor ; Schaltet den Sensor aus (Color0)
							; indem er auf die Copperlist einwirkt
ExitColl:
	rts

flag:
	dc.w	0
altezza:
	dc.w	$2c

	
	SECTION	GRAPHIC,DATA_C

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
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0100011000000000	; Bit 10 an = Dual Playfield
							; verwende 4 Planes = 4 Farben pro
							; Playfield

BPLPOINTERS1:
	dc.w	$e0,0,$e2,0		; erste Bitplane Playfield 1 (BPLPT1)
	dc.w	$e8,0,$ea,0		; zweite Bitplane Playfield 1 (BPLPT3)
	
BPLPOINTERS2:
	dc.w	$e4,0,$e6,0		; erste Bitplane Playfield 2 (BPLPT2)
	dc.w	$ec,0,$ee,0		; zweite Bitplane Playfield 2 (BPLPT4)

; Das ist das Register CLXCON (kontrolliert die Art der Signalisierung)

; Die Bit von 0 bis 5 sind die Werte, die die Planes annehmen müssen
; Die Bit von 6 bis 11 geben an, welche Planes für Kollisionen freigegeben sind
; Die Bit von 12 bis 15 geben an, welche der ungeraden Sprites für die
; Kollisionserfassung aktiviert sind

				;5432109876543210
	dc.w	$98,%0000001111000111	; CLXCON

; Die Planes 1,2,3,4 sind für Kollisionen aktiviert (Bit 6,7,8,9).
; Es wird eine Kollision angezeigt, wenn sich folgende Situationen ergeben:
;				Plane 1 = 1 (Bit 0)
;       		Plane 3 = 1 (Bit 2)
; Also Color3 des Playfield 1
; 				Plane 2 = 1 (Bit 1)
;       		Plane 4 = 0 (Bit 3)
; also Color1 des Playfield 2


	dc.w	$180			; COLOR00
Kollisions_Sensor:
	dc.w	0				; AN DIESEM PUNKT modifiziert die Routine CheckColl
							; die Copperlist, indem sie einen anderen Wert einträgt

                        	; Palette Playfield 1
	dc.w	$182,$005		; Farben von 0 bis 7
	dc.w	$184,$a40
	dc.w	$186,$f80
	dc.w	$188,$f00
	dc.w	$18a,$0f0
	dc.w	$18c,$00f
	dc.w	$18e,$080
	
							; Palette Playfield 2
	dc.w	$192,$367		; Farben von 9 bis 15
	dc.w	$194,$0cc 		; Color8 ist durchsichtig, er wird also nicht
	dc.w	$196,$a0a 		; gesetzt
	dc.w	$198,$242
	dc.w	$19a,$282
	dc.w	$19c,$861
	dc.w	$19e,$ff0

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

	dcb.b	40*90,0			; Diesen freien Raum brauchen wir, denn wenn wir über
							; bzw. unter der Zone des PIC1 anzeigen, dann sehen
							; wir ja das, was darüber/darunterliegt, und das
							; ergäbe im Normalfall zufällige Bytes.
							; Durch viele Nullen aber haben wir COLOR0, also die
							; Hintergrundfarbe.

PIC1:	incbin	"/Sources/colldual1.raw"
	dcb.b	40*30,0			; siehe oben

PIC2:	incbin	"/Sources/colldual2.raw"

	end

In diesem Beispiel zeigen wir die  Kollision zwischen zwei Playfields. Der
Mechanismus ist der gleiche wie mit den  Sprites. Das Register CLXCON wird
verwendet, um  anzugeben, welche Planes für  die Spriteerkennung aktiviert 
werden sollen.  Wie immer ist es  möglich, das anzugeben, und  bei welchen 
Werten der Überlagerung der Farben sich eine Kollision ergeben soll.
Im Beispiel erkennen wir die Kollision zwischen Color3 des Playfield 1 und
Color1 des Playfield 2.  Wenn ihr  die Copperlist verändert,  und den Wert
von CLXCON  austauscht,  dann  könnt  ihr  andere  Typen von Zusammenstöße 
erkennen. Zum Beispiel so:

	dc.w	$98,%0000001111000110	; CLXCON

Die Planes 1,2,3 und 4 sind für die Kollisionen aktiviert (Bit 6,7,8,9).

Es wird eine Kollision angezeigt, wenn sich ein Pixel mit
					Plane 1 = 0 (Bit 0)
       	        	Plane 3 = 1 (Bit 2)
 also Color2 des Playfield1
 
 und ein Pixel mit	Plane 2 = 1 (Bit 1)
               		Plane 4 = 0 (Bit 3)
 also Color1 des Playfield 2
 überlagern.

Ihr könnt auch Kollisionen zwischen mehreren Farben erkennen, indem ihr
einfach einige Planes ausschaltet. Beispiel:

	dc.w	$98,%0000001011000011	; CLXCON

Die Planes 1,2 und 4 sind für Kollisionen aktiviert (Bit 6,7 und 9).
Was Playfield 2 angeht, so wurden beide Planes aktiviert, es werden also
die Pixel betrachtet, die:	Plane 2 = 1 (Bit 1)
							Plane 4 = 0 (Bit 3)
haben, also Color1 des Playfield 2.

Bei  Playfield1  hingegen  wurde  nur Plane 1 eingeschaltet, der Wert  des
Plane3 hat keinen Einfluß.Es werden also die Pixel betrachtet,die folgende
Konfiguration haben:	Plane 0 = 1 (Bit 0)
						Plane 3 = 0 (Bit 2)

						Plane 0 = 1 (Bit 0)
                        Plane 3 = 1 (Bit 2)

Es wird also Color1 und Color3 des Playfield1 betrachtet.

Für die  Erkennung  wird  dann wie  immer ein Bit in CLXDAT  verwendet. In 
diesem Fall handelt es sich  um das Bit 0.  Wenn  es auf 1 steht, dann hat 
eine Kollision stattgefunden, ansonsten nicht.

