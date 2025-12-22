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
#include "../libTDDD/TDDD.h"
#include "../libTDDD/TDDD.c"

#define	CLUSTER_POINTS		(CLUSTER_FACES / 3)
#define	CLUSTER_GROUPS		16
#define	CLUSTER_SUBGROUP	(CLUSTER_FACES / 3)

bool SetEntity(register HANDLE outFile, register char *variable, register char *content)
{
  int nameLen = __strlen(content);
  struct {
    int Entity[2];
    struct texture4 brushTex;
  } ent;
  char *str;

  nameLen = ((nameLen + 1) & ~1);
  nameLen++;
  nameLen = ((nameLen + 1) & ~1);
  __bzero(&ent.brushTex, sizeof(struct texture4));
  __strncpy(ent.brushTex.label, str = ShortenName(18, variable), 18);
  free(str);

  ent.Entity[0] = BigLong(ID_TXT4);
  ent.Entity[1] = BigLong(sizeof(struct texture4) + nameLen);
  ent.brushTex.flags = BigShort(TXT_DISAB);
  ent.brushTex.length = (char)nameLen;

  __write(outFile, &ent, 8 + sizeof(struct texture4));
  __write(outFile, content, nameLen - 1);
  __write(outFile, "\0", 1);

  return TRUE;
}

bool SetBrushes(register HANDLE outFile)
{
  int lastBrush, i;
  char *str;

  for (i = 0; i < TDDDgroups; i++) {
    /*
     * write only a subgroup if there are more than one
     * and if the subgroup contains members
     */
    if ((TDDDgroups > 1) && (TDDDgroup[i]->count > 0)) {
      SetUnknown(outFile, ID_FGRP, TDDDgroup[i], 20 + (sizeof(unsigned short int) * TDDDgroup[i]->count));
      __strncpy(TDDDbrushes[i].subgrp, str = ShortenName(18, TDDDgroup[i]->name), 18);
      free(str);
    }
    SetRoot(outFile, &lastBrush, ID_BRS5);
    TDDDbrushes[i].length = ((__strlen(TDDDgroup[i]->name + 1) + 1) & ~1);
    __write(outFile, &TDDDbrushes[i], sizeof(struct brush5));
    __write(outFile, TDDDgroup[i]->name, TDDDbrushes[i].length);
    VerRoot(outFile, &lastBrush, ID_BRS5);
  }

  return TRUE;
}

