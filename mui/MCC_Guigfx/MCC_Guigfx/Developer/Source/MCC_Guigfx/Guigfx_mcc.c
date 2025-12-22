/*
** $Id: Guigfx_mcc.c 1.3 2000/08/18 16:17:34 msbethke Exp msbethke $
**
** $Log: Guigfx_mcc.c $
** Revision 1.3  2000/08/18 16:17:34  msbethke
** Added MUIA_Version/MUIA_Revision
**
** Revision 1.2  2000/03/30 23:01:54  msbethke
** Completed the NewImage->Guigfx renaming
**
** Revision 1.1  2000/03/30 22:36:02  msbethke
** Initial revision
**
*/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

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
#include <proto/cybergraphics.h>
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

#define VERSIONNUM2STR(v,r) # v "." # r
#define VN2S(v,r) VERSIONNUM2STR(v,r)

/* Class definitions */
#define CLASS	MUIC_Guigfx
#define SUPERCLASS	MUIC_Area
#define COPYRIGHT	"1999-2000"
#define AUTHOR	"Matthias Bethke"
#define VERSION	19
#define REVISION	2
#define VERSIONSTR VN2S(VERSION,REVISION)

/* Local protos */
static void SetAttributes(struct IClass*,Object*,struct opSet*,BOOL);

/* Globals */
struct Library *GuiGFXBase;

#include "MCCLib.c"


/*****************************************************************************/
/*****************************************************************************/

static BOOL ClassInitFunc(const struct Library *const base)
{
	if(GuiGFXBase = OpenLibrary("guigfx.library",15))
	{
		return TRUE;
	}
	return FALSE;
}

/*****************************************************************************/

static VOID ClassExitFunc(const struct Library *const base)
{
	CloseLibrary(GuiGFXBase);
}

/*****************************************************************************/
/*****************************************************************************/

static ULONG __inline mNew(struct IClass *cl,Object *obj, struct opSet *msg)
{
struct Data *d;

	if(!(obj = (Object*)DoSuperMethodA(cl,obj,(Msg)msg))) return 0;	// create object

	d = INST_DATA(cl,obj);

	memset(d,0,sizeof(*d));

	d->this = obj;
	d->myclass = cl;
	SetAttributes(cl,obj,msg,TRUE);	// set initial attributes

	if(!(d->Picture))						// fail if picture doesn't exist
	{
		CoerceMethod(cl,obj,OM_DISPOSE);
		return NULL;
	}

	set(obj,MUIA_FillArea,FALSE);
	return (ULONG)obj;
}

/*********************************/

static ULONG __inline mDispose(struct IClass *cl,Object *obj, Msg msg)
{
struct Data *d=INST_DATA(cl,obj);;

	FreeGuiGfxStuff(d);
	return DoSuperMethodA(cl,obj,msg);
}

/******************************************************************************/

static ULONG __inline mSet(struct IClass *cl,Object *obj,struct opSet *msg)
{
	SetAttributes(cl,obj,msg,FALSE);				// in a subroutine to make it
	return DoSuperMethodA(cl,obj,(Msg)msg);	// usable from OM_NEW too
}

/*********************************/

static ULONG __inline mGet(struct IClass *cl,Object *obj,struct opGet *msg)
{
struct Data *d = INST_DATA(cl,obj);

	switch(msg->opg_AttrID)
	{
		case MUIA_Guigfx_Picture :
			*(msg->opg_Storage) = (ULONG)d->Picture;
			return TRUE;
		case MUIA_Guigfx_Quality :
			*(msg->opg_Storage) = (ULONG)d->Quality;
			return TRUE;
		case MUIA_Guigfx_Transparency :
			*(msg->opg_Storage) = (ULONG)d->Transparency;
			return TRUE;
		case MUIA_Guigfx_TransparentColor :
			*(msg->opg_Storage) = (ULONG)d->TransColor;
			return TRUE;
		case MUIA_Guigfx_ScaleMode :
			*(msg->opg_Storage) = (ULONG)d->ScaleMode;
			return TRUE;
		case MUIA_Guigfx_ShowRect :
			*(msg->opg_Storage) = (ULONG)&d->ShowRect;
			return TRUE;

		/* overload MUI attributes */
		case MUIA_Version :
			*(msg->opg_Storage) = VERSION;
			return TRUE;
		case MUIA_Revision :
			*(msg->opg_Storage) = REVISION;
			return TRUE;

		default : return DoSuperMethodA(cl,obj,(Msg)msg);
	}
}

