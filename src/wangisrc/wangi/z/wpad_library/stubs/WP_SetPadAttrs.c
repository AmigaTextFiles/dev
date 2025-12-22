typedef unsigned long ULONG;
extern struct Library *WPadBase;
extern ULONG WP_SetPadAttrsA(ULONG, ULONG);

#if defined(AZTEC_C)  ||  defined(__MAXON__)
#pragma amicall(WPadBase,0x2a,WP_SetPadAttrsA(a0,a1))
#endif

#if defined(_DCC)  ||  defined(__SASC)
#pragma libcall WPadBase WP_SetPadAttrsA 2a 9802
#endif


ULONG WP_SetPadAttrs(ULONG pad, ULONG tags, ...)

{ return(WP_SetPadAttrsA(pad, (ULONG) &tags));
}
