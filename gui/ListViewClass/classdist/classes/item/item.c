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

#define DSM DoSuperMethodA

#define IAF_JUALL (IAF_JULEFT|IAF_JUCENTER|IAF_JURIGHT)
#define IAF_JUVALL (IAF_JUTOP|IAF_JUVCENTER|IAF_JUBOTTOM)
#define IAF_JUMASK 0x0000003f

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
	struct Node lod_Node;
	Object *lod_SubItem;
	ULONG lod_Flags;
	struct DrawInfo *lod_Dri;
	ULONG lod_ID;
	ULONG lod_UserData;
};

#define MYCLASSID "itemclass"
#define SUPERCLASSID "rootclass"

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
			cl->cl_Dispatcher.h_Entry = (ULONG (*) ())dispatchItem;
			cl->cl_UserData = (ULONG)libbase;
			AddClass( cl );
			return( FALSE );
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
	CloseLibrary( (struct Library *)IntuitionBase );
	CloseLibrary( (struct Library *)GfxBase );
	CloseLibrary( UtilityBase );
}

int SAVEDS InitItemClass( void )
{
	return( TRUE );
}

void KillItemClass( void )
{
}

/***********************************************************/
/**********       The RKMBut class dispatcher      *********/
/***********************************************************/
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
				lod->lod_Flags |= IAF_JULEFT;
				lod->lod_Flags |= IAF_JUTOP;
				setItemAttrs( cl, newobj, (struct opSet *)msg );
				retval = (ULONG)newobj;
			}
			break;
		case OM_DISPOSE:
			lod = INST_DATA( cl, o );
			if( lod->lod_SubItem )
				DoMethodA( lod->lod_SubItem, msg );
			DSM( cl, o, msg );
			break;
		case OM_SET:
			retval += setItemAttrs( cl, o, ((struct opSet *)msg) );
			break;
		case OM_GET:
			retval = getItemAttr( cl, o, (struct opGet *)msg );
			break;
		case IM_DIMENSIONS:
			lod = INST_DATA( cl, o );

			DIM(msg)->itp_Dimensions->Width = 0;
			DIM(msg)->itp_Dimensions->Height = 0;
			break;
		case IM_DRAW:
			break;
		case IM_ERASE:
			lod = INST_DATA( cl, o );
			EraseRect( ERA(msg)->itp_RPort, ERA(msg)->itp_Offset.X, ERA(msg)->itp_Offset.Y, ERA(msg)->itp_Offset.X + ERA(msg)->itp_Bounds.Width - 1, ERA(msg)->itp_Offset.Y + ERA(msg)->itp_Bounds.Height - 1 );
			break;

		/* Node related meths */
		case IM_ENQUEUE:
			Enqueue( ENQ(msg)->itp_List, (struct Node *)o );
			break;
		case IM_INSERT:
			Insert( INS(msg)->itp_List, (struct Node *)o, INS(msg)->itp_Pred );
			break;
		case IM_REMOVE:
			Remove( (struct Node *)o );
			break;
		case IM_ADDHEAD:
			AddHead( ADDI(msg)->itp_List, (struct Node *)o );
			break;
		case IM_ADDTAIL:
			AddTail( ADDI(msg)->itp_List, (struct Node *)o );
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
			case IA_SubItem:
				lod->lod_SubItem = (Object *)tidata;
				break;
			case IA_ID:
				lod->lod_ID = tidata;
				break;
			case IA_UserData:
				lod->lod_UserData = tidata;
				break;
			case IA_DrawInfo:
				lod->lod_Dri = (struct DrawInfo *)tidata;
				break;
			case IA_JURight:
				lod->lod_Flags &= ~IAF_JUALL;
				if( tidata )
					lod->lod_Flags |= IAF_JURIGHT;
				break;
			case IA_JUCenter:
				lod->lod_Flags &= ~IAF_JUALL;
				if( tidata )
					lod->lod_Flags |= IAF_JUCENTER;
				break;
			case IA_JULeft:
				lod->lod_Flags &= ~IAF_JUALL;
				if( tidata )
					lod->lod_Flags |= IAF_JULEFT;
				break;
			case IA_JUTop:
				lod->lod_Flags &= ~IAF_JUVALL;
				if( tidata )
					lod->lod_Flags |= IAF_JUTOP;
				break;
			case IA_JUVCenter:
				lod->lod_Flags &= ~IAF_JUVALL;
				if( tidata )
					lod->lod_Flags |= IAF_JUVCENTER;
				break;
			case IA_JUBottom:
				lod->lod_Flags &= ~IAF_JUVALL;
				if( tidata )
					lod->lod_Flags |= IAF_JUBOTTOM;
				break;
			case IA_Selected:
				if( tidata )
					lod->lod_Flags |= IAF_SELECTED;
				else
					lod->lod_Flags &= ~IAF_SELECTED;
				break;
			case IA_Name:
				lod->lod_Node.ln_Name = (char *)tidata;
				break;
			case IA_Pri:
				lod->lod_Node.ln_Pri = (BYTE)tidata;
				break;
			case IA_NoBack:
				if( tidata )
					lod->lod_Flags |= IAF_NOBACK;
				else
					lod->lod_Flags &= ~IAF_NOBACK;
		}
	}
	/* make sure one JU flag is set */
	if( !(lod->lod_Flags & IAF_JUMASK) )
		lod->lod_Flags |= IAF_JULEFT;
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
		case IA_SubItem:
			*msg->opg_Storage = (ULONG)lod->lod_SubItem;
			break;
		case IA_ID:
			*msg->opg_Storage = lod->lod_ID;
			break;
		case IA_UserData:
			*msg->opg_Storage = lod->lod_UserData;
			break;
		case IA_Name:
			*msg->opg_Storage = (ULONG)lod->lod_Node.ln_Name;
			break;
	}
	return (1L);
}
