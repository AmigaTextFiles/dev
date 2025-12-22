
*****************************************************************************
* ASSEMBLERKURS - LEKTION 15: AGA											*
*****************************************************************************

Dies ist die mit Spannung erwartete Lektion zum neuen AGA-Chipsatz, der im
A1200 und A4000 enthalten ist.
Als der Amiga4000 Ende 1992 herauskam, hatte ich einen Freund der einen sofort
kaufte und im Grunde ging ich so oft in sein Haus, dass ich ihn mehr benutzte 
als er. In diesen ersten Monaten habe ich die copperlist des Betriebssystems 
und ganze Teile von KickStart disassembliert, weil es vom verstorbenen
Commodore keine Dokumentation zur AGA gab. Komisch aber wahr. Jedoch aufgrund
von Nachweisen, begann ich einiges zu verstehen, aber der AGA IFF-converter
fehlte auch und ich musste die Zahlen von IFF in RAW von Hand "konvertieren".
Das einzige Programm, das zu dieser Zeit fähig war AGA-screens anzuzeigen war
das neue DeLuxePaint, also habe ich ein 256-Farben-Bild geladen, dann habe ich
in Multitasking den asmone geladen und im Speicher nach der .raw-Figur und der
copperliste gesucht, um sie zu retten.
Im zweiten Schritt habe ich das RAW neu geladen, die copperliste aufgebaut und
die Daumen gedrückt. Ich war jedoch nicht der erste, der ein AGA Demo machte.
Die erste wurde von ABYSS erstellt, eine kleine Demo, die jedoch die
schicksalhaften 256 Farben zeigte. Nichts außergewöhnliches, aber sie waren
die Ersten.
Mehr oder weniger war ich jedoch am selben Punkt wie Abyss bei der Entdeckung
der AGA und ich wurde nicht entmutigt. Es war jetzt Februar 1993, ich war fast
bereit für ein Intro mit einem Logo in 640*256 in 256 Farben, das mit der
Scrollfähigkeit von 1/4 von Pixel (unter Verwendung des neuen BPLCON3)
schwankte, als das erste VERA AGA-Demo herauskam, dh PLANET GROOVE von
TEAM HOI. Ich rief sofort ihre BBS in Holland an und hinterließ eine Nachricht
für den Programmierer Rhino.
Von diesem Tag an begann eine Beziehung von (teuren) Nachrichten zwischen uns,
in denen wir uns über die neuesten Entdeckungen und Funktion der letzten
unbekannten Bits ausgetauscht haben. 
Kurz zuvor wurde ZOOL AGA veröffentlicht, das in Wirklichkeit überhaupt nichts
von AGA hatte. Der einzige anständige SHAKED-Code war also das Rhino-Demo.
Es wurde auch ein AGA-Iffconverter (der erste Veröffentlichte) programmiert,
den ich mit großer Freude verwendete.
Da es keine Dokumentation zur 1200 Hardware gab, und es folglich keine Demos
oder AGA-Spiele gab, habe ich die Informationen die ich mit Rhino entdeckt habe 
in einem AGADOC.TXT zusammengestellt, aber als ich fast bereit war, es in der
BBS zu verteilen, kam ein kleiner Text heraus, hard1200.txt, von Yragael,
einem französischen Programmierer.
Es gab einige Dinge in diesem Text, die ich nicht wusste, aber viele Dinge, die 
ich wusste, fehlten. Ich habe ein paar mal das BBS in Frankreich angerufen und
es geschafft, ihn zu finden. Ich wusste, dass er auch einen iffconverter für
AGA plant, der auch 64 Pixel breite Sprites speichert.
Dieser historische Iff-Converter befindet sich auf der Utilitty Diskette. Ich 
habe alle Informationen zusammengestellt und einen großartigen Text gemacht,
der auch vollgestopft ist mit Informationen über den 68020. Dieser Text wurde
sowohl für die BBS als auch für die Party gemacht.
Theoretisch war ich bereit, eine AGA-Demo zu machen, und tatsächlich habe ich
eine für die SMAU vom Oktober 1993 in Mailand gemacht, aber in Wirklichkeit ist
es eine Diashow "sehr technisch" statt einer Demo (ich habe es in 2 Wochen
programmiert, da ich immer Dinge in letzter Minute tue!). Es gab jedoch
256-farbige Bilder in Interlaced-Einstellungen, 24-Bit-AGA-Fade (wie im Kino!)
sowie ein Bild in HAM8 (ich glaube, es ist das erste Bild in HAM8, das in einer 
Demo angezeigt wird!!!) und ein sehr erfolgreicher 24-Bit-Cross-Fade-Effekt.
Es gibt heutzutage viele AGA-Demos und Spiele wie SUPER STARDUST oder BRIAN
THE LION die endlich die neuen Möglichkeiten nutzen.
Obwohl ich das erste italienische AGA-Demo programmiert habe, habe ich
"aufgehört" und ich habe nichts mehr getan, so sehr, dass die letzte Demo, die
ich gemacht habe, für den A500 war. Warum? Ich weiß es nicht.
Allerdings mit meinem AGADOC.TXT und einigen Ratschlägen, habe ich zur
Programmierung des zweiten italienischen AGA-Demos, IT CAN'T BE DONE,
programmiert von EXECUTOR / RAM JAM, das eine unterschiedliche Texturabbildung
aufweist beigetragen. Während Executor sich in seinem Demo für die Hilfe die
ich ihm gab gebührend bedankte, enthielten nur sehr wenige der frühen
ausländischen AGA-Demos Grüße für mich, aber ich glaube, dass viele mein
kostbares agadoc verwendet haben. Einige Zeit später begann Commodore, das
Handbuch über AGA an das Softwarehaus zu senden, also hat jemand es "gestohlen"
er transkribierte (es war COMBAT 18), folglich wurde mein Agadoc weniger
"exklusiv".
Dies war die Geschichte der Entdeckung der AGA, wo ich mich unter den ersten
10 Pionieren betrachten kann, obwohl ich mich immer noch frage, ob es sich
gelohnt hat, weil ich dann ein paar Monate danach die schöne und fertige
Dokumentation gelesen habe.
Ich schlage eine italienische Übersetzung meines ersten AGADOC vor, da ich es 
auf Englisch geschrieben habe. Zunächst ist zu beachten, dass es zum Anzeigen 
von AGA-Bildern nicht erforderlich ist 68020-Anweisungen zu verwenden.
Sie können mit allen Anweisungen der 68000 Basis ein AGA-Demo erstellen, da die
Unterschiede im COPPER liegen. Dies bedeutet, dass Sie auch mit dem TRASH'M'ONE
programmieren können, der keine 68020-Anweisungen unterstützt. Wenn Sie ihn
verwenden, ist es natürlich besser, zu TFA ASMONE 1.25 zu wechseln, das auf der 
Utility Disk ist: Unter anderem hat es die Online-Hilfe zu den AGA-Registern,
wie in der TRASH'M'ONE, nur anstatt "= C" zu verwenden, müssen Sie hier "= R"
verwenden. Zum Beispiel: Um das Register $dff106 (BPLCON3) zu sehen, geben Sie
einfach "= R 106" ein.
Wir haben bereits gesehen, wie man die AGA "deaktiviert":

	move.w	#0,$1fc(a5)			; FMODE - deaktivieren fetch 64/32 bit.
	move.w	#$c00,$106(a5)		; BPLCON3 - deaktivieren Palette 24 bit
	move.w	#$11,$10c(a5)		; BPLCON4 - Palette normal.

Nun müssen wir sehen, wie wir alles aktivieren können!
Beginnen wir mit einer Zusammenfassung der neuen Möglichkeiten, um Sie dazu zu
bringen, wie man sie benutzt: die Palette statt 12-Bit, dh 4096 Farben wurde
jetzt auf 24 Bit oder 16 Millionen Farben erhöht. Während zuvor für jede RGB-
Komponente eine Zahl von 0 bis 15 gewählt werden konnte, können Sie jetzt eine
Zahl zwischen 0 und 255 wählen. Also: 16 * 16 * 16 = 4096 Farben sind im alten
OCS- und ECS-Modus möglich, während 256 * 256 * 256 = 16777216 Farben in der
AGA zur Auswahl stehen. Zum Beispiel, bisher konnten Sie höchstens 16 Graustufen
machen, das heißt jetzt geben Sie $0000, $0111, $0222, $0333 usw. in die
Farbregister ein und sie können 256 Graustufen machen.
Die verfügbaren Bitebenen haben ebenfalls zugenommen, jetzt können es auch 
256 Farben sein. (8 Bit = 256 Möglichkeiten).
Es gibt auch einen speziellen HAM8-Modus mit 262144 "theoretischen" Farben auf
dem Bildschirm, aber einige Einschränkungen (leichte "Abstriche"), ähnlich wie
bei normalem HAM6. HAM8 steht für HAM mit 8 Bitebenen, während HAM6 das normale
HAM mit 6 Bitebenen ist.
Das neue Dual Playfield kann bis zu 4 Bitebenen pro playfield (16 Farben) haben
und 16 das andere, und die Bank von 16 Farben in der Palette von 256 Farben ist
unabhängig für jedes playfield wählbar.
Als ob das nicht genug wäre, haben sich sogar Sprites "entwickelt". Erinnern Sie
sich an die Breitenbeschränkung von 16 Pixel? Nun können die 8 Sprites jeweils
32 oder 64 Pixel breit sein, und Sie können wählen, ob sie unabhängig von der
Bildschirmauflösung in Lowres oder in HIRES sein sollen. Zum Beispiel können
8 hires Sprites mit einer Breite von 64 Pixel in einem 256-Farben-Lowres-screen
angezeigt werden. Sprite Attacched sind immer verfügbar. Gerade und ungerade
Sprites können ihre eigene unabhängige Bank von 16 Farben aus der Gesamtpalette
von 256 verwenden. Allerdings hat ein nicht attached Sprite immer maximal
3 Farben + Hintergrund und ein attached 15 Farben + Hintergrund.
Neu ist auch, dass Sprites auch in den Rändern erscheinen können, dh außerhalb
des DIWSTART-DIWSTOP-Fensters, während dies normalerweise nicht möglich war.
Um diese Möglichkeit zu aktivieren, setzen Sie einfach Bit 1 von $dff106
(BPLCON3). Als ob das nicht genug wäre, wurde die horizontale Positionierung
auf 32ns erhöht. Das heißt, anstatt 320 "Aufnahmen" zu machen, um den
Bildschirm horizontal zu bewegen, können sie jetzt kleinere Schritte ausführen,
sogar ein Viertelpixel, als wäre der Bildschirm 1280 * 256 und es wurde jeweils
1 Pixel gemacht. Dadurch können Sprites schwanken wie es keine SUPER VGA-Karte
der PC MSDOS kann.																					
Die Möglichkeit eines sehr flüssigen Scrollens in Schritten von 1/4 Pixel war
auch für Bitebenen implementiert, dies sind "zusätzliche" Bits im $dff102 im
guten alten BPLCON1. Es ist möglich, Dutzende von Levels in Parallaxe damit zu
machen, das unglaublichste Scrollen in der Geschichte der Computer. Das neue
$dff102 ermöglicht zusätzlich das "Einrasten" von Scrolls von 1/4 Pixel zur
Zeit. Jetzt kann es bis zu maximal 64 statt 16 Pixel scrollen. 
Auch wenn es uns in geringerem Maße interessiert, ist es bereits vom ECS aus
möglich, 31-kHz-Bildschirme, dh für Multisync-Monitore zu verwalten. Mit dem
AGA-Chipsatz ist das "deinterlace" Bildschirme bei 15 kHz möglich,
einschließlich Bitebenen und Sprites für SUPER VGA-Monitor.
Die Demos und Spiele sind jedoch normalerweise in PAL!
Alle diese Neuheiten stören jedoch nicht die Kompatibilität mit dem alten
Chipsatz, wenn sie nicht "aktiviert" werden wie Sie durch das Ausführen von 
OCS/ECS-Quellen aus früheren Lektionen überprüfen können.
Insbesondere müssen $dff1fc (FMODE) und Bit 0 von BPLCON0 zurückgesetzt werden.
Wir haben dieses Bit in früheren Lektionen immer zurückgesetzt. Durch Setzen
werden andere Bits in BPLCON3 ($dff106) betriebsbereit, einschließlich
BRDRSPRT, das den Sprites außerhalb der "Kanten" dient.
Zum Erkennen von Kollisionen mit Bitebenen 7 und 8, die nicht unterstützt
werden von CLXCON gibt es das CLXCON2 ($dff10e), das durch Schreiben in das
alte CLXCON zurückgesetzt werden kann. Dies ermöglicht die korrekte Meldung von
Kollisionen in OCS-Spielen.
Es ist derzeit nicht bekannt, ob Amigas in Zukunft herauskommen werden.
Sie werden die AGA oder nur das ECS unterstützen. Es wurde gesagt, dass sie
vielleicht nur das OCS / ECS in Emulation unterstützen werden und sie werden ein
anderes Grafiksystem haben.
Für die Probleme, die es gab, um den Commodore usw. zu verkaufen. Die
Verzögerung führte dazu, die Veröffentlichung dieser neuen Modelle wegzuschieben,
so wird die AGA viele Jahre dauern, und dies wird wahrscheinlich zu Unterstützung 
in allen neuen Amiga-Maschinen führen.
Es gibt jedoch auch die CD32, das AGA unterstützt.
Wenn Sie CD32-Spiele programmieren möchten, beachten Sie, dass es 2 Joystick
Ports hat, die 11 "Button" unterstützen, daher müssen Sie den Code an dieser
Stelle anpassen. Andere Unterschiede des CD32 sind 1KB Flash-RAM, wo die HIGH
SCORE oder Game Passwörter gespeichert werden können sowie den AKIKO-Chip, der
in der Lage sein sollte, Grafiken von Chunky nach Planar zu konvertieren, aber
anscheinend nicht sehr schnell.
Das Konvertieren von Chunky (Videomodus wie VGA) zu Bitplanes Amiga ist für die
Textur-Mapping-Grafiken, siehe DOOM auf dem MSDOS-PC.
Später machen wir vielleicht unser eigenes DOOM.

