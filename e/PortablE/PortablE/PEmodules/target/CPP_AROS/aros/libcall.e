/* $Id: libcall.h 28952 2008-06-30 20:48:25Z verhaegs $ */
OPT NATIVE
MODULE 'target/aros/system'
PUBLIC MODULE 'target/aros/aros_shared'
/*{#include <aros/libcall.h>}*/
NATIVE {AROS_LIBCALL_H} CONST

/* System-Specific things */

->NATIVE {VOID_FUNC} CONST	->typedef void (*VOID_FUNC)()
->NATIVE {LONG_FUNC} CONST	->typedef int (*LONG_FUNC)()
->NATIVE {ULONG_FUNC} CONST	->typedef unsigned int (*ULONG_FUNC)()

   NATIVE {AROS_SLIB_ENTRY} CONST	->AROS_SLIB_ENTRY(n,s)   __AROS_SLIB_ENTRY(n,s)

/* Library functions which need the libbase */
NATIVE {AROS_LHQUAD1} CONST	->AROS_LHQUAD1(t,n,a1,bt,bn,o,s)
NATIVE {AROS_LHQUAD2} CONST	->AROS_LHQUAD2(t,n,a1,a2,bt,bn,o,s)

NATIVE {AROS_LH0} CONST	->AROS_LH0(t,n,bt,bn,o,s)
NATIVE {AROS_LH1} CONST	->AROS_LH1(t,n,a1,bt,bn,o,s)
NATIVE {AROS_LH2} CONST	->AROS_LH2(t,n,a1,a2,bt,bn,o,s)
NATIVE {AROS_LH3} CONST	->AROS_LH3(t,n,a1,a2,a3,bt,bn,o,s)
NATIVE {AROS_LH4} CONST	->AROS_LH4(t,n,a1,a2,a3,a4,bt,bn,o,s)
NATIVE {AROS_LH5} CONST	->AROS_LH5(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
NATIVE {AROS_LH6} CONST	->AROS_LH6(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
NATIVE {AROS_LH7} CONST	->AROS_LH7(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
NATIVE {AROS_LH8} CONST	->AROS_LH8(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
NATIVE {AROS_LH9} CONST	->AROS_LH9(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
NATIVE {AROS_LH10} CONST	->AROS_LH10(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
NATIVE {AROS_LH11} CONST	->AROS_LH11(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
NATIVE {AROS_LH12} CONST	->AROS_LH12(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
NATIVE {AROS_LH13} CONST	->AROS_LH13(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
NATIVE {AROS_LH14} CONST	->AROS_LH14(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
NATIVE {AROS_LH15} CONST	->AROS_LH15(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

/* Library functions which don't need the libbase */
NATIVE {AROS_LH0I} CONST	->AROS_LH0I(t,n,bt,bn,o,s)
NATIVE {AROS_LH1I} CONST	->AROS_LH1I(t,n,a1,bt,bn,o,s)
NATIVE {AROS_LH2I} CONST	->AROS_LH2I(t,n,a1,a2,bt,bn,o,s)
NATIVE {AROS_LH3I} CONST	->AROS_LH3I(t,n,a1,a2,a3,bt,bn,o,s)
NATIVE {AROS_LH4I} CONST	->AROS_LH4I(t,n,a1,a2,a3,a4,bt,bn,o,s)
NATIVE {AROS_LH5I} CONST	->AROS_LH5I(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
NATIVE {AROS_LH6I} CONST	->AROS_LH6I(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
NATIVE {AROS_LH7I} CONST	->AROS_LH7I(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
NATIVE {AROS_LH8I} CONST	->AROS_LH8I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
NATIVE {AROS_LH9I} CONST	->AROS_LH9I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
NATIVE {AROS_LH10I} CONST	->AROS_LH10I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
NATIVE {AROS_LH11I} CONST	->AROS_LH11I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
NATIVE {AROS_LH12I} CONST	->AROS_LH12I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
NATIVE {AROS_LH13I} CONST	->AROS_LH13I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
NATIVE {AROS_LH14I} CONST	->AROS_LH14I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
NATIVE {AROS_LH15I} CONST	->AROS_LH15I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

/* Call a library function which requires the libbase */
NATIVE {AROS_LCQUAD1} CONST	->AROS_LCQUAD1(t,n,a1,bt,bn,o,s)
NATIVE {AROS_LCQUAD2} CONST	->AROS_LCQUAD2(t,n,a1,a2,bt,bn,o,s)

NATIVE {AROS_LC0} CONST	->AROS_LC0(t,n,bt,bn,o,s)
NATIVE {AROS_LC1} CONST	->AROS_LC1(t,n,a1,bt,bn,o,s)
NATIVE {AROS_LC2} CONST	->AROS_LC2(t,n,a1,a2,bt,bn,o,s)
NATIVE {AROS_LC3} CONST	->AROS_LC3(t,n,a1,a2,a3,bt,bn,o,s)
NATIVE {AROS_LC4} CONST	->AROS_LC4(t,n,a1,a2,a3,a4,bt,bn,o,s)
NATIVE {AROS_LC5} CONST	->AROS_LC5(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
NATIVE {AROS_LC6} CONST	->AROS_LC6(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
NATIVE {AROS_LC7} CONST	->AROS_LC7(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
NATIVE {AROS_LC8} CONST	->AROS_LC8(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
NATIVE {AROS_LC9} CONST	->AROS_LC9(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
NATIVE {AROS_LC10} CONST	->AROS_LC10(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
NATIVE {AROS_LC11} CONST	->AROS_LC11(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
NATIVE {AROS_LC12} CONST	->AROS_LC12(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
NATIVE {AROS_LC13} CONST	->AROS_LC13(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
NATIVE {AROS_LC14} CONST	->AROS_LC14(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
NATIVE {AROS_LC15} CONST	->AROS_LC15(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

/* Call a library function which doesn't require the libbase */
NATIVE {AROS_LC0I} CONST	->AROS_LC0I(t,n,bt,bn,o,s)
NATIVE {AROS_LC1I} CONST	->AROS_LC1I(t,n,a1,bt,bn,o,s)
NATIVE {AROS_LC2I} CONST	->AROS_LC2I(t,n,a1,a2,bt,bn,o,s)
NATIVE {AROS_LC3I} CONST	->AROS_LC3I(t,n,a1,a2,a3,bt,bn,o,s)
NATIVE {AROS_LC4I} CONST	->AROS_LC4I(t,n,a1,a2,a3,a4,bt,bn,o,s)
NATIVE {AROS_LC5I} CONST	->AROS_LC5I(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
NATIVE {AROS_LC6I} CONST	->AROS_LC6I(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
NATIVE {AROS_LC7I} CONST	->AROS_LC7I(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
NATIVE {AROS_LC8I} CONST	->AROS_LC8I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
NATIVE {AROS_LC9I} CONST	->AROS_LC9I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
NATIVE {AROS_LC10I} CONST	->AROS_LC10I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
NATIVE {AROS_LC11I} CONST	->AROS_LC11I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
NATIVE {AROS_LC12I} CONST	->AROS_LC12I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
NATIVE {AROS_LC13I} CONST	->AROS_LC13I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
NATIVE {AROS_LC14I} CONST	->AROS_LC14I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
NATIVE {AROS_LC15I} CONST	->AROS_LC15I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

/* Special calls: Call a library function without the name just by the ADDRESS */
NATIVE {AROS_CALL0} CONST	->AROS_CALL0(returntype,address,basetype,basename)

NATIVE {AROS_CALL1} CONST	->AROS_CALL1(t,a,a1,bt,bn)

NATIVE {AROS_CALL2} CONST	->AROS_CALL2(t,a,a1,a2,bt,bn)
NATIVE {AROS_CALL3} CONST	->AROS_CALL3(t,a,a1,a2,a3,bt,bn)
NATIVE {AROS_CALL4} CONST	->AROS_CALL4(t,a,a1,a2,a3,a4,bt,bn)

NATIVE {AROS_CALL5} CONST	->AROS_CALL5(t,a,a1,a2,a3,a4,a5,bt,bn)

NATIVE {AROS_CALL6} CONST	->AROS_CALL6(t,a,a1,a2,a3,a4,a5,a6,bt,bn)

NATIVE {AROS_CALL7} CONST	->AROS_CALL7(t,a,a1,a2,a3,a4,a5,a6,a7,bt,bn)

NATIVE {AROS_CALL8} CONST	->AROS_CALL8(t,a,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn)

/* Special calls: Call a library function without the name just by the OFFSET */

NATIVE {AROS_LVO_CALL0} CONST	->AROS_LVO_CALL0(returntype,basetype,basename,offset,system)

NATIVE {AROS_LVO_CALL0NR} CONST	->AROS_LVO_CALL0NR(basetype,basename,offset,system)

NATIVE {AROS_LVO_CALL1} CONST	->AROS_LVO_CALL1(t,a1,bt,bn,o,s)

NATIVE {AROS_LVO_CALL1NR} CONST	->AROS_LVO_CALL1NR(a1,bt,bn,o,s)

NATIVE {AROS_LVO_CALL2} CONST	->AROS_LVO_CALL2(t,a1,a2,bt,bn,o,s)

NATIVE {AROS_LVO_CALL2NR} CONST	->AROS_LVO_CALL2NR(a1,a2,bt,bn,o,s)

NATIVE {AROS_LVO_CALL3} CONST	->AROS_LVO_CALL3(t,a1,a2,a3,bt,bn,o,s)

NATIVE {AROS_LVO_CALL3NR} CONST	->AROS_LVO_CALL3NR(a1,a2,a3,bt,bn,o,s)

NATIVE {AROS_LVO_CALL4} CONST	->AROS_LVO_CALL4(t,a1,a2,a3,a4,bt,bn,o,s)

NATIVE {AROS_LVO_CALL4NR} CONST	->AROS_LVO_CALL4NR(a1,a2,a3,a4,bt,bn,o,s)

NATIVE {AROS_LVO_CALL5} CONST	->AROS_LVO_CALL5(t,a1,a2,a3,a4,a5,bt,bn,o,s)

NATIVE {AROS_LVO_CALL5NR} CONST	->AROS_LVO_CALL5NR(a1,a2,a3,a4,a5,bt,bn,o,s)

   NATIVE {AROS_LPQUAD1} CONST	->AROS_LPQUAD1(t,n,a1,bt,bn,o,s)
   NATIVE {AROS_LPQUAD2} CONST	->AROS_LPQUAD2(t,n,a1,a2,bt,bn,o,s)

   NATIVE {AROS_LP0} CONST	->AROS_LP0(t,n,bt,bn,o,s)
   NATIVE {AROS_LP1} CONST	->AROS_LP1(t,n,a1,bt,bn,o,s)
   NATIVE {AROS_LP2} CONST	->AROS_LP2(t,n,a1,a2,bt,bn,o,s)
   NATIVE {AROS_LP3} CONST	->AROS_LP3(t,n,a1,a2,a3,bt,bn,o,s)
   NATIVE {AROS_LP4} CONST	->AROS_LP4(t,n,a1,a2,a3,a4,bt,bn,o,s)
   NATIVE {AROS_LP5} CONST	->AROS_LP5(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
   NATIVE {AROS_LP6} CONST	->AROS_LP6(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
   NATIVE {AROS_LP7} CONST	->AROS_LP7(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
   NATIVE {AROS_LP8} CONST	->AROS_LP8(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
   NATIVE {AROS_LP9} CONST	->AROS_LP9(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
   NATIVE {AROS_LP10} CONST	->AROS_LP10(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
   NATIVE {AROS_LP11} CONST	->AROS_LP11(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
   NATIVE {AROS_LP12} CONST	->AROS_LP12(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
   NATIVE {AROS_LP13} CONST	->AROS_LP13(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
   NATIVE {AROS_LP14} CONST	->AROS_LP14(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
   NATIVE {AROS_LP15} CONST	->AROS_LP15(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

   NATIVE {AROS_LP0I} CONST	->AROS_LP0I(t,n,bt,bn,o,s)
   NATIVE {AROS_LP1I} CONST	->AROS_LP1I(t,n,a1,bt,bn,o,s)
   NATIVE {AROS_LP2I} CONST	->AROS_LP2I(t,n,a1,a2,bt,bn,o,s)
   NATIVE {AROS_LP3I} CONST	->AROS_LP3I(t,n,a1,a2,a3,bt,bn,o,s)
   NATIVE {AROS_LP4I} CONST	->AROS_LP4I(t,n,a1,a2,a3,a4,bt,bn,o,s)
   NATIVE {AROS_LP5I} CONST	->AROS_LP5I(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
   NATIVE {AROS_LP6I} CONST	->AROS_LP6I(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
   NATIVE {AROS_LP7I} CONST	->AROS_LP7I(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
   NATIVE {AROS_LP8I} CONST	->AROS_LP8I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
   NATIVE {AROS_LP9I} CONST	->AROS_LP9I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
   NATIVE {AROS_LP10I} CONST	->AROS_LP10I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
   NATIVE {AROS_LP11I} CONST	->AROS_LP11I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
   NATIVE {AROS_LP12I} CONST	->AROS_LP12I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
   NATIVE {AROS_LP13I} CONST	->AROS_LP13I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
   NATIVE {AROS_LP14I} CONST	->AROS_LP14I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
   NATIVE {AROS_LP15I} CONST	->AROS_LP15I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

/* Declarations for library functions which need the libbase */
   NATIVE {AROS_LDQUAD1} CONST	->AROS_LDQUAD1(t,n,a1,bt,bn,o,s)
   NATIVE {AROS_LDQUAD2} CONST	->AROS_LDQUAD2(t,n,a1,a2,bt,bn,o,s)

   NATIVE {AROS_LD0} CONST	->AROS_LD0(t,n,bt,bn,o,s)
   NATIVE {AROS_LD1} CONST	->AROS_LD1(t,n,a1,bt,bn,o,s)
   NATIVE {AROS_LD2} CONST	->AROS_LD2(t,n,a1,a2,bt,bn,o,s)
   NATIVE {AROS_LD3} CONST	->AROS_LD3(t,n,a1,a2,a3,bt,bn,o,s)
   NATIVE {AROS_LD4} CONST	->AROS_LD4(t,n,a1,a2,a3,a4,bt,bn,o,s)
   NATIVE {AROS_LD5} CONST	->AROS_LD5(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
   NATIVE {AROS_LD6} CONST	->AROS_LD6(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
   NATIVE {AROS_LD7} CONST	->AROS_LD7(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
   NATIVE {AROS_LD8} CONST	->AROS_LD8(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
   NATIVE {AROS_LD9} CONST	->AROS_LD9(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
   NATIVE {AROS_LD10} CONST	->AROS_LD10(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
   NATIVE {AROS_LD11} CONST	->AROS_LD11(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
   NATIVE {AROS_LD12} CONST	->AROS_LD12(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
   NATIVE {AROS_LD13} CONST	->AROS_LD13(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
   NATIVE {AROS_LD14} CONST	->AROS_LD14(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
   NATIVE {AROS_LD15} CONST	->AROS_LD15(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

/* Declarations for library functions which don't need the libbase */
   NATIVE {AROS_LD0I} CONST	->AROS_LD0I(t,n,bt,bn,o,s)
   NATIVE {AROS_LD1I} CONST	->AROS_LD1I(t,n,a1,bt,bn,o,s)
   NATIVE {AROS_LD2I} CONST	->AROS_LD2I(t,n,a1,a2,bt,bn,o,s)
   NATIVE {AROS_LD3I} CONST	->AROS_LD3I(t,n,a1,a2,a3,bt,bn,o,s)
   NATIVE {AROS_LD4I} CONST	->AROS_LD4I(t,n,a1,a2,a3,a4,bt,bn,o,s)
   NATIVE {AROS_LD5I} CONST	->AROS_LD5I(t,n,a1,a2,a3,a4,a5,bt,bn,o,s)
   NATIVE {AROS_LD6I} CONST	->AROS_LD6I(t,n,a1,a2,a3,a4,a5,a6,bt,bn,o,s)
   NATIVE {AROS_LD7I} CONST	->AROS_LD7I(t,n,a1,a2,a3,a4,a5,a6,a7,bt,bn,o,s)
   NATIVE {AROS_LD8I} CONST	->AROS_LD8I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,bt,bn,o,s)
   NATIVE {AROS_LD9I} CONST	->AROS_LD9I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,bt,bn,o,s)
   NATIVE {AROS_LD10I} CONST	->AROS_LD10I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bt,bn,o,s)
   NATIVE {AROS_LD11I} CONST	->AROS_LD11I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,bt,bn,o,s)
   NATIVE {AROS_LD12I} CONST	->AROS_LD12I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,bt,bn,o,s)
   NATIVE {AROS_LD13I} CONST	->AROS_LD13I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,bt,bn,o,s)
   NATIVE {AROS_LD14I} CONST	->AROS_LD14I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,bt,bn,o,s)
   NATIVE {AROS_LD15I} CONST	->AROS_LD15I(t,n,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,bt,bn,o,s)

NATIVE {AROS_LHA} CONST	->AROS_LHA(type,name,reg) type,name,reg
NATIVE {AROS_LPA} CONST	->AROS_LPA(type,name,reg) type,name,reg
NATIVE {AROS_LCA} CONST	->AROS_LCA(type,name,reg) type,name,reg
NATIVE {AROS_LDA} CONST	->AROS_LDA(type,name,reg) type,name,reg

NATIVE {AROS_LHAQUAD} CONST	->AROS_LHAQUAD(type,name,reg1,reg2) type,name,reg1,reg2
NATIVE {AROS_LPAQUAD} CONST	->AROS_LPAQUAD(type,name,reg1,reg2) type,name,reg1,reg2
NATIVE {AROS_LCAQUAD} CONST	->AROS_LCAQUAD(type,name,reg1,reg2) type,name,reg1,reg2
NATIVE {AROS_LDAQUAD} CONST	->AROS_LDAQUAD(type,name,reg1,reg2) type,name,reg1,reg2

   NATIVE {AROS_LIBFUNC_INIT} CONST
   NATIVE {AROS_LIBFUNC_EXIT} CONST
   NATIVE {AROS_LIBBASE_EXT_DECL} CONST	->AROS_LIBBASE_EXT_DECL(a,b)

/* Tagging of private functions, so that they can be distinguished from
   official ones. But they have to compile the same way, so: */
NATIVE {AROS_PLH0}  CONST
NATIVE {AROS_PLH1}  CONST
NATIVE {AROS_PLH2}  CONST
NATIVE {AROS_PLH3}  CONST
NATIVE {AROS_PLH4}  CONST
NATIVE {AROS_PLH5}  CONST
NATIVE {AROS_PLH6}  CONST
NATIVE {AROS_PLH7}  CONST
NATIVE {AROS_PLH8}  CONST
NATIVE {AROS_PLH9}  CONST
NATIVE {AROS_PLH10} CONST
NATIVE {AROS_PLH11} CONST
NATIVE {AROS_PLH12} CONST
NATIVE {AROS_PLH13} CONST
NATIVE {AROS_PLH14} CONST
NATIVE {AROS_PLH15} CONST

/* NT stands for No Tags, which means that the functions which are defined with these headers
   are not subject to tagcall generation by the script used to generate include files */
NATIVE {AROS_NTLH0}  CONST
NATIVE {AROS_NTLH1}  CONST
NATIVE {AROS_NTLH2}  CONST
NATIVE {AROS_NTLH3}  CONST
NATIVE {AROS_NTLH4}  CONST
NATIVE {AROS_NTLH5}  CONST
NATIVE {AROS_NTLH6}  CONST
NATIVE {AROS_NTLH7}  CONST
NATIVE {AROS_NTLH8}  CONST
NATIVE {AROS_NTLH9}  CONST
NATIVE {AROS_NTLH10} CONST
NATIVE {AROS_NTLH11} CONST
NATIVE {AROS_NTLH12} CONST
NATIVE {AROS_NTLH13} CONST
NATIVE {AROS_NTLH14} CONST
NATIVE {AROS_NTLH15} CONST
