
;---;  gtfsupport.r  ;---------------------------------------------------------
*
*	****	VARIOUS GTFACE SUPPORT ROUTINES    ****
*
*	Author		Stefan Walter
*	Version		1.03
*	Last Revision	23.10.93
*	Notes		demands calls with CALL_ macro
*	Identifier	gfs_defined
*	Prefix		gfs_	(GTFace support)
*				 ¯ ¯    ¯
*	Functions	AllocLVNode, AllocLVNodeRaw, FreeLVNode
*			AddHeadLVNode, AddTailLVNode, RemHeadLVNode
*			RemTailLVNode, RemoveLVNode, FreeLVList.
*
*			SetGadgetTag,SetLVLabels,RemoveLVLabels,
*			ChangeLVLabels, SetCYActive, GetLVLabels
*			ActivateGadget, OnMenu, OffMenu, FindLVNode,
*			FindLVNodeMsg.
*
*			StringHistoryHookFunction
*
;------------------------------------------------------------------------------

;------------------
	ifnd	gfs_defined
gfs_defined	=1

;------------------
; Some macros.
;
	include	basicmac.r
	include	tasktricks.r




;------------------------------------------------------------------------------
*
* AllocLVNodeRaw	Allocate a listview node due to a string generated
*			with RawDoFmt(). The string is copied.
*
* INPUT:	a0	Format string.
*		a1	Raw data.
*		d0	Number of bytes to add after node structure.
*
* RESULT:	d0	Node or 0.
*		a0	Node or 0.
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_AllocLVNodeRaw
AllocLVNodeRaw:

;------------------
; Start.
;
\start:	movem.l	d1-d7/a1-a6,-(sp)
	move.l	d0,d5
	move.l	a0,a3
	move.l	a1,a4
	DoRawCnt_

	add.l	d5,d0
	moveq	#14,d1
	add.l	d1,d0	

	moveq	#1,d1			;even VMem allowed!
	swap	d1			;clear!
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	tst.l	d0
	beq.s	\done

	move.l	d0,a2
	move.l	a3,a0
	move.l	a4,a1
	lea	14(a2,d5.l),a3
	move.l	a3,10(a2)
	
	DoRaw_

\done:	move.l	d0,a0
	movem.l	(sp)+,d1-d7/a1-a6
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* AllocLVNode	Allocate a listview node. The node will contain a selected
*		number of bytes after the node structure and a string that is
*		copied.
*
* INPUT:	a0	String (will appear in the listview gadget).
*		d0	Number of bytes to add after node structure.
*
* RESULT:	d0	Node or 0.
*		a0	Node or 0
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_AllocLVNode
AllocLVNode:

;------------------
; Start.
;
\start:	movem.l	d1-d7/a1-a6,-(sp)
	move.l	a0,a2
	move.l	d0,d7
	moveq	#14,d0			;LN_SIZEOF
	add.l	d7,d0			;+ desired number of bytes
\loop:	addq.l	#1,d0			;+ string size
	tst.b	(a0)+
	bne.s	\loop

	moveq	#1,d1			;even VMem allowed!
	swap	d1			;clear!
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	tst.l	d0
	beq.s	\done

	move.l	d0,a0
	lea	14(a0,d7.l),a1
	move.l	a1,10(a0)
\loop2:	move.b	(a2)+,(a1)+		;copy string...
	bne.s	\loop2
	tst.l	d0

\done:	move.l	d0,a0
	movem.l	(sp)+,d1-d7/a1-a6
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* FreeLVList	Remove the entier listview list and free all nodes.
*
* INPUT:	a0	List.
*		a2	WindowKey.
*		a3	Gadget.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_FreeLVList
FreeLVList:

;------------------
; Start.
;
\start:	movem.l	d0-a6,-(sp)
	move.l	a0,a4
	move.l	a3,a0
	CALL_	RemoveLVLabels
	move.l	4.w,a6
\loop:	move.l	a4,a0
	jsr	-258(a6)		;RemHead()
	tst.l	d0
	beq.s	\done
	move.l	d0,a0
	CALL_	FreeLVNode
	bra.s	\loop
\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* FreeLVNode	Free a previously generated listview node.
*
* INPUT:	a0	Node.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_FreeLVNode
FreeLVNode:

;------------------
; Start.
;
\start:	movem.l	d0-a6,-(sp)
	move.l	10(a0),a2
