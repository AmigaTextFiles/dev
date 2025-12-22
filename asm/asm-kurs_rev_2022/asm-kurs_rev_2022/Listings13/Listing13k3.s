
; Listing13k3.s
; Reinigen mit Blitter und CPU gleichzeitig
; Zeile 2246

	SECTION CiriCop,CODE


Anfang:
	move.l	4.w,a6					; Execbase
	jsr	-$78(a6)					; Disable
	lea	GfxName(PC),a1				; Libname
	jsr	-$198(a6)					; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop			; speichern die alte COP

	MOVE.L	#BITPLANE,d0			; Bitplanepointer
	LEA	BPLPOINTERS,A1				; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	
	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106
	
mainloop: 
	move.l $dff004,d1
	and.l #$000fff00,d1
	cmp.l #$00010100,d1				; auf Ende des-Rasterdurchlaufs warten
	bne.s	mainloop
	
	;btst	#2,$dff016				; rechte Maustaste gedrückt?
	;bne.s	mouse					; wenn nicht, clearscreen überspringen	
	
	move.w #$F00,$dff180
	bsr clearscreen
	move.w #$05a,$dff180

mouse:
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mainloop


	move.l	OldCop(PC),$dff080		; Pointen auf die SystemCOP
	move.w	d0,$dff088				; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)					; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)					; Closelibrary
	rts					


clearscreen:
	lea	$dff000,a6
	;bra clear68k					; nur mit der CPU den Bildschirm reinigen
;------------------------------------------------------------------------------
	
Clear_Blit:							; mit Blitter reinigen 
	btst	#6,2(a6)
WaitBlit:
	btst	#6,2(a6)
	bne.s	WaitBlit
	move.l	#$01000000,$dff040		; BLTCON0: nur Ziel D ist aktiviert				
									; die MINTERMS (dh die Bits 0-7) sind alle
									; zurückgesetzt. Auf diese Weise ist die 
									; Löschoperation definiert	
	move.l	#BITPLANE,$dff054		; BLTDPT: Adresse des Zielkanals
	move.w	#$0000,$dff066			; BLTDMOD: Wir werden dieses Register später erklären
	move.w	#(128*64)+20,$dff058	; BLTSIZE: definiert die Dimension des
									; 320*256 --> die Hälfte 320x128	
    ;bra weiter						; mit CPU reinigen überspringen

Clear68k:
	movem.l	d0-d7/a0-a6,-(sp)		; alle Register speichern								; 128 Zyklen
	move.l	a7,SalvaStack			; wir speichern den Stack in einem Label				; 20 Zyklen
	movem.l	CLREG(PC),d0-d7/a0-a6	; Wir setzen alle Register mit nur						; 136 Zyklen
									; einem Movem aus einem Puffer von Nullen zurück.	
								
	lea	BITPLANEEND,a7				; Adresse der zu löschenden Zone
			
	rept 86							
	;rept	85						; wiederholen 85 movem... reichen nicht
	movem.l	d0-d7/a0-a6,-(a7)		; Wir setzen "rückwärts" zurück 60 bytes.				; 128 Zyklen
	endr
	move.l	SalvaStack(PC),a7		; den Stack wieder in SP setzen							; 16 Zyklen
	movem.l	(sp)+,d0-d7/a0-a6		; Wert der Register zurücksetzen						; 132 Zyklen
weiter:
;-------------------------------;	
	btst	#6,2(a6)
WaitBlit2:
	btst	#6,2(a6)
	bne.s	WaitBlit2
;-------------------------------;	
	rts


; 15 Longs gelöscht, um in die Register geladen zu werden, um sie zu löschen
CLREG:
	dcb.l	15,0

SalvaStack:
	dc.l	0

;	Daten
GfxName:
	dc.b	"graphics.library",0,0
GfxBase:
	dc.l	0
OldCop:
	dc.l	0


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

screen:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

			    ; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres
	
BPLPOINTERS:
	dc.w	$e0,0,$e2,0	; erste Bitplane

BITPLANE:
	blk.b 10240,$FF		; für 320x256		$FF für Vollbild
BITPLANEEND:

	end
	
Zeilen: im Programm auskommentieren für DMA-Debugger
	;btst	#2,$dff016				; rechte Maustaste gedrückt?
	;bne.s	mouse					; wenn nicht, clearscreen überspringen	

																				; F12 - GUI/Chipset
																				; cycle-exact must be activated	
