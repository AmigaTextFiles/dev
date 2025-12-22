#ifndef	TDDD_C
#define	TDDC_C

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

#define	CLUSTER_POINTS		(CLUSTER_FACES / 3)
#define	CLUSTER_GROUPS		16
#define	CLUSTER_SUBGROUP	(CLUSTER_FACES / 3)

int TDDDmax_pcount = 0;
int TDDDmax_ecount = 0;
int TDDDmax_tcount = 0;
int TDDDmax_gcount = 0;
struct points *TDDDpoints = 0;
struct edges *TDDDedges = 0;
struct edgeflags *TDDDedgeflags = 0;
struct faces *TDDDfaces = 0;
int TDDDgroups = 0;
int *TDDDgroupsizes = 0;
struct facesubgroup **TDDDgroup = 0;
struct brush5 *TDDDbrushes = 0;

int TDDDnumpoints = 0;
int TDDDnumedges = 0;
int TDDDnumfaces = 0;
int TDDDnumgroups = 0;
int TDDDnumobjects = 0;

int nummapbrushes;						/* 4 */

char *ShortenName(int maxlen, char *string)
{
  short int stringlen;
  char *newstring, *strpart;

  stringlen = __strlen(string);
  newstring = strdup(string);

  if (newstring && (stringlen > (maxlen - 1))) {
    void RemoveChar(char c) {
      while (stringlen > (maxlen - 1)) {
	if ((strpart = strchr(newstring, c)))
	  strcpy(strpart, strpart + 1);
	else
	  break;
	stringlen--;
      }
    }
    void RemoveChars(char *c) {
      while (stringlen > (maxlen - 1)) {
	if ((strpart = strpbrk(newstring, c)))
	  strcpy(strpart, strpart + 1);
	else
	  break;
	stringlen--;
      }
    }
    void ReplaceString(char *o, char *i) {
      short int olen;

      olen = strlen(o);
      while (stringlen > (maxlen - 1)) {
	if ((strpart = strstr(newstring, o))) {
	  strcpy(strpart, i);
	  strcat(strpart, strpart + olen);
	}
	else
	    break;

	stringlen -= olen;
      }
    }
    RemoveChar('\n');
    RemoveChar(' ');
    RemoveChar(',');
    RemoveChar('_');
    RemoveChar('-');
    RemoveChar('.');
    RemoveChars("!\"§$%&()=?|*+^#:;");
    RemoveChars("äöü");
    RemoveChars("yj");
    RemoveChars("aeiou");
    RemoveChars("ÄÖÜ");
    RemoveChars("YJ");
    RemoveChars("AEIOU");
    newstring[maxlen - 1] = '\0';
  }
  return newstring;
}

