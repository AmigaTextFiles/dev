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
#include "../include/libqdisplay.h"

bool newBsp = FALSE, newLit = FALSE, newVis = FALSE;

/* light */
bool waterlit = FALSE, extra = FALSE, doradiosity = FALSE;
vec1D scale = 0, range = 0;

/* qbsp */
bool watervis = FALSE, slimevis = FALSE;
bool nofill = FALSE, notjunc = FALSE, noclip = FALSE, onlyents = FALSE, usehulls = FALSE;
int subdivide = 0, hullnum = 0;

/* vis */
bool fastvis = FALSE;
int vislevel = 2;

/*
 * =============
 * AddBSP
 *
 * this function manages updating and/or creating and/or replacing of bsp-files
 * it is possible to replace the light and visibility lumps rather than calc-
 * ulating them new. it is a high level function to call the mid-level functions
 * light, vis and qbsp
 * TODO: the function should be capable to replace textures, the reason why that
 * isn't done is the missing CutOff and PasteIn functions
 * =============
 */
bool AddBSP(struct palpic *inPic, struct rawdata *inData, char *bspName, operation procOper, filetype inType)
{
  bool retval = TRUE, appendPic = FALSE;
  char *procName = 0, *srcName;
  HANDLE bspFile = 0;
  bspBase bspMem = 0;
  mapBase mapMem = 0;

#ifdef	MEM_SIZETRACK
  mprintf(" memory  :        %7i (       %7i)\n", memcounter, mempeak);
# ifdef	MEM_ANALYSE
  mprintf("                  %7i (       %7i)\n", memallocs, mempeakallocs);
  mprintf("                  %7i (       %7i)\n", memcounter / memallocs, mempeak / mempeakallocs);
# endif
#endif

  if (inPic) {
    procName = inPic->name;
    appendPic = TRUE;
  }
  else if (inData) {
    procName = inData->name;
    appendPic = FALSE;
  }
  srcName = GetExt(procName);

  if (!__strcasecmp(srcName, "wad") || (inType == TYPE_WAD2))
    appendPic = TRUE;

  if (appendPic) {
  }
  else {
    bool oldBsp = FALSE, oldLit = FALSE, oldVis = FALSE;

    if (!__strcasecmp(srcName, "bsp") || (inType == TYPE_BSP)) {
      oldBsp = TRUE;
      newBsp = FALSE;
      inType = TYPE_BSP;
    }
    else if (!__strcasecmp(srcName, "map") || (inType == TYPE_MAP)) {
      newBsp = TRUE;
      oldBsp = FALSE;
      inType = TYPE_MAP;
    }
    else if (!__strcasecmp(srcName, "iob") || (inType == TYPE_IMAGINE)) {
      newBsp = TRUE;
      oldBsp = FALSE;
      inType = TYPE_IMAGINE;
    }
    else if (!__strcasecmp(srcName, "prt") || (inType == TYPE_PRT)) {
      newVis = TRUE;
      oldVis = FALSE;
      inType = TYPE_PRT;
    }
    else if (!__strcasecmp(srcName, "vis") || (inType == TYPE_VIS)) {
      oldVis = oldBsp = TRUE;
      newVis = newBsp = FALSE;
      inType = TYPE_VIS;
    }
    else if (!__strcasecmp(srcName, "lit") || (inType == TYPE_LIT)) {
      oldLit = oldBsp = TRUE;
      newLit = newBsp = FALSE;
      inType = TYPE_LIT;
    }

    while (1) {
      if (!setjmp(eabort)) {
	if (oldBsp) {
	  if ((bspFile = __open(bspName, H_READWRITE_BINARY_OLD)) < 0) {
	    eprintf(failed_fileopen, bspName);
	    break;
	  }
	  if (!(bspMem = LoadBSP(bspFile, ALL_QUAKE1_LUMPS, BSP_VERSION_Q1))) {
	    eprintf(failed_fileload, bspName);
	    break;
	  }

       /* bspMem->bspOptions |= QBSP_NOTEXTURES; */

	  __close(bspFile);
	  if ((bspFile = __open(bspName, H_WRITE_BINARY)) < 0) {
	    eprintf(failed_fileopen, bspName);
	    break;
	  }
	}
	else {
	  if ((bspFile = __open(bspName, H_WRITE_BINARY)) < 0) {
	    eprintf(failed_fileopen, bspName);
	    break;
	  }
	  if (!(bspMem = (bspBase)tmalloc(sizeof(struct bspmemory)))) {
	    eprintf(failed_memory, sizeof(struct bspmemory), "bspMem");
	    break;
	  }
	  if (!(mapMem = (mapBase)tmalloc(sizeof(struct mapmemory)))) {
	    eprintf(failed_memory, sizeof(struct mapmemory), "mapMem");
	    break;
	  }

	  /* init the tables to be shared by all models */
	  BeginBSPFile(bspMem, mapMem);

	  mapMem->mapOptions |= (newLit ? MAP_LOADLIGHTS : 0);
	  mapMem->mapOptions |= (watervis ? QBSP_WATERVIS : 0);
	  mapMem->mapOptions |= (slimevis ? QBSP_SLIMEVIS : 0);
	  mapMem->mapOptions |= (nofill ? QBSP_NOFILL : 0);
	  mapMem->mapOptions |= (notjunc ? QBSP_NOTJUNC : 0);
	  mapMem->mapOptions |= (noclip ? QBSP_NOCLIP : 0);
	  mapMem->mapOptions |= (onlyents ? QBSP_ONLYENTS : 0);
	  mapMem->mapOptions |= (usehulls ? QBSP_USEHULLS : 0);

	  /* load brushes and bspMem->mapentities */
	  if (inType == TYPE_IMAGINE) {
	    if (!(retval = LoadTDDDFile(bspMem, mapMem, inData->rawdata))) {
	      eprintf(failed_fileload, "TDDD");
	      break;
	    }
	  }
	  else if (inType == TYPE_MAP) {
	    if (!(retval = LoadMapFile(bspMem, mapMem, (char *)inData->rawdata))) {
	      eprintf(failed_fileload, "map");
	      break;
	    }
	  }

	  mprintf(oper_create, "bsp-data", bspName);
	  if (!(retval = qbsp(bspMem, mapMem, hullnum, subdivide, bspName))) {
	    eprintf("failed to calculate bsp-tree\n");
	    break;
	  }
	}

	bspMem->visOptions |= (fastvis ? VIS_FAST : 0);
	bspMem->visOptions |= (verbose ? VIS_VERBOSE : 0);

	if (newVis) {
	  mprintf(oper_create, "vis-data", bspName);
	  if (!(retval = vis(bspMem, vislevel, (char *)inData->rawdata))) {
	    eprintf("failed to calculate vis-data\n");
	    break;
	  }
	}
	else if (oldVis) {
	  mprintf(oper_replace, "vis-data", bspName);
	  FreeBSPClusters(bspMem, LUMP_VISIBILITY);
	  bspMem->shared.quake1.dvisdata = inData->rawdata;
	  bspMem->shared.quake1.visdatasize = inData->size;
       /* WriteBSP(bspFile, bspMem, BSP_VERSION_Q1); */
	  break;
	}

	bspMem->litOptions |= (newLit ? LIGHT_MEM : 0);
	bspMem->litOptions |= (radiosity ? LIGHT_RADIOSITY : 0);
	bspMem->litOptions |= (extra ? LIGHT_EXTRA : 0);
	bspMem->litOptions |= (waterlit ? LIGHT_WATERLIT : 0);

	if (newLit) {
	  mprintf(oper_create, "light-data", bspName);
	  if (!(retval = light(bspMem, mapMem, scale, range))) {
	    eprintf("failed to calculate lit-data\n");
	    break;
	  }
	}
	else if (oldLit) {
	  mprintf(oper_replace, "light-data", bspName);
	  FreeBSPClusters(bspMem, LUMP_LIGHTING);
	  bspMem->shared.quake1.dlightdata = inData->rawdata;
	  bspMem->shared.quake1.lightdatasize = inData->size;
       /* WriteBSP(bspFile, bspMem, BSP_VERSION_Q1); */
	  break;
	}

	FinishBSPFile(bspMem, mapMem, bspFile);
      }
      break;
    }
  }

  if (bspFile)
    __close(bspFile);
  if (bspMem) {
    FreeBSPClusters(bspMem, 0);
    tfree(bspMem);
  }
  if (mapMem) {
    FreeMapClusters(mapMem, 0);
    tfree(mapMem);
  }

#ifdef	MEM_SIZETRACK
  mprintf(" memory  :        %7i (       %7i)\n", memcounter, mempeak);
#ifdef	MEM_ANALYSE
  mprintf("                  %7i (       %7i)\n", memallocs, mempeakallocs);
  mprintf("                  %7i (       %7i)\n", memcounter / memallocs, mempeak / mempeakallocs);
#endif
#endif

  return retval;
}

