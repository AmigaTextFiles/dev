#ifndef _INLINE_GUIFRONT_H
#define _INLINE_GUIFRONT_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * GUIFrontBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME GUIFrontBase
#endif

BASE_EXT_DECL0

extern __inline BOOL 
GF_AslRequest (BASE_PAR_DECL APTR const requester,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR const a0 __asm("a0") = requester;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0xe4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_AslRequestTags(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_AslRequest ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
GF_BeginRefresh (BASE_PAR_DECL GUIFront * const frontgui)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  __asm __volatile ("jsr a6@(-0x66)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_CopyAppID (BASE_PAR_DECL PrefsHandle * const prefshandle,char * const dest)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register PrefsHandle * const a0 __asm("a0") = prefshandle;
  register char * const a1 __asm("a1") = dest;
  __asm __volatile ("jsr a6@(-0xba)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline GUIFront *
GF_CreateGUIA (BASE_PAR_DECL GUIFrontApp * const frontguiapp,ULONG * const layouttags,GadgetSpec ** const gadgetlist,struct TagItem * const ctrltags)
{
  BASE_EXT_DECL
  register GUIFront * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = frontguiapp;
  register ULONG * const a1 __asm("a1") = layouttags;
  register GadgetSpec ** const a2 __asm("a2") = gadgetlist;
  register struct TagItem * const a3 __asm("a3") = ctrltags;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_CreateGUI(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_CreateGUIA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline GUIFrontApp *
GF_CreateGUIAppA (BASE_PAR_DECL char * const appid,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register GUIFrontApp * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = appid;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_CreateGUIApp(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_CreateGUIAppA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline BOOL 
GF_DefaultPrefs (BASE_PAR_DECL char * const appid)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = appid;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
GF_DeletePrefs (BASE_PAR_DECL char * const appid)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = appid;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
GF_DestroyGUI (BASE_PAR_DECL GUIFront * const frontgui)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_DestroyGUIApp (BASE_PAR_DECL GUIFrontApp * const appidhandle)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = appidhandle;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline long 
GF_EasyRequestArgs (BASE_PAR_DECL GUIFrontApp * const app,struct Window * const window,struct EasyStruct * const easystruct,ULONG * const idcmpptr,APTR const arglist)
{
  BASE_EXT_DECL
  register long  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const d0 __asm("d0") = app;
  register struct Window * const d1 __asm("d1") = window;
  register struct EasyStruct * const a0 __asm("a0") = easystruct;
  register ULONG * const a1 __asm("a1") = idcmpptr;
  register APTR const a2 __asm("a2") = arglist;
  __asm __volatile ("jsr a6@(-0xea)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_EasyRequest(a0, a1, a2, a3, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_EasyRequestArgs ((a0), (a1), (a2), (a3), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
GF_EndNotifyPrefsChange (BASE_PAR_DECL struct Task * const task)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Task * const a0 __asm("a0") = task;
  __asm __volatile ("jsr a6@(-0xde)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_EndRefresh (BASE_PAR_DECL GUIFront * const frontgui,const BOOL all)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  register const BOOL d0 __asm("d0") = all;
  __asm __volatile ("jsr a6@(-0x6c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline PrefsHandle *
GF_FirstPrefsNode (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register PrefsHandle * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GF_GetGUIAppAttrA (BASE_PAR_DECL GUIFrontApp * const appidhandle,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = appidhandle;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_GetGUIAppAttr(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_GetGUIAppAttrA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
GF_GetGUIAttrA (BASE_PAR_DECL GUIFront * const frontgui,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_GetGUIAttr(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_GetGUIAttrA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
GF_GetGadgetAttrsA (BASE_PAR_DECL GUIFront * const frontgui,struct Gadget * const gadget,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  register struct Gadget * const a1 __asm("a1") = gadget;
  register struct TagItem * const a2 __asm("a2") = tags;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_GetGadgetAttrs(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_GetGadgetAttrsA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct IntuiMessage *
GF_GetIMsg (BASE_PAR_DECL GUIFrontApp * const appidhandle)
{
  BASE_EXT_DECL
  register struct IntuiMessage * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = appidhandle;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GF_GetPubScreenAttrA (BASE_PAR_DECL char * const pubname,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = pubname;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0xfc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_GetPubScreenAttr(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_GetPubScreenAttrA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline BOOL 
GF_LoadPrefs (BASE_PAR_DECL char * const filename)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = filename;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
GF_LockGUI (BASE_PAR_DECL GUIFront * const frontgui)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  __asm __volatile ("jsr a6@(-0x7e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_LockGUIApp (BASE_PAR_DECL GUIFrontApp * const frontguiapp)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = frontguiapp;
  __asm __volatile ("jsr a6@(-0x8a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_LockPrefsList (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xa2)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline PrefsHandle *
GF_NextPrefsNode (BASE_PAR_DECL PrefsHandle * const prefshandle)
{
  BASE_EXT_DECL
  register PrefsHandle * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register PrefsHandle * const a0 __asm("a0") = prefshandle;
  __asm __volatile ("jsr a6@(-0xb4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
GF_NotifyPrefsChange (BASE_PAR_DECL struct Task * const task,const ULONG signals)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Task * const a0 __asm("a0") = task;
  register const ULONG d0 __asm("d0") = signals;
  __asm __volatile ("jsr a6@(-0xd8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
GF_ProcessListView (BASE_PAR_DECL GUIFront * const gui,GadgetSpec * const gadgetspec,struct IntuiMessage * const imsg,UWORD * const ordinal)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = gui;
  register GadgetSpec * const a1 __asm("a1") = gadgetspec;
  register struct IntuiMessage * const a2 __asm("a2") = imsg;
  register UWORD * const a3 __asm("a3") = ordinal;
  __asm __volatile ("jsr a6@(-0xf0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
extern __inline void 
GF_ReplyIMsg (BASE_PAR_DECL struct IntuiMessage * const intuimessage)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct IntuiMessage * const a0 __asm("a0") = intuimessage;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
GF_SavePrefs (BASE_PAR_DECL char * const filename)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = filename;
  __asm __volatile ("jsr a6@(-0x9c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
GF_SetAliasKey (BASE_PAR_DECL GUIFront * const frontgui,UBYTE const rawkey,UWORD const gadgetid)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  register UBYTE const d0 __asm("d0") = rawkey;
  register UWORD const d1 __asm("d1") = gadgetid;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GF_SetGUIAppAttrA (BASE_PAR_DECL GUIFrontApp * const appidhandle,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = appidhandle;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_SetGUIAppAttr(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_SetGUIAppAttrA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
GF_SetGUIAttrA (BASE_PAR_DECL GUIFront * const frontgui,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_SetGUIAttr(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_SetGUIAttrA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
GF_SetGadgetAttrsA (BASE_PAR_DECL GUIFront * const frontgui,struct Gadget * const gadget,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  register struct Gadget * const a1 __asm("a1") = gadget;
  register struct TagItem * const a2 __asm("a2") = tags;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
#ifndef NO_INLINE_STDARG
#define GF_SetGadgetAttrs(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_SetGadgetAttrsA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
GF_SetPubScreenAttrA (BASE_PAR_DECL char * const pubname,struct TagItem * const tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = pubname;
  register struct TagItem * const a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x102)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GF_SetPubScreenAttr(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GF_SetPubScreenAttrA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
GF_SignalPrefsVChange (BASE_PAR_DECL char * const appid)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register char * const a0 __asm("a0") = appid;
  __asm __volatile ("jsr a6@(-0xf6)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_UnlockGUI (BASE_PAR_DECL GUIFront * const frontgui)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFront * const a0 __asm("a0") = frontgui;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_UnlockGUIApp (BASE_PAR_DECL GUIFrontApp * const frontguiapp)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = frontguiapp;
  __asm __volatile ("jsr a6@(-0x90)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GF_UnlockPrefsList (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xa8)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
GF_Wait (BASE_PAR_DECL GUIFrontApp * const appidhandle,ULONG const othersignals)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register GUIFrontApp * const a0 __asm("a0") = appidhandle;
  register ULONG const d0 __asm("d0") = othersignals;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_GUIFRONT_H */
