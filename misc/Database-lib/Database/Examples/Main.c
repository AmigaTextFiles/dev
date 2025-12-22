/* Main.c
 *
 * This is a generic application entry used to create a datatable and the
 * according indexes and than calling TableEdit for manipulating these files.
 *
 * You have to define the following global constants in your application:
 *
 * The array 'dbStruct' of DBStruct structures defining the structure of the
 * datatable; this array needs to be terminated by an empty structure, e.g.:
 *		struct DBStruct dbStruct[] =
 *		{
 *			{"TRACK","Track","Number of the track on the CD.",DC_WORD,0,0,0},
 *			{"INTERPRET","Interpret","Interpret of the track.",DC_CHAR,0,40,0},
 *			{"TITLE","Title","Title of the song.",DC_CHAR,0,32,0},
 *			{"LENGTH","Length","Length of the song.",DC_TIME,0,0,0},
 *			{"ALBUM","Album","Title of the album.",DC_CHAR,0,40,0},
 *			{"COMMENT","Comment","My personal comments.",DC_TEXT,0,0,0},
 *			{0}
 *		};
 *
 * You may specify your custom TagItem list 'UserTags' with additional TagItems
 * that should be passed to DBF_InitA(). This TagItem list should not contain
 *	TagItems with the Tags DBF_Name, DBF_FileName, or DBF_Struct. All other
 *	TagItems are allowed.
 *	If you do not want any additional TagItems you have to initialize 'UserTags'
 *	to NULL, e.g.:
 *		struct TagItem UserTags[] =
 *		{
 *			{DBF_ReadOnly, 0},
 *			{DBF_ForceUnique, 0},
 *			{TAG_DONE, 0}
 *		};
 * or:
 *		struct TagItem *UserTags = NULL;
 *
 * The string 'TableName' with the name of your datatable, e.g.:
 *		STRPTR TableName = "Music";
 *
 * The string 'TablePath' with the path to your datatable and index files,e.g.:
 *		STRPTR TablePath = "Ram:t";
 *
 * The string 'TableFile' with the filename of your datatable, e.g.:
 *		STRPTR TableFile = "Music.dbf";
 *
 * The unsigned long 'NumIndexes' with the number of indexfiles to be created:
 *		ULONG NumIndexes = 4;
 *
 * A second custom TagItem list 'IndexTags' with additonal TagItems that should
 * be passed to IDX_InitA(). This TagItem list should not contain TagItems with
 * the Tags IDX_Name, IDX_Expression, IDX_FileName, or IDX_Server. All other
 *	TagItems are allowed.
 *	If you do not want any additional TagItems you have to initialize
 *	'IndexTags' to NULL, e.g.:
 *		struct TagItem IndexTags[] =
 *		{
 *			{IDX_Descend, 0},
 *			{IDX_PageSize, 2048},
 *			{TAG_DONE, 0}
 *		};
 * or:
 *		struct TagItem *IndexTags = NULL;
 *
 *	Plus the following four arrays, each having 'NumIndexes' entries:
 *
 *	The array 'idx_IndexName' with the names of the indexes, e.g.:
 *		STRPTR idx_IndexName[] =
 *		{
 *			"Album",
 *			"Interpret",
 *			"Title",
 *			"Length"
 *		};
 *
 * The array 'idx_FileName' with the filenames of the indexes, e.g.:
 *		STRPTR idx_FileName[] =
 *		{
 *			"Album.idx",
 *			"Interpret.idx",
 *			"Title.idx",
 *			"Length.idx"
 *		};
 *
 * The array 'idx_KeyExpression' with the key-expressions of the indexes, e.g.:
 *		STRPTR idx_KeyExpression[] =
 *		{
 *			"UPPER(ALBUM)+STR(TRACK,3)",
 *			"UPPER(INTERPRET)",
 *			"UPPER(TITLE)",
 *			"LENGTH"
 *		};
 *
 * And last but not least the array 'idx_Unique' with the boolean values
 * indicating weather the indexes should have unique keys or not, e.g.:
 *		BOOL idx_Unique[] =
 *		{
 *			TRUE,
 *			FALSE,
 *			FALSE,
 *			FALSE
 *		};
 *
 * That's all, compile a file containing this information and link against
 *	this module and you have a running application, without writting any line
 * of code.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

#ifndef _DATABASE_DATASERVER_H_
#include <joinOS/database/DataServer.h>
#endif

#ifndef _DATABASE_DATATABLE_H_
#include <joinOS/database/DataTable.h>
#endif

#ifndef _DATABASE_INDEX_H_
#include <joinOS/database/Index.h>
#endif

#ifndef _TABLEEDIT_H_
#include "TableEdit/TableEdit.h"
#endif

#ifndef _EXEC_PROTOS_H_
#include <joinOS/protos/ExecProtos.h>
#endif

#ifndef _JOINOS_PROTOS_H_
#include <joinOS/protos/joinOSProtos.h>
#endif

#ifndef _AMIGA_DOS_PROTOS_H_
#include <joinOS/Protos/AmigaDOSProtos.h>
#endif

#ifndef _DATABASE_PROTOS_H_
#include <joinOS/protos/DatabaseProtos.h>
#endif

#include <stdio.h>
#include <string.h>

/***************************************************************************/
/*																									*/
/*										Global data												*/
/*																									*/
/***************************************************************************/

