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

staticvar int c_bad;
struct tnode *tnodes, *tnode_p;
staticvar bool *nolightface;
staticvar vec1D *minlights;
staticvar vec1D rangescale = 0.5;
staticvar vec1D scalecos = 0.5;
staticvar vec1D scaledist = 1.0;
int bspfileface;						/* next surface to dispatch */
vec3D *faceoffset;
staticvar vec3D bsp_origin;

/*
 * ==============================================================================
 * 
 * LINE TRACING
 * 
 * The major lighting operation is a point to point visibility test, performed
 * by recursive subdivision of the line by the BSP tree.
 * 
 * ==============================================================================
 */

staticfnc bool TestLine(vec3D start, vec3D stop)
{
  int node;
  vec1D front, back;
  tracestack_t *tstack_p;
  int side;
  vec1D frontx, fronty, frontz, backx, backy, backz;
  tracestack_t tracestack[64];
  struct tnode *tnode;

  frontx = start[0];
  fronty = start[1];
  frontz = start[2];
  backx = stop[0];
  backy = stop[1];
  backz = stop[2];

  tstack_p = tracestack;
  node = 0;

  while (1) {
    while (node < 0 && node != CONTENTS_SOLID) {
      /* pop up the stack for a back side */
      tstack_p--;
      if (tstack_p < tracestack)
	return TRUE;
      node = tstack_p->node;

      /* set the hit point for this plane */

      frontx = backx;
      fronty = backy;
      frontz = backz;

      /* go down the back side */

      backx = tstack_p->backpt[0];
      backy = tstack_p->backpt[1];
      backz = tstack_p->backpt[2];

      node = tnodes[tstack_p->node].children[!tstack_p->side];
    }

    if (node == CONTENTS_SOLID)
      return FALSE;						/* DONE! */

    tnode = &tnodes[node];

    switch (tnode->type) {
      case PLANE_X:
	front = frontx - tnode->dist;
	back = backx - tnode->dist;
	break;
      case PLANE_Y:
	front = fronty - tnode->dist;
	back = backy - tnode->dist;
	break;
      case PLANE_Z:
	front = frontz - tnode->dist;
	back = backz - tnode->dist;
	break;
      default:
	front = (frontx * tnode->normal[0] + fronty * tnode->normal[1] + frontz * tnode->normal[2]) - tnode->dist;
	back = (backx * tnode->normal[0] + backy * tnode->normal[1] + backz * tnode->normal[2]) - tnode->dist;
	break;
    }

    if (front > -ON_EPSILON && back > -ON_EPSILON) {
      node = tnode->children[0];
      continue;
    }

    if (front < ON_EPSILON && back < ON_EPSILON) {
      node = tnode->children[1];
      continue;
    }

    side = front < 0;

    front = front / (front - back);

    tstack_p->node = node;
    tstack_p->side = side;
    tstack_p->backpt[0] = backx;
    tstack_p->backpt[1] = backy;
    tstack_p->backpt[2] = backz;

    tstack_p++;

    backx = frontx + front * (backx - frontx);
    backy = fronty + front * (backy - fronty);
    backz = frontz + front * (backz - frontz);

    node = tnode->children[side];
  }
}

/*
 * ============
 * CastRay
 * 
 * Returns the distance between the points, or -1 if blocked
 * =============
 */
staticfnc vec1D CastRay(register vec3D p1, register vec3D p2)
{
  short int i;
  vec1D t;

  if (!TestLine(p1, p2))
    return -1;							/* ray was blocked */

  t = 0;
  for (i = 0; i < 3; i++)
    t += (p2[i] - p1[i]) * (p2[i] - p1[i]);

  if (t == 0)
    t = 1;							/* don't blow up... */

  return sqrt(t);
}

/*
 * ===================================================================
 * 
 * TRANSFER SCALES
 * 
 * ===================================================================
 */

/*
 * ==============
 * MakeTnode
 * 
 * Converts the disk node structure into the efficient tracing structure
 * ==============
 */
