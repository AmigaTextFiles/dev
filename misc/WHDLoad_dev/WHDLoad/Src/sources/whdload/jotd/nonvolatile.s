;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
* $Id: nonvolatile.s 1.3 2006/10/30 18:19:03 wepl Exp wepl $
**************************************************************************
*   NONVOLATILE-LIBRARY                                                  *
**************************************************************************

**************************************************************************
*   INITIALIZATION                                                       *
**************************************************************************

	IFND	INITLIST
INITLIST:MACRO
	move.l	A1,LH_TAILPRED(A1)	; tailpred = head (empty list)
	addq.l	#4,A1
	clr.l	(A1)		; tail = NULL
	move.l	A1,-(A1)	; head points on tail
	ENDM
	ENDC


NONVINIT	move.l	_nonvbase(pc),d0
		beq	.init
		rts

.init		move.l	#162,d0		; reserved function
		move.l	#80,d1		; 20 variables: should be OK
		lea	_nonvname(pc),a0
		bsr	_InitLibrary
		lea	_nonvbase(pc),a0
		move.l	d0,(a0)
		move.l	d0,a0
		
		patch	_LVOGetCopyNV(a0),_GetCopyNV
		patch	_LVOStoreNV(a0),_StoreNV
		patch	_LVOGetNVInfo(a0),_GetNVInfo
		patch	_LVODeleteNV(a0),_DeleteNV
;;		patch	_LVOGetNVList(a0),_GetNVList	; not supported, buggy
		patch	_LVOFreeNVData(A0),FREENVDATA
		patch	_LVOSetNVProtection(a0),_SetNVProtection

		movem.l	d0-d1/a0-a2,-(a7)
		move.l	$4.W,a6
		lea	.dosname(pc),a1
		moveq.l	#0,d0
		JSRLIB	OpenLibrary
		lea	_nvdosbase(pc),a0
		move.l	d0,(a0)

		movem.l	(a7)+,d0-d1/a0-a2
		
		rts

.dosname
	dc.b	"dos.library",0
	even

_SetNVProtection
	; dummy, works everytime, protection unchanged
	moveq	#-1,d0
	rts
	
;GetNVInfo[APTR d0](killrequesters [bool D1])
;returns pointer in D0, -4(D0): size, -8(D0): pointer, -12(D0): 0: simple, 1: list
_GetNVInfo:
;	moveq	#0,D0	; not available

	moveq.l	#8+12,d0
	moveq.l	#0,d1
	bsr.w	ForeignAllocMem
	tst.l	d0
	beq.s	.rts
	move.l	d0,a0
	clr.l	(a0)+		;simple structure
	move.l	d0,(A0)+	;pointer
	move.l	#8+12,(A0)+	;size to free
	move.l	#999900,(A0)	;total storage on nv-device
	move.l	#989800,4(A0)	;free storage on nv-device
	move.l	a0,d0
.rts	rts


;GetCopyNV[APTR d0](appname[strptr a0],itemname[strptr a1],
;  killrequesters[bool d1])
;caveats: if appname+itemname becomes >32 chars the function will show
;  a requester indicating theres a problem within the function
;  (not likely as programmers chose them short to save NVRAM-space)
_GetCopyNV:
		link	a5,#-$40
;assemble filename, <appname>_<itemname>\0
		MOVEM.L	a0-a3,-(A7)
		lea.l	4*4+4(A7),a2

		bsr	assemble_filename

;check if file exists
		lea.l	4*4+4(A7),a0
		sub.l	a0,a2
		cmp.l	#32,a2
		bls.s	.filename_ok
		pea	_LVOGetCopyNV(pc)
		pea	_nonvname(pc)
		bra	_emufail

.filename_ok	move.l	_resload(pc),a2
		jsr	(resload_GetFileSize,a2)
		tst.l	d0
		beq.s	.notexisting

;reserve mem
		add.l	#12+7,d0
		and.w	#$fff8,d0
		move.l	d0,4*4+4+$38(A7)
		clr.l	d1
		bsr.w	ForeignAllocMem
		tst.l	d0
		beq.s	.notexisting

;header:
		move.l	d0,a3
		clr.l	(A3)+			; 0: simple
		move.l	d0,(A3)+		; pointer
		move.l	4*4+4+$38(A7),d1	; size
		move.l	d1,(A3)+

;load file into mem
;;		addq.l	#12,d0
;;		move.l	d0,a1
		move.l	a3,a1
		lea.l	4*4+4(A7),a0
		move.l	_resload(pc),a2
		jsr	(resload_LoadFile,a2)

		move.l	a3,d0
		MOVEM.L	(A7)+,a0-a3
		unlk	a5
		rts

