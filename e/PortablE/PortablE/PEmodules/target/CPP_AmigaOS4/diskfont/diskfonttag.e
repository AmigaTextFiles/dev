/* $Id: diskfonttag.h,v 1.19 2005/11/10 15:31:54 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <diskfont/diskfonttag.h>}
NATIVE {DISKFONT_DISKFONTTAG_H} CONST

/* Level 0 entries never appear in the .otag tag list, but appear in font
 * specifications */
NATIVE {OT_Level0}   CONST OT_LEVEL0   = TAG_USER

/* Level 1 entries are required to exist in the .otag tag list */
NATIVE {OT_Level1}   CONST OT_LEVEL1   = (TAG_USER OR $1000)

/* Level 2 entries are optional typeface metric tags */
NATIVE {OT_Level2}   CONST OT_LEVEL2   = (TAG_USER OR $2000)

/* Level 3 entries are required for some OT_Engines */
NATIVE {OT_Level3}   CONST OT_LEVEL3   = (TAG_USER OR $3000)

/* Indirect entries are at (tag address + data offset) */
NATIVE {OT_Indirect} CONST OT_INDIRECT = $8000


/********************************************************************/
/* font specification and inquiry tags */

/* !  tags flagged with an exclaimation mark are valid for
 *    specification.
 *
 *  ? tags flagged with a question mark are valid for inquiry.
 *
 * fixed binary numbers are encoded as 16 bits of integer and
 * 16 bits of fraction.  Negative values are indicated by twos
 * complement of all 32 bits.
 */

/* !  OT_DeviceDPI specifies the target device dots per inch -- X DPI is
 *    in the high word, Y DPI in the low word. An inch is about 25.04 mm.
 *    Note: If you know the exact DPI values (e.g. of a printer),
 *    you can specify them here.  If you dont know the exact DPI
 *    values but the aspect ratio (e.g. for display) use 72 DPI for
 *    Y and an aspect-corrected value for X (the display aspect ratio
 *    can be obtained with GetDisplayInfoData(), DInfo.Resolution
 *    can only be used as ratio since AmigaOS is unaware of the physical
 *    display size).  If you dont know the exact DPI values or
 *    the aspect ratio, use 72 DPI for X and Y.
 */
NATIVE {OT_DeviceDPI} CONST OT_DEVICEDPI = (OT_LEVEL0 OR $01)      /* == TA_DeviceDPI */

/* !  OT_DotSize specifies the target device dot size as a percent of
 *    it's resolution-implied size -- X percent in high word, Y percent
 *    in low word.  For a normal dot size, set to 0x00640064.  This is
 *    the default value.  Not all font engines accept other values.
 */
NATIVE {OT_DotSize} CONST OT_DOTSIZE = (OT_LEVEL0 OR $02)

/* !  OT_PointHeight specifies the requested point height of a typeface,
 *    specifically, the height and nominal width of the em-square.
 *    The point referred to here is 1/72" (inch).  An inch is about 25.04
 *    mm.  It is encoded as a fixed binary number.
 *    Note: If you prefer a pixel height instead of a point heigth,
 *    use the OT_YSizeFactor ratio to compute the one from the other
 *    or vice versa.
 */
NATIVE {OT_PointHeight} CONST OT_POINTHEIGHT = (OT_LEVEL0 OR $08)

/* !  OT_SetFactor specifies the requested set width of a typeface.
 *    It distorts the width of the em-square from that specified by
 *    OT_PointHeight.  To compensate for a device with different
 *    horizontal and vertical resolutions, OT_DeviceDPI should be used
 *    instead.  For a normal aspect ratio, set to 1.0 (encoded as
 *    0x00010000).  This is the default value.
 */
NATIVE {OT_SetFactor} CONST OT_SETFACTOR = (OT_LEVEL0 OR $09)

/* !  OT_Shear... specifies the Sine and Cosine of the clockwise vertical
 *    stroke angle, as two fixed point binary fractions.  Both must be
 *    specified: first the Sine and then the Cosine.  Setting the sine
 *    component changes the Shear to an undefined value, setting the
 *    cosine component completes the Shear change to the new composite
 *    value.  For no shear, set to 0.0, 1.0 (encoded as 0x00000000,
 *    0x00010000).  This is the default value.
 */
NATIVE {OT_ShearSin} CONST OT_SHEARSIN = (OT_LEVEL0 OR $0a)
NATIVE {OT_ShearCos} CONST OT_SHEARCOS = (OT_LEVEL0 OR $0b)

/* !  OT_Rotate... specifies the Sine and Cosine of the counter-clockwise
 *    baseline rotation angle, as two fixed point binary fractions.  Both
 *    must be specified: first the Sine and then the Cosine.  Setting the
 *    sine component changes the Shear to an undefined value, setting the
 *    cosine component completes the Shear change to the new composite
 *    value.  For no shear, set to 0.0, 1.0 (encoded as 0x00000000,
 *    0x00010000).  This is the default value.
 */
NATIVE {OT_RotateSin} CONST OT_ROTATESIN = (OT_LEVEL0 OR $0c)
NATIVE {OT_RotateCos} CONST OT_ROTATECOS = (OT_LEVEL0 OR $0d)

/* !  OT_Embolden... specifies values to algorithimically embolden -- or,
 *    when negative, lighten -- the glyph.  It is encoded as a fixed point
 *    binary fraction of the em-square.  The X and Y components can be
 *    changed indendently.  For normal characters, set to 0.0, 0.0
 *    (encoded as 0x00000000, 0x00000000).  This is the default value.
 */
NATIVE {OT_EmboldenX} CONST OT_EMBOLDENX = (OT_LEVEL0 OR $0e)
NATIVE {OT_EmboldenY} CONST OT_EMBOLDENY = (OT_LEVEL0 OR $0f)

/* !  OT_PointSize is an old method of specifying the point size,
 *    encoded as (points * 16).
 */
NATIVE {OT_PointSize} CONST OT_POINTSIZE = (OT_LEVEL0 OR $10)

/* !  OT_GlyphCode specifies the glyph (character) code to use with
 *    subsequent operations.  For example, this is the code for an
 *    OT_GlyphMap inquiry
 */
NATIVE {OT_GlyphCode} CONST OT_GLYPHCODE = (OT_LEVEL0 OR $11)

/* !  OT_GlyphCode2 specifies the second glyph code.  For example,
 *    this is the right glyph of the two glyphs of an OT_KernPair
 *    inquiry
 */
NATIVE {OT_GlyphCode2} CONST OT_GLYPHCODE2 = (OT_LEVEL0 OR $12)

/* For Unicode 3.1 compatibility:
 * Since Unicode 3.1 glyph codes are no longer limited to 16 bit.
 * To avoid problems with font engines that silently ignore the
 * upper 16 bit of a glyph code, two new tags are introduced
 * which can be used for specifying 32 bit ULONG glyph codes.
 * Old font engines will return an error code, e.g. OTERR_UnknownTag.
 * Font engines supporting the new tags will handle the old and
 * new tags as equal (both as 32 bit ULONG).
 * It only makes sense to use the new tags and glyph codes beyond
 * 0xFFFF when OT_UnicodeRanges is present in the .otag file and
 * has the UCR_SURROGATES bit set, which means the font has at least
 * one glyph code beyond 0xFFFF.
 */
