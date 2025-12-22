#ifndef PROTO_DISK_H
#define PROTO_DISK_H

#include <clib/disk_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/disk.h>
#endif
#ifndef __NOLIBBASE__
extern struct Node *DiskBase;
#endif

#endif
