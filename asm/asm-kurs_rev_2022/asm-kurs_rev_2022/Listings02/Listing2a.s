
; Listing2a.s - Dieses Programm registriert im Byte "Zaehler", wie
; oft die  rechte  Maustaste  gedrückt wurde, oder, besser noch, wie lange
; sie gedrückt wurde, denn wenn sie gedrückt bleibt, zählt der Zähler
; trotzdem weiter, um auszusteigen linke Maustaste

Anfang:
	btst	#2,$dff016		; POTINP - rechte Maustaste gedrückt?
	beq.s	Dazu			; Wenn ja, springe zu Dazu
	btst	#6,$bfe001		; Linke Maustaste gedrückt?
	bne.s	Anfang			; Wenn nicht, springe zu Anfang zurück
	rts						; Wenn hingegen ja, dann steige aus!

Dazu:
	move.b	Zaehler,$dff180 ; Gib den Wert von Zaehler in Farbe 0
							; (COLOR0)
	addq.b	#1,Zaehler		; Inkrementiere Zaehler um 1 (zählt 1 dazu)
	bra.s	Anfang			; Springe (immer) zu Anfang zurück

Zaehler:
	dc.b	0				; Dieses Byte ist unser Zähler

	END						; Mit END wird das Ende des Listings
							; markiert, alles, was folgt, wird vom
							; Assembler nicht mehre interpretiert

Bemerke: POTINP ist der Name des Registers $dff016. Der (großgeschriebene)
         Name  nach dem Strichpunkt  bezieht  sich immer  auf ein $dffxxx-
         Register.

