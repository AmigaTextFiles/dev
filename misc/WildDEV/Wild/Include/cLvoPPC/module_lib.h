#include <exec/types.h>
extern ULONG CallModule68kc(__reg("r7") LONG offset,__reg("r8") struct WildModule *BASE,__reg("r3") LONG d0arg,__reg("r4") LONG d1arg,__reg("r5") LONG *a0arg,__reg("r6") LONG *a1arg);

#ifndef _LVOSetModuleTags	
#define _LVOSetModuleTags			-30
#define SetModuleTags(A0,A1) \
CallModule68kc(_LVOSetModuleTags,ModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOGetModuleTags	
#define _LVOGetModuleTags			-36
#define GetModuleTags(A0,A1) \
CallModule68kc(_LVOGetModuleTags,ModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOSetupModule	
#define _LVOSetupModule			-42
#define SetupModule(A0,A1) \
CallModule68kc(_LVOSetupModule,ModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOCloseModule	
#define _LVOCloseModule			-48
#define CloseModule(A0) \
CallModule68kc(_LVOCloseModule,ModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVORefreshModule	
#define _LVORefreshModule			-54
#define RefreshModule(A0) \
CallModule68kc(_LVORefreshModule,ModuleBase,0,0,((LONG *)A0),0)
#endif

