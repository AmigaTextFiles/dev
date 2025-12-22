#ifndef PROTO_LOWLEVEL_H
#define PROTO_LOWLEVEL_H

#include <clib/lowlevel_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/lowlevel.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *LowLevelBase;
#endif

#endif
