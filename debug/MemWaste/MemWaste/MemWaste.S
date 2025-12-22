* MemWaste
*
* (c) 1992 Thies Wellpott
*
* MemWaste allocates all fast memory but a number of bytes you may specify.
* This memory block can be freed with another call of MemWaste.
* Usefull if you do not want to waste 32BitRAM for your 1 MB RAD:.
*
* History
*
* V1.0  6.10.92
*   first version
*


	opt A+,O+

	incdir "ram:include/"
	include "exec_lib.i"
	include "dos_lib.i"

CALLLIB MACRO
	jsr	_LVO\1(a6)
	ENDM


START
	movea.l	a0,a2			;save a0
	clr.b	-1(a0,d0)		;remove CR

	lea	DOSName(pc),a1
	moveq	#0,d0
	CALLEXEC OpenLibrary
	move.l	d0,DOSBase
	beq.s	ende1

	move.b	(a2),d0
	cmp.b	#'f',d0
	beq.s	free
	cmp.b	#'F',d0
	beq.s	free
	cmp.b	#'1',d0
	blo.s	usage
	cmp.b	#'9',d0
	bhi.s	usage
	bra	get

ende2:
	movea.l	DOSBase(pc),a1
	CALLEXEC CloseLibrary
ende1:	moveq	#0,d0
	rts


usage:
	CALLDOS Output
	move.l	d0,d1
	move.l	#usage_txt,d2
	move.l	#usage_len,d3
	CALLLIB Write
	bra.s	ende2


free:
	move.l	#filename,d1
	move.l	#1005,d2		;MODE_OLDFILE
	CALLDOS Open
	move.l	d0,d4			;d4: FHd
	beq.s	ende2

	move.l	d4,d1
	lea	buffer(pc),a2		;a2: buffer
	move.l	a2,d2
	moveq	#8,d3
	CALLLIB Read
	cmp.l	#8,d0
	bne.s	.error

	move.l	d4,d1
	CALLLIB Close
	move.l	#filename,d1
	CALLLIB DeleteFile

	move.l	(a2),a1
	move.l	4(a2),d0
	CALLEXEC FreeMem

	bra.s	ende2
.error
	move.l	d4,d1
	CALLLIB Close
	bra	ende2


get:
	move.l	a2,a0
	bsr.s	atod
	move.l	d0,d2

	move.l	#$20005,d1		;FAST+LARGEST+PUBLIC
	CALLEXEC AvailMem
	sub.l	d2,d0
	lea	buffer(pc),a2		;a2: buffer
	move.l	d0,4(a2)

	move.l	#$20005,d1		;FAST+LARGEST+PUBLIC
	CALLLIB AllocMem
	move.l	d0,(a2)
	beq	ende2

	move.l	#filename,d1
	move.l	#1006,d2		;MODE_NEWFILE
	CALLDOS Open
	move.l	d0,d4			;d4: FHd
	beq.s	.error2

	move.l	d4,d1
	move.l	a2,d2
	moveq	#8,d3
	CALLLIB Write
	cmp.l	#8,d0
	bne.s	.error

	move.l	d4,d1
	CALLLIB Close

	bra	ende2
.error
	move.l	d4,d1
	CALLDOS Close
.error2
	move.l	(a2),a1
	move.l	4(a2),d0
	CALLEXEC FreeMem
	bra	ende2


;Dez.-String (bis Zeichen < '0' oder > '9') -> 32-Bit-Zahl
atod:	;a0: String, => d0.l: Zahl
	moveq	#0,d0
1$	move.b	(a0)+,d1
	subi.b	#'0',d1
	cmpi.b	#10,d1
	bhs.s	2$
	move.l	d0,d2
	lsl.l	#3,d0
	add.l	d2,d0
	add.l	d2,d0
	add.b	d1,d0
	bra.s	1$
2$	rts


;***** Daten

version: dc.b 0,"$VER: MemWaste V1.0 (6.10.92)",0
usage_txt: dc.b $9b,"4mMemWaste V1.0",$9b,"0m (c) 1992 Thies Wellpott",$a,$a
	dc.b "Usage: MemWaste <bytes>|F[REE]",$a
	dc.b "   bytes   number of bytes to leave available (decimal)",$a
	dc.b "   F[REE]  free latest allocated memory",$a
usage_len = *-usage_txt
DOSName: dc.b "dos.library",0
	even
DOSBase: dc.l 0
filename: dc.b "T:MemWaste.xyq",0
	even
buffer:	dc.l 0		; MemBlk
	dc.l 0		; MemSize

