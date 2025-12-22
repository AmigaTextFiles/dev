              _
   _|_        / \.ММ/\_/\М._
    |        /   Џ\/     \/ \                   _
    |       Y _____Џ\/Џ_____ Y           ___   /Џ\   ___              .--.
.---------  |/ЏЏЏЏЏ\  /ЏЏЏЏЏ\|  -----  .YЏЏЏYОY   Y:YЏЏЏY. ___  ------.\/.--.
|        Ќ  f   |   YY   |   Y      Ќ.ООl___jОl___jОl___jОYЏЏЏY     Ќ  \/ Ќ |
|.          l  -М-  jl  -М-  j     /Џ/\Мf _ YМf _ YМf _ YОl___j             |
|Ё          |\  | _/ЏЏ\_ |  /|    ( <  >l/ \jМl/ \jМl/ \j./__ /            .|
|:          j \__/ /ЏЏ\ \__/ l     \_\/ `\ /МММ\ /МММ\ /Мl/ /j             :|
|.         (   ЏЏ /    \ ЏЏ   )           V `МММVМММММVМ' \/               .|
|           \__   \_/\_/   __/               .:::::::'                      |
|.            Џ\          /Џ    ЋЋ=--   DISK 2 - LESSON 8    --=ЛЛ         .|
|   /\          Y : .  . Y                З .  .  .                      tS |
`--'/\`-------  (_| | :| )  ----------           З  .       ----------------'
   `--'         \\j_j_ll//              .  З     .
                 ~:Џ:Џ::~                            .

ASSEMBLERKURS - LEKTION 8 

Autor: Fabio Ciucci 


In dieser Lektion wird das Wissen über den 68000 vertieft und es wird
einige Klarstellungen zu verschiedenen bereits behandelten Themen geben.
Eine Anmerkung für diejenigen, die den Kurs auf die Festplatte installieren: 
Ich schlage vor, dass Sie einige Verzeichnise mit den Namen der zugehörigen 
Kursdisketten erstellen:

Assembler1
Assembler2
Assembler3
...

Wohin die gesamten Disketten kopiert werden sollen. Dann fügen sie zu
s:startup-sequence hinzu:

assign Assembler1: dh0:Assembler1
assign Assembler2: dh0:Assembler2
assign Assembler3: dh0:Assembler3
...

(dh0: ist nur ein Beispiel ... Sie müssen natürlich das richtige Laufwerk
bestimmen!). Dann würde ich Ihnen raten, alle Quellen und Daten, die sich im
Powerpacker-Format befinden, zu entpacken. Kopieren Sie dazu die c: PP-Datei
auf die Festplatte und prüfen Sie, ob Sie in LIBS die PowerPacker.library
haben: andernfalls kopieren Sie sie von der Diskette. Führen Sie nun die "PP"
von der shell aus, um das automatische Entpacken zu aktivieren. Erstellen Sie
sich jetzt ein "temporäres" Verzeichnis, z.B. nennen Sie es "Puffer". Wenn Sie
ALLE Dateien aus dem Verzeichnis Assembler1 ins Puffer-Verzeichnis kopieren
werden alle Dateien tatsächlich entpackt und etwas "größer".
Jetzt können Sie sie alle nach Assembler1 kopieren (vielleicht mit einem MOVE
des DiskMasters oder des DirOpus, der sie auch aus dem Puffer entfernt.)
Auf die gleiche Weise können Sie alle Assembler2 in den Puffer kopieren und
dann in Assembler2 kopieren. Um einen schnellen Vorgang zu erhalten, können sie
PP laden, bevor Sie die Dateien von der Diskette in das Verzeichnis auf der
Festplatte kopieren, so dass die Dateien in AssemblerX entpackt werden.

Die 3 assign-Befehle werden stattdessen dazu verwendet, dass statt nach der
Festplatte und Verzeichnis "dh0:AssemblerX" nach dem Namen "AssemblerX:"
gesucht wird. In der Tat, in einigen der kommenden Listings suchen wir
tatsächlich nach "Assembler2:" und so wird es auch für "Assembler3:" sein.

PS: Ich beabsichtige, den gesamten Kurs ins Englische zu übersetzen, aber das
    würde mich für ganze MONATE zwingen, nicht mehr neue Lektionen zu 
	schreiben ...  Wenn ich also jemanden finden würde, der bereits Diskette 1
	gelesen hat, der Englisch kann und mindestens eine Lektion übersetzen will,
	das würde mich sehr freuen.	Wer würde mir bei der Arbeit helfen?
    Die Übersetzung hätte natürlich einen sehr hohen Prozentsatz am Gewinn aus
	dem Ausland (was ist mit 30%? Vielleicht ist es zu viel ..)
    Wer kann mir helfen? (Ich spreche von einem großen Übersetzungsjob)
    Kontaktieren Sie mich so schnell wie möglich.

P.S2: Ich empfehle, dass sie die Diskette1 des Kurses ALLEN Freunden (und
      Anderen) kopieren, es den Ladenbesitzern Ihrer Stadt geben, Werbung auf
	  schwarzen Brettern oder in Zeitungen machen um zu sehen, ob jemand
	  interessiert ist, neue Programmierer-Kontakte zu finden. Insbesondere
	  könnten Sie die CyberAssembler Philosophie der Szene verbreiten, von der
	  Sie eine Zusammenfassung in der Datei Szene.TXT finden.		 
      Selbst der Papst muss, wenn er vom Balkon aus schaut, die Disktte 1 des
	  Kurses haben! (frei kopierbar).
  	  
	  Die Disk 2 ist jedoch nicht frei kopierbar, sonst würde ich nicht einmal
	  das (nicht sehr viele) Geld bekommen, das diejenigen die nur Disk 1
	  haben, mir schicken. Stellen wir uns vor, sie hätten sofort beide
	  Disketten! Wenn (und falls) ich jedoch die Disketten 3, 4 usw. mache,
	  werde ich wahrscheinlich auch die Diskette 2 frei kopierbar machen
	  (allerdings als Shareware), so dass die Neuen die Disketten 1 + 2
	  sofort haben können, dann werde ich mit den Disketten 3, 4 ... etwas
	  Geld machen.
	 

Wir setzen die Lektion fort, unabhängig davon, ob sich die Datei auf einer
Festplatte oder auf einer Diskette befindet. Zunächst ist es notwendig, die
Lektion auf dem 68000 zu absolvieren, da vorerst eine vereinfachte Verwendung
vorgenommen wurde. Schon in der vorherigen Lektion haben sie gesehen, dass es
sehr oft notwendig ist, an den einzelnen Bits der Zahlen oder Register zu 
arbeiten. Je weiter Sie mit der Programmierung fortschreiten, umsomehr werden
sie dazu neigen Anweisungen wie AND, OR, NOT, ROL, ASL ... usw. einzufügen, die
Booleschen Operationen und Bitverschiebungsoperationen.
Ah! Im Lektionen-Verzeichnis befindet sich ein Text, der die AMIGA-SZENE
beschreibt. Nun, da Sie Coder werden, ist es ratsam, zu wissen, wem sie für die
Geburt der Programmierkultur der Demo danken sollten, auf diese "illegale"
Weise, die aber, wie Sie gesehen haben, sehr gut funktioniert. Der Text ist
Szene.TXT, lesen Sie ihn, wenn Sie Ihr Gehirn nicht mit asm-Lektionen zum
Rauchen bringen wollen!
Bevor wir mit dem Kurs fortfahren, ist es nowendig ein startup Listing zu
erstellen. Das heißt, das Speichern und Wiederherstellen des System Coppers,
effizienter als bisher. Darüber hinaus muss dieses Startup in allen zukünftigen
Listings enthalten sein, daher wird es sicherlich nützlich sein es über die
"INCLUDE" -Direktive einzubinden, wie wir es bereits beim Laden der Musik-
Routine gesehen haben. "Wir bauen" dieses Startup in der Lektion Schritt für
Schritt auf, als Ergebnis verschiedener Klarstellungen.
Analysieren wir den startup, der in den vorherigen Lektionen verwendet wurde:

Start:
	move.l	4.w,a6				; Execbase
	jsr	-$78(a6)				; Disable
	lea	GfxName(PC),a1			; Libname
	jsr	-$198(a6)				; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop		; alte COP speichern

; Hier ist unsere Copperlist und die Routinen

	move.l	OldCop(PC),$dff080	; wir zeigen auf die Copperliste
	move.w	d0,$dff088			; Copper starten
	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts

In der Praxis unterbrechen wir das Multitasking und die Systeminterrupts durch
Disable, dann öffnen wir die Grafikbibliothek, durch die wir die Adresse 
der alten Copperliste finden können, da wir wissen, dass sie sich $26 Byte 
nach der GfxBase-Adresse befindet. Da wir Wissen, wie man die alte
Copperliste zurücksetzt und wie man die WorkBench wieder mobilisiert, handeln
wir direkt auf den Custom Chips ohne Angst vor Inkompatibilität zu haben. Am
Ende der Routinen wird es notwendig sein, das Enable auszuführen, um das
Multitasking zu reaktivieren und auf die alte copperliste zu zeigen, um die
Fenster des Betriebssystems erneut anzuzeigen.
Diese Operationen sind das Minimum, das zum Arbeiten notwendig ist, aber
natürlich könnten Sie den Code verbessern, zum Beispiel einige Routinen der
graphics library ausführen, die den Videomodus zurücksetzen, um auch die
Videomodi für VGA / Multisync / Multiscan-Monitore zurückzusetzen oder andere. 
Es gibt eine spezielle Funktion, die LoadView heißt.

; Wir haben die GfxBase im A6-Register

	MOVE.L	$22(A6),WBVIEW	; speichern des aktuellen System WBView
	SUBA.L	A1,A1			; View Null, um den Videomodus zurückzusetzen
	JSR	-$DE(A6)			; LoadView Null - Videomodus zurücksetzen

Für die LoadView-Funktion muss die Strukturadresse (der Ansicht) in a1
angegeben werden, aber in diesem Fall ist A1 Null, da wir a1 von a1
subtrahieren, erhalten wir a1 = 0. Wenn A1 NULL ist, setzt die Funktion den
Videomodus in ein non-interlaced LOWRES und ohne spezielle Frequenzen für die
Monitore zurück. An diesem Punkt sind wir sicher, die Situation der
Copperliste unter Kontrolle zu haben, da wir auch den alten Zeiger auf die
WBVIEW-Struktur in einem Label gespeichert haben, was uns am Ende des Listings
erlaubt spezielle Frequenzen für Monitore wiederherzustellen:

	MOVE.L	WBVIEW(PC),A1	; alten WBVIEW in A1
	MOVE.L	GFXBASE(PC),A6	; GFXBASE in A6
	JSR	-$DE(A6)			; loadview - den alten View zurücksetzen


Um sicher zu sein, dass der Interlaced-Modus auch richtig zurückgesetzt und
korrekt wiederhergestellt wird, können sie zwei Frames warten, indem Sie die
WaitOF-Routine der graphics.library erneut aufrufen:

	MOVE.L	WBVIEW(PC),A1	; alten WBVIEW in A1
	MOVE.L	GFXBASE(PC),A6	; GFXBASE in A6
	JSR	-$DE(A6)			; loadview - den alten View zurücksetzen
	JSR	-$10E(A6)			; WaitOf (interlace neu anordnen)
	JSR	-$10E(A6)			; WaitOf


Um Ihre Gedanken in Ruhe zu bringen, setzen wir ein paar WaitOF auch nach dem
ersten loadview, der den Videomodus zurücksetzt, und während wir prüfen, ob
der Reset wirklich stattgefunden hat, indem wir testen, ob das WBVIEW wie
erwartet zurückgesetzt ist:

; Wir haben die GfxBase im A6-Register

	MOVE.L	$22(A6),WBVIEW	; speichern des aktuellen System WBView
	SUBA.L	A1,A1			; View null, um den Videomodus zurückzusetzen
	JSR	-$DE(A6)			; LoadView Null - Videomodus zurücksetzen
	JSR	-$10E(A6)			; WaitOf (Diese beiden Aufrufe von WaitOf)
	JSR	-$10E(A6)			; WaitOf (werden verwendet, um das Interlace
							;		  zurückzusetzen)

Da wir Betriebssystemroutinen verwendet haben, sind wir zuversichtlich, dass
auch in zukünftigen Maschinen der Videomodus noch zurückgesetzt wird.
Um die Kompatibilität zu "übertreiben", können wir am Ende des Listings mit 
dem Aufruf der intuition.library-Funktionen, die Bildschirme (Screens) und die
Fenster (windows) "neu zeichnen".

	move.l	4.w,a6			; ExecBase in A6
	LEA	IntuiName(PC),A1	; Bibliotheksname zum Öffnen (Intuition)
	JSR	-$198(A6)			; OldOpenLibrary - Öffne die Bibliothek
	TST.L	D0				; Fehler?
	BEQ.s	EXIT			; Wenn ja, beenden wir das Programm, ohne den
							; Code auszuführen
	MOVE.L	D0,A6			; IntuiBase in a6
	jsr	-$186(A6)			; ReThinkDisplay - Ordne die Eigenschaften des
							; Bildschirms ...


Dieser Vorgang ähnelt dem Vorgang, der mit WBView durchgeführt wird.
Bis jetzt haben wir den Blitter noch nicht benutzt, aber in den nächsten
Lektionen werden wir den Blitter verwenden, und da wir dieses Startup verwenden
werden, wird es nützlich sein es für diesen Zweck vorzubereiten. Stellen Sie
nur sicher, dass der Blitter nicht vom Betriebssystem verwendet wird, während
wir es verwenden, und es gibt eine Funktion von GfxLib die in der Lage ist, die
Verwendung des Blitters durch die Workbench zu verhindern:

	jsr	-$1c8(a6)	; OwnBlitter, gibt uns den exklusive Zugang auf den Blitter
					; verhindert, dass er vom Betriebssystem verwendet wird.

Am Ende des Listings reicht es aus, die Funktion aufzurufen, die das Gegenteil
tut. Aktivieren Sie die Verwendung des Blitters durch die graphics.library
erneut:

	jsr	-$1ce(a6)	; DisOwnBlitter, das Betriebssystem 
					; kann den Blitter jetzt wieder verwenden

Diese beiden Funktionen ähneln dem Disable und dem Enable, die wir gesehen
haben beim Ausschalten und Wiederherstellen von Multitasking und System
Interrupts. Tatsächlich gibt es auch eine weniger drastische Funktion des
Disable, das ist FORBID. Es verbietet das Multitasking lässt aber die
Systeminterrupts zu. Niemand verbietet, Forbid und Disable zusammen zu
verwenden, vielleicht wird das System dadurch weniger abrupt heruntergefahren, 
probieren wir es zusammen aus:

	move.l	4.w,a6		; ExecBase in A6
	JSR	-$84(a6)		; FORBID - Multitasking deaktivieren
	JSR	-$78(A6)		; DISABLE - deaktiviert auch die Interrupts
						; des Betriebssystems
; routines

	MOVE.L	4.w,A6		; ExecBase in a6
	JSR	-$7E(A6)		; ENABLE - ermöglicht System Interrupts
	JSR	-$8A(A6)		; PERMIT - ermöglicht Multitasking


Jetzt kann der Amiga nicht mit einer Guru-Meditation oder einem SoftWare-Fehler
protestieren, in dem er sagt, wir hätten ihn nicht gewarnt, wenn wir die
Hardware programmieren!

	                / \  //\
	  |\___/|      /   \//  .\
	  /O  O  \__  /    //  | \ \
	 /     /  \/_/    //   |  \  \
	 @___@'    \/_   //    |   \   \
	    |       \/_ //     |    \    \
	    |        \///      |     \     \
	   _|_ /   )  //       |      \     _\
	  '/,_ _ _/  ( ; -.    |    _ _\.-~        .-~~~^-.
	  ,-{        _      `-.|.-~-.           .~         `.
	   '/\      /                 ~-. _ .-~      .-~^-.  \
	      `.   {            }                   /      \  \ 
	    .----~-.\        \-'                 .~         \  `. \^-. 
	   ///.----..>        \             _ -~             `.  ^-`  ~^-_
	     ///-._ _ _ _ _ _ _}^ - - - - ~                     ~--,   .-~ 
	                                                           |_/~ 


Da wir den Status von allem speichern, warum speichern wir nicht die Werte von
Daten- und Adressregistern? Es gibt eine Anweisung, die hauptsächlich für
diesen Zweck verwendet wird und das ist das MOVEM. Die Register werden im STACK
gespeichert, das ist das A7-Register, auch SR genannt, das wir bis jetzt
vermieden haben zu verwenden. Mal sehen, was der Stack ist: Ich denke es ist
ein Register ähnlich wie ein Adressregister, es ist nicht umsonst das Register
A7. Daher ist der Wert, den das Register enthält, eine Adresse oder Zeiger
an eine Adresse. Tatsache ist, dass wenn wir die Adresse in A7 (oder SP)
ändern, bringt es den Amiga ziemlich durcheinander. Aber wer ändert die Adresse
des Stack-Pointers?
Da bei der Änderung ein Guru / Software Failure auftritt, kann man vermuten,
dass es das Betriebssystem ist, das diese Nummer bei jedem Zurücksetzen
festlegt und es verändert wenn nötig. Zu wissen, wie man es benutzt, kann
jedoch sehr nützlich sein. Wir haben im Kurs gesehen, wie es möglich ist,
einen Speicherbereich mit indirekter Adressierung anzugeben, zum Beispiel
durch Schreiben von:

	lea	bitplane,a0
	move.l	#$123,(a0)+
	move.l	#$456,(a0)+
		
Wir haben die Werte $123 und $456 über das Register a0 in die Bitebene
eingetragen, da wir a0 als Zeiger auf die Bitplane gesetzt haben. Aus diesem
Listing sehen wir auch wie es möglich ist, mit indirekter Adressierung mit
Post-Inkrement, die Daten nacheinander in den Speicherbereich einzugeben.
Was würde passieren, wenn wir nach diesen Anweisungen schreiben würden:

	move.l	-(a0),d0
	move.l	-(a0),d1

Es würde passieren, dass in d0 der letzte eingegebene Wert, dh $456, kopiert
wird, während in d1 der erste $123 und a0 wieder auf die Bitebene zeigen
würden. In der Praxis sind wir "zurückgegangen". 
Nun, stellen Sie sich die entgegengesetzte Operation vor: In dem Fall den
wir gesehen haben, ist ein Speicherbereich, den wir BITPLANE genannt haben
und wir schreiben von dieser Adresse aus vorwärts mit move.l #xxx,(a0)+ .

	Bitplane
	   o------------>

Nach einer bestimmten Anzahl von Anweisungen zeigt a0 auf Bitplane+x, das ist
viel weiter im Speicher.
Wir können die Werte mit move.l -(a0),xxx "wieder zurücknehmen", die wir in
diesem Feld mit Werten "gefüllt" haben und zurückkehren bis wir die BITPLANE-
Startadresse wieder erreichen. Aber seien sie vorsichtig!
Wir haben die Daten in umgekehrter Reihenfolge im Vergleich zu den eingegebenen
eingesammelt. Tatsächlich ist der zuletzt eingegebene, der erste der wieder
aufgenommen wird. Der Stack zeigt auf eine Adresse im Speicher, das als "Feld"
dient, in dem gesät werden soll, d.h. einem Bereich in dem Daten gespeichert
und wieder aufgenommen werden sollen.
Wir müssen jedoch aufpassen, dass es "rückwärts" verwendet wird, im Gegensatz
zu dem Beispiel der Bitebene. Die Notwendigkeit für den Stack kam mit den
ersten CPUs und ist so organisiert: Der Speicher eines Computers wird
normalerweise von der niedrigsten zur höchsten Adresse gefüllt, zum Beispiel
wenn wir einen Computer mit 512 KB Speicher haben und wir müssen eine 256 kB
große Datei laden werden die ersten 256k gefüllt und der Bereich von 257 bis
512 kB bleibt frei.
Um allgemeine Daten in einem STACK-Raum zu speichern, wurde entschieden diesen
Raum vom Ende des Speichers zu beginnen, und von dort die Daten "rückwärts"
bis zum ersten Speicherplatz zu speichern, um damit den Speicher besser zu
nutzen:

	Null ---------------------------------------Ende Speicher
	     Programm ----->>		    <<-----STACK

Auf diese Weise wird der Stack nicht überschrieben, wenn der Speicher vorhanden
ist und sowieso vermeiden die Programme die unter dem Betriebssystem laufen
diese Kollision! Wir müssen Demos oder Spiele erstellen, die vom Betriebssystem
ausgeführt werden können. Daher müssen wir den Stack auf eine Standardmethode
verwenden, um keine Konflikte oder ein Überschreiben zu erzeugen.
Wenn wir ein Programm im Autoboot gemacht haben und nicht exit gehen müssen,
könnten wir unseren eigenen Bereich für den Stack definieren, aber das kann
Kompatibilitätsprobleme generieren und ich empfehle Ihnen vorerst, dies nicht
zu tun. Lassen Sie uns abschließend sehen, wie man Daten vom STACK aus eingibt
und zurücknimmt mit einem sehr einfachen Beispiel: Speichern Sie den Inhalt des
Registers D0 und stellen Sie ihn anschließend wieder her.

	MOVE.L	d0,-(SP)	; d0 im Stack speichern. HINWEIS: wenn wir 
						; nur ein Register speichern müssen, verwenden wir MOVE
						; MOVEM, wird für mehrere Register verwendet.

						; Routinen, die D0 verändern

	MOVE.L	(SP)+,d0	; wir stellen den alten Wert von d0 wieder her
						; in dem wir es vom Stack nehmen

Beachten Sie, dass das Schreiben von MOVE.L d0,-(SP) oder MOVE.L d0,-(A7)
gleichwertig ist. Wir stellen fest, dass der Inhalt von d0 an die Adresse
kopiert wird, auf die der SP zeigt, und der SP selbst zeigt ein longword eher.
Dann wird d0 durch verschiedene Routinen geändert und wenn wir den alten Wert
wiederherstellen möchten, holen wir ihn vom SP zurück.
Beachten Sie, dass wir mit (SP)+ den SP auf die Adresse zurücksetzen, auf die
es vor dem Speichern von d0 gezeigt hat. Das heißt, wir sind ein Longword
zurückgegangen, dann haben wir den Wert herausgeholt.

Versuchen wir nun, den Wert mehrerer Register zu speichern:

	Move.l d0,-(SP)	; d0 im Stack speichern
	Move.l d1,-(SP)	; d1 im Stack speichern
	Move.l d2,-(SP)	; d2 im Stack speichern
	Move.l d3,-(SP)	; d3 im Stack speichern

					; Routinen, die d0, d1, d2, d3 modifizieren

	Move.l (SP)+,d3	; wir stellen den alten Wert von d3 wieder her
	Move.l (SP)+,d2	; wir stellen den alten Wert von d2 wieder her
	Move.l (SP)+,d1	; wir stellen den alten Wert von d1 wieder her
	Move.l (SP)+,d0	; wir stellen den alten Wert von d0 wieder her
					; in dem wir sie vom Stack nehmen

Beachten Sie, dass der zuletzt gespeicherte Wert der erste ist, der
wiederherausgeholt wird und zwar weil wir zurückgehen, indem wir vom letzten
eingegebenen Wert rückwärts bis zum ersten Wert lesen:

						Adresse Beginn STACK
	EINGEBEN:	-(SP)	<--------------o	- zurück -


						Adresse Beginn STACK
	Lesen:		(SP)+	--------->     o	- vorwärts -


	
Es ist eine "Stapel"-Struktur. Man kann sich das in folgender Weise vorstellen: 
Ich denke, Sie haben eine Sammlung von Comics und möchten sie von Nummer eins
bis 50 sortieren. Nummer 1 gefunden, auf einen Tisch legen. Wenn sie Nummer 2
gefunden haben, legen sie es oben auf die Nummer 1. Dann die 3 auf die 2 und
allmählich machen Sie einen "Stapel" von Comics, bis Sie die Zahl 50 oben auf
den Haufen gelegt haben. Nun, wenn Sie die Comics wieder sehen wegnehmen 
wollen, ist das erste, das Sie sehen die 50, dann darunter sind 49, 48 usw. und
zuletzt finden sie die 1. Tatsächlich ist der Stapel vom Typ "first in, last
out", dh "das zuerst reingelegte ist das zuletzt herausgezoge".
Sie werden verstehen, dass das unsachgemässe Ändern der Stack-Werte die Werte 
in den Speicher zufällig übernehmen wird und nicht als zuvor gespeicherte Werte
betrachtet. Seien Sie also vorsichtig, wenn Sie Folgendes ausgeführt haben:

	MOVE.L	xxxx,-(SP)	; wir speichern xxxx im stack

Wenn Sie das nächste Mal mit (SP)+ aus dem Stapel lesen, erhalten Sie xxxx.

Im Stack können Sie alle Daten speichern und wiederherstellen, aber ein 
offensichtlicher Nutzen besteht darin, den Status der Register zu speichern.
Dies ist möglich, durch das einfache MOVE.L falls nur ein Register gerettet
werden soll oder durch das MOVEM (MOVE Multiple) für mehrere Register. Mal
sehen, wie das MOVEM funktioniert: um alle Register zu speichern (außer a7,
dies ist offensichtlich der SP), also d0, d1, d2, d3, d4,5, d6, d7, a0, a1, a2,
a3, a4, a5, a6), müssen Sie dies nur das MOVEM statt 15 x MOVE ausführen:

	MOVEM.L	d0-d7/a0-a6,-(SP)	; speichert alle Register im STACK

Und um sie alle wiederherzustellen, nur ein:

	MOVEM.L	(SP)+,d0-d7/a0-a6	; nimmt alle Register vom STACK wieder heraus

Praktisch verschiebt das MOVEM eine Liste von Registern an das Ziel. In dem
Fall von "MOVEM.L d0-d7/a0-a6,Ziel", oder Sie kopieren eine Quelle in die
verschiedenen Register, im Fall von "MOVEM.L -Quelle,d0-d7/a0-a6".
Quelle und Ziel liegen im "Standard"-Format vor, sodass sie eine Kopie von und
an LABEL/ADRESSEN oder indirekte Adressierung vornehmen können:

	MOVEM.L	d0-d7/a0-a6,-(SP)
	MOVEM.L	d0-d7/a0-a6,LABEL
	MOVEM.L	d0-d7/a0-a6,$53000

	MOVEM.L	$53000,d0-d7/a0-a6
	MOVEM.L	LABEL(PC),d0-d7/a0-a6
	MOVEM.L	(SP)+,d0-d7/a0-a6

Die Liste folgt diesem Standard: Die Register können separat angegeben werden.
Alle getrennt mit dem "/" - Schrägstrich, so dass wir sagen können:

	MOVEM.L	d0-d7/a0-a6,-(SP)

Es ist äquivalent zu:

	MOVEM.L	d0/d1/d2/d3/d4/d5/d6/d7/a0/a1/a2/a3/a4/a5/a6,-(SP)

Eine aufeinanderfolgende Reihe von Registern kann durch Anzeigen des ersten
Registers und des letzten Registers getrennt durch ein "-" mitgeteilt werden. 
In Wirklichkeit akzeptiert das Asmone auch:

	MOVEM.L	d0-a6,-(SP)

Es betrachtet es als die sehr lange vorhergehende Anweisung, aber da nicht alle
Assembler dieses Darstellung akzeptieren, ist es besser, das "/" zwischen die
Sätze von Datenregistern und die der Adressregister zu setzen. Nehmen wir
einige Beispiele: Wir wollen die Register d0, d1, d2, d5 und a3 speichern:

	MOVEM.L	d0-d2/d5/a3,-(SP)
		
Wir haben d0/d1/d2 durch d0-d2 vereinfacht.
Versuchen wir jetzt d2,d4,d5,d6,a3,a4,a5,a6 zu speichern:

	MOVEM.L	d2/d4-d6/a3-a6,-(SP)

Um diese Register wiederherzustellen, schreiben wir natürlich:

	MOVEM.L	(SP)+,d2/d4-d6/a3-a6

Ich glaube, dass die Syntax von MOVEM klar ist. Durch diese Anweisung ist es
möglich das Multitasking zu verwalten. Haben Sie sich jemals gefragt, wie sie
zwei Programme zusammen mit den gleichen Daten- und Adressrregistern ausführen
können, ohne das sie sich gegenseitig stören? Die Antwort ist einfach!
Zu Beginn jeder Routine gibt es ein MOVEM, das den Status der Register
speichert. Die Routine wird ausgeführt und am Ausgang kehren die Register in
ihren Originalzustand zurück, als ob diese Routine noch nie durchgeführt worden
wäre. Tatsächlich sind viele Routinen so strukturiert:

Routine:
	MOVEM.L	d0-d7/a0-a6,-(SP)
	....
	....
	MOVEM.L	(SP)+,d0-d7/a0-a6
	rts

Auf diese Weise bewirkt eine "BSR.W ROUTINE" keine Änderung der Register. Wenn
in a5 $dff000 und in a6 ExecBase steht, sind wir uns sicher, dass nachdem die
Routine ausgeführt wurde es immer noch diese Werte sind.
Bei der Verwendung von zu häufigen MOVEM kommt es vor, die ersten paar Male, 
den "FADEN" der bereits gemachten movem zu verlieren, so das so etwas passieren
kann:

Routine:
	MOVEM.L	d0-d7/a0-a6,-(SP)
	....
	....
	MOVEM.L	(SP)+,d0-d7/a0-a6
	....
	....
	MOVEM.L	(SP)+,d0-d7/a0-a6
	rts

In diesem Fall liegt ein OFFENSICHTLICHER FEHLER vor, da zuerst der Stack zu
weit gegangen ist, so dass alle Daten, die später vom Stapel genommen werden
falsch sind. Als zweites werden die Register bereits andere Werte haben als
die eingegebenen. Um alles zurückzubekommen, können Sie Folgendes tun:

Routine:
	MOVEM.L	d0-d7/a0-a6,-(SP)
	....
	....
	....
	MOVEM.L	d0-d7/a0-a6,-(SP)
	....
	....
	MOVEM.L	(SP)+,d0-d7/a0-a6
	....
	....
	MOVEM.L	(SP)+,d0-d7/a0-a6
	rts

Auf diese Weise haben die Register am Ausgang der Routine den Eingabewert und
der Stack ist zur Eingangsadresse zurückgekehrt. (Eintritt in die Routine!)

An dieser Stelle können wir unser Startup mit einer anfänglichen Speicherung 
und endgültigen Restaurierung der Register ausführen, ähnlich dem letzten
Beispiel. So sieht unser Startup jetzt aus:

MAINCODE:
	movem.l	d0-d7/a0-a6,-(SP)	; speichern der Register auf dem Stack
	move.l	4.w,a6				; ExecBase in a6
	LEA	GfxName(PC),A1			; Name der zu öffnenden Bibliothek
	JSR	-$198(A6)				; OldOpenLibrary - öffne die Bibliothek
	MOVE.L	d0,GFXBASE			; speichern der GfxBase in einem Label
	BEQ.w	EXIT2				; Wenn ja, beenden wir das Programm, ohne den
								; Code auszuführen
	LEA	IntuiName(PC),A1		; Intuition.lib
	JSR	-$198(A6)				; Openlib
	MOVE.L	D0,IntuiBase
	BEQ.w	EXIT1				; Wenn Null, geh raus! Fehler!
	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; Version 39 oder größer? (kick3.0+)
	BLT.s	VecchiaIntui		; alte Intui
	BSR.w	ResettaSpritesV39

VecchiaIntui:
	MOVE.L	GfxBase(PC),A6
	MOVE.L	$22(A6),WBVIEW		; speichern des aktuellen System WBView
	SUBA.L	A1,A1				; View null, um den Videomodus zurückzusetzen
	JSR	-$DE(A6)				; LoadView Null - Videomodus zurücksetzen
	SUBA.L	A1,A1				; View null
	JSR	-$DE(A6)				; LoadView (zweimal zur Sicherheit...)
	JSR	-$10E(A6)				; WaitOf (Diese beiden Aufrufe von WaitOf)
	JSR	-$10E(A6)				; WaitOf (werden verwendet, um das Interlace	
	JSR	-$10E(A6)				; zurückzusetzen) Noch zwei, vah!
	JSR	-$10E(A6)

	MOVEA.L	4.w,A6
	SUBA.L	A1,A1				; NULL task - finde den Task
	JSR	-$126(A6)				; findtask (d0=task, FindTask(name) in a1)
	MOVEA.L	D0,A1				; Task in a1
	MOVEQ	#127,D0				; Priorität in d0 (-128, +127) - MAXIMUM!
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0 = Priorität, a1 = task)

	MOVE.L	GfxBase(PC),A6
	jsr	-$1c8(a6)				; OwnBlitter, gibt uns den exklusiven Zugang
								; auf den Blitter, verhindert, dass er vom 
								; Betriebssystem verwendet wird.
	jsr	-$E4(A6)				; WaitBlit - warten auf das Ende des Blitters
	JSR	-$E4(A6)				; WaitBlit

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$84(a6)				; FORBID - Multitasking deaktivieren
	JSR	-$78(A6)				; DISABLE - deaktiviere auch die interrupts
								; des Betriebssystems
**************
	bsr.w	HEAVYINIT			; Jetzt können Sie den Teil ausführen der
**************					; auf den Hardware-Registern arbeitet

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$7E(A6)				; ENABLE - ermöglicht System Interrupts
	JSR	-$8A(A6)				; PERMIT - ermöglicht Multitasking

	SUBA.L	A1,A1				; NULL task - finde den task
	JSR	-$126(A6)				; findtask (d0=task, FindTask(name) in a1)
	MOVEA.L	D0,A1				; Task in a1
	MOVEQ	#0,D0				; Priorität in d0 (-128, +127) - MAXIMUM!
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0 = Priorität, a1 = task)

	MOVE.W	#$8040,$DFF096		; blitt ermöglichen
	BTST.b	#6,$dff002			; WaitBlit...
