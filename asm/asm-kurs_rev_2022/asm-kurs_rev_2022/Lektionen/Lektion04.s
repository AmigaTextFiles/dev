
ASSEMBLERKURS - LEKTION 4

In diesem Kapitel lernen wir,  Bilder  in  verschiedenen  Auflösungen  mit
einer  Copperlist  anzuzeigen.  Bis  jetzt konnten wir nur Farbe0 (COLOR0)
verändern,  also  $dff180.  Damit   waren   wir   imstande,   Farbverläufe
herzustellen,  aber  Bilder werden natürlich nicht mit WAIT angezeigt!! Um
ein normales IFF-Bild  anzuzeigen,  das  z.B.  mit  Deluxe-Paint  erstellt
wurde,  digitalisiert,  gescannt  oder  gerendert  wurde,  braucht es kein
einziges Wait! Es reicht, dem Copper zu sagen, welche Auflösung  das  Bild
hat  (Anzahl der Farben, Auflösung Low-Res/ Hi-Res, Interlace oder nicht),
und zwar mit dem Register $dff100, BPLCON0. Bis jetzt haben wir in  dieses
Register  immer  den  Wert  $200  gegeben,  was  soviel  bedeutet wie: NUR
HINTERGRUNDFARBE OHNE BILDER DARÜBER. Deswegen passiert auch nichts,  wenn
wir in einer solchen Copperlist die Farbe 1, also $dff182, verändern: weil
kein BITPLANE aktiviert ist, aber nur "Hintergrund", dessen Farbe nur  mit
dem  $dff180 geändert werden kann. Nachdem wir die Auflösung (z.B. 320x256
Pixel, wobei PIXEL  die  kleinen  Bildpunkte  sind,  aus  denen  ein  Bild
besteht)  und  die  Anzahl  der  Farben  bestimmt haben, müssen wir in ein
Register hineinschreiben, wo   unser Bild  zu  finden  ist.  Das  ist  ein
POINTERREGISTER,  wie das COP1LC, in ihm kommt die Adresse, wo das Bild zu
finden ist, dessen Anfang. Danach müssen wir die PALETTE  bestimmen,  also
welchen  Wert  jede  einzelne Farbe hat, z.B. Farbe0 Rot, Farbe1 Hellgrün,
Farbe2 Dunkelblau... usw. Wird das nicht getan, dann erscheint unser  Bild
in  "Falschfarben",  es  werden einfach die Farben genommen, die gerade da
sind,  und unser Bild  wird  dann  ziemlich  "außerirdisch"  anmuten.  Wir
müssen  also  in  die Register den richtigen Wert eintragen, z.B. wenn ein
Bild aus vier Farben besteht, könnte die Farbdefinition so aussehen:

	dc.w	$180,$xxx	; color 0
	dc.w	$182,$xxx	; color 1
	dc.w	$184,$xxx	; color 2
	dc.w	$186,$xxx	; color 3
 
Dieses Stück Copperlist wird aber direkt schon vom KEFCON abgespeichert.

Es existieren auch noch  andere Register, mit  denen man die Dimension des
Bildes einstellen kann, um ihr eine "SPEZIAL-DIMENSION" zu  verleihen, wie
etwa OVERSCAN, das es größer erscheinen läßt, oder man kann auch  nur  ein
Fensterchen  machen,  das nur einen Teil des Bildschirmes ausfüllt. Andere
Spezial-Register sind  die  MODULO,  die  oft  in  "Verlängerungseffekten"
verwendet  werden. In den ersten Beispielen werden wir diese Register aber
auf NULL bzw. ihrem Standardwert belassen, um ein Bild anzuzeigen.  Vorweg
muß erstmal klar sein, daß es einen Unterschied  zwischen  einem  Bild  im
IFF-Format, also dem Standardformat, wie es DPaint  verwendet,  und  einem
REALEN  Bild  gibt.  Dieses reale  Bild wird RAW  oder  BITMAP genannt, es
liegt im Speicher und wird vom Copper angezeigt. Auf der Diskette ist  ein
Programm  enthalten, das ein Bild von IFF in RAW konvertiert, unerläßlich,
wenn man Bilder mit  dem  Copper  anzeigen  will.  Diese  Bilder  sind  in
Wirklichkeit auch nur eine lange Reihe von 0 und 1, wie alle BINÄREN DATEN
im Speicher. Wir haben schon gesehen, daß alle Daten im Speicher  aus  Bit
besteht,  also  aus  Nullen und Einsen, oder Strom fließt und Strom fließt
nicht, die einzig möglichen Zustände: aus Bequemlichkeit verwenden wir das
Dezimal-  und  das  Hexadezimalsystem, aber die Wirklichkeit besteht immer
aus Bit. Aber wie ist es dann möglich, ein Bild mit 32 Farben  anzuzeigen,
wenn  es  nur  0  und  1 gibt??!! Wenn wir im Speicher eine Art Papier mit
Kästchen hätten, und jedes Kästchen entweder Schwarz (Bit auf 0) oder Weiß
(Bit  auf  1)  wäre,  dann  könnten  wir nur mit zwei Farben arbeiten, dem
Schwarz  und  dem  Weiß.   Das   war   auf   den   alten   Computern   mit
Monochrom-Monitor  der  Fall,  die  nur  die  Hintergrundfarbe (Bit auf 0)
anzeigen konnten, auf der Schrift und Bilder (Bit auf 1) in einer  anderen
Farbe dargestellt waren (meist grün).
Mit dem Copper kann man auch in dieser Art arbeiten, mit zwei  Farben,  es
muß  NUR  EINE EINZIGE BITPLANE eingeschaltet werden. Im Speicher brauchen
wir dann noch das Bild in RAW, ähnlich dem Blatt Millimeterpapier, wie ich
es  vorhin  beschrieben  habe, mit "eingeschalteten" und "ausgeschalteten"
Punkten.  Bis  jetzt  müßte   noch   alles   Klar   sein,   es   ist   wie
Schiffe versenken!!  Ein Schiffchen besteht also aus einer Reihe von Pixel
(Punkten),  auf  die  gleiche  Art  und  Weise  kann  man  alles  mögliche
darstellen:

EIN MÄNNCHEN							EIN FLUGZEUG (ich habe die
						      				Nullen weggelassen!)

						      				  	  11
000011100000	      000001100000		    	 1111
000001000000	      000010010000		    	 1111
000111111000	      000010010000	     111111111111111111111
000101101000	      000111111000	   1111111111111111111111111
000101101000	      000100001000		    	 1111
000011110000	      000100001000		    	 1111
000010010000					    			111111
000010010000		 	EIN "A"           	   11111111
000010010000
000110011000

