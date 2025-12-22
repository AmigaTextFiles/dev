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

#include <libqtools.h>
#include <libqbuild.h>

/*
 * ==================
 * main
 * 
 * ==================
 */
int main(int argc, char **argv)
{
  char bspName[NAMELEN_PATH], mapName[NAMELEN_PATH], *mapBuf;
  int i, subdivide_size = 240;
  HANDLE bspFile;
  struct bspmemory bspMem;
  struct mapmemory mapMem;

#if defined(DEBUG_C) && defined(HAVE_LIBDBMALLOC)
  union dbmalloptarg m;

  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_WARN, &m);
  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_FATAL, &m);
#endif

  __bzero(&bspMem, sizeof(struct bspmemory));
  __bzero(&mapMem, sizeof(struct mapmemory));

  if (!setjmp(eabort)) {
    /* check command line flags */
    for (i = 1; i < argc; i++) {
      if (argv[i][0] != '-')
	break;
      else if (!strcmp(argv[i], "-watervis"))
	mapMem.mapOptions |= QBSP_WATERVIS;
      else if (!strcmp(argv[i], "-slimevis"))
	mapMem.mapOptions |= QBSP_SLIMEVIS;
      else if (!strcmp(argv[i], "-notjunc"))
	mapMem.mapOptions |= QBSP_NOTJUNC;
      else if (!strcmp(argv[i], "-nofill"))
	mapMem.mapOptions |= QBSP_NOFILL;
      else if (!strcmp(argv[i], "-noclip"))
	mapMem.mapOptions |= QBSP_NOCLIP;
      else if (!strcmp(argv[i], "-onlyents"))
	mapMem.mapOptions |= QBSP_ONLYENTS;
      else if (!strcmp(argv[i], "-usehulls"))
	mapMem.mapOptions |= QBSP_USEHULLS;
      else if (!strcmp(argv[i], "-hullnum")) {
	hullnum = atoi(argv[i + 1]);
	i++;
      }
      else if (!strcmp(argv[i], "-subdivide")) {
	subdivide_size = atoi(argv[i + 1]);
	i++;
      }
      else
	Error("qbsp: Unknown option '%s'", argv[i]);
    }

    if (i != argc - 2 && i != argc - 1)
      Error("usage: qbsp [options] sourcefile [destfile]\noptions: -nojunc -nofill -draw -onlyents -verbose");

    /* create destination name if not specified */
    __strncpy(mapName, argv[i], NAMELEN_PATH - 1);
    ReplaceExt(mapName, "map");

    if ((mapBuf = (char *)GetVoid(mapName))) {
      BeginBSPFile(&bspMem, &mapMem);

      if (LoadMapFile(&bspMem, &mapMem, mapBuf) == TRUE)
	if (qbsp(&bspMem, &mapMem, hullnum, subdivide, bspName))
	  if ((bspFile = __open(bspName, H_WRITE_BINARY)))
	    FinishBSPFile(&bspMem, &mapMem, bspFile);
	  else
	    eprintf(failed_fileopen, bspName);
	else
	  eprintf("failed to calculate bsp-tree\n");
      else
	eprintf("failed to parse map\n");

      FreeBSPClusters(&bspMem, 0);
      FreeMapClusters(&mapMem, 0);

      tfree(mapBuf);
    }
    else
      eprintf(failed_fileload, mapName);
  }

  return 0;
}
