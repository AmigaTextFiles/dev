

;MakeGAR	equ	1	; only for bughunt

; Alloc: lage r/w descriptor for 030


	ifnd	AmiNet
;CPU68030	equ	1
	endc
DEADLY		equ	1
Scratch		equ	1	; define to trash scratch registers (no protection)

;dummy		equ     0
	ifnd	PatchUnLoad
		ifd	AmiNet
PatchUnLoad		equ	0	; 1 == do patch, 0 == no patch
		else
PatchUnLoad		equ	1	; 1 == do patch, 0 == no patch
		endc
	endc

	ifnd	CPU68030
		ifnd	CPU68040
			ifnd	AmiNet
				ifnd	CPU68060
CPU68060	equ	1
				endc
			endc
		endc
	endc


dbug	macro
	ifeq	1
		bsr	StackDump
		dc.b	\1
		ifne	((*-CodeStart)&1)
			dc.b	" "
		endc
		dc.b	10,0
	endc
	endm

CMPNOPL	macro
	dc.w	$bffc		; cmp.l #$xxxxxxxx,sp
	endm

CHIP_END	equ	$00200000	; magic number - end of chip memory









	ifeq	1
030
USP=07e21dcc| SSP=07c02288|  PC=07dd4348|SR=0000|
VBR=00000000| SFC=00000007| DFC=00000007
MSP=e243698c| ISP=07c02288|CACR=00002111|CAAR=1fdf5df6
CRP=000f000207fff140      | SRP=8000000100000000
TT0=04038207| TT1=403f8107|  TC=80f08630| PSR=0000

030 Enforcer etter LINK
USP=07e21b68| SSP=07c02288|  PC=07dd434c|SR=8000|T1
VBR=07e74218| SFC=00000007| DFC=00000007
MSP=e243698c| ISP=07c02288|CACR=00002111|CAAR=1fdf5df6
CRP=8000000207e51bb0      | SRP=8000000100000000
TT0=04038207| TT1=403f8107|  TC=80a08680| PSR=0000

CRP=000f0002 07fff140
CRP=80000002 07e51bb0
TC=80f08630
TC=80a08680

CRP:
8000 0002 07e5 1bb 0
L/U == unsigned lower limit
LIMIT == 0
DT == VALID 4 BYTE

TC:
80a08680
E == enabled
SRE == disabled
FCL == disabled
PS == 1K page size
IS == 0 - all bits compared from address
TIA == 8 levels A
TIB == 6 levels B
TIC == 8 levels C

TT0:
04 03 8207
E == TT0 enabled
CI == cache allowed
RW == read accesses transparent
RWM == RW used
FC BASE == function code 0
FC MASK == FC BASE ignored
%00000100
%00000011
 == $04000000 to $07FFFFFF translated

TT1:
40 3f 8107
E == TT0 enabled
CI == cache allowed
RWM == RW ignored
FC BASE == function code 0
FC MASK == FC BASE ignored
%01000000
%00111111
 == $40000000 to $7FFFFFFF translated

