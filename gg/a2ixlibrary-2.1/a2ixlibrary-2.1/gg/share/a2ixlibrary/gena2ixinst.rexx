/*
 * gena2ixinst.rexx - instance generator with some extras
 * version 0.2 by megacz@usa.com
 *
 *
 * What is this good for?
 * 
 * It allows to add libraries to the instance without the need to
 * write macro manually. Aside form ixlibraries it can also insert 
 * native Amiga libraries.
 *
 *
 * How to use?
 *
 *  lib=<name[:mod]>
 *
 *    <name>        - name of ixlibrary without 'lib' prefix 
 *                    and '.ixlibrary' suffix
 *    [mod]         - assembly align modifier, can be 'W' == -resident
 *                    or 'L' == -resident32(-32), defaults to 'W'
 *                    (if your library was built with -resident32 then
 *                    all the dependencies must be 'L' aligned and -32
 *                    option must be passed to the 'a2ixlibrary'!)
 *
 *  amilib=<name:base[:ver][:struct]>
 *
 *    <name>        - name of library without '.library' suffix
 *    <base>        - name of the library base, like: 'DOSBase'
 *    [ver]         - minimum version of library
 *    [struct]      - name of structure, usually 'Library'
 *
 *  filein=<filename>
 *
 *    <filename>    - file that will be dumped before the gen. code
 *
 *  xmlnorel=<var>[,var][,...]
 *
 *    <var>         - global variable that should be initialized
 *                    locally due to relocation truncation(xmlnorel_:)
 *                    currently these vars can be compiled in:
 *                      xmlGenericErrorContext
 *                      xmlXPathNAN
 *                      xmlXPathNINF
 *                      xmlXPathPINF
 *                      xmlIsBaseCharGroup
 *                      xmlIsCharGroup
 *                      xmlIsCombiningGroup
 *                      xmlIsDigitGroup
 *                      xmlIsExtenderGroup
 *                      xmlIsIdeographicGroup
 *
 *  amissl=<errnoptr>
 *
 *    <errnoptr>    - pointer to error indication, usually '&errno', but
 *                    in ixlibrary this should be 'ixemul_errno'(please 
 *                    note, due to some "hooks" in 'AmiSSL', init. with
 *                    that standard pointer will break network error
 *                    reportability through 'errno', so you should
 *                    supply it with something like 'ssl_errno' or
 *                    define bases only in the library in an relocatable
 *                    way and init from under the process!)
 *
 *  SWITCHES
 *
 *    [xmlmapper/s] - adds xml2 mapper code for memory handling 
 *                    and such(a must have if one want to link against
 *                    shared 'xml2' or 'xml2mini')
 *
 *    [errno/s]     - attaches pseudo-global 'errno' to library that
 *                    will be routed to the process, but 'ixemul' funcs
 *                    wont be able to affect it inside the library
 *                    (if you want true global 'errno' you have to
 *                     compile your code with '-D"errno=(*ixemul_errno)"'
 *                     and include 'errno.h' or use '-malways-restore-a4'
 *                     but this option cannot be used in regular builds!)
 *
 *    [liberrno/s]  - this will assume that 'errno' is defined in some
 *                    other place and this is the only difference to
 *                    [errno/s]
 *
 *    [dummy/s]     - force output at all
 *
 *
 * And here is the example(prep. the data file as 'a2ixlibrary.data.in'):
 *
 *   /c/rx gg:share/a2ixlibrary/gena2ixinst.rexx >a2ixlibrary.data 
 *   filein=a2ixlibrary.data.in xmlmapper lib=xml2:L,iconv:L 
 *   amilib=dos:DOSBase:36L:DosLibrary 
 *   ; (everything above is single line)
 *   a2ixlibrary -noinst -32
*/

pre_:
_library='rexxsupport.library'
IF SHOW('L', _library)=0 THEN _addlib=ADDLIB(_library, 0, -30, 0)
SIGNAL ON Halt
SIGNAL ON Break_C
PARSE ARG _dosline

var_:
defmod    = "W"
defstruct = "Library"
defver    = "0L"
lf        = '0a'x

init_:
IF _dosline="" THEN DO
  SAY " *** t: gena2ixinst [lib=<name[:mod]>[,name][,...]]"
  SAY "                    [amilib=<name:base[:ver][:struct]>[,name:base][,...]]"
  SAY "                    [filein=<filename>] [xmlnorel=<var>[,var][,...]]"
  SAY "                    [amissl=<errnoptr>] [xmlmapper/s] [errno/s]"
  SAY "                    [liberrno/s] [dummy/s]"
  EXIT
END

parseargs_:
_libraries=""
_alibraries=""
_filein=""
_xmlnorel=""
_xmlmapper=0
_errno=0
_liberrno=0
_amissl=""
_dosline=" "TRANSLATE(_dosline, " ", "=")" "
_doslineu=UPPER(_dosline)
PARSE VAR _doslineu " LIB " _libraries " "
IF _libraries~="" THEN DO
  _libraries=SUBSTR(_dosline, POS(_libraries, UPPER(_dosline)), LENGTH(_libraries))
END
PARSE VAR _doslineu " AMILIB " _alibraries " "
IF _alibraries~="" THEN DO
  _alibraries=SUBSTR(_dosline, POS(_alibraries, UPPER(_dosline)), LENGTH(_alibraries))
END
PARSE VAR _doslineu " FILEIN " _filein " "
IF _filein~="" THEN DO
  _filein=SUBSTR(_dosline, POS(_filein, UPPER(_dosline)), LENGTH(_filein))
END
PARSE VAR _doslineu " XMLNOREL " _xmlnorel " "
IF _xmlnorel~="" THEN DO
  _xmlnorel=SUBSTR(_dosline, POS(_xmlnorel, UPPER(_dosline)), LENGTH(_xmlnorel))
END
PARSE VAR _doslineu " AMISSL " _amissl " "
IF _amissl~="" THEN DO
  _amissl=SUBSTR(_dosline, POS(_amissl, UPPER(_dosline)), LENGTH(_amissl))
END
IF FIND(_doslineu, " XMLMAPPER ") > 0 THEN _xmlmapper=1
IF FIND(_doslineu, " ERRNO ") > 0 THEN _errno=1
IF FIND(_doslineu, " LIBERRNO ") > 0 THEN _liberrno=1

main_:
_counter=0
_libraries=TRANSLATE(_libraries, " ", ",")
_libcount=WORDS(_libraries)
_currlib=""
_currmod=""
_alibraries=TRANSLATE(_alibraries, " ", ",")
_alibcount=WORDS(_alibraries)
_curralib=""
_currbase=""
_currver=""
_currstruct=""
_macroblock='
#define INSTANCE_LIBS \'||lf
IF _xmlmapper > 0 THEN DO
  CALL xmlmapper_
END
IF _xmlnorel ~= "" THEN DO
  CALL xmlnorel_(1)
END
IF _errno > 0 | _liberrno > 0 THEN DO
  IF _liberrno > 0 THEN DO
    _macroblock=_macroblock||'
extern int errno; \'||lf
  END
  ELSE DO
    _macroblock=_macroblock||'
int errno = 0; \'||lf
  END
END
IF _amissl ~="" THEN DO
  _macroblock=_macroblock||'
int asi_InitAmiSSL(int *); \'||lf'
void asi_CleanupAmiSSL(void); \'||lf
END
_macroblock=_macroblock||'
static int open_libs(void); \'||lf'
static void close_libs(void); \'||lf
IF _libcount > 0 THEN DO
  _macroblock=_macroblock||'
void _stext(); \'||lf'
void _etext(); \'||lf'
void _sdata(); \'||lf'
void __text_size(); \'||lf
END
IF _amissl ~="" THEN DO
  _macroblock=_macroblock||'
ULONG ___IASSL = 1; \'||lf'
struct Library *AmiSSLMasterBase = NULL; \'||lf'
struct Library *AmiSSLBase = NULL; \'||lf'
struct Library *SocketBase = NULL; \'||lf
  IF (LEFT(_amissl, 1) = "&") THEN DO
    _macroblock=_macroblock||'
extern int '||RIGHT(_amissl, LENGTH(_amissl) - 1)||'; \'||lf
  END
  ELSE DO
    _macroblock=_macroblock||'
extern int *'||_amissl||'; \'||lf
  END
END
DO _counter=1 TO _alibcount
  CALL currentalib_
  _macroblock=_macroblock||'
struct '||_currstruct||' *'||_currbase||' = NULL; \'||lf
END
DO _counter=1 TO _libcount
  CALL currentlib_
  _macroblock=_macroblock||'
struct Library *'||_currlib||'Base = NULL; \'||lf'
extern unsigned long _'||_currlib||'_shared_ptr_table[]; \'||lf'
void _shared_textfunctions_start_lib'||_currlib||'(); \'||lf'
void _shared_datafunctions_start_lib'||_currlib||'(); \'||lf'
void _shared_datadata_start_lib'||_currlib||'(); \'||lf'
asm(".text"); \'||lf'
asm("___'||_currlib||'RelocateInstance:	movel	a4@(_'||_currlib||'Base:'||_currmod||'),a0"); \'||lf'
asm("jmp	a0@(-36:w)"); \'||lf'
asm(".data"); \'||lf
END
IF _libcount > 0 THEN DO
  _macroblock=_macroblock||'
