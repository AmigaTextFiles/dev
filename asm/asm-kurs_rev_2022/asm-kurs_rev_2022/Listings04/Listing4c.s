
; Listing4c.s	ZUSAMMENSCHLUß VON 3 COPPEREFFEKTEN + BILD IN 8 FARBEN

 SECTION CIPundCOP,CODE		; auch Fast ist  OK

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary, öffnet Bibliothek
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach
							; GfxBase)

;******************************************************************************
;HIER LASSEN WIR UNSERE BPLPOINTS IN DER COPPELIST UNSERE BITPLANES ANPOINTEN 
;******************************************************************************

	MOVE.L	#PIC,d0			; in d0 kommt die Adresse von unserer PIC
							; bzw. wo ihre erste Bitplane beginnt

	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)		; kopiert das niederwertige Word der Plane-
							; Adresse ins richtige Word der Copperlist
	swap	d0				; vertauscht die 2 Word in d0 ( 1234 > 3412)

	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0
							; damit wird die orginale Adresse wieder hergestellt
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, somit zeigen wir
							; auf das zweite Bitplane (befindet sich direkt
							; nach dem ersten), wir zählen praktisch die Länge
							; eines Plane dazu
							; In den nächsten Durchgängen werden wir dann auf
							; die dritte, vierte... Bitplane zeigen

	addq.w	#8,a1			; a1 enthält nun die Adresse der nächsten
							; bplpointers in der  Copperlist, die es
							; einzutragen gilt
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1=num of bitpls)


	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP

	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	bsr.w	BewegeCopper	; Roter Balken unter Zeile $ff
	bsr.w	CopperLinkRech	; Routine für Links/Rechts-Scroll
	BSR.w	scrollcolors	; Zyklisches Fließen der Farben

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir noch auf Zeile 255?
	beq.s	Warte			; Wenn ja, geh nicht weiter, warte auf die
							; nächste Zeile, ansonsten wird BewegeCopper
							; noch einmal ausgeführt

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

GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht

	
OldCop:		    ; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0   ; Betriebssystemes


; **************************************************************************
; *		BALKEN MIT HORIZONTALEM SCROLL  (LISTING3h.s)		   *
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
							; Links-Zyklus ist fertig. Wir löschen die
							; zwei Falgs und steigen aus: beim nächsten
							; FRAME wird GehRechts ausgeführt,nach 85 Frame
							; GehLinks 85 Mal, etcetera.
	RTS						; ZURÜCK ZUM MOUSE-LOOP

GehRechts:					; Diese Routine bewegt den Balken nach RECHTS
	lea	CopBar+1,A0			; Wir geben in A0 die Adresse des ersten XX-
							; Wertes des ersten Wait, das sich genau 1 Byte
							; nach CopBar befindet

	move.w	#29-1,D2		 ; wir müßen 29 Wait verändern (verwenden ein DBRA)
RechtsLoop:
	addq.b	#2,(a0)			; zählen 2 zu der X-Koordinate des Wait dazu
	ADD.W	#16,a0			; gehen zum nächsten Wait, das zu ändern ist
	dbra	D2,RechtsLoop	; Zyklus wird d2-Mal durchlaufen
	addq.w	#1,FlagRechts   ; vermerken,daß wir ein weiteres Mal GehRechts 
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
	dbra	D2,LinksLoop	; Zyklus wird d2-Mal durchgeführt
	addq.w	#1,FlagLinks	; Zählen 1 zur Anzahl dazu, wie oft diese Routine
							; GehLinks ausgeführt wurde
	RTS						; Zurück zum Mouse-Loop

FlagRechts:		; In diesem Word wird die Anzahl festgehalten,
	dc.w	0	; wie oft  GehRechts ausgeführt wurde

FlagLinks:		; In diesem Word wird die Anzahl festgehalten,
	dc.w	0	; wie oft  GehLinks ausgeführt wurde


; **************************************************************************
; *		ROTER BALKEN UNTER ZEILE $FF  (Listing3f.s)		   *
; **************************************************************************

