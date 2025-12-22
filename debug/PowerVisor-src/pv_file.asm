*****
****
***			F I L E   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Thu Mar 24 11:42:29 1994
***			© Jorrit Tyberghein
****
*****

 * Part of PowerVisor source   Copyright © 1994   Jorrit Tyberghein
 *
 * - You may modify this source provided that you DON'T remove this copyright
 *   message
 * - You may use IDEAS from this source in your own programs without even
 *   mentioning where you got the idea from
 * - If you use algorithms and/or literal copies from this source in your
 *   own programs, it would be nice if you would quote me and PowerVisor
 *   somewhere in one of your documents or readme's
 * - When you change and reassemble PowerVisor please don't use exactly the
 *   same name (use something like 'PowerVisor Plus' or
 *   'ExtremelyPowerVisor' :-) and update all the copyright messages to reflect
 *   that you have changed something. The important thing is that the user of
 *   your program must be warned that he or she is not using the original
 *   program. If you think the changes you made are useful it is in fact better
 *   to notify me (the author) so that I can incorporate the changes in the real
 *   PowerVisor
 * - EVERY PRODUCT OR PROGRAM DERIVED DIRECTLY FROM MY SOURCE MAY NOT BE
 *   SOLD COMMERCIALLY WITHOUT PERMISSION FROM THE AUTHOR. YOU MAY ASK A
 *   SHAREWARE FEE
 * - In general it is always best to contact me if you want to release
 *   some enhanced version of PowerVisor
 * - This source is mainly provided for people who are interested to see how
 *   PowerVisor works. I make no guarantees that your mind will not be warped
 *   into hyperspace by the complexity of some of these source code
 *   constructions. In fact, I make no guarantees at all, only that you are
 *   now probably looking at this copyright notice :-)
 * - YOU MAY NOT DISTRIBUTE THIS SOURCE CODE WITHOUT ALL OTHER SOURCE FILES
 *   NEEDED TO ASSEMBLE POWERVISOR. YOU MAY DISTRIBUTE THE SOURCE OF
 *   POWERVISOR WITHOUT THE EXECUTABLE AND OTHER FILES. THE ORIGINAL
 *   POWERVISOR DISTRIBUTION AND THIS SOURCE DISTRIBUTION ARE IN FACT TWO
 *   SEPERATE ENTITIES AND MAY BE TREATED AS SUCH


			INCLUDE	"pv.i"

			INCLUDE	"pv.file.i"
			INCLUDE	"pv.eval.i"
			INCLUDE	"pv.screen.i"
			INCLUDE	"TileWindows.i"

			INCLUDE	"pv.errors.i"

	XDEF		FileConstructor,FileDestructor,FRead
	XDEF		RoutHelp,FOpen,FClose,FSeek,FReadLine,PrintCLI
	XDEF		OutputHandle,ScriptFile,RoutLog,RoutTo,FileBase
	XDEF		SearchPath,GetTemplate,RoutAppendTo,OpenDos

	;memory
	XREF		AllocClear,FreeBlock,AllocBlockInt
	XREF		AllocMem,FreeMem,ReAlloc
	;eval
	XREF		SearchWord,ParseDec,LongToDec,SetList
	XREF		GetRestLinePer,GetStringE
	;main
	XREF		DosBase,Storage,ErrorFile,VarStorage
	XREF		Remind,ErrorHandler
	XREF		ExecAlias,LastError
	XREF		CopyFileName
	;screen
	XREF		LogWin_AttachFile,LogWin_SetFlags
	XREF		CurrentLW

;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

	STRUCTURE	File,0
		BPTR		ff_DosFile
		ULONG		ff_Pos				;Physical position in file
		APTR		ff_Buffer			;Ptr to buffer
		ULONG		ff_BufPos			;Postion in buffer
		ULONG		ff_BufSize			;Size of current buffer
		LABEL		ff_SIZE

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	;***
	;Constructor: init everything for files
	;-> flags is eq if error
	;***
FileConstructor:
		moveq		#1,d0
		rts

	;***
	;Destructor: remove everything for files
	;***
FileDestructor:
		move.l	(CtrlFile,pc),d1
		bsr		FClose
		move.l	(HelpFile,pc),d1
		bsr		FClose
		move.l	(ErrorFile),d1
		bsr		FClose
		move.l	(ScriptFile,pc),d1
		bsr		FClose
		move.l	(LogFile,pc),d1
		beq.b		1$
		CALLDOS	Close
