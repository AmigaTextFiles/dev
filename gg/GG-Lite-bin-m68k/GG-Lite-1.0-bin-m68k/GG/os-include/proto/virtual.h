#ifndef _PROTO_VIRTUAL_H
#define _PROTO_VIRTUAL_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#if !defined(CLIB_VIRTUAL_PROTOS_H) && !defined(__GNUC__)
#include <clib/virtual_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *VirtualBase;
#endif

#ifdef __GNUC__
#include <inline/virtual.h>
#elif !defined(__VBCC__)
#include <pragma/virtual_lib.h>
#endif

#endif	/*  _PROTO_VIRTUAL_H  */
