/* $VER: diskfonttag.h 10.6 (28.12.2001) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <diskfont/diskfonttag.h>}
NATIVE {DISKFONT_DISKFONTTAG_H} CONST

/* Level 0 entries never appear in the .otag tag list, but appear in font
 * specifications */
NATIVE {OT_Level0}      CONST OT_LEVEL0      = TAG_USER
/* Level 1 entries are required to exist in the .otag tag list */
NATIVE {OT_Level1}      CONST OT_LEVEL1      = (TAG_USER OR $1000)
/* Level 2 entries are optional typeface metric tags */
NATIVE {OT_Level2}      CONST OT_LEVEL2      = (TAG_USER OR $2000)
/* Level 3 entries are required for some OT_Engines */
NATIVE {OT_Level3}      CONST OT_LEVEL3      = (TAG_USER OR $3000)
/* Indirect entries are at (tag address + data offset) */
NATIVE {OT_Indirect}    CONST OT_INDIRECT    = $8000


/********************************************************************/
/* font specification and inquiry tags */

/* !  tags flagged with an exclaimation mark are valid for
 *    specification.
 *  ? tags flagged with a question mark are valid for inquiry
 *
 * fixed binary numbers are encoded as 16 bits of integer and
 * 16 bits of fraction.  Negative values are indicated by twos
 * complement of all 32 bits.
 */

/* !  OT_DeviceDPI specifies the target device dots per inch -- X DPI is
 *    in the high word, Y DPI in the low word. */
NATIVE {OT_DeviceDPI}   CONST OT_DEVICEDPI   = (OT_LEVEL0 OR $01)      /* == TA_DeviceDPI */

/* !  OT_DotSize specifies the target device dot size as a percent of
 *    it's resolution-implied size -- X percent in high word, Y percent
 *    in low word. */
NATIVE {OT_DotSize}     CONST OT_DOTSIZE     = (OT_LEVEL0 OR $02)

/* !  OT_PointHeight specifies the requested point height of a typeface,
 *    specifically, the height and nominal width of the em-square.
 *    The point referred to here is 1/72".  It is encoded as a fixed
 *    binary number. */
NATIVE {OT_PointHeight} CONST OT_POINTHEIGHT = (OT_LEVEL0 OR $08)

/* !  OT_SetFactor specifies the requested set width of a typeface.
 *    It distorts the width of the em-square from that specified by
 *    OT_PointHeight.  To compensate for a device with different
 *    horizontal and vertical resolutions, OT_DeviceDPI should be used
 *    instead.  For a normal aspect ratio, set to 1.0 (encoded as
 *    0x00010000).  This is the default value. */
NATIVE {OT_SetFactor}   CONST OT_SETFACTOR   = (OT_LEVEL0 OR $09)

/* !  OT_Shear... specifies the Sine and Cosine of the vertical stroke
 *    angle, as two fixed point binary fractions.  Both must be specified:
 *    first the Sine and then the Cosine.  Setting the sine component
 *    changes the Shear to an undefined value, setting the cosine
 *    component completes the Shear change to the new composite value.
 *    For no shear, set to 0.0, 1.0 (encoded as 0x00000000, 0x00010000).
 *    This is the default value. */
NATIVE {OT_ShearSin}    CONST OT_SHEARSIN    = (OT_LEVEL0 OR $0a)
NATIVE {OT_ShearCos}    CONST OT_SHEARCOS    = (OT_LEVEL0 OR $0b)

/* !  OT_Rotate... specifies the Sine and Cosine of the baselin rotation
 *    angle, as two fixed point binary fractions.  Both must be specified:
 *    first the Sine and then the Cosine.  Setting the sine component
 *    changes the Shear to an undefined value, setting the cosine
 *    component completes the Shear change to the new composite value.
 *    For no shear, set to 0.0, 1.0 (encoded as 0x00000000, 0x00010000).
 *    This is the default value. */
NATIVE {OT_RotateSin}   CONST OT_ROTATESIN   = (OT_LEVEL0 OR $0c)
NATIVE {OT_RotateCos}   CONST OT_ROTATECOS   = (OT_LEVEL0 OR $0d)

