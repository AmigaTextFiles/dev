/* TableEdit.c
 *
 * This is a shell-tool for general access to DataTables.
 *	The DataTable has to be created and opened at the application entry, and
 * this module is linked against that application and allows to do several
 * manipulations to that DataTable:
 *
 * The Table may be browsed (define BROWSER_PAGE_LENGTH with the number of
 * lines that should be displayed at a time, before the user is requested
 * to hit RETURN to continue browsing, default is 40).
 *
 * Any record may be displayed, by jumping direct to it.
 *
 * The current order may be changed.
 *
 * New records could be added, existing records could be removed or changed.
 */
#include "TableEdit.h"

#ifndef _MEMORY_H_
#include <joinOS/exec/memory.h>
#endif

#ifndef _DATABASE_DATATABLE_H_
#include <joinOS/database/DataTable.h>
#endif

#ifndef _DATABASE_MEMO_H_
#include <joinOS/database/Memo.h>
#endif

#ifndef _DATABASE_PARSE_H_
#include <joinOS/database/Parse.h>
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
/*											Structures											*/
/*																									*/
/***************************************************************************/

/* structure used to chain strings...
 */
struct StringChain
{
	struct StringChain *Next;	/* pointer to next string */
	UBYTE String[0];				/* start of buffer containing the string */
};

/* This structure is used for every opened table...
 */
struct OpenTable
{
	struct Node Link;					/* used to link into a list */
	struct DataServer *Server;		/* the table */
	STRPTR ColumnCaptions;
	UWORD *ColumnWidth;
	UBYTE *TopScope;
	UBYTE *BottomScope;
	UBYTE *Buffer;			/* used for expression and ordername for relations */
	struct StringChain *StrChain;	/* buffered strings */
};

/* This is the main structure handling the data required for this module...
 */
struct TableEdit
{
	struct OpenTable *Used;			/* currently active table */
	struct List Tables;				/* the list of open tables */
	UBYTE *Buffer;						/* Input buffer for communication with user */
	ULONG	PageLength;					/* number of rows to be printed in one run */
};

/***************************************************************************/
/*																									*/
/*										Global data												*/
/*																									*/
/***************************************************************************/

#ifndef ZERO
#define ZERO 0L
#endif

#ifndef BROWSER_PAGE_LENGTH
#define BROWSER_PAGE_LENGTH 40
#endif

STRPTR commands[] =
{
	"Alias",
	"Ascend",
	"AvailableOrders",
	"Bottom",
	"BottomScope",
	"ClearRelation",
	"Close",
	"Closeindex",
	"CurrentOrder",
	"Debug",
	"Delete",
	"Descend",
	"Edit",
	"Expression",
	"FieldGet",
	"Goto",
	"Help",
	"List",
	"Lock",
	"LockIndex",
	"LockMemo",
	"LockMode",
	"Macro",
	"New",
	"Next",
	"Open",
	"Openindex",
	"Order",
	"PageLength",
	"Previous",
	"Quit",
	"Record",
	"ReIndex",
	"Relations",
	"Seek",
	"SetRelation",
	"ShowAll",
	"Skip",
	"Statistic",
	"Stop",
	"Structure",
	"Tables",
	"Top",
	"TopScope",
	"Unlock",
	"UnlockIndex",
	"UnlockMemo",
	"Use",
	NULL
};

#define CMD_ALIAS					1
#define CMD_ORDER_ASCEND		2
#define CMD_AVAIL_ORDER			3
#define CMD_SKIP_BOTTOM			4
#define CMD_SET_BOTTOM_SCOPE	5
#define CMD_CLEAR_RELATION		6
#define CMD_CLOSE					7
#define CMD_CLOSEINDEX			8
#define CMD_CURRENT_ORDER		9
#define CMD_DEBUG					10
#define CMD_DELETE				11
#define CMD_ORDER_DESCEND		12
#define CMD_EDIT					13
#define CMD_EXPRESSION			14
#define CMD_FIELDGET				15
#define CMD_GOTO					16
#define CMD_HELP					17
#define CMD_LIST					18
#define CMD_LOCK_RECORD			19
#define CMD_LOCK_INDEX			20
#define CMD_LOCK_MEMO			21
#define CMD_LOCK_MODE			22
#define CMD_EVAL_MACRO			23
#define CMD_NEW					24
#define CMD_NEXTRECORD			25
#define CMD_OPEN					26
#define CMD_OPENINDEX			27
#define CMD_SET_ORDER			28
#define CMD_PAGE_LENGTH			29
#define CMD_PREVIOUSRECORD		30
#define CMD_QUIT					31
#define CMD_RECORD_MACRO		32
#define CMD_REINDEX				33
#define CMD_RELATIONS			34
#define CMD_SEEK					35
#define CMD_SET_RELATION		36
#define CMD_SHOW_ALL				37
#define CMD_SKIP					38
#define CMD_STATISTIC			39
#define CMD_STOP_MACRO			40
#define CMD_DBSTRUCT				41
#define CMD_OPEN_TABLES			42
#define CMD_SKIP_TOP				43
#define CMD_SET_TOP_SCOPE		44
#define CMD_UNLOCK_RECORD		45
#define CMD_UNLOCK_INDEX		46
#define CMD_UNLOCK_MEMO			47
#define CMD_USE					48

STRPTR helpText[] =
{
	"This command  may be used to add or remove  aliases  to the\n"
	"indexes  of the  DataTable.  An alias is  just another name\n"
	"that may be used to access  an index.  The command  \"Alias\"\n"
	"has to be followed by the name of the alias. If you wish to\n"
	"add a new alias,  the name of the \"aliased\" index has to be\n"
	"specified as second argument. If no second argument occurs,\n"
	"the specified alias is removed;  e.g. \"Alias Foobar foobar\"\n"
	"will add the alias \"Foobar\" to the index \"foobar\" (the name\n"
	"of an index is case-sensitive);  \"Alias Foobar\" will remove\n"
	"this alias again.\n",

	"If you  enter this command, the records are ordered ascend,\n"
	"i.e. in the creation order of the current index.\n",

	"Shows the names of all available indexes.\n",

	"Skips to the last record in the DataTable\n",

	"Sets the bottom scope.  The keyvalue has to be specified as\n"
	"described  for  the  \"Seek\"  command.  If  no  keyvalue  is\n"
	"specified, the bottom scope is cleared.\n",

	"Clear the relation with the specified client server,e.g. if\n"
	"a client server with the name  \"Foobar\"  is attached to the\n"
	"currently active server,  \"ClearRelation Foobar\" will clear\n"
	"this relation.\n",

	"Close the DataTable with the specified name. If the table --\n"
	"that is currently in use -- is closed, the first table found\n"
	"in the list of open tables is activated.\n",

	"Close the index of the active DataTable with the specified\n"
	"name,e.g. \"CloseIndex Foobar\" will close the index \"Foobar\"\n"
	"of the currently active DataTable.\n",

	"Shows the name of the currently active index.\n",

	"Shows some  debug-information  about the  currently  active\n"
	"table.  These  informations are normally useless for users,\n"
	"except if you have  written code that makes direct  changes\n"
	"to the tables DataTable structure.\n",

	"Deletes the record with the specified recordnumber, or  the\n"
	"current  record  if  no  recordnumber  is  specified,  e.g.\n"
	"\"Delete 20\" will delete the record with the recordnumber 20.\n",

	"If you enter this command, the records are ordered descend,\n"
	"i.e. in the opposite direction as the creation order of the\n"
	"current index.\n",

	"Change the specified record, the keyword \"Edit\" should be\n"
	"followed by the number of the record to be changed,then the\n"
	"columns to be changed may follow as specified for the \"New\"\n"
	"command. If the record number is not specified, the current\n"
	"record is changed.\n",

	"Shows the key-expression of the currently active index.\n",

	"Prints the value  stored in a single column of the  current\n"
	"record. The columnname has to be entered behind the keyword\n"
	"\"FieldGet\"; e.g. \"FieldGet Foobar\"  will print the contents\n"
	"of the column \"Foobar\". If there are equal named columns in\n"
	"a record  (as the result of a relation  between two or more\n"
	"DataTables) the contents of the first one found is printed.\n"
	"If you wish to get the contents of the equal named ones,you\n"
	"have  to  preceed the  columns  name with  the name  of the\n"
	"owning DataTable, separated by a colon;\n"
	"e.g.  \"FieldGet Foo:Foobar\"  will print the contents of the\n"
	"column \"Foobar\" inherited from the related DataTable \"Foo\".\n",

	"Jumps direct  to  the record with  the specified number and\n"
	"displays it.\n",

	"Displays the helptext about any command,  e.g. this text is\n"
	"returned for \"help help\".\n",

	"Lists  all  records  of  the  DataTable,  ordered using the\n"
	"currently active index.\n",

	"Tries to lock the current record. If the keyword \"exclusive\"\n"
	"followes the command,  the record is locked  exclusive (for\n"
	"write access)  otherwise  it  is  locked shared  (for  read\n"
	"access). Every locked record must be unlocked by a matching\n"
	"command \"Unlock\".\n",

	"Tries to lock an index.  If the command  is followed by the\n"
	"name of an index,  this index  is tried to be locked,  else\n"
	"the currently active  index will be locked.  If the keyword\n"
	"\"exclusive\" followes  the command  and optional  indexname,\n"
	"the index is locked  exclusive (for write access) otherwise\n"
	"it is locked  shared  (for read-only access).  Every locked\n"
	"index must be unlocked by a matching command \"UnlockIndex\".\n",

	"Tries to lock the memo-file of the  DataTable  (if there is\n"
	"one at all. The file will be locked exclusive, shared locks\n"
	"are not supported by memo-files  (read locks of  memo-files\n"
	"are not required due to the implementation of the DataTable\n"
	"class,  accessing the memo-files).  Every locked  memo-file\n"
	"must be unlocked by a matching command \"UnlockMemo\".\n",

	"Prints the  currently used  locking mode.  If the comand is\n"
	"followed by one of the following keywords:  \"None\", \"Full\",\n"
	"or \"Optimistic\", the according locking mode is set.\n",

	"Evaluate the specified macro,  previously recorded for this\n"
	"DataTable.  The name of the marco must  be specified behind\n"
	"the \"Macro\" keyword, e.g. \"Macro RAM:Test.mcr\"\n",

	"Add a new record to the DataTable, you may either enter the\n"
	"records contents following the keyword \"New\" or you will be\n"
	"asked for a value for every column of the DataTable.\n"
	"Example:  If the DataTable has three columns with the names\n"
	"\"FirstName\",  \"Name\",  and \"Age\" where \"Age\" is a numerical\n"
	"value (a byte should do it) and the other columns are alpha-\n"
	"numerical columns, you may enter this to add a new record:\n"
	"   \"New Name=Meier FirstName Franz Age=32\"\n"
	"(Where the columnnames and their values may be separated by\n"
	"either an equal sign or a space)\n",

	"Skips to the next record (a shortcut for \"Skip 1\").\n",

	"Opens the DataTable with the specified name searching under\n"
	"the  specified  path,  e.g.  \"Open Foobar RAM:T/foobar.dbf\"\n"
	"will  open  the  DataTable with  the name \"Foobar\" with the\n"
	"according DataTable file located in \"RAM:T/foobar.dbf\"\n",

	"Opens the index found at the specified path and attaches it\n"
	"to the currently active DataTable  using the name stored in\n"
	"the  index-file;   e.g.  \"OpenIndex RAM:T/foobar.idx\"  will\n"
	"open the  index with the file located in \"RAM:T/foobar.idx\"\n"
	"The commandline may be terminated by the  keyword \"unique\".\n"
	"If this keyword is entered the index is using unique  keys,\n"
	"i.e. every key-value will only occure once.\n",

	"Changes the currently active index,e.g.\"Order Test\" changes\n"
	"the active index to the one named \"Test\".\n",

	"Using this command,  you are  able to define  the number of\n"
	"rows that should be printed to the output before the output\n"
	"is interupted. After the specified number of rows, the user\n"
	"is asked to press [ENTER], before the output is continued.\n",

	"Skips to the previous record (a shortcut for \"Skip -1\").\n",

	"Terminates this application.\n",

	"Records a macro,  i.e. copies all following inputs into the\n"
	"commandline into the specified macrofile.  The  name of the\n"
	"marco must be  specified  behind the \"Record\" keyword, e.g.\n"
	"\"Record RAM:Test.mcr\"\n",

	"The index with the specified name attached to the currently\n"
	"active DataTable is reindexed, i.e. all keys stored in this\n"
	"index  are  removed  and  a key  for every  record  of  the\n"
	"DataTable is added to this empty index.\n"
	"If no name is specified, the active index is reindexed.\n",

	"Shows all relations of the currently active DataTable, i.e.\n"
	"the name,  expression and  index used  for the  relation of\n"
	"every client DataTable  related to the active DataTable are\n"
	"shown.\n",

	"Seeks to the first record with a  keyvalue greater than the\n"
	"specified keyvalue, e.g. if the  currently active index has\n"
	"a  key-expression  of \"Upper(Name+Firstname)\" you may enter\n"
	"\"Seek Meier\" to  find the first \"Meier\" in the DataTable or\n"
	"you may enter \"Seek Meier Franz\" to  find the first \"Meier\"\n"
	"with a firstname of \"Franz\" or greater (\"Georg\" is greater).\n",

	"Using this command, a relation  between two open DataTables\n"
	"can be established. The first - superior - DataTable is the\n"
	"currently active DataTable,  the client is specified by its\n"
	"name. The index used for the client and the expression that\n"
	"is used to generate the relations key  are specified as 2nd\n"
	"and 3rd argument; e.g. \"SetRelation Foobar Id VAL(ID)\" will\n"
	"try  to create a relation  between the active DataTable and\n"
	"the one with the name \"Foobar\".  The client will be ordered\n"
	"using the  index named \"Id\"  and the keys are  generated by\n"
	"evaluating the expression \"VAL(ID)\".\n",

	"If  this  command  is followed  by the  keyword \"TRUE\"  all\n"
	"records  of this  table  are displayed,  even  if they  are\n"
	"marked to be deleted.\n"
	"Deleted records will nevertheless only be displayed,  if no\n"
	"index is active,  because  deleted  records  have  never  a\n"
	"matching key-value in any valid index.\n",

	"Skips the specified number of records, e.g. \"Skip -3\" skips\n"
	"three records to the top.\n",

	"Shows some statistic information about the DataTable.\n",

	"Stops the recording  of a  macro.  If currently no macro is\n"
	"recorded, this command is ignored silently.\n",

	"Prints the structure of the DataTable to the screen.\n",

	"Shows a list of all opened DataTables, the currently active\n"
	"DataTable is \"highlighted\".\n",

	"Skips to the first record in the DataTable.\n",

	"Sets the top scope.  The keyvalue  has  to be  specified as\n"
	"described  for  the \"Seek\"  command.  If  no keyvalue  is\n"
	"specified, the top scope is cleared.\n",

	"This function unlocks a record previously locked by \"Lock\".\n",

	"This  function  unlocks  an  index   previously  locked  by\n"
	"\"LockIndex\".  If the command  is followed by the name of an\n"
	"index,  this index  is unlocked,  else the currently active\n"
	"index will be unlocked.\n",

	"This  function  unlocks  a memo-file  previously  locked by\n"
	"\"LockMemo\".\n",

	"Activates the DataTable with the specified name to be used,\n"
	"i.e. all commands like \"Skip\", \"Edit\", or \"Delete\" are send\n"
	"to this DataTable from now on.\n"
};

