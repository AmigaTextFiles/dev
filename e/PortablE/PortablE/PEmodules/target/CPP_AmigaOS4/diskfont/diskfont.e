/* $Id: diskfont.h,v 1.17 2005/11/10 15:31:54 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/graphics/text', 'target/diskfont/glyph', 'target/interfaces/bullet'
MODULE 'target/exec/libraries', 'target/utility/tagitem', 'target/exec/types'
{#include <diskfont/diskfont.h>}
NATIVE {DISKFONT_DISKFONT_H} CONST

NATIVE {MAXFONTPATH} CONST MAXFONTPATH = 256 /* including null terminator */

NATIVE {FontContents} OBJECT fc
    {fc_FileName}	filename[MAXFONTPATH]	:ARRAY OF CHAR /*TEXT*/
    {fc_YSize}	ysize	:UINT
    {fc_Style}	style	:UBYTE
    {fc_Flags}	flags	:UBYTE
ENDOBJECT

NATIVE {TFontContents} OBJECT tfc
    {tfc_FileName}	filename[MAXFONTPATH-2]	:ARRAY OF CHAR /*TEXT*/
    {tfc_TagCount}	tagcount	:UINT                /* including the TAG_DONE tag */
    /*
     * if tfc_TagCount is non-zero, tfc_FileName is overlayed with
     * Text Tags starting at:  (struct TagItem *)
     * &tfc_FileName[MAXFONTPATH - (tfc_TagCount * sizeof(struct TagItem))]
     */
    {tfc_YSize}	ysize	:UINT
    {tfc_Style}	style	:UBYTE
    {tfc_Flags}	flags	:UBYTE
ENDOBJECT


NATIVE {FCH_ID}  CONST FCH_ID  = $0f00 /* FontContentsHeader, then FontContents */
NATIVE {TFCH_ID} CONST TFCH_ID = $0f02 /* FontContentsHeader, then TFontContents */
NATIVE {OFCH_ID} CONST OFCH_ID = $0f03 /* FontContentsHeader, then TFontContents,
                          associated with outline font */

NATIVE {FontContentsHeader} OBJECT fch
    {fch_FileID}	fileid	:UINT     /* FCH_ID */
    {fch_NumEntries}	numentries	:UINT /* the number of FontContents elements */

    /* struct FontContents fch_FC[], or struct TFontContents fch_TFC[]; */
ENDOBJECT


NATIVE {DFH_ID}      CONST DFH_ID      = $0f80
NATIVE {MAXFONTNAME} CONST MAXFONTNAME = 32     /* font name including ".font\0" */

NATIVE {DiskFontHeader} OBJECT diskfontheader
    /* the following 8 bytes are not actually considered a part of the */
    /* DiskFontHeader, but immediately preceed it. The NextSegment is  */
    /* supplied by the linker/loader, and the ReturnCode is the code   */
    /* at the beginning of the font in case someone runs it...         */
    /* Warning: you can find those bytes on disk but not in memory.    */
    /*   ULONG dfh_NextSegment; \* actually a BPTR                     */
    /*   ULONG dfh_ReturnCode;  \* MOVEQ #0,D0 : RTS                   */
    /* here then is the official start of the DiskFontHeader...        */
    {dfh_DF}	df	:ln                /* node to link disk fonts */
    {dfh_FileID}	fileid	:UINT            /* DFH_ID */
    {dfh_Revision}	revision	:UINT          /* the font revision */
    {dfh_Segment}	segment	:VALUE           /* the segment address
                                             * when loaded */
    {dfh_Name}	name[MAXFONTNAME]	:ARRAY OF CHAR /*TEXT*/ /* stripped font name (null
                                             * terminated) */
    {dfh_TF}	tf	:textfont                /* loaded TextFont structure,
                                      * dfh_TF.tf_Message.mn_Node.ln_Name
                                      * points to the full font name */
ENDOBJECT

/* unfortunately, this needs to be explicitly typed      */
/* used only if dfh_TF.tf_Style FSB_TAGGED bit is set    */
/* moved to dfh_TF.tf_Extension->tfe_Tags during loading */
NATIVE {dfh_TagList}  CONST

