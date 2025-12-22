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

/*JIM */
staticvar struct entity *CurrentEntity;					/* 4 */

staticvar vec3D brush_mins, brush_maxs;					/* 24 */
staticvar struct visfacet *brush_faces;					/* 4 */

staticvar vec3D hull_size[3][2] =					/* 72 */
{
  {
    {0, 0, 0},
    {0, 0, 0}},
  {
    {-16, -16, -32},
    {16, 16, 24}},
  {
    {-32, -32, -64},
    {32, 32, 24}}
};

staticvar int num_hull_points;						/* 4 */
staticvar vec3D hull_points[MAX_HULL_POINTS];				/* 384 */
staticvar vec3D hull_corners[MAX_HULL_POINTS * 8];			/* 3072 */
staticvar int num_hull_edges;						/* 4 */
staticvar int hull_edges[MAX_HULL_EDGES][2];				/* 512 */

/*=========================================================================== */

/*
 * =================
 * CheckFace
 * 
 * Note: this will not catch 0 area polygons
 * =================
 */
void CheckFace(mapBase mapMem, register struct visfacet *f)
{
  int i, j;
  vec1D *p1, *p2;
  vec1D d, edgedist;
  vec3D dir, edgenormal, facenormal;

  if (f->numpoints < 3)
    Error("CheckFace: %i points", f->numpoints);

#ifdef EXHAUSIVE_CHECK
  if (f->planenum >= mapMem->numbrushplanes || f->planenum < 0)
    Error("looking for nonexisting plane %d\n", f->planenum);
#endif
  VectorCopy(mapMem->brushplanes[f->planenum].normal, facenormal);
  if (f->planeside) {
    VectorNegate(facenormal);
  }

  for (i = 0; i < f->numpoints; i++) {
    p1 = f->pts[i];

    for (j = 0; j < 3; j++)
      if (p1[j] > BOGUS_RANGE || p1[j] < -BOGUS_RANGE)
	Error("CheckFace: BUGUS_RANGE: " VEC_CONV1D "", p1[j]);

    j = i + 1 == f->numpoints ? 0 : i + 1;

    /* check the point is on the face plane */
    d = DotProduct(p1, mapMem->brushplanes[f->planenum].normal) - mapMem->brushplanes[f->planenum].dist;
#ifdef EXHAUSIVE_CHECK
    if (d < -ON_EPSILON || d > ON_EPSILON)
      Error("CheckFace: point off plane");
#endif
    if (d < -1 || d > 1)
      Error("CheckFace: point off plane d = " VEC_CONV1D "", d);

    /* check the edge isn't degenerate */
    p2 = f->pts[j];
    VectorSubtract(p2, p1, dir);

    if (VectorLength(dir) < ON_EPSILON)
      Error("CheckFace: degenerate edge");

    CrossProduct(facenormal, dir, edgenormal);
    VectorNormalize(edgenormal);
    edgedist = DotProduct(p1, edgenormal);
    edgedist += ON_EPSILON;

    /* all other points must be on front side */
#ifndef	BETTER_BRANCH
    for (j = 0; j < f->numpoints; j++) {
      if (j == i)
	continue;
      d = DotProduct(f->pts[j], edgenormal);
      if (d > edgedist)
	Error("CheckFace: non-convex");
    }
#else
    for (j = 0; j < i; j++)
      if (DotProduct(f->pts[j], edgenormal) > edgedist)
	Error("CheckFace: non-convex");
    for (j++; j < f->numpoints; j++)
      if (DotProduct(f->pts[j], edgenormal) > edgedist)
	Error("CheckFace: non-convex");
#endif
  }
}

/*=========================================================================== */

/*
 * =================
 * ClearBounds
 * =================
 */
staticfnc void ClearBounds(register struct brushset *bs)
{
  bs->mins[0] = bs->mins[1] = bs->mins[2] = VEC_POSMAX;
  bs->maxs[0] = bs->maxs[1] = bs->maxs[2] = VEC_NEGMAX;
}

