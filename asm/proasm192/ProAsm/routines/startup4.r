
;---;  startup.r  ;------------------------------------------------------------
*
*	****	ENHANCED CLI AND WORKBENCH STARTUP WITH DETACH    ****
*
*	Author		Stefan Walter
*	Version		1.17
*	Last Revision	24.06.96
*	Identifier	cws_defined
*       Prefix		cws_	(cli and workbench startup)
*				 ¯       ¯         ¯
*	Functions	AutoDetach, ReplySync, ReplyWBMsg
*
*	Flags		cws_DETACH set 1      : when detaching startup
*			cws_V36PLUSONLY set 1 : when tool for KS2.0 only
*			cws_V37PLUSONLY set 1 : when tool for KS2.0/V37 only
*			cws_CLIONLY set 1     : when tool for CLI usage only
*			cws_PRI equ [pri]     :	if process must have priority
*					        [pri] otherwise the priority
*					        is inherited.
*			cws_FPU set 1         : if FPU reset needed
*			cws_EASYLIB set 1     : if libs to be opened by startup
*			cws_STACKSIZE equ [stacksize] : if process must have a
*					        stacksize of [stacksize]
*					        otherwise the stacksize of the
*					        parent process is taken.
*
* 	NOTE:	The startup code must be in the first code segment, along with
*		the other routines it accesses.
*
;------------------------------------------------------------------------------
*
* Using this include: The main code must contain the symbols 'processname',
* 'clistartup' and 'wbstartup'. The Main program must execute 'JMP AutoDetach'.
* The child process can call ReplySync with a routine in a0. This routine gets
* executed by the parent process under permitted conditions. The child process
* *MUST* call ReplySync once with a0:=0. It waits then for a final message from
* the parent process, which is sent by this under forbid. This guarantees
* that the parent process ends in any case before the child because the memory
* belongs to the child from the moment it recieves the first messy. The parent
* process terminates under forbid.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	cws_defined
cws_defined	=1

;------------------
cws_oldbase	equ __base
	base	cws_base
cws_base:

;------------------

;------------------------------------------------------------------------------
*
* AutoDetach	Standard startup code.
*
* RESULT:	If the program was started on workbench, this routine gets the
*		workbench message in d0 and jumps to 'WBSTARTUP'. In case of
*		CLI start, this routine autodetaches from the process and the
*		new process starts at 'CLISTARTUP'. A message is sent to the
*		new process to synchronize its creation with the end of the old
*		process. In the message, a routine can be designed to be
*		executed. The label 'PROCESSNAME' points to name.
*
*		The following variables can be accessed by the customer:
*
*		- cws_kick20.b		-1 if V36+, else 0
*		- cws_kick30.b		-1 if V39+, else 0
*		- cws_wbstartup.b	-1 for WB, 0 for CLI
*		- cws_wbmessage.l	Pointer to WB message
*		- cws_launchtask	Pointer to parent task structure
*		- cws_returnvalue	Return value for parent process
*
;------------------------------------------------------------------------------

        IFD     cws_V37PLUSONLY
cws_V36PLUSONLY	SET	1
	ENDIF

;------------------
AutoDetach:

;------------------
; Get main base and save startup regs for capturing CLI.
;
\start:
	pea	(a4)
	lea	cws_base(pc),a4
	movem.l	d0-a6,cws_regs(a4)
	move.l	(sp)+,cws_regs+12*4(a4)
	move.l	4.w,a6

	IFD	cws_FPU
;------------------
; Reset FPU.
;
\resetfpu:
	MC68882
	move.w	296(a6),d0
	moveq	#$30,d1
	btst	#3,d0		;68040?
	beq.s	\noforty
	moveq	#$70,d1
\noforty:
	and.w	d1,d0
	beq.s	\findtask
	fmove.l	#0,fpcr
	opt	p=-68882
	ENDIF

;------------------
; Get task and test if run from WorkBench.
;
\findtask:
	IFD	V37PLUSONLY
	cmp.w	#$25,20(a6)
	ELSE
	cmp.w	#$24,20(a6)
	ENDIF
	sge	cws_kick20(a4)		;remember exec version
	cmp.w	#39,20(a6)
	sge	cws_kick30(a4)
	move.l	$114(a6),a0
	move.l	a0,cws_launchtask(a4)	;remember for child
	move.l	$ac(a0),d6
	seq	cws_wbstartup(a4)	;remember in flag
	bne	\climode

