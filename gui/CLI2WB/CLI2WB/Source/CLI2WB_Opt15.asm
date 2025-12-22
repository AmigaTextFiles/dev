* CLI2WB.asm starts Shell (CLI) commandline from Workbench
* Memory allocations dynamically, see source, memorylenght and memoryaddress
* returns from allocmem is put at stack, very handy, no matters how much
* allocmems is used, it is always freed by the memfreed at the end of the program
* The program needs thus stack, 4096 is plenty enough
* 1.1 bugfix: if started from CLI, wrong returncode, fixed with the follow;
* fini2
*	moveq	#0,d0				;Return code
* speedup: _DOSBase in a5
* Found some little code cleanups. 
* Filesize 40 bytes shorter
* If assembled with full optimizations; filesize becomes 44bytes shorter again
* 1.2: More optimizations: variables stored in middle of the program, it's dirty, but
* the program is more compact; 84+88=172 bytes shorter
* 1.3: Replaces AmigaDOS's "FindToolType" function with own, faster one. (No library calls)
* Disadvantage: The Tooltypes in the icon must match exactly
* as in the Tooltype table. Means, case sensitive !!!
* Filesize 60+84=144 bytes shorter compared with previous version 1.2

	INCDIR	"STORMC:ASM-Include/"

	INCLUDE	LVOs/exec_lib.i
	INCLUDE	exec/memory.i
	INCLUDE	LVOs/intuition_lib.i
	INCLUDE	intuition/intuition.i
	INCLUDE	intuition/gadgetclass.i
	INCLUDE	intuition/icclass.i
	INCLUDE	LVOs/graphics_lib.i
	INCLUDE	graphics/text.i
	INCLUDE graphics/rastport.i
	INCLUDE LVOs/dos_lib.i
	INCLUDE dos/dos.i
	INCLUDE dos/dosextens.i
	INCLUDE dos/dostags.i			;only for SystemTagList, an Execute simular function
	INCLUDE LVOs/workbench_lib.i
	INCLUDE	workbench/workbench.i
	INCLUDE	LVOs/icon_lib.i
	INCLUDE	workbench/startup.i
	INCLUDE	LVOs/gadtools_lib.i
	INCLUDE	libraries/gadtools.i
	INCLUDE	LVOs/asl_lib.i
	INCLUDE	libraries/asl.i



_SYSBase	EQU	4

LIB_VER		EQU	39
TRUE		EQU	-1
FALSE		EQU	0

*Workbench or CLI startup code:

wbmsg	suba.l	a1,a1				;optimize, wbmsg on instruction
	move.l  (_SYSBase).w,a6			;base Exec in a6
	jsr     _LVOFindTask(a6)		;find us
	move.l	d0,a4				;pointer in a4
_IntuitionBase
	tst.l	pr_CLI(a4)
	bne	fini2				;if we were called from CLI: fini2
_IconBase
; we were called from the Workbench

	lea	pr_MsgPort(a4),a0
	jsr	_LVOWaitPort(a6)		;WaitPort(port)(a0) wait for a message
_AslBase
	lea	pr_MsgPort(a4),a0
	jsr	_LVOGetMsg(a6)			;GetMsg(port)(a0) then get it
diskobj
	move.l	d0,wbmsg			;save WBStartup Message for later reply
	move.l	d0,a2				;and in a2

_main

*open libraries:
filereq
	lea	aslname(pc),a1			;"asl.library"
	moveq	#0,d0				;
ReadWINDOWBuf
	jsr	_LVOOpenLibrary(a6)		;
	move.l	d0,_AslBase			;_AslBase
exestack
	beq	fini				;Not open -> fini

	lea	intname(pc),a1			;"intuition.library"
AmigaDOSptr
	moveq	#0,d0				;
	jsr	_LVOOpenLibrary(a6)		;
_TypeTexts
	move.l	d0,_IntuitionBase		;_IntuitionBase

	lea	dosname(pc),a1			;"dos.library"
	moveq	#0,d0				;
	jsr     _LVOOpenLibrary(a6)		;trashed d1 and a0 a1 !
	move.l	d0,a5				;speedup, use a5 as _DOSBase
;	move.l  d0,_DOSBase			;_DOSBase
;	move.l	d0,a6

	lea	iconname(pc),a1			;"icon.library"
	moveq	#0,d0				;
	jsr	_LVOOpenLibrary(a6)		;
	move.l	d0,_IconBase			;_IconBase
	move.l	d0,a6

*Directory where we started from (Current dir):

;	move.l	wbmsg(pc),a2			;pointer WB message
	move.l	sm_ArgList(a2),a0		;pointer for arguments
	
	move.l	(a0),d1				;d1 is Lock
;	beq	fini				;no arguments
;	move.l  _DOSBase(pc),a6
	jsr	_LVOCurrentDir(a5)		;CurrentDir(lock)(d1)
	
*Get Disk-object (.info file):

;	move.l	wbmsg(pc),a2
	move.l	sm_ArgList(a2),a0		;sm_ArgList ,pointer for arguments
	move.l	wa_Name(a0),a0			;wa_Name ,pointer name
;	move.l	_IconBase(pc),a6
	jsr	_LVOGetDiskObjectNew(a6)	;GetDiskObjectNew(name)(a0) (Release 2.0)
	move.l	d0,diskobj			;store in diskobj

*****************************************************************************
*****************WBToolTypes_OwnRoutine**************************************

*Pointer on ToolType-array:

	move.l	d0,a1				;pointer Disk-object structure in a1
	move.l	do_ToolTypes(a1),d0		;pointer on ToolType-array

	lea	_TypeTexts(pc),a1		;1e pointer base Type text (STRPTR *)
	lea	typeNames1(pc),a3

	bra	StoretypeNames

WasEmpty
;	add.l	#4,a1				;_TypeTexts one higher, no zero put in.
	clr.l	(a1)+				;use this to put zero, if it wasn't already zero (always save)

NexttypeNames
	tst.b	(a3)+				;find null-byte, next typeName
	bne	NexttypeNames
	tst.b	(a3)				;double-nullbyte, end all typeNames
	beq	EndtoolTypeArray
