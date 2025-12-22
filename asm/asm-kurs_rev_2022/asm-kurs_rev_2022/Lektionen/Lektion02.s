
ASSEMBLERKURS - LEKTION 2

Na, habt ihr Listing1a.s perfekt verstanden? Wenn  nicht,  dann  seit  ihr
reif für die Klapsmühle, und ihr solltet den Kurs hiermit beenden.

Nun  wollen  wir  die  68000er-"Sprache"  etwas vertiefen. Ich habe vorhin
schon angedeutet, daß der Prozessor nur als Organisator wirkt, selbst aber
nur  Werte  herumkopiert  und ändert. Indem man gewisse Werte in bestimmte
Zonen im Speicher gibt, z.B. $DFFxxx oder $BFExxx, gibt man den  Pins  der
einzelnen  Chips  Strom,  wie  dem  der  Grafik, des Sound, der Ports, und
folgedessen kann  man,  wie  im  vorgegangenen  Beispiel,  die  Farben  am
Bildschirm ändern, oder durch Auslesen bestimmter Adressen die Information
erhalten, wo sich gerade der Elektronenstrahl des Monitors  befindet  oder
ob  der  Mausknopf  gedrückt ist. Um ein Demo oder ein Spiel zu schreiben,
braucht man einen Haufen solcher Adressen, REGISTER genannt,  und  es  ist
nötig,  sie  zu  kennen  genauso  wie  die Programmiersprache des 68000ers
(MOVE, JSR, ADD, SUB etc.), mit denen man die beschreibt.

Für  das  Programmieren  auf  diese  Art  brauchen  wir  die  Bibliotheken
(Libraries)  der  ROM  /  des   Kickstarts   1.2/1.3/2.0/3.0   (also   die
Subroutines,  die  uns erlauben, ein Workbenchfenster zu öffnen oder einen
File zu  lesen...) nicht, oder  vielmehr  nur  sehr  wenig:  z.B.  um  das
Multitasking abzuschalten, um die Workbench nicht in GURU zu schicken!

Ich  halte  es für notwendig, in dieser Lektion 2 die Verwendung des 68000
zu vertiefen, so daß verstanden wird, was sein Zweck ist.

Das wichtigste, das es zu lernen gilt, sind  die  Adressierungsarten.  Das
ist  fast  wichtiger  als  die Befehle selbst, denn wenn das einmal sitzt,
kann man die einzelnen Befehle lernen,  sie  funktionieren  alle  mit  der
gleichen Syntax ("Rechtschreibung"), und man muß sich nur noch merken, was
jeder einzelne tut. Wie schon gesagt, arbeitet der Prozessor im  Speicher,
der in Adressen eingeteilt ist, dessen Einheit das Byte ist. Normalerweise
wird die hexadezimale Schreibweise angewandt, das  ist  ein  Zahlensystem,
das  sich  vom  gebräuchlichen  Dezimalsystem  darin unterscheidet, daß es
nicht nur die Ziffern 0 bis 9 besitzt, sondern 0 bis 9 und A bis F, es hat
als Basis nicht Zehn sondern Sechzehn. Es ist so, als ob die Ziffern A, B,
C... wie 10, 11, 12, ... dastehen würden. Um die Zahlen von Hexadezimal in
Dezimal  zu  konvertieren, reicht es, in  der Kommandozeile des ASMONE den
Befehl  "?"  einzugeben:  "?10000"  liefert  als   Resultat   $2710,   den
entsprechenden  Wert  als  Hexzahl  (die  Hexzahlen werden immer von einem
$-Zeichen angeführt, die Dezimalzeichen von nichts  und  die  Binärzeichen
von  einem  %).  Das  Hex-system  wird  verwendet,  weil  es  der  Art des
Computers, Zahlen darzustellen am  nächsten  liegt.  Der  Computer  selbst
"denkt" aber klarerweise im Binärsystem, also nur 0 und 1.
Um die verschiedenen Arten der  Adressierung  des  68000ers  verstehen  zu
lernen,   werden   wir  den  Befehl  CLR  verwenden,  der  die  angegebene
Speicherzelle löscht:

	CLR.B	$40000			; Erinnert ihr euch an den Unterschied
							; zwichen .B, .W und .L ?

Diese Instruktion "säubert" die Speicherzelle $40000, es löscht  also  das
Byte Nr. $40000 im Speicher (setzt es auf 0). Das ist der einfachste Fall,
die sogenannte ABSOLUTE Adressierung; d.h., man gibt  direkt  die  Adresse
an,  auf  die  man  ein  CLR  anwenden  will.  Im Assembler sind LABELS in
Gebrauch, die helfen, einen "Ort" im Programm zu  identifizieren,  in  dem
z.B. ein Byte steht, das es anzusprechen gilt. In diesem Fall reicht statt
der Adresse  der Name  des Labels. Der Assembler  kümmert sich dann darum,
das  Label durch die  effektive  Adresse des  Bytes zu  ersetzen. Wenn wir 
unser erstes Listing in etwa so modifizieren:

