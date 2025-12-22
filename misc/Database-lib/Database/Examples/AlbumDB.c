/* AlbumDB
 *
 * This is a very small DataTable used to test the Database library.
 * The created DataTable is used to store information about music-albums.
 * Using the DataTable I'm able to locate any entered record by searching
 * for the albums name, unique Id, or the type of the medium, the album is
 * stored on.
 *	This DataTable may be related to the MusicDB to serve the names of the
 * Albums.
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

/* The structure of the AlbumDB's DataTable...
 */
struct DBStruct dbStruct[] =
{
	{"ID","Id","Unique Id of the album",DC_LONG,DCF_NOT_EMPTY,0,0},
	{"ALBUM","Album","Title of the album.",DC_CHAR,0,40,0},
	{"MEDIUM","Medium","Type of the albums media",DC_CHAR,0,2,0},
	{"COMMENT","Comment","My personal comments.",DC_TEXT,0,0,0},
	{0}
};

struct TagItem *UserTags = NULL;

STRPTR TablePath = "RAM:";
STRPTR TableName = "AlbumDB";
STRPTR TableFile = "Album.dbf";

ULONG NumIndexes = 3;

struct TagItem *IndexTags = NULL;

STRPTR idx_KeyExpression[] =
{
	"ID",
	"UPPER(ALBUM)",
	"MEDIUM"
};

STRPTR idx_IndexName[] =
{
	"Id",
	"Album",
	"Medium"
};

STRPTR idx_FileName[] =
{
	"Id.idx",
	"Album.idx",
	"Medium.idx"
};

BOOL idx_Unique[] =
{
	TRUE,
	FALSE,
	FALSE
};
