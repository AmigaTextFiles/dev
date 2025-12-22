
; Listing5n.s	KOMBINATION VON 3 COPPER-EFFEKTEN + BILD IN 8 FARBEN MIT
;				$dff102 und Bitplanepointer-EFFEKTEN

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

	bsr.w	mt_init			; Initialisiert Musik-Routine

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	bsr.w	BewegeCopper	; Roter Bylken unter $FF
	bsr.s	CopperLinkRech	; Routine für links-rechts Scroll
	BSR.w	scrollcolors	; Zyklisches scrollen der Farben
	bsr.w	ScrollPlanes	; Rauf-und Runterscrollen des Bildes
	bsr.w	Wellen			; Wellen mit dem $dff102
	bsr.w	mt_music		; Spielt die Musik

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	bsr.w	mt_end			; Beendet die Musikroutine

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

; **************************************************************************
; *		HORIZONTAL LAUFENDER BALKEN	(Listing3h.s)		   *
; **************************************************************************

CopperLinkRech:
	CMPI.W	#85,FlagRechts	; GehRechts 85 Mal ausgeführt?
	BNE.S	GehRechts		; wenn nicht, wiederhole nochmal
							; wenn es aber 85 Mal ausgeführt wurde,
							; dann geh weiter

	CMPI.W	#85,FlagLinks	; GehLinks 85 Mal ausgeführt?
	BNE.S	GehLinks		; wenn nicht, wiederhole nochmal

	CLR.W	FlagRechts		; Die Routine GehLinks wurde 85 Mal ausge-
	CLR.W	FlagLinks		; führt, also ist zu diesem Zeitpunkt der
							; graue Balken zurückgekommen und der Rechts-
							; GehLinks 85 Mal, etcetera.
	RTS						; ZURÜCK ZUM MOUSE-LOOP

GehRechts:					; Diese Routine bewegt den Balken nach RECHTS
	lea	CopBar+1,A0			; Wir geben in A0 die Adresse des ersten XX-
							; Wertes des ersten Wait, das sich genau 1 Byte
							; nach CopBar befindet

	move.w	#29-1,D2		; wir müßen 29 Wait verändern (verwenden ein DBRA)
RechtsLoop:
	addq.b	#2,(a0)			; zählen 2 zu der X-Koordinate des Wait dazu
	ADD.W	#16,a0			; gehen zum nächsten Wait, das zu ändern ist
	dbra	D2,RechtsLoop	; Zyklus wird d2-Mal durchlaufen
	addq.w	#1,FlagRechts	; vermerken, daß wir ein weiteres Mal GehRechts
							; ausgeführt haben
							; GehRechts: in FlagRechts steht die Anzahl,
							; wie oft wir GehRechts ausgeführt haben
	RTS						; Zurück zum Mouse-Loop


GehLinks:					; diese Routine bewegt den Balken nach LINKS
	lea	CopBar+1,A0
	move.w	#29-1,D2		; wir müßen 29 Wait verändern
LinksLoop:
	subq.b	#2,(a0)			; ziehen der X-Koordinate des Wait 2 ab
	ADD.W	#16,a0			; gehen zum nächsten Wait über, das zu verändern ist
	dbra	D2,LinksLoop    ; Zyklus wird d2-Mal durchgeführt
	addq.w	#1,FlagLinks	; Zählen 1 zur Anzahl dazu, wie oft diese Routine
							; GehLinks ausgeführt wurde
	RTS						; Zurück zum Mouse-Loop

FlagRechts:					; In diesem Word wird die Anzahl festgehalten,
	dc.w	0				; wie oft GehRechts ausgeführt wurde

FlagLinks:					; In diesem Word wird die Anzahl festgehalten,
	dc.w	0				; wie oft GehLinks ausgeführt wurde

; **************************************************************************
; *		ROTER BALKEN UNTER Zeile $FF (LISTING3f.s)		   *
; **************************************************************************

