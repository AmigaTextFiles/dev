
; Listing11g2.s -  Verwendung der Coppereigenschaft,  einen "MOVE"
				; durchzuführen erfordert horizontal 8 Pixel.

	Section	coppuz,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:
	BSR.W	MAKE_IT				; copperlist vorbereiten

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper								
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
MOUSE:
	BTST	#$06,$BFE001		; Maus gedrückt?
	BNE.S	MOUSE
	RTS

*************************************************************************
* Diese Routine erstellt eine copperliste mit 52 COLOR0 Registern für	*
* eine Zeile, also, da jeder move in der copperliste 8 Pixel (lowres)	*
* der auszuführenden Zeit dauert, wird color0							*
* 52-mal HORIZONTAL in Schritten von 8 Pixeln geändert					*
*************************************************************************

;	  .:::::.
;	 ¦:::·:::¦
;	 |·     ·|
;	C| _   _ l)
;	/ _°(_)°_ \
;	\_\_____/_/
;	 l_`---'_!
;	  `-----'xCz


LINSTART	EQU	$8021fffe		; ändern von "$80", um in einer
								; anderen vertikalen Zeile zu starten.
LINUM		EQU	25*3			; Anzahl der zu erledigenden Zeilen.

MAKE_IT:
	lea	CopBuf,a1				; Adressraum in copperlist
	move.l	#LINSTART,d0		; erstes "wait"
	move.w	#LINUM-1,d1			; Anzahl der zu erledigenden Zeilen
	move.w	#$180,d3			; Word für Register color0 in copperlist
	move.l	#$01000000,d4		; Wert, der zum Wait zur nächsten Zeile
								; hinzugefügt werden soll.
colcon1:
	lea	cols(pc),a0				; Adresstabelle mit Farben in a0
	move.w	#52-1,d2			; 52 color pro Zeile	
	move.l	d0,(a1)+			; Setzen des WAIT in der copperlist
colcon2:
	move.w	d3,(a1)+			; Setzen des Registers COLOR0 ($180)
	move.w	(a0)+,(a1)+			; Setze den Wert von COLOR0 (aus der Tabelle)
	dbra	d2,colcon2			; Führe eine ganze Zeile aus
	add.l	d4,d0				; "WAIT" machen eine Zeile darunter (+$01000000)
	dbra	d1,colcon1			; Wiederholen Sie dies für die Anzahl
	rts							; der zu erledigenden Zeilen


; Tabelle mit den 52 Farben einer horizontalen Zeile.

cols:
	dc.w	$26F,$27E,$28D,$29C,$2AB,$2BA,$2C9,$2D8,$2E7,$2F6
	dc.w	$4E7,$6D8,$8C9,$ABA,$CAA,$D9A,$E8A,$F7A,$F6B,$F5C
	dc.w	$D6D,$B6E,$96F,$76F,$56F,$36F,$26F,$27E,$28D,$29C
	dc.w	$2AB,$2BA,$2C9,$2D8,$2E7,$2F6,$4E7,$6D8,$8C9,$ABA
	dc.w	$CAA,$D9A,$E8A,$F7A,$F6B,$F5C,$D6D,$B6E,$96F,$76F
	dc.w	$56F,$36F

*****************************************************************************

	section	coppa,data_C

COPLIST:
	DC.W	$100,$200			; BplCon0 - keine bitplanes
	DC.W	$180,$003			; Color0 - blau
CopBuf:
	dcb.w	(52*2)*LINUM+(2*linum),0	; Platz für die copperlist.
	DC.W	$180,$003			; Color0 - blau
	dc.w	$ffff,$fffe			; Ende copperlist

	END

In diesem Fall haben wir den Effekt "bunter" gemacht, nichts Besonderes.


52 Farben in einer horizontalen Zeile?
Der Aufmerksame wird festgestellt haben, dass hier etwas nicht stimmen kann:
In Wahrheit sind es 45 mögliche Farben (sichtbar).

