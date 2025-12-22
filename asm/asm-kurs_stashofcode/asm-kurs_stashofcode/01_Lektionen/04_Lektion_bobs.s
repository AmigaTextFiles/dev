
; Lektion 04

SPRITES UND BOBS AUF AMIGA OCS UND AGA ANZEIGEN (2/2)

12. Juli 2018 Amiga, Assembler 68000, Blitter, BOBs

Dieser Artikel ist der zweite - und damit der letzte - in einer Reihe von
zweien, die sich der Darstellung von Bitmaps auf dem Amiga widmen. Im ersten
Artikel haben wir uns ausführlich mit den Hardware Sprites beschäftigt.
Bei dieser Gelegenheit schien es, dass Sprites wie Hobbits sind: praktisch und
bunt, aber klein und wenige in der Anzahl. Und selbst wenn die Hardware es
ermöglicht, die Anzahl scheinbar durch Schneiden oder Wiederholen zu
multiplizieren, bleibt die Verwendung dieser Tricks ziemlich restriktiv.
Aus diesem Grund wurde oft eine andere Lösung für die Anzeige von Bitmaps
bevorzugt: BOBs. Das BOB ist eine Bitmap, die mit dem Blitter angezeigt wird,
dem Chip, dessen berüchtigtstes Merkmal das Kopieren von Daten aus einem
oder mehreren Speicherbereichen in einen anderen ist.

Bild: Vektorkugeln (mit einigen geraden Linien, um das 3D besser zu sehen) 
	; figure0-15.png

Wie zeige ich einen BOB an? Und sollte man sich dann nicht um all jene Aufgaben
kümmern, die bei Sprites automatisch von der Hardware erledigt wurden: 
Transparenz, Wiederherstellung, Clipping, Kollisionserkennung etc.? All dies
und mehr im Folgenden.
Update vom 08.05.2018: Klarstellung zur Notwendigkeit, b (die Umkehrung der
	Maske) und nicht B (die Maske) als Quelle in der logischen Kombination zu
	verwenden, die von der Blitter verwendet wird.
Update vom 08.11.2018: Hinzufügen von perfectBob.s im Archiv, eine verbesserte
	Version von bobRAWB.s, bei der der rechteckige Teil des Hintergrunds, den
	der BOB abdeckt, im Blitter präzise oder global wiederhergestellt wird.
Update vom 14.08.2018: Update von bobRAW.s und bobRAWB.s im Archiv, da die
	vorgeschlagenen Versionen die vorgestellte Maskierung nicht implementiert
	haben!
Update vom 10.01.2018: Alle Quellen wurden geändert, um einen Abschnitt
	"StingRay's Stuff" aufzunehmen, der den ordnungsgemäßen Betrieb aller
	Amiga-Modelle, einschließlich einer Grafikkarte, gewährleistet.

Klicken Sie hier, um das Archiv mit dem Code und den Daten der hier 
vorgestellten Programme herunterzuladen.

Dieses Archiv enthält mehrere Quellen:
bobRAW.s		für die einfache Darstellung eines Bobs in RAW;
bobRAWB.s		für die einfache Darstellung eines Bobs in RAWB;
unlimitedBobs.s für die Wirkung von unbegrenzten Bobs;
vectorBalls.s	für die Wirkung von Vektorbällen.

NB: Dieser Artikel liest sich am besten, wenn man sich das ausgezeichnete Modul
anhört, das Spirit / LSD für das Graphevine diskmag #14 komponiert hat, aber es
ist eine Frage des persönlichen Geschmacks...

VERSCHIEBEN, VERSTECKEN UND KOMBINIEREN MIT DEM BLITTER

Da Sprites von der Hardware unterstützt werden, haben sie viele Vorteile für
den Coder. Letzterer muss nämlich nicht mit der Transparenz (Maskierung)
umgehen; der Erhaltung und Restaurierung des Hintergrunds, auf dem es
dargestellt wird (die Wiederherstellung); Schneiden, das bis zur Eliminierung
gehen kann, wenn sie überlaufen oder das Abgespielte verlassen (Clipping);
Prioritäten zwischen Sprites und zwischen Sprites und Bitebenen; Das Management
von Kollisionen zwischen Sprites und zwischen Sprites und Bitebenen. Sprites
sind jedoch wie Hobbits: praktisch und bunt, aber klein und wenige an der Zahl.

BOBs leiden nicht unter solchen Einschränkungen. Da ein BOB eine Bitmap ist,
die angezeigt wird, weil sie in den Bitebenen gezeichnet ist, hat der Coder
vollen Spielraum, um die Größe und Tiefe des BOBs anzupassen. Wenn die Hardware
jedoch das Zeichnen des BOBs vereinfacht, bietet sie keine Leichtigkeit, alle
im Moment genannten Aufgaben zu verwalten, indem die Sprites präsentiert
werden: Maskieren, Wiederherstellen, Clipping, Prioritäten, Kollisionen.

