*****************************************************************************
**********************************INCLUDES***********************************
*****************************************************************************
		include		"libraries/configvars.i"
		include		"dos/dos.i"
		include		"exec/interrupts.i"
		include		"hardware/intbits.i"
		include		"hardware/ad516.i"
		include		"offsets/offsets.i"



*****************************************************************************
***********************************DEFINES***********************************
*****************************************************************************
SIGF_INT	EQU		SIGBREAKF_CTRL_F

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
		movea.l		_AbsExecBase,a6
		jsr		_LVOAddIntServer(a6)
		tst.l		d0
		lea		4,a0
		beq		Cleanup



*****************************************************************************
**********************************MAIN TASK**********************************
*****************************************************************************
*----------------------------------------------------------------------------
*Set up a5 for AD516 macros
*----------------------------------------------------------------------------
		movea.l		_AD516Base,a5


*----------------------------------------------------------------------------
*Display program information
*----------------------------------------------------------------------------
		lea		InfoString,a0
		move.l		a0,d1
		movea.l		_DosBase,a6
		jsr		_LVOPutStr(a6)


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
*Configure AD516 settings -- enable input monitor and set input gain to 0 db
*----------------------------------------------------------------------------
ConfigSettings	COMMAND		OutputVol,#$8000,#$8000	;output volume 0 db
		COMMAND		MODE|ON
		READPORT	d0
		COMMAND		PLAY_BLOCK|ON
		COMMAND		InputVol,#$8000,#$8000	;input volume 0 db
		COMMAND		DataRegAdj,#$4000,#$c0f0 ;input gain 0 db


*----------------------------------------------------------------------------
*Render bar graph meters
*----------------------------------------------------------------------------
		moveq		#9,d6
		lea		MeterPanel,a0
		move.l		a0,d1
		movea.l		_DosBase,a6
		jsr		_LVOPutStr(a6)
		moveq		#7,d7

WaitPeak	move.l		#SIGF_INT|SIGBREAKF_CTRL_C,d0
		move.l		_AbsExecBase,a6
		jsr		_LVOWait(a6)
		andi.l		#SIGBREAKF_CTRL_C,d0
		bne		StopCard

		movea.l		_DosBase,a6
		dbra		d7,GetPeaks
		lea		ClearMeter,a0	;clear bar graph
		move.l		a0,d1
		jsr		_LVOPutStr(a6)
		moveq		#7,d7


GetPeaks	COMMAND		HiLowReq
		READPORT	d5		;read left input peak
		swap		d5
		READPORT	d5		;read right input peak
		swap		d5


		moveq		#8,d1		;read chan1 - chan9 peaks
FlushPeaks	READPORT	d0
		READPORT	d0
		dbra		d1,FlushPeaks

ShowPeaks	moveq		#0,d2		;render left channel bar graph
		lea		MeterString,a0
		move.l		a0,d1
		move.w		d5,d2
		lsr.l		d6,d2
		jsr		_LVOWriteChars(a6)

		lea		DownMeter,a0	;position cursor
		move.l		a0,d1
		jsr		_LVOPutStr(a6)

		moveq		#0,d2		;render right channel bar graph
		swap		d5
		lea		MeterString,a0
		move.l		a0,d1
		move.w		d5,d2
		lsr.l		d6,d2
		jsr		_LVOWriteChars(a6)

		lea		UpMeter,a0	;position cursor
		move.l		a0,d1
		jsr		_LVOPutStr(a6)

		bra		WaitPeak


*----------------------------------------------------------------------------
*Turn off card - stops interrupts (good for when interrupt server goes away)
*----------------------------------------------------------------------------
StopCard	COMMAND		DataRegAdj,#$3f3f,#$c0f0 ;input gain 0 db
		COMMAND		InputVol,#0,#0
		COMMAND		PLAY_BLOCK|OFF
		COMMAND		MODE|OFF
		READPORT	d0


*----------------------------------------------------------------------------
*Terminate program
*----------------------------------------------------------------------------
Terminate	lea		5,a0


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
		move.w		PORT(a1),d0	;read interrupt message