StoretypeNames
	move.l	a3,d3				;store this typeName
	move.l	d0,a0				;restore bases toolTypeArray

NexttoolTypeArray

	move.l	(a0)+,a2			;base toolTypeArray
	tst.l	a2				;without "tst.l	a2", "beq" don't works !!!! (Override CCR)
	beq	WasEmpty			;no more bases toolTypeArray
	move.l	d3,a3				;restore typeName 
	
	moveq	#0,d1				;clear d1, everytime needed !
	move.b	(a3)+,d1			;first lenght typeName in d1

Com	cmpm.b	(a2)+,(a3)+			;compare typeNames
	dbne	d1,Com
	bne	NexttoolTypeArray

found						; typeName found
;nicer '=', ' =', '= ' or ' = ' handling

	move.b	(a2)+,d1
	beq	WasEmpty			;is 0 ? ,no more text
	cmp.b	#"=",d1				;search for "="
	bne	IsSpace
	move.b	(a2)+,d1
	beq	WasEmpty			;is 0 ? ,no more text
	cmp.b	#" ",d1				;search for " "
	beq	Put_TypeTexts
	sub.l	#1,a2

Put_TypeTexts			
	move.l	a2,(a1)+			;pointer typeNames's text in _TypeTexts
	bra	NexttypeNames			;proces next typeNames

IsSpace
	cmp.b	#" ",d1				;search for " "
	beq	found				;search next char. ("=" must be found)
	bra	WasEmpty			;no first "=" or space found

EndtoolTypeArray

*****************************************************************************
*****************WBToolTypes_OwnRoutine END**********************************

	moveq	#ASL_FileRequest,d0
	sub.l	a0,a0				; no tags here (could be here too)
	move.l	_AslBase(pc),a6
	jsr	_LVOAllocAslRequest(a6)		;AllocAslRequest(reqType,tagList)(d0/a0)
	move.l	d0,filereq				;filereq

	moveq	#0,d4				;0= no "" around paths

	move.l	#4,d7				;allocmem counter, needed for freemem, normal 4

*****************************************************************************
*now, process the Tooltype field:

	lea   _TypeTexts(pc),a3       ;array bases Type text
*process 1e Tooltype "Rf_title":

	move.l	(a3)+,a2		;get "Rf_title"
	move.l	a2,a0
	
	moveq	#0,d0
Rf_titlelenght
	addq.w	#1,d0			;
	tst.b	(a0)+
	bne	Rf_titlelenght

	move.l	d0,-(a7)		;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1		;memory type public
	move.l	(_SYSBase).w,a6		;
	jsr	_LVOAllocMem(a6)	;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,ReadRf_titleBuf	;start address reserved memory
	beq	closing			;not succesful ? ->closing
	move.l	d0,a0

	move.l	d0,-(a7)		;memory base at stack

Rf_titlecopy
	move.b	(a2)+,(a0)+		;
	bne	Rf_titlecopy		;0 -> search for null-byte
	
*process 2e Tooltype "Rf_button":

	move.l  (a3)+,a2		;get "Rf_button"
	move.l	a2,a0
	
	move.l	#0,d0
Rf_buttonlenght
	addq.w	#1,d0			;
	tst.b	(a0)+
	bne	Rf_buttonlenght
	cmpi.w	#1,d0			;is d0 1 ? Then empty Rf_button -> OK txt for button
	bne	buttonmem
	addq.w	#2,d0			;lenght for "OK" buttontext
	move.l	#OKbuttontxt,a2

buttonmem

	move.l	d0,-(a7)		;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1		;memory type public
;	move.l	(_SYSBase).w,a6		;
	jsr	_LVOAllocMem(a6)	;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,ReadRf_butBuf	;start address reserved memory
	beq	closing			;not succesful ? ->closing
	move.l	d0,a0

	move.l	d0,-(a7)		;memory base at stack

Rf_buttoncopy
	move.b	(a2)+,(a0)+		;
	bne	Rf_buttoncopy		;0 -> search for null-byte

*process 3e Tooltype "Rf_pattern":

	move.l  (a3)+,a2		;get "Rf_pattern"
	move.l	a2,a0

	move.l	#0,d0
Rf_patternlenght
	addq.w	#1,d0			;
	tst.b	(a0)+
	bne	Rf_patternlenght
	cmpi.w	#1,d0			;is d0 1 ? Then empty Rf_pattern -> disable pattern
	bne	patternmem
	move.l	#TAG_DONE,DoPattern	;disable pattern, no pattern string visible in filerequester
	bra	skippattern

patternmem
	move.l	d0,-(a7)		;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1		;memory type public
;	move.l	(_SYSBase).w,a6		;
	jsr	_LVOAllocMem(a6)	;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,ReadRf_patBuf	;start address reserved memory
	beq	closing			;not succesful ? ->closing
	move.l	d0,a0

	move.l	d0,-(a7)		;memory base at stack
	addq.w	#1,d7			;allocmem counter

Rf_patterncopy
	move.b	(a2)+,(a0)+		;
	bne	Rf_patterncopy		;0 -> search for null-byte
skippattern

*process 4e Tooltype "WINDOW":

	move.l	(a3)+,a2		;get "WINDOW"
	move.l	a2,a0
	
	moveq	#0,d0
WINDOWlenght
	addq.w	#1,d0			;
	tst.b	(a0)+
	bne	WINDOWlenght

	move.l	d0,-(a7)		;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1		;memory type public
;	move.l	(_SYSBase).w,a6		;
	jsr	_LVOAllocMem(a6)	;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,ReadWINDOWBuf	;start address reserved memory
	beq	closing			;not succesful ? ->closing
	move.l	d0,a0

	move.l	d0,-(a7)		;memory base at stack

WINDOWcopy
	move.b	(a2)+,(a0)+		;
	bne	WINDOWcopy		;0 -> search for null-byte

*process 5e Tooltype "Homedir":

	move.l  (a3)+,a2		;get "Homedir"
	move.l	a2,a0
	
	move.l	#0,d0
Homedirlenght
	addq.w	#1,d0			;
	tst.b	(a0)+
	bne	Homedirlenght
	cmpi.w	#1,d0			;is d0 1 ? Then empty Homedir -> SYS: as homedir
	bne	homedirmem
	addq.w	#4,d0			;lenght for "SYS:" buttontext
	move.l	#SYSdir,a2