/*
 * =================
 * AddToBounds
 * =================
 */
staticfnc void AddToBounds(register struct brushset *bs, register vec3D v)
{
  short int i;

  for (i = 0; i < 3; i++) {
    if (v[i] < bs->mins[i])
      bs->mins[i] = v[i];
    if (v[i] > bs->maxs[i])
      bs->maxs[i] = v[i];
  }
}

/*=========================================================================== */

int PlaneTypeForNormal(vec3D normal)
{
  vec1D ax, ay, az;

  /* NOTE: should these have an epsilon around 1.0? */
  if (normal[0] == 1.0)
    return PLANE_X;
  if (normal[1] == 1.0)
    return PLANE_Y;
  if (normal[2] == 1.0)
    return PLANE_Z;
  if (normal[0] == -1.0 ||
      normal[1] == -1.0 ||
      normal[2] == -1.0)
    Error("PlaneTypeForNormal: not a canonical vector");

  ax = fabs(normal[0]);
  ay = fabs(normal[1]);
  az = fabs(normal[2]);

  if (ax >= ay && ax >= az)
    return PLANE_ANYX;
  if (ay >= ax && ay >= az)
    return PLANE_ANYY;
  return PLANE_ANYZ;
}

staticfnc void NormalizePlane(register struct plane *dp)
{
  vec1D ax, ay, az;

  if (dp->normal[0] == -1.0) {
    dp->normal[0] = 1.0;
    dp->dist = -dp->dist;
  }
  if (dp->normal[1] == -1.0) {
    dp->normal[1] = 1.0;
    dp->dist = -dp->dist;
  }
  if (dp->normal[2] == -1.0) {
    dp->normal[2] = 1.0;
    dp->dist = -dp->dist;
  }

  if (dp->normal[0] == 1.0) {
    dp->type = PLANE_X;
    return;
  }
  if (dp->normal[1] == 1.0) {
    dp->type = PLANE_Y;
    return;
  }
  if (dp->normal[2] == 1.0) {
    dp->type = PLANE_Z;
    return;
  }

  ax = fabs(dp->normal[0]);
  ay = fabs(dp->normal[1]);
  az = fabs(dp->normal[2]);

  if (ax >= ay && ax >= az)
    dp->type = PLANE_ANYX;
  else if (ay >= ax && ay >= az)
    dp->type = PLANE_ANYY;
  else
    dp->type = PLANE_ANYZ;
  if (dp->normal[dp->type - PLANE_ANYX] < 0) {
    VectorNegate(dp->normal);
    dp->dist = -dp->dist;
  }

}

/*
 * ===============
 * FindPlane
 * 
 * Returns a global plane number and the side that will be the front
 * ===============
 */
int FindPlane(mapBase mapMem, register struct plane *dplane, register int *side)
{
  int i;
  struct plane *dp, pl;
  vec1D dot;

  dot = VectorLength(dplane->normal);
  if (dot < 1.0 - ANGLE_EPSILON || dot > 1.0 + ANGLE_EPSILON)
    Error("FindPlane: normalization error");

  pl = *dplane;
  NormalizePlane(&pl);
  if (DotProduct(pl.normal, dplane->normal) > 0)
    *side = 0;
  else
    *side = 1;

  dp = mapMem->brushplanes;
  for (i = 0; i < mapMem->numbrushplanes; i++, dp++) {
    dot = DotProduct(dp->normal, pl.normal);
    if (dot > 1.0 - ANGLE_EPSILON
	&& fabs(dp->dist - pl.dist) < DISTEPSILON) {		/* regular match */
      return i;
    }
  }

  if (mapMem->numbrushplanes == mapMem->max_numbrushplanes)
    ExpandMapClusters(mapMem, MAP_BRUSHPLANES);
  mapMem->brushplanes[mapMem->numbrushplanes] = pl;
  mapMem->numbrushplanes++;

  return mapMem->numbrushplanes - 1;
}

