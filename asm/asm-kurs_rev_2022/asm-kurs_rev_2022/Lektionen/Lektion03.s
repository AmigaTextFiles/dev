
ASSEMBLERKURS - LEKTION 3

Nun fahren wir mit der Praxis fort, ich rate euch vorher  aber,  68000.TXT
in  einen  Textbuffer  zu  laden,  es  ist  eine  Art  Zusammenfassung von
Lektion2. Diese wird euch nützlich sein, wenn  ihr  eine  Adressierungsart
vergessen habt oder mit einem Befehl nichts mehr anzufangen wißt, da diese
Lektion eine gewisse Vertrautheit mit ihnen voraussetzt.  In  diesem  Text
sind alle Adressierungen erklärt, auch jene, die nur sehr selten verwendet
werden, deswegen lest ihn aber sorgt euch nicht,  wenn  ihr  einige  Dinge
nicht versteht, wie z.B. die Adressierung mit INDEX, denn in Lektion3 wird
sie noch nicht verwendet!

In  diesem  Kapitel  beginnen  wir  damit,  etwas   auf   dem   Bildschirm
darzustellen: um  das  zu erreichen, müssen wir eine COPPERLIST schreiben,
das ist ein Programm für  den  COPPER-Chip,  dem  Typen,  der  die  Grafik
steuert, wir haben ihn bereits verwendet, um die Bildschirmfarbe zu ändern
($dff180 ist ein Register des Coppers, das COLOR0 heißt). Bis  jetzt  aber
haben  wir die Register nur direkt mittels Prozessor angesprochen, und wie
ihr beim Testen der  Listings  bemerkt  haben  werdet,  sind  nur    kurze
"Lichtblitze"  in  der  Farbe aufgetreten, die wir hineinschrieben, sofort
aber ersetzte der Copper des Betriebssystems  oder  ASMONE  unsere  eigene
Farbe.  Nur in einer  Schleife, bei der  dauernd eine Zahl in das Register
geschieben wurde, schafften wir es, den ganzen Bildschirm zu färben, aber,
kaum  aus  dem Programm ausgestiegen, kehrt erbarmungslos der alte Zustand
zurück. Das  ist  darauf  zurückzuführen,  daß  alles,  was  wir  auf  dem
Bildschirm  sehen  -  Fenster,  Schriften  und der Rest - ist das Ergebnis
einer  COPPERLIST,  genauer  einer  SYSTEM-COPPERLIST.  Diese  ist  nichts
anderes als eine Art:

	MOVE.W	#$123,dff180	; COLOR0 - Beschreibe Farbe 0
	MOVE.W	#$456,dff182	; COLOR1 - Beschreibe Farbe 1
	etc....

Diese wird dauernd ausgeführt, und hier liegt auch  die  Erklärung,  warum
die System-Farbe sofort zurückkehrt, wenn wir nur mit dem Prozessor in die
Register schreiben: weil die Copperlist jede 1/50 Sekunde alle Farben  neu
definiert!!! Nun werdet ihr ahnen, daß es schier unmöglich sein wird, eine
Figur in Ruhe und Frieden auf den Bildschirm zu bringen, wenn man  dauernd
mit  der Copperlist des Betriebssystemes zu kämpfen hat, die dauernd alles
umdefiniert. Wir müßten unsere eigene Copperlist erstellen und sie mit der
des   Systemes   ersetzen...  NICHTS  LEICHTER  ALS  DAS!  Wie  ich  schon
prophezeiht habe, ist die Copperlist nichts anderes als eine Schlange  von
MOVE,   die   Werte   in   die   Register   des  Copper  gibt,   also  den
$dffxxx-Registern. Diese Move aber werden nicht vom Prozessor, sondern vom
Copper  selbst  gemacht,  der  unabhängig  vom Prozessor läuft und den für
andere Sachen freihält... das ist einer der Gründe, wieso sie auf PC nicht
LIONHEART oder PROJECT X des Amiga haben. Wir müssen ihm also wirklich ein
Listing schreiben, wie wir es vom  68000er  her  kennen,  und  danach  den
Copper  darüber  informieren, wo es sich befindet und es ihn an Stelle der
Workbench-Copperlist ausführen lassen. Der Copper besitzt nur  3  Befehle,
wovon in der Praxis nur zwei verwendet werden: diese sind ein MOVE und ein
WAIT; derjenige, den niemand verwendet, ist das SKIP,  deswegen  behandeln
wir es nur, wenn wir ein Listing damit finden.

