@DATABASE "DataServer.h"
@MASTER   "include:joinOS/database/DataServer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-May-04 21:40:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "DataServer.h"

@{"DataServer.h" LINK File}


@{b}Structures@{ub}

@{"DataColumn" LINK "DataServer.h/File" 74}  @{"DataServer" LINK "DataServer.h/File" 95}


@{b}#defines@{ub}

@{"DC_BYTE" LINK "DataServer.h/File" 134}               @{"DC_CHAR" LINK "DataServer.h/File" 148}              @{"DC_DATE" LINK "DataServer.h/File" 142}
@{"DC_DOUBLE" LINK "DataServer.h/File" 139}             @{"DC_DOUBLELONG" LINK "DataServer.h/File" 137}        @{"DC_FLOAT" LINK "DataServer.h/File" 138}
@{"DC_LOGIC" LINK "DataServer.h/File" 146}              @{"DC_LONG" LINK "DataServer.h/File" 136}              @{"DC_NUMERIC" LINK "DataServer.h/File" 140}
@{"DC_TEXT" LINK "DataServer.h/File" 149}               @{"DC_TIME" LINK "DataServer.h/File" 144}              @{"DC_UNKNOWN" LINK "DataServer.h/File" 133}
@{"DC_USER" LINK "DataServer.h/File" 154}               @{"DC_VARCHAR" LINK "DataServer.h/File" 152}           @{"DC_WORD" LINK "DataServer.h/File" 135}
@{"DCF_AUTOVALUE" LINK "DataServer.h/File" 248}         @{"DCF_CHANGED" LINK "DataServer.h/File" 254}          @{"DCF_HIDDEN" LINK "DataServer.h/File" 251}
@{"DCF_NOT_EMPTY" LINK "DataServer.h/File" 253}         @{"DCF_OWNBUFFER" LINK "DataServer.h/File" 250}        @{"DCF_READONLY" LINK "DataServer.h/File" 247}
@{"DS_ADDCOLUMN" LINK "DataServer.h/File" 159}          @{"DS_ALLOWSELECTION" LINK "DataServer.h/File" 206}    @{"DS_AVAILABLEORDER" LINK "DataServer.h/File" 191}
@{"DS_CLEARSELECTION" LINK "DataServer.h/File" 204}     @{"DS_Columns" LINK "DataServer.h/File" 125}           @{"DS_CURRENTCOLUMN" LINK "DataServer.h/File" 186}
@{"DS_CURRENTKEY" LINK "DataServer.h/File" 194}         @{"DS_CURRENTROW" LINK "DataServer.h/File" 185}        @{"DS_DISPOSE" LINK "DataServer.h/File" 211}
@{"DS_ERR_MAYOR" LINK "DataServer.h/File" 222}          @{"DS_ERR_MINOR" LINK "DataServer.h/File" 224}         @{"DS_ERR_NO_ERROR" LINK "DataServer.h/File" 216}
@{"DS_ERR_NO_MEMORY" LINK "DataServer.h/File" 217}      @{"DS_ERR_NO_MORE_DATA" LINK "DataServer.h/File" 218}  @{"DS_ERR_OP_NOT_KNOWN" LINK "DataServer.h/File" 220}
@{"DS_ERR_WRITE_PROTECT" LINK "DataServer.h/File" 227}  @{"DS_ERR_WRONG_ARG" LINK "DataServer.h/File" 221}     @{"DS_FINDCOLUMN" LINK "DataServer.h/File" 166}
@{"DS_FIRSTROW" LINK "DataServer.h/File" 176}           @{"DS_FIRSTSELECTED" LINK "DataServer.h/File" 202}     @{"DS_GETCOLUMNDATA" LINK "DataServer.h/File" 168}
@{"DS_GETORDER" LINK "DataServer.h/File" 189}           @{"DS_GETRAWDATA" LINK "DataServer.h/File" 170}        @{"DS_GOTOCOLUMN" LINK "DataServer.h/File" 163}
@{"DS_GOTOROW" LINK "DataServer.h/File" 173}            @{"DS_INSERTROW" LINK "DataServer.h/File" 180}         @{"DS_ISSELECTED" LINK "DataServer.h/File" 205}
@{"DS_KEYEXPRESSION" LINK "DataServer.h/File" 192}      @{"DS_KEYLENGTH" LINK "DataServer.h/File" 193}         @{"DS_LASTROW" LINK "DataServer.h/File" 177}
@{"DS_MOVECOLUMN" LINK "DataServer.h/File" 161}         @{"DS_Name" LINK "DataServer.h/File" 129}              @{"DS_NEXTCOLUMN" LINK "DataServer.h/File" 164}
@{"DS_NEXTROW" LINK "DataServer.h/File" 174}            @{"DS_NEXTSELECTED" LINK "DataServer.h/File" 203}      @{"DS_NUM_OF_COLUMNS" LINK "DataServer.h/File" 184}
@{"DS_NUM_OF_ROWS" LINK "DataServer.h/File" 183}        @{"DS_ORDERASCEND" LINK "DataServer.h/File" 190}       @{"DS_PREVCOLUMN" LINK "DataServer.h/File" 165}
@{"DS_PREVROW" LINK "DataServer.h/File" 175}            @{"DS_ReadOnly" LINK "DataServer.h/File" 127}          @{"DS_REMOVECOLUMN" LINK "DataServer.h/File" 160}
@{"DS_REMOVEROW" LINK "DataServer.h/File" 181}          @{"DS_SEEK" LINK "DataServer.h/File" 197}              @{"DS_SEEKNEXT" LINK "DataServer.h/File" 198}
@{"DS_SELECTROW" LINK "DataServer.h/File" 201}          @{"DS_SETCOLUMNDATA" LINK "DataServer.h/File" 169}     @{"DS_SETORDER" LINK "DataServer.h/File" 188}
@{"DS_SETRAWDATA" LINK "DataServer.h/File" 171}         @{"DS_SKIPROWS" LINK "DataServer.h/File" 178}          @{"DS_SOFTSEEK" LINK "DataServer.h/File" 199}
@{"DS_SoftSeek" LINK "DataServer.h/File" 128}           @{"DS_StructSize" LINK "DataServer.h/File" 126}        @{"DS_TagBase" LINK "DataServer.h/File" 123}
@{"DS_UPDATE" LINK "DataServer.h/File" 209}             @{"DSF_DESCEND" LINK "DataServer.h/File" 242}          @{"DSF_NEWROW" LINK "DataServer.h/File" 243}
@{"DSF_READONLY" LINK "DataServer.h/File" 238}          @{"DSF_ROWCHANGED" LINK "DataServer.h/File" 239}       @{"DSF_SOFTSEEK" LINK "DataServer.h/File" 241}

