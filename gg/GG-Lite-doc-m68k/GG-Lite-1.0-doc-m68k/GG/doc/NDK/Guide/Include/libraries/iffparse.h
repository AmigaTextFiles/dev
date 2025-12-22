@DATABASE "gg:doc/NDK/Guide/Include/libraries/iffparse.h"
@MASTER   "gg:os-include/libraries/iffparse.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:49
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/iffparse.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/iffparse.h" LINK File}


@{b}Structures@{ub}

@{"ClipboardHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 148}   @{"CollectionItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 133}  @{"ContextNode" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 85}  @{"IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44}  @{"IFFStreamCmd" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 66}
@{"LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104}  @{"StoredProperty" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 119}  


@{b}#defines@{ub}

@{"ID_CAT" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 188}              @{"ID_FORM" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 186}            @{"ID_LIST" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 187}
@{"ID_NULL" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 190}             @{"ID_PROP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 189}            @{"IFF_RETURN2CLIENT" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 176}
@{"IFFCMD_CLEANUP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 233}      @{"IFFCMD_ENTRY" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 237}       @{"IFFCMD_EXIT" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 238}
@{"IFFCMD_INIT" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 232}         @{"IFFCMD_PURGELCI" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 239}    @{"IFFCMD_READ" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 234}
@{"IFFCMD_SEEK" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 236}         @{"IFFCMD_WRITE" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 235}       @{"IFFERR_EOC" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 166}
@{"IFFERR_EOF" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 165}          @{"IFFERR_MANGLED" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 172}     @{"IFFERR_NOHOOK" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 175}
@{"IFFERR_NOMEM" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 168}        @{"IFFERR_NOSCOPE" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 167}     @{"IFFERR_NOTIFF" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 174}
@{"IFFERR_READ" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 169}         @{"IFFERR_SEEK" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 171}        @{"IFFERR_SYNTAX" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 173}
@{"IFFERR_WRITE" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 170}        @{"IFFF_FSEEK" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 55}         @{"IFFF_READ" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 52}
@{"IFFF_RESERVED" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 57}       @{"IFFF_RSEEK" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 56}         @{"IFFF_RWBITS" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 54}
@{"IFFF_WRITE" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 53}          @{"IFFLCI_COLLECTION" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 194}  @{"IFFLCI_ENTRYHANDLER" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 195}
@{"IFFLCI_EXITHANDLER" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 196}  @{"IFFLCI_PROP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 193}        @{"IFFPARSE_RAWSTEP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 205}
@{"IFFPARSE_SCAN" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 203}       @{"IFFPARSE_STEP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 204}      @{"IFFSCC_CLEANUP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 252}
@{"IFFSCC_INIT" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 251}         @{"IFFSCC_READ" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 253}        @{"IFFSCC_SEEK" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 255}
@{"IFFSCC_WRITE" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 254}        @{"IFFSIZE_UNKNOWN" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 225}    @{"IFFSLI_PROP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 214}
@{"IFFSLI_ROOT" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 212}         @{"IFFSLI_TOP" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 213}         @{"MAKE_ID()" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}

@ENDNODE
@NODE File "libraries/iffparse.h"
#ifndef IFF_IFFPARSE_H
#define IFF_IFFPARSE_H
/*
**      $VER: iffparse.h 39.1 (1.6.1992)
**      Includes Release 45.1
**
**      @{"iffparse.library" LINK "gg:doc/NDK/Guide/iffparse/MAIN"} structures and constants
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**      (C) Copyright 1989-1990 Stuart Ferguson and Leo L. Schwab
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#ifndef DEVICES_CLIPBOARD_H
#include <@{"devices/clipboard.h" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File"}>
#endif


/*****************************************************************************/


/* Structure associated with an active IFF stream.
 * "iff_Stream" is a value used by the client's read/write/seek functions -
 * it will not be accessed by the library itself and can have any value
 * (could even be a pointer or a @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}).
 *
 * This structure can only be allocated by @{"iffparse.library" LINK "gg:doc/NDK/Guide/iffparse/MAIN"}
 */
struct IFFHandle
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} iff_Stream;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} iff_Flags;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  iff_Depth;    /*  Depth of context stack */
};

/* bit masks for "iff_Flags" field */
#define IFFF_READ       0L                       /* read mode - default    */
#define IFFF_WRITE      1L                       /* write mode             */
#define IFFF_RWBITS     (@{"IFFF_READ" LINK File 52} | @{"IFFF_WRITE" LINK File 53}) /* read/write bits        */
#define IFFF_FSEEK      (1L<<1)          /* forward seek only      */
#define IFFF_RSEEK      (1L<<2)          /* random seek    */
#define IFFF_RESERVED   0xFFFF0000L              /* Don't touch these bits */


/*****************************************************************************/


/* When the library calls your stream handler, you'll be passed a pointer
 * to this structure as the "message packet".
 */
struct IFFStreamCmd
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} sc_Command;    /* Operation to be performed (IFFCMD_) */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} sc_Buf;        /* Pointer to data buffer              */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} sc_NBytes;     /* Number of bytes to be affected      */
};


