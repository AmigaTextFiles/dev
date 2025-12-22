/*
** $Id: Guigfx_functions.c 1.2 2000/03/30 23:02:36 msbethke Exp msbethke $
**
** $Log: Guigfx_functions.c $
** Revision 1.2  2000/03/30 23:02:36  msbethke
** Completed the NewImage->Guigfx renaming
**
** Revision 1.1  2000/03/30 22:34:50  msbethke
** Initial revision
**
*/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/locale.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/datatypes.h>
#include <proto/utility.h>
#include <proto/icon.h>
#include <proto/asl.h>
#include <proto/gadtools.h>
#include <proto/guigfx.h>
#include <pragmas/exec_sysbase_pragmas.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/muimaster_protos.h>
#include <cybergraphics/cybergraphics.h>
#include <guigfx/guigfx.h>
#include <libraries/mui.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <datatypes/pictureclass.h>
#include <datatypes/PictureClassExt.h>
#include <lib/mb_utils.h>
#include "Guigfx_mcc.h"
#include "Guigfx_functions.h"
#include "Guigfx_data.h"
#include "debug.h"

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#ifndef max
#define   max(a,b) ((a) > (b) ? (a) : (b))
#endif

#ifndef min
#define   min(a,b) ((a) <= (b) ? (a) : (b))
#endif


/* local protos */
static ULONG *NewPalette(struct Data*,WORD,WORD);
static BOOL GetPalette(struct Data*, LONG, WORD, ULONG**);
static void DoTransparencyEffect(struct Data*);


extern struct Library *GuiGFXBase;

/******************************************************************************/

BOOL InitGuiGfxStuff(struct Data *d)
{
	if(d->PSM = CreatePenShareMapA(NULL))
	{
		DB(KPrintf("created PenShareMap\n"));
		if(AddPictureA(d->PSM,d->Picture,NULL))
		{
			GetPictureAttrs(d->Picture,			// get picture size
				PICATTR_Width,&d->OrigW,
				PICATTR_Height,&d->OrigH,
				TAG_DONE);
			DB(KPrintf("got picture size: %ldx%ld\n",d->OrigW,d->OrigH));
			d->ShowRect.MinX = d->ShowRect.MinY = 0;
			d->ShowRect.MaxX = d->OrigW;
			d->ShowRect.MaxY = d->OrigH;
			return TRUE;
		}
	}
	return FALSE;
}

/******************************************************************************/

void FreeGuiGfxStuff(struct Data *d)
{
	if(d->DisposePicture && d->Picture)
	{
		DeletePicture(d->Picture);
		DB(KPrintf("disposed of picture\n"));
	}
	if(d->PSM)
	{
		DeletePenShareMap(d->PSM);
		DB(KPrintf("deleted PenShareMap\n"));
	}
}

/******************************************************************************/
/******************************************************************************/

void SetPicSize(struct Data *d, ULONG w, ULONG h)
{
#ifdef DEBUG
	DB(KPrintf("SetpicSize(): scalemode: "));
	if(!d->ScaleMode) KPrintf("NONE");
	if(d->ScaleMode & NISMF_SCALEUP) KPrintf("SCALEUP ");
	if(d->ScaleMode & NISMF_SCALEDOWN) KPrintf("SCALEDOWN ");
	if(d->ScaleMode & NISMF_KEEPASPECT_SCREEN) KPrintf("KEEPASPECT_SCREEN ");
	if(d->ScaleMode & NISMF_KEEPASPECT_PICTURE) KPrintf("KEEPASPECT_PICTURE");
	KPrintf("\n");
#endif
	if(d->ScaleMode & NISMF_SCALEMASK)					// if scaling is allowed at all
	{
		DB(KPrintf("SetpicSize(): scaling allowed\n"));
		if(d->ScaleMode & NISMF_KEEPASPECT)				// if aspect has to be kept
		{
		ULONG ScaleFactor, ScaleX, ScaleY, PosX, PosY;

			ScaleX = (w << 16) / d->CorrW;				// calculate x/y scaling factor in 16:16 fixpoint
			ScaleY = (h << 16) / d->CorrH;
			ScaleFactor = min(ScaleX, ScaleY);

			d->PicW = (ScaleFactor * d->CorrW) >> 16;
			d->PicH = (ScaleFactor * d->CorrH) >> 16;
			PosX = w - d->PicW;
			PosY = h - d->PicH;
			d->PosX = abs(PosX) / 2;
			d->PosY = abs(PosY) / 2;

			DB(KPrintf("SetpicSize(): KeepAspect - X=%ld, Y=%ld -> factor=%ld\n",ScaleX,ScaleY,ScaleFactor));
		} else													// no aspect restrictions, just set new size
		{
			DB(KPrintf("SetpicSize(): no aspect restrictions\n"));
			d->PicW = w;
			d->PicH = h;
			d->PosX = d->PosY = 0;
		}
	} else														// no scaling allowed, just copy original sizes
	{
		DB(KPrintf("SetpicSize(): no scaling, using original size (%ldx%ld)\n",d->CorrW,d->CorrH));
		d->PicW = d->CorrW;
		d->PicH = d->CorrH;
		d->PosX = d->PosY = 0;
	}
	DB(KPrintf("SetpicSize(): new size is %ldx%ld; pos. %ld+%ld\n",d->PicW,d->PicH,d->PosX,d->PosY));
}

