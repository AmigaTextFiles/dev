
; Lektion 03

ANZEIGE VON SPRITES UND BOBS AUF AMIGA OCS UND AGA (1/2)

6. Juli 2018 Amiga, 68000 Assembler, Copper, Sprites

Was ist bequemer als ein Sprite? Der Grafik-Coprozessor rendert es so, dass es
die Szenerie hinter seinen transparenten Pixeln zeigt, und bewahrt die Szenerie
hinter seinen anderen Pixeln, um sie wiederherzustellen, wenn das Sprite bewegt
wird. Außerdem wird das Sprite abgeschnitten, wenn es den Bildschirm verlässt.
Leider sind die Fähigkeiten des Amiga 500 in diesem Bereich sehr begrenzt. Acht
Sprites mit 16 Pixeln Breite, sogar unendlicher Höhe, in 4 Farben, darunter
eine transparente, nur? Es ist die Verschwendung ...
Dennoch behalten die Sprites eine gewisse Nützlichkeit, sofern ihr volles
Potenzial genutzt wird. So ist es möglich, sie zu einer Bitmap von bis zu
64 Pixel Breite, unendlicher Höhe, in 16 Farben, darunter insbesondere eine
transparente, zusammenzufügen. Oder es ist möglich, einige wiederzuverwenden,
um ein zusätzliches playfield zu erstellen, dessen Inhalt jedoch ein sich
wiederholendes Muster sein muss, das im besten Fall eine Breite von 48 Pixeln
und eine unendliche Höhe in wenigen Farben einnimmt. Außerdem verfügt die
Advanced Graphics Architecture, mit der der Amiga 1200 ausgestattet ist, über
recht umfangreiche Funktionalitäten in Sachen Sprites. Insbesondere reicht ihre
Einheitsbreite von 16 bis 64 Pixel.

Bild: Etwas bessere Sprites in AGA	; figure13-1.png

Wie werden Sprites angezeigt und wie werden Sprites verwendet, um eine große 
und schöne Bitmap oder ein zusätzliches playfield anzuzeigen? Und schließlich 
wie werden Sprites auf AGA verwendet, in dem Wissen, dass Commodore diese
Hardware nie dokumentiert hat? All dies und mehr in diesem ersten Artikel, der
der Anzeige von Sprites auf Amiga OCS und AGA gewidmet ist.
Update 08.07.2018: Fehler in triplePlayfield.s behoben.
Update vom 10.01.2018: Alle Sourcen wurden um eine "StingRay's stuff"-Sektion
erweitert, die den ordnungsgemäßen Betrieb auf allen Amiga-Modellen,
insbesondere mit Grafikkarte, gewährleistet.
Klicken Sie hier, um das Archiv herunterzuladen, das den Code und die Daten
der hier vorgestellten Programme enthält.

Dieses Archiv enthält mehrere Quellen:
 - spriteCPU.s für die einfache Anzeige eines Sprites auf der CPU
   (dh: ohne DMA);
 - sprites.s zum einfachen Anzeigen und Verschieben eines Sprites;
 - sprites16.s zum einfachen Anzeigen und Verschieben eines Sprites in 16
   Farben;
 - spritesField.s für die Wiederverwendung von Sprites wie für einen
   sternenklaren Hintergrund;
 - spritesCollision.s zum Erkennen von Kollisionen zwischen zwei Sprites und
   zwischen diesen Sprites und einer Bitebene;
 - triplePlayfield.s zum Anzeigen einer Sprite-Map (mit Dual-Playfield, wenn
   wir schon dabei sind);
 - spritesAGA.s zum Anzeigen von Sprites mit dem AA-Chipsatz.

NB: Dieser Artikel wird am besten gelesen, wenn man sich das hervorragende
Modul anhört, das von Spirit / LSD für das Graphevine Diskmag #14 komponiert
wurde, aber das ist eine Frage des persönlichen Geschmacks ...

DER B-A-BA: ZEIGT EINEN SPRITE, UM ZU BEGINNEN

Dieser Artikel setzt eine gewisse Vertrautheit, wenn nicht sogar eine gewisse
Vertrautheit, mit der Programmierung der Amiga-Hardware in Assembler voraus.
Um sich mit letzterem vertraut zu machen und insbesondere eine
Entwicklungsumgebung zu installieren, greifen Sie am besten auf die hier
veröffentlichten Artikelserien zurück, die sich mit der Programmierung eines
Sinus-Scrolls befassen: 1,2,3,4 und 5.

Der Amiga hat einen Grafik-Coprozessor namens Copper. Der Copper führt bei
jeder Bildschirmaktualisierung eine Reihe von Anweisungen aus. Diese Befehle
umfassen Schreibvorgänge in Hardwareregister, von denen einige Sprites steuern.
Die Hardware kann acht Sprites mit einer Breite von 16 Pixeln in 4 Farben,
einschließlich einer transparenten Farbe, auf einer unbegrenzten Höhe anzeigen.
Die Sprites sind gekoppelt (die 0 mit der 1, die 2 mit der 3 usw.). In einigen
teilen sich die Sprites dieselbe 4-Farben-Palette, die nur eine Teilmenge der
32-Farben-Palette ist, die zum Anzeigen von Pixeln auf dem Bildschirm verwendet
wird. Unter diesen Bedingungen ist die Struktur dieser letzten Palette wie
folgt (die Erwähnung der playfielder wird später erklärt):

