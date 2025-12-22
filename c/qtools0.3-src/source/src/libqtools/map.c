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

#define	LIBQTOOLS_CORE
#include "../include/libqtools.h"
#include "../include/libqbuild.h"

staticvar struct entity *mapent;				/* 4 */
staticvar int nummapbrushes;					/* 4 */
staticvar short int numlighttargets;
staticvar char lighttargets[32][64];

staticvar vec3D baseaxis[18] =					/* 216 */
{
  {0, 0, 1},
  {1, 0, 0},
  {0, -1, 0},							/* floor */
  {0, 0, -1},
  {1, 0, 0},
  {0, -1, 0},							/* ceiling */
  {1, 0, 0},
  {0, 1, 0},
  {0, 0, -1},							/* west wall */
  {-1, 0, 0},
  {0, 1, 0},
  {0, 0, -1},							/* east wall */
  {0, 1, 0},
  {1, 0, 0},
  {0, 0, -1},							/* south wall */
  {0, -1, 0},
  {1, 0, 0},
  {0, 0, -1}							/* north wall */
};

/*============================================================================ */

/*
 * ===============
 * FindMiptex
 * 
 * ===============
 */
int FindMiptex(mapBase mapMem, char *name)
{
  int i;

  strnlower(name, NAMELEN_WAD);

  for (i = 0; i < mapMem->nummaptexstrings; i++)
    if (!__strncmp(name, mapMem->maptexstrings[i], NAMELEN_WAD))
      return i;

  if (mapMem->nummaptexstrings == mapMem->max_nummaptexstrings)
    ExpandMapClusters(mapMem, MAP_TEXSTRINGS);
  __strncpy(mapMem->maptexstrings[i], name, NAMELEN_WAD);
  mapMem->nummaptexstrings++;
  return i;
}

/*
 * ===============
 * FindTexinfo
 * 
 * Returns a global texinfo number
 * ===============
 */
int FindTexinfo(bspBase bspMem, mapBase mapMem, struct texinfo *t)	/* TODO: move to libqbuild */
{
  int i, j;
  struct texinfo *tex;

  /* set the special flag */
  if (isWarp(mapMem->maptexstrings[t->miptex]) ||
      isSky(mapMem->maptexstrings[t->miptex]))
    t->flags |= TEX_SPECIAL;

  tex = bspMem->shared.quake1.texinfo;
  for (i = 0; i < bspMem->shared.quake1.numtexinfo; i++, tex++) {
    if (t->miptex != tex->miptex)
      continue;
    if (t->flags != tex->flags)
      continue;

    for (j = 0; j < 8; j++)
      if (t->vecs[0][j] != tex->vecs[0][j])
	break;
    if (j != 8)
      continue;

    return i;
  }

  /* allocate a new texture */
  if (bspMem->shared.quake1.numtexinfo == bspMem->shared.quake1.max_numtexinfo)
    ExpandBSPClusters(bspMem, LUMP_TEXINFO);
  bspMem->shared.quake1.texinfo[i] = *t;
  bspMem->shared.quake1.numtexinfo++;

  return i;
}

/*JIM */
struct entity *FindEntityWithKeyPair(mapBase mapMem, char *key, char *value)
{
  struct entity *ent;
  struct epair *ep;
  int i;

  for (i = 0, ent = mapMem->mapentities; i < mapMem->nummapentities; i++, ent++)
    for (ep = ent->epairs; ep; ep = ep->next) {
      if (!__strcmp(ep->key, key)) {
	if (!__strcmp(ep->value, value))
	  return ent;
	break;
      }
    }

  return NULL;
}

struct entity *FindTargetEntity(mapBase mapMem, char *target)
{
  int i;

  for (i = 0; i < mapMem->nummapentities; i++)
    if (!__strcmp(mapMem->mapentities[i].targetname, target))
      return &mapMem->mapentities[i];

  return NULL;
}

struct entity *FindEntityWithModel(mapBase mapMem, int modnum)
{
  int i;
  char *s;
  char name[NAMELEN_WAD];

