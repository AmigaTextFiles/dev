/* Dice: 1> dcc -l0 -mD dpk.o tags.o LineTest.c -o LineTest
**
** Line demo.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Line Test";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "June 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Draws lots of different masked lines.";

void main(void)
{
  struct GScreen *Screen;
  struct JoyData *JoyData;
  LONG   palette[] = { PALETTE_ARRAY, 4, 0x000000L, 0xf080f0L, 0x80f0f0, 0xf0f080 };
  WORD   sx,sy,ex,ey;
  LONG   mask;

  if (Screen = InitTags(NULL,
      TAGS_SCREEN,    NULL,
        GSA_BitmapTags, NULL,
        BMA_Palette,    palette,
        TAGEND,         NULL,
      TAGEND)) {

     if (JoyData = Init(Get(ID_JOYDATA),NULL)) {

        Display(Screen);

        /*** Pattern 1 ***/

        mask = 0x0f0f0f0f;
        sx=0; sy=0; ex=0; ey=Screen->Bitmap->Height-1;
        for (ex=0; ex < Screen->Bitmap->Width; ex++) {
           DrawLine(Screen->Bitmap,sx,sy,ex,ey,1,mask);
        }
        for (ey=Screen->Bitmap->Height-1; ey > 0; ey--) {
           DrawLine(Screen->Bitmap,sx,sy,ex,ey,1,mask);
        }

        WaitTime(50);

        /*** Clear pattern 1 ***/

        mask = 0xffffffff;
        sx=0; sy=0; ex=0; ey=Screen->Bitmap->Height-1;
        for (ex=0; ex < Screen->Bitmap->Width; ex++) {
           DrawLine(Screen->Bitmap,sx,sy,ex,ey,3,mask);
        }
        for (ey=Screen->Bitmap->Height-1; ey > 0; ey--) {
           DrawLine(Screen->Bitmap,sx,sy,ex,ey,3,mask);
        }

        WaitTime(10);

        /*** Pattern 2 ***/

        mask = 0xAAAAAAAA;
        sx=0; sy=0; ex=0; ey=Screen->Bitmap->Height-1;
        for (ex=0; ex < Screen->Bitmap->Width; ex++) {
           DrawLine(Screen->Bitmap,sx,sy,ex,ey,2,mask);
           mask = ~mask;
           sx++;
        }

        WaitTime(50);

        /*** Clear pattern 2 ***/

        mask = 0xffffffff;
        sx=0; sy=Screen->Bitmap->Height-1; ex=Screen->Bitmap->Width-1; ey=Screen->Bitmap->Height-1;
        for (sy=Screen->Bitmap->Height-1; sy >= 0; sy--) {
           DrawLine(Screen->Bitmap,sx,sy,ex,ey,1,mask);
           ey--;
        }

        WaitTime(50);

     Free(JoyData);
     }
  Free(Screen);
  }
}

