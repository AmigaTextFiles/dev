*****************************************************************************
**********************************INCLUDES***********************************
*****************************************************************************
		include		"libraries/configvars.i"
		include		"dos/dos.i"
		include		"exec/memory.i"
		include		"exec/tasks.i"
		include		"exec/interrupts.i"
		include		"hardware/intbits.i"
		include		"hardware/ad516.i"
		include		"offsets.i"



*****************************************************************************
***********************************DEFINES***********************************
*****************************************************************************
SIGF_GO		EQU		SIGBREAKF_CTRL_D
SIGF_STOP	EQU		SIGBREAKF_CTRL_E
SIGF_FAIL	EQU		SIGBREAKF_CTRL_F
SIGF_INTL	EQU		SIGBREAKF_CTRL_F
SIGF_INTR	EQU		SIGF_SINGLE

AD516BASE	EQUR		a5



*****************************************************************************
***************************INITIALIZATION ROUTINES***************************
*****************************************************************************
		SECTION		main,CODE
*----------------------------------------------------------------------------
*Get execbase
*----------------------------------------------------------------------------
		lea		4,a6
		move.l		(a6),a6
		move.l		a6,_AbsExecBase


*----------------------------------------------------------------------------
*Find address for this task
*----------------------------------------------------------------------------
		lea		0,a1
		jsr		_LVOFindTask(a6)
		move.l		d0,MainTask


*----------------------------------------------------------------------------
*Set task priority to 2
*----------------------------------------------------------------------------
		movea.l		d0,a1
		moveq		#2,d0
		jsr		_LVOSetTaskPri(a6)


*----------------------------------------------------------------------------
*Get dos library base
*----------------------------------------------------------------------------
		lea		DOSName,a1
		clr.l		d0
		jsr		_LVOOpenLibrary(a6)
		move.l		d0,_DosBase
		lea		0,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Get expansion library base
*----------------------------------------------------------------------------
		lea		ExpansionName,a1
		moveq		#37,d0
		jsr		_LVOOpenLibrary(a6)
		move.l		d0,_ExpansionBase
		lea		1,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Find the first AD516 card
*----------------------------------------------------------------------------
		movea.l		d0,a6
		lea		0,a0
		move.l		#SUNRIZEID,d0
		moveq		#AD516ID,d1
		jsr		_LVOFindConfigDev(a6)
		move.l		d0,AD516ConfigDev
		lea		2,a0
		beq		Cleanup

		movea.l		d0,a1
		tst.l		cd_Driver(a1)		;quit if card in use
		lea		3,a0
		bne		Cleanup

		moveq		#1,d0
		move.l		d0,cd_Driver(a1)	;mark card in use
		move.l		cd_BoardAddr(a1),d0	;get board address
		move.l		d0,_AD516Base


*----------------------------------------------------------------------------
*Start the record task
*----------------------------------------------------------------------------
		lea		RecTask,a1
		move.b		#NT_TASK,LN_TYPE(a1)
		move.b		#64,LN_PRI(a1)
		lea		RecTaskName,a0
		move.l		a0,LN_NAME(a1)
		lea		RecTaskStack,a0
		move.l		a0,TC_SPLOWER(a1)
		lea		4000(a0),a0
		move.l		a0,TC_SPUPPER(a1)
		move.l		a0,TC_SPREG(a1)
		lea		RecTaskStart,a2
		lea		0,a3
		movea.l		_AbsExecBase,a6
		jsr		_LVOAddTask(a6)


*----------------------------------------------------------------------------
*Install the interrupt server
*----------------------------------------------------------------------------
		lea		Interrupt,a1
		move.b		#NT_INTERRUPT,LN_TYPE(a1)
		move.b		#64,LN_PRI(a1)
		lea		InterruptName,a0
		move.l		a0,LN_NAME(a1)
		move.l		_AD516Base,d0
		move.l		d0,IS_DATA(a1)
		lea		HandleInterrupt,a0
		move.l		a0,IS_CODE(a1)
		moveq		#INTB_EXTER,d0
		jsr		_LVOAddIntServer(a6)
		tst.l		d0
		lea		4,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Open PIPE: for output
