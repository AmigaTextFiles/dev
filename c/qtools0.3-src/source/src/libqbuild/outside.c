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

int outleafs = 0;						/* 4 */

struct portal *prevleaknode;					/* 4 */
FILE *leakfile;							/* 4 */

int hit_occupied = 0;						/* 4 */
int backdraw = 0;						/* 4 */

/* PROGRESS-ONLY! */
staticvar int outsidenum;
staticvar int outsidecur;

/*
 * ===========
 * PointInLeaf
 * ===========
 */
struct node *PointInLeaf(mapBase mapMem, struct node *node, vec3D point)
{
  vec1D d;

  if (node->contents)
    return node;

#ifdef EXHAUSIVE_CHECK
  if (node->planenum >= mapMem->numbrushplanes || node->planennum < 0)
    Error("looking for nonexisting plane %d\n", node->planenum);
#endif
  d = DotProduct(mapMem->brushplanes[node->planenum].normal, point) - mapMem->brushplanes[node->planenum].dist;

  if (d > 0)
    return PointInLeaf(mapMem, node->children[0], point);

  return PointInLeaf(mapMem, node->children[1], point);
}

/*
 * ===========
 * PlaceOccupant
 * ===========
 */
staticfnc bool PlaceOccupant(mapBase mapMem, register int num, register vec3D point, register struct node * headnode)
{
  struct node *n;

  n = PointInLeaf(mapMem, headnode, point);
  if (n->contents == CONTENTS_SOLID)
    return FALSE;
  n->occupied = num;
  return TRUE;
}

/*
 * ==============
 * MarkLeakTrail
 * ==============
 */
staticfnc void MarkLeakTrail(register struct portal *n2, register int hullNum)
{
  int i;
  short int j;
  vec3D p1, p2, dir;
  vec1D len;
  struct portal *n1;

  if (hullNum)
    return;

  n1 = prevleaknode;
  prevleaknode = n2;

  if (!n1)
    return;

  VectorCopy(n2->winding->points[0], p1);
  for (i = 1; i < n2->winding->numpoints; i++) {
    for (j = 0; j < 3; j++)
      p1[j] = (p1[j] + n2->winding->points[i][j]) / 2;
  }

  VectorCopy(n1->winding->points[0], p2);
  for (i = 1; i < n1->winding->numpoints; i++) {
    for (j = 0; j < 3; j++)
      p2[j] = (p2[j] + n1->winding->points[i][j]) / 2;
  }

  VectorSubtract(p2, p1, dir);
  len = VectorLength(dir);
  VectorNormalize(dir);

  while (len > 2) {
    fprintf(leakfile, VEC_CONV3D "\n", p1[0], p1[1], p1[2]);
    for (i = 0; i < 3; i++)
      p1[i] += dir[i] * 2;
    len -= 2;
  }
}

/*
 * ==================
 * RecursiveFillOutside
 * 
 * If fill is FALSE, just check, don't fill
 * Returns TRUE if an occupied leaf is reached
 * ==================
 */
staticfnc bool RecursiveFillOutside(register struct node *l, register bool fill, register int hullNum)
{
  struct portal *p;
  int s;

  /* PROGRESS-ONLY! */
  if (!fill)
    outsidenum++;
  else
    mprogress(outsidenum, ++outsidecur);

  if (l->contents == CONTENTS_SOLID ||
      l->contents == CONTENTS_SKY)
    return FALSE;

  if (l->valid == valid)
    return FALSE;

  if (l->occupied)
    return TRUE;

  l->valid = valid;

  /* fill it and it's neighbors */
  if (fill)
    l->contents = CONTENTS_SOLID;
  outleafs++;

  for (p = l->portals; p;) {
    s = (p->nodes[0] == l);

    if (RecursiveFillOutside(p->nodes[s], fill, hullNum)) {		/* leaked, so stop filling */

      if (backdraw-- > 0) {
	MarkLeakTrail(p, hullNum);
	DrawLeaf(l, 2);
      }
      return TRUE;
    }
    p = p->next[!s];
  }

  return FALSE;
}

/*
 * ==================
 * ClearOutFaces
 * 
 * ==================
 */
staticfnc void ClearOutFaces(register struct node *node)
{
  struct visfacet **fp;

  if (node->planenum != -1) {
    ClearOutFaces(node->children[0]);
    ClearOutFaces(node->children[1]);
    return;
  }
  if (node->contents != CONTENTS_SOLID)
    return;

  for (fp = node->markfaces; *fp; fp++) {
    /* mark all the original faces that are removed */
    (*fp)->numpoints = 0;
  }
  node->faces = NULL;
}

/*============================================================================= */

/*
 * ===========
 * FillOutside
 * 
 * ===========
 */
bool FillOutside(mapBase mapMem, struct node *node, char *ptsName, register int hullNum)
{
  int s;
  vec1D *v;
  int i;
  bool inside;

  mprintf("----- FillOutside -------\n");
  /* PROGRESS-ONLY! */
  outsidenum = 0;
  outsidecur = 0;

  if (mapMem->mapOptions & QBSP_NOFILL) {
    mprintf("    - skipped\n");
    return FALSE;
  }

  inside = FALSE;
  for (i = 1; i < mapMem->nummapentities; i++) {
    if (!VectorZero(mapMem->mapentities[i].origin)) {
      if (PlaceOccupant(mapMem, i, mapMem->mapentities[i].origin, node))
	inside = TRUE;
    }
  }

  if (!inside) {
    mprintf("hullNum %i: No mapMem->mapentities in empty space -- no filling performed\n", hullNum);
    return FALSE;
  }

  s = !(outside_node.portals->nodes[1] == &outside_node);

  /* first check to see if an occupied leaf is hit */
  outleafs = 0;
  valid++;

  prevleaknode = NULL;

  if (!hullNum && !(leakfile = __fopen(ptsName, "w")))
    Error(failed_fileopen, ptsName);

  if (RecursiveFillOutside(outside_node.portals->nodes[s], FALSE, hullNum)) {
    v = mapMem->mapentities[hit_occupied].origin;
    eprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    eprintf("reached occupant at: ( " VEC_CONV3D " )\n", v[0], v[1], v[2]);
    eprintf("no filling performed\n");
    if (!hullNum)
      __fclose(leakfile);
    eprintf("leak file written to %s\n", ptsName);
    eprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    return FALSE;
  }
  if (!hullNum)
    __fclose(leakfile);

  /* now go back and fill things in */
  valid++;
  RecursiveFillOutside(outside_node.portals->nodes[s], TRUE, hullNum);

  /* remove faces from filled in leafs     */
  ClearOutFaces(node);

  mprintf("%5i outleafs\n", outleafs);
  return TRUE;
}