Das MOVE ist kinderleicht: könnt ihr euch an das erinnern ? :

	MOVE.W	#$123,dff180	; Gib die Farbe RGB in COLOR0

Gut, in Copperlist schaut das so aus:

	dc.w	$180,$123	; die Zahlen werden direkt mit dc.w
						; in den Speicher gegeben, aber wir 
						; müssen ja nur zwei Befehle lernen!!

Das heißt, man muß zuerst die Adresse angeben, in die der Wert kommt (ohne
dem $dff, so wie wir es schon gesehen haben wenn wir in a0 $dff180 gegeben
haben: $180(a0). Genauso haben  die  Entwickler  daran  gedacht,  uns  das
dauernde  $dff zu ersparen, und so reicht es, wenn wir $180 oder $182 oder
was auch immer, schreiben. Hauptsache, wir beschreiben nur Copperregister,
denn  nur  Register  des  COPPER  können  mit  der  COPPERLIST angesteuert
werden!! Weiters darf nur auf  GERADE  Adressen  zugegriffen  werden,  wie
$180,  $182  ...,  NIE  $181,  $179 etc, weiters können nur WORD verwendet
werden. Wie ihr seht, wird  die  COPPERLIST  nicht  auf  die  gleiche  Art
assembliert  wie  die  Instruktionen des 68000, bei denen aus Befehlen wie
RTS, MOVE... $4e75 usw. wird,  sondern  es müssen  die  BYTES  so  in  den
Speicher gelegt werden, wie sie der Coprozessor Copper lesen kann. Deshalb
verwenden wir das DC, um Byte für Byte die Befehle hineinzuschreiben, aber
es ist sehr einfach! Z.B. um die ersten vier Farben zu definieren:

COPPERLIST:
	dc.w	$180,$000	; COLOR0 = SCHWARZ
	dc.w	$182,$f00	; COLOR1 = ROT
	dc.w	$184,$0f0	; COLOR2 = GRÜN
	dc.w	$186,$00f	; COLOR3 = BLAU

Erinnert ihr euchm wie das Farbformat aussieht? RGB = RED ,  GREEN,  BLUE.
Um  einen  Kommentar  über  die  $dffxxx - Register zu erhalten, könnt ihr
jederzeit "=C" schreiben, oder, speziell Z.B. für $dff180  "=C  180",  und
ihr  werdet  eine  Zusammenfassung in englisch bekommen. Probiert z.B. "=C
006" und ihr werdet Namen und Erklärung über dieses Register bekommen, das
ihr  verwendet  habt,  um  den  Bildschirm zum Blinken zu bringen. Um alle
Register zu sehen, "=C".

Das WAIT hingegen dient dazu, eine bestimmte Zeile  abzuwarten,  wenn  man
z.B.  die  Hintergrundfarbe  (COLOR0)  bis  zur  Hälfte  des  Bildschirmes
schwarz, und von da ab blau machen möchte, dann sieht das so aus:

	dc.w	$180,0		; COLOR0 Schwarz

gefolgt von einem WAIT, das die Mitte des Bildschirmes abwartet, und dann

	dc.w	$180,$00F	; COLOR0 Blau

Mit dieser Strategie kann man die ganze Palette (die Farbliste)  in  jeder
Bildschrirmzeile  verändern, von so was können die PC mit VGA nur träumen,
denn in der Tat haben die meisten Amiga-Spiele nur Screens mit 32  Farben,
aber durch ändern der Farbpalette hie und da, z.B. wenn das Spielfeld nach
unten scrollt, kann man mehr Farben erzeugen als eine VGA mit 256  Farben.
Vor  allem  wenn  man  in  Betrachtung zieht, daß man einen Farbverlauf im
Hintergrund erzeugen kann, indem  man  in jeder  Bildschirmzeile die Farbe
wechselt,  und  das wird unser erstes Programm in dieser Lektion sein. Der
WAIT-Befehl präsentiert sich so:

	dc.w	$1007,$FFFE	; WAIT Koordinate Y = $10, X = $07

Dieser Befehl bedeutet: WARTE DIE VERTIKALE ZEILE $10 AB, SPALTE 7   (also
der  siebte  Punkt  von  links,  diese "Punkte" werden Pixel genannt). Das
$FFFE steht für WAIT, es muß immer gesetzt werden, während das erste  Byte
die vertikale Zeile (y) ist, die es abzuwarten gilt, und  das zweite  Byte
die Horizontale (x). Der Bildschirm besteht aus vielen kleinen Punkten,die
alle  aneinander  gereiht sind, wie ein Blatt Papier mit kleinen Kästchen,
Millimeterpapier  in  etwa.  Um  den  Punkt  (Pixel)  an   Position   16,7
anzupeilen,  also der 16. Punkt vom oberen Rand und der 7. vom linken Rand
nach rechts, werden wir $1007 ($10  =  16!)  schreiben.  Wie  bei  Schiffe
versenken!  Normalerweise gibt man  nur  den  horizontalen  Punkt an ihrem
Anfang an, der ist $07 statt $01, weil der Rest über dem linken  Rand  des
Monitors  liegt.  Der  WAIT-Befehl  wird auch dazu verwendet, das Ende der
Copperlist zu kennzeichnen. Am Ende der COP setzt man ein

	dc.w	$FFFF,$FFFE	; Ende Copperlist

Dies  interpretiert  der  Copper  per  Definition  als  Ende, auch weil es
bedeuten würde, eine Linie abzuwarten, die es nicht gibt!  Die  Copperlist
startet  dann  von  vorne. Es hat sich auch rumgesprochen, daß bei einigen
älteren Amigamodellen zwei abschließende Instruktionen nötig  seien,  aber
es  scheint  eine  Art  von Massenpsychose zu sein, da niemand jemals zwei
verwendet hat und alles immer funktionierte.

Um unsere Copperlist zu schreiben, die am Anfang  noch  ohne  Bilder  sein
wird,   lediglich  mit  einigen  Farbverläufen,  müssen wir  die  BITPLANE
abschalten, also die  aus  Bits  bestehenden  "Ebenen",  die  übereinander
gelegt die  Bilder erzeugen. Um das zu erreichen, setzen wir am Anfang ein
DC.W $100,$200 ein, wir geben also den Wert $200 ins Register $dff100, das
das Kontrollregister der Bitplane ist.

NUN  SIND WIR IMSTANDE, EINE VOLLSTÄNDIGE COPPERLIST ZU SCHREIBEN, DIE BIS
ZUR MITTE DES BILDSCHIRMS GEHT UND DANN DIE FARBE WECHSELT!

Copperlist:
	dc.w	$100,$200	; BPLCON0 Keine Bilder, nur Hintergrund
	dc.w	$180,0		; COLOR0 schwarz (Hintergrund)
	dc.w	$7f07,$FFFE	; WAIT - warte Zeile $7f ab (127)
	dc.w	$180,$00f	; COLOR0 blau
	dc.w	$FFFF,$FFFE	; ENDE DER COPPERLIST

Wenn man bedenkt, daß  ihr  die  Funktionstüchtigkeit  eurer  Copperlisten
überprüfen wollt, hier eine TABELLE ZUM NACHSCHLAGEN DER FARBEN:

Der Amiga besitzt 32 Register  für  dementsprechend  viele    verschiedene
Farben:

	$dff180	; COLOR0 (Hintergrund)
	$dff182	; COLOR1
	$dff184	; COLOR2
	$dff186	; COLOR3
	...
	$dff1be	; COLOR31

In jedes dieser Register kann eine der 4096 möglichen Farben  kommen,  die
durch  Mischen  der  drei  Grundfarben  Rot, Grün und Blau zustande kommen
können. Jede dieser Farben kann eine Intensität von 0 bis 15  haben,  also
16  "Helligkeitsstufen".  Nachgerechnet  ergibt  sich  aus allen möglichen
Kombinationen, 16*16*16=4096, eben die Anzahl der darstellbaren Farben (16
Farbtöne  Rot,  16  von Grün und 16 von Blau). Den Wert der Farbe kann man
entweder mit dem Prozessor oder mit dem Copper eingeben:

	move.w	#$000,$dff180	; Farbe SCHWARZ in COLOR0

	dc.w	$180,$FFF		; Farbe WEIß in COLOR0

In diesem Beispiel haben wir die zwei Extremwerte  gesehen:  $FFF,  gleich
Weiß,  und $000, Schwarz. Um die Farbe zu wählen muß man bedenken, daß das
WORD der Farbe so aufgebaut ist:

	dc.w	$0RGB

	wobei die vierte 0 (ganz links) nicht verwendet wird, und es gilt:

	R = ROT -Komponente der Farbe (RED)
	G = GRÜN-Komponente der Farbe (GREEN)
	B = BLAU-Komponente der Farbe (BLUE)

Die  Bit  von 15  bis  12 werden nicht verwendet, die	Bit  von  11 bis 8
stellen den Rotanteil dar, Bit 7 bis Bit 4 den Grünanteil und  Bit  4  bis
Bit 0 den Blauanteil.

Jede  RGB-Farbe kann einen Wert von 0 bis 15 haben, also von $0 bis $f  in
Hexadezimal, es ist also leicht eine Farbe auszuwählen:

	$FFF = Weiß
	$D00 = Ziegelrot
	$F00 = Rot
	$F80 = Rot-Orange
	$F90 = Orange
	$fb0 = Goldgelb
	$fd0 = Cadmiumgelb
	$FF0 = Zitrone
	$8e0 = Hellgrün
	$0f0 = Grün
	$2c0 = Dunkelgrün
	$0b1 = Baumgrün
	$0db = Wasser
	$1fb = Wasser Hell
	$6fe = Himmelblau
	$6ce = Helles Blau
	$00f = Blau
	$61f = Brillantes Blau
	$06d = Dunkelblau
	$c1f = Violett
	$fac = Rosa
	$db9 = Beige
	$c80 = Braun
	$a87 = Dunkelbraun
	$999 = Mittelgrau
	$000 = Schwarz

Nun ist das einzige Problem, den Copper dazu zu zwingen, unsere Copperlist
auszuführen und die der Workbench bei Seite zu lassen. Aber da gibt´s noch
ein anderes Problem: wenn wir unsere eigene ausführen lassen, wie schaffen
wir es dann, den Orginalzustand wiederherzustellen? Antwort: Man  muß  auf
ein  Zettelchen  aufschreiben, wo sie war!!! Oder anders: Wir schreiben in
ein bestimmtes Longword die Adresse, an der sie zu finden ist. Wir  werden
dieses  Longword  OLDCOP  nennen,  also ALTE COPPERLIST, die des Systemes.
Aber wen müssen wir fragen, um  zu  wissen,  wo sich  die  Copperlist  des
Systemes  befindet?  Das  Betriebssystem natürlich!!! Um es das zu fragen,
müssen wir eine Routine aus dem CHIP des Kickstart ausführen!  Um  das  zu
tun, müssen  wir  immer  als  Bezug  die Adresse nehmen, die in Adresse $4
steht. Diese wird vom Kickstart geschrieben und enthält  die  Adresse,  ab
der wir unsere AdressierungsDistanzen (Offsets)  machen müssen. Diese sind
vordefiniert, wir werden später darüber plaudern. Um das Long der  Adresse
$4 aufzusammeln, reicht ein:

	MOVE.L	$4,a6	; In a6 haben wir nun die ExecBase

Oder besser:

	MOVE.L	4.w,a6  ; 4 ist eine kleine Zahl, deswegen kann 4.w
					; geschrieben werden, was Platz spart.
					; Es wird also $0004 statt $00000004 geschrieben,
					; bei dem die ersten vier Nullen nicht gebraucht
					; werden. VERSCHOBEN WIRD ABER IMMER EIN LONGWORD!
					; Also das Long, das in Adresse 4, 5, 6 und 7
					; enthalten ist.

Ist einmal die Adresse, die in $4 enthalten ist, in a6 kopiert, können wir
darangehen,  die Routinen des Kickis auszuführen, indem wir JSR verwenden,
kombiniert mit der richtigen Distanz (Offset),  denn  es  existieren  ganz
exakte  Distanzen,  die gewissen Routinen entsprechen. Nun wissen wir, daß
z.B. mit einem JSR -$78(a6) das Multitasking abgeschalten wird!!! Es  wird
also  nur  unser  Programm  ausgeführt,  nix anderes! Sofort testen! Ladet
Listing3a.s in einen Buffer und startet es. Aber  die  Exec  kümmert  sich
nicht  um  alles: der Kickstart, 256kB lang, wenn es sich um die Versionen
1.2 oder 1.3 handelt, oder 512k  bei  V2.0  und  V3.0,  ist  in  Libraries
aufgeteilt,  eine  Art  "Sammlung" von Routinen, die schon fertig sind und
aufgerufen werden können. Und da jeder Kickstart anders  ist,  ja  richtig
hardwaremäßig,  im Sinne daß die Routine, die das Multitasking abschaltet,
im Kick 1.3 z.B. auf  Adresse  $fc1000  liegen  könnte,  während  sie  bei
anderen  Versionen  irgendwo  anders  im  Speicher  sein könnte, haben die
lieben Erbauer des Amiga  eine  ihrer  wunderbaren  Geistesblitze  gehabt:
"WARUM  GEBEN  WIR  IN SPEICHERZELLE 4 NICHT EINE ADRESSE, VON DER AUS MAN
IMMER DIE GLEICHEN ROUTINEN AUSFÜHREN KANN, WENN MAN MIT EINEM  JSR  EINEN
BESTIMMTEN  OFFSET ANSPRINGT?" (P.S. JSR ist das gleiche wie BSR, nur kann
ein JSR Routinen im gesamten Speicher  anspringen,  während  das  BSR  nur
innherhalb 32768 Bytes nach vorne oder hinten operieren kann).