*----------------------------------------------------------------------------
		lea		FileName,a0
		move.l		a0,d1
		move.l		#MODE_NEWFILE,d2
		movea.l		_DosBase,a6
		jsr		_LVOOpen(a6)
		move.l		d0,OutFile
		lea		5,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Establish a memory pool for the write buffers
*----------------------------------------------------------------------------
		move.l		#MEMF_PUBLIC,d0
		moveq		#1,d1
		swap		d1
		move.l		d1,d2
		lsr.l		#1,d2
		movea.l		_AbsExecBase,a6
		jsr		_LVOCreatePool(a6)
		move.l		d0,Pool
		lea		6,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Allocate memory for 16 buffers -- more will be allocated as needed
*----------------------------------------------------------------------------
		moveq		#15,d4
		lea		BufferList,a4
CreateBuffers	moveq		#1,d0
		swap		d0
		movea.l		Pool,a0
		jsr		_LVOAllocPooled(a6)
		move.l		d0,(a4,d4.w*4)
		lea		6,a0
		beq		Cleanup
		dbra		d4,CreateBuffers


*----------------------------------------------------------------------------
*Mark all buffers as free
*----------------------------------------------------------------------------
		moveq		#-1,d0
		move.l		#2047,d2
		lea		BlockList,a2
FillBlockList	move.w		d0,(a2,d2.w*2)
		dbra		d2,FillBlockList



*****************************************************************************
**********************************MAIN TASK**********************************
*****************************************************************************
*----------------------------------------------------------------------------
*Assign often used references to registers
*----------------------------------------------------------------------------
		moveq		#0,d6		;table index
		lea		BlockList,a3	;table of pending writes
		lea		BufferList,a4	;table of buffer addresses


*----------------------------------------------------------------------------
*Display program information and prompt user
*----------------------------------------------------------------------------
		lea		InfoString,a0
		move.l		a0,d1
		movea.l		_DosBase,a6
		jsr		_LVOPutStr(a6)


*----------------------------------------------------------------------------
*Wait for user response
*----------------------------------------------------------------------------
		move.l		#SIGBREAKF_CTRL_C,d0
		movea.l		_AbsExecBase,a6
		jsr		_LVOWait(a6)


*----------------------------------------------------------------------------
*Inform user how to end program
*----------------------------------------------------------------------------
		lea		RecordString,a0
		move.l		a0,d1
		movea.l		_DosBase,a6
		jsr		_LVOPutStr(a6)


*----------------------------------------------------------------------------
*Signal record task to begin recording
*----------------------------------------------------------------------------
		move.l		#SIGF_GO,d0
		lea		RecTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)


*----------------------------------------------------------------------------
*Wait for signals from record task
*----------------------------------------------------------------------------
MainLoop	move.l		#SIGF_GO|SIGF_FAIL,d0
		movea.l		_AbsExecBase,a6
		jsr		_LVOWait(a6)
		andi.l		#SIGF_FAIL,d0
		lea		7,a0
		bne		Cleanup


*----------------------------------------------------------------------------
*Write out buffers that are marked
*----------------------------------------------------------------------------
WriteBlocks	tst.w		(a3,d6.w*2)	;is this buffer ready?
		bmi.s		MainLoop	;if not then wait some more


*----------------------------------------------------------------------------
*Write buffer pointed to by index
*----------------------------------------------------------------------------
		move.l		OutFile,d1
		move.l		(a4,d6.w*4),d2	;get address of buffer
		moveq		#1,d3
		swap		d3		;block size always 64k
		movea.l		_DosBase,a6
		jsr		_LVOWrite(a6)
		tst.l		d0
		lea		8,a0
		bmi		Cleanup


*----------------------------------------------------------------------------
*Load new buffer table index and mark current buffer as free
*----------------------------------------------------------------------------
		moveq		#-1,d0		;-1 indicates buffer is free
		move.l		d6,d1		;save current index
		move.w		(a3,d1.w*2),d6	;load new index from table
		move.w		d0,(a3,d1.w*2)	;mark current buffer as free


