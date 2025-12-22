->obsolete now?
OPT NATIVE
MODULE 'target/intuition/classes', 'target/aros/debug', 'target/aros/asmcall'
MODULE 'target/amigalib'	->work-around a bug in Icaros Desktop Live v2.0.3, which causes compilation to fail when 'clib/boopsistubs.h' is included before 'clib/alib_protos.h'.
{#include <clib/boopsistubs.h>}
NATIVE {BOOPSISTUBS_H} CONST

NATIVE {USE_BOOPSI_STUBS} CONST

	NATIVE {_CALL_DISPATCHER} PROC	->_CALL_DISPATCHER(entry, cl, o, msg) AROS_UFC3(IPTR, entry, AROS_UFCA(Class *, cl, A0), AROS_UFCA(Object *, o, A2), AROS_UFCA(APTR, msg, A1))

	NATIVE {INLINE} CONST ->INLINE = static inline


->disabled because these are already declared by 'intuition'

->        NATIVE {CoerceMethodA} PROC	->CoerceMethodA(cl, o, msg) ({ ASSERT_VALID_PTR(cl); ASSERT_VALID_PTR_OR_NULL(o); _CALL_DISPATCHER(cl->cl_Dispatcher.h_Entry, cl, o, msg); })
    
->        NATIVE {DoSuperMethodA} PROC	->DoSuperMethodA(cl, o, msg) ({ Class *_cl; ASSERT_VALID_PTR(cl); ASSERT_VALID_PTR_OR_NULL(o); _cl = cl->cl_Super; ASSERT_VALID_PTR(_cl); _CALL_DISPATCHER(_cl->cl_Dispatcher.h_Entry, _cl, o, msg); })
    
->        NATIVE {DoMethodA} PROC	->DoMethodA(o, msg) ({ Class *_cl; ASSERT_VALID_PTR(o); _cl = OCLASS(o); ASSERT_VALID_PTR(_cl); _CALL_DISPATCHER(_cl->cl_Dispatcher.h_Entry, _cl, o, msg); })
    
->        NATIVE {CoerceMethod} PROC	->CoerceMethod(cl, o, msg...) ({ IPTR _msg[] = { msg }; ASSERT_VALID_PTR(cl); ASSERT_VALID_PTR_OR_NULL(o); _CALL_DISPATCHER(cl->cl_Dispatcher.h_Entry, cl, o, _msg); })
    
->        NATIVE {DoSuperMethod} PROC	->DoSuperMethod(cl, o, msg...) ({ Class *_cl; IPTR _msg[] = { msg }; ASSERT_VALID_PTR(cl); ASSERT_VALID_PTR_OR_NULL(o); _cl = cl->cl_Super; ASSERT_VALID_PTR(_cl); _CALL_DISPATCHER(_cl->cl_Dispatcher.h_Entry, _cl, o, _msg); })
    
->        NATIVE {DoMethod} PROC	->DoMethod(o, msg...) ({ Class *_cl; IPTR _msg[] = { msg }; ASSERT_VALID_PTR(o); _cl = OCLASS(o); ASSERT_VALID_PTR_OR_NULL(_cl); _CALL_DISPATCHER(_cl->cl_Dispatcher.h_Entry, _cl, o, _msg); })
    
        /* Var-args stub for the OM_NOTIFY method */
        NATIVE {NotifyAttrs} PROC	->NotifyAttrs(o, gi, flags, attrs...) ({ Class *_cl; IPTR _attrs[] = { attrs }; IPTR _msg[] = { OM_NOTIFY, (IPTR)_attrs, (IPTR)gi, flags }; ASSERT_VALID_PTR(o); _cl = OCLASS(o); ASSERT_VALID_PTR(_cl); ASSERT_VALID_PTR_OR_NULL(gi); _CALL_DISPATCHER(_cl->cl_Dispatcher.h_Entry, _cl, o, _msg); })
    
        /* Var-args stub for the OM_UPDATE method */
        NATIVE {UpdateAttrs} PROC	->UpdateAttrs(o, gi, flags, attrs...) ({ Class *_cl; IPTR _attrs[] = { attrs }; IPTR _msg[] = { OM_UPDATE, (IPTR)_attrs, (IPTR)gi, flags }; ASSERT_VALID_PTR(o); _cl = OCLASS(o); ASSERT_VALID_PTR(_cl); ASSERT_VALID_PTR_OR_NULL(gi); _CALL_DISPATCHER(_cl->cl_Dispatcher.h_Entry, _cl, o, _msg); })
