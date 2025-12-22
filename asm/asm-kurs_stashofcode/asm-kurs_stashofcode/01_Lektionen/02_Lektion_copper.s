
; Lektion 02

WAIT, SKIP UND COPJMPX: ERWEITERTE VERWENDUNG VON Copper AUF DEM AMIGA (1/2)

18. August 2017 Amiga, Assembler 68000, Copper

Die Programmierung des Coppers auf dem Amiga ist etwas ganz Besonderes. Dieser
Grafik-Coprozessor enthält zunächst nur drei Befehle MOVE, WAIT und SKIP,
denen jedoch JUMP hinzugefügt werden kann, obwohl er nicht wie die anderen
codiert ist. Dann schreiben wir keinen Code für den Copper, wie wir Code für
den 68000 schreiben: keine Mnemonik, wir müssen direkt in Opcodes schreiben.
Schließlich weisen WAIT und SKIP gewisse Einschränkungen auf, deren
Berücksichtigung den Code komplexer macht, sobald er unabhängig von der
Linie, die der Elektronenstrahl - das Raster - auf dem Bildschirm abtastet,
funktionstüchtig sein muss.

Paradoxerweise hindern uns diese Einschränkungen im Allgemeinen nicht daran,
komplexe visuelle Effekte wie Plasma oder die Anzeige eines Echtfarbenbildes
im Vollbildmodus zu programmieren - da der Amiga 500 ohne Verwendung einer
Bitebene die gesamte Breite der 320 Pixel und die gesamte Höhe der 256
Pixelzeilen einer Oberfläche in Echtfarbe darstellen kann, die herkömmlich
in einer PAL-Demo verwendet wird. Die Überraschung des Programmierers ist noch
größer, wenn er darauf stößt. Um sie zu überwinden, ist es notwendig, die
Informationen auszunutzen, die sich in einem ziemlich kryptischen Abschnitt
des Amiga-Hardware-Referenzhandbuchs befinden. Erläuterungen.

Bild: Ein Plasmaeffekt (genauer gesagt ein RGB-Plasma) ; figure4-4.png

Update 14.01.2019: Ich habe vergessen zu erwähnen, dass ich, da ich die Ruhe
hatte, den zweiten Teil fertig zu schreiben, das meiste hier aufgenommen habe.
Tatsächlich basiert das Rotozoom auf einer Lösung des am Ende dieses Artikels
erwähnten Problems.

NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete
Skidtro-Modul anhört, das von Sun / Dreamdealers für den Road Rash Cracktro
komponiert wurde, aber es ist eine Frage des persönlichen Geschmacks...

EINE KURZE ERINNERUNG AN DIE GRUNDLAGEN VON COPPER

Mit dem Copper ist es möglich, den Wert bestimmter Register mit einem
MOVE-Befehl zu ändern. Wie jeder Copper-Befehl wird MOVE codiert, indem sein
Opcode in Form von zwei aufeinanderfolgenden Wörtern in der Liste von Befehlen
zusammengesetzt wird, die das Programm bilden, das der Copper in jedem Frame
ausführt, die Copper-Liste.
Das erste Wort eines MOVE liefert den Offset des Hardware-Registers, in den der
Copper einen Wert schreiben muss - dieser Offset ergibt sich aus der Adresse
$DFF000, also zum Beispiel $0180 für das COLOR00-Register welches die Werte der
rot, grün und blau Komponente der Farbe 0 angibt, die als Hintergrundfarbe
bezeichnet wird. Das zweite Wort liefert den Wert, der in dieses Register
geschrieben werden soll. Was gegeben ist:

Bild: Die Kodierung des MOVE-Befehls ; figure1-5-768x71.png

Der folgende MOVE ändert also COLOR00 in $0F00 (rot):

	DC.W $0180,$0F00

Der Copper benötigt einige Zeit, um einen MOVE auszuführen, die Zeit, die der
Elektronenstrahl benötigt, um 8 Pixel bei niedriger Auflösung abzutasten. Daher
erzeugt eine Reihe von MOVEs in COLOR00 auf dem Bildschirm eine Sequenz von
Segmenten von 8 Pixeln, von denen jedes eine bestimmte Farbe hat.
Die folgende Serie von MOVE erzeugt beispielsweise 3 Segmente, jeweils
rot, grün und blau:

	DC.W $0180,$0F00
	DC.W $0180,$00F0
	DC.W $0180,$000F

