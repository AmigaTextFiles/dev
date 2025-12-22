
ASSEMBLERKURS - LEKTION 7

In  dieser  Lektion  werden  wir  über  die  Sprites, den Joystick und den
logischen Operationen des 68000ers wie  AND, OR, EOR, NOT, LSR, ROL,   etc
sprechen.

Erinnert  euch,  "V LISTINGS3" zu tippen, um die .raw - Files, die sich in
dieser Directory befinden, laden zu können. Dort befinden  sich  auch  die
Listings aus dieser Lektion.

Die  Sprites  sind  grafische Objekte mit einer präzisen Größe, maximal 16
Pixel breit, die sich unabhängig von den  Bitplanes  bewegen  lassen.  Der
Mauspointer  z.B.  ist  ein  solcher  Sprite,  er  wird vom Betriebssystem
verwaltet. Er kann sich überall  bewegen,  ohne  sich  um  die  "darunter"
liegenden Bitplanes Gedanken machen zu müssen.
Die Sprites könnte man als "Geister"-Bilder auffassen, die sich "über" den
Bitplanes  bewegen,  aber  Achtung:  nicht  alles,  was  sich bewegt, sind
Sprites! Denn es können maximal 8 davon dargestellt werden, da  es  nur  8
Pointer in der Copperlist für sie gibt:

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0	; Pointer für Sprite 0
	dc.w	$124,0,$126,0	; Pointer für Sprite 1
	dc.w	$128,0,$12a,0	; ""	""	""   2
	dc.w	$12c,0,$12e,0	; ""	""	""   3
	dc.w	$130,0,$132,0	; ""	""	""   4
	dc.w	$134,0,$136,0	; ""	""	""   5
	dc.w	$138,0,$13a,0	; ""	""	""   6
	dc.w	$13c,0,$13e,0	; ""	""	""   7

Die Pointer auf die  Sprites  heißen  SPRxPT  (an  Stelle  der  "x"  kommt
natürlich  die  Nummer  des  Sprites:  wir haben also SPR0PT, SPR1PT, ...,
SPR7PT, und wenn wir von SPRxPT  sprechen,  meinen  wir  generell  alle  8
Pointer).  Bis  jetzt  haben  wir  sie  in  der  Copperlist immer auf NULL
gesetzt, damit sie uns nicht stören, denn wenn sie "frei rumlaufen"  haben
wir sie immer auf unseren Bildern sitzen.
Die Sprites sind vom Rest des Screens isoliert, fast so, als wären sie  in
einem  durchsichtigen  Couvert  über  dem  Bildschirm,  sie  sind immer in
Lowres, auch wenn der Screen in HiRes oder Interlace arbeitet. Ein  Beweis
dafür,  daß  sie  mit  den Bitplanes nichts zu tun haben ist, daß man sie,
wenn wir sie bewegen wollen, nicht löschen und weiter  hinten  neuzeichnen
müssen,  wie es der Fall wäre, wenn wir ein Stück Grafik in einer Bitplane
bewegen möchten.
Um einen Sprite zu bewegen, brauchen wir  nur  seine  Koordinaten  ändern,
indem  wir  mit wenigen und schnellen Befehlen auf einige dafür bestimmten
Bytes am Anfang der Spritestruktur  selbst  zugreifen.  Wenn  die  Sprites
nicht  ausreichen, um Raumschiffe und Figuren in einem Spiel darzustellen,
dann verwenden wir den Blitter, um Grafikblöcke  (Bob)  zu  kopieren.  Wir
werden  später  darauf  zurückkommen.  Wie schon erwähnt, ist die maximale
Breite eines Sprite 16 Pixel, während die Höhe beliebig  sein  kann,  auch
den  ganzen  Bildschirm, 256 Zeilen. Um z.B. das Monster am Ende des Level
darzustellen, könnten wir z.B. alle 8  Sprites  zusammenkleben  und  somit
16*8=128  Pixel  erreichen. Dieses Monster wäre aber recht farblos, da zur
Zeit die Sprites nur 3 Farben haben. Die vierte  ist  der  "durchsichtige"
Teil,   wo   also  der  Hintergrund  durchscheint,  die  darunterliegenden
Bitplanes.

Die Charakteristik der Sprites ist, daß sie einfach  herzustellen  und  zu
animieren  sind.  Denn  man  kann sie einfach mit einem Malprogramm malen,
Hauptsache, sie sind nicht breiter als 16 Pixel und sind  in  drei  Farben
plus  Hintergrund  gehalten.  Danach einfach durch den IFF-Konverter jagen
und in SPRITE konvertieren.
Oder sie können direkt in binär gezeichnet werden, wie  wir  es  schon bei 
den 8x8 Fonts gesehen haben:
  
- Plane 1 - - Plane 2 -		; Die Überlagerung dieser
						    ; zwei "Planes" aus Bits
	dc.w	%0111110000000000,%0111110000000000 ; bestimmt die Farbe. Das
	dc.w	%1000001000000000,%1111111000000000 ; ist der Default - Maus-
	dc.w	%1111010000000000,%1000110000000000 ; pointer des Kickstart 1.3
	dc.w	%1111101000000000,%1000011000000000 ; Erkennt ihr ihn wieder??
	dc.w	%1111110100000000,%1001001100000000
	dc.w	%1110111010000000,%1010100110000000
	dc.w	%0100011101000000,%0100010011000000
	dc.w	%0000001110100000,%0000001001100000
	dc.w	%0000000111100000,%0000000100100000
	dc.w	%0000000011000000,%0000000011000000
	dc.w	%0000000000000000,%0000000000000000

	dc.w	0,0	; Zwei auf NULL gesetzte Word signalisieren das
				; Ende des Sprite.

In diesem Fall ist die Breite 16 Pixel, und nicht 8  wie  bei  den  Fonts,
weil  wir  ihn  in  einem  Word  (dc.w)  und nicht in einem Byte zeichnen.
Weiters hat er 3 Farben plus die Durchsichtige, also insgesamt 4, wie  ein
Bild mit 2 Bitplanes, es braucht also ein Paar von "Planes", genau wie bei
den Bitplanes. Ihre Überlagerung bestimmt die Farbe eines  jeden  Punktes.
Sie kann wie folgt sein:

	Plane 1 - Plane 2

Binär:	 0	-	0	= COLOR 0 (Durchsichtig)
Binär:	 1	-	0	= COLOR 1
Binär:	 0	-	1	= COLOR 2
Binär:	 1	-	1	= COLOR 3

Denn mit 2 Planes ergeben sich vier Überlagerungsmuster:  %00,  %01,  %10,
%11.

Um die Position des Sprite zu bestimmen, müssen wir nichts anderes tun als
die X und Y-Koordinate in den ersten Bytes des Sprite  selbst  einzufügen.
Der  Sprite  besteht nämlich vor den Daten des Bildes aus vier Bytes, oder
zwei Words, den  sogenannten  KONTROLLWORDS,  und  da  hinein  kommen  die
Positionskoordinaten auf dem Bildschirm. Um genauer  zu  sein,  das  erste
Byte, VSTART genannt, beinhaltet die vertikale Position des Spriteanfangs;
das zweite Byte hingegen die horizontale  Position  (HSTART).  Das  Dritte
bekommt  das Ende des Sprites, vertikal gesehen: um diesen Wert zu finden,
ganz einfach die Höhe des Sprites mit  der  Anfangskoordinate  des  selben
addieren  und  rein  damit.  Das Resultat ist nach Adam Riese das Ende des
Sprites.
Im vierten Byte kommen die Spezialfunktionen, wie immer verweise  ich  auf
später.
VSTART und HSTART (Vertical Start und  Horizontal  Start)  sind  also  die
Koordinaten der linken, oberen Ecke des Sprites:

	#....
	.....
	.....
	.....
	.....


VSTOP hingegen ist die vertikale Position des Endes des Sprite:


	.....
	.....
	.....
	.....
	#####	-> Zeile, in der der Sprite aufhört.


Um z.B. einen Sprite an Position XX=$90  und  YY=$50  anzuzeigen,  der  20
Pixel lang ist, werden wir so vorgehen:


		;AYAX  EY - AY=Anfang Y, AX=Anfang X, EY=Ende Y
SPRITE:
	dc.w	$5090,$6400	;Y=$50, X=$90, Höhe= $50+20, alos $64
; hier beginnen die Daten der 2 Plaenes des Sprite:

	dc.w	%0000000000000000,%0000110000110000
	dc.w	%0000000000000000,%0000011001100000
	...
	dc.w	0,0	; Ende des Sprite

Das erste Byte, VSTART, ist auf $50, das Zweite, HSTART, auf $90, und  das
Dritte,  die  vertikale  Position des Spriteendes, auf $64, also $50 + 20.
Also die Anfangsposition + Länge des Sprite. Das vierte  Byte  lassen  wir
vorerst  auf 0. Ich sage euch gleich schon, daß das HSTART einen Sprite um
jeweils 2 Pixel verstellt, wenn wir also $51 eingeben, werden wir auf  $52
gelangen.  Es  sind nur Zweierschritte möglich. Wir werden aber sehen, wie
unter Verwendung des SpeizialBytes Nr. 4 diese Situation in den  Griff  zu
bekommen  ist,  und  das  ein  Scroll von einem Pixel möglich ist. Was den
vertikalen Scroll angeht,  VSTART  und  VSTOP  besorgen  uns  schon  einen
schönen 1-Pixel-Schritt. Das einzige Limit ist die Videozeile $FF, darüber
hinaus kommen wir nur, wenn wir ein Bit  im  vierten  Byte  verwenden.  Am
Anfang  werden wir aus Gründen der Einfachheit nur die Bytes VSTART, VSTOP
und HSTART verwenden, und die Zeierschritte in der Horizontalen hinnehmen.
Erst  später  werden  wir  sehen, wie wir "flüssigere" Scrolls hinkriegen.
Erinnert euch also an die Eigenschaft, das z.B. mit einem:

	ADDQ.B	#1,HSTART

der Sprite um 2 Pixel, und nicht um einen, verstellt wird.

Um auf die 3 Bytes VSTART/HSTART/VSTOP zuzugreifen,  könnte  man  etwa  so
tun:

	MOVE.B	#$50,SPRITE		; VSTART = $50
	MOVE.B	#$90,SPRITE+1	; HSTART = $90
	MOVE.B	#$64,SPRITE+2	; VSTOP  = $64 ($50+20)

Oder man kann ein Label für jedes Byte definieren, und somit alles  klarer
gestalten:


SPRITE:
VSTART:			; Beginn Anfangsposition VERTIKAL
	dc.b $50
HSTART:			; Beginn Anfangsposition HORIZONTAL
	dc.b $90
VSTOP:
	dc.b	$64	; Endposition VERTIKAL
	dc.b	$00	; Byte für Spezialanwendungen, im Moment auf 0

; hier beginnen die Daten für die Planes des Sprite:

	dc.w	%0000000000000000,%0000110000110000
	dc.w	%0000000000000000,%0000011001100000
	...
	dc.w	0,0	; Ende des Sprite

In diesem Fall würden wir auf die Label VSTART, VSTOP und HSTART agieren:

	ADDQ.B  #1,HSTART	; bewegt den Sprite um 2 Pixel nach rechts
						; (2 Pixel und nicht 1, wie oben erklärt)

	SUBQ.B  #1,HSTART	; bewegt den Sprite um 2 Pixel nach links

Um den Sprite nach  Oben  oder  Unten  zu  bewegen  müssen  wir  uns  aber
erinnern, beide Bytes VSTART und VSTOP zu verändern, denn es ist klar, daß
in diesem Fall das erste Pixel wie auch das Letzte seine Position ändert:

	ADDQ.B  #1,VSTART	; \ Bewegt den Sprite um 1 Pixel nach Unten
	ADDQ.B  #1,VSTOP	; /

	SUBQ.B  #1,VSTART	; \ Bewegt den Sprite um 1 Pixel nach Oben
	SUBQ.B  #1,VSTOP	; /


Zur Wiederholung, das ist die Struktur des Sprite:


	Erstes Kontrollword,			zweites Kontrollword
	erste   Zeile (.w) des Plane 1,  erste   Zeile (.w) des Plane 2
	zweite  Zeile (.w) des Plane 1,  zweite  Zeile (.w) des Plane 2
	dritte  Zeile (.w) des Plane 1,  dritte  Zeile (.w) des Plane 2
	vierte  Zeile (.w) des Plane 1,  vierte  Zeile (.w) des Plane 2
	fünfte  Zeile (.w) des Plane 1,  fünfte  Zeile (.w) des Plane 2
	...
	DC.W	0,0			; die letzte Zeile muß zwei Nullen enthalten

Die Daten des Sprite sind in Plane 1 und Plane 2  unterteilt,  einzig  und
alleine,  um  anzuzeigen,  daß  bei  deren  Überlagerung die 3 Farben plus
Transparent zu Stande kommen, analog wie bei den Bitplanes,  es  ist  aber
nicht damit zu verwechseln!


DIE FARBEN DER SPRITE

Um die Farben der Sprites  zu  definieren  müssen  die  gleichen  Register
verwendet  werden  wie bei den Bitplanes, da der Amiga nur 32 Farbregister
besitzt. Die Ingeneure haben gedacht, den Sprites die Farben  vom  16  bis
zum  31  zuzuteilen, somit können die Sprites, wenn das Bild nicht in in 5
Bitplanes -oder 32 Farben - ist, andere  benutzen  als  das  Bild  selbst.
Ansonsten  haben  sie  16 Farben gemeinsam mit dem darunterliegenden Bild.
Schauen wir uns mal an, wie wir die Farben des ersten Sprite hinbekommen:


(Die Sprites sind von 0 bis 7 durchnumeriert)

	COLOR 0 des Sprite 0 = TRANSPARENZ, wird nicht definiert
	COLOR 1 des Sprite 0 = COLOR17 ($dff1a2)
	COLOR 2 des Sprite 0 = COLOR18 ($dff1a4)
	COLOR 3 des Sprite 0 = COLOR19 ($dff1a6)

Color 0, oder die vierte, ist die Transparenz, sie wird nicht definiert.

Sehen wir vor dem weitermachen, das erste  Beispiel  einer  Anzeige  eines
Sprite   in   Listing7a.s   In  diesem  Beispiel  wird  der  erste  Sprite
angepointet,  die  anderen  sieben  beliben  auf  NULL.  Um  einen  Sprite
anzupointen  wird  gleich  vorgegangen  wie  bei den Bitplanes, da sie die
Pointer gleich funktionieren wie bei den Bitplanes:

	MOVE.L	#MEINSPRITE,d0		; Adresse des Sprite in d0
	LEA	SpritePointers,a1		; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

