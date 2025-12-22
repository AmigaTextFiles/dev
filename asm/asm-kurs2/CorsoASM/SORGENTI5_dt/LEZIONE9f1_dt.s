
; Lezione9f1.s	BLITTATA, in dem wir ein Rechteck von einem Punkt zu einem 
			; anderen Punkt des gleichen Bildschirms kopieren
			; Linke Taste, um den Blitting auszuführen, rechts um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:
	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#3-1,D1			; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0	; + Bitplane Länge (hier 256 Zeilen hoch)
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
	bne.s	mouse1		; wenn nicht, nicht abbrechen

	bsr.s	copia		; Führen Sie die Kopierroutine aus

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

	rts

; ************************ KOPIER ROUTINE ****************************

; Ein Rechteck mit der Breite = 160 und der Höhe = 20 wird kopiert
; aus den Koordinaten X1 = 64, Y1 = 50 (Quelle)
; zu den Koordinaten X2 = 80, Y2 = 190 (Ziel)

;	   .  , _ .
;	   ¦\_|/_/l
;	  /¯/¬\/¬\¯\
;	 /_( ©( ® )_\
;	l/_¯\_/\_/¯_\\
;	/ T (____) T \\
;	\/\___/\__/  //
;	(_/  __     T|
;	 l  (. )    |l\
;	  \  ¯¯    // /
;	   \______//¯¯
;	  __Tl___Tl xCz
;	 C____(____)

copia:

; Laden Sie die Quell- und Zieladressen in 2 Variablen

	move.l	#bitplane+((20*50)+64/16)*2,d0	; Adresse Quelle
	move.l	#bitplane+((20*190)+80/16)*2,d2	; Adresse Ziel

				; Schleife Blittata
	moveq	#3-1,d1		; für alle bitplanes wiederholen 
copia_loop:
	btst	#6,2(a5)	; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie A nach D
	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir werden es später erklären

; Lade die Zeiger

	move.l	d0,$50(a5)	; bltapt
	move.l	d2,$54(a5)	; bltdpt

; Diese 2 Anweisungen legen die Quell- und Zielmodulo fest
; Beachten Sie, dass Quelle und Ziel innerhalb des selben 
; Bildschirms liegen das MODULO ist das gleiche.
; das Modulo berechnet sich nach der Formel (H-L) * 2 (H ist die Breite der
; Bitebene in Worten und L ist die Breite des Bildes, immer in Worten)
; das haben wir in der Lektion gesehen, (20-160 / 16) * 2 = 20

	move.w	#(20-160/16)*2,$64(a5)	; bltamod
	move.w	#(20-160/16)*2,$66(a5)	; bltdmod

; Beachten Sie auch, dass Sie, da die 2 Register aufeinanderfolgende 
; Adressen haben, können Sie eine einzige Anweisung anstelle von 2
; verwenden (denken Sie daran, dass 20 = $14) ist:
; move.l # $00140014,$64(a5); Bltamod und Bltdmod

	move.w	#(20*64)+160/16,$58(a5)		; bltsize						
						; Höhe 20 Zeilen
						; 160 Pixel breit (= 10 Wörter)
						
; Aktualisieren Sie die Variablen, die die Adressen enthalten, damit sie in 
; den folgenden Bitebenen darauf zeigen

	add.l	#40*256,d2	; Zieladresse nächste Ebene
	add.l	#40*256,d0	; Quelladresse nächste Ebene

	dbra	d1,copia_loop

	btst	#6,$02(a5)	; warte auf das Ende des Blitters
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
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$3200	; bplcon0 - 1 bitplane lowres

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
	incbin	"assembler2:sorgenti6/amiga.raw"	; Hier laden wir die Figur	
	
	end

;****************************************************************************

In diesem Beispiel kopieren wir mit dem Blitter ein Bild, das aus drei 
Bitebenen gebildet wird. Beachten Sie, dass die Schleife, in der die 
Blittings ausgeführt werden, strukturiert ist.
Die Quell- und Zieladressen werden in 2 Datenregister des Prozessors 
geladen, die als Variablen verwendet werden. Bei jeder Wiederholung 
werden sie modifiziert, um auf die nächste Bitebene zu zeigen. 
Dazu wird die Formel verwendet

ADRESSE2 = ADRESSE1+2*H*V

Das hatten wir im Unterricht gesehen. In unserem Beispiel ist V = 256 
(die Anzahl der Zeilen) und H = 20 (die Breite des Bildschirms in Worten).

In diesem Beispiel sind Quelle und Ziel der Blittata auf dem gleichen 
Bildschirm enthalten. Deshalb ist die Form für beide gleich
und wird nach der üblichen Formel berechnet.
