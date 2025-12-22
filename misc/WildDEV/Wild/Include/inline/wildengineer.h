#ifndef _INLINE_WILDENGINEER_H
#define _INLINE_WILDENGINEER_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef WILDENGINEER_BASE_NAME
#define WILDENGINEER_BASE_NAME WEBase
#endif

#define weHaveModuleInfo(tags) \
	LP1(0x1E, struct WEModuleInfo	*, weHaveModuleInfo, struct TagItem *, tags, a0, \
	, WILDENGINEER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define weHaveModuleInfoTags(tags...) \
	({ULONG _tags[] = {tags}; weHaveModuleInfo((struct TagItem *) _tags);})
#endif

#define weFreeModuleInfo(moduleinfo) \
	LP1NR(0x24, weFreeModuleInfo, struct WEModuleInfo *, moduleinfo, a0, \
	, WILDENGINEER_BASE_NAME)

#define weHaveBestModules(tags) \
	LP1(0x2A, struct WEBestModules	*, weHaveBestModules, struct TagItem *, tags, a0, \
	, WILDENGINEER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define weHaveBestModulesTags(tags...) \
	({ULONG _tags[] = {tags}; weHaveBestModules((struct TagItem *) _tags);})
#endif

#define weFreeBestModules(bestmodules) \
	LP1NR(0x30, weFreeBestModules, struct WEBestModules *, bestmodules, a0, \
	, WILDENGINEER_BASE_NAME)

#define weHaveEngineCheck(tags) \
	LP1(0x36, struct WEEngineCheck	*, weHaveEngineCheck, struct TagItem *, tags, a0, \
	, WILDENGINEER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define weHaveEngineCheckTags(tags...) \
	({ULONG _tags[] = {tags}; weHaveEngineCheck((struct TagItem *) _tags);})
#endif

#define weFreeEngineCheck(enginecheck) \
	LP1NR(0x3C, weFreeEngineCheck, struct WEEngineCheck *, enginecheck, a0, \
	, WILDENGINEER_BASE_NAME)

#define weRepairEngine(tags) \
	LP1NR(0x42, weRepairEngine, struct WEBestModules *, tags, a0, \
	, WILDENGINEER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define weRepairEngineTags(tags...) \
	({ULONG _tags[] = {tags}; weRepairEngine((struct WEBestModules *) _tags);})
#endif

#define weLoadModule(tags) \
	LP1(0x48, struct WildModule	*, weLoadModule, struct TagItem *, tags, a0, \
	, WILDENGINEER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define weLoadModuleTags(tags...) \
	({ULONG _tags[] = {tags}; weLoadModule((struct TagItem *) _tags);})
#endif

#define weKillModule(module) \
	LP1NR(0x4E, weKillModule, struct WildModule *, module, a0, \
	, WILDENGINEER_BASE_NAME)

#endif /*  _INLINE_WILDENGINEER_H  */
