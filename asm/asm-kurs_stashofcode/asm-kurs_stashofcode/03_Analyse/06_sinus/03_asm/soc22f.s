
; soc22g.s
; Bitplane - Zirkulation

start:
	moveq	#4,d4
zirk:		
	move.l bitplaneA,d0
	move.l bitplaneB,d1
	move.l bitplaneC,d2
	move.l d1,bitplaneA
	move.l d2,bitplaneB
	move.l d0,bitplaneC
	dbf d4,zirk
	nop
	rts
	
bitplaneA:				DC.L $A
bitplaneB:				DC.L $B
bitplaneC:				DC.L $C

	end

;------------------------------------------------------------------------------

d0 = A , B , C , A
d1 = B , C , A , B
d2 = C , A , B , C

