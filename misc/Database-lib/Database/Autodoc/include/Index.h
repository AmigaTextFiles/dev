@DATABASE "Index.h"
@MASTER   "include:joinOS/database/Index.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-May-04 21:40:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "Index.h"

@{"Index.h" LINK File}


@{b}Structures@{ub}

@{"IDXAlias" LINK "Index.h/File" 130}  @{"IDXFileHeader" LINK "Index.h/File" 34}  @{"IDXHeader" LINK "Index.h/File" 71}  @{"IDXKeyEntry" LINK "Index.h/File" 120}  @{"IDXMemPage" LINK "Index.h/File" 105}  @{"IDXSFH" LINK "Index.h/File" 58}


@{b}#defines@{ub}

@{"DBF_INDEXFILEID" LINK "Index.h/File" 149}         @{"IDX_ALIAS" LINK "Index.h/File" 176}              @{"IDX_CUSTOM" LINK "Index.h/File" 171}
@{"IDX_Custom" LINK "Index.h/File" 163}              @{"IDX_DESCEND" LINK "Index.h/File" 170}            @{"IDX_Descend" LINK "Index.h/File" 162}
@{"IDX_ERR_BAD_EXPRESSION" LINK "Index.h/File" 208}  @{"IDX_ERR_DUPLICATE_KEY" LINK "Index.h/File" 202}  @{"IDX_ERR_NO_KEY" LINK "Index.h/File" 204}
@{"IDX_EXCLUSIVE" LINK "Index.h/File" 173}           @{"IDX_Exclusive" LINK "Index.h/File" 164}          @{"IDX_Expression" LINK "Index.h/File" 157}
@{"IDX_FileName" LINK "Index.h/File" 156}            @{"IDX_LOCKED" LINK "Index.h/File" 178}             @{"IDX_Name" LINK "Index.h/File" 155}
@{"IDX_PageSize" LINK "Index.h/File" 159}            @{"IDX_PG_CHANGED" LINK "Index.h/File" 182}         @{"IDX_READ" LINK "Index.h/File" 187}
@{"IDX_RESERVED" LINK "Index.h/File" 177}            @{"IDX_Server" LINK "Index.h/File" 158}             @{"IDX_TagBase" LINK "Index.h/File" 153}
@{"IDX_UNIQUE" LINK "Index.h/File" 169}              @{"IDX_Unique" LINK "Index.h/File" 161}             @{"IDX_WRITE" LINK "Index.h/File" 188}
@{"IDX_WRITEBEHIND" LINK "Index.h/File" 175}         @{"IDX_WriteBehind" LINK "Index.h/File" 165}        @{"INDEXHEADER_SIZE" LINK "Index.h/File" 192}
@{"LOCK_TIMEOUT" LINK "Index.h/File" 193}            @{"MAKE_ID()" LINK "Index.h/File" 145}              

@ENDNODE
@NODE File "Index.h"
#ifndef _DATABASE_INDEX_H_
#define _DATABASE_INDEX_H_ 1

/* Index.h
 *
 * Implementation of an index used to order records of a DataBase
 */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _LISTS_H_
#include <joinOS/exec/lists.h>
#endif

#ifndef _TAGITEMS_H_
#include <joinOS/misc/TagItems.h>
#endif

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDos.h>
#endif

/***************************************************************************/
/*                                                                         */
/*                      Structures used for Indexes                        */
/*                                                                         */
/***************************************************************************/

/* This is the header of an index as found in the first block (1024 bytes=
 * of an index-file.
 */