homedirmem
	move.l	d0,-(a7)		;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1		;memory type public
;	move.l	(_SYSBase).w,a6		;
	jsr	_LVOAllocMem(a6)	;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,ReadRf_dirBuf		;start address reserved memory
	beq	closing			;not succesful ? ->closing
	move.l	d0,a0

	move.l	d0,-(a7)		;memory base at stack
	

Homedircopy
	move.b	(a2)+,(a0)+		;
	bne	Homedircopy		;0 -> search for null-byte

*process 6e Tooltype "Rf_MULTISELECT":

	move.l  (a3)+,a0			;get "Rf_MULTISELECT"
	move.b	(a0)+,d0
	beq	RF_Overwrite			;NULL, no multi select desired-> RF_Overwrite
	cmp.b	#"Y",d0				;search for "Y"
	beq	SearchE
	cmp.b	#"y",d0				;search for "y"
	bne	RF_Overwrite
SearchE
	move.b	(a0)+,d0
	beq	RF_Overwrite			;NULL, no multi select desired-> RF_Overwrite
	cmp.b	#"E",d0				;search for "E"
	beq	SearchS
	cmp.b	#"e",d0				;search for "e"
	bne	RF_Overwrite
SearchS
	move.b	(a0)+,d0
	beq	RF_Overwrite			;NULL, no multi select desired-> RF_Overwrite
	cmp.b	#"S",d0				;search for "S"
	beq	FoundYES
	cmp.b	#"s",d0				;search for "s"
	bne	RF_Overwrite
FoundYES

	move.l	#TRUE,ReadRf_mulBuf		;otherwise, set MULTISELECT for Rf requester


*process 7e Tooltype "RF_OverwriteWarning":
RF_Overwrite

	move.l  (a3)+,a0			;get "RF_OverwriteWarning"
	move.b	(a0)+,d0
	beq	CareSpaces			;NULL, no OverwriteWarning desired-> CareSpaces
	cmp.b	#"Y",d0				;search for "Y"
	beq	RFSearchE
	cmp.b	#"y",d0				;search for "y"
	bne	CareSpaces
RFSearchE
	move.b	(a0)+,d0
	beq	CareSpaces			;NULL, no OverwriteWarning desired-> CareSpaces
	cmp.b	#"E",d0				;search for "E"
	beq	RFSearchS
	cmp.b	#"e",d0				;search for "e"
	bne	CareSpaces
RFSearchS
	move.b	(a0)+,d0
	beq	CareSpaces			;NULL, no OverwriteWarning desired-> CareSpaces
	cmp.b	#"S",d0				;search for "S"
	beq	RFFoundYES
	cmp.b	#"s",d0				;search for "s"
	bne	CareSpaces
RFFoundYES

	move.l	#TRUE,OverwriteWarn		;otherwise, set OverwriteWarning for RF requester

*process 8e Tooltype "TakeCareSpaces":
CareSpaces
	move.l  (a3)+,a0			;get "TakeCareSpaces"
	move.b	(a0)+,d0
	beq	CloseOn				;NULL, no TakeCareSpaces desired-> CloseOn
	cmp.b	#"Y",d0				;search for "Y"
	beq	SpacesSearchE
	cmp.b	#"y",d0				;search for "y"
	bne	CloseOn
SpacesSearchE
	move.b	(a0)+,d0
	beq	CloseOn				;NULL, no TakeCareSpaces desired-> CloseOn
	cmp.b	#"E",d0				;search for "E"
	beq	SpacesSearchS
	cmp.b	#"e",d0				;search for "e"
	bne	CloseOn
SpacesSearchS
	move.b	(a0)+,d0
	beq	CloseOn				;NULL, no TakeCareSpaces desired-> CloseOn
	cmp.b	#"S",d0				;search for "S"
	beq	SpacesFoundYES
	cmp.b	#"s",d0				;search for "s"
	bne	CloseOn
SpacesFoundYES

	move.w	#TRUE,d4			;otherwise, set TakeCareSpaces, do "" around path

*process 9e Tooltype "CloseOnExit":
CloseOn
	move.l  (a3)+,a0			;get "CloseOnExit"
	move.b	(a0)+,d0
	beq	STACK				;NULL, no CloseOnExit desired-> STACK
	cmp.b	#"Y",d0				;search for "Y"
	beq	CloseOnSearchE
	cmp.b	#"y",d0				;search for "y"
	bne	STACK
CloseOnSearchE
	move.b	(a0)+,d0
	beq	STACK				;NULL, no CloseOnExit desired-> STACK
	cmp.b	#"E",d0				;search for "E"
	beq	CloseOnSearchS
	cmp.b	#"e",d0				;search for "e"
	bne	STACK
CloseOnSearchS
	move.b	(a0)+,d0
	beq	STACK				;NULL, no CloseOnExit desired-> STACK
	cmp.b	#"S",d0				;search for "S"
	beq	CloseOnFoundYES
	cmp.b	#"s",d0				;search for "s"
	bne	STACK
CloseOnFoundYES

	move.l	#TRUE,Asynch_buf		;otherwise, set CloseOnExit in Asynch_buf

*process 10e Tooltype "STACK":
STACK
	move.l  (a3)+,a0			;get "STACK"

	moveq	#0,d5				;d5 becomes lenght ASCII buffer (can't use d4 !)
STACKlenght
	addq.w	#1,d5				;
	tst.b	(a0)+
	bne	STACKlenght
	subq.w	#1,d5				;don't count null-byte
	beq	Priority			;is 0, empty ASCIIbuf
	sub.l	#1,a0				;correct a0, now set at null-byte

	moveq	#0,d3				;becomes total decimal number
	moveq	#1,d0				;first decimal Power

STACKASCIIloop
	moveq	#0,d1				;d1 clear
	move.b	-(a0),d1			;first ASCII represent digit in d1
	subi.w	#48,d1			
	bmi	Priority			;negative: no number ->Priority
	subi.w	#10,d1
	bpl	Priority			;positive: no number ->Priority
	addi.w	#10,d1				;make number readble by machine code
	mulu.l	d0,d1				;result as .l in d1
	add.l	d1,d3				;adds to total decimal number
	subq.w	#1,d5				;lenght ASCII buffer -1
	beq	Endbuffer			;is 0, then end reached of buffer
