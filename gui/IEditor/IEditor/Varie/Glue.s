		xdef    _LoadGUI
_LoadGUI        movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _LoaderBase,a6
		jsr     _LVOLoadGUI(a6)
		movem.l (sp)+,a0-a1/a6
		rts

		xdef    _LoadScreen
_LoadScreen     movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _LoaderBase,a6
		jsr     _LVOLoadScreen(a6)
		movem.l (sp)+,a0-a1/a6
		rts

		xdef    _LoadGadgets
_LoadGadgets    movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _LoaderBase,a6
		jsr     _LVOLoadGadgets(a6)
		movem.l (sp)+,a0-a1/a6
		rts

		xdef    _LoadWindows
_LoadWindows    movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _LoaderBase,a6
		jsr     _LVOLoadWindows(a6)
		movem.l (sp)+,a0-a1/a6
		rts


		xdef    _OpenFiles
		xdef    _CloseFiles
		xdef    _WriteHeaders
		xdef    _WriteVars
		xdef    _WriteStrings
		xdef    _WriteData
		xdef    _WriteChipData
		xdef    _WriteCode
		xdef    _Config


_OpenFiles      movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _GenBase,a6
		jsr     _LVOOpenFiles(a6)
		movem.l (sp)+,a0-a1/a6
		rts

_CloseFiles     movem.l a0/a6,-(sp)
		move.l  12(sp),a0
		move.l  _GenBase,a6
		jsr     _LVOCloseFiles(a6)
		movem.l (sp)+,a0/a6
		rts

_WriteHeaders   movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _GenBase,a6
		jsr     _LVOWriteHeaders(a6)
		movem.l (sp)+,a0-a1/a6
		rts

_WriteVars      movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _GenBase,a6
		jsr     _LVOWriteVars(a6)
		movem.l (sp)+,a0-a1/a6
		rts

_WriteStrings   movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _GenBase,a6
		jsr     _LVOWriteStrings(a6)
		movem.l (sp)+,a0-a1/a6
		rts

_WriteData      movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _GenBase,a6
		jsr     _LVOWriteData(a6)
		movem.l (sp)+,a0-a1/a6
		rts

_WriteChipData  movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _GenBase,a6
		jsr     _LVOWriteChipData(a6)
		movem.l (sp)+,a0-a1/a6
		rts

_WriteCode      movem.l a0-a1/a6,-(sp)
		movem.l 16(sp),a0-a1
		move.l  _GenBase,a6
		jsr     _LVOWriteCode(a6)
		movem.l (sp)+,a0-a1/a6
		rts

_Config         movem.l a0/a6,-(sp)
		move.l  12(sp),a0
		move.l  _GenBase,a6
		jsr     _LVOConfig(a6)
		movem.l (sp)+,a0/a6
		rts

