/* Name:   Pixel-List Demo
** Author: Paul Manias
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Pixel-List Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Demonstration of pixel lists.";

#define AMT_PIXELS 32

LONG Palette[] = {
  PALETTE_ARRAY,32,
  0x000000L,0x101010L,0x171717L,0x202020L,0x272727L,0x303030L,0x373737L,0x404040L,
  0x474747L,0x505050L,0x575757L,0x606060L,0x676767L,0x707070L,0x777777L,0x808080L,
  0x878787L,0x909090L,0x979797L,0xa0a0a0L,0xa7a7a7L,0xb0b0b0L,0xb7b7b7L,0xc0c0c0L,
  0xc7c7c7L,0xd0d0d0L,0xd7d7d7L,0xe0e0e0L,0xe0e0e0L,0xf0f0f0L,0xf7f7f7L,0xffffffL
};

struct PixelEntry Pixels[AMT_PIXELS] = {
  {160,128,0},  {160,128,1},  {160,128,2},  {160,128,3},  {160,128,4},  {160,128,5},
  {160,128,6},  {160,128,7},  {160,128,8},  {160,128,9},  {160,128,10}, {160,128,11},
  {160,128,12}, {160,128,13}, {160,128,14}, {160,128,15}, {160,128,16}, {160,128,17},
  {160,128,18}, {160,128,19}, {160,128,20}, {160,128,21}, {160,128,22}, {160,128,23},
  {160,128,24}, {160,128,25}, {160,128,26}, {160,128,27}, {160,128,28}, {160,128,29},
  {160,128,30}, {160,128,31}
};

struct PixelList PixelList = {
  AMT_PIXELS,
  sizeof(struct PixelEntry),
  Pixels
};

struct GScreen *Screen;

/*=========================================================================*/

void main(void)
{
  WORD i;
  struct JoyData *joy;

  if (Screen = InitTags(NULL,
       TAGS_SCREEN,    NULL,
       GSA_Attrib,     SCR_DBLBUFFER,
         GSA_BitmapTags, NULL,
         BMA_Palette,    Palette,
         TAGEND,         NULL,
       TAGEND)) {

    if (joy = Init(Get(ID_JOYDATA),NULL)) {
       Show(Screen);

       do {
         Clear(Screen->Bitmap);

         for(i=0; i<(AMT_PIXELS-1); i++) {
           Pixels[i].YCoord += 1;            /* Y Coord down 1 */
           if ((Pixels[i].Colour -= 1) < 0)  /* Colour value down 1 */
             Pixels[i].Colour = 1;
         }

         Query(joy);
         Pixels[AMT_PIXELS-1].XCoord += joy->XChange+(FastRandom(3)-1);
         Pixels[AMT_PIXELS-1].YCoord += joy->YChange+(FastRandom(3)-1);

         if (Pixels[AMT_PIXELS-1].XCoord >= Screen->Width)  Pixels[AMT_PIXELS-1].XCoord = 0;
         if (Pixels[AMT_PIXELS-1].YCoord >= Screen->Height) Pixels[AMT_PIXELS-1].YCoord = 0;
         if (Pixels[AMT_PIXELS-1].XCoord < 0) Pixels[AMT_PIXELS-1].XCoord = Screen->Width-1;
         if (Pixels[AMT_PIXELS-1].YCoord < 0) Pixels[AMT_PIXELS-1].YCoord = Screen->Height-1;

         for(i=0; i<(AMT_PIXELS-1); i++)
           Pixels[i] = Pixels[i+1];

         DrawPixelList(Screen->Bitmap,&PixelList);
         WaitAVBL();
         SwapBuffers(Screen);
       } while (!(joy->Buttons & JD_LMB));

    Free(joy);
    }
  Free(Screen);
  }
}

