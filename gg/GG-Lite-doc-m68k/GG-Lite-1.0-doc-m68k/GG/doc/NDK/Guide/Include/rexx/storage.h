@DATABASE "gg:doc/NDK/Guide/Include/rexx/storage.h"
@MASTER   "gg:os-include/rexx/storage.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "rexx/storage.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"rexx/storage.h" LINK File}


@{b}Structures@{ub}

@{"NexxStr" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 41}  @{"RexxArg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 86}  @{"RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98}  @{"RexxRsrc" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 161}  @{"RexxTask" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 186}  @{"SrcNode" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 226}


@{b}#defines@{ub}

@{"ARG0()" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 116}       @{"ARG1()" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 117}      @{"ARG2()" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 118}      @{"GLOBALSZ" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 184}     @{"IVALUE()" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 50}
@{"KEEPNUM" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 78}      @{"KEEPSTR" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 77}     @{"MAXRMARG" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 120}    @{"MEMCLEAR" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 220}     @{"MEMMASK" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 217}
@{"MEMQUANT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 216}     @{"MEMQUICK" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 219}    @{"NSB_BINARY" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 57}  @{"NSB_EXT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 59}      @{"NSB_FLOAT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 58}
@{"NSB_KEEP" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 53}     @{"NSB_NOTNUM" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 55}  @{"NSB_NUMBER" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 56}  @{"NSB_SOURCE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 60}   @{"NSB_STRING" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 54}
@{"NSF_ALPHA" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 75}    @{"NSF_BINARY" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 67}  @{"NSF_DPNUM" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 74}   @{"NSF_EXT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 69}      @{"NSF_FLOAT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 68}
@{"NSF_INTNUM" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 73}   @{"NSF_KEEP" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 63}    @{"NSF_NOTNUM" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 65}  @{"NSF_NUMBER" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 66}   @{"NSF_OWNED" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 76}
@{"NSF_SOURCE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 70}   @{"NSF_STRING" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 64}  @{"NXADDLEN" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 49}    @{"RRT_ANY" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 171}      @{"RRT_CLIP" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 176}
@{"RRT_FILE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 174}     @{"RRT_HOST" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 175}    @{"RRT_LIB" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 172}     @{"RRT_PORT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 173}     @{"RTFB_CLOSE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 213}
@{"RTFB_HALT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 209}    @{"RTFB_SUSP" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 210}   @{"RTFB_TCUSE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 211}  @{"RTFB_TRACE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 208}   @{"RTFB_WAIT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 212}
@{"RXADDCON" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 130}     @{"RXADDFH" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 127}     @{"RXADDLIB" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 128}    @{"RXARGMASK" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 150}    @{"RXCLOSE" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 125}
@{"RXCODEMASK" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 149}   @{"RXCOMM" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 123}      @{"RXFB_NOIO" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 136}   @{"RXFB_NONRET" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 140}  @{"RXFB_RESULT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 137}
@{"RXFB_STRING" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 138}  @{"RXFB_TOKEN" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 139}  @{"RXFF_NOIO" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 143}   @{"RXFF_NONRET" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 147}  @{"RXFF_RESULT" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 144}
@{"RXFF_STRING" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 145}  @{"RXFF_TOKEN" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 146}  @{"RXFUNC" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 124}      @{"RXQUERY" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 126}      @{"RXREMCON" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 131}
@{"RXREMLIB" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 129}     @{"RXTCCLS" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 133}     @{"RXTCOPN" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 132}     

@ENDNODE
@NODE File "rexx/storage.h"
#ifndef REXX_STORAGE_H
#define REXX_STORAGE_H
/*
**      $VER: storage.h 1.4 (8.11.1991)
**      Includes Release 45.1
**
**      Header file to define ARexx data structures.
**
**      (C) Copyright 1986,1987,1988,1989,1990 William S. Hawes
**      (C) Copyright 1990-2001 Amiga, Inc.
**              All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

/* The NexxStr structure is used to maintain the internal strings in REXX.
 * It includes the buffer area for the string and associated attributes.
 * This is actually a variable-length structure; it is allocated for a
 * specific length string, and the length is never modified thereafter
 * (since it's used for recycling).
 */

struct NexxStr {
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     ns_Ivalue;                 /* integer value         */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}    ns_Length;                 /* length in bytes (excl null)   */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    ns_Flags;                  /* attribute flags               */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    ns_Hash;                   /* hash code                     */
   @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}     ns_Buff[8];        /* buffer area for strings       */
   };                                  /* size: 16 bytes (minimum)      */

#define NXADDLEN 9                     /* offset plus null byte */
#define IVALUE(nsPtr) (nsPtr->ns_Ivalue)

/* String attribute flag bit definitions                                */
#define NSB_KEEP     0                 /* permanent string?             */
#define NSB_STRING   1                 /* string form valid?            */
#define NSB_NOTNUM   2                 /* non-numeric?                  */
#define NSB_NUMBER   3                 /* a valid number?               */
#define NSB_BINARY   4                 /* integer value saved?          */
#define NSB_FLOAT    5                 /* floating point format?        */
#define NSB_EXT      6                 /* an external string?           */
#define NSB_SOURCE   7                 /* part of the program source?   */

/* The flag form of the string attributes                               */
#define NSF_KEEP     (1 << @{"NSB_KEEP" LINK File 53}  )
#define NSF_STRING   (1 << @{"NSB_STRING" LINK File 54})
#define NSF_NOTNUM   (1 << @{"NSB_NOTNUM" LINK File 55})
#define NSF_NUMBER   (1 << @{"NSB_NUMBER" LINK File 56})
#define NSF_BINARY   (1 << @{"NSB_BINARY" LINK File 57})
#define NSF_FLOAT    (1 << @{"NSB_FLOAT" LINK File 58} )
#define NSF_EXT      (1 << @{"NSB_EXT" LINK File 59}   )
#define NSF_SOURCE   (1 << @{"NSB_SOURCE" LINK File 60})

/* Combinations of flags                                                */
#define NSF_INTNUM   (@{"NSF_NUMBER" LINK File 66} | @{"NSF_BINARY" LINK File 67} | @{"NSF_STRING" LINK File 64})
#define NSF_DPNUM    (@{"NSF_NUMBER" LINK File 66} | @{"NSF_FLOAT" LINK File 68})
#define NSF_ALPHA    (@{"NSF_NOTNUM" LINK File 65} | @{"NSF_STRING" LINK File 64})
#define NSF_OWNED    (@{"NSF_SOURCE" LINK File 70} | @{"NSF_EXT" LINK File 69}    | @{"NSF_KEEP" LINK File 63})
#define KEEPSTR      (@{"NSF_STRING" LINK File 64} | @{"NSF_SOURCE" LINK File 70} | @{"NSF_NOTNUM" LINK File 65})
#define KEEPNUM      (@{"NSF_STRING" LINK File 64} | @{"NSF_SOURCE" LINK File 70} | @{"NSF_NUMBER" LINK File 66} | @{"NSF_BINARY" LINK File 67})

/* The RexxArg structure is identical to the NexxStr structure, but
 * is allocated from system memory rather than from internal storage.
 * This structure is used for passing arguments to external programs.
 * It is usually passed as an "argstring", a pointer to the string buffer.
 */

struct RexxArg {
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     ra_Size;                   /* total allocated length        */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}    ra_Length;                 /* length of string              */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    ra_Flags;                  /* attribute flags               */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    ra_Hash;                   /* hash code                     */
   @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}     ra_Buff[8];        /* buffer area                   */
   };                                  /* size: 16 bytes (minimum)      */

/* The RexxMsg structure is used for all communications with REXX
 * programs.  It is an EXEC message with a parameter block appended.
 */

struct RexxMsg {
   @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} rm_Node;             /* EXEC message structure        */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rm_TaskBlock;              /* global structure (private)    */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rm_LibBase;        /* library base (private)        */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rm_Action;                 /* command (action) code */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rm_Result1;        /* primary result (return code)  */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rm_Result2;        /* secondary result              */
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}   rm_Args[16];               /* argument block (@{"ARG0" LINK File 116}-ARG15)   */

   @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *rm_PassPort;        /* forwarding port               */
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}   rm_CommAddr;               /* host address (port name)      */
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}   rm_FileExt;        /* file extension                */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rm_Stdin;                  /* input stream (filehandle)     */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rm_Stdout;                 /* output stream (filehandle)    */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rm_avail;                  /* future expansion              */
   };                                  /* size: 128 bytes               */

