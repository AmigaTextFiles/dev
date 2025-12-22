/*
**	rexxhost.library - ARexx host management support library
**
**	Copyright © 1990-1992 by Olaf `Olsen' Barthel
**		All Rights Reserved
*/

	/* Main system includes. */

#include <dos/dosextens.h>
#include <exec/execbase.h>
#include <exec/memory.h>
#include <exec/alerts.h>
#include <rexx/rxslib.h>

#include <clib/rexxsyslib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

	/* BCPL 'NULL'. */

#define ZERO 0L

	/* Global library base IDs. */

extern struct RxsLib	*RexxSysBase;
extern struct ExecBase	*SysBase;

	/* rexxsyslib.library pragmas. */

#pragma libcall RexxSysBase CreateArgstring 7e 802
#pragma libcall RexxSysBase DeleteArgstring 84 801
#pragma libcall RexxSysBase CreateRexxMsg 90 9803
#pragma libcall RexxSysBase DeleteRexxMsg 96 801
#pragma libcall RexxSysBase FindRsrcNode b4 9803

	/* The rexx host library base. */

struct RexxHostBase
{
	struct Library	 LibNode;
	struct RxsLib	*RexxSysBase;
};

	/* A rexx host, somewhat more than a simple MsgPort. */

struct RexxHost
{
	struct MsgPort	rh_Port;
	UWORD		rh_Pad;

	ULONG		rh_SpecialID;
	ULONG		rh_Reserved[4];
};

	/* Prototypes for all library functions. */

struct RexxHost * __saveds __asm	CreateRexxHost(register __a0 STRPTR HostName);
VOID * __saveds __asm			DeleteRexxHost(register __a0 struct RexxHost *RexxHost);
LONG __saveds __asm			SendRexxCommand(register __a0 struct RexxHost *HostPort,register __a1 STRPTR CommandString,register __a2 STRPTR FileExtension,register __a3 STRPTR HostName);
VOID __saveds __asm			FreeRexxCommand(register __a0 struct RexxMsg *RexxMessage);
VOID __saveds __asm			ReplyRexxCommand(register __a0 struct RexxMsg *RexxMessage,register __d0 LONG Primary,register __d1 LONG Secondary,register __a1 STRPTR Result);
STRPTR __saveds __asm			GetRexxCommand(register __a0 struct RexxMsg *RexxMessage);
STRPTR __saveds __asm			GetRexxArg(register __a0 struct RexxMsg *RexxMessage);
LONG __saveds __asm			GetRexxResult1(register __a0 struct RexxMsg *RexxMessage);
LONG __saveds __asm			GetRexxResult2(register __a0 struct RexxMsg *RexxMessage);
STATIC BYTE __regargs			IsSpace(UBYTE c);
STRPTR __saveds __asm			GetToken(register __a0 STRPTR String,register __a1 LONG *StartChar,register __a2 STRPTR AuxBuff,register __d0 LONG MaxLength);
LONG __saveds __asm			GetStringValue(register __a0 STRPTR String);
STRPTR __saveds __asm			BuildValueString(register __d0 LONG Value,register __a0 STRPTR String);
LONG __saveds __asm			RexxStrCmp(register __a0 STRPTR Source,register __a1 STRPTR Target);
struct RexxMsg * __saveds __asm		GetRexxMsg(register __a0 struct RexxHost *RexxHost,register __d0 LONG Wait);
ULONG __saveds __asm			SendRexxMsg(register __a0 STRPTR HostName,register __a1 STRPTR *MsgList,register __a2 STRPTR SingleMsg,register __d0 LONG GetResult);
VOID __saveds __asm			GetRexxString(register __d0 STRPTR SourceString,register __d1 STRPTR DestString);
LONG __saveds __asm			GetRexxClip(register __a0 UBYTE *Name,register __d0 LONG WhichArg);
