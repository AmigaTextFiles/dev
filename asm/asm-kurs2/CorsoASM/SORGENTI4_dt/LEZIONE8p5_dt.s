
; Lezione8p5.s	Funktion der Condition Codes bei der Anweisung NEG

	SECTION	CondC,CODE

Inizio:
	neg.w	dato1
	neg.w	dato2
	neg.w	dato3
	neg.w	dato4
stop:
	rts

dato1:
	dc.w	$ff02
dato2:
	dc.w	$4f02
dato3:
	dc.w	$0000
dato4:
	dc.w	$8000

	end

Schauen wir uns ein Beispiel für den NEG-Befehl an.
Es gibt zwei Negationsanweisungen, die 2 ergänzen können
Der Operand .B .W oder .L nimmt es von 0.
--------------------------------------------------------------------------
NEG     <ea>            Quelle=All
NEGX    <ea>            Quelle=All
--------------------------------------------------------------------------
Der Negationsbefehl kann somit die Bedingungscodes beeinflussen:

1.Bit0, Carry (C): wird auf 0 gesetzt, wenn der Operand Null ist,
                   andernfalls wird er auf 1 gesetzt.

2.Bit1, Overflow (V): Das Bit wird nur dann auf 1 gesetzt, wenn der Operand den
Wert von  $80 Bytes, $8000 Wörter, $80000000 long hat.

3.Bit2, Zero (Z): Das Bit wird auf 1 gesetzt, wenn das Ergebnis der Operation Null ist.
4.Bit3, Negativ (N): wird auf 1 gesetzt, wenn der Operand eine andere positive Zahl 
vom Grund Null ist.
5.Bit4, Extend (X): nimmt den gleichen Status wie Bit C an
------------------------------------------------------------------------------

Die erste Anweisung des Listings verarbeitet die Daten an der Adresse "DATO1"
eine negative Zahl. Indem wir es ausführen, erhalten wir:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA7934
SSP=07CA8A67 USP=07CA7934 SR=8011 T1 -- PL=0 X---C PC=07CFEBDA
PC=07CFEBDA 447907CFEBF0	 NEG.W   $07CFEBF0
>

Wie Sie mit dem ASMONE-Befehl "M.w dato1" sehen können, ist das Ergebnis
positiv (anders als null). Daher sind die einzigen CCs die auf 1 gesetzt werden das
C und X.
Das zweite NEG arbeitet stattdessen mit einem positiven Wert. Das Ergebnis ist also
negativ, und folglich ist diesmal auch das N-Bit 1:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA7934
SSP=07CA8A67 USP=07CA7934 SR=8019 T1 -- PL=0 XN--C PC=07CFEBE0
PC=07CFEBE0 447907CFEBF2	 NEG.W   $07CFEBF2
>

Wir befinden uns nun im dritten NEG, das mit dem in "dato3" enthaltenen Wert 
Null arbeitet. Wie Sie überprüfen können, ist das Ergebnis immer noch Null,
denn zu Recht ist das Negative (und damit das Zweierkomplement) von Null
immer noch Null. Was die CCs betrifft, werden sie alle gelöscht, mit Ausnahme 
von Z:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA7934
SSP=07CA8A67 USP=07CA7934 SR=8000 T1 -- PL=0 --Z-- PC=07CFEBE6
PC=07CFEBE6 447907CFEBF4	 NEG.W   $07CFEBF4
>

Nun kommen wir zum letzten Fall. Der Wert, mit dem das NEG diesmal arbeitet, ist
$8000 = -32678. Wie Sie wissen, können wir mit 16 Bits den Wert 32.678 NICHT 
darstellen. Da in diesem Fall das NEG mit dem Wort arbeitet, kann es das Ergebnis 
das wir suchen, nicht Richtig berechnen. Starten wir es, sehen wir, dass es
den Wert unterläuft (dh bei $8000), der an der Adresse "dato4" enthalten ist
und weist dem Flag V (oVerflov) den Wert 1 zu, um uns den Fehler zu signalisieren:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA7934
SSP=07CA8A67 USP=07CA7934 SR=801B T1 -- PL=0 XN-VC PC=07CFEBEC
PC=07CFEBEC 4E75		 RTS
>

