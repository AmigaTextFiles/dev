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

vec3D *texreflectivity;
vec3D *radiosity;
vec3D *illumination;
struct patch **facepatches;
struct entity **faceentity;
struct patch *patches;
int numpatches = 0;
struct dplane_t *backplanes;
int fakeplanes;
int *leafparents;
int *nodeparents;
vec1D subdiv = 64;
struct directlight **directlights;
struct facelight *facelights;
int numdlights = 0;
int numbounce = 8;
bool dumppatches;
int junk;
vec1D ambient = 0;
vec1D maxlight = 196;
vec1D lightscale = 1.0;
vec1D direct_scale = 0.4;
vec1D entity_scale = 1.0;

extern struct tnode *tnodes, *tnode_p;
staticfnc int TestLine_r(register int node, vec3D start, vec3D stop)
{
  struct tnode *tnode;
  vec1D front, back;
  vec3D mid;
  vec1D frac;
  int side;
  int r;

  if (node & (1 << 31))
    return node & ~(1 << 31);					/* leaf node */

  tnode = &tnodes[node];
  switch (tnode->type) {
    case PLANE_X:
      front = start[0] - tnode->dist;
      back = stop[0] - tnode->dist;
      break;
    case PLANE_Y:
      front = start[1] - tnode->dist;
      back = stop[1] - tnode->dist;
      break;
    case PLANE_Z:
      front = start[2] - tnode->dist;
      back = stop[2] - tnode->dist;
      break;
    default:
      front = DotProduct(start, tnode->normal) - tnode->dist;
      back = DotProduct(stop, tnode->normal) - tnode->dist;
      /*
       * front = (start[0] * tnode->normal[0] + start[1] * tnode->normal[1] + start[2] * tnode->normal[2]) - tnode->dist;
       * back = (stop[0] * tnode->normal[0] + stop[1] * tnode->normal[1] + stop[2] * tnode->normal[2]) - tnode->dist;
       */
      break;
  }

  if (front >= -ON_EPSILON && back >= -ON_EPSILON)
    return TestLine_r(tnode->children[0], start, stop);

  if (front < ON_EPSILON && back < ON_EPSILON)
    return TestLine_r(tnode->children[1], start, stop);

  side = front < 0;

  frac = front / (front - back);

  mid[0] = start[0] + (stop[0] - start[0]) * frac;
  mid[1] = start[1] + (stop[1] - start[1]) * frac;
  mid[2] = start[2] + (stop[2] - start[2]) * frac;

  if ((r = TestLine_r(tnode->children[side], start, mid)))
    return r;
  else
    return TestLine_r(tnode->children[!side], mid, stop);
}

/*
 * =============
 * CollectLight
 * =============
 */
staticfnc vec1D CollectLight(void)
{
  int i, j;
  struct patch *patch;
  vec1D total;

  total = 0;

  for (i = 0, patch = patches; i < numpatches; i++, patch++) {
    /* skys never collect light, it is just dropped */
    if (patch->sky) {
      VectorClear(radiosity[i]);
      VectorClear(illumination[i]);
      continue;
    }

    for (j = 0; j < 3; j++) {
      patch->totallight[j] += illumination[i][j] / patch->area;
      radiosity[i][j] = illumination[i][j] * patch->reflectivity[j];
    }

    total += radiosity[i][0] + radiosity[i][1] + radiosity[i][2];
    VectorClear(illumination[i]);
  }

  return total;
}

/*
 * =============
 * ShootLight
 * 
 * Send light out to other patches
 * Run multi-threaded
 * =============
 */
staticfnc void ShootLight(register int patchnum)
{
  int k, l;
  struct transfer *trans;
  int num;
  struct patch *patch;
  vec3D send;

  /*
   * this is the amount of light we are distributing
   * prescale it so that multiplying by the 16 bit
   * transfer values gives a proper output value
   */
  for (k = 0; k < 3; k++)
    send[k] = radiosity[patchnum][k] / 0x10000;
  patch = &patches[patchnum];

  trans = patch->transfers;
  num = patch->numtransfers;

  for (k = 0; k < num; k++, trans++) {
    for (l = 0; l < 3; l++)
      illumination[trans->patch][l] += send[l] * trans->transfer;
  }
}

/*
 * =============
 * BounceLight
 * =============
 */
staticfnc void BounceLight(void)
{
  int i, j;
  vec1D added;
  struct patch *p;

  for (i = 0; i < numpatches; i++) {
    p = &patches[i];
    for (j = 0; j < 3; j++) {
/*                      p->totallight[j] = p->samplelight[j]; */
      radiosity[i][j] = p->samplelight[j] * p->reflectivity[j] * p->area;
    }
  }

  for (i = 0; i < numbounce; i++) {
    for (j = 0; j < numpatches; j++)
      ShootLight(j);

    added = CollectLight();
    mprintf("    - bounce %i\n%5i added\n", i, added);
  }
}

staticfnc void ClearLBounds(vec3D mins, vec3D maxs)
{
  mins[0] = mins[1] = mins[2] = VEC_POSMAX;
  maxs[0] = maxs[1] = maxs[2] = VEC_NEGMAX;
}

staticfnc void AddPointToBounds(vec3D v, vec3D mins, vec3D maxs)
{
  int i;
  vec1D val;

  for (i = 0; i < 3; i++) {
    val = v[i];
    if (val < mins[i])
      mins[i] = val;
    if (val > maxs[i])
      maxs[i] = val;
  }
}

/*
 * ===================================================================
 * 
 * TEXTURE LIGHT VALUES
 * 
 * ===================================================================
 */

staticfnc vec1D ColorNormalize(vec3D in, vec3D out)
{
  vec1D max;

  max = in[0];
  if (in[1] > max)
    max = in[1];
  if (in[2] > max)
    max = in[2];

  if (max != 0)
    VectorScale(in, 1.0 / max, out);

  return max;
}

/*
 * ======================
 * CalcTextureReflectivity
 * ======================
 */
