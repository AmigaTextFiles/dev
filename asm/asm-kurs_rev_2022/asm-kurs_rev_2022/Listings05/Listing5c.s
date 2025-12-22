
; Listing5c.s	SCROLLEN EINES BILDES NACH OBEN UND UNTEN DURCH MODIFIZIEREN
;				DER BITPLANEPOINTERS IN DER COPPERLIST

	SECTION	CIPundCOP,CODE

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
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)

	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, somit zeigen wir
							; auf das zweite Bitplane (befindet sich direkt
							; nach dem ersten), wir zählen praktisch Länge
							; eines Plane dazu

	addq.w	#8,a1			; a1 enthält nun die Adresse der nächsten
							; Bplpointers in der  Copperlist, die es
							; einzutragen gilt
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1= bitplanes)


	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter
	
 
	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; überspringe die Scrollroutine

	bsr.s	BewegeCopper	; Scrollt Bild rauf und runter

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir noch auf Zeile 255?
	beq.s	Warte			; Wenn ja, geh nicht weiter


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



OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0	; des Betriebssystemes


;	Diese Routine bewegt das Bild nach oben und unten, imdem sie auf
;	die Bitplanepointer in der Copperlist zugreift (Mit dem Label
;	BPLPOINTERS).
;	Die Struktur ist ähnlich mit der in Listing3d.s
;	Als erstes geben wir die Adresse, die dir BPLPOINTERS gerade anpointen
;	in d0, dann addieren oder subtrahieren wir 40 Bytes von d0, und
;	setzen dann diesen neuen Wert in die Copperlist ein. Dafür verwenden
;	wir wieder die gleiche Routine POINTBP.


BewegeCopper:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert in d0.
	move.w	6(a1),d0		; Das Gegenteil der Routine, die die Planes
							; anpointet! Hier wird die Adresse geholt
							; anstatt hineingegebne!!

	TST.B	RaufRunter		; Müßen wir nach oben oder unten? Wenn RaufRunter
							; auf NULL ist (TST also BEQ verifiziert), dann
							; überspringen wir GehRunter, wenn es hingegen auf
							; $FF ist (und TST somit kein BEQ liefern kann),
							; dann fahren wir nach oben fort (mit den Sub)
	beq.w	GehRunter
	cmp.l	#PIC-(40*30),d0 ; sind wir weit genug OBEN?
	beq.s	SetzRunter		; wenn ja, sind wir am Ende und müßen runter
	sub.l	#40,d0			; subtrahieren 40, also 1 Zeile, dadurch
							; wandert das Bild nach UNTEN
	bra.s	Ende

SetzRunter:
	clr.b	RaufRunter		; Durch Löschen von RaufRunter wird das TST
	bra.s	Ende			; danach wieder BEQ ermöglichen ->
							; BEQ wird zur Routine GehRunter springen

GehRunter:
	cmpi.l	#PIC+(40*30),d0 ; sind wir weit genug UNTEN?
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
	;dc.w	$100,%0001001000000000

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

; Fügt hier das Stück Copperlist ein

;2
	dc.w $18a,$102,$18e,$212,$182,$223				; color5,color7,color2
	dc.w $18c,$323,$188,$323,$186,$334,$184,$434	; col6,col4,col3,col2
	dc.w $5007,$fffe
;3
	dc.w $18a,$104,$18e,$214,$182,$225
	dc.w $18c,$324,$188,$324,$186,$335,$184,$435
	dc.w $5207,$fffe
;4
	dc.w $18a,$203,$18e,$313,$182,$324
	dc.w $18c,$423,$188,$423,$186,$434,$184,$534
	dc.w $5407,$fffe
;5
	dc.w $18a,$213,$18e,$313,$182,$324
	dc.w $18c,$433,$188,$433,$186,$434,$184,$534
	dc.w $5607,$fffe
;6
	dc.w $18a,$114,$18e,$214,$182,$224
	dc.w $18c,$323,$188,$323,$186,$334,$184,$434
	dc.w $5807,$fffe
;7
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$312,$188,$322,$186,$333,$184,$433
	dc.w $5a07,$fffe
;8
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$312,$188,$312,$186,$323,$184,$423
	dc.w $5c07,$fffe
;9
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$312,$188,$312,$186,$323,$184,$423
	dc.w $5e07,$fffe
