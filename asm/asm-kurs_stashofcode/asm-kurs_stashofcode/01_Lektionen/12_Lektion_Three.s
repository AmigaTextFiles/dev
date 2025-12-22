
; Lektion 12

SCOOPEX "THREE": DIE KODIERUNG EINES TRAINERMENÜS AUF DEM AMIGA
20. Juli 2019 Amiga, Assembler 68000, Blitter, Copper, Sprites

Auf dem Amiga war der Trainer im Wesentlichen ein Menü, das mit FX und Musik
verziert war, mit dem Sie Optionen zum Betrügen in einem Spiel aktivieren
konnten: "Unlimited Life: On/Off" und so weiter. In vielen Fällen war der
Trainer möglicherweise die einzige Möglichkeit, ein Spiel in vollen Zügen zu
genießen, ohne angesichts der Schwierigkeit zu viel Zeit damit zu verbringen.
Beenden Sie nicht Shadow of the Beast, der will...

In der Kontinuität eines Programms von Hommagen an die verschiedenen Figuren
der Szene ist hier Scoopex "THREE", ein Trainer, der für den berühmten
StingRay der glorreichen Gruppe Scoopex produziert wurde. Nach Scoopex "TWO"
würdigen Grafikdesigner, eine Hommage an Cracker, daher.

Scoopex THREE: Ein Trainer für A500 im Jahr 2019

Wie wir sehen können, hat hier Originalität Vorrang vor Technik. Zumindest dem
Anschein nach, denn was die Programmierung der Hardware im Assembler auf Amiga
angeht, wird schließlich alles ganz technisch schnell!

Code, Daten und Erklärungen in allem, was folgt...
Update 12.08.2019: Das Menü wurde wunderschön auf Flashtro portiert. Es ist da!
Dieses Menü wurde von StingRay immer noch nicht verwendet, aber wie im Fall von
Scoopex "ONE" urteilte ich, dass es nach Monaten des Wartens notwendig war...
nicht länger zu warten. A priori sollte es in Kürze verwendet werden.
Wir sehen... Um beim Lesen des Artikels zuzuhören...

Klicken Sie hier, um das Archiv mit dem Trainercode und den Daten
herunterzuladen.
Lassen Sie uns zu Beginn zwei Dinge klarstellen, um Enttäuschungen zu
vermeiden:
Der Code ist der des Trainermenüs und nicht des Trainers selbst im Sinne des
Codes, der den Code des Spiels ändert, während es läuft;
Das Tileset wird nicht verstanden, aber ich gebe am Ende dieses Artikels
Anweisungen, um es neu zu erstellen.

ENTWURF

Seit dem Tag, an dem ich die wunderbare Entdeckung von Ultima III: Exodus auf
dem CGA-Display eines PC1512 gemacht habe, habe ich grenzenlose Bewunderung für
Richard Garriott, bekannt als "Lord British".
Unnötig zu erwähnen, dass diese Bewunderung durch die Entdeckung, diesmal auf
Amiga, von Ultima IV: Quest of the Avatar und dann Ultima V: Warriors of
Destiny verstärkt wurde. Ich kann mir die Stoffkarten dieser Spiele nicht
vorstellen - ja, ich bin kein Pirat: Ich habe die Originale, môssieur! - ohne
eine Träne in Erinnerung an die freudigen Stunden zu erdrücken, die damit
verbracht wurden, die Ecken und Winkel Britanniens zu erkunden. Das heißt.
Es schien mir immer, dass das Potenzial dieser Spiele unterschätzt wurde,
insbesondere der vierte Teil. Endlich Teufel! Hatte es nicht einen
einzigartigen Charakter, indem es den Spieler zwang, sich einer Ethik zu
beugen, um zu gewinnen? In der Folge bin ich nicht auf Spiele gestoßen, die
auf diese Weise entworfen wurden, und ich dachte immer, dass Videospiele im
Allgemeinen eines Tages ihre Verwendung als Propagandawerkzeug finden würden.
Darüber hinaus hatte ich dieses Thema in einem programmatischen Papier mit dem
Titel The video game at the service of communication entwickelt, in das ich
eintauchen müsste. Davon abgesehen war es im Jahr 2001, bevor die Geschichte
zeigte, dass soziale Netzwerke ein viel einfacher zu verwendender Vektor sind.
Aber zurück zu unseren Schafen. Von dieser ganzen Serie ist es Ultima V, das
immer meine Präferenz hatte. Dies ist nicht nur auf den Reichtum des von
Richard Garriott entwickelten Drehbuchs zurückzuführen, sondern auch auf die
Schönheit der von Denis Loubet und Doug Wike produzierten Grafiken:

Ultima V auf dem Amiga

Keine Musik? Nein, denn zu diesem Punkt muss ich sagen, dass wir auf dem Amiga
nicht verwöhnt wurden. Ich erinnere mich, dass ich, nachdem ich Monate, wenn
nicht Jahre gewartet hatte, bis das Spiel endlich auf meiner
Lieblingsmaschine herauskam, um es bei Fnac zu erwerben - ich sehe mich immer
noch, wie ich die Box in der Abteilung von Les Halles nehme - mit Trotz bemerkt
hatte, dass die Musik nicht das war, was ich auf Atari ST hören konnte.
Anstelle von mehreren Stücken, die alle großartiger waren als die anderen, gab
es nur ein Stück, sicherlich nicht schlecht, aber das Spiel verlor einen großen
Teil seiner Vielfalt. Kurz gesagt, zumindest war das Spiel nicht fehlerhaft wie
auf Atari ST, und ich war immer noch in der Lage gewesen, den Mund eines guten
Freundes zu ficken, der diese Maschine besaß, als ich nach dieser Wartezeit, in
der er es versäumt hatte, mich als Zeichen der Prävalenz seiner Maschine
gegenüber meiner zu fühlen, mich rühmen konnte, das Spiel beendet zu haben.
und nicht er. Kinder...
All dies, um zu sagen, dass es notwendig war, Ultima V Tribut zu zollen, bevor
man es ignorierte.
Aber eines Tages tausche ich mich mit dem berühmten StingRay der glorreichen
Gruppe Scoopex aus, und hier bietet er mir an, einen Trainer zu machen. Für
diejenigen, die es nicht wissen, ist StingRay einer dieser brillanten
Programmierer, die zur Erhaltung des Erbes des Amiga beitragen, indem sie
methodisch Spiele übernehmen, um Versionen zu produzieren, die von einer
Festplatte mit WHDLoad betrieben werden können, mit Schlepp, wenn sie zuvor
leer waren. Zum Beispiel Ultima V, erst im April 2018. Man muss das Original
haben.
Ich denke für einen Moment nach, und es kommt mir die Idee eines Trainers für
das am wenigsten originelle, da es darin bestehen würde, das unvermeidliche
Menü nicht eines FX, sondern einer ganzen Animation zu verdoppeln, die auf
Kacheln von Ultima V basiert. Es ging darum, einem Spieler zu folgen, der gut
herumlaufen würde, bevor Stremas auf ihn fielen. Auf diesem Fall würde er
seinen Mund schwer zertrümmern und würde um Gnade bitten, von StingRay gezogen
zu werden. Bam! Er würde die Summe erben, und von den Füßen bis zum Kopf einer
Slew-Ausrüstung gekleidet, würde er dem Schrecklichen eine Rouste geben.
Das ist der Pitch.
Die Idee freut StingRay für seine Originalität, und ich beginne die
Realisierung, mit umso größerem Interesse, dass ich ein Ultima-ähnliches auf
Basis von JavaScript und WebGL entwickle - das ich irgendwann eines Tages
fertigstellen werde? Zumindest wird mir dieser Trainer bereits die Möglichkeit
gegeben haben, einen ganzen kachelbasierten Karteneditor zu programmieren, wie
wir später sehen werden.