Wblittez:
	BTST.b	#6,$dff002
	BNE.S	Wblittez

	MOVE.L	GFXBASE(PC),A6		; GFXBASE in A6
	jsr	-$E4(A6)				; WaitBlit - warten auf das Ende eines Blitts
	JSR	-$E4(A6)				; WaitBlit
	jsr	-$1ce(a6)				; DisOwnBlitter, das Betriebssystem 
								; kann den Blitter jetzt wieder benutzen
	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; V39+?
	BLT.s	Vecchissima
	BSR.w	RimettiSprites

Vecchissima:
	MOVE.L	GFXBASE(PC),A6		; GFXBASE in A6
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeiger auf das alte System "Copper1"
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeiger auf das alte System "Copper2"
	JSR	-$10E(A6)				; WaitOf (setzt Interlace zurück)
	JSR	-$10E(A6)				; WaitOf
	MOVE.L	WBVIEW(PC),A1		; alter WBVIEW in A1
	JSR	-$DE(A6)				; loadview - setzt die alte Ansicht zurück
	JSR	-$10E(A6)				; WaitOf (setzt Interlace zurück)
	JSR	-$10E(A6)				; WaitOf
	MOVE.W	#$11,$DFF10C		; Dies stellt es nicht von selbst wieder her..!
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeiger auf das alte System "Copper1"
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeiger auf das alte System "Copper2"
	moveq	#100,d7
