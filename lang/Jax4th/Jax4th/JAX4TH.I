*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
*									*
*	jax4th.i ... shared includes for JAX4TH				*
*	*C* COPYRIGHT 1991, 1993 jack j. woehr				*
*	jax@well.UUCP JAX on GEnie SYSOP, RCFB (303) 278-0364		*
*									*
*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*

*--- Register Equates

dsp	equr	a7	; data stack pointer, ptr to "rest of stack"
rp	equr	a6	; return pointer
ip	equr	a5	; instruction pointer
bp	equr	a4	; base pointer to local data space
np	equr	a3	; next pointer, points to copy of NEXT in local image
cp	equr	a2	; points to base of resident code space
tos	equr	d7	; top of stack is "cached"
dp	equr	d6	; local dictionary pointer
ap	equr	d5	; allocation pointer to data space

*--- Some Other Equates

eol		equ	$0a		; end of line character
charsize	equ	1		; size of a char in address units
cellsize	equ	4		; cellsize of our 32-bit Forth
numthreads	equ	4		; number threads in a voc
vocwidth	equ	((numthreads*cellsize)+cellsize+cellsize)
; thread0/thread1/thread2/thread3/voclink/nameptr
numvocs		equ	8		; max vocs in search order
contextsize	equ	numvocs*cellsize	; CONTEXT voc ptr array size
namebit		equ	$80		; mask for start and end of name field
immedbit	equ	$40		; mask for IMMEDIATE word's count byte
dirtybit	equ	$80000000	; mask for a BUFFER to be SAVEd
unheader	equ	-1		; cell-size mask for headerless def
maxncount	equ	$1F		; max char count in a name header
maxnchar	equ	$7F		; max ascii value of a name character
kernbit		equ	$80000000	; mask for kernel token
doflag		equ	$FFFFFFFF	; compiler security flag
ifflag		equ	$7FFFFFFF	; compiler security flag
beginflag	equ	$3FFFFFFF	; compiler security flag
forflag		equ	$1FFFFFFF	; compiler security flag
whileflag	equ	$0FFFFFFF	; compiler security flag
elseflag	equ	$07FFFFFF	; compiler security flag
compflag	equ	$00FFFFFF	; a general purpose mask
countstrsize	equ	$FF		; longest counted string
tibsize		equ	$100		; do signed count bytes exist?
inputsize	equ	$80		; all we ACCEPT in TIB for now
argarraysize	equ	cellsize*$0D	; regs for function calls, D0-D6/A0-A5
emitbufsize	equ	$100		; size of stored ouput strings
dstampsize	equ	cellsize*3	; AmigaDOS DateStamp
readbuffsize	equ	$1000		; size of a file read buffer
blockoversize	equ	4		; bytes in BLOCK overhead
rawblocksize	equ	$400		; bytes in a BLOCK itself
blocksize	equ	rawblocksize+blockoversize	; size of a block buffer with overhead
numblockbuffs	equ	2		; number of BLOCK buffers we'll support
blockbuffsize	equ	blocksize*numblockbuffs	; two block buffers
charsperline	equ	64		; characters per line of a screen file
linesperscreen	equ	rawblocksize/charsperline	; lines in a SCR

*--- Macros

;--- Stack Manipulation

pshdsp	macro		; move cached top of stack to data stack.
	move.l	tos,-(dsp)	; this by itself is DUP
	endm

push	macro		; move tos to dsp and cache arg \1 as tos
	pshdsp
	move.l	\1,tos
	endm

popdsp	macro		; restore top of stack from data stack.
	move.l	(dsp)+,tos	; this by itself is DROP
	endm

pop	macro		; move tos to \1 and restore tos from dsp
	move.l	tos,\1
	popdsp
	endm

rpush	macro		; push \1 to return stack
	move.l	\1,-(rp)
	endm

rpop	macro		; pop return stack to \1
	move.l	(rp)+,\1
	endm

tonext	macro	; compiled inline at end of code words
	jmp	(np) ; NP will be set to NEXT
	endm

nest	macro		; inline execution engine for colon definition
	rpush	ip	; save the instruction pointer,
	lea.l	*+6(pc),ip	; load IP with this word's addr list base addr
	tonext		; jump next.
	endm

