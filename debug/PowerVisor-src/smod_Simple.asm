*****
****
***			S I M P L E   source debug handler for   P O W E R V I S O R
**
*				Version 1.43
**				Wed Jun 15 17:00:54 1994
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


	;---
	;Subroutine: load debug hunks
	;a3 = filename
	;a2 = debug node
	;a4 = pointer to hunk list or 0
	;-> d0 = 1 if success, 0 if no debug hunks
	;-> d1 = 0, flags if error
	;---
LoadDebugHunks:
		moveq		#0,d6					;No symbols yet
		move.l	a4,d0
		bne.b		12$

	;Pointer to hunk list is 0
		movea.l	(db_Task,a2),a4
		move.l	(pr_CLI,a4),d0
		beq.b		9$

	;It is a cli, so we use the cli_Module instead of the pr_SegList
		lsl.l		#2,d0
		movea.l	d0,a4					;ptr to cli
		move.l	(cli_Module,a4),d0
		bra.b		10$
9$		move.l	(pr_SegList,a4),d0
		lsl.l		#2,d0					;BPTR->APTR
		movea.l	d0,a4
		move.l	(12,a4),d0			;Get ptr first seglist
10$	lsl.l		#2,d0
		movea.l	d0,a4
		lea		(4,a4),a4

	;Entry point if hunks are given (in a4)
12$	move.l	a3,d1					;Filename
		bsr		FOpen
		beq		13$					;Error
		move.l	d0,d7					;Ptr to filehandle

	;Main loop
1$		move.l	#Dummy,d2
		moveq		#8,d3
		move.l	d7,d1
		bsr		FRead					;Read hunk type
		subq.l	#8,d0
		beq.b		8$

	;End of loop (without errors)
14$	bsr		CleanupLoadSym
		move.l	d6,d0
		moveq		#1,d1					;No error, flags
		rts

	;Check the type of the hunk
8$		move.l	(Dummy),d0
;	andi.l	#$00ffffff,d0
		subi.w	#$3e7,d0
		beq.b		2$						;UNIT
		subq.w	#1,d0
		beq.b		2$						;NAME
		subq.w	#1,d0
		beq.b		2$						;CODE
		subq.w	#1,d0
		beq.b		2$						;DATA
		subq.w	#1,d0
		beq.b		1$						;BSS
		subq.w	#1,d0
		beq.b		3$						;RELOC32
		subq.w	#1,d0
		beq.b		3$						;RELOC16
		subq.w	#1,d0
		beq.b		3$						;RELOC8
		subq.w	#1,d0
		beq.b		4$						;EXT
		subq.w	#1,d0
		beq.b		11$					;SYMBOL
		subq.w	#1,d0
		beq.b		15$					;DEBUG
		subq.w	#1,d0
		beq.b		5$						;END
		subq.w	#1,d0
		beq		6$						;HEADER
		bra.b		4$

	;Handle symbol hunk
11$	bsr		SkipSymbolHunk
		bra		1$

	;There was an error
17$	bsr		CleanupLoadSym
13$	moveq		#0,d1					;Error (flags)
		rts

	;Handle debug hunk
15$	moveq		#1,d6					;Yes there are debug hunks
		move.l	(Dummy+4),d4		;Get size in longwords
		movea.l	(Storage,pc),a3	;Ptr to storage
		bsr		DebugRS
		beq.b		17$					;Error
		bra		1$

	;Ext, Overlay, Break
4$		SERR		NotAValidExecFile
		bra.b		17$

	;Normal hunks with size
2$		move.l	(Dummy+4),d2		;Get size
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		bra		1$

	;Reloc32,16,8
3$		move.l	(Dummy+4),d2
		beq		1$
		addq.l	#1,d2
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		move.l	#Dummy+4,d2
		moveq		#4,d3
		bsr		FRead
		bra.b		3$

	;End
5$		moveq		#-4,d2				;HUNK_END is only 4 bytes, not 8
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek

	;Go to next hunk
		move.l	(-4,a4),d0
		beq		14$
		lsl.l		#2,d0
		movea.l	d0,a4
		lea		(4,a4),a4
		bra		1$

	;Header
6$		move.l	(Dummy+4),d2
		beq.b		7$
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		move.l	#Dummy+4,d2
		moveq		#4,d3
		bsr		FRead
		bra.b		6$
7$		move.l	#Dummy,d2
		moveq		#12,d3
		bsr		FRead
		move.l	(Dummy+8),d2
		sub.l		(Dummy+4),d2
		addq.l	#1,d2
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		bra		1$

	;Close file handle and sort symbol table (if needed)
