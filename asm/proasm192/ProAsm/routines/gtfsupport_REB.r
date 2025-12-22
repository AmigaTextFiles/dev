****************************************************************************
*										*
*                     ****   gtfsupport REB    ****				*
*				 						*
*              Some additional GTFace (© Stefan Walter) calls			*
*				 						*
*	Author		René Eberhard						*
*	Version		0.3							*
*	Last Revision	Monday 18-Oct-93 21:47:53				*
*	Identifier	gtfreb_defined						*
*       Prefix		gtfreb_ (GTFace REB support)				*
*                                ¯¯¯    ¯¯¯         				*
*-----------------------------[ UPDATES ]----------------------------------*
*										*
*	-REB!	17-Oct-93	Start this Project			   *
*										*
****************************************************************************
*---------------------------[ Functions ]----------------------------------*
*										*
* - MoveLVEntryUp, MoveLVEntryDown, LVAlphaSort					*
*										*
*---------------------------[ COMMENT ]------------------------------------*
*	    									*
****************************************************************************
;---------------------------------------------------------------------------
	IFND	gtfreb_defined
gtfreb_defined	SET	1


;---------------[ Some includes ]-------------------------------------------

		
;---------------------------------------------------------------------------

	IFND	USE_NEWROUTINES
	NEED_	MoveLVEntryUp
	NEED_	MoveLVEntryDown
	NEED_	LVAlphaSort
	ENDIF
		
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : MoveLVEntryUp							*
*										*
* SYNOPSIS: 									*
*       Result = MoveLVEntryUp (Entry, Gadget, List, WindowKey)			*
*       D0.W                    D0.W   A0.L    A1.L  A2.L			*
*										*
* FUNCTION: Move an entry one step up						*
*										*
* RESULT  : Actual entry or ERROR (D0.L = -1)					*
*			    ^^^^^^^^^^^^^^^^^					*
* COMMENT : Entry e.g from gfw_msgcode						*
*										*
****************************************************************************
	IFD	xxx_MoveLVEntryUp

MoveLVEntryUp:

	NEED_	gtfreb_LV_Top		;Need this subroutine

	PUSHM.L	d1-a6

	link    a5,#gtfreb_LV_SIZEOF

	move.w	d0,gtfreb_LV_Entry(a5)	;Store Entry
	beq.s	\Rtn			;Top entry -> can't move up
	bmi.s	\Fail

	move.l	a0,gtfreb_LV_Gadget(a5)	;Store gadget
	move.l	a1,gtfreb_LV_List(a5)	;Store listpointer
	move.l	a2,gtfreb_LV_WdKey(a5)	;Store WindowKey

;===============[ List handling ]===========================================

	move.l	AbsExecBase,a6
	move.w	gtfreb_LV_Entry(a5),d7	;Search given node

\SNode:	move.l	(a1),a1			;Get nodepointer
	tst.l	(a1)
	beq.s	\Fail			;End of node -> Fail
	dbf	d7,\SNode
	
	move.l	a1,a4			;Store node for Insert()
	move.l	LN_PRED(a4),a2		;Pointer to previous
	tst.l	(a2)
	beq.s	\Fail			;End of node -> Fail
	move.l	LN_PRED(a2),a2		;And again

;---------------[ Remove lables and node ]----------------------------------

	APUSHM
	move.l	gtfreb_LV_Gadget(a5),a0
	move.l	gtfreb_LV_WdKey(a5),a2	;Store WindowKey
	CALL_	RemoveLVLabels		;Remove LV lables
	APOPM

	JSRLIB_	Remove			;Remove node from list

;---------------[ ReInsert node ]-------------------------------------------

	move.l	gtfreb_LV_List(a5),a0	;listpointer
	move.l	a4,a1			;Node
	JSRLIB_	Insert			;A2.L from above	

;---------------[ Handle visible aera ]-------------------------------------

\Set:	subq.w	#1,gtfreb_LV_Entry(a5)	;Sub actual entry
	move.w	gtfreb_LV_Entry(a5),d0
	move.l	gtfreb_LV_List(a5),a0	;ReSet lables
	CALL_	gtfreb_LVSelect

;---------------[ Exit ]----------------------------------------------------

	move.w	gtfreb_LV_Entry(a5),d0	;Result code
	bra.s	\Rtn