STRPTR mainHelp =
	"View and change the DataTable.\n"
	"Enter \"Help\" to get a list of the commands.\n"
	"Enter \"Help\" followed by a commandname to get help for that command,\n"
	"e.g. enter \"Help help\" to get a description of the \"help\" command.\n";

/***************************************************************************/
/*																									*/
/*							functions for testing a DataTable							*/
/*																									*/
/***************************************************************************/

void PrintDBHeader (struct DataTable *dbTable)
{
	Printf ("DataTable at address 0x%0.8lX:\n", dbTable);
	Printf ("Name of the DataTable:                 %s\n", dbTable->DS.Name);
	Printf ("Size of the DataTable structure:       %ld bytes\n", dbTable->DS.StructSize);
	Printf ("Number of columns (fields per record): %ld\n", dbTable->DS.NumColumns);
	Printf ("Number of records:                     %ld\n", dbTable->DS.NumRows);
	Printf ("Total number of records:               %ld\n", dbTable->NumRecords);
	Printf ("Flags:          ");
	if (dbTable->DS.Flags & DSF_DBTABLE) Printf ("DSF_DBTABLE ");
	if (dbTable->DS.Flags & DSF_HASMEMO) Printf ("DSF_HASMEMO ");
	if (dbTable->DS.Flags & DSF_EXCLUSIVE) Printf ("DSF_EXCLUSIVE ");
	if (dbTable->DS.Flags & DSF_REC_DELETED) Printf ("DSF_REC_DELETED ");
	if (dbTable->DS.Flags & DSF_REC_CACHED) Printf ("DSF_REC_CACHED ");
	if (dbTable->DS.Flags & DSF_MEMO_READ) Printf ("DSF_MEMO_READ ");
	if (dbTable->DS.Flags & DSF_MEMO_CHANGED) Printf ("DSF_MEMO_CHANGED ");
	if (dbTable->DS.Flags & DSF_SHOW_DELETED) Printf ("DSF_SHOW_DELETED ");
	if (dbTable->DS.Flags & DSF_FORCE_UNIQUE) Printf ("DSF_FORCE_UNIQUE ");
	if (dbTable->DS.Flags & DSF_READONLY) Printf ("DSF_READONLY ");
	if (dbTable->DS.Flags & DSF_ROWCHANGED) Printf ("DSF_ROWCHANGED ");
	if (dbTable->DS.Flags & DSF_SOFTSEEK) Printf ("DSF_SOFTSEEK ");
	if (dbTable->DS.Flags & DSF_DESCEND) Printf ("DSF_DESCEND ");
	if (dbTable->DS.Flags & DSF_NEWROW) Printf ("DSF_NEWROW ");
	Printf ("\n");
	Printf ("Locking mode:   ");
	if (dbTable->DS.Flags & DSF_LOCK_NONE) Printf ("DSF_LOCK_NONE\n");
	else if (dbTable->DS.Flags & DSF_LOCK_OPTIMISTIC) Printf ("DSF_LOCK_OPTIMISTIC\n");
	else Printf ("DSF_LOCK_FULL\n");
	Printf ("Current record: %ld\n", dbTable->DS.CurrentRow);
	Printf ("Current column: %ld\n", dbTable->DS.CurrentColumn);

	if (dbTable->DS.Order)
		Printf ("Active index:   %s\n", ((struct IDXHeader *)dbTable->DS.Order)->Link.ln_Name);
	else
		Printf ("No active index\n");

	Printf ("HeaderSize:     %ld\n", dbTable->HeaderSize);
	Printf ("RecordLength:   %ld\n", (ULONG)dbTable->RecordLength);

	Printf ("Orders attached to the DataTable:\n");
	if (dbTable->Orders.lh_Head != (struct Node *)&(dbTable->Orders.lh_Tail))
	{
		struct IDXHeader *ihd;

		dbTable->DS.LastError = DS_ERR_NO_ERROR;
		ihd = (struct IDXHeader *)dbTable->Orders.lh_Head;

		while (ihd != (struct IDXHeader *)&(dbTable->Orders.lh_Tail))
		{
			ULONG keyCount;

			keyCount = IDX_KeyCount (ihd);
			Printf ("%s: Expression = \"%s\", Number of keys = %ld",
							ihd->Link.ln_Name, ihd->Expression, keyCount);	//ihd->NumKeys
			if (ihd->Flags & IDX_CUSTOM) Printf (", custom index\n");
			else Printf ("\n");
			ihd = (struct IDXHeader *)ihd->Link.ln_Succ;
		}
		Printf ("\n");
	}
	else Printf ("None\n\n");
}

/***************************************************************************/
/*																									*/
/*								output-producing functions									*/
/*																									*/
/***************************************************************************/

/* Print an error-message according to the 'LastError' set in the DataServer...
 */
void PrintDBError (struct DataServer *server)
{
	Printf ("SERVER ERROR: ");
	switch (server->LastError)
	{
		case DS_ERR_NO_ERROR:
			Printf ("No error.\n");
			break;
		case DS_ERR_NO_MEMORY:
			Printf ("Not enough free memory.\n");
			break;
		case DS_ERR_NO_MORE_DATA:
			Printf ("No more data.\n");
			break;
		case DS_ERR_OP_NOT_KNOWN:
			Printf ("Operation not known/supported.\n");
			break;
		case DS_ERR_WRONG_ARG:
			Printf ("Wrong (or no) argument passed to DS_DoUpdate().\n");
			break;
		case DS_ERR_MAYOR:
			Printf ("Unexpected mayor failure.\n");
			break;
		case DS_ERR_MINOR:
			Printf ("Unexpected minor failure.\n");
			break;
		case DS_ERR_WRITE_PROTECT:
			Printf ("Column/server is write-protected.\n");
			break;
		case IDX_ERR_DUPLICATE_KEY:
			Printf ("Duplicate key in index.\n");
			break;
		case IDX_ERR_NO_KEY:
			Printf ("Specified key is not existing.\n");
			break;
		case IDX_ERR_BAD_EXPRESSION:
			Printf ("Key-expression is not valid.\n");
			break;
		case DBF_ERR_DUPLICATE_NAME:
			Printf ("The 'Name' of the index or column is already in use.\n");
			break;
		case DBF_ERR_LOCK_TIMEOUT:
			Printf ("Timeout while locking a record.\n");
			break;
		case DBF_ERR_LOCK_FAILURE:
			Printf ("Failed to lock a record.\n");
			break;
		case DBF_ERR_INDEX_TIMEOUT:
			Printf ("Timeout while locking an index.\n");
			break;
		case DBF_ERR_INDEX_LOCK:
			Printf ("Failed to lock an index for change.\n");
			break;
		case DBF_ERR_REC_NOT_LOCKED:
			Printf ("Record to be unlocked is not locked.\n");
			break;
		case DBF_ERR_REC_NOT_VALID:
			Printf ("The requested record is deleted.\n");
			break;
		case DBF_ERR_NO_INDEX:
			Printf ("Required (active) index not found.\n");
			break;
		case DBF_ERR_REC_CHANGED:
			Printf ("Failed to confirm changes, the record has been changed by another instance.\n");
			break;
		case DBF_ERR_RELATED_SERVER:
			Printf ("Failed during accessing a related server.\n");
			break;
		case DBF_ERR_RELATION_LOOP:
			Printf ("Failed to establish a relation: Loop detected.\n");
			break;
	}
}

/* This function prints the structure of the records of the DataTable...
 */
