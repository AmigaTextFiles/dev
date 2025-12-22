#ifndef PROTO_MATHTRANS_H
#define PROTO_MATHTRANS_H

#include <clib/mathtrans_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/mathtrans.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *MathTransBase;
#endif

#endif