1$		rts

	;***
	;Command: log the output from one command to a file
	;***
RoutTo:
		bsr		GetStringE			;Get file
		movea.l	a0,a5
		move.l	d0,d1
		moveq		#MODE_NEWFILE-1000,d2
		bsr		OpenDos
		ERROReq	OpenFile
		move.l	d0,d5
		move.l	d5,-(a7)				;Save file
LogOut:
		movea.l	(CurrentLW),a0
		move.l	(LogWin_File,a0),-(a7)
		move.l	d5,d0
		bsr		LogWin_AttachFile
		move.w	#LWF_FILE,d0
		move.w	d0,d1
		bsr		LogWin_SetFlags
		move.l	d0,-(a7)				;Save old flags
		move.l	a0,-(a7)				;Remember current logical window
		pea		(0).w					;No commandline yet on stack
		movea.l	a5,a0					;Restore commandline
	;Get command
		bsr		GetRestLinePer
		move.l	d0,d3					;If error d3 will be set to 0
		beq.b		1$
		movea.l	d0,a0
	;Establish an error routine to restore the current logfile later
		move.l	a0,(a7)				;cmdline (place was already reserved on stack)
		moveq		#EXEC_TO,d0
		bsr		ExecAlias
		move.l	d0,d2					;Result
		move.l	d1,d3					;Error status

	;Clean up
1$		bsr		CleanupTo			;Must be with 'bsr'!

	;Quit
		tst.l		d3
		HERReq
		move.l	d2,d0					;Result
		rts

	;***
	;Command: log the output from one command to an existing file
	;***
RoutAppendTo:
		bsr		GetStringE			;Get file
		movea.l	a0,a5
		move.l	d0,d1
		moveq		#MODE_READWRITE-1000,d2
		bsr		OpenDos
		ERROReq	OpenFile
		move.l	d0,d5
		move.l	d5,-(a7)
		move.l	d5,d1
		moveq		#0,d2
		moveq		#OFFSET_END,d3
		CALL		Seek
		bra.b		LogOut

	;***
	;Cleanup routine for 'to' command
	;***
CleanupTo:
		movea.l	(a7)+,a5				;Rts
		move.l	(a7)+,d0				;Commandline
		beq.b		2$
		movea.l	d0,a0
		bsr		FreeBlock
2$		movea.l	(a7)+,a0				;Get logical window to restore
		move.l	(a7)+,d0				;Get flags
		move.w	#LWF_FILE,d1
		bsr		LogWin_SetFlags
		move.l	(a7)+,d0				;Get old attached file
		bsr		LogWin_AttachFile
		move.l	(a7)+,d1				;Get file
		CALLDOS	Close
		jmp		(a5)

	;***
	;Command: log the output from a logical window to a file
	;***
RoutLog:
		tst.l		d0						;End of line
		beq.b		1$

	;First close the previous log file if there is one
		bsr		1$

		moveq		#I_LWIN,d6
		bsr		SetList
		EVALE								;Get logical window
		movea.l	d0,a5

		bsr		GetStringE
		move.l	d0,d1
		moveq		#MODE_NEWFILE-1000,d2
		bsr		OpenDos
		ERROReq	OpenFile
		lea		(LogFile,pc),a0
		move.l	d0,(a0)
		movea.l	a5,a0
		lea		(LogLogWin,pc),a1
		move.l	a5,(a1)				;Window where log file belongs
		bsr		LogWin_AttachFile
		move.w	#LWF_FILE,d0
		move.w	d0,d1
		bsr		LogWin_SetFlags
		rts

	;Close the log file
1$		move.l	(LogFile,pc),d1
		beq.b		2$						;There is no log file
		move.l	a0,-(a7)
		CALLDOS	Close
		movea.l	(LogLogWin,pc),a0
		lea		(LogFile,pc),a1
		clr.l		(a1)
		moveq		#0,d0
		bsr		LogWin_AttachFile
		movea.l	(a7)+,a0
2$		rts

	;***
	;Get template
	;a0 = pointer to command
	;***
GetTemplate:
		DEBUGPC	"Temp"
		lea		(WhyLine,pc),a1
		moveq		#18,d0