;------------------
; Started from WB, get message.
;
\getwbmsg:
	lea	$5c(a0),a0
	jsr	-384(a6)		;WaitPort()
	jsr	-372(a6)		;GetMsg()
	move.l	d0,cws_wbmessage(a4)

;------------------

	IFD	cws_V36PLUSONLY
cws_REQUESTER	set	1

;------------------
; Test if V36+
;
\testwb20:
	IFND	cws_CLIONLY
	tst.b	cws_kick20(a4)
	bne	\gowb			;okay!
	bsr.s	\ks20requester
	bra	ReplyWBMsg
	ELSE
	bra	\clirequester
	ENDIF

;------------------
; Pop up 'KS V36+ only' requester.
;
\ks20requester:
	lea	\maintext(pc),a1
	lea	\maintext2(pc),a0
	move.l	a0,\pt2-\maintext(a1)
	lea	\text2(pc),a0
	move.l	a0,\pt3-\maintext(a1)
	bra	\requester

;------------------
; Texts.
;
\maintext2:
	dc.b	0,0,0,0
	dc.w	10,18
	dc.l	0
\pt3:	dc.l	0	;text2
	dc.l	0

	IFD	V37PLUSONLY
\text2:		dc.b	"needs Kickstart V37+.",0
	ELSE
\text2:		dc.b	"needs Kickstart V36+.",0
	ENDIF

	even

;------------------
	ENDIF

;------------------
	ifd	cws_CLIONLY
cws_REQUESTER	set	1

;------------------
; Pop up 'CLI only' requester.
;
\clirequester:
	lea	\maintext(pc),a1
	lea	\maintext21(pc),a0
	move.l	a0,\pt2-\maintext(a1)
	lea	\text21(pc),a0
	move.l	a0,\pt5-\maintext(a1)
	bsr	\requester
	bra	ReplyWBMsg

;------------------
; Texts.
;
\maintext21:
	dc.b	0,0,0,0
	dc.w	10,18
	dc.l	0
\pt5:	dc.l	0	;text2
	dc.l	0

\text21:	dc.b	"is for CLI usage only.",0
	even

;------------------
	else

;------------------
; Go to start.
;	d0=WBMSG
;
\gowb:	move.l	d0,d7			;store WBMessage
	IFD	cws_EASYLIB
	bsr	cws_openlibraries	;all registers unaffected
	beq	ReplyWBMsg
	ENDIF

	bsr	OpenDosLib		;changes D0!!!
	beq.s	\nocd

	move.l	d7,a0
	move.l	36(a0),d0		;sm_ArgList
	beq.s	\cddone
	move.l	d0,a0
	move.l	(a0),d1			;wa_Lock
	beq.s	\cddone
	jsr	-126(a6)		;CurrentDir()

\cddone:
	bsr	CloseDosLib

\nocd:	move.l	cws_wbmessage(pc),d0

	IFD	cws_V36PLUSONLY
	move.l	cws_launchtask(a4),a3
	move.l	$bc(a3),cws_homedir(a4)	;HomeDir...
	ENDIF

	move.l	(sp)+,cws_returnaddr(a4)
	jsr	wbstartup(pc)
	move.l	cws_returnaddr(pc),-(sp)

	IFD	cws_EASYLIB
	bsr	CloseLibrary
	ENDIF

	bra	ReplyWBMsg

;------------------
	endif

;------------------
	ifd	cws_REQUESTER

;------------------
; Open a requester.
;	a1=\maintext
;
\requester:
	lea	\text1(pc),a0
	move.l	a0,\pt1-\maintext(a1)
	lea	\text3(pc),a0
	move.l	a0,\pt4-\maintext(a1)

	move.l	4.w,a6
	lea	\intuiname(pc),a1
	jsr	-408(a6)		;OldOpenLibrary()
	move.l	d0,a6
	tst.l	d0
	beq.s	\requesterend		;no library, no requester...

	suba.l	a0,a0
	moveq	#0,d0
	moveq	#0,d1
	moveq	#30,d2
	lsl.l	#3,d2
	moveq	#64,d3
	lea	\maintext(pc),a1
	suba.l	a2,a2
	lea	\negativetext(pc),a3
	jsr	-348(a6)		;AutoRequester()

