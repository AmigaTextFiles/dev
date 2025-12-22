
;---;  dosfile.r  ;------------------------------------------------------------
*
*	****	DOS FILE HANDLING ROUTINES    ****
*
*	Author		Stefan Walter
*	Add. Coding	Daniel Weber
*	Version		1.12
*	Last Revision	25.07.92
*	Identifier	dof_defined
*       Prefix		dof_	(DOS files)
*				 ¯¯  ¯
*	Functions	LoadFile, GetFileLength, ReadFromFile, ParseName
*			WriteToFile, ReadLine, WriteLine
*
*	NOTE		- dosfile.r MUST be included after the easylibrary.r
*			  (or the startup4.r)!
*
;------------------------------------------------------------------------------

;------------------
	ifnd	dof_defined
dof_defined	=1

;------------------
dof_oldbase	equ __base
	base	dof_base
dof_base:

;------------------

	IFD     ely_defined
	IFND	DOS.LIB
	FAIL	dos.library needed: DOS.LIB SET 1
	ENDIF
	ENDIF

;------------------------------------------------------------------------------
*
* LOADFILE	Tries to load a file from disk to allocated memory.
*
* INPUT:	d0	Path and name of file
*		d1	Amount of bytes to be allocated more before file
*		d2	Amount of bytes to be allocated more at end
*
* RESULT:	d0	Address of memory block or 0 if error
*		d1	Length of file
*		d2	Length of memory block at d0
*
;------------------------------------------------------------------------------

	IFD	xxx_LoadFile
xxx_ReadFromFile	SET	1
xxx_GetFileLength	SET	1

;------------------
LoadFile:

;--------------------------------------------------------------------
; Get filelength, memory and read file
;
\startup:
	movem.l	d3-a6,-(sp)
	move.l	d0,d6
	move.l	d1,d3
	bsr.s	GetFileLength
	move.l	d0,d5
	ble.s	\error

\allocmem:
	move.l	4.w,a6
	add.l	d3,d0
	add.l	d2,d0		;total length
	move.l	d0,d4
	moveq	#1,d1
	jsr	-198(a6)
	move.l	d0,d7
	beq.s	\error

\read:
	move.l	d6,d0
	move.l	d7,d1
	add.l	d3,d1
	move.l	d5,d2
	bsr	ReadFromFile
	tst.l	d0
	bge.s	\okay

\badread:
	move.l	d7,a1
	move.l	d4,d0
	jsr	-210(a6)
	bra.s	\error

\okay:
	move.l	d7,d0
	move.l	d5,d1
	move.l	d4,d2
	bra.s	\exit
	
\error:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2

\exit:	movem.l	(sp)+,d3-a6
	rts

	ENDC

;--------------------------------------------------------------------

;------------------------------------------------------------------------------
*
* GETFILELENGTH	Gets filelength from a specific file.
*
* INPUT:	D0	Path and name of file
*
* OUTPUT:	D0	Length of file or -1 if error
*		CCR	on D0
*
;------------------------------------------------------------------------------

	IFD	xxx_GetFileLength
;------------------
GetFileLength:

;--------------------------------------------------------------------
; Open all resources: doslib and infoblock memory
;
\startup:
	movem.l	d1-a6,-(sp)
	link	a5,#dof_length
	moveq	#-1,d6			;error
	move.l	d0,d7

\opendos:
	move.l	4.w,a6
	IFND	ely_defined
	lea	dof_dosname(pc),a1
	jsr	-408(a6)
	move.l	d0,dof_dosbase(a5)
	beq.s	\exit
	ENDC

\getinfo:
	moveq	#65,d0
	lsl.l	#2,d0
	moveq	#1,d1
	jsr	-198(a6)
	move.l	d0,dof_infoblock(a5)
	beq.s	\closedos

;------------------
; get length
;
\lock:
	move.l	d7,d1
	moveq	#-2,d2
	IFD	ely_defined
	move.l	DosBase(pc),a6
	ELSE
	move.l	dof_dosbase(a5),a6
	ENDC
	jsr	-84(a6)
	move.l	d0,dof_lock(a5)
	beq.s	\closeinfo

\examine:
	move.l	d0,d1
	move.l	dof_infoblock(a5),d2
	jsr	-102(a6)
	tst.l	d0
	beq.s	\unlockfile

\getlength:
	move.l	dof_infoblock(a5),a0
	move.l	124(a0),d6

;------------------
; free all
;
\unlockfile:
	move.l	dof_lock(a5),d1
	jsr	-90(a6)

\closeinfo:
	move.l	4.w,a6
	move.l	dof_infoblock(a5),a1
	moveq	#65,d0
	lsl.l	#2,d0
	jsr	-210(a6)

