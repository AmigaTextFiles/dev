	XDEF	UpCaseStr
	
UpCaseStr:
	cmpi.b	#0,(A0)+
	beq.s	.Exit

	cmpi.b	#'a',-1(A0)
	bcs.s	UpCaseStr

	cmpi.b	#'z'+1,-1(A0)
	bcc.s	UpCaseStr

	andi.b	#223,-1(A0)
	bra.s	UpCaseStr

.Exit	rts


	SECTION	,DATA

	XDEF	CTemplate
        XDEF    Template
	XDEF	CDirectives
	XDEF	Directives
	XDEF	FNameEnd
	XDEF	FDPath
	XDEF	Banner
	
CSI	EQU	$9B

CTemplate	dc.b	','
Template        dc.b    'FILENAME/A,NOTAB/S,NOHEADER/S,NOBASE/S,NOPRIVATE/S: ',0

CDirectives	dc.b	','
Directives	dc.b	'##BASE,##BIAS,##PRIVATE,##PUBLIC,##END.',0

FNameEnd	dc.b	'_lib.fd',0
FDPath		dc.b	'fd:',0

Banner		dc.b	CSI,'1mLVODump 1.0',CSI,'0m © Marco Favaretto 1995',$0A
		dc.b	'Usage: LVODump <.fd file> [NOTAB] [NOHEADER] [NOBASE] [NOPRIVATE]',0
		