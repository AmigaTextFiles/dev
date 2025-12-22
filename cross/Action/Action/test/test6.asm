	.SECTION	"temps",$80
__TEMP_var0:	.DS	16
	.SECTION	"args",$a0
__ARGS:	.DS	16
	.SECTION	"code",$2000
_PONE:	.DS 2
_A:	.DS 1
_B:	.DS 1
_C:	.DS 1
_D:	.DS 1
APROC:
	LDA	#<_A
	STA	__TEMP_var0+0
	LDA	#>_A
	STA	__TEMP_var0+1
	LDA	__TEMP_var0+0
	STA	_PONE+0
	LDA	#5
	STA	_A+0
	LDA	_PONE+0
	STA	__TEMP_var0+0
	LDA	_PONE+1
	STA	__TEMP_var0+1
	LDY	#0
	LDA	(__TEMP_var0),Y
	STA	_B+0
	RTS
