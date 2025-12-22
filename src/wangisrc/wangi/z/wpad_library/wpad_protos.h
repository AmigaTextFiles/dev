#ifndef CLIB_WPAD_PROTOS_H
#define CLIB_WPAD_PROTOS_H

/***************************************************************************
 * wpad_protos.h
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

#ifdef LIB_CODE
#define REG(x)	register __ ## x
#define LIBENT	__asm __saveds
#else
#define SHARED_LIB 1
#define REG(x)
#define LIBENT
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef LIBRARIES_WPAD_H
#include <libraries/wpad.h>
#endif
#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

struct Pad LIBENT *WP_OpenPadA( REG(a0) struct TagItem *tags );
struct Pad *WP_OpenPad( Tag tag1, ... ); 
VOID LIBENT WP_ClosePadA( REG(a0) struct Pad *pad, REG(a1) struct TagItem *tags );
VOID WP_ClosePad( struct Pad *pad, Tag tag1, ... );
VOID LIBENT WP_SetPadAttrsA( REG(a0) struct Pad *pad, REG(a1) struct TagItem *tags);
VOID WP_SetPadAttrs( struct Pad *pad, Tag tag1, ... );
LONG LIBENT WP_GetPadAttrsA( REG(a0) struct Pad *pad, REG(a1) struct TagItem *tags);
LONG WP_GetPadAttrs( struct Pad *pad, Tag tag1, ... );
ULONG LIBENT WP_PadCount( VOID );




