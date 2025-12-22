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

staticvar bool mergedebug;						/* ? */

/*
 * ================
 * CheckColinear
 * 
 * ================
 */
staticfnc void CheckColinear(register struct visfacet *f)
{
  int i, j;
  vec3D v1, v2;

  for (i = 0; i < f->numpoints; i++) {
    /*
     * skip the point if the vector from the previous point is the same
     * as the vector to the next point
     */
    j = (i - 1 < 0) ? f->numpoints - 1 : i - 1;
    VectorSubtract(f->pts[i], f->pts[j], v1);
    VectorNormalize(v1);

    j = (i + 1 == f->numpoints) ? 0 : i + 1;
    VectorSubtract(f->pts[j], f->pts[i], v2);
    VectorNormalize(v2);

    if (VectorCompare(v1, v2))
      Error("Colinear edge");
  }

}

/*
 * =============
 * TryMerge
 * 
 * If two polygons share a common edge and the edges that meet at the
 * common points are both inside the other polygons, merge them
 * 
 * Returns NULL if the faces couldn't be merged, or the new face.
 * The originals will NOT be freed.
 * =============
 */
staticfnc struct visfacet *TryMerge(mapBase mapMem, register struct visfacet *f1, register struct visfacet *f2)
{
  vec1D *p1, *p2, *p3, *p4, *back;
  struct visfacet *newf;
  int i, j, k, l;
  vec3D normal, delta, planenormal;
  vec1D dot;
  struct plane *plane;
  bool keep1, keep2;

  if (f1->numpoints == -1 || f2->numpoints == -1)
    return NULL;
  if (f1->planeside != f2->planeside)
    return NULL;
  if (f1->texturenum != f2->texturenum)
    return NULL;
  if (f1->contents[0] != f2->contents[0])
    return NULL;
  if (f1->contents[1] != f2->contents[1])
    return NULL;

  /* find a common edge */
  p1 = p2 = NULL;						/* stop compiler warning */
  j = 0;

  for (i = 0; i < f1->numpoints; i++) {
    p1 = f1->pts[i];
    p2 = f1->pts[(i + 1) % f1->numpoints];
    for (j = 0; j < f2->numpoints; j++) {
      p3 = f2->pts[j];
      p4 = f2->pts[(j + 1) % f2->numpoints];
      for (k = 0; k < 3; k++) {
	if (fabs(p1[k] - p4[k]) > EQUAL_EPSILON)
	  break;
	if (fabs(p2[k] - p3[k]) > EQUAL_EPSILON)
	  break;
      }
      if (k == 3)
	break;
    }
    if (j < f2->numpoints)
      break;
  }

  if (i == f1->numpoints)
    return NULL;						/* no matching edges */

  /*
   * check slope of connected lines
   * if the slopes are colinear, the point can be removed
   */
#ifdef EXHAUSIVE_CHECK
  if (f1->planenum >= mapMem->numbrushplanes || f1->planenum < 0)
    Error("looking for nonexisting plane %d\n", f1->planenum);
#endif
  plane = &mapMem->brushplanes[f1->planenum];
  VectorCopy(plane->normal, planenormal);
  if (f1->planeside)
    VectorNegate(planenormal);

  back = f1->pts[(i + f1->numpoints - 1) % f1->numpoints];
  VectorSubtract(p1, back, delta);
  CrossProduct(planenormal, delta, normal);
  VectorNormalize(normal);

  back = f2->pts[(j + 2) % f2->numpoints];
  VectorSubtract(back, p1, delta);
  dot = DotProduct(delta, normal);
  if (dot > CONTINUOUS_EPSILON)
    return NULL;						/* not a convex polygon */

  keep1 = dot < -CONTINUOUS_EPSILON;

  back = f1->pts[(i + 2) % f1->numpoints];
  VectorSubtract(back, p2, delta);
  CrossProduct(planenormal, delta, normal);
  VectorNormalize(normal);

  back = f2->pts[(j + f2->numpoints - 1) % f2->numpoints];
  VectorSubtract(back, p2, delta);
  dot = DotProduct(delta, normal);
  if (dot > CONTINUOUS_EPSILON)
    return NULL;						/* not a convex polygon */

  keep2 = dot < -CONTINUOUS_EPSILON;

  /* build the new polygon */
  if (f1->numpoints + f2->numpoints > MAXEDGES) {
/*              Error ("TryMerge: too many edges!"); */
    return NULL;
  }

  newf = NewFaceFromFace(f1, MAXEDGES);

  /* copy first polygon */
  for (k = (i + 1) % f1->numpoints; k != i; k = (k + 1) % f1->numpoints) {
    if (k == (i + 1) % f1->numpoints && !keep2)
      continue;

    VectorCopy(f1->pts[k], newf->pts[newf->numpoints]);
    newf->numpoints++;
  }

  /* copy second polygon */
  for (l = (j + 1) % f2->numpoints; l != j; l = (l + 1) % f2->numpoints) {
    if (l == (j + 1) % f2->numpoints && !keep1)
      continue;
    VectorCopy(f2->pts[l], newf->pts[newf->numpoints]);
    newf->numpoints++;
  }

  RecalcFace(newf);
  /* mprintf("TryMerge: merged %d + %d to %d\n", f1->numpoints, f2->numpoints, newf->numpoints); */

  return newf;
}