NATIVE {OT_GlyphCode_32}  CONST OT_GLYPHCODE_32  = (OT_LEVEL0 OR $18)
NATIVE {OT_GlyphCode2_32} CONST OT_GLYPHCODE2_32 = (OT_LEVEL0 OR $19)

/* !  OT_GlyphWidth specifies a specific width for a glyph.
 *    It sets a specific escapement (advance) width for subsequent
 *    glyphs.  It is encoded as a fixed binary fraction of the em-square.
 *    To revert to using the font-defined escapement for each glyph, set
 *    to 0.0 (encoded as 0x00000000).  This is the default value.
 */
NATIVE {OT_GlyphWidth} CONST OT_GLYPHWIDTH = (OT_LEVEL0 OR $13)

/* !  OT_OTagPath and
 * !  OT_OTagList specify the selected typeface.  Both must be specified:
 *    first the Path and then the List.  Setting the path name
 *    changes the typeface to an undefined value, providing the List
 *    completes the typeface selection to the new typeface.  OTagPath
 *    is the null terminated full file path of the .otag file associated
 *    with the typeface.  OTagList is a memory copy of the processed
 *    contents of that .otag file (i.e. with indirections resolved).
 *    There are no default values for the typeface.
 *    Note: diskfont.library uses the full name of the .font file
 *    for OT_OTagPath, WordWorth7 uses the full name of the .otag
 *    file. The font engine should only use the path component.
 */
NATIVE {OT_OTagPath} CONST OT_OTAGPATH = (OT_LEVEL0 OR OT_INDIRECT OR $14)
NATIVE {OT_OTagList} CONST OT_OTAGLIST = (OT_LEVEL0 OR OT_INDIRECT OR $15)

/* !  OT_MemPtr and
 * !  OT_MemSize specify the address and size of a raw font in memory
 *    (e.g. a font embedded in a PDF document) to be used instead of
 *    a disk font with an .otag file. Not all font engines support this
 *    tags.  Both must be specified: first the MemPtr and then the
 *    MemSize.  Setting the MemPtr changes the typeface to an undefined
 *    value, providing the MemSize completes the typeface selection to
 *    the new typeface.  MemPtr is the address of an embedded font in
 *    memory, MemSize is the size of the raw font in bytes.  Failure to
 *    identify the font format results in an appropriate error code.
 *    When no error is returned, you can get the information about the
 *    font that would normally be present in an .otag file by calling
 *    ObtainInfo(engineHandle, OT_OTagList, &tagListPtr, TAG_END);,
 *    if successfull, tagListPtr points to a tagList similar to an
 *    .otag file which has to be freed with
 *    ReleaseInfo(engineHandle, OT_OTagList, tagListPtr, TAG_END);.
 *    Do not release the memory containing the raw font until you have
 *    selected another raw or disk font or closed the engineHandle.
 */
NATIVE {OT_MemPtr}  CONST OT_MEMPTR  = (OT_LEVEL0 OR OT_INDIRECT OR $16)
NATIVE {OT_MemSize} CONST OT_MEMSIZE = (OT_LEVEL0 OR $17)


/********************************************************************/
/* inquiry tags */

/*  ? OT_GlyphMap supplies a read-only struct GlyphMap pointer that
 *    describes a bitmap for a glyph with the current attributes.
 *    Note: Some font engines return an error for blank glyphs
 *    (e.g. space, non-blanking space) and some return a 1*1 pixel
 *    empty bitmap with spacing information.
 */
NATIVE {OT_GlyphMap} CONST OT_GLYPHMAP = (OT_LEVEL0 OR OT_INDIRECT OR $20)

/*  ? OT_GlyphMap8Bit supplies a read-only struct GlyphMap pointer that
 *    describes a bitmap for a glyph with the current attributes.
 *    The chunky bitmap contains bytes, not bits, each byte describes
 *    the intensity of the pixel, 0 is background color, 0xff is text
 *    color (called "font smoothing" or "anti-aliased glyph").
 *    Not all font engines support this tag, it depends on the font
 *    format whether there only exist 0x00 and 0xff bytes ("b/w") or
 *    if also intermediate values exist ("gray"). Has to be freed
 *    with ReleaseInfo(engineHandle, OT_GlyphMap8Bit, glyph, TAG_END);
 */
NATIVE {OT_GlyphMap8Bit} CONST OT_GLYPHMAP8BIT = (OT_LEVEL0 OR OT_INDIRECT OR $1a)

/*  ? OT_GlyphMap8BitLCD is similar to OT_GlyphMap8Bit but returns
 *    a pointer to a struct GlyphMap with a chunky bitmap that is three
 *    times wider than normal. This can be used for horizontal
 *    LCD-optimized sub-pixel font rendering (see
 *    http://grc.com/cleartype.htm). Note that the bitmap is not
 *    filtered, the caller must convert and filter it to a RGB or BGR
 *    bitmap (in other words, the bitmap is gray).
 *    Not all font engines support this tag, it depends on the font
 *    format whether there only exist 0x00 and 0xff bytes ("b/w") or
 *    if also intermediate values exist ("gray"). Has to be freed with
 *    ReleaseInfo(engineHandle, OT_GlyphMap8BitLCD, glyph, TAG_END);
 */
NATIVE {OT_GlyphMap8BitLCD} CONST OT_GLYPHMAP8BITLCD = (OT_LEVEL0 OR OT_INDIRECT OR $27)

/*  ? OT_GlyphMap8BitLCDV is similar to OT_GlyphMap8BitLCD but returns
 *    a pointer to a struct GlyphMap with a chunky bitmap that is three
 *    times higher than normal. This can be used for vertical
 *    LCD-optimized sub-pixel font rendering (see
 *    http://grc.com/cleartype.htm). Note that the bitmap is not
 *    filtered, the caller must convert and filter it to a RGB or BGR
 *    bitmap (in other words, the bitmap is gray).
 *    Not all font engines support this tag, it depends on the font
 *    format whether there only exist 0x00 and 0xff bytes ("b/w") or
 *    if also intermediate values exist ("gray"). Has to be freed with
 *    ReleaseInfo(engineHandle, OT_GlyphMap8BitLCDV, glyph, TAG_END);
 */
NATIVE {OT_GlyphMap8BitLCDV} CONST OT_GLYPHMAP8BITLCDV = (OT_LEVEL0 OR OT_INDIRECT OR $28)

/*  ? OT_WidthList supplies a read-only struct MinList of struct
 *    GlyphWidthEntry nodes for glyphs that are defined from GlyphCode
 *    to GlyphCode2, inclusive.  Use ascending order (GlyphCode <=
 *    GlyphCode2), not all font engines can manage descending order.
 *    The widths are represented as fixed binary fractions of the
 *    em-square, ignoring any effect of SetFactor or GlyphWidth.
 *    A width would need to be converted to a distance along the
 *    baseline in device units by the application.
 */
NATIVE {OT_WidthList} CONST OT_WIDTHLIST = (OT_LEVEL0 OR OT_INDIRECT OR $21)

