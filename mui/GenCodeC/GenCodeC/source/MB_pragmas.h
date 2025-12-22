/*
**
**	MUIBuilder.library
**
**	$VER: MUIBuilder.library 1.0
**
**		(c) copyright 1994
**		    Eric Totel
**
*/

#ifndef __GNUC__

#include <exec/libraries.h>

#include "MB_protos.h"

extern struct Library *MUIBBase;

#pragma libcall MUIBBase MB_Open 1E 0
#pragma libcall MUIBBase MB_Close 24 0
#pragma libcall MUIBBase MB_GetA 2A 901
#pragma tagcall MUIBBase MB_Get 2A 901
#pragma libcall MUIBBase MB_GetVarInfoA 30 9002
#pragma tagcall MUIBBase MB_GetVarInfo 30 9002
#pragma libcall MUIBBase MB_GetNextCode 36 9802
#pragma libcall MUIBBase MB_GetNextNotify 3C 9802

#endif /* __GNUC__ */
