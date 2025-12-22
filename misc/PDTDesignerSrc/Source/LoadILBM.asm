	opt	c+,d+,l+,o+,i+

******************* (C)1992 P.D.Turner.   Version 1.04 ******************
*									*
*	NAME								*
*		LoadILBM -- Load a raster described by the given	*
*				IFF ILBM file into a ViewPort.		*
*									*
*	SYNOPSIS							*
*		ViewPort = LoadILBM( Name, ViewPort );			*
*				     a0    a1				*
*									*
*	FUNCTION							*
*		Use the given file and setup the ViewPort fields	*
*		  according to the data in the file.  If any part of	*
*		  the ViewPort is missing, eg. BitMap, then this is 	*
*		  allocated and initialised correctly.  This also	*
*		  applies the the ViewPort structure itself, so by	*
*		  passing a NULL pointer you get the whole thing	*
*		  created for you!					*
*									*
*	INPUTS								*
*		    Name - Pointer to filename of file to load.		*
*		ViewPort - Pointer to ViewPort to load ILBM into.	*
*			    If NULL, LoadILBM creates a ViewPort.	*
*									*
*	RESULTS								*
*		ViewPort - Pointer to ViewPort setup using data from	*
*				the input file.  Or <0 failure code.	*
*									*
*	BUGS								*
*		None							*
*									*
*	SEE ALSO							*
*		SaveILBM.asm, iff.i, IFF Texts in RKM's			*
*									*
*************************************************************************
*
*	Additional notes...
*
*   The routine currently requires the DOS and Gfx libraries to be opened
*     and their base pointers exported.  At some point in time these
*     functions may be incorporated into a run time shared library, in which
*     case the base pointers would no longer be required.
*
*	*****  V1.01 *****
*
*   This routine, unlike LoadILBM under version 1.00, does *not*
*     require any user structures to be present for the function to work
*     properly.
*
*	*****  V1.02 *****
*
*   The ColorMap routine allocates a Variable sized ColorMap, rather than a
*     32 Entry fixed sized one as under previous versions.
*
*	***** V1.03 ******
*
*   This routine now uses the IFF failure codes in iff.i on this disk, this
*     will allow client routines to give the user more information on what
*     happened / when wrong.
*
*	***** V1.04 ******
*
*   Provious versions did not dispose of the mask plane properly, this is now
*     fixed.
*
*	Last Changed:		**** P.T 27/11/93 ****


		incdir	Sys:Include/
		include	exec/exec_lib.i
		include	exec/memory.i
		include	graphics/graphics_lib.i
		include	graphics/view.i
		include	libraries/dos_lib.i
		include	libraries/dos.i

		include	MapDesignerV2.0:Source/iff.i   ; Custom include file!

		xdef	_LoadILBM
		xref	_DOSBase,_GfxBase

_LoadILBM:

;   This is the main control routine, it sets up everything needed then sits
; in a loop reading and processing chunks, until either the end_of_file or
; a BODY chunk is found.

	movem.l	d2-7/a2-6,-(sp)		; Save callers regs.
	link	a5,#lsf_SIZEOF		; Allocate global stack-frame.
	move.l	a0,lsf_FileName(a5)	; Store users inputs.
	move.l	a1,lsf_ViewPort(a5)
	clr.l	lsf_Flags(a5)		; flags,
	clr.l	lsf_Chunk(a5)		; chunk,
	clr.l	lsf_FileHandle(a5)	; and file handle pointers.
	tst.l	lsf_ViewPort(a5)	; Is view port pointer NULL?
	bne.s	.GotVPort		; No, then check for RasInfo.
	move.l	#IFF_NO_MEMORY,lsf_Return(a5)  ; Pre load failure code.
	moveq	#vp_SIZEOF,d0
	move.l	#(MEMF_CLEAR!MEMF_PUBLIC),d1
	CALLEXEC	AllocMem	; Allocate memory for the VPort.
	move.l	d0,lsf_ViewPort(a5)	; Store and test pointer.
	beq	.Failure		; Exit if there was a probelm.
	move.l	d0,a0
	CALLGRAF	InitVPort	; Initialise new VPort.
	ori.l	#FLGF_VPORT,lsf_Flags(a5)	; Tell cleanup VPort's ours.
