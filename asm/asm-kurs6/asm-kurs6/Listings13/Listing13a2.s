
; Listing13a2.s - Austauschanweisungen
; Zeile 295

start:
	;move.w #$4000,$dff09a	; Interrupts disable
waitmouse:  
	btst	#6,$bfe001		; left mousebutton?
	bne.s	Waitmouse		
;-----------------------	; Zeile 265
	move.l	#3,d0			; 12 Zyklen
	clr.l	d0				; 6 Zyklen
	add.l	#3,a0			; 16 Zyklen
;
	move.l	#5,Label1		; 28 Zyklen
;------------------------------------------------------------------------------
; Optimierte "Exchange" -Version:
	moveq	#3,d0			; 4 Zyklen
	moveq	#0,d0			; 4 Zyklen
	addq.w	#3,a0			; 8 Zyklen
;
	moveq	#5,d0			; 4 Zyklen
	move.l	d0,Label1		; 20 Zyklen, gesamt 24 Zyklen
;------------------------------------------------------------------------------

; Ich könnte mit solchen Beispielen noch lange weitermachen, aber Sie müssen
; natürlich nicht alle möglichen Fälle auswendig kennen! Vielmehr ist es
; notwendig, "die Methode", die Philosophie der optimierten Codierung, zu
; verstehen. Es gibt zum Beispiel Techniken, um das Laden von 32 Bit-Werten
; in die Register zu beschleunigen:
;------------------------------------------------------------------------------
	move.l	#$100000,d0		; 12 Zyklen
;------------------------------------------------------------------------------
; optimierte Version:
	moveq	#10,d0			; 4 Zyklen
	swap	d0				; 4 Zyklen, insgesamt 8 Zyklen	d0=000A0000
;------------------------------------------------------------------------------
; Eine andere SEHR WICHTIGE Sache ist, dass der Zugriff auf den Speicher (dh auf
; die Label) viel langsamer ist als der Zugriff auf Daten- und Adressregister.
; So ist es eine gute Angewohnheit alle Register zu verwenden und Label so wenig
; wie möglich zu berühren. Zum Beispiel dieses Listing:
;------------------------------------------------------------------------------
	MOVE.L	#200,LABEL1		; 28 Zyklen
	MOVE.L	#10,LABEL2		; 28 Zyklen
	;ADD.L	LABEL1,LABEL2	; undefinend symbol		; ???
;------------------------------------------------------------------------------
; Sie können VIEL durch Schreiben optimieren:
	move.l	#200,d0			; 12 Zyklen
	moveq	#10,d1			; 4 Zyklen
	add.l	d0,d1			; 4 Zyklen
;------------------------------------------------------------------------------
; Achten Sie nicht auf die Dummheit des Beispiels, sondern auf die Tatsache, dass 
; wir im ersten 4 Zugriffe auf den sehr langsamen RAM gemacht haben und die Daten
; über die wirren Drähte des Motherboards übergeben. Im zweiten Fall wird alles 
; in der CPU erledigt, was das ganze beschleunigt. Wenn Ihnen die Datenregister
; ausgehen, verwenden Sie auch die Adressregister, um Daten zu speichern, anstatt
; auf Label zuzugreifen! Verwenden Sie nach Möglichkeit auch .w anstelle von
;.l-Anweisungen, z.B. das Listing oben könnte neu optimiert werden:

	move.w	#200,d1			; 8 Zyklen
	moveq	#10,d0			; 4 Zyklen
	add.w	d0,d1			; 4 Zyklen

