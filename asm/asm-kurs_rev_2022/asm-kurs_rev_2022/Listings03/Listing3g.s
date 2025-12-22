
; Listing3g.s	; BALKEN, DER LINKS-UND RECHTS GEHT, ERSTELLT MIT MOVE & WAIT
				; DES COPPERS

	SECTION CIPundCOP,CODE	; auch Fast ist	OK

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName,a1			; Adresse des Namen der zu öffnenden Library in a1
	jsr	-$198(a6)			; OpenLibrary, Routine der EXEC, die Libraris
							; öffnet, und als Resultat in d0 die Basisadresse
							; derselben Bibliothek liefert, ab welcher
							; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach
							; GfxBase)
	move.l	#COPPERLIST,$dff080  ; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088	    ; COPJMP1 - Starten unsere COP
mouse:
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
	bne.s	mouse			; Wenn nicht, geh nicht weiter
	
	bsr.w	CopperLinkRech	; Routine für Links/Rechts Scroll

Warte:
	cmpi.b	#$ff,$dff006	; VHPOSR:
							; Sind wir noch auf $FF? Wenn ja, warte auf die
	beq.s	Warte			; nächste Zeile (00). Ansonsten wird CopperLinkRech


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

; Diese Routine operiert nicht auf dem ersten Byte links des Wait, also
; dem, das die Y-Position bestimmt, sondern auf dem zweiten, das der
; X-Position, das eine Verschiebung der Farbe von Links nach Rechts zur
; Folge hat. Dazu verwendet es zwei Flags ähnlich dem RAUFRUNTER wie wir
; es schon gesehen haben, sie heißen GehLinks und GehRechts. Sie beinhalten
; die Anzahl, wie oft die jeweilige Routine schon aufgerufen wurde, um
; so die "Verschiebung" zu begrenzen (also um bestimmen zu können, wie
; weit man vorwärts gehen muß, bevor man umdreht). Jedesmal, wenn die
; Routine GehRechts ausgeführt wird, wandert der graue Strich ein Stück
; nach rechts, wir müßen sie also stoppen, wenn wir den rechten Rand erreicht
; haben, in unserem Fall nach 85 Zyklen, und weitere 85 Schritte nach links
; gehen (GehLinks), dann sind wir wieder am Ausgangspunkt. Dieses Spielchen
; wird solange wiederholt, bis ein Mausklick alles stoppt.
; ZU BEMERKEN IST, DAß HIER ENTWEDER NACH GEHLINKS ODER GEHRECHTS VERZWEIGT
; WIRD, ES WERDEN NIE BEIDE ROUTINEN ZUGLEICH AUSGEFÜHRT. WENN GEHRECHTS
; AUSGEFÜHRT WIRD, DANN WIRD DIESE ROUTINE DURCHLAUFEN UND VON DEREN ENDE
; AUS ZUM MOUSE-ZYKLUS ZURÜCKGESPRUNGEN. DAS GLEICHE GILT FÜR GEHLINKS.
; WENN DER GEHLINKS/GEHRECHTS - ZYKLUS BEENDET IST (NACH 2*85 FRAMES)
; KEHREN WIR ZUM "MOUSE"-ZYKLUS ZURÜCK, DIREKT VOM RTS DER ROUTINE
; COPPERLINKRECH AUS, NACHDEM WIR DIE BEIDEN FLAGS AUF NULL GESETZT HABEN.

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
							; zwei Flags und steigen aus: beim nächsten
							; FRAME wird GehRechts ausgeführt, nach 85
							; Frame GehLinks 85 Mal, etcetera.
	RTS						; ZURÜCK ZUM MOUSE-LOOP


GehRechts:					; Diese Routine verschiebt den Balken nach RECHTS,
	addq.b	#2,CopBar		; indem es 2 zu der X-Koordinate des Wait addiert.
	addq.w	#1,FlagRechts   ; Verzeichnen, daß wir ein weiteres Mal GehRechts
						    ; durchlaufen haben: in FlagRechts steht die Anzahl,
						    ; wie oft diese Routine aufgerufen wurde.
	RTS						; Zurück zum Mouse-Loop
GehLinks:					; Diese Routine verschiebt den Balken nach LINKS,
	subq.b	#2,CopBar		; indem es 2 von der X-Koordinate des Wait
							; subtrahiert.
	addq.w	#1,FlagLinks    ; Verzeichnen, daß wir ein weiteres Mal GehLinks
							; durchlaufen haben: in FlagLinks steht die Anzahl,
							; wie oft diese Routine aufgerufen wurde.
	RTS						; Zurück zum Mouse-Loop


