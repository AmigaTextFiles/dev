
; Lezione8m9.s	Funktion der Condition Codes bei den Shift-Anweisungen 

	SECTION	CondC,CODE

Inizio:
	move.w	#$c003,d0
	move.w	d0,d1
	lsr.w	#1,d0
	asr.w	#1,d1

	move.w	#$6000,d0
	move.w	d0,d1
	lsl.w	#1,d0
	asl.w	#1,d1
stop:
	rts

	end

In diesem Beispiel werden wir die Shift-Anweisungen diskutieren und die 
Unterschiede zwischen arithmetischen (ASx) und logischen (LSx) 
Verschiebungsanweisungen hervorheben.
Beginnen wir mit dem rechts Shift. Nehmen wir die Nummer $C003 und verschieben 
Sie sie um 1 Stelle (was einer Division durch 2 entspricht) nach rechts. 
Wir beginnen mit LSR:

D0: 0000C003 0000C003 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8008 T1 -- PL=0 -N--- PC=07CA78A6
PC=07CA78A6 E248		 LSR.W   #1,D0
>

Das LSR interpretiert Zahlen immer als positive Zahlen.
Wir stellen fest, dass die Zahl $C003 zu $​​6001 geworden ist, was richtig ist, 
wenn wir es als positiv annehmen. Beachten Sie auch, dass das C-Flag den
Wert des Bits, das rechts ausgegeben wurde übernommen hat, in diesem Fall 1.

D0: 00006001 0000C003 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8011 T1 -- PL=0 X---C PC=07CA78A8
PC=07CA78A8 E241		 ASR.W   #1,D1
>

Das ASR interpretiert stattdessen die Zahlen als Zweierkomplement. In diesem 
Fall wird $C003 daher als negative Zahl interpretiert und als Ergebnis 
erhalten wir $E001, welches im Zweierkomplement korrigiert wird, wie Sie
mit dem Befehl "?" von ASMONE sehen können.

D0: 00006001 0000E001 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8019 T1 -- PL=0 XN--C PC=07CA78AA
PC=07CA78AA 303C6000		 MOVE.W  #$6000,D0
>

Nun kommen wir zur Verschiebung nach links, die der Multiplikation 
"entspricht". Auch hier gibt es den gleichen Unterschied zwischen
ASL und LSL. Mal sehen, wie es ist bei LSL ist:

D0: 00006000 00006000 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8010 T1 -- PL=0 X---- PC=07CA78B0
PC=07CA78B0 E348		 LSL.W   #1,D0
>

Wie Sie sehen können, ist das Ergebnis der Linksverschiebung von $6000 gleich
$C000 richtig, wenn wir $C000 als positive Zahl interpretieren. Mal sehen, 
was stattdessen die ASL macht.

D0: 0000C000 00006000 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8008 T1 -- PL=0 -N--- PC=07CA78B2
PC=07CA78B2 E341		 ASL.W   #1,D1
>

Das Ergebnis ist immer noch $C000. Was falsch ist, wenn wir die Zahlen
im Zweierkomplement interpretieren. Warum? Wenn Sie $6000 in Dezimal umrechnen 
und mit 2 multiplizieren sehen Sie, dass das Ergebnis größer als 32767 ist und 
daher nicht korrekt in der Zweierkomplementnotation dargestellt sein kann. 
Beachten Sie, dass die ASL dies durch das Setzen des Flag V auf 1 anzeigt.
Dies ist bei LSL nicht der Fall.
Dies löscht immer das V-Flag. Dies ist der einzige (aber wichtige) Unterschied
zwischen den 2 Schiebebefehlen nach links.

D0: 0000C000 0000C000 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=800A T1 -- PL=0 -N-V- PC=07CA78B4
PC=07CA78B4 4E75		 RTS
>

