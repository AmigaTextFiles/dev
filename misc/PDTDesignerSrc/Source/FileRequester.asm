	opt	c+,d+,l+,o+,i+

; NAME
;	FileRequester - get a filespec from user
;
; SYNOPSIS
;	Result = FileRequester(Screen, Title, Buffer)
;				a0      a1     a2
;
; FUNCTION
;	Puts up a custom file requester so that the user may select the
;	filespec they wish the client program to use for a pending IO command
;
; INPUTS
;	Screen - a pointer to an open intuition screen where the requester is
;		 to appear.  If NULL then the Workbench screen is used.
;	Title  - the title that is to appear on the requester.  If NULL then
;		 the default title is used.
;	Buffer - a pointer to the buffer where the final filespec will be
;		 copied if the user selects OK.  If NULL the requester will
;		 return FAILED.
;
;		The data currently in "Buffer" will be formated into the
;		 draw & file strings as a default.
;
; RESULTS
;	d0 - Will be one of the following:
;		-1 = Requester failed to open.
;		 0 = User selected cancel gadget.
;	    Buffer = User selected okay.  Buffer contains the new filespec.
;
; BUGS
;	Requires _DOSBase, _IntuitionBase and _GfxBase to be defined and
;	exported by the client routine.  This routine might make it's way
;	into a run time library some time and so the library bases could be
;	aquired from there, but until then, *tough* .	:-)
;
*****************************************************************************

	incdir	sys:include/
	include	exec/exec_lib.i
	include	exec/memory.i
	include	graphics/graphics_lib.i
	include	intuition/intuition_lib.i
	include	intuition/intuition.i
	include	libraries/dos_lib.i
	include	libraries/dos.i
	include	libraries/dosextens.i

	xref	_DOSBase,_IntuitionBase,_GfxBase
	xdef	_FileRequester	

FAILED		equ	-1	; Function / requester failed.
CANCEL		equ	0	; User canceled requester.

FILE		equ	0	; Entry types...
VOLUME		equ	1
DIRECTORY	equ	-1	

NUMCHARS	equ	38	; Number of characters in print strings.

;  This is the entry structure member in the list has one...

	STRUCTURE	le,0
	   STRUCT	le_Name,30	; Entry text.
	   WORD		le_Type		; Is this a Volume, dir or file?
	   APTR		le_Next		; Links.
	   LABEL	le_SIZEOF	; Structure size.

_FileRequester:
	movem.l	d2-7/a2-6,-(sp)		; Save clients registers.
	bsr	InitialiseRequester	; Pass inputs directly to setup code.
	move.l	d0,ReturnCode		; Did all go well?
	bmi.s	.Failed			; No, exit back to client
	bsr.s	ObtainLock		; Get a lock on initial directory.
.WhileNoExit:
	tst.w	Exit			; Is user exiting?
	bne.s	.Exit			; Yes, then cleanup and return.
	tst.w	MoreEntries		; Are there more entries in dir?
	beq.s	.WaitUser		; No, then wait for users input.
	bsr	ReadNextEntry		; Else, get next entry in dir.
	bra.s	.Ready
.WaitUser:
	move.l	InputPort,a0
	CALLEXEC	WaitPort	; Just sit here and wait for user.
.Ready:
	move.l	InputPort,a0
	CALLEXEC	GetMsg		; Get message from port.
	tst.l	d0			; Is there a message?
	beq.s	.WhileNoExit		; No, then loop.
	move.l	d0,a1
	move.l	im_IAddress(a1),Item	; Get Address of input item.
	move.l	im_Class(a1),InputClass	; Get type of input.
	move.w	im_Code(a1),InputCode	; And exact details of input.
	CALLEXEC	ReplyMsg	; Then sen message back to intuition.
	bsr	HandleInput		; Deal with users input.
	bra.s	.Ready			; Loop until done.
.Exit:
	bsr	CleanupRequester	; Free all memory, locks etc.
.Failed:
	move.l	ReturnCode,d0		; Recall return value.
	movem.l	(sp)+,d2-7/a2-6		; Restore clients registers.
	rts

ObtainLock:
	bsr	FreeEntryList		; Get rid of old file list.
	lea	SliderGadget,a0		; The gadget.
	move.l	FileWindow,a1		; Our requester's display.
	move.l	#0,a2			; This is not a real requester!
	move.w	#(AUTOKNOB!FREEVERT),d0	; Flags.
	moveq	#0,d1			; HorizPot.
	moveq	#0,d2			; VertPot.
	move.w	#MAXBODY,d3		; HorizBody.
	move.w	#MAXBODY,d4		; VertBody.
	moveq	#1,d5			; NumGads.
	CALLINT		NewModifyProp	; Make the changes.
	bsr	DisplayList		; Clear old files from display.
	move.l	CLock,d1		; Get current lock.
	beq.s	.NoOldLock		; Branch if there is no lock.
	CALLDOS		UnLock		; Else, free the lock.
.NoOldLock:
	move.l	#DrawerString,d1	; Buffer containing path.
	move.l	#ACCESS_READ,d2		; We're just looking.
	CALLDOS		Lock		; Attempt to get new lock.
	move.l	d0,CLock		; Store ptr / result.
	beq.s	.Failed			; Exit if lock was not a success.
	move.l	d0,d1
	move.l	#RequesterBlock,d2	; Our file info block.
	CALLDOS		Examine		; Examine the lock.
	tst.l	d0
	beq.s	.Failed			; Branch if something wrong.
	lea	RequesterBlock,a0
	tst.l	fib_DirEntryType(a0)	; Is lock of correct type?
	bmi.s	.Failed			; No, then display an error.
	move.w	#1,MoreEntries		; Tell main to read the directory.
	bra.s	.Return