Waitmouse:
	move.w	$dff006,$dff180	; gibt den Wert von $dff006 in $dff180
							; also das VHPOSR in COLOR0
	btst	#6,$bfe001		; linke Maustaste gedrückt ?
	bne.s	Waitmouse		; wenn nicht, zurück zu Waitmouse und
							; wiederhole
							; (das .s ist äquivalent zu .b in diesem
							; Typ von Anweisung (bne.s = bne.b)
	clr.b	Wert1			; Setze Wert1 auf 0
	rts						; Steige aus

Wert1:
	dc.b	$30				; dc.b bedeutet "Gib folgendes Byte in den
							; Speicher", in diesem Fall wird $30 unter
							; Wert1: gesetzt.

Vor dem Ausstieg mit dem RTS würde das Byte, das durch  das  Label  Wert1:
gekennzeichnet  ist,   auf NULL gesetzt. Diesem Byte wird  in der Fase des
Assemblierens eine ganz bestimmte,  absolute  Adresse  zugewiesen  werden,
z.B.  wenn das Programm mit dem ASMONE assembliert würde, auf eine Adresse
ab $50000, hier würde nach danach ein CLR.B $5001c stehen, also die  reale
Adresse  von  Wert1:  , aber bestimmt nicht CLR.B Wert1, da Wert1: nur ein
Name ist, den der Programmierer dem dc.b $30 gegeben hat. Hier  wird  auch
die  Nützlichkeit  der  Labels  klar,  man  stelle  sich  vor, ein Listing
schreiben zu müssen, bei dem  immer  die  numerischen  Adressen  angegeben
werden  müssen; abgesehen  von der Unbequemlichkeit, wenn man eine Routine
inmitten  der  anderen  einfügt,  müßten  alle  Adressen  neu  geschrieben
werden...  Um zu sehen, auf welche Adressen die Labels gelegt werden, kann
man den Befehl "D" des ASMONE verwenden: z.B. nach  dem  Assemblieren  von
Listing1a.s  kann  man  ein  "D Waitmouse" durchführen, und ihr werdet den
disassemblierten Speicher ab Waitmouse erhalten,  und  im  Listing  werden
nicht die Labels, sondern die reellen Adressen aufscheinen.

Ihr werdet bemerken, daß  in  den  Beispielprogrammen  niemals  numerische
Adressen  auftreten,  aber  immer  nur  Labels. Einzige Ausnahmen sind die
Spezialadressen wie $dffxxx oder $bfexxx. Im letzten Beispiel habe ich ein
dc.b verwendet. Dieser Befehl hat die Aufgabe, bestimmte Bytes einzufügen;
z.B. um $12345678 an einem bestimmten  Punkt  des  Programmes  einzufügen,
verwende  ich  ein  DC,  das  in drei Formen auftreten kann: .B (Byte), .W
(Word), .L (Long):

	dc.b	$12,$34,$56,$78		; in bytes

	dc.w	$1234,$5678			; in words

	dc.l	$12345678			; in longwords 

Diesen Befehl verwendet man auch, um Sätze in den Speicher zu  geben,  wie
etwa  den  Text,  der am Bildschirm ausgegeben werden soll, wenn z.B. eine
Routine PRINT aufgerufen wird, die das  ausdruckt,  was  unter  dem  Label
TEXT: steht:

TEXT:
	dc.b	"Viele schöne Grüße"

oder
	dc.b	'Viele schöne Grüße'

	dc.b	"Viele schöne Grüße",0

Erinnert euch, den Text unter Gänsefüßchen  zu  setzen  und  das  dc.b  zu
verwenden,  nicht  ein  dc.w oder dc.l!! Die Charakter sind ein Byte groß,
und sie entsprechen einem bestimmten Byte: probiert ?"a"  einzugeben,  und
ihr  werdet  merken,  daß es $61 entpricht. Daraus folgt, daß dc.b "a" das
gleiche ist wie  dc.b  $61.  Achtung  aber,  Großbuchstaben  haben  andere
Werte!!  Ein  "A"  hingegen ist $41. Die häufigste Verwendung des dc.b ist
aber jener, Bytes, Words oder noch größere Speicherzonen zu definieren, in
denen unsere Daten festgehalten werden. Wenn man zum Beispiel ein Programm
schreiben möchte, das zählt, wie oft eine Taste gedrückt wird,  müßte  man
ein   Label  definieren, gefolgt von einem - auf NULL gesetzem - Byte, und
jedesmal, wenn ich nun die Taste drücke, 1 dazuzählen. Dafür verwendet man
ein  ADD,  gefolgt  von  dem Label, somit wird das Byte unter dem Label um
eins raufgezählt. Zum Schluß braucht man nur noch den Wert auszulesen:

	; Wenn die Taste gedrückt wurde, dann ADDQ.B #1,ANZAHL, also
	; zähle ein Byte unter dem Label ANZAHL dazu.

ANZAHL:
	dc.b	0

Am Ende des Progammes wird der anfängliche Nuller nicht  mehr  existieren,
statt  dessen  wird die Anzahl der Tastendrucke darinstehen. Ein ähnliches
Beispiel  ist  in  Listing2a.s  enthalten,   es   ist   auch   ausführlich
dokumentiert.  Ich  rate euch, es in einen anderen Textbuffer zu laden: um
einen anderen Buffer auszuwählen müßt ihr nur mit einer F-Taste auswählen,
F1 bis F10. Wenn dieser Text z.B. in Buffer 1 ist, dann drückt F2, und ihr
seid im 2. Um das Listing zu laden, tippt "R" in der Kommandozeile. Danach
Listing2b.s  in  Buffer  3  usw. So habt ihr alles sofort zur Hand. Es ist
aber besser, der LEKTION.TXT zu folgen und dann Schritt  für  Schritt  die
einzelnen   Listings  reinzuholen  und  zu  testen. Danach kehrt  ihr  zur
LEKTION.TXT zurück, fahrt fort bis  zum  nächsten  angedeuteten  Beispiel,
ladet  dieses, führt aus... Das ist, glaube ich, die beste Art, zu lernen:
man macht ein bißchen Theorie und verifiziert das gelernte nebenbei.

Habt ihr Listing2a.s verstanden?

Habt ihr die Wichtigkeit von Byte, Word  und  Longword  bemerkt?  Was  die
Binärzahlen  betrifft,  um Bits zu zählen beginnt man rechts und geht nach
links, also "umgekehrt", und man startet bei 0, nicht bei 1. Ein Byte (das
aus 8 Bit besteht) beginnt bei 0 und geht bis 7. Z.B. diese Zahl:

	%000100010000

Bit 4 und Bit 8 sind "angeschaltet". Um euch ein bißchen unter die Arme zu
greifen, könnt ihr sie auch numerieren:

			 ;5432109876543210	<- intelligente Anwendung des ;
	move.w  #%0011000000100100,$dffxxx

Hier sind Bit 2,5,12 und 13 der WORD angeknipst. Nochmal zum mitschreiben:
ein Byte hat 8 Bit, ein Word 16 (von 0 bis 15), ein Longword 32 (von 0 bis
31).

In der Anweisung

	BTST #6,$bfe001

wird kontrolliert, ob Bit 6 des Byte $bfe001 NULL ist. Wenn es

	;76543210
	%01000000

wäre, dann ist Bit 6 = 1, also ist die Maustaste nicht gedrückt!!

Nochmals, ein BYTE hat 8 Bit: um sie einzeln angeben zu  können,  ist  das
Bit  ganz  rechts  das Bit 0, auch NIEDERWERTIGSTES BIT genannt, oder LSB,
aus dem Englischen (Least Significant Bit),  während  Bit  Nr.  7  das  am
weitesten  links  ist,  und  HÖCHSTWERTIGSTES  heißt (MSB Most Significant
Bit). Am höchstwertigsten deshalb, weil es am meißten zählt,  genauso  wie
beim 1000-DM Schein, bei dem der Einser ganz links um so mehr zählt, desto
weiter links er ist und umsomehr Nullen rechts von ihm sind. Ein Byte kann
als höchstens den Wert 255 annehmen, also %11111111.

Ein WORD hingegen besteht aus 16 Bit, praktisch aus zwei Bytes, und analog
zum Byte startet man rechts mit dem Bit 0, immer dem niederwertigsten, und
endet  ganz  links,  beim Bit 15, dem höchstwertigsten. Ein Word kommt bis
maximal 65536.

Ein  Longword  ist  aus  32  Bit  zusammengesetzt, von 0 bis 31, das sind,
Wunder  Wunder,  4  Bytes,  oder,   noch   größeres   Wunder,   2   Words,
zusammengeklebt. Maximum ist hier 4294967299 ( 4 Milliarden!!!).

Nun geht´s weiter mit den verschiedenen Adressierungsarten: wie wir sahen,
haben  wir  mit  CLR.W $100 die Speicherplätze $100 und $101 gelöscht, auf
NULL gesetzt, also ein Word beginnend bei $100 (da ein Word  aus  2  Bytes
besteht, und   der Speicher in Bytes aufgeteilt ist, killen wir 2 Bytes!).
Auf die gleiche Art kopiert ein MOVE.B $100,$200 den Inhalt von Zelle $100
in Zelle $200. Das kann man auch durch Labels erledigen, ohne die Adressen
spezifizieren zu müssen: MOVE.B LABEL1,LABEL2; also kopiere das Byte unter
LABEL1 nach LABEL2. Es gibt auch Kombinationen davon, so kann ich auch ein
MOVE.B #$50000,LABEL2 machen, das mir einen FIXEN Wert in LABEL2 schreibt.
Wenn  z.B.  LABEL2 auf  Adresse  $60000  steht, dann kopieren wir den Wert
$00050000 nach $60000. Mit einem M $60000 erhalten wir 00 05 00  00.  Wenn
das Symbol des Lattenzaunes (#) vor einer Zahl oder einem Label auftaucht,
dann bedeutet das, daß diese  Zahl  den  Wert  darstellt,  und  nicht  die
Adresse,  an  der  er  liegt, wie es vorkommt, wenn KEIN # davorsteht. Ein
Beispiel:

1)	MOVE.L	$50000,$60000	; die Werte in den Speicherzellen
							; $50000, $50001, $50002 und $50003
							; werden in die Zellen $60000,
							; $60001, $60002 und $60003 kopiert.

2)	MOVE.L  #$50000,$60000	; Diesmal wird in $60000 der Wert nach
							; dem # gelegt, also $50000. Zu beachten,
							; daß hier $50000 als Adresse absolut
							; nichts zu tun hat, die einzige Adresse,
							; die vorkommt, ist $60000.

