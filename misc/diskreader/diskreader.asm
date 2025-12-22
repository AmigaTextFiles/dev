; diskreader.asm - essential functionality for game disk installers.
; © 1998-2000 Kyzer/CSG

; FILEMODE means that no output diskfile will be used, therefore WRITE is
; dropped - instead, SAVEF is used to write individual files
	IFND	FILEMODE
FILEMODE=0
	ENDC

; TRACKMODE means that all tracks are DOS tracks, so the user specifies
; the trackdisk-like device on the command line, and RAWREAD/RESYNC are 
; dropped
	IFND	TRACKMODE
TRACKMODE=0
	ENDC

; MESSAGES means that each track read will print out its number for the
; user to see.
	IFND	MESSAGES
MESSAGES=0
	ENDC

; NO_INCLUDES means that no system includes are neccessary to use diskreader
	IFD	NO_INCLUDES
IO_COMMAND=28			; from devices/trackdisk.i
IO_FLAGS=30
IO_LENGTH=36
IO_DATA=40
IO_OFFSET=44
IOTD_SIZE=56
CMD_READ=2
TD_MOTOR=9
TD_RAWREAD=16
IOTDB_INDEXSYNC=4
MODE_NEWFILE=1006		; from dos/dos.i
ERROR_NOT_A_DOS_DISK=225
_LVOOpen=-30			; from dos/dos_lib.i
_LVOClose=-36
_LVOWrite=-48
_LVOIoErr=-132
_LVOPrintFault=-474
_LVOReadArgs=-798
_LVOFreeArgs=-858
_LVOPutStr=-948
_LVOVPrintf=-954
_LVOCloseLibrary=-414		; from exec/exec_lib.i
_LVOOpenDevice=-444
_LVOCloseDevice=-450
_LVODoIO=-456
_LVOOpenLibrary=-552
_LVOCreateIORequest=-654
_LVODeleteIORequest=-660
_LVOCreateMsgPort=-666
_LVODeleteMsgPort=-672
	ELSE
	include	devices/trackdisk.i
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

	IFEQ	TRACKMODE
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
	ENDC
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

; create appropriate command line arguments based on FILEMODE/TRACKMODE
	IFNE	FILEMODE
	IFNE	TRACKMODE

	; filemode on, trackmode on
	stackf	stk, __unit
	stackf	stk, __device
__args=__device
__nargs=2
__tmpl	macro
	dc.b	"DEVICE/A,UNIT/N/A",0
	endm

	ELSE

	; filemode on, trackmode off
	stackf	stk, __unit
__args=__unit
__nargs=1
__tmpl	macro
	dc.b	"UNIT/N/A",0
	endm

	ENDC
	ELSE
	IFNE	TRACKMODE

	; filemode off, trackmode on
	stackf	stk, __unit
	stackf	stk, __device
	stackf	stk, __output
__args=__output
__nargs=3
__tmpl	macro
	dc.b	"DISKFILE/A,DEVICE/A,UNIT/N/A",0
	endm

	ELSE

	; filemode off, trackmode off
	stackf	stk, __unit
	stackf	stk, __output
__args=__output
__nargs=2
__tmpl	macro
	dc.b	"DISKFILE/A,UNIT/N/A",0
	endm

	ENDC
	ENDC

; other variables used

	stackf	stk, __rdargs	; returned by ReadArgs()
	stackf	stk, __diskport	; replyport for diskio
	stackf	stk, __diskio	; IORequest to trackdisk.device
	stackf	stk, __outfh	; output filehandle (NULL in filemode)
	stackf	stk, __initsp	; initial (sp): move to sp then rts to quit
	stackf	stk, __reason	; ptr to textual reason for failure, or NULL
	stackf	stk, __ioerr	; a particular error code, overriding IoErr()
	stackf	stk, execbase	; exec.library
	stackf	stk, dosbase	; dos.library

