#ifndef _INLINE_RESOURCE_H
#define _INLINE_RESOURCE_H

#ifndef CLIB_RESOURCE_PROTOS_H
#define CLIB_RESOURCE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  LIBRARIES_RESOURCE_H
#include <libraries/resource.h>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif
#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  LIBRARIES_LOCALE_H
#include <libraries/locale.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef RESOURCE_BASE_NAME
#define RESOURCE_BASE_NAME ResourceBase
#endif

#define RL_OpenResource(resource, screen, catalog) \
	LP3(0x1e, RESOURCEFILE, RL_OpenResource, APTR, resource, a0, struct Screen *, screen, a1, struct Catalog *, catalog, a2, \
	, RESOURCE_BASE_NAME)

#define RL_CloseResource(resfile) \
	LP1NR(0x24, RL_CloseResource, RESOURCEFILE, resfile, a0, \
	, RESOURCE_BASE_NAME)

#define RL_NewObjectA(resfile, resid, tags) \
	LP3(0x2a, Object *, RL_NewObjectA, RESOURCEFILE, resfile, a0, RESOURCEID, resid, d0, struct TagItem *, tags, a1, \
	, RESOURCE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define RL_NewObject(resfile, resid, tags...) \
	({ULONG _tags[] = {tags}; RL_NewObjectA((resfile), (resid), (struct TagItem *) _tags);})
#endif

#define RL_DisposeObject(resfile, obj) \
	LP2NR(0x30, RL_DisposeObject, RESOURCEFILE, resfile, a0, Object *, obj, a1, \
	, RESOURCE_BASE_NAME)

#define RL_NewGroupA(resfile, id, taglist) \
	LP3(0x36, Object **, RL_NewGroupA, RESOURCEFILE, resfile, a0, RESOURCEID, id, d0, struct TagItem *, taglist, a1, \
	, RESOURCE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define RL_NewGroup(resfile, id, tags...) \
	({ULONG _tags[] = {tags}; RL_NewGroupA((resfile), (id), (struct TagItem *) _tags);})
#endif

#define RL_DisposeGroup(resfile, obj) \
	LP2NR(0x3c, RL_DisposeGroup, RESOURCEFILE, resfile, a0, Object **, obj, a1, \
	, RESOURCE_BASE_NAME)

#define RL_GetObjectArray(resfile, obj, id) \
	LP3(0x42, Object **, RL_GetObjectArray, RESOURCEFILE, resfile, a0, Object *, obj, a1, RESOURCEID, id, d0, \
	, RESOURCE_BASE_NAME)

#define RL_SetResourceScreen(resfile, screen) \
	LP2(0x48, BOOL, RL_SetResourceScreen, RESOURCEFILE, resfile, a0, struct Screen *, screen, a1, \
	, RESOURCE_BASE_NAME)

#endif /*  _INLINE_RESOURCE_H  */
