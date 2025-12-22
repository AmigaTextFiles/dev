@DATABASE "gg:doc/NDK/Guide/Include/render/render.h"
@MASTER   "gg:os-include/render/render.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:16
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "render/render.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"render/render.h" LINK File}


@{b}#defines@{ub}

@{"ADDH_CALLBACK_ABORTED" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 258}   @{"ADDH_NO_DATA" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 259}            @{"ADDH_NOT_ENOUGH_MEMORY" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 257}
@{"ADDH_SUCCESS" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 256}            @{"COLORMODE_CLUT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 137}          @{"COLORMODE_HAM6" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 139}
@{"COLORMODE_HAM8" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 138}          @{"COLORMODE_MASK" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 140}          @{"CONV_CALLBACK_ABORTED" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 305}
@{"CONV_NO_DATA" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 307}            @{"CONV_NOT_ENOUGH_MEMORY" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 306}  @{"CONV_SUCCESS" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 304}
@{"DITHERMODE_EDD" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 151}          @{"DITHERMODE_FS" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 149}           @{"DITHERMODE_NONE" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 148}
@{"DITHERMODE_RANDOM" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 150}       @{"EXTP_CALLBACK_ABORTED" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 242}   @{"EXTP_NO_DATA" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 243}
@{"EXTP_NOT_ENOUGH_MEMORY" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 241}  @{"EXTP_SUCCESS" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 240}            @{"HSTYPE_12BIT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 104}
@{"HSTYPE_12BIT_TURBO" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 109}      @{"HSTYPE_15BIT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 105}            @{"HSTYPE_15BIT_TURBO" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 110}
@{"HSTYPE_18BIT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 106}            @{"HSTYPE_18BIT_TURBO" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 111}      @{"HSTYPE_21BIT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 107}
@{"HSTYPE_24BIT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 108}            @{"PALFMT_PALETTE" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 56}          @{"PALFMT_RGB32" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 53}
@{"PALFMT_RGB4" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 55}             @{"PALFMT_RGB8" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 54}             @{"PALMODE_ASCENDING" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 87}
@{"PALMODE_BRIGHTNESS" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 67}      @{"PALMODE_NONE" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 64}            @{"PALMODE_POPULARITY" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 71}
@{"PALMODE_REPRESENTATION" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 75}  @{"PALMODE_SATURATION" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 83}      @{"PALMODE_SIGNIFICANCE" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 80}
@{"PIXFMT_0RGB_32" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 208}          @{"PIXFMT_BITMAP_CLUT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 217}      @{"PIXFMT_BITMAP_HAM6" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 219}
@{"PIXFMT_BITMAP_HAM8" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 218}      @{"PIXFMT_BITMAP_RGB" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 227}       @{"PIXFMT_CHUNKY_CLUT" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 207}
@{"PIXFMT_CHUNKY_HAM6" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 216}      @{"PIXFMT_CHUNKY_HAM8" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 215}      @{"PIXFMT_RGB_24" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 221}
@{"PIXFMTB_BITMAP" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 204}          @{"PIXFMTB_CHUNKY" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 203}          @{"PIXFMTB_RGB" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 205}
@{"REND_CALLBACK_ABORTED" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 274}   @{"REND_NO_DATA" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 276}            @{"REND_NO_VALID_PALETTE" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 275}
@{"REND_NOT_ENOUGH_MEMORY" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 273}  @{"REND_SUCCESS" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 272}            @{"RMHTYPE_POOL" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 32}
@{"RMHTYPE_PRIVATE" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 33}         @{"RMHTYPE_PUBLIC" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 34}          @{"RND_AlphaChannel" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 182}
@{"RND_AlphaChannel2" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 190}       @{"RND_AlphaModulo" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 183}         @{"RND_AlphaModulo2" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 191}
@{"RND_AlphaWidth" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 184}          @{"RND_AlphaWidth2" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 192}         @{"RND_BGColor" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 172}
@{"RND_BGPen" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 173}               @{"RND_ColorMode" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 127}           @{"RND_DestCoordinates" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 171}
@{"RND_DestWidth" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 162}           @{"RND_DitherAmount" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 129}        @{"RND_DitherMode" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 128}
@{"RND_EHBPalette" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 44}          @{"RND_FirstColor" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 45}          @{"RND_Histogram" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 97}
@{"RND_HSType" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 96}              @{"RND_Interleave" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 167}          @{"RND_LeftEdge" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 164}
@{"RND_LineHook" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 165}            @{"RND_MapEngine" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 166}           @{"RND_MaskFalse" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 186}
@{"RND_MaskRGB" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 185}             @{"RND_MaskTrue" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 187}            @{"RND_MemBlock" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 23}
@{"RND_MemFlags" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 25}            @{"RND_MemSize" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 24}             @{"RND_MemType" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 22}
@{"RND_NewPalette" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 46}          @{"RND_NumColors" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 118}           @{"RND_NumPixels" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 117}
@{"RND_OffsetColorZero" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 130}     @{"RND_Palette" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 168}             @{"RND_PaletteFormat" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 43}
@{"RND_PenTable" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 163}            @{"RND_PixelFormat" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 201}         @{"RND_ProgressHook" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 160}
@{"RND_RGBWeight" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 47}           @{"RND_RMHandler" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 26}           @{"RND_ScaleEngine" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 170}
@{"RND_SourceWidth" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 161}         @{"RND_SourceWidth2" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 189}        @{"RND_TAGBASE" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 14}
@{"RND_Weight" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 169}              @{"SORTP_NO_DATA" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 290}           @{"SORTP_NOT_ENOUGH_MEMORY" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 291}
@{"SORTP_NOT_IMPLEMENTED" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 292}   @{"SORTP_SUCCESS" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 289}           

@ENDNODE
@NODE File "render/render.h"
#ifndef RENDER_H
#define RENDER_H

/*
**    $VER: render.h v40 (19.12.2002)
**    render.library definitions
*/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif


#define RND_TAGBASE     (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x1000)

/************************************************************************

        memhandler

************************************************************************/

#define RND_MemType             (@{"RND_TAGBASE" LINK File 14}+1)         /* type of memhandler, see below */
#define RND_MemBlock    (@{"RND_TAGBASE" LINK File 14}+2)         /* ptr to block of memory */
#define RND_MemSize             (@{"RND_TAGBASE" LINK File 14}+3)         /* size of memblock [bytes] */
#define RND_MemFlags    (@{"RND_TAGBASE" LINK File 14}+18)        /* memflags (@{"exec/memory.h" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File"}) */
#define RND_RMHandler   (@{"RND_TAGBASE" LINK File 14}+12)        /* to pass a memhandler as an argument */

/*
 *      memhandler types
 */

#define RMHTYPE_POOL            1                               /* v39 exec dynamic pool */
#define RMHTYPE_PRIVATE         2                               /* private memory pool */
#define RMHTYPE_PUBLIC          3                               /* common public memory */


/************************************************************************

        palette

************************************************************************/

#define RND_PaletteFormat       (@{"RND_TAGBASE" LINK File 14}+19)        /* palette import/export format */
#define RND_EHBPalette          (@{"RND_TAGBASE" LINK File 14}+22)        /* tag to indicate a palette is EHB */
#define RND_FirstColor          (@{"RND_TAGBASE" LINK File 14}+23)        /* first palette entry */
#define RND_NewPalette          (@{"RND_TAGBASE" LINK File 14}+24)        /* dispose the old palette and load a new one */
#define RND_RGBWeight           (@{"RND_TAGBASE" LINK File 14}+11)        /* quantization factors */

/*
 *      palette format types
 */

#define PALFMT_RGB32            1                                       /* @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} red,green,blue */
#define PALFMT_RGB8                     2                                       /* @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} 0x00rrggbb */
#define PALFMT_RGB4                     3                                       /* @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} 0xrgb */
#define PALFMT_PALETTE          4                                       /* render.library palette */

/*
 *      palette sort mode types
 *      for the use with @{"SortPalette" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 227}()
 */

        /* no particular order */
#define PALMODE_NONE                    0x0000

        /* sort palette entries by brightness */
#define PALMODE_BRIGHTNESS              0x0001

        /* sort palette entries by the number of pixels that they represent.
           You must supply the @{"RND_Histogram" LINK File 97} taglist argument. */
#define PALMODE_POPULARITY              0x0002

        /* sort palette entries by the number of histogram entries that they
           represent. You must supply the @{"RND_Histogram" LINK File 97} taglist argument. */
#define PALMODE_REPRESENTATION  0x0003

        /* sort palette entries by their optical significance for the human
           eye. Implementation is unknown to you and may change.
           You must supply the @{"RND_Histogram" LINK File 97} taglist argument. */
#define PALMODE_SIGNIFICANCE    0x0004

        /* sort palette entries by color intensity */
#define PALMODE_SATURATION              0x0005

        /* By default, sort direction is descending, i.e. the precedence is
           more-to-less. Combine with this flag to invert the sort direction. */
#define PALMODE_ASCENDING               0x0008


/************************************************************************

        histogram related

************************************************************************/

#define RND_HSType                      (@{"RND_TAGBASE" LINK File 14}+4)         /* histogram type, see below */
#define RND_Histogram           (@{"RND_TAGBASE" LINK File 14}+9)         /* a histogram as an argument */

/*
 *      Histogram / Palette types
 *      to be specified with @{"RND_HSType" LINK File 96}
 */

#define HSTYPE_12BIT            4                                       /* 12bit dynamic histogram */
#define HSTYPE_15BIT            5                                       /* 15bit dynamic histogram */
#define HSTYPE_18BIT            6                                       /* 18bit dynamic histogram */
#define HSTYPE_21BIT            7                                       /* 21bit dynamic histogram */
#define HSTYPE_24BIT            8                                       /* 24bit dynamic histogram */
#define HSTYPE_12BIT_TURBO      20                                      /* 12bit tabular histogram */
#define HSTYPE_15BIT_TURBO      21                                      /* 15bit tabular histogram */
#define HSTYPE_18BIT_TURBO      22                                      /* 18bit tabular histogram */

/*
 *      tags that can be queried via @{"QueryHistogram" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 68}()
 */

#define RND_NumPixels           (@{"RND_TAGBASE" LINK File 14}+5)         /* # pixels in a histogram */
#define RND_NumColors           (@{"RND_TAGBASE" LINK File 14}+6)         /* # colors in a histogram */


/************************************************************************

        rendering and conversions

************************************************************************/

#define RND_ColorMode           (@{"RND_TAGBASE" LINK File 14}+7)         /* color mode, see below */
#define RND_DitherMode          (@{"RND_TAGBASE" LINK File 14}+8)         /* dither mode, see below */
#define RND_DitherAmount        (@{"RND_TAGBASE" LINK File 14}+26)        /* dither amount */
#define RND_OffsetColorZero     (@{"RND_TAGBASE" LINK File 14}+10)        /* first color index to be output */

/*
 *      color mode types
 *      to be specified with @{"RND_ColorMode" LINK File 127}
 */

#define COLORMODE_CLUT          0x0000                          /* normal palette lookup */
#define COLORMODE_HAM8          0x0001                          /* HAM8 mode */
#define COLORMODE_HAM6          0x0002                          /* HAM6 mode */
#define COLORMODE_MASK          0x0003                          /* mask to determine COLORMODE */


/*
 *      dither mode types
 *      to be specified with @{"RND_DitherMode" LINK File 128}
 */

#define DITHERMODE_NONE         0x0000                          /* no dither */
#define DITHERMODE_FS           0x0001                          /* Floyd-Steinberg dither */
#define DITHERMODE_RANDOM       0x0002                          /* random dither. amount required. */
#define DITHERMODE_EDD          0x0003                          /* EDD dither */


/************************************************************************

        miscellaneous

************************************************************************/

#define RND_ProgressHook        (@{"RND_TAGBASE" LINK File 14}+13)        /* progress callback hook */
#define RND_SourceWidth         (@{"RND_TAGBASE" LINK File 14}+14)        /* total input width [pixels] */
#define RND_DestWidth           (@{"RND_TAGBASE" LINK File 14}+15)        /* total output width [pixels] */
#define RND_PenTable            (@{"RND_TAGBASE" LINK File 14}+16)        /* ptr to a chunky conversion table */
#define RND_LeftEdge            (@{"RND_TAGBASE" LINK File 14}+17)        /* chunky data left edge [pixels] */
#define RND_LineHook            (@{"RND_TAGBASE" LINK File 14}+20)        /* line callback hook */
#define RND_MapEngine           (@{"RND_TAGBASE" LINK File 14}+27)        /* Mapping-Engine */
#define RND_Interleave          (@{"RND_TAGBASE" LINK File 14}+28)        /* Interleave */
#define RND_Palette                     (@{"RND_TAGBASE" LINK File 14}+29)        /* Palette */
#define RND_Weight                      (@{"RND_TAGBASE" LINK File 14}+30)        /* Weight factor */
#define RND_ScaleEngine         (@{"RND_TAGBASE" LINK File 14}+31)        /* ScaleEngine */
#define RND_DestCoordinates     (@{"RND_TAGBASE" LINK File 14}+42)        /* Texture coordinates */
#define RND_BGColor                     (@{"RND_TAGBASE" LINK File 14}+43)        /* backcolor for filling */
#define RND_BGPen                       (@{"RND_TAGBASE" LINK File 14}+44)        /* backpen for filling */


/************************************************************************

        alpha-channel and masking

************************************************************************/

#define RND_AlphaChannel        (@{"RND_TAGBASE" LINK File 14}+32)        /* custom alpha-channel */
#define RND_AlphaModulo         (@{"RND_TAGBASE" LINK File 14}+33)        /* bytes between alpha-channel pixels */
#define RND_AlphaWidth          (@{"RND_TAGBASE" LINK File 14}+34)        /* width of alpha-channel array */
#define RND_MaskRGB             (@{"RND_TAGBASE" LINK File 14}+35)        /* masking RGB for @{"CreateAlphaArray" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 338} */
#define RND_MaskFalse           (@{"RND_TAGBASE" LINK File 14}+36)        /* mask value for outside color range */
#define RND_MaskTrue            (@{"RND_TAGBASE" LINK File 14}+37)        /* mask value for inside color range */

#define RND_SourceWidth2        (@{"RND_TAGBASE" LINK File 14}+38)        /* total source width for 3channel operations */
#define RND_AlphaChannel2       (@{"RND_TAGBASE" LINK File 14}+39)        /* second custom alpha-channel */
#define RND_AlphaModulo2        (@{"RND_TAGBASE" LINK File 14}+40)        /* pixel modulo for a second alpha-channel */
#define RND_AlphaWidth2         (@{"RND_TAGBASE" LINK File 14}+41)        /* width of a second alpha-channel array */


/************************************************************************

        PixelFormat

************************************************************************/

#define RND_PixelFormat    (@{"RND_TAGBASE" LINK File 14}+25)             /* pixel format, see below */

#define PIXFMTB_CHUNKY          3
#define PIXFMTB_BITMAP          4
#define PIXFMTB_RGB                     5

#define PIXFMT_CHUNKY_CLUT      ((1L << @{"PIXFMTB_CHUNKY" LINK File 203}) + @{"COLORMODE_CLUT" LINK File 137})
#define PIXFMT_0RGB_32          ((1L << @{"PIXFMTB_RGB" LINK File 205}) + 0)

/*
 *      these types are currently not used by render.library, but
 *      some of them are applicable for guigfx.library functions:
 */

#define PIXFMT_CHUNKY_HAM8      ((1L << @{"PIXFMTB_CHUNKY" LINK File 203}) + @{"COLORMODE_HAM8" LINK File 138})
#define PIXFMT_CHUNKY_HAM6      ((1L << @{"PIXFMTB_CHUNKY" LINK File 203}) + @{"COLORMODE_HAM6" LINK File 139})
#define PIXFMT_BITMAP_CLUT      ((1L << @{"PIXFMTB_BITMAP" LINK File 204}) + @{"COLORMODE_CLUT" LINK File 137})
#define PIXFMT_BITMAP_HAM8      ((1L << @{"PIXFMTB_BITMAP" LINK File 204}) + @{"COLORMODE_HAM8" LINK File 138})
#define PIXFMT_BITMAP_HAM6      ((1L << @{"PIXFMTB_BITMAP" LINK File 204}) + @{"COLORMODE_HAM6" LINK File 139})

#define PIXFMT_RGB_24           ((1L << @{"PIXFMTB_RGB" LINK File 205}) + 1)

/*
 *      strictly internal:
 */

#define PIXFMT_BITMAP_RGB       ((1L << @{"PIXFMTB_BITMAP" LINK File 204}) + (1L << @{"PIXFMTB_RGB" LINK File 205}))


/************************************************************************

        @{"ExtractPalette" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 99} return codes

        You must at least check for @{"EXTP_SUCCESS" LINK File 240}.
        @{"EXTP_NO_DATA" LINK File 243} indicates that there were no colors
        in the histogram.

************************************************************************/

#define EXTP_SUCCESS                    0
#define EXTP_NOT_ENOUGH_MEMORY  1
#define EXTP_CALLBACK_ABORTED   2
#define EXTP_NO_DATA                    3


/************************************************************************

        @{"AddRGB" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 72}, @{"AddRGBImage" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 81} and @{"AddChunkyImage" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 90} return codes

        You must at least check for @{"ADDH_SUCCESS" LINK File 256}.
        If not delivered, the histogram might be
        inaccurate.

************************************************************************/

#define ADDH_SUCCESS                            0
#define ADDH_NOT_ENOUGH_MEMORY          1
#define ADDH_CALLBACK_ABORTED           2
#define ADDH_NO_DATA                            3


/************************************************************************

        Render return codes

        You must at least check for @{"REND_SUCCESS" LINK File 272}.
        If not delivered, the image has not been
        rendered completely.

************************************************************************/

#define REND_SUCCESS                            0
#define REND_NOT_ENOUGH_MEMORY          1
#define REND_CALLBACK_ABORTED           2
#define REND_NO_VALID_PALETTE           3
#define REND_NO_DATA                            3


/************************************************************************

        @{"SortPalette" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 227} return codes

        You must at least check for @{"SORTP_SUCCESS" LINK File 289}.
        @{"SORTP_NO_DATA" LINK File 290} indicates that there were data missing,
        e.g. you specified no histogram or the histogram was empty.

************************************************************************/

#define SORTP_SUCCESS                           0
#define SORTP_NO_DATA                           1
#define SORTP_NOT_ENOUGH_MEMORY         2
#define SORTP_NOT_IMPLEMENTED           3


/************************************************************************

        conversion return codes

        These return codes apply to conversion functions
        such as @{"Chunky2RGB" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 126} and @{"ConvertChunky" LINK "gg:doc/NDK/Guide/Include/inline/render.h/File" 166}.

************************************************************************/

#define CONV_SUCCESS                    0
#define CONV_CALLBACK_ABORTED   1
#define CONV_NOT_ENOUGH_MEMORY  2
#define CONV_NO_DATA                    3


/***********************************************************************/

#endif
@ENDNODE