/* Field definitions                                                    */
#define ARG0(rmp) (rmp->rm_Args[0])    /* start of argblock             */
#define ARG1(rmp) (rmp->rm_Args[1])    /* first argument                */
#define ARG2(rmp) (rmp->rm_Args[2])    /* second argument               */

#define MAXRMARG  15                   /* maximum arguments             */

/* Command (action) codes for message packets                           */
#define RXCOMM    0x01000000           /* a command-level invocation    */
#define RXFUNC    0x02000000           /* a function call               */
#define RXCLOSE   0x03000000           /* close the REXX server */
#define RXQUERY   0x04000000           /* query for information */
#define RXADDFH   0x07000000           /* add a function host           */
#define RXADDLIB  0x08000000           /* add a function library        */
#define RXREMLIB  0x09000000           /* remove a function library     */
#define RXADDCON  0x0A000000           /* add/update a ClipList string  */
#define RXREMCON  0x0B000000           /* remove a ClipList string      */
#define RXTCOPN   0x0C000000           /* open the trace console        */
#define RXTCCLS   0x0D000000           /* close the trace console       */

/* Command modifier flag bits                                           */
#define RXFB_NOIO    16        /* suppress I/O inheritance?     */
#define RXFB_RESULT  17        /* result string expected?       */
#define RXFB_STRING  18        /* program is a "string file"?   */
#define RXFB_TOKEN   19        /* tokenize the command line?    */
#define RXFB_NONRET  20        /* a "no-return" message?        */

