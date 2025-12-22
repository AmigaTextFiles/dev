@DATABASE "gg:doc/NDK/Guide/Include/exec/resident.h"
@MASTER   "gg:os-include/exec/resident.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:17
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/resident.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/resident.h" LINK File}


@{b}Structures@{ub}

@{"Resident" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 18}


@{b}#defines@{ub}

@{"RTC_MATCHWORD" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 31}   @{"RTF_AFTERDOS" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 34}   @{"RTF_AUTOINIT" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 33}  @{"RTF_COLDSTART" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 36}
@{"RTF_SINGLETASK" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 35}  @{"RTW_COLDSTART" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 41}  @{"RTW_NEVER" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 40}     

@ENDNODE
@NODE File "exec/resident.h"
#ifndef EXEC_RESIDENT_H
#define EXEC_RESIDENT_H
/*
**      $VER: resident.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Resident/ROMTag stuff.  Used to identify and initialize code modules.
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif /* EXEC_TYPES_H */


struct Resident {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} rt_MatchWord; /* word to match on (ILLEGAL)   */
    struct Resident *rt_MatchTag; /* pointer to the above       */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}  rt_EndSkip;           /* address to continue scan     */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} rt_Flags;             /* various tag flags            */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} rt_Version;           /* release version number       */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} rt_Type;              /* type of module (NT_XXXXXX)   */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}  rt_Pri;               /* initialization priority */
    char  *rt_Name;             /* pointer to node name */
    char  *rt_IdString; /* pointer to identification string */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}  rt_Init;              /* pointer to init code */
};

#define RTC_MATCHWORD   0x4AFC  /* The 68000 "ILLEGAL" instruction */

#define RTF_AUTOINIT    (1<<7)  /* rt_Init points to data structure */
#define RTF_AFTERDOS    (1<<2)
#define RTF_SINGLETASK  (1<<1)
#define RTF_COLDSTART   (1<<0)

/* Compatibility: (obsolete) */
/* #define RTM_WHEN        3 */
#define RTW_NEVER       0
#define RTW_COLDSTART   1

#endif  /* EXEC_RESIDENT_H */
@ENDNODE