;------------------------------------------------------------------------------
; 
	add.b	#6,d0			; 8 Zyklen
	add.w	#6,d0			; 8 Zyklen
	add.l	#6,d0			; 16 Zyklen

	sub.b	#7,d0			; 8 Zyklen
	sub.w	#7,d0			; 8 Zyklen
	sub.l	#7,d0			; 16 Zyklen

	MOVE.w LABEL1,d0		; 16 Zyklen	(Inhalt von Label1, nicht Adresse #)
	LEA LABEL1,A0			; 12 Zyklen (Adresse von Label1)

	MOVE.L #30,d1			; 12 Zyklen
	CLR.L d4				; 6 Zyklen

	ADD.l #12000,a3			; 16 Zyklen
	SUB.l #12000,a3			; 16 Zyklen

	MOVE.w #0,d0			; 8 Zyklen
	CMP.w  #0,d0			; 8 Zyklen
	
	;CLR a0					; Zyklen		; Reg. Ax	zurücksetzen	; invalid adressing mode
	;moveq #0,a0			; Zyklen		; Reg. Ax	zurücksetzen	; data reg. expected
	move.l #0,a0			; 12 Zyklen

	JMP	XXX1				; 12 Zyklen
XXX1b:	
	JSR	XXX2				; 20 Zyklen
XXX2b:	
	MOVE.l #Label1,A0		; 12 Zyklen	(Adresse von Label1)
	MOVE.L 0(a0),d0			; 16 Zyklen
	LEA	(A0),A0				; 4 Zyklen	; nutzlos
	LEA	4(A0),A0			; 8 Zyklen
	addq.l #3,a0			; 8 Zyklen
	;Bcc.w label1			; Beq,Bne,Bsr... dist. >128
	bra opt					; 10 Zyklen

XXX1:
	JMP	XXX1b				; 12 Zyklen
XXX2:
	JMP	XXX2b				; 12 Zyklen

;------------------------------------------------------------------------------
; optimierte Anweisung	(ÄQUIVALENT, ABER SCHNELLER)
opt:	
	addq	#6,d0			; 4 Zyklen	(bix max. 8)
	subq	#7,d0			; 4 Zyklen	(bix max. 8)

	MOVE.w	LABEL1(PC),d0	; 12 Zyklen	(wenn in der gleichen SECTION)
	LEA LABEL1(PC),A0		; 12 Zyklen (wenn in der gleichen SECTION)
	MOVEQ #0,d4				; 4 Zyklen

	LEA 12000(a3),A3		; 8 Zyklen  (min -32768, max 32767)
	
	CLR.w d0				; 4	Zyklen	#0 zu bewegen ist dumm!
	TST.w d0				; 4 Zyklen  das TST, wo Sie es verlassen?
	
	SUB.L A0,A0				; 8 Zyklen	besser als "LEA 0,a0"	
	
	BRA	XXX3				; 10 Zyklen (wenn XXX in der Nähe ist)
XXX3b:	
	BSR XXX4				; 18 Zyklen 
XXX4b:
	LEA label1,A0			; 12 Zyklen (nur Adressregister!)
	MOVE.L (a0),d0			; 12 Zyklen (Offset entfernen, wenn es 0 ist!!!)

	ADDQ.W #4,A0			; 8 Zyklen bis zu 8
	addq.w #3,a0			; 8 Zyklen nur Adressregister , max 8
	;Bcc.s label1			; Beq,Bne,Bsr... dist. <128
	nop						; an dieser Stelle ist die Aufgabe erledigt	
	;move.w #$C000,$dff09a	; Interrupts enable
	rts

XXX3:
	BRA	XXX3b				; 10 Zyklen

XXX4:
	rts						; 16 Zyklen

	
Label1:
	dc.w $0
Label2:
	dc.w $0

	end

;------------------------------------------------------------------------------
; Zusammenfassung Register löschen
	move.l #$0,d5			; 12 Zyklen	
	clr.l d5				; 6 Zyklen
	moveq.l	#0,d5			; 4 Zyklen

	;clr.l a0				; invalid adressing mode
	;moveq.l #0,a0			; Data Reg. expected
	LEA 0,a0				; 12 Zyklen
	SUB.L A0,A0				; 8 Zyklen	besser als "LEA 0,a0"		
	

Da es ausreicht, zu wissen, wie man die richtige Anweisung wählt, reicht es
aus, zu jeder Anweisung das äquivalente Paar zu kennen, das am schnellsten
ist. Ich präsentiere eine Tabelle ähnlich der am Ende von 68000-2.txt, mit 
"langsamen" Anweisungen und den "schnellen" Äquivalenten dazu:

ANWEISUNG Beispiel		| ÄQUIVALENT, ABER SCHNELLER
------------------------|-----------------------------------------------
add.X #6,XXX			| addq.X #6,XXX		(maximal 8)
sub.X #7,XXX			| subq.X #7,XXX		(maximal 8)
MOVE.X LABEL,XX			| MOVE.X LABEL(PC),XX	(wenn in der gleichen SECTION)
LEA LABEL,AX			| LEA LABEL(PC),AX	(wenn in der gleichen SECTION)
MOVE.L #30,d1			| moveq #30,d1		(min #-128, max #+127)
CLR.L d4				| MOVEQ #0,d4		(nur für Datenregister)
ADD.X/SUB.X #12000,a3	| LEA (+/-)12000(a3),A3	(min -32768, max 32767)
MOVE.X #0,XXX			| CLR.X XXX			; #0 zu bewegen ist dumm!
CMP.X  #0,XXX			| TST.X XXX			; das TST, wo Sie es verlassen?
Reg. Ax	zurücksetzen	| SUB.L A0,A0		; besser als "LEA 0,a0"		
JMP/JSR	XXX				| BRA/BSR XXX		(wenn XXX in der Nähe ist)
MOVE.X #label,AX		| LEA label,AX		(nur Adressregister!)
MOVE.L 0(a0),d0			| MOVE.L (a0),d0	(Offset entfernen, wenn es 0 ist!!!)
LEA	(A0),A0				| HAHAHAHA!         ; es hat keine Wirkung!!
LEA	4(A0),A0			| ADDQ.W #4,A0		; bis zu 8
addq.l #3,a0			| addq.w #3,a0		; nur Adressregister , max 8
Bcc.W label				| Bcc.S label       ; Beq,Bne,Bsr... dist. <128


;------------------------------------------------------------------------------
r
Filename: Listing13a2.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
00028dcc 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00028dd4 66f6                     bne.b #$f6 == $00028dcc (T)
00028dd6 203c 0000 0003           move.l #$00000003,d0
00028ddc 4280                     clr.l d0
00028dde d1fc 0000 0003           adda.l #$00000003,a0
00028de4 23fc 0000 0005 0002 8eda move.l #$00000005,$00028eda [00000000]
00028dee 7003                     moveq #$03,d0
00028df0 7000                     moveq #$00,d0
00028df2 5648                     addaq.w #$03,a0
00028df4 7005                     moveq #$05,d0
>d
00028df6 23c0 0002 8eda           move.l d0,$00028eda [00000000]
00028dfc 203c 0010 0000           move.l #$00100000,d0
00028e02 700a                     moveq #$0a,d0
00028e04 4840                     swap.w d0
00028e06 23fc 0000 00c8 0002 8eda move.l #$000000c8,$00028eda [00000000]
00028e10 23fc 0000 000a 0002 8edc move.l #$0000000a,$00028edc [0000000a]
00028e1a 203c 0000 00c8           move.l #$000000c8,d0
00028e20 720a                     moveq #$0a,d1
00028e22 d280                     add.l d0,d1
00028e24 323c 00c8                move.w #$00c8,d1
>d
00028e28 700a                     moveq #$0a,d0
00028e2a d240                     add.w d0,d1
00028e2c 0600 0006                add.b #$06,d0
00028e30 0640 0006                add.w #$0006,d0
00028e34 0680 0000 0006           add.l #$00000006,d0
00028e3a 0400 0007                sub.b #$07,d0
00028e3e 0440 0007                sub.w #$0007,d0
00028e42 0480 0000 0007           sub.l #$00000007,d0
00028e48 3039 0002 8eda           move.w $00028eda [0000],d0
00028e4e 41f9 0002 8eda           lea.l $00028eda,a0
>d
00028e54 223c 0000 001e           move.l #$0000001e,d1
00028e5a 4284                     clr.l d4
00028e5c d7fc 0000 2ee0           adda.l #$00002ee0,a3
00028e62 97fc 0000 2ee0           suba.l #$00002ee0,a3
00028e68 303c 0000                move.w #$0000,d0
00028e6c 0c40 0000                cmp.w #$0000,d0
00028e70 207c 0000 0000           movea.l #$00000000,a0
00028e76 4ef9 0002 8e98           jmp $00028e98
00028e7c 4eb9 0002 8e9e           jsr $00028e9e
00028e82 207c 0002 8eda           movea.l #$00028eda,a0
>d
00028e88 2028 0000                move.l (a0,$0000) == $00028ee1 [34567801],d0
00028e8c 41d0                     lea.l (a0),a0
00028e8e 41e8 0004                lea.l (a0,$0004) == $00028ee5,a0
00028e92 5688                     addaq.l #$03,a0
00028e94 6000 000e                bra.w #$000e == $00028ea4 (T)
00028e98 4ef9 0002 8e7c           jmp $00028e7c
00028e9e 4ef9 0002 8e82           jmp $00028e82
00028ea4 5c40                     addq.w #$06,d0
00028ea6 5f40                     subq.w #$07,d0
00028ea8 303a 0030                move.w (pc,$0030) == $00028eda [0000],d0
>d
00028eac 41fa 002c                lea.l (pc,$002c) == $00028eda,a0
00028eb0 7800                     moveq #$00,d4
00028eb2 47eb 2ee0                lea.l (a3,$2ee0) == $00008ca0,a3
00028eb6 4240                     clr.w d0
00028eb8 4a40                     tst.w d0
00028eba 91c8                     suba.l a0,a0
00028ebc 6000 0016                bra.w #$0016 == $00028ed4 (T)
00028ec0 6100 0016                bsr.w #$0016 == $00028ed8
00028ec4 41f9 0002 8eda           lea.l $00028eda,a0
00028eca 2010                     move.l (a0) [34567801],d0
>d
00028ecc 5848                     addaq.w #$04,a0
00028ece 5648                     addaq.w #$03,a0
00028ed0 4e71                     nop
00028ed2 4e75                     rts  == $00c4f7b8
00028ed4 6000 ffea                bra.w #$ffea == $00028ec0 (T)
00028ed8 4e75                     rts  == $00c4f7b8
00028eda 0000 0000                or.b #$00,d0
00028ede 000a                     illegal
00028ee0 1234 5678                move.b (a4,d5.W[*8],$78) == $00000078 (68020+) [00],d1
00028ee4 0101                     btst.l d0,d1
>
;------------------------------------------------------------------------------
>d pc
00028dcc 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00028dd4 66f6                     bne.b #$f6 == $00028dcc (T)
00028dd6 203c 0000 0003           move.l #$00000003,d0
00028ddc 4280                     clr.l d0
00028dde d1fc 0000 0003           adda.l #$00000003,a0
00028de4 23fc 0000 0005 0002 8eda move.l #$00000005,$00028eda [00000000]
00028dee 7003                     moveq #$03,d0
00028df0 7000                     moveq #$00,d0
00028df2 5648                     addaq.w #$03,a0
00028df4 7005                     moveq #$05,d0
>fd
All breakpoints removed.
>f 28dd6
Breakpoint added.
>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 4040751 Chip, 8081502 CPU. (V=210 H=3 -> V=210 H=27)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 203c (MOVE) 0000 (OR) Chip latch 00000000
00028dd6 203c 0000 0003           move.l #$00000003,d0
Next PC: 00028ddc
>t
Cycles: 6 Chip, 12 CPU. (V=210 H=27 -> V=210 H=33)
  D0 00000003   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4280 (CLR) d1fc (ADDA) Chip latch 00000000
00028ddc 4280                     clr.l d0
Next PC: 00028dde
>t
Cycles: 3 Chip, 6 CPU. (V=210 H=33 -> V=210 H=36)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch d1fc (ADDA) 0000 (OR) Chip latch 00000000
00028dde d1fc 0000 0003           adda.l #$00000003,a0
Next PC: 00028de4
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=36 -> V=210 H=44)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE4   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 23fc (MOVE) 0000 (OR) Chip latch 00000000
00028de4 23fc 0000 0005 0002 8eda move.l #$00000005,$00028eda [00000000]
Next PC: 00028dee
>t
Cycles: 14 Chip, 28 CPU. (V=210 H=44 -> V=210 H=58)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE4   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 7003 (MOVE) 7000 (MOVE) Chip latch 00000000
00028dee 7003                     moveq #$03,d0
Next PC: 00028df0
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=58 -> V=210 H=60)
  D0 00000003   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE4   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 7000 (MOVE) 5648 (ADDA) Chip latch 00000000
