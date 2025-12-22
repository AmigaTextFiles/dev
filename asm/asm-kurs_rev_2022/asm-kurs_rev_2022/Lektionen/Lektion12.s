
ASSEMBLERKURS - LEKTION 12

Autor: Fabio Ciucci

In dieser Lektion lernen Sie die Techniken zum Erreichen der KOMPATIBILITÄT von
ihrem Code kennen, eine sehr wichtige Sache: Überlegen Sie, wie wichtig es ist,
dass das Spiel oder das von Ihnen programmierte Demo auf allen Amiga-Modellen
funktioniert!!!
Dies ist nicht unbedingt schwierig, obwohl es bekannt ist, dass viele alte Spiele
und Demos nicht mit Kick 2.0, 68020, A1200 funktionieren. Es gibt Dinge, die nur
auf dem erweiterten A500 1.3 funktionieren. Einfach das Fast RAM oder das neue
Kickstart nehmen, und es funktioniert nicht mehr. Alle diese Probleme kommen von
ein paar Ursachen, immer die gleichen dummen Ursachen.
In der Tat 99% des Codes einer Demo oder eines Spiels, das nur auf dem A500 1.3
läuft, würde auf allen Amigas funktionieren, wenn nicht diese 2 oder 3 Zeilen von
"DIRTY"-Code, der alles zum Sargnagel macht, im Allgemeinen beim Booten.
Persönlich habe ich immer versucht, all diese BUGs zu verstehen. Das sind
Programmierfehler die nur sichtbar werden auf Maschinen über A500 1.3. Oft habe ich
es geschafft, zu FIXEN, das heißt, einige Spiele oder Demos, zu "reparieren" die
nicht funktionierten, indem ich den Code disassemblierte und die wiederkehrenden
Fehler im Code änderte. Auf diese Weise verband ich Arbeit mit Vergnügen: 
Von einem Teil, den ich mit Freunden gemacht habe, auf A1200 oder anderen Computern 
oder eine Demo die ihnen immer gefallen hat, die sie vorher immer auf der A500 1.3
hatten. Um zu sagen, auf der anderen Seite habe ich eine diskrete Kultur über die
Ursachen von "Sargnägeln" mit spektakulären Gurus festgestellt, und ich habe eine 
wenige Programmier-"Schraubstöcke" gefunden, die ich auflisten werde.
Aufgrund dieser Probleme hat sich der größte Teil der Software der direkt in
Assembler auf der Amiga-Hardware geschrieben ist den Ruf erarbeitet inkompatibel
und unsicher zu sein. So wurde Assembler selbst beschuldigt eine unsichere Sprache
zu sein, besonders das "Hardware Direct", das "Metalbashing".
All diese Probleme können leicht vermieden werden, machen Sie einfach bestimmte
Dinge nicht und sicherlich wird das Spiel / die Demo auf allen Amigas laufen.
Tatsächlich funktionieren beispielsweise alle Listings dieses Kurses auf dem 
Amiga500 1.3 wie auch auf Amiga 4000/040 und natürlich auch auf allen anderen
Zwischencomputern mit beliebiger Konfiguration.
Natürlich kann ich keine Kompatibilität mit hypothetischen Amiga Modellen 
mit RISC- oder AAA-Chipsatz garantieren, aber in diesem Fall würde NICHT EINER
funktionieren, geschweige denn Programme wie der Protracker. In der Tat hoffe ich,
dass es so ist 680x0-Serie beibehalten und Abwärts-Kompatibilität mit ECS
(mindestens) oder wir würden uns mit PCs, genannt "Amiga", aber nicht kompatiblen
MSDOS befinden.
Ich mache lieber 68060-basierte Computer mit 150 MHz, was nichts zu tun hat mit
Neid auf ein RISC und ein "lokaler Bus" des RAM-Chips, das ist ein schnellerer
Zugriff auf diese Art von Speicher als bei aktuellen Modellen. Es ist zu langsam
(verdammt C = Last-Minute-Ingenieure).
Ich habe mich erst jetzt mit diesem Thema befasst, auch weil, um es beim Thema
Fehlern es zumindest notwendig ist zu wissen, wie man programmiert, daher wäre
es nicht logisch diese Lektion einzusetzen, bevor wir die Grundlagen der 
Programmierung erläutern.
Nach dieser Lektion können Sie möglicherweise Ihr altes Spiel zum Laufen bringen!
Während des Kurses haben Sie gesehen "WIE MAN PROGRAMMIERT" mit allen richtigen
Verfahren. 
Ignorieren Sie also die dummen Dinge, die vor Jahren gemacht wurden. Hier ist
eine Liste von "typischen"-Fehlern, die ich in der Umgebung auf Programmen
gefunden habe, die nicht auf allen Maschinen funktionieren: (Test auf A4000 / 040)

******************************************************************************
 TEIL 1: FEHLER IN BEZUG AUF DIE REGISTER $dffXXX, d.h. COPPERLIST und BLITTER
******************************************************************************

1) Unter den "behebbaren" Fehlern finden wir die nicht so Schwerwiegenden, welche
   keine Fehler in alten Produktionen waren, da sie nichts über die AGA wissen
   konnten: Es wurde "vergessen", die AGA mit diesen 3 Anweisungen nach dem Zeigen
   auf die copperliste zurückzusetzen: (Nicht vorher!)

	lea	$dff000,a5			; Adresse CUSTOM base in A5 für offset
	move.l	#copper,$80(a5)	; COP1LC - Zeiger copperlist
	move.w	d0,$88(a5)		; COPJMP1 - Start copperlist

;	AGA deaktivieren:

	move.w	#0,$1fc(a5)		; reset sprites wide and DISABLE 64 bit burst
	MOVE.W	#$c00,$106(A5)	; reset AGA palette , sprite resolution
							; and double playfield palette
	MOVE.W	#$11,$10c(A5)	; reset AGA sprite palette

   Dieser Fehler kann behoben werden, indem der Computer durch Drücken beider
   Maustasten gestartet wird und wählen Sie die Emulation des alten Chipsatzes.
   Auf der anderen Seite enden die Probleme des coppers tatsächlich nicht, wenn
   sie vergessen, eines der COPPER-Register zu definieren, das den Fehler 
   verursacht! Tatsächlich habe ich viele copperlisten alter Demos / Spiele
   gefunden, die dies nicht tun. Sie haben die Modulos nicht definiert, also
   bleiben die Werte der copperliste des Systems, so dass man nie weiß, wie sie
   sind. In der Tat der häufigste Fehler ist, keine Modulo ($108 und $10a) zu
   setzen, vorausgesetzt, sie sind gelöscht.
   Dies war wahr für die KICKSTART 1.3!!! ABER AB 2.0 IST DAS MODULO NICHT NULL !!! 
   Das Intro / die Demo / die Spiele werden also in "Swipes" angezeigt, wenn nicht
   dieser Kickstart 1.3 geladen wird. Gleiches gilt für DiwStart / DiwStop und so
   weiter. Denken Sie IMMER daran, alle Register in der copperliste zu setzen auch
   wenn sie auf Null gesetzt sind, um unsichere Werte des Betriebssystems zu
   vermeiden!!!

	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
	dc.w	$8e,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2

   Ich fand auch andere dumme Fehler, in alten copperlisten.
   Einige stellten die Register NICHT ein, oder stellten auf mysteriöse Weise 
   ZU VIELE ein!!! Tatsächlich DÜRFEN SIE NIEMALS AUF EIN UNBEKANNTES ODER EIN
   NOCH NICHT VERWENDETES REGISTER ZUGREIFEN. Auf diese Weise riskieren Sie die
   Aktivierung seltsamer Eigenschaften in zukünftigen Chipsätzen. Im Moment ist die
   größte Entwicklung von ECS zu AGA, und die Fehler von "Blind Setting" sind mehr
   als ich erwartet hatte. Zum Beispiel fand ich diese Kuriosität in der
   copperliste eines sehr alten Ackerlight-Intros:

	....
	dc.w	$100,$5000	; BPLCON0
	dc.w	$092,$30	; DDFSTRT
