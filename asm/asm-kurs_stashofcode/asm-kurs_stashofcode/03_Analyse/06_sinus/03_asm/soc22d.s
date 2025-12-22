
; soc22d.s
; Summe aller XOR-Werte, Ergebnis: TEXT_CHECKSUM=$12e69
; wenn Text ein anderer ist, dann textlamer an Text kopieren

;---------- Directives ----------

	SECTION yragael,CODE_C

TEXT_XOR=$3B
TEXT_CHECKSUM=$12e69
TEXT_CHECKSUM_LAMER=$7f6

; Control the integrity of the text to diplay. Watch for the context in which the macro is used, because the 
; macro may modified the length of the initial text (which must be at least as long as "You are a LAMER!", 
; or data wil be overwritten) and make the code that was using it go berzerk


CHECKTEXT:	MACRO
	movem.l d0-d1/a0-a1,-(sp)			; Register retten
	lea text,a0							; Anfangsadresse von text nach a0
	clr.l d0							; d0 zurücksetzen
	clr.l d1							; d1 zurücksetzen
_checkTextLoop\@
	move.b (a0)+,d0						; erstes Zeichen von Text nach d0
	add.l d0,d1							; Summe aller XOR-Werte (Ergebnis: TEXT_CHECKSUM=$12e69) 
	eor.b #TEXT_XOR,d0					; Rück-Entschlüsselung des Zeichens		$1B XOR $3B = $20
	bne _checkTextLoop\@				; solange Zeichen nicht $3b ist, weiter
	cmp.l textChecksum,d1				; Ende und Summe vergleichen 
	beq _checkTextOK\@					; wenn Ergebnis $12e69 ist ok
	move.l #TEXT_CHECKSUM_LAMER,textChecksum	; ansonsten ist es ein anderer Text 
	lea text,a0							; Text "Lamer" nach Text kopieren
	lea textLamer,a1					; Anfangsadresse TextLamer	
_checkTextLamerLoop\@
	move.b (a1)+,d0						; aktuelles Zeichen in d0 zwischenspeichern
	move.b d0,(a0)+						; aktuelles Zeichen in Text ersetzen
	eor.b #TEXT_XOR,d0					; solange bis Ende $3B erreicht ist
	bne _checkTextLamerLoop\@			; ansonsten weiter machen
_checkTextOK\@
	movem.l (sp)+,d0-d1/a0-a1			; Register wiederherstellen
	ENDM

waitmouse
	btst	#2,$dff016					; right mousebutton?
	bne.s	waitmouse		
	
	CHECKTEXT							; das Makro ausführen		

	nop

	rts

;---------- Data ----------

graphicslibrary:		DC.B "graphics.library",0
	EVEN
font8:					INCBIN "font8.fnt"
	EVEN
