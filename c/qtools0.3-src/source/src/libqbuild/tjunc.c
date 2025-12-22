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

#define	NUM_HASH	1024

struct wvert {
  vec1D t;
  struct wvert *prev, *next;
} __packed;							/* 12 */

struct wedge {
  struct wedge *next;
  vec3D dir;
  vec3D origin;
  struct wvert head;
} __packed;							/* 40 */

staticvar int numwedges, numwverts;					/* 8 */
staticvar int tjuncs;							/* 4 */
staticvar int tjuncfaces;							/* 4 */

staticvar struct wvert *wverts = 0;
staticvar struct wedge *wedges = 0;
staticvar struct wedge *wedge_hash[NUM_HASH];				/* 4096 */
staticvar vec3D hash_min, hash_scale;					/* 24 */

/* a specially allocated face that can hold hundreds of edges if needed */
staticvar struct visfacet *superface;
staticvar struct visfacet *newlist;					/* 4 */

/* PROGRESS-ONLY! */
staticvar int tjuncnum;
staticvar int tjunccur;

/*============================================================================ */

staticfnc void PrintFace(register struct visfacet *f)
{
  int i;

  for (i = 0; i < f->numpoints; i++)
    mprintf("( " VEC_CONV3D " )\n", f->pts[i][0], f->pts[i][1], f->pts[i][2]);
}

staticfnc void InitTJHash(register vec3D mins, register vec3D maxs)
{
  vec3D size;
  vec1D volume;
  vec1D scale;
  int newsize[2];

  VectorCopy(mins, hash_min);
  VectorSubtract(maxs, mins, size);
  __bzero(wedge_hash, sizeof(wedge_hash));

  volume = size[0] * size[1];

  scale = sqrt(volume / NUM_HASH);

  newsize[0] = size[0] / scale;
  newsize[1] = size[1] / scale;

  hash_scale[0] = newsize[0] / size[0];
  hash_scale[1] = newsize[1] / size[1];
  hash_scale[2] = newsize[1];
}

staticfnc unsigned TJHashVec(register vec3D vec)
{
  unsigned h;

  h = hash_scale[0] * (vec[0] - hash_min[0]) * hash_scale[2]
    + hash_scale[1] * (vec[1] - hash_min[1]);
  if (h >= NUM_HASH)
    return NUM_HASH - 1;
  return h;
}

/*============================================================================ */

staticfnc void CanonicalVector(register vec3D vec)
{
  VectorNormalize(vec);
  if (vec[0] > EQUAL_EPSILON)
    return;
  else if (vec[0] < -EQUAL_EPSILON) {
    VectorNegate(vec);
    return;
  }
  else
    vec[0] = 0;

  if (vec[1] > EQUAL_EPSILON)
    return;
  else if (vec[1] < -EQUAL_EPSILON) {
    VectorNegate(vec);
    return;
  }
  else
    vec[1] = 0;

  if (vec[2] > EQUAL_EPSILON)
    return;
  else if (vec[2] < -EQUAL_EPSILON) {
    VectorNegate(vec);
    return;
  }
  else
    vec[2] = 0;
  Error("CanonicalVector: degenerate");
}

staticfnc struct wedge *FindEdge(register vec3D p1, register vec3D p2, register vec1D * t1, register vec1D * t2)
{
  vec3D origin;
  vec3D dir;
  struct wedge *w;
  vec1D temp;
  int h;

  VectorSubtract(p2, p1, dir);
  CanonicalVector(dir);

  *t1 = DotProduct(p1, dir);
  *t2 = DotProduct(p2, dir);

  VectorMA(p1, -*t1, dir, origin);

  if (*t1 > *t2) {
    temp = *t1;
    *t1 = *t2;
    *t2 = temp;
  }

  h = TJHashVec(origin);

  for (w = wedge_hash[h]; w; w = w->next) {
    temp = w->origin[0] - origin[0];
    if (temp < -EQUAL_EPSILON || temp > EQUAL_EPSILON)
      continue;
    temp = w->origin[1] - origin[1];
    if (temp < -EQUAL_EPSILON || temp > EQUAL_EPSILON)
      continue;
    temp = w->origin[2] - origin[2];
    if (temp < -EQUAL_EPSILON || temp > EQUAL_EPSILON)
      continue;

    temp = w->dir[0] - dir[0];
    if (temp < -EQUAL_EPSILON || temp > EQUAL_EPSILON)
      continue;
    temp = w->dir[1] - dir[1];
    if (temp < -EQUAL_EPSILON || temp > EQUAL_EPSILON)
      continue;
    temp = w->dir[2] - dir[2];
    if (temp < -EQUAL_EPSILON || temp > EQUAL_EPSILON)
      continue;

    return w;
  }

  if (!(w = (struct wedge *)kmalloc(sizeof(struct wedge))))
      Error(failed_memoryunsize, "wedge");

  numwedges++;

  w->next = wedge_hash[h];
  wedge_hash[h] = w;

  VectorCopy(origin, w->origin);
  VectorCopy(dir, w->dir);
  w->head.next = w->head.prev = &w->head;
  w->head.t = VEC_POSMAX;
  return w;
}

