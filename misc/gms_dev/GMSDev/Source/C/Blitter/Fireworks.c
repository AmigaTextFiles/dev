/* Name:   Fireworks Demo
** Author: Paul Manias
**
*/

#include <proto/dpkernel.h>

BYTE *ProgName      = "Fireworks Demo";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "May 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1998.  Freely distributable.";
BYTE *ProgShort     = "A new fireworks demo for GMS.";

#define AMT_FIREWORKS 7   /* Maximum fireworks (7, 15, 31 only) */
#define AMT_PIXELS    60  /* Maximum pixel burst for each firework */
#define GRAVITY       1

struct Spark {
  WORD XCoord;
  WORD YCoord;
  LONG Colour;
  WORD XSpeed;
  WORD YSpeed; 
};

struct Firework {
  WORD XCoord;
  WORD YCoord;
  WORD XSpeed;
  WORD YSpeed;
  WORD Colour;
  WORD BurstCount;
  struct Spark Pixels[AMT_PIXELS];
};

struct Firework Fireworks[AMT_FIREWORKS];

struct PixelList PixelList = {
  AMT_PIXELS,
  sizeof(struct Spark),
  NULL
};

struct GScreen *Screen;

/***************************************************************************/

void SetFirework(struct Firework *Firework)
{
   Firework->XCoord = FastRandom(Screen->Width);
   Firework->YCoord = Screen->Height;
   Firework->XSpeed = FastRandom(10)-5;
   Firework->YSpeed = -(FastRandom(10)+10);
   Firework->BurstCount = FastRandom(20)+10;

   Screen->Bitmap->Palette[Firework->Colour+3] = ((FastRandom(100)+150)<<16) | ((FastRandom(100)+150)<<8) | (FastRandom(100)+150);
}

/***************************************************************************/

void main(void)
{
  WORD i, j;
  struct JoyData *joy;
  struct RGB *Pixel;

  if (Screen = InitTags(NULL,
       TAGS_SCREEN,    NULL,
       GSA_Attrib,     SCR_DBLBUFFER,
       TAGEND)) {

    if (joy = Init(Get(ID_JOYDATA),NULL)) {
       Show(Screen);

       /*** Setup the fireworks ***/

       for (i=0; i < AMT_FIREWORKS; i++) {
          Fireworks[i].Colour = i;
          SetFirework(&Fireworks[i]);
       }

       UpdatePalette(Screen);

       /*** Main loop ***/

       do {
         Clear(Screen->Bitmap);
         Query(joy);

         for (i=0; i < AMT_FIREWORKS; i++) {
            if (Fireworks[i].BurstCount > 0) {
               Fireworks[i].XCoord += Fireworks[i].XSpeed;
               Fireworks[i].YCoord += Fireworks[i].YSpeed;
               Fireworks[i].YSpeed += GRAVITY;
               Fireworks[i].BurstCount--;
               DrawPixel(Screen->Bitmap, Fireworks[i].XCoord, Fireworks[i].YCoord, Fireworks[i].Colour);

               if (Fireworks[i].BurstCount IS 0) {
                  /*** Explode the firework by setting up the pixel list ***/

                  for (j=0; j < AMT_PIXELS; j++) {
                     Fireworks[i].Pixels[j].XCoord = Fireworks[i].XCoord;
                     Fireworks[i].Pixels[j].YCoord = Fireworks[i].YCoord;
                     Fireworks[i].Pixels[j].Colour = Fireworks[i].Colour;
                     Fireworks[i].Pixels[j].XSpeed = FastRandom(14)-7 ;
                     Fireworks[i].Pixels[j].YSpeed = -(FastRandom(20));
                  }
               }
            }
            else {
               /*** Explosion is active ***/

               for (j=0; j < AMT_PIXELS; j++) {
                  Fireworks[i].Pixels[j].XCoord += Fireworks[i].Pixels[j].XSpeed;
                  Fireworks[i].Pixels[j].YCoord += Fireworks[i].Pixels[j].YSpeed;
                  Fireworks[i].Pixels[j].YSpeed += GRAVITY;
               }
               Fireworks[i].BurstCount--;

               /*** Lower colour values ***/

               Pixel = (struct RGB *)(&Screen->Bitmap->Palette[Fireworks[i].Colour+3]);
               if (Pixel->Red   > 3) Pixel->Red   -= 3;
               if (Pixel->Green > 3) Pixel->Green -= 3;
               if (Pixel->Blue  > 3) Pixel->Blue  -= 3;

               /*** Draw the pixels ***/

               PixelList.Pixels = (struct PixelEntry *)&Fireworks[i].Pixels;
               DrawPixelList(Screen->Bitmap,&PixelList);

               if (Fireworks[i].BurstCount < -50) {
                  SetFirework(&Fireworks[i]);
               }
            }
         }

         UpdatePalette(Screen);

         WaitAVBL();
         SwapBuffers(Screen);
       } while (!(joy->Buttons & JD_LMB));

    Free(joy);
    }
  Free(Screen);
  }
}

