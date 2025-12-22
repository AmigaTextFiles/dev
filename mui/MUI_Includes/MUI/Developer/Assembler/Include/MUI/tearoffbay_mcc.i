	IFND	TEAROFFBAY_MCC_I
TEAROFFBAY_MCC_I	SET	1

**	Assembler version by Ilkka Lehtoranta (1 Dec 1999)

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

;#define MUIC_TearOffBay "TearOffBay.mcc"
;#define TearOffBayObject MUI_NewObject(MUIC_TearOffBay

MUIA_TearOffBay_LinkedBay 	EQU	$fa34ffd0
MUIA_TearOffBay_PrimaryBay	EQU	$fa34ffd1
MUIA_TearOffBay_Horiz		EQU	$fa34ffd2

	ENDC	; TEAROFFBAY_MCC_I