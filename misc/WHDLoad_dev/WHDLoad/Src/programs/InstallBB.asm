;*---------------------------------------------------------------------------
;  :Program.	InstallBB.asm
;  :Contents.	write/read BB to/from EXE
;  :Author.	Bert Jahn
;  :EMail.	wepl@kagi.com
;  :Address.	Franz-Liszt-Straße 16, Rudolstadt, 07404, Germany
;  :History.	V 1.0 ???
;		V 1.1 23.09.95
;		1.2	20.01.96 adjusted for Sources:
;			21.01.96 reworked
;		1.3	28.07.96 no longer dos.Inhibit if reading from disk
;				 now diskchange will create an error
;				 now checks disk for write protection
;				 verify implemented
;  :Requires.	OS V37+
;  :Copyright.	© 1995,1996,1997,1998 Bert Jahn, All Rights Reserved
;  :Language.	68000 Assembler
;  :Translator.	Barfly V1.130
;---------------------------------------------------------------------------*
;##########################################################################

	INCDIR	Includes:
	INCLUDE	lvo/exec.i
	INCLUDE	exec/io.i
	INCLUDE	exec/memory.i
	INCLUDE	lvo/dos.i
	INCLUDE	dos/dos.i
	INCLUDE	devices/trackdisk.i
	
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GL	EQUR	A4		;a4 ptr to Globals
LOC	EQUR	A5		;a5 for local vars

	STRUCTURE	Globals,0
		APTR	gl_execbase
		APTR	gl_dosbase
		APTR	gl_rdargs
		LABEL	gl_rdarray
		ULONG	gl_rdloadfile
		ULONG	gl_rddiskunit
		ULONG	gl_rdwrite
		STRUCT	gl_bb,1024
		LABEL	gl_SIZEOF

;##########################################################################

	SECTION	"",CODE,RELOC16
	OUTPUT	"c:InstallBB"


VER	MACRO
		dc.b	"InstallBB 1.3 "
	DOSCMD	"WDate >t:date"
	INCBIN	"t:date"
		dc.b	" by Bert Jahn"
	ENDM

		bra	.start
		dc.b	"$VER: "
		VER
		dc.b	" V37+"
		dc.b	" (read/write BB to/from EXE)",0
	CNOP 0,2
.start

		move.l	#gl_SIZEOF,d0
		move.l	#MEMF_PUBLIC|MEMF_CLEAR,d1
		move.l	(4).w,a6
		jsr	(_LVOAllocMem,a6)
		tst.l	d0
		beq	.nostrucmem
		move.l	d0,GL			;GL = PubMem
		move.l	a6,(gl_execbase,GL)

		move.l	#37,d0
		lea	(_dosname),a1
		move.l	(gl_execbase,GL),a6
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,(gl_dosbase,GL)
		beq	.nodoslib

		lea	(_ver),a0
		bsr	_Print

		lea	(_template),a0
		move.l	a0,d1
		lea	(gl_rdarray,GL),a0
		move.l	a0,d2
		moveq	#0,d3
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOReadArgs,a6)
		move.l	d0,(gl_rdargs,GL)
		bne	.argsok
		lea	(_readargs),a0
		bsr	_PrintErrorDOS
		bra	.noargs
.argsok
		move.l	(gl_rddiskunit,GL),d0
		beq	.unitok
		move.l	d0,a0
		move.l	(a0),(gl_rddiskunit,GL)
.unitok
		pea	(.back)
		tst.l	(gl_rdwrite,GL)
		bne	_Write
		bra	_Read
.back
		move.l	(gl_rdargs,GL),d1
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOFreeArgs,a6)
.noargs
		move.l	(gl_dosbase,GL),a1
		move.l	(gl_execbase,GL),a6
		jsr	(_LVOCloseLibrary,a6)
.nodoslib
		move.l	#gl_SIZEOF,d0
		move.l	(gl_execbase,GL),a6
		move.l	GL,a1
		jsr	(_LVOFreeMem,a6)
