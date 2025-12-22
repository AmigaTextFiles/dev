#ifndef PROTO_GADTOOLS_H
#define PROTO_GADTOOLS_H

#include <clib/gadtools_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/gadtools.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *GadToolsBase;
#endif

#endif