;--->	dc.w	$106,$FE5	 ; Weil sie ein Register hinzugefügt haben welches zu
				  ; der Zeit nicht existiert. Auf der AGA verzerrt es die Palette
	dc.w	$102,$CC	; BPLCON1
	dc.w	$108,$A8	; BPL1MOD
	dc.w	$10A,$A8	; BPL2MOD
	....

   Dieser Fehler blieb unbemerkt, bis das AGA herauskam, und seien Sie vorsichtig,
   da dieser Fehler in der Tat fast ABSOLUT UNENTFERNBAR ist.
   Bevor ich das Material zerlege, das nicht funktioniert, mache ich alle möglichen 
   Tests um das Problem zu lösen: Ich entferne den Fastmemory, lade den Kick 1.3,
   ich deaktiviere die Caches, die MMU, setze den VBR zurück usw. Dieser Fehler
   zeigte sich jedoch: die Farben waren falsch, alles andere funktionierte. In der
   Tat ist die einzige Möglichkeit, diesen Fehler zu korrigieren, ihn zu finden und 
   im Code zu entfernen. Ich habe diese $106,$fe5 durch $92,$30 ersetzt. Ich habe 
   die vorherige Zeile repliziert und alles hat perfekt funktioniert.
   Vielleicht hat der Programmierer diesen Zug nicht einmal bemerkt, es kann sein,
   das es ein Tippfehler war. Vielleicht wollte er $108 schreiben und nicht $106, 
   wer weiß. Achten Sie darauf, nur an bekannten Registern oder Bits zu arbeiten,
   sonst können Sie die Enttäuschung bei ihren Enkelkinder sehen, wenn Ihre
   Produktion auf dem Amiga 9000 wegen einer blöden copperliste nicht funktioniert.
   Achten Sie auch auf die Strukturen der Sprites, da es bereits von OCS nach ECS
   zusätzliche Bits im vierten Steuerbyte gibt: viele Sprites erscheinen
   "schmutzig" oder bis zum Ende des Bildschirms gestreckt, weil NUR auf ECS/AGA-
   Maschinen und nicht auf alten A500 / A2000, die Bits anstatt zu löschen gesetzt
   sind, die Sprite-Verwaltungsroutine verlassen.
   Die Chip-Designer empfehlen, die nicht verwendeten Bits von bekannten Registern 
   CLEAR zu lassen und absolut nicht auf diejenigen zuzugreifen, die noch nicht
   bekannt sind. Ich rate Ihnen dringend, es nicht zu vergessen.

	-	-	-	-	-	-	-	-	-

2) Verwenden Sie den CLR-Befehl nicht für die Register $dffXXX, da dieser Befehl
   auf 68000- und 68020/30/40-Prozessoren sich tatsächlich anders verhält. Auf 
   68000 verursacht es ein Lesen und ein Schreiben, dh 2 Zugriffe, während es auf
   68020/30/40 nur einen Zugriff verursacht. Um unterschiedliche Ergebnisse zu
   vermeiden denken Sie bei verschiedenen Prozessoren daran, auf andere Weise auf
   die Register des Typ STROBE (COPJMP1 = $dff080, COPJMP2 = $dff088 usw.)
   zuzugreifen. Ein Weg kann sein ein MOVE.W d0,$dff080. Ich habe auch Probleme,
   wenn das CLR für andere $dffXXX Register verwendet wird, zum Beispiel $dff064
   (BLTAMOD).

Esempio1:
	MOVE.W	#0,$DFF088	; niemals CLR.W $dff088!
oppure:
	MOVE.W	d0,$dff088
	...

Esempio2:
	MOVE.W	#0,$DFF064	; niemals CLR.W $dff064!
oppure:
	MOVEQ	#0,d0
	MOVE.W	d0,$dff064
	...

   Aus Sicherheitsgründen empfehle ich Ihnen daher den Zugriff auf die Register 
   oder Werte direkt (#0,$dffxxx). Verwenden Sie niemals ein CLR in einem 
   $dffxxx-Register.

	-	-	-	-	-	-	-	-	-

3) In den Jahren 1988-1989 wurde eine ziemlich dumme Methode zur Ausrichtung auf 
   copperlisten verwendet was sich dann als inkompatibel mit den Versionen des 
   Betriebssystems ab 2.0 erwies, da Einrichtungen des Systems für selbst-
   verständlich gehalten wurden und das von Commodore natürlich nicht dokumentiert
   wurde. "Die Schlauen" änderten ihren Source, die nicht mehr auf die copperliste 
   vom A500+ und A600 zeigten.														
   Leider hat jemand mit nicht sehr viel Erfahrung bei der Programmierung Teile 
   alter Listings, die er fand kopiert und diesen lächerlichen Zeigercode von der  
   copperliste enthielt, den einige Demos von 1990-91 die Kickstart 1.3 erfordern,
   eingefügt.
   Hier ist der schmerzhafte Code, den ein "kluger" Codierungspionier erfunden hat:

	move.l  4.w,a6			; execbase
	move.l  (a6),a6			; ???
	move.l  (a6),a6			; HAHAHA! GFXBASE??? nur in kick1.3!
	move.l	$26(a6),OLDCOP	; HAHAHA! speichern alte COPLIST???
	move.l	#MYCOP,$32(a6)	; doppelt HAHAHAHA! Zeiger COPLIST???
	...

   Leider ist dieser Code in alten Listings sehr verbreitet (zB im Intro von
   ORACLE). Denken Sie IMMER daran, den darin enthaltenen DOUBLE-Fehler nicht zu
   begehen. Es sind 4 Zeilen SEHR SCHMUTZIGEN Codes: Zunächst wird die GFXBASE
   durch Öffnen der Grafikbibliothek wie in den Kursbeispielen gefunden und nicht
   wenn sie zweimal "move.l (a6),a6" ausführen. Dies geschieht nur zufällig in
   Kickstart 1.2 und 1.3 für die jeweilige Struktur der alten Bibliothek. Der 
   zweite Fehler besteht darin, die copperliste mit einer eigenen Adresse in der
   GFXBASE-Struktur anstelle von Register $dff080 zu versehen. 
   Dies verursacht endlose Katastrophen, zeigen Sie immer auf die copperliste 
   mit einem Schönen:

	MOVE.L	#Copperlist,$dff080	; COP1LC
	move.w	d0,$dff088			; COPJMP1

	-	-	-	-	-	-	-	-	-

4) Ein Brauch der älteren Generation von Programmierern war auch nicht zu warten,
   bis der Blitter fertig ist, bevor Sie einen anderen machen. Das kann sehr leicht
   in dem Code, der vor 1990 geschrieben wurde gefunden werden, aber es gibt Einige
   welche immer noch über die Routinen von WaitBlit fliegen.
   In der Tat, als der Amiga nur den 68000 als Prozessor hatte gab es Fälle, in
   denen der Prozessor zwischen den Blittings und dem anderen viele dieser
   Operationen ausführen musste, die der Blitter bereits abgeschlossen hatte.
   Die Demo- (und leider auch Spiele) Programmierer dachten oft das es keinen Sinn
   hat, auf den Blitter zu warten. Auch ohne die Wait-Routine einzufügen hat es 
   funktioniert. Ein Beispiel ist das PANG-Spiel... Aber wenn sie in ihrem Demo /
   ihrem Spiel 2 Codezeilen gespart haben, haben sie damit nicht die 
   Ausführungsgeschwindigkeit erhöht (ich bin mir nicht sicher, ob ein paar
   "btst #6,$dff002" verlangsamen ...), habe aber dabei nicht berücksichtigt, das
   bei schnelleren Prozessoren die Zeit zwischen einem Blitt und dem anderen die
   Zeit verkürzt ist, da ja bekannt ist, dass der 68020 schneller als der 68000
   ist. Der Absturz ist also total.
   Leider blieb der Blitter bei ECS und AGA von derselben Langsamkeit
   (Auf beschleunigten A4000 oder A1200 ist er sogar langsamer als normal!). Um die
   durch diese Programmierprobleme verursachten "Auffälligkeiten" zu lösen, reicht
   manchmal einfach die caches und den Fast-RAM zu entfernen, also sogar einen
   68020. Wenn er im Chip-RAM mit deaktivierten Caches arbeitet, verlangsamt er
   sich manchmal genug, um eine Kugel (bullet) über einer anderen, die bereits
   läuft zu vermeiden.
   Das Schlimme ist, dass aus Gründen der Hardware-Synchronisation auf Computern
   wie A4000 oder A1200, die mit 68030 beschleunigt wurden, der Blitter langsamer
   ist als DER ALTE A500, also auch wenn wir den Prozessor verlangsamen können.
   Wie auf einer 68000-Basis ist es der langsame Blitter, der einen Absturz
   unvermeidlich macht und das ist sicherlich nicht willkommen.
   Denken Sie also daran, warten Sie auf das Ende des Blitters, bevor Sie einen
   anderen Blit machen. Da es auf dem A4000 langsamer ist, kann es schreckliche
   "Probleme" bei Spielen oder Demos verursachen, die auf einem A500 reibungslos
   (mit 50 Bildern pro Sekunde) laufen. Der ungläubige Besitzer des A4000, der
   stattdessen glaubte, er sei es, wird nervös wenn er sich das Spiel oder das Demo
   schneller ansieht.
   Warten Sie also IMMER und JEDERZEIT, bis der Blitter fertig ist:

	LEA	$dff000,a5
WaitBlit0:
	BTST.B	#6,2(a5)
WaitBlit1:
	BTST.B	#6,2(a5) ; Überprüfen Sie zweimal wegen einem Fehler auf dem A1000
	BNE.S	WaitBlit1

	P.S: Manchmal findet man ein "btst #14,$dff002" anstelle des Guten
	"btst # 6,$dff002", aber der Effekt ist der gleiche wie wenn mmer Bit 6
	getestet wird. Tatsächlich ist 6 + 8=14. BTST funktioniert nur auf Bytes
   und es testet das sechste Bit trotzdem. Es ist bevorzugt aus ästhetischen
   (und logischen) Gründen  btst #6 und nicht btst #14 zu verwenden!!

   Um Ihnen eine Vorstellung davon zu geben, wie stark sich der Blitter auf 
	beschleunigten Maschinen verlangsamt, denken Sie zum Beispiel an eine Routine, 
	für die 14 Bobs  in einem Frame auf einem  einfachen A1200 verfolgen, nur 12 
	davon auf einem A4000 und nur 9 auf einem A1200 mit Beschleunigerkarte 
	GVP 030 bei 40MHz !!!!

   Denken Sie also daran, dass es nach Möglichkeit besser ist, den Prozessor zu 
	verwenden, als den Blitter.
   Außerdem ist es immer gut, dem Blitter einige "freie" Rasterzeilen zu belassen
   anstatt bis zur letzten Millisekunde auszureizen. In der Tat, im letzteren 
   Fall, mit der Verlangsamung des Blitters auf dem beschleunigten A4000 oder
	A1200 würde es mehr in einem Frame tun, und alles würde mega bissig werden.