void PrintDBStruct (struct DataServer *server)
{
	if (DS_DoUpdate (server, DS_GOTOCOLUMN, (APTR)1))
	{
		struct DataColumn *column;
		BOOL success;
		ULONG i = 1;

		if (success = DS_DoUpdate (server, DS_CURRENTCOLUMN, (APTR)&column))
		{
			UWORD *offset;

			if (server->Flags & DSF_DBTABLE)
				offset = ((struct DataTable *)server)->Offsets;
			else
				offset = NULL;

			while (success && column)
			{
				Printf ("Column %ld, \"%s\":\n", i++, column->Name);
				if (column->Caption || column->HelpText)
				{
					if (column->Caption)
					{
						Printf ("   Caption = \"%s\"", column->Caption);
						if (column->HelpText) Printf (", ");
						else Printf ("\n");
					}
					else Printf ("   ");

					if (column->HelpText)
						Printf ("HelpText = \"%s\"\n", column->HelpText);
				}
				Printf ("   Flags = ");

				if (column->Flags & DCF_READONLY) Printf ("DCF_READONLY ");
				if (column->Flags & DCF_AUTOVALUE) Printf ("DCF_AUTOVALUE ");
				if (column->Flags & DCF_OWNBUFFER) Printf ("DCF_OWNBUFFER ");
				if (column->Flags & DCF_HIDDEN) Printf ("DCF_HIDDEN ");
				if (column->Flags & DCF_NOT_EMPTY) Printf ("DCF_NOT_EMPTY");

				Printf ("\n   Type = ");
				switch (column->Type)
				{
					case DC_BYTE:
						Printf ("DC_BYTE\n");
						break;
					case DC_WORD:
						Printf ("DC_WORD\n");
						break;
					case DC_LONG:
						Printf ("DC_LONG\n");
						break;
					case DC_DOUBLELONG:
						Printf ("DC_DOUBLELONG\n");
						break;
					case DC_FLOAT:
						Printf ("DC_FLOAT\n");
						break;
					case DC_DOUBLE:
						Printf ("DC_DOUBLE\n");
						break;
					case DC_NUMERIC:
						Printf ("DC_NUMERIC\n");
						break;
					case DC_DATE:
						Printf ("DC_DATE\n");
						break;
					case DC_TIME:
						Printf ("DC_TIME\n");
						break;
					case DC_LOGIC:
						Printf ("DC_LOGIC\n");
						break;
					case DC_CHAR:
						Printf ("DC_CHAR\n");
						break;
					case DC_TEXT:
						Printf ("DC_TEXT\n");
						break;
					case DC_VARCHAR:
						Printf ("DC_VARCHAR\n");
						break;
					default:
						Printf ("DC_UNKNOWN\n");
						break;
				}
				Printf ("   Length = %ld\n", column->Length);
				if (column->Decimals)
					Printf ("   Decimals = %ld\n", column->Decimals);
				if (offset)
					Printf ("   Offset = %ld\n\n", (ULONG)*offset++);
				else Printf ("\n");
				success = DS_DoUpdate (server, DS_NEXTCOLUMN, (APTR)&column);
			}
		}
		if (server->LastError != DS_ERR_NO_MORE_DATA)
			PrintDBError (server);
	}
}

/* Print the current record of the DBServer...
 * Needs to be reworked to perform only a single I/O instead of dozens.
 */
BOOL PrintRecord (struct DataServer *server, UWORD *columnWidth)
{
	BOOL success;

	if (success = DS_DoUpdate (server, DS_GOTOCOLUMN, (APTR)1))
	{
		struct DataColumn *dc;

		if (success = DS_DoUpdate (server, DS_CURRENTCOLUMN, (APTR)&dc))
		{
			UWORD *p = columnWidth;
			struct DataColumn *dcMemo = NULL;

			Printf ("%5ld ", server->CurrentRow);

			while (success)
			{
				if ((dc->Type != DC_TEXT) || dcMemo)
				{
					STRPTR value;
					ULONG slen;

					if (success = DS_DoUpdate(server,DS_GETCOLUMNDATA,(APTR)&value))
					{
						slen = strlen (value);
						PutStr (value);
					}
					else if (server->LastError == DBF_ERR_RELATED_SERVER)
					{
						slen = 0;
						success = TRUE;
					}
					if (success)
					{
						if (dc != dcMemo)
						{
							/* pad with spaces (at least one)...
							 */
							do
							{
								Printf (" ");
								slen += 1;
							}
							while (slen < *p);
							p++;
						}
					}
					else
					{
						Printf ("Failed to get data of current column: ");
						PrintDBError (server);
					}
					if (dc == dcMemo) break;
				}
				else dcMemo = dc;

				if (success)
				{
					if (!(success = DS_DoUpdate (server, DS_NEXTCOLUMN, (APTR)&dc)))
					{
						if (server->LastError == DS_ERR_NO_MORE_DATA)
						{
							if (dc = dcMemo)
							{
								success = DS_DoUpdate (server, DS_GOTOCOLUMN,
																(APTR)dcMemo->Position);
							}
						}
						else Printf ("Failed to skip to next column: ");
					}
				}
			}
		}
		else Printf ("Failed to access current column: ");
		if (success) Printf ("\n");
	}
	else Printf ("Failed to position to first column: ");

	if (server->LastError == DS_ERR_NO_MORE_DATA)
	{
		Printf ("\n");
		success = TRUE;
	}

	return success;
}

/* Print every record stored in the DBServer...
 */
BOOL PrintRecords (struct OpenTable *ot, BPTR input, ULONG pageLength)
{
	BOOL success;
	struct DataServer *server;

	server = ot->Server;
	if (success = DS_DoUpdate (server, DS_FIRSTROW, NULL))
	{
		ULONG records = 0;

		PutStr (ot->ColumnCaptions);

		while (success)
		{
			if (success = PrintRecord(server, ot->ColumnWidth))
			{
				if (!(success = DS_DoUpdate (server, DS_NEXTROW, NULL)))
				{
					if (server->LastError == IDX_ERR_NO_KEY)
					{
						/* Missing key is ignored...
						 */
						success = TRUE;
					}
					else if (server->LastError != DS_ERR_NO_MORE_DATA)
						Printf ("Failed to skip to next record: ");
				}

				if (success)
				{
					if ((input != ZERO) && (records == pageLength))
					{
						UBYTE fooBuffer[128];

						records = 0;
						Printf ("Press ENTER to continue (insert any text to abort)...");
						Flush (Output());
						if (Read (Input(), fooBuffer, 128) > 0)
						{
							if (fooBuffer[0] != '\n')
							{
								success = FALSE;
								server->LastError = DS_ERR_NO_MORE_DATA;
							}
						}
					}
					else records += 1;
				}
			}
		}
		if (server->LastError == DS_ERR_NO_MORE_DATA) success = TRUE;
		else  PrintDBError (server);
	}
	else
	{
		Printf ("DS_FIRSTROW failed: ");
		PrintDBError (server);
	}

	return success;
}

/* Print the current record of a server...
 */
__inline BOOL PRINTRECORD (struct OpenTable *ot)
{
	PutStr (ot->ColumnCaptions);
	return PrintRecord (ot->Server, ot->ColumnWidth);
}

/* Evaluate the width of a column...
 */
UWORD ColumnLength (struct DataColumn *dc)
{
	UWORD length;

	switch (dc->Type)
	{
		case DC_TIME:
			length = 12;
			break;
		case DC_DATE:
			length = 11;
			break;
		case DC_BYTE:
			length = 4;
			break;
		case DC_WORD:
			length = 6;
			break;
		case DC_LONG:
			length = 11;
			break;
		case DC_DOUBLELONG:
			length = 21;
			break;
		case DC_FLOAT:
			length = 13;
			break;
		case DC_DOUBLE:
			length = 17;
			break;
		case DC_LOGIC:
			length = 5;
			break;
		case DC_NUMERIC:
			length = dc->Length + 1;
			break;
		default:
			length = dc->Length;
			break;
	}
	return length;
}

/* Create a text with the captions of the columns and an array containing
 * the width of the contents of the columns if printed in human readable form.
 */
BOOL CreateCaptions (struct OpenTable *ot)
{
	BOOL success;
	struct DataServer *server;

	server = ot->Server;

	/* Evaluate the length of the required string-buffer...
	 */
	if (success = DS_DoUpdate (server, DS_GOTOCOLUMN, (APTR)1))
	{
		struct DataColumn *dc;

		if (success = DS_DoUpdate (server, DS_CURRENTCOLUMN, (APTR)&dc))
		{
			struct DataColumn *dcMemo = NULL;
			ULONG length = 8;
			ULONG numColumns = 0;

			while (success && dc)
			{
				ULONG slen;

				numColumns += 1;
				slen = strlen (dc->Caption);

				if ((dc->Type != DC_TEXT) || dcMemo)
				{
					UWORD colLength;

					colLength = ColumnLength (dc);
					if (slen > colLength) length += slen;
					else length += colLength;
				}
				else
				{
					/* This is a memo-field (the first), the length is variable.
					 */
					dcMemo = dc;
					length += slen;
				}
				length += 1;

				success = DS_DoUpdate (server, DS_NEXTCOLUMN, (APTR)&dc);
			}
			if (server->LastError == DS_ERR_NO_MORE_DATA)
			{
				/* Allocate the storage for the captions-text...
				 */
				if (ot->ColumnCaptions = (STRPTR)AllocVector (length + 2, MEMF_PUBLIC))
				{
					/* Allocate the array for the width of the columns...
					 */
					if (ot->ColumnWidth = (UWORD *)
									AllocVector (numColumns * sizeof (UWORD), MEMF_ANY))
					{
						if (success = DS_DoUpdate (server, DS_GOTOCOLUMN, (APTR)1))
						{
							if (success = DS_DoUpdate (server,
															DS_CURRENTCOLUMN, (APTR)&dc))
							{
								UWORD *p = ot->ColumnWidth;
								UBYTE *c = ot->ColumnCaptions;

								strcpy (c, "RecNo ");
								c += 6;
								while (success && dc)
								{
									if (dc != dcMemo)
									{
										UBYTE *name;
										ULONG slen;
										UWORD length;

										/* Add the name of the column to the string...
										 */
										name = dc->Caption;
										slen = 0;

										/* Copy the caption of the column...
										 */
										while (*name)
										{
											slen += 1;
											*c++ = *name++;
										}
										if (dc->Type != DC_TEXT)
										{
											/* pad with spaces...
											 */
											length = ColumnLength (dc);
										}
										else length = slen;

										if (slen > length) *p = slen;
										else
										{
											/* Column is wider than the names text ->
											 * Pad with spaces...
											 */
											*p = length;
											while (slen < length)
											{
												*c++ = ' ';
												slen += 1;
											}
										}
										*c++ = ' ';
										*p++ += 1;
									}
									if (!(success = DS_DoUpdate (server,
																DS_NEXTCOLUMN, (APTR)&dc)))
									{
										/* Last column processed ->
										 * Insert the caption of the memo-field...
										 */
										if (server->LastError == DS_ERR_NO_MORE_DATA)
										{
											if (dc = dcMemo) success = TRUE;
											dcMemo = NULL;
										}
									}
								}
								if (server->LastError == DS_ERR_NO_MORE_DATA)
								{
									*c++ = '\n';
									*c = '\0';
									success = TRUE;
								}
								else PrintDBError (server);
							}
							else PrintDBError (server);
						}
						if (!success)
						{
							FreeVector (ot->ColumnWidth);
							FreeVector (ot->ColumnCaptions);
							ot->ColumnWidth = NULL;
							ot->ColumnCaptions = NULL;
						}
					}
					else
					{
						Printf ("Failed to allocate array for column-width.\n");
						FreeVector (ot->ColumnCaptions);
						ot->ColumnCaptions = NULL;
						success = FALSE;
					}
				}
				else
				{
					Printf ("Failed to allocate buffer for column-captions.\n");
					success = FALSE;
				}
			}
			else PrintDBError (server);
		}
	}	
	return success;
}

/* Change the captions of the DataTable, as the result of a set or cleared
 * relation.
 */
void ChangeCaption (struct OpenTable *ot)
{
	STRPTR caption;
	UWORD *width;

	if (caption = ot->ColumnCaptions) ot->ColumnCaptions = NULL;
	if (width = ot->ColumnWidth) ot->ColumnWidth = NULL;

	if (CreateCaptions (ot))
	{
		/* Free the old no longer used caption and width-array...
		 */
		if (caption) FreeVector (caption);
		if (width) FreeVector (width);
	}
	else
	{
		/* Failed to create a new caption-line (ignore)...
		 */
		ot->ColumnCaptions = caption;
		ot->ColumnWidth = width;
	}
}

/***************************************************************************/
/*																									*/
/*								input-processing functions									*/
/*																									*/
/***************************************************************************/

/* Notify-function called whenever 10 records are indexed by IDX_ReIndex()...
 */
BOOL __saveds __asm ReIndexNotify ( register __a0 struct IDXHeader *ihd,
												register __d0 ULONG recCount,
												register __a1 STRPTR indexName)
{
	Printf ("Added %ld keys to the index %s...\n", recCount, indexName);

	return TRUE;
}

/* Remove a table from the list of open tables...
 */
struct DataServer *RemoveOpenTable (APTR tableEd, STRPTR name)
{
	struct DataServer *removed = NULL;
	struct TableEdit *te = (struct TableEdit *)tableEd;
	struct OpenTable *ot;

