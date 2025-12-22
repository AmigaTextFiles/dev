/* This program demonstrates the use of the EzLib screen functions.
 * It opens two screens, one after the other, scribbles into them, then
 * closes down.
 *
 *  Dominic Giampaolo
 */
#include "inc.h"         /* get all the amiga includes needed */

#include <ezlib.h>

/* protos */
void draw_stuff(struct Screen *screen);



UWORD my_colors[] =
{
  BLACK,  GREY3,  GREY2,  GREY1,  GREY,   GREY0,  WHITE,
  RED,	  ORANGE, YELLOW, GREEN,  BLUE,   INDIGO,
  INDIGO, BLUE,   GREEN,  YELLOW, ORANGE, RED,
  WHITE,  GREY0,  GREY,   GREY1,  GREY2,  GREY3,  BLACK,
  PINK,   ORANGE, PURPLE, GOLD,   INDIGO, YELLOW
};


void main(void)
{
 struct Screen *screen;

 /* make a LoRes 5 bitplane screen */
 screen = CreateScreen(LORES, 5);
 if (screen == NULL)
   {
     MSG("Couldn't create LoRes screen.\n");
     exit(10);
   }

 LoadRGB4(&(screen->ViewPort), my_colors, 32);
 draw_stuff(screen);

 Delay(100);
 KillScreen(screen);

 /* make a HiRes Interlaced 3 bitplane screen */
 screen = CreateScreen(HIRES|LACE, 3);
 if (screen == NULL)
   {
     MSG("Couldn't create HiRes Interlaced screen.\n");
     exit(11);
   }

 LoadRGB4(&(screen->ViewPort), my_colors, 8);
 draw_stuff(screen);

 Delay(100);
 KillScreen(screen);

 exit(0);
}


void draw_stuff(struct Screen *screen)
{
  char blurb[] = "EzLib Screens Example";
  int i,j,k;
  int width, height;
  struct RastPort *rp;

  if (screen == NULL)
    return;

  rp	 = &(screen->RastPort);
  width  = screen->Width  - 1;
  height = screen->Height - 1;

  for(i=0, j=0; i < width; i += 4, j++)
    {
       Move(rp, i,0);
       Draw(rp, 0,height);
       SetAPen(rp, (UBYTE)j);
    }

  for(i=width-2, j=0; i > 0; i -= 4, j++)
    {
       Move(rp, i,0);
       Draw(rp, width,height);
       SetAPen(rp, (UBYTE)j);
    }

  k = TextLength(rp, blurb, strlen(blurb));
  i = (width - k) / 2;
  j = height - rp->TxHeight*2;
  Move(rp, i,j);
  Print(rp, blurb);
}