.notexisting	moveq	#0,D0
		MOVEM.L	(A7)+,a0-a3
		unlk	a5
		rts


;FreeNVData(data[APTR A0])

FREENVDATA
		move.l	a0,d0
		beq.s	.rts
		tst.l	-12(a0)
		bne.b	.freelist
		move.l	-8(A0),a1
		move.l	-4(A0),d0
		bsr.w	ForeignFreeMem

.rts		rts

.freelist:
	illegal
	rts

;; DeleteNV [error - UWORD d0](appName[STRPTR a0], itemName[STRPTR A1], 
;   killRequesters[BOOL d1])

_DeleteNV:
		link	a5,#-$40
		MOVEM.L	a2-a3/d1,-(A7)
		lea.l	4*4+4(A7),a2

		bsr	assemble_filename

		lea.l	4*4+4(A7),a2

		move.l	_resload(pc),a3
		move.l	a2,a0
		jsr	resload_GetFileSize(a3)
		tst.l	d0
		beq.b	.out		; error

		IFD	NV_DELETE_FILES
		move.l	a2,a0
		jsr	resload_DeleteFile(a3)
		ELSE
		moveq	#-1,d0		; pretend that we succeeded in deletion
		ENDC
.out
		MOVEM.L	(a7)+,a2-a3/d1
		unlk	a5
		rts

;; StoreNV [error - UWORD d0](appName[STRPTR a0], itemName[STRPTR A1], 
;   data[APTR a2],length[ULONG d0], killRequesters[BOOL d1])


_StoreNV
		link	a5,#-$40
		MOVEM.L	a2/d0/d2-d3,-(A7)
		lea.l	4*4+4(A7),a2

		bsr	assemble_filename

;check if file exists
		lea.l	4*4+4(A7),a0
		sub.l	a0,a2
		cmp.l	#32,a2
		bls.s	.filename_ok
		pea	_LVOStoreNV
		pea	_nonvname(pc)
		bra	_emufail

.filename_ok
;save with dos to ensure to wipe out illegal pathnames
		move.l	a0,d1
		MOVE.L	#MODE_NEWFILE,D2

		movem.l	a6,-(a7)
		move.l	_nvdosbase(pc),a6
		JSRLIB	Open
		movem.l	(a7)+,a6

		TST.L	D0
		beq.s	.err
		move.l	d0,a2
		move.l	d0,d1
		move.l	$c(A7),d2
		move.l	(A7),d3		;multiply len by 10
		lsl.l	#2,d3
		add.l	(A7),d3
		add.l	d3,d3

		movem.l	a6,-(a7)
		move.l	_nvdosbase(pc),a6

		JSRLIB	Write
					;ignore any error
		move.l	a2,d1
		JSRLIB	Close
		movem.l	(a7)+,a6

.err		movem.l	(A7)+,a2/d0/d2-d3
		moveq	#0,D0
		unlk	a5
		rts

; < A0: appname
; < A1: itemname
; > D0: item file size

get_item_size:
	movem.l	D1/A0-A2,-(A7)
	lea	-60(A7),A7

	move.l	A7,A2
	bsr	assemble_filename

	move.l	A7,A0
	move.l	_resload(pc),a2
	jsr	(resload_GetFileSize,a2)

	lea	60(A7),A7
	movem.l	(A7)+,D1/A0-A2
	rts


; < A0: appname
; < A1: itemname
; < A2: buffer
; JOTD: used by StoreNV and GetCopyNV to compute the item final filename
; assemble filename, <appname>.nvd/<itemname>\0

assemble_filename:
.cpappname	tst.b	(A0)
		beq.s	.endappname
		move.b	(A0)+,(A2)+
		bra.s	.cpappname

.endappname	
		lea	appname_extension(pc),A0
.cpext		tst.b	(A0)
		beq.s	.endext
		move.b	(A0)+,(A2)+
		bra.s	.cpext
.endext
.cpitemname	tst.b	(A1)
		beq.s	.enditemname
		move.b	(A1)+,(A2)+
		bra.s	.cpitemname

.enditemname
		cmp.b	#'/',-1(A2)
		bne.b	.noslash
		subq.l	#1,A2		; will remove the trailing slash
.noslash
		move.b	#0,(A2)+
		rts


	IFEQ	1
;GetNVList[AppName A0](killrequesters [bool D1])