struct IDXFileHeader
{
   ULONG FileID;                 /* 'IDX ' */
   ULONG VersionID;              /* 1L */
   ULONG FirstPage;              /* offset to root node of the tree */
   ULONG FirstEmptyPage;         /* offset to first unused page */
   struct DateStamp LastChanged; /* last time the file has been changed, this
                                  * might be an illegal date ! */
   UBYTE Reserved[4];            /* reserved for future use, set to 0 */
   ULONG NumKeys;                /* number of keys stored in the index */
   UWORD KeyLen;                 /* length of a key-value */
   UWORD Decimals;               /* no. of decimals in key (not used) */
   UWORD PageSize;               /* size of a single page (2^n >= 1024) */
   UWORD KeysPerPage;            /* maximum no. of keys per page */
   UBYTE Flags;                  /* flags specifying the index */
   UBYTE Name[32];               /* name of the index */
   UBYTE Expression[256];        /* the key-expression in human readable form */
   UBYTE PreParsedExpr[256];     /* the prepcompiled key-expression */
   UBYTE Unused[0];              /* the rest of 1024 bytes are unused */
};

/* This is a part of the IDXFileHeader used to evaluate if the index-file has
 * changed since the last access...
 */
struct IDXSFH
{
   ULONG FileID;                 /* 'IDX ' */
   ULONG VersionID;              /* 1L */
   ULONG FirstPage;              /* offset to root node of the tree */
   ULONG FirstEmptyPage;         /* offset to first unused page */
   struct DateStamp LastChanged; /* last time the file has been changed */
   UBYTE Reserved[4];            /* reserved for future use, set to 0 */
   ULONG NumKeys;                /* number of keys stored in the index */
};

/* This is the header of an Index, the handle used to access the tree.
 */
struct IDXHeader
{
   struct Node Link;             /* used to link to a list, 'ln_Name' contains
                                  * the name of the order */
   BPTR fh;                      /* FileHandle of index-file */
   UBYTE Flags;                  /* see below for defines */
   UBYTE Reserved[3];            /* reserved for future use */
   ULONG FirstPage;              /* offset to root node of the tree */
   ULONG FirstEmptyPage;         /* offset to first unused page */
   @{"struct IDXMemPage" LINK File 105} *PagePtr;   /* ptr. to first page */
   @{"struct IDXMemPage" LINK File 105} *CurrentPage;  /* ptr. to currently processed page */
   struct DateStamp LastChanged; /* date & time of last change of file, this
                                  * might be an illegal date ! */
   STRPTR Expression;            /* NUL-terminated string with key-expr. */
   UBYTE *PreParsedExpr;         /* the prepcompiled key-expression */
   ULONG NumKeys;                /* number of keys stored in the index */
   UWORD KeyLen;                 /* length of a key-value */
   UWORD Decimals;               /* no. of decimals in key (not used) */
   UWORD KeySize;                /* 'KeyLen'+8 rounded up to a multiple of 4 */
   UWORD PageSize;               /* size of a page */
   UWORD KeysPerPage;            /* maximum no. of Keys per page */
   UWORD CurrentKeyPos;          /* position of the current key on the current
                                  * page, required for "skipping" */
   @{"struct IDXKeyEntry" LINK File 120} *CurrentKey;  /* buffer for the currently compared
                                     * key-value ('KeySize' bytes) */
   UBYTE *TopScope;              /* buffer for the key-value of the upper
                                  * boundary of a "Scope",'KeyLen' bytes */
   UBYTE *BottomScope;           /* buffer for the key-value of the upper
                                  * boundary of a "Scope",'KeyLen' bytes */
   @{"struct IDXSFH" LINK File 58} sfh;            /* used to determine changes */
};

/* This is a single page copied into memory...
 */
struct IDXMemPage
{
   ULONG Offset;                 /* offset in file, for identification */
   struct IDXMemPage *SubPage;   /* a single SubNode of this page */
   struct IDXMemPage *Parent;    /* parent of this page */
   UWORD ParentKey;              /* no. of parent key in the parent's page */
   UBYTE Flags;                  /* bit-flags describing the page's state */
   UBYTE Reserved;               /* reserved for future use */
   UWORD *KeysUsed;              /* keys used on this page */
   UWORD *KeyPtr;                /* ptr. to list of offsets to key-values */
   UBYTE PageData[0];            /* plain data as read from disk */
};

/* This is a single key-entry in a page...
 */
