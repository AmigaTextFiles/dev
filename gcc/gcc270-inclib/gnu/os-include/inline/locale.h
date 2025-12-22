#ifndef _INLINE_LOCALE_H
#define _INLINE_LOCALE_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct LocaleBase * LocaleBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME LocaleBase
#endif

BASE_EXT_DECL0

extern __inline void 
CloseCatalog (BASE_PAR_DECL struct Catalog *catalog)
{
  BASE_EXT_DECL
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Catalog *a0 __asm("a0") = catalog;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CloseLocale (BASE_PAR_DECL struct Locale *locale)
{
  BASE_EXT_DECL
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  __asm __volatile ("jsr a6@(-0x2a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
ConvToLower (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
ConvToUpper (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
FormatDate (BASE_PAR_DECL struct Locale *locale,STRPTR fmtTemplate,struct DateStamp *date,struct Hook *putCharFunc)
{
  BASE_EXT_DECL
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register STRPTR a1 __asm("a1") = fmtTemplate;
  register struct DateStamp *a2 __asm("a2") = date;
  register struct Hook *a3 __asm("a3") = putCharFunc;
  __asm __volatile ("jsr a6@(-0x3c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
}
extern __inline APTR 
FormatString (BASE_PAR_DECL struct Locale *locale,STRPTR fmtTemplate,APTR dataStream,struct Hook *putCharFunc)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register STRPTR a1 __asm("a1") = fmtTemplate;
  register APTR a2 __asm("a2") = dataStream;
  register struct Hook *a3 __asm("a3") = putCharFunc;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
extern __inline STRPTR 
GetCatalogStr (BASE_PAR_DECL struct Catalog *catalog,long stringNum,STRPTR defaultString)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Catalog *a0 __asm("a0") = catalog;
  register long d0 __asm("d0") = stringNum;
  register STRPTR a1 __asm("a1") = defaultString;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline STRPTR 
GetLocaleStr (BASE_PAR_DECL struct Locale *locale,unsigned long stringNum)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = stringNum;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsAlNum (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsAlpha (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsCntrl (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsDigit (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsGraph (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsLower (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsPrint (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsPunct (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsSpace (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsUpper (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
IsXDigit (BASE_PAR_DECL struct Locale *locale,unsigned long character)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Catalog *
OpenCatalogA (BASE_PAR_DECL struct Locale *locale,STRPTR name,struct TagItem *tags)
{
  BASE_EXT_DECL
  register struct Catalog * _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register STRPTR a1 __asm("a1") = name;
  register struct TagItem *a2 __asm("a2") = tags;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define OpenCatalog(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; OpenCatalogA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct Locale *
OpenLocale (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register struct Locale * _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x9c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
ParseDate (BASE_PAR_DECL struct Locale *locale,struct DateStamp *date,STRPTR fmtTemplate,struct Hook *getCharFunc)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register struct DateStamp *a1 __asm("a1") = date;
  register STRPTR a2 __asm("a2") = fmtTemplate;
  register struct Hook *a3 __asm("a3") = getCharFunc;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
StrConvert (BASE_PAR_DECL struct Locale *locale,STRPTR string,APTR buffer,unsigned long bufferSize,unsigned long type)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register STRPTR a1 __asm("a1") = string;
  register APTR a2 __asm("a2") = buffer;
  register unsigned long d0 __asm("d0") = bufferSize;
  register unsigned long d1 __asm("d1") = type;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
StrnCmp (BASE_PAR_DECL struct Locale *locale,STRPTR string1,STRPTR string2,long length,unsigned long type)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LocaleBase *a6 __asm("a6") = BASE_NAME;
  register struct Locale *a0 __asm("a0") = locale;
  register STRPTR a1 __asm("a1") = string1;
  register STRPTR a2 __asm("a2") = string2;
  register long d0 __asm("d0") = length;
  register unsigned long d1 __asm("d1") = type;
  __asm __volatile ("jsr a6@(-0xb4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_LOCALE_H */
