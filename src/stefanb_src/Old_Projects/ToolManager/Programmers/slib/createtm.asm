
		IFD BARFLY
		 CODE
		 SMALLDATA a4
		ELSE
		 CSECT text,0
		ENDC

		XREF _ToolManagerBase
		XREF _LVOCreateTMObjectTagList

		XDEF _CreateTMObjectTags
_CreateTMObjectTags:
		movem.l a2/a6,-(sp)

		lea 24(sp),a2
		bra.s Common

		XDEF _CreateTMObjectTagList
_CreateTMObjectTagList:
		movem.l a2/a6,-(sp)

		move.l 24(sp),a2
Common:		move.l _ToolManagerBase(a4),a6
		movem.l 12(sp),a0/a1
		move.l 20(sp),d0
		jsr _LVOCreateTMObjectTagList(a6)

		movem.l (sp)+,a2/a6
		rts

		END
