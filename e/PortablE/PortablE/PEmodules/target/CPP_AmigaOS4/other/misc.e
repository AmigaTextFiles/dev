/* $Id: misc_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries', 'target/exec', 'target/resources/misc'
MODULE 'target/other/cia'		->a hack for OpenResource()
{
#include <proto/misc.h>
}
{
struct Library *MiscBase = NULL;
struct MiscIFace* IMisc = NULL;
}
NATIVE {CLIB_MISC_PROTOS_H} CONST

NATIVE {PROTO_MISC_H} CONST
NATIVE {PRAGMA_MISC_H} CONST
->NATIVE {INLINE4_MISC_H} CONST
NATIVE {MISC_INTERFACE_DEF_H} CONST

NATIVE {MiscBase} DEF miscbase:PTR TO lib
NATIVE {IMisc}    DEF

PROC OpenResource(resName:ARRAY OF CHAR) REPLACEMENT
	DEF ret:APTR
	ret := SUPER OpenResource(resName)
	NATIVE {
	if(}ret{!=NULL && strcasecmp(}resName{, MISCNAME)==0) \{
		if (IMisc == NULL) \{
			//get global interface for "misc.resource"
			IMisc = (struct MiscIFace *) IExec->GetInterface( (struct Library *) } ret{, "main", 1, NULL);
		\}
	\}
	} ENDNATIVE
ENDPROC ret


NATIVE {AllocMiscResource} PROC
PROC allocMiscResource( unitNum:ULONG, name:ARRAY OF CHAR /*STRPTR*/ ) IS NATIVE {(char*) IMisc->AllocMiscResource(} unitNum {,} name {)} ENDNATIVE !!/*CONST_STRPTR*/ ARRAY OF CHAR
NATIVE {FreeMiscResource} PROC
PROC freeMiscResource( unitNum:ULONG ) IS NATIVE {IMisc->FreeMiscResource(} unitNum {)} ENDNATIVE