asm(".text"); \'||lf
END
_macroblock=_macroblock||'
static int open_libs(void) \'||lf'
{ \'||lf
IF _libcount > 0 THEN DO
  _macroblock=_macroblock||'
  long offset = _etext -_sdata + 4 + 4 * *((long *)__datadata_relocs); \'||lf'
  long A4; \'||lf'
  asm volatile ("movel	a4,%0" : "=g" (A4)); \'||lf'
  A4 -= 0x7ffe; \'||lf
END
IF _xmlnorel ~= "" THEN DO
  CALL xmlnorel_(0)
END
IF _errno > 0 | _liberrno > 0 THEN DO
  _macroblock=_macroblock||'
  ixemul_errno = &errno; \'||lf
END
IF _amissl ~="" THEN DO
  _macroblock=_macroblock||'
  if ((asi_InitAmiSSL('||_amissl||'))) \'||lf'
  { \'||lf
END
DO _counter=1 TO _alibcount
  CALL currentalib_
  _macroblock=_macroblock||'
  if (('||_currbase||' = (struct '||_currstruct||' *)OpenLibrary("'||_curralib||'.library", '||_currver||')) != NULL) \'||lf'
  { \'||lf
END
IF _libcount > 0 THEN DO
  DO _counter=1 TO _libcount
    CALL currentlib_
    _macroblock=_macroblock||'
      if (('||_currlib||'Base = OpenLibrary("lib'||_currlib||'.ixlibrary", 0L)) != NULL) \'||lf'
      { \'||lf'
        if (__'||_currlib||'RelocateInstance(_stext, _shared_textfunctions_start_lib'||_currlib||' + offset, NULL, \'||lf'
                             (void *)A4, _shared_datafunctions_start_lib'||_currlib||' + offset, \'||lf'
                             _shared_datadata_start_lib'||_currlib||' + offset, _'||_currlib||'_shared_ptr_table)) \'||lf'
        { \'||lf
    IF _counter = _libcount THEN DO
      _macroblock=_macroblock||'
          CacheClearE(_stext, (long)__text_size, CACRF_ClearI | CACRF_ClearD); \'||lf'
          return 1; \'||lf
    END
  END
  DO _counter=1 TO _libcount
    _macroblock=_macroblock||'
        } \'||lf'
      } \'||lf
  END
END
ELSE DO
  _macroblock=_macroblock||'
    return 1; \'||lf
END
DO _counter=1 TO _alibcount
  _macroblock=_macroblock||'
  } \'||lf
END
IF _amissl ~="" THEN DO
  _macroblock=_macroblock||'
  } \'||lf
END
_macroblock=_macroblock||'
  close_libs(); \'||lf'
  return 0; \'||lf'
} \'||lf'
static void close_libs(void) \'||lf'
{ \'||lf
DO _counter=1 TO _alibcount
  CALL currentalib_
  _macroblock=_macroblock||'
  if ('||_currbase||') \'||lf'
  { \'||lf'
    CloseLibrary((struct Library *)'||_currbase||'); \'||lf'
    '||_currbase||' = NULL; \'||lf'
  } \'||lf
END
DO _counter=1 TO _libcount
  CALL currentlib_
  _macroblock=_macroblock||'
  if ('||_currlib||'Base) \'||lf'
  { \'||lf'
    CloseLibrary('||_currlib||'Base); \'||lf'
    '||_currlib||'Base = NULL; \'||lf'
  } \'||lf
END
IF _amissl ~="" THEN DO
  _macroblock=_macroblock||'
  asi_CleanupAmiSSL(); \'||lf
END
_macroblock=_macroblock||'
} '||lf
IF _libcount > 0 THEN DO
  _macroblock=_macroblock||'
#define MISC_SETVARS \'||lf'
asm(".text"); \'||lf
  DO _counter=1 TO _libcount
    CALL currentlib_
    _macroblock=_macroblock||'
asm("___'||_currlib||'SetVarsInstance:	movel	a4@(_'||_currlib||'Base:'||_currmod||'),a0"); \'||lf'
asm("jmp	a0@(-42:w)"); '
    IF _counter ~= _libcount THEN DO
      _macroblock=_macroblock||'
\'||lf
    END
    ELSE DO
      _macroblock=_macroblock||'
'||lf
    END
  END
  _macroblock=_macroblock||'
#define CALL_SETVARS \'||lf
  DO _counter=1 TO _libcount
    CALL currentlib_
    _macroblock=_macroblock||'
__'||_currlib||'SetVarsInstance(argc, ixbase, errnoptr, ctype, sf); '
    IF _counter ~= _libcount THEN DO
      _macroblock=_macroblock||'
\'||lf
    END
    ELSE DO
      _macroblock=_macroblock||'
'||lf
    END
  END
