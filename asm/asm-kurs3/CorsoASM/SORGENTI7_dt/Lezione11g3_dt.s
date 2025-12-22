
; Lezione11g3.s -  Verwendung der Coppereigenschaft,  einen "MOVE"
				; durchzuführen erfordert horizontal 8 Pixel.

	Section	coppuz,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

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
* eine Zeile, also, da jeder Zug in der copperliste 8 Pixel (lowres)	*
* der auszuführenden Zeit dauert, wird color0							*
* 52-mal HORIZONTAL in Schritten von 8 Pixeln geändert					*
*************************************************************************

;	  .:::::.
;	 ¦:::·:::¦
;	 |· _ - ·|
;	C|  o °  l)
;	 ¡_ (_) _|
;	 |\_____/|
;	 l_l±±±|_!
;	  `-----'xCz

LINSTART	EQU	$8021fffe	; ändern von "$80", um in einer
							; anderen vertikalen Zeile zu starten.
LINUM		EQU	80			; Anzahl der zu erledigenden Zeilen.

MAKE_IT:
	lea	cols(pc),a0			; Adresstabelle mit Farben in a0
	lea	CopBuf,a1			; Adressraum in copperlist
	move.l	#LINSTART,d0	; erstes "wait"
	move.w	#LINUM-1,d1		; Anzahl der zu erledigenden Zeilen
	move.w	#$180,d3		; Word für Register color0 in coplist
	move.l	#$01000000,d4	; Wert, der zum Wait zur nächsten Zeile
							; hinzugefügt werden soll.
	moveq	#9,d6			; und stelle den Zähler auf 9
colcon1:
	move.w	#52-1,d2		; 52 color pro Zeile
	move.l	d0,(a1)+		; Setzen des WAIT in der copperlist
colcon2:
	move.w	d3,(a1)+		; Setzen des Registers COLOR0 ($180)
	move.w	(a0)+,(a1)+		; Setze den Wert von COLOR0 (aus der Tabelle)
	dbra	d2,colcon2		; Führen Sie eine ganze Zeile aus
	add.l	d4,d0			; Machen Sie die Zeile "Wait" unten (+$01000000)
	subq.b	#1,d6			; markiert, dass wir eine Zeile gemacht haben
	bne.s	NonRipartire	; Wenn wir 9 gemacht haben, ist d6 = 0, dann ist es notwendig
							; Starten Sie ab der ersten Farbe in der Tabelle neu.
	lea	cols(pc),a0			; Tab Farben in a0 - mit Farben teilen.
	moveq	#9,d6			; und stelle den Zähler auf 9
NonRipartire:
	dbra	d1,colcon1	; Wiederholen Sie dies für die Anzahl der zu erledigenden Zeilen
	rts


;	Tabelle mit 52 * 9 Farben einer horizontalen Linie.

cols:
	dc.w	$26F,$27E,$28D,$29C,$2AB,$2BA,$2C9,$2D8,$2E7,$2F6
	dc.w	$4E7,$6D8,$8C9,$ABA,$CAA,$D9A,$E8A,$F7A,$F6C,$F5C
	dc.w	$D6D,$B6E,$96F,$76F,$56F,$36F,$26F,$27E,$28D,$29C
	dc.w	$2AB,$2BA,$2C9,$2D8,$2E7,$2F6,$4E7,$6D8,$8C9,$ABA
	dc.w	$CAA,$D9A,$E8A,$F7A,$F6B,$F5C,$D6D,$B6E,$96F,$76F
	dc.w	$56F,$36F,$36F,$37E,$38D,$39C,$3AB,$3BA,$3C9,$3D8
	dc.w	$3E7,$3F6,$4E7,$7D8,$9C9,$BBA,$DAA,$E9A,$F8A,$F7A
	dc.w	$F6C,$F5C,$E6D,$C6E,$A6F,$86F,$66F,$46F,$36F,$37E
	dc.w	$38D,$39C,$3AB,$3BA,$3C9,$3D8,$3E7,$3F6,$5E7,$7D8
	dc.w	$9C9,$BBA,$DAA,$E9A,$F8A,$F7A,$F6B,$F5C,$E6D,$C6E
	dc.w	$A6F,$86F,$46F,$46F,$36E,$37D,$38C,$39B,$3AA,$3B9
	dc.w	$3C8,$3D7,$3E6,$3F5,$4E6,$7D7,$9C8,$BB9,$DA9,$E99
	dc.w	$F89,$F79,$F6B,$F5B,$E6C,$C6D,$A6E,$86E,$66E,$46E
	dc.w	$36E,$37D,$38C,$39B,$3AA,$3B9,$3C8,$3D7,$3E6,$3F5
	dc.w	$5E6,$7D7,$9C8,$BB9,$DA9,$E99,$F89,$F79,$F6A,$F5B
	dc.w	$E6C,$C6E,$A6E,$86E,$46E,$46E,$46E,$47D,$48C,$49B
	dc.w	$4AA,$4B9,$4C8,$4D7,$4E6,$4F5,$5E6,$8D7,$AC8,$CB9
	dc.w	$EA9,$F99,$F89,$F79,$F6B,$F5B,$F6C,$D6D,$B6E,$96E
	dc.w	$76E,$56E,$46E,$47D,$48C,$49B,$4AA,$4B9,$4C8,$4D7
	dc.w	$4E6,$4F5,$6E6,$8D7,$AC8,$CB9,$EA9,$F99,$F89,$F79
	dc.w	$F6A,$F5B,$F6C,$D6E,$B6E,$96E,$56E,$56E,$45E,$46D
	dc.w	$47C,$48B,$49A,$4A9,$4B8,$4C7,$4D6,$4E5,$5D6,$8C7
	dc.w	$AB8,$CA9,$E99,$F89,$F79,$F69,$F5B,$F4B,$F5C,$D5D
	dc.w	$B5E,$95E,$75E,$55E,$45E,$46D,$47C,$48B,$49A,$4A9
	dc.w	$4B8,$4C7,$4D6,$4E5,$6D6,$8C7,$AB8,$CA9,$E99,$F89
	dc.w	$F79,$F69,$F5A,$F4B,$F5C,$D5E,$B5E,$95E,$55E,$55E
	dc.w	$44D,$45C,$46B,$47A,$489,$498,$4A7,$4B6,$4C5,$4D4
	dc.w	$5C5,$8B6,$AA7,$C98,$E88,$F78,$F68,$F68,$F59,$F4A
	dc.w	$F4B,$D4C,$B4D,$94D,$74D,$54D,$44D,$45C,$46B,$47A
	dc.w	$489,$498,$4A7,$4B6,$4C5,$4D4,$6C5,$8B6,$AA7,$C98
	dc.w	$E88,$F78,$F68,$F58,$F49,$F3A,$F4B,$D4D,$B4D,$94D
	dc.w	$54D,$54D,$44C,$45B,$46A,$479,$488,$499,$4A6,$4B5
	dc.w	$4C4,$4D3,$5C4,$8B5,$AA6,$C97,$E87,$F77,$F67,$F67
	dc.w	$F58,$F49,$F4C,$D4B,$B4C,$94C,$74C,$54C,$44C,$45B
	dc.w	$46A,$479,$488,$497,$4A6,$4B5,$4C4,$4D3,$6C4,$8B5
	dc.w	$AA6,$C97,$E87,$F77,$F67,$F57,$F48,$F39,$F4A,$D4C
	dc.w	$B4C,$94C,$54C,$54C,$44B,$45A,$469,$478,$487,$498
	dc.w	$4A5,$4B4,$4C3,$4D2,$5C3,$8B4,$AA5,$C96,$E86,$F76
	dc.w	$F66,$F66,$F57,$F48,$F4B,$D4A,$B4B,$94B,$74B,$54B
	dc.w	$44B,$45A,$469,$478,$487,$496,$4A5,$4B4,$4C3,$4D2
	dc.w	$6C3,$8B4,$AA5,$C96,$E86,$F76,$F66,$F56,$F47,$F38
	dc.w	$F49,$D4B,$B4B,$94B,$54B,$54B,$44A,$459,$468,$477
	dc.w	$486,$497,$4A4,$4B3,$4C2,$4D1,$5C2,$8B3,$AA4,$C95
	dc.w	$E85,$F75,$F65,$F65,$F56,$F47,$F4A,$D49,$B4A,$94A
	dc.w	$74A,$54A,$44A,$459,$468,$477,$486,$495,$4A4,$4B3
	dc.w	$4C2,$4D1,$6C2,$8B3,$AA4,$C95,$E85,$F75,$F65,$F55
	dc.w	$F46,$F37,$F48,$D4A,$B4A,$94A,$54A,$54A

*****************************************************************************

	section	coppa,data_C

COPLIST:
	DC.W	$100,$200	; BplCon0 - keine bitplanes
	DC.W	$180,$003	; Color0 - blau
CopBuf:
	dcb.w	(52*2)*LINUM+(2*linum),0	; Platz für die copperlist.

	DC.W	$180,$003	; Color0 - blau
	dc.w	$ffff,$fffe	; Ende copperlist

	END

Immer bunter, aber im Grunde hat sich nichts geändert zu Lezione11g1.s

