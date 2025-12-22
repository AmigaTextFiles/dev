/* SAS/C: sc Helix.c opt math=standard INCDIR=INCLUDES:
**
** This is a demo of a spinning helix consisting entirely of dots.  The
** object is pre-calculated then rotated in real time for speed, although
** things could be faster than this.  Move the mouse to scale the object
** to any size.
*/

#include <proto/dpkernel.h>
#include <math.h>

BYTE *ProgName      = "Spinning Helix";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "January 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "3-Dimensional object demonstration.";

struct GScreen *screen;
struct JoyData *jport1;

void Demo(void);

struct DotPixel { double X,Y,Z; };

#define AMTCOLOURS 32

LONG palette[AMTCOLOURS+2] = {
  PALETTE_ARRAY,32,
  0x000000L,0x101010L,0x171717L,0x202020L,0x272727L,0x303030L,0x373737L,0x404040L,
  0x474747L,0x505050L,0x575757L,0x606060L,0x676767L,0x707070L,0x777777L,0x808080L,
  0x878787L,0x909090L,0x979797L,0xa0a0a0L,0xa7a7a7L,0xb0b0b0L,0xb7b7b7L,0xc0c0c0L,
  0xc7c7c7L,0xd0d0d0L,0xd7d7d7L,0xe0e0e0L,0xe0e0e0L,0xf0f0f0L,0xf7f7f7L,0xffffffL
};

/***********************************************************************************/

void main(void)
{
  if (screen = InitTags(NULL,
     TAGS_SCREEN,    NULL,
       GSA_BitmapTags, NULL,
       BMA_Palette,    palette,
       TAGEND,         NULL,
     GSA_Attrib,     SCR_DBLBUFFER,
     TAGEND)) {

     if (jport1 = Init(Get(ID_JOYDATA),NULL)) {
        Display(screen);
        Demo();

     Free(jport1);
     }
  Free(screen);
  }
}

/************************************************************************************
** Longtitude deterimines the position of the dot on the horizontal axis.
** Latitude determines the position of the dot on the vertical axis.
*/

#define AMTDOTS 500       /* The amount of dots in the Object. */
#define MAXZ    6.3926    /* MAXZ  */

void Demo(void)
{
  struct DotPixel *object;
  WORD   i;
  WORD   offsetx = (screen->Width/2);
  WORD   offsety = (screen->Height/2);
  double temp;
  double angle=0;
  ULONG  colour;
  double Z2,X2,Y2;
  LONG   scale=16;
  UWORD  anglex=0, angley=0, anglez=0;
  double u,v;
  double *sine;       /* Pointer to our sine table */
  double *cosine;     /* Pointer to our cosine table */

  object = AllocMemBlock(sizeof(struct DotPixel)*AMTDOTS,MEM_DATA);
  sine   = AllocMemBlock(sizeof(double)*360,MEM_DATA);
  cosine = AllocMemBlock(sizeof(double)*360,MEM_DATA);

  /* First calculate the X, Y and Z coordinates of our object. */

  for (i=0; i<AMTDOTS; i++) {
    u = ((double)FastRandom(12566-1)+1)/1000;  /*  0 < u < 4*PI  */
    v = ((double)FastRandom(6283-1)+1)/1000;   /*  0 < v < 2*PI  */
    object[i].X  = cos(u)*(2+cos(v));
    object[i].Y  = sin(u)*(2+cos(v));
    object[i].Z  = (u-2*3.14159)+sin(v);
  }

  /* Now generate our cosine and sinus tables */

  for (i=0; i<360; i++) {
    cosine[i] = cos(angle);
    sine[i]   = sin(angle);
    angle    += 0.25;
  }

  /* Go into our main loop */

  do
  {
    Query(jport1);
    scale += jport1->YChange;
    if (scale < 1) scale = 1;
    if (scale > 100) scale = 100;

    Clear(screen->Bitmap);

    for (i=0; i<AMTDOTS; i++) {

      X2 = object[i].X;
      Y2 = object[i].Y;
      Z2 = object[i].Z;
 
      /* Rotate the X axis */

      temp = Z2;
      Z2 = Z2*cosine[anglex] - Y2*sine[anglex];
      Y2 = Y2*cosine[anglex] + temp*sine[anglex];

      /* Rotate the Y axis */

      temp = Z2;
      Z2 = Z2*cosine[angley] - X2*sine[angley];
      X2 = X2*cosine[angley] + temp*sine[angley];

      /* Rotate the Z axis */

//      temp = X2;
//      X2 = X2*cosine[anglez] - Y2*sine[anglez];
//      Y2 = Y2*cosine[anglez] + temp*sine[anglez];

      /* Calculate colour based on Z position (-1.96 < Z < +1.96) */

      colour = (((Z2+MAXZ)/MAXZ)*screen->Bitmap->AmtColours)/2;

      /* Finally scale the (x,y) coordinates to enlarge or shrink the sphere */

      X2 *= scale;
      Y2 *= scale;

      DrawPixel(screen->Bitmap,(WORD)X2+offsetx,(WORD)Y2+offsety,colour);
    }
    anglex++; if (anglex >= 360) anglex = 0;
    angley++; if (angley >= 360) angley = 0;
    anglez++; if (anglez >= 360) anglez = 0;

    WaitAVBL();
    SwapBuffers(screen);
  } while(!(jport1->Buttons & JD_LMB));

  FreeMemBlock(object);
  FreeMemBlock(sine);
  FreeMemBlock(cosine);
}

