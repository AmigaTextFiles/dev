#ifndef _INCLUDE_PRAGMA_FILES_LIB_H
#define _INCLUDE_PRAGMA_FILES_LIB_H

#ifndef CLIB_FILES_PROTOS_H
#include <clib/files_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(FILBase,0x006,SetFComment(a0,a1))
#pragma amicall(FILBase,0x00C,SetFDate(a0,a1))
#pragma amicall(FILBase,0x012,OpenFile(a0,d0))
#pragma amicall(FILBase,0x018,GetFDate(a0))
#pragma amicall(FILBase,0x01E,GetFComment(a0))
#pragma amicall(FILBase,0x024,GetFPermissions(a0))
#pragma amicall(FILBase,0x02A,GetFSize(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall FILBase SetFComment       006 9802
#pragma libcall FILBase SetFDate          00C 9802
#pragma libcall FILBase OpenFile             012 0802
#pragma libcall FILBase GetFDate          018 801
#pragma libcall FILBase GetFComment       01E 801
#pragma libcall FILBase GetFPermissions   024 801
#pragma libcall FILBase GetFSize          02A 801
#endif

#endif	/*  _INCLUDE_PRAGMA_FILES_LIB_H  */
