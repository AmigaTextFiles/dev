****************************************************************************
*										*
*                  ****   DiskObject Support  ****				*
*										*
*	Author		René Eberhard						*
*	Version		0.20							*
*	Last Revision	11-Apr-93						*
*	Identifier	dobjs_defined						*
*       Prefix		dobjs_ (diskobjectsupport)				*
*                               ¯   ¯ ¯   ¯	         			*
*				 						*
*-----------------------------[ UPDATES ]----------------------------------*
*										*
*	-REB!	26.07.1992	Start this Project			   *
*	-REB!	11-Apr-93	Macro -> Routine / added some new features *
*										*
****************************************************************************
*---------------------------[ Functions ]----------------------------------*
*										*
* - GetDiskObject_WB, GetToolType						*
*										*
*---------------------------[ UPDATES ]------------------------------------*
*	    									*
*---------------------------[ COMMENT ]------------------------------------*
* - FreeDiskObject is NOT implemented, because it is to simple			*
*	    									*
****************************************************************************
;---------------------------------------------------------------------------
	IFND	dobjs_defined
dobjs_defined	SET	1


;---------------[ Some includes ]-------------------------------------------

	;INCLUDE	"special/DiskObjectSupport.i"
		
;---------------------------------------------------------------------------

	IFND	USE_NEWROUTINES
	NEED_	GetDiskObject_WB
	NEED_	GetDiskObject_CLI
	NEED_	GetToolType
	ENDIF
		
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : GetDiskObject_CLI							*
*										*
* SYNOPSIS: 									*
*       Result = GetDiskObject_CLI (Name)					*
*       D0.L                	    A0.L	   				*
*										*
* FUNCTION: Get the diskobject with a optional name.				*
*										*
* RESULT  : DiskObject or FALSE 						*
*										*
* COMMENT : This function takes the diskobject with a given name. 		*
*	    If there was a WB startup, it takes the diskobjekt via		*
*	    GetDiskObject_WB().		 					*
*	    CLI startup needs cws_homedir.					*
*	    Save the cli_CommandName before detaching.				*
*										*
****************************************************************************
	IFD	xxx_GetDiskObject_CLI
GetDiskObject_CLI:
	NEED_	GetDiskObject_WB

	tst.b	cws_wbstartup		;Startup from WB?
	bne.s	GetDiskObject_WB	;Yes, get diskobject via wbmsg

	PUSHM.L	d1-a6

	move.l	a0,a4			;Store name

	move.l	DosBase(PC),a6
	move.l	cws_homedir,d1		;Sorry for reloc
	JSRLIB_	CurrentDir		;CD homedir
	move.l	d0,-(SP)		;Store old lock

	move.l	a4,a0			;Restore Name

	move.l	IconBase(PC),a6		;IconBase
	JSRLIB_	GetDiskObject
	move.l	d0,a4			;Store DiskObject

	move.l	DosBase(PC),a6
	move.l	(SP)+,d1		;Restore old lock
	JSRLIB_	CurrentDir		;CD old dir

	move.l	a4,d0			;Restore DiskObject

\Exit:	POPM.L	d1-a6
	rts

	ENDC
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : GetDiskObject_WB							*
*										*
* SYNOPSIS: 									*
*       Result = GetDiskObject_WB ()						*
*       D0.L                			   				*
*										*
* FUNCTION: Get the diskobject.							*
*										*
* RESULT  : DiskObject or FALSE 						*
*										*
* COMMENT : This function takes the diskobject only if the program has		*
*	    been started from the workbench. 					*
*										*
*	    dc.b	cws_wbstartup,-1	;-1 for WB, 0 for CLI		*
*										*
****************************************************************************
	IFD	xxx_GetDiskObject_WB
GetDiskObject_WB:
	PUSHM.L	d1-a6

	tst.b	cws_wbstartup		;No WB startup
	beq.s	\Exit

	move.l	IconBase(PC),a6		;IconBase
	move.l	cws_wbmessage,d0		
	beq.s	\Exit			;No WB startup

	move.l	d0,a0
	move.l	sm_ArgList(a0),a0	;sm_ArgList 
	move.l	wa_Name(a0),d0		;Pointer to name
	beq.s	\Exit			;No name
	move.l	d0,a0			;Name into A0.L
	JSRLIB_	GetDiskObject

\Exit:	POPM.L	d1-a6
	rts

	ENDC
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : GetToolType								*
*										*
* SYNOPSIS: 									*
*       Value = FindToolType    (DiskObject,TypeName)				*
*       D0.L                     A0.L	    A1.L				*
*										*
* FUNCTION: Find the value of a ToolType variable.				*
*										*
* RESULT  : Pointer to string that is the value bound to TypeName		*
*           or FALSE if TypeName is not in the ToolTypeArray			*
*										*
****************************************************************************
	IFD	xxx_GetToolType
GetToolType:

	PUSHM.L	d1-a6
	move.l	IconBase(PC),a6		;IconBase
	move.l	do_ToolTypes(a0),a0	;Pointer to ToolTypeArray
	JSRLIB_	FindToolType
	POPM.L	d1-a6

		ENDC
;---------------------------------------------------------------------------


		ENDC
;---------------------------------------------------------------------------
