#include <proto/exec.h>

#include <exec/types.h>

#include "MinimalDebug.h"

void __KPutStr(__reg("a6") void *SysBase, __reg("a0") const char *string) {
	while (1) {
		char c = *string++;
		if ('\0' == c) {
			break;
		}
		RawPutChar(c);
	}
}

static void RawPutCharProc(__reg("d0") char c, __reg("a3") void *SysBase) {
	RawPutChar(c);
}

/*#include <stdarg.h>
void __KPrintF(__reg("a6") void *SysBase, const char *format, ...) {
	va_list varArgs;
	va_start(varArgs, format);
	RawDoFmt(format, varArgs, &RawPutCharProc, SysBase);
	va_end(varArgs);
}*/