Es ist also höchstens möglich, das Ergebnis von 40 MOVEs hintereinander oder
40 Segmenten unterschiedlicher Farbe auf einer Zeile eines niedrig auflösenden
Bildschirms (320 Pixel breit) zu erzeugen. Dadurch ist es möglich, den
sogenannten Copper-Line-Effekt zu erzeugen, bei dem die Werte der 
aufeinanderfolgenden MOVEs von einem wie ein Fass durchlaufenen Gradienten von
einem Offset stammen, der bei jedem Frame inkrementiert wird, um eine Animation
zu erzeugen:

Bild: Copper-Line-Effekt	; figure2-5.png

Klicken Sie hier, um die Quelle des Mindestcodes für eine Copper-Linieneffekt
herunterzuladen.

Beachten Sie, dass Sie, um diesen Effekt bei einer bestimmten Höhe des
Bildschirms zu erzeugen, den MOVEs ein WAIT voranstellen müssen. Das erste Wort
eines WAIT liefert die horizontalen und vertikalen Positionen, mit denen der
Copper die aktuelle Position des Rasters vergleichen muss, während letzteres
den Bildschirm abtastet, um das Bild bei jedem Frame anzuzeigen. Das zweite 
Wort liefert Masken, die auf die erwartete und die aktuelle Position anzuwenden
sind, wodurch die Bits der letzteren bestimmt werden, auf die sich der
Vergleich bezieht. Was gegeben ist:

Bild: Die Kodierung des WAIT-Befehls	; figure3-4-768x71.png

Der Vergleich ist vom Typ "größer oder gleich": Damit der Copper zum
WAIT-Befehl geht, muss die aktuelle Position größer oder gleich der erwarteten
Position sein. Mit anderen Worten, und dies ist ein wichtiger Punkt, wenn das
Raster bereits die erwartete Position passiert hat, wenn das Copper auf das
WAIT in der Copperliste fällt, bleibt der Copper nicht vor dem WAIT stehen,
während auf die Rückkehr des Rasters gewartet wird zu dieser Position während
des nächsten Frames: es geht zum nächsten Befehl in der Copper-Liste.

Es wird dem Leser nicht entgangen sein, dass die horizontale Position und ihre
Maske ausgehend von Bit 1 auf 7 Bits codiert sind, während die vertikale
Position auf 8 Bits codiert ist, mit Ausnahme ihrer Maske, von der Bit 7
ausgeschlossen erscheint. Wie wir sehen werden, sind diese Besonderheiten 
allesamt Quellen der Komplexität. Denken Sie vorerst daran, dass das
BFD-Bit auf 1 sein muss (es wird verwendet, um dem Copper anzuzeigen, dass es
auf den Blitter warten muss, der hier nicht von Interesse ist) und dass die
0-Bits des ersten und zweiten Worts auf 0 bzw. 1 sein müssen - der Copper
verlässt sich auf die Kombination der 0-Bits der beiden Wörter eines Opcodes,
um zu bestimmen, mit welchem ​​Befehl es zu tun hat.

Es ist beispielsweise möglich, auf die horizontale Position X auf die vertikale
Position Y wie folgt zu warten (die Masken werden nicht verwendet, alle ihre
Bits sind auf 1):

	DC.W (Y<<8)!X!$0001
	DC.W $8000!($7F<<8)!$FE

In der Quelle der Copper-Linie beträgt die erwartete horizontale Position, um
den MOVE zu starten, $3E. Diese Position stimmt mit dem Anfang einer Bitebene
überein, wenn die in DIWSTRT angegebene horizontale Position normalerweise $81
beträgt. Es wird daher häufig gefunden.
Die Möglichkeit, auf den Beginn jeder Zeile warten zu können, um die
Hintergrundfarbe - oder jede andere Farbe - nacheinander zu ändern und eine
Copperzeile zu erzeugen, wird verwendet, um den zuvor vorgestellten
Plasmaeffekt zu erzeugen. Bei einem solchen Effekt werden 41 MOVEs pro Zeile
ausgeführt. Tatsächlich besteht eine kleine Feinheit darin, die Genauigkeit der
horizontalen Position eines WAIT, die bei niedriger Auflösung 4 Pixel beträgt,
auszunutzen, um eine Zeile gegenüber der vorherigen und der nächsten zu
verschieben und so einen übermäßig pixeligen Effekt zu vermeiden:

Bild: Plasma ; figure5-4.png

Der gleiche Plasmaeffekt, keine Verschiebung um 4 Pixel jede zweite Zeile
Unter diesen Bedingungen zeigt jede zweite Zeile die 8 Pixel, die von 39 MOVEs
erzeugt wurden, plus die 4 Pixel, die von 2 zusätzlichen MOVEs erzeugt wurden,
also insgesamt 41 MOVEs. Um den Code zu vereinfachen, der die Farben in der
Copperliste modifiziert, wird diese Anzahl von MOVEs pro Zeile auf alle Zeilen
verallgemeinert, verschoben oder nicht.

Klicken Sie hier, um die Quelle des minimalen Codes für ein RGB-Plasma
herunterzuladen. Wenn der Code vollständig original ist, lassen Sie uns
angeben, dass er die von Stéphane Rubinstein in Amiga News Tech Nr. 31
(März 1992) beschriebene Technik der Trennung der Komponenten R, G und B
ausnutzt.

DAS INTERESSE AM LOOPING AM COPPER

Der Copper kann für viel mehr verwendet werden, als nur darauf zu warten, dass
das Raster am Anfang der Linie eine Reihe von MOVEs ausführt. Das Amiga-
Hardware-Referenzhandbuch dokumentiert zwei fortgeschrittene Anwendungen vom
Copper: zum Aktivieren des Blitters und zum Ausführen von Loops. Auf diese
letzte Verwendung werden wir uns konzentrieren.

Bevor wir zum Kern der Sache kommen, sei darauf hingewiesen, dass es nicht
einfach ist, sich für Copperschleifen zu interessieren und von dort aus auf die
Besonderheiten der WAIT- und SKIP-Anweisungen einzugehen, Quellen wie schon
gesagt der Komplexität. Der Grund wird später erklärt. Sagen wir erst einmal,
dass es paradoxerweise durchaus möglich ist, mit dem Copper komplexe Effekte zu
erzielen, ohne wirklich zu wissen, wie es funktioniert - es ist diese Lektion,
die diesem Artikel einen Raum gibt, der geeignet ist, das Interesse des
Spielers zu wecken, der nicht altmodisch ist. Das hoffen wir zumindest.

Zur Veranschaulichung können wir uns noch auf ein konkretes Beispiel verlassen,
nämlich die Darstellung eines Echtfarbenbildes in Copper. Hallo! Alles in allem
ermöglicht die gerade vorgestellte Technik zur Herstellung eines Plasmas nicht
ganz einfach ein Hintergrundbild von 40x32 "Pixeln" in PAL (jedes "Pixel" wird
auf dem Bildschirm durch ein Segment von 8 Pixeln Breite und 1 Pixel Höhe
erreicht.) Warum also nicht versuchen, dort ein Bild anzuzeigen, dessen Werte
der R-, G- und B-Komponenten der Farbe jedes Pixels ohne Bezug auf eine
Palette, also in Echtfarbe, angegeben sind?
Konvertieren Sie dazu einfach ein normales Bild in eine MOVE-Serie. Nehmen wir
ein Bild im RAW Blitter (RAWB) von PICTURE_DX auf PICTURE_DY Pixel auf
PICTURE_DEPTH Bitplanes, das heißt in 1 << PICTURE_DEPTH Farben. Zur
Erinnerung, wir bezeichnen mit RAWB ein triviales Bilddateiformat, da der
Inhalt der Datei wie folgt organisiert ist:

Zeile 0 in Bitebene 1
...
Zeile 0 in Bitebene N
...
PICTURE_DY-1-Zeile in Bitebene 1
...
PICTURE_DY-1-Zeile in Bitebene N
Palette (Fortsetzung der Wörter)