END
IF _filein~="" THEN DO
  IF OPEN(__filein, _filein, 'R') > 0 THEN DO
    DO UNTIL EOF(__filein)
      _write=WRITECH(STDOUT, READCH(__filein, 2048))
    END
    _close=CLOSE(__filein)
  END
  ELSE DO
    SAY " *** error, cannot open file ='"_filein"'!"
    EXIT 5
  END
END
SAY _macroblock
EXIT

Halt:
Break_C:
EXIT 5

currentlib_:
_currlib=WORD(_libraries,_counter)
PARSE VAR _currlib _currlib ":" _currmod
IF _currlib="" THEN DO
  SAY " *** error in 'lib=...', <name> not defined!"
  EXIT 5
END
_currmod=UPPER(_currmod)
IF _currmod = "" | (_currmod ~= "W" & _currmod ~= "L") THEN _currmod=defmod
RETURN

currentalib_:
_curralib=WORD(_alibraries,_counter)
PARSE VAR _curralib _curralib ":" _currbase ":" _currver ":" _currstruct
IF _curralib="" THEN DO
  SAY " *** error in 'amilib=...', <name> not defined!"
  EXIT 5
END
IF _currbase = "" THEN DO
  SAY " *** error in 'amilib=...', <base> not defined!"
  EXIT 5
END
IF _currver = "" THEN _currver=defver
IF _currstruct = "" THEN _currstruct=defstruct
RETURN

xmlmapper_:
_macroblock=_macroblock||'
typedef enum {  \'||lf'
    XML_ERR_NONE = 0, \'||lf'
    XML_ERR_WARNING = 1, \'||lf'
    XML_ERR_ERROR = 2, \'||lf'
    XML_ERR_FATAL = 3 \'||lf'
} xmlErrorLevel; \'||lf'
struct _xmlError { \'||lf'
    int		domain; \'||lf'
    int		code; \'||lf'
    char       *message; \'||lf'
    xmlErrorLevel level; \'||lf'
    char       *file; \'||lf'
    int		line; \'||lf'
    char       *str1; \'||lf'
    char       *str2; \'||lf'
    char       *str3; \'||lf'
    int		int1; \'||lf'
    int		int2; \'||lf'
    void       *ctxt; \'||lf'
    void       *node; \'||lf'
}; \'||lf'
typedef unsigned char xmlChar; \'||lf'
typedef struct _xmlError xmlError; \'||lf'
typedef xmlError *xmlErrorPtr; \'||lf'
typedef unsigned long size_t; \'||lf'
typedef void (*xmlFreeFunc)(void *mem); \'||lf'
typedef void *(*xmlMallocFunc)(size_t size); \'||lf'
typedef void *(*xmlReallocFunc)(void *mem, size_t size); \'||lf'
typedef char *(*xmlStrdupFunc)(const char *str); \'||lf'
typedef void (*xmlGenericErrorFunc) (void *ctx, const char *msg, ...); \'||lf'
typedef void (*xmlStructuredErrorFunc) (void *userData, xmlErrorPtr error); \'||lf'
void a2ix_xmlFree(void *); \'||lf'
void *a2ix_xmlMalloc(size_t); \'||lf'
void *a2ix_xmlMallocAtomic(size_t); \'||lf'
void *a2ix_xmlRealloc(void *, size_t); \'||lf'
char *a2ix_xmlMemStrdup(const char *); \'||lf'
void xmlGenericErrorDefaultFunc(void *, const char *, ...); \'||lf'
const xmlChar *a2ix_xmlStrstr(const xmlChar *, const xmlChar *); \'||lf'
int a2ix_xmlUCSIsCatMe(int); \'||lf'
xmlFreeFunc xmlFree = (xmlFreeFunc)a2ix_xmlFree; \'||lf'
xmlMallocFunc xmlMalloc = (xmlMallocFunc)a2ix_xmlMalloc; \'||lf'
xmlMallocFunc xmlMallocAtomic = (xmlMallocFunc)a2ix_xmlMalloc; \'||lf'
xmlReallocFunc xmlRealloc = (xmlReallocFunc)a2ix_xmlRealloc; \'||lf'
xmlStrdupFunc xmlMemStrdup = (xmlStrdupFunc)a2ix_xmlMemStrdup; \'||lf'
xmlGenericErrorFunc xmlGenericError = xmlGenericErrorDefaultFunc; \'||lf'
xmlStructuredErrorFunc xmlStructuredError = (void *)0; \'||lf'
const xmlChar *xmlStrstr(const xmlChar *str, const xmlChar *val) \'||lf'
{ \'||lf'
  return a2ix_xmlStrstr(str, val); \'||lf'
} \'||lf'
int xmlUCSIsCatMe(int code) \'||lf'
{ \'||lf'
  return a2ix_xmlUCSIsCatMe(code); \'||lf'
} \'||lf
RETURN

