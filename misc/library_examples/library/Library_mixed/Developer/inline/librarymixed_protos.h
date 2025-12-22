#ifndef _VBCCINLINE_LIBRARYMIXED_H
#define _VBCCINLINE_LIBRARYMIXED_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

LONG __m68k_add(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-4\n"
	"\tblrl";
#define m68k_add(x, y) __m68k_add(LibraryMixedBase, (x), (y))

LONG __m68k_sub(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-0\n"
	"\tblrl";
#define m68k_sub(x, y) __m68k_sub(LibraryMixedBase, (x), (y))

LONG __m68k_mul(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-6\n"
	"\tblrl";
#define m68k_mul(x, y) __m68k_mul(LibraryMixedBase, (x), (y))

LONG __m68k_div(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-2\n"
	"\tblrl";
#define m68k_div(x, y) __m68k_div(LibraryMixedBase, (x), (y))

#endif /*  _VBCCINLINE_LIBRARYMIXED_H  */