;------------------------------------------------------------------------------
r
Filename: Listing13k3.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
>v -4
DMA debugger enabled, mode=4.
>x
;------------------------------------------------------------------------------
>v $102 0
Line: 102 258 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
 BLT-D 00    CPU-RW  BLT-D 00  RFS0 03C    CPU-RW  RFS1 1FE  BLT-D 00  RFS2 1FE
     0000  B   4FF9      0000        *=  B   0000        *F      0000
 0006A58C  00022F9C  0006A58E            00023112            0006A590
 395DAA00  395DAC00  395DAE00  395DB000  395DB200  395DB400  395DB600  395DB800

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
   CPU-RW  RFS3 1FE  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
 B   0000                0000  B   0000      0000  B   0000      0000  B   0000
 00023114            0006A592  00023116  0006A594  00023118  0006A596  0002311A
 395DBA00  395DBC00  395DBE00  395DC000  395DC200  395DC400  395DC600  395DC800

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
     0000  B   0000      0000  B   0000      0000  B   0000      0000  B   0000
 0006A598  0002311C  0006A59A  0002311E  0006A59C  00023120  0006A59E  00023122		
 395DCA00  395DCC00  395DCE00  395DD000  395DD200  395DD400  395DD600  395DD800	

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW 
     0000  B   0000      0000  B   0000      0000  B   0000      0000  B   0000
 0006A5A0  00023124  0006A5A2  00023126  0006A5A4  00023128  0006A5A6  0002312A
 395DDA00  395DDC00  395DDE00  395DE000  395DE200  395DE400  395DE600  395DE800

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
     0000  B   0000      0000  B   0000  (   0000  B   0000      0000  B   0000
 0006A5A8  0002312C  0006A5AA  0002312E  0006A5AC  00023130  0006A5AE  00023132
 395DEA00  395DEC00  395DEE00  395DF000  395DF200  395DF400  395DF600  395DF800

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
     0000  B   0000      0000  B   0000      0000  B   0000      0000  B   0000
 0006A5B0  00023134  0006A5B2  00023136  0006A5B4  00023138  0006A5B6  0002313A
 395DFA00  395DFC00  395DFE00  395E0000  395E0200  395E0400  395E0600  395E0800

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
     0000  B   0000      0000  B   0000      0000  B   0000      0000  B   0000
 0006A5B8  0002313C  0006A5BA  0002313E  0006A5BC  00023140  0006A5BE  00023142
 395E0A00  395E0C00  395E0E00  395E1000  395E1200  395E1400  395E1600  395E1800

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
 0   0000  B   0000      0000  B   0000      0000  B   0000      0000  B   0000
 0006A5C0  00023144  0006A5C2  00023146  0006A5C4  00023148  0006A5C6  0002314A
 395E1A00  395E1C00  395E1E00  395E2000  395E2200  395E2400  395E2600  395E2800

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
 BLT-D 00    CPU-RW  BLT-D 00  BPL1 110    CPU-RW  BLT-D 00    CPU-RW  BLT-D 00
     0000  B   0000      0000      0000  B   00C5      0000  B   0006      0000
 0006A5C8  0002314C  0006A5CA  0006C6B4  0002314E  0006A5CC  00022F9E  0006A5CE
 395E2A00  395E2C00  395E2E00  395E3000  395E3200  395E3400  395E3600  395E3800

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-RW  BLT-D 00    CPU-RW  BPL1 110  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
 B   CD44      0000  B   48E7      0000      0000  B   FFFE      0000  B   48E7
 00022FA0  0006A5D0  00022FA2  0006C6B6  0006A5D2  00022FA4  0006A5D4  00022FA6
 395E3A00  395E3C00  395E3E00  395E4000  395E4200  395E4400  395E4600  395E4800


>v $102 $48
Line: 102 258 HPOS 48  72:
 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-RW  BLT-D 00    CPU-RW  BPL1 110  BLT-D 00    CPU-RW  BLT-D 00    CPU-RW
 B   CD44      0000  B   48E7      0000      0000  B   FFFE      0000  B   48E7
 00022FA0  0006A5D0  00022FA2  0006C6B6  0006A5D2  00022FA4  0006A5D4  00022FA6
 395E3A00  395E3C00  395E3E00  395E4000  395E4200  395E4400  395E4600  395E4800

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
 BLT-D 00    CPU-WW  BLT-D 00  BPL1 110    CPU-WW  BLT-D 00    CPU-WW  BLT-D 00
     0000  B   0000      0000      0000  B   0000      0000  B   0000      0000
 0006A5D6  0006CD42  0006A5D8  0006C6B8  0006CD40  0006A5DA  0006CD3E  0006A5DC
 395E4A00  395E4C00  395E4E00  395E5000  395E5200  395E5400  395E5600  395E5800

 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
   CPU-WW  BLT-D 00    CPU-WW  BPL1 110  BLT-D 00    CPU-WW  BLT-D 00    CPU-WW
 B   0000      0000  B   0000      0000      0000  B   0000      0000  B   0000
 0006CD3C  0006A5DE  0006CD3A  0006C6BA  0006A5E0  0006CD38  0006A5E2  0006CD36
 395E5A00  395E5C00  395E5E00  395E6000  395E6200  395E6400  395E6600  395E6800

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
 BLT-D 00    CPU-WW  BLT-D 00  BPL1 110    CPU-WW  BLT-D 00    CPU-WW  BLT-D 00
     0000  B   0000      0000      0000  B   0000      0000  B   0000      0000
 0006A5E4  0006CD34  0006A5E6  0006C6BC  0006CD32  0006A5E8  0006CD30  0006A5EA
 395E6A00  395E6C00  395E6E00  395E7000  395E7200  395E7400  395E7600  395E7800

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]
   CPU-WW  BLT-D 00    CPU-WW  BPL1 110  BLT-D 00    CPU-WW  BLT-D 00    CPU-WW
 B   0000      0000  B   0000      0000      0000  B   0000      0000  B   0000
 0006CD2E  0006A5EC  0006CD2C  0006C6BE  0006A5EE  0006CD2A  0006A5F0  0006CD28
 395E7A00  395E7C00  395E7E00  395E8000  395E8200  395E8400  395E8600  395E8800

 [70 112]  [71 113]  [72 114]  [73 115]  [74 116]  [75 117]  [76 118]  [77 119]
 BLT-D 00    CPU-WW  BLT-D 00  BPL1 110    CPU-WW  BLT-D 00    CPU-WW  BLT-D 00
     0000  B   0000      0000      0000  B)  0000      0000  B   0000      0000
 0006A5F2  0006CD26  0006A5F4  0006C6C0  0006CD24  0006A5F6  0006CD22  0006A5F8
 395E8A00  395E8C00  395E8E00  395E9000  395E9200  395E9400  395E9600  395E9800

 [78 120]  [79 121]  [7A 122]  [7B 123]  [7C 124]  [7D 125]  [7E 126]  [7F 127]
   CPU-WW  BLT-D 00    CPU-WW  BPL1 110  BLT-D 00    CPU-WW  BLT-D 00    CPU-WW		
 B   0000      0000  B   0000      0000      0000  B   0000      0000  B   0000		; BLT-D with increasing adresses
 0006CD20  0006A5FA  0006CD1E  0006C6C2  0006A5FC  0006CD1C  0006A5FE  0006CD1A		; 6A5FA, 6A5FC, 6A5FE
 395E9A00  395E9C00  395E9E00  395EA000  395EA200  395EA400  395EA600  395EA800

 [80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]
 BLT-D 00    CPU-WW  BLT-D 00  BPL1 110    CPU-WW  BLT-D 00    CPU-WW  BLT-D 00
     0000  B   0000      0000      0000  B   0000      0000  B   0000      0000		; CPU-WW with decreasing adresses
 0006A600  0006CD18  0006A602  0006C6C4  0006CD16  0006A604  0006CD14  0006A606		; 6CD18, 6CD16, 6CD14
 395EAA00  395EAC00  395EAE00  395EB000  395EB200  395EB400  395EB600  395EB800

 [88 136]  [89 137]  [8A 138]  [8B 139]  [8C 140]  [8D 141]  [8E 142]  [8F 143]
   CPU-WW  BLT-D 00    CPU-WW  BPL1 110  BLT-D 00    CPU-WW  BLT-D 00    CPU-WW
 B   0000      0000  B   0000      0000      0000  B   0000      0000  B   0000
 0006CD12  0006A608  0006CD10  0006C6C6  0006A60A  0006CD0E  0006A60C  0006CD0C
 395EBA00  395EBC00  395EBE00  395EC000  395EC200  395EC400  395EC600  395EC800

 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
 BLT-D 00    CPU-WW  BLT-D 00  BPL1 110    CPU-WW  BLT-D 00    CPU-RW  BLT-D 00
     0000  B   0000      0000      0000  B   0000      0000  B   FFFE      0000
 0006A60E  0006CD0A  0006A610  0006C6C8  0006CD08  0006A612  00022FA8  0006A614
 395ECA00  395ECC00  395ECE00  395ED000  395ED200  395ED400  395ED600  395ED800

>