.nostrucmem
		moveq	#0,d0
		rts

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;----------------------------------------
; Operation File
; Übergabe :	
; Rückgabe :	

_Write		moveq	#BB_READ,d0			;read old bootblock
		bsr	_ReadWriteBB
		tst.l	d0
		beq	.end

		lea	(gl_bb,GL),a0			;chk FS-ID (DOS\0 DOS\1 ...)
		move.l	(a0),d0
		clr.b	d0
		move.l	#"DOS"<<8,d1
		cmp.l	d1,d0
		beq	.bbvalid
		move.l	d1,(a0)
.bbvalid
		addq.w	#4,a0
		clr.l	(a0)+				;reset chksum
		move.l	#$0000370,(a0)+
		move.w	#253-1,d1
		moveq	#-1,d0				;init data area with $FFFFFFFF
.bbclear	move.l	d0,(a0)+
		dbf	d1,.bbclear

		move.l	(gl_rdloadfile,GL),a0
		bsr	_LoadFile
		move.l	d0,d6				;D6 = aptr src
		beq	.end
		move.l	d1,d7				;D7 = size of src

		move.l	d6,a0
		cmp.l	#$000003F3,(a0)+	;hunk CODE
		bne	.noexe

.nextname	move.l	(a0)+,d0		;name
		beq	.noname
		add.l	d0,d0
		add.l	d0,d0
		bmi	.corrupt
		add.l	d0,a0
		bra	.nextname

.noname		cmp.l	#1,(a0)+		;count of hunks
		bne	.no1hunk

		addq.l	#8,a0			;lowhunk,highhunk
		cmp.l	#253,(a0)+		;
		bhi	.tolarge
		cmp.l	#$000003E9,(a0)+	;code
		bne	.nocode
		move.l	(a0)+,d0		;lw's
		add.l	d0,d0
		add.l	d0,d0
		lea	(a0,d0.l),a1
		cmp.l	#$3EC,(a1)		;reloc32
		beq	.relocs
		cmp.l	#$3ED,(a1)		;reloc16
		beq	.relocs
		cmp.l	#$3EE,(a1)		;reloc8
		beq	.relocs
		cmp.l	#$3F2,(a1)		;end
		beq	.srcok
		cmp.l	#$3F0,(a1)		;symbol
		beq	.srcok
		cmp.l	#$3F1,(a1)		;debug
		beq	.srcok
.uhunk		lea	(_err_uhunk),a0
		bra	.errgo
.corrupt	lea	(_err_corrupt),a0
		bra	.errgo
.relocs		lea	(_err_relocs),a0
		bra	.errgo
.tolarge	lea	(_err_tolarge),a0
		bra	.errgo
.no1hunk	lea	(_err_no1hunk),a0
		bra	.errgo
.noexe		lea	(_err_noexe),a0
		bra	.errgo
.nocode		lea	(_err_nocode),a0
.errgo		moveq	#0,d0
		sub.l	a1,a1
		bsr	_PrintError
		bra	.srcerr
		
	;a0 = begin d0 = size
.srcok		lea	(gl_bb+12,GL),a1	;copy code to bb
		lsr.l	#2,d0
		subq.l	#1,d0
.cp		move.l	(a0)+,(a1)+
		dbf	d0,.cp
		
		lea	(gl_bb,GL),a1		;calculate chksum
		moveq	#0,d0
		move.w	#255,d1
.sum		add.l	(a1)+,d0
		bcc	.sum2
		addq.l	#1,d0
.sum2		dbf	d1,.sum
		not.l	d0
		move.l	d0,(gl_bb+4,GL)		;set the chksum

		move.l	d7,d0
		move.l	d6,a1
		move.l	(gl_execbase,GL),a6
		jsr	(_LVOFreeMem,a6)
		
		moveq	#BB_WRITE,d0		;write the bootblock
		bsr	_ReadWriteBB
		tst.l	d0
		beq	.end
		
		bsr	.vsum
		move.l	d0,d3
		moveq	#BB_READ,d0		;read the bootblock
		bsr	_ReadWriteBB
		tst.l	d0
		beq	.end
		bsr	.vsum
		cmp.l	d0,d3
		beq	.end
		moveq	#0,d0
		lea	_err_verify,a0
		sub.l	a1,a1
		bsr	_PrintError