staticfnc void CalcTextureReflectivity(bspBase bspMem)
{
  int i, j;
  struct rgb *palette;
  struct dmiptexlump_t *l = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;

  if (!(palette = GetPalette()))
    Error(failed_fileopen, "palette");

  /* allways set index 0 even if no textures */
  texreflectivity[0][0] = 0.5;
  texreflectivity[0][1] = 0.5;
  texreflectivity[0][2] = 0.5;

  for (i = 0; i < bspMem->shared.quake1.numtexinfo; i++) {
    struct texinfo *curtex = &bspMem->shared.quake1.texinfo[i];

    /* see if an earlier texinfo allready got the value */
    for (j = 0; j < i; j++) {
      if (curtex->miptex == bspMem->shared.quake1.texinfo[j].miptex) {
	VectorCopy(texreflectivity[j], texreflectivity[i]);
	break;
      }
    }

    if (j == i) {
      struct mipmap *mt = (struct mipmap *)(l->dataofs[curtex->miptex] + (long int)l);
      int texels = mt->width * mt->height;
      unsigned char texel;
      unsigned char *body = (unsigned char *)mt + mt->offsets[MIPMAP_0];
      int color[3] =
      {0, 0, 0};
      vec1D scale;

      for (j = 0; j < texels; j++) {
	texel = *body++;
	color[0] += palette[texel].r;
	color[1] += palette[texel].g;
	color[2] += palette[texel].b;
      }

      for (j = 0; j < 3; j++) {
	vec1D r = color[j] / texels / 255.0;

	texreflectivity[i][j] = r;
      }

      mprintf("%s has a reflectivity of ( " VEC_CONV3D " )\n", mt->name, texreflectivity[i][0], texreflectivity[i][1], texreflectivity[i][2]);

      /*
       * scale the reflectivity up, because the textures are
       * so dim
       */
      scale = ColorNormalize(texreflectivity[i], texreflectivity[i]);
      if (scale < 0.5) {
	scale *= 2;
	VectorScale(texreflectivity[i], scale, texreflectivity[i]);
      }
    }
  }
}

/*
 * ===================
 * DecompressVis
 * ===================
 */
staticfnc void DecompressVis(bspBase bspMem, register unsigned char *in, register unsigned char *decompressed)
{
  int c;
  int row;
  unsigned char *out;

  row = (bspMem->shared.quake1.numleafs + 7) >> 3;
  out = decompressed;

  do {
    if (*in) {
      *out++ = *in++;
      continue;
    }

    c = in[1];
    in += 2;
    while (c) {
      *out++ = 0;
      c--;
    }
  } while (out - decompressed < row);
}

staticfnc int PointInLeafNum(bspBase bspMem, vec3D point)
{
  int nodenum;
  vec1D dist;
  struct dnode_t *node;
  struct dplane_t *plane;

  nodenum = 0;
  while (nodenum >= 0) {
    node = &bspMem->shared.quake1.dnodes[nodenum];
    plane = &bspMem->shared.quake1.dplanes[node->planenum];
    dist = DotProduct(point, plane->normal) - plane->dist;
    if (dist > 0)
      nodenum = node->children[0];
    else
      nodenum = node->children[1];
  }

  return -nodenum - 1;
}

staticfnc bool PvsForOrigin(bspBase bspMem, vec3D org, register unsigned char *pvs)
{
  if (!bspMem->shared.quake1.visdatasize) {
    __memset(pvs, 255, (bspMem->shared.quake1.numleafs + 7) >> 3);
  }
  else {
    struct dleaf_t *leaf = &bspMem->shared.quake1.dleafs[PointInLeafNum(bspMem, org)];

    DecompressVis(bspMem, bspMem->shared.quake1.dvisdata + leaf->visofs, pvs);
  }

  return TRUE;
}

/*
 * =============
 * MakeBackplanes
 * =============
 */
staticfnc void MakeBackPlanes(bspBase bspMem)
{
  int i;

  for (i = 0; i < bspMem->shared.quake1.numplanes; i++) {
    backplanes[i].dist = -bspMem->shared.quake1.dplanes[i].dist;
    VectorNegateTo(bspMem->shared.quake1.dplanes[i].normal, backplanes[i].normal);
  }
}

/*
 * =============
 * MakeParents
 * =============
 */
staticfnc void MakeParents(bspBase bspMem, register int nodenum, register int parent)
{
  int i, j;
  struct dnode_t *node;

  nodeparents[nodenum] = parent;
  node = &bspMem->shared.quake1.dnodes[nodenum];

  for (i = 0; i < 2; i++) {
    j = node->children[i];
    if (j < 0)
      leafparents[-j - 1] = nodenum;
    else
      MakeParents(bspMem, j, nodenum);
  }
}

/*
 * =============
 * MakePatchForFace
 * =============
 */

staticfnc bool IsSky(bspBase bspMem, register struct dface_t *f)
{
  struct texinfo *tx;
  struct mipmap *mt;
  struct dmiptexlump_t *l = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;

  tx = &bspMem->shared.quake1.texinfo[f->texinfo];
  mt = (struct mipmap *)(l->dataofs[tx->miptex] + (long int)l);
  if (isSky(mt->name))
    return TRUE;
  return FALSE;
}

#define	MAX_PATCHES		4096
staticvar vec1D totalarea;
staticfnc void MakePatchForFace(bspBase bspMem, register int facenum, register struct winding *w)
{
  struct dface_t *f;
  vec1D area;
  struct patch *patch;
  struct dplane_t *pl;
  int i;
  vec3D color;
  struct dleaf_t *leaf;

  f = &bspMem->shared.quake1.dfaces[facenum];

  area = WindingArea(w);
  totalarea += area;

  patch = &patches[numpatches];
  if (numpatches == MAX_PATCHES)
    Error("numpatches == MAX_PATCHES\n");
  patch->next = facepatches[facenum];
  facepatches[facenum] = patch;

  patch->winding = w;

  if (f->side)
    patch->plane = &backplanes[f->planenum];
  else
    patch->plane = &bspMem->shared.quake1.dplanes[f->planenum];
  if (faceoffset[facenum][0] || faceoffset[facenum][1] || faceoffset[facenum][2]) {	/* origin offset faces must create new planes */
    if (bspMem->shared.quake1.numplanes + fakeplanes >= bspMem->shared.quake1.max_numplanes)
      ExpandBSPClusters(bspMem, LUMP_PLANES);
    pl = &bspMem->shared.quake1.dplanes[bspMem->shared.quake1.numplanes + fakeplanes];
    fakeplanes++;

    *pl = *(patch->plane);
    pl->dist += DotProduct(faceoffset[facenum], pl->normal);
    patch->plane = pl;
  }

  WindingCenter(w, patch->origin);
  VectorAdd(patch->origin, patch->plane->normal, patch->origin);
  leaf = &bspMem->shared.quake1.dleafs[PointInLeafNum(bspMem, patch->origin)];
  patch->cluster = leaf->visofs;
  patch->area = area;
  if (patch->area <= 1)
    patch->area = 1;
  patch->sky = IsSky(bspMem, f);

  VectorCopy(texreflectivity[f->texinfo], patch->reflectivity);

  /* non-bmodel patches can emit light */
  if (facenum < bspMem->shared.quake1.dmodels[0].numfaces) {
    VectorClear(patch->baselight);
    ColorNormalize(patch->reflectivity, color);
    for (i = 0; i < 3; i++)
      patch->baselight[i] *= color[i];
    VectorCopy(patch->baselight, patch->totallight);
  }
  numpatches++;
}

/*
 * =============
 * MakePatches
 * =============
 */