struct Library *JoinOSBase = NULL;		/* used for Tag-functions and Math64 */
struct Library *DatabaseBase = NULL;

/* The following 'globals' are application specific and needs to be defined
 * somewhere else...
 */

extern struct DBStruct dbStruct[];
extern struct TagItem UserTags[];
extern STRPTR TablePath;
extern STRPTR TableName;
extern STRPTR TableFile;

extern ULONG NumIndexes;

extern struct TagItem IndexTags[];
extern STRPTR idx_KeyExpression[];
extern STRPTR idx_IndexName[];
extern STRPTR idx_FileName[];
extern BOOL idx_Unique[];

/***************************************************************************/
/*																									*/
/*										Generic functions										*/
/*																									*/
/***************************************************************************/

/* Open and close the required libraries...
 */

BOOL OpenLibs(void)
{
	BOOL opened = FALSE;

	if (JoinOSBase = OpenLibrary ("joinOS.library",0L))
		if (DatabaseBase = OpenLibrary ("database.library",0L))
			opened = TRUE;
		else Printf ("Unable to open database.library\n");
	else Printf ("Unable to open JoinOS.library\n");

	return (opened);
}

void CloseLibs(void)
{
	if (JoinOSBase) CloseLibrary (JoinOSBase);
	if (DatabaseBase) CloseLibrary (DatabaseBase);
}

/***************************************************************************/
/*																									*/
/*							functions for creating the DataTable						*/
/*																									*/
/***************************************************************************/

/* Function to create an index and add it to the DataTable...
 */
BOOL CreateIndex (struct DataTable *dbTable, ULONG orderNo)
{
	BOOL success = FALSE;
	BOOL created = TRUE;
	BPTR fl;
	struct IDXHeader *ihd;

	struct TagItem idxTags[] =
	{
		{IDX_Name, NULL},
		{IDX_Expression, NULL},
		{IDX_FileName, NULL},
		{IDX_Server, NULL},
		{TAG_IGNORE, 0},		/* placeholder for IDX_Unique */
		{TAG_DONE, 0}
	};
	idxTags[0].ti_Data = (ULONG)idx_IndexName[orderNo];
	idxTags[1].ti_Data = (ULONG)idx_KeyExpression[orderNo];
	idxTags[2].ti_Data = (ULONG)idx_FileName[orderNo];
	idxTags[3].ti_Data = (ULONG)dbTable;
	if (idx_Unique[orderNo]) idxTags[4].ti_Tag = IDX_Unique;

	if (IndexTags)
	{
		idxTags[5].ti_Tag = TAG_MORE;
		idxTags[5].ti_Data = (ULONG)IndexTags;
	}

	/* Let's have a look, if the index is already existing...
	 */
	if (fl = Lock (idx_FileName[orderNo], SHARED_LOCK))
	{
		/* The index is already existing...
		 */
		created = FALSE;
		UnLock (fl);
	}

	if (ihd = IDX_InitA (NULL, idxTags))
	{
		success = TRUE;
		if (created)
		{
			/* Ok, index is new -> Try to reindex...
			 */
			if (!(success = IDX_ReIndex (ihd, (struct DataServer *)dbTable,
												&ReIndexNotify, idx_IndexName[orderNo])))
			{
				ULONG error;

				error = dbTable->DS.LastError;
				Printf ("Failed to reindex the index \"%s\"; ",
													idx_IndexName[orderNo]);

				DBF_RemoveOrder ((struct DataServer *)dbTable,
													idx_IndexName[orderNo]);
				dbTable->DS.LastError = error;
			}
		}
		if (success)
		{
			if (!(success = DBF_AddOrder ((struct DataServer *)dbTable, ihd)))
			{
				Printf ("Failed to add index to DataTable; ");
			}
		}
		if (!success)
		{
			PrintDBError ((struct DataServer *)dbTable);
			IDX_Dispose (ihd);
		}
	}
	else
	{
		Printf ("Failed to create the index with the expression \"%s\".\n",
																	idx_KeyExpression[orderNo]);
		PrintFault (IoErr(), "AmigaDos errorcode");
	}

	return success;
}

