#ifndef PROTO_WBSTART_H
#define PROTO_WBSTART_H
#include <exec/types.h>
extern struct Library *WBStartBase;
#ifdef __GNUC__
#include <inline/wbstart.h>
#else
#include <clib/wbstart_protos.h>
#include <pragmas/wbstart_pragmas.h>
#endif
#endif

