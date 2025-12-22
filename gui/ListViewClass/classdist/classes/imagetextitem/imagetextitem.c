#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/cghooks.h>
#include <intuition/icclass.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <clib/macros.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <string.h>
#include <dos.h>

#include <graphics/gfxmacros.h>

#include <classes/itemclass.h>
#include <classes/textitemclass.h>
#include <classes/imagetextitemclass.h>

#define DSM DoSuperMethodA

extern int kprintf( const char *str, ... );

#define REG(x) register __## x
#define ASM __asm
#define SAVEDS __saveds

#define GA(o) ((struct Gadget *)(o))
#define IM(o) ((struct Image *)(o))

#define TXTGUTTER 4
#define YGUTTER 8
#define XGUTTER 8

ULONG
ASM dispatchClass( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) Msg msg );

ULONG
ASM setClassAttrs( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) struct opSet * msg );

ULONG
ASM getClassAttr( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opGet * msg);

#define SET(o) ((struct opSet *)o)
#define GET(o) ((struct opGet *)o)

Class *cl = 0;

struct localObjData {
	struct Image *lod_Image;
};

#define MYCLASSID "imagetextitemclass"
#define SUPERCLASSID "textitemclass"

struct Library *TextItemBase;

int ASM SAVEDS __UserLibInit( REG(a6) struct MyLibrary *libbase )
{
	if (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 36))
	{
		GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 36);
		UtilityBase = OpenLibrary("utility.library", 36);
		if( TextItemBase = OpenLibrary( "textitem.class", 0 ) )
		{
			if( cl = MakeClass( MYCLASSID,
 	                     SUPERCLASSID, NULL,
   	                   sizeof(struct localObjData), 0))
			{
				/* Fill in the callback hook */
				cl->cl_Dispatcher.h_Entry = (ULONG (*) ())dispatchClass;
				cl->cl_UserData = (ULONG)libbase;
				AddClass( cl );
				return( FALSE );
			}
		}
	}
	return( TRUE );
}

void ASM SAVEDS __UserLibCleanup( REG(a6) struct MyLibrary *libbase )
{
	if( cl )
	{
		RemoveClass( cl );
		FreeClass(cl);
	}
	CloseLibrary( TextItemBase );
	CloseLibrary( (struct Library *)IntuitionBase );
	CloseLibrary( (struct Library *)GfxBase );
	CloseLibrary( UtilityBase );
}

int SAVEDS InitImageTextItemClass( void )
{
	return( TRUE );
}

void KillImageTextItemClass( void )
{
}

ULONG ASM dispatchClass( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) Msg msg)
{
	ULONG retval = FALSE;
	Object *newobj;
	struct localObjData *lod;

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	switch (msg->MethodID)
	{
		case OM_NEW:       /* First, pass up to superclass */
			if (newobj = (Object *)DSM(cl, o, msg))
			{
				/* Initial local instance data */
				lod = INST_DATA( cl, newobj );
				setClassAttrs( cl, newobj, (struct opSet *)msg );
				retval = (ULONG)newobj;
			}
			break;
		case OM_SET:
			retval = DSM( cl, o, msg );
			retval += setClassAttrs( cl, o, SET(msg) );
			break;
		case OM_GET:
			retval = getClassAttr( cl, o, GET(msg) );
			break;
		case IM_DIMENSIONS:
			lod = INST_DATA( cl, o );
			DSM( cl, o, msg );
			if( lod->lod_Image )
			{
				DIM(msg)->itp_Dimensions->Width += IM(lod->lod_Image)->Width + 2;
				DIM(msg)->itp_Dimensions->Height = MAX( DIM(msg)->itp_Dimensions->Height, IM(lod->lod_Image)->Height + 2 );
			}
			break;
		case IM_DRAW:
			{
				struct DrawInfo *dri = IT(o)->it_Dri ? IT(o)->it_Dri : DRA(msg)->itp_DrInfo;
				struct RastPort *rp = DRA(msg)->itp_RPort;
				struct itDim off, dim, imdim;
				int backpen;

				lod = INST_DATA( cl, o );
				off.Width = DRA(msg)->itp_Offset.X;
				off.Height = DRA(msg)->itp_Offset.Y;
				dim.Width = DRA(msg)->itp_Bounds.Width;
				dim.Height = DRA(msg)->itp_Bounds.Height;
				imdim.Height = DRA(msg)->itp_Bounds.Height;
				if( lod->lod_Image )
				{
					int state;

					imdim.Width = IM(lod->lod_Image)->Width;
					SetDrMd( rp, JAM1 );
					backpen = dri ? dri->dri_Pens[IBACKPEN] : 0;
					SetAPen( rp, backpen );
					RectFill( rp, DRA(msg)->itp_Offset.X, DRA(msg)->itp_Offset.Y, DRA(msg)->itp_Offset.X + imdim.Width + 1, DRA(msg)->itp_Offset.Y + imdim.Height - 1 );
					state = (IT(o)->it_Flags & IAF_SELECTED) ? IDS_SELECTED : IDS_NORMAL;
					DoMethod( (Object *)lod->lod_Image, IM_DRAWFRAME, rp, DRA(msg)->itp_Offset, state, dri, imdim );
					off.Width += IM(lod->lod_Image)->Width + 2;
					dim.Width -= IM(lod->lod_Image)->Width + 2;
				}
				DoSuperMethod( cl, o, IM_DRAW, rp, off, dim );
			}
			break;
		default:
			retval = DSM(cl, o, msg);
			break;
	}
	return(retval);
}

ULONG
ASM setClassAttrs( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) struct opSet * msg )
{
	struct localObjData *lod = INST_DATA(cl, o);
	struct TagItem *tags = msg->ops_AttrList;
	struct TagItem *tstate;
	struct TagItem *tag;
	ULONG           tidata;

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	/* process rest */
	tstate = tags;
	while (tag = NextTagItem(&tstate))
	{
		tidata = tag->ti_Data;
		switch (tag->ti_Tag)
		{
			case ITIA_Image:
				lod->lod_Image = (struct Image *)tidata;
				break;
			default:
				break;
		}
	}
	return (1L);
}

ULONG
ASM getClassAttr( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opGet * msg )
{
	struct localObjData *lod = INST_DATA(cl, o);

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	switch (msg->opg_AttrID)
	{
		default:
			return ((ULONG) DSM(cl, o, (Msg)msg));
	}
	return (1L);
}
