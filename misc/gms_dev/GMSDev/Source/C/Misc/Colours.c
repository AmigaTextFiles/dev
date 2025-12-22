/* Dice: 1> dcc -l0 -mD dpk.o tags.o Colours.c -o Colours
**
** This source demonstrates use of the Colours module.
*/

#include <proto/dpkernel.h>
#include <clib/colours_protos.h>

BYTE *ProgName      = "Colours Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "August 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1998.  Freely distributable.";
BYTE *ProgShort     = "Demonstration of the colours module.";

struct GScreen  *screen     = NULL;
struct Restore  *restore    = NULL;
struct JoyData  *joydata    = NULL;
struct Picture  *background = NULL;
struct Module   *ColoursMod = NULL;
APTR COLBase;

struct FileName BackFile = { ID_FILENAME, "GMS:demos/data/PIC.Green" };

void Demo(void);

/***************************************************************************/

void main(void) {
  if (ColoursMod = OpenModule(MOD_COLOURS,"colours.mod")) {
     COLBase = ColoursMod->ModBase;

   if (background = Load(&BackFile, ID_PICTURE)) {
    if (screen = Get(ID_SCREEN)) {
       CopyStructure(background, screen);

     if (Init(screen,NULL)) {

      if (Copy(background->Bitmap,screen->Bitmap) IS ERR_OK) {

       if (joydata = Get(ID_JOYDATA)) {
          joydata->Port = 1;     /* Forces mouse control */

        if (Init(joydata, NULL)) {
           Display(screen); 
           Demo();
        }
       }
      }
     }
    }
   }
  }
  Free(screen);
  Free(joydata);
  Free(background);
  Free(ColoursMod);
}

/***************************************************************************/

LIBFUNC void LightPen(mreg(__a0) struct Bitmap *Bitmap, mreg(__d1) WORD X, mreg(__d2) WORD Y)
{
   LightenPixel(Bitmap,X,Y,20);
}

LIBFUNC void LightPen2(mreg(__a0) struct Bitmap *Bitmap, mreg(__d1) WORD X, mreg(__d2) WORD Y)
{
   LightenPixel(Bitmap,X,Y,15);
}

void Demo(void)
{
   WORD XCoord = screen->Width/2;
   WORD YCoord = screen->Height/2;
   struct HSV HSV;
   WORD Method = NULL;
   WORD held = FALSE;

   ConvertRGBToHSV(DecRGB(100,90,30),&HSV);
   DPrintF("RGBToHSV:","$%.8x = Hue: %d, Sat: %d, Val %d",DecRGB(100,90,30),HSV.Hue,HSV.Sat,HSV.Val);
   DPrintF("Brightness:","%d",CalcBrightness(DecRGB(100,90,30)));

   ConvertRGBToHSV(DecRGB(75,150,105),&HSV);
   DPrintF("RGBToHSV:","$%.8x = Hue: %d, Sat: %d, Val %d",DecRGB(75,150,105),HSV.Hue,HSV.Sat,HSV.Val);
   DPrintF("Brightness:","%d",CalcBrightness(DecRGB(75,150,105)));

   ConvertRGBToHSV(DecRGB(80,160,255),&HSV);
   DPrintF("RGBToHSV:","$%.8x = Hue: %d, Sat: %d, Val %d",DecRGB(80,160,255),HSV.Hue,HSV.Sat,HSV.Val);
   DPrintF("Brightness:","%d",CalcBrightness(DecRGB(80,160,255)));

   SetRGBPen(screen->Bitmap,0xffffff);
   SetPenShape(screen->Bitmap,PSP_CIRCLE,3);

   do
   {
     Query(joydata);
     XCoord += joydata->XChange;
     YCoord += joydata->YChange;
     if (XCoord < 0) XCoord = screen->Width + XCoord;
     if (YCoord < 0) YCoord = screen->Height + YCoord;
     if (XCoord >= screen->Width)  XCoord = XCoord - screen->Width;
     if (YCoord >= screen->Height) YCoord = YCoord - screen->Height;

     if (joydata->Buttons & JD_RMB) {
        held = TRUE;
     }
     else if (joydata->Buttons & JD_LMB) {
        if (Method IS 0) {
           BlurArea(screen->Bitmap,XCoord,YCoord,40,40,50);
        }
        else if (Method IS 1) {
           screen->Bitmap->PenUCPixel = &LightPen;
           SetPenShape(screen->Bitmap,PSP_CIRCLE,3);
           PenCircle(screen->Bitmap,XCoord,YCoord,30,FALSE);
        }
        else if (Method IS 2) {
           screen->Bitmap->PenUCPixel = &LightPen;
           PenCircle(screen->Bitmap,XCoord,YCoord,30,TRUE);
        }
        else if (Method IS 3) {
           screen->Bitmap->PenUCPixel = &LightPen;
           SetPenShape(screen->Bitmap,PSP_PIXEL,3);
           PenRect(screen->Bitmap,XCoord,YCoord,30,30,FALSE);
        }
        else if (Method IS 4) {
           screen->Bitmap->PenUCPixel = &LightPen2;
           SetPenShape(screen->Bitmap,PSP_SQUARE,4);
           PenEllipse(screen->Bitmap,XCoord,YCoord,20,40,FALSE);
        }
     }
     else if (held IS TRUE) {
        Method++;
        if (Method > 4) Method = 0;
        held = FALSE;
     }

     LightenPixel(screen->Bitmap,XCoord,YCoord,50);

     WaitAVBL();
   } while ((joydata->Buttons & (JD_RMB|JD_LMB)) != (JD_RMB|JD_LMB));
}