RipuntLoop:
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeiger auf das alte System "Copper1"
	move.w	d0,$dff088
	dbra	d7,RipuntLoop		; zur Sicherheit...

	MOVEA.L	IntuiBase(PC),A6
	JSR	-$186(A6)				; _LVORethinkDisplay - zeichnet alles neu
								; Displays, einschließlich ViewPorts und alle
								; Interlace- oder Multisync-Modi. IntuiBase
	MOVE.L	a6,A1				; in a1 um die Bibliothek zu schließen
	move.l	4.w,a6				; ExecBase in A6
	jsr	-$19E(a6)				; CloseLibrary - intuition.library GESCHLOSSEN
Exit1:
	MOVE.L	GfxBase(PC),A1		; GfxBase in a1 um die Bibliothek zu schließen
	jsr	-$19E(a6)				; CloseLibrary - graphics.library GESCHLOSSEN
Exit2:
	movem.l	(SP)+,d0-d7/a0-a6	; die alten Registerwerte wiederherstellen
	RTS							; zu ASMONE oder Dos / WorkBench zurückkehren
	
Es wurden nur vier Details hinzugefügt: Eines ist die Überprüfung nach dem
Öffnen der graphics.library, wenn es aus irgendeinem Grund nicht geöffnet
werden konnte, würden wir in dem Fall in d0 anstelle der Adresse der GfxBase
eine NULL finden. Alles, was dafür getan wird, ist ein Pseudo "TST.L D0"
einzufügen und einen Sprung zum EXIT-Label für den Fall wenn nicht erfolgreich
geöffnet werden konnte. Sie werden mit dem Studium der Zustandscodes (Condition
codes) feststellen, das es ausreicht ein "beq" nach einem move zu machen, ohne
"tst" zu verwenden, um zu wissen, ob d0 zurückgesetzt (Null) ist.
Ein weiteres Detail ist das Auftreten des Systems COPPER2 (GfxBase + $32), was
nichts anderes ist als der vom System eingegebene Wert in $dff084 (COP2LC) vom
Betriebssystem. Bisher haben wir die Copperliste 2 noch nicht verwendet, aber
in den späteren Lektionen werden wir das Zeigen nützlicher Anwendungsfälle
nicht versäumen.
Eine weitere "Finesse" besteht darin, die Sprites zurückzusetzen, aber nur,
wenn wir auf Kickstart 3.0 oder höher sind, da die Sprite-Reset-Funktion ab
dieser Version verfügbar ist. Die SubRoutine, die die Sprites zurücksetzt ist
ein klassisches Beispiel für die "legale" Programmierung mit Aufrufen des
Betriebssystems. Wie Sie sehen können, ist es komplizierter das Betriebssystem
zu benutzen, als das Programm über die Hardware zu bedienen (nicht wahr?).
Schließlich gibt es die Einstellung der Taskpriorität. Wie sie wissen hat jedes
Programm was in Multitasking ausgeführt wird, im Vergleich zu den anderen eine
eigene "Priorität". Nun, lassen Sie uns das Maximum einstellen! Das ist 127. In
Wirklichkeit würde das nichts nützen nachdem wir Multitasking komplett
deaktiviert haben. Wir werden später sehen, dass es trotzdem nützlich ist, die
Priorität auf das Maximum zu setzen und das Multitasking wiederherzustellen
beim Laden von Datendateien von Diskette, Festplatte oder CD-ROM.

Mit diesem Startup geben wir unser Bestes, um sicherzustellen, dass das
Betriebssystem ohne Probleme "umgangen" werden kann. Mal sehen, was wir noch
tun können um mehr Kontrolle über die Amiga Hardware zu übernehmen.
Zunächst müssen die Register DMACON, INTENA, ADKCON und INTREQ eingeführt
werden, welche für das "Schließen" oder "Öffnen" der DMA-KANÄLE zuständig sind,
sowie das Aktivieren von Interrupts und anderen Dingen. In den Listings, gehen
wir davon aus, dass COPPER, BITPLANES und SPRITE tatsächlich aktiviert sind.
Wir können sowohl die Texte als auch die Menüs des ASMONE (BITPLANE) und den
Mauszeiger-Pfeil (SPRITE) sehen. Dies bedeutet, dass diese Kanäle aktiviert
sind.
Es ist jedoch besser, den Status dieser Register persönlich zu ändern.
Vergewissern Sie sich, dass die Kanäle, die uns interessieren, aktiviert sind
und die für die wir uns nicht interessieren deaktiviert sind. Wie bei der
Copperliste wird es genug sein den Status der Register am Anfang zu speichern
und dann unser Programm auszuführen (aktiviert und deaktiviert nach Belieben),
um schließlich die Register wieder in den Anfangszustand zu bringen, als wäre
nichts passiert. Aber zuerst wollen wir sehen, was diese DMA-Kanäle sind.

DMA bedeutet "Direct Memory Access" (direkter Speicherzugriff), was "direkter
Zugriff auf den Speicher" bedeutet.
Tatsächlich ist der Zugriff auf den Speicher im Amiga sehr komplex. Denn
Zugriff auf den Speicher hat nicht nur der Prozessor, sondern auch der Copper
um Bilder anzuzeigen, der Blitter zum Kopieren und Verschieben von Daten, Audio
um Töne abzuspielen.
Um zu verhindern das "Unfälle" passieren, wenn all diese Prozessoren
gleichzeitig, den Speicher, in die Hände bekommen möchten (zumindest den
CHIP-Speicher) wurde ein System von "Ampeln" und Viadukten, wir können über
Stadtplanung sprechen, gesetzt. Tatsächlich befindet sich im AGNUS-Chip ein
DMA-Kanalmanager, der die Operationen koordiniert, und dafür sorgt, dass die
Custom Chips und der 68000er "abwechselnd" auf den Speicher zugreifen, wenn der 
Kanal frei ist. Dieser Zugang kann entweder Lesen oder Schreiben sein (Copper
liest Copperlist, Audio liest Musik, der Blitter "schreibt Bilder, und so"
weiter). Es gibt mehrere DMA-Kanäle, bei denen jeder einen bestimmten Zweck
hat.

1) DMA-COPPER: Durch diesen Kanal liest der Copper die COPPERLIST.
	Wenn er deaktiviert ist, wird die Copperliste nicht mehr gelesen und
	folglich verschwinden sowohl die Bitebene als auch die Sprites und auch
	alle Farbtöne die durch Ändern der Hintergrundfarbe mehrmals durch setzen
	von WAIT in der Copperliste gemacht werden.	In der Praxis bleibt der
	Bildschirm einfarbig mit der Farbe COLOR0. In diesem Fall können Sie die
	Farbe des Bildschirms nur mit dem Prozessor, mit "MOVE.W #xxx,$dff180"
	ändern.

2) DMA SPRITE: Dieser Kanal führt die Übertragung der Sprite-Strukturen durch,
	auf die in den SPRxPT-Registern der Copperliste verwiesen wird.	Wir haben
	jedoch bereits gesehen, wie man Sprites durch direktes Schreiben in die 
	SPRxDAT-Register visualisieren und damit manuell die Arbeit der DMA machen
	kann. Nur den DMA-Kanal Sprite deaktivieren bewirkt, dass die Sprites
	verschwinden, als ob sie auf Null zeigen würden und die Bitebene und
	Farbverläufe die mit WAIT und MOVE der Copperliste auf dem Bildschirm
	gemacht	werden bleiben erhalten. Es bleibt zu bemerken, das wenn das
	DMA-BITPLANE deaktiviert ist, auch wenn der SPRITE DMA-Kanal aktiv bleibt,
	die Sprites	verschwinden.

3) DMA-BITPLANE: Bei Deaktivieren dieses Kanals werden die Bitebenen, auf die
    die BPLxPT zeigen nicht mehr angezeigt. Andererseits werden jedoch die
	Farbtöne bei aktiven DMA-Kanal Copper mit COLOR0 angezeigt. Ausschalten des
	Kanals würde das gleiche wie das Einfügen von Null Bitebenen in den BPLCON0
	entsprechen. Das heißt, "dc.w $100,$200" in der Copperliste.
	Beachten Sie, dass bei deaktiviertem BITPLANE-DMA auch die Sprites
	zusammen mit der Bitebene verschwinden,	auch wenn der DMA-Kanal SPRITE
	aktiv ist. Dies geschieht auch, wenn wir Null Bitebenen in das BPLCON0
	setzen.
	
4) DMA DISK: Zum Übertragen von Daten vom Laufwerk in den CHIP-Speicher durch
   lesen oder schreiben.

5) DMA AUDIO1 Dies sind 4 separate Kanäle, die die 4 Stereo Stimmen des Amiga
   DMA AUDIO2 steuern. Zum Beispiel, um einen Ton von Stimme 1 zu emittieren,
   DMA AUDIO3 müssen Sie den Kanal DMA AUDIO1 öffnen und um ihn stumm zu 
   DMA AUDIO4 machen, indem der DMA-Kanal wieder geschlossen wird. 
   Offensichtlich sind die 4 Kanäle immer geschlossen, wenn der Amiga  still
   ist, zum Beispiel wenn Sie die WorkBench ohne Hintergrundmusik verwenden.

6) DMA BLITTER: Dieser DMA behandelt Lese- und Schreibzugriffe vom Blitter. Wir
    werden die DMA-Kanäle des Blitters in dem Kappitel der diesem Prozessor
	gewidmet ist analysieren.
	
Aber wie ist der zeitliche Zugriff auf den Speicher zwischen dem Prozessor und
den Custom Chips? Das hängt sehr stark von der Videoauflösung und den
aktivierten Kanälen ab. In der Praxis werden weniger Kanäle eingeschaltet ist
der 68000er schneller, als die anderen in Betrieb befindlichen CHIPs.
Sehen wir uns die Beziehung zwischen Videoauflösung und DMA an: Das Videobild
wird durch Rasterlinien erstellt, das heißt von Linien, die durch den
elektronischen Rasterstrahl gezeichnet werden. Wir wissen bereits, wie man auf
eine bestimmte vertikale Zeile durch Lesen des $dff006 (VHPOSR) oder in der
Copperliste über ein WAIT wartet. Nun, in jeder Rasterzeile gibt es 227.5
Zugriffe auf den Speicher und das DMA verwendet nur 225. Ein Zyklus des
Zugriffs auf den Speicher, wenn Sie das interessiert, hat eine Dauer von
0,00000028131 Sekunden in einem 320x256-PAL-Bildschirm bei 50 Hz.
Da der 68000 keine Zeit hätte, in jeden Buszyklus auf den Speicher zuzugreifen
wird der Zugriff nur während der geraden Zyklen gewährt, also 113 Mal pro
Rasterzeile. Das Problem ist, dass der Blitter und der Copper auch in den
gerade Zyklen Zugriff auf den Bus haben können, und somit dem armen 68000
Zyklen stehlen können. Ungerade Buszyklen werden stattdessen vom DMA-Manager
für AUDIO-Zugriffe, DISK und SPRITE verwendet.
Zusammenfassend gibt es 227/228 Zyklen pro Rasterzeile, unterteilt in gerade
und ungerade Zyklen. In den 113 ungeraden Zyklen kann nur auf den CHIP-Speicher
durch AUDIO, DISK und SPRITE zugegriffen werden. Auf die 113 geraden Zyklen
können der BLITTER, COPPER und der 68000 auf den CHIP-Speicher zugreifen, wo
wiederum der arme 68000 eine niedrigere Priorität hat.
Sie werden verstehen, dass bei Deaktivierung des DMA-Blitters der 68000
häufiger auf den Speicher zugreifen kann, da er mehr freie gerade Zyklen hat.
Bedenken Sie, dass DMA-COPPER Vorrang vor dem DMA-BLITTER hat, welcher eine
höhere Priorität über den 68000 hat, was besser für arbeiten im FAST RAM ist.
In der Tat, wenn sich der Code, den der 68000 ausführt, im FAST-RAM anstatt
im CHIP-RAM befindet leidet der Prozessor nicht daran. Es ist daher besser den
Code mit dem SECTION CODE in den Fast RAM zu setzen.
Nehmen wir ein Beispiel: Wenn der Copper den Bus besetzt hat, müssen der Blitter
und der 68000 auf den nächsten geraden Zyklus warten. Das Problem ist das, mit
einer Auflösung von 320x256 LOWRES mit 6 Bitplanes der 68000 gleich die Hälfte
der Zyklen dem Copper gewähren muss, um die 6 Bitplanes anzuzeigen, insgesamt
56 pro Zeile. Im Falle eines 640x256 HIRES mit 16 Farben oder 4 Bitebenen
"stiehlt" der Copper fast alle Zyklen dem 68000. Folglich verlangsamt sich das
Programm (wenn auf dem Computer kein FAST RAM vorhanden ist).
Die DMA-Zugriffe während der Rasterzeile folgen einem genauen Muster: Wir haben
die geraden Zyklen zwischen dem COPPER, dem BLITTER und dem 68000 aufgeteilt.
Bei ungeraden Zyklen erfolgt der Zugriff auf DISK, AUDIO, SPRITE und BITPLANE
in dieser Reihenfolge: Von der horizontalen Linie $7 bis $c finden die Zugriffe 
der DMA-DISC, von der $D bis $​​14 AUDIO, von $15 bis $34 SPRITE, schließlich 
von $35 bis $e0 die für BITPLANES statt.
Wir fassen zusammen:

- KARTE DES DMA-ZUGRIFFS IN JEDER RASTERLINIE -

GERADE ZYKLEN: Es gibt 113 und die sind zwischen Copper, Blitter und 68000
 aufgeteilt, wobei der Copper die höchste Priorität hat. Wenn wir also eine
 hohe Auflösung, z.B. 640x256 bis 4 Bitebenen haben, kann der 68000 fast nie
 auf den Speicher zugreifen, was sehr offensichtlich zu einer Verlangsamung
 führt. Die einzige Abhilfe ist, den Code in den FAST RAM zu setzen, wo es
 keine Verlangsamung des Prozessors gibt. Unter anderem im 68020-Prozessor und
 höher ist der Code im Fast-RAM immer viel schneller als der im CHIP-RAM.

UNGERADE ZYKLEN: Es gibt 113 und die werden zwischen Audio, Disk und
 Sprite in dieser Ordnung aufgeteilt:

			horizontale Linie:
			$07 - $0C	Zugriff durch DMA DISK
			$0d - $14	Zugriff durch 4 Kanäle DMA AUDIO
			$15 - $34	Zugriff durch 8 Kanäle DMA SPRITE
			$35 - $e0	Zugriff durch Bitplane in Speicher

In der Realität ist es für die Zwecke der Programmierung nicht erforderlich,
diese technischen Details zu kennen, aber sie können deutlich machen, wie
wichtig es ist, die DMA-Kanäle für eine maximale Betriebsgeschwindigkeit 
einzusparen.

Wenn Sie in Ihrem Programm beispielsweise einen Bildschirm in HAM oder HIRES 
am oberen Rand des Bildschirms haben, während Sie darunter andere Dinge in 
niedriger Auflösung laufen lassen, sollten sie für den Zeitraum von der ersten
Zeile bis zum Ende des "anspruchsvollen" Bildschirms (z.B. 16-Farben-
Einstellungen) wie DMA sowohl für den Prozessor als auch den Blitter 
Verlangsamungen erfahren und es möglicherweise in der verbleibenden Zeit
nicht unter das Bild schaffen.
Um Geschwindigkeit zu gewinnen, können Sie zunächst die 16 Farben nur dort
aktivieren, wo sie tatsächlich benötigt werden, Beispiel:


----- Start Bildschirm (Screen), BPLCON0 für 16 Farben HIRES eingestellt 
\ schwarzer Raum
/
 *** ###***  ##***##  ##**  ##* #* # # # *#*#       ### * ***#*##
 *** ###***  ##***##  ##**  ##* #* # # # *#*#       ### * ***#*## > Bild
 *** ###***  ##***##  ##**  ##* #* # # # *#*#       ### * ***#*##
\ schwarzer Raum
/
----- bplcon0 für kleinere Auflösung eingestellt

 **
				**	> 3D ROTIERENDE KUGELN UND WÜRFEL
		**
----- schwarzer Raum


----- Ende Bildschirm, dc.w $ffff,$fffe

