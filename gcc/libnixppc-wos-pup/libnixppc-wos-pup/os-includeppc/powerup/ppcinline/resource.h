/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_RESOURCE_H
#define _PPCINLINE_RESOURCE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef RESOURCE_BASE_NAME
#define RESOURCE_BASE_NAME ResourceBase
#endif /* !RESOURCE_BASE_NAME */

#define RL_CloseResource(resfile) \
	LP1NR(0x24, RL_CloseResource, RESOURCEFILE, resfile, a0, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RL_DisposeGroup(resfile, objects) \
	LP2NR(0x3c, RL_DisposeGroup, RESOURCEFILE, resfile, a0, Object **, objects, a1, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RL_DisposeObject(resfile, object) \
	LP2NR(0x30, RL_DisposeObject, RESOURCEFILE, resfile, a0, Object *, object, a1, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RL_GetObjectArray(resfile, object, resourceid) \
	LP3(0x42, Object **, RL_GetObjectArray, RESOURCEFILE, resfile, a0, Object *, object, a1, RESOURCEID, resourceid, d0, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RL_NewGroupA(resfile, resourceid, taglist) \
	LP3(0x36, Object **, RL_NewGroupA, RESOURCEFILE, resfile, a0, RESOURCEID, resourceid, d0, struct TagItem *, taglist, a1, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define RL_NewGroup(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; RL_NewGroupA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define RL_NewObjectA(resfile, resourceid, taglist) \
	LP3(0x2a, Object *, RL_NewObjectA, RESOURCEFILE, resfile, a0, RESOURCEID, resourceid, d0, struct TagItem *, taglist, a1, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define RL_NewObject(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; RL_NewObjectA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define RL_OpenResource(resource, screen, catalog) \
	LP3(0x1e, RESOURCEFILE, RL_OpenResource, void *, resource, a0, struct Screen *, screen, a1, struct Catalog *, catalog, a2, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RL_SetResourceScreen(resfile, screen) \
	LP2(0x48, BOOL, RL_SetResourceScreen, RESOURCEFILE, resfile, a0, struct Screen *, screen, a1, \
	, RESOURCE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_RESOURCE_H */
