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
 * ===========
 * main
 * ===========
 */
int main(int argc, char **argv)
{
  char portalfile[NAMELEN_PATH], bspName[NAMELEN_PATH];
  int i, level = 2, testvislevel, visOptions = 0;;
  HANDLE bspFile;
  bspBase bspMem;

#if defined(DEBUG_C) && defined(HAVE_LIBDBMALLOC)
  union dbmalloptarg m;

  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_WARN, &m);
  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_FATAL, &m);
#endif

  if (!setjmp(eabort)) {
    mprintf("----- Vis ---------------\n");

    for (i = 1; i < argc; i++) {
      if (!strcmp(argv[i], "-f") || !strcmp(argv[i], "--fast")) {
	mprintf("fastvis = true\n");
	visOptions |= VIS_FAST;
      }
      else if (!strcmp(argv[i], "-l") || !strcmp(argv[i], "--level")) {
	testvislevel = atoi(argv[i + 1]);
	mprintf("testvislevel = %i\n", testvislevel);
	i++;
      }
      else if (!strcmp(argv[i], "-v") || !strcmp(argv[i], "--verbose")) {
	mprintf("verbose = true\n");
	visOptions |= VIS_VERBOSE;
      }
      else if (argv[i][0] == '-')
	Error("Unknown option \"%s\"", argv[i]);
      else
	break;
    }

    if (i != argc - 1)
      Error("usage: vis [-l|--level 0-4] [-f|--fast] [-v|--verbose] bspfile");

    __strncpy(bspName, argv[i], NAMELEN_PATH - 1);
    ReplaceExt(bspName, "bsp");
    if ((bspFile = __open(bspName, H_READWRITE_BINARY_OLD))) {
      if ((bspMem = LoadBSP(bspFile, ALL_QUAKE1_LUMPS & (~LUMP_VISIBILITY), BSP_VERSION_Q1))) {
	char *prtBuf;

	__strncpy(portalfile, argv[i], NAMELEN_PATH - 1);
	ReplaceExt(portalfile, "prt");

	if ((prtBuf = (char *)GetVoid(portalfile))) {
          bspMem->visOptions = visOptions;

	  if (vis(bspMem, level, prtBuf))
	    WriteBSP(bspMem, bspFile, BSP_VERSION_Q1);
	  else
	    eprintf("failed to calculate vis-lump\n");

	  tfree(prtBuf);
	}
	else
	  eprintf(failed_fileload, portalfile);

	PrintBSPClusters(bspMem, LUMP_VISIBILITY, TRUE);
	FreeBSPClusters(bspMem, 0);
	tfree(bspMem);
      }
      else
	eprintf(failed_fileload, bspName);

      __close(bspFile);
    }
    else
      eprintf(failed_fileopen, bspName);
  }

  return 0;
}
