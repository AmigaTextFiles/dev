#include <exec/rawfmt.h>

#include <proto/exec.h>
#include <proto/library_sysv.h>

LONG gate_add(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_68kgate.library] Called gate_add(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);
	return sysv_add(x, y);
}

LONG gate_sub(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_68kgate.library] Called gate_sub(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);
	return sysv_sub(x,y);
}

LONG gate_mul(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_68kgate.library] Called gate_mul(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);
	return sysv_mul(x,y);
}

LONG gate_div(void)
{
	LONG x = REG_D0;
	LONG y = REG_D1;

	NewRawDoFmt("[example_68kgate.library] Called gate_div(%d, %d)\n", (APTR)RAWFMTFUNC_SERIAL, NULL, x, y);
	return sysv_div(x,y);
}
