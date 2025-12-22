/* Speedtest.c
 *
 * This is a small application that performs some speed tests to the database
 * library.
 * First a datatable is set up with a few indexes.
 * Then 50000 records are inserted, the records data are random numbers, and
 * words taken from a plain ASCII text-file and some statistics about these
 * words (position and length).
 *
 * The following times are measured:
 *
 * - The time required to set up the datatable.
 *
 * - Then another index is added to the datatable, and the time required for
 *		reindexing.
 *
 * - Then the datatable is parsed sequentiell using every available index
 *		without reading any further data from it.
 *
 * - Then the datatable is parsed sequentiell using every available index and
 * 	reading every column of every record.
 *
 * - Then the datatable is parsed sequentiell using the main index, and the
 *		value of every random number stored in the datatable is increased by one.
 *		There is an index that indexes these numbers, the index is changed
 *		implicit.
 *
 * - A couple of seeks are performed to search records.
 *
 * - Every record in the datatable is removed again.
 *
 * Before the last test is performed (deleting all records), TableEdit() is
 * called to allow the user of this speed test to have a look at the contents
 * of the datatable.
 *
 * This needs to be linked against TableEdit.o.
 */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

#ifndef _TAGITEMS_H_
#include <joinOS/misc/TagItems.h>
#endif

#ifndef _TEXTBOX_H_
#include <joinOS/misc/TextBox.h>
#endif

#ifndef _MEMORY_H_
#include <joinOS/exec/memory.h>
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
#include "/TableEdit/TableEdit.h"
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

#ifndef PROTO_INTUITION_H
#include <proto/intuition.h>		/* CurrentTime() */
#endif

#ifndef CLIB_ALIB_PROTOS_H
#include <clib/alib_protos.h>		/* RangeRand() */
#endif

#include <stdio.h>
#include <string.h>
#include <ctype.h>

/***************************************************************************/
/*																									*/
/*										Global data												*/
/*																									*/
/***************************************************************************/

struct Library *JoinOSBase = NULL;		/* used for Tag-functions and Math64 */
struct IntuitionBase *IntuitionBase = NULL;
struct Library *DatabaseBase = NULL;

BOOL debug = FALSE;

/* The structure of the TestDB's DataTable...
 */
static struct DBStruct dbStruct[] =
{
	{"RANDOM","Random","Random numbers",DC_LONG,0,0,0},
	{"TEXT","Text","A word read from a file",DC_CHAR,0,30,0},
	{"CHARPOS","CharPos","Position of first character",DC_WORD,0,0,0},
	{"LINE","Line","Number of the line",DC_LONG,0,0,0},
	{"CAPITAL","Capital","First character is capital ?",DC_LOGIC,0,0,0},
	{0}
};

/* The TagItem list used to create the test DataTable...
 */
static struct TagItem srvTags[] =
{
	{DBF_Name, 0},
	{DBF_FileName, 0},
	{DBF_Struct, 0},
	{DBF_LockMode, DSF_LOCK_OPTIMISTIC},
	{TAG_IGNORE, 0},								/* placeholder for DBF_Exclusive */
	{TAG_DONE, 0}
};

/* Other initializers required for start-up...
 */
static STRPTR TableName = "SpeedTest";
static STRPTR TableFile = "SpeedTest.dbf";

/* Number of indexes created automatically during start-up...
 */
static const ULONG NumIndexes = 3;

/* The minimum information required for creating the indexes...
 */
static STRPTR idx_KeyExpression[] =
{
	"RANDOM",
	"UPPER(TEXT)",
	"VAL(STR(LINE,10)+STRZERO(CHARPOS,5))",
	"LTOC(CAPITAL)+TEXT"
};

static STRPTR idx_IndexName[] =
{
	"Random",
	"Text",
	"Position",
	"Capital"
};

static STRPTR idx_FileName[] =
{
	"Random.idx",
	"Text.idx",
	"Position.idx",
	"Capital.idx"
};

static BOOL idx_Unique[] =
{
	FALSE,
	FALSE,
	TRUE,
	FALSE
};

/* Number of records created for testing (default value may be overwritten)...
 */
static ULONG MaxTestRecords = 5000;

/* If this variable wents TRUE, only the absolute minimum output to the console
 * is produced by this test-suite...
 */
static BOOL quiet = FALSE;

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
	{
		if (DatabaseBase = OpenLibrary ("database.library",0L))
		{
			if (IntuitionBase = (struct IntuitionBase *)
										OpenLibrary ("intuition.library",33L))
			{
				opened = TRUE;
			}
			else TextBox (NULL, "SpeedTest",
					"Unable to open Intuition.library.", MSG_WARN, 0L);
		}
		else TextBox (NULL, "SpeedTest",
							"Unable to open database.library", MSG_WARN, 0L);
	}
	return opened;
}

void CloseLibs(void)
{
	if (JoinOSBase) CloseLibrary (JoinOSBase);
	if (DatabaseBase) CloseLibrary (DatabaseBase);
	if (IntuitionBase) CloseLibrary ((struct Library *)IntuitionBase);
}

/***************************************************************************/
/*																									*/
/*							functions for creating the DataTable						*/
/*																									*/
/***************************************************************************/

/* NAME
 *		CreateIndex - create an index and add it to the DataTable
 *
 * SYNOPSIS
 *		BOOL CreateIndex (struct DataTable *, ULONG, BOOL)
 *		success = CreateIndex (dbTable, orderNo, custom)
 *
 * FUNCTION
 *		This function creates a single index and attaches it to the DataTable.
 *
 * INPUTS
 *		dbTable - a pointer to the DataTable structure of the DataTable
 *		orderNo - the number of the index to be created
 *		custom - a boolean value, TRUE indicates that a custom index should
 *					be created, i.e. an index where the key-entries are not added
 *					or removed by the DataTable the index is attached to. The keys
 *					of such an index have to be manipulated by the user-application.
 * RESULT
 *		If the index could be successfully created and attached to the DataTable
 *		TRUE is returned, else FALSE is returned.
 */
