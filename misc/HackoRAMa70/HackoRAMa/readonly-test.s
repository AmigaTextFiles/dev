
	MC68040
	DEBUG	LINE,CODE,DATA	; full debug info
	incdir	"Includes:"
	exeobj
	addsym
	output	src:Tst

	ifd	__M68
	fwdrefassign		; labels not yet defined is ok
	OLDSYNTAX		; no funny ( , , ) only addressing
	ODDERROR		; word/longword at odd is illegal

	macfile	macros:macros
	else
	include	exec/exec.i
	include	exec/funcdef.i
	include	exec/exec_lib.i
	include	exec/memory.i
	include	libraries/dos_lib.i
	include	macros:macros
	endc

	include	mmu/mmu_lib.i
	include	mmu/mmu_ver.i
	include	d:h-o-r/mmubase.i
	include	d:h-o-r/pts.i

demo_illegal	equ	1
usepool	equ	1
manual	equ	1
pages		equ	16
allocsize	equ	pages*$1000

;	section	demo,code,fast
	section	demo,code

	move.l	Magic(pc),d0
	bra	Start		; ----------

Magic	dc.l	$000340000

Start	move.l	d0,Magic
	and.w	#$0fff,d0
	bne	.out

	move.l	4.w,a6
	move.l	a6,EXECBase

	OpenLib	Dos,.out
	DOS	Output
	move.l	d0,StdOut
	beq	.out
	move.l	EXECBase(pc),a6

	ifeq	manual
; alloc a 4k block on a 4k aligned address
.try	move.l	#4096,d0
	move.l	Magic(pc),a1
	SYS	AllocAbs
	tst.l	d0
	bne	.ok
	sub.l	#4096,Magic
	bne	.try
	bra	.out

.ok	bsr	.printstuff

	endc

.mmu	OpenLib	Mmu,.getbit
	move.l	MmuBase,mc

	ifeq	manual
	move.l	Magic(pc),d0
; manually set protection. This will be valid across all tasks!!!
	ifd	demo_illegal
	MMU	SetIllegal
	else
	MMU	SetReadonly
	endc

	move.l	a0,d6
	move.l	d0,d7

	endc

; get the new MEMF definitions from mmu.library
.getbit	tst.l	MmuBase
	beq	.noget
	MMU	GetBit_GLOBAL_ILLEGAL
	move.l	d0,bit_GI
	SYS	GetBit_TASK_READONLY
	move.l	d0,bit_TRO
.noget

	ifeq	usepool
; open a V39 memory pool. no version check...
; do not use TASK_READONLY with pools!!!
	move.l	#MEMF_CLEAR,d0
	or.l	bit_GI,d0
	move.l	#$1000*$10,d1
	move.l	#$2000,d2
.pool
	EXEC	CreatePool
; the pool header was _not_ protected!

	move.l	a0,d3
	beq	.oldmemstatus

	move.l	d3,a0		; header
	move.l	#$1000,d0	; size
; this memory will get protected with the pool flags
.pud	SYS	AllocPooled
.pad	move.l	d0,a0
	move.l	(a0),d0
	clr.l	(a0)		; only legal for this task (illegal with TRO)
	move.l	d3,a0
	SYS	DeletePool	; pools are nice: all allocs goes away

	endc

; alloc 4*4k that we can write but all others can not
	move.l	#allocsize,d0
	move.l	#MEMF_CLEAR!MEMF_FAST,d1
	or.l	bit_GI,d1
; TASK_READONLY is stupid when allocating
	or.l	bit_TRO,d1
	EXEC	AllocMem
	move.w	#$0f00,COL00
	move.l	d0,PrivateMem
	beq	.out
	bsr	.printd0
	bsr	.printeol

.valid
	move.l	PrivateMem,a3
	move.l	a3,d0
	and.l	#$fff,d0
	beq	.ok
	tst.l	$cccccccc
.ok

	ifeq	1
	move.w	#$00f0,COL00

	move.l	#5000000,d0
.l	dbra	d0,.l
	swap	d0
	move.w	d0,COL00
	swap	d0
	sub.l	#$10000,d0
	bpl	.l
	endc

.gotmem
	move.l	#50,d1
;	DOS	Delay

;	tst.l	$eeffeeff

	ifeq	1
	move.l	#5000000,d0
.v	dbra	d0,.v
	swap	d0
	move.w	d0,COL00
	swap	d0
	sub.l	#$10000,d0
	bpl	.v
	endc

;	bra	.td
	move.l	a3,a4

;	bra	.bang

	psh.l	d0-d7/a0-a6
	move.l	a3,a0
	move.l	a3,a1
	move.l	a3,a2
	move.l	a3,a4
	move.l	a3,a5
	move.l	a3,a6
	moveq	#1,d0
	moveq	#2,d1
	moveq	#3,d2
	moveq	#4,d3
	moveq	#5,d4
	moveq	#6,d5
	moveq	#7,d6
	moveq	#8,d7
	move.l	d0,(a0)
	move.l	d1,(a1)
	move.l	d2,(a2)
	move.l	d3,(a3)
	move.l	d4,(a4)
	move.l	d5,(a5)
	move.l	d6,(a6)
	move.l	d7,(a0)
	pll.l	d0-d7/a0-a6

	lea	$4,a0
	neg.l	(a0)
	neg.l	(a0)
	neg.l	(a0)
	neg.l	(a0)
	neg.l	(a0)