	if (ot = (struct OpenTable *)FindName (&(te->Tables), name))
	{
		/* Free the resources...
		 */
		struct StringChain *sc, *next = NULL;

		Remove ((struct Node *)ot);
		if (ot == te->Used) te->Used = NULL;
		removed = ot->Server;

		if (ot->ColumnCaptions) FreeVector (ot->ColumnCaptions);
		if (ot->ColumnWidth) FreeVector (ot->ColumnWidth);
		if (ot->TopScope) FreeVector (ot->TopScope);
		if (ot->BottomScope) FreeVector (ot->BottomScope);
		if (ot->Buffer) FreeVector (ot->Buffer);

		/* Remove the buffered alias-names from the StringChain...
		 */
		sc = ot->StrChain;
		while (sc)
		{
			next = sc->Next;
			FreeVector (sc);
			sc = next;
		}

		FreeMem (ot, sizeof (struct OpenTable));

		if (te->Used == NULL)
		{
			/* The active server is closed, activate another one...
			 */
			ot = (struct OpenTable *)te->Tables.lh_Head;
			if (ot != (struct OpenTable *)&(te->Tables.lh_Tail))
			{
				te->Used = ot;
				Printf ("The active DataTable has been closed.\n"
							"Now the DataTable \"%s\" is activated.\n", te->Used->Server->Name);
			}
		}
	}
	else Printf ("No table with the name \"%s\" is currently open.\n", name);

	return removed;
}

/* Add a new table to the list of open tables...
 */
BOOL AddOpenTable (APTR tableEd, struct DataServer *server)
{
	struct TableEdit *te = (struct TableEdit *)tableEd;
	BOOL success;

	if (success = DS_DoUpdate (server, DS_SOFTSEEK, (APTR)TRUE))
	{
		struct OpenTable *ot;

		if (ot = (struct OpenTable *)AllocMem (sizeof (struct OpenTable), MEMF_ANY | MEMF_CLEAR))
		{
			ot->Server = server;
			ot->Link.ln_Name = server->Name;
			ot->Link.ln_Pri = 0;
			ot->Link.ln_Type = NT_USER;
			if (success = CreateCaptions (ot))
			{
				AddTail (&(te->Tables), (struct Node *)ot);
				if (!te->Used) te->Used = ot;
			}
			else
			{
				success = TRUE;
			}
		}
		else
		{
			success = FALSE;
			PrintError (IoErr(), "Failed to add table to list of open tables");
		}
	}
	else
	{
		Printf ("Failed to enable 'softseek': ");
		PrintDBError (server);
	}
	return success;
}

UBYTE *Token (UBYTE **tState)
{
	UBYTE *token;

	token = *tState;
	if (token && *token)
	{
		UBYTE *nextToken;
		BOOL escaped = FALSE;

		/* Skip leading spaces...
		 */
		while (*token && (*token<= 32)) token++;
		nextToken = token;

		/* Check for quotes...
		 */
		if (*nextToken == '\"')
		{
			/* Search a matching quote...
			 */
			token += 1;
			nextToken += 1;
			while (*nextToken && ((*nextToken != '\"') || escaped))
			{
				if (escaped) escaped = FALSE;
				else if (*nextToken == '*') escaped = TRUE;
				nextToken += 1;
			}

			if (*nextToken) *nextToken++ = '\0';
			else
			{
				Printf ("Failure: Missing quote.\n");
				token = NULL;
			}
		}
		else
		{
			/* Search the next whitespace...
			 */
			while (*nextToken &&
				(((*nextToken != '=') && (*nextToken > 32)) || escaped))
			{
				if (escaped) escaped = FALSE;
				else if (*nextToken == '*') escaped = TRUE;
				nextToken += 1;
			}
			if (*nextToken) *nextToken++ = '\0';
		}
		if (*nextToken) *tState = nextToken;
		else *tState = NULL;	/* EOL */
	}
	if (!*token) token = NULL;

	return token;
}

ULONG Command (UBYTE *cmdLine)
{
	ULONG cmd = 0;

	/* Skip leading spaces...
	 */
	while (*cmdLine && (*cmdLine <= 32)) cmdLine++;

	if (*cmdLine)
	{
		ULONG slen;

		slen = strlen (cmdLine);

		do
		{
			if (strnicmp (cmdLine, commands[cmd], slen) == 0)
			{
				/* Found !
				 */
				break;
			}
			else if (*cmdLine < *commands[cmd])
			{
				/* The commands are ordered alphabetically, so I could stop
				 * searching now...
				 */
				cmdLine = NULL;
				break;
			}
			else cmd += 1;
		}
		while (commands[cmd]);

		if (cmdLine && commands[cmd]) cmd += 1;
		else cmd = 0;
	}
	return cmd;
}

APTR GetKeyValue (struct DataServer *server, UBYTE *cmdLine)
{
	APTR keyValue = NULL;
	STRPTR indexName;

	if (DS_DoUpdate (server, DS_GETORDER, (APTR)&indexName))
	{
		if (indexName)
		{
			struct IDXHeader *idx;

			if (idx = DBF_GetOrder (server, indexName))
			{
				STRPTR *args;
				ULONG maxArgs = 10;

				/* Collect all values the user has added to the commandline...
				 */
				if (args = (STRPTR *)AllocMem (sizeof(STRPTR) * maxArgs, MEMF_ANY))
				{
					ULONG numArgs = 0;
					UBYTE *nextToken = cmdLine;
					STRPTR *arg = args;
					BOOL success = TRUE;

					while (success && (cmdLine = Token (&nextToken)))
					{
						numArgs += 1;
						if (numArgs == maxArgs)
						{
							/* need a larger array for the arguments...
							 */
							STRPTR *newArgs;

							if (newArgs = (STRPTR *)
									AllocMem (sizeof (STRPTR) * 2 * maxArgs, MEMF_ANY))
							{
								STRPTR *ptr = args;
								ULONG i;

								/* copy all already read values into the new array...
								 */
								arg = newArgs;
								for (i = 1; i < numArgs; i++) *arg++ = *ptr++;
								if (args) FreeMem (args, sizeof (STRPTR) * maxArgs);
								maxArgs <<= 1;
							}
							else
							{
								success = FALSE;
								Printf ("Not enough free memory.\n");
							}
						}
						if (success) *arg++ = cmdLine;
					}
					if (success)
					{
						if (success = IDX_EvalExpressionB (server, idx->PreParsedExpr,
															idx->CurrentKey->KeyValue,args))
						{
							keyValue = (APTR)idx->CurrentKey->KeyValue;
						}
						else
						{
							Printf ("Failed to evaluate key-expression: ");
							PrintDBError(server);
						}
					}
					FreeMem (args, sizeof (STRPTR) * maxArgs);
				}
				else Printf ("Not enough free memory.\n");
			}
		}
		else Printf ("Server has no active index.\n");
	}
	else
	{
		Printf ("Failed to access the current order: ");
		PrintDBError (server);
	}
	return keyValue;
}

BOOL PerformSeek (struct OpenTable *ot, UBYTE *cmdLine)
{
	BOOL found = FALSE;
	struct DataServer *server;
	APTR keyValue;

	server = ot->Server;
	if (keyValue = GetKeyValue (server, cmdLine))
	{
		if (found = DS_DoUpdate (server, DS_SEEK, keyValue))
		{
			PRINTRECORD (ot);
		}
		else
		{
			Printf ("Failed to locate a record "
						"according to the specified key-value: ");
			PrintDBError(server);
			found = FALSE;
		}
	}
	return found;
}

/* Read the contents of a column from user-input...
 */
BOOL ChangeColumn (struct DataServer *server, ULONG numCol,
												UBYTE *buffer, BPTR input, BPTR macro)
{
	BOOL success;

	if (success = DS_DoUpdate (server, DS_GOTOCOLUMN, (APTR)numCol))
	{
		struct DataColumn *dc;

		if (success = DS_DoUpdate (server, DS_CURRENTCOLUMN, (APTR)&dc))
		{
			if ((dc->Server == server) && !(dc->Flags & DCF_READONLY))
			{
				/* Only change a column if it is allowed...
				 */
				STRPTR value;

				if (success = DS_DoUpdate (server, DS_GETCOLUMNDATA, (APTR)&value))
				{
					LONG bytesRead = 0;

					Printf ("Please enter a new value for the column \"%s\""
								" (current value = \"%s\") terminated by RETURN:\n",
																	dc->Caption, value);
					if (input != ZERO)
					{
						if (FGets (input, buffer, 511))
						{
							bytesRead = strlen (buffer);
							if (bytesRead > 0) Write(Output(), buffer, bytesRead);
						}
					}
					else bytesRead = Read (Input(), buffer, 511);

					if (bytesRead > 0)
					{
						if (macro != ZERO) Write (macro, buffer, bytesRead);

						if (buffer[0] != '\n')
						{
							if (buffer[bytesRead-1] == '\n') buffer[bytesRead-1] = '\0';
							else buffer[bytesRead] = '\0';

							if (!(success =
									DS_DoUpdate (server, DS_SETCOLUMNDATA, (APTR)buffer)))
							{
								Printf ("Failed to store \"%s\" into the column : ",
																						buffer);
								PrintDBError (server);
							}
						}
					}
					else
					{
						success = FALSE;
						Printf ("Failed to read the input.\n");
						server->LastError = DS_ERR_MAYOR;
					}
				}
				else
				{
					Printf ("Failed to get the current contents of the column: ");
					PrintDBError (server);
				}
			}
		}
		else
		{
			Printf ("Failed to access the column %ld: ", numCol);
			PrintDBError (server);
		}
	}
	else
	{
		Printf ("Failed to go to the column %ld: ", numCol);
		PrintDBError (server);
	}
	return success;
}

BOOL ChangeRecord (struct DataServer *server, UBYTE *cmdLine,
													UBYTE *buffer, BPTR input, BPTR macro)
{
	BOOL success = TRUE;
	BOOL interactive = FALSE;

	if (cmdLine)
	{
		/* The user has entered the values into the commandline...
		 */
		UBYTE *nextToken = cmdLine;

		while (success && (cmdLine = Token (&nextToken)))
		{
			if (success = DS_DoUpdate (server, DS_FINDCOLUMN, (APTR)cmdLine))
			{
				UBYTE *column = cmdLine;

				cmdLine = Token (&nextToken);
				success = DS_DoUpdate (server, DS_SETCOLUMNDATA, (APTR)cmdLine);

				if (!success)
				{
					if (cmdLine)
					{
						Printf ("Failed to store \"%s\" in the column %s: ",
																			cmdLine, column);
					}
					else Printf ("Failed to clear the column %s: ", column);
					PrintDBError (server);
				}
			}
			else Printf ("No column named \"%s\" found. ", cmdLine);

			if (!success)
			{
				Printf ("Switching to interactive mode.\n");
				interactive = TRUE;
				success = TRUE;
			}
		}
	}
	else interactive = TRUE;

	if (interactive)
	{
		/* Let the user enter the values in a dialog...
		 */
		ULONG i = 2;

		Printf ("You are asked to enter the new values for every column,  if\n"
					"you don't want to change a value, just press RETURN,  if you\n"
					"wish  to clear  a string-value,  enter a  blank  followed by\n"
					"a RETURN.\n");
		while (success && (i <= server->NumColumns))
			success = ChangeColumn (server, i++, buffer, input, macro);
	}

	if (success)
	{
		/* Now confirm the changes...
		 */
		BOOL retry;

		do
		{
			retry = FALSE;
			if (success = DS_DoUpdate (server, DS_UPDATE, NULL))
			{
				if (server->LastError == IDX_ERR_DUPLICATE_KEY)
				{
					Printf ("The key to this record could not be added to one (or "
								"more) of the indexes, because that index is defined "
								"to have unique keys and there is already a key with "
								"the same value referencing another record.\n"
								"If you ignore this error, the record is not visible "
								"in every index, so you should change the record so "
								"it matches the key-condition.\n");
				}
			}
			else
			{
				if (server->LastError == DBF_ERR_REC_NOT_VALID)
				{
					struct DataColumn *dc;

					if (DS_DoUpdate (server, DS_CURRENTCOLUMN, (APTR)&dc))
					{
						Printf ("The contents of the column \"%s\" is not valid -> Try again.\n", dc->Name);
						retry = ChangeColumn (server, dc->Position, buffer, input, macro);
					}
					else
					{
						Printf ("Failed to validate the changes.\n");
					}
				}
				else
				{
					if (IoErr()) PrintError (IoErr(), "Failed to confirm the changes");
					else Printf ("Failed to confirm the changes: ");
					PrintDBError (server);
					Printf ("Try it again ? (Y/N): ");
					Flush (Output());
					buffer[0] = '\0';
					Read (Input(), buffer, 511);

					if ((buffer[0] & 0xDF) == 'Y') retry = TRUE;
				}
			}
		}
		while (retry);
	}
	return success;
}

