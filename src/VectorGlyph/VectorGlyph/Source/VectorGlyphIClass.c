/*
**	VectorGlyphIClass.c
**
**	Copyright (C) 1995,96,97 Bernardo Innocenti
**
**	Use 4 chars wide TABs to read this file
**
**	"vectorglyphiclass", a vector image class built
**	on top of the "imageclass", providing some useful
**	glyphs for buttons.
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <utility/tagitem.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>

#include "VectorGlyphIClass.h"
#include "CompilerSpecific.h"
#include "BoopsiStubs.h"

#ifdef OS30_ONLY
	#define WANTED_LIBVER	39
#else
	#define WANTED_LIBVER	37
#endif


/* Local function prototypes */

static ULONG HOOKCALL VectorGlyphDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Image *im),
	REG(a1, Msg msg));

static ULONG	VG_IMDraw		(Class *cl, struct Image *im, struct impDraw *imp);
static ULONG	VG_OMNew		(Class *cl, struct Image *im, struct opSet *ops);
static void		VG_OMDispose	(Class *cl, struct Image *im, Msg msg);

static void	DrawPlayImage		(struct RastPort *rp, UWORD width, UWORD heigth);
static void	DrawStopImage		(struct RastPort *rp, UWORD width, UWORD heigth);
static void	DrawForwardImage	(struct RastPort *rp, UWORD width, UWORD heigth);
static void	DrawRewindImage		(struct RastPort *rp, UWORD width, UWORD heigth);
static void	DrawPickImage		(struct RastPort *rp, UWORD width, UWORD height);


/* Class library support functions */

struct ClassLibrary	*	HOOKCALL _UserLibInit		(REG(a6, struct ClassLibrary *mybase));
struct ClassLibrary	*	HOOKCALL _UserLibCleanup	(REG(a6, struct ClassLibrary *mybase));
Class *					HOOKCALL _GetEngine			(REG(a6, struct ClassLibrary *mybase));


/* Library data */

const UBYTE LibName[] = "vectorglyph.image";
const UBYTE LibVer[] = { '$', 'V', 'E', 'R', ':', ' ' };
const UBYTE LibId[] = "vectorglyph.class 1.1 (25.9.97) © 1997 by Bernardo Innocenti\n";



/* Workaround a bug in StormC header file <proto/utility.h> */

#ifdef __STORM__
	#define UTILITYBASETYPE struct Library
#else
	#define UTILITYBASETYPE struct UtilityBase
#endif

/* Library bases */
static struct ExecBase		*SysBase		= NULL;
static struct IntuitionBase	*IntuitionBase	= NULL;
static struct GfxBase		*GfxBase		= NULL;
static UTILITYBASETYPE		*UtilityBase	= NULL;



static ULONG HOOKCALL VectorGlyphDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Image *im),
	REG(a1, Msg msg))

/* VectorGlyph class dispatcher - Handles all supported methods */
{
	switch (msg->MethodID)
	{
		case IM_DRAW:
			return VG_IMDraw (cl, im, (struct impDraw *)msg);

		case OM_NEW:
			return VG_OMNew (cl, im, (struct opSet *)msg);

		case OM_DISPOSE:
			VG_OMDispose (cl, im, msg);
			return 0;

		default:
			/* Unsupported method: let our superclass's
			 * dispatcher take a look at it.
			 */
			return DoSuperMethodA (cl, (Object *)im, msg);
	}
}



static ULONG VG_IMDraw (Class *cl, struct Image *im, struct impDraw *imp)
{
	if (im->ImageData)
		BltBitMapRastPort ((struct BitMap *)im->ImageData,
			0, 0, imp->imp_RPort,
			imp->imp_Offset.X, imp->imp_Offset.Y, im->Width, im->Height,
			(imp->imp_State == IDS_SELECTED) ? 0x030 : 0x0C0);

	return TRUE;
}



