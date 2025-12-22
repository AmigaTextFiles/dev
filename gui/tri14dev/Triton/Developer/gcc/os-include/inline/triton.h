#ifndef _INLINE_TRITON_H
#define _INLINE_TRITON_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * TritonBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME TritonBase
#endif

BASE_EXT_DECL0

extern __inline ULONG 
TR_AutoRequest (BASE_PAR_DECL struct TR_App *app,struct TR_Project *lockproject,struct TagItem *wintags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_App *a1 __asm("a1") = app;
  register struct TR_Project *a0 __asm("a0") = lockproject;
  register struct TagItem *a2 __asm("a2") = wintags;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline VOID 
TR_CloseProject (BASE_PAR_DECL struct TR_Project *project)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Project *a0 __asm("a0") = project;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline VOID 
TR_CloseWindowSafely (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x7e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct TR_App * 
TR_CreateApp (BASE_PAR_DECL struct TagItem *apptags)
{
  BASE_EXT_DECL
  register struct TR_App *  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a1 __asm("a1") = apptags;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline VOID 
TR_DeleteApp (BASE_PAR_DECL struct TR_App *app)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_App *a1 __asm("a1") = app;
  __asm __volatile ("jsr a6@(-0x66)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
TR_EasyRequest (BASE_PAR_DECL struct TR_App *app,STRPTR bodyfmt,STRPTR gadfmt,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_App *a1 __asm("a1") = app;
  register STRPTR a2 __asm("a2") = bodyfmt;
  register STRPTR a3 __asm("a3") = gadfmt;
  register struct TagItem *a0 __asm("a0") = taglist;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a2), "r" (a3), "r" (a0)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
TR_FirstOccurance (BASE_PAR_DECL UBYTE ch,STRPTR str)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE d0 __asm("d0") = ch;
  register STRPTR a0 __asm("a0") = str;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
TR_GetAttribute (BASE_PAR_DECL struct TR_Project *project,ULONG ID,ULONG attribute)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Project *a0 __asm("a0") = project;
  register ULONG d0 __asm("d0") = ID;
  register ULONG d1 __asm("d1") = attribute;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline STRPTR 
TR_GetErrorString (BASE_PAR_DECL UWORD num)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UWORD d0 __asm("d0") = num;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UWORD 
TR_GetLastError (BASE_PAR_DECL struct TR_App *app)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_App *a1 __asm("a1") = app;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct TR_Message * 
TR_GetMsg (BASE_PAR_DECL struct TR_App *app)
{
  BASE_EXT_DECL
  register struct TR_Message *  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_App *a1 __asm("a1") = app;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline VOID 
TR_LockProject (BASE_PAR_DECL struct TR_Project *project)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Project *a0 __asm("a0") = project;
  __asm __volatile ("jsr a6@(-0x48)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Screen * 
TR_LockScreen (BASE_PAR_DECL struct TR_Project *project)
{
  BASE_EXT_DECL
  register struct Screen *  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Project *a0 __asm("a0") = project;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
TR_NumOccurances (BASE_PAR_DECL UBYTE ch,STRPTR str)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE d0 __asm("d0") = ch;
  register STRPTR a0 __asm("a0") = str;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Window * 
TR_ObtainWindow (BASE_PAR_DECL struct TR_Project *project)
{
  BASE_EXT_DECL
  register struct Window *  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Project *a0 __asm("a0") = project;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct TR_Project * 
TR_OpenProject (BASE_PAR_DECL struct TR_App *app,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct TR_Project *  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_App *a1 __asm("a1") = app;
  register struct TagItem *a0 __asm("a0") = taglist;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline VOID 
TR_ReleaseWindow (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x9c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline VOID 
TR_ReplyMsg (BASE_PAR_DECL struct TR_Message *message)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Message *a1 __asm("a1") = message;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline VOID 
TR_SetAttribute (BASE_PAR_DECL struct TR_Project *project,ULONG ID,ULONG attribute,ULONG value)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Project *a0 __asm("a0") = project;
  register ULONG d0 __asm("d0") = ID;
  register ULONG d1 __asm("d1") = attribute;
  register ULONG d2 __asm("d2") = value;
  __asm __volatile ("jsr a6@(-0x3c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
}
extern __inline VOID 
TR_UnlockProject (BASE_PAR_DECL struct TR_Project *project)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_Project *a0 __asm("a0") = project;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline VOID 
TR_UnlockScreen (BASE_PAR_DECL struct Screen *screen)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  __asm __volatile ("jsr a6@(-0x90)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
TR_Wait (BASE_PAR_DECL struct TR_App *app,ULONG otherbits)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TR_App *a1 __asm("a1") = app;
  register ULONG d0 __asm("d0") = otherbits;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_TRITON_H */