BewegeCopper:
	LEA	BALKEN,a0			; in a0 kommt die Adresse von Balken
	TST.B	RAUFRUNTER2		; Müßen wir steigen oder sinken? Wenn RaufRunter
							; auf 0 steht (wenn TST also BEQ liefert), dann
							; springen wir auf GEHRUNTER, wenn es hingegen
							; auf $FF ist (TST also nicht eintrifft), fahren
	beq.w	GEHRUNTER2		; wir fort und führen somit den "steigenden" Teil
							; aus

	cmpi.b	#$0a,(a0)		; sind wir bei Zeile $0a+$ff angekommen?
	beq.s	SetzRunter2		; wenn ja, sind wir oben angekommen und
	subq.b	#1,(a0)			; müßen runter
	subq.b	#1,8(a0)
	subq.b	#1,8*2(a0)		; nun ändern wir die anderen Wait: der
	subq.b	#1,8*3(a0)		; Abstand zwischen einem und dem anderen beträgt
	subq.b	#1,8*4(a0)		; 8 Byte
	subq.b	#1,8*5(a0)
	subq.b	#1,8*6(a0)
	subq.b	#1,8*7(a0)		; hier müßen wir alle 9 Wait des roten Balken
	subq.b	#1,8*8(a0)		; ändern, wenn wir ihn steigen und sinken lassen
	subq.b	#1,8*9(a0)		; wollen.
	rts


SetzRunter2:
	clr.b	RAUFRUNTER2		; Setzt RAUFRUNTER auf 0, beim TST.B RAUFRUNTER
	rts						; wird das BEQ zu Routine GEHRUNTER verzweigen,
							; und der Balken wird sinken

GEHRUNTER2:
	cmpi.b	#$2c,8*9(a0)	; sind wir bei Zeile $2c angekommen?
	beq.s	SetzRauf2		; wenn ja, sind wir untern und müßen wieder
	addq.b	#1,(a0)			; steigen
	addq.b	#1,8(a0)
	addq.b	#1,8*2(a0)		; nun ändern wir die anderen Wait: der
	addq.b	#1,8*3(a0)		; Abstand zwischen einem und dem anderen beträgt
	addq.b	#1,8*4(a0)		; 8 Byte
	addq.b	#1,8*5(a0)
	addq.b	#1,8*6(a0)
	addq.b	#1,8*7(a0)		; hier müßen wir alle 9 Wait des roten Balken
	addq.b	#1,8*8(a0)		; ändern, wenn wir ihn steigen und sinken lassen
	addq.b	#1,8*9(a0)		; wollen.
	rts

SetzRauf2:
	move.b	#$ff,RAUFRUNTER2; Wenn das Label nicht auf NULL ist,
	rts						; bedeutet es, daß wir steigen müßen

RAUFRUNTER2:
	dc.b	0,0

; **************************************************************************
; *		ZYKLISCHES SCROLLEN DER FARBEN (LISTING3E.s)		   *
; **************************************************************************

Scrollcolors:
	move.w	col2,col1		; col2 kommt in col1
	move.w	col3,col2		; col3 kommt in col2
	move.w	col4,col3		; col4 kommt in col3
	move.w	col5,col4		; col5 kommt in col4
	move.w	col6,col5		; col6 kommt in col5
	move.w	col7,col6		; col7 kommt in col6
	move.w	col8,col7		; col8 kommt in col7
	move.w	col9,col8		; col9 kommt in col8
	move.w	col10,col9		; col10 kommt in col9
	move.w	col11,col10		; col11 kommt in col10
	move.w	col12,col11		; col12 kommt in col11
	move.w	col13,col12		; col13 kommt in col12
	move.w	col14,col13		; col14 kommt in col13
	move.w	col1,col14		; col1 kommt in col14
	rts

; **************************************************************************
; *	SCROLL NACH OBEN UND UNTEN DES BILDEN	(aus Listing5g.s)	   *
; **************************************************************************