Zuerst müssen wir sehen, ob der Computer die AGA hat durch die Routine für die
Erkennung, die wir bereits gesehen haben:

	LEA	$DFF000,A5
	MOVE.W	$7C(A5),D0	; DeniseID (oder LisaID AGA)
	MOVEQ	#100,D7		; Überprüfen Sie 100 Mal (um sicher zu sein, gegeben
						; dass der alte Mann Denise aus zufälligen Werten)
DENLOOP:
	MOVE.W	$7C(A5),D1	; Denise ID (oder LisaID AGA)
	CMP.B	d0,d1		; Der gleiche Wert?
	BNE.S	NOTAGA		; Es ist nicht der gleiche Wert: Denise OCS!
	DBRA	D7,DENLOOP
	BTST.L	#2,d0		; BIT 2 zurücksetzen=AGA. ist AGA vorhanden?
	BNE.S	NOTAGA		; nein...
	ST.B	AGA 		; ja... wir setzen dann das Flag "AGA".
NOTAGA:					; nein AGA... oder OCS/ECS oder die zukünftige AAA...
	...

*****************************************************************************
*			DIE NEUE 24-BIT-PALETTE										    *
*****************************************************************************

Ok, jetzt wollen wir in der Praxis sehen, wie man 128 oder 256 Farben anzeigt
und wie man Schattierungen mit dem copper mit "24 Bit" macht usw.
Zunächst ist es wichtig zu verstehen, wie die neue Palette funktioniert, weil
dann geht es beim Rest nur darum, hier und da ein paar Bits zum Hinzufügen von
Bitplanes oder vergrößern von Sprites zu setzen. Wir haben gesagt, dass es für
jede der 3 ROT, GRÜN und BLAU Komponenten möglich ist einen Wert von 0 bis 255
anstelle von 0 bis 15 anzugeben. Wenn zuvor das gelb eingestellt werden musste,
mussten $F von rot, $F von grün und 0 von blau gesetzt werden, jetzt brauchen
sie $FF von rot, $ff von grün und $00 von blau. Soweit alles klar. Wenn wir
vorher in $dff180 den Wert $0ff0 für gelb ($0RGB) eingeben mussten, wo setzen
wir jetzt $00FFFF00? Das Register, das ein word ist, hat nichts mit $00ffff00
zu tun, dh $00RRGGBB. Die Designer haben einen Weg gefunden, die Kompatibilität
mit dem OCS aufrechtzuerhalten um die 256 24-Bit-Farben in die alten 32
12-Bit-Register eingeben zu lassen !!
Lassen Sie uns in der Zwischenzeit sehen, wie sie das erste Problem gelöst
haben, nämlich das eingeben einer Farbe $RRGGBB, z.B. in COLOR0 ($dff180).
Lassen Sie uns diese Überlegung machen: Wenn wir die 12-Bit-Farbe "$F32"
hätten, wie wäre das 24-Bit-Äquivalent? Natürlich $f03020. Jetzt kann man
sehen, dass die 4-Bit-Farben, die normalerweise in OCS/ECS verwendet werden,
die hohen 4-Bits sind oder mit anderen Worten, das hohe nibble der 8-Bit der
Farben bei AGA. Und das stimmt! Wenn wir die AGA-Register löschen und COLOR0
eingeben oder in einem anderen Farbregister einen Wert ändern, ändern wir die
4 hohen Bits der 3 RGB-Komponenten, wobei die 4 Bits niedrig bleiben, daher ist
die resultierende Farbe das gleiche wie die bei OCS. Sie haben es erraten, um
eine Farbe mit 24 Bits einzustellen müssen Sie die High-Bits ($RxGxBx) separat
in $dff180 einfügen. Dann "tauschen" Sie sie aus und setzen die niedrigen Bits
($xRxGxB) immer in $dff180.
Nehmen wir ein Beispiel: Wir haben also die 24-Bit-Farbe $437efa ROT = $43,
GRÜN = $7e, BLAU = $fa. So machen wir es in der copperlist:

	dc.w	$180,$47f	; setze nibble hoch
	"scambio"
	dc.w	$180,$3ea	; setze nibble niedrig


Im Moment haben wir "Austausch" gesetzt. Lassen Sie uns in der Praxis sehen,
was Sie tun müsen, um die Funktion des $dff180 vom "Nibble Empfänger niedrig"
zum "Nibble Empfänger hoch" von 24-Bit-Farbe auszutauschen. Um die hohen Bits
auszuwählen, setzen wir den Wert $c00 in den BPLCON3 ($dff106). Tatsächlich
sind in der ECS-Emulation die Farbregister immer als Empfänger von hohen Bits
der Farbe gültig. Theoretisch könnten Sie $000 in $dff106 setzen, weil das
Setzen der Bits 10 und 11 nur zum Zurücksetzen im DUAL PLAYFIELD-Modus dient
von den Dingen, die wir später sehen werden. 
Es versteht sich daher, dass, wenn "ein bestimmtes Bit" von $dff106 auf Null
gesetzt sind, empfangen die Farbregister die hohen Bits, und wenn sie gesetzt
sind, empfangen sie stattdessen die niedrigen Bits .																			
Es mag Ihnen kompliziert erscheinen, RGB-Werte auf diese Weise aufzubrechen,
aber der iffconverter speichert die Palette der Bilder bereits fertig, das
ist alles um sich zu beschweren. Sie können auch Routinen erstellen, die
copperlisten erstellen oder Farben wie diese "aufbrechen".
Das Bit in $dff106, das sich mit dem "Austauschen" der Funktion der 
Farbregister befasst ist das neunte, LOCT genannt. Für die Kompatibilität mit
OCS/ECS wird es zurückgesetzt. Um eine Farbe auf 24 Bit einzustellen, müssen
zuerst die hohen und dann die niedrigen Bits geladen werden.


Hier ist ein Farbschema %RRRRrrrrGGGGggggBBBBbbbb (binär), wobei die
Großbuchstaben die hohen Bits der Farbstufe sind, die Kleinbuchstaben sind die
niedrigen.

	BIT#    11,10, 9, 8     7, 6, 5, 4     3, 2, 1, 0
	----    -----------    -----------    -----------
	LOCT=0  R7 R6 R5 R4    G7 G6 G5 G4    B7 B6 B5 B4
	LOCT=1  r3 r2 r1 r0    g3 g2 g1 g0    b3 b2 b1 b0 

	R = RED    G = GREEN    B = BLUE


Es kann gesagt werden, dass die AGA-Farbregister zwei Gesichter haben und das
Gesicht durch Setzen oder Löschen von Bit 9 von $dff106 gedreht wird.
Bit 9 gesetzt erzeugt den Wert $200 (%00000010.00000000). Also können sie den
"Tausch" durch $106, $200 ersetzen:																


	dc.w	$106,$000	; Auswahl nibble hoch
	dc.w	$180,$47f	; Color0 - nibble hoch
	dc.w	$106,$200	; Auswahl nibble niedrig
	dc.w	$180,$3ea	; Color0 - nibble niedrig


Viele setzen auch die Bits 10 und 11, die, wie gesagt, nur für die
Dual Playfield verwendet werden, aber sie tun nicht weh:


	dc.w	$106,$c00	; Auswahl nibble hoch
	dc.w	$180,$47f	; Color0 - nibble hoch
	dc.w	$106,$e00	; Auswahl nibble niedrig
	dc.w	$180,$3ea	; Color0 - nibble niedrig


Also $c00, um die hohen Bits auszuwählen, dann $e00, um die niedrigen Bits
auszuwählen. Wenn Sie 10 Farben einstellen müssen, setzen wir das BPLCON3
natürlich nicht zwischen einer Farbe und einer anderen, sondern einfach:


	dc.w	$106,$c00	; Auswahl nibble hoch

	dc.w	$180,$47f	; hohe nibble aller Farben
	dc.w	$182,$123
	dc.w	$184,$456
	dc.w	$186,$789
	dc.w	$188,$abc
	dc.w	$18a,$def

	dc.w	$106,$e00	; Auswahl nibble niedrig

	dc.w	$180,$3ea	; niedrige nibble aller Farben
	dc.w	$182,$111
	dc.w	$184,$444
	dc.w	$186,$888
	dc.w	$188,$434
	dc.w	$18a,$abc


Jetzt ist es Zeit zu testen, ob dies alles funktioniert. Versuchen wir es
einen "Balken" wie in Lektion 3 zu machen, aber mit AGA: siehe Listing15a.s

Sie werden feststellen, dass das Schreiben der copperliste in AGA lange dauert.
Für bestimmte Nuancen oder sich wiederholende Dinge, sollten sie zuerst eine
Routine erstellen.
Siehe insbesondere Listing15b.s, um einige Nuancen zu machen.

*****************************************************************************
*		     DIE NEUEN 128 UND 256 FARBMODI			    *
*****************************************************************************

Lassen Sie uns stattdessen sehen, wie es möglich ist, 256 Farben zu "laden", 
wenn die Farberegister nur 32 sind.
Tatsächlich wissen wir, dass jedes Farbregister zwei Gesichter hat, die ein
nibble niedrig und das andere nibble hoch sehen, aber wir wissen nur, wie man
höchstens ein Bild mit 32 Farben macht, auch wenn diese Farben aus einer
24-Bit-Palette ausgewählt wurden.
Nun, es gibt noch einen anderen Trick, auch im $dff106.
Die Farbregister sollten 256 sein und es gibt 32 oder ein Achtel von denen
die wir brauchen. Durch Zurücksetzen von $dff106 greifen Sie auf die ersten
32 Farben zu. Es versteht sich, dass es ein Bit geben muss, das, wenn es
gesetzt ist, auf die Register mit den Farben von 33 bis 64, immer in
$dff180-$dff1be geschrieben, zugreift. Tatsächlich gibt es 8 Banken mit
jeweils 32 Farbregistern, und Sie müssen sich entscheiden (mit den Bits
13, 14 und 15 von $dff106) auf welche der 8 Banken auf die Farbregister
schreibend zugegriffen werden kann:

------- bit --- $dff106 (BPLCON3) ------------------------------------

	15	BANK2 	| Mit diesen 3 Bits wird eine der 8 Bänke von Registern
	14	BANK1 	| ausgewählt, um auf die 256 AGA-Farben zuzugreifen
	13	BANK0 	|
----------------------------------------------------------------------

Die Auswahl "Bank" funktioniert ähnlich wie die Auswahl der Bitebene in BPLCON0
($dff100). Diese 3 Bits werden tatsächlich "zusammen" gelesen und abhängig von 
der darin enthaltenen Nummer wird die entsprechende Bank ausgewählt:

Wert der 3 Bits - entsprechende Farbbank - Wert von $dff106

	000		COLOR  00 - COLOR  31		$c00  / $e00
	001		COLOR  32 - COLOR  63		$2c00 / $2e00
	010		COLOR  64 - COLOR  95		$4c00 / $4e00
	011		COLOR  96 - COLOR 127		$6c00 / $6e00
	100		COLOR 128 - COLOR 159		$8c00 / $8e00
	101		COLOR 160 - COLOR 191		$ac00 / $ae00
	110		COLOR 192 - COLOR 223		$cc00 / $ce00
	111		COLOR 224 - COLOR 255		$ec00 / $ee00


In dieser Tabelle wird erläutert, wie Sie die alten Farbregister von $180 bis
$1be wiederverwenden um auf die 256 Farben zuzugreifen. Rechts sind die Werte,
die die Bits 13,14,15 von $dff106 (BPLCON3) annehmen müssen, um auf die
verschiedenen Banken zuzugreifen.

Nehmen wir ein Beispiel: Wenn Sie die Farbe 33 ändern möchten, müssen Sie dies
tun:


	DC.W	$106,$2C00	; AUSWAHL PALETTE 1 (32-63), NIBBLE HOCH
	dc.w	$182,$47f	; Color1/(33) - nibble HOCH
	DC.W	$106,$2E00	; AUSWAHL PALETTE 1 (32-63), NIBBLE NIEDRIG
	dc.w	$182,$3ea	; Color1/(33) - nibble NIEDRIG


Tatsächlich müssen Sie die Bank auswählen, die von Farbe 32 bis 63 geht, und
folglich bedeutet das Schreiben in $dff180 das Schreiben in Farbe 32, das
Schreiben in $dff182 bedeutet, in Farbe 33 zu schreiben und so weiter.
$dff1be, was normalerweise Farbe 31 wäre, wäre aber in diesem Fall Farbe 63
oder 31 + 32. Wenn wir die Bank gewählt hätten, die von Farbe 64 bis 95 reicht,
wäre das $dff182 die Farbe 65 usw.

Hier ist die Liste der Werte für $dff106, fertig für die copperlist. Es ist
nützlich für "Ausschneiden und Einfügen"-Operationen mit Amiga+b+c+i:


	DC.W	$106,$c00	; AUSWAHL PALETTE 0 (0-31), NIBBLE HOCH
	DC.W	$106,$e00	; AUSWAHL PALETTE 0 (0-31), NIBBLE NIEDRIG
	DC.W	$106,$2C00	; AUSWAHL PALETTE 1 (32-63), NIBBLE HOCH
	DC.W	$106,$2E00	; AUSWAHL PALETTE 1 (32-63), NIBBLE NIEDRIG
	DC.W	$106,$4C00	; AUSWAHL PALETTE 2 (64-95), NIBBLE HOCH
	DC.W	$106,$4E00	; AUSWAHL PALETTE 2 (64-95), NIBBLE NIEDRIG
	DC.W	$106,$6C00	; AUSWAHL PALETTE 3 (96-127), NIBBLE HOCH
	DC.W	$106,$6E00	; AUSWAHL PALETTE 3 (96-127), NIBBLE NIEDRIG
	DC.W	$106,$8C00	; AUSWAHL PALETTE 4 (128-159), NIBBLE HOCH
	DC.W	$106,$8E00	; AUSWAHL PALETTE 4 (128-159), NIBBLE NIEDRIG
	DC.W	$106,$AC00	; AUSWAHL PALETTE 5 (160-191), NIBBLE HOCH
	DC.W	$106,$AE00	; AUSWAHL PALETTE 5 (160-191), NIBBLE NIEDRIG
	DC.W	$106,$CC00	; AUSWAHL PALETTE 6 (192-223), NIBBLE HOCH
	DC.W	$106,$CE00	; AUSWAHL PALETTE 6 (192-223), NIBBLE NIEDRIG
	DC.W	$106,$EC00	; AUSWAHL PALETTE 7 (224-255), NIBBLE HOCH
	DC.W	$106,$EE00	; AUSWAHL PALETTE 7 (224-255), NIBBLE NIEDRIG


Alles scheint perfekt zu sein. Aber ein Detail fehlt noch! Wie wählen wir
8 Bitebenen in der BPLCON0 aus? Es ist nur Platz für 7 Bitebenen. Tatsächlich
sind die Bits 12,13 und 14 verfügbar, die von %000 für 0 Bitebenen bis %111
für 7 Bitebenen, dh 128 Farben reichen können. Es sollte möglich sein ein
extra hohes Bit einzustellen, um %1000 oder 8 zu erhalten.
Kein Problem, dieses Aufgabe wurde dem vierten Bit von $dff100 zugewiesen.
Um 8 Bitebenen zu setzen, ist es daher notwendig, die Bits 12, 13, 14
zurückzusetzen und Bit 4 zu setzen und das war's. Beispielsweise:

				 ;5432109876543210
	dc.w	$100,%0000001000010001	; 8 bitplanes lowres (320*256)
	dc.w	$100,%1000001000010001	; 8 bitplanes hires (640*256)
	dc.w	$100,%0111001000000001	; 7 bitplanes lowres (320*256)

Beachten Sie, dass wir für Genlock immer Bit 9 gesetzt lassen und das Bit 0,
ECSENA setzen, das spezielle Bits aktiviert, die wir später sehen werden.
Beachten Sie, dass Sie auch 6 Bitebenen haben können, die nicht extra half
bright, das sind 64 Farben, von denen Sie die Palette normal auswählen können,
wählen Sie einfach 6 Bitebenen und setze Bit 9 (KillEHB) von BPLCON2 ($dff104).
Wenn dieses Bit nicht eingestellt ist wird der alte EHB emuliert, mit 32 Farben
+ 32 "abgedunkelt". 

Um zu überprüfen, was wir gesagt haben, machen wir uns bereit, ein 
256-Farben-Bild zu visualisieren, in Listing15c.s

Das Bild gehört mir. Ich gebe zu, ich war vom Stil von Spielen wie AGONY und 
SHADOW OF THE BEAST inspiriert. Es ist künstlerisch nichts Innovatives, aber
es scheint mir gut zu passen, richtig? Es dient jedoch dem Zweck des Listings
gut.														

Sie haben vielleicht bemerkt, dass es vor der copperliste und dem Bild gibt:

	CNOP	0,8	; ausrichten auf 64 bit

Beim Zurücksetzen von FMODE ($dff1fc) wird es nicht "benötigt". Sie werden
später sehen, warum.

Wie wir für die Nicht-AGA-Bilder gesehen haben, können Sie die Palette unten 				
ins Bild "einkleben", um mit einer Routine in die copperliste aufgenommen zu
werden. Diese Routine ist etwas komplexer, aber nicht zu viel: Listing15c2.s

Jetzt, da wir diese Routine haben, wird es für Sie einfacher sein,
herauszufinden, wie Sie ein Überblenden mit 24 Bit bekommen, durch ändern der
in Lektion 8 gezeigten Überblendroutine. Siehe in Listing15c3.s

Versuchen wir nun, es in Listing15c4.s zu "optimieren"

Schließlich machen wir es zu 100% in "Echtzeit": Listing15c5.s

Jetzt können Sie versuchen, Ihr Bild in 320 * 256 in 128 oder 256 Farben
umzuwandeln. Verwenden Sie nach Belieben PicCon, iffConv oder AgaConv auf der
Utility-Diskette. Ich empfehle Ihnen dringend, die PicCon-Anweisungen auf der
Diskette zu lesen.

*****************************************************************************
*				FMODE					    *
*****************************************************************************

Konnten Sie Ihre AGA-Figur visualisieren? Nun, wenn Sie es trotzdem versucht
haben, ein Bild in 640 * 256 hires Einstellungen anzuzeigen und obwohl Sie das
RAW und die richtige PALETTE einfügen und das Bit 15 des BPLCON0 setzen, Sie
würden nichts als einen schwarzen Bildschirm bekommen ...
Dies liegt daran, dass wir $dff1fc (FMODE) auf Null gesetzt haben. Dieses
Register steuert den BURST, dh die Art und Weise, wie Daten aus dem Speicher
zum "Video" übertragen werden. Normalerweise ist die Übertragung 16 Bit, aber
um die Grafiken mehr "Push" anzuzeigen müssen Sie die Übertragung auf 32- oder
64-Bit einstellen. Wenn die Übertragung 16-Bit ist, muss das was übertragen
werden muss an einer geraden Adresse sein, dh auf WORD ausgerichtet sein
(16 Bit). Tatsächlich dürfen Bitplanes nicht auf eine ungerade Adresse zeigen!
Wenn der Burst ein 32-Bit-Block ist, müssen sich die Daten an einer Adresse 
ausgerichtet auf 32 Bit befinden, das heißt auf Longword! Zum Beispiel eine
Adresse wie $16dfc ist ein Vielfaches von 4 (4 * 23423) und als solches ein
Vielfaches von 4 Bytes von 8 Bits von 4 * 8 = 32 Bit. Kurz gesagt, es handelt
sich um eine 32-Bit-Adresse. Um Daten an 32-Bit-Adressen auszurichten, gibt
es die Direktive "CNOP 0,4". Während "EVEN", dh "CNOP 0,2", an 2 Bytes, dh
16 Bit, ausgerichtet ist, richtet sich "CNOP 0,4" nach 4 Bytes, dh 32 Bit aus.
Wenn der Burst 64-Bit ist, müssen Sie "CNOP 0,8" vor die copperliste setzen
um eine 64-Bit-Ausrichtung für Sprites und Bitplanes sicherzustellen.
Wenn der Assembler nicht ausgerichtet ist würde die Figur "geschnitten"
erscheinen, dh in vertikalen Streifen, da die Blöcke 32 oder 64 Bit sind
und nicht dem Anfang der Figur entsprechen.
Um zu überprüfen, ob ein Label 64-Bit ausgerichtet ist, assemblieren Sie und
überprüfen Sie an welcher Adresse sich das Label befindet mit dem Befehl "M",
dann teilen Sie die Adresse durch 8 und multiplizieren das Ergebnis erneut
mit 8. Wenn die ursprüngliche Adresse zurückgegeben wird, bedeutet dies, dass
es ein Vielfaches von 8 ist und alles ist OK, wenn es anders ist, bedeutet es,
dass es einen Rest gibt und es kein Vielfaches von 8 ist.
Setzen Sie dann "dc.w 0" über die Adresse und versuchen Sie, es "von Hand"
auszurichten. Natürlich wäre es gut, den Burst (Bandbreite) immer maximal
eingeschaltet zu halten, dh 64-Bit. Dies kann durch Setzen des Werts 3 in
$dff1fc erfolgen. Sie müssen jedoch darauf achten, dass, wenn Sie die Bitplanes
erweitern möchten, das sie in "Blöcken" von jeweils 8 Bytes vergrößert werden
müssen. Zum Beispiel haben wir gesehen, wie es in einigen Fällen bequem ist,
ein Stück Bitplane draußen "zur Seite" aus dem Videofenster zu haben, zum
Beispiel für Scrolls und Textscrolls mit dem Blitter. In diesem Fall konnten
wir nicht nur 2 Bytes hinzufügen, sondern 8. Eine andere Tatsache ist, dass Sie
NIEMALS das Allocmem verwenden dürfen, um Platz im Speicher für Bitebenen zu
finden, weil es 16-Bit-ausgerichtete Adressen sind, die zufällig auch auf
64 Bit ausgerichtet werden sein können.
Bereits in den ersten Listings der Lektion, auch wenn es nicht notwendig war,
wurde die Ausrichtungsregel befolgt:

      CNOP  0,8		; an 64-Bit-Adresse ausrichten