.Failed:
	move.w	#0,MoreEntries		; Tell main not to read the dir.
	move.l	RequesterRast,a0
	lea	DirError,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLINT		PrintIText	; Display error message.
	move.l	#0,a0
	CALLINT		DisplayBeep	; And flash the user.
.Return:
	rts

CleanupRequester:
	bsr	FreeEntryList		; Get rid of old file list.
	move.l	CLock,d1		; Get current lock.
	beq.s	.NoLock			; Branch if there is no lock.
	CALLDOS		UnLock		; Else, free the lock.
	move.l	#0,CLock
.NoLock:
	move.l	FileWindow,a0
	CALLINT		CloseWindow	; Close down the display.
	rts

ReadNextEntry:
	move.l	CLock,d1		; Get lock pointer
	move.l	#RequesterBlock,d2	; Our file info block.
	CALLDOS		ExNext		; Examine the next entry.
	tst.l	d0
	beq.s	.LastEntry		; Branch if list complete.
	move.l	#le_SIZEOF,d0
	move.l	#(MEMF_CLEAR!MEMF_PUBLIC),d1
	CALLEXEC	AllocMem	; Allocate a structure for the entry.
	tst.l	d0
	beq.s	.NoMemory		; Display an error of alloc failed.
	move.l	d0,a0			; Get List entry.
	move.l	a0,a2			; And a copy.
	lea	RequesterBlock,a1	; Get dir entry.
	lea	fib_FileName(a1),a3	; And a copy. (+point to filename).
.CopyLoop:
	move.b	(a3)+,(a2)+		; Copy next character into entry.
	bne.s	.CopyLoop		; Until we reach a NULL.
	tst.l	fib_DirEntryType(a1)	; Check entry type.
	bmi.s	.GotType		; Branch if it's a file.
	move.w	#DIRECTORY,le_Type(a0)	; Else install correct type.
.GotType:
	bsr.s	IsIcon			; Is this an .info file?
	tst.l	d0
	bne.s	.Insert			; No, then add it to the list.
	move.l	a0,a1
	move.l	#le_SIZEOF,d0
	CALLEXEC	FreeMem		; Else, free entry structure.
	bra.s	.Return			; And return.
.Insert:
	bsr	InsertEntry		; Add entry to list.
	bra.s	.Return
.NoMemory:
	move.l	RequesterRast,a0
	lea	MemError,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLINT		PrintIText	; Display error message.
	move.l	#0,a0
	CALLINT		DisplayBeep	; And flash the user.
.LastEntry:
	move.w	#0,MoreEntries		; Directory finished.
.Return:
	rts

IsIcon:
	move.l	a2,-(sp)
	subq.l	#1,a2			; Skip NULL.
	moveq	#-1,d0			; Preload "NOT".
	cmpi.b	#"o",-(a2)		; Check for ".info" suffix...
	bne.s	.NotIcon
	cmpi.b	#"f",-(a2)
	bne.s	.NotIcon
	cmpi.b	#"n",-(a2)
	bne.s	.NotIcon
	cmpi.b	#"i",-(a2)
	bne.s	.NotIcon
	cmpi.b	#".",-(a2)
	bne.s	.NotIcon
	moveq	#0,d0
.NotIcon:
	move.l	(sp)+,a2
	rts

HandleInput:
	move.l	RequesterRast,a0
	lea	TitleText,a1
	moveq	#0,d0
	moveq	#0,d1			; This prints out the title, it is
	CALLINT		PrintIText	; not auto centred.
	cmpi.l	#MOUSEMOVE,InputClass	; Is the user sliding the list?
	beq.s	.MoveList		; Yes, then deal with it.
	cmpi.l	#MOUSEBUTTONS,InputClass  ; Is the user pressing buttons?
	beq.s	.CheckButtons		; Yes, then see which one.
	andi.l	#(GADGETUP!GADGETDOWN),InputClass   ; Was it a gadget?
	beq.s	.Return				    ; No, then return.
	move.l	Item,a0			; Get gadget address.
	move.w	gg_GadgetID(a0),d0	; Extract Gadget number.
	mulu.w	#4,d0			; Calculate vector offset.
	lea	InputVectors,a0		; Get vector table.
	move.l	(a0,d0),a0		; Extract routine address.
	jsr	(a0)			; Call routine.
	bra.s	.Return
.MoveList:
	bsr	DisplayList		; Redraw display.
	bra.s	.Return
.CheckButtons:
	cmpi.w	#MENUUP,InputCode	; Are we interested?
	bne.s	.Return			; No.
	bsr	HandleDrives		; Else, list disks available.
.Return:
	rts

InitialiseRequester:
	move.l	a2,UserBuffer		; Store this.
	cmpa.l	#0,a2			; Has user provided us with a buffer?
	beq	.Failed			; No, then we've failed.
	lea	FileNewWindow,a3
	cmpa.l	#0,a0			; Has user got their own screen?
	beq.s	.UseWBench		; No, then we'll use the Workbench.
	move.w	#CUSTOMSCREEN,nw_Type(a3)    ; We're using a custom screen.
	move.l	a0,nw_Screen(a3)	; Install pointer to the screen.
	bra.s	.GotScreen
.UseWBench:
	move.w	#WBENCHSCREEN,nw_Type(a3)    ; We're using workbench screen.
	clr.l	nw_Screen(a3)		; Clear pointer to any screen.
.GotScreen:
	lea	TitleText,a3
	cmpa.l	#0,a1			; Has user got their own title?
	beq.s	.UseDefault		; No, then we'll use the default.
	move.l	a1,it_IText(a3)		; Install pointer to title string.
	bra.s	.GotTitle
