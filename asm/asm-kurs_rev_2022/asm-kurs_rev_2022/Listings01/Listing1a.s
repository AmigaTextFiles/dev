
; Listing1a.s		by Fabio Ciucci - Assemblieren mit "A", ausführen mit "J"

Waitmouse:						; diese LABEL steht als Referenzpunkt für das bne
	move.w	$dff006,$dff180		; gib den Wert von $dff006 in $dff180
								; also von VHPOSR in COLOR00
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	Waitmouse			; wenn nicht, kehre zu Waitmouse zurück
								; und wiederhole
	rts							; Ende, steig aus

	END

Anmerkung: der Befehl MOVE bedeutet soviel wie "Bewege", besser noch kopiere
den Wert, der im ersten Operand enthalten ist, in den zweiten, in diesem Fall
"LESE DEN WERT IN $DFF006 UND GIB IHN IN $DFF180". Das .w bedeutet, dass
ein Word bewegt wird, also 2 Bytes -> 16 Bit (1 Byte = 8 Bit, 1 Word = 16
Bit, 1 Longword = 32 Bit).
Anmerkung 2: das BTST, gefolgt vom BNE dient dazu, einen Sprung im Programm
zu machen, wenn eine Kondition eintrifft; es läßt sich so übersetzen:
BTST = KONTROLLIERE, OB FRITZ DEN APFEL GEGESSEN HAT, UND SCHREIBE ES AUF
EIN STÜCK PAPIER.
BNE = DAS BNE LIEST AUF DEM STÜCK PAPIER, OB FRITZ DEN APFEL GEGESSEN HAT,
ER WEISS, DAß ER DAS NICHT SELBST TUN KANN, DAFÜR HAT ES IHM SEIN FREUND
BTST GETAN... IM FALLE, DASS AUF DEM PAPIERFETZEN STEHT, DASS FRITZ DEN APFEL
NICHT GEGESSEN HAT, DANN SPRINGE ZUM ANGEGEBENEN LABEL
(BEI UNS BNE.S Waitmouse).
Praktisch, wenn Fritz den Apfel nicht gegessen hat, springt der Prozessor
zum Waitmouse zurück und wiederholt alles; wenn er ihn hingegen gegessen
hat, dann springe nicht zu Waitmouse, sondern fahre unter dem Befehl BNE
fort. Hier findet er beim Beispielprogramm ein RTS, und damit ist das
Programm zu Ende.
Das Stück Papier, auf dem das BTST das Urteil für das BNE schreibt, heißt
STATUS REGISTER, oder SR. Wenn statt dem BNE ein BEQ stehen würde, dann
würde die Schleife nur solange ausgeführt, solange der Mausknopf gedrückt
ist, und würde enden, sobald er losgelassen würde. (Das Gegenteil: Denn
BNE bedeutet BRANCH IF NOT EQUAL, also SPRINGE, WENN NICHT GLEICH (falsch),
während BEQ für BRANCH IF EQUAL steht, SPRINGE WENN GLEICH (wahr)).
In der ersten Zeile wird der Wert ausgelesen, der sich in $dff006 befindet,
also die Position des Elektronenstrahls auf dem Monitor, die sich klarerweise
dauernd ändert (so um die 50 mal pro Sekunde). Dieser Wert wird dann
in die Adresse $DFF180 geschrieben, die die Farbe 0 kontrolliert, als
Folge davon erhält man also den Bildschirm, der flackert, da die Farbe stets 
geändert wird.
Verifiziert, daß $DFF006 VHPOSR ist, indem ihr "=C 006" eintippt, das
gleiche gilt für $DFF180 mit "=C 180". Diese Hilfe könnt ihr dem ASMONE
über jedes Register aus der Reihe $DFFxxx abverlangen.
Das Format der Farben ist das folgende: $0RGB, das Word (2 Byte) des 
Registers ist also in RED, GREEN, BLUE aufgeteilt, mit 16 Tonalitäten
(Farbabstufungen) pro Farbe; durch Mischen wie mit der PALETTE des
Deluxe Paint kann man so eine der 4096 möglichen Farben auswählen
(16x16x16=4096). Jeder Wert von Red, Green und Blue, also Rot, Grün
und Blau, geht von 0 bis F (Hexzahlen...!). Probiert z.B. die erste 
Zeile durch MOVE.W #$000,$DFF180 zu ersetzen: ihr werdet den Bildschirm
in elegantes Schwarz hüllen, oder mit MOVE.W #$000e,$DFF180 , das
ergibt ein modisches Blau, und mit MOVE.W #$cd0,$dff180 ein freches
Gelb (Rot + Grün). Probiert selbst, die Farben zu tauschen, um zu
kontrollieren, ob ihr den Mechanismus verstanden habt.
#$444 = Grau, #$900 = Dunkelrot, #$e00 = helles Rot, #$0a0 Grün...
Wenn ihr nun $dff180 durch $dff182 ersetzt, blinken nun die Schriften
an Stelle des Hintergrundes, also das, was mit Farbe 1 (Color1) 
"gemalt" ist.
Der Befehl BTST kontrolliert, ob ein bestimmtes Bit an einer Adresse 0 ist
Erinnert euch, dass die Bits von rechts nach links gelesen werden und
dass man bei 0 startet, z.B. in einem Byte, das so aussieht:
%01000000  Hier ist das sechste Bit auf 1:

