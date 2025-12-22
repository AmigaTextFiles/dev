
; Listing5l.s	"VERLÄNGERUNGSEFFEKT", HERGESTELLT DURCH ALTERNIEREN DER
;				NORMALEN MODULO UND MODULO -40

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
	btst	#6,$bfe001		; linke Taste gedrückt?
	bne.s	mouse			; wenn nicht, geh nicht weiter
	
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


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	(Register mit Standartwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210  ; BPLCON0:
	dc.w	$100,%0011001000000000  ; Bits 13 und 12 an!! (3 = %011)

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


; COPPERLIST, DIE "VERLÄNGERT"

	dc.l	$8907fffe			; Wait Zeile $89
	dc.w	$108,-40,$10a,-40	; Modulo -40, Wiederholung der letzten Zeile
	dc.l	$9007fffe			; Warte 7 Zeilen - werden alle gleich sein
	dc.w	$108,0,$10a,0		; dann lasse ich alles eine Zeile weitergehen
	dc.l	$9107fffe			; und auf der nächsten Zeile...
	dc.w	$108,-40,$10a,-40	; setze ich das Modulo auf FLOOD
	dc.l	$9807fffe			; Warte 7 Zeilen - werden alle gleich sein
	dc.w	$108,0,$10a,0		; gehe auf die nächste Zeile
	dc.l	$9907fffe			; dann...
	dc.w	$108,-40,$10a,-40	; ich wiederhole diese Zeile 7 mal mit
	dc.l	$a007fffe			; Modulo auf -40
	dc.w	$108,0,$10a,0		; nächste Zeile... ECZETERA.
	dc.l	$a107fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$a807fffe
	dc.w	$108,0,$10a,0
	dc.l	$a907fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$b007fffe
	dc.w	$108,0,$10a,0
	dc.l	$b107fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$b807fffe
	dc.w	$108,0,$10a,0
	dc.l	$b907fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$c007fffe
	dc.w	$108,0,$10a,0
	dc.l	$c107fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$c807fffe
	dc.w	$108,0,$10a,0
	dc.l	$c907fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$d007fffe
	dc.w	$108,0,$10a,0
	dc.l	$d107fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$d807fffe
	dc.w	$108,0,$10a,0
	dc.l	$d907fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$e007fffe
	dc.w	$108,0,$10a,0
	dc.l	$e107fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$e807fffe
	dc.w	$108,0,$10a,0
	dc.l	$e907fffe
	dc.w	$108,-40,$10a,-40
	dc.l	$f007fffe
	dc.w	$108,0,$10a,0		; zurück zum Normalzustand

	dc.w	$FFFF,$FFFE			; Ende der Copperlist

;	BILD


PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	end

Dies  ist  eine  weitere Anwendung des FLOOD-Effektes, hergestellt mit den
Modulo. Es ist relativ einfach, ein Bild zu "ziehen" oder Pixel größer  zu
simulieren,  als sie in Wirklichkeit sind. Einfach die Modulo alternieren,
einmal -40, die verlängern (Flood), dann auf 0 setzen, die das Bild normal
weiterzeichnen  lassen. Hat man eine Zeile gezeichnet, kommt sofort wieder
der Flood zum Einsatz: weitere 7 Zeilen  werden  gleich  wie  diese  sein.
Dieses  Spiel  wiederholt  sich, solange man will. In diesem Beispiel wird
eine Zeile zu  8,  denn  einmal  wird  sie  gezeichnet,  dann  sieben  mal
"kopiert". Wenn man diese "Distanzen" vergrößert und verkleinert, also mal
3 Zeilen, mal 6,..., kann man interessante "ZOOM"-Effekte erzeugen!

