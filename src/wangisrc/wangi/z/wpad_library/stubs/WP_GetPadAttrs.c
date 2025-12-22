typedef unsigned long ULONG;
extern struct Library *WPadBase;
extern ULONG WP_GetPadAttrsA(ULONG, ULONG);

#if defined(AZTEC_C)  ||  defined(__MAXON__)
#pragma amicall(WPadBase,0x30,WP_GetPadAttrsA(a0,a1))
#endif

#if defined(_DCC)  ||  defined(__SASC)
#pragma libcall WPadBase WP_GetPadAttrsA 30 9802
#endif


ULONG WP_GetPadAttrs(ULONG pad, ULONG tags, ...)

{ return(WP_GetPadAttrsA(pad, (ULONG) &tags));
}