FlagRechts:					; In diesem Word wird die Anzahl festgehalten,
	dc.w	0				; wie oft GehRechts ausgeführt wurde

FlagLinks:					; In diesem Word wird die Anzahl festgehalten,
	dc.w	0				; wie oft GehLinks ausgeführt wurde


GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder '', Abschluß mit ,0


GfxBase:		; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0	; ab hier werden die Offsets gemacht



OldCop:		   ; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0  ; Betriebssystemes


	SECTION GRAPHIC,DATA_C	; Dieser Befehl veranlaßt das Betriebssystem,
							; das folgende Datensegment in die CHIP-RAM
							; zu laden, obligatorisch.
							; Die Cpperlist MÜSSEN in die CHIP RAM!


COPPERLIST:
	dc.w	$100,$200		; BPLCON0
	dc.w	$180,$000		; COLOR0 - Beginne die Cop mit SCHWARZ


	dc.w	$9007,$fffe		; Warte Anfang der Zeile $90 ab
	dc.w	$180,$AAA		; Farbe Grau

; Hier haben wir das erste Word des WAIT $9031 in 2 Bytes "zerrissen", um
; ein Label (CopBar) dazwischen einfügen zu können, das uns das zweite Byte
; markiert, also $31 (LA XX)

	dc.b	$90				; POSIZION YY des WAIT (erstes Byte des WAIT)
CopBar:
	dc.b	$31				; POSITION XX des WAIT (das ändern wir!)
	dc.w	$fffe			; wait - (wird $9033,$FFFE - $9035,$FFFE....)

	dc.w	$180,$700		; Farbe ROT, das immer weiter rechts starten
							; wird, vorangegangen vom Grau, das dement-
							; sprechend mitgehen wird
	dc.w	$9107,$fffe		; wait, das nicht geändert wird. (Beginn Zeile $91)
	dc.w	$180,$000		; wird gebraucht, um die Farbe in Schwarz zu ändern
							; (nach dem kleinen Balken).

;	Wie ihr seht, braucht es für die Zeile $90 zwei Wait, eines, das den
;	Anfang der Zeile abwartet (07), und eines, das modifiziert wird (31),
;	um definieren zu können, ab wo der Strich Farbe ändert, also vom Grau
;	ab Position 07 zu Rot.
 
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST

	end

Schön, gell? Ein  Effekt  von  diesem  Typ  wird  meistens  verwendet,  um
EquilizerEffekte  bei Musik zu generieren. Das Verschieben in horizontaler
Richtung hat aber ein Limit,  es  können  nur  ungerade  Werte  eingegeben
werden,  das ist auch der Grund, wieso wir immer Zeile $yy07 abwarten, und
nicht z.B. $yy08. Als Konsequenz davon kann man nur  in  Schritten  von  2
Pixel jedesmal gehen: 7, 9, $b, $d, $f, $11, $13... oder in Schritten zu 4
Pixel, 8 Schritten, Hauptsache, man hält sich  an  die  ungeraden  Zahlen,
oder  man  riskiert,  den Amiga zum Explodieren zu bringen! Bemerkung: der
maximale Wert von XX  ist  $e1.  Als  Änderungen  kann  ich  euch  diesmal
eigentlich  nur vorschlagen, in 4er oder 8er Schritten zu gehen, indem ihr
4 oder 8 an Stelle der 2 dazuzählt. Somit ändert sich natürlich  auch  die
Geschwindigkeit.  Vergesst  nicht,  auch die Anzahl zu ändern, wie oft die
Routinen durchgeführt werden sollen:


	CMPI.W	#85/2,FlagRechts	; 85 Mal /2, also "geteilt durch 2"
	BNE.S	GehRechts
	CMPI.W	#85/2,FlagLinks	; 85/2, also 42 Mal
	BNE.S	GehLinks		; wenn noch nicht, dann nochmal...
	....

	addq.b	#4,(a0)			; 4 dazu....
	....

Oder, für ein addq.b #8,a0:

	CMPI.W	#85/4,FlagRechts	; 85 Mal /4, also 21