@ENDNODE
@NODE File "DataServer.h"
#ifndef _DATABASE_DATASERVER_H_
#define _DATABASE_DATASERVER_H_ 1

/* DataServer.h
 *
 * A DataServer is the base class used as interface to any kind of data-
 * structure which is build by several rows of equal columns of data (a table).
 *
 * It has function to access the structure of the single rows, and to store and
 * retrieve any row of data in any order.
 *
 * There is an interface to define the order of the rows for sequentiell
 * access and to define the structure of the rows.
 *
 * These functions may be overwritten depending on the underlying "device",
 * which delivers the data (i.e. a SQL-Server).
 *
 * Per default all data is stored in an array of rows, each represents an array
 * of columns.
 *
 * General attributes:
 *
 *    number of rows
 *    structure of a row -> structure of the columns
 *    columns per row
 *    current row
 *
 * General operations:
 *    define structure of a row -> define structure of a column
 *    get structure of a row -> get structure of a column
 *    set order of columns
 *    set order of rows (order by one or more columns, ascend or descend)
 *    access row by number of the row
 *    access next row
 *    access previous row
 *    access any column of the current row by its number
 *    access next column of current row
 *    (access previous column of current row)
 *
 * The operations and attributes of a DataServer are accessed through an
 * unique interface, the functions that are accessed through that interface
 * are depending on the underlying "device" and are exchangeable.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _TAGITEMS_H_
#include <joinOS/misc/TagItems.h>
#endif

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDos.h>
#endif

#ifndef _DATABASE_NUMERIC_H_
#include <joinOS/database/Numeric.h>
#endif

#ifndef _DATABASE_FUNCTIONTYPES_H_
#include <joinOS/database/FunctionTypes.h>
#endif

/***************************************************************************/
/*                                                                         */
/*                      Structures used for DataServer                     */
/*                                                                         */
/***************************************************************************/

/* Base structure of a DataColumn.
 * The string referenced by this structure are allocated using joinOS.libraries
 * AllocVector() function...
 */
struct DataColumn             /* size 44 bytes, longword aligned */
{
   STRPTR Name;               /* Name of the column (name of the datafield),
                               * NULL or empty strings are not allowed */
   STRPTR Caption;            /* a caption that should be used for this column,
                               * may be the same string as used for 'Name' */
   STRPTR HelpText;           /* a short descriptive text for that column,
                               * may be NULL */
   UWORD Flags;               /* see below for defines */
   UWORD Type;                /* Type identifier, see below for defines */
   ULONG Length;              /* length of the data (may depend on type) */
   ULONG Decimals;            /* only used with numeric values */
   ULONG Position;            /* position of the column in the row */
   UBYTE *Buffer;             /* buffer used for type-convertion */
   @{"DC_CONVERT" LINK "FunctionTypes.h/File" 32} Convert;        /* type-convertion function */
   @{"DC_REVERT" LINK "FunctionTypes.h/File" 44} Revert;          /* type-convertion function */
   @{"struct DataServer" LINK File 95} *Server; /* pointer back to the owning DataServer */
};