Und  das  haben  sie  getan!  Um  z.B.  das Disable, also das Multitasking
killen, auszuführen, wird auf jedem Kickstart folgendes getan:

	move.l	4.w,a6			; Adresse der Exec in a6
	jsr	-$78(a6)			; Disable - blockiert Multitasking
	bsr.w	MeinProgramm
	jsr	-$7e(a6)			; Enable - schaltet Multitasking wieder ein

In jedem Kickstart liegt die Routine auf einer anderen Adresse,  aber  mit
dieser Methode sind wir sicher, daß wir immer diese ausführen. Man muß nur
alle Offsets der verschiedenen Routinen kennen, und das Spiel ist gemacht.
Uns   interessiert   aber   nur,   die   Copperlist  des  Betriebssystemes
abzuspeichern, und um das zu schaffen, müssen wir und an eine Routine  des
Kickstart wenden, die graphics.library heißt. Es ist die, die sich mit der
Graphic befaßt, aber nur unter dem Betriebssystem, das sei klar, nicht auf
Hardwareebene.  Um  auf  diese  Bibliothek  (Library) zugreifen zu können,
müssen wir sie zuerst öffnen:

	move.l  4.w,a6		; ExecBase in a6 schreiben
	lea	GfxName,a1		; Adresse des Namens der Library, die
						; es zu öffnen gilt, in a1
	JSR	-$198(a6)		; OpenLibrary, Routine der Exec, die
						; eine Bibliothek öffnet, und als Resultat
						; die Basisadresse dieser zurückliefert 
						; (in d0), ab
						; welcher wir die Offsets ansetzen müssen.
	move.l  d0,GfxBase	; Speichere die Basisadresse der Gfx in
	...					; GfxBase
	...