;--- Calling DOS and Exec for Kernel Startup Routines

callos	macro		; call Amiga lib when libptr in A6
	jsr	_LVO\1(rp)	; jump to offset from lib ptr
	endm

callamy	macro	; \1 Routine \2 Lib Save RP when using lib ptr
	move.l	rp,-(sp)		; save a6
	move.l	#\2lib,rp	; get the lib ptr var address
	move.l	0(bp,rp.l),rp	; get the lib ptr itself into A6
	callos	\1		; call the routine
	move.l	(sp)+,rp	; discard lib pointer, restore RP
	push	d0		; save return val from call
	endm

;--- Some General Tools for User-Specified OS Calls

savereg	macro	; save the Forth engine except the stack & lib pointer and TOS
	movem.l	cp-rp/ap-dp,-(sp)
	endm

getreg	macro	; restore the Forth engine except stack & lib pointers & TOS
	movem.l	(sp)+,ap-dp/cp-rp
	endm

getarg	macro	; load all except stack ptr, tos and lib ptr for an OS call
	push	#argarray
	movem.l	0(bp,d7.l),d0-d6/a0-a5
	popdsp
	endm

;----------------------------------------------------------------------------;
; Kernel variables are declared at the end of this file. Since ! and @	     ;
; will convert offsets in the data segment to absolute addresses transparent ;
; to the user, the DOCREATE and DOCONSTANT engines are identical.	     ;
;----------------------------------------------------------------------------;

docreat	macro	; compile dataseg offset + execution engine
	push	#\1			; push dataseg offset from jax4th.i
	tonext				; and go NEXT
	endm

;--- Constants in the shared segment use the same execution engine.

doconst macro	; compile literal + execution engine
	push	#\1	; \1 is the constant value
	tonext	; return to Forth
	endm

;---------------------------------------------------------------;
; And Vocabularies use this one. The voc ptr is a DSeg-relative	;
; address to be deref'ed like all data access in this Forth.	;
;---------------------------------------------------------------;

dovoc	macro	; assemble execution engine for a vocabulary
	move.l	#contextarray,d0
	move.l	#\1,0(bp,d0.l)	; CONTEXT[0] <- DSeg.forthvoc
	tonext			; return to Forth
	endm

* DOES and UNDOES aren't quite right yet, the stack is messy
* maybe a rp -> a0 ip -> rp a0 ->ip? foof.

* dodoes	macro	; execute hilevel interpreter compiled with does>
*	rpush 	(ip)	; push the ip
*	move.l	(sp)+,ip	; new ip is waiting on the system stack
*	next		; jump next
*	endm

* undoes	macro	; return from hilevel to code level
*	rpush	ip	; hide subroutine return address
*	move.l (sp)+,ip	; pop system stack to restore ip
*	rts		; return
*	endm

;--- Stores & Fetches

sto	macro	; addr in tos, data in @sp
	move.l	(sp)+,0(bp,tos.l)
	endm

fet	macro	; addr in tos, returns data in tos
	move.l	0(bp,tos.l),tos
	endm

;--- Block Moves

* There is something that should be noted here about byte and
* block moves. CMOVE> actually moves to the left. CMOVE moves
* to the right. The ">" in CMOVE is intended to signify that
* the *data* is moving left (low mem) to right (high mem).
* I have found this confusing!

lindex	macro	; set up indices for data to move left progressing right
	movea.l	bp,a0		; base address of data segment
	movea.l	bp,a1		
	adda.l	(dsp)+,a1	; destination
	adda.l	(dsp)+,a0	; source
	endm

rindex	macro	; set up indices for data to move right progressing left
	lindex
	adda.l	tos,a0		; add count for backwards move
	adda.l	tos,a1
	endm

dmov	macro			; prepare to move to prevent overlap
	move.l	4(dsp),d0	; get source
	cmp.l	(dsp),d0	; destination greater than source?
	endm			; LT if DEST > SRC

;--- Dictionary Alignment ... these are all forward aligns

