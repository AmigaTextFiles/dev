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

/*
 * 
 * NOTES
 * -----
 * Brushes that touch still need to be split at the cut point to make a tjunction
 * 
 */

struct visfacet **validfaces;

staticvar struct visfacet *inside, *outside;				/* 8 */
staticvar int brushfaces;							/* 4 */
staticvar int csgfaces;							/* 4 */
staticvar int csgmergefaces;						/* 4 */

staticfnc void DrawList(register struct visfacet *list)
{
  for (; list; list = list->next)
    Draw_DrawFace(list);
}

/*
 * ==================
 * NewFaceFromFace
 * 
 * Duplicates the non point information of a face, used by SplitFace and
 * MergeFace.
 * ==================
 */
struct visfacet *NewFaceFromFace(register struct visfacet *in, register int points)
{
  struct visfacet *newf;

  newf = AllocFace(points);

  newf->planenum = in->planenum;
  newf->texturenum = in->texturenum;
  newf->planeside = in->planeside;
  newf->original = in->original;
  newf->contents[0] = in->contents[0];
  newf->contents[1] = in->contents[1];

  return newf;
}

/*
 * ==================
 * SplitFace
 * 
 * ==================
 */
void SplitFace(struct visfacet *in, struct plane *split, struct visfacet **front, struct visfacet **back)
{
  vec1D *dists = (vec1D *) tmalloc(MAXEDGES * sizeof(vec1D));
  int *sides = (int *)tmalloc(MAXEDGES * sizeof(int));
  int counts[3];
  vec1D dot;
  int i, j;
  struct visfacet *newf, *new2;
  vec1D *p1, *p2;
  vec3D mid;

  if (in->numpoints < 0)
    Error("SplitFace: freed face");
  counts[0] = counts[1] = counts[2] = 0;

  /* determine sides for each point */
  for (i = 0; i < in->numpoints; i++) {
    dot = DotProduct(in->pts[i], split->normal);
    dot -= split->dist;
    dists[i] = dot;
    if (dot > ON_EPSILON)
      sides[i] = SIDE_FRONT;
    else if (dot < -ON_EPSILON)
      sides[i] = SIDE_BACK;
    else
      sides[i] = SIDE_ON;
    counts[sides[i]]++;
  }
  sides[i] = sides[0];
  dists[i] = dists[0];

  if (!counts[0]) {
    *front = NULL;
    *back = in;
    tfree(dists);
    tfree(sides);
    return;
  }
  if (!counts[1]) {
    *front = in;
    *back = NULL;
    tfree(dists);
    tfree(sides);
    return;
  }

  *back = newf = NewFaceFromFace(in, MAXEDGES);
  *front = new2 = NewFaceFromFace(in, MAXEDGES);

  /* distribute the points and generate splits */
  for (i = 0; i < in->numpoints; i++) {
    if (newf->numpoints > MAXEDGES || new2->numpoints > MAXEDGES)
      Error("SplitFace: numpoints > MAXEDGES");

    p1 = in->pts[i];

    if (sides[i] == SIDE_ON) {
      VectorCopy(p1, newf->pts[newf->numpoints]);
      newf->numpoints++;
      VectorCopy(p1, new2->pts[new2->numpoints]);
      new2->numpoints++;
      continue;
    }

    if (sides[i] == SIDE_FRONT) {
      VectorCopy(p1, new2->pts[new2->numpoints]);
      new2->numpoints++;
    }
    else {
      VectorCopy(p1, newf->pts[newf->numpoints]);
      newf->numpoints++;
    }

    if (sides[i + 1] == SIDE_ON || sides[i + 1] == sides[i])
      continue;

    /* generate a split point */
    p2 = in->pts[(i + 1) % in->numpoints];

    dot = dists[i] / (dists[i] - dists[i + 1]);
    for (j = 0; j < 3; j++) {					/* avoid round off error when possible */
      if (split->normal[j] == 1)
	mid[j] = split->dist;
      else if (split->normal[j] == -1)
	mid[j] = -split->dist;
      else
	mid[j] = p1[j] + dot * (p2[j] - p1[j]);
    }

    VectorCopy(mid, newf->pts[newf->numpoints]);
    newf->numpoints++;
    VectorCopy(mid, new2->pts[new2->numpoints]);
    new2->numpoints++;
  }

  if (newf->numpoints > MAXEDGES || new2->numpoints > MAXEDGES)
    Error("SplitFace: numpoints > MAXEDGES");

  RecalcFace(newf);
  RecalcFace(new2);
#ifdef EXHAUSIVE_CHECK
  if ((newf->numpoints > in->numpoints) || (new2->numpoints > in->numpoints))
    Error("SplitFace: heavy split (%d to %d + %d)\n", in->numpoints, newf->numpoints, new2->numpoints);
#endif

#if 0
  CheckFace(newf);
  CheckFace(new2);
#endif

  /* free the original face now that is is represented by the fragments */
  FreeFace(in);
  tfree(dists);
  tfree(sides);
}