Der BOB wird im Blitter angezeigt. Wie in einem früheren Artikel erläutert,
ermöglicht es dieser Chip, mehrere Blöcke (Quellen A, B und C) durch
logische Operationen zu kombinieren und das Ergebnis in einen anderen Block
(Ziel D) zu schreiben, indem er von 0 auf 15 Bits A und B auf der rechten
Seite wechselt und das erste und letzte Wort von A ausblendet.

Denken Sie daran, dass ein Block nicht mehr und nicht weniger als eine Abfolge
von Wörtern im Speicher ist, von denen es möglich ist, eine bestimmte Anzahl
von Wörtern periodisch zu ignorieren. Der Blitter schlägt vor, einen Block mit
einer Anfangsadresse, einer Breite (in Worten), einem Modulo und einer Höhe
(in Wortzeilen) zu beschreiben, als wäre es ein Rechteck. Zum Beispiel wird ein
Block von 28 Wörtern, von denen alle 5 Wörter 2 Wörter ignoriert werden, als
ein Block von 5 Wörtern Breite und 4 Zeilen Höhe dargestellt, mit einem Modulo
von 2 Wörtern (der Pfeil verläuft durch die Wörter zu aufeinanderfolgenden 
Adressen):

Bild: Ein Speicherblock, wie er vom Blitter gesehen wird 
	; figure1-12-768x257.png

Der Blitter bietet viele Möglichkeiten, A, B und C zu kombinieren. Zunächst
werden die Bits durch UND kombiniert, nachdem sie möglicherweise umgekehrt
wurden. Alle möglichen Kombinationen, die als Minterms bezeichnet werden,
werden mit den Buchstaben A, B und C (nicht invertierte Quellen) oder
a, b und c (invertierte Quellen) bezeichnet. In einem zweiten Schritt werden
die vom Coder gewählten Minterms durch OR miteinander kombiniert:

Bild: Phasen der Bit-zu-Bit-Kombination von Quellen durch den Blitter
	; figure2-12-768x305.png

All dies ermöglicht es, das Interesse des Blitters zu identifizieren, das
Äquivalent eines Sprites anzuzeigen. Dazu ist es notwendig, drei Quellen zu
kombinieren:

die Bitmap			(A)
die Maske			(B)	
der Hintergrund		(C)

Die Maske (B) wird durch AND mit dem Hintergrund (C) kombiniert, in dem das BOB
angezeigt werden soll. Dadurch werden Pixel aus der Landschaft entfernt, in der
nicht transparente Pixel aus der Bitmap angezeigt werden sollen. Die Bitmap (A)
wird dann durch OR mit dem Hintergrund (C) an der gleichen Position kombiniert,
so dass ihre nicht transparenten Pixel anstelle der gerade gelöschten angezeigt
werden.

Ein Beispiel mit einer charmanten kleinen Fee von 16 x 16 Pixeln, gezeichnet
von Ihrem Diener mit dem ausgezeichneten Pro Motion NG:

Bild: Die Schritte zum Anzeigen eines BOB ; figure3-10-400x340.png

Bevor bestimmt wird, welche Minterms der Blitter per OR kombinieren muss, um
dieses Ergebnis zu erzielen, muss ein kleines Problem gelöst werden. Wie
bereits erwähnt, kopiert der Blitter keine Pixel, sondern Wörter. Wie zeigt
man also die Bitmap und die Maske aus einem Pixel der Szenerie an, dessen
Abszisse nicht unbedingt ein Vielfaches von 16 ist?
Natürlich wurde dieser Bedarf von den Hardware-Designern antizipiert. Mit dem
Blitter können Sie A und B nach rechts verschieben, mit einer Anzahl von Bits
zwischen 0 und 15. Der Offset von A ist unabhängig von dem von B. Wenn die
Linien eines Blocks somit versetzt werden, werden die Bits, die rechts von der
Y-Linie gejagt werden, links von der Y+1-Linie wieder eingeführt. Zeile 0 ist
ein Sonderfall: Da es keine vorherige Zeile gibt, werden auf der linken Seite
0s eingeführt:

Bild: 4-Bit-Offset von einer Quelle von N Zeilen von 1 Wort zum Blitter
	; figure4-10-768x202.png

Wie am Beispiel eines 4-Pixel-Offsets eines Blocks eines breiten Wortes, das in
der Abbildung dargestellt ist, zu sehen ist, werden dann die niederwertigen Bits
des letzten Wortes der letzten Zeile nach rechts gejagt und eliminiert.
Wenn die Breite des Blocks die Breite der anzuzeigenden Bitmap bleibt, erleidet
diese Bitmap eine inakzeptable Verzerrung. Gleiches Beispiel für die Fee, wenn
sie einen Versatz von 4 Pixeln durchläuft (aus Gründen der Lesbarkeit werden
die Pixel der Farbe 0, transparent, links von der ersten Zeile eingefügt, rot
angezeigt):

