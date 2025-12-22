OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types/__sigval_t'
->{#include <x86_64-linux-gnu/bits/types/sigval_t.h>}
->NATIVE {__sigval_t_defined} DEF

/* To avoid sigval_t (not a standard type name) having C++ name
   mangling depending on whether the selected standard includes union
   sigval, it should not be defined at all when using a standard for
   which the sigval name is not reserved; in that case, headers should
   not include <bits/types/sigval_t.h> and should use only the
   internal __sigval_t name.  */

->NATIVE {sigval_t} OBJECT
->TYPE sigval_t IS NATIVE {sigval_t} __sigval_t
