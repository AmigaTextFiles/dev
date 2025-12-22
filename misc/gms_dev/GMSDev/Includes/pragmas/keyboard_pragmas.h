#ifndef _INCLUDE_PRAGMA_KEYBOARD_LIB_H
#define _INCLUDE_PRAGMA_KEYBOARD_LIB_H

#ifndef CLIB_KEYBOARD_PROTOS_H
#include <clib/keyboard_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(KEYBase,0x006,keyAddInputHandler())
#pragma amicall(KEYBase,0x00C,keyRemInputHandler())
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall KEYBase keyAddInputHandler   006 00
#pragma libcall KEYBase keyRemInputHandler   00C 00
#endif

#endif	/*  _INCLUDE_PRAGMA_KEYBOARD_LIB_H  */