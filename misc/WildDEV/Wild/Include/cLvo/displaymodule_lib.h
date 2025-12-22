#include <exec/types.h>
#include <gcc/compiler.h>

#ifdef __GNUC__
#define USE_TAGS_STUBS
#endif

extern ULONG CallModulePPCc(LONG offset,struct WildModule *BASE,ASMREG(LONG,d0arg,d0),ASMREG(LONG,d1arg,d1),ASMREG(LONG,*a0arg,a0),ASMREG(LONG,*a1arg,a1));

#ifndef _LVOSetModuleTags	
#define _LVOSetModuleTags			-30
#define SetModuleTags(A0,A1) \
CallModulePPCc(_LVOSetModuleTags,DisplayModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOGetModuleTags,DisplayModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOSetupModule,DisplayModuleBase,0,0,((LONG *)A0),((LONG *)A1))
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
CallModulePPCc(_LVOCloseModule,DisplayModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVORefreshModule	
#define _LVORefreshModule			-54
#define RefreshModule(A0) \
CallModulePPCc(_LVORefreshModule,DisplayModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVODISDisplayFrame	
#define _LVODISDisplayFrame			-60
#define DISDisplayFrame(A0) \
CallModulePPCc(_LVODISDisplayFrame,DisplayModuleBase,0,0,((LONG *)A0),0)
#endif

#ifndef _LVODISInitFrame	
#define _LVODISInitFrame			-66
#define DISInitFrame(A0) \
CallModulePPCc(_LVODISInitFrame,DisplayModuleBase,0,0,((LONG *)A0),0)
#endif

