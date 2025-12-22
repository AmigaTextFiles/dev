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

#define	NUM_HASH	4096

typedef struct hashvert_s {
  struct hashvert_s *next;
  vec3D point;
  int num;
  int numplanes;						/* for corner determination */

  int planenums[2];
  int numedges;
} __packed hashvert_t;						/* 36 */

#ifdef DEBUG
staticvar hashvert_t hvertex[MAX_MAP_VERTS];				/* 847872 */
staticvar hashvert_t *hvert_p;						/* 4 */
#endif

int firstmodeledge = 1;						/* 4 */
int firstmodelface;						/* 4 */

staticvar hashvert_t *hashverts[NUM_HASH];				/* 16384 */
staticvar int c_cornerverts;						/* 4 */
staticvar int c_tryedges;							/* 4 */
staticvar int subdivides;
staticvar vec3D hash_min, hash_scale;					/* 24 */
staticvar struct surface newcopy_t;					/* 48 */

/*
 * a surface has all of the faces that could be drawn on a given plane
 * 
 * the outside filling stage can remove some of them so a better bsp can be generated
 * 
 */

/*============================================================================ */

/*
 * ===============
 * SubdivideFace
 * 
 * If the face is >256 in either texture direction, carve a valid sized
 * piece off and insert the remainder in the next link
 * ===============
 */
void SubdivideFace(bspBase bspMem, register struct visfacet *f, register struct visfacet **prevptr)
{
  vec1D mins, maxs;
  vec1D v;
  short int axis;
  int i;
  struct plane plane;
  struct visfacet *front, *back, *next;
  struct texinfo *tex;

  /* special (non-surface cached) faces don't need subdivision */
  tex = &bspMem->shared.quake1.texinfo[f->texturenum];

  if (tex->flags & TEX_SPECIAL)
    return;

  for (axis = 0; axis < 2; axis++) {
    while (1) {
      mins = VEC_POSMAX;
      maxs = VEC_NEGMAX;

      for (i = 0; i < f->numpoints; i++) {
	v = DotProduct(f->pts[i], tex->vecs[axis]);
	if (v < mins)
	  mins = v;
	if (v > maxs)
	  maxs = v;
      }

      if (maxs - mins <= subdivide_size)
	break;

      /* split it */
      subdivides++;

      VectorCopy(tex->vecs[axis], plane.normal);
      v = VectorLength(plane.normal);
      VectorNormalize(plane.normal);
      plane.dist = (mins + subdivide_size - 16) / v;
      next = f->next;
      SplitFace(f, &plane, &front, &back);
      if (!front || !back)
	Error("SubdivideFace: didn't split the polygon");
      *prevptr = back;
      back->next = front;
      front->next = next;
      f = back;
    }
  }
}

/*
 * ================
 * SubdivideFaces
 * ================
 */
void SubdivideFaces(bspBase bspMem, register struct surface *surfhead)
{
  struct surface *surf;
  struct visfacet *f, **prevptr;

  mprintf("----- SubdivideFaces ---\n");

  subdivides = 0;

  for (surf = surfhead; surf; surf = surf->next) {
    prevptr = &surf->faces;
    while (1) {
      f = *prevptr;
      if (!f)
	break;
      SubdivideFace(bspMem, f, prevptr);
      f = *prevptr;
      prevptr = &f->next;
    }
  }

  mprintf("%i faces added by subdivision\n", subdivides);

}

/*
 * =============================================================================
 * 
 * GatherNodeFaces
 * 
 * Frees the current node tree and returns a new chain of the surfaces that
 * have inside faces.
 * =============================================================================
 */

staticfnc void GatherNodeFaces_r(register struct node *node)
{
  struct visfacet *f, *next;

  if (node->planenum != PLANENUM_LEAF) {
    /* decision node */
    for (f = node->faces; f; f = next) {
      next = f->next;
      if (!f->numpoints) {					/* face was removed outside */

	FreeFace(f);
      }
      else {
	f->next = validfaces[f->planenum];
	validfaces[f->planenum] = f;
      }
    }

    GatherNodeFaces_r(node->children[0]);
    GatherNodeFaces_r(node->children[1]);

    tfree(node);
  }
  else {
    /* leaf node */
    tfree(node);
  }
}

/*
 * ================
 * GatherNodeFaces
 * 
 * ================
 */
struct surface *GatherNodeFaces(mapBase mapMem, register struct node *headnode)
{
  struct surface *returnval;

  /* added by niels */
  if (!(validfaces = (struct visfacet **)tmalloc(sizeof(struct visfacet *) * mapMem->numbrushplanes)))
    Error(failed_memoryunsize, "validfaces");

