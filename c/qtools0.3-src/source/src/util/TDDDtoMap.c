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

#include "qtools.h"

int main(int argc, char **argv)
{
  FILE *mapFile;
  int i = 1;
  char *tdddBuf = (char *)GetVoid(argv[i]);

  __memBase = 0;

  if (argc > (i + 1))
    mapFile = fopen(argv[i + 1], "w");
  else
    mapFile = fopen("ram:test.map", "w");

  LoadTDDDFile(bspmem, tdddBuf);
  SaveMapFile(bspMem, mapFile);
  fclose(mapFile);
  return 0;
}
