#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#define BASE_EXT_DECL
#define BASE_NAME SysBase

static __inline struct Task *
FindTask (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct Task * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x126)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline void 
Forbid (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6)
  : "cc");
}
static __inline struct Library *
OpenLibrary (BASE_PAR_DECL UBYTE *libName,unsigned long version)
{
  BASE_EXT_DECL
  register struct Library * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = libName;
  register unsigned long d0 __asm("d0") = version;
  __asm __volatile ("jsr a6@(-0x228)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline void 
CloseLibrary (BASE_PAR_DECL struct Library *library)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Library *a1 __asm("a1") = library;
  __asm __volatile ("jsr a6@(-0x19e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "cc");
}

#ifdef V39
static __inline APTR 
AllocPooled (BASE_PAR_DECL APTR poolHeader,unsigned long memSize)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = poolHeader;
  register unsigned long d0 __asm("d0") = memSize;
  __asm __volatile ("jsr a6@(-0x2c4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline void 
FreePooled (BASE_PAR_DECL APTR poolHeader,APTR memory,unsigned long memSize)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = poolHeader;
  register APTR a1 __asm("a1") = memory;
  register unsigned long d0 __asm("d0") = memSize;
  __asm __volatile ("jsr a6@(-0x2ca)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "cc");
}
static __inline APTR 
CreatePool (BASE_PAR_DECL unsigned long requirements,unsigned long puddleSize,unsigned long threshSize)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = requirements;
  register unsigned long d1 __asm("d1") = puddleSize;
  register unsigned long d2 __asm("d2") = threshSize;
  __asm __volatile ("jsr a6@(-0x2b8)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline void 
DeletePool (BASE_PAR_DECL APTR poolHeader)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = poolHeader;
  __asm __volatile ("jsr a6@(-0x2be)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "cc");
}
#endif   /* V39 */

static __inline struct Message *
GetMsg (BASE_PAR_DECL struct MsgPort *port)
{
  BASE_EXT_DECL
  register struct Message * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  __asm __volatile ("jsr a6@(-0x174)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline struct Message *
WaitPort (BASE_PAR_DECL struct MsgPort *port)
{
  BASE_EXT_DECL
  register struct Message * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  __asm __volatile ("jsr a6@(-0x180)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline void 
ReplyMsg (BASE_PAR_DECL struct Message *message)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Message *a1 __asm("a1") = message;
  __asm __volatile ("jsr a6@(-0x17a)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "cc");
}

#undef BASE_NAME
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL0
#undef BASE_PAR_DECL

#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#define BASE_EXT_DECL
#define BASE_NAME IntuitionBase

static __inline LONG 
EasyRequestArgs (BASE_PAR_DECL struct Window *window,struct EasyStruct *easyStruct,ULONG *idcmpPtr,APTR args)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase* a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct EasyStruct *a1 __asm("a1") = easyStruct;
  register ULONG *a2 __asm("a2") = idcmpPtr;
  register APTR a3 __asm("a3") = args;
  __asm __volatile ("jsr a6@(-0x24c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","d0","d1", "cc","memory");
  return _res;
}

#undef BASE_NAME
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL0
#undef BASE_PAR_DECL

#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#define BASE_EXT_DECL
#define BASE_NAME AmigaGuideBase

static __inline APTR 
AddAmigaGuideHostA (BASE_PAR_DECL struct Hook *h,STRPTR name,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library* a6 __asm("a6") = BASE_NAME;
  register struct Hook *a0 __asm("a0") = h;
  register STRPTR d0 __asm("d0") = name;
  register struct TagItem *a1 __asm("a1") = attrs;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline LONG 
RemoveAmigaGuideHostA (BASE_PAR_DECL APTR hh,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library* a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = hh;
  register struct TagItem *a1 __asm("a1") = attrs;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline APTR 
OpenAmigaGuideA (BASE_PAR_DECL struct NewAmigaGuide *nag,struct TagItem *TagList)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library* a6 __asm("a6") = BASE_NAME;
  register struct NewAmigaGuide *a0 __asm("a0") = nag;
  register struct TagItem *a1 __asm("a1") = TagList;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline void 
CloseAmigaGuide (BASE_PAR_DECL APTR cl)
{
  BASE_EXT_DECL
  register struct Library* a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  __asm __volatile ("jsr a6@(-0x42)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "cc");
}

#undef BASE_NAME
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL0
#undef BASE_PAR_DECL

#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#define BASE_EXT_DECL
#define BASE_NAME UtilityBase

static __inline LONG 
Stricmp (BASE_PAR_DECL STRPTR string1,STRPTR string2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library* a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = string1;
  register STRPTR a1 __asm("a1") = string2;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline LONG 
Strnicmp (BASE_PAR_DECL STRPTR string1,STRPTR string2,long length)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library* a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = string1;
  register STRPTR a1 __asm("a1") = string2;
  register long d0 __asm("d0") = length;
  __asm __volatile ("jsr a6@(-0xa8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "cc");
  return _res;
}

#undef BASE_NAME
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL0
#undef BASE_PAR_DECL

#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#define BASE_EXT_DECL
#define BASE_NAME DOSBase

static __inline LONG 
Read (BASE_PAR_DECL BPTR file,APTR buffer,long length)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = file;
  register APTR d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = length;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","cc","memory");
  return _res;
}
static __inline BOOL 
ExamineFH (BASE_PAR_DECL BPTR fh,struct FileInfoBlock *fib)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register struct FileInfoBlock *d2 __asm("d2") = fib;
  __asm __volatile ("jsr a6@(-0x186)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc","memory");
  return _res;
}
static __inline void 
Delay (BASE_PAR_DECL long timeout)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = timeout;
  __asm __volatile ("jsr a6@(-0xc6)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
}
static __inline LONG 
DeleteFile (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline BOOL 
MatchPatternNoCase (BASE_PAR_DECL STRPTR pat,STRPTR str)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = pat;
  register STRPTR d2 __asm("d2") = str;
  __asm __volatile ("jsr a6@(-0x3cc)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline LONG 
ParsePatternNoCase (BASE_PAR_DECL STRPTR pat,STRPTR buf,long buflen)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = pat;
  register STRPTR d2 __asm("d2") = buf;
  register long d3 __asm("d3") = buflen;
  __asm __volatile ("jsr a6@(-0x3c6)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1", "cc","memory");
  return _res;
}
static __inline LONG 
NameFromLock (BASE_PAR_DECL BPTR lock,STRPTR buffer,long len)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  register STRPTR d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = len;
  __asm __volatile ("jsr a6@(-0x192)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1", "cc","memory");
  return _res;
}
static __inline LONG 
PutStr (BASE_PAR_DECL STRPTR str)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = str;
  __asm __volatile ("jsr a6@(-0x3b4)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline struct RDArgs *
ReadArgs (BASE_PAR_DECL STRPTR arg_template,LONG *array,struct RDArgs *args)
{
  BASE_EXT_DECL
  register struct RDArgs * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = arg_template;
  register LONG *d2 __asm("d2") = array;
  register struct RDArgs *d3 __asm("d3") = args;
  __asm __volatile ("jsr a6@(-0x31e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","cc","memory");
  return _res;
}
static __inline LONG 
IoErr (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline BPTR 
SelectInput (BASE_PAR_DECL BPTR fh)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  __asm __volatile ("jsr a6@(-0x126)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline LONG 
FGetC (BASE_PAR_DECL BPTR fh)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  __asm __volatile ("jsr a6@(-0x132)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline LONG 
UnGetC (BASE_PAR_DECL BPTR fh,long character)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register long d2 __asm("d2") = character;
  __asm __volatile ("jsr a6@(-0x13e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline LONG 
NameFromFH (BASE_PAR_DECL BPTR fh,STRPTR buffer,long len)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register STRPTR d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = len;
  __asm __volatile ("jsr a6@(-0x198)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","cc","memory");
  return _res;
}
static __inline LONG 
VPrintf (BASE_PAR_DECL STRPTR format,APTR argarray)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = format;
  register APTR d2 __asm("d2") = argarray;
  __asm __volatile ("jsr a6@(-0x3ba)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline LONG 
VFPrintf (BASE_PAR_DECL BPTR fh,STRPTR format,APTR argarray)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register STRPTR d2 __asm("d2") = format;
  register APTR d3 __asm("d3") = argarray;
  __asm __volatile ("jsr a6@(-0x162)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline BPTR 
Open (BASE_PAR_DECL STRPTR name,long accessMode)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = accessMode;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline LONG 
Close (BASE_PAR_DECL BPTR file)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = file;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline void 
FreeArgs (BASE_PAR_DECL struct RDArgs *args)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct RDArgs *d1 __asm("d1") = args;
  __asm __volatile ("jsr a6@(-0x35a)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
}
static __inline BPTR 
Lock (BASE_PAR_DECL STRPTR name,long type)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = type;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline void 
UnLock (BASE_PAR_DECL BPTR lock)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
}
static __inline BPTR 
CurrentDir (BASE_PAR_DECL BPTR lock)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline LONG 
ExAll (BASE_PAR_DECL BPTR lock,struct ExAllData *buffer,long size,long data,struct ExAllControl *control)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  register struct ExAllData *d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = size;
  register long d4 __asm("d4") = data;
  register struct ExAllControl *d5 __asm("d5") = control;
  __asm __volatile ("jsr a6@(-0x1b0)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","cc","memory");
  return _res;
}
static __inline void 
ExAllEnd (BASE_PAR_DECL BPTR lock,struct ExAllData *buffer,long size,long data,struct ExAllControl *control)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  register struct ExAllData *d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = size;
  register long d4 __asm("d4") = data;
  register struct ExAllControl *d5 __asm("d5") = control;
  __asm __volatile ("jsr a6@(-0x3de)"
  : /* no output */
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","cc","memory");
}
static __inline LONG 
Examine (BASE_PAR_DECL BPTR lock,struct FileInfoBlock *fileInfoBlock)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  register struct FileInfoBlock *d2 __asm("d2") = fileInfoBlock;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc","memory");
  return _res;
}
static __inline BOOL 
Fault (BASE_PAR_DECL long code,STRPTR header,STRPTR buffer,long len)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = code;
  register STRPTR d2 __asm("d2") = header;
  register STRPTR d3 __asm("d3") = buffer;
  register long d4 __asm("d4") = len;
  __asm __volatile ("jsr a6@(-0x1d4)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","cc","memory");
  return _res;
}
static __inline BOOL 
PrintFault (BASE_PAR_DECL long code,STRPTR header)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = code;
  register STRPTR d2 __asm("d2") = header;
  __asm __volatile ("jsr a6@(-0x1da)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline APTR 
AllocDosObject (BASE_PAR_DECL unsigned long type,struct TagItem *tags)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register unsigned long d1 __asm("d1") = type;
  register struct TagItem *d2 __asm("d2") = tags;
  __asm __volatile ("jsr a6@(-0xe4)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
  return _res;
}
static __inline void 
FreeDosObject (BASE_PAR_DECL unsigned long type,APTR ptr)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register unsigned long d1 __asm("d1") = type;
  register APTR d2 __asm("d2") = ptr;
  __asm __volatile ("jsr a6@(-0xea)"
  : /* no output */
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","cc");
}

#undef BASE_NAME
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL0
#undef BASE_PAR_DECL

#define BASE_PAR_DECL struct Library *IconBase,
#define BASE_PAR_DECL0 struct Library *IconBase
#define BASE_EXT_DECL
#define BASE_NAME IconBase

static __inline struct DiskObject *
GetDiskObject (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct DiskObject * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "cc");
  return _res;
}
static __inline void 
FreeDiskObject (BASE_PAR_DECL struct DiskObject *diskobj)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct DiskObject *a0 __asm("a0") = diskobj;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "cc");
}
static __inline UBYTE *
FindToolType (BASE_PAR_DECL UBYTE **toolTypeArray,UBYTE *typeName)
{
  BASE_EXT_DECL
  register UBYTE * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE **a0 __asm("a0") = toolTypeArray;
  register UBYTE *a1 __asm("a1") = typeName;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "cc");
  return _res;
}

#undef BASE_NAME
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL0
#undef BASE_PAR_DECL