/*****************************************************************************/


/* A node associated with a context on the iff_Stack. Each node
 * represents a chunk, the stack representing the current nesting
 * of chunks in the open IFF file. Each context node has associated
 * local context items in the (private) LocalItems list.  The ID, type,
 * size and scan values describe the chunk associated with this node.
 *
 * This structure can only be allocated by @{"iffparse.library" LINK "gg:doc/NDK/Guide/iffparse/MAIN"}
 */
struct ContextNode
{
    @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} cn_Node;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}           cn_ID;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}           cn_Type;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}           cn_Size;     /*  Size of this chunk             */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}           cn_Scan;     /*  # of bytes read/written so far */
};


/*****************************************************************************/


/* Local context items live in the ContextNode's.  Each class is identified
 * by its lci_Ident code and has a (private) purge vector for when the
 * parent context node is popped.
 *
 * This structure can only be allocated by @{"iffparse.library" LINK "gg:doc/NDK/Guide/iffparse/MAIN"}
 */
struct LocalContextItem
{
    @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} lci_Node;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          lci_ID;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          lci_Type;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          lci_Ident;
};


/*****************************************************************************/


/* StoredProperty: a local context item containing the data stored
 * from a previously encountered property chunk.
 */
struct StoredProperty
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} sp_Size;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} sp_Data;
};


/*****************************************************************************/


/* Collection Item: the actual node in the collection list at which
 * client will look. The next pointers cross context boundaries so
 * that the complete list is accessable.
 */
struct CollectionItem
{
    struct CollectionItem *ci_Next;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                   ci_Size;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}                   ci_Data;
};


/*****************************************************************************/


/* Structure returned by @{"OpenClipboard()" LINK "gg:doc/NDK/Guide/iffparse/OpenClipboard"}. You may do CMD_POSTs and such
 * using this structure. However, once you call @{"OpenIFF()" LINK "gg:doc/NDK/Guide/iffparse/OpenIFF"}, you may not
 * do any more of your own I/O to the clipboard until you call @{"CloseIFF()" LINK "gg:doc/NDK/Guide/iffparse/CloseIFF"}.
 */
struct ClipboardHandle
{
    @{"struct IOClipReq" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 41} cbh_Req;
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28}   cbh_CBport;
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28}   cbh_SatisfyPort;
};


/*****************************************************************************/


/* IFF return codes. Most functions return either zero for success or
 * one of these codes. The exceptions are the read/write functions which
 * return positive values for number of bytes or records read or written,
 * or a negative error code. Some of these codes are not errors per sae,
 * but valid conditions such as EOF or EOC (End of Chunk).
 */
#define IFFERR_EOF        -1L   /* Reached logical end of file  */
#define IFFERR_EOC        -2L   /* About to leave context       */
#define IFFERR_NOSCOPE    -3L   /* No valid scope for property  */
#define IFFERR_NOMEM      -4L   /* Internal memory alloc failed */
#define IFFERR_READ       -5L   /* Stream read error            */
#define IFFERR_WRITE      -6L   /* Stream write error           */
#define IFFERR_SEEK       -7L   /* Stream seek error            */
#define IFFERR_MANGLED    -8L   /* Data in file is corrupt      */
#define IFFERR_SYNTAX     -9L   /* IFF syntax error             */
#define IFFERR_NOTIFF     -10L  /* Not an IFF file              */
#define IFFERR_NOHOOK     -11L  /* No call-back hook provided   */
#define IFF_RETURN2CLIENT -12L  /* Client handler normal return */