Lassen Sie uns einige Konstanten definieren ...:

PICTURE_DX=320
PICTURE_DY=256
PICTURE_DEPTH=5

... integrieren wir die Image-Datei in die ausführbare Datei ...:

Bild: incbin "picture.rawb"

... und konvertieren Sie das Bild:

	lea picture,a0
	movea.l a0,a1
	addi.l #PICTURE_DEPTH*PICTURE_DY*(PICTURE_DX>>3),a1
	movea.l moves,a2
	move.w #PICTURE_DY-1,d1
_convertY:
	move.w #(PICTURE_DX>>3)-1,d0
_convertX:
	moveq #7,d2
_convertByte:
	clr.w d4
	clr.w d5
	moveq #1,d6
	moveq #PICTURE_DEPTH-1,d3
_convertByteBitplanes:
	btst d2,(a0,d4.w)
	beq _convertBit0
	or.b d6,d5
_convertBit0:
	add.b d6,d6
	add.w #PICTURE_DX>>3,d4
	dbf d3,_convertByteBitplanes
	add.w d5,d5
	move.w (a1,d5.w),(a2)+
	dbf d2,_convertByte
	lea 1(a0),a0
	dbf d0,_convertX
	lea (PICTURE_DEPTH-1)*(PICTURE_DX>>3)(a0),a0
	dbf d1,_convertY

Der Konverter muss für jedes Pixel den Farbindex ermitteln, was eine horrende
Anzahl von Tests generiert, aber das Ergebnis ist trotzdem recht schnell
erreicht. Wie auch immer, dies ist nur eine Initialisierungsphase. Eine
Optimierung ist daher irrelevant, da die Leistung der Hauptschleife nicht
beeinträchtigt wird.
Diese MOVEs werden verwendet, um eine Copper-Liste zu bilden: Um 40 Pixel einer
Zeile in Form von "Pixeln" darzustellen, reicht es aus, die entsprechende Reihe
von MOVEs zu nehmen. Dies erzeugt jedoch nur eine Reihe von 8 x 1 Pixel-
Segmenten auf dem Bildschirm. Damit das Ergebnis wie ein Bildschirm mit zwar
sehr geringer Auflösung aussieht, aber trotzdem ein Bildschirm, müssen wir jede
Zeile logischerweise 8-mal wiederholen. Somit erscheint auf dem Bildschirm ein
"Pixel" in Form eines Blocks von 8x8 Pixeln.

Nehmen wir zum Beispiel ein Beispiel des prächtigen (Worte versagen ...)
Dragonsun-Bildes dieses Michelangelo aus Grafiken auf Amiga, ich möchte Cougar
aus der Gruppe Sanity nennen, Gewinner von KO während des Wettbewerbs The Party
im Jahr 1993:

Bild: Echtfarbenbild auf Amiga 500 (Beispiel von Dragonsun von Cougar / Sanity)
	; figure6-3.png

Es wäre durchaus möglich, die Copper-Liste mit 40 MOVE-Sets zu füllen, indem
man ein Set achtmal hintereinander wiederholt, wobei jedem Set ein WAIT
vorangeht, das den Copper anweist, mit der Ausführung zu beginnen.

Dies scheint jedoch zwei Nachteile zu haben:
 - es würde Speicher verbrauchen;
 - das würde viele MOVEs machen, um das Bild im Hintergrundbild zu ändern.

Um die Anzahl der MOVEs zu reduzieren, ist es möglich, den SKIP-Befehl vom
Copper zu verwenden.

WARTEN UND ÜBERSPRINGEN, UM DAS Copper ZU LOOPEN