bool SetFirstDefaults(register HANDLE outFile, register struct entity * ent)
{
  int points;
  struct axis axis =
  {
    {0x00010000, 0x00000000, 0x00000000},
    {0x00000000, 0x00010000, 0x00000000},
    {0x00000000, 0x00000000, 0x00010000}};
  struct posi position;
  struct bbox bound;
  struct size size;
  struct shap shape;
										/* double posx = 0, posy = 0, posz = 0; */
  axis.xaxis.x = axis.yaxis.y = axis.zaxis.z = BigLong(0x00010000);
  size.size.x = size.size.x = size.size.x = 
  bound.maxs.x = bound.maxs.y = bound.maxs.z = BigLong(float2fract( 32.0));
  bound.mins.x = bound.mins.y = bound.mins.z = BigLong(float2fract(-32.0));
  position.position.x = position.position.y = position.position.z = 0;
  shape.shape = BigShort(SH_AXIS);
  shape.lamp = BigShort(LP2_NOLAM);

  if (ent) {
    position.position.x = BigLong(float2fract(ent->origin[0]));
    position.position.y = BigLong(float2fract(ent->origin[1]));
    position.position.z = BigLong(float2fract(ent->origin[2]));

    if (ent->style) {
      struct int1 light;

      shape.lamp = BigShort(LP2_POINT);
      light.intensity.x = light.intensity.y = light.intensity.z = BigFloat(((unsigned int)ent->light << 22) / 75);
      SetUnknown(outFile, ID_INT1, &light, sizeof(light));
    }
  }

  if (TDDDpoints && TDDDpoints->pcount) {
    bound.maxs.x = bound.maxs.y = bound.maxs.z = 0x80000000;
    bound.mins.x = bound.mins.y = bound.mins.z = 0x7FFFFFFF;

    points = TDDDnumpoints;
    while (--points >= 0) {
									/* posx += fract2float(TDDDpoints->points[points].x); */
      if (TDDDpoints->points[points].x > bound.maxs.x)
	bound.maxs.x = TDDDpoints->points[points].x;
      if (TDDDpoints->points[points].x < bound.mins.x)
	bound.mins.x = TDDDpoints->points[points].x;
									/* posy += fract2float(TDDDpoints->points[points].y); */
      if (TDDDpoints->points[points].y > bound.maxs.y)
	bound.maxs.y = TDDDpoints->points[points].y;
      if (TDDDpoints->points[points].y < bound.mins.y)
	bound.mins.y = TDDDpoints->points[points].y;
									/* posz += fract2float(TDDDpoints->points[points].z); */
      if (TDDDpoints->points[points].z > bound.maxs.z)
	bound.maxs.z = TDDDpoints->points[points].z;
      if (TDDDpoints->points[points].z < bound.mins.z)
	bound.mins.z = TDDDpoints->points[points].z;
    }
    position.position.x = BigLong((bound.maxs.x + bound.mins.x) / 2);		/* position.position.x = BigLong(float2fract(posx / TDDDpoints->pcount)); */
    position.position.y = BigLong((bound.maxs.y + bound.mins.y) / 2);		/* position.position.y = BigLong(float2fract(posy / TDDDpoints->pcount)); */
    position.position.z = BigLong((bound.maxs.z + bound.mins.z) / 2);		/* position.position.z = BigLong(float2fract(posz / TDDDpoints->pcount)); */

    bound.maxs.x = BigLong((bound.maxs.x - bound.mins.x) / 2);			/* bound.maxs.x = BigLong(bound.maxs.x - BigLong(position.position.x)); */
    bound.maxs.y = BigLong((bound.maxs.y - bound.mins.y) / 2);			/* bound.maxs.y = BigLong(bound.maxs.y - BigLong(position.position.y)); */
    bound.maxs.z = BigLong((bound.maxs.z - bound.mins.z) / 2);			/* bound.maxs.z = BigLong(bound.maxs.z - BigLong(position.position.z)); */
    bound.mins.x = -bound.maxs.x;						/* bound.mins.x = BigLong(bound.mins.x - BigLong(position.position.x)); */
    bound.mins.y = -bound.maxs.y;						/* bound.mins.y = BigLong(bound.mins.y - BigLong(position.position.y)); */
    bound.mins.z = -bound.maxs.z;						/* bound.mins.z = BigLong(bound.mins.z - BigLong(position.position.z)); */

    size.size.x = bound.maxs.x;
    size.size.y = bound.maxs.y;
    size.size.z = bound.maxs.z;
  }

  SetUnknown(outFile, ID_SHP2, &shape, sizeof(struct shap));
  SetUnknown(outFile, ID_POSI, &position, sizeof(struct posi));
  SetUnknown(outFile, ID_AXIS, &axis, sizeof(struct axis));
  SetUnknown(outFile, ID_SIZE, &size, sizeof(struct size));
  SetUnknown(outFile, ID_BBOX, &bound, sizeof(struct bbox));

  return TRUE;
}

void ResetState(void) {
  TDDDgroups = 0;
  if(TDDDgroup)
    TDDDgroup[0]->count = 0;
  if(TDDDpoints)
    TDDDpoints->pcount = 0;
  if(TDDDedges)
    TDDDedges->ecount = 0;
  if(TDDDfaces)
    TDDDfaces->tcount = 0;
}

/*
 * convert a Imagine-TDDD to a Quake-Map
 */

/* IFF to pseudo IFF */
int fileIFFtopIFF(HANDLE iobFile, struct IFFchunk *IFFroot);
int memIFFtopIFF(unsigned char *iobMem, struct IFFchunk *IFFroot);

/* pseudo IFF to pseudo Brushes */
void pIFFtopBrushes(bspBase bspMem, mapBase mapMem, struct IFFchunk *IFFroot, int iterVal, struct entity *fillEntity);

/* pseudo IFF to pseudo Map */
void pIFFtopMap(bspBase bspMem, mapBase mapMem, struct IFFchunk *IFFroot, int iterVal);

void strlwrcpy(register char *dst, register char *src)
{
  int i, len = __strlen(src);

  for (i = 0; i < len; i++)
    dst[i] = (char)tolower((int)src[i]);
  dst[i] = 0;
}