staticfnc void MakePatches(bspBase bspMem, mapBase mapMem)
{
  int i, j, k;
  struct dface_t *f;
  int start;
  struct winding *w;
  struct dmodel_t *mod;
  struct entity *ent;

  mprintf("%5i faces\n", bspMem->shared.quake1.numfaces);

  for (i = 0; i < bspMem->shared.quake1.nummodels; i++) {
    mod = &bspMem->shared.quake1.dmodels[i];
    ent = FindEntityWithModel(mapMem, i);
    /*
     * bmodels with origin brushes need to be offset into their
     * in-use position
     */
    start = mod->firstface;
    for (j = start; j < start + mod->numfaces; j++) {
      VectorCopy(ent->origin, faceoffset[j]);
      faceentity[j] = ent;
      f = &bspMem->shared.quake1.dfaces[j];
      w = WindingFromFace(bspMem, f);
      for (k = 0; k < w->numpoints; k++) {
	VectorAdd(w->points[k], ent->origin, w->points[k]);
      }
      MakePatchForFace(bspMem, j, w);
    }
  }

  mprintf("%5i square feet\n", (int)(totalarea / 64));
}

staticfnc void CheckPatches(void)
{
  int i;
  struct patch *patch;

  for (i = 0; i < numpatches; i++) {
    patch = &patches[i];
    if (patch->totallight[0] < 0 || patch->totallight[1] < 0 || patch->totallight[2] < 0)
      Error("negative patch totallight\n");
  }
}

/*
 * =============
 * MakeTransfers
 * 
 * =============
 */
staticvar int total_transfer;
staticfnc void MakeTransfers(bspBase bspMem, register int i)
{
  int j;
  vec3D delta;
  vec1D dist, scale;
  vec1D trans;
  int itrans;
  struct patch *patch, *patch2;
  vec1D total;
  struct dplane_t plane;
  vec3D origin;
  vec1D transfers[MAX_PATCHES], *all_transfers;
  int itotal;
  unsigned char pvs[(MAX_MAP_LEAFS + 7) / 8];
  int cluster;

  patch = patches + i;
  total = 0;

  VectorCopy(patch->origin, origin);
  plane = *patch->plane;

  if (!PvsForOrigin(bspMem, patch->origin, pvs))
    return;

  /*
   * find out which patch2s will collect light
   * from patch
   */
  all_transfers = transfers;
  patch->numtransfers = 0;
  for (j = 0, patch2 = patches; j < numpatches; j++, patch2++) {
    transfers[j] = 0;

    if (j == i)
      continue;

    /* check pvs bit */
    if (!bspMem->shared.quake1.visdatasize) {
      cluster = patch2->cluster;
      if (cluster == -1)
	continue;
      if (!(pvs[cluster >> 3] & (1 << (cluster & 7))))
	continue;						/* not in pvs */
    }

    /* calculate vector */
    VectorSubtract(patch2->origin, origin, delta);
    dist = VectorNormalize(delta);
    if (!dist)
      continue;							/* should never happen */

    /* reletive angles */
    scale = DotProduct(delta, plane.normal);
    scale *= -DotProduct(delta, patch2->plane->normal);
    if (scale <= 0)
      continue;

    /* check exact tramsfer */
    if (TestLine_r(0, patch->origin, patch2->origin))
      continue;

    trans = scale * patch2->area / (dist * dist);

    if (trans < 0)
      trans = 0;						/* rounding errors... */

    transfers[j] = trans;
    if (trans > 0) {
      total += trans;
      patch->numtransfers++;
    }
  }

  /*
   * copy the transfers out and normalize
   * total should be somewhere near PI if everything went right
   * because partial occlusion isn't accounted for, and nearby
   * patches have underestimated form factors, it will usually
   * be higher than PI
   */
  if (patch->numtransfers) {
    struct transfer *t;

    if (patch->numtransfers < 0 || patch->numtransfers > MAX_PATCHES)
      Error("Weird numtransfers\n");
    if (!(patch->transfers = (struct transfer *)tmalloc(patch->numtransfers * sizeof(struct transfer))))
        Error(failed_memoryunsize, "transfer");

    /*
     * normalize all transfers so all of the light
     * is transfered to the surroundings
     */
    t = patch->transfers;
    itotal = 0;
    for (j = 0; j < numpatches; j++) {
      if (transfers[j] <= 0)
	continue;
      itrans = transfers[j] * 0x10000 / total;
      itotal += itrans;
      t->transfer = itrans;
      t->patch = j;
      t++;
    }
  }

  /* don't bother locking around this.  not that important. */
  total_transfer += patch->numtransfers;
}

/*
 * =============
 * FreeTransfers
 * =============
 */
staticfnc void FreeTransfers(void)
{
  int i;

  for (i = 0; i < numpatches; i++) {
    tfree(patches[i].transfers);
    patches[i].transfers = NULL;
  }
}

/*
 * =======================================================================
 * 
 * SUBDIVIDE
 * 
 * =======================================================================
 */

staticfnc void FinishSplit(bspBase bspMem, register struct patch *patch, register struct patch *newp)
{
  struct dleaf_t *leaf;

  VectorCopy(patch->baselight, newp->baselight);
  VectorCopy(patch->totallight, newp->totallight);
  VectorCopy(patch->reflectivity, newp->reflectivity);
  newp->plane = patch->plane;
  newp->sky = patch->sky;

  patch->area = WindingArea(patch->winding);
  newp->area = WindingArea(newp->winding);

  if (patch->area <= 1)
    patch->area = 1;
  if (newp->area <= 1)
    newp->area = 1;

  WindingCenter(patch->winding, patch->origin);
  VectorAdd(patch->origin, patch->plane->normal, patch->origin);
  leaf = &bspMem->shared.quake1.dleafs[PointInLeafNum(bspMem, patch->origin)];
  patch->cluster = leaf->visofs;

  WindingCenter(newp->winding, newp->origin);
  VectorAdd(newp->origin, newp->plane->normal, newp->origin);
  leaf = &bspMem->shared.quake1.dleafs[PointInLeafNum(bspMem, newp->origin)];
  newp->cluster = leaf->visofs;
}

/*
 * =============
 * SubdividePatch
 * 
 * Chops the patch only if its local bounds exceed the max size
 * =============
 */
