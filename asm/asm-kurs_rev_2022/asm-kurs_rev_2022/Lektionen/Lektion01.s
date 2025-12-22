		
		Vollständiger Assembler-Programmierkurs
			auf zwei Disketten

				By
	   
		Fabio Ciucci (Randy/Ram Jam) - 1994/95


Für all jene, die jemals zu lernen versucht haben,  Demos  und  Spiele  zu
schreiben,  die  die Hardware des  Amiga vollständig  ausnutzen wollen, es
aber nie geschafft haben, entweder  weil die  Handbücher der  Programmier-
sprachen zu schwierig oder  zu abstrakt geschrieben waren und die  Source-
Codes (Programm-Listings) zu wenig dokumentiert oder zu  schwierig  waren,
oder für jene, die es noch nie  versucht haben und und die es wundert, wie
es zu schaffen wäre.

Ich möchte all denen danken, die materiell und  moralisch  zur  Entstehung
dieser zwei Diketten beigetragen haben:

Luca  Forlizzi  (The Dark Coder/Morbid Visions)
Andrea  Fasce (Executor/RAM JAM)
Sirio Zuelli (PROXIMA DESIGN)
Alberto Longo (Fields of Vision)
Alvise Spano' (Aga/Lustrones)

Nicht  desto  weniger  jenen,  die  die   Übungen   getestet   haben   und
feststellten, ob sie sie mehr oder weniger verstanden:

Andrea Scarafoni, Federico "GONZO" Stango und andere.

Zum Schluß möchte  ich  noch  meine  Freundin  Kety  grüßen,  die  darauf
achtete, daß ich nicht zu viel Zeit vor dem Computer verbrachte.

In meiner Karriere als Hobbyprogrammierer kann ich einige Demos/Intros für
BBS als Meine bezeichnen, zum Beispiel  "AMILINK.EXE"  für  die  Datenbank
"AmigaLink"  oder  für  Clubs  wie  dem  neuen  "Amiga Expert Team". Meine
größten "Werke" sind mein erstes  Demo  für  das  AGA-Chipset,  "World  of
Manga", und "NAOS2, das ich für die Gruppe NOVA ACIES programmiert habe.

Ich  möchte  vorausschicken,  daß es irgendwie angebracht wäre, mindestens
eine Grundkenntnis des DOS  zu  besitzen,  mindestens  gerade  soviel  wie
nötig,  um  die Listings abspeichern zu können! Ihr müßtet dafür beim Kauf
ein Handbuch mitbekommen haben... Kurzum, auf  den  Disks  (seien  es  nun
Harddisks  oder  Floppy)  sind  die Daten als "File" gespeichert, das sind
schier  endlose   Reihen  von   Ziffern,  die  zusammen  dann   z.B.   ein
Graphicfile,  ein  Musikfile,  einen  ausfühbaren  File, ein  Listing usw.
ergeben. Es ist außerdem darauf zu achten,  daß  eine  nagelneue  Diskette
FORMATTIERT  werden  muß,  bevor man auf ihr Daten speichern kann. Ist sie
einmal formattiert, kann man darauf jeden Typ von File speichern, seien es
nun  Bilder  von einem Graphicprogramm oder Texte (wie den, den ihr gerade
lest). Ein File kann  man von einer  Diskette auf  eine  andere  kopieren,
man  kann  ihn  löschen  oder  seinen Namen ändern usw. Auf einer Diskette
haben so viele Files Platz, bis sie  voll  ist  (so  ein  Wunder...),  das
entspricht  in  etwa  880kB.  Das heißt, ich habe zwei Dateien zu ca 400kB
platz, oder mehrere kleinere, Hauptsache sie überschreiten zusammen  nicht
die  Grenze der 880kB. Des weiteren kann man auf der Disk auch ein bißchen
Ordnung schaffen, imdem man sog. "Subdirectorys" anlegt, das  sind  kleine
Abteilungen  in  denen  man die Files legen kann. So wäre es denkbar, eine
Subdirectory "Texte" und eine  "Bilder"  anzulegen,  in  die  wir  jeweils
unsere  Liebesbriefe an die Freundin geben bzw. unsere Bilder, die wir mit
DPaint oder einem anderen Malprogramm  zusammengeschmiert  haben.  Es  ist
ungefähr  so,  als  wäre  die  Diskette/Harddisk  wie ein Schrank, und die
Subdirectorys sind  deren  Schubladen.  Nun  ist  es  aber  auch  möglich,
innerhalb der Directorys noch weitere Directorys zu machen, also kann eine
Subd. Files oder weitere Subdirectorys beinhalten. Um sich nun  in  dieser
Struktur  fortbewegen  und verschiedene Operationen durchführen zu können,
muß man einige Befehle kennen, die man über die Shell/CLI eingibt:

Dir     =  Listet alle Files / Subdir. auf dieser Diskette/
	   Platte bzw. in dieser Directory auf
Copy    =  Kopiert ein File
Delete  =  Löscht  ein File ( Geht vorsichtig mit diesem
	   Befehl um!)
Makedir =  erzeugt eine "Schublade" (Subdir)

Eine andere Methode ist die, alles von der Workbench  aus  zu  erledeigen,
dort  sind  die  File als Ikons  (Bildchen) und die Subdirs als Schubladen
dargestellt. Weiters ist zu wissen, daß  der  interne  Floppydrive  "df0:"
heißt, die externen "df1:", "df2:" etc. Die Harddisk heißt meistens "DH0:"
oder "HD0:". Schneller geht´s, wenn man Utilities wie Directory Opus  oder
DiskMaster  verwendet.  Wenn  ihr  also ein Listing geschrieben habt, dann
müßt ihr es auf einer (formattierten) Diskette  oder  auf  der  Festplatte
(Harddisk)  in  einer Subdir speichern. Eine weitere Sache, die ihr wissen
solltet, ist, wie man eine "autoboot"-fähige Diskette herstellt. Das  sind
jene  Disks,  die  automatisch nach dem Anschalten des Computers oder nach
einem Reset laden, wenn sie im Laufwerk eingelegt sind. Nehmen wir mal an,
wir   haben   ein   AUSFÜHRBARES   Programm  geschrieben,  das  den  Namen
"Mein_Programm" trägt und dieses auf eine  Diskette  kopiert.  Um  es  nun
automatisch loslegen  zu lassen, wenn wir den Computer starten, müssen wir
auf der Diskette eine Subdir mit dem Namen "S" erzeugen  und  darin  einen
Textfile mit dem Namen "startup-sequence" speichern, in dem eigentlich nur
der Name des zu Startendem Programmes steht:

Mein_Programm

Die startup-sequence könnt ihr zum  Beispiel  mit  dem  gleichen  Programm
schreiben  (editieren),  mit  dem ihr gerade diesen Text lest. Es fungiert
auch als Text-Editor. Letze Sache: ihr müßt die betreffende Diskette  noch
"installieren", das passiert mit dem Shell-Befehl "install":

Install df0:

Oder  "Install  df1:"  ,  wenn  die  betreffende Diskette im Laufwerk df1:
liegt.

Dies vorausgeschickt, kann mit den Anmerkungen begonnen werden:

Anmerkung: Wenn ihr den Assemblerkurs auf die Harddisk installieren wollt,
vergesst  nicht,  das  File  "TRASH´M-ONE16.pref"  in eure S: Directroy zu
kopieren. Er befindet sich in der s: Directory der Diskette.

Anmerkung2: Wenn ihr die Listings ausdrucken wollt, beachtet, daß sie  mit
dem  PowerPacker  gepackt sind. Ihr benötigt also den PowerPacker Patcher,
der in diesem Kurs benötigt wurde, er befindet sich in der  Directory  "C"
dieser  Diskette  und  heißt  "PP". Um ihn zu installieren müßt ihr nur in
eurer LIBS: -Directory die "powerpacker.library" haben  und  "PP"  tippen.
Die  Listings sind selbstentkomprimierend (A.d.Ü : tut mir leid, ich kenne
kein kürzeres Wort dafür) beim Start.

In diesem Kurs werden verschiedene Argumente behandelt,  wie  der  COPPER,
die  SPRITES,  der BLITTER sowie das neue AGA-Chipset und die Graphickarte
Picasso II. Auf der Disk 1 sind folgende Themen enthalten: 68000,  Copper,
Playfields  und Sprites. Der Blitter, AGA und der Rest sind auf Disk 2 und
3, leider noch nicht ganz vollständig.

Was die Verbreitung und Kopie dieser Diskette angeht, solltet ihr  wissen,
daß  sie  GiftWare/Shareware  ist  und nicht wirklich Public Domain. Damit
meine ich, daß ihr den Kurs ohne Weiters euren  Freunden  kopieren  dürft,
Hauptsache,  ihr  VERKAUFT  ihn  NICHT, da die Rechte auf diesem Kurs beim
Autor liegen, also bei mir, und nicht beim ersten Schlaumax, der  auf  der
Arbeit eines anderen spekuliert. Es ist aber auch wahr, daß ihr ihn einzig
und alleine zum Preis der einzelnen verwendeten, leeren Diskette verkaufen
dürft.   Falls  ihr  es  aber  schafft,  nachher  selbstständig  etwas  zu
programmieren, dann habt ihr aus meiner Arbeit  Nutzen  gezogen,  und  ihr
MÜßT  mir  in  irgend  einer  Art danken, vor allem wenn ihr die reichsten
Programmierer der Welt geworden seid (na ja, man kann ja  nie  wissen...).

Dieser  Dank  liegt  ganz  in  eurem Ermessen, am liebsten habe ich
natürlich 10-DM-Scheine. Der rege Zufluß von Kies/Kohle würde  mich
(Fabio  Ciucci)  ermutigen,  weitere  Lektionen  zu  schreiben, und
meinen  Übersetzer  (Martin  De  Tomaso),  sie  ins   Deutsche   zu
übersetzen. Das Geld (mindestens 10 DM) schickt ihr bitte an ihn:

        Martin De Tomaso
        Nicolodistr. 24/3
        39100 BOZEN
        ITALY                   ; Internet: mdetomas@inf.unitn.it

Bitte habt Verständnis, daß wir aus technischen Gründen (Zeit, Uni)
nicht  imstande sind, eure Listings zu verbessern, genausowenig wie
auf tausenden von Zuschriften zu antworten. Stellt euch mal vor, so
ca.  50 Briefe am Tag vor euch liegen zu sehen, wenn ihr in die Uni
gehen müßt und euch dann auch noch die Freundin steßt.
Wenn  ihr  aber  gute  und  brave  Programmierer  seid,   und   die
Amiga-Szene   retten   wollt   (hey  Chaos,  Mr.Pet,  Tron,  Azure,
Touchstone, Wayne Mendoza, .... where are you? On the PC scene?  ),
dann  könnt  - oder MÜßT- ihr mit uns Kontakt aufnehmen. Was kostet
es euch schon, ein altes Listing zu kommentieren?  Habt  ihr  nicht
gesehen,  wieviele  MB an Listings die Coder auf den PC´s hergeben?
Man braucht nur die CD-ROM der PARTY4 und der  ASSEMBLY94  ansehen,
oder sie von Internet runterholen.
Ein anderer Grund, uns anzuleuten wäre, daß ihr imstande seid,  den
Kurs  GUT  ins  ENGLISCHE zu übersetzen (bzw. in irgend eine andere
Sprache). In diesem Fall habt  ihr  ein  Anrecht  auf  einen  guten
Prozentsatz  (30%  -  50%)  des  Profites, der von euch übersetzten
Version.