BOOL CreateIndex (struct DataTable *dbTable, ULONG orderNo, BOOL custom)
{
	BOOL success = FALSE;
	struct IDXHeader *ihd;

	struct TagItem idxTags[] =
	{
		{IDX_Name, NULL},
		{IDX_Expression, NULL},
		{IDX_FileName, NULL},
		{IDX_Server, NULL},
		{TAG_IGNORE, 0},		/* placeholder for IDX_Unique */
		{TAG_IGNORE, 0},		/* placeholder for IDX_Custom */
		{TAG_IGNORE, 0},		/* placeholder for IDX_Exclusive */
//		{IDX_WriteBehind, 0},
		{TAG_DONE, 0}
	};
	idxTags[0].ti_Data = (ULONG)idx_IndexName[orderNo];
	idxTags[1].ti_Data = (ULONG)idx_KeyExpression[orderNo];
	idxTags[2].ti_Data = (ULONG)idx_FileName[orderNo];
	idxTags[3].ti_Data = (ULONG)dbTable;
	if (idx_Unique[orderNo]) idxTags[4].ti_Tag = IDX_Unique;
	if (custom) idxTags[5].ti_Tag = IDX_Custom;
	if (srvTags[4].ti_Tag == DBF_Exclusive) idxTags[6].ti_Tag = IDX_Exclusive;

	if (!quiet)
	{
		Printf ("Create the index \"%s\" named \"%s\""
					" and attache it to the datatable...\n",
					idx_FileName[orderNo], idx_IndexName[orderNo]);
	}
	if (ihd = IDX_InitA (NULL, idxTags))
	{
		if (!(success = DBF_AddOrder ((struct DataServer *)dbTable, ihd)))
		{
			Printf ("Failed to add index to datatable; ");
			PrintDBError ((struct DataServer *)dbTable);
			IDX_Dispose (ihd);
		}
	}
	else
	{
		Printf ("Failed to create the index with the expression \"%s\".\n",
																	idx_KeyExpression[orderNo]);
		PrintError (IoErr(), "AmigaDos errorcode");
	}

	return success;
}

/* NAME
 *		CreateOrders - Create and attache all indexes of the DataTable
 *
 * SYNOPSIS
 *		BOOL CreateOrders (struct DataTable *)
 *		success = CreateOrders (dbTable)
 *
 * FUNCTION
 *		This function creates all indexes of a DataTable and attaches them
 *		to the DataTable.
 *
 * INPUTS
 *		dbTable - a pointer to the DataTable structure of the DataTable
 *
 * RESULT
 *		If all indexes could be successfully created and attached to the
 *		DataTable TRUE is returned, else FALSE is returned.
 */
BOOL CreateOrders (struct DataTable *dbTable)
{
	BOOL success = TRUE;
	ULONG orderNo = 0;

	while (success && (orderNo < NumIndexes))
	{
		success = CreateIndex (dbTable, orderNo++, FALSE);
	}
	return success;
}

/***************************************************************************/
/*																									*/
/*									time-measuring functions								*/
/*																									*/
/***************************************************************************/

/* NAME
 *		CheckAbort - test is the user has pressed CTRL + 'C'
 *
 * SYNOPSIS
 *		BOOL CheckAbort (struct IDXHeader *, ULONG, APTR)
 *		success = CheckAbort (ihd, recCount, APTR)
 *
 * FUNCTION
 *		This function is a callback function used as notify-function called
 *		whenever 10 records are indexed by IDX_ReIndex().
 *		This function checks weather the user has pressed CTRL+'C' in the
 *		meantime.
 *
 * INPUTS
 *		ihd - a pointer to the IDXHeader structure of the index
 *		recCount - the number of records already processed
 *		ignored - this third argument is ignored by this function. It is the
 *				'userdata' pointer passed to IDX_ReIndex() resp. DBF_ReIndex()
 *				and should be NULL in this application.
 *
 * RESULT
 *		If the user has pressed CTRL+'C' FALSE is returned to indicate that
 *		the reindexing process should be stopped, else TRUE is returned.
 */
BOOL __saveds __asm CheckAbort ( register __a0 struct IDXHeader *ihd,
											register __d0 ULONG recCount,
											register __a1 APTR ignored)
{
	BOOL goon = TRUE;
	if (CheckSignal (SIGBREAKF_CTRL_C) != 0) goon = FALSE;

	return goon;
}

/* NAME
 *		ElapsedTime - eval the number of seconds and microseconds elapsed
 *
 * SYNOPSIS
 *		void ElapsedTime (ULONG *, ULONG *, ULONG, ULONG)
 *		ElapsedTime (startSec, startMic, endSec, endMic)
 *
 * FUNCTION
 *		THis function evaluates the length of a given timeinterval.
 *
 * INPUTS
 *		startSec - a pointer to the ULONG, where the seconds of the start of the
 *					measured interval is stored. The number of seconds of this
 *					interval is stored in there.
 *		startSec - a pointer to the ULONG, where the micro-seconds of the start
 *					of the measured interval is stored. The number of microseconds
 *					of this interval is stored in there.
 *		endSec - the number of seconds of the end of the interval
 *		endMic - the number of microseconds of the end of the interval
 */
void ElapsedTime (ULONG *startSec, ULONG *startMic, ULONG endSec, ULONG endMic)
{
	if ((endSec > *startSec) ||
		((endSec == *startSec) && (endMic >= *startMic)))
	{
		endSec -= *startSec;
		if (endMic >= *startMic)
		{
			endMic -= *startMic;
		}
		else
		{
			endMic += (1000000 - *startMic);
			endSec -= 1;
		}
		*startSec = endSec;
		*startMic = endMic;
	}
	else
	{
		/* End before start ?
		 */
		*startSec = 0;
		*startMic = 0;
	}
}

/* NAME
 *		MeasureTime - measure the time elapsed until now.
 *
 * SYNOPSIS
 *		void MeasureTime (ULONG *, ULONG *)
 *		MeasureTime (startSec, startMic)
 *
 * FUNCTION
 *		This function evaluates the elapsed time-interval since a given starttime
 *		and the current systemtime.
 *		The interval is printed to stdout.
 *
 * INPUTS
 *		startSec - a pointer to the ULONG, where the seconds of the start of the
 *					measured interval is stored. The number of seconds of this
 *					interval is stored in there.
 *		startSec - a pointer to the ULONG, where the micro-seconds of the start
 *					of the measured interval is stored. The number of microseconds
 *					of this interval is stored in there.
 */