staticfnc void AllocTDDDSubGroup(register short int faceNum, register char *subgroupname)
{
  short int groupcounter, facecounter;
  struct facesubgroup *group;

#ifdef	DEBUG
  if (faceNum < 0)
    Error("negative faceNum in AllocTDDDSubGroup\n");
#endif
#if	(WORDS_BIGENDIAN == 0)
  faceNum = BigShort(faceNum);
#endif

  if (!(subgroupname = ShortenName(18, subgroupname)))
    Error(failed_memory, "sugroupname", 18);

  if (!TDDDgroup) {
    if (!(TDDDgroup = (struct facesubgroup **)tmalloc((int)(TDDDmax_gcount = CLUSTER_GROUPS) * sizeof(struct facesubgroup *))))
        Error(failed_memory, "group", CLUSTER_GROUPS * sizeof(struct facesubgroup *));
    if (!(TDDDgroupsizes = (int *)tmalloc(CLUSTER_GROUPS * sizeof(int))))
        Error(failed_memory, "group", CLUSTER_GROUPS * sizeof(int));
    if (!(TDDDbrushes = (struct brush5 *)tmalloc(CLUSTER_GROUPS * sizeof(struct brush5))))
        Error(failed_memoryunsize, "brush");
  }

  if (TDDDnumgroups >= TDDDmax_gcount) {
    if (!(TDDDgroup = (struct facesubgroup **)trealloc(TDDDgroup, ((int)(TDDDmax_gcount += CLUSTER_GROUPS) * sizeof(struct facesubgroup *)))))
        Error(failed_memory, "group", (int)TDDDmax_gcount * sizeof(struct facesubgroup *));
    if (!(TDDDgroupsizes = (int *)trealloc(TDDDgroupsizes, ((int)TDDDmax_gcount * sizeof(int)))))
        Error(failed_memory, "group", (int)TDDDmax_gcount * sizeof(int));
    if (!(TDDDbrushes = (struct brush5 *)trealloc(TDDDbrushes, (TDDDmax_gcount * sizeof(struct brush5)))))
        Error(failed_memoryunsize, "brush");
  }

  /* backward-scanning is faster in most cases */
  groupcounter = TDDDnumgroups;
  while (--groupcounter >= 0)
    if (!__strncmp(TDDDgroup[groupcounter]->name, subgroupname, 18))
      break;
  /* not found allocate new */
  if (groupcounter < 0)
    groupcounter = TDDDnumgroups;

  if (!(group = TDDDgroup[groupcounter]))
    if (!(group = TDDDgroup[groupcounter] = (struct facesubgroup *)tmalloc(((TDDDgroupsizes[groupcounter] = CLUSTER_SUBGROUP) * sizeof(short int)) + sizeof(struct facesubgroup))))
        Error(failed_memory, "subgroup", (CLUSTER_SUBGROUP * sizeof(short int)) + sizeof(struct facesubgroup));

  if (group->count >= TDDDgroupsizes[groupcounter])
    if (!(group = TDDDgroup[groupcounter] = (struct facesubgroup *)trealloc(group, ((TDDDgroupsizes[groupcounter] += CLUSTER_SUBGROUP) * sizeof(short int)) + sizeof(struct facesubgroup))))
        Error(failed_memory, "subgroup", (TDDDgroupsizes[groupcounter] * sizeof(short int)) + sizeof(struct facesubgroup));

  if (groupcounter == TDDDnumgroups) {
    __strncpy(group->name, subgroupname, 18);
    TDDDbrushes[groupcounter].fullscale = BigShort(1);
    TDDDbrushes[groupcounter].flags = BigShort(BRS_COLOR);
    TDDDbrushes[groupcounter].wflags = BigShort(BRW_REPEA);
    TDDDnumgroups++;
  }
  free(subgroupname);

  /* backward-scanning is faster in most cases */
  facecounter = group->count;
  while (--facecounter >= 0)
    if (faceNum == group->facelist[facecounter])
      return;

  facecounter = group->count++;
  group->facelist[facecounter] = faceNum;
}

staticfnc short int AllocTDDDPoint(register fract x, register fract y, register fract z)
{
  short int pointcounter;
  vector *points;						/* + */

#if	(WORDS_BIGENDIAN == 0)
  x = BigLong(x);
  y = BigLong(y);
  z = BigLong(z);
#endif

  if (!TDDDpoints)
    if (!(TDDDpoints = (struct points *)tmalloc(((int)(TDDDmax_pcount = CLUSTER_POINTS) * sizeof(vector)) + sizeof(struct points))))
        Error(failed_memory, "point", (CLUSTER_POINTS * sizeof(vector)) + sizeof(struct points));

  if (TDDDnumpoints >= TDDDmax_pcount)
    if (!(TDDDpoints = (struct points *)trealloc(TDDDpoints, ((int)(TDDDmax_pcount += CLUSTER_POINTS) * sizeof(vector)) + sizeof(struct points))))
        Error(failed_memory, "point", ((int)TDDDmax_pcount * sizeof(vector)) + sizeof(struct points));

  /* backward-scanning is faster in most cases */
  pointcounter = TDDDnumpoints;
  points = &TDDDpoints->points[pointcounter - 1];		/* + */
  while (--pointcounter >= 0) {
    /* maybe reduction with epsilon-variance */
    if ((z == points->z) &&					/* if ((z == TDDDpoints->points[pointcounter].z) && */
	(y == points->y) &&					/*     (y == TDDDpoints->points[pointcounter].y) && */
	(x == points->x))					/*     (x == TDDDpoints->points[pointcounter].x))   */
      return pointcounter;
    points--;							/* + */
  }

  pointcounter = TDDDnumpoints++;
  points = &TDDDpoints->points[pointcounter];		/* + */
  points->z = z;
  points->y = y;
  points->x = x;

#ifdef	DEBUG
  if (pointcounter < 0)
    Error("negative faceNum in AllocTDDDPoint\n");
#endif

  return pointcounter;
}