ScrollPlanes:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	TST.B	RaufRunter3		; Müßen wir nach oben oder unten?

	beq.w	GehRunter3
	cmp.l	#PIC-(40*18),d0 ; sind wir weit genug OBEN?
	beq.s	SetzRunter3		; wenn ja, sind wir am Ende und müßen runter
	sub.l	#40,d0			; subtrahieren 40, also 1 Zeile, dadurch
							; wandert das Bild nach UNTEN
	bra.s	Ende3


SetzRunter3:
	clr.b	RaufRunter3		; Durch Löschen von RaufRunter wird das TST
	bra.s	Ende3

GehRunter3:
	cmpi.l	#PIC+(40*130),d0; sind wir weit genug UNTEN?
	beq.s	SetzRauf3		; wenn ja, sind wir am unteren Ende und
							; müßen wieder rauf			
	add.l	#40,d0			; Addieren 40, also 1 Zeile, somit scrollt
							; das Bild nach OBEN
	bra.s	Ende3

SetzRauf3:
	move.b	#$ff,RaufRunter3; Wenn das Label nicht auf NULL steht,
	rts						; bedeutet das, daß wir rauf müßen
	
Ende3:						; POINTEN DIE BITPLANEPOINTER AN
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

RaufRunter3:
	dc.b	0,0

; **************************************************************************
; *	WELLENEFFEKT MITTELS MODULO $dff102 (LISTING5H.S)		   *
; **************************************************************************

Wellen:
	LEA	Con1Effekt+8,A0		; Adresse Quellword in a0
	LEA	Con1Effekt,A1		; Adresse Zielword in a1
	MOVEQ	#19,D2			; 45 BPLCON1 sind in COPLIST zu ändern
Vertausche:
	MOVE.W	(A0),(A1)		; kopiert zwei Word - scroll!
	ADDQ.W	#8,A0			; nächstes Word-Paar
	ADDQ.W	#8,A1			; nächstes Word-Paar
	DBRA	D2,Vertausche	; wiederhole "Vertausche" die richtige Anzahl mal

	MOVE.W	Con1Effekt,LetzterWert	; um den Zyklus unendlich fortlaufen zu
	RTS						; lassen kopieren wir den ersten Wert

; **************************************************************************
; *		ROUTINE ZUM ABSPIELEN VON SOUNDTRACKER/PROTRACKER	   *
; **************************************************************************

	include "/Sources/musicE.s"		; Routine, die zu 100% auf allen Amigas funktioniert

; **************************************************************************
; *				SUPER COPPERLIST			   *
; **************************************************************************

	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	Register mit Standartwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

; das BPLCON0 ($dff100) für einen Bildschirm mit 3 Bitplanes: (8 Farben)

			    ; 5432109876543210
	dc.w	$100,%0011001000000000	; bits 13 und 12 an!! (3 = %011)

;	Wir lassen die Bitplanes direkt anpointen, indem wir die Register
;	$dff0e0 und folgende hier in der Copperlist einfügen. Die
;	Adressen der Bitplanes werden dann von der Routine POINTBP
;	automatisch eingetragen

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT

;	Die 8 Farben des Bildes werden hier definiert:

	dc.w	$0180,$000		; color0
	dc.w	$0182,$070		; color1
	dc.w	$0184,$0f0		; color2
	dc.w	$0186,$0c0		; color3
	dc.w	$0188,$090		; color4
	dc.w	$018a,$030		; color5
	dc.w	$018c,$070		; color6
	dc.w	$018e,$040		; color7

; Der Effekt aus Listing3e.s, weiter nach oben verschoben

	dc.w	$2c07,$fffe		; warten auf Zeile 154 ($9a in hexadezimal)
	dc.w	$180			; Register COLOR0
col1:
	dc.w	$0f0			; WERT DES COLOR 0 (wird verändert)
	dc.w	$2d07,$fffe		; warten auf Zeile 155 (wird nicht verändert)
	dc.w	$180			; Register COLOR0 (wird nicht verändert)