Wenn eine  Figur,  ein  Bild  aber  größer  ist,  dann  ist  es  natürlich
vorteilhafter,  sich  dieses  mit  einem  Malprogramm  zu zeichnen oder zu
scannen, und dann mit dem KEFCON in RAW zu konvertieren (000101110100...).
Um  die  Hintergrundfarbe zu definieren braucht man nur ein dc.w $180,$000
(schwarz) setzen, für die Farbe 1 ein dc.w $182,$0f0 (grün).
Bei mehrfarbigen Bildern besteht der  Trick  darin: das die  verschiedenen
Bitplanes,  also  Ebenen  aus  Bits  (0011010...) "überlagert" werden, mit
einer Art Transparenz, also wo zwei 1 übereinandertreffen, erscheint  eine
Farbe,  wo  drei  1 übereinanderkommen wieder eine andere usw. All das muß
aber nicht berechnet werden!! Es reicht, die Figur  mit  dem  IFFKonverter
Kefcon  zu  laden, sie ein RAW zu konvertieren und abzuspeichern, dann die
Anzahl der Farben und die Auflösung im $dff100  einstellen  (BPLCON0)  und
dann  dem  Copper sagen, wohin wir das RAW-Bild im Speicher geladen haben.
Danach noch die richtigen Farben einstellen,  die  u.a.  der  Kefcon  auch
schon  (separat)  abspeichert,  und  das Bild erscheint ohne größere Mühe.
Wichtig ist nur, die Prozedur klar im Kopf  zu  haben,  praktisch  gesehen
braucht es ein  paar Minuten, ein Bild von IFF in RAW zu konvertieren  und
das Listing richtig zu modifizieren.
Als Erstes stellen wir mal klar, was der  IFF-Konverter  tut  (in  unserem
Fall  verwenden  wir  den  Kefcon,  ihr  könnt  ihn starten, indem ihr das
ASMONE-Fenster herunterschiebt und unter  DOS  seinen  Namen  aufruft.  Es
exisitieren neuere Konverter, mit mehr Optionen, viele davon meist unnütz,
aber aus Platz- und Kompatibilitätsproblemen mit dem  Kick  1.3  habe  ich
entschloßen,	diesen   beizulegen.   Weiters   ist   er   auch   mittels
Hardware-Registern programmiert, und nicht  über  das  Betriebssystem,  er
liegt also in der Linie mit der Kurs. Wenn ihr einen anderen IFF-Konverter
verwenden wollt, dann bitte, aber zuerst lernt, mit diesem  umzugehen,  er
wurde  verwendet,  um  glorreiche Spiele und Demos zu programmieren!). Wir
haben gesehen, daß in Wirklichkeit ein Bild ein  Übereinander  von  Ebenen
aus  Bits ist,  desto mehr Ebenen (PLANES), desto mehr Farben, eine Ebene,
zwei Farben (Vorder- und Hintergrund). Wir haben  auch  gesehen,  daß  zum
Anzeigen der Farben (PALETTE) es notwendig ist, auch die richtige  Grafik-
auflösung im Register $dff100 (BPLCON0) einzustellen . Die Erschaffer  des
Amiga  haben  sich  ein eigenes Format ausgedacht, um Bilder abzuspeichern
und von einem Programm ins andere zu verlegen: dieses Format für den Amiga
ist  das  IFF  ILBM,  praktisch  gesehen  besteht  es  aus  Bitplanes, die
komprimiert sind, um weniger Platz zu brauchen. Angehängt  ist  dann  noch
die  Palette  und die Auflösung. Wenn ein Programm ein IFF-Bild lädt, dann
dekomprimiert  es   die  Ebenen,  setzt  die  richtige  Palette   in   den
Farb-Registern ein ($dff180, $dff182...), und setzt die richtige Auflösung
($dff100, BPLCON0). Auf die gleiche Art und Weise, wenn  es  ein  Bild  im
Speicher  abspeichern  will, dann komprimiert es die Ebenen im IFF-Format,
hängt Palette und den Rest an.
Der IFF-Konverter tut  folgendes:  er  kann  ein  RAW  laden  und  in  IFF
abspeichern,  vorausgesetzt,  er  bekommt  auch  die  richtige PALETTE und
AUFLÖSUNG, oder er kann ein Bild in IFF laden und es als RAW  abspeichern,
weiters  die  Palette  schon in Form von dc.b $180,... dc.b $182,..., also
für die Copperlist vorbereitet, abspeichern.
Auf anderen Computern werden verschiedene andere Formate  verwendet,  GIF,
PCX  oder  TIFF  z.B. werden von den PC MSDOS verwendet. Außer daß sie die
Ebenen anders komprimieren und Palette etc.  anders  anhängen,  haben  sie
auch ein anderes Anzeigesystem. Es ist das CHUNKY, das recht nützlich ist,
um 256 Farben anzuzeigen, aber weniger fähig als das des Amiga, SCROLLS zu
verwalten, und ohne die Möglichkeit, die Palette zu verändern, wie es beim
Copper mit den Wait geht. Die möglichen Auflösungen des  "normalen"  Amiga
(ohne AGA) sind:

320x256 PIXEL, LOW-RES genannt
640x256 PIXEL, HI-RES genannt

Das Bild kann auch länger sein (312 Zeilen in Overscan)  oder  doppelt  so
lange  sein  (Interlace, produziert aber ein störendes Flickern). Auch die
Breite kann ein bißchen vergrößert werden, wenn man Overscan einsetzt.

Die Bilder in Low-Res (320 Pixel breit) können maximal 32 Farben haben, es
gibt  aber noch zwei  Spezialmodi, EHB (Extra Half Bright) und  HAM  (Hold
and Modify), die zwar jeweils 64 und 4096  Farben  anzeigen  können,  aber
ihre  bestimmten  Granzen  haben.  Wir  werden  uns  später  genauer damit
befassen. Die Biler in HIGH RES können maximal 16  Farben  darstellen  und
besitzen keine Spezialmodi.
Die meisten Spiele sind in Low-Res,  um  die  größere  Anzahl  von  Farben
ausnutzen  zu  können  und  um Speicher zu sparen (der leider, früher oder
später, ausgeht!), und  auch  wegen  der  größeren  Geschwindigkeit,  denn
High-Res  bremst  die ganzen Operationen viel mehr als Low-Res, man muß ja
auch größere Speicherstücke bewegen, da der  Bildschirm  doppelt  so  groß
ist! 
Analysieren wir die Technik, mit der  die  Farben  angezeigt  werden:  wie
gesagt,  ist  die  maximal  darstellbare Anzahl der Farben 32 (Spetialmodi
nicht mitgezählt); es ist möglich, eine Bildschirmauflösung von 2,  4,  8,
16  oder  32  Farben  zu  wählen. Das ist so,  weil  die Anzahl durch  die
übereinanderliegenden Ebenen bestimmt wird, und mit  jeder  "Ebene"  kommt
ein Bit dazu, sie wird um ein Bit "tiefer": mit einem Bit können wir nur 0
und 1 aussagen, also zwei Farben, also wird eine Auflösung von 320x256  in
zwei  Farben  nur  eine Bitplane  besitzen. Wenn wir eine weitere Bitplane
dazufügen, dann werden die möglichen Farben 4, denn es  können  sich  vier
verschiedene  Situationen  ergeben:  00,  01,  10,  11,  oder: alle beiden
Bitplane auf NULL (Hintergrundfarbe), erste  Bitplane  auf  eins,   zweite
auf  NULL,  (z.B.  Farbe1),  erste   Bitplane  auf  0, zweite  auf 1 (z.B.
Farbe3) und  beide  Bitplane  auf  1  (Farbe3).  Wird  noch eine  Bitplane
dazugenommen, dann ergeben sich 8 mögliche Zustände:
000, 001, 010, 011, 100, 101, 110, 111 (3 BITPLANES=3 Bit pro Pixel=8 Mögl)

Noch eine Bitplane erhöht die Anzahl der Bits pro Pixel  auf  4,  also  16
Möglichkeiten:0000,0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,
1101, 1110,1111. Das gleiche gilt für 5 Bit pro Plane, nun sind  wir  beim
Maximum  angekommen,  32 Farben. Jede  Bitplane verdoppelt also die Anzahl
der Farben:

0 Bitplane = nur Hintergrund COLOR0 ($dff180) = 1 Farbe
1 Bitplane = 2  Farben
2 Bitplane = 4  Farben (2*2, oder 2 hoch 2)
3 Bitplane = 8  Farben (2*2*2, oder 2 hoch 3)
4 Bitplane = 16 Farben (2*2*2*2, oder 2 hoch 4)
5 Bitplane = 32 Farben (2*2*2*2*2, oder 2 hoch 5)

Der Amiga besitzt 32 Register für die 32 möglichen Farben in  LowRes,  die
bei  COLOR0  starten  und  bis  COLOR31 gehen (Die Numerierung startet bei
NULL, wie bei den Bits). COLOR0 ist das $dff180, es folgen die anderen:

$dff182 = COLOR1
$dff184 = COLOR2
$dff186 = COLOR3
$dff188 = COLOR4
$dff18a = COLOR5
etc...

Z.B. wenn ein Pixel in einem LowRes Bild  mit  16  Farben  die  Farbe  des
Hintergrundes  hat,  also  COLOR0,  die veränderbar ist, wenn man Register
$dff180 verändert, dann werden alle vier Bits auf 0 sein:  0000.  Hat  ein
Pixel hingegen die Farbe 15, COLOR15 genannt, dann werden alle Pixel auf 1
stehen:1111. Alle Farben, die dazwischen liegen, sind Kombinationen davon.
Der  Amiga  1200/4000  hat  8 Bitplanes, was 256 Farben ergibt (2 hoch 8 =
256). Er besitzt das AGA-Chipset, das ihm diese höhere Anzahl erlaubt,  in
Programmen  für AGA kann man auch 64 (6 Planes), 128 (7 Planes) und 256 (8
Planes) Farben wählen. Eine Bildschirmseite wird auch  PLAYFIELD  genannt.
Berechnen  wir  mal,  wieviel  Speicher  ein  Bild in 320*256 mit 2 Farben
braucht:  jede  Zeile  hat  320  Pixel,  und  da  ein  Byte  aus   8   Bit
zusammengesetzt  ist, haben in einer Zeile 40 Bytes Platz (40*8=320). Also
brauchen wir nur 40, also die Anzahl der Bytes pro Zeile, mit  der  Anzahl
der Zeilen selbst zu  multiplizieren, also 256, d.h. 40*256 = 10240.  Eine
Bitplane in LowRes braucht also 10240 Bytes. Nun können wir auch ein  Bild
mit 4 Farben berechnen, also mit 2 Bitplanes: 40*256*2=20480.
Für ein Bild in LowRes  brauchen  wir  demzufolge  nur  40*256*Anzahl  der
Bitplanes zu multiplizieren.
Einmal festgestellt, daß in LowRes 40 Bytes pro Zeile Platz haben,  werden
wir  nicht  lange  brauchen um zu erkennen, daß es in HighRes das doppelte
sein wird, da es doppelt so breit ist...: es werden also 80 Byte pro Zeile
nötig  sein, was folgende Rechnung ergibt: 80*256*Anzahl der Bitplane. Man
kann als generelle Formel zu Berechnung der Größe diese nehmen:

	Bytes pro Zeile * Zeilen des Playfields * Anzahl der Bitplanes

Analysieren wir jetzt das BPLCON0, das Register, in dem die Auflösung  und
die Anzahl der Farben festgehalten wird: ( Zusammenfassung mit "=C 100")

	$dff100 - BPLCON0

 Bit Plane Control Register 0   (1 Word, also 16 Bit, von 0 bis 15)

 NUMMER DES BIT		 (Achtung:Bit auf 1 = ON, Bit auf 0 = OFF)

	15	-	HIRES	Hires (1=640x256 , 0=320x256)
	14	-	BPU2	\
	13	-	BPU1	 ) 3 Bit zur Auswahl der Anzahl der Bitplanes
	12	-	BPU0	/
	11	-	HOMOD	Hold And Modify mode (HAM 4096 Farben)
	10	-	DBLPF	Double playfield
	09	-	COLOR	Composite video (für GENLOCK)
	08	-	GAUD	Genlock audio
	07	-	X
	06	-	X
	05	-	X
	04	-	X
	03	-	LPEN	Lightpen (Lichtgriffel)
	02	-	LACE	Interlace (320x512 oder 640x512)
	01	-	ERSY	External resync (Für den GENLOCK)
	00	-	X
	
Dieses Register ist BITMAPPED, d.h. jedes einzelne Bit  hat  seine  eigene
Bedeutung:

-  Bit  15  schaltet HIRES ein: damit werden 640 Pixel pro Zeile an Stelle
der üblichen 320 dargestellt. Erinnert euch, DDFSTART/STOP auf  $003c  und
$00d4  statt auf $0038 und $00d0 zu setzen, sonst werden die ersten Zeilen
links nicht angezeigt! 