*----------------------------------------------------------------------------
*Check if user terminated recording
*----------------------------------------------------------------------------
		moveq		#0,d0
		moveq		#0,d1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSetSignal(a6)
		andi.l		#SIGBREAKF_CTRL_C,d0
		beq.s		WriteBlocks


*----------------------------------------------------------------------------
*Inform user that unwritten buffers are being flushed
*----------------------------------------------------------------------------
		lea		FlushString,a0
		move.l		a0,d1
		movea.l		_DosBase,a6
		jsr		_LVOPutStr(a6)


*----------------------------------------------------------------------------
*Signal record task to stop recording and wait for response
*----------------------------------------------------------------------------
		move.l		#SIGF_STOP,d0
		lea		RecTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)
		move.l		#SIGF_STOP|SIGF_FAIL,d0
		jsr		_LVOWait(a6)


*----------------------------------------------------------------------------
*Flush unwritten blocks
*----------------------------------------------------------------------------
FlushBlocks	tst.w		(a3,d6.w*2)	;is there an unwritten buffer?
		bmi.s		Terminate	;if not then quit


*----------------------------------------------------------------------------
*Write buffer pointed to by index
*----------------------------------------------------------------------------
		move.l		OutFile,d1
		move.l		(a4,d6.w*4),d2
		moveq		#1,d3
		swap		d3
		movea.l		_DosBase,a6
		jsr		_LVOWrite(a6)
		tst.l		d0
		lea		8,a0
		bmi		Cleanup


*----------------------------------------------------------------------------
*Load new index and and mark current buffer as free
*----------------------------------------------------------------------------
		moveq		#-1,d0
		move.l		d6,d1
		move.w		(a3,d1.w*2),d6
		move.w		d0,(a3,d1.w*2)
		bra.s		FlushBlocks


*----------------------------------------------------------------------------
*Terminate program
*----------------------------------------------------------------------------
Terminate	lea		9,a0


*----------------------------------------------------------------------------
*Call housekeeping routines - a0 has entry into list of routines
*----------------------------------------------------------------------------
Cleanup		lea		PrintTable,a1
		move.l		0(a1,a0.l*4),d1
		lea		JumpTable,a1
		movea.l		0(a1,a0.l*4),a2
		beq.s		CallCleanup
		move.l		_DosBase,a6
		jsr		_LVOPutStr(a6)
CallCleanup	jsr		(a2)


*----------------------------------------------------------------------------
*Exit to shell
*----------------------------------------------------------------------------
Exit		moveq		#0,d0
		rts



*****************************************************************************
*********************************RECORD TASK*********************************
*****************************************************************************
*----------------------------------------------------------------------------
*Assign often used references to registers
*----------------------------------------------------------------------------
RecTaskStart	moveq		#16,d5		;# of allocated buffers
		moveq		#0,d6		;table index
		lea		BlockList,a3	;table of buffer flags
		lea		BufferList,a4	;table of buffer addressess
		movea.l		_AD516Base,a5	;address of AD516 card
		movea.l		_AbsExecBase,a6	;this one's pretty obvious


*----------------------------------------------------------------------------
*Load the operating code into the AD516 card
*----------------------------------------------------------------------------
LoadDSPCode	WAKEUP					;wake up card
		COMMAND		LoadCode,#0,#$03f1	;issue command
		move.l		#$03f0,d0		;write code to card
		lea		DSPCode,a0
GetDSPWords	move.w		(a0)+,d1
		move.w		(a0)+,d2
		lsr.w		#8,d2
		WRITEPORT	d2
		WRITEPORT	d1
		dbra		d0,GetDSPWords
		WAKEUP


*----------------------------------------------------------------------------
*Configure AD516 settings
*----------------------------------------------------------------------------
ConfigSettings	COMMAND		OutputVol,#$8000,#$8000	;output volume 0 db
		COMMAND		MODE|ON
		READPORT	d0
		COMMAND		PLAY_BLOCK|ON
		COMMAND		InputVol,#$8000,#$8000	;input volume 0 db
		COMMAND		DataRegAdj,#$4000,#$c0f0 ;input gain 0 db


