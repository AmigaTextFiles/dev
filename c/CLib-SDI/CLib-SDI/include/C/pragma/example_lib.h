#ifndef _INCLUDE_PRAGMA_EXAMPLE_LIB_H
#define _INCLUDE_PRAGMA_EXAMPLE_LIB_H

#ifndef CLIB_EXAMPLE_PROTOS_H
#include <clib/example_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(ExampleBase,0x01e,ex_TestRequest(a0,a1,a2))
#pragma amicall(ExampleBase,0x024,ex_TestRequest2A(a0,a1,a2,a3))
#pragma amicall(ExampleBase,0x02a,ex_TestRequest3(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall ExampleBase ex_TestRequest         01e a9803
#pragma  libcall ExampleBase ex_TestRequest2A       024 ba9804
#pragma  libcall ExampleBase ex_TestRequest3        02a 801
#endif
#ifdef __STORM__
#pragma tagcall(ExampleBase,0x024,ex_TestRequest2(a0,a1,a2,a3))
#endif
#ifdef __SASC_60
#pragma  tagcall ExampleBase ex_TestRequest2        024 ba9804
#endif

#endif	/*  _INCLUDE_PRAGMA_EXAMPLE_LIB_H  */
