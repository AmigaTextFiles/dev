	IFND GRAPHICS_BLITTER_I
GRAPHICS_BLITTER_I SET  1

**
**  $VER: blitter.i
**
**  Blitter Module Definitions
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND	DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

*****************************************************************************
* Module definitions.

BlitModVersion  = 3
BlitModRevision = 1

*****************************************************************************
* Pixel definitions.

   STRUCTURE	PXL,00
	WORD	PXL_XCoord
	WORD	PXL_YCoord
	LONG	PXL_Colour
	LABEL	PXL_SIZEOF

PIXEL	MACRO
	dc.w	\1,\2
	dc.l	\3
	ENDM

SKIPPIXEL =	-32000

*****************************************************************************
* Bitmap structure, used for blitting.

VER_BITMAP  = 2
TAGS_BITMAP = (ID_SPCTAGS<<16)|ID_BITMAP

   STRUCTURE	BMP1,HEAD_SIZEOF ;[00] Standard header.
	APTR	BMP_Data         ;[12] Pointer to bitmap data area.
	WORD	BMP_Width        ;[16] Width.
	WORD	BMP_ByteWidth    ;[18] ByteWidth.
	WORD	BMP_Height       ;[20] Height.
	WORD	BMP_Type         ;[22] Type.
	LONG	BMP_LineMod      ;[24] Line differential.
	LONG	BMP_PlaneMod     ;[28] Plane differential.
	APTR	BMP_Parent       ;[32] Bitmap owner.
	APTR	BMP_Restore      ;[36] Restore list for this bitmap, if any.
	LONG	BMP_Size         ;[40] Total size of the bitmap in bytes.
	LONG	BMP_MemType      ;[44] Memory type to use in allocation.
	WORD	BMP_Planes       ;[48] Amount of planes.
	WORD	BMP_resEmpty     ;[50] Reserved.
	LONG	BMP_AmtColours   ;[52] Maximum amount of colours available.
	APTR	BMP_Palette      ;[56] Pointer to the Bitmap's palette.
	LONG	BMP_Flags        ;[60] Optional flags.
	APTR	BMP_DrawUCPixel  ;[64] Function.
	APTR	BMP_DrawUCRPixel ;[68] Function.
	APTR	BMP_ReadUCPixel  ;[72] Function.
	APTR	BMP_ReadUCRPixel ;[76] Function.
	APTR	BMP_DrawPen      ;[80] Function.
	APTR	BMP_PenUCPixel   ;[84] Function.

BMA_Data         = (TAPTR|BMP_Data)
BMA_Width        = (TWORD|BMP_Width)
BMA_Height       = (TWORD|BMP_Height)
BMA_Type         = (TWORD|BMP_Type)
BMA_Size         = (TLONG|BMP_Size)
BMA_MemType      = (TLONG|BMP_MemType)
BMA_Planes       = (TWORD|BMP_Planes)
BMA_AmtColours   = (TLONG|BMP_AmtColours)
BMA_Palette      = (TAPTR|BMP_Palette)
BMA_Flags        = (TLONG|BMP_Flags)
BMA_DrawUCPixel  = (TAPTR|BMP_DrawUCPixel)
BMA_DrawUCRPixel = (TAPTR|BMP_DrawUCRPixel)
BMA_ReadUCPixel  = (TAPTR|BMP_ReadUCPixel)
BMA_ReadUCRPixel = (TAPTR|BMP_ReadUCRPixel)
BMA_DrawPen      = (TAPTR|BMP_DrawPen)
BMA_PenUCPixel   = (TAPTR|BMP_PenUCPixel)

*****************************************************************************
* Bitmap types (for BMP_Type).

INTERLEAVED = 1           ;Interleaved (2 ... 256 colours)
ILBM        = INTERLEAVED ;Short synonym of Interleaved.
PLANAR      = 2           ;Planar (2 ... 256 colours)
CHUNKY8     = 3           ;Chunky 8 bit (256 colours)
CHUNKY16    = 4           ;Chunky 16 bit (65535 colours)
CHUNKY32    = 5           ;True colour (16 million colours)

TRUECOLOUR  = CHUNKY32

*****************************************************************************
* Bitmap flags (for BMP_Flags).

BMF_BLANKPALETTE = $00000001  ;For a blank (black) palette.
BMF_EXTRAHB      = $00000002  ;Extra half brite.
BMF_HAM          = $00000004  ;HAM mode.

*****************************************************************************
* Pen shapes.

PSP_CIRCLE  = 1
PSP_SQUARE  = 2
PSP_PIXEL   = 3

*****************************************************************************

PALETTE_ARRAY = ((ID_PALETTE<<16)|01)

*****************************************************************************
* The RestoreList structure.