/*****************************************************************************
** CalculateScalingFactors()
**
** Calculates new image dimensions to display it aspect-corrected on the
** current display (_screen(obj) must be valid!).
*****************************************************************************/
void CalculateScalingFactors(struct Data *d)
{
ULONG ImgXA, ImgYA, ScrmXA, ScrmYA, ax=0, ay=0;
ULONG ModeID;
BOOL CalcOK=FALSE;

	d->CorrW = d->OrigW;
	d->CorrH = d->OrigH;

	if(!(d->ScaleMode & NISMF_KEEPASPECT_SCREEN))
	{
		DB(KPrintf("CalculateScalingFactors(): ignoring screen aspect\n"));
		return;
	}

	if((ModeID = GetVPModeID(&(_screen(d->this)->ViewPort))) != INVALID_ID)
	{
		DisplayInfoHandle dih;

		DB(KPrintf("CalculateScalingFactors(): ModeID 0x%lx\n",ModeID));

		if(dih = FindDisplayInfo(ModeID))
		{
			struct DisplayInfo dinfo;

			if(GetDisplayInfoData(dih,(UBYTE*)&dinfo,sizeof(dinfo),DTAG_DISP,NULL) != 0)
			{
				ScrmXA = dinfo.Resolution.y;
				ScrmYA = dinfo.Resolution.x;

				// normalize
				if(ScrmXA > ScrmYA)
				{
					ScrmYA = (ScrmYA<<16) / ScrmXA;
					ScrmXA = 1<<16;
				} else {
					ScrmXA = (ScrmXA<<16) / ScrmYA;
					ScrmYA = 1<<16;
				}

				DB(KPrintf("CalculateScalingFactors(): normalized screen aspect %ld:%ld\n",ScrmXA,ScrmYA));

				// get image's aspect ratio
				if(GetPictureAttrs(d->Picture,
						PICATTR_AspectX, &ImgXA,
						PICATTR_AspectY, &ImgYA,
						TAG_DONE) == 2)
				{

					DB(KPrintf("CalculateScalingFactors(): image's aspect ratio is %ld:%ld\n",ImgXA,ImgYA));

					// normalize
					if(ImgXA > ImgYA)
					{
						ImgYA = (ImgYA<<16) / ImgXA;
						ImgXA = 1<<16;
					} else {
						ImgXA = (ImgXA<<16) / ImgYA;
						ImgYA = 1<<16;
					}

					DB(KPrintf("CalculateScalingFactors(): normalized image aspect %ld:%ld\n",ImgXA,ImgYA));

					ax = (ScrmYA<<15) / (ImgXA>>1);
					ay = (ScrmXA<<15) / (ImgXA>>1);

					DB(KPrintf("CalculateScalingFactors(): image must be scaled by %ld/%ld\n",ax,ay));

					CalcOK = TRUE;
				}
			}

			if(CalcOK) {
				d->CorrW = (d->OrigW<<16) / ax;
				d->CorrH = (d->OrigH<<16) / ay;
				DB(KPrintf("CalculateScalingFactors(): corrected image size is %ldx%ld\n",d->CorrW,d->CorrH));
			} else {
				d->CorrW = d->OrigW;
				d->CorrH = d->OrigH;
				DB(KPrintf("CalculateScalingFactors(): couldn't obtain all data!\n"));
			}
		}
	}
}

/*****************************************************************************
** GetNewHandle()
**
** Obtains a new DrawHandle (like for MUIM_Show which might give the object
** a new display environmemt)
******************************************************************************/