*----------------------------------------------------------------------------
*Wait for main task to signal -- flush any interrupt signals
*----------------------------------------------------------------------------
WaitForStart	move.l		#SIGF_GO|SIGF_STOP,d0
		jsr		_LVOWait(a6)
		move.l		d0,d1
		andi.l		#SIGF_STOP,d0
		bne		EndRecTask
		andi.l		#SIGF_GO,d1
		beq.s		WaitForStart


*----------------------------------------------------------------------------
*Turn on record function
*----------------------------------------------------------------------------
		COMMAND		RecordInOn,#INPUTL
		READPORT	d0
		READPORT	d0
		COMMAND		RecordInOn,#INPUTR
		READPORT	d0
		READPORT	d0


*----------------------------------------------------------------------------
*Read data from card and store in buffer
*----------------------------------------------------------------------------
		move.l		(a4),d4		;for address comparison later
		movea.l		d4,a2		;address of first buffer


*----------------------------------------------------------------------------
*Wait for interrupt
*----------------------------------------------------------------------------
RecordHalf	move.l		#SIGF_INTL,d0
		jsr		_LVOWait(a6)

*----------------------------------------------------------------------------
*Read left channel PCM data (1024 words) into temporary buffer
*----------------------------------------------------------------------------
		moveq		#31,d0
		lea		HalfBuffer,a0
GetHalf		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		move.w		FIFO(a5),(a0)+	;get 1 sample from AD516
		dbra		d0,GetHalf	;loop 32 times


*----------------------------------------------------------------------------
*Wait for next interrupt
*----------------------------------------------------------------------------
RecordFull	move.l		#SIGF_INTR,d0
		jsr		_LVOWait(a6)


*----------------------------------------------------------------------------
*Interleave left and right channel PCM data and put into current buffer
*----------------------------------------------------------------------------
		moveq		#31,d0
		lea		HalfBuffer,a0
GetFull		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		move.w		(a0)+,(a2)+	;left channel from buffer
		move.w		FIFO(a5),(a2)+	;right channel from AD516
		dbra		d0,GetFull	;loop 32 times


*----------------------------------------------------------------------------
*Determine if current buffer is full
*----------------------------------------------------------------------------
		cmp.w		a2,d4		;64 kbytes in buffer?
		bne		RecordHalf	;if not then go back for more


*----------------------------------------------------------------------------
*Find next free buffer
*----------------------------------------------------------------------------
		moveq		#0,d2		;start at top of table
FindBlock	cmp.w		d2,d6		;we know this one's in use
		beq.s		IncBlock	;find one that's not in use
		tst.w		(a3,d2.w*2)	;is buffer free? (= -1 ?)
		bmi.s		MarkBlock	;if so then  mark and use it
IncBlock	addq		#1,d2		;go to next entry in table
		cmp.w		d2,d5		;need to allocate new buffer?
		bne.s		FindBlock	;if not then find a free buffer


*----------------------------------------------------------------------------
*Allocate 64k for new buffer
*----------------------------------------------------------------------------
		addq		#1,d5		;increment buffer count
		moveq		#1,d0		;allocate 64k for new buffer
		swap		d0
		movea.l		Pool,a0
		jsr		_LVOAllocPooled(a6)
		move.l		d0,(a4,d2.w*4)	;add to buffer table
		bne.s		MarkBlock	;continue if successful


*----------------------------------------------------------------------------
*Memory allocation failed
*----------------------------------------------------------------------------
OutOfSpace	move.l		#SIGF_FAIL,d0	;system out of memory
		movea.l		MainTask,a1	;tell main task about it
		jsr		_LVOSignal(a6)
		bra.s		EndRecTask


*----------------------------------------------------------------------------
*Mark current buffer as ready to be written
*----------------------------------------------------------------------------
MarkBlock	move.w		d2,(a3,d6.w*2)	;point to next free buffer
		move.l		d2,d6		;put new entry into index
		move.l		(a4,d2.w*4),d4	;get new buffer address
		movea.l		d4,a2		;store for comparison later


*----------------------------------------------------------------------------
*Tell main task that there is a buffer ready to be written out
*----------------------------------------------------------------------------
		move.l		#SIGF_GO,d0
		movea.l		MainTask,a1
		jsr		_LVOSignal(a6)


