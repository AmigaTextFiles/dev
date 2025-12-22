#ifndef API_MUI_H
#define API_MUI_H

/*
 *   Copyright © 2006-2013, Marian 'MaaG^dA' Guc  All rights reserved.
 *   $Id: api_mui macros for MorphOS 2013/05/19 MaaG^dA Exp $
 */

#ifndef MAKE_ID
	#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#include <proto/intuition.h>
#include <proto/alib.h>

#include <proto/muimaster.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* hook macro */

#define HOOK_h(name) \
	extern struct Hook HOOK_##name

#define HOOK_REF(name) \
	&HOOK_##name

#define HOOK(name, ptr_obj, ptr_msg) \
	IPTR GATE_HOOK_##name(void); \
	struct EmulLibEntry Emul_HOOK_##name = { TRAP_LIB, 0, (void (*)(void))GATE_HOOK_##name## }; \
	struct Hook HOOK_##name = { {NULL, NULL}, (void *)&Emul_HOOK_##name , NULL, NULL}; \
	IPTR GATE_HOOK_##name##(void) \
		{	struct Hook *hook= (struct Hook*)REG_A0; \
			ptr_obj obj = (ptr_obj)REG_A2; \
			ptr_msg msg = (ptr_msg)REG_A1;

#define HOOK_END(__RetValue) \
	return((IPTR) __RetValue);	}

/* dispatcher macro */

#define DISPATCHER(ClassNAME) \
	IPTR ClassNAME##_Dispatcher(void); \
	struct EmulLibEntry GATE_##ClassNAME##_Dispatcher = { TRAP_LIB, 0, (void (*)(void)) ClassNAME##_Dispatcher }; \
	IPTR ClassNAME##_Dispatcher(void) \
		{	struct IClass *cl = (struct IClass*)REG_A0; \
			Object *obj = (Object*)REG_A2; \
			Msg msg = (Msg)REG_A1;

#define DISPATCHER_BEGIN \
		switch (msg->MethodID) \
			{

#define CALL_METHOD(ClassNAME, ID, msg_type) \
	 case ID: return(ClassNAME##_##ID(cl, obj, (msg_type)msg));

#define DISPATCHER_END \
			}; \
		return (DoSuperMethodA(cl, obj, msg)); \
		}

#define DISPATCHER_REF(ClassNAME) &GATE_##ClassNAME##_Dispatcher

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

#endif API_MUI_H