staticfnc short int AllocTDDDEdge(register short int point0, register short int point1, register unsigned char flags)
{
  short int edgecounter;
  int *edges;							/* + */
  int points;							/* + */

#ifdef	DEBUG
  if ((point0 < 0) || (point1 < 0))
    Error("negative point in AllocTDDDEdge\n");
#endif
#if	(WORDS_BIGENDIAN == 0)
  point0 = BigShort(point0);
  point1 = BigShort(point1);
#endif

  if (!TDDDedges)
    if (!(TDDDedges = (struct edges *)tmalloc(((int)(TDDDmax_ecount = CLUSTER_EDGES) * sizeof(short int) * 2) + sizeof(struct edges))))
        Error(failed_memory, "edge", (CLUSTER_EDGES * sizeof(short int) * 2) + sizeof(struct edges));

  /* use only if a flag is given */
  if (flags && !TDDDedgeflags)
    if (!(TDDDedgeflags = (struct edgeflags *)tmalloc(((int)TDDDmax_ecount * sizeof(unsigned char)) + sizeof(struct edgeflags))))
        Error(failed_memory, "edge", ((int)TDDDmax_ecount * sizeof(unsigned char)) + sizeof(struct edgeflags));

  if (TDDDnumedges >= TDDDmax_ecount) {
    if (!(TDDDedges = (struct edges *)trealloc(TDDDedges, ((int)(TDDDmax_ecount += CLUSTER_EDGES) * sizeof(short int) * 2) + sizeof(struct edges))))
        Error(failed_memory, "edge", ((int)TDDDmax_ecount * sizeof(short int) * 2) + sizeof(struct edges));

    /* use only if a flag is given before */
    if (TDDDedgeflags)
      if (!(TDDDedgeflags = (struct edgeflags *)trealloc(TDDDedgeflags, ((int)TDDDmax_ecount * sizeof(unsigned char)) + sizeof(struct edgeflags))))
	  Error(failed_memory, "edge", ((int)TDDDmax_ecount * sizeof(unsigned char)) + sizeof(struct edgeflags));
  }

  /* faster: sort the points */
  if (point0 > point1)
    points = (point1 << 16) | (point0);				/* + */
  else								/* + */
    points = (point0 << 16) | (point1);				/* short int pointt; pointt = point1; point1 = point0; point0 = pointt; } */

  /* backward-scanning is faster in most cases */
  edgecounter = TDDDnumedges;
  edges = (int *)(&TDDDedges->edges[edgecounter][0]);	/* + */
  while (--edgecounter >= 0) {
    /* determine every edge-point order */
    if (points == *--edges) {					/*   if ((point0 == TDDDedges->edges[edgecounter][0]) && (point1 == TDDDedges->edges[edgecounter][1])) { */
      if (TDDDedgeflags)
	TDDDedgeflags->flags[edgecounter] = flags;
      return edgecounter;
    }
  }

  /* register edge */
  edgecounter = TDDDnumedges++;
  edges = (int *)(&TDDDedges->edges[edgecounter][0]);		/* TDDDedges->edges[edgecounter][0] = point0; */
  *edges = points;						/* TDDDedges->edges[edgecounter][1] = point1; */
  /* register edgeflag */
  if (TDDDedgeflags)
    TDDDedgeflags->flags[edgecounter] = flags;

#ifdef	DEBUG
  if (edgecounter < 0)
    Error("negative edge in AllocTDDDEdge\n");
#endif

  return edgecounter;
}