.srcerr
.end		rts

.vsum		lea	(gl_bb,GL),a0
		move.l	(a0)+,d0
		move.w	#254,d1
.s1		move.l	(a0)+,d2
		eor.l	d2,d0
		dbf	d1,.s1
		rts

;----------------------------------------
; Operation File
; Übergabe :	
; Rückgabe :	

_Read		moveq	#BB_READ,d0			;read
		bsr	_ReadWriteBB
		tst.l	d0
		beq	.end

		move.l	(gl_rdloadfile,GL),d1		;name
		move.l	#MODE_NEWFILE,d2		;mode
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOOpen,a6)
		move.l	d0,d7				;D7 = fh
		bne	.openok
		lea	(_openfile),a0
		bsr	_PrintErrorDOS
		bra	.erropen
.openok
		move.l	d7,d1			;fh
		lea	(.bbexe_begin),a0
		move.l	a0,d2			;buffer
		move.l	#8*4,d3			;length
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOWrite,a6)
		cmp.l	#8*4,d0
		bne	.writeerr
		
		move.l	d7,d1			;fh
		lea	(gl_bb+12,GL),a0
		move.l	a0,d2			;buffer
		move.l	#1024-12,d3		;length
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOWrite,a6)
		cmp.l	#1024-12,d0
		bne	.writeerr

		move.l	d7,d1			;fh
		lea	(.bbexe_end),a0
		move.l	a0,d2			;buffer
		move.l	#4,d3			;length
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOWrite,a6)
		cmp.l	#4,d0
		beq	.allok

.writeerr	lea	(_writefile),a0
		bsr	_PrintErrorDOS
.allok
		move.l	d7,d1			;fh
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOClose,a6)
.erropen
.end		rts

.bbexe_begin	dc.l	$000003F3,$00000000,$00000001,$00000000
		dc.l	$00000000,$000000FD,$000003E9,$000000FD
.bbexe_end	dc.l	$000003F2

;----------------------------------------
; Lesen / Schreiben Bootblock
; Übergabe :	D0 = WORD operation
; Rückgabe :	D0 = BOOL success

BB_READ		= 0
BB_WRITE	= 1

_ReadWriteBB	movem.l	d5-d7/a2/a6,-(a7)
		move.l	d0,d6			;D6 = operation
		moveq	#0,d7			;D7 = return

		move.l	(gl_execbase,GL),a6
		jsr	(_LVOCreateMsgPort,a6)
		move.l	d0,d5			;D5 = msgport
		bne	.portok
		moveq	#0,d0
		lea	(_noport),a0
		sub.l	a1,a1
		bsr	_PrintError
		bra	.noport
.portok		
		move.l	d5,a0
		move.l	#IOTD_SIZE,d0
		jsr	(_LVOCreateIORequest,a6)
		move.l	d0,a2			;A2 = ioreq
		tst.l	d0
		bne	.ioreqok
		moveq	#0,d0
		lea	(_noioreq),a0
		sub.l	a1,a1
		bsr	_PrintError
		bra	.noioreq
.ioreqok
		lea	(_tdname),a0
		move.l	(gl_rddiskunit,GL),d0	;unit
		move.l	a2,a1			;ioreq
		move.l	#0,d1			;flags
		jsr	(_LVOOpenDevice,a6)
		tst.l	d0
		beq	.deviceok
		move.b	(IO_ERROR,a2),d0
		lea	(_opendevice),a0
		bsr	_PrintErrorTD
		bra	.nodevice
