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

/*
 * =================
 * Cmd_Base
 * =================
 */
staticfnc void Cmd_MDLBase(mdlBase mdlMem)
{
  int i, j, k;

  GetToken(FALSE);
  /* load the base triangles */
  LoadTriangles(mdlMem, token);
  mprintf("    - NUMBER OF TRIANGLES (including degenerate triangles): %d\n", mdlMem->numtriangles);

  /*
   * run through all the base triangles, storing each unique vertex in the
   * base vertex list and setting the indirect triangles to point to the base
   * vertices
   */
  for (i = 0; i < mdlMem->numtriangles; i++) {
    if (VectorCompare(mdlMem->tris[i].verts[0], mdlMem->tris[i].verts[1]) ||
	VectorCompare(mdlMem->tris[i].verts[1], mdlMem->tris[i].verts[2]) ||
	VectorCompare(mdlMem->tris[i].verts[2], mdlMem->tris[i].verts[0])) {
      degeneratetris++;
      mdlMem->degenerate[i] = TRUE;
    }
    else
      mdlMem->degenerate[i] = FALSE;

    for (j = 0; j < 3; j++) {
      for (k = 0; k < mdlMem->numverts; k++)
	if (VectorCompare(mdlMem->tris[i].verts[j], mdlMem->baseverts[k]))
	  break;						/* this vertex is already in the base vertex list */

      if (k == mdlMem->numverts) {
	/* new vertex */
	VectorCopy(mdlMem->tris[i].verts[j], mdlMem->baseverts[mdlMem->numverts]);
	mdlMem->numverts++;
      }

      mdlMem->triangles[i].vertindex[j] = k;
    }
  }

  mprintf("    - NUMBER OF VERTEXES: %i\n", mdlMem->numverts);

  /* calculate s & t for each vertex, and set the skin width and height */
  SetSkinValues(mdlMem);
}

/*
 * ===============
 * Cmd_Skin
 * ===============
 */
staticfnc void Cmd_MDLSkin(mdlBase mdlMem)
{
  struct palpic *pskinbitmap;
  FILE *pskinfile;
  unsigned char *ptemp1, *ptemp2;
  int i;

  GetToken(FALSE);
  if (TokenAvailable()) {
    GetToken(FALSE);
    mdlMem->skins[mdlMem->numskins].interval = atof(token);
    if (mdlMem->skins[mdlMem->numskins].interval <= 0.0)
      Error("Non-positive interval");
  }
  else
    mdlMem->skins[mdlMem->numskins].interval = 0.1;

  /* load in the skin file */
  if (!(pskinfile = __fopen(token, F_READ_BINARY)))
    Error(failed_fileopen, token);
  if (!(pskinbitmap = GetImage(pskinfile, 0, -mdlMem->header.skinwidth, -mdlMem->header.skinheight)))
    Error(failed_fileload, token);
  __fclose(pskinfile);

  /*
   * now copy the part of the texture we care about, since LBMs are always
   * loaded as 320x200 bitmaps
   */
  mdlMem->header.skinwidth = pskinbitmap->width;
  mdlMem->header.skinheight = pskinbitmap->height;
  if (!(mdlMem->skins[mdlMem->numskins].pdata = tmalloc(mdlMem->header.skinwidth * mdlMem->header.skinheight)))
    Error("couldn't get memory for skin texture");

  ptemp1 = mdlMem->skins[mdlMem->numskins].pdata;
  ptemp2 = &pskinbitmap->rawdata[0];

  for (i = 0; i < mdlMem->header.skinheight; i++) {
    __memcpy(ptemp1, ptemp2, mdlMem->header.skinwidth);
    ptemp1 += mdlMem->header.skinwidth;
    ptemp2 += 320;
  }

  if (mdlMem->numskins >= mdlMem->max_numskins)
    ExpandMDLClusters(mdlMem, MODEL_SKINS);
  mdlMem->numskins++;
  
  pfree(pskinbitmap);
}

/*
 * ===============
 * Cmd_Frame    
 * ===============
 */
