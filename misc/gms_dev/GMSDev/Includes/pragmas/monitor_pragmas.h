#ifndef _INCLUDE_PRAGMA_MONITOR_LIB_H
#define _INCLUDE_PRAGMA_MONITOR_LIB_H

#ifndef CLIB_MONITOR_PROTOS_H
#include <clib/monitor_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(MONBase,0x01E,monRemapFunctions(d0))
#pragma amicall(MONBase,0x024,monSetHardware(a0,a1))
#pragma amicall(MONBase,0x02A,monTakeDisplay(a0))
#pragma amicall(MONBase,0x030,monReturnDisplay())
#pragma amicall(MONBase,0x036,monRemakeScreen(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall MONBase monRemapFunctions    01E 001
#pragma libcall MONBase monSetHardware       024 9802
#pragma libcall MONBase monTakeDisplay       02A 801
#pragma libcall MONBase monReturnDisplay     030 00
#pragma libcall MONBase monRemakeScreen      036 801
#endif

#endif	/*  _INCLUDE_PRAGMA_MONITOR_LIB_H  */