1$		move.b	(a0)+,(a1)+
		dbeq		d0,1$
		move.b	#'_',(-1,a1)
		move.b	#'t',(a1)+
		move.b	#'m',(a1)+
		move.b	#'p',(a1)+
		clr.b		(a1)+
		lea		(WhyLine,pc),a0
		bra.b		InRoutHelp

	;***
	;Command: give help
	;a0 = cmdline
	;***
RoutHelp:
		tst.l		d0						;End of line
		bne.b		InRoutHelp
		lea		(HelpArg,pc),a0
InRoutHelp:
		DEBUGPC	"IHlp"
		bsr		GetStringE
		movea.l	d0,a5					;Ptr to string
		lea		(CtrlFile,pc),a2
		tst.l		(a2)
		bne.b		1$
		lea		(pvCtrlFile,pc),a0
		bsr		CopyFileName
		beq.b		7$
		bsr		FOpen
7$		move.l	d0,(a2)
		bne.b		1$
	;Error
9$		lea		(ErrorHelp,pc),a0
		PRINT
		rts

1$		lea		(HelpFile,pc),a2
		tst.l		(a2)
		bne.b		2$
		lea		(pvHelpFile,pc),a0
		bsr		CopyFileName
		beq.b		8$
		bsr		FOpen
8$		move.l	d0,(a2)
		beq.b		9$
2$		move.l	(CtrlFile,pc),d1
		moveq		#0,d2
		moveq		#OFFSET_BEGINNING,d3
		bsr		FSeek
		movea.l	a5,a0
		movea.l	(CtrlFile,pc),a1
		lea		(GetNextFile,pc),a5
		bsr		SearchWord
		tst.l		d1
		ERROReq	NoHelpForSubject
		movea.l	(Storage),a0
		moveq		#1,d0					;Loop 2 times

3$		cmpi.b	#'|',(a0)+			;Skip first and then the second '|'
		bne.b		3$
		dbra		d0,3$

		lea		(1,a0),a0			;Skip space after second '|'
		bsr		ParseDec
		move.l	(HelpFile,pc),d1
		move.l	d0,d2
		moveq		#OFFSET_BEGINNING,d3
		bsr		FSeek
4$		move.l	(HelpFile,pc),d1
		move.l	(Storage),d2
		move.l	#198,d3
		bsr		FReadLine
		beq.b		5$
		addq.l	#1,d0					;== -1 ?
		HERReq
		movea.l	(Storage),a0
		cmpi.b	#'¬',(a0)			;Ignore-rest-of-line char
		beq.b		4$
		cmpi.b	#'=',(a0)
		bne.b		6$
		cmpi.b	#'=',(1,a0)
		bne.b		6$
		cmpi.b	#'=',(2,a0)
		bne.b		6$
5$		rts
6$		PRINT
		NEWLINE
		bra.b		4$

	;***
	;GetNext routine for files
	;a1 = ptr to list (PowerVisor filehandle in this case)
	;-> a1 = next list or 0 if error or end of files
	;***
GetNextFile:
		movem.l	a0/a5,-(a7)
3$		move.l	a1,d1
		move.l	(Storage),d2
		move.l	#198,d3
		move.l	a1,-(a7)
		bsr		FReadLine
		movea.l	(a7)+,a1				;For flags
		beq.b		4$
	;No end of file
		addq.l	#1,d0					;== -1 ?
		bne.b		1$
	;Error reading file
	;d0 is already 0
	;End of file or error
4$		movea.l	d0,a1					;0
		bra.b		2$

	;Normal file processing
1$		movea.l	(Storage),a3
		cmpi.b	#'#',(a3)
		beq.b		3$
2$		moveq		#1,d6
		movem.l	(a7)+,a0/a5
		rts

	;***
	;Open a DOS file
	;d1 = name
	;d2 = MODE_xxx-1000
	;-> d0 (flags) = filehandle
	;-> a6 = DOSBase
	;***
OpenDos:
		add.l		#1000,d2
		CALLDOS	Open
		tst.l		d0
		rts

