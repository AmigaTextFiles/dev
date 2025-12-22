
ASSEMBLERKURS - LEKTION 5

In dieser Lektion werden wir den horizontalen und  vertikalen  Scroll  von
Bildern behandeln und im weiteren noch einige andere Spezialeffekte.

Beginnen   wir  mit  dem  horizontalen Scroll (Bild nach links oder rechts
verschieben): der Amiga  besitzt  ein  spezielles  Register, das für diese
Aufgabe  zugeschnitten ist, das BPLCON1 ($dff102), das ein Bild jeweils um
ein Pixel nach links oder rechts verschieben kann, bis  zu  einem  Maximum
von  15 Pixel. Das wird durch den Copper erreicht, indem der Datentransfer
der Bitplanes um ein Pixel  oder  mehr  verspätet.  Die  geraden  und  die
ungeraden Bitplanes können auch separat voneinander verschoben werden. Die
ungeraden  Bitplanes  werden  PLAYFIELD1  genannt  (1,3,5),  die   geraden
PLAYFIELD2  (2,4,6).  Das  $dff102  ist  ein  Word lang, und in zwei Bytes
unterteilt: das hochwertige, also das links ($xx00), das aus den Bits  von
15  bis  8 besteht. Es wird nicht verwendet, es muß auf 0 gelassen werden.
Das niederwertige Byte ($00xx) kontrolliert den Scroll:

	$dff102, BPLCON1 - Bit Plane Control Register 1

	BITS		NAME-FUNKTION

	15	-	X
	14	-	X
	13	-	X
	12	-	X
	11	-	X
	10	-	X
	09	-	X
	08	-	X
	07	-	PF2H3\
	06	-	PF2H2 \4 Bit zum Scroll der GERADEN PLANES
	05	-	PF2H1 /			    (Playfield 2)
	04	-	PF2H0/
	03	-	PF1H3\
	02	-	PF1H2 \4 Bit zum Scroll der UNGERADEN PLANES
	01	-	PF1H1 /			    (Playfield 1)
	00	-	PF1H0/
 
Auf dieses Word muß man  ähnlich  zugreifen  wie  bei  den  Farbregistern:
während bei den Farbregistern auf drei Komponenten agiert werden muß, also
auf RGB, so wird hier nur auf zwei zugegriffen, die jeweils von $0 bis  $f
gehen, wie in etwa Grün und Blau des $dff180 (COLOR0):

	dc.w	$102,$00xy	; BPLCON1 - wobei: X Scroll GERADE BITPLANES
						;				   Y Scroll UNGERADE BITPLANES

Einige Beispiele: (für die Copperlist)

	dc.w	$102,$0000	; BPLCON1 - Scroll NULL, normale Position
	dc.w	$102,$0011	; BPLCON1 - Scroll = 1 in beiden Playfield,
						; ich bewege also das ganze Bild
	dc.w	$102,$0055	; BPLCON1 - Scroll = 5 für das ganze Bild
	dc.w	$102,$00FF	; "" Scroll auf Maximalwert (15) für das ganze Bild
	dc.w	$102,$0030	; "" Scroll = 3 nur für gerade Bitplanes
	dc.w	$102,$00b0	; "" Scroll = $B nur für ungerade Bitplanes
	dc.w	$102,$003e	; "" Scroll = 3 für die geraden Bitplanes, $e
						;		        für die ungeraden Bitplanes

Nichts Leichteres! Einfach den Wert des Scrolls bei jedem Frame  wechseln,
und man hat einen tollen Scroll des ganzen Bildes mit einem MOVE erzeugt!!

Ladet Listing5a.s um in der Praxis zu sehen, was passiert.

In diesem Beispiel wird das BPLCON1 - $dff102 - am Anfang  der  Copperlist
verändert,  deswegen  bewegt  sich  das  ganze  Bild. Es ist auch möglich,
mehrere $dff102 in  verschiedenen  Zeilen  der  Copperlist  zu  verwenden,
kombiniert  mit  einigen  Waits.  Was  daraus  entstehen kann, seht ihr in
Listing5b.s, dort werden  zwei  Scrolls  verwendet,  die  die  Schriftzüge
"COMMODORE" und "AMIGA" unabhängig verschieben.
Wird ein $dff102 pro Zeile eingegeben, dann erzielt  man  die allbekannten
Welleneffekte der Bilder.