  sprintf(name, "*%i", modnum);
  /* search the entities for one using modnum */
  for (i = 0; i < mapMem->nummapentities; i++) {
    s = ValueForKey(&mapMem->mapentities[i], "model");
    if (!__strcmp(s, name))
      return &mapMem->mapentities[i];
  }

  return &mapMem->mapentities[0];
}

/*============================================================================ */

/*
 * =================
 * ParseEpair
 * =================
 */
void ParseEpair(void)
{
  struct epair *e;

  if (!(e = (struct epair *)tmalloc(sizeof(struct epair))))
    Error(failed_memory, sizeof(struct epair), "epair");

  e->next = mapent->epairs;
  mapent->epairs = e;

  if (__strlen(token) >= MAX_KEY - 1)
    Error("ParseEpar: token too long");
  if (!(e->key = smalloc(token)))
    Error(failed_memoryunsize, "key");
  GetToken(FALSE);
  if (__strlen(token) >= MAX_VALUE - 1)
    Error("ParseEpar: token too long");
  if (!(e->value = smalloc(token)))
    Error(failed_memoryunsize, "value");

  strlower(e->key);
  strlower(e->value);
}

/*============================================================================ */

/*
 * ==================
 * textureAxisFromPlane
 * ==================
 */
void TextureAxisFromPlane(struct plane *pln, vec3D xv, vec3D yv)
{
  short int bestaxis;
  vec1D dot, best;
  short int i;

  best = 0;
  bestaxis = 0;

  for (i = 0; i < 6; i++) {
    dot = DotProduct(pln->normal, baseaxis[i * 3]);
    if (dot > best) {
      best = dot;
      bestaxis = i;
    }
  }

  VectorCopy(baseaxis[bestaxis * 3 + 1], xv);
  VectorCopy(baseaxis[bestaxis * 3 + 2], yv);
}

/*============================================================================= */

staticfnc void GetEdges(bspBase bspMem, register int ledge, register struct dedge_t *edge)
{
  if (bspMem->shared.quake1.dsurfedges[ledge] > 0)
    *edge = bspMem->shared.quake1.dedges[bspMem->shared.quake1.dsurfedges[ledge]];
  else {
    edge->v[0] = bspMem->shared.quake1.dedges[-(bspMem->shared.quake1.dsurfedges[ledge])].v[1];
    edge->v[1] = bspMem->shared.quake1.dedges[-(bspMem->shared.quake1.dsurfedges[ledge])].v[0];
  }
}

staticfnc struct mface *AddFace(register struct mbrush *b, register int t, register vec3D planepts0, register vec3D planepts1, register vec3D planepts2)
{
  struct mface *f;
  vec3D t1, t2, t3;
  short int j;

  if (!(f = (struct mface *)tmalloc(sizeof(struct mface))))
    Error(failed_memory, sizeof(struct mface), "mface");

  /* convert to a vector / dist plane */
  for (j = 0; j < 3; j++) {
    t1[j] = planepts0[j] - planepts1[j];
    t2[j] = planepts2[j] - planepts1[j];
    t3[j] = planepts1[j];
  }

  CrossProduct(t1, t2, f->plane.normal);
  if (VectorZero(f->plane.normal)) {
    eprintf("brush plane with no normal\n");
    tfree(f);
    f = 0;
  }
  else {
    f->next = b->faces;
    b->faces = f;

    VectorNormalize(f->plane.normal);
    f->plane.dist = DotProduct(t3, f->plane.normal);
    f->texinfo = t;
    VectorCopy(planepts0, f->p0);
    VectorCopy(planepts1, f->p1);
    VectorCopy(planepts2, f->p2);
  }

  return f;
}