****************************************************************************
 TEIL 2: FEHLER IN BEZUG AUF CIAA/CIAB - TASTATUR, TIMERS, TRACKLOADERS
****************************************************************************

5) Routinen, bei denen die Feststelltaste blinkt, funktionieren nicht
   auf A1200, weil es eine wirtschaftliche Tastatur hat, die sich von den 
   Standardtastaturen unterscheidet. Diese Routinen sind in bestimmten Demos 
   für "Schönheit" vorhanden. Hier ist eine: Probieren Sie es aus und Sie
   werden den Blitz auf A500 / A2000 / A3000 / A4000 bemerken, anstatt
   eines schönen Resets auf einem A1200:

CAPSLOCK:
	LEA	$BFE000,A2
	MOVEQ	#6,D1			; bit 6 of $bfee01-input-output bit of $bfec01
	CLR.B	$801(A2)		; reset TODLO - bit 7-0 of 50-60hz timer
	CLR.B	$C01(A2)		; CLear the SDR (synchrous serial shitf
							; connected to the keyboard)
DOFLASH:
	BSET	D1,$E01(A2)		; Output
	BCLR	D1,$E01(A2)		; Input
	CMPI.B	#50,$801(A2)	; Wait 50 blanks (CIA timer) 
	BGE.S	DONE
	BSET	D1,$E01(A2)		; Output
	BCLR	D1,$E01(A2)		; Input
	MOVE.W	$DFF01E,D0		; Intreqr in d0
	ANDI.W	#%00000010,D0	; checks I/O PORTS
	BEQ.S	DOFLASH
DONE:
	RTS

   Der Amiga 1200 verfügt über einen kostengünstigen Tastatur-Controller. Probieren 
   und überprüfen Sie es mit diesem Test: Drücken Sie die Taste "r" und halten Sie 
   sie gedrückt, und drücken Sie eine andere Taste, zum Beispiel das "u". Auf einem 
   A1200 passiert nichts. Auf einem anderen Computer wird das "u" auf dem
   Bildschirm angezeigt. Also leg dich nicht mit den Tastaturroutinen an! Eine der
   Demos, die auf dem A1200 mit dieser Routine nicht funktionieren, ist ODISSEY.

   Was die Routinen betrifft, die die Köpfe der Laufwerke "bewegen". Der 
   grundlegende Fehler besteht darin, Fehler in den Synchronisation-Routinen zu
   machen, wodurch sie mit einfachen "leeren" Schleifen oder NOP-Serien erstellt
   werden wodurch sie auf schnelleren Prozessoren zu schnell laufen und damit nicht
   lange genug warten. Zeit warten mit VBLANK oder CIA!

****************************************************************************
 TEIL 3: FEHLER BEZÜGLICH PROZESSOREN 68010/20/30/40/60
****************************************************************************

6) Zunächst müssen Fehler auch in den von uns verwendeten Dienstprogrammen gefunden 
   werden und nicht nur in unserer ausführbaren Datei. Tatsächlich ist es mir oft
   an der Arbeit an einem Demo oder Intro (die sofort "gurud") durch einfaches
   Entpacken mit einem modernen Cruncher wie Powerpacker oder neu Verpacken mit
   StoneCracker 4 passiert. In der Tat viele der alten Komprimierer (Crunchers) mit
   absoluten Adressen funktionieren bei 68010+ nicht, auch wenn das eingehende Demo
   funktioniert. Die bloße Tatsache, mit einem alten ByteKiller oder TetraPacker 
   gepackt zu werden lässt es während des decrunch zum Guru gehen. Komprimieren
   Sie Ihr Programm also zunächst nicht mit alten Crunchern. Verwenden Sie
   StoneCracker4, PowerPacker oder Titan Cruncher.
   Darüber hinaus ist es immer besser, verschiebbaren Code als absoluten Adresscode 
   zu erstellen!!!

7) Adressfehler:
   Einige alte Produktionen enthalten Zugriff auf die Adressen der ROM zum
   Beispiel:

	JSR	$fce220

   Nun, Kickstart 1.2 / 1.3 befindet sich in alten Amigas bei Speicherplätzen
   $fc0000 bis zu $ffffff für insgesamt 256 KB. Es ist offensichtlich, dass bei
   diesem Kickstart jede Routine ihre Adresse hat: 
   Wir haben bereits gesehen, dass es eine "JMP-Tabelle" unter der Execbase-
   Adresse gibt. Das heißt, wir wissen, dass wir zum Beispiel, wenn wir die 
   execbase in a6 haben, $84 Bytes vorher den JMP im ROM finden werden, um das
   Forbid auszuführen:
 
	jsr	-$84(a6)	; Forbid, deaktivieren multitask

   Zum Beispiel in Kickstart 3.0 (Version 39.106) ist dies die JMP-Tabelle von
   Execbase (ein zerlegter Teil davon):

	...
	JMP	$00F815CC	; ...
	JMP	$00F815A2	; -$96(a6)
	JMP	$00F81586	; -$90(a6)
	JMP	$00F8286C	; -$8a(a6)		- Routine PERMIT
