#ifndef _DATABASE_DATATABLE_H_
#define _DATABASE_DATATABLE_H_ 1

/* DataTable.h
 *
 * This DataTable is a subclass of the DataServer, it allows to handle
 * (nearly) any kind of data arranges in records of a table of a DataBase.
 *	The length of a single record of the database could be at most 32767 bytes;
 * it is always padded to a multiple of 4 bytes (longword aligned).
 *	Several datacolumns may be padded to a multiple of 4 bytes in length, so a
 *	single row may contain at a maximum less than 32767 bytes, depending on the
 *	type of data in the columns and the order the columns are arranged.
 *
 * The current implementation of the DataBase only supports the following
 *	datatypes:
 *		DC_BYTE - a single byte of data (-128 upto +127)
 *		DC_WORD - a two byte integer value (-32768 upto +32767)
 *		DC_LONG - a four byte integer value (-2147483648 upto +21474383647)
 *		DC_DOUBLELONG - a eight byte integer value
 *										(-9223372036854775808 upto 9223372036854775807)
 *		DC_FLOAT - a single precision floating point value, (4 bytes)
 *		DC_DOUBLE - a double precision floating point value, (8 bytes)
 *		DC_NUMERIC - a fixed point arithmetic value (upto 18 digits)
 *		DC_LOGIC - a logic (boolean) value ('T' (TRUE) or 'F' (FALSE))
 *		DC_DATE - a date (8 bytes in the format YYYYMMDD)
 *		DC_TIME - a time a 32bit-integrer with the milliseconds since midnight
 *		DC_CHAR - a fixed length string, not NUL-terminated, padded with
 *						spaces (character 32)
 *		DC_TEXT - a variable length text (a so called "memo text")
 *		DC_VARCHAR - string, variable length, max. length is specified
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _TAGITEMS_H_
#include <joinOS/misc/TagItems.h>
#endif

#ifndef _LISTS_H_
#include <joinOS/exec/lists.h>
#endif

#ifndef _DATABASE_DATASERVER_H_
#include <joinOS/database/DataServer.h>
#endif

#ifndef _DATABASE_INDEX_H_
#include <joinOS/database/Index.h>
#endif

#ifndef _DATABASE_PARSE_H_
#include <joinOS/database/Parse.h>
#endif

#ifndef _DATABASE_MEMO_H_
#include <joinOS/database/Memo.h>
#endif

#ifndef _DATABASE_FUNCTIONTYPES_H_
#include <joinOS/database/FunctionTypes.h>
#endif

/***************************************************************************/
/*																									*/
/*								Structures used for DataTables							*/
/*																									*/
/***************************************************************************/

/* Structure used to define the structure of a record...
 */
struct DBStruct
{
	STRPTR Name;			/* Name of the column (name of the datafield, 32 chars
								 * max.), NULL or empty strings are not allowed */
	STRPTR Caption;		/* a caption that should be used for this column,
								 * may be the same string as used for 'Name' */
	STRPTR HelpText;		/* a short descriptive text for that column,
								 * may be NULL */
	UWORD Type;				/* Type identifier */
	UWORD Flags;			/* column-flags (see "DataServer.h") */
	UWORD Length;			/* length of the data (may depend on type) */
	UWORD Decimals;		/* only used with numeric values */
};

/* Base structure of a DataTable...
 * DS.Device contains the FileHandle of the DataTable.
 * DS.Rows contains a pointer to the DBStruct array describing the records
 */
struct DataTable
{
	struct DataServer DS;			/* embedded DataServer structure */
	ULONG HeaderSize;					/* size of the header in the file */
	ULONG NumRecords;					/* total number of records in DataTable */
	UWORD RecordLength;				/* bytesize of a single record */
	UBYTE NullMemo;					/* used as "empty" memo */
	UBYTE pad;							/* align to longword size */
	struct DBStruct *Structure;	/* the structure of the records */
	UBYTE *CurrentRecord;			/* buffer with copy of current record */
	UBYTE *OriginalRecord;			/* unchanged copy of current record */
	UWORD *Offsets;					/* array of offsets into a record */
	STRPTR *OrderNames;				/* array with 'Names' of orders */
	VALIDATE_RECORD Validate;		/* user-function for validating records */
	struct List Orders;				/* list of available orders (Index) */
	struct DataServer *Superior;	/* server this one is related to */
	struct List Relations;			/* list of DataServers related to this one */
	struct MinList Selected;		/* list of selected records */
	struct MinList Locks;			/* list of locked records */
};

/* Node in the list of selected records...
 */
struct RecordSelect
{
	struct MinNode Link;		/* used to link into list */
	ULONG RecNo;				/* record number of the selected record */
};

/* Node in the list of locked records...
 */
struct RecordLocked
{
	struct MinNode Link;		/* used to link into list */
	ULONG RecNo;				/* record number of the locked record */
	ULONG Mode;					/* lock-mode (DBF_READ or DBF_WRITE) */
};

/* Node in the list of related DataServers...
 */
struct RelatedServer
{
	struct Node Link;				/* used to link into list */
	struct DataServer *Server;	/* the related DataServer */
	STRPTR Order;					/* the order used for the relation */
	STRPTR Expression;			/* Expression of the relation */
	UBYTE *PreParsedExpr;		/* the prepcompiled expression */
	APTR KeyValue;					/* buffer to store a single key */
	UWORD KeyLen;					/* length of a key-value */
};

/* A column-description as stored in the header of the DataTable-file
 */
