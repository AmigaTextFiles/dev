@DATABASE "gg:doc/NDK/Guide/Include/graphics/text.h"
@MASTER   "gg:os-include/graphics/text.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:08
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/text.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/text.h" LINK File}


@{b}Structures@{ub}

@{"ColorFontColors" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 143}    @{"ColorTextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 150}  @{"TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65}  @{"TextExtent" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 164}  @{"TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89}
@{"TextFontExtension" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 119}  @{"TTextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 72}      


@{b}#defines@{ub}

@{"CT_ANTIALIAS" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 137}      @{"CT_COLORFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 134}    @{"CT_COLORMASK" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 133}    @{"CT_GREYFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 135}
@{"CTB_MAPCOLOR" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 139}      @{"CTF_MAPCOLOR" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 140}    @{"FPB_DESIGNED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 54}    @{"FPB_DISKFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 44}
@{"FPB_PROPORTIONAL" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 52}  @{"FPB_REMOVED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 61}     @{"FPB_REVPATH" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 46}     @{"FPB_ROMFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 42}
@{"FPB_TALLDOT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 48}       @{"FPB_WIDEDOT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 50}     @{"FPF_DESIGNED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 59}    @{"FPF_DISKFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 45}
@{"FPF_PROPORTIONAL" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 53}  @{"FPF_REMOVED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 62}     @{"FPF_REVPATH" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 47}     @{"FPF_ROMFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 43}
@{"FPF_TALLDOT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 49}       @{"FPF_WIDEDOT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 51}     @{"FS_NORMAL" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 26}       @{"FSB_BOLD" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 29}
@{"FSB_COLORFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 36}     @{"FSB_EXTENDED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 33}    @{"FSB_ITALIC" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 31}      @{"FSB_TAGGED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 38}
@{"FSB_UNDERLINED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 27}    @{"FSF_BOLD" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 30}        @{"FSF_COLORFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 37}   @{"FSF_EXTENDED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 34}
@{"FSF_ITALIC" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 32}        @{"FSF_TAGGED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 39}      @{"FSF_UNDERLINED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 28}  @{"MAXFONTMATCHWEIGHT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 85}
@{"TA_DeviceDPI" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 82}      @{"TE0B_NOREMFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 116}  @{"TE0F_NOREMFONT" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 117}  @{"tf_Extension" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 113}

@ENDNODE
@NODE File "graphics/text.h"
#ifndef GRAPHICS_TEXT_H
#define GRAPHICS_TEXT_H
/*
**      $VER: text.h 39.0 (21.8.1991)
**      Includes Release 45.1
**
**      graphics library text structures
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_PORTS_H
#include        <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif  /* EXEC_PORTS_H */

#ifndef GRAPHICS_GFX_H
#include        <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif  /* GRAPHICS_GFX_H */

#ifndef UTILITY_TAGITEM_H
#include        <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif  /* UTILITY_TAGITEM_H */

/*------ Font Styles ------------------------------------------------*/
#define FS_NORMAL       0       /* normal text (no style bits set) */
#define FSB_UNDERLINED  0       /* underlined (under baseline) */
#define FSF_UNDERLINED  0x01
#define FSB_BOLD        1       /* bold face text (ORed w/ shifted) */
#define FSF_BOLD        0x02
#define FSB_ITALIC      2       /* italic (slanted 1:2 right) */
#define FSF_ITALIC      0x04
#define FSB_EXTENDED    3       /* extended face (wider than normal) */
#define FSF_EXTENDED    0x08

#define FSB_COLORFONT   6       /* this uses ColorTextFont structure */
#define FSF_COLORFONT   0x40
#define FSB_TAGGED      7       /* the TextAttr is really an TTextAttr, */
#define FSF_TAGGED      0x80

/*------ Font Flags -------------------------------------------------*/
#define FPB_ROMFONT     0       /* font is in rom */
#define FPF_ROMFONT     0x01
#define FPB_DISKFONT    1       /* font is from @{"diskfont.library" LINK "gg:doc/NDK/Guide/diskfont/MAIN"} */
#define FPF_DISKFONT    0x02
#define FPB_REVPATH     2       /* designed path is reversed (e.g. left) */
#define FPF_REVPATH     0x04
#define FPB_TALLDOT     3       /* designed for hires non-interlaced */
#define FPF_TALLDOT     0x08
#define FPB_WIDEDOT     4       /* designed for lores interlaced */
#define FPF_WIDEDOT     0x10
#define FPB_PROPORTIONAL 5      /* character sizes can vary from nominal */
#define FPF_PROPORTIONAL 0x20
#define FPB_DESIGNED    6       /* size explicitly designed, not constructed */
                                /* note: if you do not set this bit in your */
                                /* textattr, then a font may be constructed */
                                /* for you by scaling an existing rom or disk */
                                /* font (under V36 and above). */
#define FPF_DESIGNED    0x40
    /* bit 7 is always clear for fonts on the graphics font list */
#define FPB_REMOVED     7       /* the font has been removed */
#define FPF_REMOVED     (1<<7)

/****** TextAttr node, matches text attributes in RastPort **********/
struct TextAttr {
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  ta_Name;            /* name of the font */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ta_YSize;           /* height of the font */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ta_Style;           /* intrinsic font style */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ta_Flags;           /* font preferences and flags */
};

struct TTextAttr {
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  tta_Name;           /* name of the font */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tta_YSize;          /* height of the font */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tta_Style;          /* intrinsic font style */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tta_Flags;          /* font preferences and flags */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tta_Tags;   /* extended attributes */
};


/****** Text Tags ***************************************************/
#define TA_DeviceDPI    (1|@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48})    /* Tag value is Point union: */
                                        /* Hi word XDPI, Lo word YDPI */

#define MAXFONTMATCHWEIGHT      32767   /* perfect match from WeighTAMatch */


/****** TextFonts node **********************************************/
struct TextFont {
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} tf_Message;  /* reply message for font removal */
                                /* font name in LN        \\    used in this */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tf_YSize;           /* font height            |    order to best */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tf_Style;           /* font style             |    match a font */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tf_Flags;           /* preferences and flags  /    request. */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tf_XSize;           /* nominal font width */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tf_Baseline;        /* distance from the top of char to baseline */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tf_BoldSmear;       /* smear to affect a bold enhancement */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tf_Accessors;       /* access count */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tf_LoChar;          /* the first character described here */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tf_HiChar;          /* the last character described here */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tf_CharData;        /* the bit character data */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tf_Modulo;          /* the row modulo for the strike font data */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tf_CharLoc;         /* ptr to location data for the strike font */
                                /*   2 words: bit offset then size */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tf_CharSpace;       /* ptr to words of proportional spacing data */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    tf_CharKern;        /* ptr to words of kerning data */
};

/* unfortunately, this needs to be explicitly typed */
#define tf_Extension    tf_Message.mn_ReplyPort

/*----- tfe_Flags0 (partial definition) ----------------------------*/
#define TE0B_NOREMFONT  0       /* disallow @{"RemFont" LINK "gg:doc/NDK/Guide/graphics/RemFont"} for this font */
#define TE0F_NOREMFONT  0x01

struct TextFontExtension {      /* this structure is read-only */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tfe_MatchWord;              /* a magic cookie for the extension */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tfe_Flags0;                 /* (system private flags) */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tfe_Flags1;                 /* (system private flags) */
    @{"struct TextFont" LINK File 89} *tfe_BackPtr;       /* validation of compilation */
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *tfe_OrigReplyPort;  /* original value in @{"tf_Extension" LINK File 113} */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tfe_Tags;           /* Text Tags for the font */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  *tfe_OFontPatchS;            /* (system private use) */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  *tfe_OFontPatchK;            /* (system private use) */
    /* this space is reserved for future expansion */
};

/****** ColorTextFont node ******************************************/
/*----- ctf_Flags --------------------------------------------------*/
#define CT_COLORMASK    0x000F  /* mask to get to following color styles */
#define CT_COLORFONT    0x0001  /* color map contains designer's colors */
#define CT_GREYFONT     0x0002  /* color map describes even-stepped */
                                /* brightnesses from low to high */
#define CT_ANTIALIAS    0x0004  /* zero background thru fully saturated char */

#define CTB_MAPCOLOR    0       /* map ctf_FgColor to the rp_FgPen if it's */
#define CTF_MAPCOLOR    0x0001  /* is a valid color within ctf_Low..ctf_High */

/*----- ColorFontColors --------------------------------------------*/
struct ColorFontColors {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   cfc_Reserved;       /* *must* be zero */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   cfc_Count;          /* number of entries in cfc_ColorTable */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  *cfc_ColorTable;     /* 4 bit per component color map packed xRGB */
};

/*----- ColorTextFont ----------------------------------------------*/
struct ColorTextFont {
    @{"struct TextFont" LINK File 89} ctf_TF;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ctf_Flags;          /* extended flags */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ctf_Depth;          /* number of bit planes */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ctf_FgColor;        /* color that is remapped to FgPen */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ctf_Low;            /* lowest color represented here */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ctf_High;           /* highest color represented here */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ctf_PlanePick;      /* PlanePick ala Images */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ctf_PlaneOnOff;     /* PlaneOnOff ala Images */
    @{"struct ColorFontColors" LINK File 143} *ctf_ColorFontColors; /* colors for font */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ctf_CharData[8];    /*pointers to bit planes ala tf_CharData */
};

/****** @{"TextExtent" LINK "gg:doc/NDK/Guide/graphics/TextExtent"} node *********************************************/
struct TextExtent {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   te_Width;           /* same as @{"TextLength" LINK "gg:doc/NDK/Guide/graphics/TextLength"} */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   te_Height;          /* same as tf_YSize */
    @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} te_Extent; /* relative to CP */
};

#endif  /* GRAPHICS_TEXT_H */
@ENDNODE