staticfnc void SubdividePatch(bspBase bspMem, register struct patch *patch)
{
  struct winding *w, *o1, *o2;
  vec3D mins, maxs, total;
  vec3D split;
  vec1D dist;
  int i, j;
  vec1D v;
  struct patch *newp;

  w = patch->winding;
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
  VectorSubtract(maxs, mins, total);
  for (i = 0; i < 3; i++)
    if (total[i] > (subdiv + 1))
      /* no splitting needed */
      return;

  /* split the winding */
  VectorClear(split);
  split[i] = 1;
  dist = (mins[i] + maxs[i]) * 0.5;
  ClipWindingEpsilon(w, split, dist, ON_EPSILON, &o1, &o2);

  /* create a new patch */
  if (numpatches == MAX_PATCHES)
    Error("MAX_PATCHES\n");
  newp = &patches[numpatches];
  numpatches++;

  newp->next = patch->next;
  patch->next = newp;

  patch->winding = o1;
  newp->winding = o2;

  FinishSplit(bspMem, patch, newp);

  SubdividePatch(bspMem, patch);
  SubdividePatch(bspMem, newp);
}

/*
 * =============
 * DicePatch
 * 
 * Chops the patch by a global grid
 * =============
 */
staticfnc void DicePatch(bspBase bspMem, register struct patch *patch)
{
  struct winding *w, *o1, *o2;
  vec3D mins, maxs;
  vec3D split;
  vec1D dist;
  int i;
  struct patch *newp;

  w = patch->winding;
  WindingBounds(w, mins, maxs);
  for (i = 0; i < 3; i++)
    if (floor((mins[i] + 1) / subdiv) < floor((maxs[i] - 1) / subdiv))
      break;
  if (i == 3) {
    /* no splitting needed */
    return;
  }

  /* split the winding */
  VectorClear(split);
  split[i] = 1;
  dist = subdiv * (1 + floor((mins[i] + 1) / subdiv));
  ClipWindingEpsilon(w, split, dist, ON_EPSILON, &o1, &o2);

  /* create a new patch */
  if (numpatches == MAX_PATCHES)
    Error("MAX_PATCHES\n");
  newp = &patches[numpatches];
  numpatches++;

  newp->next = patch->next;
  patch->next = newp;

  patch->winding = o1;
  newp->winding = o2;

  FinishSplit(bspMem, patch, newp);

  DicePatch(bspMem, patch);
  DicePatch(bspMem, newp);
}

/*
 * =============
 * SubdividePatches
 * =============
 */
staticfnc void SubdividePatches(bspBase bspMem)
{
  int i, num;

  if (subdiv < 1)
    return;

  num = numpatches;						/* because the list will grow */

  for (i = 0; i < num; i++)
    /*  SubdividePatch (&patches[i]); */
    DicePatch(bspMem, &patches[i]);

  mprintf("%5i patches after subdivision\n", numpatches);
}

/*
 * ================
 * CalcFaceExtents
 * 
 * Fills in s->texmins[] and s->texsize[]
 * also sets exactmins[] and exactmaxs[]
 * ================
 */
staticfnc void CalcFaceExtentsII(bspBase bspMem, register struct lightinfo *l)
{
  struct dface_t *s;
  vec1D mins[2], maxs[2], val;
  int i, j, e;
  struct dvertex_t *v;
  struct texinfo *tex;
  vec3D vt;

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

/*  VectorAdd (v->point, l->modelorg, vt); */
    VectorCopy(v->point, vt);

    for (j = 0; j < 2; j++) {
      val = DotProduct(vt, tex->vecs[j]) + tex->vecs[j][3];
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

    if (l->texsize[0] * l->texsize[1] > SINGLEMAP / 4)		/* div 4 for extrasamples */
      eprintf("Surface to large to map: %d*%d", l->texsize[0], l->texsize[1]);
  }
}

/*
 * =================================================================
 * 
 * LIGHTMAP SAMPLE GENERATION
 * 
 * =================================================================
 */

#define	ANGLE_UP	-1
#define	ANGLE_DOWN	-2

/*
 * =============
 * CreateDirectLights
 * =============
 */
staticfnc void CreateDirectLights(bspBase bspMem, mapBase mapMem)
{
  int i;
  struct patch *p;
  struct directlight *dl;
  struct dleaf_t *leaf;
  int cluster;
  struct entity *e, *e2;
  vec1D angle;
  char *_color;
  vec1D intensity;

  /* surfaces */
  for (i = 0, p = patches; i < numpatches; i++, p++) {
    if (p->totallight[0] < DIRECT_LIGHT
	&& p->totallight[1] < DIRECT_LIGHT
	&& p->totallight[2] < DIRECT_LIGHT)
      continue;

    if (!(dl = (struct directlight *)tmalloc(sizeof(struct directlight))))
        Error(failed_memoryunsize, "directlight");

    numdlights++;

    VectorCopy(p->origin, dl->origin);

    leaf = &bspMem->shared.quake1.dleafs[PointInLeafNum(bspMem, dl->origin)];
    cluster = leaf->visofs;
    dl->next = directlights[cluster];
    directlights[cluster] = dl;

    dl->type = emit_surface;
    VectorCopy(p->plane->normal, dl->normal);

    dl->intensity = ColorNormalize(p->totallight, dl->color);
    dl->intensity *= p->area * direct_scale;
    VectorClear(p->totallight);					/* all sent now */
  }

  /* entities */
  for (i = 0; i < mapMem->nummapentities; i++) {
    e = &mapMem->mapentities[i];
    if (__strncmp(e->classname, "light", 5))
      continue;

    if (!(dl = (struct directlight *)tmalloc(sizeof(struct directlight))))
        Error(failed_memoryunsize, "directlight");

    numdlights++;

    VectorCopy(e->origin, dl->origin);
    dl->style = e->style;

    leaf = &bspMem->shared.quake1.dleafs[PointInLeafNum(bspMem, dl->origin)];
    cluster = leaf->visofs;
    dl->next = directlights[cluster];
    directlights[cluster] = dl;

    intensity = e->light;
    _color = ValueForKey(e, "_color");
    if (_color && _color[1]) {
      sscanf(_color, VEC_CONV3D, &dl->color[0], &dl->color[1], &dl->color[2]);
      ColorNormalize(dl->color, dl->color);
    }
    else
      dl->color[0] = dl->color[1] = dl->color[2] = 1.0;
    dl->intensity = intensity * entity_scale;
    dl->type = emit_point;

    if (e->target || !__strcmp(e->target, "light_spot")) {
      dl->type = emit_spotlight;
      dl->stopdot = FloatForKey(e, "_cone");
      if (!dl->stopdot)
	dl->stopdot = 10;
      dl->stopdot = cos(dl->stopdot / 180 * 3.14159);
      if (e->target[0]) {					/* point towards target */
	if (!(e2 = e->targetent))
	  eprintf("light at ( " VEC_CONV3D " ) has missing target\n",
		  dl->origin[0], dl->origin[1], dl->origin[2]);
	else {
	  VectorSubtract(e2->origin, dl->origin, dl->normal);
	  VectorNormalize(dl->normal);
	}
      }
      else {							/* point down angle */
	angle = e->angle;
	if (angle == ANGLE_UP) {
	  dl->normal[0] = dl->normal[1] = 0;
	  dl->normal[2] = 1;
	}
	else if (angle == ANGLE_DOWN) {
	  dl->normal[0] = dl->normal[1] = 0;
	  dl->normal[2] = -1;
	}
	else {
	  dl->normal[2] = 0;
	  dl->normal[0] = cos(angle / 180 * 3.14159);
	  dl->normal[1] = sin(angle / 180 * 3.14159);
	}
      }
    }
  }

  mprintf("%5i direct lights\n", numdlights);
}

