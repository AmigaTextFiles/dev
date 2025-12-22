/* Name: Moire (Converted from Amiga Graphics Inside and Out)
** Dice: dcc -l0 -mD dpk.o tags.o Moire.c -o Moire
**
** Generates some nice patterns.  Hold LMB to exit.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Moire";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Generates some nice patterns.";

struct GScreen *screen;
struct JoyData *joydata;

void Moire(void);

LONG palette[6] = { PALETTE_ARRAY,4,0x000000,0x505050,0x707070,0xF0F0F0 };

/***********************************************************************************/

void main(void)
{
  if (screen = InitTags(NULL,
     TAGS_SCREEN,    NULL,
       GSA_BitmapTags, NULL,
       BMA_Palette,    palette,
       TAGEND,         NULL,
     TAGEND)) {

     Display(screen);

     if (joydata = Init(Get(ID_JOYDATA),NULL)) {

        Moire();

     Free(joydata);
     }
  Free(screen);
  }
}

/***********************************************************************************/

void Moire(void)
{
  WORD xm,ym,i;

loop:

    Clear(screen->Bitmap);
    xm = FastRandom(screen->Width);        /* Coordinates of Centre Point */
    ym = FastRandom(screen->Height);

    for (i=0; i < screen->Height; i++) {
       Query(joydata);
       if (joydata->Buttons & JD_LMB) return;

       DrawLine(screen->Bitmap, xm, ym, 0, i, i%(2+1),0xffffffff);
       DrawLine(screen->Bitmap, xm, ym, screen->Width,i, i%(2+1),0xffffffff);
    }

    for (i=0; i < screen->Width; i++) {
       Query(joydata);
       if (joydata->Buttons & JD_LMB) return;
       DrawLine(screen->Bitmap, xm, ym, i, 0, i%(2+1),0xffffffff);
       DrawLine(screen->Bitmap, xm, ym, i, screen->Height, i%(2+1),0xffffffff);
    }

    WaitTime(100);

  goto loop;
}