NATIVE {AFB_MEMORY}   CONST AFB_MEMORY   = 0      /* dont filter out memory fonts */
NATIVE {AFF_MEMORY}   CONST AFF_MEMORY   = $0001
NATIVE {AFB_DISK}     CONST AFB_DISK     = 1      /* dont filter out disk fonts */
NATIVE {AFF_DISK}     CONST AFF_DISK     = $0002
NATIVE {AFB_SCALED}   CONST AFB_SCALED   = 2      /* dont filter out scaled fonts */
NATIVE {AFF_SCALED}   CONST AFF_SCALED   = $0004
NATIVE {AFB_BITMAP}   CONST AFB_BITMAP   = 3      /* filter out .otag files */
NATIVE {AFF_BITMAP}   CONST AFF_BITMAP   = $0008
NATIVE {AFB_OTAG}     CONST AFB_OTAG     = 4      /* show .otag files only, */
NATIVE {AFF_OTAG}     CONST AFF_OTAG     = $0010 /* implemented since V50 */
NATIVE {AFB_CHARSET}  CONST AFB_CHARSET  = 5      /* show fonts in all charsets, */
NATIVE {AFF_CHARSET}  CONST AFF_CHARSET  = $0020 /* implemented since V50 */
NATIVE {AFB_TYPE}     CONST AFB_TYPE     = 6      /* return diskfont type in [t]af_Type: */
                            /* AFF_DISK|AFF_BITMAP for bitmap fonts, */
                            /* AFF_DISK|AFF_OTAG for .otag fonts, */
                            /* AFF_DISK|AFF_OTAG|AFF_SCALED for */
                            /* scalable .otag fonts. */
NATIVE {AFF_TYPE}     CONST AFF_TYPE     = $0040 /* implemented since V50 */

NATIVE {AFB_TAGGED}   CONST AFB_TAGGED   = 16     /* return TAvailFonts with taglist */
NATIVE {AFF_TAGGED}   CONST AFF_TAGGED   = $10000

NATIVE {AvailFonts} OBJECT af
    {af_Type}	type	:UINT /* MEMORY, DISK, or SCALED */
    {af_Attr}	attr	:textattr /* text attributes for font */
ENDOBJECT

NATIVE {TAvailFonts} OBJECT taf
    {taf_Type}	type	:UINT /* MEMORY, DISK, or SCALED */
    {taf_Attr}	attr	:ttextattr /* text attributes for font */
ENDOBJECT

NATIVE {AvailFontsHeader} OBJECT afh
    {afh_NumEntries}	numentries	:UINT /* number of AvailFonts elements */
    /* struct AvailFonts afh_AF[], or struct TAvailFonts afh_TAF[]; */
ENDOBJECT

/* structure used by EOpenEngine() ESetInfo() etc (V50) */
NATIVE {EGlyphEngine} OBJECT eglyphengine
    {ege_IBullet}	ibullet	:PTR TO bulletiface    /* NULL for 68K font engines */
    {ege_BulletBase}	bulletbase	:PTR TO lib
    {ege_GlyphEngine}	glyphengine	:PTR TO glyphengine
ENDOBJECT

/* flags for OpenOutlineFont() (V50) */
NATIVE {OFB_OPEN} CONST OFB_OPEN = 0
NATIVE {OFF_OPEN} CONST OFF_OPEN = $00000001

/* structure returned by OpenOutlineFont() (V50) */
NATIVE {OutlineFont} OBJECT outlinefont
    {olf_OTagPath}	otagpath	:ARRAY OF CHAR /*STRPTR*/    /* full path & name of the .otag file */
    {olf_OTagList}	otaglist	:ARRAY OF tagitem    /* relocated .otag file in memory     */
    {olf_EngineName}	enginename	:ARRAY OF CHAR /*STRPTR*/  /* OT_Engine name                     */
    {olf_LibraryName}	libraryname	:ARRAY OF CHAR /*STRPTR*/ /* OT_Engine name + ".library"        */
    {olf_EEngine}	eengine	:eglyphengine     /* All NULL if OFF_OPEN not specified */
    {olf_Reserved}	reserved	:APTR    /* for future expansion               */
    {olf_UserData}	userdata	:APTR    /* for private use                    */
ENDOBJECT