staticfnc void ParseFace(bspBase bspMem, register struct entity *bspent, register int face)
{
  short int numfaceedges;
  short int firstfaceedge;
  int ledge, ledge2;
  struct dedge_t edges[MAXEDGES];
  struct dvertex_t vert_beg[MAXEDGES];
  struct dvertex_t vert_end[MAXEDGES];
  vec3D normal, v1, v2, v3;
  int t = bspMem->shared.quake1.dfaces[face].texinfo;
  struct mbrush *b;

  if (!(b = (struct mbrush *)tmalloc(sizeof(struct mbrush))))
    Error(failed_memory, sizeof(struct mbrush), "mbrush");

  nummapbrushes++;
  b->next = bspent->brushes;
  bspent->brushes = b;

  numfaceedges = bspMem->shared.quake1.dfaces[face].numedges;
  firstfaceedge = bspMem->shared.quake1.dfaces[face].firstedge;

  if (numfaceedges < 3)
    Error("too few edges for face");

  if (numfaceedges > MAXEDGES)
    Error("too many edges for face");

  for (ledge2 = ledge = 0; ledge < numfaceedges; ledge++, ledge2++) {
    GetEdges(bspMem, ledge2 + firstfaceedge, &edges[ledge]);
    vert_beg[ledge] = bspMem->shared.quake1.dvertexes[edges[ledge].v[0]];
    vert_end[ledge] = bspMem->shared.quake1.dvertexes[edges[ledge].v[1]];

    if (VectorCompare(vert_beg[ledge].point, vert_end[ledge].point))
      ledge--;
  }

  VectorCopy(bspMem->shared.quake1.dplanes[bspMem->shared.quake1.dfaces[face].planenum].normal, normal);
  VectorScale(normal, 2, normal);

  if (!bspMem->shared.quake1.dfaces[face].side)
    VectorInverse(normal);

  for (ledge2 = 1; ledge2 < numfaceedges - 2; ledge2++) {
    VectorSubtract(vert_end[0].point, vert_beg[0].point, v1);
    VectorSubtract(vert_end[ledge2].point, vert_beg[ledge2].point, v2);
    VectorNormalize(v1);
    VectorNormalize(v2);

    if (!VectorCompare(v1, v2))
      break;
  }

  AddFace(b, t, vert_beg[0].point, vert_end[0].point, vert_end[ledge2].point);

  for (ledge = 0; ledge < numfaceedges; ledge++) {
    if (ledge == 0) {
      VectorSubtract(vert_end[numfaceedges - 1].point, vert_beg[numfaceedges - 1].point, v1);
      VectorSubtract(vert_end[ledge].point, vert_beg[ledge].point, v2);
      VectorNormalize(v1);
      VectorNormalize(v2);
      if (VectorCompare(v1, v2))
	continue;
    }
    else {
      VectorSubtract(vert_end[ledge - 1].point, vert_beg[ledge - 1].point, v1);
      VectorSubtract(vert_end[ledge].point, vert_beg[ledge].point, v2);
      VectorNormalize(v1);
      VectorNormalize(v2);
      if (VectorCompare(v1, v2))
	continue;
    }

    VectorAdd(vert_end[ledge].point, normal, v2);
    AddFace(b, t, vert_end[ledge].point, vert_beg[ledge].point, v2);
  }

  VectorAdd(vert_beg[0].point, normal, v2);
  VectorAdd(vert_end[0].point, normal, v1);
  VectorAdd(vert_end[ledge2].point, normal, v3);
  AddFace(b, t, v1, v2, v3);
}

/*============================================================================= */

/*
 * fake proper texture vectors from QuakeEd style
 */
int MakeTexinfo(bspBase bspMem, mapBase mapMem, char *texname, struct mface *f, vec1D *scale, vec1D rotate, vec1D *shift)
{
  struct texinfo tx;
  vec3D vecs[2];
  int sv, tv;
  vec1D ang, sinv, cosv;
  vec1D ns, nt;
  short int i, j;

  __bzero(&tx, sizeof(tx));
  tx.miptex = FindMiptex(mapMem, texname);
  tfree(texname);

  TextureAxisFromPlane(&f->plane, vecs[0], vecs[1]);

  if (!scale[0])
    scale[0] = 1;
  if (!scale[1])
    scale[1] = 1;

  /* rotate axis */
  if (rotate == 0) {
    sinv = 0;
    cosv = 1;
  }
  else if (rotate == 90) {
    sinv = 1;
    cosv = 0;
  }
  else if (rotate == 180) {
    sinv = 0;
    cosv = -1;
  }
  else if (rotate == 270) {
    sinv = -1;
    cosv = 0;
  }
  else {
    ang = rotate / 180 * Q_PI;
    sinv = sin(ang);
    cosv = cos(ang);
  }

  if (vecs[0][0])
    sv = 0;
  else if (vecs[0][1])
    sv = 1;
  else
    sv = 2;

  if (vecs[1][0])
    tv = 0;
  else if (vecs[1][1])
    tv = 1;
  else
    tv = 2;

  for (i = 0; i < 2; i++) {
    ns = cosv * vecs[i][sv] - sinv * vecs[i][tv];
    nt = sinv * vecs[i][sv] + cosv * vecs[i][tv];
    vecs[i][sv] = ns;
    vecs[i][tv] = nt;
  }

  for (i = 0; i < 2; i++)
    for (j = 0; j < 3; j++)
      tx.vecs[i][j] = vecs[i][j] / scale[i];

  tx.vecs[0][3] = shift[0];
  tx.vecs[1][3] = shift[1];

  /* unique the texinfo */
  return FindTexinfo(bspMem, mapMem, &tx);
}

