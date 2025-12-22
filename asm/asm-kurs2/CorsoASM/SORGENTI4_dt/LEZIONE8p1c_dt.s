
; Lezione8p1c.s		Funktion der Condition Codes mit der DIVU/DIVS

	SECTION	CondC,CODE

Inizio:
	moveq	#$0010,d0
	moveq	#$0003,d1
	divs.w	d1,d0

	move.l	#$200000,d0
	moveq	#$0002,d1
	divs.w	d1,d0
stop:
	rts

	end

;	·[oO]·
;	  C
;	 \__/
;	   U

Sehen wir uns nun ein Beispiel für die Verwendung von Divisionsanweisungen an.
Auch für die Division liefert der 68000 uns 2 verschiedene Befehle:
DIVS teilt zwei Zahlen und betrachtet sie als Zweierkomplementzahlen.
während DIVU die Zahlen immer als positiv geteilte Zahlen ansieht.

Die Unterschiede sind daher denen von MULS und MULU ähnlich.
Wir werden sie in unseren Experimenten veranschaulichen. 
Die Beispiele, die wir machen werden, betreffen DIVS.

Die Divisionsbefehle unterteilen einen 32-Bit-Operanden in ein Datenregister.
Bei einem 16-Bit-Teiler wird der 16-Bit-Quotient in das Low-Word 
des Zielregisters und der Rest im oberen Wort geschrieben.

Bei Division durch 0 führt der 68000 eine Ausnahmeroutine durch
und in den meisten Fällen haben Sie eine schöne GURU MEDITATION.
Die Aufteilung kann die Bedingungscodes folgendermaßen beeinflussen:

1) Carry (C) es wird immer auf 0 gesetzt
2) Overflow (V) wird gesetzt, wenn der Dividend größer als der Divisor ist
Das Ergebnis kann nicht in 16 Bit enthalten sein
zB:
	move.l	#$ffffffff,d0
	divu.w	#2,d0

3) Zero (Z) wird auf 1 gesetzt, wenn das Ergebnis der Operation 0 ist
4) Negativ (N) wird auf 1 gesetzt, wenn das Ergebnis der Operation negativ ist
5) Extend (X) bleibt unverändert.
----------------------------------------------------------------------------

Zunächst sehen wir ein normales Beispiel: Wir teilen die Zahl $10 (=16) in
Register D0 mit der in D1 enthaltenen Zahl 3.

D0: 00000010 00000003 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154 
SSP=07D33287 USP=07D32154 SR=8000 T1 -- PL=0 ----- PC=07D34CE8
PC=07D34CE8 81C1		 DIVS.W  D1,D0
>

Das Ergebnis ist unten dargestellt. Beachten Sie, dass sowohl der Quotient 
berechnet wird (wird in das niedrige Wort D0 gesetzt), und dass der Rest 
(in das hohe Wort von D0 gesetzt wird).
Es ist in der Tat eine Trennung zwischen ganzen Zahlen.

D0: 00010005 00000003 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154
SSP=07D33287 USP=07D32154 SR=8000 T1 -- PL=0 ----- PC=07D34CEA
PC=07D34CEA 203C00200000	 MOVE.L  #$00200000,D0
>

Schauen wir uns ein anderes Beispiel an.
Wir teilen die Zahl $200000 (in D0 enthalten) durch $2 (in D1).

D0: 00200000 00000002 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154 
SSP=07D33287 USP=07D32154 SR=8000 T1 -- PL=0 ----- PC=07D34CF6
PC=07D34CF6 81C1		 DIVS.W  D1,D0
>

Das genaue Ergebnis ist $100000, wie Sie mit dem "?" von Asmone sehen. 
Diese Zahl ist jedoch zu groß, um in ein Wort zu passen.
Daher führt der DIVS die Berechnung nicht korrekt aus und meldet dies
durch das Setzen des Flags V auf 1:

D0: 00200000 00000002 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154
SSP=07D33287 USP=07D32154 SR=8002 T1 -- PL=0 ---V- PC=07D34CF8
PC=07D34CF8 4E75		 RTS
>

In solchen Fällen muss die Aufteilung in den Algorithmen erfolgen.

