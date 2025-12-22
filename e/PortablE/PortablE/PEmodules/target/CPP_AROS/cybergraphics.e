/* Automatically generated from '/home/aros/ABIv0/Build/20110803/AROS/workbench/libs/cgfx/cybergraphics.conf' */
OPT NATIVE
PUBLIC MODULE 'target/cybergraphx/cybergraphics'
MODULE 'target/aros/libcall', 'target/utility/tagitem', 'target/utility/hooks', 'target/graphics/gfx', 'target/graphics/rastport', 'target/graphics/view', 'target/exec/types', 'target/aros/system', 'target/aros/preprocessor/variadic/cast2iptr'
MODULE 'target/exec/libraries', 'target/exec/lists'
{
#include <proto/cybergraphics.h>
}
{
struct Library* CyberGfxBase = NULL;
}
NATIVE {CLIB_CYBERGRAPHICS_PROTOS_H} CONST
NATIVE {PROTO_CYBERGRAPHICS_H} CONST
NATIVE {INLINE_CYBERGRAPHICS_H} CONST

NATIVE {CyberGfxBase} DEF cybergfxbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {IsCyberModeID} PROC
PROC IsCyberModeID(modeID:ULONG) IS NATIVE {-IsCyberModeID(} modeID {)} ENDNATIVE !!INT
NATIVE {BestCModeIDTagList} PROC
PROC BestCModeIDTagList(tags:ARRAY OF tagitem) IS NATIVE {BestCModeIDTagList(} tags {)} ENDNATIVE !!ULONG
NATIVE {AllocCModeListTagList} PROC
PROC AllocCModeListTagList(tags:ARRAY OF tagitem) IS NATIVE {AllocCModeListTagList(} tags {)} ENDNATIVE !!PTR TO lh
NATIVE {FreeCModeList} PROC
PROC FreeCModeList(modeList:PTR TO lh) IS NATIVE {FreeCModeList(} modeList {)} ENDNATIVE
NATIVE {ScalePixelArray} PROC
PROC ScalePixelArray(srcRect:APTR, SrcW:UINT, SrcH:UINT, SrcMod:UINT, RastPort:PTR TO rastport, DestX:UINT, DestY:UINT, DestW:UINT, DestH:UINT, SrcFormat:UBYTE) IS NATIVE {ScalePixelArray(} srcRect {,} SrcW {,} SrcH {,} SrcMod {,} RastPort {,} DestX {,} DestY {,} DestW {,} DestH {,} SrcFormat {)} ENDNATIVE !!VALUE
NATIVE {GetCyberMapAttr} PROC
PROC GetCyberMapAttr(bitMap:PTR TO bitmap, attribute:ULONG) IS NATIVE {GetCyberMapAttr(} bitMap {,} attribute {)} ENDNATIVE !!ULONG
NATIVE {GetCyberIDAttr} PROC
PROC GetCyberIDAttr(attribute:ULONG, DisplayModeID:ULONG) IS NATIVE {GetCyberIDAttr(} attribute {,} DisplayModeID {)} ENDNATIVE !!ULONG
NATIVE {ReadRGBPixel} PROC
PROC ReadRGBPixel(rp:PTR TO rastport, x:UINT, y:UINT) IS NATIVE {ReadRGBPixel(} rp {,} x {,} y {)} ENDNATIVE !!ULONG
NATIVE {WriteRGBPixel} PROC
PROC WriteRGBPixel(rp:PTR TO rastport, x:UINT, y:UINT, pixel:ULONG) IS NATIVE {WriteRGBPixel(} rp {,} x {,} y {,} pixel {)} ENDNATIVE !!VALUE
NATIVE {ReadPixelArray} PROC
PROC ReadPixelArray(dst:APTR, destx:UINT, desty:UINT, dstmod:UINT, rp:PTR TO rastport, srcx:UINT, srcy:UINT, width:UINT, height:UINT, dstformat:UBYTE) IS NATIVE {ReadPixelArray(} dst {,} destx {,} desty {,} dstmod {,} rp {,} srcx {,} srcy {,} width {,} height {,} dstformat {)} ENDNATIVE !!ULONG
NATIVE {WritePixelArray} PROC
PROC WritePixelArray(src:APTR, srcx:UINT, srcy:UINT, srcmod:UINT, rp:PTR TO rastport, destx:UINT, desty:UINT, width:UINT, height:UINT, srcformat:UBYTE) IS NATIVE {WritePixelArray(} src {,} srcx {,} srcy {,} srcmod {,} rp {,} destx {,} desty {,} width {,} height {,} srcformat {)} ENDNATIVE !!ULONG
NATIVE {MovePixelArray} PROC
PROC MovePixelArray(SrcX:UINT, SrcY:UINT, RastPort:PTR TO rastport, DstX:UINT, DstY:UINT, SizeX:UINT, SizeY:UINT) IS NATIVE {MovePixelArray(} SrcX {,} SrcY {,} RastPort {,} DstX {,} DstY {,} SizeX {,} SizeY {)} ENDNATIVE !!ULONG
NATIVE {InvertPixelArray} PROC
PROC InvertPixelArray(rp:PTR TO rastport, destx:UINT, desty:UINT, width:UINT, height:UINT) IS NATIVE {InvertPixelArray(} rp {,} destx {,} desty {,} width {,} height {)} ENDNATIVE !!ULONG
NATIVE {FillPixelArray} PROC
PROC FillPixelArray(rp:PTR TO rastport, destx:UINT, desty:UINT, width:UINT, height:UINT, pixel:ULONG) IS NATIVE {FillPixelArray(} rp {,} destx {,} desty {,} width {,} height {,} pixel {)} ENDNATIVE !!ULONG
NATIVE {DoCDrawMethodTagList} PROC
PROC DoCDrawMethodTagList(hook:PTR TO hook, rp:PTR TO rastport, tags:ARRAY OF tagitem) IS NATIVE {DoCDrawMethodTagList(} hook {,} rp {,} tags {)} ENDNATIVE
NATIVE {CVideoCtrlTagList} PROC
PROC CvideoCtrlTagList(vp:PTR TO viewport, tags:ARRAY OF tagitem) IS NATIVE {CVideoCtrlTagList(} vp {,} tags {)} ENDNATIVE
NATIVE {LockBitMapTagList} PROC
PROC LockBitMapTagList(bitmap:APTR, tags:ARRAY OF tagitem) IS NATIVE {LockBitMapTagList(} bitmap {,} tags {)} ENDNATIVE !!APTR
NATIVE {UnLockBitMap} PROC
PROC UnLockBitMap(Handle:APTR) IS NATIVE {UnLockBitMap(} Handle {)} ENDNATIVE
NATIVE {UnLockBitMapTagList} PROC
PROC UnLockBitMapTagList(Handle:APTR, Tags:ARRAY OF tagitem) IS NATIVE {UnLockBitMapTagList(} Handle {,} Tags {)} ENDNATIVE
NATIVE {ExtractColor} PROC
PROC ExtractColor(RastPort:PTR TO rastport, SingleMap:PTR TO bitmap, Colour:ULONG, sX:ULONG, sY:ULONG, Width:ULONG, Height:ULONG) IS NATIVE {ExtractColor(} RastPort {,} SingleMap {,} Colour {,} sX {,} sY {,} Width {,} Height {)} ENDNATIVE !!ULONG
NATIVE {WriteLUTPixelArray} PROC
PROC WriteLUTPixelArray(srcRect:APTR, SrcX:UINT, SrcY:UINT, SrcMod:UINT, rp:PTR TO rastport, cTable:APTR, DestX:UINT, DestY:UINT, SizeX:UINT, SizeY:UINT, cTabFormat:UBYTE) IS NATIVE {WriteLUTPixelArray(} srcRect {,} SrcX {,} SrcY {,} SrcMod {,} rp {,} cTable {,} DestX {,} DestY {,} SizeX {,} SizeY {,} cTabFormat {)} ENDNATIVE !!VALUE
NATIVE {WritePixelArrayAlpha} PROC
PROC WritePixelArrayAlpha(src:APTR, srcx:UINT, srcy:UINT, srcmod:UINT, rp:PTR TO rastport, destx:UINT, desty:UINT, width:UINT, height:UINT, globalalpha:ULONG) IS NATIVE {WritePixelArrayAlpha(} src {,} srcx {,} srcy {,} srcmod {,} rp {,} destx {,} desty {,} width {,} height {,} globalalpha {)} ENDNATIVE !!ULONG
NATIVE {BltTemplateAlpha} PROC
PROC BltTemplateAlpha(src:APTR, srcx:VALUE, srcmod:VALUE, rp:PTR TO rastport, destx:VALUE, desty:VALUE, width:VALUE, height:VALUE) IS NATIVE {BltTemplateAlpha(} src {,} srcx {,} srcmod {,} rp {,} destx {,} desty {,} width {,} height {)} ENDNATIVE
NATIVE {ProcessPixelArray} PROC
PROC ProcessPixelArray(rp:PTR TO rastport, destX:ULONG, destY:ULONG, sizeX:ULONG, sizeY:ULONG, operation:ULONG, value:VALUE, taglist:ARRAY OF tagitem) IS NATIVE {ProcessPixelArray(} rp {,} destX {,} destY {,} sizeX {,} sizeY {,} operation {,} value {,} taglist {)} ENDNATIVE