Schauen wir uns nun den vertikalen Scroll an. Die einfachste Art ist jene,
einfach höher oder tiefer die    Bitplane-Pointers in  der  Copperlist  zu
pointen.  Somit erscheint das Bild höher oder tiefer. Stellen wir uns vor,
wir sehen das  Bild  durch  ein  quadratisches  Loch,  einer  Art  Fenster
(Monitor):

	 ---------------
	|				| 1
	|				| 2
	|     AMIGA		| 3
	|				| 4
	|				| 5
	 ---------------

In diesem Fall sehen wir die Schrift AMIGA in der Mitte des Fensters,  und
wir  haben  die  Bitplane-Pointers  auf 1 zeigen lassen, also dort, wo der
Bildschirm beginnt. Da er also bei Zeile 1 anfängt, steht AMIGA auf  Zeile
3. Wenn wir nun aber auf 2 pointen, was passiert dann??

	 ---------------
	|				| 2
	|     AMIGA		| 3
	|				| 4
	|				| 5
	|				| 6
	 ---------------
 
Das passiert: AMIGA "steigt" um eine Zeile,  weil  das  Fenster  (Monitor)
sinkt, oder anders ausgedrückt, der Pointer um eine Zeile tiefer angesetzt
ist. Da Bewegungen relativ sind, wird ein Baum, den wir aus dem Zugfenster
vorbeiziehen sehen, sich in Wirklichkeit ja nicht bewegen, diejenigen, die
das tun sind wir im Zug. Hier geschieht das Gleiche.  Aber  wieviel müssen
wir dazuzählen, um ein Bild rauf- oder runterzuscrollen? Um wieviel müssen
die  Bitplanepointer  erhöht  bzw. verringert werden?  Um Die  Bytes einer  
Zeile! Also 40, wenn das Pic in LOW RES 320x200 ist, oder 80 für ein  Bild
in HIGHRES 640x256. Schauen wir uns das Beispiel an:

	1234567890
	..........
	....++....
	...+..+...
	...++++...
	...+..+...
	...+..+...
	..........
 
