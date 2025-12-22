
; Listing8p8.s		Verhalten der Condition Codes bei der Anweisung ADDX

	SECTION	CondC,CODE

Inizio:
	move.l	#$b1114000,d0
	move.l	#$22222222,d1
	move.l	#$82345678,d2
	move.l	#$abababab,d3
	add.l	d0,d2
	addx.l	d1,d3
	move.l	#$01114000,d0
	move.l	#$00000000,d1
	move.l	#$02222222,d2
	move.l	#$00000000,d3
	add.l	d0,d2
	addx.l	d1,d3
stop:
	rts

	end

Schauen wir uns ein Beispiel für die Verwendung der ADDX-Anweisung an.
Angenommen, wir müssen zwei 64-Bit-Ganzzahlen addieren, eine davon in D0 und D1
und die andere in D2 und D3. Zuerst addieren wir die 32 niederwertigen Bits
von den 2 Zahlen mit einem normalen ADD:

D0: B1114000 22222222 82345678 ABABABAB 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8008 T1 -- PL=0 -N--- PC=07CA74C4
PC=07CA74C4 D480		 ADD.L   D0,D2
>

Wir stellen fest, dass ein Übertrag generiert wird, weil die Summe zu groß für 
32 Bits ist. Daher nehmen die Flags C und X den Wert 1 an.
Um die 32 höchstwertigen Bits zu addieren, verwenden wir den ADDX, welches
auch den Inhalt des X-Flags zu den 2 Registern addiert, wobei der 
Übertragung berücksichtigt wird.

D0: B1114000 22222222 33459678 ABABABAB 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8013 T1 -- PL=0 X--VC PC=07CA74C6
PC=07CA74C6 D781		 ADDX.L  D1,D3
>

Somit haben wir unser 64-Bit-Ergebnis in den Registern D2 und D3

D0: B1114000 22222222 33459678 CDCDCDCE 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8008 T1 -- PL=0 -N--- PC=07CA74C8
PC=07CA7B3E 223C02222222	 MOVE.L  #$02222222,D1
>
 
Der ADDX ändert die Flags wie der ADD mit Ausnahme des Z-Flags.
Das Z-Flag wird nämlich zurückgesetzt, wenn das Ergebnis von ADDX ungleich Null
ist, wird aber unverändert gelassen, wenn das Ergebnis gleich Null ist. Dies
ermöglicht das Flag Z, um den Status des gesamten Vorgangs zu berücksichtigen.
Das folgende Beispiel zeigt es:
Wir addieren 2 64-Bit-Zahlen, aber beide haben die 32 höchstwertigen Bits auf
Null gesetzt.

D0: 01114000 00000000 02222222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8004 T1 -- PL=0 --Z-- PC=07CA8058
PC=07CA8058 D480		 ADD.L   D0,D2
>

Das ADD der niederwertigen Zahlen setzt Z auf den Wert 1, weil das Ergebnis
nicht null ist.

D0: 01114000 00000000 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8000 T1 -- PL=0 ----- PC=07CA805A
PC=07CA805A D781		 ADDX.L  D1,D3
>

Das Ergebnis des ADDX ist stattdessen genau Null. Wenn es sich so verhalten
würde wie das ADD dann sollte es das Z-Flag zurücksetzen. Aber selbst wenn
die Summe der 32 Bits (most significant) Null ist, ist das Ergebnis der
gesamten Operation nicht Null.
Der ADDX lässt daher das Z-Flag unverändert, so dass wir feststellen können,
dass das Ergebnis der gesamten Operation ungleich Null ist

D0: 01114000 00000000 03336222 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4A64
SSP=07CA5B97 USP=07CA4A64 SR=8000 T1 -- PL=0 ----- PC=07CA805C
PC=07CA805C 4E75		 RTS
>

Diese Art der Behandlung des Z-Flags wird auch von den Anweisungen SUBX und 
NEGX verwendet.