;	mulu.l	#10,d0				;d0 *10  ->Optimized with follow 4 lines:
	move.l	d0,d2				;Optimized: mulu.l  #10,d0
	lsl.l	#2,d2				;Optimized: mulu.l  #10,d0
	add.l	d2,d0				;Optimized: mulu.l  #10,d0
	add.l	d0,d0				;Optimized: mulu.l  #10,d0
	bra	STACKASCIIloop			;next digit

Endbuffer

	move.l	d3,Stack_buf			;value in Stack_buf

*process 11e Tooltype "Priority":
Priority
	move.l  (a3)+,a0			;get "Priority"

	moveq	#0,d5				;d5 becomes lenght ASCII buffer (can't use d4 !)
Prioritylenght
	addq.w	#1,d5				;
	tst.b	(a0)+
	bne	Prioritylenght
	subq.w	#1,d5				;don't count null-byte
	beq	AmigaDOS			;is 0, empty ASCIIbuf
	sub.l	#1,a0				;correct a0, now set at null-byte

	moveq	#0,d3				;becomes total decimal number
	moveq	#1,d0				;first decimal Power

PriorityASCIIloop
	moveq	#0,d1				;d1 clear
	move.b	-(a0),d1			;first ASCII represent digit in d1
	cmp.b	#"-",d1				;look for "-"
	beq	Negnumber			;is "-" found ? -> Negnumber (make number negative)
	subi.w	#48,d1			
	bmi	AmigaDOS			;negative: no number ->AmigaDOS
	subi.w	#10,d1
	bpl	AmigaDOS			;positive: no number ->AmigaDOS
	addi.w	#10,d1				;make number readble by machine code
	mulu.l	d0,d1				;result as .l in d1
	add.l	d1,d3				;adds to total decimal number
	subq.w	#1,d5				;lenght ASCII buffer -1
	beq	EndPrioritybuf			;is 0, then end reached of buffer
;	mulu.l	#10,d0				;d0 *10  ->Optimized with follow 4 lines:
	move.l	d0,d2				;Optimized: mulu.l  #10,d0
	lsl.l	#2,d2				;Optimized: mulu.l  #10,d0
	add.l	d2,d0				;Optimized: mulu.l  #10,d0
	add.l	d0,d0				;Optimized: mulu.l  #10,d0
	bra	PriorityASCIIloop		;next digit

Negnumber
	neg.l	d3				;make negative

EndPrioritybuf

	move.l	d3,Priority_buf			;value in Priority_buf

*process 12e Tooltype "AmigaDOS":
AmigaDOS
	move.l	a7,exestack			;start stack for Execute

	move.l  (a3),a4				;get "AmigaDOS"
	move.l	a4,AmigaDOSptr			;and in AmigaDOSptr

	moveq	#0,d6				;d6 is total memory needed for execute string				

	bra	AmigaDOSskip
ASLCancel					;here, if cancel was pressed in ASL requester
	move.l	d0,-(a7)			;zero at stack, as a marker
	move.l	d0,-(a7)			;zero at stack, as a marker
	bra	AmigaDOSskip

AmigaDOSfind

	addq.l	#1,d6
	tst.b	(a4)+
	beq	EndExeBuff			;reached end of Type Text
	
AmigaDOSskip
	move.b	(a4),d0
	cmp.b	#"{",d0				;search for "{"
	bne	AmigaDOSfind
	move.b	1(a4),d0
	cmp.b	#"R",d0				;search for "R"
	bne	AmigaDOSfind
	move.b	2(a4),d0
	cmp.b	#"f",d0				;search for "f"
	beq	AmigaDOSfindRf
	cmp.b	#"F",d0				;search for "F"
	beq	AmigaDOSfindRF
	cmp.b	#"d",d0				;search for "d"
	bne	AmigaDOSfind
	move.b	3(a4),d0
	cmp.b	#"}",d0				;search for "}"
	bne	AmigaDOSfind
	bra	Rd				;to {Rd} routine
AmigaDOSfindRF
	move.b	3(a4),d0
	cmp.b	#"}",d0				;search for "}"
	bne	AmigaDOSfind
	bra	RF				;to {RF} routine
AmigaDOSfindRf
	move.b	3(a4),d0
	cmp.b	#"}",d0				;search for "}"
	bne	AmigaDOSfind
;found {Rf}

	addq.l	#4,a4
;	bra	Rf				;to {Rf} routine

*{Rf} routine (launch ASL filerequester)
Rf

;open load file requester

	move.l	#Rffilereqtags,a1		;

	move.w	firstreq(pc),d0
	bne	nohomedir
	addq.w	#1,d0
	move.w	d0,firstreq
	bra	homedir
nohomedir	
	add.l	#8,a1				;skip ASLFR_InitialDrawer
homedir

	move.l	filereq(pc),a0
;	lea	loadfilereqtags(pc),a1		;filereqtags in a1
	move.l	_AslBase(pc),a6
	jsr	_LVOAslRequest(a6)		;AslRequest(requester,tagList)(a0/a1)
	tst.l	d0				; cancel?
	beq	ASLCancel

	move.l	filereq(pc),a2				;filereq
	move.l	fr_Drawer(a2),a0		; Asl drawername in a0
	move.l	a0,d5				;and d5

	move.l	#0,d2				;d2 becomes lenght drawername
drawerlenght
	addq.w	#1,d2				;count
	tst.b	(a0)+
	bne	drawerlenght

	addq.w	#2,d2				;add 2 for counting "" "space" ("drawer+file")

;	subq.l	#2,a0				;skip null-byte and set on last char.
;	cmp.b	#":",(a0)			;check for char. : ->rootdir (is thus root-dir)
;	beq	rootdir
;	move.l	#opco1,a0			;clear commandline "move.b	d4,(a0)+" at opcode1
;	move.w	#$10C4,(a0)
;	bra	skippy
rootdir
;	move.l	#opco1,a0
;	move.w	#0,(a0)
;;	move.w	#0,d0
;;	move.w	d0,(opco1)
skippy

