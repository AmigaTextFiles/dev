/* Dice:  1> dcc -l0 -mD dpk.o tags.o 3DShape.c -o 3DShape
**
** This demo uses the PenCircle() function to 'steal' circle coordinates
** and then uses them to create a 3D object.  This type of trick is legal
** but must be used carefully.
*/

#include <proto/dpkernel.h>
#include <clib/colours_protos.h>

BYTE *ProgName      = "3D Shape Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "August 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1998.  Freely distributable.";
BYTE *ProgShort     = "Demonstration of pens being used to create dot-based shapes.";

struct GScreen  *Screen  = NULL;
struct JoyData  *joydata = NULL;

void Demo(void);

WORD PixelNum = NULL;

#define AMT_PIXELS 10000

struct Entry3D {
  WORD  XCoord;
  WORD  YCoord;
  LONG  Colour;
  LONG  XCoord3D;
  LONG  YCoord3D;
  LONG  ZCoord3D;
};

struct PixelList3D {
  WORD   AmtEntries;
  WORD   EntrySize;
  struct Entry3D *Pixels;
};

struct PixelList3D PixelList = {
  NULL, sizeof(struct Entry3D), NULL
};

/***************************************************************************/

void main(void) {

  if (Screen = Get(ID_SCREEN)) {
     Screen->Attrib |= SCR_DBLBUFFER;
   if (Init(Screen,NULL)) {
    if (joydata = Get(ID_JOYDATA)) {
     if (Init(joydata, NULL)) {
      if (PixelList.Pixels = AllocMemBlock(sizeof(struct Entry3D) * AMT_PIXELS, MEM_DATA)) {
         Display(Screen);
         Demo();
      }
     }
    }
   }
  }

  FreeMemBlock(PixelList.Pixels);
  Free(Screen);
  Free(joydata);
}

/***************************************************************************/

LIBFUNC void StealPen(mreg(__a0) struct Bitmap *Bitmap, mreg(__d1) WORD X, mreg(__d2) WORD Y)
{
  if (PixelNum < AMT_PIXELS) {
     PixelList.Pixels[PixelNum].XCoord = X;
     PixelList.Pixels[PixelNum].YCoord = Y;
     PixelList.Pixels[PixelNum].XCoord3D = X<<8;
     PixelList.Pixels[PixelNum].YCoord3D = Y<<8;
     PixelList.Pixels[PixelNum].ZCoord3D = 1;
     PixelList.Pixels[PixelNum].Colour = FastRandom(Screen->Bitmap->AmtColours-1)+1;
     PixelNum++;
  }
}

void Demo(void)
{
   WORD ZPos = 1<<8;
   WORD i;

   /* This part alters the pen functions so that we can steal the
   ** coordinates.  Once PenCircle() has been called, we set the
   ** function pointers back to normal by calling SetPenShape()
   ** and SetRGBPen().
   */

   Screen->Bitmap->PenUCPixel = &StealPen;
   Screen->Bitmap->DrawPen    = &StealPen;
   PenCircle(Screen->Bitmap, 0, 0, 30, FALSE);
   SetPenShape(Screen->Bitmap, PSP_PIXEL, 0);
   SetRGBPen(Screen->Bitmap, 0xffffff);
   PixelList.AmtEntries = PixelNum;

   do
   {
     Query(joydata);

     ZPos += joydata->YChange;
     ZPos += joydata->XChange;
     if (ZPos < 10)   ZPos = 10;   /* <-- This prevents division by 0 errors */
     if (ZPos > 2000) ZPos = 2000;

     Clear(Screen->Bitmap);

     for (i=0; i < PixelNum; i++) {
        PixelList.Pixels[i].XCoord = ((PixelList.Pixels[i].XCoord3D)/ZPos) + Screen->Width/2;
        PixelList.Pixels[i].YCoord = ((PixelList.Pixels[i].YCoord3D)/ZPos) + Screen->Height/2;
     }
     DrawPixelList(Screen->Bitmap,(struct PixelList *)&PixelList);

     for (i=0; i < PixelNum; i++) {
        PixelList.Pixels[i].XCoord = ((PixelList.Pixels[i].XCoord3D)/(ZPos/2)) + Screen->Width/2;
        PixelList.Pixels[i].YCoord = ((PixelList.Pixels[i].YCoord3D)/(ZPos/2)) + Screen->Height/2;
     }
     DrawPixelList(Screen->Bitmap,(struct PixelList *)&PixelList);

     for (i=0; i < PixelNum-1; i++) {
        PixelList.Pixels[i].XCoord = ((PixelList.Pixels[i].XCoord3D)/(ZPos*2)) + Screen->Width/2;
        PixelList.Pixels[i].YCoord = ((PixelList.Pixels[i].YCoord3D)/(ZPos*2)) + Screen->Height/2;
        PixelList.Pixels[i].Colour = PixelList.Pixels[i+1].Colour;
     }
     PixelList.Pixels[i].Colour = PixelList.Pixels[0].Colour;
     DrawPixelList(Screen->Bitmap,(struct PixelList *)&PixelList);

     SwapBuffers(Screen);
     WaitAVBL();
   } while (!(joydata->Buttons & JD_LMB));
}