*----------------------------------------------------------------------------
*Check if recording should continue
*----------------------------------------------------------------------------
		moveq		#0,d0
		moveq		#0,d1
		jsr		_LVOSetSignal(a6)
		andi.l		#SIGF_STOP,d0
		beq		RecordHalf


*----------------------------------------------------------------------------
*Turn off record function and input
*----------------------------------------------------------------------------
EndRecTask	COMMAND		RecordOff,#0
		COMMAND		RecordOff,#$0d
		COMMAND		DataRegAdj,#$3f3f,#$c0f0 ;input monitor off
		COMMAND		InputVol,#0,#0


*----------------------------------------------------------------------------
*Flush unread data out of card
*----------------------------------------------------------------------------
FlushFifo	move.w		FIFO(a5),d0
		cmpi.w		#-1,d0
		bne.s		FlushFifo
		move.l		#1023,d1
FlushIt		move.w		FIFO(a5),d0
		cmpi.w		#-1,d0
		bne.s		FlushFifo
		dbra		d1,FlushIt


*----------------------------------------------------------------------------
*Turn off card - stops interrupts (good for when interrupt server goes away)
*----------------------------------------------------------------------------
StopCard	COMMAND		PLAY_BLOCK|OFF
		COMMAND		MODE|OFF
		READPORT	d0


*----------------------------------------------------------------------------
*Wait for record task to end - respond to signals from main task
*----------------------------------------------------------------------------
WaitForTheEnd	move.l		#SIGF_STOP,d0
		movea.l		MainTask,a1
		jsr		_LVOSignal(a6)

		move.l		#SIGF_STOP,d0
		jsr		_LVOWait(a6)
		bra.s		WaitForTheEnd



*****************************************************************************
*******************************INTERRUPT CODE********************************
*****************************************************************************
*----------------------------------------------------------------------------
*Got an interrupt -- a1 has base address of configured AD516 card
*----------------------------------------------------------------------------
HandleInterrupt	btst.b		#AD516INT,(a1)	;is it from AD516 card?
		beq.s		GotInterrupt	;if so then handle it
		moveq		#0,d0		;else pass it down the chain
		rts


*----------------------------------------------------------------------------
*Interrupt came from AD516
*----------------------------------------------------------------------------
GotInterrupt	btst.b		#RDOK68,(a1)	;wait until ok to read PORT
		bne.s		GotInterrupt
		move.w		d0,(a1)		;clear AD516 interrupt
		move.w		PORT(a1),d1	;read interrupt message

		btst.l		#RECINT,d1	;is this a record interrupt?
		bne.s		EndInterrupt	;if not then end server chain

		move.l		#SIGF_INTL,d0	;set up signal mask
		btst.l		#RECINTLEFT,d1	;left channel interrupt?
		beq.s		SendIntSignal	;if so then signal left
		move.l		#SIGF_INTR,d0	;else signal right

SendIntSignal	lea		RecTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)

EndInterrupt	moveq		#1,d0		;this was our interrupt
		rts



*****************************************************************************
****************************HOUSEKEEPING ROUTINES****************************
*****************************************************************************
*----------------------------------------------------------------------------
*Free all allocated memory (I love memory pools!)
*----------------------------------------------------------------------------
Cleanup6	movea.l		Pool,a0
		movea.l		_AbsExecBase,a6
		jsr		_LVODeletePool(a6)


*----------------------------------------------------------------------------
*Close PIPE:
*----------------------------------------------------------------------------
Cleanup5	move.l		OutFile,d1
		movea.l		_DosBase,a6
		jsr		_LVOClose(a6)


*----------------------------------------------------------------------------
*Wait for record task to finish and then remove the interrupt server
*----------------------------------------------------------------------------
Cleanup4	move.l		#SIGF_STOP,d0
		lea		RecTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)
		move.l		#SIGF_STOP,d0
		jsr		_LVOWait(a6)
		move.l		#INTB_EXTER,d0
		lea		Interrupt,a1
		jsr		_LVORemIntServer(a6)


*----------------------------------------------------------------------------
*Remove the record task
*----------------------------------------------------------------------------
Cleanup3	lea		RecTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVORemTask(a6)


