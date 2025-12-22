/*
sc:c/sc opt txt/RGBtoHAM8.c
*/

#include "Decode.h"

#define abs(x) ((x)<0?-(x):(x))
#define DELTA(x1,x2) abs((x1)-(x2))
#define NUM_GUNS 3

/* /// "RGBtoHAM8()" */
void __asm RGBtoHAM8(register __a0 uchar *rgb,
                     register __a1 uchar *ham8,
                     register __d0 ulong width,
                     register __d1 ulong height)
{
  uchar oRed, oGreen, oBlue;
  uchar dRed, dGreen, dBlue;
  uchar red, green, blue;
  ulong xp, yp;

  for (yp=height; yp>0; yp--) {
    oRed=0;
    oGreen=0;
    oBlue=0;

    for (xp=width; xp>0; xp--) {
      red=rgb[0] >> 2;
      green=rgb[1] >> 2;
      blue=rgb[2] >> 2;
      rgb+=3;

      if ((red==oRed) && (green==oGreen) && (blue==oBlue)) {
        switch (xp%NUM_GUNS) {
          case 0:
           *ham8++=0x80 | red;
           break;
          case 1:
           *ham8++=0xC0 | green;
           break;
          case 2:
           *ham8++=0x40 | blue;
        }
        continue;
      }

      dRed=DELTA(red,oRed);
      dGreen=DELTA(green,oGreen);
      dBlue=DELTA(blue,oBlue);
      if (dRed>dGreen) {
        if (dRed>dBlue) {
          *ham8++=0x80 | red;
          oRed=red;
        } else {
          *ham8++=0x40 | blue;
          oBlue=blue;
        }
      } else {
        if (dGreen>dBlue) {
          *ham8++=0xC0 | green;
          oGreen=green;
        } else {
          *ham8++=0x40 | blue;
          oBlue=blue;
        }
      }
    }
  }
}
/* \\\ */