Wenn Label verwendet werden, ändert sich nichts:

1)	MOVE.L	HUND,KATZE		; Der Inhalt von Longword HUND, also
							; $00123456 wird nach Longword
							; KATZE kopiert ($123456 ist das Erste,
							; das unter dem Label HUND steht).

HUND:
	dc.l	$123456

KATZE:
	dc.l	0

Nach ausführen des Programmes:

HUND:
	dc.l	$123456

KATZE:
	dc.l	$123456

2)	MOVE.L	#HUND,KATZE		; Diesmal wird die Adresse des Labels
							; HUND in das Label KATZE kopiert.

Vor der Ausführung:	; Nehmen wir an, daß das Label HUND: auf Adresse
					; $34500 steht, wenn man also ein M HUND macht,
					; wird man ein 00034500 00 12 34 56 00 00 00 ...
					; erhalten.

HUND:
	dc.l	$123456
KATZE:
	dc.l	0

Nach der Ausführung:

HUND:
	dc.l	$123456
KATZE:
	dc.l	34500	; also wo sich das LABEL im Speicher befindet.

Zu beachten ist, daß wenn versucht worden  wäre,  ein  MOVE.W  #HUND,KATZE
oder  ein  MOVE.B  #HUND,KATZE zu tun, der Assembler einen Fehler gemeldet
hätte, da ADRESSEN IMMER ein LONGWORD groß sind. Im Speicher ist an Stelle
eines  MOVE.L  #LABEL,LABEL  immer  ein  Befehl  wie MOVE.L #$12345,$12345
vorzufinden, der Assembler verwandelt das Label  in  ihre  reale  Adresse.
Listing2b.s veranschaulicht das.