/* Change the 'TopScope' and 'BottomScope' according to the
 * scope of the currently active index...
 */
BOOL BufferScopeKeys (struct OpenTable *ot)
{
	BOOL success = TRUE;
	struct DataServer *server = ot->Server;
	STRPTR order;

	/* Clear the currently set scope...
	 */
	if (ot->TopScope)
	{
		FreeVector (ot->TopScope);
		ot->TopScope = NULL;
	}
	if (ot->BottomScope)
	{
		FreeVector (ot->BottomScope);
		ot->BottomScope = NULL;
	}
	if (success = DS_DoUpdate (server, DS_GETORDER, (APTR)&order))
	{
		if (order)
		{
			/* Set the scope so it match the orders active scope...
			 */
			struct IDXHeader *idx;

			if (idx = DBF_GetOrder (server, order))
			{
				if (idx->TopScope)
				{
					if (ot->TopScope = (UBYTE *) AllocVector (idx->KeyLen, MEMF_ANY))
					{
						CopyMem (idx->TopScope, ot->TopScope, idx->KeyLen);
					}
					else
					{
						success = FALSE;
						Printf ("Failed to allocate memory for the top scope.\n");
					}
				}
				if (idx->BottomScope)
				{
					if (ot->BottomScope = (UBYTE *) AllocVector (idx->KeyLen, MEMF_ANY))
					{
						CopyMem(idx->BottomScope, ot->BottomScope, idx->KeyLen);
					}
					else
					{
						success = FALSE;
						Printf ("Failed to allocate memory for the bottom scope.\n");
					}
				}
			}
			else
			{
				success = FALSE;
				Printf ("Failed to access the index \"%s\".\n", order);
			}
		}
	}
	else
	{
		Printf ("Failed to access the index \"%s\": ", order);
		PrintDBError (server);
		success = FALSE;
	}
	return success;
}