;	IFD D20
;
;Normally I would like to use the 2.0 buffered file IO routines. But
;because these routines are a lot slower than my versions, I don't use
;them
;
;	;***
;	;Open a buffered file (only for reading) (2.0 version)
;	;d1 = ptr to name
;	;BUFSIZE=constant for buffer size
;	;-> d0 = ptr to filedescriptor (close with FClose) or 0 if no success
;	;		 (flags)
;	;-> d1 = d0
;	;***
;FOpen:
;		move.l	d2,-(a7)
;		moveq		#MODE_OLDFILE-1000,d2
;		bsr		OpenDos
;		move.l	(a7)+,d2
;		move.l	d0,d1
;		rts
;
;	;***
;	;Close a buffered file (2.0 version)
;	;d1 = ptr to file descriptor (may be NULL)
;	;-> d0 = 0 (for FOpen) (with flags)
;	;***
;FClose:
;		tst.l		d1
;		beq.b		1$
;		CALLDOS	Close
;1$		moveq		#0,d0
;		rts
;
;	;***
;	;Read from a buffered file (2.0 version)
;	;d1 = ptr to file descriptor
;	;d2 = ptr to destination
;	;d3 = size to read
;	;-> d0 = size that is read
;	;-> d1 = file descriptor
;	;***
;FRead:
;		movem.l	d1/d3-d4,-(a7)
;		move.l	d3,d4
;		moveq		#1,d3
;		CALLDOS	FRead
;		movem.l	(a7)+,d1/d3-d4
;		rts
;
;	;***
;	;Read a character from a buffered file (2.0 version)
;	;d1 = ptr to file descriptor
;	;-> d0 = character (-1 for EOF and -2 for error (flags 'lt'))
;	;-> d1 = file descriptor
;	;***
;FReadChar:
;		move.l	d1,-(a7)
;		CALLDOS	FGetC
;		move.l	(a7)+,d1
;		tst.l		d0
;		rts
;
;	;***
;	;Seek to a position in a buffered file (2.0 version)
;	;d1 = ptr to file descriptor
;	;d2 = position
;	;d3 = mode (OFFSET_BEGINNING, (OFFSET_END not supported yet) or OFFSET_CURRENT)
;	;-> d0 = old position
;	;-> d1 = file descriptor
;	;***
;FSeek:
;		move.l	d1,-(a7)
;		CALLDOS	Seek
;		move.l	(a7)+,d1
;		rts
;
;	;***
;	;Read a line from a buffered file (2.0 version)
;	;d1 = file descriptor
;	;d2 = address
;	;d3 = max length
;	;-> linelength+1 in d0
;	;	d0 = 0 if eof (flags), d0 = -1 if error
;	;-> d1 = file descriptor
;	;***
;FReadLine:
;		movem.l	d1-d2,-(a7)
;		CALLDOS	FGets
;		movem.l	(a7)+,d1-d2
;		tst.l		d0
;		beq.b		1$
;
;	;Success, compute length and remove newline
;		movea.l	d2,a0
;2$		move.b	(a0)+,d0
;		beq.b		3$
;		cmp.b		#10,d0
;		bne.b		2$
;		clr.b		(-1,a0)
;
;3$		suba.l	d2,a0
;		move.l	a0,d0					;d0 = len+1
;
;1$		rts
;
;	ENDC


;	IFND D20

	;***
	;Open a buffered file (only for reading) (1.3 version)
	;d1 = ptr to name
	;BUFSIZE=constant for buffer size
	;-> d0 = ptr to filedescriptor (close with FClose) or 0 if no success
	;		 (flags)
	;-> d1 = d0
	;***
FOpen:
		DEBUGPC	"FOpe"
		moveq		#ff_SIZE,d0
		bsr		AllocClear
		beq		ErrorFO
		move.l	a2,-(a7)
		movea.l	d0,a2
		move.l	#BUFSIZE,d0
		bsr		AllocClear
		beq.b		FCloseFO
		move.l	d0,(ff_Buffer,a2)
		moveq		#MODE_OLDFILE-1000,d2
		bsr		OpenDos
		SERReq	OpenFile,FCloseFO
		move.l	d0,(ff_DosFile,a2)
		clr.l		(ff_BufPos,a2)
		clr.l		(ff_BufSize,a2)
		move.l	a2,d0
		movea.l	(a7)+,a2
		move.l	d0,d1
		rts

	;***
	;Close a buffered file (1.3 version)
	;d1 = ptr to file descriptor (may be NULL)
	;-> d0 = 0 (for FOpen) (with flags)
	;***
FClose:
		tst.l		d1
		bne.b		1$
	;File descriptor is NULL
		rts

