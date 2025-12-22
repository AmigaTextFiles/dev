; adfreader.asm - essential functionality for game disk installers.
; Supports Amiga Disk Files instead of trackdisk
; © 1998-1999 Kyzer/CSG

	IFND	FILEMODE
FILEMODE=0
	ENDC
	IFND	MESSAGES
MESSAGES=0
	ENDC

	IFD	NO_INCLUDES
MODE_OLDFILE=1005		; from dos/dos.i
MODE_NEWFILE=1006
OFFSET_BEGINNING=-1
ERROR_NOT_A_DOS_DISK=225
_LVOOpen=-30			; from dos/dos_lib.i
_LVOClose=-36
_LVORead=-42
_LVOWrite=-48
_LVOSeek=-66
_LVOIoErr=-132
_LVOSetIoErr=-462
_LVOPrintFault=-474
_LVOReadArgs=-798
_LVOFreeArgs=-858
_LVOPutStr=-948
_LVOVPrintf=-954
_LVOCloseLibrary=-414		; from exec/exec_lib.i
_LVODoIO=-456
_LVOOpenLibrary=-552
	ELSE
	include	dos/dos.i
	include	dos/dos_lib.i
	include	exec/exec_lib.i
	ENDC

DOSTRACKLEN=512*11

BUFFER	MACRO	; buffername
\1	equ	__trk
	ENDM

FAILURE	MACRO	; [reason]
	IFEQ	NARG
	suba.l	a0,a0
	ELSE
	lea	\1,a0
	ENDC
	bra	__fail
	ENDM

RAWREAD	MACRO	; track
	lea	__trk,a0
	move.l	\1,d0
	bsr	__rawrd
	ENDM
RESYNC	MACRO	; wordsync
	lea	__trk,a0
	move.l	\1,d0
	bsr	__sync
	ENDM
DOSREAD	MACRO	; track
	lea	__trk,a0
	move.l	\1,d0
	bsr	__dosrd
	ENDM

	IFEQ	FILEMODE
WRITE	MACRO	; length, [offset]
	IFEQ	NARG-2
	lea	__trk,a0
	add.l	\2,a0
	ELSE
	lea	__trk,a0
	ENDC
	move.l	\1,d0
	bsr	__write
	ENDM

WRITEDOS MACRO	; track
	DOSREAD	\1
	WRITE	#DOSTRACKLEN
	ENDM

	ELSE
SAVEF	MACRO	; filename, buffer, length
	lea	\1,a0
	lea	\2,a1
	move.l	\3,d0
	bsr	__savef
	ENDM
	ENDC

;------------------------------------

call	macro
	jsr	_LVO\1(a6)
	endm

initstk	macro	; stack_symbol, stackreg
	link	\2,#\1
	move.l	sp,a0
.clr\@	clr.w	(a0)+
	cmp.l	a0,\2
	bne.s	.clr\@
	endm

stackf	MACRO	; stack_symbol, stackelement_symbol, [size=4]
	IFND	\1
\1	set	0
	ENDC
	IFGE	NARG-3
\1	set	\1-(\3)
	ELSE
\1	set	\1-4
	ENDC
\2	equ	\1
	ENDM

	IFNE	FILEMODE
	stackf	stk, __adfname
__args=__adfname
__nargs=1
__tmpl	macro
	dc.b	'ADF/A',0
	endm
	ELSE
	stackf	stk, __output
	stackf	stk, __adfname
