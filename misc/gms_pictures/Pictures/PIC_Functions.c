
#include <proto/dpkernel.h>
#include <system/all.h>
#include <dpkernel/prefs.h>
#include "defs.h"

/***********************************************************************************
** Internal: UnpackPicture()
**
** Unpacks the BODY data to the Picture->Bitmap.  If the palettes or amount of
** colours do not match, the picture will be automatically remapped.
*/

LONG UnpackPicture(struct Picture *Picture, struct BMHD *BMHD,
                   struct File *File, LONG *CMAP, LONG CAMG)
{
  struct Bitmap *Bitmap;
  struct Bitmap *ILBMBitmap = NULL;
  WORD   MaxWidth;
  LONG   Colour;
  WORD   i, y, j, ydest;
  WORD   XRemainder, YRemainder, Domain;
  LONG   AmtColours;
  WORD   Height;
  WORD   BPos;
  BYTE   *DestPalette;
  BYTE   *SrcPalette;
  BYTE   *SrcBData;
  BYTE   *DestBData;
  BYTE   *Dest;
  LONG   *Palette = NULL;
  BYTE   *Buffer  = NULL;
  APTR   BLTBase  = GVBase->BlitterBase;
  LONG   ecode    = ERR_FAILED;

  DPrintF("UnpackPicture()","Unpacking ILBM picture to destination...");

  if (Picture->Options & IMG_RESIZE) {
     DPrintF("UnpackPicture:","Note that the image will need to be resized.");
  }

  DPrintF("3UnpackPicture:","Allocating an unpack buffer of %ld bytes.",UNPACKSIZE);

  if ((Buffer = AllocMemBlock(UNPACKSIZE, MEM_DATA)) IS NULL) {
     goto exit;
  }

  Bitmap     = Picture->Bitmap;
  YRemainder = NULL;

  if ((Height = Bitmap->Height) > BMHD->Height) {
     Height = BMHD->Height;
  }

  /*** Calculate the amount of colours in the ILBM BMHD source. ***/

  if (CMAP) {
     if ((BMHD->Depth < 1) OR (BMHD->Depth > 8)) {
        DPrintF("!UnpackPicture:","Incorrect/Unsupported plane depth (%d).",BMHD->Depth);
     }

     AmtColours = 1;
     for (i=0; i < BMHD->Depth; i++) {
         AmtColours *= 2;
     }

     /* Build the palette here and use it in the ILBM Bitmap.  This is
     ** necessary for ReadRGBPixel() functions which we use further down.
     */

     if (Palette = AllocMemBlock((AmtColours * 4)+8,MEM_DATA)) {
        Palette[0] = PALETTE_ARRAY;
        Palette[1] = AmtColours;

        SrcPalette  = (BYTE *)CMAP;
        DestPalette = ((BYTE *)Palette)+8;
        for (i=0; i < AmtColours; i++) {
           DestPalette[1] = SrcPalette[0];
           DestPalette[2] = SrcPalette[1];
           DestPalette[3] = SrcPalette[2];
           DestPalette += 4;
           SrcPalette  += 3;
        }
     }
     else goto exit;
  }

  DPrintF("3UnpackPicture:","Allocating dummy Bitmap.");

  if (!(ILBMBitmap = InitTags(NULL,
       TAGS_BITMAP, NULL,
       BMA_Width,   BMHD->Width,
       BMA_Height,  1,
       BMA_Planes,  BMHD->Depth,
       BMA_Type,    ILBM,
       BMA_Palette, Palette,
       TAGEND))) {
       goto exit;
  }

  /*** Force remapping if colours or palettes are different ***/

  if (Bitmap->AmtColours != ILBMBitmap->AmtColours) {
     Picture->Options |= IMG_REMAP;
  }

  if ((Picture->Options & (IMG_REMAP|IMG_NOCOMPARE)) IS NULL) {
     if (Bitmap->Palette) { /* Compare palettes */
        for (i=2; i < (Bitmap->AmtColours+2); i++) {
           if (Bitmap->Palette[i] != ILBMBitmap->Palette[i]) {
              Picture->Options |= IMG_REMAP;
              i = 30000; /* Terminate the loop */
           }
        }
     }
  }

  if (Picture->Options & IMG_REMAP) {
     DPrintF("UnpackPicture:","Colour remapping for this Picture is in effect.");
  }

  /*** Calculate some initial variables for the loop ***/

  if (Bitmap->Width < ILBMBitmap->Width) {
     MaxWidth = Bitmap->Width;
  }
  else {
     MaxWidth = ILBMBitmap->Width;
  }
  ydest = NULL;

