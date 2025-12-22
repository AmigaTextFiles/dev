
; Listing2e.s

Anfang:
	lea	$dff006,a0			; Gib $dff006 (VHPOSR) in a0
	lea	$dff180,a1			; Gib $dff180 (COLOR0) in a1
	lea	$bfe001,a2			; Gib $bfe001 (CIAAPRA) in a2
Waitmouse:
	move.w	(a0),(a1)		; Gib den Wert von $dff006 in COLOR0
	btst	#6,(a2)			; linke Maustaste gedrückt?
	bne.s	 Waitmouse		; Wenn nicht, zurück zu waitmouse
	rts						; Ende

	END

Wie man sieht, ist der  Waitmouse-Zyklus  aus  indirekten  an  Stelle  der
direkten  Adressierungen  aufgebaut,  es  wird  also  nicht direkt mit den
Adressen gearbeitet, diese werden in Register geschrieben  und  mit  denen
wird  hantiert.  Die  -  unter  Klammern  gesetzten  - Register werden für
Schreib- oder  Leseoperationen  verwendet  ->  Indirekt.  Das  erhöht  die
Geschwindigkeit  der  Schleife, da die Register bekanntlich schneller sind
als die  direkten  Adressierungen.  Es  müßte  eine  leichte  Änderung  im
Flimmern  des Bildschirmes feststellbar sein, in Vergleich zu Listing1a.s,
da die Abarbeitung schneller ist. Nach der Ausführung kann man überprüfen,
daß  die  Register  a0,  a1  und  a2  dementsprechend die Adressen $dff006
(VHPOSR), $dff180 (COLOR00) und  $bfe001  (CIAAPRA)  enthalten.  Wenn  man
wirklich alle Zahlen aus dem Loop (Schleife) entfernen will, dann kann man
das BTST #6,$bfe001 mit einem BTST d0,$bfe001 ersetzen, wobei in d0 die  6
steht:

Anfang:
	lea	$dff006,a0			; Gib $dff006 (VHPOSR) in a0
	lea	$dff180,a1			; Gib $dff180 (COLOR0) in a1
	lea	$bfe001,a2			; Gib $bfe001 (CIAAPRA) in a2
	moveq	 #6,d0			; Gib den Wert 6 in d0

Waitmouse:
	move.w	(a0),(a1)		; Gib den Wert von $dff006 in COLOR0
	btst	d0,(a2)			; linke Maustaste gedrückt?
	bne.s	 Waitmouse		; Wenn nicht, zurück zu waitmouse
	rts						; Ende

	END

(Verwendet Amiga+b,c um dieses Listing mit dem oberen zu vertauschen)

Anmerkung: Um die 6 in d0 zu schreiben, habe ich statt dem üblichen MOVE.L
#6,d0  ein  MOVEQ  #6,d0  verwendet, weil die Zahlen unter $7f (also 127),
seien sie negativ oder  positiv,  mit  diesem  speziellen  Befehl  in  die
Datenregister  gegeben  werden können. MOVEQ ist immer ein MOVE.L, es gibt
also kein .b, .w oder .l, es ist wie das LEA Beispiel:

	MOVEQ	#100,d0		; weniger als 127
	MOVE.L	#130,d0		; mehr als 127, ich verwende das normale move.l
	MOVEQ	#-3,d0		; bis -128 kann das MOVEQ eingesetzt werden.

Bemerkung2: Es ist üblich, alle Register zu verwenden, indem man  Adressen
und  Daten  darin  speichert,  die für die Routinen (Unterprogramme) nötig
sind, da sie sehr schnell sind. Aber es leuchtet ein, daß die Programme so
ihre Klarheit verlieren und nicht mehr recht "leserlich" sind, stellt euch
vor, ihr bekommt ein Programm vorgesetzt, bei dem, irgendwo  mitten  drin,
so was steht:

Routin:
	move.w	(a0),(a1)
	btst	d0,(a2)
	bne.s	Routin

Hier sehen wir nur (a0),(a1), d0,(a2) usw. WENN WIR NICHT WISSEN,  WAS  IN
DEN  REGISRTERN  DRINSTEHT,  WIRD  UNS  DAS  ALLES  OHNE  SINN ERSCHEINEN,
deswegen versichere ich euch, lernt euch die  Adressierungsarten  gut  und
erinnert  euch,  an welchen Punkten im Programm ihr Daten oder Adressen in
Register gegeben habt, um zu verstehen, was man auch nur  vor einer  Woche
getan  hat.  Eine  Stärke des 68000 liegt darin, INDIREKT mit dem Speicher
umgehen zu können, darin liegen aber auch die Schwierigkeiten. Um zu üben,
schreibt  einige  unsinnige, aber total verquirlte Listings mit indirekten
Adressierungen etc. um zu verstehen, was am Ende rauskommt. Am Ende  könnt
ihr  es  testen und überprüfen, ob eure Vermutungen stimmen. Ich gebe euch
einen Anfang, ihr fahrt mit dem Durcheinander fort, fast  so,  als  würdet
ihr ein Rätsel lösen:

	lea	SCHLUMPF,a0
	move.l	(a0),a1
	move.l	a1,a2
	move.l	(a2),d0
	moveq	#0,d1
	move.l	d1,a0
	.....
	rts

SCHLUMPF:
	dc.l	$66551

