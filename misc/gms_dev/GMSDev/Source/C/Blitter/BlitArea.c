/* Dice: 1> dcc -l0 -mD dpk.o tags.o BlitArea.c -o BlitArea
**
** This demo tests the BlitArea() routine.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Area Blitter";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "August 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "BlitArea() demonstration.";

struct GScreen  *screen;
struct JoyData  *joydata;
struct Picture  *background;
struct FileName BackFile = { ID_FILENAME, "GMS:demos/data/PIC.Green" };

void Demo(void);

/***************************************************************************/

void main(void) {
  if (background = Load(&BackFile, ID_PICTURE)) {
   if (screen = Get(ID_SCREEN)) {
      CopyStructure(background, screen);
    if (Init(screen,NULL)) {
     if (Copy(background->Bitmap,screen->Bitmap) IS ERR_OK) {
      if (joydata = Get(ID_JOYDATA)) {
         joydata->Port = 1;     /* Forces mouse control */

       if (Init(joydata, NULL)) {
          Display(screen); 
          Demo();
       }
      }
     }
    }
   }
  Free(joydata);
  Free(screen);
  Free(background);
  }
}

/***************************************************************************/

void Demo(void)
{
  do
  {
    WaitAVBL();
    Query(joydata);

    BlitArea(screen->Bitmap, screen->Bitmap, FastRandom(screen->Width-16)+16,
      FastRandom(screen->Height-16)+16, 16, 16, FastRandom(screen->Width)-8,
      FastRandom(screen->Height)-8, FALSE);

  } while (!(joydata->Buttons & JD_RMB));
}