/* Create and attache all indexes of the DataTable...
 */
BOOL CreateOrders (struct DataTable *dbTable)
{
	BOOL success = TRUE;
	ULONG orderNo = 0;

	while (success && (orderNo < NumIndexes))
	{
		success = CreateIndex (dbTable, orderNo++);
	}
	return success;
}


/***************************************************************************/
/*																									*/
/*						functions for initialization/termination						*/
/*																									*/
/***************************************************************************/

/* Application entry-point...
 */
void main (void)
{
	if (OpenLibs())
	{
		BPTR dir;

		Printf ("Open the datatable in the directory \"%s\"...\n", TablePath);
		if (dir = Lock (TablePath, SHARED_LOCK))
		{
			APTR te;

			if (te = InitTableEdit (0))
			{
				BPTR cDir;

				SetIOErr (0L);
				cDir = CurrentDir (dir);
				if (!IoErr())
				{
					struct DataServer *server;
					struct TagItem srvTags[] =
					{
						{DBF_Name, 0},
						{DBF_FileName, 0},
						{DBF_Struct, 0},
						{TAG_DONE, 0}
					};

					srvTags[0].ti_Data = (ULONG)TableName;
					srvTags[1].ti_Data = (ULONG)TableFile;
					srvTags[2].ti_Data = (ULONG)dbStruct;
					if (UserTags)
					{
						srvTags[3].ti_Tag = TAG_MORE;
						srvTags[3].ti_Data = (ULONG)UserTags;
					}
					/* Ok, lets try to create the DataTable...
					 */
					Printf ("Open the datatable \"%s\" with the filename \"%s\"...\n",
																			TableName, TableFile);

					if (server = DBF_InitA (NULL, srvTags))
					{
						if (AddOpenTable (te, server))
						{
							/* Create the indexes...
							 */
							if (CreateOrders ((struct DataTable *)server))
							{
								/* Change current directory back...
								 */
								CurrentDir (cDir);

								if (DS_DoUpdate (server, DS_SETORDER,
														(APTR)idx_IndexName[0]))
								{
									PutStr ("\n");
									TableEdit (te);
								}
								else
								{
									Printf ("Failed to activate the main index: ");
									PrintDBError (server);
								}
							}
						}
						else DS_DoUpdate (server, DS_DISPOSE, NULL);
					}
					else if (IoErr()) PrintFault (IoErr(), "Failed to open datatable");
					else Printf ("Failed to open datatable.\n");
				}
				else PrintFault (IoErr(), "Failed to change directory");

				/* Change current directory back (regardless if I've already
				 * changed back, in that case this is a NOP)...
				 */
				CurrentDir (cDir);

				DisposeTableEdit (te);
			}
			else Printf ("Failed to create the TableEdit structure.\n");

			UnLock (dir);
		}
		else PrintFault (IoErr(), "Failed to get directory lock");
	}
	CloseLibs();
}