\loop:	tst.b	(a2)+
	bne.s	\loop
	move.l	a2,d0
	sub.l	a0,d0			;size: from node to end of string
	move.l	a0,a1
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* AddHeadLVNode	Add a listview node at the head of the list.
*
* INPUT:	a0	List.
*		a1	Node.
*		a2	WindowKey.
*		a3	Gadget.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_AddHeadLVNode
AddHeadLVNode:

;------------------
; Start.
;
\start:	movem.l	d0-a6,-(sp)
	move.l	a0,a4
	move.l	a3,a0
	CALL_	RemoveLVLabels
	move.l	a4,a0
	move.l	4.w,a6
	jsr	-240(a6)		;AddHead()
	move.l	a4,d0
	CALL_	SetLVLabels
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* AddTailLVNode	Add a listview node at the tail of the list.
*
* INPUT:	a0	List.
*		a1	Node.
*		a2	WindowKey.
*		a3	Gadget.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_AddTailLVNode
AddTailLVNode:

;------------------
; Start.
;
\start:	movem.l	d0-a6,-(sp)
	move.l	a0,a4
	move.l	a3,a0
	CALL_	RemoveLVLabels
	move.l	a4,a0
	move.l	4.w,a6
	jsr	-246(a6)		;AddTail()
	move.l	a4,d0
	move.l	a3,a0
	CALL_	SetLVLabels
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* RemHeadLVNode	Remove first node of a listview gadget.
*
* INPUT:	a0	List.
*		a1	Node.
*		a2	WindowKey.
*		a3	Gadget.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_RemHeadLVNode
RemHeadLVNode:

;------------------
; Start.
;
\start:	pea	(a1)
	move.l	(a0),a1
	tst.l	(a1)			;empty?
	beq.s	\done
	CALL_	RemoveLVNode
\done:	move.l	(sp)+,a1
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* RemTailLVNode	Remove last node of a listview gadget.
*
* INPUT:	a0	List.
*		a1	Node.
*		a2	WindowKey.
*		a3	Gadget.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_RemTailLVNode
RemTailLVNode:

;------------------
; Start.
;
\start:	pea	(a1)
	move.l	8(a0),a1
	tst.l	4(a1)			;empty?
	beq.s	\done
	CALL_	RemoveLVNode
\done:	move.l	(sp)+,a1
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* RemoveLVNode	Remove a listview node from the gadget.
*
* INPUT:	a0	List.
*		a1	Node.
*		a2	WindowKey.
*		a3	Gadget.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_RemoveLVNode
RemoveLVNode:

;------------------
; Start.
;
\start:	movem.l	d0-a6,-(sp)
	move.l	a0,a4
	move.l	a3,a0
	CALL_	RemoveLVLabels
	move.l	4.w,a6
	jsr	-252(a6)		;Remove()
	exg.l	a4,d0
	move.l	a3,a0
	CALL_	SetLVLabels
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------





;--------------------------------------------------------------------
*
* ActivateGadget	Activate a gadget.
*
* INPUT:	a0	Gadget.
*		a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------

	IFD	xxx_ActivateGadget
ActivateGadget:
	movem.l	d0-a6,-(sp)
	move.l	(a2),a1
	suba.l	a2,a2
	move.l	gtf_intbase(pc),a6
	jsr	-462(a6)		;ActivateGadget()
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* OnMenu	Activate or deactivate menu strip, title, item or subitem.
* OffMenu
*
* INPUT:	d0	*_mn ID number of object.
*		a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------

	IFD	xxx_OnMenu
OnMenu:	movem.l	d0-a6,-(sp)
	move.l	(a2),a0
	move.l	gtf_intbase(pc),a6
	jsr	-192(a6)		;OnMenu()
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------

	IFD	xxx_OffMenu
OffMenu:
	movem.l	d0-a6,-(sp)
	move.l	(a2),a0
	move.l	gtf_intbase(pc),a6
	jsr	-180(a6)		;OffMenu()
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* Different Gadget modification routines.
*
* INPUT:	a0	Gadget.
*		d0	Tag data.
*		a2	WindowKey.
*
* RESULT:	d1	Tag number.
*
;--------------------------------------------------------------------

;------------------

	IFD	xxx_EnableGadget
EnableGadget:
xxx_SetGadgetTag	SET	1
	move.l	#GA_Disabled,d1
	moveq	#0,d0
	bra	SetGadgetTag
	ENDIF


	IFD	xxx_DisableGadget
DisableGadget:
xxx_SetGadgetTag	SET	1
	move.l	#GA_Disabled,d1
	moveq	#-1,d0
	bra	SetGadgetTag
	ENDIF


	IFD	xxx_RemoveLVLabels