cols:
	dc.w	$000,$000,$000,$000,$000,$2BA,$2C9,$2D8,$2E7,$2F6  ; $000 - schwarz
	dc.w	$4E7,$6D8,$8C9,$ABA,$CAA,$D9A,$E8A,$F7A,$F6B,$F5C
	dc.w	$D6D,$B6E,$96F,$76F,$56F,$36F,$26F,$27E,$28D,$29C
	dc.w	$2AB,$2BA,$2C9,$2D8,$2E7,$2F6,$4E7,$6D8,$8C9,$ABA
	dc.w	$CAA,$D9A,$E8A,$F7A,$F6B,$F5C,$D6D,$B6E,$000	   ; $000 - schwarz

Wenn das erste wait auf $8001fffe geändert wird und bei $80e3fffe endet wären
auf diese Weise maximal 56 Color0-Register Farbwertänderungen in einer
horizontalen Zeile möglich.

$e3=226 (226*2 in Pixeln=452 Pixel) 452 Pixel/8 Pixel pro move = 56 move

Wenn wir die 52 Color0-Register Farbwertänderungen betrachten, endet der
letzte move bei $80f1fffe was ausserhalb des Bereichs liegt. Die letzte
gültige horizontale Position ist $e2.

Das nächste wait wird also bei Erreichen von xxx bereits ausgeführt.

52 move * 8 Pixel/move = 416 Pixel (416/2=208 oder $d0)
Wenn der erste wait bei $8021fffe ist, dann wäre der letzte move bei $80f1fffe,
was ausserhalb des Bereichs liegt.


DMA-Debugger:


>v $80
Line: 80 128 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]



 30CE1400  30CE1600  30CE1800  30CE1A00  30CE1C00  30CE1E00  30CE2000  30CE2200

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]



 30CE2400  30CE2600  30CE2800  30CE2A00  30CE2C00  30CE2E00  30CE3000  30CE3200

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]



 30CE3400  30CE3600  30CE3800  30CE3A00  30CE3C00  30CE3E00  30CE4000  30CE4200

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]

                                                             W

 30CE4400  30CE4600  30CE4800  30CE4A00  30CE4C00  30CE4E00  30CE5000  30CE5200

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
 COP  08C            COP  180            COP  08C            COP  180
     0180                026F                0180                027E
 0006A4E4            0006A4E6            0006A4E8            0006A4EA
 30CE5400  30CE5600  30CE5800  30CE5A00  30CE5C00  30CE5E00  30CE6000  30CE6200

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
 COP  08C            COP  180            COP  08C            COP  180
     0180                028D                0180                029C
 0006A4EC            0006A4EE            0006A4F0            0006A4F2
 30CE6400  30CE6600  30CE6800  30CE6A00  30CE6C00  30CE6E00  30CE7000  30CE7200

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
 COP  08C            COP  180            COP  08C            COP  180
     0180                02AB                0180                02BA
 0006A4F4            0006A4F6            0006A4F8            0006A4FA
 30CE7400  30CE7600  30CE7800  30CE7A00  30CE7C00  30CE7E00  30CE8000  30CE8200

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  08C            COP  180            COP  08C            COP  180
     0180                02C9                0180                02D8
 0006A4FC            0006A4FE            0006A500            0006A502
 30CE8400  30CE8600  30CE8800  30CE8A00  30CE8C00  30CE8E00  30CE9000  30CE9200

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
 COP  08C            COP  180            COP  08C            COP  180
     0180                02E7                0180                02F6
 0006A504            0006A506            0006A508            0006A50A
 30CE9400  30CE9600  30CE9800  30CE9A00  30CE9C00  30CE9E00  30CEA000  30CEA200

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
 COP  08C            COP  180            COP  08C            COP  180
     0180                04E7                0180                06D8
 0006A50C            0006A50E            0006A510            0006A512
 30CEA400  30CEA600  30CEA800  30CEAA00  30CEAC00  30CEAE00  30CEB000  30CEB200

 [50  80]  [51  81]  [52  82]  [53  83]  [54  84]  [55  85]  [56  86]  [57  87]
 COP  08C            COP  180            COP  08C            COP  180
     0180                08C9                0180                0ABA
 0006A514            0006A516            0006A518            0006A51A
 30CEB400  30CEB600  30CEB800  30CEBA00  30CEBC00  30CEBE00  30CEC000  30CEC200

 [58  88]  [59  89]  [5A  90]  [5B  91]  [5C  92]  [5D  93]  [5E  94]  [5F  95]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0CAA                0180                0D9A
 0006A51C            0006A51E            0006A520            0006A522
 30CEC400  30CEC600  30CEC800  30CECA00  30CECC00  30CECE00  30CED000  30CED200

 [60  96]  [61  97]  [62  98]  [63  99]  [64 100]  [65 101]  [66 102]  [67 103]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0E8A                0180                0F7A
 0006A524            0006A526            0006A528            0006A52A
 30CED400  30CED600  30CED800  30CEDA00  30CEDC00  30CEDE00  30CEE000  30CEE200

 [68 104]  [69 105]  [6A 106]  [6B 107]  [6C 108]  [6D 109]  [6E 110]  [6F 111]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0F6B                0180                0F5C
 0006A52C            0006A52E            0006A530            0006A532
 30CEE400  30CEE600  30CEE800  30CEEA00  30CEEC00  30CEEE00  30CEF000  30CEF200

 [70 112]  [71 113]  [72 114]  [73 115]  [74 116]  [75 117]  [76 118]  [77 119]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0D6D                0180                0B6E
 0006A534            0006A536            0006A538            0006A53A
 30CEF400  30CEF600  30CEF800  30CEFA00  30CEFC00  30CEFE00  30CF0000  30CF0200

 [78 120]  [79 121]  [7A 122]  [7B 123]  [7C 124]  [7D 125]  [7E 126]  [7F 127]
 COP  08C            COP  180            COP  08C            COP  180
     0180                096F                0180                076F
 0006A53C            0006A53E            0006A540            0006A542
 30CF0400  30CF0600  30CF0800  30CF0A00  30CF0C00  30CF0E00  30CF1000  30CF1200

 [80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]
 COP  08C            COP  180            COP  08C            COP  180
     0180                056F                0180                036F
 0006A544            0006A546            0006A548            0006A54A
 30CF1400  30CF1600  30CF1800  30CF1A00  30CF1C00  30CF1E00  30CF2000  30CF2200

 [88 136]  [89 137]  [8A 138]  [8B 139]  [8C 140]  [8D 141]  [8E 142]  [8F 143]
 COP  08C            COP  180            COP  08C            COP  180
     0180                026F                0180                027E
 0006A54C            0006A54E            0006A550            0006A552
 30CF2400  30CF2600  30CF2800  30CF2A00  30CF2C00  30CF2E00  30CF3000  30CF3200

 [90 144]  [91 145]  [92 146]  [93 147]  [94 148]  [95 149]  [96 150]  [97 151]
 COP  08C            COP  180            COP  08C            COP  180
     0180                028D                0180                029C
 0006A554            0006A556            0006A558            0006A55A
 30CF3400  30CF3600  30CF3800  30CF3A00  30CF3C00  30CF3E00  30CF4000  30CF4200

 [98 152]  [99 153]  [9A 154]  [9B 155]  [9C 156]  [9D 157]  [9E 158]  [9F 159]
 COP  08C            COP  180            COP  08C            COP  180
     0180                02AB                0180                02BA
 0006A55C            0006A55E            0006A560            0006A562
 30CF4400  30CF4600  30CF4800  30CF4A00  30CF4C00  30CF4E00  30CF5000  30CF5200

 [A0 160]  [A1 161]  [A2 162]  [A3 163]  [A4 164]  [A5 165]  [A6 166]  [A7 167]
 COP  08C            COP  180            COP  08C            COP  180
     0180                02C9                0180                02D8
 0006A564            0006A566            0006A568            0006A56A
 30CF5400  30CF5600  30CF5800  30CF5A00  30CF5C00  30CF5E00  30CF6000  30CF6200

 [A8 168]  [A9 169]  [AA 170]  [AB 171]  [AC 172]  [AD 173]  [AE 174]  [AF 175]
 COP  08C            COP  180            COP  08C            COP  180
     0180                02E7                0180                02F6
 0006A56C            0006A56E            0006A570            0006A572
 30CF6400  30CF6600  30CF6800  30CF6A00  30CF6C00  30CF6E00  30CF7000  30CF7200

 [B0 176]  [B1 177]  [B2 178]  [B3 179]  [B4 180]  [B5 181]  [B6 182]  [B7 183]
 COP  08C            COP  180            COP  08C            COP  180
     0180                04E7                0180                06D8
 0006A574            0006A576            0006A578            0006A57A
 30CF7400  30CF7600  30CF7800  30CF7A00  30CF7C00  30CF7E00  30CF8000  30CF8200

 [B8 184]  [B9 185]  [BA 186]  [BB 187]  [BC 188]  [BD 189]  [BE 190]  [BF 191]
 COP  08C            COP  180            COP  08C            COP  180
     0180                08C9                0180                0ABA
 0006A57C            0006A57E            0006A580            0006A582
 30CF8400  30CF8600  30CF8800  30CF8A00  30CF8C00  30CF8E00  30CF9000  30CF9200

 [C0 192]  [C1 193]  [C2 194]  [C3 195]  [C4 196]  [C5 197]  [C6 198]  [C7 199]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0CAA                0180                0D9A
 0006A584            0006A586            0006A588            0006A58A
 30CF9400  30CF9600  30CF9800  30CF9A00  30CF9C00  30CF9E00  30CFA000  30CFA200

 [C8 200]  [C9 201]  [CA 202]  [CB 203]  [CC 204]  [CD 205]  [CE 206]  [CF 207]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0E8A                0180                0F7A
 0006A58C            0006A58E            0006A590            0006A592
 30CFA400  30CFA600  30CFA800  30CFAA00  30CFAC00  30CFAE00  30CFB000  30CFB200

 [D0 208]  [D1 209]  [D2 210]  [D3 211]  [D4 212]  [D5 213]  [D6 214]  [D7 215]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0F6B                0180                0F5C
 0006A594            0006A596            0006A598            0006A59A
 30CFB400  30CFB600  30CFB800  30CFBA00  30CFBC00  30CFBE00  30CFC000  30CFC200

 [D8 216]  [D9 217]  [DA 218]  [DB 219]  [DC 220]  [DD 221]  [DE 222]  [DF 223]
 COP  08C            COP  180            COP  08C            COP  180
     0180                0D6D                0180                0B6E
 0006A59C            0006A59E            0006A5A0            0006A5A2
 30CFC400  30CFC600  30CFC800  30CFCA00  30CFCC00  30CFCE00  30CFD000  30CFD200

 [E0 224]  [E1 225]  [E2 226]
 COP  1FE  COP  08C
 #   0180      0180
 0006A5A4  0006A5A4
 30CFD400  30CFD600  30CFD800