xmlnorel_:
/* - these are undefined yet -------
__xmlRegisterCallbacks
docbDefaultSAXHandler
emptyExp
forbiddenExp
htmlDefaultSAXHandler
oldXMLWDcompatibility
xmlBufferAllocScheme
xmlDefaultBufferSize
xmlDefaultSAXHandler
xmlDefaultSAXLocator
xmlDeregisterNodeDefaultValue
xmlDoValidityCheckingDefaultValue
xmlGetWarningsDefaultValue
xmlIndentTreeOutput
xmlKeepBlanksDefaultValue
xmlLastError
xmlLineNumbersDefaultValue
xmlLoadExtDtdDefaultValue
xmlOutputBufferCreateFilenameValue
xmlParserDebugEntities
xmlParserInputBufferCreateFilenameValue
xmlParserMaxDepth
xmlParserVersion
xmlPedanticParserDefaultValue
xmlRegisterNodeDefaultValue
xmlSaveNoEmptyTags
xmlSubstituteEntitiesDefaultValue
xmlTreeIndentString
 ----------------------------------- */
_declcounter=1
_xmlnorelcpy=TRANSLATE(_xmlnorel, " ", ",")
_xmlnorelnum=WORDS(_xmlnorelcpy)
IF ARG(1) > 0 THEN DO
  _macroblock=_macroblock||'