BOOL ParseInput (struct TableEdit *te, UBYTE *cmdLine, BPTR *input, BPTR *macro)
{
	BOOL quit = FALSE;
	struct OpenTable *ot;
	struct DataServer *server;
	UBYTE *nextToken = cmdLine;
	UBYTE *buffer = cmdLine;
	ULONG cmd;

	ot = te->Used;
	server = ot->Server;

	cmdLine = Token (&nextToken);
	if (cmd = Command (cmdLine))
	{
		switch (cmd)
		{
			case CMD_ALIAS:
				if (cmdLine = Token (&nextToken))
				{
					STRPTR alias;

					alias = cmdLine;

					if (cmdLine = Token (&nextToken))
					{
						/* Try to add a new alias to the server...
						 */
						struct StringChain *sc;
						LONG slen;

						slen = strlen (alias) + 1;
						if (sc = (struct StringChain *)
							AllocVector (sizeof(struct StringChain) + slen, MEMF_ANY))
						{
							strcpy (sc->String, alias);

							if (DBF_AddAlias (server, sc->String, cmdLine))
							{
								Printf ("Successfully established the alias \"%s\" for the index \"%s\"\n",
																									sc->String, cmdLine);
								/* Add the buffered alias-name to the StringChain...
								 */
								sc->Next = ot->StrChain;
								ot->StrChain = sc;
							}
							else
							{
								Printf ("Failed to establish the alias \"%s\": ", sc->String);
								PrintDBError(server);
								FreeVector (sc);
							}
						}
						else
						{
							PrintError (IoErr(), "Failed to store alias name");
						}
					}
					else
					{
						/* Remove the alias again...
						 */
						if (DBF_RemoveAlias (server, alias))
						{
							struct StringChain *sc, *prev = NULL;

							Printf ("Successfully removed the alias \"%s\"\n", alias);

							/* Remove the buffered alias-name from the StringChain...
							 */
							sc = ot->StrChain;
							while (sc && strcmp (sc->String, alias))
							{
								prev = sc;
								sc = sc->Next;
							}
							if (sc)
							{
								if (prev) prev->Next = sc->Next;
								else ot->StrChain = sc->Next;
								FreeVector (sc);
							}
						}
						else
						{
							Printf ("Failed to remove the alias \"%s\": ", alias);
							PrintDBError(server);						
						}
					}
				}
				else Printf ("You have to specify the name of the alias.\n");
				break;
			case CMD_ORDER_ASCEND:
				if (!DS_DoUpdate (server, DS_ORDERASCEND, (APTR)TRUE))
				{
					Printf ("Failed to change to ascend orderdirection: ");
					PrintDBError(server);
				}
				break;
			case CMD_AVAIL_ORDER:
				/* Show all available orders (indexes)...
				 */
				{
					STRPTR *orders;

					if (DS_DoUpdate (server, DS_AVAILABLEORDER, (APTR)&orders))
					{
						struct IDXHeader *index;

						Printf ("Orders available for this DataTable and their key-expression:\n");
						while (*orders)
						{
							/* If the following operation fails, the list of indexes
							 * of the DataTable is broken, which could only be the
							 * result of a bad application-developer who is "poking"
							 * into the fields of the DataTable by bypassing the
							 * according functions (without knowing what he is doing).
							 */
							if (index = DBF_GetOrder (server, *orders))
							{
								Printf ("\"%s\" = \"%s\"",*orders,index->Expression);
								if (index->Flags & IDX_UNIQUE)
									Printf (", keys are unique\n");
								else
									Printf ("\n");
							}
							orders += 1;
						}
					}
				}
				break;
			case CMD_SKIP_BOTTOM:
				if (DS_DoUpdate (server, DS_LASTROW, NULL)
					|| (server->LastError == IDX_ERR_NO_KEY))
				{
					BOOL noKey = FALSE;
					BOOL dupKey = FALSE;

					if (server->LastError == IDX_ERR_NO_KEY) noKey = TRUE;
					if (server->LastError == IDX_ERR_DUPLICATE_KEY) dupKey = TRUE;
					PRINTRECORD (ot);
					if (noKey)
					{
						Printf ("At least one index doesn't "
									"contain a keyvalue for this record.\n");
					}
					if (dupKey)
					{
						Printf ("One of the indexes with unique keys cannot "
									"access this record, because there is another "
									"record with the same keyvalue.\n");
					}
				}
				else
				{
					Printf ("Failed to skip to the last record: ");
					PrintDBError (server);
				}
				break;
			case CMD_SET_BOTTOM_SCOPE:
				/* Set the bottom scope (without affecting the top scope)...
				 */
				{
					STRPTR order;

					if (DS_DoUpdate (server, DS_GETORDER, (APTR)&order))
					{
						struct IDXHeader *idx;

						if (idx = DBF_GetOrder (server, order))
						{
							APTR keyValue = NULL;

							if (!nextToken ||
								(keyValue = GetKeyValue (server, nextToken)))
							{
								if (IDX_SetScope (idx, ot->TopScope, keyValue))
								{
									Printf ("Successfully changed the bottom scope.\n");
									if (keyValue)
									{
										if (!ot->BottomScope)
										{
											ot->BottomScope = (UBYTE *)
														AllocVector (idx->KeyLen, MEMF_ANY);
										}
										if (ot->BottomScope)
										{
											CopyMem(keyValue, ot->BottomScope, idx->KeyLen);
										}
										else Printf ("Failed to allocate a buffer "
														"for the bottom scope-value.\n");
									}
									else if (ot->BottomScope)
									{
										FreeVector (ot->BottomScope);
										ot->BottomScope = NULL;
									}

								}
								else
								{
									Printf ("Failed to set the bottom scope-value: ");
									if (IoErr() == ERROR_NO_FREE_STORE)
										Printf ("Not enougth free memory available.\n");
									else if (ot->TopScope)
										Printf ("Bottom scope-value ordered before "
																	"top scope-value ?\n");
									else
										Printf ("Maybe the index is corrupt.\n");
								}
							}
						}
						else Printf ("No active order -> No scope possible.\n");
					}
					else
					{
						Printf ("Failed to get the name of the current index: ");
						PrintDBError (server);
					}
				}
				break;
			case CMD_CLEAR_RELATION:
				if (cmdLine = Token (&nextToken))
				{
					struct OpenTable *ct;

					if (ct = (struct OpenTable *)FindName (&(te->Tables), cmdLine))
					{
						if (DBF_ClearRelation (ct->Server))
						{
							Printf ("Successfully cleared the relation.\n");
							FreeVector (ct->Buffer);
							ct->Buffer = NULL;
							ChangeCaption (ot);
						}
						else
						{
							Printf ("Failed to clear the relation: ");
							PrintDBError (ct->Server);
							Printf ("Superior table failure: ");
							PrintDBError (server);
						}
					}
					else Printf ("No table with the name \"%s\" is currently open.\n", cmdLine);
				}
				else Printf("Enter the name of the client table behind the keyword\n");
				break;
			case CMD_CLOSE:
				if (cmdLine = Token (&nextToken))
				{
					BOOL close = TRUE;
					if (*input == ZERO)
					{
						/* Count the number of entries in the list...
						 */
						if (CountNodes(&(te->Tables)) == 1)
						{
							UBYTE confirm[16];

							LONG charsRead;

							Printf("You are about  to close  the last open DataServer.  If you\n"
									"close this DataServer, the application will be terminated.\n"
									"Are you\n to do this ? (Y/N): ");
							Flush (Output());
							confirm[0] = '\0';
							charsRead = Read (Input(), confirm, 16);

							if ((confirm[0] & 0xDF) == 'Y') quit = TRUE;
							else close = FALSE;
						}
					}
					if (close)
					{
						struct DataServer *server;

						if (server = RemoveOpenTable ((APTR)te, cmdLine))
							DS_DoUpdate (server, DS_DISPOSE, NULL);
						else quit = FALSE;
					}
				}
				else Printf("Enter the name of the table behind the keyword\n");
				break;
			case CMD_CLOSEINDEX:
				if (cmdLine = Token (&nextToken))
				{
					struct IDXHeader *ihd;

					if (ihd = DBF_RemoveOrder (server, cmdLine))
					{
						IDX_Dispose (ihd);
						Printf ("Index successfully closed.\n");
					}
					else Printf ("No index with the name \"%s\" is currently open.\n");
				}
				else Printf("Enter the name of the index behind the keyword\n");
				break;
			case CMD_CURRENT_ORDER:
				if (DS_DoUpdate (server, DS_GETORDER, (APTR)&nextToken))
				{
					UBYTE *expression;

					if (DS_DoUpdate (server, DS_KEYEXPRESSION, (APTR)&expression))
					{
						ULONG keyLen;

						if (DS_DoUpdate (server, DS_KEYLENGTH, (APTR)&keyLen))
						{
							Printf ("The current index is named: \"%s\" and has the "
									"key-expression \"%s\", a key is %ld bytes long.\n",
																nextToken, expression, keyLen);
						}
						else
						{
							Printf ("Failed to evaluate the length of a keyvalue"
																	"of the current index: ");
							PrintDBError (server);
						}
					}
					else
					{
						Printf ("Failed to get the key-expression "
													"of the current index: ");
						PrintDBError (server);
					}
				}
				else
				{
					Printf ("Failed to get the name of the current index: ");
					PrintDBError (server);
				}
				break;
			case CMD_DEBUG:
				/* Print debug information about active server...
				 */
				if (server->Flags & DSF_DBTABLE)
				{
					PrintDBHeader ((struct DataTable *)server);
				}
				else Printf ("No debug-infomation available for this DataServer.\n");
				break;
			case CMD_DELETE:
				{
					LONG toDelete = 0;

					if (cmdLine = Token (&nextToken))
					{
						LONG charsRead;

						if (((charsRead = Str2Long (cmdLine, &toDelete)) <= 0) ||
							(*(cmdLine + charsRead - 1) < '0') ||
							(*(cmdLine + charsRead - 1) > '9'))
						{
							/* Bad number...
							 */
							toDelete = 0;
							Printf ("Bad number: The \"delete\" command has to be "
										"followed by a valid number.\n");
						}
						else
						{
							/* Skip to the specified record...
							 */
							if (DS_DoUpdate (server, DS_GOTOROW, (APTR)toDelete) ||
								(server->LastError == IDX_ERR_NO_KEY))
							{
								if (!PRINTRECORD (ot)) toDelete = 0;
							}
							else
							{
								toDelete = 0;
								Printf ("Failed to skip to record %ld: ", toDelete);
								PrintDBError (server);
							}
						}
					}
					else if (!DS_DoUpdate (server, DS_CURRENTROW, (APTR)&toDelete))
					{
						Printf ("Failed to access the current record: ");
						PrintDBError (server);
					}
					if (toDelete)
					{
						if (*input == ZERO)
						{
							LONG charsRead;

							Printf ("Should this record be deleted ? (Y/N): ");
							Flush (Output());
							buffer[0] = '\0';
							charsRead = Read (Input(), buffer, 511);
						}
						else buffer[0] = 'Y';

						if ((buffer[0] & 0xDF) == 'Y')
						{
							if (DS_DoUpdate (server, DS_REMOVEROW, NULL))
							{
								if (DS_DoUpdate (server, DS_UPDATE, NULL))
								{
									Printf ("The record is removed.\n");
								}
								else
								{
									Printf ("Failed to confirm the changes: ");
									PrintDBError (server);
								}
							}
							else
							{
								Printf ("Failed to remove the record: ");
								PrintDBError (server);
							}
						}
					}
				}
				break;
			case CMD_ORDER_DESCEND:
				if (!DS_DoUpdate (server, DS_ORDERASCEND, (APTR)FALSE))
				{
					Printf ("Failed to change to descend orderdirection: ");
					PrintDBError(server);
				}
				break;
			case CMD_EDIT:
				{
					BOOL success = TRUE;

					if (*nextToken)
					{
						LONG toChange = 0;
						LONG charsRead;

						if (((charsRead = Str2Long (nextToken, &toChange)) > 0) &&
							(*(nextToken + charsRead - 1) >= '0') &&
							(*(nextToken + charsRead - 1) <= '9'))
						{
							/* Use the specified record instead of the current one...
							 */
							if (!DS_DoUpdate (server, DS_GOTOROW, (APTR)toChange) &&
								(server->LastError != IDX_ERR_NO_KEY))
							{
								success = FALSE;
								Printf ("Failed to skip to record %ld: ", toChange);
								PrintDBError (server);
							}
							else Token (&nextToken); /* skip the recordnumber */
						}
					}
					else if (server->CurrentRow == 0)
					{
						Printf ("Currently no  record  active,  so you  have to  specify the\n"
									"recordnumber behind the command.\n");
						success = FALSE;
					}
					if (success)
					{
						if (ChangeRecord (server, nextToken, buffer, *input, *macro))
						{
							Printf ("New contents of the record:\n");
							PRINTRECORD (ot);
						}
					}
				}
				break;
			case CMD_EXPRESSION:
				/* Get the expression of the current index
				 * (This command cannot fail)...
				 */
				DS_DoUpdate (server, DS_GETORDER, (APTR)&nextToken);
				if (nextToken)
				{
					struct IDXHeader *index;

					if (index = DBF_GetOrder (server, nextToken))
							Printf ("%s\n", index->Expression);
				}
				else Printf ("Server has no active index.\n");
				break;
			case CMD_FIELDGET:
				if (cmdLine = Token (&nextToken))
				{
					if (DS_DoUpdate (server, DS_FINDCOLUMN, (APTR)cmdLine))
					{
						struct DataColumn *dc;

						if (DS_DoUpdate (server, DS_CURRENTCOLUMN, (APTR)&dc))
						{
							STRPTR value;

							if (DS_DoUpdate (server, DS_GETCOLUMNDATA,(APTR)&value))
							{
								Printf ("%s:%s = %s\n", dc->Server->Name, dc->Name, value);
							}
							else
							{
								Printf ("Failed to get the data of the column %s: ", dc->Name);
								PrintDBError(server);
							}
						}
						else
						{
							Printf ("Failed to get access to the column %s: ", cmdLine);
							PrintDBError(server);
						}
					}
					else
					{
						Printf ("Failed to locate the column \"%s\": ", cmdLine);
						PrintDBError (server);
					}
				}
				else Printf ("You have to specify the columns name behind the command.\n");
				break;
			case CMD_GOTO:
				{
					LONG recNo;
					LONG charsRead;

					if ((cmdLine = Token (&nextToken)) &&
						(charsRead = Str2Long (cmdLine, &recNo)) &&
						(*(cmdLine + charsRead - 1) >= '0') &&
						(*(cmdLine + charsRead - 1) <= '9'))
					{
						if (DS_DoUpdate (server, DS_GOTOROW, (APTR)recNo) ||
							(server->LastError == IDX_ERR_NO_KEY))
						{
							BOOL noKey = FALSE;
							BOOL dupKey = FALSE;

							if (server->LastError == IDX_ERR_NO_KEY)
								noKey = TRUE;
							if (server->LastError == IDX_ERR_DUPLICATE_KEY)
								dupKey = TRUE;
							PRINTRECORD (ot);
							if (noKey)
							{
								Printf ("At least one index doesn't "
											"contain a keyvalue for this record.\n");
							}
							if (dupKey)
							{
								Printf ("One of the indexes with unique keys cannot "
										"access this record, because there is another "
										"record with the same keyvalue.\n");
							}
						}
						else
						{
							Printf ("Failed to skip to record %ld: ", recNo);
							PrintDBError (server);
						}
					}
					else Printf ("Enter the number of the destination record "
											"behind he keyword, e.g. \"Goto 3\"\n");
				}
				break;
			case CMD_HELP:
				/* Get help about the supported commands...
				 */
				if (cmdLine = Token (&nextToken))
				{
					if (!(cmd = Command (cmdLine)))
					{
						Printf ("No help about \"%s\" available.\n", cmdLine);
						cmdLine = NULL;
					}
				}
				if (!cmdLine)
				{
					int i = 0;

					Printf ("Supported commands:\n");
					while (commands[i])
					{
						Printf ("   %s\n", commands[i++]);

						if ((input != ZERO) && ((i % te->PageLength) == 0))
						{
							Printf ("Press ENTER to continue...");
							Flush (Output());
							Read (Input(), buffer, 511);
						}
					}
				}
				else
				{
					Printf ("%s\n", commands[cmd - 1]);
					PutStr (helpText[cmd - 1]);
				}
				break;
			case CMD_LIST:
				/* Print the whole contents of this DataTable...
				 */
				if (*macro || *input)
					PrintRecords (te->Used, FALSE, te->PageLength);
				else
					PrintRecords (te->Used, TRUE, te->PageLength);
				break;
			case CMD_LOCK_RECORD:
				/* Try to lock the current record...
				 */
				{
					ULONG recNo;

					if (DS_DoUpdate (server, DS_CURRENTROW, (APTR)&recNo))
					{
						ULONG mode = DBF_READ;

						if ((cmdLine = Token (&nextToken)) &&
							(strnicmp ("exclusive", cmdLine, strlen (cmdLine)) == 0))
						{
							/* Lock exclusive...
							 */
							mode = DBF_WRITE;
						}
						if (DBF_LockRecord (server, recNo, mode, 5000)) //DBF_WAIT_DEFAULT))
						{
							Printf ("Successfully locked current record.\n");
						}
						else
						{
							Printf ("Failed to lock record %ld: ",recNo);
							PrintDBError (server);
						}
					}
					else
					{
						Printf ("Failed to access current record: ");
						PrintDBError (server);
					}
				}
				break;
			case CMD_LOCK_INDEX:
				/* Try to lock an index...
				 */
				{
					struct IDXHeader *ihd;
					LONG accessType = IDX_READ;

					cmdLine = Token (&nextToken);
					if ((ihd = DBF_GetOrder (server, cmdLine)) == NULL)
					{
						/* Maybe the keyword "exclusive" specified ?
						 */
						if (cmdLine)
						{
							if (strnicmp ("exclusive", cmdLine, strlen (cmdLine)) == 0)
							{
								accessType = IDX_WRITE;
								if ((ihd = DBF_GetOrder (server, NULL)) == NULL)
									Printf ("Currently no order active, specify the name of the order.\n");
							}
							else Printf ("No order with the name \"%s\" attached to the active table.\n", cmdLine);
						}
						else Printf ("Currently no order active, specify the name of the order.\n");
					}
					if (ihd)
					{
						LONG error = 0;

						if (cmdLine && (accessType == IDX_READ))
						{
							/* Maybe the keyword "exclusive" specified ?
							 */
							if (cmdLine = Token (&nextToken))
							{
								if (strnicmp ("exclusive", cmdLine, strlen (cmdLine)) == 0)
									accessType = IDX_WRITE;
								else
									Printf ("What purpose should the argument \"%s\" be good for ?\n", cmdLine);
							}
						}
						if (IDX_StartTransaction (ihd, accessType))
						{
							Printf ("Successfully locked");
						}
						else
						{
							error = IoErr();
							Printf ("Failed to lock");
						}
						Printf (" the index \"%s\" for %s access.\n",
									ihd->Link.ln_Name, (accessType == IDX_READ) ? "read" : "write");
						if (error) PrintError (error, "AmigaDos error");
					}
				}
				break;
			case CMD_LOCK_MEMO:
				/* Try to lock a memo-file...
				 */
				if (server->Flags & DSF_HASMEMO)
				{
					if (!DBM_LockMemo ((struct MemoFile *)server->Rows))
					{
						PrintError (IoErr(), "Failed to lock memo-file");
					}
					else Printf ("Successfully locked the memo-file.\n");
				}
				else Printf ("The currently active server doesn't owns a memo-file.\n");
				break;
			case CMD_LOCK_MODE:
				Printf ("Current locking mode:   ");
				if (server->Flags & DSF_LOCK_NONE)
					Printf ("DSF_LOCK_NONE\n");
				else if (server->Flags & DSF_LOCK_OPTIMISTIC)
					Printf ("DSF_LOCK_OPTIMISTIC\n");
				else Printf ("DSF_LOCK_FULL\n");
				if (cmdLine = Token (&nextToken))
				{
					STRPTR newMode = NULL;

					if (strnicmp ("full", cmdLine, strlen (cmdLine)) == 0)
					{
						DBF_SetLockMode (server, DSF_LOCK_FULL);
						newMode = "DSF_LOCK_FULL";
					}
					else if (strnicmp ("none", cmdLine, strlen (cmdLine)) == 0)
					{
						DBF_SetLockMode (server, DSF_LOCK_NONE);
						newMode = "DSF_LOCK_NONE";
					}
					else if (strnicmp ("optimistic", cmdLine, strlen (cmdLine)) == 0)
					{
						DBF_SetLockMode (server, DSF_LOCK_OPTIMISTIC);
						newMode = "DSF_LOCK_OPTIMISTIC";
					}
					else Printf ("Unknown locking mode \"%s\".\n", cmdLine);

					if (newMode)
					{
						if (server->LastError)
						{
							Printf ("Failed to change locking mode to %s:\n");
							PrintDBError(server);
						}
						else Printf ("Successfully changed locking mode to %s.\n", newMode);
					}
				}
				break;
			case CMD_EVAL_MACRO:
				/* Evaluate a macro...
				 */
				if (*input == ZERO)
				{
					if (cmdLine = Token (&nextToken))
					{
						/* Try to open the specified file for read...
						 */
						if ((*input = Open (cmdLine, MODE_OLDFILE)) == ZERO)
							PrintError (IoErr(), "Failed to open macrofile");
					}
					else Printf("Enter the name of the macro behind the keyword\n");
				}
				else Printf ("You are already evaluating a macro.\n");
				break;
			case CMD_NEW:
				if (DS_DoUpdate (server, DS_INSERTROW, NULL))
				{
					ChangeRecord (server, nextToken, buffer, *input, *macro);
				}
				else
				{
					Printf ("Failed to insert a new record: \n");
					PrintDBError (server);
				}
				break;
			case CMD_NEXTRECORD:
				if (DS_DoUpdate (server, DS_NEXTROW, NULL) ||
					(server->LastError == IDX_ERR_NO_KEY))
				{
					BOOL noKey = FALSE;
					BOOL dupKey = FALSE;

					if (server->LastError == IDX_ERR_NO_KEY) noKey = TRUE;
					if (server->LastError == IDX_ERR_DUPLICATE_KEY) dupKey = TRUE;
					PRINTRECORD (ot);
					if (noKey)
					{
						Printf ("At least one index doesn't "
									"contain a keyvalue for this record.\n");
					}
					if (dupKey)
					{
						Printf ("One of the indexes with unique keys cannot "
									"access this record, because there is another "
									"record with the same keyvalue.\n");
					}
				}
				else
				{
					Printf ("Failed to skip to the next record: ");
					PrintDBError (server);
				}
				break;
			case CMD_OPEN:
				if (cmdLine = Token (&nextToken))
				{
					/* Check if the name is already in use...
					 */
					if (FindName (&(te->Tables), cmdLine) == NULL)
					{
						/* Try to open a DataTable using the specified name...
						 */
						STRPTR name;
						STRPTR path;

						name = cmdLine;
						if (path = Token (&nextToken))
						{
							struct DataServer *server;
							struct TagItem srvTags[] =
							{
								{DBF_Name, 0},
								{DBF_FileName, 0},
								{TAG_DONE, 0}
							};
							srvTags[0].ti_Data = (ULONG)name;
							srvTags[1].ti_Data = (ULONG)path;

							/* Ok, lets try to create the DataTable...
							 */
							if (server = DBF_InitA (NULL, srvTags))
							{
								/* Add this server to the list of open servers...
								 */
								if (AddOpenTable (te, server))
								{
									Printf ("DataTable successfully opened.\n");
								}
								else
								{
									DS_DoUpdate (server, DS_DISPOSE, NULL);
								}
							}
							else
							{
								if (IoErr()) PrintError (IoErr(), "Failed to open DataTable");
								else Printf ("Failed to open DataTable: Wrong filename ?\n");
							}
						}
						else Printf("Please enter the name of the DataTable and the  path to the\n"
										"according file behind the keyword\n");
					}
					else Printf ("There is already a DataTable opened with the name \"%s\".\n",cmdLine);
				}
				else Printf("Please enter the name of the DataTable and the  path to the\n"
								"according file behind the keyword\n");
				break;
			case CMD_OPENINDEX:
				if (cmdLine = Token (&nextToken))
				{
					/* Try to open an index using the specified name...
					 */
					struct IDXHeader *ihd;
					struct TagItem idxTags[] =
					{
						{IDX_FileName, 0},
						{TAG_IGNORE, 0},
						{TAG_DONE, 0}
					};
					idxTags[0].ti_Data = (ULONG)cmdLine;

					if ((cmdLine = Token (&nextToken)) &&
						(strnicmp ("unique", cmdLine, strlen (cmdLine)) == 0))
					{
						idxTags[1].ti_Tag = IDX_Unique;
					}

					/* Ok, lets try to create the Index...
					 */
					if (ihd = IDX_InitA (NULL, idxTags))
					{
						/* Add this index to the index-list of the server...
						 */
						if (!DBF_AddOrder (server, ihd))
						{
							Printf ("Failed to attache index to DataTable; ");
							PrintDBError (server);
							IDX_Dispose (ihd);
						}
						else Printf ("Index successfully opened.\n");
					}
					else
					{
						if (IoErr()) PrintError (IoErr(), "Failed to open index");
						else Printf ("Failed to open DataTable: Wrong filename ?\n");
					}
				}
				else Printf("Please enter the path to the index-file behind the keyword\n");
				break;
			case CMD_SET_ORDER:
				cmdLine = Token (&nextToken);
				if (!DS_DoUpdate (server, DS_SETORDER, (APTR)cmdLine))
				{
					/* Failed to change the active order...
					 */
					if (cmdLine)
					{
						Printf ("Failed to change the active index to \"%s\":\n",
																							cmdLine);
					}
					else Printf ("Failed to clear the active index:\n");
					PrintDBError (server);
					if (server->LastError == DS_ERR_WRONG_ARG)
					{
						Printf ("This operation is case-sensitive, "
										"is your spelling correct ?\n");
					}
				}
				else
				{
					/* Successfully changed the current order...
					 */
					if (cmdLine)
						Printf ("Active index changed to \"%s\".\n", cmdLine);
					else
						Printf ("Active index cleared, no index is active now.\n");

					/* Set the values 'TopScope' and 'BottomScope' according to the
					 * scope of the index...
					 */
					BufferScopeKeys (ot);
				}
				break;
			case CMD_PAGE_LENGTH:
				if (cmdLine = Token (&nextToken))
				{
					LONG pageLength;
					LONG charsRead;

					if ((charsRead = Str2Long (cmdLine, &pageLength)) &&
						(*(cmdLine + charsRead - 1) >= '0') &&
						(*(cmdLine + charsRead - 1) <= '9'))
					{
						if (pageLength >= 10) te->PageLength = pageLength;
						else Printf ("A pagelength less than 10 is not allowed.\n");
					}
					else Printf ("You should specify the desired pagelength behind the command.\n");
				}
				Printf ("Pagelength currently set to %ld.\n", te->PageLength);
				break;
			case CMD_PREVIOUSRECORD:
				if (DS_DoUpdate (server, DS_PREVROW, NULL) ||
					(server->LastError == IDX_ERR_NO_KEY))
				{
					BOOL noKey = FALSE;
					BOOL dupKey = FALSE;

					if (server->LastError == IDX_ERR_NO_KEY) noKey = TRUE;
					if (server->LastError == IDX_ERR_DUPLICATE_KEY) dupKey = TRUE;
					PRINTRECORD (ot);
					if (noKey)
					{
						Printf ("At least one index doesn't "
									"contain a keyvalue for this record.\n");
					}
					if (dupKey)
					{
						Printf ("One of the indexes with unique keys cannot "
									"access this record, because there is another "
									"record with the same keyvalue.\n");
					}
				}
				else
				{
					Printf ("Failed to skip to the previous record: ");
					PrintDBError (server);
				}
				break;
			case CMD_QUIT:
				quit = TRUE;
				break;
			case CMD_RECORD_MACRO:
				if (*macro == ZERO)
				{
					if (cmdLine = Token (&nextToken))
					{
						/* Try to open the specified file for write...
						 */
						if ((*macro = Open (cmdLine, MODE_NEWFILE)) == ZERO)
							PrintError (IoErr(), "Failed to open macrofile");
					}
					else Printf("Enter the name of the macro behind the keyword\n");
				}
				else Printf ("You are already recording a macro.\n");
				break;
			case CMD_REINDEX:
				{
					struct IDXHeader *ihd;

					cmdLine = Token (&nextToken);
					if (ihd = DBF_GetOrder (server, cmdLine))
					{
						if (*input == ZERO)
						{
							LONG charsRead;

							Printf ("Are you shure to reindex the index \"%s\" ? (Y/N): ", ihd->Link.ln_Name);
							Flush (Output());
							buffer[0] = '\0';
							charsRead = Read (Input(), buffer, 511);
						}
						else buffer[0] = 'Y';

						if ((buffer[0] & 0xDF) == 'Y')
						{
							/* Copy the name of the index back to the buffer...
							 */
							strcpy (buffer, ihd->Link.ln_Name);

							/* Ok, lets fetz...
							 */
							if (DBF_ReIndex (server, buffer, &ReIndexNotify, buffer))
							{
								Printf ("Successfully reindexed the order \"%s\".\n", ihd->Link.ln_Name);
								if (server->LastError == IDX_ERR_DUPLICATE_KEY)
								{
									Printf ("The index should be unique, but there are records with\n"
											  "duplicate key-values.\n");
								}
							}
							else
							{
								STRPTR *orders;

								if (IoErr())
									PrintError (IoErr(),"Failed to reindex the order");
								else
									Printf ("Failed to reindex the order \"%s\": ", buffer);
								PrintDBError (server);

								if (DS_DoUpdate (server, DS_AVAILABLEORDER, (APTR)&orders))
								{
									while (*orders && strcmp (*orders, buffer))
									{
										orders += 1;
									}
									if (!*orders)
									{
										Printf ("The indexfile is damaged, delete it manual and than try to\n"
													"reindex it again.\n");
									}
								}
								else
								{
									Printf ("Failed to determine the available orders: ");
									PrintDBError (server);
								}
							}
						}
					}
					else if (cmdLine) Printf ("No order with the name \"%s\" attached to the active table.\n", cmdLine);
					else Printf ("Currently no order active, specify the name of the order.\n");
				}
				break;
			case CMD_RELATIONS:
				/* Show all relations to this server...
				 */
				{
					struct RelatedServer *rs;

					Printf ("Relations to the table \"%s\":\n", server->Name);

					rs = (struct RelatedServer *)
							((struct DataTable *)server)->Relations.lh_Head;

					if (rs == (struct RelatedServer *)
									&(((struct DataTable *)server)->Relations.lh_Tail))
					{
						Printf ("   None\n");
					}
					else
					{
						while (rs != (struct RelatedServer *)
											&(((struct DataTable *)server)->Relations.lh_Tail))
						{
							Printf ("   %s ==> Expression = \"%s\", Order = \"%s\"\n",
												rs->Server->Name, rs->Expression, rs->Order);
							rs = (struct RelatedServer *)rs->Link.ln_Succ;
						}
					}
				}
				break;
			case CMD_SEEK:
				PerformSeek (ot, nextToken);
				break;
			case CMD_SET_RELATION:
				if (cmdLine = Token (&nextToken))
				{
					struct OpenTable *ct;

					if (ct = (struct OpenTable *)FindName (&(te->Tables), cmdLine))
					{
						LONG slen;

						if ((cmdLine = Token (&nextToken)) && (slen = strlen (cmdLine)))
						{
							STRPTR order = cmdLine;
							LONG numChars;

							if ((cmdLine = Token (&nextToken)) && (numChars = strlen (cmdLine)))
							{
								STRPTR expression;

								numChars += 1;
								if (expression = (STRPTR)AllocVector (slen + numChars + 1, MEMF_ANY))
								{
									strcpy (expression, cmdLine);
									cmdLine = order;
									order = expression + numChars;
									strcpy (order, cmdLine);

									if (DBF_SetRelation (server, ct->Server, order, expression))
									{
										Printf ("Successfully established the relation.\n");
										ct->Buffer = expression;
										ChangeCaption (ot);
									}
									else
									{
										Printf ("Failed to established the relation: ");
										PrintDBError (server);
										Printf ("Client error: ");
										PrintDBError (ct->Server);
										FreeVector (expression);
									}
								}
								else PrintError (IoErr(), "Failed to allocate buffer for expression");
							}
							else Printf("Enter the expression of the relation at the end of the commandline.\n");
						}
						else Printf("Enter the name of the order to be used behind the name of the client table.\n");
					}
					else Printf ("No table with the name \"%s\" is currently open.\n", cmdLine);
				}
				else Printf("Enter the name of the client table behind the keyword\n");
				break;
			case CMD_SHOW_ALL:
				{
					BOOL deleted = FALSE;

					if ((cmdLine = Token (&nextToken)) &&
						(strnicmp (cmdLine, "TRUE", strlen (cmdLine)) == 0))
					{
						deleted = TRUE;
					}
					DBF_ShowDeleted (server, deleted);
					if (deleted) Printf ("Now all records of \"%s\" are displayed.\n", server->Name);
					else Printf ("Now the deleted records of \"%s\" are hidden.\n", server->Name);
				}
				break;
			case CMD_SKIP:
				{
					LONG toSkip;
					LONG charsRead;

					if ((cmdLine = Token (&nextToken)) &&
						(charsRead = Str2Long (cmdLine, &toSkip)) &&
						(*(cmdLine + charsRead - 1) >= '0') &&
						(*(cmdLine + charsRead - 1) <= '9'))
					{
						if (DS_DoUpdate (server, DS_SKIPROWS, (APTR)toSkip) ||
							(server->LastError == IDX_ERR_NO_KEY))
						{
							BOOL noKey = FALSE;
							BOOL dupKey = FALSE;

							if (server->LastError == IDX_ERR_NO_KEY)
								noKey = TRUE;
							if (server->LastError == IDX_ERR_DUPLICATE_KEY)
								dupKey = TRUE;
							PRINTRECORD (ot);
							if (noKey)
							{
								Printf ("At least one index doesn't "
											"contain a keyvalue for this record.\n");
							}
							if (dupKey)
							{
								Printf ("One of the indexes with unique keys cannot "
										"access this record, because there is another "
										"record with the same keyvalue.\n");
							}
						}
						else
						{
							Printf ("Failed to skip %ld records: ", toSkip);
							PrintDBError (server);
						}
					}
					else Printf ("Enter the number of records to be skipped behind "
									 "the keyword, e.g. \"Skip -3\"\n");
				}
				break;
			case CMD_STATISTIC:
				/* Show some statistic information...
				 */
				if (DS_DoUpdate (server, DS_NUM_OF_ROWS, (APTR)&cmd))
				{
					ULONG columns;

					if (DS_DoUpdate (server, DS_NUM_OF_COLUMNS, (APTR)&columns))
					{
						Printf ("The table with the name \"%s\" contains "
												"%ld records and %ld columns.\n",
																server->Name, cmd, columns);
					}
					else
					{
						Printf ("Failed to count the columns: ");
						PrintDBError (server);
					}
				}
				else
				{
					Printf ("Failed to count the records: ");
					PrintDBError (server);
				}
				break;
			case CMD_STOP_MACRO:
				/* Stop recording a macro...
				 */
				if (*macro != ZERO)
				{
					Printf ("Macro recording stopped.\n");
					Close (*macro);
					*macro = ZERO;
				}
				break;
			case CMD_DBSTRUCT:
				Printf ("The structure of the DataTable:\n");
				PrintDBStruct (server);
				break;
			case CMD_OPEN_TABLES:
				{
					struct FileInfoBlock *fib;

					if (fib = (struct FileInfoBlock *)AllocDOSObject (DOS_FIB, NULL))
					{
						struct OpenTable *ot;

						ot = (struct OpenTable *)te->Tables.lh_Head;
						while (ot != (struct OpenTable *)&(te->Tables.lh_Tail))
						{
							if (ExamineFH ((BPTR)ot->Server->Device, fib) == DOSTRUE)
							{
								if (ot->Server == server) Printf (">> ");
								else Printf ("   ");
								Printf ("%s -> %s\n", ot->Server->Name, fib->fib_FileName);
							}			
							else PrintError (IoErr(), "Failed to examine servers filehandle");

							ot = (struct OpenTable *)ot->Link.ln_Succ;
						}
						FreeDOSObject (DOS_FIB, fib);
					}
					else PrintError (IoErr(), "Failed to allocate FileInfoBlock");
				}
				break;
			case CMD_SKIP_TOP:
				if (DS_DoUpdate (server, DS_FIRSTROW, NULL) ||
					(server->LastError == IDX_ERR_NO_KEY))
				{
					BOOL noKey = FALSE;
					BOOL dupKey = FALSE;

					if (server->LastError == IDX_ERR_NO_KEY) noKey = TRUE;
					if (server->LastError == IDX_ERR_DUPLICATE_KEY) dupKey = TRUE;
					PRINTRECORD (ot);
					if (noKey)
					{
						Printf ("At least one index doesn't "
									"contain a keyvalue for this record.\n");
					}
					if (dupKey)
					{
						Printf ("One of the indexes with unique keys cannot "
									"access this record, because there is another "
									"record with the same keyvalue.\n");
					}
				}
				else
				{
					Printf ("Failed to skip to the first record: ");
					PrintDBError (server);
				}
				break;
			case CMD_SET_TOP_SCOPE:
				/* Set the top scope (without affecting the bottom scope)...
				 */
				{
					STRPTR order;

					if (DS_DoUpdate (server, DS_GETORDER, (APTR)&order))
					{
						struct IDXHeader *idx;

						if (idx = DBF_GetOrder (server, order))
						{
							APTR keyValue = NULL;

							if (!nextToken ||
								(keyValue = GetKeyValue (server, nextToken)))
							{
								if (IDX_SetScope (idx, keyValue, ot->BottomScope))
								{
									Printf ("Successfully changed the top scope.\n");
									if (keyValue)
									{
										if (!ot->TopScope)
										{
											ot->TopScope = (UBYTE *)
														AllocVector (idx->KeyLen, MEMF_ANY);
										}
										if (ot->TopScope)
										{
											CopyMem (keyValue, ot->TopScope, idx->KeyLen);
										}
										else Printf ("Failed to allocate a buffer "
														"for the top scope-value.\n");
									}
									else if (ot->TopScope)
									{
										FreeVector (ot->TopScope);
										ot->TopScope = NULL;
									}
								}
								else
								{
									Printf ("Failed to set the top scope-value: ");
									if (IoErr() == ERROR_NO_FREE_STORE)
										Printf ("Not enougth free memory available.\n");
									else if (ot->BottomScope)
										Printf ("Top scope-value ordered behind "
																	"bottom scope-value ?\n");
									else
										Printf ("Maybe the index is corrupt.\n");
								}
							}
						}
						else Printf ("No active order -> No scope possible.\n");
					}
					else
					{
						Printf ("Failed to get the name of the current index: ");
						PrintDBError (server);
					}
				}
				break;
			case CMD_UNLOCK_RECORD:
				/* Release the lock of the current record...
				 */
				{
					ULONG recNo;

					if (DS_DoUpdate (server, DS_CURRENTROW, (APTR)&recNo))
					{
						if (DBF_UnLockRecord (server, recNo))
						{
							Printf ("Successfully released current record.\n");
						}
						else
						{
							Printf ("Failed to unlock record %ld: ",recNo);
							PrintDBError (server);
						}
					}
					else
					{
						Printf ("Failed to access current record: ");
						PrintDBError (server);
					}
				}
				break;
			case CMD_UNLOCK_INDEX:
				/* Release the lock of an index...
				 */
				{
					struct IDXHeader *ihd;

					cmdLine = Token (&nextToken);
					if (ihd = DBF_GetOrder (server, cmdLine))
					{
						if (IDX_EndTransaction (ihd, IDX_READ))
						{
							Printf ("Successfully unlocked the index \"%s\".\n", ihd->Link.ln_Name);
						}
						else
						{
							if (IoErr()) PrintError (IoErr(), "Failed to unlock the index");
							else Printf ("Failed to unlock the index \"%s\".\n", ihd->Link.ln_Name);
						}
					}
					else if (cmdLine) Printf ("No order with the name \"%s\" attached to the active table.\n", cmdLine);
					else Printf ("Currently no order active, specify the name of the order.\n");
				}
				break;
			case CMD_UNLOCK_MEMO:
				/* Release the lock of a memo-file...
				 */
				if (server->Flags & DSF_HASMEMO)
				{
					if (!DBM_UnLockMemo ((struct MemoFile *)server->Rows))
					{
						PrintError (IoErr(), "Failed to unlock memo-file");
					}
					else Printf ("Successfully released the lock of the memo-file.\n");
				}
				else Printf ("The currently active server doesn't owns a memo-file.\n");
				break;
			case CMD_USE:
				/* Activate another server...
				 */
				if (cmdLine = Token (&nextToken))
				{
					/* Check if the name is already in use...
					 */
					struct OpenTable *ot;
					if (ot = (struct OpenTable *)FindName (&(te->Tables), cmdLine))
					{
						te->Used = ot;
					}
					else Printf ("No table with the name \"%s\" is currently open.\n", cmdLine);
				}
				else Printf("Enter the name of the DataTable behind the keyword\n");
				break;
			default:
				Printf ("Unsupported command \"%s\"\n", cmdLine);
				break;

		}
	}
	else if (*cmdLine != '\n') Printf ("Unknown command: \"%s\".\n", cmdLine);

	return quit;
}