staticfnc short int AllocTDDDFace(register short int connect0, register short int connect1, register short int connect2)
{
  short int facecounter;
  short int *connects;						/* + */

#ifdef	DEBUG
  if ((connect0 < 0) || (connect1 < 0) || (connect2 < 0))
    Error("negative connect in AllocTDDDFace\n");
#endif
#if	(WORDS_BIGENDIAN == 0)
  connect0 = BigShort(connect0);
  connect1 = BigShort(connect1);
  connect2 = BigShort(connect2);
#endif

  if (!TDDDfaces)
    if (!(TDDDfaces = (struct faces *)tmalloc(((int)(TDDDmax_tcount = CLUSTER_FACES) * sizeof(short int) * 3) + sizeof(struct faces))))
        Error(failed_memory, "face", (CLUSTER_FACES * sizeof(short int) * 3) + sizeof(struct faces));

  if (TDDDnumfaces >= TDDDmax_tcount)
    if (!(TDDDfaces = (struct faces *)trealloc(TDDDfaces, ((int)(TDDDmax_tcount += CLUSTER_FACES) * sizeof(short int) * 3) + sizeof(struct faces))))
        Error(failed_memory, "face", ((int)TDDDmax_tcount * sizeof(short int) * 3) + sizeof(struct faces));

  /* faster: sort the connects */
  if (connect1 < connect0) {					/* c0 < c1 */
    short int connectt; connectt = connect1; connect1 = connect0; connect0 = connectt; }
  if (connect2 < connect0) {					/* c0 < c1 & c2 < c0 = c1 < c0 < c1 */
    short int connectt; connectt = connect2; connect2 = connect0; connect0 = connectt; }
  if (connect2 < connect1) {					/* c0 < c1 & c2 < c1 = c0 < c2 < c1 */
    short int connectt; connectt = connect2; connect2 = connect1; connect1 = connectt; }

#ifdef	DEBUG
  if (!((connect0 < connect1) && (connect0 < connect2) && (connect1 < connect2)))
    EDEBUGOUT("leakface found %d < %d < %d\n", connect0, connect1, connect2);
#endif

  /* backward-scanning is faster in most cases */
  facecounter = TDDDnumfaces;
  connects = &TDDDfaces->connects[facecounter - 1][0];	/* + */
  while (--facecounter >= 0) {
    /* determine every face-connect order */
    if ((connect2 == connects[2]) &&				/* if ((connect2 == TDDDfaces->connects[facecounter][2]) && */
	(connect1 == connects[1]) &&				/*     (connect1 == TDDDfaces->connects[facecounter][1]) && */
	(connect0 == connects[0]))				/*     (connect0 == TDDDfaces->connects[facecounter][0])) */
      return facecounter;
    connects--;
  }

  facecounter = TDDDnumfaces++;
  connects = &TDDDfaces->connects[facecounter][0];		/* + */
  connects[2] = connect2;					/* TDDDfaces->connects[facecounter][2] = connect2; */
  connects[1] = connect1;					/* TDDDfaces->connects[facecounter][1] = connect1; */
  connects[0] = connect0;					/* TDDDfaces->connects[facecounter][0] = connect0; */

#ifdef	DEBUG
  if (facecounter < 0)
    Error("negative face in AllocTDDDFace\n");
#endif

  return facecounter;
}