typedef struct _xmlChSRange xmlChSRange; \'||lf'
typedef xmlChSRange *xmlChSRangePtr; \'||lf'
struct _xmlChSRange { \'||lf'
  unsigned short	low; \'||lf'
  unsigned short	high; \'||lf'
}; \'||lf'
typedef struct _xmlChLRange xmlChLRange; \'||lf'
typedef xmlChLRange *xmlChLRangePtr; \'||lf'
struct _xmlChLRange { \'||lf'
  unsigned int	low; \'||lf'
  unsigned int	high; \'||lf'
}; \'||lf'
typedef struct _xmlChRangeGroup xmlChRangeGroup; \'||lf'
typedef xmlChRangeGroup *xmlChRangeGroupPtr; \'||lf'
struct _xmlChRangeGroup { \'||lf'
  int			nbShortRange; \'||lf'
  int			nbLongRange; \'||lf'
  const xmlChSRange	*shortRange; \'||lf'
  const xmlChLRange	*longRange; \'||lf'
}; \'||lf
_xmlnorel_decl.1 = '
void * xmlGenericErrorContext = NULL; \'||lf
_xmlnorel_decl.2 = '
const long long ___nannan = 0x7ff8000000000000LL; \'||lf'
double xmlXPathNAN = 0; \'||lf
_xmlnorel_decl.3 = '
const long long ___ninfninf = 0xfff0000000000000LL; \'||lf'
double xmlXPathNINF = -1; \'||lf
_xmlnorel_decl.4 = '
const long long ___pinfpinf = 0x7ff0000000000000LL; \'||lf'
double xmlXPathPINF = 1; \'||lf
_xmlnorel_decl.5 = '
static const xmlChSRange xmlIsBaseChar_srng[] = { {0x100, 0x131}, \'||lf'
    {0x134, 0x13e}, {0x141, 0x148}, {0x14a, 0x17e}, {0x180, 0x1c3}, \'||lf'
    {0x1cd, 0x1f0}, {0x1f4, 0x1f5}, {0x1fa, 0x217}, {0x250, 0x2a8}, \'||lf'
    {0x2bb, 0x2c1}, {0x386, 0x386}, {0x388, 0x38a}, {0x38c, 0x38c}, \'||lf'
    {0x38e, 0x3a1}, {0x3a3, 0x3ce}, {0x3d0, 0x3d6}, {0x3da, 0x3da}, \'||lf'
    {0x3dc, 0x3dc}, {0x3de, 0x3de}, {0x3e0, 0x3e0}, {0x3e2, 0x3f3}, \'||lf'
    {0x401, 0x40c}, {0x40e, 0x44f}, {0x451, 0x45c}, {0x45e, 0x481}, \'||lf'
    {0x490, 0x4c4}, {0x4c7, 0x4c8}, {0x4cb, 0x4cc}, {0x4d0, 0x4eb}, \'||lf'
    {0x4ee, 0x4f5}, {0x4f8, 0x4f9}, {0x531, 0x556}, {0x559, 0x559}, \'||lf'
    {0x561, 0x586}, {0x5d0, 0x5ea}, {0x5f0, 0x5f2}, {0x621, 0x63a}, \'||lf'
    {0x641, 0x64a}, {0x671, 0x6b7}, {0x6ba, 0x6be}, {0x6c0, 0x6ce}, \'||lf'
    {0x6d0, 0x6d3}, {0x6d5, 0x6d5}, {0x6e5, 0x6e6}, {0x905, 0x939}, \'||lf'
    {0x93d, 0x93d}, {0x958, 0x961}, {0x985, 0x98c}, {0x98f, 0x990}, \'||lf'
    {0x993, 0x9a8}, {0x9aa, 0x9b0}, {0x9b2, 0x9b2}, {0x9b6, 0x9b9}, \'||lf'
    {0x9dc, 0x9dd}, {0x9df, 0x9e1}, {0x9f0, 0x9f1}, {0xa05, 0xa0a}, \'||lf'
    {0xa0f, 0xa10}, {0xa13, 0xa28}, {0xa2a, 0xa30}, {0xa32, 0xa33}, \'||lf'
    {0xa35, 0xa36}, {0xa38, 0xa39}, {0xa59, 0xa5c}, {0xa5e, 0xa5e}, \'||lf'
    {0xa72, 0xa74}, {0xa85, 0xa8b}, {0xa8d, 0xa8d}, {0xa8f, 0xa91}, \'||lf'
    {0xa93, 0xaa8}, {0xaaa, 0xab0}, {0xab2, 0xab3}, {0xab5, 0xab9}, \'||lf'
    {0xabd, 0xabd}, {0xae0, 0xae0}, {0xb05, 0xb0c}, {0xb0f, 0xb10}, \'||lf'
    {0xb13, 0xb28}, {0xb2a, 0xb30}, {0xb32, 0xb33}, {0xb36, 0xb39}, \'||lf'
    {0xb3d, 0xb3d}, {0xb5c, 0xb5d}, {0xb5f, 0xb61}, {0xb85, 0xb8a}, \'||lf'
    {0xb8e, 0xb90}, {0xb92, 0xb95}, {0xb99, 0xb9a}, {0xb9c, 0xb9c}, \'||lf'
    {0xb9e, 0xb9f}, {0xba3, 0xba4}, {0xba8, 0xbaa}, {0xbae, 0xbb5}, \'||lf'
    {0xbb7, 0xbb9}, {0xc05, 0xc0c}, {0xc0e, 0xc10}, {0xc12, 0xc28}, \'||lf'
    {0xc2a, 0xc33}, {0xc35, 0xc39}, {0xc60, 0xc61}, {0xc85, 0xc8c}, \'||lf'
    {0xc8e, 0xc90}, {0xc92, 0xca8}, {0xcaa, 0xcb3}, {0xcb5, 0xcb9}, \'||lf'
    {0xcde, 0xcde}, {0xce0, 0xce1}, {0xd05, 0xd0c}, {0xd0e, 0xd10}, \'||lf'
    {0xd12, 0xd28}, {0xd2a, 0xd39}, {0xd60, 0xd61}, {0xe01, 0xe2e}, \'||lf'
    {0xe30, 0xe30}, {0xe32, 0xe33}, {0xe40, 0xe45}, {0xe81, 0xe82}, \'||lf'
    {0xe84, 0xe84}, {0xe87, 0xe88}, {0xe8a, 0xe8a}, {0xe8d, 0xe8d}, \'||lf'
    {0xe94, 0xe97}, {0xe99, 0xe9f}, {0xea1, 0xea3}, {0xea5, 0xea5}, \'||lf'
    {0xea7, 0xea7}, {0xeaa, 0xeab}, {0xead, 0xeae}, {0xeb0, 0xeb0}, \'||lf'
    {0xeb2, 0xeb3}, {0xebd, 0xebd}, {0xec0, 0xec4}, {0xf40, 0xf47}, \'||lf'
    {0xf49, 0xf69}, {0x10a0, 0x10c5}, {0x10d0, 0x10f6}, {0x1100, 0x1100}, \'||lf'
    {0x1102, 0x1103}, {0x1105, 0x1107}, {0x1109, 0x1109}, {0x110b, 0x110c}, \'||lf'
    {0x110e, 0x1112}, {0x113c, 0x113c}, {0x113e, 0x113e}, {0x1140, 0x1140}, \'||lf'
    {0x114c, 0x114c}, {0x114e, 0x114e}, {0x1150, 0x1150}, {0x1154, 0x1155}, \'||lf'
    {0x1159, 0x1159}, {0x115f, 0x1161}, {0x1163, 0x1163}, {0x1165, 0x1165}, \'||lf'
    {0x1167, 0x1167}, {0x1169, 0x1169}, {0x116d, 0x116e}, {0x1172, 0x1173}, \'||lf'
    {0x1175, 0x1175}, {0x119e, 0x119e}, {0x11a8, 0x11a8}, {0x11ab, 0x11ab}, \'||lf'
    {0x11ae, 0x11af}, {0x11b7, 0x11b8}, {0x11ba, 0x11ba}, {0x11bc, 0x11c2}, \'||lf'
    {0x11eb, 0x11eb}, {0x11f0, 0x11f0}, {0x11f9, 0x11f9}, {0x1e00, 0x1e9b}, \'||lf'
    {0x1ea0, 0x1ef9}, {0x1f00, 0x1f15}, {0x1f18, 0x1f1d}, {0x1f20, 0x1f45}, \'||lf'
    {0x1f48, 0x1f4d}, {0x1f50, 0x1f57}, {0x1f59, 0x1f59}, {0x1f5b, 0x1f5b}, \'||lf'
    {0x1f5d, 0x1f5d}, {0x1f5f, 0x1f7d}, {0x1f80, 0x1fb4}, {0x1fb6, 0x1fbc}, \'||lf'
    {0x1fbe, 0x1fbe}, {0x1fc2, 0x1fc4}, {0x1fc6, 0x1fcc}, {0x1fd0, 0x1fd3}, \'||lf'
    {0x1fd6, 0x1fdb}, {0x1fe0, 0x1fec}, {0x1ff2, 0x1ff4}, {0x1ff6, 0x1ffc}, \'||lf'
    {0x2126, 0x2126}, {0x212a, 0x212b}, {0x212e, 0x212e}, {0x2180, 0x2182}, \'||lf'
    {0x3041, 0x3094}, {0x30a1, 0x30fa}, {0x3105, 0x312c}, {0xac00, 0xd7a3}};\'||lf'
