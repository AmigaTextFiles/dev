#ifndef  CLIB_BLITTER_PROTOS_H
#define  CLIB_BLITTER_PROTOS_H

/*
**   $VER: blitter_protos.h V2.1
**
**   C prototypes.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef MODULES_BLTBASE_H
#include <modules/bltbase.h>
#endif

#ifndef _USE_DPKBASE

APTR AllocBlitMem(LONG Size, LONG Flags);
void BlitArea(struct Bitmap *, struct Bitmap *, WORD XStart, WORD YStart, WORD Width, WORD Height, WORD XDest, WORD YDest, WORD Remap);
void CopyBuffer(struct GScreen *, WORD SrcBuffer, WORD DestBuffer);
LONG CopyLine(struct Bitmap *SrcBitmap, struct Bitmap *DestBitmap, WORD SrcY, WORD DestY, WORD AmtPixels, WORD Remap);
LONG CreateMasks(APTR Bob);
void DrawBob(APTR Bob);
void DrawBobList(LONG *BobList);
void DrawLine(struct Bitmap *, WORD SX, WORD SY, WORD EX, WORD EY, LONG Colour, LONG Mask);
void DrawPen(struct Bitmap *, WORD X, WORD Y);
void DrawPixel(struct Bitmap *, WORD XCoord, WORD YCoord, LONG Colour);
void DrawPixelList(struct Bitmap *, struct PixelList *);
void DrawRGBLine(struct Bitmap *, WORD SX, WORD SY, WORD EX, WORD EY, LONG RGB, LONG Mask);
void DrawRGBPixel(struct Bitmap *, WORD XCoord, WORD YCoord, LONG RGB);
void DrawRGBPixelList(struct Bitmap *, struct PixelList *);
void DrawUCLine(struct Bitmap *, WORD SX, WORD SY, WORD EX, WORD EY, LONG Colour, LONG Mask);
void DrawUCPixel(struct Bitmap *, WORD XCoord, WORD YCoord, LONG Colour);
void DrawUCPixelList(struct Bitmap *, struct PixelList *);
void DrawUCRGBLine(struct Bitmap *, WORD SX, WORD SY, WORD EX, WORD EY, LONG RGB, LONG Mask);
void DrawUCRGBPixel(struct Bitmap *, WORD XCoord, WORD YCoord, LONG RGB);
void FlipHBitmap(struct Bitmap *);
void FlipVBitmap(struct Bitmap *);
void Flood(struct Bitmap *, WORD X, WORD Y, LONG RGB);
void FreeBlitMem(APTR MemBlock);
LONG GetBmpType(void);
LONG GetRGBPen(struct Bitmap *);
void GiveOSBlitter(void);
void PenCircle(struct Bitmap *, WORD X, WORD Y, WORD Radius, WORD Fill);
void PenEllipse(struct Bitmap *, WORD X, WORD Y, WORD RadiusX, WORD RadiusY, WORD Fill);
void PenLine(struct Bitmap *, WORD SX, WORD SY, WORD EX, WORD EY, LONG Mask);
void PenLinePxl(struct Bitmap *, WORD SX, WORD SY, WORD EX, WORD EY, LONG Mask);
void PenPixel(struct Bitmap *, WORD X, WORD Y);
void PenRect(struct Bitmap *, WORD X, WORD Y, WORD Width, WORD Height, WORD Fill);
void PenUCLine(struct Bitmap *, WORD SX, WORD SY, WORD EX, WORD EY, LONG Mask);
LONG ReadPixel(struct Bitmap *, WORD XCoord, WORD YCoord);
LONG ReadRGBPixel(struct Bitmap *, WORD XCoord, WORD YCoord);
void ReadPixelList(struct Bitmap *, struct PixelList *);
void SetBobDimensions(APTR Bob, WORD Width, WORD Height, WORD Depth);
LONG SetBobDrawMode(APTR Bob, LONG Attrib);
LONG SetBobFrames(APTR Bob);
void SetPenShape(struct Bitmap *Bitmap, WORD Shape, WORD Radius);
LONG SetRGBPen(struct Bitmap *, LONG RGB);
void SortBobList(APTR List, LONG Flags);
void SortMBob(struct MBob *, LONG Flags);
void TakeOSBlitter(void);

#else /*** Definitions for inline library calls ***/

