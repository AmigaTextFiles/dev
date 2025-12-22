;===================================================================================;
;                                 CHUNKY8 EMULATOR
;===================================================================================;
;This c2p routine is the slowest, as it uses simple bit testing/setting
;instructions.  It has an advantage of no restrictions (any screen width/height is
;okay).

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
	dc.b	"020.Simple",0
	even
	dc.b	"$VER: "
IDString:
	dc.b	"Chunky 8 Emulator V1.0",10,0
	even

Init:	dc.l	CHKBase_SIZEOF,FunctionTable,DataTable,InitRoutine

FunctionTable:
FT:	dc.w	-1,Open-FT,Close-FT,Expunge-FT,Null-FT
	dc.w	LIB_emuRemapFunctions-FT
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
;Returns:  Nothing.

LIB_emuRemapFunctions:
	move.l	d0,DPKBase	;ma = Save the DPKBase.
	rts

;===================================================================================;
;                             INITIALISE C2P ALGORITHM
;===================================================================================;
;Function: Initialise the C2P algorithm for emuRefreshScreen().  Note how if the
;	   screen is double buffered, we do not allocate a second chunky buffer.
;	   The reason is because a second planar display buffer already exists, so
;	   having a second chunky buffer has no benefit.
;Requires: a0 = Screen
;	   a6 = Chunky Base.
;Returns:  d0 = ErrorCode.

LIB_emuInitRefresh:
	MOVEM.L	D1-D7/A0-A6,-(SP)	;SP = Return used registers.
	move.l	DPKBase(pc),a6	;a6 = DPKBase.
	move.l	GS_Bitmap(a0),a4

	;Move the planar screen displays (allocated in AddScreen()) to
	;GS_EMemPtrX.

	move.l	GS_MemPtr1(a0),GS_EMemPtr1(a0)
	move.l	GS_MemPtr2(a0),GS_EMemPtr2(a0)
	move.l	GS_MemPtr3(a0),GS_EMemPtr3(a0)

	;Allocate the chunky memory, place it in GS_MemPtrX fields and store
	;the pointers in GS_EFreeX fields to free it later.

	move.w	BMP_Width(a4),d0	;d0 = PicWidth
	mulu	BMP_Height(a4),d0	;d0 = (PicWidth)*PicHeight
	moveq	#CHUNKYMEM,d1	;d1 = Memory Type (see definition).
	CALL	AllocMemBlock	;>> = Go get the chunky memory.
	move.l	d0,GS_EFree1(a0)	;a4 = Store chunky buffer for freemem.
	move.l	d0,GS_MemPtr1(a0)	;a0 = Store chunky buffer #1.
	beq.s	.error	;>> = Memory allocation error.

	move.l	GS_Attrib(a0),d2	;d2 = Screen attributes.
	and.l	#SCR_DBLBUFFER,d2	;d2 = Double buffer?
	beq.s	.done	;>> = No, finished.
	move.l	d0,GS_MemPtr2(a0)	;a0 = Store chunky buffer #1.

.done	MOVEM.L	(SP)+,D1-D7/A0-A6	;SP = Return used registers.
	moveq	#ERR_SUCCESS,d0
	rts

.error	MOVEM.L	(SP)+,D1-D7/A0-A6	;SP = Return used registers.
	moveq	#ERR_FAILED,d0
	rts

;===================================================================================;
;                            DE-INITIALISE C2P ALGORITHM
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
	move.l	DPKBase(pc),a6	;a6 = DPKBase.
	move.l	GS_Bitmap(a0),a4	;a4 = Bitmap
	move.w	BMP_ByteWidth(a4),d5	;d5 = PicWidth	[Chunky]    [320]
	mulu	BMP_Height(a4),d5	;d5 = (PicWidth)*PicHeight [320*256]
	move.w	BMP_Width(a4),d0	;d0 = PicWidth	[Chunky]    [320]
	lsr.w	#3,d0	;d0 = PicWidth/8 [Planar]  [320/8]
	mulu	BMP_Height(a4),d0	;d0 = Size of a planar bitplane.

	move.l	GS_Attrib(a0),d1	;d1 = Screen attributes
	and.l	#SCR_DBLBUFFER|SCR_TPLBUFFER,d1	;d1 = Double or triple buffered?
	bne.s	.doubleandtriple	:>> = Yes.

.single	move.l	GS_EMemPtr1(a0),a1	;a1 = Pointer to planar display.
	move.l	GS_MemPtr1(a0),a0	;a0 = Pointer to chunky buffer.
	bra.s	.process

.doubleandtriple
	move.l	GS_EMemPtr2(a0),a1	;a1 = Pointer to planar display.
	move.l	GS_MemPtr2(a0),a0	;a0 = Pointer to chunky buffer.

.process
	lea	(a1,d0.l*2),a2	;a2 = Plane 2.
	lea	(a2,d0.l*2),a3	;a3 = Plane 4.
	lea	(a3,d0.l*2),a4	;a4 = Plane 6.
	lea	(a4,d0.l),a5	;a5 = Plane 7.
	move.l	a0,a6	;a6 = Start of chunky plane.
	add.l	d5,a6	;a6 = End of chunky plane.

	;a0 = Chunky buffer
	;a1 = Plane 0
	;a1 = Plane 1
	;a2 = Plane 2
	;a2 = Plane 3
	;a3 = Plane 4
	;a3 = Plane 5
	;a4 = Plane 6
	;a5 = Plane 7
	;a6 = End of chunky plane.
	;
	;d6 = Chunky byte.
	;d7 = Pixel position in planar destination.

.copy	moveq	#8-1,d7	;d7 = 8 pixels to copy across.
	moveq	#$00,d1
	moveq	#$00,d2
	moveq	#$00,d3
	moveq	#$00,d4
	moveq	#$00,d5
	clr.b	(a3,d0.l)
	clr.b	(a4)
	clr.b	(a5)
.loop	move.b	(a0)+,d6	;d6 = Chunky byte.
.bit0	btst	#0,d6
	beq.s	.bit1
	bset	d7,d1
.bit1	btst	#1,d6
	beq.s	.bit2
	bset	d7,d2
.bit2	btst	#2,d6
	beq.s	.bit3
	bset	d7,d3
.bit3	btst	#3,d6
	beq.s	.bit4
	bset	d7,d4
.bit4	btst	#4,d6
	beq.s	.bit5
	bset	d7,d5
.bit5	btst	#5,d6
	beq.s	.bit6
	bset	d7,(a3,d0.l)
.bit6	btst	#6,d6
	beq.s	.bit7
	bset	d7,(a4)
.bit7	btst	#7,d6
	beq.s	.done
	bset	d7,(a5)
.done	dbra	d7,.loop	;d7 = --1 and loop.

	move.b	d2,(a1,d0.l)
	move.b	d1,(a1)+
	move.b	d4,(a2,d0.l)
	move.b	d3,(a2)+
	move.b	d5,(a3)+
	addq.w	#1,a4
	addq.w	#1,a5
	cmp.l	a0,a6
	bne.s	.copy
	MOVEM.L	(SP)+,D0-D7/A0-A6	;SP = Return used registers.
	rts

;===================================================================================;
;                                       DATA
;===================================================================================;

DPKBase	dc.l	0
CHKBase dc.l	0

;-----------------------------------------------------------------------------------;
EndCode:
