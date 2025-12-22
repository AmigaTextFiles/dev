OPT NATIVE
MODULE 'target/exec/types'
{#include <dos/bptr.h>}
NATIVE {DOS_BPTR_H} CONST

       NATIVE {AROS_BPTR_TYPE}   CONST
       NATIVE {AROS_BSTR_TYPE}   CONST

NATIVE {BPTR} CONST
NATIVE {BSTR} CONST

   NATIVE {MKBADDR} CONST	->MKBADDR(a)               ((BPTR)(a))
   NATIVE {BADDR} CONST	->BADDR(a)                 ((APTR)a)

   NATIVE {AROS_BSTR_ADDR} CONST	->AROS_BSTR_ADDR(s)        ((STRPTR)BADDR(s))
   NATIVE {AROS_BSTR_strlen} CONST	->AROS_BSTR_strlen(s)      (strlen(AROS_BSTR_ADDR(s)))
   NATIVE {AROS_BSTR_setstrlen} CONST	->AROS_BSTR_setstrlen(s,l) (AROS_BSTR_ADDR(s)[l] = 0)
   NATIVE {AROS_BSTR_MEMSIZE4LEN} CONST	->AROS_BSTR_MEMSIZE4LEN(l) ((l)+1)
NATIVE {AROS_BSTR_getchar} CONST	->AROS_BSTR_getchar(s,l)   (AROS_BSTR_ADDR(s)[l])
NATIVE {AROS_BSTR_putchar} CONST	->AROS_BSTR_putchar(s,l,c) (AROS_BSTR_ADDR(s)[l] = c)