/* !  OT_Embolden... specifies values to algorithimically embolden -- or,
 *    when negative, lighten -- the glyph.  It is encoded as a fixed point
 *    binary fraction of the em-square.  The X and Y components can be
 *    changed indendently.  For normal characters, set to 0.0, 0.0
 *    (encoded as 0x00000000, 0x00000000).  This is the default value. */
NATIVE {OT_EmboldenX}   CONST OT_EMBOLDENX   = (OT_LEVEL0 OR $0e)
NATIVE {OT_EmboldenY}   CONST OT_EMBOLDENY   = (OT_LEVEL0 OR $0f)

/* !  OT_PointSize is an old method of specifying the point size,
 *    encoded as (points * 16). */
NATIVE {OT_PointSize}   CONST OT_POINTSIZE   = (OT_LEVEL0 OR $10)

/* !  OT_GlyphCode specifies the glyph (character) code to use with
 *    subsequent operations.  For example, this is the code for an
 *    OT_Glyph inquiry */
NATIVE {OT_GlyphCode}   CONST OT_GLYPHCODE   = (OT_LEVEL0 OR $11)

/* !  OT_GlyphCode2 specifies the second glyph code.  For example,
 *    this is the right glyph of the two glyphs of an OT_KernPair
 *    inquiry */
NATIVE {OT_GlyphCode2}  CONST OT_GLYPHCODE2  = (OT_LEVEL0 OR $12)

/* !  OT_GlyphWidth specifies a specific width for a glyph.
 *    It sets a specific escapement (advance) width for subsequent
 *    glyphs.  It is encoded as a fixed binary fraction of the em-square.
 *    To revert to using the font-defined escapement for each glyph, set
 *    to 0.0 (encoded as 0x00000000).  This is the default value. */
NATIVE {OT_GlyphWidth}  CONST OT_GLYPHWIDTH  = (OT_LEVEL0 OR $13)

/* !  OT_OTagPath and
 * !  OT_OTagList specify the selected typeface.  Both must be specified:
 *    first the Path and then the List.  Setting the path name changes
 *    changes the typeface to an undefined value, providing the List
 *    completes the typeface selection to the new typeface.  OTagPath
 *    is the null terminated full file path of the .otag file associated
 *    with the typeface.  OTagList is a memory copy of the processed
 *    contents of that .otag file (i.e. with indirections resolved).
 *    There are no default values for the typeface. */
NATIVE {OT_OTagPath}    CONST OT_OTAGPATH    = (OT_LEVEL0 OR OT_INDIRECT OR $14)
NATIVE {OT_OTagList}    CONST OT_OTAGLIST    = (OT_LEVEL0 OR OT_INDIRECT OR $15)

/*  ? OT_GlyphMap supplies a read-only struct GlyphMap pointer that
 *    describes a bitmap for a glyph with the current attributes. */
NATIVE {OT_GlyphMap}    CONST OT_GLYPHMAP    = (OT_LEVEL0 OR OT_INDIRECT OR $20)

/*  ? OT_WidthList supplies a read-only struct MinList of struct
 *    GlyphWidthEntry nodes for glyphs that are defined from GlyphCode
 *    to GlyphCode2, inclusive.  The widths are represented as fixed
 *    binary fractions of the em-square, ignoring any effect of
 *    SetFactor or GlyphWidth.  A width would need to be converted to
 *    a distance along the baseline in device units by the
 *    application. */
NATIVE {OT_WidthList}   CONST OT_WIDTHLIST   = (OT_LEVEL0 OR OT_INDIRECT OR $21)

/*  ? OT_...KernPair supplies the kern adjustment to be added to the
 *    current position after placement of the GlyphCode glyph and
 *    before placement of the GlyphCode2 glyph.  Text kern pairs are
 *    for rendering body text.  Display kern pairs are generally
 *    tighter values for display (e.g. headline) purposes.  The
 *    adjustment is represented as a fixed binary fraction of the
 *    em-square, ignoring any effect of SetFactor.  This number would
 *    need to be converted to a distance along the baseline in device
 *    units by the application. */