Bild: Verformung eines Blocks, der seine Breite während eines Versatzes 
	beibehält ; figure5-9.png

Um die gesamte Bitmap im Block zu behalten, müssen Sie zuerst die Breite des
Blocks um ein Wort rechts erhöhen (aus Gründen der Lesbarkeit werden Pixel der
Farbe 0, transparent, rechts von den Zeilen in Grün angezeigt). Nach dem Offset
ist es notwendig, die überflüssigen Bits links und rechts, dh Bits des ersten
und letzten Wortes jeder Zeile des Blocks, auszublenden, bevor der Block mit
dem entsprechenden Block in der Einstellung kombiniert wird. Das bedeutet,
wenn die Bitmap versetzt ist, muss ihre Maske auf die gleiche Weise versetzt
werden:

Bild: Die Erweiterung des Blocks erfordert eine Maskierung 
	; figure6-7-400x166.png

DER SPEZIALFALL A UND DER ALLGEMEINE FALL VON B

An dieser Stelle sollte beachtet werden, dass der Blitter das erste und letzte
Wort jeder Zeile von A verbergen kann. Ist es durch die Ausnutzung dieser
Möglichkeit nicht möglich, auf das Hinzufügen einer Wortspalte rechts neben
der Bitmap und sogar einer Maske in einem bestimmten, aber dennoch häufigen
Fall zu verzichten: wenn die Bitmap auf einer Einstellung angezeigt wird, bei
der ihre undurchsichtigen Pixel nur Pixel der Farbe 0 ersetzen?

In der Tat, aber damit es funktioniert, reicht es nicht aus, diese Masken
anzugeben. Wir müssen auch auf dem Modulo von A spielen.
Um zu verstehen, wie es darum geht, ist es notwendig, auf die Details des
Verlaufs einer Kopie beim Blitter einzugehen.
Wie bereits dargestellt, kombiniert der Blitter die Wörter aus den Quellen
A, B und C und kopiert das Ergebnis in ein Wort ans Ziel D. Es geht Wort für
Wort vor und erhöht die Adressen, die in den Registern BLTxPTH und BLTxPTL
enthalten sind, zum Beispiel BLTAPTH und BLTAPTL für A. Darüber hinaus addiert
der Blitter am Ende jeder Zeile der Adresse von A, B, C und D den in BLTxMOD
enthaltenen Wert, z.B. BLTAMOD. Wenn es also A sein sollte, sollte der Block
der Figur vor einer Kopie, die ihn impliziert, wie folgt angegeben werden:
	
	move.l #blockA,d0
	move.w d0,BLTAPTL(a5)
	swap d0
	move.w d0,BLTAPTH(a5)
	move.w #2*2,BLTAMOD(a5)	; Modulo wird in Bytes angegeben
	;...
	blockA:		BLK.W 7*4,0

Denken Sie daran, dass der Blitter zum Zeitpunkt des Kopierens über die Breite
und Höhe der beteiligten Blöcke informiert wird. In der Tat, indem wir eine
Kombination dieser Werte in BLTSIZE schreiben, geben wir sie an, während wir
gleichzeitig die Kopie auslösen (deren Begriff gewartet werden muss, indem
zweimal ein bisschen DMACONR getestet wird, was das Makro hier erwähnt 
WAIT_BLITTER):

	BLOCK_WIDTH=7			; In Worten!
	BLOCK_HEIGHT=4			; In Pixeln
	move.w #(BLOCK_HEIGHT<<6)!BLOCK_WIDTH,BLTSIZE(a5)
	WAIT_BLITTER

Der Trick besteht darin, einen Modulo... negativ, von -2, um genauer zu sein.
So beginnt der Blitter am Ende der Kopie einer Zeile Y von A die Zeile Y + 1
nicht beim ersten Wort des letzteren, sondern beim letzten Wort der Zeile Y.
Die folgende Abbildung zeigt, was in beiden Fällen passiert, wenn ein Block mit
zwei Wörtern in drei Zeilen kopiert wird: mit oder ohne zusätzliche Wortspalte:
Im ersten Fall, am Ende der Kopie der ersten Zeile, wobei das modulo 0 ist,
zeigt der Blitter auf das erste Wort der zweiten Zeile (sein erstes Bit ist
rot eingerahmt). Er kopiert diese Zeile, indem er in die linken Teile des
letzten Wortes injiziert, das er gelesen hat, also vom Ende der ersten Zeile
der zusätzlichen Wortspalte (in dunkelgrau).
Im zweiten Fall, am Ende der Kopie der ersten Zeile, wobei der Modulo -2 ist,
zeigt der Blitter auf dieselbe Stelle. Nachdem er zwei Wörter vom Anfang der
ersten Zeile kopiert hatte, hätte er auf das erste Wort in der dritten Zeile
zeigen sollen, aber durch das Hinzufügen des Modulos schickte er ein Wort
zurück. Er kopiert diese Zeile, indem er in die linken Teile des letzten Wortes
injiziert, das er gelesen hat, also vom Ende der zweiten Zeile der zusätzlichen
Wortspalte (in dunkelgrün).