/* Base structure of a DataServer...
 */
struct DataServer                /* size 52 bytes, longword aligned */
{
   ULONG StructSize;             /* Size of the structure */
   ULONG NumColumns;             /* number of columns of each row */
   ULONG CurrentColumn;          /* number of the current column */
   @{"struct DataColumn" LINK File 74} *Columns;   /* pointer to structure array of columns */
   ULONG Flags;                  /* flags specifying the state of the server */
   ULONG LastError;              /* errorcode, see below for defines */
   @{"DS_UPDATE_FCT" LINK "FunctionTypes.h/File" 22} Update;         /* function ptr. to update-function */
   APTR Device;                  /* underlying "device", delivering the data */
   STRPTR Name;                  /* optional name of the DataServer */
   ULONG NumRows;                /* number of rows, that are available */
   ULONG CurrentRow;             /* number of the current row */
   APTR Rows;                    /* data of all rows */
   APTR Order;                   /* the current order of the rows */
};

/* Include the function-type definitions here, so the above structures
 * are known by the following includefile at the moment of inclusion...
 */
/***************************************************************************/
/*                                                                         */
/*                      Defines used for DataServer                        */
/*                                                                         */
/***************************************************************************/

/* Tags for creation of DataServers...
 */
#define DS_TagBase        TAG_USER + 0x80000

#define DS_Columns      DS_TagBase + 1 /* the initial DataColumns */
#define DS_StructSize   DS_TagBase + 2 /* size of the DataServer structure */
#define DS_ReadOnly     DS_TagBase + 3 /* DataServer is read-only */
#define DS_SoftSeek     DS_TagBase + 4 /* soft-seek is enabled */
#define DS_Name         DS_TagBase + 5 /* the name of the DataServer */

/* Default types of DataColumns...
 */
#define DC_UNKNOWN      0  /* unknown type, ignored */
#define DC_BYTE         1  /* a single byte, DataColumn.Length = 1 */
#define DC_WORD         2  /* a word (16 bit), DataColumn.Length = 2 */
#define DC_LONG         3  /* a longword (32 bit), DataColumn.Length = 4 */
#define DC_DOUBLELONG   4  /* a "longlong" (64 bit), DataColumn.Length = 8 */
#define DC_FLOAT        5  /* float single precision, DataColumn.Length = 4 */
#define DC_DOUBLE       6  /* float double precision, DataColumn.Length = 8 */
#define DC_NUMERIC      7  /* fixed point arithmetic value, uses 'Decimals'
                            * DataColumn.Length <= 19 */
#define DC_DATE         8  /* date "20031104", after the year 1582 A.D.,
                            * DataColumn.Length = 8 */
#define DC_TIME         9  /* time, milli-seconds since 0:00:00,
                            * DataColumn.Length = 4 */
#define DC_LOGIC        10 /* boolean value, 'true' ('T') or 'false' ('F'),
                            * DataColumn.Length = 1 */
#define DC_CHAR         11 /* string fixed length */
#define DC_TEXT         12 /* string, variable length, NUL-terminated,
                            * DataColumn.Length = 8,1. longword = page number
                            *                   2. longword = offset in page */
#define DC_VARCHAR      13 /* string, variable length, max. DataColumn.Length
                            * characters */
#define DC_USER      1000  /* if you create own datatypes use a value greater
                            * or equal to this type */

/* Default operations, every DataServer supports...
 */
#define DS_ADDCOLUMN       0x00000001  /* add a new column to the DataServer */
#define DS_REMOVECOLUMN    0x00000002  /* remove a column */
#define DS_MOVECOLUMN      0x00000003  /* rearrange the order of the columns */

#define DS_GOTOCOLUMN      0x00000010  /* access any column by ordernumber */
#define DS_NEXTCOLUMN      0x00000020  /* get next column */
#define DS_PREVCOLUMN      0x00000030  /* get previous column */
#define DS_FINDCOLUMN      0x00000040  /* goto column, specified by name */

#define DS_GETCOLUMNDATA   0x00000100  /* get the data of the column */
#define DS_SETCOLUMNDATA   0x00000200  /* change the data of the column */
#define DS_GETRAWDATA      0x00000300  /* get the data of the column */
#define DS_SETRAWDATA      0x00000400  /* change the data of the column */

