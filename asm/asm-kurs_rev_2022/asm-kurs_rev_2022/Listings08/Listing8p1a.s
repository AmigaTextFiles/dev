
; Listing8p1a.s		Verhalten der Condition Codes bei der Anweisung MOVE

; Hier ist das Programm für diese Lektion: 2 Anweisungen.
; Glauben sie, ich will sie auf den Arm nehmen? Nach allem, was Sie gesehen
; haben? Glauben Sie, dass Sie bis jetzt schon alles über dieses einfache
; Programm wissen?
; Nun, sie liegen falsch. Folgen Sie den Anweisungen im Kommentar.

	SECTION	CondC,CODE

Inizio:
	move.l	#$0000,d0
stop:
	rts

	end

;	 oO
;	\__/
;	 U

In diesem und in den folgenden Listings werden wir die Bedingungscodes 
(sogenannte CCs, Condition Codes) des Statusregisters sehen. Die CCs sind
ausführlich in der Lektion 68000-2.TXT beschrieben.
Wenn Sie sich nicht gut erinnern, was sie sind und wie sie funktionieren, 
empfehle ich Ihnen, sie erneut zu lesen.
Lassen Sie uns kurz daran erinnern, dass die CCs Bits sind, die im
Statusregister platziert sind. Diese werden von den Assembler-Anweisungen
geändert, um Informationen zum Ergebnis der durchgeführten Operation zu geben.
Es gibt Anweisungen, die alle CCs ändern, andere, die nur einige ändern und
andere, die keine von ihnen ändern.
Darüber hinaus tut jeder Befehl, der die CCs modifiziert, dies auf seine
eigene Weise. In Lektion 68000-2.TXT wird für jede Assembler-Anweisung kurz die
Auswirkung auf die CCs beschrieben. In diesen Listings werden wir kleine
praktische Beispiele präsentieren, wie die am häufigsten verwendeten
Anweisungen die CCs modifizieren.
Dies sind langweiligere Listings als die, die wir bisher gesehen haben, aber es
ist notwendig, dass Sie sie gut studieren, wenn Sie einmal ein ECHTER Coder
werden wollen. In diesem Listing werden wir die MOVE-Anweisung untersuchen.

Es ist, wie Sie wissen sollten, eine Anweisung, die den Inhalt eines 
Registers oder einer Speicherstelle kopiert und die CCs entsprechend ändert.
Um zu beobachten, wie diese Anweisung funktioniert, verwenden wir ASMONE.
Führen Sie das Programm STEP-BY-STEP aus, dh jeweils eine Anweisung.

Assemblieren Sie dazu das Programm wie gewohnt, aber noch NICHT ausführen.
Geben Sie stattdessen im ASMONE den Befehl X ein, durch den der Inhalt 
aller vorhandenen Register des 68000 und die nächste Anweisung, die
ausgeführt wird, ausgegeben wird.
Diese Informationen werden von ASMONE in 4 Zeilen unten zusammengefasst:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CAAE9C 
SSP=07CABFD3 USP=07CAAE9C SR=0000 -- -- PL=0 ----- PC=07CAE030
PC=07CAE030 303C0000             MOVE.W  #$0000,D0
>

Wir erklären kurz die Bedeutung dieser 4 Zeilen. Die erste Zeile repräsentiert
den Inhalt der 8 Datenregister des 68000. Sie können in der Tat sehen, wie es
8 Zahlen gibt, die durch ein Leerzeichen voneinander getrennt sind. Diese
stellen den Inhalt der Register dar, beginnend mit D0 (das auf der linken
Seite) und der Reihe nach weiter bis zu D7. Beachten Sie, wie alle Register
gelöscht werden, bevor Sie das Programm ausführen.

Die zweite Zeile repräsentiert exakt den Inhalt der Adressregister in der
gleichen Weise, wie die erste den Inhalt der Datenregister darstellt. Beachten
Sie, dass alle Register gelöscht sind, mit Ausnahme von A7, das die Adresse
des Stackpointers (Stack) enthält.

Die dritte Reihe zeigt andere Prozessorregister. Im Moment beschäftigen wir uns
nur mit dem PC (Programmcounterr) und dem SR (Statusregister).

Der PC enthält die Adresse des nächsten auszuführenden Befehls. Wie sie wissen
befinden sich die Anweisungen, aus denen ein Assembler-Programm besteht, im
Speicher!

Die Speicheradresse der nächsten Anweisung, von der es bezogen wird, ist im PC 
enthalten. In diesem Fall lautet die Adresse 07CAE030, was Teil des 
32-Bit-FAST-Speichers ist, der auf A1200 / A4000 und dergleichen vorhanden ist. 

Es ist natürlich so, dass dieser Wert auf verschiedenen Computern an
verschiedenen Speicherorten sein wird, und auch auf dem gleichen Computer wird 
kann er von Zeit zu Zeit anders sein, da die Programme verschoben werden
können.

Vom SR, dem Statusregister, haben wir bereits in 68000-2.TXT gesprochen. Wir 
werden uns vorerst nur um das Low-Byte mit den CCs kümmern. Beachten Sie, dass
der Inhalt von SR hexadezimal dargestellt wird.