void MeasureTime (ULONG *startSec, ULONG *startMic)
{
	ULONG endSec;
	ULONG endMic;

	CurrentTime (&endSec, &endMic);
	ElapsedTime (startSec, startMic, endSec, endMic);
	Printf ("Required time: %ld.%03ld seconds\n", *startSec, *startMic / 1000);
}

/***************************************************************************/
/*																									*/
/*									fill the DataTable										*/
/*																									*/
/***************************************************************************/

/* Prototypes of functions located in ReadWords.o
 */
BOOL CreateReadBuffer (void);
void DestroyReadBuffer (void);
STRPTR NextWord (BPTR fh, ULONG *lineNo, UWORD *pos);

/* NAME
 *		FindField - locate a DataColumn of a DataServer
 *
 * SYNOPSIS
 *		BOOL FindField (struct DataServer *, STRPTR)
 *		success = FindField (server, field)
 *
 * FUNCTION
 *		This function tries to locate the specified DataColumn of a DataServer
 *		and activates it, i.e. the following read or write will access that
 *		DataColumn.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the DataServer, the
 *					searched DataColumn is attached to.
 *		field - a pointer to the NUL-terminated string with the name of the field
 *					(DataColumn) that should be activated.
 *
 * RESULT
 *		If the DataColumn is found TRUE is returned, else FALSE is returned.
 */
BOOL FindField (struct DataServer *server, STRPTR field)
{
	BOOL success;
	if (!(success = DS_DoUpdate (server, DS_FINDCOLUMN, (APTR)field)))
	{
		Printf ("Failed to located column \"%s\": ");
		PrintDBError (server);
	}
	return success;
}

/* NAME
 *		FieldPutRaw - write "raw" data into a DataColumn
 *
 * SYNOPSIS
 *		BOOL FieldPutRaw (struct DataServer *, STRPTR, APTR)
 *		success = FieldPutRaw (server, field, rawData)
 *
 * FUNCTION
 *		This function is a shortcut for locating a DataColumn in the current
 *		record of the DataServer and write the specified data in "raw" format
 *		into that column.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the DataServer the data
 *					should be written into.
 *		field - a pointer to the NUL-terminated string with the name of the field
 *					(DataColumn) the data should be written into.
 *		rawData - a pointer to the data to be written in "raw" format (the data
 *					in the format it is stored into the DataServer-file).
 *
 * RESULT
 *		If the data could be written into the current column of the DataServer
 *		TRUE is returned, else FALSE is returned.
 */
BOOL FieldPutRaw (struct DataServer *server, STRPTR field, APTR rawData)
{
	BOOL success;
	if (success = FindField (server, field))
	{
		if (!(success = DS_DoUpdate (server, DS_SETRAWDATA, rawData)))
		{
			Printf ("Failed to store data into the current column: ");
			PrintDBError (server);
		}
	}
	return success;
}

/* NAME
 *		FieldPut - write data in human-readable format into a DataColumn
 *
 * SYNOPSIS
 *		BOOL FieldPut (struct DataServer *, STRPTR, STRPTR)
 *		success = FieldPut (server, field, data)
 *
 * FUNCTION
 *		This function is a shortcut for locating a DataColumn in the current
 *		record of the DataServer and write the specified data in human-readable
 *		format into that column.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the DataServer the data
 *					should be written into.
 *		field - a pointer to the NUL-terminated string with the name of the field
 *					(DataColumn) the data should be written into.
 *		data - a pointer to the NUL-terminated string containing the data to be
 *					written in human-readable format (the data is converted into the
 *					"raw" format it is stored into the DataServer-file by this
 *					function).
 *
 * RESULT
 *		If the data could be written into the current column of the DataServer
 *		TRUE is returned, else FALSE is returned.
 */
BOOL FieldPut (struct DataServer *server, STRPTR field, STRPTR data)
{
	BOOL success;
	if (success = FindField (server, field))
	{
		if (!(success = DS_DoUpdate (server, DS_SETCOLUMNDATA, (APTR)data)))
		{
			Printf ("Failed to store data into the current column: ");
			PrintDBError (server);
		}
	}
	return success;
}

/* NAME
 *		AddRecord - add a single record to the DataTable
 *
 * SYNOPSIS
 *		BOOL AddRecord (struct DataServer *, BPTR)
 *		success = AddRecord (server, textFile)
 *
 * FUNCTION
 *		This function creates a new record and writes it to the DataTable.
 *		A key-entry according to this record is created in every attached
 *		index.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the DataTable the
 *					record should be added to.
 *		textFile - a BPTR to the FileHandle of the ASCII-file that should be
 *					parsed for words that are inserted into the DataTable.
 *
 * RESULT
 *		If the record could be added without any error TRUE is returned, else
 *		FALSE is returned.
 */
BOOL AddRecord (struct DataServer *server, BPTR textFile)
{
	BOOL success = FALSE;
	STRPTR text;
	ULONG line;
	UWORD pos;

	if (text = NextWord (textFile, &line, &pos))
	{
		if (DS_DoUpdate (server, DS_INSERTROW, NULL))
		{
			ULONG rand;

			rand = RangeRand(65535);
			if (FieldPutRaw (server, "RANDOM", (APTR)&rand))
			{
				if (FieldPut (server, "TEXT", text))
				{
					if (FieldPutRaw (server, "CHARPOS", (APTR)&pos))
					{
						if (success = FieldPutRaw (server, "LINE", (APTR)&line))
						{
							if (*text == toupper(*text))
								success = FieldPutRaw (server, "CAPITAL", (APTR)"T");
						}
					}
				}
			}
			if (success)
			{
				if (!(success = DS_DoUpdate (server, DS_UPDATE, NULL)))
				{
					if (IoErr())PrintError (IoErr(), "Failed to confirm insertion");
					else Printf ("Failed to confirm insertion:\n");
					PrintDBError(server);
				}
			}
		}
		else
		{
			Printf ("Failed to add a new record to the DataServer:\n");
			PrintDBError(server);
		}
	}
	else PrintError (IoErr(), "Failed to read a word from the ASCII-file");
	return success;
}

