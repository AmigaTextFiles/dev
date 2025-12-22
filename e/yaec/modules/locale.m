OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V38 or higher (Release 2.1) ---
MACRO CloseCatalog(catalog) IS (A0:=catalog) BUT (A6:=localebase) BUT ASM ' jsr -36(a6)'
MACRO CloseLocale(locale) IS (A0:=locale) BUT (A6:=localebase) BUT ASM ' jsr -42(a6)'
MACRO ConvToLower(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -48(a6)'
MACRO ConvToUpper(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -54(a6)'
MACRO FormatDate(locale,fmtTemplate,date,putCharFunc) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(localebase,locale,fmtTemplate,date,putCharFunc) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -60(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO FormatString(locale,fmtTemplate,dataStream,putCharFunc) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(localebase,locale,fmtTemplate,dataStream,putCharFunc) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -66(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO GetCatalogStr(catalog,stringNum,defaultString) IS Stores(localebase,catalog,stringNum,defaultString) BUT Loads(A6,A0,D0,A1) BUT ASM ' jsr -72(a6)'
MACRO GetLocaleStr(locale,stringNum) IS Stores(localebase,locale,stringNum) BUT Loads(A6,A0,D0) BUT ASM ' jsr -78(a6)'
MACRO IsAlNum(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -84(a6)'
MACRO IsAlpha(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -90(a6)'
MACRO IsCntrl(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -96(a6)'
MACRO IsDigit(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -102(a6)'
MACRO IsGraph(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -108(a6)'
MACRO IsLower(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -114(a6)'
MACRO IsPrint(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -120(a6)'
MACRO IsPunct(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -126(a6)'
MACRO IsSpace(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -132(a6)'
MACRO IsUpper(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -138(a6)'
MACRO IsXDigit(locale,character) IS Stores(localebase,locale,character) BUT Loads(A6,A0,D0) BUT ASM ' jsr -144(a6)'
MACRO OpenCatalogA(locale,name,tags) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(localebase,locale,name,tags) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -150(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO OpenLocale(name) IS (A0:=name) BUT (A6:=localebase) BUT ASM ' jsr -156(a6)'
MACRO ParseDate(locale,date,fmtTemplate,getCharFunc) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(localebase,locale,date,fmtTemplate,getCharFunc) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -162(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO StrConvert(locale,string,buffer,bufferSize,type) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(localebase,locale,string,buffer,bufferSize,type) BUT Loads(A6,A0,A1,A2,D0,D1) BUT ASM ' jsr -174(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO StrnCmp(locale,string1,string2,length,type) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(localebase,locale,string1,string2,length,type) BUT Loads(A6,A0,A1,A2,D0,D1) BUT ASM ' jsr -180(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