/*
 * ===============
 * FindPlane_old
 * 
 * Returns a global plane number and the side that will be the front
 * ===============
 */
staticfnc int FindPlane_old(mapBase mapMem, register struct plane *dplane, register int *side)
{
  int i;
  struct plane *dp;
  vec1D dot, ax, ay, az;

  dot = VectorLength(dplane->normal);
  if (dot < 1.0 - ANGLE_EPSILON || dot > 1.0 + ANGLE_EPSILON)
    Error("FindPlane: normalization error");

  dp = mapMem->brushplanes;

  for (i = 0; i < mapMem->numbrushplanes; i++, dp++) {
    dot = DotProduct(dplane->normal, dp->normal);
    if (dot > 1.0 - ANGLE_EPSILON
	&& fabs(dplane->dist - dp->dist) < DISTEPSILON) {	/* regular match */

      *side = 0;
      return i;
    }
    if (dot < -1.0 + ANGLE_EPSILON
	&& fabs(dplane->dist + dp->dist) < DISTEPSILON) {	/* inverse of vector */

      *side = 1;
      return i;
    }
  }

  /* allocate a new plane, flipping normal to a consistant direction */
  /* if needed */
  *dp = *dplane;

  if (mapMem->numbrushplanes == mapMem->max_numbrushplanes)
    ExpandMapClusters(mapMem, MAP_BRUSHPLANES);
  mapMem->numbrushplanes++;

  *side = 0;

  /* NOTE: should these have an epsilon around 1.0? */
  if (dplane->normal[0] == 1.0)
    dp->type = PLANE_X;
  else if (dplane->normal[1] == 1.0)
    dp->type = PLANE_Y;
  else if (dplane->normal[2] == 1.0)
    dp->type = PLANE_Z;
  else if (dplane->normal[0] == -1.0) {
    dp->type = PLANE_X;
    dp->normal[0] = 1.0;
    dp->dist = -dp->dist;
    *side = 1;
  }
  else if (dplane->normal[1] == -1.0) {
    dp->type = PLANE_Y;
    dp->normal[1] = 1.0;
    dp->dist = -dp->dist;
    *side = 1;
  }
  else if (dplane->normal[2] == -1.0) {
    dp->type = PLANE_Z;
    dp->normal[2] = 1.0;
    dp->dist = -dp->dist;
    *side = 1;
  }
  else {
    ax = fabs(dplane->normal[0]);
    ay = fabs(dplane->normal[1]);
    az = fabs(dplane->normal[2]);

    if (ax >= ay && ax >= az)
      dp->type = PLANE_ANYX;
    else if (ay >= ax && ay >= az)
      dp->type = PLANE_ANYY;
    else
      dp->type = PLANE_ANYZ;
    if (dplane->normal[dp->type - PLANE_ANYX] < 0) {
      VectorNegate(dp->normal);
      dp->dist = -dp->dist;
      *side = 1;
    }
  }

  return i;
}

/*
 * =============================================================================
 * 
 * TURN BRUSHES INTO GROUPS OF FACES
 * 
 * =============================================================================
 */

/*
 * =================
 * CreateBrushFaces
 * =================
 */