/***************************************************************************/
/*																									*/
/*										module-entry-point									*/
/*																									*/
/***************************************************************************/

APTR InitTableEdit (ULONG pageLength)
{
	struct TableEdit *te = NULL;

	if (((struct Library *)DOSBase)->lib_Version >= 36)
	{
		if (te = (struct TableEdit *)AllocMem (sizeof (struct TableEdit), MEMF_ANY | MEMF_CLEAR))
		{
			if (te->Buffer = (UBYTE *)AllocMem (512, MEMF_ANY))
			{
				if (!pageLength) pageLength = BROWSER_PAGE_LENGTH;
				NewList (&(te->Tables));
				te->PageLength = pageLength;
			}
			else
			{
				PrintError (IoErr(), "Failed to allocate input-buffer");
				FreeMem (te, sizeof (struct TableEdit));
				te = NULL;
			}
		}
		else PrintError (IoErr(),"Failed to create 'TableEdit' structure");
	}
	else Printf ("Sorry, wrong OS version, requires AmigaOS 2.0 or better.\n");

	return (APTR)te;
}

void DisposeTableEdit (APTR tableEd)
{
	struct TableEdit *te;

	if (te = (struct TableEdit *)tableEd)
	{
		struct DataServer *ds;
		struct OpenTable *ot;

		/* Prevent the RemoveOpenTable() function from activating another
		 * table if the currently active one is closed...
		 */
		te->Used = (struct OpenTable *)~0L;

		/* Process the whole list of open tables and close them all...
		 */
		ot = (struct OpenTable *)te->Tables.lh_Head;

		while (ot != (struct OpenTable *)&(te->Tables.lh_Tail))
		{
			ds = RemoveOpenTable (tableEd, ot->Link.ln_Name);
			DS_DoUpdate (ds, DS_DISPOSE, NULL);
			ot = (struct OpenTable *)te->Tables.lh_Head;
		}
		if (te->Buffer) FreeMem (te->Buffer, 512);

		FreeMem (tableEd, sizeof (struct TableEdit));
	}
}

