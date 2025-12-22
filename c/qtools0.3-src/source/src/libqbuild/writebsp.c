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

staticvar int headclipnode;						/* 4 */
staticvar int firstface;						/* 4 */

staticvar int *planemapping;

/*=========================================================================== */

/*
 * ==================
 * FindFinalPlane
 * 
 * Used to find plane index numbers for clip nodes read from child processes
 * ==================
 */
int FindFinalPlane(bspBase bspMem, struct dplane_t *p)
{
  int i;
  struct dplane_t *dplane;

  for (i = 0, dplane = bspMem->shared.quake1.dplanes; i < bspMem->shared.quake1.numplanes; i++, dplane++) {
    if (p->type != dplane->type)
      continue;
    if (p->dist != dplane->dist)
      continue;
    if (p->normal[0] != dplane->normal[0])
      continue;
    if (p->normal[1] != dplane->normal[1])
      continue;
    if (p->normal[2] != dplane->normal[2])
      continue;
    return i;
  }

  /* new plane */
  if (bspMem->shared.quake1.numplanes == bspMem->shared.quake1.max_numplanes)
    ExpandBSPClusters(bspMem, LUMP_PLANES);
  dplane = &bspMem->shared.quake1.dplanes[bspMem->shared.quake1.numplanes];
  *dplane = *p;
  bspMem->shared.quake1.numplanes++;

  return bspMem->shared.quake1.numplanes - 1;
}

staticfnc void WriteNodePlanes_r(bspBase bspMem, mapBase mapMem, register struct node *node)
{
  struct plane *plane;
  struct dplane_t *dplane;

  if (node->planenum == -1)
    return;
  if (planemapping[node->planenum] == -1) {			/* a new plane */

    planemapping[node->planenum] = bspMem->shared.quake1.numplanes;

    if (bspMem->shared.quake1.numplanes == bspMem->shared.quake1.max_numplanes)
      ExpandBSPClusters(bspMem, LUMP_PLANES);
#ifdef EXHAUSIVE_CHECK
    if (node->planenum >= bspMem->numbrushplanes || node->planenum < 0)
      Error("looking for nonexisting plane %d\n", node->planenum);
#endif
    plane = &mapMem->brushplanes[node->planenum];
    dplane = &bspMem->shared.quake1.dplanes[bspMem->shared.quake1.numplanes];
    dplane->normal[0] = plane->normal[0];
    dplane->normal[1] = plane->normal[1];
    dplane->normal[2] = plane->normal[2];
    dplane->dist = plane->dist;
    dplane->type = plane->type;

    bspMem->shared.quake1.numplanes++;
  }

  node->outputplanenum = planemapping[node->planenum];

  WriteNodePlanes_r(bspMem, mapMem, node->children[0]);
  WriteNodePlanes_r(bspMem, mapMem, node->children[1]);
}

/*
 * ==================
 * WriteNodePlanes
 * 
 * ==================
 */
void WriteNodePlanes(bspBase bspMem, mapBase mapMem, struct node *nodes)
{
  if (!(planemapping = (int *)tmalloc(sizeof(int) * mapMem->numbrushplanes)))
    Error(failed_memoryunsize, "planemapping");
  memset(planemapping, -1, sizeof(int) * mapMem->numbrushplanes);

  WriteNodePlanes_r(bspMem, mapMem , nodes);
  tfree(planemapping);
}

/*=========================================================================== */

/*
 * ==================
 * WriteClipNodes_r
 * 
 * ==================
 */