*----------------------------------------------------------------------------
*Mark the AD516 as not in use and then close the expansion library
*----------------------------------------------------------------------------
Cleanup2	moveq		#0,d0
		movea.l		AD516ConfigDev,a1
		move.l		d0,cd_Driver(a1)
		movea.l		_ExpansionBase,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOCloseLibrary(a6)


*----------------------------------------------------------------------------
*Close the dos library
*----------------------------------------------------------------------------
Cleanup1	movea.l		_DosBase,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOCloseLibrary(a6)


*----------------------------------------------------------------------------
*Set task priority to 0
*----------------------------------------------------------------------------
Cleanup0	movea.l		MainTask,a1
		moveq		#0,d0
		movea.l		_AbsExecBase,a6
		jsr		_LVOSetTaskPri(a6)
		rts


*****************************************************************************
*********************************STATIC DATA*********************************
*****************************************************************************
		SECTION		data,DATA

JumpTable	dc.l		Cleanup0
		dc.l		Cleanup1
		dc.l		Cleanup2
		dc.l		Cleanup2
		dc.l		Cleanup3
		dc.l		Cleanup4
		dc.l		Cleanup5
		dc.l		Cleanup6
		dc.l		Cleanup6
		dc.l		Cleanup6

PrintTable	dc.l		NoDosBaseString
		dc.l		NoExpBaseString
		dc.l		NoAD516String
		dc.l		InUseString
		dc.l		NoIntString
		dc.l		NoPipeString
		dc.l		NoMemString
		dc.l		NoBufferString
		dc.l		WriteErrString
		dc.l		TerminateString

InfoString	dc.b		'AD516 Piping Recorder  (C) 2001 Chris Brenner',10,10
		dc.b		'Monitoring Input...',10
		dc.b		'Press <CTRL-C> To Begin Recording',10,10,0
RecordString	dc.b		'Recording...',10
		dc.b		'Press <CTRL-C> To End Recording',10,10,0
FlushString	dc.b		'Flushing Write Buffers...',10,10,0

NoDosBaseString	dc.b		'Unable to access dos.library! Exiting...',10,0
NoExpBaseString	dc.b		'Unable to access expansion.library! Exiting...',10,0
NoAD516String	dc.b		'Unable to find an AD516 card! Exiting...',10,0
InUseString	dc.b		'AD516 is being used by another program! Exiting...',10,0
NoIntString	dc.b		'Unable to install interrupt server! Exiting...',10,0
NoPipeString	dc.b		'Unable to open PIPE: for writing! Exiting...',10,0
NoMemString	dc.b		'Unable to create a memory pool! Exiting...',10,0
NoBufferString	dc.b		'Out of buffer space! Exiting...',10,0
WriteErrString	dc.b		'Error writing to PIPE:! Exiting...',10,0
TerminateString	dc.b		'**Finished**',10,0

DOSName		dc.b		'dos.library',0
ExpansionName	dc.b		'expansion.library',0
InterruptName	dc.b		'AD516 Interrupt',0
RecTaskName	dc.b		'AD516 Record Task',0
FileName	dc.b		'PIPE:',0

VersionString	dc.b		'$VER: AD516pipe 0.1 (20.11.01) (C) 2001 Chris Brenner',0



*****************************************************************************
**********************************STORAGE************************************
*****************************************************************************
		SECTION		MyBss,BSS

_AbsExecBase	ds.l		1
_DosBase	ds.l		1
_ExpansionBase	ds.l		1
_AD516Base	ds.l		1
AD516ConfigDev	ds.l		1
OutFile		ds.l		1
MainTask	ds.l		1
Pool		ds.l		1
BlockList	ds.w		2048
BufferList	ds.l		2048
HalfBuffer	ds.w		1024
RecTaskStack	ds.l		1024
Interrupt	ds.b		IS_SIZE
		CNOP		0,4
RecTask		ds.b		TC_SIZE



*****************************************************************************
**********************************DSP CODE***********************************
*****************************************************************************
		SECTION		dsp,DATA

;DSPCode
*----------------------------------------------------------------------------
*Removed to conform to Aminet copyright rules -- take a look at DumpDSPCode.s
*----------------------------------------------------------------------------


		end