#define AllocBlitMem(Size,Flags)           BLTBase->AllocBlitMem(Size,Flags)
#define BlitArea(Sr,Ds,XS,YS,W,H,XD,YD,Rm) BLTBase->BlitArea(Sr,Ds,XS,YS,W,H,XD,YD,Rm)
#define CopyBuffer(Screen,Src,Dest)        BLTBase->CopyBuffer(Screen,Src,Dest)
#define CopyLine(Src,Dst,SY,DY,Pix,Remap)  BLTBase->CopyLine(Src,Dst,SY,DY,Pix,Remap)
#define CreateMasks(Bob)                   BLTBase->CreateMasks(Bob)
#define DrawBob(Bob)                       BLTBase->DrawBob(Bob)
#define DrawBobList(BobList)               BLTBase->DrawBobList(BobList)
#define DrawLine(Bmp,SX,SY,EX,EY,Col,Msk)  BLTBase->DrawLine(Bmp,SX,SY,EX,EY,Col,Msk)
#define DrawPen(Bmp,X,Y)                   BLTBase->DrawPen(Bmp,X,Y)
#define DrawPixel(Bmp,X,Y,Col)             BLTBase->DrawPixel(Bmp,X,Y,Col)
#define DrawPixelList(Bmp,Pixels)          BLTBase->DrawPixelList(Bmp,Pixels)
#define DrawRGBLine(Bmp,SX,SY,EX,EY,RGB,M) BLTBase->DrawRGBLine(Bmp,SX,SY,EX,EY,RGB,M)
#define DrawRGBPixel(Bmp,X,Y,RGB)          BLTBase->DrawRGBPixel(Bmp,X,Y,RGB)
#define DrawRGBPixelList(Bmp, PixelList)   BLTBase->DrawRGBPixelList(Bmp,PixelList)
#define DrawUCLine(Bmp,SX,SY,EX,EY,Col,M)  BLTBase->DrawUCLine(Bmp,SX,SY,EX,EY,Col,M)
#define DrawUCPixel(Bmp,X,Y,Col)           BLTBase->DrawUCPixel(Bmp,X,Y,Col)
#define DrawUCPixelList(Bmp, Pixels)       BLTBase->DrawUCPixelList(Bmp,Pixels)
#define DrawUCRGBLine(Bmp,SX,SY,EX,EY,R,M) BLTBase->DrawUCRGBLine(Bmp,SX,SY,EX,EY,R,M)
#define DrawUCRGBPixel(Bmp,X,Y,RGB)        BLTBase->DrawUCRGBPixel(Bmp,X,Y,RGB)
#define FlipHBitmap(Bmp)                   BLTBase->FlipHBitmap(Bmp)
#define FlipVBitmap(Bmp)                   BLTBase->FlipVBitmap(Bmp)
#define Flood(Bmp,X,Y,RGB)                 BLTBase->Flood(Bmp,X,Y,RGB)
#define FreeBlitMem(MemBlock)              BLTBase->FreeBlitMem(MemBlock)
#define GetBmpType()                       BLTBase->GetBmpType()
#define GetRGBPen(Bmp)                     BLTBase->GetRGBPen(Bmp)
#define GiveOSBlitter()                    BLTBase->GiveOSBlitter()
#define PenCircle(Bmp,X,Y,Rad,Fill)        BLTBase->PenCircle(Bmp,X,Y,Rad,Fill)
#define PenEllipse(Bmp,X,Y,RX,RY,Fill)     BLTBase->PenEllipse(Bmp,X,Y,RX,RY,Fill)
#define PenLine(Bmp,SX,SY,EX,EY,Mask)      BLTBase->PenLine(Bmp,SX,SY,EX,EY,Mask)
#define PenLinePxl(Bmp,SX,SY,EX,EY,Mask)   BLTBase->PenLinePxl(Bmp,SX,SY,EX,EY,Mask)
#define PenPixel(Bmp,X,Y)                  BLTBase->PenPixel(Bmp,X,Y)
#define PenRect(Bmp,X,Y,W,H,Fill)          BLTBase->DrawRect(Bmp,X,Y,W,H,Fill)
#define PenUCLine(Bmp,SX,SY,EX,EY,Mask)    BLTBase->PenUCLine(Bmp,SX,SY,EX,EY,Mask)
#define ReadPixel(Bmp,X,Y)                 BLTBase->ReadPixel(Bmp,X,Y)
#define ReadRGBPixel(Bmp,X,Y)              BLTBase->ReadRGBPixel(Bmp,X,Y)
#define ReadPixelList(Bmp,Pixels)          BLTBase->ReadPixelList(Bmp,Pixels)
#define SetBobDimensions(Bob,W,H,D)        BLTBase->SetBobDimensions(Bob,W,H,D)
#define SetBobDrawMode(Bob, Attrib)        BLTBase->SetBobDrawMode(Bob,Attrib)
#define SetBobFrames(Bob)                  BLTBase->SetBobFrames(Bob)
#define SetPenShape(Bmp,Shape,Radius)      BLTBase->SetPenShape(Bmp,Shape,Radius)
#define SetRGBPen(Bmp,RGB)                 BLTBase->SetRGBPen(Bmp,RGB)
#define SortBobList(List, Flags)           BLTBase->SortBobList(List,Flags)
#define SortMBob(MBob, Flags)              BLTBase->SortMBob(MBob,Flags)
#define TakeOSBlitter()                    BLTBase->TakeOSBlitter()

#endif /* _USE_DPKBASE */

#endif /* CLIB_BLITTER_PROTOS_H */
