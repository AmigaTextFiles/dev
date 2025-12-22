/*
**	Chip.c   Chipmem Daten für Gadgets
**	12.09.92 - 12.10.92
*/

#include <intuition/classes.h>
#include "Chip.pro"

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "Gadget_lib.h"
#else
#ifdef STATIC
#undef STATIC
#endif
#define STATIC
#endif

extern struct Library *IntuitionBase;

struct TextAttr TextAttr=
{
   (STRPTR)"topaz.font",
   TOPAZ_EIGHTY,
   FS_NORMAL,
   FPF_ROMFONT,
};

struct TextAttr BoldTextAttr=
{
   (STRPTR)"topaz.font",
   TOPAZ_EIGHTY,
   FSF_BOLD,
   FPF_ROMFONT,
};

WORD Pens13[]=
{
	0, 		/* DETAILPEN compatible Intuition rendering pens	*/
	1,			/* BLOCKPEN	 compatible Intuition rendering pens	*/
	1, 		/* TEXTPEN 	 text on background 			*/
	1,			/* SHINEPEN	 bright edge on 3D objects		*/
	2, 		/* SHADOWPEN dark edge on 3D objects		*/
	3,			/* FILLPEN 		active-window/selected-gadget fill	*/
	1,			/* FILLTEXTPEN	text over FILLPEN			*/
	0,			/* BACKGROUNDPEN always color 0			*/
	3, 		/* HIGHLIGHTTEXTPEN special color text, on background	*/
};
WORD *Pens = Pens13;

USHORT checkdata0[] =
{
	0,64,   0,192,   0,192,   0,192,   0,192,   0,192,   0,192,   0,192,
   0,192,   0,192,   32767,-64,   -1,-128,   -16384,0,   -16384,0,
   -16384,0,   -16384,0,   -16384,0,   -16384,0,   -16384,0,   -16384,0,
   -16384,0,   -32768,0,
};
struct Image checkimage0 =
{
   0,0,26,11,2,   NULL,3,0,NULL,
};

USHORT checkdata1[] =
{
   0,64,   0,192,   0,28864,   0,-16192,   1,-32576,   451,192,   230,192,
   124,192,   56,192,   0,192,   32767,-64,   -1,-128,   -16384,0,
   -16384,0,   -16384,0,   -16384,0,   -16384,0,   -16384,0,   -16384,0,
   -16384,0,   -16384,0,   -32768,0,
};
struct Image checkimage1 =
{
   0,0,26,11,2,   NULL,3,0,NULL,
};

USHORT radiodata0[] =
{
   2,0,   3,0,   1,-32768,   1,-32768,   1,-32768,   1,-32768,   1,-32768,
   3,0,   8190,0,   16380,0,   24576,0,   -16384,0,   -16384,0,   -16384,0,
   -16384,0,   -16384,0,   24576,0,   8192,0,
};

struct Image radioimage0 =
{
   0,0,17,9,2,   NULL,3,0,NULL,
};

USHORT radiodata1[] =
{
   16380,0,   24576,0,   -14352,0,   -12296,0,   -12296,0,   -12296,0,
   -14352,0,   24576,0,   8192,0,   2,0,   3,0,   2033,-32768,   4089,-32768,
   4089,-32768,   4089,-32768,   2033,-32768,   3,0,   8190,0,
};

struct Image radioimage1 =
{
   0,0,17,9,2, NULL,3,0,NULL,
};

USHORT updata0[]=
{
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x00c0, 0x4000,
	0x0330, 0x4000,
	0x0c0c, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x7fff, 0xc000,

	0xffff, 0x8000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
};

struct Image upimage0=
{
	0, 0, 18, 11, 2, NULL, 3, 0, NULL,
};

USHORT updata1[]=
{
	0xffff, 0xc000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0x0000, 0x0000,

	0x0000, 0x0000,
	0x7fff, 0xc000,
	0x7fff, 0xc000,
	0x7f3f, 0xc000,
	0x7c0f, 0xc000,
	0x70c3, 0xc000,
	0x73f3, 0xc000,
	0x7fff, 0xc000,
	0x7fff, 0xc000,
	0x7fff, 0xc000,
	0xffff, 0xc000,
};

struct Image upimage1=
{
	0, 0, 18, 11, 2, NULL, 3, 0, NULL,
};

USHORT downdata0[]=
{
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x0c0c, 0x4000,
	0x0330, 0x4000,
	0x00c0, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x0000, 0x4000,
	0x7fff, 0xc000,

	0xffff, 0x8000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
	0x8000, 0x0000,
};

