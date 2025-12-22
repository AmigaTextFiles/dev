/* Dice: 1> dcc -l0 -mD dpk.o tags.o RainingBobs.c -o RainingBobs
**
** This is a demonstration of raining bobs, which I use as a test routine to
** see how fast some of my blitter routines are.  It's a good example of using
** MBOB's, try out different MAX_IMAGES values to see how many you can get on
** screen.  **120** 16 colour 16x8 bobs just manage to run at full speed on my
** A1200+FAST, change the value if you have a faster machine (600 can be very
** interesting :-).
**
** Technical notes
** ---------------
** This demo takes direct advantage of some special GMS blitting features,
** such as restored clearing without masks (gain: 10%), and 16 pixel
** alignment (gain: 15%).  That allows us to have 25% more Bob's on screen!
**
** The fact that GMS will use the CPU to draw and clear images when the blitter
** is busy gives a boost of about 20%+ on an '020, so the overall advantage
** over a bog standard blitting function (eg BltBitmap()) is at least 40%.
** Given that such a function would have to be called 120 times with newly
** calculated parameters each time to draw, and 120 times to do the clears, we
** are probably looking at least 65% faster... is that good enough?
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Raining Bobs";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "February 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Raining bobs demo.";

#define MAX_IMAGES 115

struct NBEntry {
  struct MBEntry MB;
  WORD   Speed;
  WORD   Set;
  WORD   FChange;
  WORD   Locked;
};

struct GScreen *screen;
struct Restore *restore;
struct MBob    *rain;
struct JoyData *joydata;
struct Picture *bobspic;
struct NBEntry *Images;

WORD counter=0;

WORD RainFrames[] = {
  0,8*0,  0,8*1,  0,8*2,  0,8*3, /* Red rain */
  8,8*0,  8,8*1,  8,8*2,  8,8*3, /* Green rain */
 16,8*0, 16,8*1, 16,8*2, 16,8*3, /* Blue rain */
  -1,-1
};

void Demo(void);
void RegenerateBob(struct MBob *, struct NBEntry *);
void UpdateBob(struct MBob *, struct NBEntry *);

/***************************************************************************/

void main(void) {
  struct FileName bobfile  = { ID_FILENAME, "GMS:demos/data/PIC.Pulse" };

  if (bobspic = InitTags(NULL,
      TAGS_PICTURE, NULL,
        PCA_BitmapTags, NULL,
        BMA_MemType,    MEM_BLIT,
        TAGEND,         NULL,
      PCA_Source,   &bobfile,
      TAGEND)) {

   if (screen = InitTags(NULL,
       TAGS_SCREEN, NULL,
       GSA_Attrib,  SCR_DBLBUFFER,
         GSA_BitmapTags, NULL,
         BMA_Palette,    bobspic->Bitmap->Palette,
         TAGEND,         NULL,
       TAGEND)) {

    if (restore = InitTags(screen->Bitmap,
        TAGS_RESTORE, NULL,
        RSA_Entries,  MAX_IMAGES,
        RSA_Buffers,  2,
        TAGEND)) {

     if (Images = AllocMemBlock(sizeof(struct NBEntry)*MAX_IMAGES,MEM_DATA)) {

      if (rain = InitTags(screen->Bitmap,
          TAGS_MBOB,      NULL,
          MBA_AmtEntries, MAX_IMAGES,
          MBA_GfxCoords,  &RainFrames,
          MBA_Width,      8,
          MBA_Height,     8,
          MBA_Attrib,     BBF_GENMASKS|BBF_CLIP|BBF_CLRNOMASK|BBF_CLEAR,
          MBA_Source,     bobspic,
          MBA_EntrySize,  sizeof(struct NBEntry),
          MBA_EntryList,  Images,
          TAGEND)) {

       if (joydata = Init(Get(ID_JOYDATA), NULL)) {
          Display(screen);
          Demo();
       }
      }
     }
    }
   }
  Free(joydata);
  Free(rain);
  FreeMemBlock(Images);
  Free(restore);
  Free(screen);
  Free(bobspic);
  }
}

/****************************************************************************
** Keep X coordinates at multiples of 8 for increased speed.
*/  

void RegenerateBob(struct MBob *bob, struct NBEntry *entry)
{
  entry->MB.YCoord = -8;
  entry->MB.XCoord = (FastRandom(screen->Width) - (bob->Width/2)) & 0xfff8;
  entry->MB.Frame  = FastRandom(12);
  entry->Speed     = FastRandom(8)+2;
  entry->Set       = (entry->MB.Frame)/3;
  entry->FChange   = 1;
  entry->Locked    = ~entry->Locked;
}

/***************************************************************************/

void UpdateBob(struct MBob *bob, struct NBEntry *entry)
{
   /* Check if bob entry has left the screen */

   entry->MB.YCoord += entry->Speed;

   if (entry->MB.YCoord >= screen->Height) {
      RegenerateBob(bob,entry);
   }

   /* Animation */

   if ((entry->Locked) AND ((counter & 0x0003) IS NULL)) {
      if (entry->FChange < 0) {
         /* Negative */
         if (entry->Set IS 1) {         /* Green */
            if ((--entry->MB.Frame) < 4) {
               entry->FChange  = 1;
               entry->MB.Frame = 4;
            }
         }
         else if (entry->Set IS 2) {    /* Blue */
            if ((--entry->MB.Frame) < 8) {
               entry->FChange  = 1; 
               entry->MB.Frame = 8;
            }
         }
         else {                         /* Red */
            if ((--entry->MB.Frame) < 0) {
               entry->FChange  = 1;
               entry->MB.Frame = 0;
            }
         }
      }
      else {
         /* Positive */
         if (entry->Set IS 1) {        /* Green */
            if ((++entry->MB.Frame) > 7) {
               entry->FChange  = -1;
               entry->MB.Frame = 6;
            }
         }
         else if (entry->Set IS 2) {   /* Blue */
            if ((++entry->MB.Frame) > 11) {
               entry->FChange  = -1; 
               entry->MB.Frame = 10;
            }
         }
         else {                        /* Red */
            if ((++entry->MB.Frame) > 3) {
               entry->FChange  = -1;
               entry->MB.Frame = 2;
            }
         }
      }
   }
}

/***************************************************************************/

void Demo(void)
{
  struct NBEntry *entry;
  WORD i;

  /* Generate the bob entries */

  entry = (struct NBEntry *)rain->EntryList;
  for (i = rain->AmtEntries; i > 0; i--) {
    RegenerateBob(rain,entry);
    entry->MB.YCoord = FastRandom(screen->Height);
    entry++;
  }

  do {
    Query(joydata);
    counter++;

    entry = (struct NBEntry *)rain->EntryList;
    for (i = rain->AmtEntries; i > 0; i--) {
       UpdateBob(rain,entry);
       entry++;
    }

    Activate(restore);
    DrawBob(rain);
    WaitAVBL();
    SwapBuffers(screen);
  } while (!(joydata->Buttons & JD_LMB));
}