/*
 * =================
 * ParseBrush
 * =================
 */
void ParseBrush(bspBase bspMem, mapBase mapMem)
{
  struct mbrush *b;
  struct mface *f, *f2;
  vec3D planepts[3];
  short int i, j;
  vec1D d;
  vec1D shift[2], rotate, scale[2];
  char *texname;

  if (!(b = (struct mbrush *)tmalloc(sizeof(struct mbrush))))
    Error(failed_memory, sizeof(struct mbrush), "mbrush");

  nummapbrushes++;
  b->next = mapent->brushes;
  mapent->brushes = b;

  do {
    if (!GetToken(TRUE))
      break;
    if (!__strcmp(token, "}"))
      break;

    /* read the three point plane definition */
    for (i = 0; i < 3; i++) {
      if (i != 0)
	GetToken(TRUE);
      if (__strcmp(token, "("))
	Error("parsing brush");

      for (j = 0; j < 3; j++) {
	GetToken(FALSE);
	planepts[i][j] = atof(token);
      }

      GetToken(FALSE);
      if (__strcmp(token, ")"))
	Error("parsing brush");

    }

    /* read the texturedef */
    GetToken(FALSE);
    texname = smalloc(token);
    GetToken(FALSE);
    shift[0] = atof(token);
    GetToken(FALSE);
    shift[1] = atof(token);
    GetToken(FALSE);
    rotate = atof(token);
    GetToken(FALSE);
    scale[0] = atof(token);
    GetToken(FALSE);
    scale[1] = atof(token);

    /* if the three points are all on a previous plane, it is a */
    /* duplicate plane */
    for (f2 = b->faces; f2; f2 = f2->next) {
      for (i = 0; i < 3; i++) {
	d = DotProduct(planepts[i], f2->plane.normal) - f2->plane.dist;
	if (d < -ON_EPSILON || d > ON_EPSILON)
	  break;
      }
      if (i == 3)
	break;
    }
    if (f2) {
      eprintf("brush with duplicate plane\n");
      continue;
    }

    if ((f = AddFace(b, 0, planepts[0], planepts[1], planepts[2])))
      f->texinfo = MakeTexinfo(bspMem, mapMem, texname, f, scale, rotate, shift);
  } while (1);
}

/*
 * ================
 * ParseEntity
 * ================
 */
