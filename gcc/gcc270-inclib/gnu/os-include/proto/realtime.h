#ifndef PROTO_REALTIME_H
#define PROTO_REALTIME_H

#include <clib/realtime_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/realtime.h>
#endif
#ifndef __NOLIBBASE__
extern struct RealTimeBase *RealTimeBase;
#endif

#endif