staticfnc void CreateBrushFaces(mapBase mapMem)
{
  int i, j;
  short int k;
  vec1D r;
  struct visfacet *f;
  struct winding *w;
  struct plane plane;
  struct mface *mf;

  vec3D offset;
  vec3D point;
  vec1D max;
  vec1D min;

  offset[0] = offset[1] = offset[2] = 0;
  brush_mins[0] = brush_mins[1] = brush_mins[2] = min = VEC_POSMAX;
  brush_maxs[0] = brush_maxs[1] = brush_maxs[2] = max = VEC_NEGMAX;

  brush_faces = NULL;

  if (!strncmp(CurrentEntity->classname, "rotate_", 7)) {
    char text[32];

    if (CurrentEntity->targetent) {
      GetVectorForKey(CurrentEntity->targetent, "origin", offset);
      sprintf(text, VEC_CONV3D, offset[0], offset[1], offset[2]);
      SetKeyValue(CurrentEntity, "origin", text);
    }
  }

  for (i = 0; i < mapMem->numbrushfaces; i++) {
    mf = &mapMem->brushfaces[i];

    w = BaseWindingForPlane(&mf->plane);
    /*
     * if (!w)
     *   printf("basewinding failed\n");
     */

    for (j = 0; j < mapMem->numbrushfaces && w; j++) {
      if (j == i)
	continue;
      /* flip the plane, because we want to keep the back side */
      VectorNegateTo(mapMem->brushfaces[j].plane.normal, plane.normal);
      plane.dist = -mapMem->brushfaces[j].plane.dist;

      w = ClipWinding(w, &plane, FALSE);
      /*
       * if (!w)
       *   Error("clipwinding failed\n");
       */
    }

    if (!w)
      continue;							/* overcontrained plane */

    /* this face is a keeper */
    f = AllocFace(w->numpoints);
    f->numpoints = w->numpoints;
    if (f->numpoints > MAXEDGES)
      Error("f->numpoints > MAXEDGES");

    /* mprintf("CreateBrushFaces: make face with %d points\n", f->numpoints); */

    for (j = 0; j < w->numpoints; j++) {
      for (k = 0; k < 3; k++) {
	/*JIM */
	point[k] = w->points[j][k] - offset[k];
	r = rint(point[k]);
	if (fabs(point[k] - r) < ZERO_EPSILON)
	  f->pts[j][k] = r;
	else
	  f->pts[j][k] = point[k];

	if (f->pts[j][k] < brush_mins[k])
	  brush_mins[k] = f->pts[j][k];
	if (f->pts[j][k] > brush_maxs[k])
	  brush_maxs[k] = f->pts[j][k];
	if (f->pts[j][k] < min)
	  min = f->pts[j][k];
	if (f->pts[j][k] > max)
	  max = f->pts[j][k];
      }

    }
    VectorCopy(mf->plane.normal, plane.normal);
    VectorScale(mf->plane.normal, mf->plane.dist, point);
    VectorSubtract(point, offset, point);
    plane.dist = DotProduct(plane.normal, point);

    FreeWinding(w);
    f->texturenum = mf->texinfo;
    f->planenum = FindPlane(mapMem, &plane, &f->planeside);
    f->next = brush_faces;
    brush_faces = f;
    CheckFace(mapMem, f);
  }

  /*
   * Rotatable objects have to have a bounding box big enough
   * to account for all its rotations.
   */
  if (!strncmp(CurrentEntity->classname, "rotate_", 7)) {
    vec1D delta;

    delta = fabs(max);
    if (fabs(min) > delta)
      delta = fabs(min);

    for (k = 0; k < 3; k++) {
      brush_mins[k] = -delta;
      brush_maxs[k] = delta;
    }
  }
}

/*
 * ==============================================================================
 * 
 * BEVELED CLIPPING HULL GENERATION
 * 
 * This is done by brute force, and could easily get a lot faster if anyone cares.
 * ==============================================================================
 */

/*
 * ============
 * AddBrushPlane
 * =============
 */
staticfnc void AddBrushPlane(mapBase mapMem, register struct plane *plane)
{
  int i;
  struct plane *pl;
  vec1D l;

  if (mapMem->numbrushfaces == mapMem->max_numbrushfaces)
    ExpandMapClusters(mapMem, MAP_BRUSHFACES);

  l = VectorLength(plane->normal);
  if (l < 0.999 || l > 1.001)
    Error("AddBrushPlane: bad normal");

  for (i = 0; i < mapMem->numbrushfaces; i++) {
    pl = &mapMem->brushfaces[i].plane;
    if (VectorCompare(pl->normal, plane->normal)
	&& fabs(pl->dist - plane->dist) < ON_EPSILON)
      return;
  }
  mapMem->brushfaces[i].plane = *plane;
  mapMem->brushfaces[i].texinfo = mapMem->brushfaces[0].texinfo;
  mapMem->numbrushfaces++;
}

