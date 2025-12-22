/* $Id: system.h 29223 2008-08-22 11:02:18Z sonic $ */
OPT NATIVE
MODULE 'target/aros/cpu'
/*{#include <aros/system.h>}*/
NATIVE {AROS_SYSTEM_H} CONST

NATIVE {_AMIGA} DEF
NATIVE {AMIGA} CONST

/* 4. Macros for debugging and development */
->   NATIVE {AROS_64BIT_TYPE} CONST
   NATIVE {AROS_HAVE_LONG_LONG} CONST

/* 5. Calculated #defines */
   NATIVE {AROS_SLOWSTACKTAGS} CONST
   NATIVE {AROS_SLOWSTACKMETHODS} CONST

   NATIVE {AROS_ASMSYMNAME} CONST	->AROS_ASMSYMNAME(n) n

       NATIVE {AROS_CSYM_FROM_ASM_NAME} CONST	->AROS_CSYM_FROM_ASM_NAME(n) n

/* Makes a 'new' symbol which occupies the same memory location as the 'old' symbol */
   NATIVE {AROS_MAKE_ALIAS} CONST	->AROS_MAKE_ALIAS(old, new)

/* define an asm symbol 'asym' with a C name 'csym', type 'type' and with value 'value'.
   'value' has to be an asm constant, thus either an address number or an asm symbol name, */
    NATIVE {AROS_MAKE_ASM_SYM} CONST	->AROS_MAKE_ASM_SYM(type, csym, asym, value)

/* Makes an ASM symbol 'asym' available for use in the compilation unit this
   macro is used, with a C name 'csym'. This has also the side effect of
   triggering the inclusion, by the linker, of all code and data present in the
   module where the ASM symbol is actually defined.  */
    NATIVE {AROS_IMPORT_ASM_SYM} CONST	->AROS_IMPORT_ASM_SYM(type, csym, asym)

/* Make sure other compilation units can see the symbol 'asym' created with AROS_MAKE_ASM_SYM.
   This macro results in a compile-time error in case it's used BEFORE the symbol has been
   made with AROS_MAKE_ASM_SYM.  */
    NATIVE {AROS_EXPORT_ASM_SYM} CONST ->AROS_EXPORT_ASM_SYM(asym)
