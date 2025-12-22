#ifndef PROTO_FIFO_H
#define PROTO_FIFO_H

#ifndef CLIB_FIFO_PROTOS_H
#include <clib/fifo_protos.h>
#endif

#if defined(__GNUC__) && !defined(__NOINLINES__)
#include <inline/fifo.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *FifoBase;
#endif

#endif