Wenn ihr Sadisten seid, könnt ihr versuchen, ein addq.b #1,(a0) zu setzen,
und  somit auch gerade Wait XX erzeugen.... Bestenfalls "verschwindet" der
Bildschirm,  wenn  ein  ungerades  XX  eintritt,  oder,  wenn  auf   einen
exotischen  Wert  gewartet  wird,  dann  kann schon mal ein totaler Streik
eintreten, eine Art "GURU MEDITATION" des Copper. Seid also  vorsichtig!!!
Ich  kann  euch  einige  "Spezialkoordinaten" verraten, die sich nicht nur
darauf beschränken, den Bildschirm zum Verschwinden  zu  bringen,  sondern
wirklich  den  Copper  ins  Nirwana  schicken,  und euch zum Reset zwingen
(zumindest auf dem A1200, wo ich es ausprobiert habe).

	dc.w	$79DC,$FFFE		; $dc = 220! Gerade uns besonders BÖSE!
							; er bringt den Copper um den Verstand,
							; blockiert aber nicht das System. Ihr könnt
							; weiterarbeiten wenn auch "im Dunkeln",
							; ohne was zu sehen

	dc.w	$0100,$FFFE		; das hingegen BLOCKIERT alles, man kann nicht
							; mal vom Programm aussteigen, ein Reset ist
							; das einzige Heilmittel

	dc.w	$0300,$FFFE		; Weiterer Totalabsturz...


Diese "Fehler" können von Vorteil sein, wenn ihr Programme schützen wollt,
die  schlecht  kopiert wurden oder ein falsches Password eingegeben wurde.
Einfach eine  Copperlist  mit  diesen  Wait  ansteuern  und  der  Computer
BLOCKIERT  schlimmer als mit einem GURU des 68000, und jedes Action Replay
oder  anderes  Cartridge   sind   nutzlos.   Oder   man   kann   sie   als
SELBSTZERSTÖRUNG   verwenden,  wer  weiß,  ob  der  Computer  PHYSIKALISCH
zerstört wird, wenn man viele solcher Fehler hintereinander schaltet???

Bemerkung: Ihr könnt einen Effekt wie diesen auch mit Listing3c.s erzielen,
wenn ihr es folgendermaßern modifiziert:


BewegeCopper:
	cmpi.b	#$fc,BALKEN		; Sind wir bei Zeile $fc angekommen?
	beq.s	Ende			; wenn ja, sind wir unten und stoppen
	addq.b	#1,BALKEN		; WAIT 1 geändert, der Balken sinkt um 1 Zeile
Ende:
	rts

Auf diese Art, indem ihr  ihm  also  Position  XX  anstatt  YY  (BALKEN+1)
ändert,  und ihr ihn um 2 statt um 1 weiterdreht (ungerade Zahl!), ohne zu
vergessen, daß der maximale Wert $e1 ist (auszutauschen mit dem $fc)

BewegeCopper:
	cmpi.b	#$e1,BALKEN+1	; Sind wir bei Zeile $e1 angekommen?
	beq.s	Ende			; wenn ja, sind wir rechts und stoppen
	addq.b	#2,BALKEN+1		; WAIT 2 geändert, der Balken wandert um 2 px
Ende:
	rts


werdet  ihr die erste Zeile nach rechts wandern sehen, anstatt nach unten.
Um diesen Effekt hervorzuheben, könnt ihr die Zeile $79 "isolieren", indem
ihr  ab dort den Bildschirm blau werden laßt, also ab $7a. Fügt diese zwei
Zeilen vor dem Ende der Copperlist dazu:

	dc.w	$7a07,$FFFE		; Warte auf Zeile $7a
	dc.w	$180,$004		; Beginne die blaue Zone : Blau auf 4

In Listing3g.s werden die Schwierigkeiten vor allem in der Routine liegen,
die den Balken vor- und zurückwandern läßt, vielmahr als an der  Tatsache,
daß  wir die YY-Positionen ändern, an Stelle der XX. Die letzten Listings,
die ihr gerade bewältigt habt,  beinhalten  68000er  Routinen,  die  nicht
grade ganz banal sind, aber unbedingt notwendig, um Effekte mit dem Copper
erzeugen zu können, und somit den Copper selbst verstehen  zu  lernen.  In
Lektion4  werden  die  Routinen auch noch einfacher sein als die in diesem
Kapitel, da wir nur das Anzeigen von statischen Bildern behandeln  werden.
Wenn  ihr im Moment also noch nicht alles ganz verstanden habt, dann fahrt
ruhig mit Kapitel 4 fort, und kommt später hierauf zurück,  wenn  ihr  mit
den  Routinen  besser  vertraut sein werdet.  Listing3h.s ist ein Ausbauen
des Listing3g.s

