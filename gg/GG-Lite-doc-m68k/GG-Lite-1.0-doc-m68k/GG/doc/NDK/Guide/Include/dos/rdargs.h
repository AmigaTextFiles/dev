@DATABASE "gg:doc/NDK/Guide/Include/dos/rdargs.h"
@MASTER   "gg:os-include/dos/rdargs.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/rdargs.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/rdargs.h" LINK File}


@{b}Structures@{ub}

@{"CSource" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 61}  @{"RDArgs" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 95}


@{b}#defines@{ub}

@{"MAX_MULTIARGS" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 122}  @{"MAX_TEMPLATE_ITEMS" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 115}  @{"RDAB_NOALLOC" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 106}   @{"RDAB_NOPROMPT" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 108}
@{"RDAB_STDIN" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 104}     @{"RDAF_NOALLOC" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 107}        @{"RDAF_NOPROMPT" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 109}  @{"RDAF_STDIN" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 105}

@ENDNODE
@NODE File "dos/rdargs.h"
#ifndef DOS_RDARGS_H
#define DOS_RDARGS_H
/*
**
**      $VER: rdargs.h 36.6 (12.7.1990)
**      Includes Release 45.1
**
**      @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"} structure definitions
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

/**********************************************************************
 *
 * The CSource data structure defines the input source for "@{"ReadItem()" LINK "gg:doc/NDK/Guide/dos/ReadItem"}"
 * as well as the @{"ReadArgs" LINK "gg:doc/NDK/Guide/dos/ReadArgs"} call.  It is a publicly defined structure
 * which may be used by applications which use code that follows the
 * conventions defined for access.
 *
 * When passed to the @{"dos.library" LINK "gg:doc/NDK/Guide/dos/MAIN"} functions, the value passed as
 * struct *CSource is defined as follows:
 *      if ( CSource == 0)      Use buffered IO "@{"ReadChar" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 15}()" as data source
 *      else                    Use CSource for input character stream
 *
 * The following two pseudo-code routines define how the CSource structure
 * is used:
 *
 * long CS_ReadChar( @{"struct CSource" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 61} *CSource )
 * {
 *      if ( CSource == 0 )     return @{"ReadChar" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 15}();
 *      if ( CSource->CurChr >= CSource->Length )       return ENDSTREAMCHAR;
 *      return CSource->Buffer[ CSource->CurChr++ ];
 * }
 *
 * @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} CS_UnReadChar( @{"struct CSource" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 61} *CSource )
 * {
 *      if ( CSource == 0 )     return @{"UnReadChar" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 17}();
 *      if ( CSource->CurChr <= 0 )     return @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98};
 *      CSource->CurChr--;
 *      return @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95};
 * }
 *
 * To initialize a @{"struct CSource" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 61}, you set CSource->CS_Buffer to
 * a string which is used as the data source, and set CS_Length to
 * the number of characters in the string.  Normally CS_CurChr should
 * be initialized to ZERO, or left as it was from prior use as
 * a CSource.
 *
 **********************************************************************/

struct CSource {
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *CS_Buffer;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    CS_Length;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    CS_CurChr;
};

/**********************************************************************
 *
 * The RDArgs data structure is the input parameter passed to the DOS
 * @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"} function call.
 *
 * The RDA_Source structure is a CSource as defined above;
 * if RDA_Source.CS_Buffer is non-null, RDA_Source is used as the input
 * character stream to parse, else the input comes from the buffered STDIN
 * calls @{"ReadChar" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 15}/@{"UnReadChar" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 17}.
 *
 * RDA_DAList is a private address which is used internally to track
 * allocations which are freed by @{"FreeArgs()" LINK "gg:doc/NDK/Guide/dos/FreeArgs"}.  This MUST be initialized
 * to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} prior to the first call to @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"}.
 *
 * The RDA_Buffer and RDA_BufSiz fields allow the application to supply
 * a fixed-size buffer in which to store the parsed data.  This allows
 * the application to pre-allocate a buffer rather than requiring buffer
 * space to be allocated.  If either RDA_Buffer or RDA_BufSiz is @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101},
 * the application has not supplied a buffer.
 *
 * RDA_ExtHelp is a text string which will be displayed instead of the
 * template string, if the user is prompted for input.
 *
 * RDA_Flags bits control how @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"} works.  The flag bits are
 * defined below.  Defaults are initialized to ZERO.
 *
 **********************************************************************/

struct RDArgs {
        @{"struct  CSource" LINK File 61} RDA_Source;     /* Select input source */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    RDA_DAList;             /* PRIVATE. */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *RDA_Buffer;            /* Optional string parsing space. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    RDA_BufSiz;             /* Size of RDA_Buffer (0..n) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *RDA_ExtHelp;           /* Optional extended help */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    RDA_Flags;              /* Flags for any required control */
};

#define RDAB_STDIN      0       /* Use "STDIN" rather than "COMMAND LINE" */
#define RDAF_STDIN      1
#define RDAB_NOALLOC    1       /* If set, do not allocate extra string space.*/
#define RDAF_NOALLOC    2
#define RDAB_NOPROMPT   2       /* Disable reprompting for string input. */
#define RDAF_NOPROMPT   4

/**********************************************************************
 * Maximum number of template keywords which can be in a template passed
 * to @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"}. IMPLEMENTOR NOTE - must be a multiple of 4.
 **********************************************************************/
#define MAX_TEMPLATE_ITEMS      100

/**********************************************************************
 * Maximum number of MULTIARG items returned by @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"}, before
 * an @{"ERROR_LINE_TOO_LONG" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 189}.  These two limitations are due to stack
 * usage.  Applications should allow "a lot" of stack to use @{"ReadArgs()" LINK "gg:doc/NDK/Guide/dos/ReadArgs"}.
 **********************************************************************/
#define MAX_MULTIARGS           128

#endif /* DOS_RDARGS_H */
@ENDNODE