const xmlChRangeGroup xmlIsBaseCharGroup = \'||lf'
	{197, 0, xmlIsBaseChar_srng, (xmlChLRangePtr)0}; \'||lf
_xmlnorel_decl.6 = '
static const xmlChSRange xmlIsChar_srng[] = { {0x100, 0xd7ff}, \'||lf'
    {0xe000, 0xfffd}}; \'||lf'
static const xmlChLRange xmlIsChar_lrng[] = { {0x10000, 0x10ffff}}; \'||lf'
const xmlChRangeGroup xmlIsCharGroup = \'||lf'
	{2, 1, xmlIsChar_srng, xmlIsChar_lrng}; \'||lf
_xmlnorel_decl.7 = '
static const xmlChSRange xmlIsCombining_srng[] = { {0x300, 0x345}, \'||lf'
    {0x360, 0x361}, {0x483, 0x486}, {0x591, 0x5a1}, {0x5a3, 0x5b9}, \'||lf'
    {0x5bb, 0x5bd}, {0x5bf, 0x5bf}, {0x5c1, 0x5c2}, {0x5c4, 0x5c4}, \'||lf'
    {0x64b, 0x652}, {0x670, 0x670}, {0x6d6, 0x6dc}, {0x6dd, 0x6df}, \'||lf'
    {0x6e0, 0x6e4}, {0x6e7, 0x6e8}, {0x6ea, 0x6ed}, {0x901, 0x903}, \'||lf'
    {0x93c, 0x93c}, {0x93e, 0x94c}, {0x94d, 0x94d}, {0x951, 0x954}, \'||lf'
    {0x962, 0x963}, {0x981, 0x983}, {0x9bc, 0x9bc}, {0x9be, 0x9be}, \'||lf'
    {0x9bf, 0x9bf}, {0x9c0, 0x9c4}, {0x9c7, 0x9c8}, {0x9cb, 0x9cd}, \'||lf'
    {0x9d7, 0x9d7}, {0x9e2, 0x9e3}, {0xa02, 0xa02}, {0xa3c, 0xa3c}, \'||lf'
    {0xa3e, 0xa3e}, {0xa3f, 0xa3f}, {0xa40, 0xa42}, {0xa47, 0xa48}, \'||lf'
    {0xa4b, 0xa4d}, {0xa70, 0xa71}, {0xa81, 0xa83}, {0xabc, 0xabc}, \'||lf'
    {0xabe, 0xac5}, {0xac7, 0xac9}, {0xacb, 0xacd}, {0xb01, 0xb03}, \'||lf'
    {0xb3c, 0xb3c}, {0xb3e, 0xb43}, {0xb47, 0xb48}, {0xb4b, 0xb4d}, \'||lf'
    {0xb56, 0xb57}, {0xb82, 0xb83}, {0xbbe, 0xbc2}, {0xbc6, 0xbc8}, \'||lf'
    {0xbca, 0xbcd}, {0xbd7, 0xbd7}, {0xc01, 0xc03}, {0xc3e, 0xc44}, \'||lf'
    {0xc46, 0xc48}, {0xc4a, 0xc4d}, {0xc55, 0xc56}, {0xc82, 0xc83}, \'||lf'
    {0xcbe, 0xcc4}, {0xcc6, 0xcc8}, {0xcca, 0xccd}, {0xcd5, 0xcd6}, \'||lf'
    {0xd02, 0xd03}, {0xd3e, 0xd43}, {0xd46, 0xd48}, {0xd4a, 0xd4d}, \'||lf'
    {0xd57, 0xd57}, {0xe31, 0xe31}, {0xe34, 0xe3a}, {0xe47, 0xe4e}, \'||lf'
    {0xeb1, 0xeb1}, {0xeb4, 0xeb9}, {0xebb, 0xebc}, {0xec8, 0xecd}, \'||lf'
    {0xf18, 0xf19}, {0xf35, 0xf35}, {0xf37, 0xf37}, {0xf39, 0xf39}, \'||lf'
    {0xf3e, 0xf3e}, {0xf3f, 0xf3f}, {0xf71, 0xf84}, {0xf86, 0xf8b}, \'||lf'
    {0xf90, 0xf95}, {0xf97, 0xf97}, {0xf99, 0xfad}, {0xfb1, 0xfb7}, \'||lf'
    {0xfb9, 0xfb9}, {0x20d0, 0x20dc}, {0x20e1, 0x20e1}, {0x302a, 0x302f}, \'||lf'
    {0x3099, 0x3099}, {0x309a, 0x309a}}; \'||lf'
