/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQBUILD_CORE
#include "../include/libqbuild.h"

staticvar int leaffaces;							/* 4 */
staticvar int nodefaces;							/* 4 */
staticvar int splitnodes;							/* 4 */

staticvar int c_solid, c_empty, c_water;					/* 12 */

staticvar bool usemidsplit;						/* ? */

/*============================================================================ */

/*
 * ==================
 * FaceSide
 * 
 * For BSP hueristic
 * ==================
 */
staticfnc int FaceSide(register struct visfacet *in, register struct plane *split)
{
  int frontcount, backcount;
  vec1D dot;
  int i;
  vec1D *p;

  frontcount = backcount = 0;

  if (split->type < 3)
    /* axial planes are fast */
    for (i = 0, p = in->pts[0] + split->type; i < in->numpoints; i++, p += 3) {
      if (*p > split->dist + ON_EPSILON) {
	if (backcount)
	  return SIDE_ON;
	frontcount = 1;
      }
      else if (*p < split->dist - ON_EPSILON) {
	if (frontcount)
	  return SIDE_ON;
	backcount = 1;
      }
    }
  else
    /* sloping planes take longer */
    for (i = 0, p = in->pts[0]; i < in->numpoints; i++, p += 3) {
      dot = DotProduct(p, split->normal);
      dot -= split->dist;
      if (dot > ON_EPSILON) {
	if (backcount)
	  return SIDE_ON;
	frontcount = 1;
      }
      else if (dot < -ON_EPSILON) {
	if (frontcount)
	  return SIDE_ON;
	backcount = 1;
      }
    }

  if (!frontcount)
    return SIDE_BACK;
  if (!backcount)
    return SIDE_FRONT;

  return SIDE_ON;
}

/*
 * ==================
 * ChooseMidPlaneFromList
 * 
 * The clipping hull BSP doesn't worry about avoiding splits
 * ==================
 */
staticfnc struct surface *ChooseMidPlaneFromList(mapBase mapMem, register struct surface *surfaces, register vec3D mins, register vec3D maxs)
{
  int j, l;
  struct surface *p, *bestsurface;
  vec1D bestvalue, value, dist;
  struct plane *plane;

  /* pick the plane that splits the least */
  bestvalue = 6 * 8192 * 8192;
  bestsurface = NULL;

  for (p = surfaces; p; p = p->next) {
    if (p->onnode)
      continue;

#ifdef EXHAUSIVE_CHECK
    if (p->planenum >= mapMem->numbrushplanes || p->planenum < 0)
      Error("looking for nonexisting plane %d\n", p->planenum);
#endif
    plane = &mapMem->brushplanes[p->planenum];

    /* check for axis aligned surfaces */
    l = plane->type;
    if (l > PLANE_Z)
      continue;

    /* calculate the split metric along axis l, smaller values are better */
    value = 0;

    dist = plane->dist * plane->normal[l];
    for (j = 0; j < 3; j++) {
      if (j == l) {
	value += (maxs[l] - dist) * (maxs[l] - dist);
	value += (dist - mins[l]) * (dist - mins[l]);
      }
      else
	value += 2 * (maxs[j] - mins[j]) * (maxs[j] - mins[j]);
    }

    if (value > bestvalue)
      continue;

    /* currently the best! */
    bestvalue = value;
    bestsurface = p;
  }

  if (!bestsurface) {
    for (p = surfaces; p; p = p->next)
      if (!p->onnode)
	return p;						/* first valid surface */

    Error("ChooseMidPlaneFromList: no valid planes");
  }

  return bestsurface;
}

/*
 * ==================
 * ChoosePlaneFromList
 * 
 * The real BSP hueristic
 * ==================
 */
