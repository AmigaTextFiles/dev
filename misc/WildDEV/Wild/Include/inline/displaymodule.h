#ifndef _INLINE_DISPLAYMODULE_H
#define _INLINE_DISPLAYMODULE_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef DISPLAYMODULE_BASE_NAME
#define DISPLAYMODULE_BASE_NAME DisplayModuleBase
#endif

#define SetModuleTags(WildApp, Tags) \
	LP2NR(0x1E, SetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, DISPLAYMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define GetModuleTags(WildApp, Tags) \
	LP2NR(0x24, GetModuleTags, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, DISPLAYMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetModuleTagsTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; GetModuleTags((WildApp), (struct TagItem *) _tags);})
#endif

#define SetupModule(WildApp, Tags) \
	LP2(0x2A, BOOL, SetupModule, struct WildApp *, WildApp, a0, struct TagItem *, Tags, a1, \
	, DISPLAYMODULE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetupModuleTags(WildApp, tags...) \
	({ULONG _tags[] = {tags}; SetupModule((WildApp), (struct TagItem *) _tags);})
#endif

#define CloseModule(WildApp) \
	LP1NR(0x30, CloseModule, struct WildApp *, WildApp, a0, \
	, DISPLAYMODULE_BASE_NAME)

#define RefreshModule(WildApp) \
	LP1(0x36, BOOL, RefreshModule, struct WildApp *, WildApp, a0, \
	, DISPLAYMODULE_BASE_NAME)

#define DISDisplayFrame(WildApp) \
	LP1NR(0x3C, DISDisplayFrame, struct WildApp *, WildApp, a0, \
	, DISPLAYMODULE_BASE_NAME)

#define DISInitFrame(WildApp) \
	LP1NR(0x42, DISInitFrame, struct WildApp *, WildApp, a0, \
	, DISPLAYMODULE_BASE_NAME)

#endif /*  _INLINE_DISPLAYMODULE_H  */
