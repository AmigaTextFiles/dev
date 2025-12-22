#ifndef _INLINE_INTUITION_H
#define _INLINE_INTUITION_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct IntuitionBase * IntuitionBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME IntuitionBase
#endif

BASE_EXT_DECL0

extern __inline BOOL 
ActivateGadget (BASE_PAR_DECL struct Gadget *gadgets,struct Window *window,struct Requester *requester)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadgets;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  __asm __volatile ("jsr a6@(-0x1ce)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline void 
ActivateWindow (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x1c2)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddClass (BASE_PAR_DECL struct IClass *classPtr)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct IClass *a0 __asm("a0") = classPtr;
  __asm __volatile ("jsr a6@(-0x2ac)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline UWORD 
AddGList (BASE_PAR_DECL struct Window *window,struct Gadget *gadget,unsigned long position,long numGad,struct Requester *requester)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct Gadget *a1 __asm("a1") = gadget;
  register unsigned long d0 __asm("d0") = position;
  register long d1 __asm("d1") = numGad;
  register struct Requester *a2 __asm("a2") = requester;
  __asm __volatile ("jsr a6@(-0x1b6)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline UWORD 
AddGadget (BASE_PAR_DECL struct Window *window,struct Gadget *gadget,unsigned long position)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct Gadget *a1 __asm("a1") = gadget;
  register unsigned long d0 __asm("d0") = position;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
AllocRemember (BASE_PAR_DECL struct Remember **rememberKey,unsigned long size,unsigned long flags)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Remember **a0 __asm("a0") = rememberKey;
  register unsigned long d0 __asm("d0") = size;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x18c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct ScreenBuffer *
AllocScreenBuffer (BASE_PAR_DECL struct Screen *sc,struct BitMap *bm,unsigned long flags)
{
  BASE_EXT_DECL
  register struct ScreenBuffer * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = sc;
  register struct BitMap *a1 __asm("a1") = bm;
  register unsigned long d0 __asm("d0") = flags;
  __asm __volatile ("jsr a6@(-0x300)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
AlohaWorkbench (BASE_PAR_DECL long wbport)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = wbport;
  __asm __volatile ("jsr a6@(-0x192)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
AutoRequest (BASE_PAR_DECL struct Window *window,struct IntuiText *body,struct IntuiText *posText,struct IntuiText *negText,unsigned long pFlag,unsigned long nFlag,unsigned long width,unsigned long height)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct IntuiText *a1 __asm("a1") = body;
  register struct IntuiText *a2 __asm("a2") = posText;
  register struct IntuiText *a3 __asm("a3") = negText;
  register unsigned long d0 __asm("d0") = pFlag;
  register unsigned long d1 __asm("d1") = nFlag;
  register unsigned long d2 __asm("d2") = width;
  register unsigned long d3 __asm("d3") = height;
  __asm __volatile ("jsr a6@(-0x15c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","a2","a3","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline void 
BeginRefresh (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x162)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Window *
BuildEasyRequestArgs (BASE_PAR_DECL struct Window *window,struct EasyStruct *easyStruct,unsigned long idcmp,APTR args)
{
  BASE_EXT_DECL
  register struct Window * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct EasyStruct *a1 __asm("a1") = easyStruct;
  register unsigned long d0 __asm("d0") = idcmp;
  register APTR a3 __asm("a3") = args;
  __asm __volatile ("jsr a6@(-0x252)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (a3)
  : "a0","a1","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define BuildEasyRequest(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; BuildEasyRequestArgs ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct Window *
BuildSysRequest (BASE_PAR_DECL struct Window *window,struct IntuiText *body,struct IntuiText *posText,struct IntuiText *negText,unsigned long flags,unsigned long width,unsigned long height)
{
  BASE_EXT_DECL
  register struct Window * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct IntuiText *a1 __asm("a1") = body;
  register struct IntuiText *a2 __asm("a2") = posText;
  register struct IntuiText *a3 __asm("a3") = negText;
  register unsigned long d0 __asm("d0") = flags;
  register unsigned long d1 __asm("d1") = width;
  register unsigned long d2 __asm("d2") = height;
  __asm __volatile ("jsr a6@(-0x168)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","a2","a3","d0","d1","d2", "memory");
  return _res;
}
extern __inline ULONG 
ChangeScreenBuffer (BASE_PAR_DECL struct Screen *sc,struct ScreenBuffer *sb)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = sc;
  register struct ScreenBuffer *a1 __asm("a1") = sb;
  __asm __volatile ("jsr a6@(-0x30c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ChangeWindowBox (BASE_PAR_DECL struct Window *window,long left,long top,long width,long height)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register long d0 __asm("d0") = left;
  register long d1 __asm("d1") = top;
  register long d2 __asm("d2") = width;
  register long d3 __asm("d3") = height;
  __asm __volatile ("jsr a6@(-0x1e6)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline BOOL 
ClearDMRequest (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ClearMenuStrip (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ClearPointer (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x3c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
CloseScreen (BASE_PAR_DECL struct Screen *screen)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
CloseWindow (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x48)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
CloseWorkBench (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
CurrentTime (BASE_PAR_DECL ULONG *seconds,ULONG *micros)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register ULONG *a0 __asm("a0") = seconds;
  register ULONG *a1 __asm("a1") = micros;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
DisplayAlert (BASE_PAR_DECL unsigned long alertNumber,UBYTE *string,unsigned long height)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = alertNumber;
  register UBYTE *a0 __asm("a0") = string;
  register unsigned long d1 __asm("d1") = height;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
DisplayBeep (BASE_PAR_DECL struct Screen *screen)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  __asm __volatile ("jsr a6@(-0x60)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DisposeObject (BASE_PAR_DECL APTR object)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = object;
  __asm __volatile ("jsr a6@(-0x282)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
DoGadgetMethodA (BASE_PAR_DECL struct Gadget *gad,struct Window *win,struct Requester *req,Msg message)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gad;
  register struct Window *a1 __asm("a1") = win;
  register struct Requester *a2 __asm("a2") = req;
  register Msg a3 __asm("a3") = message;
  __asm __volatile ("jsr a6@(-0x32a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define DoGadgetMethod(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; DoGadgetMethodA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline BOOL 
DoubleClick (BASE_PAR_DECL unsigned long sSeconds,unsigned long sMicros,unsigned long cSeconds,unsigned long cMicros)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = sSeconds;
  register unsigned long d1 __asm("d1") = sMicros;
  register unsigned long d2 __asm("d2") = cSeconds;
  register unsigned long d3 __asm("d3") = cMicros;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline void 
DrawBorder (BASE_PAR_DECL struct RastPort *rp,struct Border *border,long leftOffset,long topOffset)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct Border *a1 __asm("a1") = border;
  register long d0 __asm("d0") = leftOffset;
  register long d1 __asm("d1") = topOffset;
  __asm __volatile ("jsr a6@(-0x6c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DrawImage (BASE_PAR_DECL struct RastPort *rp,struct Image *image,long leftOffset,long topOffset)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct Image *a1 __asm("a1") = image;
  register long d0 __asm("d0") = leftOffset;
  register long d1 __asm("d1") = topOffset;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DrawImageState (BASE_PAR_DECL struct RastPort *rp,struct Image *image,long leftOffset,long topOffset,unsigned long state,struct DrawInfo *drawInfo)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct Image *a1 __asm("a1") = image;
  register long d0 __asm("d0") = leftOffset;
  register long d1 __asm("d1") = topOffset;
  register unsigned long d2 __asm("d2") = state;
  register struct DrawInfo *a2 __asm("a2") = drawInfo;
  __asm __volatile ("jsr a6@(-0x26a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (a2)
  : "a0","a1","a2","d0","d1","d2", "memory");
}
extern __inline LONG 
EasyRequestArgs (BASE_PAR_DECL struct Window *window,struct EasyStruct *easyStruct,ULONG *idcmpPtr,APTR args)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct EasyStruct *a1 __asm("a1") = easyStruct;
  register ULONG *a2 __asm("a2") = idcmpPtr;
  register APTR a3 __asm("a3") = args;
  __asm __volatile ("jsr a6@(-0x24c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define EasyRequest(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; EasyRequestArgs ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
EndRefresh (BASE_PAR_DECL struct Window *window,long complete)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register long d0 __asm("d0") = complete;
  __asm __volatile ("jsr a6@(-0x16e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
EndRequest (BASE_PAR_DECL struct Requester *requester,struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Requester *a0 __asm("a0") = requester;
  register struct Window *a1 __asm("a1") = window;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
EraseImage (BASE_PAR_DECL struct RastPort *rp,struct Image *image,long leftOffset,long topOffset)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct Image *a1 __asm("a1") = image;
  register long d0 __asm("d0") = leftOffset;
  register long d1 __asm("d1") = topOffset;
  __asm __volatile ("jsr a6@(-0x276)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
FreeClass (BASE_PAR_DECL struct IClass *classPtr)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct IClass *a0 __asm("a0") = classPtr;
  __asm __volatile ("jsr a6@(-0x2ca)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
FreeRemember (BASE_PAR_DECL struct Remember **rememberKey,long reallyForget)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Remember **a0 __asm("a0") = rememberKey;
  register long d0 __asm("d0") = reallyForget;
  __asm __volatile ("jsr a6@(-0x198)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeScreenBuffer (BASE_PAR_DECL struct Screen *sc,struct ScreenBuffer *sb)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = sc;
  register struct ScreenBuffer *a1 __asm("a1") = sb;
  __asm __volatile ("jsr a6@(-0x306)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeScreenDrawInfo (BASE_PAR_DECL struct Screen *screen,struct DrawInfo *drawInfo)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register struct DrawInfo *a1 __asm("a1") = drawInfo;
  __asm __volatile ("jsr a6@(-0x2b8)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeSysRequest (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x174)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GadgetMouse (BASE_PAR_DECL struct Gadget *gadget,struct GadgetInfo *gInfo,WORD *mousePoint)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadget;
  register struct GadgetInfo *a1 __asm("a1") = gInfo;
  register WORD *a2 __asm("a2") = mousePoint;
  __asm __volatile ("jsr a6@(-0x23a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline ULONG 
GetAttr (BASE_PAR_DECL unsigned long attrID,APTR object,ULONG *storagePtr)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = attrID;
  register APTR a0 __asm("a0") = object;
  register ULONG *a1 __asm("a1") = storagePtr;
  __asm __volatile ("jsr a6@(-0x28e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Preferences *
GetDefPrefs (BASE_PAR_DECL struct Preferences *preferences,long size)
{
  BASE_EXT_DECL
  register struct Preferences * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Preferences *a0 __asm("a0") = preferences;
  register long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
GetDefaultPubScreen (BASE_PAR_DECL UBYTE *nameBuffer)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = nameBuffer;
  __asm __volatile ("jsr a6@(-0x246)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Preferences *
GetPrefs (BASE_PAR_DECL struct Preferences *preferences,long size)
{
  BASE_EXT_DECL
  register struct Preferences * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Preferences *a0 __asm("a0") = preferences;
  register long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
GetScreenData (BASE_PAR_DECL APTR buffer,unsigned long size,unsigned long type,struct Screen *screen)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = buffer;
  register unsigned long d0 __asm("d0") = size;
  register unsigned long d1 __asm("d1") = type;
  register struct Screen *a1 __asm("a1") = screen;
  __asm __volatile ("jsr a6@(-0x1aa)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct DrawInfo *
GetScreenDrawInfo (BASE_PAR_DECL struct Screen *screen)
{
  BASE_EXT_DECL
  register struct DrawInfo * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  __asm __volatile ("jsr a6@(-0x2b2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
HelpControl (BASE_PAR_DECL struct Window *win,unsigned long flags)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = win;
  register unsigned long d0 __asm("d0") = flags;
  __asm __volatile ("jsr a6@(-0x33c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
InitRequester (BASE_PAR_DECL struct Requester *requester)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Requester *a0 __asm("a0") = requester;
  __asm __volatile ("jsr a6@(-0x8a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
IntuiTextLength (BASE_PAR_DECL struct IntuiText *iText)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct IntuiText *a0 __asm("a0") = iText;
  __asm __volatile ("jsr a6@(-0x14a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Intuition (BASE_PAR_DECL struct InputEvent *iEvent)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct InputEvent *a0 __asm("a0") = iEvent;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct MenuItem *
ItemAddress (BASE_PAR_DECL struct Menu *menuStrip,unsigned long menuNumber)
{
  BASE_EXT_DECL
  register struct MenuItem * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Menu *a0 __asm("a0") = menuStrip;
  register unsigned long d0 __asm("d0") = menuNumber;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
LendMenus (BASE_PAR_DECL struct Window *fromwindow,struct Window *towindow)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = fromwindow;
  register struct Window *a1 __asm("a1") = towindow;
  __asm __volatile ("jsr a6@(-0x324)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
LockIBase (BASE_PAR_DECL unsigned long dontknow)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = dontknow;
  __asm __volatile ("jsr a6@(-0x19e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Screen *
LockPubScreen (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct Screen * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x1fe)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct List *
LockPubScreenList (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct List * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x20a)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct IClass *
MakeClass (BASE_PAR_DECL UBYTE *classID,UBYTE *superClassID,struct IClass *superClassPtr,unsigned long instanceSize,unsigned long flags)
{
  BASE_EXT_DECL
  register struct IClass * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = classID;
  register UBYTE *a1 __asm("a1") = superClassID;
  register struct IClass *a2 __asm("a2") = superClassPtr;
  register unsigned long d0 __asm("d0") = instanceSize;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x2a6)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
MakeScreen (BASE_PAR_DECL struct Screen *screen)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  __asm __volatile ("jsr a6@(-0x17a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
ModifyIDCMP (BASE_PAR_DECL struct Window *window,unsigned long flags)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register unsigned long d0 __asm("d0") = flags;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ModifyProp (BASE_PAR_DECL struct Gadget *gadget,struct Window *window,struct Requester *requester,unsigned long flags,unsigned long horizPot,unsigned long vertPot,unsigned long horizBody,unsigned long vertBody)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadget;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  register unsigned long d0 __asm("d0") = flags;
  register unsigned long d1 __asm("d1") = horizPot;
  register unsigned long d2 __asm("d2") = vertPot;
  register unsigned long d3 __asm("d3") = horizBody;
  register unsigned long d4 __asm("d4") = vertBody;
  __asm __volatile ("jsr a6@(-0x9c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","a2","d0","d1","d2","d3","d4", "memory");
}
extern __inline void 
MoveScreen (BASE_PAR_DECL struct Screen *screen,long dx,long dy)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  __asm __volatile ("jsr a6@(-0xa2)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
MoveWindow (BASE_PAR_DECL struct Window *window,long dx,long dy)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  __asm __volatile ("jsr a6@(-0xa8)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
MoveWindowInFrontOf (BASE_PAR_DECL struct Window *window,struct Window *behindWindow)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct Window *a1 __asm("a1") = behindWindow;
  __asm __volatile ("jsr a6@(-0x1e0)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
NewModifyProp (BASE_PAR_DECL struct Gadget *gadget,struct Window *window,struct Requester *requester,unsigned long flags,unsigned long horizPot,unsigned long vertPot,unsigned long horizBody,unsigned long vertBody,long numGad)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadget;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  register unsigned long d0 __asm("d0") = flags;
  register unsigned long d1 __asm("d1") = horizPot;
  register unsigned long d2 __asm("d2") = vertPot;
  register unsigned long d3 __asm("d3") = horizBody;
  register unsigned long d4 __asm("d4") = vertBody;
  register long d5 __asm("d5") = numGad;
  __asm __volatile ("jsr a6@(-0x1d4)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","a2","d0","d1","d2","d3","d4","d5", "memory");
}
extern __inline APTR 
NewObjectA (BASE_PAR_DECL struct IClass *classPtr,UBYTE *classID,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct IClass *a0 __asm("a0") = classPtr;
  register UBYTE *a1 __asm("a1") = classID;
  register struct TagItem *a2 __asm("a2") = tagList;
  __asm __volatile ("jsr a6@(-0x27c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define NewObject(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; NewObjectA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline APTR 
NextObject (BASE_PAR_DECL APTR objectPtrPtr)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = objectPtrPtr;
  __asm __volatile ("jsr a6@(-0x29a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UBYTE *
NextPubScreen (BASE_PAR_DECL struct Screen *screen,UBYTE *namebuf)
{
  BASE_EXT_DECL
  register UBYTE * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register UBYTE *a1 __asm("a1") = namebuf;
  __asm __volatile ("jsr a6@(-0x216)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct RastPort *
ObtainGIRPort (BASE_PAR_DECL struct GadgetInfo *gInfo)
{
  BASE_EXT_DECL
  register struct RastPort * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct GadgetInfo *a0 __asm("a0") = gInfo;
  __asm __volatile ("jsr a6@(-0x22e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
OffGadget (BASE_PAR_DECL struct Gadget *gadget,struct Window *window,struct Requester *requester)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadget;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  __asm __volatile ("jsr a6@(-0xae)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
OffMenu (BASE_PAR_DECL struct Window *window,unsigned long menuNumber)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register unsigned long d0 __asm("d0") = menuNumber;
  __asm __volatile ("jsr a6@(-0xb4)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
OnGadget (BASE_PAR_DECL struct Gadget *gadget,struct Window *window,struct Requester *requester)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadget;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  __asm __volatile ("jsr a6@(-0xba)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
OnMenu (BASE_PAR_DECL struct Window *window,unsigned long menuNumber)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register unsigned long d0 __asm("d0") = menuNumber;
  __asm __volatile ("jsr a6@(-0xc0)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
OpenIntuition (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1e)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Screen *
OpenScreen (BASE_PAR_DECL struct NewScreen *newScreen)
{
  BASE_EXT_DECL
  register struct Screen * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct NewScreen *a0 __asm("a0") = newScreen;
  __asm __volatile ("jsr a6@(-0xc6)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Screen *
OpenScreenTagList (BASE_PAR_DECL struct NewScreen *newScreen,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct Screen * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct NewScreen *a0 __asm("a0") = newScreen;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x264)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define OpenScreenTags(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; OpenScreenTagList ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct Window *
OpenWindow (BASE_PAR_DECL struct NewWindow *newWindow)
{
  BASE_EXT_DECL
  register struct Window * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct NewWindow *a0 __asm("a0") = newWindow;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Window *
OpenWindowTagList (BASE_PAR_DECL struct NewWindow *newWindow,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct Window * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct NewWindow *a0 __asm("a0") = newWindow;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x25e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define OpenWindowTags(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; OpenWindowTagList ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
OpenWorkBench (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
PointInImage (BASE_PAR_DECL unsigned long point,struct Image *image)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = point;
  register struct Image *a0 __asm("a0") = image;
  __asm __volatile ("jsr a6@(-0x270)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
PrintIText (BASE_PAR_DECL struct RastPort *rp,struct IntuiText *iText,long left,long top)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct IntuiText *a1 __asm("a1") = iText;
  register long d0 __asm("d0") = left;
  register long d1 __asm("d1") = top;
  __asm __volatile ("jsr a6@(-0xd8)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline UWORD 
PubScreenStatus (BASE_PAR_DECL struct Screen *screen,unsigned long statusFlags)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register unsigned long d0 __asm("d0") = statusFlags;
  __asm __volatile ("jsr a6@(-0x228)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
QueryOverscan (BASE_PAR_DECL unsigned long displayID,struct Rectangle *rect,long oScanType)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long a0 __asm("a0") = displayID;
  register struct Rectangle *a1 __asm("a1") = rect;
  register long d0 __asm("d0") = oScanType;
  __asm __volatile ("jsr a6@(-0x1da)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
RefreshGList (BASE_PAR_DECL struct Gadget *gadgets,struct Window *window,struct Requester *requester,long numGad)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadgets;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  register long d0 __asm("d0") = numGad;
  __asm __volatile ("jsr a6@(-0x1b0)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
RefreshGadgets (BASE_PAR_DECL struct Gadget *gadgets,struct Window *window,struct Requester *requester)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadgets;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  __asm __volatile ("jsr a6@(-0xde)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
RefreshWindowFrame (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x1c8)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ReleaseGIRPort (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  __asm __volatile ("jsr a6@(-0x234)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
RemakeDisplay (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x180)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
RemoveClass (BASE_PAR_DECL struct IClass *classPtr)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct IClass *a0 __asm("a0") = classPtr;
  __asm __volatile ("jsr a6@(-0x2c4)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline UWORD 
RemoveGList (BASE_PAR_DECL struct Window *remPtr,struct Gadget *gadget,long numGad)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = remPtr;
  register struct Gadget *a1 __asm("a1") = gadget;
  register long d0 __asm("d0") = numGad;
  __asm __volatile ("jsr a6@(-0x1bc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UWORD 
RemoveGadget (BASE_PAR_DECL struct Window *window,struct Gadget *gadget)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct Gadget *a1 __asm("a1") = gadget;
  __asm __volatile ("jsr a6@(-0xe4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ReportMouse (BASE_PAR_DECL long flag,struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = flag;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0xea)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
Request (BASE_PAR_DECL struct Requester *requester,struct Window *window)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Requester *a0 __asm("a0") = requester;
  register struct Window *a1 __asm("a1") = window;
  __asm __volatile ("jsr a6@(-0xf0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
ResetMenuStrip (BASE_PAR_DECL struct Window *window,struct Menu *menu)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct Menu *a1 __asm("a1") = menu;
  __asm __volatile ("jsr a6@(-0x2be)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
RethinkDisplay (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x186)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ScreenDepth (BASE_PAR_DECL struct Screen *screen,unsigned long flags,APTR reserved)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register unsigned long d0 __asm("d0") = flags;
  register APTR a1 __asm("a1") = reserved;
  __asm __volatile ("jsr a6@(-0x312)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ScreenPosition (BASE_PAR_DECL struct Screen *screen,unsigned long flags,long x1,long y1,long x2,long y2)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register unsigned long d0 __asm("d0") = flags;
  register long d1 __asm("d1") = x1;
  register long d2 __asm("d2") = y1;
  register long d3 __asm("d3") = x2;
  register long d4 __asm("d4") = y2;
  __asm __volatile ("jsr a6@(-0x318)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4", "memory");
}
extern __inline void 
ScreenToBack (BASE_PAR_DECL struct Screen *screen)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  __asm __volatile ("jsr a6@(-0xf6)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ScreenToFront (BASE_PAR_DECL struct Screen *screen)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  __asm __volatile ("jsr a6@(-0xfc)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ScrollWindowRaster (BASE_PAR_DECL struct Window *win,long dx,long dy,long xMin,long yMin,long xMax,long yMax)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a1 __asm("a1") = win;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  register long d2 __asm("d2") = xMin;
  register long d3 __asm("d3") = yMin;
  register long d4 __asm("d4") = xMax;
  register long d5 __asm("d5") = yMax;
  __asm __volatile ("jsr a6@(-0x31e)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","d2","d3","d4","d5", "memory");
}
extern __inline ULONG 
SetAttrsA (BASE_PAR_DECL APTR object,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = object;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x288)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline BOOL 
SetDMRequest (BASE_PAR_DECL struct Window *window,struct Requester *requester)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct Requester *a1 __asm("a1") = requester;
  __asm __volatile ("jsr a6@(-0x102)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetDefaultPubScreen (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x21c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Hook *
SetEditHook (BASE_PAR_DECL struct Hook *hook)
{
  BASE_EXT_DECL
  register struct Hook * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Hook *a0 __asm("a0") = hook;
  __asm __volatile ("jsr a6@(-0x1ec)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
SetGadgetAttrsA (BASE_PAR_DECL struct Gadget *gadget,struct Window *window,struct Requester *requester,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Gadget *a0 __asm("a0") = gadget;
  register struct Window *a1 __asm("a1") = window;
  register struct Requester *a2 __asm("a2") = requester;
  register struct TagItem *a3 __asm("a3") = tagList;
  __asm __volatile ("jsr a6@(-0x294)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetGadgetAttrs(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetGadgetAttrsA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline BOOL 
SetMenuStrip (BASE_PAR_DECL struct Window *window,struct Menu *menu)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register struct Menu *a1 __asm("a1") = menu;
  __asm __volatile ("jsr a6@(-0x108)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
SetMouseQueue (BASE_PAR_DECL struct Window *window,unsigned long queueLength)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register unsigned long d0 __asm("d0") = queueLength;
  __asm __volatile ("jsr a6@(-0x1f2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetPointer (BASE_PAR_DECL struct Window *window,UWORD *pointer,long height,long width,long xOffset,long yOffset)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register UWORD *a1 __asm("a1") = pointer;
  register long d0 __asm("d0") = height;
  register long d1 __asm("d1") = width;
  register long d2 __asm("d2") = xOffset;
  register long d3 __asm("d3") = yOffset;
  __asm __volatile ("jsr a6@(-0x10e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline struct Preferences *
SetPrefs (BASE_PAR_DECL struct Preferences *preferences,long size,long inform)
{
  BASE_EXT_DECL
  register struct Preferences * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Preferences *a0 __asm("a0") = preferences;
  register long d0 __asm("d0") = size;
  register long d1 __asm("d1") = inform;
  __asm __volatile ("jsr a6@(-0x144)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UWORD 
SetPubScreenModes (BASE_PAR_DECL unsigned long modes)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = modes;
  __asm __volatile ("jsr a6@(-0x222)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetWindowPointerA (BASE_PAR_DECL struct Window *win,struct TagItem *taglist)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = win;
  register struct TagItem *a1 __asm("a1") = taglist;
  __asm __volatile ("jsr a6@(-0x330)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
#ifndef NO_INLINE_STDARG
#define SetWindowPointer(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetWindowPointerA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
SetWindowTitles (BASE_PAR_DECL struct Window *window,UBYTE *windowTitle,UBYTE *screenTitle)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register UBYTE *a1 __asm("a1") = windowTitle;
  register UBYTE *a2 __asm("a2") = screenTitle;
  __asm __volatile ("jsr a6@(-0x114)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
ShowTitle (BASE_PAR_DECL struct Screen *screen,long showIt)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Screen *a0 __asm("a0") = screen;
  register long d0 __asm("d0") = showIt;
  __asm __volatile ("jsr a6@(-0x11a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SizeWindow (BASE_PAR_DECL struct Window *window,long dx,long dy)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  __asm __volatile ("jsr a6@(-0x120)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
SysReqHandler (BASE_PAR_DECL struct Window *window,ULONG *idcmpPtr,long waitInput)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register ULONG *a1 __asm("a1") = idcmpPtr;
  register long d0 __asm("d0") = waitInput;
  __asm __volatile ("jsr a6@(-0x258)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
TimedDisplayAlert (BASE_PAR_DECL unsigned long alertNumber,UBYTE *string,unsigned long height,unsigned long time)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = alertNumber;
  register UBYTE *a0 __asm("a0") = string;
  register unsigned long d1 __asm("d1") = height;
  register unsigned long a1 __asm("a1") = time;
  __asm __volatile ("jsr a6@(-0x336)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (d1), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
UnlockIBase (BASE_PAR_DECL unsigned long ibLock)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long a0 __asm("a0") = ibLock;
  __asm __volatile ("jsr a6@(-0x1a4)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
UnlockPubScreen (BASE_PAR_DECL UBYTE *name,struct Screen *screen)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  register struct Screen *a1 __asm("a1") = screen;
  __asm __volatile ("jsr a6@(-0x204)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
UnlockPubScreenList (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x210)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct View *
ViewAddress (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct View * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x126)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct ViewPort *
ViewPortAddress (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct ViewPort * _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x12c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
WBenchToBack (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x150)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
WBenchToFront (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x156)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
WindowLimits (BASE_PAR_DECL struct Window *window,long widthMin,long heightMin,unsigned long widthMax,unsigned long heightMax)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  register long d0 __asm("d0") = widthMin;
  register long d1 __asm("d1") = heightMin;
  register unsigned long d2 __asm("d2") = widthMax;
  register unsigned long d3 __asm("d3") = heightMax;
  __asm __volatile ("jsr a6@(-0x13e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline void 
WindowToBack (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x132)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
WindowToFront (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x138)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ZipWindow (BASE_PAR_DECL struct Window *window)
{
  BASE_EXT_DECL
  register struct IntuitionBase *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = window;
  __asm __volatile ("jsr a6@(-0x1f8)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_INTUITION_H */
