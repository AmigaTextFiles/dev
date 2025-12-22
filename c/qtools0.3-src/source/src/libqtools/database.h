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

#ifndef	WAD_H
#define	WAD_H

#define	MAX_MULTIPLE	32

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

struct alist {
  /* link hook for the lists */
  struct nnode listNode;
  /* standard list-header */
  struct nlist listHeader;
  /* filetype of this list
   * there exists a listheader for every filetype
   * linked together by a rootlistheader */
  filetype listType;
};

struct anode {
  /* standard list-node */
  struct nnode Node;
  /* pointer to the name, aliasname, filename */
  char *aliasname;						/* "WeirdSound" */
  char *name;							/* "sound/ambient/weirdwav" */
  char *filename;						/* "Quake:id1/pak0.pak$sound/ambient/weirdwav" */
};

struct db {
  /*
   * the names could point to real filenames
   * depend on the filetype we search through all
   * path set in the environment
   * the format of the location is <path>/<file>
   */
  char *dirPath[MAX_MULTIPLE + 1];
  DIR *dirDir[MAX_MULTIPLE + 1];
  int dirAvail = 0;

  /*
   * the names could point to pak-files
   * depend on the filetype we search through all
   * pak-files set in the environment
   * the format of the location is <path>/<file>$<pakpath>/<pakfile>
   */
  struct pakheader pakHeader[MAX_MULTIPLE + 1];
  struct pakentry *pakEntries[MAX_MULTIPLE + 1];
  char *pakPath[MAX_MULTIPLE + 1];
  HANDLE pakFile[MAX_MULTIPLE + 1];
  int pakAvail = 0;

  /*
   * the names could point to wad-files
   * depend on the filetype we search through all
   * wad-files set in the environment
   * the format of the location is <path>/<file>$<wadpath>/<wadfile>
   */
  struct wadheader wadHeader[MAX_MULTIPLE + 1];
  struct wadentry *wadEntries[MAX_MULTIPLE + 1];
  char *wadPath[MAX_MULTIPLE + 1];
  HANDLE wadFile[MAX_MULTIPLE + 1];
  int wadAvail = 0;

  /*
   * add bsp-files too?
   */

  /*
   * root-list-header that points to the list-header
   * for every filetype that points to the nodes
   */
  struct nlist aliasList;
};

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern struct db globalDB;

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

char *GetNameEntryDB(struct db *database, char *aliasname);
#define	GetNameEntry(aliasname)		GetNameEntryDB(&globalDB, aliasname)
char *GetPathEntryDB(struct db *database, char *aliasname);
#define	GetPathEntry(aliasname)		GetPathEntryDB(&globalDB, aliasname)
bool LoadDatabaseDB(struct db *database, char *fileName);
#define	LoadDatabase(fileName)		LoadDatabaseDB(&globalDB, fileName)
bool AppendDatabaseDB(struct db *database, char *fileName);
#define	AppendDatabase(fileName)	AppendDatabaseDB(&globalDB, fileName)
bool SaveDatabaseDB(struct db *database, char *fileName);
#define	SaveDatabase(fileName)		SaveDatabaseDB(&globalDB, fileName)

#endif