staticfnc int WriteClipNodes_r(bspBase bspMem, register struct node *node)
{
  int c;
  short int i;
  struct dclipnode_t *cn;
  int num;

  /* FIXME: tfree more stuff?       */
  if (node->planenum == -1) {
    num = node->contents;
    tfree(node);
    return num;
  }

  if (bspMem->shared.quake1.numclipnodes == bspMem->shared.quake1.max_numclipnodes)
    ExpandBSPClusters(bspMem, LUMP_CLIPNODES);
  /* emit a clipnode */
  c = bspMem->shared.quake1.numclipnodes;
  cn = &bspMem->shared.quake1.dclipnodes[c];
  bspMem->shared.quake1.numclipnodes++;

  cn->planenum = node->outputplanenum;
  for (i = 0; i < 2; i++)
    cn->children[i] = WriteClipNodes_r(bspMem, node->children[i]);

  tfree(node);
  return c;
}

/*
 * ==================
 * WriteClipNodes
 * 
 * Called after the clipping hull is completed.  Generates a disk format
 * representation and frees the original memory.
 * ==================
 */
void WriteClipNodes(bspBase bspMem, struct node *nodes)
{
  headclipnode = bspMem->shared.quake1.numclipnodes;
  WriteClipNodes_r(bspMem, nodes);
}

/*=========================================================================== */

/*
 * ==================
 * WriteLeaf
 * ==================
 */
void WriteLeaf(bspBase bspMem, register struct node *node)
{
  struct visfacet **fp, *f;
  struct dleaf_t *leaf_p;

  /* emit a leaf */
  if (bspMem->shared.quake1.numleafs == bspMem->shared.quake1.max_numleafs)
    ExpandBSPClusters(bspMem, LUMP_LEAFS);
  leaf_p = &bspMem->shared.quake1.dleafs[bspMem->shared.quake1.numleafs];
  bspMem->shared.quake1.numleafs++;

  leaf_p->contents = node->contents;

  /* write bounding box info */
  VectorCopy(node->mins, leaf_p->mins);
  VectorCopy(node->maxs, leaf_p->maxs);

  leaf_p->visofs = -1;						/* no vis info yet */

  /* write the marksurfaces */
  leaf_p->firstmarksurface = bspMem->shared.quake1.nummarksurfaces;

  for (fp = node->markfaces; *fp; fp++) {
    /* emit a marksurface */
    f = *fp;
    do {
      if (bspMem->shared.quake1.nummarksurfaces == bspMem->shared.quake1.max_nummarksurfaces)
	ExpandBSPClusters(bspMem, LUMP_MARKSURFACES);
      bspMem->shared.quake1.dmarksurfaces[bspMem->shared.quake1.nummarksurfaces] = f->outputnumber;
      bspMem->shared.quake1.nummarksurfaces++;
      f = f->original;						/* grab tjunction split faces */
    } while (f);
  }

  leaf_p->nummarksurfaces = bspMem->shared.quake1.nummarksurfaces - leaf_p->firstmarksurface;
}

/*
 * ==================
 * WriteDrawNodes_r
 * ==================
 */
staticfnc void WriteDrawNodes_r(bspBase bspMem, register struct node *node)
{
  struct dnode_t *n;
  short int i;

  /* emit a node   */
  if (bspMem->shared.quake1.numnodes == bspMem->shared.quake1.max_numnodes)
    ExpandBSPClusters(bspMem, LUMP_NODES);
  n = &bspMem->shared.quake1.dnodes[bspMem->shared.quake1.numnodes];
  bspMem->shared.quake1.numnodes++;

  VectorCopy(node->mins, n->mins);
  VectorCopy(node->maxs, n->maxs);

  n->planenum = node->outputplanenum;
  n->firstface = node->firstface;
  n->numfaces = node->numfaces;

  /* recursively output the other nodes */
  for (i = 0; i < 2; i++) {
    if (node->children[i]->planenum == -1) {
      if (node->children[i]->contents == CONTENTS_SOLID)
	n->children[i] = -1;
      else {
	n->children[i] = -(bspMem->shared.quake1.numleafs + 1);
	WriteLeaf(bspMem, node->children[i]);
      }
    }
    else {
      n->children[i] = bspMem->shared.quake1.numnodes;
      WriteDrawNodes_r(bspMem, node->children[i]);
    }
  }
}

/*
 * ==================
 * WriteDrawNodes
 * ==================
 */
