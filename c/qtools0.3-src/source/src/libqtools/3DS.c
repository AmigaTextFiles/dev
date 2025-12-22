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

/* trilib.c: library for loading triangles from an Alias triangle file */

staticfnc void ByteSwapTri(struct tftriangle *tri)
{
  int i;

  for (i = 0; i < sizeof(struct tftriangle) / 4; i++)
    ((int *)tri)[i] = BigLong(((int *)tri)[i]);
}

bool LoadTriangles(mdlBase mdlMem, char *fileName)
{
  HANDLE input;
  vec1D start;
  char name[NAMELEN_PATH], tex[256];
  int i, count, magic;
  struct tftriangle tri;
  struct triangle *ptri;
  int iLevel;
  int exitpattern;
  vec1D t;
  bool success;

  t = -FLOAT_START;
  *((unsigned char *)&exitpattern + 0) = *((unsigned char *)&t + 3);
  *((unsigned char *)&exitpattern + 1) = *((unsigned char *)&t + 2);
  *((unsigned char *)&exitpattern + 2) = *((unsigned char *)&t + 1);
  *((unsigned char *)&exitpattern + 3) = *((unsigned char *)&t + 0);

  if ((input = __open(fileName, H_READ_BINARY))) {
    iLevel = 0;

    __read(input, &magic, sizeof(int));

    if (magic == BigLong(MAGIC_TRI)) {
      AllocMDLClusters(mdlMem, TRIANGLES);
      ptri = mdlMem->tris;

      while (__read(input, &start, sizeof(vec1D))) {
	*(int *)&start = BigLong(*(int *)&start);

	if (*(int *)&start != exitpattern) {
	  if (start == FLOAT_START) {
	    /* Start of an object or group of objects. */
	    i = -1;
	    do {
	      /*
	       * There are probably better ways to read a string from 
	       * a file, but this does allow you to do error checking 
	       * (which I'm not doing) on a per character basis.      
	       */
	      ++i;
	      __read(input, &(name[i]), sizeof(char));
	    } while (name[i] != '\0');

	    __read(input, &count, sizeof(int));

	    count = BigLong(count);
	    ++iLevel;
	    if (count != 0) {
	      i = -1;
	      do {
		++i;
		__read(input, &(tex[i]), sizeof(char));
	      } while (tex[i] != '\0');
	    }
	    /*
	     * Else (count == 0) this is the start of a group, and 
	     * no texture name is present. 
	     */
	  }
	  else if (start == FLOAT_END) {
	    /*
	     * End of an object or group. Yes, the name should be 
	     * obvious from context, but it is in here just to be 
	     * safe and to provide a little extra information for 
	     * those who do not wish to write a recursive reader. 
	     * Mia culpa. 
	     */
	    --iLevel;
	    i = -1;
	    do {
	      ++i;
	      __read(input, &(name[i]), sizeof(char));
	    } while (name[i] != '\0');
	    continue;
	  }
	}

	/*
	 * read the triangles
	 */
	for (i = 0; i < count; ++i) {
	  int j;

	  __read(input, &tri, sizeof(struct tftriangle));

	  ByteSwapTri(&tri);
	  for (j = 0; j < 3; j++) {
	    int k;

	    ptri->verts[j][0] = tri.pt[j].p[0];
	    ptri->verts[j][1] = tri.pt[j].p[1];
	    ptri->verts[j][2] = tri.pt[j].p[2];
	  }

	  if (mdlMem->numtriangles <= mdlMem->max_numtriangles)
	    ExpandMDLClusters(mdlMem, TRIANGLES);
	  mdlMem->numtriangles++;
	  ptri = mdlMem->tris + mdlMem->numtriangles;
	}
      }

      __close(input);
      success = TRUE;
    }
    else
      eprintf("file %s is not a Alias object separated triangle file, magic number is wrong.\n", fileName);
  }
  else
    eprintf(failed_fileopen, fileName);

  return success;
}