CleanupLoadSym:
		move.l	d7,d1
		bra		FClose

	;Skip symbol hunk
SkipSymbolHunk:
		moveq		#-4,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
1$		moveq		#4,d3
		move.l	(Storage),d2
		move.l	d7,d1
		bsr		FRead
		movea.l	(Storage),a0
		move.l	(a0),d2
		beq.b		2$
		addq.l	#1,d2
		lsl.l		#2,d2					;Length of string+4 (extra value)
		move.l	d7,d1
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek					;Skip this string
		bra.b		1$
2$		rts								;Return to caller of 'LoadSymbols'

	;Symbol
	;-> flags eq if error
SymbolRS:
		moveq		#-4,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
1$		moveq		#4,d3
		move.l	(Storage),d2
		move.l	d7,d1
		bsr		FRead
		movea.l	(Storage),a0
		move.l	(a0),d3
		beq.b		2$
		addq.l	#1,d3
		lsl.l		#2,d3
		move.l	d3,d4
		move.l	(Storage),d2
		addq.l	#4,d2
		bsr		FRead
		movea.l	(Storage),a0
		addq.w	#4,a0
		move.l	(-4,a0,d4.l),d0
		add.l		a4,d0
		bsr		AppendSymbol
		bne.b		1$

	;Error
		moveq		#0,d1					;Error (flags)
		rts

	;No error
2$		moveq		#1,d1					;Flags
		rts

JumpTable:
		dc.l		FRead
		dc.l		FSeek
		dc.l		AddSourceFile
		dc.l		AllocClear

	;***
	;Load a debug chunk
	;d4 = size in longwords of this chunk
	;d7 = PowerVisor file handle, only use this with the given filehandle
	;		routines. DON'T use AmigaDOS routines
	;a2 = pointer to debug node
	;a3 = pointer to area you can use (300 bytes long)
	;a4 = pointer to current hunk
	;?? = pointer to jump table
	;-> flags eq if error
	;***
DebugRS:
		lsl.l		#2,d4					;Nr of bytes to read
		moveq		#4,d3
		move.l	a3,d2
		move.l	d7,d1
		bsr		FRead					;Get offset in current hunk to add with
											;other following offsets
		subq.l	#4,d4					;Decrement remaining size in debug hunk
		movea.l	(a3),a5				;a5 = offset
		move.l	a5,d0
		bne.b		5$
	;If offset = 0 we must ignore it (this is the case for SAS/C 5.x). We
	;will add one to the offset so that it will become 0 again later
		lea		(1,a5),a5

5$		moveq		#8,d3
		move.l	a3,d2
		move.l	d7,d1
		bsr		FRead					;Read 'LINE' <len>
		subq.l	#8,d4					;Decrement remaining size in debug hunk
		move.l	(a3),d0
		cmp.l		#'LINE',d0
		bne		3$

	;Read the name of the source file
		move.l	(4,a3),d3
		lsl.l		#2,d3					;Length of string to read
		clr.l		(0,a3,d3.l)			;NULL-terminate the string
		sub.l		d3,d4					;Decrement remaining size in debug hunk
		move.l	d7,d1
		move.l	a3,d2
		bsr		FRead
		movea.l	a3,a0
		bsr		AddSourceFile
		beq.b		4$

	;Success!
	;The remaining debug hunk is the list of <line numbers> and
	;<offsets>
		movea.l	d0,a3					;Remember pointer to source structure
		move.l	d4,(srcf_LinesSize,a3)
		move.l	d4,d0
		bsr		AllocClear
		beq.b		4$

	;Success!
		move.l	d0,(srcf_Lines,a3)
		move.l	d0,d2
		move.l	d4,d3
		move.l	d7,d1
		bsr		FRead

	;All things have been allocated and loaded, we must now relocate the
	;offsets in the 'Lines' block to the correct addresses

		subq.l	#1,a5					;Make offset one smaller
		lsr.l		#3,d4					;Number of lines in set
		movea.l	(srcf_Lines,a3),a0
	;We assume there is at least one line
1$		lea		(4,a0),a0
		move.l	(a0),d0
		add.l		a5,d0					;Add global offset
		add.l		a4,d0					;Hunk start
		move.l	d0,(a0)+
		subq.l	#1,d4
		bgt.b		1$

		moveq		#1,d1					;No error (flags)
		rts

	;Error
4$		moveq		#0,d1					;Error (flags)
		rts

	;This debug hunk does not contain line number information, skip it
3$		move.l	d4,d2					;Remaining size to skip
		move.l	d7,d1
		moveq		#OFFSET_CURRENT,d3
		bra		FSeek					;Skip it
