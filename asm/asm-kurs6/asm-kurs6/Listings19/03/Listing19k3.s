
; Listing19k3.s
; DMA Debugger
; cycle-exact mode must be activated
; DMA and CPU-Usage
;
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger	
;------------------------------------------------------------------------------
	
	ORG $1FFEC				; to align the adresses
	LOAD $1FFEC
	JUMPPTR start

start:

waitmouse:  
	btst	#6,$bfe001		; left mousebutton?
	bne.s	Waitmouse	

WaitWblank:
	cmp.b	#200,$dff006	; vhposr - wait line
	bne.s	WaitWblank

l20000:						; on adress $20000	
	lea	dog,a0
	move.L	#dog,a1
	move.L	dog,a2
	move.l	#$AA,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	move.l	#$BB,cat1
	move.l	a1,cat2
	move.l	a2,cat3

	btst	#2,$dff016		; right mousebutton?
	bne.s	WaitWblank		 
	
	move.w #$C000,$dff09a	; Interrupts enable
	rts

dog:
	dc.l	$12345678		; dog = $20052
cat1:
	dc.l	0				; cat1 = $20056
cat2:
	dc.l	0				; cat2 = $2005a
cat3:
	dc.l	0				; cat3 = $2005e

	end
		
;------------------------------------------------------------------------------
>r
Filename:Listing19i3.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
0001FFF4 66f6                     BNE.B #$f6 == $0001ffec (T)
0001FFF6 0c39 00c8 00df f006      CMP.B #$c8,$00dff006
0001FFFE 66f6                     BNE.B #$f6 == $0001fff6 (T)
00020000 41f9 0002 0052           LEA.L $00020052,A0
00020006 227c 0002 0052           MOVEA.L #$00020052,A1
0002000C 2479 0002 0052           MOVEA.L $00020052 [12345678],A2
00020012 23fc 0000 00aa 0002 0056 MOVE.L #$000000aa,$00020056 [00000000]
0002001C 23c9 0002 005a           MOVE.L A1,$0002005a [00000000]
00020022 23ca 0002 005e           MOVE.L A2,$0002005e [00000000]
00020028 23fc 0000 00bb 0002 0056 MOVE.L #$000000bb,$00020056 [00000000]
>f 20000
Breakpoint added.
>x

>x																				; step 2 - leave the debugger
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button
																				; now click left mousebutton and the debugger reopens
>d pc
00020000 41f9 0002 0052           LEA.L $00020052,A0
00020006 227c 0002 0052           MOVEA.L #$00020052,A1
0002000C 2479 0002 0052           MOVEA.L $00020052 [12345678],A2
00020012 23fc 0000 00aa 0002 0056 MOVE.L #$000000aa,$00020056 [00000000]
0002001C 23c9 0002 005a           MOVE.L A1,$0002005a [00000000]
00020022 23ca 0002 005e           MOVE.L A2,$0002005e [00000000]
00020028 23fc 0000 00bb 0002 0056 MOVE.L #$000000bb,$00020056 [00000000]
00020032 23c9 0002 005a           MOVE.L A1,$0002005a [00000000]
00020038 23ca 0002 005e           MOVE.L A2,$0002005e [00000000]
0002003E 0839 0002 00df f016      BTST.B #$0002,$00dff016
;------------------------------------------------------------------------------
>t
Cycles: 6 Chip, 12 CPU. (V=200 H=8 -> V=200 H=14)										; we are on line 200
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00020052   A1 00020052   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 227c (MOVEA) Chip latch 00000002
00020006 227c 0002 0052           MOVEA.L #$00020052,A1
Next PC: 0002000c
;------------------------------------------------------------------------------
>t																						; step through the program	
Cycles: 6 Chip, 12 CPU. (V=200 H=14 -> V=200 H=20)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00020052   A1 00020052   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 2479 (MOVEA) Chip latch 00000002
0002000C 2479 0002 0052           MOVEA.L $00020052 [12345678],A2
Next PC: 00020012
;------------------------------------------------------------------------------
																						; now we look in line 200 where we are
																						; but we see not the actual values from the programm
																						; thats are historical data from the last frame
>v !200																					; debug the line 200
Line: C8 200 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
           RFS  1FE            RFS  1FE    CPU-RW  RFS  1FE              CPU-RW
               FFFF                FFFF      0C39      FFFF                0839			; data-or opcode
                                         0001FFF6                      0001FFEC			; adresses
 B6957A00  B6957C00  B6957E00  B6958000  B6958200  B6958400  B6958600  B6958800

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               0006                00BF                E001                66F6			; data-or opcode
           0001FFEE            0001FFF0            0001FFF2            0001FFF4			; adresses
 B6958A00  B6958C00  B6958E00  B6959000  B6959200  B6959400  B6959600  B6959800

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
                                                   SPR  144            SPR  146
                                                       7C00                8600
                                                   00000C94            00000C96
 B6959A00  B6959C00  B6959E00  B695A000  B695A200  B695A400  B695A600  B695A800

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
   CPU-RW                        CPU-RW              CPU-RW              CPU-RW
     0C39                          0839                0006                00BF
 0001FFF6                      0001FFEC            0001FFEE            0001FFF0
 B695AA00  B695AC00  B695AE00  B695B000  B695B200  B695B400  B695B600  B695B800

