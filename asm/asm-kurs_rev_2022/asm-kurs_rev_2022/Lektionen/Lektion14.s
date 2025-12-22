
ASSEMBLERKURS - LEKTION 14

		- Wellen der Akustik und digitales Audio -

(Verzeichnis Sorgenti8) - dann schreibe "V Assembler3:sorgenti8"

			         ___
			       _(   )_
			    __( . .  .)__
			  _(   _ .. ._ . )_
			 ( . _/(_____)\_   )
			(_  // __ | __ \\ __)
			(__( \/ o\ /o \/ )__)
			 ( .\_\__/ \__/_/. )
			  \_/ (_.   ._) \_/
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


Autor: Alvise Spano'

Wie Sie alle wissen, ist Schall nichts anderes als eine WELLE, das heißt, nach 
der physikalischen Definition ist es die "Ausbreitung einer Schwingung im
Raum".
Bei den Geräuschen, die wir gewohnt sind, wird die Welle zunächst durch die
Schwingung der Materie emittiert (Moleküle und / oder Atome) und das Medium ist
Luft. Eine Welle ist eine Schwingung, ein kontinuierlicher Austausch von
kinetischer und potentieller Energie, daher mechanisch, zwischen Molekülen
und / oder Atomen. Physikalisch ist es die Druckänderung zwischen
Materieteilchen und deshalb braucht es Materie, um zu existieren und sich zu
verbreiten. Im Vakkum beispielsweise breitet sich weder eine Schallwelle noch
eine andere Art von Vibration zwischen zwei verschiedenen und getrennten
Körpern aus. Nur elektromagnetische Strahlung - zumindest bis jetzt schaffen
es die einzigen, mit denen er vertraut ist. Bewegen Sie sich auch in einem
Vakuum dank ihrer doppelten physischen Natur von beiden Körper mit Masse -
wenn auch sehr klein - (Photon und Welle).
Das physikalische Modell zur Beschreibung dieses kontinuierlichen Verlaufes
von einem Punkt der Bewegung zum anderen wird als Graph der trigonometrischen
SINUS (= sin) Funktion dargestellt, das ist ein SINUSKURVE.

>>> WELLENFUNKTION: y = f(x ± v*t) <<<

x z.B.: HARMONISCHE WELLENGLEICHUNG: y = asink(x±vt) = a * sin(k * (x ± v * t))

		    - y = VARIABLE ZEITABHÄNGIG: in einem zweidimensionalen 
			  kartesischen Diagramm (x,y), repräsentiert y die Ordinate 
			  die "Höhe" zu jedem x-Punkt der Schwingung.

		    - a =  VERSTÄRKUNGSKOEFFIZIENT DER WELLE: Nun, wie sie wissen
			  werden, -1 <= sin(x) <= 1 (Sinus von x  (x = jede reelle Zahl)
			  zwischen -1 und 1, inklusiv der Extreme.) Also, um verschiedene
			  Schwingungen mit -a bis a (-a <= sin (x) <= a) zu bekommen ist es 
			  notwendig sin (x) mit einer reellen Zahl a zu multiplizieren.

		    - k = FREQUENZ DER WELLE: durch Variieren dieses Parameters
			  wird die Frequenz variiert und umgekehrt proportional die
			  Periodendauer der Welle, das heißt das minimale Intervall
			  entlang der Achse der unabhängigen Variable (in diesem Fall x)
			  wobei die Sinuskurve ein zyklischer Weg ist, dh das
			  Mindestintervall. Danach nimmt (hat) die Welle die gleichen
			  Eigenschaften an. An dieser Stelle stellen wir das Konzept der
			  WELLENLÄNGE vor (= Raum von der Periode abgedeckt = Abstand
			  zwischen zwei Wellenbergen benachbarter Zyklen) und vertiefen die
			  Frequenz: die Häufigkeit mit der sie mit den gleichen
			  Eigenschaften von der Welle in einer Zeiteinheit wiederkommt oder
			  wie oft pro Sekunde die Periode gelesen wird (= Zyklen pro
			  Sekunde). Normalerweise wird die Sekunde als Einheit der Zeit
			  betrachtet und Hertz [Hz = s ^ -1 = 1 / s] als Einheit der
			  Frequenzmessung.			  

		    - x = VARIABLE UNABHÄNGIG: in einem zweidimensionalen 
			  kartesischen Koordinatensystem (x,y), repräsentiert die Abszisse x
			  einen Punkt entlang einer geradlinigen räumlichen Dimension
			  in einem bestimmten Moment. x gehört zu den reellen Zahlen und
			  hat theoretisch keine Einschränkungen, das heißt, es umfasst die
			  gesamte Linie in der Ebene. Es betrachtet (x, y) als eine
			  Sinuswelle, die endlos fortschreitet nach links und rechts.
			  Der Ursprung der O-Achsen ist (0,0): das ist leicht zu verstehen,
			  da die Sinusfunktion periodisch ist. Zum Beispiel, wenn k = 1,
			  die Periode der Welle von 360 Grad (= 2*PI radiant) ist, ist die
			  Frequenz 1 Hz. Wenn k = 2, die Periode von 180° (= PI rad) ist,
			  ist die Frequenz gleich 2 Hz und so weiter.

		    - v = GESCHWINDIGKEIT DER AUSRBREITUNG: zeigt die Geschwindigkeit
			  im kinematischen Sinn an mit dem sich ein Punkt der Welle im Raum
			  bewegt. Beachten Sie, dass v = WELLENLÄNGE * FREQUENZ ist.

		    - t = ZEIT: Denken Sie daran, das v * t = s = Weg ist und s ist der
			  aufgenommene Abstand zwischen zwei korrespondierenden Punkten der
			  gleichen Bewegung. Eine Ausbreitung von x ist daher nicht anderes,
			  als s zu x zu addieren bzw. von x zu subtrahieren. Eine Bewegung
			  der Welle im Raum erfolgt mit der Zeit. Es ist zu beachten, dass
			  sich die Welle mit (x + s) nach rechts und mit (x - s) nach links
			  entlang der Abszissen-Achse bewegt.

			  P.S.: Ich entschuldige mich für die Eile der Erklärungen und das
			  Fehlen von Demonstrationen, aber es scheint mir nicht erforderlich
			  übermäßig mit diesem Thema zu verlängern, da es für Assembler und
			  die Codierung im Allgemeinen nicht relevant ist.				
			  Also nehmen Sie bitte die obigen Erklärungen wie sie sind und 
			  Sorgen Sie sich nicht zu sehr, wenn Sie die Wellenphysik nicht
			  verstanden haben: Sie werden es nicht brauchen um am Ende Musik
			  in ein Spiel oder Demo einzufügen.

		      N.B.: Denken Sie daran, dass x und y zwei beliebige Eigenschaften
			  des Ausbreitungsphänomens darstellen. Bei Schallwellen betrachten
			  wir x und y als zwei räumliche Dimensionen, die einen Zustand der
			  Welle beschreiben.

	                         ·      ·
	                         :      :
	                 ________¦      ¦________
	                 \       |  __  |       /
	__________________\_____ | _\/_ | _____/__________________
	\____________________  / | \/\/ | \  ____________________/
	         \____________ \_|._  _.|_/ ____________/
	                \  ____ _)| \/ |(_ ____  /
	                 \/   / \__¯`'¯__/ \   \/
	                     / /  /    \  \ \
	                     \/ \ `····' / \/
	                         \      /
	                          \    /
	                           \  /sYz
	                            \/

Jetzt können wir vermitteln, was wir aus den Hinweisen der Physik gelernt haben
allgemein von den Phänomenen der Ausbreitung in der tatsächlichen Akustik. 
Das Konzept der HARMONISCHEN: ein Klang -  in der Natur nicht existent und nur
mit elektronischen Instrumenten wie dem Computer reproduzierbar zeigt die
Wellenform (= Graph (x, y) entlang des Ganzen seiner Dauer als Sinuskurve.
Wir können sagen, dass die Harmonischen das Modell des einfachen Klangs ist,
der viele andere verbindet um alle NICHT reinen Klänge zu erzeugen. Die Physik
unterscheidet immer 3 Qualitäten in einem Klang, so das es beschrieben werden
kann:
	
	   1- Höhe:     Ausserhalb von Reinen-Klängen bestehend aus nur einer
				Harmonischen, die in der Natur nicht existieren und NATÜRLICH
				aus mehreren Harmonischen bestehenen, die in einem gleichen
				Zeitintervall überlagert sind. Einige von denen, die
				in der Natur existieren haben Tausende von Harmonischen
				mit unterschiedlicher Periode und qualifiziert die Frequenz.
				Durch Ändern werden die verschiedenen Noten erzeugt.

	   2- INTENSITÄT:  Was als eine Art "Volumen" des Klangs angesehen werden
				kann und im Fall von Harmonischen ist es direkt proportional
				zur Verstärkung (absoluter Wert	der Y-Dimensionen der
				Amplituden)	der Sinuskurve.

	   3- TON:      Welches die Schallwellenform unabhängig von den beiden
				vorhergehenden Parametern qualifiziert. Es beschreibt im Grunde
				das Musikinstrument oder allgemeiner, den Unterschied eines
				Tons von einem anderen, unabhängig von seiner Höhe und
				Intensität.

Vergessen Sie die verschiedenen Formeln, um die Schallintensität zu berechnen
und Druck- und Intensitätspegel [deciBell = dB], die die elektronische Musik
nicht direkt berühren. Die Akustik als Zweig der Physik befasst sich mit der 
Ausbreitung von Geräuschen in der Umgebung und der Gestaltung von Geräten,
die Schall reproduzieren (Lautsprecher usw.) oder aufnehmen (Mikrofone,
etc.) und lassen Sie uns auf die Tonhöhe und den Ton eingehen.

*** Zunächst ist der Ton selbst ein nicht existierender Parameter: Der Computer
unterscheidet keine Töne und konvertiert die im Speicher befindlichen
digitalen Daten in analoge Signale (die elektrischen und Nicht-Bit-Intensität
übertragen) gemäß einer Lesefrequenz und einem gegebenen Unterverstärkungswert,
unabhängig von einem Unterschied zwischen Ton und Geräusch - zwei Konzepte, nur
wir Menschen haben dem verschiedenen Bedeutungen gegeben, die auf die
ästhetische Bedeutung zurückgeführt werden kann ***.

Über den Ton als Parameter kann daher elektronisch zumindest nicht richtig
gesprochen werden - obwohl es ausgefeilte Algorithmen zur Identifizierung und
Vergleich der Klangfarbe verschiedener Wellenformen gibt. Sie könnten für
diejenigen nützlich sein, die beabsichtigen, Routinen zum Beispiel für
Spracherkennung zu programmieren. Wie auch immer, es ist sicher nicht der 
richtige Ort für die Diskussion derart komplexer Anwendungen in der Welt der
Synthese und der Tonverarbeitung geeignet.

Kommen wir also zum wichtigsten Parameter - soweit es uns betrifft: Die Tonhöhe
der Klänge ist bei NATÜRLICHEN Klängen direkt mit der Frequenz der
Grundharmonischen (GRUNDFREQUENZ) verbunden, die sie unterscheidet und im Fall
von REINEN-Klängen mit der Frequenz der EINZIGEN Harmonischen die sie haben.

Nehmen wir ein Beispiel: Wir haben einen reinen Klang (harmonisch) der
Periode X (= Dauer). Es kann mit jeder Frequenz ausgegeben werden, es hängt nur
von der "LESEGESCHWINDIGKEIT" des Klangs durch den Sender ab: Zum Beispiel,
wenn die Harmonische für ihre gesamte Periode 2 mal pro Sekunde ist, ist die
Frequenz 2 Hz. Später tritt auch das Problem der Diffusion auf
Akustik des gegebenen Geräusches in der Luft, die jedoch bald gelöst ist:

Die Geschwindigkeit der Schallausbreitung in der Luft beträgt 380 m/s und es
ist dies bekannt: GESCHWINDIGKEIT = WELLENLÄNGE * FREQUENZ.
Es ist extrem einfach, die Länge der Welle zu erhalten, die in Bezug auf die 
räumliche Dimensionen mit der Periode ausgedrückt in Sekunden zusammenfällt. An 
dieser Stelle kommt ein neuer Parameter ins Spiel, der sich mit den Werkzeugen
der Klangerzeugung befasst: die Lesegeschwindigkeit oder GESCHWINDIGKEIT /
SAMPLINGFREQUENZ.
Um nun fortzufahren, muss jedoch erklärt werden, wie elektronische Instrumente
funktionieren wie sie den Klang behandeln und wie sie ihn verarbeiten, bevor
sie ihn an den Verstärker weiterleiten.

Durch die Verwendung eines Samplers (Audio-Digitalisierers) und einer
geeigneten Software ist es möglich, die von einer Schallquelle kommenden Töne 
(Mikrofon, CD, etc.) in numerischen Daten (digitale Sample) umzuwandeln, von
denen jeder den "Anteil" eines Intervalls (einen "winzigen Teils") beschreibt - 
in wissenschaftlichen Begriffen gesprochen - entlang der Abszisse des Graphen
(x, y) der Wellenlänge. Je mehr Samples wir "fangen", desto definierter und
näher wird der digitale Klang an der physischen Realität sein.
Zum Beispiel, wenn wir einen natürlichen Klang (und daher nicht harmonisch) der
Dauer von 2 Sekunden haben (was wir als Zeitraum nehmen, da es nicht möglich
ist ein niedrigeres Mindestintervall zu finden, für das die Welle zyklisch ist)
sind wir in der Lage die Grundfrequenz abzuleiten. Es reicht aus mit einer
DOPPELTEN Abtastfrequenz (Nyquist-Theorem, wird später erklärt) abzutasten,
um eine originalgetreue und akustisch definierte Reproduktion des Klangs 
zu erhalten.

Zum Beispiel, wenn die Grundfrequenz 2 kHz (= 2000 Hz) ist, sollten wir 2000
Samples pro Sekunde aufnehmen, also insgesamt 4000 Samples
(2000 Abtastwerte / s * 2 s = 4000 Abtastwerte). 

** Jedes Sample (= Sample) belegt im Speicher 8 Bits (= 1 Byte) das dadurch
eine 8-Bit-Sounddefinition annimmt. Mit der 8-Bit-Nummer ist es möglich,
Y-Dimensionen zwischen 
-128 (= -(2^8)/2 = -2^(8-1) = -2^7) und 127 (= (2^8)/2-1 = 2^(8-1)-1 = 2^7-1 
zu beschreiben. (Die Null bedutet ein positives Vorzeichen in binär): In der
Tat die positiven Zahlen sind von 0 bis 127 und damit insgesamt 128 wie die
negativen. Die Extreme sind eingeschlossen von jedem einzelnen Sample für
insgesamt 256 (= 2 ^ 8) ausdrückbare Werte**.

N.B.: Es ist wichtig zu beachten, dass die Wellenform zwischen I (+) und II (-)
	Quadrant schwingt, geteilt durch die Abszisse der Dimension 0.
	Betrachten Sie NICHT -128 als 0 und +127 als 255:
	Es ist NICHT möglich, die Welle im 1. Quadranten zu verschieben um alles 
	positiv zu machen, * die Beträge würden nicht zum Soundchip zurückkehren,
	noch zu irgendeiner Tonverarbeitung für Spezialeffekte über Software *.


*** Betrachten Sie jeden Sapmple als Byte mit Zeichen (= MSB = bit 7) ***

Es ist wichtig, zu unterstreichen, das die digitale Synthese mit einer höheren
Anzahl von Bits als 8 eine überlegenere Klangqualität bei gleicher Frequenz von 
Samples bieten würde.
Beispielsweise lesen CD-Player 16-Bit-Samples (= 2 byte = 1 word), was
bedeutet, dass der Quantisierungsbereich von -32768 (= -(2^16)/2 = -2^(16-1) =
= -2^15) und 32767 (= (2^16)/2-1 = 2^(16-1)-1 = 2^15-1) variiert, für insgesamt
65536 (= 2 ^ 16) ausdrückbare Werte: *** Dies bedeutet jedoch nicht, dass der
Wert 32767 (positiver Peak) der CD einem größeren Anteil dieses Samples in
Bezug auf den Wert 127 des gleichen Samples mit 8-Bit gerendert entspricht: die
Tonausgabe wird dieselbe sein, nur dass die 16-Bit-Synchronisation bei gleichem
physikalischen Bereich viel mehr Definition bietet (im Grunde habe ich mit
8 Bits 256 Zahlen, um einen Ton zwischen zwei physikalisch konstanten positiven
und negativen Spitzen auszudrücken. Die 16 Bit werden jedoch mit einem viel
höheren Wertebereich synthetisiert (65536) und daher mit größerer Präzision,
mit geringerer Annäherung an die Abmessungen.
In gewissem Sinne können wir sagen, dass die 8 Bits des ersten Beispiels den 8
hohen Bits (15:8) der 16 Bits der Sekunde entsprechen und die 8 niedrigen Bits
entsprechen einer Art Annäherung nach einem fiktiven Komma zwischen den High-
und Low-Bytes des Samples***.

Lassen Sie uns noch einmal auf die Abtastfrequenz zurückkommen und eine
berühmte wichtige Ausgabe zitieren - so kompliziert wie im Hinblick auf
die Demonstration -, die besagt, dass « DIE FREQUENZANTWORT GLEICH DER HÄLFTE
DER FREQUENZ DER ABTASTRATE IST» (Nyquist Theorem): Im Grunde bedeutet es,
dass wenn wir 10 kHz abtasten, nur Töne mit der Frequenz kleiner oder gleich
10/2 = 5 kHz (dies erklärt das mysteriöse "DOUBLE", das geschrieben wurde knapp
über der Abtastrate, das zum Abtasten des gegebenen Tons die  Kenntnis der
Grundfrequenz benötigt wird, um originalgetreu wiedergegeben zu werden.

Es ist wichtig, die Töne mit einer geeigneten Frequenz abzutasten, um das
ALIASING nicht zu hören, was die Frequenzen über der Hälfte der Frequenz
abschneidet, so kommt es bei Samplenahme zu einem unangenehmen "gestörten"
Effekt.

** Obwohl Paula (für die Aufzeichnung, Eigenname des Amiga-Soundchips) eine
digitale 8-Bit-Präzision annimmt, ist es möglich, Töne wiederzugeben mit gleich
guter Qualität durch Abtasten bei den richtigen Frequenzen und durch Vermeiden
von Aliasing ***, auch wenn wir jedoch nicht die Qualität einer CD, die 16 Bit
bei 44,1 kHz (44100 Hz) abtastet erreichen können, um eine Antwort der Frequenz
im Bereich von ungefähr 20 Hz bis 22 kHz zu erhalten, was ungefähr dem
Frequenzbereich entspricht, der für das menschliche Ohr hörbar ist (subjektiv:
jemand könnte bis zu ca. 20 kHz erreichen)
* Ich nutze diese Gelegenheit, um zu sagen, dass Frequenzen mit weniger als
20 Hz INFRASCHALL und Frequenzen größer als 20-22 kHz ULTRASCHALL genannt
werden: beide sind für Menschen NICHT hörbar *.
Die meisten natürlichen Klänge haben jedoch keine Grundfrequenz über 15-16 kHz.
Reicht es daher aus, höchstens bei 32 kHz abzutasten um fast alle vorhandenen
Klänge originalgetreu wiederzugeben?
Nun, nein! Aus einem sehr einfachen Grund: Gleich oben wurde erklärt, dass
natürliche Klänge aus vielen Harmonischen bestehen, darunter kann ein
grundlegender identifiziert werden: es könnte auch passieren, dass die 
grundlegende Frequenz (die wir normalerweise verwenden, um die Abtastung 
zu berechnen) eigentlich die Frequenz der Nebenperiode ist und daher von
höherer Frequenz. In diesem Fall sind alle Frequenzoberwellen größer als das,
was wir als grundlegend annehmen und die Wiedergabe mit Aliasing würde
geschnitten, wodurch die Gesamtklangqualität erheblich verringert wird.
*** ES WÄRE DAHER MÖGLICH, DIE DOPPELTE FREQUENZ IN BEZUG AUF DIE HÖHERE
 HARMONISCHE FREQUENZ ZU ÄNDERN, DIE DIE NATÜRLICHEN TONDATEN HERSTELLT ***.
			      _______
			 _  _/ /_____\
			   _ __\  Oo /
			_ ______\_-_/______
			  (_/__/  :  __\_) '
			    __/   :   \__
			_  (_/____:____\_>
			   _ O/    _ _O/

Daher unterscheidet die Intensität die "Lautstärke" des Tons und es ist NICHT
konstant in Bezug auf die Frequenz: bei sehr hohen oder sehr niedrigen
Frequenzen ist es notwendig, es zu verstärken, um mit der gleichen Intensität
wahrgenommen zu werden. Die biologische Evolution (Folge der Gewohnheit) führte
offensichtlich dazu, dass mittelfrequente Geräusche, die in der Natur am
häufigsten vorkommen besser vom Ohr gehört werden.
*** Was unterscheidet die Höhe vom Klang? Rein musikalisch ist es leicht zu
sagen: Die Noten. Wie Sie sicherlich wissen, bilden die Noten eine Skala von
7 Noten pro OKTAVE, jedes davon beginnt mit der Note DO (C für die
angelsächsische Notation) und endet mit dem SI (B, für angelsächsische
Notation - LA ist A). Jede Oktave verdoppelt die Frequenz, sodass jedes DO
eine doppelte Frequenz im Vergleich zum vorherigen DO hat (beachten Sie daher,
dass der Anstieg der Frequenzen nicht gerade ist, aber EXPONENTIAL mit der
Basis 2).
Innerhalb der Oktave sind die Verhältnisse zwischen den Noten der Skala wie
folgt:

        DO      RE      MI      FA     SOL      LA      SI      |  (DO)
--------+-------+-------+-------+-------+-------+-------+-------|---+---------
        1      9/8     5/4     4/3     3/2     5/3     15/8     |   2

Falls Sie Sounds abtasten müssen, die dann als Instrumente in
Musikbearbeitungsprogrammen (wie SoundTracker, NoiseTracker oder ProTracker)
verwendet werden wäre es ausreichend, mit der doppelten Frequenz der
Grundfrequenz des Klangs abzutasten, die, wenn Sie von einem Musikinstrument
abtasten, der Frequenz der gespielten Note entspricht, zumindest der
Einfachheit halber:

Wenn wir zum Beispiel ein Klavier für die Komposition eines Stücks benötigen,
können wir LA3 (LA der dritten Oktave) bei 880 Hz (LA3 = 440 Hz) abtasten und
dem Tracker mitteilen, dass die Abtastfrequenz LA3 entspricht. Wir werden
später darüber nachdenken, die richtigen Frequenzen relativ zu den Samples
basierend auf den Noten zu berechnen, die wir mit dem Werkzeug auf die
Noten setzen.
Jetzt werden Sie sich sicherlich eine Frage stellen: Müssen wir bei 880 Hz,
abtasten um kein Aliasing zu bekommen?
Die Antwort ist nein. Wie bereits erwähnt, sollte eine doppelte Abtastung von 
der Frequenz der starken Harmonischen durchgeführt werden, um die Klangfarbe
des Klaviers originalgetreu zu reproduzieren, aber es ist sehr kompliziert,
diese Frequenz abzuleiten (um nicht zu sagen unmöglich). Was ist dann zu tun?
** Versuchen Sie es erneut durch Sampling mit verschiedenen Frequenzen
(ehrlich gesagt weit über 880 Hz) bis Sie eine Reproduktion mit optimalen Wert
des Instruments bei dieser Note erhalten und teilen Sie dem Tracker die
Frequenz zum Lesen der Note mit **.
Wie Sie sehen, ist die Sache in der Praxis daher komplizierter als in der
Theorie!

Nach diesen unvermeidlichen (und - ich hoffe - interessanten) Hinweisen zum
digitalen Audio gehe ich zur genaueren Erklärung der Soundhardware des
Original-Chips des Amiga über (Paula ist der einzige Custom Chip, der noch nie
durchlaufen wurde. Es gibt keine Verbesserungen seit der Veröffentlichung des
ersten Amiga (1985, für die Aufzeichnung)).
Die Hardware verfügt über 4 DMA-Kanäle für die 4 Stimmen des Soundchips. Diese
4 Kanäle sind völlig unabhängig und werden 2 zu 2 gruppiert pro Lautsprecher.
Es bekommen die Stimmen 1 + 4 den linken und 2 + 3 den rechten Weg in Stereo.
Alle 4 Stimmen haben auch ihre eigenen Hardwareregister:

	AUDxLCH $dff0y0 =       Speicherort der zu lesenden Daten (word hoch)
	AUDxLCL $dff0y2 =       Speicherort der zu lesenden Daten (word niedrig)
	AUDxLEN $dff0y4 =       Länge der DMA (in word)
	AUDxPER $dff0y6 =       Abtastzeitraum ablesen
	AUDxVOL $dff0y8 =       Volumen
	AUDxDAT $dff0ya =       Kanaldaten (2 Bytes = 2 Samples gleichzeitig)

N.B.:   Ersetzen Sie für jedes 'x' eine Zahl von 0 bis 3, entsprechend des
		gewünschten Kanals. Ersetzen Sie für jedes 'y' eine Hexadezimalzahl
		von $a bis $d in Bezug auf die Punkte 0 bis 3.
	
AUDxLCH-AUDxLCL: Sie bilden den Speicher-Wert, nicht den Zeiger des DMA.
		Einmal eingestellte Daten werden daher nicht inkrementiert, wie es
		geschieht für Bitplanes, Sprites oder Blitter-Kanäle, aber es ist
		ähnlich den copper-Zeigern, deren Wert automatisch wieder in die
		internen Zeiger-Register eingetragen werden.
		* Da diese beiden 16-Bit-Register benachbart sind, ist es bequem, sie 
		mit einem einzigen 68000 MOVE.L des Typs MOVE.L #miosample,AUDxLCH
		einzustellen: *.
		N.B.: Von nun an werde ich mich mit AUDxLC auf das Paar der zwei 
		Register beziehen, als eine Art 32-Bit Einzel-Register.		
		 
AUDxLEN:	Drückt die Länge des zu spielenden Samples in Words aus.
		Wenn wir beispielsweise ein 500-Byte-Sample im Speicher haben, muss
		dieses Register (eines der gewünschten 4 Kanäle) eingestellt sein mit
		einem Wert von 250.		
		Anmerkung: Wie für den Blitter, das Schreiben von 0 in dieses Register
		bedeutet das Lesen von 128 kB Samples.

AUDxPER:	Dieses Register wird verwendet, um die Lesefrequenz der DMA auf 
		etwas bizarre Weise zu spezifizieren - anscheinend -, aber das kommt 
		bequem und schnell zur Hardware zurück: Sie müssen es mit dem 
		SAMPLING PERIOD jedes einzelnen Soundsamples einstellen.
		Ein Wert, der die Zeit ausdrückt (in CLOCK-Zyklen des DMA vom
		System = 3546895 Hz (PAL), 3579545 Hz (NTSC)). Die DMA  muss warten 
		(arbeitet als Dekrementierer: -1 pro Taktzyklus) vor dem Übertragen
		eines anderen Samples.
		Hier ist eine Formel zur Berechnung des darin einzugebenden Wertes in
		das Register, die Abtastfrequenz (in der Praxis): 
		PER = CLOCK / freq. [Hz]
		Zum Beispiel, wenn wir eine harmonische LA3 abtasten müssen - zugegeben
		dass wir eine natürliche Quelle finden... - die Frequenz ist 440 Hz,
		von der Periode 1 Sekunde, also müssen wir eine Abtastfrequenz von 
		880 Hz annehmen. Also hier ist die Zeit der Abtastung, die in das
		AUDxPER-Register eingegeben werden soll, um die richtige Frequenz
		in 1 Sekunde des Samples im Speicher zu lesen:
		PER = 3546895 / 880 = 4030 (PAL)
	  N.B.: Die Audiodaten werden vom DMA in 4 color clock slots aufgeteilt
		(16 Bit = 2 Abtastwerte pro Kanal) pro horizontaler Abtastzeile.
		PAL-Scanlinien sind 312.5 (312=SHF, 313=LOF) zum Raster und es gibt 
		50 Raster pro Sekunde. Also wäre die maximale Lesefrequenz (Messwert
		bei	allen zugewiesenen verfügbaren Zyklen) 
		 = 2 Byte pro Zeile * 312.5 * 50 = 31300 Hz	circa: ** ABER DIESE
		GESCHWINDIGKEIT IST NUR THEORETISCH **, es ist unmöglich, einen
		richtigen Abtastzeitraum festzulegen, der perfekt mit den Zyklen
		übereinstimmt, die dem Audio-DMA jede Rasterzeile zugewiesen wird. Das
		Ende einer Periodenzählung von DMA könnte in der Mitte einer Scanzeile
		auftreten (oder, ganz schlecht, den Zyklus nach dem zugewiesenen Slot
		auf dem angegebenen Element), und die Hardware ist gezwungen, auf die 
		Zeile danach zu warten, um die Daten zu spielen, während wenn der
		Zeitraum der Abtastung kurz ist, könnte das nächste Zählende in der
		Zeile selbst stattfinden, wenn keine neuen Daten vorliegen.
		Grundsätzlich, die Mindestdauer muss der Hardware erlauben MINDESTENS
		eine ganze Rasterzeile zu laufen: der Ton wird nicht beendet, wenn von
		DMA gelesen, sondern wenn das Zählen intern vom Periodenwert in AUDxPER
		endet: Audio-DMA liest die Daten nur während der zugewiesenen Zyklen
		(außerdem sehr hohe Priorität - wie die von Diskettenlaufwerk-DMA -,
		Vermeiden Sie Verzerrungen und Verlangsamungen aufgrund von
		"Überfüllung" von Kanälen - siehe: "Bitplanes, die immer brechen") und
		halten sie in AUDxDAT bis zum Ende des Abtastzeitraums,
		* was jederzeit passieren kann * und der Klang generiert wird.		
		* Aus diesem Grund ist es NICHT möglich, die Mindestdauer der Abtastung
		über 123 (= 28836 Hz) zu senken: um DMA zu ermöglichen um vor dem
		Spielen mindestens eine weitere Daten zu lesen, um Zeile nach *.
		An dieser Stelle ist die Frage ein Muss: «Wie kommt es, dass 123 die
		minimale Periode ist, wenn der Taktzyklen pro Zeile (d.h. die Anzahl
		der Dekremente) 226,5 sind (226 = LOF, 227 = SHF)? ».
		Hier ist die Antwort: Zuvor wurde erwähnt, dass die DMA 16 Bit
		(= 2 Bytes) "pro shot" pro Eintrag überträgt, also 2 Samples, die auf
		jeder Zeile spielbar sind, und wenn der erste gespielt wurde, kann auch
		der nächste in derselben Rasterzeile gespielt werden, weil es noch
		nicht gelesen wurde, mit 123.
		Tatsächlich können maximal 2 Endzählungen auf der gleichen Zeile 
		auftreten und das Problem tritt nicht auf. Die theoretische Mindestdauer
		sollte daher 227 betragen (halte uns weit) / 2 = 114 (immer aufrunden),
		was mehr oder weniger zusammenfällt (die Entsprechung zwischen Periode
		und	der Abtastfrequenz ist NICHT eindeutig: Es gibt immer eine bestimmte
		Annäherung) mit der theoretischen Maximalfrequenz von ca. 31300Hz. Aber
		wie oben erwähnt wurde ist es per Hardware nicht präzise erreichbar.
		*** 123 Dies ist die minimal einstellbare Zeit = 28836 Hz ***

AUDxVOL:	In dieses Register müssen Sie das Ausgabevolumen des Tons im 
		relativen Kanal mit Werten zwischen 0 und 64 angeben.
		(Bei Eingabe von '64' nimmt dB nicht ab = Lautstärke ist maximal).
		*** HINWEIS!!! Wenn Sie probieren, versuchen Sie, alle Vorteile 
		des Wertebereiches von -128 bis 127 auch für leise Töne (Intensität)
		zu nutzen, um immer die maximale Präzision zu haben und Verringern Sie
		höchstens die Lautstärke in diesem Register ***.

AUDxDAT:	Dies ist der momentane Puffer, den die DMA verwendet bevor die Daten 
		an den D/A-Wandler (Digital/Analog) gesendet und konvertiert werden und
		die Signale durch den Amiga ausgegeben werden.
		Es enthält 2 Byte Audiodaten (die DMA überträgt 16 Bit zu einer Zeit
		aus dem RAM - deshalb muss AUDxLEN in Worten angegeben werden!), die 
		1 zu 1 an den DAC (Digital-Analog-Converter) gesendet werden.
		*** Entmutigt!!! Es ist auch möglich, diese Register mit der CPU
		einzustellen, wenn der DMA ausgeschaltet ist und lassen Sie den
		Computer arbeiten :( ***.
		         _____   
			     .__/_____\
			        \ O o /
			  /\ ____\_\_/___
			  \\\/___  :  _  \
			  O\ \  /  :  /  /
			    \\\_   :   \/
			_ __O\_/___:____\


		- BEISPIEL zum Einstellen der Register zum Abspielen eines Samples
		von 23 kB bei einer Frequenz von 21056 Hz im Speicher bei $60000
		(RAM-Chip) bei maximaler Lautstärke in Stereo, mit Stimme 2 und 3
		(dritter und vierter Kanal):

PlaySample:
	lea	$dff000,a0			; Basis custom chip in a0
	move.l	#$60000,$c0(a0)	; Zeiger AUD2LC in $60000
	move.l	#$60000,$d0(a0)	; Zeiger AUD3LC in $60000
	move.w	#11776,$c4(a0)	; AUD2LEN = 23 kB = 23*1024 = 23552 B [...]
	move.w	#11776,$d4(a0)	; ebenfalls AUD3LEN = [...] = 23552/2 = 11776 word
	move.w	#168,$c6(a0)	; AUD2PER = 3546895/21056 = 168
	move.w	#168,$d6(a0)	; setzen AUD3PER als AUD2PER
	move.w	#64,$c8(a0)		; maximale Lautstärke in AUD2VOL
	move.w	#64,$d8(a0)		; maximale Lautstärke in AUD3VOL
	move.w	#$800c,$96(a0)	; schaltet die DMA Kanäle 2 und 3 in DMACON ein

Lassen Sie uns nun erklären, was passiert, wenn die DMAs der Kanäle
eingeschaltet werden (neben der Tatsache, dass Sie die Sample hören können ...):

		1 -	Der in AUDLC enthaltene Wert wird in die Register eingetragen
			interne Erweiterungen und der DMA beginnt in die Datenregister
			2 Bytes gleichzeitig zu übertragen.
		    * Ab jetzt kann auch das AUDLC-Register geändert werden: die
		    Hardware, die gerade die Übertragung des gesamten Samples beendet
			hat, wird von vorne beginnen (ENDLOSSCHLEIFE).
		2 - Geben Sie einfach den AUDLC-Wert in die internen Register ein. Ein
		    LEVEL 4-Interrupt wird ausgelöst, der sich in den Registern befindet.
			INTENA und INTREQ sind in 4 Subinterrupts unterteilt, jedem der
			4 Audiokanäle ist einer zugeordnet:

		      +--------------+---------------------+---------+
		      | LEVEL IRQ    |  BIT INTENA/INTREQ  |  KANAL  |
		      +--------------+---------------------+---------+
		      |      4       |	 	10  		   |    3    |
		      |      4       |	  	9			   |    2    |
		      |      4       |	  	8			   |    1    |
		      |      4       |	  	7		       |    0    |
		      +--------------+---------------------+---------+
			 

		    Dank dieser Interrupts ist es beispielsweise möglich, ein neues
			Sample einzustellen, das abgespielt werden soll und sobald es
			fertig ist. Spielen Sie das aktuelle einfach durch Zeigen auf die
			Register ab Ort an eine andere Sample und Erhalten einer perfekten
			Verbindung zwischen den beiden (solange die beiden Wellenformen
			jeweils ähnlich enden und beginnen).

		3 - Am Ende der Übertragung beginnt alles bei Punkt (1).
			** Die Datensätze werden niemals geändert **.

			   .||||||.
			   \ oO  ||
			   _\_-_/||_
			  / {_{_ __ \
			  \ |____|/_/
			   /______\_)
			 ___|_|  |
			/_/______|ck!^desejn

Natürlich ist das alles interessant - sagen Sie - aber wie geht es einen 
10-minütigen Song auf dem Computer abzuspielen, ohne Dutzende Megabyte Daten
abzutasten (zu samplen)? 
Zu diesem Zweck wurden Tracker erfunden: Programme die geeignet sind zum
Schreiben von Musik, für die nur die grundlegenden Werkzeuge zum Abtasten der
verschiedenen Noten durch Variieren der Lesefrequenz von sich erforderlich
sind. Sie sind auch mit einem Editor ausgestattet, in dem Sie die Partitur in
4 Tracks (einer pro Stimme) unterteilen können, von denen jeder jederzeit jedes
Instrument spielen kann, aber immer noch einzeln (insgesamt kann dies erreicht
werden mit maximal 4 Instrumenten tatsächlich gleichzeitig). 
Es wäre sehr kompliziert, hier alle verschiedenen Möglichkeiten von Tracker zu
erklären, deshalb empfehle ich einen zu bekommen (z.B. den ProTracker): Es ist
zur Zeit der beste 4-Track-Tracker - ja, es gibt auch mehr Tracks durch
Mischen der Noten mehrerer Spuren in Echtzeit mit einer Stimme.
Unglücklicherweise, ist dieses Verfahren jedoch äußerst langsam und konnte
nicht übernommen werden um die Musik eines Demos oder Videospiels zu spielen,
da die Maschine in solchen Fällen viel mehr zu tun hat, als seine ganze Zeit
mit Spielen zu verschwenden ...).
Die "Philosophie" der Tracker ändert sich jedoch nicht: alle bieten 
- sogenannte - Musikroutinen, die asm-Quellen sind, sie nutzen oft den
Level 6 Interrupt (verbunden mit CIAB) oder Warteschleifen die mit dem 
Elektronenstrahl synchronisiert sind und die Module in Echtzeit spielen
(Song + Samples = Partitur + Instrumente), die mit dem relativen Tracker
erstellt wurden (oder kompatibel sind, d.h. die die Formularstruktur auf
die gleiche Weise speichern).
Die Anpassung dieser Routinen an Ihre Quellen ist sehr einfach: im Prinzip
- hat jeder seine eigenen Konventionen: Lesen Sie die .doc Ihres Trackers -
Starten Sie einfach eine Initialisierungs-Subroutine, die die Interrupt- und
DMA-Kanäle - einige auch CIAB-Timer festlegt. Die CIAA bleibt intakt, da es von
Exec verwendet wird, um die Prozesse / tasks zeitlich zu steuern und Führen Sie
die Wiedergaberoutine mit jedem frame aus. Sie sollten dies am Anfang durch
einen vertical blank Interrupt-Code tun - wenn Sie sich unter dem
Betriebssystem befinden, fügen Sie einen Interrupt-Server 5 mit hoher Priorität
(VBLANK, Ebene 3) hinzu, um alles während des vertikal blanks zu machen, bevor
das Holen der Bitplanes beginnt und alles verlangsamt. Bevor Sie Ihr Demo /
Spiel oder ihr Programm beenden, denken sie daran die Wiederherstellungsroutine
der Interrupts, DMAs und Timer vom Betriebssystem auszuführen.

Ein weiterer wichtiger Absatz über die Audio-Hardware des Amiga betrifft die
Modulation des von der DMA kommenden Klangs der 4 Kanäle. Was ist MODULATION?
Sie haben den Effekt sicherlich in vielen Songs gehört AUDIO FADE (die
progressive und langsame Abnahme der Lautstärke): Gut, dieser einfache Effekt
ist eine besondere Art der Modulation.
*** MODULATION besteht darin, einen oder mehrere Parameter eines Klangs 
während und nach seiner Zeit zu ändern *** Die fraglichen Parameter sind
natürlich INTENSITÄT (Amplitude) und HÖHE (Frequenz). Welchen Effekten
entspricht - auf der Ebene der Schallwahrnehmung - die Modulation? in
Amplituden- und Frequenzmodulation?
Als erstes findet, wie bereits erwähnt, eine gemeinsame Anwendung im Verblassen
normalerweise am Anfang und Ende eines Musikstücks statt. Ein bekanntes
Beispiel für Frequenzmodulation ist der Übergang auf den Saiten einer Gitarre
(oder ein Streichinstrument): Im Wesentlichen eine nuancierte Fusion von
benachbarten Noten ausgehend von einer gegebenen Frequenz bis zum Erreichen
einer anderen Frequenz beim allmählichen Übergang für alle Zwischenschritte mit
einer bestimmten Geschwindigkeit (oder sogar mit einer gewissen
Beschleunigung).
Es ist auch möglich, sowohl die Amplitude als auch die Frequenz gleichzeitig 
zu modulieren um einen seltsamen Effekt zu erzielen, der auf ein Phänomen der 
täglichen Erfahrung zurückzuführen ist: * Doppler-Effekt *.

Kurz gesagt besteht es in der Änderung (genau, Modulation) von Intensität und
Tonhöhe von einer sich bewegenden Quelle relativ zum Zuhörer: Wenn Sie auf der
Straße gehen, bemerken Sie, dass der Lärm der Maschinen, die sich nähern und
dann überholen, die Parameter in den verschiedenen Positionen des Autos
(Quelle) in Bezug auf Sie (Zuhörer) nicht gleich bleiben aber vor allem wird es
umgekehrt proportional lauter zur Entfernung zwischen Ihnen und der Quelle
wenn Sie darauf achten. Die Intensität ist nicht das einzige, die sich im Laufe
der Zeit ändert. Auch die Frequenz des Rauschens des vom Motor abgegebene Werts
ist geringer, wenn die Maschine entfernt ist.
Ich halte es nicht für angebracht, die Gleichung, die das Phänomen in
Abhängigkeit von der Geschwindigkeit der beiden Körper und der Entfernung
beschreibt anzugeben, da das Problem das Thema "Modulation am Amiga" nicht
genau berührt. Die Gleichung können Sie jedoch leicht in jedem Physik- oder
Akustikbuch finden.
Wenn ich zur Modulation des Amiga übergehe, bin ich gezwungen, Sie sofort zu 
enttäuschen, obwohl Paula einige besondere Modulationsmöglichkeiten hat. Die
Töne, die von einem Kanal sowohl in der Amplitude als auch in der Frequenz
kommen, werden nicht verwendet. Verwenden Sie diese Hardwarelösung niemals, da
sie eine schreckliche Beschränkung besitzt: 

Um die Intensität und Höhe zu modulieren, muss die DMA die Werte aus dem RAM
lesen, die währenddessen in die Register AUDxVOL und / oder AUDxPER eingegeben
werden sollen.
Ein anderer DMA liest die tatsächlichen Werte des abzuspielenden Samples und
dann verzerren. Dieser Prozess hat die Einschränkung, dass der DMA, der aus der
Tabelle der Modulationswerte liest einer der Audiokanäle sein muss, also wenn
Sie beispielsweise den von Kanal 0 gelesenen Ton sowohl in der Frequenz als
auch in der Amplitude Modulieren wollen sind wir gezwungen, die Kanäle 1 und 2
zu verwenden, um die jeweiligen Tabellen zu lesen, mit dem Ergebnis der
Verschwendung von 3 Kanälen, um einen einzelnen modulierten Klang zu erzeugen.
Alle von den Trackern verwendeten Modulationseffekte werden von der CPU
verwaltet. Hiermit werden die Lautstärke- und Periodenregister der gewünschten
Stimme "böse" eingestellt während der DMA seine Sample ahnungslos liest.

Dabei werden keine Kanäle verschwendet, auch wenn die CPU noch eine Weile mit
der Berechnung der Echtzeit-Soundeffekte beschäftigt ist. Der Amiga hat NICHT
einmal einen FM-Synthesizer (Frequenz Modulation) der in der Lage ist,
verschiedene Klangfarben/Timbre ausgehend von derselben Wellenform zu
erstellen.
Diese wenden sowohl Amplituden- als auch Frequenzmodulationen gemäß der 4
Parameter mit den Namen ADSR aus den Initialen der 4 Hauptphasen eines Klangs
an, zusammengefasst: Attack, Decay, Sustain, Release.
Der Graph dieser Modulation ist wie folgt:

							 b
						     /\
						    /  \ D     
						   /    \      S
		        		A /      \___________d
						 /       c           \
						/				      \  R
					   /					   \
  _ _ _ ______________/							\____________________ _ _ _
				    a							 e

Die erste Phase ist Attack, bei der die Lautstärke und / oder Frequenz von 'a' 
nach 'b' eingestellt werden (d.h. von 0 bis zu einem maximalen Spitzenwert).
Danach fällt der Graph für den Abschnitt Decay auf ein 'c'-Niveau und bleibt 
anschließend stabil für die Dauer des Sustain auf dem er sich befindet und
kehrt schließlich mit dem Release von 'd' nach 'e' auf 0 zurück .

** "Indem Sie "mit der Position der Punkte 'a', 'b', 'c', 'd' und 'e' und mit 
der Dauer der verschiedenen Phasen spielen ist es möglich, eine unendliche
Anzahl von Tönen zu erzeugen auch ausgehend vom Sample einer trivialen
Harmonischen **.
Leider sind diese Begriffe für die Programmierung des SoundChips des Amigas
nicht nützlich also fahren wir mit der Beschreibung der Teile fort, die in der
Geschichte des Amigas und seiner Hardware gekommen sind... :)
Bei dem fraglichen Register handelt es sich um das berüchtigte ADKCON ($dff09e),
das ebenfalls eine Lesekopie (ADKCONR) bei $dff010 besitzt:

   bit 
	7:      USE3PN  Kanal 3 verwenden, um nichts zu modulieren
	6:      USE2P3  Kanal 2 verwenden, um die Periode von Kanal 3 zu modulieren
	5:      USE1P2  Kanal 1 verwenden, um die Periode von Kanal 2 zu modulieren					
	4:      USE0P1  Kanal 0 verwenden, um die Periode von Kanal 1 zu modulieren					
	3:      USE3VN  Kanal 3 verwenden, um nichts zu modulieren
	2:      USE2V3  Kanal 2 verwenden, um das Volumen von Kanal 3 zu modulieren					
	1:      USE1V2  Kanal 1 verwenden, um das Volumen von Kanal 2 zu modulieren					
	0:      USE0V1  Kanal 0 verwenden, um das Volumen von Kanal 1 zu modulieren					

Sie werden sicherlich verstehen, wie die Sache funktioniert: Wenn Sie zum
Beispiel die Amplitude von Kanal 2 modulieren müssen, können Sie dies nur mit
Kanal 1 als Leser der Werte tun, die in das AUD2VOL-Register eingefügt werden
sollen, daher müssen Sie auf die Daten ihrer Kanäle zeigen und ihnen eine
Lesefrequenz geben.
** Modulation ist jedoch ein einfacher, aber wichtiger Effekt, der über die CPU
simuliert wird - wie bereits gesagt - um keinen der Audiokanäle von Amiga zu
besetzen... **

			   O    .... o      
			     o :¦ll¦:       
			   ___( 'øo` )___   
			 /¨¨¨(_  `____)¨¨¨\ 
			(__,  `----U-'  .__)
			( ¬\\_>FATAL< _,/¯ )
			(__)\ ¯¯":"¯¯¯ /(__)
			(,,) \__ : ___/ (,,)
			     (_\¯¯¯ /_)     
			:...(    Y    ¬) ··:
			    _\___|____/_
			   `-----`------'


Abschließend möchte ich bestätigen, dass das vorhandenes Wissen über digitale
Akustik, also wie Soundchips im Allgemeinen funktionieren, nicht so
grundlegend erforderlich ist wie das Wissen über die Grafikhardware oder ASM 
einer CPU, und die Beherrschung von diesen ist sicherlich für jeden notwendig,
auch für Audiophile.

Es ist genauso wahr, diese wahre Kultur zu diesem Thema erfordert jedoch auch
fundiertes Wissen über digitale Klangtheorie, die in letzterer Zeit so sehr
gelobt wird, wie viel ist das Objekt der Unwissenheit von den meisten Menschen,
die genau wie die "Programmierer" denken, die schnüffeln - nicht zu sagen
"springen" - vollständig die sources zu diesem Thema, weil «so viel, die
Musikroutine ruft sie einfach vom Interrupt auf ... ».

****************************************************************************
* TEIL 2: DIE ANSPRUCHSVOLLEN WIEDERHOLUNGSROUTINEN (Autor: Fabio Ciucci)  *
****************************************************************************

Apropos solche Musikroutinen, im Moment haben wir nur die Standard-Routinen
gesehen, die mit dem Protracker geliefert werden, aber es gibt auch andere 
Anspruchsvollere. Wir werden jetzt einen der besten sehen, den player6.1a,
für den ebenfalls ein Programm für die Konvertierung (die p61con, auf dieser
Diskette) erforderlich ist. Mit diesem müssen wir ein normales Modul in
ein für die Wiedergaberoutine optimiertes Modul transformieren. 

Anmerkung: Dieser Player unterliegt dem Copyright des Autors:

		Jarno Paananen / Guru of Sahara Surfers.
	
Wenn Sie also die Wiedergaberoutine in einem kommerziellen Produkt verwenden, 
z.B. in einem Spiel, müssen Sie seine schriftliche Erlaubnis erhalten und ihm
etwas (in finnischen Mark!) als Prozentsatz geben.
Er wird schon sauer auf mich sein, dass ich nicht das ganze Archiv aufgenommen
habe!!!...

Dieser Player hat viele Optionen, während wir das meiste einfach tun:
Spielen eines Moduls mit der bereitgestellten Standardroutine zusammen
mit dem Protracker-Programm.

Dies sind die Dinge die zu tun sind:

1) Konvertieren Sie das Modul mit dem utility "P61CON" in das P61-Format.
   Dieses Dienstprogramm erfordert die reqtools.library und die
   powerpacker.library im lib-Verzeichniss um zu funktionieren. In den
   Preferences berühren Sie nichts und lassen nur die Option "Tempo"
   eingestellt. Notieren Sie sich den Save the USECODE, der im Listing
   angegeben wird zum Äquivalent "use = ....". Dies dient zum Speichern von
   Code.

2) Auf diese Weise haben wir das konvertierte Modul NICHT KOMPRIMIERT.
   Trotzdem wird die Form oft bei der automatischen Optimierung 
   kleiner gemacht.

3) Gehen Sie jetzt genauso vor wie bei den vorherigen Routinen: Rufen Sie 
   zuerst P61_Init auf um zu spielen, dann P61_Music für jeden Frame und
   P61_End am Ende. Die einzige zusätzliche Anforderung ist die Aktivierung
   des Level 6 Interrupts.

Sehen wir uns ein praktisches Beispiel in Listing14-10a.s an.

Sie werden feststellen, dass es schneller als das Standardgerät ist, aber auch,
dass es den TimerA der CIAB und der Level 6 Interrupt ($78) verwendet.
Dann gibt es Gleichgestellte, deren Bedeutung bekannt sein muss:

fade  = 0	;0 = Normal, NO master volume control possible
			;1 = Use master volume (P61_Master)

Dies sollte auf 1 gesetzt werden, wenn Sie die Lautstärke regeln möchten, um
eine Überblendung (Fade) an dem Label P61_Master zu erzielen.
Wir werden noch ein Beispiel sehen. Wenn wir keinen brauchen
setzen wir die Option auf 0, um Code zu speichern. In der Tat sind diese
nichts anderes als konditionierte Assemblys, die die Direktiven 
des Assemblers "ifeq", "ifne", "endc" verwenden...

jump = 0	;0 = do NOT include position jump code (P61_SetPosition)
			;1 = Include

Auch diese Option sollte auf Null belassen werden, wenn die Sprungroutine an
einen bestimmten Ort im Modul nicht verwendet wird. Wir werden noch ein
Beispiel sehen.

system = 0	;0 = killer
			;1 = friendly

Diese Option können sie auf 0 belassen, wenn Sie "schlechten" Code verwenden
und startup2.s verwenden. Seien Sie vorsichtig, wenn Sie von dos laden!!! (Sie
müssen auch den Interrupt $78 (Level6) an Ort und Stelle lassen, ohne das 
System zurückzusetzen, falls Sie mit dieser aktiven Wiedergaberoutine laden!).

CIA = 0		;0 = CIA disabled
			;1 = CIA enabled

Diese Option muss auf 0 gehalten werden, um die Routine im "Standard" -Modus 
zu verwenden. Wenn es auf 1 gesetzt ist, muss P61_Music nicht mehr bei jedem
Frame aufgerufen werden, weil das Timing vollständig von der CIAB stattfinden
wird. Wir werden ein Beispiel sehen.

exec = 1	;0 = ExecBase destroyed (zerstört)
			;1 = ExecBase valid		(gültig)

Hier muss 1 übrig bleiben, da wir in $4.w die gültige Execbase verlassen...
Wir sind nicht nicht die Maniacs!!! Was ist mit dem Startup, das wir machen?

opt020 = 0	;0 = MC680x0 code
			;1 = MC68020+ or better

Das ist klar: Wenn Ihr Spiel / Ihr Demo nur AGA ist, können Sie dies auf 1
setzen, sonst belassen Sie es bei Null. Achten Sie darauf, sie es nicht auf 1 
zu setzen brauchen, wenn dies nicht der Fall ist!!!!!!

use = $2009559	; Usecode (Setzen Sie den von p61con angegebenen Wert zum
				; Speichern für jedes Modul unterschiedlich!)
NUR WENN DAS SPIEL / DAS DEMO ** NUR ** AUF AGA GEHT (daher 68020+).

Hier erklärt der Kommentar alles... Notieren Sie den Usecode immer auf einem
Blatt (ohne den Zettel natürlich zu verlieren) und legen Sie ihn hier ab. Es
wird nur verwendet, um die im Modul verwendeten Effektroutinen
zusammenzustellen. Es spart Platz. -1 zu setzen bedeutet, alles
zusammenzusetzen (puah!).
			      ____  
			     /    \ 
			  _ |______| _
			 /(_|/\/\/\|_)\
			(______________)
			    |  ..  |
			    | \__/ |
			    |______|
			  .--'    `--.
			  | |      | |
			  | |______| |
			  |_||||||||_|
			  (^) ____ (^)
			    |  ||  |
			   _| _||_ |_
			  /____\/____\

Mit dem Konvertierungsprogramm können Sie das Modul aber auch komprimieren.
Dadurch verlieren Sie etwas an Qualität. Ich empfehle daher nicht, zu
komprimieren... Es sei denn, Sie müssen ein 40k-Intro machen und stehen mit dem
Rücken zur Wand. Aus Platzgründen ist es immer gut, das "normal" konvertierte
Modul zu verwenden. Mit dem Programm können Sie jedoch auswählen, welche
Samples komprimiert werden sollen und welche nicht... und mit unseren Ohren
zuhören, ob Sie zu viel Qualität verlieren!!!

Folgendes müssen Sie tun, um ein komprimiertes Modul zu komprimieren und in
Resonanz zu bringen:

1) Konvertieren Sie das Modul in das komprimierte P61-Format mit "P61CON".
   In den Programmeinstellungen muss die Option "pack samples" aktiviert sein.
   Beachten Sie, dass Sie auswählen können, welche Samples komprimiert werden
   sollen und welche nicht. Hier ist, was Sie in jedem Beispiel sehen werden:

   Original	- das Original-Sample abspielen (Stoppen mit der rechten Maustaste)
   Packed	- Spielen Sie das Sample so ab, wie es komprimiert wurde. Wenn Sie
              bemerken, das sie zu viel Qualität verlieren, dann noch einmal
			  überlegen...!
   Pack		       - Markieren Sie dieses sample als "komprimieren".
   Pack rest	   - komprimieren alle anderen samples ab hier 
   Don't pack	   - das sample nicht komprimieren
   Don't pack rest - die anderen samples nicht berühren (von hier aus raus)
   Notieren Sie sich beim Speichern wie immer den USECODE und
   notieren Sie sich auch die Länge des sample puffers!!!!!!

2) Auf diese Weise haben wir das konvertierte und komprimierte Modul erhalten.

3) Jetzt gibt es zwei weitere Dinge zu tun: Erstens hat das Modul samples
   komprimiert, die in einen Puffer entpackt werden müssen. Dazu ist es
   notwendig  2 Dinge zu tun: der Puffer, solange vom Programm als "sample
   buffer Länge" angegeben und die Adresse in a2 eingeben, bevor Sie P61_Init
   aufrufen wird für die Dekompression sorgen. Für den Rest (spielen und enden)
   ist es das gleiche. Lassen Sie uns alles in der Praxis sehen:

	movem.l	d0-d7/a0-a6,-(SP)
	lea	P61_data,a0		; Adresse des Moduls in a0
	lea	$dff000,a6		; Custom base $dff000 in a6!
	sub.l	a1,a1		; Die Samples sind nicht getrennt, wir setzen Null
*******************
>>>>>	lea	samples,a2	; Modul komprimiert! Zeiger auf Zielpuffer für
*******************		; die samples (in Chip Ram)!
	bsr.w	P61_Init	; Anmerkung: Das Dekomprimieren dauert einige Sekunden!
	movem.l	(SP)+,d0-d7/a0-a6

Für das Modul und den Puffer sind hier die Änderungen:

1) Das Modul muss nicht mehr in den Chip-RAM geladen werden:

	Section	modulozzo,data	; Es muss nicht in Chip-RAM sein, weil es 
						; komprimiert ist und wird woanders ausgepackt wird!
P61_data:
	incbin	"P61.stardust"	; komprimiert, (Option PACK SAMPLES)

2) Der Puffer muss so groß wie angegeben in den CHIP-RAM geladen werden:

	section	smp,bss_c

