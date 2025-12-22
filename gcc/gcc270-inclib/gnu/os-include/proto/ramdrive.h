#ifndef PROTO_RAMDRIVE_H
#define PROTO_RAMDRIVE_H

#include <clib/ramdrive_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/ramdrive.h>
#endif
#ifndef __NOLIBBASE__
extern struct Device *RamdriveDevice;
#endif

#endif
