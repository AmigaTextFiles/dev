#ifndef PROTO_INTUITION_H
#define PROTO_INTUITION_H

#include <clib/intuition_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/intuition.h>
#endif
#ifndef __NOLIBBASE__
extern struct IntuitionBase *IntuitionBase;
#endif

#endif
