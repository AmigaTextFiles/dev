/* TVDB
 *
 * This is a very small DataTable used to test the Database library.
 * The created DataTable is used to store information about TV-movies.
 * Using the DataTable I'm able to locate any entered record by searching
 * for the title, the date, or the channel.
 *
 * This needs to be linked against TableEdit.o and Main.o.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _TAGITEMS_H_
#include <joinOS/misc/TagItems.h>
#endif

#ifndef _DATABASE_DATASERVER_H_
#include <joinOS/database/DataServer.h>
#endif

#ifndef _DATABASE_DATATABLE_H_
#include <joinOS/database/DataTable.h>
#endif

/***************************************************************************/
/*																									*/
/*										Global data												*/
/*																									*/
/***************************************************************************/

/* The structure of the TVDB's DataTable...
 */
struct DBStruct dbStruct[] =
{
	{"DATE","Date","Date the movie is send",DC_DATE,0,0,0},
	{"TIME","Time","Time the movie is send",DC_TIME,0,0,0},
	{"CHANNEL","Channel","Number of the channel",DC_BYTE,0,0,0},
	{"TITLE","Title","Title of the movie", DC_CHAR,0,36,0},
	{"SERIES","Series","Is it a part of a series ?",DC_LOGIC,0,0,0},
	{"SEEN","Seen","Have I already seen this ?",DC_LOGIC,0,0,0},
	{"TAPE","Tape","Number of the videotape ?",DC_WORD,0,0,0},
	{"COMMENT","Comment","My personal comments.",DC_TEXT,0,0,0},
	{0}
};

struct TagItem *UserTags = NULL;

STRPTR TablePath = "RAM:";
STRPTR TableName = "TVDB";
STRPTR TableFile = "TV.dbf";

ULONG NumIndexes = 5;

struct TagItem IndexTags[] =
{
		{IDX_Exclusive, 0},
		{IDX_PageSize, 3700},
		{IDX_WriteBehind, 0},
		{TAG_DONE, 0}
};

STRPTR idx_KeyExpression[] =
{
	"VAL(DTOS(DATE)+STR(TIME))",
	"STR(CHANNEL,3)+DTOS(DATE)+STR(TIME)",
	"LOWER(TITLE)",
	"TAPE",
	"LTOC(SEEN)+TTOS(TIME)"		/* Seen movies, ordered by daytime */
};

STRPTR idx_IndexName[] =
{
	"Date",
	"Channel",
	"Title",
	"Tape",
	"Seen"
};

STRPTR idx_FileName[] =
{
	"Date.idx",
	"Channel.idx",
	"Title.idx",
	"Tape.idx",
	"Seen.idx"
};

BOOL idx_Unique[] =
{
	FALSE,
	TRUE,
	FALSE,
	FALSE,
	FALSE
};
