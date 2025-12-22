#ifndef PROTO_DOSPATH_H
#define PROTO_DOSPATH_H
#include <exec/types.h>
extern struct Library *DOSPathBase;
#ifdef __GNUC__
#include <inline/dospath.h>
#else
#include <clib/dospath_protos.h>
#include <pragmas/dospath_pragmas.h>
#endif
#endif
