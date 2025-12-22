#ifndef PROTO_MISC_H
#define PROTO_MISC_H

#include <clib/misc_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/misc.h>
#endif
#ifndef __NOLIBBASE__
extern struct Node *MiscBase;
#endif

#endif