NATIVE {OT_TextKernPair} CONST OT_TEXTKERNPAIR = (OT_LEVEL0 OR OT_INDIRECT OR $22)
NATIVE {OT_DesignKernPair} CONST OT_DESIGNKERNPAIR = (OT_LEVEL0 OR OT_INDIRECT OR $23)

/*  ? OT_Underlined is an unsigned word which is used to request
 *    algorithimic underlining for the engine when rendering the glyph.
 *    Bullet.library currently does not support this tag, though it
 *    may be used by other engines in the future.  The default for
 *    any engine which supports this tag must be OTUL_None.  Engines which
 *    do not support this tag should return an appropriate OTERR value.
 *
 *    As of V39, diskfont.library will request underlining if specified
 *    in the TextAttr, or TTextAttr passed to OpenDiskFont().  Diskfont
 *    will first request Broken underlining (like the Text() function
 *    does when SetSoftStyle() is used), and then Solid underlining if
 *    the engine returns an error.  If the engine returns an error for
 *    both, then diskfont.library attempts to find, or create the best
 *    non-underlined font that it can. */
NATIVE {OT_UnderLined}          CONST OT_UNDERLINED          = (OT_LEVEL0 OR $24)

NATIVE {OTUL_None}              CONST OTUL_NONE              = 0
NATIVE {OTUL_Solid}             CONST OTUL_SOLID             = 1
NATIVE {OTUL_Broken}            CONST OTUL_BROKEN            = 2
NATIVE {OTUL_DoubleSolid}       CONST OTUL_DOUBLESOLID       = 3
NATIVE {OUTL_DoubleBroken}      CONST OUTL_DOUBLEBROKEN      = 4

/*  ? OT_StrikeThrough is a boolean which is used to request
 *    algorithimic strike through when rendering the glyph.
 *    Bullet.library currently does not support this tag, though it
 *    may be used by other engines in the future.  The default for
 *    any engined which supports this tag must be FALSE.  Engines which
 *    do not support this tag should return an appropriate OTERR value. */
NATIVE {OT_StrikeThrough}       CONST OT_STRIKETHROUGH       = (OT_LEVEL0 OR $25)


/********************************************************************/
/* .otag tags */

/* suffix for files in FONTS: that contain these tags */
NATIVE {OTSUFFIX}       CONST
#define OTSUFFIX otsuffix
STATIC otsuffix       = '.otag'

/* OT_FileIdent both identifies this file and verifies its size.
 * It is required to be the first tag in the file. */
NATIVE {OT_FileIdent}   CONST OT_FILEIDENT   = (OT_LEVEL1 OR $01)

/* OT_Engine specifies the font engine this file is designed to use */
NATIVE {OT_Engine}      CONST OT_ENGINE      = (OT_LEVEL1 OR OT_INDIRECT OR $02)
NATIVE {OTE_Bullet}     CONST
#define OTE_BULLET ote_bullet
STATIC ote_bullet     = 'bullet'

/* OT_Family is the family name of this typeface */
NATIVE {OT_Family}      CONST OT_FAMILY      = (OT_LEVEL1 OR OT_INDIRECT OR $03)

/* The name of this typeface is implicit in the name of the .otag file */
/* OT_BName is used to find the bold variant of this typeface */
NATIVE {OT_BName}       CONST OT_BNAME       = (OT_LEVEL2 OR OT_INDIRECT OR $05)
/* OT_IName is used to find the italic variant of this typeface */
NATIVE {OT_IName}       CONST OT_INAME       = (OT_LEVEL2 OR OT_INDIRECT OR $06)
/* OT_BIName is used to find the bold italic variant of this typeface */
NATIVE {OT_BIName}      CONST OT_BINAME      = (OT_LEVEL2 OR OT_INDIRECT OR $07)
/* OT_RName is used to find the Roman variant of this typeface */
NATIVE {OT_RName}	CONST OT_RNAME	= (OT_LEVEL2 OR OT_INDIRECT OR $09)

/* OT_SymSet is used to select the symbol set that has the OT_YSizeFactor
 * described here.  Other symbol sets might have different extremes */
NATIVE {OT_SymbolSet}   CONST OT_SYMBOLSET   = (OT_LEVEL1 OR $10)

