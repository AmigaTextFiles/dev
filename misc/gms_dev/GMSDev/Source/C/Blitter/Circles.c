/* Dice: 1> dcc -l0 -mD dpk.o tags.o Circles.c -o Circles
**
** Draws different circles at random positions.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Circles";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "July 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1998.  Freely distributable.";
BYTE *ProgShort     = "Draws different circles at random positions.";

LONG Palette[] = {
  ID_PALETTE, 16,
  0x000000,0xff0000,0x00ff00,0x0000ff,0xffff00,0xff00ff,0x00ffff,0x555555,
  0xaaaaaa,0xffffff,0xff3456,0x6543ff,0xffaadd,0x29ff55,0x96f92a,0x89fa92
};

void main(void)
{
  struct GScreen *Screen;
  struct JoyData *JoyData;
  WORD   sx,sy,radius;

  if (Screen = InitTags(NULL,
      TAGS_SCREEN, NULL,
        GSA_BitmapTags, NULL,
        BMA_Palette,    Palette,
        TAGEND,         NULL,
      TAGEND)) {

     if (JoyData = Init(Get(ID_JOYDATA),NULL)) {

        Display(Screen);

        do {
          Query(JoyData);
          sx = FastRandom(Screen->Width+50)-25;
          sy = FastRandom(Screen->Height+50)-25;
          radius  = (FastRandom(Screen->Width/4))+1;
          SetRGBPen(Screen->Bitmap,Palette[FastRandom(15)+3]);
          PenCircle(Screen->Bitmap,sx,sy,radius,FastRandom(2));
        } while (!(JoyData->Buttons & JD_LMB));

     Free(JoyData);
     }
  Free(Screen);
  }
}

