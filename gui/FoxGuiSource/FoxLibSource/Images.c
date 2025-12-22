/* FoxGUI - The fast, flexible, free Amiga GUI system
	Copyright (C) 2001 Simon Fox (Foxysoft)

This library is free software; you can redistribute it and/ormodify it under the terms of the GNU Lesser General PublicLicense as published by the Free Software Foundation; eitherversion 2.1 of the License, or (at your option) any later version.This library is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty ofMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNULesser General Public License for more details.You should have received a copy of the GNU Lesser General PublicLicense along with this library; if not, write to the Free SoftwareFoundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
Foxysoft: www.foxysoft.co.uk      Email:simon@foxysoft.co.uk                */


/******************************************************************************
 * Shared library code.  Cannot call functions which use exit() such as:
 * printf(), fprintf()
 *
 * Otherwise:
 * The linker returns "__XCEXIT undefined" and the program will fail.
 * This is because you must not exit() a library!
 *
 * Also:
 * proto/exec.h must be included instead of clib/exec_protos.h and
 * __USE_SYSBASE must be defined.
 *
 * Otherwise:
 * The linker returns "Absolute reference to symbol _SysBase" and the
 * library crashes.  Presumably the same is true for the other protos.
 ******************************************************************************/

#define __USE_SYSBASE

#define FOXGUI_IMAGES	// Used to stop iffp/ilbm.h from redefining GfxBase & IntuitionBase.

#include <proto/mathieeedoubbas.h>
#include <stdlib.h>
#include <math.h>

#include <libraries/dos.h>
#include <libraries/iffparse.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <graphics/gfx.h>
#include <graphics/scale.h>

#define USE_BUILTIN_MATH 1  // to use built-in min() and max() in string.h
#include <string.h>

#include <graphics/display.h>
#include <intuition/intuition.h>

#define NO_PROTOS
#define NO_SAS_PRAGMAS

#include <iffp/ilbm.h>
#include <iffp/packer.h>

#include "/foxinclude/foxgui.h"
#include "FoxGuiTools.h"

#define MaxSrcPlanes (25)

static void freeBitMap(struct BitMap *bm)
   {
   short j;

	if (bm)
		{
		for (j = 0; j < bm->Depth; j++)
			if (bm->Planes[j])
				FreeRaster(bm->Planes[j], bm->BytesPerRow << 3, bm->Rows);
		FreeMem(bm, sizeof(struct BitMap));
		}
	}

static struct BitMap *getBitMap(int wide, int high, int deep, short clear)
	{
	register short i;
	struct BitMap *bitmap;

	if (!(bitmap = (struct BitMap *) AllocMem(sizeof(struct BitMap), MEMF_PUBLIC|MEMF_CLEAR)))
		return NULL;

	InitBitMap(bitmap, deep, wide, high);
	for (i = 0; i < deep; i++)
		{
		if (!(bitmap->Planes[i] = (PLANEPTR)AllocRaster(wide, high)))
			{
			freeBitMap(bitmap);
			return NULL;
			}
		if (clear)
			BltClear(bitmap->Planes[i], RASSIZE(wide, high), 0);
		}
	return bitmap;
	}

static BOOL unpackrow(BYTE **pSource, BYTE **pDest, WORD srcBytes0, WORD dstBytes0)
	{
	register BYTE *source = *pSource;
	register BYTE *dest = *pDest;
	register WORD n;
	register WORD srcBytes = srcBytes0, dstBytes = dstBytes0;
	register BYTE c;
	BOOL error = TRUE;  // assume error until we make it through the loop
	WORD minus128 = -128;  // get the compiler to generate a CMP.W

	while (dstBytes > 0)
		{
		if (--srcBytes < 0)
			goto errorexit;
		n = *source++;
		if (n >= 0)
			{
			++n;
			if ((srcBytes -= n) < 0)
				goto errorexit;
			if ((dstBytes -= n) < 0)
				goto errorexit;
			do {
				*dest++ = *source++;
				} while (--n > 0);
			}
		else if (n != minus128)
			{
			n = 1 - n;
			if (--srcBytes < 0)
				goto errorexit;
			if ((dstBytes -= n) < 0)
				goto errorexit;
			c = *source++;
			do {
				*dest++ = c;
				} while (--n > 0);
			}
		}
	error = FALSE;  // success!

errorexit:
	*pSource = source;
	*pDest = dest;
	return error;
	}


