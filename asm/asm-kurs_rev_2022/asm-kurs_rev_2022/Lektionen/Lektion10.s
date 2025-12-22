                           .      :  .
                           ¦.:.:.:..::.::.¦
                           |::··    _____:!
                           |  _____  ____ |
                          _!  '____ |    ||
                         / __ |    ||    ||
                         \ /\ `--°-'`-°--'| xCz
    _ __ _________________)\ \____C¯  l___l___________________ __ _
                            ¯¯    `---'
				ASSEMBLERKURS - LEKTION 10
    - -- ----------------------------------------------------- -- -

In dieser Lektion lernen wir die Verwendung der erweiterten Funktionen des 
Blitters kennen.

*******************************************************************************
*				MINTERMS													  *
*******************************************************************************

In Lektion 9 haben wir gesagt, dass der Blitter uns erlaubt mit verschiedenen  
Arten von Operationen zu spielen. Wir haben auch gesagt, dass die Art der 	   
Operation definiert wird durch die MINTERMS, welche die Bits 0 bis 7 des 	   
BLTCON0-Registers sind, d.h. das Low-Byte (genannt LF - Logic Function Byte)   
dieses Registers. Je nach dem Wert, der in diese Bits geschrieben wird, 	   
ändert sich die vom Blitter ausgeführte Operation.
Zum Beispiel wissen wir, dass zum Löschen des Speichers das LF-Byte auf den    
Wert $00 gesetzt sein muss, während wenn von Kanal A nach Kanal D kopiert 	   
werden soll es den Wert $f0 haben muss. Diese Werte wurden nicht zufällig von  
den Entwicklern des Blitters gewählt, sondern sie folgen einer sehr genauen
Logik, die wir jetzt erklären werden.
Zunächst weisen wir darauf hin, dass die Operationen, die vom Blitter
ausgeführt werden können, LOGISCHE Operationen sind, d.h. NICHT, UND und ODER,
die Sie inzwischen gut kennen sollten. (In Wirklichkeit gibt es auch solche,
die arithmetische Operationen durchführen können, aber darüber werden wir
vielleicht auf der nächsten Diskette reden!)	   
Der Blitter kann auch mehrere solcher Operationen diesen Typs in einem einzigen	   
Blitt kombinieren. Aber lassen Sie uns der Reihe nach gehen.
Wie Sie wissen, hat der Blitter 3 Eingangskanäle und einen Ausgangskanal. Für  
den Moment wollen wir uns nicht mit dem Aktivieren oder Deaktivieren von
Kanälen beschäftigen. Ein Blitt ist eine logische Operation, die
3 Eingangswerte über die 3 Kanäle A, B, C einliest und ein Ergebnis über den
Kanal D erzeugt. Wie bei allen logischen Operationen wird dies Bit für Bit
ausgeführt, auch wenn der Blitter immer Wörter liest (und schreibt), genau wie
der 68000er mit einer logischen AND-Anweisung.
Daher wird jedes Bit des Ausgabewortes basierend auf den Werten der 		   
korrespondierenden Bits der Eingabewörter berechnet. Die 3 Bits in der Eingabe 
können 8 verschiedene Kombinationen führen. Eine Blitter-Operation wird		   
definiert, indem für jede möglichen Kombination der Eingangsbits festgestellt
wird ob das Ausgangsergebnis 0 oder 1 ist.		   
In der Praxis kommt jeder der 8 Minterms (Bits 0 bis 7 von BLTCON0) in		   
Verbindung mit einer anderen Kombination von Eingangsbits; Wenn der Minterm    
den Wert 0 hat, bedeutet es, dass die Eingangskombination 0 ergibt, falls 	   
es stattdessen den Wert 1 hat, wird das Ergebnis eine 1 sein.
Dies kann mit einer Wahrheitstabelle angezeigt werden, wie unten gezeigt.	   
Die drei Quellkanäle sind aufgelistet und die möglichen Werte für ein einzelnes
Bit von jedem. Als nächstes folgt das Bit, das jeder Kombination zugeordnet    
ist.

	A	B	C	 	Position BLTCON0
	-	-	-	    -----------------
						
	0	0	0			0
						
	0	0	1			1
						
	0	1	0			2
						
	0	1	1		 	3
						
	1	0	0			4
						
	1	0	1			5
						
	1	1	0			6

	1	1	1			7

		Fig. 27	MINTERMS
		
Zum Beispiel, wenn wir möchten, dass ein Blitt eine Ausgabe von 1 erzeugt, wenn
am Eingang A=0, B=1 und C=0 ist und in allen anderen Fällen gleich 0, müssen
wir den Minterm 2 auf 1 und all die anderen Minterms auf Null setzen. Wir 
schreiben also den Wert $04 in das LF-Byte. Für ein anderes Beispiel wird  
der Wert $80 (= 1000.0000 binär) in die LF Bits geschrieben, wenn das Ziel auf
1 gesetzt werden soll, wenn die entsprechenden Bits der Quellen A, B und C alle
auf 1 gesetzt sind. Alle anderen Bits des Ziels, mit denen die andere
Kombinationen für A, B und C übereinstimmen werden auf Null gesetzt. Dies liegt
daran, da die Bits 6 bis 0  des LF-Bytes den Wert 0 annehmen. Natürlich ist es
möglich, mehr als einen Minterm gleichzeitig auf 1 zu setzen. Zum Beispiel,
wenn wir LF auf $42 setzen (= 0100.0010 in binär) schalten wir 2 Minterms ein.
Mit diesem Wert werden wir eine Ausgabe von 1 in 2 Fällen haben: im Fall  
A=0, B=0 und C=1 (entspricht Bit 1 von LF) und im Fall A=1, B=1 und C=0		   
(entspricht Bit 6 von LF). In den anderen Fällen haben wir eine Ausgabe von 0.
Versuchen wir nun, die Bedeutung der Werte unserer Minterme zu verstehen, die
wir zum Löschen und Kopieren verwendet haben. Im Falle des Löschens haben ist    
LF = $00. Alle Minterms haben den Wert 0. Das bedeutet, dass für jede
Kombination der Quellkanäle immer eine 0 ausgegeben wird.
In der Praxis schreiben wir immer, egal was wir lesen, immer eine 0, d.h. wir
löschen. (Tatsächlich lesen wir während der Löschung nichts, weil wir die
Kanäle A, B und C nicht aktivieren, aber wir müssen immer noch LF = $00
eintragen, warum erklären wir später). Um (sagen wir mal) eine Kopie von A nach
D zu machen, schreiben wir LF = $F0 (=% 1111.0000). 
Auf diese Weise ist die Ausgabe in entsprechend 4 verschiedene Kombinationen 1,
während in den restlichen 4 Kombinationen der Wert 0 ist.
Wie Sie in der Abb. 27 sehen können, werden die Kombinationen, die den Minterms 
entsprechen auf 1 gesetzt. Das sind alle möglichen Kombinationen mit A = 1. In 
gleicher Weise werden die Kombinationen, die den Minterms nicht entsprechen    
auf 0 gesetzt. Es sind diejenigen mit A = 0.
Das bedeutet, dass jedes Mal, wenn A=1 ist, der Ausgang 1 ist und wenn statt- 
dessen A=0 ist, ist die Ausgabe 0, unabhängig von dem Wert von B und von C. 
In der Praxis nimmt also der Ausgang den gleichen Wert wie der Kanal A an, und 
daher ist es die exakte Kopie davon. Wenn wir stattdessen von Kanal B zu
Kanal D kopieren wollten, müssen wir einen anderen LF-Wert verwenden und die
Minterms auf 1 setzen bei den die Kombinationen mit B = 1 sind. (Das sind, wie
wir in Abb. 27 sehen, die Minterme 2, 3, 6 und 7). Die anderen Minterms
0, 1, 4 und 5 sind gelöscht und Sie erhalten LF = $CC (=%11001100).
Durch die entsprechende Programmierung der Minterms können viele Operationen
mit dem Blitter ausgeführt werden. Angenommen, Sie möchten alle Pixel in einem     
Rechteck auf 1 setzen (in der Praxis die umgekehrte Operation der Löschung, die
stattdessen alle Bits auf 0 setzt). Für die Löschung verwenden wir nur den 
Ausgabekanal. Was wir wollen ist, dass die Ausgabe immer 1 ist, unabhängig von
der Kombination der Eingänge. Um dieses Ergebnis zu erhalten, setzen wir alle
Minterms auf 1 und erhalten LF = $FF.

Sie können dies im Beispiel Listing10a1.s sehen.
Im Beispiel Listing10a2.s zeigen wir stattdessen die NOT-Operation.

Für die Erklärung verweise ich auf das Listing.

	     ______                                ______
	    (:::::\`~-.     ___   /|\   ___    .-~ /:::::)
	     `\:::::\  `\  __\\\\|||||////__ /'  /:::::/'
	       `\-::::\_ `\.\\\\\|||||////./' _/::::-/'
	         `--..__`\/    \\\\|////   \/ __..--'
	                >' .--. `\   /'.--. `<
	         _...--/ -<    |      |    >- \--..._
	    /    \         `\()|      |()/'         /    \
	  /||     `\|  ____. `          ' .____  |/'     ||\
	 /|||       | ' `\       /::\       /' ` |       |||\
	|||||\    .---. __|_.  /::::::\  ._|__ .---.    /|||||
	|||||||-._|_   `-._  /::::::::::\  _.-'   _|_.-|||||||
	 \|||||||||||      /::/' |::| `\::\      |||||||||||/
	  \||||||||||     /::/   |::|   \::\     ||||||||||/
	   `\||||||||\   (:::`---'::`---':::)   /||||||||/'
	        /     `-._`-.::::::::::::.-'_.-'     \
	       |              .________.              |
	       |                                      |
	       |                                      |
	       |                                      |
	        \                                    /
	        `\                                /'
	           `~-.________________________.-~'


Kommen wir nun zu einem Beispiel für eine 2-Operanden-Operation, zum Beispiel  
dem ODER. Wir wollen, dass der Ausgang dem OR der Kanäle A und B entspricht. Im
Rückblick auf die Wahrheitstabelle des OR verstehen wir, dass die Ausgabe den  
Wert 1 in allen Fällen annimmt, in denen A = 1 und in allen Fällen, in denen
B = 1 ist. Wie Sie aus Abb. 27 sehen, gibt es insgesamt 6 Fälle, bei denen die 
Bedingung gilt (bei LF = $FC).

Die Beispiel Listing10b1.s zeigt eine ODER-Operation, während das Beispiel
Listing10b2.s eine UND-Operation ausführt.

Eine andere Möglichkeit, das LF-Byte zu berechnen, das eine bestimmte Operation
ausführt, ist durch die Verwendung des Venn-Diagramms:


		     ______  0 ______
		    /	   \  /      \
		   /	    \/	      \
		  /	        /\	       \
		 /   A	   /  \     B	\
		|    -	  |    |    -	 |
		|	      |  6 |	     |
		|	 4    |____| 2	     |
		|	     /|    |\	     |
		|	    / |  7 | \	     |
		 \     /   \  /   \	    /
		  \   /  5  \/  3  \   /
		   \ |	    /\	    | /
		    \|_____/  \_____|/
		     |		        |
		     |	    1	    |
		     |		        |
		      \		       /
		       \     C	  /
		        \    -   /
		         \______/


		Fig. 28	Venn-Diagramm

Wir veranschaulichen die Verwendung dieses Diagramms anhand einiger Beispiele. 

1. Um eine Funktion D = A auszuwählen (d.h. Ziel = nur Quelle A),
   Wählen Sie nur die Minterms aus, die in der obigen Abbildung vollständig 
   im Kreis A enthalten sind. Dies ist die Reihe der Minterms 7, 6, 5 und 4.
   Wenn sie als eine Reihe mit 1 für die ausgewählten Minterms und 0 für die
   nicht ausgewählten Minterme schreiben, wird der Wert zu:
   
		Anzahl Minterm		7 6 5 4 3 2 1 0
		Minterm ausgewählt	1 1 1 1 0 0 0 0
							---------------
							F   0       nämlich $F0