staticfnc struct surface *ChoosePlaneFromList(mapBase mapMem, register struct surface *surfaces, register vec3D mins, register vec3D maxs, register bool usefloors)
{
  int j, k, l;
  struct surface *p, *p2, *bestsurface;
  vec1D bestvalue, bestdistribution, value, dist;
  struct plane *plane;
  struct visfacet *f;

  /* pick the plane that splits the least */
  bestvalue = VEC_POSMAX;
  bestsurface = NULL;
  bestdistribution = VEC_POSMAX;

  for (p = surfaces; p; p = p->next) {
    if (p->onnode)
      continue;

#ifdef EXHAUSIVE_CHECK
    if (p->planenum >= mapMem->numbrushplanes || p->planenum < 0)
      Error("looking for nonexisting plane %d\n", p->planenum);
#endif
    plane = &mapMem->brushplanes[p->planenum];
    k = 0;

    if (!usefloors && plane->normal[2] == 1)
      continue;

    for (p2 = surfaces; p2; p2 = p2->next) {
      if (p2 == p)
	continue;
      if (p2->onnode)
	continue;

      for (f = p2->faces; f; f = f->next) {
	if (FaceSide(f, plane) == SIDE_ON) {
	  k++;
	  if (k >= bestvalue)
	    break;
	}

      }
      if (k > bestvalue)
	break;
    }

    if (k > bestvalue)
      continue;

    /* if equal numbers, axial planes win, then decide on spatial subdivision */
    if (k < bestvalue || (k == bestvalue && plane->type < PLANE_ANYX)) {
      /* check for axis aligned surfaces */
      l = plane->type;

      if (l <= PLANE_Z) {					/* axial aligned                                                 */
	/* calculate the split metric along axis l */
	value = 0;

	for (j = 0; j < 3; j++) {
	  if (j == l) {
	    dist = plane->dist * plane->normal[l];
	    value += (maxs[l] - dist) * (maxs[l] - dist);
	    value += (dist - mins[l]) * (dist - mins[l]);
	  }
	  else
	    value += 2 * (maxs[j] - mins[j]) * (maxs[j] - mins[j]);
	}

	if (value > bestdistribution && k == bestvalue)
	  continue;
	bestdistribution = value;
      }
      /* currently the best! */
      bestvalue = k;
      bestsurface = p;
    }
  }

  return bestsurface;
}

/*
 * ==================
 * SelectPartition
 * 
 * Selects a surface from a linked list of surfaces to split the group on
 * returns NULL if the surface list can not be divided any more (a leaf)
 * ==================
 */
staticfnc struct surface *SelectPartition(mapBase mapMem, register struct surface *surfaces)
{
  int i;
  short int j;
  vec3D mins, maxs;
  struct surface *p, *bestsurface;

  /* count onnode surfaces */
  i = 0;
  bestsurface = NULL;
  for (p = surfaces; p; p = p->next)
    if (!p->onnode) {
      i++;
      bestsurface = p;
    }

  if (i == 0)
    return NULL;

  if (i == 1)
    return bestsurface;						/* this is a final split */

  /* calculate a bounding box of the entire surfaceset */
  mins[0] = mins[1] = mins[2] = VEC_POSMAX;
  maxs[0] = maxs[1] = maxs[2] = VEC_NEGMAX;

  for (p = surfaces; p; p = p->next)
    for (j = 0; j < 3; j++) {
      if (p->mins[j] < mins[j])
	mins[j] = p->mins[j];
      if (p->maxs[j] > maxs[j])
	maxs[j] = p->maxs[j];
    }

  if (usemidsplit)						/* do fast way for clipping hull */
    return ChooseMidPlaneFromList(mapMem, surfaces, mins, maxs);

  /* do slow way to save poly splits for drawing hull */
#if 0
  bestsurface = ChoosePlaneFromList(surfaces, mins, maxs, FALSE);
  if (bestsurface)
    return bestsurface;
#endif
  return ChoosePlaneFromList(mapMem, surfaces, mins, maxs, TRUE);
}

/*============================================================================ */

/*
 * =================
 * CalcSurfaceInfo
 * 
 * Calculates the bounding box
 * =================
 */
void CalcSurfaceInfo(register struct surface *surf)
{
  int i;
  short int j;
  struct visfacet *f;

  if (!surf->faces)
    Error("CalcSurfaceInfo: surface without a face");

  /* calculate a bounding box */
  surf->mins[0] = surf->mins[1] = surf->mins[2] = VEC_POSMAX;
  surf->maxs[0] = surf->maxs[1] = surf->maxs[2] = VEC_NEGMAX;

  for (f = surf->faces; f; f = f->next) {
    if (f->contents[0] >= 0 || f->contents[1] >= 0)
      Error("Bad contents");
    for (i = 0; i < f->numpoints; i++)
      for (j = 0; j < 3; j++) {
	if (f->pts[i][j] < surf->mins[j])
	  surf->mins[j] = f->pts[i][j];
	if (f->pts[i][j] > surf->maxs[j])
	  surf->maxs[j] = f->pts[i][j];
      }
  }
}

/*
 * ==================
 * DividePlane
 * ==================
 */