In diesem Fall sehen Sie den Ablauf einer Copperliste. Nehmen wir an, dass alle
3D-Routinen unter dem Bild nur wenig Zeit einer 1/50 einer Sekunde brauchen um
ausgeführt zu werden. Ändern Sie einfach die Copperliste leicht und die Routine 
könnte mit einem Frame pro Sekunde laufen, mal sehen, was zu tun ist:

COPPERLIST
	dc.w	$100,$200	; 0 Bitplanes im Anfangsbereich "SCHWARZ"
	dc.w	$3507,$fffe	; Warten Sie auf die Zeile, in der die Figur beginnt
	dc.w	$100,$c200	; Aktiviere 16 Farben
	dc.w	$a007,$ffe	; Warten Sie auf die Zeile, in der die Figur endet
	dc.w	$100,$200	; 0 Bitplanes im Bereich unter dem Bild
	dc.w	$b007,$fffe	; warte auf das Ende der schwarzen Zone
	dc.w	$100,$3200	; 3 Bitplanes lowres für Vektor-Routine
	dc.w	$e007,$fffe	; Das Bild kommt nicht unterhalb dieser Linie
	dc.w	$100,$200	; Schalten Sie das DMA BITPLANE für immer aus
						; und vielleicht machen wir eine Nuance mit COLOR0 und
						; WAIT, um die Unterseite des Monitors zu füllen, ohne 
						; auf die DMA einzugreifen
	dc.w	$ffff,$fffe

Um zu übertreiben, könnten wir auch das Videofenster einschränken, in dem sich
die Figuren befinden. Sie füllen den gesamten Bildschirm nicht horizontal aus.
Lass uns diesen Fall machen:
Wir haben einen 3D-Körper, der sich in der Mitte des Bildschirms dreht, und wir
haben die DMA-Bitplane darüber und darunter bereits geschlossen:

---------- Startbildschirm, dc.w $100,$200



----------------   /\   --- fester Start, dc.w $100,$3200
				  / |\
				 /  | \
				/   |  \
				\___|__/
--------------------------- festes Ende, dc.w $100,$200

------------- Ende Bildschirm, dc.w $ffff,$fffe

Wie Sie sehen, dreht sich der Körper in der Mitte des Bildschirms und nimmt
niemals die Bereiche ganz rechts und ganz links auf dem Bildschirm ein. An
diesem Punkt könnten wir auch auf DIWStrt und DIWStop agieren, um den
Bildschirm ein wenig zu "schließen", wenn wir es nur auf die notwendige Breite
begrenzen und wir können es so oft wie nötig für größere Designs darüber oder
darunter "vergrößern":

	dc.w	$8E,$2c81	; DiwStrt Größe normal für große Figuren
	dc.w	$90,$2cc1	; DiwStop Größe normal

	WAIT

	dc.w	$8E,$2c91	; DiwStrt im festen Bereich eingeschränkt
	dc.w	$90,$2cb1	; DiwStop

Durch die Beschränkung des Videofensters sparen wir tatsächlich DMA-Zeit ein,
da die Übertragung der Bitplane nur in dem Bereich innerhalb des definierten
Videofensters erfolgt.

Wir schließen diese Klammer und sehen, wie diese Kanäle geöffnet und
geschlossen werden. Im Amiga gibt es ein Hardwareregister ($dff096) namens
DMACON (= DMA-Controller), der jeden einzelnen DMA-Kanal steuert. Das DMAConW
($dff096) dient nur zum Schreiben von Änderungen, während das DMAConR ($dff002)
nur zum Lesen der verschiedenen Bits dient.
Hier ist die Karte der 2 Register $dff096 und $dff002: (die gleiche aber eine
zum Lesen und eine für das Schreiben). Das Register ist BITMAPPED wie $dff100
(BPLCON0) was bedeutet, das entscheidend ist, welche Bits einzeln ein- oder
ausgeschaltet werden:

(HINWEIS: Die Bits 13 und 14 sind nur lesbar (R), 15 ist mur schreibbar (W).)

 DMACON ($dff096/$dff002)

bit- 15 DMA Set/Clear				(W)	(man kann nur schreiben $dff096)
     14 BlitBusy (oder BlitDone)	(R)	(Sie können nur auslesen $dff002)
     13 Blit Zero					(R)	(man kann nur lesen)
     12 X								(nicht benutzt)
     11 X								(nicht benutzt)
     10	BlitterNasty (BlitPri)		(R/W)	(R/W = sowohl lesbar als auch
											 beschreibbar)
      9	Master (DmaEnable)			(R/W) - "allgemeiner Schalter"
      8	DMA BitPlane (RASTER)		(R/W) - auch genannt BPLEN
      7 DMA Copper					(R/W) - auch genannt COPEN
      6 DMA Blitter					(R/W) - auch genannt BLTEN
      5 DMA Sprite					(R/W) - auch genannt SPREN
      4 DMA DISK					(R/W) - auch genannt DSKEN
      3 DMA Audio3 (Stimme 4)		(R/W) - nämlich AUD3EN
      2 DMA Audio2 (Stimme 3)		(R/W) - nämlich AUD2EN
      1 DMA Audio1 (Stimme 2)		(R/W) - nämlich AUD1EN
      0 DMA Audio0 (Stimme 1)		(R/W) - nämlich AUD0EN

* SET / CLR
- Bit 15 ist sehr wichtig: wenn es gesetzt ist, werden beim Schreiben in $96
  die Bits, die auf 1 gesetzt sind zum Einschalten der relativen DMAs
  verwendet, während wenn Bit 15 auf 0 steht, dann werden die 1-Bits zum
  Ausschalten der entsprechenden Kanäle verwendet.

 Lassen Sie es mich erklären: Um einen oder mehrere Kanäle ein- oder
 auszuschalten müssen die relevanten Bits auf 1 gesetzt werden, was entscheidet
 ob die Kanäle ausgeschaltet oder eingeschaltet werden sollen ist Bit 15:
 Wenn es 1 ist, schalten es sie ein. Bei 0 schalten es sie aus immer unabhängig
 von ihrem vorherigen Zustand. Nehmen wir an, Sie wählen die zu bearbeitenden
 aus und entscheiden dann, ob Sie ausschalten (0) oder einschalten (1) wollen
 basierend auf Bit 15.
 Nehmen wir ein Beispiel:

			;5432109876543210
	move.w #%1000000111000000,$dff096	; Bits 6, 7 und 8 sind eingeschaltet
			;5432109876543210
	move.w #%0000000100100000,$dff096	; Bits 5 und 8 sind AUS.

N. B .: DIE BITS 14-10 BETREFFEN DEN BLITTER UND DIE CHIP-CLOCK-ZYKLEN,
      EIN THEMA DAS WEITER UNTEN AUSFÜHRLICH BEHANDELT WIRD.
      IN DIESER LEKTION WERDEN SIE NICHT VERWENDET.

* BlitBusy
- Bit 14 ist schreibgeschützt (Sie können es NUR aus $dff002 lesen) und es
 dient dazu zu wissen, ob der Blitter zu diesem Zeitpunkt "blittet"
 (d.h. arbeitet). Dieses Bit wird verwendet, um zu wissen, ob der Blitter
 arbeitet oder nicht. Tatsächlich ist es, wie wir später sagen werden, nicht
 möglich, die Register des Blitters zu verändern, während der Blitter noch
 blittet ... in der Tat ist es möglich, aber eine Katastrophe würde passieren!
 Sie müssen also mit einem btst warten, bis dieses Bit 0 ist, bevor sie den
 Blitter wieder verwenden.

* Blit Zero
- Bit 13 wird nur dann gesetzt, wenn das Ergebnis eines Blitts 0 ist, d.h. wenn
 der RAM der mit einem Blitt verändert wurde, vollständig auf 0 gesetzt wurde. 
 Es kann in vielen Situationen vorkommen, obwohl es praktisch ist, dieses Bit
 nur in seltenen Fällen auf die Wahrheit zu lesen (z.B.: prüfen, ob zwei
 BOB-Objekte kollidieren ohne den Arbeitsspeicher zu verändern), aber das
 werden wir später noch vertiefen.
 
- Die Bits 12-11 werden im Moment von der Maschine nicht verwendet.

* BlitPri
- Wenn Bit 10 gesetzt ist, verwendet der Blitter alle verfügbaren
 Chip-Buszyklen. Er "stiehlt" sogar die wenigen, die dem armen 68000 zur
 Verfügung stehen. Wenn dieser auf den Fast RAM oder den ROM zugreift, wird er
 nicht verlangsamt, andernfalls wird er sogar beim Zugriff auf den Chip 
 gestoppt. In der Praxis hat der Blitter, wenn dieses Bit auf 1 steht, eine
 volle, bzw. einen fast vollständigen Vorrang vor dem 680x0.
 
* DmaEn / Master
- Bit 9 ist der allgemeine Schalter: Es muss auf 1 gesetzt werden um die DMAs
 der verschiedenen Geräte zum Laufen zu bringen. Sie können beispielsweise
 durch Ausschalten vorübergehend alle Kanäle deaktivieren, ohne einen Reset
 des ganzen Registers durchzuführen.

- Die Bits 8-0 werden zum Ein- und Ausschalten der DMA-Kanäle der 
 verschiedenen Geräte verwendet.

Grundsätzlich sind nur die Bits 10-0 mit Bit 15 umschaltbar.
Versuchen wir zum Beispiel, nur die DMAs der Bitplanes, des Coppers und das
Blitter DMA einzuschalten. Dazu müssen Sie zunächst die Register zurücksetzen.
Schalten Sie alle Kanäle aus und deaktivieren Sie damit unerwünschte DMA und
dann werden die gewünschten DMAs eingestellt:

	move.w	#$7fff,$dff096			
						; $7fff = %0111111111111111
						; das heißt: alles aus: das
						; Bit 15 ist daher NULL
						; alle 1 bedeuten
						; in diesem Fall AUSSCHALTEN.
			; 5432109876543210
	move.w	#%1000001111000000,$dff096	; 
						; Bits 6,7,8,9 gesetzt, das heißt
						; Blitter, Copper, bitplane
						; und Hauptschalter Bit 15 ist 1,
						; alle 1 bedeutet 
						; in diesem Fall EINSCHALTEN
						
Der Wert $7fff ist %0111111111111111, daher werden alle DMA-Bits zurückgesetzt.
Dann werden die DMAs des Coppers, der Bitplanes und des Blitters und der
Master eingestellt und dank Bit 15 auf 1 gesetzt!

DIE FUNKTION DIESES WICHTIGEN REGISTERS IST ANALOG ZU DEM REGISTER 'INTENA' UND
'INTREQ', DARUM NICHT WEITERMACHEN, BIS SIE KEINE ZWEIFEL HABEN ÜBER DIE
FUNKTION VON BIT 15 ALS BIT "EIN- / AUSSCHALTEN".

In den Listings, die wir bisher gesehen haben, wurden die Register $dff096
(DMACON) und $dff002 (DMACONR) nie verwendet, weil wir davon ausgegangen
sind, das die DMA-Kanäle von Copper, Bitplane und Sprites aktiviert sind.
In der Tat, zum Zeitpunkt der Ausführung des Programms können Sie am ASMone
Bildschirm sehen, dass sowohl COPPER als auch BITPLANE DMA aktiviert sind. 
Der Mauszeigerpfeil zeigt an, dass er mit dem DMA SPRITE angezeigt wird.
Aber bei der Programmierung auf der Hardware-Ebene dürfen keine Kompromisse
gemacht werden. Wir dürfen nicht "hoffen", dass alles so ist, wie wir es
wollen. Wir haben bereits gesehen, wie wichtig es ist, ALLE Register der 
Copperlist zu setzen wie BPL1MOD, DIWSTART / STOP usw. zu setzen, um zu
vermeiden, dass sie "falsche" Werte enthalten.
Wir werden dasselbe mit den DMA-Kanälen tun: Wir werden ihren Zustand zu Beginn
des Startvorgangs speichern, dann schalten wir sie alle aus und nur die 
gewünschten schalten wir ein und schließlich versetzen wir die DMA-Kanäle
wieder in ihren Ausgangszustand Zustand zurück, genau wie bei der Copperliste.
Wir haben gesagt, dass zum Lesen des DMACON-Status das Lesen von DMACONR
d.h. $dff002, erforderlich ist.

Eine "sichere" Routine könnte sein:

	move.w	$dff002,OLDDMA	; DMACONR - Status der DMA speichern

Jetzt können wir es nach Belieben ändern, indem wir auf das Register $dff096
schreiben:

	move.w	#$7fff,$dff096	; DMACON - Alle Kanäle zurücksetzen

			; 5432109876543210
	move.w	#%1000001110100000,$dff096 ; einschalten Copper,Bitplane und Sprite

Nun müssen wir zuerst den alten Wert in den Ausgang zurücklegen, bevor wir das
Programm verlassen. Aber ACHTUNG! Wir können OLDDMA nicht direkt in DMACON
($dff096) schreiben, so wie wir es von DMACONR ($dff002) gelesen haben, weil
Bit 15, das SET / CLR, beim Lesen immer Null ist.
Dadurch das der Wert von Bit 15 zurückgesetzt ist, werden die Bits nicht
gesetzt. Das Einschalten der DMA-Kanäle würde sie schließlich ausschalten.
Es ist daher notwendig, zuerst Bit 15 des in OLDDMA gespeicherten Wertes zu
setzen, so dass die gesetzten Bits als "EINSCHALTEN" zählen. Aber wie setzt
man Bit 15 eines Wortes? Es gibt unendlich viele Möglichkeiten. Eine wäre die
Verwendung der BSET Anweisung, zum Beispiel:

	move.w $dff002,d0				; Mit Ausnahme der DMACONR in d0
	bset.l #15,d0					; Bit 15 (SET / CLR)
	move.w d0,OLDDMA				; und speichern Sie den Wert in OLDDMA
	...
	bsr.w Routinen
	...
	move.w #$7FFF,$dff096			; Alle Kanäle zurücksetzen
	move.w OLDDMA(PC),$dff096		; reaktiviere nur diejenigen, die 
	rts								; am Anfang aktiv waren.

Ansonsten kann die ODER-Anweisung verwendet werden. Erinnern wir uns an seine
Wirkungsweise:

 0 ODER 0 = 0
 0 ODER 1 = 1
 1 ODER 0 = 1
 1 ODER 1 = 1
  
Das Beispiel oben würde werden:

	or.w	#$8000,OLDDMA		; $8000 = %1000000000000000, d.h., Bit 15 auf 1

Wie Sie der obigen Tabelle entnehmen können, kommen die genullten Bits in das
Ziel. In diesem Fall werden die niederwertigen 15 Bits zurückgesetzt. Also die
ersten 15 Bits von OLDDMA bleiben nach diesem ODER unverändert (0 ODER 0 = 0,
0 ODER 1 = 1). Da das Bit 15 gesetzt ist, haben wir 1 ODER 0 = 1, also setzen
wir das Bit 15 und die anderen 14 Bits bleiben unverändert. Das gleiche wie bei
BTST #15,d0.
Beim startup ist es besser, das ODER zu verwenden, da auch andere Register 
zusätzlich zu DMACON gespeichert werden. Dies ist INTENA ($dff09a Schreiben und
$dff01c Lesen), INTREQ ($dff09c Schreiben und $dff01e Lesen) und ADKCON
($dff09e Schreiben und $dff010 Lesen). Für den Moment kann ich nur
vorwegnehmen, das die Register wie DMACON bitmaskiert werden und analog
funktionieren mit dem Bit 15, das als SET / CLR dient. INTENA und INTREQ werden
für Interrupts verwendet, während ADKCON für verschiedene Aufgaben für DISK
DRIVE und AUDIO dient. Wir werden sehen, wie man diese Register benutzt, wenn
Interrupts und Audio behandelt werden. Jetzt wollen wir ihren Zustand zusammen
mit dem DMACON speichern. Nun wollen wir sehen, wie man diese 4 Register
speichert:

	LEA	$DFF000,A5				; Basis der CUSTOM-Register für Offsets
	MOVE.W	$2(A5),OLDDMA		; alten Status von DMACONR speichern
	MOVE.W	$1C(A5),OLDINTENA	; alten Status von INTENA speichern
	MOVE.W	$10(A5),OLDADKCON	; alten Status von ADKCON speichern
	MOVE.W	$1E(A5),OLDINTREQ	; alten Status von INTREQ speichern

Jetzt müssen wir Bit 15 von allen 4 Wörtern, die mit den Labeln OLDDMA,
OLDINTENA, OLDADKCON, OLDINTREQ gekennzeichent sind, setzen, um den
Ausgangswert wiederherzustellen. Beachten Sie, dass die 4 Label
nacheinander eingefügt werden:

OLDDMA:							; alter Status DMACON
	dc.w	0
OLDINTENA:						; alter Status INTENA
	dc.w	0
OLDADKCON:						; alter Status ADKCON
	DC.W	0
OLDINTREQ:						; alter Status INTREQ
	DC.W	0

