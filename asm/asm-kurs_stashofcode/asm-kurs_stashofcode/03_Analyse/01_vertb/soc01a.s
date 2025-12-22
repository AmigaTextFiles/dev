
; soc01a.s	

; a) erklärt Erstellung der Copperliste
; b) erklärt Ermittlung der Größe von COPSIZE zur Anforderung des Speicherplatzes

;------------------------------------------------------------------------------
; a)
	move.l copperlist,a0
	move.w #((DISPLAY_Y+(DISPLAY_DY>>1))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+									
	move.w #COLOR00,(a0)+
	move.w #$0F00,(a0)+
	move.l #$FFFFFFFE,(a0)+	
					
	move.w #((DISPLAY_Y+(DISPLAY_DY>>1))<<8)!$0001,(a0)+	
	DISPLAY_Y = $2C
	DISPLAY_DY = 256

	DISPLAY_Y								= 0x0000002C = %00000000.00000000.00000000.00101100 = 44
	DISPLAY_DY								= 0x00000010 = %00000000.00000000.00000001.00000000 = 256
	DISPLAY_DY >> 1							= 0x00000080 = %00000000.00000000.00000000.10000000 = 128
	
	(DISPLAY_Y+(DISPLAY_DY>>1)					= $AC	 = %00000000.00000000.00000000.10101100 = 172
	((DISPLAY_Y+(DISPLAY_DY>>1))<<8				= $AC00  = %00000000.00000000.10101100.00000000
	((DISPLAY_Y+(DISPLAY_DY>>1))<<8)!$0001		= $AC01  = %00000000.00000000.10101100.00000001
	
;------------------------------------------------------------------------------
; b)

COPSIZE=2*4+4

	dc.w $AC01,$FF00		; 4  ; die Hälfte von 256 + Rand
	dc.w $0180,$0F00		; 4
	dc.w $ffff,$fffe		; 4	
						