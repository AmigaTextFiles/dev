/* $Id: cia_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/interrupts', 'target/exec/libraries'
MODULE 'target/exec', 'target/resources/cia'
MODULE 'target/other/battmem'		->a hack for OpenResource()
{
#include <proto/cia.h>
}
{
struct CIAIFace* ICIA = NULL;
}
NATIVE {CLIB_CIA_PROTOS_H} CONST
NATIVE {PROTO_CIA_H} CONST
NATIVE {PRAGMA_CIA_H} CONST
->NATIVE {INLINE4_CIA_H} CONST
NATIVE {CIA_INTERFACE_DEF_H} CONST

NATIVE {ICIA} DEF

PROC OpenResource(resName:ARRAY OF CHAR) REPLACEMENT
	DEF ret:APTR
	ret := SUPER OpenResource(resName)
	NATIVE {
	if(}ret{!=NULL && (strcasecmp(}resName{, CIAANAME)==0) || (strcasecmp(}resName{, CIABNAME)==0)) \{
		if (ICIA == NULL) \{
			//get global interface for "ciaa/b.resource"
			ICIA = (struct CIAIFace *) IExec->GetInterface( (struct Library *) } ret{, "main", 1, NULL);
		\}
	\}
	} ENDNATIVE
ENDPROC ret


NATIVE {AddICRVector} PROC
PROC addICRVector( resource:PTR TO lib, iCRBit:VALUE, interrupt:PTR TO is ) IS NATIVE {ICIA->AddICRVector(} resource {,} iCRBit {,} interrupt {)} ENDNATIVE !!PTR TO is
NATIVE {RemICRVector} PROC
PROC remICRVector( resource:PTR TO lib, iCRBit:VALUE, interrupt:PTR TO is ) IS NATIVE {ICIA->RemICRVector(} resource {,} iCRBit {,} interrupt {)} ENDNATIVE
NATIVE {AbleICR} PROC
PROC ableICR( resource:PTR TO lib, mask:VALUE ) IS NATIVE {ICIA->AbleICR(} resource {,} mask {)} ENDNATIVE !!INT
NATIVE {SetICR} PROC
PROC setICR( resource:PTR TO lib, mask:VALUE ) IS NATIVE {ICIA->SetICR(} resource {,} mask {)} ENDNATIVE !!INT
