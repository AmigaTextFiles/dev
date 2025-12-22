typedef unsigned long ULONG;
extern struct Library *WPadBase;
extern ULONG WP_ClosePadA(ULONG, ULONG);

#if defined(AZTEC_C)  ||  defined(__MAXON__)
#pragma amicall(WPadBase,0x24,WP_ClosePadA(a0,a1))
#endif

#if defined(_DCC)  ||  defined(__SASC)
#pragma libcall WPadBase WP_ClosePadA 24 9802
#endif


ULONG WP_ClosePad(ULONG pad, ULONG tags, ...)

{ return(WP_ClosePadA(pad, (ULONG) &tags));
}
