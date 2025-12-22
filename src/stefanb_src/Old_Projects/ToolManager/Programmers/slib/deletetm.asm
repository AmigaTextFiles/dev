
		IFD BARFLY
		 CODE
		 SMALLDATA a4
		ELSE
		 CSECT text,0
		ENDC

		XREF _ToolManagerBase
		XREF _LVODeleteTMObject

		XDEF _DeleteTMObject
_DeleteTMObject:
		move.l a6,-(sp)

		move.l _ToolManagerBase(a4),a6
		movem.l 8(sp),a0/a1
		jsr _LVODeleteTMObject(a6)

		move.l (sp)+,a6
		rts

		END