void WriteDrawNodes(bspBase bspMem, struct node *headnode)
{
  short int i;
  int start;
  struct dmodel_t *bm;

#if 0
  if (headnode->contents < 0)
    Error("FinishBSPModel: empty model");
#endif

  /* emit a model */
  if (bspMem->shared.quake1.nummodels == bspMem->shared.quake1.max_nummodels)
    ExpandBSPClusters(bspMem, LUMP_MODELS);
  bm = &bspMem->shared.quake1.dmodels[bspMem->shared.quake1.nummodels];
  bspMem->shared.quake1.nummodels++;

  bm->headnode[0] = bspMem->shared.quake1.numnodes;
  bm->firstface = firstface;
  bm->numfaces = bspMem->shared.quake1.numfaces - firstface;
  firstface = bspMem->shared.quake1.numfaces;

  start = bspMem->shared.quake1.numleafs;

  if (headnode->contents < 0)
    WriteLeaf(bspMem, headnode);
  else
    WriteDrawNodes_r(bspMem, headnode);
  bm->visleafs = bspMem->shared.quake1.numleafs - start;

  for (i = 0; i < 3; i++) {
    bm->mins[i] = headnode->mins[i] + SIDESPACE + 1;		/* remove the padding */
    bm->maxs[i] = headnode->maxs[i] - SIDESPACE - 1;
  }
  /* FIXME: are all the children decendant of padded nodes? */
}

/*
 * ==================
 * BumpModel
 * 
 * Used by the clipping hull processes that only need to store headclipnode
 * ==================
 */
void BumpModel(bspBase bspMem, int hullNum)
{
  struct dmodel_t *bm;

  /* emit a model */
  if (bspMem->shared.quake1.nummodels == bspMem->shared.quake1.max_nummodels)
    ExpandBSPClusters(bspMem, LUMP_MODELS);
  bm = &bspMem->shared.quake1.dmodels[bspMem->shared.quake1.nummodels];
  bspMem->shared.quake1.nummodels++;

  bm->headnode[hullNum] = headclipnode;
}

/*============================================================================= */

#define	MAX_MULTIPLE	32

bool completeSearch = FALSE;

/*
 * ==================
 * WriteMiptex
 * ==================
 */