static ULONG VG_OMNew (Class *cl, struct Image *im, struct opSet *ops)
{
	/* Create the image structure */
	if (im = (struct Image *)DoSuperMethodA (cl, (Object *)im, (Msg) ops))
	{
		ULONG			 which;
		struct RastPort	 rp;

		which = GetTagData (SYSIA_Which, 0, ops->ops_AttrList);

		InitRastPort (&rp);

#ifndef OS30_ONLY
		if (GfxBase->LibNode.lib_Version >= 39)
#endif /* !OS30_ONLY */
			rp.BitMap = AllocBitMap (im->Width, im->Height, 1, BMF_CLEAR, NULL);
#ifndef OS30_ONLY
		else
		{
			if (rp.BitMap = AllocMem (sizeof (struct BitMap), MEMF_PUBLIC))
			{
				InitBitMap (rp.BitMap, 1, im->Width, im->Height);
				if (!(rp.BitMap->Planes[0] = AllocMem (RASSIZE(im->Width, im->Height), MEMF_CHIP | MEMF_CLEAR)))
				{
					FreeMem (rp.BitMap, sizeof (struct BitMap));
					rp.BitMap = NULL;
				}
			}
		}
#endif /* !OS30_ONLY */

		if (rp.BitMap)
		{
			PLANEPTR		planeptr;
			struct TmpRas	tmpras;
			struct AreaInfo	areainfo;
			WORD			areabuffer[(5 * 10 + 1) / 2];

			/* Allocate the TmpRass needed by AreaDraw */
			if (planeptr = AllocRaster (im->Width, im->Height))
			{
				InitTmpRas (&tmpras, planeptr, RASSIZE(im->Width, im->Height));
				InitArea (&areainfo, areabuffer, 10);
				SetAPen (&rp, 1);
				rp.TmpRas = &tmpras;
				rp.AreaInfo = &areainfo;

				switch (which)
				{
					case IM_PLAY:
						DrawPlayImage (&rp, im->Width, im->Height);
						break;

					case IM_STOP:
						DrawStopImage (&rp, im->Width, im->Height);
						break;

					case IM_FWD:
						DrawForwardImage (&rp, im->Width, im->Height);
						break;

					case IM_REW:
						DrawRewindImage (&rp, im->Width, im->Height);
						break;

					case IM_PICK:
						DrawPickImage (&rp, im->Width, im->Height);
						break;
				}

				/* Just to be sure... */
				rp.TmpRas = NULL;
				rp.AreaInfo = NULL;
				FreeRaster (planeptr, im->Width, im->Height);
			}

			/* Set the bitmap to depth 8, and clear all bitplane
			 * pointers except the first one.
			 * This way our image will complement better.
			 * See the BltBitMap() autodoc for the meaning
			 * of NULL bitplane pointers in the BitMap structure.
			 */
			{
				int i;

				for (i = 1; i < 8; i++)
					rp.BitMap->Planes[i] = (UBYTE *)0;

				rp.BitMap->Depth = 8;
			}

			/* NOTE: Failing to allocate the TmpRas will cause the
			 * image to be blank, but no error will be reported.
			 */

			/* Store the BitMap pointer here for later usage */
			im->ImageData = (UWORD *)rp.BitMap;

			return (ULONG)im;	/* Return new image object */
		}

		/* Dispose object without disturbing our subclasses */
		CoerceMethod (cl, (Object *)im, OM_DISPOSE);
	}

	return NULL;
}



static void VG_OMDispose (Class *cl, struct Image *im, Msg msg)
{
	/* Restore original depth! */
	((struct BitMap *)im->ImageData)->Depth = 1;

#ifndef OS30_ONLY
	if (GfxBase->LibNode.lib_Version >= 39)
#endif /* !OS30_ONLY */
		FreeBitMap ((struct BitMap *)im->ImageData);
#ifndef OS30_ONLY
	else
	{
		FreeMem (((struct BitMap *)im->ImageData)->Planes[0], RASSIZE(im->Width, im->Height));
		FreeMem (((struct BitMap *)im->ImageData), sizeof (struct BitMap));
	}
#endif /* !OS30_ONLY */

	/* Now let our superclass free it's istance */
	DoSuperMethodA (cl, (Object *)im, msg);
}



static void DrawPlayImage (struct RastPort *rp, UWORD width, UWORD height)
{
	UWORD	ymin = height / 4,
			ymax = (height * 3) / 4,
			ymid;

	ymin -= (ymax - ymin) & 1;	/* Force odd heigth for better arrow aspect */
	ymid = (ymin + ymax) / 2;

	RectFill (rp, 1, ymin, (width / 4) - 1, ymax);

	AreaMove (rp, width / 3, ymin);
	AreaDraw (rp, width - 2, ymid);
	AreaDraw (rp, width / 3, ymax);

	AreaEnd (rp);
}



static void DrawStopImage (struct RastPort *rp, UWORD width, UWORD height)
{
	RectFill (rp, width / 4, height / 4, (width * 3) / 4, (height * 3) / 4);
}