/*  ? OT_WidthList32 supplies a read-only struct MinList of struct
 *    GlyphWidthEntry32 nodes for glyphs that are defined from GlyphCode_32
 *    to GlyphCode2_32, inclusive.  The list is guaranteed to be sorted by
 *    glyph code, in ascending order. The widths are represented as fixed
 *    binary fractions of the em-square, ignoring any effect of
 *    SetFactor or GlyphWidth.  A width would need to be converted to
 *    a distance along the baseline in device units by the
 *    application. Only font engines that support Unicode3.1 and up
 *    with glyph codes beyond 0xFFFF support this tag
 */
NATIVE {OT_WidthList32} CONST OT_WIDTHLIST32 = (OT_LEVEL0 OR OT_INDIRECT OR $1b)

/*  ? OT_...KernPair supplies the kern adjustment to be added to the
 *    current position after placement of the GlyphCode glyph and
 *    before placement of the GlyphCode2 glyph.  Text kern pairs are
 *    for rendering body text.  Display kern pairs are generally
 *    tighter values for display (e.g. headline) purposes.  The
 *    adjustment is represented as a fixed binary fraction of the
 *    em-square, ignoring any effect of SetFactor.  This number would
 *    need to be converted to a distance along the baseline in device
 *    units by the application.
 */
NATIVE {OT_TextKernPair}   CONST OT_TEXTKERNPAIR   = (OT_LEVEL0 OR OT_INDIRECT OR $22)
NATIVE {OT_DesignKernPair} CONST OT_DESIGNKERNPAIR = (OT_LEVEL0 OR OT_INDIRECT OR $23)

/*  ? OT_UnderLined is an unsigned word which is used to request
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
 *    non-underlined font that it can.
 *    Example:
 *    if (!ObtainInfo(engineHandle, OT_UnderLined, OTUL_Solid, TAG_DONE))
 *        printf("The font engine now solid underlines the glyphs\n");
 *    else
 *        printf("The font engine cant solid underline this font\n");
 */
NATIVE {OT_UnderLined} CONST OT_UNDERLINED = (OT_LEVEL0 OR $24)

NATIVE {OTUL_None}         CONST OTUL_NONE         = 0
NATIVE {OTUL_Solid}        CONST OTUL_SOLID        = 1
NATIVE {OTUL_Broken}       CONST OTUL_BROKEN       = 2
NATIVE {OTUL_DoubleSolid}  CONST OTUL_DOUBLESOLID  = 3
NATIVE {OTUL_DoubleBroken} CONST OTUL_DOUBLEBROKEN = 4
/* old versions had a typo here */
NATIVE {OUTL_DoubleBroken} CONST OUTL_DOUBLEBROKEN = OTUL_DOUBLEBROKEN

/*  ? OT_StrikeThrough is a boolean which is used to request
 *    algorithimic strike through when rendering the glyph.
 *    Bullet.library currently does not support this tag, though it
 *    may be used by other engines in the future.  The default for
 *    any engine which supports this tag must be FALSE.  Engines which
 *    do not support this tag should return an appropriate OTERR value.
 *    Example:
 *    if (!ObtainInfo(engineHandle, OT_StrikeThrough, TRUE, TAG_DONE))
 *        printf("The font engine now strikes through the glyphs\n");
 *    else
 *        printf("The font engine cant strikethrough this font\n");
 */
NATIVE {OT_StrikeThrough} CONST OT_STRIKETHROUGH = (OT_LEVEL0 OR $25)

/*  ? OT_BaseLine returns the ascender in the upper 16 bit
 *    and the descender in the lower 16 bit so you can compute
 *    the baseline faster if the font engine supports this tag.
 *    Even if the tag is supported you must check whether the
 *    result contains a zero ascender.
 *    Example:
 *
 *    int Ascend, Descend;
 *    ULONG BaseLine;
 *
 *    if (!ObtainInfo(engineHandle, OT_BaseLine, &BaseLine, TAG_END) &&
 *        ((BaseLine & 0xffff0000) != 0))
 *    {
 *            Ascend = BaseLine >> 16;
 *            Descend = BaseLine & 0xffff;
 *            BaseLinePosInPixels =
 *                (LineHeightInPixels * Ascend) / (Ascend + Descend);
 *    }
 *    else
 *    {
 *            // assume the baseline from ascender and
 *            // descender values of a series of rendered glyphs as before
 *    }
 */
NATIVE {OT_BaseLine} CONST OT_BASELINE = (OT_LEVEL0 OR OT_INDIRECT OR $1c)

/*  ? OT_NumGlyphs tells you how many glyphs the font contains.
 *    It depends on OT_SymbolSet if this number is really available.
 *    Example:
 *
 *    ULONG NumGlyphs;
 *
 *    if (!ObtainInfo(engineHandle, OT_NumGlyphs, &NumGlyphs, TAG_END))
 *        printf("The font contains %ld glyphs\n", NumGlyphs);
 *    else
 *        printf("The font engine does not support OT_NumGlyphs\n");
 */
NATIVE {OT_NumGlyphs} CONST OT_NUMGLYPHS = (OT_LEVEL0 OR OT_INDIRECT OR $1d)

/*  ? OT_NumKernPairs tells you how many kerning pairs the font contains.
 *    Example:
 *
 *    ULONG NumPairs;
 *
 *    if (!ObtainInfo(engineHandle, OT_NumKernPairs, &NumPairs, TAG_END))
 *        printf("The font contains %ld kerning pairs\n", NumPairs);
 *    else
 *        printf("The font engine does not support OT_NumKernPairs\n");
 */
NATIVE {OT_NumKernPairs} CONST OT_NUMKERNPAIRS = (OT_LEVEL0 OR OT_INDIRECT OR $1e)

/*  ? OT_HasGlyphs provides a faster searching method for the glyph codes
 *    that are definded in a font than OT_WidthList (depending on font
 *    format it may be necessary to render the glyphs for WidthList
 *    creation). You pass a pointer to an ULONG containing the number of
 *    glyphs to be checked for, after the call it contains 1 if so many
 *    glyphs are available or 0 otherwise.
 *    Example: If you want to know whether the font has at least 230
 *    cyrillic glyphs between 0x400 and 0x4ff then call something like
 *
 *    ULONG wanted = 230;
 *    if ((SetInfo(engineHandle, OT_GlyphCode, 0x400,
 *                 OT_GlyphCode2, 0x4ff, TAG_END) == OTERR_Success) &&
 *        (ObtainInfo(engineHandle, OT_HasGlyphs, &wanted,
 *                    TAG_END) == OTERR_Success))
 *    {
 *        if (wanted)
 *            printf("at least 230 cyrillic glyphs available\n");
 *        else
 *            printf("less than 230 cyrillic glyphs available\n");
 *    }
 *    else
 *    {
 *        // Use OT_WidthList since OT_HasGlyphs seems to be not supported
 *    }
 */
NATIVE {OT_HasGlyphs} CONST OT_HASGLYPHS = (OT_LEVEL0 OR OT_INDIRECT OR $1f)