struct Image downimage0=
{
	0, 0, 18, 11, 2, NULL, 3, 0, NULL,
};

USHORT downdata1[]=
{
	0xffff, 0xc000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0xffff, 0x8000,
	0x0000, 0x0000,

	0x0000, 0x0000,
	0x7fff, 0xc000,
	0x7fff, 0xc000,
	0x7fff, 0xc000,
	0x73f3, 0xc000,
	0x70c3, 0xc000,
	0x7c0f, 0xc000,
	0x7f3f, 0xc000,
	0x7fff, 0xc000,
	0x7fff, 0xc000,
	0xffff, 0xc000,
};

struct Image downimage1=
{
	0, 0, 18, 11, 2, NULL, 3, 0, NULL,
};

USHORT leftdata0[]=
{
	0x0000,
	0x0001,
	0x0061,
	0x0181,
	0x0601,
	0x0181,
	0x0061,
	0x0001,
	0x0001,
	0xffff,

	0xffff,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x0000,
};

struct Image leftimage0=
{
	0, 0, 16, 10, 2, NULL, 3, 0, NULL,
};

USHORT leftdata1[]=
{
	0xffff,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0x0000,

	0x0000,
	0x7fff,
	0x7f1f,
	0x7c7f,
	0x71ff,
	0x7c7f,
	0x7f1f,
	0x7fff,
	0x7fff,
	0xffff,
};

struct Image leftimage1=
{
	0, 0, 16, 10, 2, NULL, 3, 0, NULL,
};

USHORT rightdata0[]=
{
	0x0000,
	0x0001,
	0x0601,
	0x0181,
	0x0061,
	0x0181,
	0x0601,
	0x0001,
	0x0001,
	0xffff,

	0xffff,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x0000,
};

struct Image rightimage0=
{
	0, 0, 16, 10, 2, NULL, 3, 0, NULL,
};

USHORT rightdata1[]=
{
	0xffff,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0xfffe,
	0x0000,

	0x0000,
	0x7fff,
	0x78ff,
	0x7e3f,
	0x7f8f,
	0x7e3f,
	0x78ff,
	0x7fff,
	0x7fff,
	0xffff,
};

struct Image rightimage1=
{
	0, 0, 16, 10, 2, NULL, 3, 0, NULL,
};

USHORT getfiledata0[]=
{
	0x0000, 0x1000,
	0x0000, 0x3000,
	0x003c, 0x3000,
	0x0042, 0x3000,
	0x0f81, 0x3000,
	0x0fc1, 0x3000,
	0x0c3f, 0x3000,
	0x0c01, 0x3000,
	0x0c01, 0x3000,
	0x0c01, 0x3000,
	0x0fff, 0x3000,
	0x0000, 0x3000,
	0x0000, 0x3000,
	0x7fff, 0xf000,

	0xffff, 0xe000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0xc000, 0x0000,
	0x8000, 0x0000,
};

struct Image getfileimage0=
{
	0, 0, 20, 14, 2, NULL, 3, 0, NULL,
};

USHORT getfiledata1[]=
{
	0xffff, 0xe000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0xffff, 0xc000,
	0x8000, 0x0000,

	0x0000, 0x1000,
	0x3fff, 0xf000,
	0x3fc3, 0xf000,
	0x3fbd, 0xf000,
	0x307e, 0xf000,
	0x303e, 0xf000,
	0x33c0, 0xf000,
	0x33fe, 0xf000,
	0x33fe, 0xf000,
	0x33fe, 0xf000,
	0x3000, 0xf000,
	0x3fff, 0xf000,
	0x3fff, 0xf000,
	0x7fff, 0xf000,
};

struct Image getfileimage1=
{
	0, 0, 20, 14, 2, NULL, 3, 0, NULL,
};

struct Image *upimage2=NULL, *downimage2=NULL, *leftimage2=NULL, *rightimage2=NULL;

STATIC BOOL allocimagedata(struct Image *image, USHORT *data, ULONG size)
{
	if(!image->ImageData && (image->ImageData = ALLOCCHIPMEM(size)))
      CopyMem((UBYTE *)data, (UBYTE *)image->ImageData, size);
	return(image->ImageData != NULL);
}

