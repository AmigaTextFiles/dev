#include <exec/types.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/cghooks.h>
#include <intuition/icclass.h>

#include <graphics/gfxmacros.h>

#include <utility/tagitem.h>
#include <utility/hooks.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>

#include <clib/macros.h>
#include <string.h>
#include <dos.h>
#include <stdlib.h>

#include <classes/itemclass.h>
#include <classes/itemlistclass.h>

#define DSM DoSuperMethodA

#define REG(x) register __## x
#define ASM __asm
#define SAVEDS __saveds

/* Casting macros */
#define GA(o) ((struct Gadget *)o)
#define REN(o) ((struct gpRender *)o)
#define GPI(o) ((struct gpInput *)o)
#define SET(o) ((struct opSet *)o)
#define MEM(o) ((struct opMember *)o)
#define GMEM(o) ((struct gpMember *)o)


extern int kprintf( const char *str, ... );

/* Protos */
ULONG
ASM dispatchpopwin( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) Msg msg );

ULONG
ASM setpopwinAttrs( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) struct opSet * msg );

ULONG
ASM getpopwinAttr( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opGet * msg);


void ASM drawitem( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct gpInput *msg, REG(d0) starty, REG(d1) start, REG(d2) len );

void ASM changeitem( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct gpInput *msg, REG(d0) newsel, REG(a3) struct GadgetInfo *ginfo );

void ASM scrollitem( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct gpInput *msg, REG(d0) newtop, REG(d1) flag );


void ASM NotifyTop( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opSet *msg, REG(d0) ULONG attr, REG(d1) ULONG val, REG(d2) ULONG flags, REG(a3) struct GadgetInfo *ginfo );

Class *cl = 0;

USHORT ghostdata[] =
{
	0x2222, 0x8888
};

#define NS_NONE 0
#define NS_ONE 1
#define NS_ALL 2

/* Flags */
#define ITB_DRAG 0
#define ITB_ON 1 /* when in multiselect if the user shift clicks on an item
							this corresponds to whether the item was selected or not */
#define ITB_SHIFT 2 /* did the user have the shift key down when they first clicked on an item */
#define ITB_NOCARESHIFT 3
#define ITB_DONTHOLD 4
#define ITB_LOCK 5
#define ITB_SMOOTH 6
#define ITB_DELAYEDLOCK 7 /* if the gadget was selected when the program wanted to lock it
										we set this and then actually lock it in GM_GOINACTIVE */

#define ITF_DRAG (1L << ITB_DRAG)
#define ITF_ON (1L << ITB_ON)
#define ITF_SHIFT (1L << ITB_SHIFT)
#define ITF_NOCARESHIFT (1L << ITB_NOCARESHIFT)
#define ITF_DONTHOLD (1L << ITB_DONTHOLD)
#define ITF_LOCK (1L << ITB_LOCK)
#define ITF_SMOOTH (1L << ITB_SMOOTH)
#define ITF_DELAYEDLOCK (1L << ITB_DELAYEDLOCK)

struct localObjData
{
	struct MinList lod_Items; /* our list of items */
	struct Item *lod_SelectedItem; /* pointer to the struct Item that is currently selected */
	WORD lod_ItemHeight; /* current height used to draw the items */
	WORD lod_Selected; /* number of the currently selected item */
	WORD lod_Top; /* number of the top item */
	WORD lod_Visible; /* number of items visible */
	WORD lod_Total; /* total number of items */
	WORD lod_RealHeight; /* this thing doesnt move smoothly and the items arent yet built to
									clip so this is the actual height (ie. itemheight * visible) */
	WORD lod_NumSel; /* number selectable, NS_NONE, NS_ONE, NS_ALL, prolly should be moved to flags */
	WORD lod_Flags; /* holds the various flags */
};

#define MYCLASSID "itemlistgadget"
#define SUPERCLASSID "gadgetclass"

/* library init for sas/c */
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
			cl->cl_Dispatcher.h_Entry = (ULONG (*) ())dispatchpopwin;
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

