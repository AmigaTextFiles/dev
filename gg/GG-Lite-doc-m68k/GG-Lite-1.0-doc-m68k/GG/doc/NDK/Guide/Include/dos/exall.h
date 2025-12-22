@DATABASE "gg:doc/NDK/Guide/Include/dos/exall.h"
@MASTER   "gg:os-include/dos/exall.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/exall.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/exall.h" LINK File}


@{b}Structures@{ub}

@{"ExAllControl" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 70}  @{"ExAllData" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 45}


@{b}#defines@{ub}

@{"ED_COMMENT" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 37}  @{"ED_DATE" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 36}  @{"ED_NAME" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 32}  @{"ED_OWNER" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 38}  @{"ED_PROTECTION" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 35}  @{"ED_SIZE" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 34}
@{"ED_TYPE" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 33}     

@ENDNODE
@NODE File "dos/exall.h"
#ifndef DOS_EXALL_H
#define DOS_EXALL_H
/*
**
**      $VER: exall.h 36.6 (5.4.1992)
**      Includes Release 45.1
**
**      include file for @{"ExAll()" LINK "gg:doc/NDK/Guide/dos/ExAll"} data structures
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

/* NOTE: V37 @{"dos.library" LINK "gg:doc/NDK/Guide/dos/MAIN"}, when doing @{"ExAll()" LINK "gg:doc/NDK/Guide/dos/ExAll"} emulation, and V37 filesystems  */
/* will return an error if passed @{"ED_OWNER" LINK File 38}.  If you get @{"ERROR_BAD_NUMBER" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 184},    */
/* retry with @{"ED_COMMENT" LINK File 37} to get everything but owner info.  All filesystems  */
/* supporting @{"ExAll()" LINK "gg:doc/NDK/Guide/dos/ExAll"} must support through @{"ED_COMMENT" LINK File 37}, and must check Type   */
/* and return @{"ERROR_BAD_NUMBER" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 184} if they don't support the type.               */

/* values that can be passed for what data you want from @{"ExAll()" LINK "gg:doc/NDK/Guide/dos/ExAll"} */
/* each higher value includes those below it (numerically)       */
/* you MUST chose one of these values */
#define ED_NAME         1
#define ED_TYPE         2
#define ED_SIZE         3
#define ED_PROTECTION   4
#define ED_DATE         5
#define ED_COMMENT      6
#define ED_OWNER        7

/*
 *   Structure in which exall results are returned in.  Note that only the
 *   fields asked for will exist!
 */

struct ExAllData {
        struct ExAllData *ed_Next;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}  *ed_Name;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    ed_Type;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ed_Size;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ed_Prot;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ed_Days;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ed_Mins;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ed_Ticks;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}  *ed_Comment;     /* strings will be after last used field */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ed_OwnerUID;    /* new for V39 */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ed_OwnerGID;
};

/*
 *   Control structure passed to @{"ExAll" LINK "gg:doc/NDK/Guide/dos/ExAll"}.  Unused fields MUST be initialized to
 *   0, expecially eac_LastKey.
 *
 *   eac_MatchFunc is a hook (see @{"utility.library" LINK "gg:doc/NDK/Guide/utility/MAIN"} documentation for usage)
 *   It should return true if the entry is to returned, false if it is to be
 *   ignored.
 *
 *   This structure MUST be allocated by @{"AllocDosObject()" LINK "gg:doc/NDK/Guide/dos/AllocDosObject"}!
 */

struct ExAllControl {
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   eac_Entries;     /* number of entries returned in buffer      */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   eac_LastKey;     /* Don't touch inbetween linked @{"ExAll" LINK "gg:doc/NDK/Guide/dos/ExAll"} calls! */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}  *eac_MatchString; /* wildcard string for pattern match or @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} */
        @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *eac_MatchFunc; /* optional private wildcard function     */
};

#endif /* DOS_EXALL_H */
@ENDNODE