2. Um eine Kombinationsfunktion aus zwei Quellen auszuwählen, suchen Sie nach  
   Mintermen von beiden Kreisen (deren Kreuzung). Zum Beispiel, die Kombination 
   A "UND" B wird durch den gemeinsamen Bereich der Kreise A und B dargestellt,
   d.h. Minterme 7 und 6.
   
		Anzahl Minterm		7 6 5 4 3 2 1 0
		Minterm ausgewählt	1 1 0 0 0 0 0 0
							---------------
							C   0       nämlich $C0
						
3. Um eine inverse Funktion zu verwenden, das "NOT" einer der Quellen, zB:     
   NICHT A
   nimmt man alle Minterme, die nicht in dem von A dargestellten Kreis
   enthalten sind. In diesem Fall haben wir Minterms 0, 1, 2 und 3.
   
		Anzahl Minterm		7 6 5 4 3 2 1 0
		Minterm ausgewählt	0 0 0 0 1 1 1 1
							---------------
							0   F       nämlich $0F
								
4. Um MINTERME zu kombinieren, d.h. ein ODER zwischen ihnen, machen Sie ein  
   ODER der Werte. Zum Beispiel wird die Operation (A UND B) ODER (B und C) zu
							
		Anzahl Minterme			7 6 5 4 3 2 1 0
		A AND B					1 1 0 0 0 0 0 0
		B AND C					1 0 0 0 1 0 0 0
								---------------
		(A AND B) OR (B AND C)	1 1 0 0 1 0 0 0
								---------------
								C   8       nämlich $C8

In jedem Fall, wenn Sie sich wirklich die Mühe ersparen wollen, finden sie
hier 
eine Tabelle mit den am häufigsten verwendeten Minterm-Werten.			
Diese Tabelle verwendet eine andere Notation als die bisher verwendete:

Wenn zwei Buchstaben nebeneinander stehen, wird ein AND zwischen ihnen gebildet
(z.B. bedeutet AB A und B);

Ein Bindestrich über einem Buchstaben zeigt das NOT an:
      _
(z.B. A bedeutet NICHT A);

Wenn zwei Buchstaben durch ein "+" getrennt sind, wird ein OR zwischen ihnen
gemacht (z.B. bedeutet A + B  bedeutet A oder B);

UND hat die höchste Priorität, also ist AB+BC gleich (A UND B) ODER (B UND C).
Hier ist die Tabelle:

	Operation	 Wert		Operation	 Wert
	ausgewählt	  LF		ausgewählt	  LF
	--------	-------		--------	-------
	D = A		 $F0		D = AB		 $C0
	    _					     _
	D = A		 $0F		D = AB		 $30
					            _
	D = B		 $CC		D = AB		 $0C
	    _				        __
	D = B		 $33		D = AB		 $03

	D = C		 $AA		D = BC		 $88
	    _				         _
	D = C		 $55		D = BC		 $44
					            _
	D = AC		 $A0	 	D = BC		 $22
	     _				        __
	D = AC		 $50		D = AC		 $11
	    _					         _
	D = AC		 $0A		D =  A + B	 $F3
	    _				         _	 _
	D = AC		 $05		D =  A + B	 $3F
					                 _
	D = A + B	 $FC		D =  A + C	 $F5
	    _				         _	 _
	D = A + B	 $CF		D =  A + C	 $5F
					                 _
	D = A + C	 $FA		D =  B + C	 $DD
	    _				         _	 _
	D = A + C	 $AF		D =  B + C	 $77
						               _
	D = B + C	 $EE		D =  AB + AC	 $CA
	    _
	D = B + C	 $BB
	
		Fig. 29	oft verwendete Minterme 

HINWEIS: Um den gewünschten Wert von LF für Ihre Zwecke zu finden, können Sie  
auch das Hilfsprogramm "minterm" verwenden, das von Deftronic programmiert
wurde, genau Trash'M'One. Das betreffende kurze Hilfsprogramm kann auf dieser
Diskette gefunden werden. Die Syntax ist folgende: Für das NOT, setzen Sie den
Buchstaben des Kanals nicht geshifted (in Kleinbuchstaben), zum Beispiel "abc".
Für den normalen Kanal wird der Shift-Buchstabe (Großbuchstabe) verwendet. Zwei
benachbarte Buchstaben bedeuten ein UND zwischen den Kanälen, wenn sie getrennt
sind bedeutet dies ein ODER ("+") zwischen den Kanälen.

					  __
Beispiel 1: wenn Sie ABC wollen:

	minterm	Abc

	Ergebnis: $10

Beispiel 2: wenn Sie nur die Quelle A möchten:

	minterm	A

	Ergebnis: $F0	(wie sie es beweisen wollten)

