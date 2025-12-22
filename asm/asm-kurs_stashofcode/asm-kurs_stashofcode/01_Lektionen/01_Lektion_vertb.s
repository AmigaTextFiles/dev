
; Lektion 01

VERWENDEN DES VERTB-INTERRUPTS AUF DEM AMIGA

11. Juli 2017 Amiga, Assembler 68000, Copper, Interrupt

Ein letztes für unterwegs! Im Anschluss an die vorherigen Artikelserien, die
sich mit den Themen der Programmierung eines Cracktros (1 und 2) und eines
Sinusscrolls (1,2,3,4 und 5) befasst hatten, wird nun die Art und Weise des
"Angreifens" der Hardware des Amiga 500 in 68000 Assembler nach Umgehung des
Betriebssystems	detailiert dargestellt, und zwar muss man auf einen heiklen
Punkt zurückkommen, der angesprochen wurde, nämlich den Umgang mit
"Hardware-Interrupts".

Das Problem, das genauer untersucht wurde, ist das folgende: Wie stellt man
unter "VERTB Interrupt" einen Codeabschnitt ein, dessen einzige Funktion
darin besteht, die Hintergrundfarbe (COLOR00) zu ändern? Um die Effekte
deutlich zu visualisieren, entwickeln wir ein Szenario, bei dem die
Hintergrundfarbe durch einen solchen Code merklich verändert wird, wenn der
Elektronenstrahl bestimmte vertikale Positionen erreicht:

Bild: Änderung von COLOR00 durch den Copper, das Hauptprogramm und einen
	  VERTB-Interrupt-Handler	; figure0-3.png 

Klicken Sie hier, um die Quelle des hier vorgestellten Programms
herunterzuladen.
Update 10.02.2018: Alle Quellen wurden um einen Abschnitt "StingRay's Stuff"
erweitert, der die einwandfreie Funktion auf allen Amiga-Modellen, insbesondere
mit Grafikkarte, gewährleistet.

SO FUNKTIONIEREN HARDWARE-INTERRUPTS

Wie in einem früheren Artikel erklärt, generiert die Amiga-Hardware Ereignisse,
die zu Unterbrechungen der Level 1 bis 6 der CPU führen können.
Zum Beispiel kann das VERTB-Ereignis, das auftritt, wenn der Elektronenstrahl,
den unteren Rand des Bildschirms erreicht hat, und beginnt, zum oberen Rand des
Bildschirms zurückzukehren, um den nächsten Frame anzuzeigen, einen
Interrupt der CPU der Stufe 3 verursachen. Die CPU stoppt dann die
Ausführung des Hauptprogramms, um den Interrupt-Handler auszuführen, dessen
Adresse in einer Interrupt-Vektortabelle gespeichert ist. Da dies ein Interrupt
der Ebene 3 ist, sagt uns das Benutzerhandbuch für M68000 8- / 16- / 32-Bit-
Mikroprozessoren, dass es sich um Vektor 27 handelt, der sich auf den
Interrupt-Handler an Adresse $6C bezieht:

Bild: Aufruf des Interrupt Manager Level 3 Interrupt Autovector bei einem
	  VERTB-Ereignis	; figure1-4-1024x314.png

Wir sprechen daher durch Sprachmissbrauch von einem Hardware-Interrupt, wie
beispielsweise einem VERTB-Interrupt, um den gerade erwähnten Interrupt zu
bezeichnen. Da diese Konvention jedoch praktisch ist, werden wir sie später
verwenden.

Die Liste der von der Hardware gemeldeten Ereignisse, die einen Interrupt der
Ebene 1 bis 6 der CPU verursachen können, finden Sie in der Dokumentation des
INTENA-Registers im Amiga-Hardware-Referenzhandbuch:

Bit	Name	Level	Beschreibung
15	SET/CLR		Dieses Bit wird später beschrieben.
14	INTEN		Dieses Bit wird später beschrieben.
13	AUSSEN	6	Externer Interrupt
12	DSKSYN	5	Der Inhalt des DSKSYNC-Registers entspricht den Daten auf der Platte
11	RBF		5	Empfangspuffer der seriellen Schnittstelle voll
10	AUD3 	4	Audiokanal 3 Block abgeschlossen
09	AUD2	4	Audiokanal 2 Block abgeschlossen
08	AUD1	4	Audiokanal 1 Block abgeschlossen
07	AUD0	4	Audiokanal 0 Block abgeschlossen
06	BLIT	3	Blitter-Vorgang abgeschlossen
05	VERTB	3	Beginn des vertikal blanks
04	Copper	3	Copper
03	PORTS	2	Ein-/Ausgangsports und Timer
02	SANFT	1	Reserviert für einen Software-initiierten Interrupt
01	DSKBLK	1	Disc-Block abgeschlossen
00	FSME	1	Leerer Übertragungspuffer der seriellen Schnittstelle

Die Hardware signalisiert immer die aufgelisteten Ereignisse, indem die
entsprechenden Bits in einem anderen Register Einstellung INTREQ. Auf
der anderen Seite unterbricht es die CPU nicht immer im Schritt.
Tatsächlich hängt alles von der Verwaltung ab, die das INTENA-Register
konfigurieren kann.
Wenn ein 16-Bit-X-Wert in INTENA geschrieben wird, zeigt der Zustand des
SET/CLR-Bits in X an, ob ein INTENA-Bit, das durch ein in X gesetztes Bit
bezeichnet wird, gesetzt oder gelöscht werden soll. Um beispielsweise das
Auslösen eines Level-3-Interrupts der CPU bei einem VERTB-Ereignis zu
verhindern, müssen wir $0020 in INTENA schreiben. Um es umgekehrt zu
aktivieren, müssen wir $8020 in dieses Register schreiben. Allerdings muss man
trotzdem mit dem INTEN-Bit rechnen.

Das INTEN-Bit ist eine Art allgemeiner Schalter:

- Wenn INTEN gelöscht wird, wird das Auslösen eines CPU-Interrupts bei einem
Hardwareereignis gesperrt, obwohl das einem Ereignis entsprechende Bit in
INTENA gesetzt ist. Wenn beispielsweise INTEN nie gesetzt wurde, reicht das
Schreiben von $8020 in INTENA nicht aus, um die Auslösung eines
Level-3-Interrupts der CPU bei VERTB-Ereignis zu aktivieren. Schreiben Sie
stattdessen $C020 in das Register auf Position INTEN und VERTB gleichzeitig
oder schreiben Sie $8020 auf die Position VERTB und dann $C000 auf die
Position INTEN - das Gegenteil ist möglich.

- Wenn INTEN gesetzt ist, wird das Auslösen von CPU-Interrupts bei Hardware-
reignissen aktiviert, jedoch nur bei Ereignissen, deren entsprechende Bits in
INTENA gesetzt sind. Beispielsweise hat das Schreiben von $C000 keine andere
Auswirkung, als das Auslösen eines Level-3-Interrupts der CPU bei VERTB-
Ereignis zu aktivieren, falls VERTB das einzige Bit ist, das einem Ereignis
entspricht, das in INTENA gesetzt wurde.

Eine wichtige Konsequenz dieser Operation ist, dass wir in INTENA schreiben
können, um die Art und Weise, wie die Hardware CPU-Interrupts bei Hardware-
Ereignissen generiert - kurz die Verwaltung von Hardware-Interrupts - sehr
selektiv zu verändern. Im folgenden Beispiel aktiviert die erste Anweisung nur
den Prozessalarm TBE und die zweite sperrt nur den VERTB-Interrupt - alles
was die Verwaltung der anderen Prozessalarme betrifft und der Generalschalter
INTEN bleibt unverändert:
	
	move.w #$8001,INTENA(a5)
	move.w #$0020,INTENA(a5)

Aus diesem Grund ermöglicht nur ein Lesen von INTENAR, dem Gegenregister von
INTENA in read only - INTENA ist in write only -, es möglich, genau über die
Verwaltung der Hardware-Interrupts zu einem bestimmten Zeitpunkt informiert
zu werden.

REDUZIEREN SIE HARDWARE-INTERRUPTS