DIE KARTE

Basierend auf der Bedarfsäußerung von stingRay kann der Trainer dem Spieler
zwei Arten von Paddeleinstellungen anbieten:
Ein ganzzahliger Wert, der standardmäßig im Bereich [0, 255] liegt, aber in
jedem kleineren Abstandshalter begrenzt werden kann.
ein boolescher Wert.
Darüber hinaus kann jeder Parameter einen beliebigen Standardwert haben.
Die kleine Schwierigkeit bestand darin, StingRay zu ermöglichen, den Inhalt der
Menüseiten einfach zu schreiben. Das Beste war, so WYSIWYG wie möglich zu sein
und es daher zu ermöglichen, Textzeilen, Zeilen von Parametern, aber auch
Zeilen im Menü zu verflechten: Gehen Sie zur möglichen vorherigen Seite, zur
möglichen nächsten Seite, verlassen Sie den Trainer.

Aus diesem Grund werden Menüzeilen in den Daten als Strukturen deklariert:

<Text>, 0, PARAM_NONE	Einzelne Textzeile
<Text>, 0, PARAM_BOOL, <Wert>	Zeile eines booleschen Parameters (0: true, -1: false)
<Text>, 0, PARAM_INT, <Wert>, <min>, <max>	Zeile eines beschränkten ganzzahligen Parameters
<Text>, 0, PARAM_PREV	Zeile eines Links zur vorherigen Seite
<Text>, 0, PARAM_NEXT	Zeile eines Links zur nächsten Seite
<Text>, 0, PARAM_QUIT	Zeile eines Links, um den Trainer zu verlassen
0, PARAM_NONE	Leerzeile

Zum Beispiel für die erste Seite - jede Seite endet mit einer -1 und die Menge
der Seiten endet mit einer zusätzlichen -1:

	DC.B 0,PARAM_NONE
	DC.B "  .oO Idea & Opcodes: Yragael Oo.",0,PARAM_NONE
	DC.B "oO. Paintings: Loubet &| Wike .Oo",0,PARAM_NONE
	DC.B "  .Oo    Bells & Horns: JMD   oO.",0,PARAM_NONE
	DC.B 0,PARAM_NONE
	DC.B "The menu may contain lines of",0,PARAM_NONE
	DC.B "text (32 chars), possibly empty,",0,PARAM_NONE
	DC.B "even between params.",0,PARAM_NONE
	DC.B 0,PARAM_NONE
	DC.B "There may be up to 255 params.",0,PARAM_NONE
	DC.B "A param is either BOOL or INT:",0,PARAM_NONE
	DC.B 0,PARAM_NONE
	DC.B "BOOL parameters:",0,PARAM_BOOL,-1
	DC.B "INT parameters:",0,PARAM_INT,0,0,10
	DC.B 0,PARAM_NONE
	DC.B "The menu may run on several pages.",0,PARAM_NONE
	DC.B "Just add PREV/NEXT option as",0,PARAM_NONE
	DC.B "required:",0,PARAM_NONE
	DC.B 0,PARAM_NONE
	DC.B "Next page",0,PARAM_NEXT
	DC.B 0,PARAM_NONE
	DC.B "And don't forget a QUIT option:",0,PARAM_NONE
	DC.B 0,PARAM_NONE
	DC.B "Quit",0,PARAM_QUIT
	DC.B -1

Wenn der Trainer gestartet wird, befinden sich die Daten, die das Menü
beschreiben, unter menuData. Interpretiert werden sie von der _menuSetup
Routine, die bei menuPages eine leicht manipulierbare Menüdarstellung erzeugt,
in Form einer Sequenz von Datenstrukturen im Detail, die Sie nicht eingeben
müssen. Insbesondere werden diese Strukturen von der _menuPrintPage Routine
verwendet, um den Inhalt einer Seite anzuzeigen.
Eine Seite des Menüs mobilisiert die Bitebenen 5 und 6. Auf Amiga ist die
Bitebene 6 etwas Besonderes, da das Bit 5, das es in die Farbindexcodierung
eines Pixels einführt, nicht zulässt, dass dieses Pixel in einer Farbe
angezeigt wird, die gesteuert werden kann. Die Hardware berücksichtigt, dass
die Farben 32 bis 63 notwendigerweise halbhelle Versionen sind - halb so hell
- Farben 00 bis 31. Diese Operation ist ideal für das Menü, da sie es
ermöglicht, es auf einem Hintergrund anzuzeigen, der einen Einblick in die
Bitebenen der ersten Zwischensequenz in Halbtransparenz gibt, ohne eingreifen
zu müssen.
Das Trainermenü verwaltet boolesche Werte und begrenzte ganze Zahlen (oder auch
nicht)
Wenn es daher perfekt ist, dass die Helligkeit der Farben der Pixel der ersten
Zwischensequenz abgeschwächt wird, sollte nicht vergessen werden, dass die
Bitebene 6 die Helligkeit der anderen Pixel, dh die des Textes des Menüs,
beeinflusst. Aus diesem Grund schreibt die Routine _menuPrintPage, nachdem sie
den Menühintergrund mit 1 Bit in Bitebene 6 gefüllt hat, jedes Zeichen des
Menüs in Bitebene 5 und die Umkehrung dieses Zeichens in Bitebene 6.

DIE MAUS

Von allen Schwierigkeiten, mit denen der Amiga-Hardware-Encoder konfrontiert
sein kann, ist die Mausverwaltung eine der unerwartetsten. Denn so einfach es
auch ist, zu testen, ob die linke Maustaste gedrückt oder losgelassen wird -
testen Sie das 6-Bit von $BFE001 - es ist auch schwierig, dasselbe für die
rechte Taste zu testen.
Das Lesen dieses Abschnitts des Amiga Hardware Reference Manual legt nahe, dass
die rechte Taste nicht wie die linke Taste verwaltet wird, da sie nicht an eine
Schaltung der gleichen Art angeschlossen ist: Sie ist mit einem analogen und
nicht mit einem digitalen Pin verbunden.
In der Tat, wenn man diesen Anhang liest, scheint es, dass das Lesen des Status
der rechten Taste auf diesem Pin nicht einfach ein bisschen in einem Register
testet. Wenn es möglich ist, die 10 Bit (DATLY) von POTCHOR zu testen,
geschieht dies erst, nachdem die Hardware gebeten wurde, den Pin als digital zu
behandeln. Dazu ist es notwendig, in ein anderes Register, POTGO, zu schreiben.
Daher die folgende Reihenfolge:
	
	move.w #$8400,POTGO(a5)	;OUTRY=1, DATLY=1
	btst #10,POTGOR(a5)		;Bit 10 % 8 = 2 de l'octet de poids fort, donc DATLY