Bild: Kopieren von zwei Wörtern in die zweite Zeile eines Blocks mit oder ohne
zusätzliche Wortspalte	; figure7-7-768x373.png

Um die überflüssigen Teile sowohl links als auch rechts von denen in der Linie
zu eliminieren, bleibt nur, die Möglichkeit des Blitters auszunutzen, das erste
und letzte Wort von A zu verbergen. Die Masken, die der Blitter mit diesen
Wörtern kombiniert, müssen in den BLTAFWM- bzw. BLTALWM-Registern angegeben
werden. Da die Kombination durch AND erfolgt, müssen die Bits der Masken, die
den überflüssigen Bits entsprechen, gelöscht werden, während die anderen Bits
positioniert werden müssen. Diese Masken müssen nicht verschoben werden, da der
Blitter sie auf das erste und letzte Wort jeder Zeile anwendet, BEVOR sie
letztere verschieben. Kurz gesagt, unabhängig vom Offset im Zusammenhang mit
der Anzeige eines BOB sollten ihre Werte $FFFF bzw. $0000 betragen.
Im Anschluss an die vorherige Abbildung wird in der folgenden Abbildung
beschrieben, was beim Kopieren der zweiten Zeile geschieht. Seien Sie
vorsichtig, Sie müssen folgen! Diese Kopie besteht aus zwei Wörtern: dem Wort,
das die zweite Zeile bildet (in grün), gefolgt von dem Wort, das die dritte
Zeile bildet (in blau). Am Ende dieser Kopie wurden alle Teile des Wortes des
zweiten Wortes nach dem UND mit BLTALWM gelöscht. Darüber hinaus sind die
letzten vier so gelöschten Bits bereit, während der bevorstehenden Kopie links
vom ersten Wort der dritten Zeile (in blau) injiziert zu werden. Dies geschah
bereits beim Kopieren der ersten Zeile (in rot), und deshalb erscheinen die
0 Bits, die beim Kopieren der zweiten Zeile (in grün) injiziert wurden, in
dunkelgrün: Dies sind die letzten vier Bits des Wortes, die die zweite Zeile
(in grün) bilden, die nach dem AND mit BLTALWM gelöscht wurden.

Bild: Ausblenden des ersten und letzten Wortes von A ; figure8-5-768x243.png	

Am Ende lautet der Code zum Anzeigen eines BOB von BOB_DX x BOB_DY Pixeln,
bestehend aus einer einzelnen Bitebene (an der Adresse bob), auf einer
DISPLAY_DX x DISPLAY_DY Pixeln, die aus einer einzelnen Bitebene
(an der backBuffer-Adresse) bestehen, wie folgt:
	
	lea bob,a0
	move.w #BOB_X,d0
	move.w d0,d1
	and.w #$F,d0
	ror.w #4,d0
	or.w #$0BFA,d0
	move.w d0,BLTCON0(a5)
	lsr.w #3,d1
	and.b #$FE,d1
	move.w #BOB_Y,d0
	mulu #DISPLAY_DX>>3,d0
	add.w d1,d0
	movea.l backBuffer,a1
	lea (a1,d0.w),a1
	move.w #$0000,BLTCON1(a5)
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$0000,BLTALWM(a5)
	move.w #-2,BLTAMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTCMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTDMOD(a5)
	move.l a0,BLTAPTH(a5)
	move.l a1,BLTCPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #(BOB_DY<<6)!((BOB_DX+16)>>4),BLTSIZE(a5)
	WAIT_BLITTER

Die Rolle der anderen Register, die in diesem Code verwendet werden, wird im
Folgenden erläutert.
Die Lösung, die gerade vorgestellt wurde, ist praktisch, weil sie es Ihnen
ermöglicht, keine zusätzliche Wortspalte einführen zu müssen, aber sie
funktioniert nur für A. Tatsächlich kann der Blitter nur das erste und letzte
Wort einer Zeile von A ausblenden, die der Bitmap entsprechen würde. Nichts für
B, was der Maske entsprechen würde.
Es ist jedoch wichtig zu wissen, dass diese Möglichkeit besteht, da Sie eine
Bitmap anzeigen können, ohne eine zusätzliche Wortspalte hinzufügen zu müssen
und ohne ihre Maske bereitstellen zu müssen:

Es ist interessant, keine zusätzliche Wortspalte hinzufügen zu müssen, wenn die
Bitmap eine Extraktion eines Teils eines Bildes ist. Zum Beispiel, wenn es
darum geht, einen Teil einer Bitplane irgendwohin zu kopieren: Dieser Teil kann
also direkt genommen werden.
Es ist interessant, keine Maske erstellen zu müssen, wenn die Pixel der Bitmap
nur Pixel der Farbe 0 ersetzen. Zum Beispiel, wenn es darum geht, die
Buchstaben eines Bildlaufs auf einem Hintergrund der Farbe 0 anzuzeigen,
Buchstaben, die sich nie überlappen - ein Buchstabe kann durch ein einfaches
ODER mit dem Hintergrundangezeigt werden, ohne B für die Maske zu verwenden.
Und B, wer wird für die Maske verwendet? Es gibt keine Register, die BLTAFWM
und BLTALWM entsprechen, um das erste und letzte Wort jeder Zeile aus dieser
Quelle auszublenden. Unter diesen Bedingungen kann der Trick, einen Modulo von
-2 zu verwenden, um zu vermeiden, dass eine zusätzliche Wortspalte zu 0
hinzugefügt werden muss, nicht funktionieren.
Wie bereits erläutert, muss die Maske nach rechts verschoben werden, was
bedeutet, dass Teile auf der linken Seite injiziert und andere auf der rechten
Seite jeder ihrer Linien abgelehnt werden müssen, Zeilen, deren Länge um ein
Wort auf der rechten Seite vergrößert werden muss.
Aber wie positioniert man die überflüssigen Teile links und rechts, bevor man
UND die Maske mit dem Hintergrund kombiniert, um die Teile der entsprechenden
Dekoration zu erhalten? Die Masken BlTBFWM und BLTBLWM können nicht angewendet
werden, da sie nicht vorhanden sind. Daher müssen diese Bits bereits in der
Maske vorhanden sein, also müssen sie in einer zusätzlichen Spalte mit Wörtern
auf der rechten Seite erscheinen, deren Bits bei 1 wären.

Eine 1? Sehr logischerweise möchten wir, dass die Maske von UND mit dem Dekor
kombiniert wird, was bedeutet, dass die Teile der Maske 1 sein mussten, wo das
Hintergrund erhalten bleiben sollte, und 0, wo das Hintergrund gelöscht werden
sollte.
Wir haben jedoch gesehen, dass der Blitter Bits links von der ersten Zeile der
Maske einführt, um sie zu verschieben, und dass diese Bits notwendigerweise bei
0 liegen. Dies bedeutet, dass ein Bit bei 0 in der Maske einem Bit entsprechen
muss, das in der Einstellung beibehalten werden muss, während ein Bit bei 1 in
der Maske einem Bit entsprechen muss, das gelöscht werden muss. Deshalb ist es
b, das Gegenteil der Maske, und nicht B, die Maske, die von UND mit dem Hintergrund
kombiniert werden muss. Glücklicherweise ermöglicht es der Blitter, B oder
seine Umkehrung, b (für NICHT B), mit C zu kombinieren, was dem Hintergrund
entspricht.
Daher sollten die Bits in der zusätzlichen Wortspalte rechts neben der
Maske 0 und nicht 1 sein.

Zur Erinnerung:
A ist die Bitmap, die versetzt werden muss. Seine Daten enthalten keine 
	Wortspalte zusätzlich zu 0, aber das liegt daran, dass die ersten und
	letzten Wortmasken BLTAFWM und BLTALWM angewendet werden.
B ist die Maske, die versetzt werden muss. Seine Daten enthalten eine Spalte
	mit zusätzlichen Wörtern mit 0, da es keine solchen Masken für diese
	Quelle gibt, die ansonsten umgekehrt wird, bevor sie mit dem Hintergrund 
	kombiniert wird.
C	entspricht dem Hintergrund, das nicht verschoben werden sollte.

KOMBINIEREN SIE DIE MINTERMS, STARTEN SIE DEN BLITTER UND WARTEN SIE DARAUF.

Um den angezeigten Anzeigecode eines BOB vollständig zu verstehen (Sonderfall
des BOB, dessen undurchsichtige Pixel auf Pixeln der Farbe 0 angezeigt werden)
und den folgenden Code zu verstehen (allgemeiner Fall des BOB, dessen
undurchsichtige Pixel auf Pixeln beliebiger Farben angezeigt werden), bleibt es
zu verstehen, wie sie es ermöglichen, dem Blitter zu spezifizieren, wie
Quellen A, B und C kombiniert werden müssen, um den Bestimmungsort D zu 
erzeugen.
Wie bereits erläutert, kombiniert der Blitter die Quellen durch Kombination
durch OR-Minterms, die selbst das Produkt von Kombinationen durch UND der
Quellen sind, möglicherweise umgekehrt. Aber was soll es tun, wenn nicht die
folgende Kombination:

D=A+bC