col2:
	dc.w	$0d0			; WERT DES COLOR 0 (will be modified)
	dc.w	$2e07,$fffe		; warten auf Zeile 156 (not modified, ecc.)
	dc.w	$180			; Register COLOR0
col3:
	dc.w	$0b0			; WERT DES COLOR 0
	dc.w	$2f07,$fffe		; warten auf Zeile 157
	dc.w	$180			; Register COLOR0
col4:
	dc.w	$090			; WERT DES COLOR 0
	dc.w	$3007,$fffe		; warten auf Zeile 158
	dc.w	$180			; Register COLOR0
col5:
	dc.w	$070			; WERT DES COLOR 0
	dc.w	$3107,$fffe		; warten auf Zeile 159
	dc.w	$180			; Register COLOR0
col6:
	dc.w	$050			; WERT DES COLOR 0
	dc.w	$3207,$fffe		; warten auf Zeile 160
	dc.w	$180			; Register COLOR0
col7:
	dc.w	$030			; WERT DES COLOR 0
	dc.w	$3307,$fffe		; warten auf Zeile 161
	dc.w	$180			; color0... (nun habt ihr schon verstanden,
col8:						; ab hier kann ich´s mir sparen!)
	dc.w	$030
	dc.w	$3407,$fffe		; Zeile 162
	dc.w	$180
col9:
	dc.w	$050
	dc.w	$3507,$fffe		; Zeile 163
	dc.w	$180
col10:
	dc.w	$070
	dc.w	$3607,$fffe		; Zeile 164
	dc.w	$180
col11:
	dc.w	$090
	dc.w	$3707,$fffe		; Zeile 165
	dc.w	$180
col12:
	dc.w	$0b0
	dc.w	$3807,$fffe		; Zeile 166
	dc.w	$180
col13:
	dc.w	$0d0
	dc.w	$3907,$fffe		; Zeile 167
	dc.w	$180
col14:
	dc.w	$0f0
	dc.w	$3a07,$fffe		; Zeile 168

	dc.w	$0180,$000		; color0	; reale Farben des Bildes
	dc.w	$0182,$475		; color1
	dc.w	$0184,$fff		; color2
	dc.w	$0186,$ccc		; color3
	dc.w	$0188,$999		; color4
	dc.w	$018a,$232		; color5
	dc.w	$018c,$777		; color6
	dc.w	$018e,$444		; color7

;	Coppereffekt der Wellen mit dem $dff102 aus Listing5h.s, "geschmälert"

	DC.W	$102
CON1EFFEKT:
	dc.w	$000
	DC.W	$4007,$FFFE,$102,$00
	DC.W	$4407,$FFFE,$102,$11
	DC.W	$4807,$FFFE,$102,$11
	DC.W	$4C07,$FFFE,$102,$22
	DC.W	$5007,$FFFE,$102,$33
	DC.W	$5407,$FFFE,$102,$44
	DC.W	$5807,$FFFE,$102,$66
	DC.W	$5C07,$FFFE,$102,$66
	DC.W	$6007,$FFFE,$102,$77
	DC.W	$6407,$FFFE,$102,$77
	DC.W	$6807,$FFFE,$102,$77
	DC.W	$6C07,$FFFE,$102,$66
	DC.W	$7007,$FFFE,$102,$66
	DC.W	$7407,$FFFE,$102,$55
	DC.W	$7807,$FFFE,$102,$33
	DC.W	$7C07,$FFFE,$102,$22
	DC.W	$8007,$FFFE,$102,$11
	DC.W	$8407,$FFFE,$102,$11
	DC.W	$8807,$FFFE,$102,$00
	DC.W	$8C07,$FFFE,$102
LETZTERWERT:
	DC.W	$00

;	EFFEKT AUS Listing3h.s

	dc.w	$9007,$fffe		; warten auf Anfang der Zeile
	dc.w	$180,$000		; Grau auf Minimum, oder SCHWARZ!