RemoveLVLabels:
xxx_SetGadgetTag	SET	1
	move.l	#GTLV_Labels,d1
	moveq	#-1,d0
	bra	SetGadgetTag
	ENDIF


	IFD	xxx_ChangeLVLabels
ChangeLVLabels:
xxx_SetLVLabels		SET	1
	move.l	d0,-(sp)
	CALL_	RemoveLVLabels
	move.l	(sp)+,d0
	ENDIF


	IFD	xxx_SetLVLabels
SetLVLabels:
xxx_SetGadgetTag	SET	1
	move.l	#GTLV_Labels,d1
	bra	SetGadgetTag
	ENDIF


	IFD	xxx_SetCYActive
SetCYActive:
xxx_SetGadgetTag	SET	1
	move.l	#GTCY_Active,d1
	bra	SetGadgetTag
	ENDIF
	

	IFD	xxx_GetLVLabel
GetLVLabel:
	movem.l	d1/a0,-(sp)
	move.w	d0,d1
	move.l	(a0),d0

\loop:	move.l	d0,a0
	move.l	(a0),d0
	beq.s	\no
	subq.w	#1,d1
	bhs.s	\loop
	move.l	a0,d0

\no:	tst.l	d0
	movem.l	(sp)+,d1/a0
	rts
	ENDIF


;------------------





;--------------------------------------------------------------------
*
* SetGadgetTag	Call GT_SetGadgetAttrs with one tag.
*
* INPUT:	a0	Gadget
*		d0	Tag data
*		d1	Tag Number
*		a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_SetGadgetTag
SetGadgetTag:
xxx_gtf_tagspace	SET	1

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	move.l	gfw_window(a2),a1
	suba.l	a2,a2
	lea	gtf_tagspace+12(pc),a3
	clr.l	-(a3)
	move.l	d0,-(a3)
	move.l	d1,-(a3)
	move.l	gtf_gadtoolsbase(pc),a6
	jsr	-42(a6)			;GT_SetGadgetAttrsA()
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* FindLVNode	Find Listview node.
* FindLVNodeMsg	Find Listview node that is stated in gfw_msgcode.
*
* INPUT:	a0	List.
*		d0	Number.
*		a2	WindowKey (only for FindLVNodeMsg).
*
* RESULT:	d0	Node or 0.
*		a0	Same as d0.
*		ccr	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_FindLVNodeMsg
	move.w	gfw_msgcode(a2),d0
xxFindLVNode	SET	1

	ENDC

;------------------
	IFD	xxx_FindLVNode
FindLVNode:

;------------------
; Do!
;
\do:	move.l	(a0),a0

\loop:	tst.l	(a0)
	beq.s	\notfound
	tst.w	d0
	beq.s	\found
	subq.w	#1,d0
	move.l	(a0),a0
	bra.s	\loop

\found:	move.l	a0,d0
	rts

\notfound:
	moveq	#0,d0
	rts

	ENDC


;--------------------------------------------------------------------
*
* Historyfunction for Stringgadgets.
*
* You'll need to declare this with 'NEED_ StringHistoryHookFunction'
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_StringHistoryHookFunction

	rsreset
gtfh_buffer	rs.l	1
gtfh_buflen	rs.l	1
gtfh_bufusage	rs.l	1
gtfh_start	rs.l	1
gtfh_counter	rs.l	1
gtfh_current	rs.l	1
gtfh_SIZEOF	rsval

;
; HistoryHook_	StringHistStruct
;
HistoryHook_	MACRO
	dc.l	0,0
	dc.l	StringHistoryHookFunction
	dc.l	0
	dc.l	\1
	ENDM


;
; StringHistoryStruct_	Buffer,BufferSize
;
StringHistoryStruct_	MACRO
	dc.l	\1
	dc.l	\2
	dc.l	0,0,0,0
	ENDM


StringHistoryHookFunction:

;------------------
; Hook.
;
;	A0 - pointer to hook itself
;	A1 - pointer to parameter packet ("message")
;	A2 - Hook specific address data ("object," e.g, gadget )
;
\start:	moveq	#0,d0
	cmp.l	#SGH_KEY,(a1)
	bne.s	\done
	movem.l	d3/a3/a4,-(sp)
	move.l	16(a0),a3
	move.l	sgw_Actions(a2),d3
	btst	#SGAB_END,d3
	bne.s	\remember
	move.l	sgw_IEvent(a2),a4
	cmp.b	#$4c,7(a4)
	beq.s	\prev	
	cmp.b	#$4d,7(a4)
	beq.s	\next