Color		Verwendung
00 bis 07	playfield 1 (Bitplanes 1, 3 und 5)
08 bis 15	playfield 2 (Bitplanes 2, 4 und 6)
16 bis 19	Sprites 0 und 1
20 bis 23	Sprites 2 und 3
24 bis 27	Sprites 4 und 5
28 bis 31	Sprites 6 und 7

Ein Sprite wird vollständig durch eine Folge von Wörtern beschrieben. Die
ersten beiden sind Steuerwörter, die nächsten sind Wörter, die kleine
Bitplanes Zeile für Zeile beschreiben, und die letzten sind 0.
Zum Beispiel für ein zweizeiliges Sprite:

Sprite:	
	DC.W $444C,$5401	; Steuerwörter
	DC.W $5555,$3333	; Erste Zeile mit 16 Pixeln
	DC.W $1234,$5678	; Zweite Zeile mit 16 Pixeln
	DC.W 0,0			; Ende

Für jede Zeile des Sprites werden die beiden Wörter miteinander kombiniert, um
die Farbindizes der 16 Pixel der Zeile abzuleiten. Wenn Sie mit diesem Beispiel
fortfahren, ist das Ergebnis für die erste Zeile das hier gezeigte:

Bild: Kombination der Wörter einer Datenzeile von Sprite 0 ; figure2-11.png

Wie zu sehen ist, liefert das erste Wort der Zeile die 0-Bits der Zeile und das
zweite Wort die 1-Bits.
Die Koordinaten (X,Y) und die Höhe eines Sprites (abgeleitet von der
Y + DY-Ordinate der Zeile nach der letzten Zeile des Sprites) sind in den
Steuerwörtern auf ziemlich exotische Weise codiert (Bit 7 des zweiten Wortes
ist für Sprite attach reserviert, was später besprochen wird). Um
beispielsweise ein Sprite oben links auf dem Bildschirm anzuzeigen, das
normalerweise bei ($81,$2C) beginnt:

Bild: Kodierung der Steuerworte eines Sprites DY Pixel hoch dargestellt in (X,Y)
	; figure3-9.png

Ja, im Gegensatz zu dem, was das Amiga Hardware Reference Manual behauptet,
müssen Sie X-1 und nicht X in den Steuerwörtern codieren. Dies ist ein
Dokumentationsfehler.
Konkret müssen die Steuerwörter also wie folgt codiert werden (in ASM-One ist
das Ausrufezeichen ein ODER, >> ist eine vorzeichenlose Verschiebung nach
rechts):

sprite:			
	DC.W ((Y&$FF)<<8)!(((X-1)&$1FE)>>1)
	DC.W (((Y+DY)&$FF)<<8)!((Y&$100)>>6)!(((Y+DY)&$100)>>7)!((X-1)&$1)

Um solche Berechnungen jedes Mal zu vermeiden, wenn ein Sprite bewegt werden
muss, besteht eine Technik darin, die zu kombinierenden Wörter für jede der
320 horizontalen Positionen einerseits und jede der vertikalen Positionen
andererseits vorzuberechnen. Weitere Informationen finden Sie in diesem
englischen Amiga Board-Forenthread. http://eab.abime.net/showthread.php?t=81835

Die Folge von Wörtern, die die Daten eines zu schreibenden Sprites bilden,
reicht aus, seine Adresse (die gerade sein muss) an die Hardware zu
übermitteln, damit sie das Sprite anzeigt. Jeder Sprite hat dafür SPRxPTH-
und SPRxPTL-Register. Beispielsweise:
	
	lea #dff000,a5
	move.l #sprite,d0
	move.w d0,SPR0PTL(a5)			; $DFF122
	swap d0
	move.w d0,SPR0PTH(a5)			; $DFF120

Tatsächlich werden Sprite-Adressen niemals auf diese Weise von der CPU
kommuniziert. MOVE-Befehle werden der Copper-Liste hinzugefügt, damit der
Copper sie bei jedem Frame kommuniziert:
	
	lea copperList,a0
	;... (Anfang der Copperliste)
	move.l #sprite,d0
	move.w #SPR0PTL,(a0)+
	move.w d0,(a0)+
	swap d0
	move.w #SPR0PTH,(a0)+
	move.w d0,(a0)+
	;... (Fortsetzung der Copperliste)
	
Sprites werden nur angezeigt, wenn die Hardware auf ihre Daten zugreifen kann,
wofür sie vom direkten Speicherzugriff (DMA) profitiert. Die Verwendung von DMA
ist nicht unbedingt erforderlich - es ist möglich, es zu ersetzen, indem durch
die CPU in die verschiedenen Register geschrieben wird, wo der DMA die Daten der
Sprites schreibt, um sie an die Hardware zu übermitteln: SPRxPOS, SPRxCTRL,
SPRxDATB und SPRxDATA. Das Programm spriteCPU.s geht wie folgt vor:
	
; Warten Sie, bis die erste Zeile des Sprites angezeigt wird

_waitSpriteStart:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #SPRITE_Y,d0
	blt _waitSpriteStart