/*  ? OT_GlyphName asks the font engine for the name of the glyph specified
 *    with OT_GlyphCode. You pass a pointer to a buffer of at least 128
 *    bytes in size. If the font engine supports this tag but the font does
 *    not contain glyph names, the return code will be OTERR_BadFace. If
 *    no error is returned, the buffer will be filled with the name of the
 *    glyph, at least with an empty string. It depends on the font format
 *    what type of name is returned (normally the postscript name).
 *    Example:
 *
 *    char namebuf[128];
 *
 *    if (!SetInfo(engineHandle, OT_GlyphCode, '>', TAG_END) &&
 *        !ObtainInfo(engineHandle, OT_GlyphName, &namebuf, TAG_END))
 *            printf("name of glyph '>': %s\n", namebuf); // greater
 */
NATIVE {OT_GlyphName} CONST OT_GLYPHNAME = (OT_LEVEL0 OR OT_INDIRECT OR $26)



/********************************************************************/
/* .otag tags */

/* suffix for files in FONTS: that contain these tags
 */
NATIVE {OTSUFFIX} CONST
#define OTSUFFIX otsuffix
STATIC otsuffix = '.otag'

/* OT_FileIdent both identifies this file and verifies its size.
 * It is required to be the first tag in the file.
 */
NATIVE {OT_FileIdent} CONST OT_FILEIDENT = (OT_LEVEL1 OR $01)

/* OT_Engine specifies the font engine this file is designed to use
 */
NATIVE {OT_Engine}  CONST OT_ENGINE  = (OT_LEVEL1 OR OT_INDIRECT OR $02)
NATIVE {OTE_Bullet} CONST
#define OTE_BULLET ote_bullet
STATIC ote_bullet = 'bullet'

/* OT_Family is the family name of this typeface
 */
NATIVE {OT_Family} CONST OT_FAMILY = (OT_LEVEL1 OR OT_INDIRECT OR $03)

/* OT_FontFile specifies the raw font file. This tag can be used
 * by special applications that are able to use e.g. a PostScript
 * Type1 font directly and want to know where the .pfa|.pfb file
 * is located. Before this public tag was specified, each font
 * engine did use a private tag for this purpose.
 */
NATIVE {OT_FontFile} CONST OT_FONTFILE = (OT_LEVEL2 OR OT_INDIRECT OR $24)

/* OT_MetricsFile specifies the metrics file (.afm, .pfm, ...) with
 * e.g. kerning information which can be used by several PostScript font
 * format variants.
 * This tag can be used by special applications that are able to use
 * e.g. a PostScript font directly and want to know where the metrics file
 * is located. Before this public tag was specified, each font
 * engine did use a private tag for this purpose.
 */
NATIVE {OT_MetricsFile} CONST OT_METRICSFILE = (OT_LEVEL2 OR OT_INDIRECT OR $25)
NATIVE {OT_AFMFile} CONST OT_AFMFILE = OT_METRICSFILE /* backwards compatibility */

/* OT_FontFormat specifies the format of the raw font file which was
 * specified with OT_FontFile. This tag can be used by special
 * applications that are able to use a raw font file directly. It was
 * introduced because there exist font engines that can handle
 * different font formats so the OT_Engine tag is not enough
 * information. The name has to be all lower case.
 */
NATIVE {OT_FontFormat} CONST OT_FONTFORMAT = (OT_LEVEL2 OR OT_INDIRECT OR $26)

NATIVE {OTF_BDF}         CONST
#define OTF_BDF otf_bdf
STATIC otf_bdf         = 'bdf'         /* Adobe Bitmap Distribution Format  */
NATIVE {OTF_CFF}         CONST
#define OTF_CFF otf_cff
STATIC otf_cff         = 'cff'         /* Adobe Compact Font Format */
NATIVE {OTF_Intellifont} CONST
#define OTF_INTELLIFONT otf_intellifont
STATIC otf_intellifont = 'intellifont' /* Agfa MonoType CompuGraphic */
NATIVE {OTF_PCF}         CONST
#define OTF_PCF otf_pcf
STATIC otf_pcf         = 'pcf'         /* X Portable Compiled Format */
NATIVE {OTF_PFR}         CONST
#define OTF_PFR otf_pfr
STATIC otf_pfr         = 'pfr'         /* Bitstream Portable Font Resource  */
NATIVE {OTF_TrueType}    CONST
#define OTF_TRUETYPE otf_truetype
STATIC otf_truetype    = 'truetype'    /* Apple|MicroSoft TrueType|OpenType */
NATIVE {OTF_Type1}       CONST
#define OTF_TYPE1 otf_type1
STATIC otf_type1       = 'type1'       /* Adobe PostScript Type1 */
NATIVE {OTF_Type1CID}    CONST
#define OTF_TYPE1CID otf_type1cid
STATIC otf_type1cid    = 't1cid'       /* Adobe CID-keyed PostScript Type1  */
NATIVE {OTF_Type42}      CONST
#define OTF_TYPE42 otf_type42
STATIC otf_type42      = 'type42'      /* Adobe PostScript Type42 */
NATIVE {OTF_WinFonts}    CONST
#define OTF_WINFONTS otf_winfonts
STATIC otf_winfonts    = 'winfonts'    /* MicroSoft .fnt|.fon */

/* The name of this typeface is implicit in the name of the .otag file.
 * The following four tags point to the names of other .otag files
 * that may be used instead of the current file for e.g. a bold face,
 * the names are without path and without .otag extension so they are
 * assumed to be in the same directory as the current .otag file.
 * Applications can use this information if present, diskfont.library
 * currently does not use it. It is not guaranteed that the other
 * .otag files were not deleted since this .otag file was written
 * (even FixFonts cant fix .otag files).
 */

/* OT_BName is used to find the bold variant of this typeface
 */
NATIVE {OT_BName}  CONST OT_BNAME  = (OT_LEVEL2 OR OT_INDIRECT OR $05)

/* OT_IName is used to find the italic variant of this typeface
 */
NATIVE {OT_IName}  CONST OT_INAME  = (OT_LEVEL2 OR OT_INDIRECT OR $06)

/* OT_BIName is used to find the bold italic variant of this typeface
 */
NATIVE {OT_BIName} CONST OT_BINAME = (OT_LEVEL2 OR OT_INDIRECT OR $07)

/* OT_RName is used to find the Roman variant of this typeface
 */
NATIVE {OT_RName}  CONST OT_RNAME  = (OT_LEVEL2 OR OT_INDIRECT OR $09)

/* OT_SymbolSet is used to select the symbol set that has the
 * OT_YSizeFactor described here.  Other symbol sets might have
 * different extremes.
 * Note: The only documented values for this tag are "L1" for
 * ISO 8859-1 Latin 1 and "GD" for "Gold Disk" (whatever that means).
 */
NATIVE {OT_SymbolSet} CONST OT_SYMBOLSET = (OT_LEVEL1 OR $10)

/* OT_YSizeFactor is a ratio to assist in calculating the Point height
 * to BlackHeight relationship -- high word: Point height term, low
 * word: Black height term -- pointSize = ysize*<high>/<low>
 */
NATIVE {OT_YSizeFactor} CONST OT_YSIZEFACTOR = (OT_LEVEL1 OR $11)

