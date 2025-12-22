#include <proto/intuition.h>
#include <proto/exec.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <iff/pchg.h>
#include <clib/pchglib_protos.h>

#if INCLUDE_VERSION<36
FAILURE!! Amiga includes version<36
#endif


/****** pchg.lib/PCHG_ParsePCHG ******************************************

   NAME
       PCHG_ParsePCHG -- Parse a PCHG chunk and build Copperlist.

   SYNOPSIS
       Error = PCHG_ParsePCHG(PCHG, ViewPort);

       LONG PCHG_ParsePCHG(struct PCHGHeader *, struct ViewPort *);

   FUNCTION
       I-do-all-for-you function. PCHG_ParsePCHG() frees you from
       every hassle. You simply pass it the content of the PCHG
       chunk (i.e., what follows the IFF chunk size) and a pointer
       to your ViewPort. The Copperlist will be built and stuffed in.

   INPUTS
       PCHG          - A pointer to the contents of the PCHG chunk.
       ViewPort      - A pointer to the ViewPort that will receive the
                       Copperlist described in the PCHG chunk.

   RESULT
       Error will be set to 0 if everything OK. Otherwise you can
       the error listed in iff/pchg.h (PCHGERR_NOMEM, etc.).

   EXAMPLE

   NOTES
       The Copperlist created by this function will be
       automatically deallocated when you call CloseScreen() if
       you're using the ViewPort of an Intuition Screen.
       This function parses the chunk and then calls
       PCHG_SetUserCopList(); thus, it needs grahics.library.
       After calling it, you will probably need a RethingDisplay()
       if you're using an Intuition Screen, or the suitable graphics
       calls (MrgCop() etc.) if you're directly handling the
       ViewPort.

   BUGS

   SEE ALSO
       PCHG_SetUserCopList(), iff/pchg.h

*****************************************************************************/

LONG PCHG_ParsePCHG(struct PCHGHeader *PCHG, struct ViewPort *ViewPort) {

	void *PCHGDecomp = NULL;
	struct PCHGCompHeader *pch;

	if (PCHG->Compression == PCHG_COMP_HUFFMANN) {
		pch = (void *)&PCHG[1];
		if (PCHGDecomp = AllocMem(pch->OriginalDataSize, MEMF_PUBLIC | MEMF_CLEAR))
			PCHG_FastDecomp((char *)&pch[1]+pch->CompInfoSize, PCHGDecomp, (WORD *)((char *)&pch[1]+pch->CompInfoSize-2), pch->OriginalDataSize);
		else return(PCHGERR_NOMEM);
		PCHG_SetUserCopList(0, 0, ViewPort, PCHG, PCHGDecomp, (ULONG *)PCHGDecomp+(PCHG->LineCount+31)/32);
	}
	else if (PCHG->Compression != PCHG_COMP_NONE) return(PCHGERR_UNKNOWNCOMP);
	else PCHG_SetUserCopList(0, 0, ViewPort, PCHG, (void *)&PCHG[1], (ULONG *)&PCHG[1]+(PCHG->LineCount+31)/32);

	if (PCHGDecomp) FreeMem(PCHGDecomp, pch->OriginalDataSize);
	return(0);
}
