
; Listing19m1.s (program to start is ; Listing19k4.s	(copper cycle sequence)
; PC-History
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

; H[H] <cnt>            Show PC history (HH=full CPU info) <cnt> instructions.
1. H
2. H 20				; see last 20 lines (H <number of lines>)
3. HH 20			; HH also includes registers


;------------------------------------------------------------------------------
; 1. Test - cycle exact is disabled, without dma-debugger
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
>r
Filename:Listing19k4.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm				   
																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------

  D0 00006800   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c80 (CMP) 0000 (OR) Chip latch 00000000
0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
Next PC: 0002a5aa
>H 5																			; no usefull output
-1 00fc0f94 60e6                     bra.b #$e6 == $00fc0f7c (T)
-1 00fc0f94 60e6                     bra.b #$e6 == $00fc0f7c (T)
-1 00fc0f94 60e6                     bra.b #$e6 == $00fc0f7c (T)
-1 00fc0f94 60e6                     bra.b #$e6 == $00fc0f7c (T)
 0 0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
>
;------------------------------------------------------------------------------
>d pc
0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
0002a5aa 66ec                     bne.b #$ec == $0002a598 (T)
0002a5ac 0839 0006 00df f002      btst.b #$0006,$00dff002
0002a5b4 0839 0006 00df f002      btst.b #$0006,$00dff002
0002a5bc 66f6                     bne.b #$f6 == $0002a5b4 (T)
0002a5be 33fc 0100 00df f040      move.w #$0100,$00dff040
0002a5c6 33fc 0000 00df f042      move.w #$0000,$00dff042
0002a5ce 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
0002a5d8 33fc 0000 00df f066      move.w #$0000,$00dff066
0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
;------------------------------------------------------------------------------
>f 2a5e0
Breakpoint added.
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 65479 Chip, 130958 CPU. (V=105 H=1 -> V=80 H=104)
  D0 00005000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000140
0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 0002a5e8
;------------------------------------------------------------------------------
																				; from EAB:
																				; but last 500 instructions are automatically stored when any normal break
																				; point is active. H <number of instructions> command lists them.
>H 10
 0 0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
 0 0002a5aa 66ec                     bne.b #$ec == $0002a598 (F)
 0 0002a5ac 0839 0006 00df f002      btst.b #$0006,$00dff002
 0 0002a5b4 0839 0006 00df f002      btst.b #$0006,$00dff002
 0 0002a5bc 66f6                     bne.b #$f6 == $0002a5b4 (F)
 0 0002a5be 33fc 0100 00df f040      move.w #$0100,$00dff040
 0 0002a5c6 33fc 0000 00df f042      move.w #$0000,$00dff042
 0 0002a5ce 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
 0 0002a5d8 33fc 0000 00df f066      move.w #$0000,$00dff066
 0 0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
;------------------------------------------------------------------------------
>HH 10
  D0 00005000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0c80 (CMP) 0000 (OR) Chip latch 00000000
0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
  D0 00005000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 66ec (Bcc) 0839 (BTST) Chip latch 00000000
0002a5aa 66ec                     bne.b #$ec == $0002a598 (F)
...
>fd
All breakpoints removed.
>x
;------------------------------------------------------------------------------
>H 500																			; H 500 shows the last 500 lines of executed programcode...
																				; look at RTS, RTE - subroutines 

;------------------------------------------------------------------------------
; 2. Test - cycle exact full is enabled
;			dma-debugger enabled			
;------------------------------------------------------------------------------

>r
Filename:Listing19k4.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm				   
																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
  D0 00013800   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66ec (Bcc) 0839 (BTST) Chip latch 00000839
0002a5aa 66ec                     bne.b #$ec == $0002a598 (T)
Next PC: 0002a5ac
;------------------------------------------------------------------------------
>v-4																			; dma debugger enabled
DMA debugger enabled, mode=4.
;------------------------------------------------------------------------------
>H																				; without new breakpoint
 0 0002a5aa 66ec                     bne.b #$ec == $0002a598 (T)
 0 0002a5ac 0839 0006 00df f002      btst.b #$0006,$00dff002
 0 0002a5b4 0839 0006 00df f002      btst.b #$0006,$00dff002
 0 0002a5bc 66f6                     bne.b #$f6 == $0002a5b4 (T)
 0 0002a5be 33fc 0100 00df f040      move.w #$0100,$00dff040
 0 0002a5c6 33fc 0000 00df f042      move.w #$0000,$00dff042
 0 0002a5ce 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
 0 0002a5d8 33fc 0000 00df f066      move.w #$0000,$00dff066
 0 0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
 0 0002a5aa 66ec                     bne.b #$ec == $0002a598 (T)
;------------------------------------------------------------------------------
>d pc
0002a5aa 66ec                     bne.b #$ec == $0002a598 (T)
0002a5ac 0839 0006 00df f002      btst.b #$0006,$00dff002
0002a5b4 0839 0006 00df f002      btst.b #$0006,$00dff002
0002a5bc 66f6                     bne.b #$f6 == $0002a5b4 (T)
0002a5be 33fc 0100 00df f040      move.w #$0100,$00dff040
0002a5c6 33fc 0000 00df f042      move.w #$0000,$00dff042
0002a5ce 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
0002a5d8 33fc 0000 00df f066      move.w #$0000,$00dff066
0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
0002a5e8 0839 0002 00df f016      btst.b #$0002,$00dff016
;------------------------------------------------------------------------------
>f 2a5e0																		; set breakpoint
Breakpoint added.
;------------------------------------------------------------------------------
>g																				; run
Breakpoint 0 triggered.
Cycles: 18262 Chip, 36524 CPU. (V=0 H=2 -> V=80 H=104)
  D0 00005000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000050
0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 0002a5e8
;------------------------------------------------------------------------------
>H 10																			; first round without dma-data
 0 0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
 - 18 CPU-RW     5000 0002A5A8
 - 1A CPU-RW     66EC 0002A5AA
 - 1C CPU-RW     0839 0002A5AC
 0 0002a5aa 66ec                     bne.b #$ec == $0002a598 (F)
 - 21 CPU-RW     0006 0002A5AE
 0 0002a5ac 0839 0006 00df f002      btst.b #$0006,$00dff002
 - 23 CPU-RW     00DF 0002A5B0
 - 25 CPU-RW     F002 0002A5B2
 - 27 CPU-RW     0839 0002A5B4
 - 29 CPU-RB     0023 00DFF002
 - 2B CPU-RW     0006 0002A5B6
 0 0002a5b4 0839 0006 00df f002      btst.b #$0006,$00dff002
 - 2D CPU-RW     00DF 0002A5B8
 - 2F CPU-RW     F002 0002A5BA
 - 31 CPU-RW     66F6 0002A5BC
 - 33 CPU-RB     0023 00DFF002
 - 35 CPU-RW     33FC 0002A5BE
 0 0002a5bc 66f6                     bne.b #$f6 == $0002a5b4 (F)
 - 39 CPU-RW     0100 0002A5C0
 0 0002a5be 33fc 0100 00df f040      move.w #$0100,$00dff040
 - 3B CPU-RW     00DF 0002A5C2
 - 3C          0
 - 3D CPU-RW     F040 0002A5C4
 - 3F CPU-RW     33FC 0002A5C6
 - 42 CPU-WW     0100 00DFF040
 - 44 CPU-RW     0000 0002A5C8
 0 0002a5c6 33fc 0000 00df f042      move.w #$0000,$00dff042
 - 46 CPU-RW     00DF 0002A5CA
 - 48 CPU-RW     F042 0002A5CC
 - 4A CPU-RW     23FC 0002A5CE
 - 4C CPU-WW     0000 00DFF042
 - 4E CPU-RW     0001 0002A5D0
 0 0002a5ce 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
 - 50 CPU-RW     0508 0002A5D2
 - 52 CPU-RW     00DF 0002A5D4
 - 54 CPU-RW     F054 0002A5D6
 - 56 CPU-RW     33FC 0002A5D8
 - 58 CPU-WW     0001 00DFF054
 - 5A CPU-WW     0508 00DFF056
 - 5C CPU-RW     0000 0002A5DA
 0 0002a5d8 33fc 0000 00df f066      move.w #$0000,$00dff066
 - 5E CPU-RW     00DF 0002A5DC
 - 60 CPU-RW     F066 0002A5DE
 - 62 CPU-RW     33FC 0002A5E0
 - 64 CPU-WW     0000 00DFF066
 - 66 CPU-RW     0050 0002A5E2
 0 0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
;------------------------------------------------------------------------------
>V $50 $48																		; first round without dma-data
Line: 50  80 HPOS 48  72:
 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-RW              CPU-RW              CPU-WW              CPU-RW
     F042                23FC                0000                0001
 0002A5CC            0002A5CE            00DFF042            0002A5D0
 F92F4600  F92F4800  F92F4A00  F92F4C00  F92F4E00  F92F5000  F92F5200  F92F5400

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
   CPU-RW              CPU-RW              CPU-RW              CPU-RW
     0508                00DF                F054                33FC
 0002A5D2            0002A5D4            0002A5D6            0002A5D8
 F92F5600  F92F5800  F92F5A00  F92F5C00  F92F5E00  F92F6000  F92F6200  F92F6400

 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
   CPU-WW              CPU-WW              CPU-RW              CPU-RW
     0001                0508                0000                00DF
 00DFF054            00DFF056            0002A5DA            0002A5DC
 F92F6600  F92F6800  F92F6A00  F92F6C00  F92F6E00  F92F7000  F92F7200  F92F7400

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
   CPU-RW              CPU-RW              CPU-WW              CPU-RW
     F066                33FC                0000                0050
 0002A5DE            0002A5E0            00DFF066            0002A5E2
 F92F7600  F92F7800  F92F7A00  F92F7C00  F92F7E00  F92F8000  F92F8200  F92F8400

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]



 F92F8600  F92F8800  F92F8A00  F92F8C00  F92F8E00  F92F9000  F92F9200  F92F9400

 [70 112]  [71 113]  [72 114]  [73 115]  [74 116]  [75 117]  [76 118]  [77 119]



 F92F9600  F92F9800  F92F9A00  F92F9C00  F92F9E00  F92FA000  F92FA200  F92FA400

 [78 120]  [79 121]  [7A 122]  [7B 123]  [7C 124]  [7D 125]  [7E 126]  [7F 127]



 F92FA600  F92FA800  F92FAA00  F92FAC00  F92FAE00  F92FB000  F92FB200  F92FB400

 [80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]



 F92FB600  F92FB800  F92FBA00  F92FBC00  F92FBE00  F92FC000  F92FC200  F92FC400

 [88 136]  [89 137]  [8A 138]  [8B 139]  [8C 140]  [8D 141]  [8E 142]  [8F 143]



 F92FC600  F92FC800  F92FCA00  F92FCC00  F92FCE00  F92FD000  F92FD200  F92FD400

 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]



 F92FD600  F92FD800  F92FDA00  F92FDC00  F92FDE00  F92FE000  F92FE200  F92FE400
