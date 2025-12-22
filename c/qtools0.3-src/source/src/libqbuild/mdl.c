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
#define	LIBQBUILD_CORE
#include "../include/libqtools.h"
#include "../include/libqbuild.h"
#include "./qccparse.h"

/*
 * modelgen.c: generates a .mdl file from a base triangle file (.tri), a
 * texture containing front and back skins (.lbm), and a series of frame
 * triangle files (.tri). Result is stored in
 * /raid/quake/models/<scriptname>.mdl.
 */

vec1D scale, scale_up = 1.0;
vec3D mins, maxs;
vec3D framesmins, framesmaxs;
vec3D adjust;

/* base frame info */
int degeneratetris;
int firstframe = 1;
vec1D totsize, averagesize;

const vec3D avertexnormals[NUMVERTEXNORMALS] =
{
#include "anorms.h"
};

/*============================================================================ */

void ClearModel(mdlBase mdlMem)
{
  __bzero(&mdlMem->header, sizeof(struct dmdlheader));
  mdlMem->header.synctype = ST_RAND;					/* default */
  mdlMem->numframes = mdlMem->numskins = 0;

  scale = 0;
  scale_up = 1.0;

  VectorClear(adjust);
  VectorClear(mins);
  VectorClear(maxs);
  VectorClear(framesmins);
  VectorClear(framesmaxs);

  degeneratetris = 0;
  firstframe = 1;
  totsize = 0.0;
}

/*
 * ============
 * SetSkinValues
 * 
 * Called for the base frame
 * ============
 */
void SetSkinValues(mdlBase mdlMem)
{
  int i;
  vec1D v;
  int width, height, iwidth, iheight, skinwidth;
  vec1D basex, basey;

  mins[0] = mins[1] = mins[2] = VEC_POSMAX;
  maxs[0] = maxs[1] = maxs[2] = VEC_NEGMAX;

  for (i = 0; i < mdlMem->numverts; i++) {
    int j;

    mdlMem->stverts[i].onseam = 0;

    for (j = 0; j < 3; j++) {
      v = mdlMem->baseverts[i][j];
      if (v < mins[j])
	mins[j] = v;
      if (v > maxs[j])
	maxs[j] = v;
    }
  }

  mins[0] = mins[1] = mins[2] = floor(mins[i]);
  maxs[0] = maxs[1] = maxs[2] = ceil(maxs[i]);

  width = maxs[0] - mins[0];
  height = maxs[2] - mins[2];

  mprintf("    - width: %i  height: %i\n", width, height);

  scale = 8;
  if (width * scale >= 150)
    scale = 150.0 / width;
  if (height * scale >= 190)
    scale = 190.0 / height;
  iwidth = ceil(width * scale) + 4;
  iheight = ceil(height * scale) + 4;

  mprintf("    - scale: " VEC_CONV1D "\n", scale);
  mprintf("    - iwidth: %i  iheight: %i\n", iwidth, iheight);

  /* determine which side of each triangle to map the texture to */
  for (i = 0; i < mdlMem->numtriangles; i++) {
    int j;
    vec3D vtemp1, vtemp2, normal;

    VectorSubtract(mdlMem->baseverts[mdlMem->triangles[i].vertindex[0]],
		   mdlMem->baseverts[mdlMem->triangles[i].vertindex[1]], vtemp1);
    VectorSubtract(mdlMem->baseverts[mdlMem->triangles[i].vertindex[2]],
		   mdlMem->baseverts[mdlMem->triangles[i].vertindex[1]], vtemp2);
    CrossProduct(vtemp1, vtemp2, normal);

    if (normal[1] > 0) {
      basex = iwidth + 2;
      mdlMem->triangles[i].facesfront = 0;
    }
    else {
      basex = 2;
      mdlMem->triangles[i].facesfront = 1;
    }
    basey = 2;

    for (j = 0; j < 3; j++) {
      vec1D *pbasevert;
      struct stvert *pstvert;

      pbasevert = mdlMem->baseverts[mdlMem->triangles[i].vertindex[j]];
      pstvert = &mdlMem->stverts[mdlMem->triangles[i].vertindex[j]];

      if (mdlMem->triangles[i].facesfront)
	pstvert->onseam |= 1;
      else
	pstvert->onseam |= 2;

      if ((mdlMem->triangles[i].facesfront) || ((pstvert->onseam & 1) == 0)) {
	/* we want the front s value for seam vertices */
	pstvert->s = rint((pbasevert[0] - mins[0]) * scale + basex);
	pstvert->t = rint((maxs[2] - pbasevert[2]) * scale + basey);
      }
    }
  }

  /*
   * make the width a multiple of 4; some hardware requires this, and it ensures
   * dword alignment for each scan
   */
  skinwidth = iwidth * 2;
  mdlMem->header.skinwidth = (skinwidth + 3) & ~3;
  mdlMem->header.skinheight = iheight;

  mprintf("    - skin width: %i (unpadded width %i)\n    - skin height: %i\n",
	  mdlMem->header.skinwidth, skinwidth, mdlMem->header.skinheight);
}

/*
 * ===============
 * GrabFrame
 * ===============
 */