00028df0 7000                     moveq #$00,d0
Next PC: 00028df2
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=60 -> V=210 H=62)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE4   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 5648 (ADDA) 7005 (MOVE) Chip latch 00000000
00028df2 5648                     addaq.w #$03,a0
Next PC: 00028df4
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=62 -> V=210 H=66)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 7005 (MOVE) 23c0 (MOVE) Chip latch 00000000
00028df4 7005                     moveq #$05,d0
Next PC: 00028df6
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=66 -> V=210 H=68)
  D0 00000005   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 23c0 (MOVE) 0002 (OR) Chip latch 00000000
00028df6 23c0 0002 8eda           move.l d0,$00028eda [00000005]
Next PC: 00028dfc
>t
Cycles: 10 Chip, 20 CPU. (V=210 H=68 -> V=210 H=78)
  D0 00000005   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 203c (MOVE) 0010 (OR) Chip latch 00000000
00028dfc 203c 0010 0000           move.l #$00100000,d0
Next PC: 00028e02
>t
Cycles: 6 Chip, 12 CPU. (V=210 H=78 -> V=210 H=84)
  D0 00100000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 700a (MOVE) 4840 (SWAP) Chip latch 00000000
00028e02 700a                     moveq #$0a,d0
Next PC: 00028e04
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=84 -> V=210 H=86)
  D0 0000000A   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4840 (SWAP) 23fc (MOVE) Chip latch 00000000