Wir werden nicht auf die Details der Operationen eingehen, die erforderlich
sind, um eine Entwicklungsumgebung mit WinUAE für Windows einzurichten und ein
minimales 68000-Assemblerprogramm zu schreiben, das die volle Kontrolle über
die Amiga-Hardware übernimmt. All dies wurde in diesem Artikel bereits
sorgfältig besprochen.
Konzentrieren wir uns von Anfang an auf die Verwaltung von Hardware-Interrupts.
Nachdem das OS umgangen wurde, geht es darum, die Kontrolle über die sechs
Interrupt-Vektoren der CPU zu übernehmen, die von den 255, die letzterer zur
Verfügung stehen, den Interrupts der Ebene 1 bis 6 entsprechen, also den
Vektoren 25 bis 30.
Zunächst müssen wir den Zustand der Hardware-Interrupt-Behandlung speichern,
um ihn am Ende wiederherzustellen. Dazu lesen und speichern wir in oldintena-
und oldintreq- Variablen den Inhalt der INTENAR- und INTREQR-Register,
schreibgeschützte Versionen der INTENA- und INTREQ-Register:
	
	move.w INTENAR(a5),oldintena
	move.w INTREQR(a5),oldintreq

Wir können dann alle Hardware-Interrupts ausschalten:

	move.w #$7FFF,INTENA(a5)

Dabei quittieren wir alle Ereignisse, die die Hardware hätte signalisieren
können. Sicherlich wird die Hardware weiterhin einiges signalisieren, aber
zumindest wissen wir von diesem Moment an, dass, wenn die Hardware ein Bit in
INTREQ setzt, dies ein Ereignis sein wird, das eingetreten ist, nachdem wir
die Kontrolle übernommen haben:
	
	move.w #$7FFF,INTREQ(a5)

Schließlich lenken wir die Vektoren der Interrupts der Ebene 1 bis 6 um,
indem wir sie an ein Unterprogramm vom Typ Interrupt-Manager zurücksenden,
das uns gehört. Diese Vektoren zeigen auf Adressen $64 bis $78:
	
	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

Weiter codieren wir nach dem letzten RTS des Hauptprogramms den betreffenden
_rte-Interrupt-Handler:

_rte:
	rte

Dieser Manager tut daher absolut nichts, er bestätigt nicht einmal die
Benachrichtigung über das Hardware-Ereignis, das seinem Aufruf zugrunde liegt
- wir werden darauf zurückkommen.

EIN SZENARIO BASIEREND AUF VERTB-INTERRUPTS

Wie erklärt, funktioniert INTREQ genau wie INTENA, außer dass es verwendet
wird, um Ereignisse zu signalisieren, anstatt das Auslösen von CPU-Interrupts,
die mit den fraglichen Ereignissen verbunden sind, zu aktivieren/ zu
verhindern.

Wir müssen bei INTREQ zwei Dinge hinzufügen:

 - nichts kann die Hardware daran hindern, die auftretenden Ereignisse
   weiterhin in INTREQ zu melden;
 - es ist möglich, in INTREQ durch die CPU zu schreiben, um ein oder mehrere
   Hardware-Ereignisse zu simulieren.

Wir werden diese Punkte veranschaulichen. Das angenommene Szenario sieht wie
folgt aus:
 - das Hauptprogramm wartet auf das obere Viertel des Bildschirms
   (Zeile DISPLAY_Y + (DISPLAY_DY >> 2) ), um einen VERTB-Interrupt auszulösen,
   dessen Manager $00F0 (grün) an COLOR00 übergibt;
 - die Copper-Liste wartet, bis die Hälfte des Bildschirms
   (Zeile DISPLAY_Y + (DISPLAY_DY >> 1)) $0F00 (rot) an COLOR00 übergeben wird;
 - die Hardware wartet, bis der untere Bildschirmrand (Ende von Zeile 312 in
   PAL) einen VERTB-Interrupt auslöst, dessen Manager COLOR00 in $000F (blau)
   ändert.

CODIERE DAS SZENARIO