/* OT_SpaceWidth specifies the width of the space character relative
 * to the character height.  This tag's value is the width of the space
 * character at 250 points (where there are 72.307 points in an inch
 * and an inch is about 25.04 mm). The width is in Design Window Units
 * (DWUs).  One DWU is equal to 1/2540 inches.  To convert to X pixels:
 *
 *  OT_SpaceWidth   pointsize
 *  ------------- * --------- *  XDPI = spacewidth in pixels (X dots)
 *     2540           250
 *
 * Note: OT_SpaceWidth is a Level2 tag (optional) but is highly
 * recommended to be present in an .otag file, at least for fixed-width
 * fonts.
 */
NATIVE {OT_SpaceWidth} CONST OT_SPACEWIDTH = (OT_LEVEL2 OR $12)

/* OT_IsFixed is a boolean indicating that all the characters in the
 * typeface are intended to have the same character advance.
 * Defaults to FALSE if absent.
 */
NATIVE {OT_IsFixed} CONST OT_ISFIXED = (OT_LEVEL2 OR $13)

/* OT_IsUnderlined is a boolean indicating that the characters in the
 * typeface are underlined.
 * Defaults to FALSE if absent.
 */
NATIVE {OT_IsUnderlined} CONST OT_ISUNDERLINED = (OT_LEVEL2 OR $23)

/* OT_SerifFlag is a boolean indicating if the character has serifs
 */
NATIVE {OT_SerifFlag} CONST OT_SERIFFLAG = (OT_LEVEL1 OR $14)

/* OT_StemWeight is an unsigned byte indicating the weight of the character
 */
NATIVE {OT_StemWeight} CONST OT_STEMWEIGHT = (OT_LEVEL1 OR $15)

NATIVE {OTS_UltraThin}    CONST OTS_ULTRATHIN    = 8 /*   0- 15 */
NATIVE {OTS_ExtraThin}   CONST OTS_EXTRATHIN   = 24 /*  16- 31 */
NATIVE {OTS_Thin}        CONST OTS_THIN        = 40 /*  32- 47 */
NATIVE {OTS_ExtraLight}  CONST OTS_EXTRALIGHT  = 56 /*  48- 63 */
NATIVE {OTS_Light}       CONST OTS_LIGHT       = 72 /*  64- 79 */
NATIVE {OTS_DemiLight}   CONST OTS_DEMILIGHT   = 88 /*  80- 95 */
NATIVE {OTS_SemiLight}  CONST OTS_SEMILIGHT  = 104 /*  96-111 */
NATIVE {OTS_Book}       CONST OTS_BOOK       = 120 /* 112-127 */
NATIVE {OTS_Medium}     CONST OTS_MEDIUM     = 136 /* 128-143 */
NATIVE {OTS_SemiBold}   CONST OTS_SEMIBOLD   = 152 /* 144-159 */
NATIVE {OTS_DemiBold}   CONST OTS_DEMIBOLD   = 168 /* 160-175 */
NATIVE {OTS_Bold}       CONST OTS_BOLD       = 184 /* 176-191 */
NATIVE {OTS_ExtraBold}  CONST OTS_EXTRABOLD  = 200 /* 192-207 */
NATIVE {OTS_Black}      CONST OTS_BLACK      = 216 /* 208-223 */
NATIVE {OTS_ExtraBlack} CONST OTS_EXTRABLACK = 232 /* 224-239 */
NATIVE {OTS_UltraBlack} CONST OTS_ULTRABLACK = 248 /* 240-255 */

/* OT_SlantStyle is an unsigned byte indicating the font posture
 */
NATIVE {OT_SlantStyle} CONST OT_SLANTSTYLE = (OT_LEVEL1 OR $16)

NATIVE {OTS_Upright}    CONST OTS_UPRIGHT    = 0
NATIVE {OTS_Italic}     CONST OTS_ITALIC     = 1 /* Oblique, Slanted, etc. */
NATIVE {OTS_LeftItalic} CONST OTS_LEFTITALIC = 2 /* Reverse Slant */

/* OT_HorizStyle is an unsigned byte indicating the appearance width
 */
NATIVE {OT_HorizStyle} CONST OT_HORIZSTYLE = (OT_LEVEL1 OR $17)

NATIVE {OTH_UltraCompressed}  CONST OTH_ULTRACOMPRESSED  = 16 /*   0- 31 */
NATIVE {OTH_ExtraCompressed}  CONST OTH_EXTRACOMPRESSED  = 48 /*  32- 63 */
NATIVE {OTH_Compressed}       CONST OTH_COMPRESSED       = 80 /*  64- 95 */
NATIVE {OTH_Condensed}       CONST OTH_CONDENSED       = 112 /*  96-127 */
NATIVE {OTH_Normal}          CONST OTH_NORMAL          = 144 /* 128-159 */
NATIVE {OTH_SemiExpanded}    CONST OTH_SEMIEXPANDED    = 176 /* 160-191 */
NATIVE {OTH_Expanded}        CONST OTH_EXPANDED        = 208 /* 192-223 */
NATIVE {OTH_ExtraExpanded}   CONST OTH_EXTRAEXPANDED   = 240 /* 224-255 */

/* OT_SpaceFactor specifies the width of the space character relative
 * to the character height. The exact meaning of OT_SpaceFactor was
 * never documented, use OT_SpaceWidth instead.
 */
NATIVE {OT_SpaceFactor} CONST OT_SPACEFACTOR = (OT_LEVEL2 OR $18)

/* OT_InhibitAlgoStyle indicates which ta_Style bits, if any, should
 * be ignored even if the font does not already have that quality.
 * For example, if FSF_BOLD is set and the typeface is not bold but
 * the user specifies bold, the application or diskfont library is
 * not to use OT_Embolden to achieve a bold result.
 * Note: Since it depends not only on the font, but also on the
 * version of the font engine whether a font can be underlined,
 * emboldened, extended or sheared, dont analyze OT_InhibitAlgoStyle.
 * Specify the font with OT_OTagPath and OT_OTagList and then ask
 * the font engine if underlining etc is possible.
 */
NATIVE {OT_InhibitAlgoStyle} CONST OT_INHIBITALGOSTYLE = (OT_LEVEL2 OR $19)

/* OT_AvailSizes is an indirect pointer to a sorted (ascending)
 * array of UWORDs, the first UWORD is the number of entrys in
 * the array, the remaining UWORDs are the font sizes that
 * diskfont.library lists when calling AvailFonts().
 */
NATIVE {OT_AvailSizes} CONST OT_AVAILSIZES = (OT_LEVEL1 OR OT_INDIRECT OR $20)
NATIVE {OT_MAXAVAILSIZES} CONST OT_MAXAVAILSIZES = 20 /* no more than 20 sizes allowed */

