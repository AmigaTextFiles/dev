#ifndef _INCLUDE_PRAGMA_TEXTFIELD_LIB_H
#define _INCLUDE_PRAGMA_TEXTFIELD_LIB_H


#ifdef __cplusplus
#define CPLUSPLUSON
#pragma -
#endif

#include <clib/textfield_protos.h>

#pragma amicall( TextFieldBase,0x1e,TEXTFIELD_GetClass())
#pragma amicall( TextFieldBase,0x24,TEXTFIELD_GetCopyright())


#ifdef CPLUSPLUSON
#undef CPLUSPLUSON
#pragma +
#endif

#endif

