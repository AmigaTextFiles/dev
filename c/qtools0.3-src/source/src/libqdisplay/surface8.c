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

staticfnc void BuildSky8(unsigned char *out, unsigned char *in)
{
  __memcpy(out, in, SKY_X * SKY_Y * sizeof(unsigned char));
}

staticfnc void BuildLightBlock8(unsigned char *out, struct bitmap *raw, int x, int y)
{
  int c, dc;
  int a, b, h, c0, c1, c2, c3;
  int y_max = raw->height, x_max = raw->width;
  unsigned char *fullbright = raw->data + lookup(y, raw->width);

  c0 = ((255 << 6) - lightmapIndex[0]);
  c1 = ((255 << 6) - lightmapIndex[1]);
  c2 = ((255 << 6) - lightmapIndex[lightmapWidth]);
  c3 = ((255 << 6) - lightmapIndex[lightmapWidth + 1]);

  c2 = (c2 - c0) >> shift;
  c3 = (c3 - c1) >> shift;

  for (b = 0; b < step; ++b) {
    h = x;
    c = c0;
    dc = (c1 - c0) >> shift;
    for (a = 0; a < step; ++a) {
      unsigned char pel = fullbright[h];

      *out++ = cachedColormap[(c & 0x00003F00) + (int)pel];
      c += dc;
      if (++h == x_max)
	h = 0;
    }
    out += row;
    c0 += c2;
    c1 += c3;
    if (++y == y_max) {
      y = 0;
      fullbright = raw->data;
    }
    else
      fullbright += raw->width;
  }
}

staticvar unsigned char *brightColormap;
staticfnc void BuildBrightBlock8(unsigned char *out, struct bitmap *raw, int x, int y)
{
  int a, b, h;
  int y_max = raw->height, x_max = raw->width;
  unsigned char *fullbright = raw->data + lookup(y, raw->width);

  for (b = 0; b < step; ++b) {
    h = x;
    for (a = 0; a < step; ++a) {
      unsigned char pel = fullbright[h];

      *out++ = brightColormap[(int)pel];
      if (++h == x_max)
	h = 0;
    }
    out += row;
    if (++y == y_max) {
      y = 0;
      fullbright = raw->data;
    }
    else
      fullbright += raw->width;
  }
}