/* OT_BMSize specifies whether the font is scalable or not.  Some font
 * engines can use non-scalable bitmap font formats, e.g.
 * .(bdf|fnt|fon|pcf) files.  This is an unsigned long that contains
 * the maximum glyph bounding box width in pixels in the high word and
 * the maximum glyph bounding box height in pixels in the low word.
 * If absent or 0 the font is scalable. Setting OT_DeviceDPI,
 * OT_PointHeight etc for non-scalable fonts has no effect on the glyphs,
 * especially they can be much higher as expected.  If you e.g. specified
 * 12 pts but (OT_BMSize & 0xffff) is 48, they may be 48 pixels high
 * and your template for BltTemplate() may be too small. Using non-
 * scalable fonts via bullet API instead of converting them to Amiga
 * bitmap fonts makes sense for font formats that can handle glyph
 * codes beyond 0xFF, e.g. BDF or PCF.
 */
NATIVE {OT_BMSize} CONST OT_BMSIZE = (OT_LEVEL2 OR $21)

/* OT_UnicodeRanges is an indirect pointer to an array of 8 longwords
 * (really 2*4 longwords) with flag bits describing whether at least
 * one glyph (first 4 longwords) or at least 80 percent of the defined
 * printable glyphs in Unicode 3.1 (second 4 longwords) are available
 * in that Unicode range or not when using the OT_SymbolSet of the
 * .otag file.  It is similar to ulUnicodeRangeX of the OS/2 table of
 * OpenType1.3 fonts.  The first longword contains bits 0-31,
 * the second 32-63, the third 64-95 and the fourth bits 96-127.
 * All longwords are big-endian (m68k).  The bits 57, 60 and 69
 * (Surrogates, Private Use and Specials) always mean "at least one
 * glyph" even in the second 4 longwords.
 *
 * Bit Range     Description
 * ---------------------------------------------------------------
 * 0   0000-007F Basic Latin
 * 1   0080-00FF Latin-1 Supplement
 * 2   0100-017F Latin Extended-A
 * 3   0180-024F Latin Extended-B
 * 4   0250-02AF IPA Extensions
 * 5   02B0-02FF Spacing Modifier Letters
 * 6   0300-036F Combining Diacritical Marks
 * 7   0370-03FF Greek
 * 8             Reserved for Unicode SubRanges
 * 9   0400-04FF Cyrillic
 * 10  0530-058F Armenian
 * 11  0590-05FF Hebrew
 * 12            Reserved for Unicode SubRanges
 * 13  0600-06FF Arabic
 * 14            Reserved for Unicode SubRanges
 * 15  0900-097F Devanagari
 * 16  0980-09FF Bengali
 * 17  0A00-0A7F Gurmukhi
 * 18  0A80-0AFF Gujarati
 * 19  0B00-0B7F Oriya
 * 20  0B80-0BFF Tamil
 * 21  0C00-0C7F Telugu
 * 22  0C80-0CFF Kannada
 * 23  0D00-0D7F Malayalam
 * 24  0E00-0E7F Thai
 * 25  0E80-0EFF Lao
 * 26  10A0-10FF Georgian
 * 27            Reserved for Unicode SubRanges
 * 28  1100-11FF Hangul Jamo
 * 29  1E00-1EFF Latin Extended Additional
 * 30  1F00-1FFF Greek Extended
 * 31  2000-206F General Punctuation
 * 32  2070-209F Superscripts and Subscripts
 * 33  20A0-20CF Currency Symbols
 * 34  20D0-20FF Combining Marks for Symbols
 * 35  2100-214F Letterlike Symbols
 * 36  2150-218F Number Forms
 * 37  2190-21FF Arrows
 * 38  2200-22FF Mathematical Operators
 * 39  2300-23FF Miscellaneous Technical
 * 40  2400-243F Control Pictures
 * 41  2440-245F Optical Character Recognition
 * 42  2460-24FF Enclosed Alphanumerics
 * 43  2500-257F Box Drawing
 * 44  2580-259F Block Elements
 * 45  25A0-25FF Geometric Shapes
 * 46  2600-26FF Miscellaneous Symbols
 * 47  2700-27BF Dingbats
 * 48  3000-303F CJK Symbols and Punctuation
 * 49  3040-309F Hiragana
 * 50  30A0-30FF Katakana
 * 51  3100-312F Bopomofo
 *     31A0-31BF Bopomofo Extended
 * 52  3130-318F Hangul Compatibility Jamo
 * 53  3190-319F Kanbun ("CJK Miscellaneous" in OpenType spec)
 * 54  3200-32FF Enclosed CJK Letters and Months
 * 55  3300-33FF CJK Compatibility
 * 56  AC00-D7A3 Hangul Syllables
 * 57            Surrogates: Bit 57 implies that there is at least one
 *               codepoint beyond the Basic Multilingual Plane
 *               that is supported by this font. Currently (Unicode 3.1)
 *               this ranges are defined:
 *                10300- 1032F Old Italic
 *                10330- 1034F Gothic
 *                10400- 1044F Deseret
 *                1D000- 1D0FF Byzantine Musical Symbols
 *                1D100- 1D1FF Musical Symbols
 *                1D400- 1D7FF Mathematical Alphanumeric Symbols
 *                20000- 2A6D6 CJK Unified Ideographs Extension B
 *                2F800- 2FA1F CJK Compatibility Ideographs Supplement
 *                E0000- E007F Tags
 *                F0000- FFFFD Private Use
 *               100000-10FFFD Private Use
 * 58            Reserved for Unicode SubRanges
 * 59  4E00-9FFF CJK Unified Ideographs
 *     2E80-2EFF CJK Radicals Supplement
 *     2F00-2FDF Kangxi Radicals
 *     2FF0-2FFF Ideographic Description Characters
 *     3400-4DB5 CJK Unified Ideographs Extension A
 * 60  E000-F8FF Private Use
 * 61  F900-FAFF CJK Compatibility Ideographs
 * 62  FB00-FB4F Alphabetic Presentation Forms
 * 63  FB50-FDFF Arabic Presentation Forms-A
 * 64  FE20-FE2F Combining Half Marks
 * 65  FE30-FE4F CJK Compatibility Forms
 * 66  FE50-FE6F Small Form Variants
 * 67  FE70-FEFE Arabic Presentation Forms-B
 * 68  FF00-FFEF Halfwidth and Fullwidth Forms
 * 69  FFF0-FFFD Specials
 * 70  0F00-0FFF Tibetan
 * 71  0700-074F Syriac
 * 72  0780-07BF Thaana
 * 73  0D80-0DFF Sinhala
 * 74  1000-109F Myanmar
 * 75  1200-137F Ethiopic
 * 76  13A0-13FF Cherokee
 * 77  1400-167F Unified Canadian Aboriginal Syllabics
 * 78  1680-169F Ogham
 * 79  16A0-16FF Runic
 * 80  1780-17FF Khmer
 * 81  1800-18AF Mongolian
 * 82  2800-28FF Braille Patterns
 * 83  A000-A48F Yi Syllables
 *     A490-A4CF Yi Radicals
 * 84-127        Reserved for Unicode SubRanges
 */
NATIVE {OT_UnicodeRanges} CONST OT_UNICODERANGES = (OT_LEVEL2 OR OT_INDIRECT OR $22)