;------------------------------------

	section	diskreader,code
	link	a5,#stk
	move.l	4.w,a6
	move.l	a6,execbase(a5)

; no printable reason for failure, but start with errorcode
; incase we can't open DOS

	clr.l	__reason(a5)
	clr.l	__ioerr(a5)
	moveq	#100,d7

; open dos.library
	moveq	#37,d0
	lea	__dosnm(pc),a1
	call	OpenLibrary
	move.l	d0,dosbase(a5)
	beq	.nodos
	move.l	d0,a6

; read arguments on command line
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

; create the output diskfile (unless FILEMODE)
	IFEQ	FILEMODE
	move.l	__output(a5),d1
	move.l	#MODE_NEWFILE,d2
	call	Open
	move.l	d0,__outfh(a5)
	beq.s	.nofile
	ENDC

; open trackdisk.device (or user-specified in TRACKMODE)
	move.l	#ERROR_DEVICE_NOT_MOUNTED,__ioerr(a5)
	move.l	execbase(a5),a6
	call	CreateMsgPort
	move.l	d0,__diskport(a5)
	beq.s	.noport

	move.l	d0,a0
	moveq	#IOTD_SIZE,d0
	call	CreateIORequest
	move.l	d0,__diskio(a5)
	beq.s	.noio

	move.l	d0,a1
	move.l	__unit(a5),a0
	move.l	(a0),d0
	IFNE	TRACKMODE
	move.l	__device(a5),a0
	ELSE
	lea	__tdnm(pc),a0
	ENDC
	moveq	#0,d1
	call	OpenDevice
	tst.l	d0
	bne.s	.nodev
	clr.l	__ioerr(a5)

;--------------------------------------
; call and return from the main 'slave'
	bsr	__main
;--------------------------------------


; if messages mode, advance to new line for clarity
	IFNE	MESSAGES
	pea	10<<24	; "\n\0\0\0"
	move.l	sp,d1
	move.l	dosbase(a5),a6
	call	PutStr	; print a newline
	addq.l	#4,sp
	ENDC

; turn off disk motor
	move.l	__diskio(a5),a1
	move.w	#TD_MOTOR,IO_COMMAND(a1)
	clr.l	IO_LENGTH(a1)
	move.l	execbase(a5),a6
	call	DoIO
	
; close disk device
	move.l	__diskio(a5),a1
	call	CloseDevice
.nodev	move.l	__diskio(a5),a0
	call	DeleteIORequest
.noio	move.l	__diskport(a5),a0
	call	DeleteMsgPort
.noport

	move.l	dosbase(a5),a6

; close the output diskfile (if not FILEMODE)
	IFEQ	FILEMODE
	move.l	__outfh(a5),d1
	call	Close
.nofile
	ENDC

; free command-line arguments
	move.l	__rdargs(a5),d1
	call	FreeArgs
.noargs

; print error message if ioerror - this includes NOT_A_DOS_DISK
; if a printable reason exists, use that as the head of the printed
; error message.

	moveq	#0,d7	 	; returncode = 0
	move.l	__ioerr(a5),d1
	bne.s	1$
	call	IoErr
	move.l	d0,d1
	beq.s	2$
1$	moveq	#20,d7		; returncode = 20
2$	move.l	__reason(a5),d2
	call	PrintFault

; close dos.library and go home
	move.l	a6,a1
	move.l	execbase(a5),a6
	call	CloseLibrary
.nodos	move.l	d7,d0
	unlk	a5
	rts


; internal routine to print out track number - D0 = track
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

; if TRACKMODE, then use a complete DOSREAD routine

	IFNE	TRACKMODE
