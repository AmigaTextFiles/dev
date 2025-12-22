#ifndef PRAGMAS_HELLOWORLD_PRAGMAS_H
#define PRAGMAS_HELLOWORLD_PRAGMAS_H

#ifndef CLIB_HELLOWORLD_PROTOS_H
#include <clib/helloworld_protos.h>
#endif

#ifdef PRAGMAS_DECLARING_LIBBASE
extern struct Library *HelloWorldBase;
#endif

#pragma libcall HelloWorldBase HelloWorld 1e 001

#endif	/*  PRAGMAS_HELLOWORLD_PRAGMAS_H  */