bool SaveFace(vec3D point0, vec3D point1, vec3D point2, register char *subgroupname, register int flags)
{
  unsigned short int face, p0, p1, p2;
  fract px, py, pz;

  /* this is a special case for LWOBtoTDDD: addresses can normally change */
/* if ((point0 == point1) || (point0 == point2) || (point1 == point2)) */
/*   return FALSE; */

  px = float2fract(point0[0]);
  py = float2fract(point0[1]);
  pz = float2fract(point0[2]);
  p0 = AllocTDDDPoint(px, py, pz);
  px = float2fract(point1[0]);
  py = float2fract(point1[1]);
  pz = float2fract(point1[2]);
  p1 = AllocTDDDPoint(px, py, pz);
  px = float2fract(point2[0]);
  py = float2fract(point2[1]);
  pz = float2fract(point2[2]);
  p2 = AllocTDDDPoint(px, py, pz);

  face = AllocTDDDFace(AllocTDDDEdge(p0, p1, 0),
		       AllocTDDDEdge(p1, p2, 0),
		       AllocTDDDEdge(p2, p0, 0));

  if (subgroupname)
    AllocTDDDSubGroup(face, subgroupname);

  return TRUE;
}

#define	CACHE_UNUSED_OUT
struct pointcache {
  short int inited;						/*  2 */
  struct {
    vec1D x, y, z;
  } normal;							/* 12 */
} __attribute__((aligned(16)));					/* 14 bytes */

