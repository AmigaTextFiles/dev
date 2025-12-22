
; Listing5a.s	SCROLLEN EINES BILDES NACH LINKS UND RECHTS MIT DEM $dff102

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary, Routine der EXEC, die Libraris
							; öffnet, und als Resultat in d0 die Basisadr.
							; derselben Bibliothek liefert, ab welcher
							; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach
							; GfxBase)

;	POINTEN AUF UNSERE BITPLANES
 
	MOVE.L	#PIC,d0			; in d0 kommt die Adresse von unserer PIC
							; bzw. wo ihr erstes Bitplane beginnt

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
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, somit zeigen wir
							; auf das zweite Bitplane (befindet sich direkt
							; nach dem ersten),wir zählen praktisch Länge
							; eines Plane dazu

	addq.w	#8,a1			; a1 enthält nun die Adresse der nächsten
							; Bplpointers in der  Copperlist, die es
							; einzutragen gilt
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1= bitplanes)


	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP

	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; dann wird die Scrollroutine übersprungen
 
	bsr.w	BewegeCopper	; Scrollt Bild hin und her

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



OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0	; des Betriebssystemes


;	Diese Routine ist sehr ähnlich mit der in Listing3d.s, in diesem
;	Fall aber modifizieren wir den Wert in $dff102 BPLCON1, um das
;	Bild vor- und zurückzubewegen.
;	Da es möglich ist, auf die geraden und ungeraden Bitplanes
;	unabhängig zuzugreifen, müßen wir beide gleichzeitig verschieben:
;	$0011, $0022, $0033, und nicht $0001, $0002, $0003, das nur die
;	ungeraden Bitplanes (1,3,5) verschieben würde, oder $0010, $0020, 
;	$0030; dieses hätte nur auf die geraden Planes (2,4,6) Einfluß.
;	Probiert ein "=C 102" um zu sehen, was die einzelnen Bits bedeuten.


BewegeCopper:
	TST.B	FLAG			; Müßen wir vor oder zurück? Wenn FLAG NULL
							; ist (TST also BEQ ergibt), dann springen wir
							; nach Vorne, wenn es hingegen auf $FF ist,
							; (TST also nicht BEQ ergibt), dann fahren wir
							; mit dem zurückgehen fort (mit den sub)
	beq.w	Vorne
	cmpi.b	#$00,MeinCon1	; sind wir auf der Standartposition angekommen,
							; also ganz hinten?
	beq.s	GehNachVorne	; wenn ja, dann müßen wir nach vorne!
	sub.b	#$11,MeinCon1	; wir ziehen 1 vom Scroll der geraden/ungeraden
	rts						; Bitplanes ab ($ff,$ee,$dd,$cc,$bb,$aa,$99..)
							; gehen somit nach LINKS
GehNachVorne:
	clr.b	FLAG			; Durch Nullsetzen des FLAG wird bei TST.B FLAG
	rts						; das BEQ die Routine nach Vorne springen lassen, und
							; das Bild wird vorschreiten (nach rechts)

Vorne:
	cmpi.b	#$ff,MeinCon1	; Sind wir beim Maximalscroll nach vorne ($ff)
							; angekommen?? ($f gerade und $f ungerade)
	beq.s	GehNachHinten	; wenn ja müßen wir zurückgehen
	add.b	#$11,MeinCon1	; zähle 1 zum Bitplanescroll dazu, gerade und
							; ungerade ($11,$22,$33,$44 etc..)
	rts						; GEH NACH RECHTS

GehNachHinten:
	move.b	#$ff,FLAG		; Wenn das Label FLAG nicht auf NULL ist,
	rts						; dann bedeutet das, daß wir nach links
							; zurückgehen müßen

;	Dieses Byte ist ein FLAG, es zeigt uns an, ob wir vor oder
;	zurück gehen müßen.

FLAG:
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
	
	dc.w	$102			; BplCon1 - DAS REGISTER
	dc.b	$00				; BplCon1 - DAS NICHT VERWENDETE BYTE!!!
MeinCon1:
	dc.b	$00				; BplCon1 - DAS VERWENDETE BYTE!!!
	
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

			    ; 5432109876543210  ; BPLCON0:
	dc.w	$100,%0011001000000000  ; Bits 13 und 12 an!! (3 = %011)
							; 3 Bitplanes Lowres, nicht Lace
BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane - BPL0PT
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

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	BILD

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	end

Ein Bild um 16 Pixel nach vorne zu verschieben ist auf dem Amiga ein Witz!
Einfach das BPLCON1, $dff102, manipulieren, und das war´s auch schon.  Auf
anderen  Systemen,  wie  etwa  PC  MSDOS  muß  wirklich das ganze Bild neu
berechnet werden, was klarerweise alles bremst.
Weiteres können  gerade  und  ungerade  Bitplanes  unabhängig  voneinander
manipuliert werden, was mit wenigen Befehlen sehr einfach Parallax-Effekte
erzeugt. Einfach den Hintergrund etwas langsamer scrollen lassen, der z.B.
aus  den  geraden  Bitplanes besteht, und den Vordergrund etwas schneller.
Auf den PC´s hingegen brauchts dafür lange und komplizierte Routinen,  die
alles verlangsamen. Und dann heißt´s : "Pentium 75 ist zwar etwas langsam,
aber mit dem neuen Pentium 100  müßte  das  Spiel  recht  gut  laufen...!"
Überprüfen	wir,	daß  es  möglich  ist,  die  zwei  Playfields  separat
anzusteuern. macht die  folgenden  Modifizierungen:  um  NUR  die  GERADEN
Planes zu bewegen (hier ist es das Nr. 2) ersetzt folgende Anweisungen:

	sub.b	#$11,MeinCon1	; ziehen 1 dem Scroll der Bitplanes ab

	cmpi.b	#$ff,MeinCon1	; sind wir beim Maximalscroll angekommen?

	add.b	#$11,MeinCon1	; zählen 1 zum Scroll der geraden /ungeraden
							; Bitplanes dazu ($11,$22,$33,$44 etc..)

mit diesen:


	sub.b	#$10,MeinCon1	; nur die GERADEN Planes!

	cmpi.b	#$f0,MeinCon1

	add.b	#$10,MeinCon1

Ihr werdet bemerken, daß sich nur ein Bitplane bewegt, das zweite, während
das  Erste  und  das  Dritte  stehen  bleiben.  Beim  Bewegen verliert das
Bitplane 2 seine Überlappung, es bleibt  alleine  stehen  und  zeigt  sein
"wahres  Gesicht".  Es  übernimmt  die  Farbe von COLOR2, $FFF, wie in der
Copperlist ersichtlich, also Weiß. Es bekommt die Farbe2 weil das Bitplane
2  beim Verstellen nur mit dem Hintergrund auftritt, also %010, die Planes
1 und 3 sind auf 0 weil nicht vorhanden. Die Binärzahl %010 entspricht der
2,  also  wird  dessen  Farbe  vom  Register Color2 bestimmt, dem $dff184.
Verändert den Wert dieses Registers und ihr werdet sehen, wie das Plane 2,
wenn es "alleine" dasteht, die Farbe ändert.

	dc.w	$0184,$fff		; Color2

Wird $FF0 eingesetzt, wird es Gelb werden.  Des  Weiteren  wird  das  Bild
"gelöchert",  wo  die  Bitplane verschwindet, das ist vielleicht besser zu
sehen, wenn ihr die Bewegung  stoppt,  indem  ihr  den  rechten  Mausknopf
drückt.  Diese  "Löcher"  treten  vor  allem  dort  auf, wo die Bitplane 2
alleine stand, wo das Bild also Weiß war. Anderswo wird sich  statt  einem
Loch zu bilden die Farbe verändern.

Um  nur die UNGERADEN Bitplanes zu bewegen (1 und 3 in unserem Bild), dann
verändert die Zeilen so:

	subq.b  #$01,MeinCon1	; nur die UNGERADEN Planes!

	cmpi.b  #$0f,MeinCon1

	addq.b  #$01,MeinCon1

In  diesem  Fall bleibt das Plane 2 stehen, und die Planes 1 und 3 bewegen
sich. Mit diesem Beispiel habt ihr  vielleicht  auch  die  Methode  besser
verstanden, mit der die Farben durch Überlappung angezeigt werden.