walin	macro			; align contents of Dreg to next word boundary
	moveq.l	#0,d0		; obviously, \1 can't be d0
	lsr.l	#1,\1
	addx.l	d0,\1
	lsl.l	#1,\1
	endm

lalin	macro			; align contents of Dreg to next lword boundary
	moveq.l	#0,d0		; obviously, \1 can't be d0
	lsr.l	#1,\1
	addx.l	d0,\1
	lsr.l	#1,\1
	addx.l	d0,\1
	lsl.l	#2,\1
	endm

apalin	macro			; align allocation pointer
	lalin	ap
	endm

wapalin	macro			; word align allocation pointer
	walin	ap
	endm

dpalin	macro			; align dictionary pointer
	lalin	dp
	endm

wdpalin	macro			; word align dictionary pointer
	walin	dp
	endm

;--- Relative and Absolute Addressing

krn2abs	macro	; convert a resident kernel image addr token in \1 to abs addr
	lsl.l	#1,\1	; \1 must be a data reg
	add.l	cp,\1
	endm

cod2abs	macro	; convert a local image code addr token in \1 to abs addr
	lsl.l	#1,\1	; \1 must be a data reg
	add.l	np,\1
	endm

dat2abs	macro	; convert a local image data addr in \1 to abs addr
	add.l	bp,\1
	endm

abs2krn	macro	; convert abs addr in \1 to resident kernel image addr token
	sub.l	cp,\1
	lsr.l	#1,\1	; \1 must be a data reg
	ori.l	#kernbit,\1
	endm

abs2cod	macro	; convert abs addr in \1 to local image code addr token
	sub.l	np,\1
	lsr.l	#1,\1	; \1 must be a data reg
	endm

abs2dat	macro	; convert a local image data addr in \1 to abs addr
	sub.l	bp,\1
	endm

;--- Dictionary and Data Management

dicp	macro			; get the local dictionary pointer
	push	dp		; to the top of the stack
	endm

datp	macro			; get the local dataseg pointer
	push	ap		; to the top of stack
	endm

;-----------------------------------------------------------------------;
; Link Fields will be offsets just like execution tokens, masked in	;
; the same manner: right-shifted one bit and masked with $80000000	;
; if they reside in the kernel, unmasked in D31 if they are in the	;
; local code image.							;
;-----------------------------------------------------------------------;

lfa	macro	; create link field in specified thread
	dc.l	link\1
link\1	set	((((*-start)-4)>>1)|kernbit)	; reset the specified link
	endm

nfa	macro	; create name field, count & last char |$80
	ifeq	narg-3
	dc.b	\1|namebit,\2,(\3|namebit)	; ct, string, nth char
	else
	dc.b	\1|namebit,(\2|namebit)		; ct, sole char
	endc
	cnop	2	; word-align start of word
	endm	; the above may become longword-align for 68020/30

nfi	macro	; create IMMEDIATE name field count & last char |$80
	ifeq	narg-3
	dc.b	\1|namebit|immedbit,\2,(\3|namebit)	; ct, string, nth char
	else
	dc.b	\1|namebit|immedbit,(\2|namebit)	; ct, sole char
	endc
	cnop	2	; word-align start of word
	endm	; the above may become longword-align for 68020/30

headerless	macro	; so Headerless defs may be recognized by decompiler
	dc.l	-1
	endm

exetok	macro	; execution token in D0, jump to correct machine addr
	lsl.l	#1,d0		; msb set indicates a kernel token
	bcc.s	1$		; branch if carry indicates local token
	jmp	0(cp,d0.l)	; interpret token as a kernel address
1$	jmp	0(np,d0.l)	; interpret token as a local address
	endm

dereftok	macro	; \1 is register containing token
	move.l	\1,d0		; copy to a shift-able register
	lsl.l	#1,d0		; shift out kernel/local bit
	bcc.s	8$		; branch if carry indicates local token
	add.l	cp,d0		; convert kernel token to absolute address
	bra.s	9$
8$	add.l	np,d0		; convert local token to absolute address
9$	move.l	d0,\1
	endm

*--- Counted String Assembly