Ihr würdet mir auch einen großen Gefallen machen,  wenn  ihr  diese  erste
Diskette  allen  weiterkopiert,  die  ihr  kennt,  auch  wenn  euch selbst
persönlich  Assembler  nicht   interessiert,  da  ihr  somit  anderen  die
Möglichkeit gebt, programmieren zu lernen. Ich habe beschlossen, den ASM -
Kurs (ASM=Assembler) zu schreiben, weil 10000 Personen mich  darum  baten,
und  da  ich  es  aus  reinem  Spaß  tue,  ist  er  auch  in  einer  recht
umstreitbaren Form geschrieben, aber den Anfängern  wird  es  so  leichter
fallen,  denn wenn sie einmal "drinnen" sind, können sie immer noch selbst
die Argumente  vertiefen.  Wer  hingegen  Assembler  schon  seit  längerem
programmiert,  wird  die Lektionen teils lustig finden, teils auch gewisse
Ungereimtheiten, deswegen rate ich denjenigen, sich  sofort  die  Listings
anzuschauen:  dieser  Kurs  ist für die gedacht, die bei NULL starten. Aus
eigener Erfahrung, und laut dem, was mir die zukünftigen "CODER" so sagen,
liegen  die  größten Probleme in den ersten zwei oder drei Programmen, und
darin alles zu verstehen, danach ist man  selbst  imstande,  fortzufahren.
Ich  biete  mich  also  an,  den Personen, die nicht einmal wissen was der
68000er ist,beizubringen, Kugeln auf dem Bildschirm hin und her  zu  jagen
und  dort  hüpfende  Schriften anzuzeigen. Wenn die dann Programmierer bei
TEAM 17 werden wollen, reicht es, wenn sie weitermachen und dazulernen.

UM EIN SPIEL WIE GODS, PROJEKT X  ODER  ÄHNLICHES  ZU  PROGRAMMIEREN,  DAS
NICHT  GERADE  EIN  FLUGSIMULATOR  IST  ODER  EIN 3D-SPIEL MIT ROTIERENDEN
WÜRFELN MIT  TEXTURE-MAPPING  ODER  SINUS-TUNNELN  á  la  STARDUST  HABEN,
REICHEN DIE MATHEKENNTNISSE DER MITTELSCHULE.

Damit   will   ich   jedem   aus   dem  Kopf  schalgen,  daß  er  für  die
Assemblerprogrammierung des Amiga weiß Gott was  für  Mathematik  braucht.
Ich  persönlich  glaube,  Mathes  hat  gar  nix damit zu tun. Wenn man ein
Mathematikprogramm    schreiben    will,    ok,    dann    braucht     man
Mathematikkenntnisse,  genauso  wie  wenn  man  ein Fußballspiel schreiben
will, man Fußball kennen muß. Das Wichtige ist zu wissen,  wie  der  Amiga
funktioniert,  seinen Prozessor kennen (beim Amiga ein Motorola 68000 oder
größer), seine CustomChips (praktisch die Teile, die die Graphic  auf  den
Bildschirm   bringen   und  die  Musik  spielen).  Ich  selbst  habe  eine
Kunsthochschule in meiner Stadt besucht, und habe  die  ASM-Programmierung
gelernt,  wenn  ich  in der Mittelschule war, es reicht also, die Zeit, in
der der Amiga eingeschaltet ist, gut zu nützen, und nicht nur zu  spielen:
man  muß  nicht Informatik an der Uni studieren, denn dort bringen sie dir
sowieso nicht das Programmieren von Demos und Spielen auf einem Amiga bei!

Aber wieso sollte man lernen, Demos und Spiele zu programmieren?  Und  was
sind  überhaupt  diese  Demos?  Also,  was Spiele sind, wissen hoffentlich
alle, deswegen kann man davon ausgehen, daß diejenigen, die Spiele  selber
programmieren,  es  satt haben, Spiele zu sehen, die nicht so sind wie man
möchte, und man halt einmal sein eigenes machen  will,  Pixel  für  Pixel.
Demo  ist  ein Synonym für "demonstration", praktisch "zeigen","beweisen",
meist Graphic. Aber was zeigen, beweisen? Klarer Fall, die Power, die  der
Amiga  in  sich hat und die Bravour der Programmierer. Aber da gibt´s noch
mehr: die Szene. Nein, nicht die Theaterszene, die Amiga-Szene, die "AMIGA
SCENE"  (englisch  ist  die  offizielle SCENE-Sprache...). Stellt euch die
Musikszene  vor:  dort  gibe  es  verschiedene   Gruppen,   mit   Sängern,
Schlagzeugern  etc. In der AMIGA-SCENE hingegen gibt es verschiedene CODER
(Programmierer), GFX Artists (Graphiker), MUSICIANS (Musiker), die anstatt
ein  "VIDEO"  als  Beitrag  zu drehen, ein Demo schreiben, das sich zu den
anderen reiht, die von jemand anderem, zu einer anderen Zeit und in  einem
anderen Ort geschrieben wurden, fügen. Dann gibt´s da noch die SWAPPER und
die TRADER, die jeweils diese Demos tauschen  und  über  Post  oder  Modem
verbreiten.  Die  produzieren  zwar  gar  nichts,  haben  aber  auch  ihre
Wichtigkeit in der Szene: etwas, was nicht zirkuliert, ist so, als  ob  es
nicht  existieren  würde.  Andererseits  streben sie danach, selbst CODER,
Graphiker oder Musicians zu  werden,  um  selbst  einmal  bei  einem  Demo
mitgewirkt  zu  haben.  Es  gibt  viele  Gruppen  in  der Amiga-Szene, die
Mitglieder in der ganzen Welt haben,  vor  allem  in  Europa.  Einige  der
bekanntesten Gruppen sind ANDROMEDA, BALANCE, COMPLEX, ESSENCE, FAIRLIGHT,
FREEZERS, MELON DEZIGN, POLKA BROTHERS, PYGMY PROJECTS, RAM  JAM,  SANITY,
SPACEBALLS...  Zu  Bemerken  ist,  daß  jedes  Mitglied  einer  Gruppe ein
Pseudonym hat, ein sog.  "handle".  Kurzum,  es  sind  Künstlernamen:  zum
Beispiel  heißen  sich  zwei Programmierer der ANDROMEDA "Dr. Jeckyll" und
"Mr. Hyde", einer der FREEZERS heißt sich "Sputnik", und dann sind  andere
von   anderen   Gruppen:Hannibal,  Dan,  Paradroid,  Dak,  Wayne  Mendoza,
Performer, Bannasoft, Laxity, Vention, Psyonic, Slammer,  Tron,  Mr.  Pet,
Chaos,  Lone Starr, Dr. Skull, Tsunami, Dweezil..... Der vollständige Name
besteht  aus  dem  handle  und  der  Gruppe,  der  man   angehört,   z.B.:
CHAOS/SANITY, DWEEZIL/STELLAR, DAK/MAD ELKS, und so weiter. Ich bin in der
Szene "RANDY/RAM JAM", aber klarerweise Fabio Ciucci für alle, die mit der
Szene  nichts am Hut haben, sonst wäre es wohl etwas verwirrend. Die Szene
organisiert Partys, eine Art Begegnungs-Fete, wo die  Gruppen  ihre  Demos
vorführen,  mit einer Art "Wettkampf" um das beste Demo, mit Bewertung und
Preisen, auch in der Tausend-Mark-und-mehr-Gegend für die Gewinner. Einige
Programmierer  der Szene gehen mit der Zeit über und programmieren Spiele,
die Argumente liegen ja sehr nah. So ist zum Bleistift  der  Programmierer
von  "BANSHEE"  Hannibal/Lemon, von "ELFMANIA" ist es Saviour/Complex, die
von "STARDUST" sind DESTOP/CNCD und SCY/CNCD, und die Liste  ginge  weiter
und  weiter...  Auf  jeden  Fall, auf Disk zwei ist eine ganze Lektion nur
über die SCENE enthalten.

Um zur Assemblerprogrammierung zurückzukommen,  ob  ihr  nun  Spiele  oder
Demos  auscodieren  wollt,  rate  ich euch wärmstens davon ab, 3D-Routinen
(Routine=Teil eines Listings, eines Programmes) zu studieren, da  sie  die
komplexesten und somit die schwierigsten sind, und die ich selbst schlecht
verdaue,  nicht  wegen  der  Programmierart,  aber  wegen  der  grausligen
Matheformeln,  die  sie  beinhalten.  Aber  Achtung!  Ihr dürft auch nicht
glauben, daß  wenn  keine  Mathematik-Kenntnisse  gefragt  sind,  ihr  nun
Elektronikgenies  sein  müßt  und  die  Schaltpläne des Amiga durchbüffeln
müßt! Das ist nur der Fall, wenn ihr eine  Graphik-Karte  ansteuern  müßt,
einen  Videodigitizer oder ähnliches. Ich versichere euch, daß ihr getrost
die Figur eines Bayern auf den Bildschirm holt und dazu eine Polka spielen
läßt,  ohne  zu  wissen, wo die Drähte ´rumführen!!!! Ich kenne Leute, die
Assembler mit 12 gelernt haben, andere mit 30 oder 40,  ohne  sich  jemals
mit  Mathematik  befaßt  zu haben und ohne Englischkenntnisse. GENAU! DENN
AUCH DEN MYTHOS, PERFEKT ENGLISCH KÖNNEN ZU MÜSSEN,SCHLAGT EUCH SOFORT AUS
DEM  KOPF! Ich gebe zu, englisch zu können erleichtert die Arbeit manchmal
schon,  denn  die  ASM-Befehle  sind  Abkürzungen  von  Wörtern  aus   dem
Englischen,  wie  SUB  und  ADD,  was  soviel wie Subtraktion und Addition
heißt. Die Kenntnis der WorkBench und des  AmigaDOS  werden  euch  in  der
Programmierarbeit  an  und  für  sich  nicht  recht  nützlich sein, da der
Computer   in   Wirklichkeit   ziemlich   anders   funktioniert.   Einfach
ausgedrückt,  sind  diese  "Überstrukturen" das Betriebssystem, die in den
Kickstart-Chips lokalisiert sind, und  ohne  die  beim  Einschalten  nicht
einmal  die  Bildschirmseite  angezeigt würde, die verlangt, eine Diskette
einzulegen. Die Fenster, die ihr seht und verstellt, sind das Ergebnis von
tausenden  Zeilen in ASM, die im Kickstart enthalten sind, zur Bestätigung
reicht es aus, die Unterschiede zwischen Kick 1.3 und  2.0  anzusehen.  Es
hat  sich nichts an den Disketten geändert, aber an den Kickstarts selbst.
Wenn ihr Programme wie Deluxe Paint, Kontoüberwachung, Haushaltskasse oder
Word-Processor schreiben wollt, also Programme, die  unter  der  Workbench
laufen  sollen,  mit all ihren Fenstern, Menues, Gadgets und Multitasking,
dann rate ich euch, die Programmiersprache "C" zu lernen. Sie ist für eure
Art   von   Tätigkeit   besser   geeignet,  und  ihr  könnt  ohne  größere
Schwierigkeiten eure Programme nach MS-DOS und  WINDOWS  konvertieren,  im
Falle,  daß ihr unsere Freundin verlassen (oder verraten?) wollt. Wenn ihr
aber  von  Graphicdemos  mit  springenden  Kugeln,  metallern  glizzernden
Schriften  und Super-Soundtracks im Hintergrund fasziniert seid, und davon
träumt, Spiele wie AGONY,LIONHEART, SHADOW OF THE BEAST, TURRICAN, APYDIA,
PROJECT  X, SUPERFROG, ZOOL, GODS, CHAOS ENGINE, XENON II, LOTUS ESPRIT zu
programmieren, dann sollte klar sein, daß  das  nur  in  REINEM  ASSEMBLER
machbar  ist!!  Und es braucht keine speziellen Vorkenntnisse in Mathe, es
reichen  die  üblichen  Additionen,  Subtraktionen,  Multiplikationen  und
Divisionen, vielleicht manchmal eine Sinustabelle oder eine Kosinustabelle
um zum Beispiel die Kugeln in einer gewissen Laufbahn flizzen  zu  lassen,
sei  es nun eine Parabelform oder sonst eine Art von Kurve. Diese Tabellen
sind nichts anderes als eine  Serie  von  Zahlen  im  Speicher,  wie  z.B.
1,2,3,5,8,10,13,15,18,23,  die  wiederum nichts anderes darstellen als die
X-Position bei einer bestimmten Y-Position. Diese Serien von  Zahlen,  die
Tabellen  oder  SINUSTAB,  erzeugt  der ASMONE auf Wunsch auch von selbst.
Dafür gibt´s den Befehl CS, der, ohne genaues  Wissen  über  Trigonometrie
und  ähnlichem  Zeug,  die  Tabelle von selbst erstellt, es reicht ihm die
richtigen Parameter zu übergeben, schlimmstenfalls probiert  man  halt  so
lange, bis es mehr oder weniger paßt. Solche SINUSTAB  kommen in Demos und
Spielen oft vor, da viele wellenartige Bewegungen nicht in  diesem  Moment
berechnet  werden.  Wenn ihr aber davon träumt, Adventurespiele wie Monkey
Island  zu  schreiben  bzw.   Managerspiele,   in   denen   nur   stehende
Graphicseiten  auftreten,  und  sich  darin  höchstens hie und da mal eine
Figur langsam bewegt, in denen der Sinn des  Spieles  darin  besteht,  die
richtigen Objekte oder Schriftzüge mit der Maus auszuwählen, dann ist auch
C besser am Platz. Es wird auch leichter, es auf PC zu  konvertieren,  auf
dem  man  dan leicht einen Haufen Geld verdienen kann. Andererseits wird C
in  den  technischen  Hochsculen  unterrichtet,  und  sehr  gut   an   den
Universitäten, also machen schon die das große Geld.