BOOL GetNewHandle(struct Data *d, Object *obj)
{
	DB(KPrintf("GetNewHandle(): starting\n"));

	if(d->DrawHandle = ObtainDrawHandle(d->PSM,_rp(obj),		// get a DrawHandle
			_screen(obj)->ViewPort.ColorMap,
			GGFX_DitherMode, d->DitherMode,
			GGFX_AutoDither, d->AutoDither,
			d->DitherThresh ? GGFX_DitherThreshold : TAG_IGNORE, d->DitherThresh,
			OBP_Precision, d->Precision,
			TAG_DONE))
	{
		DB(KPrintf("GetNewHandle(): created DrawHandle @$%08.lx\n",d->DrawHandle));
		return TRUE;
	}
	return FALSE;
}

/******************************************************************************
** RenderBitmaps()
**
** Renders bitmaps assuming a valid DrawHandle, like for size changes
*******************************************************************************/

BOOL RenderBitmaps(struct Data *d, Object *obj)
{
ULONG	SrcW=d->ShowRect.MaxX - d->ShowRect.MinX,
		SrcH=d->ShowRect.MaxY - d->ShowRect.MinY;

	DB(KPrintf("RenderBitmaps(): starting\n"));

//	DoTransparencyEffect(d);

	if(d->PicBM = CreatePictureBitMap(d->DrawHandle,d->Picture,
							GGFX_DestWidth, d->PicW,
							GGFX_DestHeight, d->PicH,
							GGFX_SourceX, d->ShowRect.MinX,
							GGFX_SourceY, d->ShowRect.MinY,
							GGFX_SourceWidth, SrcW,
							GGFX_SourceHeight, SrcH,
							TAG_DONE))
	{
		DB(KPrintf("RenderBitmaps(): created %ldx%ld bitmap @$%08.lx\n",d->PicW,d->PicH,d->PicBM));

		if(d->Transparency)
		{
		ULONG has_mask=FALSE;
	
			DB(KPrintf("RenderBitmaps(): transparency on ($%02lx)\n",d->Transparency));

			if(d->Transparency & NITRF_MASK)
			{
				GetPictureAttrs(d->Picture, PICATTR_AlphaPresent, &has_mask, TAG_DONE);
				DB(KPrintf("RenderBitmaps(): transparency mask requested (%spresent)\n",has_mask?"":"not "));
			}

			if(!has_mask && (d->Transparency & NITRF_RGB))
			{
				has_mask = DoPictureMethod(d->Picture,PICMTHD_CREATEALPHAMASK,d->TransColor);
				DB(KPrintf("RenderBitmaps(): transparency RGB ($%08.lx) requested\n"));
			}

			if(has_mask)
			{
			UWORD MaskWidth;
			PLANEPTR blitmask;

				MaskWidth = (d->PicW+15) & 0xfff0;
				DB(KPrintf("RenderBitmaps(): trying to create %ldx%ld bitmap from alphachannel\n",MaskWidth,d->PicH));
				if(blitmask = AllocRaster(MaskWidth,d->PicH))
				{
					DB(KPrintf("RenderBitmaps(): raster allocated @$%08.lx\n",blitmask));
				 	if(CreatePictureMask(d->Picture,blitmask,MaskWidth>>3,
							GGFX_Ratio, 1,
							GGFX_DestWidth, d->PicW,
							GGFX_DestHeight, d->PicH,
							GGFX_SourceX, d->ShowRect.MinX,
							GGFX_SourceY, d->ShowRect.MinY,
							GGFX_SourceWidth, SrcW,
							GGFX_SourceHeight, SrcH,
							TAG_DONE))
					{
						DB(KPrintf("RenderBitmaps(): successfully created mask\n"));
						d->BltMask = blitmask;
					} else
					{
						DB(KPrintf("RenderBitmaps(): error creating mask, freeing raster!\n",d->DrawHandle));
						FreeRaster(blitmask, MaskWidth, d->PicH);
					}
				} else
				{
					DB(KPrintf("RenderBitmaps(): could not allocate raster!\n",d->DrawHandle));
				}

			} else d->BltMask = NULL;
		} else d->BltMask = NULL;
		DB(KPrintf("RenderBitmaps(): done OK\n"));
		return TRUE;
	}
	DB(KPrintf("RenderBitmaps(): done failed\n"));
	return FALSE;
}

/******************************************************************************
** DisposeBitmapsAndHandle()
**
** Disposes of blitmask, picture bitmap and DrawHandle
*******************************************************************************/

