/* $VER: Picasso96API_protos.h 53.7 (31.1.2010) */
OPT NATIVE
PUBLIC MODULE 'target/libraries/Picasso96'
MODULE 'target/exec/types', /*'target/libraries/Picasso96',*/ 'target/graphics/rastport', 'target/utility/hooks', 'target/exec'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/utility/tagitem', 'target/intuition/screens', 'target/graphics/gfx'
{
#include <proto/Picasso96API.h>
}
{
struct Library* P96Base = NULL;
struct P96IFace* IP96 = NULL;
}
NATIVE {CLIB_PICASSO96API_PROTOS_H} CONST
NATIVE {PROTO_PICASSO96API_H} CONST
NATIVE {INLINE4_PICASSO96API_H} CONST
NATIVE {PICASSO96API_INTERFACE_DEF_H} CONST

NATIVE {P96Base} DEF p96base:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IP96} DEF

PROC new()
	InitLibrary('Picasso96API.library', NATIVE {(struct Interface **) &IP96} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {p96OpenScreenTagList} PROC
PROC p96OpenScreenTagList(Tags:PTR TO tagitem) IS NATIVE {IP96->p96OpenScreenTagList(} Tags {)} ENDNATIVE !!PTR TO screen
->NATIVE {p96OpenScreenTags} PROC
->PROC p96OpenScreenTags(Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96OpenScreenTags(} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!PTR TO screen
->NATIVE {p96CloseScreen} PROC
PROC p96CloseScreen(screen:PTR TO screen) IS NATIVE {-IP96->p96CloseScreen(} screen {)} ENDNATIVE !!INT

->NATIVE {p96BestModeIDTagList} PROC
PROC p96BestModeIDTagList(Tags:PTR TO tagitem) IS NATIVE {IP96->p96BestModeIDTagList(} Tags {)} ENDNATIVE !!ULONG
->NATIVE {p96BestModeIDTags} PROC
->PROC p96BestModeIDTags(Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96BestModeIDTags(} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {p96RequestModeIDTagList} PROC
PROC p96RequestModeIDTagList(Tags:PTR TO tagitem) IS NATIVE {IP96->p96RequestModeIDTagList(} Tags {)} ENDNATIVE !!ULONG
->NATIVE {p96RequestModeIDTags} PROC
->PROC p96RequestModeIDTags(Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96RequestModeIDTags(} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!ULONG

->NATIVE {p96AllocModeListTagList} PROC
PROC p96AllocModeListTagList(Tags:PTR TO tagitem) IS NATIVE {IP96->p96AllocModeListTagList(} Tags {)} ENDNATIVE !!PTR TO lh
->NATIVE {p96AllocModeListTags} PROC
->PROC p96AllocModeListTags(Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96AllocModeListTags(} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!PTR TO lh
->NATIVE {p96FreeModeList} PROC
PROC p96FreeModeList(ModeList:PTR TO lh) IS NATIVE {IP96->p96FreeModeList(} ModeList {)} ENDNATIVE

->NATIVE {p96GetModeIDAttr} PROC
PROC p96GetModeIDAttr(DisplayID:ULONG, attribute_number:ULONG) IS NATIVE {IP96->p96GetModeIDAttr(} DisplayID {,} attribute_number {)} ENDNATIVE !!ULONG

->NATIVE {p96AllocBitMap} PROC
PROC p96AllocBitMap(SizeX:ULONG, SizeY:ULONG, Depth:ULONG, Flags:ULONG, friend_bitmap:PTR TO bitmap, rgbFormat:RGBFTYPE) IS NATIVE {IP96->p96AllocBitMap(} SizeX {,} SizeY {,} Depth {,} Flags {,} friend_bitmap {,} rgbFormat {)} ENDNATIVE !!PTR TO bitmap
->NATIVE {p96FreeBitMap} PROC
PROC p96FreeBitMap(bm:PTR TO bitmap) IS NATIVE {IP96->p96FreeBitMap(} bm {)} ENDNATIVE
->NATIVE {p96GetBitMapAttr} PROC
PROC p96GetBitMapAttr(bm:PTR TO bitmap, attribute_number:ULONG) IS NATIVE {IP96->p96GetBitMapAttr(} bm {,} attribute_number {)} ENDNATIVE !!ULONG

->NATIVE {p96LockBitMap} PROC
PROC p96LockBitMap(bm:PTR TO bitmap, buf:PTR TO UBYTE, size:ULONG) IS NATIVE {IP96->p96LockBitMap(} bm {,} buf {,} size {)} ENDNATIVE !!VALUE
->NATIVE {p96UnlockBitMap} PROC
PROC p96UnlockBitMap(bm:PTR TO bitmap, lock:VALUE) IS NATIVE {IP96->p96UnlockBitMap(} bm {,} lock {)} ENDNATIVE

->NATIVE {p96WritePixelArray} PROC
PROC p96WritePixelArray(ri:PTR TO p96RenderInfo, SrcX:UINT, SrcY:UINT, rp:PTR TO rastport, DestX:UINT, DestY:UINT, SizeX:UINT, SizeY:UINT) IS NATIVE {IP96->p96WritePixelArray(} ri {,} SrcX {,} SrcY {,} rp {,} DestX {,} DestY {,} SizeX {,} SizeY {)} ENDNATIVE
->NATIVE {p96ReadPixelArray} PROC
PROC p96ReadPixelArray(ri:PTR TO p96RenderInfo, DestX:UINT, DestY:UINT, rp:PTR TO rastport, SrcX:UINT, SrcY:UINT, SizeX:UINT, SizeY:UINT) IS NATIVE {IP96->p96ReadPixelArray(} ri {,} DestX {,} DestY {,} rp {,} SrcX {,} SrcY {,} SizeX {,} SizeY {)} ENDNATIVE

->NATIVE {p96WritePixel} PROC
PROC p96WritePixel(rp:PTR TO rastport, x:UINT, y:UINT, color:ULONG) IS NATIVE {IP96->p96WritePixel(} rp {,} x {,} y {,} color {)} ENDNATIVE !!ULONG
->NATIVE {p96ReadPixel} PROC
PROC p96ReadPixel(rp:PTR TO rastport, x:UINT, y:UINT) IS NATIVE {IP96->p96ReadPixel(} rp {,} x {,} y {)} ENDNATIVE !!ULONG

->NATIVE {p96RectFill} PROC
PROC p96RectFill(rp:PTR TO rastport, MinX:UINT, MinY:UINT, MaxX:UINT, MaxY:UINT, argb:ULONG) IS NATIVE {IP96->p96RectFill(} rp {,} MinX {,} MinY {,} MaxX {,} MaxY {,} argb {)} ENDNATIVE

->NATIVE {p96WriteTrueColorData} PROC
PROC p96WriteTrueColorData(tci:PTR TO p96TrueColorInfo, SrcX:UINT, SrcY:UINT, rp:PTR TO rastport, DestX:UINT, DestY:UINT, SizeX:UINT, SizeY:UINT) IS NATIVE {IP96->p96WriteTrueColorData(} tci {,} SrcX {,} SrcY {,} rp {,} DestX {,} DestY {,} SizeX {,} SizeY {)} ENDNATIVE
->NATIVE {p96ReadTrueColorData} PROC
PROC p96ReadTrueColorData(tci:PTR TO p96TrueColorInfo, DestX:UINT, DestY:UINT, rp:PTR TO rastport, SrcX:UINT, SrcY:UINT, SizeX:UINT, SizeY:UINT) IS NATIVE {IP96->p96ReadTrueColorData(} tci {,} DestX {,} DestY {,} rp {,} SrcX {,} SrcY {,} SizeX {,} SizeY {)} ENDNATIVE

->NATIVE {p96PIP_OpenTagList} PROC
PROC p96PIP_OpenTagList(Tags:PTR TO tagitem) IS NATIVE {IP96->p96PIP_OpenTagList(} Tags {)} ENDNATIVE !!PTR TO window
->NATIVE {p96PIP_OpenTags} PROC
->PROC p96PIP_OpenTags(Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96PIP_OpenTags(} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!PTR TO window
->NATIVE {p96PIP_Close} PROC
PROC p96PIP_Close(Window:PTR TO window) IS NATIVE {-IP96->p96PIP_Close(} Window {)} ENDNATIVE !!INT
->NATIVE {p96PIP_SetTagList} PROC
PROC p96PIP_SetTagList(Window:PTR TO window, Tags:PTR TO tagitem) IS NATIVE {IP96->p96PIP_SetTagList(} Window {,} Tags {)} ENDNATIVE !!VALUE
->NATIVE {p96PIP_SetTags} PROC
->PROC p96PIP_SetTags(Window:PTR TO window, Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96PIP_SetTags(} Window {,} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {p96PIP_GetTagList} PROC
PROC p96PIP_GetTagList(Window:PTR TO window, Tags:PTR TO tagitem) IS NATIVE {IP96->p96PIP_GetTagList(} Window {,} Tags {)} ENDNATIVE !!VALUE
->NATIVE {p96PIP_GetTags} PROC
->PROC p96PIP_GetTags(Window:PTR TO window, Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96PIP_GetTags(} Window {,} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!VALUE

/* obsolete, no longer needed (GetMsg and ReplyMsg will do from now on...)
struct IntuiMessage *p96PIP_GetIMsg(struct MsgPort *Port);
void p96PIP_ReplyIMsg(struct IntuiMessage *IntuiMessage);
*/

->NATIVE {p96GetRTGDataTagList} PROC
PROC p96GetRTGDataTagList(tags:PTR TO tagitem) IS NATIVE {IP96->p96GetRTGDataTagList(} tags {)} ENDNATIVE !!VALUE
->NATIVE {p96GetRTGDataTags} PROC
->PROC p96GetRTGDataTags(Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96GetRTGDataTags(} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {p96GetBoardDataTagList} PROC
PROC p96GetBoardDataTagList(board_number:ULONG, tags:PTR TO tagitem) IS NATIVE {IP96->p96GetBoardDataTagList(} board_number {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {p96GetBoardDataTags} PROC
->PROC p96GetBoardDataTags(board_number:ULONG, Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96GetBoardDataTags(} board_number {,} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!VALUE

->NATIVE {p96EncodeColor} PROC
PROC p96EncodeColor(rgbFormat:RGBFTYPE, Color:ULONG) IS NATIVE {IP96->p96EncodeColor(} rgbFormat {,} Color {)} ENDNATIVE !!ULONG

/* new, do not use!!! */
->NATIVE {p96WriteYUVPixels} PROC
/*
PROC p96WriteYUVPixels(pixels:APTR, SrcX:INT, SrcY:INT, bm:PTR TO bitmap, DestX:INT, DestY:INT, SizeX:INT, SizeY:INT, Tags:PTR TO tagitem) IS NATIVE {IP96->p96WriteYUVPixels(} pixels {,} SrcX {,} SrcY {,} bm {,} DestX {,} DestY {,} SizeX {,} SizeY {,} Tags {)} ENDNATIVE !!VALUE
*/
->NATIVE {p96WriteYUVPixelsTags} PROC
->PROC p96WriteYUVPixelsTags(pixels:APTR, SrcX:INT, SrcY:INT, bm:PTR TO bitmap, DestX:INT, DestY:INT, SizeX:INT, SizeY:INT, Tags:ULONG, Tags2=0:ULONG, ...) IS NATIVE {IP96->p96WriteYUVPixelsTags(} pixels {,} SrcX {,} SrcY {,} bm {,} DestX {,} DestY {,} SizeX {,} SizeY {,} Tags {,} Tags2 {,} ... {)} ENDNATIVE !!VALUE