; Sprite anzeigen. Sie sollten zuletzt in SPRxDATA schreiben, da dies der Weg
; ist, um die Anzeige des Sprites auszulösen.

	move.w #((SPRITE_Y&$FF)<<8)!(((SPRITE_X-1)&$1FE)>>1),SPR0POS(a5)
	move.w #(((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X-1)&$1),SPR0CTL(a5)
	move.w #$0F0F,SPR0DATB(a5)
	move.w #$00FF,SPR0DATA(a5)
	
; Warten Sie auf die Mittellinie des Sprites, um es horizontal neu zu
; positionieren (8 Pixel weiter rechts) und ändern Sie seine Daten

_waitSpriteMiddle:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #SPRITE_Y+(SPRITE_DY>>1),d0
	blt _waitSpriteMiddle
	move.w #((SPRITE_Y&$FF)<<8)!(((SPRITE_X+8-1)&$1FE)>>1),SPR0POS(a5)

; Write to SPRxCTL stoppt die Anzeige des Sprites, was eine horizontale
; Neupositionierung des Sprites auf Pixelgenauigkeit verbietet, es sei denn, es
; wird durch Schreiben in SPRxDATA wiederhergestellt, da sich Bit 0 dieser
; Position in SPRxCTL befindet. Mit anderen Worten, die drei folgenden Zeilen
; sind nur erforderlich, wenn die neue horizontale Position ungerade ist.

	move.w #(((SPRITE_Y+SPRITE_DY)&$FF)<<8)!((SPRITE_Y&$100)>>6)!(((SPRITE_Y+SPRITE_DY)&$100)>>7)!((SPRITE_X+9 -1)&$1),SPR0CTL(a5)
	move.w #$F0F0,SPR0DATB(a5)
	move.w #$FF00,SPR0DATA(a5)

; Warten Sie, bis die letzte Zeile des Sprites nicht mehr angezeigt wird,
; wenn Sie etwas in SPRxCTL schreiben.

_waitSpriteEnd:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #SPRITE_Y+SPRITE_DY,d0
	blt _waitSpriteEnd
	move.w #$0000,SPR0CTL(a5)

Diese Technik ist jedoch, wenn überhaupt, von geringem Interesse. Um ein Sprite
anzuzeigen, wäre es daher notwendig, eine Schleife zu schreiben, die auf den
Elektronenstrahl bei jeder Zeile warten würde, bei der eine Zeile des Sprites
angezeigt werden sollte, bevor der Inhalt der Register SPRxDATB und SPRxDATA
mit den Daten modifiziert wird der neuen Zeile des Sprites, was extrem
einschränkend wäre.
Daher wird DMA nicht emuliert, sondern verwendet. Zur Darstellung der Sprites
ist es daher notwendig, zumindest die DMA-Kanäle des Coppers, der Bitplanes und
der Sprites zu aktivieren:

	move.w #$83A0,DMACON(a5) ; DMAEN=1, BPLEN=1, COPEN=1, SPREN=1

Wie es vermuten lässt, gibt es keinen Mechanismus, um einen der acht Sprites
selektiv zu aktivieren. Um ein Sprite nicht anzuzeigen, müssen Sie der
Hardware mitteilen, dass die Höhe des Sprites null ist, indem Sie seine Daten
auf Steuerwörter mit 0 einstellen:

spriteVoid:
	DC.W 0, 0

Bezüglich DMA muss noch ein Detailpunkt erwähnt werden, der aber dennoch
wichtig ist. Sie müssen auf ein vertikales Leerzeichen warten, um den DMA-Kanal
der Sprites zu unterbrechen. Wenn andernfalls ein Sprite angezeigt wurde,
werden seine Daten weiterhin angezeigt. Dies erzeugt einen bekannten "vertikal
sabbernden Sprite"-Effekt.
Tatsächlich wird der DMA, wie zuvor erklärt, als es darum ging, ihn durch die
CPU zu emulieren, nur verwendet, um die Register SPRxPOS, SPRxCTL, SPRxDATA und
SPRxDATB zu laden, aus denen die Hardware systematisch die Daten der Sprites
liest, die sie mit denen der Bitplanes kombiniert. Wenn es geschnitten wird,
bevor es das letzte Wort auf 0 in SPRxPOS und SPRxCTL geschrieben hat (was es
tut, wenn es weiß, dass die Höhe des Sprites durchlaufen wurde, weshalb diese
beiden Wörter am Ende der Daten eines Sprites stehen müssen), die DMA kann
daher die Anzeige des Sprites nicht unterbrechen. Daher wird letzteres
weiterhin über die restliche Bildschirmhöhe mit den Daten angezeigt, die zum
Zeitpunkt des Schneidens des DMA in SPRxDATA und SPRxDATB vorhanden waren.
Aus diesem Grund warten die vorgeschlagenen Programme auf das vertikal blank
(VERTB), d.h. auf den Moment, in dem der Elektronenstrahl die Abtastung des
Bildschirms beendet hat, um den DMA zu schneiden (die Schleife wird in der
Unterroutine _waitVERTB berücksichtigt ):

_waitVERTBLoop:
	move.w INTREQR(a5),d0
	btst #5,d0
	beq _waitVERTBLoop
	move.w #$07FF,DMACON(a5)

KINETIK: SPRITES BEWEGEN UND KOLLISIONEN ERKENNEN

