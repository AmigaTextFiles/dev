#ifndef PROTO_POTGO_H
#define PROTO_POTGO_H

#include <clib/potgo_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/potgo.h>
#endif
#ifndef __NOLIBBASE__
extern struct Node *PotgoBase;
#endif

#endif
