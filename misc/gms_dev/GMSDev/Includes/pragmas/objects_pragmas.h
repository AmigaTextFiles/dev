#ifndef _INCLUDE_PRAGMA_OBJECTS_LIB_H
#define _INCLUDE_PRAGMA_OBJECTS_LIB_H

#ifndef CLIB_OBJECTS_PROTOS_H
#include <clib/objects_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(OBJBase,0x006,PullObject(a0,a1))
#pragma amicall(OBJBase,0x00C,PullObjectList(a0,a1))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall OBJBase PullObject           006 9802
#pragma libcall OBJBase PullObjectList       00C 9802
#endif

#endif	/*  _INCLUDE_PRAGMA_OBJECTS_LIB_H  */