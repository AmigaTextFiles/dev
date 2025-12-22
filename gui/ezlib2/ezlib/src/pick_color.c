/* this file contains functions associated with picking the correct
 * colors for highlighting gadgets.
 *
 *  Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


/* these are the two variables we're concerned with setting */
BYTE EzLightPen = 2, EzDarkPen = 1;


/* here we use the colormap of the screen (which could be workbench) to
 * pick out the light and dark colors.
 */
void PickHighlightColors(struct Screen *screen)
{
  int i, num_colors = 1, dist_squared;
  UWORD value;
  ULONG  light_dist, dark_dist, red, green, blue;
  UWORD lightpen, darkpen;
  struct ColorMap *cmap;

  if (screen == NULL)
    return;

  cmap = screen->ViewPort.ColorMap;
  for(i=0; i < screen->BitMap.Depth; i++)
    num_colors *= 2;

  /* set up opposite values so they get changed when we loop through */
  light_dist = 0;   dark_dist = 0x7fffffff;

  /* start at 1 because we don't want to consider the background color */
  for(i=1; i < num_colors; i++)
   {
     value = (UWORD)GetRGB4(cmap, i);
     red = (value >> 8);  green = (value >> 4) & 0x0f; blue = value & 0x0f;

     dist_squared = red*red + green*green + blue*blue;


     if (dist_squared > light_dist)
       { light_dist = dist_squared; lightpen = i; }

     if (dist_squared < dark_dist)
       { dark_dist = dist_squared; darkpen = i; }
   }

  EzLightPen = (BYTE)lightpen;
  EzDarkPen  = (BYTE)darkpen;
}
