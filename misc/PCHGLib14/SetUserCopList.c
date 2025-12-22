#include <proto/exec.h>
#include <proto/graphics.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <hardware/custom.h>
#include <graphics/gfxmacros.h>
#include <graphics/gfxbase.h>
#include <graphics/copper.h>
#include <intuition/screens.h>
#include <iff/pchg.h>
#include <clib/pchglib_protos.h>

#define min(a,b) ((a)<(b) ? (a) : (b))

#if INCLUDE_VERSION<36
FAILURE!! Amiga includes version<36
#endif

/* This number is hardware dependent, and limits the numbers of colors
changes written by PCHG_SetUserCopList(). */

#define MAX_PER_LINE_CHANGES (15)

extern struct Custom __far custom;


/****** pchg.lib/PCHG_SetUserCopList ****************************************

   NAME
       PCHG_SetUserCopList -- Set a ViewPort Copperlist using a PCHG chunk

   SYNOPSIS
       PCHG_SetUserCopList(Offset, Length, ViewPort, PCHG, LineMask, LineData);

       VOID PCHG_SetUserCopList(WORD, UWORD, struct ViewPort *,
                                     struct PCHGHeader *, APTR, APTR);

   FUNCTION
       Creates the Copperlist defined by a PCHG header and data. If a user
       Copperlist is already defined on the ViewPort, it is first
       deallocated. If Length is 0, every change specified by the PCHG
       chunk will be generated. If Length is not 0, every change which
       happens on a line in the range Offset<->Offset+Length will be
       generated.  In each case, an offset equal to Offset is subtracted
       from the PCHG indications. For instance, if Offset == 8, Length ==
       10, the changes specified in the PCHG chunk for the line range 8-17
       will happen on the line range 0-9. This allows setting a Copperlist
       for a scrolled picture (i.e., the first displayed line is not the
       first picture line). If Offset == 0, Length == ViewPort->DHeight, only
       the changes which happen inside the ViewPort will be generated (with
       no offset). Do NOT ask for odd offsets for a laced picture, because
       of the well-known limitations of MrgCop(). Note that when Offset is
       non-zero, this function will stuff via SetRGB4() all the changes which
       happens before the Offset line, so that the image will be correctly
       displayed. This however implies you have to reload the CMAP before each
       call with an offset.

   INPUTS
       Offset       - A positive offset which will be subtracted from the
                      line specified by the PCHG->StartLine field.
       Length       - A number of lines which will limit the
                      Copperlist generation. Ignored if == 0.
       ViewPort     - The ViewPort which will receive the Copperlist.
       PCHG         - The PCHGHeader.
       LineMask     - The line mask pointer. Technically, the LINEMASK
                      part of the PCHG grammar.
       LineData     - The (Small|Big)PaletteChange array
                      pointer. Technically, the second part of the LINEDATA
                      part of the PCHG grammar.

   RESULT
       None.

   EXAMPLE

   NOTES
       The MAX_PER_LINE_CHANGES #define at the start of the source
       code limits the maximum number of changes allowed on a
       single line. No check is done for changes on odd lines if
       the ViewPort is laced. MaxReg and MinReg are ignored.
       This function does *not* call RethinkDisplay() for you,
       and needs graphics.library. Remember to free the user Copperlist
       (if you're using a &Screen->Viewport, Intuition will do it for you).

   BUGS
       Background Copperlists which a PCHGHeader->StartLine
       negative value will not be correctly displayed if Offset
       is not 0, because only changes on a line >=Offset will be
       generated. This shouldn't be a problem however.

   SEE ALSO

*****************************************************************************/

