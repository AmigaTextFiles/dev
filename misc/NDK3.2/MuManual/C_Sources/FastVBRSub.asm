	xref _MMUBase
	xref _SysBase

	machine mc68010

Supervisor			=	-30
WithoutMMU                      =       -270
KickMemPtr			=	$222

	section TEXT,code

	xdef _CopyMMULess
_CopyMMULess:
	movem.l a5-a6,-(a7)
	move.l _MMUBase(a4),a6
	lea __CopyCode(pc),a5
	jsr WithoutMMU(a6)
	movem.l (a7)+,a5-a6
	rts

__CopyCode:
	move.b (a0)+,(a1)+
	subq.l #1,d0
	bne.s __CopyCode
	rts


	xdef _GetVBR
_GetVBR:
	movem.l a5-a6,-(a7)
	move.l _SysBase(a4),a6
	lea __GetVBR(pc),a5
	jsr Supervisor(a6)
	movem.l (a7)+,a5-a6
	rts
__GetVBR:
	movec.l vbr,d0
	rte

	xdef _SetVBR
_SetVBR:
	movem.l a5-a6,-(a7)
	move.l _SysBase(a4),a6
	lea __SetVBR(pc),a5
	jsr Supervisor(a6)
	movem.l (a7)+,a5-a6
	rts
__SetVBR:
	movec.l a0,vbr
	rte

	xdef _NewSumKickData
_NewSumKickData:
	movem.l d2-d4/a5-a6,-(a7)

	move.l -4+_NewSumKickData(pc),a0	;get the old entry point
	jsr (a0)				;call it
	move.l d0,d4				;keep the new checksum
	move.l a6,a0
	lea _InstallIntoCopy(pc),a5
	move.l -8+_NewSumKickData(pc),a6	;MMUBase
	movem.l KickMemPtr(a0),d2-d3		;read other data
	jsr WithoutMMU(a6)

	move.l d4,d0				;proper return code
	movem.l (a7)+,d2-d4/a5-a6
	rts

_InstallIntoCopy:				;move the data into the original code
	movem.l d2-d4,KickMemPtr(a0)
	rts
	nop
	xdef _NewSumKickDataEnd
_NewSumKickDataEnd:
	rts
