 *
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Orginal written by Stefan Zeiger in 1993-1994
 *
 *  Translated to assembly language by Oskar Liljeblad in 1994
 *
 *  (c) 1993-1994 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 *  trLogo.asm - The Triton logo
 *
 *

******* Included Files *************************************************

	NOLIST
	INCLUDE	"exec/types.i"
	INCLUDE "exec/libraries.i"
	INCLUDE "exec/funcdef.i"
	INCLUDE "exec/exec_lib.i"
	INCLUDE "dos/dos.i"
	INCLUDE "dos/dos_lib.i"
	INCLUDE "libraries/triton.i"
	INCLUDE "libraries/triton_lib.i"
	LIST

******* MACROS *********************************************************

CALLSYS MACRO
        CALLLIB _LVO\1
        ENDM

******* Imported *******************************************************

	XREF _SysBase
	XREF _DOSBase

	XREF @TRIM_trLogo_Init
	XREF @TRIM_trLogo_Free
	XREF _TRIM_trLogo

	XREF _LVOPutStr

******* Exported *******************************************************

	XDEF _main

******* Code ***********************************************************

	SECTION	trLogo,CODE

_main	MOVE.L	_SysBase,A6			; Open triton.library
	MOVEQ	#TRITON11VERSION,D0
	LEA	TritonName(PC),A1
	CALLSYS	OpenLibrary
	MOVE.L	D0,_TritonBase
	BNE.S	createApp

	MOVE.L	_DOSBase,A6			; Print error
	LEA	openTritonError(PC),A0
	MOVE.L	A0,D1
	CALLSYS	PutStr
	BRA	exit

createApp					; Create our application
	MOVE.L	D0,A6
	LEA	appTags(pc),A1
	CALLSYS	TR_CreateApp
	MOVE.L	D0,___Triton_Support_App
	BEQ	closeTriton	

	JSR	@TRIM_trLogo_Init		; Initialize the triton logo
	TST.L	D0
	BEQ	deleteApp

	MOVE.L	_TRIM_trLogo,logoPlace

	MOVE.L	___Triton_Support_App(PC),A1	; Open our window (requester)
	MOVE.L	#0,A0
	LEA	projectTags(PC),A2
	CALLSYS	TR_AutoRequest
	TST.L	D0
	BEQ	freeLogo

closeProject
	MOVE.L	#RETURN_OK,rc
freeLogo					; Free the triton logo
	JSR	@TRIM_trLogo_Free
deleteApp					; Remove our application
	MOVE.L	___Triton_Support_App,A1
	CALLSYS TR_DeleteApp
closeTriton					; Close triton.library
	MOVE.L	_SysBase,A6
	MOVE.L	_TritonBase,A1
	CALLSYS	CloseLibrary

exit	MOVE.L	rc(pc),d0
	RTS

******* Data ***********************************************************

_TritonBase	DC.L	0			; triton.library base

___Triton_Support_App				; Our application
		DC.L	0			;  (struct TR_App *)

rc		DC.L	RETURN_FAIL		; Return code storage

projectTags	WindowID	1			; Tags for the
		WindowPosition	TRWP_CENTERDISPLAY	;  window/
		WindowTitle	appName			;  requester
		WindowFlags	TRWF_NOMINTEXTWIDTH
		DC.L	TROB_Image			; BoopsiImageD
logoPlace	DC.L	0
		DC.L	TRAT_MinWidth,57
		DC.L	TRAT_MinHeight,57
		DC.L	TRAT_Flags,TRIM_BOOPSI
		EndProject

appTags		DC.L	TRCA_Name,appName	; Application tags
		DC.L	TRCA_LongName,appName
		DC.L	TRCA_Info,appInfo
		DC.L	TRCA_Version,appVersion
		DC.L	TAG_END

TritonName	TRITONNAME			; 'triton.library'

openTritonError	DC.B	'Can''t open triton.library v2+.',0

appName		DC.B	'trLogo',0
appInfo		DC.B	'The Triton Logo',0
appVersion	DC.B	'1.0',0

	END
