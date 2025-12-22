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

/*
 * ============
 * WriteFrame
 * ============
 */
staticfnc void WriteMDLFrame(mdlBase mdlMem, HANDLE mdlFile, int framenum)
{
  int j, k;
  struct trivert *pframe;
  struct daliasframe aframe;
  vec1D v;

  pframe = mdlMem->verts[framenum];

  __strcpy(aframe.name, mdlMem->frames[framenum].name);

  aframe.bboxmin.v[0] = aframe.bboxmin.v[1] = aframe.bboxmin.v[2] = 255;
  aframe.bboxmax.v[0] = aframe.bboxmax.v[1] = aframe.bboxmax.v[2] = 0;

  for (j = 0; j < mdlMem->numverts; j++) {
    /* all of these are byte values, so no need to deal with endianness */
    mdlMem->tarray[j].lightnormalindex = pframe[j].lightnormalindex;

    if (mdlMem->tarray[j].lightnormalindex > NUMVERTEXNORMALS)
      Error("invalid lightnormalindex %d\n", mdlMem->tarray[j].lightnormalindex);

    for (k = 0; k < 3; k++) {
      /* scale to byte values & min/max check */
      v = (pframe[j].v[k] - mdlMem->header.scale_origin[k]) / mdlMem->header.scale[k];

      mdlMem->tarray[j].v[k] = v;

      if (mdlMem->tarray[j].v[k] < aframe.bboxmin.v[k])
	aframe.bboxmin.v[k] = mdlMem->tarray[j].v[k];
      if (mdlMem->tarray[j].v[k] > aframe.bboxmax.v[k])
	aframe.bboxmax.v[k] = mdlMem->tarray[j].v[k];
    }
  }

  __write(mdlFile, &aframe, sizeof(aframe));
  __write(mdlFile, &mdlMem->tarray[0], mdlMem->numverts * sizeof(mdlMem->tarray[0]));
}

/*
 * ============
 * WriteGroupBBox
 * ============
 */
staticfnc void WriteGroupBBox(mdlBase mdlMem, HANDLE mdlFile, int numframes, int curframe)
{
  int i, j, k;
  struct daliasgroup dagroup;
  struct trivert *pframe;

  dagroup.numframes = LittleLong(numframes);

  dagroup.bboxmin.v[0] = dagroup.bboxmin.v[1] = dagroup.bboxmin.v[2] = 255;
  dagroup.bboxmax.v[0] = dagroup.bboxmax.v[1] = dagroup.bboxmax.v[2] = 0;

  for (i = 0; i < numframes; i++) {
    pframe = (struct trivert *)mdlMem->frames[curframe].pdata;

    for (j = 0; j < mdlMem->numverts; j++) {
      for (k = 0; k < 3; k++) {
	/* scale to byte values & min/max check */
	mdlMem->tarray[j].v[k] = (pframe[j].v[k] - mdlMem->header.scale_origin[k]) / mdlMem->header.scale[k];
	if (mdlMem->tarray[j].v[k] < dagroup.bboxmin.v[k])
	  dagroup.bboxmin.v[k] = mdlMem->tarray[j].v[k];
	if (mdlMem->tarray[j].v[k] > dagroup.bboxmax.v[k])
	  dagroup.bboxmax.v[k] = mdlMem->tarray[j].v[k];
      }
    }

    curframe++;
  }

  __write(mdlFile, &dagroup, sizeof(dagroup));
}

/*
 * ============
 * WriteModel
 * ============
 */