Um ein Sprite zu verschieben, müssen Sie lediglich seine Koordinaten in seinen
Steuerwörtern am Ende eines Frames ändern, bevor die Hardware es erneut liest,
um das neue Frame anzuzeigen. Das sprite.s- Programm bewegt somit ein Sprite 0
16 Pixel hoch in 4 Farben auf einem Hintergrund, der aus einer einzelnen
Bitebene besteht, die ein Schachbrett darstellt:

Bild: Sprite 0, in 4 Farben, kreist friedlich auf einer Bitplane ; figure4-9.png

Die Hardware ermöglicht es, die Tiefe über ein Prioritätensystem zu verwalten:
zwischen Sprites zuerst, Prioritäten sind festgelegt: Sprite 0 wird immer vor
Sprite 1 angezeigt, dieses wird immer vor Sprite 2 angezeigt usw.;
dann zwischen Sprites und playfieldern (zur Erinnerung, die Hardware kann ein
playfield mit 1 bis 6 Bitplanes oder zwei playfielder mit jeweils 1 bis 3
Bitplanes anzeigen - dies ist das Dual-Playfield), die Prioritäten können über
das BPLCON2-Register angepasst werden.

BPLCON2 setzt sich wie folgt zusammen:
Bits		Verwendung
15 bis 7	Unbenutzt (auf 0 gesetzt)
6			PF2PRI
5 bis 3		PF2P2 bis PF2P0
2 bis 0		PF1P2 bis PF1P0

Bei einem einzelnen playfield wird PF2P2-0 (nicht PF1P2-0, wie man annehmen
würde) verwendet. Sie erlauben es, auf 3 Bits die Nummer des Sprite-Paares
(und nicht des Sprites!) zu codieren, hinter dem sich das playfield befindet:

Bild: Ah! Ich habe dich. Dieser Artikel handelt von Amiga und nicht von Android!
	; figure5-7.png

Im Dual-Playfield ermöglichen es PF1P2 bis PF1P0, die Priorität des zweiten
Playfields und der Sprite-Paare auf die gleiche Weise zu verwalten. Beachten
Sie, dass sich diese Bits dann mit playfield 1 (Bitebenen 1, 3 und 5) befassen,
während PF2P2-0 sich mit playfield 2 (Bitebenen 2, 4 und 6) befasst. Das
PF2PRI-Bit ermöglicht es, playfield 2 vor playfield 1 zu passieren, was die
Möglichkeiten der Priorisierung zwischen Sprites und playfieldern erweitert.
In den bereits erwähnten Beispielen von Sprites in 4 und 16 Farben ist Sprite 0
vor dem einzigen Playfield positioniert und speichert somit $0008 in BPLCON2.
Abschließend sei erwähnt, dass die Hardware es einfach macht, eine Kollision
zwischen Sprites oder zwischen Sprites und Bitplanes zu erkennen, und zwar bis
auf den nächsten Pixel. Das Programm spritesCollision.s zeigt, wie es möglich
ist, Kollisionen zwischen Sprite 0 und Sprite 2 sowie zwischen jedem dieser
Sprites und Bitplane 1 zu erkennen:

Bild: Erkennung von Kollisionen zwischen Sprites und zwischen Sprites und Bitplane
	; collision.png

Die Kollisionserkennung ist ziemlich subtil. Es basiert auf der Verwendung von
zwei Registern:
 - Mit CLXCON können Sie angeben, welche Sprites und welche Bitplanes
   einbezogen werden sollen.
 - CLXDAT ermöglicht es, den Status der resultierenden Kollisionserkennung
   abzurufen.
An der Kollisionserkennung sind immer gerade Sprites beteiligt. Im CLXCON:
 - Die vier ENSP7-1-Bits ermöglichen die Angabe, dass auch ungerade Sprites
   beteiligt sein müssen, und 1: Es ist also nur dann wirklich sinnvoll, wenn
   diese Sprites angehängt werden, um ein Sprite in 16 Farben anzuzeigen.
 - Die sechs ENBP6-1-Bits werden verwendet, um anzugeben, ob die entsprechenden
   Bitplanes beteiligt werden sollen (wenn alle ausgeschlossen sind, wird eine
   Kollision mit den Bitplanes immer gemeldet, unabhängig von den Werten der
   MVBP6-1-Bits).
 - Die sechs MVBP6-1-Bits ermöglichen es, den Wert des Bits in einer Bitebene
   zu spezifizieren, die an der Erkennung von Kollisionen beteiligt ist,
   wodurch es möglich wird, zu bestimmen, ob eine Kollision mit dieser Bitebene
   vorliegt oder nicht.

Im Programm spritesCollision.s ist der Wert von CLXCON $0041, was dem Setzen
des ENBP1-Bits entspricht, um Bitebene 1 in die Kollisionserkennung
einzubeziehen, und des MVBP1-Bits, um anzugeben, dass eine Kollision mit
Bitebene 1 auftritt, wenn ein Bit auf 1 gefunden wird in Letzterem.
Es reicht aus, CLXDAT zu lesen (seien Sie vorsichtig, da dies es auf 0
zurücksetzt), um den Zustand der Kollisionen abzurufen, die zwischen zwei
Entitäten bei jedem Frame (zwischen Sprites oder zwischen Sprite und Bitplane
oder zwischen Bitplanes) erkannt wurden. In dieser Abbildung befindet sich
neben jedem Bit ein Kästchen pro Sprite (0 bis 7) sowie ein Kästchen für die
ungeraden Bitplanes (I) und eines für die geraden Bitplanes (P). Die Kästchen
sind farbig, um die erkannte Kollision anzuzeigen (erste Entität in Rot,
zweite in Grün).