/******************************************************************************/

static ULONG __inline mSetup(struct IClass *cl,Object *obj, Msg msg)
{
struct Data *d=INST_DATA(cl,obj);

	if(!(DoSuperMethodA(cl,obj,msg))) return FALSE;
	CalculateScalingFactors(d);
	return TRUE;
}

/******************************************************************************/

static ULONG __inline mShow(struct IClass *cl,Object *obj, Msg msg)
{
	if(!(DoSuperMethodA(cl,obj,msg))) return FALSE;
	if(GetNewHandle(INST_DATA(cl,obj),obj)) return TRUE;
	return FALSE;
}

/*********************************/

static ULONG __inline mHide(struct IClass *cl,Object *obj, Msg msg)
{
struct Data *d=INST_DATA(cl,obj);

	DisposeBitmapsAndHandle(d);
	return(DoSuperMethodA(cl,obj,msg));
}

/******************************************************************************/

static ULONG __inline mAskMinMax(struct IClass *cl,Object *obj, struct MUIP_AskMinMax *msg)
{
LONG x,y;
struct Data *d=INST_DATA(cl,obj);;

	DoSuperMethodA(cl,obj,(Msg)msg);

	x = d->CorrW;
	y = d->CorrH;

	msg->MinMaxInfo->DefWidth  += x;
	msg->MinMaxInfo->DefHeight += y;

	if(d->ScaleMode & NISMF_SCALEUP)
	{
		msg->MinMaxInfo->MaxWidth  += MUI_MAXMAX;
		msg->MinMaxInfo->MaxHeight += MUI_MAXMAX;
	} else
	{
		msg->MinMaxInfo->MaxWidth  += x;
		msg->MinMaxInfo->MaxHeight += y;
	}

	if(d->ScaleMode & NISMF_SCALEDOWN)
	{
		msg->MinMaxInfo->MinWidth  += 2;
		msg->MinMaxInfo->MinHeight += 2;
	} else
	{
		msg->MinMaxInfo->MinWidth  += x;
		msg->MinMaxInfo->MinHeight += y;
	}
	return 0;
}

/******************************************************************************/

static ULONG __inline mDraw(struct IClass *cl,Object *obj, struct MUIP_Draw *msg)
{
struct Data *d=INST_DATA(cl,obj);

	if((!(d->PicBM)) ||
		(d->PicW != _mwidth(obj)) ||
		(d->PicH != _mheight(obj)))
	{
		if(d->PicBM) DisposeBitmaps(d);

		SetPicSize(d,_mwidth(obj),_mheight(obj));
		RenderBitmaps(d,obj);
	}

	DoSuperMethodA(cl,obj,(Msg)msg);

	if((d->ScaleMode & NISMF_KEEPASPECT) || (d->Transparency && d->BltMask))
	{
		DoMethod(obj,MUIM_DrawBackground,_mleft(obj),_mtop(obj),_mwidth(obj),_mheight(obj),0,0,0);
	}

	if(d->Transparency && d->BltMask)
	{
		BltMaskBitMapRastPort(d->PicBM,0,0,_rp(obj),
								_mleft(obj)+d->PosX, _mtop(obj)+d->PosY,
								d->PicW, d->PicH,
								0x0c0,d->BltMask);	// masked blit
	} else
	{
		BltBitMapRastPort(d->PicBM,0,0,_rp(obj),
								_mleft(obj)+d->PosX, _mtop(obj)+d->PosY,
								d->PicW,d->PicH,
								0x0c0);					// copy bitmap to window
	}
	return 0;
}

/******************************************************************************/