VOID PCHG_SetUserCopList(WORD Offset, UWORD Length, struct ViewPort *ViewPort, struct PCHGHeader *PCHG, APTR LineMask, APTR LineData) {

	LONG i,j,RegNum;
	ULONG r,g,b;
	struct UCopList *UCop;
	struct SmallLineChanges *slc;
	UWORD *RGB;
	ULONG *PreRGB;
	struct BigLineChanges *blc;
	struct BigPaletteChange *bpl;
	ULONG *Mask;
	BOOL Change;

	Forbid();
	if (ViewPort->UCopIns) {
		if (ViewPort->UCopIns->FirstCopList) FreeCopList(ViewPort->UCopIns->FirstCopList);
		FreeMem(ViewPort->UCopIns, sizeof(struct UCopList));
		ViewPort->UCopIns = NULL;
	}
	Permit();

	Mask = LineMask;
	blc = (void *)(slc = LineData);

	if ((UCop = AllocMem(sizeof(struct UCopList), MEMF_PUBLIC | MEMF_CLEAR)) == NULL) return;

	CINIT(UCop, PCHG->TotalChanges+PCHG->ChangedLines);

	if (Length && (PreRGB = AllocMem(sizeof(ULONG)*(PCHG->MaxReg-PCHG->MinReg+1), MEMF_PUBLIC | MEMF_CLEAR)) != NULL) {

		for(i=0; i<Offset-PCHG->StartLine; i++) {
			if (Mask[i/32] & 1UL<<(31-(i%32))) {
				if (PCHG->Flags & PCHGF_12BIT) {

					RGB = (UWORD *)&slc[1];

					for(j=0; j<slc->ChangeCount16; j++) {
						RegNum = *RGB>>12 & 0xF;
						if (RegNum >= PCHG->MinReg && RegNum <= PCHG->MaxReg) PreRGB[RegNum-PCHG->MinReg] = 0x1000 | (*RGB & 0xFFF);
						RGB++;
					}

					for(j=0; j<slc->ChangeCount32; j++) {
						RegNum = (*RGB>>12 & 0xF)+16;
						if (RegNum >= PCHG->MinReg && RegNum <= PCHG->MaxReg) PreRGB[RegNum-PCHG->MinReg] = 0x1000 | (*RGB & 0xFFF);
						RGB++;
					}
					slc = (void *)RGB;
				}
				else if (PCHG->Flags & PCHGF_32BIT) {

					bpl = (void *)&blc[1];

					for(j=0; j<blc->ChangeCount; j++) {
						if (bpl->Register >= PCHG->MinReg && bpl->Register <= PCHG->MaxReg) PreRGB[bpl->Register-PCHG->MinReg] = 0x1000000 | bpl->Red<<16 | bpl->Green<<8 | bpl->Blue;
						bpl++;
					}
					blc = (void *)bpl;
				}
			}
		}

		for(i=0; i<=PCHG->MaxReg-PCHG->MinReg; i++) {
			if (PCHG->Flags & PCHGF_12BIT) {
				if (PreRGB[i] & 0x1000)
					SetRGB4(ViewPort, i+PCHG->MinReg, PreRGB[i]>>8 & 0xF, PreRGB[i]>>4 & 0xF, PreRGB[i] & 0xF);
			}
			else if (PCHG->Flags & PCHGF_32BIT) {
				if (PreRGB[i] & 0x1000000) {

					r = PreRGB[i]>>16 & 0xFF;
					g = PreRGB[i]>>8 & 0xFF;
					b = PreRGB[i] & 0xFF;

					if (GfxBase->LibNode.lib_Version >= 39) {
						r = r|r<<8|r<<16|r<<24;
						g = g|g<<8|g<<16|g<<24;
						b = b|b<<8|b<<16|b<<24;
						SetRGB32(ViewPort, i+PCHG->MinReg, r, g, b);
					}
					else {
						SetRGB4(ViewPort, i+PCHG->MinReg, min(r+8,0xFF)>>4, min(g+8,0xFF)>>4, min(b+8,0xFF)>>4);
					}
				}
			}
		}
		FreeMem(PreRGB, sizeof(ULONG)*(PCHG->MaxReg-PCHG->MinReg+1));
	}

	blc = (void *)(slc = LineData);

	for(i=0; i<PCHG->LineCount; i++) {
		if (Mask[i/32] & 1UL<<(31-(i%32))) {
			Change = (!Length || (i+PCHG->StartLine >= Offset && i+PCHG->StartLine < Offset+Length));
			if (Change) CWAIT(UCop, i+PCHG->StartLine-Offset, 0);
			if (PCHG->Flags & PCHGF_12BIT) {
				RGB = (UWORD *)&slc[1];
				for(j=0; j<slc->ChangeCount16; j++) {
					if (j<MAX_PER_LINE_CHANGES && Change) CMOVE(UCop, custom.color[*RGB>>12 & 0xF], *RGB & 0xFFF);
					RGB++;
				}
				for(j=0; j<slc->ChangeCount32; j++) {
					if (j+slc->ChangeCount16<MAX_PER_LINE_CHANGES && Change) CMOVE(UCop, custom.color[(*RGB>>12 & 0xF)+16], *RGB & 0xFFF);
					RGB++;
				}
				slc = (void *)RGB;
			}
			else if (PCHG->Flags & PCHGF_32BIT) {
				bpl = (void *)&blc[1];
				for(j=0; j<blc->ChangeCount; j++) {
					if (j<MAX_PER_LINE_CHANGES && Change) CMOVE(UCop, custom.color[bpl->Register], (min(bpl->Red+8, 0xFF) & 0xF0)<<4 | min(bpl->Green+8, 0xFF) & 0xF0 | min(bpl->Blue+8, 0xFF)>>4);
					bpl++;
				}
				blc = (void *)bpl;
			}
		}
	}

	CEND(UCop);
	Forbid();
	ViewPort->UCopIns = UCop;
	Permit();
}