.UseDefault:
	move.l	#Default,it_IText(a3)	; Install default title string.
.GotTitle:
	lea	FileNewWindow,a0
	CALLINT		OpenWindow	; Attempt to open the window.
	move.l	d0,FileWindow		; Store result.
	beq	.Failed			; Exit, if window failed.
	move.l	d0,a0
	move.l	wd_RPort(a0),RequesterRast	; Extract RastPort.
	move.l	wd_UserPort(a0),InputPort	; Extract msg port.
	move.l	RequesterRast,a1
	moveq	#1,d0
	CALLGRAF	SetAPen		; Set drawing pen to pen 1.
	move.l	RequesterRast,a1
	moveq	#4,d0
	moveq	#2,d1
	move.w	#635,d2			; New we fill in the whole window,
	move.w	#61,d3			; just leaving a 1 pixel border
	CALLGRAF	RectFill	; around the edge. 
	move.l	RequesterRast,a1
	moveq	#0,d0
	CALLGRAF	SetAPen		; Set drawing pen to pen 0.
	move.l	RequesterRast,a1
	move.w	#323,d0
	move.w	#3,d1			; Now we "Cut Out" a section of the
	move.w	#346,d2			; window in the background colour
	move.w	#60,d3			; this is where the slider gadget,
	CALLGRAF	RectFill	; and the up / down gadgets go.
	move.l	RequesterRast,a0
	lea	FileBox,a1		; Next we draw borders around the
	moveq	#0,d0			; three main sections of screen,
	moveq	#0,d1			; Title area, file selection area,
	CALLINT		DrawBorder	; and the output / gadget area.
	bsr.s	GetDefaults		; Get Initial strings.
	clr.w	Exit			; Make sure de don't suddenly quit!
	move.l	RequesterRast,a0
	lea	TitleText,a1
	moveq	#0,d0
	moveq	#0,d1			; This prints out the title, it is
	CALLINT		PrintIText	; not auto centred.
	lea	File1Gadget,a0
	move.l	FileWindow,a1		; Finally we update all gadgets which
	CALLINT		RefreshGadgets	; draws them into our fancy screen.	
	lea	FileSelGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	CALLINT		ActivateGadget	; Make sure file gadget is active.
	moveq	#0,d0			; Return value = success.
	bra.s	.Return
.Failed:
	moveq	#-1,d0			; Tell main that we've failed.
.Return:
	rts

GetDefaults:
	clr.l	DrawerString		; First we clear the strings...
	clr.l	FileString
	move.l	UserBuffer,a2		; Get pointer to buffer.
	move.l	a2,a1
	moveq	#0,d0			; Character count = 0.
.GetLength:
	tst.b	(a1)+			; Test char.
	beq.s	.GotEnd			; Exit loop when NULL found.
	addq.w	#1,d0
	bra.s	.GetLength		; Loop until done...
.GotEnd:
	subq.w	#1,d0
	tst.b	-(a1)			; Move back a byte.
	cmpa.l	UserBuffer,a1		; Is there a drawer spec?
	ble.s	.GotDrawerEnd		; No, then don't search anymore.
	cmpi.b	#"/",(a1)		; Else find end of drawer spec...
	beq.s	.GotDrawerEnd
	cmpi.b	#":",(a1)
	bne.s	.GotEnd
	addq.w	#1,d0
.GotDrawerEnd:
	tst.w	d0
	bmi.s	.JustFile		; Don't do drawer if there isn't one.
	lea	DrawerString,a0
.DrawerLoop:
	move.b	(a2)+,(a0)+		; Copy drawer string...
	dbra	d0,.DrawerLoop
	move.b	#0,(a0)+
	addq.l	#1,a1			; Adjust file pointer.
.JustFile:
	lea	FileString,a0
.FileLoop:
	move.b	(a1)+,(a0)+		; Copy file string...
	bne.s	.FileLoop
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	moveq	#2,d0
	CALLINT		RefreshGadgets	; Update info in gadgets.
	lea	DrawerInfo,a0
	move.w	si_NumChars(a0),si_BufferPos(a0)  ; Justify text properly.
	lea	FileSelInfo,a0
	move.w	si_NumChars(a0),si_BufferPos(a0)  ; Justify text properly.
	rts

FreeEntryList:
	tst.l	FirstEntry		; Are there any entries?
	beq.s	.Return			; No, then exit.
	move.l	FirstEntry,a1
	move.l	le_Next(a1),FirstEntry	; Unlink this entry.
	move.l	#le_SIZEOF,d0
	CALLEXEC	FreeMem		; Free this entry.
	bra.s	FreeEntryList		; Loop...
.Return:
	clr.w	Count			; There are no entries.
	rts

DisplayList:
	bsr	GetPosition		; Find top entry.
	move.l	d0,a2
	lea	File1Text,a3		; Get ptr to 1st text structure.
	moveq	#6,d7			; Set up loop for all 7 texts.
.MakeLoop:
	move.l	a2,a0
	move.l	a3,a1
	bsr	CreateEntryText		; Create text string for printing.
	move.l	it_NextText(a3),a3	; Get next text structure.
	cmpa.l	#0,a2
	beq.s	.Blank			; Branch if this is a NULL entry.
	move.l	le_Next(a2),a2		; Else, get a ptr to the next entry.
.Blank:
	dbra	d7,.MakeLoop		; Loop until all 7 strings are ready.
	move.l	RequesterRast,a0
	lea	File1Text,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLINT		PrintIText	; Print out file strings.
	rts

