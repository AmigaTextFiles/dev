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

/* command line flags */
int subdivide_size = 240;

struct brushset *brushset;

int valid;

int c_activefaces, c_peakfaces;
int c_activeleafs, c_peakleafs;
int c_activesurfaces, c_peaksurfaces;
int c_activeportals, c_peakportals;

/*=========================================================================== */

void PrintMemory(void)
{
  int i, j;
  int a, b;

  mprintf(" faces   : %5i, %7i (%5i, %7i)\n", c_activefaces, j = c_activefaces * sizeof(struct visfacet),
	  c_peakfaces, i = c_peakfaces * sizeof(struct visfacet));

  a = j;
  b = i;
  mprintf(" surfaces: %5i, %7i (%5i, %7i)\n", c_activesurfaces, j = c_activesurfaces * sizeof(struct surface),
	  c_peaksurfaces, i = c_peaksurfaces * sizeof(struct surface));

  a += j;
  b += i;
  mprintf(" windings: %5i, %7i (%5i, %7i)\n", c_activewindings, j = c_activewindings * sizeof(struct winding),
	  c_peakwindings, i = c_peakwindings * sizeof(struct winding));

  a += j;
  b += i;
  mprintf(" portals : %5i, %7i (%5i, %7i)\n", c_activeportals, j = c_activeportals * sizeof(struct portal),
	  c_peakportals, i = c_peakportals * sizeof(struct portal));

  a += j;
  b += i;
  mprintf("-------------------------------------------\n");
  mprintf("                  %7i (       %7i)\n\n", a, b);
}

/*
 * ===========
 * AllocLeaf
 * ===========
 */
struct visleaf *AllocLeaf(register int prtals)
{
  struct visleaf *l;

  c_activeleafs++;
  if (c_activeleafs > c_peakleafs)
    c_peakleafs = c_activeleafs;

  if (!(l = (struct visleaf *)tmalloc(sizeof(struct visleaf))))
      Error(failed_memoryunsize, "leaf");

#ifdef DYNAMIC_EDGES
  /* at least one point available */
  if (prtals < 0)
    prtals = 0;
  if (!(l->portals = (struct visportal **)tmalloc((prtals) * sizeof(struct visportal *))))
      Error(failed_memoryunsize, "portals");

#endif
  return l;
}

void RecalcLeaf(register struct visleaf *l)
{
#ifdef DYNAMIC_EDGES
  /* at least one point available */
  int prtals = l->numportals;

  if (prtals < 0)
    prtals = 0;
  if (!(l->portals = (struct visportal **)trealloc(l->portals, (prtals) * sizeof(struct visportal *))))
      Error(failed_memoryunsize, "face");

#endif
}

void FreeLeaf(register struct visleaf *l)
{
  c_activeleafs--;
#ifdef DYNAMIC_EDGES
  tfree(l->portals);
#endif
  tfree(l);
}

/*
 * ===========
 * AllocFace
 * ===========
 */
struct visfacet *AllocFace(register int points)
{
  struct visfacet *f;

  c_activefaces++;
  if (c_activefaces > c_peakfaces)
    c_peakfaces = c_activefaces;

  if (!(f = (struct visfacet *)tmalloc(sizeof(struct visfacet))))
      Error(failed_memoryunsize, "face");

  f->planenum = -1;
#ifdef DYNAMIC_EDGES
  /* at least one point available */
  if (points < 0)
    points = 0;
  if (!(f->pts = (vec3D *)tmalloc((points) * sizeof(vec3D))))
    Error(failed_memoryunsize, "points");
  if (!(f->edges = (int *)tmalloc((points) * sizeof(int))))
      Error(failed_memoryunsize, "edges");
#endif

  return f;
}

