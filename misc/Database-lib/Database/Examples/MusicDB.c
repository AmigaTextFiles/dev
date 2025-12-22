/* MusicDB
 *
 * This is a very small DataTable used to test the Database library.
 * The created DataTable is used to store information about music-titles.
 * Using the DataTable I'm able to locate any entered record by searching
 * for the interpret, the title, or the album. It is also possible to order
 * the records by their length.
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

/* The structure of the MusicDB's DataTable...
 */
struct DBStruct dbStruct[] =
{
	{"TRACK","Track","Number of the track on the CD.",DC_WORD,DCF_NOT_EMPTY,0,0},
	{"INTERPRET","Interpret","Interpret of the track.",DC_CHAR,0,40,0},
	{"TITLE","Title","Title of the song.",DC_CHAR,0,32,0},
	{"LENGTH","Length","Length of the song.",DC_TIME,0,0,0},
	{"ALBUMID","AlbumId","Id of the album.",DC_LONG,DCF_NOT_EMPTY,0,0},
	{"COMMENT","Comment","My personal comments.",DC_TEXT,0,0,0},
	{0}
};

struct TagItem UserTags[] = 
{
	{DBF_ForceUnique, 0},
	{TAG_DONE, 0}
};

STRPTR TablePath = "RAM:";
STRPTR TableName = "MusicDB";
STRPTR TableFile = "Music.dbf";

ULONG NumIndexes = 4;

struct TagItem *IndexTags = NULL;

STRPTR idx_KeyExpression[] =
{
	"VAL(STR(ALBUMID,10)+STRZERO(TRACK,5))",
	"UPPER(INTERPRET)",
	"UPPER(TITLE)",
	"LENGTH"
};

STRPTR idx_IndexName[] =
{
	"Track",
	"Interpret",
	"Title",
	"Length"
};

STRPTR idx_FileName[] =
{
	"Track.idx",
	"Interpret.idx",
	"Title.idx",
	"Length.idx"
};

BOOL idx_Unique[] =
{
	TRUE,
	FALSE,
	FALSE,
	FALSE
};