GfxBase:
	dc.b	"graphics.library",0,0	; BEMERKUNG: Um Charakter, also
						; Buchstaben, in den Speicher zu
						; geben, verwenden wir immer das
						; dc.b und setzen sie unter ""oder´´
GfxBase:
	dc.l	0

In diesem Fall haben wir die Routine der Exec verwendet, die  Bibliotheken
öffnet,  die  "OpenLibrary". Sie verlangt, daß in a1 die Adresse steht, an
der der Text mit dem Name der zu öffnenden  Library  zu  finden  ist.  Wir
hätten  z.B. auch die "dos.library" öffnen können, um mit Files umzugehen,
oder "intuition.library" für die Fenster, Screens etc. Einmal  ausgeführt,
liefert  OpenLibrary  in d0 die Basisadresse der gefragten Bibliothek,  um
uns zu verstehen, eine Adresse wie GfxBase, ab der wir dann mit JSR unsere
Offsets  machen, um die verschiedensten Routinen anzuspringen, die mit der
Grafik zu tun haben. Außer den JSR wissen wir auch noch, daß  die  Adresse
der  aktuellen  COPPERLIST  des  Systemes auf $26 nach GfxBase liegt, also
fahren wir mit unserem Programm fort, indem wir diese Adresse in ein Label
(OLDCOP) abspeichern:

	move.l  4.w,a6		; ExecBase in a6 schreiben
	lea	GfxName,a1		; Adresse des Namens der Library, die
						; es zu öffnen gilt, in a1
	JSR	-$198(a6)		; OpenLibrary, Routine der Exec, die
						; eine Bibliothek öffnet, und als Resultat
						; die Basisadresse dieser in d0 zurückliefert,
						; ab welcher wir die Offsets ansetzen müssen.
	move.l  d0,GfxBase	; Speichere die Basisadresse der Gfx in
						; GfxBase

	move.l  d0,a6
	move.l  $26(a6),OldCop  ; Nun speichern wir die Adresse der zur Zeit
						; aktuellen System-Copper in OLDCOP ab
	....

