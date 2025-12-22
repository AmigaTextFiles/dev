
; soc02a.s	

; a) erklärt Erstellung der Copperliste
; b) erklärt Ermittlung der Größe von COPSIZE zur Anforderung des Speicherplatzes


;---------- Copperlist ----------

	move.l copperlist,a0

; Warten auf halber Höhe des Bildschirms

	move.w #((DISPLAY_Y+((2*DISPLAY_DY)>>2))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+

; Farbe ändern in rot ($0F00)

	move.w #COLOR00,(a0)+
	move.w #$0F00,(a0)+

; Warten auf das letzte Viertel der Bildschirmhöhe

	move.w #((DISPLAY_Y+((3*DISPLAY_DY)>>2))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+

; einen VERTB-Interrupt auslösen, um die Farbe in Schwarz zu ändern ($0000)

	move.w #INTREQ,(a0)+
	move.w #$8020,(a0)+

; Ende

	move.l #$FFFFFFFE,(a0)+

;------------------------------------------------------------------------------
; a)

DISPLAY_Y=$2C
DISPLAY_DY=256
COPSIZE=4*4+4
	
	move.l copperlist,a0
	move.w #((DISPLAY_Y+((2*DISPLAY_DY)>>2))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #COLOR00,(a0)+
	move.w #$0F00,(a0)+

	move.w #((DISPLAY_Y+((3*DISPLAY_DY)>>2))<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #INTREQ,(a0)+
	move.w #$8020,(a0)+
	move.l #$FFFFFFFE,(a0)+


	move.w #((DISPLAY_Y+((2*DISPLAY_DY)>>2))<<8)!$0001,(a0)+

	DISPLAY_Y								= 0x0000002C = %00000000.00000000.00000000.00101100 = 44
	DISPLAY_DY								= 0x00000010 = %00000000.00000000.00000001.00000000 = 256
	DISPLAY_DY >> 2							= 0x00000040 = %00000000.00000000.00000000.01000000 = 64
	(2*DISPLAY_DY)>>2						= 0x00000080 = %00000000.00000000.00000000.10000000 = 128

	(DISPLAY_Y+((2*DISPLAY_DY)>>2)					= $AC	 = %00000000.00000000.00000000.10101100 = 172
	((DISPLAY_Y+((2*DISPLAY_DY)>>2))<<8)			= $AC00  = %00000000.00000000.10101100.00000000
	((DISPLAY_Y+((2*DISPLAY_DY)>>2))<<8)!$0001		= $AC01  = %00000000.00000000.10101100.00000001
	
	move.w #((DISPLAY_Y+((3*DISPLAY_DY)>>2))<<8)!$0001,(a0)+
	((DISPLAY_Y+((2*DISPLAY_DY)>>2))<<8)!$0001		= $EC01  = %00000000.00000000.11101100.00000000
	
;------------------------------------------------------------------------------
; b)	
		
	dc.w $AC01,$FF00		; 4
	dc.w $0180,$0F00		; 4
	dc.w $EC01,$FF00		; 4
	dc.w $009C,$8020		; 4
	dc.w $ffff,$fffe		; 4	