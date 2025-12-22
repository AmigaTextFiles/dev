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

#define	LIBQDISPLAY_CORE
#include "../include/libqdisplay.h"

/*
 *   Render a Quake polygon:
 *      read it from the db
 *      transform it into 3d
 *      clip it in 3d
 *      compute the 2d texture gradients
 *      scan convert
 *      pass off the spans
 */

/* drawing */
displaypointer texture;
int textureRow;
int textureMask1, textureMask2;
short int textureShift1, textureShift2;
short int textureMip;
short int textureType;
unsigned char textureColor;

#ifndef __OPTIMIZE__
#include "draw-orig.c"
#else
#include "draw-opti.c"
#endif

staticfnc inline void draw_poly(int n, point_3d ** vl)
{
  int i, j, y, ey;
  fix ymin, ymax;

  /* find max and min y height */
  ymin = ymax = vl[0]->sy;
  for (i = 1; i < n; ++i) {
    if (vl[i]->sy < ymin)
      ymin = vl[i]->sy;
    else if (vl[i]->sy > ymax)
      ymax = vl[i]->sy;
  }

  /* scan out each edge */
  j = n - 1;
  for (i = 0; i < n; ++i) {
    scan_convert(vl[i], vl[j]);
    j = i;
  }

  y = FIX_INT(ymin);
  ey = FIX_INT(ymax);

#ifndef __OPTIMIZE__
  for (; y < ey; y++) {
    int sx = FIX_INT(scan[y][0]);
    int ex = FIX_INT(scan[y][1]);

    if (ex - sx) {
      /* iterate over all spans and draw */
#ifdef DRIVER_8BIT
      if (localDim.frameDepth <= 8) {
	if (actView->displayType == DISPLAY_TEXTURED)
	  draw_spans8(y, sx, ex);
	else if (actView->displayType == DISPLAY_FLAT)
	  draw_spans8flat(y, sx, ex);
	else if (actView->displayType == DISPLAY_WIRE)
	  draw_spans8wire(y, sx, ex);
      }
      else
#endif
#ifdef DRIVER_16BIT
      if (localDim.frameDepth <= 16)
	draw_spans16(y, sx, ex);
      else
#endif
#ifdef DRIVER_24BIT
      if (localDim.frameDepth <= 24)
	draw_spans24(y, sx, ex);
      else
#endif
#ifdef DRIVER_32BIT
#endif
	;
    }
  }
#else
  /* iterate over all spans and draw */
#ifdef DRIVER_8BIT
  if (localDim.frameDepth <= 8) {
    if (actView->displayType == DISPLAY_TEXTURED)
      draw_spans8(y, ey);
    else if (actView->displayType == DISPLAY_FLAT)
      draw_spans8flat(y, ey);
    else if (actView->displayType == DISPLAY_WIRE)
      draw_spans8wire(y, ey);
  }
  else
#endif
#ifdef DRIVER_16BIT
  if (localDim.frameDepth <= 16)
    draw_spans16(y, ey);
  else
#endif
#ifdef DRIVER_24BIT
  if (localDim.frameDepth <= 24)
    draw_spans24(y, ey);
  else
#endif
#ifdef DRIVER_32BIT
#endif
    ;
#endif
}

staticvar point_3d defaultPoints[32], *defaultVList[32];

void setup_default_point_list(void)
{
  int i;

  for (i = 32 - 1; i >= 0; --i)
    defaultVList[i] = &defaultPoints[i];
}

/* calculation */
staticfnc short int compute_mip_level(bspBase bspMem, int face)
{
  /*
   * dumb algorithm: grab 3d coordinate of some vertex,
   * compute dist from viewer
   */
  double dist;
  int se = bspMem->shared.quake1.dfaces[face].firstedge;
  int e = bspMem->shared.quake1.dsurfedges[se];

  if (e < 0)
    e = -e;
  dist = scalw(dist2_from_viewer((vec1D *) & bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[e].v[0]].point), -16);	/* / 65536; */
  if (dist < 1)
    return 0;
  if (dist < 4)
    return 1;
  if (dist < 16)
    return 2;
  return 3;
}

