#ifndef CLIB_EXAMPLE_PROTOS_H
#define CLIB_EXAMPLE_PROTOS_H


/*
**	$VER: example_protos.h 1.0 (12.10.2002)
**
**	C prototypes. For use with 32 bit integers only.
**
**	Copyright © 2002 Dirk Stöcker
**	All Rights Reserved
*/

#ifndef  LIBRARIES_EXAMPLE_H
#include <libraries/example.h>
#endif
#ifndef  UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

LONG ex_TestRequest(STRPTR title, STRPTR body, STRPTR gadgets);
LONG ex_TestRequest2A(STRPTR title, STRPTR body, STRPTR gadgets, APTR args);
LONG ex_TestRequest2(STRPTR title, STRPTR body, STRPTR gadgets, ...);
ULONG ex_TestRequest3(struct Hook * hook);

#endif	/*  CLIB_EXAMPLE_PROTOS_H  */
