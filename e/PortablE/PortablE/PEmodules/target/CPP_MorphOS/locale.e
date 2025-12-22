/* $VER: locale_protos.h 38.5 (18.6.1993) */
OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/libraries/locale'
MODULE 'target/exec/types', /*'target/libraries/locale',*/ 'target/dos/dos', 'target/utility/hooks', 'target/utility/tagitem', 'target/rexx/storage'
MODULE 'target/exec/libraries'
{
#include <proto/locale.h>
}
{
struct Library* LocaleBase = NULL;
}
NATIVE {CLIB_LOCALE_PROTOS_H} CONST
NATIVE {_PROTO_LOCALE_H} CONST
NATIVE {PRAGMA_LOCALE_H} CONST
NATIVE {PRAGMAS_LOCALE_PRAGMAS_H} CONST

NATIVE {LocaleBase} DEF localebase:PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V38 or higher (Release 2.1) ---*/
NATIVE {CloseCatalog} PROC
PROC CloseCatalog( catalog:PTR TO catalog ) IS NATIVE {CloseCatalog(} catalog {)} ENDNATIVE
NATIVE {CloseLocale} PROC
PROC CloseLocale( locale:PTR TO locale ) IS NATIVE {CloseLocale(} locale {)} ENDNATIVE
NATIVE {ConvToLower} PROC
PROC ConvToLower( locale:PTR TO locale, character:ULONG ) IS NATIVE {ConvToLower(} locale {,} character {)} ENDNATIVE !!ULONG
NATIVE {ConvToUpper} PROC
PROC ConvToUpper( locale:PTR TO locale, character:ULONG ) IS NATIVE {ConvToUpper(} locale {,} character {)} ENDNATIVE !!ULONG
NATIVE {FormatDate} PROC
PROC FormatDate( locale:PTR TO locale, fmtTemplate:/*STRPTR*/ ARRAY OF CHAR, date:PTR TO datestamp, putCharFunc:PTR TO hook ) IS NATIVE {FormatDate(} locale {,} fmtTemplate {,} date {,} putCharFunc {)} ENDNATIVE
NATIVE {FormatString} PROC
PROC FormatString( locale:PTR TO locale, fmtTemplate:/*STRPTR*/ ARRAY OF CHAR, dataStream:APTR, putCharFunc:PTR TO hook ) IS NATIVE {FormatString(} locale {,} fmtTemplate {,} dataStream {,} putCharFunc {)} ENDNATIVE !!APTR
NATIVE {GetCatalogStr} PROC
PROC GetCatalogStr( catalog:PTR TO catalog, stringNum:VALUE, defaultString:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {GetCatalogStr(} catalog {,} stringNum {,} defaultString {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {GetLocaleStr} PROC
PROC GetLocaleStr( locale:PTR TO locale, stringNum:ULONG ) IS NATIVE {GetLocaleStr(} locale {,} stringNum {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {IsAlNum} PROC
PROC IsAlNum( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsAlNum(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsAlpha} PROC
PROC IsAlpha( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsAlpha(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsCntrl} PROC
PROC IsCntrl( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsCntrl(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsDigit} PROC
PROC IsDigit( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsDigit(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsGraph} PROC
PROC IsGraph( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsGraph(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsLower} PROC
PROC IsLower( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsLower(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsPrint} PROC
PROC IsPrint( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsPrint(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsPunct} PROC
PROC IsPunct( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsPunct(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsSpace} PROC
PROC IsSpace( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsSpace(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsUpper} PROC
PROC IsUpper( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsUpper(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {IsXDigit} PROC
PROC IsXDigit( locale:PTR TO locale, character:ULONG ) IS NATIVE {-IsXDigit(} locale {,} character {)} ENDNATIVE !!INT
NATIVE {OpenCatalogA} PROC
PROC OpenCatalogA( locale:PTR TO locale, name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {OpenCatalogA(} locale {,} name {,} tags {)} ENDNATIVE !!PTR TO catalog
NATIVE {OpenCatalog} PROC
PROC OpenCatalog( locale:PTR TO locale, name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {OpenCatalog(} locale {,} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO catalog
NATIVE {OpenLocale} PROC
PROC OpenLocale( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {OpenLocale(} name {)} ENDNATIVE !!PTR TO locale
NATIVE {ParseDate} PROC
PROC ParseDate( locale:PTR TO locale, date:PTR TO datestamp, fmtTemplate:/*STRPTR*/ ARRAY OF CHAR, getCharFunc:PTR TO hook ) IS NATIVE {-ParseDate(} locale {,} date {,} fmtTemplate {,} getCharFunc {)} ENDNATIVE !!INT
NATIVE {StrConvert} PROC
PROC StrConvert( locale:PTR TO locale, string:/*STRPTR*/ ARRAY OF CHAR, buffer:APTR, bufferSize:ULONG, type:ULONG ) IS NATIVE {StrConvert(} locale {,} string {,} buffer {,} bufferSize {,} type {)} ENDNATIVE !!ULONG
NATIVE {StrnCmp} PROC
PROC StrnCmp( locale:PTR TO locale, string1:/*STRPTR*/ ARRAY OF CHAR, string2:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, type:ULONG ) IS NATIVE {StrnCmp(} locale {,} string1 {,} string2 {,} length {,} type {)} ENDNATIVE !!VALUE