Hier kommt das OR ins Spiel. Für ein Wort machen wir ein OR.w #$8000,dest.
Damit können wir mit nur einem ODER ein Wort arrangieren. Mit einem
OR.l #$80008000,dest !!! können wir mit einem ODER 2 Wörter erreichen.
In diesem Fall reichen ein paar dieser ODERs für 4 Wörter:

	MOVE.L	#$80008000,d0		; die High-Bit-Maske vorbereiten
								; zum Setzen der Bits die in den
								; Worten gespeichert wurden 
	OR.L	d0,OLDDMA			; Bit 15 aller gespeicherten Werte setzen
	OR.L	d0,OLDADKCON		; der Hardware-Register,  unverzichtbar für
								; das zurücksetzen dieser Werte in die
								; Register.

Hier haben wir mit ein paar Anweisungen alle 4 Register gespeichert und
"gesetzt" die wir danach sofort zurücksetzen werden:

	MOVE.L	#$7FFF7FFF,$9A(a5)	; Deaktivieren INTERRUPTS & INTREQS
	MOVE.L	#0,$144(A5)			; SPR0DAT - Wert auf Null!
	MOVE.W	#$7FFF,$96(a5)		; Deaktivieren DMA

An dieser Stelle können wir nur die DMA-Kanäle aktivieren, die wir benötigen.
Am Ausgang genügt es, alle Register zurückzusetzen und wiederherzustellen:

	MOVE.W	#$7FFF,$96(A5)			; Deaktiviert alle DMAs
	MOVE.L	#$7FFF7FFF,$9A(A5)		; Deaktiviert INTERRUPTS & INTREQS
	MOVE.W	#$7fff,$9E(a5)			; Deaktiviert der ADKCON-Bits
	MOVE.W	OLDADKCON(PC),$9E(A5)	; ADKCON 
	MOVE.W	OLDDMA(PC),$96(A5)		; den alten DMA-Status zurücksetzen
	MOVE.W	OLDINTENA(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQ(PC),$9C(A5)	; INTREQ

Nichts könnte einfacher sein! Wir haben jetzt die vollständige Kontrolle über
die DMA-Kanäle und wir sind sicher, dass wir sie aktivieren und deaktivieren
können, da sie am Ausgang wiederhergestellt werden.

Um unseren Startup abzuschließen, könnten wir einen EQUATE definieren. 
Erinneren sie sich, was die EQUATES sind? Die Assembler-Direktiven EQU oder =
definieren die Gleichheit zwischen beliebig erfassten Wörtern und Zahlen, zB:

CANE	EQU	10
GATTO	EQU	20

	MOVE.L	#CANE,d0	; wird assembliert als MOVE.L #10,d0
	MOVE.L	#GATTO,d1	; assembliert als MOVE.L #20,d1
	ADD.L	d0,d1		; Ergebnis = 30
	rts

Equates sind ähnlich wie Labels, enden jedoch nicht mit einem ":". Anstelle von
EQU können sie auch das Gleichheitszeichen (=) verwenden: 

CANE	=	10

Wir könnten einen EQU für die einzustellenden DMA-Kanäle definieren:

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper- und DMA-Bitplane aktiviert
;		 -----a-bcdefghij

;	a: Blitter Nasty   (Im Moment ist es uns egal, lassen wir es auf Null)
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die
;						 Sprites)
;	c: Copper DMA	   (Wenn es zurückgesetzt ist, wird die Copperlist nicht
;						 ausgeführt)
;	d: Blitter DMA	   (Im Moment ist es egal, setzen wir es zurück)
;	e: Sprite DMA	   (Beim Zurücksetzen verschwinden nur die 8 sprites)
;	f: Disk DMA		   (Im Moment sind wir nicht interessiert, setzen wir es
;						 zurück)
;	g-j: Audio 3-0 DMA (Wir setzen es zurück und lassen den Amiga stumm)

Wie Sie sehen können, müssen die Bits 15 und 9 IMMER GESETZT sein, da eines
davon das SET / CLR und der andere der Master, der Generalschalter ist.
Im Listing können Sie Folgendes eingeben:

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane und copper

Auf diese Weise können wir zu Beginn des Listings den zu ändernden EQU haben,
mit einer nachfolgenden kurzen Zusammenfassung der Bedeutung der Bits.

Aber sehen wir uns den Startup an, laden Sie Listing8a.s in einen Textpuffer
und studieren Sie es. Im abschließenden Kommentar gibt es einige Anmerkungen
zu einigen geringfügigen Änderungen.

 З                                                                З
   І                          . .__                                 :
   :                          З^ЗЏЏ\                              __Ё__
_ _|__  _______ ____________  /\    \______________ _________ ____\  //____ _
Џ Џ|ЏЏ  ЏЏЏЏЏЏЏ ЏЏЏЏЏЏЏЏЏЏЏЏ\/  \    ЏЏЏЏЏЏЏЏЏЏЏЏЏЏ ЏЏЏЏЏЏЏЏЏ ЏЏЏЏЏ\//ЏЏЏЏЏ Џ
   :                  _ј ,       \__. .                             І
   І                 //\/         ЏЏЗ^З   /\__. .                   :
   З                '/\                  /  ЏЏЗ^З                   :
_ _|___ ____________/ /_____ _________  /     /\________ ______ ____|______ _
Џ Џ|ЏЏЏ ЏЏЏЏЏЏЏЏЏЏЏЏЏ ЏЏЏЏЏЏ ЏЏЏЏЏЏЏЏЏ\/     /  ЏЏЏЏЏЏЏЏ ЏЏЏЏЏЏ ЏЏЏЏ|ЏЏЏЏЏЏ Џ
   І                            .    . .__  /                       З
   :                   "COi! аe$ІgN" З^ЗЏЏ\/                        :
   .                                                                З
   З                                                                .
   .                                                                .

Nun, da wir das "universelle" Startup haben, können wir es auch in eine Datei
packen und es zu Beginn der nächsten Listings in mit der INCLUDE - Direktive
einfügen, die wir bereits verwendet haben, um die Musik Routine einzufügen.
Beginnen Sie einfach jedes Listing mit einem:

	Section	UsoLaStartUp,CODE

*****************************************************************************
	include	"startup1.s"	; mit diesem include ersparen wir es uns,
							; es immer neu zu schreiben!
*****************************************************************************

Beachten Sie, das der Start des Startup1.s ohne SECTION ist, also müssen wir
die SECTION-Direktive CODE oder CODE_C vor jedem include eingeben.
Das Startup führt ein "BSR.S START" aus, also starten wir das Listing mit:

START:
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren Bitplane, copper
								; und Sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger auf COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

Beachten Sie, dass $dff000 in a5 steht. In diesem Fall habe ich es genutzt.

Es sieht nach einem perfekten Startup aus, aber es fehlt ihm noch das
Sahnehäubchen. Dieses Sahnehäubchen ist die Möglichkeit, das Programm mit einem
icon ohne Probleme von der WorkBench zu starten. In der Tat, solange wir es von
cli / shell starten brauchen unsere Programme nur diesen Startup, aber wenn Sie
ein Icon designen wollen um das Programm mit einem Doppelklick von der
WorkBench aus zu starten, müssen sie einige Anweisungen hinzufügen. Es ist nur
eine bürokratische Formalität, aber wenn es nicht bei großen Programmen gemacht
wird, die auch Speicher zuweisen, kann es passieren das am Ende nicht der
gesamte Speicher wieder freigegeben wird.
Folgendes müssen Sie am Anfang hinzufügen:

ICONSTARTUP:
	MOVEM.L	D0/A0-A1/A4/A6,-(SP)	; speichern der Register auf dem stack
	SUBA.L	A1,A1
	MOVEA.L	4.w,A6
	JSR	-$126(A6)					; _LVOFindTask(a6)
	MOVEA.L	D0,A4
	TST.L	$AC(A4)					; pr_CLI(a4) wir laufen von CLI?
	BNE.S	FROMCLI					; Wenn ja, überspringe die Formalitäten
	LEA	$5C(A4),A0					; pr_MsgPort
	MOVEA.L	4.W,A6					; Execbase in a6
	JSR	-$180(A6)					; _LVOWaitPort
	LEA	$5C(A4),A0					; pr_MsgPort
	JSR	-$174(A6)					; _LVOGetMsg
	LEA	RETURNMSG(PC),A0
	MOVE.L	D0,(A0)
FROMCLI:
	MOVEM.L	(SP)+,D0/A0-A1/A4/A6	; Register wiederherstellen vom stack
	BSR.w	MAINCODE				; unser Programm ausführen
	MOVEM.L	D0/A6,-(SP)
	LEA	RETURNMSG(PC),A6
	TST.L	(A6)					; Wir fingen von CLI an?
	BEQ.S	ExitToDos				; Wenn ja, überspringe die Formalitäten
	MOVEA.L	4.w,A6
	JSR	-$84(A6)					; _LVOForbid - Achtung! Es ist keine 
	MOVEA.L	RETURNMSG(PC),A1		; Genehmigung erforderlich
	JSR	-$17A(A6)					; _LVOReplyMsg
ExitToDos:
	MOVEM.L	(SP)+,D0/A6				; exit code
	MOVEQ	#0,d0
	RTS

RETURNMSG:
	dc.l	0

Ich werde nicht ausführlich auf die Aufrufe der Systembibliotheken eingehen.
Es genügt zu sagen, dass dies die Formalitäten sind, über die ich gesprochen
habe. Wenn Sie ein Programm von der Workbench starten, das diesen Code nicht am
Anfang hat, ist das größte Problem, das beim Beenden dieses Programms, der
Speicher den es belegt hat, nicht wieder freigegeben wird!!!
Wie Sie sehen, wird zu Beginn geprüft, ob das Programm von der CLI oder von der
WorkBench aus gestartet wurde, wobei ein spezielles Systemflag geprüft wird.
Wenn das Programm von der CLI gestartet wurde, werden die Formalitäten die bei
der Ausführung von der WB folgen übersprungen, ansonsten werden diese
Formalitäten ausgeführt.
Anstatt diesen Teil mit dem anderen Startup zu verbinden, sollten Sie daher
auswählen, ob Sie es aufnehmen möchten oder nicht, da einige Assembler
einschließlich der modifizierten ASMONE-Version des Kurses, bei der Ausführung
eine Endlosschleife verursachen, da es scheinbar von der WorkBench geladen
wurde, aber wenn die "Formalitäten" durchgeführt werden, scheint es dann
umgekehrt zu sein . Andere Versionen von Asmone oder andere Assembler führen
diesen Code stattdessen stillschweigend aus, aber aus Gründen der
Kompatibilität mit jedem Assembler schlagen wir es getrennt vor:

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

Auf diese Weise schließen wir es bei den Assemblieren und Testen mit "J" nicht
ein. Vor dem Speichern der endgültigen ausführbaren Datei mit "WO" fügen wir es
hinzu.

Laden Sie die Listing8b.s, das erste Listing, das den universellen
Startvorgang, durch einbinden durch INCLUDE verwendet. Es umfasst die
Verwendung sowohl von Bitplanes als auch von Sprites, für die Sie Tests
durchführen können, um das Verhalten der DMA-Kanäle zu überprüfen.
__   __            __            __     __            __            __   __
 /\_/_/\__   __   / /\__   __   / /\   /\ \   __   __/\ \   __   __/\_\_/\
/ / \_\/_/\_/_/\_/_/ / /\_/_/\_/_/  \_/  \_\_/\_\_/\ \ \_\_/\_\_/\_\/_/ \ \_
\/     \_\/ \_\/ \_\/_/ / \_\/ \ \  / \  / / \/_/ \ \_\/_/ \/_/ \/_/     \/_
-:-----:------------\_\/--------\_\/---\/_/--------\/_/---------------------

Haben Sie Angst, wenn Sie die NEUE Routine sehen, die auf die vertikale Zeile
wartet? Nun, es ist nichts Monströses, aber sie ist viel besser.
Analysieren wir die alte "Routine":

	cmp.b	#$xx,$dff006		; VHPOSR

Nun, wir überprüfen einfach das Byte $dff006, das die vertikale Position des
elektronischen Rasterstrahls in den Bits 0 bis 7, das heißt von $00 bis $ff
enthält. Aber wie Sie von der Verwednung des WAIT in der Copperliste wissen,
überschreitet der elektronische Rasterstrahl die Zeile $FF, was in Wirklichkeit
nicht die Zeile 200 in einem normalen Bildschirm ist.
Um die Positionen hinter dem $FF mit dem COPPER WAIT zu erreichen, haben wir
gesehen, dass wir auf das Ende dieser Zone warten müssen:

	dc.w	$FFDF,$FFFE			; Warten auf das NTSC-Zonenlimit

Danach startet der Zähler ab $00

	dc.w	$0007,$FFFE			; Warte auf Zeile $100
	dc.w	$0107,$FFFE			; Warte auf Zeile $FF+$01=$101

Nun zu $38. Nun, das Byte in $dff006 verhält sich ebenso: Nachdem die Position
$ff erreicht ist wird Rasterzeile $100 in $dff006 als $00 dargestellt. Das
geht bis Zeile $138 (mit $38), wonach ein neuer Frame mit $00 beginnt, der
wahren NULL, um dann wieder zu $ff zu gehen und dann das andere $38 zu
bekommen usw.
Deshalb wird in den Listings immer auf die Zeile $FF oder die $80 gewartet, 
denn das Warten auf die Zeile $00 oder die Zeile $20 mit dem $dff006 hätte 
bedeutet, die Routine 2 mal pro Frame auszuführen, da $00 in Zeile $00 und in 
Zeile $100 vorkommt. Aber wie können wir sicher auf die ersten 38 Zeilen und
die Zeilen nach dem $ff warten? Kurz gesagt, Sie brauchen eine Routine, die
ohne Fehler auf jede der 312 Abtastzeilen warten kannn.
Es ist nicht schwierig, da das HIGH-Bit, das achte, sehr nahe an $dff006 ist, 
genau genommen ist es im $dff005, dem ersten Byte.
Wir müssen genauso vorgehen wie bei der vertikalen Position der Sprites, d.h.
wir haben das hohe Bit getrennt. In diesem Fall befindet es sich jedoch nicht
im Speicher, sondern um das betreffende Byte. Analysieren wir die Situation:

$dff004 Byte, das uns jetzt nicht interessiert, enthält das LOF-Bit für
		das Interlace
$dff005 wir sind interessiert Bit 0 ist V8, dh das High-Bit von der vertikalen
		Position
$dff006 jetzt wissen wir es! die Bits V7-V0, die niedrigen 8 Bits der
        vertikalen Position
$dff007 enthält die horizontale Position (H8-H1). Die Auflösung beträgt 1/160
		des Bildschirms. Jetzt interessiert uns das nicht wirklich !!!

Das $dff004/$dff005 ist das VPOSR-Register, während das $dff006/$dff007 das
VHPOSR ist. Jedes Register ist tatsächlich ein WORD lang. Wir können jedoch in
auf die Einzelbytes zugreifen. Um auf die Zeile $100 zu warten, können wir
Folgendes tun:

WaitVbl:
	btst.b	#0,$dff005
	beq.s	WaitVbl

Diese Routine wartet auf das Setzen des High-Bits V8. Wenn es gesetzt ist
bedeutet das, dass wir an der Zeile $100 sind oder in jedem Fall danach. Um
eine UNIVERSAL-Routine auszuführen, können wir Folgendes tun: (a5 = $dff000)

Waity1:
	MOVE.L	4(A5),D0	; $dff004 und $dff006, nämlich VPOSR und VHPOSR
	LSR.L	#8,D0		; verschiebt die Bits um 8 Positionen nach rechts
	AND.W	#%111111111,D0	; Wählen Sie nur die Bits der vertikalen Position 
	CMP.W	#300,D0		; Zeile 300? ($12c)
	bne.s	Waity1

In diesem Fall haben wir $dff004/5/6/7 nach d0 kopiert, dann verschieben wir
das Ganze um 8 Bits nach rechts. Da die ersten 8 Bits von rechts mit der
horizontale Position des $dff007 belegt sind, die uns nicht interessiert,
bringen wir die vertikale Position ganz nach rechts. 
An dieser Stelle wählen wir mit einem AND nur die ersten 9 Bits, dh die des
$dff006 plus das hohe Bit des $dff005 aus. Auf diese Weise haben wir in d0 die
wahre Zeilennummer von 0 bis 312!
Ich erinnere Sie daran, dass der AND-Befehl diesen Effekt hat:

 0 AND 0 = 0
 0 AND 1 = 0
 1 AND 0 = 0
 1 AND 1 = 1

Tatsächlich ergibt AND nur dann 1, wenn das Bit des ersten Operanden und des
zweiten Operanden auf 1 steht. Der Befehl könnte übersetzt werden mit
"SIND DAS ERSTE UND DAS ZWEITE BIT 1?", WENN JA, ANTWORTEN SIE MIT 1, WENN NEIN
ANTWORTEN SIE MIT EINER NULL". Ein UND ist tatsächlich nützlich, um bestimmte
Bits einer Zahl zurückzusetzen. In unserem Fall haben wir die hohen Bits
zurückgesetzt:

	AND.W	#%00000000000000000000000111111111,d0

Vielleicht erscheint es hexadezimal klarer:

	AND.W	#$000001FF,D0	; nur das low byte plus bit 8.


Der einzige Nachteil besteht darin, dass Sie 4 Anweisungen benötigen. Versuchen
wir, eine Routine zu schreiben die nur 3 Anweisungen verwendet:

WBLANNY:
	MOVE.L	4(A5),D0		; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	#$0001FF00,D0	; Wählen Sie nur die Bits des vertikalen Position
	CMP.L	#$00013000,D0	; warten auf Zeile $130 (304)
	BNE.S	WBLANNY

