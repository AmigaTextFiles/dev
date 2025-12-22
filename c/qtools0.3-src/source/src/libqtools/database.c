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
#include <libqtools.h>
#include "../liblists/liblists.h"
#include "database.h"

/*
 * in general the database-system allows completely transparent access to
 * files and/or names out of every possible filetype
 */

struct db globalDB;

/*
 * ============================================================================
 * GetNameEntry
 *
 * returns the original name of the entry or the old alias if not found
 * the database will be updated automatically if the entry does not exists
 * the path will verified
 * ============================================================================
 */
char *GetNameEntryDB(struct db *database, char *aliasname)
{
}

/*
 * ============================================================================
 * GetPathEntry
 *
 * returns the valid path of the entry or 0
 * the database will be updated automatically if the entry does not exists
 * the path will verified and the original name will set to the aliasname
 * ============================================================================
 */
char *GetPathEntryDB(struct db *database, char *aliasname)
{
}

char *VerifyPathDB(struct db *database, char *name)
{
}

/*
 * ============================================================================
 * LoadDatabase
 * 
 * loads the disk-representation of the complete database
 * joins lists with the same datatype
 * fileName of NULL creates new empty list
 * TODO: remove doubled entries
 * ============================================================================
 */
bool LoadDatabaseDB(struct db *database, char *fileName)
{
  nNewList(&db->aliasList);

  return AppendDatabaseDB(database, fileName);
}

bool AppendDatabaseDB(struct db *database, char *fileName)
{
  FILE *dbFile;

  if ((dbFile = __fopen(fileName, F_READ_BINARY))) {
    int dbEnd;

    __fseek(dbFile, 0, SEEK_END);
    dbEnd = __ftell(dbFile);
    __fseek(dbFile, 0, SEEK_BEGINNING);

    while (dbEnd > __ftell(dbFile)) {
      struct alist *actList, lastList;
      int dbLength, i;
      bool new = TRUE;

      if (!(actList = (struct alist *)tmalloc(sizeof(struct alist)))) {
	eprintf("failed to allocate database\n");
	return FALSE;
      }
      nNewList(&actList->listHeader);
      
      /* set filetype */
      __fread(&actList->fileType, 1, sizeof(filetype), dbFile);
      /* read length of filetype */
      __fread(&dbLength, 1, sizeof(int), dbFile);

      /* look if there exists the same datatype before this */
      lastList = (struct alist *)nGetHead(&database->aliasList));
      for (i = database->aliasList.nodes; i > 0; i--) {
	if (actList->fileType == lastList->fileType) {
	  new = FALSE;
	  tfree(actList);
	  actList = lastList;
	  break;
	}
      }

      while (dbLength > __ftell(dbFile)) {
	struct anode *actNode;

	if (!(actNode = (struct anode *)tmalloc(sizeof(struct anode)))) {
	  eprintf("failed to allocate database\n");
	  return FALSE;
	}
	/* strings cant be greater than 1k */
	if (!(actNode->aliasname = (char *)tmalloc(1024))) {
	  eprintf("failed to allocate database\n");
	  return FALSE;
	}
	if (!(actNode->name = (char *)tmalloc(1024))) {
	  eprintf("failed to allocate database\n");
	  return FALSE;
	}
	if (!(actNode->filename = (char *)tmalloc(1024))) {
	  eprintf("failed to allocate database\n");
	  return FALSE;
	}
	/* scan the string out */
	__fscanf("%s\n%s\n%s\n\0", actNode->aliasname, actNode->name, actNode->filename);
	/* shorten the strings to the real size */
	actNode->aliasname = (char *)trealloc(actNode->aliasname, strlen(actNode->aliasname) + 1);
	actNode->name = (char *)trealloc(actNode->name, strlen(actNode->name) + 1);
	actNode->filename = (char *)trealloc(actNode->filename, strlen(actNode->filename) + 1);
	actNode->data = *((int *)actNode->name);		/* sort by name */

	/* register to the list */
	nEnqueue(&actList->listHeader, &actNode->Node);		/* register sorted */
      }
      __fseek(dbFile, dbLength, SEEK_BEGINNING);
      actList->listNode.data = actList->fileType;		/* sort by fileType */

      /* register to the list only if this is a new list */
      if (new)
	nEnqueue(&database->aliasList, &actList->listNode);	/* register sorted */
    }

    __fclose(dbFile);
  }

  return TRUE;
}

/*
 * ============================================================================
 * SaveDatabase
 *
 * saves the complete database to the disk-representation
 * ============================================================================
 */
bool SaveDatabaseDB(struct db * database, char *fileName) {
  FILE *dbFile;

  if ((dbFile = __fopen(fileName, F_WRITE_BINARY))) {
    struct alist *actList = (struct alist *)nGetHead(&database->aliasList);

    /* loop through all fileType-lists */
    while ((actList = (struct alist *)nGetNext(&actList->listNode))) {
      struct anode *actNode = (struct anode *)&actList->listHeader;
      int dbLength = 0, dbPos;

      /* put fileType first */
      __fwrite(&actList->listType, 1, sizeof(filetype), dbFile);
      dbPos = __ftell(dbFile);
      /* then some space for the seek-able offset */
      __fwrite(&dbLength, 1, sizeof(int), dbFile);

      /* loop through all node of a fileType-list */
      while ((actNode = (struct anode *)nGetNext(&actNode->Node)))
	__fprintf("%s\n%s\n%s\n\0", actNode->aliasname, actNode->name, actNode->filename);
      /* this is the offset for the next filetype */
      dbLength = __ftell(dbFile);
      /* seek to the offset-specifier */
      __fseek(dbFile, dbPos, SEEK_BEGINNING);
      /* save it */
      __fwrite(&dbLength, 1, sizeof(int), dbFile);

      /* and return to old position */
      __fseek(dbFile, dbLength, SEEK_BEGINNING);
    }

    __fclose(dbFile);
  }
  else {
    eprintf("failed to save database %s\n", fileName);
    return FALSE;
  }

  return TRUE;
}