/*
 * =============
 * AddSampleToPatch
 * 
 * Take the sample's collected light and
 * add it back into the apropriate patch
 * for the radiosity pass.
 * 
 * The sample is added to all patches that might include
 * any part of it.  They are counted and averaged, so it
 * doesn't generate extra light.
 * =============
 */
staticfnc void AddSampleToPatch(vec3D pos, vec3D color, register int facenum)
{
  struct patch *patch;
  vec3D mins, maxs;
  int i;

  if (numbounce == 0)
    return;
  if (color[0] + color[1] + color[2] < 3)
    return;

  for (patch = facepatches[facenum]; patch; patch = patch->next) {
    /* see if the point is in this patch (roughly) */
    WindingBounds(patch->winding, mins, maxs);
    for (i = 0; i < 3; i++) {
      if (mins[i] > pos[i] + 16)
	goto nextpatch;
      if (maxs[i] < pos[i] - 16)
	goto nextpatch;
    }

    /* add the sample to the patch */
    patch->samples++;
    VectorAdd(patch->samplelight, color, patch->samplelight);
  nextpatch:;
  }
}

/*
 * =================================================================
 * 
 * POINT TRIANGULATION
 * 
 * =================================================================
 */

struct edgeshare {
  struct dface_t *faces[2];
  bool coplanar;
};

staticvar int *facelinks;							/*[MAX_MAP_FACES]; */
staticvar int *planelinks[2];						/*[MAX_MAP_PLANES]; */

/*
 * ============
 * LinkPlaneFaces
 * ============
 */
staticfnc void LinkPlaneFaces(bspBase bspMem)
{
  int i;
  struct dface_t *f;

  if (!(facelinks = (int *)kmalloc(bspMem->shared.quake1.numfaces * sizeof(int))))
      Error(failed_memoryunsize, "facelinks");
  if (!(planelinks[0] = (int *)kmalloc(bspMem->shared.quake1.numplanes * sizeof(int))))
      Error(failed_memoryunsize, "planelinks[0]");
  if (!(planelinks[1] = (int *)kmalloc(bspMem->shared.quake1.numplanes * sizeof(int))))
      Error(failed_memoryunsize, "planelinks[1]");

  f = bspMem->shared.quake1.dfaces;
  for (i = 0; i < bspMem->shared.quake1.numfaces; i++, f++) {
    facelinks[i] = planelinks[f->side][f->planenum];
    planelinks[f->side][f->planenum] = i;
  }
}

/*
 * ============
 * PairEdges
 * ============
 */
staticfnc void PairEdges(bspBase bspMem)
{
  int i, j, k;
  struct dface_t *f;
  struct edgeshare *e;
  struct edgeshare *edgeshare;

  if (!(edgeshare = (struct edgeshare *)tmalloc(bspMem->shared.quake1.numedges * sizeof(struct edgeshare))))
      Error(failed_memoryunsize, "edgeshare");

  f = bspMem->shared.quake1.dfaces;
  for (i = 0; i < bspMem->shared.quake1.numfaces; i++, f++) {
    for (j = 0; j < f->numedges; j++) {
      k = bspMem->shared.quake1.dsurfedges[f->firstedge + j];
      if (k < 0) {
	e = &edgeshare[-k];
	e->faces[1] = f;
      }
      else {
	e = &edgeshare[k];
	e->faces[0] = f;
      }

      if (e->faces[0] && e->faces[1]) {
	/* determine if coplanar */
	if (e->faces[0]->planenum == e->faces[1]->planenum)
	  e->coplanar = TRUE;
      }
    }
  }

  tfree(edgeshare);
}

/*
 * ===============
 * AllocTriangulation
 * ===============
 */
staticfnc struct triangulation *AllocTriangulation(register struct dplane_t *plane)
{
  struct triangulation *t;
  if (!(t = (struct triangulation *)tmalloc(sizeof(struct triangulation))))
      Error(failed_memoryunsize, "triangulation");

  t->plane = plane;
  return t;
}

/*
 * ===============
 * FreeTriangulation
 * ===============
 */
staticfnc void FreeTriangulation(register struct triangulation *trian)
{
  if (trian->matrixsquare)
    tfree(trian->edgematrix);
  if (trian->numedges)
    tfree(trian->edges);
  if (trian->numpoints)
    tfree(trian->points);
  if (trian->numtris)
    tfree(trian->tris);
  tfree(trian);
}

staticfnc struct triedge *FindTriEdge(register struct triangulation *trian, register int p0, register int p1)
{
  struct triedge *e, *be;
  vec3D v1;
  vec3D normal;
  vec1D dist;

  /* recalculation */
  if ((trian->matrixsquare < p0) || (trian->matrixsquare < p1)) {
    struct triedge **newtrie;
    int i, newsquare = p0 > p1 ? p0 : p1;
    unsigned char *new, *old;

    if (!(newtrie = (struct triedge **)tmalloc(newsquare * newsquare * sizeof(struct triedge *))))
        Error(failed_memoryunsize, "triedges");

    new = (unsigned char *)newtrie;
    old = (unsigned char *)trian->edgematrix;

    for (i = 0; i < trian->matrixsquare; i++) {
      __memcpy(new + (i * newsquare), old + (i * trian->matrixsquare), trian->matrixsquare * sizeof(struct triedge *));
    }

    tfree(trian->edgematrix);
    trian->edgematrix = newtrie;
    trian->matrixsquare = newsquare;
  }
  else if (trian->edgematrix[(p0 * trian->matrixsquare) + p1])
    return trian->edgematrix[(p0 * trian->matrixsquare) + p1];

  if (trian->numedges > MAX_TRI_EDGES - 2)
    Error("trian->numedges > MAX_TRI_EDGES-2");

  VectorSubtract(trian->points[p1]->origin, trian->points[p0]->origin, v1);
  VectorNormalize(v1);
  CrossProduct(v1, trian->plane->normal, normal);
  dist = DotProduct(trian->points[p0]->origin, normal);

  if (!(trian->edges = (struct triedge *)trealloc(trian->edges, (trian->numedges + 2) * sizeof(struct triedge))))
      Error(failed_memoryunsize, "triedges");

  e = &trian->edges[trian->numedges];
  e->p0 = p0;
  e->p1 = p1;
  e->tri = NULL;
  VectorCopy(normal, e->normal);
  e->dist = dist;
  trian->numedges++;
  trian->edgematrix[(p0 * trian->matrixsquare) + p1] = e;

  be = &trian->edges[trian->numedges];
  be->p0 = p1;
  be->p1 = p0;
  be->tri = NULL;
  VectorNegateTo(normal, be->normal);
  be->dist = -dist;
  trian->numedges++;
  trian->edgematrix[(p1 * trian->matrixsquare) + p0] = be;

  return e;
}