CopBar:
	dc.w	$9031,$fffe		; Wait, das wir verändern ($9033,$9035,$9037..)
	dc.w	$180,$100		; Farbe Rot
	dc.w	$9107,$fffe		; Wait, das wir nicht verändern (Beginn Zeile)
	dc.w	$180,$111		; Farbe GRAU (Beginnt beim Anfang der Zeile und
	dc.w	$9131,$fffe		; geht bis zu diesem Wait, das wir nicht ändern
	dc.w	$180,$200		; danach beginnt das ROT

;	FIXE WAIT	(dann Grau)	- zu ändernde WAIT (gefolgt von Rot)

	dc.w	$9207,$fffe,$180,$120,$9231,$fffe,$180,$301 ; Zeile 3
	dc.w	$9307,$fffe,$180,$230,$9331,$fffe,$180,$401 ; Zeile 4
	dc.w	$9407,$fffe,$180,$240,$9431,$fffe,$180,$502 ; Zeile 5
	dc.w	$9507,$fffe,$180,$350,$9531,$fffe,$180,$603 ; ....
	dc.w	$9607,$fffe,$180,$360,$9631,$fffe,$180,$703
	dc.w	$9707,$fffe,$180,$470,$9731,$fffe,$180,$803
	dc.w	$9807,$fffe,$180,$580,$9831,$fffe,$180,$904
	dc.w	$9907,$fffe,$180,$690,$9931,$fffe,$180,$a04
	dc.w	$9a07,$fffe,$180,$7a0,$9a31,$fffe,$180,$b04
	dc.w	$9b07,$fffe,$180,$8b0,$9b31,$fffe,$180,$c05
	dc.w	$9c07,$fffe,$180,$9c0,$9c31,$fffe,$180,$d05
	dc.w	$9d07,$fffe,$180,$ad0,$9d31,$fffe,$180,$e05
	dc.w	$9e07,$fffe,$180,$be0,$9e31,$fffe,$180,$f05
	dc.w	$9f07,$fffe,$180,$cf0,$9f31,$fffe,$180,$e05
	dc.w	$a007,$fffe,$180,$be0,$a031,$fffe,$180,$d05
	dc.w	$a107,$fffe,$180,$ad0,$a131,$fffe,$180,$c05
	dc.w	$a207,$fffe,$180,$9c0,$a231,$fffe,$180,$b04
	dc.w	$a307,$fffe,$180,$8b0,$a331,$fffe,$180,$a04
	dc.w	$a407,$fffe,$180,$7a0,$a431,$fffe,$180,$904
	dc.w	$a507,$fffe,$180,$690,$a531,$fffe,$180,$803
	dc.w	$a607,$fffe,$180,$580,$a631,$fffe,$180,$703
	dc.w	$a707,$fffe,$180,$470,$a731,$fffe,$180,$603
	dc.w	$a807,$fffe,$180,$360,$a831,$fffe,$180,$502
	dc.w	$a907,$fffe,$180,$250,$a931,$fffe,$180,$402
	dc.w	$aa07,$fffe,$180,$140,$aa31,$fffe,$180,$301
	dc.w	$ab07,$fffe,$180,$130,$ab31,$fffe,$180,$202
	dc.w	$ac07,$fffe,$180,$120,$ac31,$fffe,$180,$103
	dc.w	$ad07,$fffe,$180,$111,$ad31,$fffe,$180,$004

	dc.w	$ae07,$fffe
	dc.w	$180,$002
	dc.w	$af07,$fffe
	dc.w	$180,$003

;	Zylinder-Spiegel-Effekt aus Listing3g.s (+neudefinition der Farben)

	dc.w	$0182,$235		; color1
	dc.w	$0184,$99e		; color2
	dc.w	$0186,$88c		; color3
	dc.w	$0188,$659		; color4
	dc.w	$018a,$122		; color5
	dc.w	$018c,$337		; color6
	dc.w	$018e,$224		; color7

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

	dc.w	$0182,$245		; color1
	dc.w	$0184,$9cf		; color2
	dc.w	$0186,$89c		; color3
	dc.w	$0188,$669		; color4
	dc.w	$018a,$132		; color5
	dc.w	$018c,$347		; color6
	dc.w	$018e,$234		; color7

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

	dc.w	$0182,$355		; color1
	dc.w	$0184,$abf		; color2
	dc.w	$0186,$9ac		; color3
	dc.w	$0188,$779		; color4
	dc.w	$018a,$232		; color5
	dc.w	$018c,$457		; color6
	dc.w	$018e,$344		; color7
	dc.w	$180,$00c		; Color0
	dc.w	$102,$055		; bplcon1
	dc.w	$108,-40*3		; Bpl1Mod - Spiegel halbiert
	dc.w	$10a,-40*3		; Bpl2Mod

	dc.w	$d007,$fffe

	dc.w	$180,$00e		; Color0
	dc.w	$102,$066		; bplcon1
	dc.w	$108,-40*2		; Bpl1Mod - Spiegel normal
	dc.w	$10a,-40*2		; Bpl2Mod

	dc.w	$d607,$fffe
	dc.w	$0182,$465		; color1
	dc.w	$0184,$cdf		; color2
	dc.w	$0186,$bbc		; color3
	dc.w	$0188,$889		; color4
	dc.w	$018a,$232		; color5
	dc.w	$018c,$557		; color6
	dc.w	$018e,$444		; color7

	dc.w	$180,$00f		; Color0
	dc.w	$102,$077		; bplcon1
	dc.w	$108,-40		; Bpl1Mod - FLOOD, Zeilen wiederholt, für
	dc.w	$10a,-40		; Bpl2Mod - Vergrößerungseffekt in der Mitte

	dc.w	$da07,$fffe

	dc.w	$0182,$355		; color1
	dc.w	$0184,$abf		; color2
	dc.w	$0186,$9ac		; color3
	dc.w	$0188,$779		; color4
	dc.w	$018a,$232		; color5
	dc.w	$018c,$457		; color6
	dc.w	$018e,$344		; color7
	dc.w	$180,$00e		; Color0
	dc.w	$102,$066		; bplcon1
	dc.w	$108,-40*2		; Bpl1Mod - Spiegel normal
	dc.w	$10a,-40*2		; Bpl2Mod

	dc.w	$e007,$fffe

	dc.w	$0182,$245		; color1
	dc.w	$0184,$9cf		; color2
	dc.w	$0186,$89c		; color3
	dc.w	$0188,$669		; color4
	dc.w	$018a,$132		; color5
	dc.w	$018c,$347		; color6
	dc.w	$018e,$234		; color7
	dc.w	$180,$00c		; Color0
	dc.w	$102,$055		; bplcon1
	dc.w	$108,-40*3		; Bpl1Mod - Spiegel halbiert
	dc.w	$10a,-40*3		; Bpl2Mod

	dc.w	$ed07,$fffe

	dc.w	$180,$00a		; Color0
	dc.w	$102,$044		; bplcon1
	dc.w	$108,-40*4		; Bpl1Mod - Spiegel 2 Mal halbiert
	dc.w	$10a,-40*4		; Bpl2Mod

	dc.w	$f507,$fffe

	dc.w	$0182,$235		; color1
	dc.w	$0184,$99e		; color2
	dc.w	$0186,$88c		; color3
	dc.w	$0188,$659		; color4
	dc.w	$018a,$122		; color5
	dc.w	$018c,$337		; color6
	dc.w	$018e,$224		; color7
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
	dc.w	$108,-40		; Stoppt das Bild um zu vermeiden, daß Bytes
	dc.w	$10a,-40		; vor dem RAW angezeigt werden

;	Effekt aus Listing3f.s

	dc.w	$ffdf,$fffe		; ACHTUNG! WAIT am Ende der Zeile $FF!
							; die Wait nach dieser Zeile befinden sich
							; unter $FF, starten aber bei $00!!

	dc.w	$0107,$FFFE		; ein fixer, grüner Balken unter der Zeile $FF!
	dc.w	$180,$010
	dc.w	$0207,$FFFE
	dc.w	$180,$020
	dc.w	$0307,$FFFE
	dc.w	$180,$030
	dc.w	$0407,$FFFE
	dc.w	$180,$040
	dc.w	$0507,$FFFE
	dc.w	$180,$030
	dc.w	$0607,$FFFE
	dc.w	$180,$020
	dc.w	$0707,$FFFE
	dc.w	$180,$010
	dc.w	$0807,$FFFE
	dc.w	$180,$000

BALKEN:
	dc.w	$0907,$FFFE		; Warte auf Zeile $79
	dc.w	$180,$300		; Beginne die rote Zeile: Rot auf 3
	dc.w	$0a07,$FFFE		; nächste Zeile
	dc.w	$180,$600		; Rot auf 6
	dc.w	$0b07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$0c07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$0d07,$FFFE
	dc.w	$180,$f00		; Rot auf 15 (Maximum)
	dc.w	$0e07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$0f07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$1007,$FFFE
	dc.w	$180,$600		; Rot auf 6
	dc.w	$1107,$FFFE
	dc.w	$180,$300		; Rot auf 3
	dc.w	$1207,$FFFE
	dc.w	$180,$000		; Farbe Schwarz

	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST


; **************************************************************************
; *			BILD IN 8 FARBEN 320x256			   *
; **************************************************************************

	dcb.b	40*98,0			; leergefegter Raum

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	dcb.b	40*8,0			; wie oben

; **************************************************************************
; *				PROTRACKER-MUSIK			   *
; **************************************************************************

mt_data:
	;incbin	"/Sources/mod.purple-shades"
	incbin	"/Sources/mod.yellowcandy"

	end

; **************************************************************************
Dieses Listing ist nichts  anderes  als  ein  Zusammenschluß  von  einigen
Listings,  wie  ihr  gesehen habt. Die Unterschiede sind zwei:

1) Ich habe den Welleneffekt von 45 Wait auf 20 verkürzen  müßen,  um  ihn
zwischen  die  anderen  Effekte  zu  bekommen. 

