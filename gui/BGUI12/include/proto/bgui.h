#ifndef BGUI_PROTO_H
#define BGUI_PROTO_H
#ifdef _DCC
#include <pragmas/config.h>
#else
#define __SUPPORTS_PRAGMAS__ 1
#endif
#include <exec/types.h>
#include <clib/bgui_protos.h>
#ifdef __SUPPORTS_PRAGMAS__
extern struct Library *BGUIBase;
#include <pragmas/bgui_pragmas.h>
#endif
#endif
