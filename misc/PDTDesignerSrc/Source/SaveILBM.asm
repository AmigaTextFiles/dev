	opt	c+,d+,l+,o+,i+

******************* (C)1993 P.D.Turner.   Version 1.01 ******************
*									*
*	NAME								*
*		SaveILBM -- Save a raster described by the given	*
*				viewport as an IFF ILBM file.		*
*									*
*	SYNOPSIS							*
*		Fail = SaveILBM( Name, ViewPort );			*
*				 a0    a1				*
*									*
*	FUNCTION							*
*		Take info from the given viewport and create a file	*
*		  according to the IFF ILBM standard.  The file has	*
*		  the chunks, BMHD, CMAP, CAMG, and BODY.		*
*									*
*	INPUTS								*
*		    Name - Pointer to  string to save picture under.	*
*		ViewPort - Pointer to ViewPort to save as an ILBM.	*
*									*
*	RESULTS								*
*		Fail - Set to 0 if Save was successful, else a		*
*			negative error code. (See iff.i)		*
*									*
*	BUGS								*
*		None							*
*									*
*	SEE ALSO							*
*		LoadILBM.asm, iff.i, IFF Texts in RKM's			*
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
*   This routine, unlike LoadILBM under the same version, does *not*
*     require any user structures to be present for the function to work
*     properly.  This is a bug in LoadILBM, and will be fixed in V1.01.
*
*	****** Update V1.01 ******
*
*   Extended save's stack frame to allow the routine to return more detailed
*      error codes, which will allow the client program to display more
*      refined error messages to the user.
*
*			**** P.T 1/1/93 ****

		incdir	Sys:Include/
		include	exec/exec_lib.i
		include	exec/memory.i
		include	graphics/graphics_lib.i
		include	graphics/view.i
		include	libraries/dos_lib.i
		include	libraries/dos.i

	include	MapDesignerV2.0:Source/iff.i	; Custom include file!

	include	MapDesignerV2.0:Source/apack.asm   ; CREATIVE FOCUS' Compressor.


		xdef	_SaveILBM
		xref	_DOSBase,_GfxBase

_SaveILBM:

;   This is the routine called by you.  It basically sets up the file and
; a stack frame to hold data for the program, then calls each of the four
; main sub-routines which create the IFF chunks.  If at any point the program
; detects an error then all resouces are freed, and an appropriate error
; returned to our calling routine.

	movem.l	d2-7/a2-6,-(sp)		; Save callers regs.
	link	a5,#ssf_SIZEOF		; Allocate the above stack frame.
	clr.l	ssf_H_Size(a5)		; No data written yet.
	move.l	a0,ssf_FileName(a5)	; Save user inputs...
	move.l	a1,ssf_ViewPort(a5)
	move.l	#IFF_NO_FILE,ssf_Return(a5)	; Pre load failure code.
	move.l	a0,d1
	move.l	#MODE_NEWFILE,d2
	CALLDOS		Open		; Open the output file.
	move.l	d0,ssf_FileHandle(a5)	; Save and test pointer.
	beq	.Exit		; Exit there was a problem.
	move.l	#ID_FORM,ssf_H_FORM(a5)	; Create file header...
	move.l	#ID_ILBM,ssf_H_ILBM(a5)
	move.l	#IFF_FAILURE,ssf_Return(a5)	; Pre load failure code.
	move.l	d0,d1			; Get File handle.
	moveq	#12,d3			; Length of File Header.
	move.l	a5,d2			; Get base of data.
	addi.l	#ssf_H_FORM,d2		; Calculate position of Header.
	CALLDOS		Write		; Write the header to the file.
	cmpi.l	#-1,d0			; Was the write a success?
	beq	.DirtyFail		; No, Cleanup & exit.
	bsr	CreateBMHD		; Create the BMHD chunk.
	tst.l	d0
	beq	.DirtyFail		; Exit if there was a problem.
	add.l	d0,ssf_H_Size(a5)	; Else, add last block to total size.
	bsr	CreateCMAP		; Create the CMAP chunk.
	tst.l	d0
	beq.s	.DirtyFail		; Exit if there was a problem.
	add.l	d0,ssf_H_Size(a5)	; Else, add last block to total size.
	bsr	CreateCAMG		; Create the CAMG chunk.
	tst.l	d0
	beq.s	.DirtyFail		; Exit if there was a problem.
	add.l	d0,ssf_H_Size(a5)	; Else, add last block to total size.
	bsr	CreateBODY		; Create the BODY chunk.
	tst.l	d0
	beq.s	.DirtyFail		; Exit if there was a problem.
	add.l	d0,ssf_H_Size(a5)	; Else, add last block to total size.
	addq.l	#4,ssf_H_Size(a5)	; Add "ILBM" size. (4 * char).
	move.l	ssf_FileHandle(a5),d1	; Get File Handle.
	moveq	#4,d2
	moveq	#OFFSET_BEGINNING,d3
	CALLDOS		Seek		; Seek back to file size specifier.
	move.l	ssf_FileHandle(a5),d1	; Get File Handle.
	move.l	#IFF_FAILURE,ssf_Return(a5)	; Pre load failure code.
	moveq	#4,d3
	move.l	a5,d2			; Get base of data.
	addi.l	#ssf_H_Size,d2		; Calculate position of size.
	CALLDOS		Write		; Write size into the file.
	cmpi.l	#-1,d0
	beq.s	.DirtyFail		; Cleanup & Exit if write failed.
	move.l	ssf_FileHandle(a5),d1
	CALLDOS		Close		; Close the file.
	move.l	#IFF_SUCCESS,ssf_Return(a5)	; Set return code.
