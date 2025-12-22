/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_LISTBROWSER_H
#define _PPCINLINE_LISTBROWSER_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef LISTBROWSER_BASE_NAME
#define LISTBROWSER_BASE_NAME ListBrowserBase
#endif /* !LISTBROWSER_BASE_NAME */

#define AllocListBrowserNodeA(columns, tags) \
	LP2(0x24, struct Node *, AllocListBrowserNodeA, UWORD, columns, d0, struct TagItem *, tags, a0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AllocListBrowserNode(a0, tags...) \
	({ULONG _tags[] = { tags }; AllocListBrowserNodeA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define FreeListBrowserList(list) \
	LP1NR(0x5a, FreeListBrowserList, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeListBrowserNode(node) \
	LP1NR(0x2a, FreeListBrowserNode, struct Node *, node, a0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetListBrowserNodeAttrsA(node, tags) \
	LP2NR(0x36, GetListBrowserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetListBrowserNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetListBrowserNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define HideAllListBrowserChildren(list) \
	LP1NR(0x54, HideAllListBrowserChildren, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define HideListBrowserNodeChildren(node) \
	LP1NR(0x48, HideListBrowserNodeChildren, struct Node *, node, a0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LISTBROWSER_GetClass() \
	LP0(0x1e, Class *, LISTBROWSER_GetClass, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ListBrowserSelectAll(list) \
	LP1NR(0x3c, ListBrowserSelectAll, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetListBrowserNodeAttrsA(node, tags) \
	LP2NR(0x30, SetListBrowserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetListBrowserNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetListBrowserNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define ShowAllListBrowserChildren(list) \
	LP1NR(0x4e, ShowAllListBrowserChildren, struct List *, list, a0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ShowListBrowserNodeChildren(node, depth) \
	LP2NR(0x42, ShowListBrowserNodeChildren, struct Node *, node, a0, WORD, depth, d0, \
	, LISTBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_LISTBROWSER_H */