VER_RESTORE  = 1
TAGS_RESTORE = (ID_SPCTAGS<<16)|ID_RESTORE

    STRUCTURE	RH1,HEAD_SIZEOF
	WORD	RH_Buffers       ;Amount of screen buffers
	WORD	RH_Entries       ;Amount of entries.
	APTR	RH_Owner         ;Owner of the restorelist, ie bitmap.

	*** Private fields below ***

	APTR	RH_List1
	APTR	RH_List2
	APTR	RH_List3
	APTR	RH_ListPos1
	APTR	RH_ListPos2
	APTR	RH_ListPos3
	LABEL	RH_SIZEOF

RSA_Buffers = (TWORD|RH_Buffers)
RSA_Entries = (TWORD|RH_Entries)
RSA_Owner   = (TAPTR|RH_Owner)

	*** Private Structure ***

    STRUCTURE	RSE,0
	APTR	RSE_Next         ;Next restore entry in the chain.
	APTR	RSE_Prev         ;Previous restore enty in the chain.
	APTR	RSE_Bob          ;Bob structure belonging to the restore [*]
	APTR	RSE_Address      ;Screen pointer (top of screen) [*]
	LABEL	RSE_Mask         ;Pointer to the bob's mask [Label *]
	APTR	RSE_Storage      ;Background storage or NULL.
	APTR	RSE_Control      ;Controls from the lookup table.
	APTR	RSE_ConMask      ;The control mask to use.
	WORD	RSE_Modulo1      ;Modulo C
	LONG	RSE_Modulo2      ;Modulos A/D.
	LABEL	RSE_BlitSize     ;[Label *]
	WORD	RSE_BlitWidth    ;[*]
	WORD	RSE_BlitHeight   ;[*]
	LABEL	RSE_SIZEOF

*****************************************************************************
* Bob structure, also used as a skeleton for Mbob's.

