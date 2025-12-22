
ASSEMBLERKURS - LEKTION 6

In dieser Lektion werden  wir  lernen,  Texte  am  Bildschirm  anzuzeigen,
screens hin- und herzuscrollen, die größer sind als der Bildschirm und wie
man Tabellen mit vordefinierten Werten verwendet, um "Hüpfbewegungen"  und
Wellen zu simulieren.

Zu  lernen, Schriften am Bildschirm anzuzeigen ist extrem wichtig, denn es
gibt kein Spiel oder  Grafikdemo,  das  ohne  auskommt:  ob  wir  nun  den
Punktestand  anzeigen  wollen,  oder die Leben von Player1, eine Botschaft
zwischen einem Level und dem anderen, ein Gruß an die Freunde,  usw...  Es
leuchtet  hoffentlich  ein, daß da nicht jedesmal Bilder im Format 320x256
angezeigt werden, die die vorgefertigten Schriften beinhalten! Stellt euch
vor,  ihr  wollt 5 Seiten Text als Intro von eurem Spiel hinmalen: "Es war
einmal ein Ritter, vor langer, langer Zeit, der sich auf  die  Suche  nach
dem  heiligen  Graal  machte,...",  ihr habt schon verstanden. Nun gut, es
gibt zwei Möglichkeiten: entweder ihr zeichnet euch mit einem  Malprogramm
fünf  Bilder mit dem Text darauf, und in diesem Fall haben wir 5 Bilder zu
40*245 = 51200 Bytes verwendet,  die  uns  Platz  auf  Disk  und  Speicher
fressen,  oder wir erledigen alles mit 1kB Fonts und einigen Bytes Routine
und erreichen das Gleiche. Nur 50kB weniger Speicher haben wir verschenkt.
Habt  ihr  die  Charakter-FONTS  des  Betriebssystemes  vor  Augen, TOPAZ,
DIAMOND und all die anderen?
Sehr gut, aber die interessieren uns überhaupt nicht. Tut mir  leid.  Aber
wir  werden eigene verwenden!! Klar, wir können auch diese verwenden, aber
die sind begrenzt, aber wenn wir uns selbst  was  zusammenbasteln,  können
wir  anzeigen   was  wir  wollen,  keine  Größe  kann  uns aufhalten, kein
arabischer Zeichensatz. Auch Farben, kein  Problem,  dann  müßt  ihr  halt
einen  Font in Farbe zeichnen und die richtige Routine dazuschreiben. Wenn
man einmal das PRINT-System verstanden hat, also jenes, das die Buchstaben
auf  den Monitor bringt, dann sind Variationen kein Thema mehr. Zum Anfang
lernen wir mal, wie wir einen kleinen Font anzeigen, 8 mal 8  Pixel  groß,
in einer Farbe.
Zuerst brauchen wir einmal ein BITPLANE, auf  dem  wir  unsere  Buchstaben
"drucken"   können,   und  einem  CHARAKTERFONT,  indem  diese  Buchstaben
gespeichert sind. Mit Bitplane gibt´s keine Probleme, da  braucht  man  ja
nur  ein  Stück  Speicher  mit Nullen aufzufüllen, das der Dimension   der
Bitplane entspricht, und es dann anpointen, es also  anzeigen.  Um  dieses
Stück leeren Speicher zu schaffen können wir das DCB.B 40*256,0 verwenden,
das ein richtiges Stück mit NULL füllt und uns zur Verfügung  stellt. Aber
es  gibt  eine  spezielle  SECTION  für  die  leeren  "BUFFERS": die BSS -
Section. In ihr kann man die Anweisungen DS.B / DS.W / DS.L verwenden, die
angeben,  wieviele  Bytes,  Words oder Longwords man auf NULL setzen will.
Der Vorteil liegt in der Gesamtlänge des ausführbaren Files: wenn wir  mit
einem "Bitplane: dcb.b 40*256,0" aufwarten, dann werden die 10240 Bytes in
der Länge eingebaut, hingegen mit der Section BSS:

	SECTION EinBitplaneHier,BSS_C	; _C bedeutet, daß sie in CHIP RAM
						; kommen muß, ansonsten könnte das
						; Betriebssystem auf die Idee
						; kommen, sie in FAST zu lagern.
						; Und Bitplanes müssen IMMER in 
						; CHIP RAM!!!