Bild: Die Zusammensetzung des CLXDAT-Registers	; figure6-6.png

Beispielsweise wird Bit 7 gesetzt, wenn eine Kollision erkannt wird zwischen:
 - Sprite 4, ggf. per OR mit Sprite 5 verknüpft, wenn ENSP14 gesetzt ist;
 - die ungeraden Bitebenen, unter denen, deren ENBP-Bits gesetzt wurden, und
   für den Fall, wo ein Bit mit dem Wert MVBP angetroffen wurde.

Im Programm spritesCollision.s werden also die Bits 9, 1 und 2 getestet.
Indem es möglich ist, festzulegen, bei welchem ​​Bitwert eine Kollision
zwischen einem Sprite und bestimmten Bitplanes erkannt werden soll, macht es
die Hardware sehr einfach zu spezifizieren, dass eine Kollision nur erkannt
werden soll, wenn ein Sprite auf ein Pixel einer bestimmten Farbe
(möglicherweise transparent) trifft das Dekor. Mächtig.
Allerdings ist diese pixelgenaue Erkennung nicht unbedingt interessant. Ein
Programmierer von Amiga-Videospielen erklärte mir, dass es besser sei,
zusammenfassende Kollisionszonen zu verwenden, die in den Entitäten und der
Szenerie enthalten sind, um den Spieler weniger zu frustrieren. Insofern bleibt
die Hardware-Kollisionserkennung rudimentär. Vielleicht wurde es in Bezug auf
eine Zeit eingefügt, als die Pixel so groß waren, dass es kein Spielproblem
darstellte.

MEHR SPRITES: SPRITES ATTACH UND/ODER WIEDERVERWENDEN (MULTIPLEXEN).

Mit 4 Farben, darunter eine transparente, ist die Palette eines Sprites
besonders begrenzt. Zweifellos ist es möglich, Sprites zu überlagern, um die
Farben zu multiplizieren, aber das Übereinanderlegen von zwei Sprites erlaubt
nur, die Palette auf 8 Farben zu erweitern, darunter 2 transparente. Darüber
hinaus sollte daran erinnert werden, dass die Sprites gekoppelt sind und dass
die Sprites desselben Paares dieselbe Palette von 4 Farben teilen. Bestenfalls
wäre es also möglich, vier Sprites übereinander zu legen, was die Palette auf
16 Farben erweitert, darunter 4 transparente. Wenn man weiß, dass es acht
Sprites gibt, wäre es also nur möglich, zwei Sprites in 12 Farben anzuzeigen?
Nein. Wie bereits erwähnt, können die beiden Sprites, die ein Paar bilden, zu
einem einzigen Sprite kombiniert werden, der immer noch 16 Pixel breit ist,
aber diesmal in 16 Farben angezeigt wird (Farben 16 bis 31 der
Bildschirmpalette, wobei die Farbe 16 transparent ist). Die Leitungen des
ersten Sprites liefern die Bits für die kleinen Bitplanes 1 und 2 des Sprites,
während die Leitungen des zweiten Sprites die Bits für die kleinen Bitplanes 3
und 4 liefern.
Um auf diese Weise zwei Sprites eines Paares zu kombinieren, ist es notwendig,
Bit 7 des zweiten Steuerworts des zweiten Sprites des Paares zu positionieren:
Dies ist das Attach. Außerdem müssen beide Sprites an der gleichen Position
dargestellt werden, also gleichzeitig bewegt werden - wo sie sich nicht
überlappen, wird jedes in der gemeinsamen 4-Farben-Palette dargestellt.

Das Programm sprite16.s verschiebt also ein Sprite mit 16 Farben, das aus den
Sprites 0 und 1 besteht, auf denselben Hintergrund wie zuvor:

Bild: Die Sprites 0 und 1 kombiniert, in 16 Farben, fließen friedlich auf einer
      Bitplane ; figure7-6.png

Die Möglichkeiten, die Anzeige von Sprites zu bereichern, hören hier nicht auf.			
Wenn die Hardware ein Sprite nur einmal pro Zeile des Bildschirms anzeigen
kann, ist es durchaus möglich, sie zu bitten, die Position eines Sprites von
einer Zeile zur anderen zu ändern. Dadurch ist es möglich, die Sprites zu
multiplizieren. Diese Technik, auch "Multiplexing" genannt, wird verwendet, um
mit Sternen versehene Hintergründe zu erzeugen, wie das Programm
spritesField.s zeigt:

Bild: Sprites von Zeile zu Zeile wiederverwenden, um einen sternenklaren
      Hintergrund zu erzeugen (vertikales Muxing) ; figure8-4.png

Beachten Sie, dass dieses Programm doppelt begrenzt ist, da nicht nur Sprite 0
wiederverwendet wird, was keinen Tiefeneffekt erzeugt, sondern auch das Muster
des Sprites nicht von einem Auftreten zum anderen geändert wird, was das
Erscheinungsbild sehr eintönig macht. Indem Sie mit diesen beiden Parametern
spielen, ist es einfach, im Handumdrehen besser zu werden.
Modifizieren Sie dazu einfach die Datenstruktur des Sprites. Die letzten beiden
Wörter bei 0 müssen durch neue Steuerwörter ersetzt werden, die die Koordinaten
angeben, wo das Sprite wieder angezeigt werden soll. Beispielsweise :

