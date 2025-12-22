#ifndef _INLINE_WILDPREFS_H
#define _INLINE_WILDPREFS_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef WILDPREFS_BASE_NAME
#define WILDPREFS_BASE_NAME WPBase
#endif

#define wpGetHandledList() \
	LP0(0x1E, struct MinList 		*, wpGetHandledList, \
	, WILDPREFS_BASE_NAME)

#define wpFindNamedApp(name) \
	LP1(0x24, struct AppPrefs 	*, wpFindNamedApp, char *, name, a0, \
	, WILDPREFS_BASE_NAME)

#define wpLoadPrefs(app, tags) \
	LP2(0x2A, BOOL, wpLoadPrefs, struct AppPrefs *, app, a0, struct TagItem *, tags, a1, \
	, WILDPREFS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define wpLoadPrefsTags(app, tags...) \
	({ULONG _tags[] = {tags}; wpLoadPrefs((app), (struct TagItem *) _tags);})
#endif

#define wpSetPrefs(app, tags) \
	LP2(0x30, BOOL, wpSetPrefs, struct AppPrefs *, app, a0, struct TagItem *, tags, a1, \
	, WILDPREFS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define wpSetPrefsTags(app, tags...) \
	({ULONG _tags[] = {tags}; wpSetPrefs((app), (struct TagItem *) _tags);})
#endif

#define wpTestPrefs(app) \
	LP1(0x36, BOOL, wpTestPrefs, struct AppPrefs *, app, a0, \
	, WILDPREFS_BASE_NAME)

#define wpUsePrefs(app) \
	LP1(0x3C, BOOL, wpUsePrefs, struct AppPrefs *, app, a0, \
	, WILDPREFS_BASE_NAME)

#define wpSavePrefs(app) \
	LP1(0x42, BOOL, wpSavePrefs, struct AppPrefs *, app, a0, \
	, WILDPREFS_BASE_NAME)

#define wpFreePrefs(app) \
	LP1(0x48, BOOL, wpFreePrefs, struct AppPrefs *, app, a0, \
	, WILDPREFS_BASE_NAME)

#define wpGetAppTag(app, tag, default) \
	LP3(0x4E, ULONG, wpGetAppTag, struct AppPrefs *, app, a0, ULONG, tag, d0, ULONG, default, d1, \
	, WILDPREFS_BASE_NAME)

#endif /*  _INLINE_WILDPREFS_H  */
