
; Lezione8p7.s	Funktion der Condition Codes bei der Anweisung CMP

	SECTION	CondC,CODE

Inizio:
	move.w	#$9000,d0
	move.w	#$6000,d1
	cmp.w	d0,d1	
	bgt.w	salto
stop:
	rts

salto:
	nop	; Dieser Sprung wird gemacht, wenn das Ziel größer als die
		; Quelle ist
	rts

	end

Der CMP-Befehl ermöglicht es uns, 2 Zahlen zu vergleichen und entsprechend die 
CCs einzustellen. Normalerweise folgt auf einen CMP ein Bcc-Befehl. 
Hier sind die 3 "Typen":

CMPA.x	<ea>,Ay		Quelle=All	Ziel=An (Notiz: NUR .W o .L).
-----------------------------------------------------------------------------
CMPI.x	#d,<ea>		Quelle=#d	Ziel=Daten, die geändert werden können
-----------------------------------------------------------------------------
CMPM.x	(Ax)+,(Ay)+	Quelle=(An)+	Ziel=(An)+
-----------------------------------------------------------------------------

Jede der 68000 Vergleichsanweisungen subtrahiert den Quelloperanden
vom Ziel und setzt die Bedingungsflags gemäß der folgenden Tabelle:

+----------------------+---+---+---+---+
|Zustand			   | N | Z | V | C |
+----------------------+---+---+---+---+
|Quelle<Ziel		   | 0 | 0 |0/1| 0 |
+----------------------+---+---+---+---+
|Quelle=Ziel		   | 0 | 1 | 0 | 0 |
+----------------------+---+---+---+---+
|Quelle>Ziel		   | 1 | 0 |0/1| 1 |
+----------------------+---+---+---+---+

Bit V ist 1, wenn die Differenz zwische Quelle und Ziel größer als das
Ergebnis das Feld im Zweierkomplement des Operanden ist (das heißt, wenn es 
kleiner als die kleinste negative Zahl, die dargestellt werden kann oder 
größer als die größte positive darstellbare Zahl ist).
N und V sind nur dann signifikant, wenn Zweierkomplement Operanden verglichen 
werden.

HINWEIS: Anders als die Subtraktionsanweisungen speichern die Vergleichsanweisungen
nicht das Ergebnis der Subtraktion !!!!!!!! (Es scheint mir klar zu sein!)
------------------------------------------------------------------------------

Bccs lesen den Status von CCs und ob eine bestimmte Bedingung verifiziert ist
(die zwischen den einzelnen Bccs variiert) einen Sprung ausführen oder nicht.
Der CMP setzt die CC-Flags auf die gleiche Weise wie der SUB.

Sehen wir uns ein kurzes Beispiel an. Wir führen einen Vergleich zwischen einer 
positiven und ein negativer Zahl durch. Wir sehen, dass das Ergebnis des Vergleichs
anders ausfällt, wenn wir die negative Zahl als positive betrachten.

Wir führen das Programm bis zur BGT-Anweisung aus.

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64 
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B52
PC=07CA7B52 6E000004		 BGT.W   $07CA7B58
>

Die bekannte BGT führt den Sprung durch, wenn der Zieloperand größer als der 
des Quelloperanden ist.
Außerdem werden die Zahlen als Zweierkomplementwerte betrachtet.
In unserem Fall ist der Zieloperand größer als der Quelloperand,
da die erste positiv ist, während die zweite negativ ist.
Machen wir einen weiteren Schritt und überprüfen es:

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64 
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B58
PC=07CA7B58 4E71		 NOP
>

Wie Sie sehen, wurde der Sprung gemacht, in der Tat ist die nächste 
durchzuführene Anweisung das NOP.
Versuchen wir nun zu sehen, was passiert, wenn die BGT durch die BHI-Anweisung 
ersetzt wird. Dieser Befehl führt auch den Sprung aus, wenn der Zieloperand 
größer als der Quelloperand ist. Der Unterschied besteht darin, dass der BHI 
die Zahlen als positiv berücksichtigt.
Wir führen das geänderte Programm aus.

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B52
PC=07CA7B52 62000004		 BHI.W   $07CA7B58
>

Diesmal werden $9000 als positive Zahl gewertet. Dann ist es
ist größer als $6000. Daher wird der Sprung nicht ausgeführt:

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B56
PC=07CA7B56 4E75		 RTS
>

Wenn Sie das CMP verwenden, müssen Sie also genau darauf achten, wie es ist.
Sie möchten die negativen Zahlen interpretieren und dann das richtige Bcc 
verwenden.

