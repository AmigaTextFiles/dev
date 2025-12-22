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
SIGF_GO		equ		SIGBREAKF_CTRL_D
SIGF_STOP	equ		SIGBREAKF_CTRL_E
SIGF_INT	equ		SIGBREAKF_CTRL_F

AD516BASE	equ		a5

*----------------------------------------------------------------------------
*mpega library defines
*----------------------------------------------------------------------------
MPEGA_MODE_STEREO	equ	0
MPEGA_MODE_J_STEREO	equ	1
MPEGA_MODE_DUAL		equ	2
MPEGA_MODE_MONO		equ	3
MPEGA_MAX_CHANNELS	equ	2
MPEGA_PCM_SIZE		equ	1152
MPEGA_ERR_NONE		equ	0
MPEGA_ERR_BASE		equ	0
MPEGA_ERR_EOF		equ	MPEGA_ERR_BASE-1
MPEGA_ERR_BADFRAME	equ	MPEGA_ERR_BASE-2
MPEGA_ERR_MEM		equ	MPEGA_ERR_BASE-3
MPEGA_ERR_NO_SYNC	equ	MPEGA_ERR_BASE-4
MPEGA_ERR_BADVALUE	equ	MPEGA_ERR_BASE-5

_LVOMPEGA_open		equ	-30
_LVOMPEGA_close		equ	-36
_LVOMPEGA_decode_frame	equ	-42
_LVOMPEGA_find_sync	equ	-60

   STRUCTURE	MPEGA_OUTPUT,0
	WORD	freq_div
	WORD	quality
	LONG	freq_max
	LABEL	MPEGA_OUTPUT_SIZE

   STRUCTURE	MPEGA_LAYER,0
	WORD	force_mono
	STRUCT	mono,MPEGA_OUTPUT_SIZE
	STRUCT	stereo,MPEGA_OUTPUT_SIZE
	LABEL	MPEGA_LAYER_SIZE

   STRUCTURE	MPEGA_CTRL,0
	APTR	bs_access
	STRUCT	layer_1_2,MPEGA_LAYER_SIZE
	STRUCT	layer_3,MPEGA_LAYER_SIZE
	WORD	check_mpeg
	LONG	stream_buffer_size
	LABEL	MPEGA_CTRL_SIZE

   STRUCTURE	MPEGA_STREAM,0
	WORD	norm
	WORD	layer
	WORD	mode
	WORD	bitrate
	LONG	frequency
	WORD	channels
	ULONG	ms_duration
	WORD	private_bit
	WORD	copyright
	WORD	original
	WORD	dec_channels
	WORD	dec_quality
	LONG	dec_frequency
	APTR	handle
	LABEL	MPEGA_STREAM_SIZE



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
*Get command line argument
*----------------------------------------------------------------------------
		move.l		#ArgsTemplate,d1
		move.l		#ArgsArray,d2
		moveq		#0,d3
		movea.l		d0,a6
		jsr		_LVOReadArgs(a6)
		move.l		d0,ArgsAnchor
		lea		1,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Get expansion library base
*----------------------------------------------------------------------------
		lea		ExpansionName,a1
		moveq		#37,d0
		movea.l		_AbsExecBase,a6
		jsr		_LVOOpenLibrary(a6)
		move.l		d0,_ExpansionBase
		lea		2,a0
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
		lea		3,a0
		beq		Cleanup

		movea.l		d0,a1
		tst.l		cd_Driver(a1)	;quit if card is in use
		lea		4,a0
		bne		Cleanup

		moveq		#1,d0
		move.l		d0,cd_Driver(a1)	;mark card in use
		move.l		cd_BoardAddr(a1),d0	;get board address
		move.l		d0,_AD516Base


*----------------------------------------------------------------------------
*Get mpega library base
*----------------------------------------------------------------------------
		lea		MpegaName,a1
		moveq		#0,d0
		movea.l		_AbsExecBase,a6
		jsr		_LVOOpenLibrary(a6)
		move.l		d0,_MpegaBase
		lea		5,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Open file for input