void CopyFace(register struct visfacet *out, register struct visfacet *in)
{
#ifdef DYNAMIC_EDGES
  /* at least one point available */
  short int points = in->numpoints;
  vec3D *pts;
  int *edges;

  if (points < 0)
    points = 0;
  tfree(out->pts);
  tfree(out->edges);
  if (!(pts = (vec3D *)tmalloc((points) * sizeof(vec3D))))
    Error(failed_memoryunsize, "face");
  if (!(edges = (int *)tmalloc((points) * sizeof(int))))
      Error(failed_memoryunsize, "face");

  if (points) {
    memcpy(pts, in->pts, points * sizeof(vec3D));
    memcpy(edges, in->edges, points * sizeof(int));
  }
#endif
  __memcpy(out, in, sizeof(struct visfacet));

#ifdef DYNAMIC_EDGES
  out->pts = pts;
  out->edges = edges;
#endif
}

void RecalcFace(register struct visfacet *f)
{
#ifdef DYNAMIC_EDGES
  /* at least one point available */
  short int points = f->numpoints;

  if (points < 0)
    points = 0;
  if (!(f->pts = (vec3D *)trealloc(f->pts, (points) * sizeof(vec3D))))
    Error(failed_memoryunsize, "face");
  if (!(f->edges = (int *)trealloc(f->edges, (points) * sizeof(int))))
      Error(failed_memoryunsize, "face");
#endif
}

void FreeFace(register struct visfacet *f)
{
  c_activefaces--;
#ifdef DYNAMIC_EDGES
  tfree(f->pts);
  tfree(f->edges);
#endif
  tfree(f);
}

/*
 * ===========
 * AllocSurface
 * ===========
 */
struct surface *AllocSurface(void)
{
  struct surface *s;

  if (!(s = (struct surface *)tmalloc(sizeof(struct surface))))
      Error(failed_memoryunsize, "surface");

  c_activesurfaces++;
  if (c_activesurfaces > c_peaksurfaces)
    c_peaksurfaces = c_activesurfaces;

  return s;
}

void FreeSurface(register struct surface *s)
{
  c_activesurfaces--;
  tfree(s);
}

/*
 * ===========
 * AllocPortal
 * ===========
 */
struct portal *AllocPortal(void)
{
  struct portal *p;

  c_activeportals++;
  if (c_activeportals > c_peakportals)
    c_peakportals = c_activeportals;

  if (!(p = (struct portal *)tmalloc(sizeof(struct portal))))
      Error(failed_memoryunsize, "portal");

  return p;
}

void FreePortal(register struct portal *p)
{
  c_activeportals--;
  tfree(p);
}

/*
 * ===========
 * AllocNode
 * ===========
 */
struct node *AllocNode(void)
{
  struct node *n;

  if (!(n = (struct node *)tmalloc(sizeof(struct node))))
      Error(failed_memoryunsize, "node");

  return n;
}

/*
 * ===========
 * AllocBrush
 * ===========
 */
struct brush *AllocBrush(void)
{
  struct brush *b;

  if (!(b = (struct brush *)tmalloc(sizeof(struct brush))))
      Error(failed_memoryunsize, "node");

  return b;
}

/*=========================================================================== */

/*
 * ===============
 * ProcessEntity
 * ===============
 */
