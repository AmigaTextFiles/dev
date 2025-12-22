;/* Execute me to compile me with SAS/C 6.58
sc link Tutorial_1.c nochkabort nostkchk strt=c from lib:database.lib to AlbumDB
quit
 * Tutorial_1.c
 *
 * This is a simple tutorial, used to introduce into the usage of the
 * database.library. It should be easy to understand, so only the minimum
 * errorhandling is done.
 *
 * It implements a very small database (a single table without any index) that
 * is usable to register a music-collection, i.e. the personal CDs, MCs and LPs
 */

#include <joinOS/exec/defines.h>
#include <joinOS/exec/memory.h>
#include <joinOS/database/DataServer.h>
#include <joinOS/database/DataTable.h>

#include <joinOS/protos/ExecProtos.h>
#include <joinOS/Protos/AmigaDOSProtos.h>
#include <joinOS/protos/DatabaseProtos.h>

#include <stdio.h>
#include <string.h>

struct Library *JoinOSBase = NULL;
struct Library *DatabaseBase = NULL;

struct DBStruct dbs[] =
{
	{"ID",     NULL, NULL, DC_LONG, 0, 0, 0},
	{"ALBUM",  NULL, NULL, DC_CHAR, 0,40, 0},
	{"MEDIUM", NULL, NULL, DC_CHAR, 0, 2, 0},
	{"COMMENT",NULL, NULL, DC_TEXT, 0, 0, 0},
	{0}
};

struct TagItem dbfTags[] =
{
	{DBF_Name, (ULONG)"TestDB"},
	{DBF_FileName, (ULONG)"RAM:Test.dbf"},
	{DBF_Struct, (ULONG)dbs},
	{TAG_DONE, 0}
};

/* Open the required libraries
 */
BOOL OpenLibs(void)
{
	BOOL opened = FALSE;

	if (JoinOSBase = OpenLibrary ("joinOS.library",0L))
		if (DatabaseBase = OpenLibrary ("database.library",0L))
			opened = TRUE;
		else printf ("Unable to open database.library.\n");
	else printf ("Unable to open joinOS.library.\n");

	return opened;
}

/* close the opened libraries
 */
void CloseLibs(void)
{
	if (JoinOSBase) CloseLibrary (JoinOSBase);
	if (DatabaseBase) CloseLibrary (DatabaseBase);
}

/* create the database
 */
struct DataServer *CreateTestServer (void)
{
	struct DataServer *server;

	if (server = DBF_InitA (NULL, dbfTags))
	{
		printf ("The DataTable is successfully created.\n");
	}
	return server;
}

/* wait for user-respond
 */
void WaitForReturn (void)
{
	printf ("Press ENTER to continue...");
	fflush (stdout);
	(void)getchar(); 
}

/* print a single record
 */
BOOL PrintRecord (struct DataServer *server)
{
	STRPTR data;
	BOOL success;

	if (success = DBF_FieldGet (server, "ID", (APTR)&data))
	{
		printf ("Id      = %s\n", data);
		if (success = DBF_FieldGet (server, "Album", (APTR)&data))
		{
			printf ("Album   = %s\n", data);
			if (success = DBF_FieldGet (server, "Medium", (APTR)&data))
			{
				printf ("Medium  = %s\n", data);
				if (success = DBF_FieldGet (server, "Comment", (APTR)&data))
				{
					printf ("Comment = %s\n", data);
				}
			}
		}
	}
	return success;
}

/* make a dump of the whole database to stdio
 */
BOOL DumpServer (struct DataServer *server)
{
	BOOL success;

	success = DS_DoUpdate (server, DS_FIRSTROW, NULL);

	while (success)
	{
		if (success = PrintRecord (server))
		{
			WaitForReturn ();
			success = DS_DoUpdate (server, DS_NEXTROW, NULL);
		}
	}
	if (server->LastError == DS_ERR_NO_MORE_DATA) success = TRUE;

	return success;
}

/* add a single record to the database
 */
