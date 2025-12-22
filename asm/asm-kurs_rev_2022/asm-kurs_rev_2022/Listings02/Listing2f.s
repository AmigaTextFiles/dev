
; Listing2f.s

Anfang:
	lea	START,a0	; Gib in a0 die Startadresse, d.h. gib in
					; a0 die Adresse von START, also WO START
					; sich befindet, nicht seinen INHALT!!
	lea	THEEND,a1	; Gib in a1 die Endadresse, also gib
					; in THEEND das Ende der 40 Byte, denn das
					; Label befindet sich unter den 40 Bytes
					; Nun wird ALLES, was sich zwischen den Label
					; START und THEEND befindet, gelöscht. Dafür sorgt
					; die CLELOOP: Schleife, seien es nun 40 Byte oder
					; mehr, auch wenn sich dazwischen Befehle befinden
					; würden.

CLELOOP:
	clr.l	(a0)+	; Löscht das Long, das sich in Adresse (a0) befindet,
					; danach zählt es 4 Byte zu a0 dazu (Long!!!)
					; Achtung! Das ist eine indirekte Adressierung, in
					; der nicht das Register a0 gelöscht wird, sondern den
					; Inhalt, der sich auf der enthaltenen Adresse befindet,
					; hier vier $fe pro Durchgang ($fe ist eine Zufallszahl,
					; die ich verwende, grad um sie von den Nullen zu
					; unterscheiden!) Um zu beweisen, daß ich einen Teil des
					; Speichers lösche, der mit $fe gefüllt ist;
					; Da ein + nach der Klammer steht, wird nach jedem Aufruf
					; von a0 dieses um 4 erhöht, es positioniert sich also
					; auf die nächste Zelle, die es zu löschen gilt.
					; Beim ersten Durchgang werden die ersten 4 $fe unter Start 
					; gelöscht, beim nächsten die darauffolgenden und so weiter.
					; Zu Beachten ist, daß nur a0 raufzählt, a1 bleibt stehen.
	cmp.l	a0,a1	; Ist a0 = a1, ist also a0 bei THEEND angekommen?
	bne.s	CLELOOP	; wenn nicht, zurück zu CLELOOP
	rts				; Fertig, zurück zum ASMONE

START:
	dcb.b	40,$fe	; Der Befehl DCB dient dazu, einen Teil des Speichers
					; mit einer bestimmten Anzahl von Bytes, Words oder
					; Longwords zu füllen, die alle gleich sind (Hier: $fe)
					; Er ist ähnlich dem Befehl DC.B, nur hätten wir für
					; 40 Bytes dc.b $fe, $fe, $fe, $fe ... tippen müßen!
					; Mit dem DCB.B 40,$fe geht´s einfacher: GIB AB HIER
					; 40 BYTES VOM TYP $FE IN DEN SPEICHER.
THEEND:				; Dieses Label markiert das Ende der 40 Bytes...
	dcb.b	10,0	; Aus purem Spaß hänge ich 10 Nuller an...

	end