/* just leave these alone for now */
int SAVEDS InitItemListClass( void )
{
	return( TRUE );
}

void KillItemListClass( void )
{
}

/* The dispatch hook */
ULONG ASM dispatchpopwin( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) Msg msg)
{
	ULONG retval = FALSE;
	Object *newobj;
	struct localObjData *lod;

	/* need to get the global vars back with this */
	putreg( REG_A6, cl->cl_UserData );
	geta4();

	switch (msg->MethodID)
	{
		case OM_NEW:       /* First, pass up to superclass */
			if (newobj = (Object *)DSM(cl, o, msg))
			{
				struct TagItem *tag;

				lod = INST_DATA( cl, newobj );
				NewList( (struct List *)&(lod->lod_Items) );
				/* set defaults */
				if( tag = FindTagItem( ILGA_NumSelectable, ((struct opSet *)msg)->ops_AttrList ) )
					lod->lod_NumSel = tag->ti_Data;
				else
					lod->lod_NumSel = NS_ONE;
				lod->lod_Flags |= ITF_DRAG;
				setpopwinAttrs( cl, newobj, (struct opSet *)msg );
				retval = (ULONG)newobj;
			}
			break;
		case OM_DISPOSE:
			{
				struct Item *it, *it2;

				lod = INST_DATA( cl, o );
				/* auto kill all the items in the list */
				it = (struct Item *)lod->lod_Items.mlh_Head;
				while( it->it_Link.ln_Succ )
				{
					it2 = (struct Item *)it->it_Link.ln_Succ;
					DoMethod( (Object *)it, IM_REMOVE );
					DoMethodA( (Object *)it, msg );
					it = it2;
				}
			}
			DSM( cl, o, msg );
			break;
		case OM_SET:
		case OM_UPDATE:
        	retval = DSM( cl, o, msg );
        	retval += setpopwinAttrs( cl, o, (struct opSet *)msg );
        	break;
		case OM_GET:
			retval = getpopwinAttr( cl, o, (struct opGet *)msg );
			break;
		case OM_ADDMEMBER:
			if( MEM(msg)->opam_Object )
			{
				struct itDim dim;

				lod = INST_DATA( cl, o );

				/* if this is the first item we need to setup the selected item or
					make sure the item is not selected */
				if( !lod->lod_SelectedItem )
				{
					lod->lod_SelectedItem = (struct Item *)((struct opMember *)msg)->opam_Object;
					lod->lod_Selected = lod->lod_Total;
					if( (lod->lod_NumSel != NS_ALL) && !(lod->lod_Flags & ITF_DONTHOLD) )
						lod->lod_SelectedItem->it_Flags |= IAF_SELECTED;
				}
				else
					IT(MEM(msg)->opam_Object)->it_Flags &= ~IAF_SELECTED;
				/* get dimensions and make sure the itemheight is big enough to hold it */
				DoMethod( ((struct opMember *)msg)->opam_Object, IM_DIMENSIONS, &dim, GMEM(msg)->gpm_Dri );
				if( dim.Height > lod->lod_ItemHeight )
					SetGadgetAttrs( (struct Gadget *)o, 0, 0, ILGA_ItemHeight, dim.Height, TAG_DONE );
				DoMethod( ((struct opMember *)msg)->opam_Object, IM_ADDTAIL, &lod->lod_Items );
				lod->lod_Total++;
			}
			break;
		case OM_REMMEMBER:
			if( MEM(msg)->opam_Object )
			{
				lod = INST_DATA( cl, o );

				DoMethod( ((struct opMember *)msg)->opam_Object, IM_REMOVE );
				lod->lod_Total--;
				if( lod->lod_Total == 0 )
				{
					lod->lod_SelectedItem = 0;
					lod->lod_Selected = 0;
				}
			}
			break;

		/* This meth will automatically make the width and height bigger to accomodate this
			new item */
		case IM_ADDMEMBERADJUST:
			if( MEM(msg)->opam_Object )
			{
				struct itDim dim;

				lod = INST_DATA( cl, o );
				if( !lod->lod_SelectedItem )
				{
					lod->lod_SelectedItem = (struct Item *)((struct opMember *)msg)->opam_Object;
					lod->lod_Selected = lod->lod_Total;
					if( (lod->lod_NumSel != NS_ALL) && !(lod->lod_Flags & ITF_DONTHOLD) )
						lod->lod_SelectedItem->it_Flags |= IAF_SELECTED;
				}
				else
					IT(MEM(msg)->opam_Object)->it_Flags &= ~IAF_SELECTED;
				DoMethod( ((struct opMember *)msg)->opam_Object, IM_ADDTAIL, lod );
				lod->lod_Total++;
				DoMethod( ((struct opMember *)msg)->opam_Object, IM_DIMENSIONS, &dim, GMEM(msg)->gpm_Dri );
				if( dim.Height > lod->lod_ItemHeight )
					SetGadgetAttrs( (struct Gadget *)o, 0, 0, ILGA_ItemHeight, dim.Height, TAG_DONE );
				if( dim.Width > GA(o)->Width )
					SetGadgetAttrs( (struct Gadget *)o, 0, 0, GA_Width, dim.Width, TAG_DONE );
				SetGadgetAttrs( (struct Gadget *)o, 0, 0, GA_Height, GA(o)->Height + lod->lod_ItemHeight, TAG_DONE );
      	}
        	break;

		/* uh, this should remove the item and resize the gadget accordingly, i'm not posistive it works though :) */
		case IM_REMMEMBERADJUST:
			if( MEM(msg)->opam_Object )
        	{
				struct itDim dim;

				lod = INST_DATA( cl, o );
				DoMethod( ((struct opMember *)msg)->opam_Object, IM_REMOVE );
				lod->lod_Total--;
				DoMethod( ((struct opMember *)msg)->opam_Object, IM_DIMENSIONS, &dim, GMEM(msg)->gpm_Dri );
				if( dim.Width == GA(o)->Width )
				{
					Object *objectstate, *memberob;
					int width;

					width = 0;
					objectstate = (Object *)lod->lod_Items.mlh_Head;
					while( (memberob = NextObject( &objectstate )) )
					{
						DoMethod( memberob, IM_DIMENSIONS, &dim, GMEM(msg)->gpm_Dri );
						if( width < dim.Width )
							width = dim.Width;
					}
					GA(o)->Width = width;
				}
				if( lod->lod_Total == 0 )
				{
					lod->lod_SelectedItem = 0;
					lod->lod_Selected = 0;
				}
				SetGadgetAttrs( (struct Gadget *)o, 0, 0, GA_Height, GA(o)->Height - lod->lod_ItemHeight, TAG_DONE );
			}
			break;
		case GM_HITTEST:
			lod = INST_DATA(cl, o);

			/* if the gadget is locked we dont wanna become active */
			if( lod->lod_Flags & ITF_LOCK )
				retval = 0;
			else
				retval = GMR_GADGETHIT;
			break;
		case GM_RENDER:
			{
				int temp;

				lod = INST_DATA(cl, o);
				switch( REN(msg)->gpr_Redraw )
				{
					case GREDRAW_REDRAW:
						drawitem( cl, o, (struct gpInput *)msg, GA(o)->TopEdge, lod->lod_Top, lod->lod_Visible );
						/* if its disabled we should ghost */
						if( GA(o)->Flags & GFLG_DISABLED	)
						{
							SetAPen( REN(msg)->gpr_RPort, 1 );
							SetAfPt( REN(msg)->gpr_RPort, ghostdata, 1 );
							RectFill( REN(msg)->gpr_RPort, GA(o)->LeftEdge, GA(o)->TopEdge, GA(o)->LeftEdge + GA(o)->Width - 1, GA(o)->TopEdge + GA(o)->Height - 1 );
						}
						break;
					case GREDRAW_UPDATE:
						break;
					case GREDRAW_TOGGLE:
						break;
				}
			}
			break;
		case GM_GOACTIVE:
			lod = INST_DATA(cl, o);

			/* make sure theres and input event */
			if( ((struct gpInput *)msg)->gpi_IEvent )
			{
				int newsel;
				struct Item *it;

				GA(o)->Flags |= GFLG_SELECTED;
				/* compute the new selected value */
				newsel = ((UWORD)((struct gpInput *)msg)->gpi_Mouse.Y / (UWORD)lod->lod_ItemHeight) + lod->lod_Top;
				if( !(newsel < lod->lod_Total) )
					newsel = lod->lod_Total - 1;

				it = (struct Item *)lod->lod_Items.mlh_Head;
				/* check for NS_ALL and no shift key */
				if( (lod->lod_NumSel == NS_ALL) && !(lod->lod_Flags & ITF_NOCARESHIFT) &&
						!((GPI(msg)->gpi_IEvent->ie_Qualifier & IEQUALIFIER_LSHIFT) ||
						(GPI(msg)->gpi_IEvent->ie_Qualifier & IEQUALIFIER_RSHIFT)) )
				{
					/* clear all old selected items */
					lod->lod_Flags &= ~ITF_SHIFT;
					while( it )
					{
						it->it_Flags &= ~IAF_SELECTED;
						it = (struct Item *)it->it_Link.ln_Succ;
					}
					drawitem( cl, o, (struct gpInput *)msg, GA(o)->TopEdge, lod->lod_Top, lod->lod_Visible );
				}
				else
				{
					int place;

					/* either we're not NS_ALL or there was a shift... */
					lod->lod_Flags |= ITF_SHIFT;
					/* find the new selected item */
					for( place = 0; place < newsel; place++, it = (struct Item *)it->it_Link.ln_Succ );
					/* if it was on it should be turned off and all others on the drag should be turned off instead
						of toggled */
					if( it->it_Flags & IAF_SELECTED )
						lod->lod_Flags &= ~ITF_ON;
					else
						lod->lod_Flags |= ITF_ON;
				}
				/* redraw */
				changeitem( cl, o, (struct gpInput *)msg, newsel, GPI(msg)->gpi_GInfo );
				/* if there is no drag then we can become inactive and return control */
				if( lod->lod_Flags & ITF_DRAG )
					retval = GMR_MEACTIVE;
				else
				{
					retval = GMR_NOREUSE | GMR_VERIFY;
					GPI(msg)->gpi_Termination = lod->lod_Selected;
					GA(o)->Flags &= ~GFLG_SELECTED;
				}
			}
			else
				retval = GMR_NOREUSE;
			break;
		case GM_HANDLEINPUT:
			{
				struct gpInput *gpi = (struct gpInput *)msg;
				struct InputEvent *ie = gpi->gpi_IEvent;

				lod = INST_DATA( cl, o );

				retval = GMR_MEACTIVE;

				if (ie->ie_Class == IECLASS_RAWMOUSE)
				{
					switch (ie->ie_Code)
					{
						/* user let go send out notify and verify for idcmp message */
						case SELECTUP:
							retval = GMR_NOREUSE | GMR_VERIFY;
							GPI(msg)->gpi_Termination = lod->lod_Selected;
							NotifyTop( cl, o, SET(msg), ILGA_Selected, lod->lod_Selected, 0, GPI(msg)->gpi_GInfo );
							break;
						case MENUDOWN:
							retval = GMR_REUSE;
							break;
						default:
							/* compute new selected and redraw */
							if( (gpi->gpi_Mouse.X >= 0) && (gpi->gpi_Mouse.Y >= 0) &&
								(gpi->gpi_Mouse.X < GA(o)->Width) && (gpi->gpi_Mouse.Y < lod->lod_RealHeight) )
							{
								int newsel;
								int starty;

								newsel = ((UWORD)gpi->gpi_Mouse.Y / (UWORD)lod->lod_ItemHeight) + lod->lod_Top;
								if( (newsel != lod->lod_Selected) && (newsel < lod->lod_Total) )
									changeitem( cl, o, (struct gpInput *)msg, newsel, GPI(msg)->gpi_GInfo );
							}
					}
			   }
			   /* for timers we want to scroll the list */
				else if( ie->ie_Class == IECLASS_TIMER )
				{
					if( (gpi->gpi_Mouse.X >= 0) && (gpi->gpi_Mouse.X < GA(o)->Width) &&
						((gpi->gpi_Mouse.Y < 0) || (gpi->gpi_Mouse.Y > lod->lod_RealHeight)) )
					{
						if( gpi->gpi_Mouse.Y < 0 )
						{
							if( (lod->lod_Top - 1) >= 0 )
								scrollitem( cl, o, (struct gpInput *)msg, lod->lod_Top - 1, lod->lod_Top - 1 );
						}
						else
						{
							if( (lod->lod_Top + 1) <= (lod->lod_Total - lod->lod_Visible) )
								scrollitem( cl, o, (struct gpInput *)msg, lod->lod_Top + 1, lod->lod_Top + lod->lod_Visible );
						}
					}
            }
			}
			break;
		case GM_GOINACTIVE:
			{
				lod = INST_DATA(cl, o);

				GA(o)->Flags &= ~GFLG_SELECTED;
				/* if we're not supposed to keep the selected item drawn as selected
					(ie. for a menu item) we need to redraw it as normal */
				if( lod->lod_Flags & ITF_DONTHOLD )
				{
					struct RastPort *rp;

					if( rp = ObtainGIRPort( GPI(msg)->gpi_GInfo ) )
					{
						struct itDim off, dim;

						lod->lod_SelectedItem->it_Flags ^= IAF_SELECTED;
						off.Width = GA(o)->LeftEdge;
						off.Height = GA(o)->TopEdge + ((lod->lod_Selected - lod->lod_Top) * lod->lod_ItemHeight);
						dim.Width = GA(o)->Width;
						dim.Height = lod->lod_ItemHeight;
						DoMethod( (Object *)lod->lod_SelectedItem, IM_DRAW, rp, off, dim, GPI(msg)->gpi_GInfo->gi_DrInfo );
						ReleaseGIRPort( rp );
					}
				}
				/* clear the flags */
				lod->lod_Flags &= ~ITF_SHIFT;
				lod->lod_Flags &= ~ITF_ON;
				GA(o)->Flags &= ~GFLG_SELECTED;
				/* if the program wanted to lock the list while it was active this will then
					take care of locking it and notifying the prog */
				if( lod->lod_Flags & ITF_DELAYEDLOCK )
				{
					lod->lod_Flags |= ITF_LOCK;
					lod->lod_Flags &= ~ITF_DELAYEDLOCK;
					NotifyTop( cl, o, SET(msg), ILGA_Lock, TRUE, 0, GPI(msg)->gpi_GInfo );
				}
				DSM( cl, o, msg );
			}
			break;
		default:
			retval = DSM(cl, o, msg);
			break;
	}
	return(retval);
}

