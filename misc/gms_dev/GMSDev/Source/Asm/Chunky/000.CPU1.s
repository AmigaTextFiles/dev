;===================================================================================;
;                                 CHUNKY8 EMULATOR
;===================================================================================;
;This c2p routine is also used in the rtgmaster library, it's not too bad for
;a CPU only routine.

CHUNKYMEM =	MEM_DATA	;<- Fast memory.

	INCDIR	"INCLUDES:"
	INCLUDE	"exec/libraries.i"
	INCLUDE	"exec/initializers.i"
	INCLUDE	"exec/resident.i"
	INCLUDE	"exec/exec_lib.i"
	INCLUDE	"hardware/custom.i"
	INCLUDE	"dpkernel/dpkernel.i"
	INCLUDE	"system/debug.i"

CALL	MACRO
	jsr	_LVO\1(a6)
	ENDM

;===================================================================================;
;                                  MONITOR DRIVER
;===================================================================================;

    STRUCTURE	ChunkyBase,LIB_SIZE
	ULONG	CHK_SegList
	LABEL	CHKBase_SIZEOF

	SECTION	"Chunky8",CODE

LibPriority = 	0

CleanExit:		;If the user tries to run the library, we
	moveq	#$00,d0	;don't want to crash...
	rts

InitDescrip:
	dc.w	RTC_MATCHWORD	;UWORD rt_matchword
	dc.l	InitDescrip,EndCode	;APTR  rt_matchtag, rt_endskip
	dc.b	RTF_AUTOINIT,DPKVersion	;UBYTE rt_flags, rt_version
	dc.b	NT_LIBRARY,LibPriority	;UBYTE rt_type, rt_pri
	dc.l	LibName,IDString,Init	;APTR  rt_name, rt_idstring, rt_init

LibName:
	dc.b	"000.CPU1",0
	even
	dc.b	"$VER: "
IDString:
	dc.b	"Chunky 8 Emulator V1.0",10,0
	even

Init:	dc.l	CHKBase_SIZEOF,FunctionTable,DataTable,InitRoutine

FunctionTable:
FT:	dc.w	-1,Open-FT,Close-FT,Expunge-FT,Null-FT
	dc.w	LIB_emuStart-FT
	dc.w	LIB_emuInitRefresh-FT
	dc.w	LIB_emuFreeRefresh-FT
	dc.w	LIB_emuRefreshScreen-FT
	dc.w	-1

DataTable:
	INITBYTE LN_TYPE,NT_LIBRARY
	INITLONG LN_NAME,LibName
	INITBYTE LIB_FLAGS,LIBF_SUMUSED!LIBF_CHANGED
	INITWORD LIB_VERSION,DPKVersion
	INITWORD LIB_REVISION,DPKRevision
	INITLONG LIB_IDSTRING,IDString
	dc.l	0
	even

;===================================================================================;
;                              INITIALISATION ROUTINE
;===================================================================================;
;Requires: a0 = SegList
;	   d0 = Library Base.

InitRoutine:
	MOVEM.L	D1-D7/A0-A6,-(SP)	;SP = Save registers.
	move.l	d0,a5	;a5 = Store pointer to our base.
	move.l	d0,CHKBase	;ma = Save pointer to our base.
	move.l	a0,CHK_SegList(a5)	;a5 = Save pointer to SegList.
	move.l	CHKBase(pc),d0	;d0 = Return library pointer.
.error	MOVEM.L	(SP)+,D1-D7/A0-A6	;SP = Return registers.
	rts

;===================================================================================;
;                                   OPEN LIBRARY
;===================================================================================;

Open:	addq.w	#1,LIB_OPENCNT(a6)	;Increment lib count.
	bclr	#LIBB_DELEXP,LIB_FLAGS(a6)
	move.l	a6,d0	;Return library base.
	rts

;===================================================================================;
;                                  CLOSE LIBRARY
;===================================================================================;

