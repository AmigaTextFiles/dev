OPT NATIVE
MODULE 'target/boost/preprocessor/repetition/for', 'target/boost/preprocessor/logical/compl', 'target/boost/preprocessor/punctuation/comma_if', 'target/aros/preprocessor/facilities/is_empty', 'target/aros/preprocessor/variadic/first', 'target/aros/preprocessor/variadic/rest'
->{#include <aros/preprocessor/variadic/cast2iptr.hpp>}
 NATIVE {AROS_PREPROCESSOR_VARIADIC_CAST2IPTR_HPP} CONST

 NATIVE {AROS_PP_VARIADIC_CAST2IPTR_O} CONST	->AROS_PP_VARIADIC_CAST2IPTR_O(_, tuple) (AROS_PP_VARIADIC_REST tuple)

 NATIVE {AROS_PP_VARIADIC_CAST2IPTR_M} CONST	->AROS_PP_VARIADIC_CAST2IPTR_M(_, tuple) (IPTR)(AROS_PP_VARIADIC_FIRST tuple)BOOST_PP_COMMA_IF( AROS_PP_VARIADIC_CAST2IPTR_P(, (AROS_PP_VARIADIC_REST tuple) ) )

 NATIVE {AROS_PP_VARIADIC_CAST2IPTR_P} CONST	->AROS_PP_VARIADIC_CAST2IPTR_P(_, tuple) BOOST_PP_COMPL(AROS_PP_IS_EMPTY(AROS_PP_VARIADIC_FIRST tuple))

 NATIVE {AROS_PP_VARIADIC_CAST2IPTR} CONST	->AROS_PP_VARIADIC_CAST2IPTR(...) BOOST_PP_FOR( (__VA_ARGS__), AROS_PP_VARIADIC_CAST2IPTR_P, AROS_PP_VARIADIC_CAST2IPTR_O, AROS_PP_VARIADIC_CAST2IPTR_M )