Ich erinnere daran, daß um ein Sprite anzuzeigen, mindestens ein  Bitplane
"eingeschaltet"  sein  muß, ohne Bitplane keine Sprites. Des Weiteren wird
ein Sprite "abgeschnitten", wenn er außerhalb des  Videofensters  gelangt,
das  zuvor mit DIWSTART und DIWSTOP definiert wurde, er kann nur innerhalb
angezeigt  werden.  Um  ihn  z.B.  in  der  Mitte  eines  320x256  Screens
anzuzeigen,  auf  Position 160x128, ist weiters zu beachten, daß die erste
Koordinate links oben nicht 0,0 ist, sondern $40, $2c,  deswegen  muß  $40
zur  X-Koordinate und $2c zur YKoordinate addiert werden. $40+160, $2c+128
entprechen also den Koordinaten 160, 128  in  einem  Screen  320x200  ohne
Overscan.
Da wir noch nicht die 1-Pixel-Kontrolle über die  Sprites  haben  was  die
horiziontale Positionierung angeht, müssen wir nicht 160 addieren, sondern
160/2, wenn wir die Mitte anpeilen wollen:


HSTART:
	dc.b $40+(160/2)	; Positionierung in der Mitte des Screen
	...


Hier  ein  Schema  des  Screens,  in  dem  der  sichtbare  Teil,  also das
Videofenster, hell dargestellt ist, und des  gesamten  Schirms,  außerhalb
des  Randes,  der  bei 0,0 beginnt, mit ###. Beachtet daß das Videofenster
bei $40 XX und $2c YY beginnt.

      (0,0) __
		      \
		       \
				+---------------------------+
				|###########################|
		/\		|###########################|
		||		|###+-------------------+###|
		||		|###| $40,$2c			|###|  __ Rand des sichtbaren
		||		|###|	 ______			|###| /   Teil (Videofenster)
		||		|###|	/Sprite\		|###|/
		||		|###|	|++XX++|		|###/
		||		|###|	\/\/\/\/		|##/|
				|###|					|#/#|
      Y-Achse	|###| 					|/##|
				|###|					|###|
		||		|###|					|###|
		||		|###|					|###|
		||		|###|					|###|
		||		|###|					|###|
		||		|###+-------------------+###|
		\/		|###########################|
				|###########################|
				+--------------------------+
					 <----- Y-Achse ----->


Die horizontale Position des Sprites kann von 0 bis 447 gehen, es ist aber
logisch, daß sie bei einem Screen zu 320 Pixel Breite von 64 bis 383 geht.
Die vertikale hingegen kann von  0  bis  262  gehen,  aber  um  auf  einem
PAL-Screen  sichtbar  zu  sein  (256 Zeilen), muß sie von 44 ($2c) bis zum
Ende des Screens reichen, also bis 44+256=300 (12c). Bis jetzt  haben  wir
nur  die  Zone bis $FF erreicht, wir werden später sehen, wie wir bis $12c
kommen.

In Listing7b.s wird ein Sprite am Bildschirm rauf und runter  gejagt,  das
geschieht mit ADD´s und SUB´s auf die zwei Kontrollword.

In  Listing7c.s  wird der Sprite horizontal bewegt, indem er die Werte aus
einer vordefinierten Tabelle liest anstatt  ADD  und  SUB  anzuwenden.  In
Listing7d.s  wird  er  in  Vertikal  zum Springen gebracht. In Listing7e.s
werden die zwei Koordinaten (XX und YY) von  zwei  verschiedenen  Tabellen
kontrolliert,  um eine Kreisbewegung, Ellipse, etc. zu erzeugen. In diesem
Beispiel wird auch erklärt, wie man sich eigene Tabellen erstellt!

Bevor ihr weitermacht, ladet die Beispiele in  einen  anderen  Buffer  und
führt sie aus, VERSTEHT sie und lest die Kommentare.

Bis  jetzt  haben  wir  nur einen Sprite angezeigt, sehen wir nun, was wir
wissen müssen, um alle 8 auf den Monitor zu bringen.
Zum Anfang mal festgehalten: jeder Sprite hat eine individuelle  Position,
er  ist  in  keiner  Weise  an  die anderen gebunden, da jeder ein eigenes
VSTART, VSTOP und HSTART in seinen zwei  AnfangsWord  hat.  Was  aber  die
Farben  angeht  (und  andere  Eigenschaften, wie etwa Kollisionen, die wir
später sehen werden), da sind die Sprites nicht ganz unabhängig, sie  sind
zu  Zweierpaaren  zusammengehängt.  Es  gibt  also  4 Paare von 2 Sprites:
Sprite0+Sprite1,  Sprite2+Sprite3,  Sprite4+Sprite5,   und   schlußendlich
Sprite6+Sprite7.  Wenn  ich  von  nun  an von "Spritepaar" sprechen werde,
meine ich nicht ein x-beliebiges Paar, aber genau eines von diesen vieren.
Bei  den Farben hängen sie zusammen, d.h. jeweils ein Paar hat die gleiche
Palette, die Paare untereinander können  verschiedene  Farben  haben.  Wir
wissen,  daß  die  3 Farben des Sprite0 mit den Registern COLOR17, COLOR18
und COLOR19 definiert werden. Diese 3 Farben gelten also auch  für  seinen
"Bruder", dem Sprite1.
Jedes Paar hat eine andere Palette, da  es  insgesamt  16  Register  dafür
gibt,  vom  16  bis  zum  31.  Wenn wir davon ausgehen, daß jeder Sprite 4
Farben hat ( 1 davon Transparent), dann bräuchten wir 8*4=32 Register. Wir
haben aber nur 16. Da wir nun aber 8 Sprites mit 4 Farben haben, hier eine
Tabelle, die angibt, welcher Sprite welche Farbe bekommt:

			Sprite     Binärwert	Farbregister:
			------  --------------  ------------------
Paar 1:		0 o 1	  	00			Nicht verwendet da  Transparent
						01			Color17 - $dff1a2
						10			Color18 - $dff1a4
						11			Color19 - $dff1a6

Paar 2:		2 o 3	 	00			Nicht verwendet da  Transparent
						01			Color21 - $dff1aa
						10			Color22 - $dff1ac
						11			Color23 - $dff1ae

Paar 3:		4 o 5		00			Nicht verwendet da  Transparent
						01			Color25 - $dff1b2
						10			Color26 - $dff1b4
						11			Color27 - $dff1b6

Paar 4:		6 o 7		00			Nicht verwendet da  Transparent
						01			Color29 - $dff1ba
						10			Color30 - $dff1bc
						11			Color31 - $dff1be

Machen wir ein praktisches Beispiel: um in der Copperlist die Farben der 8
Sprites zu definieren ist folgendes notwendig:


	dc.w	$1A2,$F00	; color17, - COLOR1 der sprite0/1 -ROT
	dc.w	$1A4,$0F0	; color18, - COLOR2 der sprite0/1 -GRÜN
	dc.w	$1A6,$FF0	; color19, - COLOR3 der sprite0/1 -GELB

	dc.w	$1AA,$FFF	; color21, - COLOR1 der sprite2/3 -WIEß
	dc.w	$1AC,$0BD	; color22, - COLOR2 der sprite2/3 -WASSER
	dc.w	$1AE,$D50	; color23, - COLOR3 der Sprite2/3 -ORANGE

	dc.w	$1B2,$00F	; color25, - COLOR1 der Sprite4/5 -BLAU
	dc.w	$1B4,$F0F	; color26, - COLOR2 der Sprite4/5 -VIOLETT
	dc.w	$1B6,$BBB	; color27, - COLOR3 der Sprite4/5 -GRAU

	dc.w	$1BA,$8E0	; color29, - COLOR1 der Sprite6/7 -HELLGRÜN
	dc.w	$1BC,$a70	; color30, - COLOR2 der Sprite6/7 -BRAUN
	dc.w	$1BE,$d00	; color31, - COLOR3 der Sprite6/7 -DUNKELROT

BEMERKUNG: Wenn ihr als Hintergrund ein Bild in 2,4,8 oder 16 Farben habt,
dann  gibt´s  keine Probleme, aber wenn ihr einen Bildschirm in 32 Farben,
also 5 Bitplanes, aktiviert, dann müßt ihr bedenken, daß  die  letzten  16
Farben  von Bild und Sprites geteilt werden. Die Farbe muß also für´s Bild
stimmen, genauso wie für die Sprites, die Farben müssen "Multifunktionell"
sein.

DIE VIDEOPRIORITÄT ZWISCHEN DEN SPRITES

Wenn zwei oder mehr Sprites am Bildschirm angezeigt werden, dann  kann  es
leicht  vorkommen, daß sie sich überlappen. In diesem Fall wird der Sprite
mit der niedrigeren Priorität überdeckt. Die Prioritäten  sind  immer  die
gleichen,  der Sprite mit der kleineren Nummer hat Vorrang gegenüber einem
mit Höhere. Daraus folgt, daß  Sprite0  alle  anderen  Sprites  überdecken
kann,  und  Sprite7  von  allen  anderen  überdeckt  werden kann. Hier ein
kleines Schema:
								     _______
								    |	    |
								 ___|___7   |
							    |	    |___|
							 ___|___6   |
							|	    |___|
						 ___|___5   |
						|       |___|
					 ___|___4   |
					|	    |___|
		         ___|___3   |
		        |       |___|
		     ___|___2   |
		    |	    |___|
		 ___|___1   |
		|		|___|
		|   0   |
		|_______|

Überprüft das, indem ihr Listing7f.s in einen  anderen  Buffer  ladet  und
ausführt.  Er  zeigt  8  Sprites  an,  und  nach  dem  Druck auf die linke
Maustaste werden sie übereinandergelegt, um die Prioritäten hervorzuheben.
Rechte Taste um auszusteigen.

"ATTACHED"-SPRITES

Es  existiert  auch  eine  Methode,  um  die   Sprites   in   Zweierpaaren
zusammenzuschweißen,  einen  über  dem  anderen.  Damit  halbiert sich die
Anzahl der verfügbaren Sprites, aber es sind als Trost 16  Farben  möglich
(na ja, 15 + Transparent). Sie können folgendermaßen kombiniert werden:

	SPRITE0+SPRITE1	- Sprite ATTACCHED Nummer 1
	SPRITE2+SPRITE3	- Sprite ATTACCHED Nummer 2
	SPRITE4+SPRITE5	- Sprite ATTACCHED Nummer 3
	SPRITE6+SPRITE7	- Sprite ATTACCHED Nummer 4

In  der  Praxis  werden  die  selben Sprites verbündet, die im Normalmodus
schon eine Verbindung eingegangen sind, die der selben Palette.  Die  vier
"Attached"-Sprites  besitzen  alle  die gleiche Palette, da ja nur mehr 16
Farben übrig sind, von COLOR16 bis COLOR31.
Die  ATTACHED-Sprites  funktionieren   auf   folgende   Art   und   Weise:
normalerweise hat ein Sprite maximal 4 Überlappungsmöglichkeiten, also %00
für die Transparenz, %01, %10, %11 für die drei Farben. Im  Attached-Modus
werden  die  Planes  des  Sprite  übereinandergelegt  und ergeben somit 16
mögliche Situationen, denn 2 Planes vom ersten Sprite plus 2 Planes vom  2
Sprite   ergeben  4  Planes,  oder  %0000  bis  %1111,  also  16  statt  4
Möglichkeiten.  In  der  folgenden  Tabelle  werden   die   16   möglichen
Überlappungsmuster aufgelistet, daneben die dazugehörige Farbe.

		Sprite  Binär   Nummer des
		Farbe	wert	Farbregisters
		-------	------	--------------
		0		0000	Color16 - NICHT VERWENDET, TRANSPARENT
		1		0001	Color17 - $dff1a2
		2		0010	Color18 - $dff1a4
		3		0011	Color19 - $dff1a6
		4		0100	Color20 - $dff1a8
		5		0101	Color21 - $dff1aa
		6		0110	Color22 - $dff1ac
		7		0111	Color23 - $dff1ae
		8		1000	Color24 - $dff1b0
		9		1001	Color25 - $dff1b2
		10		1010	Color26 - $dff1b4
		11		1011	Color27 - $dff1b6
		12		1100	Color28 - $dff1b8
		13		1101	Color29 - $dff1ba
		14		1110	Color30 - $dff1bc
		15		1111	Color31 - $dff1be

In der COPPERLIST müssen sie also so definiert werden:

	dc.w	$1A2,$F00	; color17, FARBE  1 für die Attached-Sprites
	dc.w	$1A4,$0F0	; color18, FARBE  2 für die Attached-Sprites
	dc.w	$1A6,$FF0	; color19, FARBE  3 für die Attached-Sprites
	dc.w	$1A8,$FF0	; color20, FARBE  4 für die Attached-Sprites
	dc.w	$1AA,$FFF	; color21, FARBE  5 für die Attached-Sprites
	dc.w	$1AC,$0BD	; color22, FARBE  6 für die Attached-Sprites
	dc.w	$1AE,$D50	; color23, FARBE  7 für die Attached-Sprites
	dc.w	$1B0,$D50	; color24, FARBE  7 für die Attached-Sprites
	dc.w	$1B2,$00F	; color25, FARBE  9 für die Attached-Sprites
	dc.w	$1B4,$F0F	; color26, FARBE 10 für die Attached-Sprites
	dc.w	$1B6,$BBB	; color27, FARBE 11 für die Attached-Sprites
	dc.w	$1B8,$BBB	; color28, FARBE 12 für die Attached-Sprites
	dc.w	$1BA,$8E0	; color29, FARBE 13 für die Attached-Sprites
	dc.w	$1BC,$a70	; color30, FARBE 14 für die Attached-Sprites
	dc.w	$1BE,$d00	; color31, FARBE 15 für die Attached-Sprites

Um zwei Sprites zu vermählen muß nur das Bit 7  des  zweiten  Kontrollword
des  ungeraden  Sprite  im  Paar  auf  1  gesetzt  werden  (also  Bit 7 im
berühmt-berüchtigten vierten Byte  der  Spezialfunktionen).  Um  z.B.  die
Sprites 0 und 1 zusammenzuschließen, einfach dieses Bit im Sprite1 setzen,
um Sprite 4 und 5 zu koppeln Bit 7 im Byte 4 des Sprite  5.  Es  ist  wohl
einleuchtend, daß die Sprites die gleichen Koordinaten haben müssen, damit
die vier Planes genau übereinanderliegen, sonst wird wohl  kein  richtiges
Überlagerungsmuster  entstehen!  Machen wir ein Beispiel: um die Sprites 0
und 1 zusammenzubringen, müssen wir das Bit 7 des vierten Words im Sprite1
auf High (1) setzen:


SPRITE0:
VSTART0:		; Anfangsposition VERTIKAL
	dc.b $50
HSTART0:		; Anfangsposition HORIZONTAL
	dc.b $90
VSTOP0:
	dc.b	$64	; Endposition VERTIKAL
	dc.b	$00	; Bei geraden Sprites muß Bit 7 nicht gesetzt werden.
; ab hier beginnen die Daten für die zwei Planes des Sprite
	dc.w	%0000000000000000,%0000110000110000
	dc.w	%0000000000000000,%0000011001100000
	...
	dc.w	0,0	; Ende Sprite0


SPRITE1:
VSTART1:			; Anfangsposition VERTIKAL
	dc.b $50
HSTART:				; Anfangsposition HORIZONTAL
	dc.b $90
VSTOP:
	dc.b	$64		; Endposition Vertikal

			;76543210
	dc.b	%10000000	; BIT 7 GESETZT! ATTACCHED MODE 
					; für Sprite 0/1