/*
 * =================
 * ClipInside
 * 
 * Clips all of the faces in the inside list, possibly moving them to the
 * outside list or spliting it into a piece in each list.
 * 
 * Faces exactly on the plane will stay inside unless overdrawn by later brush
 * 
 * frontside is the side of the plane that holds the outside list
 * =================
 */
staticfnc void ClipInside(mapBase mapMem, register int splitplane, register int frontside, register bool precedence)
{
  struct visfacet *f, *next;
  struct visfacet *frags[2];
  struct visfacet *insidelist;
  struct plane *split;

#ifdef EXHAUSIVE_CHECK
  if (splitplane >= mapMem->numbrushplanes || splitplane < 0)
    Error("looking for nonexisting plane %d\n", splitplane);
#endif
  split = &mapMem->brushplanes[splitplane];

  insidelist = NULL;
  for (f = inside; f; f = next) {
    next = f->next;

    if (f->planenum == splitplane) {				/* exactly on, handle special */
      if (frontside != f->planeside || precedence) {		/* allways clip off opposite faceing */
	frags[frontside] = NULL;
	frags[!frontside] = f;
      }
      else {							/* leave it on the outside */
	frags[frontside] = f;
	frags[!frontside] = NULL;
      }
    }
    else {							/* proper split */
      SplitFace(f, split, &frags[0], &frags[1]);
    }

    if (frags[frontside]) {
      frags[frontside]->next = outside;
      outside = frags[frontside];
    }
    if (frags[!frontside]) {
      frags[!frontside]->next = insidelist;
      insidelist = frags[!frontside];
    }
  }

  inside = insidelist;
}

/*
 * ==================
 * SaveOutside
 * 
 * Saves all of the faces in the outside list to the bsp plane list
 * ==================
 */
staticfnc void SaveOutside(mapBase mapMem, register bool mirror)
{
  struct visfacet *f, *next, *newf;
  int i;
  int planenum;

  for (f = outside; f; f = next) {
    next = f->next;
    csgfaces++;
    Draw_DrawFace(f);
    planenum = f->planenum;

    if (mirror) {
      newf = NewFaceFromFace(f, f->numpoints);

      newf->numpoints = f->numpoints;
      newf->planeside = f->planeside ^ 1;			/* reverse side */

      newf->contents[0] = f->contents[1];
      newf->contents[1] = f->contents[0];

      for (i = 0; i < f->numpoints; i++)			/* add points backwards */
	VectorCopy(f->pts[f->numpoints - 1 - i], newf->pts[i]);
    }
    else
      newf = NULL;

    validfaces[planenum] = MergeFaceToList(mapMem, f, validfaces[planenum]);
    if (newf)
      validfaces[planenum] = MergeFaceToList(mapMem, newf, validfaces[planenum]);

    validfaces[planenum] = FreeMergeListScraps(validfaces[planenum]);
  }
}

/*
 * ==================
 * FreeInside
 * 
 * Free all the faces that got clipped out
 * ==================
 */
staticfnc void FreeInside(register int contents)
{
  struct visfacet *f, *next;

  for (f = inside; f; f = next) {
    next = f->next;

    if (contents != CONTENTS_SOLID) {
      f->contents[0] = contents;
      f->next = outside;
      outside = f;
    }
    else
      FreeFace(f);
  }
}

/*========================================================================== */

