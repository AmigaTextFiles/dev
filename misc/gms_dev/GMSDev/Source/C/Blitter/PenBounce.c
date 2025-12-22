/* Dice: 1> dcc -l0 -mD dpk.o tags.o BounceLine.c -o BounceLine
**
** Line bouncing demo that works on a screen of any type of dimensions as
** specified by the user in GMSPrefs.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Bounce Line (Pens based)";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "August 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Line bouncing demo (Pens based).";

void main(void)
{
  struct GScreen *Screen;
  struct JoyData *JoyData;
  LONG palette[] = { PALETTE_ARRAY, 2, 0x000000L, 0x80f0f0L };
  int  sx,sy,ex,ey;
  int  dsx,dsy,dex,dey;

  if (Screen = InitTags(NULL,
      TAGS_SCREEN,    NULL,
        GSA_BitmapTags, NULL,
        BMA_Palette,    palette,
        TAGEND,         NULL,
      GSA_Attrib,     SCR_DBLBUFFER,
      TAGEND)) {

     sx = SlowRandom(Screen->Width);  dsx = -1;
     sy = SlowRandom(Screen->Height); dsy = 2;
     ex = SlowRandom(Screen->Width);  dex = 3;
     ey = SlowRandom(Screen->Height); dey = 1;

     if (JoyData = Init(Get(ID_JOYDATA),NULL)) {

        Display(Screen);

        SetPenShape(Screen->Bitmap,PSP_CIRCLE,2);
        SetRGBPen(Screen->Bitmap,0xffffffL);

        do
        {
          Clear(Screen->Bitmap);
          Query(JoyData);
          sx += dsx;
          sy += dsy;
          ex += dex;
          ey += dey;

          if(sx<0) { sx = 0; dsx = -(dsx); }
          if(sy<0) { sy = 0; dsy = -(dsy); }
          if(ex<0) { ex = 0; dex = -(dex); }
          if(ey<0) { ey = 0; dey = -(dey); }

          if(sx>Screen->Width-1) {
            sx  = Screen->Width-1;
            dsx = -(dsx);
          }

          if(sy>Screen->Height-1) {
            sy  = Screen->Height-1;
            dsy = -(dsy);
          }

          if(ex>Screen->Width-1) {
            ex  = Screen->Width-1;
            dex = -(dex);
          }

          if(ey>Screen->Height-1) {
            ey  = Screen->Height-1;
            dey = -(dey);
          }

          PenLine(Screen->Bitmap,sx,sy,ex,ey,0x01010101);
          WaitAVBL();
          SwapBuffers(Screen);
        } while (!(JoyData->Buttons & JD_LMB));

     Free(JoyData);
     }
  Free(Screen);
  }
}

