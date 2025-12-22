#ifndef PROTO_CONSOLE_H
#define PROTO_CONSOLE_H

#include <clib/console_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/console.h>
#endif
#ifndef __NOLIBBASE__
extern struct Device *ConsoleDevice;
#endif

#endif
