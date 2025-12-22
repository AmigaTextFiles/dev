/* $Id: text.h 14170 2002-04-15 22:06:37Z stegerg $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared3'
MODULE 'target/exec/ports', 'target/graphics/gfx', 'target/utility/tagitem'
MODULE 'target/exec/types'
{#include <graphics/text.h>}
NATIVE {GRAPHICS_TEXT_H} CONST

->"OBJECT textfont" is on-purposely missing from here (it can be found in 'graphics/gfx_shared3')
NATIVE {tf_Extension} CONST
NATIVE {GetTextFontReplyPort} PROC	->GetTextFontReplyPort(font) ({ struct TextFontExtension * tfe; tfe = ExtendFont (font, NULL); tfe ? tfe->tfe_OrigReplyPort : font->tf_Message.mn_ReplyPort })

NATIVE {TextFontExtension} OBJECT textfontextension
    {tfe_MatchWord}	matchword	:UINT
    {tfe_Flags0}	flags0	:UBYTE
    {tfe_Flags1}	flags1	:UBYTE

    {tfe_BackPtr}	backptr	:PTR TO textfont
    {tfe_OrigReplyPort}	origreplyport	:PTR TO mp
    {tfe_Tags}	tags	:ARRAY OF tagitem

    {tfe_OFontPatchS}	ofontpatchs	:PTR TO UINT
    {tfe_OFontPatchK}	ofontpatchk	:PTR TO UINT
ENDOBJECT

/* tfe_Flags0 */
NATIVE {TE0B_NOREMFONT}	   CONST TE0B_NOREMFONT	   = 0
NATIVE {TE0F_NOREMFONT} CONST TE0F_NOREMFONT = $1

/* Text Attributes */
NATIVE {TextAttr} OBJECT textattr
    {ta_Name}	name	:/*STRPTR*/ ARRAY OF CHAR
    {ta_YSize}	ysize	:UINT
    {ta_Style}	style	:UBYTE
    {ta_Flags}	flags	:UBYTE
ENDOBJECT

NATIVE {TTextAttr} OBJECT ttextattr
    /* like TextAttr */
    {tta_Name}	name	:/*STRPTR*/ ARRAY OF CHAR
    {tta_YSize}	ysize	:UINT
    {tta_Style}	style	:UBYTE
    {tta_Flags}	flags	:UBYTE

    /* TTextAttr specific extension */
    {tta_Tags}	tags	:ARRAY OF tagitem
ENDOBJECT

/* ta_Style/tta_Style */
NATIVE {FS_NORMAL}	   CONST FS_NORMAL	   = 0
NATIVE {FSB_UNDERLINED}	   CONST FSB_UNDERLINED	   = 0
NATIVE {FSF_UNDERLINED} CONST FSF_UNDERLINED = $1
NATIVE {FSB_BOLD}	   CONST FSB_BOLD	   = 1
NATIVE {FSF_BOLD}       CONST FSF_BOLD       = $2
NATIVE {FSB_ITALIC}	   CONST FSB_ITALIC	   = 2
NATIVE {FSF_ITALIC}     CONST FSF_ITALIC     = $4
NATIVE {FSB_EXTENDED}	   CONST FSB_EXTENDED	   = 3
NATIVE {FSF_EXTENDED}   CONST FSF_EXTENDED   = $8
NATIVE {FSB_COLORFONT}	   CONST FSB_COLORFONT	   = 6
NATIVE {FSF_COLORFONT}  CONST FSF_COLORFONT  = $40
NATIVE {FSB_TAGGED}	   CONST FSB_TAGGED	   = 7
NATIVE {FSF_TAGGED}     CONST FSF_TAGGED     = $80

/* ta_Flags/tta_Flags */
NATIVE {FPB_ROMFONT}	     CONST FPB_ROMFONT	     = 0
NATIVE {FPF_ROMFONT}	 CONST FPF_ROMFONT	 = $1
NATIVE {FPB_DISKFONT}	     CONST FPB_DISKFONT	     = 1
NATIVE {FPF_DISKFONT}	 CONST FPF_DISKFONT	 = $2
NATIVE {FPB_REVPATH}	     CONST FPB_REVPATH	     = 2
NATIVE {FPF_REVPATH}	 CONST FPF_REVPATH	 = $4
NATIVE {FPB_TALLDOT}	     CONST FPB_TALLDOT	     = 3
NATIVE {FPF_TALLDOT}	 CONST FPF_TALLDOT	 = $8
NATIVE {FPB_WIDEDOT}	     CONST FPB_WIDEDOT	     = 4
NATIVE {FPF_WIDEDOT}	 CONST FPF_WIDEDOT	 = $10
NATIVE {FPB_PROPORTIONAL}     CONST FPB_PROPORTIONAL     = 5
NATIVE {FPF_PROPORTIONAL} CONST FPF_PROPORTIONAL = $20
NATIVE {FPB_DESIGNED}	     CONST FPB_DESIGNED	     = 6
NATIVE {FPF_DESIGNED}	 CONST FPF_DESIGNED	 = $40
NATIVE {FPB_REMOVED}	     CONST FPB_REMOVED	     = 7
NATIVE {FPF_REMOVED}	 CONST FPF_REMOVED	 = $80

/* tta_Tags */
NATIVE {TA_DeviceDPI}	   CONST TA_DEVICEDPI	   = (TAG_USER + 1)

NATIVE {MAXFONTMATCHWEIGHT} CONST MAXFONTMATCHWEIGHT = 32767

NATIVE {ColorFontColors} OBJECT colorfontcolors
    {cfc_Reserved}	reserved	:UINT
    {cfc_Count}	count	:UINT
    {cfc_ColorTable}	colortable	:PTR TO UINT
ENDOBJECT

NATIVE {ColorTextFont} OBJECT colortextfont
    {ctf_TF}	textfont	:textfont

    {ctf_Flags}	flags	:UINT
    {ctf_Depth}	depth	:UBYTE
    {ctf_FgColor}	fgcolor	:UBYTE
    {ctf_Low}	low	:UBYTE
    {ctf_High}	high	:UBYTE
    {ctf_PlanePick}	planepick	:UBYTE
    {ctf_PlaneOnOff}	planeonoff	:UBYTE

    {ctf_ColorFontColors}	colorfontcolors	:PTR TO colorfontcolors

    {ctf_CharData}	chardata[8]	:ARRAY OF APTR
ENDOBJECT

/* ctf_Flags */
NATIVE {CTB_MAPCOLOR}	 CONST CTB_MAPCOLOR	 = 0
NATIVE {CTF_MAPCOLOR} CONST CTF_MAPCOLOR = $1
NATIVE {CT_COLORFONT} CONST CT_COLORFONT = $1
NATIVE {CT_GREYFONT}  CONST CT_GREYFONT  = $2
NATIVE {CT_ANTIALIAS} CONST CT_ANTIALIAS = $4
NATIVE {CT_COLORMASK} CONST CT_COLORMASK = $000F

NATIVE {TextExtent} OBJECT textextent
    {te_Width}	width	:UINT
    {te_Height}	height	:UINT

    {te_Extent}	extent	:rectangle
ENDOBJECT