Beispiel 3: wenn Sie nur (A AND B) OR C wollen:

	minterm	AB+C

	Ergebnis: $DA.

	               ___________
	               \        _/___
	                \____________)
	                 |.  _  |
	                 |___/  |
	                 `------'
	                ./   _  \.
	             __ |___/ )  |
	            (__|_____/   |
	                |________|____.                  _ __ ____
	                   |  _)      |  - --- --- --- -(         )
	                   |  |----.  |        -- -    (  (  )     )
	                 __|  |    |__| _    - -- --      vrooom )  )
	             ___|_____|________/ | --- -- - ---( (    (    )
	            (____________________|              (____ _ __)
	             (_)              (_)

*******************************************************************************
*				DIE BOBS													  *
*******************************************************************************

Wir sind fast beim Hauptthema dieser Lektion angekommen, nämlich den BOBs.
Bevor wir uns mit ihnen befassen, ist es notwendig, eine andere Idee
vorzustellen: die Masken-Bitebene. Es handelt sich einfach um eine Bitebene,
die den "Schatten" eines Bildes darstellt, d.h. es ist eine Bitebene mit der
gleichen Dimensionen wie das Bild, bei der die Pixel, die einer Farbe des
Bildes entsprechen, die mit einer anderen Farbe als der des Hintergrunds 
gefärbt sind auf 1 setzt und die Pixel die der Hintergrundfarbe des Bildes
entsprechen auf 0 setzt.

Betrachten Sie zum Beispiel die folgende Zahlentabelle:


	0020
	0374
	5633
	0130

Sie stellt ein 8-farbiges Bild (3 Bitebenen) 4 Pixeln Breite und 4 Zeilen Höhe   
dar. Jede Zahl gibt die Farbe an, die dem Pixel zugeordnet ist. Die Maske 
diesen Bildes ist wie folgt:

	0010
	0111
	1111
	0110

Wir stellen fest, dass bei allen Farben außer 0 (dem Hintergrund) mindestens
eine Bitebene auf 1 gesetzt ist.
	
Daher kann die Maske ausgehend von dem Bild durch ein ODER-Verknüpfung aller
Bitebenen erstellt werden, so wie es in den Beispielen Listing10c1.s und
Listing10c2.s gezeigt wird. Das erlaubt Ihnen auch, die Verwendung der 	   
logischen Operationen des Blitters zu überprüfen. Insbesondere in 
Listing10c2.s zeigen wir zum ersten Mal ein Blitt, der alle 4 Kanäle des 
Blitters verwendet.

Der Kefrens Converter befügt jedoch über eine Option zur automatischen
Erstellung der Maske eines Bildes. Masken Bitebenen sind nützlich, weil sie
uns erlauben, Teile eines Bildes anzuzeigen, basierend auf der Form eines
anderen Bildes.   

In Listing10c3.s und Listing10c4.s sehen wir Beispiele, in denen wir eine
kreisförmige Maske verwenden, um einen Reflektor zu erzeugen, der ein Bild
beleuchtet um einen Teil davon sichtbar zu machen.

Die 2 Beispiele, erzielen zwar den gleichen Effekt, verwenden aber
unterschiedliche Techniken, wie in den Kommentaren erläutert. Studieren Sie die
Lektion gründlich, was für das Verständnis von BOBs unerlässlich ist.

In diesem Beispiel wird die Masken-Bitebene verwendet, um Teile eines Bildes
mit 5 Bitebenen "auszuwählen". Die Auswahl erfolgt durch eine UND-Operation
zwischen der Bitebenenmaske und den 5 Bitebenen macht, aus denen das Bild   
besteht. Da das Bild im normalen Format vorliegt, werden 5 verschiedene Blitts
durchgeführt, eine für jede Ebene. Die Maske ist natürlich bei jedem Blitt 
immer die gleich (sie besteht aus einer einzigen Bitebene).

Wenn wir die Technik des Beispiels Listing10c4.s auf einen Bildschirm im     
Interleaved-Format anwenden wollen, stehen wir vor einem Problem. Wenn wir in
diesem Format arbeiten, dann werden alle Bitebenen gleichzeitig geblittet.
Die Maske hat jedoch die Größe einer Ebene und kann daher nicht in einem Blitt
verwendet werden, deren Dimension der Anzahl der Ebenen entspricht aus denen  
das Bild zusammengesetzt ist. 
Um dieses Problem zu lösen, müssen wir unsere Maske ändern. Da jede Zeile der
Maske die entsprechende Zeile ALLER Bitebenen des Bildes auswählen muss, müssen
wir die Zeile so oft wiederholen, wie es Bitebenen gibt.
Im interleaved Format müssen wir also eine Bitplane-Maske verwenden bei der jede 
Zeile so oft wiederholt wird, wie es Bitebenen des Bildes gibt.
Im Fall des Bildes, das wir zuvor gesehen haben (3 Ebenen) sieht unsere
verschachtelte Maske wie folgt aus:


	0010\
	0010 |	- erste Zeile der normalen Maske dreimal wiederholt
	0010/
	0111
	0111
	0111
	1111
	1111
	1111
	0110
	0110
	0110


Da das Bild aus 3 Bitebenen besteht, wurde jede Zeile der Maske im normalen
Format dreimal wiederholt, um die verschachtelte Maske zu erhalten. Das
interleaved Format zwingt uns daher, eine Maske zu verwenden, die mehr 
Speicherplatz benötigt als im normalen Format.

Das Beispiel Listing10c5.s ist die verschachtelte Version von Listing10c4.s,
und ermöglicht es uns, das Gesagte in der Praxis zu sehen.

		                 ___
		               _(   )_        
		            __( . .  .)__     
		          _(   _ .. ._ . )_   
		         ( . _/(_____)\_   )  
		        (_  // __ | __ \\ __) 
		        (__( \/ o\ /o \/ )__) 
		         ( .\_\__/ \__/_/. )  
		          \_/¬(_.   ._)¬\_/   
		           /___(     )___\    
		          ( |  |\___/|  | )   
		           ||__|  |  |__||    
		           ||::|__|__|::||    
		           ||:::::::::sc||    
		          .||:::__|__:;:||    
		          /|. __     __ .|\.  
		        ./(__..| .  .|.__) \. 
		        (______|. .. |______) 
		           /|  |_____|        
		                 /|\          
		                  :

Wenn Sie die Funktionsweise der Masken verstanden haben, sind Sie bereit das 
Hintergrundproblem mit den BOBS ein für alle mal zu lösen. Wie Sie sich
sicherlich erinnern, sind wir im Beispiel Listing9i3.s ziemlich nah an der      
Lösung des Problems gewesen. Der Hintergrund wird gespeichert und anschließend 
an seiner Stelle neu gezeichnet. Das einzige Problem ist, das das umschließende 
Rechteck der Figur des BOBs den Hintergrund löscht und durch die Farbe 0 	   
ersetzt wird.
In Wirklichkeit verwenden wir beim Zeichnen eines BOBs die Farbe 0 nicht als
irgendeine andere Farbe, sondern einfach, um die Pixel des Rechtecks zu
bezeichnen, die nicht zum Bild des BOBs gehören. Es ist genau dasselbe, wie bei
den Sprites wo wir die Farbe 0 als "transparent" verwenden.
Wenn wir das BOB auf dem Bildschirm zeichnen, möchten wir, dass der Hintergrund
in farbigen Pixeln erscheint, anstelle der mit der Farbe 0 gefärbten Pixel. In 
der Praxis sollten wir in der Lage sein nur die Pixel mit einer anderen Farbe 
als 0 auf den Bildschirm zu schreiben.     
Dies ist nicht möglich, weil wie Sie wissen, der Blitter IMMER VOLLSTÄNDIGE   
Wörter schreibt (und liest).
Daher wird eine andere Strategie verfolgt. Anstatt eine einfache Kopie des   
BOBs auf dem Ziel zu machen, machen wir einen komplizierteren Blitt.
Wir lesen aus dem Speicher, neben dem BOB, auch den Hintergrund, und 
"vermischen" sie miteinander, so dass die Hintergrundpixel anstelle der 0 
Pixel des BOBs erscheinen, und wir schreiben das Ergebnis auf den Bildschirm.
Die Strategie ist in der folgenden Abbildung dargestellt, in der wir ein BOB   
und ein Hintergrundstück von 6 × 8-Pixel haben.
Das Symbol "." stellt ein Pixel der Farbe 0 dar, das Symbol "#" repräsentiert  
ein Pixel vom BOB mit unterschiedlicher Farbe und das Symbol "o" repräsentiert 
ein Pixel vom Hintergrund in einer anderen Farbe:

	BOB				Hintergrund

	........		...o....
	..####..		...oo...
	.#.##.#.		..oooo..
	..####..		..ooooo.
	...##...		.ooooooo
	..#..#..		oooooooo

	   \			   /
	    \			  /
	     \			 /  

	BOB überlagert auf HINTERGRUND
			...o....
			..####..
			.#o##o#.
			..####o.
			.oo##ooo
			oo#oo#oo


	Fig. 30	BOB und Hintergrund

Auf diese Weise erhalten wir den gewünschten Effekt.	
Es bleibt noch zu klären, wie man das BOB mit dem Hintergrund "mischt". Um
"richtig" zu mischen, müssen wir wissen, welche Pixel des BOBs die Farbe 0
haben und welche nicht. Diese Information ist in der BOB-Masken-Bitplane 
enthalten, die wie sie wissen, für jedes Pixel der Farbe 0 des BOBs ein Bit     
auf 0 und für jedes Pixel einer anderen Farbe ein Bit auf 1 hat.
Der Mischvorgang läuft folgendermaßen ab:

- Für jedes Pixel wird die Maske gelesen
- Wenn die Maske den Wert 1 hat, kopieren wir das entsprechende Pixel des BOBs  
- Wenn die Maske den Wert 0 hat, kopieren wir das entsprechende Pixel des 	   
  Hintergrunds.
  
Wir können diesen Vorgang mit einem einzigen Blitt auf folgende Weise
durchführen: Wir lesen die Maske durch den Kanal A des Blitters, den BOB durch
den Kanal B, den Hintergrund durch den Kanal C, wir benutzen die Maske, um die
zu kopierenden Pixel aus (oder aus dem Hintergrund oder aus dem BOB) und 
schreiben das Ergebnis in Kanal D (die Kanalzuweisung ist nicht zufällig).	   
Die Auswahl erfolgt anhand der folgenden logischen Gleichung:

D = (A AND B) OR ( (NOT A) AND C)

Diese Gleichung verhält sich genau wie das oben beschriebene Auswahlverfahren.
In der Tat, wenn die Maske A = 1 ist (d.h. wir haben ein BOB Pixel mit einer     
Farbe UNTERSCHIEDLICH von 0) vereinfacht sich die Gleichung in der folgenden
Art und Weise:

D = (1 AND B) OR ( (NOT 1) AND C) = B OR (0 AND C) = B OR 0 = B
 
Dann wird das Pixel des BOBs kopiert. Wenn stattdessen A = 0 ist (d.h. wir
haben ein Pixel des BOBs der Farbe 0), lautet die Gleichung:

D = (0 AND B) OR ( (NOT 0) AND C) = 0 OR (1 AND C) = 0 OR C = C

Dann wird das Hintergrundpixel kopiert.
Diese logische Gleichung wird vom Blitter ausgeführt (wie sie selbst berechnen 
können) indem LF = $CA gesetzt wird, ein Wert, der als "COOKIE CUT" bezeichnet
wird. Wie wir bereits erwähnt haben, war die Kanalzuweisung basierend auf den
Eigenschaften der Kanäle selbst.							   
In der Tat, um eine horizontale flüssige Verschiebung zu machen, ist es
notwendig für den BOB und für die Maske die Verschiebung des Blitters zu
verwenden und den Kanal C (welcher die Verschiebung nicht kann) für den 
Hintergrund zu verwenden. 
Außerdem wenden wir den Trick an, das letzte Wort der Bitebene zu maskieren,
so dass das letzte Wort gelöscht wird, wodurch der Hintergrund im letzten Wort
ausgeblendet wird.

Die Beispiele Listing10d1.s und Listing10d1r.s zeigen (jeweils in Version
normal und interleaved) den lang erwarteten BOB, der sich auf einem Hintergrund
bewegt.

                 _|_
          __|__ |___| |\
          |o__| |___| | \
          |___| |___| |o \
         _|___| |___| |__o\
        /...\_____|___|____\_/
        \   o * o * * o o  /
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*******************************************************************************
*		 DIE GESCHWINDIGKEIT DES BLITTERS (UND NICHT NUR))			      	  *
*******************************************************************************

Jetzt ist es an der Zeit, sich mit einer sehr wichtigen Frage zu befassen: der	   
Geschwindigkeit des Blitters. Wie Sie wissen, benötigt der Blitter eine gewisse
Zeit, um seine Aufgaben zu erfüllen, und es ist notwendig dies bei der
Programmierung komplexer Effekte zu berücksichtigen. Um die Geschwindigkeit des
Blitters zu messen, verwenden wir eine sehr einfache Technik, die als "copper
monitor" bekannt ist und uns das Ergebnis in Echtzeit auf dem Bildschirm
anzeigt.
Die Technik ist sehr einfach: Wir verwenden eine bestimmte Farbe (normalerweise
schwarz) als Hintergrund. Dann, kurz vor dem Start des Blitts, ändern wir die
Hintergrundfarbe mit dem Prozessor, über ein "MOVE.W #$xxx,$dff180". Wenn der
Blitt endet, setzen wir den Hintergrund auf die Ausgangsfarbe zurück. Auf diese
Weise wissen wir, dass der Blitt eine proportionale Zeit zu dem andersfarbigen
Teil des Bildschirms benötigt.
Es sollte beachtet werden, dass diese Technik verwendet wird, um jede Art von  
Routine zu messen, und ist besonders nützlich um zu verstehen, wann eine
Routine	schneller oder langsamer wird nach einer Änderung, zum Beispiel einer
Optimierung.

Ein Beispiel wird in Listing10e1.s gezeigt.

In diesem Beispiel verwenden wir den Blitter, um ein Rechteck auf dem
Bildschirm zu kopieren. Anhand dieses Beispiels können wir einige Überlegungen
zur Geschwindigkeit des Blitters anstellen. Zunächst einmal hängt die
Geschwindigkeit, wie bereits erwähnt, von der der Größe des Blitts ab.
Versuchen Sie im Beispiel die Höhe und / oder Breite des Rechtecks zu ändern
und sie werden es selbst sehen.

Das ist normal, denn je größer das Rechteck ist, desto größer ist auch die     
Anzahl der zu bewegenden Wörter. In ähnlicher Weise beeinflusst die Anzahl der
Bitebenen die Geschwindigkeit. (Versuchen sie es in Listing10e1.s, die Anzahl
der Iterationen der Routine "DisegnaOggetto" (DrawObject) zu ändern.) Je mehr
Bitebenen es gibt, desto größer ist die Menge der zu verschiebenden Daten.

Das Beispiel Listing10e1r.s ist die Rawblit-Version des vorherigen Beispiels.   

Wenn Sie es ausführen, werden Sie feststellen, dass es schneller ist, aber nur
sehr wenig. Aber dann, werden Sie, nach allen Vorteilen von RawBlit fragen?
Wie wir bereits gesagt haben, ist die Rawblit-Technik nicht praktisch, weil sie
den Blitter beschleunigt, sondern weil sie Prozessorzeit spart.

In den 2 Beispielen, die wir bisher gesehen haben, haben wir nur die Zeit      
vom Blitter gemessen.

In den Beispielen Listing10e2.s und Listing10e2r.s verwenden wir stattdessen 	   
verschiedene Farben um sowohl die vom Blitter als auch die vom Prozessor
benötigte Zeit anzuzeigen.

Der Vergleich zwischen diesen Beispielen zeigt uns die Vorteile des rawblit-   
Version: Bei dieser Technik wird der Prozessor sehr wenig verwendet, nämlich
nur für die Zeit zum Laden der Blitter-Register, und dann ist er frei, um
andere Aufgaben zu erledigen, anders als das was mit dem normalen Modus, bei
dem der Prozessor auf das Ende eines Blitts warten muss, um den Blitt der
nächsten Bitebene zu starten. 

Um den Vorteil der Rawblit-Technik auszunutzen, ist es natürlich notwendig,
dass die Routine nach dem Blitt den Blitter NICHT benutzt.

Wenn nämlich (wie in den Beispielen geschehen) nach einem Blitt sofort eine 
Routine folgt, die den Blitter benutzt, muss der Prozessor immer noch warten,
bis der Blitter seine Aufgabe beendet hat, und daher haben wir keinen Vorteil.
Ein Kriterium für die Optimierung der Programme ist daher, die Routinen, die
den Blitter benutzen "auf Abstand" zu platzieren, d.h. durchsetzt mit anderen
Routinen, die ihn nicht benutzen, so das der Blitter und der Prozessor  
parallel arbeiten können.
Es muss jedoch gesagt werden, dass dieses Kriterium vor allem auf Maschinen die
mit FAST Memory ausgestattet sind gilt, denn wenn der Prozessor auf den
Chipspeicher zugreifen muss, kommt es zu Konflikten beim Zugriff auf den
Speicher, die wir gleich näher erläutern werden.
  
Vorerst noch eine Anmerkung zu den Beispielen Listing10e2.s und
Listing10e2r.s:

Der Blitter benötigt in etwa die gleiche Zeit zum Löschen (grüner Bildschirm)
und zum Zeichnen (roter Bildschirm). Wenn Sie darüber nachdenken, sollte Ihnen
diese Tatsache seltsam erscheinen: In der Tat ist es wahr, dass die 2 Blitts
die gleiche Größe haben, aber wir müssen bedenken, dass die Löschung ein Blitt
ist, der nur einen Kanal verwendet, während die Kopie 2 Kanäle verwendet. Es
ist klar, dass, mit zunehmender Anzahl der Kanäle sich die Anzahl der Wörter die
vom Blitter gelesen und geschrieben werden erhöhen, so dass der Blitt länger
dauern sollte.

                      o    .  o  .  o .  o  .  o  .  o
                 o
              .
            .        ___
           _n_n_n____i_i ________ ______________ _++++++++++++++_
        *>(____________I I______I I____________I I______________I
          /ooOOOO OOOOoo  oo oooo oo          oo ooo          ooo
      ------------------------------------------------------------

Aber sehen sie sich das Beispiel Listing10e3.s an.

Dieses Beispiel ähnelt dem vorherigen, aber anstat eine einfache Kopie des
Bildes zu machen, führt es eine ODER-Operation zwischen der Figur und einer  
Null-Ebene durch. Der Effekt ist natürlich immer noch derselbe, aber Sie
können jetzt sehen, dass die Routine, die einen 3-Kanal-Blitt (D = A OR B)
durchführt, wesentlich langsamer ist.
Die Geschwindigkeit hängt davon ab, welche und wie viele Kanäle auf einmal
verwendet werden und zwar auf recht komplizierte Weise, die in der folgenden
Tabelle zusammengefasst werden kann:
    bit 8-11
       von      Kanäle 
    BLTCON0     benutzt		Speicherzugriffsfolge
   ---------    --------    --------------------------------------
       F        A B C D     A0 B0 C0 -  A1 B1 C1 D0 A2 B2 C2 D1 D2
       E        A B C       A0 B0 C0 A1 B1 C1 A2 B2 C2
       D        A B   D     A0 B0 -  A1 B1 D0 A2 B2 D1 -  D2
       C        A B         A0 B0 -  A1 B1 -  A2 B2
       B        A   C D     A0 C0 -  A1 C1 D0 A2 C2 D1 -  D2
       A        A   C       A0 C0 A1 C1 A2 C2
       9        A     D     A0 -  A1 D0 A2 D1 -  D2
       8        A           A0 -  A1 -  A2
       7          B C D     B0 C0 -  -  B1 C1 D0 -  B2 C2 D1 -  D2
       6          B C       B0 C0 -  B1 C1 -  B2 C2
       5          B   D     B0 -  -  B1 D0 -  B2 D1 -  D2
       4          B         B0 -  -  B1 -  -  B2
       3            C D     C0 -  -  C1 D0 -  C2 D1 -  D2
       2            C       C0 -  C1 -  C2
       1              D     D0 -  D1 -  D2
       0        niemand     -  -  -  -
	   
Diese Tabelle zeigt für jede Kombination von aktiven Kanälen die Reihenfolge der 
Speicherzugriffe durch den Blitter, im Falle eines Blitts von 3 Wörtern.
Für jeden Zugriff wird der Kanal angegeben, der ihn durchführt, und die Striche 
bezeichnen Buszyklen, die vom Blitter nicht genutzt werden. Zum Beispiel die
Zeichenfolge:

A0 B0 -  A1 B1 -  A2 B2

Zeigt an, dass zuerst der Kanal A (A0), dann der B (B0) auf den Bus zugreift,
dann der Blitter keinen Buszyklus verwendet (was dem Prozessor den Zugriff auf
den Speicher ermöglicht), dann greift er wieder auf Kanal A (A1) zu und so
weiter.

Die gezeigte Tabelle ist eigentlich nur indikativ, weil sie viele Faktoren
nicht berücksichtigt, wie die Verwendung spezieller Blitter-Modi und die
Konkurrenz mit dem Prozessor und anderen DMA-Kanälen (siehe Lektion 8).
Trotzdem ist es sehr nützlich, um eine Vorstellung von den besten
Kanalkombinationen zu bekommen. Beachten Sie, dass diese Tabelle sich auf 
einen Blitt von 3 Wörtern bezieht. Um mehr Wörter zu blitten, wiederholt der 
Blitter die Zugriffsfolge, die in der Tabelle "in der Mitte" steht.  
Zum Beispiel ein Blitt von 5 Wörtern mit den Kanälen A und D hat die folgende	   
Sequenz:

A0 -  A1 D0 A2 D1 -  D2 A3 -  A4 D3 A5 D4 -  D5

Die Untersuchung der Tabelle erlaubt uns einige interessante Beobachtungen.
Betrachtet man die Sequenz, die sich nur auf die Nutzung des D-Kanals bezieht,
sieht man dass der Blitter den Bus jeden zweiten Zyklus ausnutzt. Umgekehrt,
wenn die Kanäle A und D verwendet werden, nutzt der Blitter (außer beim ersten
und letzten Wort) alle Buszyklen. Diese Tatsache erklärt, warum in den
Beispielen die Löschroutine (Kanal D) etwa die gleiche Geschwindigkeit hat wie
die Zeichenroutine (Kanäle A und D). Beachten Sie jedoch, dass die Dinge anders
liegen, wenn wir eine Kopie von B nach D machen.

Sie können es in der Praxis in Listing10e4.s sehen.

Ein Blick auf die Tabelle zeigt, dass es im Falle von Blitts mit 2 Quellen
besser ist, A und B oder A und C zu verwenden, aber nicht B und C, da mehr 
Zyklen verschwendet werden.

Sie müssen jedoch bedenken, dass die Geschwindigkeit des Blitters auch von 
eventuellen Konflikten mit den anderen DMA-Kanälen (Video, Audio, Cupfer, 	   
Prozessor) abhängt, die Zyklen "stehlen" können und ihn damit verzögern.
Wie wir in Lektion 8 erklärt haben, hat der Blitter nur eine
Buszugriffspriorität gegenüber der CPU. Das bedeutet, dass wenn ein anderes     
Gerät (z.B. Copper) zur gleichen Zeit wie der Blitter auf den RAM zugreifen
will, hat das anderen Gerät Vorrang.

Der einzige Narr, der dem Blitter den Vorrang gibt, ist der Prozessor. Der
Blitter zeigt sich nämlich sehr großzügig, wenn er feststellt, dass der
Prozessor 3 Mal hintereinander versucht hat, auf den Bus zuzugreifen, es aber
nicht geschafft hat, weil jemand anderes den Vorrang hatte, sagt er ihm:
"Diesmal bist du dran, vah" und gibt ihm den Bus für einen Zyklus.
Dieser Mechanismus reduziert die Möglichkeit, dass der Prozessor im Falle einer
DMA Überlastung, blockiert ist und  zu lange auf den Bus warten muss. Es ist
jedoch möglich, die Großzügigkeit des Blitters zu unterdrücken. 

Durch Setzen von Bit 10 (genannt blitter_nasty) auf 1 im DMACON Register
verhält sich der Blitter nun nicht mehr so, sondern hat jetzt immer Vorrang
vor dem Prozessor. Falls die Routinen unseres Programms alle den Blitter
benutzen, dann macht der Prozessor nichts, sondern lädt nur die Register und
geht in den Wartemodus, dann ist es besser, dieses Bit auf 1 zu setzen.
Offensichtlich macht dieser Diskurs Sinn, wenn das Programm im Chip RAM   
enthalten ist und keine Caches vorhanden sind, denn sonst gibt es keine
Konflikte zwischen dem Prozessor und dem Blitter beim Zugriff auf den RAM.

Ein Beispiel für das Blitter Nasty Bit findet sich in Listing10e5.s.

Um die Nutzung des Blitters so weit wie möglich zu maximieren, müssen Sie die
Geschwindigkeit des Schreibens in die zugeörigen Register auf das Maximum
beschleunigen. In den Beispielen, die wir bisher gemacht haben und auch in
denen, die wir im weiteren Verlauf der Lektion machen werden, haben wir das
Schreiben der Register aus Gründen der Übersichtlichkeit nicht so optimiert,
wie wir es hätten tun können.
Die einzigen Register, die sich bei einem Blitt ändern, sind die BLTxPT- und
BLTSIZE Register. Die Register BLTCONx, BLTxMOD und BLTxWM bleiben konstant.
Das bedeutet, dass, wenn der Inhalt dieser Register nicht von anderen Routinen
geändert werden, müssen sie nicht zu Beginn jedes Blitts neu geschrieben
werden.
Ein Mittel zur Optimierung der Routinen für den Fall, dass es sich um 
Blitt-Schleifen handelt, besteht darin, die in die Blitter-Register zu
schreibenden Werte in Prozessorregister zu schreiben, und das
MOVE.W #YYY,$DFFxxx innerhalb der Schleife zu ersetzen durch
MOVE.W Dx,$DFFxxx, die schneller sind.
Diese Optimierungen beim Schreiben der Register führen zu sehr kleinen 
Geschwindigkeitssteigerungen, die mit dem Coppermonitor nur schwer zu erkennen
sind. Aber in einer Demo mit vielen komplexen Effekten, haben sie
zusammengenommen ihr Gewicht.

Schauen Sie sich als Beispiel Listing10e6.s an, das eine optimierte Version 
von Listing10c3.s ist.

                                 \\\|///                            
                               \\  ~ ~  //
                                (  @ @  )
______________________________oOOo_(_)_oOOo____________________________________
*******************************************************************************
*			 DOUBLE BUFFERING												  *
*******************************************************************************

Alle Beispiele, die wir bisher im Zusammenhang mit Bobs gesehen haben, hatten
immer nur einen Bob, der sich über den Bildschirm bewegt. Versuchen wir nun,
mehr Bobs zu zeigen.
Versuchen wir zum Beispiel, die Technik des "unechten" Hintergrunds anzuwenden: 
Wir verwenden eine Bitplane für den Hintergrund und 3 Ebenen, um die Bobs zu
bewegen. Da sich alle Bobs auf den gleichen Bitebenen bewegen, müssen wir sie
trotzdem mit der Masken-Bitplane-Technik zeichnen.
Allerdings haben wir den Vorteil, dass wir den Hintergrund nicht speichern und
wiederherstellen müssen, da die Bitebenen der Bobs anfangs zurückgesetzt
werden. Es reicht daher aus, diese Ebenen bei jedem frame zu löschen, bevor die
Bobs an den neuen Positionen neu gezeichnet werden.

Diese Technik wird im Beispiel Listing10f1.s angewendet.

Wenn Sie dieses Programm ausführen, werden Sie jedoch eine böse Überraschung
erleben: Die Bobs werden nur im unteren Teil des Bildschirms richtig
gezeichnet, während sie oberen Teil nicht richtigt gezeichnet werden. Woran
liegt das? Gibt es irgendwelche Fehler in unseren Routinen? Nein, unsere
Routinen sind in Ordnung. Das Problem ist, dass sie zu langsam sind. Wie Sie
wissen, zeichnet der Elektronenstrahl das Bild auf den Bildschirm, während
unser Programm ausgeführt wird. 
Damit ein stabiles Bild erscheint, wird versucht, den Bildschirm zu verändern	   
(d.h. Löschen, Zeichnen von Bobs, Linien usw.) während des Vertical Blank,
das heißt in der Zeit, in der der Elektronenstrahl inaktiv ist.		   
Wenn wir jedoch viele Änderungen am Bildschirm vornehmen müssen, kann es		   
passieren, das unsere Routinen nicht schnell genug sind, um ihre Arbeit während
des Vertical Blank zu machen. Genau das passiert in diesem Fall.
Durch die Erhöhung der Anzahl der Bobs, erhöht sich die Zeit, die benötigt
wird, um sie zu zeichnen und folglich ist es nicht mehr möglichd, dies während
des vertical blanks zu tun. Das Ergebnis ist, dass die Bobs manchmal erst auf
dem Bildschirm gezeichnet werden, nachdem der Elektronenstrahl diesen Teil des
Bildschirms gezeichnet hat und daher werden die Bobs nicht angezeigt.  
Da der Elektronenstrahl von oben nach unten arbeitet, passiert dies sind umso
häufiger, je höher die Bobs gezeichnet werden. 
Wenn Sie sich das Beispiel genau ansehen, werden Sie feststellen, dass der
Bereich des Bildschirms wo alle Bobs gut gezeichnet sind, derjenige ist, der
angezeigt wird, NACHDEM die Zeichnungsroutinen ihre Arbeit beendet haben, wie
der Coppermonitor beweist.
Mit der "Double-Buffering" Technik können wir dieses Problem lösen.
Dies ist eine allgemeine Technik, die Sie für jeden Effekt verwenden können,
nicht nur für Bobs. Wir werden sie insbesondere für 3D-Routinen verwenden.
Diese Technik besteht in der Verwendung von zwei Bildschirmen (Puffern genannt)
anstelle von nur einen. Die beiden Puffer werden abwechselnd angezeigt, erst
das eine Bild und dann das andere. Während einer der Puffer angezeigt wird,
können wir frei auf dem anderen zeichnen, ohne sich Gedanken um die Stabilität
zu machen, da das angezeigte Bild das des ersten Puffers ist, den wir nicht
verändern. Wenn der nächste Verical Blank auftritt, werden die beiden Puffer
ausgetauscht. Der Puffer, auf dem wir zuvor gezeichnet haben, wird angezeigt
und zeigt die Änderungen, die wir vorgenommen haben und der Puffer, der vorher
angezeigt wurde, steht uns nun zum Zeichnen zur Verfügung. 
Durch Wiederholung des Austauschs bei jedem Vertical Blank haben wir immer 	   
einen verfügbaren Puffer der nicht angezeigt wird, auf dem gezeichnet werden 	   
kann, ohne sich Gedanken um den Elektronenstrahl zu machen. 
Dank dieser Technik ist, die einzige zeitliche Begrenzung, das unsere Zeichen-	   
Routinen beendet sein müssen, bevor der Elektronenstrahl das Ende des
Bildschirms erreicht. Dies gibt uns eine Zeit von 1/50 einer Sekunde (in Pal,
1/60 in NTSC).  


               <>+<>                 //////      __v__        __\/__
   `\|||/      /---\     """""""    | _ - |     (_____)   .  / ^  _ \  .
    (q p)     | o o |   <^-@-@-^>  (| o O |)    .(O O),   |\| (o)(o) |/|(
_ooO_<_>_Ooo_ooO_U_Ooo_ooO__v__Ooo_ooO_u_Ooo_ooO__(_)__Ooa__oOO_()_OOo___
[_____}_____!____.}_____{_____|_____}_____i____.}_____!_____{_____}_____]
__.}____.|_____{_____!____.}_____|_____{.____}_____|_____}_____|_____!__
[_____{_____}_____|_____}_____i_____}_____|_____}_____i_____{_____}_____]
*******************************************************************************
*		VERWENDUNG VON NICHT AKTIVIERTEN BLITTERKANÄLEN						  *
*******************************************************************************