00028e04 4840                     swap.w d0
Next PC: 00028e06
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=86 -> V=210 H=88)
  D0 000A0000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 23fc (MOVE) 0000 (OR) Chip latch 00000000
00028e06 23fc 0000 00c8 0002 8eda move.l #$000000c8,$00028eda [00000005]
Next PC: 00028e10
>t
Cycles: 14 Chip, 28 CPU. (V=210 H=88 -> V=210 H=102)
  D0 000A0000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 23fc (MOVE) 0000 (OR) Chip latch 00000000
00028e10 23fc 0000 000a 0002 8edc move.l #$0000000a,$00028edc [00c8000a]
Next PC: 00028e1a
>t
Cycles: 14 Chip, 28 CPU. (V=210 H=102 -> V=210 H=116)
  D0 000A0000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 203c (MOVE) 0000 (OR) Chip latch 00000000
00028e1a 203c 0000 00c8           move.l #$000000c8,d0
Next PC: 00028e20
>t
Cycles: 6 Chip, 12 CPU. (V=210 H=116 -> V=210 H=122)
  D0 000000C8   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 720a (MOVE) d280 (ADD) Chip latch 00000000
00028e20 720a                     moveq #$0a,d1
Next PC: 00028e22
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=122 -> V=210 H=124)
  D0 000000C8   D1 0000000A   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d280 (ADD) 323c (MOVE) Chip latch 00000000
