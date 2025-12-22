VERSION		EQU	0
REVISION	EQU	5
DATE	MACRO
		dc.b	'12.7.98'
	ENDM
VERS	MACRO
		dc.b	'KaliosisQuantrum 0.5'
	ENDM
VSTRING	MACRO
		dc.b	'KaliosisQuantrum 0.5 (12.7.98)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: KaliosisQuantrum 0.5 (12.7.98)',0
	ENDM
