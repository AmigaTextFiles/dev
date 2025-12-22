
		IFD BARFLY
		 CODE
		 SMALLDATA a4
		ELSE
		 CSECT text,0
		ENDC

		XREF _ToolManagerBase
		XREF _LVOFreeTMHandle

		XDEF _FreeTMHandle
_FreeTMHandle:
		move.l a6,-(sp)

		move.l _ToolManagerBase(a4),a6
		move.l 8(sp),a0
		jsr _LVOFreeTMHandle(a6)

		move.l (sp)+,a6
		rts

		END