  GatherNodeFaces_r(headnode);
  returnval = BuildSurfaces(mapMem);
  /* added by niels */
  tfree(validfaces);
  return returnval;
}

/*=========================================================================== */

staticfnc void InitHash(void)
{
  vec3D size;
  vec1D volume;
  vec1D scale;
  int newsize[2];
  short int i;

  __bzero(hashverts, sizeof(hashverts));

  for (i = 0; i < 3; i++) {
    hash_min[i] = -8000;
    size[i] = 16000;
  }

  volume = size[0] * size[1];

  scale = sqrt(volume / NUM_HASH);

  newsize[0] = size[0] / scale;
  newsize[1] = size[1] / scale;

  hash_scale[0] = newsize[0] / size[0];
  hash_scale[1] = newsize[1] / size[1];
  hash_scale[2] = newsize[1];

#ifdef DEBUG
  hvert_p = hvertex;
#endif
}

staticfnc unsigned HashVec(register vec3D vec)
{
  unsigned h;

  h = hash_scale[0] * (vec[0] - hash_min[0]) * hash_scale[2]
    + hash_scale[1] * (vec[1] - hash_min[1]);
  if (h >= NUM_HASH)
    return NUM_HASH - 1;
  return h;
}

/*
 * =============
 * GetVertex
 * =============
 */
staticfnc int GetVertex(bspBase bspMem, register vec3D in, register int planenum)
{
  int h;
  int i;
  hashvert_t *hv;
  vec3D vert;

  for (i = 0; i < 3; i++) {
    if (fabs(in[i] - rint(in[i])) < 0.001)
      vert[i] = rint(in[i]);
    else
      vert[i] = in[i];
  }

  h = HashVec(vert);

  for (hv = hashverts[h]; hv; hv = hv->next) {
    if (fabs(hv->point[0] - vert[0]) < POINT_EPSILON
	&& fabs(hv->point[1] - vert[1]) < POINT_EPSILON
	&& fabs(hv->point[2] - vert[2]) < POINT_EPSILON) {
      hv->numedges++;
      if (hv->numplanes == 3)
	return hv->num;						/* allready known to be a corner */

      for (i = 0; i < hv->numplanes; i++)
	if (hv->planenums[i] == planenum)
	  return hv->num;					/* allready know this plane */

      if (hv->numplanes == 2)
	c_cornerverts++;
      else
	hv->planenums[hv->numplanes] = planenum;
      hv->numplanes++;
      return hv->num;
    }
  }

  if (!(hv = (hashvert_t *) kmalloc(sizeof(hashvert_t))))
    Error(failed_memoryunsize, "hashvert");
  hv->numedges = 1;
  hv->numplanes = 1;
  hv->planenums[0] = planenum;
  hv->next = hashverts[h];
  hashverts[h] = hv;
  VectorCopy(vert, hv->point);
  if (bspMem->shared.quake1.numvertexes == bspMem->shared.quake1.max_numvertexes)
    ExpandBSPClusters(bspMem, LUMP_VERTEXES);
  hv->num = bspMem->shared.quake1.numvertexes;

  /* emit a vertex */
  if (bspMem->shared.quake1.numvertexes == bspMem->shared.quake1.max_numvertexes)
    ExpandBSPClusters(bspMem, LUMP_VERTEXES);

  bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.numvertexes].point[0] = vert[0];
  bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.numvertexes].point[1] = vert[1];
  bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.numvertexes].point[2] = vert[2];
  bspMem->shared.quake1.numvertexes++;

  return hv->num;
}

/*=========================================================================== */

/*
 * ==================
 * GetEdge
 * 
 * Don't allow four way edges
 * ==================
 */

staticfnc int GetEdge(bspBase bspMem, register vec3D p1, register vec3D p2, register struct visfacet *f)
{
  int v1, v2;
  struct dedge_t *edge;
  int i;

  if (!f->contents[0])
    Error("GetEdge: 0 contents");

  c_tryedges++;
  v1 = GetVertex(bspMem, p1, f->planenum);
  v2 = GetVertex(bspMem, p2, f->planenum);
  for (i = firstmodeledge; i < bspMem->shared.quake1.numedges; i++) {
    edge = &bspMem->shared.quake1.dedges[i];
    if (v1 == edge->v[1] && v2 == edge->v[0]
	&& !bspMem->edgefaces[1][i]
	&& bspMem->edgefaces[0][i]->contents[0] == f->contents[0]) {
      bspMem->edgefaces[1][i] = f;
      return -i;
    }
  }

  /* emit an edge */
  if (bspMem->shared.quake1.numedges == bspMem->shared.quake1.max_numedges)
    ExpandBSPClusters(bspMem, LUMP_EDGES);
  edge = &bspMem->shared.quake1.dedges[bspMem->shared.quake1.numedges];
  bspMem->shared.quake1.numedges++;
  edge->v[0] = v1;
  edge->v[1] = v2;
  bspMem->edgefaces[0][i] = f;

  return i;
}