/*
 * ============
 * TestAddPlane
 * 
 * Adds the given plane to the brush description if all of the original brush
 * vertexes can be put on the front side
 * =============
 */
staticfnc void TestAddPlane(mapBase mapMem, register struct plane *plane)
{
  int i, c;
  vec1D d;
  vec1D *corner;
  struct plane flip;
  vec3D inv;
  int counts[3];
  struct plane *pl;

  /* see if the plane has allready been added */
  for (i = 0; i < mapMem->numbrushfaces; i++) {
    pl = &mapMem->brushfaces[i].plane;
    if (VectorCompare(plane->normal, pl->normal) && fabs(plane->dist - pl->dist) < ON_EPSILON)
      return;
    VectorNegateTo(plane->normal, inv);
    if (VectorCompare(inv, pl->normal) && fabs(plane->dist + pl->dist) < ON_EPSILON)
      return;
  }

  /* check all the corner points */
  counts[0] = counts[1] = counts[2] = 0;
  c = num_hull_points * 8;

  corner = hull_corners[0];
  for (i = 0; i < c; i++, corner += 3) {
    d = DotProduct(corner, plane->normal) - plane->dist;
    if (d < -ON_EPSILON) {
      if (counts[0])
	return;
      counts[1]++;
    }
    else if (d > ON_EPSILON) {
      if (counts[1])
	return;
      counts[0]++;
    }
    else
      counts[2]++;
  }

  /* the plane is a seperator */
  if (counts[0]) {
    VectorNegateTo(plane->normal, flip.normal);
    flip.dist = -plane->dist;
    plane = &flip;
  }

  AddBrushPlane(mapMem, plane);
}

/*
 * ============
 * AddHullPoint
 * 
 * Doesn't add if duplicated
 * =============
 */
staticfnc int AddHullPoint(register vec3D p, register int hullNum)
{
  int i;
  vec1D *c;
  short int x, y, z;

  for (i = 0; i < num_hull_points; i++)
    if (VectorCompare(p, hull_points[i]))
      return i;

  VectorCopy(p, hull_points[num_hull_points]);

  c = hull_corners[i * 8];

  for (x = 0; x < 2; x++)
    for (y = 0; y < 2; y++)
      for (z = 0; z < 2; z++) {
	c[0] = p[0] + hull_size[hullNum][x][0];
	c[1] = p[1] + hull_size[hullNum][y][1];
	c[2] = p[2] + hull_size[hullNum][z][2];
	c += 3;
      }

  if (num_hull_points == MAX_HULL_POINTS)
    Error("MAX_HULL_POINTS");

  num_hull_points++;

  return i;
}

/*
 * ============
 * AddHullEdge
 * 
 * Creates all of the hull planes around the given edge, if not done allready
 * =============
 */