In diesem Fall arbeiten wir an dem ganzen longword, ohne die Bits zu
verschieben (shifting). Denken Sie daran, dass auf die zu wartende
Zeilennummer auf der linken Seite um 2 Ziffern verschoben ist. Um
beispielsweise auf die $FF-Zeile zu warten:

	CMP.L	#$0000ff00,D0	; warten auf Zeile $FF (255)

Es ist definitiv besser und schneller. Ich empfehle, dass Sie immer diese
Routine verwenden. Ansonsten, wenn es Ihnen nichts ausmacht, ein paar
Register mehr zu "verschmutzen", gibt es eine "gestörte" Version, die in
Listing8b.s enthalten ist:

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch AND
	MOVE.L	#$13000,d2	; zu wartende Zeile = $130 oder 304
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits des vertikalen Position 
	CMPI.L	D2,D0		; warten auf Zeile $130 (304)
	BNE.S	Waity1

Wie Sie sehen, ändert sich im Wesentlichen nichts, nur dass die Operationen nun
zwischen Registern anstelle von Konstanten ausgeführt werden und dies ist
schneller. Die Geschwindigkeit ist wichtig, denn wenn Sie zum Beispiel auf die
Zeile 50 warten müssen mit der ersten Routine, die wir gesehen haben, sie hat
auch ein LSR, wenn der Prozessor alle Tests beendet hat und feststellt, dass
wir jetzt in Zeile 50 sind, sind wir bereits in der Mitte von Zeile 50!!
Ich muss Ihnen nur raten, auf a5 oder a6 zu achten, je nachdem, welches
Register sie als Basis verwenden, das dort immer $dff000 ist, das es nicht von
einigen Unterprogrammen überschrieben werden darf. Um dies zu vermeiden, können
Sie die Register mit MOVEM wie oben beschrieben speichern, oder Sie können
ein LEA $dff000,a5 unter das "MOVE.L #$1ff00,d1" eingeben. Gleiches gilt für
die Register d0, d1 und d2. Stellen Sie sicher, dass sie nicht von anderen
Programmen verwendet werden, da Sie sie verändern.

Warten Sie schließlich niemals über die Zeile $138 hinaus, da es die letzte
ist oder die Routine wird in einer Endlosschleife blockiert.

Wenn das Video auf die NTSC-Frequenz (durch Reset $dff1dc) eingestellt ist,
wird der Grenzwert maximal auf die Zeile $106 festgelegt.

		 ииииииииииииииииииииииииииииииииииииииииииииииииииииииииииии
         ииииииииииииииииииииииииииииииииииииииииииииииииииииииииииии
         ииии                                                   Эииии
         ииии          ___                                      Эииии
         ииии      __ји@**#__                      ____цццц_    [ииии
         ииии     gиАЏ     А4ц_                __ји@ЄАЈЏЏЏЏЖ&   Ьииии
         ииии   ,иP          Ќ0ўИ           ,gиЄАЏ          0Q  [ииии
         ииии   и~  _______    Аи_         _иА   ___цциии,      Ьииии
         ииии       ииииииииm_   Аи_  _ ,_/иД _цииииииииД      Ьииии
         ииии       ААЄиииииииQ__  А#_и Iио _Циииииии@А         Эииии
         ииии      _    `ииииииииц_ ЌЂВ    dииибииииГ           ]ииии
         ииии     `ицИ   иии1 "ЂиииQ__    ЦиииД ЖиииИ           Ьииии
         ииии      Vи#_  #ииђ (ц Аииииј  иииА ц) Жии#    ,Ў     ]ииии
         ииии       и#и_ ЌиииQ___ииииии  Ћиииц__ Jиии   ИиF     Эииии
         ииии       Ќи_`N_ ЂиииииииВААЏ___ЌА0ииииииии  _иА      [ииии
         ииии        АиЕиб&_ ЈААА~   Ииииии, Џ~АААА"_.јиЙ       ]ииии
         ииии          #и ЌиQ_       Ќи' ЌЄА  ___цциЄАиP        Iииии
         ииии           `W_иP4MјцццццццццццциииЄА"и _иА         ]ииии
         ииии            Ќии_ 0FЏЏ7#ЏЏЏЌиЏЏЏЏTи   ии@Д          Ьииии
         ииии             Ќ#иииц._рW___jи____jи_цјиГ            [ииии
         ииии               Ђ#иFЈАЖи^^Є4иЄЄААЂиии^              [ииии
         ииии                АЋN__IN_   и___циЛА                [ииии
         ииии                   А^Є*#ииии@ЄА"            xCz    Iииии
         ииии                                                   Эииии
         ииииL__________________________________________________Iииии
         ииииииииииииииииииииииииииииииииииииииииииииииииииииииииииии
         ииииииииииииииииииииииииииииииииииииииииииииииииииииииииииии

Nun, da wir die Nützlichkeit von AND / OR / LSR-Anweisungen zum Speichern der
DMA und zur besseren Kontrolle der VBLANK-Linie gesehen haben, kommen wir zu
neuen Anwendungen dieser logischen Anweisungen. Es besteht kein Zweifel, zu 
analysieren, wie eine Fade-Routine (Überblendroutine) oder ein überblenden 
einer Figur von schwarz allmählich in Richtung einer vollen und hellen Farbe 
(und umgekehrt) geht.
Zuerst wollen wir sehen, wo wir operieren müssen:

CopColors:
	dc.w $180,0,$182,0,$184,0,$186,0
	dc.w $188,0,$18a,0,$18c,0,$18e,0
	....

In der copperliste sind die Farbregister. Was wir tun müssen, ist anstelle
dieser Nullen die richtigen RGB-Werte (genau das Wort: $0RGB) zu setzen und
"sie zu erhöhen", so dass wir mit verschiedenen Schritten, einer pro Frame,
die Farben unserer Figur bekommen:

CopColors:
	dc.w $180,$000,$182,$fff,$184,$200,$186,$310
	dc.w $188,$410,$18a,$620,$18c,$841,$18e,$a73
	...

Zuerst müssen wir die Liste der Farben der Figur in einer Tabelle haben und
"konsultieren", ansonsten würden wir nicht wissen, wann wir "angekommen" sind:

TabColoriPic:
	dc.w $fff,$200,$310,$410,$620,$841,$a73,...
	...

(HINWEIS: color0, $dff180, ist in dieser Tabelle nicht eingefügt, weil es
schwarz ist, $000. Es bleibt immer schwarz und wir verwenden es in der Routine
nicht. Stattdessen beginnen wir mit color1, $dff182, was in diesem Fall $FFF
ist.)

Um diese Tabelle zu erstellen, kopieren wir die copperliste mit dem Editor und 
entfernen einfach $180, $182, $184 "von Hand" und natürlich bleiben die Farben
erhalten.

Nun da wir die Tabelle mit den "Zielfarben" haben, wie kann man eine Routine
machen, welche "die richtigen Farben" in der Tabelle "erhöht"?
Sicherlich müssen wir auf jede der 3 RGB-Komponenten separat arbeiten. Um sie
zu trennen, können wir das AND verwenden, das, wie wir gesehen haben, nur ein
Teil von Bits "auswählt" und die anderen nullt. Die Adresse der Tabelle mit den
Farben haben wir in a0. Lassen Sie uns am Beispiel sehen, wie nur die blaue
Komponente getrennt wird:

	MOVE.W	(A0),D4		; Setzen Sie die Farbe aus der Farbtabelle in d4
	AND.W	#$00f,D4	; Nur die blaue Komponente auswählen ($RGB -> $00B)

Jetzt haben wir in d4 nur den Wert der Farbe BLAU... wenn es die Farbe $0123
war haben wir in d4 danach den Wert $0003. Durch das AND.w #%000000001111,d4
werden nur die 4 Bits oder das Nibble des Wertes ausgewählt. Also haben wir das
Unternehmen erfolgreich abgeschlossen. 
Mal sehen, wie man die grüne Komponente auswählt:

	AND.W	#$0f0,D4	; nur die grüne Komponente ($RGB -> $0G0) auswählen

und rot:

	AND.W	#$f00,D4	; nur die rote Komponente ($RGB -> $R00) auswählen 

Soweit sollte es klar sein.
Nun konnten wir bereits die "FAKE"-Routine, die "FALSCHE", durchführen, die auf
diese Weise arbeitet. Jedes Mal, wenn Sie #1 zu der einzelnen Komponente
hinzufügen und mit der Farbe in der Tabelle vergleichen, um zu sehen, ob wir
das Hinzufügen zu dieser Komponente stoppen müssen. Wenn wir zum Beispiel die
Farbe von $0235 haben, werden wir diese Schritte in jedem Frame haben:

1)	$111	; +$111, alle 3
2)	$222	; +$111, alle 3
3)	$233	; +$011, die ROTE Komponente ist in Ordnung, 
			; ich füge nur Grün und Blau hinzu
4)	$234	; +$001, Die ROTE und GRÜNE Komponente ist in Ordnung, nur Blau +1 
5)	$235	; +$001, wie oben nur blau +1 

Jedes Mal sollten wir die ROT-Komponente der Farbe mit einem CMP mit dem
Tabellenwert vergleichen und wenn wir es nicht erreicht haben addieren wie 1
hinzu. Wenn wir es erreicht haben addieren wir nicht. Dann machen wir dasselbe
mit GRÜN und BLAU. Schließlich kombinieren Sie die 3 "resultierenden"
Komponenten mit einem oder mehreren ODER-Anweisungen, um das resultierende
Farbwort in die Copperlist zu schreiben. Und dies für jede der 16, 32 Farben
oder wieviele es sind. Die Menge ist für den Prozessor kein Problem, mit
DBRA-Zyklen kann er alles machen.
Das einzige Besondere ist, dass das von mir beschriebene System nicht sehr
genau ist, und insbesondere bei AGA sehen wir, dass die Farben ihren eigenen
Weg gehen. Daher bleibt die Struktur der Routine gleich, aber wir müssen die
Art und Weise der Berechnung ändern. Zuerst müssen wir eines beachten: Wie
viele Frames also wie oft sollten wir die Routine aufrufen, um eine
vollständige Überblendung durchzuführen? Wenn wir zum Beispiel die Farbe $0F3,
ein schönes Grün haben und bei $000 beginnen und jedes Mal 1 addieren, würde es
mit der obigen Routine 15 add.w #$010 für die grüne Komponente erfordern, da
sie den Wert $f (15) erreichen muss.
Betrachten wir also eine "parametrische" Routine, die die Farben in einer der
16 möglichen PHASEN der Überblendung berechnen kann, wobei Phase 0 das
vollständig SCHWARZ und Phase 16 die volle Farbe ist. Nehmen wir an, wir halten
"die Zählung" der durchzuführenden Phase in einem Label "FaseDelFade" fest.
Jedes Mal müssen wir Folgendes tun:

	addq.w	#1,FaseDelFade	; System für die nächste Phase zu tun

Daher werden wir beim ersten Frame ein "BSR.s Fade" mit "FaseDelFade" auf 1
machen und die Farben werden sehr dunkel sein. Das nächste Frame ruft die
Routine neu auf, aber mit "FaseDelFade" bei 2, und die Farben werden heller
(2/16 der vollen Farbe). Schließlich wenn wir es mit "FaseDelFade" mit 3
ausführen, werden die Farben gleich denen in der Tabelle sein. Zuerst bezog
sich der Bruch auf 2 Sechzehntel der Farbe und ich habe die verwendete 
Technik vorweggenommen!
In der Tat während eine Fake-Routine, einer der schrecklichen Fade-Routinen
ist, die einfach 1 addiert, ist zwar nicht bruchstückhaft genau, aber was wir
jetzt tun werden, ist akzeptabel. Kommen wir zur Sache: Mit der Fake-Routine
kämen wir in folgenden Schritten zu einem $084:

 $011
 $022
 $033
 $044
 $054
 $064
 $074
 $084

Wenn wir in die Mitte kommen, haben wir ein GRAU! $044 !! statt hellgrün.
In der Realität hätte es in der Mitte $042 oder dunkelgrün sein sollen. Was
aussieht wie 1/2 von $084. Nun kommt die Lösung: mit dem Wert "FaseDelFade",
dass wir MULTIPLIER nennen können. Wir haben das, wenn es 0 ist, müssen wir
0/16 (null sechzehntel) der Farben berechnen, das ist alles NULL.
Auf der anderen Seite müssen wir bei einem Wert von 1, 1/16 der Farben
berechnen. Also bis 16/16, wo die Farbe gleich bleibt.
Wie implementiere ich diese Formel in Anweisungen? Easy! Wenn ich eine
RGB-Komponente, zum Beispiel BLAU isoliert habe: (wir haben den MULTIPLIER
in d0)

	MOVE.W	(A0),D4		; Setzen Sie die Farbe aus der Farbtabelle in d4
	AND.W	#$00f,D4	; Nur die blaue Komponente auswählen ($RGB -> $00B)
	MULU.W	D0,D4		; Multipliziere mit der Fade-Phase (0-16)
	ASR.W	#4,D4		; 4 BITS nach rechts verschieben, dh durch 16 teilen
	AND.W	#$00f,D4	; Wählen Sie nur die BLAUE Komponente aus
	MOVE.W	D4,D5		; Speichern Sie die BLAU-Komponente in d5

In der Praxis multiplizieren wir die Komponente mit dem MULTIPLIER und teilen
es dann durch 16. Eine Division durch 16 entspricht einem ASR.W #4,Dx, wie wir
in der 8x8-Zeichen-Druckroutine bereits gesehen haben. Die MULU.W #8,Dx kann
durch ein LSL.w #3,Dx ersetzt werden. Betrachten Sie es als DIVU.w #16,D4 und
ANDe es am Ende.
Wiederholt man diese Prozedur 3 Mal für die 3 RGB-Komponenten, erhält man die 
FADE-Routine von SCHWARZ zu Farben, und wenn wir mit dem Multiplikator bei 16
beginnen, und jedes Mal #1 bis Null subtrahieren, erhalten wir die umgekehrte
Überblendung, von Farbe zu SCHWARZ. Letzteres wird FADE OUT genannt, während
ersteres FADE IN ist.

Wir können die Funktionsweise der beiden beschriebenen Routinen in den Listings
Listing8c.s und Listing8d.s in der Praxis sehen. Der Unterschied zwischen
diesen beiden Listings ist nur die Reihenfolge, in der die 
3 Divisionsoperationen der RGB-Komponenten ausgeführt werden, aber das
Prinzip der Multiplikation mit dem Multiplikator und die Division durch 16 ist
gleich. Das deutlichste ist vielleicht das von Listing8d.s.

Das Design ist ein Logo der RAM JAM-Gruppe von FLENDER, das aus Italien stammt.
Ich habe diesen Logo verwendet, weil ich mich dieser Gruppe gerade
angeschlossen habe, als ich diese Lektion schrieb. Also der Kurs von hier an
ist eine RAM JAM Produktion !!!

Wir fahren mit einer Variation des Themas fort und laden Listing8e.s. Das ist
die selbe Routine, mit einer geringfügigen Änderung, die Sie in Betracht ziehen
sollten, wenn sie eine zusätzliche dominante Komponente hinzuzufügen wollen,
die dem Design einen Schatten gibt. Es kann nützlich sein, dem Ganzen eine 
karnevalistische Note zu verleihen.