sprite:
	incbin "agasprite1"

      CNOP  0,8		; an 64-Bit-Adresse ausrichten
pic:
	incbin "AGAbitplanes"

Schauen wir uns die ersten beiden Bits des FMODE-Registers $dff1fc genauer an:

	bit 1	BPAGEM	| Bitplane Modus Seiten (Doppel CAS)
	bit 0	BLP32	| Bitplane Breite 32 bit

Wir sagten, wenn beide Bits gelöscht werden, ist der Burst "Emulation"
OCS / ECS ", dh die Übertragung beträgt 16 Bit.
Und wenn beide gesetzt sind, ist der Modus 64bit.
Sehen wir uns die 4 Fälle an, in denen die ersten 2 Bits gefunden werden können:


[x1]	%00	- Bitplane-Datenübertragung von jeweils 2 Bytes (16 Bit)
		  Speicherzyklen: CAS normal
		  Busbreite 16 Bit
		  Erforderlich: 16-Bit-ausgerichtete Bitplanes

[x2]	%01	- Bitplane-Datenübertragung von jeweils 4 Bytes (32 Bit)
		  Speicherzyklen: CAS normal
		  Busbreite 32 bit
		  Erforderlich: 32-Bit-ausgerichtete Bitplanes (Double)
		  Modulo = Modulo -4

[x2]	%10	- Bitplane-Datenübertragung von jeweils 4 Bytes (32 Bit)
		  Speicherzyklen: CAS double
		  Busbreite 16 Bit
		  Erforderlich: 32-Bit-ausgerichtete Bitplanes (Double)
		  Modulo = Modulo -4

[x4]	%11	- Bitplane-Datenübertragung von jeweils 8 Bytes (64 Bit)
		  Speicherzyklen: CAS double
		  Busbreite 32 Bit
		  Erforderlich: 64-Bit-ausgerichtete Bitplanes (Quadruple)
		  Modulo = Modulo -8


Ich würde sagen, es ist vollkommen in Ordnung, immer %11 zu verwenden, was $3
entspricht. Das einzige Problem, das auftauchen kann ist ein Gewirr der DMA,
wenn schließlich der Blitter und der Prozessor (nicht mit FAST RAM
ausgestattet) über den 64-Bit-Fluss des hypergalaktischen Transfers von
AGA-Chips auslösen sollte. Im Falle dieser Turbulenzen, können Sie sich für
%01 oder %10 entscheiden, wenn Sie Verbesserungen sehen.
Lassen Sie uns nun die minimale Bandbreite sehen, die für die verschiedenen
AGA Grafikauflösungen erforderlich ist (obwohl wir immer versuchen werden, es
auf 64bit zu bringen!).

Wie bereits gesehen, reichen 16 Bit ($1fc,0) für 320 * 256 Lowres bei
8 Bitebenen aus:

LORES (320x256), 	für 64, 128, 256 Farben oder HAM8 reichen 16 Bit aus

HIRES (640x245), 	für 32, 64, 128, 256 Farben oder HAM8 sind 32 Bit
				    erforderlich

SUPERHIRES (1280x200)	für 2, 4 Farben reichen 16 Bit aus
						für 8, 16 Farben werden 32 Bit benötigt
						für 32, 64, 128, 256, HAM8 benötigen Sie 64 Bit

In der Zwischenzeit könnten wir damit beginnen, den BURST im Display für unser				
ruhiges Bild in Lowres auf Maximum zu setzen. Auch wenn nichts sichtbar
passieren wird, wird die Übertragung mehr GALAKTISCH sein. Es ist jedoch eine
SEHR WICHTIGE Klarstellung erforderlich: Das Ändern des FETCH beinhaltet auch
eine MODULO-Korrektur aufgrund von Hardware-Umständen. Wenn daher der FMODE
gelöscht wird und die Übertragung mit 16 Bit erfolgt, muss das Modulo 0 sein,
sonst ist es sowieso normal. Wenn der BURST andererseits 32-Bit ist, ist das
Modulo gleich -4. Wenn es Null war, müssen Sie -4 in BPL1MOD / BPL2MOD
eingeben, um dies zu kompensieren. Wenn der BURST 64-Bit ist, ist das Modulo
das gleiche wie das normale Modulo -8:


BANDWIDTH 1: dc.w $1FC,0		; dann müssen die Bitplanes 
						; mindestens zu word (16 Bit) ausgerichtet werden 
						; und das Modulo ist normal.

BANDWIDTH 2: dc.w $1FC,1 oder 2	; dann müssen die Bitplanes 
						; mindestens zu long (32 Bit) ausgerichtet werden 
						; und das Modulo ist normal -4.

BANDWIDTH 4: dc.w $1FC,3		; dann müssen die Bitplanes 
						; mindestens zu quadword (64 Bit) ausgerichtet werden 
						; und das Modulo ist normal -8.

Um alles zu überprüfen, laden Sie Listing15c.s neu und versuchen Sie den FMODE 
in der copperliste zu bearbeiten, indem Sie den Wert 1 oder 2 setzen und den
32-Bit-Burst aktivieren. Sie werden feststellen, dass wenn Sie keine weiteren
Änderungen vornehmen die Abbildung mit dem Modulo falsch angezeigt wird. 

Ändern Sie dann auch das Modulo und setzen Sie es auf -4, und Sie werden sehen,
dass das Bild sich "aufrichtet". Versuchen Sie in ähnlicher Weise, den Burst
auf 64-Bit zu setzen und den Wert $3 auf die "dc.w $fc" (FMODE) in der
copperliste zu setzen. Jetzt müssen Sie das Modulo, sowohl in $108 als auch
$10a, auf -8 setzen, um das Bild zu sehen.

Nachdem wir diese Tatsache geklärt haben, halten Sie den FMODE immer bei $3,
dh Setzen Sie immer die ersten 2 Bits, und Sie können auch 256-Farben-hires
anzeigen.

Es gibt ein letztes Detail bezüglich der Auswirkungen des 32- oder
64-Bit-Bursts. Die Werte von DDFSTRT und DDFSTOP werden ebenfalls geändert.
Mit einem normalen 16-Bit-Burst zum Öffnen eines Screens in hires zum Starten
der horizontalen Position MIOX wurde es mit der "Formel" bestimmt:

	DDFSTRT=(MIOX-9)/2

Beim 32-Bit-Burst müssen Sie jedoch Folgendes tun:

	DDFSTRT=(MIOX-17)/2

Weil ein longword anstelle eines words gelesen wird. Wenn Sie jedoch
Bildschirme mit Standardbreite verwenden, gibt es kein Problem, und wenn doch
können Sie versuchen so zu gehen!
In der Praxis jedoch mit aktivem Burst, wenn Sie ein Bild in hires anzeigen
ist es nicht erforderlich, DDFSTART und DDFSTOP auf $003c und $00d4
einzustellen, sondern gleichzeitig auf dem Lowres Weg:

	dc.w	$92,$0038	; DdfStart lowres, geeignet für HIRES mit burst
	dc.w	$94,$00d0	; DdfStop lowres, wie oben

Dies ist auf die Speicherzyklen zurückzuführen, die für eine "Turbo"-
Übertragung von ChipRam zu Chip Lisa erforderlich sind.

Sehen wir uns ein Bild in 256-Farben-hires in Listing15d.s an
Die fragliche Figur ist das Werk von Cristiano Evangelisti, genannt "KREEX",
ein "Indie", der die Grafik für ein adventure-Spiel macht das einer meiner
Schüler plant.

*****************************************************************************
*				HAM8					    *
*****************************************************************************

Der gute alte HAM mit 6 Bitebenen wurde "erweitert" zum neuen HAM8 mit
8 Bitebenen. Für die Farben werden 6 Bitebenen und für die Steuerung 2 Bits
verwendet. Es ist auch in allen Auflösungen verfügbar, nicht nur in LowRes.
Um es zu aktivieren, setzen Sie einfach 8 Bitebenen und das HAM-Bit in BPLCON0
($100). Von den 8 Bits werden die hohen 6 Bits als 64 24-Bit-Grundfarbregister
verwendet, oder	als 6-Bit-MODIFY-Wert plus die 2 Low-Bits für den Hold-Modus
oder auf 18 bit ändern. Auf diese Weise können Sie mehr als 256.000 Farben
anzeigen. Die 2 Steuerebenen und die 6 Farbebenen werden "intern" in die
8 Bit des HAM8 zusammengeführt, aber in umgekehrter Reihenfolge: erste 
Stockwerke 3,4,5,6,7,8, dann 1 und 2.
Dies ist auf den Austausch von Bitplanes zurückzuführen, den wir sehen werden.

Hier ist ein Vergleich zwischen dem alten HAM6 und dem neuen HAM8.

Funktion der control bitplanes 5 und 6 in HAM6:

	+-----+-----+--------+--------+------------------+
	| BP6 | BP5 |   RED  |  GREEN | BLUE		 |
	+-----+-----+--------+--------+------------------+
	| 0   | 0   | Auswahl neues Basisreg. (1 von 16) |
	+-----+-----+--------+--------+------------------+
	| 0   | 1   |  hold  |  hold  | modify		 |
	+-----+-----+--------+--------+------------------+
	| 1   | 0   | modify |  hold  |  hold		 |
	+-----+-----+--------+--------+------------------+
	| 1   | 1   |  hold  | modify |  hold		 |
	+-----+-----+--------+--------+------------------+

In HAM8 sind die Steuerbitebenen 1 und 2:

	+-----+-----+--------+--------+------------------+
	| BP2 | BP1 |   RED  |  GREEN | BLUE		 |
	+-----+-----+--------+--------+------------------+
	| 0   | 0   | Auswahl neues Basisreg. (1 von 64) |
	+-----+-----+--------+--------+------------------+
	| 0   | 1   |  hold  |  hold  | modify		 |
	+-----+-----+--------+--------+------------------+
	| 1   | 0   | modify |  hold  |  hold		 |
	+-----+-----+--------+--------+------------------+
	| 1   | 1   |  hold  | modify |  hold		 |
	+-----+-----+--------+--------+------------------+

Diese 2 LOW-Bits sind der Befehl: neues Basisregister oder ändern eines der
ROT, GRÜN, BLAU-Komponenten. Achten Sie auf die niedrigen 2 Farbbits die nicht
geändert werden können, daher muss die ursprüngliche Palette gut ausgewählt
werden. (Dies liegt jedoch bei Grafikdesignern und Programmen wie AdPro oder
ImageFX).

Lassen Sie uns nun in der Praxis sehen, wie eine HAM8-Figur visualisiert wird.
Zuallererst besteht die Palette aus 64 Farben, nicht aus 256: Tatsächlich
reichen nur diese "wenigen" Farben aus um HAM zu erzeugen, dank der Steuerbits,
die die RGB-Komponenten "halten" oder "modifizieren". Um es zu aktivieren,
setzen Sie einfach in BPLCON0 8 Bitebenen und den HAM-Modus, dh Bit 4 und
Bit 11 setzen.
Aber es gibt noch eine letzte "Besonderheit". Wir haben bereits gesagt, dass
die Bitebenen 1-2 mit den Bitebenen 3-4-5-6-7-8 intern "getauscht" werden. Nun,
im Moment des "Zeigens" auf die Bitplanes gibt es dieses Problem.
Wenn Sie die RAW mit der PicCon speichern, können Sie gewöhnlich auf die Figur
zeigen, als wenn Sie eine 256-Farben-Figur gemacht haben. Dies liegt daran, dass
PicCon die Ordnung in RAW schon "zurück" gibt.
Wenn Sie stattdessen das Raw mit AgaConv oder mit anderen iff-Konvertern
speichern, wird das Raw "wie es ist" gespeichert, so dass Sie auf die ersten
6 Bitebenen zeigen müssen als wären es die Bitebenen 3,4,5,6,7,8 und
schließlich auf die Ebene 1 und 2 zeigen.

