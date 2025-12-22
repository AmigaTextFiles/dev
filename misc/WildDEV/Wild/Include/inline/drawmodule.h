#ifndef _INLINE_DRAWMODULE_H
#define _INLINE_DRAWMODULE_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef DRAWMODULE_BASE_NAME
#define DRAWMODULE_BASE_NAME DrawModuleBase
#endif

#define SetModuleTags(WildApp, Tags) \
	LP2NR(0x1E, SetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, DRAWMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define GetModuleTags(WildApp, Tags) \
	LP2NR(0x24, GetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, DRAWMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; GetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define SetupModule(WildApp, Tags) \
	LP2(0x2A, BOOL, SetupModule, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, DRAWMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetupModuleTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetupModule((WildApp), (struct TagItem *) _tags);})
#endif

#define CloseModule(WildApp) \
	LP1NR(0x30, CloseModule, struct WildApp *, WildApp, a0, \
	, DRAWMODULE_BASE_NAME)

#define RefreshModule(WildApp) \
	LP1(0x36, BOOL, RefreshModule, struct WildApp *, WildApp, a0, \
	, DRAWMODULE_BASE_NAME)

#define DRWPaintArray(WildApp, BSPEntries) \
	LP2NR(0x3C, DRWPaintArray, struct WildApp *, WildApp, a0, ULONG *, BSPEntries, a1, \
	, DRAWMODULE_BASE_NAME)

#define DRWInitFrame(WildApp) \
	LP1NR(0x42, DRWInitFrame, struct WildApp *, WildApp, a0, \
	, DRAWMODULE_BASE_NAME)

#define DRWInitTexture(WildApp, Texture) \
	LP2(0x48, BOOL, DRWInitTexture, struct WildApp *, WildApp, a0, struct WildTexture *, Texture, a1, \
	, DRAWMODULE_BASE_NAME)

#endif /*  _INLINE_DRAWMODULE_H  */
