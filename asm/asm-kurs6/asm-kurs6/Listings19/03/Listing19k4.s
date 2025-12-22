
; Listing19k4.s		blitter cycle sequence

; Listing9a1.s - Löschen von $10 Wörter mit dem BLITTER (dient als Vorlage)
; Bevor Sie dieses Beispiel sich ansehen, schauen Sie sich Listing2fs an, wo es herkommt
; gelöschter Speicher mit dem 68000

	SECTION Blit,CODE

Inizio:
	move.l	4.w,a6				; Execbase in a6
	jsr	-$78(a6)				; Disable - stop multitasking
	lea	GfxName,a1				; Adresse des Namens der zu öffnenden Bibliothek in a1
	jsr	-$198(a6)				; OpenLibrary
	move.l	d0,a6				; benutze eine Routine von graphics library:

	jsr	-$1c8(a6)				; OwnBlitter, 
								; das gibt uns den exklusiven Zugang auf dem Blitter
								; verhindert, das es vom Betriebssystem verwendet wird.
								; Wir müssen warten, bevor wir den Blitter benutzen
								; das es einen laufenden BLittervorgang beendet hat.
								; Die folgenden Anweisungen erledigen das							    
;------------------------------------------------------------------------------
WaitWblank:
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00005000,d0			; $50
	;cmp.l #$000001000,d0		; $10  (ohne Bitplanearea) 
	bne.s	WaitWblank

	btst	#6,$dff002			; warte auf das Ende des Blitters (leerer Test)
								; für den BUG von Agnus
waitblit:
	btst	#6,$dff002			; freier Blitter?
	bne.s	waitblit

; Hier ist, wie man eine Blittata macht !!! 
; Nur 5 Anweisungen zum Zurücksetzen !!!
;	     __
;	__  /_/\   __
;	\/  \_\/  /\_\
;	 __   __  \/_/   __
;	/\_\ /\_\  __   /\_\
;	\/_/ \/_/ /_/\  \/_/
;	     __   \_\/
;	    /\_\  __
;	    \/_/  \/

	move.w	#$0100,$dff040		; BLTCON0: nur Ziel D ist aktiviert				
								; die MINTERMS (dh die Bits 0-7) sind alle
								; zurückgesetzt. Auf diese Weise ist die 
								; Löschoperation definiert					

	move.w	#$0000,$dff042		; BLTCON1: Wir werden dieses Register später erklären
	move.l	#START,$dff054		; BLTDPT: Adresse des Zielkanals
	move.w	#$0000,$dff066		; BLTDMOD: Wir werden dieses Register später erklären
	move.w	#(1*64)+$10,$dff058 ; BLTSIZE: definiert die Dimension des
								; Rechtecks. In diesem Fall haben wir
								; $10 Wörter Breite und 1 Zeilenhöhe.
								; Weil die Höhe des Rechtecks in die Bits 6-15 von 
								; BLTSIZE ??geschrieben wird
								; müssen wir es 6 Bits nach links verschieben.
								; Dies entspricht der Multiplikation seines Wertes
								; mit 64. Die Breite wird in die niedrigen
								; 6 Bits geschrieben und werden daher nicht
								; geändert.
								; Außerdem beginnt diese Anweisung die Blittata					 

	;btst	#6,$dff002			; warte auf das Ende des Blitters (leerer Test)
;waitblit2:
	;btst	#6,$dff002			; freier Blitter?
	;bne.s	waitblit2

	btst	#2,$dff016			; right mousebutton?
	bne.s	WaitWblank	
;------------------------------------------------------------------------------

	jsr	-$1ce(a6)				; DisOwnBlitter, das Betriebssystem
								; kann den Blitter jetzt wieder benutzen
	move.l	a6,a1				; Basis der Grafikbibliothek zum Schließen
	move.l	4.w,a6
	jsr	-$19e(a6)				; Closelibrary - schließe die Grafikbibliothek
	jsr	-$7e(a6)				; Enable - Multitasking einschalten
	rts

******************************************************************************

	SECTION THE_DATA,DATA_C

; Beachten Sie, dass die gelöschten Daten im CHIP-Speicher liegen müssen
; Tatsächlich funktioniert der Blitter nur im CHIP-Speicher

START:
	dcb.b	$20,$fe
THEEND:
	dc.b	'Hier loeschen wir nicht'

	even

