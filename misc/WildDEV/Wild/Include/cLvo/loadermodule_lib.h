#include <exec/types.h>
#include <gcc/compiler.h>

#ifdef __GNUC__
#define USE_TAGS_STUBS
#endif

extern ULONG CallModulePPCc(LONG offset,struct WildModule *BASE,ASMREG(LONG,d0arg,d0),ASMREG(LONG,d1arg,d1),ASMREG(LONG,*a0arg,a0),ASMREG(LONG,*a1arg,a1));

#ifndef _LVOSetModuleTags	
#define _LVOSetModuleTags			-30
#define SetModuleTags(A0,A1) \
CallModulePPCc(_LVOSetModuleTags,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#ifdef USE_TAGS_STUBS
#define SetModuleTagsTags(A0,tags... ) \
({ULONG _t[]={tags}; \
SetModuleTags(A0,(APTR)_t); \
})
#endif
#endif

#ifndef _LVOGetModuleTags	
#define _LVOGetModuleTags			-36
#define GetModuleTags(A0,A1) \
CallModulePPCc(_LVOGetModuleTags,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#ifdef USE_TAGS_STUBS
#define GetModuleTagsTags(A0,tags... ) \
({ULONG _t[]={tags}; \
GetModuleTags(A0,(APTR)_t); \
})
#endif
#endif

#ifndef _LVOSetupModule	
#define _LVOSetupModule			-42
#define SetupModule(A0,A1) \
CallModulePPCc(_LVOSetupModule,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#ifdef USE_TAGS_STUBS
#define SetupModuleTags(A0,tags... ) \
({ULONG _t[]={tags}; \
SetupModule(A0,(APTR)_t); \
})
#endif
#endif

#ifndef _LVOCloseModule	
#define _LVOCloseModule			-48
#define CloseModule(A0) \
CallModulePPCc(_LVOCloseModule,LoaderModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVORefreshModule	
#define _LVORefreshModule			-54
#define RefreshModule(A0) \
CallModulePPCc(_LVORefreshModule,LoaderModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVOLOALoadObj	
#define _LVOLOALoadObj				-60
#define LOALoadObj(A0,A1) \
CallModulePPCc(_LVOLOALoadObj,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#ifdef USE_TAGS_STUBS
#define LOALoadObjTags(A0,tags... ) \
({ULONG _t[]={tags}; \
LOALoadObj(A0,(APTR)_t); \
})
#endif
#endif

#ifndef _LVOLOAGetObjAttr	
#define _LVOLOAGetObjAttr			-66
#define LOAGetObjAttr(A0,A1,D0,D1) \
CallModulePPCc(_LVOLOAGetObjAttr,LoaderModuleBase,((LONG)D0),((LONG)D1),((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOLOANextObjChild	
#define _LVOLOANextObjChild			-72
#define LOANextObjChild(A0,A1,D0) \
CallModulePPCc(_LVOLOANextObjChild,LoaderModuleBase,((LONG)D0),0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOLOAMadeObjIs	
#define _LVOLOAMadeObjIs			-78
#define LOAMadeObjIs(A0,A1) \
CallModulePPCc(_LVOLOAMadeObjIs,LoaderModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOLOAFreeObj	
#define _LVOLOAFreeObj				-84
#define LOAFreeObj(A0) \
CallModulePPCc(_LVOLOAFreeObj,LoaderModuleBase,0,0,((LONG *)A0),0)
#endif

