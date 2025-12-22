@DATABASE "gg:doc/NDK/Guide/Include/dos/dosasl.h"
@MASTER   "gg:os-include/dos/dosasl.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:54
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/dosasl.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/dosasl.h" LINK File}


@{b}Structures@{ub}

@{"AChain" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 99}  @{"AnchorPath" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 52}


@{b}#defines@{ub}

@{"APB_DIDDIR" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 83}       @{"APB_DirChanged" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 92}         @{"APB_DODIR" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 78}
@{"APB_DODOT" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 89}        @{"APB_DOWILD" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 69}             @{"APB_FollowHLinks" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 95}
@{"APB_ITSWILD" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 72}      @{"APB_NOMEMERR" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 86}           @{"APF_DIDDIR" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 84}
@{"APF_DirChanged" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 93}   @{"APF_DODIR" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 79}              @{"APF_DODOT" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 90}
@{"APF_DOWILD" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 70}       @{"APF_FollowHLinks" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 96}       @{"APF_ITSWILD" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 73}
@{"APF_NOMEMERR" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 87}     @{"COMPLEX_BIT" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 140}            @{"DDB_AllBit" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 114}
@{"DDB_Completed" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 112}    @{"DDB_ExaminedBit" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 110}        @{"DDB_PatternBit" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 108}
@{"DDB_Single" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 116}       @{"DDF_AllBit" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 115}             @{"DDF_Completed" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 113}
@{"DDF_ExaminedBit" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 111}  @{"DDF_PatternBit" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 109}         @{"DDF_Single" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 117}
@{"ERROR_BREAK" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 150}      @{"ERROR_BUFFER_OVERFLOW" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 149}  @{"ERROR_NOT_EXECUTABLE" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 151}
@{"EXAMINE_BIT" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 141}      @{"P_ANY" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 125}                  @{"P_CLASS" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 133}
@{"P_NOT" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 130}            @{"P_NOTCLASS" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 132}             @{"P_NOTEND" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 131}
@{"P_OREND" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 129}          @{"P_ORNEXT" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 128}               @{"P_ORSTART" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 127}
@{"P_REPBEG" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 134}         @{"P_REPEND" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 135}               @{"P_SINGLE" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 126}
@{"P_STOP" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 136}           

@ENDNODE
@NODE File "dos/dosasl.h"
#ifndef DOS_DOSASL_H
#define DOS_DOSASL_H
/*
**
**      $VER: dosasl.h 36.16 (2.5.1991)
**      Includes Release 45.1
**
**      Pattern-matching structure definitions
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif

#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif


/***********************************************************************
************************ PATTERN MATCHING ******************************
************************************************************************

* structure expected by @{"MatchFirst" LINK "gg:doc/NDK/Guide/dos/MatchFirst"}, @{"MatchNext" LINK "gg:doc/NDK/Guide/dos/MatchNext"}.
* Allocate this structure and initialize it as follows:
*
* Set ap_BreakBits to the signal bits (CDEF) that you want to take a
* break on, or @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}, if you don't want to convenience the user.
*
* If you want to have the FULL PATH NAME of the files you found,
* allocate a buffer at the END of this structure, and put the size of
* it into ap_Strlen.  If you don't want the full path name, make sure
* you set ap_Strlen to zero.  In this case, the name of the file, and stats
* are available in the ap_Info, as per usual.
*
* Then call @{"MatchFirst()" LINK "gg:doc/NDK/Guide/dos/MatchFirst"} and then afterwards, @{"MatchNext()" LINK "gg:doc/NDK/Guide/dos/MatchNext"} with this structure.
* You should check the return value each time (see below) and take the
* appropriate action, ultimately calling @{"MatchEnd()" LINK "gg:doc/NDK/Guide/dos/MatchEnd"} when there are
* no more files and you are done.  You can tell when you are done by
* checking for the normal AmigaDOS return code @{"ERROR_NO_MORE_ENTRIES" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 217}.
*
*/

struct AnchorPath {
        @{"struct AChain" LINK File 99}   *ap_Base;       /* pointer to first anchor */
#define ap_First ap_Base
        @{"struct AChain" LINK File 99}   *ap_Last;       /* pointer to last anchor */
#define ap_Current ap_Last
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    ap_BreakBits;   /* Bits we want to break on */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    ap_FoundBreak;  /* Bits we broke on. Also returns @{"ERROR_BREAK" LINK File 150} */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    ap_Flags;       /* New use for extra word. */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    ap_Reserved;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    ap_Strlen;      /* This is what ap_Length used to be */
#define ap_Length ap_Flags      /* Old compatability for LONGWORD ap_Length */
        @{"struct  FileInfoBlock" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 61} ap_Info;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ap_Buf[1];      /* Buffer for path name, allocated by user */
        /* FIX! */
};