bool CheckEdgeAngles(vec1D softAngle)
{
  if (TDDDedges && TDDDnumedges &&
      TDDDfaces && TDDDnumfaces) {
    /*
     * loop through all edges
     * 1. get edge
     * 2. find the two polygons (triangles) that share the edge
     * 3. if there are two polygons, calculate normals
     *     find angle between them (180 - 0), compare,
     *     make soft or sharp
     *    else make sharp
     */
    short int edge;

#ifdef	VERBOSE
    short int softedges;
#endif
#ifdef	CACHE_UNUSED_OUT
    short int maxface;
#endif
    struct pointcache *pcache;
#if defined(__HAVE_FPU__) && !defined(PROFILE)
    const register double M_PI_2_90 __asm__("fp7");

    __asm__("fmovecr%.x %#0,%0"					/* extended precision pi */
	    : "=f" (M_PI_2_90)
	    : /* no inputs */ );
    __asm__("fdiv%.s %#0r90.0,%0"
	    : "=f" (M_PI_2_90)
	    : "0" (M_PI_2_90));
#else
    const double M_PI_2_90 = M_PI_2 / 90;
#endif

    pcache = tmalloc(TDDDnumfaces * sizeof(struct pointcache));	/* clears all inited */
#ifdef	VERBOSE
    softedges = 0;
#endif
#ifdef	CACHE_UNUSED_OUT
    maxface = TDDDnumfaces;
#endif

    edge = TDDDnumedges;
    while (--edge >= 0) {
      /* do not process edges that are soft */
      if (TDDDedgeflags->flags[edge] & EDG_SHARP) {
	register struct pointcache *cface1p, *cfacep;
	struct pointcache cface1, cface2;
	register short int facecounter;

	cface1p = 0;
	cfacep = &cface1;
	cface1.inited = 0;
	cface2.inited = 0;

#ifdef	CACHE_UNUSED_OUT
	if (pcache) {
	  facecounter = maxface;
	  /* every face has three edges, so every face could only be used three times */
	  while ((--facecounter >= 0) && (pcache[facecounter].inited >= 3))
	    maxface--;
	}
	facecounter = maxface;
#else
	facecounter = TDDDnumfaces;
#endif

	while (--facecounter >= 0) {
	  short int *connects;

#ifdef	CACHE_UNUSED_OUT
	  if (pcache && (pcache[facecounter].inited >= 3))
	    continue;
#endif
	  connects = &TDDDfaces->connects[facecounter][0];
	  if ((edge == BigShort(connects[0])) ||
	      (edge == BigShort(connects[1])) ||
	      (edge == BigShort(connects[2]))) {
	    if (pcache)
	      cfacep = &pcache[facecounter];

	    /* if cache else fallback */
	    if (!cfacep->inited) {
	      struct {vec1D x, y, z;} fface[2];

	      {
		short int face0, face1, face2;

		face0 = TDDDedges->edges[BigShort(connects[0])][0];
		face1 = TDDDedges->edges[BigShort(connects[0])][1];
		connects = &TDDDedges->edges[BigShort(connects[1])][0];
		if ((face0 != connects[0]) && (face1 != connects[0]))
		  face2 = connects[0];
		else
		  face2 = connects[1];

		{
		  register fract fface0x, fface0y, fface0z;
		  register vector *pface;

		  /* plane equation */
		  pface = &TDDDpoints->points[BigShort(face0)];
		  fface0x = BigLong(pface->x);
		  fface0y = BigLong(pface->y);
		  fface0z = BigLong(pface->z);
		  pface = &TDDDpoints->points[BigShort(face1)];
		  fface[0].x = fract2float(BigLong(pface->x) - fface0x);
		  fface[0].y = fract2float(BigLong(pface->y) - fface0y);
		  fface[0].z = fract2float(BigLong(pface->z) - fface0z);
		  pface = &TDDDpoints->points[BigShort(face2)];
		  fface[1].x = fract2float(BigLong(pface->x) - fface0x);
		  fface[1].y = fract2float(BigLong(pface->y) - fface0y);
		  fface[1].z = fract2float(BigLong(pface->z) - fface0z);
		}
	      }

	      {
		register vec1D cfacex, cfacey, cfacez;

		/* normal and length */
		cfacex = (fface[0].y * fface[1].z) - (fface[0].z * fface[1].y);
		cfacey = (fface[0].z * fface[1].x) - (fface[0].x * fface[1].z);
		cfacez = (fface[0].x * fface[1].y) - (fface[0].y * fface[1].x);

		{
		  register vec1D lface;

		  lface = sqrt((cfacex * cfacex) + (cfacey * cfacey) + (cfacez * cfacez));
		  cfacep->normal.x = cfacex / lface;
		  cfacep->normal.y = cfacey / lface;
		  cfacep->normal.z = cfacez / lface;
		}
	      }
	    }

	    if (pcache) {
#ifdef	CACHE_UNUSED_OUT
	      /* every face has three edges, so every face could only be used three times */
	      if (++cfacep->inited >= 3)
		if (facecounter == (maxface - 1))
		  maxface--;
#else
	      cfacep->inited = 1;
#endif
	    }

	    /* second face found */
	    if (cface1p) {
	      register vec1D thisAngle;

	      /* angle */
	      /* sad, we have destroyed clockwise order while edge-allocation     *
	       * so we cannot check for angles > 90.0° the object must be convex        */
	      thisAngle = fabs((cface1p->normal.x * cfacep->normal.x) +
			       (cface1p->normal.y * cfacep->normal.y) +
			       (cface1p->normal.z * cfacep->normal.z));
	      if (thisAngle > cos(softAngle * M_PI_2_90)) {
#ifdef	VERBOSE
		softedges++;
#endif
		TDDDedgeflags->flags[edge] &= ~EDG_SHARP;	/* remove sharp flag */
	      }

	      break;
	    }

	    /* first face found */
	    cface1p = cfacep;
	    cfacep = &cface2;
	  }
	}

	/* no second face found */
        mprogress(TDDDnumedges, edge);
      }
      else {
#ifdef	VERBOSE
	softedges++;
#endif
      }
    }

    if (pcache)
      tfree(pcache);
#ifdef	VERBOSE
    mprintf("  %d softedges\n", softedges);
#endif
  }

  return TRUE;
}

bool SetForm(register HANDLE outFile, register int *last, register int ID)
{
  int Form[3];

  Form[0] = BigLong(ID_FORM);
  Form[1] = BigLong(*last);
  Form[2] = BigLong(ID);

  *last = __ltell(outFile) + 8;
  __write(outFile, Form, 12);

  return TRUE;
}

bool SetRoot(register HANDLE outFile, register int *last, register int ID)
{
  int Root[2];

  Root[0] = BigLong(ID);
  Root[1] = BigLong(*last);

  *last = __ltell(outFile) + 8;
  __write(outFile, Root, 8);

  return TRUE;
}

bool SetEndM(register HANDLE outFile, register int ID)
{
  int EndM[2];

  EndM[0] = BigLong(ID);
  EndM[1] = BigLong(0);

  __write(outFile, EndM, 8);
  TDDDnumobjects++;

  return TRUE;
}