Anmerkung:  Das  Beherrschen  des  Assemblers des Amiga kann sich als sehr
nützlich erweisen, wenn man in Zukunft auf ein  anderes  System  umsteigt,
das  mit  dem  gleichen  Prozessor  arbeitet, eben dem 68000 von Motorola.
Solche Systeme sind Apple MacIntosh und AtariST. Diese Systeme haben  aber
ein  anderes Betriebssystem als das im Kickstart des Amiga enthaltene, und
andere Chips für die Darstellung der Graphic und  des  Tons,  also  werden
euch  die  erworbenen  Fähigkeiten  für  den Prozessor, nicht aber für das
andere Betriebssystem oder die anderen Graphic/Sound-Chips zu Gute kommen.
Für diese müßt ihr immer von NULL beginnen. Aber auch bei Sprachen wie dem
"C" bleibt euch das Erlernen der neuern Umgebung nicht erspart.  Wenn  ihr
zum  Beispiel  ein  Programm  in  C  unter der Workbench schreibt, das ein
Fenster öffnet, und darin Berge zeichnet, und ihr steigt auf  PC-MSDOS  um
(grober  Fehler!),  dann  könnt ihr den Teil des Programmes, der die Berge
berechnet wiederverwerten, aber der Teil,  der  die  Fenster  öffnet,  die
Gadgets  und ähnliches unter der Workbench verwaltet, ist zu verwerfen und
komplett neu zu schreiben. Und ich versichere euch, auf ein anderes System
umzusteigen und alles neu zu lernen kostet Monate wenn nich Jahre an Zeit.

Anmerkung:Ein   Programm,   das  in  68000er  Assembler  geschrieben  ist,
funktioniert tadellos auf höheren Prozessoren, man muß  nur  einige  Dinge
beachten.

Wenn   ihr  noch  da  seid  und  lest,  dann  heißt  das,  ihr  seid  noch
unerschrocken. Also beende ich das Aufzählen der Vorzüge des  Assembler...
(die  Sprache  an  und  für  sich  heißt  ASSEMBLY,  das  Programm, das es
compiliert nennt  man  ASSEMBLER,  aber  einfacherweise  nennt  man  alles
ASSEMBLER,  auch  die Sprache selbst). Als erstes wird Assembler immer die
schnellste Sprache sein, was Geschwindigkeit  der  Programme  angeht.  Vor
allem,  wenn sie gut geschrieben wurden, werden sie immer schneller laufen
als mit einem  x-beliebigen  anderen  Compiler.  Weiters  kann  man  damit
spezielle  Grafikeffekte  erzeugen,  die  es noch nie gegeben hat: ok, ihr
könnt sie auch  mit  einem  Titler  erzeugen,  aber  halt  immer  nur  die
gleichen.  Es  ist  nicht  schwer  zu  erkennen,  mit welchem Programm ein
gewisser Effekt erzeugt wurde. Das gleiche gilt auch für die  Demo  Maker.
Der  Beste  darunter  ist  der  TRSI  DEMOMAKER,  und  er  hat zweifelslos
interessante Effekte, aber inzwischen erkennt auch ein  Kind  eine  Sache,
die  mit  dem  Demomaker  gemacht wurde, weil da immer die goldene Schrift
oben und unten auftaucht, und in der Mitte entweder die Kügelchen oder die
Sternchen...  JETZT  REICHTS! Man kann´s schon bald nicht mehr seh´n! Aber
mit Assembler kann man dauernd neue Effekte  erfinden,  die  noch  niemand
gesehen  hat,  und  man  muß  sich  nicht  darauf beschränken, unter einem
Dutzend Vordefinierten auszusuchen, die  schon  tausende  andere  Personen
verwendet  haben  und  Privatfernsehn  damit angehäuft haben. Um euch eine
Idee davon zu verschaffen, was ihr alles anstellen könnt, möchte  ich  das
Demo  von  SPACEBALLS  "State  of  the Art" nennen, eines der bekanntesten
Demos, weil es alle erstaunte wegen der stilisierten Mädels, die in Mitten
von Spezialeffekten tanzten. Ist nicht Schwieriges zu programmieren.

Wenn  ein  Programmierer  genug Geduld hat, kann er sich auch an ein Spiel
heranwagen, zuerst um es selber zu spielen, um das Spiel seiner Träume  zu
kreiren,  um  zu  experimentieren, wieviele Männchen er bewegen kann, ohne
Geschwindigkeitseinbußen, um die wahren Grenzen des Amiga zu finden,  und,
später,  vielleicht  ein kommerzielles Spiel auf die Beine zu stellen, das
auch die Mitarbeit von Grafikern und Musikern erfordert.  Weiters  braucht
es  dann  noch  einen,  der  an der Werbetrommel rüttelt, denn die ist oft
ausschlaggebender als der effektive Wert des  Spieles,  außer  in  einigen
Fällen, in denen das Spiel einfach so toll ist, das es trotzdem zum Erfolg
kommt. Wieso  nicht  ein  Spiel  für  CD32  entwickeln??  Es  reicht,  ein
AGA-Spiel  zu  machen, das die 600MB einer CD ausnützt, z.B. mit einer Art
von "Film", die in Echtzeit im Hintergrund geladen wird, auf der sich  ein
Alles-Töten-Rambo  oder ein Raumschiff bewegt. Es ist gar nicht so schwer,
ein solches Spiel zu  machen:  das  Chipset  ist  mehr  oder  weniger  das
gleiche,   es   sind  nur  einige  Register  dazuzulernen,  der  Prozessor
unterscheidet sich um NULL komma Josef, und die Verwaltung der CD ist noch
einfacher.  Da gibt´s nämlich das "CD32 Developer Kit", zwei Disketten mit
allem Nötigen, das unter den Programmierern zirkuliert. Im  Endeffekt  ist
an der Schwelle zum 2000 Assembler noch an der Spitze mit dabei, und wenn,
wie viele PC-Typen prophezeien, nur mehr CD´s die Welt regieren, wird auch
der  Amiga  mit  seinen  CD´s aufwarten. Denn zur Zeit sind es ja noch vor
allem die PC-Fanaten, die voll aufrüsten um nur noch CD-Games  zu  spielen
und  sich  Slideshows von nackten Girls anzuschauen. Na ja, und wenn eines
Tages ein eine Software auf CD für den  Amiga  hervorkommt,  dann  ist  es
möglich, daß alles mit einem uns nicht unbekanntem Assemblerkurs begann...
Wenn man dann einmal versteht, wie die Dinge in Wirklichkeit laufen,  kann
man  auch  versuchen,  die  Spiele und Programme zu verändern. So habe ich
einige Male ein Programm so veränert, daß es den virtuellen  Speicher  des
A4000   verwendet   oder  habe  ich  gewisse  Routinen  von  PD-Programmen
verändert,  so  daß  sie  schneller  liefen.  Bei  Spielen  kann  man  die
sogenannten  Trainer  schreiben,  in etwa so, daß wenn Player 1 stirbt, er
ein Leben dazukriegt und  ihm  somit  zur  Unsterblichkeit  verhelfen.  Um
solche  Spielereien  aufzuziehen muß man aber schon einiges auf der Platte
haben, und vor allem braucht es dazu eine Utility, die MS-Monitor  genannt
wird.  Diese  erlaubt  das  disassemblieren  von  Maschinencode,  also das
anzeigen von gewissen Teilen des Speichers, und wenn man  dann  genau  den
erwischt,  in  dem  die  Leben des Player 1 stehen, ist die Sache geritzt.
Besser noch sind aber die Cartridges wie die ACTION REPLAY. MS  steht  für
Maschinensprache,  es  ist praktisch die Sprache, die der Prozessor direkt
verwerten kann und die der Assembler erzeugt. MS ist aber für uns Menschen
extrem  unverständlich, und so hat man sie in Assembler gekleidet, der uns
alles sehr viel leichter macht. Diese  Operationen  sind  aber  wie  schon
gesagt,  recht schwierig, und es hat auch keinen rechten Sinn, einfach auf
geradewohl loszuhacken und zu versuchen, ein blaues Männchen  grün  werden
zu  lassen.  Ich  habe  Typen  erlebt,  die  ihre  Zeit damit vergeudeten,
blindlings  mit  MS-Monitoren  und  Cartridges  darauf  loszuschießen   um
Änderungen  vorzunehmen, die eingentlich kein Mensch richtig verstand -sie
selbst inklusive- nur um dann zu Behaupten, sie hätten weiß der Geier  was
für  Verbesserungen  an  dem Programm/Spiel angebracht. Diese können heute
immer noch nicht eine Grafik  in  Assembler  anzeigen;  im  Jargon  heißen
solche Typen LAMER.

Bringen  wir  mal alles auf einen Punkt: wenn ihr einer dieser klassischen
18 jährigen, bleichgesichtigen, buckligen Jungs ohne Mädels seid, und  auf
gut  Glück  mit  einem  MS-Monitor  in  den  Intimitäten eures armen Amiga
rumfuchtelt, und behauptet, ein großer  Hacker  zu  sein,  dann  legt  den
Monitor bei  Seite  und  folgt  mir auf den rechten Weg. Auch ich habe auf
dieser lächerlichen Art und Weise begonnen (aber mit 8  Jahren,  nicht mit
18!), habe aber bemerkt, daß es zu nichts führt und somit begonnen, Bücher
zu lesen ohne Seiten zu überspringen.

*Anmerkung   des   Übersetzers:  An  diesem  Punkt  werden  einige  Bücher
aufgezählt, die es (nicht) wert sind, unter die Lupe genommen  zu  werden,
die  meisten  jedoch  von  italienischen  Herausgebern  mit ausschließlich
italienischen Auflagen. Ich zähle sie trotzdem auf und verweise auf  jene,
die  in  englisch  oder deutsch zu haben sind. Hätte jemand einen Beitrag,
also wenn jemand ein Buch empfehlen kann, dann bitte schreib mir!!!  Meine
Adresse findest du auf der Diskette!!