;-----------------------------------------------------------------------;
; Note that the handling of counted strings in the kernel will be	;
; different from the handling of same in the runttime system. BASIS12	;
; is somewhat ambiguous about the location of the strings compiled by	;
; '"' (quote) ... my intent is that the runtime system will compile	;
; them into data space so they may be altered. (The code segment will	;
; not be generally readable with "@", etc., nor will the kernel).	;
;-----------------------------------------------------------------------;

countstr macro	; "a string" is arg \1
	dc.b	(1$-(*+1))	; count byte
	dc.b	\1		; compile string
1$	cnop	2		; align dictionary
	endm	

*--- Allocating storage in the local image data segment

dataptr	set	0	; keeps track of our local dataseg usage

;--- Perform assembly-time allocation of slots in the local dataseg
;    which will be constructed/loaded at runtime

allocdat	macro
dataptr	set	dataptr+\1	; \1 is number of bytes
	endm

setdat	macro	; perform allocation as above and SET symbol
\1	set	dataptr		; \1 is symbolic name
	allocdat	\2	; \2 is amount of storage
	endm

avar	macro	; make a variable allocation
	setdat	\1,cellsize	; assign offset
	endm

avoc	macro	; make a vocabulary allocation
	setdat	\1,vocwidth+cellsize	; one cell extra for backlink
	endm

*--- Default variables in each image's data seg

	avar	empty	; holds image dictionary size	
	avar	there	; holds image data size
	setdat	contextarray,contextsize	; the CONTEXT array
	avar	stdout	; I/O handle loaded by startup
	avar	stdin	; ditto
	avar	appwin	; -1 = opened NEWCON:  0 = stdio  n = custom win
	setdat	emitbuf,emitbufsize	; holds chars for output
	avar	base	; holds numeric base
	avar	doslib	; holds DOS libptr
	avar	execlib	; holds Exec libptr
	avoc	forthvoc	; the FORTH voc thread array
	avoc	impvoc	; the IMPLEMENTOR voc thread array
	avar	spzero	; hold initial stack pointer passed by AmigaDOS
	avar	rpzero	; hold initial return stack allocated at Forth startup
*	avar	rpsize	; hold user request for rstacksize at next load
	avar	savedimage	; holds various info for a saved image
	avar	autostart	; holds autostart vector for a saved image
	avar	state	; compiling or interpreting?
	avar	span	; count returned by EXPECT
	avar	ticktib	; holds address of Terminal Input Buffer
	setdat	tickword,tibsize	; WORD buffer \ s.b. a MEMALLOC
	setdat	tibuf,tibsize	; Terminal Input Buffer	\ ditto above
	setdat	sqbuff,tibsize	; Holds interpreted S" strings
	avar	numtib	; number of chars read into terminal input buffer
	avar	toin	; input pointer indexing thru TIB
	setdat	argarray,argarraysize	; holds reg args for OSCalls
	avar	blk	; tells which BLOCK being interp'ed or 0 for terminal
	avar	last	; last word in any wordlist added to dictionary
	avar	width	; holds max num chars <32 to be saved in name fields
	avar	hld	; holds number conversion string inset
	avar	dpl	; holds decimal point place of last number parse
	avar	endq	; true if at end of input line
	avar	caps	; true if all input should be converted to uppercase
	avar	istype	; holds deferral for TYPE
	avar	isemit	; holds deferral for EMIT
	avar	iswhere	; holds deferral for WHERE
	avar	isqerror	; holds deferral for ?ERROR
	avar	catcher		; head of linked list for CATCH/THROW
	setdat	datestamp,dstampsize	; holds AmigaDOS DateStamp() return
	avar	current		; holds CURRENT vocabulary
	avar	tickreadbuff	; holds abs addr of fileread buffer
	avar	tickblockbuff	; holds abs addr of base of block buffers
	avar	csp		; holds stack depth during compilation
	avar	blockfid	; holds BLOCK file identifier
	avar	sourcefile	; holds source file identifier
	avar	nonaming	; TRUE if a :NONAME def is under composition
	avar	voclink		; holds pointer to last vocab declared
	avar	memtype		; holds allocation type for mem allocs
	avar	lastblk		; holds index of most-recently-used BLOCK
	avar	scr		; holds current SCReen number

*--- End of File