- Die Bit 14-12 dienen dazu, die ANZAHL der Bitplanes zu bestimmen,  nicht
welche  PLANE.  Die Bits sind insgesamt 3, es ergeben sich also 6 mögliche
Planes. Hier muß hineingeschrieben werden,  WIEVIELE  Planes  einschalten,
richtig  als Zahl, und nicht auswählen, welche, Z.B.: ´3´, ´0´, ´6´. Mit 3
Bit sind 8 Zahlen möglich, von 0 bis 7. ICH WIEDERHOLE: ARBEITET MIT EINER
RICHTIGEN  ZAHL, DIE  BINÄR DARGESTELLT IST, NICHT MIT DEN EINZELNEN BITS,
DIE EIN- UND AUSZUSCHALTEN SIND, IM UNTERSCHIED ZU DEN ANDEREN BITS!
(N.B.: Wenn ´0´ geschrieben wird, ist %000 gemeint, alle Planes aus, bei 
´101´ werden 5 eingeschalten; mit 6 Bitplanes wird der HALF-BRIGHT Modus
aktiviert.

- Bit 11 aktiviert  den  HAM-Modus.  Ein  Amiga  kann  damit  4096  Farben
darstellen, ein Amiga mit AGA (1200/4000) 262144 Farben.

- Bit 10 aktiviert den DUAL-PLAYFIELD-Modus, einem speziellen Modus zu  2,
4 oder 6 Bitplanes, der es ermöglicht, zwei Screens zu jeweils 1, 2 oder 3
Planes zu erzeugen. Diese werden Playfiled1 und  Playfield2  genannt,  sie
sind   übereinandergelegt   und   transparent,   indem   sie   Farbe0  des
darüberliegenden durchsichtig sein lassen. Es  ist  also  möglich,   einen
Parallel-Effekt  zu  schaffen,  ähnlich dem, wie wir ihn in vielen Spielen
sehen. Z.B. könnte man ein Playfield  zu  3  Planes  (8  Farben)  für  das
Spielfeld  verwenden,  und  ein anderes für den Hintergrund, das Berge und
Täler darstellt, das langsamer scrollt (sich von einer Seite  zur  anderen
bewegt),  und somit einen besseren Tiefeneindruck verleiht. Sobald das Bit
gesetzt ist, bilden die ungeraden Planes (1,3,5) das  Playfield1  und  die
geraden  (2,4,6)  das  zweite: die Hardware gruppiert die Planes auf diese
Art und Weise um sie unabhängig voneinander zu machen, sofort nachdem  das
Bit  DBF  gesetzt wurde. Wir werden in den nächsten Kapiteln sehen, daß es
Register für Scrolls gibt und andere, die  Parameter  für  gerade/ungerade
Planes  unterscheiden,  um  sie  unabhängig  voneinander  kontrollieren zu
können! N.B.: Bei DualPlayField  ist  es  nur  möglich,  zwei  Screens  zu
überlappen,   die   beide   auch  die  gleiche  Auflösung  besitzen,  z.B.
Hires+Hires, Lowres+Lowres ...

- Bit 9 dient dazu, auch den FBAS-Videoausgang  zu  aktivieren,  der  sich
neben  dem  RGB-Stecker  des  Amiga  befindet. Ich persönlich aktiviere es
immer, somit können auch Leute meine Produktionen  anschauen,  die  keinen
RGB-Monitor besitzen und diesen Ausgang verwenden. SETZT ES IMMER AUF 1.

- Bit 8 aktiviert  den  Audio  eines  eventuell  angeschlossenen  Genlock.
Praktisch dient es zu gar nichts, überfliegen wir´s.

- Bit 7 wird nur  von  den  fortgeschritteneren  Chipsets  den  A1200/4000
verwendet, auf normalen Amigas hat es keinen Einfluß. Erinnert euch, diese
nicht verwendeten Bits immer auf NULL zu lassen, ansonsten  riskiert  ihr,
daß   auf   A1200ern   und   4000ern  eure Demos/ Spiele/ Programme  nicht
funktionieren.

- Bit 6 hat auf Standard-Amigas keine Funktion, auf 0 lassen.

- Bit 5 laßt ihr auf 0

- Bit 4 laßt ihr auf 0

- Bit 3 dient dazu, die Koordinaten der Lightpen  in  die  Register  VHPOS
($dff006)  und  VPOS ($dff004) des BEAM zu bekommen. Der Lichtgriffel wird
auf dem Amiga fast nie verwendet, diese Option interessiert uns nicht.

- Bit 2 aktiviert das Interlace, das es erlaubt, doppelt so  viele  Zeilen
darzustellen  als  normal (512). Der Nachteil ist ein Flackern. Wir werden
später noch darüber reden.

- Bit 1 dient dazu, den Beam mit einem externen Gerät zu  synchronisieren,
laßt es einfach auf 0.

- Bit 0 laßt ihr auf 0.

Das gesagt, machen wir einige Beispiele mit der Verwendung des $100 (BPLCON0):

		  ; 5432109876543210
 dc.w $100,%0100001000000000	; ---> 4 Planes in Lowres (320x256)
 dc.w $100,%1011001000000100	; ---> 3 Planes in Hires+Interlace (640x512)
 dc.w $100,%0110001000000100	; ---> 6 Planes in HALF-BRIGHT Lowres+Lace
 dc.w $100,%0110101000000000	; ---> 6 Planes in HAM lowres (4096 colors)
 dc.w $100,%0110011000000000	; ---> DualPlayField 3+3 Plane in Lowres
 dc.w $100,%1100011000000100	; ---> DualPlayField 2+2 in Hires+Interlace
  
In Lektion3 haben wir BPLCON0 in der Copperlist verwendet, indem  wir  ihm
immer den Wert $200 gegeben haben:

	dc.w	$100,$200

Wir haben also nur das Bit 9 gesetzt, das, das den Genlock aktiviert:

		         ;5432109876543210
	dc.w	$100,%0000001000000000
  
Der Genlock ist ein Gerät, das es ermöglicht, Texte, Grafiken und  Bilder,
die  mit  dem Amiga erzeugt wurden, über ein Fernseh/Videobild zu blenden.
Wer also kein solches Genlock besitzt, wird keinen  Unterschied  bemerken,
ob nun dieses Bit gesetzt ist oder nicht. Es zahlt sich aber aus, es immer
einzuschalten, falls jemand unsere Copperlist mit einem Genlock  verwenden
möchte,  und  weil  der alte Amiga 1000 einen Videoausgang für den Monitor
hat. Wir hätten also das gleiche Resultat mit dc.w  $100,0  erhalten.  Wie
ihr seht, sind die Bitplane auf NULL, es ist also nur die Hintergrundfarbe
aktiviert, ohne Bilder darauf. Um die Bitplanes "einzuschalten"  müßt  ihr
nur die Anzahl in binär eingeben, wieviele ihr verwenden wollt. Bit 12, 13
und 14 sind dafür zuständig.

Um z.B. einen Screen mit 1 Bitplane (2 Farben): (320x256!)

		        ; 5432109876543210
	dc.w	$100,%0001001000000000  ; BPLCON0 - Bit 12 an!! (1 = %001)

				*

Für einen Bildschirm mit 2 Bitplanes: (4 Farben)

		        ; 5432109876543210
	dc.w	$100,%0010001000000000  ; BPLCON0 - Bit 13 an!! (2 = %010)

				*

Für einen Screen mit 3 Bitplanes: (8 Farben)

		        ; 5432109876543210
	dc.w	$100,%0011001000000000  ; Bits 13 und 12 an!! (3 = %011)

				*

Für einen Schirm mit 4 Bitplanes: (16 Farben)

		        ; 5432109876543210
	dc.w	$100,%0100001000000000  ; BPLCON0 - Bit 14 an!! (4 = %100)

				*

Für einen Bildschirm mit 5 Bitplanes: (32 Farben)

		        ; 5432109876543210
	dc.w	$100,%0101001000000000  ; Bits 14 und 12 an!! (5 = %101)

				*

Für einen Screen mit 6 Bitplanes:(für Spezialmodi EHB und HAM 4096 Farben)

		        ; 5432109876543210
	dc.w	$100,%0110001000000000  ; Bits 14,13 an!! (6 = %110)
 
(Wenn in dieser Einstellung das Bit für HAM (Bit 11)  auf  1  steht,  dann
wird  der  HAM-Modus  aktiviert,  ansonsten,  bei  Bit  auf  0, Extra Half
Bright.)

Es reicht also, die Anzahl der erforderlichen Bitplanes in  die  drei  Bit
12,  13  und  14 dieses Registers zu geben. Wenn man einen Screen in Hires
wünscht, 640 Pixel breit statt 320, dann wird das Bit 15  auf  1  gesetzt,
das  ist das erste von Links. Man muß sich halt ERINNERN, daß die MAXIMALE
ANZAHL der Planes in  HIRES  4  beträgt  (16  Farben),  und  daß  DFFSTART
($dff092) und DFFSTOP ($dff094) geändert werden müssen:

	dc.w	$92,$003c			; DdfStart HIRES normal
	dc.w	$94,$00d4			; DdfStop HIRES normal

Das Gleiche gilt für das  Interlace  (Länge  512  statt  256  Zeilen),  es
reicht, Bit 2 auf 1 zu setzen.

Einmal  das BPLCON0 richtig eingestellt, muß man dem Copper auch verraten,
wo die "aktivierten" Bitplanes liegen. Um das zu tun, müssen wir  nur ihre
Adressen in die dazu bestimmten Register schreiben:

	$dff0e0 = BPL0PT (Pointer (Zeiger) auf Bitplane 1)
	$dff0e4 = BPL1PT (Pointer (Zeiger) auf Bitplane 2)
	$dff0e8 = BPL2PT (Pointer (Zeiger) auf Bitplane 3)
	$dff0ec = BPL3PT (Pointer (Zeiger) auf Bitplane 4)
	$dff0f0 = BPL4PT (Pointer (Zeiger) auf Bitplane 5)
	$dff0f4 = BPL5PT (Pointer (Zeiger) auf Bitplane 6)

Auch hier wird bei 0 gestartet, also kommt man bei 5 an, das  die  sechste
Bitplane  definiert. Das  Help  des  ASMONE  startet bei  NULL,  das könnt
ihr nachprüfen, wenn ihr "=C 0e0" tippt.
Um ein Bild anzuzeigen muß man also eine Copperlist anpeilen, die  richtig
gesetzt  ist  und  die  richtigen  Farben  enthält,  dann muß man auch die
Bitplanes POINTEN, also "daraufzeigen", "anpeilen", z.B. so:

	MOVE.L	#BITPLANE0,$dff0e0	; Adresse von BITPLANE0 in BPL0PT
	MOVE.L	#BITPLANE1,$dff0e4	; BPL1PT
	MOVE.L	#BITPLANE2,$dff0e8	; BPL2PT
	...
 
Und das Bild wird wie von Geisterhand erscheinen. Die Bitplanes sind  aber
in   der  Copperlist  direkt  angepeilt,  weil  sie  ja  bei  jedem  Frame
neugeschrieben werden müssen.

Man darf aber nie vergessen, in die Copperlist  die  "Spezialregister"  zu
geben,  die  wir  zur  Zeit  entweder  auf  NULL  oder  ihrem Standardwert
belassen, ansonsten sind noch die Werte der Workbench  enthalten,  und  es
kann   zu   Anzeigeproblemen  kommen.  Z.B.  hat  die  Workbench  1.3  die
Modulo-Register auf 0, Kick 2.0 hat hingegen andere Werte  darin:  Spiele,
die  unter  1.3  gut  laufen, auf höheren Kickstarts aber Probleme mit der
Darstellung der  Figuren  haben,  haben  oft  als  Grund  dafür,  daß  die
Modulo-Register  ($dff108  und  $dff10a) nicht  gesetzt wurden, somit beim
kollaudieren funktionierten, auf Kick 2.0 aber alles verdrehen. Um  solche
Probleme  zu  vermeiden,  sollten wir also immer alle Register definieren,
auch jene, die wir nicht verwenden; die Register sind die folgenden:

	$dff08e - DIWSTRT, Anfang Videofenster - normal auf $2c81
	$dff090 - DIWSTOP, Ende Videofenster - normal auf $2cc1
	$dff092 - DDFSTRT, Data Fetch Start - normal auf $0038
	$dff094 - DDFSTOP, Data Fetch Stop - normal auf $00d0
	$dff102 - BPLCON1, Bitplane control 1 - normal auf $0000
	$dff104 - BPLCON2, Bitplane control 2 - normal auf $0000
	$dff108 - BPL1MOD, Modulo gerade Bitplanes - normal auf $0000
	$dff10A - BPL2MOD, Modulo ungerade Bitplanes - normal auf $0000
  
Wir werden diese Register genauer behandeln, wenn wir  sie  verwenden,  um
Spezialeffekte  zu  erzeugen,  im  Moment  erinnert  euch,  daß  ihr diese
Register mit den Standardwerten immer an den Anfang der Copperlist  setzen
müßt:

COPPERLIST:
	dc.w	$8e,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart * ACHTUNG: für HIRES 640x256 $003c
	dc.w	$94,$00d0	; DdfStop  * ACHTUNG: für HIRES 640x256 $00d4
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,xxxx	; Bplcon0 - Definieren Auflösung und Farben

;	An diese Stelle können wir die Farben des Bildes geben; dieses Stück
;	Copperlist speichert der IFF-Konverter KEFCON automatisch ab, mit
;	einem eigenen Namen, danach kann man es hier einfügen, indem man
;	das Cut&PASTE des Editors verwendet, indem man es zuerst in einen
;	anderen Buffer ladet, z.B.:

	dc.w $0180,$0010,$0182,$0111,$0184,$0022,$0186,$0222
	dc.w $0188,$0333,$018a,$0043,$018c,$0333,$018e,$0154
	dc.w $0190,$0444,$0192,$0455,$0194,$0165,$0196,$0655
	dc.w $0198,$0376,$019a,$0666,$019c,$0387,$019e,$0766
	dc.w $01a0,$0777,$01a2,$0598,$01a4,$0498,$01a6,$0877
	dc.w $01a8,$0888,$01aa,$05a9,$01ac,$0988,$01ae,$0999
	dc.w $01b0,$06ba,$01b2,$0a9a,$01b4,$0baa,$01b6,$07cb
	dc.w $01b8,$0bab,$01ba,$0cbc,$01bc,$0dcd,$01be,$0eef

;	Wie ihr seht, sind hier alle 32 Farbregister des Amiga definiert,
;	denn ich habe mit dem KEFCON ein Bild mit 32 Farben geladen und das
;	ist seine Palette, die zusammen mit dem RAW generiert wurde.

;	Hier können eventuelle Videoeffekte mit Waits eingefügt werden...

	dc.w	$FFFF,$FFFE	; Ende der Copperlist
 
Diese Copperlist ist ausreichend, um ein Bild anzuzeigen. Beginnen wir nun
mit  dem  ersten  Beispiel,  dem Anzeigen eines PLAYFIELD mit 3 Bitplanes,
also 8 Farben. Im ersten Beispiel dieses Kurses zeigen wir  schon ein   in
RAW konvertiertes Bild an, das auf der Diskette enthalten ist: um ein Bild
in den Speicher zu "laden" gibt  es  eine  Anweisung  des  ASMONE,  INCBIN
genannt, das eben erlaubt, einen gewissen Daten-File von Diskette zu laden
und an den Punkt im Speicher  zu geben, an dem das Incbin steht. Wenn  wir
z.B.  eine  Copperlist  vorbereiten  und als File abspeichern würden, dann
könnten wir sie so laden:

Copperlist:
	incbin "Copper1"

Das Resultat ist das gleiche, als ob wir hier eine Serie von dc.w eingeben
würden,  die  identisch  mit  denen  im File Copper1 sind. In unserem Fall
laden wir ein Bild unter das Label PIC:

PIC:
	incbin "amiga.320*256*3"

Dieses Bild ist aber nicht in Textform vorhanden, sondern wirklich als
Bytes, die die Bitplane ergeben: probiert es in einen Textbuffer zu laden
und ihr werdet sehen, daß es sich nicht um einen Text handelt.

Wie ihr bemerkt habt, ist der Name so angegeben worden, daß er die
Eigenschaften des Bildes selbst wiederspiegelt; es ist besser solche Namen
zu vergeben, ansonsten riskiert man, zu vergessen, wie dieses Bild
aufgebaut war, wieviele Bitplanes, die Dimension...   Aus der Länge dieses
Files kann man aber schließen, welche Auflösung und wieviele Bitplanes das
Bild hat: es ist 30720 Bytes lang, also 40*256*3 (40 Bytes pro Zeile * 256
Zeilen * 3 Bitplanes). Jetzt noch dem Copper sagen, daß das Bild unter dem
Label PIC: steht, und das war´s auch schon.

Aber um die Bitplanes ohne Risiko anzupointen, muß man die Pointer in  die
Copperlist  geben.  Diese  Pointer können jeweils ein Word enthalten, also
eine  halbe  Adresse  (eine  Adresse  ist  ein  Longword  lang!  Beispiel:
$00020000).  Wenn  wir  den  Prozessor  verwenden,  können  wir  auch zwei
Register aus Word mit einem einzigen move.l laden

	MOVE.L	#BITPLANE00,$dff0e0 ; BPL0PT
	MOVE.L	#BITPLANE01,$dff0e4 ; BPL1PT (2 Word weiter vorne als $dff0e0)
 
Aber in der Copperlist kann  ein  Move  bekanntlicherweise  nur  ein  Word
verstellen:

	MOVE.W	#$123,$dff180   -->>   dc.w  $180,$123

Im Falle der Pointer zu den Bitplanes müssen wir also jede Adresse, die  ja
1 Longword lang ist, in zwei Words aufteilen, um so tun zu können:

	MOVE.W	#BITPL,$dff0e0	; BPL0PTH (H=Hochwertiges Word der Adresse)
	MOVE.W	#ANE00,$dff0e2	; BPL0PTL (L=Niederwertiges Word der Adresse)
	MOVE.W	#BITPL,$dff0e4	; BPL1PTH
	MOVE.W	#ANE01,$dff0e6	; BPL1PTL

 BPLxPTH	= BitPLane x PoinTer High word , Pointer Hochwertiges Word
 BPLxPTL	= BitPLane x PoinTer Low word , Pointer Niederwertiges Word
 
Wir haben BITPLANE00 (1 Longword lang) in zwei Word  zerteilt,  BITPL  und
ANE00,  und  somit  mit zwei MOVE.W, die für die Copperlist geeignet sind,
das gleiche erzielt wie mit einem MOVE.L. In der Copperlist würde es  dann
so aussehen:

	dc.w	$e0,BITPL		; BPL0PTH \erste Bitplane
	dc.w	$e2,ANE00		; BPL0PTL /

	dc.w	$e4,BITPL		; BPL1PTH \zweite Bitplane
	dc.w	$e6,ANE01		; BPL1PTL /
	
(denn $dff0e0 wird in der Copperlist zu $e0, etc.)

Diese Spaltung nennt man Aufteilung eines  Longword  in  ein  hochwertiges
Word  und  ein  niederwertiges  Word, wobei das hochwertige das Word links
ist, das BITPL, das niederwertige hingegen  das  rechte,  bei  uns  ANE00.
Machen wir ein Beispiel mit echten Adressen:

Die Bitplane0 befindet sich auf Adresse $23400, die Bitplane1 auf $25c00

	dc.w	$e0,$0002	\Erste Bitplane (hochw. Word)	 \$00023400
	dc.w	$e2,$3400	/				 (niederw. Word) /

	dc.w	$e4,$0002	\Zweite Bitplane (hochw. Word)   \$00025c00
	dc.w	$e6,$5c00	/				 (niederw. Word) /

Ihr  werdet  euch  schon  vorstellen, daß um die richtigen Adressen in die
Copperlist zu geben, es zuerst  nötig  ist zu  kontrollieren, auf  welcher
Adresse   das  Bild  liegt  und  dann  händisch  die  entsprechenden  Word
austauschen. Aber es reicht eine kleine Routine zu einem  Dutzend  Zeilen,
die  uns  diese  Arbeit  des  Teilens  der  Adressen  und das Einsetzen am
richtigen Ort abnimmt. Diese Routine ermöglicht uns, jedes Bild  an  jedem
Ort  im  Speicher anzupointen, egal wieviele Bitplanes es hat und wie groß
es ist! Lediglich die Parameter müssen verändert werden. Der  Trick  liegt
in  einem  Befehl  des  68000er, dem SWAP, das zwei Word in einem Longword
vertauscht, und somit das hochwertige, das niederwertige wird und umgekehrt:

	MOVE.L	#HUNDMAUS,d0	; in d0 kommt das Longword HUNDMAUS

	SWAP	d0				; Wir vertauschen die Words, wir haben in
							; d0 MAUSHUND!!

Dieser Befehl funktioniert nur auf DATENREGISTERN.
Auf die gleiche Weise wird $00023400 zu $34000002.
Schauen wir uns die Routine an:


	MOVE.L	#PIC,d0			; in d0 kommt die Adresse von PIC, also
							; wo dessen erstes Bitplane beginnt

	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Pointer
							; auf die Planes der COPPERLIST
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; um den DBRA-Zyklus auszuführen
POINTBP:
	move.w	d0,6(a1)		; kopiert das niederwertige Word der Adresse
							; des Plane ins richtige Word der Copperlist
	swap	d0				; vertauscht di 2 Word von d0 (z.B.: 1234 > 3412)
							; Das hochw. Word kommt an die Stelle des niederw.
							; Word, dadurch erlaubt es das Kopieren mit move.w!!
	move.w  d0,2(a1)		; kopiert das hochwertige Word der Adresse
							; des Plane in das richtige Word der Copperlist
	swap	d0				; Vertauscht die 2 Word von d0 (z.B.: 3412 > 1234)
							; es stellt also die richtige Adresse wieder her
	ADD.L	#40*256,d0		; Wir zählen 10240 zu D0 dazu, somit zeigen wir
							; auf das zweite Bitplane (es befindet sich nach
							; dem ersten), wir addieren also die Länge eines
							; Plane. In den nächsten Durchgängen werden wir
							; auf das dritte, das vierte etc. zeigen

	addq.w  #8,a1			; a1 enthält nun die Adresse der nächsten
							; Bplpointers in der Copperlist, die es
							; einzusetzen gilt.
	dbra	d1,POINTBP		; Wiederhole D1 Mal POINTBP
							; (D1=Num. of Bitplanes)

Wir verändern dieses Stück Copperlist:

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane (BPL0PT)
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane (BPL1PT)
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane (BPL2PT)
	
Diese Routine tut nichts anderes als die Adresse der  Bitplane  zu  holen,
und  dessen niederwertiges Word ins Word nach dem $e2 in die Copperlist zu
kopieren, also dem Pointer auf das niederwertige Word dieser Adresse  (der
sich  6 Bytes nach BPLPOINTERS befindet, ich habe dazu ein move.w d0,6(a1)
verwendet, wobei in a1 die Adresse von  BPLPOINTERS  steht).  Nachdem  das
niederwertige  Word  erledigt  ist,  vertauschen  wir  mit  dem  SWAP  das
hochwertige Word mit dem niederwertigen,  und  ermöglichen  so  mit  einem
weiteren move.w d0,2(a1) das Kopieren des höherwertigen Word an die Stelle
nach dem  $e0, also dem Pointer auf den höherwertigen Teil der Adresse der
Bitplane.
Jetzt haben wir die erste Bitplane ANGEPOINTET: (z.B. $23400)

BPLPOINTERS:
	dc.w $00e0,$0002,$00e2,$3400	; BPL0PT - erste Bitplane *GEPOINTET*
	dc.w $00e4,$0000,$00e6,$0000	; BPL1PT - zweite Bitplane
	dc.w $00e8,$0000,$00ea,$0000	; BPL2PT - dritte Bitplane

		    ^		^
		    |		|
		  2(a1)	      6(a1)	; Bemerkt die Verwendung der Offset
							; um das Word an der richtigen 
							; Stelle einzufügen.

Bemerkung: mit dem move.w d0,x(a1) kopieren wir das niederwertige Word des 
Longwords in d0, weil die Kopie wie folgt abläuft:

	move.w	#HUNDMAUS,2(a1)	; in Adresse 2(a1) kommt MAUS

Daraufhin stellen wir die Adresse mit einem weiteren SWAP wieder  her,  um
mit  einem  ADD.L  #LÄNGEBITPLANE,d0  zum nächsten Plane zu schreiten. Mit
einem addq.w #8,a1 gehen wir zu den Pointern für das zweite Bitplane über,
denn  wenn  in  a1  die  Adresse  von  BPLPOINTERS  steht, und wir 8 Bytes
dazuzählen (4 Words), dann kommen wir hier hin:

BPLPOINTERS:
	dc.w $00e0,$0002,$00e2,$3400	; BPL0PT - erste Bitplane *GEPOINTET*
a1ZEIGTHIERHER:
	dc.w $00e4,$0000,$00e6,$0000	; BPL1PT - zweite Bitplane
	dc.w $00e8,$0000,$00ea,$0000	; BPL2PT - dritte Bitplane
	
Wir wiederholen diese Routine mit einem "DBRA d1,label"-Zyklus, in unserem
Fall  drei  Mal, um 3 Bitplanes anzupointen. (Wie ihr euch sicher erinnert
muß beim DBRA-Zyklus die Anzahl der Durchgänge-1 eingegeben  werden,  weil
der erste Durchgang nicht gezählt wird. In d1 steht hier deshalb auch 2.)

Diese  Routine  hat die klassische Struktur einer Routine, die Effekte mit
dem Copper vor hat. Sie zu verstehen ist also fundamental.  Eine  ähnliche
Routine  habt  ihr  schon  in  Listing3h.s  vorgefunden,  dort  wurde  ein
DBRA-Loop dazu verwendet, um 29 Wait in der Copperlist zu verändern.

Ladet Listing4a.s um in der Praxis die Ausführung  dieser  BITPLANEPOINTER
Routine zu sehen. Verwendet den Debug dazu.

Nun  fehlen  unserem  kleinen  Programm nur noch zwei "Verfeinerungen", um
Probleme bei der Darstellung der Bilder zu vermeiden: zum einen  ein  paar
Befehle um das AGA-Chipset auszuschalten, und somit die Kompatibilität mit
den A1200 und  A4000  herzustellen,  zum  anderen  einige  Zeilen  in  der
Copperlist, die die Sprites verschwinden läßt, die sonst ziellos durch die
Gegend schwirren würden. Um das AGA zu deaktivieren,  reichen  diese  zwei
Zeilen:

	move.w	#0,$dff1fc			; FMODE - deaktiviert das AGA
	move.w	#$c00,$dff106		; BPLCON3 - deaktiviert das AGA

Und wenn ihr unbedingt auf Nummer sicher gehen wollt, auch noch das:
(Pallette Sprite)

	move.w	#$11,$dff10c		; BPLCON4 - resetiert Sprite-Palette

Diese  paar  Zeilen  werden  nach  dem  Anpeilen  der   neuen   Copperlist
ausgeführt.  Um die besoffenen Sprites zu stoppen, müssen wir ihre Pointer
auf NULL zeigen lassen:

	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000
 
(Bemerkung: Die Register von  $dff120 bis $dff13e heißen SPR0PT, SPR1PT...
SPR7PT)

Wir  werden  über  die  Sprites  später  noch  zu  reden kommen, im Moment
schaffen wir sie einfach aus dem Weg, z.B. durch ein  CUT&PASTE,  mit  dem
ihr   dieses  Stück  einfach  in  eure  Copperlist  einfügt.  Die  Sprites
erschienen nicht, wenn wir alle Bitplanes ausgeschaltet hatten,  aber  ein
einziger reicht, und sie werden lebendig.

Endlich könnt ihr in der Praxis sehen, wie ein Bild angezeigt wird.  Ladet
Listing4b.s in einen beliebigen Buffer.

Habt  ihr  versucht,  Copppereffekte  beizumischen???  Ladet  das Beispiel
Listing4c.s für eine Mischung mit einigen schon gesehenen Effekten.

Habt ihr nun die Wichtigkeit des WAIT in  einer  Copperlist  mit  Bitplane
begriffen?  Es  ermöglicht uns, auch in jeder Zeile Farbe zu wechseln (und
nicht nur das). Jetzt müßt ihr nur noch ein Bild anzeigen, das ihr gemacht
habt,  und  es  mit  dem aus dem Kurs ersetzen. Dafür müßt ihr ein Bild in
320x256 Pixel in 8 Farben besitzen. Wenn ihr gerade keines  bei  der  Hand
habt,  dann  kritzelt  mal schnell was zusammen, oder konvertiert ein Bild
mit einem Utility wie ADPRO in dieses Format. Habt ihr mal dieses Bild  in
IFF-Format  (auf  einer  formatierten  Diskette),  mit dem Namen, der euch
gefällt, z.B. "BILD", dann müßt ihr es in RAW konvertieren,  also  in  das
REALE  Format  der  Bitplanes,  so, wie es der Copper lesen kann. Ladet es
dazu mit dem IFF-Konverter auf dieser  Diskette,  dem  KEFCON,  der  viele
Optionen  hat,  die  wir  aber erst nachher diskutieren werden. Lest diese
Anweisungen bevor ihr ihn startet:
Der Konverter ist in Hardware-Assembler programmiert, deshalb  unterstützt
er  nicht  das  Multitasking, und  man  kann sein Fenster nicht nach unten
schieben, um die Lektion zu lesen, da sein Fenster eine eigene  Copperlist
ist, und nicht die des Systemes. Es ist kompatibel zum AGA und macht keine
Probleme (die guten, alten Programmierer!). Bereitet euch zuerst das  Bild
auf einer formatierten Diskette vor, die  ihr einlegen werdet, nachdem ihr
den KEFCON von df0: gestartet habt (internes Disk Drive),  oder  vom  df1:
(extern, wenn ihr eines habt).
Einmal geladen, erscheint oben ein Menü mit einigen Optionen, die, die uns
aber interessieren sind: (ich mache euch ein Schema der "Knöpfe")

	 ------	 	 ----------
	| SAVE |	| IFF ILBM |
	 ------ 	 ----------

	 ------		 ----------
	| LOAD |	| READ DIR |
	 ------ 	 ----------

	 ------
	| QUIT |
	 ------ 

  -------------------------------------------
 | HIER BEFINDET SICH EIN LÄNGLICHES FENSTER | - Hier kommt der Name
  -------------------------------------------	 des File hinein

LOAD, SAVE und  QUIT bedeuten  natürlich  LADE,  SPEICHERE  und  ENDE  DES
PROGRAMMES. READ DIR dient dazu, im rechten Fenster die Liste der File auf
der Diskette anzuzeigen, ihre Directory.
IFF ILBM ist ein Knopf, der anzeigt, welchen Typ von  File  man  speichern
oder  laden  kann,  in diesem Fall ist er genau richtig mit IFF ILBM, weil
wir ein IFF-Bild laden müssen. Wenn wir später das Bild in RAW abspeichern
wollen,  dann  müssen wir  nur auf diesen Knopf drücken, der zu "RAW NORM"
wird. Das Bild wird nun als RAW gespeichert. Andere Formate sind u.a. auch
"SPRITE"  und  "RAW  BLIT",  wir  werden  sie  in  den  nächsten  Kapiteln
verwenden. Im Moment interessiert uns nur "RAW NORM" und  "COPPER",  wobei
"COPPER"  die  Palette  der  Farben  direkt in einen Textfile mit den dc.w
abspeichert, die wir dann gleich in unsere Copperlist einsetzen können!
Um die Konvertierung zu vollziehen, klickt auf das längliche Fenster,  das
sich   unten  befindet,  wo  dann  der  Schriftzug  "ALLOCATE  GFX-BUFFER"
erscheinen wird und in "df0:" mutieren wird. Wenn ihr das  Bild  auf  df0:
habt, dann laßt alles so, wie es ist, ansonsten gebt euren Drive ein, etwa
df1: oder dh0: (HardDisk). Um die Directory zu lesen,  drückt  "READ  DIR"
und  wählt  dann euer Bild aus und drückt "LOAD". Das Bild wird erscheinen
und ihr könnt mit den Cursortasten rauf- und runterscrollen.
Einmal  das  Bild  geladen,  erscheinen  dessen  Charakteristiken  in  dem
länglichen  Fenster:  "Bitplane  $2800,  Total  $7800". Jedes Bitplane ist
$2800 lang (oder 10240 in Dezimal, 40*256), und gesamt ist das  RAW  $7800
lang,   oder   30720   (40*256*3).   Darüber   sind   auch   die   anderen
Charakteristiken angegeben:

 WIDTH: 320 (BREITE), HEIGHT 256 (LÄNGE), DEPTH 3 (ANZAHL DER BITPLANES)

Nun klickt auf den Knopf "IFF-ILBM", bis er in "RAW NORM" ändert.  Um  das
Pic  nun  in RAW zu speichern, klickt mit dem linken Mausknopf nochmal auf
das  längliche  Fenster,  gebt  den  zu  speichernden  Namen   ein,   z.B.
"df0:Bild.RAW" und drückt "SAVE". Das RAW, das mit INCBIN reingeholt wird,
ist abgespeichert! Nun drückt solange auf den Knopf mit  "RAW  NORM",  bis
"COPPER"  erscheint.  Wiederholt die Speicherprozedur, gebt dem File einen
Namen, z.B. "Bild.s"   und  drückt  erneut  "SAVE".  Nun  könnt  ihr  auch
aussteigen,  das Bild wurde in RAW abgespeichert und die Palette als dc.w,
wie wir sie dann reinholen können.

Um das Bild anzuzeigen, ladet Listing4b.s und macht  folgende  Änderungen:
ändert  den  Namen  des  Bildes, den es zu laden gilt, indem ihr den Namen
eures Bildes eingebt:

PIC:
	incbin "amiga.320*200*3"

könnt ihr in

PIC:
	incbin "df0:Bild.RAW"

ändern. Oder ihr schreibt "v df0:"in der Kommandozeile, und es reicht ein:

PIC:
	incbin "Bild.RAW"

Für die Palette gibt es zwei Methoden: entwder ihr ladet "Bild.s" in einen
anderen  Textbuffer und kopiert es dann mit Amiga+b+c+i in die Copperlist,
oder ihr verwendetden "I"-Befehl des ASMONE, "INSERT". Er fügt einen  Text
dort ein, wo  sich  gerade  der  Cursor befand, bevor ESC gedrückt und zur
Kommandozeile gewechselt wurde. Wie ihr es  auch  angeht,  eliminiert  die
alte Palette mit dem CUT (Ausschneiden) des Editor, Amiga+b zum auswählen,
Amiga+x zum killen.

Hat funktioniert?? Ich hoffe schon, ansonsten bedeutet es, daß  ihr  einen
Durchgang  falsch  gemacht  habt, und zur Strafe alles nochmal wiederholen
müßt.

Um mit Freude am Werk zu bleiben, fahren wir fort, indem wir ein  Bild  in
32  Farben  darstellen.  Dazu  braucht  ihr  das  übliche Bild in 320*256,
diesmal aber in 32 Farben (wenn ihr wirklich keines  habt,  dann  schmiert
irgend  etwas  obszönes  mit  dem  DPaint zusammen). Konvertiert alles wie
vorhin, und ihr werdet bemerken, daß  alles  nach  Plan  läuft:  "Bitplane
$2800, Total $c800". In der Tat, jede  Bitplane ist immer noch $2800 lang,
aber die Gesamtgröße ist klarerweise gewachsen, weil wir hier 5  Bitplanes
(2^5=32)  haben,  und  5*$2800  =  $c800.  Speichert  in .RAW ab, dann die
Palette, z.B. mit Namen wie "Bild32.RAW" und "Bild32.S".

Um es anzuzeigen, müßt ihr beim Listing4b.s die gleichen  zwei  Änderungen
wie  vorhin  machen.  Ersetzt  die  alte  Palette mit der neuen (die jetzt
länger sein wird als die mit nur 8 Farben!). Weiters müßt ihr  die  Anzahl
der  Bitplanes  in  der Pointer-Routine ändern, um die fehlenden zwei auch
noch einzubeziehen:

	MOVE.L	#PIC,d0			; in d0 kommt die Adresse von PIC, also
							; wo dessen erste Bitplane beginnt

	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Pointer
							; auf die Planes der COPPERLIST
**->	MOVEQ	#4,D1		; Anzahl der Bitplanes -1 (hier sind es 5!!)
							; um den DBRA-Zyklus auszuführen
POINTBP:
	....

1) Ändert das MOVEQ #2,D1 in MOVEQ #4,D1 ab, jetzt werden also statt  drei
DBRA-Zyklen  fünf  durchlaufen  (5-1=4),  wir pointen fünf Planes an. Aber
dann müssen auch die fehlenden Pointer in der Copperlist eingefügt werden:

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste  Bitplane (BPL0PT)
	dc.w $e4,$0000,$e6,$0000	; zweite Bitplane (BPL1PT)
	dc.w $e8,$0000,$ea,$0000	; dritte Bitplane (BPL2PT)
	dc.w $ec,$0000,$ee,$0000	; vierte bitplane (JETZT DAZUGEKOMMEN!)
	dc.w $f0,$0000,$f2,$0000	; fünfte bitplane (JETZT DAZUGEKOMMEN!)