\Fail:	moveq	#-1,d0

\Rtn:	unlk	a5
	POPM.L	d1-a6
	rts

	ENDC
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : MoveLVEntryDown							*
*										*
* SYNOPSIS: 									*
*       Result = MoveLVEntryDown (Entry, Gadget, List, WindowKey)		*
*       D0.W                      D0.W   A0.L    A1.L  A2.L			*
*										*
* FUNCTION: Move an entry one step down						*
*										*
* RESULT  : Actual entry 							*
*			 							*
* COMMENT : Entry e.g from gfw_msgcode						*
*										*
****************************************************************************
	IFD	xxx_MoveLVEntryDown

MoveLVEntryDown:

	NEED_	gtfreb_LV_Top		;Need this subroutine

	PUSHM.L	d1-a6

	link    a5,#gtfreb_LV_SIZEOF

	move.w	d0,gtfreb_LV_Entry(a5)	;Store Entry
	bmi.s	\Rtn			;Fail result as entry

	move.l	a0,gtfreb_LV_Gadget(a5)	;Store gadget
	move.l	a1,gtfreb_LV_List(a5)	;Store listpointer
	move.l	a2,gtfreb_LV_WdKey(a5)	;Store WindowKey

;===============[ List handling ]===========================================

	move.l	AbsExecBase,a6

	move.w	gtfreb_LV_Entry(a5),d7	;Search given node

\SNode:	move.l	(a1),a1			;Get nodepointer
	tst.l	(a1)
	beq.s	\Last
	dbf	d7,\SNode
	
	move.l	a1,a4			;Store node for Insert()
	move.l	LN_SUCC(a4),a2		;Pointer to successor
	tst.l	(a2)			;Actual entry IS the last entry
	beq.s	\Last

;---------------[ Remove lables and node ]----------------------------------

	APUSHM
	move.l	gtfreb_LV_Gadget(a5),a0
	move.l	gtfreb_LV_WdKey(a5),a2	;Store WindowKey
	CALL_	RemoveLVLabels		;Remove LV lables
	APOPM

	JSRLIB_	Remove			;Remove node from list ; A1.Ll from above

;---------------[ ReInsert node ]-------------------------------------------

\ReIn:	move.l	gtfreb_LV_List(a5),d0	;listpointer
	move.l	a4,a1			;Node
	JSRLIB_	Insert			;A2.L from above	

;---------------[ Handle visible aera ]-------------------------------------

\Set:	addq.w	#1,gtfreb_LV_Entry(a5)	;Add actual entry
	move.w	gtfreb_LV_Entry(a5),d0
	move.l	gtfreb_LV_List(a5),a0
	CALL_	gtfreb_LVSelect


\Last:	move.w	gtfreb_LV_Entry(a5),d0	;Result code

\Rtn:	unlk	a5
	POPM.L	d1-a6
	rts

	ENDC
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : LVAlphaSort								*
*										*
* SYNOPSIS: 									*
*       Result = LVAlphaSort (Gadget, List, WindowKey)				*
*       D0.L                  A0.L    A1.L  A2.L				*
*										*
* FUNCTION: Sorts a list in alphabetical order					*
*										*
* RESULT  : TRUE / FALSE 							*
*			 							*
****************************************************************************
	IFD	xxx_LVAlphaSort

	NEED_	gtfreb_LV_Top		;Need this subroutine
	NEED_	gtfreb_SwapNode		;Need this subroutine

LVAlphaSort:

	PUSHM.L	d1-a6

	link    a5,#gtfreb_LV_SIZEOF

	move.l	a0,gtfreb_LV_Gadget(a5)	;Store gadget
	move.l	a1,gtfreb_LV_List(a5)	;Store listpointer
	move.l	a2,gtfreb_LV_WdKey(a5)	;Store WindowKey
		
	move.l	(a1),a3			;Pointer to first node

;---------------[ Remove lables and node ]----------------------------------

	move.l	gtfreb_LV_Gadget(a5),a0
	move.l	gtfreb_LV_WdKey(a5),a2	;Store WindowKey
	CALL_	RemoveLVLabels		;Remove LV lables

;---------------[ Get two nodes ]-------------------------------------------

	moveq	#0,d7			;Clr flag for loop

	move.l	UtilityBase,a6

