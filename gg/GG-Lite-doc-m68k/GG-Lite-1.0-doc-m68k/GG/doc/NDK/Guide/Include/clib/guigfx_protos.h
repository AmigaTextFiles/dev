@DATABASE "gg:doc/NDK/Guide/Include/clib/guigfx_protos.h"
@MASTER   "gg:os-include/clib/guigfx_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:46
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/guigfx_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/guigfx_protos.h" LINK File}

@ENDNODE
@NODE File "clib/guigfx_protos.h"
#ifndef CLIB_GUIGFX_H
#define CLIB_GUIGFX_H
/*
**      $VER: guigfx_protos.h v16.0 (23.5.99)
**
**      C prototype definitions
**
**      © TEK neoscientists
*/

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif


@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"MakePicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 25}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} width, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} height, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"MakePictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 20}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} width, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} height, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"LoadPicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 34}(@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} filename, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"LoadPictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 29}(@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} filename, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ReadPicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 43}(@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct ColorMap *cm, UWORD x, UWORD y, UWORD width, UWORD height, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ReadPictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 38}(@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct ColorMap *cm, UWORD x, UWORD y, UWORD width, UWORD height, struct TagItem *tags);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ClonePicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 52}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ClonePictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 47}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

void @{"DeletePicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 56}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic);

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddPicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 65}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddPictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 60}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddPalette" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 74}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} palette, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddPaletteA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 69}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} palette, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddPixelArray" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 83}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} width, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} height, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddPixelArrayA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 78}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} width, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} height, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

void @{"RemColorHandle" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 87}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} colorhandle);

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreatePenShareMap" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 96}(@{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreatePenShareMapA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 91}(@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);
void @{"DeletePenShareMap" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 100}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm);

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ObtainDrawHandle" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 109}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct ColorMap *cm, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"ObtainDrawHandleA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 104}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} psm, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct ColorMap *cm, struct TagItem *tags);

void @{"ReleaseDrawHandle" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 113}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle);


@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DrawPicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 122}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} x, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} y, ...);
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DrawPictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 117}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} x, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} y, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MapPalette" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 131}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} palette, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *pentab, ...);
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MapPaletteA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 126}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} palette, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *pentab, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MapPen" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 140}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} rgb, ...);
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MapPenA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 135}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} rgb, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *CreatePictureBitMap(APTR drawhandle, APTR pic, ...);
@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *CreatePictureBitMapA(APTR drawhandle, APTR pic, struct TagItem *tags);


@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DoPictureMethod" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 158}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} method, ...);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DoPictureMethodA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 153}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} method, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *arguments);

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetPictureAttrs" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 167}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, ...);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetPictureAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 162}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"LockPicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 176}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} mode, ...);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"LockPictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 171}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} mode, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *arguments);
void @{"UnLockPicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 180}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} mode);

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsPicture" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 189}(char *filename, ...);
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsPictureA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 184}(char *filename, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateDirectDrawHandle" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 198}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sw, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sh, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} dw, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} dh, ...);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateDirectDrawHandleA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 193}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} drawhandle, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sw, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sh, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} dw, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} dh, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);
void @{"DeleteDirectDrawHandle" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 202}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} ddh);
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DirectDrawTrueColor" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 211}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} ddh, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} x, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} y, ...);
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DirectDrawTrueColorA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 206}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} ddh, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} x, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} y, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CreatePictureMask" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 220}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} arraywidth, ...);
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CreatePictureMaskA" LINK "gg:doc/NDK/Guide/Include/inline/guigfx.h/File" 215}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pic, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *array, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} arraywidth, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags);

#endif
@ENDNODE