Es gibt Fälle, in denen es sinnvoll ist, nicht aktive Kanäle an dem Blitt zu
beteiligen. Um zu verstehen, was das bedeutet, müssen Sie noch eine weitere
Sache über den Blitter wissen. Wenn ein Eingangskanal (A, B oder C) aktiv ist,
liest er Wörter aus dem Speicher. Nach dem Lesen wird jedes Wort in ein
spezielles Register kopiert, das so genannte Blitter-Datenregister.
Jeder Kanal hat sein eigenes Datenregister, in dessen Namen der Buchstabe 	   
steht, der den Kanal identifiziert: wir haben daher BLTADAT (Kanal A, 	   
$DFF074), BLTBDAT (Kanal B, $DFF072), BLTCDAT (Kanal C, $DFF070) und BLTDDAT   
(Kanal D $DFF000).
Das Wort aus dem Datenregister wird anschließend der Reihe nach mit den Wörtern
der anderen Kanäle durch Logik Operationen verknüpft und das Ergebnis über   
den Kanal D in den Speicher geschrieben.
Nehmen wir ein Beispiel, um es besser zu verstehen. Betrachten wir den Fall
eines Blitts, der eine UND-Verknüpfung zwischen den Kanälen B und C durchführt.
Innerhalb des Blitters passieren die folgenden Dinge:

1 - Kanal B liest ein Wort und kopiert es in BLTBDAT
2 - Kanal C liest ein Wort und kopiert es in BLTCDAT
3 - Es wird eine UND-Verknüpfung zwischen dem Inhalt von BLTBDAT und dem von
	BLTCDAT durchgeführt
4 - Das Ergebnis wird über Kanal D geschrieben
5 - Die Schritte 1 bis 4 werden für die folgenden Wörter wiederholt.

In Wirklichkeit funktionieren die Dinge ein wenig anders, weil einige
Operationen parallel ausgeführt werden, um den Blitter zu beschleunigen, aber
auf der logischen Ebene funktionieren die Dinge so, und das ist es, was wir
wissen müssen. Was passiert, wenn ein Kanal deaktiviert ist? Natürlich wenn
nichts aus dem Speicher geholt wird, dann wird das entsprechende BLTxDAT-
Register auch nicht geändert.
Der Inhalt dieses Registers bleibt erhalten und kann in jedem Fall für logische
Operationen verwendet werden. Außerdem kann dieses Register auch von der CPU
beschrieben werden, was es uns ermöglicht, es auf geeignete Werte zu setzen
(nicht das BLTDDAT-Register!).
Die Situation ist ähnlich der, wie wir es in Lektion 7 für die Sprites gesehen
haben. Sprites haben auch DMA-Kanäle (SPRxPT-Register), die die gelesenen Daten
in Datenregister (SPRxDAT) kopieren.
In einigen Anwendungen ist es jedoch sinnvoll, direkt in die Datenregister mit 
dem Prozessor (oder mit dem Copper) zu schreiben.
Schauen wir uns nun die Nützlichkeit dieser Funktion des Blitters an.
Betrachten wir zum Beispiel den Fall, in dem wir eine Reihe von Speicherplätzen
mit einem konstanten Wert füllen wollen, um zum Beispiel auf dem Bildschirm ein 
Rechteck zu zeichnen, das nicht voll, sondern "gestreift" ist, oder wie die
Grafiker sagen mit einem "Muster" (d.h. einer Grafik). 
Wir können das Problem lösen, indem wir unser Rechteck im Datenteil unseres
Programms speichern und es mit dem Blitter kopieren, genau so, als wäre es ein
Bild wie die anderen. Eine bessere Lösung bietet jedoch die Möglichkeit die
Blitter-Kanäle zu deaktivieren.
Um das Problem zu lösen, können wir nämlich eine Kopie von Kanal A nach D  
machen, wobei Kanal A deaktiviert bleibt, und das "Muster" in das Register
BLTADAT schreiben. Auf diese Weise erhalten wir 2 Vorteile: Wir müssen uns das
Rechteck zwischen den Daten in unserem Programm nicht speichern, sodass wir
Speicherplatz sparen und weil Kanal A deaktiviert ist machen wir weniger 
Speicherzugriffe, als bei einer normalen Kopie von A nach D, so dass der
Prozessor mehr RAM-Zugriff hat.

Laden Sie Listing10g1.s, um diese Anwendung in der Praxis zu sehen.

Es ist möglich, diese Technik nicht nur für einfache Kopien eines konstanten   
Wertes anzuwenden, sondern auch in komplexeren logischen Operationen, bei denen 
ein Operand konstant ist.