;d2 holds lenght drawer name (incl. 0-byte)
;d5 holds drawer name
	
	move.l	fr_NumArgs(a2),d1		;(LONG) Number of files selected
	beq	nomulti				;no selected files-> nomulti (otherwise crash!!)
	move.l	d1,d3				;and in d3

	move.l	fr_ArgList(a2),a1		;(APTR) List of files selected
	add.l	#4,a1				;1e name selected file in a1
	move.l	a1,a3				;and in a3
	move.l	(a1),a0
	
	move.l	#0,d0				;d0 becomes lenght drawername*fr_NumArgs
filenamelenght
	addq.w	#1,d0				;count
	tst.b	(a0)+
	bne	filenamelenght

	add.l	#8,a1				;set pointer on next wa_Name (selected file)
	move.l	(a1),a0
	add.l	d2,d0				;add drawername lenght for each filename lenght
	
	subq.l	#1,d1				;fr_NumArgs -1
	bne	filenamelenght

;d0 holds lenght of all selected "drawername+filename"
;d3 holds amount of selected files, d5 holds drawername, a3 holds 1e name selected file
;
;now reserve memory

	addq.l	#1,d0			;count last added nul-byte too
	add.l	d0,d6			;add in d6
	move.l	d0,-(a7)		;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1		;memory type public
	move.l	(_SYSBase).w,a6		;
	jsr	_LVOAllocMem(a6)	;AllocMem(byteSize,requirements)(d0/d1)
	beq	closing			;not succesful ? ->closing

	move.l	d0,-(a7)		;memory base at stack
	add.l	#1,d7

	move.l	d0,a0

norootcopy
	move.l	(a3),a2			;1e selected file

	move.l	d5,a1			;drawername in a1
	tst.b	d4			;!!!
	beq	drawercopy		;!!!
	move.b	#34,(a0)+		; add char. "

drawercopy
	move.b	(a1)+,(a0)+		;
	bne	drawercopy		;0 -> search for null-byte

	subq.l	#2,a0				;skip null-byte and set on last char.
	cmp.b	#":",(a0)+			;check for char. : ->rootdir (is thus root-dir)
	beq	ffilecopy
;	subq.l	#1,a0				;skip null-byte and set on last char.
	move.b	#"/",(a0)+			;add character  /  for correct path
;	cnop	0,4
opco1:
;	dc.w	$10C4
;	ds.w	1				;4E71 is opcode nop
;	cnop	0,4
ffilecopy
	move.b	(a2)+,(a0)+			;then append filename
	bne	ffilecopy			;find null-byte

	subq.l	#1,a0				;skip null-byte and set on last char.
	tst.b	d4			;!!!
	beq	skipchar		;!!! 
	move.b	#34,(a0)+			; add char. "
skipchar
	move.b	#32,(a0)+			; add "space"

	add.l	#8,a3				;set pointer on next wa_Name (selected file)

	subq.l	#1,d3				;fr_NumArgs -1
	bne	norootcopy

	clr.b	-1(a0)				;make null-byte from last "space"

	bra	AmigaDOSskip			;TEST zover als hier



**************nomultiselect ASL requester********************************
nomulti

	move.l	fr_File(a2),a0			; Asl filename in a0
;	tst.b	(a0)				;is 0 ? no filename-> cancel
;	beq	AmigaDOSskip			;no file at all
	move.l	a0,a2				; Asl filename in a2

						;d2 holds already drawerlenght and ""
	addq.w	#1,d2				;add 1 for counting last added nul-byte
frfilelenght
	addq.w	#1,d2				;count
	tst.b	(a0)+
	bne	frfilelenght

	move.l	d2,d0
	add.l	d0,d6				;add in d6
	move.l	d0,-(a7)			;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1			;memory type public
	move.l	(_SYSBase).w,a6			;
	jsr	_LVOAllocMem(a6)		;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,a0

	move.l	d0,-(a7)			;memory base at stack
	add.l	#1,d7

;d5 holds drawername

	move.l	d5,a1				;drawername in a1
	tst.b	d4			;!!!
	beq	frdrawercopy		;!!!
	move.b	#34,(a0)+			; add char. "

frdrawercopy
	move.b	(a1)+,(a0)+			;
	bne	frdrawercopy			;0 -> search for null-byte

	subq.l	#2,a0				;skip null-byte and set on last char.
	cmp.b	#":",(a0)+			;char : ->frfilecopy
	beq	frfilecopy
	move.b	#"/",(a0)+			;add character  /  for correct path 
frfilecopy
	move.b	(a2)+,(a0)+			;then append filename
	bne	frfilecopy			;find null-byte

	subq.l	#1,a0				;set on null-byte
	tst.b	d4			;!!!
	beq	skipchar1		;!!!
	move.b	#34,(a0)+			; add char. "
skipchar1
	move.b	#0,(a0)+			; add null-byte
;	move.w	#$2200,(a0)			;add two char. " and null-byte

	bra	AmigaDOSskip

;-----------------------------------------------------------------

*{RF} routine (launch save ASL filerequester)
RF
	addq.l	#4,a4
RFagain
	move.l	#RFfilereqtags,a1		;

	move.w	firstreq(pc),d0
	bne	noRFhomedir
	addq.w	#1,d0
	move.w	d0,firstreq
	move.l	ReadRf_dirBuf(pc),d0
	move.l	d0,ReadRF_dirBuf		;homedir copied in ReadRF_dirBuf
	bra	RFhomedir
noRFhomedir	
	add.l	#8,a1				;skip ASLFR_InitialDrawer
RFhomedir

	move.l	filereq(pc),a0
;	lea	RFfilereqtags(pc),a1		;filereqtags already in a1
	move.l	_AslBase(pc),a6
	jsr	_LVOAslRequest(a6)		;AslRequest(requester,tagList)(a0/a1)
	tst.l	d0				; cancel?
	beq	ASLCancel

	move.l	filereq(pc),a2				;filereq
	move.l	fr_Drawer(a2),a0		; Asl drawername in a0
	move.l	a0,d5				;in d5 too

	move.l	#0,d2				;d2 becomes lenght RFdrawername and later drawer+file