\closeintui:
	move.l	a6,a1
	move.l	4.w,a6
	jsr	-414(a6)		;CloseLibrary()

\requesterend:
	rts

;------------------
; IntuiText structures.
;
\maintext:
	dc.b	0,0,0,0
	dc.w	10,8
	dc.l	0
\pt1:	dc.l	0	;text1
\pt2:	dc.l	0	;maintext2

\negativetext:
	dc.b	0,0,0,0
	dc.w	4,3
	dc.l	0
\pt4:	dc.l	0	;text3
	dc.l	0

;------------------
; Texts.
;
\text1:		dc.b	"The program '",gea_progname,"'",0
\text3:		dc.b	" Okay ",0
\intuiname:	dc.b	"intuition.library",0
	even

;------------------
	endif

;------------------

;------------------------------------------------------------------------
;-	Task Detach							-
;------------------------------------------------------------------------

;------------------
; To the CLI.
;
\climode:

;------------------
	ifd	cws_V36PLUSONLY

;------------------
; Test if V36+
;
\testcli20:
	tst.b	cws_kick20(a4)
	beq	\ks20requester

;------------------
	endif

;------------------
	ifd	cws_DETACH

;------------------
; Okay, run from CLI or shell: Open dos.library.
;
\opendos:
	bsr	OpenDosLib
	bne.s	\getcd
	move.w	#fail_nodos,d0
	jsr	Alert(a4)		;*** failure
	bne.s	\opendos
	bra	\exit

;------------------
; Get current directory.
;
\getcd:
	move.l	d0,a6
	moveq	#0,d1
	jsr	-126(a6)		;CurrentDir()
	move.l	d0,cws_lock(a4)		;remember for duplock.
	exg.l	d0,d1
	jsr	-126(a6)		;CurrentDir()

	IFD	cws_V36PLUSONLY
	move.l	cws_launchtask(a4),a3
	move.l	$bc(a3),cws_homedir(a4)	;HomeDir...
	ENDIF

;------------------
; Count number of segments.
;
\countsegments:
	lsl.l	#2,d6

\againc:moveq	#0,d1
	move.l	d6,a3
	move.l	$3c(a3),d0		;first segment
	bra.s	\entry

\loop:
	addq.l	#1,d1
	move.l	(a0),d0
	beq.s	\gotnumber
\entry:
	lsl.l	#2,d0
	move.l	d0,a0
	bra.s	\loop

\gotnumber:
	move.w	d1,cws_segnumber(a4)

;------------------
; Get enough memory for mementry for all segments.
;
\getmementrymem:
	addq.l	#2,d1
	lsl.l	#3,d1
	moveq	#1,d0
	exg.l	d0,d1
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	move.l	d0,cws_mementry(a4)
	bne.s	\launchproc
	move.w	#fail_nomementry,d0
	jsr	Alert(a4)		;*** failure
	bne.s	\againc
	bra	\closedos

;------------------
; Create new process under forbid.
;
\launchproc:
	jsr	-132(a6)		;Forbid()
	move.l	cws_launchtask(a4),a2
	lea	$3c(a3),a0
	move.l	(a0),cws_myseg(a4)
	clr.l	(a0)			;remove all other segments
\againp:pea	\gocli-4(pc)
	move.l	(sp)+,d3		;routine
	lsr.l	#2,d3
	pea	processname(a4)
	move.l	(sp)+,d1		;name
	moveq	#0,d2

	ifnd	cws_PRI
	move.b	9(a2),d2		;copy pri of parent
	else
	moveq	#cws_PRI,d2
	endif

	ifnd	cws_STACKSIZE
	move.l	$34(a3),d4		;copy stack longwords
	lsl.l	#2,d4			;bytes stack
	else
	move.l	#cws_STACKSIZE,d4	;custom stack size
	endc
	bsr	GetDosBase
	jsr	-138(a6)		;CreateProc()

;------------------
; If error occured link mementry in parent process.
;
\testprocess:
	move.l	d0,a2			;process ID
	move.l	d0,d3			;remember this
	bne.s	\insertmem
	move.w	#fail_noprocess,d0
	jsr	Alert(a4)		;*** failure
	bne.s	\againp
	move.l	cws_launchtask(a4),a2
	lea	$5c(a2),a2		;link in mementry in own task

