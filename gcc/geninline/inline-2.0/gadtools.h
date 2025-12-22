#ifndef _INLINE_GADTOOLS_H
#define _INLINE_GADTOOLS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct GadToolsBase*  GadToolsBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME GadToolsBase
#endif

static __inline struct Gadget *
CreateContext (BASE_PAR_DECL struct Gadget **glistptr)
{
  BASE_EXT_DECL
  register struct Gadget * _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Gadget **a0 __asm("a0") = glistptr;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct Gadget *
CreateGadgetA (BASE_PAR_DECL unsigned long kind,struct Gadget *gad,struct NewGadget *ng,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct Gadget * _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = kind;
  register struct Gadget *a0 __asm("a0") = gad;
  register struct NewGadget *a1 __asm("a1") = ng;
  register struct TagItem *a2 __asm("a2") = taglist;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline struct Menu *
CreateMenusA (BASE_PAR_DECL struct NewMenu *newmenu,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct Menu * _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct NewMenu *a0 __asm("a0") = newmenu;
  register struct TagItem *a1 __asm("a1") = taglist;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
DrawBevelBoxA (BASE_PAR_DECL struct RastPort *rport,long left,long top,long width,long height,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rport;
  register long d0 __asm("d0") = left;
  register long d1 __asm("d1") = top;
  register long d2 __asm("d2") = width;
  register long d3 __asm("d3") = height;
  register struct TagItem *a1 __asm("a1") = taglist;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a1)
  : "a0","a1","d0","d1","d2","d3");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline void 
FreeGadgets (BASE_PAR_DECL struct Gadget *gad)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gad;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
FreeMenus (BASE_PAR_DECL struct Menu *menu)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Menu *a0 __asm("a0") = menu;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
FreeVisualInfo (BASE_PAR_DECL APTR vi)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = vi;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
GT_BeginRefresh (BASE_PAR_DECL struct Window *win)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = win;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
GT_EndRefresh (BASE_PAR_DECL struct Window *win,long complete)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = win;
  register long d0 __asm("d0") = complete;
  __asm __volatile ("jsr a6@(-0x60)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline struct IntuiMessage *
GT_FilterIMsg (BASE_PAR_DECL struct IntuiMessage *imsg)
{
  BASE_EXT_DECL
  register struct IntuiMessage * _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct IntuiMessage *a1 __asm("a1") = imsg;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct IntuiMessage *
GT_GetIMsg (BASE_PAR_DECL struct MsgPort *iport)
{
  BASE_EXT_DECL
  register struct IntuiMessage * _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = iport;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct IntuiMessage *
GT_PostFilterIMsg (BASE_PAR_DECL struct IntuiMessage *imsg)
{
  BASE_EXT_DECL
  register struct IntuiMessage * _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct IntuiMessage *a1 __asm("a1") = imsg;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
GT_RefreshWindow (BASE_PAR_DECL struct Window *win,struct Requester *req)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = win;
  register struct Requester *a1 __asm("a1") = req;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline void 
GT_ReplyIMsg (BASE_PAR_DECL struct IntuiMessage *imsg)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct IntuiMessage *a1 __asm("a1") = imsg;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a1 = *(char *)a1;
}
static __inline void 
GT_SetGadgetAttrsA (BASE_PAR_DECL struct Gadget *gad,struct Window *win,struct Requester *req,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gad;
  register struct Window *a1 __asm("a1") = win;
  register struct Requester *a2 __asm("a2") = req;
  register struct TagItem *a3 __asm("a3") = taglist;
  __asm __volatile ("jsr a6@(-0x2a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;  *(char *)a3 = *(char *)a3;
}
static __inline APTR 
GetVisualInfoA (BASE_PAR_DECL struct Screen *screen,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register struct TagItem *a1 __asm("a1") = taglist;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline BOOL 
LayoutMenuItemsA (BASE_PAR_DECL struct MenuItem *firstitem,APTR vi,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct MenuItem *a0 __asm("a0") = firstitem;
  register APTR a1 __asm("a1") = vi;
  register struct TagItem *a2 __asm("a2") = taglist;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline BOOL 
LayoutMenusA (BASE_PAR_DECL struct Menu *firstmenu,APTR vi,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GadToolsBase* a6 __asm("a6") = BASE_NAME;
  register struct Menu *a0 __asm("a0") = firstmenu;
  register APTR a1 __asm("a1") = vi;
  register struct TagItem *a2 __asm("a2") = taglist;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_GADTOOLS_H */
