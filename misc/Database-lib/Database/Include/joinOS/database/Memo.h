#ifndef _DATABASE_MEMO_H_
#define _DATABASE_MEMO_H_ 1

/* Memo.h
 *
 * The memo is a special file attached to a DataTable and used to store strings
 * of variable length, i.e. the contents of a column of the type DC_TEXT.
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
/*																									*/
/*								Structures used for memo-files							*/
/*																									*/
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
	BPTR fh;						/* FileHandle of the memofile */
	DOUBLELONG *addr;			/* pointer to a storage with an address of a memo
									 * stored in the memofile (for custom use) */
	struct MemoBlock emb;	/* used as buffer */
};

#define DBF_MEMOID	MAKE_ID('D','B','M',' ')	/* first long in file */

#endif		/* _DATABASE_MEMO_H_ */