In diesem Beispielprogramm erkennt man die Verwendung der Label sei es als
Kennzeichnung  von  Befehlen  (bne.s Anfang, bra.s Anfang...), wie auch um
Bytes  anzusprechen  (addq.b  #1,Zaehler).  Es  besteht  kein  Unterschied
zwischen  der  Label Anfang und der Label Zaehler: beides sind Label, also
NAMEN, DIE EINEN BESTIMMTEN PUNKT IM SPEICHER MARKIEREN,  OB  ES  NUN  EIN
BYTE ODER EINE REIHE VON BEFEHLEN ODER SONST ETWAS IST. DAMIT KANN MAN DIE
BEFEHLE UNTER DEM LABEL AUSFÜHREN ODER AUCH NUR DAS BYTE  NACH  DEM  LABEL
VERÄNDERN.  Ich habe bemerkt, daß es vielen Schwierigkeiten bereitet, sich
mit dieser Logik vertraut zu machen. Machen wir einige  Beispiele  um  die
Rolle  der  Labels  genauer  zu verstehen: stellt euch vor, ihr habt einen
kleinen Schrebergarten, der eingezäunt ist, und in dessen  Mitte  verläuft
ein   kleiner  Weg.  Nachdem  ihr  ihn  umgegraben  habt,  beschließt  ihr
Erdbeeren, Kohl, Rüben und Petersilie zu pflanzen, also teilt ihr  ihn  in
vier gleich große Rechtecke ein und streut den Samen aus. Um zu wissen, wo
das  verschiedenen  Grünzeug  wächst,  verwendet   man   meistens   solche
Plastiktäfelchen  mit  einem  Spitz  unten  dran,  auf  dem  ein  Foto der
Erdbeere/Kohl... ist. Man steckt sie dann  in  die  Erde,  ihr  kennt  die
Dinger   doch..?   Also  pflanzen  wir  sie:  Auf  einem  Täfelchen  steht
ERDBEEREN:, auf dem anderen KOHL:, dem nächsten RUEBEN:  und  dem  letzten
PETERSILIE:.  Wir  haben  die  Etiketten  so in die Erde gesteckt, daß sie
jeweils den ANFANG des abgebildeten Gemüses markieren, und somit  zugleich
das ENDE des vorherigen.

ERDBEEREN:          KOHL:            RUEBEN:         PETERSILIE:
   \/                \/                \/                \/
    ..................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-_-_-_-_-_-_-_-_-_


Wenn wir die "...." als Erdbeeren ansehen, den Kohl als "oooo", die  Rüben
als  "^^^^" und die Petersilie als "-_-_", dann wird ein "BNE KOHL" soviel
bedeuten wie "GEHE ZUR ETIKETTE KOHL:", und nicht "renn´ mitten  ins  Beet
hinein",  oder  "gehe  in  Richtung  KOHL:".  Einzi  und  allein "GEHE ZUM
TÄFELCHEN MIT DER AUFSCHRIFT KOHL: UND  FÜHRE  DIE  BEFEHLE,  DIE  FOLGEN,
AUS",  in  diesem  Fall werden wir die "oooo" ausführen. Wenn das Label so
verwendet wird:

	addq.b	#1,RUEBEN

Da tun wir nichts anderes als einen Samen im ersten Byte nach der Etikette
dazuzufügen,  es  ändert  aber  nicht  seine  Funktion!  Es bedeutet nicht
Inhalte oder andere komische Dinge!!! Es markiert  immer  einen  Punkt  im
Speicher, also des Listings, das in unserem Fall der Anfang der Rüben ist.
Probieren wir mal, ein MOVE.B ERDBEEREN,RUEBEN zu machen:

ERDBEEREN:          KOHL:            RUEBEN:         PETERSILIE:
   \/                \/                \/                \/
    ..................oooooooooooooooooo.^^^^^^^^^^^^^^^^^-_-_-_-_-_-_-_-_-_

    |                                   |
     \------->--------->-------->------>

Wie ihr seht, ist ein ".", also das Byte nach ERDBEEREN:,  ins  Byte  nach
RUEBEN: kopiert worden. Versuchen wir nun ein MOVE.W KOHL,ERDBEEREN

ERDBEEREN:          KOHL:            RUEBEN:         PETERSILIE:
   \/                \/                \/                \/
    oo................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-_-_-_-_-_-_-_-_-_

    ||                ||
     \<----<----<-----/

Wir haben die ersten zwei "oo", die  sich  nach  KOHL:  befanden,  in  die
ersten zwei Bytes nahc ERDBEEREN: kopiert.

Wenn  man  einen  Punkt  zwischen  zwei Labels lesen/scheiben möchte, dann
brauchtr man nur ein weiteres hinzufügen: um 4 Bytes Kohl  mitten  in  die
Rüben  zu  geben, werden wir in der Mitte der Rüben ein neues Label namens
RUE2: pflanzen, und danach ein MOVE.L KOHL,RUE2

Vorher:

ERDBEEREN:          KOHL:            RUEBEN:  RUE2:  PETERSILIE:
   \/                \/                \/      \/        \/
    ..................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-_-_-_-_-_-_-_-_-_ 

Nachher:

ERDBEEREN:          KOHL:            RUEBEN:  RUE2:  PETERSILIE:
   \/                \/                \/      \/        \/
    ..................oooooooooooooooooo^^^^^^^^oooo^^^^^^-_-_-_-_-_-_-_-_-_
                      ||||                      ||||
                       \\\\ ---->---->----->-- ////

Wir haben die ersten 4 Bytes von KOHL: in die ersten 4  Bytes  nach  RUE2:
kopiet. Das .L bedeutet eben 4 Bytes...

Es  funktioniert  auf  die  gleiche Art und Weise, als wenn man die realen
Adressen  verwenden  würde,  wie   schon   in   LEKTION1   erklärt   (WORT
PEDAL>PORTAL),  nur  daß  anstatt  mit den Adressen, bei denen jeder Samen
eine eigene hat,  mit  Etiketten,  also  Labels,  gearbeitet  wird.  Unter
Verwendung der Adressen:

ERDBEEREN:          KOHL:            RUEBEN:         PETERSILIE:
   \/                \/                \/                \/
    ..................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-_-_-_-_-_-_-_-_-_ 
    123456789012345678901234567890123456789012345678901234567890123456789012
             111111111122222222223333333333444444444455555555556666666666777

Wenn man mit Adressen arbeitet, kann man 4 Bytes von jeder Stelle an jede
Stelle kopieren, z.B. von Stelle 25 zu Stelle 60: Move.L 25,60

ERDBEEREN:          KOHL:            RUEBEN:         PETERSILIE:
   \/                \/                \/                \/
    ..................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-_-_-oooo_-_-_-_-_
    123456789012345678901234567890123456789012345678901234567890123456789012
             111111111122222222223333333333444444444455555555556666666666777
                            ||||                               ||||
                             \\\\ --->---->---->---->--->---> ////

Die gleiche Operation läßt sich aber auch durchführen, indem man ein Label
an Position 25 und eines an Position 60 gibt:

                         Label1:                            Label2:
                           \/                                 \/
    ..................oooooooooooooooooo^^^^^^^^^^^^^^^^^^-_-_-oooo_-_-_-_-_
                            ||||                               ||||
                             \\\\ --->---->---->---->--->---> ////

Wieso man Labels den Adressen  vorgezogen  hat?  GANZ  EINFACH!  Wenn  wir
Adressen  verwendet  hätten,  und  zwischen  dem  Kohl und den Rüben etwas
eingefügt hätten, dann wäre die Adresse nicht mehr 60 gewesen, aber irgend
eine  andere  Zahl,  z.B.  80,  und wir hätten alle Adressen ändern müßen,
indem wir sie "nach vorne" schieben, um das Stück  reinzupassen.  Mit  den
Labels  hingegen  macht  uns ein Stück mehr oder weniger dazwischen nichts
aus, da der Assembler erst beim Assemblieren die realen Adressen zuteilt.

Probiert dieses Programm auszuführen, das erste Mal ohne den Mausknopf  zu
drücken,  nur  die  linke  Taste  zum  Aussteigen: das Byte ZAEHLER ist in
diesem Fall 0 geblieben, wie man einfach mit  dem  Befehl  M  sehen  kann.
Dieser  Befehl  zeigt die effektiven Werte in den Speicherzellen byteweise
an. Aufgerufen wird er z.B. mit M  $50000  oder  M  Label:  wir  werden  M
Zaehler  tippen,  und  0  erhalten,  gefolgt  von  anderen Zahlen, die die
folgenden Bytes darstellen, uns aber nicht interessieren. Um  im  Speicher
voran  zu  kommen,  drückt  öfters RETURN, um auszusteigen, ESC. Die Bytes
werden natürlich in Hexadezimal angezeigt. Assembliert von neuem mit A und
drückt  diesmal einige Male die rechte Maustaste, bevor ihr aussteigt (mit
der linken Taste): wenn ihr jetzt M Zaehler eingebt, werdet ihr eine  Zahl
verschieden von 0 erhalten, der der Anzahl der Zyklen entspricht, in denen
die Maustaste gedrückt war. Diese Zyklen werden vom Prozessor sehr schnell
ausgeführt,  und  auch wenn ihr nur einen Augenblick lang die rechte Taste
drückt, werdet ihr  eine  Zaahl  größer  als  eins  erhalten.  Es  ist  zu
beachten,  daß  der  Zähler  ein Byte groß ist, also einen Maximalwert von
$FF, also 255 oder %11111111 erreichen kann, danach startet er wieder  von
0  (wenn  man  mit  dem  dazuzählen  fortfährt).  $FF+1=0,  $ff+2=1... Die
Evolution  dieses  Programmes  gegenüber  dem  vorherigen  ist  die  etwas
komplexere  Struktur  der  bedingten  Sprünge, und ich rate euch, ja nicht
fortzufahren, bis ihr das nicht verstanden habt! Weiters wird ein Byte als
Variable   verwendet.   Diese   Byte,  Zaehler  genannt,  wird  nicht  nur
beschrieben, sondern auch gelesen, um dessen Wert in das Register $dff180,
Color0, einzutragen. Jetzt beginnt man zu verstehen, wie es einem Programm
möglich ist, verschiedene Werte zu speichern, die  von  Nutzen  sind,  wie
etwa  die  Leben  von  Player1,  seine  energie,  seine  Punkte,  etc. Die
Verwendung von Labels ist dem Programmierer nützlich, das Programm  selbst
aber,  einmal  assembliert,  wird nur eine Serie von Bytes werden, die der
68000er lesen kann. Sie werden als Befehle  interpretiert,  die  sich  auf
eine  direkte  Adresse beziehen: um das bestätigt zu bekommen, assembliert
das Programm und macht ein D Anfang... So wird das Programm sichtbat,  wie
es  in  Wirklichkeit  ist:  an  Stelle der Label finden wir die EFFEKTIVEN
Adressen. Die erste Zahlenkolonne links sind die realen Adressen, die  wir
gerade  lesen,  die zweite Kolonne zeigt die Befehle in ihrer REALEN Form,
also eine reine Bytesequenz (z.B. wird die erste Zeile BTST #2,$dff016  im
Speicher  so  aussehen:  0839000200dff016, wobei $0839 BTST bedeutet, 0002
ist das #2, 00dff016 ist die angesprochene Adresse),  die  dritte  Kolonne
ist  die disassemblierte Form der Befehle. Das ist genau das Gegenteil des
Assemblierens: hier werden  die  Bytes  in  Befehle  wie  Add,  Move  u.ä.
umgewandelt.  Um  zu Beweisen, daß die Befehle ganz bestimmte Zahlenfolgen
werden, tauscht die erste Zeile folgendermaßen aus:

	btst	#2,$dff016	; POTINP - rechte Maustaste gedrückt?

Ersetzen durch:

	dc.l	$08390002,$00dff016  

oder:

	dc.w	$0839,$0002,$00df,$f016

oder:

	dc.b	$08,$39,$00,$02,$00,$df,$f0,$16  


In allen Fällen ist das Resultat 0839000200dff016  im  Speicher,  was  vom
68000  als  "btst  #2,$dff016"  interpretiert  wird,  also  "ist Bit 2 von
$dff016 Null?".

Wenn die Variabel ein Word anstatt  ein  Byte  wäre,  würde  das  Programm
folgendermaßen aussehen:

Anfang:
	btst	#2,$dff016	; POTINP - rechte Maustaste gedrückt?
	beq.s	Dazu		; Wenn ja, springe zu Dazu
	btst	#6,$bfe001	; Linke Maustaste gedrückt?
	bne.s	Anfang		; Wenn nicht, springe zu Anfang zurück
	rts			; Wenn hingegen ja, dann steige aus!

Dazu:
	move.w	Zaehler,$dff180 ; Farbe 0 - Ein .W beim move verwenden!
				; (COLOR0)
	addq.w	#1,Zaehler	; ADDQ.W statt ADDQ.b!!!
	bra.s	Anfang		; Springe (immer) zu Anfang zurück

Zaehler:
	dc.w	0		; Dieses Byte ist unser Zähler


Da der Zähler nun ein Word groß ist, kann er maximal 65535 enthalten,  das
entspricht $FFFF oder %1111111111111111.

Wenn  wir  ein Longword als Zaehler verwenden würden, dann hätte $FFFFFFFF
Platz, also ein paar Miliarden, bevor er wieder auf 0 springen  würde.  Es
ist  aber aufzupassen, denn das höchstwertigste Bit (also das 31. im Falle
eines Longword) wird als Vorzeichen verwendet: probiert ein ?0FFFFFFF, ihr
werdet  268 Millionen und ein paar zerquetschte erhalten, und in Binärform
sind die vier höchsten Bit (also die ersten vier nach dem %)  auf  0.  Die
höchste Zahl die man erreichen kann, ist $7FFFFFFF, oder binär:

	;10987654321098765432109876543210	; Bitzahl von 0 bis 31
	%01111111111111111111111111111111

Das Bit Nr. 31 (was das zweiundreisigste wäre, es zählt aber auch di NULL)
ist  auf 0, während alle anderen auf 1 sind. Wenn man nun ein ?$7FFFFFFF+1
macht, erhält man -2 Milliarden und Etwas, und destomehr  man  die  Ziffer
erhöht,  desto  mehr  nähert man sich der 0, in der Tat erhält man mit ?-1
$FFFFFFFF, mit $-2 = $FFFFFFE.

Dieses System des höchsten Bits, das als Vorzeichen wirkt, kann  auch  für
Bytes  und  Words  gelten:  ein  MOVE.B  #-1,$50000  kann  auch als MOVE.B
#FF,$50000  geschrieben  werden.  Das  größtmögliche   Byte   würde   also
%01111111,   also   $7F->   127,   für   das   Word   gilt   das  gleiche,
%0111111111111111 -> $7FFF, also 32767. Aber es hängt davon  ab,  wie  man
das  Programm  schreibt,  ob  man nun die Zahlen als positive und negative
ansieht oder absolut.

Probiert, das Listing so abzuändern, daß Zaehler: ein Word wird, wie  oben
beschrieben:  ihr  könnt  die Editorfunktionen des ASMONE "AUSCHNEIDEN und
EINFÜGEN" verwenden. Damit könnt ihr ein  Stück  Text  "ausschneiden"  und
irgendwo  anders  "aufkleben", also "einfügen". Dafür verwendet die Tasten
Amiga_rechts+b  um  den  Anfang  des  Blockes  zu   markieren,   den   ihr
ausschneiden   wollt;  in  diesem  Fall  wählt  den  Teil  am  Anfang  des
modifizierten Listings aus, gleich nach dem "...folgendermaßen aussehen:".
Positioniert   den   Cursor   eben  über  der  Label  Anfang:  und  drückt
Amiga_rechts+b.  Nun  könnt  ihr  den  Block  auswählen,  der  in  negativ
erscheinen  wird,  indme  ihr  einfach mit den Pfeiltasten rauf und runter
fahrt. Unter dem dc.w 0 angekommen, drückt Amiga+c, und  das  Stück  Text,
das  nun  das  Listing  beinhaltet,  wandert in den Speicher. Nun geht zum
Anfang des Listings, durch Pfeil_rauf+SHIFT, und drückt Amiga+i... Wie von
Zauberhand  erscheint  eine  Kopie  des  Textes, den ihr vorhin ausgewählt
habt. Nun müßt ihr nur noch ein  END  unter  dem  dc.w  0  setzen,  einige
Leerzeichen vom limken Rand entfernt, besser noch ein TAB, um das orginale
Listing auszuschließen, das ja noch den Zaehler:  mit  dem  Byte  enthält.
Assembliert und Jumpt (startet es...).

P.S: Ignoriert die Zahlen, die nach jeden "J" auftauchen, einfach.
     Sie werden später erklärt.

Sofort werdet ihr einen  Unterschied  beim  Aufleuchten  des  Bildschirmes
feststellen,  wenn  ihr  die rechte Maustaste drückt; macht ein M Zaehler,
und kontrolliert den Inhalt. Jetzt ist es ein Word, also werden jetzt  die
ersten  zwei Zahlen gültig sein, also die ersten zwei Bytes. Wenn z.B. ein
00 30 erscheint, dann wird das bedeuten, daß das ADDQ.W #1,Zaehler $30 Mal
ausgeführt worden ist, also 48 Mal (in Dezimal). Bei einem 02 5e $25e mal,
das entspricht (?$25e) 606 Mal.

Wenn ihr keine Experten im "Ausschneiden und Einfügen" (Cut & Paste) seid,
dann  übt  ein  bißchen,  indem  ihr Textteile von einem Punkt zum anderen
kopiert. Beachtet auch, daß wenn ein mit Amiga_rechts+b ausgewählter  Text
anstatt mit Amiga_c mit Amiga_x traktiert wird, gelöscht wird, mit Amiga_i
aber  irgendwo  anders  eingefügt  werden  kann.  Ich   versichere   euch,
programmieren  ist  das reinste Ausschneiden und Einfügen, da dieser Trick
dir das Neuschreiben von ähnlichen Programmteilen erspart, die nur kopiert
und leicht verändert werden müßen.

Auch  mit den Binärzahlen sollte man sich vertraut machen, denn auch viele
Hardware-Register sind BITMAPPED, d.h. jedes Bit hat eine Bedeutung.  Hier
eine Tabelle, um den Unterschied klarzumachen:



Hexadezimal    Binär     Dezimal
	0      %00000    0
	1      %00001    1
	2      %00010    2
	3      %00011    3
	4      %00100    4
	5      %00101    5
	6      %00110    6
	7      %00111    7
	8      %01000    8
	9      %01001    9
       $A      %01010    10
       $B      %01011    11
       $C      %01100    12
       $D      %01101    13
       $E      %01110    14
       $F      %01111    15
      $10      %10000    16
      $11      %10001    17
      $12      %10010    18
      ...       ...      ...

Wie ihr seht, folgt das Binärsystem einer einfachen Logik,  die  die  Zahl
mit  einsen  füllt, bis sie zu einer 11, 111, 1111 etc. gekommen ist: nach
einem %011 kommt es zu einem %100, nach einem %0111 zu einem  %1000,  nach
einem  %01111  zu  einem  %10000 usw. Ich erinnere euch, daß Hexzahlen von
einem $-Zeiche vorangegangen werden, die  Binärzahlen  von  einem  %.  Die
Zahlen  in Dezimalformat hingegen stehen ohne nicht vorne dran. Wenn wir 9
oder $9 schreiben,  meinen  wir  immer  9,  aber  es  besteht  ein  großer
Unterschied  zwischen  $10  und 10!!! Denn 10 ist 10, $10 in Hex ist 16 in
Dezimal! Einfacher ausgedrückt, nach dem 9 ändert ein $ mehr oder weiniger
alles.  Man muß die Zahlen nicht im Kopf konvertieren können, dafür gibt´s
ja den "?"-Befehl im ASMONE, der das REsultat  in  jedem  Format  ausgibt,
Dezimal,  Hexadezimal,  Binär und ASCII, also in Form von Charaktern. Denn
Charakter wie "abcd.."  sind  nichts  anderes  als  Bytes,  die  nach  dem
ASCII-Standart  zugewiesen  sind.  So ist ein "a"=$61, während ein "A" ein
$41 ist. Es ist leicht mit einem ?"a" oder einem ?$61 in der Kommandozeile
nachgewiesen.

Bemerke:  Das  .s  am BNE bedeutet SHORT, also Kurz (equivalent zu .b), im
Gegenteil zu .w, wenn das Label "weit" weg ist. Probiert einfach immer ein
.s  zu setzen, und wenn das Label nach dem beq oder bne... zu weit weg ist
(mehr als 127 Byte), dann korrigiert es der Assembler mit .w  automatisch.
Um das zu testen, probiert folgende Änderung:


Anfang:
	btst	#2,$dff016	; POTINP - rechte Maustaste gedrückt?
	beq.s	Dazu		; Wenn ja, springe zu Dazu
	btst	#6,$bfe001	; Linke Maustaste gedrückt?
	bne.s	Anfang		; Wenn nicht, springe zu Anfang zurück
	rts			; Wenn hingegen ja, dann steige aus!

	dcb.b	200,0	; Dieser Befehl wird später erklärt, hier
			; werden einfach 200 bytes $00 im Speicher
			; zwischen dem RTS und der Label Dazu: eingefügt,
			; um die Distanz zu vergrößern.

Dazu:
	move.b	Zaehler,$dff180	; Gib den Wert von Zaehler in Farbe 0
				; (COLOR0)
	addq.b	#1,Zaehler	; Inkrementiere Zaehler um 1 (zählt 1 dazu)
	bra.s	Anfang		; Springe (immer) zu Anfang zurück

Zaehler:
	dc.b	0		; Dieses Byte ist unser Zähler


Beim Assemblieren werdet ihr bemerken, daß der  Assembler  ein  FORCED  TO
WORD SIZE meldet. Das bedeutet, er hat das bne.s zu einem bne.w gezwungen,
weil die aufgerufene Routine zu weit weg war. Ich rate euch, immer ein  .s
nach  einem  BRS,  BNE,  BRA,  BEQ  und ähnlichem zu setzen, wenn es nicht
stimmt, korrigiert es ja der Assembler. Man kann auch immer ein .w setzen,
aber  die  .s sind schneller und verbrauchen weniger Bytes im Speicher. Um
das Konzept der Label  nochmal  aufzugreifen:  das  dcb.b  200,0  ist  ein
Paradebeispiel  dafür,  wie nützlich die Label sind, die uns davor bewahrt
haben, die nachfolgenden Adressen alle neuzuschreiben, indem man sie  alle
um 200 Bytes aufstocken hätte müßen.

