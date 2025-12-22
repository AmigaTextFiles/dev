#ifndef _INLINE_WB_H
#define _INLINE_WB_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct WorkbenchBase*  WorkbenchBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME WorkbenchBase
#endif

static __inline struct AppIcon *
AddAppIconA (BASE_PAR_DECL unsigned long id,unsigned long userdata,UBYTE *text,struct MsgPort *msgport,struct FileLock *lock,struct DiskObject *diskobj,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct AppIcon * _res  __asm("d0");
  register struct WorkbenchBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = id;
  register unsigned long d1 __asm("d1") = userdata;
  register UBYTE *a0 __asm("a0") = text;
  register struct MsgPort *a1 __asm("a1") = msgport;
  register struct FileLock *a2 __asm("a2") = lock;
  register struct DiskObject *a3 __asm("a3") = diskobj;
  register struct TagItem *a4 __asm("d2") = taglist;
  __asm __volatile ("movel a4,sp@-; movel d2,a4; jsr a6@(-0x42); movel sp@+,a4"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
  : "a0","a1","a2","a3","d0","d1","d2");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;  *(char *)a3 = *(char *)a3;  *(char *)a4 = *(char *)a4;
  return _res;
}
static __inline struct AppMenuItem *
AddAppMenuItemA (BASE_PAR_DECL unsigned long id,unsigned long userdata,UBYTE *text,struct MsgPort *msgport,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct AppMenuItem * _res  __asm("d0");
  register struct WorkbenchBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = id;
  register unsigned long d1 __asm("d1") = userdata;
  register UBYTE *a0 __asm("a0") = text;
  register struct MsgPort *a1 __asm("a1") = msgport;
  register struct TagItem *a2 __asm("a2") = taglist;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline struct AppWindow *
AddAppWindowA (BASE_PAR_DECL unsigned long id,unsigned long userdata,struct Window *window,struct MsgPort *msgport,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct AppWindow * _res  __asm("d0");
  register struct WorkbenchBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = id;
  register unsigned long d1 __asm("d1") = userdata;
  register struct Window *a0 __asm("a0") = window;
  register struct MsgPort *a1 __asm("a1") = msgport;
  register struct TagItem *a2 __asm("a2") = taglist;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline BOOL 
RemoveAppIcon (BASE_PAR_DECL struct AppIcon *appIcon)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct WorkbenchBase* a6 __asm("a6") = BASE_NAME;
  register struct AppIcon *a0 __asm("a0") = appIcon;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline BOOL 
RemoveAppMenuItem (BASE_PAR_DECL struct AppMenuItem *appMenuItem)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct WorkbenchBase* a6 __asm("a6") = BASE_NAME;
  register struct AppMenuItem *a0 __asm("a0") = appMenuItem;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline BOOL 
RemoveAppWindow (BASE_PAR_DECL struct AppWindow *appWindow)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct WorkbenchBase* a6 __asm("a6") = BASE_NAME;
  register struct AppWindow *a0 __asm("a0") = appWindow;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_WB_H */
