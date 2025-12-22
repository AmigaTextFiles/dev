#ifndef	LIBRARY_M68K_PROTOS
#define	LIBRARY_M68K_PROTOS

LONG sysv_add(LONG x, LONG y);
LONG sysv_sub(LONG x, LONG y);
LONG sysv_mul(LONG x, LONG y);
LONG sysv_div(LONG x, LONG y);

LONG m68k_add(LONG x, LONG y);
LONG m68k_sub(LONG x, LONG y);
LONG m68k_mul(LONG x, LONG y);
LONG m68k_div(LONG x, LONG y);

VOID sysv_output1(struct MyLibrary *LibBase, LONG x, LONG y);
VOID sysv_output2(LONG x, LONG y, struct MyLibrary *LibBase);

#endif	/* LIBRARY_M68K_PROTOS */