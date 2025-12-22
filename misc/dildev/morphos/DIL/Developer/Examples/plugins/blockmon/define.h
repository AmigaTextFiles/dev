/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef DEFINE_H
#define DEFINE_H 1

//------------------------------------------------------------------------------

#define PI 				((DOUBLE)3.14159265358979323846)

#define DEG_360 		360l
#define DEG_180 		180l

//------------------------------------------------------------------------------
//bit and flag

#define   setb(v,b)  ((v) |=  (1ul << (b)))
#define   clrb(v,b)  ((v) &= ~(1ul << (b)))
#define issetb(v,b) (((v) &   (1ul << (b))) != 0)
#define isclrb(v,b) (((v) &   (1ul << (b))) == 0)

#define   setf(v,f)  ((v) |=  (f))
#define   clrf(v,f)  ((v) &= ~(f))
#define issetf(v,f) (((v) &   (f)) != 0)
#define isclrf(v,f) (((v) &   (f)) == 0)

#define min(x,y) ((x) < (y) ? (x) : (y))
#define max(x,y) ((x) > (y) ? (x) : (y))

//------------------------------------------------------------------------------
//list macors

#ifdef IsListEmpty
#undef IsListEmpty
#endif
#define IsListEmpty(list) \
	((((struct List *)(list))->lh_TailPred) == (struct Node *)(list))

#define GetHead(list) \
({ struct List *l = (struct List *)(list); \
	l->lh_Head->ln_Succ ? l->lh_Head : (struct Node *)NULL; \
})

#define GetTail(list) \
({ struct List *l = (struct List *)(list); \
	l->lh_TailPred->ln_Pred ? l->lh_TailPred : (struct Node *)NULL; \
})

#define GetSucc(node) \
({ struct Node *n = (struct Node *)(node);  \
	n->ln_Succ->ln_Succ ? n->ln_Succ : (struct Node *)NULL;  \
})

#define GetPred(node) \
({ struct Node *n = (struct Node *)(node); \
	n->ln_Pred->ln_Pred ? n->ln_Pred : (struct Node *)NULL; \
})

#define ForeachNode(l,n) \
	for (n = (void *)(((struct List *)(l))->lh_Head); \
	((struct Node *)(n))->ln_Succ; \
	n = (void *)(((struct Node *)(n))->ln_Succ))

#define ForeachNodeSafe(l,n,n2)  \
	for (n = (void *)(((struct List *)(l))->lh_Head); \
		(n2 = (void *)((struct Node *)(n))->ln_Succ); \
		n = (void *)n2)

#define SetNodeName(node,name) \
	(((struct Node *)(node))->ln_Name = (char *)(name))

#define GetNodeName(node) \
	(((struct Node *)(node))->ln_Name)

#define _NewList(list) \
	NewList((struct List *)(list))

#define _AddHead(list, node) \
	AddHead((struct List *)(list), (struct Node *)(node))

#define _AddTail(list, node) \
	AddTail((struct List *)(list), (struct Node *)(node))

#define _RemHead(list) \
	RemHead((struct List *)(list))

#define _RemTail(list) \
	RemTail((struct List *)(list))

#define _Remove(node) \
	Remove((struct Node *)(node))

#define _Insert(list, node1, node2) \
	Insert((struct List *)(list), (struct Node *)(node1), (struct Node *)(node2))

//------------------------------------------------------------------------------
//memory macors

#define memclr(mem, size) \
	memset((mem), 0, (size))

//------------------------------------------------------------------------------
//MUI stuff

#ifndef MUIM_Group_ExitChange2
#define MUIM_Group_ExitChange2 0x8042e541
#endif

#ifndef MUIA_FrameDynamic
#define MUIA_FrameDynamic 0x804223c9
#endif

#ifndef MUIA_FrameVisible
#define MUIA_FrameVisible 0x80426498
#endif

#ifndef MUIA_Window_ShowIconify
#define MUIA_Window_ShowIconify 0x8042bc26
#endif

