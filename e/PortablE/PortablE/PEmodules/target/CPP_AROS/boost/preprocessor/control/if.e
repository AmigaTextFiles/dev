OPT NATIVE
MODULE 'target/boost/preprocessor/config/config', 'target/boost/preprocessor/control/iif', 'target/boost/preprocessor/logical/bool'
->{#include <boost/preprocessor/control/if.hpp>}
 NATIVE {BOOST_PREPROCESSOR_CONTROL_IF_HPP} CONST

    NATIVE {BOOST_PP_IF} CONST	->BOOST_PP_IF(cond, t, f) BOOST_PP_IF_I(cond, t, f)
    NATIVE {BOOST_PP_IF_I} CONST	->BOOST_PP_IF_I(cond, t, f) BOOST_PP_IIF(BOOST_PP_BOOL(cond), t, f)