*----------------------------------------------------------------------------
		lea		ArgsArray,a0	;get filename from commandline
		move.l		(a0),a0

		lea		MpegControl,a1
		move.w		#1,check_mpeg(a1)
		move.l		#16384,stream_buffer_size(a1)

		lea		layer_1_2(a1),a2
		lea		mono(a2),a3
		move.w		#1,freq_div(a3)
		move.w		#2,quality(a3)
		move.w		#48000,freq_max(a3)
		lea		stereo(a2),a3
		move.w		#1,freq_div(a3)
		move.w		#2,quality(a3)
		move.w		#48000,freq_max(a3)

		lea		layer_3(a1),a2
		lea		mono(a2),a3
		move.w		#1,freq_div(a3)
		move.w		#2,quality(a3)
		move.w		#48000,freq_max(a3)
		lea		stereo(a2),a3
		move.w		#1,freq_div(a3)
		move.w		#2,quality(a3)
		move.w		#48000,freq_max(a3)

		movea.l		d0,a6
		jsr		_LVOMPEGA_open(a6)
		move.l		d0,InStream
		lea		6,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Start the play task
*----------------------------------------------------------------------------
		lea		PlayTask,a1
		move.b		#NT_TASK,LN_TYPE(a1)
		move.b		#64,LN_PRI(a1)
		lea		PlayTaskName,a0
		move.l		a0,LN_NAME(a1)
		lea		PlayTaskStack,a0
		move.l		a0,TC_SPLOWER(a1)
		lea		4000(a0),a0
		move.l		a0,TC_SPUPPER(a1)
		move.l		a0,TC_SPREG(a1)
		lea		PlayTaskStart,a2
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
		lea		7,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Establish a memory pool for the read buffers
*----------------------------------------------------------------------------
		move.l		#MEMF_PUBLIC|MEMF_CLEAR,d0
		move.l		#MPEGA_PCM_SIZE*8*2,d1	;8 frames PCM data
		move.l		d1,d2
		lsr.l		#1,d2
		movea.l		_AbsExecBase,a6
		jsr		_LVOCreatePool(a6)
		move.l		d0,Pool
		lea		8,a0
		beq		Cleanup


*----------------------------------------------------------------------------
*Allocate memory for 4 buffers
*----------------------------------------------------------------------------
		moveq		#3,d4
		lea		StorageList,a4
CreateBuffers	move.l		#MPEGA_PCM_SIZE*8*2,d0	;8 frames PCM data
		movea.l		Pool,a0
		jsr		_LVOAllocPooled(a6)
		move.l		d0,(a4,d4.w*4)
		lea		9,a0
		beq		Cleanup
		dbra		d4,CreateBuffers



*****************************************************************************
**********************************MAIN TASK**********************************
*****************************************************************************
*----------------------------------------------------------------------------
*Assign often used references to registers
*----------------------------------------------------------------------------
		moveq		#0,d6		;buffer index
		lea		LengthList,a3	;table of sample lengths
		lea		BufferList,a4	;decoding buffer pointers
		lea		StorageList,a5	;table of buffer pointers


*----------------------------------------------------------------------------
*Set up buffer table for MPEGA_decode_frame()
*----------------------------------------------------------------------------
		move.l		(a5),(a4)	;left decode buffer
		move.l		4(a5),4(a4)	;right decode buffer
		moveq		#7,d5		;8 frames per buffer


*----------------------------------------------------------------------------
*Pre-load first buffer with PCM data
*----------------------------------------------------------------------------
PreLoadBuffer	movea.l		InStream,a0
		movea.l		a4,a1
		movea.l		_MpegaBase,a6
		jsr		_LVOMPEGA_decode_frame(a6)
		tst.l		d0
		beq.s		PreLoadBuffer	;in case of skipped frame
		bmi		EndPlayback
		add.l		d0,(a3)		;add # samples to total
		lsl.l		#1,d0
		add.l		d0,(a4)		;move pointers to start of
		add.l		d0,4(a4)	;next frame in buffers
		dbra		d5,PreLoadBuffer


*----------------------------------------------------------------------------
*Change buffer index (we're double buffering you know)
*----------------------------------------------------------------------------
		bchg.l		#0,d6


*----------------------------------------------------------------------------
*Signal play task to start sending buffers to the AD516
*----------------------------------------------------------------------------
		move.l		#SIGF_GO,d0
		lea		PlayTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)


