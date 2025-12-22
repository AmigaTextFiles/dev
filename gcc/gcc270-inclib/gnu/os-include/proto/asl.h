#ifndef PROTO_ASL_H
#define PROTO_ASL_H

#include <clib/asl_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/asl.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *AslBase;
#endif

#endif