#define APB_DOWILD      0       /* User option ALL */
#define APF_DOWILD      1

#define APB_ITSWILD     1       /* Set by @{"MatchFirst" LINK "gg:doc/NDK/Guide/dos/MatchFirst"}, used by @{"MatchNext" LINK "gg:doc/NDK/Guide/dos/MatchNext"}  */
#define APF_ITSWILD     2       /* Application can test @{"APB_ITSWILD" LINK File 72}, too */
                                /* (means that there's a wildcard        */
                                /* in the pattern after calling          */
                                /* @{"MatchFirst" LINK "gg:doc/NDK/Guide/dos/MatchFirst"}).                          */

#define APB_DODIR       2       /* Bit is SET if a DIR node should be */
#define APF_DODIR       4       /* entered. Application can @{"RESET" LINK "gg:doc/NDK/Guide/exec/RESET"} this */
                                /* bit after @{"MatchFirst" LINK "gg:doc/NDK/Guide/dos/MatchFirst"}/@{"MatchNext" LINK "gg:doc/NDK/Guide/dos/MatchNext"} to AVOID */
                                /* entering a dir. */

#define APB_DIDDIR      3       /* Bit is SET for an "expired" dir node. */
#define APF_DIDDIR      8

#define APB_NOMEMERR    4       /* Set on memory error */
#define APF_NOMEMERR    16

#define APB_DODOT       5       /* If set, allow conversion of '.' to */
#define APF_DODOT       32      /* @{"CurrentDir" LINK "gg:doc/NDK/Guide/dos/CurrentDir"} */

#define APB_DirChanged  6       /* ap_Current->an_Lock changed */
#define APF_DirChanged  64      /* since last @{"MatchNext" LINK "gg:doc/NDK/Guide/dos/MatchNext"} call */

#define APB_FollowHLinks 7      /* follow hardlinks on DODIR - defaults   */
#define APF_FollowHLinks 128    /* to not following hardlinks on a DODIR. */


struct AChain {
        struct AChain *an_Child;
        struct AChain *an_Parent;
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    an_Lock;
        @{"struct FileInfoBlock" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 61} an_Info;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    an_Flags;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   an_String[1];   /* FIX!! */
};

#define DDB_PatternBit  0
#define DDF_PatternBit  1
#define DDB_ExaminedBit 1
#define DDF_ExaminedBit 2
#define DDB_Completed   2
#define DDF_Completed   4
#define DDB_AllBit      3
#define DDF_AllBit      8
#define DDB_Single      4
#define DDF_Single      16

/*
 * Constants used by wildcard routines, these are the pre-parsed tokens
 * referred to by pattern match.  It is not necessary for you to do
 * anything about these, @{"MatchFirst()" LINK "gg:doc/NDK/Guide/dos/MatchFirst"} @{"MatchNext()" LINK "gg:doc/NDK/Guide/dos/MatchNext"} handle all these for you.
 */

#define P_ANY           0x80    /* Token for '*' or '#?  */
#define P_SINGLE        0x81    /* Token for '?' */
#define P_ORSTART       0x82    /* Token for '(' */
#define P_ORNEXT        0x83    /* Token for '|' */
#define P_OREND 0x84    /* Token for ')' */
#define P_NOT           0x85    /* Token for '~' */
#define P_NOTEND        0x86    /* Token for */
#define P_NOTCLASS      0x87    /* Token for '^' */
#define P_CLASS 0x88    /* Token for '[]' */
#define P_REPBEG        0x89    /* Token for '[' */
#define P_REPEND        0x8A    /* Token for ']' */
#define P_STOP          0x8B    /* token to force end of evaluation */

/* Values for an_Status, NOTE: These are the actual bit numbers */

#define COMPLEX_BIT     1       /* Parsing complex pattern */
#define EXAMINE_BIT     2       /* Searching directory */

/*
 * Returns from @{"MatchFirst()" LINK "gg:doc/NDK/Guide/dos/MatchFirst"}, @{"MatchNext()" LINK "gg:doc/NDK/Guide/dos/MatchNext"}
 * You can also get dos error returns, such as @{"ERROR_NO_MORE_ENTRIES" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 217},
 * these are in the dos.h file.
 */

#define ERROR_BUFFER_OVERFLOW   303     /* User or internal buffer overflow */
#define ERROR_BREAK             304     /* A break character was received */
#define ERROR_NOT_EXECUTABLE    305     /* A file has E bit cleared */

#endif /* DOS_DOSASL_H */
@ENDNODE
