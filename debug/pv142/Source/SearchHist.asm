	;Machinelanguage script, search line in history
	;This ML-script is installed by s:PowerVisor-startup on the
	;<shift>+<up> key
	;a2 = pointer to PVCallTable
	;Version 1.1    Mon Sep 23 15:03:28 1991


	INCLUDE	"pv:PVDevelop/include/PV/MainBase.i"
	INCLUDE	"pv:PVDevelop/include/PV/PVCallTable.i"


Search:
		move.l	PVCGetStringGBuf(a2),a0
		jsr		(a0)						;Get pointer to stringgadget buffer
		move.l	d0,a3
		move.l	PVCGetStringInfo(a2),a0
		jsr		(a0)						;Get pointer to StringInfo of stringgadget
		move.l	d0,a4
		move.l	PVCGetMainBase(a2),a0
		jsr		(a0)						;Get pointer to MainBase
		move.l	d0,a5

		move.w	8(a4),d5					;Position in stringgadget buffer
		move.b	0(a3,d5.w),d7			;Remember byte
		move.b	#0,0(a3,d5.w)			;Clear byte

	;Pointer to scanning history line
		move.l	base_ScanHistory(a5),d0
		bne.s		1$

	;No, we are not scanning. Take the pointer to the first history line
2$		move.l	base_FirstHistLine(a5),d0
	;If 0, there are no history lines, so we can do nothing at all
		beq.s		3$
		move.l	d0,a6
		bra.s		4$

	;Yes, we are scanning, skip this line and go to the next
1$		move.l	d0,a6
		move.l	pvhl_Next(a6),d0
	;If d0 == 0 we are at the end of the history buffer, so we must return
	;to the first line
		beq.s		2$
		move.l	d0,a6

	;Everything is fine, a6 points to the first history line we must check
	;We can start searching here
4$		move.l	a6,d6						;Remember first line we have checked
6$		lea		pvhl_String(a6),a0	;Pointer to string in history
		move.l	a3,a1						;Pointer to stringgadget
		bsr.s		Compare					;Compare two strings
		beq.s		5$
	;Not found, we go to the next history line
		move.l	pvhl_Next(a6),d0
		bne.s		7$
	;We must go to the first line (wrap)
		move.l	base_FirstHistLine(a5),d0
7$		move.l	d0,a6
		cmp.l		a6,d6						;If a6==d6 we have turned around
		bne.s		6$

	;The end, and we didn't find anything, restore the byte we cleared
3$		move.b	d7,0(a3,d5.w)
		moveq		#0,d0						;Return code failure
		rts

	;Yes ! We have found a matching line !
	;We must now copy it to the stringgadget buffer and display it
	;We also set ScanHistory to that line so that we can use
	;this routine more than one time
5$		move.l	a6,base_ScanHistory(a5)
		move.l	PVCGetHistoryLine(a2),a0
		jsr		(a0)
		move.l	PVCRefreshStringG(a2),a0
		jsr		(a0)						;Refresh stringgadget

	;The end, we did find something
		moveq		#1,d0						;Return code success
		rts

	;***
	;Compare two strings
	;a0 = string 1
	;a1 = string 2
	;-> Z flag true if equal
	;***
Compare:
		cmp.b		(a0)+,(a1)+
		beq.s		Compare
		tst.b		-1(a1)
		rts

	END
