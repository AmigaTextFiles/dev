#ifndef _INLINE_GRAPHICS_H
#define _INLINE_GRAPHICS_H

#ifndef CLIB_GRAPHICS_PROTOS_H
#define CLIB_GRAPHICS_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  GRAPHICS_GFX_H
#include <graphics/gfx.h>
#endif
#ifndef  GRAPHICS_DISPLAYINFO_H
#include <graphics/displayinfo.h>
#endif
#ifndef  GRAPHICS_GELS_H
#include <graphics/gels.h>
#endif
#ifndef  GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif
#ifndef  GRAPHICS_VIEW_H
#include <graphics/view.h>
#endif
#ifndef  GRAPHICS_COPPER_H
#include <graphics/copper.h>
#endif
#ifndef  GRAPHICS_CLIP_H
#include <graphics/clip.h>
#endif
#ifndef  GRAPHICS_REGIONS_H
#include <graphics/regions.h>
#endif
#ifndef  GRAPHICS_SPRITE_H
#include <graphics/sprite.h>
#endif
#ifndef  GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif
#ifndef  GRAPHICS_SCALE_H
#include <graphics/scale.h>
#endif
#ifndef  HARDWARE_BLIT_H
#include <hardware/blit.h>
#endif

#ifndef GRAPHICS_BASE_NAME
#define GRAPHICS_BASE_NAME GfxBase
#endif

#define BltBitMap(srcBitMap, xSrc, ySrc, destBitMap, xDest, yDest, xSize, ySize, minterm, mask, tempA) \
	LP11(0x1e, LONG, BltBitMap, const struct BitMap *, srcBitMap, a0, LONG, xSrc, d0, LONG, ySrc, d1, struct BitMap *, destBitMap, a1, LONG, xDest, d2, LONG, yDest, d3, LONG, xSize, d4, LONG, ySize, d5, ULONG, minterm, d6, ULONG, mask, d7, PLANEPTR, tempA, a2, \
	, GRAPHICS_BASE_NAME)

#define BltTemplate(source, xSrc, srcMod, destRP, xDest, yDest, xSize, ySize) \
	LP8NR(0x24, BltTemplate, const PLANEPTR, source, a0, LONG, xSrc, d0, LONG, srcMod, d1, struct RastPort *, destRP, a1, LONG, xDest, d2, LONG, yDest, d3, LONG, xSize, d4, LONG, ySize, d5, \
	, GRAPHICS_BASE_NAME)

