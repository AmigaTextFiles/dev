
; Listing19k5.s
; DMA-Debugger - DMA map ; some extra letters
; reset-screen (hand with workbench screen)

; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger	
; cycle-exact not enabled
;------------------------------------------------------------------------------

																				; start the programm				   
																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
>v-4
DMA debugger enabled, mode=4.
>x																				
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger


>v $04
Line: 04   4 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
                               RFS0 038            RFS1 1FE            RFS2 1FE
                                    *SB                  *F							; vertical sync (S)
																					; vertical blanking (B)
"Copper wake up" (W) and
"Copper wanted this cycle but couldn't get it" (c)
 markers in DMA debugger had disappeared. Skip also shows 'W' if SKIP skipped.

DMA debugger uses first refresh slot to show if line is
	- vertical blanking (B),
	- vertical sync (S) or 
	- vertical diw is open (=), 
second refresh slot is used for long field (F) and long line (L).

These special slots are marked with '*' to not
(too easily) confuse them with same symbols in other slots.

				Horizontal diw ('(' and ')'), 
programmed horizontal blanking ('[' and ']') 
and programmed horizontal sync ('{' and '}') are also marked.


>v $2c
Line: 2C  44 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
                               RFS0 03C            RFS1 1FE  COP  08C  RFS2 1FE
                                     *=  W               *F      0100				; *=  vertical diw is open (=)
                                                             0000B8D4				; *F= long field (F)
 98F94200  98F94400  98F94600  98F94800  98F94A00  98F94C00  98F94E00  98F95000		; marked with * only in for refresh slot 
																					; W - Copper wake up
 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
 COP  100  RFS3 1FE  COP  08C            COP  08C
     2200                F401                FFFE
 0000B8D6            0000B8D8            0000B8D8
 98F95200  98F95400  98F95600  98F95800  98F95A00  98F95C00  98F95E00  98F96000

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]



 98F96200  98F96400  98F96600  98F96800  98F96A00  98F96C00  98F96E00  98F97000

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]



 98F97200  98F97400  98F97600  98F97800  98F97A00  98F97C00  98F97E00  98F98000

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]

                                         (											; ( - Horizontal diw

 98F98200  98F98400  98F98600  98F98800  98F98A00  98F98C00  98F98E00  98F99000

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]



 98F99200  98F99400  98F99600  98F99800  98F99A00  98F99C00  98F99E00  98F9A000

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]



 98F9A200  98F9A400  98F9A600  98F9A800  98F9AA00  98F9AC00  98F9AE00  98F9B000

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
                                                                       BPL2 112
 0                                                                         0000		; 0 - DDFSTRT (0)
                                                                       00007A02
 98F9B200  98F9B400  98F9B600  98F9B800  98F9BA00  98F9BC00  98F9BE00  98F9C000

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AC2                                00007A04
 98F9C200  98F9C400  98F9C600  98F9C800  98F9CA00  98F9CC00  98F9CE00  98F9D000

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AC4                                00007A06
 98F9D200  98F9D400  98F9D600  98F9D800  98F9DA00  98F9DC00  98F9DE00  98F9E000
 

 >v $2c $48
