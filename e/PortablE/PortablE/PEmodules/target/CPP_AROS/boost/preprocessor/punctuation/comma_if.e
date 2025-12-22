OPT NATIVE
MODULE 'target/boost/preprocessor/config/config', 'target/boost/preprocessor/control/if', 'target/boost/preprocessor/facilities/empty', 'target/boost/preprocessor/punctuation/comma'
->{#include <boost/preprocessor/punctuation/comma_if.hpp>}
 NATIVE {BOOST_PREPROCESSOR_PUNCTUATION_COMMA_IF_HPP} CONST

    NATIVE {BOOST_PP_COMMA_IF} CONST	->BOOST_PP_COMMA_IF(cond) BOOST_PP_COMMA_IF_I(cond)
    NATIVE {BOOST_PP_COMMA_IF_I} CONST	->BOOST_PP_COMMA_IF_I(cond) BOOST_PP_IF(cond, BOOST_PP_COMMA, BOOST_PP_EMPTY)()
