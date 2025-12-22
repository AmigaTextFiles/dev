#ifndef _INCLUDE_PRAGMA_IOBLIX_DEV_LIB_H
#define _INCLUDE_PRAGMA_IOBLIX_DEV_LIB_H

#ifndef CLIB_IOBLIX_DEV_PROTOS_H
#include <clib/ioblix_dev_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(IOBlixDevBase,0x02A,GetChipInfo(a0))
#pragma amicall(IOBlixDevBase,0x030,AllocECPInfo(a0))
#pragma amicall(IOBlixDevBase,0x036,FreeECPInfo(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall IOBlixDevBase GetChipInfo          02A 801
#pragma libcall IOBlixDevBase AllocECPInfo         030 801
#pragma libcall IOBlixDevBase FreeECPInfo          036 801
#endif

#endif	/*  _INCLUDE_PRAGMA_IOBLIX_DEV_LIB_H  */