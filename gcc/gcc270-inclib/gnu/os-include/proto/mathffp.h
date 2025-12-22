#ifndef PROTO_MATHFFP_H
#define PROTO_MATHFFP_H

#include <clib/mathffp_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/mathffp.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *MathBase;
#endif

#endif