  /* Begin the loop now.  Unpack one row at a time to the ILBM Bitmap
  ** buffer, then copy the pixels from the buffer over to our destination.
  */

  DebugOff();

  BPos = NULL;
  Read(File, Buffer, UNPACKSIZE);

  for (y=0; y < Height; y++) {

     /*** Unpack the body data to our special ILBM Bitmap ***/

     if ((BMHD->Depth IS 8) AND (CAMG & OSV_HAM)) {
        Dest = ((BYTE *)ILBMBitmap->Data) + (ILBMBitmap->ByteWidth * 2);
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos); Dest += ILBMBitmap->ByteWidth;
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos); Dest += ILBMBitmap->ByteWidth;
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos); Dest += ILBMBitmap->ByteWidth;
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos); Dest += ILBMBitmap->ByteWidth;
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos); Dest += ILBMBitmap->ByteWidth;
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos);

        Dest = ILBMBitmap->Data;
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos); Dest += ILBMBitmap->ByteWidth;
        BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos);
     }
     else {
        Dest = ILBMBitmap->Data;
        for (j=0; j < ILBMBitmap->Planes; j++) {
           BPos = UnpackPlane(BMHD, File, ILBMBitmap, Dest, Buffer, BPos);
           Dest += ILBMBitmap->ByteWidth;
        }
     }

     /* Write the data out to the destination Bitmap.  If resizing,
     ** we use the standard DrawPixel() and ReadPixel() routines.  Although
     ** we could improve the speed in some parts, it is not too crucial.
     */

     if ((Picture->Options & IMG_RESIZEX) AND (Bitmap->Width != ILBMBitmap->Width)) {
        if (ILBMBitmap->Width > Bitmap->Width) { /*** Shrink Row ***/
           XRemainder = NULL;
           Domain = ILBMBitmap->Width - Bitmap->Width;
           j = NULL;

           for (i=0; i < Bitmap->Width; i++) {
              XRemainder += Domain;

              while (XRemainder >= Bitmap->Width) {
                 XRemainder -= Bitmap->Width;
                 j++;
              }
              Bitmap->DrawUCRPixel(Bitmap,i,ydest,ILBMBitmap->ReadUCRPixel(ILBMBitmap,j++,0));
           }
        }
        else { /*** Expand Row ***/
           XRemainder = NULL;
           Domain = Bitmap->Width - ILBMBitmap->Width;
           j = NULL;

           for (i=0; i < ILBMBitmap->Width; i++) {
              Colour = ILBMBitmap->ReadUCRPixel(ILBMBitmap,i,0);
              Bitmap->DrawUCRPixel(Bitmap,j++,ydest,Colour);
              XRemainder += Domain;

              while (XRemainder >= ILBMBitmap->Width) {
                 Bitmap->DrawUCRPixel(Bitmap,j++,ydest,Colour);
                 XRemainder -= ILBMBitmap->Width;
              }
           }
        }
     }
     else if (Picture->Options & IMG_REMAP) {
        for (i=0; i < MaxWidth; i++) {
            Bitmap->DrawUCRPixel(Bitmap,i,ydest,ILBMBitmap->ReadUCRPixel(ILBMBitmap,i,0));
        }
     }
     else if ((Bitmap->Type IS PLANAR) OR (Bitmap->Type IS ILBM)) {
        /* This routine takes advantage of the fact that PLANAR and ILBM
        ** store pixels in sets of 8 per byte.
        */

        SrcBData  = (BYTE *)ILBMBitmap->Data;
        DestBData = ((BYTE *)Bitmap->Data) + (Bitmap->LineMod * ydest);
        for (j=0; j < ILBMBitmap->Planes; j++) {
           for (i=0; i < ((MaxWidth+15) & 0xFFF0)/8; i++) {
              DestBData[i] = SrcBData[i];
           }
           SrcBData  += ILBMBitmap->ByteWidth;
           DestBData += Bitmap->PlaneMod;
        }
     }
     else if (Bitmap->Type IS CHUNKY8) {
        DestBData = ((BYTE *)Bitmap->Data) + (Bitmap->ByteWidth * ydest);
        for (i=0; i < MaxWidth; i++) {
            DestBData[i] = ILBMBitmap->ReadUCPixel(ILBMBitmap,i,0); /* Convert ILBM to Chunky */
        }
     }
     else { /* CHUNKY16 and TRUECOLOUR types require RGB to read from ILBM */
        for (i=0; i < MaxWidth; i++) {
            Bitmap->DrawUCRPixel(Bitmap,i,ydest,ILBMBitmap->ReadUCRPixel(ILBMBitmap,i,0));
        }
     }

     /*** Image Resizing Y Axis ***/

     if (Picture->Options & IMG_RESIZEY) {
        if (Bitmap->Height < BMHD->Height) { /*** Shrink Down ***/
           Domain      = BMHD->Height - Bitmap->Height;
           YRemainder += Domain;
           while (YRemainder >= Bitmap->Height) {
              YRemainder -= Bitmap->Height;
              BPos = SkipLine(BMHD, (BYTE *)Buffer, File, ILBMBitmap,BPos);
           }
        }
        else if (Bitmap->Height > BMHD->Height) { /*** Expand ***/
           Domain      = Bitmap->Height - BMHD->Height;
           YRemainder += Domain;
           while (YRemainder >= BMHD->Height) {
              YRemainder -= BMHD->Height;
              ydest++;
              CopyLine(Bitmap,Bitmap,ydest-1,ydest,Bitmap->Width,0);
           }
        }
     }
     ydest++;
  }

  ecode = ERR_OK;