static int loadbody2(struct IFFHandle *iff, struct BitMap *bitmap, BYTE *mask, BitMapHeader *bmhd,
		BYTE *buffer, ULONG bufsize)
	{
	register int iPlane, iRow, nEmpty;
	register WORD nFilled;
	WORD srcRowBytes = RowBytes(bmhd->w), destRowBytes = bitmap->BytesPerRow,
		destWidthBytes,   // used for width check
		compression = bmhd->compression;
	LONG bufRowBytes = MaxPackedSize(srcRowBytes);
	int nRows = bmhd->h;
	struct ContextNode *cn = CurrentChunk(iff);
	UBYTE srcPlaneCnt = bmhd->nPlanes;
	BYTE *buf, *nullDest, *nullBuf, **pDest, *planes[MaxSrcPlanes];   // array of ptrs to planes & mask

	if (compression > cmpByteRun1)
		return 1;

	if (((struct Library *)GfxBase)->lib_Version >= 39)
		destWidthBytes = RowBytes(GetBitMapAttr(bitmap, BMA_WIDTH));
	else
		destWidthBytes = destRowBytes;

	if (srcRowBytes > destWidthBytes || bufsize < (bufRowBytes<<1) || srcPlaneCnt > MaxSrcPlanes)
		return 1;
	if (nRows > bitmap->Rows)
		nRows = bitmap->Rows;

	// Initialize array "planes" with bitmap ptrs; NULL in empty slots.
	for (iPlane = 0; iPlane < bitmap->Depth; iPlane++)
		planes[iPlane] = (BYTE *)bitmap->Planes[iPlane];

	while (iPlane < MaxSrcPlanes)
		planes[iPlane++] = NULL;

	// copy any mask plane ptr into corresponding "planes" slot.
	if (bmhd->masking == mskHasMask)
		planes[srcPlaneCnt++] = mask ? mask : NULL;

	// Set up a sink for dummy destination of rows from unwanted planes
	nullDest = buffer;
	buffer += srcRowBytes;
	bufsize -= srcRowBytes;

	// Read the BODY contents into bitmap.
	// De-interleave planes, decompress rows.
	// MODIFIES: Last iteration modifies bufsize.

	buf = buffer + bufsize;  // buffer is currently empty
	for (iRow = nRows; iRow > 0; iRow--)
		{
		for (iPlane = 0; iPlane < srcPlaneCnt; iPlane++)
			{
			pDest = &planes[iPlane];
			if (!(*pDest))	// establish sink for any unwanted plane
				{
				nullBuf = nullDest;
				pDest = &nullBuf;
				}
			// read in at least enough bytes to uncompress next row
			nEmpty = buf - buffer;       // size of empty part of buffer
			nFilled = bufsize - nEmpty;  // this part has data
			if (nFilled < bufRowBytes)
				{
				CopyMem(buf, buffer, nFilled);
				if (nEmpty > ChunkMoreBytes(cn))	// not enough left to fill buffer
					{
					nEmpty = ChunkMoreBytes(cn);
					bufsize = nFilled + nEmpty;
					}
				if (ReadChunkBytes(iff, &buffer[nFilled], nEmpty) < nEmpty)
					return 1;

				buf = buffer;
				nFilled = bufsize;
				}

			// copy uncompressed row to destination plane
			if (compression == cmpNone)
				{
				if (nFilled < srcRowBytes)
					return 2;
				CopyMem(buf, *pDest, srcRowBytes);
				buf += srcRowBytes;
				*pDest += destRowBytes;
				}
			else
				{  // decompress row to destination plane
				if (unpackrow(&buf, pDest, nFilled, srcRowBytes))
					return 2;
				else
					*pDest += (destRowBytes - srcRowBytes);
				}
			}
		}
	return 0;
	}

static int loadbody(struct IFFHandle *iff, struct BitMap *bitmap,BitMapHeader *bmhd)
	{
	BYTE *buffer;
	ULONG bufsize;
	LONG err = 0;
	register struct ContextNode *cn = CurrentChunk(iff);

	if (!cn)
		return 1;
	if (cn->cn_Type != ID_ILBM || cn->cn_ID != ID_BODY)
		return 1;
	if (bitmap && bmhd)
		{
		bufsize = MaxPackedSize(RowBytes(bmhd->w)) << 4;
		if (!(buffer = AllocMem(bufsize, 0L)))
			return 2;
		err = loadbody2(iff, bitmap, NULL, bmhd, buffer, bufsize);
		}
	FreeMem(buffer, bufsize);
	return err;
	}