_GetNVList:
	movem.l	D2-D3/A2-A5,-(A7)
	
	sub.l	A5,A5
	sub.l	A4,A4

	lea	-64(a7),A7

	move.l	A7,A2
	move.l	A0,A3		; appname
	lea	.null(pc),A1	; no item
	bsr	assemble_filename
	
	moveq	#0,D2		; no buffer yet

	move.l	#$400,D0
	move.l	#MEMF_CLEAR,D1
	bsr	ForeignAllocMem
	tst.l	D0
	beq.b	.end

	move.l	D0,D2		; buffer

	move.l	A7,A0		; dir name
	move.l	D2,A1		; buffer
	move.l	_resload(PC),a2
	move.l	#$400,D0		; buffer size

	bsr	WHDListFiles
	move.l	D0,A2

	; loop on files and insert them in the list

	move.l	#MLH_SIZE+12,D0
	move.l	#MEMF_CLEAR,D1
	bsr	ForeignAllocMem
	tst.l	D0
	beq.b	.end
	move.l	D0,A5

	; header
	move.l	#1,(A5)+
	move.l	D0,(A5)+
	move.l	#MLH_SIZE+12,(A5)+

	move.l	A5,A1
	INITLIST
.atloop
	tst.b	(A2)
	beq.b	.end	; empty name: end

	move.l	A2,A0
	bsr	.alloc_nventry

	bsr.b	.nextname
	bra.b	.atloop

.end
	move.l	A4,MLH_TAIL(A5)		; end of list
	move.l	MLH_TAIL(a5),a1
	move.l	MLN_PRED(a1),MLH_TAILPRED(a5)	; tail predecessor

	move.l	#$400,D0
	tst.l	D2
	beq.b	.skipfree
	move.l	D2,A1		; buffer
	bsr	ForeignFreeMem
.skipfree
	lea	64(a7),A7
	move.l	A5,D0		; pointer on minlist
	movem.l	(A7)+,D2-D3/A2-A5
	rts

.nextname:
	tst.b	(a2)+
	bne.b	.nextname
	rts

; < A0
; > D0 len
.strlen:
	moveq	#0,D0
.strloop
	tst.b	(A0,D0)
	beq.b	.out
	addq.l	#1,D0
	bra.b	.strloop
.out
	rts

; < A0: item name
; < A3: app name
; < A4: previous nv entry
; > A4: nventry structure

.alloc_nventry:
	movem.l	D0-D1/A0-A2,-(A7)
	move.l	A0,D0
	bsr	.strlen

	addq.l	#1,D0			; one more for NULL char
	move.l	#MEMF_CLEAR,D1
	movem.l	A0,-(A7)
	bsr	ForeignAllocMem
	movem.l	(A7)+,A0
	tst.l	D0
	beq.b	.fail
	move.l	D0,A2
	move.l	A2,-(A7)
.strcpy
	move.b	(A0)+,(A2)+
	bne.b	.strcpy
	move.l	(A7)+,A2

	move.l	#NVENTRY_SIZE,D0
	move.l	#MEMF_CLEAR,D1
	bsr	ForeignAllocMem
	tst.l	D0
	bne.b	.ok
.fail
	movem.l	(A7)+,D0-D1/A0-A2
	addq.l	#4,A7
	bra.b	.end	; failure
.ok
	move.l	D0,A1
	move.l	A3,A0	; app name

	moveq.l	#0,D0
	movem.l	A1,-(A7)
	move.l	A2,A1		; item name
	bsr	get_item_size
	movem.l	(A7)+,A1
.skipsz

	; store the string pointer (or NULL)

	move.l	A2,nve_Name(a1)

	; store the item size

	move.l	D0,nve_Size(a1)

	; init minnode

	clr.l	MLN_SUCC(A1)

	; link succ/pred

	cmp.l	#0,A4
	beq.b	.skipsucc
	move.l	a1,MLN_SUCC(a4)
	bra.b	.skiphead
.skipsucc
	move.l	a1,MLH_HEAD(a5)	; init list
.skiphead
	move.l	a4,MLN_PRED(a1)
	move.l	a4,MLH_TAILPRED(a5)	; tail predecessor

	move.l	A1,A4		; A4 = tail
	move.l	A4,MLH_TAIL(A5)

	movem.l	(A7)+,D0-D1/A0-A2
	rts


.null:
	dc.b	0
	ENDC

appname_extension:
	dc.b	".nvd/",0
	cnop	0,4
_nvdosbase:
	dc.l	0
