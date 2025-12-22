#ifndef API_MUI_H
#define API_MUI_H

/*
 *   Copyright © 2006-2013, Marian 'MaaG^dA' Guc  All rights reserved.
 *   $Id: api_mui macros for AmigaOS4.x 2013/05/19 ZaP && MiniQ && MaaG^dA Exp $
 */

#ifndef MAKE_ID
	#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#undef __USE_INLINE__
#define __USE_INLINE__

#ifndef __USE_BASETYPE__
  #define __USE_BASETYPE__
  #include <proto/intuition.h>
  #undef __USE_BASETYPE__
#else
  #include <proto/intuition.h>
#endif

#include <proto/muimaster.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* hook macro */

#define HOOK_h(name)\
	extern struct Hook HOOK_##name

#define HOOK_REF(name) \
	&HOOK_##name

#define HOOK(name, ptr_obj, ptr_msg) \
	int32 GATE_Hook_##name(struct Hook *hook, ptr_obj obj, ptr_msg msg); \
	struct Hook HOOK_##name = { {NULL, NULL}, (HOOKFUNC)GATE_Hook_##name, NULL, NULL}; \
	int32 GATE_Hook_##name(struct Hook *hook, ptr_obj obj, ptr_msg msg) \
		{

#define HOOK_END(__RetValue) \
	return ((uint32) __RetValue); }

/* dispatcher macro */

#define DISPATCHER(ClassNAME) \
	int32 ClassNAME##Dispatcher(struct IClass *cl, Object *obj, Msg msg) \
		{

#define DISPATCHER_BEGIN \
		switch (msg->MethodID) \
			{

#define CALL_METHOD(ClassNAME, ID, msg_type) \
	 case ID: return (ClassNAME##_##ID(cl, obj, (msg_type)msg));

#define DISPATCHER_END \
			}; \
		return ((int32) DoSuperMethodA(cl, obj, msg)); \
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
