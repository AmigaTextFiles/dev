@DATABASE "gg:doc/NDK/Guide/Include/rexx/rexxio.h"
@MASTER   "gg:os-include/rexx/rexxio.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:27
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "rexx/rexxio.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"rexx/rexxio.h" LINK File}


@{b}Structures@{ub}

@{"IoBuff" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 24}  @{"RexxMsgPort" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 63}


@{b}#defines@{ub}

@{"ACTION_QUEUE" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 80}  @{"ACTION_STACK" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 79}  @{"CLVALUE()" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 57}  @{"DT_DEV" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 72}      @{"DT_DIR" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 73}
@{"DT_VOL" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 74}        @{"LLOFFSET()" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 50}    @{"LLVERS()" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 51}   @{"RXBUFFSZ" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 18}    @{"RXIO_APPEND" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 39}
@{"RXIO_BEGIN" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 44}    @{"RXIO_CURR" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 45}     @{"RXIO_END" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 46}   @{"RXIO_EXIST" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 35}  @{"RXIO_READ" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 37}
@{"RXIO_STRF" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 36}     @{"RXIO_WRITE" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File" 38}    

@ENDNODE
@NODE File "rexx/rexxio.h"
#ifndef REXX_REXXIO_H
#define REXX_REXXIO_H
/*
**      $VER: rexxio.h 1.4 (8.11.1991)
**      Includes Release 45.1
**
**      Header file for ARexx Input/Output related structures
**
**      (C) Copyright 1986,1987,1988,1989,1990 William S. Hawes
**      (C) Copyright 1990-2001 Amiga, Inc.
**              All Rights Reserved
*/

#ifndef REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif

#define RXBUFFSZ  204                  /* buffer length         */

/*
 * The IoBuff is a resource node used to maintain the File List.  Nodes
 * are allocated and linked into the list whenever a file is opened.
 */
struct IoBuff {
   @{"struct RexxRsrc" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 161} iobNode;            /* structure for files/strings   */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     iobRpt;                    /* read/write pointer            */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     iobRct;                    /* character count               */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     iobDFH;                    /* DOS filehandle                */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     iobLock;                   /* DOS lock                      */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     iobBct;                    /* buffer length         */
   @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}     iobArea[@{"RXBUFFSZ" LINK File 18}];         /* buffer area                   */
   };                                  /* size: 256 bytes               */

/* Access mode definitions                                              */
#define RXIO_EXIST   -1        /* an external filehandle        */
#define RXIO_STRF    0                 /* a "string file"               */
#define RXIO_READ    1                 /* read-only access              */
#define RXIO_WRITE   2                 /* write mode                    */
#define RXIO_APPEND  3                 /* append mode (existing file)   */

/*
 * Offset anchors for SeekF()
 */
#define RXIO_BEGIN   -1L               /* relative to start             */
#define RXIO_CURR    0L        /* relative to current position  */
#define RXIO_END     1L        /* relative to end               */

/* The Library List contains just plain resource nodes.         */

#define LLOFFSET(rrp) (rrp->rr_Arg1)   /* "Query" offset                */
#define LLVERS(rrp)   (rrp->rr_Arg2)   /* library version               */

/*
 * The RexxClipNode structure is used to maintain the Clip List.  The value
 * string is stored as an argstring in the rr_Arg1 field.
 */
#define CLVALUE(rrp) ((@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) rrp->rr_Arg1)

/*
 * A message port structure, maintained as a resource node.  The ReplyList
 * holds packets that have been received but haven't been replied.
 */
struct RexxMsgPort {
   @{"struct RexxRsrc" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 161} rmp_Node;           /* linkage node                  */
   @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28}  rmp_Port;           /* the message port              */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}     rmp_ReplyList;      /* messages awaiting reply       */
   };

/*
 * DOS Device types
 */
#define DT_DEV    0L                   /* a device                      */
#define DT_DIR    1L                   /* an ASSIGNed directory */
#define DT_VOL    2L                   /* a volume                      */

/*
 * Private DOS packet types
 */
#define ACTION_STACK 2002L             /* stack a line                  */
#define ACTION_QUEUE 2003L             /* queue a line                  */

#endif
@ENDNODE