int fileIFFtopIFF(register HANDLE iobFile, register struct IFFchunk *IFFroot)
{
  int processed = 0;

  /*
   * small hack -> IFFroot->iter is IFFpart->next
   */
  struct IFFchunk *IFFpart = (struct IFFchunk *)&IFFroot->size;

  while (IFFpart->type != BigLong(ID_TOBJ)) {
    int oldOffs;

    /*
     * allocate IFFchunk
     */
    IFFpart->next = (struct IFFchunk *)tmalloc(sizeof(struct IFFchunk));

    IFFpart = IFFpart->next;
    IFFpart->next = 0;
    IFFpart->iter = 0;
    IFFpart->data = 0;

    /*
     * read and parse IFFchunk
     */
    __read(iobFile, IFFpart, 8);
    IFFpart->size = ((BigLong(IFFpart->size) + 1) & ~1);
    processed += 8;
    oldOffs = __ltell(iobFile);

    if (IFFpart->type == BigLong(ID_OBJ)) {
      processed += fileIFFtopIFF(iobFile, IFFpart);
      if ((IFFroot->type == BigLong(ID_TDDD)) && (IFFroot->size == processed))
	break;
    }
    else if (IFFpart->type == BigLong(ID_DESC)) {
      processed += fileIFFtopIFF(iobFile, IFFpart);
      if ((IFFroot->type == BigLong(ID_OBJ)) && (IFFroot->size == processed))
	break;
    }
    else if (IFFpart->type != BigLong(ID_TOBJ)) {
      processed += IFFpart->size;
      IFFpart->data = (void *)tmalloc(IFFpart->size + 1);
      __read(iobFile, IFFpart->data, IFFpart->size);
    }
  }

  return processed;
}

int memIFFtopIFF(register unsigned char *iobMem, register struct IFFchunk *IFFroot)
{
  int processed = 0;

  /*
   * small hack -> IFFroot->iter is IFFpart->next
   */
  struct IFFchunk *IFFpart = (struct IFFchunk *)&IFFroot->size;

  while (IFFpart->type != BigLong(ID_TOBJ)) {
    /*
     * allocate IFFchunk
     */
    IFFpart->next = (struct IFFchunk *)tmalloc(sizeof(struct IFFchunk));

    IFFpart = IFFpart->next;
    IFFpart->next = 0;
    IFFpart->iter = 0;
    IFFpart->data = 0;

    /*
     * read and parse IFFchunk
     */
    __memcpy(IFFpart, iobMem, 8);
    iobMem += 8;
    IFFpart->size = ((BigLong(IFFpart->size) + 1) & ~1);
    processed += 8;

    if (IFFpart->type == BigLong(ID_OBJ)) {
      processed += memIFFtopIFF(iobMem, IFFpart);
      if ((IFFroot->type == BigLong(ID_TDDD)) && (IFFroot->size == processed))
	break;
    }
    else if (IFFpart->type == BigLong(ID_DESC)) {
      processed += memIFFtopIFF(iobMem, IFFpart);
      if ((IFFroot->type == BigLong(ID_OBJ)) && (IFFroot->size == processed))
	break;
    }
    else if (IFFpart->type != BigLong(ID_TOBJ)) {
      processed += IFFpart->size;
      IFFpart->data = (void *)tmalloc(IFFpart->size + 1);
      __memcpy(IFFpart->data, iobMem, IFFpart->size);
      iobMem += IFFpart->size;
    }
  }

  return processed;
}

