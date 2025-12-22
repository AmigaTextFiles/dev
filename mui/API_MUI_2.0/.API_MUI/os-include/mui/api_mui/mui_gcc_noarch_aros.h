#ifndef API_MUI_H
#define API_MUI_H

/*
 *   Copyright © 2006-2013, Marian 'MaaG^dA' Guc  All rights reserved.
 *   $Id: api_mui macros for AROS 2013/05/19 Michal Schulz && MaaG^dA Exp $
 */

#ifndef MAKE_ID
	#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#include <proto/intuition.h>
#include <proto/alib.h>
#include <libraries/mui.h>
#include <proto/muimaster.h>

#include <utility/hooks.h>
#include <aros/asmcall.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* hook macro */

#define HOOK_h(name)\
	extern struct Hook HOOK_##name

#define HOOK_REF(name) \
	&HOOK_##name

#define HOOK(name, ptr_obj, ptr_msg) \
	AROS_UFP3(IPTR, GATE_Hook_##name, AROS_UFPA(struct Hook *, hook, A0), AROS_UFPA(ptr_obj, obj, A2), AROS_UFPA(ptr_msg, msg, A1)); \
	struct Hook HOOK_##name = { {NULL, NULL}, (HOOKFUNC)GATE_Hook_##name, NULL, NULL}; \
	AROS_UFH3(IPTR, GATE_Hook_##name, AROS_UFHA(struct Hook *, hook, A0), AROS_UFHA(ptr_obj, obj, A2), AROS_UFHA(ptr_msg, msg, A1)); \
		{ AROS_USERFUNC_INIT

#define HOOK_END(__RetValue) \
	return ((IPTR) __RetValue); AROS_USERFUNC_EXIT }

/* dispatcher macro */

#define DISPATCHER(ClassNAME) \
	AROS_UFH3S(IPTR, ClassNAME##Dispatcher, \
	    AROS_UFHA(struct IClass *, cl, A0), \
	    AROS_UFHA(Object *, obj, A2), \
	    AROS_UFHA(Msg, msg, A1)) \
		{ AROS_USERFUNC_INIT

#define DISPATCHER_BEGIN \
		switch (msg->MethodID) \
			{

#define CALL_METHOD(ClassNAME, ID, msg_type) \
	 case ID: return (ClassNAME##_##ID(cl, obj, (msg_type)msg));

#define DISPATCHER_END \
			}; \
		return ((IPTR) DoSuperMethodA(cl, obj, msg)); \
		AROS_USERFUNC_EXIT }

#define DISPATCHER_REF(ClassNAME) ClassNAME##Dispatcher

#define CLASS_METHOD(ClassNAME, ID, msg_type) \
	IPTR ClassNAME##_##ID(Class *cl, Object *obj, msg_type msg) \
		{

#define CLASS_METHOD_END(__RetValue) \
	return((IPTR) __RetValue); \
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

#endif /* API_MUI_H */
