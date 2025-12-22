#ifndef _PROTO_EXAMPLE_H
#define _PROTO_EXAMPLE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_EXAMPLE_PROTOS_H
#include <clib/example_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct ExampleBase *ExampleBase;
#endif

#ifdef __GNUC__
#include <inline/example.h>
#elif defined(__VBCC__)
#if defined(__MORPHOS__) || !defined(__PPC__)
#include <inline/example_protos.h>
#endif
#else
#include <pragma/example_lib.h>
#endif

#endif	/*  _PROTO_EXAMPLE_H  */