.bang
	repeat	pages
		tst.l	(a3)
		bne	.oops
		add.l	#$1000,a3
	endr
	move.l	a4,a3
	repeat	pages
		tst.l	(a3)
		bne	.aarg
		not.l	(a3)		; read 0, write -1
		tst.l	(a3)
		bne	.oops		; the -1 write should not have happened
		add.l	#$1000,a3
	endr
	bra	.lasso

.td
	nop
;	bra	.tehe

.lasso
; test tail protection
	moveq	#10-1,d3
.tailo	move.l	PrivateMem(pc),a0
	move.l	#allocsize,d0
	move.l	(a0,d0.l),(a0,d0.l)	; this gives Enforcer hit
	move.l	#15,d1
	DOS	Delay
;	dbra	d3,.tailo
.tehe

; waste time while waiting for user
	jsr	.Spin

.down

; free the memory we allocated
	move.l	PrivateMem(pc),d0
	beq	.out
	move.l	d0,a1
	move.l	#allocsize,d0
	EXEC	FreeMem

.oldmemstatus
; reset the status for the memory we changed manually
	move.l	EXECBase(pc),a6

	ifeq	manual
	move.l	d6,a0
	move.l	d7,d0

	ifd	demo_illegal
	MMU	SetPageDescriptor
	else
	MMU	RestoreDescriptor
	endc

	endc

	tst.l	MmuBase
	beq	.noprt
	move.l	MmuBase,a2
	move.l	mmub_DescriptorChip(a2),d0
;	bsr	.printd0
	move.l	mmub_DescriptorFast(a2),d0
;	bsr	.printd0
;	bsr	.printeol

.noprt

; free memory
.out
	ifeq	manual
	move.l	Magic(pc),d1
	beq	.memfree
	move.l	#4096,d0
	move.l	d1,a1
	EXEC	FreeMem

	endc

.memfree
	CloseLib	Mmu
	CloseLib	Dos
	rts
; that's it. You're clear now kid.

.printstuff
	rts
	lea	text1(pc),a0
	PrintStr	.out
	bsr	.printd0
	lea	text2(pc),a0
	PrintStr	.out
	bsr	.printeol
	rts
.printd0
;	rts
	PrintLong	.out
	PrintSPC	.out,2
	rts
.printeol
;	rts
	PrintEOL	.out
	rts
.Spin
.poll	JOY1jmp	.pout
	move.l	#50,d1		; 1 second
	DOS	Delay
	bra	.poll
.pout
	rts

	psh.l	d0-d7/a0-a6
	move.l	EXECBase,a6
	move.l	ThisTask(a6),a6
	move.l	TC_Userdata(a6),a6	; get pointer to PerTaskStruct
	addq.l	#pts_BitsSize,a6
	move.l	(a6)+,d3	; bits array size
	move.l	(a6)+,a3	; table == end of bitmap+1
	move.l	a3,a1		; from task table
	move.l	(a6)+,a0	; to Work

	lsr.l	#2,d3			; longs to counter
	subq.l	#1,d3			; loop adjust
.find_private
	move.l	-(a3),d2
	dbne	d3,.find_private
	bne	.found_private
	move.l	pagebits,d0
	bsr	.printd0
	bsr	.printeol
	pll.l	d0-d7/a0-a6
	rts
.found_private
	move.l	d3,d1		; 14M is 6C longs
	subq.w	#1,d3
; each long: 32 bits - each bit: 4 byte
	lsl.l	#7,d1		; offset from start of table
	moveq	#31,d0
.find_page
	lsr.l	#1,d2		; check bit
;.do_loop
	dbls	d0,.find_page	; condition: either carry set or zero set
	bcc	.find_private
.found_page
	move.l	d1,a2		; d1
	lea	(a2,d0.l*4),a2	; +d0*4
	lea	(a0,a2.l),a4	; insert descriptor from table to table
	psh.l	d0
	move.l	a4,d0
	bsr	.printd0	; desc dest
	lea	(a1,a2.l),a4
	move.l	a4,d0
	bsr	.printd0	; desc src
	move.l	(a1,a2.l),d0
	bsr	.printd0	; desc
	pll.l	d0
	bsr	.printeol
	add.l	#1,pagebits
;	clrc
;	clrz
;	bra	.do_loop
	subq.w	#1,d0
	bpl	.find_page
	bra	.find_private

.oops	move.l	(a3),$f0f0f0ff
	nop
	move.l	a3,$f0f0f0f0
	bra	.td

.aarg	move.l	(a3),$ffff0001
	nop
	move.l	  a3,$ffff0000
	bra	.td

EXECBase	dc.l	0
DosBase		dc.l	0
MmuBase		dc.l	0
bit_GI		dc.l	0
bit_TRO		dc.l	0
mc		dc.l	0
PrivateMem	dc.l	0
StdOut		dc.l	0
pagebits	dc.l	0
DosName		dc.b	"dos.library",0
MmuName		MMUNAME
	ifd	demo_illegal
text1	dc.b	"Try to read memory at $",0
	else
text1	dc.b	"Try to write to memory at $",0
	endc
text2	dc.b	" now. Exit with joystick button (1s push needed).",CR,0
	even
Nybble2Ascii	NYBBLE2ASCII
	end
