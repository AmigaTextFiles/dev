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

#define	LIBQBUILD_CORE
#include "../include/libqbuild.h"

int c_activewindings, c_peakwindings;

/*=========================================================================== */

void WindingBounds(register struct winding *w, vec3D mins, vec3D maxs)
{
  vec1D v;
  int i, j;

  mins[0] = mins[1] = mins[2] = VEC_POSMAX;
  maxs[0] = maxs[1] = maxs[2] = VEC_NEGMAX;

  for (i = 0; i < w->numpoints; i++) {
    for (j = 0; j < 3; j++) {
      v = w->points[i][j];
      if (v < mins[j])
	mins[j] = v;
      if (v > maxs[j])
	maxs[j] = v;
    }
  }
}
void WindingCenter(register struct winding *w, vec3D center)
{
  int i;

  VectorClear(center);
  for (i = 0; i < w->numpoints; i++)
    VectorAdd(w->points[i], center, center);

  VectorScale(center, 1.0 / w->numpoints, center);
}

vec1D WindingArea(register struct winding *w)
{
  int i;
  vec3D d1, d2, cross;
  vec1D total = 0;

  for (i = 2; i < w->numpoints; i++) {
    VectorSubtract(w->points[i - 1], w->points[0], d1);
    VectorSubtract(w->points[i], w->points[0], d2);
    CrossProduct(d1, d2, cross);
    total += 0.5 * VectorLength(cross);
  }
  return total;
}

/*
 * =================
 * BaseWindingForPlane
 * =================
 */
struct winding *BaseWindingForPlane(register struct plane *p)
{
  int i, x;
  vec1D max, v;
  vec3D org, vright, vup;
  struct winding *w;

  /* find the major axis */
  max = -BOGUS_RANGE;
  x = -1;
  for (i = 0; i < 3; i++) {
    v = fabs(p->normal[i]);
    if (v > max) {
      x = i;
      max = v;
    }
  }
  if (x == -1)
    Error("BaseWindingForPlane: no axis found");

  VectorClear(vup);
  switch (x) {
    case 0:
    case 1:
      vup[2] = 1;
      break;
    case 2:
      vup[0] = 1;
      break;
  }

  v = DotProduct(vup, p->normal);
  VectorMA(vup, -v, p->normal, vup);
  VectorNormalize(vup);

  VectorScale(p->normal, p->dist, org);

  CrossProduct(vup, p->normal, vright);

  VectorScale(vup, 8192, vup);
  VectorScale(vright, 8192, vright);

  /* project a really big axis aligned box onto the plane */
  w = NewWinding(4);

  VectorSubtract(org, vright, w->points[0]);
  VectorAdd(w->points[0], vup, w->points[0]);

  VectorAdd(org, vright, w->points[1]);
  VectorAdd(w->points[1], vup, w->points[1]);

  VectorAdd(org, vright, w->points[2]);
  VectorSubtract(w->points[2], vup, w->points[2]);

  VectorSubtract(org, vright, w->points[3]);
  VectorSubtract(w->points[3], vup, w->points[3]);

  w->numpoints = 4;

  return w;
}

/*
 * =============
 * WindingFromFace
 * =============
 */
struct winding *WindingFromFace(bspBase bspMem, register struct dface_t *f)
{
  int se;
  struct dvertex_t *dv;
  int v;
  struct winding *w;
  int i, j, k;
  vec3D v1, v2;
  int nump;
  vec3D p[MAX_POINTS_ON_WINDING];

  w = NewWinding(f->numedges);
  w->numpoints = f->numedges;

  for (i = 0; i < f->numedges; i++) {
    se = bspMem->shared.quake1.dsurfedges[f->firstedge + i];
    if (se < 0)
      v = bspMem->shared.quake1.dedges[-se].v[1];
    else
      v = bspMem->shared.quake1.dedges[se].v[0];

    dv = &bspMem->shared.quake1.dvertexes[v];
    VectorCopy(dv->point, w->points[i]);
  }

