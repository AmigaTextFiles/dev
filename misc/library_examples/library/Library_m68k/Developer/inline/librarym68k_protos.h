#ifndef _VBCCINLINE_LIBRARYM68K_H
#define _VBCCINLINE_LIBRARYM68K_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

LONG __m68k_add(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-0\n"
	"\tblrl";
#define m68k_add(x, y) __m68k_add(LibraryM68KBase, (x), (y))

LONG __m68k_sub(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-6\n"
	"\tblrl";
#define m68k_sub(x, y) __m68k_sub(LibraryM68KBase, (x), (y))

LONG __m68k_mul(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-2\n"
	"\tblrl";
#define m68k_mul(x, y) __m68k_mul(LibraryM68KBase, (x), (y))

LONG __m68k_div(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-8\n"
	"\tblrl";
#define m68k_div(x, y) __m68k_div(LibraryM68KBase, (x), (y))

#endif /*  _VBCCINLINE_LIBRARYM68K_H  */
