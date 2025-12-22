/* $VER: text.h 39.0 (21.8.1991) */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/ports', 'target/graphics/gfx', 'target/utility/tagitem'
MODULE 'target/exec/types'
{#include <graphics/text.h>}
NATIVE {GRAPHICS_TEXT_H} CONST

/*------ Font Styles ------------------------------------------------*/
NATIVE {FS_NORMAL}	CONST FS_NORMAL	= 0	/* normal text (no style bits set) */
NATIVE {FSB_UNDERLINED}	CONST FSB_UNDERLINED	= 0	/* underlined (under baseline) */
NATIVE {FSF_UNDERLINED}	CONST FSF_UNDERLINED	= $01
NATIVE {FSB_BOLD}	CONST FSB_BOLD	= 1	/* bold face text (ORed w/ shifted) */
NATIVE {FSF_BOLD}	CONST FSF_BOLD	= $02
NATIVE {FSB_ITALIC}	CONST FSB_ITALIC	= 2	/* italic (slanted 1:2 right) */
NATIVE {FSF_ITALIC}	CONST FSF_ITALIC	= $04
NATIVE {FSB_EXTENDED}	CONST FSB_EXTENDED	= 3	/* extended face (wider than normal) */
NATIVE {FSF_EXTENDED}	CONST FSF_EXTENDED	= $08

NATIVE {FSB_COLORFONT}	CONST FSB_COLORFONT	= 6	/* this uses ColorTextFont structure */
NATIVE {FSF_COLORFONT}	CONST FSF_COLORFONT	= $40
NATIVE {FSB_TAGGED}	CONST FSB_TAGGED	= 7	/* the TextAttr is really an TTextAttr, */
NATIVE {FSF_TAGGED}	CONST FSF_TAGGED	= $80

/*------ Font Flags -------------------------------------------------*/
NATIVE {FPB_ROMFONT}	CONST FPB_ROMFONT	= 0	/* font is in rom */
NATIVE {FPF_ROMFONT}	CONST FPF_ROMFONT	= $01
NATIVE {FPB_DISKFONT}	CONST FPB_DISKFONT	= 1	/* font is from diskfont.library */
NATIVE {FPF_DISKFONT}	CONST FPF_DISKFONT	= $02
NATIVE {FPB_REVPATH}	CONST FPB_REVPATH	= 2	/* designed path is reversed (e.g. left) */
NATIVE {FPF_REVPATH}	CONST FPF_REVPATH	= $04
NATIVE {FPB_TALLDOT}	CONST FPB_TALLDOT	= 3	/* designed for hires non-interlaced */
NATIVE {FPF_TALLDOT}	CONST FPF_TALLDOT	= $08
NATIVE {FPB_WIDEDOT}	CONST FPB_WIDEDOT	= 4	/* designed for lores interlaced */
NATIVE {FPF_WIDEDOT}	CONST FPF_WIDEDOT	= $10
NATIVE {FPB_PROPORTIONAL} CONST FPB_PROPORTIONAL = 5	/* character sizes can vary from nominal */
NATIVE {FPF_PROPORTIONAL} CONST FPF_PROPORTIONAL = $20
NATIVE {FPB_DESIGNED}	CONST FPB_DESIGNED	= 6	/* size explicitly designed, not constructed */
				/* note: if you do not set this bit in your */
				/* textattr, then a font may be constructed */
				/* for you by scaling an existing rom or disk */
				/* font (under V36 and above). */
NATIVE {FPF_DESIGNED}	CONST FPF_DESIGNED	= $40
    /* bit 7 is always clear for fonts on the graphics font list */
NATIVE {FPB_REMOVED}	CONST FPB_REMOVED	= 7	/* the font has been removed */
NATIVE {FPF_REMOVED}	CONST FPF_REMOVED	= $80

/****** TextAttr node, matches text attributes in RastPort **********/
NATIVE {TextAttr} OBJECT textattr
    {ta_Name}	name	:ARRAY OF CHAR /*STRPTR*/		/* name of the font */
    {ta_YSize}	ysize	:UINT		/* height of the font */
    {ta_Style}	style	:UBYTE		/* intrinsic font style */
    {ta_Flags}	flags	:UBYTE		/* font preferences and flags */
ENDOBJECT

NATIVE {TTextAttr} OBJECT ttextattr
    {tta_Name}	name	:ARRAY OF CHAR /*STRPTR*/		/* name of the font */
    {tta_YSize}	ysize	:UINT		/* height of the font */
    {tta_Style}	style	:UBYTE		/* intrinsic font style */
    {tta_Flags}	flags	:UBYTE		/* font preferences and flags */
    {tta_Tags}	tags	:ARRAY OF tagitem	/* extended attributes */
ENDOBJECT


/****** Text Tags ***************************************************/
NATIVE {TA_DeviceDPI}	CONST TA_DEVICEDPI	= (1 OR TAG_USER)	/* Tag value is Point union: */
					/* Hi word XDPI, Lo word YDPI */

NATIVE {MAXFONTMATCHWEIGHT}	CONST MAXFONTMATCHWEIGHT	= 32767	/* perfect match from WeighTAMatch */


/****** TextFonts node **********************************************/
->"OBJECT textfont" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/* unfortunately, this needs to be explicitly typed */
NATIVE {tf_Extension}	CONST

/*-----	tfe_Flags0 (partial definition) ----------------------------*/
NATIVE {TE0B_NOREMFONT}	CONST TE0B_NOREMFONT	= 0	/* disallow RemFont for this font */
NATIVE {TE0F_NOREMFONT}	CONST TE0F_NOREMFONT	= $01

NATIVE {TextFontExtension} OBJECT textfontextension	/* this structure is read-only */
    {tfe_MatchWord}	matchword	:UINT		/* a magic cookie for the extension */
    {tfe_Flags0}	flags0	:UBYTE			/* (system private flags) */
    {tfe_Flags1}	flags1	:UBYTE			/* (system private flags) */
    {tfe_BackPtr}	backptr	:PTR TO textfont	/* validation of compilation */
    {tfe_OrigReplyPort}	origreplyport	:PTR TO mp	/* original value in tf_Extension */
    {tfe_Tags}	tags	:ARRAY OF tagitem		/* Text Tags for the font */
    {tfe_OFontPatchS}	ofontpatchs	:PTR TO UINT		/* (system private use) */
    {tfe_OFontPatchK}	ofontpatchk	:PTR TO UINT		/* (system private use) */
    /* this space is reserved for future expansion */
ENDOBJECT

/******	ColorTextFont node ******************************************/
/*-----	ctf_Flags --------------------------------------------------*/
NATIVE {CT_COLORMASK}	CONST CT_COLORMASK	= $000F	/* mask to get to following color styles */
NATIVE {CT_COLORFONT}	CONST CT_COLORFONT	= $0001	/* color map contains designer's colors */
NATIVE {CT_GREYFONT}	CONST CT_GREYFONT	= $0002	/* color map describes even-stepped */
				/* brightnesses from low to high */
NATIVE {CT_ANTIALIAS}	CONST CT_ANTIALIAS	= $0004	/* zero background thru fully saturated char */

NATIVE {CTB_MAPCOLOR}	CONST CTB_MAPCOLOR	= 0	/* map ctf_FgColor to the rp_FgPen if it's */
NATIVE {CTF_MAPCOLOR}	CONST CTF_MAPCOLOR	= $0001	/* is a valid color within ctf_Low..ctf_High */

/*----- ColorFontColors --------------------------------------------*/
NATIVE {ColorFontColors} OBJECT colorfontcolors
    {cfc_Reserved}	reserved	:UINT	/* *must* be zero */
    {cfc_Count}	count	:UINT		/* number of entries in cfc_ColorTable */
    {cfc_ColorTable}	colortable	:PTR TO UINT	/* 4 bit per component color map packed xRGB */
ENDOBJECT

/*-----	ColorTextFont ----------------------------------------------*/
NATIVE {ColorTextFont} OBJECT colortextfont
    {ctf_TF}	textfont	:textfont
    {ctf_Flags}	flags	:UINT		/* extended flags */
    {ctf_Depth}	depth	:UBYTE		/* number of bit planes */
    {ctf_FgColor}	fgcolor	:UBYTE	/* color that is remapped to FgPen */
    {ctf_Low}	low	:UBYTE		/* lowest color represented here */
    {ctf_High}	high	:UBYTE		/* highest color represented here */
    {ctf_PlanePick}	planepick	:UBYTE	/* PlanePick ala Images */
    {ctf_PlaneOnOff}	planeonoff	:UBYTE	/* PlaneOnOff ala Images */
    {ctf_ColorFontColors}	colorfontcolors	:PTR TO colorfontcolors /* colors for font */
    {ctf_CharData}	chardata[8]	:ARRAY OF APTR	/*pointers to bit planes ala tf_CharData */
ENDOBJECT

/****** TextExtent node *********************************************/
NATIVE {TextExtent} OBJECT textextent
    {te_Width}	width	:UINT		/* same as TextLength */
    {te_Height}	height	:UINT		/* same as tf_YSize */
    {te_Extent}	extent	:rectangle	/* relative to CP */
ENDOBJECT