static void freeIFFHandle(struct IFFHandle *iff)
	{
	CloseIFF(iff);
	if (iff->iff_Stream)
		Close(iff->iff_Stream);
	FreeIFF(iff);
	}

static struct IFFHandle *getilbminfo(char *filename, USHORT *wide, USHORT *high, USHORT *deep,
		WORD **colortable, USHORT *colors, unsigned long *mode, BitMapHeader **bmhd)
	{
	struct StoredProperty *sp;
	struct IFFHandle *iff;

	if (!IFFParseBase)
		return NULL;

	// open things
	if (!(iff = AllocIFF()))
		return NULL;
	if (!(iff->iff_Stream = Open(filename, MODE_OLDFILE)))
		goto iffdone;
	InitIFFasDOS(iff);
	if (OpenIFF(iff, IFFF_READ))
		goto iffdone;

	// set up the parser and parse the file
	if (PropChunk(iff, ID_ILBM, ID_BMHD))
		goto iffdone;
	PropChunk(iff, ID_ILBM, ID_CMAP);
	PropChunk(iff, ID_ILBM, ID_CAMG);
	if (StopChunk(iff, ID_ILBM, ID_BODY))
		goto iffdone; // stop at start of body
	if (ParseIFF(iff, IFFPARSE_SCAN))
		goto iffdone;

	// extract header and determine dimensions
	// From modules/getbitmap.c
	if (!(sp = FindProp(iff, ID_ILBM, ID_BMHD)))
		goto iffdone;
	*bmhd = (BitMapHeader *)sp->sp_Data;

	*wide = RowBits((*bmhd)->w);
	*high = (*bmhd)->h;
	*deep = (*bmhd)->nPlanes;

	if (colors)
		{              // get colormap information
		if (sp = FindProp(iff, ID_ILBM, ID_CMAP))
			{
			register unsigned char *rgb = sp->sp_Data;
			long r, g, b;
			unsigned long ncheck;
			unsigned short i, ncolors = *colors = sp->sp_Size / sizeofColorRegister;

			if ((ncheck = 1 << (*bmhd)->nPlanes) > ncolors)
				ncheck = ncolors;
//ifdef PENDING_LATER_INCLUDES
			if (((struct Library *)GfxBase)->lib_Version >= 39)
				{
				Color32 *ct;
				unsigned short AllShifted = TRUE;
				unsigned short nc = max(ncolors, 32);

				if (!(*colortable = (short *)GuiMalloc((nc*sizeof(Color32)) + (4*sizeof(short)), MEMF_CLEAR)))
					goto errctab;
				ct = (Color32 *)(*colortable + 2);
				**colortable = nc;

				i = 0;
				while (ncheck--)
					{
					ct[i].r   = r = *rgb++;
					ct[i].g   = g = *rgb++;
					ct[i++].b = b = *rgb++;
					if ((r & 0x0f) || (g & 0x0f) || (b & 0x0f))
						AllShifted = FALSE;
					}
				if (AllShifted && ((*bmhd)->flags & BMHDF_CMAPOK))  // shift if 4-bit
					for (i = 0; i < ncolors; i++)
						{
						ct[i].r |= (ct[i].r >> 4);
						ct[i].g |= (ct[i].g >> 4);
						ct[i].b |= (ct[i].b >> 4);
						}
				for (i = 0; i < ncolors; i++)
					{  // scale to 32 bits
					g = ct[i].r;
					ct[i].r |= ((g << 24) | (g << 16) | (g << 8));
					g = ct[i].g;
					ct[i].g |= ((g << 24) | (g << 16) | (g << 8));
					g = ct[i].b;
					ct[i].b |= ((g << 24) | (g << 16) | (g << 8));
					}
				}
			else
//endif
			if (*colortable = (short *)calloc(ncolors, sizeof(short)))
				{
				short *ct = *colortable;
				while (ncheck--)
					{
					r = (*rgb++ & 0xf0) << 4;
					g = *rgb++ & 0xf0;
					b = *rgb++ >> 4;
					*(ct++) = r | g | b;
					}
				}
			else
				{
errctab:
				*colortable = NULL;
				*colors = 0xffff;
				}
			}
		else
			*colors = 0xffff;
		}

	return iff;

iffdone:
	if (iff)
		freeIFFHandle(iff);
	return NULL;
	}

