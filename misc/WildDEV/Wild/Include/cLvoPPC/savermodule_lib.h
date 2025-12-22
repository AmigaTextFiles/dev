#include <exec/types.h>
extern ULONG CallModule68kc(__reg("r7") LONG offset,__reg("r8") struct WildModule *BASE,__reg("r3") LONG d0arg,__reg("r4") LONG d1arg,__reg("r5") LONG *a0arg,__reg("r6") LONG *a1arg);

#ifndef _LVOSetModuleTags	
#define _LVOSetModuleTags			-30
#define SetModuleTags(A0,A1) \
CallModule68kc(_LVOSetModuleTags,SaverModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOGetModuleTags	
#define _LVOGetModuleTags			-36
#define GetModuleTags(A0,A1) \
CallModule68kc(_LVOGetModuleTags,SaverModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOSetupModule	
#define _LVOSetupModule			-42
#define SetupModule(A0,A1) \
CallModule68kc(_LVOSetupModule,SaverModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOCloseModule	
#define _LVOCloseModule			-48
#define CloseModule(A0) \
CallModule68kc(_LVOCloseModule,SaverModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVORefreshModule	
#define _LVORefreshModule			-54
#define RefreshModule(A0) \
CallModule68kc(_LVORefreshModule,SaverModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVOSAVNewObj	
#define _LVOSAVNewObj				-60
#define SAVNewObj(D0,A0,A1,D1) \
CallModule68kc(_LVOSAVNewObj,SaverModuleBase,((LONG)D0),((LONG)D1),((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOSAVSetObjAttr	
#define _LVOSAVSetObjAttr			-66
#define SAVSetObjAttr(A0,A1,D0,D1) \
CallModule68kc(_LVOSAVSetObjAttr,SaverModuleBase,((LONG)D0),((LONG)D1),((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOSAVSaveObj	
#define _LVOSAVSaveObj				-72
#define SAVSaveObj(A0) \
CallModule68kc(_LVOSAVSaveObj,SaverModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVOSAVFreeObj	
#define _LVOSAVFreeObj				-78
#define SAVFreeObj(A0) \
CallModule68kc(_LVOSAVFreeObj,SaverModuleBase,0,0,((LONG *)A0),0)
#endif