BITPLANE:
	ds.b	40*256		; 10240 Bytes auf 0

Am Ende des File wird dann ein HUNK angehängt, der im  Moment  des  Ladens
soviel bedeuten wird wie 40*256 Bytes, im File selbst aber nur einige Byte
belegen wird.
Es ist, als ob man einen Sack voller 10 Pfennig-Münzen  haben  würde,  und
mit  dem  "ds.b 40*256" einen Schein zu 100 DM. Das Resultat ist immer das
gleiche, aber der 100 DM-Schein ist etwas leichter. Das Gleiche  gilt  für
den File, er ist "magerer".

Zu  Bemerken,  daß  das  "ds.b 40*256" nicht von "0" gefolgt ist, wie etwa
beim DCB.B der Fall, denn "DS" bedeutet immer NULL. DCB hingegen kann auch
was anderes sein.

Nun haben wir das  "Stück  Papier",  worauf  wir  unseren  Text  schreiben
können. Jetzt fehlt noch der Font und die Druckroutine.
Schauen wir uns mal an was ein Font eigentlich ist und  wie  er  aufgebaut
ist.  Ein  Font  ist  ein  File, der die Anweisungen und Daten enthält, um
etwas zu schreiben. Er kann in verschiedenen Formaten  vorliegen.  Er  ist
eigentlich  nichts  anderes als eine Serie von Charaktern, einem unter dem
anderen, um Präzise zu sein sind sie alle in  einer  Reihe:"ABCDEFGHI...".
Einige Fonts sind in .IFF gezeichnet, also ein Screen aus Charaktern:

	 ------------
	|ABCDEFGHIJKL|
	|MNOPQRSTUVWX|
	|YZ1234567890|
	|			 |
	|			 |
	 ------------
	
Dieses  Bild  wird dann in RAW umgewandelt, und die Buchstaben werden dann
aus diesem Bild herausgenommen und an die richtige Stelle in der  Bitplane
kopiert:  wenn  ein  "A"  erscheinen  soll,  dann  wird  die Stelle im RAW
herauskopiert und kommt mit einigen Move ins Bitplane. Wenn wir  also  ein
"A" brauchen, wissen wir jedesmal, wo wir es zu suchen haben. Idem mit den
anderen Lettern.
Sprechen wir über das System, das wir in diesem  Kurs  mit  dem  8x8  Font
anwenden werden: die Buchstaben brauchen 8 Pixel*8 Pixel, sie sind also so
groß wie die Font des Kickstart. Eigentlich sind sie  etwas  schmaler,  da
sie ja auch noch einen kleinen Abstand enthalten müssen, sonst würden sie,
einmal aneinandergeschrieben, alle aufeinander kleben. Die Buchstaben sind
dann   alle   in   der  "richtigen"  Reihenfolge  aufgestellt,  also  nach
ASCII-Norm, das sieht so aus:

	dc.b	$1f,' !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO'
	dc.b	'PQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~',$7F
 
Das $1f am Anfang und das $7f am Ende bedeuten, daß der  erste  Charakter,
das  LEERZEICHEN, das nach dem $1f ist, also $20, gefolgt von dem "!", das
den Wert $21 einnimmt, usw, bis zu den letzten Lettern, die dann  bei  $7F
ankommen.  Das  gerade  mal um  euch  eine  Idee  von  der Ausrichtung der
AsciiTabelle zu geben. Wir haben  schon  einmal  darüber  gesprochen,  daß
Ziffern auch  ASCII-Zeichen (Buchstaben) sein können, probiert ein "?$21".
Das Ergebnis wird in Hex($), Dezimal, Binär und  ASCII  "...!"  angezeigt.
Überzeugt? Wir haben auch gesehen, daß ein:

	dc.b	"hund"

äquivalent zu einem

	dc.b	$68,$75,$6e,$64

