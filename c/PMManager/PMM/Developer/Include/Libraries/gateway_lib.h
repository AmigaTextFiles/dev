#ifndef _INCLUDE_PRAGMA_GATEWAY_LIB_H
#define _INCLUDE_PRAGMA_GATEWAY_LIB_H

#ifndef CLIB_GATEWAY_PROTOS_H
#include "gateway_protos.h"
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)

#pragma amicall(GatewayBase, 0x1e, GateRequest(d1,d2,d3))
#pragma amicall(GatewayBase, 0x24, trim(d1))
#pragma amicall(GatewayBase, 0x2a, rtrim(d1))
#pragma amicall(GatewayBase, 0x30, trim_include(d1))
#pragma amicall(GatewayBase, 0x36, mail_trim(d1,d2))
#pragma amicall(GatewayBase, 0x3c, set(d1,d2))
#pragma amicall(GatewayBase, 0x42, lset(d1,d2))
#pragma amicall(GatewayBase, 0x48, lsetmin(d1,d2))
#pragma amicall(GatewayBase, 0x4e, instr(d1,d2))
#pragma amicall(GatewayBase, 0x54, midstr(d1,d2,d3))
#pragma amicall(GatewayBase, 0x5a, newstr(d1,d2,d3,d4))
#pragma amicall(GatewayBase, 0x60, wordwrp(d1,d2,d3))
#pragma amicall(GatewayBase, 0x66, kill_ansi(d1))
#pragma amicall(GatewayBase, 0x6c, fn_splitt(d1,d2,d3,d4,d5))
#pragma amicall(GatewayBase, 0x72, fn_build(d1,d2,d3,d4,d5))
#pragma amicall(GatewayBase, 0x78, time_to_zahl(d1))
#pragma amicall(GatewayBase, 0x7e, date_to_zahl(d1))
#pragma amicall(GatewayBase, 0x84, date_to_day(d1))
#pragma amicall(GatewayBase, 0x8a, addval(d1,d2))
#pragma amicall(GatewayBase, 0x90, ltofa(d1,d2))
#pragma amicall(GatewayBase, 0x96, string(d1,d2,d3))
#pragma amicall(GatewayBase, 0x9c, newer(d1,d2,d3,d4))
#pragma amicall(GatewayBase, 0xa2, upstr(d1))
#pragma amicall(GatewayBase, 0xa8, lowstr(d1))
#pragma amicall(GatewayBase, 0xae, StrCaseCmp(d1,d2))
#pragma amicall(GatewayBase, 0xb4, strdup(d1))
#pragma amicall(GatewayBase, 0xba, swapmem(d1,d2,d3))
#pragma amicall(GatewayBase, 0xc0, memncmp(d1,d2,d3))
#pragma amicall(GatewayBase, 0xc6, index(d1,d2))

#endif
#if defined(_DCC) || defined(__SASC)

#pragma libcall GatewayBase GateRequest 1e 32103
#pragma libcall GatewayBase trim 24 101
#pragma libcall GatewayBase rtrim 2a 101
#pragma libcall GatewayBase trim_include 30 101
#pragma libcall GatewayBase mail_trim 36 2102
#pragma libcall GatewayBase set 3c 2102
#pragma libcall GatewayBase lset 42 2102
#pragma libcall GatewayBase lsetmin 48 2102
#pragma libcall GatewayBase instr 4e 2102
#pragma libcall GatewayBase midstr 54 32103
#pragma libcall GatewayBase newstr 5a 432104
#pragma libcall GatewayBase wordwrp 60 32103
#pragma libcall GatewayBase kill_ansi 66 101
#pragma libcall GatewayBase fn_splitt 6c 5432105
#pragma libcall GatewayBase fn_build 72 5432105
#pragma libcall GatewayBase time_to_zahl 78 101
#pragma libcall GatewayBase date_to_zahl 7e 101
#pragma libcall GatewayBase date_to_day 84 101
#pragma libcall GatewayBase addval 8a 2102
#pragma libcall GatewayBase ltofa 90 2102
#pragma libcall GatewayBase string 96 32103
#pragma libcall GatewayBase newer 9c 432104
#pragma libcall GatewayBase upstr a2 101
#pragma libcall GatewayBase lowstr a8 101
#pragma libcall GatewayBase StrCaseCmp ae 2102
#pragma libcall GatewayBase strdup b4 101
#pragma libcall GatewayBase swapmem ba 32103
#pragma libcall GatewayBase memncmp c0 32103
#pragma libcall GatewayBase index c6 2102

#endif
#ifdef __STORM__
#endif
#ifdef __SASC_60
#endif

#endif	/*  _INCLUDE_PRAGMA_GATEWAY_LIB_H  */
