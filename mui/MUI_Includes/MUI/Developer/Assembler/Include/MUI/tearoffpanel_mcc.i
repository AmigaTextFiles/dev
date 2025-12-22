	IFND	TEAROFFPANEL_MCC_I
TEAROFFPANEL_MCC_I	SET	1

**	Assembler version by Ilkka Lehtoranta (1 Dec 1999)

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

;#define MUIC_TearOffPanel "TearOffPanel.mcc"
;#define TearOffPanelObject MUI_NewObject(MUIC_TearOffPanel

MUIA_TearOffPanel_State		EQU	$fa34ffc0
MUIA_TearOffPanel_Contents	EQU	$fa34ffc1
MUIA_TearOffPanel_Label		EQU	$fa34ffc4
MUIA_TearOffPanel_Bay		EQU	$fa34ffc3
MUIA_TearOffPanel_Horiz		EQU	$fa34ffc5
MUIA_TearOffPanel_CanFlipShape	EQU	$fa34ffc6
MUIA_TearOffPanel_WindowTags	EQU	$fa34ffc8

MUIV_TearOffPanel_State_Fixed	EQU	0
MUIV_TearOffPanel_State_Torn	EQU	1
MUIV_TearOffPanel_State_Hidden	EQU	2
MUIV_TearOffPanel_State_Cycle	EQU	999

	ENDC	; TEAROFFPANEL_MCC_I