; ab hier beginnen die Daten für die 2 Planes des Sprite
	dc.w	%0000000000000000,%0000110000110000
	dc.w	%0000000000000000,%0000011001100000
	...
	dc.w	0,0		; Ende Sprite1


Um also die Sprites "Attached" zu gestalten, einfach  das  siebte  Bit  im
vierten Byte der ungeraden Sprites auf 1 setzen, also in den sprites 1,3,5
und 7.

Um sich einen Sprite in 16 Farben zu schaffen muß man ihn zuerst mit einem
Malprogramm  zeichnen  und dann mit dem IFF-Konverter KefCon konvertieren,
denn es wäre recht schwierig, so über dem Daumen  gepeilt  die  16  Farben
richtig zu kalkulieren, da es 4 Planes sind, die zusammen 16 Möglichkeiten
ergeben!

Ladet und führt dann Listing7g.s aus. Es zeigt einen Sprite in  16  Farben
an,  im  Attached-Modus.  Darin ist auch beschrieben, wie man einen Sprite
mit dem KefCon herstell, sei er nun zu 4 oder 16 Farben.

Es ist möglich, gleichzeitig Sprites in 4 und in 16  Farben  darzustellen.
Z.B. könnten Sprite 0 und 1 Attached sein und die anderen nicht, oder jede
beliebige Kombination.

Im Beispiellisting Listing7h.s werden 4 Attached-Sprites angezeigt,  jeder
von ihnen in einer unabhängigen Bewegung.

Hier  angekommen werdet ihr euch sicher fragen, wieso immer noch nicht das
Problem der zwei Pixel pro Schritt nicht eliminiert wurde, und  wir  immer
noch  nicht Pixel für Pixel uber den Schirm gleiten können. Gut, es ist an
der Zeit, das in den Griff zu bekommen. Aber dazu müssen wir  vorher  noch
einen  neuen Befehl des 68000 lernen, welcher auf den einzelnen Bits einer
Zahl operiert: --- LSR ---
Dieses Kürzel steht für "LOGIC SHIFT RIGHT", oder  "LOGISCHER  SCROLL  DER
BITS  NACH  RECHTS".  Anders ausgedrückt, wenn eine Binärzahl in d0 %00111
ist, dann wird sie nach einem LSR #1,d0 folgendermaßen  aussehen:  %00011,
nach einem LSR #2,d0 so: %00001.
Auf die gleiche Art wird ein %00110010 nach einem LSR #1,d0 zu  %00011001,
und  nahc  einem  LSR#5,d0  wäre nur mehr ein %00000001 erhalten. Die Zahl
wird also binär betrachtet, es ist so, als wären sie auf einem  Tischtuch,
an  dem  wir ziehen: wenn wir um #1 ziehen, dann bewegen wir das Tischtuch
mitsamt seinen BitTellern darauf, und das erste in der Reihe wird zu Boden
fallen...  Wenn  man  zuviel  zieht,  dann  kommen alle BitTeller über den
Tischrand und man hat den Tisch abgeräumt (auf NULL gesetzt). Aber was hat
dieser Befehl mit dem Byte HSTART zu tun ???
Das Probelm ist folgendes: wie ihr wißt, gibt es weitaus mehr  horizontale
Positionen  als  nur $FF (255), man denke nur daran, daß ein LowRes-Screen
320 Pixel breit ist. Wenn wir eine Zahl erreichen wollen, die über dem 255
ist  (8  Bit,  vom  0 bis zum 7) dann müssen wir ein Bit mehr zu Verfügung
haben: somit kommen wir  nicht  mehr  nur  bis  maximal  %11111111  ($ff),
sondern  bis  %111111111, oder 511. Das wäre ja super für das HSTART! Aber
wohin geben wir dieses zusätzliche Bit?? Die  Scherzkekse  von  Ingeneuren
haben  gedacht, es wäre im famosen vierten KontrollByte gut aufgehoben, in
dem wir auch die Sprites zusammenpappen. Nun gut, das siebte Bit  ist  für
den  Attached-Modus  reserviert,  dann haben wir ja noch die sechs unteren
frei. Also nehmen wir Bit 0 für diese Aufgabe, und machen dieses  Bit  zum
NIEDERWERTIGSTEN  Bit  der horizontalen Koordinate, oder anders, zum Bit 9
der Koordinate. Damit wird das Kontrollbyte wie folgt aufgeteilt:

		;876543210	; Zahl mit 9 bit, für die HSTART - Koordinate
		%111111111
		 \_____/ \/
			|	  |
      8 hochwert. |
      Bits im	  |
      Byte HSTART |
				  |
				  |
				  |
				  |
				  |
				Bit 0 der
				Zahl zu 9 Bit,
				steht im Bit 0
				des vierten
				Kontrollbyte

Wenn ihr das niederwertige Bit einer 9 Bit  breiten  Zahl  entfernt,  dann
werdet ihr immer eine gerade Zahl erhalten, da dieses Bit immer auf 0 ist.
Denn eine Zahl ist immer dann ungerade, wenn dieses lezte Bit auf 1 steht,
testet  mal  mit  "?100"  und  "?101".  Ihr werdet feststellen, daß gerade
Zahlen immer eine NULL hinten stehen haben, ungerade eine Eins. Bis  jetzt
konntne  wir  also in Schritten zu zwei Pixel scrollen, und wir mußten aus
diesem Grund auch immer  nur  die  Hälfte  des  Effektivwertes  in  HSTART
einsetzen.  Um  auch  die ungeraden Adressen zu erreichen und um die reale
Adresse als Input zu geben müssen wir die Koordinate in niederwertiges Bit
und  hochwertiges Byte aufteilen. Danach dieses Bit in die richtige Stelle
und das Byte hineinschreiben. Um dies zu tun, stellt euch  vor,  ihr  habt
die ungerade Adresse 35: (%00100011). Als erstes müssen wir kontrollieren,
ob das Bit 0 des vierten Kontrollbytes  gesetzt  werden  muß  oder  nicht.
Dafür  müssen  wir  nur mit einem BTST kontrollieren, ab unsere Koordinate
das Bit 0 auf 1 hat oder nicht, und dann dementsprechend reagieren: nehmen
wir an, wir haben die Koordinate in d0:

	btst	#0,D0			; niederwertiges Bit der X-Koordinate =0?
	beq.s	BitNiederNULL
	bset	#0,MeinSprite+3	; Setzen das niederw. Bit von HSTART
	bra.s	PlaceCoords

BitNiederNull:
	bclr	#0,MeinSprite+3	; Löschen das niederw. Bit von HSTART
PlaceCoords:
	....

Nun haben wir das niederwertige Bit von HSTART  gesetzt  (oder  gelöscht),
nun kommt der Rest der Zahl an die Reihe, die höherwertigen 8 Bit. Aber es
gibt ein Problem: die Zahl hat 9 Bit, und wir brauchen  nur  8!  Und  hier
kommt  die Anweisung LSR ins Spiel!!! Denn sie läßt die Bits der Zahl alle
um eins nach rechts rutschen, somit verschwindet das 9. Bit und wir  haben
die  anderen  8 schon an der richtigen Stelle. Schauen wir uns an, wie die
Routine PlaceCoords weitergeht:

	lsr.w	#1,D0		; SHIFTEN 1 Bit nach rechts, oder "verschieben"
						; den Wert von HSTART, um ihn in den in das
						; Byte von HSTART geben zu können, ohne dem
						; niederwertigen, 9. Bit.
	move.b  D0,HSTART	; Setzen diesen Wert XX ins Byte HSTART
	rts

In diesem Fall hatten wir die Koordinate %00100011 (35), so sieht sie nach
dem  LSR #1,d0 aus: %00010001!!!! Das Byte ist so, wie es in HSTART kommen
muß.

In Listing7i.s wird diese Routine angewandt, um endlich einen Sprite schön
flüssig und  gleichmäßig  über  den Bildschirm zu schicken, wie es nur der
Amiga kann.

Jetzt ist es an der Zeit, auch noch das letzte Limit zu  eliminieren,  das
in  vertikaler  Richtung:  in  dieser  Richtung  konnten wir zwar schon in
Einerschritten gehen, aber nur bis Zeile $FF.  Um  dieses  zu  beseitigen,
haben  die  Erfinder  des  Amiga  bei  VSTART/VSTOP  eine  andere  Technik
angewandt, als bei HSTART: eigentlich braucht auch VSTART/VSTOP eine  Zahl
mit  neun  Bit,  aber  anstatt  das  niederwertigste  haben  sie  hier das
hochwertigste "herausgeführt". Somit ist in VSTART/VSTOP jede Zahl bis $FF
gültig, also bis 256, danach muß das neunte Bit gesetzt werden, um darüber
hinaus zu  kommen,  und  wo  wird  das  wohl  liegen?  Genau,  im  vierten
Kontrollbyte.  Nach  $FF  kommt  $100,  $101 usw., der Zählvorgang beginnt
wieder von vorne, nur mit dem neunten Bit auf High. Sehen wir nun, wie wir
eine  Routine  machen können, die im Grunde genommen gleich ist wie die im
horizontalen Sinn, die also mit der realen Koordinate startet (es ist  ein
Word  notwendig)  und sie dann in hochwertiges Bit und niederwertiges Byte
zerteilt. Achtung, hier haben wir auch  VSTOP  zu  modifizieren,  nur  mit
VSTART  ist  nix  getan!! Ach ja, habe fast vergessen: das hochwertige Bit
von VSTOP ist in Bit 1 des vierten Kontrollbytes zu finden, VSTART in  Bit 2:

	MOVE.w	(A0),d0		; kopiert das Word aus der Tabelle in d0
	ADD.W	#$2c,d0		; addiert den Offset vom Anfang des Screens
	MOVE.b	d0,VSTART	; kopiert das Byte in VSTART
	btst.l	#8,d0		; Zahl größer als $FF?
	beq.s	NichtVSTARTSET
	bset.b	#2,MeinSprite+3	; Setzt das Bit 8 von VSTART (Zahl > $FF)
	bra.s	ToVSTOP
NichtVSTARTSET:
	bclr.b	#2,MeinSprite+3	; Löscht das Bit 8 von VSTART (Zahl < $FF)
ToVSTOP:
	ADD.w	#13,D0		; Addiere die Länge des Sprite um die
						; Endposition festzulegen (VSTOP)
	move.b	d0,VSTOP	; Setze den richtigen Wert in VSTOP
	btst.l	#8,d0
	beq.s	NichtVSTOPSET
	bset.b	#1,MeinSprite+3 ; Setzt das Bit 8 von VSTOP (Zahl > $FF)
	bra.w	VstopFIN
NichtVSTOPSET:
	bclr.b	#1,MeinSprite+3 ; Löscht das Bit 8 von VSTOP (Zahl < $FF)
VstopFIN:
	rts

Diese Routine funktioniert auf die gleiche Weise wie  die  vorherige,  was
das  Setzen des "zusätzlichen" Bits angeht, unterscheidet sich aber darin,
daß sie auf VSTART wie auf VSTOP zugreifen muß, und daß das LSR fehlt (ist
hier überflüssig).

Ihr könnt sie testen, ladet dazu Listing7l.s.

Da  wir  nun  die volständige Kontrolle über die Sprites haben, werden wir
deren Kontrollroutinen etwas optimisieren:  als  erstes  werden  wir  eine
universelle  Kontrollroutine  für Sprites erstellen, so, daß wir nicht für
jeden der 8 Sprites  jedesmal  alles  neuschreiben  müssen.  Es  ist  eine
Routine  mit  Parametern  notwendig,  die  als  Eingang  die  Adresse  des
gewünschten Sprites und dessen X-Y-Koordinaten erhält. Damit brauchen  wir
für  jeden  Sprite nur mehr ein "BSR ROUTINE" machen, und nicht mehr alles
neuschreiben. Wir können dann diese Routine jedesmal  recyclen,  wenn  wir
Sprites  bewegen  wollen,  eventuell  nur kleine Änderungen anbringen. Ein
Beispiel  einer  solchen   Routine   findet   ihr   in   Listing7m.s   Die
Universalroutine heißt UniBewSprite, und damit sie funktioniert müssen wir
ihr, außer  der  Adresse  des  zu  bewegenden  Sprites  und  dessen  neuen
Koordinaten,  auch  die  Höhe des Sprites übermitteln. Damit errechnet die
Routine den Wert für VSTOP.
Diese Werte werden ihr mittels  einiger  Register  übermittelt:  Werte  in
Register  schreiben, Routine aufrufen, fertig. Um genau zu sein, kommt die
Adresse des Sprite in a1, seine Höhe ins Register d2, die Y-Koordinate  in
d0 und die X-Koordinate in d1. Die der Routine "übermittelten" Koordinaten
sind die Werte für einen Screen  in  320x256.  Die  Routine  kümmert  sich
selbst  um  das  "zentrieren"  des  Sprites  am Monitor, indem sie $40 zur
X-Koordinate und $2c zur Y-Koordinate dazuzählt. Weiters kümmert sie  sich
darum,  das  niederwertige  Bit  von  HSTART  und  das hochwertige Bit von
VSTART/VSTOP zu setzen.

Kurzum:

;
;	Eingangsparameter von UniBewSprite:
;
;	a1 = Adresse des Sprite
;	d0 = Vertikale Y-Position des Sprites auf dem Screen (0-255)
;	d1 = Horizontale X-Position des Sprites auf dem Screen (0-320)
;	d2 = Höhe des Sprite

Da  wir  nun diese Routine haben, die sich ein für alle Mal aller Probleme
annimmt, können wir uns daran machen,  sie  für  einige  Applikationen  zu
verwenden,  die  uns  mit  den  Sprites  vertrauter  macht. Bevor ihr aber
weitermacht,  ladet  Listing7m.s  und  wehe  dem,  wer   in   LEKTION7.TXT
weiterliest  oder  andere  Listings  ladet,  bevor er es nicht VOLLSTÄNDIG
verstanden hat. Da die Routine in  allen  folgenden  Beispielen  auftreten
wird,  wäre  es  sehr unwirtschaftlich, weiterzumachen, bevor eine Routine
verstanden wurde, die wir dauernd antreffen werden.

In Listing7n.s sehen wir einen Sprite auf dem Bildschirm, der  geradlinige
"Schußlinien" einschlägt. Die Koordinaten stammen nicht aus einer Tabelle,
sondern werden nach und nach berechnet. Dadurch bewegt sich der Sprite mit
einer  konstanten  Geschwindigkeit.  Ladet es und führt es aus, wir werden
sehen, wie man einen Sprite an den Ecken des Bildschirmes abprallen lassen
kann.

In  Listing7o.s  sehen  wir  hingegen  zwei  Sprites,  die  beide  von der
Universalroutine bewegt werden. Es ist ein ausgezeichnetes  Beispiel,  wie
unsere  Routine  verschieden Sprites, auch verschiedener Größe, problemlos
bewegen kann. Wenn wir keine Parameter verwenden würden, dann  müßten  wir
für   jeden   Sprite   alles   neu   schreiben,  eine  unnütze  Zeit-  und
Speichervergeudung.