#define DS_GOTOROW         0x00001000  /* go to any row by its number */
#define DS_NEXTROW         0x00002000  /* go to next row */
#define DS_PREVROW         0x00003000  /* go to previous row */
#define DS_FIRSTROW        0x00004000  /* go to first row */
#define DS_LASTROW         0x00005000  /* go to last row */
#define DS_SKIPROWS        0x00008000  /* skip any number of rows */

#define DS_INSERTROW       0x00006000  /* add a new row to the DataServer */
#define DS_REMOVEROW       0x00007000  /* remove the current row */

#define DS_NUM_OF_ROWS     0x00010000  /* get number of accessable rows */
#define DS_NUM_OF_COLUMNS  0x00020000  /* get number of accessable columns */
#define DS_CURRENTROW      0x00030000  /* get the number of the current row */
#define DS_CURRENTCOLUMN   0x00040000  /* get a pointer to the current col. */

#define DS_SETORDER        0x00100000  /* change the order of the rows */
#define DS_GETORDER        0x00200000  /* get the order of the rows */
#define DS_ORDERASCEND     0x00300000  /* order the rows ascend or descend */
#define DS_AVAILABLEORDER  0x00400000  /* show the available orders */
#define DS_KEYEXPRESSION   0x00500000  /* get the key-expression of the order*/
#define DS_KEYLENGTH       0x00600000  /* get the length of a keyvalue */
#define DS_CURRENTKEY      0x00700000  /* get the keyvalue of the current
                                        * record in the active index */

#define DS_SEEK            0x01000000  /* seek to an ordered value */
#define DS_SEEKNEXT        0x02000000  /* seek to next value (softseek only) */
#define DS_SOFTSEEK        0x03000000  /* enable/disable softseek */

#define DS_SELECTROW       0x04000000  /* (un)select the current row */
#define DS_FIRSTSELECTED   0x05000000  /* skip to first selected row */
#define DS_NEXTSELECTED    0x06000000  /* skip to next selected row */
#define DS_CLEARSELECTION  0x07000000  /* clear all selections made */
#define DS_ISSELECTED      0x08000000  /* Is the current row selected ? */
#define DS_ALLOWSELECTION  0x09000000  /* evaluate if DataServer supports
                                        * selection */

#define DS_UPDATE          0x70000000  /* synchronize the contents of the
                                        * DataServer and the "device" */
#define DS_DISPOSE         0x80000000  /* terminate connection to "device" and
                                        * free all resources */

/* Error-codes for failures occured during DS_DoUpdate()...
 */
#define DS_ERR_NO_ERROR       0L /* no error occured */
#define DS_ERR_NO_MEMORY      1L /* not enough free memory available */
#define DS_ERR_NO_MORE_DATA   2L /* tried to select a row or column that
                                  * is out of range */
#define DS_ERR_OP_NOT_KNOWN   3L /* specified operation is not supported */
#define DS_ERR_WRONG_ARG      4L /* wrong argument passed to DataServer */
#define DS_ERR_MAYOR          5L /* unknown mayor error occured -> DataServer
                                  * is corrupt (Alert(), terminate) */
#define DS_ERR_MINOR          6L /* unknown minor error occured -> DataServer
                                  * is corrupt, but may still work (ignore) */

#define DS_ERR_WRITE_PROTECT  7L /* column/server is write protected */

/* The error-codes in the following ranges are reserved:
 * 1000 to 1999 - reserved for the DataTable
 * 2000 to 2999 - reserved for the Index
 * 9000 to 9999 - for user-applications (i.e. NOT reserved by the system)
 */

/* Flag defines for 'DataServer.Flags'...
 * Flag-values above 0x00008000 are for use in subclasses.
 */
#define DSF_READONLY    0x00000001  /* the DataServer is readonly */
#define DSF_ROWCHANGED  0x00000002  /* the data of the current row has
                                     * been changed */
#define DSF_SOFTSEEK    0x00000004  /* use soft-seek */
#define DSF_DESCEND     0x00000008  /* use descend order */
#define DSF_NEWROW      0x00000010  /* new row added to the DataServer */

/* Flag defines for 'DataColumn.Flags'...
 */
#define DCF_READONLY    0x0001   /* the DataColumn is readonly */
#define DCF_AUTOVALUE   0x0002   /* value is created from "device",
                                  * don't change */
#define DCF_OWNBUFFER   0x0004   /* 'Buffer' needs to be freed on dispose */
#define DCF_HIDDEN      0x0008   /* this DataColumn is not visible in a
                                  * Browser by default */
#define DCF_NOT_EMPTY   0x0010   /* NULL-values are not allowed */
#define DCF_CHANGED     0x0020   /* this column has been changed */

#endif         /* _DATABASE_DATASERVER_H_ */
@ENDNODE