ULONG
ASM setpopwinAttrs( REG(a0) Class * cl, REG(a2) Object * o, REG(a1) struct opSet * msg )
{
	struct localObjData *lod = INST_DATA(cl, o);
	struct TagItem *tags = msg->ops_AttrList;
	struct TagItem *tstate;
	struct TagItem *tag;
	ULONG           tidata, titemp;
	struct RastPort *rp;

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	/* the prog changed the width or pos so we should redraw if we can */
	if( FindTagItem(GA_Width,  ((struct opSet *)msg)->ops_AttrList) ||
			FindTagItem(GA_Top,    ((struct opSet *)msg)->ops_AttrList) ||
			FindTagItem(GA_Left,   ((struct opSet *)msg)->ops_AttrList) )
	{
		if( rp = ObtainGIRPort( msg->ops_GInfo ) )
		{
			DoMethod( o, GM_RENDER, msg->ops_GInfo, rp, GREDRAW_REDRAW );
			ReleaseGIRPort( rp );
		}
	}

	tstate = tags;
	while (tag = NextTagItem(&tstate))
	{
		tidata = tag->ti_Data;
		switch (tag->ti_Tag)
		{
			/* all the bloody flags should be done with PackBoolTags() but... */
			case ILGA_NoCareShift:
				if( tidata )
					lod->lod_Flags |= ITF_NOCARESHIFT;
				else
					lod->lod_Flags &= ~ITF_NOCARESHIFT;
				break;
			case ILGA_Top:
				if( (lod->lod_Top != tidata) && (tidata <= (lod->lod_Total - lod->lod_Visible)) )
				{
					if( (msg->MethodID != OM_NEW) )
					{
						struct gpInput gpmsg;

						gpmsg.MethodID = GM_HANDLEINPUT;
						gpmsg.gpi_GInfo = msg->ops_GInfo;
						scrollitem( cl, o, &gpmsg, tidata, -1 );
					}
				}
				break;
			case ILGA_ItemHeight:
				lod->lod_ItemHeight = tidata;
			case GA_Height:
				if( lod->lod_ItemHeight )
					lod->lod_Visible = GA(o)->Height / lod->lod_ItemHeight;
				else
					lod->lod_Visible = 0;
				lod->lod_RealHeight = lod->lod_Visible * lod->lod_ItemHeight;
				if( (msg->MethodID != OM_NEW) && (rp = ObtainGIRPort( msg->ops_GInfo )) )
				{
					DoMethod( o, GM_RENDER, msg->ops_GInfo, rp, GREDRAW_REDRAW );
					ReleaseGIRPort( rp );
				}
				if( msg->MethodID != OM_NEW )
					NotifyTop( cl, o, msg, ILGA_Visible, lod->lod_Visible, 0, msg->ops_GInfo );
				break;
			case ILGA_DontHold:
				if( tidata )
					lod->lod_Flags |= ITF_DONTHOLD;
				else
					lod->lod_Flags &= ~ITF_DONTHOLD;
				break;
			case ILGA_Lock:
				/* I'm not absolutely positive the delayed lock is needed but... */
				if( tidata )
				{
					Forbid();
					/* want atomic for check */
					if( GA(o)->Flags & GFLG_SELECTED )
					{
						lod->lod_Flags |= ITF_DELAYEDLOCK;
						Permit();
					}
					else
					{
						lod->lod_Flags |= ITF_LOCK;
						Permit();
						NotifyTop( cl, o, msg, ILGA_Visible, lod->lod_Visible, 0, msg->ops_GInfo );
					}
				}
				else
					lod->lod_Flags &= ~(ITF_LOCK|ITF_DELAYEDLOCK);
				break;
			case ILGA_Selected:
				{
					if( (msg->MethodID != OM_NEW) )
					{
						if( msg->ops_GInfo )
							changeitem( cl, o, msg, tidata, msg->ops_GInfo );
						else
						{
							struct Item *it;
							int place;

							if( tidata < lod->lod_Total )
								lod->lod_Selected = tidata;
							else
								lod->lod_Selected = lod->lod_Total - 1;
							it = (struct Item *)lod->lod_Items.mlh_Head;
							for( place = 0; place < lod->lod_Selected; place++, it = (struct Item *)it->it_Link.ln_Succ );
							lod->lod_SelectedItem = it;
							it->it_Flags |= IAF_SELECTED;
						}
					}
				}
				break;
			case ILGA_Total:
				if( msg->MethodID != OM_NEW )
					NotifyTop( cl, o, msg, ILGA_Total, lod->lod_Total, 0, msg->ops_GInfo );
				break;
			case ILGA_Drag:
				if( tidata )
					lod->lod_Flags |= ITF_DRAG;
				else
					lod->lod_Flags &= ~ITF_DRAG;
				break;
		}
	}
	return (1L);
}

