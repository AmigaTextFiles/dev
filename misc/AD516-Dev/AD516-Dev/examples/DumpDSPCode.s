		include		"libraries/configvars.i"
		include		"dos/dos.i"
		include		"exec/memory.i"
		include		"hardware/intbits.i"
		include		"hardware/ad516.i"
		include		"offsets/offsets.i"


		SECTION		main,CODE

		lea		4,a6
		move.l		(a6),a6
		move.l		a6,_AbsExecBase


		lea		DOSName,a1
		clr.l		d0
		jsr		_LVOOpenLibrary(a6)
		move.l		d0,_DosBase
		lea		0,a0
		beq		Cleanup


		lea		InFileName,a0
		move.l		a0,d1
		move.l		#MODE_OLDFILE,d2
		movea.l		_DosBase,a6
		jsr		_LVOOpen(a6)
		move.l		d0,InFile
		lea		1,a0
		beq		Cleanup


		lea		Buffer,a0
		move.l		InFile,d1
		move.l		a0,d2
		move.l		#65536,d3
		movea.l		_DosBase,a6
		jsr		_LVORead(a6)
		move.l		d0,d6
		lea		2,a0
		bmi		Cleanup
		beq		Terminate


		cmpi.l		#51264,d0
		lea		3,a0
		bne		Cleanup


		lea		OutFileName,a0
		move.l		a0,d1
		move.l		#MODE_NEWFILE,d2
		jsr		_LVOOpen(a6)
		move.l		d0,OutFile
		lea		4,a0
		beq		Cleanup


		lea		Buffer,a0
		adda.l		#3148,a0
		move.l		OutFile,d1
		move.l		a0,d2
		move.l		#4096,d3
		jsr		_LVOWrite(a6)
		tst.l		d0
		lea		5,a0
		bmi		Cleanup


Terminate	lea		6,a0


Cleanup		lea		PrintTable,a1
		move.l		0(a1,a0.l*4),d1
		lea		JumpTable,a1
		movea.l		0(a1,a0.l*4),a2
		beq.s		CallCleanup
		move.l		_DosBase,a6
		jsr		_LVOPutStr(a6)
CallCleanup	jsr		(a2)

Exit		moveq		#0,d0
		rts


Cleanup3	move.l		OutFile,d1
		jsr		_LVOClose(a6)


Cleanup2	move.l		InFile,d1
		jsr		_LVOClose(a6)


Cleanup1	movea.l		_DosBase,a1
		movea.l		_AbsExecBase,a6
		jsr		_LVOCloseLibrary(a6)


Cleanup0	rts


		SECTION		data,DATA

JumpTable	dc.l		Cleanup0
		dc.l		Cleanup1
		dc.l		Cleanup2
		dc.l		Cleanup2
		dc.l		Cleanup2
		dc.l		Cleanup3
		dc.l		Cleanup3

PrintTable
		dc.l		NoDosBaseString
		dc.l		NoInFileString
		dc.l		ReadErrString
		dc.l		WrongVerString
		dc.l		NoOutFileString
		dc.l		WriteErrString
		dc.l		TerminateString

NoDosBaseString	dc.b		'Unable to access dos.library! Exiting...',10,0
NoInFileString	dc.b		'Unable to open the AD516Handler file for input. Exiting...',10,0
ReadErrString	dc.b		'Read Error on input file. Exiting...',10,0
WrongVerString	dc.b		'Version Error! Studio 16 version 3.01 required. Exiting...',10,0
NoOutFileString	dc.b		'Unable to open the DSPCode file for output. Exiting...',10,0
WriteErrString	dc.b		'Write Error on output file. Exiting...',10,0
TerminateString	dc.b		'--- Code Dump Complete ---',10,0


DOSName		dc.b		'dos.library',0
InFileName	dc.b		'Studio16_3:Drivers/AD516Handler',0
OutFileName	dc.b		'RAM:DSPCode',0


		SECTION		MyBss,BSS

_AbsExecBase	ds.l		1
_DosBase	ds.l		1
InFile		ds.l		1
OutFile		ds.l		1
Buffer		ds.b		65536


		end