void GrabFrame(mdlBase mdlMem, char *frame, int isgroup)
{
  int i, j;
  struct trivert *ptrivert;
  int numtriangles;

  mdlMem->frames[mdlMem->numframes].interval = 0.1;
  __strcpy(mdlMem->frames[mdlMem->numframes].name, frame);

  /* load the frame */
  numtriangles = mdlMem->numtriangles;
  mdlMem->numtriangles = 0;
  LoadTriangles(mdlMem, frame);
  if (numtriangles != mdlMem->numtriangles)
    Error("number of triangles doesn't match\n");

  /* set the intervals */
  if (isgroup && TokenAvailable()) {
    GetToken(FALSE);
    mdlMem->frames[mdlMem->numframes].interval = atof(token);
    if (mdlMem->frames[mdlMem->numframes].interval <= 0.0)
      Error("Non-positive interval %s " VEC_CONV1D "", token, mdlMem->frames[mdlMem->numframes].interval);
  }
  else
    mdlMem->frames[mdlMem->numframes].interval = 0.1;

  /* allocate storage for the frame's vertices */
  ptrivert = mdlMem->verts[mdlMem->numframes];

  mdlMem->frames[mdlMem->numframes].pdata = ptrivert;
  mdlMem->frames[mdlMem->numframes].type = MDL_SINGLE;

  for (i = 0; i < mdlMem->numverts; i++)
    mdlMem->vnorms[i].numnormals = 0;

  /*
   * store the frame's vertices in the same order as the base. This assumes the
   * triangles and vertices in this frame are in exactly the same order as in the
   * base
   */
  for (i = 0; i < numtriangles; i++) {
    vec3D vtemp1, vtemp2, normal;
    vec1D ftemp;

    if (mdlMem->degenerate[i])
      continue;

    if (firstframe) {
      VectorSubtract(mdlMem->tris[i].verts[0], mdlMem->tris[i].verts[1], vtemp1);
      VectorSubtract(mdlMem->tris[i].verts[2], mdlMem->tris[i].verts[1], vtemp2);
      VectorScale(vtemp1, scale_up, vtemp1);
      VectorScale(vtemp2, scale_up, vtemp2);
      CrossProduct(vtemp1, vtemp2, normal);

      totsize += VectorLength(normal) / 2;
    }

    VectorSubtract(mdlMem->tris[i].verts[0], mdlMem->tris[i].verts[1], vtemp1);
    VectorSubtract(mdlMem->tris[i].verts[2], mdlMem->tris[i].verts[1], vtemp2);
    CrossProduct(vtemp1, vtemp2, normal);

    VectorNormalize(normal);

    /* rotate the normal so the model faces down the positive x axis */
    ftemp = normal[0];
    normal[0] = -normal[1];
    normal[1] = ftemp;

    for (j = 0; j < 3; j++) {
      int k;
      int vertindex;

      vertindex = mdlMem->triangles[i].vertindex[j];

      /*
       * rotate the vertices so the model faces down the positive x axis
       * also adjust the vertices to the desired origin
       */
      ptrivert[vertindex].v[0] = ((-mdlMem->tris[i].verts[j][1]) * scale_up) + adjust[0];
      ptrivert[vertindex].v[1] = (  mdlMem->tris[i].verts[j][0]  * scale_up) + adjust[1];
      ptrivert[vertindex].v[2] = (  mdlMem->tris[i].verts[j][2]  * scale_up) + adjust[2];

      for (k = 0; k < 3; k++) {
	if (ptrivert[vertindex].v[k] < framesmins[k])
	  framesmins[k] = ptrivert[vertindex].v[k];
	if (ptrivert[vertindex].v[k] > framesmaxs[k])
	  framesmaxs[k] = ptrivert[vertindex].v[k];
      }

      VectorCopy(normal, mdlMem->vnorms[vertindex].normals[mdlMem->vnorms[vertindex].numnormals]);
      mdlMem->vnorms[vertindex].numnormals++;
    }
  }

  /*
   * calculate the vertex normals, match them to the template list, and store the
   * index of the best match
   */
  for (i = 0; i < mdlMem->numverts; i++) {
    int j;
    vec3D v;
    vec1D maxdot;
    int maxdotindex;

    if (mdlMem->vnorms[i].numnormals > 0) {
      for (j = 0; j < 3; j++) {
	int k;

	v[j] = 0;
	for (k = 0; k < mdlMem->vnorms[i].numnormals; k++)
	  v[j] += mdlMem->vnorms[i].normals[k][j];
	v[j] /= mdlMem->vnorms[i].numnormals;
      }
    }
    else
      Error("Vertex with no non-degenerate triangles attached");

    VectorNormalize(v);

    maxdot = VEC_NEGMAX;
    maxdotindex = -1;

    for (j = NUMVERTEXNORMALS - 1; j >= 0; j--) {
      vec1D dot;

      if ((dot = DotProduct(v, avertexnormals[j])) > maxdot) {
	maxdot = dot;
	maxdotindex = j;
      }
    }

    ptrivert[i].lightnormalindex = maxdotindex;
  }

  if (mdlMem->numframes >= mdlMem->max_numframes)
    ExpandMDLClusters(mdlMem, MODEL_FRAMES);
  mdlMem->numframes++;

  firstframe = 0;
}

/*
 * ==============
 * main
 * ==============
 */
void mdlgen(mdlBase mdlMem, char *mdlBuf)
{
  char *filebase;

  StartTokenParsing(mdlBuf);

  framesmins[0] = framesmins[1] = framesmins[2] = VEC_POSMAX;
  framesmaxs[0] = framesmaxs[1] = framesmaxs[2] = VEC_NEGMAX;

  ClearModel(mdlMem);
  filebase = ParseScript(PARSE_MODEL, mdlMem, 0);
  WriteModel(mdlMem, filebase);
}