---»	JMP	$00F82864	; -$84(a6)	- Routine FORBID
	JMP	$00F817F8	; -$7e(a6)
	JMP	$00F817EA	; ...
	...

   Auf einem Computer mit Kickstart V39.106 können Sie ein FORBID mit einem erhalten:

	JSR	$F82864		; Forbid auf A1200/A4000 mit kickstart V39.106 

   Aber wenn zum Beispiel das Kickstart V39.106 per Software geladen wird und sich
   nicht im ROM befindet, zeigt die JMP-Tabelle auf die RAM-Adressen, an denen sich
   Kick befindet wo es hingeladen wurde. Also NIEMALS auf Kickstart zugreifen.
   Auf diese Weise funktioniert Ihre Produktion nur auf Ihrem Computer.
   In diesem Beispiel können Sie jedoch davon ausgehen, dass die JMP-Tabellen durch
   Ersetzen der Adresse im ROM durch unsere geändert werden können um unsere
   modifizierten Routinen laufen zu lassen. So zum Beispiel Programme, die das
   Betriebssystem ändern, Dienstprogramme, die Windows ein Gadget hinzufügen oder
   Workbench-Optionen erhöhen.
   Für diese "RELATIVITÄT" des Betriebssystems müssen Sie NIEMALS im ROM
   überspringen. Die einzige feste Adresse des Amiga-Betriebssystems ist $0004. Das
   ist die EXECBASE, die die Adresse enthält, von der aus die Offsets erstellt 
   werden sollen. Wenn Sie sich also mit dem Betriebssystem befassen möchten,
   folgen Sie immer den Standardmaßnahmen.
   Und selbst wenn Sie sich nicht darum kümmern wollen! Diese Art von Fehlern ist
   tödlich, so sehr, dass sehr viele alte Demos die auf Amiga500 Kick1.2 gemacht
   wurden nicht auf Amiga500 Kick1.3 oder höher funktionieren, nicht einmal durch
   Laden von Kickstart 1.2 über Software.

   Andere, etwas weniger schwerwiegende Adressfehler sind solche, die annehmen, der
   Fast RAM liegt bei $c00000. Ursprünglich hatte der Amiga 512k CHIP RAM, später
   verbreitete sich die interne Speichererweiterung, die es auf 1 MB brachte, und
   es ist bekannt, dass die zusätzlichen 512k Fast RAM von $c00000 bis $c80000 
   sind.Dann wurden auch Demos und Spiele entwickelt, die den gesamten Megabyte
   Speicher füllen und in dieser Zeit hatte die große Mehrheit der Programme
   absolute Adressen. Die Programmierer dachten daran, das Programm im Fast RAM an
   den Adressen von $c00000 bis $c80000 zusammenzustellen und die Grafiken und
   Musik in den Chip-RAM von $00000 bis $080000 zu laden. Also das Programm wurde
   mit absoluten Adressen nach $c00000 entpackt und den Anweisungen wurden Adressen 
   in diesem Bereich zugewiesen:

	...
	MOVE.L	#$c23b40,d0
	jsr	$c32100
	...

   Diese Demos oder Spiele funktionierten auf dem A500 mit der intern erweiterten 
   klassischen Karte, aber als der A500plus herauskam, der immer mit 1 MB Speicher
   ausgestattet war, aber nur CHIP, stellten sich alle diese Programme als 
   unbrauchbar heraus. Dies geschah, weil mit 1 MB Chip der Speicher so angeordnet
   ist: Die ersten 512k sind immer von $00000 bis $80000, aber die zweiten 512k 
   liegen von $80000 bis $100000!!! Ein "JSR $c32100" führt also nirgendwo hin, er
   führt jedoch sicher zu einem spektakulären Absturz mit einem Feuerwerk auf dem
   Bildschirm.
   Anschließend verwendeten nachfolgende Spiele und Demos mehrere Methoden, um den
   Speicher über die ersten 512k hinaus zu nutzen. Eine davon ist, die absolute
   Adressierung ganz aufzugeben, die Befehle ORG und LOAD zu vergessen, sowie die
   Programme Autoboot, da diese mit ihrem eigenen Lader unbedingt an absolute
   Adressen gesetzt sein müssen. Später waren auf der einen Seite viele Demos /
   Spiele die über DOS geladen werden konnten 100% über SECTIONS verlagerbar, ohne
   dass Teile an feste Adressen geladen werden behoben. Andere wollten den Autoboot
   und die festen Adressen nicht aufgeben und bis zum letzten Byte des Speichers
   verwenden. Letzterer löste das Problem in vielerlei Hinsicht:
   Eine besteht darin, zwei Hauptprogramme zusammenzustellen einer mit ORG und LOAD
   bei $c00000, wenn sich herausstellte, dass der Computer eine halbes Megabyte
   CHIP hatte und eine halbes FAST, und eine andere war fixed bei $80000, um
   stattdessen geladen zu werden, falls der Computer 1 MB oder mehr CHIP hatte. Auf
   diese Weise prüft beim Booten eine Routine, welchen Fall wir haben und lädt
   entweder das Hauptprogramme an die richtige Adresse hoch, während Daten wie
   Grafiken und Sounds später von Hauptprogramm geladen werden. Dieses System hat
   den Nachteil, dass zusätzlicher Speicherplatz für die beiden Versionen des
   Hauptprogramms benötigt wird.
   Andere "Schlaue" haben stattdessen ein kleines Betriebssystem programmiert,
   welche beim Booten notiert, welche Speichersegmente auf dem Computer vorhanden 
   sind und durch ihre eigene Zuordnungsroutine ordnen sie die  verschiedenen
   Teile des Programms an der Adresse an der sie den FAST RAM finden neu zu. Dies
   ist definitiv auch der beste Weg, um ein AUTOBOOT-Programm zu erstellen auch
   wenn es ziemlich schwierig ist, die Vorteile sind diese: Stellen Sie sich das
   Laden von einer Demo oder einem Spiel auf einem A4000 mit dem System der beiden
   Hauptprogramme vor:
   Beim Booten erkennt das Programm den Speicher und stellt fest, dass dies nicht
   der Fall ist. Laden Sie bei einem Speicher von $c00000 den Code für $80000 in
   den CHIP-RAM. Die gleiche Demo / das gleiche Spiel wurde jedoch geändert, um mit
   dem Mini Betriebssystem geladen zu werden: Beim Booten erkennt dies, dass es
   zwei Blöcke von Speicher gibt, den CHIP RAM von $000000 bis $200000 und den 
   FAST-RAM von $7c00000 bis $7ffffff.
   Er verschiebt daher alle Teile des Codes in FAST RAM und lädt die Grafik und den
   Sound in den CHIP-RAM. Bekanntlich ist der Code im FAST RAM viel schneller als
   im CHIP RAM, insbesondere auf TURBO-Prozessoren wie dem 68040, folglich wird die
   Demo oder das Spiel viel schnell laufen mit dem Code in FAST RAM.
   Es ist jedoch zu beachten, dass diejenigen, die ihre Betriebssysteme verwendet
   haben ihre Demos mit dem Aufkommen des 68040 abstürzen sahen, oder auch mit dem
   Aufkommen des einfachen 68020, weil Motorola volle Abwärtskompatibilität NUR im
   Benutzermodus und nicht im Supervisor-Modus garantiert:
   Tatsächlich hat der 68040 seine eigenen Anweisungen im Supervisor Mode und sogar
   der 68060 ist nur im Usermode 100% kompatibel... 
   Geschweige denn Prozessoren oder Computer der Zukunft, die vielleicht die 680x0
   emulieren werden... NIEMALS ZUM SUPERVISOR GEHEN UND KEINE BETRIEBSSYSTEME HABEN.
   Um Ihnen eine Idee zu geben, die schöne Demo WOC 92 von Sanity, wegen sein
   Betriebssystem funktioniert es nicht auf 68040... und das gleiche gilt für das
   italienische Demo IT CAN'T BE DONE, von einem Freund von mir, und in diesem
   letzten Fall war ich derjenige, der den Fehler gefunden hat:
   die Supervisor-Routine !!!
   Alles in allem denke ich, dass es einfacher und sicherer ist, SECTIONS für 
   ausführbaren Code zu verwenden, auch weil es den Vorteil gibt, in der Lage zu
   sein auf Festplatte zu installieren und sicherlich wird der Amiga in den
   nächsten Jahren zunehmend wettbewerbsfähig mit MSDOS sein müssen und damit meine
   ich das andernfalls der BASIC-Computer über die Festplatte und den FAST-RAM
   verfügen muss. Andererseits werden wir bei einigen 1MB Spielen sehen, die von
   Diskette im Autoboot geladen werden  und die Prozessorgeschwindigkeit nicht
   einmal ausnutzen wenn der Code in FAST RAM geladen ist!

   Bis hierher habe ich angegeben, das es besser ist, verschiebbaren Code zu
   erstellen, aber was passiert, wenn wir absolute Adressen für eine von DOS
   ladbare ausführbare Datei verwenden?
   Nun, die Einführung des A500+ mit 1 MB CHIP hat dazu geführt,
   nicht einmal viele der "MIXED" -Codeproduktionen zu betreiben, d.h.
   mit verschiebbarem Code, erstellt mit dem "SECTION", aber unter Verwendung 
   von Puffern für Grafiken, die NICHT über Section BSS oder AllocMem zugewiesen
   wurden, aber willkürlich festgelegt:

	lea	$30000,a0		; Adresse bitplane Puffer
	bsr.s	PrintText	; Drucken Sie den Text bei $30000

   In diesem Fall ist nicht der Code, sondern der Grafik-Puffer verschiebbar.
   Folglich gibt es auch keine Zeigeroutine für die Bitebenen in der copperliste,
   da der Wert $30000 direkt vom Programmierer gesetzt wird: (HORROR!!!)
 
	...
	dc.w	$e0,$0003	; bpl0pth
	dc.w	$e2,$0000	; bpl0ptl
	...

   Mal sehen, was auf alten Computern passiert, solchen mit 512k CHIP und 512k
   FAST: Angenommen, das Intro hat einen 20k-Section CODE und einen CHIP von 40k
   (mit der Schriftart FONT und der Musik). Der erste Abschnitt wird in FAST und 
   der zweite in CHIP geladen, so dass Sie es nicht nach $30000 kommt, aber
   beispielsweise nach $2000. In diesem Fall funktioniert alles, solange dieses
   Intro das erste ist, was vom DOS geladen wird.
   Auf neueren Maschinen mit NUR 1MB oder 2MB Chip, wird da es kein FAST MEM gibt
   alles in CHIP geladen, sowohl der Abschnitt CODE als auch der andere. Auf diese
   Weise finden sie die letzten Kb Code (oder von Musik, Grafiken usw.) über der
   Adresse $30000. Stellen Sie sich vor, was für ein schöner Absturz passiert,
   wenn die Routine die Zeichen über dem Code druckt!
   Die Verzweiflung der "einfachen" Codierer am Ende der A500+ und A600 war, dass
   sie die Listings auf diesen Computern nicht korrigieren konnten, in welches
   das ASMONE selbst in CHIP RAM geladen wurde, über das hinaus gepackt $30000 oder
   $40000, die als absolute Puffer verwendet werden, also bei JMP.
   Das Listing könnte auch funktionieren (UNBEABSICHTIGT), aber am Ausgang das ASMONE
   fand er sich durch die Routinen DURCHLÖCHERT und der Absturz war unvermeidlich.
   Dies lehrte auch Intro-Produzenten, dass man sich einen schönen verschiebbarer
   Puffer zulegen muss:

	SECTION	BufferOK,BSS_C

	ds.b	10000

   Um die Reihe von Fehlern bezüglich der Adressen abzuschließen, berichte ich nun
   von den Fehlern, die Sie kaum gemacht hätten, da es unlogische Handlungen sind,
   aber aus Sicherheitsgründen ist es gut zu wissen, dass:

   - Einige schlaue Programmierer haben manchmal das hohe Adressbyte verwendet um
   Nachrichten zu schreiben oder einfach um uns zu schreiben. Sie sollten wissen,
   dass 16-Bit-CPUs wie die 68000 oder 68010 das High-Byte einer Adresse
   ignorieren, z.B.:

	JSR	$00005a00
	JSR	$00120d00
	JSR	$00c152b0
	JSR	$00013cd0

  es ist gleichbedeutend mit schreiben von

	JSR	$C0005a00
	JSR	$DE120d00
	JSR	$FEc152b0
	JSR	$DE013cd0

  Es liest sich in den ersten Bytes deutlich ein "C0DE-FEDE", das eine Nachricht
  sein kann, die ein Emilio Fede-Codierer vor vielen Jahren hinterlassen hat, der
  es auf diese Weise signiert. Beachten Sie, dass Sie mit hexadezimal viele Wörter
  bilden können (A, B, C, D, E, F und 0 als "O"), zum Beispiel:
  FEDE, AFA, ABAC0, FACCE, F0CA, CACCA, CADE, C0DE, ...
  Diese schlauen Männer hinterließen daher ganze Botschaften, Gedichte,
  Liebesbriefe in den hohen Bytes von Adressen in den Unterprogrammreihen oder an
  anderen Orten, an denen diejenigen, die es disassemblierten, auch Beleidigungen
  lesen konnten!
  Dieses kleine Spiel dauerte zum Glück nur kurz, aber das Intro / Demo arbeitet
  nicht auf 32-Bit-Prozessoren, auf solchen Prozessoren bei denen die maximale
  Adressierung erhöht wurde, sodass der JSR wirklich diese seltsamen Orte versucht.
  Übrigens haben Sie vielleicht bemerkt, das der FAST RAM des alten A500 bei
  $00c00000 liegt, während beim A4000 es bei $07c00000 ist, das heißt, außerhalb
  des Adressbereichs eines 68000.

  Der letzte der Adressfehler und nicht weniger ungewöhnlich, als die vorherigen,
  ist das der 512k CHIP-Speicher, viermal im Adressbus "wiederholt" wird, was 
  bedeutet, dass von $00000 bis $7ffff, können Sie auch darauf zugreifen, indem Sie
  auf $80000- $FFFFF oder $100000- $17ffff oder $180000- $1FFFFF arbeiten.

  In der Praxis sind die $80000 Bytes (512 KB) 1/4 der $200000 (2 MB) des Busses
  und auf den OCS-Maschinen (alte Amigas, die nur auf 512k  CHIP, der Rest FAST
  abzielen konnten), auf jedes Byte des CHIP-Speichers können vier verschiedene 
  Adressen zugreifen, die um 512 KB voneinander entfernt sind.
  Dies ist natürlich eine Eigenschaft, die nur auf ECS- und AGA-Maschinen vorhanden
  ist. Diejenigen, die 1 MB oder mehr Speicher adressieren können, gehen verloren.
  Nehmen wir ein Beispiel:  Wenn wir den Wert $12345678 an Position $0 schreiben,
  können wir diesen Wert auch von $0+$80000, $0+$80000*2, $0+$80000*3 und 
  $0+$80000*4 "herausfischen". Sehen wir uns eine Liste an:

	move.l #$12345678,$0	; wir setzen diesen Wert in die ersten 4 Bytes

	move.l	$80000,d0		; d0 = $12345678
	move.l	$100000,d1		; d1 = $12345678
	move.l	$180000,d2		; d2 = $12345678

   Lesen von $80000, $100000 und $180000 ist wie Lesen von $0!!!!
   Leider hat ein Dummkopf diese seltsame Eigenschaft für seine Routinen benutzt,
   die zu Fehlfunktionen verschiedene Dinge des A500 + und des A600 führen und
   bedenken Sie, dass der Prozessor immer eine 68000 ist. Der Fehler tritt auch
   bei Kickstart 1.3 im ROM auf.

   Jetzt kennen Sie alle Fehler bezüglich der Adressen, die in der Vergangenheit
   gemacht wurden. Sie sehen, wie sie sie nicht machen und wie sie sie nicht 
   von neuen erfinden!!!!

	-	-	-	-	-	-	-	-	-