staticfnc void MakeTnode(bspBase bspMem, register int nodenum)
{
  struct tnode *t;
  struct dplane_t *plane;
  short int i;
  struct dnode_t *node;

  t = tnode_p++;

  node = bspMem->shared.quake1.dnodes + nodenum;
  plane = bspMem->shared.quake1.dplanes + node->planenum;

  t->type = plane->type;
  VectorCopy(plane->normal, t->normal);
  t->dist = plane->dist;

  for (i = 0; i < 2; i++) {
    if (node->children[i] < 0)
      t->children[i] = bspMem->shared.quake1.dleafs[-node->children[i] - 1].contents;
    else {
      t->children[i] = tnode_p - tnodes;
      MakeTnode(bspMem, node->children[i]);
    }
  }

}

/*
 * =============
 * MakeTnodes
 * 
 * Loads the node structure out of a .bsp file to be used for light occlusion
 * =============
 */
staticfnc void MakeTnodes(bspBase bspMem, register struct dmodel_t *bm)
{
  if (!(tnode_p = tnodes = (struct tnode *)kmalloc(bspMem->shared.quake1.numnodes * sizeof(struct tnode))))
      Error(failed_memoryunsize, "tnode");

  MakeTnode(bspMem, 0);
}

/*
 * ===============================================================================
 * 
 * SAMPLE POINT DETERMINATION
 * 
 * void SetupBlock (dface_t *f) Returns with surfpt[] set
 * 
 * This is a little tricky because the lightmap covers more area than the face.
 * If done in the straightforward fashion, some of the
 * sample points will be inside walls or on the other side of walls, causing
 * FALSE shadows and light bleeds.
 * 
 * To solve this, I only consider a sample point valid if a line can be drawn
 * between it and the exact midpoint of the face.  If invalid, it is adjusted
 * towards the center until it is valid.
 * 
 * (this doesn't completely work)
 * 
 * ===============================================================================
 */

/*
 * ================
 * CalcFaceVectors
 * 
 * Fills in texorg, worldtotex. and textoworld
 * ================
 */
void CalcFaceVectors(bspBase bspMem, register struct lightinfo *l)
{
  struct texinfo *tex;
  short int i, j;
  vec3D texnormal;
  vec1D distscale;
  vec1D dist, len;

  tex = &bspMem->shared.quake1.texinfo[l->face->texinfo];

  /* convert from vec1D to vec1D */
  for (i = 0; i < 2; i++)
    for (j = 0; j < 3; j++)
      l->worldtotex[i][j] = tex->vecs[i][j];

  /*
   * calculate a normal to the texture axis.  points can be moved along this
   * without changing their S/T
   */
  texnormal[0] = tex->vecs[1][1] * tex->vecs[0][2] - tex->vecs[1][2] * tex->vecs[0][1];
  texnormal[1] = tex->vecs[1][2] * tex->vecs[0][0] - tex->vecs[1][0] * tex->vecs[0][2];
  texnormal[2] = tex->vecs[1][0] * tex->vecs[0][1] - tex->vecs[1][1] * tex->vecs[0][0];
  VectorNormalize(texnormal);

  /* flip it towards plane normal */
  distscale = DotProduct(texnormal, l->facenormal);
  if (!distscale)
    Error("Texture axis perpendicular to face\n"
	  "Face point at ( " VEC_CONV3D " )\n",
	  bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[l->face->firstedge].v[0]].point[0],
	  bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[l->face->firstedge].v[0]].point[1],
	  bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[l->face->firstedge].v[0]].point[2]);
  if (distscale < 0) {
    distscale = -distscale;
    VectorNegate(texnormal);
  }

  /*
   * distscale is the ratio of the distance along the texture normal to
   * the distance along the plane normal
   */
  distscale = 1 / distscale;

  for (i = 0; i < 2; i++) {
    len = VectorLength(l->worldtotex[i]);
    dist = DotProduct(l->worldtotex[i], l->facenormal);
    dist *= distscale;
    VectorMA(l->worldtotex[i], -dist, texnormal, l->textoworld[i]);
    VectorScale(l->textoworld[i], (1 / len) * (1 / len), l->textoworld[i]);
  }

  /* calculate texorg on the texture plane */
  for (i = 0; i < 3; i++)
    l->texorg[i] = -tex->vecs[0][3] * l->textoworld[0][i] - tex->vecs[1][3] * l->textoworld[1][i];

  /* project back to the face plane */
  dist = DotProduct(l->texorg, l->facenormal) - l->facedist - 1;
  dist *= distscale;
  VectorMA(l->texorg, -dist, texnormal, l->texorg);

}