  nump = 0;
  for (i = 0; i < w->numpoints; i++) {
    j = (i + 1) % w->numpoints;
    k = (i + w->numpoints - 1) % w->numpoints;
    VectorSubtract(w->points[j], w->points[i], v1);
    VectorSubtract(w->points[i], w->points[k], v2);
    VectorNormalize(v1);
    VectorNormalize(v2);
    if (DotProduct(v1, v2) < 0.999) {
      VectorCopy(w->points[i], p[nump]);
      nump++;
    }
  }

  if (nump != w->numpoints) {
    w->numpoints = nump;
    __memcpy(w->points, p, nump * sizeof(vec3D));
  }
  return w;
}

/*
 * ==================
 * CopyWinding
 * ==================
 */
struct winding *CopyWinding(register struct winding *w)
{
  int size;
  struct winding *c;

  /*size = (int)((struct winding *)0)->points[w->numpoints];            hell, bloody shit */
  size = (w->numpoints * sizeof(vec3D)) + sizeof(bool) + sizeof(int);

  if (!(c = (struct winding *)tmalloc(size)))
    Error(failed_memoryunsize, "winding");
  __memcpy(c, w, size);
  c->original = FALSE;
  return c;
}

/*
 * ==================
 * CheckWinding
 * 
 * Check for possible errors
 * ==================
 */
void CheckWinding(register struct winding *w)
{
}

void CheckWindingInNode(register struct winding *w, register struct node *node)
{
  int i, j;

  for (i = 0; i < w->numpoints; i++) {
    for (j = 0; j < 3; j++)
      if (w->points[i][j] < node->mins[j] - 1
	  || w->points[i][j] > node->maxs[j] + 1) {
	eprintf("CheckWindingInNode: outside\n");
	return;
      }
  }
}

void CheckWindingArea(register struct winding *w)
{
  int i;
  vec1D total, add;
  vec3D v1, v2, cross;

  total = 0;
  for (i = 1; i < w->numpoints; i++) {
    VectorSubtract(w->points[i], w->points[0], v1);
    VectorSubtract(w->points[i + 1], w->points[0], v2);
    CrossProduct(v1, v2, cross);
    add = VectorLength(cross);
    total += add * 0.5;
  }
  if (total < 16)
    eprintf("winding area " VEC_CONV1D "\n", total);
}

void PlaneFromWinding(register struct winding *w, register struct plane *plane)
{
  vec3D v1, v2;

  /* calc plane */
  VectorSubtract(w->points[2], w->points[1], v1);
  VectorSubtract(w->points[0], w->points[1], v2);
  CrossProduct(v2, v1, plane->normal);
  VectorNormalize(plane->normal);
  plane->dist = DotProduct(w->points[0], plane->normal);
}

/*
 * ==================
 * ClipWinding
 * 
 * Clips the winding to the plane, returning the new winding on the positive side
 * Frees the input winding.
 * If keepon is TRUE, an exactly on-plane winding will be saved, otherwise
 * it will be clipped away.
 * ==================
 */
struct winding *ClipWinding(register struct winding *in, register struct plane *split, register bool keepon)
{
  vec1D dists[MAX_POINTS_ON_WINDING];
  int sides[MAX_POINTS_ON_WINDING];
  int counts[3];
  vec1D dot;
  int i, j;
  vec1D *p1, *p2;
  vec3D mid;
  struct winding *neww;
  int maxpts;

  counts[0] = counts[1] = counts[2] = 0;

  /* determine sides for each point */
  for (i = 0; i < in->numpoints; i++) {
    dot = DotProduct(in->points[i], split->normal);
    dot -= split->dist;
    dists[i] = dot;
    if (dot > ON_EPSILON)
      sides[i] = SIDE_FRONT;
    else if (dot < -ON_EPSILON)
      sides[i] = SIDE_BACK;
    else {
      sides[i] = SIDE_ON;
    }
    counts[sides[i]]++;
  }
  sides[i] = sides[0];
  dists[i] = dists[0];

/*
 * printf("counts[0]: %d\n", counts[0]);
 * printf("counts[1]: %d\n", counts[1]);
 */

  if (keepon && !counts[0] && !counts[1])
    return in;

  if (!counts[0]) {
    FreeWinding(in);
    return NULL;
  }
  if (!counts[1])
    return in;

  maxpts = in->numpoints + 4;					/* can't use counts[0]+2 because */
  /* of fp grouping errors */

