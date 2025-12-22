#ifndef _INLINE_DOS_H
#define _INLINE_DOS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct DosLibrary * DOSBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME DOSBase
#endif

static __inline void 
AbortPkt (BASE_PAR_DECL struct MsgPort *port,struct DosPacket *pkt)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *d1 __asm("d1") = port;
  register struct DosPacket *d2 __asm("d2") = pkt;
  __asm __volatile ("jsr a6@(-0x108)"
  : /* no output */
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
}
static __inline LONG 
AddBuffers (BASE_PAR_DECL STRPTR name,long number)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = number;
  __asm __volatile ("jsr a6@(-0x2dc)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
AddDosEntry (BASE_PAR_DECL struct DosList *dlist)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosList *d1 __asm("d1") = dlist;
  __asm __volatile ("jsr a6@(-0x2a6)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
AddPart (BASE_PAR_DECL STRPTR dirname,STRPTR filename,unsigned long size)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = dirname;
  register STRPTR d2 __asm("d2") = filename;
  register unsigned long d3 __asm("d3") = size;
  __asm __volatile ("jsr a6@(-0x372)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
AddSegment (BASE_PAR_DECL STRPTR name,BPTR seg,long system)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register BPTR d2 __asm("d2") = seg;
  register long d3 __asm("d3") = system;
  __asm __volatile ("jsr a6@(-0x306)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
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
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BOOL 
AssignAdd (BASE_PAR_DECL STRPTR name,BPTR lock)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register BPTR d2 __asm("d2") = lock;
  __asm __volatile ("jsr a6@(-0x276)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BOOL 
AssignLate (BASE_PAR_DECL STRPTR name,STRPTR path)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register STRPTR d2 __asm("d2") = path;
  __asm __volatile ("jsr a6@(-0x26a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
AssignLock (BASE_PAR_DECL STRPTR name,BPTR lock)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register BPTR d2 __asm("d2") = lock;
  __asm __volatile ("jsr a6@(-0x264)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BOOL 
AssignPath (BASE_PAR_DECL STRPTR name,STRPTR path)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register STRPTR d2 __asm("d2") = path;
  __asm __volatile ("jsr a6@(-0x270)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct DosList *
AttemptLockDosList (BASE_PAR_DECL unsigned long flags)
{
  BASE_EXT_DECL
  register struct DosList * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x29a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
ChangeMode (BASE_PAR_DECL long type,BPTR fh,long newmode)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = type;
  register BPTR d2 __asm("d2") = fh;
  register long d3 __asm("d3") = newmode;
  __asm __volatile ("jsr a6@(-0x1c2)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
CheckSignal (BASE_PAR_DECL long mask)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = mask;
  __asm __volatile ("jsr a6@(-0x318)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct CommandLineInterface *
Cli (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct CommandLineInterface * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1ec)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
CliInitNewcli (BASE_PAR_DECL struct DosPacket *dp)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosPacket *a0 __asm("a0") = dp;
  __asm __volatile ("jsr a6@(-0x3a2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
CliInitRun (BASE_PAR_DECL struct DosPacket *dp)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosPacket *a0 __asm("a0") = dp;
  __asm __volatile ("jsr a6@(-0x3a8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
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
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
CompareDates (BASE_PAR_DECL struct DateStamp *date1,struct DateStamp *date2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DateStamp *d1 __asm("d1") = date1;
  register struct DateStamp *d2 __asm("d2") = date2;
  __asm __volatile ("jsr a6@(-0x2e2)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BPTR 
CreateDir (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct Process *
CreateNewProc (BASE_PAR_DECL struct TagItem *tags)
{
  BASE_EXT_DECL
  register struct Process * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *d1 __asm("d1") = tags;
  __asm __volatile ("jsr a6@(-0x1f2)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct MsgPort *
CreateProc (BASE_PAR_DECL STRPTR name,long pri,BPTR segList,long stackSize)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = pri;
  register BPTR d3 __asm("d3") = segList;
  register long d4 __asm("d4") = stackSize;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
  return _res;
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
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct DateStamp *
DateStamp (BASE_PAR_DECL struct DateStamp *date)
{
  BASE_EXT_DECL
  register struct DateStamp * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DateStamp *d1 __asm("d1") = date;
  __asm __volatile ("jsr a6@(-0xc0)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
DateToStr (BASE_PAR_DECL struct DateTime *datetime)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DateTime *d1 __asm("d1") = datetime;
  __asm __volatile ("jsr a6@(-0x2e8)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
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
  : "a0","a1","d0","d1");
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
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
DeleteVar (BASE_PAR_DECL STRPTR name,unsigned long flags)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register unsigned long d2 __asm("d2") = flags;
  __asm __volatile ("jsr a6@(-0x390)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct MsgPort *
DeviceProc (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
DoPkt (BASE_PAR_DECL struct MsgPort *port,long action,long arg1,long arg2,long arg3,long arg4,long arg5)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *d1 __asm("d1") = port;
  register long d2 __asm("d2") = action;
  register long d3 __asm("d3") = arg1;
  register long d4 __asm("d4") = arg2;
  register long d5 __asm("d5") = arg3;
  register long d6 __asm("d6") = arg4;
  register long d7 __asm("d7") = arg5;
  __asm __volatile ("jsr a6@(-0xf0)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6), "r" (d7)
  : "a0","a1","d0","d1","d2","d3","d4","d5","d6","d7");
  return _res;
}
static __inline BPTR 
DupLock (BASE_PAR_DECL BPTR lock)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
DupLockFromFH (BASE_PAR_DECL BPTR fh)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  __asm __volatile ("jsr a6@(-0x174)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
EndNotify (BASE_PAR_DECL struct NotifyRequest *notify)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct NotifyRequest *d1 __asm("d1") = notify;
  __asm __volatile ("jsr a6@(-0x37e)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
}
static __inline LONG 
ErrorReport (BASE_PAR_DECL long code,long type,unsigned long arg1,struct MsgPort *device)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = code;
  register long d2 __asm("d2") = type;
  register unsigned long d3 __asm("d3") = arg1;
  register struct MsgPort *d4 __asm("d4") = device;
  __asm __volatile ("jsr a6@(-0x1e0)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
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
  : "a0","a1","d0","d1","d2","d3","d4","d5");
  return _res;
}
static __inline LONG 
ExNext (BASE_PAR_DECL BPTR lock,struct FileInfoBlock *fileInfoBlock)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  register struct FileInfoBlock *d2 __asm("d2") = fileInfoBlock;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
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
  : "a0","a1","d0","d1","d2");
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
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
Execute (BASE_PAR_DECL STRPTR string,BPTR file,BPTR file2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = string;
  register BPTR d2 __asm("d2") = file;
  register BPTR d3 __asm("d3") = file2;
  __asm __volatile ("jsr a6@(-0xde)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline void 
Exit (BASE_PAR_DECL long returnCode)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = returnCode;
  __asm __volatile ("jsr a6@(-0x90)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
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
  : "a0","a1","d0","d1");
  return _res;
}
static __inline STRPTR 
FGets (BASE_PAR_DECL BPTR fh,STRPTR buf,unsigned long buflen)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register STRPTR d2 __asm("d2") = buf;
  register unsigned long d3 __asm("d3") = buflen;
  __asm __volatile ("jsr a6@(-0x150)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
FPutC (BASE_PAR_DECL BPTR fh,unsigned long ch)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register unsigned long d2 __asm("d2") = ch;
  __asm __volatile ("jsr a6@(-0x138)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
FPuts (BASE_PAR_DECL BPTR fh,STRPTR str)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register STRPTR d2 __asm("d2") = str;
  __asm __volatile ("jsr a6@(-0x156)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
FRead (BASE_PAR_DECL BPTR fh,APTR block,unsigned long blocklen,unsigned long number)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register APTR d2 __asm("d2") = block;
  register unsigned long d3 __asm("d3") = blocklen;
  register unsigned long d4 __asm("d4") = number;
  __asm __volatile ("jsr a6@(-0x144)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
  return _res;
}
static __inline LONG 
FWrite (BASE_PAR_DECL BPTR fh,APTR block,unsigned long blocklen,unsigned long number)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register APTR d2 __asm("d2") = block;
  register unsigned long d3 __asm("d3") = blocklen;
  register unsigned long d4 __asm("d4") = number;
  __asm __volatile ("jsr a6@(-0x14a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
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
  : "a0","a1","d0","d1","d2","d3","d4");
  return _res;
}
static __inline STRPTR 
FilePart (BASE_PAR_DECL STRPTR path)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = path;
  __asm __volatile ("jsr a6@(-0x366)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
FindArg (BASE_PAR_DECL STRPTR keyword,STRPTR template)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = keyword;
  register STRPTR d2 __asm("d2") = template;
  __asm __volatile ("jsr a6@(-0x324)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct Process *
FindCliProc (BASE_PAR_DECL unsigned long num)
{
  BASE_EXT_DECL
  register struct Process * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register unsigned long d1 __asm("d1") = num;
  __asm __volatile ("jsr a6@(-0x222)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct DosList *
FindDosEntry (BASE_PAR_DECL struct DosList *dlist,STRPTR name,unsigned long flags)
{
  BASE_EXT_DECL
  register struct DosList * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosList *d1 __asm("d1") = dlist;
  register STRPTR d2 __asm("d2") = name;
  register unsigned long d3 __asm("d3") = flags;
  __asm __volatile ("jsr a6@(-0x2ac)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline struct Segment *
FindSegment (BASE_PAR_DECL STRPTR name,struct Segment *seg,long system)
{
  BASE_EXT_DECL
  register struct Segment * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register struct Segment *d2 __asm("d2") = seg;
  register long d3 __asm("d3") = system;
  __asm __volatile ("jsr a6@(-0x30c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline struct LocalVar *
FindVar (BASE_PAR_DECL STRPTR name,unsigned long type)
{
  BASE_EXT_DECL
  register struct LocalVar * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register unsigned long d2 __asm("d2") = type;
  __asm __volatile ("jsr a6@(-0x396)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
Flush (BASE_PAR_DECL BPTR fh)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  __asm __volatile ("jsr a6@(-0x168)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
Format (BASE_PAR_DECL STRPTR filesystem,STRPTR volumename,unsigned long dostype)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = filesystem;
  register STRPTR d2 __asm("d2") = volumename;
  register unsigned long d3 __asm("d3") = dostype;
  __asm __volatile ("jsr a6@(-0x2ca)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
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
  : "a0","a1","d0","d1");
}
static __inline void 
FreeDeviceProc (BASE_PAR_DECL struct DevProc *dp)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DevProc *d1 __asm("d1") = dp;
  __asm __volatile ("jsr a6@(-0x288)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
}
static __inline void 
FreeDosEntry (BASE_PAR_DECL struct DosList *dlist)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosList *d1 __asm("d1") = dlist;
  __asm __volatile ("jsr a6@(-0x2be)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
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
  : "a0","a1","d0","d1","d2");
}
static __inline STRPTR 
GetArgStr (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x216)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct MsgPort *
GetConsoleTask (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1fe)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
GetCurrentDirName (BASE_PAR_DECL STRPTR buf,long len)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = buf;
  register long d2 __asm("d2") = len;
  __asm __volatile ("jsr a6@(-0x234)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct DevProc *
GetDeviceProc (BASE_PAR_DECL STRPTR name,struct DevProc *dp)
{
  BASE_EXT_DECL
  register struct DevProc * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register struct DevProc *d2 __asm("d2") = dp;
  __asm __volatile ("jsr a6@(-0x282)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct MsgPort *
GetFileSysTask (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x20a)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
GetProgramDir (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x258)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
GetProgramName (BASE_PAR_DECL STRPTR buf,long len)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = buf;
  register long d2 __asm("d2") = len;
  __asm __volatile ("jsr a6@(-0x240)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BOOL 
GetPrompt (BASE_PAR_DECL STRPTR buf,long len)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = buf;
  register long d2 __asm("d2") = len;
  __asm __volatile ("jsr a6@(-0x24c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
GetVar (BASE_PAR_DECL STRPTR name,STRPTR buffer,long size,long flags)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register STRPTR d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = size;
  register long d4 __asm("d4") = flags;
  __asm __volatile ("jsr a6@(-0x38a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
  return _res;
}
static __inline LONG 
Info (BASE_PAR_DECL BPTR lock,struct InfoData *parameterBlock)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  register struct InfoData *d2 __asm("d2") = parameterBlock;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
Inhibit (BASE_PAR_DECL STRPTR name,long onoff)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = onoff;
  __asm __volatile ("jsr a6@(-0x2d6)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BPTR 
Input (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
InternalLoadSeg (BASE_PAR_DECL BPTR fh,BPTR table,LONG *funcarray,LONG *stack)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d0 __asm("d0") = fh;
  register BPTR a0 __asm("a0") = table;
  register LONG *a1 __asm("a1") = funcarray;
  register LONG *a2 __asm("a2") = stack;
  __asm __volatile ("jsr a6@(-0x2f4)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline void 
InternalUnLoadSeg (BASE_PAR_DECL BPTR seglist,void (*freefunc)())
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = seglist;
  register void (*a1)() __asm("a1") = freefunc;
  __asm __volatile ("jsr a6@(-0x2fa)"
  : /* no output */
  : "r" (a6), "r" (d1), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a1 = *(char *)a1;
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
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
IsFileSystem (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0x2c4)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
IsInteractive (BASE_PAR_DECL BPTR file)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = file;
  __asm __volatile ("jsr a6@(-0xd8)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
LoadSeg (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
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
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct DosList *
LockDosList (BASE_PAR_DECL unsigned long flags)
{
  BASE_EXT_DECL
  register struct DosList * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x28e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
LockRecord (BASE_PAR_DECL BPTR fh,unsigned long offset,unsigned long length,unsigned long mode,unsigned long timeout)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register unsigned long d2 __asm("d2") = offset;
  register unsigned long d3 __asm("d3") = length;
  register unsigned long d4 __asm("d4") = mode;
  register unsigned long d5 __asm("d5") = timeout;
  __asm __volatile ("jsr a6@(-0x10e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","d2","d3","d4","d5");
  return _res;
}
static __inline BOOL 
LockRecords (BASE_PAR_DECL struct RecordLock *recArray,unsigned long timeout)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct RecordLock *d1 __asm("d1") = recArray;
  register unsigned long d2 __asm("d2") = timeout;
  __asm __volatile ("jsr a6@(-0x114)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct DosList *
MakeDosEntry (BASE_PAR_DECL STRPTR name,long type)
{
  BASE_EXT_DECL
  register struct DosList * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = type;
  __asm __volatile ("jsr a6@(-0x2b8)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
MakeLink (BASE_PAR_DECL STRPTR name,long dest,long soft)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = dest;
  register long d3 __asm("d3") = soft;
  __asm __volatile ("jsr a6@(-0x1bc)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline void 
MatchEnd (BASE_PAR_DECL struct AnchorPath *anchor)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct AnchorPath *d1 __asm("d1") = anchor;
  __asm __volatile ("jsr a6@(-0x342)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
}
static __inline LONG 
MatchFirst (BASE_PAR_DECL STRPTR pat,struct AnchorPath *anchor)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = pat;
  register struct AnchorPath *d2 __asm("d2") = anchor;
  __asm __volatile ("jsr a6@(-0x336)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
MatchNext (BASE_PAR_DECL struct AnchorPath *anchor)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct AnchorPath *d1 __asm("d1") = anchor;
  __asm __volatile ("jsr a6@(-0x33c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
MatchPattern (BASE_PAR_DECL STRPTR pat,STRPTR str)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = pat;
  register STRPTR d2 __asm("d2") = str;
  __asm __volatile ("jsr a6@(-0x34e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
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
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline ULONG 
MaxCli (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x228)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
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
  : "a0","a1","d0","d1","d2","d3");
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
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline BPTR 
NewLoadSeg (BASE_PAR_DECL STRPTR file,struct TagItem *tags)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = file;
  register struct TagItem *d2 __asm("d2") = tags;
  __asm __volatile ("jsr a6@(-0x300)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct DosList *
NextDosEntry (BASE_PAR_DECL struct DosList *dlist,unsigned long flags)
{
  BASE_EXT_DECL
  register struct DosList * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosList *d1 __asm("d1") = dlist;
  register unsigned long d2 __asm("d2") = flags;
  __asm __volatile ("jsr a6@(-0x2b2)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
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
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BPTR 
OpenFromLock (BASE_PAR_DECL BPTR lock)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  __asm __volatile ("jsr a6@(-0x17a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
Output (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
ParentDir (BASE_PAR_DECL BPTR lock)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
ParentOfFH (BASE_PAR_DECL BPTR fh)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  __asm __volatile ("jsr a6@(-0x180)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
ParsePattern (BASE_PAR_DECL STRPTR pat,STRPTR buf,long buflen)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = pat;
  register STRPTR d2 __asm("d2") = buf;
  register long d3 __asm("d3") = buflen;
  __asm __volatile ("jsr a6@(-0x348)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
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
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline STRPTR 
PathPart (BASE_PAR_DECL STRPTR path)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = path;
  __asm __volatile ("jsr a6@(-0x36c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
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
  : "a0","a1","d0","d1","d2");
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
  : "a0","a1","d0","d1");
  return _res;
}
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
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline struct RDArgs *
ReadArgs (BASE_PAR_DECL STRPTR template,LONG *array,struct RDArgs *args)
{
  BASE_EXT_DECL
  register struct RDArgs * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = template;
  register LONG *d2 __asm("d2") = array;
  register struct RDArgs *d3 __asm("d3") = args;
  __asm __volatile ("jsr a6@(-0x31e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
ReadItem (BASE_PAR_DECL STRPTR name,long maxchars,struct CSource *cSource)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = maxchars;
  register struct CSource *d3 __asm("d3") = cSource;
  __asm __volatile ("jsr a6@(-0x32a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
ReadLink (BASE_PAR_DECL struct MsgPort *port,BPTR lock,STRPTR path,STRPTR buffer,unsigned long size)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *d1 __asm("d1") = port;
  register BPTR d2 __asm("d2") = lock;
  register STRPTR d3 __asm("d3") = path;
  register STRPTR d4 __asm("d4") = buffer;
  register unsigned long d5 __asm("d5") = size;
  __asm __volatile ("jsr a6@(-0x1b6)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","d2","d3","d4","d5");
  return _res;
}
static __inline LONG 
Relabel (BASE_PAR_DECL STRPTR drive,STRPTR newname)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = drive;
  register STRPTR d2 __asm("d2") = newname;
  __asm __volatile ("jsr a6@(-0x2d0)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
RemAssignList (BASE_PAR_DECL STRPTR name,BPTR lock)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register BPTR d2 __asm("d2") = lock;
  __asm __volatile ("jsr a6@(-0x27c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BOOL 
RemDosEntry (BASE_PAR_DECL struct DosList *dlist)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosList *d1 __asm("d1") = dlist;
  __asm __volatile ("jsr a6@(-0x2a0)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
RemSegment (BASE_PAR_DECL struct Segment *seg)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct Segment *d1 __asm("d1") = seg;
  __asm __volatile ("jsr a6@(-0x312)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
Rename (BASE_PAR_DECL STRPTR oldName,STRPTR newName)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = oldName;
  register STRPTR d2 __asm("d2") = newName;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline void 
ReplyPkt (BASE_PAR_DECL struct DosPacket *dp,long res1,long res2)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosPacket *d1 __asm("d1") = dp;
  register long d2 __asm("d2") = res1;
  register long d3 __asm("d3") = res2;
  __asm __volatile ("jsr a6@(-0x102)"
  : /* no output */
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
}
static __inline LONG 
RunCommand (BASE_PAR_DECL BPTR seg,long stack,STRPTR paramptr,long paramlen)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = seg;
  register long d2 __asm("d2") = stack;
  register STRPTR d3 __asm("d3") = paramptr;
  register long d4 __asm("d4") = paramlen;
  __asm __volatile ("jsr a6@(-0x1f8)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
  return _res;
}
static __inline BOOL 
SameDevice (BASE_PAR_DECL BPTR lock1,BPTR lock2)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock1;
  register BPTR d2 __asm("d2") = lock2;
  __asm __volatile ("jsr a6@(-0x3d8)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
SameLock (BASE_PAR_DECL BPTR lock1,BPTR lock2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock1;
  register BPTR d2 __asm("d2") = lock2;
  __asm __volatile ("jsr a6@(-0x1a4)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
Seek (BASE_PAR_DECL BPTR file,long position,long offset)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = file;
  register long d2 __asm("d2") = position;
  register long d3 __asm("d3") = offset;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
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
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BPTR 
SelectOutput (BASE_PAR_DECL BPTR fh)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  __asm __volatile ("jsr a6@(-0x12c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
SendPkt (BASE_PAR_DECL struct DosPacket *dp,struct MsgPort *port,struct MsgPort *replyport)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DosPacket *d1 __asm("d1") = dp;
  register struct MsgPort *d2 __asm("d2") = port;
  register struct MsgPort *d3 __asm("d3") = replyport;
  __asm __volatile ("jsr a6@(-0xf6)"
  : /* no output */
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
}
static __inline BOOL 
SetArgStr (BASE_PAR_DECL STRPTR string)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = string;
  __asm __volatile ("jsr a6@(-0x21c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
SetComment (BASE_PAR_DECL STRPTR name,STRPTR comment)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register STRPTR d2 __asm("d2") = comment;
  __asm __volatile ("jsr a6@(-0xb4)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct MsgPort *
SetConsoleTask (BASE_PAR_DECL struct MsgPort *task)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *d1 __asm("d1") = task;
  __asm __volatile ("jsr a6@(-0x204)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
SetCurrentDirName (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0x22e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
SetFileDate (BASE_PAR_DECL STRPTR name,struct DateStamp *date)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register struct DateStamp *d2 __asm("d2") = date;
  __asm __volatile ("jsr a6@(-0x18c)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
SetFileSize (BASE_PAR_DECL BPTR fh,long pos,long mode)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register long d2 __asm("d2") = pos;
  register long d3 __asm("d3") = mode;
  __asm __volatile ("jsr a6@(-0x1c8)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline struct MsgPort *
SetFileSysTask (BASE_PAR_DECL struct MsgPort *task)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *d1 __asm("d1") = task;
  __asm __volatile ("jsr a6@(-0x210)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
SetIoErr (BASE_PAR_DECL long result)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = result;
  __asm __volatile ("jsr a6@(-0x1ce)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
SetMode (BASE_PAR_DECL BPTR fh,long mode)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register long d2 __asm("d2") = mode;
  __asm __volatile ("jsr a6@(-0x1aa)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline BPTR 
SetProgramDir (BASE_PAR_DECL BPTR lock)
{
  BASE_EXT_DECL
  register BPTR  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = lock;
  __asm __volatile ("jsr a6@(-0x252)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
SetProgramName (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0x23a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
SetPrompt (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  __asm __volatile ("jsr a6@(-0x246)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
SetProtection (BASE_PAR_DECL STRPTR name,long protect)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register long d2 __asm("d2") = protect;
  __asm __volatile ("jsr a6@(-0xba)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
SetVBuf (BASE_PAR_DECL BPTR fh,STRPTR buff,long type,long size)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register STRPTR d2 __asm("d2") = buff;
  register long d3 __asm("d3") = type;
  register long d4 __asm("d4") = size;
  __asm __volatile ("jsr a6@(-0x16e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
  return _res;
}
static __inline BOOL 
SetVar (BASE_PAR_DECL STRPTR name,STRPTR buffer,long size,long flags)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register STRPTR d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = size;
  register long d4 __asm("d4") = flags;
  __asm __volatile ("jsr a6@(-0x384)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4");
  return _res;
}
static __inline WORD 
SplitName (BASE_PAR_DECL STRPTR name,unsigned long seperator,STRPTR buf,long oldpos,long size)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = name;
  register unsigned long d2 __asm("d2") = seperator;
  register STRPTR d3 __asm("d3") = buf;
  register long d4 __asm("d4") = oldpos;
  register long d5 __asm("d5") = size;
  __asm __volatile ("jsr a6@(-0x19e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","d2","d3","d4","d5");
  return _res;
}
static __inline BOOL 
StartNotify (BASE_PAR_DECL struct NotifyRequest *notify)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct NotifyRequest *d1 __asm("d1") = notify;
  __asm __volatile ("jsr a6@(-0x378)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
StrToDate (BASE_PAR_DECL struct DateTime *datetime)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct DateTime *d1 __asm("d1") = datetime;
  __asm __volatile ("jsr a6@(-0x2ee)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
StrToLong (BASE_PAR_DECL STRPTR string,LONG *value)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = string;
  register LONG *d2 __asm("d2") = value;
  __asm __volatile ("jsr a6@(-0x330)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
SystemTagList (BASE_PAR_DECL STRPTR command,struct TagItem *tags)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = command;
  register struct TagItem *d2 __asm("d2") = tags;
  __asm __volatile ("jsr a6@(-0x25e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
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
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline void 
UnLoadSeg (BASE_PAR_DECL BPTR seglist)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = seglist;
  __asm __volatile ("jsr a6@(-0x9c)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
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
  : "a0","a1","d0","d1");
}
static __inline void 
UnLockDosList (BASE_PAR_DECL unsigned long flags)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x294)"
  : /* no output */
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
}
static __inline BOOL 
UnLockRecord (BASE_PAR_DECL BPTR fh,unsigned long offset,unsigned long length)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register unsigned long d2 __asm("d2") = offset;
  register unsigned long d3 __asm("d3") = length;
  __asm __volatile ("jsr a6@(-0x11a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline BOOL 
UnLockRecords (BASE_PAR_DECL struct RecordLock *recArray)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register struct RecordLock *d1 __asm("d1") = recArray;
  __asm __volatile ("jsr a6@(-0x120)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
VFPrintf (BASE_PAR_DECL BPTR fh,STRPTR format,LONG *argarray)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register STRPTR d2 __asm("d2") = format;
  register LONG *d3 __asm("d3") = argarray;
  __asm __volatile ("jsr a6@(-0x162)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline void 
VFWritef (BASE_PAR_DECL BPTR fh,STRPTR format,LONG *argarray)
{
  BASE_EXT_DECL
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = fh;
  register STRPTR d2 __asm("d2") = format;
  register LONG *d3 __asm("d3") = argarray;
  __asm __volatile ("jsr a6@(-0x15c)"
  : /* no output */
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
}
static __inline LONG 
VPrintf (BASE_PAR_DECL STRPTR format,LONG *argarray)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = format;
  register LONG *d2 __asm("d2") = argarray;
  __asm __volatile ("jsr a6@(-0x3ba)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline LONG 
WaitForChar (BASE_PAR_DECL BPTR file,long timeout)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = file;
  register long d2 __asm("d2") = timeout;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
static __inline struct DosPacket *
WaitPkt (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct DosPacket * _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xfc)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
Write (BASE_PAR_DECL BPTR file,APTR buffer,long length)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register BPTR d1 __asm("d1") = file;
  register APTR d2 __asm("d2") = buffer;
  register long d3 __asm("d3") = length;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
WriteChars (BASE_PAR_DECL STRPTR buf,unsigned long buflen)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DosLibrary *a6 __asm("a6") = BASE_NAME;
  register STRPTR d1 __asm("d1") = buf;
  register unsigned long d2 __asm("d2") = buflen;
  __asm __volatile ("jsr a6@(-0x3ae)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_DOS_H */