void DisposeBitmapsAndHandle(struct Data *d)
{
	DisposeBitmaps(d);
	if(d->DrawHandle)
	{
		DB(KPrintf("DisposeBitmapsAndHandle(): releasing DrawHandle\n"));
		ReleaseDrawHandle(d->DrawHandle);
		d->DrawHandle = NULL;
	}
}

/******************************************************************************
** DisposeBitmaps()
**
** Disposes of the blitmask and picture bitmap but leaves the DrawHandle
** allocated
*******************************************************************************/

void DisposeBitmaps(struct Data *d)
{
	if(d->BltMask)
	{
		DB(KPrintf("DisposeBitmaps(): freeing blitmask\n"));
		FreeRaster(d->BltMask, (d->PicW+15)&0xfff0, d->PicH);
		d->BltMask = NULL;
	}
	if(d->PicBM)
	{
		DB(KPrintf("DisposeBitmaps(): freeing picture bitmap\n"));
		FreeBitMap(d->PicBM);
		d->PicBM = NULL;
	}
}

/******************************************************************************
** SetQuality(ULONG quality)
**
** Translates quality setting to DitherMode, AutoDither, DitherThreshold and
** Precision values
*******************************************************************************/

void SetQuality(struct Data *d, ULONG qual)
{
struct QUALITIES
{
	LONG Precision;
	LONG DitherMode;
	LONG DitherThresh;
	BOOL AutoDither;
} QualiTab[4] =
{
	{PRECISION_ICON,DITHERMODE_NONE,0,FALSE}, {PRECISION_ICON,DITHERMODE_EDD,250,TRUE},
	{PRECISION_IMAGE,DITHERMODE_EDD,200,TRUE} , {PRECISION_IMAGE,DITHERMODE_FS,100,FALSE}
};

	if((qual >= MUIV_Guigfx_Quality_Low) &&
		(qual <= MUIV_Guigfx_Quality_Best))
	{
		d->Precision	= QualiTab[qual].Precision;
		d->DitherMode	= QualiTab[qual].DitherMode;
		d->DitherThresh= QualiTab[qual].DitherThresh;
		d->AutoDither	= QualiTab[qual].AutoDither;

		DB(KPrintf("SetQuality():\n\tPrecision   : %ld\n\tDitherMode  : %ld\n\tDitherThresh: %ld\n\tAutoDither  : %s\n",d->Precision,d->DitherMode,d->DitherThresh,d->AutoDither?"TRUE":"FALSE"));
	}
}

BOOL __inline SetNewBitmap(struct MUIP_Guigfx_BitMapInfo *bmi, struct Data *d)
{
ULONG PicTags[14], *TagPtr=PicTags, *Palette, ncolors;
BOOL FreePalette;

	if((!bmi) || (!(bmi->Version))) return FALSE;		// only check for zero right now
	ncolors = 1<<bmi->Bitmap->Depth;

	FreePalette = GetPalette(d,(LONG)bmi->ColorTable,ncolors,&Palette);

	if(!Palette)
	{
		DB(KPrintf("SetNewBitmap(): can't create palette or NULL pointer passed in!\n"));
		return FALSE;
	}

	DisposeBitmapsAndHandle(d);
	FreeGuiGfxStuff(d);

	if(bmi->AspectX && bmi->AspectY)
	{
		*TagPtr++ = GGFX_AspectX;
		*TagPtr++ = bmi->AspectX;
		*TagPtr++ = GGFX_AspectY;
		*TagPtr++ = bmi->AspectY;
	}
	*TagPtr++ = GGFX_PixelFormat;
	*TagPtr++ = PIXFMT_BITMAP_CLUT;
	*TagPtr++ = GGFX_Palette;
	*TagPtr++ = (ULONG)Palette;
	*TagPtr++ = GGFX_NumColors;
	*TagPtr++ = ncolors;
	*TagPtr++ = GGFX_PaletteFormat;
	*TagPtr++ = PALFMT_RGB32;
	*TagPtr = TAG_DONE;

	if(d->Picture = MakePictureA(bmi->Bitmap,
							GetBitMapAttr(bmi->Bitmap,BMA_WIDTH),
							GetBitMapAttr(bmi->Bitmap,BMA_HEIGHT),
							(struct TagItem*)PicTags))
	{
		InitGuiGfxStuff(d);
		SetSuperAttrs(d->myclass,d->this,MUIA_Guigfx_Picture,d->Picture,TAG_DONE);
		DB(KPrintf("SetNewBitmap(): MUIA_Guigfx_BitmapInfo: probably still buggy...\n"));
		d->DisposePicture = TRUE;
	}
	if(FreePalette) FreeVec(Palette);
	return TRUE;
}


