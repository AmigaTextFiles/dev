/* Dice: 1> dcc -l0 -mD dpk.o ManyScreens.c -o ManyScreens
**
** This demo shows how multiple screens can be initialised in your program.
** The most important thing is that you do not refer to old objects when
** initialising new or duplicate objects.  This is why we keep two variables,
** Screen1 and Screen2, to prevent any mistakes.
**
** In this version a screen is shown, removed, then a second screen is shown
** and removed.
*/

#include <proto/dpkernel.h>
#include <clib/colours_protos.h>

BYTE *ProgName      = "Multiple Screens V1";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "August 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Multiple Screens Demonstration.";

struct GScreen *Screen1    = NULL;
struct GScreen *Screen2    = NULL;
struct JoyData *joydata    = NULL;
struct Picture *background = NULL;
struct Picture *Logo       = NULL;

struct FileName BackFile = { ID_FILENAME, "GMS:demos/data/PIC.Green" };
struct FileName PicFile  = { ID_FILENAME, "GMSDev:Logos/GMSLogo-FullScreen.iff" };

void Demo(void);

/***************************************************************************/

void main(void) {
  if (background = Load(&BackFile, ID_PICTURE)) {
   if (Screen1 = Get(ID_SCREEN)) {
      CopyStructure(background, Screen1);
      Screen1->Attrib  = SCR_DBLBUFFER;

    if (Init(Screen1,NULL)) {

     if (Copy(background->Bitmap,Screen1->Bitmap) IS ERR_OK) {
        CopyBuffer(Screen1,BUFFER2,BUFFER1);

        Free(background);
        background = NULL;

        if (joydata = Get(ID_JOYDATA)) {

           if (Init(joydata, NULL)) {
              Display(Screen1); 

              do
              {
                Query(joydata);
              } while (!(joydata->Buttons & JD_LMB));
           }

           Free(Screen1);
           Screen1 = NULL;

           if (Logo = Load(&PicFile, ID_PICTURE)) {
              if (Screen2 = Get(ID_SCREEN)) {
                 CopyStructure(Logo, Screen2);
                 if (Init(Screen2,NULL)) {
                    if (Copy(Logo->Bitmap,Screen2->Bitmap) IS ERR_OK) {
                       Free(Logo);
                       Logo = NULL;

                       Display(Screen2);
                       do {
                          Query(joydata);
                       } while (!(joydata->Buttons & JD_LMB));
                    }
                 }
                 Free(Screen2);
                 Screen2 = NULL;
              }
              Free(Logo);
              Logo = NULL;
           }
        }
     }
    }
   }
  }
  Free(Screen1);
  Free(Screen2);
  Free(Logo);
  Free(joydata);
  Free(background);
}

