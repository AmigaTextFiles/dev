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
#include <classes/separatoritemclass.h>

#define DSM DoSuperMethodA

extern int kprintf( const char *str, ... );

#define REG(x) register __## x
#define ASM __asm
#define SAVEDS __saveds

#define GA(o) ((struct Gadget *)(o))

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

#define MYCLASSID "separatoritemclass"
#define SUPERCLASSID "itemclass"

struct localObjData {
	ULONG lod_Type;
};

int ASM SAVEDS __UserLibInit( REG(a6) struct MyLibrary *libbase )
{
	if (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 36))
	{
		GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 36);
		UtilityBase = OpenLibrary("utility.library", 36);
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
	return( TRUE );
}

void ASM SAVEDS __UserLibCleanup( REG(a6) struct MyLibrary *libbase )
{
	if( cl )
	{
		RemoveClass( cl );
		FreeClass(cl);
	}
	CloseLibrary( (struct Library *)IntuitionBase );
	CloseLibrary( (struct Library *)GfxBase );
	CloseLibrary( UtilityBase );
}

int SAVEDS InitSeparatorItemClass( void )
{
	return( TRUE );
}

void KillSeparatorItemClass( void )
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
				lod->lod_Type = SI_DoubleLine;
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
		case IM_DRAW:
			{
				struct DrawInfo *dri = IT(o)->it_Dri ? IT(o)->it_Dri : DRA(msg)->itp_DrInfo;
				struct RastPort *rp = DRA(msg)->itp_RPort;
				int whitepen, blackpen;

				lod = INST_DATA( cl, o );

				blackpen = dri ? dri->dri_Pens[ISHADOWPEN] : 1;
				whitepen = dri ? dri->dri_Pens[ISHINEPEN] : 2;
				switch( lod->lod_Type )
				{
					case SI_DoubleLine:
						SetAPen( rp, blackpen );
						Move( rp, DRA(msg)->itp_Offset.X + 4, DRA(msg)->itp_Offset.Y + (DRA(msg)->itp_Bounds.Height / 2) - 1 );
						Draw( rp, DRA(msg)->itp_Offset.X + DRA(msg)->itp_Bounds.Width - 8, DRA(msg)->itp_Offset.Y + (DRA(msg)->itp_Bounds.Height / 2) - 1 );
						SetAPen( rp, whitepen );
						Move( rp, DRA(msg)->itp_Offset.X + 4, DRA(msg)->itp_Offset.Y + (DRA(msg)->itp_Bounds.Height / 2) );
						Draw( rp, DRA(msg)->itp_Offset.X + DRA(msg)->itp_Bounds.Width - 8, DRA(msg)->itp_Offset.Y + (DRA(msg)->itp_Bounds.Height / 2) );
						break;
				}
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
			case SI_Type:
				lod->lod_Type = tidata;
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