.GotVPort:
	move.l	lsf_ViewPort(a5),a2
	tst.l	vp_RasInfo(a2)		; Is RasInfo pointer NULL?
	bne.s	.GotRasInfo		; No, then check for BitMap.
	moveq	#ri_SIZEOF,d0
	move.l	#(MEMF_CLEAR!MEMF_PUBLIC),d1
	CALLEXEC	AllocMem	; Allocate memory for the RasInfo.
	move.l	d0,vp_RasInfo(a2)	; Store and test pointer.
	beq	.Failure		; Exit if there was a probelm.
	ori.l	#FLGF_RINFO,lsf_Flags(a5)      ; Tell cleanup RasInfo's ours.
.GotRasInfo:
	move.l	vp_RasInfo(a2),a2
	tst.l	ri_BitMap(a2)		; Is BitMap pointer NULL?
	bne.s	.GotBitMap		; No, then check for load file.
	moveq	#bm_SIZEOF,d0
	move.l	#(MEMF_CLEAR!MEMF_PUBLIC),d1
	CALLEXEC	AllocMem	; Allocate memory for the BitMap.
	move.l	d0,ri_BitMap(a2)	; Store and test pointer.
	beq	.Failure		; Exit if there was a probelm.
	ori.l	#FLGF_BITMAP,lsf_Flags(a5)      ; Tell cleanup BitMap's ours.
.GotBitMap:
	move.l	#IFF_NO_FILE,lsf_Return(a5)	; Set up failure code.
	move.l	lsf_FileName(a5),d1
	move.l	#MODE_OLDFILE,d2
	CALLDOS		Open		; Attempt to open the input file.
	move.l	d0,lsf_FileHandle(a5)
	beq	.Failure		; Exit if there was a problem.
	move.l	#IFF_FAILURE,lsf_Return(a5)   ; Set up DOS error failure.
	move.l	d0,d1
	moveq	#12,d3
	move.l	a5,d2
	addi.l	#lsf_ID,d2
	CALLDOS		Read		; Read in file size, type etc.
	cmpi.l	#-1,d0
	beq.s	.Failure		; Exit if read failed
	move.l	#IFF_NOT_IFF,lsf_Return(a5)   ; Set up failure code.
	cmpi.l	#ID_FORM,lsf_ID(a5)	; Is it an IFF-85 FORM?
	bne.s	.Failure		; No, then exit.
	move.l	#IFF_NOT_ILBM,lsf_Return(a5)   ; Set up failure code.
	cmpi.l	#ID_ILBM,lsf_Type(a5)	; Is file ILBM type?
	bne.s	.Failure		; No, then exit.
.ParserLoop:
	bsr.s	ReadChunk		; Read in next chunk.
	move.l	d0,lsf_Chunk(a5)	; Save & Test pointer.
	beq.s	.Failure		; Exit if there was no chunk.
	cmpi.l	#ID_BMHD,lsf_ID(a5)	; Is this a BMHD chunk?
	bne.s	.CMAP			; No, then branch.
	bsr	HandleBMHD		; Handle the chunk.
	bra.s	.ChunkDone		; Branch when finished.
.CMAP:
	cmpi.l	#ID_CMAP,lsf_ID(a5)	; Is this a CMAP chunk?
	bne.s	.CAMG			; No, then branch.
	bsr	HandleCMAP		; Handle the chunk.
	bra.s	.ChunkDone		; Branch when finished.
.CAMG:
	cmpi.l	#ID_CAMG,lsf_ID(a5)	; Is this a CAMG chunk?
	bne.s	.BODY			; No, then branch.
	bsr	HandleCAMG		; Handle the chunk.
	bra.s	.ChunkDone		; Branch when finished.
.BODY:
	cmpi.l	#ID_BODY,lsf_ID(a5)	; Is this a BODY chunk?
	bne.s	.ParserLoop		; No, then get next chunk.
	bsr	HandleBODY		; Handle the chunk.
.ChunkDone:
	tst.l	d0			; Was chunk handled correctly?
	beq.s	.Success
.Failure:
	bsr	Cleanup			; Free all structures we allocated.
	bra.s	.Exit			; Now exit.
.Success:
	cmpi.l	#ID_BODY,lsf_ID(a5)
	bne.s	.ParserLoop		; Loop if not done...
	move.l	lsf_ViewPort(a5),lsf_Return(a5)		; Set return code.
