/* $Id: iffparse.h,v 1.10 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/iff_shared2'
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/ports', 'target/devices/clipboard'
MODULE 'target/exec/nodes'
{#include <libraries/iffparse.h>}
NATIVE {IFF_IFFPARSE_H} CONST

/* Structure associated with an active IFF stream.
 * "iff_Stream" is a value used by the client's read/write/seek functions -
 * it will not be accessed by the library itself and can have any value
 * (could even be a pointer or a BPTR).
 *
 * This structure can only be allocated by iffparse.library
 */
NATIVE {IFFHandle} OBJECT iffhandle
    {iff_Stream}	stream	:ULONG
    {iff_Flags}	flags	:ULONG
    {iff_Depth}	depth	:VALUE /*  Depth of context stack */
ENDOBJECT

/* bit masks for "iff_Flags" field */
NATIVE {IFFF_READ}     CONST IFFF_READ     = 0                       /* read mode - default    */
NATIVE {IFFF_WRITE}    CONST IFFF_WRITE    = 1                       /* write mode             */
NATIVE {IFFF_RWBITS}   CONST IFFF_RWBITS   = (IFFF_READ OR IFFF_WRITE) /* read/write bits        */
NATIVE {IFFF_FSEEK}    CONST IFFF_FSEEK    = 1 SHL 1                  /* forward seek only      */
NATIVE {IFFF_RSEEK}    CONST IFFF_RSEEK    = 1 SHL 2                  /* random seek            */
NATIVE {IFFF_RESERVED} CONST IFFF_RESERVED = $FFFF0000              /* Don't touch these bits */

/*****************************************************************************/

/* When the library calls your stream handler, you'll be passed a pointer
 * to this structure as the "message packet".
 */
NATIVE {IFFStreamCmd} OBJECT iffstreamcmd
    {sc_Command}	command	:VALUE /* Operation to be performed (IFFCMD_) */
    {sc_Buf}	buf	:APTR     /* Pointer to data buffer              */
    {sc_NBytes}	nbytes	:VALUE  /* Number of bytes to be affected      */
ENDOBJECT

/*****************************************************************************/

/* A node associated with a context on the iff_Stack. Each node
 * represents a chunk, the stack representing the current nesting
 * of chunks in the open IFF file. Each context node has associated
 * local context items in the (private) LocalItems list.  The ID, type,
 * size and scan values describe the chunk associated with this node.
 *
 * This structure can only be allocated by iffparse.library
 */
NATIVE {ContextNode} OBJECT contextnode
    {cn_Node}	mln	:mln
    {cn_ID}	id	:VALUE
    {cn_Type}	type	:VALUE
    {cn_Size}	size	:VALUE /*  Size of this chunk             */
    {cn_Scan}	scan	:VALUE /*  # of bytes read/written so far */
ENDOBJECT

/*****************************************************************************/

/* Local context items live in the ContextNode's.  Each class is identified
 * by its lci_Ident code and has a (private) purge vector for when the
 * parent context node is popped.
 *
 * This structure can only be allocated by iffparse.library
 */
NATIVE {LocalContextItem} OBJECT localcontextitem
    {lci_Node}	mln	:mln
    {lci_ID}	id	:ULONG
    {lci_Type}	type	:ULONG
    {lci_Ident}	ident	:ULONG
ENDOBJECT

/*****************************************************************************/

/* StoredProperty: a local context item containing the data stored
 * from a previously encountered property chunk.
 */
NATIVE {StoredProperty} OBJECT storedproperty
    {sp_Size}	size	:VALUE
    {sp_Data}	data	:APTR
ENDOBJECT

/*****************************************************************************/

/* Collection Item: the actual node in the collection list at which
 * client will look. The next pointers cross context boundaries so
 * that the complete list is accessable.
 */
NATIVE {CollectionItem} OBJECT collectionitem
    {ci_Next}	next	:PTR TO collectionitem
    {ci_Size}	size	:VALUE
    {ci_Data}	data	:APTR
ENDOBJECT

/*****************************************************************************/

/* Structure returned by OpenClipboard(). You may do CMD_POSTs and such
 * using this structure. However, once you call OpenIFF(), you may not
 * do any more of your own I/O to the clipboard until you call CloseIFF().
 */
NATIVE {ClipboardHandle} OBJECT clipboardhandle
    {cbh_Req}	iocr	:ioclipreq
    {cbh_CBport}	cbport	:mp
    {cbh_SatisfyPort}	satisfyport	:mp
ENDOBJECT

/*****************************************************************************/

/* IFF return codes. Most functions return either zero for success or
 * one of these codes. The exceptions are the read/write functions which
 * return positive values for number of bytes or records read or written,
 * or a negative error code. Some of these codes are not errors per sae,
 * but valid conditions such as EOF or EOC (End of Chunk).
 */