1$		move.l	a2,-(a7)
		movea.l	d1,a2
FCloseFO:
		move.l	(ff_Buffer,a2),d0
		beq.b		1$
		movea.l	d0,a1
		move.l	#BUFSIZE,d0
		bsr		FreeMem
1$		move.l	(ff_DosFile,a2),d1
		beq.b		2$
		CALLDOS	Close
2$		movea.l	a2,a1
		moveq		#ff_SIZE,d0
		bsr		FreeMem
		movea.l	(a7)+,a2
ErrorFO:
		moveq		#0,d0
		rts

	;***
	;Read from a buffered file (1.3 version)
	;d1 = ptr to file descriptor
	;d2 = ptr to destination
	;d3 = size to read
	;-> d0 = size that is read
	;-> d1 = file descriptor
	;***
FRead:
		movem.l	d1/d4/a2-a3,-(a7)
		movea.l	d2,a3					;Ptr to buffer
		moveq		#0,d4					;Number of chars read

		tst.l		d3
		beq.b		2$

	;Loop
1$		bsr		FReadChar			;Read one char
		bge.b		4$

	;There is something special
		addq.l	#1,d0					;== -1 ?
		beq.b		2$
		addq.l	#1,d0					;== -1 ?
		beq.b		3$
	;It is not possible to come here!

	;Normal operation
4$		addq.l	#1,d4
		move.b	d0,(a3)+
		subq.l	#1,d3
		bgt.b		1$

	;The end
2$		move.l	d4,d0
3$		movem.l	(a7)+,d1/d4/a2-a3
		rts

	;***
	;Read a character from a buffered file (1.3 version)
	;d1 = ptr to file descriptor
	;-> d0 = character (-1 for EOF and -2 for error (flags 'lt'))
	;-> d1 = file descriptor
	;***
FReadChar:
		movem.l	d1/a2,-(a7)
		movea.l	d1,a2
		move.l	(ff_BufPos,a2),d1
		cmp.l		(ff_BufSize,a2),d1
		bge.b		3$
		addq.l	#1,d1

5$		move.l	d1,(ff_BufPos,a2)
		movea.l	(ff_Buffer,a2),a0
		moveq		#0,d0
		move.b	(-1,a0,d1.l),d0

	;The end
4$		movem.l	(a7)+,d1/a2
		tst.l		d0
		rts

	;Buffer if full
3$		movem.l	d2-d3,-(a7)
		move.l	(ff_DosFile,a2),d1
		move.l	(ff_Buffer,a2),d2
		move.l	#BUFSIZE,d3
		CALLDOS	Read
		movem.l	(a7)+,d2-d3
		tst.l		d0
		ble.b		1$						;0 or -1 ?
		move.l	d0,(ff_BufSize,a2)
		add.l		d0,(ff_Pos,a2)		;Adjust physical position
		moveq		#1,d1
		bra.b		5$

	;EOF or error
1$		subq.l	#1,d0					;0 (EOF) -> -1 and -1 (error) -> -2
		bra.b		4$

	;***
	;Seek to a position in a buffered file (1.3 version)
	;d1 = ptr to file descriptor
	;d2 = position
	;d3 = mode (OFFSET_BEGINNING, (OFFSET_END not supported yet) or OFFSET_CURRENT)
	;-> d0 = old position
	;-> d1 = file descriptor
	;***
FSeek:
		movem.l	d1/a2,-(a7)
		movea.l	d1,a2
		move.l	(ff_Pos,a2),d1
		sub.l		(ff_BufSize,a2),d1
		add.l		(ff_BufPos,a2),d1	;Current pos
		move.l	d1,d0					;Remember old pos
		add.l		d2,d1					;New pos (if OFFSET_CURRENT)
		cmpi.b	#OFFSET_BEGINNING,d3
		bne.b		4$


;		beq.b		1$
;		cmpi.b	#OFFSET_END,d3
;		bne.b		4$
;
;	;OFFSET_END
;5$		movem.l	d0/d2-d3,-(a7)
;		move.l	(ff_DosFile,a2),d1
;		moveq		#0,d2
;		moveq		#OFFSET_END,d3
;		CALLDOS	Seek
;		move.l	d0,d2					;Restore back to current position
;		move.l	(ff_DosFile,a2),d1
;		moveq		#OFFSET_BEGINNING,d3
;		CALL		Seek
;		move.l	d0,d1					;This is the position for end of file
;		movem.l	(a7)+,d0/d2-d3
;		add.l		d2,d1					;Add offset
;		bra.b		4$

	;OFFSET_BEGINNING