text:							; der verschlüsselte Text
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B62, $697A, $7C7A, $7E77
	dc.w $1B59, $4952, $555C, $411B, $425A, $1B5A, $1B54, $555E
	dc.w $1B4B, $5243, $5E57, $1B48, $5255, $5E1B, $4858, $4954
	dc.w $5757, $1A1B, $6854, $4949, $4217, $1B55, $541B, $0A0D
	dc.w $430A, $0D1B, $5D54, $554F, $1B5A, $4D5A, $5257, $5A59
	dc.w $575E, $151B, $721B, $535A, $5F1B, $4F54, $1B48, $4F49
	dc.w $5E4F, $5853, $1B5A, $1B03, $4303, $1B54, $555E, $171B
	dc.w $535E, $5558, $5E1B, $524F, $481B, $4B52, $435E, $575E
	dc.w $5F1B, $5754, $5450, $1515, $151B, $7C49, $5E5E, $4F52
	dc.w $555C, $481B, $5D54, $5757, $544C, $1515, $151B, $1B15
	dc.w $5474, $5415, $1B1B, $686F, $7469, $766F, $6974, $746B
	dc.w $7E69, $011B, $7354, $4C1B, $5248, $1B6B, $5A55, $415E
	dc.w $491B, $7957, $524F, $411B, $5C54, $5255, $5C04, $1B78
	dc.w $5A55, $1C4F, $1B4C, $5A52, $4F1B, $4F54, $1B4B, $575A
	dc.w $421B, $4F53, $5E1B, $5C5A, $565E, $1A1B, $1B15, $5474
	dc.w $5415, $1B1B, $7F7A, $6970, $1B7E, $756F, $6972, $7E68
	dc.w $011B, $7F54, $1B42, $544E, $1B48, $4F52, $5757, $1B54
	dc.w $4C55, $1B42, $544E, $491B, $7A56, $525C, $5A1B, $0A0B
	dc.w $0B0B, $041B, $7754, $5450, $1B4E, $555F, $5E49, $4852
	dc.w $5F5E, $1B4F, $535E, $1B57, $525F, $011B, $4F53, $5E49
	dc.w $5E1B, $565A, $421B, $595E, $1B4D, $5A57, $4E5A, $5957
	dc.w $5E1B, $4852, $5C55, $5A4F, $4E49, $5E48, $1A1B, $1B15
	dc.w $5474, $5415, $1B1B, $716E, $7570, $727E, $011B, $7552
	dc.w $585E, $1B4F, $5E5A, $561B, $4C54, $4950, $1B5F, $5E58
	dc.w $545F, $5255, $5C1B, $4F53, $5E1B, $7A7C, $7A1B, $495E
	dc.w $5C52, $484F, $5E49, $481A, $1B6F, $5354, $485E, $1B5C
	dc.w $4E42, $481B, $5A4F, $1B78, $5456, $5654, $5F54, $495E
	dc.w $1B49, $5E5A, $5757, $421B, $595E, $5752, $5E4D, $5E5F
	dc.w $1B55, $5459, $545F, $421B, $4C54, $4E57, $5F1B, $4F49
	dc.w $421B, $4F54, $1B56, $5E4F, $5A57, $1B59, $5A48, $531B
	dc.w $4F53, $5E1B, $5853, $524B, $485E, $4F04, $1B1B, $1554
	dc.w $7454, $151B, $1B78, $7469, $7E75, $6F72, $7501, $1B69
	dc.w $5E56, $5E56, $595E, $4952, $555C, $1B4F, $535E, $1B5D
	dc.w $5249, $484F, $1B4F, $5256, $5E1B, $721B, $485A, $4C1B
	dc.w $5A55, $1B7A, $5652, $5C5A, $1B5C, $5A56, $5E15, $1515
	dc.w $1B72, $4F1B, $4C5A, $481B, $7459, $5752, $4F5E, $495A
	dc.w $4F54, $491B, $494E, $5555, $5255, $5C1B, $5455, $1B42
	dc.w $544E, $4948, $1A1B, $1B15, $5474, $5415, $1B1B, $737E
	dc.w $7A7F, $736E, $756F, $7E69, $011B, $6F53, $5A55, $431B
	dc.w $5A5C, $5A52, $551B, $5D54, $491B, $4F53, $5E1B, $5F52
	dc.w $485A, $5957, $5E5F, $1B5A, $5858, $5E48, $481A, $1B78
	dc.w $5455, $5F5E, $5655, $5E5F, $1B78, $5E57, $5704, $1B79
	dc.w $5E48, $4F1B, $5C5E, $4956, $5A55, $1B79, $7968, $1B5E
	dc.w $4D5E, $491A, $1B1B, $1554, $7454, $151B, $1B76, $7475
	dc.w $6F62, $011B, $6854, $1B5C, $495E, $5A4F, $1B4F, $4E55
	dc.w $5E48, $1B5D, $5449, $1B4F, $535E, $1B58, $495A, $5850
	dc.w $4F49, $5448, $1A1B, $6C53, $5A4F, $1B5A, $1B4F, $5E5A
	dc.w $561B, $4C5E, $1B56, $5A5F, $5E1A, $1B1B, $1554, $7454
	dc.w $151B, $1B73, $7E7A, $6F73, $7E75, $011B, $7754, $5450
	dc.w $1B5A, $4F1B, $4254, $4E1A, $1B6C, $535A, $4F1B, $5A1B
	dc.w $4B5A, $5255, $4F59, $5A57, $571B, $5853, $5A56, $4B52
	dc.w $5455, $1A1B, $1B15, $5474, $5415, $1B1B, $767A, $6372
	dc.w $7672, $7772, $7E75, $011B, $721B, $5F54, $4E59, $4F1B
	dc.w $4254, $4E1B, $4C52, $5757, $1B49, $5E5A, $5F1B, $4F53
	dc.w $5248, $1B54, $555E, $171B, $594E, $4F1B, $4C53, $5A4F
	dc.w $5E4D, $5E49, $1515, $151B, $724F, $1B4C, $5A48, $1B5D
	dc.w $4E55, $1B4F, $541B, $5854, $5F5E, $1B4F, $5354, $485E
	dc.w $1B58, $495A, $5850, $4F49, $5448, $1A1B, $1B15, $5474
	dc.w $5415, $1B1B, $6F69, $7268, $6F7A, $7501, $1B62, $544E
	dc.w $1B4C, $5E49, $5E1B, $4952, $5C53, $4F01, $1B7A, $7674
	dc.w $681B, $5248, $1B77, $7A76, $7468, $1A1B, $7A68, $761B
	dc.w $494E, $575E, $411A, $1B1B, $1554, $7454, $151B, $1B7D
	dc.w $7269, $7E78, $697A, $7870, $7E69, $011B, $7352, $171B
	dc.w $565A, $551A, $1B73, $544B, $5E1B, $4254, $4E1C, $495E
	dc.w $1B55, $544F, $1B59, $5449, $5255, $5C1B, $4F54, $1B5F
	dc.w $5E5A, $4F53, $1B52, $551B, $4254, $4E49, $1B59, $5A55
	dc.w $501A, $1B1B, $1554, $7454, $151B, $1B3B, $0000		
	EVEN

textLamer:	
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B62, $544E, $1B5A, $495E
	dc.w $1B5A, $1B77, $7A76, $7E69, $1A3B, $0000
	EVEN

textChecksum:			
	DC.L TEXT_CHECKSUM
	
	end


;------------------------------------------------------------------------------
; WinUAE-Debugger (open with Shift+F12)

_checkTextOK\@
	movem.l (sp)+,d0-d1/a0-a1			; Register wiederherstellen
; Breakpoint vor dieser Anweisung

>r
  D0 00000000   D1 00012E69   D2 00000000   D3 00000000							; d1 = 12E69 (Summe aller Werte)
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 0006AC7E   A1 00023A12   A2 000235D6   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FE40
USP  00C5FE40 ISP  00C60E50
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cdf (MVMEL) 0303 (BTST) Chip latch 00000000
0006a528 4cdf 0303                movem.l (a7)+,d0-d1/a0-a1
Next PC: 0006a52c
>