;10
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$322,$188,$312,$186,$323,$184,$433
	dc.w $6007,$fffe
;11
	dc.w $18a,$110,$18e,$210,$182,$221
	dc.w $18c,$321,$188,$311,$186,$322,$184,$432
	dc.w $6207,$fffe
;12
	dc.w $18a,$210,$18e,$310,$182,$321
	dc.w $18c,$421,$188,$411,$186,$422,$184,$532
	dc.w $6407,$fffe
;13
	dc.w $18a,$210,$18e,$320,$182,$331
	dc.w $18c,$431,$188,$421,$186,$432,$184,$542
	dc.w $6607,$fffe
;14
	dc.w $18a,$220,$18e,$330,$182,$431
	dc.w $18c,$441,$188,$431,$186,$442,$184,$552
	dc.w $6807,$fffe
;15
	dc.w $18a,$220,$18e,$330,$182,$431
	dc.w $18c,$440,$188,$430,$186,$441,$184,$551
	dc.w $6a07,$fffe
;16
	dc.w $18a,$220,$18e,$330,$182,$431
	dc.w $18c,$441,$188,$431,$186,$442,$184,$552
	dc.w $6c07,$fffe
;17
	dc.w $18a,$120,$18e,$230,$182,$331
	dc.w $18c,$341,$188,$331,$186,$342,$184,$452
	dc.w $6e07,$fffe
;18

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	BILD

	dcb.b	40*30,%11001100 ; dieses Stück voller Nullen ist notwendig, da wir
							; beim Anzeigen weiter über und unter das Pic selbst
							; gehen und diesen Teil anzeigen. Wären hier keine
							; Nullen, würden die Byte angezeigt, die sich gerade
							; in diesem Teil des Speichers befinden. Das Resultat
							; wäre Chaos am Bildschirm. Aber durch $0000 wird
							; immer Farbe0 angezeigt, also der Hintergrund.


PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format
	dcb.b	40*30,0			; siehe oben

	end

Diese  Routine  addiert  bzw. subtrahiert zur Adresse, die die BPLPOINTERS
anpointen, 40. Dafür wird dieser Wert zuerst in d0 geladen, das  geschieht
mit  einer  Routine,  die  genau  das  Gegenteil deren ist, die die Planes
anpointet.
Mit dieser Methode können auch Bilder angezeigt werden, die größer als der
Bildschirm sind, indem man nur einen Teil anzeigt und die Möglichkeit hat,
hin- und herzuscrollen. Als Beispiel  könnte  man  die  Flipperspiele  wie
Pinball  Dreams  anführen,  die  ein  Spielfeld haben, das über den realen
Bildschirm hinausreicht. Es wird immer der Teil angezeigt, indem sich die
Kugel gerade befindet. Einfach die Pointer umschreiben.
In diesem Beispiel zeigen wir auch Zeilen an, die nicht zum Bild  gehören,
da  wir uns ja nach oben und unten bewegen. Das Bild selbst ist 256 Zeilen
lang, aber wir bewegen unser Bild um 30  Zeilen  nach  oben  und  30  nach
unten,	deswegen  müßen  wir  die  "nachrutschenden"  Zeilen  an  der
Ober/Unterseite  mit  etwas  füllen,  wenn  wir  nicht  x-beliebige  Bytes
anzeigen  wollen.  Dafür  haben  wir  die  dcb.b eingefügt, die jeweils 30
Zeilen "simulieren". Sie  schreiben  nur  0  hinein,  das  entspricht  dem
Color0.  Somit  ist  die Zone ober und unter unserem RAW-Bild "sauber" und
präsentierbar. Probiert z.B. das dcb.b auf folgende Weise zu verändern:

	dcb.b	40*30,%11001100

Bei Ausführen des Listings werdet ihr bemerken, daß die Teile  "außerhalb"
der  Pic  in Streifen erscheinen werden. In der Tat, wir haben ja auch das
Muster
	110011001100110011001100110011
	110011001100110011001100110011
	110011001100110011001100110011

produziert. Ein Bit-Streifenmuster...  Ihr  könnt  auch  die  3  Bitplanes
einzeln  scrollen  lassen:  um  das zu  tun,  müßt  ihr  nur eine Bitplane
anschalten:

			    ; 5432109876543210
	dc.w	$100,%0001001000000000  ; 1 Bitplane


