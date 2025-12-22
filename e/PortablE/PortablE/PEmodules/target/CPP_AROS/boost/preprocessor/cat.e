OPT NATIVE
MODULE 'target/boost/preprocessor/config/config'
->{#include <boost/preprocessor/cat.hpp>}
 NATIVE {BOOST_PREPROCESSOR_CAT_HPP} CONST
 
    NATIVE {BOOST_PP_CAT} CONST	->BOOST_PP_CAT(a, b) BOOST_PP_CAT_OO((a, b))
    NATIVE {BOOST_PP_CAT_OO} CONST	->BOOST_PP_CAT_OO(par) BOOST_PP_CAT_I # #par

    NATIVE {BOOST_PP_CAT_I} CONST	->BOOST_PP_CAT_I(a, b) BOOST_PP_CAT_II(a # #b)
    NATIVE {BOOST_PP_CAT_II} CONST	->BOOST_PP_CAT_II(res) res