static void DrawForwardImage (struct RastPort *rp, UWORD width, UWORD height)
{
	UWORD	ymin = height / 4,
			ymax = (height * 3) / 4,
			ymid;

	ymin -= (ymax - ymin) & 1;	/* Force odd heigth for better arrow aspect */
	ymid = (ymin + ymax) / 2;

	AreaMove (rp, 1, ymin);
	AreaDraw (rp, width / 2, ymid);
	AreaDraw (rp, 1, ymax);

	AreaMove (rp, width / 2, ymin);
	AreaDraw (rp, width - 2, ymid);
	AreaDraw (rp, width / 2, ymax);

	AreaEnd (rp);
}



static void DrawRewindImage (struct RastPort *rp, UWORD width, UWORD height)
{
	UWORD	ymin = height / 4,
			ymax = (height * 3) / 4,
			ymid;

	ymin -= (ymax - ymin) & 1;	/* Force odd heigth for better arrow aspect */
	ymid = (ymin + ymax) / 2;

	AreaMove (rp, width - 2, ymin);
	AreaDraw (rp, width / 2, ymid);
	AreaDraw (rp, width - 2, ymax);

	AreaMove (rp, width / 2 - 1, ymin);
	AreaDraw (rp, 1, ymid);
	AreaDraw (rp, width / 2 - 1, ymax);

	AreaEnd (rp);
}



static void DrawPickImage (struct RastPort *rp, UWORD width, UWORD height)
/*
 *      arrowxmin
 *      | tailxmin
 *      | | tailxmax
 *      | | |
 *      | v v
 *      | ###<----tailymin
 *      v ###
 *      #######<--arrowymin
 *       #####
 *        ###
 *         #<-----arrowymax
 *      #######<--arrowymax+1
 */
{
	UWORD	tailymin	= height / 6,
			tailxmin	= (width * 2) / 5,
			tailxmax	= (width * 3) / 5,
			arrowymin	= (height * 2) / 5,
			arrowymax	= (height * 4) / 5,
			arrowxmin	= width / 5,
			arrowxmax	= (width * 4) / 5;

	AreaMove (rp, tailxmin, tailymin);
	AreaDraw (rp, tailxmax, tailymin);
	AreaDraw (rp, tailxmax, arrowymin);
	AreaDraw (rp, arrowxmax, arrowymin);
	AreaDraw (rp, (arrowxmin + arrowxmax) / 2, arrowymax);
	AreaDraw (rp, arrowxmin, arrowymin);
	AreaDraw (rp, tailxmin, arrowymin);
	AreaEnd (rp);

	if (arrowymax < height - 1) arrowymax++;

	Move (rp, arrowxmin, arrowymax);
	Draw (rp, arrowxmax, arrowymax);
}



/*
 * Class library support functions
 */

struct ClassLibrary * HOOKCALL _UserLibInit (REG(a6, struct ClassLibrary *mybase))
{
	SysBase = *((struct ExecBase **)4);	/* Initialize SysBase */

	IntuitionBase	= (struct IntuitionBase *) OpenLibrary ("intuition.library", WANTED_LIBVER);
	GfxBase			= (struct GfxBase *) OpenLibrary ("graphics.library", WANTED_LIBVER);
	UtilityBase		= (UTILITYBASETYPE *) OpenLibrary ("utility.library", WANTED_LIBVER);

	if (!(IntuitionBase && GfxBase && UtilityBase))
	{
		_UserLibCleanup (mybase);
		return NULL;
	}

	if (mybase->cl_Class = MakeClass (VECTORGLYPHCLASS, IMAGECLASS, NULL, 0, 0))
	{
		mybase->cl_Class->cl_Dispatcher.h_Entry = (ULONG (*)()) VectorGlyphDispatcher;
		AddClass (mybase->cl_Class);
	}
	else
	{
		_UserLibCleanup (mybase);
		return NULL;
	}

	return mybase;
}



struct ClassLibrary * HOOKCALL _UserLibCleanup (REG(a6, struct ClassLibrary *mybase))
{
	if (mybase->cl_Class)
		if (!FreeClass (mybase->cl_Class))
			return NULL;

	CloseLibrary ((struct Library *)UtilityBase);
	CloseLibrary ((struct Library *)GfxBase);
	CloseLibrary ((struct Library *)IntuitionBase);

	return mybase;
}



Class * HOOKCALL _GetEngine (REG(a6, struct ClassLibrary *mybase))
{
	return (mybase->cl_Class);
}