/*
 * =============
 * ExtractMipTex
 *
 * this is the exact opposite of the WriteMiptex-function
 * =============
 */
bool ExtractMipTex(bspBase bspMem, FILE * script, char *destDir, char *destPath, char *entryName, filetype outType, operation procOper, bool recurse, bool toWad) {
  bool retval = TRUE;
  int *MipOffsets = (int *)bspMem->shared.quake1.dtexdata;
  int MipNums = *MipOffsets++;
  int i;

  /* decode mips from bsp */
  ReplaceExt(destPath, "wad");
  for (i = 0; i < MipNums; i++) {
    if (MipOffsets[i] != -1) {
    struct mipmap *Texture = (struct mipmap *)(MipOffsets[i] + bspMem->shared.quake1.dtexdata);

    if (!(entryName && fnmatch(entryName, Texture->name, FNM_PATHNAME))) {
      char fileName[NAMELEN_PATH];

      __strncpy(fileName, destDir, NAMELEN_PATH - 1);
      __strncat(fileName, Texture->name, NAMELEN_PATH - 1);
      AppendType(fileName, outType, ".mip");

      switch (procOper) {
        case OP_EXTRACT:
	  retval = FALSE;

	  if (toWad) {
	    struct rawdata *MipMap;

	    if ((MipMap = ParseRaw((char *)Texture, Texture->name,  MIP_MULT(LittleLong(Texture->width) * LittleLong(Texture->height)) + sizeof(struct mipmap)))) {
	      mprintf(oper_extract, Texture->name, destPath);
	      CreatePath(destPath);

	      retval = AddWAD2(0, MipMap, destPath, OP_UPDATE, WAD2_MIPMAP);
	      rfree(MipMap);
	    }
	  }
	  else if (outType == TYPE_NONE) {
	    struct rawdata *MipMap;

	    if ((MipMap = ParseRaw((char *)Texture, Texture->name,  MIP_MULT(LittleLong(Texture->width) * LittleLong(Texture->height)) + sizeof(struct mipmap)))) {
	      FILE *fileDst;

	      mprintf(oper_extract, Texture->name, fileName);
	      CreatePath(fileName);

	      if ((fileDst = __fopen(fileName, F_WRITE_BINARY))) {
		retval = PutRaw(fileno(fileDst), MipMap);
		__fclose(fileDst);
	      }
	      else
	  	eprintf(failed_fileopen, fileName);
	      rfree(MipMap);
	    }
	  }
	  else {
	    struct palpic *MipMap;

	    if ((MipMap = ParseMipMap(Texture, MIPMAP_0))) {
	      FILE *fileDst;

	      mprintf(oper_extract, MipMap->name, fileName);
	      CreatePath(fileName);

	      if ((fileDst = __fopen(fileName, F_WRITE_BINARY))) {
		retval = PutImage(fileDst, MipMap, outType);
		__fclose(fileDst);
	      }
	      else
	  	eprintf(failed_fileopen, fileName);
	      pfree(MipMap);
	    }
	  }
	  break;
        case OP_DELETE:{
	    int len, diff;

	    len = MIP_MULT(LittleLong(Texture->width) * LittleLong(Texture->height)) + sizeof(struct mipmap);
	    diff = bspMem->shared.quake1.texdatasize - (int)((long int)Texture - (long int)&MipOffsets[MipNums]);
	    __memcpy(Texture, ((unsigned char *)Texture) + len, len);

	    for (diff = 0; diff < MipNums; diff++)
	      /* subtract cutoff-region from the offsets if they lie behind it */
	      if (MipOffsets[diff] > MipOffsets[i])
	        MipOffsets[diff] -= len;

	    MipOffsets[i] = -1;
	    bspMem->shared.quake1.texdatasize -= len;
	  }
	  break;
        case OP_VIEW:{
 	    struct palpic *MipMap;

	    mprintf(oper_view, Texture->name, fileName);
	    if ((MipMap = ParseMipMap(Texture, MIPMAP_0))) {
	      if (DisplayMipMap(MipMap->rawdata, MipMap->name, MipMap->width, MipMap->height, 8, TRUE))
	        i = MipNums;
	      pfree(MipMap);
	    }
	    else
	      retval = FALSE;
	  }
	  break;
        case OP_LIST:
        case OP_DEFAULT:
        default:
	  mprintf("%16s (offset: %8d) %4dx%d\n", Texture->name, MipOffsets[i], LittleLong(Texture->width), LittleLong(Texture->height));
	  break;
      }

      if (script)
        fprintf(script, "update %s as %s as %c\n", fileName, Texture->name, WAD2_MIPMAP);
    }
    }
  }

  if ((toWad) && (recurse))
    retval = processName(destPath, 0, 0, outType, 0, 0, procOper, script ? TRUE : FALSE, recurse);

  return retval;
}

/*
 * =============
 * ExtractBSP
 *
 * this is the exact opposite of the addbsp-function
 * TODO: scripting for bsp-files
 * =============
 */
bool ExtractBSP(HANDLE bspFile, FILE * script, char *destDir, char *entryName, filetype outType, operation procOper, bool recurse)
{
  HANDLE outFile;
  bool retval = FALSE;

  bspBase bspMem;

#ifdef	PRINTCALLS
  mprintf("ExtractBSP(%lx, %lx, %s, %s, %d, %d, %d)\n", bspFile, script, destDir, entryName, outType, procOper, recurse);
#endif

  if (!setjmp(eabort)) {
    char destPath[NAMELEN_PATH], *destName;
    bool toWad = FALSE, toMap = FALSE, toVis = FALSE, toLit = FALSE, toIob = FALSE, toBsp = FALSE, toTex = TRUE;
    int bspMask;

    __strncpy(destPath, destDir, NAMELEN_PATH - 1);
    if (!entryName) {
      destName = smalloc(destDir);
      destName[__strlen(destName) - 1] = '\0';
           if (outType == TYPE_WAD2) {		toWad = TRUE;				bspMask = LUMP_TEXTURES;	}
      else if (outType == TYPE_MAP) {		toMap = TRUE;		toTex = FALSE;	bspMask = BSP_QUAKE1_LUMPS;	}
      else if (outType == TYPE_IMAGINE) {	toMap = toIob = TRUE;	toTex = FALSE;	bspMask = BSP_QUAKE1_LUMPS;	}
      else if (outType == TYPE_VIS) {		toVis = TRUE;		toTex = FALSE;	bspMask = LUMP_VISIBILITY;	}
      else if (outType == TYPE_LIT) {		toLit = TRUE;		toTex = FALSE;	bspMask = LUMP_LIGHTING;	}
      else if (outType == TYPE_BSP) {		toBsp = TRUE;		toTex = FALSE;	bspMask = ALL_QUAKE1_LUMPS;	}
      else {					toWad = toMap = toVis = toLit = TRUE;	bspMask = ALL_QUAKE1_LUMPS;	}								/* default: extract all */
      __strncat(destPath, GetFile(destName), NAMELEN_PATH - 1);
      tfree(destName);
    }
    else {
      destName = GetExt(entryName);
      __strncat(destPath, GetFile(entryName), NAMELEN_PATH - 1);
      if (!__strcasecmp(destName, "wad") || (outType == TYPE_WAD2)) {
	entryName = 0;	toWad = TRUE;		bspMask = LUMP_TEXTURES;
      }
      else if (!__strcasecmp(destName, "map") || (outType == TYPE_MAP)) {
	toTex = FALSE;	toMap = TRUE;		bspMask = BSP_QUAKE1_LUMPS;
      }
      else if (!__strcasecmp(destName, "iob") || (outType == TYPE_IMAGINE)) {
	toTex = FALSE;	toMap = toIob = TRUE;	bspMask = BSP_QUAKE1_LUMPS;
      }
      else if (!__strcasecmp(destName, "vis") || (outType == TYPE_VIS)) {
	toTex = FALSE;	toVis = TRUE;		bspMask = LUMP_VISIBILITY;
      }
      else if (!__strcasecmp(destName, "lit") || (outType == TYPE_LIT)) {
	toTex = FALSE;	toLit = TRUE;		bspMask = LUMP_LIGHTING;
      }
      else if (!__strcasecmp(destName, "bsp") || (outType == TYPE_BSP)) {
	toTex = FALSE;	toBsp = TRUE;		bspMask = ALL_QUAKE1_LUMPS;
      }
      else
	bspMask = LUMP_TEXTURES;
    }

    if ((bspMem = LoadBSP(bspFile, bspMask, BSP_VERSION_Q1))) {
      retval = TRUE;
    
      if (procOper == OP_EXTRACT)
	CreatePath(destPath);

      if ((bspMem->shared.quake1.dtexdata) && (toTex))
        retval = ExtractMipTex(bspMem, script, destDir, destPath, entryName, outType, procOper, recurse, toWad);

      if ((bspMem->shared.quake1.dentdata) && (toMap)) {
	/* decode map from bsp */
	if (procOper == OP_EXTRACT) {
	  FILE *mapFile;
	  struct mapmemory mapMem;

	  __bzero(&mapMem, sizeof(mapMem));
	  LoadMapFile(bspMem, &mapMem, bspMem->shared.quake1.dentdata);
	  if (toWad)
	    SetKeyValue(FindEntityWithModel(&mapMem, 0), "wad", destPath);

	  ReplaceExt(destPath, toIob ? "iob" : "map");
	  mprintf(oper_extract, "bsp-data", destPath);

	  if ((mapFile = __fopen(destPath, toIob ? F_WRITE_BINARY : "w"))) {
	    LoadBSPFile(bspMem, &mapMem);

	    if (toIob)
	      retval = SaveTDDDFile(bspMem, &mapMem, fileno(mapFile));
	    else
	      retval = SaveMapFile(bspMem, &mapMem, mapFile);

	    __fclose(mapFile);
	  }
	}
	else if (procOper == OP_VIEW)
	  retval = DisplayBSP(bspMem, "bspFile ...", 320, 200, 8, DISPLAY_FLAT, FALSE);
      }

      if ((bspMem->shared.quake1.dvisdata) && (toVis)) {
	/* decode vis from bsp */
	if (procOper == OP_EXTRACT) {
	  ReplaceExt(destPath, "vis");
	  mprintf(oper_extract, "vis-data", destPath);

	  if ((outFile = __open(destPath, H_WRITE_BINARY)) > 0) {
	    __write(outFile, (void *)bspMem->shared.quake1.dvisdata, bspMem->shared.quake1.visdatasize * sizeof(unsigned char));
	    __close(outFile);
	  }
	  else
	    retval = FALSE;
	}
	else if ((procOper == OP_VIEW) && (!toMap))		/* display only if not displayed previous */
	  retval = DisplayBSP(bspMem, "bspFile ...", 320, 200, 8, DISPLAY_FLAT, FALSE);
	else if (procOper == OP_DELETE)
	  FreeBSPClusters(bspMem, LUMP_VISIBILITY);
      }

      if ((bspMem->shared.quake1.dlightdata) && (toLit)) {
	/* decode lit from bsp */
	if (procOper == OP_EXTRACT) {
	  ReplaceExt(destPath, "lit");
	  mprintf(oper_extract, "light-data", destPath);

	  if ((outFile = __open(destPath, H_WRITE_BINARY)) > 0) {
	    __write(outFile, (void *)bspMem->shared.quake1.dlightdata, bspMem->shared.quake1.lightdatasize * sizeof(unsigned char));
	    __close(outFile);
	    retval = TRUE;
	  }
	}
	else if ((procOper == OP_VIEW) && (!toMap) && (!toVis))	/* display only if not displayed previous */
	  retval = DisplayBSP(bspMem, "bspFile ...", 320, 200, 8, DISPLAY_FLAT, FALSE);
	else if (procOper == OP_DELETE)
	  FreeBSPClusters(bspMem, LUMP_LIGHTING);
      }

      if ((toBsp) && (procOper == OP_EXTRACT)) {
	/*
	 * decode bsp from bsp
	 * mostly for conversions between the bsp-file versions
	 */
	ReplaceExt(destPath, "bsp");
	mprintf(oper_extract, "bsp-data", destPath);

	if ((outFile = __open(destPath, H_WRITE_BINARY)) > 0) {
	  WriteBSP(bspMem, outFile, BSP_VERSION_Q1);
	  __close(outFile);
	}
	else
	  retval = FALSE;
      }

      if ((procOper == OP_LIST) || (procOper == OP_DEFAULT))
	PrintBSPClusters(bspMem, 0, FALSE);
      else if(procOper == OP_DELETE)
        WriteBSP(bspMem, bspFile, BSP_VERSION_Q1);
   /* else if(procOper == OP_VIEW)
        DisplayEnd(); */

      FreeBSPClusters(bspMem, 0);
    }
    else
      eprintf(failed_fileload, "bspFile");
  }

  return retval;
}

/*
 * =============
 * SwapBSPFile
 * 
 * Byte swaps all data in a bsp file.
 * =============
 */
staticfnc void SwapBSPFile(bspBase bspMem, bool toDisk)
{
  int i, c;
  short int j = 0;

  oprintf("swapmask: %lx\n", bspMem->availHeaders);

  /* same in both */
  /*
   * planes
   */
  if (bspMem->availHeaders & LUMP_PLANES)
    for (i = 0; i < bspMem->shared.quake1.numplanes; i++) {
      for (j = 0; j < 3; j++)
	bspMem->shared.quake1.dplanes[i].normal[j] = LittleFloat(bspMem->shared.quake1.dplanes[i].normal[j]);
      bspMem->shared.quake1.dplanes[i].dist = LittleFloat(bspMem->shared.quake1.dplanes[i].dist);
      bspMem->shared.quake1.dplanes[i].type = LittleLong(bspMem->shared.quake1.dplanes[i].type);
    }

  /*
   * vertexes
   */
  if (bspMem->availHeaders & LUMP_VERTEXES)
    for (i = 0; i < bspMem->shared.quake1.numvertexes; i++) {
      for (j = 0; j < 3; j++)
	bspMem->shared.quake1.dvertexes[i].point[j] = LittleFloat(bspMem->shared.quake1.dvertexes[i].point[j]);
    }

  /*
   * faces
   */
  if (bspMem->availHeaders & LUMP_FACES)
    for (i = 0; i < bspMem->shared.quake1.numfaces; i++) {
      bspMem->shared.quake1.dfaces[i].texinfo = LittleShort(bspMem->shared.quake1.dfaces[i].texinfo);
      bspMem->shared.quake1.dfaces[i].planenum = LittleShort(bspMem->shared.quake1.dfaces[i].planenum);
      bspMem->shared.quake1.dfaces[i].side = LittleShort(bspMem->shared.quake1.dfaces[i].side);
      bspMem->shared.quake1.dfaces[i].lightofs = LittleLong(bspMem->shared.quake1.dfaces[i].lightofs);
      bspMem->shared.quake1.dfaces[i].firstedge = LittleLong(bspMem->shared.quake1.dfaces[i].firstedge);
      bspMem->shared.quake1.dfaces[i].numedges = LittleShort(bspMem->shared.quake1.dfaces[i].numedges);
    }

  /*
   * marksurfaces
   */
  if (bspMem->availHeaders & LUMP_MARKSURFACES)
    for (i = 0; i < bspMem->shared.quake1.nummarksurfaces; i++)
      bspMem->shared.quake1.dmarksurfaces[i] = LittleShort(bspMem->shared.quake1.dmarksurfaces[i]);

  /*
   * edges
   */
  if (bspMem->availHeaders & LUMP_EDGES)
    for (i = 0; i < bspMem->shared.quake1.numedges; i++) {
      bspMem->shared.quake1.dedges[i].v[0] = LittleShort(bspMem->shared.quake1.dedges[i].v[0]);
      bspMem->shared.quake1.dedges[i].v[1] = LittleShort(bspMem->shared.quake1.dedges[i].v[1]);
    }

  /*
   * surfedges
   */
  if (bspMem->availHeaders & LUMP_SURFEDGES)
    for (i = 0; i < bspMem->shared.quake1.numsurfedges; i++)
      bspMem->shared.quake1.dsurfedges[i] = LittleLong(bspMem->shared.quake1.dsurfedges[i]);

  /* differencies */
  if (bspMem->bspVersion == BSP_VERSION_Q1) {
    struct dmodel_t *d;
    struct dmiptexlump_t *mtl;

    /*
     * miptex
     */
    if (bspMem->availHeaders & LUMP_TEXTURES)
      if (bspMem->shared.quake1.texdatasize) {
	mtl = (struct dmiptexlump_t *)bspMem->shared.quake1.dtexdata;
	if (toDisk)
	  c = mtl->nummiptex;
	else
	  c = LittleLong(mtl->nummiptex);
	mtl->nummiptex = LittleLong(mtl->nummiptex);
	for (i = 0; i < c; i++)
	  mtl->dataofs[i] = LittleLong(mtl->dataofs[i]);
      }

    /*
     * nodes
     */
    if (bspMem->availHeaders & LUMP_NODES)
      for (i = 0; i < bspMem->shared.quake1.numnodes; i++) {
	bspMem->shared.quake1.dnodes[i].planenum = LittleLong(bspMem->shared.quake1.dnodes[i].planenum);
	for (j = 0; j < 3; j++) {
	  bspMem->shared.quake1.dnodes[i].mins[j] = LittleShort(bspMem->shared.quake1.dnodes[i].mins[j]);
	  bspMem->shared.quake1.dnodes[i].maxs[j] = LittleShort(bspMem->shared.quake1.dnodes[i].maxs[j]);
	}
	bspMem->shared.quake1.dnodes[i].children[0] = LittleShort(bspMem->shared.quake1.dnodes[i].children[0]);
	bspMem->shared.quake1.dnodes[i].children[1] = LittleShort(bspMem->shared.quake1.dnodes[i].children[1]);
	bspMem->shared.quake1.dnodes[i].firstface = LittleShort(bspMem->shared.quake1.dnodes[i].firstface);
	bspMem->shared.quake1.dnodes[i].numfaces = LittleShort(bspMem->shared.quake1.dnodes[i].numfaces);
      }

    /*
     * texinfos
     */
    if (bspMem->availHeaders & LUMP_TEXINFO)
      for (i = 0; i < bspMem->shared.quake1.numtexinfo; i++) {
	for (j = 0; j < 8; j++)
	  bspMem->shared.quake1.texinfo[i].vecs[0][j] = LittleFloat(bspMem->shared.quake1.texinfo[i].vecs[0][j]);
	bspMem->shared.quake1.texinfo[i].miptex = LittleLong(bspMem->shared.quake1.texinfo[i].miptex);
	bspMem->shared.quake1.texinfo[i].flags = LittleLong(bspMem->shared.quake1.texinfo[i].flags);
      }

    /*
     * clipnodes
     */
    if (bspMem->availHeaders & LUMP_CLIPNODES)
      for (i = 0; i < bspMem->shared.quake1.numclipnodes; i++) {
	bspMem->shared.quake1.dclipnodes[i].planenum = LittleLong(bspMem->shared.quake1.dclipnodes[i].planenum);
	bspMem->shared.quake1.dclipnodes[i].children[0] = LittleShort(bspMem->shared.quake1.dclipnodes[i].children[0]);
	bspMem->shared.quake1.dclipnodes[i].children[1] = LittleShort(bspMem->shared.quake1.dclipnodes[i].children[1]);
      }

    /*
     * leafs
     */
    if (bspMem->availHeaders & LUMP_LEAFS)
      for (i = 0; i < bspMem->shared.quake1.numleafs; i++) {
	bspMem->shared.quake1.dleafs[i].contents = LittleLong(bspMem->shared.quake1.dleafs[i].contents);
	for (j = 0; j < 3; j++) {
	  bspMem->shared.quake1.dleafs[i].mins[j] = LittleShort(bspMem->shared.quake1.dleafs[i].mins[j]);
	  bspMem->shared.quake1.dleafs[i].maxs[j] = LittleShort(bspMem->shared.quake1.dleafs[i].maxs[j]);
	}
	bspMem->shared.quake1.dleafs[i].firstmarksurface = LittleShort(bspMem->shared.quake1.dleafs[i].firstmarksurface);
	bspMem->shared.quake1.dleafs[i].nummarksurfaces = LittleShort(bspMem->shared.quake1.dleafs[i].nummarksurfaces);
	bspMem->shared.quake1.dleafs[i].visofs = LittleLong(bspMem->shared.quake1.dleafs[i].visofs);
      }

    /*
     * models
     */
    if (bspMem->availHeaders & LUMP_MODELS) {
      for (i = 0; i < bspMem->shared.quake1.nummodels; i++) {
	d = &bspMem->shared.quake1.dmodels[i];
	for (j = 0; j < MAX_MAP_HULLS; j++)
	  d->headnode[j] = LittleLong(d->headnode[j]);
	d->visleafs = LittleLong(d->visleafs);
	d->firstface = LittleLong(d->firstface);
	d->numfaces = LittleLong(d->numfaces);
	for (j = 0; j < 3; j++) {
	  d->mins[j] = LittleFloat(d->mins[j]);
	  d->maxs[j] = LittleFloat(d->maxs[j]);
	  d->origin[j] = LittleFloat(d->origin[j]);
	}
      }
    }
  }
  else if (bspMem->bspVersion == BSP_VERSION_Q2) {
    struct dmodel2_t *d;

    /*
     * models
     */
    if (bspMem->availHeaders & LUMP_MODELS)
      for (i = 0; i < bspMem->shared.quake2.nummodels; i++) {
	d = &bspMem->shared.quake2.dmodels[i];
	d->headnode = LittleLong(d->headnode);
	d->firstface = LittleLong(d->firstface);
	d->numfaces = LittleLong(d->numfaces);
	for (j = 0; j < 3; j++) {
	  d->mins[j] = LittleFloat(d->mins[j]);
	  d->maxs[j] = LittleFloat(d->maxs[j]);
	  d->origin[j] = LittleFloat(d->origin[j]);
	}
      }

    /*
     * texinfos
     */
    if (bspMem->availHeaders & LUMP_TEXINFO)
      for (i = 0; i < bspMem->shared.quake2.numtexinfo; i++) {
	for (j = 0; j < 8; j++)
	  bspMem->shared.quake2.texinfo[i].vecs[0][j] = LittleFloat(bspMem->shared.quake2.texinfo[i].vecs[0][j]);
	bspMem->shared.quake2.texinfo[i].flags = LittleLong(bspMem->shared.quake2.texinfo[i].flags);
	bspMem->shared.quake2.texinfo[i].value = LittleLong(bspMem->shared.quake2.texinfo[i].value);
	bspMem->shared.quake2.texinfo[i].nexttexinfo = LittleLong(bspMem->shared.quake2.texinfo[i].nexttexinfo);
      }

    /*
     * nodes
     */
    if (bspMem->availHeaders & LUMP_NODES)
      for (i = 0; i < bspMem->shared.quake2.numnodes; i++) {
	bspMem->shared.quake2.dnodes[i].planenum = LittleLong(bspMem->shared.quake2.dnodes[i].planenum);
	for (j = 0; j < 3; j++) {
	  bspMem->shared.quake2.dnodes[i].mins[j] = LittleShort(bspMem->shared.quake2.dnodes[i].mins[j]);
	  bspMem->shared.quake2.dnodes[i].maxs[j] = LittleShort(bspMem->shared.quake2.dnodes[i].maxs[j]);
	}
	bspMem->shared.quake2.dnodes[i].children[0] = LittleLong(bspMem->shared.quake2.dnodes[i].children[0]);
	bspMem->shared.quake2.dnodes[i].children[1] = LittleLong(bspMem->shared.quake2.dnodes[i].children[1]);
	bspMem->shared.quake2.dnodes[i].firstface = LittleShort(bspMem->shared.quake2.dnodes[i].firstface);
	bspMem->shared.quake2.dnodes[i].numfaces = LittleShort(bspMem->shared.quake2.dnodes[i].numfaces);
      }

    /*
     * leafs
     */
    if (bspMem->availHeaders & LUMP_LEAFS)
      for (i = 0; i < bspMem->shared.quake2.numleafs; i++) {
	bspMem->shared.quake2.dleafs[i].contents = LittleLong(bspMem->shared.quake2.dleafs[i].contents);
	bspMem->shared.quake2.dleafs[i].cluster = LittleLong(bspMem->shared.quake2.dleafs[i].cluster);
	bspMem->shared.quake2.dleafs[i].area = LittleLong(bspMem->shared.quake2.dleafs[i].area);
	for (j = 0; j < 3; j++) {
	  bspMem->shared.quake2.dleafs[i].mins[j] = LittleShort(bspMem->shared.quake2.dleafs[i].mins[j]);
	  bspMem->shared.quake2.dleafs[i].maxs[j] = LittleShort(bspMem->shared.quake2.dleafs[i].maxs[j]);
	}
	bspMem->shared.quake2.dleafs[i].firstleafface = LittleShort(bspMem->shared.quake2.dleafs[i].firstleafface);
	bspMem->shared.quake2.dleafs[i].numleaffaces = LittleShort(bspMem->shared.quake2.dleafs[i].numleaffaces);
	bspMem->shared.quake2.dleafs[i].firstleafbrush = LittleShort(bspMem->shared.quake2.dleafs[i].firstleafbrush);
	bspMem->shared.quake2.dleafs[i].numleafbrushes = LittleShort(bspMem->shared.quake2.dleafs[i].numleafbrushes);
      }

    /*
     * leafbrushes
     */
    if (bspMem->availHeaders & LUMP_LEAFBRUSHES)
      for (i = 0; i < bspMem->shared.quake2.numleafbrushes; i++)
	bspMem->shared.quake2.dleafbrushes[i] = LittleShort(bspMem->shared.quake2.dleafbrushes[i]);

    /*
     * brushes
     */
    if (bspMem->availHeaders & LUMP_BRUSHES)
      for (i = 0; i < bspMem->shared.quake2.numbrushes; i++) {
	bspMem->shared.quake2.dbrushes[i].firstside = LittleLong(bspMem->shared.quake2.dbrushes[i].firstside);
	bspMem->shared.quake2.dbrushes[i].numsides = LittleLong(bspMem->shared.quake2.dbrushes[i].numsides);
	bspMem->shared.quake2.dbrushes[i].contents = LittleLong(bspMem->shared.quake2.dbrushes[i].contents);
      }

    /*
     * areas
     */
    if (bspMem->availHeaders & LUMP_AREAS)
      for (i = 0; i < bspMem->shared.quake2.numareas; i++) {
	bspMem->shared.quake2.dareas[i].numareaportals = LittleLong(bspMem->shared.quake2.dareas[i].numareaportals);
	bspMem->shared.quake2.dareas[i].firstareaportal = LittleLong(bspMem->shared.quake2.dareas[i].firstareaportal);
      }

    /*
     * areasportals
     */
    if (bspMem->availHeaders & LUMP_AREAPORTALS)
      for (i = 0; i < bspMem->shared.quake2.numareaportals; i++) {
	bspMem->shared.quake2.dareaportals[i].portalnum = LittleLong(bspMem->shared.quake2.dareaportals[i].portalnum);
	bspMem->shared.quake2.dareaportals[i].otherarea = LittleLong(bspMem->shared.quake2.dareaportals[i].otherarea);
      }

    /*
     * brushsides
     */
    if (bspMem->availHeaders & LUMP_BRUSHSIDES)
      for (i = 0; i < bspMem->shared.quake2.numbrushsides; i++) {
	bspMem->shared.quake2.dbrushsides[i].planenum = LittleShort(bspMem->shared.quake2.dbrushsides[i].planenum);
	bspMem->shared.quake2.dbrushsides[i].texinfo = LittleShort(bspMem->shared.quake2.dbrushsides[i].texinfo);
      }

    /*
     * visibility
     */
    if (bspMem->availHeaders & LUMP_VISIBILITY) {
      if (toDisk)
	j = bspMem->shared.quake2.clusters->numclusters;
      else
	j = LittleLong(bspMem->shared.quake2.clusters->numclusters);

      bspMem->shared.quake2.numclusters = LittleLong(bspMem->shared.quake2.clusters->numclusters);
      bspMem->shared.quake2.clusters->numclusters = LittleLong(bspMem->shared.quake2.clusters->numclusters);
      for (i = 0; i < j; i++) {
	bspMem->shared.quake2.clusters->bitofs[i][0] = LittleLong(bspMem->shared.quake2.clusters->bitofs[i][0]);
	bspMem->shared.quake2.clusters->bitofs[i][1] = LittleLong(bspMem->shared.quake2.clusters->bitofs[i][1]);
      }
    }
  }
}

staticfnc int GetBlock(register HANDLE bspFile, register struct dpair *dPair, register void **store, register int partSize)
{
  register int blockSize = LittleLong(dPair->size);

  if ((*store = (void *)tmalloc(blockSize))) {
    __lseek(bspFile, LittleLong(dPair->offset), SEEK_SET);
    __read(bspFile, *store, blockSize);
    return (blockSize / partSize);
  }
  else {
    eprintf(failed_memory, blockSize, "bspBlock");
    return 0;
  }
}

staticfnc void PutBlock(register HANDLE bspFile, register struct dpair *dPair, register void *store, register int blockSize)
{
  if (blockSize) {
    dPair->size = LittleLong(blockSize);
    dPair->offset = LittleLong(__ltell(bspFile));
    __write(bspFile, store, (blockSize + 3) & ~3);
    /*
     * probably we want to use it after this
     * tfree(store);
     */
  }
  else {
    dPair->size = 0;
    dPair->offset = LittleLong(__ltell(bspFile));
  }
}

/*
 * =============
 * ConvertBSPFile
 *
 * say me what you want, and you get it. this routine
 * is some of the more important and a manager to transparently
 * hide the internals of the bsp-representation to the disk-io
 * -functions rather than the following modifications to the
 * datas
 * =============
 */
staticfnc void ConvertBSP(bspBase bspMem)
{
  int successfull = 0, success = 0, i, j;

  oprintf("convertmask: %lx\n", bspMem->availHeaders);

  /* Quake1 to Quake2, possible? */
  if (bspMem->bspVersion == BSP_VERSION_Q1) {
    eprintf("converting to quake2 bsps currently not supported\n");
  }
  /* Quake2 to Quake1, possible! */
  else if (bspMem->bspVersion == BSP_VERSION_Q2) {
    /* models */
    if (bspMem->availHeaders & LUMP_MODELS) {
      struct dmodel_t *dmodels;

      success++;
      if ((dmodels = (struct dmodel_t *)tmalloc(bspMem->shared.quake2.nummodels * sizeof(struct dmodel_t)))) {
	struct dmodel_t *d = dmodels;
	struct dmodel2_t *d2 = bspMem->shared.quake2.dmodels;

	for (i = 0; i < bspMem->shared.quake2.nummodels; i++, d++, d2++) {
	  /*d->visleafs = ??? */
	  d->headnode[0] = d2->headnode;
	  d->firstface = d2->firstface;
	  d->numfaces = d2->numfaces;
	  for (j = 0; j < 3; j++) {
	    d->mins[j] = d2->mins[j];
	    d->maxs[j] = d2->maxs[j];
	    d->origin[j] = d2->origin[j];
	  }
	}
	tfree(bspMem->shared.quake2.dmodels);
	bspMem->shared.quake1.dmodels = dmodels;
	successfull++;
      }
      else
	eprintf(failed_memory, bspMem->shared.quake2.nummodels * sizeof(struct dmodel_t), "new dmodels");
    }

    /*
     * nodes
     */
    if (bspMem->availHeaders & LUMP_NODES) {
      struct dnode_t *dnodes;

      success++;
      if ((dnodes = (struct dnode_t *)tmalloc(bspMem->shared.quake2.numnodes * sizeof(struct dnode_t)))) {
	struct dnode_t *d = dnodes;
	struct dnode2_t *d2 = bspMem->shared.quake2.dnodes;

	for (i = 0; i < bspMem->shared.quake2.numnodes; i++, d++, d2++) {
	  d->planenum = d2->planenum;
	  for (j = 0; j < 3; j++) {
	    d->mins[j] = d2->mins[j];
	    d->maxs[j] = d2->maxs[j];
	  }
	  if (d2->children[0] > 32767)
	    eprintf("node-children overflow\n");
	  d->children[0] = (short int)d2->children[0];
	  if (d2->children[1] > 32767)
	    eprintf("node-children overflow\n");
	  d->children[1] = (short int)d2->children[1];
	  d->firstface = d2->firstface;
	  d->numfaces = d2->numfaces;
	}
	tfree(bspMem->shared.quake2.dnodes);
	bspMem->shared.quake1.dnodes = dnodes;
	successfull++;
      }
      else
	eprintf(failed_memory, bspMem->shared.quake2.numnodes * sizeof(struct dnode_t), "new dnodes");
    }

    /*
     * texinfos
     */
    if (bspMem->availHeaders & LUMP_TEXINFO) {
      struct texinfo *dtexinfo;
      struct mapmemory mapMem;

      __bzero(&mapMem, sizeof(mapMem));
      AllocBSPClusters(bspMem, LUMP_TEXTURES);
      AllocMapClusters(&mapMem, MAP_TEXSTRINGS);

      success++;
      if ((dtexinfo = (struct texinfo *)tmalloc(bspMem->shared.quake2.numtexinfo * sizeof(struct texinfo)))) {
	struct texinfo *t = dtexinfo;
	struct texinfo2 *t2 = bspMem->shared.quake2.texinfo;
	char mipName[NAMELEN_MIP + 1];

	for (i = 0; i < bspMem->shared.quake2.numtexinfo; i++, t++, t2++) {
	  mipName[0] = '\0';

	  for (j = 0; j < 8; j++)
	    t->vecs[0][j] = t2->vecs[0][j];
	  /* ??? = t2->value;                           	/+ light value */

	  if (t2->flags & SURF2_NODRAW) {
	    __strcpy(mipName, CLIP_MIPMAP);
	  }
	  else {
	    /* ??? = t2->nexttexinfo;		                /+ has something to do with animatable textures */
	    if (t2->nexttexinfo != -1)
	      __strncpy(mipName, "+0", NAMELEN_MIP);		/* animatable, TODO: fix filename of nexttexinfo, we must parse out all animtexs at the beginning */

	    if (t2->flags & SURF2_SKY) {			/* "+0sky...", "sky..." */
	      __strncat(mipName, SKY_MIPMAP, NAMELEN_MIP);
	      t->flags = TEX_SPECIAL;
	    }
	    else if (t2->flags & SURF2_WARP) {			/* "+0*...", "*..." */
	      __strncat(mipName, "*", NAMELEN_MIP);
	      t->flags = TEX_SPECIAL;
	    }

	    __strncat(mipName, GetFile(t2->texture), NAMELEN_MIP);
	  }
	  t->miptex = FindMiptex(&mapMem, mipName);		/* register texturename */
	}
	tfree(bspMem->shared.quake2.texinfo);
	bspMem->shared.quake1.texinfo = dtexinfo;
	WriteMiptex(bspMem, &mapMem);				/* load the textures into memory */
	successfull++;
      }
      else
	eprintf(failed_memory, bspMem->shared.quake2.numtexinfo * sizeof(struct texinfo), "new texinfos");

      FreeMapClusters(&mapMem, MAP_TEXSTRINGS);
    }

    /*
     * leafs
     */
    if (bspMem->availHeaders & LUMP_LEAFS) {
      struct dleaf_t *dleafs;

      success++;
      if ((dleafs = (struct dleaf_t *)tmalloc(bspMem->shared.quake2.numleafs * sizeof(struct dleaf_t)))) {
	struct dleaf_t *d = dleafs;
	struct dleaf2_t *d2 = bspMem->shared.quake2.dleafs;

	for (i = 0; i < bspMem->shared.quake2.numleafs; i++, d++, d2++) {
	  if (d2->contents & CONTENTS2_SOLID)
	    d->contents = CONTENTS_SOLID;
	  else if (d2->contents & CONTENTS2_WATER)
	    d->contents = CONTENTS_WATER;
	  else if (d2->contents & CONTENTS2_SLIME)
	    d->contents = CONTENTS_SLIME;
	  else if (d2->contents & CONTENTS2_LAVA)
	    d->contents = CONTENTS_LAVA;
	  else if (d2->contents & CONTENTS2_AUX)
	    d->contents = CONTENTS_SKY;
	  else
	    d->contents = CONTENTS_EMPTY;

	  d->visofs = (int)d2->cluster;
	  /* ??? = d2->area; */
	  for (j = 0; j < 3; j++) {
	    d->mins[j] = d2->mins[j];
	    d->maxs[j] = d2->maxs[j];
	  }
	  d->firstmarksurface = d2->firstleafface;
	  d->nummarksurfaces = d2->numleaffaces;
	  /* ??? = d2->firstleafbrush; */
	  /* ??? = d2->numleafbrushes; */
	  /* d->ambient_level[...] = ??? */
	}
	tfree(bspMem->shared.quake2.dleafs);
	bspMem->shared.quake1.dleafs = dleafs;
	successfull++;
      }
      else
	eprintf(failed_memory, bspMem->shared.quake2.numleafs * sizeof(struct dleaf_t), "new dleafs");
    }

    /*
     * visibility
     */
    if (bspMem->availHeaders & LUMP_VISIBILITY) {
      unsigned char *dvisdata;

      success++;
      if ((dvisdata = (unsigned char *)tmalloc(bspMem->shared.quake2.numclusters * sizeof(int)))) {
	int *d = (int *)dvisdata;
	int *d2 = &bspMem->shared.quake2.clusters->bitofs[0][0];
	int i;

	for (i = 0; i < bspMem->shared.quake2.numclusters; i++, d2++)
	  *d++ = *d2++;

	tfree(bspMem->shared.quake2.clusters);
	bspMem->shared.quake1.dvisdata = dvisdata;
	bspMem->shared.quake1.visdatasize = bspMem->shared.quake2.numclusters * (sizeof(int) / sizeof(unsigned char));

	successfull++;
      }
      else
	eprintf(failed_memory, bspMem->shared.quake2.numclusters * sizeof(int), "new dvisdata");
    }

    if (successfull == success)
      bspMem->bspVersion = BSP_VERSION_Q1;
    else
      Error("destroyed internal bsp-representation while incorrect translation (%d correct)\n", successfull);
  }
}

/*
 * =============
 * LoadBSPFile
 *
 * this loads a bsp-file to the internal representation
 * =============
 */
bspBase LoadBSP(HANDLE bspFile, int availLoad, unsigned char versionLoad)
{
  struct memory baseMem = {0};
  bspBase bspMem;

  if ((baseMem.actBSP = bspMem = (bspBase)tmalloc(sizeof(struct bspmemory)))) {
    union header {
      struct bspheader Header1;
      struct bspheader2 Header2;
    } Header;

    __bzero(&Header, sizeof(Header));
    __bzero(bspMem, sizeof(struct bspmemory));

    oprintf("loadmask: %lx\n", availLoad);

    /*
     * load the file header
     */
    __lseek(bspFile, 0, SEEK_SET);
    __read(bspFile, &Header, sizeof(struct bspheader));

    if (Header.Header1.version == LittleLong(BSP_VERSION_Q1)) {
      mprintf("read Quake1 binary space partitioning file ...\n");
      bspMem->bspVersion = BSP_VERSION_Q1;
      bspMem->availHeaders = availLoad;

      if (availLoad & LUMP_ENTITIES)
	bspMem->shared.quake1.entdatasize = bspMem->shared.quake1.max_entdatasize = GetBlock(bspFile, &Header.Header1.entities, (void **)&bspMem->shared.quake1.dentdata, sizeof(char));

      if (availLoad & LUMP_PLANES)
	bspMem->shared.quake1.numplanes = bspMem->shared.quake1.max_numplanes = GetBlock(bspFile, &Header.Header1.planes, (void **)&bspMem->shared.quake1.dplanes, sizeof(struct dplane_t));

      if (availLoad & LUMP_TEXTURES)
	bspMem->shared.quake1.texdatasize = bspMem->shared.quake1.max_texdatasize = GetBlock(bspFile, &Header.Header1.miptex, (void **)&bspMem->shared.quake1.dtexdata, sizeof(unsigned char));

      if (availLoad & LUMP_VERTEXES)
	bspMem->shared.quake1.numvertexes = bspMem->shared.quake1.max_numvertexes = GetBlock(bspFile, &Header.Header1.vertices, (void **)&bspMem->shared.quake1.dvertexes, sizeof(struct dvertex_t));

      if (availLoad & LUMP_VISIBILITY)
	bspMem->shared.quake1.visdatasize = bspMem->shared.quake1.max_visdatasize = GetBlock(bspFile, &Header.Header1.visilist, (void **)&bspMem->shared.quake1.dvisdata, sizeof(unsigned char));

      if (availLoad & LUMP_NODES)
	bspMem->shared.quake1.numnodes = bspMem->shared.quake1.max_numnodes = GetBlock(bspFile, &Header.Header1.nodes, (void **)&bspMem->shared.quake1.dnodes, sizeof(struct dnode_t));

      if (availLoad & LUMP_TEXINFO)
	bspMem->shared.quake1.numtexinfo = bspMem->shared.quake1.max_numtexinfo = GetBlock(bspFile, &Header.Header1.texinfo, (void **)&bspMem->shared.quake1.texinfo, sizeof(struct texinfo));

      if (availLoad & LUMP_FACES)
	bspMem->shared.quake1.numfaces = bspMem->shared.quake1.max_numfaces = GetBlock(bspFile, &Header.Header1.faces, (void **)&bspMem->shared.quake1.dfaces, sizeof(struct dface_t));

      if (availLoad & LUMP_LIGHTING)
	bspMem->shared.quake1.lightdatasize = bspMem->shared.quake1.max_lightdatasize = GetBlock(bspFile, &Header.Header1.lightmaps, (void **)&bspMem->shared.quake1.dlightdata, sizeof(unsigned char));

      if (availLoad & LUMP_CLIPNODES)
	bspMem->shared.quake1.numclipnodes = bspMem->shared.quake1.max_numclipnodes = GetBlock(bspFile, &Header.Header1.clipnodes, (void **)&bspMem->shared.quake1.dclipnodes, sizeof(struct dclipnode_t));

      if (availLoad & LUMP_LEAFS)
	bspMem->shared.quake1.numleafs = bspMem->shared.quake1.max_numleafs = GetBlock(bspFile, &Header.Header1.leaves, (void **)&bspMem->shared.quake1.dleafs, sizeof(struct dleaf_t));

      if (availLoad & LUMP_MARKSURFACES)
	bspMem->shared.quake1.nummarksurfaces = bspMem->shared.quake1.max_nummarksurfaces = GetBlock(bspFile, &Header.Header1.lface, (void **)&bspMem->shared.quake1.dmarksurfaces, sizeof(unsigned short int));

      if (availLoad & LUMP_EDGES)
	bspMem->shared.quake1.numedges = bspMem->shared.quake1.max_numedges = GetBlock(bspFile, &Header.Header1.edges, (void **)&bspMem->shared.quake1.dedges, sizeof(struct dedge_t));

      if (availLoad & LUMP_SURFEDGES)
	bspMem->shared.quake1.numsurfedges = bspMem->shared.quake1.max_numsurfedges = GetBlock(bspFile, &Header.Header1.ledges, (void **)&bspMem->shared.quake1.dsurfedges, sizeof(int));

      if (availLoad & LUMP_MODELS)
	bspMem->shared.quake1.nummodels = bspMem->shared.quake1.max_nummodels = GetBlock(bspFile, &Header.Header1.models, (void **)&bspMem->shared.quake1.dmodels, sizeof(struct dmodel_t));
    }
    else if ((Header.Header2.version == LittleLong(BSP_VERSION_Q2)) && (Header.Header2.identifier == MAGIC_BSP_Q2)) {
      /* read the outstanding */
      __read(bspFile, &Header.Header2 + sizeof(struct bspheader), sizeof(struct bspheader2) - sizeof(struct bspheader));

      mprintf("read Quake2 binary space partitioning file ...\n");
      bspMem->bspVersion = BSP_VERSION_Q2;
      bspMem->availHeaders = availLoad;

      if (availLoad & LUMP_ENTITIES)
	bspMem->shared.quake2.entdatasize = bspMem->shared.quake2.max_entdatasize = GetBlock(bspFile, &Header.Header2.entities, (void **)&bspMem->shared.quake2.dentdata, sizeof(char));

      if (availLoad & LUMP_PLANES)
	bspMem->shared.quake2.numplanes = bspMem->shared.quake2.max_numplanes = GetBlock(bspFile, &Header.Header2.planes, (void **)&bspMem->shared.quake2.dplanes, sizeof(struct dplane_t));

      if (availLoad & LUMP_VERTEXES)
	bspMem->shared.quake2.numvertexes = bspMem->shared.quake2.max_numvertexes = GetBlock(bspFile, &Header.Header2.vertices, (void **)&bspMem->shared.quake2.dvertexes, sizeof(struct dvertex_t));

      if (availLoad & LUMP_VISIBILITY)
	bspMem->shared.quake2.numclusters = bspMem->shared.quake2.max_numclusters = GetBlock(bspFile, &Header.Header2.visilist, (void **)&bspMem->shared.quake2.clusters, sizeof(unsigned char));

      if (availLoad & LUMP_NODES)
	bspMem->shared.quake2.numnodes = bspMem->shared.quake2.max_numnodes = GetBlock(bspFile, &Header.Header2.nodes, (void **)&bspMem->shared.quake2.dnodes, sizeof(struct dnode2_t));

      if (availLoad & LUMP_TEXINFO)
	bspMem->shared.quake2.numtexinfo = bspMem->shared.quake2.max_numtexinfo = GetBlock(bspFile, &Header.Header2.texinfo, (void **)&bspMem->shared.quake2.texinfo, sizeof(struct texinfo2));

      if (availLoad & LUMP_FACES)
	bspMem->shared.quake2.numfaces = bspMem->shared.quake2.max_numfaces = GetBlock(bspFile, &Header.Header2.faces, (void **)&bspMem->shared.quake2.dfaces, sizeof(struct dface_t));

      if (availLoad & LUMP_LIGHTING)
	bspMem->shared.quake2.lightdatasize = bspMem->shared.quake2.max_lightdatasize = GetBlock(bspFile, &Header.Header2.lightmaps, (void **)&bspMem->shared.quake2.dlightdata, sizeof(unsigned char));

      if (availLoad & LUMP_LEAFS)
	bspMem->shared.quake2.numleafs = bspMem->shared.quake2.max_numleafs = GetBlock(bspFile, &Header.Header2.leaves, (void **)&bspMem->shared.quake2.dleafs, sizeof(struct dleaf2_t));

      if (availLoad & LUMP_LEAFFACES)
	bspMem->shared.quake2.numleaffaces = bspMem->shared.quake2.max_numleaffaces = GetBlock(bspFile, &Header.Header2.lface, (void **)&bspMem->shared.quake2.dleaffaces, sizeof(unsigned short int));

      if (availLoad & LUMP_EDGES)
	bspMem->shared.quake2.numedges = bspMem->shared.quake2.max_numedges = GetBlock(bspFile, &Header.Header2.edges, (void **)&bspMem->shared.quake2.dedges, sizeof(struct dedge_t));

      if (availLoad & LUMP_SURFEDGES)
	bspMem->shared.quake2.numsurfedges = bspMem->shared.quake2.max_numsurfedges = GetBlock(bspFile, &Header.Header2.ledges, (void **)&bspMem->shared.quake2.dsurfedges, sizeof(int));

      if (availLoad & LUMP_MODELS)
	bspMem->shared.quake2.nummodels = bspMem->shared.quake2.max_nummodels = GetBlock(bspFile, &Header.Header2.models, (void **)&bspMem->shared.quake2.dmodels, sizeof(struct dmodel2_t));

      if (availLoad & LUMP_LEAFBRUSHES)
	bspMem->shared.quake2.numleafbrushes = bspMem->shared.quake2.max_numleafbrushes = GetBlock(bspFile, &Header.Header2.leafbrushes, (void **)&bspMem->shared.quake2.dleafbrushes, sizeof(unsigned short int));

      if (availLoad & LUMP_BRUSHES)
	bspMem->shared.quake2.numbrushes = bspMem->shared.quake2.max_numbrushes = GetBlock(bspFile, &Header.Header2.brushes, (void **)&bspMem->shared.quake2.dbrushes, sizeof(struct dbrush2_t));

      if (availLoad & LUMP_BRUSHSIDES)
	bspMem->shared.quake2.numbrushsides = bspMem->shared.quake2.max_numbrushsides = GetBlock(bspFile, &Header.Header2.brushsides, (void **)&bspMem->shared.quake2.dbrushsides, sizeof(struct dbrushside2_t));

      if (availLoad & LUMP_AREAS)
	bspMem->shared.quake2.numareas = bspMem->shared.quake2.max_numareas = GetBlock(bspFile, &Header.Header2.areas, (void **)&bspMem->shared.quake2.dareas, sizeof(struct darea2_t));

      if (availLoad & LUMP_AREAPORTALS)
	bspMem->shared.quake2.numareaportals = bspMem->shared.quake2.max_numareaportals = GetBlock(bspFile, &Header.Header2.areaportals, (void **)&bspMem->shared.quake2.dareaportals, sizeof(struct dareaportal2_t));

      if (availLoad & LUMP_POPS)
	bspMem->shared.quake2.numpops = bspMem->shared.quake2.max_numpops = GetBlock(bspFile, &Header.Header2.pops, (void **)&bspMem->shared.quake2.dpops, sizeof(unsigned char));
    }
    else {
      tfree(bspMem);
      bspMem = 0;
      eprintf("no valid bsp-file\n");
      return 0;
    }

    /*
     * swap everything
     */
    SwapBSPFile(bspMem, FALSE);

    /*
     * convert to opposite
     */
    if (((bspMem->bspVersion == BSP_VERSION_Q1) && (versionLoad == BSP_VERSION_Q2)) ||
	((bspMem->bspVersion == BSP_VERSION_Q2) && (versionLoad == BSP_VERSION_Q1)))
      ConvertBSP(bspMem);
  }

  return bspMem;
}

/*
 * =============
 * WriteBSPFile
 *
 * this safes the bsp file out of the internal representation
 * =============
 */
void WriteBSP(bspBase bspMem, HANDLE bspFile, unsigned char versionSave)
{
  if (bspMem) {
    /*
     * convert to opposite
     */
    if (((bspMem->bspVersion == BSP_VERSION_Q1) && (versionSave == BSP_VERSION_Q2)) ||
	((bspMem->bspVersion == BSP_VERSION_Q2) && (versionSave == BSP_VERSION_Q1)))
      ConvertBSP(bspMem);

    /*
     * swap everything
     */
    SwapBSPFile(bspMem, TRUE);

    if (bspMem->bspVersion == BSP_VERSION_Q1) {
      struct bspheader Header;
      __bzero(&Header, sizeof(struct bspheader));

      Header.version = LittleLong(BSP_VERSION_Q1);

      /*
       * save the file header
       */
      __lseek(bspFile, 0, SEEK_SET);
      __write(bspFile, &Header, sizeof(struct bspheader));

      if (bspMem->availHeaders & LUMP_PLANES)
	PutBlock(bspFile, &Header.planes, (void *)bspMem->shared.quake1.dplanes, bspMem->shared.quake1.numplanes * sizeof(struct dplane_t));

      if (bspMem->availHeaders & LUMP_LEAFS)
	PutBlock(bspFile, &Header.leaves, (void *)bspMem->shared.quake1.dleafs, bspMem->shared.quake1.numleafs * sizeof(struct dleaf_t));

      if (bspMem->availHeaders & LUMP_VERTEXES)
	PutBlock(bspFile, &Header.vertices, (void *)bspMem->shared.quake1.dvertexes, bspMem->shared.quake1.numvertexes * sizeof(struct dvertex_t));

      if (bspMem->availHeaders & LUMP_NODES)
	PutBlock(bspFile, &Header.nodes, (void *)bspMem->shared.quake1.dnodes, bspMem->shared.quake1.numnodes * sizeof(struct dnode_t));

      if (bspMem->availHeaders & LUMP_TEXINFO)
	PutBlock(bspFile, &Header.texinfo, (void *)bspMem->shared.quake1.texinfo, bspMem->shared.quake1.numtexinfo * sizeof(struct texinfo));

      if (bspMem->availHeaders & LUMP_FACES)
	PutBlock(bspFile, &Header.faces, (void *)bspMem->shared.quake1.dfaces, bspMem->shared.quake1.numfaces * sizeof(struct dface_t));

      if (bspMem->availHeaders & LUMP_CLIPNODES)
	PutBlock(bspFile, &Header.clipnodes, (void *)bspMem->shared.quake1.dclipnodes, bspMem->shared.quake1.numclipnodes * sizeof(struct dclipnode_t));

      if (bspMem->availHeaders & LUMP_MARKSURFACES)
	PutBlock(bspFile, &Header.lface, (void *)bspMem->shared.quake1.dmarksurfaces, bspMem->shared.quake1.nummarksurfaces * sizeof(unsigned short int));

      if (bspMem->availHeaders & LUMP_SURFEDGES)
	PutBlock(bspFile, &Header.ledges, (void *)bspMem->shared.quake1.dsurfedges, bspMem->shared.quake1.numsurfedges * sizeof(int));

      if (bspMem->availHeaders & LUMP_EDGES)
	PutBlock(bspFile, &Header.edges, (void *)bspMem->shared.quake1.dedges, bspMem->shared.quake1.numedges * sizeof(struct dedge_t));

      if (bspMem->availHeaders & LUMP_MODELS)
	PutBlock(bspFile, &Header.models, (void *)bspMem->shared.quake1.dmodels, bspMem->shared.quake1.nummodels * sizeof(struct dmodel_t));

      if (bspMem->availHeaders & LUMP_LIGHTING)
	PutBlock(bspFile, &Header.lightmaps, (void *)bspMem->shared.quake1.dlightdata, bspMem->shared.quake1.lightdatasize * sizeof(unsigned char));

      if (bspMem->availHeaders & LUMP_VISIBILITY)
	PutBlock(bspFile, &Header.visilist, (void *)bspMem->shared.quake1.dvisdata, bspMem->shared.quake1.visdatasize * sizeof(unsigned char));

      if (bspMem->availHeaders & LUMP_ENTITIES)
	PutBlock(bspFile, &Header.entities, (void *)bspMem->shared.quake1.dentdata, bspMem->shared.quake1.entdatasize * sizeof(char));

      if (bspMem->availHeaders & LUMP_TEXTURES)
	PutBlock(bspFile, &Header.miptex, (void *)bspMem->shared.quake1.dtexdata, bspMem->shared.quake1.texdatasize * sizeof(unsigned char));

      /*
       * save the file header
       */
      __lseek(bspFile, 0, SEEK_SET);
      __write(bspFile, &Header, sizeof(struct bspheader));

      /*
       * tfree(bspMem); 
       */
    }
    else {
      struct bspheader2 Header;
      __bzero(&Header, sizeof(struct bspheader2));

      Header.identifier = MAGIC_BSP_Q2;
      Header.version = LittleLong(BSP_VERSION_Q2);

      /*
       * save the file header
       */
      eprintf("saving of quake2 bsps currently not supported\n");
    }
  }
}