const xmlChRangeGroup xmlIsCombiningGroup = \'||lf'
	{95, 0, xmlIsCombining_srng, (xmlChLRangePtr)0}; \'||lf
_xmlnorel_decl.8 = '
static const xmlChSRange xmlIsDigit_srng[] = { {0x660, 0x669}, \'||lf'
    {0x6f0, 0x6f9}, {0x966, 0x96f}, {0x9e6, 0x9ef}, {0xa66, 0xa6f}, \'||lf'
    {0xae6, 0xaef}, {0xb66, 0xb6f}, {0xbe7, 0xbef}, {0xc66, 0xc6f}, \'||lf'
    {0xce6, 0xcef}, {0xd66, 0xd6f}, {0xe50, 0xe59}, {0xed0, 0xed9}, \'||lf'
    {0xf20, 0xf29}}; \'||lf'
const xmlChRangeGroup xmlIsDigitGroup = \'||lf'
	{14, 0, xmlIsDigit_srng, (xmlChLRangePtr)0}; \'||lf
_xmlnorel_decl.9 = '
static const xmlChSRange xmlIsExtender_srng[] = { {0x2d0, 0x2d0}, \'||lf'
    {0x2d1, 0x2d1}, {0x387, 0x387}, {0x640, 0x640}, {0xe46, 0xe46}, \'||lf'
    {0xec6, 0xec6}, {0x3005, 0x3005}, {0x3031, 0x3035}, {0x309d, 0x309e}, \'||lf'
    {0x30fc, 0x30fe}}; \'||lf'
const xmlChRangeGroup xmlIsExtenderGroup = \'||lf'
	{10, 0, xmlIsExtender_srng, (xmlChLRangePtr)0}; \'||lf
_xmlnorel_decl.10 = '
static const xmlChSRange xmlIsIdeographic_srng[] = { {0x3007, 0x3007}, \'||lf'
    {0x3021, 0x3029}, {0x4e00, 0x9fa5}}; \'||lf'
const xmlChRangeGroup xmlIsIdeographicGroup = \'||lf'
	{3, 0, xmlIsIdeographic_srng, (xmlChLRangePtr)0}; \'||lf
DO WHILE(_xmlnorel_decl._declcounter ~= "_XMLNOREL_DECL."_declcounter)
  DO xmlnorelcnt=1 TO _xmlnorelnum
    IF (FIND(_xmlnorel_decl._declcounter, WORD(_xmlnorelcpy, xmlnorelcnt))>0) THEN DO
      _macroblock=_macroblock||_xmlnorel_decl._declcounter
    END
  END
  _declcounter=_declcounter + 1
END
END
ELSE DO
  _xmlnorel_init.1 = ''
  _xmlnorel_init.2 = '
  xmlXPathNAN = (*(double*)&___nannan); \'||lf
  _xmlnorel_init.3 = '
  xmlXPathNINF = (*(double*)&___ninfninf); \'||lf
  _xmlnorel_init.4 = '
  xmlXPathPINF = (*(double*)&___pinfpinf); \'||lf
DO WHILE(_xmlnorel_init._declcounter ~= "_XMLNOREL_INIT."_declcounter)
  DO xmlnorelcnt=1 TO _xmlnorelnum
    IF (FIND(_xmlnorel_init._declcounter, WORD(_xmlnorelcpy, xmlnorelcnt))>0) THEN DO
      _macroblock=_macroblock||_xmlnorel_init._declcounter
    END
  END
  _declcounter=_declcounter + 1
END
END
RETURN