void pIFFtopBrushes(bspBase bspMem, mapBase mapMem, register struct IFFchunk *IFFroot, register int iterVal, register struct entity *fillEntity)
{
  struct IFFchunk *IFFpart = IFFroot;

  struct faces *facelist = 0;
  struct posi *origin = 0;
  struct edges *edgelist = 0;
  struct points *pointlist = 0;
  struct brush5 **brushtex = (struct brush5 **)tmalloc(15 * sizeof(struct brush5 *));
  int brushtexs = 0;
  struct facesubgroup **facegroup = (struct facesubgroup **)tmalloc(15 * sizeof(struct facesubgroup *));
  int facegroups = 0;

  /*
   * look for other iterated brushes
   */
  while (IFFpart) {
    struct IFFchunk *actIFFpart = IFFpart;
    int indentSpace = iterVal;

    while (indentSpace-- > 0) {
      oprintf("  ");
    }
    oprintf("%4s %d bytes\n", (char *)&IFFpart->type, IFFpart->size);

    /*
     * all types that are not DESC are for the actBrush
     * after first appeareance of DESC there are only DESCs
     */
    switch (BigLong(IFFpart->type)) {
      case ID_POSI:
	origin = (struct posi *)actIFFpart->data;
	break;
      case ID_FACE:
	facelist = (struct faces *)actIFFpart->data;
	break;
      case ID_EDGE:
	edgelist = (struct edges *)actIFFpart->data;
	break;
      case ID_PNTS:
	pointlist = (struct points *)actIFFpart->data;
	break;
      case ID_FGRP:
      case ID_FGR2:
      case ID_FGR3:
      case ID_FGR4:
	facegroup[facegroups] = (struct facesubgroup *)actIFFpart->data;
	facegroups++;
	break;
      case ID_BRS5:
	brushtex[brushtexs] = (struct brush5 *)actIFFpart->data;
	brushtexs++;
	break;
      case ID_DESC:
	pIFFtopBrushes(bspMem, mapMem, actIFFpart->iter, iterVal + 1, fillEntity);
	break;
      default:
	tfree(actIFFpart->data);
	break;
    }
    IFFpart = IFFpart->next;
    tfree(actIFFpart);
  }

  if (facelist && edgelist && pointlist && brushtexs) {
    int i;

    unsigned short int facecnt;
    struct mbrush *actBrush = (struct mbrush *)tmalloc(sizeof(struct mbrush));
    struct mface *checkFace = 0;
    vec3D middle;
    unsigned short int p0, p1, p2;
    vector *point;

    for (facecnt = 0; facecnt < BigShort(facelist->tcount); facecnt++) {
      p0 = edgelist->edges[BigShort(facelist->connects[facecnt][0])][0];
      p1 = edgelist->edges[BigShort(facelist->connects[facecnt][0])][1];
      if ((edgelist->edges[BigShort(facelist->connects[facecnt][1])][0] != p0) &&
	  (edgelist->edges[BigShort(facelist->connects[facecnt][1])][0] != p1))
	p2 = edgelist->edges[BigShort(facelist->connects[facecnt][1])][0];
      else
	p2 = edgelist->edges[BigShort(facelist->connects[facecnt][1])][1];

      point = &pointlist->points[BigShort(p0)];
      middle[0] += fract2float(BigLong(point->x));
      middle[1] += fract2float(BigLong(point->y));
      middle[2] += fract2float(BigLong(point->z));
      point = &pointlist->points[BigShort(p1)];
      middle[0] += fract2float(BigLong(point->x));
      middle[1] += fract2float(BigLong(point->y));
      middle[2] += fract2float(BigLong(point->z));
      point = &pointlist->points[BigShort(p2)];
      middle[0] += fract2float(BigLong(point->x));
      middle[1] += fract2float(BigLong(point->y));
      middle[2] += fract2float(BigLong(point->z));
    }
    middle[0] /= (facecnt * 3);
    middle[1] /= (facecnt * 3);
    middle[2] /= (facecnt * 3);

    for (facecnt = 0; facecnt < BigShort(facelist->tcount); facecnt++) {
      int j;
      struct mface *actFace = (struct mface *)tmalloc(sizeof(struct mface));
      vec3D t1, t2, t3;
      vec1D distance;

      p0 = edgelist->edges[BigShort(facelist->connects[facecnt][0])][0];
      p1 = edgelist->edges[BigShort(facelist->connects[facecnt][0])][1];
      if ((edgelist->edges[BigShort(facelist->connects[facecnt][1])][0] != p0) &&
	  (edgelist->edges[BigShort(facelist->connects[facecnt][1])][0] != p1))
	p2 = edgelist->edges[BigShort(facelist->connects[facecnt][1])][0];
      else
	p2 = edgelist->edges[BigShort(facelist->connects[facecnt][1])][1];

      point = &pointlist->points[BigShort(p0)];
      actFace->p0[0] = fract2float(BigLong(point->x));
      actFace->p0[1] = fract2float(BigLong(point->y));
      actFace->p0[2] = fract2float(BigLong(point->z));
      point = &pointlist->points[BigShort(p1)];
      actFace->p1[0] = fract2float(BigLong(point->x));
      actFace->p1[1] = fract2float(BigLong(point->y));
      actFace->p1[2] = fract2float(BigLong(point->z));
      point = &pointlist->points[BigShort(p2)];
      actFace->p2[0] = fract2float(BigLong(point->x));
      actFace->p2[1] = fract2float(BigLong(point->y));
      actFace->p2[2] = fract2float(BigLong(point->z));

      /*
       * correct to clockwise order
       * planenormal must direct to other side of middle
       * or: the middle must be in the negative side of the room splitted by the plane
       * positive distance between plane and point mean it is on the positive side
       *
       * Erzeugen der Hessischen Normalenform
       * building of hesse-normalform ? to calculate distane between plane and point
       */
      VectorSubtract(actFace->p0, actFace->p1, t1);
      VectorSubtract(actFace->p2, actFace->p1, t2);
      VectorCopy(actFace->p1, t3);
      CrossProduct(t1, t2, actFace->plane.normal);
      VectorNormalize(actFace->plane.normal);
      actFace->plane.dist = DotProduct(t3, actFace->plane.normal);

      if ((distance = DotProduct(middle, actFace->plane.normal) - actFace->plane.dist) > 0) {
	vec3D temp;

	VectorCopy(actFace->p0, temp);
	VectorCopy(actFace->p2, actFace->p0);
	VectorCopy(temp, actFace->p2);

	VectorNegate(actFace->plane.normal);
	actFace->plane.dist = -actFace->plane.dist;
      }

      /*
       * elimination doubled faces in resulting only valid brushes
       * equal is: if normal and distance to origin are equal
       * the distance to origin is equal then if the angle between normal and normal of ?-normal is equal
       *
       * in theory in quakeMode, there are no eleminations possible
       */
      checkFace = actBrush->faces;
      while (checkFace) {
	vec1D a, b, c;

	/* Abstand Punkt->Ebene / distances point->plane */
	a = fabs(DotProduct(actFace->p0, checkFace->plane.normal) - checkFace->plane.dist);
	b = fabs(DotProduct(actFace->p1, checkFace->plane.normal) - checkFace->plane.dist);
	c = fabs(DotProduct(actFace->p2, checkFace->plane.normal) - checkFace->plane.dist);

	/* if point->plane less than minimum, eleminate them */
	if ((a < ON_EPSILON) && (b < ON_EPSILON) && (c < ON_EPSILON))
	  break;

	checkFace = checkFace->next;
      }

      if (!checkFace) {
	/*
	 * get the textures
	 */
	for (i = 0; i < facegroups; i++) {
	  for (j = 0; j < BigShort(facegroup[i]->count); j++) {
	    if (BigShort(facegroup[i]->facelist[j]) == facecnt)
	      break;
	  }
	  if (j < BigShort(facegroup[i]->count))
	    break;
	}
	for (j = 0; j < brushtexs; j++) {
	  if (!__strncmp(facegroup[i]->name, brushtex[j]->subgrp, 18))
	    break;
	}
	if (j < brushtexs) {
	  vec1D zero[2] = {0, 0};
	  vec1D one[2] = {1, 1};

	  actFace->texinfo = MakeTexinfo(bspMem, mapMem, brushtex[j]->name, actFace, one, 0, zero);
	}

	actFace->next = actBrush->faces;
	actBrush->faces = actFace;
      }
      else
	tfree(actFace);
    }

    tfree(facelist);
    tfree(edgelist);
    tfree(pointlist);
    for (i = 0; i < facegroups; i++)
      tfree(facegroup[i]);
    tfree(facegroup);
    for (i = 0; i < brushtexs; i++)
      tfree(brushtex[i]);
    tfree(brushtex);

    /*
     * put in brush
     */
    actBrush->next = fillEntity->brushes;
    fillEntity->brushes = actBrush;
    nummapbrushes++;
  }
  else
    eprintf("not enough data to convert brush!\n");
}