int FoxPow2(int r)
	{
	return 1 << r;
	}

BOOL FOXLIB ScreenColoursFromILBM(REGA0 GuiScreen *sc, REGA1 char *fname)
	{
	// Inspect the ilbm file given in fname and set the screen's colours to those in the ilbm.

	int pen;
	BitMapHeader *bmhd;
	unsigned short wide, high, deep, colours = sc->scr->ViewPort.ColorMap->Count; //MAXAMCOLORREG;
	short *colourtable = NULL;
	struct IFFHandle *iff = getilbminfo(fname, &wide, &high, &deep,
			&colourtable, &colours, NULL, &bmhd);

	if (!iff)
		return FALSE;
	if ((!(sc->nsc)) || !(sc->scr))
		{
		freeIFFHandle(iff);
		return FALSE;
		}
	if (sc->nsc->Depth < deep)
		{ // The supplied screen isn't deep enough for this ilbm.
		SetLastErr("The screen isn't deep enough for this ILBM in function ScreenColoursFromILBM.");
		freeIFFHandle(iff);
		return FALSE;
		}

	if (colourtable)
		if (((struct Library *)GfxBase)->lib_Version < 39)
			LoadRGB4(&sc->scr->ViewPort, (unsigned short *) colourtable, colours);
		else
			LoadRGB32(&sc->scr->ViewPort, (unsigned long *) colourtable);

	if (colourtable)
		GuiFree(colourtable);
	freeIFFHandle(iff);
	// Black is usually in pen 0, white is usually in the last pen.
	pen = FoxPow2(sc->nsc->Depth);
	SetGuiPens(pen - 1, 0);
	return TRUE;
	}

static struct BitMap *loadilbmBitMap(char *filename, unsigned short *wide, unsigned short *high,
		unsigned short *deep)
	{
	BitMapHeader *bmhd;
	struct BitMap *bitmap;
	struct IFFHandle *iff = getilbminfo(filename, wide, high, deep, NULL, NULL, NULL, &bmhd);

	if (!iff)
		return NULL;

	// Allocate a bitmap according to the data in the bitmap header and load the ILBM file into the bitmap
	if (bitmap = getBitMap(*wide, *high, *deep, 1))
		if (loadbody(iff, bitmap, bmhd))
			{
			freeBitMap(bitmap);	// Load was unsuccessful
			bitmap = NULL;
			}
	freeIFFHandle(iff);	// IFF handle must be freed before exiting
	return bitmap;
	}

BOOL FOXLIB HideBitMap(REGA0 BitMapInstance *bmi)
	{
	if (!bmi)
		return FALSE;
	
	AreaBlank(bmi->win->Win->RPort, bmi->left, bmi->top, bmi->bm->width, bmi->bm->height);
	GuiFree(bmi);
	return TRUE;
	}

BitMapInstance* FOXLIB ShowBitMap(REGA0 GuiBitMap *bm, REGA1 GuiWindow *w, REGD0 unsigned short x, REGD1 unsigned short y,
		REGD2 short flags)
	{
	if (bm && w)
		{
		BitMapInstance *bmi = (BitMapInstance *) GuiMalloc(sizeof(BitMapInstance), 0);

		if (!bmi)
			return NULL;
		bmi->win = w;
		bmi->left = x;
		bmi->top = y;
		bmi->bm = bm;
		BltBitMapRastPort(bm->bm, 0L, 0L, w->Win->RPort, (long) x, (long) y, (long) (bm->width),
				(long) (bm->height), (flags & BM_OVERLAY ? 0x60 : 0xC0));
		WaitBlit();
		return bmi;
		}
	return NULL;
	}

GuiBitMap* FOXLIB LoadBitMap(REGA0 char *fname)
	{
	unsigned short wide, high, deep;
	GuiBitMap *gbm;

	if (!fname)
		return NULL;

	if (!IFFParseBase)
		return NULL;

	if (!(gbm = (GuiBitMap *) GuiMalloc(sizeof(GuiBitMap), 0)))
		return NULL;

	if (!(gbm->bm = loadilbmBitMap(fname, &wide, &high, &deep)))
		{
		GuiFree(gbm);
		return NULL;
		}
	gbm->width = wide;
	gbm->height = high;
	gbm->depth = deep;
	gbm->flags = 0;
	gbm->bmi = NULL;
	gbm->next = gbm->obm = NULL;

	return gbm;
	}