GfxName:
	dc.b	"graphics.library",0,0	; BEMERKUNG: Um Charakter, also
						; Buchstaben, in den Speicher zu
						; geben, verwenden wir immer das
						; dc.b und setzen sie unter ""oder´´
GfxBase:
	dc.l	0

OldCop:
	dc.l	0 

Nun können wir unsere eigene Copperlist ansteuern, ein WaitMouse dazufügen
und dann wieder den alten Zustand herstellen; mit ansteuern meine ich, daß
wir die Adresse unserer Copperlist ins Register COP1LC geben, das ist  das
$dff080, das der Zeiger auf die Copperlist ist,  d.h. der Copper führt die
Copperlist aus, deren Adresse sich im  Register  $dff080  befindet.  Also,
einmal  die  Adresse  unserer  Copperlist in  $dff080, müssen wir sie noch
"starten", indem wir ins Register $dff088 (COPJMP1) irgend  einen  Nonsens
schreiben, egal, ob wir hineinschreiben oder was rauslesen, denn da es ein
sog.  STROBE-Register  ist,  reicht  irgend  eine  Änderung,  um   es   zu
aktivieren.  Die  Strobe-Register  sind  wie eine Art Knopf, der grade mal
berührt werden muß, um ausgelöst zu werden.  Verwendet  aber  nicht  CLR.W
$dff088, das gibt komischerweise Probleme. Nun wird unsere Liste bei jedem
Fotogramm ausgeführt, solange, bis in $dff080  nicht  wieder  eine  andere
kommt  (oder  besser, deren Adresse...!). Ein Problem ist, daß $dff080 ein
NUR-SCHREIBE-REGISTER ist, probiert ein "=c 080"  und  ihr  werdet  das  W
bemerken  (WRITE).  Um  die alte Copperlist - die, die der Asmone oder die
Workbench verwendet - wieder an  ihren  Platz  zu  setzen, müssen  wir das
Betriebssystem  fragen, welche Adresse in $dff080 enthalten ist, da dieses
Register selbst ja nicht ausgelesen werden kann. Und dafür  verwenden  wir
die  Routine  des  Kickstart.  Wenn wir dann diese Adresse erhalten haben,
speichern wir sie in ein LONGWORD unseres Programmes, danach  starten  wir
unsere  einene  Copperlist,  und  am  Ende  des  Programmes  geben wir die
gespeicherte Adresse wieder in COP1LC ($dff080).


	move.l	4.w,a6			; ExecBase in a6 schreiben
	JSR	-78(a6)				; Disable - schaltet Multitasking aus
	lea	GfxName,a1			; Adresse des Namens der Library, die
							; es zu öffnen gilt, in a1
	JSR	-$198(a6)			; OpenLibrary, Routine der Exec, die
							; eine Bibliothek öffnet, und als Resultat
							; die Basisadresse dieser in d0 zurückliefert,
							; ab welcher wir die Offsets ansetzen müssen.
	move.l	d0,GfxBase		; Speichere die Basisadresse der Gfx in
							; GfxBase

	move.l	d0,a6
	move.l	$26(a6),OldCop	; Nun speichern wir die Adresse der zur Zeit
							; aktuellen System-Copper in OLDCOP ab

	move.l	#COPPERLIST,$dff080	; COP1LC-Wir zeigen auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Wir starten unsere COP,
							; indem wir etwas hineinschreiben,
							; z.B. d0