\closedos:
	IFND	ely_defined
	move.l	dof_dosbase(a5),a1
	jsr	-414(a6)
	ENDC

\exit:	unlk	a5
	move.l	d6,d0
	movem.l	(sp)+,d1-a6
	rts

	ENDC

;--------------------------------------------------------------------

;------------------------------------------------------------------------------
*
* READFROMFILE	Load from a specific file a certain amount of bytes.
*
* INPUT:	D0	Path and name of file
*		D1	Destinatio memory
*		D2	Number of bytes to read
*
* OUTPUT:	D0	0 if all okay, -1 if error occured (CCR)
*
;------------------------------------------------------------------------------
	IFD	xxx_ReadFromFile

;------------------
ReadFromFile:

;--------------------------------------------------------------------
; Open all resources: doslib and file
;
\startup:
	movem.l	d1-a6,-(sp)
	link	a5,#dof_length
	moveq	#-1,d6			;error
	move.l	d0,d7
	move.l	d1,d4
	move.l	d2,d5

\opendos:
	IFND	ely_defined
	lea	dof_dosname(pc),a1
	move.l	4.w,a6
	jsr	-408(a6)
	move.l	d0,dof_dosbase(a5)
	beq.s	\exit
	ENDC

\open:	move.l	d7,d1
	move.l	#1005,d2
	IFD	ely_defined
	move.l	DosBase(pc),a6
	ELSE
	move.l	dof_dosbase(a5),a6
	ENDC
	jsr	-30(a6)
	move.l	d0,dof_lock(a5)
	beq.s	\closedos

\read:
	move.l	d0,d1
	move.l	d4,d2
	move.l	d5,d3
	jsr	-42(a6)
	cmp.l	d5,d0
	bne.s	\closefile
	moveq	#0,d6			;okay		

\closefile:
	move.l	dof_lock(a5),d1
	jsr	-36(a6)

\closedos:
	IFND	ely_defined
	move.l	4.w,a6
	move.l	dof_dosbase(a5),a1
	jsr	-414(a6)
	ENDC

\exit:	unlk	a5
	move.l	d6,d0
	movem.l	(sp)+,d1-a6
	rts

	ENDC
	
;--------------------------------------------------------------------

;------------------------------------------------------------------------------
*
* READLINE	Load from a file one line (LF & zero as line termination)
*
* INPUT:	D0	filehandle (as returned by Open())
*		D1	destination memory
*		D2	max. number of bytes to read
*
* OUTPUT:	D0	+<#of bytes read> if all okay, -1 if error occured (CCR)
*
* NOTES:        - dosbase is accessed using DosBase(pc).
*
;------------------------------------------------------------------------------
	IFD	xxx_ReadLine
;------------------
ReadLine:
	movem.l	d1-a6,-(a7)

	move.l	d2,d3
	beq.s	.out
	move.l	d1,d2
	move.l	d1,a2
	move.l	d0,d1
	move.l	d0,d4			; filehandle
	move.l	DosBase(pc),a6
	jsr	-42(a6)			; read()
	move.l	d0,d2
	ble.s	.out

	moveq	#$a,d1			; line feed
.loop:	move.b	(a2)+,d3
	beq.s	.seek
	cmp.b	d1,d3
	beq.s	.seek
	subq.l	#1,d2
	bgt.s	.loop

.seek:	move.l	d4,d1			;seek back to the beginning
	moveq	#0,d3			;of the next line (0= OFFSET_CURRENT)
	neg.l	d2
	jsr	-66(a6)			;seek()

.out:	movem.l	(a7)+,d1-a6
	rts

	ENDC

;--------------------------------------------------------------------

;------------------------------------------------------------------------------
*
* WRITELINE	Write a line to a file (LF & zero as line termination)
*
* INPUT:	D0	filehandle (as returned by Open())
*		D1	destination memory
*		D2	max. number of bytes to write
*
* OUTPUT:	D0	+<#of bytes wrote> if all okay, -1 if error occured (CCR)
*
* NOTES:        - dosbase is accessed using DosBase(pc).
*
;------------------------------------------------------------------------------
	IFD	xxx_WriteLine
;------------------
WriteLine:
	movem.l	d1-a6,-(a7)
	move.l	d1,a0
	moveq	#$a,d5			; line feed
.loop:	move.b	(a0)+,d4
	beq.s	.write
	cmp.b	d5,d4
	beq.s	.write
	subq.l	#1,d2
	bgt.s	.loop

.write: move.l	a0,d3
	sub.l	d1,d3			; length
	move.l	d1,d2			; buffer
	move.l	d0,d1			; filehandle
	move.l	DosBase(pc),a6
	jsr	-48(a6)			; write()
	movem.l	(a7)+,d1-a6
	rts

	ENDC
	