  neww = NewWinding(maxpts);

  for (i = 0; i < in->numpoints; i++) {
    p1 = in->points[i];

    if (sides[i] == SIDE_ON) {
      VectorCopy(p1, neww->points[neww->numpoints]);
      neww->numpoints++;
      continue;
    }

    if (sides[i] == SIDE_FRONT) {
      VectorCopy(p1, neww->points[neww->numpoints]);
      neww->numpoints++;
    }

    if (sides[i + 1] == SIDE_ON || sides[i + 1] == sides[i])
      continue;

    /* generate a split point */
    p2 = in->points[(i + 1) % in->numpoints];

    dot = dists[i] / (dists[i] - dists[i + 1]);
    for (j = 0; j < 3; j++) {					/* avoid round off error when possible */

      if (split->normal[j] == 1)
	mid[j] = split->dist;
      else if (split->normal[j] == -1)
	mid[j] = -split->dist;
      else
	mid[j] = p1[j] + dot * (p2[j] - p1[j]);
    }

    VectorCopy(mid, neww->points[neww->numpoints]);
    neww->numpoints++;
  }

  if (neww->numpoints > maxpts)
    Error("ClipWinding: points exceeded estimate");

  /* free the original winding */
  FreeWinding(in);

  return neww;
}

void ClipWindingEpsilon(struct winding *in, vec3D normal, vec1D dist,
		 vec1D epsilon, struct winding **front, struct winding **back)
{
  vec1D dists[MAX_POINTS_ON_WINDING + 4];
  int sides[MAX_POINTS_ON_WINDING + 4];
  int counts[3];
  vec1D dot;
  int i, j;
  vec1D *p1, *p2;
  vec3D mid;
  struct winding *f, *b;
  int maxpts;

  counts[0] = counts[1] = counts[2] = 0;

  /* determine sides for each point */
  for (i = 0; i < in->numpoints; i++) {
    dot = DotProduct(in->points[i], normal);
    dot -= dist;
    dists[i] = dot;
    if (dot > epsilon)
      sides[i] = SIDE_FRONT;
    else if (dot < -epsilon)
      sides[i] = SIDE_BACK;
    else {
      sides[i] = SIDE_ON;
    }
    counts[sides[i]]++;
  }
  sides[i] = sides[0];
  dists[i] = dists[0];

  *front = *back = NULL;

  if (!counts[0]) {
    *back = CopyWinding(in);
    return;
  }
  if (!counts[1]) {
    *front = CopyWinding(in);
    return;
  }

  maxpts = in->numpoints + 4;					/* cant use counts[0]+2 because */
  /* of fp grouping errors */

  *front = f = NewWinding(maxpts);
  *back = b = NewWinding(maxpts);

  for (i = 0; i < in->numpoints; i++) {
    p1 = in->points[i];

    if (sides[i] == SIDE_ON) {
      VectorCopy(p1, f->points[f->numpoints]);
      f->numpoints++;
      VectorCopy(p1, b->points[b->numpoints]);
      b->numpoints++;
      continue;
    }

    if (sides[i] == SIDE_FRONT) {
      VectorCopy(p1, f->points[f->numpoints]);
      f->numpoints++;
    }
    if (sides[i] == SIDE_BACK) {
      VectorCopy(p1, b->points[b->numpoints]);
      b->numpoints++;
    }

    if (sides[i + 1] == SIDE_ON || sides[i + 1] == sides[i])
      continue;

    /* generate a split point */
    p2 = in->points[(i + 1) % in->numpoints];

    dot = dists[i] / (dists[i] - dists[i + 1]);
    for (j = 0; j < 3; j++) {					/* avoid round off error when possible */

      if (normal[j] == 1)
	mid[j] = dist;
      else if (normal[j] == -1)
	mid[j] = -dist;
      else
	mid[j] = p1[j] + dot * (p2[j] - p1[j]);
    }

    VectorCopy(mid, f->points[f->numpoints]);
    f->numpoints++;
    VectorCopy(mid, b->points[b->numpoints]);
    b->numpoints++;
  }

  if (f->numpoints > maxpts || b->numpoints > maxpts)
    Error("ClipWinding: points exceeded estimate");
  if (f->numpoints > MAX_POINTS_ON_WINDING || b->numpoints > MAX_POINTS_ON_WINDING)
    Error("ClipWinding: MAX_POINTS_ON_WINDING");
}
/*
 * ==================
 * DivideWinding
 * 
 * Divides a winding by a plane, producing one or two windings.  The
 * original winding is not damaged or freed.  If only on one side, the
 * returned winding will be the input winding.  If on both sides, two
 * new windings will be created.
 * ==================
 */
