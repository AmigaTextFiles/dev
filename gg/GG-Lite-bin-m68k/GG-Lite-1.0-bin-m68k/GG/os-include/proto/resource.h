#ifndef _PROTO_RESOURCE_H
#define _PROTO_RESOURCE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#if !defined(CLIB_RESOURCE_PROTOS_H) && !defined(__GNUC__)
#include <clib/resource_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *ResourceBase;
#endif

#ifdef __GNUC__
#include <inline/resource.h>
#elif !defined(__VBCC__)
#include <pragma/resource_lib.h>
#endif

#endif	/*  _PROTO_RESOURCE_H  */