Achtung!! Mit LEA START,a0 wird in a0 die Adresse des ersten  der  vierzig
$fe-Bytes  gegeben,  es  enthält  nicht  40  Bytes!!  Die Labels sind eine
Konvention, die in der Programmierung verwendet werden, um sich im Listing
orientieren  zu  können,  sie  dienen  dazu,  den verschiedenen Teilen des
Programmes einen Namen zu geben, seien es nun Befehle  oder  anderes,  und
beim Aufruf derer beziehen wir uns GENAU AUF DEN PUNKT, AN DER SIE STEHEN,
also die Adresse, auf der die Label stehen. Um  Konfusionen zu  vermeiden,
stellt euch mal vor, wieso eigentlich Labels erfunden wurden: würde es sie
nicht geben, müßten wir jedes Byte numerieren, also mit  Adressen  denken,
also  statt  ein BNE.S CLELOOP müßten wir z.B. ein BNE.S $20398 schreiben,
also die Adresse, bei der der  Loop  beginnt,  wo  sich  das  clr.l  (a0)+
befindet. Genauso, statt LEA START,a0, wäre ein LEA $123456,a0 nötig, also
die Adresse, von wo ab zu Löschen ist, angenommen,  die  Startadresse  sei
$123456.  Stellt  euch  dann  auch  noch  vor,  wir  müßten  auch nur eine
Instruktion im Loop einfügen! Jetzt wäre START nach vorne verrutscht,  und
wir  hätten  statt  dem  LEA  $123456,a0 die nun gültige Adresse einsetzen
müßen. Ein Ding  zum  Kinder  kriegen!!  Wenn  wir  aber  jedem  PUNKT  IM
PROGRAMM,  der  uns interessiert, einen Namen geben, so wie man einem Fluß
auch einen Namen gibt, dann beschreibt man damit die Adresse, bei  der  er
beginnt  (und  NICHT  seinen  INHALT!!). Wenn ich LEA START,a0 mache, dann
befindet sich in  a0  nicht  der  Inhalt  von  Start!!  In  der  Fase  des
Assemblierens  kümmert  sich  dann  der Assembler darum, die Label mit der
realen Adresse zu ersetzen, egal ob sie inzwischen verstellt  wurde  (z.B.
etwas  eingefügt...).  Dieses  Programmchen  macht  Großputz zwischen  der
Adresse in a0 und der in a1: Um das zu überprüfen, assembliert mit  A  und
und dann führt ein M START aus (BEVOR ihr mit J das Programm startet). Ihr
werdet ab diesem Punkt die berühmt-berüchtigten $fe finden,  und  zwar  40
Stück!  Als  weitere  Probe,  macht ein D Anfang, und ihr werdet in a0 die
gleiche Zahl bemerken, wie sie auch neben dem ersten  LINE_F  steht,  also
die  Adresse des ersten $fe, das als LINE_F vom ASMONE interpretiert wird.
In a1 steht die Adresse von THEEND, wie ihr seht das Ende  der  $FEFE  und
der  Anfang der 0000000. Nun startet mit J: wenn ihr ein D Anfang eingebt,
werdet ihr feststellen, daß die Bytes gelöscht wurden (und nun  als  ORI.B
#$0,d0 interpretiert werden). Weiters könnt ihr es mit M START überprüfen,
und euch wird auch aufgefallen sein, daß die Adresse in a0 gleich  der  in
a1  ist.  JETZT  WERDE  ICH  EUCH  EINE  SEHR  NETTE  UTILITY  DES  ASMONE
BEIBRINGEN, DIE DAS KONTROLLIEREN EURER PROGRAMME VEREINFACHT: anstatt  A,
probiert   man  AD!!!  Damit,  nach  dem  Assemblieren,  startet  ihr  den
DEBUGGER!!! Nun RUHE UND KÜHLEN KOPF BEWAHREN: Euch wird  das  Listing  so
erscheinen, wie ihr es erstellt habt, und auf der rechten Seite werdet ihr
alle Register unter Kontrolle haben, die in einer Kolonne erscheinen:  d0,
d1, d2,...,a0, a2, a3,...etc. Die erste Zeile des Listings, in diesem Fall
das LEA START,a0, wird in Negativ erscheinen, also  ein  Balken  wird  sie
hervorheben.  Das  zeigt  an,  auf  was  für  einer  Linie  wir uns gerade
befinden. Nun könnt ihr die Ausführung  des  Programmes  Zeile  für  Zeile
nachvollziehen  und  mitverfolgen,  und gleichzeitig kontrollieren, was in
den Registern passiert!!!  In  der  letzten  Zeile  unten  sieht  man  die
disassemblierten Befehle wie mit dem D-Befehl, einen nach dem anderen, mit
seiner Adresse zu seiner linken, gefolgt von der Instruktion in BYTE-Form,
gefolgt  von  der  Instruktion  als BEFEHL (z.B. CLR.L (a0)+, das in Bytes
$4298 ist). Um die Befehle nacheinander "abzuspielen", um  sich  also  zum
nächsten zu begeben, drückt die Pfeil-nach-Rechts-Taste. Ihr werdet sehen,
wie nach der Abarbeitung des ersten Befehles in a0 die Adresse  von  START
kommt,  während  nach  dem zweiten in a1 die Adresse von THEEND erscheint.
Einmal in der Schleife eingetreten, werdet ihr sehen, wie sich die Adresse
in   a0   jedesmal   um  4  hochschraubt,  und  wie  jedesmal  zu  CLELOOP
zurückgesprungen wird, wenn a0 noch nicht gleich a1 ist (BNE.S). Einmal am
RTS  angekommen,  ist  alles vorbei, oder wenn ihr wollt auch früher, wenn
ihr ESC drückt. Wenn ihr mitzählt, wie  oft  das  CLR.L  (a0)+  ausgeführt
wird,  werdet  ihr 10 zählen. Das stimmt, denn wenn jedesmal 4 Bytes (=ein
Long) gelöscht werden, dann ist mit 4*10=40 alles  sauber.  Probiert,  das
CLR.L (a0)+ mit einem CLR.W (a0)+ zu ersetzen, ihr werdet feststellen, daß
20 Durchgänge notwendig sind (2*20=40...), um ans Ende zu kommen,  und  a0
wird  jedesmal  um  2  hochgezählt. Mit einem CLR.B (a0)+ werden 40 Zyklen
gebraucht, und a0 wird jedesmal um eins erhöht. Um alles  noch  klarer  zu
bekommen,  ladet  die  Listings, die bisher behandelt wurden, nochmal, und
checkt sie mit AD durch. Bemerkung: der  DEBUGGER  kann  nicht  bei  allen
Programmen   angewandt   werden,   denn  solche,  die  das  Betriebssystem
abschalten, schalten auch den Debugger ab!

Um euch zu beweisen, daß wirklich alle Bytes zwischen START:  und  THEEND:
gelöscht  werden,  ob  es  nun  40,  200  oder  mehr  sind,  testet  diese
Abänderung:

START:
	dcb.b	80,$fe	; Gib hier 80 Bytes "$fe" in den Speicher

THEEND:				; Dieses LAbel markiert das Ende der 80 Bytes

Wenn ihr die gleichen Durchgänge mit AD macht, werdet ihr feststellen, daß
genau  doppelt soviele Durchgänge nötig sind, und daß die Distanz zwischen
START: und  THEEND:  sich  auch  verdoppelt  hat.  Um  sich  das  bildlich
vorzustellen,  stellt  euch  vor,  das  Programm  sei eine Straße, bei der
START: die Hausnummer 10 hat, und THEEND 40 Bytes weit weg liegt, also auf
Hausnummer  50  (10+40=50). Wenn nun der Bewohner von START: seinen Freund
von THEEND: besuchen will, muß er 40 Schritte  machen,  jedes  einen  Byte
lang.  Wenn  START: aber immer 10 darstellt, die Entfernung jetzt statt 40
80 Byte geworden ist, dann wird sich der Freund auf Adresse  90  befinden,
und START: muß 80 Schritte zu einem Byte machen, um ihn zu treffen.