8) Probleme mit SR in Prozessoren ab 68010:
   Eines der häufigsten Inkompatibilitätsprobleme bei 68010 und höher als der
   68000-Code ist der der Anweisungen "MOVE SR,dest". Zum Beispiel "MOVE SR,d0"
   oder "MOVE SR,$1234" oder "MOVE SR,LABEL". Tatsächlich können diese Anweisungen
   auf 68000 Basis im Benutzermodus (USER MODE) wie jede andere Anweisung normal
   verwendet werden: Programme wie Emulatoren (PC Transformer, C64 Emulator usw.)
   funktionieren unter 68010+ nicht, weil sie dies im USER-Modus tun, der auf
   68010+ nicht mehr möglich ist und es verursacht einen "Privilege Violation"
   Guru. Viele Spiele und Demos werden auch durch das Vorhandensein dieser
   Anweisungen im ersten Teil der Routinen, die die Kontrolle über das System
   übernehmen ge(sarg)nagelt.
   Motorola hat beschlossen, die Möglichkeit zur Simulation der Funktionsweise
   neuer Betriebssysteme für Maschinen die noch nicht verfügbar sind hinzuzufügen.
   Dies machte die Notwendigkeit der Rückkehr des Befehls MOVE SR, privilegiertes
   Ziel, d.h. nur im Supervisor Modus ausführbar notwendig. Andernfalls ist das
   Ergebnis ein GURU "Privilege Violation".
   Um im Benutzermodus auf den SR zugreifen zu können, haben die Motorola-
   Entwickler jedoch ab dem 68010 Prozessoren aufwärts den Befehl MOVE CCR,dest
   hinzugefügt, anstelle von MOVE SR,dest, welcher auf 68000 nicht verfügbar war.
   Also einige Programme für den 68000 von Amiga wurden mit der Anweisung 
   MOVE SR,dest im Benutzermodus geschrieben und wir werden dies bei einem Spiel
   oder Demo mit einer finsteren GURU-MEDITATION Nachricht oder SOFTWAREFEHLER
   auf A1200 / A3000 / A4000 oder A2000 beschleunigt beim Booten bemerken.

   In Wirklichkeit wurde der "Fehler" von Motorola gemacht, da sie sich dessen
   nicht bewusst waren habe MOVE SR,dest im Benutzermodus (USER) sicher verwendet
   nicht.
   Sie warteten darauf, dass daraus eine Anweisung wurde, die nur auf eine Art und
   Weise im Supervisor! (nach einer TRAP oder AUSNAHME des Prozessors) ausgeführt
   werden sollte. Das Wichtigste ist jedoch zu wissen, und jetzt können wir sicher 
   sein, dass wir es nicht tun stoßen Sie auf das Problem, und dies ist möglich,
   indem Sie daran denken, immer den Befehl MOVE SR,dest im SUPERVISOR-Modus laufen
   zu lassen, d. h. nach einer TRAP oder nach einer UNTERBRECHUNG usw. Auf diese
   Weise wird die Bildung bei allen Prozessoren funktionieren.
   Eine andere Lösung wäre, zu überprüfen ob der Prozessor der sich auf dem
   Computer befindet und den entsprechenden Code ein "MOVE SR, dest" auf 68000 oder
   ein "MOVE CCR, dest" auf 68020 ausführt, beide im USER-Modus, um zu vermeiden,
   dass sie im SUPERVISOR-Modus ausgeführt werden müssen, aber ich denke das die
   schnellste und vernünftigste Lösung darin besteht, immer das "MOVE SR,dest" im 
   SUPERVISOR-Modus auszuführen. Zusammengefasst:

	CPU				Modus USER (Benutzer)	Modus SUPERVISOR

	68000			MOVE SR,dest			MOVE SR,dest
	68010/20/30/40	MOVE CCR,dest			MOVE SR,dest

   Sie werden zustimmen, dass es immer besser ist, das alte "MOVE SR,dest" im
   Supervisor Mode auszuführen, was Zeit und Routinen spart. Wenn andererseits das
   Spiel / Programm / Demo, das Sie programmieren, nur für 68010+ Prozessoren
   bestimmt ist, wenn die Demo beispielsweise nur AGA ist, können Sie das neue
   MOVE CCR,dest im Benutzermodus verwenden, da Sie sich auf einem 68020+ befinden,
   aber denken Sie auch daran, dass diese Anweisung auf 68000 nicht existiert, so
   dass es nicht von 68000 Basis-Assemblern wie diesem TRASH'M-One assembliert
   wird. Um Anweisungen wie diese ab 68010 assemblieren zu können müssen Sie
   TFA ASMONE oder DEVPAC 3 verwenden.
   Auf der anderen Seite rate ich Ihnen wirklich, NIEMALS DIESE ANWEISUNG ZU
   VERWENDEN und NIEMALS IN SUPERVISOR MODE ZU GEHEN... wofür brauchst du es? um
   was zu riskieren?
   Wenn ein solcher Fehler auftritt, ist die SOFTWARE FEHLER-Nummer vom
   Betriebssystem #80000008 und es ist nicht schwer, es zu identifizieren. Um Demos
   oder Spiele zu programmieren, verfügt das SR-Register jedoch nicht über einen
   grundlegenden Nutzen, daher rate ich Ihnen dringend, NIEMALS auf dieses Register
   zuzugreifen, auch weil sich seine Bits vom Prozessor unterscheiden und es ist
   sehr leicht, Inkompatibilitätsprobleme zu verursachen.

	-	-	-	-	-	-	-	-	-