Den Inhalt der einzelnen CCs zu lesen kann unpraktisch sein. Aus diesem Grund
werden die CCs getrennt dargestellt. 
Sie werden in der Tat feststellen, dass es unmittelbar vor dem Inhalt des PC
5 Striche gibt. Jeder Strich repräsentiert einen anderen CC und zeigt an, dass
es auf Null gesetzt ist. Wenn einer der CCs den Wert 1 anstelle des
Bindestrichs hat, wird der Buchstabe, der den Bindestrich benennt, gedruckt: 
Wenn zum Beispiel das Carry zu 1 wird, wird anstelle des entsprechenden Strichs 
der Buchstabe C gedruckt.

Schließlich können wir in der vierten Zeile die nächste Anweisung lesen, die
als Nächstes ausgeführt wird. In diesem Fall ist es die erste Anweisung des
Programms.

HINWEIS: Wenn Sie die ASMONE-Ausgabe in eine Datei drucken möchten, können Sie
dies tun. Verwenden Sie den Befehl > oder wählen Sie den entsprechenden Eintrag
im Menü Befehl aus.
Der ASMONE fragt Sie nach dem Namen der Datei, in der Sie die Ausgabe drucken
möchten und das Spiel ist geschafft. Genau so wurde die Ausgabe des X-Befehls
gedruckt.

An diesem Punkt können wir die erste Anweisung des Programms ausführen, dh:

          MOVE.W  #$0000,D0

Wir geben dem ASMONE den Befehl K. Die Anweisung wird ausgeführt und es wird
automatisch der Inhalt der Register gedruckt:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CAAE9C 
SSP=07CABFCF USP=07CAAE9C SR=8004 T1 -- PL=0 --Z-- PC=07CAE034
PC=07CAE034 4E75		 RTS
>

Unsere Anweisung hat im Register D0 den Wert $0000 gesetzt. Außerdem hat es
auch die CCs geändert. Beachten Sie, dass der Inhalt von SR jetzt $8004 ist.
Das Low-Byte hat den Wert $04, was in Binärform %00000100 geschrieben wird. Das
bedeutet das Bit 2, das CC "Zero" entspricht, den Wert 1 angenommen hat. Wie
ich es am Anfang gesagt hatte, wurde einer der fünf Striche, die früher
erschienen, durch das Zeichen "Z", das anzeigt, dass das "Zero"-Flag den Wert 1
übernommen hat, ersetzt.

Der MOVE-Befehl ändert die CCs tatsächlich wie folgt:
Die V- und C-Flags werden gelöscht
Das X-Flag wird nicht geändert
Das Z-Flag nimmt den Wert 1 an, wenn die zu kopierenden Daten 0 sind
Das N-Flag nimmt den Wert 1 an, wenn die kopierten Daten negativ sind.

In unserem Fall nimmt das Z-Flag den Wert 1 an, da die Daten, die wir nach D0 
kopieren, $0000 sind und das Flag N nimmt den Wert 0 an (da $0000 KEINE
negative Zahl ist).

Schauen wir uns nun einige andere Beispiele für die Verwendung der MOVE-
Anweisung an. Ändere im Source den MOVE und schreibe:

	move.w	#$1000,d0

Wiederholen Sie nun den Vorgang, um das Programm STEP BY STEP auszuführen.
Nach dem Ausführen des MOVE haben wir folgende Situation:

D0: 00001000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07C9EDFC 
SSP=07C9FF2F USP=07C9EDFC SR=8000 T1 -- PL=0 ----- PC=07CA2E40
PC=07CA2E40 4E75		 RTS     

Wir können feststellen, dass D0 jetzt den Wert $00001000 enthält, oder vielmehr 
das was wir mit dem MOVE zu ihm kopiert haben. Auch diesmal sind die CCs alle
gelöscht. Das hängt davon ab, dass der Wert $1000 ist, den wir kopiert haben
anders als null und auch eine positive Zahl ist.

Nehmen wir eine weitere Änderung vor.
Anstelle des Wertes von $1000 setzen wir $8020 ein und erhalten:

	move.w	#$8020,d0			; dh "move.w #-32736,d0

Diesmal nach der Ausführung des MOVE erhalten wir:

D0: 00008020 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07C9EDFC 
SSP=07C9FF2F USP=07C9EDFC SR=8008 T1 -- PL=0 -N--- PC=07CA2E40
PC=07CA2E40 4E75		 RTS

Wie Sie sehen, hat D0 den gewünschten Wert und das Flag N hat den Wert 1
angenommen. Der Grund ist, dass die Zahl $8020 eine negative Zahl ist,
weil sein höchstwertiges Bit 1 ist.

Lassen Sie uns jetzt das MOVE wie folgt ändern:

	move.l	#$8020,d0

Wir haben einfach die Größe der verschobenen Daten geändert. Diese Tatsache
bedeutet, dass wir jetzt den Wert $8020 als 32-Bit-Zahl betrachten müssen
oder als $00008020. Jetzt ist das höchstwertige Bit das Bit 31, nicht das
Bit 15 wie zuvor! In diesem Fall handelt es sich also um eine
POSITIVE Zahl. In der Tat erhalten Sie durch Ausführen des MOVE:

D0: 00008020 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07C9EDC4 
SSP=07C9FEF7 USP=07C9EDC4 SR=8000 T1 -- PL=0 ----- PC=07CA33CA
PC=07CA33CA 4E75		 RTS
>

Hier können Sie sehen, dass das Flag "N" gelöscht ist. 

