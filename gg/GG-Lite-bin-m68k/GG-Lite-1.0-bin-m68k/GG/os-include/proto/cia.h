#ifndef _PROTO_CIA_H
#define _PROTO_CIA_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#if !defined(CLIB_CIA_PROTOS_H) && !defined(__GNUC__)
#include <clib/cia_protos.h>
#endif

#ifdef __GNUC__
#include <inline/cia.h>
#elif !defined(__VBCC__)
#include <pragma/cia_lib.h>
#endif

#endif	/*  _PROTO_CIA_H  */