Close:	moveq	#$00,d0	;This is called whenever someone closes
	subq.w	#1,LIB_OPENCNT(a6)	;our library.
	bne.s	.Exit
	btst	#LIBB_DELEXP,LIB_FLAGS(a6)
	beq.s	.Exit
	bsr.s	Expunge
.Exit	rts

;===================================================================================;
;                               EXPUNGE THE LIBRARY
;===================================================================================;

Expunge:
	MOVEM.L	D1-D7/A0-A6,-(SP)	;SP = Save all registers.
	move.l	a6,a5	;a5 = Our library base.
	tst.w	LIB_OPENCNT(a5)	;a5 = Do any programs have us open?
	beq.s	.expunge	;>> = No, so it's safe to expunge ourselves.
	bset	#LIBB_DELEXP,LIB_FLAGS(a5)
	MOVEM.L	(SP)+,D1-D7/A0-A6	;SP = Return all registers.
	moveq	#$00,d0
	rts

.expunge
	move.l	($4).w,a6	;a6 = ExecBase.
	move.l	CHK_SegList(a5),d2	;d2 = Our segment list.
	move.l	a5,a1	;a1 = Our library base.
	CALL	Remove	;>> = Remove it.
	move.l	a5,a1	;a1 = Our library base.
	moveq	#$00,d0	;d0 = 00
	move.w	LIB_NEGSIZE(a5),d0	;d0 = LIB_NEGSIZE(base)
	sub.l	d0,a1	;a1 = (base)-LIB_NEGSIZE
	add.w	LIB_POSSIZE(a5),d0	;d0 = (LIB_NEGSIZE)+LIB_POSSIZE
	CALL	FreeMem	;>> = Free the memory.
	move.l	d2,d0	;d0 = Pointer to segment list.
	MOVEM.L	(SP)+,D1-D7/A0-A6	;SP = Return all registers, d0 = seglist.
	rts

;===================================================================================;
;                                    DO NOTHING
;===================================================================================;

Null:	moveq	#$00,d0
	rts

;===================================================================================;
;                                FUNCTION REMAPPING
;===================================================================================;
;Function: Ignore this function, we will only use it to grab the DPKBase.
;Requires: d0 = DPKBase.
;	   a6 = Chunky Base.
;Returns:  d0 = ErrorCode

LIB_emuStart:
	move.l	d0,DPKBase	;ma = Save the DPKBase.
	moveq	#ERR_OK,d0	;d0 = No errors.
	rts

;===================================================================================;
;                             INITIALISE C2P ALGORITHM
;===================================================================================;
;Function: Initialise the C2P algorithm for emuRefreshScreen().  Note how if the
;	   screen is double buffered, we do not allocate a second chunky buffer.
;	   The reason is a second planar display buffer already exists, so
;	   having a two chunky buffers has no benefit.
;
;Requires: a0 = Screen
;Returns:  d0 = ErrorCode.

