
; Listing15a.s		copper-AGA-Nuance unter Verwendung der 24-Bit-Palette.
;					Unten sehen Sie den Unterschied zu 12-Bit.

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

LOOP:
	BTST	#6,$BFE001
	BNE.S	LOOP
	RTS

;*****************************************************************************
;*				COPPERLIST													 *
;*****************************************************************************

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
	dc.w	$100,$201			; keine bitplanes (bit 1 aktiviert jedoch!)

	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$005			; Color0 - nibble hoch
								; (Wir lassen die niedrigen Nibble bei Null...)

	dc.w	$5f07,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$010			; Color0 - nibble niedrig

	dc.w	$6007,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$030			; Color0 - nibble niedrig

	dc.w	$6107,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$050			; Color0 - nibble niedrig

	dc.w	$6207,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$070			; Color0 - nibble niedrig

	dc.w	$6307,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$090			; Color0 - nibble niedrig

	dc.w	$6407,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0b0			; Color0 - nibble niedrig

	dc.w	$6507,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0d0			; Color0 - nibble niedrig

	dc.w	$6607,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0f0			; Color0 - nibble niedrig

	dc.w	$6707,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$010			; Color0 - nibble niedrig

	dc.w	$6807,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$030			; Color0 - nibble niedrig

	dc.w	$6907,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$050			; Color0 - nibble niedrig

	dc.w	$6a07,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$070			; Color0 - nibble niedrig

	dc.w	$6b07,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$090			; Color0 - nibble niedrig

	dc.w	$6c07,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0b0			; Color0 - nibble niedrig

	dc.w	$6d07,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0d0			; Color0 - nibble niedrig

	dc.w	$6e07,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0f0			; Color0 - nibble niedrig

	dc.w	$6f07,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$010			; Color0 - nibble niedrig

	dc.w	$7007,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$030			; Color0 - nibble niedrig

	dc.w	$7107,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$050			; Color0 - nibble niedrig

	dc.w	$7207,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$070			; Color0 - nibble niedrig

	dc.w	$7307,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$090			; Color0 - nibble niedrig

	dc.w	$7407,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0b0			; Color0 - nibble niedrig

	dc.w	$7507,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0d0			; Color0 - nibble niedrig

	dc.w	$7607,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$0f0			; Color0 - nibble niedrig

	dc.w	$7707,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$030			; Color0 - nibble hoch
	dc.w	$106,$e00			; AUSWAHL NIBBLE NIEDRIG
	dc.w	$180,$010			; Color0 - nibble niedrig

; Vergleichen wir nun mit der "Standard" Palette ECS/OCS:

	dc.w	$7907,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000			; Color0 - nibble hoch

	dc.w	$8007,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$010			; Color0 - nibble hoch

	dc.w	$8807,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$020			; Color0 - nibble hoch

	dc.w	$9007,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$030			; Color0 - nibble hoch

	dc.w	$9807,$fffe			; Wait
	dc.w	$106,$c00			; AUSWAHL NIBBLE HOCH
	dc.w	$180,$005			; Color0 - nibble hoch

	dc.w	$FFFF,$FFFE			; Ende der copperlist

	end

Sie bemerken den Unterschied, richtig?? AGA rulez!
Wie Sie bemerken, folgt die Nuance diesem Trend:

  Division durch nibble	  24-Bit Original

	  RGB	rgb				RrGgBb
	$0000,$0000	-> das ist $000000
	$0000,$0010	-> das ist $000100
	$0000,$0030	-> das ist $000300
	$0000,$0050	-> das ist $000500
	$0000,$0070	-> das ist $000700
	$0000,$0090	-> das ist $000900
	$0000,$00B0	-> das ist $000b00
	$0000,$00D0	-> das ist $000d00
	$0000,$00F0	-> das ist $000f00
	$0010,$0010	-> das ist $001100
	$0010,$0030	-> das ist $001300
	$0010,$0050	-> das ist $001500
	$0010,$0070	-> das ist $001700
	$0010,$0090	-> das ist $001900
	$0010,$00B0	-> das ist $001b00
	$0010,$00D0	-> das ist $001d00
	$0010,$00F0	-> das ist $001f00
	$0020,$0010	-> das ist $002100
	$0020,$0030	-> das ist $002300
	$0020,$0050	-> das ist $002500
	$0020,$0070	-> das ist $002700
	$0020,$0090	-> das ist $002900
	$0020,$00B0	-> das ist $002b00
	$0020,$00D0	-> das ist $002d00
	$0020,$00F0	-> das ist $002f00
	$0030,$0010	-> das ist $003100
	...

Das Erstellen eines AGA-Gradienten ist manuell lang, es 
lohnt sich, eine Routine zu erstellen, die das erschafft!