mouse:
	btst	#6,$bfe001
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; COP1LC - Wir zeigen auf die alte
							; System-Copperlist
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - schaltet Multitasking wieder ein
	move.l	GfxBase(PC),a1	; Base der zu schließenden Bibliothek
							; (Bibliotheken werden IMMER geschloßen!!!)
	jsr	-$19e(a6)			; Closelibrary - Schließt die graphics lib
	rts


GfxName:
	dc.b	"graphics.library",0,0	; BEMERKUNG: Um Charakter, also
							; Buchstaben, in den Speicher zu
							; geben, verwenden wir immer das
							; dc.b und setzen sie unter ""oder´´
GfxBase:
	dc.l	0

OldCop:
	dc.l	0	  

COPPERLIST:
	dc.w	$100,$200		; BPLCON0 - Keine Bilder, nur Hintergrund
	dc.w	$180,0			; COLOR0 SCHWARZ
	dc.w	$7f07,$FFFE		; WAIT - Warte auf Zeile $7f (127)
	dc.w	$180,$00F		; COLOR0 BLAU
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST

Ihr  werdet  dieses Beispiel mit Vorschlägen und Änderungen in Listing3b.s
finden. Holt es in den Buffer mit F2 oder einem x-beliebigen  anderen  und
bestaunt  das  erste  Programm  aus  dem  Kurs, das den Chips des Amiga so
richtig "Power unterm Hintern" macht.