.Exit:
	move.l	lsf_FileHandle(a5),d1
	beq.s	.NoFile
	CALLDOS		Close		; Close input file, if opened.
.NoFile:
	move.l	lsf_Return(a5),d0	; Get return value.
	unlk	a5			; Free stack-frame.
	movem.l	(sp)+,d2-7/a2-6		; Restore callers regs.
	rts				; Return!!

ReadChunk:

;   This routine reads the next chunk from the file.

	bsr	FreeOldCk	; Remove any existing chunk.
	move.l	#IFF_FAILURE,lsf_Return(a5)   ; Set up failure code.
	moveq	#ck_SIZEOF,d3	; Number of bytes in header.
	move.l	lsf_FileHandle(a5),d1	; File.
	move.l	a5,d2
	addi.l	#lsf_ID,d2
	CALLDOS		Read	; Read in next chunk header.
	cmpi.l	#-1,d0
	beq.s	.CleanFail	; Exit if there was a problem.
	move.l	#IFF_BAD_FORM,lsf_Return(a5)
	tst.l	d0
	beq.s	.CleanFail	; Or if the end of file was reached.
	move.l	lsf_Size(a5),d0
	btst	#0,d0		; Ensure size is even...
	beq.s	.Even
	addq.l	#1,d0		; Add 1 to make size even.
	move.l	d0,lsf_Size(a5)
.Even:
	move.l	#IFF_NO_MEMORY,lsf_Return(a5)   ; Set up failure code.
	moveq	#MEMF_PUBLIC,d1		; Public memory.
	CALLEXEC	AllocMem	; Get memory for chunk.
	move.l	d0,lsf_Chunk(a5)
	beq.s	.CleanFail		; Exit if there was no memory.
	move.l	#IFF_FAILURE,lsf_Return(a5)   ; Set up failure code.
	move.l	d0,d2
	move.l	lsf_Size(a5),d3
	move.l	lsf_FileHandle(a5),d1
	CALLDOS		Read		; Read in data chunk.
	cmpi.l	#-1,d0
	beq.s	.DirtyFail		; Exit if read failed.
	move.l	lsf_Chunk(a5),d0
	bra.s	.Exit			; Return chunk on success
.DirtyFail:
	bsr	FreeOldCk		; Free chunk memory.
.CleanFail:
	moveq	#0,d0			; Return failure.
.Exit:
	rts

HandleBMHD:

;   This funtion takes info from the bmhd chunk, and initialises the ViewPort
; and BitMap structures.  It also allocates calls the routine to allocate the
; BitPlanes.

	bsr	FreePlanes		; Free any old planes.
	move.l	lsf_Chunk(a5),a0	; Pointer to BMHD.
	move.l	lsf_ViewPort(a5),a1	; Pointer to destination VPort.
	move.w	bmhd_pageWidth(a0),vp_DWidth(a1)	; Set screen width.	
	move.w	bmhd_pageHeight(a0),vp_DHeight(a1)	; Set screen height.
	move.w	#0,vp_DxOffset(a1)	; Set D. Offsets to 0...
	move.w	#0,vp_DyOffset(a1)
	move.l	vp_RasInfo(a1),a1	; Get RasInfo.
	move.w	#0,ri_RxOffset(a1)	; Set R. Offsets to 0...
	move.w	#0,ri_RyOffset(a1)
	move.l	#IFF_BAD_FORM,lsf_Return(a5)   ; Set up failure code.
	cmpi.b	#cmpByteRun1,bmhd_compression(a0)	; Check compression.
	blt.s	.NoCompression
	bgt.s	.Failure		; Fail we we don't know alogrithm.
	ori.l	#FLGF_COMPRESSED,lsf_Flags(a5)
.NoCompression:
	cmpi.b	#mskHasMask,bmhd_masking(a0)	; Check masking.
	bne.s	.NoMask
	ori.l	#FLGF_MASKING,lsf_Flags(a5)
.NoMask:
	move.w	bmhd_w(a0),d1		; Get raster width.
	move.w	bmhd_h(a0),d2		; Get raster height.
	move.b	bmhd_nPlanes(a0),d0	; Get depth.
	move.l	ri_BitMap(a1),a0	; Get BitMap.
	CALLGRAF	InitBitMap	; Setup the BitMap structure.
	bsr	AllocPlanes		; Get BitPlanes.
	tst.l	d0
	beq.s	.AllOK