Dann noch die maximal erreichbare Scrollposition ändern:

GehRunter:
	cmpi.l	#PIC+(40*530),d0 ; sind wir weit genug UNTEN?
	beq.s	SetzRauf		; wenn ja, sind wir am unteren Ende und
	...						; müßen wieder rauf

Somit  werdet  ihr  alle  3  Bitplanes separat scrollen sehen, sie sind ja
eines nach dem anderen angeordnet.

* Hier eine kleine Verfeinerung für die Copperlist. Was passiert, wenn wir
alle  8  Farben des Bildes alle 2 Zeilen ändern? Kopiert (mit Amiga+b+c+i)
dieses Stück Copperlist und fügt es vor dem Ende derselben ein:

; Fügt hier das Stück Copperlist ein
  
Durch 52 maliges ändern einer Palette von 8 Farben erhalten  wir  8*52=416
Farben.	Aber	geändert  werden  nur  die  7  Farben,  die  Farbe0,  der
Hintergrund, bleibt immer SCHWARZ. Die Reihenfolge,  mit  der  die  Farben
verändert  werden,  ist  egal,  man kann zuerst Color2 ändern, dann Color3
etc. Wir starten z.B. mit Color5 ($dff18a), dann kommt Color7...
Durch 52 Mal ändern von 7 Farben erhalten wir dann  364  effektive  Farben
gleichzeitig  am Bildschirm, und das ist nicht schlecht, wenn man bedenkt,
daß "offiziell" nur 8 Farben angezeigt werden können. (7*52=364)

;2
	dc.w $18a,$102,$18e,$212,$182,$223				; color5,color7,color2
	dc.w $18c,$323,$188,$323,$186,$334,$184,$434	; col6,col4,col3,col2
	dc.w $5007,$fffe
;3
	dc.w $18a,$104,$18e,$214,$182,$225
	dc.w $18c,$324,$188,$324,$186,$335,$184,$435
	dc.w $5207,$fffe
;4
	dc.w $18a,$203,$18e,$313,$182,$324
	dc.w $18c,$423,$188,$423,$186,$434,$184,$534
	dc.w $5407,$fffe
;5
	dc.w $18a,$213,$18e,$313,$182,$324
	dc.w $18c,$433,$188,$433,$186,$434,$184,$534
	dc.w $5607,$fffe
;6
	dc.w $18a,$114,$18e,$214,$182,$224
	dc.w $18c,$323,$188,$323,$186,$334,$184,$434
	dc.w $5807,$fffe
;7
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$312,$188,$322,$186,$333,$184,$433
	dc.w $5a07,$fffe
;8
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$312,$188,$312,$186,$323,$184,$423
	dc.w $5c07,$fffe
;9
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$312,$188,$312,$186,$323,$184,$423
	dc.w $5e07,$fffe
;10
	dc.w $18a,$101,$18e,$211,$182,$222
	dc.w $18c,$322,$188,$312,$186,$323,$184,$433
	dc.w $6007,$fffe
;11
	dc.w $18a,$110,$18e,$210,$182,$221
	dc.w $18c,$321,$188,$311,$186,$322,$184,$432
	dc.w $6207,$fffe
;12
	dc.w $18a,$210,$18e,$310,$182,$321
	dc.w $18c,$421,$188,$411,$186,$422,$184,$532
	dc.w $6407,$fffe
;13
	dc.w $18a,$210,$18e,$320,$182,$331
	dc.w $18c,$431,$188,$421,$186,$432,$184,$542
	dc.w $6607,$fffe
;14
	dc.w $18a,$220,$18e,$330,$182,$431
	dc.w $18c,$441,$188,$431,$186,$442,$184,$552
	dc.w $6807,$fffe
;15
	dc.w $18a,$220,$18e,$330,$182,$431
	dc.w $18c,$440,$188,$430,$186,$441,$184,$551
	dc.w $6a07,$fffe
;16
	dc.w $18a,$220,$18e,$330,$182,$431
	dc.w $18c,$441,$188,$431,$186,$442,$184,$552
	dc.w $6c07,$fffe
;17
	dc.w $18a,$120,$18e,$230,$182,$331
	dc.w $18c,$341,$188,$331,$186,$342,$184,$452
	dc.w $6e07,$fffe
;18
	... etc.

