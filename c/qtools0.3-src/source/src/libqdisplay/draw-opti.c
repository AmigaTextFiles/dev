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

#if defined(NOASM) || \
    defined(USE_ZBUFFER) || \
    !( \
       ((defined(__mc68020__) || defined(__mc68030__)) && defined(__HAVE_68881__)) || \
        defined(__mc68040__) || \
        defined(__mc68060__) \
     )
# undef	 NOASM
# define NOASM
# undef  staticfnc
# define staticfnc
# undef  staticvar
# define staticvar
#endif

staticvar fix scan[768][2];
staticvar vec1D tmap[9];

/*
 * NOTE: subdivision of 16 is a really hard thig, it works most, but you can see sometimes curved textures
 *       if you have some processorpower use 8 instead!
 */
#define SUBDIV_SHIFT	4
#define SUBDIV		(1 << SUBDIV_SHIFT)
#define	SUBDIV_MASK	(SUBDIV - 1)

/* draw an affine (linear) span starting at dest, n pixels long, */
/* starting at (u,v) in the texture and stepping by (du,dv) each pixel */
/*
 * if we are in liquid, we can calculate the average pixelcolor
 * of the liquid texture (eg. *lava1) and do a transp with this color
 * so we don't need to change the palette, and the accuracity
 * is better
 *
 * we can make the liquid with a falloff if we use the zbuffer,
 * we have the current z-value, and the z-value at that position
 * we sub them and calculate the transparency-level from that
 * (better use every 10th or like that transparency-level: first,
 *  the transparency is not so accurate, that every percent makes
 *  a change, second, all 100% transparency uses 6,5MB cached
 *  tables, both in memory and on disk (horror!))
 * the falloff is calculated from the brightness of the liquid texture
 * and the type, so brighter texture are more transparent than darker
 *
 * the liquid looks more real if the textures after it also warps
 * so we must determine, which textures lies in liquid, probably
 * we can use the same procedure as the liquid itself, maybe
 * we must project the liquids behaviour to the texture (uff)
 *
 * how to determine if a texture lies in liquid? as I know qbsp
 * splits the plaes at every intersection of two polygons, that
 * means we do not need to split the polygon at the liquid-line
 * the disadvatage of the mark-texture-in-liquid is, that while
 * we are in liquid, the textures outside the liquid doesn't warp
 *
 * probably we can do real wave in liquid, for that we do not change
 * the du or dv, but the z-value (upwards) of the polygon in a
 * reproducable caustics manner, the difficulty is, to calculate this
 * values in the very inner loop (draw_affine), thats slow
 *
 * how to avoid this mipmap shiftig and masking in liquid textures:
 * after building the waterblock convert the scanlines from this:
 *
 * +----+ example: memory-block-size is 64*64
 * |****|          mipmap-size is 32*32
 * |    |          memory is linear
 * |    |
 * |    |
 * +----+
 *
 * interally handled as this:   to this:
 *                              
 * +--+                         +----+ we need no shiftig, on masking
 * |**|                         |**  | and it is faster, 'cause the 
 * |**|                         |**  | conversion could be cached and is
 * +--+                         |    | out of the span-draw-inner-loop
 *                              |    |
 *                              +----+
 *
 * we can even remove all the shifting, if we put the warp-textures
 * in a 256*64 block, so the offset is 0x0000xxyy (0b000000000000000000xxxxxx00yyyyyy)
 * that is a 16k-block per watertexture, not too much
 *
 * probably it could be faster, if we call a hook defined in the TextureCache
 */

#ifndef NOASM
#ifdef DRIVER_8BIT
#include "drawSpans8-m68k2.S"
#include "drawSpans8flat-m68k2.S"
#include "drawSpans8wire-m68k2.S"
#endif
#ifdef DRIVER_16BIT
#include "drawSpans16-m68k2.S"
#endif
#ifdef DRIVER_24BIT
#include "drawSpans24-m68k2.S"
#endif
#ifdef DRIVER_32BIT
#endif
#else
#ifdef DRIVER_8BIT
#include "draw-opti8.c"
#include "draw-opti8flat.c"
#include "draw-opti8wire.c"
#endif
#ifdef DRIVER_16BIT
#include "draw-opti16.c"
#endif
#ifdef DRIVER_24BIT
#include "draw-opti24.c"
#endif
#ifdef DRIVER_32BIT
#endif
#endif

/* preparing */
staticfnc inline void scan_convert(point_3d * a, point_3d * b)
{
  int right;
  fix x, dx;
  int y, ey;

  if (a->sy == b->sy)
    return;

  if (a->sy < b->sy)
    right = 0;
  else {
    void *temp = a;

    a = b;
    b = temp;
    right = 1;
  }

  /* compute dxdy */
  dx = FLOAT_TO_INT(scalw((b->sx - a->sx), 16) / (b->sy - a->sy));	/* * 65536.0 */
  x = a->sx;
  y = FIX_INT(a->sy);
  ey = FIX_INT(b->sy);
  x += FLOAT_TO_INT(((double)dx * ((y << 16) - a->sy)) * (1 / 65534.0));

  while (y < ey) {
    scan[y][right] = FIX_INT(x);
    x += dx;
    ++y;
  }
}