exit:
  DebugOn();
  if (Buffer)     FreeMemBlock(Buffer);
  if (ILBMBitmap) Free(ILBMBitmap);
  if (Palette)    FreeMemBlock(Palette);
  return(ecode);  
}

/***********************************************************************************
** Internal: SkipLine()
** Short:    Skips a complete line of Buffer data.
*/

WORD SkipLine(struct BMHD *BMHD, BYTE *Buffer, struct File *File, struct Bitmap *ILBMBitmap, WORD BPos)
{
  WORD written;
  BYTE num, j;

  if (BMHD->Pack) {
     for (j=0; j < ILBMBitmap->Planes; j++) {
        written = NULL;
        while (written < ILBMBitmap->ByteWidth) {
           num = Buffer[BPos++];
           if (BPos >= UNPACKSIZE) {
              BPos = NULL;
              Read(File, Buffer, UNPACKSIZE);
           }

           if (num >= 0) {
              do {
                 BPos++;
                 if (BPos >= UNPACKSIZE) {
                    BPos = NULL;
                    Read(File, Buffer, UNPACKSIZE);
                 }
                 num--;
                 written++;
              } while (num >= 0);
           }
           else if (num != -128) {
              num = -num;
              BPos++;
              if (BPos >= UNPACKSIZE) {
                 BPos = NULL;
                 Read(File, Buffer, UNPACKSIZE);
              }

              do {
                 written++;
                 num--;
              } while (num >= 0);
           }
        }
     }
  }
  else {
     for (j=0; j < ILBMBitmap->Planes; j++) {
        for (num=0; num < ILBMBitmap->ByteWidth; num++) {
           BPos++;
           if (BPos >= UNPACKSIZE) {
              BPos = NULL;
              Read(File, Buffer, UNPACKSIZE);
           }
        }
     }
  }

  return(BPos);
}

/***********************************************************************************
** Internal: UnpackPlane()
** Short:    Unpacks one plane of BODY data to the ILBMBitmap object.
*/

WORD UnpackPlane(struct BMHD *BMHD, struct File *File, struct Bitmap *ILBMBitmap, BYTE *Dest, BYTE *Buffer, WORD BPos)
{
  WORD written;
  BYTE num, col;

  if (BMHD->Pack) {
     written = NULL;
     while (written < ILBMBitmap->ByteWidth) {
        num = Buffer[BPos++];
        if (BPos >= UNPACKSIZE) {
           BPos = NULL;
           Read(File, Buffer, UNPACKSIZE);
        }

        if (num >= 0) {
           do {
              *Dest++ = Buffer[BPos++];
              if (BPos >= UNPACKSIZE) {
                 BPos = NULL;
                 Read(File, Buffer, UNPACKSIZE);
              }
              num--;
              written++;
              if (written > ILBMBitmap->ByteWidth) return(BPos);
           } while (num >= 0);
        }
        else if (num != -128) {
           col = Buffer[BPos++];
           if (BPos >= UNPACKSIZE) {
              BPos = NULL;
              Read(File, Buffer, UNPACKSIZE);
           }

           do {
              *Dest++ = col;
              written++;
              num++;
              if (written > ILBMBitmap->ByteWidth) return(BPos);
           } while (num <= 0);
        }
     }
  }
  else {
     for (num=0; num < ILBMBitmap->ByteWidth; num++) {
        *Dest++ = Buffer[BPos++];
        if (BPos >= UNPACKSIZE) {
           BPos = NULL;
           Read(File, Buffer, UNPACKSIZE);
        }
     }
  }

  return(BPos);
}

