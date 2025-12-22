#ifndef	CLIB_WILDENGINEER_H
#define CLIB_WILDENGINEER_H

#include <misc/wildengineer.h>

struct WEModuleInfo	*weHaveModuleInfo(struct TagItem *tags);
void			weFreeModuleInfo(struct WEModuleInfo *mi);
struct WEBestModules	*weHaveBestModules(struct TagItem *tags);
void			weFreeBestModules(struct WEBestModules *bm);
struct WEEngineCheck	*weHaveEngineCheck(struct TagItem *tags);
void			weFreeEngineCheck(struct WEEngineCheck *bm);
void			weRepairEngine(struct WEBestModules *bm);
struct WildModule	*weLoadModule(struct TagItem *tags);
void			weKillModule(struct WildModule *mod);

#endif