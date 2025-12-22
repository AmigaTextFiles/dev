_LVOMUIE_MakeObjects		EQU	-30
_LVOMUIE_MakeMethods		EQU	-36
_LVOMUIE_SetAttrs			EQU	-42
_LVOMUIE_GetAttr			EQU	-48
_LVOMUIE_Main				EQU	-54
_LVOMUIE_MakeAll			EQU	-60
_LVOMUIE_DisposeObjects	EQU	-66

CALLMUIEXTEND	MACRO
	movea.l	_MUIExtendBase,a6
	jsr		_LVO\1(a6)
	ENDM
MUIEXTEND_VMIN	EQU	0
MUIEXTEND_NAME	MACRO
	dc.b		'muiextend.library',0
	ENDM