;------------------
; Insert mementry structure.
;
\insertmem:
	lea	-18(a2),a2		;start of tc_mementry
	move.l	(a2),a1			;remember old head
	move.l	cws_mementry(a4),a0
	move.l	a0,(a2)			;new head in list
	move.l	a0,4(a1)		;new pred in second node
	move.l	a1,(a0)+		;next in our node
	move.l	a2,(a0)+		;pred in our node
	move.w	#$a00,(a0)+		;type: memory  pri: 0
	clr.l	(a0)+			;noname
	move.w	cws_segnumber(a4),d7
	move.w	d7,(a0)+		;#of entries

;------------------
; Fill it out.
;
\fillout:
	subq.w	#1,d7
	move.l	cws_myseg(pc),a1

\fillloop:
	add.l	a1,a1
	add.l	a1,a1
	subq.l	#4,a1
	move.l	a1,(a0)+		;address
	move.l	(a1)+,(a0)+		;length
	move.l	(a1)+,a1
	dbra	d7,\fillloop

;-------------------
; Now, all went fine(d3<>0)?.
;
\didwe:
	tst.l	d3
	beq	\noforbid

;------------------
; Send message to child. Send first message to process port, others
; to custom port.
;
\sendmsg:
	st.b	cws_sync(a4)		;we begin...
	move.l	d3,cws_portptr(a4)
	
\sendmsgloop:
	move.l	cws_launchtask(pc),a2
	lea	$5c(a2),a2
	move.l	cws_portptr(pc),a0
	lea	cws_messy(pc),a1
	move.l	a2,14(a1)		;replyport...
	move.l	4.w,a6
	jsr	-366(a6)		;PutMsg()

;------------------
; Wait for reply.
;
\wait:
	move.l	a2,a0
	jsr	-384(a6)		;WaitPort()
	move.l	a2,a0
	jsr	-372(a6)		;GetMsg()
	move.l	d0,a0
	lea	cws_messy(pc),a1
	move.l	20(a0),d0
	beq.s	\sendend

;------------------
; Permit, call routine, forbid and wait for nilroutine messy.
;
\call:
	pea	\rts(pc)
	move.l	d0,-(sp)
	jmp	-138(a6)		;Permit() and then routine
\rts:
	jsr	-132(a6)
	bra	\sendmsgloop

;------------------
; Send final message to child.
;
\sendend:
	move.l	cws_portptr(pc),a0
	lea	cws_messy(pc),a1
	jsr	-366(a6)		;PutMsg()

;------------------
; Prepare to Permit().
;
\noforbid:
	pea	-138(a6)		;Permit()

;------------------
; Close dos.library.
;
\closedos:
	bsr	CloseDosLib

;------------------
; Leave this code.
;
\exit:
	movem.l	cws_regs(a4),d0-a5	;a6=[4] for permit()!
	move.l	cws_returnvalue(pc),d0	;returnvalue
	rts

;--------------------------------------------------------------------
; Patch return address, handle locks and go to cli (foreign task territory).
;
\makebcpl:
	align.l				;because of BCPL
	dc.l	0,0			;some monitors crash when this is not here

\gocli:	lea	cws_base(pc),a4
	lea	cws_returnaddr(pc),a0
	move.l	(sp)+,(a0)		;remember real return
	move.l	4.w,a6
	move.l	$114(a6),a0
	move.l	$80(a0),d0
	beq.s	\openport
	lsl.l	#2,d0
	move.l	d0,a0
	move.l	cws_myseg(pc),$c(a0)		;copy segment list.

;------------------
; Open new port and fail if not.
;
\openport:
	lea	cws_port(pc),a0
	bsr	MakePort
	bne.s	\gotport
	move.w	#fail_nostartp,d0
	jsr	Alert(a4)		;*** failure
	bne.s	\openport

\bad:	suba.l	a0,a0
	bsr	ReplySync
	bra	\fexit

\gotport:
	lea	cws_dummy(pc),a0
	bsr	ReplySync

;------------------
; Change directory to the new lock.
;
\changedir:
	bsr	OpenDosLib		;the child will free it when ending
	move.l	d0,a6			;it exists, parent has it still open
	move.l	cws_lock(pc),d1
	beq.s	\lockduped
	jsr	-96(a6)			;DupLock()
	move.l	d0,d1
	move.l	d0,cws_lock(a4)
	move.l	d0,cws_currentdir(a4)