Line: 2C  44 HPOS 48  72:
 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AC4                                00007A06
 98F9D200  98F9D400  98F9D600  98F9D800  98F9DA00  98F9DC00  98F9DE00  98F9E000

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AC6                                00007A08
 98F9E200  98F9E400  98F9E600  98F9E800  98F9EA00  98F9EC00  98F9EE00  98F9F000

 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AC8                                00007A0A
 98F9F200  98F9F400  98F9F600  98F9F800  98F9FA00  98F9FC00  98F9FE00  98FA0000

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005ACA                                00007A0C
 98FA0200  98FA0400  98FA0600  98FA0800  98FA0A00  98FA0C00  98FA0E00  98FA1000

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005ACC                                00007A0E
 98FA1200  98FA1400  98FA1600  98FA1800  98FA1A00  98FA1C00  98FA1E00  98FA2000

 [70 112]  [71 113]  [72 114]  [73 115]  [74 116]  [75 117]  [76 118]  [77 119]
                               BPL1 110                                BPL2 112
                                   0000  )                                 0000		; ) - Horizontal diw
                               00005ACE                                00007A10
 98FA2200  98FA2400  98FA2600  98FA2800  98FA2A00  98FA2C00  98FA2E00  98FA3000

 [78 120]  [79 121]  [7A 122]  [7B 123]  [7C 124]  [7D 125]  [7E 126]  [7F 127]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AD0                                00007A12
 98FA3200  98FA3400  98FA3600  98FA3800  98FA3A00  98FA3C00  98FA3E00  98FA4000

 [80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AD2                                00007A14
 98FA4200  98FA4400  98FA4600  98FA4800  98FA4A00  98FA4C00  98FA4E00  98FA5000

 [88 136]  [89 137]  [8A 138]  [8B 139]  [8C 140]  [8D 141]  [8E 142]  [8F 143]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AD4                                00007A16
 98FA5200  98FA5400  98FA5600  98FA5800  98FA5A00  98FA5C00  98FA5E00  98FA6000

 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AD6                                00007A18
 98FA6200  98FA6400  98FA6600  98FA6800  98FA6A00  98FA6C00  98FA6E00  98FA7000

>v $2c $90
Line: 2C  44 HPOS 90 144:
 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AD6                                00007A18
 98FA6200  98FA6400  98FA6600  98FA6800  98FA6A00  98FA6C00  98FA6E00  98FA7000

 [98 152]  [99 153]  [9A 154]  [9B 155]  [9C 156]  [9D 157]  [9E 158]  [9F 159]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AD8                                00007A1A
 98FA7200  98FA7400  98FA7600  98FA7800  98FA7A00  98FA7C00  98FA7E00  98FA8000

 [A0 160]  [A1 161]  [A2 162]  [A3 163]  [A4 164]  [A5 165]  [A6 166]  [A7 167]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005ADA                                00007A1C
 98FA8200  98FA8400  98FA8600  98FA8800  98FA8A00  98FA8C00  98FA8E00  98FA9000

 [A8 168]  [A9 169]  [AA 170]  [AB 171]  [AC 172]  [AD 173]  [AE 174]  [AF 175]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005ADC                                00007A1E
 98FA9200  98FA9400  98FA9600  98FA9800  98FA9A00  98FA9C00  98FA9E00  98FAA000

 [B0 176]  [B1 177]  [B2 178]  [B3 179]  [B4 180]  [B5 181]  [B6 182]  [B7 183]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005ADE                                00007A20
 98FAA200  98FAA400  98FAA600  98FAA800  98FAAA00  98FAAC00  98FAAE00  98FAB000

 [B8 184]  [B9 185]  [BA 186]  [BB 187]  [BC 188]  [BD 189]  [BE 190]  [BF 191]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AE0                                00007A22
 98FAB200  98FAB400  98FAB600  98FAB800  98FABA00  98FABC00  98FABE00  98FAC000

 [C0 192]  [C1 193]  [C2 194]  [C3 195]  [C4 196]  [C5 197]  [C6 198]  [C7 199]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AE2                                00007A24
 98FAC200  98FAC400  98FAC600  98FAC800  98FACA00  98FACC00  98FACE00  98FAD000

 [C8 200]  [C9 201]  [CA 202]  [CB 203]  [CC 204]  [CD 205]  [CE 206]  [CF 207]
                               BPL1 110                                BPL2 112
                                   0000                                    0000
                               00005AE4                                00007A26
 98FAD200  98FAD400  98FAD600  98FAD800  98FADA00  98FADC00  98FADE00  98FAE000

 [D0 208]  [D1 209]  [D2 210]  [D3 211]  [D4 212]  [D5 213]  [D6 214]  [D7 215]
                               BPL1 110                                BPL2 112
 1                                 0000                                    0000		; 1 - DDFSTOP (1)
                               00005AE6                                00007A28
 98FAE200  98FAE400  98FAE600  98FAE800  98FAEA00  98FAEC00  98FAEE00  98FAF000

 [D8 216]  [D9 217]  [DA 218]  [DB 219]  [DC 220]  [DD 221]  [DE 222]  [DF 223]
                               BPL1 110
                                   0000
                               00005AE8
 98FAF200  98FAF400  98FAF600  98FAF800  98FAFA00  98FAFC00  98FAFE00  98FB0000

>v $2c $d8
Line: 2C  44 HPOS D8 216:
 [D8 216]  [D9 217]  [DA 218]  [DB 219]  [DC 220]  [DD 221]  [DE 222]  [DF 223]
                               BPL1 110
                                   0000
                               00005AE8
 98FAF200  98FAF400  98FAF600  98FAF800  98FAFA00  98FAFC00  98FAFE00  98FB0000

 [E0 224]  [E1 225]  [E2 226]



 98FB0200  98FB0400  98FB0600

 