Nehmen wir an, dass es notwendig ist, eine Copperliste aufzubauen, deren
Adresse im Register A0 erscheint. Jeder Block von 8 Zeilen besteht aus einer
COPPER_DX MOVE- Serie (40, um die 320 Pixel eines Bildschirms mit niedriger
Auflösung abzudecken), die an jeder der COPPER_DY- Zeilen des Bildschirms
wiederholt werden muss (32, um die 256 Zeilen dieses gleichen Bildschirms
im PAL abzudecken). Beginnen wir also damit, dass die erste Zeile die erste
Zeile mit Blöcken anzeigt, nämlich COPPER_Y, die normalerweise $2C ist, um den
oberen Rand des Bildschirms zu bezeichnen:
	
	move.w #((COPPER_Y&$00FF)<<8)!$0001,d0		; D0 X=0 Y=y
	move.w d0,(a0)+
	move.w #$8000!($7F<<8)!$FE,(a0)+			; WAIT X=0 Y=COPPER_Y

Dies ist ein klassischer WAIT-Befehl, bei dem die vertikale Positionsmaske $7F
und die horizontale Positionsmaske $FE ist, was dem Copper sagt, dass er die
Position des Rasters mit allen Bits der vertikalen Position und der
horizontalen Position vergleichen soll, die wir dazu angeben.

Lassen Sie uns die Position ändern, an der das Copper jetzt auf das Raster
wartet, es sei denn, wir verstecken einige Teile davon. Standardmäßig wartet
der Copper bei (COPPER_X, COPPER_Y), COPPER_X entspricht normalerweise $81,
um die linke Seite des Bildschirms zu bezeichnen:

	or.w #(((COPPER_X-4)>>2)<<1)&$00FE,d0		; D0 X=x Y=y

Merken wir uns die Adresse, unter der wir uns befinden, denn sie wird weiter
verwendet:

_copperListRows:
	move.l a0,d2

Warten wir, bis sich das Raster an der horizontalen Position befindet, an der
das erste "Pixel" erscheinen muss. Wir warten in einer beliebigen Zeile darauf
und nutzen dafür die Möglichkeit, die Bits der vertikalen Position
auszublenden:

	move.w d0,(a0)+
	move.w #($00<<8)!$FE,(a0)+					; WAIT X=x Y=?

Dann können wir die Reihe von MOVE bereitstellen, um auf dem Bildschirm die
erste Zeile der Reihe von COPPER_DX- "Pixeln" darzustellen. In Anbetracht
dessen, dass wir die Adresse der MOVEs, die sich aus der Konvertierung des
Bildes in A1 ergeben, gespeichert haben, ergibt sich:

	move.w #COPPER_DX-1,d3
_copperListCols:
	move.w #COLOR00,(a0)+
	move.w (a1)+,(a0)+
	dbf d3,_copperListCols

Dann wird es subtil. Tatsächlich werden wir den Copper bitten, zum vorherigen
WAIT zurückzukehren.
Wie bringe ich den Copper dazu, mit der Ausführung einer bestimmten
Anweisungsliste zu beginnen? Durch Modifizieren der Adresse, die der Copper in
den COP1LCH- und COP1LCL-Registern liest, wenn irgendein Wert in das
COPJMP1-Register geschrieben wird. Dies entspricht einem 68000 JUMP, daher der
Name dieses Registers, und dies ist der Copper "JUMP"-Befehl.
Diese Register gehören jedoch zu denen, in die der Copper schreiben kann. Es
ist daher möglich, den Copper aufzufordern, die zuvor in COP1LCH und COP1LCL
gespeicherte Adresse zu schreiben:
	
	move.w #COP1LCL,(a0)+
	move.w d2,(a0)+			; MOVE COP1LCL
	swap d2
	move.w #COP1LCH,(a0)+
	move.w d2,(a0)+			; MOVE COP1LCH