>v $81
Line: 81 129 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
 COP  180            COP  08C            COP  180            COP  08C
     096F                0180                076F                0180
 0006A5A6            0006A5A8            0006A5AA            0006A5AC
 30CFDA00  30CFDC00  30CFDE00  30CFE000  30CFE200  30CFE400  30CFE600  30CFE800

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
 COP  180            COP  08C            COP  180            COP  08C
     056F                0180                036F                8121
 0006A5AE            0006A5B0            0006A5B2            0006A5B4
 30CFEA00  30CFEC00  30CFEE00  30CFF000  30CFF200  30CFF400  30CFF600  30CFF800

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
 COP  08C
     FFFE
 0006A5B6
 30CFFA00  30CFFC00  30CFFE00  30D00000  30D00200  30D00400  30D00600  30D00800

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]

                                                             W

 30D00A00  30D00C00  30D00E00  30D01000  30D01200  30D01400  30D01600  30D01800

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
 COP  08C            COP  180            COP  08C            COP  180
     0180                026F                0180                027E
 0006A5B8            0006A5BA            0006A5BC            0006A5BE
 30D01A00  30D01C00  30D01E00  30D02000  30D02200  30D02400  30D02600  30D02800



   D0 CB21FFFE   D1 4000FFFF   D2 0000FFFF   D3 00000180
  D4 01000000   D5 00000000   D6 00000000   D7 00000000
  A0 00022D10   A1 0006E2FC   A2 00000000   A3 00000000
  A4 00BFE001   A5 00DFF000   A6 00C00276   A7 00C5FE94