/*
 * ==================
 * BuildSurfaces
 * 
 * Returns a chain of all the external surfaces with one or more visible
 * faces.
 * ==================
 */
struct surface *BuildSurfaces(mapBase mapMem)
{
  struct visfacet **f;
  struct visfacet *count;
  int i;
  struct surface *s;
  struct surface *surfhead;

  surfhead = NULL;

  f = validfaces;
  for (i = 0; i < mapMem->numbrushplanes; i++, f++) {
    if (*f) {							/* !nothing left on this plane */
      /* create a new surface to hold the faces on this plane */
      s = AllocSurface();
      s->planenum = i;
      s->next = surfhead;
      surfhead = s;
      s->faces = *f;
      for (count = s->faces; count; count = count->next)
	csgmergefaces++;
      CalcSurfaceInfo(s);					/* bounding box and flags */
    }
/** mprogress(mapMem->numbrushplanes, i + 1); **/
  }

  return surfhead;
}

/*========================================================================== */

/*
 * ==================
 * CopyFacesToOutside
 * ==================
 */
staticfnc void CopyFacesToOutside(register struct brush *b)
{
  struct visfacet *f, *newf;

  outside = NULL;

  for (f = b->faces; f; f = f->next) {
    brushfaces++;
#if 0
    {
      int i;

      for (i = 0; i < f->numpoints; i++)
	mprintf("( " VEC_CONV3D ") ", f->pts[i][0], f->pts[i][1], f->pts[i][2]);
      mprintf("\n");
    }
#endif
    newf = AllocFace(f->numpoints);
    CopyFace(newf, f);
    newf->next = outside;
    newf->contents[0] = CONTENTS_EMPTY;
    newf->contents[1] = b->contents;
    outside = newf;
  }
}

/*
 * ==================
 * CSGFaces
 * 
 * Returns a list of surfaces containing aall of the faces
 * ==================
 */
struct surface *CSGFaces(mapBase mapMem, struct brushset *bs)
{
  struct brush *b1, *b2;
  int i, j;
  bool overwrite;
  struct visfacet *f;
  struct surface *surfhead;

  mprintf("----- CSGFaces ----------\n");

  if (!(validfaces = (struct visfacet **)tmalloc(sizeof(struct visfacet *) * mapMem->numbrushplanes)))
      Error(failed_memoryunsize, "validfaces");

  csgfaces = brushfaces = csgmergefaces = 0;

  Draw_ClearWindow();

  /* do the solid faces */
  for (b1 = bs->brushes, j = 0; b1; b1 = b1->next) {
    mprogress(bs->numbrushes, ++j);

    /* set outside to a copy of the brush's faces */
    CopyFacesToOutside(b1);

    overwrite = FALSE;

    for (b2 = bs->brushes; b2; b2 = b2->next) {
      /* see if b2 needs to clip a chunk out of b1 */
      if (b1 == b2) {
	overwrite = TRUE;					/* later brushes now overwrite */
	continue;
      }

      /* check bounding box first */
      for (i = 0; i < 3; i++)
	if (b1->mins[i] > b2->maxs[i] || b1->maxs[i] < b2->mins[i])
	  break;
      if (i < 3)
	continue;

      /* divide faces by the planes of the new brush */
      inside = outside;
      outside = NULL;

      for (f = b2->faces; f; f = f->next)
	ClipInside(mapMem, f->planenum, f->planeside, overwrite);

      /* these faces are continued in another brush, so get rid of them */
      if (b1->contents == CONTENTS_SOLID && b2->contents <= CONTENTS_WATER)
	FreeInside(b2->contents);
      else
	FreeInside(CONTENTS_SOLID);
    }

    /* all of the faces left in outside are real surface faces */
    if (b1->contents != CONTENTS_SOLID)
      SaveOutside(mapMem, TRUE);				/* mirror faces for inside view */
    else
      SaveOutside(mapMem, FALSE);
  }

#if 0
  if (!csgfaces)
    Error("No faces");
#endif

  surfhead = BuildSurfaces(mapMem);

  mprintf("%5i brushfaces\n", brushfaces);
  mprintf("%5i csgfaces\n", csgfaces);
  mprintf("%5i mergedfaces\n", csgmergefaces);

  tfree(validfaces);
  return surfhead;
}