/*****************************************************************************/


#define @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 20}(a,b,c,d)        \\
        ((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (a)<<24 | (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (b)<<16 | (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (c)<<8 | (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (d))

/* Universal IFF identifiers */
#define ID_FORM         @{"MAKE_ID" LINK File 182}('F','O','R','M')
#define ID_LIST         @{"MAKE_ID" LINK File 182}('L','I','S','T')
#define ID_CAT                  @{"MAKE_ID" LINK File 182}('C','A','T',' ')
#define ID_PROP         @{"MAKE_ID" LINK File 182}('P','R','O','P')
#define ID_NULL         @{"MAKE_ID" LINK File 182}(' ',' ',' ',' ')

/* Identifier codes for universally recognized local context items */
#define IFFLCI_PROP             @{"MAKE_ID" LINK File 182}('p','r','o','p')
#define IFFLCI_COLLECTION       @{"MAKE_ID" LINK File 182}('c','o','l','l')
#define IFFLCI_ENTRYHANDLER     @{"MAKE_ID" LINK File 182}('e','n','h','d')
#define IFFLCI_EXITHANDLER      @{"MAKE_ID" LINK File 182}('e','x','h','d')


/*****************************************************************************/


/* Control modes for @{"ParseIFF()" LINK "gg:doc/NDK/Guide/iffparse/ParseIFF"} function */
#define IFFPARSE_SCAN    0L
#define IFFPARSE_STEP    1L
#define IFFPARSE_RAWSTEP 2L


/*****************************************************************************/


/* Control modes for @{"StoreLocalItem()" LINK "gg:doc/NDK/Guide/iffparse/StoreLocalItem"} function */
#define IFFSLI_ROOT  1L  /* Store in default context      */
#define IFFSLI_TOP   2L  /* Store in current context      */
#define IFFSLI_PROP  3L  /* Store in topmost FORM or LIST */


/*****************************************************************************/


/* Magic value for writing functions. If you pass this value in as a size
 * to @{"PushChunk()" LINK "gg:doc/NDK/Guide/iffparse/PushChunk"} when writing a file, the parser will figure out the
 * size of the chunk for you. If you know the size, is it better to
 * provide as it makes things faster.
 */
#define IFFSIZE_UNKNOWN -1L


/*****************************************************************************/


/* Possible call-back command values */
#define IFFCMD_INIT     0       /* Prepare the stream for a session */
#define IFFCMD_CLEANUP  1       /* Terminate stream session         */
#define IFFCMD_READ     2       /* Read bytes from stream           */
#define IFFCMD_WRITE    3       /* Write bytes to stream            */
#define IFFCMD_SEEK     4       /* Seek on stream                   */
#define IFFCMD_ENTRY    5       /* You just entered a new context   */
#define IFFCMD_EXIT     6       /* You're about to leave a context  */
#define IFFCMD_PURGELCI 7       /* Purge a LocalContextItem         */


/*****************************************************************************/


/* Obsolete IFFParse definitions, here for source code compatibility only.
 * Please do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} use in new code.
 *
 * #define IFFPARSE_V37_NAMES_ONLY to remove these older names
 */
#ifndef IFFPARSE_V37_NAMES_ONLY
#define IFFSCC_INIT     @{"IFFCMD_INIT" LINK File 232}
#define IFFSCC_CLEANUP  @{"IFFCMD_CLEANUP" LINK File 233}
#define IFFSCC_READ     @{"IFFCMD_READ" LINK File 234}
#define IFFSCC_WRITE    @{"IFFCMD_WRITE" LINK File 235}
#define IFFSCC_SEEK     @{"IFFCMD_SEEK" LINK File 236}
#endif


/*****************************************************************************/


#endif /* IFFPARSE_H */
@ENDNODE