"IL  MANUALE DELL´ HARDWARE DELL´AMIGA" Herausgeber IHT. Ist einen Versuch
wert, eine deutsche Version zu suchen. Soll scheinbar mächtig gut sein! In
ihm  werden  die  Hardware-Bausteine wie CUSTOM-CHIPS und FLOPPY unter die
Lupe genommen, Register beschrieben usw. Es ist aber mehr eine  Ansammlung
von  abstrakten Daten und Tabellen ohne Beispielen, aber die findet ihr ja
in diesem Kurs. Für die Register braucht ihr nur im ASMONE den Befehl "=C"
zu  tippen, und es kommen die Informationen über die Register $DFFXXX, sei
es generell wie speziell: =C 040 gibt euch eine Zusammenfassung  über  das
Register DFF040, das ist BLTCON0, ein Blitterregister.

"HARDWARE REFERENCE MANUAL" nur in englischer Version.

"ROM  KERNEL  MANUAL"  nicht  recht empfohlen für hüpfende Kugeln etc, nur
wenn man in ASM unter der WorkBench programmieren möchte.

Weiters gibts dann noch das "AMIGA GURU BOOK", wenn ich nicht voll daneben
liege,  in  englisch, und weiter wie "Amiga Spiele Programmierung", "Amiga
Assembler Praxis" ü.ä. Ich kann sie weder empfehlen noch abraten, denn ich
kenne  sie  (noch) nicht. Wenn jemand genaueres weiß, dann weiß er ja, was
er zu tun hat... *Ende der Anmerkungen des Übersetzers.

Anmerkung: Wenn ihr hingegen nicht die bleichen MS-Monitor-per-Zufall-User
seid,  sondern  gierige Forscher von neuen Spielen, die es zu kopieren und
zu beenden gilt, und ihr Stunden damit verbringt, am Telefon zu hocken  um
euch über die Neuigkeiten zu informieren, und die restlichen Stunden damit
verbringt, mit XCOPY zu kopieren und  zu  spielen,  vielleicht  immer  mit
eingeschaltenem Trainer um früher ans Ende zu kommen,  dann  ist  es  noch
schlimmer als bucklig mit dem  MS-Monitor  zu  sein:  entweder  ihr  macht
Schluß  mit  diesem atemlosen Kummer, immer auf der Suche nach Kopierbarem
zu sein, oder ihr werdet immer  überspannt  und  gestresst  sein  und  nie
erfahren,  wieso  sich  die  Figuren  über den Bildschirm bewegen, und ihr
werdet nie erfahren, wie man sich selber einen Trainer mit Menu  und  viel
Trara  macht,  und ich versichere euch, wenn ihr mal einen Trainer für ein
Spiel geschrieben habt, dann kratzt euch nicht mehr, das Spiel zu beenden,
sondern  nur  zu  verstehn,  wie´s  wohl  läuft!!! Das ist der Unterschied
zwischen  dem  Spieler  und  dem  Erschaffer  des  Spieles,  zwischen  dem
unterworfenem Volk und dem herrschendem Regime, das ihm quasi befiehlt, in
schlaflosen Nächten Unmengen an Spielen zu Ende zu bringen,  entweder  mit
oder  ohne  Tainer,  und egal, welche Spiele, Hauptsache, es sind Neue und
Viele, wenn möglich mit XCopy kopiert (verwendet mindestens einen besseren
Kopierer,  XCopy  ist  einer der schlechtesten!). P.S.: Weil wir grade von
Mädels  sprachen...  Ich  habe  noch  NIE  was  von  einer  Frau  in   ASM
programmiert  gesehen!!  Wenn  das  gerade eine Vertreterin des weiblichen
Geschlechtes liest, dann glaube ich, ist es ein weiteres Motiv, die  Erste
zu  sein!! Wenn sich ein Mädchen für anderes als Tuschel über fremde Leute
und Vetrinen von Geschäften interessieren würde, und fetzige Dinge in  ASM
schreiben,  dann  glaube  ich,  könnte  sie  so  manchen Boy in eine Krise
versetzen, da die meisten davon bei den (weinigen) Girls, die sie  kennen,
so  sehr angeben, wie gut sie den Mauspointer über den Bildschirm bewegen,
und ihnen vorgaukeln, mit der NASA  in  Verbindung  zu  stehen,  weil  sie
glauben,  die  versteh´n eh nicht die Bohne. Meistens können die nicht mal
´ne Diskette formattieren.

Ich möchte hier schon mal vorweg nehmen, daß die  Lektion2.TXT  mit  ihren
Beispielen  die schwierigste von allen ist. Wenn ihr die überstanden habt,
dann ist die Sache gelaufen. Denn schon ab Kapitel 3 beginnen wir mit  den
ersten  Coppereffekten, und von da an werdet ihr schnell wie Kanonenkugeln
sein. Also bitte ich  euch,  die  ersten  beiden  Lektionen  mit  Ruhe  zu
verdauen,  ohne  Dinge  zu  überspringen  und -wie bei Romanen- die letzte
Seite am Anfang zu lesen. Es bringt nichts.

Nun schau´n wir mal, was wir zum programmieren brauchen:

-Der ASSEMBLER ist das Programm, das die Listings mit ihren Befehlen (ADD,
SUB,...),  für  den  Programmierer  lesbar, in das Äquivalente von binären
Zahlen übersetzt (für den Microprozessor lesbar). So wird z.B. der  Befehl
"RTS"   in   $4e75   übersetzt,  usw.  Das  macht  programmieren  halbwegs
menschlich, denn stellt euch vor,  ihr  müßtet  jeden  Befehl  als  Nummer
auswendig  wissen!  Das  würde programmieren in reiner MS bedeuten, es ist
aber klar, daß es  viel  besser  ist,  in  ASSEMBLY  zu  tippen!  Der  nun
entstandene  binäre  Code  wird  Objekt-Code  genannt  und  ist direkt vom
Computer ausführbar. Man kann ihn als ausführbares File  abspeichern  oder
direkt   testen.  Ach  ja,  erinnert  euch  auch,  daß  in  Assembler  die
Numerierung in Hexadezimal gängig  ist!  Hex-Zahlen  sind  jene,  die  das
"$"-Symbol  am  Anfang  stehen  haben.  Sie  arbeiten mit der Basis 16, im
Gegensatz zum Dezimalsystem, das mit Basis  10  arbeitet,  das  heißt,  es
kommen  auch  die  Buchstaben  A,B,C,D,E,F vor, wie im vorherigen Beispiel
$4e75. Es ist egal, ob die Buchstaben groß oder  klein  geschrieben  sind,
$4e75  ist  identisch  mit $4E75. Wenn in einem Listing "Grammatik"-Fehler
vorkommen, dann weist uns der Assembler darauf hin. Denn  es  gibt  einige
präzise  Regeln,  die  einzuhalten  sind.  So  z.B.  muß  ein  LABEL (oder
Etikette) am Anfang einer Zeile stehen, es dürfen keine Leerzeichen  davor
sein,  und  es  muß  mit  einem Doppelpunkt (:) enden. Ein korrektes Label
sieht so aus:

PLUTO:

Der  Name  kann nach Belieben vergeben werden, und PLUTO geht gut, denn es
beinhaltet keine komischen Zeichen wie +-=^  usw,  es  beginnt  am  Anfang
einer  Zeile  und endet mit :. Labels werden im ganzen Programm an "Dinge"
vergeben, und sie dienen dazu, diese Dinge zu merken, sie zu finden,  wenn
man  sie sucht. Wenn man innerhalb des Programmes einer Reihe von Befehlen
den Namen PLUTO gibt, und dann zu irgend einem Zeitpunkt den Befehl  gibt,
Pluto  auszuführen,  dann  werden die Instruktionen darunter abgearbeitet.
Genauso können wir einem Bild oder einem Musikstück ein  Label geben.  Die
Labels  stellen  also die Speicherstelle dar, an der etwas liegt, genauso,
wie Städtenamen die geographische Position der  selben  angibt!  Wenn  ich
nach  Sidney gehen will, dann gehe ich da hin, wo das Label Sidney: steht.
Erinnert euch aber, daß Labels nur uns Codern als Gedächtnisstütze dienen,
der  Assembler  verwandelt dann alles in Zahlen, seien es nun Befehle oder
Labels (die ja nur Speicherstellen  sind  und  somit  eine  Adresse,  eine
Haus-"Nummer" haben).

Dann   gibt´s  noch  die  Befehle,  die  IMMER  von  einem  oder  mehreren
Leerstellen vorangegangen werden muß,  besser  noch  von  einem  TAB,  der
gleich  8 auf einen Schlag macht (es ist die Taste über CTRL), gefolgt von
den Operanden.

Pluto: MOVE.L $10,$20

In diesem Fall ist MOVE.L der Befehl (oder Instruktion), während der erste
Operand $10 ist und der zweite $20.  Manche  Befehle  brauchen  nur  einen
Operanden, andere überhaupt keinen, z.B.:

CLR.L $10

Nur  ein  Operand.  Befehle wie RTS brauchen z.B. keinen. Dann ist da noch
der Kommentar, der uns hilft, zu erinnern, was wir  gerade  tun:  er  wird
immer nach einem Strichpunkt (;) geschrieben.

Pluto:  ;LABEL, stellt die Adresse von MOVE dar MOVE.L $10,$20 ;Befehl mit
2 Operanden CLR.L $10 ;Befehl mit 1 Operand RTS ;Befehl ohne Operanden

Die  Kommentare  werden  beim  assemblieren  verworfen,  also  könnt   ihr
schreiben,  was  und wieviel ihr wollt, Hauptsache nach dem ;. Das war die
Grammatik. Nach diesen einfachen Regeln wird das Programm erzeugt, und  ob
es dann tut, was ihr wolltet, hängt dann ganz von euch ab!

-Ein  EDITOR  hingegen  ist  ein  Programm,  das euch ermöglicht, Texte zu
schreiben und zu modifizieren,  in  unserem  Fall  werden  wir  damit  die
Listings  schreiben,  die ja nichts anderes sind als Text, der die Befehle
(Move, Sub,...) und die Kommentare enthält. Bessere  Editoren  haben  dann
Such-  und  Ersetzoptionen,  mit  denen  gewisse Zeichenfolgen gesucht und
ersetzt werden können. Normalerweise endet der Filename  von  ASM-Listings
mit  .ASM  oder  .S. Ich bevorzuge .S, TExte, die zum lesen bestimmt sind,
enden mit .TXT. Der Name des File aber  beeinflußt  in  keiner  Weise  die
Funktionsweise des Assemblers, der frißt alles.

-Ein MONITOR ist in diesem Fall nicht die Glotze des Computers,sondern ein
anderes Programm, das euch ermöglicht, die Inhalte des Speichers zu sehen,
z.B.  was  auf  Speicherzelle $100 steht usw. Normalerweise haben Monitore
auch  einen DISASSEMBLER, das Gegenteil des  Assemblers,  mit  integriert,
das das Sehen des Speichers als Befehlen erlaubt. Er verwandelt also MS in
Assembly, er verwandelt $4e75 in "RTS".

-Ein DEBUGGER, wortwörtlich "Entwanzer", dient dazu, ein  Programm  Befehl
für  Befehl  durchzugehen  und  zu  testen.  Damit findet man meistens die
Stelle, an der ein Fehler liegt.