ist. Denn "h" ist im  Speicher  ein  $68,  ein  "u"  ein  $75  etc.  Jeder
Charakter  besetzt  im Speicher ein Byte, also hat ein Text, der 5000 Byte
lang ist, 5000 Zeichen.
Kommen wir zu unserem Font zurück. Stellt euch ein Bild  vor,  das  nur  8
Pixel  breit  ist,  aber  lang  genug,  um alle Buchstaben einen unter dem
anderen zu enthalten:

!
"
#
$
%
&
'
(
)
*
+
,
-
.
/
0
1
2
3
4
5
6
7
8
9
:
;
<
=
>
?
@
A
B
C
D
E
F
G
H
I
J
K
L
M
N
O
	
Und so weiter...

Den  Font,  den  wir  in unserem Kurs verwenden ist nichts anderes als ein
Bild in RAW, das so aussieht. In Wirklichkeit wird ein  solcher  Font  mit
speziellen  EDITOREN  entworfen, Programmen, die  eigens für Fonts gedacht
wurden. Für Fonts, die größer sind ist es aber vorteilhaft, sie  in  einem
Bild   zu  malen,  normalerweise  320x256,  und  eine  eigene  Routine  zu
verwenden, um sie "auszuschneiden".
Aber zum Anfang sehen wir uns den einfachsten Font an und wie er  auf  den
Schirm  kommt:  zu  erst  muß einmal der String (Zeichenkette) vorbereitet
werden, in dem steht, was dann angezeigt werden soll, z.B.:

	dc.b	"Erste Schrift!"	; Bemerke: es können die ´´oder die ""
								; verwendet werden.

	EVEN						; und: gleiche alles an GERADE
								; Adressen an

Der Befehl EVEN dient dazu, ungerade Adressen zu vermeiden, die unter  dem
dc.b entstehen können. Die Text-Strings bestehen aus einzelnen Buchstaben,
und es kann passieren, daß eine  ungerade Anzahl dabei herrausspringt.  In
diesem  Fall  wäre das Label darunter auf einer ungeraden Adresse, und das
kann Fehler beim Assemblieren verursachen: beim 68000er müssen die Befehle
immer  auf  geraden  Adressen liegen, wenn man nicht einen GURU MEDITATION
verursachen will.  Ein  Move.L  oder  Move.W  auf  eine  ungerade  Adresse
verursacht Crashes, GURUS und Explosionen.
Also erinnert euch, immer ein Even am Ende eines  Textstrings  zu  setzen,
oder versichert euch, daß die Anzahl gerade ist. Dafür könnt ihr auch eine
0 am Ende anhängen, und somit die Rechnung aufgehen  lassen.  Bei  GFXName
habe isch das so gemacht:

GfxName:
	dc.b	"graphics.library",0,0

Könnte man auch so schreiben:

GfxName:
	dc.b	"graphics.library",0
	even
 
Es reicht eine NULL am Ende, die andere setzt das Even. Gut, wenn wir also
festgelegt  haben,  was  wir  anzeigen  wollen,  müssen  wir nur noch eine
Routine schreiben, die das Richtige an den richtigen Ort ausgibt.
Ich stelle euch schon die Routine vor, die einen Buchstaben druckt:

PRINT:
	LEA	TEXT(PC),A0			; Adresse des zu schreibenden Textes in a0
	LEA	BITPLANE,A3			; Adresse des Ziel-Bitplanes in a3
	MOVEQ	#0,D2			; Lösche d2
	MOVE.B	(A0),D2			; Nächster Charakter in d2
	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUFUNGSZEICHEN ($21) IN $01...
	MULU.W	#8,D2			; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
							; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTEBEN IM FONT

							; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,40*2(A3)  ; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,40*3(A3)  ; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,40*4(A3)  ; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,40*5(A3)  ; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,40*6(A3)  ; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,40*7(A3)  ; Drucke Zeile 8  "	"

	RTS
  