*----------------------------------------------------------------------------
*Display program information
*----------------------------------------------------------------------------
Greeting	lea		InfoString,a0
		move.l		a0,d1
		movea.l		_DosBase,a6
		jsr		_LVOPutStr(a6)


*----------------------------------------------------------------------------
*Main task loop
*----------------------------------------------------------------------------
MainLoop	move.l		(a5,d6.w*8),(a4)	;left decode buffer
		move.l		4(a5,d6.w*8),4(a4)	;right decode buffer
		moveq		#7,d5			;8 frames per buffer


*----------------------------------------------------------------------------
*Load current section of buffers with PCM data
*----------------------------------------------------------------------------
ReadFrame	movea.l		InStream,a0
		movea.l		a4,a1
		movea.l		_MpegaBase,a6
		jsr		_LVOMPEGA_decode_frame(a6)
		tst.l		d0
		beq.s		ReadFrame	;in case of skipped frame
		bmi		EndPlayback
		add.l		d0,(a3,d6.w*4)	;add # samples to total
		lsl.l		#1,d0
		add.l		d0,(a4)		;move pointers to start of
		add.l		d0,4(a4)	;next frame in buffers
		dbra		d5,ReadFrame


*----------------------------------------------------------------------------
*Change buffer index (we're double buffering you know)
*----------------------------------------------------------------------------
		bchg.l		#0,d6


*----------------------------------------------------------------------------
*Wait for signal from play task or user
*----------------------------------------------------------------------------
WaitForSignal	move.l		#SIGF_GO|SIGF_STOP|SIGBREAKF_CTRL_C,d0
		movea.l		_AbsExecBase,a6
		jsr		_LVOWait(a6)
		andi.l		#SIGF_GO,d0
		bne.s		MainLoop


*----------------------------------------------------------------------------
*Signal play task to stop playing and wait for response
*----------------------------------------------------------------------------
EndPlayback	cmpi.l		#MPEGA_ERR_EOF,d0
		lea		10,a0
		bmi.s		Cleanup		;in case of a decoding error
		move.l		#SIGF_STOP,d0
		lea		PlayTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)
		move.l		#SIGF_STOP,d0
		jsr		_LVOWait(a6)


*----------------------------------------------------------------------------
*Terminate program
*----------------------------------------------------------------------------
Terminate	lea		11,a0


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
**********************************PLAY TASK**********************************
*****************************************************************************
*----------------------------------------------------------------------------
*Assign often used references to registers
*----------------------------------------------------------------------------
PlayTaskStart	moveq		#0,d6		;buffer index
		lea		LengthList,a4	;buffer sample count table
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
ConfigSettings	COMMAND		InputVol,#0,#0		;input off
		COMMAND		Chan1Vol,#$8000,#$8000	;normal volume (0 db)
		COMMAND		Chan2Vol,#$8000,#$8000	;normal volume (0 db)
		COMMAND		OutputVol,#$8000,#$8000	;normal volume (0 db)
		COMMAND		ReadPM
		READPORT	d0
		COMMAND		MODE|ON
		READPORT	d0
		COMMAND		PLAY_BLOCK|ON
		COMMAND		DataRegAdj,#$4000,#$c0f0


*----------------------------------------------------------------------------
*Set playback frequency to that of mpeg stream
*----------------------------------------------------------------------------
		lea		FreqTable,a0
		movea.l		InStream,a1
		moveq		#3,d1
GetFrequency	move.l		(a0)+,d0
		addq		#4,a0
		cmp.l		frequency(a1),d0
		dbeq		d1,GetFrequency
		tst.l		d1
		bmi		SetOutput
		move.w		-(a0),d2
		move.w		-(a0),d1

		COMMAND		DataRegAdj,#$3F3F,#$c0f0
		COMMAND		MODE|OFF
		READPORT	d0
		COMMAND		CntrlRegAdj,d1,d2	;set frequency
		COMMAND		MODE|ON
		READPORT	d0
		COMMAND		DataRegAdj,#$4000,#$c0f0