/*
 * ===============
 * AddVert
 * 
 * ===============
 */

staticfnc void AddVert(register struct wedge *w, register vec1D t)
{
  struct wvert *v, *newv;

  v = w->head.next;
  do {
    if (fabs(v->t - t) < T_EPSILON)
      return;
    if (v->t > t)
      break;
    v = v->next;
  } while (1);

  /* insert a new wvert before v */
  if (!(newv = (struct wvert *)kmalloc(sizeof(struct wvert))))
      Error(failed_memoryunsize, "newv");

  numwverts++;

  newv->t = t;
  newv->next = v;
  newv->prev = v->prev;
  v->prev->next = newv;
  v->prev = newv;
}

/*
 * ===============
 * AddEdge
 * 
 * ===============
 */
staticfnc void AddEdge(register vec3D p1, register vec3D p2)
{
  struct wedge *w;
  vec1D t1, t2;

  w = FindEdge(p1, p2, &t1, &t2);
  AddVert(w, t1);
  AddVert(w, t2);
}

/*
 * ===============
 * AddFaceEdges
 * 
 * ===============
 */
staticfnc void AddFaceEdges(register struct visfacet *f)
{
  int i, j;

  for (i = 0; i < f->numpoints; i++) {
    j = (i + 1) % f->numpoints;
    AddEdge(f->pts[i], f->pts[j]);
  }
}

/*============================================================================ */

staticfnc void SplitFaceForTjunc(register struct visfacet *f, register struct visfacet *original)
{
  int i;
  struct visfacet *new, *chain;
  vec3D dir, test;
  vec1D v;
  int firstcorner, lastcorner;

  chain = NULL;
  do {
    if (f->numpoints <= MAXPOINTS) {				/* the face is now small enough without more cutting */
      /* so copy it back to the original */
      CopyFace(original, f);
      original->original = chain;
      original->next = newlist;
      newlist = original;
      return;
    }

    tjuncfaces++;

  restart:
    /* find the last corner  */
    VectorSubtract(f->pts[f->numpoints - 1], f->pts[0], dir);
    VectorNormalize(dir);
    for (lastcorner = f->numpoints - 1; lastcorner > 0; lastcorner--) {
      VectorSubtract(f->pts[lastcorner - 1], f->pts[lastcorner], test);
      VectorNormalize(test);
      v = DotProduct(test, dir);
      if (v < 0.9999 || v > 1.00001) {
	break;
      }
    }

    /* find the first corner         */
    VectorSubtract(f->pts[1], f->pts[0], dir);
    VectorNormalize(dir);
    for (firstcorner = 1; firstcorner < f->numpoints - 1; firstcorner++) {
      VectorSubtract(f->pts[firstcorner + 1], f->pts[firstcorner], test);
      VectorNormalize(test);
      v = DotProduct(test, dir);
      if (v < 0.9999 || v > 1.00001) {
	break;
      }
    }

    if (firstcorner + 2 >= MAXPOINTS) {
      /* rotate the point winding */
      VectorCopy(f->pts[0], test);
      /*__memcpy(f->pts + 1, f->pts, (f->numpoints - 1) * sizeof(vec3D)); */
      for (i = 1; i < f->numpoints; i++) {
	VectorCopy(f->pts[i], f->pts[i - 1]);
      }
      VectorCopy(test, f->pts[f->numpoints - 1]);
      goto restart;
    }

    /*
     * cut off as big a piece as possible, less than MAXPOINTS, and not
     * past lastcorner
     */
    new = NewFaceFromFace(f, MAXPOINTS);
    if (f->original)
      Error("SplitFaceForTjunc: f->original");

    new->original = chain;
    chain = new;
    new->next = newlist;
    newlist = new;
    if (f->numpoints - firstcorner <= MAXPOINTS)
      new->numpoints = firstcorner + 2;
    else if (lastcorner + 2 < MAXPOINTS &&
	     f->numpoints - lastcorner <= MAXPOINTS)
      new->numpoints = lastcorner + 2;
    else
      new->numpoints = MAXPOINTS;

    /*__memcpy(new->pts, f->pts, new->numpoints * sizeof(vec3D)); */
    for (i = 0; i < new->numpoints; i++)
      VectorCopy(f->pts[i], new->pts[i]);

    /*__memcpy(f->pts, f->pts + new->numpoints - 1, (f->numpoints - (new->numpoints - 2)) * sizeof(vec3D)); */
    for (i = new->numpoints - 1; i < f->numpoints; i++)
      VectorCopy(f->pts[i], f->pts[i - (new->numpoints - 2)]);

    f->numpoints -= (new->numpoints - 2);

    RecalcFace(f);
    RecalcFace(new);
  } while (1);
}