Letzte und wichtigste Änderung: wir müssen nun fünf Planes  "einschalten",
und nicht mehr nur drei. Eine Änderung an BPLCON0 muß her:

				; 5432109876543210
	dc.w	$100,%0101001000000000  ; bits 14,12 an!! (5 = %101)
 
Assembliert alles und das Bild in 32 Farben müßte erscheinen.

Durch diese zwei Beispiele könnt ihr nun leicht erahnen, wie man Bilder zu
2, 4, 8 und 16 Farben anzeigt! Die Anzahl der Loops in der Pointer-Routine
anpassen, und die richtigen Bits in $dff100 (BPLCON0) setzen.

Sehen wir nun, wie man ein Bild in EHB mit 64 Farben und eines in HAM mit
4096 Farben anzeigt, indem man die zwei speziellen Grafikmodi anschaltet.

Starten  wir  bei  dem HAM-Bild: erstellt euch eine Pic in 320x256 in HAM,
oder sucht eines der vielen HAM-Figuren, die  so  oft  auf  Disketten  mit
"SEXY"-Inhalt  verwendet werden. Es wird meißt HAM verwendet, weil es sehr
auf hohe Farbtreue ankommt, wenn man eine nackte Frau anzeigt. Ich glaube,
es  ist  schöner  ein nacktes Girl anzuzeigen als eine Obstschale... Ladet
das Ham-Bild wie nach Drehbuch mit dem KEFCON und speichert  sie  als  RAW
und COPPERLIST.
Leider hat der KEFCON einen Programmierfehler, denn  wenn  Figuren  mit  6
Bitplanes  auf  A4000  geladen  werden,  seien  sie  nun  in HAM oder EHB,
verursachen sie eine "Verwirrung" der Zahlen und Satzzeichen im Menü  (auf
A500/2000/600  funkt´s  aber!),  deswegen  könnt ihr nur die Worte richtig
lesen, aber das ist sicher kein Problem, da ihr ja nur auf  das  längliche
Fenster  klicken  und  einen anderen Namen eigeben müßt. Einmal, z.B. .RAW
und einmal .S für die Copperlist.
Nun müßt ihr noch die fehlenden Pointer für Bitplane 6 in  der  Copperlist
dazufügen,  und  die  Anzahl  der Zyklen in der Routine so ändern, daß sie
sechs mal ausgeführt wird:

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste  Bitplane - BPL0PT
	dc.w $e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	dc.w $e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT
	dc.w $ec,$0000,$ee,$0000	; vierte Bitplane - BPL3PT
	dc.w $f0,$0000,$f2,$0000	; fünfte Bitplane - BPL4PT
	dc.w $f4,$0000,$f6,$0000	; sechste Bitplane (JETZT DAZU!)