In  Listing7p.s sehen wir, immer mit der Universalroutine, wie wir Objekte
kreiren  können,  die  größer  sind  als  16  Pixel,  indem  wir   Sprites
zusammenflicken. Achtung! Das ist was anderes als die "ATTACHED"- Sprites!
Bei denen werden zwei Sprites  genau  übereinandergelegt,  sie  haben  die
exakt  gleichen  Koordinaten,  und  das  Bit "attach" ist in den ungeraden
Sprites gesetzt. Bei "aneinandergereihten"  Sprites  hingegen  ahndelt  es
sich  um  einen  "Zusammenschluß"  von  zwei  oder  mehreren  Sprites, die
nebeneinander  oder  untereinander  auf  den  Screen  gezeichnet   werden.
Zusammen ergeben sie dann ein Gesamtbild. Sie müssen genau mit den Rändern
aneinandergereiht werden, wenn wir nicht wollen, daß es aussieht, daß  sie
"zerfallen".  Es  muß  kein spezielles Bit gesetzt werden, es handelt sich
nur um normale Sprites,  die  nebeneinander  aufgestellt  sind.  Hier  ein
Beispiel mit einem Raumschiff, das aus zwei Sprites besteht:
	
     (128,65)		     (128,65)	    (144,65)
	 |_ _ _ __ _ _ _	|_ _ _ _ _ _ __	|__ _ _ _ _ _ _
	 |     /  \		|	|			 /  |  \	       |
	    __/____\__				    /	    \
	 | |	      |	|	|		   /    |    \	       |
	   |	      |			  ____/__________ \____
	 | |__________| |	|    |	        |		   |   |
	      \	   /		     |		 			   |
	 |_ _ _\__/_ _ _|	|    |	        |		   |   |
							 |					   |
						|    |__________|__________|   |
								 \			  /
						|		  \     |    /		   |
								   \	    /
						|_ _ _ _ _ _\__ |__/_ _ _ _ _ _|

						   Sprite 0		Sprite 1

Mit dieser Technik lassen sich Ende-Level-Monster schaffen, die bis zu 128
Pixel  breit sind (16*8), wenn ihr die Sprites zu 3 Farben verwendet, oder
64 Pixel breit (16*4), wenn ihr Attached-Sprites mit 15  Farben  einsetzt.
Wenn  das  Monster  länger als breit ist, z.B. "Humanoid", dann könnt auch
die ganze Länge des Screens verwenden, denn dort gibt´s bekanntlich  keine
Limits. In der vertikalen Richtung können wir dann auch die Farben mit dem
Copper vertauschen, und ihm somit die Schuhe anders färben als die Jeans.


MOUSE UND JOYSTICK

Jetzt haben wir gesehen, wie wir den  Amiga  die  Spites  bewegen  lassen,
wieso  bewegen  nicht  wir sie? Natürlich unter Verwendung einer Maus oder
eines Joysticks. Bevor wir aber lernen, mit  diesen  Apparaten  umzugehen,
müssen  wir  einige  weitere  Befehle lernen, die uns Bitmanipulationen in
Registern erlauben: NOT, AND, OR, EOR.

Diese Befehle operieren auf den einzelnen Bits eines Registers (oder einer
Speicherzelle),  sei es für das Quellregister wir für das Zielregister. So
z.B. behandeln diese Anweisungen ein Byte nicht als eine Zahl, die  aus  8
Bit  besteht, sondern wie 8 Bits, die unabhängig voneinander in der Gegend
rumstehen. Das bedeutet, daß die Auswirkung, die ein Befehl  auf  ein  Bit
hat, unabhängig von den weiteren Bits im Register ist.

Als  erstes  sehen  wir  uns  das  NOT  an.  Es funktioniert nur auf einen
Operanden, dessen Effekt ist das vertauschen der  Bits  des  Operanden.  1
wird durch 0 ersetzt, und 0 durch 1. Wenn wir z.B. im Register d0 die Zahl
%01001100 haben, dann wird ein

	NOT.B	d0

folgendes Resultat bringen: %10110011.

Die 3 weiteren Instruktionen hingegen  arbeiten  mit  2  Operanden,  einem
Quelloperand  und einem Zieloperand. Sie führen die Operation zwischen den
beiden Operanden aus und schreiben das Ergebnis in  den  Zieloperand.  Die
Operationen   (die   sich   von   Befehl  zu  Befehl  unterscheiden)  sind
Bit-für-Bit, d.h., sie werden  zwischen  einem  Bit  im  QuellOP  und  dem
entsprechenden  ZielOP  durchgeführt.  Ein D0 AND D1 entspricht in etwa so
was:

(Bit 0 von D0) AND (Bit 0 von D1)
(Bit 1 von D0) AND (Bit 1 von D1)
(Bit 2 von D0) AND (Bit 2 von D1) und so weiter für alle Bit in D0 und D1

Schauen  wir, was das AND auf sich hat. Wir untersuchen seine Arbeitsweise
auf zwei einzelnen Bits. Da ein Bit entweder 0 oder 1  ist,  ergeben  sich
daraus 4 Fälle:

 0 AND 0 = 0
 0 AND 1 = 0
 1 AND 0 = 0
 1 AND 1 = 1

AND gibt als Resultat dann und nur dann 1, wenn das Bit des ersten UND des
zweiten  Operanden  1  ist. In allen anderen Fällen werden wir 0 erhalten.
Dreimal dürft ihr raten, was AND auf deutsch heißt: UND.  Man  könnte  die
Funktionsweise  auch so übersetzen: "SIND DAS ERSTE UND DAS ZWEITE BIT AUF
1? WENN JA, ANTWORTE MIT 1, ANSONSTEN MIT 0". Ein AND kann nützlich  sein,
um gewisse Bits in einer Zahl auf NULL zu setzen:

 AND.W #%1111111111111011,LABEL

Es wird das Bit 2 der Zahl in LABEL löschen, da es das  einzige  auf  NULL
gesetzte  Bit  im  Operand  ist,  und  somit das einzige sein wird, das im
Zieloperand geändert wird. Denn die anderen sind auf 1, und  werden  somit
nichts  am  Resultat ändern: Wenn das Zielbit 0 war, dann wird ein 0 AND 1
nichts ändern, es ergibt immer 0. Genauso wird eine 1 nichts ändern: 1 AND
1  =  1.  Dort,  wo  aber  0 steht, wird immer auf 0 gesetzt, egal, ob das
Zielbit 1 oder 0 war. Einige Beispiele:

   1111001111 AND 0011001100 = 0011001100 - Keine Änderung
   1101011011 AND 0001110001 = 0001010001 - 1 Bit gelöscht(auf 0 gesetzt)
   1111101101 AND 0011111111 = 0011101101 - 2 Bit gelöscht

Diese Operation des Löschens heißt MASKIERUNG:

 AND #%11110000,LABEL	(%11110000 ist die MASKE, denn es ist so, als
			würde man eine Schablone aus NULLEN über die Zahl
			in Label geben. In diesem Fall werden die ersten
			vier Bits rechts "verhüllt" wie bei einem Mädchen,
			das ein Muttermal mit Schminke "verhüllt". Dieses
			Mal ist wie eine 1, die vom Nuller wie von der
			Schminke überdeckt wird, also gelöscht wird.

Das OR hingegen verhält sich so:

 0 OR 0 = 0
 0 OR 1 = 1
 1 OR 0 = 1
 1 OR 1 = 1

In  diesem  Fall  reicht  es,  daß  eines  der zwei Bits auf 1 ist, um als
Resultat eine 1 zu geben. Das Resultat ist also immer 1, außer wenn  beide
Bits  auf  0 sind. Auch hier kann es helfen zu wissen, daß die Übersetzung
von OR aus dem englischen "ODER"  heißt.  "ENTWERDER  DAS  EINE  ODER  DAS
ANDERE  BIT  MUß  1 SEIN, UM ALS RESULTAT EINE 1 ZU LIEFERN. ANSONSTEN 0".
Dieses ist nützlich, im Gegensatz zum AND, um einige Bits in einem Byte zu
SETZEN, sie also auf 1 (High) setzen. Einige Beispiele:

	0000000001 OR 1101011101 = 1101010001 - Keine Änderung
	1000000000 OR 0010011000 = 1010011000 - 1 Bit gesetzt
	0001111000 OR 1111100000 = 1111111000 - 2 Bit gesetzt

In  diesem Fall ist es so, als würde sich das Mädchen von vorhin statt der
rosa Pinselei (den Nullen) über den schwarzen  Malen  (den  Einsen)  jetzt
einen schwarzen Punkt setzen, um ein falsches Mal zu bekommen, wie es z.B.
Marilyn Monroe über der Lippe hatte. Oder  als  würde  sich  ein  farbiges
Mädchen  (vollstandig  auf  1)  rosa  schminken,  um  weiß auszusehen (wie
Michael Jackson), also vollständig auf NULL zu sein,  und  nur  dort  eine
Stelle  freizulassen, wo die Zahl im OR auf 1 ist, und die schwarze Stelle
hervortreten lassen.

Das EOR, oder Exklusives OR, setzt nur dann auf 1, wenn entweder das erste
oder  das  zweite  Bit auf 1 sind, niemals aber wenn es beide sind, wie es
beim OR der Fall ist:

 0 EOR 0 = 0
 0 EOR 1 = 1
 1 EOR 0 = 1
 1 EOR 1 = 0	 ; Hier ist der Unterschied zum OR: denn 1 OR 1 = 1!

Einige Beispiele:

	0000000001 EOR 1101011101 = 1101010000 - 1 Bit gelöscht
	1000000000 EOR 0010011000 = 1010011000 - 1 Bit gesetzt

Dieser  letzte  Befefl  wird  uns  guten  Dienst  beim Lesen des Joysticks
erweisen. Wie ihr wißt besitzt der Amiga 2 Ports, an denen  Joystick  oder
Mouse  angeschlossen  werden  können.  An jeden der zwei können unabhängig
entweder  Mouse  oder  Joystick  angeschlossen  werden.  Für  jeden   Port
existiert  ein  Hardwareregister,  das gelesen werden kann, um den Zustand
der Mouse/Joystick zu erfähren. Port 0 (an  dem  normalerweise  die  Mouse
hängt)  wird  durch  Register JOY0DAT ausgelesen ($dff00a), Port 1 mittels
JOY1DAT ($dff00c). Als erstes sehen wir, wie wir  den  Joystick  abfragen.
Wir  beziehen  uns dabei auf das Register JOY1DAT, denn daran ist meistens
der Joystick angeschlossen. Es funktioniert  auf  JOY0DAT  auf  genau  die
gleiche Weise.
Wir können uns  einen  Joystick  wie  einen  Apparat  mit  vier  Schaltern
vorstellen  (einen  pro  Richtung), von denen jeder zwei Zustände annehmen
kann: geschlossen (1) oder offen (0),  jenachdem,  ob  der  Hebel  in  die
jeweilige  Richtung  gedrückt wird oder nicht. Um also zu wissen, wohin er
zeigt, müssen wir den Zustand  der  Schalter  abfragen.  Für  zwei  dieser
Schalter  ist die Abfrage sehr simpel, es wird einfach ein Bit im Register
JOY1DAT gesetzt:

- Das Bit 1 von JOY1DAT ist der Status des Schalters "Rechts"
- Das Bit 9 von JOY1DAT ist der Status des Schalters "Links"

Wenn das Bit auf 1 ist, dann ist  der  betroffenen  Schalter  geschlossen,
ansonsten ist er offen. Was die beiden anderen Richtungen angeht, sie sind
nicht direkt als einzelnes Bit eingetragen. Um sie zu erfahren, müssen wir
eine kleine Rechenoperation mit einem EOR durchführen:

-  Der Status des Schalters "Oben" ist das Resultat aus einem EOR zwischen
dem Bit 8 und Bit 9 des Registers

- Der Status des Schalters "Unten" ist das Resultat aus einem EOR zwischen
dem Bit 0 und Bit 1 des Registers.

Auch hier gilt, daß ein Bit 1 bedeutet, daß der Schalter geschlossen  ist,
ein  Bit  auf  0  daß  er  offen  ist. Da wir nun den Status des Joysticks
abfragen können, können wir auch Sprites auf dem Bildschirm bewegen.
Ladet Listing7q.s in einen anderen Textbuffer und führt es aus.

Nun kommen wir zur Maus.
Wenn wir an einen der zwei Ports eine  Maus  anschließen,  dann  verhalten
sich die Register anders als bei einem Joystick. Wenn wir nun das Register
JOY1DAT ansehen (genauso auch das Register JOY0DAT...), dann bemerken wir,
daß  das  hochwertige Byte dazu verwendet wird, um vertikale Bewegungen zu
registrieren, und das niederwertige Byte für horizontale Bewegungen. Jedes
Byte  stellt  eine Zahl dar (von 0 bis 255), die sich je nach Bewegung der
Mouse verändert.

- Das hochwertige Byte verringert die Zahl, wenn die Maus nach oben bewegt
wird und erhöht den Inhalt, wenn die Maus nach unten bewegt wird.

-  Das  niederwertige Byte verringert die dargestellte Zahl, wenn die Maus
nach links bewegt wird, und erhöht sie, wenn sie nach rechts bewegt wird.

Nun schauen wir, wie wir diese Informationen so ausnutzen können, um einen
Sprite  zu  bewegen.  Die  erste Methode, die einen in den Sinn kommt, ist
jene, einfach die Werte der zwei Bytes JOYxDAT  als  Koordinaten  für  den
Sprite  zu  verwenden.  Es  ist  eigentlich  sehr praktisch, denn auch die
Koordinaten der Sprites verringern sich nach Oben und nach Links hin,  und
erhöhen sich nach Rechts und nach Unten.
Diese  Methode  hat  aber den Nachteil, daß wir mit einem Byte bekanntlich
maximal bis 255 kommen, der Bildschirm aber 320  Pixel  breit  ist.  Ladet
Listing7r1.s und testet diese Methode. Eine ein bißchen komplexere Methode
wird in Listing7r2.s präsentiert. Sie eliminiert das Limit der 255  Pixel.
Die  Beschreibung  der  Methode  befindet sich im Listing selbst. Lest den
angehängten Kommentar.

Da wir nun wissen, wie wir einen Pfeil am Bildschirm bewegen  können,  ist
es nur mehr einfach, ein Intuition-System zu simulieren, man kann also ein
Kontrollpanel mit Knöpfen  und  Schaltern  machen,  die  mit  einem  Pfeil
(Sprite) an-und ausgeschalten werden können, wenn damit über einem solchen
ist. Durch Auslesen der Koordinaten des  Sprites  und  Vergleich  mit  den
Kooridinaten  der Buttons ist das ein Kinderspiel. Versucht es mal selbst.
In fortgeschritteren Lektionen werden wir ein Listing dieser Art sehen.

WIEDERVERWENDUNG DER SPRITES