\lockduped:
	jsr	-126(a6)		;CurrentDir() DOES NOT USE MSGS!

	IFD	cws_V36PLUSONLY
	move.l	cws_homedir(pc),d1
	beq.s	\nghd
	jsr	-96(a6)			;DupLock()
	move.l	d0,cws_homedir(a4)
	move.l	4.w,a6
	move.l	$114(a6),a4
	move.l	d0,$bc(a4)
\nghd:	ENDIF

	IFD	cws_EASYLIB
	bsr	cws_openlibraries
	bne.s	\go
	suba.l	a0,a0
	bsr	ReplySync
	bra.s	\unlock

	ENDIF

\go:	movem.l	cws_regs(pc),d0-a6
	jsr	clistartup(pc)		;GO!

	IFD	cws_EASYLIB
	bsr	CloseLibrary
	ENDIF

;------------------
; Unlock DupLock()ed struct
;
\unlock:
	movem.l	d0-a6,-(sp)

	IFD	cws_V36PLUSONLY
	move.l	cws_homedir(pc),d1
	beq.s	\nhd
	bsr	GetDosBase
	jsr	-90(a6)			;Unlock()
	move.l	4.w,a6
	move.l	$114(a6),a4
	clr.l	$bc(a4)
	
\nhd:	ENDIF

	move.l	cws_lock(pc),d1
	beq.s	\nlock
	bsr	GetDosBase
	jsr	-90(a6)			;Unlock()
	moveq	#0,d1
	jsr	-126(a6)		;ChangeDir()

\nlock:	bsr	CloseDosLib

	movem.l	(sp)+,d0-a6

\fexit:	move.l	cws_returnaddr(pc),-(sp)
	rts

;------------------

;------------------------------------------------------------------------------
*
* ReplySync	Reply to startup message and set routine.
*
* INPUT:	a0	Address of routine to be called
*
* RESULT:	Waits for startup message and replies to it, setting
*		the routine field to d0. Then it waits again for a
*		message. This routine can be called without concideration
*		of WB or CLI start or if ReplySync already terminated.
*
;------------------------------------------------------------------------------

;------------------
ReplySync:

;------------------
; Get task address.
;
\start:
	movem.l	d0-a6,-(sp)
	lea	cws_wbstartup(pc),a3
	tst.b	(a3)			;from WB?
	bne.s	\exit
	move.b	cws_sync(pc),d0		;done yet?
	beq.s	\exit
	move.l	a0,a3
	move.l	4.w,a6
	move.l	cws_portptr(pc),a2

;------------------
; Wait for messy and test if it is 'messy'.
;
\wait:
	move.l	a2,a0
	jsr	-384(a6)		;WaitPort()
	move.l	a2,a0
	jsr	-372(a6)		;GetMsg()
	tst.l	d0
	beq.s	\wait
	move.l	d0,a1
	lea	cws_messy(pc),a0
	cmp.l	a0,a1
	bne.s	\wait
	pea	cws_dummy(pc)
	cmp.l	(sp)+,a3
	bne.s	\nodummy
	lea	cws_portptr(pc),a0
	pea	cws_port(pc)
	move.l	(sp)+,(a0)		;set new port to use.

\nodummy:
	move.l	a3,20(a1)
	jsr	-378(a6)		;ReplyMsg()

;------------------
; Now wait again, either for next messy or for final messy.
; If final messy, get it so DOS can then use port for IO.
;
\again
	move.l	cws_portptr(pc),a2
	move.l	a2,a0
	jsr	-384(a6)		;WaitPort()
	move.l	a3,d0
	bne.s	\exit
	move.l	a2,a0
	jsr	-372(a6)		;GetMsg()
	lea	cws_port(pc),a0
	bsr	UnMakePort
	lea	cws_sync(pc),a0
	clr.b	(a0)

;------------------
; Exit.
;
\exit:
	movem.l	(sp)+,d0-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
; Data only used by detaching startup.
;

;------------------
	include	alert.r
	include	ports.r

;------------------
	AddAlert_	fail_nodos,"Unable to open dos.library"
	AddAlert_	fail_nomementry,"No memory for mementry struct"
	AddAlert_	fail_noprocess,"Unable to create process"
	AddAlert_	fail_nostartp,"Unable to create port"

