/* Dice: 1> dcc -l0 -mD dpk.o tags.o MoveCircle.c -o MoveCircle
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Circles";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "July 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1998.  Freely distributable.";
BYTE *ProgShort     = "Move a circle around the screen.";

LONG Palette[] = {
  ID_PALETTE, 2,
  0x000000,0xff0000,
};

void main(void)
{
  struct GScreen *Screen;
  struct JoyData *JoyData;
  WORD   x, y, radius, fill;

  if (Screen = InitTags(NULL,
      TAGS_SCREEN, NULL,
      GSA_Attrib,  SCR_DBLBUFFER,
        GSA_BitmapTags, NULL,
        BMA_Palette,    Palette,
        TAGEND,         NULL,
      TAGEND)) {

     if (JoyData = Init(Get(ID_JOYDATA),NULL)) {

        Display(Screen);

        /*** Set the circle's parameters ***/

        x      = Screen->Width/2;
        y      = Screen->Height/2;
        radius = FastRandom(Screen->Width/2);
        fill   = FastRandom(2);
        SetRGBPen(Screen->Bitmap,0xff0000);

        /*** Main loop ***/

        do {
           Query(JoyData);

           if (JoyData->Buttons & JD_LMB) {
              radius += (JoyData->XChange + JoyData->YChange);
           }
           else {
              x += JoyData->XChange;
              y += JoyData->YChange;
           }

           if (radius > 50) radius = 50;
           if (radius < 1) radius = 1;

           Clear(Screen->Bitmap);
           PenCircle(Screen->Bitmap,x,y,radius,fill);
           WaitVBL();
           SwapBuffers(Screen);
        } while (!(JoyData->Buttons & JD_RMB));

     Free(JoyData);
     }
  Free(Screen);
  }
}