/* NAME
 *		FillTable - fill the DataTable with records
 *
 * SYNOPSIS
 *		BOOL FillTable (struct DataServer *, BPTR)
 *		success = FillTable (server, textFile)
 *
 * FUNCTION
 *		This function inserts as many records into the DataTable as specified
 *		by the user during program-startup.
 *		A key-entry for every record is created in every attached index.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the tested DataTable
 *		textFile - a BPTR to the FileHandle of the ASCII-file that should be
 *					parsed for words that are inserted into the DataTable.
 *
 * RESULT
 *		If the insertion of the records completely succeed without any error or
 *		user-break, TRUE is returned, else FALSE is returned.
 */
BOOL FillTable (struct DataServer *server, BPTR textFile)
{
	BOOL success;
	ULONG recNo;
	/* Evaluate the number of records already stored in the DataServer (as the
	 * result of a previous, interrupted test)...
	 */
	if (success = DS_DoUpdate (server, DS_NUM_OF_ROWS, (APTR)&recNo))
	{
		if (recNo < MaxTestRecords)
		{
			Printf ("\nStart inserting %ld records into the datatable.\n",
																	MaxTestRecords - recNo);
			if (!quiet)
			{
				Printf ("Please be patient, "
					"this could take a while and no respond is\n"
					"send to the user (each additonal I/O falsifies the result).\n"
					"To abort press CTRL-C...\n");
			}
			/* Go to the begin of the ASCII-file...
			 */
			if (Seek (textFile, 0, OFFSET_BEGINNING) != -1)
			{
				if (success = CreateReadBuffer ())
				{
					ULONG seconds;
					ULONG micros;

					CurrentTime (&seconds, &micros);

					while (success && (recNo++ < MaxTestRecords))
					{
						if (CheckSignal (SIGBREAKF_CTRL_C) != 0)
						{
							success = FALSE;
							Printf ("User break after adding %ld records "
												"to the datatable.\n", recNo - 1);
							MeasureTime (&seconds, &micros);
							SetIOErr (ERROR_BREAK);
						}
						else success = AddRecord (server, textFile);
					}
					if (success) MeasureTime (&seconds, &micros);

					DestroyReadBuffer ();
				}
			}
			else
			{
				PrintError (IoErr(), "Failed to access ASCII-file");
				success = FALSE;
			}
		}
	}
	else
	{
		Printf ("Failed to evaluate the number of records stored in the table.\n");
		PrintDBError (server);
	}
	return success;
}

/***************************************************************************/
/*																									*/
/*										Speed test 												*/
/*																									*/
/***************************************************************************/

/* NAME
 *		RemoveRecords - remove all records from the DataTable
 *
 * SYNOPSIS
 *		BOOL RemoveRecords (struct DataServer *)
 *		success = RemoveRecords (server)
 *
 * FUNCTION
 *		This function removes all records from the DataTable and the attached
 *		indexes by removing them one by one.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the tested DataTable
 *
 * RESULT
 *		If the tests completely succeed without any error or user-break, TRUE is
 *		returned, else FALSE is returned.
 */
BOOL RemoveRecords (struct DataServer *server)
{
	BOOL success = FALSE;

	Printf ( "\nThis  final  test will try to  remove all  records from the\n"
				"datatable and all according keys from the attached indexes.\n");
	if (!quiet)
		Printf ("To abort press CTRL-C...\n");

	DBF_ShowDeleted (server, FALSE);
	DS_DoUpdate (server, DS_ORDERASCEND, (APTR)TRUE);

	if (DS_DoUpdate (server, DS_SETORDER, (APTR)idx_IndexName[0]))
	{
		if (success = DS_DoUpdate (server, DS_FIRSTROW, NULL))
		{
			ULONG seconds;
			ULONG micros;
			ULONG numDeleted = 0;

			CurrentTime (&seconds, &micros);

			while (success)
			{
				if (CheckSignal (SIGBREAKF_CTRL_C) != 0)
				{
					success = FALSE;
					SetIOErr (ERROR_BREAK);
					Printf ("User break after removing %ld records.\n", numDeleted);
					MeasureTime (&seconds, &micros);
					server->LastError = DS_ERR_NO_ERROR;
				}
				else if (success = DS_DoUpdate(server, DS_REMOVEROW, NULL))
				{
					if (!(success = DS_DoUpdate (server, DS_UPDATE, NULL)))
					{
						if (IoErr())
							PrintError (IoErr(), "Failed to confirm deletion");
						else
							Printf ("Failed to confirm deletion:\n");
						PrintDBError (server);
					}
					else numDeleted += 1;
				}
				else if (server->LastError != DS_ERR_NO_MORE_DATA)
				{
					Printf ("Failed to mark current record as deleted:\n");
					PrintDBError (server);
				}
			}
			if (server->LastError == DS_ERR_NO_MORE_DATA)
			{
				success = TRUE;
				MeasureTime (&seconds, &micros);
				Printf ("Have removed %ld records.\n", numDeleted);
			}
		}
		else
		{
			Printf ("Failed to skip to first row: ");
			PrintDBError(server);
		}
	}
	else
	{
		Printf ("Failed to change the order used by "
					"the server to \"%s\".\n",idx_IndexName[0]);
		PrintDBError(server);
	}
	return success;
}

/* NAME
 *		SeekSpeed - measure the time required for searching key-values
 *
 * SYNOPSIS
 *		BOOL SeekSpeed (struct DataServer *, BPTR)
 *		success = SeekSpeed (server, textFile)
 *
 * FUNCTION
 *		This test performs two times as many seeks for a key-value of a record
 *		stored in the DataTable as records are in that DataTable.
 *
 *		The first seeks are performed using an alphanumerical index and searching
 *		words in this index.
 *		The second seeks are perforemd using an numerical index and searching
 *		random numbers in this index.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the tested DataTable
 *		textFile - a BPTR to the FileHandle of the ASCII-file previously used to
 *					read words from that are inserted into the records of the
 *					DataTable. Now these words are read again and then they are
 *					searched in the DataTable during the first half of this test.
 *
 * RESULT
 *		If the tests completely succeed without any error or user-break, TRUE is
 *		returned, else FALSE is returned.
 */