USP  00C5FE94 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0006 (OR) 0839 (BTST) Chip latch 00000000
00022C68 0839 0006 00bf e001      BTST.B #$0006,$00bfe001
Next PC: 00022c70
>o1
*0006a4d8: 0100 0200            ;  BPLCON0 := 0x0200
 0006a4dc: 0180 0003            ;  COLOR00 := 0x0003
 0006a4e0: 8021 fffe            ;  Wait for vpos >= 0x80 and hpos >= 0x20
                                ;  VP 80, VE 7f; HP 20, HE fe; BFD 1
 0006a4e4: 0180 026f            ;  COLOR00 := 0x026f
 0006a4e8: 0180 027e            ;  COLOR00 := 0x027e
 0006a4ec: 0180 028d            ;  COLOR00 := 0x028d
 0006a4f0: 0180 029c            ;  COLOR00 := 0x029c
 0006a4f4: 0180 02ab            ;  COLOR00 := 0x02ab
 0006a4f8: 0180 02ba            ;  COLOR00 := 0x02ba
 0006a4fc: 0180 02c9            ;  COLOR00 := 0x02c9
 0006a500: 0180 02d8            ;  COLOR00 := 0x02d8
 0006a504: 0180 02e7            ;  COLOR00 := 0x02e7
 0006a508: 0180 02f6            ;  COLOR00 := 0x02f6
 0006a50c: 0180 04e7            ;  COLOR00 := 0x04e7
 0006a510: 0180 06d8            ;  COLOR00 := 0x06d8
 0006a514: 0180 08c9            ;  COLOR00 := 0x08c9
 0006a518: 0180 0aba            ;  COLOR00 := 0x0aba
 0006a51c: 0180 0caa            ;  COLOR00 := 0x0caa
 0006a520: 0180 0d9a            ;  COLOR00 := 0x0d9a
 0006a524: 0180 0e8a            ;  COLOR00 := 0x0e8a
>od
Copper debugger enabled.
>ot
Cycles: 16 Chip, 32 CPU. (V=0 H=4 -> V=0 H=20)
  D0 CB21FFFE   D1 4000FFFF   D2 0000FFFF   D3 00000180
  D4 01000000   D5 00000000   D6 00000000   D7 00000000
  A0 00022D10   A1 0006E2FC   A2 00000000   A3 00000000
  A4 00BFE001   A5 00DFF000   A6 00C00276   A7 00C5FE94
USP  00C5FE94 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 66f6 (Bcc) Chip latch 00000000
00022C70 66f6                     BNE.B #$f6 == $00022c68 (T)
Next PC: 00022c72
>o1
 0006a4d8: 0100 0200            ;  BPLCON0 := 0x0200
 0006a4dc: 0180 0003            ;  COLOR00 := 0x0003
 0006a4e0: 8021 fffe            ;  Wait for vpos >= 0x80 and hpos >= 0x20
                                ;  VP 80, VE 7f; HP 20, HE fe; BFD 1
*0006a4e4: 0180 026f            ;  COLOR00 := 0x026f
 0006a4e8: 0180 027e            ;  COLOR00 := 0x027e
 0006a4ec: 0180 028d            ;  COLOR00 := 0x028d
 0006a4f0: 0180 029c            ;  COLOR00 := 0x029c
 0006a4f4: 0180 02ab            ;  COLOR00 := 0x02ab
 0006a4f8: 0180 02ba            ;  COLOR00 := 0x02ba
 0006a4fc: 0180 02c9            ;  COLOR00 := 0x02c9
 0006a500: 0180 02d8            ;  COLOR00 := 0x02d8
 0006a504: 0180 02e7            ;  COLOR00 := 0x02e7
 0006a508: 0180 02f6            ;  COLOR00 := 0x02f6
 0006a50c: 0180 04e7            ;  COLOR00 := 0x04e7
 0006a510: 0180 06d8            ;  COLOR00 := 0x06d8
 0006a514: 0180 08c9            ;  COLOR00 := 0x08c9
 0006a518: 0180 0aba            ;  COLOR00 := 0x0aba
 0006a51c: 0180 0caa            ;  COLOR00 := 0x0caa
 0006a520: 0180 0d9a            ;  COLOR00 := 0x0d9a
 0006a524: 0180 0e8a            ;  COLOR00 := 0x0e8a