BewegeCopper:
	LEA	BALKEN,a0			; in a0 kommt die Adresse von Balken
	TST.B	RAUFRUNTER		; oben angekommen?
	beq.w	GEHRUNTER

	cmpi.b	#$0a,(a0)		; sind wir bei Zeile $0a+$ff angekommen?
	beq.s	SetzRunter		; wenn ja, sind wir oben angekommen und
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
	

SetzRunter:
	clr.b	RAUFRUNTER		; Setzt RAUFRUNTER auf 0, beim TST.B RAUFRUNTER
	rts						; wird das BEQ zu Routine GEHRUNTER verzweigen,
							; und der Balken wird sinken
				
GEHRUNTER:
	cmpi.b	#$2c,8*9(a0)	; sind wir bei Zeile $2c angekommen?
	beq.s	SetzRauf		; wenn ja, sind wir untern und müßen wieder
	addq.b	#1,(a0)	 		; steigen
	addq.b	#1,8(a0)
	addq.b	#1,8*2(a0)		; nun ändern wir die anderen Wait: der
	addq.b	#1,8*3(a0)		; Abstand zwischen einem und dem anderen beträgt
	addq.b	#1,8*4(a0)		; 8 Byte
	addq.b	#1,8*5(a0)
	addq.b	#1,8*6(a0)
	addq.b	#1,8*7(a0)      ; hier müßen wir alle 9 Wait des roten Balken
	addq.b	#1,8*8(a0)		; ändern, wenn wir ihn steigen und sinken lassen
	addq.b	#1,8*9(a0)		; wollen.
	rts

SetzRauf:
	move.b	#$ff,RAUFRUNTER ; Wenn das Label nicht auf NULL ist,
	rts						; bedeutet es, daß wir steigen müßen

RAUFRUNTER:
	dc.b	0,0

; **************************************************************************
; *		ZYKLISCHES FLIEßEN DER FARBEN (Listing3e.s)		   *
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
; *				SUPER COPPERLIST			   *
; **************************************************************************

	SECTION GRAPHIC,DATA_C

COPPERLIST:

	; Wir lassen die Sprites auf 0 pointen, ansonsten gasen sie nur
	; wie verrückt herum und stören!!

	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000
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

; Das BPLCON0 für einen Bildschirm mit 3 Bitplanes: (8 Farben)

			    ; 5432109876543210
	dc.w	$100,%0011001000000000  ; Bts 13 und 12 an!! (3 = %011)


;	Wir lassen die Bitplanes direkt anpointen, indem wir die Register
;	$dff0e0 und folgende hier in der Copperlist einfügen. Die
;	Adressen der Bitplanes werden dann von der Routine POINTBP
;	automatisch eingetragen


BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; bitplane 1 - BPL0PT
	dc.w	$e4,$0000,$e6,$0000	; bitplane 2 - BPL1PT
	dc.w	$e8,$0000,$ea,$0000	; bitplane 3 - BPL2PT

;	Der Effekt von Listing3e.s, nur weiter HINAUF versetzt

	dc.w	$3a07,$fffe		; warten auf Zeile 154 ($9a in Hexadezimal)
	dc.w	$180			; REGISTER COLOR0
col1:
	dc.w	$0f0			; Wert von COLOR 0 (das verändert wird)
	dc.w	$3b07,$fffe		; warten auf Zeile 155 (wird nicht verändert)
	dc.w	$180			; REGISTER COLOR0 (wird nicht verändert)
col2:
	dc.w	$0d0			; Wert von COLOR 0 (wird verändert)
	dc.w	$3c07,$fffe		; warten auf Zeile 156 (wird nicht verändert,ecc.)
	dc.w	$180			 ; REGISTER COLOR0
col3:
	dc.w	$0b0			; Wert von COLOR 0
	dc.w	$3d07,$fffe		; warten auf Zeile 157
	dc.w	$180			; REGISTER COLOR0
col4:
	dc.w	$090			; Wert von COLOR 0
	dc.w	$3e07,$fffe		; warten auf Zeile 158
	dc.w	$180			; REGISTER COLOR0
col5:
	dc.w	$070			; Wert von COLOR 0
	dc.w	$3f07,$fffe		; warten auf Zeile 159
	dc.w	$180			; REGISTER COLOR0