BOOL SetNewImage(struct MUIP_Guigfx_ImageInfo *iinf, struct Data *d)
{
struct Image *img = iinf->Image;
struct BitMap *bm;
ULONG *Palette;
LONG ncolors = 1<<img->Depth;
UWORD TotWidth = (img->Width+15)&0xfff0;
BOOL rc=FALSE, FreePalette;

	if(!iinf) return FALSE;

	FreePalette = GetPalette(d,(LONG)iinf->ColorTable,ncolors,&Palette);

	if(!Palette)
	{
		DB(KPrintf("SetNewImage(): can't create palette or NULL pointer passed in!\n"));
		return FALSE;
	}

	// allocate a bitmap to copy image data to
	if(bm = AllocBitMap(TotWidth,img->Height,img->Depth,BMF_CLEAR,NULL))
	{
	int p,x,y;
	UWORD *srcp, *destp;

		// all allocations OK, so dispose of the old class data
		DisposeBitmapsAndHandle(d);
		FreeGuiGfxStuff(d);

		DB(KPrintf("SetNewImage():\n\tImageData : $%08.lx\n\tWidth     : %ld (-> %ld)\n\tHeight    : %ld\n\tDepth     : %ld\n\tPlanePick : $%02.lx\n\tPlaneOnOff: $%02.lx\n",
				img->ImageData, img->Width, TotWidth, img->Height, img->Depth, (long)(img->PlanePick), (long)(img->PlaneOnOff)));

		// copy data Image -> Bitmap
		srcp = img->ImageData;
		for(p=0; p<img->Depth; p++)
		{
			destp = (UWORD*)(bm->Planes[p]);
			DB(KPrintf("SetNewImage(): Plane %ld @ $%08.lx\n",p,destp));
			for(y=0; y<img->Height; y++)
			{
				for(x=0; x<TotWidth/16; x++)
				{
					*destp++ = *srcp++;
				}
			}
		}

		// create GGFX picture object from bitmap
		if(d->Picture = MakePicture((APTR)bm,img->Width,img->Height,
				GGFX_PixelFormat, PIXFMT_BITMAP_CLUT,
				GGFX_Palette, Palette,
				GGFX_NumColors, ncolors,
				GGFX_PaletteFormat, PALFMT_RGB32,
				TAG_DONE))
			
		{
			InitGuiGfxStuff(d);
			SetSuperAttrs(d->myclass,d->this,MUIA_Guigfx_Picture,d->Picture,TAG_DONE);
			d->DisposePicture = TRUE;
			rc = TRUE;
		} else { DB(KPrintf("SetNewImage(): Can't make picture from bitmap!\n")); }
		FreeBitMap(bm);
	} else { DB(KPrintf("SetNewImage(): Can't allocate %dx%dx%d bitmap!\n",TotWidth,img->Height,img->Depth)); }

	if(FreePalette) FreeVec(Palette);
	return rc;
}

BOOL SetNewFileName(STRPTR name, struct Data *d)
{
	if(!name) return FALSE;

	DisposeBitmapsAndHandle(d);
	FreeGuiGfxStuff(d);
	if(d->Picture = LoadPicture(name,
							GGFX_UseMask, TRUE,
							TAG_DONE))
	{
		InitGuiGfxStuff(d);
		SetSuperAttrs(d->myclass,d->this,MUIA_Guigfx_Picture,d->Picture,TAG_DONE);
		d->DisposePicture = TRUE;
		return TRUE;
	}
	return FALSE;
}


/*
** GetPalette()
** Takes a palette pointer or a special value and fills *Palette with a palette pointer
** Arguments: d      : Object's instance data pointer
**            Type   : pointer to palette table or MUIV_Guigfx_*Palette
**                     if a pointer, this is just be copied to *Palette. Else a new
**                     palette table is allocated and filled according to the value
**            Palette: pointer to a LONG* where the palette pointer should be stored
** Returns:   Free/Don't free palette later
*/
static BOOL GetPalette(struct Data *d, LONG Type, WORD NColors, ULONG **Palette)
{
	switch(Type)
	{
		case MUIV_Guigfx_WBPalette      :
		case MUIV_Guigfx_GreyPalette    :
		case MUIV_Guigfx_CurrentPalette :
			return (BOOL)(*Palette = NewPalette(d,NColors,(WORD)Type));
			break;
		default :
			*Palette = (ULONG*)Type;
			return FALSE;
			break;
	}
}

