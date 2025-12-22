/* $Id: potgo_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries', 'target/exec', 'target/resources/potgo'
MODULE 'target/other/misc'		->a hack for OpenResource()
{
#include <proto/potgo.h>
}
{
struct Library *PotgoBase = NULL;
struct PotgoIFace* IPotgo = NULL;
}
NATIVE {CLIB_POTGO_PROTOS_H} CONST
NATIVE {PROTO_POTGO_H} CONST
NATIVE {PRAGMA_POTGO_H} CONST
->NATIVE {INLINE4_POTGO_H} CONST
NATIVE {POTGO_INTERFACE_DEF_H} CONST

NATIVE {PotgoBase} DEF potgobase:PTR TO lib
NATIVE {IPotgo}    DEF

PROC OpenResource(resName:ARRAY OF CHAR) REPLACEMENT
	DEF ret:APTR
	ret := SUPER OpenResource(resName)
	NATIVE {
	if(}ret{!=NULL && strcasecmp(}resName{, POTGONAME)==0) \{
		if (IPotgo == NULL) \{
			//get global interface for "potgo.resource"
			IPotgo = (struct PotgoIFace *) IExec->GetInterface( (struct Library *) } ret{, "main", 1, NULL);
		\}
	\}
	} ENDNATIVE
ENDPROC ret


NATIVE {AllocPotBits} PROC
PROC allocPotBits( bits:ULONG ) IS NATIVE {IPotgo->AllocPotBits(} bits {)} ENDNATIVE !!UINT
NATIVE {FreePotBits} PROC
PROC freePotBits( bits:ULONG ) IS NATIVE {IPotgo->FreePotBits(} bits {)} ENDNATIVE
NATIVE {WritePotgo} PROC
PROC writePotgo( word:ULONG, mask:ULONG ) IS NATIVE {IPotgo->WritePotgo(} word {,} mask {)} ENDNATIVE
