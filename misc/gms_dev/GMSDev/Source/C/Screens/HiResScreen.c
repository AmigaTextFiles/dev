/* Dice: dcc -l0 -mD dpk.o tags.o HiResScreen.c -o HiResScreen
**
** Opens a screen of 640x256 pixels in HIRES LACED mode.  You can even try
** SuperHiRes (SHIRES) if you change the appropriate flag in the Screen object.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "High-Resolution Screen";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "February 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "High resolution screen display.";

void main(void)
{
  struct GScreen  *Screen = NULL;
  struct Picture  *pic = NULL;
  struct JoyData  *joydata = NULL;
  struct FileName PicFile = { ID_FILENAME, "GMSDev:Logos/GMSLogo.iff" };

  if (pic = Load(&PicFile, ID_PICTURE)) {
     Screen = Get(ID_SCREEN);
     CopyStructure(pic,Screen);
     Screen->ScrMode = SM_HIRES|SM_LACED;

     if (joydata = Init(Get(ID_JOYDATA),NULL)) {
        if (Init(Screen,NULL)) {

           Copy(pic->Bitmap,Screen->Bitmap);

           Show(Screen);

           while (!(joydata->Buttons & JD_LMB)) {
             WaitAVBL();
             Query(joydata);
           }
        }
     }
  }

  if (Screen)  { Free(Screen);  Screen  = NULL; }
  if (joydata) { Free(joydata); joydata = NULL; }
  if (pic)     { Free(pic);     pic     = NULL; }
}