struct DBFColumn			/*  size 40 bytes */
{
	UBYTE Name[32];		/* name of the column, only NUL-terminated if less
								 * than 32 characters */
	UWORD Type;				/* Type-identifier */
	UWORD Flags;			/* column-flags (see "DataServer.h") */
	UWORD Length;			/* length of the data (may depend on type) */
	UWORD Decimals;		/* only used with numeric values */
};

/* This is the header of a DataTable-file...
 */
struct DataTableHeader	/* size (24 + 40 * 'NumberofColumns') bytes */
{
	ULONG FileID;						/* 'DBF ' */
	ULONG VersionID;					/* 1L */
	ULONG HeaderSize;					/* size of this structure (>= 1024) */
	ULONG EmptyRecord;				/* number of the first unused record */
	ULONG NumberOfRecords;			/* number of valid records in the file */
	ULONG TotalNumRecords;			/* total number of records (valid & deleted)*/
	UWORD RecordLength;				/* bytesize of a single recod (8 - 32767) */
	UWORD NumberOfColumns;			/* number of columns per record */
	struct DBFColumn Columns[0];	/* array with 'NumberOfColumns' structures */
};

/***************************************************************************/
/*																									*/
/*									Defines used for DataTables							*/
/*																									*/
/***************************************************************************/

#define DBF_FILEID		MAKE_ID('D','B','F',' ')	/* first long in file */

/* Tags for creation of DataTables...
 */
#define DBF_TagBase	     TAG_USER + 0x80000

#define DBF_Name			DBF_TagBase + 1	/* the name of the table */
#define DBF_FileName		DBF_TagBase + 2	/* filename and path of the file */
#define DBF_StructSize	DBF_TagBase + 3	/* size of the DataTable structure */
#define DBF_Struct		DBF_TagBase + 4	/* structure array of the table */

#define DBF_Validate		DBF_TagBase + 5	/* validation function for records */

#define DBF_ForceUnique	DBF_TagBase + 11	/* records should be unique */
#define DBF_ReadOnly		DBF_TagBase + 12	/* Table cannot be changed */
#define DBF_Exclusive	DBF_TagBase + 13	/* Table is used exclusive */
#define DBF_LockMode		DBF_TagBase + 14	/* see below for defines */

/* Accessing-modes of records:
 */
#define DBF_READ	REC_SHARED		/* read-only access */
#define DBF_WRITE	REC_EXCLUSIVE	/* read-write access */

/* Locking modes (passed using Tag DBF_LockMode)...
 */
#define DSF_LOCK_FULL			0x00000000	/* Lock the records exclusive */
#define DSF_LOCK_OPTIMISTIC	0x00200000	/* use optimistic locking */
#define DSF_LOCK_NONE			0x00400000	/* don't use any locking */

/* Additional flag defines for 'DataServer.Flags'...
 */
#define DSF_FORCE_UNIQUE	0x00800000	/* fails to add/change records, if a
													 * duplicate key is found in an unique
													 * index */
#define DSF_SHOW_DELETED	0x01000000	/* also show deleted records */
#define DSF_MEMO_READ		0x02000000	/* the memo of the current record is
													 * copied into memory */
#define DSF_MEMO_CHANGED	0x04000000	/* the memo of the current record has
													 * been changed */
#define DSF_REC_CACHED		0x08000000	/* the current record is cached */
#define DSF_REC_DELETED		0x10000000	/* current record is deleted */
#define DSF_EXCLUSIVE		0x20000000	/* the table is opened exclusive */
#define DSF_HASMEMO			0x40000000	/* there should be a "memo"-file */
#define DSF_DBTABLE			0x80000000	/* this is a 'DataBase' */

/* Additonal error codes (stored in the 'LastError' field of the embedded
 * DataServer...
 */
#define DBF_ERR_DUPLICATE_NAME	1000L	/* a 'Name' of an index or a column is
													 * already in use */
#define DBF_ERR_LOCK_TIMEOUT		1001L	/* timeout while locking a record */
#define DBF_ERR_LOCK_FAILURE		1002L	/* failed to lock a record */
#define DBF_ERR_INDEX_TIMEOUT		1003L	/* timeout while locking an index */
#define DBF_ERR_INDEX_LOCK			1004L	/* failed to lock an index for change */
#define DBF_ERR_REC_NOT_LOCKED	1005L /* tried to unlock a not locked record*/
#define DBF_ERR_REC_NOT_VALID		1006L	/* tried to skip to a deleted record */
#define DBF_ERR_NO_INDEX			1007L	/* no index is active */
#define DBF_ERR_REC_CHANGED		1008L	/* failed to save changes,
													 *	record is changed in meanwhile */
#define DBF_ERR_RELATED_SERVER	1009L /* failure in related server */
#define DBF_ERR_RELATION_LOOP		1010L	/* loop detected in DBF_SetRelation() */

/* This values may be used for the DBF_LockRecord() function as timeout...
 */
#define DBF_WAIT_FOREVER	0x7FFFFFFF		/* wait (nearly) forever */
#define DBF_WAIT_NONE		0L					/* don't wait */
#define DBF_WAIT_DEFAULT	LOCK_TIMEOUT	/* timeout equal to lock-timeout
														 * of indexes (750 ticks == 15 sec)*/
/* A combination of flags that are cleared, if the current record is changed...
 */
#define DSF_RECORD_CHANGED (DSF_NEWROW | DSF_MEMO_CHANGED | DSF_MEMO_READ| \
									DSF_ROWCHANGED | DSF_REC_DELETED | DSF_REC_CACHED)

#endif			/* _DATABASE_DATATABLE_H_ */