Der Anhang scheint anzugeben, dass es theoretisch notwendig ist, bis zu 300 ms
zwischen den beiden Operationen zu warten. Es scheint jedoch nicht, dass dies
wirklich notwendig ist. In jedem Fall verzichtet der Trainercode darauf.
Und um die Bewegung der Maus zu verfolgen? Wie hier auch erläutert, führt das
Bewegen der Maus dazu, dass ein Zähler erhöht wird, wenn er nach oben bewegt
wird, und derselbe Zähler verringert wird, wenn er nach unten bewegt wird. Dies
ist ein 8-Bit-Zähler, dessen Wert in JOY0DAT gelesen werden kann, wenn die Maus
an Port 1 angeschlossen ist - was normalerweise der Fall ist.
Die hier angegebenen Details ermöglichen es zu verstehen, dass das Messgerät,
wenn es die Sättigung erreicht, wieder geschlossen wird. Der Trainer
berücksichtigt dies, um diesen unerwünschten Effekt zu vermeiden, bei dem die
Bewegung der Maus nach unten als eine Bewegung nach oben interpretiert wird und
umgekehrt. Zum Beispiel würde die Änderung von -126 zu -127 nach einer
Abwärtsbewegung es ermöglichen, eine Variation von -1 des Zählers zu erkennen,
die einer Abwärtsbewegung gleichgestellt ist, da sie negativ ist. Bei der
nächsten Bewegung immer nach unten würde der Durchgang von -127 bis 0 des
Zählers jedoch dazu führen, dass eine Variation von +127 erkannt wird, die
einer Aufwärtsbewegung gleichgestellt ist, da diese Variation positiv ist.
Im Code des Trainers, wissend, dass der Zähler bei jedem Frame gelesen wird -
1/50Heit Zweitens -, und eine Bewegung kann vernünftigerweise nicht dazu
führen, dass der Zähler zurückkehrt, wenn er bei 0 beginnt, wird der Zähler
bei jedem Lesen auf 0 zurückgesetzt. Darüber hinaus wird eine Bewegung nur
erkannt, wenn das Messgerät den Schwellenwert MENU_MOUSESENSITIVITY 
überschreitet - der in der Praxis auf ein Minimum eingestellt ist. Das
Zurücksetzen erfolgt durch Schreiben in eine andere Registrierung, JOY0TEST:
	
	move.w JOY0DAT(a5),d1
	and.w #$FC00,d1		;Les deux bits de poids faibles doivent être ignorés
	beq _menuMoveSelectorExit
	bgt _menuMoveSelectorDown
	cmpi.w #-MENU_MOUSESENSITIVITY,d1
	bgt _menuMoveSelectorDone
	;Rajouter ici le code pour gérer un mouvement vers le haut
	bra _menuMoveSelectorDone
_menuMoveSelectorDown:
	cmpi.w #MENU_MOUSESENSITIVITY,d1
	blt _menuMoveSelectorDone
	;Rajouter ici le code pour gérer un mouvement vers le bas	
_menuMoveSelectorDone:
	move.w #0,JOYTEST(a5)
_menuMoveSelectorExit:

Es mag seltsam erscheinen, die beiden leichtgewichtigen Teile des Zählers zu
ignorieren, da dies ein Verlust an Genauigkeit zu sein scheint. Wie hier
erklärt, haben diese beiden Bits ein ganz besonderes Verhalten, um in JOY0DAT
sowohl die Amplitude einer Mausbewegung als auch die Richtung eines Drucks auf
einem Joystick zu lesen. Daher ist es am besten, sie zu ignorieren.
Klicken Sie hier, um den minimalen Code abzurufen, um die Kontrolle über die
Hardware zu übernehmen, um einen Bildschirm auf einer Bitebene anzuzeigen, und
führen Sie eine Schleife aus, die das Drücken von Maustasten, die Bewegungen
der letzteren und das Loslassen einer Taste (ESC) zum Beenden testet.

ZWISCHENSEQUENZEN

Wie ich bereits erwähnt habe, habe ich lange versucht, ein Ultima-ähnliches in
JavaScript und WebGL zu produzieren - aber "Ich werde es eines Tages haben! Ich
hätte es!", das ist sicher. Dieses persönliche Projekt gab mir die Möglichkeit,
viele Tools zu entwickeln - das ist das Problem, dieser ewige Exkurs... -, und
sehr gute Kenntnisse in JavaScript und einigen APIs des Browsers, 
einschließlich WebGL und Canvas, zu erwerben. Daher wusste ich, dass ich, wenn
ich anfangen würde, einen Zwischensequenz-Editor zu entwickeln, um ihn zu 
ziehen, keine Schwierigkeiten haben würde, ihn schnell zu beenden.
Aber das Komponieren des Sets und das Beschreiben der Animation einer 
Zwischensequenz mit Codes in einem Texteditor würde sich sicherlich schnell als
umso mühsamer erweisen, da ich mir überhaupt nicht sicher war, welche
Zwischensequenz zu erstellen war, so dass ich mich höchstwahrscheinlich auf 
viele Bearbeitungen einlassen müsste. Kurz gesagt, einen Verleger zu haben,
schien mir schnell unerlässlich, um bequem zu arbeiten.
Also produzierte ich folgendes:

Cut-Scene-Editor von Scoopex THREE

Dieser nette kleine Editor macht es einfach, eine Zwischensequenz zu erstellen.
Grundsätzlich lädt es eine JSON-Datei - vergessen Sie XML für immer -, die
einfach eine Tabelle enthält, die die Kacheln in der PNG-Datei identifiziert,
die sie gruppieren. Ein Beispiel für einen Eintrag:

{"id":0, "name":"Grass",   "type":0, "u":4, "v":0,   "nbFrames":1}

Diese Tabelle stellt die Kacheln zur Verfügung, die mit der Maus in jedem Frame
der Zwischensequenz abgelegt werden sollen.
Um das Leben zu vereinfachen, ist der Editor mit folgenden Funktionen
ausgestattet:

drei Ebenen (die Einstellung, die Charaktere, die Objekte), damit Sie leicht
an Entitäten eines bestimmten Typs arbeiten können, ohne das zu ruinieren, was
bereits auf den anderen produziert wurde;
Kopieren und Einfügen, Löschen und Füllen eines gesamten Frames, der auf aktive
Ebenen beschränkt ist.
unendliches Rückgängigmachen für alle Operationen auf Kacheln in einem Frame
und auch für alle Operationen der Animationsverwaltung;
Laden und Exportieren der Zwischensequenz im JSON-Format und Exportieren in das
vom Trainer verwendete DC.B-Format;
Spielen Sie die Animation aus einem beliebigen Frame ab und kehren Sie am Ende
oder bei Unterbrechung zu diesem Frame zurück.
Es ist nicht sehr groß: höchstens 2.500 Zeilen, JavaScript, HTML und CSS - aber
HTML und CSS, es gibt fast keine - verwirrt. Ich werde den Code zur Verfügung
stellen, sobald ich eine erste Version der erwähnten Ultima-ähnlichen Version
erstellt habe.
Für die Animation war es nicht notwendig, mittags um vierzehn Uhr zu suchen: Es
ist differentiell. Mit anderen Worten, mit Ausnahme von Frame 0 wird ein Frame
auf die Liste der Kacheln reduziert, die er im vorherigen Frame ersetzt. Mit
dieser Technik können Sie die Größe der Datei begrenzen, die die Animation 
beschreibt, aber auch die Grafikoperationen, die erforderlich sind, um einen
Frame in den nächsten zu transformieren.
Beispielsweise besteht Bild 1 der zweiten Zwischensequenz im DC.B-Exportformat
aus den folgenden Bytes:

;Frame 1
DC.B 2,9,14,29,9,15,75

Was sich so liest. Es ist notwendig, 2 Kacheln zu ändern:
Die Kachel (9, 14) wird zur Kachel des Index 29 in der Kachelpalette;
Die Kachel (9, 15) wird zur Kachel des Index 75 in der Kachelpalette.

... Das ist, als würde man den Charakter ein Quadrat hinaufbewegen und den Weg
enthüllen, auf dem er gehen soll. Kurz gesagt, um von Bild 0 zu Bild 1 zu
gelangen, zeichnen Sie einfach zwei Kacheln neu, anstatt sie alle neu zu
zeichnen.
Die Technik ist wirtschaftlich, hat aber einen großen Nachteil bei der
Bearbeitung. Tatsächlich ist eine Kachel nur eine Kachel, dh eine Instanz einer
Kachel einer Palette von Kacheln, und keine Instanz einer Entität wie eines
Charakters, eines Objekts oder eines dekorativen Elements, die eine Existenz
außerhalb des Rahmens hätte. Um es anders auszudrücken, eine Kachel ist für
einen Rahmen der Zwischensequenz das, was ein Pixel für einen Rahmen einer
Animation ist: Sie ist nichts anderes als ein Bild, sie enthält keine anderen
Informationen als die, die sie anzeigen lässt.
Dies stellt eine besondere Schwierigkeit bei der Animation der Entitäten dar,
die Kacheln darstellen, da es keine Verbindung zwischen einer Kachelinstanz in
einem Frame und der Entität gibt, die sie darstellt - keine Informationen in
der Instanz kehren zu ihr zurück. Daher ist es unmöglich, automatisch zu sagen
- dh: im Code -, ob eine Kachel in (x0, y0) in Frame N die gleiche Entität 
darstellt wie eine Kachel in (x1, y1) in Frame N + 1 oder sogar in (x0, y0) in
diesem Frame. Selbst wenn es sich um einen Drachen handelt, der an beiden 
Positionen in den Bildern dargestellt ist, wie können wir sagen, dass es 
derselbe Drache ist? Wie kann man also sagen, dass das Bild des Drachen im 
Bild N +1 das Bild der Animation eines Drachen sein muss, das dem im Rahmen N
in dieser Animation verwendeten folgt?
Die Animation der Kacheln kann nicht von der der Entitäten, die sie darstellen,
abgeleitet werden, so dass es bei jedem Frame notwendig ist, die Kachel, die
die Entität darstellt, von Hand zu ändern, um die Animation der betreffenden 
Entität zu erzeugen. Es ist ziemlich schwer. Wenn jemals ein Frame gelöscht
oder eingefügt wird, ist es außerdem notwendig, die Kacheln, die diese Entität
in allen nachfolgenden Frames darstellen, von Hand zu ändern, da sonst die
Kontinuität der Animation der Entität unterbrochen wird. Und das für alle
Entitäten. Es genügt zu sagen, dass es besser ist, die Entitäten zwischen den
Frames erst am Ende zu animieren, sobald die Liste der Frames, aus denen die
Zwischensequenz besteht, endgültig ist.
Es ist klar, dass es angesichts dieser Einschränkung ein reiner Albtraum 
gewesen wäre, die Zwischensequenzen durch differentielle Animationen ohne 
Editor zu erstellen. Auf dem Weg dorthin wird eine Zwischensequenz im Assembler
gespielt, einige Details.
Es gibt keinen Doppelpuffer, aus zwei Gründen. Zunächst einmal ist es
schmerzhaft, den Doppelpuffer zu verwalten, wenn es darum geht, das 
Differential zu spielen: Bei jedem Frame müssen Sie den Frame, den der 
aktuelle Puffer enthält, um zwei Frames in der Zwischensequenz und nicht 
um einen verschieben. Dann ist es nicht die Modifikation einiger Kacheln, die
dazu führt, dass das Raster die CPU einholt und das Flimmern erzeugt, das der
Doppelpuffer vermeidet, wie ich hier erklärt habe.
Der einzige etwas knifflige Teil des Codes und wohl der längste ist die 
_drawText-Routine, die Text in einer Blase anzeigt, die relativ zu einem in den
Framedaten festgelegten Winkel einer Kachel nach folgendem Muster positioniert
ist:

DC.B 24,9,14,1,"I must find",$0A,"the princess"

Was sich so liest: Zeigen Sie eine Zeichenfolge mit 24 Zeichen - möglicherweise
einschließlich Zeilenumbrüchen - relativ zu einem Winkel der Kachel an (9, 14).
Der Winkel und die Position der Blase relativ zu diesem Winkel ist 1. Es gibt
vier mögliche Werte:

Positionieren einer Textblase relativ zu einer Kachel

Die Routine berechnet die Abmessungen der Blase und kombiniert diese
Informationen mit ihrer relativen Positionierung, um die Koordinaten
abzuleiten, an denen sie angezeigt werden soll.
Hier wird der Code etwas subtiler, da die Blase nicht in den Bitebenen
gezeichnet wird. Es wird in den Bitebenen von Sprites gezeichnet, die zu einem
Super-Sprite zusammengefügt werden. Wozu? Weil es lustig ist und weil es
vermeidet, sich mit der Wiederherstellung befassen zu müssen.
Um sich nicht zu sehr zu ärgern, wird die Blase immer noch in Off-Screen-Mini-
Bitplanes gezeichnet, und der Inhalt dieser Mini-Bitplanes wird dann Spalte
von 16 Pixeln für Spalte von 16 Pixeln in die Bitebenen der verwendeten Sprites
kopiert. Es wäre viel zu schmerzhaft gewesen, wenn der Code, der den Rahmen
nachzeichnet, den Hintergrund ausfüllt und die Zeichen schreibt, alle 
16 Pixel von den Bitebenen eines Sprites zu denen eines anderen Sprites
springt...
Wie hier erklärt, kann die Hardware des Amiga 500 8 Sprites in vier Farben
anzeigen, darunter eine transparente, mit einer Breite von 16 Pixeln und über
die gesamte Bildschirmhöhe. Somit beträgt die maximale Breite einer Blase
16 * 8 = 128 Pixel, was 15 Zeichen in 8x8-Schriftart pro Zeile ergibt, wobei
4 Pixel auf beiden Seiten für den Rand der Blase reserviert sind. Das ist
mehr als genug für die Bedürfnisse des Trainers: Die Charaktere deklamieren
Dostojewski nicht.

DAS BANNER

Das Banner wird ausschließlich während der zweiten Zwischensequenz angezeigt.
Es gibt einige Botschaften, die nichts Unterschwelliges haben - ich werde nicht
die gleiche Prüfung wie im Abspann der 20-Stunden-Zeitung über Antenne 2 zu
ihrer Zeit erhalten!

Das Banner, und werfen Sie Trump den Dummen weg!

