
; Listing8p1b.s		Verhalten der Condition Codes bei MULU / MULS

	SECTION	CondC,CODE

;	 oO 
;	 C _
;	\__/
;	  U 

Inizio:
	move.l	#$0003,d0			; schneller wäre "moveq #3,d0"...
	move.l	#$c000,d1
	muls.w	d0,d1

	moveq	#3,d0				; Hier haben wir es benutzt... vah!
	move.l	#$c000,d1
	mulu.w	d0,d1
stop:
	rts

	end

Sehen wir uns nun ein Beispiel für die Verwendung von Multiplikationsanweisungen
an. Der 68000 bietet uns 2 verschiedene Multiplikationsanweisungen:
MULS multipliziert zwei Zahlen, indem er sie als Zweierkomplementzahlen
betrachtet, während MULU die Zahlen immer als positiv bewertet.
Muls / Divs arbeiten mit Zweierkomplementzahlen, während Mulu / Divu diese 
als vorzeichenlose Zahlen verwenden.

	MULU    <ea>,Dn         Quelle=Daten    Ziel=Dn
	MULS    <ea>,Dn         Quelle=Daten    Ziel=Dn

Es ist nur möglich, 16-Bit-Zahlen (im Wortformat) zu multiplizieren und das
32-Bit-Produkt (Langwortformat) wird in einem Datenregister bereitgestellt.
Offensichtlich sind die mit MULU oder MULS erzielten Ergebnisse sehr
unterschiedlich. Nehmen wir ein Beispiel, indem wir $c000 mit $0003
multiplizieren.

D0: 00000003 0000C000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154 
SSP=07D33287 USP=07D32154 SR=8000 T1 -- PL=0 ----- PC=07D34CEC
PC=07D34CEC C3C0		 MULS.W  D0,D1
>

MULS betrachtet $c000 als negative Zahl.
Das Ergebnis ist das folgende:

D0: 00000003 FFFF4000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154
SSP=07D33287 USP=07D32154 SR=8008 T1 -- PL=0 -N--- PC=07D34CEE
PC=07D34CEE 203C00000003	 MOVE.L  #$00000003,D0
>

Das Ergebnis ist negativ (in der Tat haben wir eine positive Zahl mit 
einer negativen Zahl multipliziert) und daher ist das Flag N=1 gesetzt.
Ich erinnere die Unwissenden daran, dass, wenn sie zwei positive Zahlen 
multiplizieren, das Ergebnis positiv ist, ebenso, wenn 2 negative Zahlen 
multipliziert werden ist das Ergebnis positiv.
Wenn stattdessen eine negative Zahl mit einem positiven Wert multipliziert wird
oder ein positiver Wert mit einem negativen Wert ist das Ergebnis negativ.
Zusammenfassend: 	+ * + = +       - * - = +       + * - = -       - * + = -
Nun wollen wir sehen, wie sich MULU verhält, wobei $c000 als positive Zahl 
betrachtet wird.

D0: 00000003 0000C000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154
SSP=07D33287 USP=07D32154 SR=8000 T1 -- PL=0 ----- PC=07D34CFA
PC=07D34CFA C2C0		 MULU.W  D0,D1
>

Das Ergebnis ist das Folgende:

D0: 00000003 00024000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07D32154
SSP=07D33287 USP=07D32154 SR=8000 T1 -- PL=0 ----- PC=07D34CFC
PC=07D34CFC 4E75		 RTS
>

Wie Sie sehen, ist es ganz anders. Unter anderem ist es positiv und in der Tat
ist das Flag N=0. Deshalb muss man auch in Bezug auf die Multiplikationen die
zu verwendende Anweisung sorgfältig auswählen.