staticfnc void AddHullEdge(mapBase mapMem, register vec3D p1, register vec3D p2, register int hullNum)
{
  int pt1, pt2;
  int i;
  short int a, b, c, d, e;
  vec3D edgevec, planeorg, planevec;
  struct plane plane;
  vec1D l;

  pt1 = AddHullPoint(p1, hullNum);
  pt2 = AddHullPoint(p2, hullNum);

  for (i = 0; i < num_hull_edges; i++)
    if ((hull_edges[i][0] == pt1 && hull_edges[i][1] == pt2)
	|| (hull_edges[i][0] == pt2 && hull_edges[i][1] == pt1))
      return;							/* allread added */
  if (num_hull_edges == MAX_HULL_EDGES)
    Error("MAX_HULL_EDGES");

  hull_edges[i][0] = pt1;
  hull_edges[i][1] = pt2;
  num_hull_edges++;

  VectorSubtract(p1, p2, edgevec);
  VectorNormalize(edgevec);

  for (a = 0; a < 3; a++) {
    b = (a + 1) % 3;
    c = (a + 2) % 3;
    for (d = 0; d <= 1; d++)
      for (e = 0; e <= 1; e++) {
	VectorCopy(p1, planeorg);
	planeorg[b] += hull_size[hullNum][d][b];
	planeorg[c] += hull_size[hullNum][e][c];

	VectorClear(planevec);
	planevec[a] = 1;

	CrossProduct(planevec, edgevec, plane.normal);
	l = VectorLength(plane.normal);
	if (l < 1 - ANGLE_EPSILON || l > 1 + ANGLE_EPSILON)
	  continue;
	plane.dist = DotProduct(planeorg, plane.normal);
	TestAddPlane(mapMem, &plane);
      }
  }
}

/*
 * ============
 * ExpandBrush
 * =============
 */
staticfnc void ExpandBrush(mapBase mapMem, register int hullNum)
{
  int i, s;
  short int x;
  vec3D corner;
  struct visfacet *f;
  struct plane plane, *p;

  num_hull_points = 0;
  num_hull_edges = 0;

  /* create all the hull points */
  for (f = brush_faces; f; f = f->next)
    for (i = 0; i < f->numpoints; i++)
      AddHullPoint(f->pts[i], hullNum);

  /* expand all of the planes */
  for (i = 0; i < mapMem->numbrushfaces; i++) {
    p = &mapMem->brushfaces[i].plane;
    VectorClear(corner);
    for (x = 0; x < 3; x++) {
      if (p->normal[x] > 0)
	corner[x] = hull_size[hullNum][1][x];
      else if (p->normal[x] < 0)
	corner[x] = hull_size[hullNum][0][x];
    }
    p->dist += DotProduct(corner, p->normal);
  }

  /* add any axis planes not contained in the brush to bevel off corners */
  for (x = 0; x < 3; x++)
    for (s = -1; s <= 1; s += 2) {
      /* add the plane */
      VectorClear(plane.normal);
      plane.normal[x] = s;
      if (s == -1)
	plane.dist = -brush_mins[x] + -hull_size[hullNum][0][x];
      else
	plane.dist = brush_maxs[x] + hull_size[hullNum][1][x];
      AddBrushPlane(mapMem, &plane);
    }

  /* add all of the edge bevels */
  for (f = brush_faces; f; f = f->next)
    for (i = 0; i < f->numpoints; i++)
      AddHullEdge(mapMem, f->pts[i], f->pts[(i + 1) % f->numpoints], hullNum);
}

/*============================================================================ */

/*
 * ===============
 * LoadBrush
 * 
 * Converts a mapbrush to a bsp brush
 * ===============
 */
