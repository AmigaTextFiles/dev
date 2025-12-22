
; Listing2i.s

Anfang:
	lea	$dff000,a0			; Gib $dff000 in a0
Waitmouse:
	move.w	6(a0),$180(a0)	; Gib den .W-Wert von $dff006 in COLOR0
							; 6(a0)=$dff000+6, $180(a0)=$dff000+$180
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	Waitmouse		; wenn nicht, zurück zu Waitmouse
	rts						; Ende

	END

In   dieser  Variante  des  ersten  Listings  sind  Adressierungsdistanzen
eingefügt: in a0 kommt die Adresse $dff000, und dann werden die  Distanzen
angegeben.  Ich  habe  $dff000 gewählt, weil es eine "gerade" Adresse ist,
denn um $dff180 (COLOR0) zu erreichen, brauche ich eine Distanz  von  $180
($180(a0)), und so ist sofort eindeutig, was für eine Adresse gemeint ist.
Hätte ich hingegen $dff013 in a0 geschrieben hätte, dann wäre $16d(a0) die
richtige  Distanz  gewesen  ($dff013 + $16d = $dff180). Wäre aber nicht so
klar. Zu Beachten ist, daß das Register a0 nie verändert wird, es  bleibt,
wie es ist, $dff000, bei jedem Aufruf zählt der Prozessor die Distanz dazu
und errechnet somit die neue Adresse. In fast allen  Programmen,  die  mit
Grafik  arbeiten,  wird die Adresse $dff000 in irgend ein Register gegeben
und dann  werden  die  Adressierungen  auf  die  gerade  beschriebene  Art
durchgeführt,  auch  OFFSET  genannt.  Somit kann man alle CUSTOM-REGISTER
erreichen, sie gehen von $dff000 bis $dff1fe.  Man  kann  einen  maximalen
Offset von -32768 bis +32767 erreichen, also von -$8000 bis $7FFF.

Bemerkung:  Achtet  auf den Unterschied, der zwischen dem LEA und dem MOVE
besteht, wenn eine Adressierungsdistanz verwendet wird:

	MOVE.L	$100(a0),a1

Kopiert das Longword, das an Adresse a0 plus $100 Bytes ENTHALTEN ist, ins
Register a1. Also: MACHE DIE SUMME VON ADRESSE IN A0 UND OFFSET (DIE ZAHL
VOR DER KLAMMER); DAS RESULTAT DAVON IST DIE ADRESSE, DEREN INHALT IN A1
KOPIERT WIRD.

Während:

	LEA	$100(a0),a1

Gibt in a1 die Adresse a0+$100 selbst, nicht deren Inhalt, denn LEA kann
ausschließlich ADRESSEN laden, KEINE INHALTE.

Machen  wir  ein Beispiel, das alles noch ein bißchen klarer macht: Stellt
euch den Speicher wie  eine  lange,  einsame  Straße  mit  vielen  kleinen
Häuschen vor, alle in Reih und Glied, und jedes mit einer Hausnummer. Wenn
wir in a0 die Adresse 0 geben, also die Adresse des  ersten  Hauses,  dann
wird  der  Befehl  MOVE.L  $100(a0),a1  nichts anderes tun, als zu Adresse
a0+$100 = $100 zu gehen, und Teppich, Möbel, Betten usw. in a1  zu  geben.
Es  wurde  also  der  INHALT  des Hauses in $100(a0) kopiert, im Falle des
MOVE.L ein Longword ab der angegebenen Adresse. Mit  dem  LEA  $100(a0),a1
hingegen  wandert  nur die Adresse des Hauses in a1, also $100 + a0 = $100
(im Beispiel),  wir  treten  ins  Haus  nicht  ein.  Der  Unterschied  ist
letztendlich  eben  der, daß wir mit einem MOVE in a1 die Möbel des Hauses
kopiert haben, mit dem LEA nur die Adresse. Für INHALT meine ich das,  was
in der Adresse enthalten ist, denn in jeder Adresse (jedem Haus) ist etwas
enthalten: es können Zahlen sein (die Möbel) oder es kann leer sein  (wenn
das Haus verlassen ist), dafür können wir aber immer NULL ($00) nehmen.

z.B. ist der Befehl:

	LEA	$100(a1),a1

identisch mit dem Befehl:

	ADD.W	#$100,a1

In a1 wird eben die Adresse a1+$100 gegeben.

Bemerkung:  Die  Adressierungsdistanzen (Offset) könnt ihr in Dezimal oder
in Hexadezimal (mit dem $-Symbol) schreiben, ganz wie´s euch gefällt,  ihr
könnt auch Multiplikationen, Divisionen usw. einfließen lassen:

	LEA	$10+3(a1),a2	; es wird als LEA $30(a1),a2 assembliert
						; werden, denn das * steht für 
						; MULTIPLIZIERE

