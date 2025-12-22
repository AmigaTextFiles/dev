#ifndef PROTO_BATTMEM_H
#define PROTO_BATTMEM_H

#include <clib/battmem_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/battmem.h>
#endif
#ifndef __NOLIBBASE__
extern struct Node *BattMemBase;
#endif

#endif
