/* $Id: graphics_protos.h,v 1.13 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/graphics/clip', 'target/graphics/coerce', 'target/graphics/collide', 'target/graphics/copper', 'target/graphics/display', 'target/graphics/displayinfo', 'target/graphics/gels', 'target/graphics/gfx', 'target/graphics/gfxbase', /*'target/graphics/gfxmacros',*/ 'target/graphics/gfxnodes', 'target/graphics/graphint', 'target/graphics/layers', 'target/graphics/modeid', 'target/graphics/monitor', 'target/graphics/rastport', 'target/graphics/regions', 'target/graphics/rpattr', 'target/graphics/scale', 'target/graphics/sprite', 'target/graphics/text', 'target/graphics/videocontrol', 'target/graphics/view', 'target/graphics/composite'
MODULE 'target/graphics/gfx', 'target/graphics/displayinfo', 'target/graphics/gels', 'target/graphics/rastport', 'target/graphics/view', 'target/graphics/copper', 'target/graphics/clip', 'target/graphics/regions', 'target/graphics/scale', 'target/graphics/sprite', 'target/graphics/text', 'target/hardware/blit'
MODULE 'target/exec/libraries', 'target/utility/tagitem', 'target/exec', 'target/dos/dos'
{
#include <proto/graphics.h>
}
{
struct Library* GfxBase = NULL;
struct GraphicsIFace* IGraphics = NULL;
}
NATIVE {CLIB_GRAPHICS_PROTOS_H} CONST
NATIVE {PROTO_GRAPHICS_H} CONST
NATIVE {PRAGMA_GRAPHICS_H} CONST
NATIVE {INLINE4_GRAPHICS_H} CONST
NATIVE {GRAPHICS_INTERFACE_DEF_H} CONST

NATIVE {GfxBase} DEF gfxbase:PTR TO lib
NATIVE {IGraphics} CONST

->automatic opening of graphics library
PROC new()
	gfxbase := OpenLibrary('graphics.library', 0)
	IF gfxbase=NIL THEN CleanUp(RETURN_ERROR)
	
	NATIVE {IGraphics = (struct GraphicsIFace *) IExec->GetInterface((struct Library *)} gfxbase{, "main", 1, NULL)} ENDNATIVE
ENDPROC

->automatic closing of graphics library
PROC end()
	{IExec->DropInterface((struct Interface *) IGraphics)}
	CloseLibrary(gfxbase)
ENDPROC