#define ClearEOL(rp) \
	LP1NR(0x2a, ClearEOL, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define ClearScreen(rp) \
	LP1NR(0x30, ClearScreen, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define TextLength(rp, string, count) \
	LP3(0x36, WORD, TextLength, struct RastPort *, rp, a1, CONST_STRPTR, string, a0, ULONG, count, d0, \
	, GRAPHICS_BASE_NAME)

#define Text(rp, string, count) \
	LP3(0x3c, LONG, Text, struct RastPort *, rp, a1, CONST_STRPTR, string, a0, ULONG, count, d0, \
	, GRAPHICS_BASE_NAME)

#define SetFont(rp, textFont) \
	LP2(0x42, LONG, SetFont, struct RastPort *, rp, a1, const struct TextFont *, textFont, a0, \
	, GRAPHICS_BASE_NAME)

#define OpenFont(textAttr) \
	LP1(0x48, struct TextFont *, OpenFont, struct TextAttr *, textAttr, a0, \
	, GRAPHICS_BASE_NAME)

#define CloseFont(textFont) \
	LP1NR(0x4e, CloseFont, struct TextFont *, textFont, a1, \
	, GRAPHICS_BASE_NAME)

#define AskSoftStyle(rp) \
	LP1(0x54, ULONG, AskSoftStyle, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define SetSoftStyle(rp, style, enable) \
	LP3(0x5a, ULONG, SetSoftStyle, struct RastPort *, rp, a1, ULONG, style, d0, ULONG, enable, d1, \
	, GRAPHICS_BASE_NAME)

#define AddBob(bob, rp) \
	LP2NR(0x60, AddBob, struct Bob *, bob, a0, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define AddVSprite(vSprite, rp) \
	LP2NR(0x66, AddVSprite, struct VSprite *, vSprite, a0, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define DoCollision(rp) \
	LP1NR(0x6c, DoCollision, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define DrawGList(rp, vp) \
	LP2NR(0x72, DrawGList, struct RastPort *, rp, a1, struct ViewPort *, vp, a0, \
	, GRAPHICS_BASE_NAME)

#define InitGels(head, tail, gelsInfo) \
	LP3NR(0x78, InitGels, struct VSprite *, head, a0, struct VSprite *, tail, a1, struct GelsInfo *, gelsInfo, a2, \
	, GRAPHICS_BASE_NAME)

#define InitMasks(vSprite) \
	LP1NR(0x7e, InitMasks, struct VSprite *, vSprite, a0, \
	, GRAPHICS_BASE_NAME)

#define RemIBob(bob, rp, vp) \
	LP3NR(0x84, RemIBob, struct Bob *, bob, a0, struct RastPort *, rp, a1, struct ViewPort *, vp, a2, \
	, GRAPHICS_BASE_NAME)

#define RemVSprite(vSprite) \
	LP1NR(0x8a, RemVSprite, struct VSprite *, vSprite, a0, \
	, GRAPHICS_BASE_NAME)

#define SetCollision(num, routine, gelsInfo) \
	LP3NRFP(0x90, SetCollision, ULONG, num, d0, __fpt, routine, a0, struct GelsInfo *, gelsInfo, a1, \
	, GRAPHICS_BASE_NAME, VOID (*__fpt)(struct VSprite *gelA, struct VSprite *gelB))

#define SortGList(rp) \
	LP1NR(0x96, SortGList, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define AddAnimOb(anOb, anKey, rp) \
	LP3NR(0x9c, AddAnimOb, struct AnimOb *, anOb, a0, struct AnimOb **, anKey, a1, struct RastPort *, rp, a2, \
	, GRAPHICS_BASE_NAME)

#define Animate(anKey, rp) \
	LP2NR(0xa2, Animate, struct AnimOb **, anKey, a0, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define GetGBuffers(anOb, rp, flag) \
	LP3(0xa8, BOOL, GetGBuffers, struct AnimOb *, anOb, a0, struct RastPort *, rp, a1, LONG, flag, d0, \
	, GRAPHICS_BASE_NAME)

#define InitGMasks(anOb) \
	LP1NR(0xae, InitGMasks, struct AnimOb *, anOb, a0, \
	, GRAPHICS_BASE_NAME)

#define DrawEllipse(rp, xCenter, yCenter, a, b) \
	LP5NR(0xb4, DrawEllipse, struct RastPort *, rp, a1, LONG, xCenter, d0, LONG, yCenter, d1, LONG, a, d2, LONG, b, d3, \
	, GRAPHICS_BASE_NAME)

#define AreaEllipse(rp, xCenter, yCenter, a, b) \
	LP5(0xba, LONG, AreaEllipse, struct RastPort *, rp, a1, LONG, xCenter, d0, LONG, yCenter, d1, LONG, a, d2, LONG, b, d3, \
	, GRAPHICS_BASE_NAME)

#define LoadRGB4(vp, colors, count) \
	LP3NR(0xc0, LoadRGB4, struct ViewPort *, vp, a0, const UWORD *, colors, a1, LONG, count, d0, \
	, GRAPHICS_BASE_NAME)

#define InitRastPort(rp) \
	LP1NR(0xc6, InitRastPort, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define InitVPort(vp) \
	LP1NR(0xcc, InitVPort, struct ViewPort *, vp, a0, \
	, GRAPHICS_BASE_NAME)

#define MrgCop(view) \
	LP1(0xd2, ULONG, MrgCop, struct View *, view, a1, \
	, GRAPHICS_BASE_NAME)

#define MakeVPort(view, vp) \
	LP2(0xd8, ULONG, MakeVPort, struct View *, view, a0, struct ViewPort *, vp, a1, \
	, GRAPHICS_BASE_NAME)

#define LoadView(view) \
	LP1NR(0xde, LoadView, struct View *, view, a1, \
	, GRAPHICS_BASE_NAME)

#define WaitBlit() \
	LP0NR(0xe4, WaitBlit, \
	, GRAPHICS_BASE_NAME)

#define SetRast(rp, pen) \
	LP2NR(0xea, SetRast, struct RastPort *, rp, a1, ULONG, pen, d0, \
	, GRAPHICS_BASE_NAME)

#define Move(rp, x, y) \
	LP3NR(0xf0, Move, struct RastPort *, rp, a1, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define Draw(rp, x, y) \
	LP3NR(0xf6, Draw, struct RastPort *, rp, a1, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define AreaMove(rp, x, y) \
	LP3(0xfc, LONG, AreaMove, struct RastPort *, rp, a1, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define AreaDraw(rp, x, y) \
	LP3(0x102, LONG, AreaDraw, struct RastPort *, rp, a1, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define AreaEnd(rp) \
	LP1(0x108, LONG, AreaEnd, struct RastPort *, rp, a1, \
	, GRAPHICS_BASE_NAME)

#define WaitTOF() \
	LP0NR(0x10e, WaitTOF, \
	, GRAPHICS_BASE_NAME)

#define QBlit(blit) \
	LP1NR(0x114, QBlit, struct bltnode *, blit, a1, \
	, GRAPHICS_BASE_NAME)

#define InitArea(areaInfo, vectorBuffer, maxVectors) \
	LP3NR(0x11a, InitArea, struct AreaInfo *, areaInfo, a0, APTR, vectorBuffer, a1, LONG, maxVectors, d0, \
	, GRAPHICS_BASE_NAME)

#define SetRGB4(vp, index, red, green, blue) \
	LP5NR(0x120, SetRGB4, struct ViewPort *, vp, a0, LONG, index, d0, ULONG, red, d1, ULONG, green, d2, ULONG, blue, d3, \
	, GRAPHICS_BASE_NAME)

#define QBSBlit(blit) \
	LP1NR(0x126, QBSBlit, struct bltnode *, blit, a1, \
	, GRAPHICS_BASE_NAME)

#define BltClear(memBlock, byteCount, flags) \
	LP3NR(0x12c, BltClear, PLANEPTR, memBlock, a1, ULONG, byteCount, d0, ULONG, flags, d1, \
	, GRAPHICS_BASE_NAME)

#define RectFill(rp, xMin, yMin, xMax, yMax) \
	LP5NR(0x132, RectFill, struct RastPort *, rp, a1, LONG, xMin, d0, LONG, yMin, d1, LONG, xMax, d2, LONG, yMax, d3, \
	, GRAPHICS_BASE_NAME)

#define BltPattern(rp, mask, xMin, yMin, xMax, yMax, maskBPR) \
	LP7NR(0x138, BltPattern, struct RastPort *, rp, a1, const PLANEPTR, mask, a0, LONG, xMin, d0, LONG, yMin, d1, LONG, xMax, d2, LONG, yMax, d3, ULONG, maskBPR, d4, \
	, GRAPHICS_BASE_NAME)

#define ReadPixel(rp, x, y) \
	LP3(0x13e, ULONG, ReadPixel, struct RastPort *, rp, a1, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define WritePixel(rp, x, y) \
	LP3(0x144, LONG, WritePixel, struct RastPort *, rp, a1, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define Flood(rp, mode, x, y) \
	LP4(0x14a, BOOL, Flood, struct RastPort *, rp, a1, ULONG, mode, d2, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define PolyDraw(rp, count, polyTable) \
	LP3NR(0x150, PolyDraw, struct RastPort *, rp, a1, LONG, count, d0, const WORD *, polyTable, a0, \
	, GRAPHICS_BASE_NAME)

#define SetAPen(rp, pen) \
	LP2NR(0x156, SetAPen, struct RastPort *, rp, a1, ULONG, pen, d0, \
	, GRAPHICS_BASE_NAME)

#define SetBPen(rp, pen) \
	LP2NR(0x15c, SetBPen, struct RastPort *, rp, a1, ULONG, pen, d0, \
	, GRAPHICS_BASE_NAME)

#define SetDrMd(rp, drawMode) \
	LP2NR(0x162, SetDrMd, struct RastPort *, rp, a1, ULONG, drawMode, d0, \
	, GRAPHICS_BASE_NAME)

#define InitView(view) \
	LP1NR(0x168, InitView, struct View *, view, a1, \
	, GRAPHICS_BASE_NAME)

#define CBump(copList) \
	LP1NR(0x16e, CBump, struct UCopList *, copList, a1, \
	, GRAPHICS_BASE_NAME)

#define CMove(copList, destination, data) \
	LP3NR(0x174, CMove, struct UCopList *, copList, a1, APTR, destination, d0, LONG, data, d1, \
	, GRAPHICS_BASE_NAME)

#define CWait(copList, v, h) \
	LP3NR(0x17a, CWait, struct UCopList *, copList, a1, LONG, v, d0, LONG, h, d1, \
	, GRAPHICS_BASE_NAME)

#define VBeamPos() \
	LP0(0x180, LONG, VBeamPos, \
	, GRAPHICS_BASE_NAME)

#define InitBitMap(bitMap, depth, width, height) \
	LP4NR(0x186, InitBitMap, struct BitMap *, bitMap, a0, LONG, depth, d0, LONG, width, d1, LONG, height, d2, \
	, GRAPHICS_BASE_NAME)

#define ScrollRaster(rp, dx, dy, xMin, yMin, xMax, yMax) \
	LP7NR(0x18c, ScrollRaster, struct RastPort *, rp, a1, LONG, dx, d0, LONG, dy, d1, LONG, xMin, d2, LONG, yMin, d3, LONG, xMax, d4, LONG, yMax, d5, \
	, GRAPHICS_BASE_NAME)

#define WaitBOVP(vp) \
	LP1NR(0x192, WaitBOVP, struct ViewPort *, vp, a0, \
	, GRAPHICS_BASE_NAME)

#define GetSprite(sprite, num) \
	LP2(0x198, WORD, GetSprite, struct SimpleSprite *, sprite, a0, LONG, num, d0, \
	, GRAPHICS_BASE_NAME)

#define FreeSprite(num) \
	LP1NR(0x19e, FreeSprite, LONG, num, d0, \
	, GRAPHICS_BASE_NAME)

#define ChangeSprite(vp, sprite, newData) \
	LP3NR(0x1a4, ChangeSprite, struct ViewPort *, vp, a0, struct SimpleSprite *, sprite, a1, UWORD *, newData, a2, \
	, GRAPHICS_BASE_NAME)

#define MoveSprite(vp, sprite, x, y) \
	LP4NR(0x1aa, MoveSprite, struct ViewPort *, vp, a0, struct SimpleSprite *, sprite, a1, LONG, x, d0, LONG, y, d1, \
	, GRAPHICS_BASE_NAME)

#define LockLayerRom(layer) \
	LP1NRA5(0x1b0, LockLayerRom, struct Layer *, layer, d7, \
	, GRAPHICS_BASE_NAME)

#define UnlockLayerRom(layer) \
	LP1NRA5(0x1b6, UnlockLayerRom, struct Layer *, layer, d7, \
	, GRAPHICS_BASE_NAME)

#define SyncSBitMap(layer) \
	LP1NR(0x1bc, SyncSBitMap, struct Layer *, layer, a0, \
	, GRAPHICS_BASE_NAME)

#define CopySBitMap(layer) \
	LP1NR(0x1c2, CopySBitMap, struct Layer *, layer, a0, \
	, GRAPHICS_BASE_NAME)

#define OwnBlitter() \
	LP0NR(0x1c8, OwnBlitter, \
	, GRAPHICS_BASE_NAME)

#define DisownBlitter() \
	LP0NR(0x1ce, DisownBlitter, \
	, GRAPHICS_BASE_NAME)

#define InitTmpRas(tmpRas, buffer, size) \
	LP3(0x1d4, struct TmpRas *, InitTmpRas, struct TmpRas *, tmpRas, a0, PLANEPTR, buffer, a1, LONG, size, d0, \
	, GRAPHICS_BASE_NAME)

#define AskFont(rp, textAttr) \
	LP2NR(0x1da, AskFont, struct RastPort *, rp, a1, struct TextAttr *, textAttr, a0, \
	, GRAPHICS_BASE_NAME)

#define AddFont(textFont) \
	LP1NR(0x1e0, AddFont, struct TextFont *, textFont, a1, \
	, GRAPHICS_BASE_NAME)

#define RemFont(textFont) \
	LP1NR(0x1e6, RemFont, struct TextFont *, textFont, a1, \
	, GRAPHICS_BASE_NAME)

#define AllocRaster(width, height) \
	LP2(0x1ec, PLANEPTR, AllocRaster, ULONG, width, d0, ULONG, height, d1, \
	, GRAPHICS_BASE_NAME)

#define FreeRaster(p, width, height) \
	LP3NR(0x1f2, FreeRaster, PLANEPTR, p, a0, ULONG, width, d0, ULONG, height, d1, \
	, GRAPHICS_BASE_NAME)

#define AndRectRegion(region, rectangle) \
	LP2NR(0x1f8, AndRectRegion, struct Region *, region, a0, const struct Rectangle *, rectangle, a1, \
	, GRAPHICS_BASE_NAME)

#define OrRectRegion(region, rectangle) \
	LP2(0x1fe, BOOL, OrRectRegion, struct Region *, region, a0, const struct Rectangle *, rectangle, a1, \
	, GRAPHICS_BASE_NAME)

#define NewRegion() \
	LP0(0x204, struct Region *, NewRegion, \
	, GRAPHICS_BASE_NAME)

#define ClearRectRegion(region, rectangle) \
	LP2(0x20a, BOOL, ClearRectRegion, struct Region *, region, a0, const struct Rectangle *, rectangle, a1, \
	, GRAPHICS_BASE_NAME)

#define ClearRegion(region) \
	LP1NR(0x210, ClearRegion, struct Region *, region, a0, \
	, GRAPHICS_BASE_NAME)

#define DisposeRegion(region) \
	LP1NR(0x216, DisposeRegion, struct Region *, region, a0, \
	, GRAPHICS_BASE_NAME)

#define FreeVPortCopLists(vp) \
	LP1NR(0x21c, FreeVPortCopLists, struct ViewPort *, vp, a0, \
	, GRAPHICS_BASE_NAME)

#define FreeCopList(copList) \
	LP1NR(0x222, FreeCopList, struct CopList *, copList, a0, \
	, GRAPHICS_BASE_NAME)

#define ClipBlit(srcRP, xSrc, ySrc, destRP, xDest, yDest, xSize, ySize, minterm) \
	LP9NR(0x228, ClipBlit, struct RastPort *, srcRP, a0, LONG, xSrc, d0, LONG, ySrc, d1, struct RastPort *, destRP, a1, LONG, xDest, d2, LONG, yDest, d3, LONG, xSize, d4, LONG, ySize, d5, ULONG, minterm, d6, \
	, GRAPHICS_BASE_NAME)

#define XorRectRegion(region, rectangle) \
	LP2(0x22e, BOOL, XorRectRegion, struct Region *, region, a0, const struct Rectangle *, rectangle, a1, \
	, GRAPHICS_BASE_NAME)

#define FreeCprList(cprList) \
	LP1NR(0x234, FreeCprList, struct cprlist *, cprList, a0, \
	, GRAPHICS_BASE_NAME)

#define GetColorMap(entries) \
	LP1(0x23a, struct ColorMap *, GetColorMap, LONG, entries, d0, \
	, GRAPHICS_BASE_NAME)

#define FreeColorMap(colorMap) \
	LP1NR(0x240, FreeColorMap, struct ColorMap *, colorMap, a0, \
	, GRAPHICS_BASE_NAME)

#define GetRGB4(colorMap, entry) \
	LP2(0x246, ULONG, GetRGB4, struct ColorMap *, colorMap, a0, LONG, entry, d0, \
	, GRAPHICS_BASE_NAME)

#define ScrollVPort(vp) \
	LP1NR(0x24c, ScrollVPort, struct ViewPort *, vp, a0, \
	, GRAPHICS_BASE_NAME)

#define UCopperListInit(uCopList, n) \
	LP2(0x252, struct CopList *, UCopperListInit, struct UCopList *, uCopList, a0, LONG, n, d0, \
	, GRAPHICS_BASE_NAME)

#define FreeGBuffers(anOb, rp, flag) \
	LP3NR(0x258, FreeGBuffers, struct AnimOb *, anOb, a0, struct RastPort *, rp, a1, LONG, flag, d0, \
	, GRAPHICS_BASE_NAME)

#define BltBitMapRastPort(srcBitMap, xSrc, ySrc, destRP, xDest, yDest, xSize, ySize, minterm) \
	LP9NR(0x25e, BltBitMapRastPort, const struct BitMap *, srcBitMap, a0, LONG, xSrc, d0, LONG, ySrc, d1, struct RastPort *, destRP, a1, LONG, xDest, d2, LONG, yDest, d3, LONG, xSize, d4, LONG, ySize, d5, ULONG, minterm, d6, \
	, GRAPHICS_BASE_NAME)

#define OrRegionRegion(srcRegion, destRegion) \
	LP2(0x264, BOOL, OrRegionRegion, const struct Region *, srcRegion, a0, struct Region *, destRegion, a1, \
	, GRAPHICS_BASE_NAME)

#define XorRegionRegion(srcRegion, destRegion) \
	LP2(0x26a, BOOL, XorRegionRegion, const struct Region *, srcRegion, a0, struct Region *, destRegion, a1, \
	, GRAPHICS_BASE_NAME)

#define AndRegionRegion(srcRegion, destRegion) \
	LP2(0x270, BOOL, AndRegionRegion, const struct Region *, srcRegion, a0, struct Region *, destRegion, a1, \
	, GRAPHICS_BASE_NAME)

#define SetRGB4CM(colorMap, index, red, green, blue) \
	LP5NR(0x276, SetRGB4CM, struct ColorMap *, colorMap, a0, LONG, index, d0, ULONG, red, d1, ULONG, green, d2, ULONG, blue, d3, \
	, GRAPHICS_BASE_NAME)

#define BltMaskBitMapRastPort(srcBitMap, xSrc, ySrc, destRP, xDest, yDest, xSize, ySize, minterm, bltMask) \
	LP10NR(0x27c, BltMaskBitMapRastPort, const struct BitMap *, srcBitMap, a0, LONG, xSrc, d0, LONG, ySrc, d1, struct RastPort *, destRP, a1, LONG, xDest, d2, LONG, yDest, d3, LONG, xSize, d4, LONG, ySize, d5, ULONG, minterm, d6, const PLANEPTR, bltMask, a2, \
	, GRAPHICS_BASE_NAME)

#define AttemptLockLayerRom(layer) \
	LP1A5(0x28e, BOOL, AttemptLockLayerRom, struct Layer *, layer, d7, \
	, GRAPHICS_BASE_NAME)

#define GfxNew(gfxNodeType) \
	LP1(0x294, APTR, GfxNew, ULONG, gfxNodeType, d0, \
	, GRAPHICS_BASE_NAME)

#define GfxFree(gfxNodePtr) \
	LP1NR(0x29a, GfxFree, APTR, gfxNodePtr, a0, \
	, GRAPHICS_BASE_NAME)

#define GfxAssociate(associateNode, gfxNodePtr) \
	LP2NR(0x2a0, GfxAssociate, const APTR, associateNode, a0, APTR, gfxNodePtr, a1, \
	, GRAPHICS_BASE_NAME)

#define BitMapScale(bitScaleArgs) \
	LP1NR(0x2a6, BitMapScale, struct BitScaleArgs *, bitScaleArgs, a0, \
	, GRAPHICS_BASE_NAME)

#define ScalerDiv(factor, numerator, denominator) \
	LP3(0x2ac, UWORD, ScalerDiv, ULONG, factor, d0, ULONG, numerator, d1, ULONG, denominator, d2, \
	, GRAPHICS_BASE_NAME)

#define TextExtent(rp, string, count, textExtent) \
	LP4(0x2b2, WORD, TextExtent, struct RastPort *, rp, a1, CONST_STRPTR, string, a0, LONG, count, d0, struct TextExtent *, textExtent, a2, \
	, GRAPHICS_BASE_NAME)

#define TextFit(rp, string, strLen, textExtent, constrainingExtent, strDirection, constrainingBitWidth, constrainingBitHeight) \
	LP8(0x2b8, ULONG, TextFit, struct RastPort *, rp, a1, CONST_STRPTR, string, a0, ULONG, strLen, d0, const struct TextExtent *, textExtent, a2, const struct TextExtent *, constrainingExtent, a3, LONG, strDirection, d1, ULONG, constrainingBitWidth, d2, ULONG, constrainingBitHeight, d3, \
	, GRAPHICS_BASE_NAME)

#define GfxLookUp(associateNode) \
	LP1(0x2be, APTR, GfxLookUp, const APTR, associateNode, a0, \
	, GRAPHICS_BASE_NAME)

#define VideoControl(colorMap, tagarray) \
	LP2(0x2c4, BOOL, VideoControl, struct ColorMap *, colorMap, a0, struct TagItem *, tagarray, a1, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define VideoControlTags(colorMap, tags...) \
	({ULONG _tags[] = {tags}; VideoControl((colorMap), (struct TagItem *) _tags);})
#endif

#define OpenMonitor(monitorName, displayID) \
	LP2(0x2ca, struct MonitorSpec *, OpenMonitor, CONST_STRPTR, monitorName, a1, ULONG, displayID, d0, \
	, GRAPHICS_BASE_NAME)

#define CloseMonitor(monitorSpec) \
	LP1(0x2d0, BOOL, CloseMonitor, struct MonitorSpec *, monitorSpec, a0, \
	, GRAPHICS_BASE_NAME)

#define FindDisplayInfo(displayID) \
	LP1(0x2d6, DisplayInfoHandle, FindDisplayInfo, ULONG, displayID, d0, \
	, GRAPHICS_BASE_NAME)

#define NextDisplayInfo(displayID) \
	LP1(0x2dc, ULONG, NextDisplayInfo, ULONG, displayID, d0, \
	, GRAPHICS_BASE_NAME)

#define GetDisplayInfoData(handle, buf, size, tagID, displayID) \
	LP5(0x2f4, ULONG, GetDisplayInfoData, const DisplayInfoHandle, handle, a0, APTR, buf, a1, ULONG, size, d0, ULONG, tagID, d1, ULONG, displayID, d2, \
	, GRAPHICS_BASE_NAME)

#define FontExtent(font, fontExtent) \
	LP2NR(0x2fa, FontExtent, const struct TextFont *, font, a0, struct TextExtent *, fontExtent, a1, \
	, GRAPHICS_BASE_NAME)

#define ReadPixelLine8(rp, xstart, ystart, width, array, tempRP) \
	LP6(0x300, LONG, ReadPixelLine8, struct RastPort *, rp, a0, ULONG, xstart, d0, ULONG, ystart, d1, ULONG, width, d2, UBYTE *, array, a2, struct RastPort *, tempRP, a1, \
	, GRAPHICS_BASE_NAME)

#define WritePixelLine8(rp, xstart, ystart, width, array, tempRP) \
	LP6(0x306, LONG, WritePixelLine8, struct RastPort *, rp, a0, ULONG, xstart, d0, ULONG, ystart, d1, ULONG, width, d2, UBYTE *, array, a2, struct RastPort *, tempRP, a1, \
	, GRAPHICS_BASE_NAME)

#define ReadPixelArray8(rp, xstart, ystart, xstop, ystop, array, temprp) \
	LP7(0x30c, LONG, ReadPixelArray8, struct RastPort *, rp, a0, ULONG, xstart, d0, ULONG, ystart, d1, ULONG, xstop, d2, ULONG, ystop, d3, UBYTE *, array, a2, struct RastPort *, temprp, a1, \
	, GRAPHICS_BASE_NAME)

#define WritePixelArray8(rp, xstart, ystart, xstop, ystop, array, temprp) \
	LP7(0x312, LONG, WritePixelArray8, struct RastPort *, rp, a0, ULONG, xstart, d0, ULONG, ystart, d1, ULONG, xstop, d2, ULONG, ystop, d3, UBYTE *, array, a2, struct RastPort *, temprp, a1, \
	, GRAPHICS_BASE_NAME)

#define GetVPModeID(vp) \
	LP1(0x318, LONG, GetVPModeID, const struct ViewPort *, vp, a0, \
	, GRAPHICS_BASE_NAME)

#define ModeNotAvailable(modeID) \
	LP1(0x31e, LONG, ModeNotAvailable, ULONG, modeID, d0, \
	, GRAPHICS_BASE_NAME)

#define EraseRect(rp, xMin, yMin, xMax, yMax) \
	LP5NR(0x32a, EraseRect, struct RastPort *, rp, a1, LONG, xMin, d0, LONG, yMin, d1, LONG, xMax, d2, LONG, yMax, d3, \
	, GRAPHICS_BASE_NAME)

#define ExtendFont(font, fontTags) \
	LP2(0x330, ULONG, ExtendFont, struct TextFont *, font, a0, const struct TagItem *, fontTags, a1, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ExtendFontTags(font, tags...) \
	({ULONG _tags[] = {tags}; ExtendFont((font), (const struct TagItem *) _tags);})
#endif

#define StripFont(font) \
	LP1NR(0x336, StripFont, struct TextFont *, font, a0, \
	, GRAPHICS_BASE_NAME)

#define CalcIVG(v, vp) \
	LP2(0x33c, UWORD, CalcIVG, struct View *, v, a0, struct ViewPort *, vp, a1, \
	, GRAPHICS_BASE_NAME)

#define AttachPalExtra(cm, vp) \
	LP2(0x342, LONG, AttachPalExtra, struct ColorMap *, cm, a0, struct ViewPort *, vp, a1, \
	, GRAPHICS_BASE_NAME)

#define ObtainBestPenA(cm, r, g, b, tags) \
	LP5(0x348, LONG, ObtainBestPenA, struct ColorMap *, cm, a0, ULONG, r, d1, ULONG, g, d2, ULONG, b, d3, const struct TagItem *, tags, a1, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ObtainBestPen(cm, r, g, b, tags...) \
	({ULONG _tags[] = {tags}; ObtainBestPenA((cm), (r), (g), (b), (const struct TagItem *) _tags);})
#endif

#define SetRGB32(vp, n, r, g, b) \
	LP5NR(0x354, SetRGB32, struct ViewPort *, vp, a0, ULONG, n, d0, ULONG, r, d1, ULONG, g, d2, ULONG, b, d3, \
	, GRAPHICS_BASE_NAME)

#define GetAPen(rp) \
	LP1(0x35a, ULONG, GetAPen, struct RastPort *, rp, a0, \
	, GRAPHICS_BASE_NAME)

#define GetBPen(rp) \
	LP1(0x360, ULONG, GetBPen, struct RastPort *, rp, a0, \
	, GRAPHICS_BASE_NAME)

#define GetDrMd(rp) \
	LP1(0x366, ULONG, GetDrMd, struct RastPort *, rp, a0, \
	, GRAPHICS_BASE_NAME)

#define GetOutlinePen(rp) \
	LP1(0x36c, ULONG, GetOutlinePen, struct RastPort *, rp, a0, \
	, GRAPHICS_BASE_NAME)

#define LoadRGB32(vp, table) \
	LP2NR(0x372, LoadRGB32, struct ViewPort *, vp, a0, const ULONG *, table, a1, \
	, GRAPHICS_BASE_NAME)

#define SetChipRev(want) \
	LP1(0x378, ULONG, SetChipRev, ULONG, want, d0, \
	, GRAPHICS_BASE_NAME)

#define SetABPenDrMd(rp, apen, bpen, drawmode) \
	LP4NR(0x37e, SetABPenDrMd, struct RastPort *, rp, a1, ULONG, apen, d0, ULONG, bpen, d1, ULONG, drawmode, d2, \
	, GRAPHICS_BASE_NAME)

#define GetRGB32(cm, firstcolor, ncolors, table) \
	LP4NR(0x384, GetRGB32, const struct ColorMap *, cm, a0, ULONG, firstcolor, d0, ULONG, ncolors, d1, ULONG *, table, a1, \
	, GRAPHICS_BASE_NAME)

#define AllocBitMap(sizex, sizey, depth, flags, friend_bitmap) \
	LP5(0x396, struct BitMap *, AllocBitMap, ULONG, sizex, d0, ULONG, sizey, d1, ULONG, depth, d2, ULONG, flags, d3, const struct BitMap *, friend_bitmap, a0, \
	, GRAPHICS_BASE_NAME)

#define FreeBitMap(bm) \
	LP1NR(0x39c, FreeBitMap, struct BitMap *, bm, a0, \
	, GRAPHICS_BASE_NAME)

#define GetExtSpriteA(ss, tags) \
	LP2(0x3a2, LONG, GetExtSpriteA, struct ExtSprite *, ss, a2, const struct TagItem *, tags, a1, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetExtSprite(ss, tags...) \
	({ULONG _tags[] = {tags}; GetExtSpriteA((ss), (const struct TagItem *) _tags);})
#endif

#define CoerceMode(vp, monitorid, flags) \
	LP3(0x3a8, ULONG, CoerceMode, struct ViewPort *, vp, a0, ULONG, monitorid, d0, ULONG, flags, d1, \
	, GRAPHICS_BASE_NAME)

#define ChangeVPBitMap(vp, bm, db) \
	LP3NR(0x3ae, ChangeVPBitMap, struct ViewPort *, vp, a0, struct BitMap *, bm, a1, struct DBufInfo *, db, a2, \
	, GRAPHICS_BASE_NAME)

#define ReleasePen(cm, n) \
	LP2NR(0x3b4, ReleasePen, struct ColorMap *, cm, a0, ULONG, n, d0, \
	, GRAPHICS_BASE_NAME)

#define ObtainPen(cm, n, r, g, b, f) \
	LP6(0x3ba, ULONG, ObtainPen, struct ColorMap *, cm, a0, ULONG, n, d0, ULONG, r, d1, ULONG, g, d2, ULONG, b, d3, LONG, f, d4, \
	, GRAPHICS_BASE_NAME)

#define GetBitMapAttr(bm, attrnum) \
	LP2(0x3c0, ULONG, GetBitMapAttr, const struct BitMap *, bm, a0, ULONG, attrnum, d1, \
	, GRAPHICS_BASE_NAME)

#define AllocDBufInfo(vp) \
	LP1(0x3c6, struct DBufInfo *, AllocDBufInfo, struct ViewPort *, vp, a0, \
	, GRAPHICS_BASE_NAME)

#define FreeDBufInfo(dbi) \
	LP1NR(0x3cc, FreeDBufInfo, struct DBufInfo *, dbi, a1, \
	, GRAPHICS_BASE_NAME)

#define SetOutlinePen(rp, pen) \
	LP2(0x3d2, ULONG, SetOutlinePen, struct RastPort *, rp, a0, ULONG, pen, d0, \
	, GRAPHICS_BASE_NAME)

#define SetWriteMask(rp, msk) \
	LP2(0x3d8, ULONG, SetWriteMask, struct RastPort *, rp, a0, ULONG, msk, d0, \
	, GRAPHICS_BASE_NAME)

#define SetMaxPen(rp, maxpen) \
	LP2NR(0x3de, SetMaxPen, struct RastPort *, rp, a0, ULONG, maxpen, d0, \
	, GRAPHICS_BASE_NAME)

#define SetRGB32CM(cm, n, r, g, b) \
	LP5NR(0x3e4, SetRGB32CM, struct ColorMap *, cm, a0, ULONG, n, d0, ULONG, r, d1, ULONG, g, d2, ULONG, b, d3, \
	, GRAPHICS_BASE_NAME)

#define ScrollRasterBF(rp, dx, dy, xMin, yMin, xMax, yMax) \
	LP7NR(0x3ea, ScrollRasterBF, struct RastPort *, rp, a1, LONG, dx, d0, LONG, dy, d1, LONG, xMin, d2, LONG, yMin, d3, LONG, xMax, d4, LONG, yMax, d5, \
	, GRAPHICS_BASE_NAME)

#define FindColor(cm, r, g, b, maxcolor) \
	LP5(0x3f0, LONG, FindColor, struct ColorMap *, cm, a3, ULONG, r, d1, ULONG, g, d2, ULONG, b, d3, LONG, maxcolor, d4, \
	, GRAPHICS_BASE_NAME)

#define AllocSpriteDataA(bm, tags) \
	LP2(0x3fc, struct ExtSprite *, AllocSpriteDataA, const struct BitMap *, bm, a2, const struct TagItem *, tags, a1, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocSpriteData(bm, tags...) \
	({ULONG _tags[] = {tags}; AllocSpriteDataA((bm), (const struct TagItem *) _tags);})
#endif

#define ChangeExtSpriteA(vp, oldsprite, newsprite, tags) \
	LP4(0x402, LONG, ChangeExtSpriteA, struct ViewPort *, vp, a0, struct ExtSprite *, oldsprite, a1, struct ExtSprite *, newsprite, a2, const struct TagItem *, tags, a3, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ChangeExtSprite(vp, oldsprite, newsprite, tags...) \
	({ULONG _tags[] = {tags}; ChangeExtSpriteA((vp), (oldsprite), (newsprite), (const struct TagItem *) _tags);})
#endif

#define FreeSpriteData(sp) \
	LP1NR(0x408, FreeSpriteData, struct ExtSprite *, sp, a2, \
	, GRAPHICS_BASE_NAME)

#define SetRPAttrsA(rp, tags) \
	LP2NR(0x40e, SetRPAttrsA, struct RastPort *, rp, a0, const struct TagItem *, tags, a1, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetRPAttrs(rp, tags...) \
	({ULONG _tags[] = {tags}; SetRPAttrsA((rp), (const struct TagItem *) _tags);})
#endif

#define GetRPAttrsA(rp, tags) \
	LP2NR(0x414, GetRPAttrsA, const struct RastPort *, rp, a0, const struct TagItem *, tags, a1, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetRPAttrs(rp, tags...) \
	({ULONG _tags[] = {tags}; GetRPAttrsA((rp), (const struct TagItem *) _tags);})
#endif

#define BestModeIDA(tags) \
	LP1(0x41a, ULONG, BestModeIDA, const struct TagItem *, tags, a0, \
	, GRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define BestModeID(tags...) \
	({ULONG _tags[] = {tags}; BestModeIDA((const struct TagItem *) _tags);})
#endif

#define WriteChunkyPixels(rp, xstart, ystart, xstop, ystop, array, bytesperrow) \
	LP7NR(0x420, WriteChunkyPixels, struct RastPort *, rp, a0, ULONG, xstart, d0, ULONG, ystart, d1, ULONG, xstop, d2, ULONG, ystop, d3, const UBYTE *, array, a2, LONG, bytesperrow, d4, \
	, GRAPHICS_BASE_NAME)

#endif /*  _INLINE_GRAPHICS_H  */