; Dies ist die Reihenfolge der Bitebenen, wenn Sie die RAW mit AgaConv oder mit 
; einem weiteren iff-Konverter speichern, der die planes nicht selbst "umdreht".

BPLPOINTERS:
	dc.w $e8,0,$ea,0	; dritte    bitplane
	dc.w $ec,0,$ee,0	; vierte	   "
	dc.w $f0,0,$f2,0	; fünfte	   "
	dc.w $f4,0,$f6,0	; sechste	   "
	dc.w $f8,0,$fA,0	; siebte	   "
	dc.w $fC,0,$fE,0	; achte		   "
	dc.w $e0,0,$e2,0	; erste 	   "
	dc.w $e4,0,$e6,0	; zweite	   "

Im Beispiellisting wird die RAW mit PicCon gespeichert, also sind die planes
normal ausgerichtet. Laden Sie Listing15e.s

Jetzt können wir einen Vergleich zwischen dem HAM8 und den normalen 256 Farben
anstellen. Sehen und beurteilen Sie in Listing15e2.s

Beachten Sie, dass das Ändern der gesamten AGA-Palette eine anspruchsvolle
Operation mit ungefähr zehn Rasterzeilen ist! In diesem Beispiel ändern wir
"nur" 64 Farben, es reichen also 2 oder 3 Zeilen aus, aber wenn wir zum
Beispiel ein adventure game spielen wollten mit einem 256-Farben-Bild oben auf
dem Bildschirm und einem Bedienfeld im unteren Teil, wenn Sie die Palette
ändern sollten wir 10 "schwarze" Pixel belassen und darauf warten, dass sich
die Palette vollständig ändert, es ist daher notwendig, die Zeit der
"Palletenänderung" zu berücksichtigen.
Denken Sie daran, dass jede Bewegung des coppers 8 Pixel lowres und ungefähr
52 Pixel zum Bewegen einer Zeile verwendet?...

**************************************************************************
*				SPRITE					 *
**************************************************************************

Es gibt viele Neuigkeiten in Bezug auf Sprites.
Zuerst können Sie die Breite bestimmen und zwischen 16, 32 oder 64 Pixel
wählen. Wie Sie wissen, betrug die maximale Breite normalerweise 16 Pixel!
Darüber hinaus kann das Sprite in Lowres, Hires oder Superhires angezeigt
werden unabhängig von der Auflösung des Bildes im Hintergrund. Mal sehen,
wie diese Dinge in der Praxis gemacht werden.

Die Auflösung des Sprites wird mit den Bits 6 und 7 des BPLCON3-Registers
($dff106) festgelegt und die Breite der Sprites spielt keine Rolle:

  bit 7   bit 6

	0	0	LOW RES, Emulation OCS/ECS (140ns)
	0	1	LOW RES, (140ns) (nicht der ECS standard Modus!)
	1	0	HIRES (70ns)
	1	1	SUPER HIRES (35ns)

Diese beiden Bits werden zur Abwechslung SPRES0 und SPRES1 genannt. Lassen
Sie uns gleich ein Beispiel für ein Sprite mit der Einstellung sehen, bei dem
nur das Bit	7 von $dff106 gesetzt wurde, in Listing15f.s

			SPRITES BREITE 32 oder 64 PIXEL

Jetzt müssen wir sehen, wie es möglich ist, Sprites mit einer Breite von 32
oder 64 Pixel zu erstellen. Zuerst benötigen Sie einen iff-Konverter, der
Sprites von diesem Typ speichert! Der PicCon oder AgaConv speichern sie
angemessen, es gibt keine Probleme. Wie üblich gibt es ein paar Bits, die die
Breite bestimmen.
Dies sind die Bits 3 und 2 des FMODE-Registers ($dff1fc), die als SPAGEM und
SPR32 bezeichnet werden. Die SPAGEM- und SPR32-Bits bestimmen die Breite des
Sprites und folglich, wenn die Daten, an die SPRxDATA übergeben werden sollen,
müssen es 16,32 oder 64 Bit betragen, ähnlich wie es für die Bitebenen
gemacht wird. Es ist auch analog, dass 32-Bit-Sprites mit einem "cnop 0,4" und
64-Bit mit einem "cnop 0,8" ausgerichtet werden müssen. Dies liegt an der
bekannten Tatsache, dass 16-Bit-Übertragungen eine Bandbreite * 1 haben,
während 32-Bit eine Bandbreite * 2 erfordern, entsprechend benötigt diejenige
mit 64 eine Bandbreite * 4.
Bei Sprites variieren jedoch die Kontrollwörter, die sich "erweitern" zusammen 
mit dem Rest des Sprites in Fällen von 32 oder 64 Bit.

Aber sehen wir uns eine Tabelle der Werte der SPAGEM- und SPR32-Bits des FMODE
an:

bit 3 | bit 2 | Breite	    | Steuer-Word
------+-------+-------------+----------------------------------
  0   |   0   | 16 pixel    | 2 word (normal) - erfordert cnop 0,2
  1   |   0   | 32 pixel    | 2 longword - erfordert cnop 0,4
  0   |   1   | 32 pixel    | 2 longword - erfordert cnop 0,4
  1   |   1   | 64 pixel    | 4 longword - erfordert cnop 0,8
---------------------------------------------------------------

Die "vergrößerten" Sprites sind nicht verfügbar, wenn der DMA sie nicht zu
Gesicht bekommt, vor allem in 256-Farben-Interlaced-Overscan-Superhires.

Nachdem Sie mit dem iffconverter ein 32 oder 64 Pixel breites Sprite
gespeichert haben und nachdem wir die Adresse auf ein Vielfaches von 4 oder 8
ausgerichtet haben, können wir auf die Steuerwörtern wie bei einem 16 Pixel
breiten Sprite zugreifen? NEIN natürlich, deshalb:

Dies ist die Struktur eines normalen Sprites mit einer Breite von 16 Pixeln:


MIOSPRITE16:
VSTART:
	dc.b $50	; Vertikale Sprite-Startposition (von $2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Sprite-Startposition (von $40 bis $d8)
VSTOP:
	dc.b $5d	; $50+13=$5d	; vertikale Position des Sprite-Endes
VHBITS:
	dc.b $00	; bit

 dc.w	%0000000000000000,%0000110000110000 ; Daten
 dc.w	%0000000000000000,%0000111001110000
 ...
 dc.w	0,0		; 2 gelöschte Wörter definieren das Ende des Sprites.

d.h:

------------------------------------------------------------------------------
 dc.w 0,0					; 2 word für Steuerung
 dc.w dataPlane1,dataPlane2	; 2 word (16 bit - 16 pixel) mit 2 "plane"
 dc.w dataPlane1,dataPlane2	; 2 word (16 bit - 16 pixel) mit 2 "plane"
 dc.w dataPlane1,dataPlane2	; 2 word (16 bit - 16 pixel) mit 2 "plane"
 ....
 dc.w 0,0					; 2 word zurücksetzen zum Beenden 
------------------------------------------------------------------------------

Die Struktur der 32 Pixel breiten Sprites lautet nun wie folgt:

------------------------------------------------------------------------------
 dc.l 0,0					; 2 longword für Steuerung
 dc.l dataPlane1,dataPlane2	; 2 longword (32 bit/pixel) mit 2 "plane"
 dc.l dataPlane1,dataPlane2	; 2 longword (32 bit/pixel) mit 2 "plane"
 dc.l dataPlane1,dataPlane2	; 2 longword (32 bit/pixel) mit 2 "plane"
 ....
 dc.l 0,0					; 2 longword zurücksetzen zum Beenden 
------------------------------------------------------------------------------

Während das von 64 Pixel breiten Sprites dies ist:

------------------------------------------------------------------------------
 dc.l 0,0,0,0						; 2 doppel longword für Steuerung
 dc.l data1a,data1b,data2a,data2b	; 2 doppel longword (64 bit/pixel)
 dc.l data1a,data1b,data2a,data2b	; 2 doppel longword (64 bit/pixel)
 dc.l data1a,data1b,data2a,data2b	; 2 doppel longword (64 bit/pixel)
 ....
 dc.l 0,0,0,0						; 2 doppel longword = 0 zum Beenden
------------------------------------------------------------------------------

Was uns jetzt interessiert, ist, unsere Teile in den neuen Steuerwörten den
erweiterten Langwörter- und doppelten Langwörten zu finden.
Für 32-Bit-Sprites:

------------------------------------------------------------------------------
SPRITE32:
VSTART:
	dc.b $50	; Vertikale Sprite-Startposition (von $2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Sprite-Startposition (von $40 bis $d8)
	DC.W 0		; Wort "hinzugefügt" im 32 Pixel breiten Sprite
VSTOP:
	dc.b $5d	; $50+13=$5d	; vertikale Position des Sprite-Endes
VHBITS:
	dc.b $00	; bit
	DC.W 0		; Wort "hinzugefügt" im 32 Pixel breiten Sprite

 dc.l %00000000000000111100000000000000,%0000000000001000000000000000000 ;Daten
 dc.l %00000000000011111111000000000000,%0000000000010111100000000000000
 ...
 dc.l	0,0		; Ende des Sprites (2 longword statt 2 word).
------------------------------------------------------------------------------

Wie Sie sehen können, sind die 2 Steuerwörter 2 long geworden, und die
Steuerbits blieben im hohen Wort.

Betrachten wir nun den Fall von 64 Pixel breiten Sprites:

------------------------------------------------------------------------------
SPRITE64:
VSTART:
	dc.b $50	; Vertikale Sprite-Startposition (von $2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Sprite-Startposition (von $40 bis $d8)
	dc.w 0		; Word + longword Ergänzung, um das Doppelte zu erreichen
	dc.l 0		; longword im sprite für Breite 64 pixel (2 long!)
VSTOP:
	dc.b $5d	; $50+13=$5d	; vertikale Position des Sprite-Endes
VHBITS:
	dc.b $00	; bit
	dc.w 0		; Word + longword hinzugefügt, um das Doppelte zu erreichen
	dc.l 0		; longword im sprite für Breite 64 pixel (2 long!)

 dc.l data1a,data1b,data2a,data2b	; 2 doppel longword (64 bit/pixel)
 dc.l data1a,data1b,data2a,data2b	; 2 doppel longword (64 bit/pixel)
 dc.l data1a,data1b,data2a,data2b	; 2 doppel longword (64 bit/pixel)
 ...
 dc.l	0,0,0,0		; Ende des Sprites (2 doppelte longword!).
------------------------------------------------------------------------------

Daraus folgt, dass kleine Änderungen an UniMuoviSprite vorgenommen werden
müssen, so dass es auf die verschobenen Bytes des zweiten Steuerworts zugreift.

Ein Beispiel für ein 32 Pixel breites Sprite ist Listing15f2.s

Ein Beispiel für ein 64 Pixel breites Sprite ist Listing15f3.s

Haben Sie das Insekt gesehen? Und Sie können 8 davon machen oder 4 mit
16 Farben im Mode attacched.

Beachten Sie, dass PicCon die attached Sprites ohne das Bit 7 speichert.
Stellen Sie das ungerade Sprite ein, müssen Sie es also "von Hand" einstellen,
wenn Sie es mit diesem IffConverter speichern.

		NEUE HORIZONTALE POSITIONIERUNG MIT 1/4 PIXEL

Ein Viertelpixel? Nun ja!
Der horizontalen Position des Sprites wurden 2 "niedrige" Bits hinzugefügt.
Dadurch ist es möglich, 4-mal kleiner und damit flüssiger zu "schnappen".
Mal sehen, wo diese Bits platziert wurden, im SPRxCTL, das Register, das 	
ein "Äquivalent" des zweiten Steuerworts des Sprites ist:

 $dff142/14A/152/15A/162/16A/172/17A - SPRxCTL - Steuerung und Posit. sprite

+-------+-------+-------------------------------------------------------+
| BIT   |  Name	|	FUNKION												|
+-------+-------+-------------------------------------------------------+
| 15-08	| EV7-0	| VSTOP - die niedrigen 8 Bits der pos. vert. Ende) 	|
| 07	| ATT	| attached Steuerbit (nur ungerade sprites)				|
| 06	| SV9	| 10. Bit der vertikalen Startposition					|
| 05	| EV9	| 10. Bit der vertikalen Endposition					|
| 04	| SH1=0	| Position horizontal, 70ns Inkrement (halbes Pixel)	|
| 03	| SH0=0	| Position horizontal, 35ns Inkrement (1/4 Pixel)		|
| 02	| SV8	| 9. Bit der vertikalen Startposition (vstart)			|
| 01	| EV8	| 9. Bit der vertikalen Endposition (vstop)				|
| 00	| SH2	| Position horizontal, 140ns Inkrement (1 Pixel)		|
+-------+-------+-------------------------------------------------------+

Die Bits, die uns interessieren, sind SH0, SH1, SH2, dh Start Horizontal. Wie
Sie sehen können, finden wir neben den bekannten Bits SV8, EV8 die achten Bits
von VSTART und VSTOP, auch zwei neue Bits bezüglich des HSTART: zusätzlich
zum "niedrigen" Bit, mit dem wir jeweils ein Pixel scrollen können, wurde ein 
paar noch niedrigere hinzugefügt, mit denen wir Pixel aus dem Weg (Bild)
scrollen können oder 1/4 Pixel gleichzeitig. 140ns (Nanosekunden) ist die 
"Zeit" des Bildlaufvideos.
Es ist jedoch klarer zu sagen, dass 140ns 1 Pixel Lowres entsprechen, während
140/2 = 70ns einem Pixel hires (oder einem halben Pixel Lowres) entsprechen. 
Es scheint offensichtlich, dass 70/2 = 35ns 1/4 von Pixel Lowres oder ein Pixel
mit einer Auflösung von 1280 * xxx, das heißt Superhires entsprechen.

Aber wie bewegt sich das Sprite in Schritten von 1/4 Pixel?
Eine Möglichkeit besteht darin, die UniMuoviSprite-Routine so zu ändern, dass
hier eine X-Position von 0 bis 1280 anstelle von 0 bis 320 akzeptiert wird.
Wenn wir also jedes Mal eine 1 hinzufügen, beträgt der Bildlauf 1/4 Pixel, wenn
wir 2 addieren ist es ein halbes Pixel oder wenn wir 4 addieren scrollen wir
jeweils um ein Pixel. Einfach, nicht wahr?

Siehe die Implementierung in Listing15f4.s und Listing15f5.s 

In der Praxis ist die horizontale Position AGA eine Zahl mit 11 Bits anstelle
von 9.

			     DAS BIT BRDRSPRT

Das gesetzte BRDRSPRT-Bit ermöglicht die Anzeige des Sprites auch außerhalb der
durch diwstart / diwstop definierten Grenzen. Beachten Sie, dass bei aktiviertem
Bit die Sprites angezeigt werden, auch wenn die Bitebenen in bplcon0 deaktiviert
sind! Es ist jedoch zu beachten, dass auch Bit 0 von bplcon0 ($dff100) gesetzt
wird. Dies ermöglicht auch andere spezielle Bits. Das fragliche Bit ist das
zweite (01) des $dff106 (bplcon3).

Mal sehen, wie es umgesetzt wird in Listing15f6.s


			    DER MODUS ATTACCHED

Sprites können auf jede Weise attached werden, außer im ECS-Modus
SHRES (1280 * xxx, 35 ns).

			DIE AGA SPRITES PALETTE

Jede Bank mit 16 Farben kann als Sprite-Palette verwendet werden aus der
Palette von 256 genommen.
Mit den Bits von ESPRM7 zu ESPRM4 können Sie die Farbkarte der geraden Sprites
"verschieben", während die Bits von OSPRM7 zu OSPRN4 es erlauben, die Farbkarte
der ungeraden Sprite zu verschieben.
In OCS/ECS stammten die 16 Farben der Sprites immer und obligatorisch aus
color16 ($dff1a0) bis color31 ($dff1be), also ein Bild, das mehr als 16 Farben
hatte musste sich die Farben von 16 bis 31 mit den Sprites teilen. Mit AGA ist
es stattdessen möglich, diese Bank von 16 Farben in jedes Segment der 256 zu
verschieben. Wenn wir zum Beispiel ein 128-Farben-Bild hätten, könnten wir die
Farben der Sprites an die Position von color 129 nach vorne verschieben. Sie
müssen die Palette also nicht mit dem Bild teilen.
Der Nutzen findet sich daher bei den Bildern mit mehr als 16 Farben. Wenn die
Bitebenen jedoch 8 und die Farben 256 sind, können wir wählen, welche Bank
von 16 wir verwenden, aber diese 16 Farben werden immer mit der Figur gemeinsam
sein. So werden die Palette der Farben den Sprites im OCS zugewiesen:

Sprites | Colors
------------------
   0-1  |  00-03	; $dff1a0/1a2/1a4/1a6
   2-3  |  04-07
   4-5  |  08-11
   6-7  |  12-15
------------------

Es gibt also 4 Paare dreifarbiger Sprites.
So definieren Sie beispielsweise die drei Farben des ersten Sprites:

	dc.w	$1A2,$462	; color17, nibble niedrig
	dc.w	$1A4,$2e4	; color18, nibble niedrig
	dc.w	$1A6,$672	; color19, nibble niedrig

Im AGA-Chipsatz kann man jedoch nicht nur auswählen, welcher Teil der Palette
der 256 Farben für Sprites sind, es können auch 2 Paletten ausgewählt werden,
eine für die geraden Sprites und eine für die ungeraden Sprites mit insgesamt
32-8 Farben, d.h. 24, da color0 transparent ist und nicht zählt.
Zusammenfassend während wir in OCS 8 Sprites mit jeweils 3 effektiven Farben
haben die durch eine "Paar"-Beziehung verbunden sind, sind die Gesamtfarben
der AGA Sprites 3 * 4 = 12 immer in 3 Farben, aber sie teilen die Palette
nicht paarweise! Wenn die Sprites jedoch attached sind, wird für alle die
gleiche 16-Farben-Palette verwendet, die den ungeraden Sprites zugewiesen ist.

In der 256-Farben-AGA-Palette haben wir also 16 Paletten mit 16 Farben zur
Auswahl durch das Low-Byte von bplcon4 ($dff10c). Die Bits 7 bis 4 werden
verwendet, um die "Nummer" der Unterpalette der 16 geraden Sprites auszuwählen,
während die Bits 3 bis 0 zur Auswahl der Unterpalette der ungeraden Sprites
stehen.

Sehen wir uns die niedrigen 8 Bits des Registers bplcon4 ($dff10c) an: 

   bit	"Name"

	0	ESPRM7 \   Unterpalette auswählen
	1	ESPRM6  \  verwenden für gerade sprites 
	2	ESPRM5  /
	3	ESPRM4 /
	4	OSPRM7 \   Unterpalette auswählen
	5	OSPRM6  \  verwenden für ungerade sprites
	6	OSPRM5  /
	7	OSPRM4 /

Und hier ist eine Referenztabelle zur Auswahl der Palette:

bit 3 | bit 2 | bit 1 | bit 0 | Sprites gerade
bit 7 | bit 6 | bit 5 | bit 4 | Sprites ungerade
------+-------+-------+-------+------------------------------------------
  0   |   0   |   0   |   0   | $180/palette 0 (color 0)
  0   |   0   |   0   |   1   | $1A0/palette 0 (color 16)
  0   |   0   |   1   |   0   | $180/palette 1 (color 32)
  0   |   0   |   1   |   1   | $1A0/palette 1 (color 48)
  0   |   1   |   0   |   0   | $180/palette 2 (color 64)
  0   |   1   |   0   |   1   | $1A0/palette 2 (color 80)
  0   |   1   |   1   |   0   | $180/palette 3 (color 96)
  0   |   1   |   1   |   1   | $1A0/palette 3 (color 112)
  1   |   0   |   0   |   0   | $180/palette 4 (color 128)
  1   |   0   |   0   |   1   | $1A0/palette 4 (color 144)
  1   |   0   |   1   |   0   | $180/palette 5 (color 160)
  1   |   0   |   1   |   1   | $1A0/palette 5 (color 176)
  1   |   1   |   0   |   0   | $180/palette 6 (color 192)
  1   |   1   |   0   |   1   | $1A0/palette 6 (color 208)
  1   |   1   |   1   |   0   | $180/palette 7 (color 224)
  1   |   1   |   1   |   1   | $1A0/palette 7 (color 240)
-------------------------------------------------------------------------

So verwenden Sie es: Wenn Sie beispielsweise beide für die geraden und
ungeraden Sprites die zweite Palette mit den von Farbe 16 bis Farbe 31
auswählen möchten, setzen Sie %0001 in die Bits 0 bis 3 für die geraden Sprites
und %0001 in die Bits 4 bis 7 für die ungeraden Sprites. Das niedrige Byte wäre
also %00010001. Jetzt entspricht meine Einstellung dem OCS / ECS-Modus und die
Sprite-Palette reicht immer von Farbe 16 bis Farbe 31.
Tatsächlich beträgt %00010001 hexadezimal $11 und deshalb tun wir Folgendes:

	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

So setzen Sie die Sprite-Palette zurück !!!
Sobald dieses Rätsel gelüftet ist, ändern wir die Einstellung auf eine
nützlichere Weise für mögliche Verwendungen: Wir verschieben die Sprite-Palette
nach unten, das heißt, wir entscheiden uns von Farbe 240 bis Farbe 256. In
diesem Fall haben wir %11111111. Aber jetzt könnten wir eine Bank von 16 für
die geraden Sprites und für die ungeraden Sprites wählen! Zum Beispiel weisen
wir den geraden Sprites die Farben 224 bis 240 und den ungeraden Sprites von
240 bis 256 zu. Das Ergebnis in $dff10c ist % 1101111.

Lassen Sie uns dies in Listing15f7.s sehen.

******************************************************************************
      NEUES HORIZONTALES SUPER-FLUID-SCROLL (1/4 Pixel) FÜR BITPLANES
******************************************************************************

Horizontales Scrollen mit 1/4 Pixel wurde auch für Bitplanes implementiert.
Und raten Sie mal wie? Durch Hinzufügen von Bits zu BPLCON1 ($dff102).
Wie für die Sprites gesehen, wurden ein paar "niedrige" Bits dem Scrollwert
hinzugefügt. Zusätzlich wurden zwei Hohe hinzugefügt, die Aufnahmen mit	jeweils
16 Pixel und maximal 64 Pixel ermöglichen. Beachten Sie, dass 16- und 32-Pixel-
Aufnahmen nur dann "aktiviert" sind, wenn der Burst (FMODE- $dff1fc) 32 bzw.
64 Bit ist.
Jetzt kann der Bildlauf in Schritten von 1/4 Pixel von 0 auf 64 Pixel gehen.
Aber wir liefern:
Bisher war der horizontale Versatzwert für jedes playfield von 0 bis 15
(%1111). Jetzt wurden zwei niedrige und zwei hohe Bits hinzugefügt. Jetzt kann
es von 0 bis %11111111 gehen, d.h. von 0 bis 255 (ein 8-Bit-Wert!), aber als
1/4 Pixel-Aufnahmen gedacht, also der maximale Bildlauf wenn gemessen in
Lowres-Pixeln ist 256/4 = 64. Aber mal sehen, wo diese Bits im High-Byte des
alten bplcon1 ($dff102) "stecken geblieben" sind:

	BIT	"Name"		Beschreibung

	15	PF2H7	\ hohe Bits (6 und 7) des Scrollwertes playfield 2 
	14	PF2H6	/
	13	PF2H1	\ niedrige Bits (0 und 1) des Scrollwertes playfield 2 
	12	PF2H0	/
	11	PF1H7	\ hohe Bits (6 und 7) des Scrollwertes playfield 1
	10	PF1H6	/
	09	PF1H1	\ niedrige Bits (0 und 1) des Scrollwertes playfield 1 
	08	PF1H0	/

	07	PF2H5	\ 
	06	PF2H4	 \ "mittlere" Bits (2,3,4,5) des Scrollwertes playfield 2 
	05	PF2H3	 /
	04	PF2H2	/
	03	PF1H5	\
	02	PF1H4	 \ "mittlere" Bits (2,3,4,5) des Scrollwertes playfield 1 
	01	PF1H3	 /
	00	PF1H2	/

Hinweis:
	bit PFxH0 scrollt 1/4 pixel (35ns)
	bit PFxH1 scrollt 1/2 pixel (70ns)
	bit PFxH2 scrollt 1 pixel (140ns)
	bit PFxH3 scrollt 2 pixel
	bit PFxH4 scrollt 4 pixel
	bit PFxH5 scrollt 8 pixel
	bit PFxH6 scrollt 16 pixel (Der 32-Bit-Burst muss aktiv sein)
	bit PFxH7 scrollt 32 pixel (Der 64-Bit-Burst muss aktiv sein)

Wie Sie sehen können, ist das niedrige Byte dasselbe, während das hohe nur
AGA ist.

Angenommen, wir möchten eine Bitebene  nach rechts schieben in Scheiben von
1/4 Pixel, bis zum  maximal möglichen Wert mit dem bplcon1, dh 256 Positionen
entspricht 64 Pixel Lowres. Wir sollten den Scollwert von 0 bis 255 in 3
"Teile" aufteilen: die zwei niedrigen Bits sollten in PHxH0/1, die 4
"mittleren" in PFxH2-5 und die beiden hohen Bits in PFxH6/7 platziert werden.
Dies kann leicht mit einigen AND und LSL / LSR durchgeführt werden.

Sehen wir uns eine Implementierung in Listing15g1.s an (1 playfield)

Sehen wir uns eine Implementierung in Listing15g2.s an (2 playfield)

Versuchen wir nun, einen "Wellen"-Effekt mit einer Genauigkeit von 1/4 Pixel zu
erzielen indem wir eine Sintab in Werte für bplcon1 konvertieren und diese in
der copperliste einmal pro Zeile ändern: ListingL15g3.s

Eine Besonderheit: Wenn das Bild in hires ist, "funktioniert" das höchste Bit 
der Scrolls nicht, so dass die Werte von 0 bis 127 gehen können. Listing15g4.s

*****************************************************************************
		EINE NEUE MÖGLICHKEIT, DIE PALETTE ZU ZYKLIEREN
*****************************************************************************

Wir haben bereits die Low-Bit-Funktion des BPLCON4 gesehen. Die hohen Bits
dagegen werden verwendet, um Farben in der Palette zu "tauschen", ohne den
Inhalt der Register der Palette selbst ändern zu müssen.

	BPLTCON4 ($dff10c)

    BIT	NAME

	15	BPLAM7
	14	BPLAM6
	13	BPLAM5
	12	BPLAM4
	11	BPLAM3
	10	BPLAM2
	09	BPLAM1
	08	BPLAM0


BPLAMx = Dieses 8-Bit-Feld wird XOR-verknüpft mit der 8-Bitplane-Farbadresse.
Dadurch	wird die geänderte Farbadresse an die Farbtabelle (x = 1-8) gesendet.
Die Bits 15 bis 8 von BPLCON4 umfassen eine 8-Bit-Maske für die
8-Bitplaneadresse. Durch XOR'ing der einzelnen Bits kann der copper die
Farbkarten (color map) mit einer einzigen Anweisung austauschen.

Sehen wir uns ein praktisches Beispiel für einen Austausch zwischen Farbe A
und Farbe B an:

 - Der Inhalt des Hardware-Farbregisters wird nicht geändert

 - Alle Pixel, die mit Farbe A angezeigt wurden, werden jetzt
   mit Farbe B angezeigt und allen Pixeln, die angezeigt wurden
   mit Farbe B werden jetzt mit Farbe A angezeigt (in der Praxis: EXCHANGED!)

 - Die Gruppe von 2^n Farben von Farbe 00 bis Farbe (2^n)-1 wurde
   getauscht mit der Gruppe von 2^n Farben von Farbe 2^n bis Farbe 2^n+(2^n)-1

 - Die Gruppe von 2^n Farben von Farbe 2*2^n bis Farbe 2*2^n+(2^n)-1
   wird mit der Gruppe von 2^n Farben von der Farbe 3*2^n bis
   3*2^n+(2^n)-1 zur Farbe ausgetauscht

Der Tauschvorgang endet, wenn die Hardware keine andere Gruppen zum 
Austausch der Farbe findet.

Nehmen wir ein Beispiel: Wenn wir das zweite Bit setzen, BPLAM1 (Bit 9 des
BPLCON4), sieht die Palette vor und nach der Operation so aus:

	VORHER		|	DANACH
    -------------------------
	Color 00	|	Color 02
	Color 01	|	Color 03
	Color 02	|	Color 00
	Color 03	|	Color 01
	Color 04	|	Color 06
	Color 05	|	Color 07
	Color 06	|	Color 04
	Color 07	|	Color 05
	...			|	...

Die Farben wurden durch Verwendung von Gruppen von 2^1=2 Farben ausgetauscht.

Sie können nicht mit einer einzigen Farbe handeln. Wenn Sie ein BPLAMx-Bit
ändern, ändert dies die ganze Palette.

Die Austauschvorgänge können jedoch kombiniert werden. Wenn mehr als ein Bit 
BPLAMx gesetzt ist, werden die Austauschoperationen für jedes Bit einer nach 
dem anderen ausgeführt, beginnend mit Bit BPLAM0 bis BPLAM7.

Beispiel: $dff10c enthält $0500 (%00000101.00000000). Die Bits BPLAM0 und
     BPLAM2 sind eingestellt. Zuerst werden sie mit Gruppen von 2^0 Farben
	 getauscht. DANN wird die resultierende Palette mit Gruppen von 2^2 Farben 
	 wie in dieser Tabelle ausgetauscht:

	VORHER		|   Austausch BPLAM0	|   Austausch BPLAM1
    ---------------------------------------------------------
	Color 00	|	Color 01			|	Color 05
	Color 01 	|	Color 00			|	Color 04
	Color 02	|	Color 03			|	Color 07
	Color 03	|	Color 02			|	Color 06
	Color 04	|	Color 05			|	Color 01
	Color 05	|	Color 04			|	Color 00
	Color 06	|	Color 07			|	Color 03
	Color 07	|	Color 06			|	Color 02
	Color 08	|	Color 09			|	Color 13
	Color 09	|	Color 08			|	Color 12
	Color 10	|	Color 11			|	Color 15
	Color 11	|	Color 10			|	Color 14
	Color 12	|	Color 13			|	Color 09
	Color 13	|	Color 12			|	Color 08
	Color 14	|	Color 15			|	Color 11
	Color 15	|	Color 14			|	Color 10
	...			|	...     			|	...

In der Praxis sind die 8 Bits BPLAM0-7 des BPLCON4 eine Adressmaske
der 8 Bitebenen, da von jedem Bit ein XOR (EOR) erstellt wird.

Sehen wir uns ein Beispiel an, nur "didaktisch" für die Auswirkungen dieser
Bits: Listing15h.s


****************************************************************************
			DUAL PLAYFIELD AGA
****************************************************************************

Das neue Dual Playfield kann bis zu 4 Bitebenen pro Spielfeld haben (16 Farben
das eine Spielfeld und 16 das andere), und die Bank von 16 Farben in der
Palette von 256 ist unabhängig wählbar für jedes Spielfeld.

Um das double playfield zu aktivieren, muss Bit 10 von BPLCON0 gesetzt sein.
Wählen Sie wie gewohnt die Bitebenen (für 8 Ebenen setzen Sie die Bits
12, 13, 14 von BPLCON0 zurück und 4 setzen, andernfalls von 2 bis 6 die Bits
12, 13, 14 verwenden und 4 zurücksetzen).
Jetzt müssen Sie auf die 2 Bilder zeigen, eins in den geraden Zeigern und eins
in den ungeraden bplpointers. Dann müssen Sie auswählen, welche Farbbänke Sie
für die 2 Bilder verwenden möchten, in einer ähnlichen Weise wie wir das für
Sprites gesehen haben.

Dies wird mit den Bits 10,11,12 des BPLCON3 ($dff106) entschieden:

	| PF20F     | BITPLANE BETEILIGT            | OFFSET     |
	+---+---+---+-------------------------------+------------+
	| 2 | 1 | 0 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | (dezimal)  |
	+---+---+---+-------------------------------+------------+
	| 0 | 0 | 0 | - | - | - | - | - | - | - | - | 0          |
	| 0 | 0 | 1 | - | - | - | - | - | - | 1 | - | 2          |
	| 0 | 1 | 0 | - | - | - | - | - | 1 | - | - | 4          |
	| 0 | 1 | 1 | - | - | - | - | - | 1 | - | - | 8 (default)|
	| 1 | 0 | 0 | - | - | - | 1 | - | - | - | - | 16         |
	| 1 | 0 | 1 | - | - | 1 | - | - | - | - | - | 32         |
	| 1 | 1 | 0 | - | 1 | - | - | - | - | - | - | 64         |
	| 1 | 1 | 1 | 1 | - | - | - | - | - | - | - | 128        |
	+---+---+---+---+---+---+---+---+---+---+---+------------+

Spielfeld 2 hat Vorrang vor Spielfeld 1. Wie Sie sehen tritt die
Standardsituation tatsächlich auf, wenn die Bits 10 und 11 gesetzt sind
Standardmäßig setzen wir $c00 (%110000000000) in $dff106.

******************************************************************************
*		VGA / PRODUKTIVITÄT 640x480 ohne Interlaced	     *
******************************************************************************

Demos und Spiele werden normalerweise in PAL- oder NTSC-Auflösung ausgeführt
unterstützt von Fernsehern oder Monitoren wie 1084. Die vertikale Frequenz
beträgt 50 Hz, während die NTSC-Frequenz 60 Hz beträgt. Die horizontale
Frequenz beträgt 15 kHz. Wie Sie wissen, gehen Sie wie folgt vor, um zwischen
einer dieser beiden Frequenzen zu wählen:

	move.w	#$20,$dff1dc	; BEAMCON0 - Modus PAL

	move.w	#$00,$dff1dc	; BEAMCON0 - Modus NTSC

Dies funktioniert jedoch nicht auf älteren Amiga-Computern, die vor 1990 oder
1991 hergestellt wurden. In der Praxis haben der A1000 und der erste A500/A2000
nicht den FAT AGNUS, der das BEAMCON0 "besitzt", während dieses Register im
A500 / A2000 Kickstart 1.3 hergestellt nach 1990-91 begonnen hat zu erscheinen.
Eine AGA-Maschine hat jedoch definitiv dieses Register.

Möglicherweise haben Sie bemerkt, dass ab Workbench 2.0 die Option die Art des
Monitors ausgewählt werden kann die Einstellung einer Videofrequenz auch "VGA"
nicht interlaced, dh 640 x 480 bei 31 kHz oder sogar 800 x 600 und andere
spezielle Auflösungen.

   NTSC (525 Zeilen, 227.5 Farbtakte pro Scanlinie) 15Khz
   PAL  (625 Zeilen, 227.5 Farbtakte pro Scanlinie) 15Khz
   VGA  (525 Zeilen, 114.0 Farbtakte pro Scanlinie) 31Khz

Um diese Auflösungen anzuzeigen, benötigen Sie jedoch mindestens einen
"VGA"-Monitor oder Multisync / Multiscan. Fernseher und "normale" Monitore wie
der 1084 können diese Frequenzen nicht erfassen.

Dann denken sie vielleicht: Ich kaufe mindestens einen VGA / Multisync-Monitor
und sehe beides sowohl PAL / NTSC als auch nicht interlaced 31KHz Auflösung!
Leider können die meisten Monitore die den 640x480 bei 31 kHz anzeigen nicht 
die "Fernseh" -Auflösung bei 50/60 Hz anzeigen, sie sollten zwei Monitore
haben, einen, um die eine Auflösung zu sehen, und einen, um die andere zu
sehen. Dafür müssen Sie vorsichtig sein! Wenn Sie einen Multisync / Multiscan
Monitor kaufen möchten, stellen Sie zunächst sicher, dass auch das 320x256 PAL
von Videospielen / Demos korrekt angezeigt wird, wie zum Beispiel das C = 1950.

Das Programmieren der verschiedenen Videomodi 800x600 oder ähnlich ist
kompliziert und nicht kompatibel mit allen Monitoren. Deswegen werden wir nur
sehen, wie der 640x480 unterstützt wird auch von den schlechtesten
VGA-Monitoren des MSDOS-PCs.

In der Zwischenzeit sehen wir uns einige neue Register für die
Synchronisation an:

	VSSTRT		- Vertikale Zeilenposition für VSYNC-Start.
	VSSTOP		- Vertikale Zeilenposition für VSYNC stop.
	HSSTRT		- Horizontale Zeilenposition für HSYNC start.
	HSSTOP		- Horizontale Zeilenposition für  HSYNC stop.
	HCENTER		- Horizontale Position für VSYNC im Interlace.

Und andere für programmierbares Austasten:

	HBSTRT		- Horizontale Zeilenposition für HBLANK-Start.
	HBSTOP		- Horizontale Zeilenposition für HBLANK stop.
	VBSTRT		- Vertikale Zeilenposition für VBLANK start.
	VBSTOP		- Vertikale Zeilenposition für VBLANK stop.

Die Daten, die wir von unserem Videomodus haben, sind:

VGA (525 Zeilen, 114.0 Farbtakte pro Scanzeile) 31 kHz

Wir müssen daher in VTOTAL die Anzahl der Zeilen-1 (524) und in HTOTAL die
Anzahl der Farbtakte pro Scanline-1 (113) sowie weitere Einstellungen packen.

Um die horizontale Frequenz von 15 kHz (TV, Monitor 1084) auf 31 kHz bei VGA / 
Multiscan / Multisync-Monitoren zu ändern ist es notwendig, viele Register
zu beeinflussen, nicht nur das BEAMCON0 (das verwendet wird, um andere Register
zu aktivieren):


	LEA	$DFF000,A5

			 ;5432109876543210
	MOVE.W	#%0001101110001000,$1DC(A5) ; BEAMCON0 - Liste der gesetzten Bits:

			; 3 - BLANKEN - COMPOSITE BLANK OUT TO CSY PIN
			; 7 - VARBEAMEN - VARIABLE BEAM COUNTER COMP. ENABLED
			;     Aktivieren variable Elektronenstrahl-Komparatoren
			;	  als horizontalen Hauptzähler arbeiten,
			;	  und deaktivieren des Hardwarestopp des Displays in
			;     horizontal und vertikal.
			; 8 - VARHSYEN - VARIABLE HORIZONTAL SYNC ENABLED
			;     Aktiviert Register HSSTRT/HSSTOP (var. HSY)
			; 9 - VARVSYEN - VARIABLE VERTICAL SYNC ENABLED
			;     Aktiviert Register VSSTRT/VSSTOP (var. VSY)
			; 11- LOLDIS - DISABLE LONGLINE/SHORTLINE TOGGLE
			;     Deaktivieren des Umschaltens zwischen langen und kurzen Zeilen
			; 12- VARVBEN - VARIABLE VERTICAL BLANK ENABLED
			;     Aktiviert Register VBSTRT/VBSTOP, und deaktivieren
			;     "Hardware Ende" des Videofensters.

	MOVE.W	#113,$1C0(a5)	; HTOTAL - HIGHEST NUMBER COUNT, HORIZ LINE
				; Maximaler Farbtakt pro horizontale Zeile:
				; Der VGA hat 114 Farbtakte pro Scanlinie!
				; Der Wert liegt zwischen 0 und 255: 113 ist in Ordnung!
	
	MOVE.W	#%1000,$1C4(a5)	; HBSTRT - HORIZONTAL LINE POS FOR HBLANK START
				; Die Bits 0-7 enthalten die Startpositionen
				; und horizontal blanking stop in
				; Inkrementen von 280 ns. Die Bits 8-10 sind für
				; eine 35ns (1/4 Pixel) Positionierung.
				; In diesem Fall haben wir 2240ns eingestellt.

	MOVE.W	#14,$1DE(a5)	; HORIZONTAL SYNC START - Anzahl der Farben
							; Takte für Sync-Start.

	MOVE.W	#28,$1C2(a5)	; HORIZONTAL LINE POSITION FOR HSYNC STOP
							; Anzahl der Farbtakte für Sync-stop.

	MOVE.W	#30,$1C6(a5)	; HORIZONTAL LINE POSITION FOR HBLANK STOP
							; horizontale Zeile für Stop Horiz BLANK

	MOVE.W	#70,$1E2(a5)	; HCENTER - POS. HORIZ. von VSYNCH in interlace
							; im Fall von variablen Starhlzähler.

	MOVE.W	#524,$1C8(a5)	; VTOTAL - HIGHEST NUMBERED VERTICAL LINE
				; Maximale Anzahl Zeilen vertikal, d.h.
				; die Zeile in der der Zähler zurückgesetzt werden soll
				; vertikale Position.
				; Wir wissen das der VGA Mode 525 Zeilen hat.

	MOVE.W	#0,$1CC(a5)	; VBSTRT - VERTICAL LINE FOR VBLANK START
	MOVE.W	#3,$1E0(a5)	; VERTICAL SYNC START

	MOVE.W	#5,$1CA(a5)	; VERTICAL LINE POSITION FOR VSYNC STOP
	MOVE.W	#29,$1CE(a5)	; VBSTOP - VERTICAL LINE FOR VBLANK STOP

	MOVE.W	#%0000110000100001,$106(a5)	; 0 - external blank enable
						; 5 - BORDER BLANK
						; 10-11 AGA dual playfiled fix

Zeigen Sie jetzt einfach auf unsere copperliste bei $dff080 und erinnern
Sie sich an das Bit 0 von BPLCON0 ($dff100) es muss gesetzt sein und
wenn Sie mehr als 1 Bitebene wollen muss der 32/64-Bit-Burst mit
FMODE ($dff1fc) aktiviert werden.

zum Beispiel:

COPPERLIST:
	dc.w	$8E,$1c45	; diwstrt
	dc.w	$90,$ffe5	; diwstop
	dc.w	$92,$0018	; ddfstrt
	dc.w	$94,$0068	; ddfstop
	dc.w	$1e4,$100
	dc.w	$108,0		; modulo (nicht -8??)
	dc.w	$10A,0

		; Zeiger auf unser Bild 640x480.

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste 	bitplane
	dc.w $e4,0,$e6,0	; zweite	   "
	dc.w $e8,0,$ea,0	; dritte	   "
	dc.w $ec,0,$ee,0	; vierte	   "
	dc.w $f0,0,$f2,0	; fünfte	   "
	dc.w $f4,0,$f6,0	; sechste	   "
	dc.w $f8,0,$fA,0	; siebte	   "
	dc.w $fC,0,$fE,0	; achte		   "

	dc.w	$100,$1241	; bplcon0 (Stellen Sie keine Bit-Einstellungen ein,
						; nur die Anzahl der Ebenen und Bits 0-9 und SHRES (6))

; hier die Palette

	dc.w	$180,$000

	dc.w	$1fc,$8003	; sprite scan Verdopplung???
	dc.w	$FFFF,$FFFE	; Ende Coplist


Sehen wir uns ein praktisches Beispiel in Listing15i.s an (Wenn Sie keinen
Monitor haben, der dazu in der Lage ist 31kHz anzuzeigen sehen Sie nur
"Wischen").

Eine Bemerkung: Niemand hat jemals eine Demo oder ein 31-kHz-Spiel gemacht,
weil es nur wenige Amiga-Benutzer mit einem VGA + -Monitor gibt.
Wenn Sie Grafik in diesem Modus anzeigen (hinzufügen) möchten, sollten 
Sie zuerst ein Fenster mit der Frage anzeigen, ob die normale Frequenz oder
31 kHz verwendet werden soll!

**************************************************************************
*				KOLLISIONEN				 *
**************************************************************************

Mit Hinzufügen der Bitebenen 7 und 8, wurde ein CLXCON2 benötigt, der
Kollisionen mit diesen 2 Ebenen Aufzeichnen kann.

CLXCON2	 $dff10e	- Extended collision control - überprüfen (ob
	Bitebene 7 und 8 in der Erkennung enthalten sind !)
	Dieses Register wird beim Schreiben in das alte CLXCON zurückgesetzt -
	Die Bitfunktion ist ähnlich wie bei CLXCON

	BIT	NAME	BESCHREIBUNG

	15-08		nicht benutzt
	07	ENBP8	aktivieren Steuerbit bitplane 8
	06	ENBP7	aktivieren Steuerbit bitplane 7
	05-02		nicht benutzt
	01	MVBP8	Übereinstimmungswert für Kollision bitplane 8
	00	MVBP7   Übereinstimmungswert für Kollision bitplane 7

Hinweis: Das Deaktivieren von Bitebenen verhindert keine Kollisionen: wenn 
      alle Ebenen deaktiviert sind, sind Kollisionen "kontinuierlich".

****************************************************************************
*				BLITTER ECS+
****************************************************************************

Der Blitter hat bereits einige Verbesserungen mit dem ECS erfahren, jedoch aus
Kompatibilitätsgründen ist es immer gut, im OCS-Modus zu blitten.
Andererseits Wenn AGA erkannt wird, kann man sicher sein, ECS + verwenden
zu können, solange es nützlich ist.

In der Praxis wurden BLTSIZV ($dff05c) und BLTSIZH ($dff05E) hinzugefügt.
Dies sind in der Praxis zwei Register, in die die VERTIKALE und HORIZONTALE
Menge der Blittata anstelle des klassischen BLTSIZE ($dff058) eingegeben
werden kann. Zuerst müssen Sie in BLTSIZV schreiben, dann in BLTSIZH und die
Blittata beginnt. Im BLTSIZV muss die Höhe in Zeilen eingegeben werden, die 
zwischen 0 und 32767 liegen kann.
Wenn Sie in einer Zeile mit der gleichen Höhe blitten, ist es nicht
erforderlich erneut in BLTSIZV ($dff05c) zu schreiben. Der zuletzt eingegebene
Wert bleibt erhalten.
Die Blittata beginnt beim Schreiben in BLTSIZH ($dff05e). Schreiben Sie die
horizontale Größe der Blittata in word (von 0 bis 2047, dh bis zu 32768 Pixel).
Das Setzen von Null in diese 2 Register entspricht dem Maximum, wie beim
"alten" BLTSIZE. Der maximale Blitt wurde daher auf 32768 * 32768 im Vergleich
zum alten Blittata-Maximum von 1024x1024 gebracht.

Dann gibt es ein paar weniger wichtige Dinge:

1) Das Byte $dff05b (BLTCON0L) ist ein "fac simile" des LF-Bytes der minterms,
   das ist das Low-Byte von BLTCON0 ($dff040). Anscheinend macht es einige
   Blittings etwas schneller, besonders wenn das High-Byte von bltcon0 immer 
   das gleiche ist und sich das niedrige ändert, indem man hier schreibt...
   Ich habe jedoch keine bestimmten Geschwindigkeiten bemerkt.

2) Bit 7 von BPLCON1 ($dff042), genannt "DOFF", wenn gesetzt, deaktiviert es
   den Blitter-Ausgang Kanal D. Dies ermöglicht jedoch eine Eingabe durch die
   Kanäle A, B und C oder Adressänderungen, ohne das dies in Kanal D
   "geschrieben" wird.

Ich hoffe ich war klar genug und habe alles gesagt um die AGA zu programmieren.
Jetzt gibt es keine Ausreden! Sie MÜSSEN etwas mit dem AGA-Chipsatz 
unternehmen.

Wenn Sie jedoch AGA haben, haben Sie auch einen 68020+, so dass es sich als
nützlich herausstellen kann die nächste Lektion zu lesen, die sich genau damit
befasst!