BOOL SeekSpeed (struct DataServer *server, BPTR textFile)
{
	BOOL success = FALSE;

	if (DS_DoUpdate (server, DS_SETORDER, (APTR)idx_IndexName[1]))
	{
		/* Seek for words found in the ASCII-file...
		 */
		ULONG maxSeekTests;

		maxSeekTests = MaxTestRecords;
		if (quiet)
			Printf ("Seek for %ld alphanumerical key-values...\n", maxSeekTests);
		else
			Printf ("\nNow the datatable is scanned for the records matching to\n"
						"the words found in the ASCII-file, i.e. %ld 'Seeks' are\n"
						"performed using  \"IDX_EvalExpression()\" to generate the\n"
						"key-values.\n"
						"To abort press CTRL-C...\n", maxSeekTests);

		if (CreateReadBuffer ())
		{
			/* Go to the begin of the ASCII-file...
			 */
			if (Seek (textFile, 0, OFFSET_BEGINNING) != -1)
			{
				STRPTR expr;

				if (DS_DoUpdate (server, DS_KEYEXPRESSION, (APTR)&expr))
				{
					ULONG keyLen;

					if (DS_DoUpdate (server, DS_KEYLENGTH, (APTR)&keyLen))
					{
						APTR keyValue;

						if (keyValue = AllocMem (keyLen, MEMF_ANY))
						{
							ULONG seconds;
							ULONG micros;
							ULONG seekNo = 0;

							CurrentTime (&seconds, &micros);
							success = TRUE;

							while (success && (seekNo++ < maxSeekTests))
							{
								if (CheckSignal (SIGBREAKF_CTRL_C) != 0)
								{
									success = FALSE;
									Printf ("User break after %ld seeks.\n", seekNo - 1);
									MeasureTime (&seconds, &micros);
									SetIOErr (ERROR_BREAK);
								}
								else
								{
									STRPTR word;
									ULONG line;
									UWORD pos;

									if (word = NextWord (textFile, &line, &pos))
									{
										if (success = IDX_EvalExpression (server, expr,
																					keyValue, word))
										{
											if (!(success =
													DS_DoUpdate(server, DS_SEEK, keyValue)))
											{
												if (server->LastError==DS_ERR_NO_MORE_DATA)
													success = TRUE;
												else
												{
													Printf ("Failed to seek to a record "
															"with a matching key-value:\n");
													PrintDBError (server);
												}
											}
										}
										else
										{
											Printf("Failed to generate the key-value.\n");
											success = FALSE;
										}
									}
									else
									{
										success = FALSE;
										PrintError (IoErr(),
											"Failed to read a word from the ASCII-file");
									}
								}
							}
							if (success)
							{
								MeasureTime (&seconds, &micros);
							}
							FreeMem (keyValue, keyLen);
						}
						else PrintError (IoErr(),
											"Failed to allocate buffer for key-value");
					}
					else
					{
						Printf ("Failed to determine length of a key-value:\n");
						PrintDBError (server);
					}
				}
				else
				{
					Printf ("Failed to determine key-expression "
													"of current order:\n");
					PrintDBError (server);
				}
			}
			else
			{
				PrintError (IoErr(), "Failed to access ASCII-file");
				success = FALSE;
			}
			DestroyReadBuffer ();
		}
		if (success)
		{
			/* Seek for random numbers...
			 */
			success = FALSE;

			if (quiet)
				Printf ("Seek for %ld numerical key-values...\n", maxSeekTests);
			else
				Printf ( "\nNow the datatable is scanned for the records matching a\n"
							"random  number,  i.e. %ld 'Seeks'  are performed  using\n"
							"\"IDX_EvalExpression()\" to generate the key-values.\n"
							"To abort press CTRL-C...\n", maxSeekTests);

			if (DS_DoUpdate (server,DS_SETORDER,(APTR)idx_IndexName[0]))
			{
				STRPTR expr;

				if (DS_DoUpdate (server, DS_KEYEXPRESSION, (APTR)&expr))
				{
					ULONG keyLen;

					if (DS_DoUpdate (server, DS_KEYLENGTH, (APTR)&keyLen))
					{
						APTR keyValue;

						if (keyValue = AllocMem (keyLen, MEMF_ANY))
						{
							ULONG seconds;
							ULONG micros;
							ULONG seekNo = 0;

							CurrentTime (&seconds, &micros);
							success = TRUE;

							while (success && (seekNo++ < maxSeekTests))
							{
								if (CheckSignal (SIGBREAKF_CTRL_C) != 0)
								{
									success = FALSE;
									Printf ("User break after %ld seeks.\n", seekNo - 1);
									MeasureTime (&seconds, &micros);
									SetIOErr (ERROR_BREAK);
								}
								else
								{
									ULONG rand;

									rand = RangeRand(65535) + 1;

									if (success = IDX_EvalExpression (server, expr,
																					keyValue, rand))
									{
										if (!(success =
													DS_DoUpdate(server, DS_SEEK, keyValue)))
										{
											if (server->LastError == DS_ERR_NO_MORE_DATA)
												success = TRUE;
											else
											{
												Printf ("Failed to seek to a record "
														"with a matching key-value:\n");
												PrintDBError (server);
											}
										}
									}
									else
									{
										Printf ("Failed to generate the key-value.\n");
									}
								}
							}
							if (success)
							{
								MeasureTime (&seconds, &micros);
							}

							FreeMem (keyValue, keyLen);
						}
						else PrintError (IoErr(),
											"Failed to allocate buffer for key-value");
					}
					else
					{
						Printf ("Failed to determine length of a key-value:\n");
						PrintDBError (server);
					}
				}
				else
				{
					Printf ("Failed to determine key-expression "
													"of current order:\n");
					PrintDBError (server);
				}
			}
			else
			{
				Printf ("Failed to change the order used by "
							"the server to \"%s\".\n",idx_IndexName[0]);
				PrintDBError(server);
			}
		}
	}
	else
	{
		Printf ("Failed to change the order used by "
					"the server to \"%s\".\n", idx_IndexName[1]);
		PrintDBError(server);
	}
	return success;
}

/* NAME
 *		ChangeRecordSpeed - change the contents of the records
 *
 * SYNOPSIS
 *		BOOL ChangeRecordSpeed (struct DataServer *)
 *		ChangeRecordSpeed (server)
 *
 * FUNCTION
 *		This function changes the contents of half of the records of the
 *		DataTable. The attached indexes are also changed to match these changes.
 *
 *		The value stored in the DataColumn names "RANDOM" is increased by one in
 *		the first half of the records of the DataTable.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the tested DataTable
 *
 * RESULT
 *		If the tests completely succeed without any error or user-break, TRUE is
 *		returned, else FALSE is returned.
 */