col6:
	dc.w	$050			; Wert von COLOR 0
	dc.w	$4007,$fffe		; warten auf Zeile 160
	dc.w	$180			; REGISTER COLOR0
col7:
	dc.w	$030			; Wert von COLOR 0
	dc.w	$4107,$fffe		; warten auf Zeile 161
	dc.w	$180			; color0... (nun habt ihr schon verstanden,
col8:						; ab hier gebe ich keinen Kommentar mehr!)
	dc.w	$030
	dc.w	$4207,$fffe		; Zeile 162
	dc.w	$180
col9:
	dc.w	$050
	dc.w	$4307,$fffe		;  Zeile 163
	dc.w	$180
col10:
	dc.w	$070
	dc.w	$4407,$fffe		;  Zeile 164
	dc.w	$180
col11:
	dc.w	$090
	dc.w	$4507,$fffe		;  Zeile 165
	dc.w	$180
col12:
	dc.w	$0b0
	dc.w	$4607,$fffe		;  Zeile 166
	dc.w	$180
col13:
	dc.w	$0d0
	dc.w	$4707,$fffe		;  Zeile 167
	dc.w	$180
col14:
	dc.w	$0f0
	dc.w	$4807,$fffe		;  Zeile 168


	dc.w	$180,$0000		; Wir beschließen, den Bildschirm unter
							; dem Effekt Schwarz zu färben

	dc.w	$0180,$000		; color0
	dc.w	$0182,$550		; color1	; wir verändern die Farbe der
	dc.w	$0184,$ff0		; color2	; COMMODORE-Schrift! GELB!
	dc.w	$0186,$cc0		; color3
	dc.w	$0188,$990		; color4
	dc.w	$018a,$220		; color5
	dc.w	$018c,$770		; color6
	dc.w	$018e,$440		; color7

	dc.w	$7007,$fffe		; Wir warten das Ende des COMMODORE-
							; Schriftzuges ab

;	Die 8 Farben des Bildes sind hier definiert:

	dc.w	$0180,$000		; Color0
	dc.w	$0182,$475		; Color1
	dc.w	$0184,$fff		; Color2
	dc.w	$0186,$ccc		; Color3
	dc.w	$0188,$999		; Color4
	dc.w	$018a,$232		; Color5
	dc.w	$018c,$777		; Color6
	dc.w	$018e,$444		; Color7

;	Effekt aus Listing3h.s

	dc.w	$9007,$fffe		; Warten auf den Beginn der Zeile
	dc.w	$180,$000		; Grau auf Minimum, also SCHWARZ!