Abschließend möchte ich Ihnen eine Routine vorstellen, mit der Sie von einer
beliebigen Farbe aus zu irgendeiner anderen Farbe wechseln können! In der
Praxis werden zwei Tabellen benötigt, eine mit den Anfangsfarben, zum Beispiel,
wenn Sie mit Schwarz angefangen haben, einer Tabelle mit vielen Nullen und
einer anderen mit den endgültigen Farben. Um die erste Überblendung, d.h. von
Schwarz zu normalen Farben zu machen, muss man als erste Tabelle eine komplett
zurückgesetzte und als zweite die mit den Farben haben, um von den Farben zu
Schwarz zu wechseln, (FADE OUT), muss man als erste Tabelle diejenige mit den
normalen Farben und als zweite vollständig zurückgesetzt haben.
An dieser Stelle sind hier die Neuerungen: Zum Beispiel können wir eine
Überblendung von WEISS zu normalen Farben machen, in dem wir in die erste
Tabelle alles $FFF packen und die zweite mit den normalen Farben machen.
Wir übertreiben: Wir können von einer Farbe zur nächsten wechseln! Stelle
einfach in die erste Tabelle die Farben die wir am Anfang haben wollen und in
die zweite Tabelle, die Farben die wir am Ende haben wollen. Auf diese Weise
können wir von einem grünen zu einem bläulichen Schatten gehen usw.
Laden Sie Listing8f.s und probieren Sie die Routine aus, die die Beispiele
dafür zeigt. Die Funktionsweise der Routine ist ziemlich kompliziert, und ich
möchte sie nicht wiederholen. Wenn Sie versuchen wollen, es zu verstehen, lesen
Sie meine (wenigen) alten Kommentare. Allerdings lernen Sie wenigstens, es
für Ihre eigenen Zwecke zu nutzen!


               ,јиииииm                              И____
               иVД   ЌиQ                             иўЄ4и,
            _јци#__  .иF       ________              и   и#цииц_
           .и^Ј~АЂиа  `и_ __gјииииииииии#јц___       и&  VоА~ЏАиL
           `иј_   __   ЌииииииЛ^^ААААААЄ*0иииииј__ _Ци~   _____Jи
            ЌЂиц_јииј__иииГ"               Ќ~^ЋиииииP   _јииииииА
               ААА  А#ии/    Иgццц___           ЌА#ииц_јиА
                     ииP     #иииииииц_       ___  А4иииИ
       _____________ ииЬ      А _FАииии_    _Ц**иЎ_  "0и#_ _____________
       \___          ии#        и   АЂииL  Ци  _ `иь   Жии_         ___/
         T           Жии       0и  (ј Ќииb иЭ (и) иf    Жии,         T
         |            #и#И     (и&____јиЄА А#И   _иД     ииQ         |
         |             0ии__    А^ЄЄЄА" __  Ќ^***ГД      ииV         |
         |              Аиииц______    ,ии             _ции'         |
         |                АЋиииииии   ииии   ________циии@~          |
         |                 _ии~ЈииP  `ААЄ*  јиииииииииоАЏ            |
         |        _цииN___ииА  _ии  _       0_ЏЏЏЌ4и_                |
         |      ,ииАЏЏ"0ииА  Ијии" _и .     `и_    Аиц_   _          |
         |      lи      ^  __иииЙ ,и" Ц  иQ  Ќи,     Аииииии_        |
         |      Ќиц__g#   јиЄ~иД  иА ,и  ии   #ии__    АЏЏ Ќи,  xCz  |
     _ __І_______ЌА^Єии   Жи Ии__Ци__иP  ии   ЖииЂи_    ____иf ______І__ _
         :           иђ___ии #иииииииииијииццции' Ќ4#   ииЄЄА        :
         .           "Ђиии@   ~~Џ ЏЌ"А^^ЄЄЋ**ииГ   lи   Юи           .
                         Џ                          иL__Ци
                                                    А**ЄА

Jetzt möchte ich Ihnen drei Listings anbieten, die Arbeit vieler "Studenten"
die von Null anfingen mit meinem Kurs, genau wie Sie, ermutigend?

Listing8g.s		- Parallaxe 10 Ebenen (von Federico Stango)

Listing8h.s		- Bedienfeld mit Gadgets (von Michele Giannelli)

Listing8h2.s	- Scrolltext 8X8 (von Lorenzo Di Gaetano)

Diese drei Listings verwenden nur die Kenntnisse der Diskette 1 des Kurses.
Ich habe nur den Start geändert und statt der alten Methode zum Initialisieren 
der Diskette 1 das startup1.s eingefügt. Ich hoffe sie machen auch ihre
"eigenen" Tests, ansonsten lesen Sie alles wie ein Roman? Wake up !!!
Und wenn Sie etwas Schönes gemacht haben, versuchen Sie es mir zu schicken,
zumindest werde ich es in die nächsten Lektionen hineinstecken und sie werden
berühmt als Fiorello.

Lassen Sie uns nun mit einer häufig gestellten Frage fortfahren: "Wie
funktionieren die Equalizer die in der kleinen AMIGAET.EXE-Demo auf Diskette 1
des Kurses vorgestellt werden?" Nun, ich habe diesen Teil des Listing
"herausgeschnitten". Sie können sehen, wie das alles funktioniert in
Listing8i.s.

Achtung: Die "music.s" -Routine von Diskette 2 ist nicht dieselbe wie die von
Diskette 1. Die 2 Änderungen betreffen die Entfernung eines BUGs, ​​der manchmal
dazu führte, dass ein Guru das Programm beendete und die Tatsache, dass mt_data
ein Zeiger auf die Musik, auf keine Musik zeigt. Dies ermöglicht es Ihnen, die
Musik einfacher zu ändern, um Musikdisketten zu erstellen, wie in Listing8i2.s
zu sehen.

Wir haben Equalizer gemacht, aber wir haben noch nicht gesehen, wie man einen
Punkt druckt, d.h. "plot a dot". Lassen Sie uns dies sofort mit Listing8l.s
beheben.

(dann Plotten verschiedener Ebenen mit 3d_stars.s)

Ok, jetzt, da wir wissen, wie man die Punkte druckt, lassen Sie uns so viele
nebeneinander drucken um "Linien" zu machen, in Listing8m.s und Listing8m2.s.

Nun, wenn Sie Linien machen können, können Sie auch parabolische Kurven machen,
multiplizieren Sie einfach X * X in Listing8m3.s, Listing8m4.s, Listing8m5.s

Nun wollen wir sehen, wie die Punktdruckroutine "optimiert" werden kann. Wie
sie gesehen haben, hat es eine Multiplikation, die sehr schlecht ist, weil sie
langsam ist. Wie kann man sie "entfernen"? Wir müssen mit 40 multiplizieren, 
also führen wir einfach alle möglichen Multiplikationen, d.h. die ersten 256
Vielfache von 40 aus, und schreiben die Ergebnisse in eine Tabelle. 
Nun haben wir in dieser Tabelle alle "Ergebnisse" der betreffenden
Multiplikation nach dem verschiedenen Fällen. Stellen Sie einfach sicher, dass
jedes Mal das richtige Ergebnis aus der Tabelle "genommen" wird, so wie wir das
richtige X oder Y aus den Tabellen der Koordinaten für Sprites genommen haben.
Lassen Sie es uns in der Praxis in Listing8n.s sehen.

Lassen Sie uns überprüfen, ob die neue Routine tatsächlich schneller ist als
die alte beim Schreiben und Löschen des gesamten Bildschirms in Listing8n2.s

Da wir gesehen haben, wie man einen Punkt löscht (einfach einen BCLR anstatt
von BSET) versuchen wir, einen Punkt zu "animieren", wie wir es für Sprites
beim Schreiben und Löschen in jedem Frame an verschiedenen Positionen in
Listing8n3.s getan haben.

Versuchen Sie, modifizierte Versionen zu erstellen, mit mehr Bitebenen, mit
mehr als einem Punkt auf einmal und so weiter. Um auf 2 Bitebenen, d.h.
4 Farben, zu drucken, können Sie dies tun: color0 ist der Hintergrund, 
während wir 3 verschiedene Farben zum Plotten haben. Angenommen, Sie haben
2 Bitebenen mit dem Namen "Bitplane1" und  "Bitplane2", könnten Sie 3 Routinen
erstellen, eine, die in Bitplane1 plottet, eine die in Bitplane2 zeichnet,
und eine, die in beiden Bitplanes zeichnet, und zu einer dieser dieser 
3 Routinen springen, um in einer der 3 Farben zu drucken.

- Unglaublich! Lorenzo di Gaetano schrieb sein Listing im Handumdrehen! 
  siehe: Listing8n4.s

Ich stelle mir vor, Sie haben ein Programm erstellt, das megakomplexe
Funktionen untersucht, welches Wellen zeichnet wie das des Quark-Kürzel. Dann
können Sie eine kurze Werbepause für copper waits machen, die nicht für die
Punktroutine verwendet werden. Schauen sie sich an was mit wait und color0
ohne die Hilfe einer Bitplane alles möglich ist, in Listing8o.s 
Es gibt keine Tricks, nur dass die Kupferliste sowohl "gebaut" als auch
modifiziert wird. Hier ist die Routine, die das herausragende Stück der
copperliste "erstellt":

; INITCOPPER erstellt den Teil der Copperliste mit vielen WAIT und COLOR0 unten

INITCOPPER:
	lea	barcopper,a0		; Adresse, an der die copperlist erstellt werden
							; soll 
	move.l	#$3001fffe,d1	; erstes wait: Zeile $30 - WAIT in d1
	move.l	#$01800000,d2	; COLOR0 in d2
	move.w  #coplines-1,d0	; Anzahl der copper Zeilen
initloop:
	move.l	d1,(a0)+		; leg das WAIT
	move.l	d2,(a0)+		; leg das COLOR0
	add.l	#$02000000,d1	; nächstes Mal warten, 2 Zeilen tiefer warten
	dbra	d0,initloop
	rts

Wie Sie sehen können, ist das Ergebnis dieser Routine die Erstellung von:

barcopper:
	dc.l	$3001fffe		; wait Zeile $30
	dc.l	$01800000		; color 0
	dc.l	$3201fffe		; wait Zeile $32
	dc.l	$01800000		; color 0
	dc.l	$3401fffe		; wait Zeile $34
	dc.l	$01800000		; color 0
	....

Überlegen Sie, wie viel Platz und wie viel Zeit wir auf diese Weise sparen.

	                             ________
	                      ___---'--------`--..____
	,-------------------.============================
	(__________________<|_)   `--.._______..--'
	      |   |   ___,--' - _  /
	      |   |  |            |
	   ,--'   `--'            |
	   ~~~~~~~`-._            |  _
	              `-.______,-'  (і)
	                           '(_)`
	                            Џ Џ


Um die Lektion zu beenden, halte ich es für angebracht, eine Eigenschaft des
Prozessors zu behandeln, der obwohl sehr wichtig, bis jetzt nicht diskutiert
wurde. In der Tat glaubt man genug über den 68000 zu wissen, aber in
Wirklichkeit wurde es bisher nur "mit Rosenwasser" untersucht, das absolute
Minimum um einige Routinen auszuführen. In der Tat wurden die Bedingungscodes
(Condition Codes) nicht benannt, und mit ihnen das CCR, das Teil des SR 
(Status Register) ist.
Hier sind die 16 Bits, aus denen sich das Register zusammensetzt:

SR:
								___
	15	T - TRACE					\
	14	- nicht benutzt 68000		 |
	13	S - SUPERVISOR				 |
	12	- nicht benutzt 68000		 |- SYSTEM BYTE
	11	-							 |
	10	I2 \						 |
	9	I1  > INTERRUPT MASK		 |
	8	I0 /					  ___/
	7	-							\
	6	-							 |
	5	-							 |
	4	X - EXTENSION				 |- USER BYTE (Condition Code Register)
	3	N - NEGATIVE				 |  (enthält die arithmetischen Flags)
	2	Z - ZERO					 |
	1	V - OVERFLOW (Überlauf)		 |
	0	C - CARRY	 (Übertrag)  ___/

Nun, dieses mysteriöse Register enthält Informationen über die Bedingungs
FLAGs, genau genommen sein niedriges Byte, genannt CCR (Condition Code
Register) enthält diese FLAGs. Wir werden das High-Byte des SR behandeln, wenn
wir über INTERRUPT und SUPERVISOR MODE sprechen.
Im Moment kann ich nur davon ausgehen, dass der Prozessor auf zwei Arten
arbeiten kann: im USER- und im SUPERVISOR-Modus. Normalerweise werden die
Programme die wir schreiben im USER-Modus ausgeführt. Wenn wir Interrupts
brauchen, werden wir sehen, wie wir vom Supervisor-Modus in den User-Modus
und umgekehrt wechseln können, aber einige Anweisungen können nur im
SUPERVISOR-Modus ausgeführt werden, wenn Sie versuchen sie im USER-Mode
auszuführen, geht alles in ein tiefes Koma. Diese Anweisungen sind wie wir
sagen PRIVILEGIERT, also pass auf!

Vorerst wird es ausreichen, das Low-Byte, des CCR, das SR zu verstehen. Jeder
ausgeführte Befehl, kann die Flags beeinflussen, zum Beispiel bei einer
Subtraktion mit einem negativen Ergebnis wird das N-Flag gesetzt. Wenn das
Ergebnis Null ist, wird das Z-Flag gesetzt. Bei einer Addition die zu einer
größeren Zahl führt, zum Beispiel: von dem in D0.l enthaltenen Wert setzen wir
das V-Bit, overflow, welches uns anzeigt, dass das Ergebnis nicht im Ziel
gespeichert werden kann. Dies gilt auch für den Carry, also den Übertrag, der
im Falle eines Übertrags gesetzt wird.
Sie können die Flags selbst überprüfen, indem Sie das CCR-Byte testen. Der
68000 ist der beste Prozessor der Welt, es gibt genug Anweisungen, um den
Status der Flags zu kennen: Es ist das Bcc, wobei cc für Condition Codes
(Bedingungscode) steht und es kann durch CS, EQ, GE, GT, HI, LE, LS, LT, MI, PL
... ersetzt werden.
Erinnern sie sich daran, als wir über die Funktionsweise von CMP-Anweisungen
gefolgt von BEQ und BNE sprachen, haben wir die Tatsache erklärt, dass das
BEQ / BNE wusste, wie der CMP ablief, weil das Ergebnis des CMP auf einen
"Zettel" geschrieben wurde? Nun, der "Zettel", auf den der CMP das Ergebnis für
die BEQ / BNE schreibt, ist das SR, das niedrige Byte vom CCR!! In Wirklichkeit
besteht dieser Zettel aus 4 Bits, plus einem fünften, genannt eXtend, das einen
besonderen Zweck erfüllt.
Durch diese 4 Bits können viele "Situationen" erzeugt werden, nicht nur BEQ und
BNE, sondern wir können wissen, ob eine Zahl größer oder kleiner als eine
andere ist. Wenn zwei Zahlen gleich sind, wenn ein Übertrag in einer Operation 
auftritt, wenn das Ergebnis negativ ist, etc. Hier sind alle Bccs:

	bhi.s	label	; > für vorzeichenlose Zahlen
	bgt.w	label	; > für alle Zahlen mit Vorzeichen
	bcc.s	label	; > auch genannt BHS, Carry = 0 (ohne Vorzeichen)
	bge.s	label	; >= für alle Zahlen mit Vorzeichen
	beq.s	label	; = für alle Zahlen
	bne.w	label	; >< für alle Zahlen
	bls.w	label	; <= für alle Zahlen ohne Vorzeichen
	ble.w	label	; <= für alle Zahlen mit Vorzeichen
	bcs.w	label	; < für vorzeichenlose Zahlen; auch BLO genannt, BLO,
					; bedeutet, dass der Carry = 1 ist
	blt.w	label	; < für Zahl mit Vorzeichen
	bpl.w	label	; wenn Negative = 0 (PLus)
	bmi.s	label	; wenn Negative = 1, (Minus) Zahlen mit Vorzeichen
	bvc.w	label	; V=0, kein OVERFLOW (einschränkendes Ergebnis)
	bvs.s	label	; V=1 OVERFLOW (Ergebnis zu groß um
					; im Ziel enthalten zu sein)

Nun wollen wir sehen, wie die Bccs nach CMP.x OP1, OP2 verwendet werden

	beq.s	label	; OP2 =  OP1 - für alle Zahlen
	bne.w	label	; OP2 >< OP1 - für alle Zahlen
	bhi.s	label	; OP2 >  OP1 - ohne Vorzeichen
	bgt.w	label	; OP2 >  OP1 - mit Vorzeichen
	bcc.s	label	; OP2 >= OP1 - ohne Vorzeichen, auch genannt *"BHS"*
	bge.s	label	; OP2 >= OP1 - mit Vorzeichen
	bls.w	label	; OP2 <= OP1 - ohne Vorzeichen
	ble.w	label	; OP2 <= OP1 - mit Vorzeichen
	bcs.w	label	; OP2 <  OP1 - ohne Vorzeichen, auch genannt *"BLO"*
	blt.w	label	; OP2 <  OP1 - mit Vorzeichen

Und jetzt, wie man sie nach einem TST.x OP1 benutzt

	beq.s	label	; OP1 =  0 - für alle Zahlen
	bne.w	label	; OP1 >< 0 - für alle Zahlen
	bgt.w	label	; OP1 >  0 - mit Vorzeichen
	bpl.s	label	; OP1 >= 0 - mit Vorzeichen (oder BGE)
	ble.w	label	; OP1 <= 0 - mit Vorzeichen
	bmi.w	label	; OP1 <  0 - mit Vorzeichen (oder BLT)

Wie Sie sehen können, können Sie nach einem CMP eine Menge wissen! Ja, sie
können die Zeichen > (größer), >= (größer oder gleich), =, >< (verschieden),
<= (weniger oder gleich), <(weniger) und darüber hinaus gibt es ein Bcc von
diesen für Vergleiche für normale Zahlen und eins für vorzeichenbehaftete
Zahlen (mit Vorzeichen).
Bezüglich der negativen Zahlen haben wir bisher nur erwähnt, dass zum Beispiel:
-1 = $FFFFFFFF, -5 = $FFFFFFFB ist, wodurch mehr oder weniger das jeweilige
high bit, das ist Bit 31, wenn wir im Langwort, Bit 15, wenn in .w und Bit 7,
wenn wir in .b sind, ausschlaggebend ist.
Das heißt für das Vorzeichen, wenn es auf 1 ist, ist die Zahl negativ und es
geht weiter zurück von $FFFF mit dem Wert -1 zu $​​FFFE mit dem Wert -2, für -3
wird $FFFD verwendet usw., bis zu $8001 (in .w Feld), das ist -32767,
gefolgt von $8000, das ist -32768, was die negativste Zahl in einem Wort mit
Vorzeichen ist und entspricht %1000000000000000, d.h. dem High-Bit des
gesetzten Vorzeichens und die vorherigen Stellen sind alle gelöscht:
Wir begannen mit -1, das ist %111111111111111.
Dieses System mit negativen Binärzahlen wird als Zweierkomplement bezeichnet.
Wir wissen bereits, dass das höchstwertige Bit, d.h. das Bit das am weitesten
links steht für das Vorzeichen steht: wenn es 0 ist die Zahl positiv, wenn es
1 ist, ist die Zahl negativ. Dieses System ist sowohl für Byte-Nummern (das Bit
ist 7) ​​als auch .word (das Bit ist 15) und für longword (das Bit ist 31)
gültig.
Nun wollen wir im Detail sehen, wie das Zweierkomplement der beiden
funktioniert: Wir haben bemerkt, dass es nicht ausreicht, das höchstwertige Bit
zu ändern, um von positiv zu negativ zu ändern. Nehmen wir das Beispiel von +26
und -26 im Feld .word:

		;5432109876543210
	+26	%0000000000011010	($001A)
	-26	%1111111111100110	($FFE6)

Bit 15 in +26 wird zurückgesetzt und in -26 gesetzt, aber offensichtlich ist es
nicht die einzige Änderung, die gemacht werden muss, um von -26 auf -26 zu
kommen !!! Es ist erforderlich, das Zweierkomplement von %0000000000011010 zu
erstellen, das aus der UMKEHRUNG alle Bits und ADD 1 zum Ergebnis besteht.
Lassen Sie uns versuchen, ob es wahr ist: Indem wir alle Bits invertieren, die
wir erhalten:

	%1111111111100101

wir fügen 1 hinzu:

	%1111111111100101 +
			1 =
	-----------------
	%1111111111100110

Wenn Sie die Zeile mit Einsen verwirrt, isolieren Sie die 6 niedrigen Bits:
%100101 (25) und addieren 1 = %100110, also 26, mit Bits 7 bis 15 sind alle 1,
also -26. Wenn wir -26 in einem Byte haben wollen, reichen nur %11100110 oder
$E6 aus. Wenn wir -26 in einem longword haben wollen:
%11111111111111111111111100110 = $FFFFFFE6
Wir können wählen, ob wir unsere Bytes (Wort oder Long) mit Vorzeichen oder
ohne Vorzeichen verwenden möchten. Die Verwendung hängt von den Anweisungen in
unserem Programm ab. Zur Verdeutlichung kann Folgendes enthalten sein:
a .b, a .w oder a .l, abhängig vom verwendeten System, wenn "normal" oder
"Zweierkomplement:

	BYTE mit Vorzeichen	 .8 bit	 - von -128 ($80) bis +127 ($7f)
	BYTE ohne Vorzeichen .8 bit	 - von 0 ($00) bis 255 ($ff)
	WORD mit Vorzeichen	 .16 bit - von -32768 ($8000) bis +32767 ($7fff)
	WORD ohne Vorzeichen .16 bit - von 0 ($0000) bis 65535 ($ffff)
	LONG mit Vorzeichen	 .32 bit - von -2147483648 ($80000000) bis
									   +2147483648 ($7fffffff)
	LONG ohne Vorzeichen .32 bit - von 0 ($00000000) bis 4294967299 ($ffffffff)

Wie Sie sehen, werden die Zahlen im SIGNED BYTE-Feld zwischen 128 und 255,
als Werte von -128 und -1 betrachtet. Im SIGNED WORD Feld werden die Werte
zwischen 32768 und 65535 als Werte zwischen -32768 und -1 betrachtet.
Dasselbe Wert für die .longword-Notation.
Zusammenfassend gibt es zwei Möglichkeiten, aus dem Positiven eine negative
Zahl zu erhalten:

System 1:

Wenn die Zahl N = %00110 (6 Dezimal) gegeben ist. Um -N zu finden, wird
die Negation Bit für Bit von N durchgeführt, N = %11001 (-7 Dezimal) und
dann 1 zum Ergebnis addiert:

N = %11001 + %00001 = %11010 (-6 Dezimal)

System 2:

Die Zahl N = %00110 (6 Dezimal) um -N zu finden, wird die Negation von N 
Bit für Bit bis auf die niedrigstwertige 1 gemacht, N = %11010 (-6 dezimal).

Wenn wir in unserer Routine nie unter Null gehen, ist es gut ein Byte mit
seinen 255 Werte zu benutzen. Wenn wir stattdessen von -50 auf +50 gehen
wollen, müssen wir Anweisungen wie BGT, BLE, BLT,die
vorzeichenbehaftete Zahlen vergleichen, anstelle von zum Beispiel von
BHI und BLS verwenden, vorzeichenlose Zahlen vergleichen.
Addition und Subtraktion funktionieren mit vorzeichenbehafteten und
vorzeichenlosen Zahlen während Multiplikationen und Divisionen dies nicht tun.
Es gibt tatsächlich zwei Arten von Anweisungen vorzeichenlose und
vorzeichenbehaftete Zahlen: MULU und DIVU für Zahlen ohne Vorzeichen und
MULS und DIVS für vorzeichenbehaftete Zahlen.

Nachdem wir die negativen Zahlen geklärt haben, sehen wir uns die Bits des CCR,
d.h. die Flags, einzeln an:

* Bit 0 - Carry (C): Wird auf 1 gesetzt, wenn das Ergebnis einer Addition einen
Übertrag ('Carry') erzeugt, oder wenn der Subtrahend größer als der Minuend
ist, dh wenn eine Subtraktion ein "Darlehen/Entlehnung" erforderte. Das 
Carry-Bit enthält außerdem das das höher- oder niederwertige Bit eines
Operanden, der einer Verschiebung oder Rotation unterliegt. Es wird auf Null
gesetzt, wenn es keine Überträge oder "Ausleihen" in der letzten Operation
gibt. Eine Möglichkeit zum Setzen des CARRY-Flag ist zum Beispiel:

	move.l	#$FFFFFFFF,d0
	ADDQ.L	#1,d0

Das Ergebnis ist d0 = 00000000, wobei die CARRY- und ZERO-Flags gesetzt sind,
weil wir das Maximum, das in .l enthalten sein kann, überschritten haben und
das Ergebnis ist auch NULL!. 

* Bit 1 - oVerflow (V): Es wird gesetzt, wenn das Ergebnis der letzten 
Operation zwischen vorzeichenbehafteten Zahlen zu groß ist, um im Zieloperanden
enthalten zu sein, zum Beispiel, wenn das Ergebnis die Grenzen -128 ... +127 im
Bytefeld überschreitet. zum Beispiel: Die Summe.b 80 + 80 erzeugt einen
Überlauf, da sie +127 überschritten hat. Im Feld .w sind die Grenzen
-32768 ... + 32767, und im Feld .l sind sie - / + 2 Milliarden. Beachten Sie,
dass die Summe 80 + 80 im Byte-Feld nicht das Carry und eXtend-Flags setzt,
sondern nur das oVerflow-Flag, da 160 nicht größer als 255 ist, das Maximum,
das in einem Byte für normale Zahlen enthalten sein kann.

* Bit 2 - Zero (Z): Wird gesetzt, wenn die Operation das Ergebnis Null erzeugt.
Dies ist auch nützlich um die Dekrementierung eines Zählers zu überprüfen,
sowie zum Vergleich von zwei gleichen Operanden.

* Bit 3 - Negativ (N): Es wird auf 1 gesetzt, wenn in einer Operation das hohe
Bit der Zahl (welche im Zweierkomplement-Format festgelegt ist) gesetzt ist. In
der Praxis, wenn das Ergebnis eine negative Zahl ist, wird dieses Bit gesetzt,
andernfalls zurückgesetzt. Das Zweierkomplement erhält man durch das
Komplementieren eines Operanden (d.h. alle Bits umkehren) und dann 1 addieren.
Zum Beispiel +26 ist in binär %000110010 - sein Komplement dazu ist %11100101 
Bitumkehrung Bit 0 in Bit 1 und umgekehrt). Wenn Sie 1 addieren, erhalten Sie
%11100110. Bit 7 wird als Vorzeichenbit bezeichnet und wird in Bit 3 des
Statusregisters kopiert. Im Fall von -26 wird N gesetzt, was eine negative Zahl
anzeigt.