bool ParseEntity(bspBase bspMem, mapBase mapMem)
{
  if (!GetToken(TRUE))
    return FALSE;

  if (__strcmp(token, "{"))
    Error("ParseEntity: { not found");

  if (mapMem->nummapentities == mapMem->max_nummapentities)
    ExpandMapClusters(mapMem, MAP_ENTITIES);
  mapent = &mapMem->mapentities[mapMem->nummapentities];
  mapMem->nummapentities++;

  do {
    if (!GetToken(TRUE))
      Error("ParseEntity: EOF without closing brace");
    if (!__strcmp(token, "}"))
      break;
    if (!__strcmp(token, "{"))
      ParseBrush(bspMem, mapMem);
    else
      ParseEpair();
  } while (1);

  /* for all */
  GetVectorForKey(mapent, "origin", mapent->origin);
  mapent->classname = ValueForKey(mapent, "classname");
  mapent->target = ValueForKey(mapent, "target");
  mapent->targetname = ValueForKey(mapent, "targetname");

  /* special for qbsp+light+vis in one part */
  if (mapMem->mapOptions & MAP_LOADLIGHTS) {
    if (!(mapent->light = FloatForKeyN(mapent, "light")))
      if (!(mapent->light = FloatForKey(mapent, "_light")))
	mapent->light = 0;
    if (!(mapent->style = FloatForKey(mapent, "style")))
      if (!(mapent->style = FloatForKey(mapent, "_style")))
	mapent->style = 0;
    if (!(mapent->scaledist = FloatForKey(mapent, "wait")))
      if (!(mapent->scaledist = FloatForKey(mapent, "_wait")))
	mapent->scaledist = 1;
    mapent->angle = FloatForKey(mapent, "angle");

    GetVectorForKey(mapent, "mangle", mapent->targetmangle);
    if (!mapent->targetmangle[0] && !mapent->targetmangle[1])
      mapent->targetmangle[2] = 0;
    else
      mapent->targetmangle[2] = 1;

    if (!__strncmp(mapent->classname, "light", 5)) {
      if (!mapent->light)
	mapent->light = DEFAULTLIGHTLEVEL;

      /*if (!mapent->classname[5])) { */
      if (mapent->targetname[0] && !mapent->style) {
	char s[256];

	mapent->style = LightStyleForTargetname(mapent->targetname, TRUE);
	sprintf(s, "%i", mapent->style);
	SetKeyValue(mapent, "style", s);
      }
      /*} */
    }
  }
  return TRUE;
}

/*
 * ================
 * LoadMapFile
 * ================
 */
bool LoadMapFile(bspBase bspMem, mapBase mapMem, char *mapBuf)
{
  StartTokenParsing(mapBuf);
  mapMem->nummapentities = 0;

  mprintf("----- LoadMapFile -------\n");

  while (ParseEntity(bspMem, mapMem));
  MatchTargets(mapMem);

  if (nummapbrushes)
    mprintf("%5i brushes\n", nummapbrushes);
  if (mapMem->nummapentities)
    mprintf("%5i entities\n", mapMem->nummapentities);
  if (mapMem->nummaptexstrings)
    mprintf("%5i miptex\n", mapMem->nummaptexstrings);
  if (bspMem->shared.quake1.numtexinfo)
    mprintf("%5i texinfo\n", bspMem->shared.quake1.numtexinfo);

  return TRUE;
}

/*
 * ================
 * SaveMapFile
 * ================
 */
bool SaveMapFile(bspBase bspMem, mapBase mapMem, FILE * outFile)
{
  struct entity *ent;
  struct epair *ep;
  struct mbrush *b;
  struct mface *f;
  int i;
  struct dmiptexlump_t *head_miptex = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;

  mprintf("----- SaveMapFile -------\n");

  for (i = 0, ent = mapMem->mapentities; i < mapMem->nummapentities; i++, ent++) {
    fprintf(outFile, "{\n");

    for (ep = ent->epairs; ep; ep = ep->next)
      if (__strcmp(ep->key, "model"))
	fprintf(outFile, "  \"%s\" \"%s\"\n", ep->key, ep->value);

    for (b = ent->brushes; b; b = b->next) {
      fprintf(outFile, "  {\n");

      for (f = b->faces; f; f = f->next) {
	struct texinfo *texinfo = &bspMem->shared.quake1.texinfo[f->texinfo];
	char *miptexname;

	if (head_miptex)					/* for an allready compiled map */
	  miptexname = ((struct mipmap *)(bspMem->shared.quake1.dtexdata + head_miptex->dataofs[texinfo->miptex]))->name;
	else if (mapMem->maptexstrings)				/* for an uncompiled map */
	  miptexname = mapMem->maptexstrings[texinfo->miptex];
	else							/* for unknown states */
	  miptexname = "unknown\0";

	/*here must calc x_off y_off rotation x_scale y_scale from p_texinfo->vecs ! */
	fprintf(outFile, "    ( " VEC_CONV3D " ) ( " VEC_CONV3D " ) ( " VEC_CONV3D " ) %s " VEC_CONV1D " " VEC_CONV1D " " VEC_CONV1D " " VEC_CONV1D " " VEC_CONV1D "\n",
		f->p0[0], f->p0[1], f->p0[2], f->p1[0], f->p1[1], f->p1[2], f->p2[0], f->p2[1], f->p2[2], miptexname, texinfo->vecs[0][3], texinfo->vecs[1][3], 0.0, 1.0, 1.0);
      }

      fprintf(outFile, "  }\n");
    }

    fprintf(outFile, "}\n");
    mprogress(mapMem->nummapentities, i + 1);
  }

  return TRUE;
}