staticfnc struct tripoly *AllocTriangle(register struct triangulation *trian)
{
  if (!(trian->tris = (struct tripoly *)trealloc(trian->tris, ++trian->numtris * sizeof(struct tripoly))))
      Error(failed_memoryunsize, "triangle");

  return trian->tris + trian->numtris - 1;
}

/*
 * ============
 * TriEdge_r
 * ============
 */
staticfnc void TriEdge_r(register struct triangulation *trian, register struct triedge *e)
{
  int i, bestp = 0;
  vec3D v1, v2;
  vec1D *p0, *p1, *p;
  vec1D best, ang;
  struct tripoly *nt;

  if (e->tri)
    return;							/* allready connected by someone */

  /* find the point with the best angle */
  p0 = trian->points[e->p0]->origin;
  p1 = trian->points[e->p1]->origin;
  best = 1.1;
  for (i = 0; i < trian->numpoints; i++) {
    p = trian->points[i]->origin;
    /* a 0 dist will form a degenerate triangle */
    if (DotProduct(p, e->normal) - e->dist < 0)
      continue;							/* behind edge */

    VectorSubtract(p0, p, v1);
    VectorSubtract(p1, p, v2);
    if (!VectorNormalize(v1))
      continue;
    if (!VectorNormalize(v2))
      continue;
    ang = DotProduct(v1, v2);
    if (ang < best) {
      best = ang;
      bestp = i;
    }
  }
  if (best >= 1)
    return;							/* edge doesn't match anything */

  /* make a new triangle */
  nt = AllocTriangle(trian);
  nt->edges[0] = e;
  nt->edges[1] = FindTriEdge(trian, e->p1, bestp);
  nt->edges[2] = FindTriEdge(trian, bestp, e->p0);
  for (i = 0; i < 3; i++)
    nt->edges[i]->tri = nt;
  TriEdge_r(trian, FindTriEdge(trian, bestp, e->p1));
  TriEdge_r(trian, FindTriEdge(trian, e->p0, bestp));
}

/*
 * ============
 * TriangulatePoints
 * ============
 */
staticfnc void TriangulatePoints(register struct triangulation *trian)
{
  vec1D d, bestd;
  vec3D v1;
  int bp1 = 0, bp2 = 0, i, j;
  vec1D *p1, *p2;
  struct triedge *e, *e2;

  if (trian->numpoints < 2)
    return;

  /* find the two closest points */
  bestd = VEC_POSMAX;
  for (i = 0; i < trian->numpoints; i++) {
    p1 = trian->points[i]->origin;
    for (j = i + 1; j < trian->numpoints; j++) {
      p2 = trian->points[j]->origin;
      VectorSubtract(p2, p1, v1);
      d = VectorLength(v1);
      if (d < bestd) {
	bestd = d;
	bp1 = i;
	bp2 = j;
      }
    }
  }

  e = FindTriEdge(trian, bp1, bp2);
  e2 = FindTriEdge(trian, bp2, bp1);
  TriEdge_r(trian, e);
  TriEdge_r(trian, e2);
}

/*
 * ===============
 * AddPointToTriangulation
 * ===============
 */
staticfnc void AddPointToTriangulation(register struct patch *patch, register struct triangulation *trian)
{
  if (!(trian->points = (struct patch **)trealloc(trian->points, ++trian->numpoints * sizeof(struct patch *))))
      Error(failed_memoryunsize, "point");

  trian->points[trian->numpoints - 1] = patch;
}

/*
 * ===============
 * LerpTriangle
 * ===============
 */
staticfnc void LerpTriangle(register struct triangulation *trian, register struct tripoly *t, vec3D point, vec3D color)
{
  struct patch *p1, *p2, *p3;
  vec3D base, d1, d2;
  vec1D x, y, x1, y1, x2, y2;

  p1 = trian->points[t->edges[0]->p0];
  p2 = trian->points[t->edges[1]->p0];
  p3 = trian->points[t->edges[2]->p0];

  VectorCopy(p1->totallight, base);
  VectorSubtract(p2->totallight, base, d1);
  VectorSubtract(p3->totallight, base, d2);

  x = DotProduct(point, t->edges[0]->normal) - t->edges[0]->dist;
  y = DotProduct(point, t->edges[2]->normal) - t->edges[2]->dist;

  x1 = 0;
  y1 = DotProduct(p2->origin, t->edges[2]->normal) - t->edges[2]->dist;

  x2 = DotProduct(p3->origin, t->edges[0]->normal) - t->edges[0]->dist;
  y2 = 0;

  if (fabs(y1) < ON_EPSILON || fabs(x2) < ON_EPSILON) {
    VectorCopy(base, color);
    return;
  }

  VectorMA(base, x / x2, d2, color);
  VectorMA(color, y / y1, d1, color);
}

staticfnc bool PointInTriangle(vec3D point, register struct tripoly * t)
{
  int i;
  struct triedge *e;
  vec1D d;

  for (i = 0; i < 3; i++) {
    e = t->edges[i];
    d = DotProduct(e->normal, point) - e->dist;
    if (d < 0)
      return FALSE;						/* not inside */

  }

  return TRUE;
}

/*
 * ===============
 * SampleTriangulation
 * ===============
 */
staticfnc void SampleTriangulation(vec3D point, register struct triangulation *trian, vec3D color)
{
  struct tripoly *t;
  struct triedge *e;
  vec1D d, best;
  struct patch *p0, *p1;
  vec3D v1, v2;
  int i, j;

  if (trian->numpoints == 0) {
    VectorClear(color);
    return;
  }
  if (trian->numpoints == 1) {
    VectorCopy(trian->points[0]->totallight, color);
    return;
  }

  /* search for triangles */
  for (t = trian->tris, j = 0; j < trian->numtris; t++, j++) {
    if (!PointInTriangle(point, t))
      continue;

    /* this is it */
    LerpTriangle(trian, t, point, color);
    return;
  }

  /* search for exterior edge */
  for (e = trian->edges, j = 0; j < trian->numedges; e++, j++) {
    if (e->tri)
      continue;							/* not an exterior edge */

    d = DotProduct(point, e->normal) - e->dist;
    if (d < 0)
      continue;							/* not in front of edge */

    p0 = trian->points[e->p0];
    p1 = trian->points[e->p1];

    VectorSubtract(p1->origin, p0->origin, v1);
    VectorNormalize(v1);
    VectorSubtract(point, p0->origin, v2);
    d = DotProduct(v2, v1);
    if (d < 0)
      continue;
    if (d > 1)
      continue;
    for (i = 0; i < 3; i++)
      color[i] = p0->totallight[i] + d * (p1->totallight[i] - p0->totallight[i]);
    return;
  }

  /* search for nearest point */
  best = VEC_POSMAX;
  p1 = NULL;
  for (j = 0; j < trian->numpoints; j++) {
    p0 = trian->points[j];
    VectorSubtract(point, p0->origin, v1);
    d = VectorLength(v1);
    if (d < best) {
      best = d;
      p1 = p0;
    }
  }

  if (!p1)
    Error("SampleTriangulation: no points");

  VectorCopy(p1->totallight, color);
}