staticfnc bool WriteModelFile(mdlBase mdlMem, HANDLE mdlFile)
{
  int i, curframe, curskin;
  vec3D dist;
  struct dmdlheader modeltemp;

  /* Calculate the bounding box for this model */
  for (i = 0; i < 3; i++) {
    mprintf("    - framesmins[%d]: " VEC_CONV1D ", framesmaxs[%d]: " VEC_CONV1D "\n", i, framesmins[i], i, framesmaxs[i]);
    if (fabs(framesmins[i]) > fabs(framesmaxs[i]))
      dist[i] = framesmins[i];
    else
      dist[i] = framesmaxs[i];

    mdlMem->header.scale[i] = (framesmaxs[i] - framesmins[i]) / 255.9;
    mdlMem->header.scale_origin[i] = framesmins[i];
  }

  mdlMem->header.boundingradius = VectorLength(dist);

  /* write out the model header */
  modeltemp.ident = LittleLong(MAGIC_MDL_Q1);
  modeltemp.version = LittleLong(MDL_VERSION_Q1);
  modeltemp.boundingradius = LittleFloat(mdlMem->header.boundingradius);

  for (i = 0; i < 3; i++) {
    modeltemp.scale[i] = LittleFloat(mdlMem->header.scale[i]);
    modeltemp.scale_origin[i] = LittleFloat(mdlMem->header.scale_origin[i]);
    modeltemp.eyeposition[i] = LittleFloat(mdlMem->header.eyeposition[i] + adjust[i]);
  }

  modeltemp.flags = LittleLong(mdlMem->header.flags);
  modeltemp.numskins = LittleLong(mdlMem->numskins);
  modeltemp.skinwidth = LittleLong(mdlMem->header.skinwidth);
  modeltemp.skinheight = LittleLong(mdlMem->header.skinheight);
  modeltemp.numverts = LittleLong(mdlMem->numverts);
  modeltemp.numtris = LittleLong(mdlMem->numtriangles - degeneratetris);
  modeltemp.numframes = LittleLong(mdlMem->numframes);
  modeltemp.synctype = LittleFloat(mdlMem->header.synctype);
  averagesize = totsize / mdlMem->numtriangles;
  modeltemp.size = LittleFloat(averagesize);

  __write(mdlFile, &modeltemp, sizeof(struct dmdlheader));

  /* write out the skins */
  curskin = 0;

  for (i = 0; i < mdlMem->numskins; i++, curskin++) {
    __write(mdlFile, &mdlMem->skins[curskin].type, sizeof(mdlMem->skins[curskin].type));
    __write(mdlFile, mdlMem->skins[curskin].pdata, mdlMem->header.skinwidth * mdlMem->header.skinheight);
  }

  /* write out the base model (the s & t coordinates for the vertices) */
  for (i = 0; i < mdlMem->numverts; i++) {
    if (mdlMem->stverts[i].onseam == 3)
      mdlMem->stverts[i].onseam = LittleLong(MDL_ONSEAM);
    else
      mdlMem->stverts[i].onseam = LittleLong(0);

    mdlMem->stverts[i].s = LittleLong(mdlMem->stverts[i].s);
    mdlMem->stverts[i].t = LittleLong(mdlMem->stverts[i].t);
  }

  __write(mdlFile, mdlMem->stverts, mdlMem->numverts * sizeof(mdlMem->stverts[0]));

  /* write out the triangles */
  for (i = 0; i < mdlMem->numtriangles; i++) {
    struct dtriangle tri;

    if (!mdlMem->degenerate[i]) {
      tri.facesfront   = LittleLong(mdlMem->triangles[i].facesfront);
      tri.vertindex[0] = LittleLong(mdlMem->triangles[i].vertindex[0]);
      tri.vertindex[1] = LittleLong(mdlMem->triangles[i].vertindex[1]);
      tri.vertindex[2] = LittleLong(mdlMem->triangles[i].vertindex[2]);
      __write(mdlFile, &tri, sizeof(tri));
    }
  }

  /* write out the frames */
  curframe = 0;

  for (i = 0; i < mdlMem->numframes; i++) {
    __write(mdlFile, &mdlMem->frames[curframe].type, sizeof(mdlMem->frames[curframe].type));

    if (mdlMem->frames[curframe].type == MDL_SINGLE) {
      /* single (non-grouped) frame */
      WriteMDLFrame(mdlMem, mdlFile, curframe);
      curframe++;
    }
    else {
      int j, numframes, groupframe;
      vec1D totinterval;

      groupframe = curframe;
      curframe++;
      numframes = mdlMem->frames[groupframe].numgroupframes;

      /* set and write the group header */
      WriteGroupBBox(mdlMem, mdlFile, numframes, curframe);

      /* write the interval array */
      totinterval = 0.0;

      for (j = 0; j < numframes; j++) {
	struct daliasinterval temp;

	totinterval += mdlMem->frames[groupframe + 1 + j].interval;
	temp.interval = LittleFloat(totinterval);

	__write(mdlFile, &temp, sizeof(temp));
      }

      for (j = 0; j < numframes; j++, curframe++)
	WriteMDLFrame(mdlMem, mdlFile, curframe);
    }
  }
  
  return TRUE;
}

/*
 * ===============
 * WriteModel
 * ===============
 */
bool WriteModel(mdlBase mdlMem, char *filebase)
{
  bool success = FALSE;

  /* write the model output file */
  if (mdlMem->numframes &&
      mdlMem->numskins &&
      filebase) {
    HANDLE mdlFile;

    ReplaceExt(filebase, "mdl");

    mprintf("---------------------\n");
    mprintf("    - writing %s:\n", filebase);
    if((mdlFile = __open(filebase, H_WRITE_BINARY)) > 0) {
      if(WriteModelFile(mdlMem, mdlFile)) {
        mprintf("    - %4d frame(s)\n", mdlMem->numframes);
        mprintf("    - %4d ungrouped frame(s), including group headers\n", mdlMem->numframes);
        mprintf("    - %4d skin(s)\n", mdlMem->numskins);
        mprintf("    - %4d degenerate triangles(s) removed\n", degeneratetris);
        mprintf("    - %4d triangles emitted\n", mdlMem->numtriangles - degeneratetris);
        mprintf("    - pixels per triangle " VEC_CONV1D "\n", averagesize);

        mprintf("    - file size: %d\n", (int)__ltell(mdlFile));
        mprintf("---------------------\n");
        success = TRUE;
      }
      else
        eprintf("failed to save model to %s\n", filebase);
      __close(mdlFile);

      ClearModel(mdlMem);
    }
    else
      eprintf(failed_fileopen, filebase);
  }
  else
    eprintf("no frames/skins grabbed, no file generated\n");
  
  return success;
}