/*
 * ================
 * LoadBSPFile
 * ================
 */
bool LoadBSPFile(bspBase bspMem, mapBase mapMem)
{
  struct entity *ent;
  struct epair *ep;
  int face;
  int i;

  mprintf("----- LoadBSPFile -------\n");

  for (i = 0, ent = mapMem->mapentities; i < mapMem->nummapentities; i++, ent++) {
    int modelfaces = 0;
    int numfaces = 0;

    for (ep = ent->epairs; ep; ep = ep->next) {
      if (!__strcmp(ep->key, "model")) {
	int model = atoi(ep->value);

	numfaces = bspMem->shared.quake1.dmodels[model].numfaces;
	modelfaces = bspMem->shared.quake1.dmodels[model].firstface;
      }

      if (!__strcmp(ep->key, "classname") && !__strcmp(ep->value, "worldspawn")) {
	numfaces = bspMem->shared.quake1.dmodels[0].numfaces;
	modelfaces = bspMem->shared.quake1.dmodels[0].firstface;
      }
    }
    if (numfaces)
      for (face = 0; face < numfaces; face++, modelfaces++)
	ParseFace(bspMem, ent, modelfaces);
    mprogress(mapMem->nummapentities, i + 1);
  }

  mprintf("%5i brushes\n", nummapbrushes);

  return TRUE;
}

/*
 * ==============================================================================
 * 
 * ENTITY FILE PARSING
 * 
 * If a light has a targetname, generate a unique style in the 32-63 range
 * ==============================================================================
 */

int LightStyleForTargetname(char *targetname, bool alloc)
{
  int i;

  for (i = 0; i < numlighttargets; i++)
    if (!__strncmp(lighttargets[i], targetname, 64))
      return 32 + i;
  if (!alloc)
    return -1;
  __strncpy(lighttargets[i], targetname, 64);
  numlighttargets++;
  return numlighttargets - 1 + 32;
}

/*
 * ==================
 * MatchTargets
 * ==================
 */
void MatchTargets(mapBase mapMem)
{
  int i;

  for (i = 0; i < mapMem->nummapentities; i++) {
    if (mapMem->mapentities[i].target[0]) {
      if (!(mapMem->mapentities[i].targetent = FindTargetEntity(mapMem, mapMem->mapentities[i].target)))
	eprintf("entity at (%i,%i,%i) (%s) has unmatched target\n", (int)mapMem->mapentities[i].origin[0], (int)mapMem->mapentities[i].origin[1], (int)mapMem->mapentities[i].origin[2], mapMem->mapentities[i].classname);
      else {
	/* set the style on the source ent for switchable lights */
	if (mapMem->mapentities[i].targetent->style) {
	  char s[256];

	  mapMem->mapentities[i].style = mapMem->mapentities[i].targetent->style;
	  sprintf(s, "%i", mapMem->mapentities[i].style);
	  SetKeyValue(&mapMem->mapentities[i], "style", s);
	}
      }
    }
  }
}