Die Technik der Wiederverwendung der Sprites erlaubt uns, mehr als  die  8
erlaubten Sprites gleichzeitig am Bildschirm anzuzeigen. Praktisch gesehen
wird ein Sprite dazu verwendet,  verschiedene  Objekte  auf  verschiedenen
Höhen  anzuzeigen. Wenn wir z.B. einen Sprite verwenden, um einen Alien im
oberen  Teil  des  Monitors  anzuzeigen,  dann  können  wir   den   selben
wiederverwenden,  um weiter unten das Raumschiff des Spielers zu zeichnen.
Das einzige Limit bei der Wiederwerwertung eines Sprites liegt darin,  daß
die  beiden  Objekte  auf  verschiedenen Höhen liegen müssen. Es ist nicht
möglich, auf der selben Zeile zwei Objekte anzuzeigen, die mit dem  selben
Sprite   gezeichnet   werden.   Des  Weiteren  muß  die  erste  Zeile  des
nachfolgenden Sprites mindestens eine Zeile Abstand von der letzten  Zeile
des vorigen Sprites haben. Horizontal gibt keine Einschränkungen. Das Bild
ilustriert die Situation vielleicht etwas besser:


	  Ausschnitt des Screens
	 ________________________
	|						 |		  Jedes Bild in diesem Ausschnitt
	|				  _		 |		  des Bildschirmes ist mit dem
	|				_|_|_	 |		  selben Sprite gezeichnet.
	|				\___/ _ _|_ _	  Jedes kann horizontal frei
	|		_ _ _ _ _ _ _ _ _|_ _ <-- positioniert werden, aber es muß
	|	 _/_\_				 |		  mindestens eine Bildschirmzeile
	|	|_____|				 |		  zwischen der letzten Zeile eines
	|	  \_/_ _ _ _ _ _ _ _ |_ _	  Sprites und der ersten Zeile
	|		    _ _ _ _ _ _ _|_ _ <-- des wiederverwendeten liegen.
	|		 /\				 |
	|		 \/				 |		  Die Pfeile zeigen die freie
	|						 |		  Zeilen zwischen den Objekten an.
	|						 |
	|________________________|


Wie schon gesagt, gibt es kein Limit was die horizontale Position  angeht,
weger  die  Anzahl,  wie oft man einen Sprite wiederverwendet. Hauptsache,
man hält sich  an  die  oben  genannte  Regel.  Ein  Sprite  kann  so  oft
wiederverwendet  werden, wie man will. Diese Technik kann bei jedem Sprite
angewandt werden, und unabhängig unter den verschiedenen Sprites: so  kann
Sprite  0,3 und 4 nur einmal verwendet werden, Sprite 1 drei mal, Sprite 2
vier mal, und die Sprites 56 und 7 überhaupt  nicht.  Spielt  alles  keine
Rolle.

Diese  Technik  anzuwenden ist recht einfach, es bedarf nur einer Änderung
in der Struktur des Sprites.

Normalerweise kommen am Ende eines Sprites, nach den Daten, aus  denen  er
besteht,  zwei Words mit Inhalt 0. Sie markieren das Ende der Struktur. Um
ihn wiederzuverwenden setzen wir statt dieser zwei Word eine neue Struktur
ein,  die  ein  weiteres Bild beschreibt, nur weiter unten im Screen. Wenn
man dann noch ein drittes Mal das Spiel wiederholen will, dann  noch  eine
Struktur angehängt, usw., bis dann am Ende die zwei Word mit 0 kommen. Sie
markieren dann das Ende der letzten Wiederverwendung:

					SPRITE-STRUKTUR
			  ___________________________ - -
      |		 |     VSTART_1, HSTART_1    |   |
			 |___________________________|
      |		 |     VSTOP_1 und bits	     |   |
			 |___________________________|
      |				  						 |
			  ___________________________
	  |		 |     plane 1, Zeile 1      |   |
			 |___________________________|
	  |		 |     plane 2, Zeile 1		 |   |
			 |___________________________|	 		Daten der ersten
      |				  						 |- - - Verwendung des
						------						sprite
      |					------				 |
						------
      |		 ___________________________     |
			|  plane 1, letzte Zeile    |
      |		|___________________________|    |
			|  plane 2, letzte Zeile    |
      |		|___________________________|    |
										  - -
			 ___________________________  - -
      |		|    VSTART_2, HSTART_2     |    |		Daten der zweiten
			|___________________________|			Wiederverwendung des Sprite.
      |		|    VSTOP_2 und bit		|    |- - -	Die vertikale Anfangs-
			|___________________________|			position muß mindestens
      |										 |		eine Zeile Abstand von
		     ___________________________			der letzten Zeile der
      |		|							|	 |		vorherigen Verwendung haben.
			|___________________________|
      |		|							|	 |
			|___________________________|
      |										 |
						------
      |					------				 |
						------
      |		 ___________________________	 |
			|							|
      |		|___________________________|	 |
			|							|
     \|/	|___________________________|	 |
										  - -
										  _ _
					_____					 |
					_____					 |- - - Weitere Verwendungen
					_____				  _ _|

			 ___________________________ _  _
			|			0				|	 |		Zwei auf 0 gesetzte
      		|___________________________|	 |_ _ _ Word, sie markieren
			|			0				|	 |		das Ende der letzten
     		|___________________________|_  _|		Wiederverwertung


Zu  bemerken,  daß  die  einzelnen  Wiederverwertungen  des   Sprites   in
Reihenfolge   eingesetzt   werden   müssen,  angefangen  vom  am  höchsten
positionierten Sprite bis hin zum  niedersten  am  Bildschirm.  Somit  muß
jedes VSTART größer sein als das VSTOP des Vorgängers.

Sehen  wir z.B. eine solche Struktur in der Praxis. Hier wird der Sprite 2
mal wiederverwertet.


MEINSPRITE:
VSTART_1:
	dc.b $50				; Position erste Verwendung
HSTART_1:
	dc.b $40+12
VSTOP_1:
	dc.b $58
	dc.b $00
 dc.w   %0000001111000000,%0111110000111110	; "Form"-Daten der ersten
 dc.w   %0000111111110000,%1111001110001111	; Verwendung
 dc.w   %0011111111111100,%1100010001000011
 dc.w   %0111111111111110,%1000010001000001
 dc.w   %0111111111111110,%1000010001000001
 dc.w   %0011111111111100,%1100010001000011
 dc.w   %0000111111110000,%1111001110001111
 dc.w   %0000001111000000,%0111110000111110
VSTART_2:					; Position zweite Verwendung
	dc.b $70				; BEMERKT, daß VSTART_2 > VSTOP_1
HSTART_2:
	dc.b $40+20
VSTOP_2:
	dc.b $78
	dc.b $00
 dc.w   %0000001111000000,%0111110000111110	; "Form"-Daten der zweiten
 dc.w   %0000111111110000,%1111001110001111	; Verwendung
 dc.w   %0011111111111100,%1100010001000011
 dc.w   %0111111111111110,%1000001110000001
 dc.w   %0111111111111110,%1000010001000001
 dc.w   %0011111111111100,%1100010001000011
 dc.w   %0000111111110000,%1111001110001111
 dc.w   %0000001111000000,%0111110000111110
 dc.w   0,0					; Ende der letzten Verwendung


Die  Technik  der  Wiederverwendung,  wenn  richtig  angewandt,  kann  zur
Vervielfachung  der bewegten Objekte in einem Shoot´em´up führen. In einem
Spiel, in dem sich die Feinde z.B. horizontal bewegen:


						/--___
						\--
	
							/--___
							\--
	
								/--___
	   ()-						\--
	   /\___o - - - - - -
	  ||||--o - - - - - -			/--___
	  ||||							\--
	  //\\
	 //  \\
------------------------------------------------------------

Da  dieses  feindliche Geschwader aus Objekten besteht, die eines über dem
anderen stehen, die sich nie überkreuzen,  haben  wir  noch  ganze  sieben
Sprites für Player 1 und eventuelle Bomben zur Verfügung.

Ein  Beispiel  davon  bekommt  ihr  in  Listing7s.s,  wo  wir "16" Sprites
gleichzeitig anzeigen. Ladet und studiert es euch.

In unserem Kurs konnte dann  auch  einer  der  klassischen  Effekte  nicht
fehlen,  der  vor  einigen  Jahren  sehr in Mode war: das "Starfield", die
Sterne, die sich horizontal bewegen.
Diese Sterne werden durch recycelte Sprites dargestellt. Wir stellen  euch
mit  Listing7t1.s, Listing7t2.s und Listing7t3.s drei Versionen davon vor.
Die Wiederverwendung  von  Sprites  kann  auch  auf  "Attached"  angewandt
werden,  genauso  wie  auf "normalen". In Listing7t4.s sehen wir zirca das
gleiche wie in den Starfields, nur  mit  farbigen  Bällen  an  Stelle  der
Sterne.

	-		-		-		-

DAS DUAL PLAYFIELD MODE

Bevor wir weitere Charakteristiken der Sprites aufzählen machen  wir  kurz
einen  Abstecher  und vertiefen das Kapitel des Dual Playfields. Wir haben
schon in Lektion 4 angedeutet, daß es sich dabei um einen Spezialmodus  in
der  Grafik  handelt,  der  es  uns  erlaubt,  zwei  Screens  übereinander
anzuzeigen.  Sie  heißen  jeweils  PLAYFIELD1  und  PLAYFIELD2.  Aber  was
bedeutet,  daß  zwei  Screens "übereinander" liegen? Praktisch gesehen hat
jedes Playfield eine "durchsichtige" Farbe,  durch  die  wir  durchschauen
können,  was  drunter  vor  sich  geht.  Es ist mit dem COLOR0 der Sprites
durchaus vergleichbar. Eigentlich ist das "durchsichtige" gar keine Farbe,
es  ist  eher wie ein "Loch" im Playfield zu verstehen. Die anderen Farben
des Playfields  hingegen  verhalten  sich  normal.  Eines  der  Playfields
erscheint  über  dem  anderen  (ist  nur auszuwählen, welches), und dessen
NICHT durchsichtigen Farben überdecken das darunterliegende Playfield. Das
Durchsichtige  hingegen  verhält sich wie gesagt wie ein Loch und läßt das
drunterliegende durchscheinen.
Die maximale Anzahl von Bitplanes, die ein Playfield haben kann, ist  drei
in  Lowres und 2 in Highres. Praktisch werden die 6 Bitplanes des Amiga in
zwei Gruppen zu 3 aufgeteilt, jede dieser Gruppen ist ein  Playfield.  Das
Playfield  1 besteht aus den ungeraden Bitplanes, also aus den Planes 1, 3
und 5, das Playfield 2 aus den geraden, also 2, 4 und 6.
Natürlich ist es nicht immer notwendig, alle Bitplanes zu  verwenden.  Wir
können  unabhängig voneinander den zwei Playfields die Bitplanes zuteilen,
die wir wollen. Die Anzahl der zu verwendenden Bitplanes geben wir auf die
gleiche  Art  und Weise an, wie bei den "normalen" Grafikmodi. In die Bits
14-12 des BPLCON0 ($dff100), BPU2, BPU1 und BPU0 genannt, kommt die Anzahl
der insgesamt verwendeten Bitplanes für die Playfields. Je nachdem, welche
Zahl wir hier eintragen, teilt die Hardware die  Bitplanes  folgendermaßen
auf:


Anzahl der verwendeten BPL. |   Bitplanes für	  |	Bitplanes für
 (bit BPU di BPLCON0)	    |   Playfield 1		  |	Playfield 2
----------------------------|---------------------|-------------------
							|					  |
	0						|	keines			  |	keines
							|					  |
	1						|	Plane 1			  |	keines
							|					  |
	2						|	Plane 1			  |	Plane 2
							|					  |
	3						|	Plane 1,3		  |	Plane 2
							|					  |
	4						|	Plane 1,3		  |	Plane 2,4
							|					  |
	5						|	Plane 1,3,5		  |	Plane 2,4
							|					  |
	6						|	Plane 1,3,5		  |	Plane 2,4,6

Wie ihr seht, hat Playfield 1 immer gleichviel oder mehr  Planes  als  das
Field  2,  und Playfield 2 maximal eines weniger als Field 1. Es ist nicht
möglich,  3  Planes  dem  Playfield1  und  ein  einziges  dem   Playfield2
zuzuordnen.

Analog  wie  bei  den  Standart-Grafikmodi  bestimmt  die Überlagerung der
Bitplane  die  Farbe  eines  jeden  Pixel.  Die  Übereinstimmung  zwischen
Bitplane-Kombination  und  Farbregistern  ist  aber etwas verschieden, die
Tabelle gibt genaueren Aufschluß darüber:

PLAYFIELD 1
    Wert	|   Wert	|   Wert	|  ausgewählte
	Plane 5 |	Plane 3 |	Plane 1 |  Farbe
----------------------------------------------------
			|			|			|
	0		|	0		|	0		|  durchsichtig
			|			|			|
	0		|	0		|	1		|  COLOR01
			|			|			|
	0		|	1		|	0		|  COLOR02
			|			|			|
	0		|	1		|	1		|  COLOR03
			|			|			|
	1		|	0		|	0		|  COLOR04
			|			|			|
	1		|	0		|	1		|  COLOR05
			|			|			|
	1		|	1		|	0		|  COLOR06
			|			|			|
	1		|	1		|	1		|  COLOR07


PLAYFIELD 2
    Wert	|   Wert	|   Wert	|  ausgewählte
	Plane 6 |	Plane 4 |	Plane 2 |  Farbe
----------------------------------------------------
			|			|			|
	0		|	0		|	0		|  durchsichtig
			|			|			|
	0		|	0		|	1		|  COLOR09
			|			|			|
	0		|	1		|	0		|  COLOR10
			|			|			|
	0		|	1		|	1		|  COLOR11
			|			|			|
	1		|	0		|	0		|  COLOR12
			|			|			|
	1		|	0		|	1		|  COLOR13
			|			|			|
	1		|	1		|	0		|  COLOR14
			|			|			|
	1		|	1		|	1		|  COLOR15

Nun wißt ihr, wie das Dual Playfield Mode funktioniert. Nur etwas wißt ihr
noch nicht... wie man dieses aktiviert!!
Ganz einfach, Bit 10 im Register BPLCON0  auf  1  setzen.  Wie  wir  schon
gesagt  haben,  ist  es  möglich,  auszuwählen, welches Playfield über dem
anderen erscheinen soll. Man sagt,  daß  ein  Playfield,  das  über  einem
anderen  erscheint,  höhere  Priorität  hat.  Es  gibt  ein Bit, das diese
Priorität bestimmt, es ist das Bit 6 des Registers BPLCON2 ($dff104): wenn
es auf 0 ist, dann erscheint Playfield 1 über dem 2, ansonsten Playfield 2
über dem ersten.

Ein Beispiel dafür gibt es in Listing7u.s


PRIOTITÄT ZWISCHEN SPRITES UND PLAYFIELDS

