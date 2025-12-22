#ifndef PROTO_INPUT_H
#define PROTO_INPUT_H

#include <clib/input_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/input.h>
#endif
#ifndef __NOLIBBASE__
extern struct Device *InputBase;
#endif

#endif
