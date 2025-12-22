#ifndef _INLINE_LOADERMODULE_H
#define _INLINE_LOADERMODULE_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef LOADERMODULE_BASE_NAME
#define LOADERMODULE_BASE_NAME LoaderModuleBase
#endif

#define SetModuleTags(WildApp, Tags) \
	LP2NR(0x1E, SetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, LOADERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define GetModuleTags(WildApp, Tags) \
	LP2NR(0x24, GetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, LOADERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; GetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define SetupModule(WildApp, Tags) \
	LP2(0x2A, BOOL, SetupModule, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, LOADERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetupModuleTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetupModule((WildApp), (struct TagItem *) _tags);})
#endif

#define CloseModule(WildApp) \
	LP1NR(0x30, CloseModule, struct WildApp *, WildApp, a0, \
	, LOADERMODULE_BASE_NAME)

#define RefreshModule(WildApp) \
	LP1(0x36, BOOL, RefreshModule, struct WildApp *, WildApp, a0, \
	, LOADERMODULE_BASE_NAME)

#define LOALoadObj(Tags) \
	LP1(0x3C, ULONG		*, LOALoadObj, struct TagItem *, Tags, a0, \
	, LOADERMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define LOALoadObjTags(tags...) \
	({ULONG _tags[] = {tags}; LOALoadObj((struct TagItem *) _tags);})
#endif

#define LOAGetObjAttr(WildApp, Object, Attr, Default) \
	LP4(0x42, ULONG, LOAGetObjAttr, struct WildApp *, WildApp, a0, ULONG *, Object, a1, ULONG, Attr, d0, ULONG, Default, d1, \
	, LOADERMODULE_BASE_NAME)

#define LOANextObjChild(Object, Precedent, Type) \
	LP3(0x48, ULONG		*, LOANextObjChild, ULONG *, Object, a0, ULONG *, Precedent, a1, ULONG, Type, d0, \
	, LOADERMODULE_BASE_NAME)

#define LOAMadeObjIs(Object, WildObject) \
	LP2NR(0x4E, LOAMadeObjIs, ULONG *, Object, a0, ULONG *, WildObject, a1, \
	, LOADERMODULE_BASE_NAME)

#define LOAFreeObj(Object) \
	LP1NR(0x54, LOAFreeObj, ULONG *, Object, a0, \
	, LOADERMODULE_BASE_NAME)

#endif /*  _INLINE_LOADERMODULE_H  */
