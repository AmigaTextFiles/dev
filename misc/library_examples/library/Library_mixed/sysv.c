#include <exec/rawfmt.h>

#include <proto/exec.h>

#include "Library.h"

LONG sysv_add(LONG x, LONG y)
{
	NewRawDoFmt("[example_mixed.library] Called sysv_add(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x + y;
}

LONG sysv_sub(LONG x, LONG y)
{
	NewRawDoFmt("[example_mixed.library] Called sysv_sub(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x - y;
}

LONG sysv_mul(LONG x, LONG y)
{
	NewRawDoFmt("[example_mixed.library] Called sysv_mul(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x * y;
}

LONG sysv_div(LONG x, LONG y)
{
	NewRawDoFmt("[example_mixed.library] Called sysv_div(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x / y;
}

VOID sysv_output1(struct MyLibrary *LibBase, LONG x, LONG y)
{
	NewRawDoFmt("[example_mixed.library] Called sysv_output1(0x%08x, %d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, LibBase, x, y);
}

VOID sysv_output2(LONG x, LONG y, struct MyLibrary *LibBase)
{
	NewRawDoFmt("[example_mixed.library] Called sysv_output2(%d, %d, 0x%08x)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y, LibBase);
}