2 Beispiele finden Sie in Listing10g2.s und Listing10g3.s.

			   .-----------.
			   |         ¬ |
			   |           |
			   |  ___      |
			  _j / __\     l_
			 /,_  /  \ __  _,\
			.\¬| /    \__¬ |¬/....
			  ¯l_\_o__/° )_|¯    :
			   /   ¯._.¯¯  \     :
			.--\_ -^---^- _/--.  :
			|   `---------'   |  :
			|   T    °    T   |  :
			|   `-.--.--.-'   | .:
			l_____|  |  l_____j
			   T  `--^--'  T
			   l___________|
			   /     _    T
			  /      T    | xCz
			 _\______|____l_
			(________X______)

*******************************************************************************
*			DAS NULL-FLAG UND KOLLISIONEN									  *
*******************************************************************************

Dies ist die letzte zu erklärende Hardware-Funktion des Blitters!

Der Blitter hat ein Flag, das sogenannte Zero-Flag, das ähnlich funktioniert
wie das Null-Flag des Prozessors. Dieses Flag ist Bit 13 des DMACONR-Registers.
Wenn ein Blitt ein ALLES NULL-Ergebnis produziert, wird das Zero-Flag auf EINS
gesetzt. Umgekehrt, wenn mindestens ein Bit in einem der Ergebniswörter den    
Wert 1 hat, wird das Zero-Flag auf den Wert 0 gesetzt.
Das Flag verhält sich auch in dem Fall so, wenn das Ergebnis des Blitts NICHT
in den Speicher geschrieben wird, d.h. wenn der Kanal D deaktiviert ist.
Diese Tatsache ist sehr nützlich, da sie uns hilft, Kollisionen zwischen einem 
Bob und einer Zeichnung auf dem Bildschirm zu erkennen. (die ein anderer,
bereits gezeichneter Bob sein kann). Nehmen wir einmal an, wir arbeiten mit
Bildern mit einer einzigen Bitplane.
Um Kollisionen zu erkennen, führen wir (mit dem Blitter) eine UND-Verknüpfung   
zwischen dem Bob und dem Teil des Bildschirms, auf dem der Bob positioniert    
werden soll durch, aber wir schreiben das Ergebnis nirgendwohin. Dieser Blitt
wird nur zum Testen der Kollision verwendet.
Was passiert, wenn wir ein UND ausführen? Wie Sie wissen ist das Ergebnis einer
UND-Verknüpfung zwischen 2 Bits nur 1, wenn beide Operandenbits 1 sind. In 	   
unserem Fall bedeutet das, dass ein Bit des Ergebnisses NUR dann den Wert 1 
haben kann wenn ein Bit des Bobs mit dem Wert 1 und ein Bit des Bildes mit dem
Wert 1 an der gleichen Position übereinstimmen. Das bedeutet aber, dass solche
Bits eine Kollision erzeugen.
Wenn also eine Kollision auftritt, hat mindestens ein Bit des Ergebnisses den
Wert EINS, und dementsprechend hat das Null-Flag den Wert NULL.
Umgekehrt, wenn keine Kollision auftritt, fällt kein Bit des Bobs mit einem Bit   
des Hintergrunds zusammen, daher ist das UND IMMER NULL, und daher nimmt das 
Null-Flag den Wert EINS an.
Das Zero-Flag kann uns also sagen, wann es eine Kollision gibt und wann nicht. 
Wenn wir es mit Bildern mit mehreren Bitplanes zu tun haben, sind die Dinge 
komplizierter, da es vorkommen kann, dass eine Kollision zwischen 2 Pixeln
unterschiedlicher Farben auftritt, die in der Ebenenbeziehung betrachtet,
nicht übereinstimmen.
Zum Beispiel, wenn eine Kollision zwischen einem Pixel der Farbe 1    
(Ebene 1 = 1 und alle anderen auf 0) und ein Pixel der Farbe 2 (Ebene 2 = 1 und
alle anderen auf 0) auftritt, ergibt eine UND-Verknüpfung einer Ebene immer als
Ergebnis 0. In diesen Fällen ist es besser, die Bitebenen der Maske zu 
verwenden.
Diese haben nämlich jedes Mal ein Bit auf 1, wenn das entsprechende Pixel des
Bobs eine andere Farbe als der Hintergrund hat.
Durch die UND-Verknüpfung der 2-Bitebenen-Maske werden Kollisionen unabhängig
von der Farbe der Pixel erkannt. (es ist wie die Erkennung der Kollision
zwischen dem "Schatten" der 2 Bobs, bei denen es sich um 1-Ebenen-Bilder
handelt).

Sie können ein Beispiel in Listing10h1.s sehen

			  \\ ,\\  /, ,,//
			   \\\\\X///////
			    \¬¯___  __/
			   _;=(  ©)(®_)
			  (, _ ¯T¯  \¬\
			   T /\ '   ,)/
			   |('/\_____/__
			   l_¯         ¬\
			    _T¯¯¯T¯¯¯¯¯¯¯
			 /¯¯¬l___¦¯¯¬\
			/___,  °  ,___\
			¯/¯/¯  °__T\¬\¯
			(  \___/ '\ \ \
			 \_________) \ \
			    l_____ \  \ \
			    / ___¬T¯   \ \
			   / _/ \ l_    ) \
			   \ ¬\  \  \  ())))
			  __\__\  \  )  ¯¯¯
			 (______)  \/\ xCz
			           / /
			          (_/

*******************************************************************************
*			   SINUSCROLL													  *
*******************************************************************************

Sicherlich weiß jeder von Ihnen, was ein Sinus-Scroller ist. Es ist ein
Scrolltext der beim Scrollen auf dem Bildschirm ansteigt und abfällt, so dass
er eine Sinuswelle bildet.
Bevor ich Ihnen erkläre, wie der Sinus-Scroller funktioniert, werde ich auf 
ein paar Dinge hinweisen.

Erstens: die Geschwindigkeit. Ein Sinus-Scroller ist ein sehr langsames
Programm. Ein guter Sinus-Scroller kann sogar mehr als ein Viertel der
verfügbaren Zeit in einem Frame benötigen. Für Systeme ohne Caches und FAST RAM
(in der Praxis der Amiga 500 und 600) ist es äußerst nützlich, das BLITTER
NASTY-Flag auf 1 zu setzen, was dem Blitter die absolute Priorität gegenüber
dem 68000er gibt, um die Leistung der Routine zu verbessern. 

Darüber hinaus muss auch die "Qualität" des zu erhaltenden Sinus-Scrollers
berücksichtigt werden. Damit ist gemeint, wie viele Pixel in jeder
Sinusposition angezeigt werden sollen. Ein 1-Pixel-Sinus-Scroller ist
derjenige, der am weichesten aussieht, aber auch derjenige, der am meisten
Zeit benötigt.

Erwarten Sie nicht, dass Sie Zeit für andere Effekte haben, wenn Sie einen
nicht "doppelt gepufferten" Bildschirm  verwenden. Auf der anderen Seite
erscheint ein 4-Pixel-Sinus-Scroller bereits sehr "verpixelt". Aus diesem
Grund werden wir zunächst erklären, wie man einen 2-Pixel-Sinus-Scroller
erstellt und dann wie die Variationen für die 1 und 2 Pixel-Versionen gemacht
werden.

Sind Sie ein wenig verwirrt? Schauen wir uns anhand eines Beispiels genau an,
was wir mit Qualität meinen.

Stellen Sie sich vor, dass die folgende Abbildung der Buchstabe A einer Bitmap-
Schrift ist:

.**************.
****************
****************
******....******
*****......*****
****************
****************
****************
*****......*****
*****......*****
*****......*****
*****......*****
*****......*****
*****......*****
*****......*****
................

	Fig. 31 Buchstabe A

Ein "*" steht für ein auf 1 gesetztes Bit, ein "." für ein gelöschtes Bit.
Das Zeichen "A" erscheint bei einem normalen horizontalen Bildlauf immer so 
so wie es in den Schriftdaten gespeichert ist. Bei einem Sinus-Scroller wollen
wir das nicht. Wir wollen die Spalten von Pixeln ändern die das Zeichen bilden,
so dass sie unterschiedliche vertikale Positionen einnehmen, basierend auf den
Werten einer Sinuswelle.
Bei einem 1-Pixel-Sinus-Scroller nimmt jede Pixelspalte eine andere vertikale
Position ein. Bei einem 2-Pixel-Sinus-Scroller sind die Pixelspalten
stattdessen 2 x 2 gepaart, und jedes Spaltenpaar nimmt eine andere vertikale
Position als die anderen Paare.
Ein 1-Pixel-Sinus-Scroller verformt das Zeichen A wie in der folgenden
Abbildung gezeigt.


 .
 **
 ***
 ****
 *****
 ******
 *******
 ********
 *********
 *****..***
 ******..***
 *******..***
 ********..***
 *****.***.****
 *****..***.****
 .****...*******.
  .***....*******
   .**.....******
    .*......*****
     .......*****
      ......*****
       .....*****
        ....*****
         ...*****
          ..*****
           .*****
            .****
             .***
              .**
 			   .*
 				.


	Fig. 31 Buchstabe A verformt durch einen 1-Pixel-Sinus-Scroller 

Wie Sie sehen können, befindet sich jede Pixelspalte in einer anderen 		   
vertikalen Position als die anderen. Ein 2-Pixel-Sinus-Scroller führt dagegen  
zu folgendem Ergebnis:

 .*
 **
 ****
 ****
 ******
 ******
 ********
 ********
 *****.****
 ******..**
 ******..****
 ********..**
 *****.**..****
 *****.********
 *****...**.****.
 ..***...********
   ***.....******
   ..*.....******
     *......*****
	 .......*****
       .....*****
       .....*****
         ...*****
         ...*****
           .*****
           ..****
             ****
             ..**
               **
 			   ..

	Fig. 32 Buchstabe A verformt durch einen 2-Pixel-Sinus-Scroller

Wie Sie sehen können, haben Paare benachbarter Spalten dieselbe vertikale      
Position. In einem 4-Pixel-Sinus-Scroller sind, wie Sie vielleicht vermutet
haben, die Pixelspalten in 4 zu 4 gruppiert und jede Gruppe nimmt eine andere    
Position ein als eine andere Gruppe.
Sie sollten jetzt verstanden haben, was mit einem 1-Pixel- oder 2-Pixel-Sinus-
Scroller gemeint ist. Die Methode, einen Sinus-Scroller zu erstellen, ist sehr
einfach.
Sie beginnt mit einer normalen Text-Scroll-Routine, wie die, die wir bereits
gesehen haben. Anstatt jedoch unseren Text auf dem sichtbaren Bildschirm zu
zeichnen und zu scrollen, tun wir dies in einem Datenpuffer, der irgendwo im 
Speicher liegt. Dieser Bildlaufpuffer ist niemals sichtbar. Aus diesem Puffer
nehmen wir vertikale "Scheiben" des Scrollers und kopieren sie auf den
sichtbaren Bildschirm.
Jedes "Stück" wird an eine andere vertikale Position, basierend auf den Werten 
der Sinuswelle kopiert. Die Dicke der "Slices" bestimmt die Qualität des Sinus-
Scrollers. Wenn sie 1 Pixel dick sind, haben wir einen 1-Pixel-Sinus-Scroller,
wenn sie 2 Pixel dick sind haben wir eine 2-Pixel-Routine und so weiter.
Sehen wir uns genauer an, wie man die "Scheiben" kopiert. Da die Scheiben sehr	   
dünn sind, werden wir einen einzelnen Wortbreiten Blitt machen. Um innerhalb
des Wortes nur die Scheiben (d.h. nur die Pixelspalten) auszuwählen die uns
interessieren, verwenden wir eines der Maskenregister von Kanal A (das
bedeutet, dass wir den Kanal A zum Lesen verwenden müssen) mit dem wir alle
Pixelspalten löschen können, die nicht zu der Scheibe gehören, die uns
interessiert. Natürlich variiert der Wert der Maske je nach zu lesender
"Scheibe". Das Schreiben erfolgt, wie bereits erwähnt, jedes Mal an einer
anderen vertikalen Position. Beim Schreiben reicht es nicht aus, eine einfache
Kopie von A nach D zu machen: Wenn wir dies täten, würden wir beim Kopieren
einer "Scheibe" einen Teil der vorher kopierten "Scheibe" löschen, die zum
selben Wort gehört wie die aktuelle "Scheibe".
Selbst wenn sich die anderen "Scheiben" nicht mit unseren überschneiden (weil
sie nebeneinander liegen), da unser Blitt ein Wort breit ist, würden wir mit
einer einfachen Kopie auch die Spalten der durch die Maske gelöschten Pixel auf
den Bildschirm kopieren, die neben der aktuellen "Scheibe" liegen.
Um dieses Problem zu lösen, machen wir ein ODER zwischen unserem Wort und dem
Hintergrund auf dem wir es schreiben. Auf diese Weise überschreiben die
genullten Pixel des aktuellen Wortes nicht die des Hintergrunds. Um den
Sinus-Scroller zu erstellen, genügt es, den gesamten Scroller vom Puffer auf
den Bildschirm zu kopieren. Mit diesem Verfahren scrollt der gesamte Scrolltext
einen "Slice" nach dem Anderen. 

Natürlich muss die ganze Prozedur in jedem Frame wiederholt werden, da sich der
Scrolltext bewegt hat und jedes Mal, bevor er ausgeführt wird ist es notwendig,
den Bildschirm zu löschen. Je größer die Amplitude des Sinus ist, desto größer
ist die Fläche des Bildschirms, die von der Operation betroffen ist. (die wir
jedes Mal löschen müssen.)
Daher ist es besser, eine kleinen Sinus-Scroller zu verwenden, um die Leistung
zu verbessern.

In Listing10i1.s und Listing10i2.s finden Sie einen 2-Pixel-Sinus-Scroller    
bzw. einen 1-Pixel-Sinus-Scroller.

		           /#\    ...
		          /   \  :   :
		         / /\  \c o o ø
		        /%/  \  (  ^  )    /)OO
		       (  u  / __\ O / \   \)(/
		       UUU_ ( /)  `-'`  \  /%/
		        /  \| /   <  :\  )/ /
		       /  . \::.   >.( \ ' /
		      /  /\   '::./|. ) \#/
		     /  /  \    ': ). )
		 __ û%,/    \   / (.  )
		(  \% /     /  /  ) .'
		 \_ò /     /  /   `:'
		  \_/     /  /
		         /\./
		        /.%
		       / %
		      (  %
		       \ ~\
		        \__)

*******************************************************************************
*				ANIMATION													  *
*******************************************************************************

Wir beenden die Lektion mit einer kurzen Erklärung, wie man Animationen mit dem
Blitter	erstellt. Eine Animation besteht aus einer Reihe von Bildern (Frames),
die in einer bestimmten Reihenfolge angezeigt werden müssen. 
Normalerweise ändert sich zwischen den einzelnen Frames nicht das ganze Bild, 
sondern nur Teile davon.
Zum Beispiel könnten wir ein Schloss mit Fahnen haben, die sich durch dem Wind   
bewegen. Natürlich ändert sich nur der Teil des Bildschirms, auf dem die 	   
Fahnen gezeichnet sind zwischen einem Frame und dem nächsten.	
Um Speicherplatz zu sparen, ist es nicht ratsam, alle Bilder der Animation zu 
speichern. Speichern Sie nur das erste Bild und dann die "Teile" der anderen 
Bilder, die die Unterschiede zum ersten Bild enthalten. 
Auf diese Weise können um die Animation zu erstellen, kopiert man einfach die
neuen "Teile" des Bildes auf das alte Bild. Für diesen Zweck ist der Blitter
sehr nützlich, da wie Sie wissen, er viel schneller als der 68000 (Basis) beim
Kopieren von Daten ist. Um eine Animation zu erstellen, müssen Sie im Grunde 
mit dem Blitter, den wir jetzt beherrschen Kopien machen.
Animationen können in zwei Arten unterteilt werden, je nachdem, wie die Abfolge
der Frames strukturiert ist.  
Bei Animationen des ersten Typs, den so genannten "zyklischen" Animationen,
werden die Bilder nacheinander in einer bestimmten Reihenfolge gezeichnet.
Nachdem das letzte Bild gezeichnet wurde, wird die Animation mit dem ersten
Bild fortgesetzt.
Auch bei den Animationen des zweiten Typs ("Vorwärts-Rückwärts"-Animationen)
werden die Bilder in einer bestimmten Reihenfolge gezeichnet. Nachdem jedoch
das letzte Bild gezeichnet wurde wird die Animation jedoch fortgesetzt, indem
die Bilder in umgekehrter Reihenfolge gezeichnet werden. An diesem Punkt läuft
die Animation wieder in direkten Reihenfolge bis zum letzten Bild, dann wieder
in umgekehrter Reihenfolge und so weiter. Je nach Art der Animation müssen Sie
eine andere Bildbearbeitungsroutine verwenden. 

Wir präsentieren 2 Animationsbeispiele (eine für jeden Typ) in den Listings 
Listing10l1.s und Listing10l2.s.

Es ist auch möglich, animierte Bobs zu erstellen. Das sind Bobs, die sich jedes   
Mal ändern, wenn sie gezeichnet werden. Natürlich haben wir auch für Bobs eine
Reihe von Frames die nacheinander dargestellt werden, basierend auf einer der
2 Techniken, über die wir gesprochen haben.
Es ist daher sehr praktisch, eine universelle Routine zu haben, die in der Lage
ist ein beliebiges Bild mit unterschiedlichen Abmessungen wie einen Bob zu
zeichnen.

Sie finden eine solche Routine für Bildschirme im Normalformat im Listing10m1.s 
und für Bildschirme im INTEREAVED-Format in Listing10m2.s.


		            .
		           .¦.¦:.:¦:.:¦
		          .;/'____  `;l
		          ;/ /   ¬\  __\
		          / /    ° \/o¬\\
		         /  \______/\__//
		        / ____       \  \
		        \ \   \    ,  )  \
		        /\ \   \_________/
		       /    \   l_l_|/ /
		      /    \ \      / /
		   __/    _/\ \/\__/ /
		  / ¬`----'¯¯\______/
		 /  __      __ \
		/   /        T  \

****************************************************************************** 
*			SPEZIAL MODIS DES BLITTERS										 *
****************************************************************************** 

Zusätzlich zu allen bisher beschriebenen Funktionen bietet der Blitter auch die   
Möglichkeit, Linien zu zeichnen und Bereiche zu "füllen", d.h. alle Bits einer    
bestimmten Region einer Bitebene auf 1 zu setzen.
Diese zusätzlichen Fähigkeiten werden durch spezielle Betriebsarten des
Blitters erreicht.

Lassen Sie uns mit dem Zeichnen von Linien beginnen. Wenn der Blitter im 
Linien-Zeichen-Modus (genannt "Linien-Modus") ist, zeichnet er eine Linie von
einem Punkt auf dem Bildschirm (den wir P1 nennen) zu einem anderen (den wir P2
nennen). Wir bezeichnen mit X1 und Y1, jeweils die Abszisse und die Ordinate
von P1 und mit X2 und Y2 die Abszisse und die Ordinate von P2. Im "Linien-
Modus" arbeiten viele Register auf eine völlig andere Weise als was wir bisher
gesehen haben, und es ist notwendig, sie entsprechend einzustellen. Einige
Einstellungen hängen von der Position von P1 und P2 ab. Vor der Beschreibung
der Verwendung von Registern, müssen einige Vorüberlegungen angestellt werden.

Während der Verfolgung betrachtet der Blitter den Bildschirm als in "Oktanten"
unterteilt bezogen auf den Punkt P1. Zum besseren Verständnis sehen Sie sich
bitte die folgende Abbildung an:

					 |
					 |
		    \  (2)   |  (1)   /
		     \ 	     |       /
		      \   3  |  1   /
		       \     |     /
				\    |    /
		(3)      \   |   /       (0)
				  \  |  /
		    7      \ | /     6
		       	    \|/
		-------------*-------------
					/|\
		    5      / | \     4
				  /  |  \
		(4)      /   |   \       (7)
				/    |    \
		       /     |     \
		      /   2  |  0   \
		     / 	     |       \
		    /  (5)   |  (6)   \
			         |
			         |


	Fig. 1 Oktanten
	

In der Abbildung repräsentiert das Sternchen (*) den Punkt P1. Der Blitter 	   
betrachtet den Bildschirm in 8 Bereiche (Oktanten genannt) unterteilt, die in
der Abbildung dargestellt sind.		               
Die zu verfolgende Linie gehört zu einem der Oktanten, nämlich zu dem, in dem
P2 gefunden wird. Die Zahlen in Klammern dienen der Nummerierung der Oktanten
gemäß der Notation, die wir "Menschen" normalerweise verwenden (also gegen den
Uhrzeigersinn). Der Blitter nummeriert sie stattdessen auf eine etwas
merkwürdige Weise, die durch Zahlen ohne Klammern angezeigt wird. Dies
Aufteilung werden wir später berücksichtigen.

Wir müssen auch einige Größen definieren, die wir für die Vorbereitung des 
Blitt verwenden müssen. Wir nennen DiffX die Differenz zwischen den Abszissen  
von P2 und P1, das Vorzeichen wird geändert, wenn es negativ ist, so dass es
immer noch positiv ist. In der Formel setzen wir:

DiffX = abs (X2 - X1)

wobei "abs" die Funktion bezeichnet, die den absoluten Wert einer Zahl
berechnet. Wir machen dasselbe mit den Ordinaten, indem wir festlegen:

DiffY = abs (Y2 - Y1).

An dieser Stelle definieren wir DX und DY als Maximum bzw. Minimum zwischen
DiffX und DiffY. In den Formeln:

DX = max (diffX, diffY)
DY = min (diffX, diffY).

Sehen wir uns nun an, wie die Blitter-Register gesetzt werden, beginnend mit 
BLTCON1, mit dem man den Line-Mode aktivieren kann. Bit 0 von BLTCON1 dient 
genau für diesen Zweck. Wenn es auf 1 gesetzt wird, ist der Linienmodus
aktiviert. Mit Bit 1 können Sie "spezielle" Linien zeichnen, die das
anschließende Füllen von Blitter-Flächen ermöglichen. Wir werden später darüber
sprechen, für jetzt lassen wir es auf 0 (normale Linien).
In den Bits 2,3 und 4 muss die Nummer des Oktanten geschrieben werden, in dem
sich der Punkt P2 befindet. Natürlich müssen wir die Nummerierung des Blitters
verwenden. Um die normale Nummerierung gegen den Uhrzeigersinn leicht in die
vom Blitter verwendete zu konvertieren können Sie die folgende Tabelle
verwenden: 

Wert Bit von BLTCON1	 Nummer Oktant
---------------------	 --------------
		4 3 2
		- - -
		1 1 0				0
		0 0 1				1
		0 1 1				2
		1 1 1				3
		1 0 1				4
		0 1 0				5
		0 0 0				6
		1 0 0				7

		
Bit 6 von BLTCON1 (das sogenannte SIGN-Bit) muss auf 1 gesetzt werden, wenn 
4 * DY-2 * DX < 0 ist. Andernfalls (d.h. wenn 4 * DY-2 * DX > 0) muss es auf 0
gesetzt werden.
Die Bits 12 bis 15 von BLTCON1 enthalten die Anfangsposition des "Musters" der  
Linie. Es ist nämlich möglich, nicht nur "durchgezogene" Linien, sondern auch 	   
gestrichelte Linien zu zeichnen, durch zwar mit Hilfe eines "Musters", das sich
entlang der gesamten Linie wiederholt. (Wir haben bereits Beispiele für Muster
in Lektion 9 gesehen). Die Bits 12 bis 15 von BLTCON1 geben das Pixel an, ab
dem das Muster verwendet werden soll. Natürlich (wir haben nur 4 Bits) muss es
eines der ersten 16 Pixel der Linie sein.
Alle anderen Bits von BLTCON1 müssen auf 0 belassen werden. Wir kommen nun zu
BLTCON0. Mit dem niederwertigen Byte dieses Registers (LF, das der Minterms)   
können Sie 2 verschiedene Zeichenmodi auswählen. Durch Setzen von LF = $4A  
wird eine Exklusiv-ODER-Operation zwischen der Linie und dem Hintergrund auf
dem sie gezeichnet wird, durchgeführt. In der Praxis werden die Pixel, die von
der Linie gekreuzt werden, invertiert.
Wenn Sie stattdessen LF = $CA setzen, wird eine einfache ODER-Operation
zwischen der Zeile und dem Hintergrund durchgeführt. In der Praxis werden die
Pixel, die von der Linie gekreuzt werden, eingeschaltet.
Die für das Blitting zu aktivierenden Kanäle sind A, C und D. Dann müsen die  
Bits 8,9 und 11 auf 1 gesetzt werden, während 10 auf 0 gesetzt werden muss.
Die Bits 12 bis 15 von BLTCON0 müssen stattdessen die 4 niederwertigen Bits 
enthalten (d.h. niedrigsten) von X1, der Abszisse des Punktes P1, enthalten.
Glücklicherweise sind die Einstellungen der anderen Register einfacher.

Die Register BLTAFWM und BLTALWM müssen auf den Wert $FFFF gesetzt werden (sie
maskieren nichts). Das BLTADAT-Register muss stattdessen den Wert $8000
enthalten, das den Wert des zu zeichnenden Pixel darstellt. Das BLTBDAT-
Register enthält stattdessen das "Muster" der Linie, das wir bereits erwähnt
haben. Ein Wert $FFFF bewirkt, dass eine durchgezogene Linie gezeichnet wird.
Beim Zeichnen von Linien wird nur der untere Teil von BLTAPT verwendet, d.h.
nur das 16-Bit-Register BLTAPTL, das auf den Wert 4 * DY-2 * DX gesetzt werden 	   
muss. Das BLTAMOD-Register hingegen muss auf den Wert 4 * DY-4 * DX gesetzt 	   
werden. Das BLTBMOD-Register muss auf den Wert 4 * DY gesetzt werden. In den 	   
Registern BLTCPT und BLTDPT muss die Adresse des Bildschirmworts enthalten
sein, das das Pixel P1 hat.
In den Registern BLTCMOD und BLTDMOD muss die Breite des Bildschirms enthalten   
sein ausgedrückt in Bytes. Schließlich muss das BLTSIZE-Register so eingestellt
werden, dass ein Blitt 2 Wörter breit und eine Anzahl von Zeilen gleich DX + 1
hoch ist. Das bedeutet, dass die Bits 0 bis 5 die Zahl 2 enthalten müssen, 
während die Bits 6 bis 15 den Wert DX + 1 enthalten. Wie üblich aktiviert das
Schreiben in das BLTSIZE-Register den Blitter. Aus diesem Grund muss dieses
Register als letztes beschrieben werden.

Zusammengefasst lauten die in die Register zu ladenden Werte:
BLTADAT = $8000
BLTBDAT = Linienmuster ($FFFF für eine durchgezogene Linie)

BLTAFWM = $FFFF
BLTALWM = $FFFF

BLTAMOD = 4 * (dy - dx)
BLTBMOD = 4 * dy
BLTCMOD = Breite der Bitebene in Bytes
BLTDMOD = Breite der Bitebene in Bytes

BLTAPT = (4 * dy) - (2 * dx)
BLTBPT = nicht verwendet
BLTCPT = Zeiger auf das Wort, das das erste Pixel der Zeile enthält
BLTDPT = Zeiger auf das Wort, das das erste Pixel der Zeile enthält

BLTCON0 Bit 15-12 = die unteren 4 Bits von X1
BLTCON0 Bit 11 (SRCA), 9 (SRCC), und 8 (SRCD) = 1
BLTCON0 Bit 10 (SRCB) = 0
BLTCON0 LF-Steuerbyte   = $4A (für Zeile in EOR)
						= $CA (für Zeile in OR)

BLTCON1 Bit 0 = 1
BLTCON1 Bit 4-2 = Oktantenzahl (aus der Tabelle)
BLTCON1 Bit 15-12 = Startbit für Linienmuster 
BLTCON1 Bit 6 = 1 wenn (4 * dy) - (2 * dx)) < 0
			  = 0 andernfalls
BLTCON1 Bit 1 = 0 (für normale Linien)
			  = 1 (für spezielle Fülllinien)

BLTSIZE Bit 15-6 = dx + 1
BLTSIZE Bit 5-0 = 2

Ein Beispiel für eine Linienzeichnung ist in Listing10n.s. enthalten.

Es handelt sich um eine maximal vereinfachte Routine, ohne besondere
Optimierungen, um das Verständnis auf Kosten der Ausführungsgeschwindigkeit
zu erleichtern.

Flächenfüllmodus

Zusätzlich zum Kopieren von Daten kann der Blitter während des Kopierens 
gleichzeitig eine Fülloperation ausführen. Dieser Modus kann mit jedem Standard
Blitt (Kopieren, UND, ODER, usw.) aktiviert werden und wird NACH allen anderen
Operationen durchgeführt, die Sie bereits kennen (Verschiebung, Maskierung
usw.).
Um zu verstehen, wie das Füllen funktioniert, stellen Sie sich vor, dass der  
Blitter zu einem Zeitpunkt ein Bit schreibt (was, wie Sie wissen, falsch ist,
da er immer EIN WORT auf einmal schreibt) und eine einfache Kopieroperation
durchführt. Solange er 0-Bits liest, kopiert er sie normal. 
An einem bestimmten Punkt erhält er ein Bit mit dem Wert 1. Er kopiert es
trotzdem in die Ausgabe, aber von diesem Moment an, anstatt die folgenden Bits
weiter zu kopieren, gibt er alle Bits mit dem Wert 1 aus. Wenn er jedoch ein
zweites Bit mit dem Wert 1 liest, wird das normale Verhalten wieder
fortgesetzt. Wenn er dann ein drittes Bit mit dem Wert 1 liest, beginnt er
wieder, 1en an den Ausgang zu schreiben, bis zur nächsten 1 im Eingang, und so
weiter.
  
Lassen Sie uns in einem Beispiel ansehen, was mit den kopierten Daten    
geschieht mit einer Folge von eingehenden Bits und die entsprechende Ausgabe:

Eingang 	000100010010010001000001000110010010
Ausgang		000111110011110001111111000110011110

In der Praxis werden die Bits dem Wert 1 als die Ränder des Bereichs
betrachtet und daher füllt der Blitter die Bits innerhalb des Bereichs (d.h. er
setzt sie auf 1). Sehen wir uns nun die technischen Details des Füllmodus an.   
Wie wir bereits gesagt haben, kann er in Kombination mit jedem Blitt verwendet
werden, da das Füllen erfolgt, nachdem die Daten aus den 3 Quellen geholt
wurden und die entsprechende logische Verknüpfung gemäß der Minterm-Einstellung
erfolgte. 		   
Der Füllmodus kann jedoch nur mit Blitts verwendet werden, die im absteigenden
Modus sind. (descending Mode)

Es gibt zwei verschiedene Arten von Füllungen, die als inklusiv und exklusiv   
bezeichnet werden. Jeder Fülltyp hat sein eigenes Aktivierungsbit. Um den     
Füllmodus zu aktivieren, muss eines der 2 Freigabebits auf 1 gesetzt werden.	   
Es ist nicht möglich die beiden verschiedenen Füllarten gleichzeitig zu
aktivieren.
Schauen wir uns die Unterschiede zwischen den 2 Fülltypen an.
Der inklusive Füllmodus füllt zwischen den Zeilen und lässt sie intakt. Der
exklusive Fülltyp füllt zwischen den Linien, aber während die
Begrenzungslinie auf der rechten Seite beibehalten wird, wird die Linie auf
der linken Seite gelöscht.

Die exklusive Füllung erzeugt also gefüllte Formen, die ein Pixel schmaler sind
als das gleiche Muster (Umriss), das mit inklusive Füllung gefüllt wurde.       

Zum Beispiel das Muster:

	00100100-00011000

gefüllt mit inklusiver Füllung, produziert:

	00111100-00011000

mit exklusiver Füllung wäre das Ergebnis:

	00011100-00001000

(Natürlich werden Füllungen immer mit vollen 16-Bit-Wörtern erstellt.)

Nehmen wir ein anderes Beispiel anhand von Zeichnungen:

inklusive Füllung:

		  zuerst			  nach der inklusiven Füllung
	 _______________________     _______________________
	|						|	|						|
	|						|	|						|
	|   1   1      1   1	|	|   11111      11111	|
	|    1  1		1  1	|	|    1111		1111	|
	|     1 1	 	 1 1	|	|     111		 111	|
	|      11	 	  11	|	|      11	  	  11	|
	|     1 1	 	 1 1	|	|     111	 	 111	|
	|    1  1		1  1	|	|    1111		1111	|
	|   1   1      1   1	|	|   11111      11111	|
	|						|	|						|
	|_______________________|	|_______________________|


exklusive Füllung:

		  zuerst			  nach der exklusiven Füllung
	 _______________________	 _______________________
	|						|	|						|
	|						|	|						|
	|   1   1      1   1	|	|    1111       1111	|
	|    1  1       1  1	|	|     111	 	 111	|
	|     1 1		 1 1	|	|      11	  	  11	|
	|      11	 	  11	|	|       1	  	   1	|
	|     1 1	 	 1 1	|	|      11	 	  11	|
	|    1  1       1  1	|	|     111		 111	|
	|   1   1      1   1	|	|    1111       1111	|
	|						|	|						|
	|_______________________|	|_______________________|


Wie Sie sehen können, wurden die Linien links von der Figur mit der exklusiven
Füllung gelöscht. Auf diese Weise erhält man Figuren mit schärferen Kanten. Das
Freigabebit der inklusiven Füllung ist Bit 3 von BLTCON1, das der exklusiven
Füllung ist Bit 4 ist, ebenfalls von BLTCON1.    
Es gibt ein weiteres Bit, das zur Steuerung der Füllung dient. Dies ist Bit 2  
von BLTCON1 (FILL_CARRYIN genannt), das, wenn es auf 1 gesetzt ist, das Füllen
der Bereiche außerhalb der Linien erzweingt, anstatt der inneren Bereiche. 
Kehren wir zum ersten Beispiel zurück und sehen uns an, was mit unserer
Bitzeile passiert wenn das Bit FILL_CARRYIN auf 1 gesetzt wird.
Die Ausgangszeile war: 

	00100100-00011000 
	
mit inklusiven Füllen und FILL_CARRYIN = 1 wäre die Ausgabe:

	11100111-11111111

mit exklusiven Füllen und FILL_CARRYIN = 1 würde die Ausgabe wie folgt lauten:

	11100011-11110111

Schauen wir uns an, was im zweiten Beispiel mit inklusiven Füllen und
FILL_CARRYIN = 1 passiert.


		  vorher				  danach
	 _______________________ 	 _______________________
	|						|	|						|
	|						|	|						|
	|   1   1      1   1	|	| 111   1111111   11	|
	|    1  1		1  1	|	| 1111  11111111  11	|
	|     1 1	 	 1 1	|	| 11111 111111111 11	|
	|      11	  	  11	|	| 111111111111111111	|
	|     1 1		 1 1	|	| 11111 111111111 11	|
	|    1  1		1  1	|	| 1111  11111111  11	|
	|   1   1      1   1	|	| 111   1111111   11	|
	|						|	|						|
	|_______________________|	|_______________________|

			inklusives Füllen mit Bit FCI = 1
			
Der Füllmodus wird hauptsächlich zum Füllen von Polygonen verwendet. Die Kanten
der Polygone werden mit dem Blitter-Line-Modus gezeichnet. Ein sehr einfaches   
erstes Beispiel wird im Listing10o.s gezeigt, das die verschiedenen Arten von
Füllungen veranschaulicht.
Wenn der zu füllende Bereich durch Linien mit einer Neigung von weniger als 45 
Grad begrenzt wird, ergibt sich ein Problem. In diesem Fall ist es nämlich so,
dass eine Linie aus Pixeln besteht, die auf derselben horizontalen Zeile des
Bildschirms nebeneinander liegen können. 
Die Situation wird durch die folgende Abbildung dargestellt, in der die
Sternchen (*) Pixel mit Wert 1 darstellen.


 		   *
 		  *
		 *		Linie mit einem Gefälle von > 45 Grad
		*
	   *


 		    *
 		  **
		**		Linie mit einer Neigung < von 45 Grad
	   *
	  **

Wie Sie sehen können, kommt es bei einer Linie mit einer Neigung von mehr als
45 Grad nie vor, dass 2 ihrer Pixel nebeneinander auf der gleichen Zeile des
Bildschirms liegen. Im Gegensatz dazu geschieht dies, wenn die Neigung der
Linie weniger als 45 Grad beträgt. Diese Tatsache schafft das Problem bei   
der Füllung. Wenn der Blitter nämlich auf 2 Pixel nebeneinander auf derselben
Zeile trifft, betrachtet er sie als 2 verschiedene Kanten und füllt daher die
Pixel, die rechts von der Linie liegen nicht.
Im Listing10p.s finden Sie ein Beispiel für dieses Problem.			   
Um dieses Problem zu lösen, haben die Entwickler des Blitters uns einen 	   
speziellen Modus zum Zeichnen von Linien gegeben (den wir bereits erwähnt
haben), der Linien erzeugt, die nur einen Pixel für jede horizontale Zeile
haben. Wenn Sie eine Linie in diesem Modus zeichnen, ohne die Füllung
vorzunehmen, erscheint sie Ihnen natürlich "aufgebrochen".	 

Im Listing10q.s finden Sie die Lösung für das Problem von Listing10p.s.

In dem Beispiel Listing10r.s versuchen wir ein geschlossenes Polygon zu
zeichnen und zu füllen, das aus vielen Linien gebildet ist. Wir stellen fest,  
dass es auch hier ein kleines Problem gibt. Das Problem ergibt sich aus der
Tatsache, dass der Scheitelpunkt des Polygons ein Linien Paar gemeinsam hat.
Wenn wir Linien im EOR-Modus zeichnen, invertieren wir die Hintergrund Pixel.
Die Scheitelpunkte werden zweimal invertiert und dann am Ende wieder auf Null
gesetzt. Es entsteht also ein "Loch" in der Kante des Polygons, wodurch die
Füllung schlecht ausgeführt wird. Wenn wir stattdessen die Linien im ODER-Modus
zeichnen, bleiben die Scheitelpunkte auf dem Wert 1. Dies führt zu Problemen
mit den Scheitelpunkten oben und unten, da sie von der Zeile zu der sie gehören
isoliert sind und deshalb beginnt die Füllung von ihnen aber nie endet. 

Um das besser zu verstehen, sehen Sie sich die folgende Abbildung an (bezogen
auf den unteren Scheitelpunkt):

	*        *		
	 *     *		Vor dem FÜLLEN
	  *  *
	   *

	   ^
	   +---- Scheitelpunkt am unteren Rand


	**********		
	 *******		Nach dem FÜLLEN
	  ****
************

	   ^
	   +---- Scheitelpunkt am unteren Rand
	   
	   

Wie Sie an der Linie sehen können, wo der letzte Eckpunkt liegt, endet die      
Füllung nicht, weil kein weiterer Pixel auf 1 gesetzt ist, der als linker Rand   
fungiert. Bei Linien im EOR-Modus tritt dieses Problem nicht auf, weil der 	     
Scheitelpunkt auf Null gesetzt ist (d.h. aufgrund des Phänomens, das uns Probleme
für die Zwischenscheitelpunkte verursacht).
Kurz gesagt, egal was wir tun, es gibt immer einen Scheitelpunkt, der uns die
Füllung kaputt macht! Schauen wir uns an, wie man dem aus dem Weg gehen kann.
Es ist besser, die Linien im EOR-Modus zu zeichnen, um das Problem der oberen
und unteren Scheitelpunkte zu beseitigen. Wir stellen auch sicher, dass die
Linien immer von oben nach unten gezeichnet werden und, bevor wir sie zeichnen, 
invertieren wir (mit einem BCHG) das erste Pixel. Auf diese Weise wird dieses
Pixel zweimal invertiert. Auf diese Weise wird dieses Pixel 2 Mal invertiert
(durch das BCHG und dann durch den Blitt) und wird daher unverändert bleiben. 
Auf diese Weise ist das Problem gelöst. 
In der Tat (da wir die Punkte geordnet haben) wird jeder Zwischenpunkt einmal
als letztes Pixel einer Zeile gezeichnet (und daher wird er auf 1 gesetzt) und
einmal als erstes Pixel der anderen Zeile (und bleibt daher unverändert, also 
auf 1).

Diese Technik wird im Beispiel Listing10s.s vorgestellt.

Kehren wir nun zur Behandlung von Linien zurück, um eine Besonderheit zu
zeigen. Es ist möglich, 2 Pixel breite Linien zu zeichnen, indem man einfach 
den Initialisierungswert von BLTBDAT ändert. Die Technik wird im Beispiel  
Listing10t1.s veranschaulicht. Im Beispiel Listing10t2.s wird stattdessen eine
bessere Routine zum Zeichnen von Linien vorgestellt, als die bisher verwendete.
	 
In der Tat nutzt diese Routine viele Eigenheiten des 68000-Assemblers aus, um
die Berechnung und das Laden der Blitter-Register zu optimieren.	 

	   
                    /\\    ____  ,^-o,
        _a' /(   <.    `-,'    `-';~~
     ~~ _}\ \(  _  )     ',-'~`../     ,         \         .'"v"'.
           \(._(.)'      `^^    `^^  .:/          \ /\     = 'm' =
          ._> _>.   |\__/|        ,,///;,   ,;/   ( )      " \|/ "--_o
      @..@          /     \      o:::::::;;///  .( o ).   /m"..."m\
     (\--/)        /_.~ ~,_\    >::::::::;;\\\       _,/
    (.>__<.)          \@/        ''\\\\\'" ';\      <__ \_.---.
    ^^^  ^^^    A___A               ';\     _          \_  /   \
          ____ / o o \      O\   /O      .-/ )-""".      \)\ /\.\
       _/~____   =^= /       O>!<O     oP __/_)_(  )*      //   \\
      <______>__m_m_>        o   o      "(__/ (___/      ,/'     `\_,
       _____                                              _____
    oo/><><>\    ()-()                       ((((     ~..~     \9
   ( -)><><><>   (o o)      AMIGA RULEZ     ( )(:[    (oo)_____/
     L|_|L|_|'   /\o/\                      ((((        WW  WW
          _                   ,--,      ___
        ('v')           _ ___/ /\|    {~._.~}      __    __  
        (,_,)       ,;'( )__,  ) ~     ( Y )    o-''))_____\\
      .,;;;;;,.    //  //   '--;      ()~*~()   "--__/ * * * )
     .;;'|/';;;;'  '   \     | ^      (_)-(_)   c_c__/-c____/
	 
Zum Abschluss der Lektion stellen wir einige Effekte vor, die durch Linien und 
Füllungen erzeugt werden in den Beispielen Listing10u1.s, Listing10u2.s,
Listing10v.s, Listing10x.s. Insbesondere im letzten Listing werden Sie eine der
Haupttechniken der legendären "State of the Art" Demo sehen !!
								     ^    ^