CorrectSlider:
	movem.l	d2-7/a2-6,-(sp)
	move.l	#MAXBODY,d4
	move.w	Count,d0
	cmpi.w	#7,d0			; If there are <=7 entries,
	ble.s	.GotBody		; use maximum knob size.
	divu.w	d0,d4			; Else, caclulate actual size...
	mulu.w	#7,d4
.GotBody:
	move.w	#0,d2			; Set up default in case of fail.
	subq.w	#7,d0
	ble.s	.GotPot
	move.l	#MAXPOT,d2
	divu.w	d0,d2
	mulu.w	TopEntryNumber,d2
.GotPot:
	lea	SliderGadget,a0		; Fill in remaining inputs...
	move.l	FileWindow,a1
	move.l	#0,a2
	move.w	#(AUTOKNOB!FREEVERT),d0
	move.w	#0,d1
	move.w	#MAXBODY,d3
	moveq	#1,d5
	CALLINT		NewModifyProp	; Update the gadget.
	movem.l	(sp)+,d2-7/a2-6
	rts

GetPosition:
	moveq	#0,d0
	move.w	Count,d1
	subq.w	#7,d1			; If there are <=7 entries,
	ble.s	.GotPos			; use lowest position possible.
	move.l	#MAXPOT,d0		; Else, calculate actual position...
	exg.l	d0,d1
	divu.w	d0,d1			
	lea	FileSlideInfo,a0
	moveq	#0,d0
	move.w	pi_VertPot(a0),d0
	divu.w	d1,d0			; d0 = ( VertPot / d1 )
	move.l	d0,d1
	swap	d1
	tst.w	d1
	beq.s	.GotPos
	addq.w	#1,d0
.GotPos:
	move.w	d0,TopEntryNumber	; Store top entry number.
	move.l	FirstEntry,a0		; Get 1st entry in list.
	subq.w	#1,d0			; Are we already there?
	bmi.s	.GotEntry		; Yes, then exit.
.Loop:
	cmpa.l	#0,a0			; Was this the las entry?
	beq.s	.GotEntry		; Yes, then exit.
	move.l	le_Next(a0),a0		; Else, move onto the next entry.
	dbra	d0,.Loop		; and loop...
.GotEntry:
	move.l	a0,TopEntry		; Store the result in here.
	move.l	a0,d0			; And return it to our caller.
	rts

CreateEntryText:		; source entry = a0.  Dest. IText = a1.
	movem.l	d2-7/a2-6,-(sp)
	move.l	a0,a2			; Make a copy of this.
	move.l	it_IText(a1),a1		; Get destination string.
	move.w	#NUMCHARS-1,d2		; Get number of characters in string.
	cmpa.l	#0,a0
	beq.s	.BlankIt		; Blank out string if no source.
.MakeLoop:
	tst.b	(a0)			; Test next character
	beq.s	.BlankRest		; Blank rest of string if it's NULL.
	move.b	(a0)+,(a1)+		; Else copy next character over.
	dbra	d2,.MakeLoop		; Loop...
	bra.s	.CheckType		; Now see if its a dir or a file.
.BlankRest:
	move.b	#" ",(a1)+		; Copy a space into next character.
	dbra	d2,.BlankRest		; Loop for rest of string...
.CheckType:
	cmpi.w	#DIRECTORY,le_Type(a2)	; Is this entry a directory?
	bne.s	.Return			; No, then were done.
	move.b	#"r",-(a1)		; place " Dir" at end of string...
	move.b	#"i",-(a1)
	move.b	#"D",-(a1)
	move.b	#" ",-(a1)
	bra.s	.Return
.BlankIt:
	move.b	#" ",(a1)+		; Copy a space into next character.
	dbra	d2,.BlankRest		; Loop for rest of string...
.Return:
	movem.l	(sp)+,d2-7/a2-6
	rts

HandleDrives:
	bsr	FreeEntryList		; Free old list.
	bsr	DisplayList		; Clear display.
	move.l	_DOSBase,a2
	move.l	dl_Root(a2),a2		; Get Root Node
	move.l	rn_Info(a2),d0		; Get BPTR to info.
	lsl.l	#2,d0			; Convert to address.
	move.l	d0,a2
	move.l	di_DevInfo(a2),d0	; Get BPTR to device list.
.DriveLoop:
	tst.l	d0			; Is BPTR to device NULL?
	beq.s	.Return			; Yes, then we're done.
	lsl.l	#2,d0
	move.l	d0,a2			; Else, convert BPTR.
	cmpi.l	#DLT_VOLUME,dl_Type(a2)	; Is this a volume?
	bne.s	.Next			; No, then skip to the next one.
	move.l	#le_SIZEOF,d0
	move.l	#(MEMF_CLEAR!MEMF_PUBLIC),d1
	CALLEXEC	AllocMem	; Allocate a structure for the entry.
	tst.l	d0
	beq.s	.NoMemory		; Display an error of alloc failed.
	move.l	d0,a0			; Get List entry.
	move.w	#VOLUME,le_Type(a0)	; Install correct entry type.
	move.l	a0,-(sp)
	move.l	dl_Name(a2),d0
	lsl.l	#2,d0
	move.l	d0,a1			; Extract BSTR to name.
	moveq	#0,d0
	move.b	(a1)+,d0		; Extract length of string.
	subq.w	#1,d0			; Adjustment for dbra.
.NameLoop:
	move.b	(a1)+,(a0)+		; Copy character into entry
	dbra	d0,.NameLoop		; Loop...
	move.b	#":",(a0)+		; This is a volume name.
	move.b	#0,(a0)+		; And needs to be NULL terminated.
	move.l	(sp)+,a0
	bsr	InsertEntry		; Add entry to list.
.Next:
	move.l	dl_Next(a2),d0		; Get pointer to next.
	bra.s	.DriveLoop		; And loop...