Immer mit dem heftigen Wunsch geschrieben, eine Wiederherstellung in Bitplanes
zu vermeiden, in denen die Zwischensequenz angezeigt wird, zeichnet der Code
das Banner in den Bitplanes 5 bis 6, wo die Zwischensequenz nicht angezeigt
wird. Der Start der Animation des Banners führt zur Reaktivierung der Anzeige
dieser Bitplanes ...

	;Show bitplanes 5 and 6

	movea.l copperList,a0
	move.w #(DISPLAY_DEPTH<<12)!$0200,10(a0)
	... dass das Ende der Banneranimation dazu führt, dass Folgendes deaktiviert wird:
	;Hide bitplanes 5 and 6

	movea.l copperList,a0
	move.w #((DISPLAY_DEPTH-2)<<12)!$0200,10(a0)

Die vorherigen Anweisungen werden in die Copperliste eingegeben, wo sie den
Wert ändern, den eine MOVE-Anweisung in das BPLCON0-Register schreibt, wodurch
Sie die Anzahl der angezeigten Bitebenen steuern können.
Der gesamte Banner-Management-Code wurde berücksichtigt, um bei anderen
Gelegenheiten verwendet zu werden. So nimmt es ein Modell an, mit dem 
diejenigen, die den Code von Scoopex "TWO" gelesen haben, jetzt vertraut sind,
nämlich:
eine Konfigurationsroutine (_bnrSetup) auf Basis einer Datenstruktur 
(bnrSetupData), deren Offsets der verschiedenen Felder durch Konstanten
(OFFSET_BANNERSETUP_* identifiziert werden);
eine Step-Routine (_bnrStep) auf Basis einer Datenstruktur (bnrState), deren
Offsets der verschiedenen Felder durch Konstanten
(OFFSET_BANNER_* identifiziert werden) ;
Eine Reset-Routine (_bnrReset) ;
eine Finalisierungsroutine (_bnrEnd).
Weniger wichtig, um Platz im Speicher zu sparen, als das Design nicht zu
komplizieren, verwendet das Banner eine 16x16-Schriftart, die keine andere als
die 8x8-Schriftart des HiRes-Menüs ist und scrollt, deren Abmessungen
verdoppelt werden. Es ist eine Lösung der gleichen Art wie die, die hier
bereits implementiert wurde, um eine Schriftart der gleichen Größe zu erzeugen.
Darüber hinaus ist es derselbe Code, der verwendet wird, um diese
16x16-Schriftart bei der Initialisierung des Trainers zu erstellen.

DER ÜBERGANG

Die zyklische Animation von phasenverschobenen Quadraten ist ein bisschen
ein Markenzeichen. Diesen Effekt habe ich damals in fast allen meinen Cracktros
genutzt, nicht nur, weil ich ihn elegant fand, sondern auch und vor allem, weil
ich die Dienste eines Grafikdesigners nicht in Anspruch nehmen konnte. Wenn Sie
nicht wissen, wie man zeichnet, ist es besser, es einfach zu halten: Das ist
meine ganze Theorie des Designs.
Der Trainer gab mir die Möglichkeit, diesen Effekt zu recyceln, den ich 2016
wieder aufgegriffen hatte, als ich anfing, die Amiga-Hardware in Assembler zu
programmieren. Die Idee war dann, eine Reihe von Effekten zu produzieren, die
ich eines Tages in einer Demo zusammenstellen werde. Schließlich dienen sie mir
nach und nach, um bescheidenere Produktionen zu produzieren, aber trotzdem 
Produktionen, wie dieser Trainer. Friedhöfe sind voll von viel besseren
Programmierern, die für immer ignoriert werden, weil sie nie etwas
veröffentlicht haben. Und zumindest wird dieser Code nicht für alle verloren
gehen.
Der Effekt ist trivial. Der Bildschirm ist in Quadrate geschnitten. Jedes
Quadrat ist animiert: In wenigen Bildern werden seine Abmessungen auf fast
nichts reduziert. Bei jedem Frame - oder mehreren, abhängig von der
Geschwindigkeit, die Sie dem Effekt geben möchten - schreitet die Animation
jedes Quadrats um einen Frame voran und kehrt bei Bedarf am Anfang zurück. Der
Trick besteht darin, die Animationen der Quadrate auslaufen zu lassen, das
heißt, sie immer aus dem Frame 0 - völlig leer - zu starten, aber zu
unterschiedlichen Zeiten. Dies ermöglicht es, ein allgemeines Muster zu
erzeugen, wie hier, wo sich der Bildschirm aufzublasen und zu entleeren
scheint:

Eine zyklische Animation von phasenverschobenen Quadraten

Anstatt zu warten, bevor Sie mit der Animation eines Quadrats beginnen, warum
beginnen Sie diese Animation nicht einfach mit der von anderen, aber in einem
anderen Bild? Denn wenn dies der Fall wäre, würde der erste Rahmen des
Übergangs aus Quadraten bestehen, die Quadrate unterschiedlicher Größe
enthalten. Das wäre zu brutal; Es ist besser, dass zu Beginn seiner Animation
ein Quadrat durch ein minimales Seitenquadrat dargestellt wird.
Im Trainer ermöglicht der Effekt, einen Übergang zwischen dem Ende der
zweiten Zwischensequenz und ihrer Wiederaufnahme zu arrangieren, nur um das
Ende zu markieren:

Ein Übergang am Ende der zweiten Zwischensequenz

Die Frames der Animation des Platzes wurden mit einem kleinen HTML5-Tool
generiert, das für diesen Anlass entwickelt wurde:

HTML5-Tool zum Generieren von Bitmaps für die Animation eines Quadrats

Im Allgemeinen ermöglicht dieses Tool die Generierung dieser Art von Animation
auf einer bestimmten Anzahl von Bitebenen und in Form von RAW-Daten - den
Bitebenen eines Frames nacheinander - oder RAWB - den Bitebenen eines Frames,
die mit jeder Zeile verflochten sind. Die Begründung für diese Formate wurde
hier bereits erläutert.
Das Muster, das durch die phasenverschobenen Animationen der Quadrate erzeugt
wird, wurde in einem Excel-Tool entwickelt, das hier wieder für diesen Anlass
entwickelt wurde. Durch die Verknüpfung einer Farbe mit dem Index des
Startrahmens der Animation eines Quadrats macht es dieses Werkzeug einfach,
eine Vorstellung davon zu bekommen, was der Effekt sein wird, der im Maßstab
des Bildschirms erzeugt wird:

Entwerfen von Fräsermustern in Excel

Die Quadrate des Übergangs sind 16 x 16. Ihr Muster ist umgekehrt, in dem
Sinne, dass in einem Frame seiner Animation das Quadrat ein Quadrat von Bits 0
auf einem Hintergrund von Bits 1 ist. Dies ermöglicht es, die Landschaft
allmählich auszublenden, während die Animation der Quadrate endet, wobei der
letzte Frame dieser Animation einfach ein Hintergrund von Bits 1 ist. Um diese
Maskierung zu erzeugen, werden die Quadrate in Bitebene 5 gezeichnet. So
erstreckt sich die Pixelpalette auf dem Bildschirm am Ende des Übergangs nicht
mehr von Color 00 bis 15 aus der Kachelpalette, sondern von Color 16 bis 31, 
die alle in Schwarz fixiert sind.
Die Bedingung für das Stoppen des Übergangs ist, dass alle Quadrate
undurchsichtig sind. Da die Animation jedes Quadrats mit oder ohne Verzögerung
auf der des Übergangs beginnt, ist es schwierig, die Gesamtdauer des Übergangs,
ausgedrückt in Frames, im Voraus zu berechnen. Es hängt von vielen Parametern
ab. Die Datei cutter.s enthält Kommentare, die weitere Details zum Algorithmus
und zu diesem Thema enthalten.
Genau wie der Bannercode wurde der Übergangscode berücksichtigt, um bei anderen
 Gelegenheiten verwendet zu werden. Es ist in der Datei cutter.s gruppiert:
_cutSetup	Eine Initialisierungsroutine auf Basis einer Datenstruktur
 (cutSetupData), deren Offsets der verschiedenen Felder durch Konstanten
 (OFFSET_CUTTERSETUP_*) identifiziert werden.
_cutStep	Eine Schrittroutine, die auf einer Datenstruktur (cutState)
 basiert, deren Offsets der verschiedenen Felder durch Konstanten
 (OFFSET_CUTTER_*) identifiziert werden.
_cutReset	Setzen Sie die Routine zurück.
_cutEnd	Finalisierungsroutine.

DIE TASTATUR

Das Programmieren eines Tastaturtreibers auf dem Amiga ist nicht die einfachste
Sache. Ich habe hier bereits ausführlich erklärt, wie man einfach den Code
einer Taste abruft, die gedrückt und dann losgelassen wird, nicht nur durch
Unterbrechung, sondern auch durch Polling. In diesem Trainer ist es die zweite
Lösung, die beibehalten wird.

Der Treiber verarbeitet Drücken, gefolgt von Loslassen der folgenden Tasten:
Während des Menüs wechselt die Taste Leertaste zur zweiten Zwischensequenz.
Während des Menüs spielt eine Taste, die einer Zahl entspricht - die
Tastenreihe über den Buchstaben, nicht die auf dem Ziffernblock - ein
bestimmtes Stück des Moduls ab;
Während der zweiten Zwischensequenz wechselt die Leertaste zum Menü, außer
während der Banneranzeige und des Übergangs.
Was weiter geklärt werden sollte, ist, dass der Tastaturtreiber nicht immer
aktiv ist. Insbesondere das Drücken und anschließende Loslassen der Leertaste
beim Animieren des Banners während der zweiten Zwischensequenz oder während des
Übergangs am Ende der letzteren erzeugt nichts. Der Spieler könnte jedoch damit
rechnen, zurück in das Menü geschickt zu werden, wie es der Fall ist, wenn er
diese Taste zu einem anderen Zeitpunkt während dieser Zwischensequenz drückt
und dann wieder loslässt. Warum also die Tastatur ausschalten?
Der Grund dafür ist, dass es die Verwaltung der Ausgabe dieser beiden Zustände
der Zwischensequenz vereinfacht. Anstatt sich mit einem Fall befassen zu
müssen, in dem Sie aussteigen müssen, wenn weder das Banner noch der Übergang
im Gange sind, einen Fall, in dem das Banner in Bearbeitung ist, und einen
Fall, in dem der Übergang im Gange ist, verwalten Sie einfach den ersten Fall.
Das Verlassen des Banners oder des Übergangs erfordert eine Reihe von
Operationen, um die aus dem Menü verwendeten Bitebenen so wiederherzustellen,
wie sie sind. Es ist besser, diese Komplikation auf Kosten einer
Neutralisierung der Tastatur zu sparen, die der Spieler wahrscheinlich nie
bemerken wird, das Banner und der Übergang dauern nur kurze Zeit.
Es reicht jedoch nicht aus, den Fahrer nicht mehr anzurufen, um die Tastatur
zu schneiden. In der Tat, jedes Mal, wenn der Spieler eine Taste drückt und
loslässt, sammelt sich der Code des letzteren in einem Puffer der Hardware.
Wenn der Treiber reaktiviert wird, beginnt er daher, jeden Schlüssel zu
verwalten, dessen Code sich im Puffer befindet. Dies kann diesen besonders
unerwünschten Effekt der Berücksichtigung der Verzögerung des Drucks mit
anschließender Freigabe eines Schlüssels hervorrufen.
Es ist daher notwendig, diesen Puffer zu leeren, bevor der Treiber wieder
aktiviert wird. Dies ist die Rolle dieses kleinen Codestücks, das in einem
Makro berücksichtigt wird, das leicht an den verschiedenen Stellen wiederholt
werden kann, an denen es notwendig ist, dh während der Animation des Banners
und des Übergangs. Im vorliegenden Fall

EMPTY_KEYBOARD:	MACRO
_keyboardFlush\@:
	btst #3,$BFED01
	beq _keyboardEmpty\@
	bset #6,$BFEE01
	WAIT_RASTER 2
	bclr #6,$BFEE01
	WAIT_RASTER 16		; Time required by CIA to move 8 bits from 10 keys
					; keyboard buffer to SDR and set the interrupt bit in ICR
	bra _keyboardFlush\@
_keyboardEmpty\@:
	ENDM	

DIE MUSIK

Nach der Veröffentlichung einer Kleinanzeige auf Wollte ich Freunde finden, um
meine Serie von Ehrungen zu produzieren, kontaktierte mich der ausgezeichnete
JMD, um mir seine Dienste als Musiker anzubieten.
JMD ist besonders versiert in der Kunst der Chiptunes, wie jeder sehen kann,
indem er einige seiner Produktionen auf Bandcamp oder ausführlicher AMP hört.
Außerdem, was nicht meine Überraschung war, zu finden, dass wir in der Liste 
der Spiele, an denen er teilgenommen hat, Despot Dungeon finden, das das ganze
Aussehen eines Ultima-ähnlichen hat!
Danke an JMD, denn ich muss sagen, dass er mir ein Modul mit kleinen Zwiebeln 
komponiert hat. Denken wir darüber nach: Letzteres hat fast ein Dutzend 
benutzerdefinierte Melodien, entsprechend den Themen, die ich ihm angegeben
hatte. Profi-Arbeit!
Darüber hinaus habe ich angesichts der Qualität der bereitgestellten Arbeit
sofort bedauert, dass der Spieler schließlich nur kurze Passagen hören konnte,
während er sich die Zwischensequenz ansah. Da der Tastaturtreiber vollständig
programmiert war, war es nicht angebracht, die Möglichkeit hinzuzufügen, die
numerischen Tasten zu drücken - nicht die gepflasterten, sondern die über
den Zeichen -, um jede der Melodien nach Belieben zu hören?
Sobald es gesagt wird, sobald es getan ist! Es reichte, um ein paar Zeilen
hinzuzufügen. Der Spieler wird daher aufgefordert, die Tasten 1 bis 8 zu 
drücken, um die verschiedenen Songs in ihrer Gesamtheit anzuhören.
Ich nutze diese Gelegenheit, um phx, der immer noch auf Amiga aktiv ist, für
die routinemäßige Wiedergabe von ProTracker-Modulen zu grüßen - am Rande von
StingRay retuschiert. Wir vergessen immer, ihm zu danken, während seine Routine
in den Produktionen der Szene genauso verwendet werden muss, wie Forbid ().
Frank Wille - weil er es ist - gab dieses Interview im Jahr 2016. Es zeigt
das Ausmaß seines Beitrags.

SCROLLEN SIE ES