00028e22 d280                     add.l d0,d1
Next PC: 00028e24
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=124 -> V=210 H=128)
  D0 000000C8   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 323c (MOVE) 00c8 (ILLEGAL) Chip latch 00000000
00028e24 323c 00c8                move.w #$00c8,d1
Next PC: 00028e28
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=128 -> V=210 H=132)
  D0 000000C8   D1 000000C8   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 700a (MOVE) d240 (ADD) Chip latch 00000000
00028e28 700a                     moveq #$0a,d0
Next PC: 00028e2a
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=132 -> V=210 H=134)
  D0 0000000A   D1 000000C8   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d240 (ADD) 0600 (ADD) Chip latch 00000000
00028e2a d240                     add.w d0,d1
Next PC: 00028e2c
>t
Cycles: 2 Chip, 4 CPU. (V=210 H=134 -> V=210 H=136)
  D0 0000000A   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0600 (ADD) 0006 (OR) Chip latch 00000000
00028e2c 0600 0006                add.b #$06,d0
Next PC: 00028e30
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=136 -> V=210 H=140)
  D0 00000010   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0640 (ADD) 0006 (OR) Chip latch 00000000
00028e30 0640 0006                add.w #$0006,d0
Next PC: 00028e34
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=140 -> V=210 H=144)
  D0 00000016   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0680 (ADD) 0000 (OR) Chip latch 00000000