$683b1040|6838db5a 01000000 02000000 03000000 h8.Z............
$683b1050|04000000 05000000 06000000 07000000 ................
$683b1060|08000000 09000000 0a000000 0b000000 ................
$683b1070|0c000000 0d000000 0e000000 0f000000 ................
$683b1080|10000000 11000000 12000000 13000000 ................
$683b1090|14000000 15000000 16000000 17000000 ................
$683b10a0|18000000 19000000 1a000000 1b000000 ................
$683b10b0|1c000000 1d000000 1e000000 1f000000 ................
$683b10c0|20000000 21000000 22000000 23000000  ...!..."...#...
$683b10d0|24000000 25000000 26000000 27000000 $...%...&...'...
$683b10e0|28000000 29000000 2a000000 2b000000 (...)...*...+...
$683b10f0|2c000000 2d000000 2e000000 2f000000 ,...-......./...
$683b1100|30000000 31000000 32000000 33000000 0...1...2...3...
$683b1110|34000000 35000000 36000000 37000000 4...5...6...7...
$683b1120|38000000 39000000 3a000000 3b000000 8...9...:...;...
$683b1130|3c000000 3d000000 3e000000 3f000000 <...=...>...?...
$683b1140|40000000 41000000 42000000 43000000 @...A...B...C...
$683b1150|44000000 45000000 46000000 47000000 D...E...F...G...
$683b1160|48000000 49000000 4a000000 4b000000 H...I...J...K...
$683b1170|4c000000 4d000000 4e000000 4f000000 L...M...N...O...
$683b1180|50000000 51000000 52000000 53000000 P...Q...R...S...
$683b1190|54000000 55000000 56000000 57000000 T...U...V...W...
$683b11a0|58000000 59000000 5a000000 5b000000 X...Y...Z...[...
$683b11b0|5c000000 5d000000 5e000000 5f000000 \...]...^..._...
$683b11c0|60000000 61000000 62000000 63000000 `...a...b...c...
$683b11d0|64000000 65000000 66000000 67000000 d...e...f...g...
$683b11e0|68000019 69000000 6a000000 6b000000 h...i...j...k...
$683b11f0|6c000000 6d000000 6e000000 6f000000 l...m...n...o...
$683b1200|70000000 71000000 72000000 73000000 p...q...r...s...
$683b1210|74000000 75000000 76000000 77000000 t...u...v...w...
$683b1220|78000000 79000000 7a000000 7b000000 x...y...z...{...
$683b1230|7c000000 7d000000 7e000000 7f000000 |...}...~......
$683b1240|80000000 81000000 82000000 83000000 ................
$683b1250|84000000 85000000 86000000 87000000 ................
$683b1260|88000000 89000000 8a000000 8b000000 ................
$683b1270|8c000000 8d000000 8e000000 8f000000 ................
$683b1280|90000000 91000000 92000000 93000000 ................
$683b1290|94000000 95000000 96000000 97000000 ................
$683b12a0|98000000 99000000 9a000000 9b000000 ................
$683b12b0|9c000000 9d000000 9e000000 9f000000 ................
$683b12c0|a0000000 a1000000 a2000000 a3000000 ................
$683b12d0|a4000000 a5000000 a6000000 a7000000 ................
$683b12e0|a8000000 a9000000 aa000000 ab000000 ................
$683b12f0|ac000000 ad000000 ae000000 af000000 ................
$683b1300|b0000000 b1000000 b2000000 b3000000 ................
$683b1310|b4000000 b5000000 b6000000 b7000000 ................
$683b1320|b8000000 b9000000 ba000000 bb000000 ................
$683b1330|bc000000 bd000000 be000000 bf000000 ................
$683b1340|c0000000 c1000000 c2000000 c3000000 ................
$683b1350|c4000000 c5000000 c6000000 c7000000 ................
$683b1360|c8000000 c9000000 ca000000 cb000000 ................
$683b1370|cc000000 cd000000 ce000000 cf000000 ................
$683b1380|d0000000 d1000000 d2000000 d3000000 ................
$683b1390|d4000000 d5000000 d6000000 d7000000 ................
$683b13a0|d8000000 d9000000 da000000 db000000 ................
$683b13b0|dc000000 dd000000 de000000 df000000 ................
$683b13c0|e0000000 e1000000 e2000000 e3000000 ................
$683b13d0|e4000000 e5000000 e6000000 e7000000 ................
$683b13e0|e8000000 e9000000 ea000000 eb000000 ................
$683b13f0|ec000000 ed000000 ee000000 ef000000 ................
$683b1400|f0000000 f1000000 f2000000 f3000000 ................
$683b1410|f4000000 f5000000 f6000000 f7000000 ................
$683b1420|f8000000 f9000000 fa000000 fb000000 ................
$683b1430|fc000000 fd000000 fe000000 ff000000 ................

$683b1440|badf00d0 00000441 00000841 00000c41 .......A...A...A
$683b1450|00001041 00001441 00001841 00001c41 ...A...A...A...A
$683b1460|00002059 00002459 00002859 00002c49 .. Y..$Y..(Y..,I
$683b1470|00003041 00003441 00003841 00003c41 ..0A..4A..8A..<A


On the 030 mmu, bit zero tells if its a descriptor or a pointer to the next
level table
if bit 0 = 0 , the upper 24bit is the address of the next level table
LEt me write the detail on the lower 8 bit of each descriotor you will find
at any level (A,B,C,D)
0 = DT descriptor type)   This tell if its early terminated (not a pointer)
2 = write protect
3 = acessed
4 = modified
bit 1 is part of DT   , let me see the 030 mmu book
DT can have 4 value (bit 0-1) : 0 = invalid
1 = page descriptor
2 = valid 4 byte pointer to table
3 = valid 8byte pointer to table)
The 030 as a short and long format descriptor format....
32bit, or 64bit
Table A is 8but, Table B is 6bit, table C is 8bit, No table D


*******************************************************************************
*******************************************************************************
*******************************************************************************
*******									*******
*******	Guardian Angel Remix						*******
*******									*******
*******	Once upon a time a long long ago, there was this utility called	*******
*******	"Guardian Angel". A few had heard of it, some had seen it, but	*******
*******	none could make it work (or so the story goes). This fabled	*******
*******	program was said to protect your free memory so that you could	*******
*******	trap your nasty errors. As destiny would happen, I got a copy	*******
*******	of this program, and lo and behold, it seemed such a nice idea,	*******
*******	but the implementation left a lot to be desired: It was 68020/	*******
*******	68030 only, used 256 bytes page size, rounded all allocations 	*******
*******	up to a multiple of 256, and allocated the largest free chunk	*******
*******	of memory to be your new memory that could be alloacted from.	*******
*******	Enter the time machine and warp forwards to the year 1994 where	*******
*******	the CyberStorm060 card is released. Because Enforcer doesn't	*******
*******	work with the 68060, the utility "CyberGuard" is shipped with	*******
*******	it. Imagine the surprise when it is discovered to have a	*******
*******	"guard" option. Yes, the Guardian Angel is back in a new	*******
*******	disguise. A new implementation, but it still aims to protect	*******
*******	your free memory. And this time it works! Only oh-so-slowly.	*******
*******	It does a complete rebuild of memory access rights when		*******
*******	entering and leaving allocation related OS calls. Which is the	*******
*******	only way to go if you want to stay compatible (well, the memory	*******
*******	lists _are_ private, and _could_ of course change).		*******
*******	However, some of us (well, at least me) are willing to trade	*******
*******	compatability with solutions that works well enough to be used	*******
*******	today. This is my story of how you can depend on the OS code to	*******
*******	know what is going on, and to use two mmu tables to have a	*******
*******	protected and an unprotected side so you can get your work done	*******
*******	faster.								*******
*******									*******
*******	Going with the times I have chosen to call it			*******
*******	"Guardian Angel Remix" and here it is:				*******
*******									*******
*******************************************************************************
*******************************************************************************
*******************************************************************************

;||
;|| Credits:
;||
;|| Thanks must go to Valentin Pepelea for the original Guardin Angel program
;|| and idea.
;|| Thanks also to Ralph Schmidt for implementing the 'guard' option in
;|| CyberGuard that made me think about this again. Thanks for the piece of
;|| code I used too.
;||
;|| Note that much of the patched code is copyright Amiga Technologies.
;|| I hope I can be allowed this as fair use in an example.
;||
;|| All other code, ideas, and implementation issues are my copyright.
;|| This source and binary is allowed to be copied if no money is charged for
;|| the service, or in any other ways the receiver has to pay for it.
;|| AmiNet and Fred Fish have the permission to distribute this in their CD-ROM
;|| compilations.
;|| Commercial parties are encouraged to contact me for distribution rights.
;||
;||
;|| Børge Nøst, Storgt. 12, N-4890 Grimstad, Norway
;|| bnost@online.no
;||


;\\\\\\\\\\\\\
;\
;\  Incompatible programs found so far (using DEADLY version):
;\
;\  MungWall. This was expected and a calculated loss. Fatal. Use patch.
;\  ARTM (probably). Expected to happen when 4K aligned header is found. Non-fatal.
;\  Virus Checker 7.18. Later versions gave me Enforcer hits anyway, but this
;\  version shows major problems with memory handling.


; allocations that live in parts of a page will not give hits when freed if
; there are other alloactions in the same page.
; This can be fixed by rounding up allocation size to a multiple of the page
; size and align the allocated addresses to page boundaries, but this will
; probably cost a _lot_ of memory

	endc







	ifnd	CPU68030
		ifnd	CPU68060
			printx	"Building 68040 version.\n"
		else
			printx	"Building 68060 version.\n"
		endc
	else
		printx	"Building 68030 version.\n"
	endc

	super
	ifd	CPU68030
		MC68030
	else
		MC68040
	endc

	bopt	f+,x+,O+,wo-,OG+,OT+

	ifnd	AmiNet
		addsym
	endc

	ifd	DEADLY
		ifd	Scratch
			output	ram:GuardianAngelRemix/No_Read-Scratch/GuardianAngelRemix
		else
			output	ram:GuardianAngelRemix/No_Read/GuardianAngelRemix
		endc
	else
		ifd	Scratch
			output	ram:GuardianAngelRemix/No_Write-Scratch/GuardianAngelRemix
		else
			output	ram:GuardianAngelRemix/No_Write/GuardianAngelRemix
		endc
	endc

	ifnd	AmiNet
		output	src:tst
	else
		ifd	CPU68030
			ifeq	PatchUnLoad-1
				output	ram:GuardianAngelRemix/68851_68030/Patch_UnLoadSeg/GuardianAngelRemix
			else
				output	ram:GuardianAngelRemix/68851_68030/GuardianAngelRemix
			endc
		else
			ifeq	PatchUnLoad-1
				output	ram:GuardianAngelRemix/68040_68060/Patch_UnLoadSeg/GuardianAngelRemix
			else
				output	ram:GuardianAngelRemix/68040_68060/GuardianAngelRemix
			endc
		endc
	endc

	ifd	DEADLY
		filecom	"Guardian Angel Remix - DEADLY version. © Børge Nøst"
	else
		filecom	"Guardian Angel Remix. © Børge Nøst"
	endc

	incdir	includes:
	include	exec/exec.i
	include	offsets/exec_lib.i
	include	offsets/dos_lib.i
	include	dos/dos.i
	include	dos/dosextens.i
;	include	mmu/mmu_private_defines.i
;	include	macros:macros


UP	macro
	add.l	 #PAGESIZE-1,\1
	ifeq	NARG-2
		add.l	 #PAGESIZE-1,\2
	endc
	and.w	#~(PAGESIZE-1),\1
	ifeq	NARG-2
		and.w	#~(PAGESIZE-1),\2
	endc
	endm

DOWN	macro
	and.w	#~(PAGESIZE-1),\1
	ifeq	NARG-2
		and.w	#~(PAGESIZE-1),\2
	endc
	endm

* stuff from my macros
	ifmacrond	SYS
SYS	macro
	jsr	(_LVO\1,a6)
	endm
	endc

	ifmacrond	DOS
DOS	macro
	move.l	(DosBase,pc),a6
	jsr	(_LVO\1,a6)
	endm
	endc

	ifmacrond	EXEC
EXEC	macro
	move.l	(EXECBase,pc),a6
	jsr	(_LVO\1,a6)
	endm
	endc

	ifmacrond	SYSX
*------ LINKLIB for calling functions where A6 is incorrect:

SYSX	MACRO   ; functionOffset,libraryBase
	IFGT	NARG-2
		FAIL	"!!! LINK MACRO - too many arguments !!!"
	ENDC
	MOVE.L	A6,-(SP)
	MOVE.L	\2,A6
	JSR	_LVO\1(A6)
	MOVE.L  (SP)+,A6
	ENDM
	endc

	ifmacrond	psh
psh	macro
	movem.\0	\1,-(sp)
	endm
	endc

	ifmacrond	pll
pll	macro
	movem.\0	(sp)+,\1
	endm
	endc

	ifnd	mmu_readonly
mmu_readonly	equ	%00000100
	endc

	ifnd	COL00
COL00	equ	$dff180
* macro stuff ends
	endc

	ifd	CPU68030
PAGESIZE	equ	$400
ASIZE		equ	1024
BSIZE		equ	256
CSIZE		equ	1024
	else
PAGESIZE	equ	$1000
ASIZE		equ	512
BSIZE		equ	512
CSIZE		equ	256
	endc

GETURP	macro
	ifnd	CPU68030
		movec	TC,\1
		tst.w	\1
		bmi.b	.ok\@

		sub.l	\1,\1
		bra.b	.nogo\@
.ok\@
		move.l	\1,-(sp)
		btst.b	#6,2(sp)	; TCR bit 14
		addq.l	#4,sp
		beq.b	.ok2\@

		sub.l	\1,\1
		bra.b	.nogo\@
.ok2\@
		movec	URP,\1
.nogo\@
	else
		subq.l	#8,sp
		pmove.q	CRP,(sp)
		move.l	(sp)+,\1
		move.l	(sp)+,\2
	endc					; -1
	endm

FlushDataAddress	macro		; register indirect
	ifne	NARG-1
		fail
	endc

	ifnd	CPU68030
		cpushl	DC,(\1)

	else
		move.l	d0,-(sp)
		movec	cacr,d0
		or.w	#CACRF_ClearD,d0
		movec	d0,cacr
		move.l	(sp)+,d0
	endc
	endm

ATCFlushaAddress	macro
	ifd	CPU68030
		ifnd	dummy
			pflusha
		endc
;/\/\/\/\/\
	else
		ifnd	dummy
			pflush	(\1)		; flush selected atc entry
		endc
	endc
	endm

	ifeq	1

There are two ways (as I see it) to implement a 'Guardian Angel' feature:
When a de/allocation happens the following is done
1.
 - halt all other allocations (Forbid())
 - unprotect all memory
 - call OS function to de/allocate
 - protect all free memory (de/allocation has changed status of memory lists)
 - restart other allocations (Permit())


2.
 - halt other allocations (Forbid())
 - call your own shadow memory management functions to find out where the OS
   will do the de/alloc
 - unprotect memory that will be returned, and memory that has pointers etc that
   needs to be updated
 - update pointers etc exactly the same way the OS does
 - reprotect the pages where updates were done, with the possible exception of
   the page where memory was allocated
 - restart other allocations (Permit())


Option 1 is slow by default. Not much to do about it, but it is relatively
easy and clean to implement. It is also slow (did I mention that it is slow?).

Option 2 has potential to be faster, but it needs more fancy interaction with
the OS. Depending on how much memory you are willing to spend it can be slow.


Without having tested I can envision another solution, but this might break
programs that peek the memory lists on their own. I'd say it is solution 1
with the idea of solution 2 applied:
 - halt all other allocations (Forbid())
 - unprotect all memory by doing
   - change MMU table to one that is equal to the current one, but where no free
     memory is protected
 - call OS function to de/allocate
 - protect all free memory (de/allocation has changed status of memory lists) by
   doing
   - un/protect memory where de/allocation was done (in the MMU table that protects
     free memory). Needs to check if whole pages have become free/allocated
   - change MMU table to the original where free memory is protected
 - restart other allocations (Permit())

	endc




	section	MegaHack,code


**							**
**	Allocate memory, copy code, install hacks	**
**							**

CodeStart
	lea	(ExitSP,pc),a0
	move.l	sp,(a0)				; exit stack
	move.l	4.w,a6
	lea	(EXECBase,pc),a0
	move.l	a6,(a0)

	moveq	#5,d7
	lea	(MungName,pc),a1		; shit happens with Mungwall around
	SYS	FindPort
	tst.l	d0
	bne	ExitAngel

	bsr	FunctionCheck			; patched functions are uncool

	lea	(DosName,pc),a1
	SYS	FindResident
	lea	(DosStart,pc),a0
	move.l	d0,(a0)				; check if started from kicktags
	beq	ExitAngel

	move.l	d0,a1
	lea	(DosEnd,pc),a0
	move.l	(RT_ENDSKIP,a1),(a0)

	ifnd	MakeGAR
						; patch code for end of chipmem
		move.l	(MaxLocMem,a6),CodeStart+CODE_MODIFY+2
		move.l	(MaxLocMem,a6),CodeStart+CODE_MODIFY2+2
	endc

	moveq	#4,d7
	cmp.w	#39,(LIB_VERSION,a6)		; only 3.0 or 3.1
	blo.b	ExitAngel

	moveq	#1,d7
	ifd	CPU68030
		btst.b	#AFB_68020,AttnFlags+1(a6)
	else
		btst.b	#AFB_68040,AttnFlags+1(a6)
	endc
	beq.b	ExitAngel			; check correct cpu

	ifd	CPU68030
		ifnd	ENFORCER
						; test hack for 030 check only
			btst.b	#AFB_68040,AttnFlags+1(a6)
			bne.b	ExitAngel
		endc
	endc

	sub.l	a1,a1
	jsr	_LVOFindTask(a6)

	move.l	d0,a4
	tst.l	pr_CLI(a4)	; was it called from CLI?
	bne.b	.fromCLI	; if so, skip out this bit...

	lea	pr_MsgPort(a4),a0
	jsr	_LVOWaitPort(A6)
	lea	pr_MsgPort(a4),a0
	jsr	_LVOGetMsg(A6)
	lea	(returnMsg,pc),a0
	move.l	d0,(a0)

.fromCLI

	ifd	CPU68060
		lea	(_MMU060,pc),a0
		clr.l	(a0)
		btst.b	#AFB_68060,AttnFlags+1(a6)
		sne	(a0)
	endc

	move.l	#End-Start,d0
	move.l	#MEMF_CLEAR|MEMF_PUBLIC|MEMF_REVERSE,d1
	SYS	AllocMem
	tst.l	d0
	bne.b	AllocOK

	moveq	#3,d7

ExitAngel
	move.l	(ExitSP,pc),sp
	move.l	(AllocAddress,pc),d0
	beq.b	.no_code_to_free

	move.l	d0,a1
	move.l	#End-Start,d0
	SYS	FreeMem

.no_code_to_free
	bsr.b	WB_Exit

	moveq	#0,d0
	ifd	CPU68030
		lea	(Needs020,pc),a2
	else
		lea	(Needs040,pc),a2
	endc
	cmp.l	#1,d7
	beq.b	.info

	lea	(MMUproblem,pc),a2
	cmp.l	#2,d7
	beq.b	.info

	lea	(Allocproblem,pc),a2
	cmp.l	#3,d7
	beq.b	.info

	lea	(BadExec,pc),a2
	cmp.l	#4,d7
	beq.b	.info

	lea	(MungFound,pc),a2
	cmp.l	#5,d7
	beq.b	.info

	lea	(PatchDetected,pc),a2
	cmp.l	#6,d7
	bne.b	.out

.info
	bsr.b	UserFeedback
	moveq	#20,d0
	or.l	d7,d0				; feedback on what error
.out
	rts

UserFeedback

	ifnd	MakeGAR
		moveq	#0,d6
		tst.l	(DosBase,pc)
		bne.b	.ok

		moveq	#-1,d6
		lea	(DosName),a1
		moveq	#0,d0
		EXEC	OpenLibrary
		lea	(DosBase,pc),a0
		move.l	d0,(a0)
		beq	.window_done

.ok
	endc

	lea	(windowname,pc),a0
	move.l	a0,d1
	move.l	#MODE_NEWFILE,d2
	DOS	Open
	move.l	d0,d4
	beq.b	.window_done

	move.l	d4,d1
	move.l	a2,d2
	move.l	a2,a0
.loop	tst.b	(a0)+
	bne.b	.loop

	sub.l	a2,a0
	move.l	a0,d3

	SYS	Write

	move.l	d4,d1
	SYS	Close

	ifnd	MakeGAR
		tst.l	d6
		beq.b	.window_done

		move.l	a6,a1
		EXEC	CloseLibrary
	endc

.window_done

	rts

FunctionCheck
	move.l	(LIB_IDSTRING,a6),d2
	and.l	#~($80000-1),d2			; 512K mask
	moveq	#6,d7
	lea	(FuncTab,pc),a0
	move.w	(a0)+,d0
.next
	move.l	(2,a6,d0.w),d1			; function address
	and.l	#$fff80000,d1
	cmp.l	d2,d1
	bne	ExitAngel

	move.w	(a0)+,d0
	bne	.next

	rts

FuncTab	dc.w	_LVOFreeMem
	dc.w	_LVOAllocAbs
	dc.w	_LVOAllocMem
;	dc.w	_LVORemTask
	dc.w	0

MungName	dc.b	"Mungwall",0
windowname	dc.b	"CON:000/000/640/100/Error information/AUTO/CLOSE/WAIT/SMART",0
	ifd	CPU68030
Needs020	dc.b	"This program only works on a 68020 with 68851, or 68030 with MMU.",0
	else
Needs040	dc.b	"This program only works on a 68040 or 68060.",0
	endc
	ifd	CPU68030
MMUproblem	dc.b	"MMU is not in use. Please run Enforcer.",0
	else
MMUproblem	dc.b	"MMU is not in use. Please run SetPatch and CyberGuard/Enforcer.",0
	endc
Allocproblem	dc.b	"Could not allocate required memory.",0
BadExec		dc.b	"Needs Exec version 39 or higher.",0
MungFound	dc.b	"Mungwall detected!",13,10
		dc.b	"Please terminate Mungwall. "
		dc.b	"Mungwall can be started again after I have",10
		dc.b	"successfully installed my patches.",0
PatchDetected	dc.b	"Sorry, but some Exec function has already been patched.",10
		dc.b	"Since this could lead to a system crash when I patch the",10
		dc.b	"same function I will not continue.",10
		dc.b	"(This means AllocMem/FreeMem/AllocAbs has been patched.)",10
	dc.b	"Please start me before any other program that installs such patches",10,0

	cnop	0,4
	dcb.b	8,0
RomTag
	DC.W	RTC_MATCHWORD		; UWORD RT_MATCHWORD
	DC.L	RomTag-RomTag		; APTR	RT_MATCHTAG
	DC.L	End-RomTag		; APTR	RT_ENDSKIP
	DC.B	RTF_COLDSTART		; UBYTE RT_FLAGS
	DC.B	0			; UBYTE RT_VERSION (defined in sample_rev.i)
	DC.B	NT_UNKNOWN		; UBYTE RT_TYPE
	DC.B	104			; BYTE	RT_PRI - after exec.library
	DC.L	MyName-RomTag		; APTR	RT_NAME
	DC.L	IDString-RomTag		; APTR	RT_IDSTRING
	DC.L	CodeStart-RomTag	; APTR	RT_INIT	table for InitResident()

MyName
	dc.b	"Guardian Angel Remix",0
	even
IDString
	dc.b	0,'$VER: '
	dc.b	"Guardian Angel Remix 1.1 "
	ifd	CPU68030
		dc.b	"68020+68851 / 68030 version."
	else
		ifd	CPU68040
			dc.b	"68040 version."
		else
			dc.b	"68060 / 68040 version."
		endc
	endc
	dc.b	" By bnost@online.no."
	dc.b	" Børge Nøst, Storgt. 12, N-4890 Grimstad, NORWAY."
	dc.b	"Assembly date: "
	dstring	w,d,t
	dc.b	13,10,0
	cnop	0,4

AllocOK
	lea	(AllocAddress,pc),a0
	move.l	d0,(a0)

	move.l	d0,a4
; if illegal descriptors are indirect save the indirect descriptor they use
; assumes address $80000000 is not a legal address!
	bsr	GetURP
	moveq	#2,d7				; set error
	ifd	CPU68030
		moveq	#~$f,d2
		and.l	d1,d2
	else
		tst.l	d0
	endc
	beq.b	ExitAngel

	lea	(ProtectedURP,pc),a0
	move.l	d0,(a0)
	ifd	CPU68030
		move.l	d1,(4,a0)
		lea	(FreeURP,pc),a0
		move.l	d0,(a0)
		move.l	d1,d0
	endc

	ifnd	CPU68030
		add.l	#$100,d0	; add.l #$80000000 (BSIZE*SIZE*PAGESIZE)
	endc

	move.l	d0,a0
	move.l	(a0),d0
	lea	(BadLevelA,pc),a1
	move.l	d0,(a1)

	ifd	CPU68030
		and.b	#~$f,d0
	else
		and.w	#~$1ff,d0
	endc
	move.l	d0,a0
	move.l	(a0),d0
	lea	(BadLevelB,pc),a1
	move.l	d0,(a1)

	ifd	CPU68030
		and.b	#~$f,d0
	else
		clr.b	d0
	endc

	move.l	d0,a0
	move.l	(a0),d0
	moveq	#%11,d1
	and.l	d0,d1
	cmp.b	#%10,d1		; indirect

	ifnd	CPU68030
		bne.b	.ok_ill
	else
;;;; 68030 uses ExecBase descriptor ;;;;
*		beq.b	.get_real_descriptor
		beq.b	.set_descriptor

		moveq	#%10,d0	; indirect descriptor pointing to
		add.l	a0,d0	; the descriptor for page 0
*		bra.b	.set_descriptor

*.get_real_descriptor
*		eor.l	d1,d0	; indirect - remove bits not in indirect address
*		move.l	d0,d0	; new
.set_descriptor
	endc

	lea	(_EnforcerHack,pc),a0
	move.l	d0,(a0)
.ok_ill

; 1. Calc mmu table size
; 2. Alloc mmu table
; 3. Clone mmu table
	ifd	CPU68030
		lea	(ProtectedURP,pc),a5
	else
		move.l	(ProtectedURP,pc),a5
	endc
	bsr	CalcSize

	lea	(MMU_TableSize,pc),a0
	move.l	d2,(a0)

	move.l	#MEMF_CLEAR|MEMF_PUBLIC|MEMF_REVERSE,d1
	move.l	d2,d0
	bsr	AllocMemAligned4K

	lea	(MMU_AllocSize,pc),a0
	move.l	d1,(a0)
	lea	(MMU_Alloc,pc),a0
	moveq	#3,d7
	move.l	d0,(a0)
	beq	ExitAngel

	lea	(RomTag,pc),a0
	move.l	a0,(2,a0)
	move.l	a0,d7
	add.l	d7,(6,a0)
	add.l	d7,(14,a0)
	add.l	d7,(18,a0)
	add.l	d7,(22,a0)

	ifd	CPU68030
		lea	(_Adr1024,pc),a0
		move.l	d0,(a0)
		add.l	#1024,(a0)
		lea	(_Adr256,pc),a0
;/\/\/\/
	else
		lea	(_Adr256,pc),a0
		move.l	d0,(a0)
		add.l	#512,(a0)		; pre-alloc root
		lea	(_Adr512,pc),a0
	endc
	add.l	d0,d1
	move.l	d1,(a0)

	bsr	Clone

	ifd	CPU68060
		printx	"060 can't use copyback for descriptors\n"
		move.l	(MMU_Alloc,pc),d0
		move.l	(MMU_AllocSize,pc),d1
		add.l	d0,d1
		move.l	(ProtectedURP,pc),a0
		bsr	SetNocache

		move.l	(MMU_Alloc,pc),d0
		move.l	(MMU_AllocSize,pc),d1
		add.l	d0,d1
		move.l	(FreeURP,pc),a0
		bsr	SetNocache
	endc

	SYS	CacheClearU
	bsr	FlushMMU

	moveq	#0,d0
	lea	(DosName,pc),a1
	SYS	OpenLibrary
	lea	(DosBase,pc),a0
	move.l	d0,(a0)
	beq.b	.sorry

; copy patch to allocated memory
	move.l	(AllocAddress,pc),d0
	lea	(Start,pc),a0
	move.l	d0,a1
	lea	(End,pc),a2
.cl	move.w	(a0)+,(a1)+
	cmp.l	a2,a0
	bne.b	.cl

	move.l	d0,a2

	SYS	CacheClearU

	SYS	Disable

	ifd	ENFORCER
		bsr	ProtectFreeMemory
		move.l	#$1000,d0
		moveq	#0,d1
		bsr	exec_AllocMem
		move.l	d0,a1
		move.l	#$1000,d0
		bsr	exec_FreeMem
		move.l	#$1000,d0
		moveq	#MEMF_CHIP,d1
		bsr	exec_AllocMem
		move.l	d0,a1
		move.l	#$1000,d0
		bsr	exec_FreeMem
		rts
	endc		

	bsr	PatchFunctions

	move.l	(TaskExitCode,A6),(OldTaskExitCode-Start,a2)

	lea	(ExitCode-Start,a2),a0
	move.l	a0,(TaskExitCode,A6)

	bsr	ProtectFreeMemory

	SYS	Enable

	move.l	(DosBase,pc),a1
	SYS	CloseLibrary

 IFEQ 1
	move.l	#2*PAGESIZE,d0
	move.l	d0,d2
	move.l	#MEMF_CHIP,d1
	SYS	AllocMem
	move.l	d0,d3
	beq.b	.sorry

	cmp.l	#$40000,d0
	bhs.b	.flash

	add.l	#PAGESIZE,d0
	and.l	#~(PAGESIZE-1),d0
	move.l	d0,d1
	move.l	d0,a2
	add.l	#PAGESIZE,d1
	move.l	d1,a3
	bsr	SetIllegal

	move.l	(a2),d0
	move.b	($a110c0cc),d0
	move.l	a2,d0
	move.l	a3,d1
	bsr	SetReadWrite
.free
	move.l	d3,a1
	move.l	d2,d0
	SYS	FreeMem

 ENDC


.sorry
	bsr	WB_Exit
	moveq	#0,d0
	rts

 IFEQ 1
.flash
	move.b	($bada110c),d0
	bra.b	.free
 ENDC



PatchFunctions
	move.l	a3,-(sp)
 IFEQ 0
	lea	(.PatchTable,pc),a3
.loop
	move.l	a6,a1
	move.w	(a3)+,a0
	move.l	(a3)+,d0
	add.l	a2,d0
	SYS	SetFunction
	move.w	(a3)+,d1
	move.l	d0,(a2,d1.w)
	tst.w	(a3)
	bne	.loop

 ELSE
; patch FreeMem
	move.l	a6,a1
	move.w	#_LVOFreeMem,a0
	move.l	#exec_FreeMem-Start,d0
	add.l	a2,d0
	SYS	SetFunction
	move.l	d0,(OldFreeMem-Start,a2)

; patch AllocAbs
	move.l	a6,a1
	move.w	#_LVOAllocAbs,a0
	move.l	#exec_AllocAbs-Start,d0
	add.l	a2,d0
	SYS	SetFunction
	move.l	d0,(OldAllocAbs-Start,a2)

; patch AllocMem
	move.l	a6,a1
	move.w	#_LVOAllocMem,a0
	move.l	#exec_AllocMem-Start,d0
	add.l	a2,d0
	SYS	SetFunction
	move.l	d0,(OldAllocMem-Start,a2)

; patch AvailMem
	move.l	a6,a1
	move.w	#_LVOAvailMem,a0
	move.l	#exec_AvailMem-Start,d0
	add.l	a2,d0
	SYS	SetFunction
	move.l	d0,(OldAvailMem-Start,a2)

; patch RemTask
	move.l	a6,a1
	move.w	#_LVORemTask,a0
	move.l	#exec_RemTask-Start,d0
	add.l	a2,d0
	SYS	SetFunction
	move.l	d0,(OldRemTask-Start,a2)

; patch RemLibrary
	move.l	a6,a1
	move.w	#_LVORemLibrary,a0
	move.l	#exec_RemLibrary-Start,d0
	add.l	a2,d0
	SYS	SetFunction
	move.l	d0,(OldRemLibrary-Start,a2)

; patch RemDevice
	move.l	a6,a1
	move.w	#_LVORemDevice,a0
	move.l	#exec_RemDevice-Start,d0
	add.l	a2,d0
	SYS	SetFunction
	move.l	d0,(OldRemDevice-Start,a2)
 ENDC

	ifeq	PatchUnLoad-1
		printx	"Patching UnLoadSeg\n"
; patch UnLoadSeg
		move.l	(DosBase,pc),a1
		move.w	#_LVOUnLoadSeg,a0
		move.l	#exec_UnLoadSeg-Start,d0
		add.l	a2,d0
		SYS	SetFunction
		move.l	d0,(OldUnLoadSeg-Start,a2)

; patch InternalUnLoadSeg
		move.l	(DosBase,pc),a1
		move.w	#_LVOInternalUnLoadSeg,a0
		move.l	#exec_InternalUnLoadSeg-Start,d0
		add.l	a2,d0
		SYS	SetFunction
		move.l	d0,(OldInternalUnLoadSeg-Start,a2)
	endc

	ifeq	1
; patch Allocate
		move.l	a6,a1
		move.w	#_LVOAllocate,a0
		move.l	#HackAllocate-Start,d0
		add.l	a2,d0
		SYS	SetFunction
		move.l	d0,(olda-Start,a2)
	endc

	move.l	(sp)+,a3
	rts
PatchData	macro
	dc.w	_LVO\1
	dc.l	exec_\1-Start
	dc.w	Old\1-Start
	endm
.PatchTable
	PatchData	FreeMem
	PatchData	AllocAbs
	PatchData	AllocMem
	PatchData	AvailMem
	PatchData	RemTask
	PatchData	RemLibrary
	PatchData	RemDevice
	PatchData	TypeOfMem

	dc.w	0


WB_Exit
	move.l	(returnMsg,pc),d0	; Is there a message?
	beq.b	.exitToDOS		; if not, skip...

        jsr	_LVOForbid(a6)          ; note! No Permit needed!
	move.l	d0,a1
	jsr	_LVOReplyMsg(a6)
	jsr	_LVOPermit(a6)

.exitToDOS
	rts


AllocAddress	dc.l	0
returnMsg	dc.l	0

Start
;olda	dc.l	0
OldAvailMem	dc.l	0
OldAllocMem	dc.l	0
OldRemTask	dc.l	0
OldFreeMem	dc.l	0
OldAllocAbs	dc.l	0
OldTaskExitCode	dc.l	0
OldRemLibrary	dc.l	0
OldRemDevice	dc.l	0
OldTypeOfMem	dc.l	0

	ifeq	PatchUnLoad-1
OldUnLoadSeg	dc.l	0
OldInternalUnLoadSeg	dc.l	0
	endc

MMU_TableSize	dc.l	0
MMU_AllocSize	dc.l	0
FreeURP
	ifd	CPU68030
		dc.l	80000002
FreeURP_low
	endc
MMU_Alloc	dc.l	0
	ifd	CPU68030
_Adr1024	dc.l	0
_Adr256		dc.l	0
	else
_Adr256		dc.l	0
_Adr512		dc.l	0
	endc
BadLevelA	dc.l	0
BadLevelB	dc.l	0
ProtectedURP
	ifd	CPU68030
		dc.l	80000002
ProtectedURP_low
	endc
		dc.l	0

_EnforcerHack	dc.l	0
	ifd	CPU68060
_MMU060		dc.l	0
	endc
EXECBase	dc.l	0
DosBase		dc.l	0
ExitSP		dc.l	0
DosName		dc.b	"dos.library",0
	cnop	0,4
;_RememberFreeMem	dc.l	0
;BugBag		dc.l	0


UseFreeURP
	move.l	a5,-(sp)
	lea	(.GetSetURP,pc),a5
	SYS	Supervisor
	move.l	(sp)+,a5
	rts
.GetSetURP
	ifd	CPU68030
		exg.l	d0,a0
		ifnd	ENFORCER
			pmove.q	CRP,(a0)
		else
			move.l	CRP_030,(a0)
			move.l	CRP_030+4,(4,a0)
		endc
		move.l	(4,a0),a5
		cmp.l	(FreeURP_low,pc),a5
		beq.b	.OkURP

		ifnd	dummy
			lea	(FreeURP,pc),a5		; get the free URP
			pmove.q	(a5),CRP		; change URP
		else
			ifd	ENFORCER
				lea	(FreeURP,pc),a5		; get the free URP
				move.l	(a5),CRP_030		; change URP
				move.l	(4,a5),CRP_030+4
			endc
		endc	;

		ifnd	dummy
			pflusha
		endc
.OkURP
		exg.l	d0,a0
		rte

;/\/\/\/\/\
	else
		move.l	(FreeURP,pc),a5		; get the free URP
		movec	URP,d0			; URP in use

		cmp.l	a5,d0
		beq.b	.OkURP

		ifnd	dummy
			movec	a5,URP			; change URP
		endc	;

		ifnd	dummy
			pflusha
		endc
.OkURP
		rte
	endc	;

UseNewURP
	move.l	a5,-(sp)
	lea	(.NewURP,pc),a5
	SYS	Supervisor
	move.l	(sp)+,a5
	rts
.NewURP
	ifd	CPU68030
		subq.l	#8,sp
		ifnd	ENFORCER
			pmove.q	CRP,(sp)
		else
			move.l	CRP_030,(sp)
			move.l	CRP_030+4,(4,sp)
		endc
		move.l	(4,sp),a5
		cmp.l	(4,a0),a5
		addq.l	#8,sp
		beq.b	OkURP2

		ifnd	dummy
			pmove.q	(a0),CRP
		else
			ifd	ENFORCER
				move.l	(a5),CRP_030		; change URP
				move.l	(4,a5),CRP_030+4
			endc
		endc	;

;/\/\/\/\/\/\
	else
		movec	URP,a5			; URP in use
		cmp.l	a0,a5
		beq.b	OkURP2

		ifnd	dummy
			movec	a0,URP			; change URP
		endc	;
	endc	;


_FlushMMU
	ifnd	dummy
		pflusha
	endc
OkURP2
	rte

FlushMMU
	ifnd	ENFORCER
		move.l	a5,-(sp)
		lea	(_FlushMMU,pc),a5
		SYS	Supervisor
		move.l	(sp)+,a5
	endc
	rts
GetURP
	ifd	ENFORCER
		move.l	CRP_030,d0
		move.l	CRP_030+4,d1
		rts
	endc

	psh.l	a0/a1/a5
	lea	(.super,pc),a5
	SYS	Supervisor
	pll.l	a0/a1/a5
	rts
.super
	ifd	CPU68030
		GETURP	d0,d1
	else
		GETURP	d0
	endc
	rte


*******************************************************************************
*******************************************************************************
*******************************************************************************
	ifeq	1		; no point, this _is_ legal on private memory
HackAllocate
		move.w	d0,COL00
		tst.b	$A110CADE
		move.l	(olda,pc),-(sp)
		rts
	endc	;



*******************************************************************************
*******************************************************************************
*******************************************************************************
ProtectFreeMemory
	psh.l	d2-d7/a2-a6

	SYS	Forbid
	LEA	(MemList,A6),A3

*	ifd	CPU68030
*		move.l	(ProtectedURP_low,pc),a5
*		lea	(A_Shadow,pc),a0
*		move.w	#(ASIZE/4)-1,d0
*.acl		move.l	(a5)+,(a0)+
*		dbra	d0,.acl
*	endc

; loop over all ram address ranges
.global_loop
	SUCC	a3,a3
	TST.L	(LN_SUCC,A3)
	beq	.done

	move.l	(MH_FIRST,A3),A2	; first free in memory header list

	ifd	CPU68030
		SYS	CacheClearU
;		cmp.l	#$00040000,a2
;		bhs.b	.global_loop

		move.l	(MH_LOWER,a3),d6
		move.l	(MH_UPPER,a3),d7
		clr.w	d6
		clr.w	d7
.CheckEarlyTerminators
		lea	(ProtectedURP,pc),a0
		move.l	d6,d0
		bsr	FindDescriptorCheck
		beq.b	.AllocLevelB
.CheckLevelC
		subq.l	#1,d0
		beq.b	.AllocLevelC

		add.l	#PAGESIZE,d6
		cmp.l	d6,d7
		bhi.b	.CheckEarlyTerminators
	endc

; loop over all free memory chunks in this list
.chunk_loop
	move.l	a2,d0
	beq	.global_loop

; a2 free chunk node
	UP	d0
	move.l	(MC_BYTES,a2),d1
	add.l	a2,d1			; end+1 of this free chunk
	DOWN	d1
	cmp.l	d0,d1
	bls	.next_chunk		; any whole pages in between?

; protect memory starting from d0 up to (but not including) d1
	move.l	(MC_NEXT,a2),a2
	bsr	SetIllegal
	bra	.chunk_loop

.next_chunk
	move.l	(MC_NEXT,a2),a2
	bra	.chunk_loop

; flush mmu table to be sure changes are used
.done
	bsr	FlushMMU
	SYS	Permit

	ifd	CPU68030
		SYS	CacheClearU
	endc

	pll.l	d2-d7/a2-a6
	rts
	ifd	CPU68030
.AllocLevelB
*	lea	(A_Shadow,pc),a4
*	sub.l	(ProtectedURP_low,pc),a4
	move.l	a0,a4
*	add.l	a0,a4

	move.l	#BSIZE,d0
	move.l	#MEMF_FAST|MEMF_PUBLIC|MEMF_REVERSE,d1
	bsr	AllocMemAligned256
	tst.l	d0
	beq	ExitAngel

	move.l	d0,a0
	move.l	(a4),d5			; get early terminator in A
	moveq	#%1100,d1		; U/M
	and.l	d5,d1			;
	add.l	#%10,d1			; valid  short DT
	add.l	d0,d1			; make full new descriptor

	moveq	#(BSIZE/4)-1,d2
	move.l	d5,d0			; early termination
.bl	move.l	d0,(a0)+
	add.l	#(CSIZE/4)*PAGESIZE,d0
	dbra	d2,.bl

;	move.l	d1,(a4)			; store new level A descriptor
	bra	.CheckEarlyTerminators

.AllocLevelC
	move.l	a0,a4
	move.l	#CSIZE,d0
	move.l	#MEMF_FAST|MEMF_PUBLIC|MEMF_REVERSE,d1
	bsr	AllocMemAligned256
	tst.l	d0
	beq	ExitAngel

	move.l	d0,a0
	move.l	(a4),d5			; get early terminator in A
	moveq	#%1100,d1		; U/M
	and.l	d5,d1			;
	add.l	#%10,d1			; valid  short DT
	add.l	d0,d1			; make full new descriptor

	move.w	#(CSIZE/4)-1,d2
;	move.b	d5,d0			; early termination
	move.l	d5,d0
	move.b	#%00000001,d0		; DT = page descriptor
	cmp.l	(MaxLocMem,a6),d0
	bhs.b	.nochip

	or.b	#%01000000,d0		; no cache of chipmem
.nochip
.cl	move.l	d0,(a0)+
	add.l	#PAGESIZE,d0
	dbra	d2,.cl

	move.l	d1,(a4)			; store new descriptor
	bra	.CheckEarlyTerminators

	endc


*******************************************************************************
*******************************************************************************
*******************************************************************************
UnprotectFreeMemory
	SYS	Forbid
	LEA	(MemList,A6),A3

; loop over all ram address ranges
.global_loop
	SUCC	a3,a3
	TST.L	(LN_SUCC,A3)
	beq	.done

	move.l	(MH_LOWER,A3),d0	; first free in memory header list
;	ifd	CPU68030
;		cmp.l	#$01000000,d0
;		bhs.b	.global_loop
;	endc
	move.l	(MH_UPPER,A3),d1	; first free in memory header list
	move.l	(MH_ATTRIBUTES,a3),d4

	UP	d0
	DOWN	d1

; unprotect memory starting from d0 up to (but not including) d1
	bsr	SetReadWrite
	bra	.global_loop

; flush mmu table to be sure changes are used
.done
	bsr	FlushMMU
	SYS	Permit
	rts




*******************************************************************************
*******************************************************************************
*******************************************************************************
exec_DeAllocate
;memHeader, memoryBlock, byteSize
;a0         a1           d0
	MOVEM.L	D3/A2,-(SP)
	MOVE.L	A1,D1
	MOVEQ	#-8,D3
	AND.L	D3,D1			;align on 8
	EXG	D1,A1			; a1 = DOWN 8
	SUB.L	A1,D1			;address diff
	ADD.L	D1,D0			; up size
	ADDQ.L	#7,D0
	AND.L	D3,D0			; up size on 8 multiple
	BEQ.B	lbC001D18		; check malformed

	move.l	a1,d4		; start free addr
	move.l	d0,d5		; free size
	move.l	a1,d6
	add.l	d4,d5		; end free addr
	move.l	d5,d7
	LEA	(MH_FIRST,A0),A2	; first free in memory header list
	MOVE.L	(MC_NEXT,A2),D3		; real first free
	BEQ.B	lbC001CE8
.lbC001CC6
	CMPA.L	D3,A1			; before this chunk?
	BLS.B	.lbC001CD2

	MOVEA.L	D3,A2
	MOVE.L	(MC_NEXT,A2),D3		; get this->next
	BNE.B	.lbC001CC6

	BRA.B	.lbC001CD4

.lbC001CD2
	BEQ.B	ChunkListedTwice
.lbC001CD4
; a1 = new free chunk
; a2 = previous chunk
	MOVEQ	#$10,D1
	ADD.L	A0,D1
	CMP.L	A2,D1			; test first chunk?
	BEQ.B	lbC001CE8

	MOVE.L	(MC_BYTES,A2),D3
	ADD.L	A2,D3			; end prev chunk
	CMP.L	A1,D3			; prev and this continous?
	BEQ.B	JoinPrev

; end of prev higher than this is an error!
	BHI.B	MemoryFreeTwice
lbC001CE8
; link new->next to prev->next
	MOVE.L	(MC_NEXT,A2),(MC_NEXT,A1)
	MOVE.L	A1,(MC_NEXT,A2)		; prev->next = this
	MOVE.L	D0,(MC_BYTES,A1)
	BRA.B	lbC001CF8

JoinPrev
	ADD.L	D0,(MC_BYTES,A2)	; just enlarge prev
	move.l	a2,d4
	MOVEA.L	A2,A1			; this is our new chunk
lbC001CF8
	TST.L	(MC_NEXT,A1)		; test last chunk
	BEQ.B	lbC001D14

	MOVE.L	(MC_BYTES,A1),D3
	ADD.L	A1,D3			; end this chunk
	CMP.L	(MC_NEXT,A1),D3
	BHI.B	MemoryFreeTwice

	BNE.B	lbC001D14

* join new and next chunk
;;	MOVEA.L	(MC_NEXT,A1),A2		; removed for optimisation
;- value already known
	move.l	d3,a2
; this->next = next->next
;	MOVE.L	(MC_NEXT,A2),(MC_NEXT,A1)
;	MOVE.L	(MC_BYTES,A2),D3
;	ADD.L	D3,(MC_BYTES,A1)	; enlarge this chunk
	MOVE.L	(A2)+,(A1)+
	MOVE.L	(A2),D3
	ADD.L	D3,(A1)			; enlarge this chunk
	add.l	d3,d5			; new end
lbC001D14
	ADD.L	D0,(MH_FREE,A0)		; total free size up
lbC001D18
	MOVEM.L	(SP)+,D3/A2
	RTS

ChunkListedTwice
	MOVE.L	#$01000009,D7
	bra.b	Do_Alert

MemoryFreeTwice
	MOVE.L	#$01000005,D7
Do_Alert
	MOVEM.L	(SP)+,D3/A2
;;	MOVEA.L	(4).W,A6	; removed - assumed known, at least when direct
; ROM calling can be ruled out
	moveq	#0,d4
	moveq	#0,d5

	JSR	(_LVOAlert,A6)

	rts

	ifeq	1
;exec_FreeVec
		MOVE.L	A1,D1
		BEQ	_rts

		MOVE.L	-(A1),D0
		JMP	(_LVOFreeMem,A6)

	endc	;



*******************************************************************************
*******************************************************************************
*******************************************************************************
	cnop	0,16
exec_FreeMem
	MOVE.L	A1,D1
	BEQ	_rts

	SYS	Forbid

	move.l	d0,d1

	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc	;

	bsr	UseFreeURP

	ifnd	CPU68030
		move.l	d0,-(sp)	; save current URP
	endc	;

	move.l	d1,d0

.no_change
	LEA	(MemList,A6),A0
lbC001D56
	MOVEA.L	(LN_SUCC,A0),A0
	TST.L	(MH,A0)
	BEQ.B	_exec_Permit4

	CMPA.L	(MH_LOWER,A0),A1
	BLO.B	lbC001D56

	CMPA.L	(MH_UPPER,A0),A1
	BHS.B	lbC001D56

	psh.l	d4/d5/d6/d7
	BSR.W	exec_DeAllocate

	tst.l	d5			; d4=0 if error
	beq	.noprotect

; d0 = start, d1 = end
; d4 = start free addr
; d5 = end free addr
	UP	d6,d4
;	UP	d4
	cmp.l	d6,d4
	beq	.okstart

; chunks have been merged - start protection earlier to fix up prev chunk
	sub.l	#PAGESIZE,d6
.okstart
*BONK
;	DOWN	d7
;	DOWN	d5
	DOWN	d7,d5
	cmp.l	d7,d5
	beq	.okend

; chunks have been merged - end protection later to fix up next chunk
	add.l	#PAGESIZE,d7
.okend
;	cmp.l	d6,d7
;	bls	.noprotect		; branch if no whole pages have been freed

	move.l	d6,d4
	move.l	d7,d5

	bra.b	.check

.protect
	move.l	d4,d0
	ifd	CPU68030
		lea	(ProtectedURP,pc),a0
	else
		move.l	(ProtectedURP,pc),a0
	endc
	bsr	FindDescriptor		; internal

	ifd	CPU68030
		beq.b	.next
	endc

	tst.l	(_EnforcerHack,pc)
	bne.b	.special

	move.l	#mmu_readonly,d0
	or.l	(a0),d0

	ifd	DEADLY
		and.b	#~%11,d0
	endc	;

	bra.b	.ok

.special
	ifd	DEADLY
		move.l	(_EnforcerHack,pc),d0
;---------------
	else
		move.l	#mmu_readonly,d0
		or.l	(a0),d0
	endc	;

.ok
	ifnd	dummy
		move.l	d0,(a0)
	else
		ifd	ENFORCER
			move.l	d0,(a0)
		endc
	endc	;

.next
	add.l	#PAGESIZE,d4
.check	cmp.l	d4,d5
	bhi.b	.protect

.noprotect
	pll.l	d4/d5/d6/d7

	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc	;

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc	;

	SYS	Permit
	ifd	Scratch
		move.l	#$badfebad,d1
		move.l	#$badfebad,a0
		move.l	d1,a1
		move.l	a0,d0
	endc	;
; exit FreeMem
_rts
	rts

_exec_Permit4
	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc	;

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc	;

	SYS	Permit

	MOVE.L	D7,-(SP)
	MOVE.L	#$0100000F,D7
	JSR	(_LVOAlert,A6)
	MOVE.L	(SP)+,D7

	ifd	Scratch
		move.l	#$badffbad,d1
		move.l	d1,a0
		move.l	d1,a1
		move.l	a0,d0
	endc	;
	RTS




*******************************************************************************
*******************************************************************************
*******************************************************************************
AllocateAllocMem
	MOVE.L	A2,-(SP)
	ADDQ.L	#7,D0		;round up
	AND.W	#$FFF8,D0	;align
	LEA	(MH_FIRST,A0),A2	;prev
lbC001D9C
	MOVEA.L	(MC_NEXT,A2),A1
	MOVE.L	A1,D1
	BEQ.B	lbC001DE2

	CMP.L	(MC_BYTES,A1),D0	;chunk size big enough?
	BLS.B	GotChunk

	MOVEA.L	(MC_NEXT,A1),A2
	MOVE.L	A2,D1
	BEQ.B	lbC001DE2

	CMP.L	(MC_BYTES,A2),D0
	BHI.B	lbC001D9C

	EXG	A1,A2
GotChunk
	BEQ.B	AllocWholeChunk

	MOVE.L	A3,-(SP)
	LEA	(A1,D0.L),A3	;alloc end address - new chunk
	MOVE.L	A3,(MC_NEXT,A2)	;prev.next = new
	MOVE.L	(MC_NEXT,A1),(A3)+	;new.next = this.next
	MOVE.L	(MC_BYTES,A1),D1	;chunk size
	SUB.L	D0,D1		;new chunk size
	MOVE.L	D1,(A3)		;store new chunk size
	SUB.L	D0,(MH_FREE,A0)	;correct hunk free size
	MOVEA.L	(SP)+,A3
	move.l	d0,d1	; alloc size
	MOVE.L	A1,D0
	MOVEA.L	(SP)+,A2
	RTS

AllocWholeChunk
	MOVE.L	(MC_NEXT,A1),(MC_NEXT,A2)
	SUB.L	D0,(MH_FREE,A0)
	MOVEA.L	(SP)+,A2
	move.l	d0,d1	; alloc size
	MOVE.L	A1,D0
	RTS

lbC001DE2
	MOVEA.L	(SP)+,A2
lbC001DE4
	MOVEQ	#0,D0
lbC001DE6
	RTS

AllocNeedExpunge
	MOVEM.L	A2/A3/A5,-(SP)
	LEA	(12,SP),A3
;	ADDQ.B	#1,(TDNestCnt,A6)	;Forbid()
	SYS	Forbid
	TST.L	(ex_MemHandler,A6)
	BNE.B	_exec_Permit0

	LEA	(ex_MemHandlers,A6),A0
	MOVE.L	(A0),(ex_MemHandler,A6)
lbC001E1C
	MOVEA.L	(ex_MemHandler,A6),A2
	MOVE.L	(A2),D0
	MOVE.L	D0,(ex_MemHandler,A6)
	BEQ.B	_exec_Permit0

	CLR.L	(8,A3)			; memh_Flags 0==First time, 1==recycle
lbC001E2C
	MOVEA.L	A3,A0			; struct MemHandlerData
	MOVEM.L	(14,A2),A1/A5		; is_Data
;	move.w	a5,$dff180
;	bsr	DumpInfo
	JSR	(A5)
;	move.w	d0,$dff180
	MOVEA.L	D0,A5
	TST.L	D0
	BEQ.B	lbC001E1C	; MEM_DID_NOTHING EQU	0	; Nothing we could do...

	MOVEM.L	(A3),D0/D1
;	move.w	#$0f00,$dff180
	BSR.B	_exec_AllocMem		; no mem handler stuff
;	move.w	#$0f0f,$dff180
;	tst.l	d0
	BNE.B	lbC001E50

	MOVE.L	A5,D0
	BMI.B	lbC001E1C	; MEM_ALL_DONE	EQU	-1	; We did all we could do

	MOVEQ	#1,d0
	MOVE.L	D0,(8,A3)	; 0==First time, 1==recycle
	BRA.B	lbC001E2C

lbC001E50
	CLR.L	(ex_MemHandler,A6)
_exec_Permit0
	SYS	Permit

	MOVEM.L	(SP)+,A2/A3/A5
;NoExpunge
	TST.L	D0			; test if alloc was successful
	BNE.B	NoTask

NoExpunge
	MOVEA.L	(ThisTask,A6),A0
	CMPI.B	#NT_PROCESS,(LN_TYPE,A0)
	BNE.B	NoTask			; not a process

	MOVEQ	#103,D1			;Out of mem
	MOVE.L	D1,(pr_Result2,A0)
	BRA.B	NoTask

AllocNoSuccess
;	move.w	#$0f00,$dff180
	TST.L	(ThisTask,A6)		; before tasks are up and running?
	BEQ.B	NoTask

	TST.L	(4,SP)
	BMI.B	NoExpunge

	BRA.B	AllocNeedExpunge




*******************************************************************************
*******************************************************************************
*******************************************************************************
	cnop	0,16
exec_AllocMem
	ifeq	0
		ifd	CPU68030
			movem.l	d0/d1/d2/d3/d4,-(sp)
			moveq	#12,d0
			add.l	sp,d0
		else
			movem.l	d0/d1/d2/d3,-(sp)
		endc	;
		SYS	Forbid

		bsr	UseFreeURP

		ifnd	CPU68030
			move.l	d0,(12,sp)
		endc	;

		move.l	(sp),d0

	else

		ifeq	1
			SUBQ.L	#4,SP
			MOVEM.L	D0/D1,-(SP)
;			move.l	d1,-(sp)
;			move.l	d0,-(sp)
		else
			movem.l	d0/d1/d2,-(sp)
		endc	;

	endc	;

	BSR.B	_exec_AllocMem
	BEQ.B	AllocNoSuccess
NoTask
;	ADDQ.L	#8,SP
;	ADDQ.L	#4,SP
	bopt	O-
	add.w	#12,sp
	bopt	O+

	ifeq	0

		ifd	CPU68030
			move.l	sp,a0
;/\/\/\/\/
		else
			move.l	(sp)+,a0
		endc	;

		bsr	UseNewURP

		ifd	CPU68030
			addq.l	#8,sp
		endc	;

		SYS	Permit
	endc	;

	ifd	Scratch
		move.l	#$bada1bad,d1
		move.l	#$bada1bad,a0
		move.l	d1,a1
	endc	;
	TST.L	D0
	RTS
********************************************************************************
_exec_AllocMem
	MOVEM.L	D2/D3,-(SP)
	MOVE.L	D0,D3
	BEQ.B	end

	ifeq	1
		SYS	Forbid

		move.l	d0,-(sp)
		bsr	UseFreeURP
		move.l	(sp),a0
		move.l	d0,(sp)
		move.l	a0,d0
	endc	;

	MOVE.L	D1,D2
	LEA	(MemList,A6),A0
loop
	MOVEA.L	(LH_HEAD,A0),A0
	TST.L	(LN_SUCC,A0)
	BEQ.B	_exec_Permit

	MOVE.W	(MH_ATTRIBUTES,A0),D0
	AND.W	D2,D0
	CMP.W	D2,D0
	BNE.B	loop

	CMP.L	(MH_FREE,A0),D3
	BHI.B	loop

	BTST	#MEMB_REVERSE,D2	;MEMF_REVERSE
	BNE.B	revmem

	MOVE.L	D3,D0
	BSR.W	AllocateAllocMem
	tst.l	d0
	BEQ.B	loop

; d0 = start address
; d1 = size
	psh.l	d0/d2/d3
	add.l	d0,d1
*BONK
	UP	d0,d1		; if not 4K aligned then page is r/w already
				; last page _must_ be unprotected even if just a
				; little of it is used
;	DOWN	d0
;	UP	d1

	move.l	d1,d3

	ifd	CPU68030
		or.b	#%00000010,d0

	else
		or.w	#$43b,d0
	endc

	btst.l	#MEMB_CHIP,d2
	beq.b	.nochip

	ifd	CPU68030
		or.b	#%01000000,d0	; change copyback to noncache serialized

	else
		or.b	 #%01000000,d0	; change copyback to noncache
;		and.b	#~%00100000,d0	; change copyback to noncache serialized
	endc

.nochip
	move.l	d0,d2
	bra.b	.check

.protect
	move.l	d2,d0
	ifd	CPU68030
		lea	(ProtectedURP,pc),a0
	else
		move.l	(ProtectedURP,pc),a0
	endc
	bsr	FindDescriptor		; internal

	ifd	CPU68030
		beq.b	.next
	endc

	cmp.l	(_EnforcerHack,pc),d0

	ifnd	DEADLY
		bne.b	.setglob
;---------------
	else
; if DEADLY option but not DEADLY descriptor then it is already fine
		bne.b	.next
;---------------
	endc

;	move.l	d2,d0
;	CMPNOPL
	ifnd	dummy
		move.l	d2,(a0)
	else
		ifd	ENFORCER
			move.l	d2,(a0)
		endc
	endc
	bra.b	.next
.setglob
	and.b	#~(mmu_readonly|%11),d0
	or.b	#%11,d0
	ifnd	dummy
		move.l	d0,(a0)
	else
		ifd	ENFORCER
			move.l	d0,(a0)
		endc
	endc
.next
	add.l	#PAGESIZE,d2
.check	cmp.l	d2,d3
	bhi.b	.protect
.out
	pll.l	d0/d2/d3

_exec_Permit1
	BTST	#MEMB_CLEAR,D2	;MEMF_CLEAR
	BEQ.B	end

	MOVEQ	#0,D1
	MOVEA.L	D0,A0
	ADDQ.L	#7,D3
	LSR.L	#3,D3
	MOVE.W	D3,D2
	SWAP	D3
	BRA.B	lbC001EE6

lbC001EE2
	MOVE.L	D1,(A0)+
	MOVE.L	D1,(A0)+
lbC001EE6
	DBRA	D2,lbC001EE2
	DBRA	D3,lbC001EE2
end

	ifeq	1
		move.l	(sp)+,a0
		bsr	UseNewURP
		SYS	Permit
	endc

	MOVEM.L	(SP)+,D2/D3
	TST.L	D0
	RTS

_exec_Permit
	MOVEQ	#0,D0
	BRA.B	end

revmem
	MOVEQ	#0,D1
	MOVE.L	(MH_FIRST,A0),D0
	BEQ.B	loop
lbC001F06
	MOVEA.L	D0,A1
	CMP.L	(4,A1),D3
	BHI.B	lbC001F10

	MOVE.L	A1,D1
lbC001F10
	MOVE.L	(A1),D0
	BNE.B	lbC001F06

	TST.L	D1
	BEQ	loop

	MOVEA.L	D1,A1
	MOVE.L	(4,A1),D0
	SUB.L	D3,D0
	AND.W	#$FFF8,D0
	ADDA.L	D0,A1
	MOVE.L	D3,D0
	JSR	(_LVOAllocAbs,A6)
	BRA.B	_exec_Permit1




*******************************************************************************
*******************************************************************************
*******************************************************************************
;#prob
	cnop	0,16
exec_AllocAbs
	move.l	d0,d1
	beq.b	_AbsExit

	SYS	Forbid

	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc

	bsr	UseFreeURP

;	tst.b	($07f30000)
;	move.l	d0,a0
;	bsr	UseNewURP
;	moveq	#0,d0
;	SYS	Permit
;	rts


	ifnd	CPU68030
		move.l	d0,-(sp)	; save current URP
	endc

	move.l	d1,d0

	MOVE.L	A1,D1		;location
	AND.L	#7,D1

	SUBA.L	D1,A1		;address 8 aligned
	ADD.L	D1,D0		;bytesize + address offset
	ADDQ.L	#7,D0		;size expansion trick
	AND.W	#$FFF8,D0	;dividable by 8
	LEA	(MemList,A6),A0
	MOVE.L	D0,D1
	MOVEQ	#0,D0
lbC001F70
	MOVEA.L	(A0),A0
	TST.L	(A0)
	BEQ.B	_exec_Permit5

	CMPA.L	(MH_LOWER,A0),A1
	BLO.B	lbC001F70

	CMPA.L	(MH_UPPER,A0),A1
	BHS.B	lbC001F70

; optimise: don't move d1 to d0. use d1 instead of d0
;  collapse FailedAllocAbs
AllocAbsThisHeader
	MOVEM.L	D2-D4/A2/A3,-(SP)
	MOVE.L	D1,D0
	CMP.L	(MH_FREE,A0),D0	;want more mem than available?
	BHI.B	FailedAllocAbs

	MOVEA.L	A1,A3
	MOVE.L	A1,D2	;where to do alloc
	LEA	(MH_FIRST,A0),A2
	ADD.L	D0,D2	;end of wanted alloc
lbC001F9E
	MOVE.L	(MC_NEXT,A2),D3
	BEQ.B	FailedAllocAbs

	MOVEA.L	D3,A1		;get chunk
	MOVE.L	(MC_BYTES,A1),D4	;size of cunk
	ADD.L	D3,D4		;end of this chunk
	CMP.L	D2,D4		;end after wanted address?
	BHS.B	GotAbsChunk

	MOVEA.L	A1,A2		;loop on this next chunk
	BRA.B	lbC001F9E

GotAbsChunk
	CMP.L	A3,D3	;start after wanted address?
	BHI.B	FailedAllocAbs

	SUB.L	D0,(MH_FREE,A0)	;new free size
	SUB.L	D2,D4	;end chunk - end wanted
	BNE.B	lbC001FC2

	MOVEA.L	(MC_NEXT,A1),A0	;chunk was completely eaten
	BRA.B	lbC001FCE

lbC001FC2
	LEA	(A3,D0.L),A0	;end of split chunk
	MOVE.L	(MC_NEXT,A1),(MC_NEXT,A0)	;new.next = this.next
	MOVE.L	A0,(MC_NEXT,A1)	;this.next = new
	MOVE.L	D4,(MC_BYTES,A0)
lbC001FCE
	CMP.L	A3,D3	;alloc at start of chunk?
	BEQ.B	lbC001FDC

	SUB.L	A3,D3	;start - alloc address
	NEG.L	D3
	MOVE.L	D3,(MC_BYTES,A1)	;new free size this chunk
	BRA.B	lbC001FDE

lbC001FDC
	MOVE.L	A0,(MC_NEXT,A2)	;prev.next = this.next
lbC001FDE
	move.l	a3,d0
	move.l	d2,d1
*BONK
	DOWN	d0		; page might not have been used previously
	UP	d1		; page might not have been used previously

	psh.l	d2/d3

	move.l	d0,d2
	move.l	d1,d3

	ifd	CPU68030
		or.b	#%00000010,d2

	else
		or.w	#$43b,d2
	endc

CODE_MODIFY	equ	*-CodeStart
	cmp.l	#CHIP_END,d2
	bhs.b	.check

	ifd	CPU68030
		or.b	#%01000000,d2	; change copyback to noncache serialized

	else
;		eor.b	 #%01100000,d2	; change copyback to noncache serialized
		or.b	 #%01000000,d2	; change copyback to noncache
;		and.b	#~%00100000,d2	; change copyback to noncache serialized
	endc

	bra.b	.check

.protect
	move.l	d2,d0
	ifd	CPU68030
		lea	(ProtectedURP,pc),a0
	else
		move.l	(ProtectedURP,pc),a0
	endc
	bsr	FindDescriptor		; internal

	ifd	CPU68030
		beq.b	.next
	endc

	cmp.l	(_EnforcerHack,pc),d0

	ifnd	DEADLY
		bne.b	.setglob
;---------------
	else
; if DEADLY option but not DEADLY descriptor then it is already fine
		bne.b	.next
;---------------
	endc

;	move.l	d2,d0
	ifnd	dummy
		move.l	d2,(a0)
	else
		ifd	ENFORCER
			move.l	d2,(a0)
		endc
	endc
	bra.b	.next

.setglob
	and.b	#~mmu_readonly,d0
	or.b	#%11,d0
	ifnd	dummy
		move.l	d0,(a0)
	else
		ifd	ENFORCER
			move.l	d0,(a0)
		endc
	endc
.next
	add.l	#PAGESIZE,d2
.check	cmp.l	d2,d3
	bhi.b	.protect
.out
	pll.l	d2/d3

	MOVE.L	A3,D0
lbC001FE0
	MOVEM.L	(SP)+,D2-D4/A2/A3
_exec_Permit5
	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc

	SYS	Permit
	ifd	Scratch
		move.l	#$badaabad,d1
		move.l	d1,a0
		move.l	d1,a1
	endc
	tst.l	d0
_AbsExit
	rts

FailedAllocAbs
	MOVEQ	#0,D0
	BRA.B	lbC001FE0




*******************************************************************************
*******************************************************************************
*******************************************************************************
	cnop	0,16
exec_AvailMem
	SYS	Forbid

	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc

	bsr	UseFreeURP

	ifnd	CPU68030
		move.l	d0,-(sp)	; save current URP
	endc

	move.l	(OldAvailMem,pc),a0
	jsr	(a0)

	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc

	SYS	Permit

	ifd	Scratch
		move.l	#$bad88bad,d1
		move.l	#$bad88bad,a0
		move.l	d1,a1
	endc

	TST.L	D0
	RTS



*******************************************************************************
*******************************************************************************
*******************************************************************************
; A1 = address
	cnop	0,16
exec_TypeOfMem
	move.l	a1,-(sp)
	move.l	a1,d0
	SYS	Forbid

	ifd	CPU68030
		lea	(ProtectedURP,pc),a0
	else
		move.l	(ProtectedURP,pc),a0
	endc
	bsr	FindDescriptor		; internal

	SYS	Permit
	move.l	(sp)+,a1
	move.l	d0,a0
	and.l	#%11,d0
	beq	.out

	cmp.b	#%10,d0
	bne	.OldCheck

	move.l	(-2,a0),d0		; nasty code - depend on %10 pattern = 2 too far
	and.l	#%11,d0
	beq	.out
.OldCheck
	move.l	(OldTypeOfMem,pc),a0
	jsr	(a0)
.out
	ifd	Scratch
		move.l	#$fee1dead,d1
		move.l	d1,a0
		move.l	d1,a1
	endc	;
	RTS


;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;//////////////////////////////////////////////////////////////////////////////
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;//////////////////////////////////////////////////////////////////////////////


	ifnd	CPU68030
FindDescriptor
;-Input:-----------------------------------------------------------------------
;	d0 = address	no alignment needed
;	a0 = URP
;-Output:----------------------------------------------------------------------
;	d0 = page descriptor for address
;	a0 = address of page descriptor
;------------------------------------------------------------------------------
	moveq	#$7f,d1
	rol.l	#7,d0		; top 7 bits
	and.l	d0,d1
* level 1
	move.l	(a0,d1.w*4),d1	; root level tables
	and.w	#$fe00,d1	; clear lower 9 bits
	rol.l	#7,d0		; level B bits
	move.l	d1,a0		; level B table
	moveq	#$7f,d1
	and.l	d0,d1
* level 2
	move.l	(a0,d1.w*4),d1	; pointer level tables
	rol.l	#6,d0
	clr.b	d1		; clear lower  8 bits
	and.w	#%111111,d0	; d1 = table offset
	move.l	d1,a0
* level 3
	lea	(a0,d0.w*4),a0
	move.l	(a0),d0		; page descriptor

	rts



	else
* 68030 version
FindDescriptor
;-Input:-----------------------------------------------------------------------
;	d0 = address	no alignment needed
;	a0 = URP
;-Output:----------------------------------------------------------------------
;	d0 = page descriptor for address
;	a0 = address of page descriptor
;------------------------------------------------------------------------------
	move.l	d2,-(sp)
	moveq	#~$f,d1
	and.l	(4,a0),d1
	move.l	d1,a0
	move.w	#$ff,d1
	rol.l	#8,d0		; top 8 bits
	and.l	d0,d1
* level 1
	move.l	(a0,d1.w*4),d1	; root level tables
	moveq	#%11,d2
	and.l	d1,d2
	beq.b	.invalid1

	subq.l	#1,d2
	beq.b	.early1

	and.w	#$fff0,d1	; clear lower 4 bits
	rol.l	#6,d0		; level B bits
	move.l	d1,a0		; level B table
	moveq	#$3f,d1
	and.l	d0,d1
* level 2
	move.l	(a0,d1.w*4),d1	; pointer level tables
	moveq	#%11,d2
	and.l	d1,d2
	beq.b	.invalid2

	subq.l	#1,d2
	beq.b	.early2

	rol.l	#8,d0
	and.b	#$f0,d1		; clear lower 4 bits
	and.w	#$ff,d0		; d1 = table offset
	move.l	d1,a0
* level 3
	lea	(a0,d0.w*4),a0
	move.l	(sp)+,d2
	move.l	(a0),d0		; page descriptor

	rts
.invalid2
	move.l	a0,$fc.w
	move.l	d1,$fc.w
	ror.l	#6,d0
	ror.l	#8,d0
	move.l	d0,$fc.w
	bra.b	.out
.invalid1
	move.l	a0,$f8.w
	move.l	d1,$f8.w
	ror.l	#8,d0
	move.l	d0,$f8.w

	ifeq	1
;	illegal
	move.l	#$003fffff,d0
;	moveq   #1,d0
.l	move.w	d0,COL00
	subq.l	#1,d0
	bne.b	.l
	endc
.out
.early2
.early1
	move.l	(sp)+,d2
	moveq	#0,d0
	rts

* 68030 version
FindDescriptorCheck
;-Input:-----------------------------------------------------------------------
;	d0 = address	no alignment needed
;	a0 = URP
;-Output:----------------------------------------------------------------------
;	d0 = page descriptor for address
;	a0 = address of page descriptor
;------------------------------------------------------------------------------
	move.l	d2,-(sp)
	moveq	#~$f,d1
	and.l	(4,a0),d1
	move.l	d1,a0
	move.w	#$ff,d1
	rol.l	#8,d0		; top 8 bits
	and.l	d0,d1
* level 1
	lea	(a0,d1.w*4),a0	; root level tables
	move.l	(a0),d1		; root level tables
	moveq	#%11,d2
	and.l	d1,d2
	beq.b	.invalid1

	subq.l	#1,d2
	beq.b	.early1

	and.w	#$fff0,d1	; clear lower 4 bits
	rol.l	#6,d0		; level B bits
	move.l	d1,a0		; level B table
	moveq	#$3f,d1
	and.l	d0,d1
* level 2
	lea	(a0,d1.w*4),a0	; pointer level tables
	move.l	(a0),d1		; pointer level tables
	moveq	#%11,d2
	and.l	d1,d2
	beq.b	.invalid2

	subq.l	#1,d2
	beq.b	.early2

	rol.l	#8,d0
	and.b	#$f0,d1		; clear lower 4 bits
	and.w	#$ff,d0		; d1 = table offset
	move.l	d1,a0
* level 3
	lea	(a0,d0.w*4),a0
	move.l	(sp)+,d2
	move.l	(a0),d0		; page descriptor

	rts
.invalid2
	move.l	a0,$fc.w
	move.l	d1,$fc.w
	ror.l	#6,d0
	ror.l	#8,d0
	move.l	d0,$fc.w
	bra.b	.out
.invalid1
	move.l	a0,$f8.w
	move.l	d1,$f8.w
	ror.l	#8,d0
	move.l	d0,$f8.w

	ifeq	1
;	illegal
	move.l	#$003fffff,d0
;	moveq   #1,d0
.l	move.w	d0,COL00
	subq.l	#1,d0
	bne.b	.l
	endc
.out
	move.l	(sp)+,d2
	moveq	#0,d0
	rts
.early2
	move.l	(sp)+,d2
	moveq	#1,d0
	rts
.early1
	move.l	(sp)+,d2
	moveq	#0,d0
	rts

	endc




	ifeq	1
xFindDescriptor
;-Input:-----------------------------------------------------------------------
;	d0 = address	no alignment needed
;	a0 = URP
;-Output:----------------------------------------------------------------------
;	d0 = page descriptor for address
;	a0 = address of page descriptor
;------------------------------------------------------------------------------
	move.l	d0,d1
	swap	d1
	lsr.w	#7,d1		; top 7 bits
	and.b	#%11111100,d1	; d1 = root index	;clear bit 0,1
* level 1
	move.l	(a0,d1.w),d1	; root level tables
	and.w	#$fe00,d1	; clear lower 9 bits
	move.l	d1,a0
	move.l	d0,d1
	swap	d1
	and.w	#%0000000111111100,d1	; pointer index
* level 2
	move.l	(a0,d1.w),d1	; pointer level tables
	clr.b	d1		; clear lower  8 bits
	move.l	d1,a0

	move.l	d0,d1
	lsl.l	#6,d1
	swap	d1
	and.w	#%0000000011111100,d1	; d1 = table offset
* level 3
	lea	(a0,d1.w),a0
	move.l	(a0),d0		; page descriptor

	rts

	endc



SetReadWrite
;-Input:----------------------------------------------------------------------
;	d0 = address of first page to be read&write
;	d1 = address+1 of last page to be read&write
;-Output:---------------------------------------------------------------------
;	pages are read&writeable
;-----------------------------------------------------------------------------
;	rts
	psh.l	d2/d3
	move.l	d0,d2
	move.l	d1,d3

	ifd	CPU68030
		pea	(ProtectedURP,pc)
	else
		move.l	(ProtectedURP,pc),-(sp)
	endc
.protect
	move.l	d2,d0
	move.l	(sp),a0
	bsr	FindDescriptor		; internal

	ifd	CPU68030
		beq.b	.next
	endc

	cmp.l	(_EnforcerHack,pc),d0
	beq.b	.fixup

	moveq	#%11,d1
	and.l	d0,d1
	cmp.b	#%10,d1
	beq.b	.next

; read&write protected page
.fixup
	btst.l	#1,d0
	beq.b	.next

; d0 = % 11
	move.l	d2,d0

	ifd	CPU68030
		or.b	#%00000010,d0

	else
		or.w	#$439,d0
	endc

CODE_MODIFY2	equ	*-CodeStart
	cmp.l	#CHIP_END,d2
	bhs.b	.nochip

	ifd	CPU68030
		or.b	#%01000000,d0	; change copyback to noncache serialized

	else
;		eor.b	#%01100000,d0	; change copyback to noncache serialized
		or.b	#%01000000,d0	; change copyback to noncache
	endc
.nochip
.setglob
	and.b	#~mmu_readonly,d0
;	or.b	#%11,d0
	move.l	d0,a1
	bsr	SetPageDescriptor
.next
	add.l	#PAGESIZE,d2
.check	cmp.l	d2,d3
	bhi.b	.protect

	addq.l	#4,sp
.out
	pll.l	d2/d3
	rts

SetIllegal
;-Input:----------------------------------------------------------------------
;	d0 = address of first page to be read&write-protected
;	d1 = address+1 of last page to be read&write-protected
;-Output:---------------------------------------------------------------------
;	pages are protected against access
;-----------------------------------------------------------------------------
;	rts
	psh.l	d2/d3
	move.l	d0,d2
	move.l	d1,d3

	ifd	CPU68030
		pea	(ProtectedURP,pc)
	else
		move.l	(ProtectedURP,pc),-(sp)
	endc
.protect
	move.l	d2,d0
	move.l	(sp),a0
	bsr	FindDescriptor		; internal

	ifd	CPU68030
		beq.b	.next
	endc

	or.b	#mmu_readonly,d0

	ifd	DEADLY
		and.b	#~%11,d0
	endc

	move.l	d2,a1

	tst.l	(_EnforcerHack,pc)
	beq.b	.ok

	ifd	DEADLY
		move.l	(_EnforcerHack,pc),d0
	endc

.ok
	bsr	SetPageDescriptor
.next
	add.l	#PAGESIZE,d2
.check	cmp.l	d2,d3
	bhi.b	.protect

	addq.l	#4,sp
.out
	pll.l	d2/d3
	rts

SetPageDescriptor
;-Input:-----------------------------------------------------------------------
;	d0 = new descriptor
;	a1 = logical address that with changed desciptor (12 lowest bits ignored)
;	a0 = descriptor address
;------------------------------------------------------------------------------
	moveq	#%11,d1
	and.l	d0,d1
	bne.b	.zok

	move.l	d0,($87650000.l,d0.w)
	move.l	a0,($87650000.l,a0.w)
	move.l	a1,($87650000.l,a1.w)
	move.w	(2,sp),d1
	move.l	d1,($87650000.l,d1.w)

	swap	d0
	move.l	d0,($87650000.l,d0.w)
	swap	d0

	move.l	a0,d1
	swap	d1
	move.l	d1,($87650000.l,d1.w)

	move.l	a1,d1
	swap	d1
	move.l	d1,($87650000.l,d1.w)

	move.w	(sp),d1
	move.l	d1,($87650000.l,d1.w)
.zok
	move.l	a5,d1
	lea	(.super,pc),a5
	SYS	Supervisor
	rts
.super
	ifnd	dummy
		move.l	d0,(a0)		; set new descriptor
	else
		ifd	ENFORCER
			move.l	d0,(a0)
		endc
	endc
;	tst.l	(_MMU060,pc)
;	beq.b	.desc_ok
;
;	FlushDataAddress	a0
;.desc_ok
; flush out the old descriptor that is no longer correct in the atc
; need to flush ATC entry so that ATC goes to memory (060) / snoops cache (040)
	ATCFlushaAddress	a1	; flush atc for this address
;	ATCFlusha
	move.l	d1,a5
	rte


;##############################################################################
CalcSize
; a5 = URP
	ifd	CPU68030
		move.l	#~$f,d2
		and.l	(4,a5),d2
		move.l	d2,a5
	endc
	move.l	#ASIZE,d2		; total mmu table size
	move.l	#(ASIZE/4)-1,d7		; root level
;	moveq	#%10,d4
.root_loop
	move.l	a5,a0
	move.l	(a5)+,d3		; get level A

	ifd	CPU68030
		btst.l	#1,d3

	else
		cmp.l	(BadLevelA,pc),d3
	endc

	beq.b	.do_root_loop

	ifd	CPU68030
		and.l	#~$f,d3

	else
		and.l	#~$1ff,d3
	endc

	move.l	d3,a4
;	move.l	#(CSIZE/4)-1,d6		; pointer level
	move.l	#(BSIZE/4)-1,d6		; pointer level
.pointer_loop
	move.l	a4,a0
	move.l	(a4)+,d3		; get level B

	ifd	CPU68030
		btst.l	#1,d3

	else
		cmp.l	(BadLevelB,pc),d3
	endc

	beq.b	.do_pointer_loop

	add.l	#CSIZE,d2		; descriptors size

********************

.do_pointer_loop
	dbra	d6,.pointer_loop

	add.l	#BSIZE,d2		; pointer level valid, add to size

********************

.do_root_loop
	dbra	d7,.root_loop

.out
	rts


	ifd	CPU68030
;##############################################################################
AllocMemAligned256
; a6 = ExecBase
;-Input:-----------------------------------------------------------------------
;	d0 = alloc size
;	d1 = type
;-Output:----------------------------------------------------------------------
;	d0 = 256 byte aligned memory block
;	d1 = real alloc size
;------------------------------------------------------------------------------
	add.l	#$100-1,d0
	clr.b	d0
	psh.l	d0/d2
	move.l	#$100,d2	; align size
	bsr	AllocMemAligned
	pll.l	d1/d2
	rts
	endc

;##############################################################################
AllocMemAligned4K
; a6 = ExecBase
;-Input:-----------------------------------------------------------------------
;	d0 = alloc size
;	d1 = type
;-Output:----------------------------------------------------------------------
;	d0 = 4k aligned memory block
;	d1 = real alloc size
;------------------------------------------------------------------------------
	UP	d0
	psh.l	d0/d2
	move.l	#$1000,d2	; align size
	bsr	AllocMemAligned
	pll.l	d1/d2
	rts

AllocMemAligned
; a6 = ExecBase
;-Input:-----------------------------------------------------------------------
;	d0 = alloc size multiple of d2
;	d1 = type flags
;	d2 = align boundary
;-Output:----------------------------------------------------------------------
;	d0 = aligned memory block
; no	d1 = TypeOfMem(d0)
;------------------------------------------------------------------------------
	psh.l	d3/d4
	or.w	#MEMF_PUBLIC,d1
	move.l	d0,d3			; size
	move.l	d2,d4			; align
	add.l	d2,d0		; round up to align
	SYS	AllocMem
	tst.l	d0		; alloc ok?
	beq	.fail

	move.l	d0,a1		; free addr reg
	move.l	d0,d1		; work
	SYS	Forbid
	move.l	d3,d0		; size
	add.l	d4,d0		; +align
	subq.l	#1,d4
	add.l	d4,d1
	not.l	d4		; align mask
	and.l	d4,d1		; aligned address
	move.l	d1,d4		; store abs address
	SYS	FreeMem
	move.l	d4,a1		; addr
	move.l	d3,d0		; size
	SYS	AllocAbs
	SYS	Permit

.fail	pll.l	d3/d4
	rts




	ifnd	CPU68030
Clone
	move.l	#(ASIZE/4)-1,d7		; level A loop
	move.l	(ProtectedURP,pc),d5
	move.l	(FreeURP,pc),a5
	move.l	a5,a1
	move.l	d5,a0
	bsr	Copy512			; copy root table

.loop_level_A
	move.l	(a5)+,d0
	cmp.l	(BadLevelA,pc),d0
;	dbne	d7,.do_loop_level_A
	dbne	d7,.loop_level_A
	beq	.out

	move.l	d0,d4
	and.l	#$1ff,d4		;
	and.w	#~$1ff,d0
	move.l	d0,a0			; from this level A
	bsr	Alloc512		; to allocated level A
	move.l	a1,a4
	move.l	a1,-(a5)		; new pointer for new level A
	or.l	d4,(a5)+
	bsr	Copy512
	move.l	#(BSIZE/4)-1,d6

.loop_level_B
	move.l	(a4)+,d0
	cmp.l	(BadLevelB,pc),d0
;	dbne	d6,.do_loop_level_B
	dbne	d6,.loop_level_B
	beq	.do_loop_level_A

	move.l	d0,d3
	and.l	#$ff,d3
	clr.b	d0
	move.l	d0,a0			; from this level B
	bsr	Alloc256		; to allocated level B
	move.l	a1,-(a4)
	or.l	d3,(a4)+

	bsr	Copy256

.do_loop_level_B
	dbra	d6,.loop_level_B

.do_loop_level_A
	dbra	d7,.loop_level_A
.out
	rts



;##############################################################################
Alloc512
	lea.l	(_Adr512,pc),a1
	sub.l	#512,(a1)
	move.l	(a1),a1
	rts
Alloc256
	lea.l	(_Adr256,pc),a1
	add.l	#256,(a1)
	move.l	(a1),a1
	sub.w	#256,a1
	rts

;##############################################################################
Copy512
	move.l	d0,-(sp)
	moveq	#(512/4)-1,d0
	bra	Copy
Copy256
	move.l	d0,-(sp)
	moveq	#(256/4)-1,d0
Copy
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	move.l	(sp)+,d0
	rts


;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
	else

Clone
	move.l	#(ASIZE/4)-1,d7		; level A loop
	move.l	#~$f,d5
	and.l	(FreeURP_low,pc),d5
	move.l	d5,a5
	move.l	#~$f,d5
	and.l	(ProtectedURP_low,pc),d5
	move.l	a5,a1
	move.l	d5,a0
	bsr	Copy1024		; copy root table

.loop_level_A
	move.l	(a5)+,d0
	moveq	#%10,d4
	and.l	d0,d4
	dbne	d7,.do_loop_level_A
	beq	.out

	move.l	d0,d4
	and.l	#$f,d4
	and.w	#~$f,d0
	move.l	d0,a0			; from this level A
	bsr	Alloc256table		; to allocated level A
	move.l	a1,a4
	move.l	a1,-(a5)		; new pointer for new level A
	or.l	d4,(a5)+
	bsr	Copy256
	move.l	#(BSIZE/4)-1,d6

.loop_level_B
	move.l	(a4)+,d0
	moveq	#%10,d4
	and.l	d0,d4
	dbne	d6,.do_loop_level_B
	beq	.do_loop_level_A

	move.l	d0,d3
	and.l	#$ff,d3
	clr.b	d0
	move.l	d0,a0			; from this level B
	bsr	Alloc1024descriptor	; to allocated level B
	move.l	a1,-(a4)
	or.l	d3,(a4)+
	bsr	Copy1024

.do_loop_level_B
	dbra	d6,.loop_level_B

.do_loop_level_A
	dbra	d7,.loop_level_A
.out
	rts

;##############################################################################
Alloc1024table
	lea.l	(_Adr256,pc),a1
	sub.l	#1024,(a1)
	move.l	(a1),a1
	rts
Alloc256table
	lea.l	(_Adr256,pc),a1
	sub.l	#256,(a1)
	move.l	(a1),a1
	rts
Alloc1024descriptor
	lea.l	(_Adr1024,pc),a1
	add.l	#1024,(a1)
	move.l	(a1),a1
	sub.w	#1024,a1
	rts

;##############################################################################
Copy1024
	move.l	d0,-(sp)
	move.w	#(1024/4)-1,d0
	bra	Copy
Copy256
	move.l	d0,-(sp)
	moveq	#(256/4)-1,d0
Copy
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	move.l	(sp)+,d0
	rts

	endc






	ifd	CPU68060
SetNocache
;-Input:----------------------------------------------------------------------
;	d0 = first address to get nocache status
;	d1 = last address to get nocache status
;	a0 = URP
;-Output:---------------------------------------------------------------------
;	pages between addresses have nocache status
;-----------------------------------------------------------------------------
	psh.l	d2/d3
	UP	d0			; first page to be protected
	DOWN	d1			; last page to be protected
	move.l	d0,d2
	move.l	d1,d3
	move.l	a0,-(sp)

.setstatus
	move.l	d2,d0
	move.l	(sp),a0
	bsr	FindDescriptor		; internal

	ifd	CPU68030
		beq.b	.next
	endc

	and.b	#%10011111,d0		; write-through
;	or.b	#%01000000,d0		; no cache, serialized
	move.l	d0,a1
	bsr	SetPageDescriptor
.next
	add.l	#PAGESIZE,d2
.check	cmp.l	d2,d3
	bhs.b	.setstatus

.out
	addq.l	#4,sp
	pll.l	d2/d3
	rts

	endc



;##############################################################################
	cnop	0,16
exec_RemTask
	cmp.l	a1,a6		; another HACK
	beq.b	.UnInstall

	move.l	a1,d0
	beq	.newstack		; remove ourself

	cmp.l	(ThisTask,a6),a1
	bne	.call			; remove ourself

.newstack

  ******************************************************************************
**										**
**	{	This should really send a msg to another task that	}	**
**	{	never exits and ask it to RemTask() ourself.		}	**
**										**
  ******************************************************************************

	SYS	Forbid

	lea	(NewStack+$1000,pc),sp
.call

; check if UnLoadSeg() has changed URP and force it back to protected
; hope that RemTask() comes close after UnLoadSeg()

	tst.w	(ChangeURP,pc)
	bne	.do_rem

	lea	(ChangeURP,pc),a0
	move.w	#$ffff,(a0)

	move.l	a1,-(sp)
	ifd	CPU68030
		lea	(ProtectedURP,pc),a0
	else
		move.l	(ProtectedURP,pc),a0
	endc
;	bsr	UseNewURP
.do_rem

	move.l	(OldRemTask,pc),a0
	jsr	(a0)

	ifd	Scratch
		move.l	#$bad22bad,d1
		move.l	d1,a0
		move.l	d1,a1
		move.l	a0,d0
	endc

	rts

.UnInstall
	SYS	Disable

check	macro
	lea	(exec_\1,pc),a0
	cmp.l	(_LVO\1+2,a6),a0
	bne	.fail
	endm

	check	FreeMem
	check	AllocAbs
	check	RemTask
	check	AllocMem
	check	AvailMem
	check	RemLibrary
	check	RemDevice
	check	TypeOfMem

	ifeq	PatchUnLoad-1
		move.l	(DosBase,pc),a1
		lea	(exec_UnLoadSeg,pc),a0
		cmp.l	(_LVOUnLoadSeg+2,a1),a0
		bne	.fail
		lea	(exec_InternalUnLoadSeg,pc),a0
		cmp.l	(_LVOInternalUnLoadSeg+2,a1),a0
		bne.b	.fail
	endc

	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc

	bsr	UseFreeURP

	ifnd	CPU68030
		move.l	d0,-(sp)	; save current URP
	endc

	bsr	UnprotectFreeMemory
	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc

UnPatch	macro
	move.l	a6,a1
	move.w	#_LVO\1,a0
	move.l	(Old\1,pc),d0
	SYS	SetFunction
	endm

	UnPatch	FreeMem
	UnPatch	AllocAbs
	UnPatch	RemTask
	UnPatch	AllocMem
	UnPatch	AvailMem
	UnPatch	RemLibrary
	UnPatch	RemDevice
	UnPatch	TypeOfMem

	ifeq	PatchUnLoad-1
		move.l	(DosBase,pc),a1
		move.w	#_LVOUnLoadSeg,a0
		move.l	(OldInternalUnLoadSeg,pc),d0
		SYS	SetFunction
		move.l	(DosBase,pc),a1
		move.w	#_LVOInternalUnLoadSeg,a0
		move.l	(OldUnLoadSeg,pc),d0
		SYS	SetFunction
	endc

	move.l	(OldTaskExitCode,pc),(TaskExitCode,A6)
	moveq	#0,d7
.fail
	SYS	Enable

	rts


*******************************************************************************
ExitCode
	move.l	(EXECBase,pc),a6
	SUBA.L	A1,A1
;exec_RemTask
	jmp	(_LVORemTask,a6)

*******************************************************************************

	ifeq	PatchUnLoad-1
	cnop	0,16
exec_UnLoadSeg
	move.l	d1,d0
	beq.b	.out

	SYSX	Forbid,EXECBase

	dbug	<"UnLoad">
	move.l	d2,-(sp)
	tst.l	(RemCheck,pc)
	bne	.URP_ok

	moveq	#0,d2
.check
	lsl.l	#2,d0
	move.l	d0,a0
	move.l	(-4,a0),a1		; size
	add.l	a0,a1
	cmp.l	sp,a0
	bhi.b	.next1

	cmp.l	sp,a1
	blo.b	.next1

	moveq	#-1,d2
;	bsr	Flasher
	dbug	<"Self UnL">
.next1
	cmp.l	(4,sp),a0
	bhi.b	.next2

	cmp.l	(4,sp),a1
	blo.b	.next2

	moveq	#-1,d2
;	bsr	Flasher
	dbug	<"Self UnL">
.next2
	move.l	(a0),d0
	bne.b	.check

	tst.l	d2
	bne	.Change

	move.l	(EXECBase,pc),a0
	move.l	(ThisTask,a0),a0
	sub.l	a1,a1
;	move.l	($80,a0),d0		; pr_SegList
	move.l	(pr_SegList,a0),d0
	move.l	($C,a1,d0.l*4),d0	; BPTR [3]
	beq	.URP_ok

	tst.l	(a1,d0.l*4)		; test seglist
	bne	.URP_ok			; >1 segment is not CreateNewProc

	tst.l	(-4,a1,d0.l*4)		; 0,0 pair is CreateNewProc style
	bne	.URP_ok

; we have an unnatural seglist
	move.l	(4,sp),d0		; return address
	cmp.l	(DosStart,pc),d0
	blo	.URP_ok

	cmp.l	(DosEnd,pc),d0		; return address
	bhi	.URP_ok

;	bsr	Flasher
.Change
	dbug	<"New_URP ">

	lea	(ChangeURP,pc),a0
	clr.w	(a0)
	move.l	d1,-(sp)
	move.l	a6,-(sp)
	move.l	(EXECBase,pc),a6
	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc
	bsr	UseFreeURP
	ifd	CPU68030
		addq.l	#8,sp
	endc
	move.l	(sp)+,a6
	move.l	(sp)+,d1

;insecure checks says that we will not remove our own code
.URP_ok
	dbug	<"Enter ">
	move.l	(sp)+,d2
	move.l	(OldUnLoadSeg,pc),a0

	tst.l	(RemCheck,pc)
	beq	.xo1
	move.l	#$001fffff,d0
.flish
	move.w	#$00f0,COL00
	subq.l	#1,d0
	bpl.b	.flish
.xo1

	jsr	(a0)

	tst.l	(RemCheck,pc)
	beq	.xo2
	move.l	#$001fffff,d0
.flysh
	move.w	#$0ff0,COL00
	subq.l	#1,d0
	bpl.b	.flysh
.xo2

	SYSX	Permit,EXECBase

	dbug	<"UnL out">
.out
	ifd	Scratch
		move.l	#$bad01bad,d1
		move.l	d1,a0
		move.l	d1,a1
	endc	;
	rts

	IFNE	PatchUnLoad-1
xunl
;	MOVEA.L	(4).W,A0
	move.l	(EXECBase,pc),a0
	LEA	(_LVOFreeMem,A0),A1
	ASL.L	#2,D1	;BPTR
	BNE.B	.lbC01D572
	MOVE.W	D1,D0
	RTS

.lbC01D572
	MOVEM.L	D2/A2-A4/A6,-(SP)
	MOVEA.L	D1,A2
	MOVEA.L	A1,A4
	CMPI.L	#$ABCD,(seg_Seg,A2)
	BNE.B	lbC01D5BC
	BSR	lbC016082
	MOVEA.L	D0,A6
	MOVE.L	($18,A2),D0
	CMP.L	($26,A6),D0
	BNE.B	lbC01D5BC
	MOVE.L	(12,A2),D1
;	BSR.W	dos_Close
	move.l	($10,sp),a6
	SYS	Close

;	MOVEA.L	(4).W,A6
	move.l	(EXECBase,pc),a6
	MOVEA.L	($14,A2),A1
	MOVE.L	A1,D0
	BEQ.B	lbC01D5B0
	ADDA.L	A1,A1
	ADDA.L	A1,A1
	MOVE.L	-(A1),D0
	JSR	(A4)
lbC01D5B0
	MOVEA.L	($10,A2),A1
	MOVE.L	A1,D0
	BEQ.B	lbC01D5BC
	MOVE.L	-(A1),D0
	JSR	(A4)
lbC01D5BC
;	MOVEA.L	(4).W,A6
	move.l	(EXECBase,pc),a6
	MOVE.L	A2,D2	;seglist
	BEQ.B	lbC01D5D4
lbC01D5C4
	MOVEA.L	A2,A1
	dbug	<"bang">
	MOVEA.L	(seg_Next,A1),A2
;	illegal
	dbug	<"bing">
	ADDA.L	A2,A2
	ADDA.L	A2,A2
	MOVE.L	-(A1),D0
	JSR	(A4)	;FreeMem
	MOVE.L	A2,D0	;check next segment
	BNE.B	lbC01D5C4
lbC01D5D4
	MOVEM.L	(SP)+,D2/A2-A4/A6
	MOVEQ	#-1,D0
	RTS

lbC016082
;	MOVEA.L	(4).W,A0
	move.l	(EXECBase,pc),a0
	MOVEA.L	(ThisTask,A0),A0
	MOVEA.L	(pr_GlobVec,A0),A0
	MOVE.L	(516,A0),D0
	RTS

	ENDC


	ifeq	1
Flasher
	move.l	d0,-(sp)
	move.l	#$00020000,d0
.l	move.w	d0,$DFF180
	subq.l	#1,d0
	bne	.l
	move.l	(sp)+,d0
	rts
	endc


*******************************************************************************
exec_InternalUnLoadSeg
	move.l	d1,d0
	beq.b	.out

	SYSX	Forbid,EXECBase

	dbug	<"IUnLoad">
	movem.l	a1/d2,-(sp)
	tst.l	(RemCheck,pc)
	bne	.URP_ok

	moveq	#0,d2
.check
	lsl.l	#2,d0
	move.l	d0,a0
	move.l	(-4,a0),a1		; size
	add.l	a0,a1
	cmp.l	sp,a0
	bhi.b	.next1

	cmp.l	sp,a1
	blo.b	.next1

	moveq	#-1,d2
;	bsr	Flasher
	dbug	<"ISelf UnL">
.next1
	cmp.l	(8,sp),a0
	bhi.b	.next2

	cmp.l	(8,sp),a1
	blo.b	.next2

	moveq	#-1,d2
;	bsr	Flasher
	dbug	<"ISelf UnL">
.next2
	move.l	(a0),d0
	bne.b	.check

	tst.l	d2
	bne	.Change

	move.l	(EXECBase,pc),a0
	move.l	(ThisTask,a0),a0
	sub.l	a1,a1
;	move.l	($80,a0),d0		; pr_SegList
	move.l	(pr_SegList,a0),d0
	move.l	($C,a1,d0.l*4),d0	; BPTR [3]
	beq	.URP_ok

	tst.l	(a1,d0.l*4)		; test seglist
	bne	.URP_ok			; >1 segment is not CreateNewProc

	tst.l	(-4,a1,d0.l*4)		; 0,0 pair is CreateNewProc style
	bne	.URP_ok

; we have an unnatural seglist
	move.l	(8,sp),d0		; return address
	cmp.l	(DosStart,pc),d0
	blo	.URP_ok

	cmp.l	(DosEnd,pc),d0		; return address
	bhi	.URP_ok

;	bsr	Flasher
.Change
	dbug	<"INew_URP ">

	lea	(ChangeURP,pc),a0
	clr.w	(a0)
	move.l	d1,-(sp)
	move.l	a6,-(sp)
	move.l	(EXECBase,pc),a6
	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc
	bsr	UseFreeURP
	ifd	CPU68030
		addq.l	#8,sp
	endc
	move.l	(sp)+,a6
	move.l	(sp)+,d1

;insecure checks says that we will not remove our own code
.URP_ok
	dbug	<"Enter ">
	movem.l	(sp)+,d2/a1
	move.l	(OldInternalUnLoadSeg,pc),a0
	jsr	(a0)

	SYSX	Permit,EXECBase

	dbug	<"IUnL out">
.out
	ifd	Scratch
		move.l	#$bad10bad,d1
		move.l	d1,a0
		move.l	d1,a1
	endc	;
	rts

	endc



*******************************************************************************
; come and get me
;	ifeq	PatchRem_LD-1
	ifeq	0
	printx	"Full replace RemLibrary/RemDevice\n"
exec_RemLibrary
	SYS	Forbid
	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc

	bsr	UseFreeURP

	ifnd	CPU68030
		move.l	d0,-(sp)	; save current URP
	endc

	dbug	<"OldR 1 ">
	MOVEA.L	(ex_RamLibPrivate,A6),A0
	JSR	($1A+$12,A0)
	dbug	<"OldR 2 ">

	MOVE.L	D0,D1
	BEQ.B	lbC041D8E

	dbug	<"Doing UnL ">
	MOVE.L	A6,-(SP)
	MOVEA.L	(ex_RamLibPrivate,A6),A0
	MOVEA.L	(A0),A6
	JSR	(_LVOUnLoadSeg,A6)	;dos.library
	MOVEA.L	(SP)+,A6
	dbug	<"Did UnL ">
lbC041D8E
	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc

	SYS	Permit
	RTS

*******************************************************************************
exec_RemDevice
	SYS	Forbid
	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc

	bsr	UseFreeURP

	ifnd	CPU68030
		move.l	d0,-(sp)	; save current URP
	endc

	dbug	<"OldRd 1 ">
	MOVEA.L	(ex_RamLibPrivate,A6),A0
	JSR	($1A+12,A0)
	dbug	<"OldRd 2 ">

	MOVE.L	D0,D1
	BEQ.B	.lbC041D8E

	dbug	<"Doing UnL ">
	MOVE.L	A6,-(SP)
	MOVEA.L	(ex_RamLibPrivate,A6),A0
	MOVEA.L	(A0),A6
	JSR	(_LVOUnLoadSeg,A6)	;dos.library
	MOVEA.L	(SP)+,A6
	dbug	<"Did UnL ">
.lbC041D8E
	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc

	SYS	Permit
	RTS

	else

*******************************************************************************
*******************************************************************************
*******************************************************************************
*******************************************************************************
exec_RemDevice
;	SYS	Forbid
;	bsr	UseFreeURP
;	move.l	d0,-(sp)
	move.l	(OldRemDevice,pc),a0
;	jsr	(a0)
;	move.l	(sp)+,a0
;	bsr	UseNewURP
;	SYS	Permit
;	rts
	CMPNOPL
;	bra.b	do_Rem
	printx	"		Non-hacked RemDevice\n"


********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
exec_RemLibrary
	printx	"		Non-hacked RemLibrary\n"
	move.l	(OldRemLibrary,pc),a0
do_Rem
	move.l	#$001fffff,d0
.flash
	move.w	d0,COL00
	subq.l	#1,d0
	bpl.b	.flash

	move.l	a1,d0
	lea	(RemCheck,pc),a1
	addq.l	#1,(a1)
	move.l	d0,a1

	SYS	Forbid
	ifd	CPU68030
		subq.l	#8,sp
		move.l	sp,d0
	endc

	bsr	UseFreeURP

	ifnd	CPU68030
		move.l	d0,-(sp)	; save current URP
	endc

;	move.l	(OldRemLibrary,pc),a0
	jsr	(a0)
	ifd	CPU68030
		move.l	sp,a0
;/\/\/\/\
	else
		move.l	(sp)+,a0
	endc

	move.l	#$001fffff,d0
.flish
	move.w	#$0f00,COL00
	subq.l	#1,d0
	bpl.b	.flish

	bsr	UseNewURP

	ifd	CPU68030
		addq.l	#8,sp
	endc

	lea	(RemCheck,pc),a0
	subq.l	#1,(a0)

	SYS	Permit
	rts

	endc


	ifeq	1
DumpL
	psh.l	d0-a6
	lea	(Lstr,pc),a0
	bsr.b	DPutStr
	pll.l	d0-a6
	rts
Lstr	dc.b	"L",10,0,0

DumpD
	psh.l	d0-a6
	lea	(Dstr,pc),a0
	bsr.b	DPutStr
	pll.l	d0-a6
	rts
Dstr	dc.b	"D",10,0,0

StackDump
	psh.l	d0-a6
	move.l	(4*15,sp),a0
	move.l	a0,a1
.find0
	move.b	(a1)+,d0
	bne.b	.find0
	move.l	a1,(4*15,sp)
	bsr	DPutStr
	pll.l	d0-a6
	rts

DumpInfo
	psh.l	d0-a6
	move.l	a0,d0
	lea	(1+InfoString,pc),a0
	bsr	to_buf
	move.l	a1,d0
	lea	(11+InfoString,pc),a0
	bsr	to_buf
	move.l	a5,d0
	lea	(21+InfoString,pc),a0
	bsr	to_buf

	lea	(InfoString,pc),a0
	bsr	DPutStr

	pll.l	d0-a6
	rts

DPutStr
	MOVE.B	(A0)+,D0
	BEQ.B	ps1
	bsr	rawpr
	BRA.B	DPutStr
ps1
	RTS
rawpr
	MOVE.B	D0,-(SP)
	CMPI.B	#10,D0
	BNE.B	10$
	MOVEQ	#13,D0
	BSR.B	20$
	TST.B	($BFD000).L
10$	MOVE.B	(SP)+,D0
20$	TST.B	($BFD000).L
	TST.B	($BFD000).L
30$	BTST	#0,($BFD000).L
	BNE.B	30$
	MOVE.B	#$FF,($BFE301).L
	MOVE.B	D0,($BFE101).L
	TST.B	($BFD000).L
	TST.B	($BFD000).L
	RTS

to_buf
	LongToString	d0,d1,a0
	rts
InfoString	dc.b	"$01234567 $01234567 $01234567",13,10,0
	even
Nybble2Ascii	NYBBLE2ASCII

	endc

*	ifd	CPU68030
*A_Shadow	ds.l	ASIZE
*	endc

	ifd	ENFORCER
PSR_030	dc.l	0
	cnop	0,4
TC_030	dc.l	$80f08630
CRP_030	dc.l	$000f0002,$07fff140
	endc

RemCheck	dc.l	0
DosStart	dc.l	0
DosEnd		dc.l	0
ChangeURP	dc.w	$ffff
NewStack
	dx.b	$2000
End