bool VerRoot(register HANDLE outFile, register int *last, register int ID)
{
  int this = __ltell(outFile);
  int Root[2];
  const int pad0 = 0;

  __lseek(outFile, *last - 8, SEEK_SET);
  *last = this - *last;

  Root[0] = BigLong(ID);
  Root[1] = BigLong(*last);

  __write(outFile, Root, 8);
  __lseek(outFile, this, SEEK_SET);
  /* pad to 2-byte boundary */
  if (this & 1)
    __write(outFile, &pad0, 1);

  return TRUE;
}

bool SetUnknown(register HANDLE outFile, register int ID, register void *data, register int size)
{
  int Defs[2];
  const int pad0 = 0;

  Defs[0] = BigLong(ID);
  Defs[1] = BigLong(size);

  __write(outFile, Defs, 8);
  __write(outFile, data, size);
  /* pad to 2-byte boundary */
  if (size & 1)
    __write(outFile, &pad0, 1);

  return TRUE;
}

bool SetClassName(register HANDLE outFile, register char *className)
{
  char name[19];

  __bzero(name, sizeof(name));
  __strncpy(name, ShortenName(18, className), 18);
  SetUnknown(outFile, ID_NAME, name, 18);

  return TRUE;
}

bool SetSubGroups(register HANDLE outFile)
{
  short int groupcounter;

  groupcounter = TDDDnumgroups;
  while (--groupcounter >= 0) {
    /*
     * write only a subgroup if there are more than one
     * and if the subgroup contains members
     */
    if ((TDDDnumgroups > 1) && (TDDDgroup[groupcounter]->count > 0))
      SetUnknown(outFile, ID_FGRP, TDDDgroup[groupcounter], 20 + (sizeof(short int) * TDDDgroup[groupcounter]->count));
  }

  return TRUE;
}

bool SetPoints(register HANDLE outFile)
{
  if (TDDDpoints && TDDDnumpoints) {
    TDDDpoints->pcount = TDDDnumpoints;
    SetUnknown(outFile, ID_PNTS, TDDDpoints, (sizeof(vector) * TDDDnumpoints) + sizeof(short int));
  }

  return TRUE;
}

bool SetEdges(register HANDLE outFile)
{
  if (TDDDedges && TDDDnumedges) {
    TDDDedges->ecount = TDDDnumedges;
    SetUnknown(outFile, ID_EDGE, TDDDedges, sizeof(short int) * ((TDDDnumedges * 2) + 1));

    /* save only if exists */
    if (TDDDedgeflags) {
      TDDDedgeflags->count = TDDDnumedges;
      SetUnknown(outFile, ID_EFLG, TDDDedgeflags, (sizeof(unsigned char) * TDDDnumedges) + sizeof(short int));
    }
  }
  return TRUE;
}

bool SetFaces(register HANDLE outFile)
{
  if (TDDDfaces && TDDDnumfaces) {
    TDDDfaces->tcount = TDDDnumfaces;
    SetUnknown(outFile, ID_FACE, TDDDfaces, sizeof(short int) * ((TDDDnumfaces * 3) + 1));
  }

  return TRUE;
}