Das Amiga Hardware Reference Manual erklärt, wie man die Minterms ableitet, die
aktiviert werden müssen, indem man die entsprechenden Bits in BLTCON0
positioniert. Fügen Sie einfach neutrale Faktoren zu den DNAs hinzu
(z.B. c + C, was notwendigerweise 1 ist) und erweitern und reduzieren Sie dann:

D=A(b+B)(c+C)+bC(a+A)
D=Abc+AbC+ABc+ABC+abC+AbC D=ABC+ABc+AbC+Abc+abC

Die acht Bits von BLTCON0, die für die Minterms reserviert sind, sind die
seines niederwertigen Bytes:

Minterm	ABC	ABc	AbC	Abc	aBC	aBc	abC	abc
Bit		7	6	5	4	3	2	1	0

In diesem Fall bedeutet dies, dass das Byte auf $F2 gesetzt werden muss.
Der Rest der Konfiguration des Blitters besteht lediglich darin, anzugeben,
dass er A, B, C und D aktivieren muss, und den Wert des Versatzes auf der
Linie von A und den Wert des Offset von B anzugeben. Andere Bits von BLTCON0
und BLTCON1 werden für diese Zwecke verwendet - siehe das Amiga Hardware
Reference Manual, das hier nicht neu geschrieben werden soll, um sie zu
identifizieren.
Nachdem nun alles präsentiert wurde, ist es möglich, den Anzeigecode eines
versteckten BOBs zu schreiben, von dem bob die Adresse der Bitmap und bobMask
die seiner Maske ist:
	
	moveq #0,d1
	move.w #BOB_X,d0
	subi.w #BOB_DX>>1,d0
	move.w d0,d1
	and.w #$F,d0
	ror.w #4,d0
	move.w d0,BLTCON1(a5)
	or.w #$0FF2,d0
	move.w d0,BLTCON0(a5)
	lsr.w #3,d1
	and.b #$FE,d1
	move.w #BOB_Y,d0
	subi.w #BOB_DY>>1,d0
	mulu #DISPLAY_DEPTH*(DISPLAY_DX>>3),d0
	add.l d1,d0
	move.l backBuffer,d1
	add.l d1,d0
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$0000,BLTALWM(a5)
	move.w #-2,BLTAMOD(a5)
	move.w #0,BLTBMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTCMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTDMOD(a5)
	move.l #bob,BLTAPTH(a5)
	move.l #bobMask,BLTBPTH(a5)
	move.l d0,BLTCPTH(a5)
	move.l d0,BLTDPTH(a5)
	move.w #(DISPLAY_DEPTH*(BOB_DY<<6))!((BOB_DX+16)>>4),BLTSIZE(a5)

Der aufmerksame Leser muss sich noch am Kopf kratzen. Welche Werte werden in den
Registern BLTCMOD und BLTDMOD gespeichert?
Gerade ist eine Konstante aufgetaucht: DISPLAY_DEPTH. Mit dem Code können Sie
ein BOB DISPLAY_DEPTH Bitebenen tief in einer Einstellung mit derselben Tiefe
anzeigen. Dies wirft ein interessantes Problem auf.
Wenn die Daten der Bitmap, der Maske und der Szenerie wie gewohnt organisiert
sind, folgen auf die Daten der Bitebene 1 die der Bitebene 2 und so weiter.
Dies führt dazu, dass die Bitebenen der Bitmap angezeigt und nacheinander in
einer Schleife maskiert werden, da der Modulo, der verwendet wird, um sich in D
von einer Zeile zur anderen zu bewegen, also (DISPLAY_DX-(BOB_DX+16))>>3 nicht
verwendet werden kann, um von der letzten Zeile einer Bitebene zur ersten
Zeile zu gelangen, die im Folgenden verwendet wird:

; Angenommen, a2 zeigt auf das Wort der ersten Bitplane der Szenerie, in der
; das BOB angezeigt werden soll, und ruft nicht die Werte der anderen Register
; BLTAFWM, BLTALWM, BLTCON0, BLTCON1, BLTAMOD, BLTBMOD, BLTCMOD und BLTDMOD ab...

	lea bob,a0
	lea bobMask,a1
	move.w #DISPLAY_DEPTH-1,d0
_drawBobBitplanes:
	move.l a0,BLTAPTH(a5)
	move.l a1,BLTBPTH(a5)
	move.l a2,BLTCPTH(a5)
	move.l a2,BLTDPTH(a5)
	move.w #(BOB_DY<<6)!((BOB_DX+16)>>4),BLTSIZE(a5)
	addi.l #BOB_DY*(BOB_DX>>3),a0
	addi.l #BOB_DY*((BOB_DX+16)>>3),a1
	addi.l #DISPLAY_Y*(DISPLAY_DX>>3),a2
	WAIT_BLITTER
	dbf d0,_drawBobBitplanes