/*
** NewPalette()
** Allocates a new palette array and fills it
** Arguments: d      : Object's instance data pointer
**            NColors: number of colors for the table
**            Type   : type of palette to create
** Returns  : pointer to new table or NULL on failure
*/
static ULONG *NewPalette(struct Data *d, WORD NColors, WORD Type)
{
ULONG *PaletteArray;
struct Screen *WBScreen;
int i;
ULONG *pal,val;

	if(PaletteArray = AllocVec(NColors * sizeof(ULONG) * 3,MEMF_ANY))
	{
		switch(Type)
		{
		case MUIV_Guigfx_WBPalette :
			if(WBScreen = LockPubScreen("Workbench"))
			{
				GetRGB32(WBScreen->ViewPort.ColorMap,0,NColors,PaletteArray);
				UnlockPubScreen(NULL,WBScreen);
			}
			break;

		/* don't use this when _screen(obj) is invalid! */
		case MUIV_Guigfx_CurrentPalette :	
			GetRGB32(_screen(d->this)->ViewPort.ColorMap,0,NColors,PaletteArray); 
			break;

		case MUIV_Guigfx_GreyPalette :
			for(i=0,pal=PaletteArray; i<NColors; i++)
			{
				val = (255*i/NColors);		// screw rounding errors...
				val = val | val<<8;
				val = val | val<<16;
				*pal++ = val;
				*pal++ = val;
				*pal++ = val;
			}

		default:
			PaletteArray = NULL;
		}
	}
	return PaletteArray;
}

/*
**
**
*/
// static void DoTransparencyEffect(struct Data *d)
// {
// struct RastPort *rp,*tmprp;
// struct BitMap *bm;
// APTR pic;
// ULONG *pal;
// WORD depth;
// 
// 	if(d->PicBackup == NULL)
// 	{
// 		/* create backup for later mixing */
// 		if((d->PicBackup = ClonePictureA(d->Picture,NULL)) == NULL) return;
// 	}
// 
// 	/* allocate a RastPort structure */
// 	if(rp = AllocVec(sizeof(*rp),MEMF_PUBLIC))
// 	{
// 		depth = _rp(d->this)->BitMap->Depth;
// 
// 		/* allocate a BitMap with as many planes as needed */
// 		if(bm = AllocBitMap(d->PicW,d->PicH,depth,0,NULL))
// 		{
// 			rp->BitMap = bm;
// 
// 			/* save object's rastport and set my own */
// 			tmprp = _rp(d->this);
// 			_rp(d->this) = rp;
// 
// 			/* let our object draw its background as configured */
// 			DoMethod(d->this,MUIM_DrawBackground,0,0,d->PicW,d->PicH,0,0,0);
// 
// 			/* restore object's rastport */
// 			_rp(d->this) = tmprp;
// 
// 			if(pal = NewPalette(d,1<<depth,MUIV_Guigfx_CurrentPalette))
// 			{
// 				/* create GGFX picture object from bitmap */
// 				if(pic = MakePicture((APTR)bm,d->PicW,d->PicH,
// 						GGFX_PixelFormat, PIXFMT_BITMAP_CLUT,
// 						GGFX_Palette, pal,
// 						GGFX_NumColors, 1<<depth,
// 						GGFX_PaletteFormat, PALFMT_RGB32,
// 						TAG_DONE))	
// 				{
// 					/* delete previous picture */
// 					DeletePicture(d->Picture);
// 					/* copy backup (shouldn't fail) */
// 					if(d->Picture = ClonePictureA(d->PicBackup,NULL))
// 					{
// 						/* mix picture and background */
// 						DoPictureMethod(d->Picture,PICMTHD_MIX,pic,
// 								GGFX_Ratio, 128,
// 								TAG_DONE);
// 					} else
// 					{
// 						d->Picture = d->PicBackup;
// 						d->PicBackup = NULL;
// 					}
// 					DeletePicture(pic);
// 				}
// 				FreeVec(pal);
// 			}
// 			FreeBitMap(bm);
// 		}
// 		FreeVec(rp);
// 	}
// }

void ObjectSizeChange(struct Data *d)
{
APTR parent;

	get(d->this,MUIA_Parent,&parent);
	if(parent)
	{
		if(DoMethod(parent,MUIM_Group_InitChange) != NULL)
		{
			DoMethod(parent,MUIM_Group_ExitChange);
		}
	}
}
