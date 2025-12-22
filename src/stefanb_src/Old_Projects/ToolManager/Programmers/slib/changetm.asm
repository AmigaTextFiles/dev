
		IFD BARFLY
		 CODE
		 SMALLDATA a4
		ELSE
		 CSECT text,0
		ENDC

		XREF _ToolManagerBase
		XREF _LVOChangeTMObjectTagList

		XDEF _ChangeTMObjectTags
_ChangeTMObjectTags:
		movem.l a2/a6,-(sp)

		lea 20(sp),a2
		bra.s Common

		XDEF _ChangeTMObjectTagList
_ChangeTMObjectTagList:
		movem.l a2/a6,-(sp)

		move.l 20(sp),a2
Common:		move.l _ToolManagerBase(a4),a6
		movem.l 12(sp),a0/a1
		jsr _LVOChangeTMObjectTagList(a6)

		movem.l (sp)+,a2/a6
		rts

		END
