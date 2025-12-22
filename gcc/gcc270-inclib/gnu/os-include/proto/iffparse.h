#ifndef PROTO_IFFPARSE_H
#define PROTO_IFFPARSE_H

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif
#include <clib/iffparse_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/iffparse.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *IFFParseBase;
#endif

#endif