.Exit:
	move.l	ssf_Return(a5),d0	; Pull return code from stack frame.
	unlk	a5			; Free the stack frame.
	movem.l	(sp)+,d2-7/a2-6		; Restore callers regs.
	rts				; And return!
.DirtyFail:
	move.l	ssf_FileHandle(a5),d1
	CALLDOS		Close		; Close the file.
	move.l	ssf_FileName(a5),d1	; Recall filespec.
	CALLDOS		DeleteFile	; Attempt to delete file.
	bra.s	.Exit

CreateBMHD:

;   This routine creates and saves a BMHD, it is filled with data taken from
; the ViewPort, and BitMap structures.  All parameters are taken from the
; global stack frame, via a5...

	link	a4,#-BMHD_SZ	; Allocate a bit of stack to create chunk.
	lea	-BMHD_SZ(a4),a3	; Get a pointer to *start* of chunk.
	move.l	#ID_BMHD,ck_ID(a3)	; Create the chunk header...
	move.l	#20,ck_Size(a3)
	move.l	ssf_ViewPort(a5),a0	; Get ViewPort.
	move.l	vp_RasInfo(a0),a1
	move.l	ri_BitMap(a1),a1	; Get BitMap.
	move.w	bm_BytesPerRow(a1),d0	; Get width in bytes.
	lsl.w	#3,d0			; Convert into pixels.
	move.w	d0,(8+bmhd_w)(a3)	; Install Width value.
	move.w	bm_Rows(a1),(8+bmhd_h)(a3)	; Install number of rows.
	move.w	#0,(8+bmhd_x)(a3)		; Set offset to top-left...
	move.w	#0,(8+bmhd_y)(a3)
	move.b	bm_Depth(a1),(8+bmhd_nPlanes)(a3)	; Set depth.
	move.b	#0,(8+bmhd_masking)(a3)		; No masking needed here!
	move.b	#0,(8+bmhd_pad1)(a3)		; Clear pad byte.
	move.b	#1,(8+bmhd_compression)(a3)	; Image is always compressed.
	move.w	#0,(8+bmhd_transparentColor)(a3)   ; Set trans. color index.
	move.w	vp_DWidth(a0),(8+bmhd_pageWidth)(a3)	; Set page size...
	move.w	vp_DHeight(a0),(8+bmhd_pageHeight)(a3)
	move.b	#11,(8+bmhd_yAspect)(a3)	; Y aspect never changes.
	moveq	#10,d0			; Now we calculate xAspect...
	move.w	vp_Modes(a0),d1		; Get display modes.
	btst	#2,d1		; Is it interlaced?
	beq.s	.NoInt		; No, then branch.
	lsl.b	#1,d0		; Else, multiply Aspect by 2.
