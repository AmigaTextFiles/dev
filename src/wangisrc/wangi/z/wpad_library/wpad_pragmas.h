#ifndef PRAGMAS_WPAD_PRAGMAS_H
#define PRAGMAS_WPAD_PRAGMAS_H

#ifndef CLIB_WPAD_PROTOS_H
#include <clib/wpad_protos.h>
#endif

#pragma libcall WPadBase WP_OpenPadA 1e 801
#pragma libcall WPadBase WP_ClosePadA 24 9802
#pragma libcall WPadBase WP_SetPadAttrsA 2a 9802
#pragma libcall WPadBase WP_GetPadAttrsA 30 9802
#pragma libcall WPadBase WP_PadCount 36 00

#ifdef __SASC_60
#pragma tagcall WPadBase WP_OpenPad 1e 801
#pragma tagcall WPadBase WP_ClosePad 24 9802
#pragma tagcall WPadBase WP_SetPadAttrs 2a 9802
#pragma tagcall WPadBase WP_GetPadAttrs 30 9802
#endif	/*  __SASC_60  */

#endif	/*  PRAGMAS_WPAD_PRAGMAS_H  */