Manchmal muß der Objektcode, um einwandfrei unter  dem  Betriebssystem  zu
arbeiten,  gelinkt  werden,  denn  ein ausführbares File enthält nicht nur
einen Block von Befehlen, sondern auch Angaben  darüber,  wie  er  in  den
Speicher  geladen  werden soll. Das geschieht mit dem LINKER. Das gilt für
.EXE  und  .COM  Files  unter  MSDOS  genauso  wie   bei   allen   anderen
Betriebssystemem. Das ist auch der Grund, warum unter Atari oder MacIntosh
Amigafiles  nicht  gelesen  werden,  obwohl  sie  den  gleichen  Prozessor
besitzen: weil das Format eben anders ist. Speziell unter dem Amiga gibt´s
die HUNKs, und um Objectcode durch Mausklick oder  Shellbefehl  ausführbar
zu  machen,  müssen  sie  gelinkt  werden.  Zum  Glück  haben  die meisten
Assembler den Linker eingebaut, und ihr müßt euch nicht darum sorgen!

Gut, der Assembler, der diesem Kurs beigefügt ist,  der  TRASH´M´ONE,  hat
einen  Editor, einen Assembler, einen Debugger/Monitor und einen Linker!!!
Alles in einem, was will man denn mehr! Es ist die modifizierte PD-Version
des Asmone.

Übrigens,  zum  Editor,  ihr könnt einen Text suchen, indem ihr die Tasten
AMIGA rechts+Shift+S gleichzeitig drückt, oder mit der  rechten  Maustaste
aus  dem  Menue  die Option SEARCH unter dem Titel "Edit Funkt." auswählt.
Nun erscheint links oben die Schrift  "Search  for:",  wo  ihr  das  -oder
dieWorte  eingebt,  die ihr suchen wollt. Es kann nützlich werden, z.B. um
die Stelle wiederzufinden, an der ihr aufgehört habt, zu lesen, in  diesem
Fall  Zeile  592  (wird  links  unten  angezeigt), oder ihr sucht das Wort
"Funkt." oder "Zeile 592" oder was euch grade einfällt.

Natürlich hätten wir normalerweise das Listing mit einem Editor  schreiben
müssen und mit einem beliebigen Namen abspeichern.Dann mit einem Assembler
laden, assemblieren und den Objektcode speichern. Um das Programm dann  zu
guter  Letzt  testen  zu  könne,  kommt  auch  noch das linken dazu. Um es
verändern zu können, wieder mit dem Editor laden, speichern, usw. bis  zur
Vergasung.  Auf  den  PC-MS-Dosen  ist  das  so  der  Fall,  und ich hab´s
aufgegeben, dort in  Assembly  zu  programmieren.  Aber  beim  Amiga,  mit
Multitasking  kann  man gleichzeitig Editor und Assembler laden, etc. Und,
als würde das noch nicht reichen, hat jemand den ruhmvollen SEKA erfunden,
ähnlich  dem  jetzigem  ASMONE, der Editor, Assembler und Monitor alles in
einem hatte. Dann ging die Entwicklung weiter  zum  MasterSeka,  dann  zum
ASMONE  und  dann  endlos  viele,  von  Hobbyprogrammierern  modifizierte,
Versionen dessen. Die zwei verbissensten Verbesserer  (die  sind  wirklich
gut!) sind die TFA die den TFA ASMONE hervorgebracht haben, und DEFTRONIC,
die diesen TRASH´M´ONE ins  Leben  riefen.  Ich  habe  den  von  DEFTRONIC
ausgewählt,  weil  er  am  wenigsten  BUGS  (Fehler) hat, denn die meisten
anderen Versionen assemblieren oft saDFSDAF SADFFDSASAD, aber man kann  es
ihnen  ja nicht verübeln, denn sie tun es ja aus purem Spaß, ohne etwas zu
verdienen!

Das Endergebnis ist also, daß ihr ein Listing eintippen könnt,  und  dann,
mit   ESC,   zum   Assembler/Monitor  überwechseln,  und  dort  (mit  "A")
assemblieren oder den Speicherinhalt ansehen, sei es nun als  Zahlen  oder
als  Befehle  dargestellt, und zum Schluß -aber nicht weniger interessant-
disassemblieren. Um das ausführbare File  direkt  abspeichern  zu  können,
tippt "WO" in der Kommandozeile (das ist die Zeile, die ihr erreicht, wenn
ihr mit ESC den Editor verlasst). Damit  keine  Verwechslungen  auftreten,
stellen  wir  noch mal klar, daß es einen Unterschied zwischen Listing und
Programm gibt: das Listing ist ein Text, der  die  Befehle/Anweisungen  in
ASM  enthält,  und  es  ist mit jedem Editor editierbar, z.B. dem CED oder
GoldED.Das Listing wird durch "W" abgespeichert. Das Programm hingegen ist
das   schon   assemblierte   File,  es  ist  von  der  WorkBench/Cli/Shell
ausführbar, es hat schon den Hunk angehängt etc. Abspeichern  durch  "WO".
Der  Editor  im ASMONE ist also nur ein Editor wie alle anderen, ihr könnt
damit auch die Startup-sequence ändern oder  einen  Brief  an  eure  Mutti
schreiben.

Alsodann,  jetzt werde ich -auf meine Art- mit den Erklärungen fortfahren,
wie der Computer funktioniert.

Derjenige, der alles organisiert ist  der  Prozessor,  oder  CPU  (Central
Processing  Unit),  praktisch  der Boss...Er führt Befehle aus, in der Tat
besitzt er ein genaues Set von Anweisungen, die er ausführen kann, nur die
und keine anderen. Er geht dabei immer der Reihe nach, erst eine, dann die
nächste, usw., außer man befiehlt ihm, nach weiter vorne  oder  hinten  zu
springen,   oder   eine   Schleife   (Loop)  auszuführen.  Einige  Befehle
(Anweisungen) sind: MOVE, das soviel bedeutet wie bewegen, hier  aber  als
"kopieren"  zu interpretieren. Move $10,$20 sagt also "Kopiere das, was in
$10 (Adresse/Speicherzelle) nach $20" aus. Dann CLR, Abkürzung für  Clear,
also  Lösche, setze auf NULL: CLR $10 -> lösche die Adresse/Zelle $10. Als
Adresse, Speicherzelle oder Zelle meine ich einen Punkt im  Speicher,  der
dem Prozessor zugänglich ist.

Übrigens, der Prozessor operiert im Speicher!! Erstellen wir also eine Art
"Karte" darüber:

Wenn die Befehle mit Adressen  herumhantieren,  die  kleiner  als  $200000
sind,  dann  befinden wir uns im CHIP RAM. Von $000000 bis $80000 befinden
sich die ersten 512kB Chip Ram, also die der alten A500  und  A2000,  wenn
die  Ram aber bis $100000 weitergeht, haben wir 1MB Chip Ram, wie z.B. die
A500+,  A600  oder  die  neueren  A2000.  Bei  den  A1200,   auffrisierten
(erweiterten)  A500+  oder  A600 hingegen reicht die Chip Ram bis $200000.
Also sind Befehle unter $200000 in der Chip Ram:

CLR.L $30000 MOVE.L $150000,$1a0000

Das waren Instruktionen, die  in  der  ChipRam  arbeiten.  Wenn  aber  mit
Adressen  über  $200000 gearbeitet wird, dann befinden wir uns in der Fast
Ram. Ein alter A500 mit 1MB Speicher ist in zwei Blöcke  zu  512kB  (512kB
Fast + 512kB Chip) aufgeteilt:

1)  von  $000000  bis  $80000  ;ersten  512kB  CHIP RAM 2) von $c00000 bis
$c80000 ;512kB FAST RAM

Mit Utilities wie SYSINFO könnt ihr feststellen, wie  eure  Speicherblöcke
verteilt sind.

Dann  existieren  noch  spezielle  Speicherzonen, wie in etwa die der ROM,
also des Kickstarts. Die beginnt normalerweise bei $fc0000  für  Kick  1.2
und  1.3  und  $f80000 für Kick 2.0 und 3.0. Die ROM kann im Gegensatz zur
RAM nur gelesen, nicht aber überschrieben werden.  Sie  bleibt  auch  nach
abschalten des Computers intakt.

Eine  extrem  wichtige  Adresse  ist  noch  $DFF000,  denn von $DFF000 bis
$DFF1FE sitzen die CUSTOM CHIPS für  Grafik  und  Sound.  Um  eine  Grafik
anzuzeigen  oder  Musik spielen zu lassen, muß man in die Adressen $DFFXXX
die richtigen Werte schreiben, sonst passiert gar  nix.  Diese  speziellen
Adressen  werden auch REGISTER genannt. Probiert mal, in der Kommandozeile
(mit ESC schaltet ihr zwischen Kommandozeile und Editor  um!)  den  Befehl
"=C"  einzutippen,  ihr werdet eine Zusammenfassung der Register mit ihrer
Adresse erhalten. Die Zahlen sind die Adressen, 000 steht für $DFF000, 100
für  $DFF100,  und  die  Namen  sind daneben geschrieben, z.B. ist $dff006
VHPOSR,  und  $dff100  BPLCON0.  Diese  Adressen  kann  man  entweder  nur
beschreiben  oder  nur  lesen,  z.B.  $dff006  ist nur lesbar, $dff100 nur
beschreibbar. Ihr werdet zwischen Zahl und Namen entweder ein W oder ein R
stehen sehen : W (write) -> nur schreiben, R (read) nur lesen. Andere sind
S (strobe) oder ER (EarlyRead), wir werden sie besprechen,  wenn  wir  sie
verwenden.

Weitere  Spezialadressen  befinden  sich  in der Gegend von $bfeXXX, genau
gesehen von $bfe001 bis $bfef01. Sie beziehen sich auf den Chip CIAA,  der
verschiedene  Dinge  beinhaltet,  wie  den  Timer  oder die Kontrolle über
verschiedene Ports, z.B. den Parallelport, das ist der, an dem der Drucker
hängt. Analog dazu gibt´s die CIAB, sie hängt an den Adressen $bfdXXX.

In  Erinnerung behalten müßt ihr eigentlich nur, daß wenn ihr eine Adresse
vom Typ $bfeXXX, $dfdXXX oder $dffXXX seht, sie sich auf  die  CustomChips
bezieht,  die  Farbänderungen  auf  dem  Bilschirm  zur  Folge haben, oder
Bewegungen von Maus oder Joystick einlesen uvm.

Was die RAM angeht, sei es nun CHIP oder  FAST,  braucht  ihr  euch  nicht
darum  zu  kümmern,  wo  welcher  Befehl  landet. Das erledigt für uns der
ASMONE, wir müssen lediglich einige LABELs verteilen,um gewisse Stellen zu
markieren,  danach  ersetzt der Assembler sie mit den realen Adresswerten.
Wen´s interessiert, er  kann  danach  nachschauen,  wo  die  Instruktionen
gelandet sind.

