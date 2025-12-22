
; Listing3b.s	; DIE ERSTE COPPERLIST

	SECTION ERSTECOP,CODE	; Dieser Befehl veranlasst das Betriebs-
							; system, den folgenden Code in die
							; Fast-Ram zu laden, wenn welche frei ist
							; sonst in Chip-Ram

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName,a1			; Adresse des Namen der zu öffnenden Library in a1
	jsr	-$198(a6)			; OpenLibrary, Routine der EXEC, die Libraris
						    ; öffnet, und als Resultat in d0 die Basisadresse
							; derselben Bibliothek liefert, ab welcher
							; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach
							; GfxBase)
	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
mouse:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088			; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts

GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder ´´, Abschluß mit ,0


GfxBase:					; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0				; ab hier werden die Offsets gemacht
	

OldCop:						; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0				; des Betriebssystemes


	SECTION GRAPHIC,DATA_C	; Dieser Befehl veranlaßt das Betriebssystem,
							; das folgende Datensegment in die CHIP-RAM
							; zu laden, obligatorisch.
							; Die Copperlist MÜSSEN in die CHIP RAM!

COPPERLIST:
	dc.w	$100,$200		; BPLCON0 - Kein Bild, nur Hintergrund
	dc.w	$180,$000		; COLOR0 SCHWARZ
	dc.w	$7f07,$FFFE		; WAIT - Warte auf Zeile $7f (127)
	dc.w	$180,$00F		; COLOR0 BLAU
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST

	end

Dieses Programm läßt unsere eigene Copperlist vom Copper  "anpeilen",  und
es kann verwendet werden, jede beliebige Copperlist anzusteuern, es eignet
sich also gut für Experimente mit dem Copper. Laßt euch nicht  entmutigen,
weil  ihr  hier  seht,  daß  Bibliotheken (Libraries) des Betriebssystemes
geöffent und geschlossen werden und ähnliches, da im ganzen Kurs  nur  die
Öffnung  der Graphics.library zum rechtrücken der alten Copperlist und ein
paar andere Dinge sehen werdet. Es reicht also, wenn ihr diese paar  Dinge
lernt.  BEMERKUNG1:  Wie  ihr  schon  bemerkt haben werdet, enthält dieses
Listing  den  Befehl  SECTION,  das  die  Funktion  hat,  die  HUNKS   des
ausführbaren  Files zu bestimmen, das ihr mit WO abspeichern werdet: Jedes
Programm, das ihr von der Shell aus starten könnt,  wie  auch  der  ASMONE
selbst, wird in die RAM gegeben, nachdem es von der Diskette oder Harddisk
gelesen wurde. Diese Aktion des Kopierens wird von den  Hunks  beeinflußt,
denn  sie  bestimmen, wohin das Programm geladen wird, ob in CHIP-RAM oder
ob es auch in Fast-RAM kommen kann. Ein File kann aus einem oder  mehreren
Hunks  bestehen,  und jeder von ihnen hat seine Eigenschaften. Man muß den
Befehl SECTION verwenden, wenn man  ein  ausführbares  Programm  schreiben
will,  das  mit  Copperlisten  oder Tönen arbeitet, da diese Art von Daten
unbedingt in dir CHIP-RAM kommen muß. Wenn man das _C nicht  spezifiziert,
dann  wird  der mit WO generierte File einen generellen Hunk besitzen, der
in jeden Typ von freiem Speicher geladen werden kann, sei es nun CHIP oder
FAST.  Viele  alte  Demos oder sogar Demos für den A1200 funktionieren auf
Amigas mit Fast-Ram nicht,  genau  weil  der  Hunk  in  jeden  beliebiegen
Speicher geladen werden kann, und das Betriebssystem dazu tendiert, zuerst
die  Fast-Ram  zu  füllen,  bevor  es  die  kostbare  Chip-Ram   angreift:
Eindeutigerweise  haben  die  Personen,  die diese alten Spiele oder Demos
geschrieben haben, nur den A500 in der  Grundversion  mit  512kB  Chip-Ram
besessen, ohne Fast, und die Programme funktionierten immer, weil sie wohl
oder übel immer im Chip landeten, das gleiche gilt für A500+ und A600, die
1MB  Chip  haben.  Aber  wenn  diese  Programme auf Computern mit FAST RAM
geladen  werden,  entstehen  zufällige  Töne  und  der  Bildschirm  spielt
verrückt,  weil  die  CUSTOM-CHIPS  nur  auf  CHIP-RAM  zugreifen  können.
Manchmal blockieren sie auch das ganze System.  Die  Syntax  des  Befehles
SECTION  ist  die  folgende:  nach  dem  Wort SECTION wird der Name dieser
Sektion geschrieben, irgend ein beliebiger Name. Danach wird angegeben, um
welchen  Typ  von  Section es sich handelt: ob CODE oder DATA, also ob sie
aus Anweisungen oder Daten besteht. Der Unterschied aber ist  nicht  recht
wichtig,  denn in der Tat nennen wir den ersten Teil dieses Listings CODE,
obwohl er auch Labels mit Texten enthält (dc.b 'graphics  library');  dann
aber  wird  das  wichtigste  entschieden:  ob  dieser Teil in CHIP geladen
werden  muß  oder  ob  auch  FAST  gut  geht.  Wenn   Chip-Ram   unbedingt
erforderlich  ist,  dann hängen wir ein _C dem DATA oder CODE an, wenn nix
steht, dann ist er in allen Speichertypen willkommen.


   SECTION FIGUREN,DATA_C    ; Sektion von Daten, die in CHIP geladen werden
   SECTION LISTENAMEN,DATA   ; Sektion von Daten, die in CHIP oder FAST kommt
   SECTION Program,CODE_C    ; Sektion von Code, der in CHIP kommen muß
   SECTION Program2,CODE     ; Sektion von Code, der CHIP oder FAST recht ist