\Loop:	move.l	LN_SUCC(a3),a4		;Copy next node into A4.L
	tst.l	(a4)			
	beq.s	\Last			;It was the last entry

	move.l	LN_NAME(a3),a0		;Compare both strings
	move.l	LN_NAME(a4),a1
	JSRLIB_	Stricmp
	tst.l	d0
	bpl.s	\Swap

	move.l	LN_SUCC(a3),a3
	tst.l	(a3)
	beq.s	\Last
	bra	\Loop

;---------------[ Last ]----------------------------------------------------

\Last:	tst.l	d7
	beq.s	\Rtn
	moveq	#0,d7			;Clr flag for loop

	move.l	gtfreb_LV_List(a5),a3

	move.l	LN_SUCC(a3),a3
	tst.l	(a3)
	beq.s	\Rtn
	bra	\Loop

\Rtn:	moveq	#0,d0
	move.l	gtfreb_LV_List(a5),a0
	CALL_	gtfreb_LVSelect

	unlk	a5
	POPM.L	d1-a6
	rts
		
;===============[ Swap ]====================================================

\Swap:	moveq	#-1,d7			;Set flag for changeing

	move.l	gtfreb_LV_List(a5),a0	;Listpointer
	move.l	a3,a1			;Node
	CALL_	gtfreb_SwapNode

	move.l	LN_SUCC(a3),a3
	tst.l	(a3)
	beq.s	\Last
	bra.s	\Loop

	ENDC
;---------------------------------------------------------------------------
****************************************************************************
*										*
* SUBROUTINE : gtfreb_LVSelect							*
*										*
* SYNOPSIS: 									*
*       gtfreb_LVSelect (TopEntry,Lables)					*
*                        D0.W 	  A0.L						*
*										*
* FUNCTION: Select entry							*
*										*
****************************************************************************
	IFD	xxx_gtfreb_LVSelect

gtfreb_LVSelect:
	APUSHM

	lea	\gtfreb_Select_TagList(PC),a3

	move.l	a0,4(a3)			;Set lables

	moveq	#0,d1
	move.w	d0,d1
	move.l	d1,12(a3)			;Put in tag_data
	move.l	d1,20(a3)

;---------------[ SetGadgetAttrs ]------------------------------------------

\NoTag:	move.l	gtf_gadtoolsbase(PC),a6
	move.l	gtfreb_LV_Gadget(a5),a0
	move.l	gtfreb_LV_WdKey(a5),a1
	move.l	gfw_window(a1),a1
	suba.l	a2,a2
	JSRLIB_	GT_SetGadgetAttrsA		;A3.L from above

\Rtn:	APOPM
	rts

\gtfreb_Select_TagList:	dc.l	GTLV_Labels,0
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	TAG_DONE

	ENDC
;---------------------------------------------------------------------------
****************************************************************************
*										*
* SUBROUTINE : gtfreb_SwapNode							*
*										*
* SYNOPSIS: 									*
*       gtfreb_SwapNode (List, Node)						*
*                        A0.L  A1.L 						*
*										*
* FUNCTION: Swaps the actual node and its successor				*
*										*
****************************************************************************
	IFD	xxx_gtfreb_SwapNode
gtfreb_SwapNode:

	APUSHM
	move.l	AbsExecBase,a6

	move.l	LN_SUCC(a1),a2		;Pointer to successor
	tst.l	(a2)			;Is there a next entry
	beq.s	\Rtn			;No -> Don't swap -> Exit

	PUSHM.L	a0-a2
	JSRLIB_	Remove			;A1.L from above
	POPM.L	a0-a2

	JSRLIB_	Insert

\Rtn:	APOPM
	rts

	ENDC
;---------------------------------------------------------------------------
****************************************************************************
*										*
*										*
* DATA										*
*										*
*										*
****************************************************************************

			FORESET
gtfreb_LV_List:		FO.L	1
gtfreb_LV_Entry:	FO.W	1
gtfreb_LV_Gadget:	FO.L	1
gtfreb_LV_WdKey:	FO.L	1
gtfreb_LV_SIZEOF	FOVAL

;---------------------------------------------------------------------------
		ENDC
;---------------------------------------------------------------------------
