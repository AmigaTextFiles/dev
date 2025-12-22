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
 * ========
 * main
 * 
 * light modelfile
 * ========
 */
int main(int argc, char **argv)
{
  int i, litOptions = 0;
  char bspName[NAMELEN_PATH];
  HANDLE bspFile;
  vec1D scaledist = 0, rangescale = 0;
  bspBase bspMem;

#if defined(DEBUG_C) && defined(HAVE_LIBDBMALLOC)
  union dbmalloptarg m;

  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_WARN, &m);
  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_FATAL, &m);
#endif

  if (!setjmp(eabort)) {
    printf("----- LightFaces --------\n");

    for (i = 1; i < argc; i++) {
      if (!strcmp(argv[i], "-extra")) {
	litOptions |= LIGHT_EXTRA;
	mprintf("extra sampling enabled\n");
      }
      else if (!strcmp(argv[i], "-rad")) {
	litOptions |= LIGHT_RADIOSITY;
	mprintf("radiosity calculation enabled\n");
      }
      else if (!strcmp(argv[i], "-waterlit")) {
	litOptions |= LIGHT_WATERLIT;
	mprintf("extra watershadowing enabled\n");
      }
      else if (!strcmp(argv[i], "-dist")) {
	scaledist = atof(argv[i + 1]);
	i++;
      }
      else if (!strcmp(argv[i], "-range")) {
	rangescale = atof(argv[i + 1]);
	i++;
      }
      else if (argv[i][0] == '-')
	Error("Unknown option \"%s\"", argv[i]);
      else
	break;
    }

    if (i != argc - 1)
      Error("usage: light [-extra] bspfile");

    __strncpy(bspName, argv[i], NAMELEN_PATH - 1);
    ReplaceExt(bspName, "bsp");
    if ((bspFile = __open(bspName, H_READWRITE_BINARY_OLD))) {
      if ((bspMem = LoadBSP(bspFile, ALL_QUAKE1_LUMPS & (~(LUMP_LIGHTING | LUMP_VISIBILITY)), BSP_VERSION_Q1))) {
        bspMem->litOptions = litOptions;
	if (light(bspMem, 0, scaledist, rangescale) == FALSE)
	  eprintf("failed to calculate light-lump\n");
	else
	  WriteBSP(bspMem, bspFile, BSP_VERSION_Q1);

	PrintBSPClusters(bspMem, LUMP_LIGHTING, TRUE);
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