BOOL InsertRecord (struct DataServer *server,
                   ULONG Id,
                   STRPTR album,
                   STRPTR medium,
                   STRPTR comment)
{
	BOOL success;

	if (success = DS_DoUpdate (server, DS_INSERTROW, NULL))
	{
		if (success = DBF_FieldPutRaw (server, "ID", (APTR)&Id))
		{
			if (success = DBF_FieldPut (server, "Album", (APTR)album))
			{
				if (success = DBF_FieldPut (server, "Medium", (APTR)medium))
				{
					if (success = DBF_FieldPut (server, "Comment", (APTR)comment))
						success = DS_DoUpdate (server, DS_UPDATE, NULL);
				}
			}
		}
	}
	return success;
}

/* read the contents of a column from user-input
 */
UBYTE *ReadColumn (STRPTR columnName, UBYTE *buffer)
{
	UBYTE *data = NULL;

	printf ("Please enter a new value for the column \"%s\":\n", columnName);

	if (gets (buffer)) data = buffer;
	else printf ("I/O-error during input.\n");

	return data;
}

/* add a new record to the datatable
 */
BOOL AddRecord (struct DataServer *server, UBYTE *buffer)
{
	BOOL success = FALSE;
	LONG Id;
	STRPTR album;
	STRPTR medium;
	STRPTR comment;
	UBYTE *p;

	printf ("Adding a new record:\n");

	if (p = ReadColumn ("Id", buffer))
	{
		Id = 0;
		StrToLong (p, &Id);

		if (album = ReadColumn ("Album", buffer))
		{
			p += strlen (album) + 1;

			if (medium = ReadColumn ("Medium", p))
			{
				p += strlen (medium) + 1;
				if (comment = ReadColumn ("Comment", p))
				{
					if (!(success =
							InsertRecord (server, Id, album, medium, comment)))
					{
						printf ("Failed to add record to datatable.\n");
					}
				}
			}
		}
	}
	return success;
}

/* main loop
 */
void do_Operations (struct DataServer *server, UBYTE *buffer)
{
	BOOL quit = FALSE;

	printf ( "\nPlease enter a command; enter \"help\" to get a list of the\n"
				"available commands.\n");

	while (!quit)
	{
		printf ("> ");
		fflush (stdout);
		if (gets(buffer))
		{
			if (strnicmp (buffer, "HELP", strlen(buffer)) == 0)
			{
				printf ("Available commands:\n"
							"help - see this text;\n"
							"quit - terminate this application;\n"
							"new - add a new record to the datatable;\n"
							"list - list the contents of the datatable;\n");
			}
			else if (strnicmp (buffer, "QUIT", strlen (buffer)) == 0)
				quit = TRUE;
			else if (strnicmp (buffer, "NEW", strlen (buffer)) == 0)
			{
				AddRecord (server, buffer);
			}
			else if (strnicmp (buffer, "LIST", strlen (buffer)) == 0)
			{
				DumpServer (server);
			}
			else
			{
				printf ("Unknown command \"%s\".\n"
						"Enter \"help\" to get a list if the available commands.\n");
			}
		}
		else
		{
			printf ("I/O-error during input.\n");
			quit = TRUE;
		}
	}
}

/* application entry point, do the necessary initializations
 */
void main (void)
{
	if (OpenLibs())
	{
		struct DataServer *server;

		printf ("AlbumDB, © 2004, Peter Riede\n");
		printf ("A small demo of a database created using the database.library.\n");

		if (server = CreateTestServer ())
		{
			UBYTE *buffer;

			if (buffer = (UBYTE *)AllocMem (1024, MEMF_PUBLIC))
			{
				do_Operations (server, buffer);
				FreeMem (buffer, 1024);
			}
			else printf ("Failed to allocate I/O-buffer.\n");

			DS_DoUpdate (server, DS_DISPOSE, NULL);

			printf ("The database file \"Test.dbf\" is found in \"RAM:\".\n"
					  "You should delete it, if you doesn't need it any more.\n");
		}
	}
	CloseLibs();
}
