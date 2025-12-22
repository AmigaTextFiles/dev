#ifndef PROTO_KEYMAP_H
#define PROTO_KEYMAP_H

#include <clib/keymap_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/keymap.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *KeymapBase;
#endif

#endif
