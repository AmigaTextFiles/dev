
; Listing4b.s	ANZEIGEN EINES BILDES IN 320*256 mit 3 Planes (8 Farben)

 SECTION CIPundCOP,CODE		; auch Fast ist  OK

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6) 			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary, Routine der EXEC, die Libraris
							; öffnet, und als Resultat in d0 die Basisadr.
							; derselben Bibliothek liefert, ab welcher
							; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach GfxBase)

;******************************************************************************
;HIER LASSEN WIR UNSERE BPLPOINTERS IN DER COPPELIST UNSERE BITPLANES ANPOINTEN
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
	swap	d0				; vertauscht die 2 Word in d0 (Z.B.: 1234 > 3412)
							; dadurch kommt das hochwertige Word an die
							; Stelle des niederwertigen, wodurch das
							; kopieren mit dem Move.w ermöglicht wird!!
	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0 (3412 > 1234)
							; damit wird die orginale Adresse wieder hergestellt
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, somit zeigen wir
							; auf das zweite Bitplane (befindet sich direkt
							; nach dem ersten), wir zählen praktisch die Länge
							; eines Plane dazu
							; In den nächsten Durchgängen werden wir dann auf die
							; dritte, vierte... Bitplane zeigen

	addq.w	#8,a1			; a1 enthält nun die Adresse der nächsten
							; bplpointers in der	Copperlist, die es
							; einzutragen gilt
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1=num of bitplanes)


	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP

	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:	
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080 	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts

GfxName:
	dc.b	"graphics.library",0,0	

GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht



OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0	; des Betriebssystemes


	SECTION GRAPHIC,DATA_C

COPPERLIST:

	; Die Sprites lassen wir auf NULL zeigen, also pointen, um sie zu 
	; eliminieren ansonsten geistern sie umher uns stören uns nur!!!

	;dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000
	;dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	;dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	;dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	Register mit Standartwerten
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
	dc.w	$e0,$0000,$e2,$0000	; erste	Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT

;	Die 8 Farben des Bildes werden hier definiert:

	dc.w	$0180,$000		; color0
	dc.w	$0182,$475		; color1
	dc.w	$0184,$fff		; color2
	dc.w	$0186,$ccc		; color3
	dc.w	$0188,$999		; color4
	dc.w	$018a,$232		; color5
	dc.w	$018c,$777		; color6
	dc.w	$018e,$444		; color7
	;	Fügt hier eventuelle WAIT-Effekte ein:

	dc.w	$a907,$FFFE		; warte auf Zeile $a9
	dc.w	$180,$001		; sehr dunkles Blau
	dc.w	$aa07,$FFFE		; Zeile $aa
	dc.w	$180,$002		; ein bißchen helleres Blau
	dc.w	$ab07,$FFFE		; Zeile $ab
	dc.w	$180,$003		; ein bißchen helleres Blau
	dc.w	$ac07,$FFFE		; nächste Zeile
	dc.w	$180,$004		; ein bißchen helleres Blau
	dc.w	$ad07,$FFFE		; nächste Zeile
	dc.w	$180,$005		; ein bißchen helleres Blau
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
	dc.w	$ffdf,$FFFE		; ENDE DER NTSC-ZONE (Zeile $FF)
	dc.w	$180,$33F		; helle auf...
	dc.w	$2007,$FFFE		; Zeile $20+$FF = Zeile $1ff (287)
	dc.w	$180,$44F		; helle auf...
;------------------------------------

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


;	Erinnert euch, die Directory auszuwählen, in der das Bild zu
;	finden ist, in diesem Fall: "V df0:LISTINGS2"


PIC:
	incbin  "/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW
							; Format, das zuvor mit dem
							; KEFCON konvertiert wurde, es
							; besteht aus drei Bitplanes
							; nacheinander	
	end


Wie  ihr  gesehen  habt,  kommen  in diesem Listing keine synchronisierten
Routinen  vor,  nur  Routinen,  die  die  Bitplanes  und  dir	Copperlist
anpointen.  Als  erstes  versucht  mal,  die  Sprite-Pointer  mit  ";"  zu
eliminieren:

;	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000
;	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
;	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
;	dc.w	$13e,$0000

