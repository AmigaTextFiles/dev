#ifndef _VBCCINLINE_LIBRARYGATE_H
#define _VBCCINLINE_LIBRARYGATE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

LONG __gate_add(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-30\n"
	"\tblrl";
#define gate_add(x, y) __gate_add(LibraryGateBase, (x), (y))

LONG __gate_sub(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-36\n"
	"\tblrl";
#define gate_sub(x, y) __gate_sub(LibraryGateBase, (x), (y))

LONG __gate_mul(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-42\n"
	"\tblrl";
#define gate_mul(x, y) __gate_mul(LibraryGateBase, (x), (y))

LONG __gate_div(struct Library *, LONG x, LONG y) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-48\n"
	"\tblrl";
#define gate_div(x, y) __gate_div(LibraryGateBase, (x), (y))

#endif /*  _VBCCINLINE_LIBRARYGATE_H  */
