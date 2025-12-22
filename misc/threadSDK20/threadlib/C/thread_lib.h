#ifndef _INCLUDE_PRAGMA_THREAD_LIB_H
#define _INCLUDE_PRAGMA_THREAD_LIB_H

#ifndef CLIB_THREAD_PROTOS_H
#include <clib/thread_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(ThreadBase,0x01E,TLCreate(a0,d0))
#pragma amicall(ThreadBase,0x024,TLExit(d0))
#pragma amicall(ThreadBase,0x02A,TLJoin(a0))
#pragma amicall(ThreadBase,0x030,TLDetach(d0))
#pragma amicall(ThreadBase,0x036,TLCancel(a0))
#pragma amicall(ThreadBase,0x03C,TLSetCancel(d0))
#pragma amicall(ThreadBase,0x042,TLSetPrio(d0))
#pragma amicall(ThreadBase,0x048,TLGetPrio(a0))
#pragma amicall(ThreadBase,0x04E,TLMutexInit())
#pragma amicall(ThreadBase,0x054,TLMutexDestroy(a0))
#pragma amicall(ThreadBase,0x05A,TLMutexLock(a0))
#pragma amicall(ThreadBase,0x060,TLMutexTryLock(a0))
#pragma amicall(ThreadBase,0x066,TLMutexUnlock(a0))
#pragma amicall(ThreadBase,0x06C,TLAllocMem(d0))
#pragma amicall(ThreadBase,0x072,TLFreeMem(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall ThreadBase TLCreate             01E 0802
#pragma libcall ThreadBase TLExit               024 001
#pragma libcall ThreadBase TLJoin               02A 801
#pragma libcall ThreadBase TLDetach             030 001
#pragma libcall ThreadBase TLCancel             036 801
#pragma libcall ThreadBase TLSetCancel          03C 001
#pragma libcall ThreadBase TLSetPrio            042 001
#pragma libcall ThreadBase TLGetPrio            048 801
#pragma libcall ThreadBase TLMutexInit          04E 00
#pragma libcall ThreadBase TLMutexDestroy       054 801
#pragma libcall ThreadBase TLMutexLock          05A 801
#pragma libcall ThreadBase TLMutexTryLock       060 801
#pragma libcall ThreadBase TLMutexUnlock        066 801
#pragma libcall ThreadBase TLAllocMem           06C 001
#pragma libcall ThreadBase TLFreeMem            072 801
#endif

#endif	/*  _INCLUDE_PRAGMA_THREAD_LIB_H  */