BOOL ChangeRecordSpeed (struct DataServer *server)
{
	BOOL success;

	if (success = DS_DoUpdate (server, DS_SETORDER, NULL))
	{
		ULONG numToChange = MaxTestRecords >> 1;

		if (quiet)
			Printf ("Change %ld record of the DataServer...\n", numToChange);
		else
			Printf ("\nThe randomnumber stored in the column \"RANDOM\" is increased\n"
						"by one in %ld records of the DataServer.\n"
						"The order that indexes this column is changed implicit.\n"
						"To abort press CTRL-C...\n", numToChange);

		if (success = DS_DoUpdate (server, DS_FIRSTROW, NULL))
		{
			ULONG seconds;
			ULONG micros;
			ULONG numChanged = 0;
			ULONG numColumn;

			if (!(success = DS_DoUpdate (server, DS_FINDCOLUMN, (APTR)"RANDOM")))
			{
				Printf ("Failed to locate the column named \"RANDOM\":\n");
				PrintDBError (server);
			}
			else numColumn = server->CurrentColumn;

			CurrentTime (&seconds, &micros);

			while (success && (numChanged < numToChange))
			{
				ULONG *rand;

				if (CheckSignal (SIGBREAKF_CTRL_C) != 0)
				{
					success = FALSE;
					Printf ("User break after %ld changed records.\n", numChanged);
					MeasureTime (&seconds, &micros);
					SetIOErr (ERROR_BREAK);
					server->LastError = DS_ERR_NO_ERROR;
				}
				else if (success = DS_DoUpdate(server, DS_GETRAWDATA, (APTR)&rand))
				{
					ULONG value;

					value = *rand + 1;
					if (success = DS_DoUpdate (server, DS_SETRAWDATA, (APTR)&value))
					{
						if (success = DS_DoUpdate (server, DS_UPDATE, NULL))
						{
							numChanged += 1;
							if (success = DS_DoUpdate (server, DS_NEXTROW, NULL))
							{
								if (!(success = DS_DoUpdate (server, DS_GOTOCOLUMN,
																				(APTR)numColumn)))
								{
									Printf ("Failed to position to the "
												"column named \"RANDOM\":\n");
									PrintDBError (server);
								}
							}
							else
							{
								if (server->LastError != DS_ERR_NO_MORE_DATA)
								{
									Printf ("Failed to skip to next record:\n");
									PrintDBError (server);
								}
							}
						}
						else
						{
							Printf ("Failed to store the changed record:\n");
							PrintDBError (server);
						}
					}
					else
					{
						Printf ("Failed to store changed value:\n");
						PrintDBError (server);
					}
				}
				else
				{
					Printf ("Failed to read value to be changed:\n");
					PrintDBError (server);
				}
			}
			if ((numChanged == numToChange) &&
				(success || (server->LastError == DS_ERR_NO_MORE_DATA)))
			{
				MeasureTime (&seconds, &micros);
				success = TRUE;
			}
		}
		else
		{
			Printf ("Failed to skip to first row: ");
			PrintDBError(server);
		}
	}
	else
	{
		Printf ("Failed to clear the order used by the DataServer: ");
		PrintDBError (server);
	}
	return success;
}

/* NAME
 *		SkipSpeed - skip throught the whole DataTable
 *
 * SYNOPSIS
 *		BOOL SkipSpeed (struct DataServer *, BOOL)
 *		SkipSpeed (server, readData)
 *
 * FUNCTION
 *		This function skips through the whole DataTable from the first to the
 *		last record. It uses every available index for skipping, i.e. it
 *		activates one index after the other and performs the skipping from first
 *		to last record using that index.
 *		The time required to skip through the whole DataTable is measured. The
 *		overall time for all skips is also evaluated.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the tested DataTable
 *		readData - a boolean value, TRUE indicates that the contents of every
 *					record should be read, i.e. the record needs to be read;
 *					FALSE indicates that the record is not read, i.e. only the index
 *					is accessed and the record pointer is moved. Therefor this
 *					function requires less I/O-operations.
 *
 * RESULT
 *		If the tests completely succeed without any error or user-break, TRUE is
 *		returned, else FALSE is returned.
 */
BOOL SkipSpeed (struct DataServer *server, BOOL readData)
{
	BOOL success;
	STRPTR *orders;

	if (success = DS_DoUpdate (server, DS_AVAILABLEORDER, (APTR)&orders))
	{
		ULONG totalSecs = 0;
		ULONG totalMics = 0;
		ULONG seconds;
		ULONG micros;
		ULONG numSkips = 0;

		Printf ( "\nNow  every  record  of  the  whole  datatable  is  skipped\n"
					"sequentiell, using every available order.\n");

		if (readData)
			Printf ("The data of every column of every record is read.\n");

		if (!quiet) Printf ("To abort press CTRL-C...\n");
		while (success && *orders)		
		{
			if (!quiet) Printf ("Use the order \"%s\"...\n", *orders);
			if (success = DS_DoUpdate (server, DS_SETORDER, (APTR)*orders))
			{
				CurrentTime (&seconds, &micros);
				success = DS_DoUpdate (server, DS_FIRSTROW, NULL);
				while (success)
				{
					if (CheckSignal (SIGBREAKF_CTRL_C) != 0)
					{
						Printf ("User break after %ld records have been skipped.\n",
																							numSkips);
						MeasureTime (&seconds, &micros);
						SetIOErr (ERROR_BREAK);
						server->LastError = DS_ERR_NO_ERROR;
						success = FALSE;
					}
					else
					{
						numSkips += 1;
						if (readData)
						{
							/* Read the contents of the whole record...
							 */
							STRPTR value;

							success = DS_DoUpdate(server, DS_GOTOCOLUMN, (APTR)1);

							while (success)
							{
								if (success = DS_DoUpdate (server, DS_GETCOLUMNDATA,
																					(APTR)&value))
								{
									success = DS_DoUpdate (server, DS_NEXTCOLUMN, NULL);
								}
							}
							if (server->LastError == DS_ERR_NO_MORE_DATA)
								success = TRUE;
						}
						if (success)
							success = DS_DoUpdate (server, DS_NEXTROW, NULL);
					}
				}
				if (server->LastError == DS_ERR_NO_MORE_DATA)
				{
					success = TRUE;
					if (quiet)
					{
						ULONG endSec;
						ULONG endMic;

						CurrentTime (&endSec, &endMic);
						ElapsedTime (&seconds, &micros, endSec, endMic);
					}
					else MeasureTime (&seconds, &micros);
					totalSecs += seconds;
					totalMics += micros;
				}
			}
			orders += 1;
		}
		if (success)
		{
			/* How long does the whole test takes ?
			 */
			totalSecs += totalMics / 1000000;
			totalMics %= 1000000;
			Printf ("Whole skip-test has required: %ld.%03ld seconds.\n",
														totalSecs, totalMics / 1000);
		}
	}
	return success;
}