Nun  wenden  wir  uns an die anderen Adressierungsarten mit Registern (sie
sind schwieriger); wie ich schon angedeutet hatte, gibt es 8 Datenregister
und  8  Adressregister, jeweils D0, D1, D2, D3, D4, D5, D6, D7 und a0, a1,
a2, a3, a4, a5, a6 und a7. Das Adressregister a7 wird auch STACK  POINTER,
oder SP, genannt, wir werden es später näher behandeln. Im Moment lasst es
bitte stehen, verwendet nur jene bis a6.  Diese  Adressen  sind  alle  ein
Longword groß, es sind sowas wie kleine Speicher im 68000er, die als Folge
davon, hurtig schnell sind. Mittels Registern kann man viel anstellen, und
deswegen gibt es eine eigene Syntax dafür. Als erstes vorweg: man kann mit
den A-Registern keine Byte-Arbeiten verrichten. Ein MOVE.B  LABEL,A0  gibt
einen  Fehler.  Mit  den  Adress-Registern  kann  man  also als .W oder .L
arbeiten. Die Datenregister sind da flexibler: sie erlauben  .B,  .W  oder
.L.   Die   A-Register   sind,  wie  man  bemerkt,  für  Adressoperationen
prädestiniert, und deswegen gibt es auch eigene Befehle  dafür,  wie  z.B.
LEA,  was  soviel wie "LOAD ENTIRE ADRESS" bedeutet, also lade die gesamte
Adresse ins Register. LEA steht alleine, ohne .b oder .w, denn  es  könnte
nur  .L geben, es sind ja Adressen, deswegen wird es weggelassen. Um einen
Wert in ein Adressregister zu laden gibt es zwei Methoden:

1)	MOVE.L	#$50000,A0	; (oder MOVE.L #LABEL,a0)

2)	LEA	$50000,A0		; (oder LEA LABEL,A0)

Wenn man die erste Methode auf Daten- wie auf Adressregister anwenden kann
(Beispiel:   move.l   #$50000,d0   -   move.l   #$50000,LABEL   -   move.l
#$LABEL,LABEL...), so ist die zweite auf Adressen beschränkt.

P.S: Ob man nun move.l #$50000,d0 oder  MOVE.L  #$50000,D0  schreibt,  ist
egal,  auch  MoVe.L  #$50000,d0  ist  identisch,  das Resultat ändert sich
nicht, nur ästhetisch  ist  eine  Version  der  anderen  zu  bevorzugen...
Anderes  gilt für das Label: zwar können sie in einem Punkt des Programmes
groß geschrieben sein, weiter später klein, etc.  aber  nur,  weil  es  in
den Preferences des TRASH´M-ONE so eingetragen  ist.  Diese Option ist die
"UCase = LCase" im Menü "Assembler/Assemble..", was  soviel  bedeutet  wie
"Upper  case  =  Lower  case", praktisch "Groß ist gleich Klein". Wenn ihr
diese Option ausschaltet, dann  wird  bei  der  Erkennung  des  Labels auf
Groß-Kleinschreibung geachtet, HUND: wird also etwas anderes wie Hund oder
HuNd sein...

Die zweite Methode kann  nur  auf  Adressregister  angewandt  werden,  und
intuitiv  kann  man  sich  denken,  daß  das die schnellere Art sein wird:
richtig. Erinnert euch deshalb, daß wenn ihr eine Adresse in ein  Register
wie  a0,  a1...  geben müßt, ihr den Befehl LEA verwenden solltet, gefolgt
von der Adresse OHNE vorangehendem  Lattenzaun  (#)  und  dem  anvisierten
Register. Schaut die folgenden zwei Beispiele genau an:

1)	MOVE.L	$50000,a0	; gib in a0 den ab Adresse $50000
						; ($50000 + $50001 + $50002 + $50003,
						; ein Longword = 4 Byte!) enthaltenen
						; Wert

2)	LEA	$50000,a0		; gib die Zahl $50000 in a0

