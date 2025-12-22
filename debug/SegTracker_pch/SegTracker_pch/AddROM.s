****************************************************************************
*** AddROM routine of SegTracker V37.76
*** written by Mikolaj Calusinski <bloelle@priv.gold.pl>
*** based on original work of Michael Sinz <Enforcer@sinz.org>
***
*****************************************************************************
*                                                                           *
* Permission is hereby granted to distribute this source for non-commercial *
* purposes so long as its contents is not modified in any way.              *
*                                                                           *
*****************************************************************************

;ROM scan routine
;rewritten to support KickTags and Kickstart ROM extension tables -MM

AddROM	movem.l	d3-D7/A2-A6,-(SP)
	movea.l	(4).W,A6

;HACK!!! - try to locate private Kickstart modules table
;Algorithm is based on fact that in all current Kickstarts this table starts
;with main Kickstart start address followed by upper address of the chunk
;which should be $1000000. Such an assumption is *extremely* ugly but there
;seems to be no other way to properly register all KS ROM modules. :(((
;The table is terminated by $ffffffff longword

;first try to figure out our current ROM address, so fetch ptr to name of
;exec.library which must be somewhere in the lower ROM area

	move.l	(LIB_IDSTRING,A6),D0
;	clr.w	D0		this should give us start of ROM

;unfortunately, this is not true for exec45 loaded via SetPatch
;so, to find Kickstart ROMTag search table, it is assumed that main ROMTag
;search table ends at $1000000 address and that it is located after exec id
;string. Heck, what a hack. ;/

	andi.b	#$fe,d0		ensure id ptr is evenly aligned
	movea.l	d0,a3
\s1	cmpi.w	#$100,(a3)+
	bne	\s1
	tst.w	(a3)
	bne	\s1
	subq.l	#6,a3		ptr to ROMTag search table
	movea.l	(a3),a4		start of main KS ROM
	move.l	a3,d6		save table ptr

.nxt	move.l	(a3),d0		fetch start address of the area
	not.l	d0		is it table terminator?
	beq	_kickm		tablewalk completed, skip to KickTagPtr scan routine
	movea.l	(a3)+,a4	get lower addr of this area
	move.l	(a3)+,d7	max upper address to search in the area
	cmpa.l	#$f00000,a4	F-space?
	bne	.doit
	tst.l	($140,sp)	FSPACE?
	beq	.nxt
.doit	suba.l	A5,A5

;workaround for IO hardware extensions, like Blizzard SCSI chip in F-space:
;if there's not a valid ROMTag structure within first 64kb of area, it is
;assumed to be invalid and is skipped

;problem is that Blizzard SCSI places some ROM in F-space first, followed by
;IO registers. Urgh. Added FSPACE switch.

	moveq	#1,d3
	swap	d3
	add.l	a4,d3

.srch2	cmp.l	a4,d3
	bhi	\1
	move.l	a5,d0		any ROMTag has been found?
	beq	.nxt		no, so skip this area
\1	cmp.l	a4,d7		search in the area completed?
	bls	.end		yeah, so skip to the next
	cmpi.w	#RTC_MATCHWORD,(A4)+	look for the magic word
	bne	.srch2
	lea	(-2,a4),a2
	cmpa.l	(a4)+,a2	really ROMTag?
	bne	.srch2
	movea.l	(RT_IDSTRING,a2),A1	id string of this module
	movea.l	(A4),a4		load endskip for next search
	move.l	a4,d0
	lsr.b	#1,d0
	bcc	.even
	addq.l	#1,a4
.even	movea.l	a1,a0
	moveq	#'(',d1
.l	move.b	(a0)+,d0
	beq	.srch2		weird module name, skip it
	cmp.b	d0,d1
	bne	.l

;add this module to the list

	move.l	A5,D0
	beq	.fm		first module on list
	move.l	A2,D0
	sub.l	(12,A5),D0
	move.l	D0,(16,A5)	entry: size
.fm	movea.l	A1,A0
.sz	tst.b	(A0)+
	bne	.sz
	suba.l	A1,A0
	moveq	#34,D0	minnode(8)+name ptr(4)+entry terminator(8)+entry(8)+'ROM - ' string (6)
	add.l	a0,D0	+ zero terminated name length
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,D1
	sys	AllocVec
	movea.l	D0,A5
	tst.l	D0
	beq	.srch2

	move.l	A2,(12,A5)	entry: start address
	lea	($1C,A5),A0
	move.l	A0,(8,A5)	name ptr to this entry

	lea	(ROM.MSG,PC),A1
.cni	move.b	(A1)+,(A0)+	copy 'ROM - ' name introducer
	bne.b	.cni
	subq.l	#1,a0

	movea.l	(RT_IDSTRING,a2),A1	id string of this module
	moveq	#32,D1
.skip	move.b	(A1)+,D0
	beq	.add
	cmp.b	D1,D0
	blt.b	.skip
	move.b	D0,(A0)+
	bra	.skip

.add	lea	(_list,pc),A0
	movea.l	A5,A1
	sys	AddTail
	bra	.srch2

.end	move.l	A5,D0
	beq	.nxt
	sub.l	(12,A5),D7
	move.l	D7,(16,A5)
	bra	.nxt

;KickTagPtr scan routine - here all those RAM replacement modules are added

_kickm	movea.l	(ResModules,A6),a4
	move.l	(KickMemPtr,a6),d7
	beq	_done

.next	move.l	(a4)+,d0	get module
	beq	_done
	bclr	#31,d0
	beq	\do
	movea.l	d0,a4
	bra	.next

;first check if our module lays in ROM tables (if so - skip it as it must have
;been added above already)

\do	movea.l	d6,a0		check if it is inside of ROM tables
.c	cmp.l	(a0),d0
	bcs	.l
	cmp.l	(4,a0),d0
	bls	.next
.l	addq.l	#8,a0
	move.l	(a0),d1
	not.l	d1		table terminator?
	bne	.c

;our module is not inside ROM areas, so let's look at it a little closer

	movea.l	d0,a0
	cmpi.w	#RTC_MATCHWORD,(A0)	does it have the magicword?
	bne	.next
	cmpa.l	(2,a0),a0	really ROMTag?
	bne	.next

;seems it has a valid ROMTag, so process it

.nl	movea.l	d0,a3
	movea.l	(RT_IDSTRING,A3),a1	id string of this resident
	move.l	a1,d2
	beq	.noid
.sz	tst.b	(a1)+
	bne	.sz
	suba.l	d2,a1
	move.l	a1,d3
	subq.l	#1,d3
	bne	.isn

;hmm, this module has no id string, so try the name field

.noid	movea.l	(RT_NAME,A3),a1	try name string of this resident
	move.l	a1,d2
	beq	.non
.sz2	tst.b	(a1)+
	bne	.sz2
	suba.l	d2,a1
	move.l	a1,d3
	subq.l	#1,d3
	bne	.isn

;no name either??? Use '<Unnamed>' string then (should never happen)

.non	lea	(_unn,pc),a1
	move.l	a1,d2
	moveq	#ns,d3

;now we're going to determine the number of hunks (sections) this module has
;so KickMemPtr is analyzed

.isn	move.l	d7,d0		analyze KickMemPtr
.nmeml	movea.l	d0,a2
	lea	(14,a2),a1
	move.w	(a1)+,d0	numentries
	moveq	#0,d5
	move.w	d0,d5
	subq.w	#1,d0

.loop	move.l	(a1),d1		entry start address
	cmpa.l	d1,a3
	bcs	.lp
	add.l	(4,a1),d1	entry upper address
	cmpa.l	d1,a3
	bls	.ok
.lp	addq.l	#8,a1
	dbf	d0,.loop
	move.l	(a2),d0		next memlist
	bne	.nmeml
	bra	.next

.ok	moveq	#31,D0	minnode(8)+name ptr(4)+entry terminator(8)+'KickTag - ' string (10)
	add.l	d3,D0	+ zero terminated name length
	lsl.l	#3,d5	8 * number of mementries (sections)
	add.l	d5,d0
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,D1
	sys	AllocVec
	movea.l	D0,A5
	tst.l	D0
	beq	.next

	lea	(14,a2),a1
	move.w	(a1)+,d1
	lea	(20,a5,d5.l),a2
	lea	(8,a5),a0
	move.l	A2,(A0)+	name ptr to this entry
	subq.w	#1,d1

.lp2	move.l	(a1)+,(a0)+	entry: start address
	move.l	(a1)+,(a0)+	entry: size
	dbf	d1,.lp2
	
	lea	(_kick.msg,PC),A1
.cni	move.b	(A1)+,(A2)+	copy 'KickTag - ' name introducer
	bne.b	.cni
	subq.l	#1,a2

	movea.l	d2,A1		final name of this module
	moveq	#32,D1
.skip	move.b	(A1)+,D0
	beq	.add
	cmp.b	D1,D0
	blt.b	.skip
	move.b	D0,(A2)+
	bra	.skip

.add	lea	(_list,pc),A0
	movea.l	A5,A1
	sys	AddTail
	bra	.next

_done	movem.l	(SP)+,d3-D7/A2-A6
	rts