BOOL FOXLIB FreeGuiBitMap(REGA0 GuiBitMap *bm)
	{
	if (bm)
		{
		freeBitMap(bm->bm);
		GuiFree(bm);
		return TRUE;
		}
	return FALSE;
	}

BOOL FOXLIB RedrawBitMap(REGA0 BitMapInstance *bmi)
	{
	if (bmi)
		{
/*		struct GuiWindow *win = bmi->win;
		GuiBitMap *bm = bmi->bm;
		unsigned short left = bmi->left, top = bmi->top;

		HideBitMap(bmi);
		ShowBitMap(bm, win, left, top, bm->flags);
*/
		BltBitMapRastPort(bmi->bm->bm, 0L, 0L, bmi->win->Win->RPort, (long) bmi->left, (long) bmi->top,
				(long) (bmi->bm->width), (long) (bmi->bm->height), (bmi->bm->flags & BM_OVERLAY ? 0x60 : 0xC0));
		WaitBlit();

		return TRUE;
		}
	return FALSE;
	}

static GuiBitMap *GetBitMap(unsigned short width, unsigned short height, unsigned short depth, short clear)
	{
	GuiBitMap *gbm;

	if (!(gbm = (GuiBitMap *) GuiMalloc(sizeof(GuiBitMap), 0)))
		return NULL;

	if (!(gbm->bm = getBitMap(width, height, depth, clear)))
		{
		GuiFree(gbm);
		return NULL;
		}
	gbm->width = width;
	gbm->height = height;
	gbm->depth = depth;
	gbm->flags = 0;
	gbm->bmi = NULL;
	gbm->next = gbm->obm = NULL;
	return gbm;
	}

GuiBitMap* FOXLIB ScaleBitMap(REGA0 GuiBitMap *source, REGD0 unsigned short destwidth, REGD1 unsigned short destheight)
	{
	GuiBitMap *destgbm;
	struct BitScaleArgs bsa;

	if (!(source && destwidth > 0 && destheight > 0 && Gui.LibVersion >= 36))
		return NULL;
	if (!(destgbm = GetBitMap(destwidth, destheight, source->depth, TRUE)))
		return NULL;

	memset(&bsa, 0, sizeof(struct BitScaleArgs));
	bsa.bsa_SrcWidth = source->width;
	bsa.bsa_SrcHeight = source->height;
	bsa.bsa_XSrcFactor = source->width;
	bsa.bsa_XDestFactor = destwidth;
	bsa.bsa_YSrcFactor = source->height;
	bsa.bsa_YDestFactor = destheight;
	bsa.bsa_SrcBitMap = source->bm;
	bsa.bsa_DestBitMap = destgbm->bm;

	while (bsa.bsa_XSrcFactor > 16383 || bsa.bsa_XDestFactor > 16383)
		{
		bsa.bsa_XSrcFactor /= 2;
		bsa.bsa_XDestFactor /= 2;
		}
	while (bsa.bsa_YSrcFactor > 16383 || bsa.bsa_YDestFactor > 16383)
		{
		bsa.bsa_YSrcFactor /= 2;
		bsa.bsa_YDestFactor /= 2;
		}

	BitMapScale(&bsa);
	WaitBlit(); // Wait for our blit(s) to finish incase the user wants to immediately free the source bm.

	destgbm->width = destwidth;
	destgbm->height = destheight;
	destgbm->depth = source->depth;
	destgbm->bmi = source->bmi;
	destgbm->flags = source->flags;
	destgbm->next = destgbm->obm = NULL;

	return destgbm;
	}


/*	Attach a bitmap (or a portion of a bitmap) to a control.  left, top are the offsets of the first
	pixel of the bitmap to use and width, height are the extent of the bitmap to use.  Set width and
	height to -1 to use the remainder of the bitmap. */