>ot
Cycles: 29080 Chip, 58160 CPU. (V=0 H=20 -> V=128 H=44)
  D0 CB21FFFE   D1 4000FFFF   D2 0000FFFF   D3 00000180
  D4 01000000   D5 00000000   D6 00000000   D7 00000000
  A0 00022D10   A1 0006E2FC   A2 00000000   A3 00000000
  A4 00BFE001   A5 00DFF000   A6 00C00276   A7 00C5FE94
USP  00C5FE94 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 66f6 (Bcc) Chip latch 00000000
00022C70 66f6                     BNE.B #$f6 == $00022c68 (T)
Next PC: 00022c72
>o1
 0006a4d8: 0100 0200            ;  BPLCON0 := 0x0200
 0006a4dc: 0180 0003            ;  COLOR00 := 0x0003
 0006a4e0: 8021 fffe            ;  Wait for vpos >= 0x80 and hpos >= 0x20
                                ;  VP 80, VE 7f; HP 20, HE fe; BFD 1
 0006a4e4: 0180 026f            ;  COLOR00 := 0x026f
 0006a4e8: 0180 027e            ;  COLOR00 := 0x027e
 0006a4ec: 0180 028d            ;  COLOR00 := 0x028d
*0006a4f0: 0180 029c            ;  COLOR00 := 0x029c
 0006a4f4: 0180 02ab            ;  COLOR00 := 0x02ab
 0006a4f8: 0180 02ba            ;  COLOR00 := 0x02ba
 0006a4fc: 0180 02c9            ;  COLOR00 := 0x02c9
 0006a500: 0180 02d8            ;  COLOR00 := 0x02d8
 0006a504: 0180 02e7            ;  COLOR00 := 0x02e7
 0006a508: 0180 02f6            ;  COLOR00 := 0x02f6
 0006a50c: 0180 04e7            ;  COLOR00 := 0x04e7
 0006a510: 0180 06d8            ;  COLOR00 := 0x06d8
 0006a514: 0180 08c9            ;  COLOR00 := 0x08c9
 0006a518: 0180 0aba            ;  COLOR00 := 0x0aba
 0006a51c: 0180 0caa            ;  COLOR00 := 0x0caa
 0006a520: 0180 0d9a            ;  COLOR00 := 0x0d9a
 0006a524: 0180 0e8a            ;  COLOR00 := 0x0e8a
>ot
Cycles: 5 Chip, 10 CPU. (V=128 H=44 -> V=128 H=49)
  D0 CB21FFFE   D1 4000FFFF   D2 0000FFFF   D3 00000180
  D4 01000000   D5 00000000   D6 00000000   D7 00000000
  A0 00022D10   A1 0006E2FC   A2 00000000   A3 00000000
  A4 00BFE001   A5 00DFF000   A6 00C00276   A7 00C5FE94
USP  00C5FE94 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0006 (OR) 0839 (BTST) Chip latch 00000000
00022C68 0839 0006 00bf e001      BTST.B #$0006,$00bfe001
Next PC: 00022c70
>o1
 0006a4d8: 0100 0200            ;  BPLCON0 := 0x0200
 0006a4dc: 0180 0003            ;  COLOR00 := 0x0003
 0006a4e0: 8021 fffe            ;  Wait for vpos >= 0x80 and hpos >= 0x20
                                ;  VP 80, VE 7f; HP 20, HE fe; BFD 1
 0006a4e4: 0180 026f            ;  COLOR00 := 0x026f
 0006a4e8: 0180 027e            ;  COLOR00 := 0x027e
 0006a4ec: 0180 028d            ;  COLOR00 := 0x028d
 0006a4f0: 0180 029c            ;  COLOR00 := 0x029c
