#include <exec/rawfmt.h>

#include <proto/exec.h>

LONG m68k_add(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_mixed.library] Called m68k_add(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x + y;
}

LONG m68k_sub(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_mixed.library] Called m68k_sub(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x - y;
}

LONG m68k_mul(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_mixed.library] Called m68k_mul(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x * y;
}

LONG m68k_div(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_mixed.library] Called m68k_div(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);

	return x / y;
}
