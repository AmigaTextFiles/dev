/* $Id: rexxio.h,v 1.12 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/rexx/storage'
MODULE 'target/exec/types', 'target/exec/ports', 'target/exec/lists'
{#include <rexx/rexxio.h>}
NATIVE {REXX_REXXIO_H} CONST

NATIVE {RXBUFFSZ} CONST RXBUFFSZ = 204 /* buffer length */

/*
 * The IoBuff is a resource node used to maintain the File List.  Nodes
 * are allocated and linked into the list whenever a file is opened.
 */
NATIVE {IoBuff} OBJECT iobuff
    {iobNode}	node	:rexxrsrc           /* structure for files/strings */
    {iobRpt}	rpt	:APTR            /* read/write pointer */
    {iobRct}	rct	:VALUE            /* character count */
    {iobDFH}	dfh	:VALUE            /* DOS filehandle */
    {iobLock}	lock	:APTR           /* DOS lock */
    {iobBct}	bct	:VALUE            /* buffer length */
    {iobArea}	area[RXBUFFSZ]	:ARRAY OF BYTE /* buffer area */
ENDOBJECT                                     /* size: 256 bytes */

/* Access mode definitions */
NATIVE {RXIO_EXIST}  CONST RXIO_EXIST  = -1 /* an external filehandle */
NATIVE {RXIO_STRF}    CONST RXIO_STRF    = 0 /* a "string file" */
NATIVE {RXIO_READ}    CONST RXIO_READ    = 1 /* read-only access */
NATIVE {RXIO_WRITE}   CONST RXIO_WRITE   = 2 /* write mode */
NATIVE {RXIO_APPEND}  CONST RXIO_APPEND  = 3 /* append mode (existing file) */

/*
 * Offset anchors for SeekF()
 */
NATIVE {RXIO_BEGIN} CONST RXIO_BEGIN = -1 /* relative to start */
NATIVE {RXIO_CURR}   CONST RXIO_CURR   = 0 /* relative to current position */
NATIVE {RXIO_END}    CONST RXIO_END    = 1 /* relative to end */

/* The Library List contains just plain resource nodes. */

NATIVE {LLOFFSET} CONST	->LLOFFSET(rrp) (rrp->rr_Arg1) /* "Query" offset */
NATIVE {LLVERS} CONST	->LLVERS(rrp)   (rrp->rr_Arg2) /* library version */

/*
 * The RexxClipNode structure is used to maintain the Clip List.  The value
 * string is stored as an argstring in the rr_Arg1 field.
 */
NATIVE {CLVALUE} CONST	->CLVALUE(rrp) ((STRPTR) rrp->rr_Arg1)

/*
 * A message port structure, maintained as a resource node.  The ReplyList
 * holds packets that have been received but haven't been replied.
 */
NATIVE {RexxMsgPort} OBJECT rexxmsgport
    {rmp_Node}	rrsizeof	:rexxrsrc      /* linkage node */
    {rmp_Port}	port	:mp      /* the message port */
    {rmp_ReplyList}	replylist	:lh /* messages awaiting reply */
ENDOBJECT

/*
 * DOS Device types
 */
NATIVE {DT_DEV} CONST DT_DEV = 0 /* a device */
NATIVE {DT_DIR} CONST DT_DIR = 1 /* an ASSIGNed directory */
NATIVE {DT_VOL} CONST DT_VOL = 2 /* a volume */

/*
 * Private DOS packet types
 */
NATIVE {ACTION_STACK} CONST ACTION_STACK = 2002 /* stack a line */
NATIVE {ACTION_QUEUE} CONST ACTION_QUEUE = 2003 /* queue a line */