/*
 * =============
 * GatherSampleLight
 * 
 * Lightscale is the normalizer for multisampling
 * =============
 */
staticfnc void GatherSampleLight(bspBase bspMem, vec3D pos, vec3D normal,
		       register vec1D **styletable, register int offset, register int mapsize, register vec1D lightscale)
{
  int i;
  struct directlight *l;
  unsigned char pvs[(MAX_MAP_LEAFS + 7) / 8];
  vec3D delta;
  vec1D dot, dot2;
  vec1D dist;
  vec1D scale = 1.0;
  vec1D *dest;

  /* get the PVS for the pos to limit the number of checks */
  if (!PvsForOrigin(bspMem, pos, pvs)) {
    return;
  }

  for (i = 0; i < bspMem->shared.quake1.numleafs; i++) {
    if ((pvs[i >> 3] & (1 << (i & 7)))) {
      for (l = directlights[i]; l; l = l->next) {
	VectorSubtract(l->origin, pos, delta);
	dist = VectorNormalize(delta);
	dot = DotProduct(delta, normal);
	if (dot <= 0.001)
	  continue;						/* behind sample surface */
	switch (l->type) {
	  case emit_point:
	    /* linear falloff */
	    scale = (l->intensity - dist) * dot;
	    break;

	  case emit_surface:
	    dot2 = -DotProduct(delta, l->normal);
	    if (dot2 <= 0.001)
	      goto skipadd;					/* behind light surface */
	    scale = (l->intensity / (dist * dist)) * dot * dot2;
	    break;

	  case emit_spotlight:
	    /* linear falloff */
	    dot2 = -DotProduct(delta, l->normal);
	    if (dot2 <= l->stopdot)
	      goto skipadd;					/* outside light cone */
	    scale = (l->intensity - dist) * dot;
	    break;
	  default:
	    Error("Bad l->type");
	}

	if (TestLine_r(0, pos, l->origin))
	  continue;						/* occluded */
	if (scale <= 0)
	  continue;

	/* if this style doesn't have a table yet, allocate one */
	if (!styletable[l->style])
	  styletable[l->style] = (vec1D *)tmalloc(mapsize);

	dest = styletable[l->style] + offset;
	/* add some light to it */
	VectorMA(dest, scale * lightscale, l->color, dest);

      skipadd:;
      }
    }
/** mprogress(bspMem->shared.quake1.numleafs, i + 1); **/
  }

}

/*
 * =============
 * FinalLightFace
 * 
 * Add the indirect lighting on top of the direct
 * lighting and save into final map format
 * =============
 */
staticfnc void FinalLightFace(bspBase bspMem, register int facenum)
{
  struct dface_t *f;
  int i, j, k, st;
  vec3D lb;
  struct patch *patch;
  struct triangulation *trian = 0;
  struct facelight *fl;
  vec1D minlight;
  vec1D max, newmax;
  unsigned char *dest;
  int pfacenum;
  vec3D facemins, facemaxs;

  f = &bspMem->shared.quake1.dfaces[facenum];
  fl = &facelights[facenum];

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

  if (bspMem->shared.quake1.lightdatasize + (fl->numstyles * (fl->numsamples * 3)) >= bspMem->shared.quake1.max_lightdatasize)
    ExpandBSPClusters(bspMem, LUMP_LIGHTING);
  f->lightofs = bspMem->shared.quake1.lightdatasize;
  bspMem->shared.quake1.lightdatasize += fl->numstyles * (fl->numsamples * 3);

  f->styles[0] = 0;
  f->styles[1] = f->styles[2] = f->styles[3] = 0xff;

  /* set up the triangulation */
  if (numbounce > 0) {
    ClearLBounds(facemins, facemaxs);
    for (i = 0; i < f->numedges; i++) {
      int ednum = bspMem->shared.quake1.dsurfedges[f->firstedge + i];

      if (ednum >= 0)
	AddPointToBounds(bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[ednum].v[0]].point, facemins, facemaxs);
      else
	AddPointToBounds(bspMem->shared.quake1.dvertexes[bspMem->shared.quake1.dedges[-ednum].v[1]].point, facemins, facemaxs);
    }

    trian = AllocTriangulation(&bspMem->shared.quake1.dplanes[f->planenum]);

    /*
     * for all faces on the plane, add the nearby patches
     * to the triangulation
     */
    for (pfacenum = planelinks[f->side][f->planenum];
	 pfacenum; pfacenum = facelinks[pfacenum]) {
      for (patch = facepatches[pfacenum]; patch; patch = patch->next) {
	for (i = 0; i < 3; i++) {
	  if (facemins[i] - patch->origin[i] > subdiv * 2)
	    break;
	  if (patch->origin[i] - facemaxs[i] > subdiv * 2)
	    break;
	}
	if (i != 3)
	  continue;						/* not needed for this face */
	AddPointToTriangulation(patch, trian);
      }
    }
#if 0
    for (i = 0; i < trian->numpoints; i++)
      __bzero(trian->edgematrix[i], trian->numpoints * sizeof(trian->edgematrix[0][0]));
#endif
    TriangulatePoints(trian);
  }

  /*
   * sample the triangulation
   *
   * _minlight allows models that have faces that would not be
   * illuminated to receive a mottled light pattern instead of
   * black
   */
  minlight = FloatForKey(faceentity[facenum], "_minlight") * 128;

  dest = &bspMem->shared.quake1.dlightdata[f->lightofs];

  if (fl->numstyles > MAXLIGHTMAPS) {
    fl->numstyles = MAXLIGHTMAPS;
    eprintf("face with too many lightstyles: ( " VEC_CONV3D " )\n",
	    facepatches[facenum]->origin[0],
	    facepatches[facenum]->origin[1],
	    facepatches[facenum]->origin[2]);
  }

  for (st = 0; st < fl->numstyles; st++) {
    f->styles[st] = fl->stylenums[st];
    for (j = 0; j < fl->numsamples; j++) {
      VectorCopy((fl->samples[st] + j * 3), lb);
      if (numbounce > 0 && st == 0) {
	vec3D add;

	SampleTriangulation(fl->origins + j * 3, trian, add);
	VectorAdd(lb, add, lb);
      }
      /* add an ambient term if desired */
      lb[0] += ambient;
      lb[1] += ambient;
      lb[2] += ambient;

      VectorScale(lb, lightscale, lb);

      /* we need to clamp without allowing hue to change */
      for (k = 0; k < 3; k++)
	if (lb[k] < 1)
	  lb[k] = 1;
      max = lb[0];
      if (lb[1] > max)
	max = lb[1];
      if (lb[2] > max)
	max = lb[2];
      newmax = max;
      if (newmax < 0)
	newmax = 0;						/* roundoff problems */

      if (newmax < minlight) {
	newmax = minlight + (rand() % 48);
      }
      if (newmax > maxlight)
	newmax = maxlight;

      for (k = 0; k < 3; k++) {
	*dest++ = lb[k] * newmax / max;
      }
    }
  }

  if (numbounce > 0)
    FreeTriangulation(trian);
}

