	.SECTION	"temps",$80
__TEMP_var0:	.DS	16
	.SECTION	"args",$a0
__ARGS:	.DS	16
	.SECTION	"code",$2000
_c:	.DS 2
_pc:	.DS 2
_ac:	.DS 32
main:
	LDA	#6
	STA	_c+0
	LDA	#0
	STA	_c+1
	LDA	#<_c
	STA	__TEMP_var0+0
	LDA	#>_c
	STA	__TEMP_var0+1
	LDA	__TEMP_var0+0
	STA	_pc+0
	LDA	__TEMP_var0+1
	STA	_pc+1
	LDA	#7
	ASL	A
	PHP
	CLC
	ADC	_ac+0
	STA	__TEMP_var0+0
	LDA	#0
	ROL	A
	PLP
	ADC	_ac+1
	STA	__TEMP_var0+1
	LDA	_pc+0
	STA	__TEMP_var2+0
	LDA	_pc+1
	STA	__TEMP_var2+1
	LDY	#0
	LDA	(__TEMP_var2),Y
	STA	(__TEMP_var0),Y
	INY
	LDA	(__TEMP_var2),Y
	STA	(__TEMP_var0),Y
	RTS
