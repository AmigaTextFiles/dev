/***************************************************************************
 * graphics_pak.c - general-purpose graphics functions to make programming *
 *               alot easier!                                              *
 * ----------------------------------------------------------------------- *
 * Author: Paul T. Miller                                                  *
 * ----------------------------------------------------------------------- *
 * Modification History:                                                   *
 * ---------------------                                                   *
 * Date     Comment                                                        *
 * -------- -------                                                        *
 * 05-09-90 Bring AllocBitMap into the graphics package
 * 05-18-90 DrawLine()
 *
 ***************************************************************************/

#ifndef GRAPHICS_PAK_H
#include "graphics_pak.h"
#endif

#include <proto/graphics.h>

extern struct IntuitionBase *IntuitionBase;
extern struct DiskfontBase *DiskfontBase;
struct Library *LayersBase;

static int openflags;

OpenLibraries(flags)
UWORD flags;
{
   openflags = NULL;

   if (flags & INTUITIONBASE)
   {
      IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",0);
      openflags |= INTUITIONBASE;
   }
   if (flags & GFXBASE)
   {
      GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",0);
      openflags |= GFXBASE;
   }
   if (flags & LAYERSBASE)
   {
      LayersBase = (struct LayersBase *)OpenLibrary("layers.library",0);
      openflags |= LAYERSBASE;
   }
   if (flags & DISKFONTBASE)
   {
      DiskfontBase = (struct DiskfontBase *)OpenLibrary("diskfont.library",0);
      if (DiskfontBase)
         openflags |= DISKFONTBASE;
   }
   return(openflags);
}

void CloseLibraries()
{
   if (openflags & GFXBASE)
      if (GfxBase) CloseLibrary((struct Library *)GfxBase);
   if (openflags & INTUITIONBASE)
      if (IntuitionBase) CloseLibrary((struct Library *)IntuitionBase);
   if (openflags & LAYERSBASE)
      if (LayersBase) CloseLibrary(LayersBase);
   if (openflags & DISKFONTBASE)
      if (DiskfontBase) CloseLibrary((struct Library *)DiskfontBase);

   openflags = NULL;
}

void DrawPixel(rp, x, y, c)
register struct RastPort *rp;
register int x, y, c;
{
   SetAPen(rp, c);
   WritePixel(rp, x, y);
}

void DrawLine(rp, x1, y1, x2, y2, c)
struct RastPort *rp;
int x1, y1, x2, y2, c;
{
   SetAPen(rp, c);
   Move(rp, x1, y1);
   Draw(rp, x2, y2);
}

void DrawBox(rp, x, y, w, h, c)
struct RastPort *rp;
int x, y, w, h, c;
{
   SetAPen(rp, c);
   Move(rp, x, y);
   Draw(rp, x+w, y);
   Draw(rp, x+w, y+h);
   Draw(rp, x, y+h);
   Draw(rp, x, y);
}

void FillBox(rp, x, y, w, h, c)
struct RastPort *rp;
int x, y, w, h, c;
{
   SetAPen(rp, c);
   RectFill(rp, x, y, x+w, y+h);
}

void WriteText(rport, x, y, text, color)
struct RastPort *rport;
long x, y, color;
char *text;
{
   Move(rport, x, y);
   SetAPen(rport, color);
   SetDrMd(rport, JAM1);
   Text(rport, text, strlen(text));
}

struct BitMap *AllocBitMap(width, height, depth, flags)
USHORT width, height;
UBYTE depth, flags;
{
   struct BitMap *bm;
   register int i;
   long memsize = RASSIZE(width, height);

   bm = (struct BitMap *)AllocMem(sizeof(struct BitMap), MEMF_CLEAR);
   if (bm)
   {
      InitBitMap(bm, (long)depth, (long)width, (long)height);

      for (i = 0; i < depth; i++)
      {
         if (flags & FASTMEM)
            bm->Planes[i] = (PLANEPTR)AllocMem(memsize, MEMF_CLEAR);
         else
            bm->Planes[i] = (PLANEPTR)AllocMem(memsize, MEMF_CHIP|MEMF_CLEAR);
         if (!bm->Planes[i])
         {
            FreeBitMap(bm);
            return(NULL);
         }
      }
   }
   return(bm);
}

void FreeBitMap(bm)
struct BitMap *bm;
{
   register int i;

   if (bm)
   {
      for (i = 0; i < bm->Depth; i++)
         if (bm->Planes[i])
            FreeMem(bm->Planes[i], (long)(bm->BytesPerRow * bm->Rows));
      FreeMem(bm, sizeof(struct BitMap));
   }
}

void MoveBitMap(source, x, y, w, h, dest, dx, dy)
struct BitMap *source, *dest;
int x, y, w, h, dx, dy;
{
   if (source && dest)
      BltBitMap(source, x, y, dest, dx, dy, w, h, 0xc0, 0xff, NULL);
}

void DrawBitMap(source, x, y, w, h, dest)
struct BitMap *source, *dest;
int x, y, w, h;
{
   if (source && dest)
      BltBitMap(source, 0, 0, dest, x, y, w, h, 0xc0, 0xff, NULL);
}

void CopyBitMap(source, x, y, w, h, dest)
struct BitMap *source, *dest;
int x, y, w, h;
{
   if (source && dest)
      BltBitMap(source, x, y, dest, 0, 0, w, h, 0xc0, 0xff, NULL);
}
