
Nun fahren wir mit der Praxis fort, aber ich rate euch vorher, 68000-2.TXT

                                  '''
                                 (o o)
+---------------------------oOOO--(_)-------------------------------------+
|																		  |
|						ASSEMBLERKURS - LEKTION 9						  |
|																		  |
+--------------------------------------oOOO-------------------------------+
                                |__|__|
                                 || ||
                                ooO Ooo

Autor: Luca Forlizzi, Alvise Spano', Fabio Ciucci

(Verzeichnis Sorgenti5) - dann schreibe "V Assembler2:sorgenti5"

     иОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОи
								BLITTER
     иОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОииОXОи

In dieser Lektion werden wir anfangen, über den Blitter zu sprechen. Jeder, der
einen Amiga besitzt wird sicherlich von diesem speziellen Schaltkreis, der in
seinem Computer platziert ist, gehört haben. Er stellt sich als einer der
größten in Punkto Stärke heraus, wenn man ihn mit anderen Computern vergleicht.
Doch nicht alle aber wissen, was der Blitter eigentlich ist und aus welchen
Gründen er so nützlich ist. In der Tat die Mehrheit der Spezialeffekte, die sie
in den Demos bewundern können (wie sinusförmigen Scrolltext oder Vektorkugeln)
benutzen den Blitter. 
Und dann werden sie sich fragen, wie diese Effekte selbst auf PCs erreicht
werden können, die nicht über den Blitter verfügen? Der Grund ist, dass in
Wirklichkeit alles was der Blitter kann, kann auch mit dem Mikroprozessor
gemacht werden und es ist tatsächlich so. So machen es die PCs. Der Blitter
kann jedoch die Aufgaben viel schneller lösen, in manchen Fällen sogar 10 Mal
schneller. Es ist der Dank an den Blitter, dass spezielle Effekte, die mit
einem PC nur realisiert werden können, wenn Sie einen schnellen 386 oder gar
486 zur Verfügung haben, während ein Amiga 500 mit gewöhnlicher Ausstattung
mit seinem Prozessor (68000 mit 7Mhz, wie Sie gut wissen) viel langsamer ist,
als der 386 und 486. 
Sie werden also verstehen, dass für diejenigen, die Demos oder Spiele auf dem
Amiga programmieren wollen das Wissen um den Blitter essentiell ist. Wir
beginnen das Studium der Fähigkeiten des Blitters ausgehend vom Einfachsten.
Auf den ersten Blick mögen sie langweilig und unbedeutend erscheinen, aber dann
werden wir allmählich die dahinter versteckte Kraft entdecken, die die
Schaffung von Spielen und spektakuläreren Demos erlaubten. Es sollte jedoch
beachtet werden, dass die Programme die für den 68020+ geschrieben wurden, eher
dazu tendieren, die CPU als den Blitter zu verwenden, da letzteres nicht die
Geschwindigkeit erhöht.

      .    .
  ,      ,   ,  ..            ______________
    .     ..     и ..        /      ,      г\           ____
      .    и:: ..   и:. .:,_/  »»»»»  -----' \         `----'
                и::: ..: ::`________  ________\ ____________________
    .и  :и  и :::. . .  и:  )(  г(X ) ) О)» )  \                  _/
           ,   :::и.  ..:. ,  »»»»»» (»»»»»»   /_____________ ___ T
       и:    .       . и '»\_   _    »\  _   _/   `-----||( АА:::!|
  .       :и      .        /    /   (,_) \    \ xCz     ll  !|:::||
     .,             _______\   / ________ \   /_______   »»T |:::||
                  /ппппппппп\   /_T_T_T_T\   /ппппппппп\   | !ддд!|
                 /ппппппппппп\__» » » » »»__/ппппппппппп\  l______!
                /пппппппппппппп`----------'пппппппппппппп\  `----'
               иппппппппппппппппппппппппппппппппппппппппппи


*******************************************************************************
*							FUNKTIONEN DES BLITTERS						      *
*******************************************************************************

Das Wort "Blitter" ist eine Abkürzung für "BLock Image TransferER" oder
"Bildblockkopierer". Der Blitter ist daher ein Werkzeug, mit dem wir "Teile"
von Bildern bewegen können. In Wirklichkeit wie Sie später herausfinden werden,
ist dies nur eine der Möglichkeiten. Der Blitter kann noch komplexere
Operationen ausführen.
Wie Sie wissen, besteht ein Bild im Amiga einfach aus einem Speicherbereich,
der die Daten enthält, die die Farbe jedes einzelnen Pixels definieren. Wenn
Sie sich nicht gut erinnern, wie die Bilder aufgebaut sind, dann ist es gut,
wenn Sie noch einmal die Lektionen 4 und 5 wiederholen, bevor sie weiter
fortfahren. Wenn der Blitter eine Operation an einem "Stück" des Bildes
ausführt, arbeitet er tatsächlich auf dem Speicherbereich, der das "Stück" vom
Bild enthält. Tatsächlich arbeitet der Blitter einfach auf Speicherbereichen,
unabhängig davon, ob sie ein Bild einer Grafik, ein Sound oder den Programmcode
enthalten. Dies bedeutet, dass der Blitter auch in solchen Aufgaben verwendet
werden kann, die nicht die Grafik betreffen.
Es ist jedoch wichtig zu wissen, dass der Blitter, wie der Copper, die
Audio-Schaltkreise und der ganze Rest der Customs Chips des Amigas, nicht in
der Lage ist, auf allen verfügbaren Speicher zuzugreifen, sondern nur auf einen
Teil davon den sogenannten "Chip RAM".

Um auf den Speicher zuzugreifen, verwendet der Blitter die erwähnten DMA-Kanäle
die in Lektion 8 ganz allgemein erklärt wurden, auf die ich Sie im Zweifelsfall
verweise. Der Blitter verfügt über 4 DMA-Kanäle, von denen 3 (A, B und C)
genannt werden, verwendet um Daten aus dem RAM zu lesen (und aus diesem Grund
werden sie  "Quelle"-Kanäle genannt), während der vierte (Kanal D) zum 
Schreiben in den Speicher verwendet wird (und deshalb wird er als "Ziel"-Kanal
bezeichnet). Wie bei allen DMA-Kanälen übertragen die Blitter-Kanäle jeweils
ein Datenwort.

Das allgemeine Schema einer Blitter-Operation ("BLIT" genannt) ist vereinfacht:
Der Blitter liest über die Kanäle A, B und C Daten aus dem Speicher, führt
Operationen an ihnen durch und schreibt das Ergebnis über den Kanal D in den
Speicher. Für eine erfolgreiche Blitter-Operation sind folgende Informationen
notwendig:

1) welche Kanäle sollen für dies Operation verwendet werden 
2) welche Operation ist an den gelesenen Daten durchzuführen 
3) für jeden verwendeten Kanal die Adresse, an der das Lesen und Schreiben
   beginnt
4) wie viele Daten sind zu lesen oder zu schreiben 

Beachten Sie, dass die Menge an Daten, die während einer Operation gelesen
(oder geschrieben) werden, für alle vier Kanäle gleich ist: Wenn ich in einer
Operation die Kanäle A, B und D verwende, sind die Anzahl der Wörter, die über
Kanal A gelesen werden, gleich der Anzahl von Wörtern, die durch Kanal B
gelesen werden und gleich der Anzahl von Wörtern, die über Kanal D geschrieben
werden.

Diese Informationen werden durch einige Hardware-Register spezifiziert. Die
Register, die den Blitter steuern, sind wie alle Hardware-Register 16-Bit. Es
gibt jedoch viele Register mit aufeinanderfolgenden Adressen. Diese Tatsache
macht es möglich, mit "move.l" paarweise darauf zuzugreifen statt mit "move.w",
ähnlich dem, wie wir es für andere Paare gesehen haben, z.B. den Registern
BPLxPT ($dff0e0 ...) und COPxLC ($dff080 ...).

Bevor Sie mit dem Schreiben in die Register beginnen, müssen Sie sicher sein,
dass der Blitter im stationären Zustand ist, d.h. das er aktuell keine
Operation macht. Es ist wichtig zu warten, bis der letzte "Blit" fertig ist,
bevor Sie einen anderen machen, sonst könnte es Explosionen und Zusammenbrüche
innerhalb eines Radius von 100 Meter verursachen, eine echte Katastrophe,
vergleichbar mit einem Luftangriff.

Um zu wissen, ob der Blitter stationär ist oder das "Blitting" noch läuft, wird 
einfach der Status eines Bits (Bit 6) des DMACONR-Registers ($dff002)
überprüft. Wenn dieses Bit 1 ist, dann arbeitet der Blitter, während, wenn 
es 0 ist, sagt es uns, dass der Blitter fertig ist.

In der Praxis genügt dann eine einfache Abfrage:

waitBlit:
	btst	#6,$dff002	; dmaconr - ist der Blitter fertig?
	bne.s	waitBlit	; geh nicht weiter, bis er fertig ist


Leider gibt es einen sehr nervigen Hardware-BUG in der ersten Versionen des 
Agnus-Chips (der Chip, der den Blitter enthält), der die Dinge verkompliziet.
So wird beim ersten Lesen des fraglichen Bits ein falsches Ergebnis geliefert.
Deswegen muss eine Leermessung durchgeführt werden um den Status des Bits
genau zu kennen.

Nachdem wir uns vergewissert haben, dass der Blitter stationär ist, können wir
in die Register die Informationen schreiben, die der Blitter benötigt, d.h. die
die wir oben aufgelistet haben.

Lassen Sie uns nun im Detail sehen, wie es weitergeht.

1) Für jeden Blitt können wir unabhängig voneinander die DMA-Kanäle aktivieren
 oder deaktivieren die uns interessieren und zwar mit Hilfe der Freigabebits, 
 die, wenn sie auf 1 gesetzt sind, den Kanal freigeben; bzw. wenn sie
 zurückgesetzt sind, deaktiviert sind. 
 Die Freigabebits finden wir im Steuerregister BLTCON0 ($dff040):

Kanal	Name Freigabebit		Bitposition in BLTCON0

  A			SRCA						8
  B			SRCB						9
  C			SRCC						10
  D			DEST						11

2) Um festzulegen, welche Operation ausgeführt werden soll, werden die
 Bits 0 bis 7 des BLTCON0-Steuerregister beschrieben, die sogenannten MINTERMS.
 Der Wert, den sie annehmen bestimmt die vom Blitter durchgeführte Operation.
 Die Wirkungsweise der MINTERMS ist ziemlich kompliziert und wir werden sie
 später ausführlich erklären.
  
3) Jetzt wollen wir sehen, wie man die Startadressen der Kanäle festlegt. Jeder
 Kanal hat einen Zeiger zum RAM-Speicher, welcher die Startadresse der
 Operation enthält. Während der Operation ändert sich der im Zeiger enthaltene
 Wert automatisch und zeigt immer auf die Adresse des Wortes, das der Blitter
 liest oder schreibt. Ein Zeiger wird erstellt (wie für die DMA-Kanäle von
 Sprites und Bitplanes) aus einem Paar von 16-Bit-Registern, von denen eines
 den niederwertigen 16 Bit Teil enthält und eins, das den Rest enthält (hoch).
 Diese Tabelle fasst die Namen und Adressen der Zeiger zusammen:
    
Kanal	Register hoch			Register niedrig	   

		Name	   Adresse		Name	   Adresse	

  A		BLTAPTH	   $DFF050		BLTAPTL	   $DFF052
  B		BLTBPTH	   $DFF04C		BLTBPTL	   $DFF04E
  C		BLTCPTH	   $DFF048		BLTCPTL	   $DFF04A
  D		BLTDPTH	   $DFF054		BLTDPTL	   $DFF056  

Diese Registerpaare können eindeutig wie einzelne 32-Bit-Register behandelt
werden - wie für Copperlist- und Bitplane-Zeiger - und daher kann die
Adresse mit einer einzigen "move.l" Anweisung in die BLTxPTH geschrieben
werden. Daher werden wir sie von nun an als individuelle 32-Bit-Register
betrachten, mit dem Namen BLTxPT die sich auf die Adressen $dff050, $dff04c,
$dff048 und $dff054 beziehen. (mit Ausnahmen auf die wir angemessen zu
sprechen kommen)

Die Zeigerregister sollten mit einer Adresse in Bytes geschrieben werden, aber
da der Blitter nur mit WÖRTERN arbeitet, wird das niedrigstwertige Bit unserer
Adresse ignoriert, daher müssen die Adressen immer gerade sein, d.h. auf WORDS
ausgerichtet. 
Deshalb muss man sich merken, dass man nur geraden Adressen in den CHIP-
Speicher schreiben kann, sowohl für die Quellen als auch für das Ziel.

HINWEIS: Weisen Sie unbenutzten Bits immer eine Null zu, insbesondere solchen,
die nicht vorhanden sind und keine Funktion auch in ECS haben, da es in
zukünftigen Versionen sein könnte, das sie für wer weiß welche Zwecke verwendet
werden. Die Ergebnisse wären unvorhersehbar.

4) Die letzte auszuführende Operation besteht darin, die Datenmenge anzugeben,
die gelesen oder geschrieben werden soll. Dies geschieht über das Register
BLTSIZE ($dff058). Dieses Register erlaubt dem Blitter, die Daten die gelesen
oder geschrieben werden nicht als einfache Folge von Wörtern zu
berücksichtigen, sondern als eine Art zweidimensionales Rechteck, das aus
Wörtern besteht. Zum Beispiel betrachtet der Blitter eine Folge von 8 Wörtern,
wie ein Rechteck, 8 Wörter breit und 1 Zeile hoch:

                          Breite=8 WORD
                     _______________|_______________
                    /                               \

                   ein word
                     _|_
                    /   \ 
                 /  +---+---+---+---+---+---+---+---+
Höhe = 1 Zeile -    | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
                 \  +---+---+---+---+---+---+---+---+

			Abb. 1	Rechteck der Wörter 8*1


Nehmen wir ein anderes Beispiel: Eine Folge von 50 Wörtern kann berücksichtigt
werden als ein Rechteck von 10 Wörtern x 5 Zeilen:

                           Breite=10 WORD
                     _______________|_______________
                    /                               \

                   ein word
                     _|_
                    /   \ 
                  / +---+---+---+---+---+---+---+---+---+---+
                 |  | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
                 |  +---+---+---+---+---+---+---+---+---+---+
                 |  |   |   |   |   |   |   |   |   |   |   |
                 |  +---+---+---+---+---+---+---+---+---+---+
Höhe=5 Zeilen -	 |  |   |   |   |   |   |   |   |   |   |   |
                 |  +---+---+---+---+---+---+---+---+---+---+
                 |  |   |   |   |   |   |   |   |   |   |   |
                 |  +---+---+---+---+---+---+---+---+---+---+
                 |  |   |   |   |   |   |   |   |   |   |   |
                 \  +---+---+---+---+---+---+---+---+---+---+

			Abb. 2	Rechteck der Wörter 10*5

Diese Tatsache, die auf den ersten Blick wie eine unnötige Komplikation
erscheinen mag, ist eine der Eigenschaften, die den Blitter so großartig
macht. In einem Moment werden wir sehen warum. Aber lassen sie uns zuerst
sehen, wie BLTSIZE funktioniert. Um die Menge der Daten anzugeben, die in
den Blit einbezogen werden, schreiben wir in BLTSIZE die Dimensionen des
Rechtecks ​​der Wörter, die die Daten bilden.
In den 6 unteren Bits wird die horizontale Dimension angegeben, das ist
die ANZAHL VON WÖRTERN, aus dennen sich jede horizontale Zeile
zusammensetzt. In den oberen 10 Bits muss die Anzahl der horizontalen
Zeilen angegeben werden, aus denen das Rechteck besteht:
Im Wesentlichen wird die Breite des Rechtecks in X in den unteren 6 Bits
angegeben, die Höhe Y des besagten Rechtecks in den oberen 10 Bits.
Es sollte beachtet werden, dass, wenn der Wert der oberen 10 Bits 0 ist, der
Blitter 1024 Zeilen blittet, und wenn der Wert der 6 niedrigen Bits (Breite
in Wort) 0 ist, der Blitter 64 Wörter blittet und daher werden wir den
größten Blit durch Eingabe von "move.w #$0000,$dff058" erhalten.

Es wird 64 Worte x 1024 Zeilen und damit (= 64 * 2 * 1024 = 128 Kb) sein.
Das BLTSIZE-Register hat noch eine weitere wichtige Funktion: DURCH SCHREIBEN
DER GRÖSSE WIRD DER BLITTER AKTIVIERT und startet den angegebenen Vorgang.

Aus diesem Grund MÜSSEN SIE IMMER INS BLTSIZE REGISTER SCHREIBEN, NACHDEM IN
ALLE ANDEREN REGISTER DES BLITTERS GESCHRIEBEN WURDE, sonst wird der Blit
gestartet, bevor Sie alle korrekt eingestellt haben, was zu anderen
Ergebnissen führt als erwünscht.

	                    ._________________
	                    |    _________    |
	                    |   (_________)   |
	                    |_________________|
	                     |:и            и|
	                    _|______   ______|_
	                     |______. .______|
	                   _/       |^|       \_
	                 __\\_______|_|_______//__
	                /__/    __(_____)__    \__\
	               //\/    /           \    \/\\
	               \_/    /_____________\    \_/
	                /    /»    _____    »\    \
	                \        _  /    _        /  ___________
	    .____________\_______(       )_______/__/           \
	    | ___/                \_____/          / _     _   _ \
	    | | \_________________________________/  \|    |   |  \
	    | |      g«m|         _________      /    \    |   |   \
	  __| |__       |       »»   /|\   »»   /______\___|___|___/
	 /       \ _____|___________  |  ______//______\\     )
	(__|_| |_//                 \_|_/      \        /____/
	     |_| /___________________\ /_____ __\______/____\


An dieser Stelle ist es gut, das bisher Gelernte in die Praxis umzusetzen, 
indem wir uns einige Beispiele ansehen werden. In diesen Beispielen verwenden
wir auch Register, über die wir noch nicht gesprochen haben, wie BLTDMOD und
BLTCON1. Für den Moment ignoriere sie, wir werden sie später erklären.

In Listing9a1.s sehen Sie, wie Sie mit dem Blitter einen Speicherbereich
löschen. Um einen Löschvorgang durchzuführen, müssen Sie nur den Kanal D
aktivieren, weil wir nur die gelöschten Wörter in den Speicher schreiben.
Für das Deaktivieren des Quell- und Zielkanals wird $00  geschrieben. Um eine
Löschoperation zu definieren, ist es notwendig den Wert $00 in den MINTERMS
zu schreiben, d.h. in den Bits 0-7 (das niederwertige Byte) des Registers
BLTCON0.

In Listing9a2.s verwenden wir den Blitter, um Daten aus einem Speicherbereich
in einen anderen Bereich zu kopieren. Für diesen Vorgang werden wir die Kanäle
A und D verwenden. Die Daten werden über Kanal A aus dem Speicher gelesen und
über Kanal D in den Speicher geschrieben. Um einen Kopiervorgang von Kanal A
zum Kanal D zu definieren ist es notwendig, den Wert $F0 in die MINTERMS zu
schreiben.

		__________
		\ AMIGA! /       lllll
		 \ !!!! /     __/     \__
		  \____/      \/ (o!o) \/
		    ||        / \_____/ \
		    ||       /___________\\\\\
		    ||           _| |_     \  \
		    ||__________/     \_____\_ \
		    ()(________/       \________)
		    ||        /_________\
		    ||       (_____░_____)
		    ||        \    Y    /
		    ||       __\___|___/__
		  __||____ __\_____!_____/_____

*******************************************************************************
*		ERSTE ANWENDUNGEN DES BLITTERS										  *
*******************************************************************************

Wir werden nun beginnen, den Blitter in grafischen Anwendungen zu verwenden.
Wie wir wissen besteht ein Bild aus Datenworten im Speicher. Mit dem Blitter
können wir Operationen an den Daten im Speicher ausführen. Wir können eine
Veränderung des Bildes selbst verursachen.
Lassen Sie uns einen kurzen Überblick über die Darstellung der Bilder geben.
Wir beschränken uns auf den Fall einer einzelnen Bitebene.

Eine Bitebene ist eine Menge von Wörtern, von denen jeder den Zustand eines
Pixels darstellt: Ein Wort steht für 16 horizontal angeordnete Pixel. Das erste
Wort der Bitebene repräsentiert die 16 Pixel links von der ersten Zeile des
Bildes. Die folgenden Wörter repräsentieren alle Pixel in der ersten Zeile der
Reihe nach. Wenn die Pixel der ersten Zeile fertig sind, starten wir auf die
gleiche Weise mit der zweiten Zeile.
Wenn sich beispielsweise 320 Pixel in einer Zeile befinden, sind 320/16 =
20 Wörter erforderlich um alles darzustellen. Deshalb stellen die ersten
20 Wörter der Bitebene die erste Zeile des Bildes dar, die Wörter von
21. bis 39. stellen die zweite Zeile dar usw.

		 ____ ____ ____ ____ _ _ _ _ _ _ ____
		|    |    |    |    |			|    |
		| 0  | 1  |  2 |  3 |			| 19 |
		|____|____|____|____|			|____|
		|    |    |    |    |			|    |
		| 20 | 21 | 22 | 23 |			| 39 |
		|____|____|____|____|			|____|
		|    |    |    |    |			|    |
		| 40 | 41 | 42 | 43 |			| 59 |
		|____|____|____|____|			|____|
		|									 |
		|									 |


		|____ ____ ____ ____			 ____|
		|    |    |    |    |			|    |
		|    |    |    |    |			|    |
		|____|____|____|____|_ _ _ _ _ _|____|

		Abb. 3  Darstellung des Speichers eines Bildes:
				Jedes Quadrat ist ein Word 


Wir haben gesehen, dass wir mit dem Blitter Daten von einem Punkt zum Anderen
kopieren können. Zur Erinnerung, wenn wir Daten innerhalb einer Bitebene
kopieren um das Bild auf dem Bildschirm zu bilden, arbeitet der Blitter wie
gesagt, mit Daten in der WORD (16 Bit)-Dimension. Es erlaubt das Bild in
Gruppen von WORD zu ändern, das heißt in Gruppen von 16 Pixeln. Zum Beispiel,
wenn wir mit dem Blitter das 21-te Wort der Bitebene eingeben, werden wir 
die 16 Pixel links von der zweiten Zeile im Bild ändern.
Nehmen wir an, wir haben ein Bild mit einer einzelnen Zeile und einer
bestimmten Anzahl L von Pixeln breit. Gerade weil die Bitebene in Worte 
unterteilt ist, die 16 Pixel enthalten, ist es zweckmäßig, dass die Breite in
Pixel unseres Bildes, d.h. L, ein Vielfaches von 16 ist, so dass das Bild genau
L / 16 Wörter enthält. Dies kann erreicht werden durch Hinzufügen von 0-Pixel
am Ende unseres Bildes, wie anhand des folgenden Beispiels veranschaulicht:

Dies ist ein 20 Pixel breites Bild und nur eine Zeile hoch.
	
	1100110101010001.1001
	\__________________/
 		 |
	     20 pixel

		 
Es ist unangenehm zu handhaben, weil 20 kein Vielfaches von 16 ist. Wir fügen
daher 0-Wert-Pixel am Ende hinzu, um die Breite von 32 Pixel zu erhalten,
d.h. gleich einem Vielfachen von 16.

	1100110101010001.1001000000000000
	\______________________________/
		|
	    32 pixel

Unser Bild ist in den Daten unseres Programms gespeichert. Um es auf dem
Bildschirm erscheinen zu lassen, müssen wir es in den Speicherbereich der
Bitebene kopieren. Das Bild nimmt eine entsprechende Position zu den Wörten
der Bitebene auf dem Bildschirm ein, in die wir es kopieren werden.
Angenommen, wir wollen das Bild auf dem Bildschirm zeichnen, so dass das erste
Pixel davon, das ist das Pixel am weitesten links, die X - und Y - Koordinaten
annimmt. (ich erinnere sie daran, dass das Koordinatensystem des Bildschirms
ihren Koordinatenursprung, das ist der Koordinatenpunkt X = 0 und Y = 0, in der
linken oberen Ecke hat. Die X-Koordinatoren wachsen nach rechts während das Y
nach unten wächst).
Dieses Pixel ist in einem Wort der Bitebene enthalten. Für den Moment
betrachten wir den Fall, in dem X auch ein Vielfaches von 16 ist. Dies stellt
sicher, dass unser Pixel das erste ist (d.h. das Pixel auf der linken Seite)
des Wortes, zu dem es gehört. Auf diese Weise, wenn einmal die Adresse dieses
Wortes berechnet ist, können wir (mit dem Blitter) das erste Wort des Bildes
kopieren. Die anderen Wörter, die unser Bild formen, werden natürlich in die
Wörter der nächsten Bitebenen kopiert. All dies, da der Blitter Wortsequenzen
kopieren kann, wird mit einem einzelnen Blitt gemacht, der die Quelladresse
des ersten Wortes des Bildes und als Zieladresse die Adresse des Wortes der
Bitebene, zu der das X- und Y-Koordinatenpixel gehört.
Sehen wir uns an, wie man diese Adresse berechnet. Wir nummerieren die Wörter
der Bitebenen von 0 an, wie in der Abbildung gezeigt, und berechnen die Nummer
des Wortes, das uns interessiert: Von dieser Nummer werden wir wieder zur
eigentlichen Adresse zurückkehren.
Wir beginnen mit der Berechnung der Nummer des ersten Wortes der Zeile Y, wobei
wir uns noch einmal daran erinnern, dass jede Zeile aus 20 Wörtern besteht und
das die Zeilen von 0 an nummeriert sind. Sie können aus der Abbildung erkennen,
dass das erste Wort der Zeile 0 (die erste Zeile) die Nummer 0 hat, das erste
Wort der Zeile 1 (die zweite Zeile) die Nummer 20 hat, das erste Wort der
Zeile 2 die Nummer 40 hat, das erste Wort der Zeile 3 die Nummer 60 hat und so
weiter.
Im Allgemeinen hat daher das erste Wort der Zeile Y die Nummer Y * 20. Die
Nummern der anderen Wörter in der Zeile sind denen der ersten folgend: Das
zweite Wort der Zeile hat die Nummer Y * 20 + 1, das dritte Wort der Zeile hat
die Nummer Y * 20 + 2 und so weiter.
Wir können nun den "Abstand" eines bestimmten Wortes R vom ersten Wort der
Zeile bestimmen, also den Betrag, der zu der Nummer des ersten Wortes der Zeile
hinzugefügt werden muss um das Wort R (Nummer) zu erhalten: 

In der Praxis, da das zweite Wort der Zeile die Nummer Y * 20 + 1 hat, sagen
wir, dass es den "Abstand" 1 vom ersten Wort der Zeile hat. In gleicher Weise
hat das dritte Wort der Zeile, welches die Nummer Y * 20 + 2 hat, den Abstand 2
vom ersten Wort der Zeile und so weiter.
Wir können auch sagen, dass das erste Wort der Zeile den Abstand 0 von sich
selbst hat. Es ist sehr einfach, den Abstand zwischen dem Wort, das das Pixel
der Koordinate X enthält, und dem ersten Wort der Zeile zu berechnen, wie wir
anhand der folgenden Abbildung sehen werden: 

			 ________ ________ ________ ________ _ _ _
			|        |        |        |        |		
Zeile Y		| Y*20+0 | Y*20+1 | Y*20+2 | Y*20+3 |
			|________|________|________|________|_ _ _

Entfernung 
vom 
Wordanfang  |   0	 |   1	  |   2    |   3    | -  -

Pixel
Inhalt:		|  0-15  |  16-31 |  32-47 |  48-63 | -  -

			Abb. 4	Reihe der Wörter

Die X-Koordinate unseres Pixels repräsentiert die Entfernung (in Pixeln)
zwischen ihm und dem ersten Pixel der Zeile. Da jedes Wort 16 Pixel enthält,
enthält das erste Wort einer Zeile die ersten 16 Pixel der Zeile, d.h. deren
X-Koordinate (= ein Abstand vom Rand) von 0 bis 15 hat. Das zweite Wort enthält
stattdessen die Pixel, deren X-Koordinate zwischen 16 bis 31 variiert, das
dritte Wort die Pixel, deren X-Koordinate von 32 bis 47 variiert, und so weiter: 
Alle 16 Pixel haben wir ein Wort.
Um also den Abstand zwischen den Wörtern zu berechnen, teilen Sie einfach die
Entfernung in Pixel (das ist der Wert von X) durch 16. Da wir X als ein
Vielfaches von 16 gewählt haben, wird das Ergebnis eine ganze Zahl sein. Wenn
beispielsweise X = 32 ist, ist der Abstand in Worten 32/16 = 2. Wie Sie in der
Abbildung sehen können, ist das Pixel 32 der Zeile Y tatsächlich das erste
Pixel des dritten Wortes der Zeile, dessen Nummer genau Y * 20 + 2 ist.
Mit derselben Berechnung sehen wir, dass das Pixel, das X = 64 hat, in dem Wort
enthalten ist welches 64/16 = 4 ist, das Wort, dessen Nummer Y * 20 + 4 ist.
Diese Berechnung funktioniert auch wenn X = 0 ist: Tatsächlich haben wir den
Abstand 0/16 = 0, das ist das Wort mit der Nummer Y * 20 + 0, das genau das
erste Wort der Zeile ist.

Insgesamt ist dann das Wort mit dem Pixel X, Y (das Wort mit der Nummer N)
durch die folgende Formel gegeben:

N = (Y*20)+(X/16)

Diese Formel gilt für die Bitebene, in der eine Zeile aus 20 Wörter besteht.
Im Allgemeinen lautet die Formel:

N = (Y * Anzahl der Wörter einer Zeile) + (X/16)

Von der Nummr des Wortes können wir zur entsprechenden Adresse zurückgehen:
Einfach die Adresse des ersten Wortes der Bitebene nehmen und die Nummer des
Wortes multipliziert mit 2 (Multiplikation ist notwendig, weil die Adresse in
Bytes ausgedrückt wird und 1 Wort = 2 Bytes) hinzufügen:

Wortadresse = (Bitplaneadresse)+N*2.

Im Beispiel Listing9b1.s finden Sie die Anwendung von allem, was wir bis hier
gesagt haben. Im Beispiel Listing9b2.s sehen Sie eine Reihe von Blitts an
verschiedene Positionen des Bildschirms.

Beginnen wir nun mit Bildern, deren Höhe größer als eine Zeile ist. Wir haben
gesehen, als wir über das BLTSIZE-Register gesprochen haben, wie der Blitter
die Daten betrachtet. Der Blitter sieht die Daten als "Rechtecke" von Wörtern. 
Diese Eigenschaft ist sehr nützlich, weil es es uns ermöglicht, leicht mit
rechteckigen Bildern zu arbeiten. Angenommen, Sie möchten eine Bitebene eines
32 Pixel breiten und 2 Zeilen hohen Bildes in eine Bitplane kopieren. Dieses
kleine Bild belegt einen kleinen Teil der Bitebene, hervorgehoben in der
Abbildung mit schrägen Linien.

		 ____ ____ ____ ____ _ _ _ _ _ _ ____
		|    |    |    |    |			|    |
		| 0  | 1  |  2 |  3 |	        | 19 |
		|____|____|____|____|			|____|
		|    |\\\\|\\\\|    |			|    |
		| 20 |\21\|\22\| 23 |			| 39 |
		|____|\\\\|\\\\|____|			|____|
		|    |\\\\|\\\\|    |			|    |
		| 40 |\41\|\42\| 43 |			| 59 |
		|____|\\\\|\\\\|____|			|____|
		|									 |
		|									 |


		|____ ____ ____ ____			 ____|
		|    |    |    |    |			|    |
		|    |    |    |    |			|    |
		|____|____|____|____|_ _ _ _ _ _|____|

		Abb. 5  Eine Bitebene mit hervorgehobenem Bereich
				auf dem wir einen blit machen

Es ist ein kleines Rechteck, 2 Wörter breit (d.h. 32 Pixel) und 2 Zeilen hoch.
Sie werden sofort verstehen, dass, um die Kopie zu machen, ist es notwendig die
Größe des Rechtecks ​​in BLTSIZE anzugeben. Aber das ist nicht ausreichend. Um 
dies zu realisieren, lassen Sie uns für einen Moment in die Rolle des Blitters
schlüpfen und lassen Sie uns versuchen die Kopie selbst durchzuführen, in dem
wir unsere Aufmerksamkeit im Moment nur auf die Schreibphase konzentrieren. 
Wir kennen (weil es in BLTDPT geschrieben ist) die Adresse des Wortes oben links
im Rechteck (das Wort 21 in der Abbildung). Wir kennen auch (es ist in BLTSIZE
geschrieben) die Dimensionen des Rechtecks. Sehr gut. Wir lesen das erste Wort
und kopieren es an die Adresse des Wortes 21. Jetzt müssen wir das zweite Wort
der ersten Zeile kopieren. Wir wissen, dass dieses Wort dem ersten Wort folgt
und addieren 2 zu der Adresse des ersten Wortes (das in BLTDPT geschrieben ist)
Jetzt kennen wir die Adresse des zweiten zu schreibenden Wortes. Wir schreiben
es und wir haben die erste Zeile beendet. Sehr zufrieden bereiten wir uns vor,
die zweite Zeile zu schreiben. Und hier erkennen wir, dass es ein kleines
Problem gibt: Das erste Wort der zweiten Zeile folgt nicht dem letzten Wort der
ersten Zeile! In der Tat, wie Sie aus der Abbildung sehen können, ist das
letzte Wort der ersten Zeile das Wort 22 während in der zweiten Zeile das Wort
41 steht.
Wie berechnen wir die Adresse des ersten Wortes der zweiten Zeile? In der
Abbildung wird eine 20 Wörter breite Bitebene gezeigt, aber es ist nur ein
Beispiel. Woher weiß der arme Blitter, wie viele Wörter die Bitebene hat?
Tatsächlich könnten wir uns in einer größeren Bitplane als dem sichtbaren
Bildschirm befinden! Wer sagt dem Blitter, dass wir ihn zum Kopieren eines
Rechtecks auf dem Bildschirm benutzen wollen? Was wäre, wenn wir die Daten
einfach in eine Copperliste kopieren? Es ist offensichtlich, dass der Blitter
allein nicht weiß wie er aus der misslichen Lage kommt.
Aber es gibt kein Problem, wir helfen ihm. Was der Blitter wissen muss, ist
einfach, wie man die Adresse des ersten Wortes einer Zeile berechnet, wenn man
die Adresse des letzten Wortes der vorherigen Zeile kennt.
Wenn Sie sich einen Moment die Abbildung ansehen, werden sie erkennen das der
Blitter einfach die Wörter von 23 bis einschließlich 40 "überspringen" muss.
Dies kann geschehen, indem zur Adresse des Wortes 22 (d.h. der Adresse des
letzten Wortes der ersten Zeile, die der Blitter bereits kennt) die Anzahl der
Bytes der Differenz zum Wort 42 (das genau das erste Wort der neuen Zeile ist)
addiert wird. Diese Anzahl von Bytes, das MODULO genannt wird, ist natürlich
gleich der Anzahl der Wörter die "übersprungen" werden sollen, multipliziert
mit 2 (denn wie Sie wissen, belegt ein Wort 2 Bytes).


word		0            X            X+L             H
Zeile y		|------------|*************|--------------|
Zeile y+1	|------------|*************|--------------|
			\____________/\____________/\_____________/
	 			   |		    |			   |
	 			 word zum	word Bild		word zum
				 Springen	Größe L			Springen
				
			Abb. 6	Modulo
		
Im Allgemeinen, wenn wir ein Rechteck mit einer Breite von L Wörtern in eine
Bitmap mit einer Breite von H Wörtern kopieren wollen, erhält man das MODULO in
Bytes mit der folgenden Formel:

MODULO = (H-L)*2

Die H-L Berechnung würde uns das Modulo in Wörtern ausgedrückt geben, 
multipliziert mit 2 dient dazu, es in Bytes auszudrücken. In unserem Beispiel
ist das MODULO (20-2)*2.
Wenn Sie sich erinnern, hatten wir das Konzept des MODULO in Bezug auf
Bitebenen kennengelernt. Das Blitter-Modulo funktioniert genauso. Es ist
möglich, jedem DMA-Kanal ein anderes Modulo zuzuweisen. Auf diese Weise können
Daten zwischen Bitebenen unterschiedlicher Breite kopiert und bewegt werden.
Der Wert des MODULOS wird in 4 spezifische Register geschrieben, eines für 
jeden DMA-Kanal:
BLTAMOD für Kanal A ($dff064), BLTBMOD für B ($dff062),
BLTCMOD für Kanal C ($dff060), BLTDMOD für D ($dff066).
MODULO-Werte sind in Bytes, und nicht als Wörter anzugeben. Da der Blitter nur
mit Wörtern arbeiten kann, wird das niederwertigste Bit ignoriert, was
bedeutet, dass der Modulo-Wert gerade sein muss.
Der Wert, positiv oder negativ, wird den Registern (BLTxPT) die auf die
Adressen zeigen jedes Mal, wenn der Blitter das Kopieren beendet hat
automatisch hinzugefügt um die Adresse des ersten Wortes der nächsten Zeile zu
berechnen. Negative Werte als Ergebnis der Berechnung können in vielen Fällen
nützlich sein, z.B. um eine Zeile zu wiederholen, indem Sie das MODULO als
Breite der Bitebene negativ festlegen. Wir haben bereits in Lektion 5 gesehen,
wie man eine Zeile wiederholen kann in dem die Register BPL1MOD / BPL2MOD
in der Copperlist auf -40 setzen, oder auf jeden Fall eine lineare Länge haben.

		          ._________
		          |  _ ____/
		       ___|______|___
		     _/              \_
		     \________________/
		          \_ Oo _/
		        /\_(»»»»)_/\
		       /    \  /    \
		     ./ /\   \/   /\ \.))
		     | |  \__  __/  | |
		     | |   |    |   | |
		     | \   |    |   / |
		   (( \ \__|____|__/ /
		       \/ _/    \_ \/
		        \||______||/
		       /|_|  |   |_|\
		      / ||   |    || \
		     ( (»    |     ») )
		     | |     |      | |
		     | |     |      | |
		    _|_|     |      |_|_
		    \  |     |______|  /
		     ) |           g| (
		 ___/  |           «|  \___
		/______|           m|______\


An dieser Stelle wissen wir, wie man ein Rechteck innerhalb einer Bitmap
kopiert. Lassen Sie uns mit einem Beispiel alle notwendigen Berechnungen
zusammenfassen: 

Angenommen, wir möchten auf einem Abschnitt einer 320 x 200 großen Bitmap
arbeiten, die bei Zeile 13, Wort 6 (beide sind von Null nummeriert) 5 Wörter
breit beginnt. Zuerst müssen wir die Adresse des ersten Wortes des Rechtecks
ermitteln, und schreiben es dann in das BLTxPT-Register des Kanals, das uns
interessiert. Die Berechnung erfolgt folgendermaßen: Wir nehmen die Adresse
des ersten Wortes der Bitebene und fügen 13 * 20 * 2 Bytes hinzu, um die
Adresse des erstes Bytes der Zeile 13 (tatsächlich belegt jede Zeile 20 Wörter
= 40 Bytes) und schließlich addieren wir 12 Bytes (= 6 Wörter), um zur
richtigen horizontalen Position zu kommen.
Die Breite beträgt 5 Wörter (10 Bytes). Am Ende jeder Zeile müssen wir 30 Bytes
springen um zum Anfang der nächsten Zeile zu kommen, also verwenden wir ein
MODULO von 30. Im Allgemeinen enstspricht die doppelte Breite (in Wörtern) plus
dem Modulo-Wert (in Byte) gleich der vollen Breite der Bitebene des Bildes in
Bytes.

Die Berechnung der erforderlichen Werte der Blitter-Register
BLTxMOD und BLTxPTR (BLTxPTH und BLTxPTL) ist in der Abbildung dargestellt.


<Speicher_Addr> = Adresse (0,0)
	     \
	      \
	       \ Anzahl BYTE (SPALTE)
	        \ 0	    10	      20	30	 39
			 \|	     |	       |	 |	  |
			  +----------------------------------------+ - -
			 0|ииииииииииииииииииииииииииииииииииииииии|	|
			 1|ииииииииииииииииииииииииииииииииииииииии|
			 2|ииииииииииииииииииииииииииииииииииииииии|	|
			 3|ииииииииииииииииииииииииииииииииииииииии|
			 4|ииииииииииииииииииииииииииииииииииииииии|	|
			 5|ииииииииииииииииииииииииииииииииииииииии|
			 6|ииииииииииииииииииииииииииииииииииииииии|	|
			 7|ииииииииииииииииииииииииииииииииииииииии|
			 8|ииииииииииииииииииииииииииииииииииииииии|	|
			 9|ииииииииииииииииииииииииииииииииииииииии|
	 Zeilen	10|ииииииииииииииииииииииииииииииииииииииии|	|
	 nummer	11|ииииииииииииииииииииииииииииииииииииииии|
			12|ииииииииииииииииииииииииииииииииииииииии|	|- - Fenster
			13|ииииииииииии##########ииииииииииииииииии|	     Bitmap
			14|ииииииииииии##########ииииииииииииииииии|	|
			15|иSprung Anf ##########иии Sprung Ziel.ии|
			16|<---------->##########<---------------->|	|
			17| = 12 bytes ##########иии = 18 bytes иии|
			18|ииииииииииии##########ииииииииииииииииии|	|
			19|иииииииииииииииии\ииииииииииииииииииииии|
			20|ииииииииииииииииии\иииииииииииииииииииии|	|
			 -|иииииииииииииииииии\ииииииииииииииииииии|
			 -|ииииииииииииииииииии\иииииииииииииииииии|    |
			 -|иииииииииииииииииииии\ииииииииииииииииии|
			 -|ииииииииииииииииииииии\иииииииииииииииии|	|
			  +-----------------------\------------\---+ - -
									   \			\
									    \			 \
							zu manipulierendes Bild	  \
													   \
													ein Byte

	BLTxPTR = <Speicher-Addresse> + (40*13) + 12
			= <Speicher-Addresse> + 532

	BLTxMOD = 12 + 18
			= 30 bytes

		Abb. 7  Berechnung für BLTxPTR und BLTxMOD
		
An diesem Punkt ist es gut, anzuhalten und einige Beispiele zu betrachten.

In Listing9c1.s und Listing9c2.s finden Sie einfache Beispiele für das Kopieren
von rechteckigen Bereichen. Studieren Sie sie sorgfältig und konzentrieren sie
sich auf die Berechnung der Adressen und MODULO, die in den Blitts verwendet
werden.

In Listing9c3.s gibt es ein Beispiel, in dem ein Blitt mit einem negativen
Modulo gemacht wird.

In Listing9d1.s und Listing9d2.s sehen Sie die ersten Beispiele für Animationen
mit dem Blitter.

Die Idee ist sehr einfach. Um die Bewegung unserer Figur zu erhalten, genügt
es, sie jedes Mal an einer anderen Position neu zu zeichnen, so ähnlich wie
wir es mit den Sprites getan haben. Anders als da aber, bevor die Figur an die
neue Position gezeichnet wird, müssen wir sie an der alten Position löschen,
da wir sonst einen "Trail" (Nachzieh-)Effekt bekommen würden.

In diesen 2 Beispielen verschieben wir die Figur von Zeit zu Zeit um eine Zeile
nach unten durch Hinzufügen von jeweils 40 Bytes zur BLTxPT-Adresse.

In Listing9d3.s wenden wir die gleiche Technik an, um die Figur horizontal zu
bewegen. Beachten Sie jedoch, dass das Ändern der Adresse dem Verschieben des
Rechtecks nach rechts (oder links) um eins oder mehreren Wörtern entspricht.
Ein Wort entspricht 16 Pixeln, auf diese Weise können wir die horizontale
Bewegung nur in Schritten von 16 Pixel machen, was man, wie Sie im Beispiel
sehen können die Bewegung nicht sehr flüssig und zu schnell macht.

	              .       :
	                      и
	              д:.:.:.:д
	              l______ |
	              (░X░ )  »)
	              |C_»»__ T___
	 ________     l_____г l _ \
	(_____   \________T____/ ) \
	    (__   ______________/   \
	     (____/      /\░         \
	                / /\░         \
	               / /  \░         \
	      .и.     / /    \░_________\
	    .и   и. _/  \     »\ _..  г\  xCz
	  .и       (_   _)      \/и:    \____
	.и          `-`-'       /и:      \.  \__
	ииии.     .иииии       /и:        \:. \ \
	    :     :            \и:.        \::.\ \
	....:..  .:...........  \и::.       \___\ \
	                       __\___________\ `-\_)
	                      (_____________)

Bis jetzt haben wir uns darauf beschränkt, Figuren zu zeichnen, bei denen das
äußerste linke Pixel an einer Position mit einem Vielfachen von 16 ist. Für
eine flüssige Bewegung ist es jedoch notwendig die Figur an einer beliebigen
Position auf dem Bildschirm zeichnen zu können. Nehmen wir ein Beispiel:
Stellen wir uns vor, wir haben das Bild eines Autos, das wir auf dem Bildschirm
bewegen wollen.

Indem wir die Adresse des Rechtecks, das es enthält, richtig berechnen, können
wir unser Auto von einem beliebigen Wort auf dem Bildschirm aus "blitten". Wenn
unser Auto-Bild zum Beispiel die Tür 5 Pixel von der äußersten linken Seite
entfernt ist, können wir es zusammen mit dem Auto um 5 Pixel vom Anfang eines
Wortes auf dem Bildschirm bewegen. Wenn wir sie nach rechts verschieben wollen,
können wir sie ab dem nächsten Wort "blitten". 
Das Ergebnis wäre jedes Mal ein "Klick" von 16 Pixeln. Wenn wir das Auto aber
pixelweise nach rechts oder links verschieben wollen, oder in jedem Fall in 
einer horizontalen Position, die nicht ein Vielfaches von 16 ist, wie können
wir das tun?

Wir müssen sicherstellen, dass die Pixel, die das Bild bilden, NICHT vom ersten
Bit des ersten Wortes aus kopiert werden, sondern von einem beliebigen Bit 
innerhalb dieses Wortes, wie in der folgenden Abbildung gezeigt.

		kopiere mit X multipliziere mit 16

erstes word
Quelle			1 0 0 1 1 0 1 0 1

				| | | | | | | | |
				| | | | | | | | |
				v v v v v v v v v
erstes word 	_ _ _ _ _ _ _ _ _ _
Ziel	       |_|_|_|_|_|_|_|_|_|_

bit				0 1 2 3 4 5 6 7 8 ..


		kopiere mit X willkürlich

erstes word
Quelle	 			  1 0 0 1 1 0 1 0 1

					  | | | | | | | | |
					  | | | | | | | | |
					  v v v v v v v v v
erstes word 	_ _ _ _ _ _ _ _ _ _
Ziel	       |_|_|_|_|_|_|_|_|_|_

bit				0 1 2 3 4 5 6 7 8 ..

		Abb. 8  Shift 

In der Praxis müssen wir die Bits, aus denen die Figur besteht, von links nach
rechts verschieben.

Der Blitter hat einen Hardware-Shifter für die Kanäle A und B, der alle Bits
der Wörter die aus den Kanälen A und B gelesen werden nach rechts verschiebt.
Die Bits werden um eine bestimmte Anzahl von Positionen verschoben, die von
0 bis 15 variieren kann.

Das Verschieben von 0 Positionen ist gleichbedeutend mit dem Nicht-Verschieben:
Alle Blitts die wir bisher gesehen (und durchgeführt) haben, wurden mit einer
0-Positionen-Verschiebung geblittet. Der Verschiebungswert für Kanal A wird mit
den Bits 15 bis 12 des BLTCON0 Registers ($dff040) zugewiesen; der
Verschiebungswert für Kanal B wird mit den Bits 15 bis 12 von BLTCON1 ($dff042).
Wenn Sie sich erinnern - bisher hatten wir diese Bits immer auf 0 belassen, was
eine Verschiebung um 0 Positionen bedeutet. Kanal C hingegen ist ein
Proletarier, er hat keinen Shifter.
(Für diejenigen, die es vergessen haben, bedeutet das Verschieben von Bits das
"Scrollen" von Bits nach rechts oder links ....)
Der Verschiebevorgang wird gleichzeitig mit dem normalen Kopiervorgang
durchgeführt und die Geschwindigkeit des Blitters nicht beeinflusst: Unabhängig
vom Wert der Verschiebung bleibt die Zeit für den Blitter immer gleich.
Dank der Verschiebung können wir eine Figur zeichnen, bei der sich das äußerste
linke Pixel an einer beliebige X-Position befindet, indem wir die Adresse des
Ziels wie üblich berechnen, können wir die Figur an einem Vielfachen der
X-Position von 16 zeichnen. Durch gleichzeitige Aktivierung des Shifters können
wir die Figur weiter nach rechts verschieben, damit sie die gewünschte Position
erreicht.
Angenommen, Sie möchten eine X-Position von 38 Pixeln. Durch die Berechnung der
Adresse können wir das Objekt um 32 Pixel nach rechts vom Rand 0 verschieben
(32 ist ein Vielfaches von 16), und dann um weitere 6 Bits nach rechts
verschieben (38-32 = 6), indem wir einen Verschiebungswert von 6 einstellen.
Wenn X kein Vielfaches von 16 ist, erhalten wir bei der ganzzahligen Division
X / 16 im Allgemeinen ein ganzzahliges Ergebnis (das wir zur Berechnung der
Zieladresse verwenden) und einen Rest, der uns sagt, wie groß die Verschiebung
sein muss.
(Ich erinnere mich, dass die ganzzahlige Division eine Division ist, bei der
die Dezimalstellen der Nachkommastellen des Ergebnisses nicht berechnet werden
und ein Rest erhalten wird, wie in der ersten Klasse; zum Beispiel 7/3 = 2 mit
einem Rest von 1).
Im Falle einer horizontalen Position X = 100 ergibt sich 100/16 = 6 mit dem 
Rest von 4 (in Wirklichkeit 16 * 6 = 96 und 100-96 = 4); daher ist der Abstand 
zwischen dem ersten Zielwort und dem ersten Wort der Zeile gleich 6 Worte,
d.h. 12 Bytes, und der Verschiebungswert beträgt 4 Bits.

Bevor wir mit der Verschiebung beginnen, müssen wir jedoch verstehen, wie sie
funktioniert. Zunächst werden einige Bits natürlich direkt aus dem Wort zu dem
sie gehörten heraus verschoben. Von links muss etwas hineingeschoben werden, um
die Bits zu ersetzen, die herausgefallen sind. Und was genau? Im ersten Wort
werden Nullen eingeschoben. Für jedes nachfolgende Wort die Bits, die aus dem
vorherigen Wort verschoben wurden. Kurz gesagt, was von einer Seite (rechts)
kommt geht in die andere Seite (links!) im folgenden Wort rein.

Nehmen wir ein kleines Beispiel und helfen uns mit einer Figur, um es besser zu
verstehen. Nehmen wir an, wir kopieren 3 Wörter (eine Zeile kann ein
einzeiliges Rechteck bilden) 3 Wörter breit oder 3 Zeilen hoch und 1 Wort
breit, das macht keinen Unterschied vom Blickpunkt auf die Verschiebung). Wir 
stellen einen Shift-Wert von 3 ein.

Schauen wir uns an, was passiert:

Quelle
word 1					word 2					word 3
10001100.01010101		00010010.01000110		10101010.10101010
			  ^^^					  ^^^
Ziel
word 1					word 2					word 3
000100011.0001010		10100010.01001000		11010101.01010101
^^^						^^^						^^^

diese 3 Bits sind		diese 3 Bits sind		diese 3 Bits sind
die in das erste		die aus dem				die aus dem
Wort hinein				ersten Word				zweiten Word
verschobenen Nullen		herausgeschobenen		herausgeschobenen
						und in das zweite		und in das dritte
						word hinein				word hinein	

		Abb. 9  shift

Beachten Sie, dass die letzten 3 Bits von Wort 3 der Quelle NIRGENDWO hin
kopiert werden!

Betrachten wir zum Beispiel einen Blitt mit drei Wörtern Breite und zwei
Wörtern Höhe, mit einer 4-Bit-Verschiebung. Der Einfachheit halber nehmen wir
an, dass es sich um eine normale Kopie von A nach D handelt. Das erste Wort,
das in D geschrieben wird, ist das erste Wort aus A, das um vier Bits nach
rechts verschoben wird, wobei 4 gelöschte Bits von links eingeschoben werden.
Das zweite Wort ist das zweite Wort von A, das nach rechts verschoben wird, 
wobei die vier niedrigstwertigen Bits (nach rechts) des ersten Wortes
verschoben werden.
Als Nächstes schreibe ich das erste Wort der zweiten Zeile von A, verschoben 
um vier Bits, wobei die vier niedrigstwertigen Bits des letzten Wortes aus
der ersten Zeile eingeschoben werden. Dies wird fortgesetzt, bis der Blitt zu
Ende ist.

In Listing9e1.s sehen Sie ein Beispiel für die Verwendung der Verschiebung, die
es ermöglicht eine Figur, um jeweils einen Pixel nach rechts zu verschieben.
Das Ergebnis ist jedoch nicht sehr gut aufgrund der Tatsache, dass die Bits
aus einem Wort herausgeschoben werden, und in das nächste Wort verschoben
werden, das eine Zeile tiefer liegt. Die Bits, die nach rechts hinausgehen, 
fallen von links in die nächste Zeile! Die Situation wird in der folgenden
Abbildung dargestellt, wobei eine 4-Bit-Verschiebung angenommen wird: 

Quelle
word 1		10000011.11100000
  "  2		11001111.11111000
  "  3		11111111.11101100
  "  4		11111111.11111110
  "  5		11001111.11111000
word 6		10000011.11100000


Ziel
word 1		00001000.00111110
  "  2		00001100.11111111
  "  3		10001111.11111110
  "  4		11001111.11111111
  "  5		11101100.11111111
word 6		10001000.00111110
		    ^^^^

		
Diese 4 Bit-Spalten bestehen aus den Bits, die von links eingegeben werden:
Wie Sie sehen können (außer in der ersten Zeile), gehen in jeder Zeile 
die Bits, die von der vorherigen Zeile übrig geblieben sind, ein.

Abb. 10 Verschiebung eines Rechtecks

Glücklicherweise kann dieses Problem auf sehr einfache Weise gelöst werden.
Wenn Sie darüber nachdenken, möchten wir, dass die Bits, die rechts aus einem
Wort herauskommen, NICHT von links in der nächste Zeile, sondern IN DAS
ÄUSSERSTE RECHTE WORT kommen! Wir müssen daher in den Blitt auch die Wörter
weiter nach rechts "einbeziehen". Dies kann einfach dadurch geschehen, dass man
die Breite der Figur durch Hinzufügen mit Wörtern einer NULL WERT "Spalte" 
auf der rechten Seite erweitert.
Auf diese Weise ist die zusätzliche Spalte unsichtbar, und außerdem sind die
Bits, aus denen die Wörter bestehen, allesamt Nullen und daher stören sie nicht
die Wörter, wenn sie verschoben und neu eingegeben werden in der folgenden
Zeile.
Um dies zu verdeutlichen, geschieht folgendes:

Quelle
			word 1			 word 2
Zeile 1		1000001111100000.0000000000000000
  "  2		1100111111111000.0000000000000000
  "  3		1111111111101100.0000000000000000
  "  4		1111111111111110.0000000000000000
  "  5		1100111111111000.0000000000000000
  "  6		1000001111100000.0000000000000000
							 ^^^^^^^^^^^^^^^^
				
			Dies ist die Spalte der hinzugefügten Wörter

Ziel
			word 1			 word 2
Zeile 1		0000100000111110.0000000000000000
  "  2		0000110011111111.1000000000000000
  "  3		0000111111111110.1100000000000000
  "  4		0000111111111111.1110000000000000
  "  5		0000110011111111.1000000000000000
  "  6		0000100000111110.0000000000000000
			^^^^		     ^^^^
							 |	
							 Diese 4 Bits stammen aus dem Wort 1 und 
							 sie gingen in Wort 2 ein.
			|
		Diese 4 Bits haben Wort 2 der vorherigen Zeile verlassen und sind 
		in Wort 1 eingetreten (mit Ausnahme derjenigen, die in Wort 1 der Zeile 1,
		die automatisch zurückgesetzt werden)
 
Abb. 11 Verschiebung eines Rechtecks

Im Beispiel Listing9e2.s wird diese Technik angewendet, die es Ihnen erlaubt
ein Bild nach rechts mit einer Anzahl von Pixeln zwischen 1 und 15 zu
verschieben. (Tatsächlich reichen die möglichen Verschiebungswerte von 0 bis
einschließlich 15).	
Im Beispiel Listing9e3.s sehen wir endlich, wie sich unsere Figur nach rechts
um eine beliebige Anzahl von Pixeln bewegt. In der Praxis werden die Beispiele
Listing9d3.s und Listing9e2.s miteinander kombiniert.


                     __---__
	                  _-       _--______
	              __--( /     \ )XXXXXXXXXXXXX_
	            --XXX(   O   O  )XXXXXXXXXXXXXXX-
	           /XXX(       U     )        XXXXXXX\
	         /XXXXX(              )--_  XXXXXXXXXXX\
	        /XXXXX/ (      O     )   XXXXXX   \XXXXX\
	        XXXXX/   /            XXXXXX   \__ \XXXXX----
	        XXXXXX__/          XXXXXX         \__-----
	---___  XXX__/          XXXXXX      \__         ---
	  --  --__/   ___/\  XXXXXX            /  ___---=
	    -_    ___/    XXXXXX              '--- XXXXXX
	      --\/XXX\ XXXXXX                      /XXXXX
	        \XXXXXXXXX                        /XXXXX/
	         \XXXXXX                        _/XXXXX/
	           \XXXXX--__/              __-- XXXX/
	            --XXXXXXX---------------- XXXXX--
	               \XXXXXXXXXXXXXXXXXXXXXXXX-
	                 --XXXXXXXXXXXXXXXXXX-

*******************************************************************************
*					BLITT "IN FARBEN"										  *
*******************************************************************************

Bis jetzt haben wir uns darauf beschränkt, Bilder zu betrachten, die nur aus
einer Bitebene besteht, d.h. mit nur 2 Farben. Normalerweise sind beim Arbeiten
mit mehrfarbigen Bildern, die Bitebenen nacheinander im Speicher angeordnet, so
dass unmittelbar nach dem letzten Wort einer Bitebene das erste Wort der
nächste Bitebene folgt.

Das Bild ist dann wie folgt strukturiert:

bitplane 1	|    |    |    |    |			|    |
			| 0  | 1  |  2 |  3 |			| 19 |	Zeile 0 bitplane 1
			|____|____|____|____|			|____|
			|    |    |    |    |			|    |
			| 20 | 21 | 22 | 23 |			| 39 |	Zeile 1 bitplane 1
			|____|____|____|____|			|____|
			|								     |
			|								     |


			|____ ____ ____ ____			 ____|
			|    |    |    |    |			|    |
			|    |    |    |    |			|    |	letzte Zeile bitplane 1
			|____|____|____|____|_ _ _ _ _ _|____|
bitplane 2	|    |    |    |    |			|    |
			| 0  | 1  |  2 |  3 |		    | 19 |	Zeile 0 bitplane 2
			|____|____|____|____|			|____|
			|								     |
			|									 |


			|____ ____ ____ ____			 ____|
			|    |    |    |    |			|    |
			|    |    |    |    |			|    |	letzte Zeile bitplane 2
			|____|____|____|____|_ _ _ _ _ _|____|
bitplane 3	|    |    |    |    |			|    |
			|    |    |    |    |			|    |	Zeile 0 bitplane 3
			|____|____|____|____|_ _ _ _ _ _|____|
			|									 |


			|____ ____ ____ ____			 ____|
			|    |    |    |    |			|    |	letzte Zeile
			|    |    |    |    |			|    |	letzte bitplane
			|____|____|____|____|_ _ _ _ _ _|____|

		Abb. 12  Repräsentation eines Bildes im Speicher
			für mehrere-Bitebene (jedes Quadrat ist ein Wort)*/


Wie Sie bereits wissen, belegt ein Bitebene mit H-Wörter und V-Zeilen,
H * V Wörter oder 2 * H * V Bytes. (normalerweise H = 20 und V = 256, denn eine
Bitebene belegt 40 * 256 Bytes). Dies bedeutet, dass die Bitebenen im Speicher
nacheinander angeordnet sind. Wenn Bitebene 1 bei Adresse PLANE1 beginnt, dann
startet die Bitebene 2 bei PLANE2 = PLANE1 + 2 * H * V. In ähnlicher Weise
beginnt die Bitebene 3 bei PLANE3 = PLANE2 + 2 * H * V und so weiter. Die
gleiche Formel gilt für die Bestimmung der Adresse eines bestimmten Wortes in
der Bitebene. Beispielsweise erfolgt die Berechnung der Adresse des siebten
Wortes der ersten Bitebene mit: ADDRESS1 = PLANE1 + 2 * 7, bzw. der zweiten
Bitebene: ADDRESS2 = PLANE2 + 2 * 7 = PLANE1 + 2 * H * V + (2 * 7), da aber
ADDRESS1=PLANE1 + 2 * 7 ist, ergibt sich die folgende Formel:

ADRESSE2 = ADRESSE1+2*H*V.

Diese Formel wird uns in Kürze sehr nützlich sein. Ein rechteckiges Bild 
auf einem Bildschirm mit N-Bitebenen, wird durch N Rechtecke eines für jede
Bitebene gebildet. Um es also mit dem Blitter zu bearbeiten, führen Sie einfach
einen Blitt für jede Bitebene aus. In der Abbildung unten sehen Sie einen
Bildschirm mit 3 Bitebenen, mit einem Bild, das 3 Zeilen hoch hervorgehoben ist.

Im Speicher bilden die Zeilen jeder Bitebene ein anderes Rechteck von Wörtern.
(Wir haben in jeder Zeile des Bildes die Bitebene angegeben, zu der es gehört.)
Wie Sie sehen können, liegen die Zeilen jeder Bitebene nahe beieinander und von
den Zeilen der anderen Ebenen voneinander entfernt. Sie müssen deshalb mit
verschiedenen Blitts manipuliert werden.

		  +----------------------------------------+
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииии#####1####ииииииииииииииииии|
		  |ииииииииииии#####1####ииииииииииииииииии|
		  |ииииииииииии#####1####ииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|

		  |ииииииииииииииииииииииииииииииииииииииии|
		  +----------------------------------------+
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииии#####2####ииииииииииииииииии|
		  |ииииииииииии#####2####ииииииииииииииииии|
		  |ииииииииииии#####2####ииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|

		  |ииииииииииииииииииииииииииииииииииииииии|
		  +----------------------------------------+
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииии#####3####ииииииииииииииииии|
		  |ииииииииииии#####3####ииииииииииииииииии|
		  |ииииииииииии#####3####ииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|

		  |ииииииииииииииииииииииииииииииииииииииии|
		  +----------------------------------------+ 

		  Abb. 13 Bildschirm mit hervorgehobenem Bild.

Wenn wir zum Beispiel eine Figur auf dem Bildschirm zeichnen wollen, müssen
wir zuerst die erste Ebene der Figur in die erste Ebene des Bildschirms, dann
die zweite Ebene der Figur in der zweiten Ebene des Bildschirms, dann machen
wir dasselbe mit der dritten Ebene und so weiter mit den anderen.
Normalerweise macht man dann eine Blitt Schleife, wie die folgende:

	move.w	#NUMEROPLANES-1,d1	; Schleifenzähler
LOOP:
waitblit:				; warte auf das Ende des Blitters
	btst	#6,2(a5)	; des vorherigen Blitts
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A und D
	
; Laden Sie die anderen Blitter-Register

; starte den Blitt

	dbra	d1,LOOP		; Schleife

Die in die Blitter-Register zu ladenden Werte sind bei jedem Blitt immer
gleich, außer natürlich bei den BLTxPT-Registern, da die Adressen der
verschiedenen Bitebenen unterschiedlich sind. An diesem Punkt kommt die Formel,
die wir gesehen haben, ins Spiel. Mit Hilfe dieser Formel kennen wir die
Adressen, die in die BLTxPT geschrieben werden sollen, für den ersten Blitt
(d.h. für den Blitt bezogen auf die erste Bitebene) und wir sind in der Lage
die Adressen (für die BLTxPT-Register) für die nachfolgenden Bitebenen zu
berechnen. Es ist ausreichend die Adresse der ersten Bitebene in eine Variable
zu schreiben und zu dieser Adresse 2 * H * V bei jeder Schleife zu addieren.

Im Beispiel Listing9f1.s sehen Sie, wie diese Technik angewendet wird. Nicht
immer werden jedoch Schleifen dieses Typs verwendet.

In den Beispielen Listing9f2.s und Listing9f3.s gibt es weitere Beispiele für
Blitts "in Farbe".

Es gibt jedoch noch eine andere Möglichkeit, die Bitebenen im Speicher
anzuordnen, die es ermöglicht, alle Bitebenen eines Bildes in einem Durchgang
zu blitten, genannt "INTERLEAVED BITMAP" oder "interlaced bitmap". Wie der Name
schon sagt, besteht diese Technik darin, die Zeilen der verschiedenen Ebenen
miteinander zu "mischen". Anstatt zuerst alle Zeilen der ersten Ebene, dann die
der zweiten und so weiter, setzen wir zuerst die Zeile 0 (die erste) der ersten
Bitebene ein, dann die Zeile 0 der zweiten Bitebene und dann der Reihe nach die
Zeilen 0 der anderen Ebenen.
Nach den Zeilen 0 aller Ebenen kommt die Zeile 1 der ersten Ebene, dann die
Zeile 1 der zweiten Ebene und dann alle Zeilen 1 der anderen Ebenen; so geht es
weiter mit den anderen Zeilen. Um das zu verstehen, sehen Sie sich die folgende 
Abbildung an und vergleichen Sie sie mit Abbildung 12, in der die normale
Anordnung der Bitebenen dargestellt ist.


		Bitebenen.

		|    |    |    |    |			|    |
		| 0  | 1  |  2 |  3 |	        | 19 |	Zeile 0 bitplane 1
		|____|____|____|____|			|____|
		|    |    |    |    |			|    |
		| 20 | 21 | 22 | 23 |			| 39 |	Zeile 0 bitplane 2
		|____|____|____|____|			|____|
		|									 |
		|									 |


		|____ ____ ____ ____			 ____|
		|    |    |    |    |			|    |
		|    |    |    |    |			|    |	Zeile 0 letzte bitplane
		|____|____|____|____|_ _ _ _ _ _|____|
		|    |    |    |    |			|    |
		|    |    |    |    |	        |    |	Zeile 1 bitplane 1
		|____|____|____|____|			|____|
		|    |    |    |    |			|    |
		|    |    |    |    |	        |    |	Zeile 1 bitplane 2
		|____|____|____|____|			|____|
		|								     |
		|								     |


		|____ ____ ____ ____			 ____|
		|    |    |    |    |			|    |
		|    |    |    |    |			|    |	Zeile 1 letzte bitplane
		|____|____|____|____|_ _ _ _ _ _|____|
		|									 |
		|									 |


		|____ ____ ____ ____			 ____|
		|    |    |    |    |			|    |
		|    |    |    |    |			|    |	letzte Zeile bitplane 1
		|____|____|____|____|_ _ _ _ _ _|____|
		|    |    |    |    |			|    |
		|    |    |    |    |	        |    |	letzte Zeile bitplane 2
		|____|____|____|____|			|____|
		|									 |


		|____ ____ ____ ____			 ____|
		|    |    |    |    |			|    |	letzte Zeile
		|    |    |    |    |			|    |	letzte bitplane
		|____|____|____|____|_ _ _ _ _ _|____|


		Abb. 14 Darstellung eines Bildes im Speicher
		mit mehreren Bitebenen (jedes Quadrat ist ein Wort)
		mit der INTERLEAVED (oder RAWBLIT) Technik.

Sehen wir uns zunächst an, wie Bilder in diesem Format angezeigt werden können,
wobei wir den Blitter für einen Moment beiseite lassen. Die Anzahl der Wörter,
aus denen die Zeilen bestehen, ist immer gleich. Was sich ändert, ist die
relative Anordnung der Zeilen. Für uns bedeutet dies 2 Änderungen an dem
Verfahren, das wir normalerweise zur Visualisierung der Bitebenen verwenden.
Das erste betrifft die Art und Weise, wie wir die Adressen berechnen, die in
die BPLxPT-Register eingetragen werden.
Normalerweise, um in der Copperliste auf die Bitebenen zu zeigen, berechnen wir
die Adressen der folgenden Bitebenen, ausgehend von der Adresse der ersten
und addieren jedes Mal die Anzahl der Bytes einer Zeile multipliziert mit der
Anzahl der Zeilen, die die Bitebene bilden.
Dies liegt daran, dass die erste Zeile einer Bitebene nach der letzten Zeile
der vorherigen Bitebene gespeichert wird und daher von der ersten Zeile der 
vorherigen Bitebene eine Anzahl von Zeilen, die der Höhe der Bitebene selbst
entspricht. Bei der verschachtelten Anordnung hingegen wird die Zeile 0 einer
Bitebene unmittelbar nach der Zeile 0 der vorangehenden Bitebene gespeichert.
Das bedeutet, dass wir in der Schleife, welche die Bitebenenadressen berechnet,
jedes Mal zur Adresse einer Bitebene einfach die Anzahl der Bytes addieren
müssen die von EINER Zeile belegt werden, um die Adresse der nächsten Bitebene
zu erhalten. Wir müssen auch beachten, dass im Gegensatz zum Normalfall die
Zeilen, die eine Bitebene bilden, NICHT aufeinanderfolgend im Speicher
angeordnet sind.
Zwischen Zeile Y und Zeile Y + 1 befinden sich nämlich die Zeilen der anderen
Bitebenen. Das bedeutet, dass der Zeiger auf die Bitebene jedes Mal, wenn er
das Ende einer Zeile erreicht, die Zeilen der anderen Bitebenen "überspringen"
muss, um auf den Anfang der nächsten Zeile zu zeigen.
Wie Sie bereits erraten haben, müssen wir den Modulo verwenden, um ihn springen
zu lassen. Ich erinnere Sie daran, dass auch die Bitebenen ihre Modulos haben,
die in den Registern BPLxMOD enthalten sind (wobei x = 1 für ungerade Bitebenen
und x = 2 für gerade steht).
Bei der normalen Anordnung der Bitebenen, da unmittelbar nach dem Ende einer
Zeile die nächste Zeile beginnt, setzen wir das Modul auf 0 (es sei denn, wir
wollen den Flood-Effekt oder ein Bild, das größer als der Bildschirm ist).
Sehen wir uns stattdessen an, welchen Wert wir bei der verschachtelten
Anordnung setzen. Wir bezeichnen mit N die Anzahl der Bitebenen, die wir
verwenden.
Betrachten wir die Bitebene 1: Am Anfang der Zeile Y zeigt das Register BPLPT1 
auf das erste Wort der Zeile Y der Bitebene 1. Während die Zeile Y auf dem
Bildschirm angezeigt wird, ändert sich das Register BPLPT1, in dem es auf die
folgenden Wörter zeigt. Am Ende der Zeile Y zeigt BPLPT1 auf das erste Wort der
Zeile Y von Bitplane 2. An dieser Stelle wird das Modulo hinzugefügt.
BPLPT1 soll auf das erste Wort der Zeile Y + 1 der Bitebene 1 zeigen. Daher
müssen wir die Zeilen 2, 3 usw. bis N zum Zeiger überspringen. Insgesamt
sind es N-1 Zeilen (wenn wir zum Beispiel 4 Bitebenen haben, müssen wir die
Zeile Y der Bitebenen 2, 3 und 4 überspringen, das sind 3 Zeilen). Wenn also
eine Zeile L Wörter, also 2 * L Bytes, belegt, ist der korrekte Wert des 
modulo 2 * L * (N-1).

		 ____ ____ ____ ____ _ _ _ _ _ _ ____
		|    |    |    |    |			|    |
		|    |    |    |    |	        |    |		Zeile Y bitplane 1
		|____|____|____|____|			|____|
	/	|    |    |    |    |			|    |
	|	|    |    |    |    |			|    |		Zeile Y bitplane 2
	|	|____|____|____|____|			|____|
	|	|									 |
	|	|									 |
	|
	|
wir müssen diese N-1
Zeilen überspringen
	|
	|
	|	|____ ____ ____ ____			 ____|
	|	|    |    |    |    |			|    |
	|	|    |    |    |    |			|    |		Zeile Y bitplane N
	\	|____|____|____|____|_ _ _ _ _ _|____|
		|    |    |    |    |			|    |
		|    |    |    |    |	        |    |		Zeile Y+1 bitplane 1
		|____|____|____|____|			|____|

		Abb. 15 Werte der MODULO mit der INTERLEAVED-Technik.

Natürlich müssen alle Bilder, die wir auf dem Bildschirm anzeigen wollen, die 
Bitplanes im Interleaved-Format angeordnet sein. Wenn ein Bild direkt in der
Quelle definiert ist (mittels DC.w ...), müssen wir die Zeilen so anordnen, wie
es das Format vorsieht. Wenn wir stattdessen das Bild in einer externen Datei
haben, das durch die INCBIN-Direktive eingebunden werden soll, müssen wir es
NICHT in das RAW-Format konvertieren (das ist das normale Format), sondern in
das Interleaved-Format konvertieren. Alle Konvertierungsprogramme unterstützen
dieses Format, auch wenn viele es unter anderen Bezeichnungen führen.
Insbesondere der KEFRENS CONVERTER, den wir in diesem Kurs verwendet haben,
nennt dieses Format "RAW-BLIT". Andere Konverter nennen es "RASTER MODULO".
Achten Sie also darauf, das Bild in das richtige Format zu konvertieren, sonst
sehen Sie nichts und verbringen Stunden damit, Ihr Programm nach einem nicht
existierenden BUG zu durchsuchen!

In Listing9g1.s sehen Sie ein Beispiel für die Anzeige einer verschachtelten
Bitmap.

		               ___
		             _/   г\
		            /      .г\
		           /._/\\_\ \ \
		          (( _/\__\\ \<
		          /\/__.  \_.  \
		         <__ \Э\\__Y\\  \
		      ____<   »»___///  /
		     /Э   Y       .//  /
		    //    |_  э---|` ./
		   /`      /\__  ^/\ |
		  /.    .  [_  \_/  \|
		.//   _/     \_/ ~\  
		|(    |        ,   \
		|?    | (   . /    ))
		|и    | Э    Y    //  _
		|  _  | ?    |   / \ (%)
		| |_| | |    ?  ` /"XI_I_ 
		?_| |_? ?    и\  ` [____г\
		/?? ??\ и      \_  [____ (
		)     ( ._   _.  \_[_____/
		\_____/   \_/      |эaXeэ|
		                   X_____X

Lassen Sie uns jetzt sehen, warum dieses Format für die Verwendung des Blitters
praktisch ist.
In der folgenden Abbildung ist ein verschachtelter Bildschirm dargestellt, in
dem ein rechteckiger Bereich hervorgehoben ist. Wie Sie sehen können, sind die
Zeilen, die die verschiedenen Bitebenen bilden, miteinander "vermischt" und
bilden im Speicher ein einziges Rechteck (wir haben in jeder Zeile des Bildes
die Bitebene angegeben, zu der es gehört). Vergleichen Sie diese Abbildung mit
Abbildung 13, das eine ähnliche Situation mit einem "normalen" Bildschirm
zeigt. Im normalen Fall bilden die Zeilen die N Bitebenen des Bildes N
verschiedene Rechtecke aus Wörtern, von denen jedes so groß ist wie die Anzahl
der Zeilen des Bildes. Im interleaved Fall hingegen mischen sich die Zeilen der 
der N Bitebenen zusammen zu einem einzelnen Wortrechteck.
Beachten Sie, dass dieses Rechteck eine Höhe hat, die der Höhe des Bildes 
entspricht, multipliziert mit der Anzahl der Bitebenen, aus denen es besteht.
In der Abbildung haben wir also ein Bild mit 3 Bitebenen und 3 Zeilen Höhe.
Das Rechteck der Wörter hat 9 Zeilen.

		  +----------------------------------------+
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииии#####1####ииииииииииииииииии|
		  |ииииииииииии#####2####ииииииииииииииииии|
		  |ииииииииииии#####3####ииииииииииииииииии|
		  |ииииииииииии#####1####ииииииииииииииииии|
		  |ииииииииииии#####2####ииииииииииииииииии|
		  |ииииииииииии#####3####ииииииииииииииииии|
		  |ииииииииииии#####1####ииииииииииииииииии|
		  |ииииииииииии#####2####ииииииииииииииииии|
		  |ииииииииииии#####3####ииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|

		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  |ииииииииииииииииииииииииииииииииииииииии|
		  +----------------------------------------+

		  Abb. 16 INTERLEAVED-Bildschirm mit hervorgehobenem Bild.

Die Tatsache, dass im Interleaved-Format die Zeilen der Bitebenen eines Bildes 
ein einziges Rechteck im Speicher bilden, ist sehr wichtig, denn es ermöglicht 
dass wir das Bild mit einem einzigen Blitt bearbeiten können. Natürlich ist
dieser Blitt anders als der Blitt, den wir im Normalfall durchführen.
Zunächst einmal ist die Größe des Bildes anders.
Im normalen Fall hat jeder Blitt eine Höhe, die der Höhe des Bildes entspricht,
während im verschachtelten Fall das Rechteck der Wörter eine Höhe gleich der
Höhe des Bildes multipliziert mit der Anzahl der Bitebenen hat, die es bilden,
und daher muss dies die Höhe unseres Blitts sein.
Zweitens ist die Art und Weise, wie wir die Adressen der Blitts berechnen
anders, insbesondere müssen wir die Art und Weise ändern, wie wir die Adresse
des ersten Wortes einer Zeile berechnen.
Im Normalfall haben wir gesehen, dass, wenn das zu blittende Rechteck in Zeile Y
beginnt, ist der "Abstand" (Offset) des ersten Wortes der Zeile Y vom Anfang der
Bitebene gleich Y * (ANZAHL DER VON EINER ZEILE BESETZTEN BYTES). Und das ist
logisch, denn auf einem normalen Bildschirm sind die Zeilen einer Bitebene im
Speicher fortlaufend.
In einem INTERLEAVED-Bildschirm sind die Dinge jedoch anders, weil die Zeilen
einer Bitebene nicht aufeinanderfolgend sind.
Tatsächlich folgen, wie Sie wissen, nach der Zeile Y der ersten Bitebene die Y
Zeilen der anderen Bitebenen und danach die Zeile Y + 1 der ersten Bitebene.
Daher ist der Abstand zwischen dem ersten Wort der Zeile Y der ersten Bitebene
und dem ersten Wort der Zeile Y + 1 der ersten Bitebene gleich der Anzahl der
Bytes, die von den Y-Zeilen aller Bitebenen der Figur. 
Mit der gleichen Argumentation können Sie leicht verstehen, dass der Abstand
zwischen dem ersten Wort der Zeile Y der ersten Bitebene und dem Anfang des
Bildschirms gleich ist:

Y * (ANZAHL BYTES, DIE VON EINER ZEILE BELEGT WERDEN) * (ANZAHL BITPLANES)

Zusammenfassend ist daher die Berechnung der Adresse für ein Rechteckblock,
startend bei den X- und Y-Koordinaten für einen INTERLEAVED-Bildschirm:

Address_word = (Address_bitplane) + N * 2

mit:
N = (Y *(ANZAHL DER WÖRTER DIE EINE ZEILE BILDEN)*(Anzahl Bitplanes)) + (X/16).

Ein einziger Blitt anstelle von vielen macht das Programm nicht nur einfacher,
sondern auch schneller. Es ist zu beachten, dass die Zeit, die der Blitter
benötigt, (mehr oder weniger) die gleiche ist, da wir zwar einen einzigen Blitt
machen, dieser aber eine Höhe hat, die der Summe der Höhen der Blitts des
Normalfalls entspricht, und daher die gleiche Zeit braucht, denn die
Geschwindigkeit des Blitters wird im Wesentlichen durch die Anzahl der zu
bearbeitenden Wörter, d.h. von der Größe des Blitts beeinflusst.
Ein einziger Blitt ist jedoch für den Prozessor von großem Vorteil, wie das
folgende Diagramm zeigt, das die auszuführenden Operationen der 2 Fälle 
(Bildschirm mit 3 Bitebenen) vergleicht, sehen können.

NORMALER BILDSCHIRM					INTERLEAVED BILDSCHIRM

1) warte auf das Ende				warte auf das Ende
   des Blitts (wenn überhaupt)		des Blitts (wenn überhaupt)

2) lädt die Blitter Register		lädt die Blitter Register für
   für den ersten Blitt				den ersten und einzigen Blitt							

3) warte auf das Ende
   des ersten Blitts

4) lädt die Blitter Register 
   für den zweiten Blitt

5) warte auf das Ende
   der zweiten Blitts

6) lädt die Blitter Register
   für den dritten Blitt

Wie Sie sehen, muss der Prozessor im Falle eines verschachtelten Bildschirms 
weniger Operationen durchführen, und vor allem muss er nur einmal auf die
Beendigung des Blitters warten, während er im Falle eines normalen Bildschirms
so oft warten muss, wie es der Anzahl der Bitplanes entspricht. Da der
Prozessor während einer Wartezeit nichts sinnvolles macht und sich nicht
ausruhen kann, ist es ratsam, ihn so viel wie möglich arbeiten zu lassen, 
indem man die Anzahl der Wartezeiten verringert.

Das Beispiel Listing9g2.s ist die INTERLEAVED-Version des Beispiels Listing9f1.s.
Schau sie dir zusammen an und bemerke die Unterschiede, die sie zeigen.

Das Beispiel Listing9g3.s ist stattdessen die INTERLEAVED-Version des Beispiels
Listing9f3.s. Vergleichen Sie auch diese.

					               ........
					           .::::::::::::::.
					          ::::::::::::::::::
					         :::       :::::::::.
					        :::          ::::::::
					       ::(__   ___    ::::::::
					       .::/_)  /__,  :/_\::::.
					      .:::o/    o   .: //::::::
					       .::/        .::./::::::
					       ::(__  )   .::  ::::::
					       .::/()    .::   ::::::'
	 _n_____________n__                      (___           ::::
	|-----------\\\--__F                       \ ~           |
	|_____________ (O_.\________      __________\___.      ./X\
	         \(__D)__\   \\     ~~~~~~             \______/.xST\
	          `-(___O)|_  ||        .                         XX|
	            (___O) \_//          :          .:    .        О|
	              (__O)///__________ //________.:     :        .|
	                                ~~~        :      :         :
	                                           .      .         .


*******************************************************************************
*						MASKEN												  *
*******************************************************************************

Der Blitter ist in der Lage, das erste und das letzte Wort jeder Zeile, das
über Kanal A läuft, zu maskieren. Maskierung bedeutet, nur einige Bits dieser
Wörter zu lesen und die anderen zu ignorieren. Diese Operation wird mit Hilfe
von zwei Registern durchgeführt, die wir bisher verwendet haben, ohne ihre
Bedeutung zu erläutern. Diese beiden Register heißen BLTAFWM ($dff044) und
BLTALWM ($dff046) und werden verwendet, das erste und das letzte Wort jeder
Zeile, das durch den Kanal A gelesen wird, zu maskieren. Jeder von ihnen
enthält ein Wort, das als Maske dient. Wenn der Blitter das erste oder letzte
Wort einer Zeile liest, führt er eine logische UND Verknüpfung zwischen dem
gelesenen Wort und der entsprechenden Maske durch. Die Bits des Wortes, die
von Kanal A gelesen werden und in denen in der Maske ein auf 0 gesetztes Bit
ist, werden gelöscht.

Lassen sie uns ein paar Beispiele sehen:

Word gelesen von
Kanal A		%10011011.00010111
Maske		%11111111.00000000
					  ^^^^^^^^
_________________________________

Ergebnis	%10011011.00000000

Auf diese Weise haben wir nur die äußersten rechten 8 Bits des Wortes
ausgewählt.

Word gelesen von
Kanal A		%10011011.00010111
Maske		%11111100.00111111
				   ^^ ^^
_________________________________

Ergebnis	%10011000.00010111

Auf diese Weise haben wir die 4 Bits in der Mitte der Maske auf Null gesetzt.
Wenn wir die Maske vollständig löschen, löschen wir das ganze Wort:

Word gelesen von
Kanal A		%10011011.00010111
Maske		%00000000.00000000
_________________________________

Ergebnis	%00000000.00000000

Wenn wir stattdessen die Maske auf $ffff =%11111111.11111111 = -1 setzen
löscht die Maske nichts, d.h. sie "lässt" das ganze Wort durch:

Word gelesen von
Kanal A		%10011011.00010111
Maske		%11111111.11111111
_________________________________

Ergbebnis	%10011011.00010111

In allen Beispielen, die wir bisher gesehen haben, war es nicht nötig, etwas zu
maskieren und wir haben sogar beide Masken mit dem Wert $ffff initialisiert.

Das erste Wort jeder Zeile (d.h. das Wort ganz links) wird mit BLTAFWM
"UND-verknüpft", und das letzte Wort (das Wort ganz rechts) wird mit BLTALWM
"UND-verknüpft". Sie können sich das leicht merken, denn das F im Namen BLTAFWM
steht für "First", das wie jeder weiß, "vorher" bedeutet und das L in BLTALWM
steht für "Last", das ist zuletzt. Natürlich können die 2 Masken
unterschiedlich sein (wozu bräuchten wir sonst 2 Register?).
Wenn die Zeilenbreite ein einzelnes Wort ist, werden beide Masken auf dasselbe
Wort gleichzeitig angewendet. Da die 2 Register BLTAFWM und BLTALWM
aufeinanderfolgende Adressen haben, ist es möglich, sie mit einer einzigen
Anweisung MOVE.L #mask,$dff044 zu initialisieren. 
Es ist wichtig zu beachten, dass Masken auf die Daten angewendet werden, VOR
der SHIFT-Bewegung. Die Kanäle B und C hingegen haben keine Möglichkeit, die
gelesenen Wörter zu maskieren.

Im Beispiel Listing9h1.s zeigen wir die Wirkungsweise von Masken mit einfachen
Kopiervorgängen.

In Listing9h2.s haben wir eine Demonstration der Nützlichkeit der Masken
im "Extrahieren" von nur einenm Teil von einem Bild, das uns interessiert.

In Listing9h3.s und Listing9h4.s präsentieren wir 2 neue Effekte mit der
Verwendung von Masken.

Die Beispiele Listing9h2r.s, Listing9h3r.s und Listing9h4r.s sind die Versionen
mit Rawblit-Format (interleaved) von Listing9h1.s, Listing9h2.s und
Listing9h3.s.

Führen Sie einen Quervergleich durch und notieren Sie alle Unterschiede, die es
gibt (insbesondere beachten Sie, dass alle Routinen der Interleaved-Version
keine Schleife zum Blitten auf jede Ebene haben und daher eine viel einfachere
Struktur haben).

Nachdem wir die neuen Effekte gesehen haben, kehren wir zu einem alten Effekt
zurück, nämlich dem Fisch der auf dem Bildschirm schwimmt, um festzustellen,
dass wir mit unserem neuen Wissen über den Blitter eine wichtige Verbesserung
erzielen können.

Wir haben nämlich gesehen, dass es für die korrekte Verschiebung einer Figur 
notwendig ist, das eine "Spalte" von Wörtern mit Nullen auf der rechten Seite
des Bildes hinzugefügt werden muss. Diese zwingt uns dazu, mehr Speicher zu
verschwenden, als für die Speicherung der Bilder notwendig ist. Aber dank der
Masken können wir diese Verschwendung vermeiden. Zum Verschieben ist es
notwendig, dass das letzte Wort jeder Zeile der Abbildung Null gesetzt wird.
Anstatt ein gelöschtes Wort direkt aus dem Speicher zu lesen, können wir ein 
Wort mit einem beliebigen Wert lesen und es durch die Maske löschen. Da die
Maskierung VOR der Verschiebung erfolgt, kommt das letzte Wort jeder mit Null
belegten Zeile trotzdem an der Verschiebeschaltung an, und alles läuft so ab,
als ob das genullte Wort aus dem Speicher gelesen worden wäre. Da der Wert des
letzten Wortes der Zeile keine Rolle spielt, können wir ein Wort mit
beliebigem Wert lesen.

Versuchen wir also folgendes Spielchen: Wir fügen kein Wort rechts neben dem
Bild hinzu, aber ohne es dem Blitter mitzuteilen, d.h. wir stellen die Breite
des Blitts so ein, als ob rechts vom Bild ein zusätzliches Wort stehen würde. 
Der Blitter wird also, nachdem er das letzte Wort einer Zeile gelesen hat,
denken dass er noch ein Wort lesen muss, und liest deshalb das Wort, das auf
das letzte Wort der Zeile folgt. Was ist dieses Wort? Wenn wir ein Bild im
normalen Format verwenden, ist es das erste Wort der nächsten Zeile der
gleichen Bitebene, während bei einem Bild im Interleaved-Format ist es das
erste Wort einer Zeile einer anderen Bitebene. In jedem Fall handelt es sich um
ein Nicht-Null-Wort, aber für uns ist es kein Problem, weil wir es mit der
Maske zurücksetzen können.
An dieser Stelle gibt es nur ein Problem: Da wir ein Wort zu viel gelesen
haben, ist der Quellzeiger um ein Wort nach vorne gerückt, so dass wenn es 
mit der nächsten Zeile startet es mit dem zweiten Wort statt mit dem ersten
Wort beginnt. Wie kann können Sie den Zeiger zurückgehen lassen?

Natürlich mit dem alten Trick des negativen Modulos! Durch das Setzen des
Modulos der Quelle auf -2 (das Modulo wird in Bytes angegeben), wird der
Blitter auf das erste Wort der folgenden Zeile gesetzt. Um das Ganze
zusammenzufassen, gehen wir zurück zum Fischbeispiel, das wir zur
Veranschaulichung der Verschiebung verwendet haben. Wir haben also ein Bild 
einer einzelnen Bitebene, 1 Wort breit und 6 Zeilen hoch. Wie gesagt, wir fügen
KEINE Wortspalte auf der rechten Seite ein.

Quelle
			word 1		
Zeile 1		1000001111100000
  "  2		1100111111111000
  "  3		1111111111101100
  "  4		1111111111111110
  "  5		1100111111111000
  "  6		1000001111100000
				
		Abb. 17 Wir fügen KEINE Spalten mit Wörtern hinzu


Stellen wir uns jedoch vor, dass die zusätzliche Spalte vorhanden ist und
blitten dann ein Rechteck von 2 Wörtern Breite und 6 Zeilen Höhe. Der Blitter
liest dann 2 Wörter für jede Zeile, wobei das erste Wort der nächsten Zeile
als zweites Wort verwendet wird. Sehen wir uns anhand der folgenden Abbildung
an, was im Einzelnen beim Lesen der ersten Zeile geschieht:

Quelle
			word 1		
Zeile 1		1000001111100000 --------
  "  2		1100111111111000 -------+-----------------------
  "  3		1111111111101100		|						|
  "  4		1111111111111110		|						|
  "  5		1100111111111000		|						|
  "  6		1000001111100000		|						|
									|						|
									V						V
WÖRTER (LESEN)				
vom Kanal A					1000001111100000		1100111111111000
									|						|
									|						|
									V						V
Das letzte Word
der Zeile wird maskiert		1000001111100000		0000000000000000
									|						|
									|						|
									V						V

SHIFT (2 pixel)				0010000011111000		0000000000000000
									|						|
									|						|
									V						V

				
						geschrieben in Kanal D		geschrieben in Kanal D

		Abb. 18	 Shift mit Zurücksetzen des letzten Wortes.


Wie Sie sehen können, wird das zweite gelesene Wort gelöscht, bevor es
verschoben wird. Nach der Verschiebung werden die 2 Wörter über den Kanal D
geschrieben. In der Zwischenzeit hat sich der Zeiger auf Kanal A um 2 Worte
nach vorne bewegt und zeigt auf das erste Wort der dritten Zeile. 
Stattdessen müssen wir ihn auf das erste Wort der zweiten Zeile zeigen lassen,
d.h. wir müssen ihn ein Wort zurückgehen lassen. Wir verwenden also ein Modulo
gleich -2. Die Bewegungen des Zeigers werden in der folgenden Abbildung
dargestellt:


	Quelle				   WORD 	   WORD nach dem    WORD zeigt nach
						  Anfang	   Ersten LESEN		dem Hinzufügen
							 |			 1. Zeile		 des MODULO
	1000001111100000	<----				|			  |
	1100111111111000	<-------------------+--------------
	1111111111101100	<-------------------
	1111111111111110
	1100111111111000
	1000001111100000

		Abb. 19	 Bewegung des Zeigers zur Quelle.

Um unseren Fisch in Aktion zu sehen, sehen Sie sich das Beispiel
Listing9i1.s an. 

Inzwischen wissen wir, wie man mit dem Blitter sehr gut Bilder auf dem
Bildschirm bewegen kann. Diese Bilder werden BOB genannt, was eine Abkürzung
für den englischen Begriff "Blitter OBject" ist, also vom Blitter erzeugte
Objekte. Mit BOBs können wir die gleichen Dinge tun, die wir auch mit
Hardware-Sprites machen können. BOBs sind langsamer als Sprites, weil der
Blitter einige Zeit braucht, um Daten zu kopieren. Auf der anderen Seite leiden
die BOBS nicht unter den Beschränkungen von Sprites hinsichtlich Größe, Farben
und maximaler Anzahl.
In der Tat kann ein BOB so groß sein, wie wir wollen (es ist jedoch
offensichtlich, dass mit zunehmender Größe auch der belegte Speicherplatz und
damit die Zeit, die der Blitter benötigt, um es zu bewegen), und es kann die
gleiche Anzahl von Farben haben wie der Bildschirm. 
Es gibt auch keine Begrenzung für die Anzahl der Bobs, die gleichzeitig auf
dem Bildschirm sind. (je mehr Bobs auf dem Bildschirm sind, desto mehr Zeit
verlieren wir natürlich, um sie zu zeichnen):
"Wie schön", sagen sie, "wir können anfangen, ein Spiel zu machen!". Einen
Moment noch, lassen sie uns nicht zu aufgeregt sein. Sind wir wirklich sicher,
dass wir mit BOBs dasselbe tun können die wir mit Sprites machen können?

Schauen wir uns Listing9i2.s und seinen "Zwilling" im Interleaved-Format 
Listing9i2r.s an.

Wir haben einen farbigen BOB, den wir frei mit der Maus auf dem Bildschirm
bewegen. Aber es gibt ein Problem ... wenn wir das BOB bewegen, löschen wir
den Hintergrund! Das passiert bei Sprites nicht, denn die Sprites sind
kleine Bitplanes, die von den Hintergrund-Bitplanes getrennt sind.
Die BOBs hingegen werden direkt auf die Bitebenen des Hintergrundbildes
gezeichnet, so dass sie diese teilweise überschreiben.

Eine erste Lösung des Problems zeigen wir in den Beispielen Listing9i3.s und 
Listing9i3r.s (das zweite Beispiel ist natürlich die RAW-BLIT-Version des
ersten Beispiels). Wie Sie sehen werden, ist es jedoch noch nicht befriedigend.

Im Beispiel Listing9i4.s versuchen wir eine andere Lösung, aber auch hier gibt
es Probleme.

Im Beispiel Listing9i5.s sehen wir stattdessen ein Beispiel für einen Bob, der
mit dem Joystick bewegt wird, der den Bildschirm teilweise verlässt.

Wir haben begonnen, BOBs kennenzulernen, aber bis jetzt haben wir noch kein
zufriedenstellendes Ergebnis erzielt, so dass wir die typischen
Videospieloperationen mit BOBs durchführen können, aufgrund des
Hintergrundproblems. Leider können wir mit dem, was wir bisher wissen es nicht
besser machen.

Aber keine Sorge: Es gibt noch viele Dinge über den Blitter zu lernen, und 
eines davon wird uns helfen, das Problem zu lösen!
Kraft und Mut also, der Weg ist noch lang!

			 .
			  )                       \\\..
			(                       __/ __ \
			 )                      (.__.)  O
			(  n_______n            /(__,    \
			  |________ }__________/ ____,    )__
			       ((O) \\.       (__________/   \
			        =(_O) |          /(    )\     \
			          (_O)|_______   \_\  /_/  \   )
			                      \    \)(/     | /
			                       )   /. \     |/
			                       |  / .  \    |
			                       | (__.___)   |
			                       |_|==()==|___|
			                        |   _      |
			                        |   |      |
			                        |   |      |


*******************************************************************************
*			KOPIEREN VON ÜBERLAPPENDEN SPEICHERBEREICHEN 					  *
*******************************************************************************

Wir werden nun eine weitere Funktion des Blitters veranschaulichen, das von der
Kopie von Rechtecken, eine Operation, die wir inzwischen gut kennen.
Was passiert, wenn die Quelle und das Ziel des Blitters übereinander liegen,
d.h. 2 Wortrechtecke gemeinsame Teile haben? Es ist offensichtlich, dass der
Blitt das gesamte Ziel verändert, einschließlich der Teile, die mit der Quelle
gemeinsam sind. Das Kopieren zwischen überlappenden Bereichen besteht also
darin, den Inhalt der Quelle VOR dem Kopieren in das Ziel zu übertragen.
Nach dem Kopieren wird der Inhalt der Quelle geändert.
Daher wird das Ziel nach dem Kopieren NICHT mit der Quelle identisch sein!
Vielmehr wird es, wir wiederholen es, dasselbe sein, was die Quelle vor dem
Kopieren war! Kurz gesagt, stellen Sie sich vor, dass das Ziel ein an der
Quelle aufgenommenes Foto ist, und dass während der Zeit, die der Fotograf für
die Entwicklung des Fotos benötigt, die Quelle schnell gealtert ist, so dass
sie ganz anders aussieht als auf dem Foto.
Wird unter solchen Bedingungen immer eine Kopie gemacht?
Wir müssen das Problem genau untersuchen.
Schauen wir uns das Beispiel einer Kopie eines Rechtecks mit 2 Zeilen Höhe 
und 3 Wörtern Breite an. Angenommen, die Quelle liegt tiefer als das Ziel, wie
in der folgenden Abbildung:

		 ____ ____ ____ ____ ____ ____
		|    |\\\\|\\\\|\\\\|    |    |
		|    |\\\\|\\\\|\\\\|    |    |
		|____|\\\\|\\\\|\\\\|____|____|		Rechteck Quelle=////
		|    |\\\\|XXXX|XXXX|////|    |
		|    |\\\\|XXXX|XXXX|////|    |		Rechteck Ziel=\\\\
		|____|\\\\|XXXX|XXXX|////|____|
		|    |    |////|////|////|    |		Rechteck gemeinsam=XXXX
		|    |    |////|////|////|    |
		|____|____|////|////|////|____|
		|    |    |    |    |    |    |
		|    |    |    |    |    |    |
		|____|____|____|____|____|____|


		Abb. 20	 Blitt zwischen überlappenden Rechtecken

Analysieren wir mit Hilfe einer Reihe von Abbildungen die folgenden Phasen der 
Operation. Wir geben mit den Buchstaben A, B, C, D, E, F den Inhalt der 
6 Wörter an, die wir kopieren wollen, und mit dem Symbol "?" den Inhalt der
Wörter die uns nicht interessieren, und die wir daher auch löschen können.
Bevor wir mit dem Kopieren beginnen, haben wir diese Situation:

		 ____ ____ ____ ____ ____ ____
		|    |\\\\|\\\\|\\\\|    |    |
		|    |  ? |  ? |  ? |    |    |
		|____|\\\\|\\\\|\\\\|____|____|		Rechteck Quelle=////
		|    |\\\\|XXXX|XXXX|////|    |
		|    |  ? |  A |  B |  C |    |		Rechteck Ziel=\\\\
		|____|\\\\|XXXX|XXXX|////|____|
		|    |    |////|////|////|    |		Rechteck gemeinsam=XXXX
		|    |    |  D |  E |  F |    |
		|____|____|////|////|////|____|


		Abb. 21a Blitt zwischen überlappenden Rechtecken

Wie wir wissen, kopiert der Blitter die Wörter eines nach dem anderen,
beginnend mit dem oberen links und weiter nach unten und nach rechts. Die erste
Zeile wird gelesen und in einen Bereich des Ziels kopiert, der nicht gemeinsam
ist und den wir daher leicht überschreiben können. 
Hier ist die Situation nach dem Kopieren der ersten Zeile:

		 ____ ____ ____ ____ ____ ____
		|    |\\\\|\\\\|\\\\|    |    |
		|    |  A |  B |  C |    |    |
		|____|\\\\|\\\\|\\\\|____|____|		Rechteck Quelle=////
		|    |\\\\|XXXX|XXXX|////|    |
		|    |  ? |  A |  B |  C |    |		Rechteck Ziel=\\\\
		|____|\\\\|XXXX|XXXX|////|____|
		|    |    |////|////|////|    |		Rechteck gemeinsam=XXXX
		|    |    |  D |  E |  F |    |
		|____|____|////|////|////|____|


		Abb. 21b Blitt zwischen überlappenden Rechtecken

An dieser Stelle müssen wir die zweite Zeile kopieren. Die zweite Zeile des 
Ziels überschneidet sich mit der ersten Zeile der Quelle. Das bedeutet, wenn
wir die Daten in das Ziel schreiben, überschreiben wir einen Teil der Quelle, 
dessen Inhalt zerstört wird. Beachten Sie jedoch, dass die überschriebenen
Daten zur ERSTEN Zeile der Quelle gehören, die wir bereits kopiert haben, und
daher brauchen wir sie nicht mehr. Daher gibt es keine Probleme.
Die Situation nach dem Kopieren der zweiten (und letzten) Zeile ist die
folgende:

		 ____ ____ ____ ____ ____ ____
		|    |\\\\|\\\\|\\\\|    |    |
		|    |  A |  B |  C |    |    |
		|____|\\\\|\\\\|\\\\|____|____|		Rechteck Quelle=////
		|    |\\\\|XXXX|XXXX|////|    |
		|    |  D |  E |  F |  C |    |		Rechteck Ziel=\\\\
		|____|\\\\|XXXX|XXXX|////|____|
		|    |    |////|////|////|    |		Rechteck gemeinsam=XXXX
		|    |    |  D |  E |  F |    |
		|____|____|////|////|////|____|


		Abb. 21c Blitt zwischen überlappenden Rechtecken

Wir haben genau das bekommen, was wir wollten, denn das Zielrechteck ist jetzt
die exakte Kopie des Inhalts des Quellrechtecks, BEVOR wir den Blitt gestartet
haben. Beachten Sie, dass sich der Inhalt der Quelle allerdings geändert hat,
aber das war unvermeidlich.

Im Beispiel Listing9l1.s können Sie alles in der Praxis sehen.

Es scheint also, dass die Überschneidung zwischen Quelle und Ziel keine
Probleme verursacht. Versuchen wir jedoch, den Fall zu untersuchen, in dem das 
Ziel niedriger ist als die Quelle:

		 ____ ____ ____ ____ ____ ____
		|    |////|////|////|    |    |
		|    |////|////|////|    |    |
		|____|////|////|////|____|____|		Rechteck Quelle=////
		|    |////|XXXX|XXXX|\\\\|    |
		|    |////|XXXX|XXXX|\\\\|    |		Rechteck Ziel=\\\\
		|____|////|XXXX|XXXX|\\\\|____|
		|    |    |\\\\|\\\\|\\\\|    |		Rechteck gemeinsam=XXXX
		|    |    |\\\\|\\\\|\\\\|    |
		|____|____|\\\\|\\\\|\\\\|____|
		|    |    |    |    |    |    |
		|    |    |    |    |    |    |
		|____|____|____|____|____|____|


		Abb. 22	 Blitt zwischen überlappenden Rechtecken

Vor dem Blitt ist die Situation wie folgt:

		 ____ ____ ____ ____ ____ ____
		|    |////|////|////|    |    |
		|    |  A |  B |  C |    |    |
		|____|////|////|////|____|____|		Rechteck Quelle=////
		|    |////|XXXX|XXXX|\\\\|    |
		|    |  D |  E |  F |  ? |    |		Rechteck Ziel=\\\\
		|____|////|XXXX|XXXX|\\\\|____|
		|    |    |\\\\|\\\\|\\\\|    |		Rechteck gemeinsam=XXXX
		|    |    |  ? |  ? |  ? |    |
		|____|____|\\\\|\\\\|\\\\|____|

		Abb. 23a Blitt zwischen überlappenden Rechtecken

Beginnen wir mit dem Kopieren der ersten Zeile. Die erste Zeile des Ziels ist 
teilweise überlappt mit der zweiten Zeile der Quelle, die noch nicht kopiert 
wurde. Das Ergebnis sieht so aus:

		 ____ ____ ____ ____ ____ ____
		|    |////|////|////|    |    |
		|    |  A |  B |  C |    |    |
		|____|////|////|////|____|____|		Rechteck Quelle=////
		|    |////|XXXX|XXXX|\\\\|    |
		|    |  D |  A |  B |  C |    |		Rechteck Ziel=\\\\
		|____|////|XXXX|XXXX|\\\\|____|
		|    |    |\\\\|\\\\|\\\\|    |		Rechteck gemeinsam=XXXX
		|    |    |  ? |  ? |  ? |    |
		|____|____|\\\\|\\\\|\\\\|____|

		Abb. 23b Blitt zwischen überlappenden Rechtecken

Wie Sie sehen können, haben wir die Werte E und F verloren! Es scheint, dass
dieses Mal die Kopie fehlschlagen wird! Wir kopieren jedoch auch die zweite
Zeile und sehen, was passiert.

		 ____ ____ ____ ____ ____ ____
		|    |////|////|////|    |    |
		|    |  A |  B |  C |    |    |
		|____|////|////|////|____|____|		Rechteck Quelle=////
		|    |////|XXXX|XXXX|\\\\|    |
		|    |  D |  A |  B |  C |    |		Rechteck Ziel=\\\\
		|____|////|XXXX|XXXX|\\\\|____|
		|    |    |\\\\|\\\\|\\\\|    |		Rechteck gemeinsam=XXXX
		|    |    |  D |  A |  B |    |
		|____|____|\\\\|\\\\|\\\\|____|


		Abb. 23c Blitt zwischen überlappenden Rechtecken

Erledigt. Der Blitt ist vorbei, aber das Ergebnis ist nicht das, was wir
wollten. Sind Sie überzeugt?

Nein? Dann schauen Sie sich das Beispiel Listig9l2.s an und überzeugen Sie sich
selbst davon!

Wir versuchen zu verstehen, warum es das erste Mal funktioniert hat und dieses
Mal nicht. Das Problem entsteht, wenn wir auf Teile des Ziels schreiben die mit
der Quelle überlappt sind, weil wir in diesem Fall einige Daten überschreiben.
Im ersten Fall gab es keine Probleme, da wir die Daten die dort überschrieben
wurden schon kopiert hatten.
Dies geschah, weil die Quelle niedriger ist (bei höheren Adressen) als das
Ziel, und die Überschneidung tritt zwischen der ersten Zeile der Quelle und 
der zweiten Zeile des Ziels auf.
Da der Blitter von der ersten Zeile an kopiert, werden die Daten der ersten 
Zeile der Quelle kopiert, BEVOR sie von der zweiten Zeile des Ziels
überschrieben werden. 
Im zweiten Fall ist die Quelle jedoch höher gelegen (bei niedrigeren 
Adressen) als das Ziel, und die Überlappung tritt zwischen der zweiten 
Zeile der Quelle und der ersten Zeile des Ziels auf.
Die Daten der zweiten Zeile der Quelle werden daher überschrieben, während der
Kopie der ersten Zeile, d.h. BEVOR sie der Reihe nach kopiert werden, deshalb
gehen sie verloren.
Um dieses Problem zu lösen, sollten Sie zuerst die zweite Zeile kopieren und
dann die erste Zeile. Dies ist mit dem DESCENDING MODE des Blitters möglich.
Wenn Sie diesen Modus verwenden, kopiert der Blitter (oder jede andere
Operation) in umgekehrter Richtung als normalerweise, d.h. er beginnt mit
dem rechten unteren Wort des Rechtecks und fährt nach links und oben fort.
Die Wörter, die auf diesem Weg durchlaufen werden, haben eine Adresse, die
allmählich abnimmt. Man sagt daher, dass der Blitter entlang des Speichers
ABSTEIGT, daher der Name des Funktionsmodus (im Gegensatz dazu wird der
normale Modus auch als ASCENDING MODE genannt, da normalerweise Wörter mit
allmählich ansteigenden Adressen geblittet werden).
Bevor wir im Detail untersuchen, wie man den Blitter im DESCENDING MODE
verwendet, lassen Sie uns zu dem Problem des Kopierens überlappender Regionen
zurückkehren und überprüfen, ob der absteigende Modus (descending mode) die
richtige Lösung ist.
Die Ausgangssituation ist wie folgt:

		 ____ ____ ____ ____ ____ ____
		|    |////|////|////|    |    |
		|    |  A |  B |  C |    |    |
		|____|////|////|////|____|____|		Rechteck Quelle=////
		|    |////|XXXX|XXXX|\\\\|    |
		|    |  D |  E |  F |  ? |    |		Rechteck Ziel=\\\\
		|____|////|XXXX|XXXX|\\\\|____|
		|    |    |\\\\|\\\\|\\\\|    |		Rechteck gemeinsam=XXXX
		|    |    |  ? |  ? |  ? |    |
		|____|____|\\\\|\\\\|\\\\|____|

		Abb. 24a Blitt zwischen überlappenden Rechtecken

Diesmal benutzen wir den absteigenden Weg, also fangen wir mit dem Kopieren von
der letzten Zeile an. Auf diese Weise schreiben wir von Beginn nicht auf den 
übereinanderliegenden Teil:

		 ____ ____ ____ ____ ____ ____
		|    |////|////|////|    |    |
		|    |  A |  B |  C |    |    |
		|____|////|////|////|____|____|		Rechteck Quelle=////
		|    |////|XXXX|XXXX|\\\\|    |
		|    |  D |  E |  F |  ? |    |		Rechteck Ziel=\\\\
		|____|////|XXXX|XXXX|\\\\|____|
		|    |    |\\\\|\\\\|\\\\|    |		Rechteck gemeinsam=XXXX
		|    |    |  D |  E |  F |    |
		|____|____|\\\\|\\\\|\\\\|____|

		Abb. 24b Blittata zwischen überlappenden Rechtecken 

Jetzt kopieren wir die erste Zeile. Dabei überschreiben wir die zweite Zeile
des Quelle, aber da wir sie bereits kopiert haben, ist das kein Problem:

		 ____ ____ ____ ____ ____ ____
		|    |////|////|////|    |    |
		|    |  A |  B |  C |    |    |
		|____|////|////|////|____|____|		Rechteck Quelle=////
		|    |////|XXXX|XXXX|\\\\|    |
		|    |  D |  A |  B |  C |    |		Rechteck Ziel=\\\\
		|____|////|XXXX|XXXX|\\\\|____|
		|    |    |\\\\|\\\\|\\\\|    |		Rechteck gemeinsam=XXXX
		|    |    |  D |  E |  F |    |
		|____|____|\\\\|\\\\|\\\\|____|

		Abb. 24c Blittata zwischen überlappenden Rechtecken

OK! Diesmal sind wir am Ziel. Das Ziel sieht jetzt genauso aus wie die Quelle 
vor dem Blitt. Abschließend können wir also sagen, dass bei einer Kopie mit
überlappender Quelle und Ziel, wenn die Quelle an einer höheren Speicheradresse
liegt als das Ziel, muss sie auf normale Weise (ASCENDING) geblittet werden,
wenn die Quelle an einer niedrigeren Adresse im Speicher liegt, muss der Modus
DESCENDING verwendet werden.

		               __________
		              /          \
		             |_________ _ |
		             / _______ \| |
		            | /  o_o  \ | |
		             \|  ___  |/\_|
		         _____|\/ = \/|_(_)__
		        /     |       |      \
		       /      |       |       \
		      /  _.    \_____/    __  _\_____
		  ___/__ |        o        | _\_     \____
		 /   \_ \|        o        |/ __\__|     /
		|     |) |\_______________/|\(__/  \_/__/__
		O==o==O_/|     ||__||      | / ____        \_
		| `-' |   \____||__||_____/ /   / _    ___   \
		| sk8 |    \             / (   / (_)\/ \      |
		| .-. |     |_____Y_____|   \       / \/     /
		O==o==O   __|     |    _|_   |           '   )
		|     |  / ``     |    '' \  (              /
		 \___/  (_________|________)  \_____________)


An dieser Stelle können wir auf die Details des absteigenden Modus eingehen.
Zunächst muss der absteigende Modus über ein Steuerbit aktiviert werden. Dies
ist Bit 1 des BLTCON1-Registers, das, wenn es auf 1 gesetzt wird, den 
absteigenden Modus (Descending-Modus) aktiviert, während es, wenn es
zurückgesetzt wird (wie wir es bisher getan haben), den aufsteigenden Modus
(Ascending-Modus) aktiviert.
Wie wir bereits gesagt haben, geht der Blitter im absteigenden Modus
"rückwärts", d.h. er bewegt sich zwischen Speicherplätzen mit immer
niedrigeren Adressen. Dazu ist es notwendig, dass die Zeiger der DMA-Kanäle
des Blitters auf das Wort des Blitters zeigen, das die höchste Adresse hat, 
d.h. auf das erste Wort, das geblittet wird.
Dies ist, wie Sie wissen, das unterste und äußerste rechte Wort des
Wortrechtecks das geblittet werden soll.
Wenn Sie zum Beispiel ein Rechteck mit 3 Wörtern Breite und 2 Zeilen Höhe
schreiben wollen, müssen Sie die Zeiger mit der Adresse des dritten Wortes 
der zweiten Zeile des Rechtecks initialisieren, das in der Abbildung mit 
zwei Sternchen (**) angegeben ist.

		 ____ ____ ____ ____ _ _ _ _ _ _ ____
		|    |    |    |    |			|    |
		|    |    |    |    |	        |    |
		|____|____|____|____|			|____|
		|    |\\\\|\\\\|\\\\|			|    |
		|    |\\\\|\\\\|\\\\|			|    |
		|____|\\\\|\\\\|\\\\|			|____|
		|    |\\\\|\\\\|\\\\|			|    |
		|    |\\\\|\\\\| ** |			|    |
		|____|\\\\|\\\\|\\\\|			|____|
		|    |    |    |    |			|    |
		|    |    |    |    |	        |    |
		|____|____|____|____|			|____|
		|									 |
		|									 |

		Abb. 25 Word-Rechteck mit hervorgehobenem Wort
				welches auf den Anfang des Blitts zeigt 

Um die Adresse dieses Wortes zu berechnen, folgen wir einem ähnlichen Ansatz
wie im aufsteigenden Fall. Wir müssen den Abstand (Offset) dieses Wortes vom
Anfang der Bitebene berechnen. Angenommen, wir kennen die Koordinaten Xa und Ya 
des linken oberen Pixels des Rechtecks, sowie die Breite in Wörter L und die
Höhe A des Rechtecks. Das Wort, an dem wir interessiert sind gehört zur
letzten Zeile des Rechtecks und hat die Koordinate Yb = Ya + A. Der Offset des
ersten Wortes dieser Zeile wird durch die folgende Formel bestimmt:

OFFSET_Y = 2 * (Yb * ANZAHL_WORDS_PRO_ZEILE) im Normalfall und

OFFSET_Y = 2 * (Yb * ANZAHL_WORDS_PRO_ZEILE * BITPLANES) im interleaved Fall.

Nun müssen wir den Abstand zwischen dem ersten Wort der Zeile und dem letzten
Wort des Rechtecks berechnen. Wie wir wissen, ist dieser Abstand gegeben durch
2 * (Xa/16). Andererseits gibt es zwischen dem ersten und dem letzten Wort des
Rechtecks L-1 Wörter, was einem Abstand (ausgedrückt in Bytes) von 2*(L-1)
entspricht. Addiert man die 2 Abstände, erhält man:

Offset_x = 2*(Xa/16 + L-1).


	|    |				|    |\\\\|\\\\|	|\\\\|
	|  A |				|    |  B |\\\\|	|  C |
	|____|_ _			|____|\\\\|\\\\|_ _	|\\\\|

	\____________________/\______________________/
		|			|
	    Xa/16 words		   L words

	Abstand zwischen Wort A und Wort B = 2*(Xa/16)
	Abstand zwischen Wort B und Wort C = 2*(L-1)

		Abb. 26 Berechnung OFFSET_X
	
Die Adresse, die in die Zeiger der DMA-Kanäle zu schreiben ist, ist also
gegeben durch:

ADDRESS_WORD = ADDRESS_BITPLANE + OFFSET_Y + OFFSET_X.

Was die Modulo und die Größe des Blitts betrifft, so gibt es keine Unterschiede 
im Vergleich zum ascending mode, sie werden alle mit den gleichen Formeln
berechnet. Jetzt können wir endlich 2 sich überlappende rechteckige Bereiche
korrekt kopieren auch wenn die Quelle an einer niedrigeren Speicheradresse
als das des Ziels beginnt: dies ist das Beispiel Listing9l3.s.

Im absteigenden Modus verhalten sich die Masken und der Shift anders als im 
aufsteigenden Modus. Die Masken funktionieren immer auf die gleiche Weise, aber
die Wörter, auf die sie angewendet werden, ändern sich. Die in BLTAFWM
enthaltene Maske wird, wie im aufsteigenden Fall, auf das ersten Wort jeder
Zeile angewendet. Da wir jedoch im absteigenden Modus in umgekehrter
Reihenfolge blitten, ist das erste Wort das ganz rechte Wort des Rechtecks,
während es im aufsteigenden Modus das ganz linke Wort ist.

Ebenso wird die in BLTALWM enthaltene Maske immer auf das zuletzt geblittete 
Wort jeder Zeile angewendet, nur dass dieses Wort in absteigender Modus das
Wort ganz links ist. Zusammengefasst:

- Im aufsteigenden (normalen) Modus gilt BLTAFWM für das Wort ganz links und
  BLTALWM auf das äußerste rechte Wort.

- Im absteigenden Modus gilt BLTAFWM für das Wort ganz rechts und BLTALWM für
  das Wort Wort ganz links.

Wenn wir uns das Bild so ansehen, wie es auf dem Video erscheint, und in den
absteigenden Modus wechseln, tauschen die Masken die Spalten, auf die sie
wirken. Um dies zu überprüfen, laden Sie und führen Sie das Beispiel
Listing9m1.s aus, das genau dasselbe tut wie Listing9h1.s, nur dass es in
absteigender Reihenfolge arbeitet. Sie werden sehen, dass die Masken die
gleiche Wirkung haben, aber die Spalten vertauscht sind.

Die Verschiebung in absteigender Reihenfolge weist einen grundlegenden
Unterschied auf: Sie erfolgt nach LINKS und nicht nach rechts. Wenn wir einen
Verschiebungswert angeben, der zum Beispiel 2 ist, wird die Quelle um 2 Pixel
nach LINKS verschoben. Mit dieser Funktion können wir den Effekt erzielen, dass
ein Bild nach links verschoben wird.

Sie finden es im Beispiel Listing9m2.s.

An diesem Punkt können wir endlich einen der klassischsten Effekte der Demos
erzeugen: den SCROLLTEXT, einen Text, der von rechts nach links über den
Bildschirm scrollt.

Ein einfaches, aber wichtiges Beispiel ist Listing9n1.s, in der Sie alle 
Erklärungen finden. Ich empfehle Ihnen, dieses Beispiel mit besonderer
Aufmerksamkeit zu studieren, denn zu wissen, wie man einen Scrolltext erstellt,
ist absolut essentiel für einen Demo-Coder!

Im Beispiel Listing9n2.s finden Sie den Scrolltext des Intros von Diskette 1.


	                                      .-%%%-,
	                                     (       )
	                                   (         )
	              -~x~-               (          )
	            /%     %\           (           )
	           |         |         (           )
	           |         |        (           )
	           |     __ _,       (%%%%-(     )
	          /\/\  (. ).)       `_'_', (   )
	           C       __)       (.( .)-(  )
	           |   /%%%  \      (_      ( )
	           /   \ %===='    /_____/` D)
	         /`-_   `---'         \     |
	    .__|%-/~\-%|_/_   |~~~~~~~||    |
	   __.         ||/.\  |       |OooooO
	   \           ---. \ |       |      \ _
	  _-    ,`_'_'  .%\  \|__   __|-____  / )
	 <     -(. ).)   > \  ( .\ (. )     \(_/ )
	  %-       _) \_- ooo @  (_)  @      \(_//.
	 / /_C (-.____)  /((O)/       \     ._/\%_.
	/   |_\     /   / /\\\\`-----''    _|>o<  |__
	|     \ooooO   (  \ \\ \\___/     \ `_'_',  /
	 \     \__-|    \  `)\\-~\\ ~--.  /_(.(.)- _\
	  \   \ )  |-`--.`--=\-\ /-//_  '  ( c     D\
	   \_\_)   |-___/   / \ V /.% \/\\\ (@)___/ %|
	  /        |       /   | |.  /`\\_/\/   /   /
	 /         |      (   C`-'` /  |  \/   (/  /
	/_________-        \  `C__-%   |  /    (/ /
	     | | |          \__________|  \     (/

Haben Sie verstanden, wie der Scrolltext funktioniert? Wenn die Antwort ja
lautet, können Sie mit dem, was Sie gelernt haben, zufrieden sein. Inzwischen
kennen Sie die grundlegende Funktionsweise des Blitters. In der nächsten
Lektion werden wir die verborgensten Geheimnisse dieses mächtigen Freundes
entdecken, beginnenend mit dem größten, dem am schwersten zu verstehenden, mit
dem wir uns in dieser Lektion beschäftigen werden, es bisher aber immer
vermieden haben: der Funktionsweise der MINTERMS!