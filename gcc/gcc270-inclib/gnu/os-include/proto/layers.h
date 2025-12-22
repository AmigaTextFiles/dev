#ifndef PROTO_LAYERS_H
#define PROTO_LAYERS_H

#include <clib/layers_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/layers.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *LayersBase;
#endif

#endif
