#ifndef PROTO_DTCCLASS_H
#define PROTO_DTCCLASS_H

#include <clib/dtclass_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/dtclass.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *DTClassBase;
#endif

#endif