**->	MOVEQ	#5,D1		; Anzahl der Bitplanes -1 (hier sind es 6!!!!!)

POINTBP:
	...

Auch das BPLCON0:

		  ; 5432109876543210
 dc.w $100,%0110101000000000	; ---> 6 Plane in HAM Lowres (4096 Farben)
								; BIT 11 gesetzt = HAM!


Die Funktion des HAM wird später näher betrachtet.

				*

Um ein Bild in Extra Half Bright anzuzeigen, konvertiert ein  solches  mit
dem KEFCON, laßt es mit dem INCBIN laden, ersetzt die Palette, pointet das
sechste Bitplane an und setzt das Bit 11 von BPLCON0 auf 0:

		  ; 5432109876543210
 dc.w $100,%0110001000000000	; ---> 6 Plane in EHB Lowres (64 Farben)
  
Bemerkung: Im EHB - Modus stehen zwar 64 Farben  zur  Verfügung,  aber  es
können  nicht  alle  frei  verändert  werden:  der  Amiga  besitzt  nur 32
Farbregister; die anderen 32  Farben  sind  gleich  mit  den  ersten,  nur
dunkler, eine Art "Halbe Helligkeit", eben "HALF BRIGHT".

Nun,  da wir wissen, wie man Bilder anzeigt, sehen wir uns die Effekte an,
die wir mit den Scroll-Registern erzeugen können. Ladet  LEKTION5.TXT  mit
"r".