Diese Vorgehensweise zwingt Sie, nach jeder Kopie in einer Bitebene auf den
Blitter zu warten, bevor Sie zur nächsten Bitebene übergehen. Dies ermöglicht
es nicht, den parallelen Betrieb von Blitter und CPU zu nutzen, außer
anlässlich der letzten Kopie - es wäre dann notwendig, das Makro nicht
WAIT_BLITTER aufzurufen, was daher zwingen würde, die ersten Schleifen von den
letzten zu unterscheiden, um mehr hinzuzufügen.
Ist es nicht möglich, die Bitebenen der Bitmap und die Maske gleichzeitig in
die der Bitplanes zu kopieren? Das stimmt:
Nachdem eine Zeile einer Bitebene angezeigt wurde, addiert die Hardware den
Wert von BPL1MOD (ungerade Bitplane) oder BPL2MOD (gerade Bitplane) zur
aktuellen Adresse in der Bitebene, um zur nächsten Zeile zu wechseln. Der Wert
eines solchen Registers kann auf (DISPLAY_DEPTH-1)*(DISPLAY_DX>>3) gesetzt
werden, um die Linien der Bitebenen (gerade oder ungerade, je nach Register)
in den Hintergrunddaten zu verweben.
Der Blitter seinerseits ermöglicht es, den Wert eines Modulo über BLTAMOD,
BLTBMOD und BLTCMOD für A, B und C zu fixieren und damit auch hier die Linien
der Bitebenen (gerade und ungerade, ohne Unterschied) in die Daten der Bitmap,
der Maske und des Hintergrunds, also A, B, C und D, einzuweben.
Die Organisation der Daten ist daher sehr unterschiedlich, je nachdem, ob es
sich um klassische Daten handelt, genannt RAW ("foundry crude"), oder
optimiert, genannt RAWB (RAW Blitter). Die folgende Abbildung vergleicht sie
im Falle einer Bitmap, die 16 Pixel breit und 2 Zeilen hoch ist:

Bild: Organisation der Bitmap-Daten eines BOB in RAW und RAWB 
	; figure9-3-768x419.png

Abschließend (weil es endlich vorbei ist!) untersuchen die Programme bobRAW.s
und bobRAWB.s jede der Lösungen, um ein BOB von 64 x 64 Pixeln auf 5-Bitebenen
anzuzeigen:

Bild: Anzeige eines BOB von 64 x 64 Pixeln auf 5 Bitebenen ; figure10-4.png

In diesen Programmen ändert sich die Hintergrundfarbe zu Beginn des Betriebs in
Rot und am Ende in Grün. Es ist kein Unterschied zu beobachten, aber das liegt
daran, dass der Blitter in beiden Programmen am Ende jeder Kopie systematisch
erwartet wird.
Das Programm bobRAWB.s könnte modifiziert werden, um CPU-Operationen
auszuführen, während das BOB in allen 5-Bitebenen angezeigt wird. Das Programm
bobRAW.s könnte auf die gleiche Weise modifiziert werden, aber damit diese
Operationen an der CPU ausgeführt werden können, während das BOB nur in der
letzten Bitebene angezeigt wird. Der Unterschied konnte dann festgestellt
werden. Aus diesem Grund, wenn die Verwendung von RAW in besonderen Fällen
notwendig sein kann, ist es in der Regel das RAWB, das verwendet werden sollte,
wenn es um die Anzeige von BOBs geht.

UNBEGRENZTE BOBS: BOBS IN HÜLLE UND FÜLLE, WIRKLICH?

BOBs werden verwendet, um eine Vielzahl von Effekten zu erzeugen, von denen die
berüchtigtsten unbegrenzte BOBs und Vektorbälle sind.
"Die Möglichkeiten des Amiga sind jenseits deiner Vorstellungskraft geplatzt.
Und das Ergebnis ist, was Sie !!! sehen", verkündet stolz der Autor einer
Schriftrolle der berühmten Megademo von Dragons. Übermäßig Vintage, enthält
diese Demo einen sehr klassischen Effekt zu der Zeit, sagt unbegrenzte BOBs.
Jedem Frame wird sichtbar ein BOB hinzugefügt, und der Zähler scheint
anzuzeigen, dass er niemals aufhören wird. Die Leistung wird durch diese
Multiplikation von BOBs in keiner Weise bestraft:
2.000 BOBs im frame, und es ist noch nicht vorbei! (Megademo von Dragons)

Im Leben ist NICHTS kostenlos, und vor allem nicht BOBs. Es gibt also einen
Trick. Bevor wir ins Detail gehen, lassen Sie uns einen BOB von 16 x 16 Pixeln
in 4 Farben erhalten, der immer mit dem ausgezeichneten Pro Motion NG
gezeichnet wird:

Bild: BOB, dein Kumpel von 16 x 16 Pixeln auf zwei Bitplanes ; figure11-3.png