Habt ihr´s schon verstanden??? 
Analysieren wir sie Schritt für Schritt:

	LEA	TEXT(PC),A0			; Adresse des zu schreibenden Textes in a0
	LEA	BITPLANE,A3			; Adresse des Ziel-Bitplanes in a3
	MOVEQ	#0,D2			; Lösche d2
	MOVE.B	(A0),D2			; Nächster Charakter in d2
  
Bis hierher keine Probleme, wir haben in d2 den Wert des Buchstaben, wenn
es ein "A" wäre, dann wäre dieser Wert $41.

	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUFUNGSZEICHEN ($21) IN $01...
  
Auch was hier passiert müßte klar sein, schauen wir mal, wieso wir 32($20)
abziehen:

	MULU.W	#8,D2			; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
							; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTABEN IM FONT
  
Diese  Operation gibt uns als Ergebnis in A2 die Adresse des Buchstaben im
Font, also die Adresse, von der wir den Charakter auschneiden  müssen,  um
ihn dann in unser Bitplane einzufügen.
Was ist passiert? Erinnert ihr euch, daß die  Charakter  im  Font  in  der
gleichen Reihenfolge eingesetzt wurden wie im ASCII-Standart? Wenn wir nun
diesen ASCII-Wert kennen, können wir auch unser hypotetisches "A" im  Font
ausfindig  machen. Wenn jeder Buchstabe 8 Pixel mal 8 Pixel groß ist, dann
bedeutet das, daß er 8 Bit lang ist, also 1 Byte pro Zeile, mit  8  Zeilen
ergibt sich daraus dann 8 Bytes.
Also befindet sich das Leerzeichen (erstes Zeichen im Font) am Anfang  des
Fonts,  und  das nächste Zeichen beginnt 8 Byte später (Rufezeichen), usw.
Durch das Abziehen von $20 vom Wert erhält das Leerzeichen  nun  den  Wert
$00,  das  Rufezeichen  $01, ... , das "A" bekommt $21, das "B" $22 und so
fort. Wir brauchen also nur noch diese Ziffer mit 8 zu multiplizieren, und
wir haben die richtige Distanz vom Anfang des Fonts!  Nochmal   wiederholt:

	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUFUNGSZEICHEN ($21) IN $01...
	MULU.W	#8,D2			; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
							; da die Charakter ja 8 Pixel hoch sind
 
Nun haben wir in  D2  die  Distanz  (Offset)  vom  Anfang  des  bestimmten
Buchstabens  vom  Anfang  des  Fonts  berechnet!	  Um nun die effektive
Adresse im Speicher zu finden, zählen wir zu diesem "Offset innerhalb  des
Fonts" noch die Adresse des Fonts selbst dazu:

	MOVE.L	D2,A2
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTEBEN IM FONT...
  
Nun haben wir in A2 die  Adresse,  wo  sich  unser  auserwählter Buchstabe
befindet, z.B. das "A". Nun noch von FONT auf den Bildschirm, also auf die
Bitplane von 320x256, in dem jede Zeile 40 Byte lang ist:

							; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,40*2(A3)  ; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,40*3(A3)  ; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,40*4(A3)  ; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,40*5(A3)  ; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,40*6(A3)  ; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,40*7(A3)  ; Drucke Zeile 8  "	"
  
Die Kopie erfolgt Zeile für Zeile, der Charakter ist 8  Zeilen  hoch   und
jede besteht aus 8 Bit (1 Byte):

	12345678

	...###.. Zeile  1 - 8 bit, 1 byte
	..#...#. 2
	..#...#. 3
	..#####. 4
	..#...#. 5
	..#...#. 6
	..#...#. 7
	........ 8

Also  um  eine  Zeile  pro  Durchgang  zu kopieren müssen wir ein Byte pro
Durchgang kopieren. Aber der Ziel-Screen ist 40 Byte pro Zeile breit,  wir
müssen bedenken, daß jede Zeile unter die andere kommen muß, wenn wir also
nicht jedesmal 40 Byte überspringen würden, dann sähe alles so aus:

	...###....#...#...#...#...#####...#...#...#...#...#...#.........
 
