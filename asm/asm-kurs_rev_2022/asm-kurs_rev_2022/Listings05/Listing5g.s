
; Listing5g.s	AUF- UND ABSCROLLEN EINES BILDES DURCH ÄNDERN DER BITPLANEPTERS
;				KOMBINIERT MIT DEM SPIEGELEFFEKT, HERGESTELLT MIT DEN MODULO

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

	bsr.s	BewegeCopper	; Läßt Bild rauf und runter gehen durch
							; Modifizieren der BitplanePointers

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

;	Diese Routine bewegt das Bild nach oben und unten, imdem sie auf
;	die Bitplanepointer in der Copperlist zugreift (Mit dem Label
;	BPLPOINTERS).
;

BewegeCopper:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	TST.B	RaufRunter		; Müßen wir nach oben oder unten?

	beq.w	GehRunter
	cmp.l	#PIC-(40*18),d0 ; sind wir weit genug OBEN?
	beq.s	SetzRunter		; wenn ja, sind wir am Ende und müßen runter
	sub.l	#40,d0			; subtrahieren 40, also 1 Zeile, dadurch
							; wandert das Bild nach UNTEN
	bra.s	Ende


SetzRunter:
	clr.b	RaufRunter		; Durch Löschen von RaufRunter wird das TST
	bra.s	Ende

GehRunter:

	cmpi.l	#PIC+(40*130),d0; sind wir weit genug UNTEN?
	beq.s	SetzRauf		; wenn ja, sind wir am unteren Ende und
							; müßen wieder rauf			
	add.l	#40,d0			; Addieren 40, also 1 Zeile, somit scrollt
							; das Bild nach OBEN
	bra.s	Ende

SetzRauf:
	move.b	#$ff,RaufRunter ; Wenn das Label nicht auf NULL steht,
	rts						; bedeutet das, daß wir rauf müßen

Ende:						; POINTEN DIE BITPLANEPOINTER AN
	LEA	BPLPOINTERS,A1		; POINTER in der COPPERLIST
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier: 3) 

POINTBP2:
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Pl.
	swap	d0				; vertauscht die 2 Word von d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Pl.
	swap	d0				; vertauscht die 2 Word von d0 (3412 > 1234)
	ADD.L	#40*256,d0		; + Länge Bitplane -> nächstes Bitplane
	addq.w	#8,a1			; zu den nächsten bplpointers in der Cop
	dbra	d1,POINTBP2		; Wiederhole D1 Mal POINTBP (D1=n. bitplanes)
	rts


;	Dieses Byte, vom Label RaufRunter markiert, ist ein FLAG.

RaufRunter:
	dc.b	0,0


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

;	SPIEGELEFFEKT (könnte man als "TextureMap-Effekt" verkaufen)

	dc.w	$b007,$fffe
	dc.w	$180,$004		; Color0
	dc.w	$108,-40*7		; Bpl1Mod - Spiegel 5 Mal halbiert
	dc.w	$10a,-40*7		; Bpl2Mod
	dc.w	$b307,$fffe
	dc.w	$180,$006		; Color0
	dc.w	$108,-40*6		; Bpl1Mod - Spiegel 4 Mal halbiert
	dc.w	$10a,-40*6		; Bpl2Mod
	dc.w	$b607,$fffe
	dc.w	$180,$008		; Color0
	dc.w	$108,-40*5		; Bpl1Mod - Spiegel um  3 Mal halbiert
	dc.w	$10a,-40*5		; Bpl2Mod
	dc.w	$bb07,$fffe
	dc.w	$180,$00a		; Color0
	dc.w	$108,-40*4		; Bpl1Mod - Spiegel 2 Mal halbiert
	dc.w	$10a,-40*4		; Bpl2Mod
	dc.w	$c307,$fffe
	dc.w	$180,$00c		; Color0
	dc.w	$108,-40*3		; Bpl1Mod - Spiegel 
	dc.w	$10a,-40*3		; Bpl2Mod
	dc.w	$d007,$fffe
	dc.w	$180,$00e		; Color0
	dc.w	$108,-40*2		; Bpl1Mod - normaler Spiegel
	dc.w	$10a,-40*2		; Bpl2Mod
	dc.w	$d607,$fffe
	dc.w	$180,$00f		; Color0
	dc.w	$108,-40		; Bpl1Mod - FLOOD, wiederholte Zeilen für den
	dc.w	$10a,-40		; Bpl2Mod - Vergrößerungseffekt in der Mitte
	dc.w	$da07,$fffe
	dc.w	$180,$00e		; Color0
	dc.w	$108,-40*2		; Bpl1Mod - normaler Spiegel
	dc.w	$10a,-40*2		; Bpl2Mod
	dc.w	$e007,$fffe
	dc.w	$180,$00c		; Color0
	dc.w	$108,-40*3		; Bpl1Mod - Spiegel
	dc.w	$10a,-40*3		; Bpl2Mod
	dc.w	$ed07,$fffe
	dc.w	$180,$00a		; Color0
	dc.w	$108,-40*4		; Bpl1Mod - Spiegel 2 Mal halbiert
	dc.w	$10a,-40*4		; Bpl2Mod
	dc.w	$f507,$fffe
	dc.w	$180,$008		; Color0
	dc.w	$108,-40*5		; Bpl1Mod - Spiegel 3 Mal halbiert
	dc.w	$10a,-40*5		; Bpl2Mod
	dc.w	$fa07,$fffe
	dc.w	$180,$006		; Color0
	dc.w	$108,-40*6		; Bpl1Mod - Spiegel 4 Mal halbiert
	dc.w	$10a,-40*6		; Bpl2Mod
	dc.w	$fd07,$fffe
	dc.w	$180,$004		; Color0
	dc.w	$108,-40*7		; Bpl1Mod - Spiegel 5 Mal halbiert
	dc.w	$10a,-40*7		; Bpl2Mod
	dc.w	$ff07,$fffe
	dc.w	$180,$002		; Color0
	dc.w	$108,-40		; stoppt das Bild, um nicht die Bytes vor dem
	dc.w	$10a,-40		; RAW anzuzeigen
 
	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	BILD

	dcb.b	40*98,0			; oben freimachen
