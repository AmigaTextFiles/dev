*********************************************************************************
*										*
*                   ****   Tool Type support  ****				*
*										*
*	Author		René Eberhard						*
*	Version		0.34							*
*	Last Revision	12-May-93 11:34:57				        *
*	Identifier	ttys_defined						*
*       Prefix		ttys_ (tool type support)				*
*                              ¯    ¯¯   ¯	         			*
*				 						*
*-----------------------------[ UPDATES ]---------------------------------------*
*										*
*	-REB!	26.07.1992	Start this Project			        *
*	-REB!	11-Apr-93	Macro -> Routine / added some new features      *
*	-REB!	23-Apr-93	Prefix changed from dobjs_ to ttys_		*
*	-DAW!	12-May-93	FreeDiskObject added.				*
*										*
*********************************************************************************
*---------------------------[ Functions ]---------------------------------------*
*										*
* - GetDiskObject_WB, GetDiskObject_CLI, FreeDiskObject, GetToolType		*
*										*
*********************************************************************************
;---------------------------------------------------------------------------
	IFND	ttys_defined
ttys_defined	SET	1


;---------------[ Some includes ]-------------------------------------------

	INCLUDE	"ToolTypeSupport.i"
		
;---------------------------------------------------------------------------

	IFND	USE_NEWROUTINES
	NEED_	GetDiskObject_WB
;	NEED_	GetDiskObject_CLI
	NEED_	FreeDiskObject
	NEED_	GetToolType
	NEED_	GetTTConfig
	ENDIF
		
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : GetDiskObject_CLI							*
*										*
* SYNOPSIS: 									*
*       Result = GetDiskObject_CLI 						*
*       D0.L                	   	   					*
*										*
* FUNCTION: Get the diskobject from CLI.					*
*										*
* RESULT  : DiskObject or FALSE 						*
*										*
* COMMENT : This function takes the diskobject by a CLI startup. 		*
*	    CLI startup needs cws_homedir AND cws_clicmdname.			*
*	    If there was a WB startup, it jumps to GetDiskObject_WB		*
*	    DO NOT use this function, if you'll get a diskobject from		*
*	    another program. This function is comming soon.			*
*										*
*********************************************************************************
	IFD	xxx_GetDiskObject_CLI
GetDiskObject_CLI:
	NEED_	GetDiskObject_WB

	tst.b	cws_wbstartup
	bne.s	GetDiskObject_WB	;Handle diskobject by WB startup

	PUSHM.L	d1-a6

	move.l	DosBase(PC),a6
	move.l	cws_homedir(PC),d1	;cws_homedir from startup
	JSRLIB_	CurrentDir		;CD homedir
	move.l	d0,-(SP)		;Store old lock

	move.l	cws_clicmdname(PC),a0	;Name

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
*********************************************************************************
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
* COMMENT : This function takes the diskobject only, if the program has		*
*	    been started from the workbench. 					*
*										*
*	    dc.b	cws_wbstartup,-1	;-1 for WB, 0 for CLI		*
*										*
*********************************************************************************
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
*********************************************************************************
*										*
* NAME    : FreeDiskObject  							*
*										*
* SYNOPSIS: 									*
*       FreeDiskObject(diskobject)  						*
*                         D0.L			   				*
*										*
* FUNCTION: Free the diskobject returned by GetDiskObject_#?.			*
*										*
* RESULT  : none (d0 set to zero)                                               *
*										*
*********************************************************************************
	IFD	xxx_FreeDiskObject
FreeDiskObject:
	movem.l	d1/a0-a1/a6,-(a7)
	move.l	d0,a0
	move.l	a0,d0
	beq.s	.out
	move.l	IconBase(pc),a6
	JSRLIB_	FreeDiskObject
.out:	movem.l	(a7)+,d1/a0-a1/a6
	rts
	ENDC



;---------------------------------------------------------------------------
*********************************************************************************
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
*********************************************************************************
	IFD	xxx_GetToolType