/*
 * ================
 * CalcFaceExtents
 * 
 * Fills in s->texmins[] and s->texsize[]
 * also sets exactmins[] and exactmaxs[]
 * ================
 */
staticfnc void CalcFaceExtents(bspBase bspMem, register struct lightinfo *l, register vec3D faceoffset)
{
  struct dface_t *s;
  vec1D mins[2], maxs[2], val;
  int i, e;
  short int j;
  struct dvertex_t *v;
  struct texinfo *tex;

  s = l->face;

  mins[0] = mins[1] = VEC_POSMAX;
  maxs[0] = maxs[1] = VEC_NEGMAX;

  tex = &bspMem->shared.quake1.texinfo[s->texinfo];

  for (i = 0; i < s->numedges; i++) {
    e = bspMem->shared.quake1.dsurfedges[s->firstedge + i];
    if (e >= 0)
      v = bspMem->shared.quake1.dvertexes + bspMem->shared.quake1.dedges[e].v[0];
    else
      v = bspMem->shared.quake1.dvertexes + bspMem->shared.quake1.dedges[-e].v[1];

    for (j = 0; j < 2; j++) {
      val = (v->point[0] + faceoffset[0]) * tex->vecs[j][0] +
	(v->point[1] + faceoffset[1]) * tex->vecs[j][1] +
	(v->point[2] + faceoffset[2]) * tex->vecs[j][2] +
	tex->vecs[j][3];
      if (val < mins[j])
	mins[j] = val;
      if (val > maxs[j])
	maxs[j] = val;
    }
  }

  for (i = 0; i < 2; i++) {
    l->exactmins[i] = mins[i];
    l->exactmaxs[i] = maxs[i];

    mins[i] = floor(mins[i] / 16);
    maxs[i] = ceil(maxs[i] / 16);

    l->texmins[i] = mins[i];
    l->texsize[i] = maxs[i] - mins[i];
    if (l->texsize[i] > 17)
      Error("Bad surface extents\n");
  }
}

/*
 * =================
 * CalcPoints
 * 
 * For each texture aligned grid point, back project onto the plane
 * to get the world xyz value of the sample point
 * =================
 */