/*
 * ===============
 * FixFaceEdges
 * 
 * ===============
 */
staticfnc void FixFaceEdges(register struct visfacet *f)
{
  int i, j, k;
  struct wedge *w;
  struct wvert *v;
  vec1D t1, t2;

  /* allocate the mega-face */
  superface = AllocFace(1024);					/* 512 faces: 34 + 1024*12 + 1024*4 = 8226*2 */
  __memcpy(superface, f, sizeof(struct visfacet) - sizeof(vec3D *) - sizeof(int *));	/* <- small hack to not overwrite the allocated pts/edges */

  __memcpy(superface->pts, f->pts, f->numpoints * sizeof(vec3D));
  __memcpy(superface->edges, f->edges, f->numpoints * sizeof(int));

restart:
  for (i = 0; i < superface->numpoints; i++) {
    j = (i + 1) % superface->numpoints;

    w = FindEdge(superface->pts[i], superface->pts[j], &t1, &t2);

    for (v = w->head.next; v->t < t1 + T_EPSILON; v = v->next) {
    }

    if (v->t < t2 - T_EPSILON) {
      tjuncs++;
      /* insert a new vertex here */
/*__memcpy(superface->pts + j + 1, superface->pts + j, superface->numpoints - j); */
      /*for (k = j; k < superface->numpoints; k++) { */
      /*  VectorCopy(superface->pts[k], superface->pts[k + 1]); */
      /*} */
      for (k = superface->numpoints; k > j; k--) {
	VectorCopy(superface->pts[k - 1], superface->pts[k]);
      }
      VectorMA(w->origin, v->t, w->dir, superface->pts[j]);
      superface->numpoints++;
      goto restart;
    }
  }

  if (superface->numpoints <= MAXPOINTS) {
    CopyFace(f, superface);
    FreeFace(superface);
    f->next = newlist;
    newlist = f;
    return;
  }

  /* the face needs to be split into multiple faces because of too many edges */
  SplitFaceForTjunc(superface, f);
  FreeFace(superface);
}

/*============================================================================ */

staticfnc void tjunc_find_r(register struct node *node)
{
  struct visfacet *f;

  /* PROGRESS-ONLY! */
  tjuncnum++;

  if (node->planenum == PLANENUM_LEAF)
    return;

  for (f = node->faces; f; f = f->next)
    AddFaceEdges(f);

  tjunc_find_r(node->children[0]);
  tjunc_find_r(node->children[1]);
}

staticfnc void tjunc_fix_r(register struct node *node)
{
  struct visfacet *f, *next;

  /* PROGRESS-ONLY! */
  mprogress(tjuncnum, ++tjunccur);

  if (node->planenum == PLANENUM_LEAF)
    return;

  newlist = NULL;

  for (f = node->faces; f; f = next) {
    next = f->next;
    FixFaceEdges(f);
  }

  node->faces = newlist;

  tjunc_fix_r(node->children[0]);
  tjunc_fix_r(node->children[1]);
}

/*
 * ===========
 * tjunc
 * 
 * ===========
 */
void tjunc(struct node *headnode)
{
  vec3D maxs, mins;
  short int i;

  mprintf("----- tjunc ------------\n");
  /* PROGRESS-ONLY! */
  tjuncnum = 0;
  tjunccur = 0;

  /* identify all points on common edges */
  /* origin points won't allways be inside the map, so extend the hash area  */
  for (i = 0; i < 3; i++) {
    if (fabs(brushset->maxs[i]) > fabs(brushset->mins[i]))
      maxs[i] = fabs(brushset->maxs[i]);
    else
      maxs[i] = fabs(brushset->mins[i]);
  }
  VectorNegateTo(maxs, mins);

  InitTJHash(mins, maxs);

  numwedges = numwverts = 0;

  tjunc_find_r(headnode);

  mprintf("%5i world edges\n%5i edge points\n", numwedges, numwverts);

  /* add extra vertexes on edges where needed  */
  tjuncs = tjuncfaces = 0;

  tjunc_fix_r(headnode);

  mprintf("%5i edges added by tjunctions\n", tjuncs);
  mprintf("%5i faces added by tjunctions\n", tjuncfaces);

  kfree();
}