staticfnc void ProcessEntity(bspBase bspMem, mapBase mapMem, char *filebase, register int hullNum, register int entNum)
{
  char ptsName[NAMELEN_PATH], prtName[NAMELEN_PATH];
  struct entity *ent;
  char mod[80];
  struct surface *surfs;
  struct node *nodes;
  struct brushset *bs;

  __strcpy(ptsName, filebase);
  ReplaceExt(ptsName, "pts");
  __strcpy(prtName, filebase);
  ReplaceExt(prtName, "prt");

  ent = &mapMem->mapentities[entNum];
  if (!ent->brushes)
    return;							/* non-bmodel entity */

  if (entNum > 0) {
    if (entNum == 1)
      mprintf("----- Internal Entities ---\n");
    sprintf(mod, "*%i", bspMem->shared.quake1.nummodels);

    if (hullNum == 0)
      mprintf("    - MODEL: %s\n", mod);
    SetKeyValue(ent, "model", mod);
    /*
     * take the brush_ts and clip off all overlapping and contained faces,
     * leaving a perfect skin of the model with no hidden faces
     */
    bs = Brush_LoadEntity(bspMem, mapMem, ent, hullNum, FALSE);
  }
  else
    /*
     * take the brush_ts and clip off all overlapping and contained faces,
     * leaving a perfect skin of the model with no hidden faces
     */
    bs = Brush_LoadEntity(bspMem, mapMem, ent, hullNum, TRUE);

  if (!bs->brushes) {
    PrintEntity(ent);
    Error("Entity with no valid brushes");
  }

  brushset = bs;
  surfs = CSGFaces(mapMem, bs);

  if (hullNum) {
    nodes = SolidBSP(bspMem, mapMem, surfs, TRUE);
    if (entNum == 0 && !(mapMem->mapOptions & QBSP_NOFILL)) {	/* assume non-world bmodels are simple */
      PortalizeWorld(mapMem, nodes);
      if (FillOutside(mapMem, nodes, ptsName, hullNum)) {
	surfs = GatherNodeFaces(mapMem, nodes);
	nodes = SolidBSP(bspMem, mapMem, surfs, FALSE);			/* make a really good tree */
      }
      FreeAllPortals(nodes);
    }
    WriteNodePlanes(bspMem, mapMem, nodes);
    WriteClipNodes(bspMem, nodes);
    BumpModel(bspMem, hullNum);
  }
  else {
    /*
     * SolidBSP generates a node tree
     *
     * if not the world, make a good tree first
     * the world is just going to make a bad tree
     * because the outside filling will force a regeneration later
     */
    nodes = SolidBSP(bspMem, mapMem, surfs, entNum == 0);

    /*
     * build all the portals in the bsp tree
     * some portals are solid polygons, and some are paths to other leafs
     */
    if (entNum == 0 && !(mapMem->mapOptions & QBSP_NOFILL)) {	/* assume non-world bmodels are simple */
      PortalizeWorld(mapMem, nodes);

      if (FillOutside(mapMem, nodes, ptsName, hullNum)) {
	FreeAllPortals(nodes);

	/* get the remaining faces together into surfaces again */
	surfs = GatherNodeFaces(mapMem, nodes);

	/* merge polygons */
	MergeAll(mapMem, surfs);

	/* make a really good tree */
	nodes = SolidBSP(bspMem, mapMem, surfs, FALSE);

	/* make the real portals for vis tracing */
	PortalizeWorld(mapMem, nodes);

	/* save portal file for vis tracing */
	WritePortalfile(mapMem, nodes, prtName);

	/* fix tjunctions */
	if (!(mapMem->mapOptions & QBSP_NOTJUNC))
	  tjunc(nodes);
      }
      FreeAllPortals(nodes);
    }

    WriteNodePlanes(bspMem, mapMem, nodes);
    MakeFaceEdges(bspMem, nodes);
    WriteDrawNodes(bspMem, nodes);
  }

  remove(ptsName);
  remove(prtName);
}

/*
 * =================
 * UpdateEntLump
 * 
 * =================
 */
staticfnc void UpdateEntLump(bspBase bspMem, mapBase mapMem, char *bspName)
{
  int m, entNum;
  char mod[80];
  HANDLE bspFile;

  m = 1;
  for (entNum = 1; entNum < mapMem->nummapentities; entNum++) {
    if (!mapMem->mapentities[entNum].brushes)
      continue;
    sprintf(mod, "*%i", m);
    SetKeyValue(&mapMem->mapentities[entNum], "model", mod);
    m++;
  }

  mprintf("    - updating mapentities lump...\n");

  FreeBSPClusters(bspMem, 0);
  FreeMapClusters(mapMem, 0);
  if ((bspFile = __open(bspName, H_READWRITE_BINARY_OLD)) > 0) {
    bspMem = LoadBSP(bspFile, ALL_QUAKE1_LUMPS, BSP_VERSION_Q1);
    WriteEntitiesToString(bspMem, mapMem);
    WriteBSP(bspMem, bspFile, BSP_VERSION_Q1);
    FreeBSPClusters(bspMem, 0);
    FreeMapClusters(mapMem, 0);
    tfree(bspMem);
    __close(bspFile);
  }
}