RFdrawerlenght
	addq.w	#1,d2				;count
	tst.b	(a0)+
	bne	RFdrawerlenght

	addq.w	#1,d2				;add 1 for counting nul-byte ("drawer+file")

	move.l	OverwriteWarn(pc),d0
	beq	nomulti				;if 0, no Overwrite warning requester desired-> nomulti 
	move.l	fr_File(a2),a0			; Asl filename in a0
;	tst.b	(a0)				;is 0 ? no filename-> cancel
;	beq	AmigaDOSskip			;no file at all
	move.l	a0,a2				; Asl filename in a2

						;d2 holds already drawerlenght and ""
	addq.w	#1,d2				;add 1 for counting last added nul-byte
Frfilelenght
	addq.w	#1,d2				;count
	tst.b	(a0)+
	bne	Frfilelenght

	move.l	d2,d0
	move.l	d0,-(a7)			;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1			;memory type public
	move.l	(_SYSBase).w,a6			;
	jsr	_LVOAllocMem(a6)		;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,a0

	move.l	d0,-(a7)			;memory base at stack
	move.l	d0,d1				;and in d1
	tst.b	d4			;!!!
	beq	Frdrawer		;!!!
	move.b	#34,(a0)+			; add char. "
	addq.l	#1,d1				;skip first " char.

;d5 holds drawername
Frdrawer
	move.l	d5,a1				;drawername in a1
;	move.b	#34,(a0)+			; add char. "

Frdrawercopy
	move.b	(a1)+,(a0)+			;
	bne	Frdrawercopy			;0 -> search for null-byte

	subq.l	#2,a0				;skip null-byte and set on last char.
	cmp.b	#":",(a0)+			;char : ->frfilecopy
	beq	Frfilecopy
	move.b	#"/",(a0)+			;add character  /  for correct path 
Frfilecopy
	move.b	(a2)+,(a0)+			;then append filename
	bne	Frfilecopy			;find null-byte

	move.l	a0,d5				;remember end "drawer+file" in d5


;check if file already exist, if exist then "overwrite" requester

						;d1
	moveq	#ACCESS_READ,d2			;mode READ