struct IDXKeyEntry
{
   ULONG LeftPage;         /* ptr. to 'left' subtree */
   ULONG RecNo;            /* record number in the according Database */
   UBYTE KeyValue[0];      /* 'IDXHeader.KeyLen' (rounded up to a multiple
                            * of 4) bytes for the key-value */
};

/* An alias could be used to access an index using another name...
 */
struct IDXAlias
{
   struct Node Link;             /* used to link to a list, 'ln_Name' contains
                                  * the name of the order */
   @{"struct IDXHeader" LINK File 71} *ihd;        /* the referenced index */
   UBYTE Flags;                  /* see below for defines */
};

/***************************************************************************/
/*                                                                         */
/*                         Defines used for Indexes                        */
/*                                                                         */
/***************************************************************************/

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d)   \\
   ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#define DBF_INDEXFILEID    MAKE_ID('I','D','X',' ')   /* first long in file */

/* Tags for creation of Indexes...
 */
#define IDX_TagBase       TAG_USER + 0x80000

#define IDX_Name        IDX_TagBase + 1   /* the name of the index */
#define IDX_FileName    IDX_TagBase + 2   /* filename and path of the index */
#define IDX_Expression  IDX_TagBase + 3   /* expression used for the index */
#define IDX_Server      IDX_TagBase + 4   /* the server the index belongs to */
#define IDX_PageSize    IDX_TagBase + 5   /* size of a single page */

#define IDX_Unique      IDX_TagBase + 10  /* an unique index */
#define IDX_Descend     IDX_TagBase + 11  /* ordered descend */
#define IDX_Custom      IDX_TagBase + 12  /* new keys are added manually */
#define IDX_Exclusive   IDX_TagBase + 13  /* index is used exclusive */
#define IDX_WriteBehind IDX_TagBase + 14  /* use a write behind caching algorithm */

/* Flag defines for 'IDXHeader.Flags' resp. 'IDXFileHeader.Flags'...
 */
#define IDX_UNIQUE      0x01  /* the keys are unique */
#define IDX_DESCEND     0x02  /* the KeyValues are ordered descend */
#define IDX_CUSTOM      0x04  /* a custom order, the keys are not changed
                               * automatically, they must be changed manual */
#define IDX_EXCLUSIVE   0x08  /* the index is used exclusive, no locking
                               * required */
#define IDX_WRITEBEHIND 0x10  /* use a write behind caching algorithm */
#define IDX_ALIAS       0x20  /* identifying an alias of an index */
#define IDX_RESERVED    0x40  /* reserved for future use */
#define IDX_LOCKED      0x80  /* the index is locked */

/* Flag defines for 'IDXMemPage.Flags'...
 */
#define IDX_PG_CHANGED  0x01  /* the changes on the page are not flushed to
                               * the index-file until now */

/* Access types of indexes:
 */
#define IDX_READ  REC_SHARED     /* read-only access */
#define IDX_WRITE REC_EXCLUSIVE  /* read-write access */

/* misc. defines...
 */
#define INDEXHEADER_SIZE   1024  /* size of the index-fileheader */
#define LOCK_TIMEOUT       750   /* fifteen seconds timeout; samba only checks
                                  * every 10th second per default, so a shorter
                                  * timeout doesn't makes sence,a longer time
                                  * may seduce impatient users to kill the app
                                  * because they think it's hold forever */

/* Additonal error codes (stored in the 'LastError' field of the attached
 * DataServer...
 */
#define IDX_ERR_DUPLICATE_KEY    2000L /* a key value is already in use
                                        * (in a unique index) */
#define IDX_ERR_NO_KEY           2001L /* tried to access a non-existing key,
                                        * e.g. try to remove the key for the
                                        * current record and no key is stored
                                        * for that record. */
#define IDX_ERR_BAD_EXPRESSION   2002L /* the expression specified for the
                                        * index is not valid. */

#endif      /* _DATABASE_INDEX_H_ */
@ENDNODE
