#include <exec/types.h>
extern ULONG CallModule68kc(__reg("r7") LONG offset,__reg("r8") struct WildModule *BASE,__reg("r3") LONG d0arg,__reg("r4") LONG d1arg,__reg("r5") LONG *a0arg,__reg("r6") LONG *a1arg);

#ifndef _LVOSetModuleTags	
#define _LVOSetModuleTags			-30
#define SetModuleTags(A0,A1) \
CallModule68kc(_LVOSetModuleTags,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOGetModuleTags	
#define _LVOGetModuleTags			-36
#define GetModuleTags(A0,A1) \
CallModule68kc(_LVOGetModuleTags,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOSetupModule	
#define _LVOSetupModule			-42
#define SetupModule(A0,A1) \
CallModule68kc(_LVOSetupModule,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOCloseModule	
#define _LVOCloseModule			-48
#define CloseModule(A0) \
CallModule68kc(_LVOCloseModule,LoaderModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVORefreshModule	
#define _LVORefreshModule			-54
#define RefreshModule(A0) \
CallModule68kc(_LVORefreshModule,LoaderModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVOLOALoadObj	
#define _LVOLOALoadObj				-60
#define LOALoadObj(A0,A1) \
CallModule68kc(_LVOLOALoadObj,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOLOAGetObjAttr	
#define _LVOLOAGetObjAttr			-66
#define LOAGetObjAttr(A0,A1,D0,D1) \
CallModule68kc(_LVOLOAGetObjAttr,LoaderModuleBase,((LONG)D0),((LONG)D1),((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOLOANextObjChild	
#define _LVOLOANextObjChild			-72
#define LOANextObjChild(A0,A1,D0) \
CallModule68kc(_LVOLOANextObjChild,LoaderModuleBase,((LONG)D0),0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOLOAMadeObjIs	
#define _LVOLOAMadeObjIs			-78
#define LOAMadeObjIs(A0,A1) \
CallModule68kc(_LVOLOAMadeObjIs,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOLOAFreeObj	
#define _LVOLOAFreeObj				-84
#define LOAFreeObj(A0) \
CallModule68kc(_LVOLOAFreeObj,LoaderModuleBase,0,0,((LONG *)A0),0)
#endif

