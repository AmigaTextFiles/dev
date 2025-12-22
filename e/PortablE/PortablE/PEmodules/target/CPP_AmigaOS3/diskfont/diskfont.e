/* $VER: diskfont.h 38.0 (18.6.1992) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/graphics/text'
MODULE 'target/exec/types'
{#include <diskfont/diskfont.h>}
NATIVE {DISKFONT_DISKFONT_H} CONST

NATIVE {MAXFONTPATH} CONST MAXFONTPATH = 256   /* including null terminator */

NATIVE {FontContents} OBJECT fc
    {fc_FileName}	filename[MAXFONTPATH]	:ARRAY OF CHAR
    {fc_YSize}	ysize	:UINT
    {fc_Style}	style	:UBYTE
    {fc_Flags}	flags	:UBYTE
ENDOBJECT

NATIVE {TFontContents} OBJECT tfc
    {tfc_FileName}	filename[MAXFONTPATH-2]	:ARRAY OF CHAR
    {tfc_TagCount}	tagcount	:UINT	/* including the TAG_DONE tag */
    /*
     *	if tfc_TagCount is non-zero, tfc_FileName is overlayed with
     *	Text Tags starting at:	(struct TagItem *)
     *	    &tfc_FileName[MAXFONTPATH-(tfc_TagCount*sizeof(struct TagItem))]
     */
    {tfc_YSize}	ysize	:UINT
    {tfc_Style}	style	:UBYTE
    {tfc_Flags}	flags	:UBYTE
ENDOBJECT


NATIVE {FCH_ID}		CONST FCH_ID		= $0f00	/* FontContentsHeader, then FontContents */
NATIVE {TFCH_ID}	CONST TFCH_ID	= $0f02	/* FontContentsHeader, then TFontContents */
NATIVE {OFCH_ID}	CONST OFCH_ID	= $0f03	/* FontContentsHeader, then TFontContents,
				 * associated with outline font */

NATIVE {FontContentsHeader} OBJECT fch
    {fch_FileID}	fileid	:UINT		/* FCH_ID */
    {fch_NumEntries}	numentries	:UINT	/* the number of FontContents elements */
    /* struct FontContents fch_FC[], or struct TFontContents fch_TFC[]; */
ENDOBJECT


NATIVE {DFH_ID}		CONST DFH_ID		= $0f80
NATIVE {MAXFONTNAME}	CONST MAXFONTNAME	= 32	/* font name including ".font\0" */

NATIVE {DiskFontHeader} OBJECT diskfontheader
    /* the following 8 bytes are not actually considered a part of the	*/
    /* DiskFontHeader, but immediately preceed it. The NextSegment is	*/
    /* supplied by the linker/loader, and the ReturnCode is the code	*/
    /* at the beginning of the font in case someone runs it...		*/
    /*	 ULONG dfh_NextSegment;			\* actually a BPTR	*/
    /*	 ULONG dfh_ReturnCode;			\* MOVEQ #0,D0 : RTS	*/
    /* here then is the official start of the DiskFontHeader...		*/
    {dfh_DF}	df	:ln		/* node to link disk fonts */
    {dfh_FileID}	fileid	:UINT		/* DFH_ID */
    {dfh_Revision}	revision	:UINT	/* the font revision */
    {dfh_Segment}	segment	:VALUE	/* the segment address when loaded */
    {dfh_Name}	name[MAXFONTNAME]	:ARRAY OF CHAR /* the font name (null terminated) */
    {dfh_TF}	tf	:textfont	/* loaded TextFont structure */
ENDOBJECT

/* unfortunately, this needs to be explicitly typed */
/* used only if dfh_TF.tf_Style FSB_TAGGED bit is set */
NATIVE {dfh_TagList}	CONST


NATIVE {AFB_MEMORY}	CONST AFB_MEMORY	= 0
NATIVE {AFF_MEMORY}	CONST AFF_MEMORY	= $0001
NATIVE {AFB_DISK}	CONST AFB_DISK	= 1
NATIVE {AFF_DISK}	CONST AFF_DISK	= $0002
NATIVE {AFB_SCALED}	CONST AFB_SCALED	= 2
NATIVE {AFF_SCALED}	CONST AFF_SCALED	= $0004
NATIVE {AFB_BITMAP}	CONST AFB_BITMAP	= 3
NATIVE {AFF_BITMAP}	CONST AFF_BITMAP	= $0008

NATIVE {AFB_TAGGED}	CONST AFB_TAGGED	= 16	/* return TAvailFonts */
NATIVE {AFF_TAGGED}	CONST AFF_TAGGED	= $10000

NATIVE {AvailFonts} OBJECT af
    {af_Type}	type	:UINT		/* MEMORY, DISK, or SCALED */
    {af_Attr}	attr	:textattr	/* text attributes for font */
ENDOBJECT

NATIVE {TAvailFonts} OBJECT taf
    {taf_Type}	type	:UINT		/* MEMORY, DISK, or SCALED */
    {taf_Attr}	attr	:ttextattr	/* text attributes for font */
ENDOBJECT

NATIVE {AvailFontsHeader} OBJECT afh
    {afh_NumEntries}	numentries	:UINT	 /* number of AvailFonts elements */
    /* struct AvailFonts afh_AF[], or struct TAvailFonts afh_TAF[]; */
ENDOBJECT
