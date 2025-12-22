;*****************************************************************************
;*
;* ListScanner.asm	by HEIKO RATH
;* 
;*			Copyright 1988 by the Software Brewery
;*
;* This program may be non-commercially distributed.
;* 
;* This little program is intented to printout all ExecLists. It will only
;* work from CLI, WB-starting is senseless. To redirect the output to a file
;* use the standart DOS file redirection (ListScanner >filename). The output
;* contains the name of node, the type and the priority. 
;*
;*
;* A note to Leo Schwab: keep on developing display hacks.
;*
;*								Heiko Rath
;*
;*****************************************************************************
;                          
;______  /          
;______\O                    - The Software Brewery - 
;      \\                        
;       o            Sparkling, fresh software from W.-Germany
;                 
;     @@@@@             Straight from the bar to your Amiga
;     |~~~|\        
;     | | |/        
;     |___|        With our regards to the Software Distillery
;
;Members are (listed alphabetically):
;Christian Balzer alias <CB>, Lattice C, user interfaces, beer addict. 
;Christof Bonnkirch alias KEY, Aztec C, Hardware & Devices, beer adict.
;Heiko Rath alias <HR>, Assembler, ROM-Kernal stuff, Marabou addict. 
;Peter Stark alias PS, Lattice C, IO & utilities, WordStar addict.
;Ralf Woitinas alias RAF, Assembler, anything, Ray-Tracing addict.
;Torsten Wronski alias MM, Assembler, anything, girls addict.
;
;Beverages: Altenmuenster Brauer Bier, Urfraenkisches Landbier, Grohe Bock.
;
;Send exotic drinks, beautyful girls, $$$$, comments, critizism, flames to:
;
;The Software Brewery	
;Christian Balzer		
;Im Wingertsberg 45		
;D-6108 Weiterstadt	
;West-Germany		
;
;Our BBS "AmigaNode" isn't online yet. As soon as it becomes available, 
;you'll be the first to know :-).
;
;
;Send the above stuff and of course MARABOU-CHOCOLATE to:
;
;Heiko Rath (AAAARRRRGGGHHH, where is my Marabou chocolate??)
;Raiffeisenstr.10a
;D-6108 Weiterstadt
;Tel.06150-2658
;West-Germany
;
;

ExecBase	Equ	4

;***
;*** Exec Offsets:
;***
OpenLibrary	Equ	-552		;OpenLibrary (LibName,version)(a1,d0)
CloseLibrary	Equ	-414		;CloseLibrary (Library)(a1)
Forbid		Equ	-132		;Forbid ()()
Permit		Equ	-138		;Permit ()()
AllocMem	Equ	-198		;AllocMem (bytesize,requirement)(d0,d1)
FreeMem		Equ	-210		;FreeMem (memoryblock,bytesize)(a1,d0)

;***
;*** DOS Offsets:
;***
OutPut		Equ	-60		;OutPut ()
Write		Equ	-48		;Write (file,buffer,length)(d1,d2,d3)

;***
;*** I use these Macros to make things easier for me
;***

doit:	MACRO
	move.l	#\1.txt,d2		;address of listname to d2
	bsr	TextOutPut		;output listname
	move.l	#HeadLine,d2		;address of HeadLine to d2
	bsr	TextOutPut		;output HeadLine
	move.l	\1,d0			;offset of listhead to d0
	bsr	Showlist		;output list
	ENDM

;***
;*** Here we go:
;***
DosOpen:		;opens DOS-library, saves DOSBasepointer
			;saves stdout
	move.l	ExecBase,a6		;Execaddress to a6 (only to be sure)
	move.l	#DOSNAME,a1		;Librarynamepointer to a1
	moveq	#0,d0			;any version
	jsr	OpenLibrary(a6)		;try to open DOS-Libary
	tst.l	d0			;is d0 = NULL?
	beq	ErrorExit		;exit if call wasn't successfull
	move.l	d0,DOSBase		;save DOSBasepointer
	move.l	d0,a6			;move DOSBasepointer to a6
	jsr	OutPut(a6)		;identify the initial output handle
	move.l	d0,stdout		;save stdout

			;from here we call the PrintOutPut-subroutine to output
			;the listnames and then we call the Showlist-subroutine
