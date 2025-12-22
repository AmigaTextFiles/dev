#ifndef _INCLUDE_PRAGMA_CONFIG_LIB_H
#define _INCLUDE_PRAGMA_CONFIG_LIB_H

#ifndef CLIB_CONFIG_PROTOS_H
#include <clib/config_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(CNFBase,0x006,ReadConfig(a0,a1,a2))
#pragma amicall(CNFBase,0x00C,ReadConfigInt(a0,a1,a2))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall CNFBase ReadConfig           006 A9803
#pragma libcall CNFBase ReadConfigInt        00C A9803
#endif

#endif	/*  _INCLUDE_PRAGMA_CONFIG_LIB_H  */