/* Dice: 1> dcc -l0 -mD dpk.o tags.o SetField.c -o SetField
**
** This demo tests the SetField() and GetField() functions.
*/

#include <proto/dpkernel.h>
#include <system/sysobject.h>

BYTE *ProgName      = "SetField";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "August 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1998.  Freely distributable.";
BYTE *ProgShort     = "Field Orientation demo.";

struct GScreen  *screen;
struct Restore  *restore;
struct Bob      *Rabbit;
struct JoyData  *joydata;
struct Picture  *bobpic;
struct FileName bobfile  = { ID_FILENAME, "GMS:demos/data/Rabbit.iff" };

WORD RabbitFrames[] = {
   /* Right 0 - 7 */
   0,0, 8,0, 16,0, 24,0, 32,0, 40,0, 48,0, 56,0,

   /* Left 8 - 15 */
   120,0, 112,0, 104,0, 96,0, 88,0, 80,0, 72,0, 64,0,

   /* Jumping 16 - 24 */
   128,0, 136,0, 144,0, 152,0, 160,0, 168,0, 176,0, 184,0, 192,0,

   /* Backward Flip 25 - 47 */
   0,16,     8,16,  16,16,  24,16,  32,16,  40,16,  48,16,  56,16,
   64,16,   72,16,  80,16,  88,16,  96,16, 104,16, 112,16, 120,16,
   128,16, 136,16, 144,16, 152,16, 160,16, 168,16, 176,16,
   -1,-1
};

void Demo(void);
void Wrap(struct Bob *);

/***************************************************************************/

void main(void) {
  LONG *palette;

  if (bobpic = Get(ID_PICTURE)) {
     SetField(bobpic,FID_Source,(LONG)&bobfile);
     SetField(bobpic->Bitmap,FID_MemType,MEM_BLIT);

   if (Init(bobpic,NULL)) {

    if (screen = Get(ID_SCREEN)) {
     if (palette = CloneMemBlock(bobpic->Bitmap->Palette,MEM_DATA)) {
        SetField(screen->Bitmap,FID_Palette,(LONG)palette);

      if (Init(screen,NULL)) {

       if (restore = InitTags(screen,
            TAGS_RESTORE, NULL,
            RSA_Entries,  1,
            TAGEND)) {

        if (Rabbit = InitTags(screen,
            TAGS_BOB,      NULL,
            BBA_GfxCoords, RabbitFrames,
            BBA_Width,     8,
            BBA_Height,    16,
            BBA_XCoord,    screen->Width/2,
            BBA_YCoord,    screen->Height/2,
            BBA_Attrib,    BBF_RESTORE|BBF_GENMASKS|BBF_CLIP,
            BBA_SrcBitmap, bobpic->Bitmap,
            TAGEND)) {

         if (joydata = Get(ID_JOYDATA)) {
          if (SetField(joydata,FID_Port,2) IS ERR_OK) {  /* Forces joystick control */

           if (Init(joydata, NULL)) {
              Display(screen); 
              Demo();
           }
          }
         }
        }
       }
      }
     }
    }
   }
  }

  FreeMemBlock(palette);
  Free(joydata);
  Free(Rabbit);
  Free(restore);
  Free(screen);
  Free(bobpic);
}

/***************************************************************************/

void Demo(void)
{
  WORD AnimSpeed = 0;
  WORD Direction = 0;
  WORD Flip = FALSE;

  #define MAXSPEED 3

  do
  {
    Activate(restore); 
    Draw(Rabbit);
    WaitAVBL();
    SwapBuffers(screen);

    /* Animate the Rabbit's movements */

    AnimSpeed++;

    if (AnimSpeed > MAXSPEED) {
       AnimSpeed = 0;
       Rabbit->Frame++;

       if (Direction IS 1) {
          if (Rabbit->Frame < 0) Rabbit->Frame = 0;
          if (Rabbit->Frame > 7) Rabbit->Frame = 0;
       }
       else if (Direction IS -1) {
          if (Rabbit->Frame < 8) Rabbit->Frame  = 8;
          if (Rabbit->Frame > 15) Rabbit->Frame = 8;
       }
       else {
          if (Flip IS FALSE) {
             if (Rabbit->Frame < 16) Rabbit->Frame = 16;
             if (Rabbit->Frame > 24) Rabbit->Frame = 16;
          }
          else {
             if (Rabbit->Frame < 25) Rabbit->Frame = 25;
             if (Rabbit->Frame > 47) Rabbit->Frame = 25;
          }
       }
    }

    /* Get the user input */

    Query(joydata);
    if (Direction != NULL) {
       Rabbit->XCoord += joydata->XChange;
    }

    if (joydata->YChange < 0) {
       if ((Direction != NULL) OR (Flip IS TRUE)) {
          Rabbit->Frame = 16;
          Direction = 0;
          Flip = FALSE;
       }
    }
    else if (joydata->YChange > 0) {
       if ((Direction != NULL) OR (Flip IS FALSE)) {
          Rabbit->Frame = 25;
          Direction = 0;
          Flip = TRUE;
       }
    }
    else if (joydata->XChange > 0) {
       if (Direction IS -1) {   /* If rabbit is facing left, spin right */
          Rabbit->Frame -= 8;
          Direction     = 1;
       }
       else if (Direction IS NULL) {
          Rabbit->Frame = 0;
          Direction     = 1;
       }
    }
    else if (joydata->XChange < 0) {
       if (Direction IS 1) {    /* If rabbit is facing right, spin left */
          Rabbit->Frame += 8;
          Direction     = -1;
       }
       else if (Direction IS NULL) {
          Rabbit->Frame = 8;
          Direction     = -1;
       }
    }

    Wrap(Rabbit);

  } while (!(GetField(joydata,FID_Buttons) & JD_FIRE1));
}

/*****************************************************************************
** Function: This function will wrap a bob to the other side of a screen if
**           it leaves the bob's screen borders.
**
** Synopsis: Wrap(Bob);
*/

void Wrap(struct Bob *bob)
{
  if (bob->XCoord < -bob->Width)  bob->XCoord = bob->DestBitmap->Width;
  if (bob->YCoord < -bob->Height) bob->YCoord = bob->DestBitmap->Height;

  if (bob->XCoord > bob->DestBitmap->Width)  bob->XCoord = -bob->Width;
  if (bob->YCoord > bob->DestBitmap->Height) bob->YCoord = -bob->Height;
}