00028e34 0680 0000 0006           add.l #$00000006,d0
Next PC: 00028e3a
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=144 -> V=210 H=152)
  D0 0000001C   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0400 (SUB) 0007 (OR) Chip latch 00000000
00028e3a 0400 0007                sub.b #$07,d0
Next PC: 00028e3e
>
;------------------------------------------------------------------------------
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=152 -> V=210 H=156)
  D0 00000015   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0440 (SUB) 0007 (OR) Chip latch 00000000
00028e3e 0440 0007                sub.w #$0007,d0
Next PC: 00028e42
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=156 -> V=210 H=160)
  D0 0000000E   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0480 (SUB) 0000 (OR) Chip latch 00000000
00028e42 0480 0000 0007           sub.l #$00000007,d0
Next PC: 00028e48
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=160 -> V=210 H=168)
  D0 00000007   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 3039 (MOVE) 0002 (OR) Chip latch 00000000
00028e48 3039 0002 8eda           move.w $00028eda [0000],d0
Next PC: 00028e4e
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=168 -> V=210 H=176)
  D0 00000000   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE7   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000000
00028e4e 41f9 0002 8eda           lea.l $00028eda,a0
Next PC: 00028e54
>t
Cycles: 6 Chip, 12 CPU. (V=210 H=176 -> V=210 H=182)
  D0 00000000   D1 000000D2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 223c (MOVE) 0000 (OR) Chip latch 00000000
