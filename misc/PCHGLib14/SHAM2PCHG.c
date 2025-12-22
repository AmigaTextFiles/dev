#include <proto/exec.h>
#include <proto/graphics.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <hardware/custom.h>
#include <graphics/gfxmacros.h>
#include <graphics/copper.h>
#include <intuition/screens.h>
#include <iff/pchg.h>
#include <clib/pchglib_protos.h>

#if INCLUDE_VERSION<36
FAILURE!! Amiga includes version<36
#endif

/****** pchg.lib/PCHG_SHAM2PCHG ****************************************

   NAME
       PCHG_SHAM2PCHG -- Fakes a PCHG chunk from a SHAM chunk

   SYNOPSIS
       PCHGHeader = PCHG_SHAM2PCHG(SHAMChunk, SHAMSize, Increment);

       struct PCHGHeader *PCHG_SHAM2PCHG(UWORD *, ULONG, WORD);

   FUNCTION
       Creates a PCHGHeader and a LINEMASK (see the PCHG specs) by parsing a
       SHAM chunk. The memory block containing the SHAM is overwritten by an
       array of SmallPaletteChanges (this array is always shorter than the
       original SHAM chunk). A memory block is allocated for the PCHGHeader
       and for the LINEMASK (which is of course placed just after the
       PCHGHeader), and is returned by the function. You can then free it
       using as dimension the size of a PCHGHeader plus the number of bytes
       required by the longword mask, i.e.,

            sizeof(struct PCHGHeader)+((PCHGHeader->LineCount+31)/32)*4

       You can parse this chunk as any PCHG chunk, but the changes per line
       could be more than seven (up to fifteen). This function, however, is
       intelligent, and doesn't generate useless color changes (i.e., it
       never pokes again the same value two times). You will usually call

       PCHG_SetUserCopList(0, 0, Screen, PCHGHeader, &PCHGHeader[1], SHAMChunk);

       after using PCHG_SHAM2PCHG().


   INPUTS
       SHAMChunk    - The address of the SHAM chunk.
       SHAMSize     - The size of the SHAM chunk (we handle >200
                      lines chunks).
       Increment    - The increment to add to the line number while parsing
                      the SHAM chunk. It has to be 1 for non-laced pictures,
                      2 for laced pictures.

   RESULT
       PCHGHeader   - A pointer to a memory block contaning a PCHGHeader
                      followed by a LINEMASK, or NULL if the memory
                      allocation failed. You have to free this memory after
                      you used it.

   EXAMPLE

   NOTES
       This function will not generate any change on line 0, because the
       line 0 colors should be the same of the CMAP. If you get any problem,
       you can feed the first line of the SHAM chunk as a color table to the
       screen before calling this function.

       Since this function writes in the fake PCHG chunk only the real
       changes, you will generally get a better display using this function
       and PCHG_SetUserCopList() than with SHAMVIEW, for instance.

   BUGS

   SEE ALSO

*****************************************************************************/

struct PCHGHeader *PCHG_SHAM2PCHG(UWORD *SHAMChunk, ULONG SHAMSize, WORD Increment) {

	int i,j,k;
	UWORD Pal[16], *p;
	struct PCHGHeader *pch;
	ULONG *LineMask, LineCount;

	LineCount = (SHAMSize-2)/32;

	if (!(pch = AllocMem(sizeof(struct PCHGHeader)+((LineCount*Increment+31)/32)*4, MEMF_PUBLIC | MEMF_CLEAR))) return(NULL);
	LineMask = (void *)&pch[1];

	for(i=1; i<16; i++) Pal[i] = SHAMChunk[i+1] & 0xFFF;
	p = SHAMChunk++;
	pch->MinReg = 15;

	for(i=1; i<LineCount; i++) {
		for(j=1, k=0; j<16; j++)
			if (Pal[j] != SHAMChunk[i*16+j] & 0xFFF) {
				p[++k] = (Pal[j] = SHAMChunk[i*16+j] & 0xFFF) | j<<12;
				if (pch->MinReg>j) pch->MinReg = j;
				if (pch->MaxReg<j) pch->MaxReg = j;
			}
		if (k) {
			*p = k<<8;
			p+=(k+1);
			LineMask[(i*Increment)/32] |= 1<<(31-(i*Increment)%32);
			pch->ChangedLines++;
			pch->TotalChanges += k;
			if (k>pch->MaxChanges) pch->MaxChanges = k;
		}
	}

	pch->Compression = PCHG_COMP_NONE;
	pch->Flags = PCHGF_12BIT;
	pch->StartLine = 0;
	pch->LineCount = LineCount*Increment;
	return(pch);
}