2) Ich habe die Palette des Bildes oben verändert, so daß es aussieht, als
ob das Bild in die ScrollColors eintreten würde. Weiters habe ich hier und
da die Farben verändert, um die SUPERCOPPERLIST zu verschönern und ...  zu
verlängern!!

Die wirkliche Neuigkeit ist das Einfügen einer Musikroutine! Zuerst einmal
folgendes: ich habe das Einbinden dieser Routine mit "INCLUDE" dem  wahren
"Einsetzen" (abtippen, reinkopieren) vorgezogen. Dieses Include erlaubt es
mir, außenstehende Listings praktisch einzufügen. Schauen wir nun, wie wir
unsere Wunder noch mit einem bißchen Musik auf die Sprünge helfen können.
Als erstes ist zu beachten, daß das Musikstück in einem speziellen  Format
vorliegen  muß, dem PROTRACKER-Format. Und nicht etwa digitalisierte Musik
etc. Es gibt viele Programme, mit denen man Musik komponieren kann, das am
meisten  verwendete  ist  der  Protracker, kompatibel mit Soundtracker und
Noisetracker. Sie speichern das  Stück  im  MOD-Format  ab,  oft  beginnen
solche  Musikstücke auch mit dem Kürzel MOD. Es ist aber nicht gesagt, daß
unbedingt immer Protracker verwendet wurde: bei einigen Spielen, vor allem
älteren,   wurden   oft   MED,   OCTAMED,  FUTURE-COMPOSER,  SOUNDMONITOR,
OKTALYZER..., verwendet, aber in diesen Fällen muß eine eigene Routine für
diese  Formate  das Abspielen übernehmen. Meistens erhält man zusammen mit
dem Programm auch die REPLAY-Routine, die im Programm eingebaut werden
kann.
Heutzutage verwenden 99%  der  Amiga-Produktionen  Protracker-Format  oder
deren Untersorten, also einem Format, das nach eigenen Regeln und Gesetzen
die "Noten" speichert und komprimiert.
Ich habe diesem Kurs diese Routine mitgegeben, die  Protracker  problemlos
spielt, sie ist kompatibel zu Soundtracker und Noisetracker. Des  weiteren
habe  ich  sie modifiziert, daß sie kompatibel zu 68020+ Prozessoren, auch
mit  eingeschalteter   Cache,   ist.   Im   Orginalzustand   hatte   diese
ReplayRoutine  einige  Probleme  bei schnelleren Prozessoren und so verlor
sie manchmal einige Noten... Aber  jetzt  singt  die  "music.s"  auch  auf
A4000ern ohne Schwierigkeiten.
Um sie einzufügen, könnt ihr entweder den "I"-Befehl verwenden,  oder  sie
in  einen  anderen  Buffer  laden  und  dann  ins  Listing  kopieren.  Ich
persönlich ziehe es aber vor, Platz zu sparen, deswegen verwende  ich  die
"Include"-Direktive des ASMONE. Somit wird das Listing assembliert, als ob
die Routine wirklich händisch eingebaut worden wäre, nur  sparen  wir  uns
die  Länge  dieser  Routine  selbst,  ca  21 kB. Stellt euch z.B. vor, ihr
hättet sieben Listings, denen ihr allen diese Routine unterjubeln wollt:

	Listing1.s	12234 bytes
	Listing2.s	23523 bytes
	Listing3.s	29382 bytes
	Listing4.s	78343 bytes
	Listing5.s	10482 bytes
	Listing6.s	14925 bytes
	Listing7.s	29482 bytes

