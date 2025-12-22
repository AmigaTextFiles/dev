#include <exec/types.h>
#include <gcc/compiler.h>

#ifdef __GNUC__
#define USE_TAGS_STUBS
#endif

extern ULONG CallModulePPCc(LONG offset,struct WildModule *BASE,ASMREG(LONG,d0arg,d0),ASMREG(LONG,d1arg,d1),ASMREG(LONG,*a0arg,a0),ASMREG(LONG,*a1arg,a1));

#ifndef _LVOSetModuleTags	
#define _LVOSetModuleTags			-30
#define SetModuleTags(A0,A1) \
CallModulePPCc(_LVOSetModuleTags,BrokerModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOGetModuleTags,BrokerModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOSetupModule,BrokerModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOCloseModule,BrokerModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVORefreshModule	
#define _LVORefreshModule			-54
#define RefreshModule(A0) \
CallModulePPCc(_LVORefreshModule,BrokerModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVOBRKBreakOut	
#define _LVOBRKBreakOut			-60
#define BRKBreakOut(A0,A1) \
CallModulePPCc(_LVOBRKBreakOut,BrokerModuleBase,0,0,((LONG *)A0),((LONG *)A1))
#endif