*----------------------------------------------------------------------------
*Set audio output mode (mono or stereo)
*----------------------------------------------------------------------------
SetOutput	movea.l		InStream,a0
		move.w		channels(a0),d0
		cmpi.w		#2,d0
		beq.s		StereoMode
		COMMAND		Chan1Gain,#$8000,#$8000	;channel 1 center
		bra.s		WaitForStart
StereoMode	COMMAND		Chan1Gain,#$8000,#0	;channel 1 full left
		COMMAND		Chan2Gain,#0,#$8000	;channel 2 full right


*----------------------------------------------------------------------------
*Wait for main task to signal -- flush any interrupt signals
*----------------------------------------------------------------------------
WaitForStart	move.l		#SIGF_GO|SIGF_STOP|SIGF_INT,d0
		jsr		_LVOWait(a6)
		move.l		d0,d1
		andi.l		#SIGF_STOP,d0
		bne		EndPlayTask
		andi.l		#SIGF_GO,d1
		beq.s		WaitForStart


*----------------------------------------------------------------------------
*Pre-load buffer pointers and set borrow count to 0
*----------------------------------------------------------------------------
		moveq		#0,d4		;samples borrowed from buffer
		lea		StorageList,a3
		movea.l		(a3,d6.w*8),a2	;pointer to left samples
		movea.l		4(a3,d6.w*8),a3	;pointer to right samples


*----------------------------------------------------------------------------
*Calculate how many blocks of 1024 samples are in current buffer
*----------------------------------------------------------------------------
Play		move.l		(a4,d6.w*4),d5	;get # of samples in buffer
		sub.l		d4,d5		;adjust for borrowed samples
		bls		EndPlayTask	;exit if no samples left
		moveq		#0,d0
		move.l		d0,(a4,d6.w*4)	;reset sample count to zero
		move.l		d5,d4
		lsl.l		#6,d5		;a quick way to divide by 1024
		swap		d5		;result is in lower word of d5
		andi.l		#$03ff,d4	;samples left over from divide
		move.l		#1024,d3	;1024 samples in a full block


*----------------------------------------------------------------------------
*Wait for interrupt
*----------------------------------------------------------------------------
PutBuffers	move.l		#SIGF_INT,d0
		jsr		_LVOWait(a6)


*----------------------------------------------------------------------------
*Write left channel PCM data to AD516 (usually 1024 samples, could be less)
*----------------------------------------------------------------------------
		move.l		d3,d0
		subq		#1,d0

PutLeft		WRITEFIFO	(a2)+		;write 1 sample to AD516
		dbra		d0,PutLeft	;loop until all written

		move.l		d3,d0
		lsl.l		#5,d0
		ori.l		#PlayChan1,d0
		WRITEPORT	d0		;send play command to AD516


*----------------------------------------------------------------------------
*Write right channel PCM data to AD516 (usually 1024 samples, could be less)
*----------------------------------------------------------------------------
		move.l		d3,d0
		subq		#1,d0

PutRight	WRITEFIFO	(a3)+		;write 1 sample to AD516
		dbra		d0,PutRight	;loop until all written

		move.l		d3,d0
		lsl.l		#5,d0
		ori.l		#PlayChan2,d0
		WRITEPORT	d0		;send play command to AD516


*----------------------------------------------------------------------------
*Decrement counter and branch until all PCM data is sent
*----------------------------------------------------------------------------
		subq		#1,d5
		bhi		PutBuffers	;write out all full blocks
		bmi.s		SwitchBuffer	;wrote leftover samples
		move.l		d4,d3		;are there leftover samples?
		bne		PutBuffers	;if so then write them