LIB_emuInitRefresh:
	MOVEM.L	D2-D7/A2-A6,-(SP)	;SP = Return used registers.
	move.l	a0,a3
	move.l	GS_Bitmap(a3),a4	;a4 = Bitmap structure.
	cmp.l	#$00,a4
	beq.s	.error

	;Move the planar screen displays (allocated in AddScreen()) to
	;GS_EMemPtrX.

	move.l	GS_MemPtr1(a3),GS_EMemPtr1(a3)	;a3 = Save planar.
	move.l	GS_MemPtr2(a3),GS_EMemPtr2(a3)	;a3 = Save planar.
	move.l	GS_MemPtr3(a3),GS_EMemPtr3(a3)	;a3 = Save planar.
	clr.l	GS_MemPtr1(a3)		;a3 = Clear record pf memory ptr.
	clr.l	GS_MemPtr2(a3)		;a3 = Clear record of memory ptr.
	clr.l	GS_MemPtr3(a3)		;a3 = Clear record of memory ptr.

	;Allocate the chunky memory, place it in GS_MemPtrX fields and store
	;the pointers in GS_EFreeX fields to free it later.

	move.l	DPKBase(pc),a6	;a6 = DPKBase.
	move.w	BMP_Width(a4),d0	;d0 = BmpWidth
	mulu	BMP_Height(a4),d0	;d0 = (BmpWidth)*BmpHeight
	moveq	#CHUNKYMEM,d1	;d1 = Memory Type (see definition).
	CALL	AllocMemBlock	;>> = Go get the chunky memory.
	move.l	d0,GS_EFree1(a3)	;a3 = Store chunky buffer for freemem.
	move.l	d0,GS_MemPtr1(a3)	;a3 = Store chunky buffer in ptr #1.
	beq.s	.error	;>> = Memory allocation error.

	move.l	GS_Attrib(a3),d2	;d2 = Screen attributes.
	and.l	#SCR_DBLBUFFER|SCR_TPLBUFFER,d2	;d2 = Double/Triple buffer?
	beq.s	.done	;>> = No, finished.
	move.l	d0,GS_MemPtr2(a3)	;a3 = Store chunky buffer in ptr #2.

	move.l	GS_Attrib(a3),d2	;d2 = Screen attributes.
	and.l	#SCR_TPLBUFFER,d2	;d2 = Triple buffer?
	beq.s	.done	;>> = Done.
	move.l	d0,GS_MemPtr3(a3)	;a3 = Store chunky buffer in ptr #3.
	
.done	move.l	GS_MemPtr1(a3),BMP_Data(a4)
	MOVEM.L	(SP)+,D2-D7/A2-A6	;SP = Return used registers.
	moveq	#ERR_OK,d0	;d0 = No errors.
	rts

.error	MOVEM.L	(SP)+,D2-D7/A2-A6	;SP = Return used registers.
	moveq	#ERR_FAILED,d0	;d0 = Failure.
	rts

;===================================================================================;
;                               REMOVE C2P ALGORITHM
;===================================================================================;
;Function: Free any allocations we made for the C2P routine.
;Requires: a0 = Screen
;	   a6 = Chunky Base.
;Returns:  Nothing.

LIB_emuFreeRefresh:
	MOVEM.L	D0/A6,-(SP)	;SP = Save used registers.
	move.l	DPKBase(pc),a6	;a6 = DPKBase.
	move.l	GS_EFree1(a0),d0	;d0 = Screen memory 1 (C2P)
	CALL	FreeMemBlock	;>> = Free screen memory.
	move.l	GS_EFree2(a0),d0	;d0 = Screen memory 2 (C2P)
	CALL	FreeMemBlock	;>> = Free screen memory.
	move.l	GS_EFree3(a0),d0	;d0 = Screen memory 3 (C2P)
	CALL	FreeMemBlock	;>> = Free screen memory.
	MOVEM.L	(SP)+,D0/A6	;SP = Return used registers.
	rts

;===================================================================================;
;                              C2P CONVERSION ROUTINE
;===================================================================================;
;Function: Do the C2P process.
;Requires: a0 = Screen
;	   a6 = Chunky Base.
;Returns:  Nothing.

LIB_emuRefreshScreen:
	MOVEM.L	D0-D7/A0-A6,-(SP)	;SP = Save used registers.
	move.l	GS_Bitmap(a0),a4
	moveq	#$00,d0	;d0 = 00.
	moveq	#$00,d1	;d1 = 00.
	move.w	BMP_Width(a4),d0	;d0 = Width.
	move.w	BMP_Height(a4),d1	;d1 = Height.
	move.l	d0,d2	;d2 = ByteWidth
	lsr.l	#3,d2	;d2 = (ByteWidth)/8 [planar]
	move.l	d2,d3	;d3 = Line modulo.
	mulu	BMP_Height(a4),d2	;d2 = (ByteWidth/8)*Height

	move.l	GS_Attrib(a0),d7	;d7 = Screen attributes
	and.l	#SCR_DBLBUFFER|SCR_TPLBUFFER,d7	;d7 = Double or triple buffered?
	bne.s	.doubleandtriple	:>> = Yes.