.Failure:
	moveq	#-1,d0		; Set negative failure code.
	bra.s	.Exit		; Then exit.
.AllOK:
	moveq	#0,d0		; Set success code.
.Exit:
	rts			; Return!!

HandleCMAP:

;   This routine handles CMAP chunks, it first ensures that a 32 color
; colour map is present in the ViewPort structure.  The it sits in a loop
; setting the ColorMap values.

** This copy allocates a variable ColorMap not always a 32 color one **

	move.l	lsf_ViewPort(a5),a2	; Get ViewPort.
	tst.l	vp_ColorMap(a2)		; Does a ColorMap exist?
	bne.s	.TheirCMAP		; Yes, Delete it.
	ori.l	#FLGF_COLMAP,lsf_Flags(a5)   ; This is our Colour Map.
	bra.s	.NoCMAP
.TheirCMAP:
	move.l	vp_ColorMap(a2),a0
	CALLGRAF	FreeColorMap	; Free the old ColorMap.
.NoCMAP:
	move.l	lsf_Size(a5),d0
	divu.w	#3,d0			; Get number of regs in CMAP chunk.
	ext.l	d0
	cmpi.l	#32,d0
	ble.s	.SizeOK			; If theres more than 32, only alloc
	move.l	#IFF_NO_MEMORY,lsf_Return(a5)   ; Set up failure code.
	moveq	#32,d0			; the first 32.
.SizeOK:
	CALLGRAF	GetColorMap	; Attempt to allocate a new Map.
	move.l	d0,vp_ColorMap(a2)
	bne.s	.GotIt			; Branch if we got it.
	moveq	#-1,d0			; Else, set failure code.
	bra.s	.Exit			; And exit.
.GotIt:
	move.l	lsf_Size(a5),d4
	divu.w	#3,d4			; Get number of regs in CMAP chunk.
	cmpi.w	#32,d4
	ble.s	.NumOK			; If theres more than 32, only handle
	moveq	#32,d4			; the first 32.
.NumOK:
	move.l	d0,a3			; ColorMap pointer.
	move.l	lsf_Chunk(a5),a2	; Get pointer to data.
	moveq	#0,d5			; This is the current entry.
.CMAPLoop:
	move.w	d5,d0			; Entry number.
	move.b	(a2)+,d1
	lsr.b	#4,d1			; Red intensity.
	move.b	(a2)+,d2
	lsr.b	#4,d2			; Green intensity.
	move.b	(a2)+,d3
	lsr.b	#4,d3			; Blue intensity.
	move.l	a3,a0			; ReCall ColorMap
	CALLGRAF	SetRGB4CM	; Set value.
	addq.w	#1,d5
	cmp.w	d4,d5			; See if we're finished.
	blt.s	.CMAPLoop		; Loop if not...
	moveq	#0,d0			; Set success return
.Exit:
	rts

HandleCAMG:

;   This routine sets up the modes for this ViewPort.

	move.l	lsf_Chunk(a5),a0	; Get chunk.
	move.l	camg_ViewModes(a0),d0	; Get Modes.
	andi.l	#CAMGMASK,d0		; Remove any illegal modes.
	move.l	lsf_ViewPort(a5),a0	; Get ViewPort.
	move.w	d0,vp_Modes(a0)		; Install modes.
	moveq	#0,d0			; Return success.
	rts

HandleBODY:
;   This routine handles the de-coding of the body chunk into the BitMap
; planes.  It handles the ByteRun1 compression, and removes a masking plane
; if one was present.  This routine acts as a controler, the actual de-coding
; is done by the DecodeRow(); routine, which you should call with a2 pointing
; to the place where the data should be written, if this pointer is NULL then
; the data is discarded (implemented specially for masking!!).

	move.l	lsf_Chunk(a5),a0	; Get ptr to BODY data.
	move.l	lsf_ViewPort(a5),a1
	move.l	vp_RasInfo(a1),a1
	move.l	ri_BitMap(a1),a1	; Get ptr to BitMap.
	move.l	#IFF_BAD_FORM,lsf_Return(a5)   ; Set up failure code.
	tst.l	bm_Planes(a1)	; Is there at least 1 plane?
	beq.s	.BODYFailure	; No, exit with a failure code.
	move.w	bm_Rows(a1),d4	; Number of times to loop.
	subq.w	#1,d4		; Adjustment for dbra.
	moveq	#0,d2		; Offset into Bit-plane.
