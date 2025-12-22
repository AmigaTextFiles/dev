#ifndef _DATABASE_PROTOS_H_
#define _DATABASE_PROTOS_H_ 1

/* DatabaseProtos.h
 *
 * The prototypes of the functions in the database.library.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _DATABASE_FUNCTIONTYPES_H_
#include <joinOS/database/FunctionTypes.h>
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

#ifndef _DATABASE_MEMO_H_
#include <joinOS/database/Memo.h>
#endif

extern struct Library *DatabaseBase;

#ifdef _AMIGA
#include <joinOS/pragmas/DatabasePragma.h>
#endif

/***************************************************************************/
/*																									*/
/*									functions for DataServers								*/
/*																									*/
/***************************************************************************/

/* The DataServer is the baseclass for accessing any data arranged in rows
 * of several equal columns of different datatypes.
 * Usually you will not call any of the functions that are for DataServers
 * direct, instead you will use subclasses of the DataServer and the according
 * functions, e.g. DataTables.
 * The only exception is the main dispatching function DS_DoUpdate(), that is
 * the dispatcher used for ANY subclass of the DataServer.
 */

/* --- function for creating a DataServer -------------------------------- */

struct DataServer *DS_InitA (APTR unused, struct TagItem *tagList);

/* --- private functions for accessing a DataServer ---------------------- */

BOOL DS_AddColumns (struct DataServer *server,
								struct DataColumn *template, ULONG numColumns);
BOOL DS_RemoveColumns (struct DataServer *server,
											ULONG firstColumn, ULONG numColumns);

/* --- default operation-processing function of all DataServers ---------- */

/* This function is called implicit, whenever the dispatcher DS_DoUpdate() is
 * called with an operation not handled by the subclass of the DataServer.
 * NEVER call this function direct from user-applications code.
 */
BOOL DS_Update (struct DataServer *server, ULONG operation, APTR arg);

/* --- main dispatcher of DataServers ------------------------------------ */

/* This function has to be used to send any operation (see "DataServer.h" for
 * a list of defined operations) to a DataServer resp. its subclasses. This
 * function will descide which operation-processing function needs to be
 * called for the specified DataServer and redirects the operation to that
 * function.
 */
BOOL DS_DoUpdate (struct DataServer *server, ULONG operation, APTR arg);

/***************************************************************************/
/*																									*/
/*							functions for accessing DataColumns							*/
/*																									*/
/***************************************************************************/

/* DataColumns are usually handled by the DataServer, for easier localization
 * the following functions may be used to pass localized strings to the
 * DataColumn.
 */
BOOL DC_SetCaption (struct DataColumn *column, STRPTR caption);
BOOL DC_SetHelpText (struct DataColumn *column, STRPTR helpText);

/* --- Basic datatype convertion ----------------------------------------- */

/* These are the default convertion function used to convert the contents of
 * any datacolumn into a human-readable format and vice-verse.
 * Don't call this functions direct, let the DataServer do the convertion
 * for you (he knows best, which convertion function to be used).
 */
BOOL DC_DefaultConvert (struct DataColumn *column, APTR value);
BOOL DC_DefaultRevert (struct DataColumn *column, STRPTR value, APTR raw);

/***************************************************************************/
/*																									*/
/*									functions for DataTables								*/
/*																									*/
/***************************************************************************/

/* --- function for creation of a DataTable ------------------------------ */

/* NOTE: A DataTable is disposed via sending the operation DS_DISPOSE to
 *			its dispatcher.
 */
struct DataServer *DBF_InitA (APTR unused, struct TagItem *tagList);

/* --- the operation-processing function of a DataTable ------------------ */

/* All operations that are send to a DataServers dispatcher are redirected to
 * this function, whenever the DataServer is a DataTable, i.e. if you call
 * the function DS_DoUpdate(), this function will be called, if the specified
 * pointer to a DataServer structure is accroding to a DataTable.
 * NEVER call this function direct from user-applications. The only was to
 * access it is via DS_DoUpdate(). You may call this function as default
 * function, if you write an own DataServer subclass with an own operation-
 * processing-function.
 */
BOOL DBF_Update (struct DataServer *server, ULONG operation, APTR arg);

/*	--- functions for administrating DataTables --------------------------- */

BOOL DBF_Pack (struct DataServer *server, REINDEX_PROGRESS fct, APTR userData);
BOOL DBF_ReIndex (struct DataServer *server, STRPTR order,
													REINDEX_PROGRESS fct, APTR userData);

/* --- functions for relations between two DataTables	-------------------- */

BOOL DBF_ClearRelation (struct DataServer *client);
BOOL DBF_SetRelation (struct DataServer *server, struct DataServer *client,
																	STRPTR order, STRPTR expr);

/* --- functions for manipulating DataTables	----------------------------- */

/* These functions are explicit for DataTables. Don't access them with a
 * pointer to a DataServer structure that doesn't belong to a DataTable.
 */