BOOL FOXLIB AttachBitMapToControl(REGA0 GuiBitMap *gbm, REGA1 void *control, REGD0 short left, REGD1 short top, REGD2 short width,
		REGD3 short height, REGD4 int flags)
	{
	PushButton *pb = (PushButton *) control;
	GuiBitMap *ngbm, *clip, *list;
	int ObjectWidth = pb->button.Width, ObjectHeight = pb->button.Height;

	if (!(gbm && control))
		return FALSE;

	// control may be a Frame or a PushButton.  The first three elements of each are identical.
	if (!(pb->WidgetData->ObjectType == FrameObject || pb->WidgetData->ObjectType == ButtonObject))
		return FALSE;

	if (pb->WidgetData->ObjectType == FrameObject)
	{
		Frame *fm = (Frame *) control;
		ObjectWidth = fm->points[8] + 1;
		ObjectHeight = fm->points[1] + 1;
	}

	if (ObjectWidth < 3 || ObjectHeight < 3)
		return FALSE;

	if (width == -1)
		width = gbm->width - left;
	if (height == -1)
		height = gbm->height - top;

	if (width < 1 || height < 1)
		return FALSE;

	if (left == 0 && top == 0 && width == gbm->width && height == gbm->height)
		// The user wants to use the whole bitmap supplied so no need to clip it.
		clip = NULL;
	else
		{
		// First cut out the portion of the bitmap we want to use and create a new bitmap out of it.
		if (!(clip = GetBitMap(width, height, gbm->depth, TRUE)))
			return FALSE;
		if (!BltBitMap(gbm->bm, left, top, clip->bm, 0, 0, width, height, 0xC0, 0xFF, NULL))
			{
			FreeGuiBitMap(clip);
			return FALSE;
			}
		}

	// Bit map scaling is not supported prior to V36 so assume BM_CLIP for V35 and below.
	if ((flags & BM_SCALE) && Gui.LibVersion >= 36)
		ngbm = ScaleBitMap(clip ? clip : gbm, ObjectWidth - 2, ObjectHeight - 2);
	else // BM_CLIP
		{
		if (!(ngbm = GetBitMap(ObjectWidth - 2, ObjectHeight - 2, gbm->depth, TRUE)))
			{
			if (clip)
				FreeGuiBitMap(clip);
			return FALSE;
			}
		if (!(BltBitMap((clip ? clip : gbm)->bm, 0, 0, ngbm->bm, 0, 0, ObjectWidth - 2, ObjectHeight - 2, 0xC0, 0xFF, NULL)))
			{
			if (clip)
				FreeGuiBitMap(clip);
			FreeGuiBitMap(ngbm);
			return FALSE;
			}
		WaitBlit(); // Wait for our blit(s) to finish before continuing.
		}

	ngbm->flags = flags;
	if (clip)
		FreeGuiBitMap(clip);

	/* If the BM_SMART flag is specified and the control is autosizing then keep a copy of the original
		bitmap so that when the window is resized we can redraw the buttons bitmap(s) by reference to the
		original and the bitmap won't lose any definition.  If the BM_SMART flag is not specified
		(BM_STUPID) then resizing the button will reference the bitmap currently on the button and will
		just scale that.  Multiple resizes will then cause loss of definition but the images will use
		less memory. */
	if (pb->WidgetData->flags & S_AUTO_SIZE && (flags & BM_SMART))
		{
		/*	We need a copy of the original GuiBitMap so that we can resize/clip the bitmap if the
			button/frame is resized. */
		if (!(ngbm->obm = GetBitMap(clip ? clip->width : gbm->width - left, clip ? clip->height : gbm->height - top, gbm->depth, FALSE)))
			{
			FreeGuiBitMap(ngbm);
			return FALSE;
			}
		ngbm->obm->flags = flags;
		if (!BltBitMap(gbm->bm, left, top, ngbm->obm->bm, 0, 0, clip ? clip->width : gbm->width - left, clip ? clip->height : gbm->height - top, 0xC0, 0xFF, NULL))
			{ // We couldn't copy the bitmap.
			FreeGuiBitMap(ngbm->obm);
			FreeGuiBitMap(ngbm);
			return FALSE;
			}
		}
	else
		ngbm->obm = NULL;

	// Draw the bitmap on the button
	if (GadInWinList(&pb->button, ((GuiWindow *) pb->button.UserData)->Win))
		ngbm->bmi = ShowBitMap(ngbm, (GuiWindow *) pb->button.UserData, pb->button.LeftEdge + 1, pb->button.TopEdge + 1, flags);
	else // The button/frame is currently hidden.
		ngbm->bmi = NULL;

	/*	Add the bitmap to the buttons list of bitmaps - we MUST add it to the end of the list NOT the
		start because that way when we re-draw the bitmaps, any that are overlaid will be overlaid in the
		correct order. */
	list = pb->bitmap;
	while (list && list->next)
		list = list->next;
	if (list)
		list->next = ngbm;
	else
		pb->bitmap = ngbm;
	return TRUE;
	}