.NoMemory:
	move.l	RequesterRast,a0
	lea	MemError,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLINT		PrintIText	; Display error message.
	move.l	#0,a0
	CALLINT		DisplayBeep	; And flash the user.
.Return:
	clr.w	MoreEntries		; Tell main not to read anything.
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	moveq	#1,d0
	CALLINT		RefreshGList	; Refresh drawer gadget.
	lea	DrawerInfo,a0		; Put cursor at end of text...
	move.w	si_NumChars(a0),si_BufferPos(a0)
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	CALLINT		ActivateGadget	; Make sure drawer gadget is active.
	rts

HandleOkay:
	move.l	UserBuffer,a2		; Get users buffer.
	move.l	a2,ReturnCode		; Setup return code.
	lea	DrawerString,a1		; Get path name.
.PathLoop:
	move.b	(a1)+,(a2)+		; Copy next character.
	bne.s	.PathLoop		; Loop until done...
	subq.l	#1,a2			; Adjust pointer.
	cmpa.l	UserBuffer,a2		; Are we at the start (ie CDir)?
	beq.s	.CopyFile		; Yes, then don't check for : or /.
	cmpi.b	#":",-1(a2)		; Else, is there a ":" at the end?
	beq.s	.CopyFile		; Yes, the copy filename.
	cmpi.b	#"/",-1(a2)		; Is there a "/" at the end?
	beq.s	.CopyFile		; Yes, the copy filename.
	move.b	#"/",(a2)+		; else, add a "/".
.CopyFile:
	lea	FileString,a1		; Get filename.
.FileLoop:
	move.b	(a1)+,(a2)+		; Copy next character.
	bne.s	.FileLoop		; Loop until done...
	move.w	#1,Exit			; Set exiting flag.
	rts

HandleCancel:
	clr.l	ReturnCode		; Setup return code.
	move.w	#1,Exit			; Set exiting flag.
	rts

HandleParent:
	bsr	FindEnd			; Get end of drawer string.
	move.l	d0,a0
.ParentLoop:
	subq.l	#1,a0			; Move back 1 character.
	cmpa.l	#DrawerString,a0	; Are we at the start?
	ble.s	.GotParent		; Yes, then branch.
	cmpi.b	#"/",-1(a0)		; Is left character end of drawer?
	beq.s	.GotParent		; Yes, then branch.
	cmpi.b	#":",-1(a0)		; Is left character end of volume?
	bne.s	.ParentLoop		; No, then loop...
.GotParent:
	move.b	#0,(a0)			; End the string here.
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	moveq	#1,d0
	CALLINT		RefreshGList	; Refresh drawer gadget.
	lea	DrawerInfo,a0		; Put cursor at end of text...
	move.w	si_NumChars(a0),si_BufferPos(a0)
	bsr	ObtainLock		; Read new directory.
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	CALLINT		ActivateGadget	; Make sure drawer gadget is active.
	rts

HandleItem:
	move.l	TopEntry,a2		; Get entry in top of display.
	move.l	Item,a0
	move.w	gg_GadgetID(a0),d0	; Get gadget number.
	subq.w	#1,d0
	bmi.s	.GotEntry		; Branch if we're already there.
.SearchLoop:
	cmpa.l	#0,a2			; Check entry.
	beq	.Return			; Exit if it's empty.
	move.l	le_Next(a2),a2		; Point to next entry.
	dbra	d0,.SearchLoop		; Search for entry...
.GotEntry:
	cmpa.l	#0,a2			; Is it NULL?
	beq	.Return			; Yes, exit.
	cmpi.w	#FILE,le_Type(a2)	; Is it a file?
	beq	.HandleFile		; Yes, then branch.
	cmpi.w	#VOLUME,le_Type(a2)	; Is it a disk?
	beq.s	.HandleDisk		; Yes, then branch.
					; Else, it must be a drawer...
	bsr	FindEnd			; Get end of drawer string.
	move.l	d0,a0
	cmpa.l	#DrawerString,a0	; Are we at the start of the string?
	beq.s	.GotPlace		; Yes, then branch.
	cmpi.b	#":",-1(a0)		; Is there a disk terminator?
	beq.s	.GotPlace		; Yes, then branch.
	cmpi.b	#"/",-1(a0)		; Is there a drawer terminator?
	beq.s	.GotPlace		; Yes, then branch.
	move.b	#"/",(a0)+		; Else, add a terminator.
.GotPlace:
	move.b	(a2)+,(a0)+		; Copy next character.
	bne.s	.GotPlace		; Loop untill done...
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	moveq	#1,d0
	CALLINT		RefreshGList	; Refresh drawer gadget.
	lea	DrawerInfo,a0		; Put cursor at end of text...
	move.w	si_NumChars(a0),si_BufferPos(a0)
	bsr	ObtainLock		; Read new directory.
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	CALLINT		ActivateGadget	; Make sure drawer gadget is active.
	bra.s	.Return
.HandleDisk:
	lea	DrawerString,a0		; Get destination string.
.CopyDir:
	move.b	(a2)+,(a0)+		; Copy next character.
	bne.s	.CopyDir		; Loop untill done...
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	moveq	#1,d0
	CALLINT		RefreshGList	; Refresh drawer gadget.
	lea	DrawerInfo,a0		; Put cursor at end of text...
	move.w	si_NumChars(a0),si_BufferPos(a0)
	bsr	ObtainLock		; Read new directory.
	lea	DrawerGadget,a0
	move.l	FileWindow,a1
	suba.l	a2,a2
	CALLINT		ActivateGadget	; Make sure drawer gadget is active.
	bra.s	.Return
