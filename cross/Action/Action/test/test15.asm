	.SECTION	"temps",$80
__TEMP_var0:	.DS	16
	.SECTION	"args",$a0
__ARGS:	.DS	16
	.SECTION	"code",$2000
_e:	.DS 2
aproc_ARG__a:	.DS 2
aproc_ARG__b:	.DS 2
aproc_ARG__c:	.DS 2
aproc:
	STA	aproc_ARG__a
	STX	aproc_ARG__a+1
	STY	aproc_ARG__a+2
	LDA	$A0+3
	STA	aproc_ARG__a+3
	LDA	$A0+4
	STA	aproc_ARG__a+4
	LDA	$A0+5
	STA	aproc_ARG__a+5
	JMP	aproc_Lab0
aproc_d:	.DS 2
aproc_Lab0:
	LDA	aproc_ARG__a+0
	CLC
	ADC	aproc_ARG__b+0
	STA	aproc_d+0
	LDA	aproc_ARG__a+1
	ADC	aproc_ARG__b+1
	STA	aproc_d+1
		;If Statement
	LDA	aproc_d+0
	SEC
	SBC	aproc_ARG__c+0
	LDA	aproc_d+1
	SBC	aproc_ARG__c+1
	BCC	aproc_Lab2
	LDA	#0
	BEQ	aproc_Lab3
aproc_Lab2:
	LDA	#1
aproc_Lab3:
	LDA	aproc_ARG__c+0
	SEC
	SBC	aproc_ARG__a+0
	LDA	aproc_ARG__c+1
	SBC	aproc_ARG__a+1
	BCC	aproc_Lab4
	LDA	#0
	BEQ	aproc_Lab5
aproc_Lab4:
	LDA	#1
aproc_Lab5:
	LDA	__TEMP_var0+0
	AND	__TEMP_var0+0
	BEQ	aproc_Lab6
	LDA	#1
	STA	_e+0
	LDA	#0
	STA	_e+1
	JMP	aproc_Lab1
aproc_Lab6:
	LDA	#0
	STA	_e+0
	LDA	#0
	STA	_e+1
aproc_Lab1:
	RTS