$2C40,$2D00 ; Anzeige des Sprites auf 1 Pixel Höhe in ($81, $2C)
$8000,$0000 ; Kleine Sprite-Bitplanes 1 und 2 (1 Pixel ganz links)
$2EE5,$2F00 ; Anzeige des Sprites auf 1 Pixel Höhe in ($81 + 100 = $E5, $2C + 2 = $2E)
$0008,$0000 ; Kleine Sprite-Bitplanes 1 und 2 (1 Pixel ganz rechts)
0,0			 ; Ende des Sprites

Die y-Koordinate des neuen Sprite-Vorkommens ist eingeschränkt. Grundsätzlich
ist sie notwendigerweise größer als die der zuletzt angezeigten Zeile der
vorherigen Instanz des Sprites. Aber es gibt noch mehr: Sie müssen zwischen
zwei Vorkommen des Sprites auf eine Zeile auf dem Bildschirm warten.
Tatsächlich hat der DMA in jeder Zeile des Bildschirms nur Zeit, die Hardware
mit zwei Wörtern pro Sprite zu versorgen. Wenn es also die neuen Steuerwörter
des Sprites während einer Zeile liest, hat es keine Zeit, die Wörter der ersten
Zeile der kleinen Bitebenen des Sprites während der letzteren zu lesen; In der
folgenden Zeile wird er dazu in der Lage sein. Folglich kann ein bis Y
angezeigtes Sprite erst wieder ab Y+2 angezeigt werden. In spritesField.s, gibt
es nur 256/17 = 15 Instanzen von 16 Pixel Höhe auf dem Bildschirm.

DER TRICK: SPRITES SUCHEN FÜR EINEN NETTEN PLAN MIT MEHREREN LEUTEN

Wenn sie nur wenige und nicht sehr farbenfroh sind, haben die Sprites daher
nicht weniger Möglichkeiten, den Programmierer zu verführen. Dies gilt
insbesondere, da ihr Potenzial über das hinausgeht, was im Amiga Hardware
Reference Manual dokumentiert ist. Insbesondere ist es möglich, Sprites
horizontal über die Breite des playfields wiederzuverwenden.
Es ist riesig, weil es Ihnen einfach erlaubt, ein playfield hinzuzufügen. Wie
Codetapper auf seiner hervorragenden Seite dokumentiert hat, wurde der Trick in
vielen erfolgreichen Spielen in verschiedenen Variationen eingesetzt.
Das Programm triplePlayfield.s verdeutlicht dies durch die Einrichtung eines
Triple-Playfields. In dieser Konfiguration werden zwei playfielder im
Dual-Playfield angezeigt, gemäß den Anweisungen im Amiga Hardware Reference
Manual. Oben wird ein playfield von Sprites angezeigt, indem der Trick der
horizontalen Wiederverwendung ausgenutzt wird. Dieses dritte playfield besteht
aus drei Sprite-Paaren in 16 Farben, die horizontal wiederverwendet werden.
Wenn die Sprites nur 32 Pixel hoch sind (ausreichend, um eine Zahl und ein
Schachbrett aus Farben anzuzeigen), versteht es sich, dass sie sich über die
gesamte Höhe des Bildschirms erstrecken können:

Bild: Ein Triple-Playfield, einschließlich eines Sprites-Playfields
(horizontales Multiplexing)	; figure9-2.png

Der bereits erwähnte Amiga-Videospiel-Coder erzählte mir, dass er die Technik
verwendet hatte, um eine Umgebung zu erstellen, deren Topologie einem Torus
entsprach. Tatsächlich wurde die Dekoration horizontal und vertikal wiederholt,
so dass die Oberfläche des Bildschirms effektiv einen rechteckigen Teil einer
auf einem Torus plattierten Dekoration zeigte. Einen Torus mit einem Flugzeug
aus Sprites machen: Ich glaube, er hat sich die Haare ausgerissen ...
Um zu verstehen, wie wir unser viel bescheideneres Ergebnis erzielen können,
müssen wir uns die Copperliste ansehen. Letzteres enthält insbesondere einen
wie folgt generierten Abschnitt:
	
move.w #(DISPLAY_Y<<8)!$38!$0001,d0
	move.w #DISPLAY_DY-1,d1
_copperListSpriteY:
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+
	move.w #((SPRITE_Y&$FF)<<8)!((SPRITE_X&$1FE)>>1),d2
	move.w #SPR0POS,d3
	move.w #(DISPLAY_DX>>4)-1,d4
_copperListSpriteX:
	move.w d3,(a0)+
	move.w d2,(a0)+
	addq.w #8,d3
	move.w d3,(a0)+
	move.w d2,(a0)+
	addq.w #8,d3
	cmpi.w #SPR6POS,d3
	bne _copperListSpriteNoReset
	move.w #SPR0POS,d3
_copperListSpriteNoReset:
	addi.w #16>>1,d2
	dbf d4,_copperListSpriteX
	addi.w #$0100,d0
	dbf d1,_copperListSpriteY