ULONG
ASM getpopwinAttr( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opGet * msg )
{
	struct localObjData *lod = INST_DATA(cl, o);

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	switch (msg->opg_AttrID)
	{
		case ILGA_Top:
			*msg->opg_Storage = (ULONG) lod->lod_Top;
			break;
		case ILGA_ItemHeight:
			*msg->opg_Storage = (ULONG) lod->lod_ItemHeight;
			break;
		case ILGA_Visible:
			*msg->opg_Storage = (ULONG) lod->lod_Visible;
			break;
		case ILGA_Total:
			*msg->opg_Storage = (ULONG) lod->lod_Total;
			break;
		case ILGA_Selected:
			*msg->opg_Storage = (ULONG) lod->lod_Selected;
			break;
		case ILGA_SelectedItem:
			*msg->opg_Storage = (ULONG) lod->lod_SelectedItem;
			break;
		case ILGA_FirstItem:
			*msg->opg_Storage = (ULONG) lod->lod_Items.mlh_Head;
			break;
		/* Let the superclass try */
		default:
			return ((ULONG) DSM(cl, o, (Msg)msg));
	}
	return (1L);
}


void ASM NotifyTop( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct opSet *msg, REG(d0) ULONG attr, REG(d1) ULONG val, REG(d2) ULONG flags, REG(a3) struct GadgetInfo *ginfo )
{
	struct TagItem tt[3];
	struct localObjData *lod = INST_DATA(cl, o);

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	tt[0].ti_Tag = attr;
	tt[0].ti_Data = val;

	tt[1].ti_Tag = GA_ID;
	tt[1].ti_Data = GA(o)->GadgetID;

	tt[2].ti_Tag = TAG_DONE;

	DoSuperMethod( cl, o, OM_NOTIFY, tt, ginfo, flags );
}