static ULONG SAVEDS_ASM Dispatcher(REG(A0) struct IClass *const cl GCCREG(A0), REG(A2) Object *const obj GCCREG(A2), REG(A1) const Msg msg GCCREG(A1))
{
	switch (msg->MethodID)
	{
		// frequently called methods
		case MUIM_Draw			: return mDraw(cl,obj,(struct MUIP_Draw *)msg);
		case OM_SET				: return mSet(cl,obj,(struct opSet*)msg);
		case OM_GET				: return mGet(cl,obj,(struct opGet*)msg);

		// called occasionally
		case MUIM_Setup		: return mSetup(cl,obj,msg);
		case MUIM_Show			: return mShow(cl,obj,msg);
		case MUIM_Hide			: return mHide(cl,obj,msg);
		case MUIM_AskMinMax	: return mAskMinMax(cl,obj,(struct MUIP_AskMinMax*)msg);

		// called only once
		case OM_NEW				: return mNew(cl,obj,(struct opSet*)msg);
		case OM_DISPOSE		: return mDispose(cl,obj,msg);
		default					: return DoSuperMethodA(cl,obj,msg);
	}
}

/******************************************************************************/

static void SetAttributes(struct IClass *cl,Object *obj,struct opSet *msg, BOOL AtInit)
{
struct TagItem *tags,*tag;
struct Data *d=INST_DATA(cl,obj);
BOOL change=FALSE;

	for(tags=msg->ops_AttrList; tag=NextTagItem(&tags);)
	{
		switch(tag->ti_Tag)
		{
			case MUIA_Guigfx_ShowRect :
				if(tag->ti_Data)
				{
					d->ShowRect.MinX = ((struct Rect32*)(tag->ti_Data))->MinX;
					d->ShowRect.MinY = ((struct Rect32*)(tag->ti_Data))->MinY;
					d->ShowRect.MaxX = ((struct Rect32*)(tag->ti_Data))->MaxX;
					d->ShowRect.MaxY = ((struct Rect32*)(tag->ti_Data))->MaxY;
					DisposeBitmaps(d);
					change = TRUE;
				}
				break;
			case MUIA_Guigfx_Picture :
				if(tag->ti_Data)
				{
					DisposeBitmapsAndHandle(d);
					FreeGuiGfxStuff(d);
					d->Picture = (APTR)(tag->ti_Data);
					d->DisposePicture = FALSE;
					InitGuiGfxStuff(d);
					if(!AtInit)	ObjectSizeChange(d);
					change = TRUE;
				}
				break;

			case MUIA_Guigfx_FileName :
				change = SetNewFileName((STRPTR)(tag->ti_Data),d);
				break;

			case MUIA_Guigfx_BitmapInfo :
				change = SetNewBitmap((struct MUIP_Guigfx_BitMapInfo*)(tag->ti_Data),d);
				break;

			case MUIA_Guigfx_ImageInfo :
				change = SetNewImage((struct MUIP_Guigfx_ImageInfo*)(tag->ti_Data),d);
				break;

			case MUIA_Guigfx_Transparency :
				if(d->Transparency != tag->ti_Data)
				{
					DisposeBitmaps(d);
					d->Transparency = tag->ti_Data;
					change = TRUE;
				}
				break;

			case MUIA_Guigfx_TransparentColor :
				if(d->TransColor != tag->ti_Data)
				{
					DisposeBitmaps(d);
					d->TransColor = tag->ti_Data;
					change = TRUE;
				}
				break;

			case MUIA_Guigfx_Quality :
				if(d->Quality != tag->ti_Data)
				{
					DisposeBitmaps(d);
					SetQuality(d,d->Quality=tag->ti_Data);
					change = TRUE;
				}
				break;

			case MUIA_Guigfx_ScaleMode :
				d->ScaleMode = tag->ti_Data;
				DisposeBitmaps(d);
				change = TRUE;
				break;
		}
	}
	if(change && !AtInit)
	{
		MUI_Redraw(obj,MADF_DRAWOBJECT);
	}
}