Die Codierung der WAIT- und MOVE-Befehle von Copper wurde in diesem Artikel
detailliert beschrieben. Es genügt daher, darauf hinzuweisen, dass dieser Code
am Anfang jeder Zeile des Bildschirms ein WAIT erzeugt, gefolgt von 20 Folgen
von MOVE, die nacheinander die Register SPR0POS bis SPR5POS modifizieren.
Wie bereits erläutert, enthält ein SPRxPOS-Register das erste Steuerwort eines
Sprites, also die höchstwertigen 8 Bits seiner horizontalen Position. In seiner
Beschreibung der Funktionsweise von Sprite DMA gibt das Amiga Hardware
Reference Manual an, dass die horizontale Position des Elektronenstrahls bei
jedem Pixel mit der in SPRxPOS verglichen wird, um zu entscheiden, ob die in
SPRxDATA und SPRxDATB geladenen Daten angezeigt werden sollen oder nicht.
Mit anderen Worten, wenn wir die horizontale Position eines Sprites in SPRxPOS
ändern, nachdem dieses Sprite angezeigt wurde, ist es möglich, dass dieses
Sprite erneut in derselben Zeile angezeigt wird. Das ist der springende Punkt
der MOVE-Serie.
Nehmen wir den Fall der Sprites 0 und 1, die zu einem 16-Farben-Sprite
verbunden sind und daher an derselben Position oben links auf dem Bildschirm
angezeigt werden. Die Hardware liest Daten von Bitplanes und Sprites, die in
16-Pixel-Paketen angezeigt werden sollen. Das erste WAIT wartet auf den
Elektronenstrahl an Position $38, was der erste dieser Messwerte ist, der dem
Beginn der Anzeige vorausgeht (die horizontale Position, die in DDFSTRT
gespeichert ist). Während die Hardware die 16 Pixel der Sprites 0 und 1
anzeigt, werden SPR0POS und SPR1POS durch zwei MOVEs modifiziert, die die
horizontale Position der Sprites um 16 Pixel nach rechts verschieben. Da der
Copper 16 Pixel benötigt, um diese MOVEs auszuführen, werden die neuen
Registerwerte von der Hardware berücksichtigt, wenn er das nächste Mal ein
16-Pixel-Paket zur Anzeige liest. Somit werden diese Sprites wieder an ihrer
neuen gemeinsamen Position angezeigt!
Die Schwierigkeit bestünde darin, die MOVEs beim Lesen der Daten der 16 Pixel,
die die Hardware anzeigen wird, richtig zu synchronisieren. Dies ist jedoch
perfekt: Es besteht keine Notwendigkeit, nutzlose MOVEs einzufügen, das
Äquivalent zum NOP für Copper, nur um in der Mitte der Linie anzuhalten.
Beachten Sie, dass es für andere Effekte viel akrobatischer ist, die ähnlich
darin bestehen, die Hardware während der Linie zu duplizieren, aber an
genauen Positionen, insbesondere für den horizontalen Hardware-Zoom, der in
einem möglichen nächsten Artikel besprochen wird.
An dieser Stelle kann sich der aufmerksame Leser zwei Fragen stellen. Warum ein
duales playfield mit zwei Bitplanes pro playfield (4 Farben pro playfield, eine
transparent) und nicht drei (8 Farben pro playfield, eine transparent)
anzeigen, wie es die Hardware erlaubt? Und warum drei Paare von Sprites
wiederverwenden und nicht vier, auch hier wieder, wie es die Hardware
zulässt?
Es ist so, dass der Trick seine Grenzen hat.
Jeder Metal-Basher, der sein Amiga-Hardware-Referenzhandbuch gelesen hat, kennt
das berühmte Schema namens DMA-Zeitschlitzzuweisung. Dieses Diagramm ermöglicht
es, die Zuordnung verfügbarer Zyklen während einer Linie zu visualisieren, die
die Hardware auf dem Bildschirm zeichnet. Einige Zyklen sind für zwingende
Funktionen reserviert, wie z.B. das Lesen von Daten aus Bitebenen. Die anderen
stehen zur Verfügung, insbesondere für den Copper, der damit die Zeit findet,
MOVEs auszuführen (Wer sich übrigens wundert, warum ein MOVE in niedriger
Auflösung 8 Pixel braucht, um ausgeführt zu werden, findet die Erklärung im
Diagramm).
Das Problem ist, dass die Hardware jenseits von 4 Bitplanes beginnt, Zyklen zu
stehlen, von denen der Copper behaupten könnte, Daten von den zusätzlichen
Bitplanes zu lesen:

Bild: Bitplanes 5 und 6 stehlen Zyklen von Copper ; figure10-2.png

Folglich wird eine Folge von 40 MOVEs regelmäßig unterbrochen, was die
Möglichkeit ausschließt, beliebig viele Sprites horizontal wiederzuverwenden.
Um alle Zyklen zur Wiederverwendung der acht Sprites zu haben, müssen Sie sich
auf 4 Bitplanes beschränken, d.h. zwei playfielder mit jeweils 2 Bitplanes.
Darüber hinaus scrollen die playfielder im Programm triplePlayfield.s
horizontal, indem die Möglichkeiten der Hardware über das BPLCON1-Register
ausgenutzt werden. Dieser Effekt basiert jedoch auf einem frühen Lesen der
Bitplane-Daten (16 Pixel vor dem eigentlichen Beginn ihrer Anzeige), was
wiederum Zyklen stiehlt, diesmal jedoch durch das Verhindern des Lesens von
Sprite-7-Daten über DMA:

Bild: Playfield-Scrolling stiehlt DMA-Zyklen für Sprites 6 und 7
	; figure11-2-768x154.png

Daher können die Sprites 6 und 7 nicht verwendet werden.

DIE AGA: SPRITES ETWAS BESSER

Während die Programmierer die Qualität des Amiga-Hardware-Referenzhandbuchs,
das den Original-Chipsatz (OCS) bis ins kleinste Detail dokumentiert,
besonders geschätzt hatten, entschied sich Commodore, die Advanced Graphics
Architecture (AGA hier, AA bei den Amerikanern) nicht zu dokumentieren. Diese
Richtlinie sollte die Softwarekompatibilität im Vorfeld einer Chipsatz-
Revolution sicherstellen, die bekanntlich nie stattgefunden hat.
Die Entscheidung wurde von den Programmierern niedergeschrien. In ihrer in
Grapevine #14 veröffentlichten Präsentation des Amiga 1200 drückten Ringo Star
/ Classic und Animal & Goofy / Silents nur das allgemeine Gefühl aus...
nicht ohne die stets unterhaltsame Prahlerei der Bühnenansicht der Mitglieder
zu zeigen!

Bild: Ringo Star / Classic und Animal & Goofy / Silents, not happy! 
	; figure12-1-768x396.png

Aber diese Ausgabe von Grapevine enthält einen anderen Artikel, weniger
prahlerisch und konstruktiver, veröffentlicht von Ihnen und seinem Kumpel
Junkie / PMC (sowie einem gewissen Spencer Shanson, dessen Rolle in dieser
Affäre mir jetzt entgangen ist ...).
Nachdem der ausgezeichnete Junkie / PMC die Idee hatte, die Copper-Liste von
der Workbench des Amiga 1200 zu disassemblieren, verbrachten wir viel Zeit
damit, die Hardware zurückzuentwickeln, indem wir ihre Register Stück für Stück
testeten. All dies auf dem Papier, das Ergebnis war eine inoffizielle
Dokumentation, die erklärt, wie man die Hauptmerkmale des AGA durch
Metal-Bashing so nutzt, wie es uns gefällt. Diese Dokumentation wurde dann von
netten Mitwirkenden ergänzt und korrigiert, insbesondere von Randy / Comax,
deren Version bis heute sichtbar die vollendetste ist.
Was Sprites angeht, übertreffen die Fähigkeiten des AGA wohl die des OCS, aber
das ist eher eine Evolution als eine Revolution. Tatsächlich ist es immer noch
nur möglich, 8 Sprites in 4 Farben (verschiedene Paletten für gerade und
ungerade Sprites) oder 4 Sprites in 16 Farben (gleiche Palette für alle
Sprites) anzuzeigen. Dennoch:
 - die Breite eines Sprites kann 16, 32 oder 64 Pixel betragen;
 - Gruppen von geraden und ungeraden Sprites können dieselbe Palette von
   16 Farben teilen oder jede Gruppe kann ihre eigene haben (wenn Sprites
   angehängt sind, wird die Palette von ungeraden Sprites verwendet);
 - Die Sprite-Auflösung kann niedrig, hoch oder superhoch sein;
 - die Position der Sprites kann auf das Äquivalent eines Pixels in niedriger,
   hoher oder superhoher Auflösung eingestellt werden;
   jede Zeile eines Sprites kann verdoppelt werden, ohne dass die Zeile in den
   Daten seiner kleinen Bitebenen verdoppelt werden muss;
 - Sprites können an den Bildschirmrändern, also jenseits der Bitplanes, im
   normalerweise in Farbe 0 gezeichneten Bereich dargestellt werden.

Auf nähere Details soll hier nicht eingegangen werden, denn das würde grob
alles wiederholen, was bereits über Sprites gesagt wurde. Für weitere
Informationen kann der Leser jederzeit auf das Programm spritesAGA.s verweisen.
Dieses Programm nutzt diese Eigenschaften aus, indem es vier 64 Pixel breite
Sprites in 16 Farben auf einem 256-Farben-Dekor anzeigt, d.h. basierend auf
8 Bitplanes, einschließlich der Ränder des Bildschirms:

Bild: Etwas bessere Sprites in AGA	; figure13-1.png

ZUM SCHLUSS MIT DEN SPRITES...

Da Sprites von der Hardware unterstützt werden, haben sie mehrere Vorteile für
den Programmierer. In der Tat müssen letztere weder die Erhaltung und
Wiederherstellung der Dekoration verwalten, auf der sie angezeigt werden (die
Wiederherstellung), noch das Schneiden, das bis zur Beseitigung gehen kann,
wenn sie überlaufen oder das playfield verlassen (das Abschneiden).
Sprites sind jedoch wie Hobbits: praktisch und farbenfroh, aber klein und
wenige an der Zahl. Aus diesem Grund verwenden Programmierer auch oder sogar
alternativ BOBs. Das Akronym entspricht Blitter OBject, also mit dem Blitter
gezeichnete Bitmaps. Da BOBs so weit verbreitet sind, behandelt der zweite
Artikel dieser Serie über die Anzeige von Bitmaps auf dem Amiga die Details.

https://www.stashofcode.fr/code/afficher-sprites-et-bobs-sur-amiga/AGAByRandyOfComax.txt