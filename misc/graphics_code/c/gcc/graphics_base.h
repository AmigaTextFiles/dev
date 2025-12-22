#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef GRAPHICS_BASE_H
#define GRAPHICS_BASE_H

struct Screen_Store
{
    struct View *   View;
    struct ViewExtra * ViewExtra;
    struct MonSpec * MonSpec;
    struct BitMap * BitMap;
    APTR Screen;
    struct RasInfo * RasInfo;
    struct ViewPort * ViewPort;
    struct ViewPortExtra * ViewPortExtra;
    struct DimensionInfo * DimensionInfo;
    struct ColorMap * ColorMap;
    LONG    ColorTable;
    APTR    MaskPlane;
    LONG    Width;
    LONG    Height;
    LONG    Planes;
    struct RastPort * RastPort;
    struct UserCopperList * UserCopperList;
};

struct MaskPlane
{
    LONG    MP_PlaneSize;
    LONG    MP_MaskPlane;
    WORD    MP_Clip_X_Min;
    WORD    MP_Clip_Y_Min;
    WORD    MP_Clip_X_Max;
    WORD    MP_Clip_Y_Max;
    UWORD   MP_PointBuffer[100];
    UWORD   MP_PointBuffer2[100];
};

#endif