.RowsLoop:
	move.b	bm_Depth(a1),d5	; Number of times to loop.
	ext.w	d5		; Make byte a word.
	subq.w	#1,d5		; Adjustment for dbra.
	moveq	#0,d3		; Number of plane (x4).
.DepthLoop:
	move.l	bm_Planes(a1,d3),a2	; Get base of plane.
	adda.l	d2,a2			; Add on the offset.
	bsr.s	DecodeRow	; Decode the raster row.
	addq.w	#4,d3		; Advance onto next plane.
	dbra	d5,.DepthLoop	; Repeat for all planes...
	move.l	lsf_Flags(a5),d5	; Get compression & masking.
	btst	#FLGB_MASKING,d5	; Does this raster have a mask?
	beq.s	.NoMask		; No, then branch.
	move.l	#0,a2		; Discard the data.
	bsr.s	DecodeRow	; Decode the mask row.
.NoMask:
	add.w	bm_BytesPerRow(a1),d2	; Advance onto next row.
	dbra	d4,.RowsLoop	; Repeat whole process for all rows...
	move.l	#0,-(sp)	; Set success return code.
.Exit:
	bsr	FreeOldCk
	move.l	(sp)+,d0	; Get the return code.
	rts			; Return!!
.BODYFailure:
	move.l	#-1,-(sp)	; Set failure code.
	bra.s	.Exit		; Now exit...

DecodeRow:
	movem.l	d0-7/a1/a3-6,-(sp)	; Save all regs. except a2 & a0.
	move.l	a2,d3			; Used in a test later.
	moveq	#0,d2			; d2 - Bytes written out.
	move.l	lsf_Flags(a5),d0	; Get compression.
	btst	#FLGB_COMPRESSED,d0
	bne.s	.Compressed	; Branch if it *is* compressed.
	move.w	bm_BytesPerRow(a1),d0	; Get bytes per row
	subq.w	#1,d0		; Emulate a compressed byte.
	bra.s	.Literally	; Go straigh into literal loop.
.Compressed:
	move.b	(a0)+,d0	; Get next byte of BODY.
	ext.w	d0		; Turn it into a WORD.
	bpl.s	.Literally	; Case [0...127] => Literally
.Replicate:
	move.b	(a0)+,d1	; Get byte to replicate.
	neg.w	d0		; Get value for dbra loop.
.RepLoop:
	tst.l	d3
	beq.s	.NoRepWrite	; If desination was NULL, don't write data.
	move.b	d1,(a2)+	; Write value into Destination.
.NoRepWrite:
	addq.w	#1,d2		; Add a byte to total written out.
	dbra	d0,.RepLoop	; Loop for correct number of times.
.AreWeDone:
	cmp.w	bm_BytesPerRow(a1),d2	; Have we written a row?
	blt.s	.Compressed		; No, read more compressed bytes.
	movem.l	(sp)+,d0-7/a1/a3-6	; Recall old register values.
	rts
.Literally:
	move.b	(a0)+,d1	; Get next value from BODY.
	tst.l	d3
	beq.s	.NoLitWrite	; If desination was NULL, don't write data.
	move.b	d1,(a2)+	; Write value into Destination.
.NoLitWrite:
	addq.w	#1,d2		; Add a byte to total written out.
	dbra	d0,.Literally	; Loop for correct number of times.
	bra.s	.AreWeDone	; See if we're finished.

Cleanup:

;   This cleans up the main routine after a failure, it frees any structures
; allocated by us, frees any bit planes, and any chunks still in memory.

	bsr	FreePlanes
	move.l	lsf_ViewPort(a5),a2
	move.l	lsf_Flags(a5),d7	; Get Alloc'd flags.
	btst	#FLGB_BITMAP,d7		; Is the BitMap ours?
	beq.s	.BMapNot		; No, then don't touch it.
	move.l	vp_RasInfo(a2),a1
	move.l	ri_BitMap(a1),a1	; Get BitMap pointer.
	moveq	#bm_SIZEOF,d0
	CALLEXEC	FreeMem		; Free the structure.
