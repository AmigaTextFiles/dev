
	incdir	cde:prog/devpac/include/include
	
	include	intuition/intuition_lib.i
	include	libraries/mui.i



* Popup-Listview hook functions for AMOS-MUI.
*
*

	bra	hook_List_To_String
	bra	hook_String_In_List


****************************************************************************
* This hook copies the active entry from a listview into a string gadget.
*

hook_List_To_String:


*A1=StringObj
*A2=ListViewObj

	movem.l	a1,-(sp)	
	move.l 	-4(a2),a0 	;A0=CLASS
	move.l 	8(a0),a3  	;A3=DISPATCHER
	lea 	tag_getactive(pc),a1
	move.l	a1,d0
	add.l	#16,d0
	move.l	d0,8(a1)	;Get active entry directly to other taglist!
	jsr	(a3)
	movem.l	(sp)+,a0
	lea	tag_setstring(pc),a1
	jsr	_LVOSetAttrsA(a6)
	moveQ	#1,d0	;MUI_TRUE				
	rts
	
tag_getactive

	dc.l	MUIM_List_GetEntry
	dc.l	MUIV_List_GetEntry_Active	
	dc.l	0	;Pointer to active_entry	
tag_setstring	dc.l	MUIA_String_Contents
active_entry	dc.l	0	

****************************************************************************		
* This hook scans a listview gadget for the string in a string gadget, and
* activates it in the listview gadget if it is found.
*

hook_String_In_List:

* Assumes Intuitionbase is in 1st Hook dataword.

	move.l	a2,-(sp)
	move.l	#MUIA_String_Contents,d0
	move.l	a1,a0
	lea	search_string(pc),a1
	jsr	_LVOGetAttr(a6)		

	move.l	(sp),a2	;Prepare DoMethod & StrCmp
	move.l	-4(a2),a0
	move.l	8(a0),a3
	lea	search_tags(pc),a1
	lea	test_string(pc),a4
	lea	search_string(pc),a5
	moveQ	#0,d0
	tst.l	(a5)
	beq.s	.emptystring
	move.l	(a5),a5
	move.l	a4,8(a1)	
	movem.l	a0-5,-(sp)

.nextentry	movem.l	(sp),a0-5
	move.l	d0,4(a1)
	move.l	d0,-(sp)
	jsr	(a3)	;Get next entry
	move.l	(sp)+,d0
	movem.l	(sp),a0-5
	tst.l	(a4)
	beq.s	.notinlist
	move.l	(a4),a4		

	;Now a StrCmp between a4 & a5
	
.next	tst.b	(a4)
	beq.s	.s1end
	tst.b	(a5)
	beq.s	.fail	
	cmp.b	(a4)+,(a5)+	
	bne.s	.fail	
	bra.s	.next
			
.s1end	tst.b	(a5)
	beq.s	.succeed
	
.fail	addQ	#1,d0
	bra.s	.nextentry

.notinlist	move.l	#MUIV_List_ActiveOff,d0		

.succeed	movem.l	(sp)+,a0-a5
.emptystring	move.l	(sp)+,a0
	lea	set_list(pc),a1	 ; change the active entry
	move.l	d0,4(a1)
	jsr	_LVOSetAttrsA(a6)
	moveQ	#1,d0
	rts

search_string	dc.l	0
test_string	dc.l	0

search_tags	dc.l	MUIM_List_GetEntry
	dc.l	0
	dc.l	0

set_list	dc.l	MUIA_List_Active
	dc.l	0
	