Aber  fahren wir mit den Beispielen fort: Es gibt Befehle wie ADD und SUB,
die soviel wie Addition und Subtraktion bedeuten, un so bedeutet z.B.  SUB
#10,ENERGIE  "ziehe  von  ENERGIE  10  ab".  Weiters  Multiplikationen und
Divisionen wie MULS, MULU, DIVS und DIVU und die logischen Operationen OR,
AND  NOT  und andere. JMP bedeutet JUMP ("Springe"), also springe zu einer
bestimmten  Adresse  (z.B.  JMP  $40000),  JSR  hingegen  veranlasst   den
Prozessor,  zu  einer Routine auf einer bestimmten Adresse zu springen und
diese durchzuführen, bis er einem RTS begegnet (JSR "Jump  to  SubRoutine"
->  "Springe  zu  SubRoutine"), (RTS "Return from Subroutine" -> "Verlasse
SubRoutine, kehre zurück"). RTS steht also für "komm zurück,  die  Routine
ist  fertig", und die Abarbeitung des Programmes fährt nach dem JSR wieder
fort. BRA tut im Wesentlichen das geliche wie JMP, BSR wie JSR. TST  heißt
"Test"  (gegenüber  NULL),  es testet also eine bestimmte Adresse oder ein
Register, ob es NULL ist.  Diese  Instruktion  oder  die  Instruktion  CMP
("Compare",  ->Vergleiche),  die  etwas  mit etwas Anderem vergleicht, ist
normalerweise von einem sog. "Bedingtem Sprung" gefolgt: z.B. BEQ ("Branch
if  Equal"  ->  "Springe wenn Bedingung erfüllt") oder BNE ("Branch if not
Equal"  ->  "Springe  wenn  Bedingung  NICHT  erfüllt").   So   kann   man
verschiedene Verzweigungen erzeügen, hier ein dummes Beispiel:

Anfang:  BSR  GLOCKEN  ;  BSR  ->  springt bis unter das Label "GLOCKEN" ;
danache kommt er hierher zurück und führt WarteMaus aus  BSR  WarteMaus  ;
Wartet,  bis  Mausknopf  gedrückt  wird  BSR  PAVAROTTI  RTS ; verläßt das
Programm, kehrt zum ASMONE oder zur Workbench zurück,  jenachdem,  von  wo
aus es gestartet wurde.

WarteMaus:  Hier  wird kontrolliert, ob der Mausknopf gedrückt wurde. Wenn
NICHT, springt er zu WarteMaus zurück, er läuft praktisch  im  Kreis,  bis
der  Mausknopf  gedrückt  wird, wie ein Hund, der versucht, seinen eigenen
Schwanz  zu  fangen.  In  diesem  Fall  werden  wir  ein  "BNE  WarteMaus"
verwenden.
    
RTS ; Ende der Subroutine, kehre unter das ; aufrufende "BRS" zurück

GLOCKEN: DingDong ; eine Routine, die "DingDong" spielt
    
RTS

PAVAROTTI: AAAAAAAHHHHHHHHH ; Diese Routine läßt den Pavarotti singen
    
RTS


END ; zeigt das Ende des Listings an, kann man ; auch weglassen

(Was unter dem END geschrieben wird, wird vom Assembler nicht gelesen)

Also, wenn wir dieses hypotetische Programm starten würden,  dann  könnten
wir sagen, daß es bei "Anfang" beginnt, und diese Routine die Hauptroutine
ist, die drei UnterRoutinen (SubRoutines, Teile  eines  Programmes,  denen
man  einen  Namen  gibt, z.B. PAVAROTTI) der Reihe nach aufruft: als ertes
würde der Prozessor zu "GLOCKEN" springen und die Glocken  läuten  lassen,
dann  findet  er  ein  RTS,  kehrt also unter das BSR GLOCKEN zurück, dort
findet er aber ein weiteres BSR, das, das ihn zu  WarteMaus  bringt.  Dort
bleibt  er,  bis  jemand  die  Maus  drückt  (eine  Knopf  davon, versteht
sich...). Der Prozessor  kontrolliert  auch eine  Milliarde  mal,  ob  der
Mausknopf  gedrückt  wurde,  und  erst,  wenn  das  eintrifft, kann er die
Routine verlassen, da der Endloszyklus unterbrochen  wird,  weil  das  BNE
nicht  mehr  wahr  ist.  Am  RTS  von  WarteMaus  angekommen, hüpft er zum
Hauptprogramm zurück, wo ihn schon das nächste  BSR  erwartet:  PAVAROTTI.
Wenn  er dann vom Pavarottikonzert zurückkommt, findet er nur mehr ein RTS
vor: für ihn bedeutet das, daß er aussteigen soll,  zum  ASMONE  oder  zur
Workbench, jenachdem. Das Programm ist zu ENDE.

Jetzt   erkläre   ich   euch  besser,  wie  der  Prozessor  sich  mit  den
verschiedenen Befehlen verhält: Im Falle von "BEQ Label" sprechen wir  von
einer  Verzweigung, denn an diesem Punkt gibt es zwei Alternativen: stellt
euch einen Baum vor, so einen richtig alten und trockenen  ohne  Blättern,
eine  uralte  Eiche  mit  einem knotigen Stamm, der sich an einem gewissen
Punkt in zwei Äste unterteilt, und jedes der Äste verzweigt  sich  nochmal
in  zwei  kleinere  Äste, und so weiter. Wenn wir nun am BEQ ankommen, ist
es, als wären wir eine kleine Ameise, die am Anfang des Programmes -  also
des  Stammes - gestartet ist, wo unser Ameisenhaufen START: steht. Gut, wo
wir nun zur VERZWEIGUNG: gekommen sind, müssen  wir wählen,  entweder  den
linken  Ast  oder  den  rechten. Diese Wahl trifft der 68000 auf Grund des
Resultates einer vorherigen Bedingung, praktisch eines CMP oder eines TST:

START: ; Ameisenhaufen im Gras ... ... TST.B LABEL30 ; ist  das  Byte  von
LABEL30  =  0 ??? (Beispielbedingung) BEQ RECHTERAST ; wenn ja, springe zu
RECHTERAST ; wenn nicht (ungleich 0), dann fahre mit LINKERAST fort.  (das
bedeutet, das Byte hatte einen Wert zwischen $01 und $FF)

... ; Befehle von LINKERAST ... ...
    
RTS  ;  ENDE,  wir  steigen  aus.  Wir  haben  den  linken Ast ; genommen.
RECHTERAST: ... ; Befehle vom rechten Ast... ... ... RTS ; Ende, wir haben
den rechten Ast genommen.

In  diesem  Fall  verwenden  wir eine Testbedingung (TST, Vergleich mit 0,
oder CMP, vergleich zwischen zwei Operatoren), gefolgt von einem BEQ (wenn
ja,  springe...) oder einem BNE (wenn nicht, springe...), um entweder eine
Serie von Befehlen auszuführen oder eine andere. Wir haben das  BNE  schon
verwendet,  um  eine  Schleife  (LOOP)  durchzuführen, in der eine gewisse
Anzahl von Instruktionen wiederholt  ausgeführt  werden,  bis  nicht  eine
bestimmte  Kondition  (Bedingung)  eintrifft,  zum Beispiel der Mausdruck.
Eine Schleife kann man vielleicht besser mit  einem  Roboter  vergleichen,
der  immer  die gleiche Handlung ausführt, auch zig-millionen mal, ohne zu
ermüden oder zu streiken:

GEH IN DIE KÜCHE, KONTROLLIERE, OB DER KUCHEN FERTIG  IST,  WENN  ER  NOCH
NICHT  FERTIG  IST,  GEH  INS  WOHNZIMMER  UND  ENTLAUSE  DEN  HUND FÜR 30
SEKUNDEN, DANN GEH IN DIE KÜCHE, KONTROLLIERE, OB DER KUCHEN  FERTIG  IST,
WENN  ER  NOCH  NICHT FERTIG IST, GEH INS WOHNZIMMER UND ENTLAUSE DEN HUND
FÜR 30 SEKUNDEN, DANN GEH IN DIE KÜCHE, KONTROLLIERE, OB DER KUCHEN FERTIG
IST,  WENN  ER  NOCH NICHT FERTIG IST, GEH INS WOHNZIMMER UND ENTLAUSE DEN
HUND FÜR 30 SEKUNDEN, DANN GEH IN DIE KÜCHE, KONTROLLIERE, OB  DER  KUCHEN
FERTIG IST, WENN ER NOCH NICHT FERTIG IST, GEH INS WOHNZIMMER UND ENTLAUSE
DEN HUND FÜR 30 SEKUNDEN, DANN

Es ist wohl recht eindeutig, daß sich ein Mensch  rebellieren  würde,  für
die  Dauer eines Kuchenbackens dieses Hin und Her ertragen zu müssen. Aber
der 68000 macht keinen Mucks, er wiederholt alles, bis der  Kuche  endlich
gar   ist,   also   das   BEQ   eintritt,  und  der  Roboter  zur  Routine
HOLIHNAUSDEMROHROHNEDIRDIEHÄNDEZUVERBRENNENUNDSTELLIHNAUFDENTISCH:.

Ihr werdet schon ahnen, daß mit einigen Verzweigungen hier  und  da,  auch
innerhalb  mehr  oder  weniger  großen  LOOPs,  recht  komplexe Strukturen
entstehen können. Man kann da z.B. an Programme denken,  die  das  Wachsen
einer  Stadt  simulieren  und  dafür  tausende von Bedingungen in Betracht
ziehen. All dies ist durch  Verzweigungen  möglich,  die  Teils  mit  sich
selbst, Teils mit Schleifen verbunden sind.

Die  Äste,  also  die Brocken von Befehlen, die ausgeführt werden, nachdem
ein BEQ oder ein BNE eingetreten ist, oder  einfach  weil  sie  gerade  da
waren,  als der 68000 vorbeikam, werden ROUTINEN oder SUBROUTINEN genannt.
Es sind also  Stücke  von  Programmen,  bestehend  aus  einer  Anzahl  von
Befehlen,  die  ausgeführt  werden,  wenn  eine bestimmte Aufgabe verlangt
wird, bei uns war es der Roboter, der den Kuchen aus dem Rohr holte. Diese
Aufgaben  können praktisch in eine eigene Routine gelegt werden, die immer
dann angesprungen wird, wenn ein Kucken aus dem Rohr  zu  holen  ist.  Die
Aufgabe von Routinen liegt prinzipiell genau darin, nicht immer einen Teil
des Listings neuschreiben zu müssen, wenn z.B. ein Kuchen aus dem Rohr  zu
holen ist. Wir können also diese Serie von Anweisungen, die dazu notwendig
sind, isoliert in eine Routine geben, ihr am Anfang  ein  Label  versetzen
und  am  Ende  ein  RTS.  Geben  wir  einer  Subroutine  eine  Definition:
-SUBROUTINE wird folgende  Struktur  genannt,  die  aus  einem  Block  von
Befehlen  besteht,  der  von  einem  LABEL  (Belibiger  Namen, gefolgt von
Doppelpunkten) vorangegangen wird und mit einem speziellem Befehl, dem RTS
(ReTurn  from  Subroutine)  endet.  Sie  wird normalerweise mit einem BSR,
gefolgt vom Namen der Subroutine, angesprungen. Nach abarbeiten  derselben
fährt  das Programm in der Zeile unterhalb des aufrufenden BSR weiter. Das
alles ist mit dem Käptn eines Unterseebootes vergleichbar, der  in  diesem
Fall   das   Hauptprogramm  darstellt,  der  durch  Verteilen  von  Ordern
gewissermaßen  Subroutinen  durchführt,  z.B.  wenn  er  im  Periskop  ein
feindliches  Schiff sieht, wird er ein BSR TorpedosLaden durchführen, also
den Befehl geben, die  Torpedos  scharf  zu  machen.  Bis  die  Subroutine
TorpedosLaden nicht fertig ist, kann er nicht fortfahren. Wenn er dann die
Mitteilung  erhält,  daß  diese  klar  sind,  wird  er  mit  der  Prozedur
fortfahren:  BSR  SchiffLinks  und  BSR SchiffRechts, bis es nicht auf der
Schußlinie zum gegnerischen Schiff liegt; das kann man mit einer  Schleife
vergleichen,  die  mit  einem CMP SCHIFF,SCHUßLINIE, gefolgt von einem BNE
VERSTELLUBOOT, aufgebaut ist, d.h.: "Ist das Label, die die  Position  des
feindlichen  Schiffs  enthält,  gleich  mit  dem  Label,  die die Position
enthält, die die Torpedos treffen werden (Schußlinie)?"  wenn  noch  nicht
(BNE),  dann  verstelle  noch,  also  kehre zur Routine zurück, die zuerst
erkennt, ob wir  zu  weit  links  oder  zu  weit  rechts  sind,  und  dann
dementsprechend  die  Routinen  SchiffLinks oder ShiffRechts aufruft. Dies
ist mit dem Loop des Roboters vergleichbar, der darauf  wartete,  daß  der
Kuchen  gar  ist, nur müssen wir hier selbst aktiv die Position erreichen,
wie beim WarteMaus, bei dem wir  die  Maustaste  drücken  mußten,  um  den
Zyklus  zu  unterbrechen.  Wir waren bei der Zielschleife stehengeblieben:
auf einmal giebt der Kommandant den Befehl, die Torpedos zu  feuern!  (BSR
SCHUßEINS,  BSR  SCHUßZWEI).  BOOOOOOOOM... Es hat funktioniert... überall
liegen Tote rum, Socken schwimmen auf dem Wasser, Witwen und  Waisen  sind
über  ganz  Deutschland  verstreut  (in den Kriegsfilmen sterben immer die
Deutschen...), ein Relikt am Meeresgrund. RUHIG BLUT! Es war nur eine gute
Computersimulation!

Wenn  ihr nun in die Logik des Prozessors eingegangen seid, dann ist alles
in Butter. Alles, was ihr auf dem Computer so laufen seht, sei es nun  ein
Programm  für  die Wettervorhersage, ein Demo mit Kuben und Kügelchen, ein
Actionspiel,  besteht  aus  Stücken  von  Programmen,  die  zyklisch  oder
sequentiell (in einer Schleife oder Nacheinander) aufeinander abfolgen, je
nach Ergebnis der Abfragen wie TST, CMP, BTST. Also ist jede durchgeführte
Operation,  auch  wenn sie noch so kompliziert und komplex erscheint, eine
Summe von einfachen Abfragen und Verzweigungen, gefolgt  von  Anweisungen.
Jede  Subroutine  kann  aus  vielen,  kleineren Subroutinen bestehen, z.B.
HOLDENKUCHENAUSDEMROHR:

HOLDENKUCHENAUSDEMROHR:  BSR   SchaltDasRohrAus   BSR   ÖffneDasRohr   BSR
NimmDenKuchen  (Es  ist  ja  ein  Roboter,  der  verbrennt sich nicht) BSR
LegDenKuchenAufDenTisch

RTS

Jede dieser SubRoutinen kann durch weitere Subroutinen aufgeteilt werden:

SchaltDasRohrAus: BSR GehZumSchalter BSR DrehIhnNachLinks

RTS

Der größte Komfort der SR (Subroutinen) liegt darin, daß man das  Programm
in  logische  Teile  gliedern  kann,  die  es  somit  klarer und einfacher
gestaten, und daß  man  Sammlungen  von  ihnen  anlegen  kann,  die  immer
wiederverwenden  kann,  z.B. eine Joystickabfrage. Diese kann man in jedem
Spiel einfügen, muß vielleicht einige leichte Änderungen daran  vornehmen,
aber  die größte Arbeit ist getan. Das gleiche gilt für Musikroutinen oder
SR, die ein Männchen bewegen.

Damit wollte ich euch eine Idee verschaffen, wie der arme  Prozessor  hin-
und  hergejagt  wird,  je  nach  Ausgang  einer  Abfrage.  Wenn bei diesem
Hinundhergehüpfe dann mal ein Fehler auftritt,  z.B.  fehlerhaft  geladene
Daten  von  der  Disk  oder  wo  Programmierer versagt hat, dann tritt das
mythische GURU MEDITATION  bzw.  SOFTWARE  FAILURE  in  seinem  unheimlich
leuchtendem  rotem  Fenster auf. Der RAM-Speicher kann man beschreiben, er
wird, wie schon gesagt, in FAST und CHIP aufgeteilt. Der Unterschied liegt
darin,  daß  Grafiken  und  SOUND  unbedingt in die CHIP-RAM gelegt werden
müssen, während Instruktionen für den Prozessor genausogut in FAST  wie IN
CHIP  leben.  Z.B.  hat der alte A500 mit Kick 1.2 oder 1.3 512kB Ram, und
wenn man ihn erweitert insgesamt 1MB, aber die ersten 512kB sind CHIP, die
anderen FAST! Deswegen endet der Speicher unter DeluxePaint bei einem A500
mit 1MB schneller als bei einem A500+, der den ganzen 1MB  nur  CHIP  hat.
Beim  A500  sind die 512kB FastRam übrig, sie sind zum Öffnen von Fenstern
ungeeignet, deswegen meldet er, daß kein Speicher mehr frei ist. Wenn  man
programmiert, und versucht, Grafik in die FAST-RAM zu legen, dann passiert
so ziemlich alles, aber es wird keine Grafik angezeigt. Der  Speicher  ist
in  Blöcke  aufgeteilt,  beim  A500 geht er von $00000 bis $80000, und die
512kB Erweiterungsspeicher von $c00000  bis  $c80000:  das  Betriebssystem
weiß  genau,  wie der Speicher verteilt ist, und es legt ein Programm, das
von  der  Workbench  oder  von  der  CLI/Shell  geladen  wurde,  je   nach
Anforderung  in  Chip  oder  Fast.  Danach springt der Prozessor an diesen
Punkt und beginnt mit der Abarbeitung. Dem Anwender bleibt aber unklar, wo
sein  Programm  hingeladen wurde und wo der Prozessor gerade arbeitet. Ich
ahbe gesagt, daß der Speicher beim A500 von $00000 bis  $80000  geht,  der
Speicher  ist  in  der  Tat  in  Teile zerlegt, wie eine Straße mit vielen
Häusern, von denen jedes eine Adresse hat: nicht  ohne  Grund  heißen  die
Adressen  (Adress, in englisch): Am Anfang der Straße ist das Haus mit der
Nummer  0,  dann  Nummer  1,  usw.  Es  wird  aber  das  Hexadezimalsystem
verwendet,  also  mit  Basis 16. Aber das ist kein Problem, denn unter dem
ASMONE kann man jede Hexziffer sofort  konvertieren,  indem  man  den  "?"
verwendet:  ?$80000  ergibt  524288  in  Dezimal,  also 512*1024, also ein
halber kB, "ein halbes Kilo", multipliziert mit 1024 (->  1kB),  das  dann
einen  halben Mega ergibt. $100000 hingegen ist das doppelte, probiert mal
?$80000*2 ("*" -> "Mal", multiplikation). Die Hexzahlen werden  von  einem
Dollarzeichen  angeführt,  wie  ihr  gesehen  habt,  die Dezimalzahlen von
nichts, die Binärzahlen von einem %. Diese Dinge  sind  von  grundlegender
Bedeutung:  so,  wie  es  für die Distanz das Meter, den Dezimeter und den
Zentimeter gibt, gibt es für den Speicher des BIT, das BYTE, das WORD  und
das  LONGWORD.  Das  Bit  ist  die  kleinste Einheit im Speicher. Ein Byte
besteht aus 8 Bit, und das ist eine Einheit,  die  eine  Adresse  besitzt:
Hier  kann der Prozessor sagen: Bewege (oder besser: kopiere) das Byte aus
dem Haus in der Speicherallee Nr. 10 in das Haus in der Speicherallee  Nr.
16.  In  diesem  Fall  hat  er  die  acht  Bit, die im Byte 10 (also $A in
Hexadezimal) enthlaten waren, ins Byte 16  kopiert.  Um  Durcheinander  zu
vermeiden, hier das Beispiel in Zeitlupe: die Bit´s können entweder 0 oder
1 sein; die Bit im Byte 10 waren : 00110110, im Byte 16 hingegen 11110010.
nach  dem MOVE.B 10,16 bleibt das Byte 10, wie es war, und das Byte 16 ist
nun 00110110. Das .B nach dem Move deutet an, daß nur ein Byte  verschoben
wird,  also  der kleinste Teil, den wir direkt ansprechen können. Man kann
auch ein MOVE.W oder ein MOVE.L einsetzen,  also  ein  WORD(.W)  oder  ein
LONGWORD(.L), die nichts anderes sind als: 1 Word = 2 Byte, ein Longword =
4 Byte = 2 Word. Wenn man also ein MOVE.W 10,16 ausführt, dann werden zwei
Bytes kopiert: in die Zelle (Adresse) 16 kommt das Byte von Adresse 10, in
die Zelle 17 das Byte von Adresse 11. Im Falle eines MOVE.L werden 4 Bytes
verstellt: 10->16, 11->17, 12->18, 13->19. Machen wir ein kleines Schema:

VOR  dem MOVE.B 16,10      08/09/10/11/12/13/14/15/16/17/18/19/20
				 W  O  R  T	   P  E  D  A  L

NACH dem MOVE.B 16,10      08/09/10/11/12/13/14/15/16/17/18/19/20
				 P  O  R  T	   P  E  D  A  L

Wenn wir ein MOVE.L 10,15  08/09/10/11/12/13/14/15/16/17/18/19/20
machen				 P  O  R  T     P  O  R  T  A  L

In unserem Beispiel waren die Adressen 8, 9, 14, 15 leer, also auf NULL,
während die Adressen 10-13 und 16-20 Werte (in unserem Fall Buchstaben)
enthielten.

Beenden wir das Werk mit einem MOVE.W 8,10 und einem MOVE.W 10,12

			    08/09/10/11/12/13/14/15/16/17/18/19/20 
						 P  O  R  T  A  L

Mit vier Befehlen haben wir  WORT  PEDAL  in  PORTAL  verwandelt!!  Scherz
beiseite,  fahrt  nicht  fort  bevor  ihr  nicht  in  das  echte  Hirn die
Arbeitsweise des synthetischen  Hirns  geprägt  habt!  Probiert  ein  paar
Spielchen mit den MOVE.x, das tut euch gut! Probiert zum Beispiel NEGER in
REGEN zu verwandeln, oder PAPPIS BART in BARBAPAPA,  MEIN  HAUS  in  MEINE
MAUS...

Erinnert  euch,daß  Prozessoranweisungen  immer an geraden Adressen stehen
müssen, wie 2, 4, 6, usw., also an WORD angepasst,  sonst  geht  alles zum
GURU...  Um  euch  die  Zweifel zu nehmen: im Speicher sind eine Reihe von
Werten hintereinander gereiht, ob es nun Prozessorbefehle sind oder  Daten
für  Grafik, Sound, SINUSTAB oder Rollschriften... Im Speicher aber liegen
sie nicht als MOVE.B 10,16 vor, das ist eine Disassemblierte  Version,  in
Wirklichkeit  sieht  dieser Befehl so aus: $13 $F9 $00 $00 $00 $0A $00 $00
$00 $10. Er besteht aus 10 Byte, wobei $13F9 in groben  Zügen  dem  MOVE.B
entspricht,  $000A  der 10 und $00010 der 13 (Hex 0A= 10 dezimal, Hex 10 =
16 dezimal). Auf diese  Art  besitzt  jede  Operation  ein  Bytemuster  im
Speicher,  sogar  NOP,  No  Operation,  ->  keine  Operation, tut nix, hat
eines:$4e71. Vorausgreifend möchte ich sagen, daß der Prozessor, außer auf
den  Speicher  zuzugreifen,  auch noch Register besitzt: Datenregister und
Adressregister. Insgesamt sind es 16 und jedes ist ein  Longword  lang  (4
Byte).  Die  Adressregister  heißen  A0,  A1,  A2, A3, A4, A5, A6, A7, die
Datenregister D0, D1, D2, D3, D4,  D5,  D6,  D7.  Da  sich  die  Registrer
innerhalb  des  Prozessors befinden, sind sie sehr schnell, auf jeden Fall
schneller, als der Speicher. So ist die Operation MOVE.L  d0,d1  schneller
als MOVE.L $100,$200, man bevorzugt also jene, die mit Registern arbeiten. 

Die  ROM  -  wie  schon  gesagt- kann man nicht beschreiben, ein MOVE, das
dorthin schreibt bleibt also effektlos: ein  MOVE  auf  $FC0000  oder  auf
$F80000  ist für gar nichts gut. Es ist nur möglich, Routinen auszuführen,
die in der ROM gespeichert sind. Da aber bei jeder Version der Kick ANDERS
ist,  darf  man  ihn  NIE  DIREKT  anspringen.  Das  Betriebssystem ist so
ausgelegt, daß jede Routine,  also  Programmstück,  das  in  im  Kickstart
enthalten ist, auf die gleiche Art aufgerufen werden kann, egal, um welche
Version es sich handelt und wo im Speicher sie sich befindet: das wird mit
einem  JSR,  oder  JUMP  TO SUBROUTINE (Spring zu Adresse xxxx, dann kehre
unter das JSR zurück und fahre dort weiter), gemacht. Die  "Schrittweiten"
für  die  JSR  der  verschiedenen  SR sind fix, starten aber immer bei der
Adresse, die in Adresse 4 enthalten ist. In der Adresse  4  ist  also  die
richtige Adresse eingetragen, ab welcher sich die SR befinden, und man muß
sich IMMER daran halten, um Routinen des Kickstarts verwenden  zu  können.
Die Programme, die WorkBench-Fenster öffnen, Buchstaben auf den Bildschirm
schreiben oder Files von einer Disk lesen oder auf  eine  Disk  schreiben,
müssen jedesmal  auf  solche SR im Chip des Kick zugreifen, und ihnen z.B.
den Namen des Files übermitteln, den man öffnen möckte oder die Größe  des
Fensters...  Wenn ein Spiel, ein Programm oder ein Demo das Betriebssystem
überspringt, es also  nicht  verwendet,  dann  werden  keine  Aufrufe  zum
Kickstart  gemacht. Ein Beispiel ist das bekannte XCopy, das einen eigenen
Screen öffnet, eindeutig das Multitasking über  den  Haufen  wirft,  keine
WorkBenchfenster  hat  und auch keine Rechte-Maus-Taste-Menüs, wie sie aus
dem AmigaDOS bekannt sind. Genauso würde ein Spiel, wie ich einige  vorher
angeführt  habe, z.B. SENSIBLE SOCCER, funktionien, wenn man den Kickstart
nach dem BOOT (Start) entfernen würde, da  es  keine  Routinen  aufgerufen
werden,  die  ein  File  laden  oder ein Fenster öffnen. Die Dinge, die am
Bildschirm erscheinen, werden Eins nach dem anderen kontrolliert, und  die
Daten  werden  nicht  als  DOS-Files von der Diskette geladen, sondern als
Spuren, die direkt über den Lesekopf eingelesen werden, der wiederum  "von
Hand"  gesteuert  wird,  indem  man  an  den  verschiedenen  Pin des DRIVE
Spannung anlegt  oder  nicht  (natürlich  softwaremäßig).  Leuchtet  diese
Differenz   ein??   Zwischen   Programmen   und   Spielen,   die   dauernd
Kickstart-Routinen verwenden, deswegen  in  Multitasking  laufen  und  den
Programmen,  die  keine  Fenster  verwenden,  oder zumindest nicht die der
Workbench, und nicht mit DeluxePaint im Hintergrund  laufen,  und  die  es
nicht  erlauben,  zwischen den Applikationen umzuschalten oder einfach das
Fenster herunterzuziehen?? Kurzum, die ROM kümmert sich darum, für uns mit
der   HARDWARE   in   Kommunikation  zu  bleiben,  und  sie  führt  einige
vordefinierte Dinge  aus,  aber  wenn  wir  beschließen,  selbst  mit  der
Hardware  in Kontakt zu treten, können wir alles Mögliche tun, Hauptsache,
wir sind es im Stande!!!

Wir werden uns daum bemühen, Code ohne ROM-Unterstützung zu erzeugen. Aber
dann  verwenden wir nur den Prozessor? Und wie zeigt man da eine Grafik an
oder läßt Musik spielen? Mit vielen MOVE??? Jetzt kommen die  CUSTOM-CHIPS
ins Spiel!! Diese Chips heißen PAULA, AGNUS und DENISE, außerdem noch zwei
weitere, CIAA und CIAB genannt. Diese Schlaumeier  sind  dafür  zuständig,
den  Amiga  aufspielen zu lassen und die Farben auf den Schirm zu bringen.
Die meisten Register, die zu deren Kontrolle notwendig sind, befinden sich
auf  den  Adressen  zwischen $DFF000 und $DFF1FE, die anderen, die mit den
Serialund Parallelport und den Disk Drive zu tun haben, sitzen auf $BFExxx
und  $BFDxxx.  Wenn man einmal die Befehle des 68000 gelernt hat, kann man
Programme so groß wie einen Berg  schreiben,  aber  es  wird  noch  nichts
angezeigt  oder gespielt. Mit dem Prozessor muß man diese Chips ansteuern;
einer davon ist der BLITTER, der die  Aufgabe  hat,  Linien  zu  zeichnen,
Speicherstücke wie Scrolls oder Männchen auf dem Bildschirm rumzukopieren,
Flächen zu füllen (Die 3d Körper werden mit  dem  Blitter  gezeichnet  und
gefüllt;  der  Prozessor  kümmert  sich  nur  darum,  die  Koordinaten  zu
errechnen, den Rest  macht  der  Blitter).  Derjenige,  der  jedoch  alles
anzeigt und die Farben bestimmt ist der COPPER: um ein Beispiel zu machen,
$DFF180 entspricht der Farbe 0, $DFF182 der Farbe 2,  während  in  $DFF006
die  Linie  gespeichert  ist,  die  der  Elektronenstrahl  gerade  auf den
Bildschirm malt. Dieser wird 50 mal in der  Sekunde  neu  erstellt.  Diese
Register  sind  entweder  nur  zum  Lesen  oder  nur zum Schreiben: in das
Register $DFF180 kann man nur  einen  Wert  hineinschreiben,  aber  keinen
auslesen  (um  zu  erfahren,  welche Farbe gerade Farbe 0 ist...), während
$DFF006 nur lesbar ist. Um die Position des Elektronenstrahls zu verändern
gibt  es  aber  ein bestimmtes Register, genauso wie für viele andere. Mit
den Registern $BFExxx kann man die Ports kontrollieren, unter anderem  die
Maus:  z.B.  entspricht  Bit  6  der Adresse $BFE001 dem Status des linken
Mausknopfes, ob er gedrückt ist oder nicht. Man kann  dieses  Bit  mittels
Prozessors  kontrollieren  und  abwarten, bis der Mausknopf gedrückt wird,
bevor das Programm verlassen wird. Und das wird  das  erste  Beispiel  des
Kurses  sein,  das  Du analysieren kannst, indem Du Lektion1a.s ladest. Es
beinhaltet  eine  Schleife   mit   dem   68000,   die   Verwendung   eines
$DFFxxx-Registers  und  eines $BFExxx-Registers. Ladet es in einen anderen
Textbuffer, wie weiter unten erklärt.

Eine kleine Anmerkung, wie man den Assembler - in unserem Fall den  ASMONE
-verwendet:  Am  Anfang  wird man entscheiden, ob CHIP- oder FAST-Speicher
reserviert werden soll. Für  die  Beispiele  des  Kurses  sollte  CHIP-RAM
gewählt werden, jenachdem wieviel ihr habt, aber mindestens 250kB. Um eine
Directory oder ein anderes Laufwerk auszuwählen, tippe "V", z.B. um in die
Directory  der  Lektionen  zu  kommen,  tippt "V df0:Lektionen", um in die
Directory der Listings zu gelangen "V df0:Listings". Um nun ein Listing zu
lesen,  gibt  es den Befehl "R". Wählt ein Listing im Fenster aus. Mit ESC
wechselt man zwichen Editor und Kommandozeile. Drückt also  ESC,  und  ihr
könnt  das  Listing  verändern,  dann  nochmal, und ihr seit wieder in der
Kommandozeile, wo ihr das Listing ASSEMBLIEREN könnt. Dafür verwendet  den
Befehl  "A"  (wie  "Assemblieren"...), danach, um es auszuführen, "J", wie
"JSR"!! Ihr könnt  bis  zu  10  Texte  gleichzeitig  laden,  wenn  ihr  im
EDIT-Modus   seit,   könnt  ihr  mit  den  Tasten  F1...F10  zwischen  den
verschiedenen Textbuffern (Textfenstern) herumspringen. So  könnt  ihr  im
Ersten  die  Lektion1.TXT  laden,  im  zweiten  (F2)  das  erste Beispiel,
Listing1a.s, im Dritten (F3) das nächste (Listing1b.s) usw. Wenn  ihr  was
vergessen  habt,  könnt ihr mit F1 wieder zum Text springen und nachlesen.
Anmerkung: um  seitenweise  rauf  oder  runter  zu  gehen,  verwendet  die
Pfeiltasten  +  SHIFT,  für  die,  die keinen C64 hatten, es ist die große
Taste über ALT, die mit dem Pfeil. Nun erkläre  ich  euch,  was  passiert,
wenn  ihr "A" eingebt: das Listing (oder Source-Code) ist in stinknormalem
Textformat und besteht aus Schlüsselworten,  die  die  Befehle  sind  oder
anderen  Zeichen,  die  der  Assembler kennt. Um eine Gruppe von Befehlen,
eine "Variabel", den Beginn einer Tabelle zu kennzeichnen  oder  jeglichen
Anhaltspunkt im Listing zu haben, werden Namen mit Doppelpunkten vergeben,
eben dem LABEL oder ETIKETTEN. Der Name des Label kann beliebig  sein,  er
darf aber nicht gleich einem 68000er Befehl sein!! Beispiel:

WAITMOUSE:		;das  Label
	btst  #6,$bfe001  ;Linke  Taste  gedrückt?  
	bne.s WAITMOUSE   ;wenn nicht, zurück zu  WAITMOUSE  
			  ;(wiederhole  das  btst)  
	RTS	       ;Ende, steig aus

Ich  erinnere  euch daran, daß die von Befehle mindestens einer Leerstelle
vorangegangen werden müssen. Ich  habe ein  TAB  genommen,  das  gleich  8
Leerzeichen  auf  einem  Schlag  erledigt.  Achtet  auch darauf, daß KEINE
Doppelpunkte gesetzt werden, wenn ein  LABEL aufgerufen wird, NUR wenn sie
selbst  erzeugt  wird. Also, einmal editiert wird das Listing assembliert,
das geschieht durch "A"; diese Operation läßt den ASMONE den  Text  lesen,
und  der  verwandelt  ihn  in  CODE,  den  der  68000er lesen kann. Einmal
assembliert, ist der Code in  einem  Teil  des  Speichers,  der  mit  "=R"
gelesen  werden  kann,  und mit "J" springt der Prozessor auf diesen Punkt
und führt unser Programm aus. Wenn vom ASMONE ein  Fehler  gefunden  wird,
assembliert  er  nicht  zu  Ende,  bis der Fehler nicht behoben wurde. Die
Listings, die im Kurs  enthalten  sind,  funktionieren  auch  mit  anderen
Assemblern,  wie  dem DEVPAC3 oder dem MASTERSEKA, mit allen Kickstart und
mit allen Amigas, auch denen mit dem AGA-Chipset, den A1200 und dem A4000.

Wenn ihr die Funktion von Listing1a.s überprüft habt, ladet "Lektion2.TXT"
in einen anderen Textbuffer (F3, z.B). Verwendet dazu "R".

Sollte   es   an   Speicher   mangeln,   wenn  ihr  zwischen  den  Buffern
herumschaltet, dann bedeutet das, daß ihr am Anfang (bei ALLOCATE), zuviel
reserviert  habt,  und  euch  nicht genug für die RAM DISK übrig geblieben
ist. Wählt das nächste Mal weniger aus.
