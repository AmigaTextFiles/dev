#ifndef _INLINE_SAVERMODULE_H
#define _INLINE_SAVERMODULE_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef SAVERMODULE_BASE_NAME
#define SAVERMODULE_BASE_NAME SaverModuleBase
#endif

#define SetModuleTags(WildApp, Tags) \
	LP2NR(0x1E, SetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, SAVERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define GetModuleTags(WildApp, Tags) \
	LP2NR(0x24, GetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, SAVERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; GetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define SetupModule(WildApp, Tags) \
	LP2(0x2A, BOOL, SetupModule, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, SAVERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetupModuleTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetupModule((WildApp), (struct TagItem *) _tags);})
#endif

#define CloseModule(WildApp) \
	LP1NR(0x30, CloseModule, struct WildApp *, WildApp, a0, \
	, SAVERMODULE_BASE_NAME)

#define RefreshModule(WildApp) \
	LP1(0x36, BOOL, RefreshModule, struct WildApp *, WildApp, a0, \
	, SAVERMODULE_BASE_NAME)

#define SAVNewObj(Type, Prec, Parent, WildObj) \
	LP4(0x3C, ULONG		*, SAVNewObj, ULONG, Type, d0, void *, Prec, a0, void *, Parent, a1, void *, WildObj, a2, \
	, SAVERMODULE_BASE_NAME)

#define SAVSetObjAttr(WildApp, Object, Attr, Value) \
	LP4NR(0x42, SAVSetObjAttr, struct WildApp *, WildApp, a0, ULONG *, Object, a1, ULONG, Attr, d0, ULONG, Value, d1, \
	, SAVERMODULE_BASE_NAME)

#define SAVSaveObj(Tags) \
	LP1NR(0x48, SAVSaveObj, struct TagItem *, Tags, a0, \
	, SAVERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SAVSaveObjTags(tags...) \
	({ULONG _tags[] = {tags}; SAVSaveObj((struct TagItem *) _tags);})
#endif

#define SAVFreeObj(Object) \
	LP1NR(0x4E, SAVFreeObj, void *, Object, a0, \
	, SAVERMODULE_BASE_NAME)

#endif /*  _INLINE_SAVERMODULE_H  */