/*=========================================================================== */

/*
 * =================
 * WriteClipHull
 * 
 * Write the clipping hull out to a text file so the parent process can get it
 * =================
 */
staticfnc void WriteClipHull(bspBase bspMem, char *hullName, register int hullNum)
{
  FILE *f;
  int i;
  struct dplane_t *p;
  struct dclipnode_t *d;

  hullName[strlen(hullName) - 1] = '0' + hullNum;

  mprintf("----- WriteClipHull -----\n");
  mprintf("    - writing %s\n", hullName);

  f = __fopen(hullName, "w");
  if (!f)
    Error(failed_fileopen, hullName);

  fprintf(f, "%i\n", bspMem->shared.quake1.nummodels);

  for (i = 0; i < bspMem->shared.quake1.nummodels; i++)
    fprintf(f, "%i\n", bspMem->shared.quake1.dmodels[i].headnode[hullNum]);

  fprintf(f, "\n%i\n", bspMem->shared.quake1.numclipnodes);

  for (i = 0; i < bspMem->shared.quake1.numclipnodes; i++) {
    d = &bspMem->shared.quake1.dclipnodes[i];
    p = &bspMem->shared.quake1.dplanes[d->planenum];
    /* the node number is only written out for human readability */
    fprintf(f, "%5i : " VEC_CONV1D " " VEC_CONV1D " " VEC_CONV1D " " VEC_CONV1D " : %5i %5i\n", i, p->normal[0], p->normal[1], p->normal[2], p->dist, d->children[0], d->children[1]);
  }

  __fclose(f);
}

/*
 * =================
 * ReadClipHull
 * 
 * Read the files written out by the child processes
 * =================
 */
staticfnc void ReadClipHull(bspBase bspMem, char *hullName, register int hullNum)
{
  FILE *f;
  int i, j, n;
  int firstclipnode;
  struct dplane_t p;
  struct dclipnode_t *d;
  int c1, c2;
  vec1D f1, f2, f3, f4;
  int junk;
  vec3D norm;

  hullName[strlen(hullName) - 1] = '0' + hullNum;

  f = __fopen(hullName, "r");
  if (!f)
    Error(failed_fileopen, hullName);

  if (fscanf(f, "%i\n", &n) != 1)
    Error("Error parsing %s", hullName);

  if (n != bspMem->shared.quake1.nummodels)
    Error("ReadClipHull: hull had %i models, base had %i", n, bspMem->shared.quake1.nummodels);

  for (i = 0; i < n; i++) {
    fscanf(f, "%i\n", &j);
    bspMem->shared.quake1.dmodels[i].headnode[hullNum] = bspMem->shared.quake1.numclipnodes + j;
  }

  fscanf(f, "\n%i\n", &n);
  firstclipnode = bspMem->shared.quake1.numclipnodes;

  for (i = 0; i < n; i++) {
    if (bspMem->shared.quake1.numclipnodes == bspMem->shared.quake1.max_numclipnodes)
      ExpandBSPClusters(bspMem, LUMP_CLIPNODES);
    d = &bspMem->shared.quake1.dclipnodes[bspMem->shared.quake1.numclipnodes];
    bspMem->shared.quake1.numclipnodes++;
    if (fscanf(f, "%i : " VEC_CONV1D " " VEC_CONV1D " " VEC_CONV1D " " VEC_CONV1D " : %i %i\n", &junk, &f1, &f2, &f3, &f4, &c1, &c2) != 7)
      Error("Error parsing %s", hullName);

    p.normal[0] = f1;
    p.normal[1] = f2;
    p.normal[2] = f3;
    p.dist = f4;

    norm[0] = f1;
    norm[1] = f2;
    norm[2] = f3;						/* vec1D precision */

    p.type = PlaneTypeForNormal(norm);

    d->children[0] = c1 >= 0 ? c1 + firstclipnode : c1;
    d->children[1] = c2 >= 0 ? c2 + firstclipnode : c2;
    d->planenum = FindFinalPlane(bspMem, &p);
  }

}