\no:	movem.l	(sp)+,d3/a3/a4
\done:	rts

\remember:
	bsr.s	\addtohist
\do:	moveq	#-1,d0
	bra.s	\no

\prev:	bsr	\historyrew
	bra.s	\do
\next:	bsr	\historyfwd
	bra.s	\do


;------------------
; Add to history buffer
;
;	a3:	History Info Block.
;	a2:	SGWork.
;
\addtohist:
	movem.l	d0/d1/d7/a0/a1/a4/a5,-(sp)
	move.l	gtfh_buffer(a3),a4	;start of buffer
	move.l	a4,a5
	move.l	gtfh_buflen(a3),d7	;length of buffer
	add.l	d7,a5			;end of buffer
	moveq	#0,d0
	move.w	sgw_NumChars(a2),d0
	beq.s	\fin
	move.w	#254,d1
	cmp.w	d1,d0
	bls.s	1$
	move.w	d1,d0			;limit to 254+1 (for len)
1$:	move.l	gtfh_bufusage(a3),d1
	add.l	d0,d1
	addq.l	#1,d1
	cmp.l	d7,d1
	bls.s	\norem
	move.l	a4,a0			;free last entry and try again
	add.l	gtfh_start(a3),a0
	moveq	#0,d1
	move.b	(a0),d1
	add.l	d1,a0
	bsr.s	\historylimit
	sub.l	a4,a0
	move.l	a0,gtfh_start(a3)
	sub.l	d1,gtfh_bufusage(a3)
	subq.l	#1,gtfh_counter(a3)
	bra.s	1$

\norem:	addq.l	#1,gtfh_counter(a3)
	move.l	a4,a0
	add.l	gtfh_bufusage(a3),a0
	add.l	gtfh_start(a3),a0
	move.l	d1,gtfh_bufusage(a3)

	bsr.s	\historylimit
	move.b	d0,(a0)
	addq.b	#1,(a0)+
	move.l	sgw_WorkBuffer(a2),a1
\loop:	bsr.s	\historylimit
	move.b	(a1)+,(a0)+
	subq.b	#1,d0
	bne.s	\loop

\fin:	clr.l	gtfh_current(a3)
	movem.l	(sp)+,d0/d1/d7/a0/a1/a4/a5
	rts

\historylimit:
	cmp.l	a4,a0
	bhs.s	\nl1
	add.l	d7,a0
\nl1:	cmp.l	a5,a0
	blo.s	\nl2
	sub.l	d7,a0
\nl2:	rts



;------------------
; Go one forth in command history.
; If nothing to go forth, clear line.
;
\historyfwd:
	tst.l	gtfh_current(a3)
	beq.s	\gethistory
	subq.l	#1,gtfh_current(a3)
	bra.s	\gethistory

\historyrew:
	addq.l	#1,gtfh_current(a3)

\gethistory:
	movem.l	d0/d1/d7/a4/a5/a1,-(sp)
	move.l	gtfh_buffer(a3),a4	;start of buffer
	move.l	a4,a5
	move.l	gtfh_buflen(a3),d7	;length of buffer
	add.l	d7,a5			;end of buffer

	move.l	sgw_WorkBuffer(a2),a1
	move.l	gtfh_current(a3),d1
	beq.s	\cls
	move.l	gtfh_counter(a3),d0
	beq.s	\cls
	cmp.l	d0,d1
	bls.s	11$
	move.l	d0,d1
11$:	move.l	d1,gtfh_current(a3)
	move.l	a4,a0
	add.l	gtfh_start(a3),a0
	sub.l	d1,d0
	beq.s	\got
\loop3:	moveq	#0,d1
	move.b	(a0),d1
	add.l	d1,a0
	bsr.s	\historylimit
	subq.l	#1,d0
	bne.s	\loop3

\got:	moveq	#0,d1
	move.b	(a0)+,d1
	subq.l	#1,d1
	clr.w	sgw_BufferPos(a2)
	move.w	d1,sgw_NumChars(a2)
	beq.s	\done2

\loop2:	bsr.s	\historylimit
	move.b	(a0)+,(a1)+
	subq.w	#1,d1
	bne.s	\loop2

\done2:	clr.b	(a1)
	movem.l	(sp)+,d0/d1/d7/a4/a5/a1
	rts

\cls:	clr.w	sgw_NumChars(a2)
	clr.w	sgw_BufferPos(a2)
	bra.s	\done2

	ENDC


;--------------------------------------------------------------------

;------------------
	endif

	end
