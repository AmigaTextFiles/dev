#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
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

#include <classes/textitemclass.h>

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
ASM dispatchItem( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) Msg msg );

ULONG
ASM setItemAttrs( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) struct opSet * msg );

ULONG
ASM getItemAttr( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opGet * msg);

Class *cl = 0;

struct localObjData {
	UWORD lod_MinWidth;
	UWORD lod_Left;
	UWORD lod_Top;
};

#define MYCLASSID "textitemclass"
#define SUPERCLASSID "itemclass"

struct Library *ItemBase;

int ASM SAVEDS __UserLibInit( REG(a6) struct MyLibrary *libbase )
{
	if (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 36))
	{
		GfxBase = (struct GfxBase *)OpenLibrary( "graphics.library", 36);
		UtilityBase = OpenLibrary( "utility.library", 36);
		if( ItemBase = OpenLibrary( "item.class", 0 ) )
		{
			if( cl = MakeClass( MYCLASSID,
 		                     SUPERCLASSID, NULL,
   		                   sizeof(struct localObjData), 0))
			{
				/* Fill in the callback hook */
				cl->cl_Dispatcher.h_Entry = (ULONG (*) ())dispatchItem;
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

    /* Try to free the public class */
    if( cl )
    {
	    RemoveClass( cl );
  	  FreeClass(cl);
  	}
  	CloseLibrary( (struct Library *)ItemBase );
    CloseLibrary( (struct Library *)IntuitionBase );
    CloseLibrary( (struct Library *)GfxBase );
    CloseLibrary( UtilityBase );
}

int SAVEDS InitTextItemClass( void )
{
	return( TRUE );
}

void KillTextItemClass( void )
{
}

ULONG ASM dispatchItem( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) Msg msg)
{
	ULONG retval = FALSE;
	Object *newobj;
	struct localObjData *lod;

    /* SAS/C and Manx function to make sure register A4
       contains a pointer to global data */
	putreg( REG_A6, cl->cl_UserData );
	geta4();

	switch (msg->MethodID)
	{
		case OM_NEW:       /* First, pass up to superclass */
			if (newobj = (Object *)DSM(cl, o, msg))
			{
				/* Initial local instance data */
				lod = INST_DATA( cl, newobj );
				lod->lod_Left = 0;
				lod->lod_Top = 0;
				setItemAttrs( cl, newobj, (struct opSet *)msg );
				retval = (ULONG)newobj;
			}
			break;
		case OM_SET:
			retval = DSM( cl, o, msg );
			retval += setItemAttrs( cl, o, (struct opSet *)msg );
			break;
		case OM_GET:
			retval = getItemAttr( cl, o, (struct opGet *)msg );
			break;
		case IM_DIMENSIONS:
			{
				struct DrawInfo *dri = IT(o)->it_Dri ? IT(o)->it_Dri : DIM(msg)->itp_DrInfo;

				lod = INST_DATA( cl, o );
				if( IT(o)->it_Link.ln_Name )
				{
					struct RastPort rp;

					InitRastPort( &rp );
					if( dri && dri->dri_Font )
						SetFont( &rp, dri->dri_Font );
					DIM(msg)->itp_Dimensions->Width = lod->lod_MinWidth = TextLength( &rp, IT(o)->it_Link.ln_Name, strlen( IT(o)->it_Link.ln_Name ) );
					DIM(msg)->itp_Dimensions->Width += lod->lod_Left;
					DIM(msg)->itp_Dimensions->Height = lod->lod_Top + rp.TxHeight + 2;
				}
			}
			break;
		case IM_DRAW:
			{
				struct RastPort *rp = DRA(msg)->itp_RPort;
				struct DrawInfo *dri = IT(o)->it_Dri ? IT(o)->it_Dri : DRA(msg)->itp_DrInfo;
				struct TextExtent te;
				int width;
				int frontpen, backpen;
				WORD destx, desty;

				lod = INST_DATA( cl, o );
				if( IT(o)->it_Link.ln_Name )
				{
					if( dri && dri->dri_Font )
						SetFont( rp, dri->dri_Font );
					SetDrMd( rp, JAM1 );
					if( IT(o)->it_Flags & IAF_SELECTED )
					{
						backpen = dri ? dri->dri_Pens[IHIGHLIGHTBACKPEN] : 3;
						frontpen = dri ? dri->dri_Pens[IHIGHLIGHTTEXTPEN] : 2;
					}
					else
					{
						backpen = dri ? dri->dri_Pens[IBACKPEN] : 0;
						frontpen = dri ? dri->dri_Pens[ITEXTPEN] : 1;
					}
					if( !(IT(o)->it_Flags & IAF_NOBACK) )
					{
						SetAPen( rp, backpen );
						RectFill( rp, DRA(msg)->itp_Offset.X + lod->lod_Left, lod->lod_Top + DRA(msg)->itp_Offset.Y, DRA(msg)->itp_Offset.X + DRA(msg)->itp_Bounds.Width - 1, DRA(msg)->itp_Offset.Y + DRA(msg)->itp_Bounds.Height - 1 );
					}
					SetAPen( rp, frontpen );
					if( (lod->lod_MinWidth - lod->lod_Left) > DRA(msg)->itp_Bounds.Width )
						width = TextFit( rp, IT(o)->it_Link.ln_Name, strlen( IT(o)->it_Link.ln_Name ), &te, NULL, 1, DRA(msg)->itp_Bounds.Width - lod->lod_Left, DRA(msg)->itp_Bounds.Height - lod->lod_Top );
					else
						width = strlen( IT(o)->it_Link.ln_Name );
					if( IT(o)->it_Flags & IAF_JULEFT )
						destx = DRA(msg)->itp_Offset.X + lod->lod_Left;
					if( IT(o)->it_Flags & IAF_JUCENTER )
						destx = DRA(msg)->itp_Offset.X + lod->lod_Left + ((DRA(msg)->itp_Bounds.Width - TextLength( rp, IT(o)->it_Link.ln_Name, width )) / 2);
					if( IT(o)->it_Flags & IAF_JURIGHT )
						destx = DRA(msg)->itp_Offset.X + DRA(msg)->itp_Bounds.Width - TextLength( rp, IT(o)->it_Link.ln_Name, width ) - lod->lod_Left;
					if( IT(o)->it_Flags & IAF_JUTOP )
						desty = DRA(msg)->itp_Offset.Y + lod->lod_Top + rp->TxBaseline;
					if( IT(o)->it_Flags & IAF_JUVCENTER )
						desty = DRA(msg)->itp_Offset.Y + ((DRA(msg)->itp_Bounds.Height - rp->TxHeight) / 2) + rp->TxBaseline;
					if( IT(o)->it_Flags & IAF_JUBOTTOM )
						desty = DRA(msg)->itp_Offset.Y + DRA(msg)->itp_Bounds.Height - rp->TxHeight + rp->TxBaseline - lod->lod_Top;
					Move( rp, destx, desty );
					Text( rp, IT(o)->it_Link.ln_Name, width );
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
ASM setItemAttrs( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) struct opSet * msg )
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
			case IA_Name:
				lod->lod_MinWidth = 0;
				break;
			case ITA_XOffset:
				lod->lod_Left = (UWORD)tidata;
				break;
			case ITA_YOffset:
				lod->lod_Top = (UWORD)tidata;
				break;
		}
	}
	return (1L);
}

ULONG
ASM getItemAttr( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opGet * msg )
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
