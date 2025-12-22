		INCLUDE "exec/types.i"
		INCLUDE	"exec/nodes.i"
		INCLUDE "exec/resident.i"

		INCLUDE	"wpad.library_rev.i"

		XREF	LibInitTab

		SECTION	text,CODE

		CNOP	4

		MOVEQ	#0,D0		; word
		RTS			; word

RomTag:		DC.W	RTC_MATCHWORD
		DC.L	RomTag
		DC.L	EndTag
		DC.B	RTF_AUTOINIT	; yet auto-init
		DC.B	VERSION		; version
		DC.B	NT_LIBRARY
		DC.B	0		; priority
		DC.L	LibName
		DC.L	LibID
		DC.L	LibInitTab	; ptr to init table

EndTag:		VERSTAG

		XREF	_BSSBAS
		XREF	_BSSLEN

		dc.l	_BSSBAS
		dc.l	_BSSLEN

		XDEF	LibName

LibName:	dc.b	'wpad.library',0
		CNOP	4

		XDEF	LibID

		IFND	CPU_ANY
LibID:		dc.b	'030 '
		VSTRING
		ELSE
LibID:		VSTRING
		ENDC

		CNOP	4

		XDEF	LibVersion
		XDEF	LibRevision

LibVersion:	dc.l	VERSION
LibRevision:	dc.l	REVISION

		END