Passt also gut auf, wenn ihr mit MOVE mit und ohne "#" arbeitet, vor allem
am  Anfang  wird  es  oft  passieren,  daß  ihr die Adresse mit einem Wert
verwechselt, weil das # fehlt, oder umgekehrt.  Den  Unterschied  versucht
auch Listing2c.s nochmals zu vertiefen.

Mit  den Adressregistern sind verschiedene Arten der Adressierung möglich:
Zu Beginn analysieren wir diese zwei Instruktionen:

	move.l	a0,d0		; gib die in a0 enthaltene Zahl ins Register d0
	move.l	(a0),d0		; gib das Longword, das an Adresse a0 zu finden
						; ist, in d0

Die Adressierung mit den Klammern nennt man INDIREKT, da nicht der Wert in
a0 kopiert wird (Direkt...), sondern der, der an der Adresse steht, die in
a0 enthalten ist. Ein praktisches Beispiel ist in Listing2d.s zu finden.

Durch Verwendung der indirekten Adressierung kann  man  auf  die  Register
INDIREKT  zugreifen,  z.B. indem die Adresse der Maustaste und der Farbe 0
in  die  Register  gegeben  wird,  kann  man  das  Listing  von   Lektion1
neuschreiben. Das wurde in Listing2e.s gemacht.

Machen  wir  die  letzten  Beispiele  zur indirekten Adressierung, um noch
eventuelle Zweifel zu beheben:

	move.l	a0,d0		; kopiert den Wert in a0 ins Register d0 
	move.b	(a0),d0		; kopiert das Byte, das an Adresse a0 steht, 
						; in das Register d0
	move.w (a0),(a1)	; kopiert das Word, das an Adresse a0 steht,
						; in die Adresse, die in a1 angegeben ist
						; (und in die folgende, denn ein Word besteht
						; ja aus zwei Bytes, also zwei Adressen !)
	clr.w	(a3)		; Löscht das Word (die zwei Bytes), ab der
						; Adresse a3, also Adresse a3 und Adresse a3+1
	clr.l	(a3)		; Wie oben, nur werden Adresse a3, a3+1,
						; a3+2 und a3+3 auf NULL gesetzt.
	move.l	d0,(a5)		; der Wert in d0 wird in die Adresse kopiert,
						; die in a5 steht. D.h. an Adresse a5 und die
						; drei folgenden wird der Inhalt von d0
						; geschrieben, insgesamt 4 Bytes, LongWord.

Also nochmal, bitte beseitigt alle Zweifel,  die  die  Adressierungsarten,
die bis hierher behandelt wurden, betreffen! Eventuell schaut euch nochmal
die Listings bis Listing2e.s durch, da  die  folgenden  Adressierungsarten
auf die bisherigen aufbauen.

Jetzt  ist´s  wieder  mal  Zeit  für  eine  Kundgebung:  das hier wird der
abstrakteste Teil von Lektion2, denn hier werden  die  letzten  Arten  der
Adressierung  aufgezählt,  aber  ich  versichere  euch,  schon ab Lektion3
werdet ihr das angeeignete Wissen einsetzen, und  ihr  werdet  die  ersten
Videoeffekte  mit dem Copper starten!! Also, dieser Teil überstanden, wird
alles sehr viel praktischer: jeder Erklärung wird ein neuer  Spezialeffekt
oder  eine  hypergeile  Farbe zugeordnet sein. Also, haut jetzt noch rein,
und gebt nicht auf, weil es langweilig erscheint, denn ich selbst hatte an
diesem  Punkt  alles  Fallen  gelassen,  als  ich  das erste Mal Assembler
lernte, genauso, weil  auch  ich  total  durcheinander  war  von  all  den
Befehlen und Klammern, die dann alles so ins Chaos stürzten. Aber wenn ihr
mal die Befehle gelernt habt, dann werdet ihr abzischen wie  eine  Rakete,
und  von selbst weiterlernen, indem ihr Listings von hier und da durchlest
und durchstrebt. Die Schritte werden immer größer werden, genauso wie  die
Regeln  bei einer Sprotart lernen: jemand, der das Set der 68000er Befehle
nicht kennt ist gleich mit einem, der z.B. die Regeln beim  Fußball  nicht
kennt:  wenn  er  einem  Spiel zusieht (Listing...), wird er sich wundern,
wieso die Verrückten alle auf den Ball reindreschen, und er wird  sich  zu
Tode   langweilen,   aber   wenn  er  weiß,  wie  die  Spielregeln  lauten
(Adressierung etc), wird er die Fasen im Spiel verstehen  und  die  Tricks
kapieren (z.B. die Programmiertricks bei den Grafikregistern).