* Bit 4 - Extend (X): ist eine Wiederholung des Carry-Bits und wird in
Operationen mit BCD - Notation (Binary Coded Decimal) verwendet. Die Zahl
Dezimal 20 wird beispielsweise nicht mit 00010100 dargestellt, sondern in der
Form zwei Zehner, Null-Einer 0010 0000) und bei 'erweiterten' binären
Operationen wie ADDX und SUBX, spezielle Versionen von ADD und SUB.

				  _____
				 /\___/\
				/_/__/  \
				\    \  /
				 \____\/
				      Y
				      :
				      .

In Anbetracht dieser neuen Erkenntnisse wird auf den Referenztext 68000-2.TXT,
über alle Anweisungen des Prozessors mit ihren Auswirkungen auf die CCR-FLAGs,
verwiesen, welche eine "Weiterentwicklung" des alten 68000.TXT der ersten
Diskette ist. Sollte mittlerweile Kinderkram für sie sein (oder nicht?).

Bevor Sie Lektion9.TXT starten, wäre es gut, wenn Sie den Text 68000-2.TXT
lesen würden, zumindest sind Sie dann mit den CPU-Anweisungen bestens
vertraut! Betrachten Sie es als Lektion8b.TXT, "DO IT" und nehmen Sie die
Essenz. Ich gebe zu, dass es Sie erschrecken könnte (wenn sie mittelmäßig
bewaffnet sind), das alles zu lesen, aber wenn sie einmal vertraut mit dem
was in diesem schönen 100K-Text geschrieben steht können sie endlich
feststellen, dass Sie wissen, wie man den 68000 programmiert.
Übrigens, wenn Sie später Anweisungen finden, die Sie nicht kennen, können Sie
sich nicht beschwere, denn sie werden in 68000-2.TXT erklärt !!

Sehen Sie sich zunächst die CMP- und Bcc-Anweisungen an, in denen die
verschiedenen Bcc-Typen ausführlicher erklärt werden und beginnen Sie dann von
Anfang an und lesen bis zum Ende, lesen Sie es vielleicht mehrmals und machen
sie Pausen zwischen zwischen dem einen und dem anderen Lesen, während Sie ein
Sandwich essen.
Dieser 68000-2.TXT ist der zweite Felsbrocken den sie überwinden müssen. Der
erste war Lektion2.TXT, wo sie die ersten Grundlagen und Richtlinien gelernt
haben. Viele sind an diesem Hügel stehen geblieben. Jetzt da wieder ein Berg
vor ihnen steht, werden ebenso viele nicht den Mut haben, ihn zu zu überwinden.
Aber wer ihn überwindet, kann versuchen, den Gipfel zu erreichen!

Haben sie ihn mindestens einmal gelesen? Verstehen Sie die Bedingungscodes?
Hier sind einige Beispiele, an denen Sie überprüfen können, ob sie sie
verstehen. Sie wurden freundlicherweise von Luca Forlizzi (the Dark Coder)
und Antonello Pardi (Deathbringer) geschrieben, so kann ich das Schreiben der
AGA- und 3D-Lektionen beschleunigen.

Listing8p1a.s	-> CC in MOVE Anweisung
Listing8p1b.s	-> CC in MULU/MULS
Listing8p1c.s	-> CC in DIVU/DIVS
Listing8p2a.s	-> CC und Adressregister Ax
Listing8p2b.s	-> Erweiterung des Vorzeichens in den Adressregistern Ax
Listing8p3.s	-> CC in TST
Listing8p4.s	-> CC in AND,NOT,OR,EOR
Listing8p5.s	-> CC in NEG
Listing8p6.s	-> CC in ADD
Listing8p7.s	-> CC in CMP
Listing8p8.s	-> CC in ADDX
Listing8p9.s	-> CC in lsr,asr,lsl,asl

Laden Sie zum Schluss mein Listing8p9b.s, das auch eine "Frage" enthält.

		   ____________________
		   \                  /
		    \________________/
		   _( o..       ..o  )_
		  /  )(\__     __/) (  \
		 (  /  \/ /   \ \/   \  )
		 /\(     (    _)      )/\
		 \_/\ __  \___/    __/\_/
		     \\\_________ ( /
		      \\_|_|_|_|7  /
		       \\|_|_|_|/ /
		        \________/

Bevor wir zur nächsten Lektion übergehen, gibt es ein paar Dinge, die ich dir
gerne sagen möchte. Mein Freund, der das Abenteuer plant. Michele, fragte mich
einiges, als er mich das letzte Mal besuchte und ich nehme an, dass es auch für
viele von euch interessant ist. Er hat ein Bedienfeld am unteren Rand erstellt,
ähnlich wie in Listing8h.s, und im oberen Teil zeigt er verschiedenen Bilder
an, die er von der Diskette lädt. (wir werden später erfahren, wie Sie Dateien
mit der Systembibliothek dos.library hochladen).
Das Problem ist, dass er die .raw der Bilder hatte, aber die Paletten für jedes
Bild musste im Hauptprogramm in vorbereiteten Tabellen gehalten werden. Eine
für jedes Bild, und eine Routine zum Kopieren der richtigen Farben aus der
Tabelle in die Copperlist entsprechend dem geladenen Bild. Dies brachte jedoch
den Code durcheinander, da es Dutzende von Bildern gibt. 
Dann habe ich daran erinnert, dass Sie mit den iff-convertern, einschließlich
des KefCon, AUCH DIE PALETTE am Ende der .RAW-Datei speichern können! Ändern
Sie einfach die Option CMAP OFF in BEHIND und am Ende der .raw-Datei wird die
Palette von color0 bis zum letzten Wort angehängt. Sie können auch BEFORE
auswählen, wodurch die Palette vor dem Bild eingefügt wird, aber in diesem Fall
müsste man auf "nach der Palette" zeigen.
Festgestellt, dass es besser ist (am Ende), mit dem CMAP BEHIND, wollen wir 
die Änderungen an der gespeicherten .raw-Datei mal sehen.

Die Datei ist dieselbe, aber länger, im Fall des Logos dieser Lektion ist sie
16 Wörter länger. In der Tat hat es 16 colors.w am unteren Rand mehr, als wie
in diesem Beispiel (um es zu verstehen):

inizio_pic:
	incbin	'logo320*84*16c.raw'	; bitplanes.raw normal
	dc.w $000,$fff,$200,$310		; palette
	dc.w $410,$620,$841,$a73
	dc.w $b95,$db6,$dc7,$111
	dc.w $222,$334,$99b,$446
fine_pic:

Ich habe das Logo entsprechend in diesem Format gespeichert. Lasst sie uns
sehen mit welcher einfachen Routine sie die Palette in die copperliste kopieren
können, in Listing8q.s. Beachten Sie, dass das Bild, wenn es gezeigt wird,
normalerweise auch in den vorherigen Listings funktioniert. Tatsächlich haben
wir nur "zusätzliche" Wörter, die nicht angezeigt werden, da sie "nach" dem 
Ende der letzten Bitebene liegen.

Eine weitere Frage, die mir gestellt wurde, lautet: Woher wissen Sie, welcher
Prozessor und welches Kickstarter in der Maschine steckt? In Listing8r.s wird
dieses Geheimnis gelüftet... 
Schauen Sie einfach in den entsprechenden Bits nach, die für diesen Zweck
vorgesehen sind!

Wenn Sie also überzeugt sind, dass Sie bis hierher alles verstanden haben,
können Sie die Lektion9.TXT laden, das Ihnen ENDLICH den Blitter vorstellt.
Bis zu diesem Punkt haben Sie sich sicherlich gefragt, ob es ihn wirklich gibt.

Eine Anmerkung: Wenn Sie Englisch lesen können, ist es sicherlich nützlich,
diese grundlegenden Bücher zu haben:

Die zweite Ausgabe des Amiga-Hardware-Handbuchs:

"Amiga Hardware Reference Manual" ISBN: 0-201-18157-6

IN BEZUG AUF DEN 680x0:

Motorola, "MC68020 32-bit Microprocessor User Manual, fourth edition",
Prentice Hall ISBN 0-13541657-4

Motorola, "MC68030 Enhanced 32-bit Microprocessor User Manual, second edition"
Prentice Hall ISBN 0-13-566951-0,  Motorola ISBN 0-13-566969-3.

Motorola, "MC68040 32-bit Microprocessor User Manual"

Vielleicht sollten Sie nicht das 68000 Benutzerhandbuch, sondern das des 68040,
nehmen, weil der 68000 in der 68000-2.txt ganz gut erklärt wird (hoffe ich),
und der 68040 vorerst einigen wenigen Glücklichen vorbehalten ist, so dass
Demos oder Speiele die nur auf dem 68040 laufen, wenig Verbreitung finden
würden. Auch sind die großen Unterschiede zwischen dem 68000 und 68020, während
zwischen 68020 und 68030 die Unterschiede gering sind. Gleiches gilt für den
68030 im Vergleich zum 68040. Die wesentlichen Unterschiede sind in der MMU
und in den CACHE Steueranweisungen, aber für die Programmierung von Demos
und NICHT des Betriebssystems, interessieren die uns nicht sonderlich.

                                 _/\  /\  /\_
      _                          \ (_/  \_) /                          _
     _)\__________________________)  _/\_  (__________________________/(_
    (______________\_\__\___\________)  (________/___/__/_/______________)
        (_  ________________\_\__\___ \/ ___/__/_/_________________  _)
          \/                         \  /                          \/
                                    \/