;------------------------------------
; a0 = buffer, d0 = track
__dosrd	move.l	a6,-(sp)
	IFNE	MESSAGES
	bsr.s	__prtrk		; print track number in messages mode
	ENDC
	move.l	__diskio(a5),a1
	move.w	#CMD_READ,IO_COMMAND(a1)
	move.l	#DOSTRACKLEN,d1
	mulu	d1,d0			; convert D0=track to D0=offset
	move.l	d1,IO_LENGTH(a1)	; D1 = length

	move.l	a0,IO_DATA(a1)
	move.l	d0,IO_OFFSET(a1)
	move.l	execbase(a5),a6
	call	DoIO			; read disk part
	lea	__ertrk(pc),a0		; fail with "error reading track"
	tst.l	d0			; if DoIO fails
	bne.s	__fail	
	move.l	(sp)+,a6
	rts
	ELSE

; if not TRACKMODE, merge the common parts of RAWREAD and DOSREAD

;------------------------------------
; a0 = buffer, d0 = track
__dosrd	move.l	a6,-(sp)
	IFNE	MESSAGES
	bsr.s	__prtrk
	ENDC
	move.l	__diskio(a5),a1
	move.w	#CMD_READ,IO_COMMAND(a1)
	move.l	#DOSTRACKLEN,d1
	mulu	d1,d0			; as above, D0 = offset, D1 = length
	move.l	d1,IO_LENGTH(a1)
	bra.s	__rdcom

;------------------------------------
; a0 = buffer, d0 = track
__rawrd	move.l	a6,-(sp)
	IFNE	MESSAGES
	bsr.s	__prtrk
	ENDC
	move.l	__diskio(a5),a1
	move.w	#TD_RAWREAD,IO_COMMAND(a1)
	move.b	#IOTDB_INDEXSYNC,IO_FLAGS(a1)	; just for fun...
	move.l	#$7ffe,IO_LENGTH(a1)	; here length always is maximum

__rdcom	move.l	a0,IO_DATA(a1)
	move.l	d0,IO_OFFSET(a1)
	move.l	execbase(a5),a6
	call	DoIO			; error handling as above
	lea	__ertrk(pc),a0
	tst.l	d0
	bne.s	__fail
	move.l	(sp)+,a6
	rts
	ENDC

; FAIL will always quit out of the 'slave' and return to the main
; routine, whatever the location on the stack

;------------------------------------
; a0 = failure reason
__fail	move.l	a0,d0
	beq.s	.noreas
	move.l	d0,__reason(a5)
	move.l	#ERROR_NOT_A_DOS_DISK,__ioerr(a5)
.noreas	move.l	__initsp(a5),sp
	rts

; in FILEMODE, there is a SAVEF which saves a whole file with its own name.

	IFNE	FILEMODE
;------------------------------------
; a0 = filename, a1 = buffer, d0 = length
__savef	movem.l	d2-d4/a0/a6,-(sp)	; careful! 12(sp)=a0
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
	beq.s	.fail
	call	Write
	move.l	d0,d3
	move.l	d4,d1
	call	Close
	tst.l	d3
	bmi.s	.fail
	movem.l	(sp)+,d2-d4/a0/a6	; careful! 12(sp)=a0
	rts
.fail	move.l	12(sp),__reason(a5)	; get A0(name) from movem as reason
	clr.l	__ioerr(a5)		; return and use IoErr() as error
	move.l	__initsp(a5),sp
	rts

	ELSE
; off FILEMODE, you can only write to the diskfile

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

; RAW tracks need to be WORDSYNCed to be readable - this routine does that

	IFEQ	TRACKMODE
;------------------------------------
; a0 = buffer d0 = sync
__sync	movem.l	d2-d3,-(sp)
	move.l	a0,a1
	move.w	#($7ffe/2)-1,d2		; search entire trackbuffer
.nxtwrd	moveq	#16-1,d3		; find a BIT distance...
.nxtbit	move.l	(a0),d1			; and a BYTE distance..
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
	rts
.err	dc.b	"can't find sync mark",0
	ENDC

__ertrk	dc.b	"error reading track",0
__dosnm	dc.b	"dos.library",0
__templ	__tmpl
	IFEQ	TRACKMODE
__tdnm	dc.b	"trackdisk.device",0
	ENDC
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