00028e54 223c 0000 001e           move.l #$0000001e,d1
Next PC: 00028e5a
>t
Cycles: 6 Chip, 12 CPU. (V=210 H=182 -> V=210 H=188)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4284 (CLR) d7fc (ADDA) Chip latch 00000000
00028e5a 4284                     clr.l d4
Next PC: 00028e5c
>t
Cycles: 3 Chip, 6 CPU. (V=210 H=188 -> V=210 H=191)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch d7fc (ADDA) 0000 (OR) Chip latch 00000000
00028e5c d7fc 0000 2ee0           adda.l #$00002ee0,a3
Next PC: 00028e62
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=191 -> V=210 H=199)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 97fc (SUBA) 0000 (OR) Chip latch 00000000
00028e62 97fc 0000 2ee0           suba.l #$00002ee0,a3
Next PC: 00028e68
>t
Cycles: 8 Chip, 16 CPU. (V=210 H=199 -> V=210 H=207)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 303c (MOVE) 0000 (OR) Chip latch 00000000
00028e68 303c 0000                move.w #$0000,d0
Next PC: 00028e6c
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=207 -> V=210 H=211)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0c40 (CMP) 0000 (OR) Chip latch 00000000
00028e6c 0c40 0000                cmp.w #$0000,d0
Next PC: 00028e70
>t
Cycles: 4 Chip, 8 CPU. (V=210 H=211 -> V=210 H=215)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 207c (MOVEA) 0000 (OR) Chip latch 00000000
00028e70 207c 0000 0000           movea.l #$00000000,a0
Next PC: 00028e76
>t
Cycles: 6 Chip, 12 CPU. (V=210 H=215 -> V=210 H=221)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4ef9 (JMP) 0002 (OR) Chip latch 00000000
00028e76 4ef9 0002 8e98           jmp $00028e98
Next PC: 00028e7c
>t
Cycles: 6 Chip, 12 CPU. (V=210 H=221 -> V=211 H=0)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4ef9 (JMP) 0002 (OR) Chip latch 00000000
00028e98 4ef9 0002 8e7c           jmp $00028e7c
Next PC: 00028e9e
>t
Cycles: 6 Chip, 12 CPU. (V=211 H=0 -> V=211 H=6)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4eb9 (JSR) 0002 (OR) Chip latch 00000000
00028e7c 4eb9 0002 8e9e           jsr $00028e9e
Next PC: 00028e82
>t
Cycles: 10 Chip, 20 CPU. (V=211 H=6 -> V=211 H=16)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4ef9 (JMP) 0002 (OR) Chip latch 00000000
00028e9e 4ef9 0002 8e82           jmp $00028e82
Next PC: 00028ea4
>t
Cycles: 6 Chip, 12 CPU. (V=211 H=16 -> V=211 H=22)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 207c (MOVEA) 0002 (OR) Chip latch 00000000
00028e82 207c 0002 8eda           movea.l #$00028eda,a0
Next PC: 00028e88
>t
Cycles: 6 Chip, 12 CPU. (V=211 H=22 -> V=211 H=28)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 2028 (MOVE) 0000 (OR) Chip latch 00000000
00028e88 2028 0000                move.l (a0,$0000) == $00028eda [00000000],d0
Next PC: 00028e8c
>t
Cycles: 8 Chip, 16 CPU. (V=211 H=28 -> V=211 H=36)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41d0 (LEA) 41e8 (LEA) Chip latch 00000000
00028e8c 41d0                     lea.l (a0),a0
Next PC: 00028e8e
>t
Cycles: 2 Chip, 4 CPU. (V=211 H=36 -> V=211 H=38)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41e8 (LEA) 0004 (OR) Chip latch 00000000
00028e8e 41e8 0004                lea.l (a0,$0004) == $00028ede,a0
Next PC: 00028e92
>t
Cycles: 4 Chip, 8 CPU. (V=211 H=38 -> V=211 H=42)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDE   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 5688 (ADDA) 6000 (Bcc) Chip latch 00000000
00028e92 5688                     addaq.l #$03,a0
Next PC: 00028e94
>t
Cycles: 4 Chip, 8 CPU. (V=211 H=42 -> V=211 H=46)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6000 (Bcc) 000e (ILLEGAL) Chip latch 00000000
00028e94 6000 000e                bra.w #$000e == $00028ea4 (T)
Next PC: 00028e98
>t
Cycles: 5 Chip, 10 CPU. (V=211 H=46 -> V=211 H=51)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 5c40 (ADD) 5f40 (SUB) Chip latch 00000000
00028ea4 5c40                     addq.w #$06,d0
Next PC: 00028ea6
>t
Cycles: 2 Chip, 4 CPU. (V=211 H=51 -> V=211 H=53)
  D0 00000006   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 5f40 (SUB) 303a (MOVE) Chip latch 00000000
00028ea6 5f40                     subq.w #$07,d0
Next PC: 00028ea8
>t
Cycles: 2 Chip, 4 CPU. (V=211 H=53 -> V=211 H=55)
  D0 0000FFFF   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 303a (MOVE) 0030 (OR) Chip latch 00000000
