#ifndef PROTO_NONVOLATILE_H
#define PROTO_NONVOLATILE_H

#include <clib/nonvolatile_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/nonvolatile.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library * NVBase;
#endif

#endif