/* this will draw the all the items from start to start + len starting from the y pos in starty */
void ASM drawitem( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct gpInput *msg, REG(d0) starty, REG(d1) start, REG(d2) len )
{
	struct Item *it;
	int place;
	struct itDim off, dim;
	struct RastPort *rp;
	struct localObjData *lod = INST_DATA(cl, o);

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	if( msg->MethodID == GM_RENDER )
		rp = REN(msg)->gpr_RPort;
	else
		rp = ObtainGIRPort( msg->gpi_GInfo );
	/* Make sure we're not locked */
	if( rp && !(lod->lod_Flags & ITF_LOCK) )
	{
		/* really off.X */
		off.Width = GA(o)->LeftEdge;
		off.Height = starty;
		dim.Width = GA(o)->Width;
		dim.Height = lod->lod_ItemHeight;
		it = (struct Item *)lod->lod_Items.mlh_Head;
		for( place = 0; place < start; place++, it = (struct Item *)it->it_Link.ln_Succ );
		for( place = 0; (place < len) && it->it_Link.ln_Succ; place++, it = (struct Item *)it->it_Link.ln_Succ, off.Height += dim.Height )
			DoMethod( (Object *)it, IM_DRAW, rp, off, dim, GPI(msg)->gpi_GInfo->gi_DrInfo );
	}
	if( msg->MethodID != GM_RENDER )
		ReleaseGIRPort( rp );
}