/*
 * ===============
 * MergeFaceToList
 * ===============
 */
struct visfacet *MergeFaceToList(mapBase mapMem, struct visfacet *face, struct visfacet *list)
{
  struct visfacet *newf, *f;

  for (f = list; f; f = f->next) {
    /* CheckColinear(f); */
    if (mergedebug) {
      Draw_ClearWindow();
      Draw_DrawFace(face);
      Draw_DrawFace(f);
      Draw_SetBlack();
    }
    newf = TryMerge(mapMem, face, f);
    if (!newf)
      continue;
    FreeFace(face);
    f->numpoints = -1;						/* merged out */

    return MergeFaceToList(mapMem, newf, list);
  }

  /* didn't merge, so add at start */
  face->next = list;
  return face;
}

/*
 * ===============
 * FreeMergeListScraps
 * ===============
 */
struct visfacet *FreeMergeListScraps(struct visfacet *merged)
{
  struct visfacet *head, *next;

  head = NULL;
  for (; merged; merged = next) {
    next = merged->next;
    if (merged->numpoints == -1)
      FreeFace(merged);
    else {
      merged->next = head;
      head = merged;
    }
  }

  return head;
}

/*
 * ===============
 * MergePlaneFaces
 * ===============
 */
void MergePlaneFaces(mapBase mapMem, struct surface *plane)
{
  struct visfacet *f1, *next;
  struct visfacet *merged;

  merged = NULL;

  for (f1 = plane->faces; f1; f1 = next) {
    next = f1->next;
    merged = MergeFaceToList(mapMem, f1, merged);
  }

  /* chain all of the non-empty faces to the plane */
  plane->faces = FreeMergeListScraps(merged);
}

/*
 * ============
 * MergeAll
 * ============
 */
void MergeAll(mapBase mapMem, struct surface *surfhead)
{
  struct surface *surf;
  int mergefaces, numsurf = 0, i;
  struct visfacet *f;

  mprintf("----- MergeAll ----------\n");

  /* PROGRESS-ONLY! */
  for (surf = surfhead; surf; surf = surf->next)
    numsurf++;

  mergefaces = 0;
  for (surf = surfhead, i = 0; surf; surf = surf->next, i++) {
    MergePlaneFaces(mapMem, surf);
    Draw_ClearWindow();
    for (f = surf->faces; f; f = f->next) {
      Draw_DrawFace(f);
      mergefaces++;
    }
    mprogress(numsurf, i + 1);
  }

  mprintf("%5i mergefaces\n", mergefaces);
}