Wir  müssen  aber  ein  Byte  kopieren,  ZEILE WECHSELN, indem wir 40 Byte
weiterspringen, und dann das nächste Byte kopieren:


	MOVE.B  (A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
 
Auf dem Monitor:

	...###..
 
	MOVE.B  (A2)+,40(A3)	; Drucke Zeile 2  (40 Bytes weiter)


Auf dem Monitor:
	
	...###..
	..#...#.
 
	
	MOVE.B  (A2)+,40*2(A3)  ; Drucke Zeile 3  (80 Bytes weiter)

Auf dem Monitor:

	...###..
	..#...#.
	..#...#.
 

Und  so  weiter. Für einen Screen, der 8 Byte breit ist (640x256 in HIRES)
müßte die Routine nur so abgeändert werden:

	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile 8  "	"

Sehen wir uns in der Praxis an, wie dieses "A" auf unsere Bitplane  kommt.
Listing6a.s, wenn ich bitten darf.

In Listing6b.s gehen wir zu einer ganzen Zeile über.

Und zum Schluß drucken wir soviele Zeilen, wie wir wollen. Dafür seht euch
Listing6c.s an. Diese Routine ist  die  ENDGÜLTIGE,  die  ihr  immer  dann
verwenden könnt, wenn ihr etwas auf den Bildschirm schreiben wollt.

Warum  nicht  den  eigenen  Font zeichnen? In Listing6c2.s ist der Font in
dc.b-Format, so wie dieses Beispiel:

; "B"
	dc.b	%01111110
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111110
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111110
	dc.b	%00000000
 
Die Buchstaben sind mit vielen dc.b % in den Speicher gegeben (binär). Ihr
könnt jeden einzelnen Charakter so abändern, wie ihr wollt. Wenn ihr einen
eigenen  Font  herstellt,  speichert ihr auf eine andere Diskette oder auf
Hard Disk!

Nun versuchen wir etwas, was  wir  noch  nie  versucht  haben:  auf  einem
einzigen  Screen  lassen  wir gleichzeitig ein Bild in LowRes und eines in
HiRes zusammenleben!  Der  Amiga  kann  gleichzeitig  mehrere  Auflösungen
anzeigen  (was  mir  auf  den  PC´s  nicht bekannt wäre), einfach ein Wait
setzen und darunter mit einem BPLCON0 eine  andere  Auflösung  einstellen,
genau so, als ob wir nur die Farben umdefinieren würden!
Z.B. könnten wir von der ersten Zeile bis zu Zeile $50 ein Bild in HAM  zu
4096  Farben  LowRes  anzeigen,  darunter  eines  in  HiRes mit 16 Farben,
nochmal darunter ein weiteres in LowRes zu 32 Farben, und  so  weiter.  In
einigen  Spielen  ist z.B. das Spielfeld, in dem sich die Figur bewegt, in
LowRes gehalten, und das Bedienfeld darunter in HiRes (siehe AGONY).

Versuchen wir es sofort. In Listing6d.s haben wir ein Bild in LowRes  über
einem anderen in HiRes.

Kommen  wir  nun  zu  einem "Trick", der uns einen "Relief-Effekt" bei den
Worten hervorruft, die wir auf den Schirm malen: in Listing6e.s aktivieren
wir  2  Bitplanes  statt  nur  einer,  und  wir  uberlagern den ersten dem
zweiten, nur um eine Zeile nach unten verrutscht. Was passiert,  wenn  wir
zwei  gleiche  Bilder übereinanderlegen, die durchsichtig erscheinen, aber
ein bißchen verschoben? Sie "verdoppeln" sich! Und was passiert, wenn  wir
das  "obere",  verdoppelte  Bitplane  dunkler  machen  als  das untere? Es
passiert, daß ihr verstanden habt, wie Listing6e.s funktioniert.

Übrigens, weil wir gerade von Überlagerungen sprechen; wieso nicht einfach
über  einem  Bild eine andere Bitplane legen und darauf schreiben?? So was
wird in Listing6f.s gemacht.

In Listing6g.s sehen wir den  "Transparenz"-Effekt.  Eine  Schrift  bewegt
sich über einem Bild.

In  Listing6h.s sehen wir eine Methode, um Texte in 3 Farben zu schreiben,
indem wir zwei Texte auf zwei Bitplanes überlappen lassen.

In Listing6i.s lassen wir eine der Farben des Textes  blinken,  indem  wir 
eine  vorgefertigte TABELLE mit   Werten   benutzen.  Wir  haben schon	in
LEKTION1 von Tabellen gesprochen, jetzt seht ihr in der Praxis, wie so was
geht.

In Listing6l.s seht ihr eine Variation der Routine, die eine TAB liest, um
die Farben zu ändern; die Änderung liegt darin, daß statt die Tabelle  von
Anfang bis zum Ende zu lesen, und dann von vorne zu beginnen, sie hier bis
zum Ende gelesen wird, und dann wird von hinten nach vorne gegangen.

Die Tabellen können für viele Zwecke nützlich bis unentbehrlich sein.  Zum
Beispiel,  um  Feder- und Sprungeffekte zu erzeugen. Sehen wir den Vorteil
einer Tabelle gegenüber einem simplen Sub und Add, wenn es  um  Bewegungen
geht. Ich verweise auf Listing6m.s...

Weil wir gerade von Bewegung sprechen: wir haben für den Horizontal-Scroll
bislang nur das $dff102 verwendet, das uns aber maximal 16 Pixel  in  eine
Richtung  erlaubte.  Aber wie können wir dann den Bildschirm beliebeig hin
und herscrollen, und soviel wir wollen? Die Antwort ist  relativ  einfach:
wir verwenden auch die Bitplanepointers!
Wir haben schon gesehen, daß mit ihnen ein  Scroll  nach  oben  und  unten
möglich ist, wir brauchen nur eine/mehrere Zeilen dazu- oder wegzählen (40
in LowRes, 80 in HiRes). Aber wir können  auch  vor-  und  zurückscrollen,
aber  nur  in  Schritten zu 8 Pixel (1 Byte). Wie? Zu den Bitplanepointers
ein Byte dazuzählen oder abziehen, jenachdem, in welche Richtung wir gehen
wollen. Somit ergibt sich ein Scroll von einem Byte, eben 8 Pixel.
Wenn wir mit den Bitplanepointers 8 Pixel scrollen  können,  und  mit  dem
$dff102 jeweils 1 Pixel, dann können wir "fließende" Bewegungen eigentlich
ganz leicht herstellen: mit dem $dff102 in eine Richtung,  bis  maximal  8
Pixel,  und  dann  mit  dem  BPLPointer einen großen "Schritt" von 8 Pixel
machen, und zugleich das BPLCON1 ($dff102)  auf  NULL  setzen.  Der  große
Schritt könnte so aussehen:

	subq.l	#1,BITPLANEPOINTER
 
Somit  sind wir auf das neunte Pixel gekommen. Dann wieder Pixel für Pixel
mit dem BPLCON1, und bei 8 angekommen, auf NULL setzen  und  einen  großen
Schritt.  In  den Beispielen aber lasse ich den großen Schritt nur alle 16
Pixel machen, da das BPLCON1 ja 16 Pixel verträgt. Für 16 Pixel muß dann 2
zu  den  BitplanePointers addiert oder subtrahiert werden (Da 1 ja das PIC
um 8 Pixel bewegte). Ich bewege das Bild also um 1 einzelnes Pixel mit dem
$dff102,  und  verwende  seine  maximale  "Spannweite",  von  $00 bis $FF,
insgesamt 16 Positionen, danach mache ich eine Sprung zu 16 Pixel mit  dem
Bitplanepointers, etwa mit ADDQ oder SUBQ #2,BITPLANEPOINTERS.
Hier eine Routine, die ein  Bild  soweit  nach  rechts  scrollt,  wie  wir
wollen,  in  Schritten  zu 1 Pixel. Betrachtet MEINBPCON1 als das Byte des
$dff102.

Rechts:
	CMP.B	#$ff,MEINBPCON1	; sind wir bei maxim. Scroll angekommen (15)?
	BNE.s	CON1ADDA		; wenn noch nicht, geh noch eines weiter,
							; verwende das BPLCON1

; Liest die Adresse des Bitplane

	LEA	BPLPOINTERS,A1	; Mit diesen 4 Operationen holen wir aus der
	move.w	2(a1),d0	; Copperlist die Adresse, wo das $dff0e0 gerade
	swap	d0			; hinpointet und geben es in d0
	move.w	6(a1),d0

; Scrollt nach Rechts um 16 Pixel, mit dem Bitplanepointer

	subq.l	#2,d0		; Pointet 16 Bit weiter nach hinten (die PIC
						; scrollt um 16 Pixel weiter nach Rechts)

