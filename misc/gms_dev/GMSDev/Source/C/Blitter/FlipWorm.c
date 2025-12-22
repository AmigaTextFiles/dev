/* Dice: 1> dcc -l0 -mD dpk.o tags.o FlipWorm.c -o FlipWorm
**
** This modified version of RamboWorm will flip the background before
** running (see FlipHBitmap()).
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Flip Worm";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "July 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Bitmap flip demonstration.";

struct GScreen  *screen;
struct Restore  *restore;
struct Bob      *Worm;
struct JoyData  *joydata;
struct Picture  *background;
struct FileName BackFile = { ID_FILENAME, "GMS:demos/data/PIC.Green" };
struct FileName bobfile  = { ID_FILENAME, "GMS:demos/data/PIC.Rambo" };

WORD WormFrames[] = {
    0,0,  32,0, 64,0,  96,0, 128,0, 160,0, 192,0, 224,0,
  256,0, 288,0, 0,48, 32,48, 64,48,
  -1,-1
};

void Demo(void);
void Wrap(struct Bob *);

/***************************************************************************/

void main(void) {
  if (background = Load(&BackFile, ID_PICTURE)) {
   if (screen = Get(ID_SCREEN)) {
      CopyStructure(background, screen);
      screen->Attrib = SCR_DBLBUFFER;

    if (Init(screen,NULL)) {
       FlipHBitmap(background->Bitmap);

     if (Copy(background->Bitmap,screen->Bitmap) IS ERR_OK) {
        CopyBuffer(screen,BUFFER2,BUFFER1);

      if (restore = InitTags(screen,
           TAGS_RESTORE, NULL,
           RSA_Entries,  1,
           TAGEND)) {

       if (Worm = InitTags(screen,
           TAGS_BOB,      NULL,
           BBA_GfxCoords, WormFrames,
           BBA_Width,     32,
           BBA_Height,    24,
           BBA_XCoord,    150,
           BBA_YCoord,    150,
           BBA_Attrib,    BBF_RESTORE|BBF_GENMASKS|BBF_CLIP,
             BBA_SourceTags, ID_PICTURE,
             PCA_Source,     &bobfile,
               PCA_BitmapTags, NULL,
               BMA_MemType,    MEM_BLIT,
               TAGEND, NULL,
             TAGEND, NULL,
           TAGEND)) {

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
    }
   }
  Free(joydata);
  Free(Worm);
  Free(restore);
  Free(screen);
  Free(background);
  }
}

/***************************************************************************/

void Demo(void)
{
  WORD anim = 0;
  WORD fire = FALSE;
  WORD x1,x2,y1,y2,ax1,ax2,ay1,ay2;

  do
  {
    Activate(restore); 
    Draw(Worm);
    WaitAVBL();
    SwapBuffers(screen);

    /* Animate the Worm's movements */

    anim++;

    if (fire IS FALSE) {
      if (anim > 5) {
        anim = 0;
        Worm->Frame++;
        if (Worm->Frame > 9)
           Worm->Frame = 0;
      }
    }
    else if (anim > 1) {
      anim = 0;
      if (Worm->Frame < 10)
         Worm->Frame = 9;

      Worm->Frame++;

      if (Worm->Frame > 12) {
         if (joydata->Buttons & JD_LMB)
            Worm->Frame = 11;
         else {
            Worm->Frame = 0;
            fire = FALSE;
         }
      }
    }

    /* Get the user input, wrap the bob around if out of bounds */

    Query(joydata);
    Worm->XCoord += joydata->XChange;
    Worm->YCoord += joydata->YChange;
    Wrap(Worm);

    if (joydata->Buttons & JD_LMB) {
       fire = TRUE;
    }

  } while (!(joydata->Buttons & JD_RMB));

  /* Randomly perform a screen wipe effect before
  ** exiting the demo.
  */

  if (FastRandom(5) IS 4) {
     Lock(screen);
     screen->Bitmap->Data = screen->MemPtr1;

     ax1 = x1 = (screen->Width - screen->Height)/2;
     ay1 = y1 = NULL;

     ax2 = x2 = screen->Width - ((screen->Width - screen->Height)/2);
     ay2 = y2 = screen->Height;

     while (x1 < screen->Width) {
        DrawLine(screen->Bitmap,x1++,y1,x2,y2,0,0xffffffff);   /* Up/Right */
        DrawLine(screen->Bitmap,ax1,ay1,ax2--,ay2,0,0xffffffff); /* Down/Left */
        if (ax1 > 0) ax1--; else { ay1++; }
        if (x2 < screen->Width) x2++; else y2--;
        WaitAVBL();
     }

     Unlock(screen);
  }
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

