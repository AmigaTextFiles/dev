
; Lezione9h4r.s	durch Scrollen nach rechts verschwindet ein Bild
		; (im rawblit Format) durch Shift + BLTALWM Maske.
		; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist Etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#3-1,D1			; Anzahl Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
				; HIER IST EIN UNTERSCHIED
				; ZU DEN NORMALEN BILDERN !!!!!!
	ADD.L	#40,d0		; + LÄNGE EINER Zeile !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse1:
	btst	#2,$dff016	; rechte Maustaste gedrückt?
	bne.s	mouse1		; Wenn nicht, gehe zurück zu mouse1:

	bsr.s	Scorri		; Führen Sie die Bildlaufroutine aus

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

	rts


;******************************************************************************
; Diese Routine lässt ein Bild nach und nach verschwinden
; Schieben Sie es nach rechts
;******************************************************************************

;	     .----------.
;	     ¦          ¦
;	     |          |
;	     |          |
;	     | ¯¯¯  --- |
;	    _l___    ___|_
;	   /   _¬\  / _  ¬\
;	 _/   ( °/--\° )   \_
;	/¬\_____/¯¯¯¯\_____/¬\
;	\ ____(_,____,_)____ /
;	 \_\ `----------' /_/
;	   \\___      ___//
;	    \__`------'__/
;	      |  ¯¯¯¯  | xCz
;	      `--------'

Scorri:
	move.w	#160-1,d7	; Die Schleife muss für jedes Pixel einmal ausgeführt werden
						; das Bild ist 160 Pixel breit (10 Wörter)

; In diesem Beispiel kopieren wir ein Bild auf sich selbst, aber verschieben 
; es kontinuierlich um ein Pixel, um es fließen zu lassen.
; Daher sind die Quell- und Zieladressen identisch

	move.l	#bitplane+((20*3*50)+64/16)*2,d0	; Adresse Quelle und Ziel

ScorriLoop:

; Warten Sie, bis das vblank das Bild um jeweils ein Pixel verschoben hat

WaitWblank:
	CMP.b	#$ff,$dff006		; warte auf die Zeile 255
	bne.s	WaitWblank
Aspetta:
	CMP.b	#$ff,$dff006		; warte auf die Zeile 255?
	beq.s	Aspetta

	btst	#6,2(a5)	; dmaconr - Warten Sie, bis der Blitter fertig ist
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$19f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
								; mit einer Pixelverschiebung

	move.l	#$fffffffe,$44(a5)	; BLTAFWM und BLTALWM
					; BLTAFWM = $ffff - alles
					; BLTALWM = $fffe = %1111111111111110
					; lösche das letzte Bit

; Lade die Zeiger

	move.l	d0,$50(a5)			; bltapt - Quelle
	move.l	d0,$54(a5)			; bltdpt - Ziel

; Das Modulo wird wie gewohnt berechnet

	move.l	#$00140014,$64(a5)			; bltamod und bltdmod 
	move.w	#(3*20*64)+160/16,$58(a5)	; bltsize
						; Höhe 20 Linien und 3 Ebenen
						; 160 Pixel breit (= 10 Wörter)

	dbra	d7,ScorriLoop		; Wiederholen Sie dies für jedes Pixel

	btst	#6,$02(a5)	; dmaconr - Warten Sie, bis der Blitter fertig ist
waitblit2:
	btst	#6,$02(a5)
	bne.s	waitblit2
	rts

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2

				; HIER GIBT ES EINEN UNTERSCHIED
				; ZU DEN NORMALEN BILDERN !!!!!!
	dc.w	$108,80		; WERT MODULO = 2*20*(3-1)= 80
	dc.w	$10a,80		; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200	; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000

	dc.w	$0180,$000	; color0
	dc.w	$0182,$475	; color1
	dc.w	$0184,$fff	; color2
	dc.w	$0186,$ccc	; color3
	dc.w	$0188,$999	; color4
	dc.w	$018a,$232	; color5
	dc.w	$018c,$777	; color6
	dc.w	$018e,$444	; color7

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

BITPLANE:
	incbin	"assembler2:sorgenti6/amiga.rawblit"
	
						; hier laden wir die Figur in
						; RAWBLIT-Format (oder Interleaved-Format)
						; konvertiert mit KEFCON.
	end

;****************************************************************************

Dieses Beispiel ist die Rawblit-Version von lesson9h4.s.
Vergleichen Sie die Unterschiede in den Formeln zur Berechnung der zu 
schreibenden Werte in den Blitterregistern.