CopBar:
	dc.w	$9031,$fffe		; Wait, das geändert wird ($9033,$9035,$9037...)
	dc.w	$180,$100		; Farbe Rot, die immer weiter rechts beginnen
							; wird, vorangegangen vom Grau, das dementsprechend
							; fortschreiten wird
	dc.w	$9107,$fffe		; Wait, das nicht geändert wird (Beginn der Zeile)
	dc.w	$180,$111		; Farbe GRAU (startet beim Beginn der Zeile bis
	dc.w	$9131,$fffe		; zu diesem WAIT, das wir nicht ändern werden...
	dc.w	$180,$200		; danach beginnt das ROT

;		FIXE WAIT (dann Grau)-VERÄNDERB. WAIT (gefolgt vom Rot)

	dc.w	$9207,$fffe,$180,$222,$9231,$fffe,$180,$300 ; Zeile 3
	dc.w	$9307,$fffe,$180,$333,$9331,$fffe,$180,$400 ; Zeile 4
	dc.w	$9407,$fffe,$180,$444,$9431,$fffe,$180,$500 ; Zeile 5
	dc.w	$9507,$fffe,$180,$555,$9531,$fffe,$180,$600 ; ....
	dc.w	$9607,$fffe,$180,$666,$9631,$fffe,$180,$700
	dc.w	$9707,$fffe,$180,$777,$9731,$fffe,$180,$800
	dc.w	$9807,$fffe,$180,$888,$9831,$fffe,$180,$900
	dc.w	$9907,$fffe,$180,$999,$9931,$fffe,$180,$a00
	dc.w	$9a07,$fffe,$180,$aaa,$9a31,$fffe,$180,$b00
	dc.w	$9b07,$fffe,$180,$bbb,$9b31,$fffe,$180,$c00
	dc.w	$9c07,$fffe,$180,$ccc,$9c31,$fffe,$180,$d00
	dc.w	$9d07,$fffe,$180,$ddd,$9d31,$fffe,$180,$e00
	dc.w	$9e07,$fffe,$180,$eee,$9e31,$fffe,$180,$f00
	dc.w	$9f07,$fffe,$180,$fff,$9f31,$fffe,$180,$e00
	dc.w	$a007,$fffe,$180,$eee,$a031,$fffe,$180,$d00
	dc.w	$a107,$fffe,$180,$ddd,$a131,$fffe,$180,$c00
	dc.w	$a207,$fffe,$180,$ccc,$a231,$fffe,$180,$b00
	dc.w	$a307,$fffe,$180,$bbb,$a331,$fffe,$180,$a00
	dc.w	$a407,$fffe,$180,$aaa,$a431,$fffe,$180,$900
	dc.w	$a507,$fffe,$180,$999,$a531,$fffe,$180,$800
	dc.w	$a607,$fffe,$180,$888,$a631,$fffe,$180,$700
	dc.w	$a707,$fffe,$180,$777,$a731,$fffe,$180,$600
	dc.w	$a807,$fffe,$180,$666,$a831,$fffe,$180,$500
	dc.w	$a907,$fffe,$180,$555,$a931,$fffe,$180,$400
	dc.w	$aa07,$fffe,$180,$444,$aa31,$fffe,$180,$301
	dc.w	$ab07,$fffe,$180,$333,$ab31,$fffe,$180,$202
	dc.w	$ac07,$fffe,$180,$222,$ac31,$fffe,$180,$103
	dc.w	$ad07,$fffe,$180,$113,$ad31,$fffe,$180,$004

	dc.w	$ae07,$FFFE		; nächste Zeile
	dc.w	$180,$006		; Blau auf 6
	dc.w	$b007,$FFFE		; überspringe 2 Zeilen
	dc.w	$180,$007		; Blau auf 7
	dc.w	$b207,$FFFE		; überspringe 2 Zeilen
	dc.w	$180,$008		; Blau auf 8
	dc.w	$b507,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$009		; Blau auf 9
	dc.w	$b807,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$00a		; Blau auf 10
	dc.w	$bb07,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$00b		; Blau auf 11
	dc.w	$be07,$FFFE		; überspringe 3 Zeilen
	dc.w	$180,$00c		; Blau auf 12
	dc.w	$c207,$FFFE		; überspringe 4 Zeilen
	dc.w	$180,$00d		; Blau auf 13
	dc.w	$c707,$FFFE		; überspringe 7 Zeilen
	dc.w	$180,$00e		; Blau auf 14
	dc.w	$ce07,$FFFE		; überspringe 6 Zeilen
	dc.w	$180,$00f		; Blau auf 15
	dc.w	$d807,$FFFE		; überspringe 10 Zeilen
	dc.w	$180,$11F		; helle auf...
	dc.w	$e807,$FFFE		; überspringe 16 Zeilen
	dc.w	$180,$22F		; helle auf...

;	Effekt von Listing3f.s

	dc.w	$ffdf,$fffe		; ACHTUNG! WAIT AM ENDE DER ZEILE FF!
							; die folgenden Wait sind unter der Zeile
							; $FF und starten wieder bei $00!!

	dc.w	$0107,$FFFE		; Ein fixer, grüner Balken UNTER der Zeile $FF!
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
	dc.w	$180,$300		; Beginne roten Balken: Rot auf 3
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
	dc.w	$180,$000		; Farbe SCHWARZ

	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST


; **************************************************************************
; *			BILD IN 8 FARBEN  320x256			   *
; **************************************************************************

;	Erinnert euch, die Directory auszuwählen, in der das Bild zu
;	finden ist, in diesem Fall: "V df0:LISTINGS2"

PIC:
	incbin  "/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild imRAW
							; Format, das zuvor mit dem
							; KEFCON konvertiert wurde, es
							; besteht aus drei Bitplanes
							; nacheinander

	end


In diesem Beispiel gibt´s nichts Neues, aber wir haben viele der bis jetzt
kennengelernten  Effekte  vereint:  Listing3h.s, Listing3f.s, Listing3e.s.
Und das einfach dadurch, daß wir die einzelnen Routinen in  einen  anderen
Buffer geladen haben, rauskopiert und hier eingesetzt. Dann noch das Stück
Copperlist  dazu  und  alles  ist  getan.  Die  Routinen  werden   einfach
nacheinander  aufgerufen,  aber bei der Copperlist ist eine ganz bestimmte
Ordnung einzuhalten, ansonsten überlappen sich die einzelnen  Effekte.  So
mußte ich zum Beispiel den Effekt aus Listing3f.s weiter hinauf versetzen,
während  ich  die  anderen  zwei  lassen  konnte,  wo  sie waren.  Im
synchronisiertem Loop braucht man dann nur noch die Routinen aufzurufen:

	bsr.w	BewegeCopper	; Roter Balken unter Zeile $ff
	bsr.w	CopperLinkRech	; Routine für Links/Rechts-Scroll
	BSR.w	scrollcolors	; Zyklisches Fließen der Farben

Es  kommt  oft vor, daß die Routinen einzeln programmiert werden, und erst
später zusammengefügt werden, wie in diesem Beispiel. Es ist von  Vorteil,
wenn man lernt, Grafikdemos zu zerlegen und wieder zusammenzustellen, denn
ein guter Teil der Programmierung  besteht  aus  solcher  Tätigkeit.  Jede
Routine  kann  dann  in anderen Listings wiederwerwendet werden, indem man
einfache Änderungen anbringt: so wird der  Programmierer  von  TEAM17  für
jedes  seiner  Spiele  die  gleiche  Joystick-Routine verwendet haben, das
Gleiche  gilt  für  die  Routine,  die  von  Diskette	ladet,	und	der
Programmteil,  der  die  Figuren  am Screen bewegt, wird auch jedesmal nur
mehr oder weniger verändert und abgeleitet werden. Jede Routine,  die  ihr
auscodiert  oder  irgendwo  findet kann euch oft nützlich sein, sei es nun
als Beispiel oder daß ihr sie richtig in eure Programme einbaut. Wenn  ihr
alle  nötigen  für  ein  Spiel  separat  beiseite  habt, z.B. Diskladen.s,
Joystick.s, Spielemusik.s, ... , dann wird  sich  das  Spieleprogrammieren
auf  das  zusammenkopieren beschränken. Es würde den Aufdecken des Tischen
gleichen: Messer, Gabel, Teller, Serviette, alles kommt an  seinen  Platz.
Ihr  müßt  nur  mehr  ein Puzzle zusammenstellen, aber auch das setzt eine
Mindestkompetenz in der Programmierung voraus. Manchmal kommt es vor,  daß
bei  Demos oder Spielen alles passt, aber man den Verdacht nicht los wird,
daß die Routinen nicht selbst geschrieben wurden, sondern entweder kopiert
oder  hergegeben  wurden. Aber wenn das Spiel funktioniert, wen kratzt´s ?
Es wird immer ein schönes Spiel sein, aber ähnlich mit einem anderen, eine
Art  Kreuzung.  Wenn jemand aber eine Routine selbst ausprogrammiert, dann
erkennt man  das  sofort,  entweder  weil  sie  besser  gemacht  ist  oder
schlechter.  Also  sind  die besten und die schlechtesten Spiele "ehrlich"
programmiert. Aber laßt im Moment die Ehre beiseite, ihr lernt  noch,  und
ich	glaube	nicht,	daß	ihr	jetzt	schon	bereit	seid,	die
Amiga-Programmierung zu erneuern!  Also demontiert und schweißt  zusammen,
was  euch  der  Kurs  bietet,  denn  es  gibt  nichts  besseres,  als das.
Hauptsache, ihr geht dann nicht mit MEINEN Routinen rum und  erzählt,  daß
ihr  sie  ganz  alleine codiert habt. Wenn ihr den Kurs beendet habt, dann
könnt ihr eure eigenen erstellen, und, wer weiß, einige gute Erleuchtungen
haben, und die innovativen Ideen umsetzen. Assembler setzt keine Grenzen.