Lasst die erste SECTION immer CODE oder CODE_C sein, fangt  natürlich  mit
Anweisungen  an,  dann könnt iht Sektionen DATA oder DATA_C anfügen, worin
keine Befehle enthalten sind. Ein Beispiel:


	SECTION Myprogram,CODE	; Kommt in CHIP oder FAST, ist egal

	move...
	move...

	SECTION COPPER,DATA_C	; NUR in CHIP assemblierbar

	dc.w	$100,$200....	; $0100,$0200, aber man kann die ersten
							; Nullen weglassen, wenn wir z.B.
							; dc.l $00000001 schreiben müßen, wird
							; es praktischer sein, dc.l 1 zu
							; schreiben, genauso kann ein dc.b $0a
							; auch als dc.b $a geschrieben werden, im
							; Speicher landet immer $0a

	SECTION MUSIC,DATA_C	; NUR in CHIP assemblierbar

	dc.b	Pavarotti.....

	SECTION FIGUREN,DATA_C	; NUR in CHIP!

	dc.l	ägyptische Pyramieden

	END

Man kann auch nur eine große SECTION CODE_C erstellen,  aber  fragmentiert
die  Grafik-  und  Sounddaten  mindestens  in  Blöcke zu 50kB, so wird das
Programm leichter in die kleinen Speicherlöcher einzuordnen sein als  wenn
es  ein  einziger Block  zu  300kB oder mehr ist. Weiteres bedenkt, daß es
Schade ist, Anweisungen in Chip-Ram zu laden, da  diese  verbraucht  wird,
und auch, weil sie in FAST-RAM erheblich schneller sind, vor allem auf den
Amigas mit 68020+ (bis zu 4 Mal  schneller..!).  Es  existieren  auch  die
Section  BSS  und BSS_C, wir werden darüber reden, wenn wir sie verwenden.
BEMERKUNG2: Ihr werdet auch die Verwendung des (PC) bemerkt haben:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf orginale COP

Dieses angehängte (PC) nach dem Namen  der  Label  ändert  nichts  an  der
FUNKTION der Anweisung, denn wenn ihr z.B. das (PC) veglasst, passiert das
gleiche.  Es  ändert  aber  die  FORM  der  Anweisung,  denn  versucht  zu
assemblieren und ein D Mouse:


	...			BTST	#$06,$00BFE001
	...			BNE.B	$xxxxxxxx
	23FA003400DFF080	MOVE.L	$xxxxxx(PC),$00DFF080
	...			MOVE.W	D0,$00DFF088
	
Seht ihr, daß das move.l OldCop(PC),$dff080 als $23fa... assembleirt wird.
Entfernt das (PC), assembliert und macht ein D Mouse:


	23F900xxxxxx00DFF080	MOVE.L	$xxxxxx,$00DFF080