.deviceok
		move.l	a2,a1
		move.w	#TD_CHANGENUM,(IO_COMMAND,a1)
		jsr	(_LVODoIO,a6)
		move.l	(IO_ACTUAL,a2),(IOTD_COUNT,a2)	;the diskchanges

		cmp.w	#BB_WRITE,d6
		bne	.nw1			;only if writing
		moveq	#-1,d0
		bsr	_InhibitDrive

		move.l	a2,a1
		move.w	#TD_PROTSTATUS,(IO_COMMAND,a1)
		jsr	(_LVODoIO,a6)
		move.b	#TDERR_WriteProt,d0
		tst.l	(IO_ACTUAL,a2)
		bne	.error
.nw1
		move.l	a2,a1
		lea	(gl_bb,GL),a0
		move.l	a0,(IO_DATA,a1)				;Buffer
		move.l	#0,(IO_OFFSET,a1)			;ab Block 0
		move.l	#$400,(IO_LENGTH,a1)			;2 Blöcke
		move.w	#ETD_WRITE,(IO_COMMAND,a1)
		cmp.w	#BB_READ,d6
		bne	.notread
		move.w	#ETD_READ,(IO_COMMAND,a1)
.notread	jsr	(_LVODoIO,a6)
		moveq	#-1,d7
		move.b	(IO_ERROR,a2),d0
		beq	.readok
.error		sub.l	a0,a0
		bsr	_PrintErrorTD
		moveq	#0,d7
.readok
		move.l	a2,a1
		move.l	#0,(IO_LENGTH,a1)
		move.w	#TD_MOTOR,(IO_COMMAND,a1)
		jsr	(_LVODoIO,a6)
		
		cmp.w	#BB_WRITE,d6
		bne	.nw2			;only if writing
		moveq	#0,d0
		bsr	_InhibitDrive
.nw2
		move.l	a2,a1
		jsr	(_LVOCloseDevice,a6)
		
.nodevice	move.l	a2,a0
		jsr	(_LVODeleteIORequest,a6)
		
.noioreq	move.l	d5,a0
		jsr	(_LVODeleteMsgPort,a6)
		
.noport		move.l	d7,d0
		movem.l	(a7)+,d5-d7/a2/a6
		rts

;----------------------------------------
; Laufwerk busy schalten
; Übergabe :	D0 = BOOL off
; Rückgabe :	D0 = BOOL success

_InhibitDrive	movem.l	d2/a6,-(a7)
		lea	(.name),a0
		move.l	(gl_rddiskunit,GL),d1
		add.b	#"0",d1
		move.b	d1,(2,a0)
		move.l	a0,d1
		move.l	d0,d2
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOInhibit,a6)
		movem.l	(a7)+,d2/a6
		rts

.name		dc.b	"DFx:",0
	EVEN

;##########################################################################

	INCDIR	Sources:
	INCLUDE	dosio.i
		Print
		PrintLn
	INCLUDE	error.i
		PrintErrorDOS
		PrintErrorTD
	INCLUDE	files.i
		LoadFile

;##########################################################################

_noport		dc.b	"can't create MessagePort",0
_noioreq	dc.b	"can't create IO-Request",0
_opendevice	dc.b	"can't open trackdisk.device",0

_err_noexe	dc.b	"source is not an executable",0
_err_relocs	dc.b	"source contain relocs (not pc-relative)",0
_err_tolarge	dc.b	"code size to large  (>1012 Bytes)",0
_err_nocode	dc.b	"first hunk isn't code",0
_err_no1hunk	dc.b	"more than 1 hunk in source",0
_err_corrupt	dc.b	"executable is corrupt",0
_err_uhunk	dc.b	"unknown hunk in source",0
_err_verify	dc.b	"verify error",0

; Operationen
_readargs	dc.b	"read arguments",0
_openfile	dc.b	"open file",0
_writefile	dc.b	"write file",0

_dosname	dc.b	"dos.library",0
_tdname		dc.b	"trackdisk.device",0

_template	dc.b	"PROGRAM/A"		;File to load or save
		dc.b	",UNIT/K/N"		;unit for trackdisk.device
		dc.b	",WRITE/S"		;if not then read
		dc.b	0

_ver		VER
		dc.b	10,0

;##########################################################################

	END

