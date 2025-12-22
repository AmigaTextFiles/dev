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

//#define	LIBQTOOLS_CORE
//#define	LIBQBUILD_CORE
#include <libqtools.h>
#include <libqbuild.h>

int main(int argc, char **argv)
{
  char *fileName;
  int width, height, depth;
  struct bspmemory bspMem;

#if defined(DEBUG_C) && defined(HAVE_LIBDBMALLOC)
  union dbmalloptarg m;

  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_WARN, &m);
  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_FATAL, &m);
#endif

  if (argc == 1)
    return 10;
  else {
    fileName = argv[1];

    if (argc <= 3) {
      width = 320;
      height = 200;
    }
    else {
      width = atoi(argv[2]);
      height = atoi(argv[3]);
    }

    if (argc > 4)
      depth = atoi(argv[4]);
    else
      depth = DRIVER_DEFAULT;
  }

  if (!(
#ifdef	DRIVER_8BIT
	 (depth == 8) ||
#endif
#ifdef	DRIVER_16BIT
	 (depth == 16) ||
#endif
#ifdef	DRIVER_24BIT
	 (depth == 24) ||
#endif
#ifdef	DRIVER_32BIT
	 (depth == 32) ||
#endif
	 0)) {
    eprintf("unsupported depth choosen\n");
    return 10;
  }

  display = DISPLAY_WIRE;

  if (!setjmp(eabort)) {
    HANDLE bspFile;

    if ((bspFile = __open(fileName, H_READWRITE_BINARY_OLD)) > 0) {
      if ((bspMem = LoadBSP(bspFile, ALL_QUAKE1_LUMPS | ALL_MAPS, BSP_VERSION_Q1))) {
	PrintClusters(bspMem, 0, FALSE);
	DisplayBSP(bspMem, width, height, depth, display);
	FreeClusters(bspMem, 0);
      }
      __close(bspFile);
    }
  }

  return 0;
}