Zusammen sind  sie  ca.  200k  groß,  nachdem  wir  aber  jeden  21kB  der
Replay-Routine  dazugezählt haben, würden sie insgesamt 300kB verbrauchen!
Aber wenn ich nur die Zeile

	include "music.s"

schreibe,  dann  ist  die Vergrößerung des Listings nur ein paar Byte, das
Resultat aber das gleiche. Der einzige Schwachpunkt ist, daß man sich, wie
beim  INCBIN,  in  der  selben  Directory befinden muß, wo sich auch diese
Routine befindet. Ansonsten muß man den vollständigen Pfad schreiben:

	include "df0:sorgenti2/music.s"

Einmal  eingefügt,  sei  es  nun  mit  dem  Include  oder mittels direktem
Einfügen von Hand, braucht man sie nur  mehr  zum  Funktionieren  bringen.
GANZ  EINFACH!  Nur  mt_init  vor  dem Mouse-Loop aufrufen, damit wird sie
initialisiert, dann "mt_music" bei JEDEM FRAME ausführen, und dann  mt_end
am  Ende  vor  dem Aussteigen aufrufen. Damit wird die Routine beendet und
sie gibt die Audio-Kanäle wieder frei.

	bsr.w	mt_init			; Inizialisiert Musik-Routine

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	bsr.w	MeineGrafikRoutine
	bsr.w	mt_music		; Spielt die Musik
 
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	bsr.s	mt_end			; Beendet die Musikroutine
 
Das Musikstück muß natürlich geladen werden, einfach mit dem INCBIN unter
dem Label "mt_data":

mt_data:
	incbin	"mod.purple-shades"

Die im Kurs enthaltene Musik ist von HI-LITE der VISION FACTORY, ein
Stück, das schon  einige Jahre auf dem Buckel hat, ich habe sie gewählt,
weil sie nur 13 kB lang ist. Wenn ihr etwas Eigenes spielen lassen wollt,
dann einfach mit dem Incbin reinholen:

mt_data:
	incbin	"df1:modules/mod.MyMusic"	; zum Beispiel!

