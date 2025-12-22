#ifndef PROTO_GRAPHICS_H
#define PROTO_GRAPHICS_H

#ifndef GRAPHICS_SCALE_H
#include <graphics/scale.h>
#endif
#include <clib/graphics_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/graphics.h>
#endif
#ifndef __NOLIBBASE__
extern struct GfxBase *GfxBase;
#endif

#endif
