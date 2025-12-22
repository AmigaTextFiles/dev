/* Dice: dcc -l0 -mD dpk.o tags.o OBJScreen.c -o OBJScreen
**
** Opens a screen according to the settings in an object file.  See
** GMS:Source/Asm/Objects/OBJ.Screen.s for object definitions.
*/

#include <proto/dpkernel.h>
#include <pragmas/objects_pragmas.h>
#include <system/debug.h>

BYTE *ProgName      = "Object Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "February 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1997-1998.  Freely distributable.";
BYTE *ProgShort     = "External object demonstration.";

struct Module *OBJModule;
APTR OBJBase;

LONG main(void)
{
  struct GScreen *Screen;
  struct Picture *Picture;
  struct JoyData *joydata;
  struct FileName ObjFilename = { ID_FILENAME, "GMS:demos/data/OBJ.Screen" };
  APTR OBJFile;

  if (OBJModule = OpenModule(MOD_OBJECTS,NULL)) {
     OBJBase = OBJModule->ModBase;
     if (OBJFile = Load(&ObjFilename,ID_OBJECTFILE)) {
        if (Picture = PullObject(OBJFile,"Picture")) {
           if (joydata = Init(Get(ID_JOYDATA),NULL)) {
              if (Init(Picture,NULL)) {
                 if (Screen = Get(ID_SCREEN)) {
                    CopyStructure(Picture,Screen);
                    Screen->Attrib  = SCR_CENTRE;
             
                    if (Init(Screen,NULL)) {
                       Copy(Picture->Bitmap,Screen->Bitmap);
                       Display(Screen);
                       while (!(joydata->Buttons & JD_LMB)) {
                          Query(joydata);
                          WaitAVBL();
                       }
                    }

                 Free(Screen);
                 }
              Free(Picture);
              }
           Free(joydata);
           }
        }
     Free(OBJFile);
     }
  Free(OBJModule);
  }

  return(ERR_OK);
}

