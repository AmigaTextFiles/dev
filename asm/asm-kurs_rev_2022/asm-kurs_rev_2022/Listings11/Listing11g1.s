
; Listing11g1.s -  Verwendung der Coppereigenschaft,  einen "MOVE"
				; durchzuführen erfordert horizontal 8 Pixel.

	Section	HorizCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern von Interrupt, DMA und so weiter.
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
* Diese Routine erstellt eine copperliste mit 40 COLOR0 Registern für   *
* eine Zeile, also, da jeder move in der copperliste 8 Pixel (lowres)   *
* der auszuführenden Zeit dauert, wird color0						    *
* 40-mal HORIZONTAL in Schritten von 8 Pixeln geändert				    *
*************************************************************************

;	   .:::::.
;	  ¦:::·:::¦
;	  |· ¯ ¯ ·|
;	 C|  ° °  l)
;	 /__ (_) __\
;	/ \ \___/ / \
;	\__\_   _/__/
;	  \_`---'_/xCz
;	    ¯¯¯¯¯

LINSTART	EQU	$A041fffe		; ändern von "$a0", um in einer
								; anderen vertikalen Zeile zu starten.
LINUM		EQU	25				; Anzahl der zu erledigenden Zeilen.

MAKE_IT:
	lea	CopBuf,a1
	move.l	#LINSTART,d0		; erstes "wait"
	move.w	#LINUM-1,d1			; Anzahl der zu erledigenden Zeilen
colcon1:
	lea	cols(pc),a0				; Adresse der Tabele mit den Farben in a0
	move.w	#39-1,d2			; 39 Farben pro Zeile
	move.l	d0,(a1)+			; setzen des WAIT in der copperlist
colcon2:
	move.w	#$0180,(a1)+		; setzen des Registers COLOR0
	move.w	(a0)+,(a1)+			; Setze den Wert von COLOR0 (aus der Tabelle)
	dbra	d2,colcon2			; Führe eine ganze Zeile aus
	add.l	#$01000000,d0		; "WAIT" machen eine Zeile darunter
	dbra	d1,colcon1			; Wiederholen Sie dies für die Anzahl 
	rts							; der zu erledigenden Zeilen


; Tabelle mit den 39 Farben einer horizontalen Zeile.

cols:
	dc.w	$000,$111,$222,$333,$444,$555,$666,$777
	dc.w	$888,$999,$aaa,$bbb,$ccc,$ddd,$eee,$fff
	dc.w	$fff,$fff,$fff,$fff,$fff,$fff,$fff,$fff
	dc.w	$eee,$ddd,$ccc,$bbb,$aaa,$999,$888,$777
	dc.w	$666,$555,$444,$333,$222,$111,$000

*****************************************************************************

	section	coppa,data_C

COPLIST:
	DC.W	$100,$200			; BplCon0 - keine bitplanes
	DC.W	$180,$003			; Color0 - blau
CopBuf:
	dcb.w	80*LINUM,0			; Bereich, in dem die copperlist erstellt wird

	DC.W	$180,$003			; Color0 - blau
	dc.w	$ffff,$fffe			; Ende copperlist

	END

In diesem Listing wird gezeigt, wie eine Zeile mit COLOR0 (oder einer anderen)
mit WAIT MOVE eingefügt wird. Es dauert einige Zeit, um jeden einzelnen move
auszuführen. Genau gesagt 8 Pixel lowres. In der Tat, wenn Sie die Auflösung
hires einstellen, ändert sich nichts, nur Sie können über "16" Pixel-hires
sprechen... (aber es ist nutzlos) Wenn Sie wollen, können Sie mit einem "Klick"
die horizontale Breite mit einem Lineal messen und Sie werden bemerken das es
immer das gleiche ist. Außerdem ist es eine nützliche Tatsache für Effekte wie
PLASMA oder das in diesem Beispiel gezeigte. Es ist eine Einschränkung in dem
Sinne, dass wenn man die ganze Palette wechseln will braucht jede Zeile "etwas
Zeit" und es würde sich nicht vollständig in der mittleren Zeile oder sogar in
der darunter liegenden Zeile ändern.
