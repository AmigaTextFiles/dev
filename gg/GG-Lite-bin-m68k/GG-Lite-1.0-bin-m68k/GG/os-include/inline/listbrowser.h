#ifndef _INLINE_LISTBROWSER_H
#define _INLINE_LISTBROWSER_H

#ifndef CLIB_LISTBROWSER_PROTOS_H
#define CLIB_LISTBROWSER_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif
#ifndef  GADGETS_LISTBROWSER_H
#include <gadgets/listbrowser.h>
#endif

#ifndef LISTBROWSER_BASE_NAME
#define LISTBROWSER_BASE_NAME ListBrowserBase
#endif

#define LISTBROWSER_GetClass() \
	LP0(0x1e, struct IClass *, LISTBROWSER_GetClass, \
	, LISTBROWSER_BASE_NAME)

#define AllocListBrowserNodeA(columns, tags) \
	LP2(0x24, struct Node *, AllocListBrowserNodeA, ULONG, columns, d0, struct TagItem *, tags, a0, \
	, LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocListBrowserNode(columns, tags...) \
	({ULONG _tags[] = {tags}; AllocListBrowserNodeA((columns), (struct TagItem *) _tags);})
#endif

#define FreeListBrowserNode(node) \
	LP1NR(0x2a, FreeListBrowserNode, struct Node *, node, a0, \
	, LISTBROWSER_BASE_NAME)

#define SetListBrowserNodeAttrsA(node, tags) \
	LP2NR(0x30, SetListBrowserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetListBrowserNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; SetListBrowserNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#define GetListBrowserNodeAttrsA(node, tags) \
	LP2NR(0x36, GetListBrowserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetListBrowserNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; GetListBrowserNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#define ListBrowserSelectAll(list) \
	LP1NR(0x3c, ListBrowserSelectAll, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME)

#define ShowListBrowserNodeChildren(node, depth) \
	LP2NR(0x42, ShowListBrowserNodeChildren, struct Node *, node, a0, LONG, depth, d0, \
	, LISTBROWSER_BASE_NAME)

#define HideListBrowserNodeChildren(node) \
	LP1NR(0x48, HideListBrowserNodeChildren, struct Node *, node, a0, \
	, LISTBROWSER_BASE_NAME)

#define ShowAllListBrowserChildren(list) \
	LP1NR(0x4e, ShowAllListBrowserChildren, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME)

#define HideAllListBrowserChildren(list) \
	LP1NR(0x54, HideAllListBrowserChildren, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME)

#define FreeListBrowserList(list) \
	LP1NR(0x5a, FreeListBrowserList, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME)

#define AllocLBColumnInfoA(columns, tags) \
	LP2(0x60, struct ColumnInfo *, AllocLBColumnInfoA, ULONG, columns, d0, struct TagItem *, tags, a0, \
	, LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocLBColumnInfo(columns, tags...) \
	({ULONG _tags[] = {tags}; AllocLBColumnInfoA((columns), (struct TagItem *) _tags);})
#endif

#define SetLBColumnInfoAttrsA(columninfo, tags) \
	LP2(0x66, LONG, SetLBColumnInfoAttrsA, struct ColumnInfo *, columninfo, a1, struct TagItem *, tags, a0, \
	, LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetLBColumnInfoAttrs(columninfo, tags...) \
	({ULONG _tags[] = {tags}; SetLBColumnInfoAttrsA((columninfo), (struct TagItem *) _tags);})
#endif

#define GetLBColumnInfoAttrsA(columninfo, tags) \
	LP2(0x6c, LONG, GetLBColumnInfoAttrsA, struct ColumnInfo *, columninfo, a1, struct TagItem *, tags, a0, \
	, LISTBROWSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetLBColumnInfoAttrs(columninfo, tags...) \
	({ULONG _tags[] = {tags}; GetLBColumnInfoAttrsA((columninfo), (struct TagItem *) _tags);})
#endif

#define FreeLBColumnInfo(columninfo) \
	LP1NR(0x72, FreeLBColumnInfo, struct ColumnInfo *, columninfo, a0, \
	, LISTBROWSER_BASE_NAME)

#define ListBrowserClearAll(list) \
	LP1NR(0x78, ListBrowserClearAll, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME)

#endif /*  _INLINE_LISTBROWSER_H  */
