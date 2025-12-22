OPT NATIVE
MODULE 'target/aros/preprocessor/variadic/first', 'target/aros/preprocessor/variadic/rest'
->{#include <aros/preprocessor/facilities/is_empty.hpp>}
 NATIVE {AROS_PREPROCESSOR_FACILITIES_IS_EMPTY_HPP} CONST

 NATIVE {AROS_PP_IS_EMPTY} CONST	->AROS_PP_IS_EMPTY(a)    AROS_PP_IS_EMPTY_I(a)
 NATIVE {AROS_PP_IS_EMPTY_I} CONST	->AROS_PP_IS_EMPTY_I(a)  AROS_PP_IS_EMPTY_II(a)
 NATIVE {AROS_PP_IS_EMPTY_II} CONST	->AROS_PP_IS_EMPTY_II(...) AROS_PP_VARIADIC_FIRST( AROS_PP_VARIADIC_REST( AROS_PP_VARIADIC_REST( , # #__VA_ARGS__, 0, 1 ) ) )
