
		IFD BARFLY
		 CODE
		 SMALLDATA a4
		ELSE
		 CSECT text,0
		ENDC

		XREF _ToolManagerBase
		XREF _LVOAllocTMHandle

		XDEF _AllocTMHandle
_AllocTMHandle:
		move.l a6,-(sp)

		move.l _ToolManagerBase(a4),a6
		jsr _LVOAllocTMHandle(a6)

		move.l (sp)+,a6
		rts

		END
