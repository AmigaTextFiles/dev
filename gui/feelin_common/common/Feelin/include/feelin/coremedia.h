#ifndef FEELIN_COREMEDIA_H
#define FEELIN_COREMEDIA_H

/*
**  feelin/coremedia.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 01.00 (2005/08/20)

************************************************************************************************/

/************************************************************************************************
*** Generation **********************************************************************************
************************************************************************************************/

#define FC_BitMap                               "BitMap"
#define BitMapObject                            IFEELIN F_NewObj(FC_BitMap

#define FC_CorePNG                              "CorePNG"
#define CorePNGObject                           IFEELIN F_NewObj(FC_CorePNG

/************************************************************************************************
*** Types ***************************************************************************************
************************************************************************************************/

/*** BitMap ************************************************************************************/

typedef struct FeelinCorePicturePublic
{
    uint16                          Width;
    uint16                          Height;
    uint8                           Depth;

    uint8                           PixelSize;
    APTR                            PixelArray;
    uint16                          PixelArrayMod;

    bits8                           Flags;

    bits8                           ColorType;
    uint16                          ColorCount;
    uint32                         *ColorArray;
}
FCorePicturePublic;

#define FV_COLOR_TYPE_GREY                      (1 << 0)
#define FV_COLOR_TYPE_PALETTE                   (1 << 1)
#define FV_COLOR_TYPE_RGB                       (1 << 2)
#define FF_COLOR_TYPE_ALPHA                     (1 << 7)
#define FV_COLOR_TYPE_MASK                      0x0F
#define FV_COLOR_TYPE_GREY_ALPHA                (FF_COLOR_TYPE_ALPHA | FV_COLOR_TYPE_GREY)
#define FV_COLOR_TYPE_PALETTE_ALPHA             (FF_COLOR_TYPE_ALPHA | FV_COLOR_TYPE_PALETTE)
#define FV_COLOR_TYPE_RGB_ALPHA                 (FF_COLOR_TYPE_ALPHA | FV_COLOR_TYPE_RGB)

#define F_PIXEL_R(x)                            ((x & 0xFF000000) >> 24)
#define F_PIXEL_G(x)                            ((x & 0x00FF0000) >> 16)
#define F_PIXEL_B(x)                            ((x & 0x0000FF00) >>  8)
#define F_PIXEL_A(x)                            (x & 0x000000FF)

/************************************************************************************************
*** Messages ************************************************************************************
************************************************************************************************/

struct  FS_BitMap_Blit                          { struct RastPort *rp; uint32 SourceX, SourceY; FBox *TargetBox; uint32 Tag1; /*...*/ };
struct  FS_BitMap_Steal                         { FObject Source; };

/************************************************************************************************
*** Values **************************************************************************************
************************************************************************************************/

enum    {

        FV_CoreMedia_SourceType_None,
        FV_CoreMedia_SourceType_File,
        FV_CoreMedia_SourceType_Handle

        };

enum    {

        FV_BitMap_BlitMode_Copy,
        FV_BitMap_BlitMode_Tile,
        FV_BitMap_BlitMode_Scale,
        FV_BitMap_BlitMode_Frame

        };

enum    {

        FV_BitMap_ScaleFilter_Nearest,
        FV_BitMap_ScaleFilter_Bilinear,
        FV_BitMap_ScaleFilter_Average

        };

#endif
