#ifndef _INCLUDE_PRAGMA_EMULATION_LIB_H
#define _INCLUDE_PRAGMA_EMULATION_LIB_H

#ifndef CLIB_EMULATION_PROTOS_H
#include <clib/emulation_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(EMUBase,0x01E,emuRemapFunctions(d0))
#pragma amicall(EMUBase,0x024,emuInitRefresh(a0))
#pragma amicall(EMUBase,0x02A,emuFreeRefresh(a0))
#pragma amicall(EMUBase,0x030,emuRefreshScreen(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall EMUBase emuRemapFunctions    01E 001
#pragma libcall EMUBase emuInitRefresh       024 801
#pragma libcall EMUBase emuFreeRefresh       02A 801
#pragma libcall EMUBase emuRefreshScreen     030 801
#endif

#endif	/*  _INCLUDE_PRAGMA_EMULATION_LIB_H  */