/* OT_YSizeFactor is a ratio to assist in calculating the Point height
 * to BlackHeight relationship -- high word: Point height term, low
 * word: Black height term -- pointSize = ysize*<high>/<low> */
NATIVE {OT_YSizeFactor} CONST OT_YSIZEFACTOR = (OT_LEVEL1 OR $11)

/* OT_SpaceWidth specifies the width of the space character relative
 * to the character height */
NATIVE {OT_SpaceWidth}  CONST OT_SPACEWIDTH  = (OT_LEVEL2 OR $12)

/* OT_IsFixed is a boolean indicating that all the characters in the
 * typeface are intended to have the same character advance */
NATIVE {OT_IsFixed}     CONST OT_ISFIXED     = (OT_LEVEL2 OR $13)

/* OT_SerifFlag is a boolean indicating if the character has serifs */
NATIVE {OT_SerifFlag}   CONST OT_SERIFFLAG   = (OT_LEVEL1 OR $14)

/* OT_StemWeight is an unsigned byte indicating the weight of the character */
NATIVE {OT_StemWeight}  CONST OT_STEMWEIGHT  = (OT_LEVEL1 OR $15)

NATIVE {OTS_UltraThin}    CONST OTS_ULTRATHIN    = 8     /*   0- 15 */
NATIVE {OTS_ExtraThin}   CONST OTS_EXTRATHIN   = 24     /*  16- 31 */
NATIVE {OTS_Thin}        CONST OTS_THIN        = 40     /*  32- 47 */
NATIVE {OTS_ExtraLight}  CONST OTS_EXTRALIGHT  = 56     /*  48- 63 */
NATIVE {OTS_Light}       CONST OTS_LIGHT       = 72     /*  64- 79 */
NATIVE {OTS_DemiLight}   CONST OTS_DEMILIGHT   = 88     /*  80- 95 */
NATIVE {OTS_SemiLight}  CONST OTS_SEMILIGHT  = 104     /*  96-111 */
NATIVE {OTS_Book}       CONST OTS_BOOK       = 120     /* 112-127 */
NATIVE {OTS_Medium}     CONST OTS_MEDIUM     = 136     /* 128-143 */
NATIVE {OTS_SemiBold}   CONST OTS_SEMIBOLD   = 152     /* 144-159 */
NATIVE {OTS_DemiBold}   CONST OTS_DEMIBOLD   = 168     /* 160-175 */
NATIVE {OTS_Bold}       CONST OTS_BOLD       = 184     /* 176-191 */
NATIVE {OTS_ExtraBold}  CONST OTS_EXTRABOLD  = 200     /* 192-207 */
NATIVE {OTS_Black}      CONST OTS_BLACK      = 216     /* 208-223 */
NATIVE {OTS_ExtraBlack} CONST OTS_EXTRABLACK = 232     /* 224-239 */
NATIVE {OTS_UltraBlack} CONST OTS_ULTRABLACK = 248     /* 240-255 */

/* OT_SlantStyle is an unsigned byte indicating the font posture */
NATIVE {OT_SlantStyle}  CONST OT_SLANTSTYLE  = (OT_LEVEL1 OR $16)
NATIVE {OTS_Upright}    CONST OTS_UPRIGHT    = 0
NATIVE {OTS_Italic}     CONST OTS_ITALIC     = 1       /* Oblique, Slanted, etc. */
NATIVE {OTS_LeftItalic} CONST OTS_LEFTITALIC = 2       /* Reverse Slant */

/* OT_HorizStyle is an unsigned byte indicating the appearance width */
NATIVE {OT_HorizStyle}  CONST OT_HORIZSTYLE  = (OT_LEVEL1 OR $17)
NATIVE {OTH_UltraCompressed}     CONST OTH_ULTRACOMPRESSED     = 16     /*   0- 31 */
NATIVE {OTH_ExtraCompressed}     CONST OTH_EXTRACOMPRESSED     = 48     /*  32- 63 */
NATIVE {OTH_Compressed}          CONST OTH_COMPRESSED          = 80     /*  64- 95 */
NATIVE {OTH_Condensed}          CONST OTH_CONDENSED          = 112     /*  96-127 */
NATIVE {OTH_Normal}             CONST OTH_NORMAL             = 144     /* 128-159 */
NATIVE {OTH_SemiExpanded}       CONST OTH_SEMIEXPANDED       = 176     /* 160-191 */
NATIVE {OTH_Expanded}           CONST OTH_EXPANDED           = 208     /* 192-223 */
NATIVE {OTH_ExtraExpanded}      CONST OTH_EXTRAEXPANDED      = 240     /* 224-255 */