#if 0
bool SetFirstDefaults(register HANDLE outFile)
{
  short int points;
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
  size.size.x  = size.size.x  = size.size.x  =
  bound.maxs.x = bound.maxs.y = bound.maxs.z = BigLong(0x00200000);
  bound.mins.x = bound.mins.y = bound.mins.z = BigLong(0xFFE00000);
  position.position.x = position.position.y = position.position.z = 0;
  shape.shape = BigShort(SH_AXIS);
  shape.lamp = BigShort(LP2_NOLAM);

  if (TDDDpoints && TDDDnumpoints) {
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
    position.position.x = BigLong((bound.maxs.x + bound.mins.x) / 2);	/* position.position.x = BigLong(float2fract(posx / TDDDnumpoints)); */
    position.position.y = BigLong((bound.maxs.y + bound.mins.y) / 2);	/* position.position.y = BigLong(float2fract(posy / TDDDnumpoints)); */
    position.position.z = BigLong((bound.maxs.z + bound.mins.z) / 2);	/* position.position.z = BigLong(float2fract(posz / TDDDnumpoints)); */

    bound.maxs.x = BigLong((bound.maxs.x - bound.mins.x) / 2);		/* bound.maxs.x = BigLong(bound.maxs.x - BigLong(position.position.x)); */
    bound.maxs.y = BigLong((bound.maxs.y - bound.mins.y) / 2);		/* bound.maxs.y = BigLong(bound.maxs.y - BigLong(position.position.y)); */
    bound.maxs.z = BigLong((bound.maxs.z - bound.mins.z) / 2);		/* bound.maxs.z = BigLong(bound.maxs.z - BigLong(position.position.z)); */
    bound.mins.x = -bound.maxs.x;					/* bound.mins.x = BigLong(bound.mins.x - BigLong(position.position.x)); */
    bound.mins.y = -bound.maxs.y;					/* bound.mins.y = BigLong(bound.mins.y - BigLong(position.position.y)); */
    bound.mins.z = -bound.maxs.z;					/* bound.mins.z = BigLong(bound.mins.z - BigLong(position.position.z)); */

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
#endif

bool SetLastDefaults(register HANDLE outFile, struct rgb Color, vec1D Reflection, vec1D Transparency, vec1D Specular)
{
  int len;
  short int facecounter;
  struct colr colour;
  unsigned int ReflectionC, TransparencyC, SpecularC;

  ReflectionC = rint(Reflection);
  TransparencyC = rint(Transparency);
  SpecularC = rint(Specular);

  colour.color = (Color.r << 16) |
		 (Color.g << 8) |
		 (Color.b << 0);
  SetUnknown(outFile, ID_COLR, &colour, sizeof(struct colr));

  colour.color = (ReflectionC << 16) |
		 (ReflectionC << 8) |
		 (ReflectionC << 0);
  SetUnknown(outFile, ID_REFL, &colour, sizeof(struct colr));

  colour.color = (TransparencyC << 16) |
		 (TransparencyC << 8) |
		 (TransparencyC << 0);
  SetUnknown(outFile, ID_TRAN, &colour, sizeof(struct colr));

  colour.color = (SpecularC << 16) |
		 (SpecularC << 8) |
		 (SpecularC << 0);
  SetUnknown(outFile, ID_SPC1, &colour, sizeof(struct colr));

  if (TDDDfaces && TDDDnumfaces) {
    struct faceattr *attr;

    if(!(attr = (struct faceattr *)tmalloc((TDDDnumfaces * sizeof(struct rgb)) + sizeof(struct faceattr))))
      Error(failed_memory, "attribute lists", (TDDDnumfaces * sizeof(struct rgb)) + sizeof(struct faceattr));

    attr->count = BigShort(TDDDnumfaces);
    len = (TDDDnumfaces * sizeof(struct rgb)) + sizeof(short int);

    facecounter = TDDDnumfaces;
    while (--facecounter >= 0) {
      attr->attr[facecounter].r = Color.r;
      attr->attr[facecounter].g = Color.g;
      attr->attr[facecounter].b = Color.b;
    }
    SetUnknown(outFile, ID_CLST, attr, len);

    facecounter = TDDDnumfaces;
    while (--facecounter >= 0) {
      attr->attr[facecounter].r = ReflectionC;
      attr->attr[facecounter].g = ReflectionC;
      attr->attr[facecounter].b = ReflectionC;
    }
    SetUnknown(outFile, ID_RLST, attr, len);

    facecounter = TDDDnumfaces;
    while (--facecounter >= 0) {
      attr->attr[facecounter].r = TransparencyC;
      attr->attr[facecounter].g = TransparencyC;
      attr->attr[facecounter].b = TransparencyC;
    }
    SetUnknown(outFile, ID_TLST, attr, len);

    tfree(attr);
  }

  return TRUE;
}

#endif