.single	move.l	GS_EMemPtr1(a0),a1	;a1 = Pointer to planar display.
	move.l	GS_MemPtr1(a0),a0	;a0 = Pointer to chunky buffer.
	bra.s	.process

.doubleandtriple
	move.l	GS_EMemPtr2(a0),a1	;a1 = Pointer to planar display.
	move.l	GS_MemPtr2(a0),a0	;a0 = Pointer to chunky buffer.

	;a0 = Chunky buffer.
	;a1 = First bitplane.
	;d0 = Width in pixels, multiple of 32.
	;d1 = Height in pixels (even).
	;d2 = Bitplane modulo.
	;d3 = Line modulo. Modulo from start of one line to start of next (linemod)

.process
	move.l	d2,a5	;a5 = Plane Size.
	lsl.l	#3,d2	;d2 = (PlaneSize)*8
	sub.l	a5,d2	;d2 = (PlaneSize*8)-PlaneSize
	subq.l	#2,d2	;d2 = --2
	move.l	d2,a6	;a6 = (PlaneSize*8-PlaneSize-2)
	lsr.w	#4,d0	;d0 = Width/32
	ext.l	d0	;d0 = Make long.
	move.l	d0,d4	;d4 = Width/32
	subq.l	#1,d4	;d4 = (Width/32)-1
	move.l	d4,-(SP)	;SP = Save it.
	add.l	d0,d0	;d0 = (Width/32)*2
	sub.l	d0,d3	;d3 = (LineMod)-Width/16
	sub.l	a6,d3	;d3 =
	move.l	d3,-(SP)	;SP =
	move.w	d1,d7	;d7 = Height
	subq.w	#1,d7	;d7 = (Height)-1 [for loop]
	movea.l	#$f0f0f0f0,a2	;a2 = $F0F0F0F0
	movea.l	#$cccccccc,a3	;a3 = $CCCCCCCC
	movea.l	#$aaaa5555,a4	;a4 = $AAAA5555
	move.l	a2,d6	;d6 = $F0F0F0F0
	swap	d7	;d7 = (loop)<<16
	move.w	(6,SP),d7
	move.l	(a0)+,d0
	move.l	(a0)+,d1
	move.l	(a0)+,d2
	move.l	(a0)+,d3
	move.l	d0,d4
	and.l	d6,d0
	eor.l	d0,d4
	lsl.l	#4,d4
	bra	.same

.outer	swap	d7
	move.w	(6,sp),d7
	move.w	d5,(a1)
	adda.l	a5,a1
	swap	d5
	move.w	d5,(a1)
	adda.l	(sp),a1
	movem.l	(a0)+,d0-d3
	move.l	d0,d5
	swap	d0
	rol.l	#8,d2
	move.w	d0,d4
	move.b	d2,d4
	swap	d4
	swap	d2
	move.w	d2,d4
	move.b	d0,d4
	ror.w	#8,d4
	move.b	d2,d5
	swap	d5
	swap	d2
	move.w	d2,d5
	swap	d0
	move.b	d0,d5
	ror.w	#8,d5
	move.l	d1,d2
	swap	d1
	rol.l	#8,d3
	move.w	d1,d0
	move.b	d3,d0
	swap	d0
	swap	d3
	move.w	d3,d0
	move.b	d1,d0
	ror.w	#8,d0
	move.b	d3,d2
	swap	d2
	swap	d3
	move.w	d3,d2
	swap	d1
	move.b	d1,d2
	ror.w	#8,d2
	move.l	d2,d3
	move.l	d0,d2
	move.l	d4,d0
	move.l	d5,d1
	move.l	d0,d4
	and.l	d6,d0
	eor.l	d0,d4
	lsl.l	#4,d4
	bra.s	.same