void WriteMiptex(bspBase bspMem, mapBase mapMem)
{
  if (!(mapMem->mapOptions & QBSP_NOTEXTURES)) {
    struct wadheader Header[MAX_MULTIPLE + 1];
    struct wadentry *allEntries[MAX_MULTIPLE + 1];
    char *wadPath[MAX_MULTIPLE + 1];
    HANDLE wadFile[MAX_MULTIPLE + 1];
    int wadAvail = 0;

    char *dirPath[MAX_MULTIPLE + 1];
    DIR *dirDir[MAX_MULTIPLE + 1];
    int dirAvail = 0;

    /* TODO: multiple wadFiles */
    if (mapMem->mapentities) {
      wadPath[0] = ValueForKey(&mapMem->mapentities[0], "_wad");
      if (!wadPath[0] || !wadPath[0][0])
	wadPath[0] = ValueForKey(&mapMem->mapentities[0], "wad");
    }
    else
      wadPath[0] = 0;
    if (!wadPath[0] || !wadPath[0][0])
      wadPath[0] = getenv("QUAKE_WADFILE");

    if (wadPath[0] && wadPath[0][0]) {				/* do only if there exists really a wad */
      for (wadAvail = 0; wadAvail < MAX_MULTIPLE;) {
	char *hit;

	if ((hit = (char *)__strchr(wadPath[wadAvail], ';'))) {	/* cut off next entry */
	  *hit = ' ';
	  while ((hit[-1] == ' ') || (hit[-1] == '\t'))		/* delete whitespace */
	    hit--;
	  *hit++ = '\0';
	  while ((*hit == ' ') || (*hit == '\t'))		/* delete whitespace */
	    hit++;
	}
	oprintf("wadPath %2d: \"%s\"\n", wadAvail, wadPath[wadAvail]);

	if ((wadPath[wadAvail][0]) && (wadFile[wadAvail] = __open(wadPath[wadAvail], H_READ_BINARY)) > 0) {
	  if (CheckWAD2(wadFile[wadAvail], &Header[wadAvail], FALSE)) {
	    FindWAD2(wadFile[wadAvail], 0, &Header[wadAvail], &allEntries[wadAvail], 0);
	    wadAvail++;
	  }
	  else {
	    __close(wadFile[wadAvail]);
	    eprintf("file \"%s\" not a wad\n", wadPath[wadAvail]);
	  }
	}
	else
	  eprintf(failed_fileopen, wadPath[wadAvail]);

	if (!hit)						/* break if nothing more found */
	  break;
	else
	  wadPath[wadAvail] = hit;				/* register next entry */
      }
    }

    /* TODO: multiple dirDirs */
    if (mapMem->mapentities) {
      dirPath[0] = ValueForKey(&mapMem->mapentities[0], "_dir");
      if (!dirPath[0] || !dirPath[0][0])
	dirPath[0] = ValueForKey(&mapMem->mapentities[0], "dir");
    }
    else
      dirPath[0] = 0;
    if (!dirPath[0] || !dirPath[0][0])
      dirPath[0] = getenv("QUAKE_WADDIR");
    if (!dirPath[0] || !dirPath[0][0])
      dirPath[0] = "\0";

    for (dirAvail = 0; dirAvail < MAX_MULTIPLE;) {		/* do ever, 'cause we have ever a valid dir (current dir) */
      char *hit;

      if ((hit = (char *)__strchr(dirPath[dirAvail], ';'))) {	/* cut off next entry */
	*hit = ' ';
	while ((hit[-1] == ' ') || (hit[-1] == '\t'))		/* delete whitespace */
	  hit--;
	*hit++ = '\0';
	while ((*hit == ' ') || (*hit == '\t'))			/* delete whitespace */
	  hit++;
      }
      oprintf("dirPath %2d: \"%s\"\n", dirAvail, dirPath[dirAvail]);

      if ((dirDir[dirAvail] = opendir(dirPath[dirAvail])))
	dirAvail++;						/* skip unavailable entries */
      else
	eprintf("dir \"%s\" is not a dir, or does not exists\n", dirPath[dirAvail]);

      if (!hit)							/* break if nothing more found */
	break;
      else
	dirPath[dirAvail] = hit;				/* register next entry */
    }
    oprintf("wads %2d, dirs %2d\n", wadAvail, dirAvail);

    if ((wadAvail || dirAvail) && mapMem->nummaptexstrings) {
      int i, k;
      unsigned char *mipFlow;
      struct dmiptexlump_t *mipBlock;
      struct rawdata *inPut;

	void GetInput(char *inName) {
	  int j;
	  struct wadentry *Entry;

	  inPut = 0;

	  /* first search in wadFiles */
	  for (j = 0; j < wadAvail; j++)
	    if ((Entry = SearchWAD2(inName, &Header[j], allEntries[j], TYPE_MIPMAP))) {
	      inPut = GetWAD2Raw(wadFile[j], Entry);
	      return;
	    }

	  /* if nothing found, search in dirDirs */
	  for (j = 0; (j < dirAvail) && !(inPut); j++) {
	    struct dirent *dirEnt = 0;

	    while ((dirEnt = readdir(dirDir[j]))) {
#ifdef DEBUG_C
	      oprintf("dirname: %s wadname: %s\n", dirEnt->d_name, inName);
#endif
	      if (!__strncasecmp(dirEnt->d_name, inName, strlen(inName)))	/* metal1 matches metal10* */
		if (dirEnt->d_name[strlen(inName)] == '.')			/* metal1 matches metal1.* */
		  break;
	    };

	    if (dirEnt) {
	      char *fileExt = GetExt(dirEnt->d_name);
	      FILE *inFile;
	      struct palpic *inPic = 0;
	      char *fileName;

	      if ((fileName = (char *)tmalloc(NAMELEN_PATH + 1))) {
		__strncpy(fileName, dirPath[j], NAMELEN_PATH);
		__strncat(fileName, STR_FOR_DIR, NAMELEN_PATH);
		__strncat(fileName, dirEnt->d_name, NAMELEN_PATH);

		if ((inFile = __fopen(fileName, F_READ_BINARY))) {
		  if (!__strcasecmp(fileExt, "mip"))
		    inPut = GetRaw(fileno(inFile), inName, 0);
		  else if (!__strcasecmp(fileExt, "lmp"))
		    inPic = GetLMP(fileno(inFile), inName);
		  else {
		    short int alignX = 16, alignY = 16;

		    if (isWarp(fileName))
		      alignX = alignY = WARP_X;
		    else if (isSky(fileName)) {
		      alignX = -(SKY_X);
		      alignY = -(SKY_Y);
		    }
		    inPic = GetImage(inFile, inName, alignX, alignY);
		  }

		  if (inPic) {
		    if ((inPut = rmalloc(MIP_MULT(inPic->width * inPic->height) + sizeof(struct mipmap), inName)))
		        PasteMipMap((struct mipmap *)inPut->rawdata, inPic);

		    pfree(inPic);
		  }
		  else if (!inPut)
		    eprintf("unknown fileformat %s\n", fileName);

		  __fclose(inFile);
		}
		else
		  eprintf(failed_fileopen, fileName);

		tfree(fileName);
	      }
	    }

	    rewinddir(dirDir[j]);
	    if (inPut)  /* stop search on first found */
	      return;
	  }
	}

	/* checks only for existance, not for validance */
	bool CheckInput(char *inName) {
	  int j;
	  struct wadentry *Entry;
	  bool returnval = FALSE;

	  /* first search in wadFiles */
	  for (j = 0; j < wadAvail; j++)
	    if ((Entry = SearchWAD2(inName, &Header[j], allEntries[j], TYPE_MIPMAP)))
	      return TRUE;

	  /* if nothing found, search in dirDirs */
	  for (j = 0; (j < dirAvail) && !(inPut); j++) {
	    struct dirent *dirEnt = 0;

	    while ((dirEnt = readdir(dirDir[j]))) {
#ifdef DEBUG_C
	      oprintf("dirname: %s wadname: %s\n", dirEnt->d_name, inName);
#endif
	      if (!__strncasecmp(dirEnt->d_name, inName, strlen(inName)))	/* metal1 matches metal10* */
		if (dirEnt->d_name[strlen(inName)] == '.')			/* metal1 matches metal1.* */
		  break;
	    };

	    if (dirEnt) {
	      FILE *inFile;
	      char *fileName;

	      if ((fileName = (char *)tmalloc(NAMELEN_PATH + 1))) {
		__strncpy(fileName, dirPath[j], NAMELEN_PATH);
		__strncat(fileName, STR_FOR_DIR, NAMELEN_PATH);
		__strncat(fileName, dirEnt->d_name, NAMELEN_PATH);

		if ((inFile = __fopen(fileName, F_READ_BINARY))) {
		  __fclose(inFile);
		  returnval = TRUE;
		}

		tfree(fileName);
	      }
	    }

	    rewinddir(dirDir[j]);
	    if (returnval)
	      return returnval;  /* stop search on first found */
	  }

	  return returnval;
	}

	void PutInput(char *inName) {
	  if (inPut) {
	    mipBlock->dataofs[i] = mipFlow - (unsigned char *)mipBlock;
	    mprintf("    - load texture \"%s\"\n", inPut->name);

	    if ((bspMem->shared.quake1.texdatasize + inPut->size) >= bspMem->shared.quake1.max_texdatasize) {
	      ExpandBSPClusters(bspMem, LUMP_TEXTURES);
	      mipBlock = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;
	      mipFlow = bspMem->shared.quake1.dtexdata + bspMem->shared.quake1.texdatasize;
	    }
	    bspMem->shared.quake1.texdatasize += inPut->size;

	    __memcpy(mipFlow, inPut->rawdata, inPut->size);
	    mipFlow += inPut->size;
	    rfree(inPut);
	  }
	  else {
	    mipBlock->dataofs[i] = -1;
	    eprintf("texture %s not found!\n", inName);
	  }
	}

      /* add animating textures before */
      for (i = 0, k = mapMem->nummaptexstrings; i < k; i++) {	/* don't search new added textures (FindMipTex) again */
	if (isAnim(mapMem->maptexstrings[i])) {
	  int j;
	  char name[20];

	  __strncpy(name, mapMem->maptexstrings[i], NAMELEN_WAD);

	  for (j = 0; j < MAX_ANIMFRAMES; j++) {
	    if (j < 10)
	      name[1] = '0' + j;
	    else
	      name[1] = 'A' + j - 10;				/* alternate animation */

	    if(CheckInput(name))				/* see if this name exists in the wadfile */
	      FindMiptex(mapMem, name);				/* add to the miptex list, if somebody after us needs it */
	    else if (!completeSearch)				/* break if stop after FirstNotFound */
	      break;
	  }
	}
      }

      if (!bspMem->shared.quake1.dtexdata)
	AllocBSPClusters(bspMem, LUMP_TEXTURES);
      mipBlock = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;
      mipFlow = (unsigned char *)&mipBlock->dataofs[mapMem->nummaptexstrings];
      mipBlock->nummiptex = mapMem->nummaptexstrings;
      bspMem->shared.quake1.texdatasize = mipFlow - bspMem->shared.quake1.dtexdata;

      /* add legal textures after */
      for (i = 0; i < mapMem->nummaptexstrings; i++) {
        if (!(isClip(mapMem->maptexstrings[i]) ||		/* possible? */
	      isMirror(mapMem->maptexstrings[i]))) {		/* mirrors exists like wall-textures, but are generated dynamicaly */
	  GetInput(mapMem->maptexstrings[i]);
	  PutInput(mapMem->maptexstrings[i]);
	}
      }

      for (i = 0; i < wadAvail; i++)
	__close(wadFile[i]);
      for (i = 0; i < dirAvail; i++)
	closedir(dirDir[i]);
    }
    else
      eprintf(failed_fileopen, "wadfile(s) or dir(s)");
  }
}