*0006a4f4: 0180 02ab            ;  COLOR00 := 0x02ab
 0006a4f8: 0180 02ba            ;  COLOR00 := 0x02ba
 0006a4fc: 0180 02c9            ;  COLOR00 := 0x02c9
 0006a500: 0180 02d8            ;  COLOR00 := 0x02d8
 0006a504: 0180 02e7            ;  COLOR00 := 0x02e7
 0006a508: 0180 02f6            ;  COLOR00 := 0x02f6
 0006a50c: 0180 04e7            ;  COLOR00 := 0x04e7
 0006a510: 0180 06d8            ;  COLOR00 := 0x06d8
 0006a514: 0180 08c9            ;  COLOR00 := 0x08c9
 0006a518: 0180 0aba            ;  COLOR00 := 0x0aba
 0006a51c: 0180 0caa            ;  COLOR00 := 0x0caa
 0006a520: 0180 0d9a            ;  COLOR00 := 0x0d9a
 0006a524: 0180 0e8a            ;  COLOR00 := 0x0e8a
>ot
Cycles: 15 Chip, 30 CPU. (V=128 H=49 -> V=128 H=64)
  D0 CB21FFFE   D1 4000FFFF   D2 0000FFFF   D3 00000180
  D4 01000000   D5 00000000   D6 00000000   D7 00000000
  A0 00022D10   A1 0006E2FC   A2 00000000   A3 00000000
  A4 00BFE001   A5 00DFF000   A6 00C00276   A7 00C5FE94
USP  00C5FE94 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 66f6 (Bcc) Chip latch 00000000
00022C70 66f6                     BNE.B #$f6 == $00022c68 (T)
Next PC: 00022c72
>o1
 0006a4d8: 0100 0200            ;  BPLCON0 := 0x0200
 0006a4dc: 0180 0003            ;  COLOR00 := 0x0003
 0006a4e0: 8021 fffe            ;  Wait for vpos >= 0x80 and hpos >= 0x20
                                ;  VP 80, VE 7f; HP 20, HE fe; BFD 1
 0006a4e4: 0180 026f            ;  COLOR00 := 0x026f
 0006a4e8: 0180 027e            ;  COLOR00 := 0x027e
 0006a4ec: 0180 028d            ;  COLOR00 := 0x028d
 0006a4f0: 0180 029c            ;  COLOR00 := 0x029c
 0006a4f4: 0180 02ab            ;  COLOR00 := 0x02ab
 0006a4f8: 0180 02ba            ;  COLOR00 := 0x02ba
 0006a4fc: 0180 02c9            ;  COLOR00 := 0x02c9
 0006a500: 0180 02d8            ;  COLOR00 := 0x02d8
*0006a504: 0180 02e7            ;  COLOR00 := 0x02e7
 0006a508: 0180 02f6            ;  COLOR00 := 0x02f6
 0006a50c: 0180 04e7            ;  COLOR00 := 0x04e7
 0006a510: 0180 06d8            ;  COLOR00 := 0x06d8
 0006a514: 0180 08c9            ;  COLOR00 := 0x08c9
 0006a518: 0180 0aba            ;  COLOR00 := 0x0aba
 0006a51c: 0180 0caa            ;  COLOR00 := 0x0caa
 0006a520: 0180 0d9a            ;  COLOR00 := 0x0d9a
 0006a524: 0180 0e8a            ;  COLOR00 := 0x0e8a
>ot
Cycles: 5 Chip, 10 CPU. (V=128 H=64 -> V=128 H=69)
  D0 CB21FFFE   D1 4000FFFF   D2 0000FFFF   D3 00000180
  D4 01000000   D5 00000000   D6 00000000   D7 00000000
  A0 00022D10   A1 0006E2FC   A2 00000000   A3 00000000
  A4 00BFE001   A5 00DFF000   A6 00C00276   A7 00C5FE94
