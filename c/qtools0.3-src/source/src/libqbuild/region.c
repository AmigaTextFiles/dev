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

/*
 * 
 * input
 * -----
 * vertexes
 * edges
 * faces
 * 
 * output
 * ------
 * smaller set of vertexes
 * smaller set of edges
 * regions
 * ? triangulated regions
 * face to region mapping numbers
 * 
 */

typedef struct {
  int numedges;
  int edges[2];
} __packed checkpoint_t;					/* 12 */

staticvar int firstedge;							/* 4 */

staticvar vec3D region_mins, region_maxs;				/* 24 */

#ifdef EDGEMAPPING
staticvar int edgemapping[MAX_MAP_EDGES];					/* 172032 */
#endif

staticvar checkpoint_t *checkpoints;

staticfnc void AddPointToRegion(register vec3D p)
{
  short int i;

  for (i = 0; i < 3; i++) {
    if (p[i] < region_mins[i])
      region_mins[i] = p[i];
    if (p[i] > region_maxs[i])
      region_maxs[i] = p[i];
  }
}

staticfnc void ClearRegionSize(void)
{
  region_mins[0] = region_mins[1] = region_mins[2] = 9999;
  region_maxs[0] = region_maxs[1] = region_maxs[2] = -9999;
}

staticfnc void AddFaceToRegionSize(register struct visfacet *f)
{
  int i;

  for (i = 0; i < f->numpoints; i++)
    AddPointToRegion(f->pts[i]);
}

/*
 * ==============
 * CanJoinFaces
 * ==============
 */
staticfnc bool CanJoinFaces(bspBase bspMem, register struct visfacet *f, register struct visfacet *f2)
{
  vec3D oldmins, oldmaxs;
  short int i;

  if (f2->planenum != f->planenum
      || f2->planeside != f->planeside
      || f2->texturenum != f->texturenum)
    return FALSE;
  if (f2->outputnumber != -1)
    return FALSE;
  if (f2->contents[0] != f->contents[0]) {			/* does this ever happen? theyy shouldn't share. */

    eprintf("CanJoinFaces: edge with different contents");
    return FALSE;
  }

  /* check size constraints */
  if (!(bspMem->shared.quake1.texinfo[f->texturenum].flags & TEX_SPECIAL)) {
    VectorCopy(region_mins, oldmins);
    VectorCopy(region_maxs, oldmaxs);
    AddFaceToRegionSize(f2);
    for (i = 0; i < 3; i++) {
      if (region_maxs[i] - region_mins[i] > 240) {
	VectorCopy(oldmins, region_mins);
	VectorCopy(oldmaxs, region_maxs);
	return FALSE;
      }
    }
  }
  else {
    if (bspMem->shared.quake1.numsurfedges - firstedge + f2->numpoints > MAX_EDGES_IN_REGION)
      return FALSE;						/* a huge water or sky polygon */

  }

  /* check edge count constraints */
  return TRUE;
}

/*
 * ==============
 * RecursiveGrowRegion
 * ==============
 */
staticfnc void RecursiveGrowRegion(bspBase bspMem, register struct dface_t *r, register struct visfacet *f)
{
  int e;
  struct visfacet *f2;
  int i;

  if (f->outputnumber == bspMem->shared.quake1.numfaces)
    return;

  if (f->outputnumber != -1)
    Error("RecursiveGrowRegion: region collision");
  f->outputnumber = bspMem->shared.quake1.numfaces;

  /* add edges */
  for (i = 0; i < f->numpoints; i++) {
    e = f->edges[i];
    if (!bspMem->edgefaces[0][abs(e)])
      continue;							/* edge has allready been removed */

    if (e > 0)
      f2 = bspMem->edgefaces[1][e];
    else
      f2 = bspMem->edgefaces[0][-e];
    if (f2 && f2->outputnumber == bspMem->shared.quake1.numfaces) {
      bspMem->edgefaces[0][abs(e)] = NULL;
      bspMem->edgefaces[1][abs(e)] = NULL;
      continue;							/* allready merged */

    }
    if (f2 && CanJoinFaces(bspMem, f, f2)) {			/* remove the edge and merge the faces */
      bspMem->edgefaces[0][abs(e)] = NULL;
      bspMem->edgefaces[1][abs(e)] = NULL;
      RecursiveGrowRegion(bspMem, r, f2);
    }
    else {
      /* emit a surfedge */
      if (bspMem->shared.quake1.numsurfedges == bspMem->shared.quake1.max_numsurfedges)
	ExpandBSPClusters(bspMem, LUMP_SURFEDGES);
      bspMem->shared.quake1.dsurfedges[bspMem->shared.quake1.numsurfedges] = e;
      bspMem->shared.quake1.numsurfedges++;
    }
  }

}