void TableEdit (APTR tableEd)
{
	struct TableEdit *te = (struct TableEdit *)tableEd;

	if (te && te->Used)
	{
		BPTR macro = ZERO;
		BPTR input = ZERO;
		BPTR stdInput = 1L;

		if (stdInput = Input())
		{
			BOOL quit = FALSE;
			LONG bytesRead;

			PutStr (mainHelp);

			/* Start the input-processing loop...
			 */
			while (!quit)
			{
				Printf ("?: ");
				Flush (Output());

				if (input != ZERO)
				{
					/* Read buffered from the file...
					 */
					if (FGets (input, te->Buffer, 511))
					{
						bytesRead = strlen (te->Buffer);
						if (bytesRead > 0) Write(Output(), te->Buffer, bytesRead);
					}
					else bytesRead = 0;
				}
				else bytesRead = Read (stdInput, te->Buffer, 511);

				if (bytesRead != -1)
				{
					if (bytesRead)
					{
						if (macro != ZERO)
						{
							/* Store the input in the macro-file...
							 */
							Write (macro, te->Buffer, bytesRead);
						}
						/* add a terminating NUL-byte...
						 */
						te->Buffer[bytesRead] = '\0';

						/* Process the input...
						 */
						quit = ParseInput (te, te->Buffer, &input, &macro);
					}
					else
					{
						/* EOF -> The input must be a macro-file, close it now.
						 */
						if (input != ZERO)
						{
							Close (input);
							input = ZERO;
							Printf ("Reached the end of the macro file; "
													"macro-processing stopped\n");
						}
						else
						{
							Printf ("Reached EOF in the commandline ?\n"
										"Stop executing the application.\n");
							quit = TRUE;
						}
					}
				}
			}
			if (macro != ZERO) Close (macro);
			if (input != ZERO) Close (input);
		}
		else Printf ("Failed to access the CLI for input.\n");
	}
	else Printf("First you have to create a  'TableEdit'  structure  calling\n"
					"InitTableInit()  and to add at least one open table to this\n"
					"structure using AddOpenTable()\n");
}


//struct List orderList;
//struct IDXHeader *index;
	/* Remove all indexes from the server ->
	 * increase speed...
	 */
// NewList (&orderList);
//	if (ds->Flags & DSF_DBTABLE)
//	{
		/* The server is a DataTable, so all indexes are
		 * linked in a list...
		 */
/*		(struct DataTable *)
	}


	while (index = RemHead (&orderList))
	{
		if (!DBF_AddOrder (ds, index))
		{
			if (success)
			{
				success = FALSE;
				error = ds->LastError;
			}
		}
	}
*/