;------------------
; Startup message.
;
cws_messy:	dc.l	0,0
		dc.b	05,0
		dc.l	0
		dc.l	0	;replyport
		dc.w	24	;length
cws_routine:	dc.l	0	;routine to be called

cws_dummy:	rts		;dummy routine for port switch

;------------------
; Second port.
;
cws_port:
	ds.b	10,0
	dc.l	0		;no name
	dc.b	0,0		;flag,sigbit
	dc.l	0		;sigtask
	ds.b	14,0		;MSG list

;------------------
cws_portptr:	dc.l	0
cws_myseg:	dc.l	0
cws_mementry:	dc.l	0
cws_lock:	dc.l	0
cws_currentdir:	dc.l	0
cws_segnumber:	dc.w	0
cws_sync:	dc.b	0
		dc.b	0
cws_returnvalue:dc.l	0

;------------------

;--------------------------------------------------------------------

;------------------
	else	

;------------------
; Simply go to start.
;
\gocli:
	IFD	cws_EASYLIB
	moveq	#0,d0
	bsr	cws_openlibraries
	beq.s	\nogo
	ENDIF

	IFD	cws_V36PLUSONLY
	move.l	cws_launchtask(a4),a3
	move.l	$bc(a3),cws_homedir(a4)	;HomeDir...
	ENDIF

	move.l	(sp)+,cws_returnaddr(a4)
	movem.l	cws_regs(a4),d0-a6
	jsr	clistartup(pc)
	move.l	cws_returnaddr(pc),-(sp)

	IFD	cws_EASYLIB
	bsr	CloseLibrary
	ENDIF

\nogo:	rts

;------------------
	endif

;------------------

;------------------------------------------------------------------------------
*
* ReplyWBMsg	Reply to workbench message and go forbid.
*
* RESULT:	Replies to cws_wbmessage and calls Forbid() because the WB
*		imediately frees the process memory. This routine can be
*		called without concideration of WB or CLI start.
*
;------------------------------------------------------------------------------

;------------------
ReplyWBMsg:

;------------------
; Start.
;
\start:
	movem.l	d0-a6,-(sp)
	lea	cws_wbstartup(pc),a0
	tst.b	(a0)			;from CLI?
	beq.s	\exit

	lea	cws_wbmessage(pc),a1
	move.l	(a1),d0
	beq.s	\exit
	clr.l	(a1)
	move.l	d0,a1

	move.l	4.w,a6
	jsr	-132(a6)		;ReplyMsg frees segments!
	jsr	-378(a6)		;ReplyMsg()

;------------------
; End.
;
\exit:
	movem.l	(sp)+,d0-a6
	rts

;------------------
; Data always used.
;
cws_wbstartup:	dc.b	0	;-1 for WB, 0 for CLI
cws_kick20:	dc.b	0	;-1 for 2.0+, 0 for 1.2/1.3
cws_kick30:	dc.b	0	;-1 for 3.0+, 0 for lower
		dc.b	0
cws_launchtask:	dc.l	0
cws_wbmessage:	dc.l	0
cws_returnaddr:	dc.l	0
cws_regs:	ds.l	15,0
	IFD	cws_V36PLUSONLY
cws_homedir:	dc.l	0
	ENDIF

;------------------
	include	doslib.r

;------------------

;--------------------------------------------------------------------

	IFD	cws_EASYLIB
;------------------

ely_NOALERT	SET	1
	include	easylibrary.r
	include	alert.r

cws_alerttext:
	AddAlert_	fail_nolibs,"Could not open                            "

;------------------
; Open libs wanted and display alert if one fails!
;
;	ccr=>EQ if failed
;
cws_openlibraries:
	movem.l	d0-a6,-(sp)

\again:	bsr	OpenLibrary
	tst.l	d0
	bne.s	\done
	bsr	CloseLibrary
	lea	cws_alerttext+15(pc),a1
\loop:	move.b	(a0)+,(a1)+
	bne.s	\loop
	move.w	#fail_nolibs,d0
	bsr	Alert
	bne.s	\again

\done:	movem.l	(sp)+,d0-a6
	rts

;------------------
	ENDIF

;--------------------------------------------------------------------

;------------------
	base	cws_oldbase

;------------------
	endif

	end

