@DATABASE "Memo.h"
@MASTER   "include:joinOS/database/Memo.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-May-04 21:40:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "Memo.h"

@{"Memo.h" LINK File}


@{b}Structures@{ub}

@{"MemoBlock" LINK "Memo.h/File" 33}  @{"MemoFile" LINK "Memo.h/File" 42}


@{b}#defines@{ub}

@{"DBF_MEMOID" LINK "Memo.h/File" 50}

@ENDNODE
@NODE File "Memo.h"
#ifndef _DATABASE_MEMO_H_
#define _DATABASE_MEMO_H_ 1

/* Memo.h
 *
 * The memo is a special file attached to a DataTable and used to store strings
 * of variable length, i.e. the contents of a column of the type @{"DC_TEXT" LINK "DataServer.h/File" 149}.
 *
 * It is structured like an memory-pool, i.e. it is a large block of several
 * pages a 1024 bytes, containing any number of strings and unused blocks. The
 * unused blocks are linked to a list, the first block is referenced by the
 * two longwords of the file that are following the filetype and version
 * longwords.
 * Every empty block contains a reference to the next empty block and the size
 * of the block itself.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDos.h>
#endif

/***************************************************************************/
/*                                                                         */
/*                      Structures used for memo-files                     */
/*                                                                         */
/***************************************************************************/

/* This structure is found at the begin of every entry into a memo-file
 */
struct MemoBlock
{
   ULONG Page;
   ULONG Offset;
   ULONG Size;
};

/* Structure used to access a memo-file...
 */
struct MemoFile
{
   BPTR fh;                /* FileHandle of the memofile */
   DOUBLELONG *addr;       /* pointer to a storage with an address of a memo
                            * stored in the memofile (for custom use) */
   @{"struct MemoBlock" LINK File 33} emb;   /* used as buffer */
};

#define DBF_MEMOID   @{"MAKE_ID" LINK "Index.h/File" 145}('D','B','M',' ')   /* first long in file */

#endif      /* _DATABASE_MEMO_H_ */
@ENDNODE