staticfnc void compute_texture_gradients(bspBase bspMem, struct texture *Text, short int mip)
{
  vec1D uu, vv;
  vec1D tmp0, tmp1, tmp2;
  vec3D P, M, N;

  /* project vectors onto face's plane, and transform */
  transform_vector(M, Text->textGradient.uv0);
  transform_vector(N, Text->textGradient.uv1);
  transform_point_raw(P, Text->textGradient.scaled);

  uu = Text->textGradient.u;
  vv = Text->textGradient.v;

  /*
   * we could just subtract (u,v) every time we compute a new (u,v);
   * instead we fold it into P:
   */
  P[0] += uu * M[0] + vv * N[0];
  P[1] += uu * M[1] + vv * N[1];
  P[2] += uu * M[2] + vv * N[2];

  /*
   * offset by Center of screen--if this were folded into
   * transform translation we could avoid it
   */
  tmp2 = N[0] * M[2] - N[2] * M[0];
  tmp1 = N[1] * M[2] - N[2] * M[1];
  tmp0 = N[0] * M[1] - N[1] * M[0];
  tmp0 -= tmp1 * xCenter + tmp2 * yCenter;
  tmap[8] = tmp2;
  tmap[7] = tmp1;
  tmap[6] = tmp0;

  tmp2 = P[2] * M[0] - P[0] * M[2];
  tmp1 = P[2] * M[1] - P[1] * M[2];
  tmp0 = P[1] * M[0] - P[0] * M[1];
  tmp0 -= tmp1 * xCenter + tmp2 * yCenter;
  tmap[5] = scalw(tmp2, -mip);
  tmap[4] = scalw(tmp1, -mip);
  tmap[3] = scalw(tmp0, -mip);

  tmp2 = P[0] * N[2] - P[2] * N[0];
  tmp1 = P[1] * N[2] - P[2] * N[1];
  tmp0 = P[0] * N[1] - P[1] * N[0];
  tmp0 -= tmp1 * xCenter + tmp2 * yCenter;
  tmap[2] = scalw(tmp2, -mip);
  tmap[1] = scalw(tmp1, -mip);
  tmap[0] = scalw(tmp0, -mip);
}

void draw_face(bspBase bspMem, int face)
{
  int n = bspMem->shared.quake1.dfaces[face].numedges;
  int se = bspMem->shared.quake1.dfaces[face].firstedge;
  int i, edge, codes_or = 0, codes_and = 0xff;
  /* clipping */
  point_3d **vlist;

  for (i = 0; i < n; ++i) {
    edge = bspMem->shared.quake1.dsurfedges[se + i];

    if (edge < 0)
      transform_point(&defaultPoints[i], (vec1D *) & bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[-edge].v[1]].point);
    else
      transform_point(&defaultPoints[i], (vec1D *) & bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[edge].v[0]].point);

    codes_or |= defaultPoints[i].ccodes;
    codes_and &= defaultPoints[i].ccodes;
  }

  if (codes_and)
    return;
  if (codes_or)							/* poly crosses frustrum, so clip it */
    n = clip_poly(n, defaultVList, codes_or, &vlist);
  else
    vlist = defaultVList;

  /*
   * with this texChange-technique it is possible for example
   * to let light render the bsp-tree, then light marks the
   * last processed face as changed and render the tree again
   * and voila, everything is unchanged but the new lightface
   */
  if (n) {
    struct texture *Text;

    Text = GetCache(bspMem, face);

    if ((textureMip = compute_mip_level(bspMem, face)) != Text->lastMip)	/* if the mipmap changes, the tex and it lights changes too */
      for (i = 0; i < Text->animMax; i++);
        Text->texChanged[i] = TRUE;

    GetTMap(bspMem, Text, textureMip);				/* GetTMap must have the capability to set texChange */
    compute_texture_gradients(bspMem, Text, textureMip);
    draw_poly(n, vlist);

    Text->lastMip = textureMip;					/* set last mip here, perhaps GetTMap should use the old value */

    /*
     * should we free the whole face if it is an ANIM_MIPMAP?
     * perhaps the sizes etc. changes ...
     */
  }
}