VER_BOB  =  1
TAGS_BOB =  (ID_SPCTAGS<<16)|ID_BOB

    STRUCTURE	BOB1,HEAD_SIZEOF
	APTR	BOB_emp1           ;...
	APTR	BOB_emp2           ;...
	APTR	BOB_GfxCoords      ;Pointer to frame list for graphics [R:W]
	WORD	BOB_Frame          ;Current frame [R:W]
	WORD	BOB_emp3           ;...
	WORD	BOB_Width          ;Width in pixels (true width) [R:I]
	WORD	BOB_ByteWidth      ;Width in bytes (round up) [R]
	WORD	BOB_XCoord         ;X coordinate [R:W]
	WORD	BOB_YCoord         ;Y coordinate [R:W]
	WORD	BOB_Height         ;Height in pixels [R:I]
	WORD	BOB_ClipLX         ;Left X border in bytes.
	WORD	BOB_ClipTY         ;Top Y border.
	WORD	BOB_ClipRX         ;Right X border in bytes.
	WORD	BOB_ClipBY         ;Bottom Y border.
	WORD	BOB_FPlane         ;First plane to blit to (planar only) [R:I]
	WORD	BOB_Planes         ;Amount of planes [R:I]
	WORD	BOB_PropHeight     ;Expected height of source bitmap.
	WORD	BOB_PropWidth      ;Expected width of source bitmap.
	WORD	BOB_Buffers        ;Amount of buffers in dest screen [O:R]
	LONG	BOB_PlaneSize      ;Size of a single plane (planar only) [R]
	LONG	BOB_Attrib         ;Attributes like CLIP and MASK.
	APTR	BOB_SrcBitmap      ;Source Bitmap.
	WORD	BOB_Empty          ;Reserved (in use by MBob).
	WORD	BOB_emp4           ;...
	APTR	BOB_Source         ;Pointer to bob source (origin).
	APTR	BOB_DirectGfx      ;Pointer to direct frame list [R]
	APTR	BOB_DestBitmap     ;Destination Bitmap [R]
	APTR	BOB_MaskCoords     ;Pointer to frame list for masks [R:I]
	APTR	BOB_DirectMasks    ;Pointer to direct frame list [R]
	APTR	BOB_MaskBitmap     ;Source Bitmap for masks.
	WORD	BOB_AmtFrames      ;Total amount of frames in GfxCoords.

	*** Private fields start now ***

	WORD	BOB_StoreSize      ;4/8/12 Sizeof one store entry (MBob's)
	APTR	BOB_StoreBuffer    ;A/B/C [0/4/8] storage pointer (MBob's)
	WORD	BOB_StoreMax       ;Maximum store position.
	APTR	BOB_StoreMemory    ;Master storage pointer (for the freemem).
	WORD	BOB_StoreCount     ;Counter for store, 0, 4, 8.
	APTR	BOB_StoreA         ;Storage buffer 1.
	APTR	BOB_StoreB         ;Storage buffer 2.
	APTR	BOB_StoreC         ;Storage buffer 3.
	APTR	BOB_DrawRoutine    ;Routine for drawing/clearing/storing.
	APTR	BOB_ClearRoutine   ;Routine for clearing.
	APTR	BOB_RestoreRoutine ;Routine for restoring/clearing.
	APTR	BOB_HeightRoutine  ;Replaces BS_DrawRoutine for large heights.
	LONG	BOB_ScreenSize     ;Size of destination plane.
	WORD	BOB_Modulo         ;Bob Modulo (PicWidth-BobWidth)
	WORD	BOB_MaskModulo     ;Mask Modulo (BobWidth-BobWidth for GENMASK).
	APTR	BOB_MaskMemory     ;Master mask pointer (for the freemem).
	WORD	BOB_MaxHeight      ;Maximum possible height, limited by blitter.
	WORD	BOB_ScrLine        ;Size of a line (for interleaved).
	WORD	BOB_BobLine        ;Size of a Bob line (Width*Planes)
	WORD	BOB_MaskLine       ;Size of a Mask Line (Width*Planes)
	WORD	BOB_TrueWidth      ;The true pixel width (++shift)
	WORD	BOB_TrueBWidth     ;The true byte width (++shift)
	WORD	BOB_TrueWWidth     ;The true word width (++shift)
	WORD	BOB_ClipBLX        ;ClipLX, byte.
	WORD	BOB_ClipBRX        ;ClipRX, byte.
	LONG	BOB_Modulo1        ;Modulus. (C/B)
	LONG	BOB_Modulo2        ;Modulus. (A/D)
	LONG	BOB_NSModulo1      ;Modulus. (C/B)
	LONG	BOB_NSModulo2      ;Modulus. (A/D)
	WORD	BOB_WordWidth      ;The word width.
	BYTE	BOB_AFlags         ;Allocation flags.
	BYTE	BOB_Pad            ;
	APTR	BOB_Screen         ;
	APTR	BOB_MaskData       ;
	WORD	BOB_SrcWidth       ;Source Page Width in bytes.
	WORD	BOB_SrcMaskWidth   ;Mask Page Width in bytes.

BBA_Frame        = (TWORD|BOB_Frame)
BBA_GfxCoords    = (TAPTR|BOB_GfxCoords)
BBA_Width        = (TWORD|BOB_Width)
BBA_Height       = (TWORD|BOB_Height)
BBA_XCoord       = (TWORD|BOB_XCoord)
BBA_YCoord       = (TWORD|BOB_YCoord)
BBA_ClipLX       = (TWORD|BOB_ClipLX)
BBA_ClipTY       = (TWORD|BOB_ClipTY)
BBA_ClipRX       = (TWORD|BOB_ClipRX)
BBA_ClipBY       = (TWORD|BOB_ClipBY)
BBA_FPlane       = (TWORD|BOB_FPlane)
BBA_Planes       = (TWORD|BOB_Planes)
BBA_PropHeight   = (TWORD|BOB_PropHeight)
BBA_PropWidth    = (TWORD|BOB_PropWidth)
BBA_Buffers      = (TWORD|BOB_Buffers)
BBA_Attrib       = (TLONG|BOB_Attrib)
BBA_SrcBitmap    = (TAPTR|BOB_SrcBitmap)
BBA_Source       = (TAPTR|BOB_Source)
BBA_MaskCoords   = (TAPTR|BOB_MaskCoords)
BBA_MaskBitmap   = (TAPTR|BOB_MaskBitmap)

BBA_SourceTags   = (TSTEPIN|TTRIGGER|BOB_Source)
BBA_AmtPlanes    = BBA_Planes

*****************************************************************************
* MBob structure for MBV1, based on BBV1.

VER_MBOB  =  1
TAGS_MBOB =  (ID_SPCTAGS<<16)|ID_MBOB

    STRUCTURE	MBOB1,HEAD_SIZEOF
	APTR	MB_emp1           ;...
	APTR	MB_emp2           ;...
	APTR	MB_GfxCoords      ;Pointer to frame list for graphics.
	WORD	MB_AmtEntries     ;Amount of entries in the image list.
	WORD	MB_emp3           ;...
	WORD	MB_Width          ;Width in pixels.
	WORD	MB_ByteWidth      ;Width in bytes.
	APTR	MB_EntryList      ;Pointer to the entry/image list.
	WORD	MB_Height         ;Height in pixels.
	WORD	MB_ClipLX         ;Left X border in bytes.
	WORD	MB_ClipTY         ;Top Y border.
	WORD	MB_ClipRX         ;Right X border in bytes.
	WORD	MB_ClipBY         ;Bottom Y border.
	WORD	MB_FPlane         ;First plane to blit to (planar only)
	WORD	MB_Planes         ;Amount of planes.
	WORD	MB_PropHeight     ;Expected height of source picture.
	WORD	MB_PropWidth      ;Expected width of source picture.
	WORD	MB_Buffers        ;Amount of buffers in dest screen.
	LONG	MB_PlaneSize      ;Size Of Plane Source (planar only)
	LONG	MB_Attrib         ;Attributes like CLIP and MASK.
	APTR	MB_SrcBitmap      ;Source Bitmap.
	WORD	MB_EntrySize      ;Size of each entry.
	WORD	MB_emp4           ;...
	APTR	MB_Source         ;Pointer to source structure (bob origin).
	APTR	MB_DirectGfx      ;Pointer to direct frame list.
	APTR	MB_DestBitmap     ;Pointer to Bob's destination Bitmap.
	APTR	MB_MaskCoords     ;Pointer to frame list for masks.
	APTR	MB_DirectMasks    ;
	APTR	MB_MaskBitmap     ;
	WORD	MB_AmtFrames      ;Total amount of frames in frame/direct lists.

   STRUCTURE	BE,0              ;MBob Entry Structure.
	WORD	BE_XCoord
	WORD	BE_YCoord
	UWORD	BE_Frame
	LABEL	BE_SIZEOF

SKIPIMAGE =  32000

MBA_AmtEntries   = (TWORD|MB_AmtEntries)
MBA_GfxCoords    = (TAPTR|MB_GfxCoords)
MBA_Width        = (TWORD|MB_Width)
MBA_Height       = (TWORD|MB_Height)
MBA_EntryList    = (TAPTR|MB_EntryList)
MBA_ClipLX       = (TWORD|MB_ClipLX)
MBA_ClipTY       = (TWORD|MB_ClipTY)
MBA_ClipRX       = (TWORD|MB_ClipRX)
MBA_ClipBY       = (TWORD|MB_ClipBY)
MBA_FPlane       = (TWORD|MB_FPlane)
MBA_Planes       = (TWORD|MB_Planes)
MBA_Attrib       = (TLONG|MB_Attrib)
MBA_SrcBitmap    = (TAPTR|MB_SrcBitmap)
MBA_EntrySize    = (TWORD|MB_EntrySize)
MBA_Source       = (TAPTR|MB_Source)
MBA_Buffers      = (TWORD|MB_Buffers)
MBA_MaskCoords   = (TAPTR|MB_MaskCoords)
MBA_PropWidth    = (TWORD|MB_PropWidth)
MBA_PropHeight   = (TWORD|MB_PropHeight)
MBA_MaskBitmap   = (TAPTR|MB_MaskBitmap)

*****************************************************************************
* Drawing Methods and Options for both bob structures (BOB_Attrib).

B_CLIP     = 	0       ;Allow border clipping.
B_MASK     = 	1       ;Allow masking.
B_FILLMASK =	2       ;Fill any holes in the mask on generation.
B_CLEAR    =	3       ;Allow automatic clearing.
B_RESTORE  =	4       ;Allow automatic background restore.
;B_ = 5
B_CLRMASK  =	6       ;Use masks in the clear.
B_GENONLY  =	7       ;Create and use masks for drawing this bob.

BBF_CLIP     =  (1<<B_CLIP)
BBF_MASK     =  (1<<B_MASK)
BBF_FILLMASK =  (1<<B_FILLMASK)
BBF_CLEAR    =  (1<<B_CLEAR)
BBF_RESTORE  =  (1<<B_RESTORE)
; = 1<<
BBF_CLRMASK  =  (1<<B_CLRMASK)
BBF_GENONLY  =  (1<<B_GENONLY)
BBF_GENMASKS =  (BBF_GENONLY|BBF_MASK)

BBF_CLRNOMASK = 0                ;Do not use masks in the clear (default).
BBF_GENMASK   = BBF_GENMASKS     ;Synonym.
BBF_FILLMASKS = BBF_FILLMASK     ;Synonym.
BBF_GENFMASK  = (BBF_GENMASK|BBF_FILLMASK)

*****************************************************************************

BSORT_X         = $00000001
BSORT_Y         = $00000002
BSORT_DOWNTOP   = $00000004    ;From Bottom to top.
BSORT_RIGHTLEFT = $00000008    ;Right to Left.
BSORT_LEFTRIGHT = $00000000    ;Default.
BSORT_TOPDOWN   = $00000000    ;Default.


	ENDC	;GRAPHICS_BLITTER_I