staticfnc void Cmd_MDLFrame(mdlBase mdlMem, int isgroup)
{
  while (TokenAvailable()) {
    GetToken(FALSE);
    GrabFrame(mdlMem, token, isgroup);

    if (!isgroup)
      mdlMem->numframes++;
  }
}

/*
 * ===============
 * Cmd_SkinGroupStart   
 * ===============
 */
staticfnc void Cmd_MDLSkinGroupStart(mdlBase mdlMem)
{
  int groupskin;

  if (mdlMem->numskins >= mdlMem->max_numskins)
    ExpandMDLClusters(mdlMem, MODEL_SKINS);
  groupskin = mdlMem->numskins++;

  mdlMem->skins[groupskin].type = MDL_SKIN_GROUP;
  mdlMem->skins[groupskin].numgroupskins = 0;

  while (1) {
    GetToken(TRUE);
    if (endofscript)
      Error("End of file during group");

    if (!__strcmp(token, "$skin")) {
      Cmd_MDLSkin(mdlMem);
      mdlMem->skins[groupskin].numgroupskins++;
    }
    else if (!__strcmp(token, "$skingroupend"))
      break;
    else
      Error("$skin or $skingroupend expected\n");
  }

  if (mdlMem->skins[groupskin].numgroupskins == 0)
    Error("Empty group\n");
}

/*
 * ===============
 * Cmd_FrameGroupStart  
 * ===============
 */
staticfnc void Cmd_MDLFrameGroupStart(mdlBase mdlMem)
{
  int groupframe;

  if (mdlMem->numframes >= mdlMem->max_numframes)
    ExpandMDLClusters(mdlMem, MODEL_FRAMES);
  groupframe = mdlMem->numframes++;

  mdlMem->frames[groupframe].type = MDL_GROUP;
  mdlMem->frames[groupframe].numgroupframes = 0;

  while (1) {
    GetToken(TRUE);
    if (endofscript)
      Error("End of file during group");

    if (!__strcmp(token, "$frame"))
      Cmd_MDLFrame(mdlMem, 1);
    else if (!__strcmp(token, "$framegroupend"))
      break;
    else
      Error("$frame or $framegroupend expected\n");
  }

  mdlMem->frames[groupframe].numgroupframes += mdlMem->numframes - groupframe - 1;

  if (mdlMem->frames[groupframe].numgroupframes == 0)
    Error("Empty group\n");
}

/*
 * =================
 * Cmd_Origin
 * =================
 */
staticfnc void Cmd_MDLOrigin(mdlBase mdlMem)
{
  /*
   * rotate points into frame of reference so model points down the positive x
   * axis
   */
  GetToken(FALSE);
  adjust[1] = -atof(token);

  GetToken(FALSE);
  adjust[0] = atof(token);

  GetToken(FALSE);
  adjust[2] = -atof(token);
}

/*
 * =================
 * Cmd_Eyeposition
 * =================
 */
staticfnc void Cmd_MDLEyeposition(mdlBase mdlMem)
{
  /*
   * rotate points into frame of reference so model points down the positive x
   * axis 
   */
  GetToken(FALSE);
  mdlMem->header.eyeposition[1] = atof(token);

  GetToken(FALSE);
  mdlMem->header.eyeposition[0] = -atof(token);

  GetToken(FALSE);
  mdlMem->header.eyeposition[2] = atof(token);
}

/*
 * =================
 * Cmd_ScaleUp
 * =================
 */
staticfnc void Cmd_MDLScaleUp(mdlBase mdlMem)
{
  GetToken(FALSE);
  scale_up = atof(token);
}

/*
 * =================
 * Cmd_Flags
 * =================
 */
staticfnc void Cmd_MDLFlags(mdlBase mdlMem)
{
  GetToken(FALSE);
  mdlMem->header.flags = atoi(token);
}

/*
 * =================
 * Cmd_Modelname
 * =================
 */
staticfnc char *Cmd_MDLName(mdlBase mdlMem, char *filebase)
{
  WriteModel(mdlMem, filebase);
  GetToken(FALSE);
  return smalloc(token);
}