__args=__adfname
__nargs=2
__tmpl	macro
	dc.b	'ADF/A,OUTPUT/A',0
	endm
	ENDC

	stackf	stk, __rdargs	; returned by ReadArgs()
	stackf	stk, __adffh	; input filehandle
	stackf	stk, __outfh	; output filehandle (NULL in filemode)
	stackf	stk, __initsp	; initial (sp): move to sp then rts to quit
	stackf	stk, __reason	; ptr to textual reason for failure, or NULL
	stackf	stk, execbase	; exec.library
	stackf	stk, dosbase	; dos.library

	stackf	stk, __sltab, 160*4	; sync and length table
	stackf	stk, __otab,  160*4	; offset table


	section	diskreader,code
	link	a5,#stk
	move.l	4.w,a6
	move.l	a6,execbase(a5)

	suba.l	a1,a1
	jsr	-$126(a6)
	move.l	d0,a0
	lea	$94(a0),a0

	clr.l	__reason(a5)
	moveq	#100,d7

	moveq	#37,d0
	lea	__dosnm(pc),a1
	call	OpenLibrary
	move.l	d0,dosbase(a5)
	beq	.nodos
	move.l	d0,a6

	lea	__templ(pc),a0
	move.l	a0,d1
	lea	__args(a5),a0
	move.l	a0,d2
	REPT	__nargs
	clr.l	(a0)+
	ENDR
	moveq	#0,d3
	call	ReadArgs
	move.l	d0,__rdargs(a5)
	beq	.noargs

	IFEQ	FILEMODE
	move.l	__output(a5),d1
	move.l	#MODE_NEWFILE,d2
	call	Open
	move.l	d0,__outfh(a5)
	beq	.nofile
	ENDC

	; open ADF file
	move.l	__adfname(a5),d1
	move.l	#MODE_OLDFILE,d2
	call	Open
	move.l	d0,__adffh(a5)
	beq	.noadf

	move.l	d0,d4
	lea	__sltab(a5),a2

	; check ADF header

	move.l	d4,d1
	move.l	a2,d2
	moveq	#8,d3
	call	Read
	tst.l	d0
	bmi.s	.notadf
	cmp.l	#"UAE-",(a2)
	bne.s	.notext
	cmp.l	#"-ADF",4(a2)
	bne.s	.notext

	; read sync/len table
	move.l	d4,d1
	move.l	a2,d2
	move.l	#160*4,d3
	call	Read
	tst.l	d0
	bmi.s	.notadf

	; fill offsets table
	lea	(8+160*4).w,a0	; track 0 data immediately follows table/header
	lea	__otab(a5),a1
	move.w	#160-1,d0
	moveq	#0,d1
.loop	move.l	a0,(a1)+	; put offset
	move.l	(a2)+,d1
	adda.w	d1,a0		; add length of track to offset
	dbra	d0,.loop
	bra.s	.begin

.notext	lea	DOSTRACKLEN.w,a3	; also support DOS-only ADFs
	lea	__otab(a5),a1
	move.w	#160-1,d0
.loop2	move.l	a3,(a2)+	; sync=$0000, length=DOSTRACKLEN
	move.l	a0,(a1)+	; put offset
	add.l	a3,a0
	dbra	d0,.loop2

.begin	bsr	__main

	move.l	dosbase(a5),a6

	IFNE	MESSAGES
	pea	10<<24
	move.l	sp,d1
	call	PutStr	; print a newline
	addq.l	#4,sp
	ENDC

.notadf	move.l	__adffh(a5),d1
	call	Close
.noadf
	IFEQ	FILEMODE
	move.l	__outfh(a5),d1
	call	Close
.nofile
	ENDC
	move.l	__rdargs(a5),d1
	call	FreeArgs
.noargs	moveq	#0,d7	 	; returncode = 0
	call	IoErr
	move.l	d0,d1
	beq.s	.nofail
	bpl.s	.real		; sometimes Read() sets error to -1
	moveq	#0,d1
	bra.s	.nofail
.real	moveq	#20,d7		; returncode = 20
.nofail	move.l	__reason(a5),d2
	call	PrintFault

	move.l	a6,a1
	move.l	execbase(a5),a6
	call	CloseLibrary
.nodos	move.l	d7,d0
	unlk	a5
	rts

	IFNE	MESSAGES
__prtrk	movem.l	d0-d2/a0,-(sp)
	lea	__msg(pc),a0
	move.l	a0,d1
	move.l	sp,d2	; points at D0 on the stack
	move.l	dosbase(a5),a6
	call	VPrintf
	movem.l	(sp)+,d0-d2/a0
	rts
	ENDC

;------------------------------------
; a0 = buffer, d0 = track
__dosrd	movem.l	d2/d3/a2/a3/a6,-(sp)
	IFNE	MESSAGES
	bsr.s	__prtrk
	ENDC
	add.l	d0,d0
	add.l	d0,d0
	lea	__sltab(a5),a2
	lea	__otab(a5),a3

	tst.w	(a2,d0.w)
	beq.s	__rdcom	; continue if DOS track
__rdfai	lea	errtrk(pc),a0
	bra.s	__fail
	
