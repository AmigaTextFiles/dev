//
//MSG(category, code, pos, text) 
//
// Macro parameter "pos" is 1 if message is position dependetn and it's 
// location should be included in history, otherwize if 0 - message is position
// independent and fully qualified by code and parameters.
//
// Parameters %0s and %1d are used for file name and line number within file,
// so all parameters used in messages should start from %2.
// Possible formats are 'd' for integer, 's' for zero terminated strings,
// 'm' for methods, 'c' for classes, 'u' for utf8 strings.
//

//
// Synchronization
//
MSG(deadlock,sync_loop,0,"Loop %2d: invocation of synchronized method %3m can cause deadlock")
MSG(deadlock,loop,0,"Loop %2d/%3d: invocation of method %4m forms the loop in class dependency graph")
MSG(deadlock,wait,0,"Method wait() can be invoked with monitor of other object locked")
MSG(deadlock,wait_path,0,"Call sequence to method %2m can cause deadlock in wait()")
MSG(race_condition,nosync,0,"Synchronized method %2m is overridden by non-synchronized method of derived class '%3c'")
MSG(race_condition,concurrent_call,0,"Method %2m can be called from different threads and is not synchronized")
MSG(race_condition,concurrent_access,0,"Field '%2u' of class '%3c' can be accessed from different threads and is not volatile")
MSG(race_condition,run_nosync,0,"Method %2m implementing 'Runnable' interface is not synchronized")
MSG(wait_nosync,wait_nosync,0,"Method %2u is called from non-synchronized method")

//
// Inheritance
//
MSG(not_overridden,not_overridden,0,"Method %2m is not overridden by method with the same name of derived class '%3c'")
MSG(field_redefined,field_redefined,0,"Component '%2u' in class '%3c' shadows one in base class '%4c'")
MSG(shadow_local,shadow_local,1,"Local variable '%2u' shadows component of class '%3c'")
MSG(super_finalize,super_finalize,0,"Method finalize() doesn't call super.finalize()")

//
// Data flow 
// 
MSG(null_reference,null_param,0,"Method %2m can be invoked with NULL as %3d parameter and this parameter is used without check for NULL")
MSG(null_reference,null_var,1,"Value of referenced variable '%2u' may be NULL")
MSG(null_reference,null_ptr,1,"NULL reference can be used")
MSG(zero_operand,zero_operand,1,"Zero operand for %2s operation") 
MSG(zero_result,zero_result,1,"Result of operation %2s is always 0") 
MSG(domain,shift_count,1,"Shift %2s with count %3s than %4d")
MSG(domain,shift_range,1,"Shift %2s count range [%3d,%4d] is out of domain")
MSG(domain,conversion,1,"Range of expression value has no intersection with %2s type domain")
MSG(truncation,truncation,1,"Data can be lost as a result of truncation to %2s")
MSG(overflow,overflow,1,"May be type cast is not correctly applied")
MSG(redundant,same_result,1,"Comparison always produce the same result")
MSG(redundant,disjoint_mask,1,"Compared expressions can be equal only when both of them are 0")
MSG(redundant,no_effect,1,"Reminder always equal to the first operand") 
MSG(short_char_cmp,short_char_cmp,1,"Comparison of short with char")
MSG(string_cmp,string_cmp,1,"Compare strings as object references")
MSG(weak_cmp,weak_cmp,1,"Inequality comparison can be replaced with equality comparison")
MSG(incomp_case, incomp_case,1,"Switch case constant %2d can't be produced by switch expression")
MSG(bounds, neg_len,1,"Array length [%2d,%3d] is less than zero")
MSG(bounds, maybe_neg_len,1,"Array length [%2d,%3d] may be less than zero")
MSG(bounds, bad_index,1,"Index [%2d,%3d] is out of array bounds")
MSG(bounds, maybe_bad_index,1,"Index [%2d,%3d] may be out of array bounds")

// Special case: no location prefix is appended to this message
MSG(done, done, 0, "Verification completed: %0d reported messages")

#undef MSG