.NoInt:
	btst	#15,d1		; Is it a Hi-Res display?
	beq.s	.NoHires	; No, then branch.
	lsr.b	#1,d0		; Else, divide Aspect by 2.
.NoHires:
	move.b	d0,(8+bmhd_xAspect)(a3)	; Install X aspect value.
	move.l	ssf_FileHandle(a5),d1	; Get file handle.
	move.l	#IFF_FAILURE,ssf_Return(a5)	; Set return code.
	moveq	#BMHD_SZ,d3
	move.l	a3,d2			; Start of memory buffer.
	CALLDOS		Write		; Write chunk out to file.
	cmpi.l	#-1,d0			; Check return
	beq.s	.BMHDFail		; Branch if there was an error.
	moveq	#BMHD_SZ,d0		; Set return code.
.Exit:
	unlk	a4			; Free chunk memory.
	rts				; Return!!
.BMHDFail:
	moveq	#0,d0		; Set failure return.
	bra.s	.Exit		; Then exit.

CreateCMAP:

;   This routine creates the CMAP chunk, it takes its base parameters from
; the Global Stack Frame.  The routine first creates the CMAP header, then
; sits in a loop writing the color registers out one at a time.  The color
; intensities are obtained through the system via calls to GetRGB4();

	link	a4,#-12		; Allocate memory for chunk header & 1 color.
	lea	-12(a4),a3	; Pointer to start of data .
	move.l	ssf_ViewPort(a5),a2	; Pointer to ViewPort.
	move.l	vp_ColorMap(a2),a2	; Extract colour map.
	move.w	cm_Count(a2),d7		; Get number of colours.
	move.w	d7,d6
	mulu.w	#creg_SIZEOF,d6		; Calculate number of bytes.
	move.l	#ID_CMAP,ck_ID(a3)	; Build chunk header...
	move.l	d6,ck_Size(a3)
	move.l	ssf_FileHandle(a5),d1	; Now write header to disk...
	move.l	#IFF_FAILURE,ssf_Return(a5)	; Set return code.
	moveq	#8,d3
	move.l	a3,d2
	CALLDOS		Write		; Attempt the write.
	cmpi.l	#-1,d0
	beq	.CMAPFail		; Branch if the write failed.
	moveq	#0,d5		; This acts as the indexer & loop control.
.CMAPLoop:
	move.l	a2,a0
	move.l	d5,d0
	CALLGRAF	GetRGB4		; Get next Colour value.
	move.w	d0,d1
	andi.w	#$0F00,d1		; Mask out around Red Value.
	lsr.w	#4,d1		; Shift value into Byte.
	move.b	d1,8(a3)	; Put value into register.
	move.b	d0,d1
	andi.b	#$F0,d1
	move.b	d1,9(a3)	; Put Green value into register.
	move.b	d0,d1
	lsl.b	#4,d1		; Justify value & clear low nibble.
	move.b	d1,10(a3)	; Put Blue value into register.
	move.l	ssf_FileHandle(a5),d1
	moveq	#3,d3
	move.l	a3,d2
	addq.l	#8,d2		; Advance pointer to register struct.
	CALLDOS		Write	; Write color register to file.
	cmpi.l	#-1,d0
	beq.s	.CMAPFail	; Branch if write failed.
	addq.w	#1,d5		; Move onto next colour.
	cmp.w	d7,d5		; Is the chunk complete?
	blt.s	.CMAPLoop	; No, then go round again.
	btst	#0,d6		; Is the chunk even?
	beq.s	.ChunkEven	; Yes, then branch.
	addq.l	#1,d6		; Else, add 1 onto chunk size.
	move.b	#0,8(a3)	; Setup an empty pad byte.
	move.l	ssf_FileHandle(a5),d1
	moveq	#1,d3
	move.l	a3,d2
	addq.l	#8,d2		; Advance pointer to register struct.
	CALLDOS		Write	; Write pad byte to file.
	cmpi.l	#-1,d0
	beq.s	.CMAPFail	; Branch if write failed.
