/*
**	rexxhost.library - ARexx host management support library
**
**	Copyright © 1990-1992 by Olaf `Olsen' Barthel
**		All Rights Reserved
*/

#ifndef _REXXHOSTBASE_H
#define _REXXHOSTBASE_H 1

#ifndef REXX_RXSLIB_H
#include <rexx/rxslib.h>
#endif	/* !REXX_RXSLIB_H */

	/* Main library structure (note: RexxSysBase can be reused
	 * by opening program).
	 */

struct RexxHostBase
{
	struct Library	 LibNode;
	struct RxsLib	*RexxSysBase;

	/* Everything below this point is considered PRIVATE and
	 * subject to change without notice (even though there isn't
	 * very much yet).
	 */
};

	/* This is an extended MsgPort structure which includes
	 * a special ID CreateRexxHost/DeleteRexxHost/SendRexxCommand
	 * rely on.
	 */

struct RexxHost
{
	/* Exec link. */

	struct MsgPort	rh_Port;

	/* Never touch the tags below, hands off - this may change soon. */

	ULONG		rh_Private0;
	ULONG		rh_Private1[4];
};

	/* This macro can be used to turn the signal bit
	 * contained in a RexxHost into a Wait-mask.
	 * Note: Argument must be a pointer.
	 */

#define HOSTMASK(Host) (1L << ((struct RexxHost *)Host) -> rh_Port . mp_SigBit)

	/* The library name. */

#define REXXHOSTNAME	"rexxhost.library"

	/* Use this value rather than REXXHOSTVERSION to open
	 * rexxhost.library.
	 */

#define REXXHOSTMINIMUM	34L

	/* The compiler version differences require the
	 * following preprocessor 'orgy'.
	 */

#ifdef __NO_PROTOS
#undef __NO_PROTOS
#endif	/* __NO_PROTOS */

#ifdef AZTEC_C

	/* No version symbol? We'll redefine it. */

#ifndef __VERSION
#define __VERSION 360
#endif	/* __VERSION */

	/* Aztec 'C' 5.0 includes full prototype checking and
	 * pragma support.
	 */

#if __VERSION < 500
#define __NO_PROTOS	1
#define __NO_PRAGMAS	1
#endif	/* __VERSION */

#endif	/* AZTEC_C */

	/* Now for the prototype handling. */

#ifdef __NO_PROTOS
#define __ARGS(x) ()
#else
#define __ARGS(x) x
#endif	/* __NO_PROTOS */

	/* Prototypes for library functions. */

struct RexxHost *	CreateRexxHost __ARGS((STRPTR));
VOID *			DeleteRexxHost __ARGS((struct RexxHost *));
LONG			SendRexxCommand __ARGS((struct RexxHost *,STRPTR,STRPTR,STRPTR));
VOID			FreeRexxCommand __ARGS((struct RexxMsg *));
VOID			ReplyRexxCommand __ARGS((struct RexxMsg *,LONG,LONG,STRPTR));
STRPTR			GetRexxCommand __ARGS((struct RexxMsg *));
STRPTR			GetRexxArg __ARGS((struct RexxMsg *));
LONG			GetRexxResult1 __ARGS((struct RexxMsg *));
LONG			GetRexxResult2 __ARGS((struct RexxMsg *));
STRPTR			GetToken __ARGS((STRPTR,LONG *,STRPTR,LONG));
LONG			GetStringValue __ARGS((STRPTR));
STRPTR			BuildValueString __ARGS((LONG,STRPTR));
LONG			RexxStrCmp __ARGS((UBYTE *,UBYTE *));
struct RexxMsg *	GetRexxMsg __ARGS((struct RexxHost *,LONG));
ULONG			SendRexxMsg __ARGS((STRPTR,STRPTR *,STRPTR,LONG));
VOID			GetRexxString __ARGS((STRPTR,STRPTR));
LONG			GetRexxClip __ARGS((char *Name,LONG WhichArg));

	/* The pragmas, both for Manx & Lattice. */

#ifndef __NO_PRAGMAS
#ifdef AZTEC_C
#pragma amicall(RexxHostBase, 0x1e, CreateRexxHost(a0))
#pragma amicall(RexxHostBase, 0x24, DeleteRexxHost(a0))
#pragma amicall(RexxHostBase, 0x2a, SendRexxCommand(a0,a1,a2,a3))
#pragma amicall(RexxHostBase, 0x30, FreeRexxCommand(a0))
#pragma amicall(RexxHostBase, 0x36, ReplyRexxCommand(a0,d0,d1,a1))
#pragma amicall(RexxHostBase, 0x3c, GetRexxCommand(a0))
#pragma amicall(RexxHostBase, 0x42, GetRexxArg(a0))
#pragma amicall(RexxHostBase, 0x48, GetRexxResult1(a0))
#pragma amicall(RexxHostBase, 0x4e, GetRexxResult2(a0))
#pragma amicall(RexxHostBase, 0x54, GetToken(a0,a1,a2,d0))
#pragma amicall(RexxHostBase, 0x5a, GetStringValue(a0))
#pragma amicall(RexxHostBase, 0x60, BuildValueString(d0,a0))
#pragma amicall(RexxHostBase, 0x66, RexxStrCmp(a0,a1))
#pragma amicall(RexxHostBase, 0x6c, GetRexxMsg(a0,d0))
#pragma amicall(RexxHostBase, 0x72, SendRexxMsg(a0,a1,a2,d0))
#pragma amicall(RexxHostBase, 0x78, GetRexxString(d0,d1))
#pragma amicall(RexxHostBase, 0x7e, GetRexxClip(a0,d0))
#else	/* AZTEC_C */
#pragma libcall RexxHostBase CreateRexxHost 1e 801
#pragma libcall RexxHostBase DeleteRexxHost 24 801
#pragma libcall RexxHostBase SendRexxCommand 2a ba9804
#pragma libcall RexxHostBase FreeRexxCommand 30 801
#pragma libcall RexxHostBase ReplyRexxCommand 36 910804
#pragma libcall RexxHostBase GetRexxCommand 3c 801
#pragma libcall RexxHostBase GetRexxArg 42 801
#pragma libcall RexxHostBase GetRexxResult1 48 801
#pragma libcall RexxHostBase GetRexxResult2 4e 801
#pragma libcall RexxHostBase GetToken 54 a9804
#pragma libcall RexxHostBase GetStringValue 5a 801
#pragma libcall RexxHostBase BuildValueString 60 8002
#pragma libcall RexxHostBase RexxStrCmp 66 9802
#pragma libcall RexxHostBase GetRexxMsg 6c 802
#pragma libcall RexxHostBase SendRexxMsg 72 a9804 
#pragma libcall RexxHostBase GetRexxString 78 1002
#pragma libcall RexxHostBase GetRexxClip 7e 802
#endif	/* AZTEC_C */
#endif	/* __NO_PRAGMAS */

#endif	/* _REXXHOSTBASE_H */
