
;---;  requester.r  ;----------------------------------------------------------
*
*	****	FILE REQUESTER ASL/REQ    ****
*
*	Author		Stefan Walter
*	Version		1.03
*	Last Revision	24.07.93
*	Identifier	frq_defined
*	Prefix		frq_	(File requester)
*				 ¯    ¯ ¯
*	Functions	DoFileRequester
*
*	Flags		frq_ASLONLY	if set only a ASL Requester opened
*
;------------------------------------------------------------------------------

;------------------
	ifnd	frq_defined
frq_defined	=1

;------------------
frq_oldbase	equ __base
	base	frq_base
frq_base:

;------------------

;------------------------------------------------------------------------------
*
* DoFileRequester	Open a file requester and get a file.
*
* INPUT:	a0	Title for requester.
*		a1	Pattern.
*		a2	Destination for file path (162 bytes, incl. zero).
*
* RESULT:	d0	Pointer to filename or 0 if cancel or error. (CCR)
*
;------------------------------------------------------------------------------

;------------------
DoFileRequester:

;------------------
; Start.
;
\start:
	movem.l	d1-a6,-(a7)
	move.l	4.w,a6
	move.l	a0,d6
	move.l	a1,d5
	move.l	a2,a4
	moveq	#0,d4			;failure

	IFND	frq_ASLONLY
	cmp.w	#36,20(a6)		;lib version
	bcs	\req
	ENDC

;--------------------------------------------------------------------
; Use asl.library.
;
\asl:
	lea	frq_aslname(pc),a1
	jsr	-408(a6)
	move.l	d0,d7
	
	IFND	frq_ASLONLY
	beq	\req
	ELSE
	beq	\exit
	ENDC

	move.l	d7,a6
	moveq	#0,d0			;0 = ASL_FileRequest
	lea	frq_asltags(pc),a0
	move.l	d6,4(a0)		;title
	move.l	d5,12(a0)		;pattern
	jsr	-48(a6)			;AllocAslRequest()
	tst.l	d0
	beq	\closelib

	move.l	d0,-(a7)		;AReqBase
	move.l	d0,a0
	lea	frq_tagdone(pc),a1
	jsr	-60(a6)			;AslRequest
	tst.l	d0			;Cancel?
	beq.s	\freeasl

	move.l	(a7),a0
	move.l	4(a0),a1		;rf_File, filename
	move.l	8(a0),a0		;rf_Dir,  directory

;------------------
; Copy asl strings together.
;
\copyasl:
	move.l	a4,a2
	move.w	#162,d1

	tst.b	(a0)			;this is done to prevent file names
	beq.s	\loop2			;like '/ass3.q' etc.

\loop:	tst.b	(a0)
	beq.s	1$
	move.b	(a0)+,(a2)+
	subq.w	#1,d1
	bhi.s	\loop
	bra.s	\freeasl

1$:	cmp.b	#":",-1(a2)
	beq.s	\loop2
	cmp.b	#"/",-1(a2)
	beq.s	\loop2
	move.b	#"/",(a2)+
	subq.b	#1,d1
	beq.s	\freeasl

\loop2:	subq.b	#1,d1			;copy filename
	beq.s	\freeasl
	move.b	(a1)+,(a2)+
	bne.s	\loop2
	move.l	a4,d4			;=>all okay!

;------------------
; Free asl request.
;
\freeasl:
	move.l	(a7)+,a0
	jsr	-54(a6)			;_LVOFreeAslRequest()

;------------------
; Close any library.
;
\closelib:
	move.l	d7,a1
	move.l	4.w,a6
	jsr	-414(a6)		;closelib

;------------------
; Exit.
;
\exit:
	move.l	d4,d0
	movem.l	(a7)+,d1-a6
	rts

;--------------------------------------------------------------------
; Use req.library.
;
	IFND	frq_ASLONLY
\req:
	lea	frq_reqname(pc),a1
	jsr	-408(a6)
	move.l	d0,d7
	beq.s	\exit

	move.l	d7,a6
	lea	frq_reqstruct(pc),a0
	move.l	d6,2(a0)		;title
	move.l	a4,14(a0)