Die natürliche Abfolge wäre, einen MOVE hinzuzufügen, um einen beliebigen Wert,
zum Beispiel 0, in COPJMP1 zu schreiben, wodurch das Copper springt.
Tatsächlich wartet der Copper, wenn er auf das zweite WAIT fällt, auf das
Raster in der horizontalen Position COPPER_X auf einer beliebigen Zeile. Und da
es auf dieses WAIT zurückgreifen wird, während der Plot von 320 Pixeln, der den
COPPER_DX MOVE darstellt, gerade auf Zeile N beendet wurde, wartet der Copper
auf das Raster an der horizontalen Position COPPER_X der folgenden Zeile,
Zeile N + 1. Auf diese Weise führt der Copper den COPPER_DX MOVE erneut auf
dieser Linie aus.
Daher müssen wir diese MOVEs nicht über 7 Zeilen wiederholen, was uns Speicher
spart und die Menge an MOVEs begrenzt, die geändert werden müssen, um das als
"Pixel" angezeigte Bild zu modifizieren.
Allerdings muss der Copper nur 8 mal die MOVE-Serie leisten. Vor dem Schreiben
in COPJMP1 muss es daher prüfen, ob das Raster die Position, von der es die
letzte Zeile gezeichnet hat, nicht überschritten hat. Wenn dies der Fall ist,
sollte der Copper COPJMP1 ignorieren. Genau das macht ein SKIP.
Ein SKIP wird genauso codiert wie ein WAIT. Sein erstes Wort gibt die
horizontalen und vertikalen Positionen an, mit denen der Copper die aktuelle
Position des Rasters vergleichen muss. Das zweite Wort liefert Masken, die auf
die erwartete und die aktuelle Position anzuwenden sind, wodurch die Bits der
letzteren bestimmt werden, auf die sich der Vergleich bezieht. Welche geben:

Bild: Die Kodierung der SKIP-Anweisung	; figure7-3-768x71.png

Es reicht daher aus, den Wert des ersten Wortes, das zum Codieren von WAIT
verwendet wird, wiederzuverwenden, nachdem die vertikale Position um 7 erhöht
wurde:
	
	addi.w #$0700,d0
	move.w d0,(a0)+
	move.w #$8000!($7F<<8)!$FE!$0001,(a0)+	; SKIP X=x Y=y+7

Wenn der SKIP nicht validiert wird, muss der Copper daher durch Schreiben
in COPJMP1 zur MOVE-Serie zurückschleifen:
	
	move.w #COPJMP1,(a0)+
	move.w #$0000,(a0)+						; MOVE COPJMP1

Er muss dann auf ein WAIT fallen, das ihm sagt, dass er auf das Raster an
der horizontalen Position COPPER_X in der folgenden Zeile warten soll:
	
	addi.w #$0100,d0

Schließlich können wir zur nächsten Zeile im Bild gehen und zur Produktion der
Anweisungen zurückkehren, die der folgenden Serie von 40 "Pixeln" entsprechen:
	
	lea (PICTURE_DX-40)<<1(a1),a1
	dbf d1,_copperListRows

Vor _copperListRows wurde D1 mit der Anzahl der anzuzeigenden "Pixelzeilen"
minus eins oder COPPER_DY-1 initialisiert :
	
	move.w #COPPER_DY-1, d1

Insgesamt ergibt dies:
	
	movea.l moves,a1
	move.w #((COPPER_Y&$00FF)<<8)!$0001,d0		; D0 X=0 Y=y
	move.w d0,(a0)+
	or.w #(((COPPER_X-4)>>2)<<1)&$00FE,d0		; D0 X=x Y=y
	move.w #$8000!($7F<<8)!$FE,(a0)+			; WAIT X=0 Y=COPPER_Y
	move.w #COPPER_DY-1,d1
_copperListRows:
	move.l a0,d2
	move.w d0,(a0)+
	move.w #$8000!($00<<8)!$FE,(a0)+			; WAIT X=x Y=?
	move.w #COPPER_DX-1,d3
_copperListCols:
	move.w #COLOR01,(a0)+
	move.w (a1)+,(a0)+
	dbf d3,_copperListCols
	lea (PICTURE_DX-COPPER_DX)<<1(a1),a1
	move.w #COP1LCL,(a0)+
	move.w d2,(a0)+								; MOVE COP1LCL
	swap d2
	move.w #COP1LCH,(a0)+
	move.w d2,(a0)+								; MOVE COP1LCH
	addi.w #$0700,d0
	move.w d0,(a0)+
	move.w #$8000!($7F<<8)!$FE!$0001,(a0)+		; SKIP X=x Y=y+7
	move.w #COPJMP1,(a0)+
	move.w #$0000,(a0)+							; MOVE COPJMP1
	addi.w #$0100,d0
	dbf d1,_copperListRows

Allerdings hält der Copper eine Überraschung für uns bereit ...