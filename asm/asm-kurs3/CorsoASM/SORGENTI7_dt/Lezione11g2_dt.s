
; Lezione11g2.s -  Verwendung der Coppereigenschaft,  einen "MOVE"
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
;	 |·     ·|
;	C| _   _ l)
;	/ _°(_)°_ \
;	\_\_____/_/
;	 l_`---'_!
;	  `-----'xCz


LINSTART	EQU	$8021fffe	; ändern von "$80", um in einer
							; anderen vertikalen Zeile zu starten.
LINUM		EQU	25*3		; Anzahl der zu erledigenden Zeilen.

MAKE_IT:
	lea	CopBuf,a1			; Adressraum in copperlist
	move.l	#LINSTART,d0	; erstes "wait"
	move.w	#LINUM-1,d1		; Anzahl der zu erledigenden Zeilen
	move.w	#$180,d3		; Word für Register color0 in copperlist
	move.l	#$01000000,d4	; Wert, der zum Wait zur nächsten Zeile
							; hinzugefügt werden soll.
colcon1:
	lea	cols(pc),a0			; Adresstabelle mit Farben in a0
	move.w	#52-1,d2		; 52 color pro Zeile	
	move.l	d0,(a1)+		; Setzen des WAIT in der copperlist
colcon2:
	move.w	d3,(a1)+		; Setzen des Registers COLOR0 ($180)
	move.w	(a0)+,(a1)+		; Setze den Wert von COLOR0 (aus der Tabelle)
	dbra	d2,colcon2		; Führen Sie eine ganze Zeile aus
	add.l	d4,d0			; Machen Sie die Zeile "Wait" unten (+$01000000)
	dbra	d1,colcon1		; Wiederholen Sie dies für die Anzahl
	rts						; der zu erledigenden Zeilen


;	Tabelle mit den 52 Farben einer horizontalen Linie.

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
	DC.W	$100,$200	; BplCon0 - keine bitplanes
	DC.W	$180,$003	; Color0 - blau
CopBuf:
	dcb.w	(52*2)*LINUM+(2*linum),0	; Platz für die copperlist.
	DC.W	$180,$003	; Color0 - blau
	dc.w	$ffff,$fffe	; Ende copperlist

	END

In diesem Fall haben wir den Effekt "bunter" gemacht, nichts Besonderes.