GetToolType:

	PUSHM.L	d1-a6

	move.l	IconBase(PC),a6		;IconBase
	move.l	do_ToolTypes(a0),a0	;Pointer to ToolTypeArray
	JSRLIB_	FindToolType

	POPM.L	d1-a6
	rts
		ENDC
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* NAME    : GetTTConfig								*
*										*
* SYNOPSIS: 									*
*       GetTTConfig   (DiskObject,MacroList)					*
*                      A0.L	  A1.L						*
*										*
* FUNCTION: Initialze a complete user configuration				*
*										*
* RESULT  : none								*
*										*
*********************************************************************************
	IFD	xxx_GetTTConfig
GetTTConfig:

	PUSHM.L	d0-a6

	link    a5,#ttyg_SIZEOF

	move.l	a0,ttyg_DiskObject(a5)
	move.l	a1,ttyg_MacroList(a5)	;Store macrolist

;---------------
;---------------[ Get ID and JMP to the required routine ]------------------
;---------------

\MasterLoop:
	move.l	ttyg_MacroList(a5),a1	;Get actiual position in macrolist
	move.b	(a1)+,d0		;Get Identifier -> Pointer to string
	ext.w	d0
	cmp.w	#ttys_MAXID,d0
	bgt.s	\Rtn			;Invalid ID
	lea	\JmpTable(PC),a2
	jmp	(a2,d0.W)

\Rtn:	unlk	a5
	POPM.L	d0-a6
	rts

;---------------------------------------------------------------------------
*********************************************************************************
*										*
* SET										*
*										*
*********************************************************************************
\Set:
	move.l	a1,ttyg_String(a5)	;Store string

	bsr	\GetNextString		;Get pointer to true string
	move.l	a1,ttyg_Addition1(a5)	;Store true string
	
	bsr	\GetLable		;Get lable
	move.l	a1,ttyg_Lable(a5)	;Store lable

	addq.l	#4,a1
	move.l	a1,ttyg_MacroList(a5)	;Pointer to next entry

	bsr	\GetTTEntry		;Look out for required string
	tst.l	d0
	beq	\MasterLoop		;Entry not in tool type list -> Continue

	move.l	IconBase(PC),a6		;IconBase
	move.l	d0,a0			;TypeString
	move.l	ttyg_Addition1(a5),a1	;True string
	JSRLIB_	MatchToolValue
	tst.l	d0
	beq	\MasterLoop		;True string not in TypeString -> Continue

	move.l	ttyg_Lable(a5),a0
	move.l	(a0),a0
	move.b	#-1,(a0)		;Set TRUE	

	bra	\MasterLoop		;-> Continue
	
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* CLR										*
*										*
*********************************************************************************
\Clr:
	move.l	a1,ttyg_String(a5)	;Store string

	bsr	\GetNextString		;Get pointer to false string
	move.l	a1,ttyg_Addition1(a5)	;Store false string
	
	bsr	\GetLable		;Get lable
	move.l	a1,ttyg_Lable(a5)	;Store lable

	addq.l	#4,a1
	move.l	a1,ttyg_MacroList(a5)	;Pointer to next entry

	bsr	\GetTTEntry		;Look out for required string
	tst.l	d0
	beq	\MasterLoop		;Entry not in tool type list -> Continue

	move.l	IconBase(PC),a6		;IconBase
	move.l	d0,a0			;TypeString
	move.l	ttyg_Addition1(a5),a1	;True string
	JSRLIB_	MatchToolValue
	tst.l	d0
	beq	\MasterLoop		;True string not in TypeString -> Continue

	move.l	ttyg_Lable(a5),a0
	move.l	(a0),a0
	clr.b	(a0)			;Set FALSE

	bra	\MasterLoop		;-> Continue
	
;---------------------------------------------------------------------------
*********************************************************************************
*										*
* STRING									*
*										*
*********************************************************************************
\String:
	move.l	a1,ttyg_String(a5)	;Store string
	
	bsr	\GetLable		;Get lable
	move.l	a1,ttyg_Lable(a5)	;Store lable

	addq.l	#4,a1
	move.l	a1,ttyg_MacroList(a5)	;Pointer to next entry

	bsr	\GetTTEntry		;Look out for required string
	tst.l	d0
	beq	\MasterLoop		;Entry not in tool type list -> Continue

	move.l	ttyg_Lable(a5),a0
	move.l	(a0),a0
	move.l	d0,(a0)			;Put pointer to string into lable

	bra	\MasterLoop		;-> Continue

;---------------------------------------------------------------------------
*********************************************************************************
*										*
* INTEGER									*
*										*
*********************************************************************************
\Integer:
	move.l	a1,ttyg_String(a5)	;Store string
	
	bsr	\GetLable		;Get lable
	move.l	a1,ttyg_Lable(a5)	;Store lable

	addq.l	#6,a1
	move.l	a1,ttyg_MacroList(a5)	;Pointer to next entry

	bsr	\GetTTEntry		;Look out for required string
	tst.l	d0
	beq	\MasterLoop		;Entry not in tool type list -> Continue

	move.l	DosBase(PC),a6
	move.l	d0,d1			;String from ToolType
	subq.l	#4,a7			;Reserve one longword from stack
	move.l	a7,d2			;Pointer to long word...
	JSRLIB_	StrToLong

	move.l	(a7)+,d2		;Value from StrToLong()
	move.l	ttyg_Lable(a5),a2
	move.l	(a2),a2			;Pointer to lable
	move.l	ttyg_MacroList(a5),a0
	move.w	-2(a0),d1		;Get BYTE, WORD, LONGWORD

	subq.w	#1,d1
	bmi.s	.long
	bne.s	.word
.byte:	move.b	d2,(a2)			;byte
	bra	\MasterLoop		;-> Continue
.word:	move.w	d2,(a2)			;word
	bra	\MasterLoop		;-> Continue
.long:	move.l	d2,(a2)			;long
	bra	\MasterLoop		;-> Continue

;---------------------------------------------------------------------------
*********************************************************************************
*										*
* HEX										*
*										*
*********************************************************************************
\Hex:

	bra	\MasterLoop		;-> Continue

;---------------------------------------------------------------------------
*********************************************************************************
*										*
* SWITCH									*
*										*
*********************************************************************************
\Switch:
	move.l	a1,ttyg_String(a5)	;Store string
	
	bsr	\GetLable		;Get lable
	move.l	a1,ttyg_Lable(a5)	;Store lable

	addq.l	#4,a1
	move.l	a1,ttyg_MacroList(a5)	;Pointer to next entry

	bsr	\GetTTEntry		;Look out for required string
	tst.l	d0
	beq	\MasterLoop		;Entry not in tool type list -> Continue

	move.l	ttyg_Lable(a5),a0
	move.l	(a0),a0

	not.b	(a0)			;Switch
	bra	\MasterLoop		;-> Continue

;---------------------------------------------------------------------------

;---------------[ GetNextString ]-------------------------------------------

\GetNextString:
	tst.b	(a1)+
	bne.s	\GetNextString
	rts

;---------------[ GetLable ]------------------------------------------------

\GetLable:
	bsr	\GetNextString		;Get end of string
	cmp.b	#ttys_LABLEID,(a1)	;Is there an EVEN mark?
	bne.s	\NoM			;No EVEN mark
	addq.l	#1,a1	
\NoM:	rts

;---------------[ GetTTEntry ]----------------------------------------------

\GetTTEntry:
	move.l	IconBase(PC),a6		;IconBase
	move.l	ttyg_DiskObject(a5),a0
	move.l	do_ToolTypes(a0),a0	;Pointer to ToolTypeArray
	move.l	ttyg_String(a5),a1
	JSRLIB_	FindToolType

	rts

;---------------------------------------------------------------------------

\JmpTable:	bra.w	\Rtn
		bra.w	\Set
		bra.w	\Clr
		bra.w	\String
		bra.w	\Integer
		bra.w	\Hex			;Not implemented yet!
		bra.w	\Switch


			FORESET
ttyg_DiskObject:	FO.L	1
ttyg_MacroList:		FO.L	1
ttyg_String:		FO.L	1
ttyg_Lable:		FO.L	1
ttyg_Addition1:		FO.L	1	;e.g for "True string"
ttyg_SIZEOF		FOVAL

		ENDC

;---------------------------------------------------------------------------
		ENDC
;---------------------------------------------------------------------------
