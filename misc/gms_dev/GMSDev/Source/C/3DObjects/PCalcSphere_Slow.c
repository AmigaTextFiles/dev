/* SAS/C: sc PCalcSphere_Slow.c opt math=standard INCDIR=INCLUDES:
**
** This is a demo of a spinning sphere consisting entirely of dots.  The
** object is pre-calculated into a set of animations.
**
** WARNING: This pre-calculated version has 360 frames of animation!
** It requires * 1.5 MEGS * to run, so make sure you have enough memory, and
** maybe make a cup of coffee while waiting for it to generate the anim...
** If you want it to run faster, get rid of the floating math and replace it
** with integers.
**
** If you have a lot of memory and don't mind waiting, try increasing the
** amount of dots to a larger number.
*/

#include <proto/dpkernel.h>
#include <system/debug.h>
#include <math.h>

BYTE *ProgName      = "Spinning Sphere";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "February 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "3-Dimensional object demonstration.";

struct GScreen *screen;
struct JoyData *jport;

void Demo(void);
void CalcFrames(void);

#define AMTDOTS 500          /* The amount of dots in the object. */
#define FRAMES  360          /* How many frames? [1280,640,360,180,90,45] */
#define ANGLE   (360/FRAMES) /* Angle/Speed is dependant on the amount of frames */
#define SCALE   80           /* Increase the scale to make the object larger */

struct DotPixel { double X,Y,Z; };

LONG palette[] = {
  PALETTE_ARRAY,32,
  0x000000L,0x101010L,0x171717L,0x202020L,0x272727L,0x303030L,0x373737L,0x404040L,
  0x474747L,0x505050L,0x575757L,0x606060L,0x676767L,0x707070L,0x777777L,0x808080L,
  0x878787L,0x909090L,0x979797L,0xa0a0a0L,0xa7a7a7L,0xb0b0b0L,0xb7b7b7L,0xc0c0c0L,
  0xc7c7c7L,0xd0d0d0L,0xd7d7d7L,0xe0e0e0L,0xe0e0e0L,0xf0f0f0L,0xf7f7f7L,0xffffffL
};

struct PixelEntry *lists[FRAMES];

struct PixelList PixelList = {
  AMTDOTS,
  sizeof(struct PixelEntry),
  NULL
};

/***********************************************************************************/

void main(void)
{
  WORD i;

  if (screen = InitTags(NULL,
     TAGS_SCREEN,    NULL,
     GSA_Attrib,     SCR_DBLBUFFER,
       GSA_BitmapTags, NULL,
       BMA_Palette,    palette,
       TAGEND, NULL,
     TAGEND)) {

     if (jport = Init(Get(ID_JOYDATA),NULL)) {
        for (i=0; i < FRAMES; i++) lists[i] = NULL; /* Clear the array */

        for (i=0; i < FRAMES; i++) {
           if (!(lists[i] = AllocMemBlock(sizeof(struct PixelEntry)*AMTDOTS,MEM_DATA)))
              goto free; /* Nasty break */
        }
        PixelList.Pixels = lists[i];

        CalcFrames();

        Demo();

free:   for (i=0; i < FRAMES; i++) {
           FreeMemBlock(lists[i]);
        }

     Free(jport);
     }
  Free(screen);
  }
}

/************************************************************************************
**
*/

void Demo(void)
{
  WORD i=NULL;

  Display(screen);

  do {
    Query(jport);
    Clear(screen->Bitmap);

    PixelList.Pixels = lists[i];

    DrawPixelList(screen->Bitmap,&PixelList);

    i++;
    if (i >= FRAMES) {
       i = NULL;
    }

    WaitAVBL();
    SwapBuffers(screen);
  } while(!(jport->Buttons & JD_LMB));
}

/************************************************************************************
** Longtitude deterimines the position of the dot on the horizontal axis.
** Latitude determines the position of the dot on the vertical axis.
*/

void CalcFrames(void)
{
  struct DotPixel *object; /* Pointer to our 3D object */
  double *sine;            /* Pointer to our sine table */
  double *cosine;         /* Pointer to our cosine table */
  register WORD   i,j,t;
  WORD   offsetx = (screen->Width/2);
  WORD   offsety = (screen->Height/2);
  double angle   = 0;
  LONG   scale   = SCALE;
  UWORD  anglex  = 0, angley = 0, anglez = 0;
  double temp;
  ULONG  colour;
  double Z2,X2,Y2;
  double longtitude;
  double latitude;
  struct PixelEntry *Entry;

  DMsg("Allocating 3D calculation memory.");

  if (object = AllocMemBlock(sizeof(struct DotPixel)*AMTDOTS,MEM_DATA)) {
   if (sine   = AllocMemBlock(sizeof(double)*360,MEM_DATA)) {
    if (cosine = AllocMemBlock(sizeof(double)*360,MEM_DATA)) {

     /* First calculate the X, Y and Z coordinates of our object */

     DMsg("Calculating the object's coordinates.");

     for (i = 0; i < AMTDOTS; i++) {
       longtitude = FastRandom(100);
       latitude   = FastRandom(100);
       object[i].X  = sin(longtitude)*cos(latitude);
       object[i].Y  = sin(longtitude)*sin(latitude);
       object[i].Z  = cos(longtitude);
     }

     DMsg("Generating sine and cosine tables.");

     /* Now generate our cosine and sinus tables */

     for (i = 0; i < 360; i++) {
       cosine[i] = cos(angle);
       sine[i]   = sin(angle);
       angle    += 0.25;
     }

     /* Do our big pre-calculation loop */

     DMsg("Big calculation loop is starting now...");

     for (j = 0; j < FRAMES; j++) {

       Entry = lists[j];

       DPrintF("Frame:","%d",j);

       for (i = 0; i < AMTDOTS; i++) {
         X2 = object[i].X;
         Y2 = object[i].Y;
         Z2 = object[i].Z;
  
         temp = Z2; /* X axis */
         Z2 = (Z2 * cosine[anglex]) - (Y2 * sine[anglex]);
         Y2 = (Y2 * cosine[anglex]) + (temp * sine[anglex]);

         temp = Z2; /* Y axis */
         Z2 = (Z2 * cosine[angley]) - (X2 * sine[angley]);
         X2 = (X2 * cosine[angley]) + (temp * sine[angley]);

         colour = ((Z2+1)*screen->Bitmap->AmtColours)/2;

         Entry->XCoord = (X2*scale)+offsetx;
         Entry->YCoord = (Y2*scale)+offsety;
         Entry->Colour = colour;
         Entry++;
       }
       anglex += ANGLE; if (anglex >= 360) anglex = 0;
       angley += ANGLE; if (angley >= 360) angley = 0;
       anglez += ANGLE; if (anglez >= 360) anglez = 0;
     }
    FreeMemBlock(cosine);
    }
   FreeMemBlock(sine);
   }
  FreeMemBlock(object);
  }
}