;------------------------------------------------------------------------------
>g																				; run again - to collect dma data
Breakpoint 0 triggered.
Cycles: 149 Chip, 298 CPU. (V=80 H=104 -> V=81 H=26)
  D0 00005000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000050
0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 0002a5e8
;------------------------------------------------------------------------------
>V $50 $48																		; now with dma-data
Line: 50  80 HPOS 48  72:
 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-WW  BPL2 112    CPU-RW  BPL1 110
     F042      0000      23FC      0000      0000      0000      0001      0000
 0002A5CC  0001A894  0002A5CE  00015894  00DFF042  0001A896  0002A5D0  00015896
 F92F4600  F92F4800  F92F4A00  F92F4C00  F92F4E00  F92F5000  F92F5200  F92F5400

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     0508      0000      00DF      0000      F054      0000      33FC      0000
 0002A5D2  0001A898  0002A5D4  00015898  0002A5D6  0001A89A  0002A5D8  0001589A
 F92F5600  F92F5800  F92F5A00  F92F5C00  F92F5E00  F92F6000  F92F6200  F92F6400

 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
   CPU-WW  BPL2 112    CPU-WW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     0001      0000      0508      0000      0000      0000      00DF      0000
 00DFF054  0001A89C  00DFF056  0001589C  0002A5DA  0001A89E  0002A5DC  0001589E
 F92F6600  F92F6800  F92F6A00  F92F6C00  F92F6E00  F92F7000  F92F7200  F92F7400

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-WW  BPL2 112    CPU-RW  BPL1 110
     F066      0000      33FC      0000      0000      0000      0050      0000
 0002A5DE  0001A8A0  0002A5E0  000158A0  00DFF066  0001A8A2  0002A5E2  000158A2
 F92F7600  F92F7800  F92F7A00  F92F7C00  F92F7E00  F92F8000  F92F8200  F92F8400

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-WW  BPL1 110
     00DF      0000      F058      0000      0839      0000      0050      0000
 0002A5E4  0001A8A4  0002A5E6  000158A4  0002A5E8  0001A8A6  00DFF058  000158A6
 F92F8600  F92F8800  F92F8A00  F92F8C00  F92F8E00  F92F9000  F92F9200  F92F9400

 [70 112]  [71 113]  [72 114]  [73 115]  [74 116]  [75 117]  [76 118]  [77 119]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
 B   0002      0000  B   00DF      0000  B)  F016      0000  B   66A6      0000
 0002A5EA  0001A8A8  0002A5EC  000158A8  0002A5EE  0001A8AA  0002A5F0  000158AA
 F92F9600  F92F9800  F92F9A00  F92F9C00  F92F9E00  F92FA000  F92FA200  F92FA400

 [78 120]  [79 121]  [7A 122]  [7B 123]  [7C 124]  [7D 125]  [7E 126]  [7F 127]
   CPU-RB  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110		; with collected dma-data
 B   0005      0000      0000      0000  B   4EAE      0000      0000      0000
 00DFF016  0001A8AC  00010508  000158AC  0002A5F2  0001A8AE  0001050A  000158AE
 F92FA600  F92FA800  F92FAA00  F92FAC00  F92FAE00  F92FB000  F92FB200  F92FB400

 [80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110
 B   2039      0000      0000      0000  B   00DF      0000      0000      0000
 0002A598  0001A8B0  0001050C  000158B0  0002A59A  0001A8B2  0001050E  000158B2
 F92FB600  F92FB800  F92FBA00  F92FBC00  F92FBE00  F92FC000  F92FC200  F92FC400

 [88 136]  [89 137]  [8A 138]  [8B 139]  [8C 140]  [8D 141]  [8E 142]  [8F 143]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110
 B   F004      0000      0000      0000  B   0280      0000      0000      0000
 0002A59C  0001A8B4  00010510  000158B4  0002A59E  0001A8B6  00010512  000158B6
 F92FC600  F92FC800  F92FCA00  F92FCC00  F92FCE00  F92FD000  F92FD200  F92FD400

 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110
 B   8000      0000      0000      0000  B   5095      0000      0000      0000
 00DFF004  0001A8B8  00010514  000158B8  00DFF006  0001A8BA  00010516  000158BA
 F92FD600  F92FD800  F92FDA00  F92FDC00  F92FDE00  F92FE000  F92FE200  F92FE400
;------------------------------------------------------------------------------
>H 10																			; History also with dma-data	
 0 0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0
 - A8 CPU-RW B   5000 0002A5A8
 - A9 BPL2 112     0000 0001A8C4
 - AA BLT-D 00     0000 00010520
 - AB BPL1 110     0000 000158C4
 - AC CPU-RW B   66EC 0002A5AA
 - AD BPL2 112     0000 0001A8C6
 - AE BLT-D 00     0000 00010522
 - AF BPL1 110     0000 000158C6
 - B0 CPU-RW B   0839 0002A5AC
 - B1 BPL2 112 b   0000 0001A8C8
 - B2 BLT-D 00     0000 00010524
 0 0002a5aa 66ec                     bne.b #$ec == $0002a598 (F)
 - B3 BPL1 110     0000 000158C8
 - B4 BLT-D 00 D   0000 00010526
 - B5 BPL2 112     0000 0001A8CA
 - B6 CPU-RW     0006 0002A5AE
 - B7 BPL1 110     0000 000158CA
 0 0002a5ac 0839 0006 00df f002      btst.b #$0006,$00dff002
 - B8 CPU-RW     00DF 0002A5B0
 - B9 BPL2 112     0000 0001A8CC
 - BA CPU-RW     F002 0002A5B2
 - BB BPL1 110     0000 000158CC
 - BC CPU-RW     0839 0002A5B4
 - BD BPL2 112     0023 0001A8CE
 - BE CPU-RB     0000 00DFF002
 - BF BPL1 110     0000 000158CE
 - C0 CPU-RW     0006 0002A5B6
 - C1 BPL2 112     0000 0001A8D0
 0 0002a5b4 0839 0006 00df f002      btst.b #$0006,$00dff002
 - C2 CPU-RW     00DF 0002A5B8
 - C3 BPL1 110     0000 000158D0
 - C4 CPU-RW     F002 0002A5BA
 - C5 BPL2 112     0000 0001A8D2
 - C6 CPU-RW     66F6 0002A5BC
 - C7 BPL1 110     0023 000158D2
 - C8 CPU-RB     0000 00DFF002
 - C9 BPL2 112     0000 0001A8D4
 - CA CPU-RW     33FC 0002A5BE
 - CB BPL1 110     0000 000158D4
 0 0002a5bc 66f6                     bne.b #$f6 == $0002a5b4 (F)
 - CD BPL2 112     0000 0001A8D6
 - CE CPU-RW     0100 0002A5C0
 - CF BPL1 110     0000 000158D6
 0 0002a5be 33fc 0100 00df f040      move.w #$0100,$00dff040
 - D0 CPU-RW 1   00DF 0002A5C2
 - D1 BPL2 112     0000 0001A8D8
 - D2 CPU-RW     F040 0002A5C4
 - D3 BPL1 110     0000 000158D8
 - D4 CPU-RW     33FC 0002A5C6
 - D5 BPL2 112     0000 0001A8DA
 - D6 CPU-WW     0100 00DFF040
 - D7 BPL1 110     0000 000158DA
 - D8 CPU-RW     0000 0002A5C8
 - D9 BPL2 112     0000 0001A8DC
 0 0002a5c6 33fc 0000 00df f042      move.w #$0000,$00dff042
 - DA CPU-RW     00DF 0002A5CA
 - DB BPL1 110     0000 000158DC
 - DC CPU-RW     F042 0002A5CC
 - DD BPL2 112     0000 0001A8DE
 - DE CPU-RW     23FC 0002A5CE
 - DF BPL1 110     0000 000158DE
 - E0 CPU-WW     0000 00DFF042
 - E2 CPU-RW     0000 0002A5D0
 0 0002a5ce 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
 - 01 CPU-RW     0508 0002A5D2
 - 03 RFS0 03C *=
 - 04 CPU-RW     00DF 0002A5D4
 - 05 RFS1 1FE *F
 - 06 CPU-RW     F054 0002A5D6
 - 07 RFS2 1FE
 - 08 CPU-RW     33FC 0002A5D8
 - 09 RFS3 1FE
 - 0A CPU-WW     0001 00DFF054
 - 0C CPU-WW     0508 00DFF056
 - 0E CPU-RW     0000 0002A5DA
 0 0002a5d8 33fc 0000 00df f066      move.w #$0000,$00dff066
 - 10 CPU-RW     00DF 0002A5DC
 - 12 CPU-RW     F066 0002A5DE
 - 14 CPU-RW     33FC 0002A5E0
 - 16 CPU-WW     0000 00DFF066
 - 18 CPU-RW     0050 0002A5E2
 0 0002a5e0 33fc 0050 00df f058      move.w #$0050,$00dff058
>

from EAB
Ok, then make sure at least one break point is enabled. History is only collected if at least
one break point is enabled (or when debugger is called). It would slow down emulation noticeably.
for example "f 0" is enough.


first field in a disasm output:
-1 00fc0f94 60e6                     bra.b #$e6 == $00fc0f7c (T)
 0 0002a5a4 0c80 0000 5000           cmp.l #$00005000,d0

It is CPU interrupt mask. (-1 = mask=0, supervisor mode.
						    0 = mask=0, user mode)
