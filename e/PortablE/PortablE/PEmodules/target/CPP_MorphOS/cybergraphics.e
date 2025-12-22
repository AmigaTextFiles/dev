OPT NATIVE
PUBLIC MODULE 'target/cybergraphx/cybergraphics'
MODULE 'target/utility/tagitem', 'target/utility/hooks', 'target/graphics/rastport', 'target/graphics/view'
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/exec/types', 'target/graphics/gfx'
{
#include <proto/cybergraphics.h>
}
{
struct Library* CyberGfxBase = NULL;
}
NATIVE {CLIB_CYBERGRAPHICS_H} CONST
NATIVE {PROTO_CYBERGRAPHICS_H} CONST

NATIVE {CYBERGRAPHICS_BASE_NAME} CONST

NATIVE {CyberGfxBase} DEF cybergfxbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {AllocCModeListTagList} PROC
PROC AllocCModeListTagList(param1:ARRAY OF tagitem) IS NATIVE {AllocCModeListTagList(} param1 {)} ENDNATIVE !!PTR TO lh
NATIVE {AllocCModeListTags} PROC
PROC AllocCModeListTags(param1:TAG, param12=0:ULONG, ...) IS NATIVE {AllocCModeListTags(} param1 {,} param12 {,} ... {)} ENDNATIVE !!PTR TO lh
NATIVE {BestCModeIDTagList} PROC
PROC BestCModeIDTagList(param1:ARRAY OF tagitem) IS NATIVE {BestCModeIDTagList(} param1 {)} ENDNATIVE !!ULONG
NATIVE {BestCModeIDTags} PROC
PROC BestCModeIDTags(param1:TAG, param12=0:ULONG, ...) IS NATIVE {BestCModeIDTags(} param1 {,} param12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {CModeRequestTagList} PROC
PROC CmodeRequestTagList(param1:APTR, param2:ARRAY OF tagitem) IS NATIVE {CModeRequestTagList(} param1 {,} param2 {)} ENDNATIVE !!ULONG
NATIVE {CModeRequestTags} PROC
PROC CmodeRequestTags(param1:APTR, param2:TAG, param22=0:ULONG, ...) IS NATIVE {CModeRequestTags(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {CVideoCtrlTagList} PROC
PROC CvideoCtrlTagList(param1:PTR TO viewport, param2:ARRAY OF tagitem) IS NATIVE {CVideoCtrlTagList(} param1 {,} param2 {)} ENDNATIVE
NATIVE {CVideoCtrlTags} PROC
PROC CvideoCtrlTags(param1:PTR TO viewport, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {CVideoCtrlTags(} param1 {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
NATIVE {DoCDrawMethodTagList} PROC
PROC DoCDrawMethodTagList(param1:PTR TO hook, param2:PTR TO rastport, param3:ARRAY OF tagitem) IS NATIVE {DoCDrawMethodTagList(} param1 {,} param2 {,} param3 {)} ENDNATIVE
NATIVE {DoCDrawMethodTags} PROC
PROC DoCDrawMethodTags(param1:PTR TO hook, param2:PTR TO rastport, param3:TAG, param32=0:ULONG, ...) IS NATIVE {DoCDrawMethodTags(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE
NATIVE {ExtractColor} PROC
PROC ExtractColor(param1:PTR TO rastport,param2:PTR TO bitmap,param3:ULONG,param4:ULONG,param5:ULONG,param6:ULONG,param7:ULONG) IS NATIVE {ExtractColor(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {)} ENDNATIVE !!ULONG
NATIVE {FillPixelArray} PROC
PROC FillPixelArray(param1:PTR TO rastport, param2:UINT, param3:UINT, param4:UINT, param5:UINT, param6:ULONG) IS NATIVE {FillPixelArray(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {)} ENDNATIVE !!ULONG
NATIVE {FreeCModeList} PROC
PROC FreeCModeList(param1:PTR TO lh) IS NATIVE {FreeCModeList(} param1 {)} ENDNATIVE
NATIVE {GetCyberIDAttr} PROC
PROC GetCyberIDAttr(param1:ULONG, param2:ULONG) IS NATIVE {GetCyberIDAttr(} param1 {,} param2 {)} ENDNATIVE !!ULONG
NATIVE {GetCyberMapAttr} PROC
PROC GetCyberMapAttr(param1:PTR TO bitmap, param2:ULONG) IS NATIVE {GetCyberMapAttr(} param1 {,} param2 {)} ENDNATIVE !!ULONG
NATIVE {InvertPixelArray} PROC
PROC InvertPixelArray(param1:PTR TO rastport, param2:UINT, param3:UINT, param4:UINT, param5:UINT) IS NATIVE {InvertPixelArray(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {)} ENDNATIVE !!ULONG
NATIVE {IsCyberModeID} PROC
PROC IsCyberModeID(param1:ULONG) IS NATIVE {-IsCyberModeID(} param1 {)} ENDNATIVE !!INT
NATIVE {LockBitMapTagList} PROC
PROC LockBitMapTagList(param1:APTR,param2:ARRAY OF tagitem) IS NATIVE {LockBitMapTagList(} param1 {,} param2 {)} ENDNATIVE !!APTR
NATIVE {LockBitMapTags} PROC
PROC LockBitMapTags(param1:APTR, param2:TAG, param22=0:ULONG, ...) IS NATIVE {LockBitMapTags(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!APTR
NATIVE {MovePixelArray} PROC
PROC MovePixelArray(param1:UINT, param2:UINT, param3:PTR TO rastport, param4:UINT, param5:UINT, param6:UINT, param7:UINT) IS NATIVE {MovePixelArray(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {)} ENDNATIVE !!ULONG
NATIVE {ReadPixelArray} PROC
PROC ReadPixelArray(dst:APTR, destx:UINT, desty:UINT, dstmod:UINT, rp:PTR TO rastport, srcx:UINT, srcy:UINT, width:UINT, height:UINT, dstformat:UBYTE) IS NATIVE {ReadPixelArray(} dst {,} destx {,} desty {,} dstmod {,} rp {,} srcx {,} srcy {,} width {,} height {,} dstformat {)} ENDNATIVE !!ULONG
NATIVE {ReadRGBPixel} PROC
PROC ReadRGBPixel(param1:PTR TO rastport, param2:UINT, param3:UINT) IS NATIVE {ReadRGBPixel(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
NATIVE {ScalePixelArray} PROC
PROC ScalePixelArray(param1:APTR,param2:UINT,param3:UINT,param4:UINT,param5:PTR TO rastport,param6:UINT, param7:UINT, param8:UINT,param9:UINT,SrcFormat:UBYTE) IS NATIVE {ScalePixelArray(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {,} param9 {,} SrcFormat {)} ENDNATIVE !!VALUE
NATIVE {UnLockBitMap} PROC
PROC UnLockBitMap(Handle:APTR) IS NATIVE {UnLockBitMap(} Handle {)} ENDNATIVE
NATIVE {WritePixelArray} PROC
PROC WritePixelArray(src:APTR, srcx:UINT, srcy:UINT, srcmod:UINT, rp:PTR TO rastport, destx:UINT, desty:UINT, width:UINT, height:UINT, srcformat:UBYTE) IS NATIVE {WritePixelArray(} src {,} srcx {,} srcy {,} srcmod {,} rp {,} destx {,} desty {,} width {,} height {,} srcformat {)} ENDNATIVE !!ULONG
NATIVE {WriteLUTPixelArray} PROC
PROC WriteLUTPixelArray(srcRect:APTR, SrcX:UINT, SrcY:UINT, SrcMod:UINT, rp:PTR TO rastport, cTable:APTR, DestX:UINT, DestY:UINT, SizeX:UINT, SizeY:UINT, cTabFormat:UBYTE) IS NATIVE {WriteLUTPixelArray(} srcRect {,} SrcX {,} SrcY {,} SrcMod {,} rp {,} cTable {,} DestX {,} DestY {,} SizeX {,} SizeY {,} cTabFormat {)} ENDNATIVE !!ULONG
NATIVE {WriteRGBPixel} PROC
PROC WriteRGBPixel(param1:PTR TO rastport, param2:UINT, param3:UINT, param4:ULONG) IS NATIVE {WriteRGBPixel(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!VALUE
NATIVE {UnLockBitMapTagList} PROC
PROC UnLockBitMapTagList(param1:APTR, param2:ARRAY OF tagitem) IS NATIVE {UnLockBitMapTagList(} param1 {,} param2 {)} ENDNATIVE
NATIVE {UnLockBitMapTags} PROC
PROC UnLockBitMapTags(param1:APTR, param2:TAG, param22=0:ULONG, ...) IS NATIVE {UnLockBitMapTags(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE

/*** V43 ***/

NATIVE {WritePixelArrayAlpha} PROC
PROC WritePixelArrayAlpha(param1:APTR, param2:UINT, param3:UINT, param4:UINT, param5:PTR TO rastport, param6:UINT, param7:UINT, param8:UINT, param9:UINT, a:ULONG) IS NATIVE {WritePixelArrayAlpha(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {,} param9 {,} a {)} ENDNATIVE !!ULONG
NATIVE {BltTemplateAlpha} PROC
PROC BltTemplateAlpha(param1:PTR TO UBYTE, param2:VALUE, param3:VALUE, param4:PTR TO rastport, param5:VALUE, param6:VALUE, param7:VALUE, param8:VALUE) IS NATIVE {BltTemplateAlpha(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {)} ENDNATIVE
NATIVE {ProcessPixelArray} PROC
PROC ProcessPixelArray(param1:PTR TO rastport,param2:ULONG,param3:ULONG,param4:ULONG,param5:ULONG,param6:ULONG,param7:VALUE,param8:ARRAY OF tagitem) IS NATIVE {ProcessPixelArray(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {)} ENDNATIVE

/*** V50 ***/

NATIVE {BltBitMapAlpha} PROC
PROC BltBitMapAlpha(param1:PTR TO bitmap, param2:INT, param3:INT, param4:PTR TO bitmap, param5:INT, param6:INT, param7:INT, param8:INT, param9:ARRAY OF tagitem) IS NATIVE {BltBitMapAlpha(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {,} param9 {)} ENDNATIVE !!ULONG
NATIVE {BltBitMapRastPortAlpha} PROC
PROC BltBitMapRastPortAlpha(param1:PTR TO bitmap, param2:INT, param3:INT, param4:PTR TO rastport, param5:INT, param6:INT, param7:INT, param8:INT, param9:ARRAY OF tagitem) IS NATIVE {BltBitMapRastPortAlpha(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {,} param9 {)} ENDNATIVE !!ULONG


NATIVE {ScalePixelArrayAlpha} PROC
PROC ScalePixelArrayAlpha(param1:APTR,param2:UINT,param3:UINT,param4:UINT,param5:PTR TO rastport,param6:UINT,param7:UINT,param8:UINT,param9:UINT,a:ULONG) IS NATIVE {ScalePixelArrayAlpha(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {,} param9 {,} a {)} ENDNATIVE !!VALUE
