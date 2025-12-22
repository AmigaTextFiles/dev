OPT NATIVE
MODULE 'target/boost/preprocessor/config/config'
->{#include <boost/preprocessor/control/iif.hpp>}
 NATIVE {BOOST_PREPROCESSOR_CONTROL_IIF_HPP} CONST

    NATIVE {BOOST_PP_IIF} CONST	->BOOST_PP_IIF(bit, t, f) BOOST_PP_IIF_OO((bit, t, f))
    NATIVE {BOOST_PP_IIF_OO} CONST	->BOOST_PP_IIF_OO(par) BOOST_PP_IIF_I # #par

    NATIVE {BOOST_PP_IIF_I} CONST	->BOOST_PP_IIF_I(bit, t, f) BOOST_PP_IIF_II(BOOST_PP_IIF_ # #bit(t, f))
    NATIVE {BOOST_PP_IIF_II} CONST	->BOOST_PP_IIF_II(id) id

 NATIVE {BOOST_PP_IIF_0} CONST	->BOOST_PP_IIF_0(t, f) f
 NATIVE {BOOST_PP_IIF_1} CONST	->BOOST_PP_IIF_1(t, f) t