Wir  haben  schon   die   Priorität   zwischen   den   einzelnen   Sprites
kennengelernt.  Wenn  sich zwei Sprites also überlappen, dann wird der mit
der kleineren Zahl über dem anderen erscheinen.  Des  weiteren  haben  wir
gerade  gesehen,  wie  man  die Priorität der Playfields im Dual Playfield
Mode untereinander  bestimmt.  Nun  bleibt  uns  nur  noch  die  Priorität
zwischen Playfield und Sprites zu besprechen. Als erstes vermerke ich, daß
die Sprites immer über der Farbe 0 erscheinen. Für die anderen Farben wird
die  Priorität  im  Register  BPLCON2  kontrolliert. Es ist möglich, diese
unabhängig für die geraden und ungeraden Planes  zu  setzen.  Das  ist  im
Dual-Playfield-Modus  sehr  nützlich,  da  es  uns damit ermöglicht, jedem
Playfield eine verschiedene Priorität gegenüber den Sprites zu  geben.  Im
Standartmodus  hingegen  ist  es  vorteilhafter, den geraden und ungeraden
Planes die gleiche Priorität gegenüber den Sprites zu geben. Das  Register
BPLCON2  enthält einige Bits, in denen der Prioritätslevel der geraden und
ungeraden Planes gesetzt werden kann. Die Bits 0 bis  zwei  enthalten  den
Prioritätslevel   für   die  ungeraden  Bitplanes  (Playfield  1  im  Dual
Playfieldmode), die Bits 3 bis  5  hingegen  den  Level  für  die  geraden
Bitplanes (Playfield2). Und so werden die Prioritäten verteilt:
Wir beziehen uns dabei auf ein beliebiges Playfield, da sie  untereinander
gleich  funktionieren.  Was  die  Priorität  Sprites-Playfield  angeht, da
werden die Sprites als Paare betrachtet (0-1,2-3,4-5  und  6-7).  Wie  wir
wissen,  ist  die Priorität unter den Sprites (und deswegen auch unter den
Paaren) fix:


MAXIMALE PRIORITÄT	PAAR 1 (SPRITES 0 UND 1)
			PAAR 2 (SPRITES 2 UND 3)
			PAAR 3 (SPRITES 4 UND 5)
MINIMALE PRIORITÄT	PAAR 4 (SPRITES 6 UND 7)

Wir können nun unseren Prioritätslevel für die Playfields innerhalb diesen
Grenzen  einfügen:  entweder  über  der  maximalen  Priorität der Sprites,
unterhalb der minimalen oder zwischen zwei Paaren. Es ist somit aber nicht
möglich, ein Playfield unter dem Paar 4 und über dem Paar 2 anzuzeigen, da
das zweite Paar über dem vierten ist. Das Gegenteil ist aber möglich. Hier
eine  Tabelle  mit  allen  Möglichkeiten, die uns in der Prioritätsvergabe
gebotren sind: (Durch die Einstellungen in BPLCON2 )

CODE	  |  000      |	 001	  |  010      |	 011	  |  100      |
----------------------------------------------------------------------------
PRI. MAX  | PLAYFIELD | PAAR 1	  | PAAR 1    | PAAR 1	  | PAAR 1    |
		  | PAAR 1    | PLAYFIELD | PAAR 2    | PAAR 2	  | PAAR 2    |
		  | PAAR 2    | PAAR 2	  | PLAYFIELD | PAAR 3	  | PAAR 3    |
		  | PAAR 3    | PAAR 3	  | PAAR 3    | PLAYFIELD | PAAR 4    |
PRI. MIN  | PAAR 4    | PAAR 4	  | PAAR 4    | PAAR 4	  | PLAYFIELD |

Wie aus der Tabelle ersichtlich, wenn wir z.B. die  Sprites  0,1,2  und  3
(also  Paar  1  und  2)  übder  dem  Playfield  anzeigen  wollen,  und die
restlichen Paare unterhalb, dann werden  wir  in  BPLCON2  den  Code  %010
setzen.  Dieser  Code kommt dann im BPLCON2 entweder in die Bits 0-2, wenn
wir uns auf das Playfield1 im Dual-Playfield-Mode beziehen,  oder  in  die
Bits  3  bis 5 für Playfield2. Wenn wir einen "normalen" Screen verwenden,
ohne Dual Playfield, dann müssen wir diesen Code zweimal schreiben, einmal
in Bit 0-2 und einmal in 3-5.

In  Listing7v1.s  sehen  wir,  wie  wir  die Priorität in einem "normalen"
Screen setzen.

In Listing7v2.s hingegen wird ein Dual Playfield verwendet.


KOLLISIONEN

Die Hardware des Amiga stellt dem Programmierer ein System zur  Verfügung,
das  es  erlaubt,  Kollisionen (Zusammenstöße) zwischen Sprite und Sprite,
Sprite und Playfield  und  zwei  Playfields  zu  registrieren.  All  diese
Kollisionstypen werden mit nur zwei Registern verwaltet: CLXDAT ($dff00e),
das ein Nur-Lese-Register ist, in dem die Kollisionen signalisiert werden,
und  CLXCON  ($dff098),  das ein Kontrollregister ist, mit dem die Art der
Registrierung der Kollisionen verändert werden kann. Beginnen  wir  damit,
die Struktur dieser Register zu beschreiben.
Die Bit von CLXDAR verhalten sich  wie  Kollisionsmelder.  Jedes  Bit  ist
einer  ganz  bestimmten  Kollision  zugeteilt.  Wenn  sich nun eine solche
bestimmte Kollision zuträgt, dann nimmt dieses jeweilige Bit  den  Wert  1
an.  Wenn  die Kollision nicht mehr besteht, dann springt es auf 0 zurück.
In der folgenden Tabelle werden die einzelnen Bit von CLXDAT genauer unter
die Lupe genommen:

VERWENDUNG DER BIT VON CLXDAT

Bit 15  nicht verwendet
Bit 14  Kollision zwischen PAAR 3 und PAAR 4
Bit 13  Kollision zwischen PAAR 2 und PAAR 4
Bit 12  Kollision zwischen PAAR 2 und PAAR 3
Bit 11  Kollision zwischen PAAR 1 und PAAR 4
Bit 10  Kollision zwischen PAAR 1 und PAAR 3
Bit 9   Kollision zwischen PAAR 1 und PAAR 2
Bit 8   Kollision zwischen Playfield 2 und PAAR 4
Bit 7   Kollision zwischen Playfield 2 und PAAR 3
Bit 6   Kollision zwischen Playfield 2 und PAAR 2
Bit 5   Kollision zwischen Playfield 2 und PAAR 1
Bit 4   Kollision zwischen Playfield 1 und PAAR 4
Bit 3   Kollision zwischen Playfield 1 und PAAR 3
Bit 2   Kollision zwischen Playfield 1 und PAAR 2
Bit 1   Kollision zwischen Playfield 1 und PAAR 1
Bit 0   Kollision zwischen Playfield 1 und Playfield 2

Das Register CLXCON hat folgende Struktur:

VERWENDUNG DER BIT VON CLXCON

Bit 15  aktiviert Sprite 7
Bit 14  aktiviert Sprite 5
Bit 13  aktiviert Sprite 3
Bit 12  aktiviert Sprite 1
Bit 11  aktiviert Bit-plane 6
Bit 10  aktiviert Bit-plane 5
Bit 9   aktiviert Bit-plane 4
Bit 8   aktiviert Bit-plane 3
Bit 7   aktiviert Bit-plane 2
Bit 6   aktiviert Bit-plane 1
Bit 5   Kollisionswert Bit-plane 6
Bit 4   Kollisionswert Bit-plane 5
Bit 3   Kollisionswert Bit-plane 4
Bit 2   Kollisionswert Bit-plane 3
Bit 1   Kollisionswert Bit-plane 2
Bit 0   Kollisionswert Bit-plane 1

(Bemerkung: wo "aktiviert" steht ist gemeint, daß  die  REGISTRIERUNG  DER
KOLLISIONEN  aktiviert  wurde:  wenn z.B. das Bit 15 von CLXCON den Wert 0
hat, dann heißt es nicht, daß Sprite  7  nicht  am  Bildschirm  erscheinen
kann,  sondern  nur,  daß  die Kollisionen, die mit Sprite 7 zu tun haben,
nicht registriert, vermerkt werden)


Wir werden die Bedeutung dieser Bits nach und nach erklären. Beginnen  wir
mit  den  Kollisionen  zwischen  Sprite und Sprite. Sofort vorweggenommen,
auch bei den Sprite-kollisionen werden die Sprites in Paaren behandelt. Es
ist  nur  möglich,  einen  Zusammenstoß zwischen Sprites aus verschiedenen
Paaren zu registrieren, und nicht zwischen zwei aus dem  selben  Paar.  Es
ist  z.B.  unmöglich,  eine Kollision zwischen Sprite 0 und 1 zu erkennen.
Wenn die Sprites aber verschiedenen Paaren  angehören,  dann  ändert  sich
alles:  bei einem Überlappen der Sprites 0 und 2 wird Bit 9 von CLXDAT auf
High (1) gesetzt (Kollision zwischen Paar 1 und 2). Auch  wenn  sich  eine
Kollision  zwischen Sprite 1 und 2 ereignet, wird Bit 9 auf 1 springen, da
Sprite 1 ja auch zum selben Paar wie Sprite 0 gehört, dem Paar 1. Das  muß
aber nicht immer so sein.
Denn die Zusammenstöße zwischen Sprites mit geradem Index (Sprite 0,2,4,6)
werden  immer  registriert,  bei  ungeraden  Sprites  hingegen  können wir
entscheiden ob ja oder nein. Um auch die ungeraden zu signalisieren müssen
wir das dementsprechende Bit in CLXCON aktivieren. Ihr könnt in der obigen
Tabelle sehen, welche es sind. Die  ungeraden  Sprites  können  unabhängig
voneinander  aktiviert werden. Einen oder mehrere ungerade Sprites einzeln
aktivieren zu können bringt Vor- und Nachteile mit  sich.  Betrachten  wir
z.B. nur das Paar 1 und 2 und nehmen wir an, wir haben weder Sprite 1 noch
Sprite 3 aktiviert. Wenn sich nun eine Kollision zwischen Sprite 0  und  2
ergibt,  wird  Bit  9  in  CLXDAT  auf  1 gehen. Wenn diese Kollision aber
zwischen Sprite 1 und 2, zwischen 0 und 3 oder zwischen 1 und 3  ereignet,
dann  passiert  nichts,  und  wir  können  nicht  sagen, ob eine Kollision
stattgefunden hat.
Nehmen wir hingegen an, einen der ungeraden Sprites  aktiviert  zu  haben,
den Sprite 1 zum Beispiel. In diesem Fall ergeben die Kollisionen zwischen
Sprite 0 und 2 und zwischen 1 und 2 einen High-Pegel im Bit 9 von  CLXDAT.
Eine  Kollision  zwischen  Sprite  0  und  3  oder  2  und 3 bleibt weiter
ergebnislos. In diesem Fall ergibt sich ein Nachteil gegenüber der vorigen
Situation,  in  der  Sprite  1 nicht aktiviert war. Denn wenn vorhin Bit 9
gesetzt war, waren wir sicher, daß es einen Zusammenstoß zwischen Sprite 0
und  2  gegeben  hat. Im derzeitigen Fall hingegen kann es der 0 und der 2
oder der 1 und der 2 sein. Es gibt keine  Möglichkeit,  das  Rätsel  durch
lesen  des  Registers  CLXDAT  zu  lüften.  Wenn Sprite 1 deaktiviert ist,
Sprite 3 aber aktiviert, dann haben wir eine analoge Situation zur  gerade
besprochenen,  nur  anstatt  auf  Sprite  1  bezieht  sich  das  Bit 9 nun
zusätzlich auf das Sprite 3: Kollisionen zwischen  Sprite  0  und  2  bzw.
zwischen  0  und  3  werden  registriert,  aber  wir  haben  wieder  keine
Möglichkeit, sie zu unterscheiden.
Zum Schluß gibt es noch die letzte Kombination, in  sowohl  Sprite  1  wie
auch Sprite 3 aktiviert sind. Nun werden die Kollisionen 0-2, 0-3, 1-2 und
1-3 signalisiert, und wir haben wieder keine Unterscheidungsmöglichkeit.

Ein Beispiel  von  Spritekollisionen,  mit  den  ungeraden  ausgeschaltet,
gindet	ihr	in	Listing7w1.s.	Ladet	und	verifiziert	die
Funktionstüchtigkeit.

Ein Beispiel zwischen Sprites mit einem  ungeraden,  deaktiviertem  Sprite
gibt´s  in Listing7w2.s. Ihr werdet bemerken, daß das Beispiel, so wie ich
es vorsetze, nicht  funktioniert;  um  es  auszuführen  müßt  ihr  die  im
Kommentar	beschriebenen   Modifizierungen   anbringen.   Um   hier   zu
unterscheiden, ob es sich bei der Kollision um die  mit  dem  aktivierten,
ungeraden  Sprite  oder  dem geraden handelt, wird eine Technik angewandt,
die die Positionen der jeweiligen Sprites vergleicht.

Nun kommen wir  zur  Kollision  zwischen  Sprite  und  Playfield.  Es  ist
möglich,  einen  Zusammenstoß  zwischen  einem  Spritepaar  und einer oder
mehreren Farben des Playfields zu registrieren. Auch hier wird  wieder  in
Paaren  gearbeitet,  und  nicht mit den einzelnen Sprites. Die Aktivierung
der ungeraden Sprites mit den Bits im Register CLXCON hat auch hier  seine
Gültigkeit.
Die Registrierung der Kollisionen läuft aber jeweils anders ab, ob wir wir
nun  einen  normalen  Screen  oder ein Dual-Playfield verwenden. Bei einem
normalen Screen zeigen die Bits von 1  bis  4  von  CLXDAT  die  Kollision
zwischen einem Spritepaar und der Farbe (oder den Farben) an, die wir dazu
ausgewählt haben. Das Bit 1 zeigt die Kollision zwischen dem Playfield und
dem  Paar  1  an,  das Bit 2 zwischen Playfield und Paar 2, Bit 3 zwischen
Playfield und Paar 3 und Bit 4 zwischen Playfield und Paar 4. Die Bit  von
5 bis 8 werden nicht verwendet.
Im Dual-Playfield-Mode ist es möglich, einen Zusammenstoß  zwischen  einem
der  2  Playfields  und einem Spritepaar zu registrieren, und die Bits von
CLXDAT  werden  verwendet,  wie  in  der  Tabelle  des  Registers   CLXDAT
angeführt:  die Bit 1 bis 4 zeigen eine Kollision zwischen Playfield 1 und
einem Spritepaar an, während die Bits von 5 bis 8 für das Playfield 2  und
den  Spritepaaren  verantwortlich sind. Um die Farben auszuwählen, die ein
"Klingeln" in CLXDAT auslösen sollen, brauchen wir  das  Register  CLXCON.
Beginnen wir mit einer einzigen Farbe.
Die Bits von 6 bis 11 von CLXCON  zeigen  an,  welche  Bitplanes  für  die
Kollisionen  aktiviert  sind.  Im Falle, daß wir Kollisionen eines Sprites
mit einer einzigen Farbe registrieren wollen  müssen  wir  alle  Bitplanes
aktivieren,  die  angezeigt werden. Die Wahl der Farbe, die eine Kollision
auslösen soll, wird durch einsetzen der Zahl des Registers in die Bits von
0 bis 5 in CLXCON erziehlt, das die dementsprechende Farbe beinhaltet.
Nehmen wir z.B. an, wir haben einen  normalen  Screen  mit  16  Farben  (4
Bitplanes),   und   wir   dir  Kollisionen  der  ungeraden  Sprites  nicht
berücksichtigen. Wenn wir nun die Kollision zwischen einen Sprite und  der
Farbe 13 registrieren wollen, dann kommt in das Register CLXCON der Wert

		111111
		5432109876543210
 $03cb=%0000001111001101