void pIFFtopMap(bspBase bspMem, mapBase mapMem, register struct IFFchunk *IFFroot, register int iterVal)
{
  struct IFFchunk *IFFpart = IFFroot;

  while (IFFpart) {
    struct IFFchunk *actIFFpart = IFFpart;
    int indentSpace = iterVal;

    while (indentSpace-- > 0) {
      oprintf("  ");
    }
    oprintf("%4s %d bytes\n", (char *)&actIFFpart->type, actIFFpart->size);

    switch (BigLong(actIFFpart->type)) {
	/*
	 * only toplevel-processing (iter 0)
	 */
      case ID_TDDD:
	/*
	 * only toplevel-processing (iter 1)
	 */
      case ID_OBJ:
	pIFFtopMap(bspMem, mapMem, actIFFpart->iter, iterVal + 1);
	break;
	/*
	 * only toplevel-processing (iter 2)
	 */
      case ID_DESC:
	if (iterVal == 2)
	  /* the dummy-axis to save the hierarchie to disk */
	  pIFFtopMap(bspMem, mapMem, actIFFpart->iter, iterVal + 1);
	else {
	  if (actIFFpart->iter) {
	    struct IFFchunk *Brushes = actIFFpart->iter;
	    struct entity *thisEntity;

	    if (mapMem->nummapentities == mapMem->max_nummapentities)
	      ExpandMapClusters(mapMem, MAP_ENTITIES);
	    thisEntity = &mapMem->mapentities[mapMem->nummapentities];
	    mapMem->nummapentities++;

	    while (Brushes) {
	      if (Brushes->type == BigLong(ID_NAME)) {
		thisEntity->classname = (char *)tmalloc(__strlen(Brushes->data) + 1);
		strlwrcpy(thisEntity->classname, Brushes->data);
	      }
	      else if (Brushes->type == BigLong(ID_INT1)) {
		struct int1 *inten = (struct int1 *)Brushes->data;

		thisEntity->light = (unsigned char)rint((fract2float(BigLong(inten->intensity.x)) +
							 fract2float(BigLong(inten->intensity.y)) +
							 fract2float(BigLong(inten->intensity.z))) / 3);
	      }
	      else if (Brushes->type == BigLong(ID_SHP2)) {
		struct shap *shape = (struct shap *)Brushes->data;

		if ((shape->lamp & BigLong(LP2_TYPE)) != BigLong(LP2_NOLAM))
		  thisEntity->style = 1;
	      }
	      else if (Brushes->type == BigLong(ID_POSI)) {
		struct posi *origin = (struct posi *)Brushes->data;

		thisEntity->origin[0] = fract2float(BigLong(origin->position.x));
		thisEntity->origin[1] = fract2float(BigLong(origin->position.y));
		thisEntity->origin[2] = fract2float(BigLong(origin->position.z));
	      }
	      else if (Brushes->type == BigLong(ID_TXT4)) {
		struct texture4 *brushtex = (struct texture4 *)Brushes->data;
		struct epair *lastString;
		struct epair *actString = (struct epair *)tmalloc(sizeof(struct epair));

		actString->next = 0;
		actString->key = (char *)tmalloc(brushtex->length + 1);
		__strncpy(actString->key, brushtex->name, brushtex->length);
		actString->key[brushtex->length] = '\0';
		actString->value = (char *)tmalloc(__strlen(brushtex->label) + 1);
		__strcpy(actString->value, brushtex->label);

		if ((lastString = thisEntity->epairs)) {
		  while (lastString->next)
		    lastString = lastString->next;
		  lastString->next = actString;
		}
		else
		  thisEntity->epairs = actString;
	      }
	      else if (Brushes->type == BigLong(ID_DESC)) {
		/*
		 * after this we get no datas any more
		 */
		if (Brushes->iter)
		  pIFFtopBrushes(bspMem, mapMem, Brushes->iter, iterVal + 1, thisEntity);
	      }
	      Brushes = Brushes->next;
	    }

	    /*
	     * for all 
	     */
	    if (VectorZero(thisEntity->origin))
	      GetVectorForKey(thisEntity, "origin", thisEntity->origin);
	    if (!thisEntity->classname)
	      thisEntity->classname = ValueForKey(thisEntity, "classname");
	    thisEntity->target = ValueForKey(thisEntity, "target");
	    thisEntity->targetname = ValueForKey(thisEntity, "targetname");

	    /*
	     * special for qbsp+light+vis in one part 
	     */
	    if (mapMem->mapOptions & MAP_LOADLIGHTS) {
	      if (!(thisEntity->light = FloatForKeyN(thisEntity, "light")))
		if (!(thisEntity->light = FloatForKey(thisEntity, "_light")))
		  if (!thisEntity->light)
		    thisEntity->light = MAX_MAPLIGHTLEVEL;
	      if (!(thisEntity->style = FloatForKey(thisEntity, "style")))
		if (!(thisEntity->style = FloatForKey(thisEntity, "_style")))
		  if (!thisEntity->style)
		    thisEntity->style = 0;
	      if (!thisEntity->angle)
		thisEntity->angle = FloatForKey(thisEntity, "angle");

	      if (__strncmp(thisEntity->classname, "light", 5)) {
		if (!thisEntity->light)
		  thisEntity->light = DEFAULTLIGHTLEVEL;

		if (thisEntity->targetname[0] && !thisEntity->style) {
		  char s[256];

		  thisEntity->style = LightStyleForTargetname(thisEntity->targetname, TRUE);
		  sprintf(s, "%i", thisEntity->style);
		  SetKeyValue(thisEntity, "style", s);
		}
	      }
	    }
	  }
	}
	break;
      default:
	break;
    }
    IFFpart = IFFpart->next;
    tfree(actIFFpart->data);
    tfree(actIFFpart);
  }
}

