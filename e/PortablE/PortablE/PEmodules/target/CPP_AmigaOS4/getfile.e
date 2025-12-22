/* $VER: getfile.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/getfile.h>
}
{
struct Library * GetFileBase = NULL;
struct GetFileIFace *IGetFile = NULL;
}
NATIVE {CLIB_GETFILE_PROTOS_H} CONST
NATIVE {PROTO_GETFILE_H} CONST
NATIVE {PRAGMA_GETFILE_H} CONST
NATIVE {INLINE4_GETFILE_H} CONST
NATIVE {GETFILE_INTERFACE_DEF_H} CONST

NATIVE {GetFileBase} DEF getfilebase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IGetFile}    DEF

PROC new()
	InitLibrary('gadgets/getfile.gadget', NATIVE {(struct Interface **) &IGetFile} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {GETFILE_GetClass} PROC
PROC GetFile_GetClass() IS NATIVE {IGetFile->GETFILE_GetClass()} ENDNATIVE !!PTR TO iclass
