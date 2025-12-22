#ifndef _INLINE_WILD_H
#define _INLINE_WILD_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef WILD_BASE_NAME
#define WILD_BASE_NAME WildBase
#endif

#define AddWildApp(wildPort, tagList) \
	LP2(0x1E, struct 	WildApp 	*, AddWildApp, struct MSGPort *, wildPort, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddWildAppTags(wildPort, tags...) \
	({ULONG _tags[] = {tags}; AddWildApp((wildPort), (struct TagItem *) _tags);})
#endif

#define RemWildApp(wildApp) \
	LP1NR(0x24, RemWildApp, struct WildApp *, wildApp, a0, \
	, WILD_BASE_NAME)

#define LoadModule(type, name) \
	LP2(0x2A, struct	WildModule	*, LoadModule, char *, type, a0, char *, name, a1, \
	, WILD_BASE_NAME)

#define KillModule(module) \
	LP1NR(0x30, KillModule, struct WildModule *, module, a1, \
	, WILD_BASE_NAME)

#define SetWildAppTags(wildApp, tagList) \
	LP2(0x36, BOOL, SetWildAppTags, struct WildApp *, wildApp, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetWildAppTagsTags(wildApp, tags...) \
	({ULONG _tags[] = {tags}; SetWildAppTags((wildApp), (struct TagItem *) _tags);})
#endif

#define GetWildAppTags(wildApp, tagList) \
	LP2NR(0x3C, GetWildAppTags, struct WildApp *, wildApp, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetWildAppTagsTags(wildApp, tags...) \
	({ULONG _tags[] = {tags}; GetWildAppTags((wildApp), (struct TagItem *) _tags);})
#endif

#define AddWildThread(wildApp, tagList) \
	LP2(0x42, struct 	WildThread	*, AddWildThread, struct WildApp *, wildApp, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AddWildThreadTags(wildApp, tags...) \
	({ULONG _tags[] = {tags}; AddWildThread((wildApp), (struct TagItem *) _tags);})
#endif

#define RemWildThread(Thread) \
	LP1NR(0x48, RemWildThread, struct WildThread *, Thread, a0, \
	, WILD_BASE_NAME)

#define AllocVecPooled(size, Pool) \
	LP2(0x4E, ULONG			*, AllocVecPooled, ULONG, size, d0, ULONG *, Pool, a0, \
	, WILD_BASE_NAME)

#define FreeVecPooled(memory) \
	LP1NR(0x54, FreeVecPooled, ULONG *, memory, a1, \
	, WILD_BASE_NAME)

#define RealyzeFrame(wildApp) \
	LP1NR(0x5A, RealyzeFrame, struct WildApp *, wildApp, a0, \
	, WILD_BASE_NAME)

#define InitFrame(wildApp) \
	LP1NR(0x60, InitFrame, struct WildApp *, wildApp, a0, \
	, WILD_BASE_NAME)

#define DisplayFrame(wildApp) \
	LP1NR(0x66, DisplayFrame, struct WildApp *, wildApp, a0, \
	, WILD_BASE_NAME)

#define LoadTable(id, name) \
	LP2(0x6C, struct	WildTable	*, LoadTable, ULONG, id, d0, char *, name, a0, \
	, WILD_BASE_NAME)

#define KillTable(table) \
	LP1NR(0x72, KillTable, struct WildTable *, table, a1, \
	, WILD_BASE_NAME)

#define LoadFile(offset, name, pool) \
	LP3(0x78, ULONG, LoadFile, ULONG, offset, d0, char *, name, d1, ULONG *, pool, a0, \
	, WILD_BASE_NAME)

#define LoadExtension(name, version) \
	LP2(0x7E, struct 	WildExtension	*, LoadExtension, char *, name, a1, ULONG, version, d0, \
	, WILD_BASE_NAME)

#define KillExtension(extension) \
	LP1NR(0x84, KillExtension, struct WildExtension *, extension, a1, \
	, WILD_BASE_NAME)

#define FindWildApp(tagList) \
	LP1(0x8A, struct	WildApp		*, FindWildApp, struct TagItem *, tagList, a0, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define FindWildAppTags(tags...) \
	({ULONG _tags[] = {tags}; FindWildApp((struct TagItem *) _tags);})
#endif

#define BuildWildObject(tagList) \
	LP1(0x90, ULONG			*, BuildWildObject, struct TagItem *, tagList, a0, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define BuildWildObjectTags(tags...) \
	({ULONG _tags[] = {tags}; BuildWildObject((struct TagItem *) _tags);})
#endif

#define FreeWildObject(object) \
	LP1NR(0x96, FreeWildObject, ULONG *, object, a0, \
	, WILD_BASE_NAME)

#define LoadWildObject(wildApp, tagList) \
	LP2(0x9C, ULONG			*, LoadWildObject, struct WildApp *, wildApp, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define LoadWildObjectTags(wildApp, tags...) \
	({ULONG _tags[] = {tags}; LoadWildObject((wildApp), (struct TagItem *) _tags);})
#endif

#define GetWildObjectChild(object, childtype, number) \
	LP3(0xA2, ULONG			*, GetWildObjectChild, ULONG *, object, a0, ULONG, childtype, d0, ULONG, number, d1, \
	, WILD_BASE_NAME)

#define SaveWildObject(wildApp, tagList) \
	LP2(0xA8, ULONG			*, SaveWildObject, struct WildApp *, wildApp, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SaveWildObjectTags(wildApp, tags...) \
	({ULONG _tags[] = {tags}; SaveWildObject((wildApp), (struct TagItem *) _tags);})
#endif

#define DoAction(wildApp, tagList) \
	LP2(0xAE, struct	WildDoing	*, DoAction, struct WildApp *, wildApp, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DoActionTags(wildApp, tags...) \
	({ULONG _tags[] = {tags}; DoAction((wildApp), (struct TagItem *) _tags);})
#endif

#define WildAnimate(wildApp, tagList) \
	LP2NR(0xB4, WildAnimate, struct WildApp *, wildApp, a0, struct TagItem *, tagList, a1, \
	, WILD_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define WildAnimateTags(wildApp, tags...) \
	({ULONG _tags[] = {tags}; WildAnimate((wildApp), (struct TagItem *) _tags);})
#endif

#define AbortAction(Doing) \
	LP1NR(0xBA, AbortAction, struct WildDoing *, Doing, a0, \
	, WILD_BASE_NAME)

#endif /*  _INLINE_WILD_H  */
