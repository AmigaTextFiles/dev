/* $VER: text.h 39.0 (21.8.1991) */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/ports', 'target/graphics/gfx', 'target/utility/tagitem'
MODULE 'target/exec/types'
{MODULE 'graphics/text'}

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

NATIVE {FPF_DESIGNED}	CONST FPF_DESIGNED	= $40
    /* bit 7 is always clear for fonts on the graphics font list */
NATIVE {FPB_REMOVED}	CONST FPB_REMOVED	= 7	/* the font has been removed */
NATIVE {FPF_REMOVED}	CONST FPF_REMOVED	= $80

/****** TextAttr node, matches text attributes in RastPort **********/
NATIVE {textattr} OBJECT textattr
    {name}	name	:ARRAY OF CHAR /*STRPTR*/		/* name of the font */
    {ysize}	ysize	:UINT		/* height of the font */
    {style}	style	:UBYTE		/* intrinsic font style */
    {flags}	flags	:UBYTE		/* font preferences and flags */
ENDOBJECT

NATIVE {ttextattr} OBJECT ttextattr
    {name}	name	:ARRAY OF CHAR /*STRPTR*/		/* name of the font */
    {ysize}	ysize	:UINT		/* height of the font */
    {style}	style	:UBYTE		/* intrinsic font style */
    {flags}	flags	:UBYTE		/* font preferences and flags */
    {tags}	tags	:ARRAY OF tagitem	/* extended attributes */
ENDOBJECT


/****** Text Tags ***************************************************/
NATIVE {TA_DEVICEDPI}	CONST TA_DEVICEDPI	= (1 OR TAG_USER)	/* Tag value is Point union: */
					/* Hi word XDPI, Lo word YDPI */

NATIVE {MAXFONTMATCHWEIGHT}	CONST MAXFONTMATCHWEIGHT	= 32767	/* perfect match from WeighTAMatch */


/****** TextFonts node **********************************************/
->"OBJECT textfont" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')

/*-----	tfe_Flags0 (partial definition) ----------------------------*/
NATIVE {TE0B_NOREMFONT}	CONST TE0B_NOREMFONT	= 0	/* disallow RemFont for this font */
NATIVE {TE0F_NOREMFONT}	CONST TE0F_NOREMFONT	= $01

NATIVE {textfontextension} OBJECT textfontextension	/* this structure is read-only */
    {matchword}	matchword	:UINT		/* a magic cookie for the extension */
    {flags0}	flags0	:UBYTE			/* (system private flags) */
    {flags1}	flags1	:UBYTE			/* (system private flags) */
    {backptr}	backptr	:PTR TO textfont	/* validation of compilation */
    {origreplyport}	origreplyport	:PTR TO mp	/* original value in tf_Extension */
    {tags}	tags	:ARRAY OF tagitem		/* Text Tags for the font */
    {ofontpatchs}	ofontpatchs	:PTR TO UINT		/* (system private use) */
    {ofontpatchk}	ofontpatchk	:PTR TO UINT		/* (system private use) */
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
NATIVE {colorfontcolors} OBJECT colorfontcolors
    {reserved}	reserved	:UINT	/* *must* be zero */
    {count}	count	:UINT		/* number of entries in cfc_ColorTable */
    {colortable}	colortable	:PTR TO UINT	/* 4 bit per component color map packed xRGB */
ENDOBJECT

/*-----	ColorTextFont ----------------------------------------------*/
NATIVE {colortextfont} OBJECT colortextfont
    {textfont}	textfont	:textfont
    {flags}	flags	:UINT		/* extended flags */
    {depth}	depth	:UBYTE		/* number of bit planes */
    {fgcolor}	fgcolor	:UBYTE	/* color that is remapped to FgPen */
    {low}	low	:UBYTE		/* lowest color represented here */
    {high}	high	:UBYTE		/* highest color represented here */
    {planepick}	planepick	:UBYTE	/* PlanePick ala Images */
    {planeonoff}	planeonoff	:UBYTE	/* PlaneOnOff ala Images */
    {colorfontcolors}	colorfontcolors	:PTR TO colorfontcolors /* colors for font */
    {chardata}	chardata[8]	:ARRAY OF APTR	/*pointers to bit planes ala tf_CharData */
ENDOBJECT

/****** TextExtent node *********************************************/
NATIVE {textextent} OBJECT textextent
    {width}	width	:UINT		/* same as TextLength */
    {height}	height	:UINT		/* same as tf_YSize */
    {extent}	extent	:rectangle	/* relative to CP */
ENDOBJECT