/*
 * the rules:
 * 
 * -the hierarchy:
 * 
 * DESC "world/axis/root" (axis)
 * -> acts as global group-manager to save all subhierarchies
 * DESC "worldspawn" (axis)
 * -> all subdesc's desribes the brushes (objects grouped to axis "worldspawn")
 * -> all subdesc's texture info must contain the name of the texture to use and
 * the alignment/positioning must be valid
 * DESC "info_player_start" (axis)
 * -> the axis position describes the players origin
 * DESC "standard quake"
 * -> will be searched for information
 * (eg. DESC "light" (axis with light) is the standard entity "light", parameters
 * are parsed out of the axis-informations)
 * -> axis that are groupt to a non-worldspawn-entity and that have no brushes
 * will beinterpreted as movement-points (?)
 * -> the texture-list of an entity will be parsed for key-values (standard-quake
 * like "target")
 * 
 * restriction: 
 * 
 * dont make objects, that are not convex
 * calculation of clockwise point-order goes via middlepoint of object
 * 
 */

/*
 * ================
 * SaveTDDDFile
 * ================
 */
bool SaveTDDDFile(bspBase bspMem, mapBase mapMem, HANDLE outFile)
{
  struct entity *ent;
  struct epair *ep;
  struct mbrush *b;
  struct mface *f;
  int i;
  struct dmiptexlump_t *head_miptex = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;
  int lastTDDD = 0;
  int lastObj = 0;
  int lastWorld = 0;
  int lastRoot = 0;
  int lastDesc = 0;
  struct rgb Color = {0,0,0};

  for (i = 0, ent = mapMem->mapentities; i < mapMem->nummapentities; i++, ent++)
    if (!__strcmp(ent->classname, "worldspawn"))
      break;

  if (i == mapMem->nummapentities) {
    eprintf("SaveTDDDFile: worldspawn not found!\n");
    return FALSE;
  }

  /*
   * hierarchy:
   * 
   * TDDD
   * OBJ
   * DESC         worldaxis
   * | DESC        worldspawn
   * | | DESC   model1
   * | | +-TOBJ
   * | | DESC   model2
   * | | +-TOBJ
   * | | ...
   * | +-TOBJ
   * | DESC        light
   * | ...
   * +-TOBJ
   */

  SetForm(outFile, &lastTDDD, ID_TDDD);
  SetRoot(outFile, &lastObj, ID_OBJ);

  SetRoot(outFile, &lastWorld, ID_DESC);
  SetClassName(outFile, "worldaxis");
  SetLastDefaults(outFile, Color, 0, 0, 0);
  VerRoot(outFile, &lastWorld, ID_DESC);
  ResetState();

  /* set worldspawn as root of all the other models */
  SetRoot(outFile, &lastRoot, ID_DESC);
  SetClassName(outFile, ent->classname);
  SetFirstDefaults(outFile, ent);
  for (ep = ent->epairs; ep; ep = ep->next)
    if (__strcmp(ep->key, "model"))
      SetEntity(outFile, ep->key, ep->value);
  for (b = ent->brushes; b; b = b->next) {
    for (f = b->faces; f; f = f->next) {
      struct texinfo *texinfo = &bspMem->shared.quake1.texinfo[f->texinfo];
      char *miptexname;

      if (head_miptex)						/* for an allready compiled map */
	miptexname = ((struct mipmap *)(bspMem->shared.quake1.dtexdata + head_miptex->dataofs[texinfo->miptex]))->name;
      else if (mapMem->maptexstrings)				/* for an uncompiled map */
	miptexname = mapMem->maptexstrings[texinfo->miptex];
      else							/* for unknown states */
	miptexname = "unknown\0";

      SaveFace(f->p0, f->p1, f->p2, miptexname, 0);
    }
  }
  SetPoints(outFile);
  SetEdges(outFile);
  SetFaces(outFile);
  SetBrushes(outFile);
  SetLastDefaults(outFile, Color, 0, 0, 0);
  VerRoot(outFile, &lastRoot, ID_DESC);
  ResetState();

  for (i = 0, ent = mapMem->mapentities; i < mapMem->nummapentities; i++, ent++) {
    bool model = FALSE;

    for (ep = ent->epairs; ep; ep = ep->next) {
      if (!__strcmp(ep->key, "model")) {
	model = TRUE;
	break;
      }
    }

    if (model && __strcmp(ent->classname, "worldspawn")) {
      SetRoot(outFile, &lastDesc, ID_DESC);
      SetClassName(outFile, ent->classname);
      SetFirstDefaults(outFile, ent);
      for (ep = ent->epairs; ep; ep = ep->next)
	if (__strcmp(ep->key, "model"))
	  SetEntity(outFile, ep->key, ep->value);
      for (b = ent->brushes; b; b = b->next) {
	for (f = b->faces; f; f = f->next) {
	  struct texinfo *texinfo = &bspMem->shared.quake1.texinfo[f->texinfo];
	  char *miptexname;

	  if (head_miptex)					/* for an allready compiled map */
	    miptexname = ((struct mipmap *)(bspMem->shared.quake1.dtexdata + head_miptex->dataofs[texinfo->miptex]))->name;
	  else if (mapMem->maptexstrings)			/* for an uncompiled map */
	    miptexname = mapMem->maptexstrings[texinfo->miptex];
	  else							/* for unknown states */
	    miptexname = "unknown\0";

	  SaveFace(f->p0, f->p1, f->p2, miptexname, 0);
	}
      }
      SetPoints(outFile);
      SetEdges(outFile);
      SetFaces(outFile);
      SetBrushes(outFile);
      SetLastDefaults(outFile, Color, 0, 0, 0);
      VerRoot(outFile, &lastDesc, ID_DESC);
      ResetState();
      SetEndM(outFile, ID_TOBJ);
    }
  }
  SetEndM(outFile, ID_TOBJ);
  VerRoot(outFile, &lastObj, ID_OBJ);
  VerRoot(outFile, &lastTDDD, ID_FORM);

  mprintf("----- SaveTDDDFile -------\n");
  mprintf("%5i points\n", TDDDnumpoints);
  mprintf("%5i edges\n", TDDDnumedges);
  mprintf("%5i faces\n", TDDDnumfaces);
  mprintf("%5i groups\n", TDDDnumgroups);
  mprintf("%5i objects\n", TDDDnumobjects);

  return TRUE;
}

/*
 * ================
 * LoadTDDDFile
 * ================
 */
bool LoadTDDDFile(bspBase bspMem, mapBase mapMem, unsigned char *tdddBuf)
{
  struct IFFheader IFFfile =
  {0, 0, 0};
  struct IFFchunk *IFFroot = (struct IFFchunk *)tmalloc(sizeof(struct IFFchunk));

  __memcpy(&IFFfile, tdddBuf, 12);
  tdddBuf += 12;
  IFFroot->type = IFFfile.type;
  IFFroot->size = IFFfile.size - 4;
  IFFroot->next = 0;
  IFFroot->iter = 0;
  IFFroot->data = 0;
  memIFFtopIFF(tdddBuf, IFFroot);
  pIFFtopMap(bspMem, mapMem, IFFroot, 0);
  MatchTargets(mapMem);

  mprintf("----- LoadTDDDFile -------\n");
  mprintf("%5i brushes\n", nummapbrushes);
  mprintf("%5i entities\n", mapMem->nummapentities);
  mprintf("%5i miptex\n", mapMem->nummaptexstrings);
  mprintf("%5i texinfo\n", bspMem->shared.quake1.numtexinfo);

  return TRUE;
}