NATIVE {UCR_BASIC_LATIN}                   CONST UCR_BASIC_LATIN                   = $1
NATIVE {UCR_LATIN1_SUPPLEMENT}             CONST UCR_LATIN1_SUPPLEMENT             = $2
NATIVE {UCR_LATIN_EXTENDED_A}              CONST UCR_LATIN_EXTENDED_A              = $4
NATIVE {UCR_LATIN_EXTENDED_B}              CONST UCR_LATIN_EXTENDED_B              = $8
NATIVE {UCR_IPA_EXTENSIONS}                CONST UCR_IPA_EXTENSIONS                = $10
NATIVE {UCR_SPACING_MODIFIER}              CONST UCR_SPACING_MODIFIER              = $20
NATIVE {UCR_COMBINING_DIACRITICS}          CONST UCR_COMBINING_DIACRITICS          = $40
NATIVE {UCR_GREEK}                         CONST UCR_GREEK                         = $80
NATIVE {UCR_CYRILLIC}                      CONST UCR_CYRILLIC                      = $200
NATIVE {UCR_ARMENIAN}                      CONST UCR_ARMENIAN                      = $400
NATIVE {UCR_HEBREW}                        CONST UCR_HEBREW                        = $800
NATIVE {UCR_ARABIC}                        CONST UCR_ARABIC                        = $2000
NATIVE {UCR_DEVANAGARI}                    CONST UCR_DEVANAGARI                    = $8000
NATIVE {UCR_BENGALI}                       CONST UCR_BENGALI                       = $10000
NATIVE {UCR_GURMUKHI}                      CONST UCR_GURMUKHI                      = $20000
NATIVE {UCR_GUJARATI}                      CONST UCR_GUJARATI                      = $40000
NATIVE {UCR_ORIYA}                         CONST UCR_ORIYA                         = $80000
NATIVE {UCR_TAMIL}                         CONST UCR_TAMIL                         = $100000
NATIVE {UCR_TELUGU}                        CONST UCR_TELUGU                        = $200000
NATIVE {UCR_KANNADA}                       CONST UCR_KANNADA                       = $400000
NATIVE {UCR_MALAYALAM}                     CONST UCR_MALAYALAM                     = $800000
NATIVE {UCR_THAI}                          CONST UCR_THAI                          = $1000000
NATIVE {UCR_LAO}                           CONST UCR_LAO                           = $2000000
NATIVE {UCR_GEORGIAN}                      CONST UCR_GEORGIAN                      = $4000000
NATIVE {UCR_HANGUL_JAMO}                   CONST UCR_HANGUL_JAMO                   = $10000000
NATIVE {UCR_LATIN_EXTENDED_ADDITIONAL}     CONST UCR_LATIN_EXTENDED_ADDITIONAL     = $20000000
NATIVE {UCR_GREEK_EXTENDED}                CONST UCR_GREEK_EXTENDED                = $40000000
NATIVE {UCR_GENERAL_PUNCTUATION}           CONST UCR_GENERAL_PUNCTUATION           = $80000000
NATIVE {UCR_SUPERSCRIPTS_SUBSCRIPTS}       CONST UCR_SUPERSCRIPTS_SUBSCRIPTS       = $1
NATIVE {UCR_CURRENCY_SYMBOLS}              CONST UCR_CURRENCY_SYMBOLS              = $2
NATIVE {UCR_COMBINING_DIACRITICS_SYMB}     CONST UCR_COMBINING_DIACRITICS_SYMB     = $4
NATIVE {UCR_LETTERLIKE_SYMBOLS}            CONST UCR_LETTERLIKE_SYMBOLS            = $8
NATIVE {UCR_NUMBER_FORMS}                  CONST UCR_NUMBER_FORMS                  = $10
NATIVE {UCR_ARROWS}                        CONST UCR_ARROWS                        = $20
NATIVE {UCR_MATHEMATICAL_OPERATORS}        CONST UCR_MATHEMATICAL_OPERATORS        = $40
NATIVE {UCR_MISCELLANEOUS_TECHNICAL}       CONST UCR_MISCELLANEOUS_TECHNICAL       = $80
NATIVE {UCR_CONTROL_PICTURES}              CONST UCR_CONTROL_PICTURES              = $100
NATIVE {UCR_OCR}                           CONST UCR_OCR                           = $200
NATIVE {UCR_ENCLOSED_ALPHANUMERICS}        CONST UCR_ENCLOSED_ALPHANUMERICS        = $400
NATIVE {UCR_BOX_DRAWING}                   CONST UCR_BOX_DRAWING                   = $800
NATIVE {UCR_BLOCK_ELEMENTS}                CONST UCR_BLOCK_ELEMENTS                = $1000
NATIVE {UCR_GEOMETRIC_SHAPES}              CONST UCR_GEOMETRIC_SHAPES              = $2000
NATIVE {UCR_MISCELLANEOUS_SYMBOLS}         CONST UCR_MISCELLANEOUS_SYMBOLS         = $4000
NATIVE {UCR_DINGBATS}                      CONST UCR_DINGBATS                      = $8000
NATIVE {UCR_CJK_SYMBOLS}                   CONST UCR_CJK_SYMBOLS                   = $10000
NATIVE {UCR_HIRAGANA}                      CONST UCR_HIRAGANA                      = $20000
NATIVE {UCR_KATAKANA}                      CONST UCR_KATAKANA                      = $40000
NATIVE {UCR_BOPOMOFO}                      CONST UCR_BOPOMOFO                      = $80000
NATIVE {UCR_HANGUL_COMPATIBILITY_JAMO}     CONST UCR_HANGUL_COMPATIBILITY_JAMO     = $100000
NATIVE {UCR_CJK_MISC}                      CONST UCR_CJK_MISC                      = $200000
NATIVE {UCR_KANBUN}                        CONST UCR_KANBUN                        = UCR_CJK_MISC
NATIVE {UCR_ENCLOSED_CJK_LETTERS_MONTHS}   CONST UCR_ENCLOSED_CJK_LETTERS_MONTHS   = $400000
NATIVE {UCR_CJK_COMPATIBILITY}             CONST UCR_CJK_COMPATIBILITY             = $800000
NATIVE {UCR_HANGUL}                        CONST UCR_HANGUL                        = $1000000
NATIVE {UCR_SURROGATES}                    CONST UCR_SURROGATES                    = $2000000
NATIVE {UCR_CJK_UNIFIED_IDEOGRAPHS}        CONST UCR_CJK_UNIFIED_IDEOGRAPHS        = $8000000
NATIVE {UCR_PRIVATE_USE}                   CONST UCR_PRIVATE_USE                   = $10000000
NATIVE {UCR_CJK_COMPATIBILITY_IDEOGRAPHS}  CONST UCR_CJK_COMPATIBILITY_IDEOGRAPHS  = $20000000
NATIVE {UCR_ALPHABETIC_PRESENTATION_FORMS} CONST UCR_ALPHABETIC_PRESENTATION_FORMS = $40000000
NATIVE {UCR_ARABIC_PRESENTATIONS_A}        CONST UCR_ARABIC_PRESENTATIONS_A        = $80000000
NATIVE {UCR_COMBINING_HALF_MARKS}          CONST UCR_COMBINING_HALF_MARKS          = $1
NATIVE {UCR_CJK_COMPATIBILITY_FORMS}       CONST UCR_CJK_COMPATIBILITY_FORMS       = $2
NATIVE {UCR_SMALL_FORM_VARIANTS}           CONST UCR_SMALL_FORM_VARIANTS           = $4
NATIVE {UCR_ARABIC_PRESENTATIONS_B}        CONST UCR_ARABIC_PRESENTATIONS_B        = $8
NATIVE {UCR_HALFWIDTH_FULLWIDTH_FORMS}     CONST UCR_HALFWIDTH_FULLWIDTH_FORMS     = $10
NATIVE {UCR_SPECIALS}                      CONST UCR_SPECIALS                      = $20
NATIVE {UCR_TIBETAN}                       CONST UCR_TIBETAN                       = $40
NATIVE {UCR_SYRIAC}                        CONST UCR_SYRIAC                        = $80
NATIVE {UCR_THAANA}                        CONST UCR_THAANA                        = $100
NATIVE {UCR_SINHALA}                       CONST UCR_SINHALA                       = $200
NATIVE {UCR_MYANMAR}                       CONST UCR_MYANMAR                       = $400
NATIVE {UCR_ETHIOPIC}                      CONST UCR_ETHIOPIC                      = $800
NATIVE {UCR_CHEROKEE}                      CONST UCR_CHEROKEE                      = $1000
NATIVE {UCR_CANADIAN_ABORIGINAL_SYLLABICS} CONST UCR_CANADIAN_ABORIGINAL_SYLLABICS = $2000
NATIVE {UCR_OGHAM}                         CONST UCR_OGHAM                         = $4000
NATIVE {UCR_RUNIC}                         CONST UCR_RUNIC                         = $8000
NATIVE {UCR_KHMER}                         CONST UCR_KHMER                         = $10000
NATIVE {UCR_MONGOLIAN}                     CONST UCR_MONGOLIAN                     = $20000
NATIVE {UCR_BRAILLE}                       CONST UCR_BRAILLE                       = $40000
NATIVE {UCR_YI}                            CONST UCR_YI                            = $80000

