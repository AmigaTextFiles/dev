
; Listing8p7.s	Verhalten der Condition Codes bei der Anweisung CMP

	SECTION	CondC,CODE

Inizio:
	move.w	#$9000,d0
	move.w	#$6000,d1
	cmp.w	d0,d1	
	bgt.w	salto
stop:
	rts

salto:
	nop		; Dieser Sprung wird gemacht, wenn das Ziel größer als die
			; Quelle ist
	rts

	end

Der CMP-Befehl ermöglicht es uns, 2 Zahlen zu vergleichen und entsprechend die 
CCs einzustellen. Normalerweise folgt auf einen CMP ein Bcc-Befehl. 
Hier sind die 3 "Typen":

CMPA.x	<ea>,Ay		Quelle=All		Ziel=An (Hinweis: NUR .W o .L).
-----------------------------------------------------------------------------
CMPI.x	#d,<ea>		Quelle=#d		Ziel=Daten, die geändert werden können
-----------------------------------------------------------------------------
CMPM.x	(Ax)+,(Ay)+	Quelle=(An)+	Ziel=(An)+
-----------------------------------------------------------------------------

Jede der 68000 Vergleichsanweisungen subtrahiert den Quelloperanden vom Ziel
und setzt die Bedingungsflags gemäß der folgenden Tabelle:

+----------------------+---+---+---+---+
|Zustand			   | N | Z | V | C |
+----------------------+---+---+---+---+
|Quelle<Ziel		   | 0 | 0 |0/1| 0 |
+----------------------+---+---+---+---+
|Quelle=Ziel		   | 0 | 1 | 0 | 0 |
+----------------------+---+---+---+---+
|Quelle>Ziel		   | 1 | 0 |0/1| 1 |
+----------------------+---+---+---+---+

Das V-Bit hat den Wert 1, wenn die Differenz zwischen Quelle und Ziel
ausserhalb des möglichen Ergebnisbereiches im Zweierkomplementfeld des
Operanden liegt.
(d.h. wenn es kleiner ist als das die kleinste darstellbare negative Zahl oder
größer ist als die größte darstellbare positive Zahl).
N und V sind nur beim Vergleich von 2er-Komplement-Operanden von Bedeutung.

HINWEIS: Anders als die Subtraktionsanweisungen speichern die
Vergleichsanweisungen nicht das Ergebnis der Subtraktion !!!!!!!!
(Es scheint mir klar zu sein!)
------------------------------------------------------------------------------

Bccs lesen den Status der CCs und wenn eine bestimmte Bedingung erfüllt ist
(die zwischen den einzelnen Bccs variiert) wird ein Sprung ausgeführt oder
nicht. Der CMP setzt die CC-Flags auf die gleiche Weise wie der SUB.

Sehen wir uns ein kurzes Beispiel an. Wir führen einen Vergleich zwischen einer 
positiven und ein negativer Zahl durch. Wir sehen, dass das Ergebnis des
Vergleichs anders ausfällt, wenn wir die negative Zahl als positive betrachten.

Wir führen das Programm bis zur BGT-Anweisung aus.

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64 
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B52
PC=07CA7B52 6E000004		 BGT.W   $07CA7B58
>

Die bekannte BGT führt den Sprung aus, wenn der Zieloperand größer als der 
des Quelloperanden ist. Außerdem werden die Zahlen als Zweierkomplementwerte
betrachtet. In unserem Fall ist der Zieloperand größer als der Quelloperand,
da die erste Zahl positiv ist, während die zweite negativ ist.
Machen wir einen weiteren Schritt und überprüfen es:

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64 
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B58
PC=07CA7B58 4E71		 NOP
>

Wie Sie sehen, wurde der Sprung gemacht, in der Tat ist die nächste 
auszuführene Anweisung das NOP.
Versuchen wir nun zu sehen, was passiert, wenn der BGT durch die BHI-Anweisung 
ersetzt wird. Dieser Befehl führt auch den Sprung aus, wenn der Zieloperand 
größer als der Quelloperand ist. Der Unterschied besteht darin, dass der BHI 
die Zahlen als positiv berücksichtigt.
Wir führen das geänderte Programm aus.

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B52
PC=07CA7B52 62000004		 BHI.W   $07CA7B58
>

Diesmal werden $9000 als positive Zahl gewertet. Dann ist es ist größer
als $6000. Daher wird der Sprung nicht ausgeführt:

D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64
SSP=07CA6097 USP=07CA4F64 SR=800B T1 -- PL=0 -N-VC PC=07CA7B56
PC=07CA7B56 4E75		 RTS
>

Wenn Sie das CMP verwenden, müssen Sie also genau darauf achten, wie es ist.
Möchten Sie negative Zahlen interpretieren und verwenden daher das richtige
Bcc. 


