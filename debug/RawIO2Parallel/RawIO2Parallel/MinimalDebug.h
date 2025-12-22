// Minimal implementation of debug.lib which is smaller, simpler and more
// efficient than the NDK version - for example only pc-relative code so
// no relocations and can call exec.library/RawPutChar() directly as SysBase
// is an argument.

#ifndef __MINIMAL_DEBUG_H__
#define __MINIMAL_DEBUG_H__

char __RawPutChar(__reg("a6") void *, __reg("d0") char c)="\tjsr\t-516(a6)";
#define RawPutChar(c) __RawPutChar(SysBase, (c))
#define KPutChar(c) RawPutChar(c)

void __KPutStr(__reg("a6") void *SysBase, __reg("a0") const char *string);
#define KPutStr(str) __KPutStr(SysBase, (str))

void __KPrintF(__reg("a6") void *SysBase, const char *format, ...);
#define KPrintF(...) __KPrintF(SysBase, __VA_ARGS__)

int __KMayGetChar(__reg("a6") void *SysBase)="\tjsr\t-510(a6)";
#define KMayGetChar() __KMayGetChar(SysBase)

#endif