*----------------------------------------------------------------------------
*Switch to other PCM buffer (we're double buffering you know)
*----------------------------------------------------------------------------
SwitchBuffer	bchg.l		#0,d6		;switch to other PCM buffer
		lea		StorageList,a3
		movea.l		(a3,d6.w*8),a2	;pointer to left samples
		movea.l		4(a3,d6.w*8),a3	;pointer to right samples
		tst.l		d4		;did FIFO get 1024 samples?
		beq		SignalMainTask	;if so continue on normally
		move.l		#1024,d4	;if not borrow samples from
		sub.l		d3,d4		;new buffer and pad FIFO


*----------------------------------------------------------------------------
*Pad FIFO out to 1024 samples
*----------------------------------------------------------------------------
		move.l		d4,d0
		subq		#1,d0

PadLeft		WRITEFIFO	(a2)+		;write 1 sample to AD516
		dbra		d0,PadLeft	;loop until all written

		move.l		d4,d0
		lsl.l		#5,d0
		ori.l		#PlayChan1,d0
		WRITEPORT	d0		;send play command to AD516


*----------------------------------------------------------------------------
*Pad FIFO out to 1024 samples
*----------------------------------------------------------------------------
		move.l		d4,d0
		subq		#1,d0

PadRight	WRITEFIFO	(a3)+		;write 1 sample to AD516
		dbra		d0,PadRight	;loop until all written

		move.l		d4,d0
		lsl.l		#5,d0
		ori.l		#PlayChan2,d0
		WRITEPORT	d0		;send play command to AD516


*----------------------------------------------------------------------------
*Tell main task to load new buffer with PCM data
*----------------------------------------------------------------------------
SignalMainTask	move.l		#SIGF_GO,d0
		movea.l		MainTask,a1
		jsr		_LVOSignal(a6)


*----------------------------------------------------------------------------
*Check if playing should continue
*----------------------------------------------------------------------------
		moveq		#0,d0
		moveq		#0,d1
		jsr		_LVOSetSignal(a6)
		andi.l		#SIGF_STOP,d0
		beq		Play


*----------------------------------------------------------------------------
*Turn off card - stops interrupts (good for when interrupt server goes away)
*----------------------------------------------------------------------------
EndPlayTask	COMMAND		PLAY_BLOCK|OFF
		COMMAND		DataRegAdj,#$3f3f,#$c0f0
		COMMAND		MODE|OFF
		READPORT	d0


*----------------------------------------------------------------------------
*Wait for play task to end - respond to signals from main task
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
HandleInterrupt	btst.b		#AD516INT,(a1)	;is it from AD516?
		beq.s		GotInterrupt	;if so then handle it
		moveq		#0,d0		;else pass it down the chain
		rts


*----------------------------------------------------------------------------
*Interrupt came from AD516
*----------------------------------------------------------------------------
GotInterrupt	btst.b		#RDOK68,(a1)	;wait until ok to read PORT
		bne.s		GotInterrupt
		move.w		d0,(a1)		;clear AD516 interrupt
		move.w		PORT(a1),d0	;read PORT
		move.l		#SIGF_INT,d0	;signal play task
		lea		PlayTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)
		moveq		#1,d0		;this was our interrupt
		rts



*****************************************************************************
****************************HOUSEKEEPING ROUTINES****************************
*****************************************************************************
*----------------------------------------------------------------------------
*Free all allocated memory (I love memory pools!)
*----------------------------------------------------------------------------
Cleanup8	movea.l		Pool,a0
		movea.l		_AbsExecBase,a6
		jsr		_LVODeletePool(a6)


*----------------------------------------------------------------------------
*Wait for play task to finish and then remove the interrupt server
*----------------------------------------------------------------------------
Cleanup7	move.l		#SIGF_STOP,d0
		lea		PlayTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)
		move.l		#SIGF_STOP,d0
		jsr		_LVOWait(a6)
		move.l		#INTB_EXTER,d0
		lea		Interrupt,a1
		jsr		_LVORemIntServer(a6)


*----------------------------------------------------------------------------
*Remove the play task
*----------------------------------------------------------------------------
Cleanup6	lea		PlayTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVORemTask(a6)


*----------------------------------------------------------------------------
*Close mpeg file
*----------------------------------------------------------------------------
Cleanup5	movea.l		InStream,a0
		movea.l		_MpegaBase,a6
		jsr		_LVOClose(a6)


*----------------------------------------------------------------------------
*Close the mpega library
*----------------------------------------------------------------------------
Cleanup4	movea.l		_MpegaBase,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOCloseLibrary(a6)