;	move.l	_DOSBase(pc),a6
	jsr	_LVOLock(a5)			;and lock !
	move.l	d0,d1				;filelock in d1
	beq	save_file			;can not lock ->save_file (don't overwrite existing file)

	jsr	_LVOUnLock(a5)			;UnLock(lock)(d1)

	lea	overwritetext,a1		;bodytext
	lea	loverwritetext,a2
	lea	roverwritetext,a3		;
	sub.l	a0,a0
        moveq	#0,d0
	moveq	#0,d1
	move.l	#180,d2
	moveq	#80,d3
	move.l	_IntuitionBase(pc),a6
        jsr	_LVOAutoRequest(a6)		;AutoRequest(window,body,posText,negText,pFlag,nFlag,width,height)(a0/a1/a2/a3,d0/d1/d2/d3)
	tst.l	d0				;which of the two buttons pressed ?
	bne	save_file			;OK ->save_file

;cancel, freed unnessary allocated memory, and start the RF save requester again
	move.l	(a7)+,a1
	move.l	(a7)+,d0			;
	move.l	(_SYSBase).w,a6
	jsr	_LVOFreeMem(a6)			;FreeMem(memoryBlock,byteSize)(a1,d0)

	bra	RFagain				;Cancel ->RFagain

save_file

	move.l	4(a7),d0			;memory lenght from stack, don't change stack !
	add.l	d0,d6				;add in d6
	add.l	#1,d7				;allocmem counter

	move.l	d5,a0
	subq.l	#1,a0				;set on null-byte
	tst.b	d4			;!!!
	beq	Frskipchar		;!!!
	move.b	#34,(a0)+			; add char. "
Frskipchar
	move.b	#0,(a0)+			; add null-byte
;	move.w	#$2200,(a0)			;add two char. " and null-byte

	bra	AmigaDOSskip

;-----------------------------------------------------------------

*{Rd} routine (launch directory only ASL requester)
Rd

	addq.l	#4,a4

	move.l	#Rdfilereqtags,a1		;

	move.w	firstreq(pc),d0
	bne	noRdhomedir
	addq.w	#1,d0
	move.w	d0,firstreq
	move.l	ReadRf_dirBuf(pc),d0
	move.l	d0,ReadRd_dirBuf		;homedir copied in ReadRd_dirBuf
	bra	Rdhomedir
noRdhomedir	
	add.l	#8,a1				;skip ASLFR_InitialDrawer
Rdhomedir

	move.l	filereq(pc),a0
;	lea	Rdfilereqtags(pc),a1		;filereqtags in a1
	move.l	_AslBase(pc),a6
	jsr	_LVOAslRequest(a6)		;AslRequest(requester,tagList)(a0/a1)
	tst.l	d0				; cancel?
	beq	ASLCancel

	move.l	filereq(pc),a2				;filereq
	move.l	fr_Drawer(a2),a0		; Asl drawername in a0
	move.l	a0,a2				;and in a2 too

	move.l	#0,d0				;d0 becomes lenght Rddrawername
Rddrawerlenght
	addq.w	#1,d0				;count
	tst.b	(a0)+
	bne	Rddrawerlenght

	addq.w	#2,d0				;add 2 for counting "" ("drawer")

	add.l	d0,d6				;add in d6
	move.l	d0,-(a7)			;memory lenght at stack

	move.l	#MEMF_PUBLIC,d1			;memory type public
	move.l	(_SYSBase).w,a6			;
	jsr	_LVOAllocMem(a6)		;AllocMem(byteSize,requirements)(d0/d1)
	move.l	d0,a0

	move.l	d0,-(a7)			;memory base at stack
	add.l	#1,d7
	tst.b	d4			;!!!
	beq	fddrawercopy		;!!!
	move.b	#34,(a0)+			; add char. "

fddrawercopy
	move.b	(a2)+,(a0)+			;
	bne	fddrawercopy			;0 -> search for null-byte

	subq.l	#1,a0				;set on null-byte
	tst.b	d4			;!!!
	beq	Rdskipchar		;!!!
	move.b	#34,(a0)+			; add char. "
Rdskipchar
	move.b	#0,(a0)+			; add null-byte

	bra	AmigaDOSskip

************************************************************************************
*Free DiskObject, close "icon.library", "asl.library" 
EndExeBuff

	

;* Open a console window.

	move.l	ReadWINDOWBuf(pc),d1
	move.l	#MODE_NEWFILE,d2		;TEST, was #MODE_NEWFILE,d2
;	move.l	_DOSBase(pc),a6
	jsr	_LVOOpen(a5)			;Open(name,accessMode)(d1/d2)
;	move.l	d0,_CONBase

 * Make the console window the Current Output. D0 returns a pointer to the
 * old output.

	move.l	d0,d1
;	move.l	_DOSBase(pc),a6
	jsr	_LVOSelectOutput(a5)		;SelectOutput(fh)(d1)

*inputhandle:
	jsr	_LVOInput(a5)
	move.l	d0,inputhandle			;in label inputhandle


 * Get the current output Handler (which is the console window).

	jsr	_LVOOutput(a5)			;Output()()
	move.l	d0,outputhandle

	move.l	d6,d0				;total lenght whole commandline for Execute
;	add.w	#1,d0				;TEST, add 1 for extra "Return" at end
	move.l	d0,-(a7)			;memory lenght at stack

;	move.l	d0,ReadMULTILen			;lenght	
	move.l	#MEMF_PUBLIC,d1			;memory type public
	move.l	(_SYSBase).w,a6			;
	jsr	_LVOAllocMem(a6)		;AllocMem(byteSize,requirements)(d0/d1)
;	move.l	d0,ReadMULTIBuf			;start address reserved memory
	move.l	d0,a0

	move.l	d0,-(a7)			;memory base at stack
	add.l	#1,d7				;allocmem counter

	move.l	AmigaDOSptr(pc),a4

	move.l	exestack(pc),a2

	bra	AmigaDOSskip2

AmigaDOSfind2

	move.b	(a4)+,(a0)+
	beq	EndExeBuff2			;reached end of Type Text
	
AmigaDOSskip2
	move.b	(a4),d0
	cmp.b	#"{",d0				;search for "{"
	bne	AmigaDOSfind2
	move.b	1(a4),d0
	cmp.b	#"R",d0				;search for "R"
	bne	AmigaDOSfind2
	move.b	2(a4),d0
	cmp.b	#"f",d0				;search for "f"
	beq	AmigaDOSfindASL
	cmp.b	#"F",d0				;search for "F"
	beq	AmigaDOSfindASL
	cmp.b	#"d",d0				;search for "d"
	bne	AmigaDOSfind2
AmigaDOSfindASL
	move.b	3(a4),d0
	cmp.b	#"}",d0				;search for "}"
	bne	AmigaDOSfind2
;found {Rf}, {RF} or {Rd}
foundASL
	addq.l	#4,a4				;skip {XX}

	move.l	-(a2),d2 ;d3 ;a1			;memoryBlock
;	subq.l	#4,a2				;skip byteSize  ! buggy !
	move.l	-(a2),a1 ;d2 ;d0			;byteSize
	beq	AmigaDOSskip2			;if 0, no copy, cancel was pressed in this requester

memexecopy
	move.b	(a1)+,(a0)+
	bne	memexecopy
	subq.l	#1,a0				;set on last null-byte
;	move.b	#10,(a0)+			;TEST, add extra "Return" at end commandline
;	clr.b	(a0)				;TEST, terminated with null-byte
	bra	AmigaDOSskip2

	

EndExeBuff2



;TESTbegin for debugging purposes, shows whole buffer.

;	move.l	ReadMULTIBuf(pc),d2
;	move.l	d2,a0

;	move.l	#0,d4				;d4 becomes lenght drawername
buflenght
;	addq.w	#1,d4				;count
;	tst.b	(a0)+
;	bne	buflenght

;	move.l	Priority_buf(pc),d0		;TEST STACK tooltype
;	bsr	output32			;TEST lenght all selected files

;	move.l	outputhandle(pc),d1
;;	move.l	ReadMULTIBuf(pc),d2
;;	move.l	ReadMULTILen(pc),d3
;	move.l	_DOSBase(pc),a6		;
;	jsr	_LVOWrite(a5)

;	bra	closing				;TEST

;TESTend

*Execute CLI AmigaDOS command:

	move.l	(a7),d1
	move.l	#Shelltags,d2
;	move.l  _DOSBase(pc),a6
	jsr	_LVOSystemTagList(a5)		;SystemTagList(command,tags)(d1/d2)

closing

;	move.l	(_SYSBase).w,a6

memfreed					;frees allocated memory

	move.l	(a7)+,a1
	move.l	(a7)+,d0			;
	beq	memfreed

	jsr	_LVOFreeMem(a6)			;FreeMem(memoryBlock,byteSize)(a1,d0) 

	subq.w	#1,d7
	bne	memfreed

endfreemem

	move.l	filereq(pc),a0
	move.l	_AslBase(pc),a6
	jsr	_LVOFreeAslRequest(a6)		;FreeAslRequest(requester)(a0)

	move.l	diskobj(pc),a0
	move.l	_IconBase(pc),a6
	jsr	_LVOFreeDiskObject(a6)		;FreeDiskObject(diskobj)(a0)

	move.l	a6,a1				;_IconBase in a1
	move.l	(_SYSBase).w,a6
        jsr	_LVOCloseLibrary(a6)		;close "icon.library"

	move.l  _AslBase(pc),a1			;_AslBase
;	move.l	(_SYSBase).w,a6
        jsr	_LVOCloseLibrary(a6)

	move.l  _IntuitionBase(pc),a1		;_IntuitionBase
;	move.l	(_SYSBase).w,a6
        jsr	_LVOCloseLibrary(a6)		;close "intuition.library"

	

exit_closedos
	
	move.l	wbmsg(pc),a1			;reply wb message
;	tst.l	(a1)
;	beq	fini				;fini - Task was started from CLI
;	move.l	(_SYSBase).w,a6
	jsr	_LVOReplyMsg(a6)		;fini - Task was started from WB
;	moveq	#0,d0				;Return code
fini
	move.l	a5,a1
;	move.l  _DOSBase(pc),a1			;_DOSBase
;	move.l	(_SYSBase).w,a6
        jsr	_LVOCloseLibrary(a6)		;cleared d0 a0 a1 too !
fini2
	moveq	#0,d0				;Return code
	rts					;End program



;	INCLUDE	Tom/DecOutput32.i


;filerequesters

Rffilereqtags

	dc.l	ASLFR_InitialDrawer
ReadRf_dirBuf	dc.l	0

	dc.l	ASLFR_TitleText		;
ReadRf_titleBuf	dc.l	0
	dc.l	ASLFR_PositiveText	;
ReadRf_butBuf	dc.l	0

	dc.l	ASLFR_DoMultiSelect
ReadRf_mulBuf	dc.l	FALSE
	dc.l	ASLFR_DoSaveMode,FALSE
	dc.l	ASLFR_DrawersOnly,FALSE

DoPattern	dc.l	ASLFR_DoPatterns,TRUE
	dc.l	ASLFR_InitialPattern
ReadRf_patBuf	dc.l	0

	dc.l	ASLFR_InitialFile,0
	dc.l	TAG_DONE

RFfilereqtags

	dc.l	ASLFR_InitialDrawer
ReadRF_dirBuf	dc.l	0

	dc.l	ASLFR_TitleText,RFtitle
	dc.l	ASLFR_PositiveText,OKbuttontxt
	dc.l	ASLFR_DoSaveMode,TRUE
	dc.l	ASLFR_DrawersOnly,FALSE
	dc.l	ASLFR_InitialFile,0
	dc.l	ASLFR_DoPatterns,FALSE
	dc.l	ASLFR_InitialPattern,0
	dc.l	TAG_DONE

Rdfilereqtags

	dc.l	ASLFR_InitialDrawer
ReadRd_dirBuf	dc.l	0

	dc.l	ASLFR_TitleText,Rdtitle
	dc.l	ASLFR_PositiveText,OKbuttontxt
	dc.l	ASLFR_DrawersOnly,TRUE
	dc.l	ASLFR_DoPatterns,FALSE
	dc.l	ASLFR_DoSaveMode,FALSE
	dc.l	TAG_DONE

Shelltags

	dc.l	SYS_Input
inputhandle	dc.l	0
	dc.l	SYS_Output
outputhandle	dc.l	0
	dc.l	SYS_Asynch
Asynch_buf	dc.l	0
	dc.l	NP_StackSize
Stack_buf	dc.l	4096
	dc.l	NP_Priority
Priority_buf	dc.l	0
	dc.l	TAG_DONE


*LONG variables----------------------------------------

;_IntuitionBase	dc.l	0

;_IconBase	dc.l	0

;_AslBase	dc.l	0
;_CONBase	dc.l	0
;outputhandle	dc.l	0
;wndwptr		dc.l	0	;window pointer

;TESTnumber	dc.l	0

;ReadWINDOWBuf	dc.l	0	;CON window properties
;;ReadMULTIBuf	dc.l	0	;holds all selected "drawer+files"
;;ReadMULTILen	dc.l	0	;lenght all selected "drawer+files"

;_TypeTexts	ds.l	12	;amount of typeNames is memory size
;wbmsg		dc.l	0	;WBStartup Message
;diskobj		dc.l	0	;diskobject (the .info structure)
;filereq		dc.l	0	;file requester

;exestack	dc.l	0	;holds first memory alloc. for passing to Execute
;AmigaDOSptr	dc.l	0	;pointer AmigaDOS commandline string from tooltype
OverwriteWarn	dc.l	0	;OverwriteWarning 0=no

overwritetext
	dc.b	3,3,0,0				;long
	dc.w	10,10				;long
	dc.l	0,overwritereqtxt,0		;ofcourse it's long

loverwritetext
	dc.b	3,1,0,0				;long
	dc.w	5,3				;long
	dc.l	0,OKbuttontxt,0			;ofcourse it's long

roverwritetext
	dc.b	0,1,0,0				;long
	dc.w	5,3				;long
	dc.l	0,Cancelbuttontxt,0		;ofcourse it's long



*WORD variables----------------------------------------

firstreq	dc.w	0	;flag for first started requester

* String Variables-------------------------------------



RFtitle		dc.b 'Enter filename',0		;title for RF (save) requester
Rdtitle		dc.b 'Choose directory',0	;title for Rd (directory) requester

overwritereqtxt	dc.b	"The file already exist, overwrite ?",0	;overwrite requester

OKbuttontxt	dc.b	'OK',0			;OK button for requesters
Cancelbuttontxt	dc.b	"Cancel",0		;Cancel button for requesters

SYSdir		dc.b	'SYS:',0		;for default homedir use

***********************************************************************
* Format Tooltype table: Each Tooltype name begins with a lenght byte *
* and ended with null-byte. Subtract 1 from lenght.                   *
* The last Tooltype name in the table ended with double null-byte.    *
***********************************************************************

typeNames1:	dc.b 7,"Rf_title",0
		dc.b 8,"Rf_button",0
		dc.b 9,"Rf_pattern",0
		dc.b 5,"WINDOW",0
		dc.b 6,"Homedir",0
		dc.b 13,"Rf_MULTISELECT",0
		dc.b 18,"RF_OverwriteWarning",0
		dc.b 13,"TakeCareSpaces",0
		dc.b 10,"CloseOnExit",0
		dc.b 4,"STACK",0
		dc.b 7,"Priority",0
		dc.b 7,"AmigaDOS",0,0	;double-nullbyte here, terminates all typeNames

*Library data------------------------------------------

intname		INTNAME				;macro of "intuition.library"
;grafname	GRAFNAME			;macro of "graphics.library"
dosname		DOSNAME				;macro of "dos.library"
;wbname		WORKBENCH_NAME			;macro of "workbench.library"
aslname		AslName				;macro of "asl.library"
iconname	ICONNAME			;macro of "icon.library"

*Version data------------------------------------------

Version dc.b "$VER:CLI2WB 1.5 by Amigaharry 19may04",0