9) Bei 68010, zusätzlich zum Befehl MOVE CCR,SR, den wir gesehen haben, haben auch
   andere eingeführte Neuerungen, die, da sie nicht bekannt waren, Fehler der
   Inkompatibilität verursachen können. Dies ist der VBR, d.h. Das VECTOR BASE
   REGISTER, was "Basis-Register" bedeutet. Wir haben das Register in der Lektion
   über Interrupts gesehen. Tatsächlich wissen wir wann ein Interrupt oder Trap
   auftritt  (TRAP #xx-Anweisung). Der Prozessor UNTERBRICHT das Lesen des
   Programms, das im USER-Modus ausgeführt wurde, wechselt in den SUPERVISOR-Modus
   und führt die Routine an der gefundenen Adresse in dem spezifischen VEKTOR aus,
   der eine der Interrupt-Ebenen oder eine der TRAPs usw. sein kann.

   In den neuen Prozessoren wurden außerdem Vektoren verwendet, die in 68000
   verwendet wurden. Sie hatten keine Funktionen (siehe zum Beispiel $18 und $1c).
   Die Möglichkeit, die BASE dieser Vektoren zu verschieben, wurde implementiert.
   Auf einem 68000 sind wir sicher, dass der VBLANC-Interrupt immer bei $6c ist.
   Bei einem 68010 oder höher können wir nicht sicher sein.
   Das liegt daran, dass die Basis für diese OFFSETs möglicherweise nicht mehr
   $000000 ist. Führen Sie einfach einen "MOVEC d0,VBR" im Supervisor aus, und
   alles ändert sich. Natürlich wird beim Booten der VBR gelöscht, also befinden
   sich die Vektoren wie beim 68000 alle am selben Ort. Es ist das SetPatch des
   AmigaDos, welcher den VBR normalerweise im FAST RAM bewegt und die Adressen der
   Vektoren an die neue Adressen kopiert. Oder der "Umzug" wird von anderen
   Dienstprogrammen durchgeführt.
   In der Tat, sobald die WorkBench auf einem Computer mit 68010+ geladen ist, ist
   es sehr wahrscheinlich, dass der VBR nicht Null ist, also die alten Demos und
   Spiele (nicht nur die alten!), wenn sie von der Shell oder der WorkBench geladen 
   werden, haben oft keine Musik oder sie stürzen ab (hängen sich auf), weil sie
   die Interrupt-Routinen in $6c, was sie sollten in VBR + $6c setzen.
   Also mach NIEMALS so etwas:

	MOVE.L	#IntRoutine,$6c

   Erstens könnten Sie "optimieren" in:

	MOVE.L	#IntRoutine,$6c.w

   Das Wichtigste ist jedoch, dass es nur funktioniert, wenn es zuerst beim Booten 
   geladen wird um SetPatch oder andere Dienstprogramme auszuführen. Um das Problem
   zu beheben, reichen nur wenige Codezeilen aus, um zu überprüfen ob es einen
   68000 oder einen 68010+ gibt.  Im letzteren Fall lesen Sie den VBR-Wert zum
   Ausführen der erforderlichen Offsets. Denken Sie am Ende des Programms daran,
   dasselbe für den alten Interrupt zu machen.
   Dies ist natürlich im Startup2.s vorhanden, welches in den erweiterten Listings
   verwendet werden. Beachten Sie, dass der Befehl MOVEC VBR,A1 (68010+) nicht von
   allen Assemblern (einschließlich dieses ASMONE) assembliert wird. Es ist also
   besser, es durch sein hexadezimales Äquivalent zu ersetzen. Tatsächlich hindert
   Sie niemand daran, "dc.w $4e75" anstelle von RTS zu schreiben!

	-	-	-	-	-	-	-	-	-

10) Lassen Sie uns nun die Programmierleuchtpunkte sehen, die mit der Einführung
   des INSTRUCTION CACHE von Prozessoren ab 68020 gemacht wurden. Mit 
   "offensichtlich gemacht" meine ich, dass solche Fehler zu einem Absturz des
   gruseligen Systems führen. Glücklicherweise können viele dieser Fehler durch
   Deaktivieren des CACHEs über das Software-Dienstprogramm gelöst werden. Lassen
   Sie uns kurz sehen, was diese CACHEs sind: Es ist viel schneller Speicher
   welcher innerhalb des Prozessors statt außerhalb, im Gegensatz zum CHIP oder
   FAST RAM ist, den Sie über den BUS ansprechen müssen, um erreicht zu werden.
   Wir haben bereits die Daten- und Adress REGISTER gesehen, die nichts anderes
   sind, als interner LONG Speicher vom Prozessor, den wir lesen und schreiben
   können. Nun, die CACHEs sind ähnliche Speicherbänke, die dies jedoch nicht tun.
   Wir können mit Anweisungen lesen oder schreiben, sie werden automatisch gelesen
   und geschrieben über eine spezielle Hardware vom Prozessor.
   Der Zweck der Caches besteht darin, die LOOPs zu beschleunigen, dh die Routinen,
   die viele Male zyklisch ausgeführt werden. Ich sage das auf 68020 und 68030 der
   INSTRUCTION-Cache 256 Byte groß ist, während er bei 68040 4096 Byte groß ist.
   Auf dem 68060 denke ich, sind ist es 8192, und wer weiß in der Zukunft ...
   Stellen Sie sich diese Schleife vor:

	...
	MOVEQ	#100,d0
Loop1:
	move.w	LABEL1(PC),d2
	add.w	d3,d2
	....
	andere Anweisungen
	....
	DBRA	d0,loop1
	...

   Selbst wenn Sie die Prozessorgeschwindigkeit erhöhen, erfordert diese Schleife
   das Lesen der Anweisungen zwischen dem Label "loop1:" und dem "DBRA d0, loop1"
   das zyklische Lesen aus dem RAM und insbesondere wenn es sich um CHIP-RAM
   handelt, ist es sehr langsam. Die Designer von Motorola haben sich dann diesen
   Trick ausgedacht: "Was wäre wenn wir automatisch die letzten 256 Bytes
   die durchgeführt wurden zwischenspeichern würden?
   Wir würden das bekommen: wenn eine weitere kleine Schleife um 256 Bytes 
   auftritt, befinden sich alle Schleifenbefehle im CACHE und der Prozessor kann
   die verbleibenden Zeiten aus dem schnellen CACHE-Speicher statt aus dem RAM
   lesen!". Der Instruction CACHE funktioniert also mehr oder weniger.
   Die erste Schleife würde dann nur beim ersten Mal aus dem RAM gelesen werden.
   Wenn dann DBRA erreicht wird, "erkennt" der Prozessor, dass Loop1: immer noch
   im CACHE enthalten ist, und die restlichen 99 mal wird die Lesezeit der
   Anweisungen erheblich reduziert. Es wird von CACHE anstelle von CHIP / FAST RAM
   ausgeführt.
   Sie fragen sich vielleicht: aber welche Fehler können dann auftreten ?????
   Am Häufigsten sind diejenigen, die bestimmte Routinen "zeitlich festgelegt"
   haben basierend auf der Zeit, die die 68000-Basis benötigt, um eine bestimmte
   Anzahl von "leere" Schleife zu erstellen. (jetzt wird sie mit einer Liste
   zum Wegwerfen gefunden).
   Mal sehen, wie die "Schlauen", die "Zeit verschwendet" haben, um zum Beispiel
   darauf zu warten, dass sich die Diskettenlaufwerksköpfe bewegen, oder für das
   Timing der Musik oder mehr:

	....
	MOVE.W	#2500,d0
Aspettatempo:
	dbra	d0,Aspettatempo
	...

   Diese Beispiele für ungeschickte und grobe Programmierung sind, leider sehr
   häufig in Trackloader und Routinen, die die Musik spielen. Die im Kurs
   vorhandene "music.s" -Routine hatte ursprünglich ein paar dieser
   "Leerschleifen", die ich durch zuverlässige "Zeitverschwender"-Routinen ersetzt
   habe, die wir jetzt sehen werden.
   Wenn Sie Wiedergaberoutinen wie Noisetracker / Protracker haben werden Sie
   sicherlich dumme Schleifen dieser Art finden, die den Verlust einiger Noten beim
   Hören der gespielten Musik verursachen.
   Eine Bemerkung: Es gibt auch Schleifen dieser dummen Art in den Kurslisten von 
   Gerardo Proia. Ich hoffe du hast sie nicht als Beispiel genommen! Schauen Sie
   sich die Listings an, und wenn Sie diese verfluchten Schleifen gefunden haben,
   werfen Sie diese miesen Quellen weg oder ersetzen Sie diese.
   
   Beginnen wir mit Routinen, die die CIA oder VBLANK für das Timing verwenden.
   Das Arbeitsprinzip einer Leerschleife ist, dass der Prozessor in diesem Fall
   2500 mal den DBRA-Befehl aus dem Speicher lesen muss, subtrahiere #1 von d0 und
   springe zurück zu "Lass uns warten:".
   Auf einem Computer mit aktivem Cache kann er sogar 50000 Mal gelesen werden.
   Nach Abschluss des CACHEs wird der DBRA jedoch in einem Bruchteil ausgeführt.
   Zweitens liest das Laufwerk jedoch folglich nicht die Titel und die Musik
   "schneidet" die Noten. Außerdem hat der 68010 auch in Wahrheit einen kleinen 
   3-Wort-CACHE, um kleine DBRA-Schleifen wie diese zu beschleunigen.
   Daher "funktionieren" diese Schleifen nur auf dem 68000 bei 7 MHz. Da Ihnen im 
   MAI-Kurs die Timer mit leeren Schleifen beigebracht wird, hoffe ich, das niemand
   beginnt autonom, ähnliche * DICKS * zu machen.
   Im Allgemeinen kann gesagt werden, dass NIEMALS als Referenz für die
   Geschwindigkeit der Ausführung der Anweisungen durch die CPU 680x0 gegeben
   genommen werden sollte.
   Diese variiert von Prozessor zu Prozessor und hängt sogar davon ab, welcher
   Speichertyp gelesen wird. Die einzigen Gewissheiten aus der Sicht von Timing
   ist das VBLANK REFRESH VIDEO, da das im PAL-Standard immer 50 Mal pro Sekunde
   ausgeführt wird, und die CIA-Timer, da die Chips für alle Amigas gleich sind,
   also ist 1 Millisekunde auf dem A500 ist gleich wie bei einem A4000. Achten Sie
   darauf, sich nicht einmal auf die Geschwindigkeit des Blitters zu verlassen, da
   die Geschwindigkeit je nach Computerprozessor variiert.

   Hier erfahren Sie, wie Sie Tracker und Signale für externe Geräte zeitlich
   verfolgen oder Roboterarme, die an den parallelen Anschluss angeschlossen sind:

   Lassen Sie uns zuerst sehen, wie Sie mit der VBLANK auf eine "Rasterlinie"
   warten können:

	LEA	$DFF000,A5		; Custom register base in a5