.inner	move.w	d5,(a1)
	adda.l	a5,a1
	swap	d5
	move.w	d5,(a1)
	suba.l	a6,a1
	move.l	(a0)+,d0
	move.l	d0,d5
	move.l	(a0)+,d1
	swap	d0
	move.l	(a0)+,d2
	rol.l	#8,d2
	move.w	d0,d4
	move.b	d2,d4
	swap	d4
	swap	d2
	move.w	d2,d4
	move.b	d0,d4
	ror.w	#8,d4
	move.b	d2,d5
	swap	d5
	swap	d2
	move.w	d2,d5
	swap	d0
	move.b	d0,d5
	ror.w	#8,d5
	move.l	d1,d2
	swap	d1
	move.l	(a0)+,d3
	rol.l	#8,d3
	move.w	d1,d0
	move.b	d3,d0
	swap	d0
	swap	d3
	move.w	d3,d0
	move.b	d1,d0
	ror.w	#8,d0
	move.b	d3,d2
	swap	d2
	swap	d3
	move.w	d3,d2
	swap	d1
	move.b	d1,d2
	ror.w	#8,d2
	move.l	d2,d3
	move.l	d0,d2
	move.l	d4,d0
	move.l	d5,d1
	and.l	d6,d0
	eor.l	d0,d4
	lsl.l	#4,d4

.same	move.l	d2,d5
	and.l	d6,d5
	eor.l	d5,d2
	lsr.l	#4,d5
	or.l	d5,d0
	or.l	d4,d2
	move.l	d1,d4
	and.l	d6,d1
	eor.l	d1,d4
	move.l	d3,d5
	and.l	d6,d5
	eor.l	d5,d3
	lsr.l	#4,d5
	lsl.l	#4,d4
	or.l	d5,d1
	or.l	d4,d3
	move.l	a3,d6
	move.l	d2,d4
	and.l	d6,d2
	eor.l	d2,d4
	move.l	d3,d5
	and.l	d6,d5
	eor.l	d5,d3
	lsl.l	#2,d4
	or.l	d4,d3
	move.l	a4,d6
	move.l	d3,d4
	and.l	d6,d3
	eor.l	d3,d4
	lsr.w	#1,d4
	swap	d4
	add.w	d4,d4
	or.l	d4,d3
	move.w	d3,(a1)
	adda.l	a5,a1
	lsr.l	#2,d5
	or.l	d5,d2
	move.l	d2,d4
	and.l	d6,d2
	eor.l	d2,d4
	lsr.w	#1,d4
	swap	d3
	move.w	d3,(a1)
	adda.l	a5,a1
	swap	d4
	add.w	d4,d4
	or.l	d4,d2
	move.l	a3,d6
	move.l	d0,d4
	and.l	d6,d0
	eor.l	d0,d4
	move.w	d2,(a1)
	adda.l	a5,a1
	move.l	d1,d5
	and.l	d6,d5
	eor.l	d5,d1
	lsl.l	#2,d4
	or.l	d4,d1
	move.l	a4,d6
	swap	d2
	move.w	d2,(a1)
	adda.l	a5,a1
	move.l	d1,d4
	and.l	d6,d1
	eor.l	d1,d4
	lsr.w	#1,d4
	swap	d4
	add.w	d4,d4
	or.l	d4,d1
	move.w	d1,(a1)
	adda.l	a5,a1
	lsr.l	#2,d5
	or.l	d5,d0
	move.l	d0,d5
	and.l	d6,d0
	eor.l	d0,d5
	swap	d1
	move.w	d1,(a1)
	adda.l	a5,a1
	lsr.w	#1,d5
	swap	d5
	add.w	d5,d5
	or.l	d0,d5
	move.l	a2,d6
	dbra	d7,.inner
	swap	d7
	dbra	d7,.outer
	move.w	d5,(a1)
	adda.l	a5,a1
	swap	d5
	move.w	d5,(a1)
	addq.l	#8,sp
	MOVEM.L	(SP)+,D0-D7/A0-A6	;SP = Return used registers.
	rts

;===================================================================================;
;                                       DATA
;===================================================================================;

DPKBase	dc.l	0
CHKBase dc.l	0

;-----------------------------------------------------------------------------------;
EndCode:
