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
#include "../include/libqdisplay.h"

/*
 * Script-System:
 * 
 * commands:
 * "process <file>.<ext>"                               -> take this file upto
 * "finish <file>.<ext>"                                -> here
 * "list <file>.<ext>"                                  -> list the contents
 * "view <file>.<ext>"                                  -> view the pictures or texts in a window, or whatever
 * 
 * sub-commands <PAK>:
 * "OP_UPDATE <file>.<ext> as <name>"                   -> OP_ADD if not exists, OP_REPLACE if newer
 * "OP_REPLACE <file>.<ext> as <name>"                  -> OP_REPLACE if exists, do NOT OP_ADD
 * "OP_ADD <file>.<ext> as <name>"                      -> OP_ADD if not exists, do NOT OP_REPLACE
 * "OP_DELETE <name>"                                   -> OP_DELETE if exists
 * "OP_EXTRACT <name> as <file>.<ext>"                  -> OP_EXTRACT if exists
 * 
 * sub-commands <WAD>:
 * -multiple same names are allowed, but with different types
 * "OP_UPDATE <file>.<ext> as <name> as <type>"         -> OP_ADD if not exists, OP_REPLACE if newer
 * "OP_REPLACE <file>.<ext> as <name> as <type>"        -> OP_REPLACE if exists, do NOT OP_ADD
 * "OP_ADD <file>.<ext> as <name> as <type>"            -> OP_ADD if not exists, do NOT OP_REPLACE
 * "OP_DELETE <name> as <type>"                         -> OP_DELETE if exists
 * "OP_EXTRACT <name> as <file>.<ext> as <type>"        -> OP_EXTRACT if exists
 * 
 * sub-commands <BSP>:
 * sub-commands <MDL>:
 * 
 */

/*
 * basic main-skeleton
 *
 * extension-type system:
 *  .wad -> wad-archive
 *  .bsp -> bsp
 *  .pak -> pak-archive
 *  .mdl -> models
 *  .spr -> sprites
 *
 *  .ppm -> ppm-picture
 *  .mip -> miptexture
 *  .lmp -> console-picture
 *  .stb -> statusbar-picture
 *  .pal -> palettes
 *  .wav -> wave-sounds
 *  .dat -> pseudo-code
 *  .rc  -> resource
 *  .cfg -> config
 *  .tri -> triangle
 *  .map -> map
 *  .skn -> skin-picture (lmp)
 *  .frm -> frame-picture (lmp)
 *
 * hierachy-system:
 *   game                                               -> pak?.pak
 *   game/pak?.dir                                      -> ?.dat, ...
 *   game/pak?.dir/gfx                                  -> ?.lmp
 *   game/pak?.dir/maps                                 -> ?.bsp
 *   game/pak?.dir/maps/?.dir                           -> ?.map, ?.wad
 *   game/pak?.dir/maps/?.dir/?.dir                     -> ?.mip/ppm, ?.lmp, ?.pal, ?.stb
 *   game/pak?.dir/progs                                -> ?.mdl, ?.spr
 *   game/pak?.dir/progs/?.dir                          -> ?-?.tri, ?-?.skn
 *   game/pak?.dir/progs/?.dir                          -> ?-?.frm
 *   game/pak?.dir/sounds                               -> ?.wav
 * example:
 *   game/pak0.pak
 *   game/pak0.dir/default.cfg                          -> pak0.pak  (makpak)
 *   game/pak0.dir/gfx/colormap.lmp                     -> pak0.pak  (makpak)
 *   game/pak0.dir/gfx/conback.lmp                      -> pak0.pak  (repak)
 *   game/pak0.dir/gfx/palette.lmp                      -> pak0.pak  (repak)
 *   game/pak0.dir/maps/start.bsp                       -> pak0.pak  (repak)
 *   game/pak0.dir/maps/start.dir/start.map             -> start.bsp (qbsp)
 *   game/pak0.dir/maps/start.dir/start.wad             -> start.bsp (qbsp)
 *   game/pak0.dir/maps/start.dir/start.dir/text1.mip   -> start.wad (rewad)
 *   game/pak0.dir/maps/start.dir/start.dir/text2.mip   -> start.wad (rewad)
 *   game/pak0.dir/progs/ogre.mdl                       -> pak0.pak  (repak)
 *   game/pak0.dir/progs/ogre.dir/ogre-0.tri            -> ogre.mdl  (mdlgen)
 *   game/pak0.dir/progs/ogre.dir/ogre-1.tri            -> ogre.mdl  (mdlgen)
 *   game/pak0.dir/progs/ogre.dir/ogre-0.skn            -> ogre.mdl  (mdlgen)
 *   game/pak0.dir/progs/fire.spr                       -> pak0.pak  (repak)
 *   game/pak0.dir/progs/fire.dir/fire-0.frm            -> fire.spr  (sprgen)
 *   game/pak0.dir/progs/fire.dir/fire-1.frm            -> fire.spr  (sprgen)
 */

char *OperationToText(operation Oper)
{
  switch(Oper) {
    case OP_ADD:	return "add";
    case OP_DELETE:	return "delete";
    case OP_EXTRACT:	return "extract";
    case OP_LIST:	return "list";
    case OP_REPLACE:	return "replace";
    case OP_UPDATE:	return "update";
    case OP_VIEW:	return "view";
    case OP_DEFAULT:
    default:		return "default action";
  }
}

void AppendType(char *Original, filetype Type, char *Default) {
  switch (Type) {
    case TYPE_PPM: 	 __strncat(Original, ".ppm", NAMELEN_PATH - 1);  break;
    case TYPE_JPEG:	 __strncat(Original, ".jpg", NAMELEN_PATH - 1);  break;
    case TYPE_ILBM:	 __strncat(Original, ".iff", NAMELEN_PATH - 1);  break;
    case TYPE_PNG: 	 __strncat(Original, ".png", NAMELEN_PATH - 1);  break;
    case TYPE_WAD2:	 __strncat(Original, ".wad", NAMELEN_PATH - 1);  break;
    case WAD2_PALETTE:   __strncat(Original, ".pal", NAMELEN_PATH - 1);  break;
    case WAD2_STATUSBAR: __strncat(Original, ".stb", NAMELEN_PATH - 1);  break;
    case WAD2_MIPMAP:    __strncat(Original, ".mip", NAMELEN_PATH - 1);  break;
    case WAD2_CONPIC:    __strncat(Original, ".lmp", NAMELEN_PATH - 1);  break;
    case TYPE_RAW:       __strncat(Original, ".xxx", NAMELEN_PATH - 1);  break;
    case TYPE_NONE:
    default:		 __strncat(Original, Default, NAMELEN_PATH - 1); break;
  }
}

bool processType(char *procName, filetype procType,
		 char *destDir,
		 char *outName, filetype outType,
		 char *arcName, filetype arcType,
		 operation procOper,
		 bool script, bool recurse)
{
  FILE *destFile, *scrpFile, *procFile;
  HANDLE destHandle;

#ifdef	PRINTCALLS
  mprintf("processType(%s, %d, %s, %s, %d, %s, %d, %d, %d, %d)\n", procName, procType, destDir, outName, outType, arcName, arcType, procOper, script, recurse);
#endif

  if ((procFile = __fopen(procName, F_READWRITE_BINARY_OLD))) {
    /* get extension */
      struct palpic *inPic;
      struct rawdata *inData;
      char idxName[NAMELEN_PATH + 1];

      inPic = 0;
      inData = 0;

      __strncpy(idxName, destDir, NAMELEN_PATH - 1);
      __strncat(idxName, procName, NAMELEN_PATH - 1);
      ReplaceExt(idxName, "idx");

      /* script-based execution */
      if (procType == TYPE_INDEX) {
	char command[NAMELEN_PATH], parameter[NAMELEN_PATH];
	char *nameStack[NAMELEN_PATH];
	short int nameCount;
	char *thisName;

	nameCount = 0;
	nameStack[0] = 0;

	/* process are now stackable -> proces ... process ... finish ... finish */
	while (fscanf(procFile, "%256s %256[^\n]\n", command, parameter) != EOF) {
	  if (!__strcasecmp(command, "process")) {
	    if (!(thisName = nameStack[++nameCount] = smalloc(parameter)))
	      eprintf("cannot allocate process-stack");
	  }
	  else if ((!__strcasecmp(command, "dither")) && (thisName)) {
	    char Bool;
	    int Value;

	    sscanf(parameter, "%c with %d", &Bool, &Value);
	    if (Bool == 1) {
	      /* activate dithering with specified value */
	      dither = TRUE;
	      dithervalue = Value;
	    }
	    else if (Bool == 0) {
	      /* deactivate dithering and reset dithervalue */
	      dither = FALSE;
	      dithervalue = 16;
	    }
	  }
	  else if ((!__strcasecmp(command, "compress")) && (thisName)) {
	    char Bool;
	    int Value;

	    sscanf(parameter, "%c with %d", &Bool, &Value);
	    if (Bool == 1)
	      Compression = Value;
	    else if (Bool == 0)
	      Compression = CMP_NONE;
	  }
	  else if ((!__strcasecmp(command, OperationToText(OP_UPDATE))) && (thisName)) {
	    char fileName[NAMELEN_PATH], entryName[NAMELEN_MAXQUAKE], entryType;

	    sscanf(parameter, "%256s as %56s as %c", fileName, entryName, &entryType);
	    processName(fileName, destDir, thisName, outType, entryName, entryType, OP_UPDATE, script, recurse);
	  }
	  else if ((!__strcasecmp(command, OperationToText(OP_REPLACE))) && (thisName)) {
	    char fileName[NAMELEN_PATH], entryName[NAMELEN_MAXQUAKE], entryType;

	    sscanf(parameter, "%256s as %56s as %c", fileName, entryName, &entryType);
	    processName(fileName, destDir, thisName, outType, entryName, entryType, OP_REPLACE, script, recurse);
	  }
	  else if ((!__strcasecmp(command, OperationToText(OP_ADD))) && (thisName)) {
	    char fileName[NAMELEN_PATH], entryName[NAMELEN_MAXQUAKE], entryType;

	    sscanf(parameter, "%256s as %56s as %c", fileName, entryName, &entryType);
	    processName(fileName, destDir, thisName, outType, entryName, entryType, OP_ADD, script, recurse);
	  }
	  else if ((!__strcasecmp(command, OperationToText(OP_DELETE))) && (thisName)) {
	    char entryName[NAMELEN_MAXQUAKE], entryType;

	    sscanf(parameter, "%56s as %c", entryName, &entryType);
	    processName(thisName, 0, 0, outType, entryName, entryType, OP_DELETE, script, recurse);
	  }
	  else if ((!__strcasecmp(command, OperationToText(OP_EXTRACT))) && (thisName)) {
	    char fileName[NAMELEN_PATH], entryName[NAMELEN_MAXQUAKE], entryType;

	    sscanf(parameter, "%256s as %56s as %c", entryName, fileName, &entryType);
	    processName(thisName, destDir, fileName, outType, entryName, entryType, OP_EXTRACT, script, recurse);
	  }
	  else if ((!__strcasecmp(command, "finish")) && (thisName)) {
	    tfree(nameStack[nameCount]);
	    thisName = nameStack[--nameCount];
	  }
	  else
	    eprintf("unknown command, cannot execute line \"%s\" ... \n", command);
	}
	/* free resources in case of unfinished processes */
	while (nameCount)
	  tfree(nameStack[nameCount--]);
      }
      /* directory-based execution */
      else if (procType == TYPE_DIRECTORY) {
	DIR *procDir;
	struct dirent *dirEnt;
	
	/* reset arcType if it was the same as procType */
	if(arcType == TYPE_DIRECTORY)
	  arcType = TYPE_NONE;

	if ((procDir = opendir(procName))) {
	  while ((dirEnt = readdir(procDir))) {
	    if (__strcmp(dirEnt->d_name, STR_FOR_CURRENT) && __strcmp(dirEnt->d_name, STR_FOR_PARENT)) {
	      char dirName[NAMELEN_PATH];

	      __strncpy(dirName, procName, NAMELEN_PATH - 1);
	      __strncat(dirName, STR_FOR_DIR, NAMELEN_PATH - 1);
	      __strncat(dirName, dirEnt->d_name, NAMELEN_PATH - 1);
	      /*
	       * if outName == 0, process the dir entirely
	       * else add the complete to outName
	       */
	      processName(dirName, destDir, outName, outType, 0, arcType, procOper, script, recurse);
	    }
	  }
	  closedir(procDir);
	}
	else
	  eprintf("failed to access directory %s\n", procName);
      }
      else if ((procType == TYPE_PALETTE) ||
	       (procType == TYPE_CONFIG) ||
	       (procType == TYPE_DEMO) ||
	       (procType == TYPE_FRAME) ||
	       (procType == TYPE_ILBM) ||
	       (procType == TYPE_JPEG) ||
	       (procType == TYPE_LIT) ||
	       (procType == TYPE_LUMP) ||
	       (procType == TYPE_MAP) ||
	       (procType == TYPE_MIPMAP) ||
	       (procType == TYPE_PNG) ||
	       (procType == TYPE_PPM) ||
	       (procType == TYPE_RESOURCE) ||
	       (procType == TYPE_SKIN) ||
	       (procType == TYPE_STATUSBAR) ||
	       (procType == TYPE_TRIANGLE) ||
	       (procType == TYPE_VIS) ||
	       (procType == TYPE_WAL) ||
	       (procType == TYPE_WAVE)) {
	if (outType == TYPE_PACK) {
	  mprintf("read raw %s\t-> ", procName);
	  inData = GetRaw(fileno(procFile), procName, 0);
	}
	else if (procType == TYPE_MIPMAP) {
	  mprintf("read mipmap %s\t-> ", procName);
	  inPic = GetMipMap(fileno(procFile), MIPMAP_0);
	}
	else if (procType == TYPE_WAL) {
	  mprintf("read wal %s\t-> ", procName);
	  inPic = 0;						/* GetWal(procFile, 0); */
	}
	else if ((procType == TYPE_LUMP) || (procType == TYPE_STATUSBAR)) {
	  mprintf("read lump %s\t-> ", procName);
	  inPic = GetLMP(fileno(procFile), arcName ? arcName : procName);
	}
	else if (procType == TYPE_IMAGE) {
	  short int alignX = 1, alignY = 1;

	  /* special size-rules if we convert to a mipmap */
	  if ((outType == TYPE_MIPMAP) || (outType == TYPE_WAD2) || (outType == TYPE_BSP)) {
	    alignX = alignY = 16;
	    if (isWarp(outName))
	      alignX = alignY = WARP_X;
	    else if (isSky(outName)) {
	      alignX = -(SKY_X);
	      alignY = -(SKY_Y);
	    }
	  }
	  mprintf("read image %s\t-> ", procName);
	  inPic = GetImage(procFile, arcName ? arcName : procName, alignX, alignY);
	}
	else if (procType == TYPE_TRIANGLE) {
	  mprintf("read tri %s\t-> ", procName);
	  inData = 0;
	}
	else if (procType == TYPE_IMAGINE) {
	  mprintf("read iob %s\t-> ", procName);
	  inData = GetRaw(fileno(procFile), procName, 0);
	}
	else if (procType == TYPE_MAP) {
	  mprintf("read map %s\t-> ", procName);
	  inData = GetRaw(fileno(procFile), procName, 0);
	}
	else {
	  mprintf("read raw %s\t-> ", procName);
	  inData = GetRaw(fileno(procFile), procName, 0);
	}

	if (inPic || inData) {
	  /* convert to ppm */
	  if (((outType == TYPE_PPM) ||
	       (outType == TYPE_JPEG) ||
	       (outType == TYPE_ILBM) ||
	       (outType == TYPE_PNG)) && inPic) {
	    mprintf("write image %s\n", outName);
	    if ((destFile = __fopen(outName, F_WRITE_BINARY))) {
	      if (PutImage(destFile, inPic, outType) == FALSE)
		eprintf("failed to convert pic\n");
	      __fclose(destFile);
	    }
	    else
	      eprintf(failed_fileopen, outName);
	  }
	  /* convert to mip */
	  else if ((outType == TYPE_MIPMAP) && inPic) {
	    mprintf("write mip %s\n", outName);
	    if ((destHandle = __open(outName, H_WRITE_BINARY)) > 0) {
	      if (PutMipMap(destHandle, inPic) == FALSE)
		eprintf("failed to convert to mip\n");
	      __close(destHandle);
	    }
	    else
	      eprintf(failed_fileopen, outName);
	  }
	  /* convert to lump */
	  else if ((outType == TYPE_LUMP) && inPic) {
	    mprintf("write lump %s\n", outName);
	    if ((destHandle = __open(outName, H_WRITE_BINARY))) {
	      if (PutLMP(destHandle, inPic) == FALSE)
		eprintf("failed to convert to lump\n");
	      __close(destHandle);
	    }
	    else
	      eprintf(failed_fileopen, outName);
	  }
	  /* convert to imagine */
	  else if ((outType != TYPE_BSP) && ((procType == TYPE_MAP) || (procType == TYPE_IMAGINE)) && inData) {
	    struct bspmemory bspMem;
	    struct mapmemory mapMem;
	    bool retval = FALSE;

	    mprintf("write to %s\n", outName);
	    __bzero(&bspMem, sizeof(bspMem));
	    __bzero(&mapMem, sizeof(mapMem));
	    AllocBSPClusters(&bspMem, LUMP_TEXINFO);
	    AllocMapClusters(&mapMem, ALL_MAPS);

	    if (procType == TYPE_MAP)
	      retval = LoadMapFile(&bspMem, &mapMem, (char *)inData->rawdata);
	    else
	      retval = LoadTDDDFile(&bspMem, &mapMem, inData->rawdata);

	    if (retval) {
	      if (outType == TYPE_MAP) {
		if ((destFile = __fopen(outName, "w"))) {
		  retval = SaveMapFile(&bspMem, &mapMem, destFile);
		  __fclose(destFile);
		}
		else
		  eprintf(failed_fileopen, outName);
	      }
	      else if (outType == TYPE_IMAGINE) {
		if ((destFile = __fopen(outName, F_WRITE_BINARY))) {
		  retval = SaveTDDDFile(&bspMem, &mapMem, fileno(destFile));
		  __fclose(destFile);
		}
		else
		  eprintf(failed_fileopen, outName);
	      }
	      else {
		WriteMiptex(&bspMem, &mapMem);
		retval = ExtractMipTex(&bspMem, scrpFile, destDir, outName, outType == TYPE_WAD2 ? NULL : arcName, outType, procOper, recurse, outType == TYPE_WAD2 ? TRUE : FALSE);
	      }

	      if (!retval)
		eprintf(failed_filewrite, outName);
	    }
	    else
	      eprintf(failed_fileload, procName);

	    FreeBSPClusters(&bspMem, 0);
	    FreeMapClusters(&mapMem, 0);
	  }
	  /* OP_ADD to pak-file */
	  else if (outType == TYPE_PACK) {
/*	    mprintf("%s %s to pak %s\n", OperationToText(procOper), procName, outName); */
	    if (!AddPAK(inPic, inData, outName, procOper))
	      eprintf("failed to add %s to pak %s\n", procName, outName);
	  }
	  /* OP_ADD to wad2-file */
	  else if (outType == TYPE_WAD2) {
	    if((arcType == TYPE_NONE) &&
	       ((procType == WAD2_CONPIC) || (procType == WAD2_MIPMAP) ||
		(procType == WAD2_STATUSBAR) || (procType == WAD2_PALETTE)))
	      arcType = procType;
	  
/*	    mprintf("%s %s to wad %s\n", OperationToText(procOper), procName, outName); */
	    if (!AddWAD2(inPic, inData, outName, procOper, arcType))
	      eprintf("failed to add %s to wad %s\n", procName, outName);
	  }
	  /* OP_ADD to bsp-file */
	  else if (outType == TYPE_BSP) {
/*	    mprintf("%s %s to bsp %s\n", OperationToText(procOper), procName, outName); */
	    if (!AddBSP(inPic, inData, outName, procOper, arcType))
	      eprintf("failed to add %s to bsp %s\n", procName, outName);
	  }
	  /* OP_ADD to mdl-file */
	  else if (outType == TYPE_MODEL) {
	  }
	  /* OP_ADD to spr-file */
	  else if (outType == TYPE_SPRITE) {
	  }
	  /* view the pictures */
	  else if ((procOper == OP_VIEW) && inPic) {
	    mprintf(oper_view, inPic->name, procName);
	    if (procType != TYPE_MIPMAP)
	      DisplayPicture(inPic->rawdata, inPic->name, inPic->width, inPic->height, 8, FALSE);
	    else
	      DisplayMipMap(inPic->rawdata, inPic->name, inPic->width, inPic->height, 8, FALSE);
	  }
	  /* list the picture-data */
	  else if ((procOper == OP_LIST) && inPic) {
	    mprintf(oper_view, inPic->name, procName);
	    mprintf(" width  %d\n height %d\n", inPic->width, inPic->height);
	  }
	  else
	    eprintf("dont know how to convert %s to %s\n", procName, outName);

	  /* tfree resources */
	  if (inPic)
	    pfree(inPic);
	  if (inData)
	    rfree(inData);
	}
	else
	  eprintf(failed_fileread, procName);
      }
      else if (procType == TYPE_QUAKEC) {
	char srcDir[NAMELEN_PATH], *tmp;

	__strncpy(srcDir, procName, NAMELEN_PATH - 1);
	/* find parent dir */
	if ((tmp = (char *)__strrchr(srcDir, CHAR_FOR_DIR)))
	  tmp[1] = '\0';
	else
	  srcDir[0] = '\0';
	if (!qcc(procFile, srcDir, procOper))
	  eprintf("cannot compile full %s\n", procName);
      }
      /* archives to archive */
      else if ((outType == TYPE_PACK) && (procType != TYPE_PACK)) {
/*	mprintf("%s %s to pak %s\n", OperationToText(procOper), procName, outName); */
	if ((inData = GetRaw(fileno(procFile), arcName, 0))) {
	  if (!AddPAK(0, inData, outName, procOper))
	    eprintf("failed to %s %s to pak %s\n", OperationToText(procOper), procName, outName);
	  rfree(inData);
	}
	else
	  eprintf(failed_fileread, procName);
      }
      /* archive to parts */
      else if ((procType == TYPE_PACK) ||
	       (procType == TYPE_WAD2) ||
	       (procType == TYPE_SPRITE) ||
	       (procType == TYPE_MODEL) ||
	       (procType == TYPE_CODE) ||
	       (procType == TYPE_BSP)) {
	if (script) {
	  if ((scrpFile = __fopen(idxName, F_WRITE_BINARY))) {
	    fprintf(scrpFile, "process %s\n", procName);
	    if (dither)
	      fprintf(scrpFile, "dither %1d with %3d\n", 1, dithervalue);
	    else
	      fprintf(scrpFile, "dither %1d with %3d\n", 0, dithervalue);
	    if (Compression != CMP_NONE)
	      fprintf(scrpFile, "compress %1d with %3d\n", 1, Compression);
	    else
	      fprintf(scrpFile, "compress %1d with %3d\n", 0, Compression);
	  }
	}

	if ((!destDir) || (*destDir == '\0')) {
	  ReplaceExt(idxName, "dir" STR_FOR_DIR);
	  destDir = idxName;
	}

	/* pak to parts */
	if (procType == TYPE_PACK) {
	  mprintf("%s %s from pak %s\n", OperationToText(procOper), arcName ? arcName : "everything", procName);
	  if (!ExtractPAK(fileno(procFile), scrpFile, destDir, arcName, outType, procOper, recurse))
	    eprintf("failed to extract full pak %s\n", procName);
	}
	/* wad to parts */
	else if (procType == TYPE_WAD2) {
	  if((arcType == TYPE_NONE) &&
	     ((outType == WAD2_CONPIC) ||
	      (outType == WAD2_MIPMAP) ||
	      (outType == WAD2_STATUSBAR) ||
	      (outType == WAD2_PALETTE)))
	    arcType = outType;
	  
	  mprintf("%s %s from wad %s\n", OperationToText(procOper), arcName ? arcName : "everything", procName);
	  if (!ExtractWAD2(fileno(procFile), scrpFile, destDir, arcName, outType, procOper, arcType))
	    eprintf("failed to extract full wad %s\n", procName);
	}
	/* bsp to parts */
	else if (procType == TYPE_BSP) {
	  mprintf("%s %s from bsp %s\n", OperationToText(procOper), arcName ? arcName : "everything", procName);
	  if (!ExtractBSP(fileno(procFile), scrpFile, destDir, arcName, outType, procOper, recurse))
	    eprintf("failed to extract full bsp %s\n", procName);
	}
	/* mdl to parts */
	else if (procType == TYPE_MODEL) {
	}
	/* spr to parts */
	else if (procType == TYPE_SPRITE) {
	}
	/* code to parts */
	else if (procType == TYPE_CODE) {
	  if (!unqcc(fileno(procFile), destDir, procOper))
	    eprintf("cannot decompile full %s to %s\n", procName, destDir);
	}

	if (scrpFile) {
	  fprintf(scrpFile, "finish %s\n", procName);
	  __fclose(scrpFile);
	  scrpFile = 0;
	}
      }
      else
	eprintf("dont know what to convert %s\n", procName);

    __fclose(procFile);
  }
  else
    eprintf(failed_fileopen, procName);

  return TRUE;
}

/*
 * one of outName and outType MUST be given
 */
bool processName(char *procName, char *destDir, char *outName, filetype outType, char *arcName, filetype arcType,
		 operation procOper, bool script, bool recurse)
{
  char *procExt = GetExt(procName);
  char *outExt = GetExt(outName);
  filetype procType = TYPE_UNKNOWN;
  char newName[NAMELEN_PATH + 1];
  struct stat procStat;

  /* if the dirname doesn't end with / we must add it, hmpf */
  if (destDir) {
    int len = __strlen(destDir);

    if (!((destDir[len - 1] == CHAR_FOR_DIR) || (destDir[len - 1] == CHAR_FOR_VOLUME) || (destDir[len - 1] == '\0'))) {
      char *newDir;

      if ((newDir = (char *)tmalloc(len + 2))) {
	__strcpy(newDir, destDir);
	newDir[len] = CHAR_FOR_DIR;
	destDir = newDir;
      }
    }
  }
  else
    destDir = "\0";

  if(stat(procName, &procStat) < 0) {
    eprintf("file or dir %s does not exists\n", procName);
    return FALSE;
  }

  if(!S_ISDIR(procStat.st_mode)) {
    /*
     * set default proctype
     */
    /* these are special types */
         if (!__strncasecmp(procName, "colormap", sizeof("colormap") - 1)) { procType = outType = TYPE_RAW; }
    else if (!__strncasecmp(procName, "conchars", sizeof("conchars") - 1)) { procType = outType = TYPE_RAW; }
    else if (!__strncasecmp(procName, "palette" , sizeof("palette" ) - 1)) { procType = outType = TYPE_PALETTE; }
    /* these are standard types */
    else if (!__strcasecmp(procExt, "pal")) { procType = TYPE_PALETTE; }
    else if (!__strcasecmp(procExt, "bsp")) { procType = TYPE_BSP; }
    else if (!__strcasecmp(procExt, "cfg")) { procType = TYPE_CONFIG; }
    else if (!__strcasecmp(procExt, "dat")) { procType = TYPE_CODE; }
    else if (!__strcasecmp(procExt, "dem")) { procType = TYPE_DEMO; }
 /* else if (!__strcasecmp(procExt, "dir")) { procType = TYPE_DIRECTORY; } */
    else if (!__strcasecmp(procExt, "frm")) { procType = TYPE_LUMP; }
    else if (!__strcasecmp(procExt, "idx")) { procType = TYPE_INDEX; }
    else if (!__strcasecmp(procExt, "iff")) { procType = TYPE_IMAGE; }
    else if (!__strcasecmp(procExt, "iob")) { procType = TYPE_IMAGINE; }
    else if (!__strcasecmp(procExt, "jpg")) { procType = TYPE_IMAGE; }
    else if (!__strcasecmp(procExt, "lbm")) { procType = TYPE_IMAGE; }
    else if (!__strcasecmp(procExt, "lit")) { procType = TYPE_LIT; }
    else if (!__strcasecmp(procExt, "lmp")) { procType = TYPE_LUMP; }
    else if (!__strcasecmp(procExt, "map")) { procType = TYPE_MAP; }
    else if (!__strcasecmp(procExt, "mdl")) { procType = TYPE_MODEL; }
    else if (!__strcasecmp(procExt, "mip")) { procType = TYPE_MIPMAP; }
    else if (!__strcasecmp(procExt, "obj")) { procType = TYPE_IMAGINE; }
    else if (!__strcasecmp(procExt, "pak")) { procType = TYPE_PACK; }
    else if (!__strcasecmp(procExt, "pgm")) { procType = TYPE_IMAGE; }
    else if (!__strcasecmp(procExt, "png")) { procType = TYPE_IMAGE; }
    else if (!__strcasecmp(procExt, "ppm")) { procType = TYPE_IMAGE; }
    else if (!__strcasecmp(procExt, "pnm")) { procType = TYPE_IMAGE; }
    else if (!__strcasecmp(procExt, "prt")) { procType = TYPE_PRT; }
    else if (!__strcasecmp(procExt, "rc" )) { procType = TYPE_RESOURCE; }
    else if (!__strcasecmp(procExt, "skn")) { procType = TYPE_LUMP; }
    else if (!__strcasecmp(procExt, "spr")) { procType = TYPE_SPRITE; }
    else if (!__strcasecmp(procExt, "src")) { procType = TYPE_QUAKEC; }
    else if (!__strcasecmp(procExt, "stb")) { procType = TYPE_STATUSBAR; }
    else if (!__strcasecmp(procExt, "tri")) { procType = TYPE_TRIANGLE; }
    else if (!__strcasecmp(procExt, "vis")) { procType = TYPE_VIS; }
    else if (!__strcasecmp(procExt, "wad")) { procType = TYPE_WAD2; }
    else if (!__strcasecmp(procExt, "wal")) { procType = TYPE_WAL; }
    else if (!__strcasecmp(procExt, "wav")) { procType = TYPE_WAVE; }
    else if (!__strcasecmp(procExt, "xxx")) { procType = TYPE_RAW; }
  }
  else {
    if(!recurse) {
      mprintf("%s is a directory, use -r/--recurse\n", procName);
      return TRUE;
    }
    procType = TYPE_DIRECTORY;
  }

  /*
   * set default outtype
   */
  if (outName) {
    /* these are special types */
         if (!__strncasecmp(outName, "colormap", sizeof("colormap") - 1)) { outType = TYPE_RAW; }
    else if (!__strncasecmp(outName, "conchars", sizeof("conchars") - 1)) { outType = TYPE_RAW; }
    else if (!__strncasecmp(outName, "palette" , sizeof("palette" ) - 1)) { outType = TYPE_PALETTE; }
    else if (outType == TYPE_NONE) {
      /* these are standard types */
           if (!__strcasecmp(outExt, "pal")) { outType = TYPE_PALETTE; }
      else if (!__strcasecmp(outExt, "bsp")) { outType = TYPE_BSP; }
      else if (!__strcasecmp(outExt, "cfg")) { outType = TYPE_CONFIG; }
      else if (!__strcasecmp(outExt, "dat")) { outType = TYPE_CODE; }
      else if (!__strcasecmp(outExt, "dem")) { outType = TYPE_DEMO; }
      else if (!__strcasecmp(outExt, "dir")) { outType = TYPE_DIRECTORY; }
      else if (!__strcasecmp(outExt, "frm")) { outType = TYPE_FRAME; }
      else if (!__strcasecmp(outExt, "idx")) { outType = TYPE_INDEX; }
      else if (!__strcasecmp(outExt, "iff")) { outType = TYPE_ILBM; }
      else if (!__strcasecmp(outExt, "iob")) { outType = TYPE_IMAGINE; }
      else if (!__strcasecmp(outExt, "jpg")) { outType = TYPE_JPEG; }
      else if (!__strcasecmp(outExt, "lbm")) { outType = TYPE_ILBM; }
      else if (!__strcasecmp(outExt, "lit")) { outType = TYPE_LIT; }
      else if (!__strcasecmp(outExt, "lmp")) { outType = TYPE_LUMP; }
      else if (!__strcasecmp(outExt, "map")) { outType = TYPE_MAP; }
      else if (!__strcasecmp(outExt, "mdl")) { outType = TYPE_MODEL; }
      else if (!__strcasecmp(outExt, "mip")) { outType = TYPE_MIPMAP; }
      else if (!__strcasecmp(outExt, "obj")) { outType = TYPE_IMAGINE; }
      else if (!__strcasecmp(outExt, "pak")) { outType = TYPE_PACK; }
      else if (!__strcasecmp(outExt, "png")) { outType = TYPE_PNG; }
      else if (!__strcasecmp(outExt, "ppm")) { outType = TYPE_PPM; }
      else if (!__strcasecmp(outExt, "pnm")) { outType = TYPE_PPM; }
      else if (!__strcasecmp(outExt, "prt")) { outType = TYPE_PRT; }
      else if (!__strcasecmp(outExt, "rc" )) { outType = TYPE_RESOURCE; }
      else if (!__strcasecmp(outExt, "skn")) { outType = TYPE_SKIN; }
      else if (!__strcasecmp(outExt, "spr")) { outType = TYPE_SPRITE; }
      else if (!__strcasecmp(outExt, "src")) { outType = TYPE_QUAKEC; }
      else if (!__strcasecmp(outExt, "stb")) { outType = TYPE_STATUSBAR; }
      else if (!__strcasecmp(outExt, "tri")) { outType = TYPE_TRIANGLE; }
      else if (!__strcasecmp(outExt, "vis")) { outType = TYPE_VIS; }
      else if (!__strcasecmp(outExt, "wad")) { outType = TYPE_WAD2; }
      else if (!__strcasecmp(outExt, "wal")) { outType = TYPE_WAL; }
      else if (!__strcasecmp(outExt, "wav")) { outType = TYPE_WAVE; }
      else if (!__strcasecmp(outExt, "xxx")) { outType = TYPE_RAW; }
    }
    __strncpy(newName, outName, NAMELEN_PATH - 1);
  }
  /*
   * set default outname
   */
  else {
    __strncpy(newName, destDir, NAMELEN_PATH - 1);
    __strncat(newName, procName, NAMELEN_PATH - 1);
    switch (outType) {
      case TYPE_PPM:	 ReplaceExt(newName, "ppm"); break;
      case TYPE_JPEG:	 ReplaceExt(newName, "jpg"); break;
      case TYPE_ILBM:	 ReplaceExt(newName, "iff"); break;
      case TYPE_PNG:	 ReplaceExt(newName, "png"); break;
      case TYPE_WAL:	 ReplaceExt(newName, "wal"); break;
      case TYPE_MIPMAP:	 ReplaceExt(newName, "mip"); break;
      case TYPE_LUMP:	 ReplaceExt(newName, "lmp"); break;
      case TYPE_PALETTE: ReplaceExt(newName, "pal"); break;
      case TYPE_RAW:	 ReplaceExt(newName, "xxx"); break;
      default:					     break;
    }
  }

  /*
   * set default arcname
   *
   * behaviour:
   *  * / *.* -> *.pak  arcName = * / *.*
   *  * / *.* -> *.wad  arcName =     *
   *  * / *.* -> *.bsp  arcName =     *
   *  *.pak -> * / *.*  arcName = * / *.*
   *  *.wad -> * / *.*  arcName =     *
   *  *.bsp -> * / *.*  arcName =     *
   *  *.bsp -> *.wad    arcName = *.wad
   */
  if (!arcName) {
    if ( (outType == TYPE_PACK) ||
	((outType == TYPE_WAD2) && (procType != TYPE_WAD2)) ||
	 (outType == TYPE_SPRITE) ||
	 (outType == TYPE_MODEL) ||
	 (outType == TYPE_BSP)) {
      arcName = smalloc(procName);
      if (arcType == TYPE_NONE)
	arcType = procType;
    }
    else {
      arcName = smalloc(outName);
      if (arcType == TYPE_NONE)
	arcType = outType;
    }
  }

  if (!((outType == TYPE_PACK) || (procType == TYPE_PACK) ||
	((procType == TYPE_BSP) && ((outType == TYPE_MAP) || (outType == TYPE_IMAGINE) || (outType == TYPE_LIT) || (outType == TYPE_VIS) || (outType == TYPE_WAD2))) ||
	((outType == TYPE_WAD2) && (procType == TYPE_WAD2)))) {
    arcName = GetFile(arcName);
    StripExt(arcName);
  }

  outName = newName;
  return processType(procName, procType, destDir, outName, outType, arcName, arcType, procOper, script, recurse);
}