/* takes care of scrolling the items based on the new top */
/* flag - if flag is -1 then scrollitem will just call drawitem
   and have it draw the items.  But, if its set to something else
   it will assume it is the the new selected item and call changeitem */
void ASM scrollitem( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct gpInput *msg, REG(d0) newtop, REG(d1) flag )
{
	struct localObjData *lod = INST_DATA(cl, o);
	WORD start, len, diff, offset, starty;
	struct RastPort *rp;

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	if( !(lod->lod_Flags & ITF_LOCK) )
	{
		diff = newtop - lod->lod_Top;
		offset = diff * lod->lod_ItemHeight;
		if( msg->MethodID == GM_RENDER )
			rp = REN(msg)->gpr_RPort;
		else
			rp = ObtainGIRPort( msg->gpi_GInfo );
		if( offset && rp )
			ScrollRaster( rp, 0, offset, GA(o)->LeftEdge, GA(o)->TopEdge, GA(o)->LeftEdge + GA(o)->Width - 1, GA(o)->TopEdge + lod->lod_RealHeight - 1 );
		if( msg->MethodID != GM_RENDER )
			ReleaseGIRPort( rp );
		starty = GA(o)->TopEdge;
		start = newtop;
		if( (diff > 0) && (diff < lod->lod_Visible) )
		{
			starty += (lod->lod_ItemHeight * (lod->lod_Visible - diff));
			start = newtop + lod->lod_Visible - diff;
		}
		len = MIN( abs(diff), lod->lod_Visible );
		lod->lod_Top = newtop;
		if( flag == -1 )
			drawitem( cl, o, msg, starty, start, len );
		else
			changeitem( cl, o, msg, flag, msg->gpi_GInfo );
		NotifyTop( cl, o, SET(msg), ILGA_Top, lod->lod_Top, 0, msg->gpi_GInfo );
	}
}