/*
 * =================
 * CreateSingleHull
 * 
 * =================
 */
staticfnc void CreateSingleHull(bspBase bspMem, mapBase mapMem, char *hullName, register int hullNum)
{
  int entNum;

  /* for each entity in the map file that has geometry */
  for (entNum = 0; entNum < mapMem->nummapentities; entNum++)
    ProcessEntity(bspMem, mapMem, hullName, hullNum, entNum);

  if (hullNum)
    WriteClipHull(bspMem, hullName, hullNum);
}

/*
 * =================
 * CreateHulls
 * 
 * =================
 */
staticfnc void CreateHulls(bspBase bspMem, mapBase mapMem, char *hullName, register int hullNum)
{
  /* commanded to create a single hull only */
  if (hullNum) {
    CreateSingleHull(bspMem, mapMem, hullName, hullNum);
    exit(0);
  }

  /* commanded to use the allready existing hulls 1 and 2 */
  if (mapMem->mapOptions & QBSP_USEHULLS) {
    CreateSingleHull(bspMem, mapMem, hullName, hullNum);
    return;
  }

  /* commanded to ignore the hulls altogether */
  if (mapMem->mapOptions & QBSP_NOCLIP) {
    CreateSingleHull(bspMem, mapMem, hullName, hullNum);
    return;
  }

  /* create all the hulls */

  /* create the hulls sequentially */
  mprintf("    - building hulls sequentially...\n");

  hullNum = 1;
  CreateSingleHull(bspMem, mapMem, hullName, hullNum);

  bspMem->shared.quake1.nummodels = 0;
  bspMem->shared.quake1.numplanes = 0;
  bspMem->shared.quake1.numclipnodes = 0;
  hullNum = 2;
  CreateSingleHull(bspMem, mapMem, hullName, hullNum);

  bspMem->shared.quake1.nummodels = 0;
  bspMem->shared.quake1.numplanes = 0;
  bspMem->shared.quake1.numclipnodes = 0;
  hullNum = 0;
  CreateSingleHull(bspMem, mapMem, hullName, hullNum);
}

/*
 * =================
 * ProcessMem
 * =================
 */
staticfnc void ProcessMem(bspBase bspMem, mapBase mapMem, register char *filebase, register int hullNum)
{
  char bspName[NAMELEN_PATH], hullName[NAMELEN_PATH];

  /* create filenames */
  __strcpy(bspName, filebase);
  ReplaceExt(bspName, "bsp");
  __strcpy(hullName, filebase);
  ReplaceExt(hullName, "h0");

  if (mapMem->mapOptions & QBSP_ONLYENTS)
    UpdateEntLump(bspMem, mapMem, bspName);
  else {
    if (!(mapMem->mapOptions & QBSP_USEHULLS)) {
      hullName[strlen(hullName) - 1] = '1';
      remove(hullName);
      hullName[strlen(hullName) - 1] = '2';
      remove(hullName);
    }

    /* the clipping hulls will be written out to text files by forked processes */
    CreateHulls(bspMem, mapMem, hullName, hullNum);

    ReadClipHull(bspMem, hullName, 1);
    ReadClipHull(bspMem, hullName, 2);

    WriteEntitiesToString(bspMem, mapMem);
  }
}

bool qbsp(bspBase bspMem, mapBase mapMem, int hullNum, int subDivide, char *filebase)
{
  if (hullNum) {
    hullNum = hullNum;
    mprintf("use hull %d\n", hullNum);
  }
  if (subDivide) {
    subdivide_size = subDivide;
    mprintf("subdivide %d\n", subDivide);
  }

  ProcessMem(bspMem, mapMem, filebase, hullNum);
  PrintMemory();

  return TRUE;
}