.ChunkEven:
	addq.l	#8,d6		; Add size of ck_ Header onto bytes written.
	move.l	d6,d0		; Set return value to bytes written.
.Exit:
	unlk	a4		; Free chunk memory.
	rts			; Return!!
.CMAPFail:
	moveq	#0,d0		; Set failure return.
	bra.s	.Exit		; The exit.

CreateCAMG:

;   This routine creates the CAMG modes chunk, it is very simple...
; First we allocate the memory on the stack, then we build the header,
; next we get the modes out of the Viewport, AND this with the allowable
; modes, then install it in the chunk, finally we write the chunk to disk...

	link	a4,#-CAMG_SZ		; Allocate chunk memory.
	lea	-CAMG_SZ(a4),a3		; Get pointer to start of chunk.
	move.l	#ID_CAMG,ck_ID(a3)	; Write in chunk identifier.
	move.l	#4,ck_Size(a3)		; And chunk size.
	move.l	ssf_ViewPort(a5),a0	; Get ViewPort.
	move.w	vp_Modes(a0),d0		; Get display modes.
	andi.l	#CAMGMASK,d0		; Discard any illegal modes.
	move.l	d0,(8+camg_ViewModes)(a3)  ; Install modes into chunk.
	move.l	ssf_FileHandle(a5),d1	; Get file handle.
	move.l	#IFF_FAILURE,ssf_Return(a5)	; Set return code.
	moveq	#CAMG_SZ,d3		; Total size of chunk
	move.l	a3,d2			; Pointer to chunk
	CALLDOS		Write		; Attempt the write
	cmpi.l	#-1,d0
	beq.s	.CAMGFail		; Branch if write failed.
	moveq	#CAMG_SZ,d0		; Set return value.
.Exit:
	unlk	a4			; Free chunk memory.
	rts				; And return!!
.CAMGFail:
	moveq	#0,d0			; Set failure return code.
	bra.s	.Exit			; Now exit...

CreateBODY:

;   This is the main sub-routine here, it creates the BODY chunk which holds
; the actual raster data.  The routine is based around 2 loops, an inner
; depth loop, which causes the data to be interleaved, and an outer Rows loop
; which loops until all rows have been interleaved & written.  The routine
; calls a sub-routine EncodeRow, this Compresses the appropriate row into a
; buffer ready for writing...

	link	a4,#cbsf_SIZEOF	; Allocate the local variable memory.
	move.l	ssf_ViewPort(a5),a3
	move.l	vp_RasInfo(a3),a3
	move.l	ri_BitMap(a3),a3	; Get pointer to bitmap.
	move.w	bm_BytesPerRow(a3),d0	; Calculate size of buffer...
	ext.l	d0
	move.l	d0,d1
	addi.w	#127,d1
	lsr.w	#7,d1
	add.l	d1,d0
	move.l	#IFF_NO_MEMORY,ssf_Return(a5)	; Set return code.
	move.l	d0,cbsf_Size(a4)		; Save this for cleanup.
	moveq	#MEMF_PUBLIC,d1
	CALLEXEC	AllocMem	; Allocate the buffer.
	move.l	d0,cbsf_Buffer(a4)	; Save pointer.
	beq	.CleanFail		; Exit if no memory.
	move.l	#0,cbsf_H_Size(a4)	; Initialize some vars to 0.
	move.l	#0,cbsf_Return(a4)
	move.l	#ID_BODY,cbsf_H_ID(a4)	; Setup chunk name.
	move.l	ssf_FileHandle(a5),d1
	move.l	#IFF_FAILURE,ssf_Return(a5)	; Set return code.
	moveq	#8,d3
	move.l	a4,d2
	addi.l	#cbsf_H_ID,d2		; Get position of chunk header data.
	CALLDOS		Write		; Attempt to write the header.
	cmpi.l	#-1,d0
	beq	.DirtyFail		; Exit if write failed.
	moveq	#0,d7			; Plane offset.
	move.w	bm_Rows(a3),d4
	subq.w	#1,d4			; Setup Rows Loop controler
