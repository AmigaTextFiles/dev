**
**	VBR - Revision 2
** Switches the Vector Base to
**	Chip- or Fast-RAM
**
**  Coded by Frank Wille 1994
**
**   Assembler: PhxAss V4.xx
**

	machine 68010			; 'cause of VBR

	incdir	"include"
**  You should also define an include path for your Commodore **
** includes or make use of the PHXASSINC environment variable **
	include "lib/exec.i"
	include "lib/dos.i"
	include "exec/execbase.i"
	include "exec/memory.i"

VBR_SIZE	= $400			; size of vector base area in bytes



	code


	move.l	ExecBase.w,a6
	lea	DosName(pc),a1
	moveq	#37,d0
	jsr	OpenLibrary(a6) 	; open dos.library (OS2.04)
	tst.l	d0
	beq	error
	move.l	d0,a4			; a4 DOSBase
	moveq	#0,d6			; d6 Quiet-Flag
	moveq	#0,d7			; d7 VBR-Flag (1=Zero, -1=Fast)
	exg	a4,a6
	lea	cmd_template(pc),a0
	move.l	a0,d1
	clr.l	-(sp)
	clr.l	-(sp)
	clr.l	-(sp)
	move.l	sp,d2
	moveq	#0,d3
	jsr	ReadArgs(a6)
	move.l	d0,d1			; ReadArgs-Error?
	bne.s	1$
	lea	12(sp),sp
	jsr	IoErr(a6)
	move.l	d0,d1
	moveq	#0,d2
	jsr	PrintFault(a6)		; print error message
	exg	a4,a6
	bra	exit
1$:	jsr	FreeArgs(a6)
	tst.l	(sp)+			; VBR ZERO?
	beq.s	2$
	moveq	#1,d7			; d7 Zero-VBR
	addq.l	#4,sp
	bra.s	3$
2$:	tst.l	(sp)+			; VBR FAST?
	sne	d7
3$:	tst.l	(sp)+			; QUIET-Mode?
	sne	d6
	exg	a4,a6
	moveq	#0,d5
	move.b	AttnFlags+1(a6),d0	; which processor is installed?
	moveq	#3,d1
4$:	lsr.b	#1,d0
	bcc.s	5$
	add.w	#10,d5
	dbf	d1,4$
	tst.b	AttnFlags+1(a6) 	; 68060?
	bpl.s	5$
	add.w	#20,d5
5$:	sub.l	a2,a2
	tst.w	d5			; 68000? (no VBR available)
	beq.s	6$
	lea	getVBR(pc),a5
	jsr	Supervisor(a6)		; read VBR -> a2
	move.l	#VBR_SIZE,d2
	tst.b	d7			; change it?
	beq.s	6$
	bsr.s	changeVBR
6$:	tst.b	d6			; print new VBR and processor type
	bne.s	exit
	exg	a4,a6
	move.l	a2,-(sp)
	add.l	#68000,d5
	move.l	d5,-(sp)
	lea	vbr_info(pc),a0
	move.l	a0,d1
	move.l	sp,d2
	jsr	VPrintf(a6)
	addq.l	#8,sp
	exg	a4,a6
exit:	move.l	a4,a1
	jsr	CloseLibrary(a6)
	moveq	#0,d0
	rts
error:	moveq	#20,d0			; Error!
	rts


changeVBR:
	bmi.s	1$
	move.l	a2,d0			; copy VBR to $00000000
	beq.s	3$			; already there?
	moveq	#0,d0
	bra.s	2$
1$:	move.l	a2,a1			; copy VBR to FAST-Ram
	jsr	TypeOfMem(a6)
	btst	#MEMB_FAST,d0		; already located in FAST-Ram?
	bne.s	3$
	move.l	d2,d0
	moveq	#MEMF_FAST|MEMF_PUBLIC,d1
	jsr	AllocMem(a6)		; allocate Fast-Ram for VBR
	tst.l	d0
	beq.s	3$			; out of memory?
2$:	move.l	d0,a3
	move.l	a2,a0
	move.l	d0,a1
	move.l	d2,d0
	jsr	CopyMem(a6)
	move.l	a2,-(sp)
	move.l	a3,a2
	lea	setVBR(pc),a5
	jsr	Supervisor(a6)		; activate new VBR
	jsr	CacheClearU(a6)
	move.l	(sp)+,d0
	bne.s	4$
3$:	rts
4$:	move.l	d0,a1			; free old VBR (except for Zero-VBRs)
	move.l	d2,d0
	jmp	FreeMem(a6)


getVBR:
	movec	VBR,a2
	rte

setVBR:
	movec	a2,VBR
	rte


DosName:
	dc.b	"dos.library",0
cmd_template:
	dc.b	"ZERO/S,FAST/S,QUIET/S",0
vbr_info:
	dc.b	"cpu: %ld  vbr: $%08lx\n",0

	end