.HandleFile:
	lea	FileString,a0		; Get destination string.
.CopyFile:
	move.b	(a2)+,(a0)+		; Copy next character.
	bne.s	.CopyFile		; Loop untill done...
	lea	FileSelGadget,a0
	move.l	FileWindow,a1
	move.l	#0,a2
	moveq	#1,d0
	CALLINT		RefreshGList	; Refresh file gadget.
.Return:
	rts

ListUp:
	tst.w	TopEntryNumber
	beq.s	.Return			; Can't move up!
	subq.w	#1,TopEntryNumber
	bsr	CorrectSlider		; Update slider & display.
	bsr	DisplayList
.Return:
	rts

ListDown:
	move.w	Count,d0
	subq.w	#7,d0
	ble.s	.Return			; Can't move if <=1 window.
	cmp.w	TopEntryNumber,d0
	ble.s	.Return			; Can't move down!
	addq.w	#1,TopEntryNumber
	bsr	CorrectSlider		; Update slider & display.
	bsr	DisplayList
.Return:
	rts

FindEnd:
	move.l	a2,-(sp)
	lea	DrawerString,a2		; Get start of string.
.Loop:
	tst.b	(a2)+			; Is current char NULL.
	bne.s	.Loop			; No, then find a NULL.
	tst.b	-(a2)			; Must actually be on NULL char.
	move.l	a2,d0			; Setup return value.
	move.l	(sp)+,a2
	rts

CompareEntries:
	movem.l	d2-7/a0-6,-(sp)
	cmpi.w	#DIRECTORY,le_Type(a0)	; Entry 1 a dir?
	bne.s	.CheckE2		; No, then branch.
	cmpi.w	#FILE,le_Type(a1)	; Entry 1 a file?
	bne.s	.Compare		; No, then check strings.
	moveq	#0,d0			; Else, return false.
	bra.s	.Return
.CheckE2:
	cmpi.w	#DIRECTORY,le_Type(a1)	; Entry 2 a dir?
	bne.s	.Compare		; No, then check strings.
	moveq	#1,d0			; Else, return true.
	bra.s	.Return
.Compare:
	bsr.s	CompareStrings		; Check the strings.
.Return:
	movem.l	(sp)+,d2-7/a0-6
	rts

CompareStrings:
	move.b	(a0)+,d2		; Get next char from string 1.
	cmpi.b	#64,d2			; Char1 > 64?
	ble.s	.C1NotCap		; No, then don't convert case.
	cmpi.b	#91,d2			; Char1 < 91?
	bge.s	.C1NotCap		; No, then don't convert case.
	addi.b	#32,d2			; Else, convert to lower case.
.C1NotCap:
	move.b	(a1)+,d3		; Get next char from string 2.
	cmpi.b	#64,d3			; Char2 > 64?
	ble.s	.C2NotCap		; No, then don't convert case.
	cmpi.b	#91,d3			; Char2 < 91?
	bge.s	.C2NotCap		; No, then don't convert case.
	addi.b	#32,d3			; Else, convert to lower case.
.C2NotCap:
	moveq	#1,d0			; Preload true return.
	cmp.b	d2,d3			; Compare chr 1 with chr 2.
	beq.s	.CheckEnd		; If they're = check if we're done.
	bgt.s	.Return			; rts if there the wrong way round.
	moveq	#0,d0			; Else, set false return.
	bra.s	.Return
.CheckEnd:
	tst.b	d2			; Is chr1 null?
	beq.s	.Return			; If so, were done.
	tst.b	d3			; Is chr2 null?
	bne.s	CompareStrings		; If not then loop.
.Return:
	rts

InsertEntry:
	movem.l	d0-7/a0-6,-(sp)
	tst.l	FirstEntry		; Is the list empty?
	beq.s	.PutAtTop		; Yes, insert entry at top.
	move.l	FirstEntry,a1		; Get initial entry to compare.
	move.l	#0,a2			; Setup previous entry.
.Loop:
	cmpa.l	#0,a1			; Is this the end of the list?
	beq.s	.PutAtCurrent		; Yes, then put entry at end.
	bsr	CompareEntries		; Else, compare a0 with a1.
	tst.l	d0
	beq.s	.Next			; Go onto next if wrong place.
	cmpa.l	#0,a2			; Is there a previous?
	bne.s	.PutAtCurrent		; Yes, put entry into middle.
.PutAtTop:
	move.l	FirstEntry,le_Next(a0)	; Put entry at top of list...
	move.l	a0,FirstEntry
	bra.s	.Inserted
.Next:
	move.l	a1,a2			; Move onto next entry...
	move.l	le_Next(a1),a1
	bra.s	.Loop
.PutAtCurrent:
	move.l	a1,le_Next(a0)		; Insert at current position...
	move.l	a0,le_Next(a2)
.Inserted:
	addq.w	#1,Count		; Tell everyone about change.	
	bsr	DisplayList		; Then update the display...
	move.l	#MAXBODY,d4
	move.w	Count,d0
	cmpi.w	#7,d0			; If there are <=7 entries,
	ble.s	.GotBody		; use maximum knob size.
	divu.w	d0,d4			; Else, caclulate actual size...
	mulu.w	#7,d4
.GotBody:
	lea	FileSlideInfo,a0	; Don't move the slider...
	move.w	pi_VertPot(a0),d2
	lea	SliderGadget,a0		; Fill in remaining inputs...
	move.l	FileWindow,a1
	move.l	#0,a2
	move.w	#(AUTOKNOB!FREEVERT),d0
	move.w	#0,d1
	move.w	#MAXBODY,d3
	moveq	#1,d5
	CALLINT		NewModifyProp	; Update the gadget.
	movem.l	(sp)+,d0-7/a0-6
	rts

	section	Structs,data
