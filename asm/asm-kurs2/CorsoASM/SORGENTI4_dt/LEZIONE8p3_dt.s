
; Lezione8p3.s	Funktion der Condition Codes mit der Anweisung TST

	SECTION	CondC,CODE

Inizio:
	tst.w	dato	
stop:
	rts


dato:
	dc.w	$ff02

	end

;	 \  /
;	  oO
;	 \__/

Der TST-Befehl vergleicht in der Praxis den Operanden mit Null.
Wir haben gesehen, dass der MOVE-Befehl den CC modifiziert und uns Informationen 
gibt, wenn kopiert wird. Wenn wir diese Informationen erhalten möchten, 
OHNE die Daten zu kopieren können wir den TST-Befehl verwenden.
Es ist eine Anweisung mit einem einzelnen Operanden, der einen Wert liest und  
alle darauf basierenden CCs ändert.
Die CCs werden auf dieselbe Weise wie die der MOVE-Anweisung geändert:

Die V- und C-Flags werden gelöscht
Das X-Flag wird nicht geändert
Das Z-Flag nimmt den Wert 1 an, wenn die getesteten Daten 0 sind
Das N-Flag nimmt den Wert 1 an, wenn die getesteten Daten negativ sind.

Stellen Sie das Programm zusammen und führen Sie die TST Anweisung aus:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CBD594
SSP=07CBE6C7 USP=07CBD594 SR=8008 T1 -- PL=0 -N--- PC=07CC0F52
PC=07CC0F52 4E75		 RTS
>

Das N-Flag hat den Wert 1, da sich das WORT welches sich an der Adresse im Speicher
befindet den Wert $ff03 hat, was eine negative Zahl ist, weil das MSB (Most
Signifikant Bit) 1 ist.

Sie können den an der "angegebenen" Adresse enthaltenen Wert ändern und beobachten,
wie sich TST verhält.
Beachten Sie, dass es nicht möglich ist, TST mit Adressregistern zu verwenden, d.h.
wenn Sie versuchen:

	TST.W	A0

gibt der ASMONE Ihnen eine Fehlermeldung.

