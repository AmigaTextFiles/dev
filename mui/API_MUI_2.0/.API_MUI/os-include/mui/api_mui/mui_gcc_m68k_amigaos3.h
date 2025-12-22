#ifndef API_MUI_H
#define API_MUI_H

/*
 *   Copyright © 2006-2013, Marian 'MaaG^dA' Guc  All rights reserved.
 *   $Id: api_mui macros for AmigaOS3.x 2013/05/19 MaaG^dA Exp $
 */

#ifndef MAKE_ID
	#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#include <proto/alib.h>
#include <libraries/mui.h>
#include <clib/muimaster_protos.h>

#if defined(__GNUC__)
	#define STDARGS
	#define REGARGS
	#define INLINE
	#define SAVEDS
	#define ASM    __asm
	#define REG(_VAR_TYPE_, _VAR_NAME_, _REG_)	_VAR_TYPE_ _VAR_NAME_ __asm(#_REG_)
#endif

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* hook macro */

#define HOOK_h(name)\
	extern struct Hook HOOK_##name

#define HOOK_REF(name) \
	&HOOK_##name

#define HOOK(name, ptr_obj, ptr_msg) \
	LONG SAVEDS GATE_Hook_##name( REG(struct Hook *, hook, a0), REG(ptr_obj, obj, a2), REG(ptr_msg, msg, a1) ); \
	struct Hook HOOK_##name = { {NULL, NULL}, (HOOKFUNC)GATE_Hook_##name, NULL, NULL}; \
	LONG SAVEDS GATE_Hook_##name( REG(struct Hook *, hook, a0), REG(ptr_obj, obj, a2), REG(ptr_msg, msg, a1))\
		{

#define HOOK_END(__RetValue) \
	return ((LONG) __RetValue); }

/* dispatcher macro */

#define DISPATCHER(ClassNAME) \
	LONG SAVEDS ClassNAME##Dispatcher(REG(struct IClass *, cl, a0), REG(Object *, obj, a2), REG(Msg, msg, a1)) \
		{

#define DISPATCHER_BEGIN \
		switch (msg->MethodID) \
			{

#define CALL_METHOD(ClassNAME, ID, msg_type) \
	 case ID: return(ClassNAME##_##ID(cl, obj, (msg_type)msg));

#define DISPATCHER_END \
			}; \
		return ((LONG) DoSuperMethodA(cl, obj, msg)); \
		}

#define DISPATCHER_REF(ClassNAME) ClassNAME##Dispatcher

#define CLASS_METHOD(ClassNAME, ID, msg_type) \
	ULONG ClassNAME##_##ID(Class *cl, Object *obj, msg_type msg) \
		{

#define CLASS_METHOD_END(__RetValue) \
	return((ULONG) __RetValue); \
	}

/* create & delete custom class macro */

#define CREATEEXTERNALCLASS(ClassNAME, base, ClassStructData) \
	MUI_CreateCustomClass(base, NULL, NULL, sizeof(ClassStructData), DISPATCHER_REF(ClassNAME))

#define CREATEPUBLICCLASS(ClassNAME, parent_name, ClassStructData) \
	MUI_CreateCustomClass(NULL, parent_name, NULL, sizeof(ClassStructData), DISPATCHER_REF(ClassNAME))

#define CREATELOCALCLASS(ClassNAME, parent_class, ClassStructData) \
	MUI_CreateCustomClass(NULL, NULL, parent_class, sizeof(ClassStructData), DISPATCHER_REF(ClassNAME))

#define DELETECUSTOMCLASS(CustomClassNAME) \
	MUI_DeleteCustomClass((struct MUI_CustomClass*) CustomClassNAME)

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif API_MUI_H
