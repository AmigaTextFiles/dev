/* $Id: locale_protos.h,v 1.12 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/libraries/locale'
MODULE 'target/exec/types', /*'target/libraries/locale',*/ 'target/dos/dos', 'target/utility/hooks', 'target/utility/tagitem', 'target/rexx/storage'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/dos/datetime'
{
#include <proto/locale.h>
}
{
struct Library* LocaleBase = NULL;
struct LocaleIFace* ILocale = NULL;
}
NATIVE {CLIB_LOCALE_PROTOS_H} CONST
NATIVE {PROTO_LOCALE_H} CONST
NATIVE {PRAGMA_LOCALE_H} CONST
NATIVE {INLINE4_LOCALE_H} CONST
NATIVE {LOCALE_INTERFACE_DEF_H} CONST

NATIVE {LocaleBase} DEF localebase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {ILocale}    DEF

PROC new()
	InitLibrary('locale.library', NATIVE {(struct Interface **) &ILocale} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V38 or higher (Release 2.1) ---*/
->NATIVE {CloseCatalog} PROC
PROC CloseCatalog( catalog:PTR TO catalog ) IS NATIVE {ILocale->CloseCatalog(} catalog {)} ENDNATIVE
->NATIVE {CloseLocale} PROC
PROC CloseLocale( locale:PTR TO locale ) IS NATIVE {ILocale->CloseLocale(} locale {)} ENDNATIVE
->NATIVE {ConvToLower} PROC
PROC ConvToLower( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->ConvToLower(} locale {,} character {)} ENDNATIVE !!ULONG
->NATIVE {ConvToUpper} PROC
PROC ConvToUpper( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->ConvToUpper(} locale {,} character {)} ENDNATIVE !!ULONG
->NATIVE {FormatDate} PROC
PROC FormatDate( locale:PTR TO locale, fmtTemplate:/*CONST_STRPTR*/ ARRAY OF CHAR, date:PTR TO datestamp, putCharFunc:PTR TO hook ) IS NATIVE {ILocale->FormatDate(} locale {,} fmtTemplate {,} date {,} putCharFunc {)} ENDNATIVE
->NATIVE {FormatString} PROC
PROC FormatString( locale:PTR TO locale, fmtTemplate:/*CONST_STRPTR*/ ARRAY OF CHAR, dataStream:APTR, putCharFunc:PTR TO hook ) IS NATIVE {ILocale->FormatString(} locale {,} fmtTemplate {,} dataStream {,} putCharFunc {)} ENDNATIVE !!APTR
->NATIVE {GetCatalogStr} PROC
PROC GetCatalogStr( catalog:PTR TO catalog, stringNum:VALUE, defaultString:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ILocale->GetCatalogStr(} catalog {,} stringNum {,} defaultString {)} ENDNATIVE !!CONST_STRPTR
->NATIVE {GetLocaleStr} PROC
PROC GetLocaleStr( locale:PTR TO locale, stringNum:ULONG ) IS NATIVE {ILocale->GetLocaleStr(} locale {,} stringNum {)} ENDNATIVE !!CONST_STRPTR
->NATIVE {IsAlNum} PROC
PROC IsAlNum( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsAlNum(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsAlpha} PROC
PROC IsAlpha( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsAlpha(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsCntrl} PROC
PROC IsCntrl( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsCntrl(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsDigit} PROC
PROC IsDigit( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsDigit(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsGraph} PROC
PROC IsGraph( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsGraph(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsLower} PROC
PROC IsLower( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsLower(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsPrint} PROC
PROC IsPrint( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsPrint(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsPunct} PROC
PROC IsPunct( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsPunct(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsSpace} PROC
PROC IsSpace( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsSpace(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsUpper} PROC
PROC IsUpper( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsUpper(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {IsXDigit} PROC
PROC IsXDigit( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsXDigit(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {OpenCatalogA} PROC
PROC OpenCatalogA( locale:PTR TO locale, name:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {ILocale->OpenCatalogA(} locale {,} name {,} tags {)} ENDNATIVE !!PTR TO catalog
->NATIVE {OpenCatalog} PROC
PROC OpenCatalog( locale:PTR TO locale, name:/*CONST_STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {ILocale->OpenCatalog(} locale {,} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO catalog
->NATIVE {OpenLocale} PROC
PROC OpenLocale( name:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ILocale->OpenLocale(} name {)} ENDNATIVE !!PTR TO locale
->NATIVE {ParseDate} PROC
PROC ParseDate( locale:PTR TO locale, date:PTR TO datestamp, fmtTemplate:/*CONST_STRPTR*/ ARRAY OF CHAR, getCharFunc:PTR TO hook ) IS NATIVE {ILocale->ParseDate(} locale {,} date {,} fmtTemplate {,} getCharFunc {)} ENDNATIVE !!VALUE
->NATIVE {StrConvert} PROC
PROC StrConvert( locale:PTR TO locale, string:/*CONST_STRPTR*/ ARRAY OF CHAR, buffer:APTR, bufferSize:ULONG, type:ULONG ) IS NATIVE {ILocale->StrConvert(} locale {,} string {,} buffer {,} bufferSize {,} type {)} ENDNATIVE !!ULONG
->NATIVE {StrnCmp} PROC
PROC StrnCmp( locale:PTR TO locale, string1:/*CONST_STRPTR*/ ARRAY OF CHAR, string2:/*CONST_STRPTR*/ ARRAY OF CHAR, length:VALUE, type:ULONG ) IS NATIVE {ILocale->StrnCmp(} locale {,} string1 {,} string2 {,} length {,} type {)} ENDNATIVE !!VALUE
/*--- functions in V50 or higher ---*/
->NATIVE {Locale_DateToStr} PROC
PROC locale_DateToStr( datetime:PTR TO datetime ) IS NATIVE {ILocale->Locale_DateToStr(} datetime {)} ENDNATIVE !!VALUE
->NATIVE {Locale_StrToDate} PROC
PROC locale_StrToDate( datetime:PTR TO datetime ) IS NATIVE {ILocale->Locale_StrToDate(} datetime {)} ENDNATIVE !!VALUE
/*--- functions in V51 or higher ---*/
->NATIVE {IsBlank} PROC
PROC IsBlank( locale:PTR TO locale, character:ULONG ) IS NATIVE {ILocale->IsBlank(} locale {,} character {)} ENDNATIVE !!VALUE
->NATIVE {FormatString32} PROC
PROC FormatString32( locale:PTR TO locale, fmtTemplate:/*CONST_STRPTR*/ ARRAY OF CHAR, dataStream:APTR, putCharFunc:PTR TO hook ) IS NATIVE {ILocale->FormatString32(} locale {,} fmtTemplate {,} dataStream {,} putCharFunc {)} ENDNATIVE !!APTR
