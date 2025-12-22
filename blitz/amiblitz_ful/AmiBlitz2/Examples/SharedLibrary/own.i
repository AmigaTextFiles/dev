		STRUCTURE LibraryBase,LIB_SIZE
		UBYTE   libb_Flags			; kirjaston liput
		UBYTE   libb_pad			; alignment
		ULONG   libb_SysLib			; ExecBase
		ULONG   libb_SegList			; SegList-osoitin
		LABEL LibraryBase_SIZEOF		; struktuurin koko

LIBRARYNAME	macro
		dc.b	'own.library',0			; Library name
		endm

