
DosError:	lib	Dos,IoErr
		cmp.l	#ERROR_NO_FREE_STORE,d0
		bne	CNOC1
		print	<"***Break",13,10,"No free store",13,10>,_stdout
		rts	 
CNOC1:		cmp.l	#ERROR_TASK_TABLE_FULL,d0
		bne	CNOC2
		print	<"***Break",13,10,"Task table full",13,10>,_stdout
		rts	 
CNOC2:		cmp.l	#ERROR_LINE_TOO_LONG,d0
		bne	CNOC3
		print	<"***Break",13,10,"Line too long",13,10>,_stdout
		rts	 
CNOC3:		cmp.l	#ERROR_OBJECT_IN_USE,d0
		bne	CNOC4
		print	<"***Break",13,10,"Object in use",13,10>,_stdout
		rts	 
CNOC4:		cmp.l	#ERROR_OBJECT_NOT_FOUND,d0
		bne	CNOC5
		print	<"***Break",13,10,"File not found",13,10>,_stdout
		print	<"Filename was: ">,_stdout
		lea.l	FRFile(pc),a0
		printa	a0
		print	<13,10>,_stdout
		rts	 
CNOC5:		cmp.l	#ERROR_DISK_NOT_VALIDATED,d0
		bne	CNOC6
		print	<"***Break",13,10,"Disk not validated",13,10>,_stdout
		rts	 
CNOC6:		cmp.l	#ERROR_DEVICE_NOT_MOUNTED,d0
		bne	CNOC7
		print	<"***Break",13,10,"Device not mounted",13,10>,_stdout
		rts	 
CNOC7:		cmp.l	#ERROR_READ_PROTECTED,d0
		bne	CNOC8
		print	<"***Break",13,10,"File is read protected",13,10>,_stdout
		rts	 
CNOC8:		cmp.l	#ERROR_NOT_A_DOS_DISK,d0
		bne	CNOC9
		print	<"***Break",13,10,"Not a dos disk",13,10>,_stdout
		rts	 
CNOC9:		cmp.l	#ERROR_NO_DISK,d0
		bne	CNOC10
		print	<"***Break",13,10,"No disk in drive",13,10>,_stdout
		rts	 
CNOC10:		print	<"***Break",13,10,"Sorry, couldn't open file",13,10>,_stdout
		rts	 
WrongFile:	print	<"***Break",13,10,"Sorry, incorrect file",13,10>,_stdout
		rts	 

FileError:	lib	Dos,IoErr
		cmp.l	#ERROR_NO_FREE_STORE,d0
		bne	FE1
		lea.l	FNoFreeStore(pc),a0
		jmp	FileErrorOut
FE1:		cmp.l	#ERROR_TASK_TABLE_FULL,d0
		bne	FE2
		lea.l	FTaskTableFull(pc),a0
		jmp	FileErrorOut
FE2:		cmp.l	#ERROR_LINE_TOO_LONG,d0
		bne	FE3
		lea.l	FLineTooLong(pc),a0
		jmp	FileErrorOut
FE3:		cmp.l	#ERROR_OBJECT_IN_USE,d0
		bne	FE4
		lea.l	FObjectInUse(pc),a0
		jmp	FileErrorOut
FE4:		cmp.l	#ERROR_OBJECT_NOT_FOUND,d0
		bne	FE5
		lea.l	FFileNotFound(pc),a0
		jmp	FileErrorOut
FE5:		cmp.l	#ERROR_DISK_NOT_VALIDATED,d0
		bne	FE6
		lea.l	FNotValidated(pc),a0
		jmp	FileErrorOut
FE6:		cmp.l	#ERROR_DEVICE_NOT_MOUNTED,d0
		bne	FE7
		lea.l	FNotMounted(pc),a0
		jmp	FileErrorOut
FE7:		cmp.l	#ERROR_READ_PROTECTED,d0
		bne	FE8
		lea.l	FReadProtected(pc),a0
		jmp	FileErrorOut
FE8:		cmp.l	#ERROR_NOT_A_DOS_DISK,d0
		bne	FE9
		lea.l	FNotDOS(pc),a0
		jmp	FileErrorOut
FE9:		cmp.l	#ERROR_NO_DISK,d0
		bne	FE10
		lea.l	FNoDisk(pc),a0
		jmp	FileErrorOut
FE10:		lea.l	FError(pc),a0
		jmp	FileErrorOut
FileErrorOut:	move.l	#$00,a1
		jsr	SimpleRequest
		rts

FNoFreeStore:	dc.b	"ERROR: No free store",0
		ds.l	0
FTaskTableFull:	dc.b	"ERROR: Task table full",0
		ds.l	0
FLineTooLong:	dc.b	"ERROR: Line too long",0
		ds.l	0
FObjectInUse:	dc.b	"File ERROR: Object in use",0
		ds.l	0
FFileNotFound:	dc.b	"File ERROR: File not found",0
		ds.l	0
FNotValidated:	dc.b	"File ERROR: Disk not validated",0
		ds.l	0
FNotMounted:	dc.b	"File ERROR: Device not mounted",0
		ds.l	0
FReadProtected:	dc.b	"File ERROR: File is read protected",0
		ds.l	0
FNotDOS:	dc.b	"File ERROR: Not a dos disk",0
		ds.l	0
FNoDisk:	dc.b	"File ERROR: No disk in drive",0
		ds.l	0
FError:		dc.b	"Sorry, file error!",0
		ds.l	0
FFileExists:	dc.b	"File ERROR: File exists",0
		ds.l	0
AskReplace:	dc.b	"File exists, do you want to overwrite?",0
		ds.l	0

	INCLUDE	"FH0:Language/WF/Questions/QSimpleReq.i"