BOOL DBF_UnLockRecord (struct DataServer *server, ULONG recNo);
BOOL DBF_LockRecord (struct DataServer *server, ULONG recNo,
												ULONG mode, ULONG timeout);

BOOL DBF_AddAlias (struct DataServer *server, STRPTR alias, STRPTR index);
BOOL DBF_RemoveAlias (struct DataServer *server, STRPTR alias);

BOOL DBF_AddOrder (struct DataServer *server, struct IDXHeader *index);
struct IDXHeader *DBF_GetOrder (struct DataServer *server, STRPTR name);
struct IDXHeader *DBF_RemoveOrder (struct DataServer *server, STRPTR name);

BOOL DBF_SetAccessMode (struct DataServer *server, BOOL exclusive);
ULONG DBF_SetLockMode (struct DataServer *server, ULONG lockMode);
BOOL DBF_ShowDeleted (struct DataServer *server, BOOL deleted);

/* --- private functions for DataTables	-------------------------------- */

/* These functions are called from the DataTable itself and should not be
 * called direct from user-applications.
 */
BOOL DBF_ClearRecord (struct DataTable *dbTable);
BOOL DBF_ReadMemo (struct DataColumn *column, APTR memoAddr);
BOOL DBF_WriteMemo (struct DataColumn *column, STRPTR memoText, APTR raw);

/***************************************************************************/
/*																									*/
/*									functions for indexes									*/
/*																									*/
/***************************************************************************/

/* --- function for parsing key-expressions ------------------------------ */

/* These are the functions required for parsing a key-expression. The parser is
 *	case-insensitive, so the characters of an expression can be written in any
 * case.
 *
 *	A key-expression could reference several fields of a DataTable. The fields
 *	have to be of the types:
 *		DC_BYTE
 *		DC_WORD
 *		DC_LONG
 *		DC_DOUBLELONG
 *		DC_TIME
 *		DC_DATE
 *		DC_LOGIC
 *		DC_CHAR
 *		DC_DOUBLE
 *		DC_FLOAT
 *		DC_NUMERIC
 *
 * If DataColumns of the type DC_FLOAT or DC_DOUBLE are indexed, these indexes
 *	can not be combined with other fields, i.e. the index will only work on this
 * single column, the expression will be just the name of the indexed column.
 *
 * If DC_NUMERIC DataColumns are indexed, this value is handled as DOUBLELONG
 * value, i.e. the comma is left away. Therefor you should not use this kind of
 * datacolumn for a combined index.
 * E.g.: The numeric value "-123.45" of a DataColumn of the length of 10 and
 * with 3 decimals would result to the DOUBLELONG: "-123450".
 *
 * The following functions may occure in a key-expression (except in the
 * expression of indexes that access DC_FLOAT or DC_DOUBLE DataColumns):
 *		Str() - generate a decimal string according to an integer-value or a time
 *					The length of the resulting string is per default (and maximum)
 *					22 characters for integer-values or 8 characters for a time, a
 *					different size could be specified following the
 *					argument of the function, separated by a colon.
 *		StrZero() - generate a string according to an integer-value or a time
 *					with leading zeros. The length could be specified as for the
 *					function STR().
 *		Val() - convert a decimal string to an integer-value
 *		TToS() - convert a time-value into a human-readable string
 *		DToS() - convert a date-value into a human-readable string
 *		LToC() - convert a boolean value into a character ('T' for TRUE,
 *					'F' for FALSE)
 *		Upper() - convert all characters to upper case
 *		Lower() - convert all characters to lower case
 *
 *	And the following operation is defined:
 *		+ - if placed between two strings, these strings are concatenated,
 *				if placed between two integers, these are added;
 *				other types cannot be combined using this operation, you have
 *				to convert these values to strings or integers before adding them.
 */
UWORD IDX_KeyLength (struct DataServer *server, UBYTE *keyExpr);
LONG IDX_PreCompileExpression (struct DataServer *server, STRPTR keyExpr,
															UBYTE *buffer, ULONG bufSize);

BOOL IDX_GetKeyValue (struct DataServer *server, APTR keyValue, UBYTE *expr);
BOOL IDX_EvalExpressionA (struct DataServer *server, STRPTR expr,
															APTR key, ULONG *args);
BOOL IDX_EvalExpressionB (struct DataServer *server, UBYTE *expr,
														APTR key, STRPTR *args);

/* --- functions for creation and disposage of indexes ------------------- */

struct IDXHeader *IDX_InitA (APTR unused, struct TagItem *tagList);
void IDX_Dispose (struct IDXHeader *idh);

/* --- functions for accessing an index ---------------------------------- */

BOOL IDX_StartTransaction (struct IDXHeader *idh, LONG accessType);
BOOL IDX_EndTransaction (struct IDXHeader *idh, LONG accessType);

BOOL IDX_ValidKey (struct IDXHeader *ihd);
BOOL IDX_FindKey (struct IDXHeader *ihd, struct DataServer *server);