Ich würde den Scroller vergessen! Es wäre eine Schande, es nicht zu erwähnen,
denn es zeigt, wie es möglich ist, Copper zu verwenden, um die Auflösung des
Bildschirms an jeder Linie des letzteren zu ändern. In der Tat ist der
Scroller in HiRes (640x256), während alles andere in LowRes (320x256) ist.
Ich hatte bereits zuvor einen Scroller in HiRes programmiert. Tatsächlich
erscheint einer am unteren Rand des ersten - wenn ich mich richtig erinnere
- Cracktro, den ich produziert habe:

Scrollen Sie HiRes im Cracktro von Flashback

Und in diesem anderen Cracktro hatte ich die Möglichkeit genutzt, die
Bildschirmauflösung von einer bestimmten Zeile aus zu ändern - mehr in
Interlaced:

Auflösungsänderung im Ishar II Cracktro

Im Trainer ist der Scroller aus zwei Gründen recht optimal:
es basiert auf Hardware-Scrolling;
Bei jedem Schritt wird ein Charakter kopiert, ein anderer geschrieben.

Scrollen ist Hardware. Auf der Höhe des Scrollers wird der Inhalt des berühmten
BPLCON1-Registers - das gleiche, das umgeleitet wurde, um Hardware-Zoom zu
machen - geändert, um das Bild nach links zu verschieben. In HiRes
interpretiert die Hardware jedoch nicht die Werte der PF2H3-0- und PF1H3-0-Bits
wie in LowRes. In HiRes reichen die möglichen Werte für PFxH3-0 nicht von
0 bis 15, sondern von 0 bis 7, und jedes Inkrement von 1 verschiebt die
betroffenen Bitebenen um 2 Pixel HiRes (1 Pixel LowRes).

In den folgenden Tabellen können Sie sich zurechtfinden. Für eine gegebene
scrollende Amplitude geben sie den Wert der PFxH3-0-Bits an, die in BPLCON1
geschrieben werden sollen, und den Offset, der in BPLxPTH/L geschrieben werden
soll, und daher die Formel, die es ermöglicht, die Werte der PFxH3-0 von denen
der Amplitude zu finden:

LowRes
Amplitude	BLPCON1		BPLxPTH/L
	0		$0000		+0
	1		$00FF		+2
	2		$00EE		+2
	...		
	14		$0022		+2
	15		$0011		+2
	16		$0000		+2
	17		$00FF		+4
	...		
	31		$0011		+4
	32		$0000		+4
	33		$00FF		+6
	...

Entgelte
Amplitude	BLPCON1		BPLxPTH/L
	0		$0000		+0
	1		$0000		+0
	2		$0077		+2
	3		$0077		+2
	4		$0066		+2
	5		$0066		+2
	...		
	12		$0022		+2
	13		$0022		+2
	14		$0011		+2
	15		$0011		+2
	16		$0000		+2
	17		$0000		+2
	18		$0077		+4
	19		$0077		+4
	...		
	30		$0011		+4
	31		$0011		+4
	32		$0000		+4
	33		$0000		+4
	34		$0077		+6
	35		$0077		+6
	...

Aus der Analyse der vorangegangenen Tabellen geht hervor, dass:

In LowRes ist der Wert von PFxH3-0 (~(Amplitude-1))&$F:
In HiRes  ist der Wert von PFxH3-0 (~((Amplitude>>1)-1))&$7.

Bei jedem Schritt wird ein Charakter kopiert, ein anderer geschrieben. Wenn
der Bildlauf ein Streifen des Bildschirms ist, der auf der linken Seite
scrollt, hat dieser Streifen notwendigerweise ein Ende. Dies impliziert, dass
es irgendwann notwendig sein wird, am Anfang dieses Bandes zurückzugehen. Da
dadurch Zeichen angezeigt werden, die längst nach links gescrollt haben,
empfiehlt es sich daher, das Ende des Bandes an den Anfang zu kopieren, bevor
man die Schriftrolle am Anfang fortsetzt.
Die Technik, die spontan in den Sinn kommt, besteht darin, einen Streifen zu
verwenden, dessen Breite einfach um ein Zeichen auf der rechten Seite erhöht
wird. In diesem Beispiel ist der Bildschirm drei Zeichen breit:

Die Bedienung des Bildlaufs in einfacher Breite

Diese Technik hat jedoch einen Nachteil. Wenn es an der Zeit ist, einen neuen
Charakter am Ende des Bandes zu schreiben, müssen Sie zuerst die drei letzten
Zeichen am Anfang des Bandes kopieren. Bilanz: vier Zeichen manipuliert.
Eine bessere Lösung ist die Verwendung eines Streifens, dessen Breite um so
viele Zeichen erhöht wird, wie die Bildschirmbreite anzeigen kann. Um das
vorherige Beispiel zu verwenden, ist das Band sechs Zeichen breit:

Die Bedienung des Bildlaufs in doppelter Breite

Hier, wenn die Zeit gekommen ist, einen neuen Charakter zu schreiben, wird das
zuletzt geschriebene Zeichen - das dann auf der rechten Seite des Bildschirms
vollständig angezeigt wird - zuerst auf die linke Seite des Bildschirms kopiert.
Balance: nur zwei Charaktere manipuliert.
Die Kombination aus dem Hardware-Scroll und dem Streifen mit doppelter Breite
bedeutet, dass im Trainercode der Speicherblock, der zum Anzeigen des Bildlaufs
verwendet wird, scrollFrontBuffer, eine Breite von ((2*SCROLL_DX+16)>>3) Bytes
hat, SCROLL_DX 640 Pixel wert. Der Grund, warum der Hardware-Scroll
zusätzliche 16 Pixel benötigt, wird hier nicht näher erläutert. Dies wird dort
im Amiga Hardware Reference Manual sehr gut erklärt.

Genau wie der Bannercode und der Übergangscode wurde der Übergangscode
berücksichtigt, um bei anderen Gelegenheiten verwendet zu werden. Es ist in
der scroll.s-Datei gruppiert:
_sclSetup	Eine Initialisierungsroutine basierend auf einer Datenstruktur
 (sclSetupData), deren Offsets der verschiedenen Felder durch Konstanten
 (OFFSET_SCROLLSETUP_*) identifiziert werden.
_sclStep	Eine Schrittroutine, die auf einer Datenstruktur (sclState)
 basiert, deren Offsets der verschiedenen Felder durch Konstanten
 (OFFSET_SCROLL_*) identifiziert werden.
_sclEnd	Finalisierungsroutine.
Ausnahmsweise sehe ich im Nachhinein, dass es keine routinemäßige
 _sclReset gibt. Ich muss den Schleim gehabt haben, um fertig zu werden...

DIE HAUPTSCHLEIFE

An dieser Stelle bleibt nur noch, über die Hauptschleife zu sprechen,
insbesondere über die Art und Weise, wie die verschiedenen Teile des Trainers
miteinander verbunden sind.
Die Schleife ist einfach eine Reihe von Tests von Flags, die in einem WORD bei
mainState gespeichert sind, was den Zustand des Automaten des Programms zum
gegenwärtigen Zeitpunkt widerspiegelt:

STATE_CUTSCENE_RUNNING=$0001
STATE_CUTSCENE_ENDING=$0002
STATE_BANNER_RUNNING=$0004
STATE_MENU_RUNNING=$0010
STATE_KEYBOARD_RUNNING=$0020

