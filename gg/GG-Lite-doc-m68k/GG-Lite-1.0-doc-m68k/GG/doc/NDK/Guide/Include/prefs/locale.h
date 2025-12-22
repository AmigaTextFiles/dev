@DATABASE "gg:doc/NDK/Guide/Include/prefs/locale.h"
@MASTER   "gg:os-include/prefs/locale.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/locale.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/locale.h" LINK File}


@{b}Structures@{ub}

@{"CountryPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/locale.h/File" 32}  @{"LocalePrefs" LINK "gg:doc/NDK/Guide/Include/prefs/locale.h/File" 84}


@{b}#defines@{ub}

@{"ID_CTRY" LINK "gg:doc/NDK/Guide/Include/prefs/locale.h/File" 29}  @{"ID_LCLE" LINK "gg:doc/NDK/Guide/Include/prefs/locale.h/File" 28}

@ENDNODE
@NODE File "prefs/locale.h"
#ifndef PREFS_LOCALE_H
#define PREFS_LOCALE_H
/*
**      $VER: locale.h 38.4 (5.12.1991)
**      Includes Release 45.1
**
**      File format for locale preferences
**
**      (C) Copyright 1991-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif


/*****************************************************************************/


#define ID_LCLE @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('L','C','L','E')
#define ID_CTRY @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('C','T','R','Y')


struct CountryPrefs
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cp_Reserved[4];
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cp_CountryCode;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cp_TelephoneCode;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MeasuringSystem;

    char  cp_DateTimeFormat[80];
    char  cp_DateFormat[40];
    char  cp_TimeFormat[40];

    char  cp_ShortDateTimeFormat[80];
    char  cp_ShortDateFormat[40];
    char  cp_ShortTimeFormat[40];

    /* for numeric values */
    char  cp_DecimalPoint[10];
    char  cp_GroupSeparator[10];
    char  cp_FracGroupSeparator[10];
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_Grouping[10];
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_FracGrouping[10];

    /* for monetary values */
    char  cp_MonDecimalPoint[10];
    char  cp_MonGroupSeparator[10];
    char  cp_MonFracGroupSeparator[10];
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonGrouping[10];
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonFracGrouping[10];
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonFracDigits;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonIntFracDigits;

    /* for currency symbols */
    char  cp_MonCS[10];
    char  cp_MonSmallCS[10];
    char  cp_MonIntCS[10];

    /* for positive monetary values */
    char  cp_MonPositiveSign[10];
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonPositiveSpaceSep;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonPositiveSignPos;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonPositiveCSPos;

    /* for negative monetary values */
    char  cp_MonNegativeSign[10];
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonNegativeSpaceSep;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonNegativeSignPos;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_MonNegativeCSPos;

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} cp_CalendarType;
};


struct LocalePrefs
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               lp_Reserved[4];
    char                lp_CountryName[32];
    char                lp_PreferredLanguages[10][30];
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                lp_GMTOffset;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               lp_Flags;
    @{"struct CountryPrefs" LINK File 32} lp_CountryData;
};


/*****************************************************************************/


#endif /* PREFS_LOCALE_H */
@ENDNODE