; Läßt das BPLCON1 wieder bei 0 starten

	clr.b	MEINBPCON1	; löscht den Hardware-Scroll BPLCON1 ($dff102)
						; wir sind ja 16 Pixel mit dem Bitplanepointer
						; gesprungen, nun müssen wir wieder bei NULL
						; starten, um mit dem $dff102 Pixel für
						; Pixel nach Rechts zu scrollen

	move.w	d0,6(a1)	; Kopiert das niederw. Word der Adresse des Plane
	swap	d0			; vertauscht die 2 Word
	move.w	d0,2(a1)	; Kopiert das hochwertige Word der Adresse des Plane
	rts					; Steige aus der Routine aus

CON1ADDA:
	add.b	#$11,MEINBPCON1	; scrolle das Bild um 1 Pixel nach Rechts
	rts					; Raus aus der Routine
 

Die Routine erhöht das BPLCON1 ($dff102) jeweils um eins, es läßt so  alle
möglichen Positionen durchlaufen:
00,11,22,33,44,55,66,77,88,99,aa,bb,cc,dd,ee,ff, dann springt es zum Pixel
ff+1, indem es zwei Operationen durchführt:

1) 2 Bytes (1 Word, 16 Bits) im Bitplanepointer zurückpointen, um das Bild
   um 16  Pixel nach  rechts  scrollen  zu lassen  (also 1 Pixel  nach der
   Position $FF, also 15, die im vorigen Frame erreicht wurde.

2) Das $dff102 auf NULL setzen, da  wir  ja  16  Pixel  in  einem  Schritt
   gemacht  haben. Ansonsten würden sich die 16 Pixel des Bitplanepointers 
   zu den 15 ($ff) des  $dff102 summieren. Aber durch  Löschen des BPLCON1 
   starten wir  wieder bei $00 + 16 = sechzehntes  Pixel, danach gehen wir 
   weiter bis zum 15ten  mit dem BPLCON1, und  lassen die Bitplanepointers 
   unverändert.

