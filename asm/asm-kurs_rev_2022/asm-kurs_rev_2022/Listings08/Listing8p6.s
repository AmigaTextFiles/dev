
; Listing8p6.s		Verhalten der Condition Codes bei der Anweisung ADD 

	SECTION	CondC,CODE

Inizio:
	move.w	#$4000,d0
	move.w	#$2000,d1
	add.w	d0,d1
	move.w	#$e000,d0
	move.w	#$b000,d1
	add.w	d0,d1
	move.w	#$6000,d0
	move.w	#$5000,d1
	add.w	d0,d1
	move.w	#$9000,d0
	move.w	#$a000,d1
	add.w	d0,d1
stop:
	rts

	end


Die Anweisung ADD beeinflusst die Bedingungscodes wie folgt:

1) Bit0, Carry (C): wird auf 1 gesetzt, wenn das Ergebnis nicht im
   Zieloperanden enthalten sein kann.
   Beispiel: (Es wird angenommen, dass die Zahlen ohne Vorzeichen sind.)

	move.w	#$7001,d0			; d0=$7001
	add.w	#$8fff,d0			; d0=$7001+$8fff=$10000

  Wie Sie sehen können, kann das Ergebnis der Addition nicht in einem Wort
  enthalten sein. Da es 17 Bits benötigen würde, wird das C-Flag gesetzt.

2) Bit1, Overflow (V): Das Bit wird nur bei Addition von zwei Zahlen mit
   gleichen Vorzeichen auf 1 gesetzt, wenn es den Wertebereich des Operanden
   überschreitet. (zB bei WORD-Operanden ist das Flag V=1, wenn das Ergebnis
   größer als 32767 oder kleiner als -32768 ist)
   Beispiel: (vorzeichenbehaftete Zahlen)

	move.w	#$7fff,d0			; d0=$7fff
	addq.w	#$1,d0				; d0=$7fff+1=$8000=-32768 !!!!!

  In diesem Fall wird das Overflow-Bit gesetzt.

3) Bit2, Zero (Z): Das Bit wird auf 1 gesetzt, wenn das Ergebnis der Operation
   Null ist.
4) Bit3, Negativ (N): Das Bit wird auf 1 gesetzt, wenn die letzte Operation die
   ausgeführt wurde ein negatives Ergebnis hat.
5) Bit4, Extend (X): nimmt den gleichen Status wie Bit C an

V und N machen nur Sinn, wenn wir Zahlen mit Vorzeichen addieren.

Anmerkung: Wenn die Operation ein Adressregister als Zieloperand hat,bleiben
die Bedingungscodes unverändert !!!! Dies ist eine Variation des ADD-Befehls
und wird als ADD-Adresse ADDA bezeichnet.

Lassen Sie uns nun die Theorie überprüfen.
Wir führen die ersten 2 Schritte des Programms durch: Es sind 2 MOVEs, mit den
wir 2 Werte laden wollen die wir dann im Register addieren.
Dies sind 2 positive Werte.

D0: 00004000 00002000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4754
SSP=07CA5887 USP=07CA4754 SR=8000 T1 -- PL=0 ----- PC=07CA7A74
PC=07CA7A74 D240		 ADD.W   D0,D1
>

Wir führen die Addition aus. Wie Sie "von Hand" überprüfen können, wird die
Summe keinen Übertrag generieren, da das Ergebnis ($6000) eine kleinere Zahl
als $7fff ist und daher kann es immer noch in einem Wort enthalten sein. Dann
werden die Flags C, X und V zurückgesetzt. Außerdem werden auch Z und N auf
Null gesetzt, da $6000 positiv ist und von Null verschieden.

D0: 00004000 00006000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4754 
SSP=07CA5887 USP=07CA4754 SR=8000 T1 -- PL=0 ----- PC=07CA7A76
PC=07CA7A76 303CE000		 MOVE.W  #$E000,D0
>

Nun addieren wir zwischen $e000 und $b000. In diesem Fall haben wir es mit
negativen Zahlen zu tun. Das Ergebnis (das Sie von Hand überprüfen können)
ist $9000 = -28672, was größer ist als -32768 und daher kein Problem ist.
Damit ist das Flag V Null.
Beachten Sie jedoch, dass wir, wenn wir unsere 2 Zahlen als positiv betrachten
wollten, könnten wir das Vorzeichen weglassen. In diesem Fall würde das Wort
Werte zwischen 0 und 65535 annehmen.
In diesem Fall erhalten wir das Ergebnis, $9000 was offensichtlich nicht 
korrekt ist. Dies geschieht, weil das genaue Ergebnis von $e000 + $b000 
(betrachten Sie es selbst als positiv) $19000 = 102400 wäre, das heißt, eine
Zahl die größer als 65535 ist und für die 17 Bits erforderlich wären um sie
richtig darzustellen.

Der 68000 speichert das 17. Bit im Carry, um dieses Problem zu lösen. (und auch
in X), das daher den Wert 1 annimmt. Beachten Sie auch, da $9000 negativ ist
(als ein Zweierkomplement betrachtet wird), wird auch das N-Flag einen Wert
von 1 haben. Folgendes erhalten Sie durch Ausführen der Addition:

D0: 0000E000 00009000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4754
SSP=07CA5887 USP=07CA4754 SR=8019 T1 -- PL=0 XN--C PC=07CA7A80
PC=07CA7A80 303C6000		 MOVE.W  #$6000,D0
>

Schauen wir uns ein drittes Beispiel an. Diesmal addieren wir $5000 (= 20480) 
und $6000 (= 24576). Dies sind 2 positive Zahlen. Im Gegensatz zum ersten 
Beispiel jedoch, wenn wir die Summe von Hand ausführen, sehen wir, dass das 
Ergebnis 45056 (= $b000) ist.
Es ist größer als 32767 und wie Sie sehen können, ist es eine negative Zahl.
Wenn wir also die Zahlen im Zweierkomplement interpretieren, (gehen sie von
-32768 bis 32767) ist das Ergebnis falsch, und daher nimmt das Flag V den
Wert 1 an. Wenn wir stattdessen die Zahlen als positiv interpretieren (dh von
0 bis 65536) ist das Ergebnis korrekt, da es kleiner als 65535 ist. Daher
nimmt das Flag C den Wert Null an. Das N-Flag nimmt jedoch den Wert 1 an, da
wir eine negative Zahl haben (da es als Zweierkomplement interpretiert wird).
In der Tat:

D0: 00006000 0000B000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4754 
SSP=07CA5887 USP=07CA4754 SR=800A T1 -- PL=0 -N-V- PC=07CA7A8A
PC=07CA7A8A 303C9000             MOVE.W  #$9000,D0
>

Schauen wir uns ein letztes Beispiel an. Wir addieren $9000 und $a000. Das sind 
2 negative Zahlen. Wenn wir sie im Zweierkomplement interpretieren und
addieren, merken wir dass das Ergebnis kleiner als -32768 ist. Daher nimmt das
Flag V den Wert 1 an.
Wenn wir sie als positive Zahlen interpretieren, würden wir, da ihre Summe 
$13000 wäre, 17 Bits benötigen. Daher ist auch das C-Flag 1.
Als Ergebnis erhalten wir $3000 oder die niederwertigen 16 Bits der Summe.
Da $3000 positiv ist, ist das N-Flag Null.

D0: 00009000 00003000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4754 
SSP=07CA5887 USP=07CA4754 SR=8013 T1 -- PL=0 X--VC PC=07CA7A94
PC=07CA7A94 4E75                 RTS     
>

