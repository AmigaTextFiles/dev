	IFND	INFOTEXT_MCC_I
INFOTEXT_MCC_I	SET	1

**
** $VER: InfoText_mcc.h V15.3
** Copyright © 1997 Benny Kjær Nielsen. All rights reserved.
**
** Assembler version by Ilkka Lehtoranta (1 Dec 1999)

*** Include stuff ***

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC

	IFND	BENNY_SERIAL
BENNY_SERIAL	EQU	(31991<<16)
	ENDC

*** MUI Defines ***

;#define MUIC_InfoText "InfoText.mcc"
;#define InfoTextObject MUI_NewObject(MUIC_InfoText

*** Methods ***
MUIM_InfoText_TimeOut	EQU	(TAG_USER | BENNY_SERIAL | $0101 )

*** Attributes ***
MUIA_InfoText_Contents		EQU	(TAG_USER | BENNY_SERIAL | $0110 )
MUIA_InfoText_ExpirationPeriod	EQU	(TAG_USER | BENNY_SERIAL | $0111 )
MUIA_InfoText_FallBackText	EQU	(TAG_USER | BENNY_SERIAL | $0112 )


	ENDC	; INFOTEXT_MCC_I