staticfnc struct brush *LoadBrush(bspBase bspMem, mapBase mapMem, register struct mbrush *mb, register int hullNum, bool worldModel)
{
  struct brush *b;
  int contents;
  char *name;
  struct mface *f;

  /* check texture name for attributes */
  name = mapMem->maptexstrings[bspMem->shared.quake1.texinfo[mb->faces->texinfo].miptex];	/* TODO: move to libqtools/map.c, put contents into mbrush */

  if (isClip(name) && hullNum == 0) {
    return NULL;						/* CLIP_MIPMAP brushes don't show up in the draw hull */
  }

  if (isWarp(name) && worldModel) {				/* mapMem->mapentities never use water merging */
    if (name[1] == 'l')						/* l for lava as LAVA */
      contents = CONTENTS_LAVA;
    else if (name[1] == 's')					/* s for slime as SLIME */
      contents = CONTENTS_SLIME;
    else
      contents = CONTENTS_WATER;
  }
  else if (isSky(name) && worldModel && hullNum == 0)
    contents = CONTENTS_SKY;
  else
    contents = CONTENTS_SOLID;

  /* no seperate textures on clip hull */
  if (hullNum && contents != CONTENTS_SOLID && contents != CONTENTS_SKY) {
    return NULL;						/* water brushes don't show up in clipping hulls */
  }

  /* create the faces */
  brush_faces = NULL;

  mapMem->numbrushfaces = 0;
  for (f = mb->faces; f; f = f->next) {
    mapMem->brushfaces[mapMem->numbrushfaces] = *f;
    if (hullNum)
      mapMem->brushfaces[mapMem->numbrushfaces].texinfo = 0;
    mapMem->numbrushfaces++;
  }

  CreateBrushFaces(mapMem);

  if (!brush_faces) {
    eprintf("couldn't create brush faces\n");
    return NULL;
  }

  if (hullNum) {
    ExpandBrush(mapMem, hullNum);
    CreateBrushFaces(mapMem);
  }

  /* create the brush */
  b = AllocBrush();

  b->contents = contents;
  b->faces = brush_faces;
  VectorCopy(brush_mins, b->mins);
  VectorCopy(brush_maxs, b->maxs);

  return b;
}

/*============================================================================= */

/*
 * ============
 * Brush_DrawAll
 * 
 * ============
 */
staticfnc void Brush_DrawAll(register struct brushset *bs)
{
  struct brush *b;
  struct visfacet *f;

  for (b = bs->brushes; b; b = b->next)
    for (f = b->faces; f; f = f->next)
      Draw_DrawFace(f);
}

#if 0
/*
 * added by Niels
 */
staticfnc struct mbrush *FreeBrush(register struct mbrush *mbr)
{
  struct mbrush *mn = mbr->next;
  struct mface *mf = mbr->faces;

  tfree(mbr);
  while (mf) {
    struct mface *mfn = mf->next;

    tfree(mf);
    mf = mfn;
  }
  return mn;
}
#endif

/*
 * ============
 * Brush_LoadEntity
 * ============
 */
struct brushset *Brush_LoadEntity(bspBase bspMem, mapBase mapMem, struct entity *ent, int hullNum, bool worldModel)
{
  struct brush *b, *next, *water, *other;
  struct mbrush *mbr;
  int numbrushes, numbrushesp, i;
  struct brushset *bset;

  if (!(bset = (struct brushset *)tmalloc(sizeof(struct brushset))))
    Error(failed_memoryunsize, "brushset");

  ClearBounds(bset);

  numbrushes = 0;
  numbrushesp = 0;
  other = water = NULL;

  mprintf("----- BrushLoadEntity ---\n");

  CurrentEntity = ent;

  /* added by niels "mbr = FreeBrush(mbr)" */
  for (mbr = ent->brushes; mbr; mbr = mbr->next)
    numbrushesp++;

  for (mbr = ent->brushes, i = 0; mbr; mbr = mbr->next, i++) {
    if ((b = LoadBrush(bspMem, mapMem, mbr, hullNum, worldModel))) {
      numbrushes++;

      if (b->contents != CONTENTS_SOLID) {
	b->next = water;
	water = b;
      }
      else {
	b->next = other;
	other = b;
      }

      AddToBounds(bset, b->mins);
      AddToBounds(bset, b->maxs);
    }
    mprogress(numbrushesp, i + 1);
  }

  /* add all of the water textures at the start */
  for (b = water; b; b = next) {
    next = b->next;
    b->next = other;
    other = b;
  }

  bset->brushes = other;
  /* PROGRESS-ONLY! */
  bset->numbrushes = numbrushes;

  brushset = bset;
  Brush_DrawAll(bset);

  mprintf("%5i brushes read\n", numbrushes);

  return bset;
}