/* NAME
 *		NewIndexSpeed - measure the time required to reindex an index
 *
 * SYNOPSIS
 *		BOOL NewIndexSpeed (struct DataServer *)
 *		success = NewIndexSpeed (server)
 *
 * FUNCTION
 *		This function creates a new empty index and then the time required to
 *		reindex that index, i.e. to create a key-entry for every of the records
 *		of the DataTable is measured.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the tested DataTable
 *
 * RESULT
 *		If the tests completely succeed without any error or user-break, TRUE is
 *		returned, else FALSE is returned.
 */
BOOL NewIndexSpeed (struct DataServer *server)
{
	BOOL success;

	Printf ("\nCreating a new index and add it to the datatable.\n");

	if (success = CreateIndex ((struct DataTable *)server, NumIndexes, TRUE))
	{
		struct IDXHeader *ihd;

		if (ihd = DBF_GetOrder (server, idx_IndexName[NumIndexes]))
		{
			ULONG seconds;
			ULONG micros;

			if (!quiet)
			{
				Printf ( "Now it is reindexed and the time required is measured.\n"
							"To abort press CTRL-C...\n");
			}

			/* Patch the index to a non-custom index...
			 */
			ihd->Flags &= ~IDX_CUSTOM;

			CurrentTime (&seconds, &micros);
			if (DBF_ReIndex (server, idx_IndexName[NumIndexes], &CheckAbort, NULL))
				MeasureTime (&seconds, &micros);
			else
			{
				if (IoErr()) PrintError (IoErr(),"Failed to reindex");
				else Printf ("Failed to reindex: ");
				PrintDBError (server);
			}
		}
		else
		{
			Printf ("Failed to access the new index: ");
			PrintDBError (server);
		}
	}
	else
	{
		if (IoErr()) PrintError (IoErr(),"Failed to create index");
		else Printf ("Failed to create index: ");
		PrintDBError (server);
	}
	return success;
}

/* NAME
 *		SpeedTest - perform several speedtest to a DataServer
 *
 * SYNOPSIS
 *		BOOL SpeedTest (struct DataServer *, BPTR)
 *		success = SpeedTest (server, textFile)
 *
 * FUNCTION
 *		This function performs several tests to an empty DataServer to measure
 *		the time required for that kind of operation.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the tested DataTable
 *		textFile - a BPTR to the FileHandle of the ASCII-file that should be
 *					parsed for words that are inserted into the DataTable.
 *
 * RESULT
 *		If the tests completely succeed without any error or user-break, TRUE is
 *		returned, else FALSE is returned.
 */
BOOL SpeedTest (struct DataServer *server, BPTR textFile)
{
	BOOL success = FALSE;

	if (FillTable (server, textFile))
	{
		/* A new index is created, added to the DataServer and reindexed...
		 */
		if (NewIndexSpeed (server))
		{
			/* The datatable is parsed sequentiell using every available index
			 * without reading any further data from it.
			 */
			if (SkipSpeed (server, FALSE))
			{
				/* The datatable is parsed sequentiell using every available index
				 * and reading every column of every record.
				 */
				if (SkipSpeed (server, TRUE))
				{
					/* The datatable is parsed sequentiell using no index,
					 * and the value of every random number stored in the datatable
					 * is increased by one.
					 * There is an index that indexes these numbers, the index is
					 * changed implicit.
					 */
					if (ChangeRecordSpeed (server))
					{
						/* A couple of seeks are performed to search records.
						 */
						success = SeekSpeed (server, textFile);
					}
				}
			}
		}
	}
	return success;
}

/***************************************************************************/
/*																									*/
/*						functions for initialization/termination						*/
/*																									*/
/***************************************************************************/

/* NAME
 *		StartTest - prepare anything required for testing
 *
 * SYNOPSIS
 *		LONG StartTest (STRPTR, STRPTR)
 *		result = StartTest (destPath, textFile)
 *
 * FUNCTION
 *		This function prepares the DataTable its Indexes and all according
 *		structures that are required to perform the tests.
 *		If everything wents fine, the testsuite is started. After the tests
 *		are performed (or canceled by the user), everything is cleaned up. 
 *
 * INPUTS
 *		destPath - a pointer to a NUL-terminated C-string specifying the
 *						destination path of the testfiles to be created
 *		textFile - a pointer to a NUL-terminated C-string specifying the
 *						path to an ASCII-file, that is used to read the words
 *						from that are inserted into the test datatable.
 *
 * RESULT
 *		If the tests could be performed successfully RETURN_OK is returned,
 *		else RETURN_WARN is returned.
 */