Habt ihr eure Experimente mit der Copperlist gemacht? Gut,  nun  versuchen
wir,  einige  bewegte Effekte zu erzeugen. Bevor wir aber anfangen muß ich
euch mitteilen, daß um irgendeine  Bewegung zu machen, diese Routinen  mit
dem   Elektronenstrahl,   der   das   Bild   auf   dem  Monitor  zeichnet,
synchronisiert werden müssen. Für die,  die  es  noch  nicht  wissen,  der
Bildschirm wird 50 Mal pro Sekunde neu gezeichnet, und die Bewegungen, die
uns flüssig erscheinen,z.B. die der besser programmierten Spiele, sind auf
diese  fünfzigstel  Sekunde angepaßt. Wir haben das Register $dff006 schon
verwendet, das bekanntlich dauernd seinen Inhalt ändert. Aus gutem  Grund,
es  beinhaltet ja die Position des Elektronenstrahles auf dem Monitor, und
der düst mit 50 Seiten pro Sekunde durch die Gegend... Er startet  bei  0,
also dem höchten Teil des Monitors, ganz oben, und durchläuft ihn bis ganz
unten. Wenn wir nun eine Routine schreiben, die Bewegungen auf den  Schirm
bringt,  ohne  sie     zeitlich anzupassen, ohne Timing, dann wird sie mit
der Geschwindigkeit des Prozessors laufen, also viel zu schnell  um  etwas
zu sehen. Um eine gewisse Zeile des Bildschirms abzuwarten  müssen wir nur
das erste Byte von $dff006 auslesen. In ihm  steht  die  gerade  erreichte
Zeile, also die vertikale Position (gleich dem WAIT des COPPER):

WaitZeile:
	CMPI.B	#$f0,$dff006	; VHPOSR - Sind wir auf Zeile $f0 ? (240)
	bne.s	WaitZeile		; wenn nicht, kontrolliere nochmal
	...

Dieser Zyklus wartet die Zeile 240 ab, und erst dann fährt er mit den
folgenden Befehlen fort, wie etwa die Routine, die auf einen Mausdruck
wartet. Fügen wir auch diesen Teil ein:

mouse:
	CMPI.B	#$f0,$dff006	; VHPOSR - Sind wir auf Zeile $f0 ? (240)
	bne.s	mouse			; wenn nicht, kontrolliere nochmal

	BSR.s	RoutineMitTiming ; Diese Routine wird nur einmal
							 ; pro Fotogramm ausgeführt
	
	bsr.s	MuoviCopper		; Die erste Bewegung am Bildschirm!!!!!
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:
	rts  

