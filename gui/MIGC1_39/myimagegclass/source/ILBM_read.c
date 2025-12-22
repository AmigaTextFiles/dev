//-----------------------------------------------------------------------------
// ILBM_read.c - makes a color font hack 8 out of an iff picture
// 08 Jan 1994
// R. Reed
// $Id: ILBM_read.c,v 1.1 94/01/11 03:02:19 rick Exp Locker: rick $
//-----------------------------------------------------------------------------

#include <exec/memory.h>
#include <libraries/iffparse.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/iffparse.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_PLANES   8

struct BitMapHeader
{
	UWORD w,h;
	WORD  x,y;
	UBYTE nPlanes;
	UBYTE masking;
	UBYTE compression;
	UBYTE pad1;
	UWORD transparentColor;
	UBYTE xAspect,yAspect;
	WORD  pageWidth,pageHeight;
};

// STATIC GLOBALS --------------------------------------------------------------
static WORD width, height; // these pass info from bitmap loader to image loader
static UBYTE depth;

// PROGRAM ---------------------------------------------------------------------

static BOOL DecompressLine(struct IFFHandle *iff, UBYTE *buffer, UWORD byteWidth)
{
   BYTE data, *endPos;

   endPos = buffer + byteWidth;

   do
   {
      if (ReadChunkBytes(iff, &data, 1) < 0)  break;
      if ((data >= 0) && (data <= 127))
      {
         if (ReadChunkBytes(iff, buffer, data+1) < 0)  break;
         buffer += data+1;
      }
      else if ((data >= -127) && (data <= -1))
      {
         register short i;
         BYTE repeatByte;

         if (ReadChunkBytes(iff, &repeatByte, 1) < 0)  break;
         for (i = 0; i < -data+1; i++, buffer++)
            *buffer = repeatByte;
      }
   }
   while (buffer < endPos);
   return((BOOL)((buffer < endPos)?FALSE:TRUE));
}

static BOOL DecodeBody(struct IFFHandle *iff, struct BitMap *bm, UBYTE compression)
{
   PLANEPTR rowPtr[MAX_PLANES];
   BOOL ok;
   register short row, p;

   memcpy(rowPtr, bm->Planes, sizeof(PLANEPTR)*bm->Depth);

   if (compression)
      for (row = 0; row < bm->Rows; row++)
      {
         for (p = 0; p < bm->Depth; rowPtr[p++]+=bm->BytesPerRow)
            if (!(ok = DecompressLine(iff, rowPtr[p], bm->BytesPerRow)))
               break;
         if (!ok)  break;
      }
   else
      for (row = 0; row < bm->Rows; row++)
      {
         for (p = 0; p < bm->Depth; rowPtr[p++]+=bm->BytesPerRow)
            if (!(ok = ReadChunkBytes(iff, rowPtr[p], bm->BytesPerRow)))
               break;
         if (!ok)  break;
      }
   return(ok);
}

static BOOL ProcessCMAP(struct IFFHandle *iff, UWORD *colorTable)
{
   struct StoredProperty *sp;

   if (sp = FindProp(iff, 'ILBM', 'CMAP'))
   {
      struct RGB {UBYTE r,g,b;} *color;
      register short i, maxColors;

      color = (struct RGB *)sp->sp_Data;
      maxColors = sp->sp_Size/3;

      for (i = 0; i < maxColors; i++, color++,colorTable++)
      {
         color->r >>= 4;  color->g >>= 4;  color->b >>= 4;
         *colorTable = (color->r<<8)|(color->g<<4)|color->b;
      }
      return(TRUE);
   }
   else
      return(FALSE);
}

WORD ReadILBM2BitMap(char *name, struct BitMap *bm, UWORD *colorTable)
{
   struct IFFHandle *iff;
   struct BitMapHeader *bmhd;
   WORD error = 0;

   if ((iff = AllocIFF()) && (iff->iff_Stream = Open(name, MODE_OLDFILE)))
   {
      InitIFFasDOS(iff);
      if (!OpenIFF(iff, IFFF_READ))
      {
         PropChunk(iff, 'ILBM', 'BMHD');
         PropChunk(iff, 'ILBM', 'CMAP');
         StopChunk(iff, 'ILBM', 'BODY');
         if (!ParseIFF(iff, IFFPARSE_SCAN))
         {
            struct StoredProperty *sp;

            if (sp = FindProp(iff, 'ILBM', 'BMHD'))
            {
               PLANEPTR planeStart;
               ULONG planeSize;

               bmhd = (struct BitMapHeader *)sp->sp_Data;
               width = bmhd->w;  height = bmhd->h;  depth = bmhd->nPlanes;
               InitBitMap(bm, bmhd->nPlanes,bmhd->w,bmhd->h);
               planeSize = RASSIZE(bmhd->w,bmhd->h);
               if (planeStart = (PLANEPTR)AllocVec(planeSize*bmhd->nPlanes,MEMF_CHIP))
               {
                  register short i;

                  for (i = 0; i < bmhd->nPlanes; i++, planeStart += planeSize)
                     bm->Planes[i] = planeStart;

                  if (colorTable)
                     ProcessCMAP(iff, colorTable);

                  error = DecodeBody(iff, bm, bmhd->compression)?0:IFFERR_MANGLED;
               }
               else
                  error = IFFERR_NOMEM;
            }
            else
               error = IFFERR_SYNTAX;
         }
         else
            error = IFFERR_READ;

         CloseIFF(iff);
      }
      else
         error = IFFERR_READ;

      Close(iff->iff_Stream);
   }
   return(error);
}

WORD ReadILBM2Image(char *name, struct Image *image, UWORD *colorTable)
{
   struct BitMap bitMap;
   WORD error;

   if (!(error = ReadILBM2BitMap(name, &bitMap, colorTable)))
   {
      image->LeftEdge = image->TopEdge = 0;
      image->Width = width;
      image->Height = height;
      image->Depth = depth;
      image->ImageData = (UWORD *)bitMap.Planes[0];
      image->PlanePick = (0xff>>(MAX_PLANES-depth));
      image->PlaneOnOff = 0;
      image->NextImage = NULL;
   }
   return(error);
}
