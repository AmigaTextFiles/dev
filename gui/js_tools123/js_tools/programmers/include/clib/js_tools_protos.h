#ifndef JS_PROTOS_H
#define JS_PROTOS_H

#include <js_tools/js_tools.h>

STRPTR __saveds __asm JS_LibInfo(register __d1 ULONG type);

/* ListViews */

void __saveds __asm LV_RefreshWindow(register __a0 struct Window *win,register __a1 struct Requester *req);
struct Gadget __saveds __asm *LV_CreateListViewA(register __d0 LONG kind,
		                                             register __a0 struct Gadget *prev,
        		                                     register __a1 struct NewGadget *ngg,
                		                             register __a2 struct TagItem *tl);

void __saveds __asm LV_FreeListView(register __a0 struct Gadget *gg);
void __saveds __asm LV_FreeListViews(register __a0 struct Gadget *gg);

void __saveds __asm LV_SetListViewAttrsA(register __a0 struct Gadget *gg,register __a1 struct Window *win,register __a2 struct Requester *req,register __a3 struct TagItem *tl);
struct IntuiMessage __saveds __asm *LV_GetIMsg(register __a0 struct MsgPort *mp);
void __saveds __asm LV_ReplyIMsg(register __a1 struct IntuiMessage *im);

ULONG __saveds __asm LV_AskListViewAttrs(register __a0 struct Gadget *gg,register __a1 struct Window *win,register __d0 Tag tag,register __d1 ULONG data);
LONG __saveds __asm LV_GetListViewAttrsA(register __a0 struct Gadget *gg,register __a1 struct Window *win,register __a2 struct Requester *req,register __a3 struct TagItem *tl);

struct Gadget __saveds __asm *LV_CreateExtraListViewA(register __a0 struct lvExtraWindow *ex,register __a1 struct TagItem *tl);

/* Extras */

void __saveds __asm JS_Sort(register __a0 struct List *ls,register __d0 LONG number);

WORD __saveds __asm LV_KeyHandler(register __a0 struct Gadget *gg,
								  register __a1 struct IntuiMessage *im,
								  register __d0 char key,
								  register __a2 struct TagItem *tl);
#endif
