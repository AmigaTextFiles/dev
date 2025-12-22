/* GadTools Drag&Drop - Includes & Defines, 28.6.99
**
** Copyright ©1999 pinc Software. All Rights Reserved.
*/


#ifndef GTDRAG_INCLUDES_H
#define GTDRAG_INCLUDES_H

#define INTUI_V36_NAMES_ONLY

#include <exec/execbase.h>
#include <exec/libraries.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/ports.h>
#include <exec/memory.h>

/* .... */

#define reg(x) register __ ## x

/* .... */

/********************* public functions *********************/

// GTD_Apps.c
extern int PUBLIC GTD_AddAppA(reg (a0) STRPTR t,reg (a1) struct TagItem *tag);
extern void PUBLIC GTD_RemoveApp(void);

// GTD_Gadgets.c
extern BOOL PUBLIC GTD_GetAttr(reg (a0) APTR gad,reg (d0) ULONG tag,reg (a1) ULONG *storage);
extern void PUBLIC GTD_SetAttrsA(reg (a0) APTR gad,reg (a1) struct TagItem *tags);
extern void PUBLIC GTD_AddGadgetA(reg (d0) ULONG type,reg (a0) struct Gadget *gad,reg (a1) struct Window *win,reg (a2) struct TagItem *tag1);
extern void PUBLIC GTD_RemoveGadget(reg (a0) struct Gadget *);
extern void PUBLIC GTD_RemoveGadgets(reg (a0) struct Window *);

// GTD_Windows.c
extern void PUBLIC GTD_AddWindowA(reg (a0) struct Window *win,reg (a1) struct TagItem *tag);
extern void PUBLIC GTD_RemoveWindow(reg (a0) struct Window *win);

// GTD_Boopsi.c
extern ULONG PUBLIC GTD_HandleInput(reg (a0) struct Gadget *gad,reg (a1) struct gpInput *gpi);
extern BOOL PUBLIC GTD_PrepareDrag(reg (a0) struct Gadget *gad,reg (a1) struct gpInput *gpi);
extern BOOL PUBLIC GTD_BeginDrag(reg (a0) struct Gadget *gad,reg (a1) struct gpInput *gpi);
extern void PUBLIC GTD_StopDrag(reg (a0) struct Gadget *gad);

// GTD_DropMsgs.c
extern STRPTR PUBLIC GTD_GetString(reg (a0) struct ObjectDescription *od,reg (a1) STRPTR buf,reg (d0) LONG len);

// GTD_IMsgs.c
extern void PUBLIC GTD_ReplyIMsg(reg (a0) struct IntuiMessage *msg);
extern struct IntuiMessage * PUBLIC GTD_GetIMsg(reg (a0) struct MsgPort *mp);
extern struct IntuiMessage * PUBLIC GTD_FilterIMsg(reg (a0) struct IntuiMessage *msg);
extern struct IntuiMessage * PUBLIC GTD_PostFilterIMsg(reg (a0) struct IntuiMessage *msg);

// GTD_Hook.c
extern struct Hook * PUBLIC GTD_GetHook(reg (d0) ULONG type);

// GTD_(IFF|Image|Tree)Hook.c
extern ULONG PUBLIC IFFStreamHook(reg (a0) struct Hook *h,reg (a1) struct IFFStreamCmd *sc,reg (a2) struct IFFHandle *iff);
extern ULONG PUBLIC RenderHook(reg (a1) struct LVDrawMsg *msg,reg (a2) struct ImageNode *in);
extern ULONG PUBLIC TreeHook(reg (a0) struct Hook *h,reg (a1) struct LVDrawMsg *msg,reg (a2) struct TreeNode *tn);

// GTD_Tree.c
extern struct TreeNode * PUBLIC AddTreeNode(reg (a0) APTR pool,reg (a1) struct MinList *tree,reg (a2) STRPTR name,reg (a3) struct Image *im,reg (d0) UWORD flags);
extern void PUBLIC FreeTreeNodes(reg (a0) APTR pool,reg (a1) struct MinList *list);
extern void PUBLIC FreeTreeList(reg (a0) APTR pool,reg (a1) struct TreeList *tl);
extern void PUBLIC CloseTreeNode(reg (a0) struct MinList *main,reg (a1) struct TreeNode *tn);
extern LONG PUBLIC OpenTreeNode(reg (a0) struct MinList *main,reg (a1) struct TreeNode *tn);
extern LONG PUBLIC ToggleTreeNode(reg (a0) struct MinList *main,reg (a1) struct TreeNode *tn);
extern void PUBLIC InitTreeList(reg (a0) struct TreeList *tl);
extern struct TreeNode * PUBLIC GetTreeContainer(reg (a0) struct TreeNode *tn);
extern STRPTR PUBLIC GetTreePath(reg (a0) struct TreeNode *tn,reg (a1) STRPTR buffer,reg (d0) LONG len);
extern struct TreeNode * PUBLIC FindTreePath(reg (a0) struct MinList *tree,reg (a1) STRPTR path);
extern struct TreeNode * PUBLIC FindTreeSpecial(reg (a0) struct MinList *tree,reg (a1) APTR special);
extern struct TreeNode * PUBLIC FindListSpecial(reg (a0) struct MinList *list,reg (a1) APTR special);
extern BOOL PUBLIC ToggleTree(reg (a0) struct Gadget *gad,reg (a1) struct TreeNode *tn,reg (a2) struct IntuiMessage *msg);

#endif