/*------ BitMap primitives ------*/
->NATIVE {BltBitMap} PROC
PROC BltBitMap( srcBitMap:PTR TO bitmap, xSrc:VALUE, ySrc:VALUE, destBitMap:PTR TO bitmap, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG, mask:ULONG, tempA:PLANEPTR ) IS NATIVE {IGraphics->BltBitMap(} srcBitMap {,} xSrc {,} ySrc {,} destBitMap {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {,} mask {,} tempA {)} ENDNATIVE !!ULONG
->NATIVE {BltTemplate} PROC
PROC BltTemplate( source:PLANEPTR, xSrc:VALUE, srcMod:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE ) IS NATIVE {IGraphics->BltTemplate(} source {,} xSrc {,} srcMod {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {)} ENDNATIVE
/*------ Text routines ------*/
->NATIVE {ClearEOL} PROC
PROC ClearEOL( rp:PTR TO rastport ) IS NATIVE {IGraphics->ClearEOL(} rp {)} ENDNATIVE
->NATIVE {ClearScreen} PROC
PROC ClearScreen( rp:PTR TO rastport ) IS NATIVE {IGraphics->ClearScreen(} rp {)} ENDNATIVE
->NATIVE {TextLength} PROC
PROC TextLength( rp:PTR TO rastport, string:ARRAY OF CHAR /*STRPTR*/, count:ULONG ) IS NATIVE {IGraphics->TextLength(} rp {,} string {,} count {)} ENDNATIVE !!INT
->NATIVE {Text} PROC
PROC Text( rp:PTR TO rastport, string:ARRAY OF CHAR /*STRPTR*/, count:ULONG ) IS NATIVE {IGraphics->Text(} rp {,} string {,} count {)} ENDNATIVE
->NATIVE {SetFont} PROC
PROC SetFont( rp:PTR TO rastport, textFont:PTR TO textfont ) IS NATIVE {IGraphics->SetFont(} rp {,} textFont {)} ENDNATIVE
->NATIVE {OpenFont} PROC
PROC OpenFont( textAttr:PTR TO textattr ) IS NATIVE {IGraphics->OpenFont(} textAttr {)} ENDNATIVE !!PTR TO textfont
->NATIVE {CloseFont} PROC
PROC CloseFont( textFont:PTR TO textfont ) IS NATIVE {IGraphics->CloseFont(} textFont {)} ENDNATIVE
->NATIVE {AskSoftStyle} PROC
PROC AskSoftStyle( rp:PTR TO rastport ) IS NATIVE {IGraphics->AskSoftStyle(} rp {)} ENDNATIVE !!ULONG
->NATIVE {SetSoftStyle} PROC
PROC SetSoftStyle( rp:PTR TO rastport, style:ULONG, enable:ULONG ) IS NATIVE {IGraphics->SetSoftStyle(} rp {,} style {,} enable {)} ENDNATIVE !!ULONG
/*------    Gels routines ------*/
->NATIVE {AddBob} PROC
PROC AddBob( bob:PTR TO bob, rp:PTR TO rastport ) IS NATIVE {IGraphics->AddBob(} bob {,} rp {)} ENDNATIVE
->NATIVE {AddVSprite} PROC
PROC AddVSprite( vSprite:PTR TO vs, rp:PTR TO rastport ) IS NATIVE {IGraphics->AddVSprite(} vSprite {,} rp {)} ENDNATIVE
->NATIVE {DoCollision} PROC
PROC DoCollision( rp:PTR TO rastport ) IS NATIVE {IGraphics->DoCollision(} rp {)} ENDNATIVE
->NATIVE {DrawGList} PROC
PROC DrawGList( rp:PTR TO rastport, vp:PTR TO viewport ) IS NATIVE {IGraphics->DrawGList(} rp {,} vp {)} ENDNATIVE
->NATIVE {InitGels} PROC
PROC InitGels( head:PTR TO vs, tail:PTR TO vs, gelsInfo:PTR TO gelsinfo ) IS NATIVE {IGraphics->InitGels(} head {,} tail {,} gelsInfo {)} ENDNATIVE
->NATIVE {InitMasks} PROC
PROC InitMasks( vSprite:PTR TO vs ) IS NATIVE {IGraphics->InitMasks(} vSprite {)} ENDNATIVE
->NATIVE {RemIBob} PROC
PROC RemIBob( bob:PTR TO bob, rp:PTR TO rastport, vp:PTR TO viewport ) IS NATIVE {IGraphics->RemIBob(} bob {,} rp {,} vp {)} ENDNATIVE
->NATIVE {RemVSprite} PROC
PROC RemVSprite( vSprite:PTR TO vs ) IS NATIVE {IGraphics->RemVSprite(} vSprite {)} ENDNATIVE
->NATIVE {SetCollision} PROC
PROC SetCollision( num:ULONG, routine:PTR /*VOID (*routine)(struct VSprite *gelA, struct VSprite *gelB)*/, gelsInfo:PTR TO gelsinfo ) IS NATIVE {IGraphics->SetCollision(} num {, (VOID (*)(struct VSprite*, struct VSprite*)) } routine {,} gelsInfo {)} ENDNATIVE
->NATIVE {SortGList} PROC
PROC SortGList( rp:PTR TO rastport ) IS NATIVE {IGraphics->SortGList(} rp {)} ENDNATIVE
->NATIVE {AddAnimOb} PROC
PROC AddAnimOb( anOb:PTR TO ao, anKey:ARRAY OF PTR TO ao, rp:PTR TO rastport ) IS NATIVE {IGraphics->AddAnimOb(} anOb {,} anKey {,} rp {)} ENDNATIVE
->NATIVE {Animate} PROC
PROC Animate( anKey:ARRAY OF PTR TO ao, rp:PTR TO rastport ) IS NATIVE {IGraphics->Animate(} anKey {,} rp {)} ENDNATIVE
->NATIVE {GetGBuffers} PROC
PROC GetGBuffers( anOb:PTR TO ao, rp:PTR TO rastport, flag:VALUE ) IS NATIVE {-IGraphics->GetGBuffers(} anOb {,} rp {,} flag {)} ENDNATIVE !!INT
->NATIVE {InitGMasks} PROC
PROC InitGMasks( anOb:PTR TO ao ) IS NATIVE {IGraphics->InitGMasks(} anOb {)} ENDNATIVE
/*------    General graphics routines ------*/
->NATIVE {DrawEllipse} PROC
PROC DrawEllipse( rp:PTR TO rastport, xCenter:VALUE, yCenter:VALUE, a:VALUE, b:VALUE ) IS NATIVE {IGraphics->DrawEllipse(} rp {,} xCenter {,} yCenter {,} a {,} b {)} ENDNATIVE
->NATIVE {AreaEllipse} PROC
PROC AreaEllipse( rp:PTR TO rastport, xCenter:VALUE, yCenter:VALUE, a:VALUE, b:VALUE ) IS NATIVE {IGraphics->AreaEllipse(} rp {,} xCenter {,} yCenter {,} a {,} b {)} ENDNATIVE !!VALUE
->NATIVE {LoadRGB4} PROC
PROC LoadRGB4( vp:PTR TO viewport, colors:PTR TO UINT, count:ULONG ) IS NATIVE {IGraphics->LoadRGB4(} vp {,} colors {,} count {)} ENDNATIVE
->NATIVE {InitRastPort} PROC
PROC InitRastPort( rp:PTR TO rastport ) IS NATIVE {IGraphics->InitRastPort(} rp {)} ENDNATIVE
->NATIVE {InitVPort} PROC
PROC InitVPort( vp:PTR TO viewport ) IS NATIVE {IGraphics->InitVPort(} vp {)} ENDNATIVE
->NATIVE {MrgCop} PROC
PROC MrgCop( view:PTR TO view ) IS NATIVE {IGraphics->MrgCop(} view {)} ENDNATIVE !!ULONG
->NATIVE {MakeVPort} PROC
PROC MakeVPort( view:PTR TO view, vp:PTR TO viewport ) IS NATIVE {IGraphics->MakeVPort(} view {,} vp {)} ENDNATIVE !!ULONG
->NATIVE {LoadView} PROC
PROC LoadView( view:PTR TO view ) IS NATIVE {IGraphics->LoadView(} view {)} ENDNATIVE
->NATIVE {WaitBlit} PROC
PROC WaitBlit( ) IS NATIVE {IGraphics->WaitBlit()} ENDNATIVE
->NATIVE {SetRast} PROC
PROC SetRast( rp:PTR TO rastport, pen:ULONG ) IS NATIVE {IGraphics->SetRast(} rp {,} pen {)} ENDNATIVE
->NATIVE {Move} PROC
PROC Move( rp:PTR TO rastport, x:VALUE, y:VALUE ) IS NATIVE {IGraphics->Move(} rp {,} x {,} y {)} ENDNATIVE
->NATIVE {Draw} PROC
PROC Draw( rp:PTR TO rastport, x:VALUE, y:VALUE ) IS NATIVE {IGraphics->Draw(} rp {,} x {,} y {)} ENDNATIVE
->NATIVE {AreaMove} PROC
PROC AreaMove( rp:PTR TO rastport, x:VALUE, y:VALUE ) IS NATIVE {IGraphics->AreaMove(} rp {,} x {,} y {)} ENDNATIVE !!VALUE
->NATIVE {AreaDraw} PROC
PROC AreaDraw( rp:PTR TO rastport, x:VALUE, y:VALUE ) IS NATIVE {IGraphics->AreaDraw(} rp {,} x {,} y {)} ENDNATIVE !!VALUE
->NATIVE {AreaEnd} PROC
PROC AreaEnd( rp:PTR TO rastport ) IS NATIVE {IGraphics->AreaEnd(} rp {)} ENDNATIVE !!VALUE
->NATIVE {WaitTOF} PROC
PROC WaitTOF( ) IS NATIVE {IGraphics->WaitTOF()} ENDNATIVE
->NATIVE {QBlit} PROC
PROC Qblit( blit:PTR TO bltnode ) IS NATIVE {IGraphics->QBlit(} blit {)} ENDNATIVE
->NATIVE {InitArea} PROC
PROC InitArea( areaInfo:PTR TO areainfo, vectorBuffer:APTR, maxVectors:VALUE ) IS NATIVE {IGraphics->InitArea(} areaInfo {,} vectorBuffer {,} maxVectors {)} ENDNATIVE
->NATIVE {SetRGB4} PROC
PROC SetRGB4( vp:PTR TO viewport, colindex:ULONG, red:ULONG, green:ULONG, blue:ULONG ) IS NATIVE {IGraphics->SetRGB4(} vp {,} colindex {,} red {,} green {,} blue {)} ENDNATIVE
->NATIVE {QBSBlit} PROC
PROC QbSBlit( blit:PTR TO bltnode ) IS NATIVE {IGraphics->QBSBlit(} blit {)} ENDNATIVE
->NATIVE {BltClear} PROC
PROC BltClear( memBlock:PLANEPTR, byteCount:ULONG, flags:ULONG ) IS NATIVE {IGraphics->BltClear(} memBlock {,} byteCount {,} flags {)} ENDNATIVE
->NATIVE {RectFill} PROC
PROC RectFill( rp:PTR TO rastport, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE ) IS NATIVE {IGraphics->RectFill(} rp {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
->NATIVE {BltPattern} PROC
PROC BltPattern( rp:PTR TO rastport, mask:PLANEPTR, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE, maskBPR:ULONG ) IS NATIVE {IGraphics->BltPattern(} rp {,} mask {,} xMin {,} yMin {,} xMax {,} yMax {,} maskBPR {)} ENDNATIVE
->NATIVE {ReadPixel} PROC
PROC ReadPixel( rp:PTR TO rastport, x:VALUE, y:VALUE ) IS NATIVE {IGraphics->ReadPixel(} rp {,} x {,} y {)} ENDNATIVE !!VALUE
->NATIVE {WritePixel} PROC
PROC WritePixel( rp:PTR TO rastport, x:VALUE, y:VALUE ) IS NATIVE {IGraphics->WritePixel(} rp {,} x {,} y {)} ENDNATIVE !!VALUE
->NATIVE {Flood} PROC
PROC Flood( rp:PTR TO rastport, mode:ULONG, x:VALUE, y:VALUE ) IS NATIVE {-IGraphics->Flood(} rp {,} mode {,} x {,} y {)} ENDNATIVE !!INT
->NATIVE {PolyDraw} PROC
PROC PolyDraw( rp:PTR TO rastport, count:VALUE, polyTable:ARRAY OF INT ) IS NATIVE {IGraphics->PolyDraw(} rp {,} count {,} polyTable {)} ENDNATIVE
->NATIVE {SetAPen} PROC
PROC SetAPen( rp:PTR TO rastport, pen:ULONG ) IS NATIVE {IGraphics->SetAPen(} rp {,} pen {)} ENDNATIVE
->NATIVE {SetBPen} PROC
PROC SetBPen( rp:PTR TO rastport, pen:ULONG ) IS NATIVE {IGraphics->SetBPen(} rp {,} pen {)} ENDNATIVE
->NATIVE {SetDrMd} PROC
PROC SetDrMd( rp:PTR TO rastport, drawMode:ULONG ) IS NATIVE {IGraphics->SetDrMd(} rp {,} drawMode {)} ENDNATIVE
->NATIVE {InitView} PROC
PROC InitView( view:PTR TO view ) IS NATIVE {IGraphics->InitView(} view {)} ENDNATIVE
->NATIVE {CBump} PROC
PROC Cbump( copList:PTR TO ucoplist ) IS NATIVE {IGraphics->CBump(} copList {)} ENDNATIVE
->NATIVE {CMove} PROC
PROC Cmove( copList:PTR TO ucoplist, destoffset:VALUE, data:VALUE ) IS NATIVE {IGraphics->CMove(} copList {,} destoffset {,} data {)} ENDNATIVE
->NATIVE {CWait} PROC
PROC Cwait( copList:PTR TO ucoplist, v:VALUE, h:VALUE ) IS NATIVE {IGraphics->CWait(} copList {,} v {,} h {)} ENDNATIVE
->NATIVE {VBeamPos} PROC
PROC VbeamPos( ) IS NATIVE {IGraphics->VBeamPos()} ENDNATIVE !!VALUE
->NATIVE {InitBitMap} PROC
PROC InitBitMap( bitMap:PTR TO bitmap, depth:VALUE, width:ULONG, height:ULONG ) IS NATIVE {IGraphics->InitBitMap(} bitMap {,} depth {,} width {,} height {)} ENDNATIVE
->NATIVE {ScrollRaster} PROC
PROC ScrollRaster( rp:PTR TO rastport, dx:VALUE, dy:VALUE, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE ) IS NATIVE {IGraphics->ScrollRaster(} rp {,} dx {,} dy {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
->NATIVE {WaitBOVP} PROC
PROC WaitBOVP( vp:PTR TO viewport ) IS NATIVE {IGraphics->WaitBOVP(} vp {)} ENDNATIVE
->NATIVE {GetSprite} PROC
PROC GetSprite( sprite:PTR TO simplesprite, num:VALUE ) IS NATIVE {IGraphics->GetSprite(} sprite {,} num {)} ENDNATIVE !!INT
->NATIVE {FreeSprite} PROC
PROC FreeSprite( num:VALUE ) IS NATIVE {IGraphics->FreeSprite(} num {)} ENDNATIVE
->NATIVE {ChangeSprite} PROC
PROC ChangeSprite( vp:PTR TO viewport, sprite:PTR TO simplesprite, newData:APTR ) IS NATIVE {IGraphics->ChangeSprite(} vp {,} sprite {,} newData {)} ENDNATIVE
->NATIVE {MoveSprite} PROC
PROC MoveSprite( vp:PTR TO viewport, sprite:PTR TO simplesprite, x:VALUE, y:VALUE ) IS NATIVE {IGraphics->MoveSprite(} vp {,} sprite {,} x {,} y {)} ENDNATIVE
->NATIVE {LockLayerRom} PROC
PROC LockLayerRom( layer:PTR TO layer ) IS NATIVE {IGraphics->LockLayerRom(} layer {)} ENDNATIVE
->NATIVE {UnlockLayerRom} PROC
PROC UnlockLayerRom( layer:PTR TO layer ) IS NATIVE {IGraphics->UnlockLayerRom(} layer {)} ENDNATIVE
->NATIVE {SyncSBitMap} PROC
PROC SyncSBitMap( layer:PTR TO layer ) IS NATIVE {IGraphics->SyncSBitMap(} layer {)} ENDNATIVE
->NATIVE {CopySBitMap} PROC
PROC CopySBitMap( layer:PTR TO layer ) IS NATIVE {IGraphics->CopySBitMap(} layer {)} ENDNATIVE
->NATIVE {OwnBlitter} PROC
PROC OwnBlitter( ) IS NATIVE {IGraphics->OwnBlitter()} ENDNATIVE
->NATIVE {DisownBlitter} PROC
PROC DisownBlitter( ) IS NATIVE {IGraphics->DisownBlitter()} ENDNATIVE
->NATIVE {InitTmpRas} PROC
PROC InitTmpRas( tmpRas:PTR TO tmpras, buffer:PLANEPTR, size:VALUE ) IS NATIVE {IGraphics->InitTmpRas(} tmpRas {,} buffer {,} size {)} ENDNATIVE !!PTR TO tmpras
->NATIVE {AskFont} PROC
PROC AskFont( rp:PTR TO rastport, textAttr:PTR TO textattr ) IS NATIVE {IGraphics->AskFont(} rp {,} textAttr {)} ENDNATIVE
->NATIVE {AddFont} PROC
PROC AddFont( textFont:PTR TO textfont ) IS NATIVE {IGraphics->AddFont(} textFont {)} ENDNATIVE
->NATIVE {RemFont} PROC
PROC RemFont( textFont:PTR TO textfont ) IS NATIVE {IGraphics->RemFont(} textFont {)} ENDNATIVE
->NATIVE {AllocRaster} PROC
PROC AllocRaster( width:ULONG, height:ULONG ) IS NATIVE {IGraphics->AllocRaster(} width {,} height {)} ENDNATIVE !!PLANEPTR
->NATIVE {FreeRaster} PROC
PROC FreeRaster( p:PLANEPTR, width:ULONG, height:ULONG ) IS NATIVE {IGraphics->FreeRaster(} p {,} width {,} height {)} ENDNATIVE
->NATIVE {AndRectRegion} PROC
PROC AndRectRegion( region:PTR TO region, rectangle:PTR TO rectangle ) IS NATIVE {IGraphics->AndRectRegion(} region {,} rectangle {)} ENDNATIVE
->NATIVE {OrRectRegion} PROC
PROC OrRectRegion( region:PTR TO region, rectangle:PTR TO rectangle ) IS NATIVE {-IGraphics->OrRectRegion(} region {,} rectangle {)} ENDNATIVE !!INT
->NATIVE {NewRegion} PROC
PROC NewRegion( ) IS NATIVE {IGraphics->NewRegion()} ENDNATIVE !!PTR TO region
->NATIVE {ClearRectRegion} PROC
PROC ClearRectRegion( region:PTR TO region, rectangle:PTR TO rectangle ) IS NATIVE {-IGraphics->ClearRectRegion(} region {,} rectangle {)} ENDNATIVE !!INT
->NATIVE {ClearRegion} PROC
PROC ClearRegion( region:PTR TO region ) IS NATIVE {IGraphics->ClearRegion(} region {)} ENDNATIVE
->NATIVE {DisposeRegion} PROC
PROC DisposeRegion( region:PTR TO region ) IS NATIVE {IGraphics->DisposeRegion(} region {)} ENDNATIVE
->NATIVE {FreeVPortCopLists} PROC
PROC FreeVPortCopLists( vp:PTR TO viewport ) IS NATIVE {IGraphics->FreeVPortCopLists(} vp {)} ENDNATIVE
->NATIVE {FreeCopList} PROC
PROC FreeCopList( copList:PTR TO coplist ) IS NATIVE {IGraphics->FreeCopList(} copList {)} ENDNATIVE
->NATIVE {ClipBlit} PROC
PROC ClipBlit( srcRP:PTR TO rastport, xSrc:VALUE, ySrc:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG ) IS NATIVE {IGraphics->ClipBlit(} srcRP {,} xSrc {,} ySrc {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {)} ENDNATIVE
->NATIVE {XorRectRegion} PROC
PROC XorRectRegion( region:PTR TO region, rectangle:PTR TO rectangle ) IS NATIVE {-IGraphics->XorRectRegion(} region {,} rectangle {)} ENDNATIVE !!INT
->NATIVE {FreeCprList} PROC
PROC FreeCprList( cprList:PTR TO cprlist ) IS NATIVE {IGraphics->FreeCprList(} cprList {)} ENDNATIVE
->NATIVE {GetColorMap} PROC
PROC GetColorMap( entries:ULONG ) IS NATIVE {IGraphics->GetColorMap(} entries {)} ENDNATIVE !!PTR TO colormap
->NATIVE {FreeColorMap} PROC
PROC FreeColorMap( colorMap:PTR TO colormap ) IS NATIVE {IGraphics->FreeColorMap(} colorMap {)} ENDNATIVE
->NATIVE {GetRGB4} PROC
PROC GetRGB4( colorMap:PTR TO colormap, entry:ULONG ) IS NATIVE {IGraphics->GetRGB4(} colorMap {,} entry {)} ENDNATIVE !!VALUE
->NATIVE {ScrollVPort} PROC
PROC ScrollVPort( vp:PTR TO viewport ) IS NATIVE {IGraphics->ScrollVPort(} vp {)} ENDNATIVE
->NATIVE {UCopperListInit} PROC
PROC UcopperListInit( uCopList:PTR TO ucoplist, n:VALUE ) IS NATIVE {IGraphics->UCopperListInit(} uCopList {,} n {)} ENDNATIVE !!PTR TO coplist
->NATIVE {FreeGBuffers} PROC
PROC FreeGBuffers( anOb:PTR TO ao, rp:PTR TO rastport, flag:VALUE ) IS NATIVE {IGraphics->FreeGBuffers(} anOb {,} rp {,} flag {)} ENDNATIVE
->NATIVE {BltBitMapRastPort} PROC
PROC BltBitMapRastPort( srcBitMap:PTR TO bitmap, xSrc:VALUE, ySrc:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG ) IS NATIVE {-IGraphics->BltBitMapRastPort(} srcBitMap {,} xSrc {,} ySrc {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {)} ENDNATIVE !!INT
->NATIVE {OrRegionRegion} PROC
PROC OrRegionRegion( srcRegion:PTR TO region, destRegion:PTR TO region ) IS NATIVE {-IGraphics->OrRegionRegion(} srcRegion {,} destRegion {)} ENDNATIVE !!INT
->NATIVE {XorRegionRegion} PROC
PROC XorRegionRegion( srcRegion:PTR TO region, destRegion:PTR TO region ) IS NATIVE {-IGraphics->XorRegionRegion(} srcRegion {,} destRegion {)} ENDNATIVE !!INT
->NATIVE {AndRegionRegion} PROC
PROC AndRegionRegion( srcRegion:PTR TO region, destRegion:PTR TO region ) IS NATIVE {-IGraphics->AndRegionRegion(} srcRegion {,} destRegion {)} ENDNATIVE !!INT
->NATIVE {SetRGB4CM} PROC
PROC SetRGB4CM( colorMap:PTR TO colormap, colindex:ULONG, red:ULONG, green:ULONG, blue:ULONG ) IS NATIVE {IGraphics->SetRGB4CM(} colorMap {,} colindex {,} red {,} green {,} blue {)} ENDNATIVE
->NATIVE {BltMaskBitMapRastPort} PROC
PROC BltMaskBitMapRastPort( srcBitMap:PTR TO bitmap, xSrc:VALUE, ySrc:VALUE, destRP:PTR TO rastport, xDest:VALUE, yDest:VALUE, xSize:VALUE, ySize:VALUE, minterm:ULONG, bltMask:PLANEPTR ) IS NATIVE {IGraphics->BltMaskBitMapRastPort(} srcBitMap {,} xSrc {,} ySrc {,} destRP {,} xDest {,} yDest {,} xSize {,} ySize {,} minterm {,} bltMask {)} ENDNATIVE
->NATIVE {AttemptLockLayerRom} PROC
PROC AttemptLockLayerRom( layer:PTR TO layer ) IS NATIVE {-IGraphics->AttemptLockLayerRom(} layer {)} ENDNATIVE !!INT
/*--- functions in V36 or higher (Release 2.0) ---*/
->NATIVE {GfxNew} PROC
PROC GfxNew( gfxNodeType:ULONG ) IS NATIVE {IGraphics->GfxNew(} gfxNodeType {)} ENDNATIVE !!APTR
->NATIVE {GfxFree} PROC
PROC GfxFree( gfxNodePtr:PTR TO xln ) IS NATIVE {IGraphics->GfxFree(} gfxNodePtr {)} ENDNATIVE
->NATIVE {GfxAssociate} PROC
PROC GfxAssociate( associateNode:APTR, gfxNodePtr:PTR TO xln ) IS NATIVE {IGraphics->GfxAssociate(} associateNode {,} gfxNodePtr {)} ENDNATIVE
->NATIVE {BitMapScale} PROC
PROC BitMapScale( bitScaleArgs:PTR TO bitscaleargs ) IS NATIVE {IGraphics->BitMapScale(} bitScaleArgs {)} ENDNATIVE
->NATIVE {ScalerDiv} PROC
PROC ScalerDiv( factor:ULONG, numerator:ULONG, denominator:ULONG ) IS NATIVE {IGraphics->ScalerDiv(} factor {,} numerator {,} denominator {)} ENDNATIVE !!UINT
->NATIVE {TextExtent} PROC
PROC TextExtent( rp:PTR TO rastport, string:ARRAY OF CHAR /*STRPTR*/, count:ULONG, textExtent:PTR TO textextent ) IS NATIVE {IGraphics->TextExtent(} rp {,} string {,} count {,} textExtent {)} ENDNATIVE
->NATIVE {TextFit} PROC
PROC TextFit( rp:PTR TO rastport, string:ARRAY OF CHAR /*STRPTR*/, strLen:ULONG, textExtent:PTR TO textextent, constrainingExtent:PTR TO textextent, strDirection:VALUE, constrainingBitWidth:ULONG, constrainingBitHeight:ULONG ) IS NATIVE {IGraphics->TextFit(} rp {,} string {,} strLen {,} textExtent {,} constrainingExtent {,} strDirection {,} constrainingBitWidth {,} constrainingBitHeight {)} ENDNATIVE !!UINT
->NATIVE {GfxLookUp} PROC
PROC GfxLookUp( associateNode:APTR ) IS NATIVE {IGraphics->GfxLookUp(} associateNode {)} ENDNATIVE !!APTR
->NATIVE {VideoControl} PROC
PROC VideoControl( colorMap:PTR TO colormap, tagarray:ARRAY OF tagitem ) IS NATIVE {IGraphics->VideoControl(} colorMap {,} tagarray {)} ENDNATIVE !!ULONG
->NATIVE {VideoControlTags} PROC
->PROC VideoControlTags( colorMap:PTR TO colormap, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {-IGraphics->VideoControlTags(} colorMap {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!INT
->NATIVE {OpenMonitor} PROC
PROC OpenMonitor( monitorName:ARRAY OF CHAR /*STRPTR*/, displayID:ULONG ) IS NATIVE {IGraphics->OpenMonitor(} monitorName {,} displayID {)} ENDNATIVE !!PTR TO monitorspec
->NATIVE {CloseMonitor} PROC
PROC CloseMonitor( monitorSpec:PTR TO monitorspec ) IS NATIVE {IGraphics->CloseMonitor(} monitorSpec {)} ENDNATIVE !!VALUE
->NATIVE {FindDisplayInfo} PROC
PROC FindDisplayInfo( displayID:ULONG ) IS NATIVE {IGraphics->FindDisplayInfo(} displayID {)} ENDNATIVE !!DISPLAYINFOHANDLE
->NATIVE {NextDisplayInfo} PROC
PROC NextDisplayInfo( displayID:ULONG ) IS NATIVE {IGraphics->NextDisplayInfo(} displayID {)} ENDNATIVE !!ULONG
->NATIVE {GetDisplayInfoData} PROC
PROC GetDisplayInfoData( handle:DISPLAYINFOHANDLE, buf:APTR, size:ULONG, tagID:ULONG, displayID:ULONG ) IS NATIVE {IGraphics->GetDisplayInfoData(} handle {,} buf {,} size {,} tagID {,} displayID {)} ENDNATIVE !!ULONG
->NATIVE {FontExtent} PROC
PROC FontExtent( font:PTR TO textfont, fontExtent:PTR TO textextent ) IS NATIVE {IGraphics->FontExtent(} font {,} fontExtent {)} ENDNATIVE
->NATIVE {ReadPixelLine8} PROC
PROC ReadPixelLine8( rp:PTR TO rastport, xstart:ULONG, ystart:ULONG, width:ULONG, array:ARRAY OF UBYTE, tempRP:PTR TO rastport ) IS NATIVE {IGraphics->ReadPixelLine8(} rp {,} xstart {,} ystart {,} width {,} array {,} tempRP {)} ENDNATIVE !!VALUE
->NATIVE {WritePixelLine8} PROC
PROC WritePixelLine8( rp:PTR TO rastport, xstart:ULONG, ystart:ULONG, width:ULONG, array:ARRAY OF UBYTE, tempRP:PTR TO rastport ) IS NATIVE {IGraphics->WritePixelLine8(} rp {,} xstart {,} ystart {,} width {,} array {,} tempRP {)} ENDNATIVE !!VALUE
->NATIVE {ReadPixelArray8} PROC
PROC ReadPixelArray8( rp:PTR TO rastport, xstart:ULONG, ystart:ULONG, xstop:ULONG, ystop:ULONG, array:ARRAY OF UBYTE, temprp:PTR TO rastport ) IS NATIVE {IGraphics->ReadPixelArray8(} rp {,} xstart {,} ystart {,} xstop {,} ystop {,} array {,} temprp {)} ENDNATIVE !!VALUE
->NATIVE {WritePixelArray8} PROC
PROC WritePixelArray8( rp:PTR TO rastport, xstart:ULONG, ystart:ULONG, xstop:ULONG, ystop:ULONG, array:ARRAY OF UBYTE, temprp:PTR TO rastport ) IS NATIVE {IGraphics->WritePixelArray8(} rp {,} xstart {,} ystart {,} xstop {,} ystop {,} array {,} temprp {)} ENDNATIVE !!VALUE
->NATIVE {GetVPModeID} PROC
PROC GetVPModeID( vp:PTR TO viewport ) IS NATIVE {IGraphics->GetVPModeID(} vp {)} ENDNATIVE !!ULONG
->NATIVE {ModeNotAvailable} PROC
PROC ModeNotAvailable( modeID:ULONG ) IS NATIVE {IGraphics->ModeNotAvailable(} modeID {)} ENDNATIVE !!ULONG
->NATIVE {EraseRect} PROC
PROC EraseRect( rp:PTR TO rastport, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE ) IS NATIVE {IGraphics->EraseRect(} rp {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
->NATIVE {ExtendFont} PROC
PROC ExtendFont( font:PTR TO textfont, fontTags:ARRAY OF tagitem ) IS NATIVE {IGraphics->ExtendFont(} font {,} fontTags {)} ENDNATIVE !!ULONG
->NATIVE {ExtendFontTags} PROC
->PROC ExtendFontTags( font:PTR TO textfont, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->ExtendFontTags(} font {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {StripFont} PROC
PROC StripFont( font:PTR TO textfont ) IS NATIVE {IGraphics->StripFont(} font {)} ENDNATIVE
/*--- functions in V39 or higher (Release 3) ---*/
->NATIVE {CalcIVG} PROC
PROC CalcIVG( v:PTR TO view, vp:PTR TO viewport ) IS NATIVE {IGraphics->CalcIVG(} v {,} vp {)} ENDNATIVE !!UINT
->NATIVE {AttachPalExtra} PROC
PROC AttachPalExtra( cm:PTR TO colormap, vp:PTR TO viewport ) IS NATIVE {IGraphics->AttachPalExtra(} cm {,} vp {)} ENDNATIVE !!VALUE
->NATIVE {ObtainBestPenA} PROC
PROC ObtainBestPenA( cm:PTR TO colormap, r:ULONG, g:ULONG, b:ULONG, tags:ARRAY OF tagitem ) IS NATIVE {IGraphics->ObtainBestPenA(} cm {,} r {,} g {,} b {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {ObtainBestPen} PROC
PROC ObtainBestPen( cm:PTR TO colormap, r:ULONG, g:ULONG, b:ULONG, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->ObtainBestPen(} cm {,} r {,} g {,} b {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {SetRGB32} PROC
PROC SetRGB32( vp:PTR TO viewport, n:ULONG, r:ULONG, g:ULONG, b:ULONG ) IS NATIVE {IGraphics->SetRGB32(} vp {,} n {,} r {,} g {,} b {)} ENDNATIVE
->NATIVE {GetAPen} PROC
PROC GetAPen( rp:PTR TO rastport ) IS NATIVE {IGraphics->GetAPen(} rp {)} ENDNATIVE !!ULONG
->NATIVE {GetBPen} PROC
PROC GetBPen( rp:PTR TO rastport ) IS NATIVE {IGraphics->GetBPen(} rp {)} ENDNATIVE !!ULONG
->NATIVE {GetDrMd} PROC
PROC GetDrMd( rp:PTR TO rastport ) IS NATIVE {IGraphics->GetDrMd(} rp {)} ENDNATIVE !!ULONG
->NATIVE {GetOutlinePen} PROC
PROC GetOutlinePen( rp:PTR TO rastport ) IS NATIVE {IGraphics->GetOutlinePen(} rp {)} ENDNATIVE !!ULONG
->NATIVE {LoadRGB32} PROC
PROC LoadRGB32( vp:PTR TO viewport, table:ARRAY OF ULONG ) IS NATIVE {IGraphics->LoadRGB32(} vp {,} table {)} ENDNATIVE
->NATIVE {SetChipRev} PROC
PROC SetChipRev( want:ULONG ) IS NATIVE {IGraphics->SetChipRev(} want {)} ENDNATIVE !!ULONG
->NATIVE {SetABPenDrMd} PROC
PROC SetABPenDrMd( rp:PTR TO rastport, apen:ULONG, bpen:ULONG, drawmode:ULONG ) IS NATIVE {IGraphics->SetABPenDrMd(} rp {,} apen {,} bpen {,} drawmode {)} ENDNATIVE
->NATIVE {GetRGB32} PROC
PROC GetRGB32( cm:PTR TO colormap, firstcolor:ULONG, ncolors:ULONG, table:ARRAY OF ULONG ) IS NATIVE {IGraphics->GetRGB32(} cm {,} firstcolor {,} ncolors {,} table {)} ENDNATIVE
->NATIVE {AllocBitMap} PROC
PROC AllocBitMap( sizex:ULONG, sizey:ULONG, depth:ULONG, flags:ULONG, friend_bitmap:PTR TO bitmap ) IS NATIVE {IGraphics->AllocBitMap(} sizex {,} sizey {,} depth {,} flags {,} friend_bitmap {)} ENDNATIVE !!PTR TO bitmap
->NATIVE {FreeBitMap} PROC
PROC FreeBitMap( bm:PTR TO bitmap ) IS NATIVE {IGraphics->FreeBitMap(} bm {)} ENDNATIVE
->NATIVE {GetExtSpriteA} PROC
PROC GetExtSpriteA( ss:PTR TO extsprite, tags:ARRAY OF tagitem ) IS NATIVE {IGraphics->GetExtSpriteA(} ss {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {GetExtSprite} PROC
PROC GetExtSprite( ss:PTR TO extsprite, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->GetExtSprite(} ss {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {CoerceMode} PROC
PROC CoerceMode( vp:PTR TO viewport, monitorid:ULONG, flags:ULONG ) IS NATIVE {IGraphics->CoerceMode(} vp {,} monitorid {,} flags {)} ENDNATIVE !!ULONG
->NATIVE {ChangeVPBitMap} PROC
PROC ChangeVPBitMap( vp:PTR TO viewport, bm:PTR TO bitmap, db:PTR TO dbufinfo ) IS NATIVE {IGraphics->ChangeVPBitMap(} vp {,} bm {,} db {)} ENDNATIVE
->NATIVE {ReleasePen} PROC
PROC ReleasePen( cm:PTR TO colormap, n:VALUE ) IS NATIVE {IGraphics->ReleasePen(} cm {,} n {)} ENDNATIVE
->NATIVE {ObtainPen} PROC
PROC ObtainPen( cm:PTR TO colormap, n:VALUE, r:ULONG, g:ULONG, b:ULONG, f:VALUE ) IS NATIVE {IGraphics->ObtainPen(} cm {,} n {,} r {,} g {,} b {,} f {)} ENDNATIVE !!VALUE
->NATIVE {GetBitMapAttr} PROC
PROC GetBitMapAttr( bm:PTR TO bitmap, attrnum:ULONG ) IS NATIVE {IGraphics->GetBitMapAttr(} bm {,} attrnum {)} ENDNATIVE !!ULONG
->NATIVE {AllocDBufInfo} PROC
PROC AllocDBufInfo( vp:PTR TO viewport ) IS NATIVE {IGraphics->AllocDBufInfo(} vp {)} ENDNATIVE !!PTR TO dbufinfo
->NATIVE {FreeDBufInfo} PROC
PROC FreeDBufInfo( dbi:PTR TO dbufinfo ) IS NATIVE {IGraphics->FreeDBufInfo(} dbi {)} ENDNATIVE
->NATIVE {SetOutlinePen} PROC
PROC SetOutlinePen( rp:PTR TO rastport, pen:ULONG ) IS NATIVE {IGraphics->SetOutlinePen(} rp {,} pen {)} ENDNATIVE !!ULONG
->NATIVE {SetWriteMask} PROC
PROC SetWriteMask( rp:PTR TO rastport, msk:ULONG ) IS NATIVE {IGraphics->SetWriteMask(} rp {,} msk {)} ENDNATIVE !!ULONG
->NATIVE {SetMaxPen} PROC
PROC SetMaxPen( rp:PTR TO rastport, maxpen:ULONG ) IS NATIVE {IGraphics->SetMaxPen(} rp {,} maxpen {)} ENDNATIVE
->NATIVE {SetRGB32CM} PROC
PROC SetRGB32CM( cm:PTR TO colormap, n:ULONG, r:ULONG, g:ULONG, b:ULONG ) IS NATIVE {IGraphics->SetRGB32CM(} cm {,} n {,} r {,} g {,} b {)} ENDNATIVE
->NATIVE {ScrollRasterBF} PROC
PROC ScrollRasterBF( rp:PTR TO rastport, dx:VALUE, dy:VALUE, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE ) IS NATIVE {IGraphics->ScrollRasterBF(} rp {,} dx {,} dy {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
->NATIVE {FindColor} PROC
PROC FindColor( cm:PTR TO colormap, r:ULONG, g:ULONG, b:ULONG, maxcolor:VALUE ) IS NATIVE {IGraphics->FindColor(} cm {,} r {,} g {,} b {,} maxcolor {)} ENDNATIVE !!UINT
->NATIVE {AllocSpriteDataA} PROC
PROC AllocSpriteDataA( bm:PTR TO bitmap, tags:ARRAY OF tagitem ) IS NATIVE {IGraphics->AllocSpriteDataA(} bm {,} tags {)} ENDNATIVE !!PTR TO extsprite
->NATIVE {AllocSpriteData} PROC
PROC AllocSpriteData( bm:PTR TO bitmap, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->AllocSpriteData(} bm {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!PTR TO extsprite
->NATIVE {ChangeExtSpriteA} PROC
PROC ChangeExtSpriteA( vp:PTR TO viewport, oldsprite:PTR TO extsprite, newsprite:PTR TO extsprite, tags:ARRAY OF tagitem ) IS NATIVE {IGraphics->ChangeExtSpriteA(} vp {,} oldsprite {,} newsprite {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {ChangeExtSprite} PROC
PROC ChangeExtSprite( vp:PTR TO viewport, oldsprite:PTR TO extsprite, newsprite:PTR TO extsprite, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->ChangeExtSprite(} vp {,} oldsprite {,} newsprite {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {FreeSpriteData} PROC
PROC FreeSpriteData( sp:PTR TO extsprite ) IS NATIVE {IGraphics->FreeSpriteData(} sp {)} ENDNATIVE
->NATIVE {SetRPAttrsA} PROC
PROC SetRPAttrsA( rp:PTR TO rastport, tags:ARRAY OF tagitem ) IS NATIVE {IGraphics->SetRPAttrsA(} rp {,} tags {)} ENDNATIVE
->NATIVE {SetRPAttrs} PROC
PROC SetRPAttrs( rp:PTR TO rastport, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->SetRPAttrs(} rp {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE
->NATIVE {GetRPAttrsA} PROC
PROC GetRPAttrsA( rp:PTR TO rastport, tags:ARRAY OF tagitem ) IS NATIVE {IGraphics->GetRPAttrsA(} rp {,} tags {)} ENDNATIVE
->NATIVE {GetRPAttrs} PROC
PROC GetRPAttrs( rp:PTR TO rastport, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->GetRPAttrs(} rp {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE
->NATIVE {BestModeIDA} PROC
PROC BestModeIDA( tags:ARRAY OF tagitem ) IS NATIVE {IGraphics->BestModeIDA(} tags {)} ENDNATIVE !!ULONG
->NATIVE {BestModeID} PROC
PROC BestModeID( tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IGraphics->BestModeID(} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!ULONG
/*--- functions in V40 or higher (Release 3.1) ---*/
->NATIVE {WriteChunkyPixels} PROC
PROC WriteChunkyPixels( rp:PTR TO rastport, xstart:ULONG, ystart:ULONG, xstop:ULONG, ystop:ULONG, array:ARRAY OF UBYTE, bytesperrow:VALUE ) IS NATIVE {IGraphics->WriteChunkyPixels(} rp {,} xstart {,} ystart {,} xstop {,} ystop {,} array {,} bytesperrow {)} ENDNATIVE

->missing from clib:
PROC CompositeTagList(operator, source:PTR TO bitmap, destination:PTR TO bitmap, tags:ARRAY OF tagitem) IS NATIVE {IGraphics->CompositeTagList(} operator {,} source {,} destination {,} tags {)} ENDNATIVE !!VALUE
