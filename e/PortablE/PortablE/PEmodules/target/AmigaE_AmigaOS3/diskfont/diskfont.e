/* $VER: diskfont.h 38.0 (18.6.1992) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/graphics/text'
MODULE 'target/exec/types'
{MODULE 'diskfont/diskfont'}

NATIVE {MAXFONTPATH} CONST MAXFONTPATH = 256   /* including null terminator */

NATIVE {fc} OBJECT fc
    {filename}	filename[MAXFONTPATH]	:ARRAY OF CHAR
    {ysize}	ysize	:UINT
    {style}	style	:UBYTE
    {flags}	flags	:UBYTE
ENDOBJECT

NATIVE {tfc} OBJECT tfc
    {filename}	filename[MAXFONTPATH-2]	:ARRAY OF CHAR
    {tagcount}	tagcount	:UINT	/* including the TAG_DONE tag */
    {ysize}	ysize	:UINT
    {style}	style	:UBYTE
    {flags}	flags	:UBYTE
ENDOBJECT


NATIVE {FCH_ID}		CONST FCH_ID		= $0f00	/* FontContentsHeader, then FontContents */
NATIVE {TFCH_ID}	CONST TFCH_ID	= $0f02	/* FontContentsHeader, then TFontContents */
NATIVE {OFCH_ID}	CONST OFCH_ID	= $0f03	/* FontContentsHeader, then TFontContents,
				 * associated with outline font */

NATIVE {fch} OBJECT fch
    {fileid}	fileid	:UINT		/* FCH_ID */
    {numentries}	numentries	:UINT	/* the number of FontContents elements */
ENDOBJECT


NATIVE {DFH_ID}		CONST DFH_ID		= $0f80
NATIVE {MAXFONTNAME}	CONST MAXFONTNAME	= 32	/* font name including ".font\0" */

NATIVE {diskfontheader} OBJECT diskfontheader
    {df}	df	:ln		/* node to link disk fonts */
    {fileid}	fileid	:UINT		/* DFH_ID */
    {revision}	revision	:UINT	/* the font revision */
    {segment}	segment	:VALUE	/* the segment address when loaded */
    {name}	name[MAXFONTNAME]	:ARRAY OF CHAR /* the font name (null terminated) */
    {tf}	tf	:textfont	/* loaded TextFont structure */
ENDOBJECT


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

NATIVE {af} OBJECT af
    {type}	type	:UINT		/* MEMORY, DISK, or SCALED */
    {attr}	attr	:textattr	/* text attributes for font */
ENDOBJECT

NATIVE {taf} OBJECT taf
    {type}	type	:UINT		/* MEMORY, DISK, or SCALED */
    {attr}	attr	:ttextattr	/* text attributes for font */
ENDOBJECT

NATIVE {afh} OBJECT afh
    {numentries}	numentries	:UINT	 /* number of AvailFonts elements */
ENDOBJECT
