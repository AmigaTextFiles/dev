;*************************************************************************
;**
;** FlexRev revproto for usage with 'dasm'
;**
;******
	MAC	date
	dc.b	"(${DATE})"
	ENDM

	MAC	verrev
	dc.b	"${VERREV}"
	ENDM