Beginnen wir mit der Copperliste.
Letztere läuft auf einen WAIT- Befehl hinaus , um zu warten, bis der
Elektronenstrahl die Hälfte des Bildschirms erreicht oder überschreitet,
gefolgt von einem MOVE-Befehl, um $0F00 (rot) in COLOR00 zu speichern:
	
	move.l copperlist,a0
	move.w #((DISPLAY_Y+(DISPLAY_DY>>1))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #COLOR00,(a0)+
	move.w #$0F00,(a0)+

Natürlich vergessen wir nicht, die Copper-Liste mit dem traditionellen
unmöglichen WAIT zu beenden:
	
	move.l #$FFFFFFFE,(a0)+

Lassen Sie uns nun das Hauptprogramm codieren.
Solange der Benutzer nicht die linke Maustaste gedrückt hat, durchläuft dieses
Programm den Elektronenstrahl in der ersten Viertelhöhe des Bildschirms. Es
speichert dann $00F0 (grün) in einer Farbvariablen, in der der VERTB-Interrupt-
handler die Farbe findet, die in COLOR00 gespeichert werden soll. Schließlich
veranlasst es den Aufruf dieses Managers, indem es einen VERTB-Interrupt
generiert, indem es an INTREQ schreibt:

_loop:

; Warten Sie auf das obere Viertel der Bildschirmhöhe

_wait0:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+(DISPLAY_DY>>2),d0
	blt _wait0

; Einen VERTB-Interrupt auslösen

	move.w #$00F0,color
	move.w #$8020,INTREQ(a5)

; Testen Sie den Druck der linken Maustaste	

	btst #6,$bfe001
	bne _loop

Warnung! Dieser Code muss durch eine _wait1- Schleife abgeschlossen werden,
die unmittelbar nach der _wait0- Schleife kommt. Sein Zweck besteht darin,
auf den Elektronenstrahl in Zeile 0 zu warten:

_wait1:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	bne _wait1

Tatsächlich dauert die Ausführung des Codes unseres Programms weniger Zeit als
der Elektronenstrahl, um die Abtastung der Zeile DISPLAY_Y + (DISPLAY_DY >> 2)
abzuschließen. Wenn Sie nicht auf eine nächste Zeile warten - in diesem Fall
Zeile 0, das könnte aber auch die Zeile unter DISPLAY_Y + (DISPLAY_DY >> 2) +1
gewesen sein, würde der Programmcode also nicht einmal pro Frame ausgeführt,
sondern mehrmals, wodurch nicht der gewünschte Effekt erzielt wird.
Schließlich müssen wir noch den Interrupt-Handler codieren.
Zuallererst sollte daran erinnert werden, dass ein Interrupt-Handler ein
Unterprogramm ist, das während der Ausführung eines Programms ausgeführt wird.
Daher ist es erforderlich, zumindest den Inhalt der Register zu sichern, die
vom Verwalter verwendet werden, um sie nach dessen Ende wiederherstellen zu
können. Dies geschieht normalerweise, indem der MOVEM- Befehl verwendet wird,
um den Inhalt der Register auf dem Stack zu speichern und zu lesen.
Dann sollten Sie wissen, dass, solange das Ereignis nicht durch Löschen seines
Bits in INTREQ quittiert wird, die Hardware den zugehörigen CPU-Interrupt
generiert. Um davon überzeugt zu sein, vergessen Sie einfach, das VERTB-
Ereignis im Interrupt-Handler zu quittieren und das Hauptprogramm so zu
ändern, dass es in eine COLOR00-Schleife bei $0FF0 (gelb) geht:

_loop:
	move.w #$0FF0,COLOR00(a5)
	btst #6,$bfe001
	bne _loop

Der Bildschirm ist vollständig blau oder fast vollständig blau und wird nur
während der seltenen Ausführungszyklen gelb unterbrochen, die das Ende des
Interrupt-Handlers der CPU ermöglicht, sich zu erholen, um die Ausführung des
Programms fortzusetzen, bevor sie den Interrupt-Handler erneut ausführen muss:

Das Programm wird fast vom Interrupt-Handler umgangen, der VERTB nicht bestätigt

