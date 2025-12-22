@DATABASE "gg:doc/NDK/Guide/Include/clib/locale_protos.h"
@MASTER   "gg:os-include/clib/locale_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/locale_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/locale_protos.h" LINK File}

@ENDNODE
@NODE File "clib/locale_protos.h"
#ifndef  CLIB_LOCALE_PROTOS_H
#define  CLIB_LOCALE_PROTOS_H

/*
**      $VER: locale_protos.h 38.5 (18.6.1993)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  LIBRARIES_LOCALE_H
#include <@{"libraries/locale.h" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File"}>
#endif
#ifndef  DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif
/*--- functions in V38 or higher (Release 2.1) ---*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseCatalog" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 35}( @{"struct Catalog" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 246} *catalog );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseLocale" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 39}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ConvToLower" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 43}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ConvToUpper" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 47}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FormatDate" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 51}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, STRPTR fmtTemplate, struct DateStamp *date, struct Hook *putCharFunc );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"FormatString" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 55}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, STRPTR fmtTemplate, APTR dataStream, struct Hook *putCharFunc );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"GetCatalogStr" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 59}( @{"struct Catalog" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 246} *catalog, LONG stringNum, STRPTR defaultString );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"GetLocaleStr" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 63}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG stringNum );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsAlNum" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 67}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsAlpha" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 71}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsCntrl" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 75}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsDigit" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 79}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsGraph" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 83}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsLower" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 87}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsPrint" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 91}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsPunct" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 95}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsSpace" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 99}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsUpper" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 103}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsXDigit" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 107}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, ULONG character );
@{"struct Catalog" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 246} *OpenCatalogA( struct Locale *locale, STRPTR name, struct TagItem *tags );
@{"struct Catalog" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 246} *OpenCatalog( struct Locale *locale, STRPTR name, Tag tag1, ... );
@{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *OpenLocale( STRPTR name );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ParseDate" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 124}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, struct DateStamp *date, STRPTR fmtTemplate, struct Hook *getCharFunc );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"StrConvert" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 128}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, STRPTR string, APTR buffer, ULONG bufferSize, ULONG type );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"StrnCmp" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 132}( @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *locale, STRPTR string1, STRPTR string2, LONG length, ULONG type );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_LOCALE_PROTOS_H */
@ENDNODE
