; Lezione9c1.s	EIN BLITTING MIT HöHE VON 1 UND MODULO
; Linke Taste, um das Bliting auszuführen, rechts um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:
;	Wir zeigen auf das "leere" PIC

	MOVE.L	#BITPLANE,d0		; 
	LEA	BPLPOINTERS,A1			; Zeiger COP
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

Aspettasin:
	btst	#6,$bfe001	; linke Mausetaste gedrückt?
	bne.s	Aspettasin

	btst.b	#6,2(a5) ; dmaconr
WBlit:
	btst.b	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit

;	    /\  /\
;	.--/  \/  \---.
;	 \           /
;	._> (o)(o   <__.
;	 \  _C        /
;	 / /____,  )  \
;	'----\    /----`
;	      oooo
;	     /    \

	move.w	#$ffff,$44(a5)		; BLTAFWM wir werden es später erklären
	move.w	#$ffff,$46(a5)		; BLTALWM wir werden es später erklären
	move.w	#$09f0,$40(a5)		; BLTCON0 (Kanal A und D)
	move.w	#$0000,$42(a5)		; BLTCON1 wir werden es später erklären
	move.w	#0,$64(a5)			; BLTAMOD = 0 weil das Rechteck in der
					; Quelle aufeinanderfolgende Zeilen im Speicher hat
					
	move.w	#36,$66(a5)		; BLTDMOD 40-4=36 das Rechteck
					; Ziel ist innerhalb einer
					; Bitebene 20 Wörter breit oder 40 Bytes. 
					; Das gemischte Rechteck ist 2 Wörter breit, 
					; das sind 4 Bytes.
					; Der Wert der Formel ist gegeben durch den
					; Unterschied zwischen den Breiten

	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	#bitplane,$54(a5)	; BLTDPT  (Zeilen des Bildschirms)
	move.w	#(64*6)+2,$58(a5)	; BLTSIZE (Blitter starten !)
					; Jetzt werden wir eine Zahl von
					; 2 Wörter X 6 Zeilen mit nur einer
					; Blittata mit den MODULO entsprechend
					; für den Bildschirm einstellen.
mouse:
	btst	#2,$16(a5)	; rechte Maustaste gedrückt?
	bne.s	mouse

	btst.b	#6,2(a5) ; dmaconr
WBlit2:
	btst.b	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	rts

;*****************************************************************************

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

	dc.w	$100,$1200	; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$eee	; color1

	dc.w	$FFFF,$FFFE	; Ende copperlist

;*****************************************************************************

; Wir definieren in binär die Figur, die 16 Bits oder 2 Wörter breit und 6 Zeilen
; hoch ist. Beachten Sie, dass die Zeilen nacheinander im Speicher angeordnet sind.

Figura:
	dc.l	%00000000000000000000110001100000	; Zeile 1
	dc.l	%00000000000000000011000110000000	; Zeile 2
	dc.l	%00000000000000001100011000000000
	dc.l	%00000110000000110001100000000000
	dc.l	%00000001100011000110000000000000
	dc.l	%00000000011100011000000000000000	; Zeile 6

;*****************************************************************************

	SECTION	PLANEVUOTO,BSS_C

BITPLANE:
	ds.b	40*256		; bitplane (alles Null) lowres

	end

*****************************************************************************

In diesem Beispiel sehen Sie, wie Sie ein Rechteck kopieren.
Beachten Sie zuerst die Formel zum Schreiben der Größe des Rechtecks 
in BLTSIZE. Achten Sie genau darauf wie die MODULO berechnet werden. 
Wie für die Quelle, die beim Label "Figur" beginnt, die Reihen des Rechtecks 
sind im Speicher hintereinander angeordnet. Daher ist der Wert des Modulos 
für die Quelle (Kanal A) 0.
Für das Ziel stattdessen, wenn wir das betreffende Rechteck innerhalb einer 
größeren Bitebene kopieren müssen, sind die Zeilen nicht fortlaufend im 
Speicher und Sie müssen einen Wert für das Modulo angeben, das wir 
mit der Formel welche wir in der Lektion gesehen haben, berechnen.