Wenn das noch nicht klar sein sollte, folgt diesem Schema,  das  #  stellt
das Bild dar, das sich nach rechts bewegt:

						; WERT BPLCON1  - BYTE VON BPLPOINT. ABGEZOGEN

#							;	$00		-	0			- tot. pixel:
 #							;	$11		-	0			-	1
  #							;	$22		-	0			-	2
   #						;	$33		-	0			-	3
    #						;	$44		-	0			-	4
     #						;	$55		-	0			-	5
      #						;	$66		-	0			-	6
       #					;	$77		-	0			-	7
		#					;	$88		-	0			-	8
		 #					;	$99		-	0			-	9
		  #					;	$aa		-	0			-	10
		   #				;	$bb		-	0			-	11
			#				;	$cc		-	0			-	12
			 #				;	$dd		-	0			-	13
			  #				;	$ee		-	0			-	14
			   #			;	$ff		-	0			-	15
				#			;	$00		-	2			-	16
				 #			;	$11		-	2			-	17
				  #			;	$22		-	2			-	18
				   #		;	$33		-	2			-	19
					#		;	$44		-	2			-	20
					 #		;	$55		-	2			-	21
					  #		;	$66		-	2			-	22
						#	;	$77		-	2			-	23

Und so weiter...

Dieses Schema spricht für sich: wenn wir z.B. 22 Pixel nach rechts wollen,
dann  müssen  wir  2  von  den  Bitplanepointers  abziehen und das BPLCON1
($dff102) aus $66 setzen.