PerdiTempo:
	MOVE.w	#LINEE-1,D1	; Anzahl der Zeilen zu warten (304=1 frame)
VBWAITY:
	MOVE.B	6(A5),D0	; $dff006, VHPOSR.
WBLAN1:
	CMP.B	6(A5),D0	; VHPOSR
	BEQ.S	WBLAN1
WBLAN2:
	DBRA	D1,VBWAITY

   Wenn Sie die CIA-Timer nicht für andere Routinen verwenden, können Sie sie
   verwenden, obwohl es am besten ist, sie so wenig wie möglich zu berühren, da Sie
   vom Betriebssystem verwenden werden.
 
   In Lektion 11 finden Sie Beispiele zu diesem Thema.
   Berücksichtigen Sie bei der Verwendung der CIA-Timer, das auch das Betriebssystem
   einige für bestimmte Zwecke verwendet: (Besser die CIAB benutzen!)

   CIAA, timer A	Dient zum Anschließen an die Tastatur

   CIAA, timer B	Wird von exec zum Austauschen von Aufgaben usw. verwendet.

   CIAA, TOD		Timer zu 50/60 Hz verwendet von Timer.device

*  CIAB, timer A	Nicht verwendet, für Programme verfügbar

*  CIAB, timer B	Nicht verwendet, für Programme verfügbar

   CIAB, TOD		Wird von der graphics.library verwendet, um der 
   					Position des Elektronenstrahls zu folgen.

   Wenn Sie Timer verwenden müssen, die auch vom Betriebssystem benötigt werden,
   machen Sie es einfach wenn Sie Multitasking und Systeminterrupts deaktiviert
   haben, das heißt, wenn sie die vollständige Kontrolle über das System übernommen
   haben. Es ist jedoch immer gefährlicher die CIA zu benutzen, gegenüber dem
   vblank.

		-		-		-		-
	
   Neben dem Problem der Zeitschleifen gibt es auch den von einem anderen
   Programmierfehler, der heutzutage zum Glück fast verschwunden ist. Es ist das
   legendäre und mysteriöse Code "SELBSTÄNDERUNG": Diese Art von Code wird als
   selbstmodifizierend bezeichnet, weil es sich selbst verändert. In der Tat ist es
   möglich "Kreaturen" zu machen, die neben dem Ändern von Daten auch ihre eigenen 
   Anweisungen während der Ausführung ändern.
   Leider wird diese Art der Programmierung seit der Antike verwendet,
   wahrscheinlich, weil es als eine Möglichkeit schien, schnelleren oder
   kraftvolleren Code zu schreiben. 
   Was kann mit selbstmodifizierendem Code gemacht werden?
   Es kann mit 100% normalem Code umgeschrieben werden und manchmal auch
   Geschwindigkeit erzielen. Vergessen Sie also, Code dafür zu schreiben, außer zu
   Versuchszwecken, weil dieser Code nicht aktiv mit dem CACHE des 68020/30/40/60
   arbeitet. Wer einen A1200 hat, weiß es.
   Ich kann sicherlich zählen, wie viele Spiele und Demos nicht funktionieren nur
   wegen der Caches! In der Tat glaube ich die meisten Fehler in alter Software
   sind von diesem Typ. Um ein Spiel oder eine Demo mit selbstmodifizierendem Code
   zu erkennen, versuchen Sie einfach, ob es funktioniert indem Sie die Caches
   entfernen (ohne alte Kicks zu laden) und es dann mit dem aktivierten Caches
   erneut versuchen. Wenn es zu diesem Zeitpunkt nicht funktioniert, ist es
   offensichtlich, dass ich es alleine bin.
   Aktive Caches verursachen das Problem, und Caches verursachen nur zwei Typen
   von Fehler: das Abbrechen der DBRA-Verzögerungszyklen, die wir bereits gesehen
   haben und diejenigen aufgrund des selbstmodifizierenden Codes.
   Hier ist ein Listing wie sie selbstmodifizierendem Code präsentieren können:
   
	...
	divu.w	#3,d0
MYLABEL:
	moveq	#0,d0
	...

   Was auf diese Weise im Speicher assembliert wird:

	...
	dc.l	$80FC0003	; DIVU.W #$0003,D0
MYLABEL:
	dc.w	$7000		; MOVEQ	 #$00,D0
	...

   Im Moment haben wir Daten im Speicher geändert, in der copperliste haben wir
   benutzerdefinierte Werte in die Register $ffXXX eingefügt, aber wir haben nie in 
   eine Anweisung gehandelt!!! Dies genau deshalb, weil es eine INKOMPATIBLE Sache
   ist. (Eigentlich haben wir ein JMP am Ende eines Interrupts in der Liste beim
   Laden von DOS in Lektion11.txt geändert, aber es ist der einzige "nützliche"
   Fall!).
   Stellen Sie sich vor, dass es später im Listing diese Anweisung gibt:

	...
	move.w	#5,MYLABEL-2
	...

	Was ist los? Das Wort, das vor dem MYLABEL-Etikett steht, lautet $0003 des
	DIVU #3,d0, was zu $0005 wird, also  DIVU #3,d0 wird zu DIVU #5,d0 !!!
	Auf die gleiche Weise können Sie alle anderen Anweisungen ändern. In einem
   anderen Weg, kannst du es so schreiben:

	...
	divu.w	#3,d0
MYLABEL:	EQU	*-2
	moveq	#0,d0
	...

   Nun, um die DIVU-Nummer zu ändern, nur ein MOVE.W #xxxx,MYLABEL, in der Tat
   durch EQU *-2 entspricht MYLABEL dem Label -2.
   Das Sternchen kann in "dieser Punkt" übersetzt werden, so dass "*-2" wird
   "dieser Punkt minus 2 Bytes". Nehmen wir nun an, wir haben diese Situation in 
   einem selbstmodifizierendem Code aufgelistet mit:

	...
	divu.w	#0,d0	; geändert in den gewünschten Wert
MYLABEL:
	EQU	*-2
	...

   Stellen Sie sich vor, was passiert, wenn der CACHE aktiv ist: Der Cache
   bildet es, wie es im Speicher ist, das heißt, DIVU.W #0,d0, wahrscheinlich
   bevor es geändert wird, so dass es zum Zeitpunkt, zu dem die:

	move.w	#5,MYLABEL

   Die DIVU-Anweisung wird im RAM geändert, jedoch nicht im CACHE! Tatsächlich
   wird die Anweisung ausgeführt, wie sie ist, nämlich DIVU.W #0,d0, was dazu
   führt, dass ein schöner Systemabsturz mit DIVISION BY ZERO folgt!!

	divu.w	#0,d0	; Der Wert "0" wird vorher ersetzt
MYLABEL:			; Anweisung wird ausgeführt, aber mit aktivem ICACHE
	EQU	*-2			; Diese Anweisung wird unverändert aus dem Cache gelesen
					; und ein netter Guru DIVISION BY ZERO
					; wird unseren Spaß stoppen.
  Ebenso:

	JMP	0		; Die Adresse wird an dieser Stelle durch einen Umzug gesetzt.
MYLABEL:		; aber mit dem Cache werden wir einen schönen Sprung bei 0 haben
				; !! (Hier !!)
	EQU	*-6		; (EQU *-4, EQU *-8, abhängig von der Größe
				; die Adresse oder die blöde "Änderung".


   In einigen Fällen treten anstelle eines echten GURU Probleme in Routinen auf,
   z. B. in einer Schleife diesen Typs:

	...
	MOVE.W	#100,d0
Loop1:
	...
	divu.w	#2,d2
MYLABEL:
	EQU	*-2
	....
	addq.w	#1,MYLABEL
	DBRA	d0,loop1
	...

   Kein System stürzt ab, aber während divu.w jeden Zyklus zu DIVU.W #3,d2,
   DIVU.W #4,d2 usw. wechseln sollte, bleibt es immer DIVU.W #2,d2 (von CACHE und 
   nicht von RAM gelesen). Wenn dies z.B. eine Routine war, die eine solide
   3D-Bewegung ausführt, dann bleibt der Körper sicher stehen oder erscheint
   nicht einmal.

