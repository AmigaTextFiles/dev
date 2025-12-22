#ifndef PROTO_REXXSYSLIB_H
#define PROTO_REXXSYSLIB_H

#include <clib/rexxsyslib_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/rexxsyslib.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *RexxSysBase;
#endif

#endif
