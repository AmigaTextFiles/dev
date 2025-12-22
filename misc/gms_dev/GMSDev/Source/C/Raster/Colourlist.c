/* Displays a colour list (24 bit colour lines).  To exit the demo, press the
** left mouse button.
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Colour List Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Colour list demonstration.";

LONG Colourlist[257];

struct RColourList RColourList = {
  ID_RASTCOLOURLIST, 1, NULL, NULL, NULL,
  000,1,0,Colourlist
};

void main(void)
{
   struct GScreen *Screen;
   struct JoyData *joydata;
   struct Raster  *Raster;
   WORD i;

   if (Raster = Get(ID_RASTER)) {

      Raster->Command = (struct RHead *)&RColourList;

      for (i=0; i<257; i++) {   /* Generate our colourlist */
        Colourlist[i] = i<<16;
      } Colourlist[i] = -1;

      if (joydata = Init(Get(ID_JOYDATA),NULL)) {
         if (Screen = InitTags(NULL,
              TAGS_SCREEN, NULL,
              GSA_Raster,  Raster,
              TAGEND)) {

            Display(Screen);

            while (!(joydata->Buttons & JD_LMB)) {
               Query(joydata);
               WaitAVBL();
            }

         Free(Screen);
         }
      Free(joydata);
      }
   Free(Raster);
   }
}