Schauen wir und die Bedeutung der Bits etwas genauer an. Die  Bit  von  12
bis  15 deaktivieren die ungeraden Sprites. Von den Bits von 6 bis 11 sind
nur Bit 6,7,8 und 9 auf eins. Das deutet an, daß nur die Bitplanes  von  1
bis  vier  aktiviert  sind.  Die  Bits  von  0  bis  5  enthalten die Zahl
%001101=13, also die Farbe 13 ist auserwählt. Im Dual-Playfield-Modus  ist
die  Situation  die  selbe,  nur  werden  dort  alle verwendeten Bitplanes
aktiviert und es werden Kollisionen mit 2 Farben  gleichzeitig  aktiviert:
Wenn  wir  z.B.  zwei  Playfileds  zu  jeweils  8  Farben  haben,  und die
Registrierung der Kollisionen mit Farbe 7 des Playfield 1 und Farbe 2  des
Playfield 2 wollen, dann werden wir in CLXCON folgende Zahl schreiben:

		111111
		5432109876543210
 $0fbb=%0000111111011101

Diese Kombination zeigt an,  daß  alle  Bitplanes  zum  kollisionsanzeigen
aktiviert  sind (alle Bit von 6 bis 11 sind auf 1). Weiters ist die "Zahl"
der Farbe für Playfield 1 aus den Bits 0, 2  und  4  zusammengesetzt,  die
zusammengeschoben  die  Zahl  %111=7  ergeben. Die Bits, die die Farbe für
Playfield 2 ergeben, sind 1,  3  und  5,  die  wiederum  zusammengeschoben
%010=2 ergeben.
Zu Bemerken ist, daß die Kollision  eines  Sprites  mit  einer  Farbe  des
Playfield 1 das Setzen eines anderne Bits in CLXDAT zur Folge hat als eine
eines Sprites mit einer Farbe von Playfield 2. Zum Beispiel, wie  ihr  aus
der  Tabelle  des  Registers  CLXDAT  lesen  könnt,  ergibt eine Kollision
Sprite0Playfield1 Bit 1 in CLXDAT einen High-Zustand auf Bit 1 in  CLXDAT,
eine Kollision Sprite0-Playfield2 hingegen einen High-Zustand auf Bit5 von
CLXDAT. Es ist auch möglich, die Kollision  eines  Sprites  mit  mehr  als
einer  Farbe zu registrieren, auch wenn nur in einigen Sonderfällen. Um zu
verstehen, wie das geht, muß man sich die Binärdarstellung der Zahlen  der
Farbregister vor Augen halten.
Es gibt, wie ihr wißt, 32 Farbregister, die die Numerierung von 0  bis  31
haben.  Die Möglichkeit, Kollisionen mit 2 Farben gleichzeitig erkennen zu
können, beruht darauf, daß die  Darstellung  einiger  Binärzahlen  ähnlich
ist.  Nehmen  wir  zum  Beispiel  die  Zahlen  2 und 21. Binär gesehen ist
2=%00010, 21 hingegen %10101 (wir betrachten  5  Bit,  um  Zahlen  bis  31
schreiben zu können). Wie ihr seht, sind sie total verschieden. Es besteht
also keine Möglichkeit, diese Farben gleichzeitig zu erkennen.
Betrachten wir nun 22 und 23. Wir erkennen, daß sie  in  binärer  Form  so
aussehen:  22=%010110  und 23=%010111. Sie unterscheiden sich nur in einem
Bit, dem niederwertigsten (ganz links). In diesem  Fall  ist  es  möglich,
Kollisionen   mit  beiden  Farben  zu  registrieren.  Denn  der  Wert  des
niederwertigsten Bit (das in diesem Fall die Farben unterscheidet) ist vom
Bitplane1  gegeben.  Wenn  wir  Bitplane  1  NICHT zur Kollisionserkennung
aktivieren, dann werden nur die Werte  der  Bitplanes  2,3,4  und  5  (wir
befinden  uns auf einem Screen zu 32 Farben, also 5 Bitplanes) betrachtet,
und der Wert, der durch Bitplane 1 angenommen wird,  hat  keinen  Einfluß.
Wir werden in CLXCON also folgenden Wert schreiben:

		 111111
		 5432109876543210
CLXCON= %0000011110010110

Das bedeutet, daß die Kollision basierend auf  den  aktivierten  Bitplanes
erkannt  wird  (also  den  Planes  2,3,4 und 5), genauer gesagt wenn unser
Sprite über einem Pixel mit

Bitplane 1=(0 oder 1), weil nicht aktiviert
Bitplane 2=1
Bitplane 3=1
Bitplane 4=0
Bitplane 5=1

steht.
Wie wir  gesehen  haben,  erfüllen  die  Darstellung  von  22=%010110  und
23=%010111  diese  bestimmte Forderung. Es werden also beide Farben in der
Kollisionsregistrierung einbezogen. Beachtet, daß das  Bitplane,  das  wir
NICHT  aktiviert haben (das erste) genau diesem ersten Bit entspricht, das
die Unterscheidung zwischen 22 und 23 ausmacht.

Diese Technik ist auf bei allen Farbpaaren anwendbar, bei denen  sich  die
Binärdarstellung  nur  in einem Bit unterscheiden. So z.B. auch die Zahlen
8=%001000 und 9=%001001, die sich im  niederwerigsten  Bit  unterscheiden.
Also  werden  wir  auch  hier  das Bitplane 1 deaktivieren, wenn wir diese
beiden Farben zur Erkennung verwenden wollen. Wenn wir hingegen die Farben
10=%001010  und  14=%001110  verwenden wollen, dann bemerken wir, daß sich
die beiden Zahlen im Bit 2 (wir notieren die Zahlen von rechts nach links,
bei  0  beginnend)  unterscheiden,  das  dem Bitplane 3 entspricht. Um nun
Kollisionen zwischen einem Sprite und diesen zwei Farben zu  registrieren,
müssen wir das Bitplane 3 deaktivieren, und dem CLXCON also folgenden Wert
zuspielen:

		 111111
		 5432109876543210
CLXCON= %0000011011001010   ; Bit 8=0 Bitplane 3 NICHT aktiviert

Wenn wir 2 Bitplanes ausschalten können wir 4 Farben  in  die  Kollisionen
einbeziehen.  Im Prinzip ist es immer das Gleiche. Nehmen wir zum Beispiel
die Farben:

1=%00001
3=%00011
5=%00101
7=%00111

Sie haben alle die Bit 0, 3 und 4 gleich, unterscheiden sich aber  in  der
Kombination  der  Bits  1  und  2.  Wollen wir nun eine Kollision zwischen
Sprites und diesen vier Farben wahrnehmen, dann werden wir Bitplane 2  und
3 deaktivieren.

Wenn  wir  3  Bitplanes  ausschalten,  können wir 8 Farben erkennen, bei 4
abgeschaltenen Bitplanes 16.

Auch im Dual-Playfield-Mode ist es möglich,  für  jedes  Playfield  einige
Bitplanes  zu  deaktivieren,  um somit die Kollision zwischen einem Sprite
und mehr als einer Farbe eines Playfields zu signalisieren.  Erinnern  wir
uns aber, daß wenn wir die Kollision zwischen einem Sprite und zwei Farben
erkennen müssen, bei der jedoch eine dem Playfield 1 gehört und die andere
dem  Playfield2, es nicht notwendig ist, dieses Spiel zu machen, da wir in
CLXDAT für jedes Playfield ein Bit haben, das  und  erlaubt,  gleichzeitig
eine Kollision mit beiden Playfields zu erkennen.

In  Listing7x1.s  sehen wir ein Beispiel von Kollision zwischen Sprite und
Playfield im "Standard-Modus".

In Listing7x2.s hingegen haben wir ein Beispiel  im  Dual-Playfield-Modus.
In  beiden  Lisitngs  sind im Kommentar Beispiele aufgezeigt, wie man mehr
als eine Farbe für die Kollisionen verwenden kann.

Der letzte Typ von Kollision ist der zwischen Playfield 1 und  Playfield2,
klarerweise  in  Dual-Playfield-Mode. Es ist möglich, Kollisionen zwischen
einer oder mehrerer Farben des Playfield1 und einer oder  mehrerer  Farben
des   Playfield  2  zu  erkennen,  indem  wir  nur  einige  der  Bitplanes
aktivieren, genauso wie wir es mit den Sprite-Playfield-Kollisionen  getan
haben.  Wenn  eine  Kollision  zwischen zwei Playfields stattgefunden hat,
dann wird Bit 0 in CLXDAT auf 1 gesetzt.

Ein Beispiel von dem Typ sehen wir in Listing7x3.s.


DIREKTE VERWENDUNG DER SPRITEREGISTER


Sehen  wir  nun eine andere Methode, mit der wir Sprites verwenden können.
Bis jetzt haben wir die Sprites generiert, indem wir die  Register  SPRxPT
verwendet haben, also Pointer auf unsere Datenstrukturen (Spritestruktur),
die alle  nötigen  Informationen  zum  Erstellen  des  gewünschten  Sprite
enthalten.  Es gibt aber eine alternative Methode, wir werden sie "Direkte
Verwendung der Sprite" nennen. Diese Art ist in den meisten  Fällen  nicht
von Vorteil, aber manchmal kann sie nützlich sein.
Um  zu  verstehen,  um  was  es  hier  geht  müssen  wir  das  Thema   der
Spritedarstellung  etwas  vertiefen.  Wenn  wir in ein SPRxPT-Register die
Adresse  einer  Spritestruktur  schreiben  setzen  wir  eine  automatische
Prozedur in Gang, die es uns erlaubt, diese Sprites effektiv zu sehen. Die
Daten, die Position und Form des Sprites  angeben,  werden  automatisch  -
mittels  eines  Hardwaremechanismus´ Namens DMAin eigene Register gegeben,
anderen als dir SPRxPT. Es ist genau dieses Schreiben der Daten  in  diese
Register,  die  es  ermöglichen,  die  Sprites WIRKLICH zu sehen. Vom DMA,
einem sehr wichtigen Instrument des Amiga, werden wir  in  einer  nächsten
Lektion  sprechen.  Im  Moment reicht uns zu wissen, was für eine Rolle er
bei den Sprites spielt. Er  verhält  sich  ähnlich  wir  ein  Briefträger.
Stellt  euch  vor,  die  Datenstruktur  eures Sprites, die ihr im Speicher
erstellt habt, ist wie ein Haufen Briefe, die  an  verschiedene  Empfänger
(Register)  kommen.  Der  DMA  übernimmt  nun  die  Aufgabe,  diese Briefe
zuzustellen, er sortiert sie  auch.  Die  direkte  Verwendung  der  Sprite
besteht  nun  genau  darin,  die Daten direkt in die richtigen Register zu
schreiben, oder anders ausgedrückt,  indem  wir  die  Briefe  selbst  beim
Empfänger abgeben, und so dem Briefträger DMA die Arbeit wegnehmen. Da der
DMA aber gratis arbeitet, werdet ihr euch nun fragen, für was das gut sein
soll. Wie schon gesagt, normalerweise
bringt es keine Vorteile. Aber manchmal schon.
Schauen wir uns an, wie diese Technik funktioniert. Wie schon gesagt,  die
Daten  werden direkt in einige Register geschrieben. Es gibt vier Register
pro Sprite, SPRxPOS, SPRxCTL, SPRxDATA und SPRxBATB genannt. Statt  dem  x
kommt  wie  immer  die  Nummer  des gewünschen Sprite. Die Adressen dieser
Register hängen vom Sprite ab, auf den wir uns beziehen.  Wir  können  sie
mit  einer  einfachen  Formel berechnen. Mit "x" geben wir eine Nummer des
Sprites an, sie liegt zwischen 0 und 7.


Adresse SPRxPOS  = $dff140+(x*8)
Adresse SPRxCTL  = $dff142+(x*8)
Adresse SPRxDATA = $dff144+(x*8)
Adresse SPRxDATB = $dff146+(x*8)

Ihr könnt sie aber auch mit dem Help des ASMONE ("=C") herausfinden.

Nun beschreiben wir die  Verwendung  dieser  Register.  Die  "Form"  eines
Sprites  kommt in die Register SPRxDATA und SPRxDATB, die die zwei kleinen
"Bitplanes" des Sprites darstellen.  SPRxDATB  ist  das  Plane  2).  Diese
Register haben die gleiche Aufgabe wie die Wordpaare, die eine Zeile eines
Sprites definieren. Bemerkt aber, daß für jeden Sprite  nur  Register  für
EINE  Zeile  zur  Verfügung stehen. Die horizontale Position eines Sprites
ist, wie ihr wißt, aus 9 Bit zusammengesetzt, H0,  H1,...  ,  H8  genannt.
Diese  9  Bit  sind  in  zwei  Register  unterteilt:  das Bit H0, also das
niederwertige, befindet sich im Bit 0 des Registers SPRxCTL. Die anderen 8
hingegen  im  niederwertigen  Byte  des Registers SPRxPOS. Kurzum, was die
horizontale Position angeht, so verhalten die  Register  prakitsch  gleich
wie  die  zwei  Kontrollword in der Spritestruktur. Die vertikale Position
wird mit dieser Technik aber nicht bestimmt, denn  die  Sprites  verhalten
sich recht eigenartig.
Um einen Sprite anzuzeigen muß er vorher aktiviert werden.  Das  passiert,
wenn man in das Register SPRxDATA schreibt.
Einmal aktivert wird der Sprite auf jeder Zeile angezeigt,  immer  in  der
von uns zugeteilten horizontalen Position. Die Form ist immer die gleiche,
also jene, die in SPRxDATA und SPRxDATB steht.
Wenn diese zwei Register also nicht ständig verändert werden, dann hat der
Sprite  in  jeder  Zeile  immer  das  gleiche  Aussehen.  Der  Sprite wird
angezeigt bis  er  nicht  deaktivert  wird,  indem  ins  Register  SPRxCTL
geschrieben wird.
Um einen Sprite anzuzeigen, der in jeder Zeile anders ist, müssen wir also
eine  Copperlist  schreiben, die ungefähr so aussieht: (Wir nehmen an, den
Sprite 0 bei VSTART=$40, VSTOP=$60 und HSTART=$160 anzeigen zu wollen)


	dc.w	$4007,$fffe	; WAIT - Warte auf Zeile VSTART
	dc.w	$140,$0080	; SPR0POS - horizontale Position
	dc.w	$142,$0000	; SPR0CTL
	dc.w	$146,$0e70	; SPR0DATB - Spriteform Zeile 1, Plane 2
	dc.w	$144,$03c0	; SPR0DATA - Spriteform Zeile 1, Plane 1
						; des Weiteren aktiviert es den Sprite,
						; deswegen wird es als letztes geschrieben

	dc.w	$4107,$fffe	; WAIT - Warte auf Zeile VSTART+1
	dc.w	$146,$0a70	; SPR0DATB - Spriteform Zeile 2, Plane 2
	dc.w	$144,$0300	; SPR0DATA - Spriteform Zeile 2, Plane 1

	dc.w	$4107,$fffe	; WAIT - Warte auf Zeile VSTART+2
	dc.w	$146,$0a7f	; SPR0DATB - Spriteform Zeile 3, Plane 2
	dc.w	$144,$030f	; SPR0DATA - Spriteform Zeile 3, Plane 1