Schauen wir uns zwei weitere Adressierungsarten an:

	lea	OPA,a0			; gibt in a0 die Adresse von OPA:
	MOVE.L	(a0)+,d0	; gibt in d0 den .L-Wert (Long), der
						; an der Adresse a0 enthalten ist, also
						; $3231020 ( genau das gleiche wie ein
						; Move.L (a0),d0 )
						; DANACH aber SUMMIERE 4 ZUM WERT IN a0 DAZU
						; "POST-INKREMENTAL"
						; praktisch "zeigen" wir jetzt auf das folgende
						; Longword im Speicher
						; Wenn es ein move.w (a0)+,d0 gewesen wäre, dann
						; würde danach zum a0 nur 2 dazugezählt (ein Word=2)
						; bei einem Move.b nur eins (ein Byte...)
	MOVE.L	(a0)+,d1	; das Gleiche: kopiert in d1 den Long-Wert,
						; der in der Adresse a0 enthalten ist, die
						; nun die Adresse OPA + ein Longword ist, also
						; OPA + 4, -> $13478
	rts					; RAUS!

OPA:
	dc.l	$3231020,$13478

	END

Wir können diesen Typ der Adressierung folgendermaßen übersetzen:

1)	Move.L	(a0)+,LABEL

ist äquivalent mit:

1b)	Move.L	(a0),LABEL	; kopiert ein Longword von der Adresse a0
						; in das LABEL.
	ADDQ.W	#4,a0		; zählt zu a0 4 dazu (.L=4)
						; Bemerkung: wenn eine Zahl kleiner als
						; 9 dazugezählt wird, verwendet man den
						; Befehl ADDQ, weil er für kleine Zahlen
						; zurechtgeschnitten ist und daher schneller!
						; Weiters, wenn zu Adressregister eine Zahl
						; kleiner als $FFFF (Word) summiert wird, kann
						; ein .W an Stelle des .L verwendet werden, es
						; wird trotzdem immer auf das gesamte Longword
						; zugegriffen.

Das Selbe:

2)	MOVE.W	(a0)+,LABEL

Bedeutet soviel wie:

2b)	Move.W	(a0),LABEL	; kopiert ein Word von Adresse a0 ins LABEL
	ADDQ	#2,a0		; summiert 2 zu a0 (.W = 2 Bytes)

Nochmal das Geliche:

3)	MOVE.B	(a0)+,LABEL

Ist gleich dem:

3b)	MOVE.B	(a0),LABEL	; kopiert das Byte an der Adresse a0 ins LABEL
	ADDQ	#1,a0		; Zählt 1 zu a0 dazu (.B = 1 Byte)

Also, zusammenfassend kann man sagen, daß die indirekte  Adressierung  mit
Post-Inkrementierung  mehr  oder  weniger  mit einem  Fließband verglichen
werden  kann,  bei  dem  der  Arbeiter  zuerst  die  Arbeit  am  Werkstück
verrichtet  (MOVE),  und  jedesmal,  wenn er fertig ist, das Fließband mit
einem Pedal (dem +) nach vorne weiterfahren läßt (die Adresse, auf die  a0
zeigt). Ein Beispiel anhand einer Schleife wird vielleicht klarer wirken:

Anfang:
	lea	$60000,a0		; Hier beginnt der Putztrupp
	lea	$62000,a1		; und hier endet er

CLELOOP:
	clr.l	(a0)+		; löscht (setzt auf 0) ein Long an der Adresse, die
						; in a0 steht, und erhöhe a0 um ein long, also
						; um 4 Byte, anders ausgedrückt, lösche ein Long
						; und geh zum Nächsten weiter
	cmp.l	a0,a1		; ist a0 bei $62000 angekommen; oder: ist a0 gleich
						; a1?
	bne.s	CLELOOP		; wenn nicht, mache einen weiteren Durchgang, bei
						; CLELOOP startend.
	rts

Wie man sieht, "putzt" dieses Programm den Speicher von Adresse $60000 bis
$62000, indem es ein CLR (a0)+ verwendet, das wiederholt wird, bis wir
nicht zur gewünschten Adresse angekommen sind. Ein ähnliches Beispiel
ist Listing2f.s.

Nun kommen wir zur Adressierung mittels Pre-Dekrement, also das Gegenteil
von dem, das ich gerade beschrieben habe, denn anstatt die Adresse im
Register zu erhöhen, nachdem die Operation durchgeführt wurde, wird hier
zuerst dekrementiert (abgezogen), und DANN kommt die Operation. Beispiel:

	lea	OPA,a0			; gibt in a0 die Adresse von OPA:
	MOVE.L	-(a0),d0	; a0 wird dekrementiert, also um 4 herunter
						; gezählt (in diesem Fall um 4, da es sich
						; um ein .L handelt, bei einem .W=2, .B=1)
						; danach wird in d0 der Wert kopiert, der
						; sich an der nun entstandenen Adresse
						; befindet, also OPA-4, => $12345678
	rts					; im Register bleibt nun der anfängliche
						; Wert - 4. Bei einem move.w -(a0),d0 würde
						; vorher dem a0 2 abgezogen (-> .W!!), DANACH

	dc.l	$12345678  ; das Move auf der errechneten Adresse ausgeführt,
OPA:				 ; bei einem .B würde dem a0 eins abgezogen, a0
	dc.l	$ffff0f0f  ; würde nun auf die vorhergehende Adresse "zeigen"

