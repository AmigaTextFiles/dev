
;---;  amigaguideasync.r  ;----------------------------------------------------
*
*	****	ASYNCHRONEOUS AMIGAGUIDE SUPPORT    ****
*
*	Author		Stefan Walter
*	Version		1.01
*	Last Revision	09.03.94
*	Identifier	aag_defined
*       Prefix		aag_	(Async AmigaGuide)
*				 ¯     ¯    ¯
*	Functions	StartAsyncAmigaGuide, SendAGCmd, EndAsyncAmigaGuide,
*			AsyncAGHandle
*
;------------------------------------------------------------------------------
* HOW TO USE:  Call StartAsyncAmigaGuide when you need help for the first time,
*              Add the resulting signal to your set of signal bits you wait on,
*              call AsyncAGHandle when the signal has been received.  Use 
*              SendAGCmd to send commands like 'LINK <node>' or 'CLOSE'.  Add 
*              EndAsyncAmigaGuide to your cleanup code.
;------------------------------------------------------------------------------

	IFND	aag_defined
aag_defined	SET	1

;------------------
aag_oldbase	EQU __BASE
	base	aag_base
aag_base:

;------------------


;------------------------------------------------------------------------------
*
* StartAsyncAmigaGuide	Start AmigaGuide in background. The window does not yet
* 			open.
*
* INPUT:	a0:	File name.
*		a1:	Title.
*
* RESULT:	d0:	Signal bit mask or 0 if error.
*               ccr:    On d0.
*
;------------------------------------------------------------------------------
	IFD	xxx_StartAsyncAmigaGuide
StartAsyncAmigaGuide:
	movem.l	d1-a6,-(sp)
	lea	aag_base(pc),a4
        move.l  aag_handle(a4),d0
	bne	.exit
	lea	aag_nag(pc),a5
	move.l	a0,nag_Name(a5)
	move.l	a1,nag_BaseName(a5)
	moveq	#%10,d0
	move.l	d0,nag_Flags(a5)
	clr.l	nag_Client(a5)
	clr.l	nag_Lock(a5)

	move.l	aag_agbase(pc),d0
	bne.s	.glib				;available
	move.l	4.w,a6
	lea	aag_agname(pc),a1
	jsr	-408(a6)			;OldOpenLibrary()
	move.l	d0,aag_agbase(a4)
	beq.s	.exit

.glib:	move.l	DosBase(pc),a6
	move.l	cws_homedir(pc),d1
	jsr	-126(a6)
	move.l	d0,d6

	move.l	aag_agbase(pc),a6
	move.l	a5,a0
	moveq	#0,d0
	jsr	-60(a6)			;OpenAmigaGuideAsyncA()
        move.l  d0,aag_handle(a4)

	move.l	DosBase(pc),a6
	move.l	d6,d1
	jsr	-126(a6)

        move.l 	aag_handle(a4),d0
        beq.s   .exit

	move.l	aag_agbase(pc),a6
        move.l  d0,a0
        jsr     -72(a6)                 ;AmigaGuideSignal()
	move.l	d0,aag_signal(a4)

.wait:	move.l	aag_signal(a4),d0
	move.l	4.w,a6
	jsr	-318(a6)		;Wait()
	CALL_	AsyncAGHandle
	sub.l	#ActiveToolID,d0
	beq.s	.exit
	subq.l	#ToolStatusID-ActiveToolID,d0
	bne.s	.wait

.exit:  move.l	aag_signal(a4),d0
	movem.l	(sp)+,d1-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* EndAsyncAmigaGuide	Terminate asynchroneous AmigaGuide. Safe to use if
*			not installed.
*
;------------------------------------------------------------------------------
	IFD	xxx_EndAsyncAmigaGuide
EndAsyncAmigaGuide:
	movem.l	d0-a6,-(sp)
	lea	aag_base(pc),a4

	move.l	aag_handle(a4),d0
	beq.s	.c1
	move.l	d0,a0
	move.l	aag_agbase(pc),a6
	jsr	-66(a6)			;CloseAmigaGuideA()
	clr.l	aag_handle(a4)

.c1:	move.l	aag_agbase(a4),d0
	beq.s	.c2
	move.l	d0,a1
	move.l	4.w,a6
	jsr	-414(a6)
	clr.l	aag_agbase(a4)

.c2:	movem.l	(sp)+,d0-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* SendAGCmd	Send a command string to the AmigaGuide window. A call
*		to OpenAmigaGuide must already be done earlier.
*
* INPUT:	a0:	Text, 0 terminated.
*
* RESULT:	d0:	Result.
*
;------------------------------------------------------------------------------
	IFD	xxx_SendAGCmd
SendAGCmd:
	movem.l	d1-a6,-(sp)
	move.l	aag_handle(pc),d0
	beq.s	.out
	exg.l	a0,d0

	move.l	aag_agbase(pc),a6
	moveq	#0,d1
	jsr	-102(a6)			;SendAmigaGuideCmdA()

.out:	tst.l	d0
	movem.l	(sp)+,d1-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* AsyncAGHandle	Deal with messages from AMigaGuide.
*
* RESULT:	d0:	0.
*
;------------------------------------------------------------------------------
	IFD	xxx_AsyncAGHandle
AsyncAGHandle:
	movem.l	d1-a6,-(sp)
	moveq	#0,d5
	move.l	aag_handle(pc),d7
	beq.s	.out
	
.loop:	move.l	aag_agbase(pc),a6
	move.l	d7,a0
        jsr	-78(a6)			;GetAmigaGuideMsg()
	tst.l	d0
	beq.s	.out
	move.l	d0,a0
	move.l	20(a0),d5
	jsr	-84(a6)			;ReplyAmigaGuideMsg()
	bra.s	.loop

.out:	move.l	d5,d0
	movem.l	(sp)+,d1-a6
	rts

	ENDC



;--------------------------------------------------------------------

;------------------
aag_nag:	ds.b	NewAmigaGuide_SIZEOF,0
aag_handle:	dc.l	0
aag_agbase:	dc.l	0
aag_signal:	dc.l	0

aag_agname:	dc.b	"amigaguide.library",0
		even


;------------------

;--------------------------------------------------------------------

	base	aag_oldbase

;------------------

	ENDIF

	end