SendIntSignal	move.l		#SIGF_INT,d0
		movea.l		MainTask,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOSignal(a6)

EndInterrupt	moveq		#1,d0		;this was our interrupt
		rts



*****************************************************************************
****************************HOUSEKEEPING ROUTINES****************************
*****************************************************************************
*----------------------------------------------------------------------------
*Remove the interrupt server
*----------------------------------------------------------------------------
Cleanup3	move.l		#INTB_EXTER,d0
		lea		Interrupt,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVORemIntServer(a6)


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
*Just return
*----------------------------------------------------------------------------
Cleanup0	rts


*****************************************************************************
*********************************STATIC DATA*********************************
*****************************************************************************
		SECTION		data,DATA

JumpTable	dc.l		Cleanup0
		dc.l		Cleanup1
		dc.l		Cleanup2
		dc.l		Cleanup2
		dc.l		Cleanup2
		dc.l		Cleanup3

PrintTable	dc.l		NoDosBaseString
		dc.l		NoExpBaseString
		dc.l		NoAD516String
		dc.l		InUseString
		dc.l		NoIntString
		dc.l		TerminateString

MeterPanel	dc.b		$9b,$30,$20,$70,13
		dc.b		$9b,'30;41;>0m',13
		dc.b		'                                                                      ',10
		dc.b		'  db -24             -10                  -4      -2      -1      0   ',10
		dc.b		'  L                                                                   ',10
		dc.b		'  R                                                                   ',10
		dc.b		'  db -24             -10                  -4      -2      -1      0   ',10
		dc.b		'                                                                      ',10
		dc.b		$9b,$34,$41,13
		dc.b		$9b,'33;41;>0m',13
		dc.b		$9b,$34,$43,0

MeterString	dc.b		'================================================================'

DownMeter	dc.b		13,$9b,$31,$42,13,$9b,$34,$43,0

UpMeter		dc.b		13,$9b,$31,$41,13,$9b,$34,$43,0

ClearMeter	dc.b		'                                                                '
		dc.b		13,$9b,$31,$42,13,$9b,$34,$43
		dc.b		'                                                                '
		dc.b		13,$9b,$31,$41,13,$9b,$34,$43,0

InfoString	dc.b		'AD516meters  (C) 2001 Chris Brenner',10,10
		dc.b		'Monitoring Input...',10
		dc.b		'Press <CTRL-C> To Exit',10,10,0

NoDosBaseString	dc.b		'Unable to access dos.library! Exiting...',10,0
NoExpBaseString	dc.b		'Unable to access expansion.library! Exiting...',10,0
NoAD516String	dc.b		'Unable to find an AD516 card! Exiting...',10,0
InUseString	dc.b		'AD516 is being used by another program! Exiting...',10,0
NoIntString	dc.b		'Unable to install interrupt server! Exiting...',10,0
TerminateString	dc.b		$9b,$20,$70,13,$9b,$35,$42,13,$9b,'31;40;>0m',13,'**Finished**',10,0

DOSName		dc.b		'dos.library',0
ExpansionName	dc.b		'expansion.library',0
InterruptName	dc.b		'AD516 Interrupt',0

VersionString	dc.b		'$VER: AD516meters 0.1 (30.11.01) (C) 2001 Chris Brenner',0



*****************************************************************************
**********************************STORAGE************************************
*****************************************************************************
		SECTION		MyBss,BSS

_AbsExecBase	ds.l		1
_DosBase	ds.l		1
_ExpansionBase	ds.l		1
_AD516Base	ds.l		1
AD516ConfigDev	ds.l		1
MainTask	ds.l		1
Interrupt	ds.b		IS_SIZE



*****************************************************************************
**********************************DSP CODE***********************************
*****************************************************************************
		SECTION		dsp,DATA

DSPCode
*----------------------------------------------------------------------------
*Removed to conform to Aminet copyright rules -- take a look at DumpDSPCode.s
*----------------------------------------------------------------------------


		end