Wenn eine Aktion eine Änderung des Zustands des Controllers bewirken muss,
werden bestimmte Flags gelöscht und/oder positioniert. Wenn beispielsweise das
Menü angezeigt wird - das ist der Startstatus - markiert die Flags 
STATE_CUTSCENE_RUNNING, STATE_KEYBOARD_RUNNING, STATE_MENU_RUNNING.
Während einer Iteration der Hauptschleife wird jedes Flag getestet und führt
zur Ausführung eines zugeordneten Codeabschnitts. Im vorherigen Fall also:
STATE_CUTSCENE_RUNNING bewirkt, dass die Zwischensequenz animiert wird, deren
 Adresse in cutScene gespeichert ist ;
STATE_KEYBOARD_RUNNING bewirkt, dass die Tastatur getestet wird, indem die
 Aktion ausgeführt wird, die mit dem möglichen Loslassen einer Taste verbunden
 ist.
STATE_MENU_RUNNING führt dazu, dass die Maus getestet wird und die Aktion mit
 einer möglichen vertikalen Bewegung oder dem Loslassen einer Taste verbunden
 ist.
Einige Flags werden gelöscht, wenn der AUTOMATon in einen bestimmten Zustand
 wechselt. Wenn der Benutzer beispielsweise im vorherigen Zustand - dem
 Trainermenü, das in der ersten Zwischensequenz angezeigt wird - die Leertaste
 drückt, wechselt die SPS in den Zustand, in dem die zweite Zwischensequenz
 abgespielt wird, ohne dass ein Menü angezeigt wird. Das Menü muss nicht mehr
 verwaltet werden, sodass das Flag STATE_MENU_RUNNING nicht mehr in menuState
 positioniert ist.
Alles in allem ist die Struktur der Hauptschleife nur eine
Schalterverschachtelung. Eine andere Lösung wäre gewesen, eine Tabelle mit
Routinezeigern zu erstellen und die Hauptschleife auf Manipulationen in dieser 
Tabelle zu beschränken, wobei der gesamte Code ansonsten in die fraglichen
Routinen einbezogen wird. Da ich jedoch wusste, dass es wenig Code gab, zog
ich es vor, nicht so weit zu gehen.

BITTE SCHÖN!

Unkomprimiert wiegt der Trainer 91.852 KB. Dies ist enorm für einen Trainer,
Glücklicherweise kann ein Problem dieser Art auf Amiga dank eines Crunchers 
behandelt werden, dh eines Programms, das ein anderes komprimieren kann und
eine ausführbare Datei erzeugt, die alles enthält, was Sie brauchen, um 
diese komprimierte Version zu dekomprimieren, sobald sie in den Speicher
geladen wurde.
In diesem Fall wurde die ausgezeichnete Crunch-Mania gewählt, die ebenso
elegant wie effektiv war. Dieser Cruncher verbogen sich in vier, oder besser
gesagt, er schaffte es, den Trainer in vier zu biegen, wodurch eine 
ausführbare Datei von nur ... 26.416 KB! Zweifellos bleibt dies für einen
Trainer sehr wichtig, aber es ermöglicht es, es für viele Spiele zu verwenden,
die nicht die gesamten 880 KB einer Diskette einnehmen.

Crunch-Mania, um den Trainer in vier zu falten

Und wie üblich endet ein Abenteuer von Asterix dem Gallier immer um ein gutes
Bankett herum, eine Produktion dieser Art muss unweigerlich mit Grüßen enden.
Ich möchte daher insbesondere folgendem danken:

JMD für seine exzellente Musik;
StingRay für die Gelegenheit, diesen Trainer zu produzieren.

Bis bald zum nächsten? Es soll eine Hommage an Sysops in Form eines BBS-Intros
für die Band Desire sein. Ich schulde dies Ramon B5, dass er den Tag auf
Scoopex "TWO" gerettet hat.

WAS IST MIT TILESET?

Um das Kachelset nachzubilden, zum Beispiel aus dem Ultima V, das Sie hier
finden, beginnen Sie mit der Erstellung eines PNG von 4 x 21 Kacheln.
Stellen Sie dann Ihr Kachelset nach diesem Modell zusammen:

Kind		(1/4)	Kind		(2/4)	Kind		(3/4)	Kinder			(4/4)
Schurke		(1/4)	Schurke		(2/4)	Schurke		(3/4)	Schurke			(4/4)
Krieger		(1/4)	Krieger		(2/4)	Krieger		(3/4)	Krieger			(4/4)
Bettler		(1/4)	Bettler		(2/4)	Bettler		(3/4)	Bettler			(4/4)
Troll		(1/4)	Troll		(2/4)	Troll		(3/4)	Troll			(4/4)
Avatar		(1/4)	Avatar		(2/4)	Avatar		(3/4)	Avatar			(4/4)
Soldat		(1/4)	Soldat		(2/4)	Soldat		(3/4)	Soldat			(4/4)
Guy			(1/4)	Guy			(2/4)	Guy			(3/4)	Guy				(4/4)
Daemon		(1/4)	Daemon		(2/4)	Daemon		(3/4)	Daemon			(4/4)
Geist		(1/4)	Geist		(2/4)	Gespenst	(3/4)	Gespenst		(4/4)
Schwarzdorn	(1/4)	Schwarzdorn (2/4)	Schwarzdorn (3/4)	Schwarzdorn		(4/4)
Lord Brite	(1/4)	Lord Brite	(2/4)	Lord Brite	(3/4)	Lord Brite		(4/4)
Schattenlord (1/4)	Schattenlord (2/4)	Schattenlord (3/4)	Schattenlord	(4/4)
Drache		(1/4)	Drache		(2/4)	Drache		(3/4)	Drache			(4/4)
Ork			(1/4)	Ork			(2/4)	Ork			(3/4)	Ork				(4/4)
Zaubertrank			Pergament			Schwert				Schild
Stubenwagen			Rüstung				Explosion			Blut
Gras				Busch				Wald (klein)		Wald (mittel)
Wald (groß)			Baum				Steine				Wanderweg (N-S)
Wanderweg (E-O)		Wanderweg (N-E)		Loipe (N/A)			Wanderweg (S&E)
Wanderweg (NW)		Grab				Wanderweg (NSEO)	Toter Baum

Sie können sich auf den Codex der Ultima-Weisheit beziehen, um sich in den
Kreaturen zurechtzufinden.
Laden Sie dann das BOBsConverter-Tool.html das sich im Verzeichnis tools
befindet. Vorsichtig! Stellen Sie sicher, dass Sie Ihr PNG im Verzeichnis
ablegen, bevor Sie das Tool verwenden, da die Sicherheitseinschränkungen des
Browsers es Ihnen verbieten, eine PNG-Datei von einem anderen Ort als diesem 
Verzeichnis hochzuladen.
Laden Sie im Tool Ihre PNG-Datei hoch. Letzteres sollte in der Eingabe
angezeigt werden. Wählen Sie das RAWB-Format aus, und klicken Sie dann auf
Konvertieren!. Das Ergebnis der Konvertierung sollte in der Ausgabe angezeigt
werden. Kopieren Sie den Code, der im Datenfenster angezeigt wird, und fügen
Sie ihn in eine Datei ein. Laden Sie diese Datei in ASM-One, assemblieren Sie
sie mit dem Befehl A, und speichern Sie dann die resultierende Binärdatei in
einer Datei tiles.rawb mit dem Befehl WB, der start und end als Start- und
Endbezeichnung angibt.