;--------------------------------------------------------------------

;------------------------------------------------------------------------------
*
* PARSENAME	Parses a filename and copies the zeroterminated result
*		to another space.
*
* INPUT:	A0	Address of name
*		A1	Destination memory
*		D0	Maximal length (excluding end zero)
*
* OUTPUT:	A0	Next char
*		A1	End of file name (after zero)
*		D0	0 if okay or -1 if error
*
;------------------------------------------------------------------------------
	IFD	xxx_ParseName
;------------------
ParseName:

;--------------------------------------------------------------------
; read name until ' ', $9, $0 and $a or if in ' or " until same and $a
;
\startup:
	movem.l	d1-d7/a2-a6,-(sp)
	move.l	d0,d6
	moveq	#$a,d2
	moveq	#$9,d3
	moveq	#" ",d4

\killspaces:
	move.b	(a0)+,d0
	cmp.b	d3,d0
	beq.s	\killspaces
	cmp.b	d4,d0
	beq.s	\killspaces
	subq.w	#1,a0

\tryintros:
	moveq	#"'",d5
	cmp.b	d5,d0
	beq.s	\introtype
	moveq	#'"',d5
	cmp.b	d5,d0
	beq.s	\introtype

;------------------
; simple type
;
\simpletype:
	move.b	(a0)+,d0
	beq.s	\ends
	cmp.b	d2,d0
	beq.s	\ends
	cmp.b	d3,d0
	beq.s	\ends
	cmp.b	d4,d0
	beq.s	\ends
	move.b	d0,(a1)+

\nexts:	subq.l	#1,d6
	bcc.s	\simpletype

\error:	moveq	#-1,d0

\exit:	movem.l	(sp)+,d1-d7/a2-a6
	rts

\ends:	subq.l	#1,a0
\endi:	moveq	#0,d0
	move.b	d0,(a1)
	bra.s	\exit

;------------------
; in high kommata
;
\introtype:
	addq.w	#1,a0

\itype:	move.b	(a0)+,d0
	cmp.b	d2,d0
	beq.s	\ends
	cmp.b	d5,d0
	beq.s	\endi
	move.b	d0,(a1)+
	subq.l	#1,d6
	bcc.s	\itype
	bra.s	\error

	ENDC
;------------------

;------------------------------------------------------------------------------
*
* WRITETOFILE	save a specified amount of bytes to the given file
*
* INPUT:	D0	Path and name of file (newfile)
*		D1	source memory
*		D2	Number of bytes to write
*
* OUTPUT:	D0	0 if all okay, -1 if error occured (CCR)
*
;------------------------------------------------------------------------------
	IFD	xxx_WriteToFile

;------------------
WriteToFile:

;--------------------------------------------------------------------
; Open all resources: doslib and file
;
\startup:
	movem.l	d1-a6,-(sp)
	link	a5,#dof_length
	moveq	#-1,d6			;error
	move.l	d0,d7
	move.l	d1,d4
	move.l	d2,d5

\opendos:
	IFND	ely_defined
	lea	dof_dosname(pc),a1
	move.l	4.w,a6
	jsr	-408(a6)
	move.l	d0,dof_dosbase(a5)
	beq.s	\exit
	ENDC

\open:	move.l	d7,d1
	move.l	#1006,d2		;mode newfile
	IFD	ely_defined
	move.l	DosBase(pc),a6
	ELSE
	move.l	dof_dosbase(a5),a6
	ENDC
	jsr	-30(a6)
	move.l	d0,dof_lock(a5)
	beq.s	\closedos

\write:	move.l	d0,d1
	move.l	d4,d2
	move.l	d5,d3
	jsr	-48(a6)			;write
	cmp.l	d5,d0
	bne.s	\closefile
	moveq	#0,d6			;okay		

\closefile:
	move.l	dof_lock(a5),d1
	jsr	-36(a6)			;close

\closedos:
	IFND	ely_defined
	move.l	4.w,a6
	move.l	dof_dosbase(a5),a1
	jsr	-414(a6)
	ENDC

\exit:	unlk	a5
	move.l	d6,d0
	movem.l	(sp)+,d1-a6
	rts

	ENDC
	
;--------------------------------------------------------------------


;------------------
; dos.library
;
	IFND	ely_defined
dof_dosname:	dc.b "dos.library",0
	even
	ENDC

;------------------
	foreset
dof_dosbase:		fo.l	1
dof_infoblock:		fo.l	1
dof_lock:		fo.l	1
dof_length:		foval

	

;------------------
	base	dof_oldbase

;------------------
	endif

 end

