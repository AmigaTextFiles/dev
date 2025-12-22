/* Dice: dcc -l0 -mD dpk.o tags.o WhiteFade.c -o WhiteFade
**
** There are three examples of fading in this program:  ColourMorph(),
** ColourToPalette(), and PaletteToColour().  This demo will only work for
** pictures that make use of a palette table - ie it wouldn't work
** for a true colour screen.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "White Fading Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Demonstration of screen fading.";

void main(void)
{
  WORD FadeState = 0;
  struct GScreen *screen;
  struct Picture *pic;
  struct FileName PicFile = { ID_FILENAME, "GMS:demos/data/PIC.Loading" };

  if (pic = Load(&PicFile, ID_PICTURE)) {
   if (screen = Get(ID_SCREEN)) {
      CopyStructure(pic,screen);
      screen->Bitmap->Palette = NULL;
      screen->Bitmap->Flags   = BMF_BLANKPALETTE;

      if (screen = Init(screen,NULL)) {
         if (Copy(pic->Bitmap,screen->Bitmap) IS ERR_OK) {

            Display(screen);

            do { WaitAVBL();
                 FadeState = ColourMorph(screen,FadeState,10,0,screen->Bitmap->AmtColours,0x000000,0xFFFFFF);
            } while (FadeState != NULL);

            do { WaitAVBL();
                 FadeState = ColourToPalette(screen,FadeState,2,0,screen->Bitmap->AmtColours,pic->Bitmap->Palette+2,0xFFFFFF);
            } while (FadeState != NULL);

            do { WaitAVBL();
                 FadeState = PaletteToColour(screen,FadeState,2,0,screen->Bitmap->AmtColours,pic->Bitmap->Palette+2,0x000000);
            } while (FadeState != NULL);
         }
      }
   Free(screen);
   }
  Free(pic);
  }
}