TopEntryNumber	dc.w	0		; Entry number at top of display.
FirstEntry	dc.l	0		; Linked list of entries.
TopEntry	dc.l	0		; Entry at the top of the diplay.
FileWindow	dc.l	0		; Window ptr.
RequesterRast	dc.l	0		; Rast port ptr.
InputPort	dc.l	0		; User port ptr.
InputClass	dc.l	0		; Class of current input.
Item		dc.l	0		; IAddress of current input.
CLock		dc.l	0		; Ptr to current lock.
UserBuffer	dc.l	0		; Destination for filespec.
ReturnCode	dc.l	0		; Code to return to our client.
InputCode	dc.w	0		; Code of current input.
Count		dc.w	0		; Number of entries in list.
MoreEntries	dc.w	0		; Flag, if directory read.
Exit		dc.w	0		; Flag, if user is exiting.


;   This table contains the addresses of the gadget handler routines...

InputVectors:
	dc.l	HandleItem,HandleItem,HandleItem,HandleItem,HandleItem
	dc.l	HandleItem,HandleItem,DisplayList,ListUp,ListDown
	dc.l	ObtainLock,HandleOkay,HandleOkay,HandleDrives,HandleParent
	dc.l	HandleCancel

;   This is the FileInfoBlock used by the directory reader...

	cnop	0,4	; Must be long word aligned.
RequesterBlock:
	ds.b	fib_SIZEOF

;  This is the NewWindow structure, it requires a screen to be opened 640
; wide, and at least 64 high.  The default font is used, so this has to be
; Topaz8, ie Set text to 80 via preferences.

FileNewWindow:
	dc.w	0,0,640,64
	dc.b	-1,-1
	dc.l	(GADGETDOWN!GADGETUP!MOUSEMOVE!MOUSEBUTTONS)
	dc.l	(SMART_REFRESH!NOCAREREFRESH!RMBTRAP!ACTIVATE)
	dc.l	File1Gadget,0,0,0,0,0,0
	dc.w	WBENCHSCREEN

;   These are the gadget structures for the file selection window, there are
; seven of them because the selection window is 7 character lines high...

File1Gadget:
	dc.l	File2Gadget
	dc.w	11,4,306,8,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	0,0,0
File2Gadget:
	dc.l	File3Gadget
	dc.w	11,12,306,8,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	1,0,0
File3Gadget:
	dc.l	File4Gadget
	dc.w	11,20,306,8,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	2,0,0
File4Gadget:
	dc.l	File5Gadget
	dc.w	11,28,306,8,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	3,0,0
File5Gadget:
	dc.l	File6Gadget
	dc.w	11,36,306,8,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	4,0,0
File6Gadget:
	dc.l	File7Gadget
	dc.w	11,44,306,8,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	5,0,0
File7Gadget:
	dc.l	SliderGadget
	dc.w	11,52,306,8,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	6,0,0

;   These 7 lots of data hold the text for the items currently in the
; selection window.

File1String	ds.w	20
File2String	ds.w	20
File3String	ds.w	20
File4String	ds.w	20
File5String	ds.w	20
File6String	ds.w	20
File7String	ds.w	20

;   These are the IText structures for the above 7 data items...

File1Text:
	dc.b	0,1,RP_JAM2
	dc.w	11,4
	dc.l	0,File1String,File2Text
File2Text:
	dc.b	0,1,RP_JAM2
	dc.w	11,12
	dc.l	0,File2String,File3Text
File3Text:
	dc.b	0,1,RP_JAM2
	dc.w	11,20
	dc.l	0,File3String,File4Text
File4Text:
	dc.b	0,1,RP_JAM2
	dc.w	11,28
	dc.l	0,File4String,File5Text
File5Text:
	dc.b	0,1,RP_JAM2
	dc.w	11,36
	dc.l	0,File5String,File6Text
File6Text:
	dc.b	0,1,RP_JAM2
	dc.w	11,44
	dc.l	0,File6String,File7Text
File7Text:
	dc.b	0,1,RP_JAM2
	dc.w	11,52
	dc.l	0,File7String,0

;   These three FilexBox structures are for splitting the window into its
; output sections, Title, File selection, Gadgets / selection output.

FileBox:
	dc.w	9,3
	dc.b	0,1,RP_JAM1
	dc.b	5
	dc.l	FileBoxData,FileBox2
FileBoxData:
	dc.w	0,0,309,0,309,57,0,57,0,0
FileBox2:
	dc.w	351,3
	dc.b	0,1,RP_JAM1
	dc.b	5
	dc.l	FileBox2Data,FileBox3
FileBox2Data:
	dc.w	0,0,280,0,280,12,0,12,0,0
FileBox3:
	dc.w	351,17
	dc.b	0,1,RP_JAM1
	dc.b	5
	dc.l	FileBox3Data,0
FileBox3Data:
	dc.w	0,0,280,0,280,43,0,43,0,0

;   This is the text structure for the title, a default title is supplied
; if you do not supply one of your own.

TitleText:
	dc.b	0,1,RP_JAM2
	dc.w	355,6
	dc.l	0
	dc.l	Default,0
Default:
	dc.b	"        File Requester V2.1      ",0
	even

;   This is the text printed if there is an error...

MemError:
	dc.b	0,1,RP_JAM2
	dc.w	355,6
	dc.l	0,NoMemString,0
NoMemString:
	dc.b	"           Out Of Memory        ",0
	even
DirError:
	dc.b	0,1,RP_JAM2
	dc.w	355,6
	dc.l	0,DirErrString,0
