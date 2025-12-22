
; Listing13g.s	 bis Ende suchen oder Stelle finden
; Zeile 1610

start:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
		
	movea.l	String(PC),a0		
	; lea	Zeichenkette,a0	
	move.b	char,d1				; Character zu suchen	z.B. nach 'C' suchen = 67

	move.w	Len(PC),d0			; Max Länge zu suchen <> 0
FdLoop:
	cmp.b	(a0)+,d1		
	dbeq	d0,FDLoop			; Ausstieg wenn Zeichen gefunden wurde
								; oder wenn alle Zeichen untersucht wurden	

	move.w	Len(PC),d2	
	sub.w	d0,d2					
	addq.b	#1,d2				; Ergebnis in d2	A=1,B=2,C=3,...,I=9,O=F
								; Zeichen nicht gefunden, Ausgabe 17=$11
	rts
	
Len:
	dc.w	15					; 15 characters

Char: 
	dc.b	'O'		
	even

Zeichenkette:
	dc.b	'ABCDEFGHIJKLMNO',0
	even
	
String:
	dc.l Zeichenkette

	end

;------------------------------------------------------------------------------
r
Filename: Listing13g.s
>a
Pass1
Pass2
No Errors
>ad			; asmone Debugger
>j			; or easy


D0: 00000001 0000004F 0000000F 00000000 00000000 00000000 00000000 00000000
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00C5FDFC
SSP=00C60DF8 USP=00C5FDFC SR=0000 -- -- PL=0 ----- PC=EOP
>


Darüber hinaus eignen sich die DBcc-Anweisungen auch hervorragend zum
Vergleichen. Hier ein Beispiel:

	Move.w	Len(PC),d0		; Max Länge zu suchen <> 0
	Move.l	String(PC),a0	
	Moveq	#Char,d1		; Character zu suchen
FdLoop:
	Cmp.b	(a0)+,d1
	Dbne.s	d0,FdLoop

Der folgende Zyklus überprüft zwei Dinge gleichzeitig, nämlich die cc-EQs wird
gesetzt, wenn wir alle Len (Anzahl der Zeichen) untersucht haben, oder wenn der
Charakter gefunden wurde, könnten wir in diesem Fall auch sagen in welcher
Position er ist.


The DBcc instruction provides an automatic looping facility and replaces the
usual decrement counter, test, and branch instructions.

Three parameters are required by the DBcc instruction:
a branch condition (specified by ?cc?),
a data register that serves as the loop down-counter, and 
a label that indicates the start of the loop. 

The DBcc first tests the condition ?cc?, and if ?cc? is true the loop is
terminated and the branch back to <label> not taken.

The 14 branch conditions supported by Bcc are also supported by DBcc, as
well as DBF and DBT (F = false, and T = true).
Note that many assemblers permit the mnemonic DBF to be expressed
as DBRA (i.e., decrement and branch back).

It is important to appreciate that the condition tested by the DBcc instruction
works in the opposite sense to a Bcc, conditional branch, instruction. 
For example, BCC means branch on carry clear, whereas DBCC means continue
(i.e., exit the loop) on carry clear.
That is, the DBcc condition is a loop terminator. If the termination condition
is not true, the low-order 16 bits of the specified data register are
decremented. If the result is -1, the loop is not taken and the next
instruction is executed. If the result is not -1, a branch is made to ?label?.
Note that the label represents a 16-bit signed value, permitting a branch range
of -32K to +32K bytes. Since the value in Dn decremented is 16 bits, the loop
may be executed up to 64K times. We can use the instruction DBEQ, decrement and
branch on zero, to mechanize the high-level language construct REPEAT...UNTIL.