void CalcPoints(bspBase bspMem, struct lightinfo *l, register vec1D sofs, register vec1D tofs)
{
  int s, t;
  short int i, j;
  int w, h, step;
  vec1D starts, startt, us, ut;
  vec1D *surf;
  vec1D mids, midt;
  vec3D facemid, move;

  /*
   * fill in surforg
   * the points are biased towards the center of the surface
   * to help avoid edge cases just inside walls
   */
  surf = l->surfpt[0];
  mids = (l->exactmaxs[0] + l->exactmins[0]) / 2;
  midt = (l->exactmaxs[1] + l->exactmins[1]) / 2;

  for (j = 0; j < 3; j++)
    facemid[j] = l->texorg[j] + l->textoworld[0][j] * mids + l->textoworld[1][j] * midt;

  if ((bspMem->litOptions & LIGHT_EXTRA) && !(bspMem->litOptions & LIGHT_RADIOSITY)) {	/* extra filtering */
    h = (l->texsize[1] + 1) * 2;
    w = (l->texsize[0] + 1) * 2;
    starts = (l->texmins[0] - 0.5) * 16;
    startt = (l->texmins[1] - 0.5) * 16;
    step = 8;
  }
  else {
    h = l->texsize[1] + 1;
    w = l->texsize[0] + 1;
    starts = l->texmins[0] * 16;
    startt = l->texmins[1] * 16;
    step = 16;
  }

  l->numsurfpt = w * h;
  for (t = 0; t < h; t++) {
    for (s = 0; s < w; s++, surf += 3) {
      us = starts + ((s + sofs) * step);
      ut = startt + ((t + tofs) * step);

      /* if a line can be traced from surf to facemid, the point is good */
      for (i = 0; i < 6; i++) {
	/* calculate texture point */
	for (j = 0; j < 3; j++)
	  surf[j] = l->texorg[j] + l->textoworld[0][j] * us + l->textoworld[1][j] * ut;

	if (TestLine(facemid, surf))
	  break;						/* got it */

	if (i & 1) {
	  if (us > mids) {
	    us -= 8;
	    if (us < mids)
	      us = mids;
	  }
	  else {
	    us += 8;
	    if (us > mids)
	      us = mids;
	  }
	}
	else {
	  if (ut > midt) {
	    ut -= 8;
	    if (ut < midt)
	      ut = midt;
	  }
	  else {
	    ut += 8;
	    if (ut > midt)
	      ut = midt;
	  }
	}

	/* move surf 8 pixels towards the center */
	VectorSubtract(facemid, surf, move);
	VectorNormalize(move);
	VectorMA(surf, 8, move, surf);
      }
      if (i == 2)
	c_bad++;
    }
  }

}

/*
 * ===============================================================================
 * 
 * FACE LIGHTING
 * 
 * ===============================================================================
 */

staticvar int c_culldistplane, c_proper;

/*
 * ================
 * SingleLightFace
 * ================
 */
void SingleLightFace(register struct entity *light, register struct lightinfo *l, register vec3D faceoffset)
{
  vec1D dist;
  vec3D incoming;
  vec1D angle;
  vec1D add;
  vec1D *surf;
  bool hit;
  int mapnum;
  int size;
  int c, i;
  vec3D rel;
  vec3D spotvec;
  vec1D falloff;
  vec1D *lightsamp;

  VectorSubtract(light->origin, bsp_origin, rel);
  /* VectorSubtract (rel, faceoffset, rel); */
  dist = scaledist * light->scaledist * (DotProduct(rel, l->facenormal) - l->facedist);

  /* don't bother with lights behind the surface */
  if (dist <= 0)
    return;

  /* don't bother with light too far away */
  if (dist > light->light) {
    c_culldistplane++;
    return;
  }

  if (light->targetent) {
    VectorSubtract(light->targetent->origin, light->origin, spotvec);
    VectorNormalize(spotvec);
    if (!light->angle)
      falloff = -cos(20 * Q_PI / 180);
    else
      falloff = -cos(light->angle / 2 * Q_PI / 180);
  }
  else if (light->targetmangle[2]) {
    spotvec[0] = cos(light->targetmangle[0] * Q_PI / 180) * (spotvec[1] = cos(light->targetmangle[1] * Q_PI / 180));
    spotvec[1] *= sin(light->targetmangle[0] * Q_PI / 180);
    spotvec[2] = sin(light->targetmangle[1] * Q_PI / 180);
    VectorNormalize (spotvec);
    if (!light->angle)
      falloff = -cos(20 * Q_PI / 180);	
    else
      falloff = -cos(light->angle / 2 * Q_PI / 180);
  }
  else
    falloff = 0;						/* shut up compiler warnings */

  mapnum = 0;
  for (mapnum = 0; mapnum < l->numlightstyles; mapnum++)
    if (l->lightstyles[mapnum] == light->style)
      break;
  lightsamp = l->lightmaps[mapnum];
  if (mapnum == l->numlightstyles) {				/* init a new light map */
    if (mapnum >= MAXLIGHTMAPS) {
      eprintf("Too many light styles on a face\n");
      return;
    }
    size = (l->texsize[1] + 1) * (l->texsize[0] + 1);
    for (i = 0; i < size; i++)
      lightsamp[i] = 0;
  }

  /* check it for real */
  hit = FALSE;
  c_proper++;

  surf = l->surfpt[0];
  for (c = 0; c < l->numsurfpt; c++, surf += 3) {
    if ((dist = CastRay(light->origin, surf) * scaledist * light->scaledist) < 0)
      continue;							/* light doesn't reach */

    VectorSubtract(light->origin, surf, incoming);
    VectorNormalize(incoming);
    angle = DotProduct(incoming, l->facenormal);
    if (light->targetent || light->targetmangle[2]) {		/* spotlight cutoff */
      if (DotProduct(spotvec, incoming) > falloff)
	continue;
    }

    angle = (1.0 - scalecos) + scalecos * angle;
    add = light->light - dist;
    add *= angle;
    if (add < 0)
      continue;
    lightsamp[c] += add;
    if (lightsamp[c] > 1)					/* ignore real tiny lights */
      hit = TRUE;
  }

  if (mapnum == l->numlightstyles && hit) {
    l->lightstyles[mapnum] = light->style;
    l->numlightstyles++;					/* the style has some real data now */
  }
}

