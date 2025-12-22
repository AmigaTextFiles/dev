	IFND	IFF_I
IFF_I	set	1

;   This file should be included when assembling the _LoadILBM.s and
; _SaveILBM.s files.  It contains details of the various staructures that
; are referenced by the routines contained in the above files.
;
;   Updated this file for LoadILBM V1.03.  IFF routines now return a failure
; code which gives more info on what happened.
;
;	(C)1993 P.D.Turner	2/1/93

	include	exec/types.i


;   The load routine creates a stack frame for all it's sub-routines to use, 
; this is referenced via a5, and has a structure as follows,

lsf_ViewPort	equ	-4	; Pointer to ViewPort to setup.
lsf_FileName	equ	-8	; Pointer to file to load.
lsf_FileHandle	equ	-12	; DOS file handle for input file.
lsf_Chunk	equ	-16	; Pointer to current chunk.
lsf_Flags	equ	-20	; Various flags. (See below)
lsf_Type	equ	-24	; File type being processed. ("ILBM")
lsf_Size	equ	-28	; Size of current chunk.
lsf_ID		equ	-32	; ID of current chunk.
lsf_Return	equ	-36	; Value to return to user.
lsf_SIZEOF	equ	-36

;   The flags field above contains various bits that control the function.
; These bits are described below.

FLGB_COMPRESSED		equ	0	; Set if BODY is compressed.
FLGB_MASKING		equ	1	; Set if BODY contains a mask plane.
FLGB_VPORT		equ	2	; Set if we allocated the ViewPort.
FLGB_RINFO		equ	3	; Set if we allocated the RasInfo.
FLGB_BITMAP		equ	4	; Set if we allocated the BitMap.
FLGB_COLMAP		equ	5	; Set if we allocated the ColorMap.

FLGF_COMPRESSED		equ	(1<<0)
FLGF_MASKING		equ	(1<<1)
FLGF_VPORT		equ	(1<<2)
FLGF_RINFO		equ	(1<<3)
FLGF_BITMAP		equ	(1<<4)
FLGF_COLMAP		equ	(1<<5)


;   The save routine creates a stack frame for all it's sub-routines to use, 
; this is referenced via a5, and has a structure as follows,

ssf_ViewPort	equ	-4	; Pointer to Viewport supplied by user.
ssf_FileName	equ	-8	; Pointer to Filespec supplied by user.
ssf_FileHandle	equ	-12	; Pointer to FileHandle returned by Open();
ssf_H_ILBM	equ	-16	; IFF File Header. (3 LONGs)...
ssf_H_Size	equ	-20
ssf_H_FORM	equ	-24
ssf_Return	equ	-28
ssf_SIZEOF	equ	-28	; Size of Global data area.


;   This routine allocates a stack frame, which is used via a4, with the
; followinf fields...

;   The create BODY routine creates another stack frame, this is referenced
; via a4, and has a structure as follows,

cbsf_Buffer	equ	-4	; Destination memory for next compressed row.
cbsf_Size	equ	-8	; Size of compress buffer above.
cbsf_Return	equ	-12	; Value to return to main routine.
cbsf_H_Size	equ	-16	; BODY size member.
cbsf_H_ID	equ	-20	; BODY header, ie. "BODY"!
cbsf_SIZEOF	equ	-20	; Size of Body Stack Frame.


*------------- IFF Return Codes -------------*

; Note: when LoadILBM returns >0 = Success, pointer to a viewport.

IFF_SUCCESS	equ	0	; Okay return from SaveILBM.
IFF_FAILURE	equ	-1	; General failure, or DOS error.
IFF_NO_MEMORY	equ	-2	; Failed to allocate some required memory.
IFF_NO_FILE	equ	-3	; Failed to open file for I/O.
IFF_NOT_IFF	equ	-4	; File is not an IFF-85 file.
IFF_NOT_ILBM	equ	-5	; File is not ILBM FORM.
IFF_BAD_FORM	equ	-6	; File is missing a required chunk.

*------------- Chunk Header Structure -------------*

	STRUCTURE	CHUNK_HEADER,0
	    ULONG	ck_ID
	    ULONG	ck_Size
	    LABEL	ck_SIZEOF

*------------- Chunk ID's Etc. -------------*

MakeID	MACRO					; Macro to make ID's...
\1	equ	((\2<<24)!(\3<<16)!(\4<<8)!(\5))
	ENDM

	MakeID	ID_FORM,("F","O","R","M")
	MakeID	ID_ILBM,("I","L","B","M")
	MakeID	ID_BMHD,("B","M","H","D")
	MakeID	ID_CAMG,("C","A","M","G")
	MakeID	ID_CMAP,("C","M","A","P")
	MakeID	ID_BODY,("B","O","D","Y")

*------------- Bit Map Header Structure -------------*

	STRUCTURE	BMHD,0
	     WORD	bmhd_w
	     WORD	bmhd_h
	     WORD	bmhd_x
	     WORD	bmhd_y
	    UBYTE	bmhd_nPlanes
	    UBYTE	bmhd_masking
	    UBYTE	bmhd_compression
	    UBYTE	bmhd_pad1
	    UWORD	bmhd_transparentColor
	    UBYTE	bmhd_xAspect
	    UBYTE	bmhd_yAspect
	     WORD	bmhd_pageWidth
	     WORD	bmhd_pageHeight
	    LABEL	bmhd_SIZEOF

*------------- Masking Types Available --------------*

mskNone			equ	0
mskHasMask		equ	1
mskHasTransparentColor	equ	2
mskLasso		equ	3

*------------- Compression Types Available --------------*

cmpNone		equ	0
cmpByteRun1	equ	1

*------------- Commodore-Amiga Modes Structure ---------------*

	STRUCTURE	CAMG,0
	     LONG	camg_ViewModes
	    LABEL	camg_SIZEOF

*------------- Commodore-Amiga Modes Data ---------------*

SPRITES		equ	$4000
HIDE		equ	$2000
GLK_AUDIO	equ	$100
GLK_VIDEO	equ	2

BADFLAGS	equ	(SPRITES!HIDE!GLK_AUDIO!GLK_VIDEO)
FLAGMASK	equ	(~BADFLAGS)
CAMGMASK	equ	(FLAGMASK&$0000FFFF)

*------------- CMAP Colour Register -------------*

	STRUCTURE	ColReg,0
	    UBYTE	creg_Red
	    UBYTE	creg_Green
	    UBYTE	creg_Blue
	    LABEL	creg_SIZEOF

*------------- Current Sizes Of Static Chunks -------------*

BMHD_SZ		equ	(bmhd_SIZEOF+ck_SIZEOF)
CAMG_SZ		equ	(camg_SIZEOF+ck_SIZEOF)

	ENDC		; IFF_I