00028ea8 303a 0030                move.w (pc,$0030) == $00028eda [0000],d0
Next PC: 00028eac
>t
Cycles: 6 Chip, 12 CPU. (V=211 H=55 -> V=211 H=61)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41fa (LEA) 002c (OR) Chip latch 00000000
00028eac 41fa 002c                lea.l (pc,$002c) == $00028eda,a0
Next PC: 00028eb0
>t
Cycles: 4 Chip, 8 CPU. (V=211 H=61 -> V=211 H=65)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 7800 (MOVE) 47eb (LEA) Chip latch 00000000
00028eb0 7800                     moveq #$00,d4
Next PC: 00028eb2
>t
Cycles: 2 Chip, 4 CPU. (V=211 H=65 -> V=211 H=67)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00005DC0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 47eb (LEA) 2ee0 (MOVE) Chip latch 00000000
00028eb2 47eb 2ee0                lea.l (a3,$2ee0) == $00008ca0,a3
Next PC: 00028eb6
>t
Cycles: 4 Chip, 8 CPU. (V=211 H=67 -> V=211 H=71)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4240 (CLR) 4a40 (TST) Chip latch 00000000
00028eb6 4240                     clr.w d0
Next PC: 00028eb8
>t
Cycles: 2 Chip, 4 CPU. (V=211 H=71 -> V=211 H=73)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4a40 (TST) 91c8 (SUBA) Chip latch 00000000
00028eb8 4a40                     tst.w d0
Next PC: 00028eba
>t
Cycles: 2 Chip, 4 CPU. (V=211 H=73 -> V=211 H=75)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 91c8 (SUBA) 6000 (Bcc) Chip latch 00000000
00028eba 91c8                     suba.l a0,a0
Next PC: 00028ebc
>t
Cycles: 4 Chip, 8 CPU. (V=211 H=75 -> V=211 H=79)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6000 (Bcc) 0016 (OR) Chip latch 00000000
00028ebc 6000 0016                bra.w #$0016 == $00028ed4 (T)
Next PC: 00028ec0
>t
Cycles: 5 Chip, 10 CPU. (V=211 H=79 -> V=211 H=84)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6000 (Bcc) ffea (ILLEGAL) Chip latch 00000000
00028ed4 6000 ffea                bra.w #$ffea == $00028ec0 (T)
Next PC: 00028ed8
>t
Cycles: 5 Chip, 10 CPU. (V=211 H=84 -> V=211 H=89)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 6100 (BSR) 0016 (OR) Chip latch 00000000
00028ec0 6100 0016                bsr.w #$0016 == $00028ed8
Next PC: 00028ec4
>t
Cycles: 9 Chip, 18 CPU. (V=211 H=89 -> V=211 H=98)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED0
USP  00C5FED0 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 0000 (OR) Chip latch 00000000
00028ed8 4e75                     rts  == $00028ec4
Next PC: 00028eda
>t
Cycles: 8 Chip, 16 CPU. (V=211 H=98 -> V=211 H=106)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000000
00028ec4 41f9 0002 8eda           lea.l $00028eda,a0
Next PC: 00028eca
>t
Cycles: 6 Chip, 12 CPU. (V=211 H=106 -> V=211 H=112)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 2010 (MOVE) 5848 (ADDA) Chip latch 00000000
00028eca 2010                     move.l (a0) [00000000],d0
Next PC: 00028ecc
>t
Cycles: 6 Chip, 12 CPU. (V=211 H=112 -> V=211 H=118)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDA   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 5848 (ADDA) 5648 (ADDA) Chip latch 00000000
00028ecc 5848                     addaq.w #$04,a0
Next PC: 00028ece
>t
Cycles: 4 Chip, 8 CPU. (V=211 H=118 -> V=211 H=122)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EDE   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 5648 (ADDA) 4e71 (NOP) Chip latch 00000000
00028ece 5648                     addaq.w #$03,a0
Next PC: 00028ed0
>t
Cycles: 4 Chip, 8 CPU. (V=211 H=122 -> V=211 H=126)
  D0 00000000   D1 0000001E   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00028EE1   A1 00000000   A2 00000000   A3 00008CA0
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED4
USP  00C5FED4 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 4e75 (RTS) Chip latch 00000000
00028ed0 4e71                     nop
Next PC: 00028ed2
>t