/* OT_SpaceFactor specifies the width of the space character relative
 * to the character height */
NATIVE {OT_SpaceFactor} CONST OT_SPACEFACTOR = (OT_LEVEL2 OR $18)

/* OT_InhibitAlgoStyle indicates which ta_Style bits, if any, should
 * be ignored even if the font does not already have that quality.
 * For example, if FSF_BOLD is set and the typeface is not bold but
 * the user specifies bold, the application or diskfont library is
 * not to use OT_Embolden to achieve a bold result. */
NATIVE {OT_InhibitAlgoStyle} CONST OT_INHIBITALGOSTYLE = (OT_LEVEL2 OR $19)

/* OT_AvailSizes is an indirect pointer to sorted UWORDs, 0th is count */
NATIVE {OT_AvailSizes}  CONST OT_AVAILSIZES  = (OT_LEVEL1 OR OT_INDIRECT OR $20)
NATIVE {OT_MAXAVAILSIZES}       CONST OT_MAXAVAILSIZES       = 20      /* no more than 20 sizes allowed */

/* OT_SpecCount is the count number of parameters specified here */
NATIVE {OT_SpecCount}   CONST OT_SPECCOUNT   = (OT_LEVEL1 OR $100)

/* Specs can be created as appropriate for the engine by ORing in the
 * parameter number (1 is first, 2 is second, ... up to 15th) */
NATIVE {OT_Spec}        CONST OT_SPEC        = (OT_LEVEL1 OR $100)
/* OT_Spec1 is the (first) parameter to the font engine to select
 * this particular typeface */
NATIVE {OT_Spec1}       CONST OT_SPEC1       = (OT_LEVEL1 OR $101)


/********************************************************************/
/* GetDiskFontCtrl and SetDiskFontCtrl tags */

NATIVE {DFCTRL_BASE}     CONST DFCTRL_BASE     = (TAG_USER + $0B000000)

/*
 * X and Y DPI device default settings for the bullet library font generator.
 * Default is 72 dpi.
 */

NATIVE {DFCTRL_XDPI}     CONST DFCTRL_XDPI     = (DFCTRL_BASE + 1)
NATIVE {DFCTRL_YDPI}     CONST DFCTRL_YDPI     = (DFCTRL_BASE + 2)

/*
 * X and Y DPI dot size settings for the font generator.
 * Default is 100dpi.
 */

NATIVE {DFCTRL_XDOTP}    CONST DFCTRL_XDOTP    = (DFCTRL_BASE + 3)
NATIVE {DFCTRL_YDOTP}    CONST DFCTRL_YDOTP    = (DFCTRL_BASE + 4)

/*
 * Default symbol set identifier. This is currently unused.
 */

NATIVE {DFCTRL_SYMSET}   CONST DFCTRL_SYMSET   = (DFCTRL_BASE + 4)

/*
 * AvailFonts cache enable flag. Either TRUE or FALSE.
 */

NATIVE {DFCTRL_CACHE}    CONST DFCTRL_CACHE    = (DFCTRL_BASE + 5)

/*
 * Availfonts font sorting flag. See below for available values.
 */
NATIVE {DFCTRL_SORTMODE} CONST DFCTRL_SORTMODE = (DFCTRL_BASE + 6)

/* No sorting: Default. */
NATIVE {DFCTRL_SORT_OFF} CONST DFCTRL_SORT_OFF = 0

/* Asceding sort order, localized with default locale. */
NATIVE {DFCTRL_SORT_ASC} CONST DFCTRL_SORT_ASC = 1

/* Descending sort order, localized with default locale. */
NATIVE {DFCTRL_SORT_DES} CONST DFCTRL_SORT_DES = -1