NATIVE {IFFERR_EOF}        CONST IFFERR_EOF        = -1  /* Reached logical end of file  */
NATIVE {IFFERR_EOC}        CONST IFFERR_EOC        = -2  /* About to leave context       */
NATIVE {IFFERR_NOSCOPE}    CONST IFFERR_NOSCOPE    = -3  /* No valid scope for property  */
NATIVE {IFFERR_NOMEM}      CONST IFFERR_NOMEM      = -4  /* Internal memory alloc failed */
NATIVE {IFFERR_READ}       CONST IFFERR_READ       = -5  /* Stream read error            */
NATIVE {IFFERR_WRITE}      CONST IFFERR_WRITE      = -6  /* Stream write error           */
NATIVE {IFFERR_SEEK}       CONST IFFERR_SEEK       = -7  /* Stream seek error            */
NATIVE {IFFERR_MANGLED}    CONST IFFERR_MANGLED    = -8  /* Data in file is corrupt      */
NATIVE {IFFERR_SYNTAX}     CONST IFFERR_SYNTAX     = -9  /* IFF syntax error             */
NATIVE {IFFERR_NOTIFF}     CONST IFFERR_NOTIFF     = -10 /* Not an IFF file              */
NATIVE {IFFERR_NOHOOK}     CONST IFFERR_NOHOOK     = -11 /* No call-back hook provided   */
NATIVE {IFF_RETURN2CLIENT} CONST IFF_RETURN2CLIENT = -12 /* Client handler normal return */

/*****************************************************************************/

NATIVE {MAKE_ID} CONST	->MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))

/* Universal IFF identifiers */
->"CONST ID_FORM" is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
->"CONST ID_CAT"  is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
->"CONST ID_LIST" is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
->"CONST ID_PROP" is on-purposely missing from here (it can be found in 'libraries/iff_shared2')
NATIVE {ID_NULL} CONST ID_NULL = "    "

/* Identifier codes for universally recognized local context items */
NATIVE {IFFLCI_PROP}         CONST IFFLCI_PROP         = "prop"
NATIVE {IFFLCI_COLLECTION}   CONST IFFLCI_COLLECTION   = "coll"
NATIVE {IFFLCI_ENTRYHANDLER} CONST IFFLCI_ENTRYHANDLER = "enhd"
NATIVE {IFFLCI_EXITHANDLER}  CONST IFFLCI_EXITHANDLER  = "exhd"

/*****************************************************************************/

/* Control modes for ParseIFF() function */
NATIVE {IFFPARSE_SCAN}    CONST IFFPARSE_SCAN    = 0
NATIVE {IFFPARSE_STEP}    CONST IFFPARSE_STEP    = 1
NATIVE {IFFPARSE_RAWSTEP} CONST IFFPARSE_RAWSTEP = 2

/*****************************************************************************/

/* Control modes for StoreLocalItem() function */
NATIVE {IFFSLI_ROOT}  CONST IFFSLI_ROOT  = 1  /* Store in default context      */
NATIVE {IFFSLI_TOP}   CONST IFFSLI_TOP   = 2  /* Store in current context      */
NATIVE {IFFSLI_PROP}  CONST IFFSLI_PROP  = 3  /* Store in topmost FORM or LIST */

/*****************************************************************************/

/* Magic value for writing functions. If you pass this value in as a size
 * to PushChunk() when writing a file, the parser will figure out the
 * size of the chunk for you. If you know the size, is it better to
 * provide as it makes things faster.
 */
NATIVE {IFFSIZE_UNKNOWN} CONST IFFSIZE_UNKNOWN = -1

/*****************************************************************************/

/* Possible call-back command values */
NATIVE {IFFCMD_INIT}     CONST IFFCMD_INIT     = 0 /* Prepare the stream for a session */
NATIVE {IFFCMD_CLEANUP}  CONST IFFCMD_CLEANUP  = 1 /* Terminate stream session         */
NATIVE {IFFCMD_READ}     CONST IFFCMD_READ     = 2 /* Read bytes from stream           */
NATIVE {IFFCMD_WRITE}    CONST IFFCMD_WRITE    = 3 /* Write bytes to stream            */
NATIVE {IFFCMD_SEEK}     CONST IFFCMD_SEEK     = 4 /* Seek on stream                   */
NATIVE {IFFCMD_ENTRY}    CONST IFFCMD_ENTRY    = 5 /* You just entered a new context   */
NATIVE {IFFCMD_EXIT}     CONST IFFCMD_EXIT     = 6 /* You're about to leave a context  */
NATIVE {IFFCMD_PURGELCI} CONST IFFCMD_PURGELCI = 7 /* Purge a LocalContextItem         */

/*****************************************************************************/

/* Obsolete IFFParse definitions, here for source code compatibility only.
 * Please do NOT use in new code.
 *
 * #define IFFPARSE_PRE_V37_NAMES when you need these older names
 */
->#ifdef IFFPARSE_PRE_V37_NAMES
NATIVE {IFFSCC_INIT}    CONST IFFSCC_INIT    = IFFCMD_INIT
NATIVE {IFFSCC_CLEANUP} CONST IFFSCC_CLEANUP = IFFCMD_CLEANUP
NATIVE {IFFSCC_READ}    CONST IFFSCC_READ    = IFFCMD_READ
NATIVE {IFFSCC_WRITE}   CONST IFFSCC_WRITE   = IFFCMD_WRITE
NATIVE {IFFSCC_SEEK}    CONST IFFSCC_SEEK    = IFFCMD_SEEK
->#endif
