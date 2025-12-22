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

#ifndef	MISC_H
#define	MISC_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */
typedef union {
  char chars[4];
  int integer;
} magick;

#define NAMELEN_PATH 256
#define NAMELEN_MAXQUAKE 0x38

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern char *preProcessor;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

void CreatePath(register char *fileName);
char *GetExt(register char *Name);
void StripExt(register char *Name);
void ReplaceExt(register char *Name, register char *newExt);
char *GetFile(register char *Name);
void ValidateDir(register char *Name);
void *GetVoidF(register HANDLE getFile);
void *GetVoid(register char *fileName);
void *GetPreProcessed(register char *fileName);
void *SmartBuffer(int len, int *clusters, int *clustersize, int *rest);
bool CutOff(HANDLE procFile, int byteValue, void *buffer);
bool PasteIn(HANDLE procFile, int byteValue, void *buffer);

#endif