/* OT_SpecCount is the count number of parameters specified here
 */
NATIVE {OT_SpecCount} CONST OT_SPECCOUNT = (OT_LEVEL1 OR $100)

/* Specs can be created as appropriate for the engine by ORing in the
 * parameter number (1 is first, 2 is second, ... up to 15th).
 * A spec tag is private to the font engine.
 */
NATIVE {OT_Spec} CONST OT_SPEC = (OT_LEVEL1 OR $100)

/* OT_Spec1 is the (first) parameter to the font engine to select
 * this particular typeface
 */
NATIVE {OT_Spec1} CONST OT_SPEC1 = (OT_LEVEL1 OR $101)


/********************************************************************/
/* GetDiskFontCtrl and SetDiskFontCtrl tags */

NATIVE {DFCTRL_BASE}         CONST DFCTRL_BASE         = (TAG_USER + $0B000000)

/*
 * X and Y DPI device default settings for the bullet library font generator.
 * Default is 72 dpi.
 */

NATIVE {DFCTRL_XDPI}         CONST DFCTRL_XDPI         = (DFCTRL_BASE + 1)
NATIVE {DFCTRL_YDPI}         CONST DFCTRL_YDPI         = (DFCTRL_BASE + 2)

/*
 * X and Y DPI dot size settings for the font generator.
 * Default is 100dpi.
 */

NATIVE {DFCTRL_XDOTP}        CONST DFCTRL_XDOTP        = (DFCTRL_BASE + 3)
NATIVE {DFCTRL_YDOTP}        CONST DFCTRL_YDOTP        = (DFCTRL_BASE + 4)

/*
 * AvailFonts cache enable flag. Either TRUE or FALSE.
 */

NATIVE {DFCTRL_CACHE}        CONST DFCTRL_CACHE        = (DFCTRL_BASE + 5)

/*
 * Availfonts font sorting flag. See below for available values.
 */

NATIVE {DFCTRL_SORTMODE}     CONST DFCTRL_SORTMODE     = (DFCTRL_BASE + 6)

/* No sorting: Default. */
NATIVE {DFCTRL_SORT_OFF}     CONST DFCTRL_SORT_OFF     = (0)

/* Ascending sort order, localized with default locale. */
NATIVE {DFCTRL_SORT_ASC}     CONST DFCTRL_SORT_ASC     = (1)

/* Descending sort order, localized with default locale. */
NATIVE {DFCTRL_SORT_DES}     CONST DFCTRL_SORT_DES     = (NOT 0)

/* Flush the cache? (BOOL) If TRUE, a cache flush is initiated. */
NATIVE {DFCTRL_CACHEFLUSH}   CONST DFCTRL_CACHEFLUSH   = (DFCTRL_BASE + 7)

/*
 * Default character set identifier (ULONG).
 */
NATIVE {DFCTRL_CHARSET}      CONST DFCTRL_CHARSET      = (DFCTRL_BASE + 8)

/*
 * Enable/disable font antialiasing (BOOL) (V50).
 * Generates AATextFonts instead of TextFonts from .otag
 * fonts, patches graphics.library/Text() to output
 * anti-aliased fonts on screens with a depth >= 16 bit
 * if possible. Experimental.
 */
NATIVE {DFCTRL_ANTIALIASING} CONST DFCTRL_ANTIALIASING = (DFCTRL_BASE + 9)

/********************************************************************/
/* ObtainCharsetInfo tags */

/* IANA CharSet number (ULONG).
 * The MIBenum value from file L:CharSets/character-sets
 * (http://www.iana.org/assignments/character-sets).
 *
 * The value space for MIBenum values has been divided into three
 * regions. The first region (3-999) consists of coded character sets
 * that have been standardized by some standard setting organization.
 * This region is intended for standards that do not have subset
 * implementations. The second region (1000-1999) is for the Unicode and
 * ISO/IEC 10646 coded character sets together with a specification of a
 * (set of) sub-repetoires that may occur.  The third region (>1999) is
 * intended for vendor specific coded character sets.
 *
 *         Assigned MIB enum Numbers
 *         -------------------------
 *         0-2       Reserved
 *         3-999     Set By Standards Organizations
 *         1000-1999 Unicode / 10646
 *         2000-2999 Vendor
 */
NATIVE {DFCS_NUMBER}     CONST DFCS_NUMBER     = (DFCTRL_BASE + 0)

/* Next IANA CharSet number (ULONG) for browsing charsets. The lowest
 * possible number to start from is 3.
 */
NATIVE {DFCS_NEXTNUMBER} CONST DFCS_NEXTNUMBER = (DFCTRL_BASE + 1)

/* IANA CharSet name (STRPTR)
 */
NATIVE {DFCS_NAME}       CONST DFCS_NAME       = (DFCTRL_BASE + 2)

/* IANA CharSet name for MIME (STRPTR)
 */
NATIVE {DFCS_MIMENAME}   CONST DFCS_MIMENAME   = (DFCTRL_BASE + 3)

/* Pointer to mapping table of 256 ULONGs from CharSet to Unicode (ULONG *)
 */
NATIVE {DFCS_MAPTABLE}   CONST DFCS_MAPTABLE   = (DFCTRL_BASE + 4)