\copypattern:
	move.l	d5,a1
	moveq	#-3,d0			;for two brackets.
\coloop:
	addq.b	#1,d0
	tst.b	(a1)+
	bne.s	\coloop

	move.l	d5,a1
	lea	frq_reqshow(pc),a2
	addq.l	#1,a1
	moveq	#31,d1
	cmp.l	d0,d1
	bge.s	\copynow
	move.l	d1,d0

\copynow:
	move.b	(a1)+,(a2)+
	subq.b	#1,d0
	bne.s	\copynow

	jsr	-84(a6)			;FileRequester()
	tst.l	d0
	beq.s	\freereq
	move.l	a4,d4

\freereq:
	lea	frq_reqstruct(pc),a0
	jsr	-114(a6)		;PurgeFiles()
	bra	\closelib
	ENDC

;------------------

;--------------------------------------------------------------------

;------------------
; Tags for ASL filerequester.
;
frq_asltags:

\ASL_Dummy	equ	$80000000+$80000
\ASL_Hail	equ	\ASL_Dummy+1
\ASL_LeftEdge	equ	\ASL_Dummy+3
\ASL_TopEdge	equ	\ASL_Dummy+4
\ASL_Width	equ	\ASL_Dummy+5
\ASL_Height	equ	\ASL_Dummy+6
\ASL_File	equ	\ASL_Dummy+8
\ASL_Dir	equ	\ASL_Dummy+9
\ASL_Pattern	equ	\ASL_Dummy+10
\ASL_FuncFlags	equ	\ASL_Dummy+20

		dc.l	\ASL_Hail,0	
		dc.l	\ASL_Pattern,0	
		dc.l	\ASL_TopEdge,11
		dc.l	\ASL_LeftEdge,0
		dc.l	\ASL_Height,175
		dc.l	\ASL_FuncFlags,1


frq_tagdone:

\tag_done	equ	0

		dc.l	\tag_done


;------------------
; Struct for REQ requester.
;
frq_reqstruct:
	dc.w	0		;version
	dc.l	0;title		;title
	dc.l	0		;directory text
	dc.l	0		;file name
	dc.l	0;pathname	;full name and path
	dc.l	0		;window
	dc.w	0,0,0,0		;stuff...
	dc.l	$1094		;FLAGS
	dc.w	3,0,3,0,0	;colors for dir/file/device,fontname/size
	ds.w	8,0		;colors...
	ds.b	36,0		;INTERNAL
	dc.l	0,0,0		;date stamp
	dc.w	0,0		;window size
	dc.w	0,0		;font...
	dc.l	0		;extended list
	ds.b	32,0		;wildcards for hide
frq_reqshow:
	ds.b	32,0		;wildcards for show
	ds.w	8,0		;cursor stuff
	ds.l	3,0		;INTERNAL
	ds.b	132,0		;INTERNAL
	ds.l	3,0		;INTERNAL

;0	;Set this in Flags if you want .info files to show.  They default to hidden.
;1	;Set this in Flags if you want extended select.  Default is not.
;2	;Set this in Flags if you want directory caching.  Default is not.
;3	;Set this in Flags if you want a font requester rather than a file requester.
;4	;Set this in Flags if you want a hide-info files gadget.
;5	;Set this in Flags if you DON'T want 'show' and 'hide' string gadgets.
;6	;Use absolute x,y positions rather than centering on mouse.
;7	;Purge the cache whenever the directory date stamp changes if this is set.
;8	;Don't cache a directory unless it is completely read in when this is set.
;9	;Set this in Flags if you DON'T want sorted directories.
;10	;Set this in Flags if you DON'T want a drag bar and depth gadgets.
;11	;Set this bit if you are selecting a file to save to.
;12	;Set this bit if you are selecting a file(s) to load from.
;13	;Allow the user to select a directory, rather than a file.

;------------------
frq_aslname:	dc.b	"asl.library",0
frq_reqname:	dc.b	"req.library",0
	 even

;------------------

;--------------------------------------------------------------------

;------------------
	base	frq_oldbase

;------------------
	endif

	end