- WIE WIR ES GEMACHT HÄTTEN:

   Das gleiche hätte auch durch ein Label oder ein REGISTER anstatt eines absoluten
   Wertes (divu.w LABEL (PC),d2 statt divu.w #xxx,d2) gemacht werden können, und
   Sie hätten das Hinzufügen auf dem Label unter Beibehaltung der Kompatibilität
   mit Caches und ohne Geschwindigkeitsverlust vornehmen können.
   Also sei nicht dumm: Selbstmodifizierender Code ist keine Sache zum Prahlen,
   weil es weder schwierig noch nützlich, aber nicht kompatibel ist. Bitte
   verwenden Sie keine alten Listings mit selbstmodifizierendem Code. Es gibt
   jedoch neben der Deaktivierung von Caches auch eine Möglichkeit,
   selbstmodifizierenden Code auszuführen: Sie können in der Tat ein Reset, das 
   heißt den Cache mit einer speziellen Anweisung REINIGEN. Auf diese Weise werden
   die alten Anweisungen im CACHE gelöscht und der Prozessor muss die vom RAM
   modifizierte lesen.
   Wenn Sie Programme mit "bakterieller" oder künstlicher Intelligenz machen wollen
   oder wer weiß, welche Art von Selbstmodifizierung, setzen Sie einfach eine
   "BSR.w CACHECLR" vor dem Ausführen der geänderten Anweisung.
   Ab Kickstart 2.0+ gibt es eine spezielle Funktion von ExecLib:

ClearMyCache:
	movem.l	d0-d7/a0-a6,-(SP)
	move.l	4.w,a6
	MOVE.W	$14(A6),D0	; lib version
	CMP.W	#37,D0		; V37+? (kick 2.0+)
	blo.s	nocaches	; wenn kick1.3, Das Problem ist, dass er es nicht kann
						; Ich weiß nicht mal, ob es ein 68040 ist, also
						; es ist riskant .. und hoffentlich eins
						; dumm wer einen 68020+ auf einen kick1.3 hat 
						; habe auch caches deaktiviert!
	jsr	-$27c(a6)		; cache clear (für load, modifications etc.)
nocaches:
	movem.l	(sp)+,d0-d7/a0-a6
	rts

   In startup2.s gibt es diese Unterroutine, die ausgeführt werden kann.
   Anmerkung: Wenn wir auf Kick 1.3 sind, wird es ohne JSR beendet, auf diese Weise 
   gibt es keine Probleme auf alten Computern.
   Führen Sie diese Routine auch nach dem Laden von Daten im Speicher mit einem 
   Trackloader durch oder nach anderen Änderungen an Zonen von Speicher mit Code.
   Beachten Sie, dass manchmal ein Programm mit selbstmodifizierendem Code zufällig
   auf 68020/68030 funktionieren kann, weil zwischen dem geänderten Befehl und
   derjenigen, die modifiziert mehr als 256 Byte Abstand liegen, so dass der Befehl
   aus dem RAM gelesen wird, aber auf A4000 beträgt der Cache 4096 Byte, und wer
   weiß, wie viel auf zukünftigen Prozessoren!
   Fallen Sie also NIEMALS in Selbstmodifikation, wie einige Demo-Codierer, die es 
   weiterhin für den A1200 machen, sodass ihre Schöpfung nicht auf dem A4000 laufen.
   In den Prozessoren 68030 und 68040 gibt es auch den DATA CACHE, der dieselbe Sache
   macht wie der INSTRUCTION CACHE, aber auf den Daten (wie den Tabellen), aber nur
   wenn sich diese Daten im FAST RAM befinden. Im CHIP-RAM funktioniert der
   DATA-Cache nicht. Fehler für DATA CACHE sind seltener, tatsächlich ist es
   schwierig, dass beispielsweise Tabellen geändert werden. Jedenfalls zur
   Sicherheit können Sie einen CACHECLR durchführen, auch weil auf 68040 ein
   Copyback vorhanden ist. Eine "Ermächtigung" von DATA CACHE, die wirklich böse
   ist, so sehr, dass nicht einmal einige in C-Sprache kompilierte Programme
   funktionieren. Machen Sie sich also ab und zu einen "ClearMyCache", der nicht
   schadet.

	-	-	-	-	-	-	-	-	-

11) Ein weiteres Inkompatibilitätsproblem, auf das ich gestoßen bin, ist das des
   Interrupt auf A4000. Mir ist aufgefallen, dass viele Demos, sogar AGA, sehr gut 
   auf A1200 funktionierten, aber auf A4000 spielten sie Musik mit doppelter
   Geschwindigkeit. Sie ruckelten und manchmal hang sich das System auf. Ich habe
   es geschafft, davon zu berichten, dass dies auf eine Vergesslichkeit
   zurückzuführen war, wenn der Code auf A4000 ausgeführt wird.
   Schauen Sie sich diesen Interrupt des Level 3 an (sozusagen die $6c):

INTERRUPT:
	MOVEM.L	D0-D7/A0-A6,-(SP)
	BSR.W	ROUTINE1
	BSR.W	ROUTINE2
	BSR.W	ROUTINE3
	BSR.W	ROUTINE4
	MOVEM.L	(SP)+,D0-D7/A0-A6
NOINT:
	move.w	#$20,$dff09c	; INTREQ - vertb (bit 5 - $20 = %100000)
	rte
	
   Was ist los??? Wohlgemerkt, es wurde in VBR + $6c gut gemacht, also
   wird es regelmäßig ausgeführt.
   Die Lösung ist:	DER BIT-TEST IN INTREQR FEHLT!!!!
   Hier ist, wie es geändert werden muss:

INTERRUPT:
	btst.b	#5,$dff01f		; INTREQR - vertb int? (bit5)
	beq.s	NOINT			; keine echter interrupt VERTB
	MOVEM.L	D0-D7/A0-A6,-(SP)
	BSR.W	ROUTINE1
	BSR.W	ROUTINE2
	BSR.W	ROUTINE3
	BSR.W	ROUTINE4
	MOVEM.L	(SP)+,D0-D7/A0-A6
NOINT:
	move.w	#$20,$dff09c	; INTREQ - vertb (bit 5 - $20 = %100000)
	rte

   Tatsächlich funktioniert der Interrupt bei A500 / A1200 oft auch sehr gut
   ohne das Bit in INTREQR zu überprüfen, aber auf A4000 muss es IMMER gesetzt
   werden. Andernfalls wird der Interrupt milliardenfach zu oft ausgeführt. 
   Also NIEMALS vergessen, die Bits zu testen, die den Interrupt in INTREQR 
   erzeugt haben! Wie wir bereits gesehen haben, für jede Ebene von Interrupt
   gibt es ein bisschen von dem zu testenden $dff01f (INTREQR).

   Eine Erinnerung:

   INT $64	LEVEL1	bits 0 (soft) ,1 (dskblk) ,2 (serial port tbe)

   INT $68	LEVEL2	bit 3 (ports)

   INT $6c	LEVEL3	bits 4 (copper) ,5 (verticalblank) ,6 (blitter)

   INT $70	LEVEL4	bits 7 (aud0) ,8 (aud1) ,9 (aud2) ,10 (aud3)

   INT $74	LEVEL5	bits 11 (serial port rbf) ,12 (disksyn)

   INT $78	LEVEL6	bit 13 (external int)

   Denken Sie immer daran am Anfang des Interrupts ein btst zu machen und für
   den Fall, wenn das Bit nicht gesetzt ist (beq), auszugeben ohne die Routinen
   auszuführen. Beim Beenden müssen Sie immer auf $dff09c reagieren, um die
   Anforderung zu entfernen. In der Praxis "markieren" wir, dass der Interrupt
   ausgeführt wurde.
   Achten Sie darauf, den Fehler, den auch ich in der Vergangenheit gemacht habe,
   nicht zu machen. Zum Beispiel ein "BTST #11,$dff01f". In diesem Fall eigentlich
   Testbit 11-8, dh Bit 3 von $dff01f. Sie werden sich an die Geschichte erinnern,
   wenn Sie also "#6,$dff002" schreiben, ist dies dasselbe wie das Schreiben von
   "btst #14,$dff002". Tatsächlich assemblieren auch einige Assembler
   BTST-Anweisungen für Adressen mit Bits größer als 7, trotzdem das nutzlos ist,
   da es die Nummer dieses Bits auf 8 skaliert. Andere Assembler wie der Devpac 3
   geben einen Fehler aus und lassen dies nicht zu. Assemblieren Sie solche
   unnötigen mit BTST.b. (HINWEIS: .BYTE! = Von 0 bis maximal 7!)

	-	-	-	-	-	-	-	-	-

- PROBLEM FÜR DIE, DIE EINEN DER IN DER LEKTION BESCHRIEBENEN FEHLER MACHEN!!!

