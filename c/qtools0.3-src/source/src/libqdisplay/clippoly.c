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

/* CLIPPOLY.c - LOTS OF WORK TO DO :) */

staticvar point_3d clipPoints[16], *clipList1[40], *clipList2[40];

#define X p[0]
#define Y p[1]
#define Z p[2]

staticfnc void intersect(point_3d * out, point_3d * a, point_3d * b, vec1D where)
{
  /* intersection occurs 'where' % along the line from a to b */
  out->X = a->X + (b->X - a->X) * where;
  out->Y = a->Y + (b->Y - a->Y) * where;
  out->Z = a->Z + (b->Z - a->Z) * where;

  transform_rotated_point(out);
}

/* compute 'where' for various clip planes */
staticfnc vec1D left_loc(point_3d * a, point_3d * b)
{
  return -(a->Z + a->X * actView->clipScaleX) / ((b->X - a->X) * actView->clipScaleX + b->Z - a->Z);
}

staticfnc vec1D right_loc(point_3d * a, point_3d * b)
{
  return (a->Z - a->X * actView->clipScaleX) / ((b->X - a->X) * actView->clipScaleX - b->Z + a->Z);
}

staticfnc vec1D top_loc(point_3d * a, point_3d * b)
{
  return (a->Z - a->Y * actView->clipScaleY) / ((b->Y - a->Y) * actView->clipScaleY - b->Z + a->Z);
}

staticfnc vec1D bottom_loc(point_3d * a, point_3d * b)
{
  return -(a->Z + a->Y * actView->clipScaleY) / ((b->Y - a->Y) * actView->clipScaleY + b->Z - a->Z);
}

/* clip the polygon to each of the view frustrum planes */
int clip_poly(int n, point_3d ** vl, int codes_or, point_3d *** out_vl)
{
  int i, j, k, p = 0;						/* p = index into temporary point pool */

  point_3d **cur;

  if (codes_or & CC_OFF_LEFT) {
    cur = clipList1;
    k = 0;
    j = n - 1;
    for (i = 0; i < n; ++i) {
      /*
       * process edge from j..i
       * if j is inside, add it
       */
      if (!(vl[j]->ccodes & CC_OFF_LEFT))
	cur[k++] = vl[j];
      /* if it crosses, add the intersection point */
      if ((vl[j]->ccodes ^ vl[i]->ccodes) & CC_OFF_LEFT) {
	intersect(&clipPoints[p], vl[i], vl[j], left_loc(vl[i], vl[j]));
	cur[k++] = &clipPoints[p++];
      }
      j = i;
    }
    /* move output list to be input */
    n = k;
    vl = cur;
  }

  if (codes_or & CC_OFF_RIGHT) {
    cur = (vl == clipList1) ? clipList2 : clipList1;
    k = 0;
    j = n - 1;
    for (i = 0; i < n; ++i) {
      if (!(vl[j]->ccodes & CC_OFF_RIGHT))
	cur[k++] = vl[j];
      if ((vl[j]->ccodes ^ vl[i]->ccodes) & CC_OFF_RIGHT) {
	intersect(&clipPoints[p], vl[i], vl[j], right_loc(vl[i], vl[j]));
	cur[k++] = &clipPoints[p++];
      }
      j = i;
    }
    n = k;
    vl = cur;
  }
  if (codes_or & CC_OFF_TOP) {
    cur = (vl == clipList1) ? clipList2 : clipList1;
    k = 0;
    j = n - 1;
    for (i = 0; i < n; ++i) {
      if (!(vl[j]->ccodes & CC_OFF_TOP))
	cur[k++] = vl[j];
      if ((vl[j]->ccodes ^ vl[i]->ccodes) & CC_OFF_TOP) {
	intersect(&clipPoints[p], vl[i], vl[j], top_loc(vl[i], vl[j]));
	cur[k++] = &clipPoints[p++];
      }
      j = i;
    }
    n = k;
    vl = cur;
  }
  if (codes_or & CC_OFF_BOT) {
    cur = (vl == clipList1) ? clipList2 : clipList1;
    k = 0;
    j = n - 1;
    for (i = 0; i < n; ++i) {
      if (!(vl[j]->ccodes & CC_OFF_BOT))
	cur[k++] = vl[j];
      if ((vl[j]->ccodes ^ vl[i]->ccodes) & CC_OFF_BOT) {
	intersect(&clipPoints[p], vl[i], vl[j], bottom_loc(vl[i], vl[j]));
	cur[k++] = &clipPoints[p++];
      }
      j = i;
    }
    n = k;
    vl = cur;
  }

  for (i = 0; i < n; ++i)
    if (vl[i]->ccodes & CC_BEHIND)
      return 0;

  *out_vl = vl;
  return n;
}
