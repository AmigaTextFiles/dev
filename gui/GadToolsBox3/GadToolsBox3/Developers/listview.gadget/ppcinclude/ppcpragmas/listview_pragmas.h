/* Automatically generated header! Do not edit! */

#ifndef _PPCPRAGMA_LISTVIEW_H
#define _PPCPRAGMA_LISTVIEW_H
#ifdef __GNUC__
#ifndef _PPCINLINE__LISTVIEW_H
#include <ppcinline/listview.h>
#endif
#else

#ifndef POWERUP_PPCLIB_INTERFACE_H
#include <powerup/ppclib/interface.h>
#endif

#ifndef POWERUP_GCCLIB_PROTOS_H
#include <powerup/gcclib/powerup_protos.h>
#endif

#ifndef NO_PPCINLINE_STDARG
#define NO_PPCINLINE_STDARG
#endif/* SAS C PPC inlines */

#ifndef LISTVIEW_BASE_NAME
#define LISTVIEW_BASE_NAME ListViewBase
#endif /* !LISTVIEW_BASE_NAME */

#define	GetListViewClass()	_GetListViewClass(LISTVIEW_BASE_NAME)

static __inline Class *
_GetListViewClass(void *ListViewBase)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.caos_Un.Offset	=	(-30);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((Class *)PPCCallOS(&MyCaos));
}

#define	Tree_NewList(list)	_Tree_NewList(LISTVIEW_BASE_NAME,list)

static __inline void
_Tree_NewList(void *ListViewBase, struct LVNode *list)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.caos_Un.Offset	=	(-36);
	MyCaos.a6		=(ULONG) ListViewBase;	
	PPCCallOS(&MyCaos);
}

#define	Tree_AddTail(list,node)	_Tree_AddTail(LISTVIEW_BASE_NAME,list,node)

static __inline void
_Tree_AddTail(void *ListViewBase, struct LVNode *list, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.a1		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-42);
	MyCaos.a6		=(ULONG) ListViewBase;	
	PPCCallOS(&MyCaos);
}

#define	Tree_AddHead(list,node)	_Tree_AddHead(LISTVIEW_BASE_NAME,list,node)

static __inline void
_Tree_AddHead(void *ListViewBase, struct LVNode *list, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.a1		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-48);
	MyCaos.a6		=(ULONG) ListViewBase;	
	PPCCallOS(&MyCaos);
}

#define	Tree_AddSubTail(list,parent,node)	_Tree_AddSubTail(LISTVIEW_BASE_NAME,list,parent,node)

static __inline void
_Tree_AddSubTail(void *ListViewBase, struct LVNode *list, struct LVNode *parent, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.a1		=(ULONG) parent;
	MyCaos.a2		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-54);
	MyCaos.a6		=(ULONG) ListViewBase;	
	PPCCallOS(&MyCaos);
}

#define	Tree_NextNode(node)	_Tree_NextNode(LISTVIEW_BASE_NAME,node)

static __inline struct LVNode *
_Tree_NextNode(void *ListViewBase, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-60);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((struct LVNode *)PPCCallOS(&MyCaos));
}

#define	Tree_AddSubHead(list,parent,node)	_Tree_AddSubHead(LISTVIEW_BASE_NAME,list,parent,node)

static __inline void
_Tree_AddSubHead(void *ListViewBase, struct LVNode *list, struct LVNode *parent, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.a1		=(ULONG) parent;
	MyCaos.a2		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-66);
	MyCaos.a6		=(ULONG) ListViewBase;	
	PPCCallOS(&MyCaos);
}

#define	Tree_RemTail(list)	_Tree_RemTail(LISTVIEW_BASE_NAME,list)

static __inline struct LVNode *
_Tree_RemTail(void *ListViewBase, struct LVNode *list)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.caos_Un.Offset	=	(-72);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((struct LVNode *)PPCCallOS(&MyCaos));
}

#define	Tree_RemHead(list)	_Tree_RemHead(LISTVIEW_BASE_NAME,list)

static __inline struct LVNode *
_Tree_RemHead(void *ListViewBase, struct LVNode *list)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.caos_Un.Offset	=	(-78);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((struct LVNode *)PPCCallOS(&MyCaos));
}

#define	Tree_Remove(list)	_Tree_Remove(LISTVIEW_BASE_NAME,list)

static __inline struct LVNode *
_Tree_Remove(void *ListViewBase, struct LVNode *list)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.caos_Un.Offset	=	(-84);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((struct LVNode *)PPCCallOS(&MyCaos));
}

#define	Tree_RemSubTail(node)	_Tree_RemSubTail(LISTVIEW_BASE_NAME,node)

static __inline struct LVNode *
_Tree_RemSubTail(void *ListViewBase, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-90);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((struct LVNode *)PPCCallOS(&MyCaos));
}

#define	Tree_RemSubHead(node)	_Tree_RemSubHead(LISTVIEW_BASE_NAME,node)

static __inline struct LVNode *
_Tree_RemSubHead(void *ListViewBase, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-96);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((struct LVNode *)PPCCallOS(&MyCaos));
}

#define	Tree_Insert(list,node,listNode)	_Tree_Insert(LISTVIEW_BASE_NAME,list,node,listNode)

static __inline void
_Tree_Insert(void *ListViewBase, struct LVList *list, struct LVNode *node, struct LVNode *listNode)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) list;
	MyCaos.a1		=(ULONG) node;
	MyCaos.a2		=(ULONG) listNode;
	MyCaos.caos_Un.Offset	=	(-102);
	MyCaos.a6		=(ULONG) ListViewBase;	
	PPCCallOS(&MyCaos);
}

#define	Tree_NextSubNode(node)	_Tree_NextSubNode(LISTVIEW_BASE_NAME,node)

static __inline struct LVNode *
_Tree_NextSubNode(void *ListViewBase, struct LVNode *node)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) node;
	MyCaos.caos_Un.Offset	=	(-108);
	MyCaos.a6		=(ULONG) ListViewBase;	
	return((struct LVNode *)PPCCallOS(&MyCaos));
}

#endif /* SASC Pragmas */
#endif /* !_PPCPRAGMA_LISTVIEW_H */