ULONG IDX_Seek (struct IDXHeader *ihd, APTR key, BOOL softSeek);
ULONG IDX_SeekNext (struct IDXHeader *ihd, APTR key, BOOL softSeek);

ULONG IDX_SkipTop (struct IDXHeader *ihd);
ULONG IDX_SkipBottom (struct IDXHeader *ihd);
ULONG IDX_SkipNext (struct IDXHeader *ihd, ULONG numKeys);
ULONG IDX_SkipPrevious (struct IDXHeader *ihd, ULONG numKeys);

BOOL IDX_SetScope (struct IDXHeader *ihd, APTR topScope, APTR bottomScope);
ULONG IDX_KeyCount (struct IDXHeader *ihd);

/*	--- functions for changing an index	----------------------------------- */

BOOL IDX_InsertKey (struct IDXHeader *ihd, struct DataServer *server);
BOOL IDX_RemoveKey (struct IDXHeader *ihd);
BOOL IDX_ClearIndex (struct IDXHeader *ihd);
BOOL IDX_ReIndex (struct IDXHeader *ihd, struct DataServer *server,
										REINDEX_PROGRESS fct, APTR userdata);

/***************************************************************************/
/*																									*/
/*								functions for memo-files									*/
/*																									*/
/***************************************************************************/

/* Usually memo-files are created and handled direct by the DataTables, so
 * there is normally no need to call any of these functions. Except if you
 * create a new subclass of the DataServer/DataTable.
 */

/* --- functions for creation and disposage of memo-files --------------- */

struct MemoFile *DBM_OpenMemo (STRPTR fileName);
void DBM_CloseMemo (struct MemoFile *mf);

/*	--- functions for manipulating memo-files ---------------------------- */

BOOL DBM_LockMemo (struct MemoFile *mf);
BOOL DBM_UnLockMemo (struct MemoFile *mf);

BOOL DBM_ClearMemo (struct MemoFile *mf, DOUBLELONG *addr);
APTR DBM_ReadMemo (struct MemoFile *mf, DOUBLELONG *addr);
BOOL DBM_WriteMemo (struct MemoFile *mf, DOUBLELONG *addr,
												APTR memo, ULONG size);

/***************************************************************************/
/*																									*/
/*							string-manipulation-functions									*/
/*																									*/
/***************************************************************************/

/* Functions used to parse strings, there may be according functions defined
 * in <string.h>.
 */
ULONG AtChr (UBYTE *string, UBYTE character, ULONG slen);
ULONG RAtChr (UBYTE *string, UBYTE character, ULONG slen);
LONG SkipChars (UBYTE *string, UBYTE character, LONG slen);

/***************************************************************************/
/*																									*/
/*								convertion-functions											*/
/*																									*/
/***************************************************************************/

/* The following functions are used to convert the data stored in DataColumns
 * into human-readable format and vice-versa. They are also used for creating
 * values that could be used in key-expressions that combine the contents of
 * two or more columns.
 */
UBYTE *STR (DOUBLELONG *val, UBYTE padByte, UWORD slen);

BOOL TToS (ULONG timeVal, UBYTE *timeStr);
BOOL SToT (UBYTE *timeStr, ULONG *timeVal);
BOOL DToS (APTR date, UBYTE *dateStr);
BOOL SToD (UBYTE *dateStr, APTR date);
BOOL LToS (APTR logic, UBYTE *str);
BOOL SToL (UBYTE *str, APTR logic);

BOOL Float2Double (APTR fVal, APTR dVal);

/***************************************************************************/
/*																									*/
/*										useful macros											*/
/*																									*/
/***************************************************************************/

#define Logic2Bool(logic) ((logic)=='T'?TRUE:FALSE)

#ifndef Upper
#define Upper(c) (((((c)>96)&&((c)<123))||(((c)>223)&&((c)<255)))?(c)&223:(c))
#endif

#ifndef Lower
#define Lower(c) (((((c)>64)&&((c)<91))||(((c)>191)&&((c)<223)))?(c)|32:(c))
#endif

/***************************************************************************/
/*																									*/
/*							functions located in link library							*/
/*																									*/
/***************************************************************************/

/* Functions for accessing the contents of DataColumn by their name...
 */
BOOL DBF_FieldPut (struct DataServer *server, STRPTR field, STRPTR data);
BOOL DBF_FieldPutRaw (struct DataServer *server, STRPTR field, APTR rawData);
BOOL DBF_FieldGet (struct DataServer *server, STRPTR field, STRPTR *data);
BOOL DBF_FieldGetRaw (struct DataServer *server, STRPTR field, APTR *rawdata);

/* functions for evaluating a key-expression
 */
ULONG IDX_CountFields (STRPTR expr);
BOOL IDX_EvalExpression (struct DataServer *ds, STRPTR expr, APTR key,...);

#endif		/* _DATABASE_PROTOS_H_ */