Nun  werden  beim  Anzeigen  des  Bildes  manchmal  recht  flotte Streifen
vorbeiziehen, das sind die entfesselten Sprites, die wild herumgasen.  Wir
werden später lernen, sie zu zähmen.

Probiert  nun, vor dem Ende der Copperlist einige Wait einzufügen, und ihr
werdet merken, wie bequem die Wait+Color sind, um HORIZONTALE FARBVERLÄUFE
einzufügen,  oder Farbe zu wechseln. Und das alles GRATIS, d.h. einem Bild
mit 8 Farben wie diesem können wir einen  Hintergrund  mit  hunderten  von
Farben  verleihen,  oder  auch  die  Farben  selbst  ändern,  aus denen es
besteht, wie etwa $182, $184, $186, $188, $18a, $18c, $18e!

Als  erste	"Verschönerung"	fügt	diesen	vorgefertigten	Teil	mit
Farbverläufen  vor  das  Ende  der  Copperlist ein ($FFFF,$FFFE): Erinnert
euch, daß ein Bock mit Amiga+b  ausgewählt  wird,  mit  Amiga+c  in  einen
Textbuffer  kopiert,  und,  nachdem  ihr  den  Cursor  auf  die gewünschte
Position gebracht habt, mit Amiga+i in den Text selbst hineinkopiert.

	dc.w	$a907,$FFFE		; warte auf Zeile $a9
	dc.w	$180,$001		; sehr dunkles Blau
	dc.w	$aa07,$FFFE		; Zeile $aa
	dc.w	$180,$002		; ein bißchen helleres Blau
	dc.w	$ab07,$FFFE		; Zeile $ab
	dc.w	$180,$003		; ein bißchen helleres Blau
	dc.w	$ac07,$FFFE		; nächste Zeile
	dc.w	$180,$004		; ein bißchen helleres Blau
	dc.w	$ad07,$FFFE		; nächste Zeile
	dc.w	$180,$005		; ein bißchen helleres Blau
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
	dc.w	$ffdf,$FFFE		; ENDE DER NTSC-ZONE (Zeile $FF)
	dc.w	$180,$33F		; helle auf...
	dc.w	$2007,$FFFE		; Zeile $20+$FF = Zeile $1ff (287)
	dc.w	$180,$44F		; helle auf...


Wir  haben  aus  dem  Nichts,  ohne   gegenproduktiven  Effekten,  einen
Farbverlauf  erzeugt, der die Gesamtzahl der Farben am Schirm von 8 auf 27
erhöht hat!!!! Wir fügen weitere 7 Farben hinzu, aber diesmal  ändern  wir
nicht  den Hintergrund, $dff180, sondern sie anderen 7 Farben: Fügt dieses
Stück Copper zwischen den Bitplane-Pointern und den  anderen  Farben  ein:
(die andere Modifizierung könnt ihr ruhig bestehen lassen)

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

Mit  45  "dc.w",  die wir der Copperlist noch untergejubelt, haben wir ein
harmloses 8-Farben-Picture in eine Picture mit 34 Farben  verwandelt,  und
somit auch das Limit der 32 Farben der 5-Bitplane-Bilder überschritten!!!

Nur  durch  Programmierung der Copperlist in Assembler kann man die Grafik
des Amiga vollständig nutzen: nun könntet  ihr  ein  Bild  in  320  Farben
erstellen,  einfach  durch  zehnmaliges ändern der Palette eines 32-Farben
Bildes, indem ihr ca. alle 25 Zeilen  ein  Wait+Palette  einfügt...  Jetzt
geht  eucht  vielleicht  ein  Licht auf, wieso gewisse Spiele 64, 128 oder
mehr Farben haben!! Sie haben ziemlich lange Copperlists, die  die  Farben
auf verschiedenen Höhen am Bildschirm ändern!

Bringt  ein  paar  Änderungen  an,  das  tut immer gut, oder versucht, die
Balken aus Lektion3 in den  Hintergrund  zu  bekommen.  Einfach  in  einen
anderen  Textbuffer laden, Routine ausschneiden und einfügen. Wenn ihr das
schafft, seid ihr auf Zack.