#ifdef DEBUG
staticfnc void PrintDface(register int f)
{								/* for debugging */

  struct dface_t *df;
  struct dedge_t *e;
  int i, n;

  df = &bspMem->shared.quake1.dfaces[f];
  for (i = 0; i < df->numedges; i++) {
    n = bspMem->shared.quake1.dsurfedges[df->firstedge + i];
    e = &bspMem->shared.quake1.dedges[abs(n)];
    if (n < 0)
      mprintf("%5i  =  %5i : %5i\n", n, e->v[1], e->v[0]);
    else
      mprintf("%5i  =  %5i : %5i\n", n, e->v[0], e->v[1]);
  }
}

staticfnc void FindVertexUse(register int v)
{								/* for debugging */

  int i, j, n;
  struct dface_t *df;
  struct dedge_t *e;

  for (i = firstmodelface; i < bspMem->shared.quake1.numfaces; i++) {
    df = &bspMem->shared.quake1.dfaces[i];
    for (j = 0; j < df->numedges; j++) {
      n = bspMem->shared.quake1.dsurfedges[df->firstedge + j];
      e = &bspMem->shared.quake1.dedges[abs(n)];
      if (e->v[0] == v || e->v[1] == v) {
	mprintf("on face %i\n", i);
	break;
      }
    }
  }
}

staticfnc void FindEdgeUse(register int v)
{								/* for debugging */

  int i, j, n;
  struct dface_t *df;

  for (i = firstmodelface; i < bspMem->shared.quake1.numfaces; i++) {
    df = &bspMem->shared.quake1.dfaces[i];
    for (j = 0; j < df->numedges; j++) {
      n = bspMem->shared.quake1.dsurfedges[df->firstedge + j];
      if (n == v || -n == v) {
	mprintf("on face %i\n", i);
	break;
      }
    }
  }
}
#endif

/*
 * ================
 * HealEdges
 * 
 * Extends e1 so that it goes all the way to e2, and removes all references
 * to e2
 * ================
 */
staticfnc void HealEdges(register int e1, int register e2)
{
  /* FIX!!! why this? niels */
#ifdef EDGEMAPPING
  int i, j, n, saved;
  struct dface_t *df;
  struct dedge_t *ed, *ed2;
  vec3D v1, v2;
  struct dface_t *found[2];
  int foundj[2];

  e1 = edgemapping[e1];
  e2 = edgemapping[e2];

  /* extend e1 to e2 */
  ed = &bspMem->shared.quake1.dedges[e1];
  ed2 = &bspMem->shared.quake1.dedges[e2];
  VectorSubtract(bspMem->shared.quake1.dvertexes[ed->v[1]].point, bspMem->shared.quake1.dvertexes[ed->v[0]].point, v1);
  VectorNormalize(v1);

  if (ed->v[0] == ed2->v[0])
    ed->v[0] = ed2->v[1];
  else if (ed->v[0] == ed2->v[1])
    ed->v[0] = ed2->v[0];
  else if (ed->v[1] == ed2->v[0])
    ed->v[1] = ed2->v[1];
  else if (ed->v[1] == ed2->v[1])
    ed->v[1] = ed2->v[0];
  else
    Error("HealEdges: edges don't meet");

  VectorSubtract(bspMem->shared.quake1.dvertexes[ed->v[1]].point, bspMem->shared.quake1.dvertexes[ed->v[0]].point, v2);
  VectorNormalize(v2);

  if (!VectorCompare(v1, v2))
    Error("HealEdges: edges not colinear");

  edgemapping[e2] = e1;
  saved = 0;

  /* remove all uses of e2 */
  for (i = firstmodelface; i < bspMem->shared.quake1.numfaces; i++) {
    df = &bspMem->shared.quake1.dfaces[i];
    for (j = 0; j < df->numedges; j++) {
      n = bspMem->shared.quake1.dsurfedges[df->firstedge + j];
      if (n == e2 || n == -e2) {
	found[saved] = df;
	foundj[saved] = j;
	saved++;
	break;
      }
    }
  }

  if (saved != 2)
    eprintf("didn't find both faces for a saved edge\n");
  else {
    for (i = 0; i < 2; i++) {					/* remove this edge */

      df = found[i];
      j = foundj[i];
      for (j++; j < df->numedges; j++)
	bspMem->shared.quake1.dsurfedges[df->firstedge + j - 1] =
	  bspMem->shared.quake1.dsurfedges[df->firstedge + j];
      bspMem->shared.quake1.dsurfedges[df->firstedge + j - 1] = 0;
      df->numedges--;
    }

    bspMem->edgefaces[0][e2] = bspMem->edgefaces[1][e2] = NULL;
  }
#else
  return;
#endif
}

/*
 * ==============
 * RemoveColinearEdges
 * ==============
 */
