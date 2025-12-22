@DATABASE "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h"
@MASTER   "gg:os-include/datatypes/pictureclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:12
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "datatypes/pictureclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"datatypes/pictureclass.h" LINK File}


@{b}Structures@{ub}

@{"BitMapHeader" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 223}  @{"ColorRegister" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 243}  @{"pdtBlitPixelArray" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 173}  @{"pdtScale" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 200}


@{b}#defines@{ub}

@{"cmpByteRun1" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 219}              @{"cmpByteRun2" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 220}            @{"cmpNone" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 218}
@{"ID_BMHD" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 252}                  @{"ID_BODY" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 261}                @{"ID_CAMG" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 258}
@{"ID_CMAP" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 253}                  @{"ID_CRNG" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 254}                @{"ID_DEST" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 257}
@{"ID_GRAB" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 255}                  @{"ID_ILBM" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 251}                @{"ID_SPRT" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 256}
@{"mskHasAlpha" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 215}              @{"mskHasMask" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 212}             @{"mskHasTransparentColor" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 213}
@{"mskLasso" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 214}                 @{"mskNone" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 211}                @{"PBPAFMT_ARGB" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 188}
@{"PBPAFMT_GREY8" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 190}            @{"PBPAFMT_LUT8" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 189}           @{"PBPAFMT_RGB" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 186}
@{"PBPAFMT_RGBA" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 187}             @{"PDTA_Allocated" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 72}         @{"PDTA_AllocatedPens" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 126}
@{"PDTA_BitMap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 43}              @{"PDTA_BitMapHeader" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 37}      @{"PDTA_ClassBitMap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 99}
@{"PDTA_ColorRegisters" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 46}      @{"PDTA_ColorTable" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 61}        @{"PDTA_ColorTable2" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 69}
@{"PDTA_CRegs" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 49}               @{"PDTA_DestBitMap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 93}        @{"PDTA_DestMode" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 146}
@{"PDTA_DitherQuality" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 123}       @{"PDTA_FreeSourceBitMap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 87}  @{"PDTA_GetNumPictures" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 115}
@{"PDTA_Grab" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 90}                @{"PDTA_GRegs" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 56}             @{"PDTA_MaskPlane" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 152}
@{"PDTA_MaxDitherPens" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 118}       @{"PDTA_ModeID" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 34}            @{"PDTA_NumAlloc" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 78}
@{"PDTA_NumColors" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 75}           @{"PDTA_NumSparse" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 102}         @{"PDTA_Remap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 81}
@{"PDTA_ScaleQuality" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 129}        @{"PDTA_Screen" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 84}            @{"PDTA_SourceMode" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 143}
@{"PDTA_SparseTable" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 109}         @{"PDTA_UseFriendBitMap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 149}   @{"PDTA_WhichPicture" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 112}
@{"PDTANUMPICTURES_Unknown" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 136}  @{"PDTM_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 164}             @{"PDTM_READPIXELARRAY" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 170}
@{"PDTM_SCALE" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 197}               @{"PDTM_WRITEPIXELARRAY" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 167}   @{"PICTUREDTCLASS" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 27}
@{"PMODE_V42" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 157}                @{"PMODE_V43" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 158}              

@ENDNODE
@NODE File "datatypes/pictureclass.h"
#ifndef DATATYPES_PICTURECLASS_H
#define DATATYPES_PICTURECLASS_H
/*
**  $VER: pictureclass.h 45.1 (23.10.2000)
**  Includes Release 45.1
**
**  Interface definitions for DataType picture objects.
**
**  Copyright © 1992-2001 Amiga, Inc.
**      All Rights Reserved
*/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef DATATYPES_DATATYPESCLASS_H
#include <@{"datatypes/datatypesclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

/*****************************************************************************/

#define PICTUREDTCLASS "picture.datatype"

/*****************************************************************************/

/* Picture attributes */

/* Mode ID of the picture (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) */
#define PDTA_ModeID             (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 200)

/* Bitmap header information (@{"struct BitMapHeader" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 223} *) */
#define PDTA_BitMapHeader       (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 201)

/* Pointer to a class-allocated bitmap, that will end
 * up being freed by picture.class when @{"DisposeDTObject()" LINK "gg:doc/NDK/Guide/datatypes/DisposeDTObject"}
 * is called (@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *).
 */
#define PDTA_BitMap             (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 202)

/* Picture colour table (@{"struct ColorRegister" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 243} *) */
#define PDTA_ColorRegisters     (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 203)

/* Color table to use with @{"SetRGB32CM()" LINK "gg:doc/NDK/Guide/graphics/SetRGB32CM"} (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *) */
#define PDTA_CRegs              (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 204)

/* Color table; this table is initialized during the layout
 * process and will contain the colours the picture will use
 * after remapping. If no remapping takes place, these colours
 * will match those in the @{"PDTA_CRegs" LINK File 49} table (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *).
 */
#define PDTA_GRegs              (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 205)

/* Shared pen table; this table is initialized during the layout
 * process while the picture is being remapped (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *).
 */
#define PDTA_ColorTable         (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 206)

/* Shared pen table; in most places this table will be identical to
 * the @{"PDTA_ColorTable" LINK File 61} table. Some of the colours in this table might
 * match the original colour palette a little better than the colours
 * picked for the other table. The @{"picture.datatype" LINK "gg:doc/NDK/Guide/picture_dtc/picture.datatype"} uses the two tables
 * during remapping, alternating for each pixel (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *).
 */
#define PDTA_ColorTable2        (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 207)

/* OBSOLETE; DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE */
#define PDTA_Allocated          (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 208)

/* Number of colors used by the picture. (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) */
#define PDTA_NumColors          (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 209)

/* Number of colors allocated by the picture (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) */
#define PDTA_NumAlloc           (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 210)

/* Remap the picture (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}); defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} */
#define PDTA_Remap              (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 211)

/* Screen to remap to (@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *) */
#define PDTA_Screen             (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 212)

/* Free the source bitmap after remapping (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) */
#define PDTA_FreeSourceBitMap   (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 213)

/* Pointer to a Point structure */
#define PDTA_Grab               (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 214)

/* Pointer to the destination (remapped) bitmap */
#define PDTA_DestBitMap         (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 215)

/* Pointer to class-allocated bitmap, that will end
 * up being freed by the class after @{"DisposeDTObject()" LINK "gg:doc/NDK/Guide/datatypes/DisposeDTObject"}
 * is called (@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *)
 */
#define PDTA_ClassBitMap        (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 216)

/* Number of colors used for sparse remapping (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) */
#define PDTA_NumSparse          (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 217)

/* Pointer to a table of pen numbers indicating
 * which colors should be used when remapping the image.
 * This array must contain as many entries as there
 * are colors specified with @{"PDTA_NumSparse" LINK File 102} (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *).
 */
#define PDTA_SparseTable        (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 218)

/* Index number of the picture to load (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}). (V44) */
#define PDTA_WhichPicture       (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 219)

/* Get the number of pictures stored in the file (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *). (V44) */
#define PDTA_GetNumPictures     (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 220)

/* Maximum number of colours to use for dithering (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}). (V44) */
#define PDTA_MaxDitherPens      (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 221)

/* Quality of the dithering algorithm to be used during colour
 * quantization (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}). (V44)
 */
#define PDTA_DitherQuality      (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 222)

/* Pointer to the allocated pen table (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *). (V44) */
#define PDTA_AllocatedPens      (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 223)

/* Quality for scaling. (V45) */
#define PDTA_ScaleQuality       (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 224)

/*****************************************************************************/

/* When querying the number of pictures stored in a file, the
 * following value denotes "the number of pictures is unknown".
 */
#define PDTANUMPICTURES_Unknown (0)

/*****************************************************************************/

/* V43 extensions (attributes) */

/* Set the sub datatype interface mode (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}); see "Interface modes" below */
#define PDTA_SourceMode         (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 250)

/* Set the app datatype interface mode (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}); see "Interface modes" below */
#define PDTA_DestMode           (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 251)

/* Allocates the resulting bitmap as a friend bitmap (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) */
#define PDTA_UseFriendBitMap    (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 255)

/* @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} or mask plane for use with @{"BltMaskBitMapRastPort()" LINK "gg:doc/NDK/Guide/graphics/BltMaskBitMapRastPort"} (@{"PLANEPTR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 44}) */
#define PDTA_MaskPlane          (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 258)

/*****************************************************************************/

/* Interface modes */
#define PMODE_V42 (0)   /* Compatibility mode */
#define PMODE_V43 (1)   /* Extended mode */

/*****************************************************************************/

/* V43 extensions (methods) */

#define PDTM_Dummy (@{"DTM_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 282} + 0x60)

/* Transfer pixel data to the picture object in the specified format */
#define PDTM_WRITEPIXELARRAY (@{"PDTM_Dummy" LINK File 164} + 0)

/* Transfer pixel data from the picture object in the specified format */
#define PDTM_READPIXELARRAY (@{"PDTM_Dummy" LINK File 164} + 1)

/* @{"PDTM_WRITEPIXELARRAY" LINK File 167}, @{"PDTM_READPIXELARRAY" LINK File 170} */
struct pdtBlitPixelArray
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   MethodID;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    pbpa_PixelData;         /* The pixel data to transfer to/from */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pbpa_PixelFormat;       /* Format of the pixel data (see "Pixel Formats" below) */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pbpa_PixelArrayMod;     /* Number of bytes per row */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pbpa_Left;              /* Left edge of the rectangle to transfer pixels to/from */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pbpa_Top;               /* Top edge of the rectangle to transfer pixels to/from */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pbpa_Width;             /* Width of the rectangle to transfer pixels to/from */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pbpa_Height;            /* Height of the rectangle to transfer pixels to/from */
};

/* Pixel formats */
#define PBPAFMT_RGB     0       /* 3 bytes per pixel (red, green, blue) */
#define PBPAFMT_RGBA    1       /* 4 bytes per pixel (red, green, blue, alpha channel) */
#define PBPAFMT_ARGB    2       /* 4 bytes per pixel (alpha channel, red, green, blue) */
#define PBPAFMT_LUT8    3       /* 1 byte per pixel (using a separate colour map) */
#define PBPAFMT_GREY8   4       /* 1 byte per pixel (0==black, 255==white) */

/*****************************************************************************/

/* V45 extensions (methods) */

/* Scale pixel data to the specified size */
#define PDTM_SCALE (@{"PDTM_Dummy" LINK File 164} + 2)

/* @{"PDTM_SCALE" LINK File 197} */
struct pdtScale
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ps_NewWidth;      /* The new width the pixel data should have */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ps_NewHeight;     /* The new height the pixel data should have */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ps_Flags;         /* should be 0 for now */
};

/*****************************************************************************/

/* Masking techniques */
#define mskNone                 0
#define mskHasMask              1
#define mskHasTransparentColor  2
#define mskLasso                3
#define mskHasAlpha             4

/* Compression techniques */
#define cmpNone                 0
#define cmpByteRun1             1
#define cmpByteRun2             2       /* NOTE: unused (V44) */

/* Bitmap header (BMHD) structure */
struct BitMapHeader
{
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bmh_Width;              /* Width in pixels */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bmh_Height;             /* Height in pixels */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    bmh_Left;               /* Left position */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    bmh_Top;                /* Top position */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bmh_Depth;              /* Number of planes */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bmh_Masking;            /* Masking type */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bmh_Compression;        /* Compression type */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bmh_Pad;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bmh_Transparent;        /* Transparent color */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bmh_XAspect;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bmh_YAspect;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    bmh_PageWidth;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    bmh_PageHeight;
};

/*****************************************************************************/

/* Color register structure */
struct ColorRegister
{
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} red, green, blue;
};

/*****************************************************************************/

/* IFF types that may be in pictures */
#define ID_ILBM @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('I','L','B','M')
#define ID_BMHD @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('B','M','H','D')
#define ID_CMAP @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('C','M','A','P')
#define ID_CRNG @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('C','R','N','G')
#define ID_GRAB @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('G','R','A','B')
#define ID_SPRT @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('S','P','R','T')
#define ID_DEST @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('D','E','S','T')
#define ID_CAMG @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('C','A','M','G')

#ifndef ID_BODY
#define @{"ID_BODY" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 141} @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('B','O','D','Y')
#endif /* ID_BODY */

#endif  /* DATATYPES_PICTURECLASS_H */
@ENDNODE
