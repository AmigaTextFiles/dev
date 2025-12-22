OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/graphics/clip', 'target/graphics/collide', 'target/graphics/copper', 'target/graphics/displayinfo', 'target/graphics/gels', 'target/graphics/gfx', 'target/graphics/gfxbase', 'target/graphics/gfxmacros', 'target/graphics/gfxnodes', 'target/graphics/layers', 'target/graphics/layersext', 'target/graphics/modeid', 'target/graphics/monitor', 'target/graphics/rastport', 'target/graphics/regions', 'target/graphics/rpattr', 'target/graphics/scale', 'target/graphics/sprite', 'target/graphics/text', 'target/graphics/videocontrol', 'target/graphics/view'
MODULE 'target/aros/libcall', 'target/graphics/gfx', 'target/graphics/displayinfo', 'target/graphics/gels', 'target/graphics/rastport', 'target/graphics/view', 'target/graphics/copper', 'target/graphics/clip', 'target/graphics/regions', /*'target/graphics/scale',*/ 'target/graphics/sprite', 'target/graphics/text', 'target/hardware/blit', 'target/utility/tagitem'
MODULE 'target/aros/system', 'target/defines/graphics', 'target/exec', 'target/dos/dos'
{
#include <proto/graphics.h>
}
{
struct GfxBase* GfxBase = NULL;
}
NATIVE {CLIB_GRAPHICS_PROTOS_H} CONST
NATIVE {PROTO_GRAPHICS_H} CONST

NATIVE {GfxBase} DEF gfxbase:NATIVE {struct GfxBase*} PTR TO lib

->automatic opening of gfx library
PROC new()
	gfxbase := OpenLibrary('graphics.library', 39)
	IF gfxbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

->automatic closing of gfx library
PROC end()
	CloseLibrary(gfxbase)
ENDPROC


