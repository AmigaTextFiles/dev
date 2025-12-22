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

#ifndef	RAW_H
#define	RAW_H
/*
 * ============================================================================
 * structures
 * ============================================================================
 */

struct rawdata {
  char *name;
  int size;
  unsigned char rawdata[0];
} __packed;

/*
 * ============================================================================
 * globals
 * ============================================================================
 */
extern char Compression;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

struct rawdata *rmalloc(register int size, char *rawName);
void rfree(register struct rawdata *rawData);

char *GetLZ77(register HANDLE file, register int readsize);
char *ParseLZ77(register char *inData, register int readsize);
int PutLZ77(register HANDLE file, register char *inData, register int size);
int PasteLZ77(register char *outData, register char *inData, register int size);

struct rawdata *GetRaw(register HANDLE file, register char *rawName, register int size);
struct rawdata *ParseRaw(register char *mem, register char *rawName, register int size);
bool PutRaw(register HANDLE file, register struct rawdata *rawData);
bool PasteRaw(register char *mem, register struct rawdata *rawData);
void FreeRaw(register struct rawdata *rawData);

#endif