/*
 * ==================
 * FindFaceEdges
 * ==================
 */
staticfnc void FindFaceEdges(bspBase bspMem, register struct visfacet *face)
{
  int i;

  face->outputnumber = -1;
  if (face->numpoints > MAXEDGES)
    Error("WriteFace: %i points", face->numpoints);

  for (i = 0; i < face->numpoints; i++)
    face->edges[i] = GetEdge(bspMem, face->pts[i], face->pts[(i + 1) % face->numpoints], face);
}

#ifdef DEBUG
/*
 * =============
 * CheckVertexes
 *  debugging
 * =============
 */
staticfnc void CheckVertexes(void)
{
  int cb, c0, c1, c2, c3;
  hashvert_t *hv;

  cb = c0 = c1 = c2 = c3 = 0;
  for (hv = hvertex; hv != hvert_p; hv++) {
    if (hv->numedges < 0 || hv->numedges & 1)
      cb++;
    else if (!hv->numedges)
      c0++;
    else if (hv->numedges == 2)
      c1++;
    else if (hv->numedges == 4)
      c2++;
    else
      c3++;
  }

  mprintf("%5i bad edge points\n", cb);
  mprintf("%5i 0 edge points\n", c0);
  mprintf("%5i 2 edge points\n", c1);
  mprintf("%5i 4 edge points\n", c2);
  mprintf("%5i 6+ edge points\n", c3);
}

/*
 * =============
 * CheckEdges
 *  debugging
 * =============
 */
staticfnc void CheckEdges(void)
{
  struct dedge_t *edge;
  int i;
  struct dvertex_t *d1, *d2;
  struct visfacet *f1, *f2;
  int c_nonconvex;
  int c_multitexture;

  c_nonconvex = c_multitexture = 0;

/* CheckVertexes (); */
  for (i = 1; i < bspMem->shared.quake1.numedges; i++) {
    edge = &bspMem->shared.quake1.dedges[i];
    if (!bspMem->edgefaces[1][i]) {
      d1 = &bspMem->shared.quake1.dvertexes[edge->v[0]];
      d2 = &bspMem->shared.quake1.dvertexes[edge->v[1]];
      mprintf("unshared edge at: ( " VEC_CONV3D " ) ( " VEC_CONV3D " )\n", d1->point[0], d1->point[1], d1->point[2], d2->point[0], d2->point[1], d2->point[2]);
    }
    else {
      f1 = bspMem->edgefaces[0][i];
      f2 = bspMem->edgefaces[1][i];
      if (f1->planeside != f2->planeside)
	continue;
      if (f1->planenum != f2->planenum)
	continue;

      /* on the same plane, might be discardable */
      if (f1->texturenum == f2->texturenum) {
	hvertex[edge->v[0]].numedges -= 2;
	hvertex[edge->v[1]].numedges -= 2;
	c_nonconvex++;
      }
      else
	c_multitexture++;
    }
  }

/* mprintf ("%5i edges\n", i); */
/* mprintf ("%5i c_nonconvex\n", c_nonconvex); */
/* mprintf ("%5i c_multitexture\n", c_multitexture); */
/* CheckVertexes (); */
}
#endif

/*
 * ================
 * MakeFaceEdges_r
 * ================
 */
staticfnc void MakeFaceEdges_r(bspBase bspMem, register struct node *node)
{
  struct visfacet *f;

  if (node->planenum == PLANENUM_LEAF)
    return;

  for (f = node->faces; f; f = f->next)
    FindFaceEdges(bspMem, f);

  MakeFaceEdges_r(bspMem, node->children[0]);
  MakeFaceEdges_r(bspMem, node->children[1]);
}

/*
 * ================
 * MakeFaceEdges
 * ================
 */
void MakeFaceEdges(bspBase bspMem, struct node *headnode)
{
  mprintf("----- MakeFaceEdges -----\n");

  InitHash();
  c_tryedges = 0;
  c_cornerverts = 0;

  MakeFaceEdges_r(bspMem, headnode);

/* CheckEdges (); */
  GrowNodeRegions(bspMem, headnode);

  firstmodeledge = bspMem->shared.quake1.numedges;
  firstmodelface = bspMem->shared.quake1.numfaces;

  kfree();
}
