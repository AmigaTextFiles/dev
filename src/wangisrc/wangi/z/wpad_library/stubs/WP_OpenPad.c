typedef unsigned long ULONG;
extern struct Library *WPadBase;
extern ULONG WP_OpenPadA(ULONG);

#if defined(AZTEC_C)  ||  defined(__MAXON__)
#pragma amicall(WPadBase,0x1e,WP_OpenPadA(a0))
#endif

#if defined(_DCC)  ||  defined(__SASC)
#pragma libcall WPadBase WP_OpenPadA 1e 801
#endif


ULONG WP_OpenPad(ULONG tags, ...)

{ return(WP_OpenPadA((ULONG) &tags));
}