;------------------------------------------------------------------------------
>g																						; run the program
Breakpoint 0 triggered.
Cycles: 108 Chip, 216 CPU. (V=200 H=20 -> V=200 H=128)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00020052   A1 00020052   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000002
00020000 41f9 0002 0052           LEA.L $00020052,A0
Next PC: 00020006
;------------------------------------------------------------------------------
>v !200																					; same result
Line: C8 200 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
           RFS  1FE            RFS  1FE    CPU-RW  RFS  1FE              CPU-RW
               FFFF                FFFF      0C39      FFFF                0839
                                         0001FFF6                      0001FFEC
 B6957A00  B6957C00  B6957E00  B6958000  B6958200  B6958400  B6958600  B6958800

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               0006                00BF                E001                66F6
           0001FFEE            0001FFF0            0001FFF2            0001FFF4
 B6958A00  B6958C00  B6958E00  B6959000  B6959200  B6959400  B6959600  B6959800

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
                                                   SPR  144            SPR  146
                                                       7C00                8600
                                                   00000C94            00000C96
 B6959A00  B6959C00  B6959E00  B695A000  B695A200  B695A400  B695A600  B695A800

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
   CPU-RW                        CPU-RW              CPU-RW              CPU-RW
     0C39                          0839                0006                00BF
 0001FFF6                      0001FFEC            0001FFEE            0001FFF0
 B695AA00  B695AC00  B695AE00  B695B000  B695B200  B695B400  B695B600  B695B800
 
 ;-----------------------------------------------------------------------------
 >g																						; better more >g (alternative: >fs 314 
Breakpoint 0 triggered.
Cycles: 120 Chip, 240 CPU. (V=200 H=8 -> V=200 H=128)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00020052   A1 00020052   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000002
00020000 41f9 0002 0052           LEA.L $00020052,A0
Next PC: 00020006
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 70931 Chip, 141862 CPU. (V=200 H=128 -> V=200 H=8)								; 141862 CPU has to be a big value!		
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00020052   A1 00020052   A2 12345678   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000002
00020000 41f9 0002 0052           LEA.L $00020052,A0
Next PC: 00020006
;------------------------------------------------------------------------------
																						; now we can see the cpu usage
>v !200																					; thats are values from the previous frame
Line: C8 200 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
   CPU-RB  RFS  1FE    CPU-RW  RFS  1FE            RFS  1FE    CPU-RW
     00C8      FFFF      41F9      FFFF                FFFF      0002					; data-or opcode
 00DFF006            00020000                                00020002					; adresses
 C16CE800  C16CEA00  C16CEC00  C16CEE00  C16CF000  C16CF200  C16CF400  C16CF600

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
   CPU-RW              CPU-RW              CPU-RW              CPU-RW
     0052                227C                0002                0052
 00020004            00020006            00020008            0002000A
 C16CF800  C16CFA00  C16CFC00  C16CFE00  C16D0000  C16D0200  C16D0400  C16D0600

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
   CPU-RW              CPU-RW              CPU-RW  SPR  144    CPU-RW  SPR  146
     2479                0002                0052      7C00      23FC      8600
 0002000C            0002000E            00020010  00000C94  00020012  00000C96
 C16D0800  C16D0A00  C16D0C00  C16D0E00  C16D1000  C16D1200  C16D1400  C16D1600

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
   CPU-RW              CPU-RW              CPU-RW              CPU-RW
     1234                5678                0000                00AA
 00020052            00020054            00020014            00020016					; dog = $20052
 C16D1800  C16D1A00  C16D1C00  C16D1E00  C16D2000  C16D2200  C16D2400  C16D2600

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
   CPU-RW              CPU-RW              CPU-RW              CPU-WW
     0002                0056                23C9                0000
 00020018            0002001A            0002001C            00020056					; cat1 = $20056
 C16D2800  C16D2A00  C16D2C00  C16D2E00  C16D3000  C16D3200  C16D3400  C16D3600

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
   CPU-WW              CPU-RW              CPU-RW              CPU-RW
     00AA                0002                005A                23CA
 00020058            0002001E            00020020            00020022
 C16D3800  C16D3A00  C16D3C00  C16D3E00  C16D4000  C16D4200  C16D4400  C16D4600

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
   CPU-WW              CPU-WW              CPU-RW              CPU-RW
     0002                0052                0002                005E
 0002005A            0002005C            00020024            00020026					; cat2 = $2005a
 C16D4800  C16D4A00  C16D4C00  C16D4E00  C16D5000  C16D5200  C16D5400  C16D5600

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
   CPU-RW              CPU-WW              CPU-WW       112    CPU-RW       110
     23FC                1234                5678      0000      0000      1800
 00020028            0002005E            00020060  0001D340  0002002A  00018340			; cat3 = $2005e
 C16D5800  C16D5A00  C16D5C00  C16D5E00  C16D6000  C16D6200  C16D6400  C16D6600

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
   CPU-RW       112    CPU-RW       110    CPU-RW       112    CPU-RW       110
     00BB      0000      0002      0000      0056      0000      23C9      0000
 0002002C  0001D342  0002002E  00018342  00020030  0001D344  00020032  00018344
 C16D6800  C16D6A00  C16D6C00  C16D6E00  C16D7000  C16D7200  C16D7400  C16D7600

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-WW       112    CPU-WW       110    CPU-RW       112    CPU-RW       110
     0000      0000      00BB      0000      0002      0000      005A      0000			; data-or opcode
 00020056  0001D346  00020058  00018346  00020034  0001D348  00020036  00018348			; adresses
 C16D7800  C16D7A00  C16D7C00  C16D7E00  C16D8000  C16D8200  C16D8400  C16D8600


Note:
It is not possible to go through the code step by step and see the actual or
next instruction in the DMA-Bebugger. The DMA don't show the latest
cpu-instructions !!! The content of of the visible results are from the last
frame. Therfore you have to run the program one frame forward with multiply
g-commands or with fs 314 (one frame).
