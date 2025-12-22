#include <exec/rawfmt.h>

#include <proto/exec.h>

LONG sysv_add(LONG x, LONG y)
{
	NewRawDoFmt("[example_sysv.library] Called sysv_add(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x + y;
}

LONG sysv_sub(LONG x, LONG y)
{
	NewRawDoFmt("[example_sysv.library] Called sysv_sub(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x - y;
}

LONG sysv_mul(LONG x, LONG y)
{
	NewRawDoFmt("[example_sysv.library] Called sysv_mul(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x * y;
}

LONG sysv_div(LONG x, LONG y)
{
	NewRawDoFmt("[example_sysv.library] Called sysv_div(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x / y;
}