; wiederhole für jede Zeile Y
;	dc.w	$40+Y07,$fffe   ; WAIT - Warte auf Zeile VSTART+Y
;	dc.w	$146,DATENY2	; SPR0DATB - Spriteform Zeile Y, Plane 2
;	dc.w	$144,DATENY1	; SPR0DATA - Spriteform Zeile Y, Plane 1
; an Stelle Von DATENY1 und DATENY2 kommen die Formdaten der Sprite.

	dc.w	$6007,$fffe	; WAIT - Warte auf Zeile VSTOP
	dc.w	$142,$0000	; SPR0CTL - deaktiviere Sprite

Wie ihr gesehen  habt,  ist  bei  längeren  Sprite  eine  sehr  lange  und
komplizierte  Copperlist  notwendig. Hier empfielt es sich auf jeden Fall,
den DMA zu verwenden.  Nehmen  wir  aber  an,  wir  möchten  einen  Sprite
anzeigen,  der  in  jeder  Zeile  gleich  ist.  Z.B. eine Säule. In dieser
Situation würde unsere Copperlist kurz und einfach:
(Wir nehmen an, den Sprite 0 bei  VSTART=$40,  VSTOP=$60  und  HSTART=$160
anzeigen zu wollen)


	dc.w	$4007,$fffe	; WAIT - Warte auf Zeile VSTART
	dc.w	$140,$0080	; SPR0POS - horizontale Position
	dc.w	$142,$0000	; SPR0CTL
	dc.w	$146,$0e70	; SPR0DATB - Spriteform Zeile 1, Plane 2
	dc.w	$144,$03c0	; SPR0DATA - Spriteform Zeile 1, Plane 1
						; des Weiteren aktiviert es den Sprite,
						; deswegen wird es als letztes geschrieben

	dc.w	$6007,$fffe	; WAIT - Warte auf Zeile VSTOP
	dc.w	$142,$0000	; SPR0CTL - deaktiviert Sprite

Ihr  bemerkt,  daß unsere Copperlist, außer daß sie kurz ist, mit der Höhe
des Sprite nicht verändert wird.
Wenn wir aber den DMA verwendet hätten, dann  hätten  wir  für  die  ganze
Länge  des  Sprite  die  gleichen Zeilen schreiben müssen. Das hätte unter
anderem auch mehr Speucher gekostet. Denkt zum Beispiel an den Fall,  eine
100  Zeilen  hohe  Säule  anzeigen  zu  müssen. Wenn wir den DMA verwenden
würden, dann sähe es so aus:

Spritestruktur:
		dc.b	VSTART,HSTART,VSTOP,0
		dc.w	$ffff,$0ff0	; Zeile 1
		dc.w	$ffff,$0ff0	; Zeile 2
		dc.w	$ffff,$0ff0	; Zeile 3
		dc.w	$ffff,$0ff0	; Zeile 4
		dc.w	$ffff,$0ff0	; Zeile 5
		dc.w	$ffff,$0ff0	; Zeile 6
		dc.w	$ffff,$0ff0	; Zeile 7
		dc.w	$ffff,$0ff0	; Zeile 8

.... und so weiter bis:

		dc.w	$ffff,$0ff0	; Zeile 99
		dc.w	$ffff,$0ff0	; Zeile 100
		dc.w	0,0			; Ende Sprite


Mit  der  direkten  Verwendung  der  Sprite  hingegen reicht eine einfache
Coperlist:

	dc.b	VSTART,7,$ff,$fe	; WAIT - Warte auf Zeile VSTART
	dc.w	$140
	dc.b	$00,HSTART	; SPR0POS - horizontale Position
	dc.w	$142,$0000	; SPR0CTL
	dc.w	$146,$ffff	; SPR0DATB - Spriteform Zeile 1, Plane 2
	dc.w	$144,$0ff0	; SPR0DATA - Spriteform Zeile 1, Plane 1
						; des Weiteren aktiviert es den Sprite,
						; deswegen wird es als letztes geschrieben

	dc.b	VSTOP,7,$ff,$fe ; Warte auf Zeile VSTOP
	dc.w	$142,$0000	; SPR0CTL - deaktivert Sprite


Ein einfaches Beispiel der direkten Verwendung der Sprites findet  ihr  in
Listing7y1.s.

Im  Programm  Listing7y2.s  hingegen  werden  durch die direkte Verwendung
Balken erzeugt, die gleich denen sind, die mit dem Copper gemacht wurden.

Mit der Technik der direkten Verwendung der Sprites ist es  auch  möglich,
den  selben  Sprite  mehrmals  auf  der  gleichen  Zeile zu verwenden. Die
Methode wird in Listing7y3.s besser erklärt und  angewandt.  Die  Sprites,
die   mehrmals   auf  der  selben  Zeile  angezeigt  werden,  heißen  auch
MULTIPLEXED, also "gemultiplext". Wie wir  also  gesehen  haben,  hat  der
Amiga  zwar  nur  8  Sprites,  aber  der  Assembler erlaubt es und, sie zu
vervielfachen und ihnen auch mehr Farben als standartmäßig  vorgesehen  zu
geben,  indem  wir die Palette mehrmals horizontal ändern. Es ergeben sich
damit zwar ziemlich lange Copperlisten, aber es rentiert sich sicherlich.

Eine  Entwicklung  dieser  Idee  bringt  und  dann  dazu,   einen   Screen
vollständig mit Sprites zu gestalten, ein Beispiel in Listing7y4.s.

Um  so  etwas  zu  gestalten  müssen  extrem  lange Copperlist geschrieben
werden, und um sie verständlicher zu machen werden  SYMBOLE  oder  EQUATES
verwendet,  es  ist eine Direktive des Assembler, die es uns gestattet, zu
einer  bestimmten  Zahl  einen   x-beliebigen   Namen   zuzuteilen.   Beim
Assemblieren  wird der Name dann durch die dementsprechenden Zahl ersetzt.
Machen wir ein Beispiel: wir wollen auf  das  Register  COLOR0  zugreifen,
das,  wie  wir  wissen, die Adresse $dff180 hat. Wir können es entweder so
schreiben:

	move.w	#$123,$dff180

Aber wenn wir möchten, dann auch auf diese Art:

COLOR0	EQU	$dff180	 ; Definition eines Symboles

	move.w	#$123,COLOR0

Wir haben praktisch definiert, daß  wenn  der  ASMONE  das  Symbol  COLOR0
findet,  er  es  mit $dff180 ersetzen soll. Es ist fast wie ein Label, wir
müssen  uns  einen  Namen  erfinden,  ihn  ganz  links   schreiben,   ohne
Leerzeichen,  aber es braucht keinen Doppelpunkt. Im Wahrheit kann man sie
auch setzen, genauso wie die Labels sie haben können oder nicht; es  hängt
vom  Assembler  ab.  EQU  bedeutet  ÄQUIVALENT  ZU.  Die meisten Assembler
akzeptieren auch das = an Stelle der EQU für die  Definition.  Machen  wir
ein weiteres Beispiel:

NUMERLOOP	=	10

	MOVEQ   #NUMERLOOP-1,d0
Loop:
	clr.l   (a0)+
	dbra	d0,NUMERLOOP
	rts

Mit diesem Mini-Listing haben wir 10 Longwords auf 0 gesetzt. Der  Vorteil
der  EQUATES  besteht  darin,  daß  wir  sie alle am Anfang des Programmes
setzen können, und somit einfaches Spiel haben,  wenn  wir  gewisse  Werte
verändern  wollen.  Es ist auch Möglich, mathematische Operationen mit den
Symbolen durchzuführen:


BytesProZeile	=	40
AnzahlZeilen	=	256
BitplanePlatz	=	BytesProZeile*AnzahlZeilen

	...

	section plane,bss_C

Bitplane:
	ds.b	BitplanePlatz

Im  Listing  gilt BitplanePlatz 10240, oder 40*256. In Listing7y4.s werden
Symbole für die Copperlist definiert.

Zum Schluß werden wir noch den Screen mit den Sprites scrollen lassen. Wir
nützen  das aus, um noch zwei weitere Befehle des 68000ers kennenzulernen:
ROR und ROL. Listing7y5.s


ANIMATION DER SPRITES


Wir  beenden  diese  Lektion  mit  der Beschreibung über die Animation der
Sprites. Wir betrachten nun wieder "normale" Sprites, also jene,  die  mit
den SPRxPT und dem DMA erzeugt werden. Um einen Sprite zu animieren müssen
wir ihn jedesmal neuzeichnen, wenn er angezeigt wird. Jede Form,  die  der
Sprite   annimmt,   wird   auch   "Fotogramm   der   Animation"   genannt.
Normalterweise wird eine Animation so gemacht, daß eine  Sequenz  abläuft,
die  immer  wiederholt wird. Denkt z.B. an ein Männchen, das am Bildschirm
läuft; ihr werdet bemerken, daß alle Schritte gleich sind.
Um ein  Männchen  zu  animieren  müssen  wir  eine  bestimmte  Anzahl  von
Fotogrammen  zeichnen,  die  in  Sequenz  (hintereinander)  gesehen  einen
kompletten Schritt ergeben. Wenn das Männchen einen Schritt  gemacht  hat,
beginnt  es  mit  einem neuen: jetzt werden wieder die gleichen Fotogramme
angezeigt wie vorhin. Durch wiederholen dieses Schrittes kann das Männchen
laufen, wie lange wir wollen, wir brauchen aber nur eine limitierte Anzahl
von Bildern (Es ist klar, daß Fotogramme ja im Endeffekt Bilder sind,  und
somit  Speicher  brauchen,  und  wir somit versuchen sollten, so wenig wie
möglich davon zu  brauchen).  Bis  hierher  gilt  des  Gesagte  für  jedes
animierte  Objekt,  es  ist  also  gut,  wenn  ihr es euch merkt, auch für
später, wenn wir Animationen mit dem Blitter erzeugen  werden.  Im  Moment
behandeln  wir  nur  Animationen  mittels  Sprite. Das bedeutet, wir haben
einen Sprite, der sich am Bildschirm  bewegt  und  jedesmal  neugezeichnet
wird,  wenn  er  Form wechselt. Man geht dabei so vor: für jedes Fotogramm
erzeugt  man  einen  Spritestruktur,  und   jedesmal   wenn   der   Sprite
neugezeichnet  wird,  pointen  wir mit dem Register SPRxPT auf ein anderes
Fotogramm (also auf eine andere Datenstruktur). Die Position  des  Sprites
wird  jedesmal in die Struktur des Fotogrammes geschrieben, auf das SPRxPT
dann zeigt.

Ein Beispiel davon gibt´s in Listing7z.s

Dieses Beispiel ist auch das Ende von Lektion7 und  somit  von  DISK1  des
Kurses.

*****************************************************************************

Die  Disketten  2  und  3  (in  Italienisch)  wurden  im Moment der
"Drucklegung"  (November  95)  fertiggestellt.  Sie  behandeln  die
folgenden Argumente:

- BLITTER (Copymode, Linemode und Fill)
- Interrupt, CIAA/CIAB, laden von Disk, Tastatur
- Audio
- Kompatibilität und Optimierung des 68000

Weiters  ist auch Disk 4 fast fertig, sie behandelt das AGA-Chipset
und den 68020.
Es  sind  auch  Lektionen  im  Bereich  3D  und   Demo   Style   in
Vorbereitung,  weiters  auch  die  Programmierung von Videospielen.
Aber wenn mir niemand hilft, werden sie  nie  das  Licht  der  Welt
erblicken.  Wenn  ihr  wollt,  daß  die  Disks  2/3/4  ins Deutsche
mutieren, dann kann  ich  euch  nur  sagen,  daß  desto  mehr  Mark
anschwirren,  desto  schneller sie übersetzt werden, hehehe :) Also
schickt mindestens 10 Märkli entweder  als  Postanweisung  oder  in
einem  verschlossenem  Brief  an  den  vertrauten  Übersetzer,  der
Halbe-Halbe mit dem Autor teilt:

        Martin De Tomaso
        Nicolodistr. 24/3
        39100 BOZEN
        ITALY                   ; internet: mdetomas@inf.unitn.it

Das  bedeutet  aber  nicht,  daß die Disks 2/3 automatisch bei euch
zuhause landen wenn sie fertig sind, es würde  uns  nur  ermutigen,
weiterzumachen.  Wenn  ihr euch registrieren wollt, dann schickt 25
Mark (wie immer mit einer Postanweisung  oder  flüssig),  und  fügt
auch noch folgende Infos hinzu:

Name, Nachname, Adresse, Amiga-Modell, das zuhause am Werk ist

Optional:  Alter, e-mail, Handle (Wenn ihr aus der Demo-Scene kommt).

Wie    schon    erwähnt,    wird    Hilfe    für    die     Kapitel
3D-Effekte/Fraktale/Warp/ Voxel/Zoom/etc, wie auch Games, benötigt.
Es betrifft sowohl Texte  wie  auch  Listings.  Es  braucht  nichts
Wundervolles, es reichen simple Dinge, die einfach zu kapieren sind
und gut kommentiert sein sollten. Egal wenn  sie  langsam  und  nix
Besonders  sind.  Ihr  könnt  sofort  loslegen, Kommentare bitte in
Deutsch oder Englisch!
Ein anderes Motiv, weswegen ihr uns  unserer  Ruhe  berauben  dürft
(nicht  so  ernst  nehmen..!), ist die Fähigkeit, GUT ins Englische
oder sonst irgend eine Sprache übersetzen zu können. In diesem Fall
habt  ihr Anrecht auf einen guten Prozentsatz des Profits (30%-50%,
das handeln wir uns dann aus) des Ertrages der von euch übersetzten
Version.  Unter GUT verstehe ich die Übersetzung des GANZEN Kurses,
auch der LABEL und der dummen Sprüche, und ohne Fehler. Weiter ohne
die  TABS  in  Spaces  zu  verwandeln  und  ohne die 79 Kolonnen zu
überschreiten.

	Fabio Ciucci (Randy/Ram Jam)   &   Martin De Tomaso

Hello's to all the German Amiga Scene groups!!! I hope to see much demos
out from EX-SWAPPERs, EX-GFX ARTISTs, EX-MUSICIANs!!!
Just read this tutorial between one swap and another, or between painting &
composing!!!!

A special hello to the R.O.M. editors (Touchstone, please write an article
about this tutorial!!!!)