Möchten wir nach links, müßten  wir  alle  16  Pixel  2  zu  den  Pointers
dazuzählen, und mit dem $dff102 rückwärts gehen: $ff, $ee, $dd...

Sehen  wir in Listing6n.s die Routine im Härtetest. Ihr bemerkt sicher die
Störung am linken Rand des Screens; das ist kein Fehler  in  der  Routine,
aber  eine  Charakteristik  der  Hardware  des Amiga, um sie zu beseitigen
reicht eine kleine Ausbesserung. Sie ist im Listing selbst erklärt.

Da wir ja nun ein Bitplane in jede Richtung scrollen können,  wieweit  wir
wollen,  wieso  bewegen  wir  dann nicht ein Bild, das größer ist, als der
Bildschirm selbst?? In Listing6o.s tun wir´s : ein  Bild,  das  640  Pixel
breit  ist, rollt in einem normalem LowRes - Screen von 320x256 nach links
und rechts.

Wir haben schon bei den Tabellen die Verwendung eines Longword als Pointer
auf eine Adresse gesehen:

POINTER:
	DC.l	TABELLE

Im Longword "POINTER" wird die  Adresse  von  Tabelle  assembliert,  somit
können  wir  festhalten, wohin wir in der Tabelle gekommen sind, indem wir
die Länge eines Elementes dazuzählen oder wegzählen.
Wir müssen jedesmal abspeichern, wohin wir gerade gekommen  sind,  da  die
Routine  nur  einmal pro Fotogramm ausgeführt wird, und nicht durchgehend.
Es ist also möglich, daß andere Routinen in  der  Zwischenzeit  aufgerufen
werden,  und  unsere  Werte  "verwischen".  Wenn diese Routine also wieder
aufgerufen  wird,  dann  muß  sie   dort   fortfahren,   wo   sie   vorhin
stehengeblieben ist. Sie kann das durch ein simples

	MOVE.L  POINTER(PC),d0	; In d0 ist die  Adresse,  wohin wir
							; das letzte Mal gekommen sind.
 
tun.  Vor  dem  Aussteigen  aus  der Routine muß nur die aktuelle Position
abgespeichert werden. Diese Systematik  kann  vielfach  verwendet  werden,
z.B.  um  nur  bei  jedem Fotogramm einen Buchstaben auf den Bildschirm zu
bringen, anstatt den ganzen Text auf einmal hinaufzuklatschen.  Dafür  muß
nur die PRINT: - Routine etwas modifiziert werden und zwei Pointer erzeugt
werden: einer, der auf den letzten gedruckten Buchstaben zeigt, und einer,
der auf die letzte Adresse zeigt, wo wir in unserem Bitplane gewesen sind.
So ist es, als würden wir einen Buchstaben schreiben, die Routine für  die
Dauer eines Frames einfriefen, und sie danach weiterlaufen lassen. Aber in
Wirklichkeit frieren wir sie nicht ein,  wir  führen  sie  aus,  um  einen
Buchstaben  zu schreiben, speichern den erreichten Stand der Dinge ab, und
fahren später fort. Das Listing, das diese Theorien in die Praxis umsetzt,
heißt Listing6p.s

In  einem  Bitplane  können  wir -außer Text drucken- auch Zeichnungen wie
Schachbretter, Webmuster oder Balken hineinmalen.  Einfach  die  richtigen
Bits auf 1 setzten!!! In Listing6q.s befinden sich einige Beispiele.

Wir  sind  am  Ende von LEKTION6 angekommen, nun bleibt uns nichts anderes
übrig,  als  einige   Listings   zusammenzusetzen,   verbunden   mit   den
"Neuigkeiten"   dieses   Kapitels,   und   so  ergibt  sich  das  gewohnte
"Letzte_Mega_Listing", mit allem Drum und Dran, auch Musik: Listing6r.s

Nun gehen wir zum Studium der Sprites  über.  Ihr  müßt  nur  LEKTION7.TXT
laden  und  dann den Path mit "V df0:LISTINGS3" wechseln. Die Listings für
dieses Kapitel befinden sich in dieser Directory auf Disk1.