/*ULONG BestModeID(Tag, ...);*/
NATIVE {BltBitMap} PROC
PROC BltBitMap(srcBitMap:PTR TO bitmap, xSrc:VALUE, ySrc:VALUE, destBitMap:PTR TO bitmap, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG, mask:ULONG, tempA:PLANEPTR) IS NATIVE {BltBitMap(} srcBitMap {,} xSrc {,} ySrc {,} destBitMap {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {,} mask {,} tempA {)} ENDNATIVE !!VALUE
NATIVE {BltTemplate} PROC
PROC BltTemplate(source:PLANEPTR, xSrc:VALUE, srcMod:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE) IS NATIVE {BltTemplate(} source {,} xSrc {,} srcMod {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {)} ENDNATIVE
NATIVE {ClearEOL} PROC
PROC ClearEOL(rp:PTR TO rastport) IS NATIVE {ClearEOL(} rp {)} ENDNATIVE
NATIVE {ClearScreen} PROC
PROC ClearScreen(rp:PTR TO rastport) IS NATIVE {ClearScreen(} rp {)} ENDNATIVE
NATIVE {TextLength} PROC
PROC TextLength(rp:PTR TO rastport, string:/*STRPTR*/ ARRAY OF CHAR, count:ULONG) IS NATIVE {TextLength(} rp {,} string {,} count {)} ENDNATIVE !!INT
NATIVE {Text} PROC
PROC Text(rp:PTR TO rastport, string:/*STRPTR*/ ARRAY OF CHAR, count:ULONG) IS NATIVE {Text(} rp {,} string {,} count {)} ENDNATIVE
NATIVE {SetFont} PROC
PROC SetFont(rp:PTR TO rastport, textFont:PTR TO textfont) IS NATIVE {SetFont(} rp {,} textFont {)} ENDNATIVE
NATIVE {OpenFont} PROC
PROC OpenFont(textAttr:PTR TO textattr) IS NATIVE {OpenFont(} textAttr {)} ENDNATIVE !!PTR TO textfont
NATIVE {CloseFont} PROC
PROC CloseFont(textFont:PTR TO textfont) IS NATIVE {CloseFont(} textFont {)} ENDNATIVE
NATIVE {AskSoftStyle} PROC
PROC AskSoftStyle(rp:PTR TO rastport) IS NATIVE {AskSoftStyle(} rp {)} ENDNATIVE !!ULONG
NATIVE {SetSoftStyle} PROC
PROC SetSoftStyle(rp:PTR TO rastport, style:ULONG, enable:ULONG) IS NATIVE {SetSoftStyle(} rp {,} style {,} enable {)} ENDNATIVE !!ULONG
NATIVE {AddBob} PROC
PROC AddBob(bob:PTR TO bob, rp:PTR TO rastport) IS NATIVE {AddBob(} bob {,} rp {)} ENDNATIVE
NATIVE {AddVSprite} PROC
PROC AddVSprite(vs:PTR TO vs, rp:PTR TO rastport) IS NATIVE {AddVSprite(} vs {,} rp {)} ENDNATIVE
NATIVE {DoCollision} PROC
PROC DoCollision(rp:PTR TO rastport) IS NATIVE {DoCollision(} rp {)} ENDNATIVE
NATIVE {DrawGList} PROC
PROC DrawGList(rp:PTR TO rastport, vp:PTR TO viewport) IS NATIVE {DrawGList(} rp {,} vp {)} ENDNATIVE
NATIVE {InitGels} PROC
PROC InitGels(head:PTR TO vs, tail:PTR TO vs, ginfo:PTR TO gelsinfo) IS NATIVE {InitGels(} head {,} tail {,} ginfo {)} ENDNATIVE
NATIVE {InitMasks} PROC
PROC InitMasks(vs:PTR TO vs) IS NATIVE {InitMasks(} vs {)} ENDNATIVE
NATIVE {RemIBob} PROC
PROC RemIBob(bob:PTR TO bob, rp:PTR TO rastport, vp:PTR TO viewport) IS NATIVE {RemIBob(} bob {,} rp {,} vp {)} ENDNATIVE
NATIVE {RemVSprite} PROC
PROC RemVSprite(vs:PTR TO vs) IS NATIVE {RemVSprite(} vs {)} ENDNATIVE
NATIVE {SetCollision} PROC
PROC SetCollision(num:ULONG, routine:NATIVE {VOID_FUNC} PTR, ginfo:PTR TO gelsinfo) IS NATIVE {SetCollision(} num {,} routine {,} ginfo {)} ENDNATIVE
NATIVE {SortGList} PROC
PROC SortGList(rp:PTR TO rastport) IS NATIVE {SortGList(} rp {)} ENDNATIVE
NATIVE {AddAnimOb} PROC
PROC AddAnimOb(anOb:PTR TO ao, anKey:ARRAY OF PTR TO ao, rp:PTR TO rastport) IS NATIVE {AddAnimOb(} anOb {,} anKey {,} rp {)} ENDNATIVE
NATIVE {Animate} PROC
PROC Animate(anKey:ARRAY OF PTR TO ao, rp:PTR TO rastport) IS NATIVE {Animate(} anKey {,} rp {)} ENDNATIVE
NATIVE {GetGBuffers} PROC
PROC GetGBuffers(anOb:PTR TO ao, rp:PTR TO rastport, db:INT) IS NATIVE {-GetGBuffers(} anOb {,} rp {, -} db {)} ENDNATIVE !!INT
NATIVE {InitGMasks} PROC
PROC InitGMasks(anOb:PTR TO ao) IS NATIVE {InitGMasks(} anOb {)} ENDNATIVE
NATIVE {DrawEllipse} PROC
PROC DrawEllipse(rp:PTR TO rastport, xCenter:VALUE, yCenter:VALUE, a:VALUE, b:VALUE) IS NATIVE {DrawEllipse(} rp {,} xCenter {,} yCenter {,} a {,} b {)} ENDNATIVE
NATIVE {AreaEllipse} PROC
PROC AreaEllipse(rp:PTR TO rastport, cx:INT, cy:INT, a:INT, b:INT) IS NATIVE {AreaEllipse(} rp {,} cx {,} cy {,} a {,} b {)} ENDNATIVE !!ULONG
NATIVE {LoadRGB4} PROC
PROC LoadRGB4(vp:PTR TO viewport, colors:PTR TO UINT, count:VALUE) IS NATIVE {LoadRGB4(} vp {,} colors {,} count {)} ENDNATIVE
NATIVE {InitRastPort} PROC
PROC InitRastPort(rp:PTR TO rastport) IS NATIVE {-InitRastPort(} rp {)} ENDNATIVE !!INT
NATIVE {InitVPort} PROC
PROC InitVPort(vp:PTR TO viewport) IS NATIVE {InitVPort(} vp {)} ENDNATIVE
NATIVE {MrgCop} PROC
PROC MrgCop(view:PTR TO view) IS NATIVE {MrgCop(} view {)} ENDNATIVE !!ULONG
NATIVE {MakeVPort} PROC
PROC MakeVPort(view:PTR TO view, viewport:PTR TO viewport) IS NATIVE {MakeVPort(} view {,} viewport {)} ENDNATIVE !!ULONG
NATIVE {LoadView} PROC
PROC LoadView(view:PTR TO view) IS NATIVE {LoadView(} view {)} ENDNATIVE
NATIVE {WaitBlit} PROC
PROC WaitBlit() IS NATIVE {WaitBlit()} ENDNATIVE
NATIVE {SetRast} PROC
PROC SetRast(rp:PTR TO rastport, pen:ULONG) IS NATIVE {SetRast(} rp {,} pen {)} ENDNATIVE
NATIVE {Move} PROC
PROC Move(rp:PTR TO rastport, x:INT, y:INT) IS NATIVE {Move(} rp {,} x {,} y {)} ENDNATIVE
NATIVE {Draw} PROC
PROC Draw(rp:PTR TO rastport, x:VALUE, y:VALUE) IS NATIVE {Draw(} rp {,} x {,} y {)} ENDNATIVE
NATIVE {AreaMove} PROC
PROC AreaMove(rp:PTR TO rastport, x:INT, y:INT) IS NATIVE {AreaMove(} rp {,} x {,} y {)} ENDNATIVE !!ULONG
NATIVE {AreaDraw} PROC
PROC AreaDraw(rp:PTR TO rastport, x:INT, y:INT) IS NATIVE {AreaDraw(} rp {,} x {,} y {)} ENDNATIVE !!ULONG
NATIVE {AreaEnd} PROC
PROC AreaEnd(rp:PTR TO rastport) IS NATIVE {AreaEnd(} rp {)} ENDNATIVE !!VALUE
NATIVE {WaitTOF} PROC
PROC WaitTOF() IS NATIVE {WaitTOF()} ENDNATIVE
NATIVE {QBlit} PROC
PROC Qblit(bn:PTR TO bltnode) IS NATIVE {QBlit(} bn {)} ENDNATIVE
NATIVE {InitArea} PROC
PROC InitArea(areainfo:PTR TO areainfo, buffer:ARRAY, maxvectors:INT) IS NATIVE {InitArea(} areainfo {,} buffer {,} maxvectors {)} ENDNATIVE
NATIVE {SetRGB4} PROC
PROC SetRGB4(vp:PTR TO viewport, n:ULONG, r:ULONG, g:ULONG, b:ULONG) IS NATIVE {SetRGB4(} vp {,} n {,} r {,} g {,} b {)} ENDNATIVE
NATIVE {QBSBlit} PROC
PROC QbSBlit(bn:PTR TO bltnode) IS NATIVE {QBSBlit(} bn {)} ENDNATIVE
NATIVE {BltClear} PROC
PROC BltClear(memBlock:PTR, bytecount:ULONG, flags:ULONG) IS NATIVE {BltClear(} memBlock {,} bytecount {,} flags {)} ENDNATIVE
NATIVE {RectFill} PROC
PROC RectFill(rp:PTR TO rastport, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE) IS NATIVE {RectFill(} rp {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
NATIVE {BltPattern} PROC
PROC BltPattern(rp:PTR TO rastport, mask:PLANEPTR, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE, byteCnt:ULONG) IS NATIVE {BltPattern(} rp {,} mask {,} xMin {,} yMin {,} xMax {,} yMax {,} byteCnt {)} ENDNATIVE
NATIVE {ReadPixel} PROC
PROC ReadPixel(rp:PTR TO rastport, x:VALUE, y:VALUE) IS NATIVE {ReadPixel(} rp {,} x {,} y {)} ENDNATIVE !!VALUE
NATIVE {WritePixel} PROC
PROC WritePixel(rp:PTR TO rastport, x:VALUE, y:VALUE) IS NATIVE {WritePixel(} rp {,} x {,} y {)} ENDNATIVE !!VALUE
NATIVE {Flood} PROC
PROC Flood(rp:PTR TO rastport, mode:ULONG, x:VALUE, y:VALUE) IS NATIVE {-Flood(} rp {,} mode {,} x {,} y {)} ENDNATIVE !!INT
NATIVE {PolyDraw} PROC
PROC PolyDraw(rp:PTR TO rastport, count:VALUE, polyTable:ARRAY OF INT) IS NATIVE {PolyDraw(} rp {,} count {,} polyTable {)} ENDNATIVE
NATIVE {SetAPen} PROC
PROC SetAPen(rp:PTR TO rastport, pen:ULONG) IS NATIVE {SetAPen(} rp {,} pen {)} ENDNATIVE
NATIVE {SetBPen} PROC
PROC SetBPen(rp:PTR TO rastport, pen:ULONG) IS NATIVE {SetBPen(} rp {,} pen {)} ENDNATIVE
NATIVE {SetDrMd} PROC
PROC SetDrMd(rp:PTR TO rastport, drawMode:ULONG) IS NATIVE {SetDrMd(} rp {,} drawMode {)} ENDNATIVE
NATIVE {InitView} PROC
PROC InitView(view:PTR TO view) IS NATIVE {InitView(} view {)} ENDNATIVE
NATIVE {CBump} PROC
PROC Cbump(ucl:PTR TO ucoplist) IS NATIVE {CBump(} ucl {)} ENDNATIVE
NATIVE {CMove} PROC
PROC Cmove(ucl:PTR TO ucoplist, reg:PTR, value:INT) IS NATIVE {CMove(} ucl {,} reg {,} value {)} ENDNATIVE
NATIVE {CWait} PROC
PROC Cwait(ucl:PTR TO ucoplist, v:INT, h:INT) IS NATIVE {CWait(} ucl {,} v {,} h {)} ENDNATIVE
NATIVE {VBeamPos} PROC
PROC VbeamPos() IS NATIVE {VBeamPos()} ENDNATIVE !!VALUE
NATIVE {InitBitMap} PROC
PROC InitBitMap(bm:PTR TO bitmap, depth:BYTE, width:UINT, height:UINT) IS NATIVE {InitBitMap(} bm {,} depth {,} width {,} height {)} ENDNATIVE
NATIVE {ScrollRaster} PROC
PROC ScrollRaster(rp:PTR TO rastport, dx:VALUE, dy:VALUE, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE) IS NATIVE {ScrollRaster(} rp {,} dx {,} dy {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
NATIVE {WaitBOVP} PROC
PROC WaitBOVP(vp:PTR TO viewport) IS NATIVE {WaitBOVP(} vp {)} ENDNATIVE
NATIVE {GetSprite} PROC
PROC GetSprite(sprite:PTR TO simplesprite, pick:INT) IS NATIVE {GetSprite(} sprite {,} pick {)} ENDNATIVE !!INT
NATIVE {FreeSprite} PROC
PROC FreeSprite(pick:INT) IS NATIVE {FreeSprite(} pick {)} ENDNATIVE
NATIVE {ChangeSprite} PROC
PROC ChangeSprite(vp:PTR TO viewport, s:PTR TO simplesprite, newdata:PTR) IS NATIVE {ChangeSprite(} vp {,} s {,} newdata {)} ENDNATIVE
NATIVE {MoveSprite} PROC
PROC MoveSprite(vp:PTR TO viewport, sprite:PTR TO simplesprite, x:INT, y:INT) IS NATIVE {MoveSprite(} vp {,} sprite {,} x {,} y {)} ENDNATIVE
NATIVE {LockLayerRom} PROC
PROC LockLayerRom(l:PTR TO layer) IS NATIVE {LockLayerRom(} l {)} ENDNATIVE
NATIVE {UnlockLayerRom} PROC
PROC UnlockLayerRom(l:PTR TO layer) IS NATIVE {UnlockLayerRom(} l {)} ENDNATIVE
NATIVE {SyncSBitMap} PROC
PROC SyncSBitMap(l:PTR TO layer) IS NATIVE {SyncSBitMap(} l {)} ENDNATIVE
NATIVE {CopySBitMap} PROC
PROC CopySBitMap(l:PTR TO layer) IS NATIVE {CopySBitMap(} l {)} ENDNATIVE
NATIVE {OwnBlitter} PROC
PROC OwnBlitter() IS NATIVE {OwnBlitter()} ENDNATIVE
NATIVE {DisownBlitter} PROC
PROC DisownBlitter() IS NATIVE {DisownBlitter()} ENDNATIVE
NATIVE {InitTmpRas} PROC
PROC InitTmpRas(tmpras:PTR TO tmpras, buffer:PTR, size:ULONG) IS NATIVE {InitTmpRas(} tmpras {,} buffer {,} size {)} ENDNATIVE
NATIVE {AskFont} PROC
PROC AskFont(rp:PTR TO rastport, textAttr:PTR TO textattr) IS NATIVE {AskFont(} rp {,} textAttr {)} ENDNATIVE
NATIVE {AddFont} PROC
PROC AddFont(textFont:PTR TO textfont) IS NATIVE {AddFont(} textFont {)} ENDNATIVE
NATIVE {RemFont} PROC
PROC RemFont(textFont:PTR TO textfont) IS NATIVE {RemFont(} textFont {)} ENDNATIVE
NATIVE {AllocRaster} PROC
PROC AllocRaster(width:ULONG, height:ULONG) IS NATIVE {AllocRaster(} width {,} height {)} ENDNATIVE !!PLANEPTR
NATIVE {FreeRaster} PROC
PROC FreeRaster(p:PLANEPTR, width:ULONG, height:ULONG) IS NATIVE {FreeRaster(} p {,} width {,} height {)} ENDNATIVE
NATIVE {AndRectRegion} PROC
PROC AndRectRegion(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {AndRectRegion(} Reg {,} Rect {)} ENDNATIVE
NATIVE {OrRectRegion} PROC
PROC OrRectRegion(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {-OrRectRegion(} Reg {,} Rect {)} ENDNATIVE !!INT
NATIVE {NewRegion} PROC
PROC NewRegion() IS NATIVE {NewRegion()} ENDNATIVE !!PTR TO region
NATIVE {ClearRectRegion} PROC
PROC ClearRectRegion(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {-ClearRectRegion(} Reg {,} Rect {)} ENDNATIVE !!INT
NATIVE {ClearRegion} PROC
PROC ClearRegion(region:PTR TO region) IS NATIVE {ClearRegion(} region {)} ENDNATIVE
NATIVE {DisposeRegion} PROC
PROC DisposeRegion(region:PTR TO region) IS NATIVE {DisposeRegion(} region {)} ENDNATIVE
NATIVE {FreeVPortCopLists} PROC
PROC FreeVPortCopLists(vp:PTR TO viewport) IS NATIVE {FreeVPortCopLists(} vp {)} ENDNATIVE
NATIVE {FreeCopList} PROC
PROC FreeCopList(coplist:PTR TO coplist) IS NATIVE {FreeCopList(} coplist {)} ENDNATIVE
NATIVE {ClipBlit} PROC
PROC ClipBlit(srcRP:PTR TO rastport, xSrc:VALUE, ySrc:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG) IS NATIVE {ClipBlit(} srcRP {,} xSrc {,} ySrc {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {, (UBYTE)} minterm {)} ENDNATIVE
NATIVE {XorRectRegion} PROC
PROC XorRectRegion(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {-XorRectRegion(} Reg {,} Rect {)} ENDNATIVE !!INT
NATIVE {FreeCprList} PROC
PROC FreeCprList(cprList:PTR TO cprlist) IS NATIVE {FreeCprList(} cprList {)} ENDNATIVE
NATIVE {GetColorMap} PROC
PROC GetColorMap(entries:ULONG) IS NATIVE {GetColorMap(} entries {)} ENDNATIVE !!PTR TO colormap
NATIVE {FreeColorMap} PROC
PROC FreeColorMap(colormap:PTR TO colormap) IS NATIVE {FreeColorMap(} colormap {)} ENDNATIVE
NATIVE {GetRGB4} PROC
PROC GetRGB4(colormap:PTR TO colormap, entry:VALUE) IS NATIVE {GetRGB4(} colormap {,} entry {)} ENDNATIVE !!ULONG
NATIVE {ScrollVPort} PROC
PROC ScrollVPort(vp:PTR TO viewport) IS NATIVE {ScrollVPort(} vp {)} ENDNATIVE
NATIVE {UCopperListInit} PROC
PROC UcopperListInit(ucl:PTR TO ucoplist, n:INT) IS NATIVE {UCopperListInit(} ucl {,} n {)} ENDNATIVE !!PTR TO coplist
NATIVE {FreeGBuffers} PROC
PROC FreeGBuffers(anOb:PTR TO ao, rp:PTR TO rastport, db:INT) IS NATIVE {FreeGBuffers(} anOb {,} rp {, -} db {)} ENDNATIVE
NATIVE {BltBitMapRastPort} PROC
PROC BltBitMapRastPort(srcBitMap:PTR TO bitmap, xSrc:VALUE, ySrc:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG) IS NATIVE {BltBitMapRastPort(} srcBitMap {,} xSrc {,} ySrc {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {)} ENDNATIVE
NATIVE {OrRegionRegion} PROC
PROC OrRegionRegion(r1:PTR TO region, r2:PTR TO region) IS NATIVE {-OrRegionRegion(} r1 {,} r2 {)} ENDNATIVE !!INT
NATIVE {XorRegionRegion} PROC
PROC XorRegionRegion(r1:PTR TO region, r2:PTR TO region) IS NATIVE {-XorRegionRegion(} r1 {,} r2 {)} ENDNATIVE !!INT
NATIVE {AndRegionRegion} PROC
PROC AndRegionRegion(r1:PTR TO region, r2:PTR TO region) IS NATIVE {-AndRegionRegion(} r1 {,} r2 {)} ENDNATIVE !!INT
NATIVE {SetRGB4CM} PROC
PROC SetRGB4CM(cm:PTR TO colormap, n:INT, r:UBYTE, g:UBYTE, b:UBYTE) IS NATIVE {SetRGB4CM(} cm {,} n {,} r {,} g {,} b {)} ENDNATIVE
NATIVE {BltMaskBitMapRastPort} PROC
PROC BltMaskBitMapRastPort(srcBitMap:PTR TO bitmap, xSrc:VALUE, ySrc:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG, bltMask:PLANEPTR) IS NATIVE {BltMaskBitMapRastPort(} srcBitMap {,} xSrc {,} ySrc {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {,} bltMask {)} ENDNATIVE
NATIVE {AndRectRegionND} PROC
PROC AndRectRegionND(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {AndRectRegionND(} Reg {,} Rect {)} ENDNATIVE !!PTR TO region
NATIVE {AndRegionRegionND} PROC
PROC AndRegionRegionND(r1:PTR TO region, r2:PTR TO region) IS NATIVE {AndRegionRegionND(} r1 {,} r2 {)} ENDNATIVE !!PTR TO region
NATIVE {AttemptLockLayerRom} PROC
PROC AttemptLockLayerRom(l:PTR TO layer) IS NATIVE {-AttemptLockLayerRom(} l {)} ENDNATIVE !!INT
NATIVE {GfxNew} PROC
PROC GfxNew(node_type:ULONG) IS NATIVE {GfxNew(} node_type {)} ENDNATIVE !!PTR TO xln
NATIVE {GfxFree} PROC
PROC GfxFree(node:PTR TO xln) IS NATIVE {GfxFree(} node {)} ENDNATIVE
NATIVE {GfxAssociate} PROC
PROC GfxAssociate(pointer:PTR, node:PTR TO xln) IS NATIVE {GfxAssociate(} pointer {,} node {)} ENDNATIVE
NATIVE {BitMapScale} PROC
PROC BitMapScale(bitScaleArgs:PTR TO bitscaleargs) IS NATIVE {BitMapScale(} bitScaleArgs {)} ENDNATIVE
NATIVE {ScalerDiv} PROC
PROC ScalerDiv(factor:UINT, numerator:UINT, denominator:UINT) IS NATIVE {ScalerDiv(} factor {,} numerator {,} denominator {)} ENDNATIVE !!UINT
->NATIVE {TextExtent} PROC
PROC TextExtent(rp:PTR TO rastport, string:/*STRPTR*/ ARRAY OF CHAR, count:ULONG, textExtent:PTR TO textextent) IS NATIVE {TextExtent(} rp {,} string {,} count {,} textExtent {)} ENDNATIVE
NATIVE {TextFit} PROC
PROC TextFit(rp:PTR TO rastport, string:/*STRPTR*/ ARRAY OF CHAR, strLen:ULONG, textExtent:PTR TO textextent, constrainingExtent:PTR TO textextent, strDirection:VALUE, constrainingBitWidth:ULONG, constrainingBitHeight:ULONG) IS NATIVE {TextFit(} rp {,} string {,} strLen {,} textExtent {,} constrainingExtent {,} strDirection {,} constrainingBitWidth {,} constrainingBitHeight {)} ENDNATIVE !!ULONG
NATIVE {GfxLookUp} PROC
PROC GfxLookUp(pointer:PTR) IS NATIVE {GfxLookUp(} pointer {)} ENDNATIVE !!PTR TO xln
NATIVE {VideoControl} PROC
PROC VideoControl(cm:PTR TO colormap, tags:ARRAY OF tagitem) IS NATIVE {VideoControl(} cm {,} tags {)} ENDNATIVE !!ULONG
NATIVE {OpenMonitor} PROC
PROC OpenMonitor(monitor_name:/*STRPTR*/ ARRAY OF CHAR, display_id:ULONG) IS NATIVE {OpenMonitor(} monitor_name {,} display_id {)} ENDNATIVE !!PTR TO monitorspec
NATIVE {CloseMonitor} PROC
PROC CloseMonitor(monitor_spec:PTR TO monitorspec) IS NATIVE {CloseMonitor(} monitor_spec {)} ENDNATIVE !!VALUE
NATIVE {FindDisplayInfo} PROC
PROC FindDisplayInfo(id:ULONG) IS NATIVE {FindDisplayInfo(} id {)} ENDNATIVE !!DISPLAYINFOHANDLE
NATIVE {NextDisplayInfo} PROC
PROC NextDisplayInfo(last_ID:ULONG) IS NATIVE {NextDisplayInfo(} last_ID {)} ENDNATIVE !!ULONG
NATIVE {OrRectRegionND} PROC
PROC OrRectRegionND(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {OrRectRegionND(} Reg {,} Rect {)} ENDNATIVE !!PTR TO region
NATIVE {ClearRectRegionND} PROC
PROC ClearRectRegionND(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {ClearRectRegionND(} Reg {,} Rect {)} ENDNATIVE !!PTR TO region
NATIVE {OrRegionRegionND} PROC
PROC OrRegionRegionND(r1:PTR TO region, r2:PTR TO region) IS NATIVE {OrRegionRegionND(} r1 {,} r2 {)} ENDNATIVE !!PTR TO region
NATIVE {GetDisplayInfoData} PROC
PROC GetDisplayInfoData(handle:DISPLAYINFOHANDLE, buf:APTR /*really ARRAY OF UBYTE*/, size:ULONG, tagID:ULONG, id:ULONG) IS NATIVE {GetDisplayInfoData(} handle {, (UBYTE*)} buf {,} size {,} tagID {,} id {)} ENDNATIVE !!ULONG
NATIVE {FontExtent} PROC
PROC FontExtent(font:PTR TO textfont, fontExtent:PTR TO textextent) IS NATIVE {FontExtent(} font {,} fontExtent {)} ENDNATIVE
NATIVE {ReadPixelLine8} PROC
PROC ReadPixelLine8(rp:PTR TO rastport, xstart:VALUE, ystart:VALUE, width:ULONG, array:ARRAY OF UBYTE, tempRP:PTR TO rastport) IS NATIVE {ReadPixelLine8(} rp {,} xstart {,} ystart {,} width {,} array {,} tempRP {)} ENDNATIVE !!VALUE
NATIVE {WritePixelLine8} PROC
PROC WritePixelLine8(rp:PTR TO rastport, xstart:VALUE, ystart:VALUE, width:ULONG, array:ARRAY OF UBYTE, tempRP:PTR TO rastport) IS NATIVE {WritePixelLine8(} rp {,} xstart {,} ystart {,} width {,} array {,} tempRP {)} ENDNATIVE !!VALUE
NATIVE {ReadPixelArray8} PROC
PROC ReadPixelArray8(rp:PTR TO rastport, xstart:VALUE, ystart:VALUE, xstop:VALUE, ystop:VALUE, array:ARRAY OF UBYTE, temprp:PTR TO rastport) IS NATIVE {ReadPixelArray8(} rp {,} xstart {,} ystart {,} xstop {,} ystop {,} array {,} temprp {)} ENDNATIVE !!VALUE
NATIVE {WritePixelArray8} PROC
PROC WritePixelArray8(rp:PTR TO rastport, xstart:ULONG, ystart:ULONG, xstop:ULONG, ystop:ULONG, array:ARRAY OF UBYTE, temprp:PTR TO rastport) IS NATIVE {WritePixelArray8(} rp {,} xstart {,} ystart {,} xstop {,} ystop {,} array {,} temprp {)} ENDNATIVE !!VALUE
NATIVE {GetVPModeID} PROC
PROC GetVPModeID(vp:PTR TO viewport) IS NATIVE {GetVPModeID(} vp {)} ENDNATIVE !!ULONG
NATIVE {ModeNotAvailable} PROC
PROC ModeNotAvailable(modeID:ULONG) IS NATIVE {ModeNotAvailable(} modeID {)} ENDNATIVE !!ULONG
NATIVE {WeighTAMatch} PROC
PROC WeighTAMatch(reqTextAttr:PTR TO textattr, targetTextAttr:PTR TO textattr, targetTags:ARRAY OF tagitem) IS NATIVE {WeighTAMatch(} reqTextAttr {,} targetTextAttr {,} targetTags {)} ENDNATIVE !!INT
NATIVE {EraseRect} PROC
PROC EraseRect(rp:PTR TO rastport, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE) IS NATIVE {EraseRect(} rp {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
NATIVE {ExtendFont} PROC
PROC ExtendFont(font:PTR TO textfont, fontTags:ARRAY OF tagitem) IS NATIVE {ExtendFont(} font {,} fontTags {)} ENDNATIVE !!ULONG
NATIVE {StripFont} PROC
PROC StripFont(font:PTR TO textfont) IS NATIVE {StripFont(} font {)} ENDNATIVE
NATIVE {CalcIVG} PROC
PROC CalcIVG(View:PTR TO view, ViewPort:PTR TO viewport) IS NATIVE {CalcIVG(} View {,} ViewPort {)} ENDNATIVE !!UINT
NATIVE {AttachPalExtra} PROC
PROC AttachPalExtra(cm:PTR TO colormap, vp:PTR TO viewport) IS NATIVE {AttachPalExtra(} cm {,} vp {)} ENDNATIVE !!VALUE
NATIVE {ObtainBestPenA} PROC
PROC ObtainBestPenA(cm:PTR TO colormap, r:ULONG, g:ULONG, b:ULONG, tags:ARRAY OF tagitem) IS NATIVE {ObtainBestPenA(} cm {,} r {,} g {,} b {,} tags {)} ENDNATIVE !!VALUE
NATIVE {ClearRegionRegionND} PROC
PROC ClearRegionRegionND(r1:PTR TO region, r2:PTR TO region) IS NATIVE {ClearRegionRegionND(} r1 {,} r2 {)} ENDNATIVE !!PTR TO region
NATIVE {SetRGB32} PROC
PROC SetRGB32(vp:PTR TO viewport, n:ULONG, r:ULONG, g:ULONG, b:ULONG) IS NATIVE {SetRGB32(} vp {,} n {,} r {,} g {,} b {)} ENDNATIVE
NATIVE {GetAPen} PROC
PROC GetAPen(rp:PTR TO rastport) IS NATIVE {GetAPen(} rp {)} ENDNATIVE !!ULONG
NATIVE {GetBPen} PROC
PROC GetBPen(rp:PTR TO rastport) IS NATIVE {GetBPen(} rp {)} ENDNATIVE !!ULONG
NATIVE {GetDrMd} PROC
PROC GetDrMd(rp:PTR TO rastport) IS NATIVE {GetDrMd(} rp {)} ENDNATIVE !!ULONG
NATIVE {GetOutlinePen} PROC
PROC GetOutlinePen(rp:PTR TO rastport) IS NATIVE {GetOutlinePen(} rp {)} ENDNATIVE !!ULONG
NATIVE {LoadRGB32} PROC
PROC LoadRGB32(vp:PTR TO viewport, table:ARRAY OF ULONG) IS NATIVE {LoadRGB32(} vp {,} table {)} ENDNATIVE
NATIVE {SetChipRev} PROC
PROC SetChipRev(ChipRev:ULONG) IS NATIVE {SetChipRev(} ChipRev {)} ENDNATIVE !!ULONG
NATIVE {SetABPenDrMd} PROC
PROC SetABPenDrMd(rp:PTR TO rastport, apen:ULONG, bpen:ULONG, drawMode:ULONG) IS NATIVE {SetABPenDrMd(} rp {,} apen {,} bpen {,} drawMode {)} ENDNATIVE
NATIVE {GetRGB32} PROC
PROC GetRGB32(cm:PTR TO colormap, firstcolor:ULONG, ncolors:ULONG, table:ARRAY OF ULONG) IS NATIVE {GetRGB32(} cm {,} firstcolor {,} ncolors {,} table {)} ENDNATIVE
NATIVE {XorRegionRegionND} PROC
PROC XorRegionRegionND(r1:PTR TO region, r2:PTR TO region) IS NATIVE {XorRegionRegionND(} r1 {,} r2 {)} ENDNATIVE !!PTR TO region
NATIVE {XorRectRegionND} PROC
PROC XorRectRegionND(Reg:PTR TO region, Rect:PTR TO rectangle) IS NATIVE {XorRectRegionND(} Reg {,} Rect {)} ENDNATIVE !!PTR TO region
NATIVE {AllocBitMap} PROC
PROC AllocBitMap(sizex:ULONG, sizey:ULONG, depth:ULONG, flags:ULONG, friend_bitmap:PTR TO bitmap) IS NATIVE {AllocBitMap(} sizex {,} sizey {,} depth {,} flags {,} friend_bitmap {)} ENDNATIVE !!PTR TO bitmap
NATIVE {FreeBitMap} PROC
PROC FreeBitMap(bm:PTR TO bitmap) IS NATIVE {FreeBitMap(} bm {)} ENDNATIVE
NATIVE {GetExtSpriteA} PROC
PROC GetExtSpriteA(sprite:PTR TO extsprite, tags:ARRAY OF tagitem) IS NATIVE {GetExtSpriteA(} sprite {,} tags {)} ENDNATIVE !!VALUE
NATIVE {CoerceMode} PROC
PROC CoerceMode(RealViewPort:PTR TO viewport, MonitorID:ULONG, Flags:ULONG) IS NATIVE {CoerceMode(} RealViewPort {,} MonitorID {,} Flags {)} ENDNATIVE !!ULONG
NATIVE {ChangeVPBitMap} PROC
PROC ChangeVPBitMap(vp:PTR TO viewport, bm:PTR TO bitmap, db:PTR TO dbufinfo) IS NATIVE {ChangeVPBitMap(} vp {,} bm {,} db {)} ENDNATIVE
NATIVE {ReleasePen} PROC
PROC ReleasePen(cm:PTR TO colormap, n:ULONG) IS NATIVE {ReleasePen(} cm {,} n {)} ENDNATIVE
NATIVE {ObtainPen} PROC
PROC ObtainPen(cm:PTR TO colormap, n:ULONG, r:ULONG, g:ULONG, b:ULONG, flags:ULONG) IS NATIVE {ObtainPen(} cm {,} n {,} r {,} g {,} b {,} flags {)} ENDNATIVE !!VALUE
NATIVE {GetBitMapAttr} PROC
PROC GetBitMapAttr(bitmap:PTR TO bitmap, attribute:ULONG) IS NATIVE {GetBitMapAttr(} bitmap {,} attribute {)} ENDNATIVE !!IPTR
NATIVE {AllocDBufInfo} PROC
PROC AllocDBufInfo(vp:PTR TO viewport) IS NATIVE {AllocDBufInfo(} vp {)} ENDNATIVE !!PTR TO dbufinfo
NATIVE {FreeDBufInfo} PROC
PROC FreeDBufInfo(db:PTR TO dbufinfo) IS NATIVE {FreeDBufInfo(} db {)} ENDNATIVE
NATIVE {SetOutlinePen} PROC
PROC SetOutlinePen(rp:PTR TO rastport, pen:ULONG) IS NATIVE {SetOutlinePen(} rp {,} pen {)} ENDNATIVE !!ULONG
NATIVE {SetWriteMask} PROC
PROC SetWriteMask(rp:PTR TO rastport, mask:ULONG) IS NATIVE {SetWriteMask(} rp {,} mask {)} ENDNATIVE !!ULONG
NATIVE {SetMaxPen} PROC
PROC SetMaxPen(rp:PTR TO rastport, maxpen:ULONG) IS NATIVE {SetMaxPen(} rp {,} maxpen {)} ENDNATIVE
NATIVE {SetRGB32CM} PROC
PROC SetRGB32CM(cm:PTR TO colormap, n:ULONG, r:ULONG, g:ULONG, b:ULONG) IS NATIVE {SetRGB32CM(} cm {,} n {,} r {,} g {,} b {)} ENDNATIVE
NATIVE {ScrollRasterBF} PROC
PROC ScrollRasterBF(rp:PTR TO rastport, dx:VALUE, dy:VALUE, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE) IS NATIVE {ScrollRasterBF(} rp {,} dx {,} dy {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
NATIVE {FindColor} PROC
PROC FindColor(cm:PTR TO colormap, r:ULONG, g:ULONG, b:ULONG, maxpen:ULONG) IS NATIVE {FindColor(} cm {,} r {,} g {,} b {,} maxpen {)} ENDNATIVE !!ULONG
NATIVE {AllocSpriteDataA} PROC
PROC AllocSpriteDataA(bitmap:PTR TO bitmap, tagList:ARRAY OF tagitem) IS NATIVE {AllocSpriteDataA(} bitmap {,} tagList {)} ENDNATIVE !!PTR TO extsprite
NATIVE {ChangeExtSpriteA} PROC
PROC ChangeExtSpriteA(vp:PTR TO viewport, oldsprite:PTR TO extsprite, newsprite:PTR TO extsprite, tags:ARRAY OF tagitem) IS NATIVE {ChangeExtSpriteA(} vp {,} oldsprite {,} newsprite {,} tags {)} ENDNATIVE !!VALUE
NATIVE {FreeSpriteData} PROC
PROC FreeSpriteData(extsp:PTR TO extsprite) IS NATIVE {FreeSpriteData(} extsp {)} ENDNATIVE
NATIVE {SetRPAttrsA} PROC
PROC SetRPAttrsA(rp:PTR TO rastport, tags:ARRAY OF tagitem) IS NATIVE {SetRPAttrsA(} rp {,} tags {)} ENDNATIVE
NATIVE {GetRPAttrsA} PROC
PROC GetRPAttrsA(rp:PTR TO rastport, tags:ARRAY OF tagitem) IS NATIVE {GetRPAttrsA(} rp {,} tags {)} ENDNATIVE
NATIVE {BestModeIDA} PROC
PROC BestModeIDA(TagItems:ARRAY OF tagitem) IS NATIVE {BestModeIDA(} TagItems {)} ENDNATIVE !!ULONG
NATIVE {WriteChunkyPixels} PROC
PROC WriteChunkyPixels(rp:PTR TO rastport, xstart:VALUE, ystart:VALUE, xstop:VALUE, ystop:VALUE, array:ARRAY OF UBYTE, bytesperrow:VALUE) IS NATIVE {WriteChunkyPixels(} rp {,} xstart {,} ystart {,} xstop {,} ystop {,} array {,} bytesperrow {)} ENDNATIVE
NATIVE {CreateRastPort} PROC
PROC CreateRastPort() IS NATIVE {CreateRastPort()} ENDNATIVE !!PTR TO rastport
NATIVE {CloneRastPort} PROC
PROC CloneRastPort(rp:PTR TO rastport) IS NATIVE {CloneRastPort(} rp {)} ENDNATIVE !!PTR TO rastport
NATIVE {DeinitRastPort} PROC
PROC DeinitRastPort(rp:PTR TO rastport) IS NATIVE {DeinitRastPort(} rp {)} ENDNATIVE
NATIVE {FreeRastPort} PROC
PROC FreeRastPort(rp:PTR TO rastport) IS NATIVE {FreeRastPort(} rp {)} ENDNATIVE
NATIVE {LateGfxInit} PROC
->removed from AROS v1.3.x: PROC LateGfxInit(data:APTR) IS NATIVE {-LateGfxInit(} data {)} ENDNATIVE !!INT
NATIVE {AllocScreenBitMap} PROC
->removed from AROS v1.3.x: PROC AllocScreenBitMap(modeid:ULONG) IS NATIVE {AllocScreenBitMap(} modeid {)} ENDNATIVE !!PTR TO bitmap
NATIVE {MouseCoordsRelative} PROC
->removed from AROS v1.3.x: PROC MouseCoordsRelative() IS NATIVE {-MouseCoordsRelative()} ENDNATIVE !!INT
NATIVE {SetFrontBitMap} PROC
->removed from AROS v1.3.x: PROC SetFrontBitMap(bitmap:PTR TO bitmap, copyback:INT) IS NATIVE {-SetFrontBitMap(} bitmap {, -} copyback {)} ENDNATIVE !!INT
NATIVE {SetPointerPos} PROC
->removed from AROS v1.3.x: PROC SetPointerPos(x:UINT, y:UINT) IS NATIVE {SetPointerPos(} x {,} y {)} ENDNATIVE
NATIVE {SetPointerShape} PROC
->removed from AROS v1.3.x: PROC SetPointerShape(shape:PTR TO UINT, width:UINT, height:UINT, xoffset:UINT, yoffset:UINT) IS NATIVE {SetPointerShape(} shape {,} width {,} height {,} xoffset {,} yoffset {)} ENDNATIVE
NATIVE {ClearRegionRegion} PROC
PROC ClearRegionRegion(r1:PTR TO region, r2:PTR TO region) IS NATIVE {-ClearRegionRegion(} r1 {,} r2 {)} ENDNATIVE !!INT
NATIVE {CopyRegion} PROC
PROC CopyRegion(region:PTR TO region) IS NATIVE {CopyRegion(} region {)} ENDNATIVE !!PTR TO region
NATIVE {AreRegionsEqual} PROC
PROC AreRegionsEqual(r1:PTR TO region, r2:PTR TO region) IS NATIVE {-AreRegionsEqual(} r1 {,} r2 {)} ENDNATIVE !!INT
NATIVE {IsPointInRegion} PROC
PROC IsPointInRegion(Reg:PTR TO region, x:INT, y:INT) IS NATIVE {-IsPointInRegion(} Reg {,} x {,} y {)} ENDNATIVE !!INT
NATIVE {ScrollRegion} PROC
PROC ScrollRegion(region:PTR TO region, rect:PTR TO rectangle, dx:INT, dy:INT) IS NATIVE {-ScrollRegion(} region {,} rect {,} dx {,} dy {)} ENDNATIVE !!INT
->NATIVE {SwapRegions} PROC
->PROC SwapRegions(region1:PTR TO region, region2:PTR TO region) IS NATIVE {SwapRegions(} region1 {,} region2 {)} ENDNATIVE
NATIVE {AndRectRect} PROC
PROC AndRectRect(rect1:PTR TO rectangle, rect2:PTR TO rectangle, intersect:PTR TO rectangle) IS NATIVE {-AndRectRect(} rect1 {,} rect2 {,} intersect {)} ENDNATIVE !!INT
NATIVE {NewRectRegion} PROC
PROC NewRectRegion(MinX:INT, MinY:INT, MaxX:INT, MaxY:INT) IS NATIVE {NewRectRegion(} MinX {,} MinY {,} MaxX {,} MaxY {)} ENDNATIVE !!PTR TO region
NATIVE {SetRegion} PROC
PROC SetRegion(src:PTR TO region, dest:PTR TO region) IS NATIVE {-SetRegion(} src {,} dest {)} ENDNATIVE !!INT
->NATIVE {BltRastPortBitMap} PROC
->PROC BltRastPortBitMap(srcRastPort:PTR TO rastport, xSrc:VALUE, ySrc:VALUE, destBitMap:PTR TO bitmap, xDest:VALUE, yDest:VALUE, xSize:ULONG, ySize:ULONG, minterm:ULONG) IS NATIVE {BltRastPortBitMap(} srcRastPort {,} xSrc {,} ySrc {,} destBitMap {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {)} ENDNATIVE
->NATIVE {ShowImminentReset} PROC
->PROC ShowImminentReset() IS NATIVE {ShowImminentReset()} ENDNATIVE
NATIVE {SetRGBConversionFunctionA} PROC
->removed from AROS v1.3.x: PROC SetRGBConversionFunctionA(srcPixFmt:ULONG, dstPixFmt:ULONG, function:APTR, tags:ARRAY OF tagitem) IS NATIVE {SetRGBConversionFunctionA(} srcPixFmt {,} dstPixFmt {,} function {,} tags {)} ENDNATIVE !!APTR
NATIVE {ConvertPixelsA} PROC
->removed from AROS v1.3.x: PROC ConvertPixelsA(srcPixels:APTR, srcMod:ULONG, srcPixFmt:ULONG, dstPixels:APTR, dstMod:ULONG, dstPixFmt:ULONG, width:ULONG, height:ULONG, tags:ARRAY OF tagitem) IS NATIVE {ConvertPixelsA(} srcPixels {,} srcMod {,} srcPixFmt {,} dstPixels {,} dstMod {,} dstPixFmt {,} width {,} height {,} tags {)} ENDNATIVE !!ULONG
