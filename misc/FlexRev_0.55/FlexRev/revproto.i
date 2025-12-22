;*************************************************************************
;**
;** FlexRev revproto for usage with ASM
;**
;******
DATE	MACRO
	dc.b	'(${DATE})'
	ENDM

VERREV	MACRO
	dc.b	'${VERREV}'
	ENDM