.BMapNot:
	btst	#FLGB_RINFO,d7		; Is the RasInfo ours?
	beq.s	.RInfoNot		; No, then don't touch it.
	move.l	vp_RasInfo(a2),a1	; Get RasInfo pointer.
	moveq	#ri_SIZEOF,d0
	CALLEXEC	FreeMem		; Free the structure.
.RInfoNot:
	btst	#FLGB_COLMAP,d7		; Is the Color Map ours?
	beq.s	.CMapNot		; No, then don't touch it.
	move.l	vp_ColorMap(a2),a0	; Get Color Map pointer.
	CALLGRAF	FreeColorMap	; Free the Color Map.
.CMapNot:
	btst	#FLGB_VPORT,d7		; Is the ViewPort ours?
	beq.s	.VPortNot		; No, then don't touch it.
	move.l	a2,a1			; Get ViewPort pointer.
	moveq	#vp_SIZEOF,d0
	CALLEXEC	FreeMem		; Free the structure.
.VPortNot:
	bsr.s	FreeOldCk		; Free chunk memory.
	rts

AllocPlanes:

;   This allocates all the planes for the BitMap.

	move.l	#IFF_NO_MEMORY,lsf_Return(a5)   ; Set up failure code.
	move.l	lsf_ViewPort(a5),a2
	move.l	vp_RasInfo(a2),a2
	move.l	ri_BitMap(a2),a2	; Pointer to BitMap.
	move.b	bm_Depth(a2),d2
	ext.w	d2			; Number of planes to allocate.
	subq.w	#1,d2
	moveq	#0,d3			; Current plane indexer.
.Loop:
	move.w	bm_BytesPerRow(a2),d0
	lsl.w	#3,d0			; Width of plane.
	move.w	bm_Rows(a2),d1		; Height of plane.
	CALLGRAF	AllocRaster	; Allocate the plane.
	move.l	d0,bm_Planes(a2,d3)	; Store pointer.
	beq.s	.Failure		; Exit if plane alloc failed.
	addq.w	#4,d3
	dbra	d2,.Loop		; Loop if we're not done.
	moveq	#0,d0		; Set success return.
	bra.s	.Exit		; and exit.
.Failure:
	bsr.s	FreePlanes	; Free any successful planes.
	moveq	#-1,d0		; Then exit failure.
.Exit:
	rts

FreeOldCk:

;   This routine frees the chunk if one is present.

	tst.l	lsf_Chunk(a5)	; Is there a chunk?
	beq.s	.Exit		; No, then exit.
	move.l	lsf_Chunk(a5),a1
	clr.l	lsf_Chunk(a5)	; NULL pointer.
	move.l	lsf_Size(a5),d0
	CALLEXEC	FreeMem		; Free then chunk.
.Exit:
	rts			; Return!!

FreePlanes:

;   This routine attempts to free all planes without a NULL pointer.

	tst.l	lsf_ViewPort(a5)
	beq.s	.Exit			; Exit if we havn't got a ViewPort.
	move.l	lsf_ViewPort(a5),a2
	tst.l	vp_RasInfo(a2)
	beq.s	.Exit			; Exit if we havn't got a RasInfo.
	move.l	vp_RasInfo(a2),a2
	tst.l	ri_BitMap(a2)
	beq.s	.Exit			; Exit if we havn't got a BitMap.
	move.l	ri_BitMap(a2),a2
	move.b	bm_Depth(a2),d2
	ext.w	d2			; Max number of planes to free.
	subq	#1,d2
	bmi.s	.Exit			; Exit if BitMap not setup.
	moveq	#0,d3			; Current plane indexer.
.Loop:
	move.w	bm_BytesPerRow(a2),d0
	lsl.w	#3,d0			; Width of plane.
	move.w	bm_Rows(a2),d1		; Height of plane.
	tst.l	bm_Planes(a2,d3)	; Store pointer.
	beq.s	.Skip			; Skip if we hit a NULL plane.
	move.l	bm_Planes(a2,d3),a0	; Get pointer.
	clr.l	bm_Planes(a2,d3)	; NULL out pointer.
	CALLGRAF	FreeRaster	; Free the plane.
.Skip:
	addq.w	#4,d3
	dbra	d2,.Loop		; Loop until done...
.Exit:
	rts			; Return!!

	end