/*
 * =============
 * RadFace
 * =============
 */
staticvar vec1D sampleofs[5][2] =
{
  {0, 0},
  {-0.25, -0.25},
  {0.25, -0.25},
  {0.25, 0.25},
  {-0.25, 0.25}};

staticfnc void RadFace(bspBase bspMem, register int facenum)
{
  struct dface_t *f;
  struct lightinfo l[5];
  vec1D *styletable[MAX_LSTYLES];
  int i, j;
  vec1D *spot;
  struct patch *patch;
  int numsamples;
  int tablesize;
  struct facelight *fl;

  f = &bspMem->shared.quake1.dfaces[facenum];

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
  __bzero(styletable, sizeof(styletable));

  if (bspMem->litOptions & LIGHT_EXTRA)
    numsamples = 5;
  else
    numsamples = 1;

  for (i = 0; i < numsamples; i++) {
    bzero(&l[i], sizeof(l[i]));
    l[i].surfnum = facenum;
    l[i].face = f;
    VectorCopy(bspMem->shared.quake1.dplanes[f->planenum].normal, l[i].facenormal);
    l[i].facedist = bspMem->shared.quake1.dplanes[f->planenum].dist;
    if (f->side) {
      VectorNegate(l[i].facenormal);
      l[i].facedist = -l[i].facedist;
    }

    /* get the origin offset for rotating bmodels */
    VectorCopy(faceoffset[facenum], l[i].modelorg);

    CalcFaceVectors(bspMem, &l[i]);
    CalcFaceExtentsII(bspMem, &l[i]);
    CalcPoints(bspMem, &l[i], sampleofs[i][0], sampleofs[i][1]);
  }

  tablesize = l[0].numsurfpt * sizeof(vec3D);
  styletable[0] = (vec1D *)tmalloc(tablesize);

  fl = &facelights[facenum];
  fl->numsamples = l[0].numsurfpt;
  fl->origins = (vec1D *)tmalloc(tablesize);
  __memcpy(fl->origins, l[0].surfpt, tablesize);

  for (i = 0; i < l[0].numsurfpt; i++) {
    for (j = 0; j < numsamples; j++)
      GatherSampleLight(bspMem, l[j].surfpt[i], l[0].facenormal, styletable, i * 3, tablesize, 1.0 / numsamples);
    /* contribute the sample to one or more patches */
    AddSampleToPatch(l[0].surfpt[i], styletable[0] + i * 3, facenum);
  }

  /* average up the direct light on each patch for radiosity */
  for (patch = facepatches[facenum]; patch; patch = patch->next) {
    if (patch->samples)
      VectorScale(patch->samplelight, 1.0 / patch->samples, patch->samplelight);
  }

  for (i = 0; i < MAX_LSTYLES; i++) {
    if (!styletable[i])
      continue;
    if (fl->numstyles == MAX_STYLES)
      break;
    fl->samples[fl->numstyles] = styletable[i];
    fl->stylenums[fl->numstyles] = i;
    fl->numstyles++;
  }

  /*
   * the light from DIRECT_LIGHTS is sent out, but the
   * texture itself should still be full bright
   */
  if (facepatches[facenum]->baselight[0] >= DIRECT_LIGHT ||
      facepatches[facenum]->baselight[1] >= DIRECT_LIGHT ||
      facepatches[facenum]->baselight[2] >= DIRECT_LIGHT) {
    spot = fl->samples[0];
    for (i = 0; i < l[0].numsurfpt; i++, spot += 3)
      VectorAdd(spot, facepatches[facenum]->baselight, spot);
  }
}

/*
 * =============
 * RadWorld
 * =============
 */
void RadWorld(bspBase bspMem, mapBase mapMem)
{
  int back, i;

  mprintf("CalcTR\n");
  CalcTextureReflectivity(bspMem);
  mprintf("MakeMB\n");
  MakeBackPlanes(bspMem);
  mprintf("MakeP\n");
  MakeParents(bspMem, 0, -1);
  /* turn each face into a single patch */
  mprintf("MakePa\n");
  MakePatches(bspMem, mapMem);
  /* subdivide patches to a maximum dimension */
  mprintf("SubD\n");
  SubdividePatches(bspMem);
  mprintf("%5i patches\n", numpatches);
  /* create directlights out of patches and lights */
  mprintf("CreateDL\n");
  CreateDirectLights(bspMem, mapMem);
  mprintf("%5i patches\n", numpatches);
  back = numpatches;
  for (i = 0; i < bspMem->shared.quake1.numfaces; i++, bspfileface++) {
    RadFace(bspMem, i);
    mprogress(bspMem->shared.quake1.numfaces, i + 1);
  }
  mprintf("%5i patches: %d\n", numpatches);
  numpatches = back;
  mprintf("%5i patches: %d\n", numpatches);
  if (numbounce > 0) {
    /* build transfer lists */
    mprintf("MakeTr\n");
    for (i = 0; i < numpatches; i++)
      MakeTransfers(bspMem, i);

    mprintf("transfer lists: " VEC_CONV1D " megs\n", (vec1D)total_transfer * sizeof(struct transfer) / (1024 * 1024));

    /* spread light around */
    mprintf("Bounce\n");
    BounceLight();
    mprintf("FreeTr\n");
    FreeTransfers();
    mprintf("CheckP\n");
    CheckPatches();
  }
  /* blend bounced light into direct light and save */
  mprintf("PairEd\n");
  PairEdges(bspMem);
  mprintf("LinkPl\n");
  LinkPlaneFaces(bspMem);
  bspMem->shared.quake1.lightdatasize = 0;
  for (i = 0; i < bspMem->shared.quake1.numfaces; i++) {
    FinalLightFace(bspMem, i);
    mprogress(bspMem->shared.quake1.numfaces, i + 1);
  }
}