samples:
	ds.b	132112	; Länge gemeldet von p61con


Wie Sie feststellen werden, wird neben dem Qualitätsverlust in den Samples auch
mehr Speicher verwendet, da wir mehr Puffer haben, auch wenn das Modul kürzer
ist.

Sehen wir uns ein Beispiel in an Listing14-10b.s

Nachdem wir die beiden Hauptimplementierungen gesehen haben, können wir alle 
Varianten sehen. Zunächst die CIA-Option, die mit dem Equate aktiviert wird.
Sie können 2 Beispiele sehen in Listing14-10c.s und Listing14-10d.s

				  o
				 o. ______
				 °O|.____.|
				°o.|| .. ||
				  O|`----'|
				   |______|
				 .--'    `--.
				 | |      | |
				 | |      | |
				 |_|______|_|
				 (^) ____ (^)
				   |  ||  |
				  _| _||_ |
				 /____\/___\

Lassen Sie uns abschließend die Verwendung von 2 Optionen sehen:

Das Audio-Fade: Aktivieren Sie einfach das gleichwertige "Fade" und reagieren 
Sie auf die entsprechende Label "P61_Master", das von 0 bis 64 reicht. 
Beispiel in Listing14-10e.s

Die Fähigkeit, zu beliebigen Positionen im Modul zu springen: Einfach 
das Gleiche wie "Sprung" aktivieren und die Routine "P61_SetPosition" mit der
Position im Register d0 aufrufen. Beispiel in Listing14-10f.s