Wir können diesen Typ von Adressierung mit zwei geteilten Operationen
gleichsetzen:

1)	MOVE.L	-(a0),LABEL

entspricht:

1b)	SUBQ.W	#4,a0		; Ziehe 4 von a0 ab (= .L)
						; wichtig: wenn Zahlen kleiner als 9
						; abgezogen werden, sollte das SUBQ dem
						; SUB vorgezogen werden, es ist schneller
	MOVE.L	(a0),LABEL	; kopiert den Wert, der an Adresse a0 steht,
						; in das LABEL ( an seine Adresse... )
Dementsprechend:

2)	MOVE.W	-(a0),LABEL

ist gleich mit:

2b)	SUBQ.W	#2,a0		; subtrahiere 2 von a0 (.W=2)
	MOVE.W	(a0),LABEL	; kopiert das Word, das sich an  Adresse a0
						; befindet, in das LABEL
Und das Letzte:

3)	MOVE.B	-(a0),LABEL

heißt soviel wie:

3b)	SUBQ.W	#1,a0		; Zieht vom Wert in a0 eins ab (.B=1)
	MOVE.B	(a0),LABEL	; Kopiert das Byte an Adresse a0 ins LABEL

Zusammenfassend,  mit dem Beispiel des Fließbandarbeiters von vorhin, kann
man sich vorstellen, daß die Adressierung mit Pre-Dekrement  so  aussieht:
Zuerst  verschiebt  er  das Fließband rückwärts (a0) mit seinem Pedal (-),
DANN   erfolgt   das   MOVE   oder   die   gewünschte  Operation.   Ein
Schleifenbeispiel:

Anfang:
	lea	$62000			; hier beginne ich
	lea	$60000			; und hier ende ich
CLELOOP:	
	clr.l	-(a0)		; verringere a0 um ein Long (4 Byte) und
						; lösche dann die daraus resultierende
						; Speicherzelle, oder anders: geh´ zum
						; vorherigen Long und lösche es
	cmp.l	a0,a1		; ist a0 bei $60000 angekommen, ist also a0=a1?
	bne.s	CLELOOP		; wenn nicht, wiederhole alles ab CLELOOP
	rts

Wie man sieht, "putzt" dieses Programm den Speicher von der Adresse $62000
bis zur Adresse $60000, indem es ein clr -(a0) verwendet, bis es nicht zur
gewünschten Adresse heruntergekommen ist (Eben rückwärts, bei einem  (a0)+
begannen  wir  bei  $60000  und kamen in 4er Schritten bis $62000, mit dem
-(a0) hingegen beginnen wir bei $62000 und  zählen  in  4er-Schritten  bis
$62000 herunter).
Schaut  euch  Listing2g.s  und  Listing2h.s  an,  um  die   letzten   zwei
Adressierungsarten besser zu verstehn.

Jetzt lernen wir, wie man die Adressierungsdistanz verwendet:  ein  MOVE.L
$100(a0),d0  kopiert  den Inhalt, der in Adresse a0+$100 enthalten ist, in
d0. Wenn z.B. a0  die  Adresse  $60200  enthält,  dann  kommt  in  d0  das
Longword, das ab Speicherzelle $60300 enthalten ist ($60200+$100). Auf die
gleiche Art und Weise funktioniert ein MOVE.L -$100(a0),d0, in d0 wird der
Wert  von a0-$100 landen, also das Long ab Adresse $60100. Zu beachten ist
aber, daß sich der Wert  in  a0  NICHT  ändert,  der  Prozessor  berechnet
jedesmal  die  Adresse neu, auf der es zu arbeiten gilt, indem er den Wert
vor den Klammern zur  Adresse  in  den  Klammern  summiert.  Die  maximale
"Distanz"  (oder  Offset), die erreicht werden kann, liegt zwischen -32768
und 32768 (-$7FFF, $8000). Ein Beispiel dafür gibt´s in Listing2i.s.

Die letzte Adressierungsart ist die folgende:

	MOVE.L	50(a0,d0),Label

Diese Art hat sowohl eine Adressierungsdistanz (den 50er), wie auch  einen
INDEX  (das  d0):  die  Distanz  und  und  der  Inhalt  von d0 werden alle
summiert, um die Adresse zu  definieren,  von  der  kopiert  werden  soll.
Praktisch gesehen ist es das gleiche wie die Adressierung mit Distanz, nur
daß hier auch noch der Inhalt des Registers d0 hinzugefügt  wird,  das  in
diesem  Fall  aber  von  minimal -128 bis maximal +128 geht. Ich will euch
nicht mit weiteren Beispielen  über  diese  Adressierung  langweilen,  ihr
werdet  damit  besser  vertraut  werden,  wenn  sie später in den Listings
vorkommen.

Um  die LEKTION2  abzuschließen, die, wenn  ihr sie  gut durchgekaut habt, 
euch in die Lage versetzt, ASM-Listings zu  lesen und zu verstehen, ist es
unerläßlich, den DBRA-Zyklus zu erklären.  Er  wird  sehr  oft  verwendet:
durch  Verwenden  eines  Datenregisters  kann  man  gewisse Befehle öfters
ausführen lassen, es reicht, in das Register (d0, d1,...) die Anzahl-1  zu
geben. Z.B. kann die Routine, die den Speicher mit dem CLR.L (a0)+ löscht,
so modifiziert werden, daß sie mit einem DBRA-Loop  funktioniert  und  den
Putzzyklus so oft aufruft, wie wir es wünschen:

Anfang:
	lea	$60000,A0			; Anfang
	move.l	#($2000/4)-1,d0	; Gib in d0 die Anzahl der notwendigen
							; Durchgänge, um $2000 Bytes zu löschen:
							; $2000/4 (also dividiert durch 4, da jedes
							; CLR.L 4 Bytes löscht, eben ein Long). Alles
							; minus 1, weil der Loop im Endeffekt einmal
							; mehr ausgeführt wird.
CLEARLOOP:
	CLR.L	(a0)+
	DBRA	d0,CLEARLOOP
	rts

Diese Routine löscht den Speicher von $60000 bis $62000, genauso  wie  das
Beispiel  von vorher, das das CMP verwendete, um a0 mit a1 zu vergleichen,
um zu sehen, ob wir angekommen sind, wo wir wollten. In diesem  Fall  wird
das CLR 2047 mal ausgeführt, probiert mal, in der Kommandozeile des ASMONE
?($2000/4)-1 zu tippen. Das DBRA funktioniert  folgendermaßen:  Das  erste
Mal  kommt in d0 z.B. der Wert 2047, das CLR wird ausgeführt, und dann, am
DBRA angekommen, wird d0 um eins verringert, der Prozessor springt zum CLR
zurück.  Das wiederholt sich solange, bis d0 "verbraucht" ist, bis es also
NULL enthält. Es muß die  Anzahl  der  Durchgänge  minus  eins  eingegeben
werden, weil beim ersten Durchgang das d0 nicht dekrementiert wird.

Als  letztes  Beispiel  studiert euch Listing2l.s, das Subroutinen mit BSR
aufruft und DBRA-Schleifen in Aktion zeigt. Es wird nützlich sein, um  die
Struktur komplexerer Programme zu verstehen.

Zum  Abschluß  möchte  ich  euch noch auf den Unterschied zwischen BSR und
BEQ/BNE hinweisen: im Falle  von  BSR  Label  springt  der  Prozessor  zur
Routine,  die  bei Label liegt, und verharrt darin, bis er ein RTS findet,
das ihn veranlasst, zur Instruktion direkt unter dem  BSR  zurückzukehren.
Man  kann  also  sagen,  es  wird  eine UNTERROUTINE ausgeführt, d.h. eine
Routine, die in Mitten einer anderen aufgerufen wird:

Hauptprogramm:
	move.l	ding1,d0
	move.l  ding2,d1

	bsr.s	Restposten

	move.l	ding3,d2
	move.l	ding4,d3

	rts	; ENDE DES HAUPTPROGRAMMES, DER HAUPTROUTINE
		; ZURÜCK ZUM ASMONE

Restposten:
	move.l  nixwert,d4
	move.l  nixwert2,d5

	rts	; ENDE DER UNTERROUTINE, KEHRE ZU "move.l ding3.d2"
		; ZURÜCK, ALSO UNTER DAS "bsr.s Restposten"

Im Falle einer BNE/BEQ  -  Verzweigung hingegen wird entweder der eine Weg
oder der andere eingeschlagen:

Hauptprogramm:
	move.l  ding1,d0
	move.l  ding2,a0

	cmp.b	d0,a0
	bne.s	weg2

	move.l	ding3,d1

	cmp.b	d1,a0
	beq.s	weg3

	move.l	ding4,d0

	rts	; ENDE DER HAUPTROUTINE , ZURÜCK ZUM ASMONE

weg2:
	move.l  nixwert,d5
	move.l  nixwert2,d6

	rts	; ENDE DER ROUTINE; ZURÜCK ZUM ASMONE, NICHT unter das bne!!!
		; Hier haben wir diesen Weg ausgesucht, und wenn ein RTS
		; auftaucht, geht´s zurück zum ASMONE!!!

weg3:
	move.l  nixwert3,d1
	move.l  nixwert4,d2

	rts	; ENDE DER ROUTINE; ZURÜCK ZUM ASMONE, NICHT unter das beq!!!
		; Auch hier wurde dieser Weg gewählt, und nach dem RTS
		; geht´s zurück zum ASMONE!!!

Das gleiche gilt für das BRA Label, das  soviel  bedeutet  wie  SPRING  ZU
Label,  äquivalent  zu JMP, es ist wie ein Zug, der zu einer Weiche kommt,
der kommt auch nicht zurück, wenn  das  Gleis  fertig  ist!  Am  Ende  des
Gleises  angekommen ist Schluß, kein beamen wie bei Raumschiff Enterprise,
das uns zurück bringt.

Für eine letzte Präzisierung über die Register, seht  euch Listing2m.s an.

Um LEKTION3.TXT zu laden, könnt ihr zwei  Methoden  wählen:  entweder  "R"
tippen  und  im Requestorfenster einen Text auswählen (in diesem Fall df0:
LEKTIONEN/LEKTION3.TXT), oder, wenn ihr in der richtigen  Directory  seid,
einfach "R LEKTION3.TXT". Um Directory zu wechseln, "V df0:LEKTIONEN".