Dieses Mal wird der Befehl in 10 Bytes anstatt in 8 assembliert,  und  das
$23f9...  ist klar ersichtlich. Es bedeutet MOVE.L die Adresse von OldCop,
während im Falle von move.l mit PC der Befehl mit $23fa  begann,  und  man
$34  an  Stelle der Adresse von OldCop sieht! Der Unterschied ist der, daß
wenn ohne PC gearbeitet wird, das MOVE sich auf eine DEFINITIVE,  absolute
Adresse bezieht, hingegen eine Anweisung mit PC schreibt statt der Adresse
die Distanz hin, die  zwischen  sich  selbst  und  der  geforderten  Label
besteht:  wenn  der  68000  zum Move.L OLDCOP(PC) kommt, dann errechnet er
PC+$34 und erhält somit die Adresse von OldCop, die eben $34 Bytes  weiter
vorne  liegt.  Diese  Methode  ist  schneller und erspart, wie wir gesehen
haben, auch einige Bytes, sie kann aber nur für  Label  verwendet  werden,
die  nicht  weiter  entfernt  sind als 32768 Bytes (wie beim BSR), und sie
kann nicht zwischen einer SECTION und der  anderen  verwendet  werden,  da
niemand  genau  weiß,  wohin  die Sections geladen werden, und wieweit sie
voneinander entfernt sind. Probiert z.B. zur Zeile  LEA  COPPERLIST(PC),a0
dazuzufügen, der ASMONE wird einen RELATIVE MODE ERROR melden, ohne dem PC
aber wird es keine Probleme geben. Ich  rate  euch,  das  (PC)  immer  den
Labels anzuhängen, wenn es möglich ist:


	LEA	LABEL(PC),a0
	MOVE.L	LABEL(PC),d0
	MOVE.L	LABEL1(PC),LABEL2	; nur bei der ersten Label kann
								; das (PC) stehen, bei der zweiten NIE!
	MOVE.L	#LABEL1,LABEL2		; Hier kann man kein (PC) verwenden,
								; denn beim ersten Operand hat es keinen
								; Sinn und beim zweiten darf man es nicht

Modifizierungen: Nun  könnt  ihr  jede  beliebige  Copperlist  herstellen!
Beginnt  damit,  die  ersten beiden Farben zu verändern. Ihr erinnert euch
das Format der Farben, $0RGB, in dem nur drei  Zahlen  (RGB)  zählen,  die
Stelle, wo die NULL steht, wird nicht genutzt. Jede der Stellen R, G und B
kann einen Wert zwischen 0 und 15  ($0  bis  $F)  erhalten,  und  je  nach
Mischung diese drei Grundfarben kann man alle 4096 vom Amiga darstellbaren
Farben erzeugen (16*16*16=4096). Um Schwarz zu  erhalten  braucht  es  ein
$000,  für  Weiß $FFF, ein $999 ist grau. ACHTUNG: die Farben werden nicht
gemischt wie bei Öl- oder Wasserfarben! Z.B. um Gelb herzustellen  braucht
es  ROT  + GRÜN, $dd0 in etwa, für ein Violett wird ROT und BLAU gemischt,
z.B. $d0e. Dieses  Mixsystem  ist  das  gleiche  wie  im  Preferences  der
Workbench  oder  in  der Palette der Malprogramme wie DPaint, mit den drei
Reglern R,G und B. Einmal die Tests mit  dem  Farbwechsel  del  Copperlist
hinter  euch,  könnt  ihr  versuchen,  Farbverläufe  auf den Bildschirm zu
zaubern. Dazu müßt ihr  weitere  WAITs  hinzufügen,  gefolgt  von  anderen
Werten  im  COLOR0  ($180,xxx). Solche Farbverläufe werdet ihr aus Spielen
wir SHADOW OF THE BEAST kennen, oder aus Demos mit Balken: nun  wißt  ihr,
wie  der  Hase  läuft! Tauscht mit Amiga+B+C+I diese Copperlist mit der im
Listing aus, schaut euch an, was sie tut,  und  gebt  euren  eigenen  Senf
dazu, um sicher zu gehen, daß ihr alles verstanden habt:

COPPERLIST:
	dc.w	$100,$200		; BPLCON0 - nur Hintergrund
	dc.w	$180,$000		; COLOR0 - Beginne die Cop mit SCHWARZ
	dc.w	$4907,$FFFE		; WAIT - Warte auf Zeile $49 (73)
	dc.w	$180,$001		; COLOR0 - Sehr dunkles Blau
	dc.w	$4a07,$FFFE		; WAIT - Zeile 74 ($4a)
	dc.w	$180,$002		; COLOR0 - ein bißchen helleres Blau
	dc.w	$4b07,$FFFE		; WAIT - Zeile 75 ($4b)
	dc.w	$180,$003		; COLOR0 - helleres Blau
	dc.w	$4c07,$FFFE		; WAIT - nächste Zeile
	dc.w	$180,$004		; COLOR0 - noch helleres Blau
	dc.w	$4d07,$FFFE		; WAIT - nächste Zeile
	dc.w	$180,$005		; COLOR0 - helleres Blau
	dc.w	$4e07,$FFFE		; WAIT - nächste Zeile
	dc.w	$180,$006		; COLOR0 - Blau auf 6
	dc.w	$5007,$FFFE		; WAIT - überspringe 2 Zeilen:
							; von $4e auf $50, also von 78 auf 80
	dc.w	$180,$007		; COLOR0 - Blau auf 7
	dc.w	$5207,$FFFE		; WAIT - sato 2 Zeilen
	dc.w	$180,$008		; COLOR0 - Blau auf 8
	dc.w	$5507,$FFFE		; WAIT - überspringe 3 Zeilen
	dc.w	$180,$009		; COLOR0 - Blau auf 9
	dc.w	$5807,$FFFE		; WAIT - überspringe 3 Zeilen
	dc.w	$180,$00a		; COLOR0 - Blau auf 10
	dc.w	$5b07,$FFFE		; WAIT - überspringe 3 Zeilen
	dc.w	$180,$00b		; COLOR0 - Blau auf 11
	dc.w	$5e07,$FFFE		; WAIT - überspringe 3 Zeilen
	dc.w	$180,$00c		; COLOR0 - Blau auf 12
	dc.w	$6207,$FFFE		; WAIT - überspringe 4 Zeilen
	dc.w	$180,$00d		; COLOR0 - Blau auf 13
	dc.w	$6707,$FFFE		; WAIT - überspringe 5 Zeilen
	dc.w	$180,$00e		; COLOR0 - Blau auf 14
	dc.w	$6d07,$FFFE		; WAIT - überspringe 6 Zeilen
	dc.w	$180,$00f		; COLOR0 - Blau auf 15
	dc.w	$7907,$FFFE		; WAIT - Warte Teile $79 ab
	dc.w	$180,$300		; COLOR0 - Beginne roten Balken: Rot auf 3
	dc.w	$7a07,$FFFE		; WAIT - Folgende Zeile
	dc.w	$180,$600		; COLOR0 - Rot auf 6
	dc.w	$7b07,$FFFE		; WAIT - 
	dc.w	$180,$900		; COLOR0 - Rot auf 9
	dc.w	$7c07,$FFFE		; WAIT - 
	dc.w	$180,$c00		; COLOR0 - Rot auf 12
	dc.w	$7d07,$FFFE
	dc.w	$180,$f00		; Rot auf 15 (Maximum)
	dc.w	$7e07,$FFFE
	dc.w	$180,$c00		; Rot auf 12
	dc.w	$7f07,$FFFE
	dc.w	$180,$900		; Rot auf 9
	dc.w	$8007,$FFFE
	dc.w	$180,$600		; Rot auf 6
	dc.w	$8107,$FFFE
	dc.w	$180,$300		; Rot auf 3
	dc.w	$8207,$FFFE
	dc.w	$180,$000		; Farbe SCHWARZ
	dc.w	$fd07,$FFFE		; warte auf Zeile $FD
	dc.w	$180,$00a		; Blau Helligkeit 10
	dc.w	$fe07,$FFFE		; nächste Zeile
	dc.w	$180,$00f		; Blau maximale Intensität (15)
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST

Zusammenfassend,  wenn ich auf Zeile $50 COLOR0 auf grün einstellen würde,
dann würden Zeile $50 und folgende alle  Grün  werden,  bis  COLOR0  nicht
wieder geändert wird (nach einem Wait, z.B. Wait $6007). Ein Ratschlag: Um
diese  Copperlist  zu  schreiben,  habe  ich  NATÜRLICH  NICHT  alle  dc.w
$180,$... dc.w $xx07,$FFFE geschrieben!!!! Es reichen die zwei Befehle :

	dc.w	$xx07,$FFFE		; WAIT
	dc.w	$180,$000		; COLOR0
  
Mit Amiga+B und Amiga+C ausgewählt, und dann eine Reihe davon  hergestellt
mit einigen Amiga+I:

	dc.w	$xx07,$FFFE		; WAIT
	dc.w	$180,$000		; COLOR0
	dc.w	$xx07,$FFFE		; WAIT
	dc.w	$180,$000		; COLOR0
	dc.w	$xx07,$FFFE		; WAIT
	dc.w	$180,$000		; COLOR0
	.....
	
Nun müßen  nur  mehr  die  xx  des  Wait  und  die  Werte  jedes  $180,...
ausgetauscht  werden,  und die überflüßigen Zeilen mit Amiga+B und Amiga+X
gelöscht  werden.  Bemerkung:  Dieses   Spielchen   kann   auch   zwischen
verschiedenen Buffern des ASMONE getrieben werden, wenn ihr z.B. im Buffer
F2 ein Listing mit einer Copperlist habt, die ihr gerne kopieren  möchtet,
dann  braucht  ihr  sie nur mit Amiga+B und Amiga+C markieren, und dann in
eurem Listing im anderen Textbuffer mit Amiga+I einfügen.


