#ifndef _INLINE_WB_H
#define _INLINE_WB_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * WorkbenchBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME WorkbenchBase
#endif

BASE_EXT_DECL0

extern __inline struct AppIcon *
AddAppIconA (BASE_PAR_DECL unsigned long id,unsigned long userdata,UBYTE *text,struct MsgPort *msgport,struct FileLock *lock,struct DiskObject *diskobj,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct AppIcon * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = id;
  register unsigned long d1 __asm("d1") = userdata;
  register UBYTE *a0 __asm("a0") = text;
  register struct MsgPort *a1 __asm("a1") = msgport;
  register struct FileLock *a2 __asm("a2") = lock;
  register struct DiskObject *a3 __asm("a3") = diskobj;
  register struct TagItem *d7 __asm("d7") = taglist;
  __asm __volatile ("exg d7,a4\n\tjsr a6@(-0x3c)\n\texg d7,a4"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d7), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1","d7", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define AddAppIcon(a0, a1, a2, a3, a4, a5, tags...) \
  ({ struct TagItem _tags[] = { tags }; AddAppIconA ((a0), (a1), (a2), (a3), (a4), (a5), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct AppMenuItem *
AddAppMenuItemA (BASE_PAR_DECL unsigned long id,unsigned long userdata,UBYTE *text,struct MsgPort *msgport,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct AppMenuItem * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = id;
  register unsigned long d1 __asm("d1") = userdata;
  register UBYTE *a0 __asm("a0") = text;
  register struct MsgPort *a1 __asm("a1") = msgport;
  register struct TagItem *a2 __asm("a2") = taglist;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define AddAppMenuItem(a0, a1, a2, a3, tags...) \
  ({ struct TagItem _tags[] = { tags }; AddAppMenuItemA ((a0), (a1), (a2), (a3), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct AppWindow *
AddAppWindowA (BASE_PAR_DECL unsigned long id,unsigned long userdata,struct Window *window,struct MsgPort *msgport,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct AppWindow * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = id;
  register unsigned long d1 __asm("d1") = userdata;
  register struct Window *a0 __asm("a0") = window;
  register struct MsgPort *a1 __asm("a1") = msgport;
  register struct TagItem *a2 __asm("a2") = taglist;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define AddAppWindow(a0, a1, a2, a3, tags...) \
  ({ struct TagItem _tags[] = { tags }; AddAppWindowA ((a0), (a1), (a2), (a3), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline BOOL 
RemoveAppIcon (BASE_PAR_DECL struct AppIcon *appIcon)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct AppIcon *a0 __asm("a0") = appIcon;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
RemoveAppMenuItem (BASE_PAR_DECL struct AppMenuItem *appMenuItem)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct AppMenuItem *a0 __asm("a0") = appMenuItem;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
RemoveAppWindow (BASE_PAR_DECL struct AppWindow *appWindow)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct AppWindow *a0 __asm("a0") = appWindow;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
WBInfo (BASE_PAR_DECL BPTR lock,STRPTR name,struct Screen *screen)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register BPTR a0 __asm("a0") = lock;
  register STRPTR a1 __asm("a1") = name;
  register struct Screen *a2 __asm("a2") = screen;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_WB_H */
