/* Dice: dcc -l0 -mD dpk.o tags.o DoubleBuffer.c -o DoubleBuffer
**
** This simple demo shows how to double buffer the screen.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Double Buffer Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "February 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Demonstration of double buffering.";

void main(void)
{
  struct Picture *picture;
  struct GScreen *screen;
  struct JoyData *JoyData;
  struct FileName PicFile = { ID_FILENAME, "GMS:demos/data/PIC.Green" };

  if (picture = Load(&PicFile, ID_PICTURE)) {
     screen = Get(ID_SCREEN);
     CopyStructure(picture,screen);
     screen->Attrib = SCR_DBLBUFFER|SCR_CENTRE;

     if (screen = Init(screen,NULL)) {

        Copy(picture->Bitmap,screen->Bitmap);

        if (JoyData = Init(Get(ID_JOYDATA),NULL)) {
           Display(screen);
           Query(JoyData);

           while (!(JoyData->Buttons & JD_LMB)) {
             WaitAVBL();
             SwapBuffers(screen);
             Query(JoyData);
           }
        Free(JoyData);
        }
     Free(picture);
     }
  Free(screen);
  }
}

