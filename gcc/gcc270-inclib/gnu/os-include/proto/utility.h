#ifndef PROTO_UTILITY_H
#define PROTO_UTILITY_H

#include <clib/utility_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/utility.h>
#endif
#ifndef __NOLIBBASE__
extern struct UtilityBase *UtilityBase;
#endif

#endif