Wir haben eine hypotetische Bitplane mit 10 Bytes pro Zeile,  das  jeweils
auf 0 (.) oder 1 (+) sein kann. Hier wird ein "A" dargestellt. Um dieses A
nach oben zu scrollen, werden wir eine Zeile  "tiefer"  pointen,  also  10
Bytes  weiter  unten.  Um  tiefer  zu  zeigen, müssen 10 BYTES DAZUGEZÄHLT
werden (ADD.L #10,Pointer):

	1234567890
	....++....
	...+..+...
	...++++...
	...+..+...
	...+..+...
	..........
	..........
 
Auf die gleiche Art und Weise, um ein Bild zum Sinken  zu  bringen,  werden
wir  eine  Zeile  weiter  oben  beginnen,  sie  zu zeichnen, also 10 Bytes
weniger in der Adresse. (SUB.L #10,Pointer):

	1234567890
	..........
	..........
	....++....
	...+..+...
	...++++...
	...+..+...
	...+..+...
  
Um das in der Praxis zu  erreichen,  müssen  wir  uns  erinnern,  daß  die
Pointer  in der Copperlist die Adresse der Planes beinhalten (und wir dann
dementsprechned ändern), und diese Adresse in zwei Words  aufgeteilt  ist.
Dieses  Problem  ist  recht  einfach zu bewältigen, wenn man einige kleine
Änderungen in der Routine zum Anpointen der Bitplanes anbringt. Wir müssen
die   Adresse   der  Bitplanes  aus  der  Copperlist  "holen"  (umgekehrte
Operation), 40 dazu- oder wegzählen (für den Scroll, 80 bei  High-Res...),
und dann diese neue Adresse wieder in die Copperlist einsetzen. Für diesen
letzten Schritt kann auch die alte Routine dienen. Schaut euch Listing5c.s
an, dort wird dieses System verwendet.

Nun  ladet  Listing5d.s,  in  dem  die  beiden Routinen für vertikalen und
horizontalen Scroll gleichzeitig laufen.

In Listing5d2.s werdet ihr eine weitere  Anwendung  des  Horizontalscrolls
zusammen  mit  dem  $dff102 (BPLCON1) finden, die Verzerrung während einer
Bewegung.

Nun werden wir  die  wichtigsten  Register  für  Video-Spezialeffekte  des
Amigas kennenlernen, und zwar die Modulo: $dff108 und $dff10a (BPL1MOD und
BPL2MOD). Es gibt zwei Modulo-Register, damit sie  unabhängig  für  gerade
und  ungerade  Planes  geändert  werden  können. Um auf unserem Bild mit 3
Bitplanes operieren zu können, müssen wir  beide  Register zur  Verwendung
ziehen. 
Ihr werdet bemerkt haben, daß bei einem Bild in LowRes  320x256  der  Beam
alle  40  Bytes  eine  neue  Zeile  nimmt,  die  Daten  selbst  aber  alle
hintereinander stehen. Genauso geht der Beam alle 80 in die nächste Zeile,
wenn  es sich  um  ein   Bild  in High-Res handelt. In der Tat wird dieses
Modulo  automatisch zugewiesen, wenn das $dff100 (BPLCON0)  gesetzt  wird:
wird  Low  Res  ausgewählt,  dann weiß der Copper, daß eine Zeile 40 Bytes
lang ist, er nimmt also alle 40 Bytes eine neue.  Er  beginnt  also  links
oben  am  Bildschirm, liest 40 Bytes und malt sie mit dem Beam hinauf. Die
erste Zeile steht. Dann beginnt das  Spiel  von  vorne,  aber  eine  Zeile
tiefer. Die nächsten 40 Bytes kommen an die Reihe. Und so weiter, bis alle
256 Zeilen durch sind. Im Speicher aber  liegen  diese  Daten  klarerweise
alle nacheinander, da gibt's kein quadratisches Bild! Der Speicher ist wie
eine  Schnur,  auf  der  die  Bytes  wie  Perlen  aufgereiht  sind.  Keine
quadratischen  Felder  mit  Bitplanes etc. Das stellen wir uns nur so vor.
Stellt euch vor, ihr zerlegt die einzelnen Zeilen  des  Bildes  und  reiht
dann alle 256 aneinander:
genau so sieht's aus!
Wenn wir nun das Modulo auf 0 lassen, dann verändern wir  nichts,  und  es
bleiben  die  Werte,  wie  sie  sich der Copper vorstellt: alle 40 bzw. 80
Bytes eine neue Zeile. Den Wert, den wir in das Modulo geben, wird zu  den
Bitplanepointers  am ENDE DER ZEILE DAZUGEZÄHLT, also wenn wir die 40 Byte
erreicht haben. Somit können wir Bytes "überspringen", die nicht angezeigt
werden.  Wenn  wir z.B. 40 an jedes Ende dazurechnen, dann wird nach jeder
Zeile eine weitere übersprungen,  es  wird  also  eine  alle  zwei  Zeilen
angezeigt:

  - NORMALES BILD -

 ....................	; am Ende dieser Zeile überspringe ich 40 Bytes
 .........+..........
 ........+++.........	; und zeige diese Zeile an, dann "springe" ich...
 .......+++++........
 ......+++++++.......	; und zeige diese Zeile an, dann "springe" ich...
 .......+++++........
 ........+++.........	; und zeige diese Zeile an, dann "springe" ich...
 .........+..........
 ....................	; und zeige diese Zeile an, dann "springe" ich...

Das Ergebnis wird eine Anzeige jeder zweiten Zeile sein:

	- BILD Modulo 40 -

 ....................	; am Ende dieser Zeile überspringe ich 40 Bytes
 ........+++.........	; und zeige diese Zeile an, dann "springe" ich...
 ......+++++++.......	; und zeige diese Zeile an, dann "springe" ich...
 ........+++.........	; und zeige diese Zeile an, dann "springe" ich...
 ....................	; und zeige diese Zeile an, dann "springe" ich...
 ....................
 ....................
 ....................
 ....................


Das Bild wird zerquetscht erscheinen, nur die Hälfte lang.  Unter  anderem
werden  wir auch Bytes "unter" unserem Bild anzeigen, da der Bildschirm ja
immer  bei  Zeile  256  endet:  praktisch  werden  immer  nur  256  Zeilen
angezeigt,  aber  da wir nur jede zweite anzeigen, wird die Gesamtzahl auf
512 Zeilen kommen. Ladet nochmal Listing5b.s und modifiziert die Modulo in
der Copperlist:

	dc.w	$108,40		; Bpl1Mod
	dc.w	$10a,40		; Bpl2Mod
  
Ihr wedet bemerken, daß das Bild wie erwartet nur die Hälfte so groß  ist,
und  der  untere  Teil  des  Bildschirmes  mit  Bitplanes gefällt ist, die
"übrig" sind: es wird die zweite  Bitplane unter der ersten angezeigt, die
dritte  unter  der zweiten, während nach dem dritten Bitplane der Speicher
angezeigt wird, wie er unter der letzten Bitplane ist. Es  werden  einfach
mehrere  angezeigt.  Probiert  zwei  Zeilen  zu überspringen, indem ihr 80
Bytes überspringt und 40 anzeigt,...:

	dc.w	$108,40*2	; Bpl1Mod
	dc.w	$10a,40*2	; Bpl2Mod

Das Bild ist nochmal halbiert worden, und darunter  werden  weitere  Bytes
erscheinen.  Ihr  werdet  eine Halbierung der Länge des Bildes alle Modulo
40*x feststellen. Wenn ihr ein Modulo wählt, das nicht 40 ist, dann werdet
ihr  eine Art "fransen" verursachen, denn der Copper wird die Zeilen nicht
mehr ab deren Anfang darstellen, sondern ab einem Punkt, der von Zeile  zu
Zeile verschieden sein wird.

Haut  euch Listing5e.s rein, um eine schnelle Routine zu sehen, die 40 zum
Modulo dazuzählt, um das Bild zu halbieren.

Die Moduli können außer positiv auch negativ sein. In diesem Fall wird die
Zahl  am  Ende  der  angezeigten  Zeile  abgezogen.  Somit können komische
Effekte erzielt werden: stellt euch vor, ihr setzt das Modulo auf -40. Der
Copper  wird  also  40 Bytes lesen, die erste Zeile, sie anzeigen, dann 40
Bytes zurückgehen und nochmal  dieselben anzeigen. Er wird also  über  die
ersten  40  Bytes  nie  darüber  hinaus  kommen. Wenn z.B. die erste Zeile
vollständig schwarz ist, dann werden alle folgendne  Zeilen  auch  schwarz
werden,  weil  sie die erste Zeile "kopieren". Wenn ein Punkt inmitten der
ersten Zeile war, dann werden alle Zeilen diesen Punkt haben:

	..........+........	; Zeile 1 (immer neu gezeichnet:
	..........+........	; Zeile 2  Modulo -40!)
	..........+........	; Zeile 3
	..........+........	; Zeile 4
	..........+........	; Zeile 5
	..........+........	; Zeile 6
	..........+........	; Zeile 7
	..........+........	; Zeile 8
	..........+........	; Zeile 9
	..........+........	; Zeile 10

So wird jede Farbe eine Art von "Schmelzeffekt" erzeugen, der bis zum Ende
des  Screens  reichen  wird.  Dieser Effekt wurde viel in Spielen wie Full
Contact, dem  Demomaker  von  Red-Sector  und  vielen  anderen  Programmen
eingesetzt.

Sehen wir uns an, wie er in der Praxis funktioniert. Listing5f.s.

Sehr  eindrucksvoll und einfach zu erstellen, stimmt's oder hab ich recht?
Er wird auch FLOOD-Effekt genannt. Das Modulo wird am Ende jeder Zeile  zu
den  Bitplane-Pointers  dazugezählt, diese "wandern" im Speicher herum, um
das ganze Bild anzuzeigen. Wir addieren also eine negative Zahl, das einer
Subtraktion  entspricht.  In diesem gegebenen Fall werden die Pointer nach
dem Transfer einer jeden Zeile mit dem Wert X+40 bzw.  mit  X-40  geladen,
und starten wieder ab diesem Wert X.

+---->->->--------+
|				  |
|BPL POINTER=  X+ 0......................................39	  
|				  |										 |
|ANFANG ZEILE-+---xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx---+- LETZTES BYTE ->
|	(X)		 |   |										 |   |	(X+39)
|			 +---+										 +---+
|				 |
| NÄCHST. Z.-+----xxxx[...]
^			 |	  |
|			 +-X+ 40  (Der Pointer ist nach dem Transfer die ganze Länge einer
^				  |   Zeile durchgegangen (40 Bytes), und ist am 40sten
|				  |   stehengeblieben, das im Grunde nichts anderes ist als
^				  |   das erste Byte der nächsten Zeile).
|				  +-> (Hier wird dem Pointer einer jeden Plane ein Wert
|				  |   ADDIERT, in unserem Fall "-40")
|				  +-> X=X+(-40) => X=X-40 => X=0 >-+
|				  |								   |
+----------<-<-<--+------------<-<-<---------------+

Gesehen? Gerade dann, wenn der Pointer am Ende angekommen ist, zählen  wir
ihm  40  Bytes  weg,  und  er muß von vorne beginnen. Er zeigt die gleiche
Zeile nochmal an.

Wir haben in Listing5f.s auch den "Spiegel-Effekt"  gesehen,  also  Modulo
-80. Schauen wir ihn uns alleine in Listing5g.s an.

Nun   sehen   wir,   wie  die  Verwendung  von  vielen  $dff102  (BPLCON1)
nacheinander in der Copperlist einen Welleneffekt erzeugen  können:  ladet
Listing5h.s.

Sehen  wir uns nun eine spezielle Verwendung des Scrolls mit den Bitplanes
an: Listing5i.s ist ein  sogenannter  GRAPHIC-SCANNER,  ein  Vorfahre  der
GFX-RIPPER,  also  der  Programme,  die Bilder aus dem Speicher "stehlen".
Dieses kurze Programm dient dazu, den Inhat des Chip-Ram  anzuzeigen,  mit
allen sichtbaren Bildern, die sie enthält.

Noch ein Beispiel mit den Modulo in Listing5l.s, diemal um ein Bild in die
Länge zu ziehen, anstatt es zu kürzen.

In Listing5m.s sehen wir eine andere Methode, um  Bilder  nach  oben  oder
nach unten zu verschieben, diesmal durch verändern von DIWSTART ($dff08e).
Die Register DIWSTART und DIWSTOP bestimmen den Anfang und  das  Ende  des
"VideoFensters",   also   dem  rechteckigen  Teil  des  Bildschirmes,  der
angezeigt wird. DIWSTART enthält die YYXX-Koordinaten  der  linken  oberen
Ecke dieses "Fensters", DIWSTOP die Koordinaten der rechten, unteren Ecke:

    DIWSTART
	o----------------
	|				|
	|				|
	|				|
	|				|
	|				|
	----------------o
		      DIWSTOP
 
In diesen Registern kann man aber nicht alle beliebigen  Werte  einsetzen,
denn   XX  und  YY  sind  Bytes,  und  bekanntlich können  Bytes  nur  256
verschiedene Werte darstellen ($00-$FF). Schauen  wir  also,  wo  wir  das
Video-Fenster mit DiwStart beginnen und es mit DiwStop beenden können.

	dc.w	$8e,$2c81	 ; DiwStrt YY=$2c,	 XX=$81
	dc.w	$90,$2cc1	 ; DiwStop YY=$2c(+$ff), XX=$c1(+$ff)
 
Das normale Videofenster hat diese Werte als  Standart  für  DIWSTART  und
DIWSTOP; die vertikale Position YY funktioniert genau so wie beim Wait des
Copper: wenn wir mit dem Copper eine Zeile über  $2c  abwarten,  und  dort
Farbverläufe  herstellen, dann werden sie nicht sichtbar sein, weil sie zu
hoch oben liegen. Das Gleiche gilt für Waits nach der Zeile $FF, die  dann
bei  $00 wieder starten werden, also $FF+1. Der Bildschirm beginnt bei $2c
und endet bei $2c nach $FF. Dadurch  werden  wie  erwartet  insgesamt  256
Zeilen  angezeigt.  Für  einen  Bildschirm,  der  nur 200 Zeilen hoch ist,
müssen wir folgendes DIWSTOP setzen:

	dc.w	$90,$f4c1	 ; DiwStop YY=$2c(+$ff), XX=$f4
 
In der Tat ist $f4-$2c = 200. Wenn wir $00, $01... setzen, werden  wir die
Zeile nach $FF meinen.
Die Limits sind folgende: das DiwStart kann sich vertikal zwischen $00 und
$FF  bewegen, also bis zur Zeile 200. Das Video-Fenster kann also nicht ab
Zeile 201 oder mehr starten, immer früher.
Für das DiwStop haben sich die Ingenieure eine Strategie ausgedacht:  wenn
der  Wert  unter  $80 (128) ist, dann warte Zeile $FF ab, $2c bezieht sich
also auf $2c+$FF, also Zeile 256. Wenn die Zahl größer als $80  ist,  dann
wird sie so wie sie ist genommen (auch weil  es  keine  Zeile  $80+$ff=383
gibt!), und es wird wirklich die Zeile 129, 130, etc. abgewartet.
DiwStart kann also bis maximal Zeile $FF gehen,  bei  NULL  startend,  das
DiwStop  hingegen  kann  Zeile  $FF  überschreiten  und über das Limit des
Bildschirmes hinausgehen, es kann aber nicht unter Zeile $80 gehen.
Dieser Trick wurde angewandt, indem die Zahlen mit Bit 7  auf  NULL  (also
bis  $80)  so  angesehen  hat, also ob sie ein hypotetisches Bit 8 gesetzt
hätten ( die Zahlen nach $80 haben es gesetzt),  das  dann  alles  um  $FF
erhöht.  Ist  dieses Bit aber nicht gesetzt, dann wird unser hypotetisches
Geisterbit gelöscht und die Zahlen werden genommen wir sie kommen.
Was die horizontalen Zeilen  angeht,  sie  können  jeden  beliebigen  Wert
zwischen  $00  und  $FF annehmen, also bis zur Position 256 (erinnert euch
aber, daß der Bildschirm bei $81 und  nicht  bei  $00  beginnt,  also  bei
126!). DiwStop hingegen interpretiert ein $00 als ein 127, und das geht so
weiter bis zum rechten Rand, denn es hat das "Geisterbit" immer auf 1,  es
weren also immer $FF zu seinem XX-Wert dazugezählt.
Schlußendlich kann man sagen, daß das DiwStart sich in jeder  Position  XX
und  YY  positionieren  kann, mit jedem Wert zwischen $00 und $FF. DiwStop
hingegen kann sich horizontal nach der Zeile $FF, vertikal von  der  Zeile
$80  bis  $FF positionieren, danach starten die Zeilen wieder bei $00, $01
usw., wie beim Wait nach $FF, deswegen ist ein $2c eigentlich $2c+$FF.

In  Listing5m2.s,  wird  dieses  Argument behandelt.

Als  Abschluß von LEKTION5 ladet Listing5n.s, das eine Zusammenfassung der
vorherigen Listings ist, und dazu spielt es auch noch ein Lied.

Einmal dieses Listing verstanden, bleibt euch nichts  anderes  übrig,  als
LEKTION6.TXT zu laden!