;------------------------------------
; a0 = buffer, d0 = track
__rawrd	movem.l	d2/d3/a2/a3/a6,-(sp)
	IFNE	MESSAGES
	bsr.s	__prtrk
	ENDC
	add.l	d0,d0
	add.l	d0,d0
	lea	__sltab(a5),a2
	lea	__otab(a5),a3

	move.w	(a2,d0.w),(a0)+
	beq.s	__rdfai		; fail if DOS track

__rdcom	move.w	d0,-(sp)
	move.l	__adffh(a5),d1
	move.l	(a3,d0.w),d2		; get offset in disk file
	moveq	#OFFSET_BEGINNING,d3
	move.l	dosbase(a5),a6
	move.l	a0,-(sp)
	call	Seek
	move.l	__adffh(a5),d1
	move.l	(sp)+,d2
	moveq	#0,d3
	move.w	(sp)+,d3
	move.w	2(a2,d3.w),d3
	call	Read
	tst.l	d0
	bmi.s	__rdfai
	movem.l	(sp)+,d2/d3/a2/a3/a6
	rts

;------------------------------------
; a0 = failure reason
__fail	move.l	a0,d0
	beq.s	.noreas
	move.l	d0,__reason(a5)
	move.l	dosbase(a5),a6
	move.l	#ERROR_NOT_A_DOS_DISK,d1
	call	SetIoErr
.noreas	move.l	__initsp(a5),sp
	rts

	IFNE	FILEMODE
;------------------------------------
; a0 = filename, a1 = buffer, d0 = length
__savef	movem.l	d2-d4/a6,-(sp)
	move.l	a0,d1
	move.l	a1,d3	; d3 = buffer
	move.l	d0,d4	; d4 = length
	move.l	#MODE_NEWFILE,d2
	move.l	dosbase(a5),a6
	call	Open
	move.l	d0,d1	; d1 = filehandle
	move.l	d3,d2	; d2 = buffer
	move.l	d4,d3	; d3 = length
	move.l	d0,d4	; d4 = filehandle
	beq.s	__fail
	call	Write
	move.l	d0,d3
	move.l	d4,d1
	call	Close
	tst.l	d3
	bmi.s	__fail
	movem.l	(sp)+,d2-d4/a6
	rts

	ELSE
;------------------------------------
; a0 = buffer, d0 = length
__write	movem.l	d2-d3/a6,-(sp)
	move.l	a0,d2
	move.l	d0,d3
	move.l	__outfh(a5),d1
	move.l	dosbase(a5),a6
	call	Write
	tst.l	d0
	bmi.s	__fail
	movem.l	(sp)+,d2-d3/a6
	rts
	ENDC

;------------------------------------
; a0 = buffer d0 = sync

__sync	movem.l	d2-d3,-(sp)
	move.l	a0,a1
	subq	#2,a0
	beq.s	.done
	move.w	#($7ffe/2)-1,d2		; search entire trackbuffer
.nxtwrd	moveq	#16-1,d3		; find a BIT distance... (0-15)
.nxtbit	move.l	(a0),d1			; and a BYTE distance.. (0-$7ffe)
	lsr.l	d3,d1
	cmp.w	d0,d1			; ... for which we find the SYNCWORD
	beq.s	.synced
	dbra	d3,.nxtbit
	addq.l	#2,a0
	dbra	d2,.nxtwrd
	lea	.err(pc),a0		; searched through all 32k...
	bra.s	__fail			; ...no sync marker found

.synced	move.l	(a0),d1			; match; now we shift all the remaining
	addq.l	#2,a0			; trackdata backwards by this BIT and
	lsr.l	d3,d1			; BYTE distance, so the first word in
	move.w	d1,(a1)+		; the trackbuffer is the SYNCWORD
	dbra	d2,.synced
	movem.l	(sp)+,d2-d3
.done	rts
.err	dc.b	"can't find sync mark",0
errtrk	dc.b	"can't read track",0
__dosnm	dc.b	"dos.library",0
__templ	__tmpl
	IFNE	MESSAGES
__msg	dc.b	"reading track %ld",13,0
	ENDC

	cnop	0,4

	; create 32kb CHIP BSS hunk for trackbuffer
	section	trackbuf,bss,chip
__trk	ds.b	$7ffe

	; return to main code section
	section	diskreader,code
__main	move.l	sp,__initsp(a5)
