#ifndef _INCLUDE_PRAGMA_C2P_LIB_H
#define _INCLUDE_PRAGMA_C2P_LIB_H

#ifndef CLIB_C2P_PROTOS_H
#include "./clib/c2p_protos.h"
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(C2PBase,0x01e,C2P_AllocMem(a0,d0))
#pragma amicall(C2PBase,0x024,C2P_CopyMem(a0,a1,d0))
#pragma amicall(C2PBase,0x02a,C2P_FreeMem(a0))
#pragma amicall(C2PBase,0x030,C2P_CreateContext())
#pragma amicall(C2PBase,0x036,C2P_InitializeContext(a0))
#pragma amicall(C2PBase,0x03c,C2P_DestroyContext(a0))
#pragma amicall(C2PBase,0x042,C2P_GetContextParameter(a0,d0))
#pragma amicall(C2PBase,0x048,C2P_SetContextParameter(a0,d0,d1))
#pragma amicall(C2PBase,0x04e,C2P_GetContextIndexedParameter(a0,d0,d1))
#pragma amicall(C2PBase,0x054,C2P_SetContextIndexedParameter(a0,d0,d1,d2))
#pragma amicall(C2PBase,0x05a,C2P_Chunky2Planar(a0))
#pragma amicall(C2PBase,0x060,C2P_WritePixel(a0,d0,d1,d2))
#pragma amicall(C2PBase,0x066,C2P_GetSystemParameter(d0))
#pragma amicall(C2PBase,0x06c,C2P_GetSystemIndexedParameter(d0,d1))
#pragma amicall(C2PBase,0x072,C2P_CreateBitMap(a0,d0,d1,d2))
#pragma amicall(C2PBase,0x078,C2P_DestroyBitMap(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall C2PBase C2P_AllocMem           01e 0802
#pragma  libcall C2PBase C2P_CopyMem            024 09803
#pragma  libcall C2PBase C2P_FreeMem            02a 801
#pragma  libcall C2PBase C2P_CreateContext      030 00
#pragma  libcall C2PBase C2P_InitializeContext  036 801
#pragma  libcall C2PBase C2P_DestroyContext     03c 801
#pragma  libcall C2PBase C2P_GetContextParameter 042 0802
#pragma  libcall C2PBase C2P_SetContextParameter 048 10803
#pragma  libcall C2PBase C2P_GetContextIndexedParameter 04e 10803
#pragma  libcall C2PBase C2P_SetContextIndexedParameter 054 210804
#pragma  libcall C2PBase C2P_Chunky2Planar      05a 801
#pragma  libcall C2PBase C2P_WritePixel         060 210804
#pragma  libcall C2PBase C2P_GetSystemParameter 066 001
#pragma  libcall C2PBase C2P_GetSystemIndexedParameter 06c 1002
#pragma  libcall C2PBase C2P_CreateBitMap       072 210804
#pragma  libcall C2PBase C2P_DestroyBitMap      078 801
#endif

#endif	/*  _INCLUDE_PRAGMA_C2P_LIB_H  */