USP  00C5FE94 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0006 (OR) 0839 (BTST) Chip latch 00000000
00022C68 0839 0006 00bf e001      BTST.B #$0006,$00bfe001
Next PC: 00022c70
>o1
 0006a4d8: 0100 0200            ;  BPLCON0 := 0x0200
 0006a4dc: 0180 0003            ;  COLOR00 := 0x0003
 0006a4e0: 8021 fffe            ;  Wait for vpos >= 0x80 and hpos >= 0x20
                                ;  VP 80, VE 7f; HP 20, HE fe; BFD 1
 0006a4e4: 0180 026f            ;  COLOR00 := 0x026f
 0006a4e8: 0180 027e            ;  COLOR00 := 0x027e
 0006a4ec: 0180 028d            ;  COLOR00 := 0x028d
 0006a4f0: 0180 029c            ;  COLOR00 := 0x029c
 0006a4f4: 0180 02ab            ;  COLOR00 := 0x02ab
 0006a4f8: 0180 02ba            ;  COLOR00 := 0x02ba
 0006a4fc: 0180 02c9            ;  COLOR00 := 0x02c9
 0006a500: 0180 02d8            ;  COLOR00 := 0x02d8
 0006a504: 0180 02e7            ;  COLOR00 := 0x02e7
*0006a508: 0180 02f6            ;  COLOR00 := 0x02f6
 0006a50c: 0180 04e7            ;  COLOR00 := 0x04e7
 0006a510: 0180 06d8            ;  COLOR00 := 0x06d8
 0006a514: 0180 08c9            ;  COLOR00 := 0x08c9
 0006a518: 0180 0aba            ;  COLOR00 := 0x0aba
 0006a51c: 0180 0caa            ;  COLOR00 := 0x0caa
 0006a520: 0180 0d9a            ;  COLOR00 := 0x0d9a
 0006a524: 0180 0e8a            ;  COLOR00 := 0x0e8a
>ot
Cycles: 15 Chip, 30 CPU. (V=128 H=69 -> V=128 H=84)
  D0 CB21FFFE   D1 4000FFFF   D2 0000FFFF   D3 00000180
  D4 01000000   D5 00000000   D6 00000000   D7 00000000
  A0 00022D10   A1 0006E2FC   A2 00000000   A3 00000000
  A4 00BFE001   A5 00DFF000   A6 00C00276   A7 00C5FE94
USP  00C5FE94 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 66f6 (Bcc) Chip latch 00000000
00022C70 66f6                     BNE.B #$f6 == $00022c68 (T)
Next PC: 00022c72
>o1
 0006a4d8: 0100 0200            ;  BPLCON0 := 0x0200
 0006a4dc: 0180 0003            ;  COLOR00 := 0x0003
 0006a4e0: 8021 fffe            ;  Wait for vpos >= 0x80 and hpos >= 0x20
                                ;  VP 80, VE 7f; HP 20, HE fe; BFD 1
 0006a4e4: 0180 026f            ;  COLOR00 := 0x026f
 0006a4e8: 0180 027e            ;  COLOR00 := 0x027e
 0006a4ec: 0180 028d            ;  COLOR00 := 0x028d
 0006a4f0: 0180 029c            ;  COLOR00 := 0x029c
 0006a4f4: 0180 02ab            ;  COLOR00 := 0x02ab
 0006a4f8: 0180 02ba            ;  COLOR00 := 0x02ba
 0006a4fc: 0180 02c9            ;  COLOR00 := 0x02c9
 0006a500: 0180 02d8            ;  COLOR00 := 0x02d8
 0006a504: 0180 02e7            ;  COLOR00 := 0x02e7
 0006a508: 0180 02f6            ;  COLOR00 := 0x02f6
 0006a50c: 0180 04e7            ;  COLOR00 := 0x04e7
 0006a510: 0180 06d8            ;  COLOR00 := 0x06d8
 0006a514: 0180 08c9            ;  COLOR00 := 0x08c9
*0006a518: 0180 0aba            ;  COLOR00 := 0x0aba
 0006a51c: 0180 0caa            ;  COLOR00 := 0x0caa
 0006a520: 0180 0d9a            ;  COLOR00 := 0x0d9a
 0006a524: 0180 0e8a            ;  COLOR00 := 0x0e8a
>