#ifndef PROTO_TIMER_H
#define PROTO_TIMER_H

#include <clib/timer_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/timer.h>
#endif
#ifndef __NOLIBBASE__
extern struct Device *TimerBase;
#endif

#endif
