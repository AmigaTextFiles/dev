#ifndef PROTO_TRITON_H
#define PROTO_TRITON_H

#ifdef __GNUC__

#include <clib/triton_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/triton.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *TritonBase;
#endif

#else

#include <exec/types.h>
extern struct Library *TritonBase;
#include <clib/triton_protos.h>
#include <pragmas/triton_pragmas.h>

#endif

#endif
