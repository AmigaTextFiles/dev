#include <exec/types.h>
#include <gcc/compiler.h>

#ifdef __GNUC__
#define USE_TAGS_STUBS
#endif

extern ULONG CallModulePPCc(LONG offset,struct WildModule *BASE,ASMREG(LONG,d0arg,d0),ASMREG(LONG,d1arg,d1),ASMREG(LONG,*a0arg,a0),ASMREG(LONG,*a1arg,a1));

#ifndef _LVOSetModuleTags	
#define _LVOSetModuleTags			-30
#define SetModuleTags(A0,A1) \
CallModulePPCc(_LVOSetModuleTags,SaverModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOGetModuleTags,SaverModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOSetupModule,SaverModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOCloseModule,SaverModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVORefreshModule	
#define _LVORefreshModule			-54
#define RefreshModule(A0) \
CallModulePPCc(_LVORefreshModule,SaverModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVOSAVNewObj	
#define _LVOSAVNewObj				-60
#define SAVNewObj(D0,A0,A1,D1) \
CallModulePPCc(_LVOSAVNewObj,SaverModuleBase,((LONG)D0),((LONG)D1),((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOSAVSetObjAttr	
#define _LVOSAVSetObjAttr			-66
#define SAVSetObjAttr(A0,A1,D0,D1) \
CallModulePPCc(_LVOSAVSetObjAttr,SaverModuleBase,((LONG)D0),((LONG)D1),((LONG *)A0),((LONG *)A1))
#endif

#ifndef _LVOSAVSaveObj	
#define _LVOSAVSaveObj				-72
#define SAVSaveObj(A0) \
CallModulePPCc(_LVOSAVSaveObj,SaverModuleBase,0,0,((LONG *)A0),0)
#ifdef USE_TAGS_STUBS
#define SAVSaveObjTags(tags... ) \
({ULONG _t[]={tags}; \
SAVSaveObj((APTR)_t); \
})
#endif
#endif

#ifndef _LVOSAVFreeObj	
#define _LVOSAVFreeObj				-78
#define SAVFreeObj(A0) \
CallModulePPCc(_LVOSAVFreeObj,SaverModuleBase,0,0,((LONG *)A0),0)
#endif