staticfnc void DividePlane(mapBase mapMem, register struct surface *in, register struct plane *split, register struct surface **front, register struct surface **back)
{
  struct visfacet *facet, *next;
  struct visfacet *frontlist, *backlist;
  struct visfacet *frontfrag, *backfrag;
  struct surface *news;
  struct plane *inplane;

#ifdef EXHAUSIVE_CHECK
  if (inplane->planenum >= mapMem->numbrushplanes || inplane->planenum < 0)
    Error("looking for nonexisting plane %d\n", inplane->planenum);
#endif
  inplane = &mapMem->brushplanes[in->planenum];

  /* parallel case is easy */
  if (VectorCompare(inplane->normal, split->normal)) {
    /* check for exactly on node */
    if (inplane->dist == split->dist) {				/* divide the facets to the front and back sides */

      news = AllocSurface();
      *news = *in;

      facet = in->faces;
      in->faces = NULL;
      news->faces = NULL;
      in->onnode = news->onnode = TRUE;

      for (; facet; facet = next) {
	next = facet->next;
	if (facet->planeside == 1) {
	  facet->next = news->faces;
	  news->faces = facet;
	}
	else {
	  facet->next = in->faces;
	  in->faces = facet;
	}
      }

      if (in->faces)
	*front = in;
      else
	*front = NULL;
      if (news->faces)
	*back = news;
      else
	*back = NULL;
      return;
    }

    if (inplane->dist > split->dist) {
      *front = in;
      *back = NULL;
    }
    else {
      *front = NULL;
      *back = in;
    }
    return;
  }

  /*
   * do a real split.  may still end up entirely on one side
   * OPTIMIZE: use bounding box for fast test
   */
  frontlist = NULL;
  backlist = NULL;

  for (facet = in->faces; facet; facet = next) {
    next = facet->next;
    SplitFace(facet, split, &frontfrag, &backfrag);
    if (frontfrag) {
      frontfrag->next = frontlist;
      frontlist = frontfrag;
    }
    if (backfrag) {
      backfrag->next = backlist;
      backlist = backfrag;
    }
  }

  /* if nothing actually got split, just move the in plane */
  if (frontlist == NULL) {
    *front = NULL;
    *back = in;
    in->faces = backlist;
    return;
  }

  if (backlist == NULL) {
    *front = in;
    *back = NULL;
    in->faces = frontlist;
    return;
  }

  /* stuff got split, so allocate one new plane and reuse in */
  news = AllocSurface();
  *news = *in;
  news->faces = backlist;
  *back = news;

  in->faces = frontlist;
  *front = in;

  /* recalc bboxes and flags */
  CalcSurfaceInfo(news);
  CalcSurfaceInfo(in);
}

/*
 * ==================
 * DivideNodeBounds
 * ==================
 */
staticfnc void DivideNodeBounds(register struct node *node, register struct plane *split)
{
  VectorCopy(node->mins, node->children[0]->mins);
  VectorCopy(node->mins, node->children[1]->mins);
  VectorCopy(node->maxs, node->children[0]->maxs);
  VectorCopy(node->maxs, node->children[1]->maxs);

  /* OPTIMIZE: sloping cuts can give a better bbox than this... */
  if (split->type > 2)
    return;

  node->children[0]->mins[split->type] =
    node->children[1]->maxs[split->type] = split->dist;
}

/*
 * ==================
 * LinkConvexFaces
 * 
 * Determines the contents of the leaf and creates the final list of
 * original faces that have some fragment inside this leaf
 * ==================
 */
staticfnc void LinkConvexFaces(register struct surface *planelist, register struct node *leafnode)
{
  struct visfacet *f, *next;
  struct surface *surf, *pnext;
  int i, count;

  leafnode->faces = NULL;
  leafnode->contents = 0;
  leafnode->planenum = -1;

  count = 0;
  for (surf = planelist; surf; surf = surf->next) {
    for (f = surf->faces; f; f = f->next) {
      count++;
      if (!leafnode->contents)
	leafnode->contents = f->contents[0];
      else if (leafnode->contents != f->contents[0])
	Error("Mixed face contents in leafnode");
    }
  }

  if (!leafnode->contents)
    leafnode->contents = CONTENTS_SOLID;

  switch (leafnode->contents) {
    case CONTENTS_EMPTY:
      c_empty++;
      break;
    case CONTENTS_SOLID:
      c_solid++;
      break;
    case CONTENTS_WATER:
    case CONTENTS_SLIME:
    case CONTENTS_LAVA:
    case CONTENTS_SKY:
      c_water++;
      break;
    default:
      Error("LinkConvexFaces: bad contents number");
  }

  /* write the list of faces, and free the originals */
  leaffaces += count;
  if (!(leafnode->markfaces = (struct visfacet **)tmalloc(sizeof(struct visfacet *) * (count + 1))))
      Error(failed_memoryunsize, "markfaces");

  i = 0;
  for (surf = planelist; surf; surf = pnext) {
    pnext = surf->next;
    for (f = surf->faces; f; f = next) {
      next = f->next;
      leafnode->markfaces[i] = f->original;
      i++;
      FreeFace(f);
    }
    FreeSurface(surf);
  }
  leafnode->markfaces[i] = NULL;				/* sentinal */

}

