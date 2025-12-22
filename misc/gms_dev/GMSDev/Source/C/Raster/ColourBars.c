/* Dice: dcc -l0 -mD dpk.o tags.o ColourBars.c -o ColourBars
**
** Colourlists are those nice colour gradients used in demos and games,
** usually  sitting in the background of your screen.  You can use them to
** get more colours on screen than what is really available.  Be warned that
** many graphics cards do not support this feature and will not display
** anything.
** 
** You can move the green colour bar by moving the mouse up and down.  Pressing
** the right mouse button tests the Hide() and Display() actions.  Press the
** left mouse button to exit the demo.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Colour Bars";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Raster demonstration.";

LONG ColourBar1[] = {
  0x100000,0x200000,0x300000,0x400000,0x500000,0x600000,0x700000,0x800000,0x900000,0xa00000,
  0xb00000,0xc00000,0xd00000,0xe00000,0xe00000,0xe00000,0xd00000,0xc00000,0xb00000,0xa00000,
  0x900000,0x800000,0x700000,0x600000,0x500000,0x400000,0x300000,0x200000,0x100000,0x000000,
  -1
};

LONG ColourBar2[] = {
  0x001000,0x002000,0x003000,0x004000,0x005000,0x006000,0x007000,0x008000,0x009000,0x00a000,
  0x00b000,0x00c000,0x00d000,0x00e000,0x00f000,0x00e000,0x00d000,0x00c000,0x00b000,0x00a000,
  0x009000,0x008000,0x007000,0x006000,0x005000,0x004000,0x003000,0x002000,0x001000,0x000000,
  -1
};

LONG ColourBar3[] = {
  0x000010,0x000020,0x000030,0x000040,0x000050,0x000060,0x000070,0x000080,0x000090,0x0000a0,
  0x0000b0,0x0000c0,0x0000d0,0x0000e0,0x0000f0,0x0000e0,0x0000d0,0x0000c0,0x0000b0,0x0000a0,
  0x000090,0x000080,0x000070,0x000060,0x000050,0x000040,0x000030,0x000020,0x000010,0x000000,
  -1
};

struct RColourList RColourList1;
struct RColourList RColourList2;
struct RColourList RColourList3;

struct RColourList RColourList1 = {
  ID_RASTCOLOURLIST, 1, NULL, NULL, (struct RHead *)&RColourList2,
  000,3,0,ColourBar1
};

struct RColourList RColourList2 = {
  ID_RASTCOLOURLIST, 1, NULL, (struct RHead *)&RColourList1, (struct RHead *)&RColourList3,
  100,1,0,ColourBar2
};

struct RColourList RColourList3 = {
  ID_RASTCOLOURLIST, 1, NULL, (struct RHead *)&RColourList2, NULL,
  170,1,0,ColourBar3
};

/***************************************************************************/

void main(void)
{
   struct GScreen *Screen;
   struct Raster  *Raster;
   struct JoyData *JoyData;
   WORD   tick = NULL;

   if (Raster = Get(ID_RASTER)) {

      Raster->Command = (struct RHead *)&RColourList1;
      Raster->Command->Prev = (struct RHead *)Raster;

      if (Screen = InitTags(NULL,
          TAGS_SCREEN, NULL,
          GSA_Raster,  Raster,
          GSA_Attrib,  SCR_BLKBDR,
          TAGEND)) {

         Display(Screen);

         if (JoyData = Init(Get(ID_JOYDATA),NULL)) {
            do {
               Query(JoyData);
               RColourList2.YCoord += JoyData->YChange;
               if (RColourList2.YCoord < 0)   RColourList2.YCoord = 0;
               if (RColourList2.YCoord > 226) RColourList2.YCoord = 226;
               Activate(Raster);
               WaitAVBL();

               if ((JoyData->Buttons & JD_RMB) AND (tick IS NULL)) {
                  if (Raster->Flags & RSF_DISPLAYED) {
                     Hide(Raster);
                  }
                  else {
                     Display(Raster);
                  }
                  tick = 25;
               }

               if (tick) tick--;

            } while (!(JoyData->Buttons & JD_LMB));
         Free(JoyData);
         }
      Free(Screen);
      }
   Free(Raster);
   }
}