/*=========================================================================== */

/*
 * ==================
 * BeginBSPFile
 * ==================
 */
void BeginBSPFile(bspBase bspMem, mapBase mapMem)
{
  bspMem->availHeaders = 0;
  AllocBSPClusters(bspMem, ((ALL_QUAKE1_LUMPS) | (ALL_MAPS)) & (~((LUMP_LIGHTING) | (LUMP_VISIBILITY))));
  AllocMapClusters(mapMem, ((ALL_QUAKE1_LUMPS) | (ALL_MAPS)) & (~((LUMP_LIGHTING) | (LUMP_VISIBILITY))));

  /* edge 0 is not used, because 0 can't be negated */
  bspMem->shared.quake1.numedges = 1;

  /* leaf 0 is common solid with no faces */
  bspMem->shared.quake1.numleafs = 1;
  bspMem->shared.quake1.dleafs[0].contents = CONTENTS_SOLID;

  firstface = 0;
}

/*
 * ==================
 * FinishBSPFile
 * ==================
 */
void FinishBSPFile(bspBase bspMem, mapBase mapMem, HANDLE bspFile)
{
  mprintf("----- FinishBSPFile -----\n");

  WriteMiptex(bspMem, mapMem);
  WriteBSP(bspMem, bspFile, BSP_VERSION_Q1);
  PrintBSPClusters(bspMem, 0, TRUE);
}
