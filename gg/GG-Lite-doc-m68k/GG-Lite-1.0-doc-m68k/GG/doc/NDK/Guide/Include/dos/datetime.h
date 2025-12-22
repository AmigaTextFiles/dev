@DATABASE "gg:doc/NDK/Guide/Include/dos/datetime.h"
@MASTER   "gg:os-include/dos/datetime.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/datetime.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/datetime.h" LINK File}


@{b}Structures@{ub}

@{"DateTime" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 25}


@{b}#defines@{ub}

@{"DTB_FUTURE" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 41}     @{"DTB_SUBST" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 39}   @{"DTF_FUTURE" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 42}  @{"DTF_SUBST" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 40}   @{"FORMAT_CDN" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 51}
@{"FORMAT_DEF" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 53}     @{"FORMAT_DOS" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 48}  @{"FORMAT_INT" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 49}  @{"FORMAT_MAX" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 52}  @{"FORMAT_USA" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 50}
@{"LEN_DATSTRING" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 35}  

@ENDNODE
@NODE File "dos/datetime.h"
#ifndef DOS_DATETIME_H
#define DOS_DATETIME_H

/*
**      $VER: datetime.h 45.1 (17.12.2001)
**      Includes Release 45.1
**
**      Date and time C header for AmigaDOS
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

/*
 *      Data structures and equates used by the V1.4 DOS functions
 * StrtoDate() and DatetoStr()
 */

/*--------- String/Date structures etc */
struct DateTime {
        @{"struct DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52} dat_Stamp;     /* DOS @{"DateStamp" LINK "gg:doc/NDK/Guide/dos/DateStamp"} */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   dat_Format;             /* controls appearance of dat_StrDate */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   dat_Flags;              /* see BITDEF's below */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *dat_StrDay;            /* day of the week string */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *dat_StrDate;           /* date string */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *dat_StrTime;           /* time string */
};

/* You need this much room for each of the DateTime strings: */
#define LEN_DATSTRING   16

/*      flags for dat_Flags */

#define DTB_SUBST       0               /* substitute Today, Tomorrow, etc. */
#define DTF_SUBST       1
#define DTB_FUTURE      1               /* day of the week is in future */
#define DTF_FUTURE      2

/*
 *      date format values
 */

#define FORMAT_DOS      0               /* dd-mmm-yy */
#define FORMAT_INT      1               /* yy-mm-dd  */
#define FORMAT_USA      2               /* mm-dd-yy  */
#define FORMAT_CDN      3               /* dd-mm-yy  */
#define FORMAT_MAX      @{"FORMAT_CDN" LINK File 51}
#define FORMAT_DEF      4               /* use default format, as defined
                                           by locale; if locale not
                                           available, use @{"FORMAT_DOS" LINK File 48}
                                           instead */

#endif /* DOS_DATETIME_H */
@ENDNODE
