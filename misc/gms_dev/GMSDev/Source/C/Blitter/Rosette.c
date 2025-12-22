/* Name:  Rosette (Converted from Amiga Graphics Inside and Out)
** SAS/C: sc Rosette.c opt math=standard INCDIR=INCLUDES:
*/

#include <proto/dpkernel.h>
#include <math.h>

BYTE *ProgName      = "Rosette";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Draws various rosette pattenrs.";

struct GScreen *screen;
struct JoyData *joydata;

void Rosette(void);

LONG palette[] = {
  PALETTE_ARRAY,32,
  0x000000L,0x101010L,0x171717L,0x202020L,0x272727L,0x303030L,0x373737L,0x404040L,
  0x474747L,0x505050L,0x575757L,0x606060L,0x676767L,0x707070L,0x777777L,0x808080L,
  0x878787L,0x909090L,0x979797L,0xa0a0a0L,0xa7a7a7L,0xb0b0b0L,0xb7b7b7L,0xc0c0c0L,
  0xc7c7c7L,0xd0d0d0L,0xd7d7d7L,0xe0e0e0L,0xe0e0e0L,0xf0f0f0L,0xf7f7f7L,0xffffffL
};

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

        Rosette();

     Free(joydata);
     }
  Free(screen);
  }
}

/***********************************************************************************/

void Rosette(void)
{
  WORD offsetx = (screen->Width/2);
  WORD offsety = (screen->Height/2);
  double t, angle, x, y;
  double inside  = 3.0, radius = 100.0,
         outside = 3.0, f      = 0.5,
         edges   = 10;

  for (t = -inside/10; t < (outside/10); t += 0.1) {
    Query(joydata);
    if (joydata->Buttons & JD_LMB) {
       return;
    }

    for (angle = 0; angle < (2*PI); angle += 0.01) {
      x = radius * cos(angle) + t * radius * cos(angle * edges);
      y = radius * sin(angle) + t * radius * sin(angle * edges);
      DrawPixel(screen->Bitmap, (WORD)(x+offsetx), (WORD)(y*f+offsety), FastRandom(screen->Bitmap->AmtColours));
    }
  }
}

