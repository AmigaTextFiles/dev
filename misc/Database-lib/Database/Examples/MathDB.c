/* MathDB
 *
 * This is a test-database that is used to test the column datatypes that
 * are currently untested:
 *
 * DC_LONG - a four byte integer value (-2147483648 upto +21474383647)
 * DC_DOUBLELONG - a eight byte integer value
 * DC_FLOAT - float single precision, (4 bytes)
 * DC_DOUBLE - float double precision, (8 bytes)
 * DC_NUMERIC - fixed point arithmetic value
 * DC_VARCHAR - NUL-terminated string
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

/* The structure of the MathDB's DataTable...
 */
struct DBStruct dbStruct[] =
{
	{"LONG","long","a 32 bit long value",DC_LONG,DCF_NOT_EMPTY,0,0},
	{"DOUBLELONG","doublelong","a 64 bit long value",DC_DOUBLELONG,0,0,0},
	{"FLOAT","float","a 32 bit floating point number", DC_FLOAT,0,0,0},
	{"DOUBLE","double","a 64 bit floating point number", DC_DOUBLE,0,0,0},
	{"NUMERIC","numeric","a fixed point number", DC_NUMERIC, 0, 10, 2},
	{"VARCHAR","varchar","a variable length string", DC_VARCHAR, 0, 32, 0},
	{0}
};

struct TagItem UserTags[] = 
{
	{DBF_Exclusive, 0},
	{TAG_DONE, 0}
};

STRPTR TablePath = "RAM:";
STRPTR TableName = "MathDB";
STRPTR TableFile = "Math.dbf";

ULONG NumIndexes = 7;

struct TagItem *IndexTags = NULL;

STRPTR idx_KeyExpression[] =
{
	"LONG",
	"DOUBLELONG",
	"LONG+DOUBLELONG",
	"Double",
	"Float",
	"NUMERIC",
	"STR(LONG)"
};

STRPTR idx_IndexName[] =
{
	"Long",
	"Doublelong",
	"Combined",
	"Double",
	"Float",
	"Numeric",
	"String"
};

STRPTR idx_FileName[] =
{
	"Long.idx",
	"Doublelong.idx",
	"Combined.idx",
	"Double.idx",
	"Float.idx",
	"Numeric.idx",
	"String.idx"
};

BOOL idx_Unique[] =
{
	TRUE,
	FALSE,
	FALSE,
	FALSE,
	FALSE,
	FALSE,
	TRUE
};