LONG StartTest (STRPTR destPath, STRPTR textFile)
{
	LONG result = RETURN_WARN;
	BPTR fh;
	BPTR dirFl;
	LONG dosError = 0L;

	if (!quiet) Printf ("Open the ASCII-file \"%s\"...\n", textFile);
	if (fh = Open (textFile, MODE_OLDFILE))
	{
		if (!quiet)
		{
			Printf ("Open the datatable in the directory \"%s\"...\n", destPath);
		}
		if (dirFl = Lock (destPath, SHARED_LOCK))
		{
			APTR te;

			if (te = InitTableEdit (0))
			{
				BPTR cDir;

				SetIOErr (0L);
				cDir = CurrentDir (dirFl);
				if (!IoErr())
				{
					struct DataServer *server;

					srvTags[0].ti_Data = (ULONG)TableName;
					srvTags[1].ti_Data = (ULONG)TableFile;
					srvTags[2].ti_Data = (ULONG)dbStruct;

					/* Ok, lets try to create the DataTable...
					 */
					Printf ("Open the datatable \"%s\" with the "
									"filename \"%s\"...\n", TableName, TableFile);

					if (server = DBF_InitA (NULL, srvTags))
					{
						if (AddOpenTable (te, server))
						{
							/* Create the indexes...
							 */
							if (CreateOrders ((struct DataTable *)server))
							{
								if (DS_DoUpdate (server, DS_SETORDER,
																(APTR)idx_IndexName[0]))
								{
									if (SpeedTest (server, fh))
									{
										/* Change current directory back...
										 */
										CurrentDir (cDir);

										if (!quiet)
										{
											Printf ("\nYou could now  have a  closer look"
												"  to the  test-datatable,\n"
												"but you should avoid doing any changes"
												" to the datatable, or\n"
												"the final deletion-test may fail.\n\n");

											TableEdit (te);
										}
										/* Clean up the DataTable again...
										 */
										if (RemoveRecords (server)) result = RETURN_OK;
										dosError = IoErr();
									}
									else dosError = IoErr();
								}
								else
								{
									dosError = IoErr();
									Printf ("Failed to activate the main index: ");
									PrintDBError (server);
								}
							}
						}
						else
						{
							dosError = IoErr();
							DS_DoUpdate (server, DS_DISPOSE, NULL);
						}
						if (!quiet)
						{
							Printf("Remember to remove the testfiles:   %s\n",TableFile);
							{
								ULONG i;

								for (i = 0; i <= NumIndexes; i++)
								{
									Printf ("   %s\n", idx_FileName[i]);
								}
							}
							Printf ("from the directory %s.\n", destPath);
						}
					}
					else if (dosError = IoErr())
						PrintError (IoErr(), "Failed to open datatable");
					else
						Printf ("Failed to open datatable.\n");
				}
				else
				{
					PrintError (IoErr(), "Failed to change directory");
					dosError = IoErr();
				}

				/* Change current directory back (regardless if I've already
				 * changed back, in that case this is a NOP)...
				 */
				CurrentDir (cDir);

				DisposeTableEdit (te);
			}
			else dosError = IoErr();

			UnLock (dirFl);
		}
		else
		{
			PrintError (IoErr(), "Failed to get directory lock");
			dosError = IoErr();
		}
		Close (fh);
	}
	else PrintError (IoErr(), "Failed to open ASCII-file");

	if (dosError) SetIOErr (dosError);
	return result;
}

/* NAME
 *		Main - the application entry function
 *
 * SYNOPSIS
 *		result = Main (length, cmdline)
 *		LONG Main (LONG, char*)
 *
 * FUNCTION
 *		This is the entry point of the application; this function is directly
 *		called from the startup-code.
 *
 *		The function examines, whether the user has specified an argument string
 *		and evaluates this.
 *		If the user choses valid arguments and passes a gultiy filename and
 *		destination path, the test-routines are called.
 *
 *		If no commandline is passed, the user is asked to insert one.
 *
 * INPUTS
 *		length - the number of characters that are stored in the passed
 *					commandline.
 *		cmdline - the commandline the user specified at program-startup.
 *
 * RESULT
 *		The final application result is returned, which is RESULT_FAIL if the
 *		application completely failed; RETURN_WARN, if anything fails during
 *		the program execution (something like no free store); RETURN_OK if
 *		everything wents fine.
 */
LONG Main (LONG length, char* cmdline)
{
	LONG result = RETURN_FAIL;

	if (OpenLibs())
	{
		if (length >= 0)
		{
			/* The test-suite has to be run from CLI.
			 */
			LONG vec[7] = {0};
			struct RDArgs *rda;

			Printf ("Speedtest v 1.0, © 2004, Peter Riede\n"
						"Tests the speed of the database.library.\n\n");

			/* First get the parsed arguments...
			 */
			result = RETURN_WARN;
			if ((rda = AllocDOSObject (DOS_RDARGS, NULL)) != NULL)
			{
				LONG dosError;

				if (cmdline && length)
				{
					rda->RDA_Source.CS_Buffer = cmdline;
					rda->RDA_Source.CS_Length = length;
				}
				rda->RDA_ExtHelp =
					"Available commandline arguments:\n"
					"Destination: the path where the testdatabase should be placed;\n"
					"Text:        path to an ASCII-file used to extract words from;\n"
					"NumRecords:  the number of records to be created (>= 100);\n"
					"Quiet:       switch, just do the minimum required console output;\n"
					"Exclusive:   switch, accesses the database in exclusive mode;\n"
					"Nolock:      switch, don't uses record locking;\n"
					"Full:        switch, use exclusive locking schema;\n"
					"Per default the testdatabase is opened in shared mode, using\n"
					"an optimistic record locking schema; 5000 records are created\n"
					"for testing.\n"
					"Enter parameters: ";

				if (ParseArgs ("DESTINATION=DEST/A,TEXT/A,NUMRECORDS=NUM/N,"
						"QUIET/S,EXCLUSIVE=EXCL/S,NOLOCK/S,FULL/S", vec,rda) != NULL)
				{
					if (vec[2]) MaxTestRecords = *((ULONG *)(vec[2]));
					if (vec[3]) quiet = TRUE;
					if (vec[4]) srvTags[4].ti_Tag = DBF_Exclusive;
					if (vec[5]) srvTags[3].ti_Data = DSF_LOCK_NONE;
					if (vec[6]) srvTags[3].ti_Data = DSF_LOCK_FULL;

					if (MaxTestRecords >= 100)
					{
						result = StartTest ((STRPTR)vec[0], (STRPTR)vec[1]);
						dosError = IoErr();
					}
					else
					{
						Printf ("You must specify at least 100 "
												"records for testing.\n");
						dosError = ERROR_BAD_NUMBER;
					}
					FreeArguments (rda);
				}
				else
				{
					dosError = IoErr();
					PrintError (dosError, "Failed to parse commandline arguments");
				}
				FreeDOSObject (DOS_RDARGS, rda);
				SetIOErr (dosError);
			}
			else PrintError (IoErr(), "Failed to allocate RDArgs structure");
		}
		else TextBox (NULL, "Speedtest",
						"This test-suite has to be run from CLI only.", MSG_INFO,0L);
	}
	else if (!JoinOSBase)
	{
		/* Just produce an error-message, if the program is started from CLI...
		 */
		if (length >= 0) Printf ("Unable to open joinOS.library\n");
	}
	CloseLibs();
	return result;
} 