/*
 * ==================
 * LinkNodeFaces
 * 
 * Returns a duplicated list of all faces on surface
 * ==================
 */
staticfnc struct visfacet *LinkNodeFaces(bspBase bspMem, register struct surface *surface)
{
  struct visfacet *f, *new, **prevptr;
  struct visfacet *list;

  list = NULL;

  /* subdivide */
  prevptr = &surface->faces;
  while (1) {
    f = *prevptr;
    if (!f)
      break;
    SubdivideFace(bspMem, f, prevptr);
    f = *prevptr;
    prevptr = &f->next;
  }

  /* copy */
  for (f = surface->faces; f; f = f->next) {
    nodefaces++;
    new = AllocFace(f->numpoints);
    CopyFace(new, f);
    f->original = new;
    new->next = list;
    list = new;
  }

  return list;
}

/*
 * ==================
 * PartitionSurfaces
 * ==================
 */
staticfnc void PartitionSurfaces(bspBase bspMem, mapBase mapMem, register struct surface *surfaces, register struct node *node)
{
  struct surface *split, *p, *next;
  struct surface *frontlist, *backlist;
  struct surface *frontfrag, *backfrag;
  struct plane *splitplane;

  split = SelectPartition(mapMem, surfaces);
  if (!split) {							/* this is a leaf node */

    node->planenum = PLANENUM_LEAF;
    LinkConvexFaces(surfaces, node);
    return;
  }

  splitnodes++;
  node->faces = LinkNodeFaces(bspMem, split);
  node->children[0] = AllocNode();
  node->children[1] = AllocNode();
  node->planenum = split->planenum;

#ifdef EXHAUSIVE_CHECK
  if (split->planenum >= mapMem->numbrushplanes || split->planenum < 0)
    Error("looking for nonexisting plane %d\n", split->planenum);
#endif
  splitplane = &mapMem->brushplanes[split->planenum];

  DivideNodeBounds(node, splitplane);

  /* multiple surfaces, so split all the polysurfaces into front and back lists */
  frontlist = NULL;
  backlist = NULL;

  for (p = surfaces; p; p = next) {
    next = p->next;
    DividePlane(mapMem, p, splitplane, &frontfrag, &backfrag);
    if (frontfrag && backfrag) {
      /*
       * the plane was split, which may expose oportunities to merge
       * adjacent faces into a single face
       *                      MergePlaneFaces (frontfrag);
       *                      MergePlaneFaces (backfrag);
       */
    }

    if (frontfrag) {
      if (!frontfrag->faces)
	Error("surface with no faces");
      frontfrag->next = frontlist;
      frontlist = frontfrag;
    }
    if (backfrag) {
      if (!backfrag->faces)
	Error("surface with no faces");
      backfrag->next = backlist;
      backlist = backfrag;
    }
  }

  PartitionSurfaces(bspMem, mapMem, frontlist, node->children[0]);
  PartitionSurfaces(bspMem, mapMem, backlist, node->children[1]);
}

/*
 * ==================
 * DrawSurface
 * ==================
 */
staticfnc void DrawSurface(register struct surface *surf)
{
  struct visfacet *f;

  for (f = surf->faces; f; f = f->next)
    Draw_DrawFace(f);
}

/*
 * ==================
 * DrawSurfaceList
 * ==================
 */
staticfnc void DrawSurfaceList(register struct surface *surf)
{
  Draw_ClearWindow();
  while (surf) {
    DrawSurface(surf);
    surf = surf->next;
  }
}

/*
 * ==================
 * SolidBSP
 * ==================
 */
struct node *SolidBSP(bspBase bspMem, mapBase mapMem, struct surface *surfhead, bool midsplit)
{
  short int i;
  struct node *headnode;

  mprintf("----- SolidBSP ----------\n");

  headnode = AllocNode();
  usemidsplit = midsplit;

  /* calculate a bounding box for the entire model */
  for (i = 0; i < 3; i++) {
    headnode->mins[i] = brushset->mins[i] - SIDESPACE;
    headnode->maxs[i] = brushset->maxs[i] + SIDESPACE;
  }

  /* recursively partition everything */
  Draw_ClearWindow();
  splitnodes = 0;
  leaffaces = 0;
  nodefaces = 0;
  c_solid = c_empty = c_water = 0;

  PartitionSurfaces(bspMem, mapMem, surfhead, headnode);

  mprintf("%5i split nodes\n", splitnodes);
  mprintf("%5i solid leafs\n", c_solid);
  mprintf("%5i empty leafs\n", c_empty);
  mprintf("%5i water leafs\n", c_water);
  mprintf("%5i leaffaces\n", leaffaces);
  mprintf("%5i nodefaces\n", nodefaces);

  return headnode;
}