Jetzt haben wir eine Routine, die 1 Mal  pro  FRAME  -  oder  Fotogramm  -
ausgeführt  wird,  also  1 Mal alle 50stel Sekunden, und um genau zu sein,
wird sie jedesmal ausgeführt, wenn wir bei Zeile 240 angekommen sind,  und
dann  wird  sie  ruhen,  bis  wir erneut Zeile 240 erreichen, dem nächstem
FRAME.

Bemerkung: Die Bilder werden mit der RASTER-Technik  gezeichnet,  die  mit
einem  "Elektronenstrahl"  links  oben  beginnt, nach rechts geht, bis zum
Ende der Zeile, dann wieder ganz links, Zeile 2, usw. bis er am  Ende  des
Bildschirms  angekommen ist. Es ist mit dem Lesen vergleichbar: jede Zeile
von links nach rechts, angefangen bei der ersten ganz oben bis runter  zur
letzten  auf  der Seite, und DANN startet man wieder von vorne, so, als ob
wir vergessen hätten, Seite zu wechseln. Denn der Monitor ist ja auch  nur
einer, und er muß nur auf dem einen Schirm schreiben, der Elektronenstrahl
malt ja nicht auf die Wand.

Ladet das Beispiel Listing3c.s in einen anderen Textbuffer und probiert es
aus.  Dieses bewegt ein WAIT nach unten und somit die folgende Farbe, wenn
ihr die Maustaste drückt. Linke Taste zum Aussteigen.

Listing3c.s verstanden?  Dann  lassen  wir  es  ein  bißchen   schwieriger
werden!  Ladet Listing3c2.s in einen Buffer und studiert es, ich habe eine
Zeilenkontrolle eingefügt, um den Scroll zu stoppen.

Alles klar in Listing3c2.s?? Gut, dann geht´s weiter  mit  der  Praxis  in
Listing3c3.s, in der ein Balken mit 10 WAIT verschoben wird, anstatt   nur
ein Wait alleine. Immer schwieriger!!!

Lebt ihr noch nach  Listing3c3.s?  Dann  massakriert  euer  Hirn  mit  dem
nächsten Listing, dem Listing3c4.s, in der wir von 10 Label BALKEN auf ein
einziges umsteigen, und die Adressierungsdistanz verwenden.

Nun, es war ja nicht recht schwer, oder? Das Schwierige  kommt  jetzt  mit
Listing3d.s, in dem der Balken rauf und runter geht, und wir werden   auch
die Geschwindigkeit ändern.

Habt ihr Listing3d.s verstanden? Ja? Glaub ich nicht! Euch kommt es nur so
vor, ihr hättet es verstanden...  ich würde noch mal nachsehen, bevor  ich
weitergehen würde...na, noch mal angeschaut?  Tja...dann  holt  euch  eine
Variante zum Thema rein mit Listing3d2.s.

Nun  seid  ihr  bereit,  Listing3e.s  in Angriff zu nehmen, in der erklärt
wird, wie man eine RASTERBAR herzaubert, also ein  wiederholendes  Fließen
der Farben.

Ein  anderer Spezialfall: Wie erreiche ich die PAL-Zone (nach $FF) mit dem
Wait des Coppers. Soviel in Listing3f.s.

Um Lektion3.TXT abzuschließen, schaut euch Listing3g.s und Listing3h.s an,
bei  dem  ein  Verlauf  von  links  nach  rechts statt von oben nach unten
erzielt wird. Danach seid ihr  bereit,  Lektion4.TXT  durchzuackern.  Dort
wird  die  Verwaltung  von  farbigen Bildern und die möglichen Effekte auf
ihnen behandelt!

Bemerkung: Die Beispiele  4x.s  der  Lektion4.TXT  befinden  sich  in  der
Directory  Listings2,  darum müßt ihr ein "V df0:Listings2" tippen, um die
Bilder in dieser Directory laden zu können. Danach ladet  Lektion4.TXT  in
diesen oder einen anderen Buffer (mit "r").

*  Kompliment,  daß  ihr  bis  hier  her  gekommen  seid!  Das Größte  ist
geschafft! Nun werden wir mit Leichtigkeit  weitergehen,  da  wir  in  die
Logik der Assemblerprogrammierung eingestiegen sind!