1$		move.l	d2,d1					;New pos (if OFFSET_BEGINNING)

	;d1 = new position
	;d0 = old position
4$		move.l	d0,d2					;Old pos
		move.l	(ff_Pos,a2),d0
		cmp.l		d0,d1
		bge.b		2$
		sub.l		(ff_BufSize,a2),d0
		cmp.l		d0,d1
		blt.b		2$

	;New pos is in buffer
		sub.l		d0,d1
		move.l	d1,(ff_BufPos,a2)

3$		movem.l	(a7)+,d1/a2
		move.l	d2,d0
		rts

	;Not in buffer
2$		movem.l	d1-d2,-(a7)
		move.l	d1,d2
		move.l	(ff_DosFile,a2),d1
		moveq		#OFFSET_BEGINNING,d3
		CALLDOS	Seek
		movem.l	(a7)+,d1-d2
		move.l	d1,(ff_Pos,a2)
		clr.l		(ff_BufPos,a2)
		clr.l		(ff_BufSize,a2)
		bra.b		3$

	;***
	;Read a line from a buffered file (1.3 version)
	;d1 = file descriptor
	;d2 = address
	;d3 = max length
	;-> linelength+1 in d0
	;	d0 = 0 if eof (flags), d0 = -1 if error
	;-> d1 = file descriptor
	;***
FReadLine:
		DEBUGPC	"FReL"
		movem.l	d1/d4/a2,-(a7)
		moveq		#1,d4
		movea.l	d2,a2
		subq.l	#2,d3

LoopFRE:
		bsr		FReadChar
		bge.b		1$

	;There is something special
		addq.l	#1,d0					;-1 ?
		beq.b		EofFRE
		addq.l	#1,d0					;-2 ?
		SERReq	ReadFile,ErrorFRL
	;It is not possible to come here!

	;Normal operation
1$		cmpi.b	#10,d0
		beq.b		ReturnFRE
		cmpi.b	#13,d0
		beq.b		ReturnFRE
		move.b	d0,(a2)+
		addq.l	#1,d4
		dbra		d3,LoopFRE

ReturnFRE:
		clr.b		(a2)
		move.l	d4,d0
		movem.l	(a7)+,d1/d4/a2
		rts
EofFRE:
		movem.l	(a7)+,d1/d4/a2		;d0 = still 0 and flags are still set
		rts
ErrorFRL:
		movem.l	(a7)+,d1/d4/a2
		moveq		#-1,d0
		rts

;	ENDC

	;***
	;Print a message on the CLI window (if any)
	;a0 = ptr to string
	;***
PrintCLI:
		move.l	a0,d2
2$		tst.b		(a0)+
		bne.b		2$
		suba.l	d2,a0					;a0 = len+1
		move.l	a0,d3

		move.l	(OutputHandle,pc),d1
		beq.b		1$
		CALLDOS	Write
		rts
	;Probably workbench startup, open window
1$		movem.l	d2-d3,-(a7)
		lea		(pvWindow,pc),a0
		move.l	a0,d1
		moveq		#MODE_NEWFILE-1000,d2
		bsr		OpenDos
		move.l	d0,d1
		movem.l	(a7)+,d2-d3
		move.l	d1,-(a7)
		CALL		Write
		move.l	(a7),d1
		subq.l	#4,a7					;Make buf
		move.l	a7,d2					;Buf
		moveq		#1,d3					;Len
		CALL		Read
		lea		(4,a7),a7
		move.l	(a7)+,d1
		CALL		Close
		rts

	;***
	;Try to lock a file in a subdirectory path
	;a0 = filename
	;a1 = ptr to subdirectory path (pointer to array with pointers to strings)
	;-> d0 = pointer to valid filename if success (or null, flags if not found)
	;			(free this filename with FreeBlock after use)
	;***
SearchPath:
		movem.l	d2-d3/a2-a5,-(a7)

		movea.l	a0,a2					;a2 = ptr to filename
		movea.l	a1,a5					;a5 = ptr to subdirectory path
		move.l	a0,d2

	;Scan until we get to the last ':' or '/'
		suba.l	a1,a1