DirErrString:
	dc.b	"          Directory Error        ",0
	even

;   This is the slider gadgets stuff...

SliderGadget:
	dc.l	FileUp
	dc.w	325,4,20,36,GADGHCOMP,(RELVERIFY!FOLLOWMOUSE),PROPGADGET
	dc.l	FileSlideImage,0,0,0,FileSlideInfo
	dc.w	7,0,0
FileSlideInfo:
	dc.w	(AUTOKNOB!FREEVERT),0,0,MAXBODY,MAXBODY,0,0,0,0,0,0
FileUp:
	dc.l	FileDown
	dc.w	325,41,20,9,(GADGIMAGE!GADGHCOMP),RELVERIFY,BOOLGADGET
	dc.l	UpImage,0,0,0,0
	dc.w	8,0,0
FileDown:
	dc.l	DrawerGadget
	dc.w	325,51,20,9,(GADGIMAGE!GADGHCOMP),RELVERIFY,BOOLGADGET
	dc.l	DownImage,0,0,0,0
	dc.w	9,0,0

;   Now the rest of the boolean OK, Cancel etc gadgets, plus anything missing
; above!!

DrawerGadget:
	dc.l	FileSelGadget
	dc.w	438,22,190,10,GADGHCOMP,RELVERIFY,STRGADGET
	dc.l	DrawerBorder,0,DrawerText,0,DrawerInfo
	dc.w	10,0,0
DrawerText:
	dc.b	0,1,RP_JAM1
	dc.w	-60,0
	dc.l	0,DTextString,0
DTextString	dc.b	"Drawer",0
	even
DrawerInfo:
	dc.l	DrawerString,UndoString
	dc.w	0,100,0,0,0,0,0,0
	dc.l	0,0,0
DrawerBorder:
	dc.w	-2,-1
	dc.b	2,1,RP_JAM1
	dc.b	5
	dc.l	DrawerData,0
DrawerData:
	dc.w	0,0,187,0,187,9,0,9,0,0
DrawerString:
	dcb.w	50
FileSelGadget:
	dc.l	OKGadget
	dc.w	438,35,190,10,GADGHCOMP,RELVERIFY,STRGADGET
	dc.l	DrawerBorder,0,FileSelText,0,FileSelInfo
	dc.w	11,0,0
OKGadget:
	dc.l	DrivesGadget
	dc.w	357,47,60,10,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	ParentBorder,0,OKGText,0,0
	dc.w	12,0,0
DrivesGadget:
	dc.l	ParentGadget
	dc.w	427,47,60,10,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	ParentBorder,0,DrivesGText,0,0
	dc.w	13,0,0
ParentGadget:
	dc.l	CancelGadget
	dc.w	495,47,60,10,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	ParentBorder,0,ParentGText,0,0
	dc.w	14,0,0
CancelGadget:
	dc.l	0
	dc.w	565,47,60,10,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	ParentBorder,0,CancelGText,0,0
	dc.w	15,0,0
OKGText:
	dc.b	0,1,RP_JAM1
	dc.w	6,2
	dc.l	0,OKTextString,0
OKTextString	dc.b	" Okay ",0
	even
DrivesGText:
	dc.b	0,1,RP_JAM1
	dc.w	6,2
	dc.l	0,DrivesTextString,0
DrivesTextString	dc.b	"Drives",0
	even
ParentGText:
	dc.b	0,1,RP_JAM1
	dc.w	6,2
	dc.l	0,ParentTextString,0
ParentTextString	dc.b	"Parent",0
	even
CancelGText:
	dc.b	0,1,RP_JAM1
	dc.w	6,2
	dc.l	0,CancelTextString,0
CancelTextString	dc.b	"Cancel",0
	even
ParentBorder:
	dc.w	0,0
	dc.b	0,1,RP_JAM1
	dc.b	5
	dc.l	ParentData,0
ParentData:
	dc.w	0,0,60,0,60,10,0,10,0,0
	
FileSelText:
	dc.b	0,1,RP_JAM1
	dc.w	-60,0
	dc.l	0,FTextString,0
FTextString	dc.b	"File",0
	even
FileSelInfo:
	dc.l	FileString,UndoString
	dc.w	0,30,0,0,0,0,0,0
	dc.l	0,0,0
FileString:
	dcb.w	15
UndoString:
	dcb.w	50

UpImage:
	dc.w	0,0,20,9,1
	dc.l	UpData
	dc.b	1,0
	dc.l	0
DownImage:
	dc.w	0,0,20,9,1
	dc.l	DownData
	dc.b	1,0
	dc.l	0
FileSlideImage:
	ds.b	ig_SIZEOF

	section	ChipStuff,data_c
UpData:
	dc.w	%1111111111111111,%1111111111111111
	dc.w	%1111111110011111,%1111111111111111
	dc.w	%1111111000000111,%1111111111111111
	dc.w	%1111100000000001,%1111111111111111
	dc.w	%1110000000000000,%0111111111111111
	dc.w	%1111111100001111,%1111111111111111
	dc.w	%1111111100001111,%1111111111111111
	dc.w	%1111111100001111,%1111111111111111
	dc.w	%1111111111111111,%1111111111111111
DownData:
	dc.w	%1111111111111111,%1111111111111111
	dc.w	%1111111100001111,%1111111111111111
	dc.w	%1111111100001111,%1111111111111111
	dc.w	%1111111100001111,%1111111111111111
	dc.w	%1110000000000000,%0111111111111111
	dc.w	%1111100000000001,%1111111111111111
	dc.w	%1111111000000111,%1111111111111111
	dc.w	%1111111110011111,%1111111111111111
	dc.w	%1111111111111111,%1111111111111111

	end
	