/*
 * ============
 * FixMinlight
 * ============
 */
staticfnc void FixMinlight(register struct lightinfo *l)
{
  int i, j;
  vec1D minlight;

  minlight = minlights[l->surfnum];

  /* if minlight is set, there must be a style 0 light map */
  if (!minlight)
    return;

  for (i = 0; i < l->numlightstyles; i++) {
    if (l->lightstyles[i] == 0)
      break;
  }
  if (i == l->numlightstyles) {
    if (l->numlightstyles >= MAXLIGHTMAPS)
      return;							/* oh well.. */

    for (j = 0; j < l->numsurfpt; j++)
      l->lightmaps[i][j] = minlight;
    l->lightstyles[i] = 0;
    l->numlightstyles++;
  }
  else {
    for (j = 0; j < l->numsurfpt; j++)
      if (l->lightmaps[i][j] < minlight)
	l->lightmaps[i][j] = minlight;
  }
}

staticfnc unsigned char *GetFileSpace(bspBase bspMem, register int size)
{
  unsigned char *ret;

  size = ((size + 3) & ~3);
  if (bspMem->shared.quake1.lightdatasize + size >= bspMem->shared.quake1.max_lightdatasize)
    ExpandBSPClusters(bspMem, LUMP_LIGHTING);
  ret = bspMem->shared.quake1.dlightdata + bspMem->shared.quake1.lightdatasize;
  bspMem->shared.quake1.lightdatasize += size;

  return ret;
}

/*
 * ============
 * LightFace
 * ============
 */