*----------------------------------------------------------------------------
*Mark the AD516 as not in use and then close the expansion library
*----------------------------------------------------------------------------
Cleanup3	moveq		#0,d0
		movea.l		AD516ConfigDev,a1
		move.l		d0,cd_Driver(a1)
		movea.l		_ExpansionBase,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOCloseLibrary(a6)


*----------------------------------------------------------------------------
*Done with command line argument
*----------------------------------------------------------------------------
Cleanup2	move.l		ArgsAnchor,d1
		movea.l		_DosBase,a6
		jsr		_LVOFreeArgs(a6)


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
		dc.l		Cleanup3
		dc.l		Cleanup3
		dc.l		Cleanup3
		dc.l		Cleanup4
		dc.l		Cleanup5
		dc.l		Cleanup7
		dc.l		Cleanup8
		dc.l		Cleanup8
		dc.l		Cleanup8

PrintTable	dc.l		NoDosBaseString
		dc.l		UsageString
		dc.l		NoExpBaseString
		dc.l		NoAD516String
		dc.l		InUseString
		dc.l		NoMpgBaseString
		dc.l		NoStreamString
		dc.l		NoIntString
		dc.l		NoMemString
		dc.l		NoBufferString
		dc.l		DecodeErrString
		dc.l		TerminateString

FreqTable	dc.l		22050,$211c2200
		dc.l		32000,$211c1200
		dc.l		44100,$212c2200
		dc.l		48000,$21341200

InfoString	dc.b		'AD516 MPEG Player  (C) 2001 Chris Brenner',10,10
		dc.b		'Playing...',10
		dc.b		'Press <CTRL-C> To End Playback',10,10,0

NoDosBaseString	dc.b		'Unable to access dos.library! Exiting...',10,0
UsageString	dc.b		'Usage: AD516mpeg <mpeg file>',10,0
NoExpBaseString	dc.b		'Unable to access expansion.library! Exiting...',10,0
NoAD516String	dc.b		'Unable to find an AD516 card! Exiting...',10,0
InUseString	dc.b		'AD516 card is being used by another program! Exiting...',10,0
NoMpgBaseString	dc.b		'Unable to access mpega.library! Exiting...',10,0
NoStreamString	dc.b		'Unable to find mpeg audio stream! Exiting...',10,0
NoIntString	dc.b		'Unable to install interrupt server! Exiting...',10,0
NoMemString	dc.b		'Unable to create a memory pool!  Exiting...',10,0
NoBufferString	dc.b		'Out of buffer space! Exiting...',10,0
DecodeErrString	dc.b		'Error encountered while decoding mpeg stream! Exiting...',10,0
TerminateString	dc.b		'**Finished**',10,0

DOSName		dc.b		'dos.library',0
ExpansionName	dc.b		'expansion.library',0
MpegaName	dc.b		'mpega.library',0
InterruptName	dc.b		'AD516 Interrupt',0
PlayTaskName	dc.b		'AD516 Play Task',0
ArgsTemplate	dc.b		'FILENAME/A',0

VersionString	dc.b		'$VER: AD516mpeg 0.1 (20.11.01) (C) 2001 Chris Brenner',0



*****************************************************************************
**********************************STORAGE************************************
*****************************************************************************
		SECTION		MyBss,BSS

_AbsExecBase	ds.l		1
_DosBase	ds.l		1
_ExpansionBase	ds.l		1
_MpegaBase	ds.l		1
_AD516Base	ds.l		1
AD516ConfigDev	ds.l		1
InStream	ds.l		1
MainTask	ds.l		1
ArgsAnchor	ds.l		1
ArgsArray	ds.l		2
Pool		ds.l		1
LengthList	ds.l		2
BufferList	ds.l		2
StorageList	ds.l		4
PlayTaskStack	ds.l		1024
MpegControl	ds.b		MPEGA_CTRL_SIZE
		CNOP		0,4
Interrupt	ds.b		IS_SIZE
		CNOP		0,4
PlayTask	ds.b		TC_SIZE



*****************************************************************************
**********************************DSP CODE***********************************
*****************************************************************************
		SECTION		dsp,DATA

;DSPCode
*----------------------------------------------------------------------------
*Removed to conform to Aminet copyright rules -- take a look at DumpDSPCode.s
*----------------------------------------------------------------------------


		end