8$		move.b	(a0)+,d0
		beq.b		9$
		cmp.b		#'/',d0
		beq.b		10$
		cmp.b		#':',d0
		bne.b		8$
10$	movea.l	a0,a1
		bra.b		8$

	;a1 now points to the last ':' or '/', or is equal to NULL if there
	;are no such things in the filename
9$		cmpa.l	#0,a1
		beq.b		11$
	;We are now going to try the filename with the path first before we
	;scan the directory path
		move.l	d2,d1
		movem.l	a1/d2,-(a7)
		moveq		#ACCESS_READ,d2
		CALLDOS	Lock
		movem.l	(a7)+,a1/d2
		move.l	d0,d3					;Remember lock and set flags
		bne.b		12$
	;No success, try the dir path
		move.l	a1,d2
		movea.l	a1,a2
		bra.b		11$
	;Success, allocate enough space to hold the name
12$	movea.l	d2,a0
13$	move.b	(a0)+,d0
		bne.b		13$
		move.l	d2,d0
		sub.l		a0,d0
		neg.l		d0						;Size+1
		bsr		AllocBlockInt
		beq.b		3$						;Error
		movea.l	d0,a0
		movea.l	d2,a1
14$	move.b	(a1)+,(a0)+
		bne.b		14$
		movea.l	d0,a4					;Remember filename
		move.l	d3,d0					;Restore lock
		bra.b		7$						;Success

	;Compute length of filename
11$	movea.l	d2,a0
1$		move.b	(a0)+,d0
		bne.b		1$
		sub.l		a0,d2
		neg.l		d2						;d2 = size of filename+1

	;For each subdirectory path
2$		move.l	(a5)+,d0
		beq.b		3$
		movea.l	d0,a3					;a3 = ptr to path string
		movea.l	a3,a0
	;Compute length of pathname
4$		move.b	(a0)+,d0
		bne.b		4$
		move.l	a3,d3
		sub.l		a0,d3
		neg.l		d3						;d3 = size of path string+1
		move.l	d2,d0
		add.l		d3,d0
		bsr		AllocBlockInt
		beq.b		3$
		movea.l	d0,a0
		movea.l	d0,a4
	;Copy path name and filename to allocated memory
		movea.l	a3,a1
5$		move.b	(a1)+,(a0)+
		bne.b		5$
		subq.l	#1,a0
		movea.l	a2,a1
6$		move.b	(a1)+,(a0)+
		bne.b		6$
	;Lock it
		move.l	a4,d1
		move.l	d2,-(a7)
		moveq		#ACCESS_READ,d2
		CALLDOS	Lock
		move.l	(a7)+,d2
		tst.l		d0
		bne.b		7$
	;Free memory
		movea.l	a4,a0
		bsr		FreeBlock
		bra.b		2$

	;The end, we did not succeed
3$		movem.l	(a7)+,d2-d3/a2-a5
		rts

	;Success !
7$		move.l	d0,d1
		CALLDOS	UnLock
		move.l	a4,d0
		bra.b		3$

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	;***
	;Start of FileBase
	;***
FileBase:

OutputHandle:	dc.l	0				;Outputhandle of current CLI

	;Help file handles
CtrlFile:		dc.l	0
HelpFile:		dc.l	0
ScriptFile:		dc.l	0
LogFile:			dc.l	0

LogLogWin:		dc.l	0				;Logical window where the log file belongs
	;***
	;End of FileBase
	;***

	;Error line
WhyLine:			dc.b	"???????????????????",0

	;File names
 IFND D20
pvCtrlFile:		dc.b	"s:PowerVisor-ctrl",0
pvHelpFile:		dc.b	"s:PowerVisor-help",0
 ENDC
 IFD D20
pvCtrlFile:		dc.b	"PowerVisor-ctrl",0
pvHelpFile:		dc.b	"PowerVisor-help",0
 ENDC
pvWindow:		dc.b	"con:10/10/600/40/Error",0
ErrorHelp:		dc.b	"Online help files not installed !",10,0

	;Help
HelpArg:			dc.b	"help",0

	IFD	DEBUGGING
DebugLongFormat:
					dc.b	"%08lx",10,0
DebugLongNNLFormat:
					dc.b	"%08lx ",0
DebugLong2Format:
					dc.b	"%s : %08lx",10,0
	ENDC

	END