.RowsLoop:
	moveq	#0,d6			; Plane indexer.
	move.b	bm_Depth(a3),d5
	ext.w	d5
	subq.w	#1,d5			; Setup inner depth loop.
.PlaneLoop:
	bsr	EncodeRow		; Encode next row into buffer.
	add.l	d0,cbsf_H_Size(a4)	; Increase BODY size.
	move.l	d0,d3
	move.l	ssf_FileHandle(a5),d1
	move.l	cbsf_Buffer(a4),d2
	CALLDOS		Write		; Attempt to write next row.
	cmpi.l	#-1,d0
	beq	.DirtyFail		; Exit on failure.
	addq.l	#4,d6			; Move onto next plane.
	dbra	d5,.PlaneLoop		; Interleave current rows...
	move.w	bm_BytesPerRow(a3),d0
	ext.l	d0
	add.l	d0,d7			; Move onto next row.
	dbra	d4,.RowsLoop		; For all rows in raster...
	move.l	ssf_FileHandle(a5),d1
	moveq	#OFFSET_CURRENT,d3
	move.l	cbsf_H_Size(a4),d2		; Get chunk size.
	addq.l	#4,d2
	neg.l	d2			; We want to go backwards!
	CALLDOS		Seek		; Seek back to BODY size.
	move.l	ssf_FileHandle(a5),d1
	moveq	#4,d3
	move.l	a4,d2
	addi.l	#cbsf_H_Size,d2		; Calculate position of data.
	CALLDOS		Write		; Write it in.
	cmpi.l	#-1,d0
	beq.s	.DirtyFail		; Exit if write failed.
	move.l	cbsf_H_Size(a4),d7		; Get size.
	btst	#0,d7			; Is the chunk even?
	beq.s	.BODYEven		; Yes, then branch.
	move.l	ssf_FileHandle(a5),d1
	moveq	#OFFSET_END,d3
	moveq	#0,d2
	CALLDOS		Seek		; Seek to end of file.
	move.l	ssf_FileHandle(a5),d1
	moveq	#1,d3
	move.l	a4,d2
	addi.l	#cbsf_Return,d2		; Calculate position of NULL data.
	CALLDOS		Write		; Write in a pad byte.
	cmpi.l	#-1,d0
	beq.s	.DirtyFail		; Exit if write failed.
	addq.l	#1,cbsf_H_Size(a4)	; Add 1 to chunk size.
.BODYEven:
	addq.l	#8,cbsf_H_Size(a4)	; Add chunk header size.
	move.l	cbsf_H_Size(a4),cbsf_Return(a4)	; Set return value
.DirtyFail:
	move.l	cbsf_Buffer(a4),a1
	move.l	cbsf_Size(a4),d0
	CALLEXEC	FreeMem		; Free compression buffer.
.CleanFail:
	move.l	cbsf_Return(a4),d0	; Get return Value.
	unlk	a4			; Free stack frame.
	rts

EncodeRow:

;   This is the function that controls the transfer of bytes form the bitmap
; pointed to by a3, into the buffer allocated by the BODY routine above.
; We must always return the number of bytes to write...

	link	a2,#-8		; Allocate 2 local LONG ptrs.
	move.l	bm_Planes(a3,d6),a0	; Get plane.
	add.l	d7,a0			; Add offset.
	move.l	a0,-4(a2)		; Save Source pointer.
	move.l	cbsf_Buffer(a4),-8(a2)	; Save Dest. ptr.
	move.w	bm_BytesPerRow(a3),d0
	ext.l	d0
	move.l	a2,-(sp)	; Save stack ptr.
	move.l	d0,-(sp)	; Number of bytes to compress.
	pea	-8(a2)		; **Dest.
	pea	-4(a2)		; **Source.
	bsr	_PackRow	; Do the compression
	adda.l	#12,a7		; remove params.
	move.l	(sp)+,a2	; Reacll stack ptr.
	unlk	a2		; Free stack frame.
	rts			; Return!!

	end
