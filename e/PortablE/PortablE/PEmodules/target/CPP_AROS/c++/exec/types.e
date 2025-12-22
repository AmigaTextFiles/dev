/* $Id: types.hpp 25103 2006-12-24 10:16:13Z weissms $ */
OPT NATIVE
MODULE /*'target/exec/types',*/ 'target/aros/macros', 'target/c++/swappedtype'
->{#include <c++/exec/types.hpp>}
NATIVE {AROS_CXX_EXEC_TYPES_HPP} CONST

    /* Some useful types, in their big and little endian version. */

NATIVE {BEWORD} CONST
NATIVE {BELONG} CONST
NATIVE {BEQUAD} CONST

NATIVE {BEUWORD} CONST
NATIVE {BEULONG} CONST
NATIVE {BEUQUAD} CONST

NATIVE {BEAPTR} CONST

NATIVE {LEWORD} CONST               
NATIVE {LELONG} CONST               
NATIVE {LEQUAD} CONST               

NATIVE {LEUWORD} CONST               
NATIVE {LEULONG} CONST
NATIVE {LEUQUAD} CONST

NATIVE {LEAPTR} CONST

NATIVE {BEPTR} CONST	->BEPTR(type) aros::SwappedType<type *>
NATIVE {LEPTR} CONST	->LEPTR(type) type *

NATIVE {LEBYTE} CONST
NATIVE {BEBYTE} CONST
NATIVE {LEUBYTE} CONST
NATIVE {BEUBYTE} CONST