Unter diesen Bedingungen muss der Interrupt-Handler unbedingt das Ereignis
quittieren, nach dem er aufgerufen wurde.
Daher muss der Code unseres Interrupt-Handlers mindestens wie folgt aussehen:

_vertb:
;	movem.l d0-d7/a0-a6,-(sp)	; Erforderlich, aber beschränkt auf
								; modifizierte Register
	move.w #$0020,INTREQR(a5)
;	movem.l (sp)+,d0-d7/a0-a6	; Erforderlich, aber beschränkt auf
								; modifizierte Register
	rte

In diesem Fall lautet der vollständige Code wie folgt:

_VERTB:
;	movem.l d0-d7/a0-a6,-(sp)	; Erforderlich, aber beschränkt auf
								; modifizierte Register
	move.w color,COLOR00(a5)
	move.w #$000F,color
	move.w #$0020,INTREQ(a5)
;	movem.l (sp)+,d0-d7/a0-a6	; Erforderlich, aber beschränkt auf
								; modifizierte Register
	rte

Die Copper-Liste, das Hauptprogramm und der Interrupt-Manager werden codiert,
es bleibt nur noch, das Ganze zu aktivieren. Nachdem der Copper aktiviert und
aufgefordert wurde, die Copper-Liste in einer Schleife auszuführen, genügt es,
die Adresse unseres Interrupt-Managers an der Adresse zu speichern, die im
Vektor des Level-3-Interrupts der CPU enthalten ist, also $6C ...:
	
	move.l #_VERTB,$6C

... bevor Sie die Hardware erneut autorisieren, diesen Level-3-Interrupt zu
 generieren, wenn sie das VERTB-Ereignis erkennt:

	move.w #$C020,INTENA(a5)	; INTEN=1, VERTB=1

Das Ergebnis ist das am Anfang dieses Artikels vorgestellte.

HARDWARE-INTERRUPTS WIEDERHERSTELLEN

Wenn der Benutzer mit der linken Maustaste klickt, endet das Programm, indem
die Hand so sauber wie möglich an das Betriebssystem zurückgegeben wird. Ohne
auf die anderen uns obliegenden Aufgaben zurückzukommen - sie werden in diesem
Artikel detailliert beschrieben - konzentrieren wir uns daher noch einmal auf
das Management von Hardware-Interrupts.
Wir fangen daher an, die Erzeugung von CPU-Interrupts durch die Hardware nicht
wieder zu kürzen ...:
	
	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)

... bevor Sie die Interrupt-Vektoren wiederherstellen ...:

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a1)+,(a0)+
	ENDR

... und stellen Sie die Erzeugung von CPU-Interrupts durch die Hardware wieder
    her:

	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

Es ist fertig!

EINE FEINHEIT ZUM ABSCHLUSS ...

Beachten Sie, dass der Copper Schreibzugriff auf INTREQ hat. Daher ist es
durchaus möglich, einen VERTB-Interrupt an jeder Position des Elektronenstrahls
auszulösen, die der Copper erkennen kann - wie in diesem Artikel erläutert
wurde, sind seine Fähigkeiten in dieser Hinsicht begrenzt, da die vertikale
Granularität sicherlich eine Linie ist, aber die die horizontale Granularität
beträgt nur 4 Pixel bei niedriger Auflösung.
Verwenden Sie also einfach einen MOVE in der Copperliste:
	
	move.l copperlist,a0
	;...
	move.w #INTREQ,(a0)+
	move.w #$8020,(a0)+

Als Beispiel ist hier das Ergebnis einer Variante des zuvor vorgestellten
Programms. Hier löst der Copper einen VERTB-Interrupt aus, wenn der
Elektronenstrahl das letzte Viertel der Bildschirmhöhe erreicht oder
überschreitet, mit dem Effekt, dass COLOR00 auf $0000 (schwarz) geändert wird:

Bild: Komplexere Version, bei der der Copper einen VERTB-Interrupt auslöst 
	; figure3-3.png

Klicken Sie hier, um die Quelle des Programms herunterzuladen, das diesen
Effekt erzeugt.