/* The flag form of the command modifiers                               */
#define RXFF_NOIO    (1L << @{"RXFB_NOIO" LINK File 136}  )
#define RXFF_RESULT  (1L << @{"RXFB_RESULT" LINK File 137})
#define RXFF_STRING  (1L << @{"RXFB_STRING" LINK File 138})
#define RXFF_TOKEN   (1L << @{"RXFB_TOKEN" LINK File 139} )
#define RXFF_NONRET  (1L << @{"RXFB_NONRET" LINK File 140})

#define RXCODEMASK   0xFF000000
#define RXARGMASK    0x0000000F

/* The RexxRsrc structure is used to manage global resources.  Each node
 * has a name string created as a RexxArg structure, and the total size
 * of the node is saved in the "rr_Size" field.  The REXX systems library
 * provides functions to allocate and release resource nodes.  If special
 * deletion operations are required, an offset and base can be provided in
 * "rr_Func" and "rr_Base", respectively.  This "autodelete" function will
 * be called with the base in register A6 and the node in A0.
 */

struct RexxRsrc {
   @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} rr_Node;
   @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}     rr_Func;                   /* "auto-delete" offset          */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rr_Base;                   /* "auto-delete" base            */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rr_Size;                   /* total size of node            */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rr_Arg1;                   /* available ...         */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     rr_Arg2;                   /* available ...         */
   };                                  /* size: 32 bytes                */

/* Resource node types                                                  */
#define RRT_ANY      0                 /* any node type ...             */
#define RRT_LIB      1                 /* a function library            */
#define RRT_PORT     2                 /* a public port         */
#define RRT_FILE     3                 /* a file IoBuff         */
#define RRT_HOST     4                 /* a function host               */
#define RRT_CLIP     5                 /* a Clip List node              */

/* The RexxTask structure holds the fields used by REXX to communicate with
 * external processes, including the client task.  It includes the global
 * data structure (and the base environment).  The structure is passed to
 * the newly-created task in its "wake-up" message.
 */

#define GLOBALSZ  200                  /* total size of GlobalData      */

struct RexxTask {
   @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}     rt_Global[@{"GLOBALSZ" LINK File 184}];       /* global data structure */
   @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} rt_MsgPort;          /* global message port           */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    rt_Flags;                  /* task flag bits                */
   @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}     rt_SigBit;                 /* signal bit                    */

   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rt_ClientID;               /* the client's task ID          */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rt_MsgPkt;                 /* the packet being processed    */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rt_TaskID;                 /* our task ID                   */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rt_RexxPort;               /* the REXX public port          */

   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rt_ErrTrap;        /* Error trap address            */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     rt_StackPtr;               /* stack pointer for traps       */

   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rt_Header1;             /* Environment list              */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rt_Header2;             /* Memory freelist               */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rt_Header3;             /* Memory allocation list        */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rt_Header4;             /* Files list                    */
   @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} rt_Header5;             /* Message Ports List            */
   };

/* Definitions for RexxTask flag bits                                   */
#define RTFB_TRACE   0                 /* external trace flag           */
#define RTFB_HALT    1                 /* external halt flag            */
#define RTFB_SUSP    2                 /* suspend task?         */
#define RTFB_TCUSE   3                 /* trace console in use? */
#define RTFB_WAIT    6                 /* waiting for reply?            */
#define RTFB_CLOSE   7                 /* task completed?               */

/* Definitions for memory allocation constants                          */
#define MEMQUANT  16L                  /* quantum of memory space       */
#define MEMMASK   0xFFFFFFF0           /* mask for rounding the size    */

#define MEMQUICK  (1L << 0 )           /* EXEC flags: @{"MEMF_PUBLIC" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 69}       */
#define MEMCLEAR  (1L << 16)           /* EXEC flags: @{"MEMF_CLEAR" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 76}        */

/* The SrcNode is a temporary structure used to hold values destined for
 * a segment array.  It is also used to maintain the memory freelist.
 */

struct SrcNode {
   struct SrcNode *sn_Succ;            /* next node                     */
   struct SrcNode *sn_Pred;            /* previous node         */
   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     sn_Ptr;                    /* pointer value         */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}     sn_Size;                   /* size of object                */
   };                                  /* size: 16 bytes                */

#endif
@ENDNODE
