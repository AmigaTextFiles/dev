#ifndef _VBCCINLINE_EXAMPLE_H
#define _VBCCINLINE_EXAMPLE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

LONG __ex_TestRequest(struct ExampleBase *, STRPTR title, STRPTR body, STRPTR gadgets) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-30\n"
	"\tblrl";
#define ex_TestRequest(title, body, gadgets) __ex_TestRequest(ExampleBase, (title), (body), (gadgets))

LONG __ex_TestRequest2A(struct ExampleBase *, STRPTR title, STRPTR body, STRPTR gadgets, APTR args) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,44(2)\n"
	"\tli\t3,-36\n"
	"\tblrl";
#define ex_TestRequest2A(title, body, gadgets, args) __ex_TestRequest2A(ExampleBase, (title), (body), (gadgets), (args))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
LONG __ex_TestRequest2(struct ExampleBase *, long, long, long, long, STRPTR title, STRPTR body, STRPTR gadgets, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t8,32(2)\n"
	"\tstw\t9,36(2)\n"
	"\tstw\t10,40(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,44(2)\n"
	"\tli\t3,-36\n"
	"\tblrl";
#define ex_TestRequest2(title, body, ...) __ex_TestRequest2(ExampleBase, 0, 0, 0, 0, (title), (body), __VA_ARGS__)
#endif

ULONG __ex_TestRequest3(struct ExampleBase *, struct Hook * hook) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-42\n"
	"\tblrl";
#define ex_TestRequest3(hook) __ex_TestRequest3(ExampleBase, (hook))

#endif /*  _VBCCINLINE_EXAMPLE_H  */
