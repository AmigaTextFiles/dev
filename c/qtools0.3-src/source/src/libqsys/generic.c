/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQSYS_CORE
#include "../include/libqsys.h"

/* processor dependent functions */
#ifndef	SWAPSHORT
short SwapShort(short l)
{
  unsigned char b1, b2;

  b1 = l & 255;
  b2 = (l >> 8) & 255;

  return (b1 << 8) + b2;
}
#endif

#ifndef	SWAPLONG
int SwapLong(int l)
{
  unsigned char b1, b2, b3, b4;

  b1 = l & 255;
  b2 = (l >> 8) & 255;
  b3 = (l >> 16) & 255;
  b4 = (l >> 24) & 255;

  return ((int)b1 << 24) + ((int)b2 << 16) + ((int)b3 << 8) + b4;
}
#endif

#ifndef	SWAPLONGLONG
#define	SWAPLONGLONG
long long int SwapLongLong(long long int l)
{
  unsigned char b1, b2, b3, b4, b5, b6, b7, b8;

  b1 = (l      ) & 255;
  b2 = (l >>  8) & 255;
  b3 = (l >> 16) & 255;
  b4 = (l >> 24) & 255;
  b5 = (l >> 32) & 255;
  b6 = (l >> 40) & 255;
  b7 = (l >> 48) & 255;
  b8 = (l >> 56) & 255;

  return ((long long int)b1 << 56) + 
	 ((long long int)b2 << 48) +
	 ((long long int)b3 << 40) +
	 ((long long int)b4 << 32) +
	 ((long long int)b5 << 24) +
	 ((long long int)b6 << 16) +
	 ((long long int)b7 <<  8) + b8;
}
#endif

#ifndef	SWAPFLOAT
float SwapFloat(float l)
{
  union {
    unsigned char b[4];
    float f;
  } in, out;

  in.f = l;
  out.b[0] = in.b[3];
  out.b[1] = in.b[2];
  out.b[2] = in.b[1];
  out.b[3] = in.b[0];

  return out.f;
}
#endif

#ifndef	SWAPDOUBLE
#define	SWAPDOUBLE
double SwapDouble(double l)
{
  union {
    unsigned char b[8];
    double d;
  } in, out;

  in.d = l;
  out.b[0] = in.b[7];
  out.b[1] = in.b[6];
  out.b[2] = in.b[5];
  out.b[3] = in.b[4];
  out.b[4] = in.b[3];
  out.b[5] = in.b[2];
  out.b[6] = in.b[1];
  out.b[7] = in.b[0];

  return out.d;
}
#endif

/*
 * this is a generic match
 */
#ifndef	MATCH
unsigned char Match(register struct rgb *rawpix, register struct rgb *Palette)
{
  unsigned char palpix = 0;
  short int i;
  short int match = 0x7FFF;

  /* save conversion? has a palette only 6 valid bits? */
  short int rawpixR = (short int)(rawpix->r);
  short int rawpixG = (short int)(rawpix->g);
  short int rawpixB = (short int)(rawpix->b);

  /* find match */
  for (i = 0; i < 256; i++) {
    short int R, G, B, thismatch;

    if ((R = (short int)(Palette[i].r) - rawpixR) < 0)
      R = -R;
    if ((G = (short int)(Palette[i].g) - rawpixG) < 0)
      G = -G;
    if ((B = (short int)(Palette[i].b) - rawpixB) < 0)
      B = -B;
    if ((thismatch = R + G + B) != 0) {
      if (thismatch < match) {
	match = thismatch;
	palpix = (unsigned char)i;
      }
    }
    else
      return (unsigned char)i;
  }
  return palpix;
}
#endif