/* used to draw the new selected item and clear the old if its NS_ONE */
void ASM changeitem( REG(a0) Class *cl, REG(a2) Object *o, REG(a1) struct gpInput *msg, REG(d0) newsel, REG(a3) struct GadgetInfo *ginfo )
{
	struct Item *it;
	int place;
	struct itDim off, dim;
	struct RastPort *rp;
	struct localObjData *lod = INST_DATA(cl, o);

	putreg( REG_A6, cl->cl_UserData );
	geta4();

	if( msg->MethodID == GM_RENDER )
		rp = REN(msg)->gpr_RPort;
	else
		rp = ObtainGIRPort( ginfo );
	if( rp && !(lod->lod_Flags & ITF_LOCK) )
	{
		switch( lod->lod_NumSel )
		{
			case NS_NONE:
				break;
			case NS_ONE:
				lod->lod_SelectedItem->it_Flags &= ~IAF_SELECTED;
				/* if the old selected item is visible we need to redraw it */
				if( (lod->lod_Selected >= lod->lod_Top) && (lod->lod_Selected < (lod->lod_Top + lod->lod_Visible)) )
				{
					off.Width = GA(o)->LeftEdge;
					off.Height = GA(o)->TopEdge + ((lod->lod_Selected - lod->lod_Top) * lod->lod_ItemHeight);
					dim.Width = GA(o)->Width;
					dim.Height = lod->lod_ItemHeight;
					DoMethod( (Object *)lod->lod_SelectedItem, IM_DRAW, rp, off, dim, GPI(msg)->gpi_GInfo->gi_DrInfo );
				}
			case NS_ALL:
				/* set the new selected item and find it in the list */
				lod->lod_Selected = newsel;
				it = (struct Item *)lod->lod_Items.mlh_Head;
				for( place = 0; place < newsel; place++, it = (struct Item *)it->it_Link.ln_Succ );
				lod->lod_SelectedItem = it;
				/* this part sucks and needs to be changed */
				if( lod->lod_Flags & ITF_NOCARESHIFT )
					it->it_Flags ^= IAF_SELECTED;
				else
				{
					if( lod->lod_NumSel == NS_ALL )
					{
						if( lod->lod_Flags & ITF_SHIFT )
						{
							if( lod->lod_Flags & ITF_ON )
								it->it_Flags |= IAF_SELECTED;
							else
								it->it_Flags &= ~IAF_SELECTED;
						}
						else
							it->it_Flags |= IAF_SELECTED;
					}
					else
						it->it_Flags ^= IAF_SELECTED;
				}
				/* redraw the new selected if its visible */
				if( (lod->lod_Selected >= lod->lod_Top) && (lod->lod_Selected < (lod->lod_Top + lod->lod_Visible)) )
				{
					off.Width = GA(o)->LeftEdge;
					off.Height = GA(o)->TopEdge + ((lod->lod_Selected - lod->lod_Top) * lod->lod_ItemHeight);
					dim.Width = GA(o)->Width;
					dim.Height = lod->lod_ItemHeight;
					DoMethod( (Object *)it, IM_DRAW, rp, off, dim, ginfo );
				}
				/* notify about the newsel */
				NotifyTop( cl, o, SET(msg), ILGA_Selected, lod->lod_Selected, 0, ginfo );
				break;
		}
	}
	if( msg->MethodID != GM_RENDER )
		ReleaseGIRPort( rp );
}