Was angezeigt wird, ist eine Animation, in der das BOB einer Flugbahn folgt und
deren Prinzip wie folgt lautet. Die Anzahl der Bilder wird z.B. auf 3 gesetzt.
Bei jedem Frame wird das Bild durch das nächste ersetzt und kehrt auf das
erste zurück. Eine Serie von 3 Bildern von 0 bis 2 bildet einen Zeitraum:

In Periode 0 wird ein BOB an den Positionen P0, P1 und P3 in den
Bildern 0, 1 bzw. 2 angezeigt.
In Periode 1 wird ein BOB zu den Positionen P4, P5 und P6 in den
Bildern 0, 1 bzw. 2 hinzugefügt;
etc.

Wenn also Bild 0 zum zweiten Mal angezeigt wird, scheint es, dass ein BOB zur
Anfangsposition des vorherigen BOB hinzugefügt wurde und dass es diesem BOB
über die folgenden Bilder folgt:

Bild: Die ersten beiden Perioden einer Drei-Frame-Animation 
	; figure13-2-400x275.png

Da es nie nur darum geht, bei jedem Frame ein neues BOB anzuzeigen, verbraucht
der Effekt fast keine Rechenzeit. Es ist also extrem einfach, aber gut
durchdacht. Was die Flugbahn betrifft, kann es jede sein.
Im unlimitedBobs.s-Programm wird die Position des BOB auf einem Kreis
berechnet, dessen Radius zwischen einem Minimum und einem Maximum oszilliert,
was es ermöglicht, die Monotonie zu durchbrechen:

Bild: Weitläufige Bobs ; figure14-1.png

VEKTORKUGELN, BOBS IN 3D

Anspruchsvoller: Vektorbälle. Eine Demo der Gruppe Impact liefert eine schöne
Illustration. Wie man sieht, geht es darum, BOBs darzustellen, die Kugeln an
bestimmten Positionen eines 3D-Modells darstellen:

Bild: Sehr schöne Vektorbälle (Vectorballs by Impact) ; figure15-1.png

Das Programm vectorBalls.s zeigt, ohne zu versuchen, es zu optimieren (um es
einfach zu halten, verwendet es sogar Blasensortierung ohne vorzeitige
Abschaltbedingung!), Wie man einen Effekt dieser Art erzeugt. Die Tatsache,
dass immer nur ein BOB verwendet wird, erlaubt es Ihnen nicht, die
Tiefenwirkung auf dem Screenshot zu visualisieren, aber alles ist sicherlich
da:

Bild: Unsere Vektorbälle. Ja, ja! Es ist in 3D! ; figure16.png

Auch wenn es aufwendiger ist als das von unbegrenzten BOBs, bleibt das Programm
der Vektorbälle einfach. Bei jedem Frame geht es darum, ein neues Bild zu
berechnen, indem Sie die folgenden Schritte ausführen:
Bitebenen löschen;
Wenden Sie einige Rotationen auf die 3D-Koordinaten der Modellpunkte an.
projizieren diese Punkte, um ihre 2D-Koordinaten zu bestimmen;
Sortieren Sie diese 2D-Koordinaten in der Reihenfolge der abnehmenden Tiefe
nach der Tiefe der 3D-Koordinaten, von denen sie abgeleitet werden.
Wenn Sie die Liste der 2D-Koordinaten in dieser Reihenfolge durchgehen, zeigen
Sie ein BOB an, dessen 2D-Koordinaten den Mittelpunkt angeben.
Beachten Sie, dass für den Erfolg des Effekts vermieden werden muss, dass eine
Kugel abrupt vor einer anderen verläuft, und damit die Punkte auf dem 3D-Modell
gut verteilt werden.
Dieser Effekt kann ausgefeilt werden, indem BOBs verwendet werden, die Kugeln
mit unterschiedlichen Farben darstellen und/oder deren Durchmesser je nach
Tiefe variiert, und indem Teile des Modells unabhängig voneinander animiert 
werden.

UM DEN BOBS EIN ENDE ZU SETZEN...

Diese Erklärungen, wie man ein BOB anzeigt und den Code verwendet, um zwei
Effekte zu erzeugen, unbegrenzte BOBs und Vektorbälle, die gegeben werden,
scheint alles über die beiden Artikel dieser kleinen Serie gesagt worden zu
sein, die der Anzeige von animierten Bitmaps auf Amiga OCS und AGA gewidmet
sind.
Wir dürfen nicht aus den Augen verlieren, dass es sich nur um grundlegende
Techniken handelt, deren Einsatz Raffinesse und Optimierung erfordert, um
erfolgreiche Effekte zu erzielen. Man könnte sich aber unter anderem eine
dritte Lösung vorstellen: animierte Bitmaps auf der CPU anzeigen, zum
Beispiel während der Blitter einen BOB und die Hardware die Sprites anzeigt.
Es gibt sicherlich viele Beispiele für eine solche Mischung von Techniken
in Spielen und Demos auf dem Amiga. Ein Computer, dessen Hardware nach wie
vor die faszinierendste ist!
	