GfxName:
	dc.b	"graphics.library",0,0

	end


 ;------------------------------------------------------------------------------
 ; 1. Test - Blitteroperation inside bitplane
 ; Waitblank here: cmp.l #$00005000,d0		; line $10
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
>v-4
DMA debugger enabled, mode=4.
>x																				
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger

  D0 00006800   D1 00014FE8   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00014FE8   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=1 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c80 (CMP) 0000 (OR) Chip latch 00000000
0002642c 0c80 0000 5000           cmp.l #$00005000,d0
Next PC: 00026432
;------------------------------------------------------------------------------
>vm
0,0: 00222222 * -
1,0: 00444444 * Refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000 * Audio
4,1: 00ff0000 * Audio
4,2: 00ff0000 * Audio
4,3: 00ff0000 * Audio
5,0: 00008888 * Blitter
5,1: 000088ff * Blitter
6,0: 000000ff * Bitplane
6,1: 000000ff * Bitplane
6,2: 000000ff * Bitplane
6,3: 000000ff * Bitplane
6,4: 000000ff * Bitplane
6,5: 000000ff * Bitplane
6,6: 000000ff * Bitplane
6,7: 000000ff * Bitplane
7,0: 00ff00ff * Sprite
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
;------------------------------------------------------------------------------
>vm 5 00ff00																	; change blitter color to green
5,0: 0000ff00 * Blitter
>x
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
>v $50																			; watch DMA-Debugger Info
Line: 50  80 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
             CPU-RW            RFS0 03C    CPU-RW  RFS1 1FE    CPU-RW  RFS2 1FE
               8000                  *=      5005        *F      000F
           00DFF004                      00DFF006            00021974
 B065CA00  B065CC00  B065CE00  B065D000  B065D200  B065D400  B065D600  B065D800

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
   CPU-RW  RFS3 1FE    CPU-RW              CPU-RW
     FF00                0C80                0000
 00021976            00021978            0002197A
 B065DA00  B065DC00  B065DE00  B065E000  B065E200  B065E400  B065E600  B065E800

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
   CPU-RW              CPU-RW              CPU-RW
     5000                66EC                0839
 0002197C            0002197E            00021980
 B065EA00  B065EC00  B065EE00  B065F000  B065F200  B065F400  B065F600  B065F800

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               0006                00DF                F002                0839
           00021982            00021984            00021986            00021988
 B065FA00  B065FC00  B065FE00  B0660000  B0660200  B0660400  B0660600  B0660800

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
             CPU-RB              CPU-RW              CPU-RW              CPU-RW
               0023                0006  (             00DF                F002		; (
           00DFF002            0002198A            0002198C            0002198E
 B0660A00  B0660C00  B0660E00  B0661000  B0661200  B0661400  B0661600  B0661800

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
             CPU-RW              CPU-RB              CPU-RW
               66F6                0023                33FC
           00021990            00DFF002            00021992
 B0661A00  B0661C00  B0661E00  B0662000  B0662200  B0662400  B0662600  B0662800

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               0100                00DF                F040                33FC
           00021994            00021996            00021998            0002199A
 B0662A00  B0662C00  B0662E00  B0663000  B0663200  B0663400  B0663600  B0663800

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
             CPU-WW              CPU-RW              CPU-RW              CPU-RW		
               0100                0000  0             00DF                F042		; 0
           00DFF040            0002199C            0002199E            000219A0
 B0663A00  B0663C00  B0663E00  B0664000  B0664200  B0664400  B0664600  B0664800

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
           BPL2 112    CPU-RW  BPL1 110    CPU-WW  BPL2 112    CPU-RW  BPL1 110
               0000      23FC      0000      0000      0000      0006      0600
           0001A890  000219A2  00015890  00DFF042  0001A892  000219A4  00015892
 B0664A00  B0664C00  B0664E00  B0665000  B0665200  B0665400  B0665600  B0665800

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     A4D8      0000      00DF      0000      F054      0000      33FC      005A
 000219A6  0001A894  000219A8  00015894  000219AA  0001A896  000219AC  00015896
 B0665A00  B0665C00  B0665E00  B0666000  B0666200  B0666400  B0666600  B0666800
;------------------------------------------------------------------------------
>v $50 $48
Line: 50  80 HPOS 48  72:
 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     A4D8      0000      00DF      0000      F054      0000      33FC      005A
 000219A6  0001A894  000219A8  00015894  000219AA  0001A896  000219AC  00015896
 B0665A00  B0665C00  B0665E00  B0666000  B0666200  B0666400  B0666600  B0666800

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
   CPU-WW  BPL2 112    CPU-WW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     0006      0000      A4D8      0000      0000      0000      00DF      0000
 00DFF054  0001A898  00DFF056  00015898  000219AE  0001A89A  000219B0  0001589A
 B0666A00  B0666C00  B0666E00  B0667000  B0667200  B0667400  B0667600  B0667800

 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-WW  BPL2 112    CPU-RW  BPL1 110
     F066      0000      33FC      0000      0000      0000      0050      0000
 000219B2  0001A89C  000219B4  0001589C  00DFF066  0001A89E  000219B6  0001589E
 B0667A00  B0667C00  B0667E00  B0668000  B0668200  B0668400  B0668600  B0668800

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-WW  BPL1 110
     00DF      0000      F058      0000      0839      0000      0050      0000
 000219B8  0001A8A0  000219BA  000158A0  000219BC  0001A8A2  00DFF058  000158A2
 B0668A00  B0668C00  B0668E00  B0669000  B0669200  B0669400  B0669600  B0669800

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
 B   0002      0000  B   00DF      0000  B   F016      0000  B   66A6      0000		; B
 000219BE  0001A8A4  000219C0  000158A4  000219C2  0001A8A6  000219C4  000158A6
 B0669A00  B0669C00  B0669E00  B066A000  B066A200  B066A400  B066A600  B066A800

 [70 112]  [71 113]  [72 114]  [73 115]  [74 116]  [75 117]  [76 118]  [77 119]
   CPU-RB  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110		; search for BLT-D
 B   0005      0000      0000      0000  B)  4EAE      0000      0000      0000		; B)
 00DFF016  0001A8A8  0006A4D8  000158A8  000219C6  0001A8AA  0006A4DA  000158AA
 B066AA00  B066AC00  B066AE00  B066B000  B066B200  B066B400  B066B600  B066B800
																					; (B=BPL, d=blit D ch, "-" cycles are free for the CPU)
 [78 120]  [79 121]  [7A 122]  [7B 123]  [7C 124]  [7D 125]  [7E 126]  [7F 127]		; = B-BdB-BdB-BdB-Bd (this is correct!)
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110		; -BdB-BdB
 B   2039      0000      0000      0000  B   00DF      0000      0000      0000		
 0002196C  0001A8AC  0006A4DC  000158AC  0002196E  0001A8AE  0006A4DE  000158AE
 B066BA00  B066BC00  B066BE00  B066C000  B066C200  B066C400  B066C600  B066C800

 [80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110		; -BdB-BdB
 B   F004      0000      0000      0000  B   0280      0000      0000      0000
 00021970  0001A8B0  0006A4E0  000158B0  00021972  0001A8B2  0006A4E2  000158B2
 B066CA00  B066CC00  B066CE00  B066D000  B066D200  B066D400  B066D600  B066D800

 [88 136]  [89 137]  [8A 138]  [8B 139]  [8C 140]  [8D 141]  [8E 142]  [8F 143]		; Any blitter cycle needs free cycle, even if it is idle cycle.
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110		; CPU can use any idle blitter cycle.
 B   8000      0000      0000      0018  B   508D      0000      0000      0000
 00DFF004  0001A8B4  0006A4E4  000158B4  00DFF006  0001A8B6  0006A4E6  000158B6
 B066DA00  B066DC00  B066DE00  B066E000  B066E200  B066E400  B066E600  B066E800

 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110
 B   000F      0000      0000      0060  B   FF00      0000      0000      3866
 00021974  0001A8B8  0006A4E8  000158B8  00021976  0001A8BA  0006A4EA  000158BA
 B066EA00  B066EC00  B066EE00  B066F000  B066F200  B066F400  B066F600  B066F800
;------------------------------------------------------------------------------
>v $50 $90
Line: 50  80 HPOS 90 144:
 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110
 B   000F      0000      0000      0060  B   FF00      0000      0000      3866
 00021974  0001A8B8  0006A4E8  000158B8  00021976  0001A8BA  0006A4EA  000158BA
 B066EA00  B066EC00  B066EE00  B066F000  B066F200  B066F400  B066F600  B066F800

 [98 152]  [99 153]  [9A 154]  [9B 155]  [9C 156]  [9D 157]  [9E 158]  [9F 159]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110
 B   0C80      0000      0000      005A  B   0000      0000      0000      0060
 00021978  0001A8BC  0006A4EC  000158BC  0002197A  0001A8BE  0006A4EE  000158BE
 B066FA00  B066FC00  B066FE00  B0670000  B0670200  B0670400  B0670600  B0670800

 [A0 160]  [A1 161]  [A2 162]  [A3 163]  [A4 164]  [A5 165]  [A6 166]  [A7 167]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110
 B   5000      0000      0000      0000  B   66EC      0000      0000      0000
 0002197C  0001A8C0  0006A4F0  000158C0  0002197E  0001A8C2  0006A4F2  000158C2
 B0670A00  B0670C00  B0670E00  B0671000  B0671200  B0671400  B0671600  B0671800

 [A8 168]  [A9 169]  [AA 170]  [AB 171]  [AC 172]  [AD 173]  [AE 174]  [AF 175]
   CPU-RW  BPL2 112  BLT-D 00  BPL1 110  BLT-D 00  BPL2 112    CPU-RW  BPL1 110
 B   0839  b   0000      0000      0000  D   0000      0000      0006      0000		; b	; D
 00021980  0001A8C4  0006A4F4  000158C4  0006A4F6  0001A8C6  00021982  000158C6
 B0671A00  B0671C00  B0671E00  B0672000  B0672200  B0672400  B0672600  B0672800

 [B0 176]  [B1 177]  [B2 178]  [B3 179]  [B4 180]  [B5 181]  [B6 182]  [B7 183]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RB  BPL1 110
     00DF      0000      F002      0000      0839      0023      0000      0000
 00021984  0001A8C8  00021986  000158C8  00021988  0001A8CA  00DFF002  000158CA
 B0672A00  B0672C00  B0672E00  B0673000  B0673200  B0673400  B0673600  B0673800

 [B8 184]  [B9 185]  [BA 186]  [BB 187]  [BC 188]  [BD 189]  [BE 190]  [BF 191]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     0006      0000      00DF      0000      F002      0000      66F6      0023
 0002198A  0001A8CC  0002198C  000158CC  0002198E  0001A8CE  00021990  000158CE
 B0673A00  B0673C00  B0673E00  B0674000  B0674200  B0674400  B0674600  B0674800

 [C0 192]  [C1 193]  [C2 194]  [C3 195]  [C4 196]  [C5 197]  [C6 198]  [C7 199]
   CPU-RB  BPL2 112    CPU-RW  BPL1 110            BPL2 112    CPU-RW  BPL1 110
     0000      0000      33FC      0000                0000      0100      0000
 00DFF002  0001A8D0  00021992  000158D0            0001A8D2  00021994  000158D2
 B0674A00  B0674C00  B0674E00  B0675000  B0675200  B0675400  B0675600  B0675800

 [C8 200]  [C9 201]  [CA 202]  [CB 203]  [CC 204]  [CD 205]  [CE 206]  [CF 207]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-WW  BPL1 110
     00DF      0000      F040      0000      33FC      0000      0100      0000
 00021996  0001A8D4  00021998  000158D4  0002199A  0001A8D6  00DFF040  000158D6
 B0675A00  B0675C00  B0675E00  B0676000  B0676200  B0676400  B0676600  B0676800

 [D0 208]  [D1 209]  [D2 210]  [D3 211]  [D4 212]  [D5 213]  [D6 214]  [D7 215]
   CPU-RW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
 1   0000      0000      00DF      0000      F042      0000      23FC      0018		; 1
 0002199C  0001A8D8  0002199E  000158D8  000219A0  0001A8DA  000219A2  000158DA
 B0676A00  B0676C00  B0676E00  B0677000  B0677200  B0677400  B0677600  B0677800

 [D8 216]  [D9 217]  [DA 218]  [DB 219]  [DC 220]  [DD 221]  [DE 222]  [DF 223]
   CPU-WW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     0000      0000      0006      0000      A4D8      0000      00DF      0000
 00DFF042  0001A8DC  000219A4  000158DC  000219A6  0001A8DE  000219A8  000158DE
 B0677A00  B0677C00  B0677E00  B0678000  B0678200  B0678400  B0678600  B0678800
;------------------------------------------------------------------------------
>v $50 $D8
Line: 50  80 HPOS D8 216:
 [D8 216]  [D9 217]  [DA 218]  [DB 219]  [DC 220]  [DD 221]  [DE 222]  [DF 223]
   CPU-WW  BPL2 112    CPU-RW  BPL1 110    CPU-RW  BPL2 112    CPU-RW  BPL1 110
     0000      0000      0006      0000      A4D8      0000      00DF      0000
 00DFF042  0001A8DC  000219A4  000158DC  000219A6  0001A8DE  000219A8  000158DE
 B0677A00  B0677C00  B0677E00  B0678000  B0678200  B0678400  B0678600  B0678800

 [E0 224]  [E1 225]  [E2 226]
   CPU-RW              CPU-RW
     F054                0000
 000219AA            000219AC
 B0678A00  B0678C00  B0678E00
;------------------------------------------------------------------------------
>H10																			; history without breakpoint
-1 00fc0f94 60e6                     bra.b #$e6 == $00fc0f7c (T)
 0 00021978 0c80 0000 5000           cmp.l #$00005000,d0
 0 00021972 0280 000f ff00           and.l #$000fff00,d0


 ;------------------------------------------------------------------------------
 ; 2. Test - Blitter outside bitplane
 ; Waitblank change to	cmp.l #$00001000,d0		; line $10
 ;------------------------------------------------------------------------------

 >r
Filename:Listing19k4.s
>a
Pass1
Pass2
No Errors
>j
 ;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger
 >v $10																			; watch DMA-Debugger Info
Line: 10  16 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
             CPU-RW            RFS0 03A            RFS1 1FE    CPU-RW  RFS2 1FE
               0000                 *B=                  *F      1000
           00025562                                          00025564
 3D839C00  3D839E00  3D83A000  3D83A200  3D83A400  3D83A600  3D83A800  3D83AA00

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
   CPU-RW  RFS3 1FE    CPU-RW                                  CPU-RW
     66EC                0839                                    2039
 00025566            00025568                                00025554
 3D83AC00  3D83AE00  3D83B000  3D83B200  3D83B400  3D83B600  3D83B800  3D83BA00

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
   CPU-RW              CPU-RW              CPU-RW              CPU-RW
     00DF                F004                0280                8000
 00025556            00025558            0002555A            00DFF004
 3D83BC00  3D83BE00  3D83C000  3D83C200  3D83C400  3D83C600  3D83C800  3D83CA00

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
   CPU-RW              CPU-RW              CPU-RW              CPU-RW
     1019                000F                FF00                0C80
 00DFF006            0002555C            0002555E            00025560
 3D83CC00  3D83CE00  3D83D000  3D83D200  3D83D400  3D83D600  3D83D800  3D83DA00

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
   CPU-RW                                  CPU-RW              CPU-RW
     0000                                (   1000                66EC
 00025562                                00025564            00025566
 3D83DC00  3D83DE00  3D83E000  3D83E200  3D83E400  3D83E600  3D83E800  3D83EA00

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
   CPU-RW                                            CPU-RW              CPU-RW
     0839                                              0006                00DF
 00025568                                          0002556A            0002556C
 3D83EC00  3D83EE00  3D83F000  3D83F200  3D83F400  3D83F600  3D83F800  3D83FA00

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
             CPU-RW              CPU-RW              CPU-RB              CPU-RW
               F002                0839                0023                0006
           0002556E            00025570            00DFF002            00025572
 3D83FC00  3D83FE00  3D840000  3D840200  3D840400  3D840600  3D840800  3D840A00

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
             CPU-RW              CPU-RW              CPU-RW              CPU-RB
               00DF                F002  0             66F6                0023
           00025574            00025576            00025578            00DFF002
 3D840C00  3D840E00  3D841000  3D841200  3D841400  3D841600  3D841800  3D841A00

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
             CPU-RW                                  CPU-RW              CPU-RW
               33FC                                    0100                00DF
           0002557A                                0002557C            0002557E
 3D841C00  3D841E00  3D842000  3D842200  3D842400  3D842600  3D842800  3D842A00

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
             CPU-RW              CPU-RW              CPU-WW              CPU-RW
               F040                33FC                0100                0000
           00025580            00025582            00DFF040            00025584
 3D842C00  3D842E00  3D843000  3D843200  3D843400  3D843600  3D843800  3D843A00
 ;------------------------------------------------------------------------------
>v $10 $48
Line: 10  16 HPOS 48  72:
 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
             CPU-RW              CPU-RW              CPU-WW              CPU-RW
               F040                33FC                0100                0000
           00025580            00025582            00DFF040            00025584
 3D842C00  3D842E00  3D843000  3D843200  3D843400  3D843600  3D843800  3D843A00

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
             CPU-RW              CPU-RW              CPU-RW              CPU-WW
               00DF                F042                23FC                0000
           00025586            00025588            0002558A            00DFF042
 3D843C00  3D843E00  3D844000  3D844200  3D844400  3D844600  3D844800  3D844A00

 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               0001                0508                00DF                F054
           0002558C            0002558E            00025590            00025592
 3D844C00  3D844E00  3D845000  3D845200  3D845400  3D845600  3D845800  3D845A00

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
             CPU-RW              CPU-WW              CPU-WW              CPU-RW
               33FC                0001                0508                0000
           00025594            00DFF054            00DFF056            00025596
 3D845C00  3D845E00  3D846000  3D846200  3D846400  3D846600  3D846800  3D846A00

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]
             CPU-RW              CPU-RW              CPU-RW              CPU-WW
               00DF                F066                33FC                0000
           00025598            0002559A            0002559C            00DFF066
 3D846C00  3D846E00  3D847000  3D847200  3D847400  3D847600  3D847800  3D847A00

 [70 112]  [71 113]  [72 114]  [73 115]  [74 116]  [75 117]  [76 118]  [77 119]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               0050                00DF  )             F058                0839
           0002559E            000255A0            000255A2            000255A4
 3D847C00  3D847E00  3D848000  3D848200  3D848400  3D848600  3D848800  3D848A00

 [78 120]  [79 121]  [7A 122]  [7B 123]  [7C 124]  [7D 125]  [7E 126]  [7F 127]
             CPU-WW              CPU-RW              CPU-RW              CPU-RW
               0050            B   0002  B         B   00DF  B         B   F016
           00DFF058            000255A6            000255A8            000255AA
 3D848C00  3D848E00  3D849000  3D849200  3D849400  3D849600  3D849800  3D849A00

 [80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RB  BLT-D 00    CPU-RW  BLT-D 00				; = d-d-d-d-
     0000  B   66A6      0000  B   0005      0000  B   4EAE      0000  B		
 00010508  000255AC  0001050A  00DFF016  0001050C  000255AE  0001050E
 3D849C00  3D849E00  3D84A000  3D84A200  3D84A400  3D84A600  3D84A800  3D84AA00

 [88 136]  [89 137]  [8A 138]  [8B 139]  [8C 140]  [8D 141]  [8E 142]  [8F 143]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW		; = d-d-d-d-
     0000  B   2039      0000  B   00DF      0000  B   F004      0000  B   0280
 00010510  00025554  00010512  00025556  00010514  00025558  00010516  0002555A
 3D84AC00  3D84AE00  3D84B000  3D84B200  3D84B400  3D84B600  3D84B800  3D84BA00

 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
     0000  B   8000      0000  B   1094      0000  B   000F      0000  B   FF00
 00010518  00DFF004  0001051A  00DFF006  0001051C  0002555C  0001051E  0002555E
 3D84BC00  3D84BE00  3D84C000  3D84C200  3D84C400  3D84C600  3D84C800  3D84CA00
 ;------------------------------------------------------------------------------
>v $10 $90
Line: 10  16 HPOS 90 144:
 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
     0000  B   8000      0000  B   1094      0000  B   000F      0000  B   FF00
 00010518  00DFF004  0001051A  00DFF006  0001051C  0002555C  0001051E  0002555E
 3D84BC00  3D84BE00  3D84C000  3D84C200  3D84C400  3D84C600  3D84C800  3D84CA00

 [98 152]  [99 153]  [9A 154]  [9B 155]  [9C 156]  [9D 157]  [9E 158]  [9F 159]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00            BLT-D 00    CPU-RW
     0000  B   0C80      0000  Bb  0000      0000            D   0000      1000		; Bb
 00010520  00025560  00010522  00025562  00010524            00010526  00025564		; D - last Blitter cycle
 3D84CC00  3D84CE00  3D84D000  3D84D200  3D84D400  3D84D600  3D84D800  3D84DA00

 [A0 160]  [A1 161]  [A2 162]  [A3 163]  [A4 164]  [A5 165]  [A6 166]  [A7 167]
             CPU-RW              CPU-RW
               66EC                0839
           00025566            00025568
 3D84DC00  3D84DE00  3D84E000  3D84E200  3D84E400  3D84E600  3D84E800  3D84EA00

 [A8 168]  [A9 169]  [AA 170]  [AB 171]  [AC 172]  [AD 173]  [AE 174]  [AF 175]
   CPU-RW              CPU-RW              CPU-RW              CPU-RW
     0006                00DF                F002                0839
 0002556A            0002556C            0002556E            00025570
 3D84EC00  3D84EE00  3D84F000  3D84F200  3D84F400  3D84F600  3D84F800  3D84FA00

 [B0 176]  [B1 177]  [B2 178]  [B3 179]  [B4 180]  [B5 181]  [B6 182]  [B7 183]
   CPU-RB              CPU-RW              CPU-RW              CPU-RW
     0023                0006                00DF                F002
 00DFF002            00025572            00025574            00025576
 3D84FC00  3D84FE00  3D850000  3D850200  3D850400  3D850600  3D850800  3D850A00

 [B8 184]  [B9 185]  [BA 186]  [BB 187]  [BC 188]  [BD 189]  [BE 190]  [BF 191]
   CPU-RW              CPU-RB              CPU-RW
     66F6                0023                33FC
 00025578            00DFF002            0002557A
 3D850C00  3D850E00  3D851000  3D851200  3D851400  3D851600  3D851800  3D851A00

 [C0 192]  [C1 193]  [C2 194]  [C3 195]  [C4 196]  [C5 197]  [C6 198]  [C7 199]
   CPU-RW              CPU-RW              CPU-RW              CPU-RW
     0100                00DF                F040                33FC
 0002557C            0002557E            00025580            00025582
 3D851C00  3D851E00  3D852000  3D852200  3D852400  3D852600  3D852800  3D852A00

 [C8 200]  [C9 201]  [CA 202]  [CB 203]  [CC 204]  [CD 205]  [CE 206]  [CF 207]
   CPU-WW              CPU-RW              CPU-RW              CPU-RW
     0100                0000                00DF                F042
 00DFF040            00025584            00025586            00025588
 3D852C00  3D852E00  3D853000  3D853200  3D853400  3D853600  3D853800  3D853A00

 [D0 208]  [D1 209]  [D2 210]  [D3 211]  [D4 212]  [D5 213]  [D6 214]  [D7 215]
   CPU-RW              CPU-WW              CPU-RW              CPU-RW
 1   23FC                0000                0001                0508
 0002558A            00DFF042            0002558C            0002558E
 3D853C00  3D853E00  3D854000  3D854200  3D854400  3D854600  3D854800  3D854A00

 [D8 216]  [D9 217]  [DA 218]  [DB 219]  [DC 220]  [DD 221]  [DE 222]  [DF 223]
   CPU-RW              CPU-RW              CPU-RW              CPU-WW
     00DF                F054                33FC                0001
 00025590            00025592            00025594            00DFF054
 3D854C00  3D854E00  3D855000  3D855200  3D855400  3D855600  3D855800  3D855A00
 ;------------------------------------------------------------------------------
>v $10 $d8
Line: 10  16 HPOS D8 216:
 [D8 216]  [D9 217]  [DA 218]  [DB 219]  [DC 220]  [DD 221]  [DE 222]  [DF 223]
   CPU-RW              CPU-RW              CPU-RW              CPU-WW
     00DF                F054                33FC                0001
 00025590            00025592            00025594            00DFF054
 3D854C00  3D854E00  3D855000  3D855200  3D855400  3D855600  3D855800  3D855A00

 [E0 224]  [E1 225]  [E2 226]
   CPU-WW              CPU-RW
     0508                0000
 00DFF056            00025596
 3D855C00  3D855E00  3D856000

>x

;------------------------------------------------------------------------------
; 3. Test - Blitter innerhalb von Bitplane
; Waitblank ändern		cmp.l #$00010100,d0		; line $101
; Breakpoint
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

 >d pc
000286ca 0280 000f ff00           and.l #$000fff00,d0
000286d0 0c80 0000 1000           cmp.l #$00001000,d0
000286d6 66ec                     bne.b #$ec == $000286c4 (T)
000286d8 0839 0006 00df f002      btst.b #$0006,$00dff002
000286e0 0839 0006 00df f002      btst.b #$0006,$00dff002
000286e8 66f6                     bne.b #$f6 == $000286e0 (T)
000286ea 33fc 0100 00df f040      move.w #$0100,$00dff040
000286f2 33fc 0000 00df f042      move.w #$0000,$00dff042
000286fa 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
00028704 33fc 0000 00df f066      move.w #$0000,$00dff066
;------------------------------------------------------------------------------
>d
0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
00028714 0839 0002 00df f016      btst.b #$0002,$00dff016
0002871c 66a6                     bne.b #$a6 == $000286c4 (T)
0002871e 4eae fe32                jsr (a6,-$01ce) == $00c02728
00028722 224e                     movea.l a6,a1
00028724 2c78 0004                movea.l $0004 [00c00276],a6
00028728 4eae fe62                jsr (a6,-$019e) == $00c02758
0002872c 4eae ff82                jsr (a6,-$007e) == $00c02878
00028730 4e75                     rts  == $00c4f6d8
00028732 0000 1234                or.b #$34,d0
>f 2870c
Breakpoint added.
>x

;------------------------------------------------------------------------------
Breakpoint 0 triggered.
Cycles: 50935 Chip, 101870 CPU. (V=105 H=10 -> V=16 H=97)
  D0 00001000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000050
0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 00028714
;------------------------------------------------------------------------------
>d pc
0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
00028714 0839 0002 00df f016      btst.b #$0002,$00dff016
0002871c 66a6                     bne.b #$a6 == $000286c4 (F)
0002871e 4eae fe32                jsr (a6,-$01ce) == $00c02728
00028722 224e                     movea.l a6,a1
00028724 2c78 0004                movea.l $0004 [00c00276],a6
00028728 4eae fe62                jsr (a6,-$019e) == $00c02758
0002872c 4eae ff82                jsr (a6,-$007e) == $00c02878
00028730 4e75                     rts  == $00c4f6d8
00028732 0000 1234                or.b #$34,d0
>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 123 Chip, 246 CPU. (V=16 H=97 -> V=16 H=220)
  D0 00001000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000050
0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 00028714
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 70928 Chip, 141856 CPU. (V=16 H=220 -> V=16 H=97)
  D0 00001000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000050
0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 00028714
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 123 Chip, 246 CPU. (V=16 H=97 -> V=16 H=220)
  D0 00001000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000050
0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 00028714
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 70928 Chip, 141856 CPU. (V=16 H=220 -> V=16 H=97)
  D0 00001000   D1 00010540   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C028F6   A1 00010540   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00C028F6   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 0050 (OR) Chip latch 00000050
0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
Next PC: 00028714
;------------------------------------------------------------------------------
>fl
0: PC == 0002870c [00000000 00000000]
;------------------------------------------------------------------------------
>H10
 0 000286d0 0c80 0000 1000           cmp.l #$00001000,d0
 - 12 CPU-RW     1000 000286D4
 - 14 CPU-RW     66EC 000286D6
 - 16 CPU-RW     0839 000286D8
 0 000286d6 66ec                     bne.b #$ec == $000286c4 (F)
 - 1B CPU-RW     0006 000286DA
 0 000286d8 0839 0006 00df f002      btst.b #$0006,$00dff002
 - 1D CPU-RW     00DF 000286DC
 - 1F CPU-RW     F002 000286DE
 - 21 CPU-RW     0839 000286E0
 - 23 CPU-RB     0023 00DFF002
 - 25 CPU-RW     0006 000286E2
 0 000286e0 0839 0006 00df f002      btst.b #$0006,$00dff002
 - 27 CPU-RW     00DF 000286E4
 - 29 CPU-RW     F002 000286E6
 - 2B CPU-RW     66F6 000286E8
 - 2D CPU-RB     0023 00DFF002
 - 2F CPU-RW     33FC 000286EA
 0 000286e8 66f6                     bne.b #$f6 == $000286e0 (F)
 - 33 CPU-RW     0100 000286EC
 0 000286ea 33fc 0100 00df f040      move.w #$0100,$00dff040
 - 35 CPU-RW     00DF 000286EE
 - 37 CPU-RW     F040 000286F0
 - 39 CPU-RW     33FC 000286F2
 - 3B CPU-WW     0100 00DFF040
 - 3C          0
 - 3D CPU-RW     0000 000286F4
 0 000286f2 33fc 0000 00df f042      move.w #$0000,$00dff042
 - 3F CPU-RW     00DF 000286F6
 - 41 CPU-RW     F042 000286F8
 - 43 CPU-RW     23FC 000286FA
 - 45 CPU-WW     0000 00DFF042
 - 47 CPU-RW     0001 000286FC
 0 000286fa 23fc 0001 0508 00df f054 move.l #$00010508,$00dff054
 - 49 CPU-RW     0508 000286FE
 - 4B CPU-RW     00DF 00028700
 - 4D CPU-RW     F054 00028702
 - 4F CPU-RW     33FC 00028704
 - 51 CPU-WW     0001 00DFF054
 - 53 CPU-WW     0508 00DFF056
 - 55 CPU-RW     0000 00028706
 0 00028704 33fc 0000 00df f066      move.w #$0000,$00dff066
 - 57 CPU-RW     00DF 00028708
 - 59 CPU-RW     F066 0002870A
 - 5B CPU-RW     33FC 0002870C
 - 5D CPU-WW     0000 00DFF066
 - 5F CPU-RW     0050 0002870E
 0 0002870c 33fc 0050 00df f058      move.w #$0050,$00dff058
>