PIC:	
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format
	dcb.b	40*30,0			; siehe oben

	end

In diesem Beispiel wurde durch das Setzen mehrerer Modulo eine Art Spiegelung
um eine ziemlich rudimentale, runde Fläche simuliert. Wenn man die Modulo
richtig setzt, kann man auch Effekte wie "Vergrößerung" oder ZOOM erzielen,
weiters auch zylindrische Verzerrungen, wie in diesem Beispiel, vor allem
wenn man dann noch einige Farben zur Hilfe zieht, wie etwa der blaue
Balken.
Das Listing ist das gleiche wie in Listing5c.s, nur wurde hier die Copperlist
etwas geändert. Durch die $dff102 (BPLCON1) konnte so etwas Realismus ins
Spiel gebracht werden. Tauscht die Copperlist mit dieser aus, es ist eine
Mischung mit der in Listing5d2.s

-Ich erinnere, daß man die Tasten Amiga+x dazu verwenden kann, einen Teil
auszuschneiden, der vorher mit Amiga+b markiert wurde. Dieser Teil kann
dann mit Amiga+i in einem beliebeigen Ort eingesetzt werden, dort, wo gerade
der Cursor steht.

	dc.w	$b007,$fffe
	dc.w	$180,$004		; Color0
	dc.w	$102,$011		; bplcon1
	dc.w	$108,-40*7		; Bpl1Mod - Spiegel 5 Mal halbiert
	dc.w	$10a,-40*7		; Bpl2Mod
	dc.w	$b307,$fffe
	dc.w	$180,$006		; Color0
	dc.w	$102,$022		; bplcon1
	dc.w	$108,-40*6		; Bpl1Mod - Spiegel 4 Mal halbiert
	dc.w	$10a,-40*6		; Bpl2Mod
	dc.w	$b607,$fffe
	dc.w	$180,$008		; Color0
	dc.w	$102,$033		; bplcon1
	dc.w	$108,-40*5		; Bpl1Mod - Spiegel 3 Mal halbiert
	dc.w	$10a,-40*5		; Bpl2Mod
	dc.w	$bb07,$fffe
	dc.w	$180,$00a		; Color0
	dc.w	$102,$044		; bplcon1
	dc.w	$108,-40*4		; Bpl1Mod - Spiegel 2 Mal halbiert
	dc.w	$10a,-40*4		; Bpl2Mod
	dc.w	$c307,$fffe
	dc.w	$180,$00c		; Color0
	dc.w	$102,$055		; bplcon1
	dc.w	$108,-40*3		; Bpl1Mod - Spiegel
	dc.w	$10a,-40*3		; Bpl2Mod
	dc.w	$d007,$fffe
	dc.w	$180,$00e		; Color0
	dc.w	$102,$066		; bplcon1
	dc.w	$108,-40*2		; Bpl1Mod - normaler Spiegel
	dc.w	$10a,-40*2		; Bpl2Mod
	dc.w	$d607,$fffe
	dc.w	$180,$00f		; Color0
	dc.w	$102,$077		; bplcon1
	dc.w	$108,-40		; Bpl1Mod - FLOOD, wiederholte Zeilen für den
	dc.w	$10a,-40		; Bpl2Mod - Vergrößerungseffekt in der Mitte
	dc.w	$da07,$fffe
	dc.w	$180,$00e		; Color0
	dc.w	$102,$066		; bplcon1
	dc.w	$108,-40*2		; Bpl1Mod - normaler Spiegel
	dc.w	$10a,-40*2		; Bpl2Mod
	dc.w	$e007,$fffe
	dc.w	$180,$00c		; Color0
	dc.w	$102,$055		; bplcon1
	dc.w	$108,-40*3		; Bpl1Mod - Spiegel
	dc.w	$10a,-40*3		; Bpl2Mod
	dc.w	$ed07,$fffe
	dc.w	$180,$00a		; Color0
	dc.w	$102,$044		; bplcon1
	dc.w	$108,-40*4		; Bpl1Mod - Spiegel 2 Mal halbiert
	dc.w	$10a,-40*4		; Bpl2Mod
	dc.w	$f507,$fffe
	dc.w	$180,$008		; Color0
	dc.w	$102,$033		; bplcon1
	dc.w	$108,-40*5		; Bpl1Mod - Spiegel 3 Mal halbiert
	dc.w	$10a,-40*5		; Bpl2Mod
	dc.w	$fa07,$fffe
	dc.w	$180,$006		; Color0
	dc.w	$102,$022		; bplcon1
	dc.w	$108,-40*6		; Bpl1Mod - Spiegel 4 Mal halbiert
	dc.w	$10a,-40*6		; Bpl2Mod
	dc.w	$fd07,$fffe
	dc.w	$180,$004		; Color0
	dc.w	$102,$011		; bplcon1
	dc.w	$108,-40*7		; Bpl1Mod - Spiegel 5 Mal halbiert
	dc.w	$10a,-40*7		; Bpl2Mod
	dc.w	$ff07,$fffe
	dc.w	$180,$002		; Color0
	dc.w	$102,$000		; bplcon1
	dc.w	$108,-40		; stoppe das Bild, um nicht die Bytes vor
	dc.w	$10a,-40		; dem RAW anzuzeigen

