#ifndef _INCLUDE_PRAGMA_SID6581_LIB_H
#define _INCLUDE_PRAGMA_SID6581_LIB_H

#ifndef CLIB_SID6581_PROTOS_H
#include <clib/sid6581_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(SID6581Base,0x01e,SID_AllocSID())
#pragma amicall(SID6581Base,0x024,SID_FreeSID(a1))
#pragma amicall(SID6581Base,0x02a,SID_Interrupt())
#pragma amicall(SID6581Base,0x030,SID_Initialize(a1))
#pragma amicall(SID6581Base,0x036,SID_ResetSID(a1))
#pragma amicall(SID6581Base,0x03c,SID_IRQOnOff(a1,d0))
#pragma amicall(SID6581Base,0x048,SID_ReadReg(a1,d0))
#pragma amicall(SID6581Base,0x04e,SID_WriteReg(a1,d0,d1))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall SID6581Base SID_AllocSID           01e 00
#pragma  libcall SID6581Base SID_FreeSID            024 901
#pragma  libcall SID6581Base SID_Interrupt          02a 00
#pragma  libcall SID6581Base SID_Initialize         030 901
#pragma  libcall SID6581Base SID_ResetSID           036 901
#pragma  libcall SID6581Base SID_IRQOnOff           03c 0902
#pragma  libcall SID6581Base SID_ReadReg            048 0902
#pragma  libcall SID6581Base SID_WriteReg           04e 10903
#endif

#endif	/*  _INCLUDE_PRAGMA_SID6581_LIB_H  */