BOOL gadAllocChip(void)
{
	struct Screen *screen = NULL;
	struct DrawInfo *drinfo = NULL;
	BOOL ret = FALSE;
	SHORT i;

	if(allocimagedata(&checkimage0, checkdata0, sizeof(checkdata0)) &&
	allocimagedata(&checkimage1, checkdata1, sizeof(checkdata1)) &&
	allocimagedata(&radioimage0, radiodata0, sizeof(radiodata0)) &&
	allocimagedata(&radioimage1, radiodata1, sizeof(radiodata1)) &&
	allocimagedata(&downimage0, downdata0, sizeof(downdata0)) &&
	allocimagedata(&downimage1, downdata1, sizeof(downdata1)) &&
	allocimagedata(&upimage0, updata0, sizeof(updata0)) &&
	allocimagedata(&upimage1, updata1, sizeof(updata1)) &&
	allocimagedata(&leftimage0, leftdata0, sizeof(leftdata0)) &&
	allocimagedata(&leftimage1, leftdata1, sizeof(leftdata1)) &&
	allocimagedata(&rightimage0, rightdata0, sizeof(rightdata0)) &&
	allocimagedata(&rightimage1, rightdata1, sizeof(rightdata1)) &&
	allocimagedata(&getfileimage0, getfiledata0, sizeof(getfiledata0)) &&
	allocimagedata(&getfileimage1, getfiledata1, sizeof(getfiledata1)))
	{
		if(!ISKICK20)
			ret = TRUE;
      else if((screen = LockPubScreen(NULL)) &&
		(drinfo = GetScreenDrawInfo(screen)) 	&&
		(upimage2 || (upimage2 = (struct Image *)
		NewObject(NULL, (UBYTE *)SYSICLASS,	SYSIA_DrawInfo, drinfo,
   												GADAR_Which, UPIMAGE,
   												SYSIA_Size, SYSISIZE_MEDRES,
													TAG_END))) &&
		(downimage2 || (downimage2 = (struct Image *)
		NewObject(NULL, (UBYTE *)SYSICLASS,	SYSIA_DrawInfo, drinfo,
   												GADAR_Which, DOWNIMAGE,
   												SYSIA_Size, SYSISIZE_MEDRES,
													TAG_END))) &&
		(leftimage2 || (leftimage2 = (struct Image *)
		NewObject(NULL, (UBYTE *)SYSICLASS, SYSIA_DrawInfo, drinfo,
   												GADAR_Which, LEFTIMAGE,
   												SYSIA_Size, SYSISIZE_MEDRES,
													TAG_END))) &&
		(rightimage2 || (rightimage2 = (struct Image *)
		NewObject(NULL, (UBYTE *)SYSICLASS,	SYSIA_DrawInfo, drinfo,
   												GADAR_Which, RIGHTIMAGE,
   												SYSIA_Size, SYSISIZE_MEDRES,
													TAG_END))))
		{
         CopyMem(drinfo->dri_Pens, Pens13, sizeof(Pens13));
			ret = TRUE;
		}
	}
	if(drinfo)
		FreeScreenDrawInfo(screen, drinfo);
	if(screen)
   	UnlockPubScreen(NULL, screen);
	if(!ret)
		gadFreeChip();
	return(ret);
}

STATIC void freeimagedata(struct Image *image, ULONG size)
{
	if(image->ImageData)
		FREECHIPMEM(image->ImageData, size);
	image->ImageData = NULL;
}

void gadFreeChip(void)
{
	freeimagedata(&checkimage0, sizeof(checkdata0));
	freeimagedata(&checkimage1, sizeof(checkdata1));
	freeimagedata(&radioimage0, sizeof(radiodata0));
	freeimagedata(&radioimage1, sizeof(radiodata1));
	freeimagedata(&downimage0, sizeof(downdata0));
	freeimagedata(&downimage1, sizeof(downdata1));
	freeimagedata(&upimage0, sizeof(updata0));
	freeimagedata(&upimage1, sizeof(updata1));
	freeimagedata(&leftimage0, sizeof(leftdata0));
	freeimagedata(&leftimage1, sizeof(leftdata1));
	freeimagedata(&rightimage0, sizeof(rightdata0));
	freeimagedata(&rightimage1, sizeof(rightdata1));
	freeimagedata(&getfileimage0, sizeof(getfiledata0));
	freeimagedata(&getfileimage1, sizeof(getfiledata1));
	if(upimage2)
	{
		DisposeObject(upimage2);
		upimage2 = NULL;
	}
	if(downimage2)
	{
		DisposeObject(downimage2);
		downimage2 = NULL;
	}
	if(leftimage2)
	{
		DisposeObject(leftimage2);
		leftimage2 = NULL;
	}
	if(rightimage2)
	{
		DisposeObject(rightimage2);
		rightimage2 = NULL;
	}
}

