@DATABASE "gg:doc/NDK/Guide/Include/inline/locale.h"
@MASTER   "gg:os-include/inline/locale.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:13
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/locale.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/locale.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_LOCALE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 5}  @{"CloseCatalog()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 35}  @{"CloseLocale()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 39}   @{"ConvToLower()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 43}
@{"ConvToUpper()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 47}         @{"FormatDate()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 51}    @{"FormatString()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 55}  @{"GetCatalogStr()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 59}
@{"GetLocaleStr()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 63}        @{"IsAlNum()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 67}       @{"IsAlpha()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 71}       @{"IsCntrl()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 75}
@{"IsDigit()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 79}             @{"IsGraph()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 83}       @{"IsLower()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 87}       @{"IsPrint()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 91}
@{"IsPunct()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 95}             @{"IsSpace()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 99}       @{"IsUpper()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 103}       @{"IsXDigit()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 107}
@{"LOCALE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 32}      @{"OpenCatalog()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 116}   @{"OpenCatalogA()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 111}  @{"OpenLocale()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 120}
@{"ParseDate()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 124}           @{"StrConvert()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 128}    @{"StrnCmp()" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File" 132}       

@ENDNODE
@NODE File "inline/locale.h"
#ifndef _INLINE_LOCALE_H
#define _INLINE_LOCALE_H

#ifndef CLIB_LOCALE_PROTOS_H
#define CLIB_LOCALE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

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

#ifndef LOCALE_BASE_NAME
#define LOCALE_BASE_NAME LocaleBase
#endif

#define @{"CloseCatalog" LINK "gg:doc/NDK/Guide/locale/CloseCatalog"}(catalog) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"CloseCatalog" LINK File 35}, @{"struct Catalog" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 246} *, catalog, a0, \\
        , LOCALE_BASE_NAME)

#define @{"CloseLocale" LINK "gg:doc/NDK/Guide/locale/CloseLocale"}(locale) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"CloseLocale" LINK File 39}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, \\
        , LOCALE_BASE_NAME)

#define @{"ConvToLower" LINK "gg:doc/NDK/Guide/locale/ConvToLower"}(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ConvToLower" LINK File 43}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define @{"ConvToUpper" LINK "gg:doc/NDK/Guide/locale/ConvToUpper"}(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ConvToUpper" LINK File 47}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define @{"FormatDate" LINK "gg:doc/NDK/Guide/locale/FormatDate"}(locale, fmtTemplate, date, putCharFunc) \\
        @{"LP4NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}(0x3c, @{"FormatDate" LINK File 51}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, STRPTR, fmtTemplate, a1, struct DateStamp *, date, a2, struct Hook *, putCharFunc, a3, \\
        , LOCALE_BASE_NAME)

#define @{"FormatString" LINK "gg:doc/NDK/Guide/locale/FormatString"}(locale, fmtTemplate, dataStream, putCharFunc) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x42, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"FormatString" LINK File 55}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, STRPTR, fmtTemplate, a1, APTR, dataStream, a2, struct Hook *, putCharFunc, a3, \\
        , LOCALE_BASE_NAME)

#define @{"GetCatalogStr" LINK "gg:doc/NDK/Guide/locale/GetCatalogStr"}(catalog, stringNum, defaultString) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x48, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"GetCatalogStr" LINK File 59}, @{"struct Catalog" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 246} *, catalog, a0, LONG, stringNum, d0, STRPTR, defaultString, a1, \\
        , LOCALE_BASE_NAME)

#define @{"GetLocaleStr" LINK "gg:doc/NDK/Guide/locale/GetLocaleStr"}(locale, stringNum) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x4e, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"GetLocaleStr" LINK File 63}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, stringNum, d0, \\
        , LOCALE_BASE_NAME)

#define IsAlNum(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x54, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsAlNum" LINK File 67}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsAlpha(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x5a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsAlpha" LINK File 71}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsCntrl(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsCntrl" LINK File 75}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsDigit(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x66, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsDigit" LINK File 79}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsGraph(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x6c, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsGraph" LINK File 83}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsLower(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x72, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsLower" LINK File 87}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsPrint(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x78, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsPrint" LINK File 91}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsPunct(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x7e, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsPunct" LINK File 95}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsSpace(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x84, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsSpace" LINK File 99}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsUpper(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x8a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsUpper" LINK File 103}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define IsXDigit(locale, character) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x90, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsXDigit" LINK File 107}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, ULONG, character, d0, \\
        , LOCALE_BASE_NAME)

#define @{"OpenCatalogA" LINK "gg:doc/NDK/Guide/locale/OpenCatalog"}(locale, name, tags) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x96, @{"struct Catalog" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 246} *, OpenCatalogA, struct Locale *, locale, a0, STRPTR, name, a1, struct TagItem *, tags, a2, \\
        , LOCALE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"OpenCatalog" LINK "gg:doc/NDK/Guide/locale/OpenCatalog"}(locale, name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"OpenCatalogA" LINK File 111}((locale), (name), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"OpenLocale" LINK "gg:doc/NDK/Guide/locale/OpenLocale"}(name) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x9c, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, OpenLocale, STRPTR, name, a0, \\
        , LOCALE_BASE_NAME)

#define @{"ParseDate" LINK "gg:doc/NDK/Guide/locale/ParseDate"}(locale, date, fmtTemplate, getCharFunc) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0xa2, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"ParseDate" LINK File 124}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, struct DateStamp *, date, a1, STRPTR, fmtTemplate, a2, struct Hook *, getCharFunc, a3, \\
        , LOCALE_BASE_NAME)

#define @{"StrConvert" LINK "gg:doc/NDK/Guide/locale/StrConvert"}(locale, string, buffer, bufferSize, type) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0xae, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"StrConvert" LINK File 128}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, STRPTR, string, a1, APTR, buffer, a2, ULONG, bufferSize, d0, ULONG, type, d1, \\
        , LOCALE_BASE_NAME)

#define @{"StrnCmp" LINK "gg:doc/NDK/Guide/locale/StrnCmp"}(locale, string1, string2, length, type) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0xb4, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"StrnCmp" LINK File 132}, @{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118} *, locale, a0, STRPTR, string1, a1, STRPTR, string2, a2, LONG, length, d0, ULONG, type, d1, \\
        , LOCALE_BASE_NAME)

#endif /*  _INLINE_LOCALE_H  */
@ENDNODE