void DivideWinding(struct winding *in, struct plane *split, struct winding **front, struct winding **back)
{
  vec1D dists[MAX_POINTS_ON_WINDING];
  int sides[MAX_POINTS_ON_WINDING];
  int counts[3];
  vec1D dot;
  int i, j;
  vec1D *p1, *p2;
  vec3D mid;
  struct winding *f, *b;
  int maxpts;

  counts[0] = counts[1] = counts[2] = 0;

  /* determine sides for each point */
  for (i = 0; i < in->numpoints; i++) {
    dot = DotProduct(in->points[i], split->normal);
    dot -= split->dist;
    dists[i] = dot;
    if (dot > ON_EPSILON)
      sides[i] = SIDE_FRONT;
    else if (dot < -ON_EPSILON)
      sides[i] = SIDE_BACK;
    else {
      sides[i] = SIDE_ON;
    }
    counts[sides[i]]++;
  }
  sides[i] = sides[0];
  dists[i] = dists[0];

  *front = *back = NULL;

  if (!counts[0]) {
    *back = in;
    return;
  }
  if (!counts[1]) {
    *front = in;
    return;
  }

  maxpts = in->numpoints + 4;					/* can't use counts[0]+2 because */
  /* of fp grouping errors */

  *front = f = NewWinding(maxpts);
  *back = b = NewWinding(maxpts);

  for (i = 0; i < in->numpoints; i++) {
    p1 = in->points[i];

    if (sides[i] == SIDE_ON) {
      VectorCopy(p1, f->points[f->numpoints]);
      f->numpoints++;
      VectorCopy(p1, b->points[b->numpoints]);
      b->numpoints++;
      continue;
    }

    if (sides[i] == SIDE_FRONT) {
      VectorCopy(p1, f->points[f->numpoints]);
      f->numpoints++;
    }
    if (sides[i] == SIDE_BACK) {
      VectorCopy(p1, b->points[b->numpoints]);
      b->numpoints++;
    }

    if (sides[i + 1] == SIDE_ON || sides[i + 1] == sides[i])
      continue;

    /* generate a split point */
    p2 = in->points[(i + 1) % in->numpoints];

    dot = dists[i] / (dists[i] - dists[i + 1]);
    for (j = 0; j < 3; j++) {					/* avoid round off error when possible */

      if (split->normal[j] == 1)
	mid[j] = split->dist;
      else if (split->normal[j] == -1)
	mid[j] = -split->dist;
      else
	mid[j] = p1[j] + dot * (p2[j] - p1[j]);
    }

    VectorCopy(mid, f->points[f->numpoints]);
    f->numpoints++;
    VectorCopy(mid, b->points[b->numpoints]);
    b->numpoints++;
  }

  if (f->numpoints > maxpts || b->numpoints > maxpts)
    Error("ClipWinding: points exceeded estimate");
}

/*
 * ==================
 * NewWinding
 * ==================
 */
struct winding *NewWinding(register int points)
{
  struct winding *w;
  int size;

  if (points > MAX_POINTS_ON_WINDING)
    Error("NewWinding: %i points", points);

  c_activewindings++;
  if (c_activewindings > c_peakwindings)
    c_peakwindings = c_activewindings;

  /*size = (int)((struct winding *)0)->points[points];          hell, bloody shit! */
  size = (points * sizeof(vec3D)) + sizeof(bool) + sizeof(int);

  if (!(w = (struct winding *)tmalloc(size)))
    Error(failed_memoryunsize, "winding");
  bzero(w, size);

  return w;
}

void FreeWinding(register struct winding *w)
{
  c_activewindings--;
  if (!w->original)
    tfree(w);
}