#ifndef MUIA_Window_ShowAbout
#define MUIA_Window_ShowAbout 0x80429c1e
#endif

#ifndef MUIA_Window_ShowPrefs
#define MUIA_Window_ShowPrefs 0x8042e262
#endif

#ifndef MUIA_Window_ShowJump
#define MUIA_Window_ShowJump 0x80422f40
#endif

#ifndef MUIA_Window_ShowSnapshot
#define MUIA_Window_ShowSnapshot 0x80423c55
#endif

#ifndef MUIA_Window_ShowPopup
#define MUIA_Window_ShowPopup 0x8042324e
#endif

#define _Button(text, cc) \
	TextObject, ButtonFrame,\
		MUIA_CycleChain, TRUE,\
      MUIA_Background, MUII_ButtonBack,\
		MUIA_Font, MUIV_Font_Button,\
		MUIA_Text_Contents, text,\
		MUIA_Text_PreParse, "\33c",\
		MUIA_Text_HiChar, cc,\
		MUIA_ControlChar, cc,\
		MUIA_InputMode, MUIV_InputMode_RelVerify,\
	End

//------------------------------------------------------------------------------

#define _AboutObject NewObject(control->c_MCC[MCC_About]->mcc_Class, NULL
#define _ApplicationObject NewObject(control->c_MCC[MCC_Application]->mcc_Class, NULL
#define _DisplayObject NewObject(control->c_MCC[MCC_Display]->mcc_Class, NULL
#define _MainObject NewObject(control->c_MCC[MCC_Main]->mcc_Class, NULL
#define _NListObject NewObject(control->c_MCC[MCC_NList]->mcc_Class, NULL

//------------------------------------------------------------------------------

#define _between(a,x,b) \
	((x) >= (a) && (x) <= (b))

#define _isinobject(x,y) \
	(_between(_mleft(obj), (x), _mright(obj)) && \
	 _between(_mtop(obj), (y), _mbottom(obj)))

#define _mcenterx(obj) \
	((LONG)(_mleft(obj) + _mwidth(obj) / 2))

#define _mcentery(obj) \
	((LONG)(_mtop(obj) + _mheight(obj) / 2))

#define disAPP set(_app(obj), MUIA_Application_Sleep, TRUE)
#define enAPP set(_app(obj), MUIA_Application_Sleep, FALSE)

#ifdef MAKE_ID
#undef MAKE_ID
#endif
#define MAKE_ID(a,b,c,d) ((ULONG)(a)<<24 | (ULONG)(b)<<16 | (ULONG)(c)<<8 | (ULONG)(d))

//------------------------------------------------------------------------------

#include <emul/emulinterface.h>
#include <emul/emulregs.h>

#define MCC_DISPATCHER(Name) \
	ULONG Name##_Dispatcher(void); \
	struct EmulLibEntry GATE##Name##_Dispatcher = { TRAP_LIB, 0, (void (*)(void)) Name##_Dispatcher }; \
	ULONG Name##_Dispatcher(void) { struct IClass *cl=(struct IClass*)REG_A0; Msg msg=(Msg)REG_A1; Object *obj=(Object*)REG_A2;

#define MCC_DISPATCHER_END }

#define MCC_DISPATCHER_REF(Name) \
	&GATE##Name##_Dispatcher

#define MCC_DISPATCHER_EXTERN(Name) \
	extern ULONG Name##_Dispatcher(void); \
	extern struct EmulLibEntry GATE##Name##_Dispatcher

#define HOOK(hookname, funcname) struct Hook hookname = {{NULL, NULL}, \
	(HOOKFUNC)HookEntry, (HOOKFUNC)funcname, NULL}

#define STATIC_HOOK(hookname, funcname) static struct Hook hookname = \
	{{NULL, NULL}, (HOOKFUNC)HookEntry, (HOOKFUNC)funcname, NULL}

//------------------------------------------------------------------------------

#endif /* DEFINE_H */

































