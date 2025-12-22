#ifndef _INCLUDE_PRAGMA_COMPRESSOR_LIB_H
#define _INCLUDE_PRAGMA_COMPRESSOR_LIB_H

#ifndef CLIB_COMPRESSOR_PROTOS_H
#include <clib/Compressor_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(compressorbase,0x01E,Cc_GetClassPtr())
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall compressorbase Cc_GetClassPtr       01E 00
#endif

#endif	/*  _INCLUDE_PRAGMA_COMPRESSOR_LIB_H  */