staticfnc void RemoveColinearEdges(bspBase bspMem)
{
  int i, v;
  short int j;
  int c0, c1, c2, c3;
  checkpoint_t *cp;

#ifdef EDGEMAPPING
  /* no edges remapped yet */
  for (i = 0; i < bspMem->shared.quake1.numedges; i++)
    edgemapping[i] = i;
#endif

  /* find vertexes that only have two edges */
  if (!(checkpoints = (checkpoint_t *) tmalloc(sizeof(checkpoint_t) * bspMem->shared.quake1.numvertexes)))
    Error(failed_memoryunsize, "checkpoints");

  for (i = firstmodeledge; i < bspMem->shared.quake1.numedges; i++) {
    if (!bspMem->edgefaces[0][i])
      continue;							/* removed */

    for (j = 0; j < 2; j++) {
      v = bspMem->shared.quake1.dedges[i].v[j];
      cp = &checkpoints[v];
      if (cp->numedges < 2)
	cp->edges[cp->numedges] = i;
      cp->numedges++;
    }
  }

  /* if a vertex only has two edges and they are colinear, it can be removed */
  c0 = c1 = c2 = c3 = 0;

  for (i = 0; i < bspMem->shared.quake1.numvertexes; i++) {
    cp = &checkpoints[i];
    switch (cp->numedges) {
      case 0:
	c0++;
	break;
      case 1:
	c1++;
	break;
      case 2:
	c2++;
	HealEdges(cp->edges[0], cp->edges[1]);
	break;
      default:
	c3++;
	break;
    }
  }

  /*      mprintf ("%5i c0\n", c0); */
  /*      mprintf ("%5i c1\n", c1); */
  /*      mprintf ("%5i c2\n", c2); */
  /*      mprintf ("%5i c3+\n", c3); */
  mprintf("%5i edges removed by tjunction healing\n", c2);
  tfree(checkpoints);
}

/*
 * ==============
 * CountRealNumbers
 * ==============
 */
staticfnc void CountRealNumbers(bspBase bspMem)
{
  int i;
  int c;

  mprintf("%5i regions\n", bspMem->shared.quake1.numfaces - firstmodelface);

  c = 0;
  for (i = firstmodelface; i < bspMem->shared.quake1.numfaces; i++)
    c += bspMem->shared.quake1.dfaces[i].numedges;
  mprintf("%5i real marksurfaces\n", c);

  c = 0;
  for (i = firstmodeledge; i < bspMem->shared.quake1.numedges; i++)
    if (bspMem->edgefaces[0][i])
      c++;							/* not removed */

  mprintf("%5i real edges\n", c);
}

/*============================================================================= */

/*
 * ==============
 * GrowNodeRegion_r
 * ==============
 */
staticfnc void GrowNodeRegion_r(bspBase bspMem, register struct node *node)
{
  struct dface_t *r;
  struct visfacet *f;
  int i;

  if (node->planenum == PLANENUM_LEAF)
    return;

  node->firstface = bspMem->shared.quake1.numfaces;

  for (f = node->faces; f; f = f->next) {
#if 0
    if (f->outputnumber != -1)
      continue;							/* allready grown into an earlier region */
#endif

    /* emit a region */
    if (bspMem->shared.quake1.numfaces == bspMem->shared.quake1.max_numfaces)
      ExpandBSPClusters(bspMem, LUMP_FACES);
    f->outputnumber = bspMem->shared.quake1.numfaces;
    r = &bspMem->shared.quake1.dfaces[bspMem->shared.quake1.numfaces];

    r->planenum = node->outputplanenum;
    r->side = f->planeside;
    r->texinfo = f->texturenum;
    for (i = 0; i < MAXLIGHTMAPS; i++)
      r->styles[i] = 255;
    r->lightofs = -1;

    /* add the face and mergable neighbors to it */
#if 0
    ClearRegionSize();
    AddFaceToRegionSize(f);
    RecursiveGrowRegion(r, f);
#endif
    r->firstedge = firstedge = bspMem->shared.quake1.numsurfedges;
    for (i = 0; i < f->numpoints; i++) {
      if (bspMem->shared.quake1.numsurfedges == bspMem->shared.quake1.max_numsurfedges)
	ExpandBSPClusters(bspMem, LUMP_SURFEDGES);
      bspMem->shared.quake1.dsurfedges[bspMem->shared.quake1.numsurfedges] = f->edges[i];
      bspMem->shared.quake1.numsurfedges++;
    }

    r->numedges = bspMem->shared.quake1.numsurfedges - r->firstedge;

    bspMem->shared.quake1.numfaces++;
  }

  node->numfaces = bspMem->shared.quake1.numfaces - node->firstface;

  GrowNodeRegion_r(bspMem, node->children[0]);
  GrowNodeRegion_r(bspMem, node->children[1]);
}

/*
 * ==============
 * GrowNodeRegions
 * ==============
 */
void GrowNodeRegions(bspBase bspMem, struct node *headnode)
{
  mprintf("----- GrowRegions -------\n");

  GrowNodeRegion_r(bspMem, headnode);

  /*RemoveColinearEdges (); */
  CountRealNumbers(bspMem);
}

/*
 * ===============================================================================
 * 
 * Turn the faces on a plane into optimal non-convex regions
 * The edges may still be split later as a result of tjunctions
 * 
 * typedef struct
 * {
 * vec3D       dir;
 * vec3D       origin;
 * vec3D       p[2];
 * } 
 * for all faces
 * for all edges
 * for all edges so far
 * if overlap
 * split
 * 
 * 
 * ===============================================================================
 */