76543210				5432109876543210
01000000 	ein Word:	0001000000000000 <= Hier ist Bit 12 auf 1!

P.S: Das erste Bit wird Bit 0 und nicht Bit 1 genannt, da darf man sich
     nicht verfehlen, also daß das siebte Bit "Bit 6" genannt wird. Um
     nichts falsch zu machen, gebt ev. eine Numerierung über die
     Binärzahl.

Das Bit 6 von $bfe001 ist der linke Mausknopf. Der Name des Registers
ist CIAAPRA, aber das merkt sich sowieso niemand...
Der rechte Mausknopf hingegen befindet sich auf Bit 2 von $dff016. Testet
mal, was passiert, wenn ihr BTST #6,$bfe001 mit BTST #2,$bfe016 ersetzt.
Was wohl...jetzt braucht´s den rechten Mausknopf, um alles abzubrechen!
Macht mir ja alle vorgeschlagenen Änderungen, dann übt ihr!!
Anmerkung: Wenn ihr die Programme so speichern wollt, daß sie von
der Shell/CLI ausführbar sind, müßt ihr nur ein "WO" tippen, nachdem
ihr mit "A" assembliert habt. Gebt im Fenster einen Namen ein, und
speichert es auf eine andere Diskette ab! Wehe, ihr überschreibt
meinen Kurs!!! Schreibschutz zu!
Wollt ihr aber das Listing abspeichern, tippt "W" (immer auf eine andere
Diskette !!!)

PSPS: Habt ihr beim BNE den Suffix bemerkt? Er war weder .B, noch .W
und auch nicht .L! Bei Befehlen wie BNE, BEQ, BSR kann man nur zwischen
.B und .W auswählen, am Resultat ändert sich aber nichts, denn BNE.B
tut genau das gleiche wie BNE.W. Bei diesen Befehlen ist erlaubt, ein
.s anstelle des .B zu verwenden, es steht für SHORT (kurz), und man
kann es nur verwenden, wenn das Label, das angesprungen werden soll,
nicht zu "weit weg" liegt. Ansonsten ersetzt der ASMONE während des 
assemblierens automatisch das .s in .W. Da das .S (das wie gesagt für
.B steht, nur für solche Instruktionen in Frage kommt, glaube ich, ist
es besser, man verwendet es. Nun wißt ihr´s, es dürften keine Probleme
mehr auftreten.
PSPSPS: Wenn ihr trotzdem ein .L unterschmuggelt, sieht es der ASMONE
als .W, und assembliert es dementsprechend, andere Assembler melden
einen Fehler. Wenn ihr vergesst, einen Suffix zu geben (BNE LABEL), 
wird es immer als .W interpretiert. Das gleiche gilt für die anderen
Befehle. Ein MOVE $10,$20 ergibt keinen Fehler, denn es wird als
MOVE.W $10,$20 angesehen. DAS BEDEUTET ABER NICHT, DAß ALLE ASSEMBLER
GLEICH GÜTIG SIND!! Daher hängt ihn immer an, es ist auch ästhetisch
schöner... 