Es würde auch andere Optionen geben, die wir in den Einstellungen
zusammenfassen können:

Two files:	Diese Option speichert die Sample und das Lied separat
			in 2 Dateien. Es kann nützlich sein, wenn wir mehrere Module 
			mit den gleichen sample verwenden ...

P61A sign:	das P61A-Zeichen am Anfang des Moduls setzen ... kann
			nur dazu dienen, es Angreifern (Rippern) leichter zu machen!!!
			Niemals einstellen!

No samples:	Es wird benötigt, wenn viele Module mit den gleichen samples
			gespeichert werden: Wenn Sie zum ersten Mal "two files"
			auswählen werden die Module und das erste Lied  gespeichert.
			Wenn er dann diese Option bekommt werden alle anderen Songs
			gespeichert.

Tempo:		Verwenden Sie die Option "Tempo", um den Player zu aktivieren.

Icon:		Wenn Sie ein Symbol zusammen mit dem Formular speichern möchten

Delta:		8-Bit-Komprimierung statt 4-Bit (ich habe bemerkt
			das es kaum etwas ändert... bah!)

Sample packing:	 Komprimierung von Samples mit dem 4-Bit-Delta-Algorithmus
				 einstellen (QUALITÄT GEHT VERLOREN !!!).

			 ____     ________     ____
			 \__ \__ /   __   \ __/ __/
			   \____|o o \/ o o|____/
			     \__|__________|__/
			        |     ___/__\
			       _|__   \__/  \\_
			      (_______/U     \/
			____/\_\___U_/ \_____/_/\____
			\ ___/  (_(_______)_)  \___ /
			 \_\/  /      |      \  \/_/
			   /  /       |       \  \
			  /  /________|_______/\  \
			 /  /      _____        \  \
			 \           /             /
			  \_______________________/

Viel Spaß beim Zuhören!