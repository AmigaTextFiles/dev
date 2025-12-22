****************************************************************************
*										*
*                   ****   GadgetGroup Support.i  ****				*
*										*
*	Author		René Eberhard						*
*	Version		0.1							*
*	Last Revision	Sunday 03-Oct-93 12:20:30				*
*	Identifier	gdgs_defined						*
*       Prefix		gdgs_  (gadgetgroup support)				*
*		     	        ¯ ¯   ¯     ¯					*
*-----------------------------[ UPDATES ]----------------------------------*
*										*
*	-REB!	03-Oct-93	Start this Project			   *
*										*
*-----------------------------[ COMMENT ]----------------------------------*
*										*
* This supportfile works only together with GTFace (© Sefan Walter)		*
*										*
****************************************************************************
****************************************************************************
*---------------------------[ Functions ]----------------------------------*
*										*
* - HandleGadgetGroups								*
*										*
****************************************************************************
;---------------------------------------------------------------------------
	IFND	gdgs_defined
gdgs_defined	SET	1


;---------------[ Some includes ]-------------------------------------------

	INCLUDE	"special/GadgetGroupSupport.i"
		
;---------------------------------------------------------------------------

	IFND	USE_NEWROUTINES
	NEED_	HandleGadgetGroups
	ENDIF
		
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : HandleGadgetGroups							*
*										*
* SYNOPSIS: 									*
*       Result = HandleGadgetGroups (GroupList,WindowKey,Group)			*
*       D0.L                         A0.L      A1.L	 D0.W			*
*										*
* FUNCTION: Handles gadgetgroups						*
*										*
* RESULT  : TRUE or FALSE 							*
*										*
****************************************************************************
	IFD	xxx_HandleGadgetGroups
HandleGadgetGroups:

	PUSHM.L	d1-a6

	link    a5,#gdgs_SIZEOF

	move.l	a0,gdgs_GroupList(a5)	;Store parameters
	move.l	a1,gdgs_WindowKey(a5)

;---------------[ Search required group ]-----------------------------------

	move.l	d0,d1			;Group into D1.L
	moveq	#0,d0			;Result = FAIL

\GLoop:	cmp.l	#gdgs_GROUPSTART_ID,(a0)+
	bne.s	\Rtn			;There in no valid group -> Exit

	cmp.w	(a0)+,d1		;Is this the required group?	
	beq.s	\Group			;Yes

\ELoop:	cmp.l	#gdgs_GROUPEND_ID,(a0)	;Is there a gdgs_GROUPEND_ID
	beq.s	\NextG			;Yes, search next group
	addq.l	#2,a0
	bra.s	\ELoop

\NextG:	addq.l	#4,a0			;Pointer to a possible gdgs_GROUPSTART_ID
	tst.l	(a0)			;End of grouplist?
	beq.s	\Rtn			;Yes, group not found -> FAIL

	bra.s	\GLoop			;Continue searching in the list

;---------------[ Handle group ]--------------------------------------------

\Group:	move.l	a0,a4				;Put group into A4.L

	cmp.l	#gdgs_NEWGADGET_ID,(a4)+	;Is there an ewn gadget?
	bne.s	\Rtn				;No -> Fail

\NewGg:	move.w	(a4)+,gdgs_Gadget(a5)		;Store gadget identifier

\SetGg:	move.l	gdgs_WindowKey(a5),a2		;Get WindowKey
	move.w	gdgs_Gadget(a5),d0		;Get gadget
	CALL_	FindGadget
	tst.l	d0
	beq.s	\Rtn

	move.l	d0,a0				;Gadget
	move.l	gdgs_WindowKey(a5),a2		;Get WindowKey
	bsr	\GetTagData			;Tagdata handler
	CALL_	SetGadgetTag			;Set gadget

	cmp.l	#gdgs_GROUPEND_ID,(a4)		;End of grouplist?
	beq.s	\Exit

	cmp.l	#gdgs_NEWGADGET_ID,(a4)		;End of gadget?
	bne.s	\SetGg				;Continue with setting gadgets

	addq.l	#4,a4				;Leave out gdgs_NEWGADGET_ID
	bra.s	\NewGg				;There is a new gadget
		
;---------------[ Exit HandleGadgetGroups ]---------------------------------

\Exit:	moveq	#-1,d0				;Flag for TRUE

\Rtn:	unlk	a5
	POPM.L	d1-a6
	rts
		
;---------------------------------------------------------------------------
****************************************************************************
*										*
* SUBFUNCTION : \GetTagData()							*
*										*
****************************************************************************

\GetTagData:
	move.l	(a4)+,d1			;Tag identifier

	lea	\SpecialTagList(PC),a3

\TLoop:	move.l	(a3)+,d0			;Get special tags
	beq.s	\Def				;No more tags left -> default handling

	cmp.l	d0,d1				;Is it a special tag
	beq.s	\Indi				;Yes -> indirect handling

	bra.s	\TLoop				;Loop
		
;---------------[ Default handling ]----------------------------------------

\Def:	move.l	(a4)+,d0			;Get data direct
	rts

;---------------------------------------------------------------------------
****************************************************************************
*										*
* ROUTINE \Indi()		 						*
*										*
*-----------------------------[ COMMENT ]----------------------------------*
*										*
* This routine part in only a test! So don't cry =)				*
*										*
****************************************************************************

\Indi:	move.l	(a4)+,a3			;Get data indirect

	cmp.l	#GTSL_Level,d1			;Wordread only
	beq.s	\Word

	move.l	(a3),d0

	rts

\Word:	clr.l	d0
	move.w	(a3),d0

	rts

;---------------------------------------------------------------------------

\SpecialTagList:	dc.l	GTIN_Number,GTSL_Level
			dc.l	0

			FORESET
gdgs_GroupList:		FO.L	1
gdgs_WindowKey:		FO.L	1
gdgs_Gadget:		FO.W	1
gdgs_SIZEOF		FOVAL

	ENDC

;---------------------------------------------------------------------------
		ENDC
;---------------------------------------------------------------------------