void WriteEntitiesToString(bspBase bspMem, mapBase mapMem)
{
  char *buf, *end;
  struct epair *ep;
  char line[128];
  int i;

  buf = bspMem->shared.quake1.dentdata;
  end = bspMem->shared.quake1.dentdata + bspMem->shared.quake1.max_entdatasize - SAVE_BACK;
  *buf = 0;

  for (i = 0; i < mapMem->nummapentities; i++) {
    ep = mapMem->mapentities[i].epairs;
    if (!ep)
      continue;							/* ent got removed */

    __strcat(buf, "{\n");
    buf += 2;

    /*
     * if free at this use "ep = FreeEpair(ep)" 
     */
    for (ep = mapMem->mapentities[i].epairs; ep; ep = ep->next) {
      sprintf(line, "\"%s\" \"%s\"\n", ep->key, ep->value);

      if ((buf + __strlen(line)) >= end) {
	int len = buf - bspMem->shared.quake1.dentdata;

	ExpandBSPClusters(bspMem, LUMP_ENTITIES);
	end = bspMem->shared.quake1.dentdata + bspMem->shared.quake1.max_entdatasize - SAVE_BACK;
	buf = bspMem->shared.quake1.dentdata + len;
      }

      __strcat(buf, line);
      buf += __strlen(line);
    }
    __strcat(buf, "}\n");
    buf += 2;
  }
  bspMem->shared.quake1.entdatasize = buf - bspMem->shared.quake1.dentdata + 1;
}

void PrintEntity(struct entity *ent)
{
  struct epair *ep;

  for (ep = ent->epairs; ep; ep = ep->next)
    mprintf("%20s : %s\n", ep->key, ep->value);
  mprintf("-------------------- - --------------------\n");
  mprintf("%20s : %s\n", "classname", ent->classname);
  mprintf("%20s : " VEC_CONV1D "\n", "angle", ent->angle);
  mprintf("%20s : ( " VEC_CONV3D " )\n", "origin", ent->origin[0], ent->origin[1], ent->origin[2]);
  mprintf("%20s : %d\n", "light", ent->light);
  mprintf("%20s : %d\n", "style", ent->style);
  mprintf("%20s : %s\n", "scaledist", ent->scaledist);
  mprintf("%20s : %s\n", "target", ent->target);
  mprintf("%20s : %s\n", "targetname", ent->targetname);
  mprintf("%20s : %s\n", "targetmangle", ent->targetmangle);
}

char *ValueForKey(struct entity *ent, char *key)
{
  struct epair *ep;

  for (ep = ent->epairs; ep; ep = ep->next)
    if (!__strcmp(ep->key, key))
      return ep->value;
  return "";
}

char *ValueForKeyN(struct entity *ent, char *key)
{
  struct epair *ep;
  int len = __strlen(key);

  for (ep = ent->epairs; ep; ep = ep->next)
    if (!__strncmp(ep->key, key, len))
      return ep->value;
  return "";
}

void SetKeyValue(struct entity *ent, char *key, char *value)
{
  struct epair *ep;

  for (ep = ent->epairs; ep; ep = ep->next)
    if (!__strcmp(ep->key, key)) {
      tfree(ep->value);
      ep->value = smalloc(value);
      return;
    }
  if (!(ep = (struct epair *)tmalloc(sizeof(*ep))))
    Error(failed_memory, sizeof(struct epair), "epair");
  ep->next = ent->epairs;
  ent->epairs = ep;
  if (!(ep->key = smalloc(key)))
    Error(failed_memoryunsize, "key");
  if (!(ep->value = smalloc(value)))
    Error(failed_memoryunsize, "value");
}

vec1D FloatForKey(struct entity *ent, char *key)
{
  char *k;
  vec1D ret = 0;

  if ((k = ValueForKey(ent, key)))
    if (k[0])
      ret = atof(k);

  return ret;
}

vec1D FloatForKeyN(struct entity *ent, char *key)
{
  char *k;
  vec1D ret = 0;

  if ((k = ValueForKeyN(ent, key)))
    if (k[0])
      ret = atof(k);

  return ret;
}

void GetVectorForKey(struct entity *ent, char *key, vec3D vec)
{
  char *k;

  VectorClear(vec);
  /* scanf into doubles, then assign, so it is vec1D size independent */
  if ((k = ValueForKey(ent, key)))
    if (k[0])
      if (sscanf(k, VEC_CONV3D, &vec[0], &vec[1], &vec[2]) != 3)
	Error("GetVectorForKey: not 3 points as expected: " VEC_CONV3D " (%s = %s)!\n", vec[0], vec[1], vec[2], key, k);
}