staticfnc void LightFace(bspBase bspMem, mapBase mapMem, register int facenum, register bool nolight, register vec3D faceoffset)
{
  struct dface_t *f;
  struct lightinfo l;
  int s, t;
  short int i, j, c;
  vec1D total;
  int size;
  int lightmapwidth, lightmapsize;
  unsigned char *out;
  vec1D *light;
  int w, h;
  vec3D point;

  f = bspMem->shared.quake1.dfaces + facenum;

  /* some surfaces don't need lightmaps */
  f->lightofs = -1;
  for (j = 0; j < MAXLIGHTMAPS; j++)
    f->styles[j] = 255;

  if ((bspMem->shared.quake1.texinfo[f->texinfo].flags & TEX_SPECIAL)) {	/* non-lit texture */
    if (bspMem->litOptions & LIGHT_WATERLIT) {
      int *textures = (int *)(bspMem->shared.quake1.dtexdata + 4);
      struct mipmap *tex = (struct mipmap *)(bspMem->shared.quake1.dtexdata + textures[bspMem->shared.quake1.texinfo[f->texinfo].miptex]);

      if (isSky(tex->name))
	return;
    }
    else
      return;
  }
  __bzero(&l, sizeof(l));
  l.surfnum = facenum;
  l.face = f;

  /* rotate plane */
  VectorCopy(bspMem->shared.quake1.dplanes[f->planenum].normal, l.facenormal);
  l.facedist = bspMem->shared.quake1.dplanes[f->planenum].dist;
  VectorScale(l.facenormal, l.facedist, point);
  VectorAdd(point, faceoffset, point);
  l.facedist = DotProduct(point, l.facenormal);

  if (f->side) {
    VectorNegate(l.facenormal);
    l.facedist = -l.facedist;
  }

  CalcFaceVectors(bspMem, &l);
  CalcFaceExtents(bspMem, &l, faceoffset);
  CalcPoints(bspMem, &l, 0, 0);

  lightmapwidth = l.texsize[0] + 1;
  size = lightmapwidth * (l.texsize[1] + 1);
  if (size > SINGLEMAP)
    Error("Bad lightmap size");

  for (i = 0; i < MAXLIGHTMAPS; i++)
    l.lightstyles[i] = 255;

  /* cast all lights */
#if 0
  if (nolight) {
    vec1D value;

    l.numlightstyles = 1;
    l.lightstyles[0] = 0;
    value = 300 + 40 * l.facenormal[0] - 50 * l.facenormal[1] +
      60 * l.facenormal[2];
    for (i = 0; i < l.numsurfpt; i++)
      l.lightmaps[0][i] = value;
  }
  else {
#endif
    l.numlightstyles = 0;
    for (i = 0; i < mapMem->nummapentities; i++) {
      if (mapMem->mapentities[i].light)
	SingleLightFace(&mapMem->mapentities[i], &l, faceoffset);
    }
    FixMinlight(&l);
    if (!l.numlightstyles)					/* no light hitting it */
      return;
#if 0
  }
#endif

  /* save out the values */
  for (i = 0; i < MAXLIGHTMAPS; i++)
    f->styles[i] = l.lightstyles[i];

  lightmapsize = size * l.numlightstyles;
  f->lightofs = bspMem->shared.quake1.lightdatasize;
  out = GetFileSpace(bspMem, lightmapsize);

  /* extra filtering */
  h = (l.texsize[1] + 1) * 2;
  w = (l.texsize[0] + 1) * 2;

  for (i = 0; i < l.numlightstyles; i++) {
    if (l.lightstyles[i] == 0xff)
      Error("Wrote empty lightmap");
    light = l.lightmaps[i];
    c = 0;
    for (t = 0; t <= l.texsize[1]; t++)
      for (s = 0; s <= l.texsize[0]; s++, c++) {
	if (bspMem->litOptions & LIGHT_EXTRA) {			/* filtered sample */
	  total = light[t * 2 * w + s * 2] +
	    light[t * 2 * w + s * 2 + 1] +
	    light[(t * 2 + 1) * w + s * 2] +
	    light[(t * 2 + 1) * w + s * 2 + 1];
	  total *= 0.25;
	}
	else
	  total = light[c];
	total *= rangescale;					/* scale before clamping */

	if (total > 255)
	  total = 255;
	if (total < 0)
	  Error("light < 0");
	*out++ = total;
      }
  }
}

staticfnc void FindFaceOffsets(bspBase bspMem, mapBase mapMem)
{
  int i, j;
  struct entity *ent;
  struct dmodel_t *mod;

  for (j = bspMem->shared.quake1.dmodels[0].firstface; j < bspMem->shared.quake1.dmodels[0].numfaces; j++) {
    nolightface[j] = FALSE;
  }
  for (i = 1; i < bspMem->shared.quake1.nummodels; i++) {
    mod = &bspMem->shared.quake1.dmodels[i];
    ent = FindEntityWithModel(mapMem, i);

    if (!__strncmp(ent->classname, "rotate_", 7)) {
      int start = mod->firstface;
      int end = start + mod->numfaces;

      for (j = start; j < end; j++) {
	nolightface[j] = TRUE;
	VectorCopy(ent->origin, faceoffset[j]);
      }
    }
  }
}

/*
 * =============
 * LightWorld
 * =============
 */
staticfnc void LightWorld(bspBase bspMem, mapBase mapMem)
{
  int i;

  FindFaceOffsets(bspMem, mapMem);
  for (i = 0; i < bspMem->shared.quake1.numfaces; i++, bspfileface++) {
    LightFace(bspMem, mapMem, i, nolightface[i], faceoffset[i]);
    mprogress(bspMem->shared.quake1.numfaces, i + 1);
  }
}

bool light(bspBase bspMem, mapBase mapMem, vec1D scale, vec1D range)
{
  mprintf("----- LightFaces --------\n");

  if (scale)
    scaledist = scale;
  if (range)
    rangescale = range;

  AllocBSPClusters(bspMem, LUMP_LIGHTING);

  if (!(minlights = (vec1D *)kmalloc(sizeof(vec1D) * bspMem->shared.quake1.numfaces)))
    Error(failed_memoryunsize, "minlights");

  if (!(nolightface = (bool *) kmalloc(sizeof(bool) * bspMem->shared.quake1.numfaces)))
    Error(failed_memoryunsize, "nolightfaces");
  if (!(faceoffset = (vec3D *) kmalloc(sizeof(vec3D) * bspMem->shared.quake1.numfaces)))
    Error(failed_memoryunsize, "faceoffsets");

  if (bspMem->litOptions & LIGHT_RADIOSITY) {
    if (!(facepatches = (struct patch **)kmalloc(sizeof(struct patch *) * bspMem->shared.quake1.numfaces)))
      Error(failed_memoryunsize, "facepatches");
    if (!(faceentity = (struct entity **)kmalloc(sizeof(struct entity *) * bspMem->shared.quake1.numfaces)))
      Error(failed_memoryunsize, "facentities");
    if (!(facelights = (struct facelight *)kmalloc(sizeof(struct entity *) * bspMem->shared.quake1.numfaces)))
      Error(failed_memoryunsize, "facelights");
    if (!(patches = (struct patch *)kmalloc(sizeof(struct patch) * 4096)))
      Error(failed_memoryunsize, "patches");

    if (!(radiosity = (vec3D *) kmalloc(sizeof(vec3D) * bspMem->shared.quake1.numfaces)))
      Error(failed_memoryunsize, "radiosity");
    if (!(illumination = (vec3D *) kmalloc(sizeof(vec3D) * bspMem->shared.quake1.numfaces)))
      Error(failed_memoryunsize, "illumination");
    if (!(backplanes = (struct dplane_t *)kmalloc(sizeof(struct dplane_t) * bspMem->shared.quake1.numplanes)))
      Error(failed_memoryunsize, "backplanes");
    if (!(directlights = (struct directlight **)kmalloc(sizeof(struct directlight *) * bspMem->shared.quake1.numleafs)))
      Error(failed_memoryunsize, "directlights");
    if (!(leafparents = (int *)kmalloc(sizeof(int) * bspMem->shared.quake1.numleafs)))
      Error(failed_memoryunsize, "leafparents");
    if (!(nodeparents = (int *)kmalloc(sizeof(int) * bspMem->shared.quake1.numnodes)))
      Error(failed_memoryunsize, "nodeparents");

    if (!(texreflectivity = (vec3D *) kmalloc(sizeof(vec3D) * bspMem->shared.quake1.numtexinfo)))
      Error(failed_memoryunsize, "texture reflectivity");
  }

  if (!(bspMem->litOptions & LIGHT_MEM)) {
    if(!(mapMem = kmalloc(sizeof(struct mapmemory))))
      Error(failed_memoryunsize, "map");
  
    mapMem->mapOptions |= MAP_LOADLIGHTS;
    LoadMapFile(bspMem, mapMem, bspMem->shared.quake1.dentdata);
  }

  MakeTnodes(bspMem, &bspMem->shared.quake1.dmodels[0]);

  if (bspMem->litOptions & LIGHT_RADIOSITY)
    RadWorld(bspMem, mapMem);
  else
    LightWorld(bspMem, mapMem);

  WriteEntitiesToString(bspMem, mapMem);
  kfree();

  return TRUE;
}