start:			;to printout the contents of the lists.  
	move.l	#Text,d2
	bsr	TextOutPut
	doit	memlist			;output Memorylist
	doit	reslist			;output Resourcelist
	doit	devlist			;output Devicelist
	doit	intrlist		;output Interruptlist
	doit	liblist			;output Librarylist
	doit	portlist		;output Portlist
	doit	trdylist		;output Taskreadylist
	doit	twtlist			;output Taskwaitinglist
	doit	smlist			;output Semaphorlist

DosClose:
	move.l	ExecBase,a6		;ExecBase to a6
	move.l	DOSBase,a1		;DOS-pointer to a1
	move.l	ExecBase,a6		;Exec-pointer to a6
	jsr	CloseLibrary(a6)	;close DOS
ErrorExit:
	rts				;CLI here I come again!!!!

;*****************************************************************************
;*
;*	Showlist II					11.1.87
;*			by	Heiko Rath
;*				Raiffeisenstr.10a
;*				D-6108 Weiterstadt
;*				West-Germany
;*				Tel.06150-2658
;*
;* PURPOSE:			print out Exec-Systemlist (address of Node,
;*				type, priority, name of Node)
;*
;* ROUTINETYPE:			subroutine
;*
;* SYNTAX:			bsr Showlist	(Exec-offset to list)(d0)
;*
;* ENTRY CONDITIONS:		needs DOSlibrary opened and stdout defined
;*				also needs DOS-'Write' offset -48 defined.
;*				It also needs binhex subroutine.
;*
;* RETURNS:			none
;*
;* BUGS:			none
;*
;* NOTE:			none
;*
;* CHANGED:			nothing
;*
;* USAGE:			move.l	Listoffset,d0
;*				bsr	Showlist
;*
;*****************************************************************************
Showlist:
	movem.l	d0-d7/a0-a6,-(sp)	;save registers

	move.l	ExecBase,a6		;ExecBase to a6
	jsr	Forbid(a6)		;forbid taskswitching (very important,
					; 'cause we are accessing Systemdata)

	move.l	a6,a0			;Execpointer to a0
	add.l	d0,a0			; + librarylistoffset=address of listhead
	move.l	a0,ListHead		;save address of listheader -=> ListHead
	move.l	(a0),a1			;get address of 1.Node to a1
	move.l	a1,Node			;save address of 1.Node -=> Node
	addq.l	#4,a0
	cmp.l	a1,a0			;list empty?
					;(test if listhead points to listhead+4)
	beq	PrintLF			;yes -=> send LF and exit

	moveq.l	#1,d1			;set counter to 1 'cause there is at least
					; one node in the list
MyCountLoop:
	move.l	(a1),a1			;get address of next node to a1
	tst.l	(a1)			;see if contents of (a1) is NULL
	beq.b	EndCount		;leave counting loop
	addq.l	#1,d1			;increment counter by one
	bra.b	MyCountLoop		;do this once more

EndCount:
	move.l	d1,NodeCount		;save number of Nodes

GetMem:
	move.l	#48,d0			;number of bytes per node
	mulu	d1,d0			;bytes per node * NodeCount
	addq.l	#1,d0			;add one for the bufferterminating Null
	move.l	d0,MyMemoryLength	;save lenght of Memoryblock
	move.l	#$10001,d1		;requirements:MEMF_Public & Clear
	jsr	AllocMem(a6)		;get memory from system
	move.l	d0,MyMemoryBlock	;save address of Memoryblock
	move.l	d0,MyMemoryOffset	;save address of Memoryblock 2.time
	tst.l	d0			;see if call was successfull
	bne	MoveNodeToBuffer	;yes -=> MoveNodeToBuffer

	move.l	#Err,d2			;this code is only here, to inform the
	bsr	TextOutPut		; user that the AllocMem call wasn't
	bra	PrintLF			; successfull

MoveNodeToBuffer:
	move.l	d0,a0			;get address of MemoryBlock to a0
	move.l	MyMemoryLength,d1	;get length to d1

fill:
	move.b	#' ',(a0)+		;fill MyMemoryBlock with spaces
	dbeq.b	d1,fill			;is d1=NULL? (no-=>d1=d1-1-=>fill)

TheLoop:
	move.l	MyMemoryOffset,a0	;get address of MyMemoryOffset to a0
	move.l	Node,a1			;get address of current node to a1

CopyName:
	add.l	#10,a1			;address of namepointer to a1
	move.l	(a1),a1			;get address of nodename to a1
	moveq.l	#0,d1			;this is faster than clr.l d1
	moveq.l	#0,d2			;set this to NULL for strlen

strlen:
	cmp.b	(a1)+,d2		;NULL?
	beq.b	strlentest		;yes -=>strlentest
	addq.l	#1,d1			;increment d1 by one (stringlength)
	bra.b	strlen			;do the loop once more

strlentest:
	cmp.b	#28,d1			;see if string is greater #28
	ble.b	DoCopy			;no (less or equal)-=>DoCopy
	move.l	#28,d1			;set max.length to 28

DoCopy:
	move.l	Node,a1			;get address of node to a1
	add.l	#10,a1			;address of namepointer to a1
	move.l	(a1),a1			;get address of nodename to a1
	tst.l	d1			;see if d1=0
	bne	DoTheCopy		;jump only if d1<>0
	move.l	#NoName,a1		;get address of NoName to a1
	moveq.l	#7,d1			;set length to 7 (length of 'No Name')

DoTheCopy:
	subq.l	#1,d1			;decrement d1 by 1

CopyLoop:
	move.b	0(a1,d1),0(a0,d1)	;copy source to destination
	dbf	d1,CopyLoop		;decrement d1, if d1<0 then out of loop

	move.l	MyMemoryOffset,a0	;get address of MyMemoryOffset to a0
	move.b	#'$',29(a0)		;store '$'
	move.b	#'$',39(a0)		;store '$'
	move.b	#'$',43(a0)		;store '$'
	move.b	#10,47(a0)		;store LF

	move.l	Node,a1			;get Nodeaddress to a1
	addq.l	#8,a1			;add 8 to get address of Type
	moveq.l	#0,d0			;clear d0
	move.w	(a1),d0			;get Type & Priority to d0
	move.l	#Buffer,a0		;get bufferaddress to a0
	bsr	binhex			;convert address to ASCII
	move.w	Buffer+6,d0		;get converted Type & Priority to d0
	move.l	MyMemoryOffset,a0	;get address of MyMemoryOffset to a0
	move.w	d0,44(a0)		;copy Priority to MyMemoryBlock
	move.w	Buffer+4,d0		;get converted Priority to d0
	move.w	d0,40(a0)		;copy Type to MyMemoryBlock

	move.l	Node,d0			;get Nodeaddress to d2
	move.l	MyMemoryOffset,a0	;get address of MyMemoryOffset to a0
	add.l	#30,a0			;add 30 to get storeaddress
	bsr	binhex			;convert address to ASCII

	add.l	#48,MyMemoryOffset	;do this for the next loop
	move.l	Node,a1			;get nodeaddress to a1
	move.l	(a1),Node		;save address of next node
	move.l	MyMemoryOffset,d0	;get MyMemoryOffset to d0
	addq.l	#1,d0
	move.l	MyMemoryBlock,d1	;get MyMemoryBlock to d1
	add.l	MyMemoryLength,d1	;add MyMemoryLength to d1
	cmp.l	d0,d1			;see if we have to loop once more
	bne	TheLoop			;if <> -=> TheLoop
	move.l	MyMemoryBlock,a0	;get address of MyMemoryBlock to a0
	add.l	MyMemoryLength,a0	;add length to MyMemoryBlock
	subq.l	#1,a0			;decrement address by one
	move.b	#0,(a0)			;set last byte of MyMemoryBlock to NULL

	move.l	MyMemoryBlock,d2	;get address of MyMemoryBlock to d2
	bsr	TextOutPut		;print out the complete buffered list
	move.l	MyMemoryBlock,a1	;get address of MyMemoryBlock to a1
	move.l	MyMemoryLength,d0	;get length of MyMemoryBlock to d0
	jsr	FreeMem(a6)		;free the allocated RAM

PrintLF:
	move.l	#LF,d2			;get address of LF-string to d2
	bsr.b	TextOutPut		;and get it out via DOS-Write & stdout
	jsr	Permit(a6)		;permit taskswitching (I think Dos enables
					; this for you, but I do this to be sure
					; that taskswitching is now allowed.)
	movem.l	(sp)+,d0-d7/a0-a6	;restore Registers
	rts

;*****************************************************************************
;*
;*	TextOutPut
;*			by	Heiko Rath
;*				Raiffeisenstr.10a
;*				D-6108 Weiterstadt
;*				West Germany
;*				Tel.06150-2658
;*
;* PURPOSE: 		output a NULL-terminated string via stdout
;*
;* ROUTINE TYPE: 	subroutine
;*
;* SYNTAX:		bsr	TextOutPut	(stringaddress)(d0)
;*
;* ENTRY CONDITIONS:	needs DOSlibrary opened and stdout defined
;*			also needs DOS-'Write' offset -48 defined.
;*
;* RETURNS:		none
;*
;* NOTE:		its better if the string is really NULL-terminated
;*
;* CHANGED:		nothing
;*
;* USAGE:		move.l	#Textaddress,d2
;*			bsr	TextOutPut
;*
;*****************************************************************************

TextOutPut:
	movem.l	d0-d7/a0-a6,-(sp)	;save registers
	move.l	d2,a0			;address to a0
	clr.l	d3			;count = 0

CountLoop:
	tst.b	(a0)+			;is it NULL ?
	beq.b	PMsg			;yes: -=> determine length
	addq.l	#1,d3			;count = count+1
	bra.b	CountLoop		;test next byte

PMsg:
	move.l	stdout,d1		;get stdout to d1
	move.l	DOSBase,a6		;move DOSBase to a6
	jsr	Write(a6)		;write the Text
	movem.l	(sp)+,d0-d7/a0-a6	;reserve registers
	rts

;***********************************************************************
;*
;*	 binhex
;*		 	by Heiko Rath
;*
;* PURPOSE: Convert a binary value in a register to
;*	    a hex ASCII string at the destination address
;*          
;* ROUTINE TYPE: SUBROUTINE
;*
;* SYNTAX: bsr	binhex	(source(long),destination) (d0.l,a0)
;*	   bsr	binhexw	(source(word),destination) (d0.w,a0)
;*	   bsr	binhexb	(source(byte),destination) (d0.b,a0)
;*
;* ENTRY CONDITIONS: None
;*
;* RETURNS: ASCII string in destination address
;* NOTE: 	the destination place must contain 8 bytes for any
;*	        length (byte, word, longword)
;*
;* CHANGED: Nothing
;*
;* USAGE:
;*
;*	 move	#label,d0
;*	 move.l	address,a0	;converts the address at label to
;*	 bsr	binhex		;string at address
;*				
;*	 move	label,d0
;*	 move.l	address,a0
;*	 bsr	binhex		;conv contents at label
;*
;*	 move	#value,d0
;*	 move.l	address,a0
;*	 bsr	binhex		;convert immediate value
;*
;****************************************************************

binhex:	movem.l	d0-d2/a0,-(sp)		;save registers

	move.l	#7,d2			;get number of counts to d2
	clr.l	d1			;clear work register

001$:	rol.l	#4,d0			;move high nibble to low order
	move.b	d0,d1			;get low order byte to d1
	andi.b	#$f,d1			;isolate low order nibble
	cmp.b	#$0a,d1			;is it a letter or a digit?
	blt.b	002$			;if digit -=> 002$
	add.b	#'A'-'0'-$0A,d1		;offset for letters

002$:	add.b	#'0',d1			;convert to ASCII
	move.b	d1,(a0)+		;store it and increment storeaddress
	dbf.b	d2,001$			;do the converting 8 times

	movem.l	(sp)+,d0-d2/a0		;restore registers
	rts

;
; Variables:
;
DOSBase:	dc.l	0		;this contains the DOSlibraryaddress
stdout:		dc.l	0		;this contains stdout
Buffer:		dc.b	'00000000'	;At runtime this is the storage of
					; Type & Priority
ListHead:
	dc.l	0			;At runtime this contains the
					; address of the listheader
Node:
	dc.l	0			;At runtime this contains the
					; address of the current node
NodeCount:
	dc.l	0			;At runtime this contains the
					; number of nodes in the list
MyMemoryLength:
	dc.l	0			;At runtime this contains the
					; length of the memoryblock
MyMemoryBlock:
	dc.l	0			;At runtime this contains the
					; address of the memoryblock
MyMemoryOffset:
	dc.l	0			;At runtime this contains the
					; address of the memoryblock
					; + 48 Bytes per finished node

;
; Constants:
;
memlist:	dc.l	$142	;These are the offsets of the Exec-
reslist:	dc.l	$150	; systemlists. To get the address
devlist:	dc.l	$15e	; of a listheader they are added to
intrlist:	dc.l	$16c	; ExecBase.
liblist:	dc.l	$17a
portlist:	dc.l	$188
trdylist:	dc.l	$196
twtlist:	dc.l	$1a4
smlist:		dc.l	$214

DOSNAME:	cstring	'dos.library'
		cnop	0,2
INTNAME:	cstring	'intuition.library'
		cnop	0,2
Err:		dc.b	'*** Out of Memory Error ***',0
		cnop	0,2
NoName:		dc.b	'No Name',0
		cnop	0,2
LF:		dc.b	10,0		;LF
		cnop	0,2
HeadLine:	dc.b	$9b,'4;32;40m'
		dc.b	'Name:                         Address Type Pri'
		dc.b	$9b,'0;31;40m',10,0
		cnop	0,2
Text:
	dc.b	$9b,'0;33;40m','ListScanner',$9b,'0;31;40m'
	dc.b	' by Heiko Rath - copyright ',169,' by '
	dc.b	$9b,'1;31;40m','The Software Brewery',$9b,'0;31;40m',10
	dc.b	'            '
	dc.b	'Raiffeisenstr.10a,D-6108 Weiterstadt,Tel.06150-2658',10
	dc.b	'            '
	dc.b	'(famous last words: Where is my Marabou chocolate?)'
	dc.b	10,10,0
		cnop	0,2
memlist.txt:	dc.b	'MemoryList:',10,0
		cnop	0,2
reslist.txt:	dc.b	'ResourceList:',10,0
		cnop	0,2
devlist.txt:	dc.b	'DeviceList:',10,0
		cnop	0,2
intrlist.txt:	dc.b	'InterruptList:',10,0
		cnop	0,2
liblist.txt:	dc.b	'LibraryList:',10,0
		cnop	0,2
portlist.txt:	dc.b	'PortList:',10,0
		cnop	0,2
trdylist.txt:	dc.b	'TaskReadyList:',10,0
		cnop	0,2
twtlist.txt:	dc.b	'TaskWaitingList:',10,0
		cnop	0,2
smlist.txt:	dc.b	'SemaphoreList:',10,0
