
; Listing11h5e.s	- dieses Listing ist nicht im Original Kurs enthalten
			; (das e steht für extra)
			; Anwendung des copper skip, (skip - überspringe die nächste Move-Anweisung)	
			; mit der rechten Maustaste wird mit COPJMP2 ($dff08a) zu 
			; copperlist2 gesprungen
				
	SECTION	DynaCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:

	lea	$dff000,a6
	MOVE.W	#DMASET,$96(a6)		; DMACON - aktivieren bitplane, copper
	move.l	#cop2,$84(a5)		; Zeiger COP2
	move.l	#cop1,$80(a5)		; Zeiger COP1
	move.w	d0,$88(a5)			; Start COP1
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:	
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A6),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1		

	btst	#2,$16(a6)			; rechte Maustaste gedrückt?
	beq.s	NonSwappare			; dann nicht tauschen 
			
	move.w	#$ff01,skip			; skip, wenn RMT gedrückt wird
	bra weiter		

nonSwappare:
	move.w	#$fffe,skip			; wait, wenn RMT nicht gedrückt
weiter:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A6),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts							; exit
			

****************************************************************************

	Section	copper,data_C

Cop1:							; copperlist 1
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
				; 5432109876543210
	;dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256
	dc.w	$100,%0000001000000000

BPLPOINTERS:
	;dc.w $e0,0,$e2,0			; erste	 bitplane

	dc.w	$1007,$fffe			
	dc.w	$180,$F00			; rot		
	dc.w	$4001,$fffe			; ohne diese Warteanweisung
								; wird der COPJMP2 immer ausgeführt werden
	dc.w	$4007		
skip:
	dc.w	$ff01				; skip	$ff01 or wait $fffe
	dc.w	$8a,0				; copjmp2 start
		
	dc.w	$180,$0F0			; grün					
	dc.w	$6007,$fffe	
	dc.w	$180,$00F			; blau
	dc.w	$ffff,$fffe

****************************************************************************

Cop2:							; copperlist 2
	dc.w	$8007,$fffe	 
	dc.w	$180,$000			; schwarz
	dc.w	$A007,$fffe	 
	dc.w	$180,$FFF			; weiss
	dc.w	$C007,$fffe	 
	dc.w	$180,$FF0			; gelb	
	dc.w	$ffff,$fffe

	end


der einzige Unterschied zwischen wait und skip ist:
SECOND WAIT INSTRUCTION WORD (IR2)
Bit 0 Always set to 0		- das Ende ist immer gerade		

SECOND SKIP INSTRUCTION WORD (IR2)
Bit 1 Always set to 1		- das Ende ist immer ungerade	

Will man an der Position $4007 zu copperlist2 springen, so muss der
Videostrahl zum Zeitpunkt des skip-Befehls diese Position erreicht haben.
In der copperlist1 wird dies durch das dc.w	$4007,$fffe	erreicht.

Ohne diese Warteanweisung wäre der Videostrahl irgendwo kurz nach $1007,
wenn er auf die Sprunganweisung trifft, sodass der folgende MOVE (CJMP)
immer ausgeführt wird! 
	
teste auch:
dc.w	$4007,$fffe				; dc.w	$39E1,$fffe, dc.w $4001,$fffe		
								; der copper benötigt einige Zeit um den 
								; eigenen wait-Befehl auszuführen