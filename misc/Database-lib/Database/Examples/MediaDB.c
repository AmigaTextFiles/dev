/* MediaDB
 *
 * This is a very small DataTable used to test the Database library.
 * The created DataTable is used to store information about music-medias,
 *	i.e. the media music is stored on like CDs, LPs, or MCs.
 * Using the DataTable I'm able to locate any entered record by searching
 * for the medias shortname.
 *	This DataTable may be related to the AlbumDB to serve the attributes of
 * the music-medias of the albums.
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

/* The structure of the MediaDB's DataTable...
 */
struct DBStruct dbStruct[] =
{
	{"MEDIA","Media","Type of the media",DC_CHAR,DCF_NOT_EMPTY,2,0},
	{"NAME","Name","Name of the media",DC_CHAR,0,40,0},
	{"DIGITAL","Digital","Is the information stored digital ?",DC_LOGIC,0,0,0},
	{"DESCRIPTION","Description","Description of the media",DC_TEXT,0,0,0},
	{0}
};

struct TagItem *UserTags = NULL;

STRPTR TablePath = "RAM:";
STRPTR TableName = "MediaDB";
STRPTR TableFile = "Media.dbf";

ULONG NumIndexes = 2;

struct TagItem *IndexTags = NULL;

STRPTR idx_KeyExpression[] =
{
	"MEDIA",
	"DIGITAL"
};

STRPTR idx_IndexName[] =
{
	"Media",
	"Digital"
};

STRPTR idx_FileName[] =
{
	"Media.idx",
	"Digital.idx"
};

BOOL idx_Unique[] =
{
	TRUE,
	FALSE
};
