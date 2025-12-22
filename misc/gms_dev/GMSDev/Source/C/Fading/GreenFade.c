/* Dice: dcc -l0 -mD dpk.o tags.o GreenFade.c -o GreenFade
**
** Fades into a 32 colour picture.  Then fades up to a specified colour
** (lime green), and then out to black.  This demo will only work for
** pictures that make use of a palette table - ie it wouldn't work
** for a true colour screen.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "GreenFade";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Demonstration of screen fading.";

void main(void)
{
   WORD   FState=0;
   struct GScreen *screen;
   struct Picture *pic;
   struct FileName PicFile = { ID_FILENAME, "GMS:demos/data/PIC.Loading" };

   if (pic = Load(&PicFile, ID_PICTURE)) {
      screen = Get(ID_SCREEN);
      CopyStructure(pic,screen);
      screen->Bitmap->Palette = NULL;
      screen->Bitmap->Flags   = BMF_BLANKPALETTE;

      if (screen = Init(screen,NULL)) {
         if (Copy(pic->Bitmap,screen->Bitmap) IS ERR_OK) {

            Display(screen);

            do {
              WaitAVBL();
              FState = ColourToPalette(screen,FState,2,0,screen->Bitmap->AmtColours,pic->Bitmap->Palette+2,0x000000);
            } while (FState != NULL);

            do {
              WaitAVBL();
              FState = PaletteToColour(screen,FState,2,0,screen->Bitmap->AmtColours,pic->Bitmap->Palette+2,0xa5f343);
            } while (FState != NULL);

            do {
              WaitAVBL();
              FState = ColourMorph(screen,FState,2,0,screen->Bitmap->AmtColours,0xa5f343,0x000000);
            } while (FState != NULL);

         }
      Free(screen);
      }
   Free(pic);
   }
}

