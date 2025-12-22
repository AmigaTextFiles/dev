#include <intuition/intuition.h>
#include <intuition/cghooks.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <intuition/imageclass.h>
#include <libraries/gadtools.h>
#include <functions.h>
#include "vcx_private.h"

/***************************** private section **************************/

static int create_sub_gadgets( Class *class, Object *object,
	struct DrawInfo *drawinfo, ULONG imagesize )
{
	struct VCX *vcx = INST_DATA( class, object );
	struct Gadget *gadget = (struct Gadget *)object;
	int success = 0;

	if( !drawinfo )
		goto terminate;
	vcx->more_image = NewObject( NULL, "sysiclass",
		SYSIA_Which, ( vcx->freedom == FREEHORIZ ) ? RIGHTIMAGE : DOWNIMAGE,
		SYSIA_DrawInfo, drawinfo,
		SYSIA_Size, imagesize,
		TAG_DONE );
	if( !vcx->more_image )
		goto terminate;
	vcx->more = NewObject( NULL, "buttongclass",
		GA_Image, (ULONG)vcx->more_image,
		GA_ID, MORE_ID,
		( vcx->freedom == FREEHORIZ ) ?
		(
			( ( gadget->Flags & GFLG_RELRIGHT ) || ( gadget->Flags & GFLG_RELWIDTH ) ) ?
				GA_RelRight
			:
				GA_Left
		)
		:
		(
			( gadget->Flags & GFLG_RELRIGHT ) ?
				GA_RelRight
			:
				GA_Left
		),
		( vcx->freedom == FREEHORIZ ) ?
			gadget->LeftEdge + gadget->Width - ((struct Image *)vcx->more_image)->Width
		:
			gadget->LeftEdge,
		( vcx->freedom == FREEVERT ) ?
		(
			( ( gadget->Flags & GFLG_RELBOTTOM ) || ( gadget->Flags & GFLG_RELHEIGHT ) ) ?
				GA_RelBottom
			:
				GA_Top
		)
		:
		(
			( gadget->Flags & GFLG_RELBOTTOM ) ?
				GA_RelBottom
			:
				GA_Top
		),
		( vcx->freedom == FREEVERT ) ?
			gadget->TopEdge + gadget->Height - ((struct Image *)vcx->more_image)->Height
		:
			gadget->TopEdge,
		GA_Previous, (ULONG)gadget,
		ICA_TARGET, (ULONG)object,
		TAG_DONE );
	if( !vcx->more )
		goto terminate;
	vcx->less_image = NewObject( NULL, "sysiclass",
		SYSIA_Which, ( vcx->freedom == FREEHORIZ ) ? LEFTIMAGE : UPIMAGE,
		SYSIA_DrawInfo, drawinfo,
		SYSIA_Size, imagesize,
		TAG_DONE );
	if( !vcx->less_image )
		goto terminate;
	vcx->less = NewObject( NULL, "buttongclass",
		GA_Image, (ULONG)vcx->less_image,
		GA_ID, LESS_ID,
		( vcx->freedom == FREEHORIZ ) ?
		(
			( ( gadget->Flags & GFLG_RELRIGHT ) || ( gadget->Flags & GFLG_RELWIDTH ) ) ?
				GA_RelRight
			:
				GA_Left
		)
		:
		(
			( gadget->Flags & GFLG_RELRIGHT ) ?
				GA_RelRight
			:
				GA_Left
		),
		( vcx->freedom == FREEHORIZ ) ?
			gadget->LeftEdge + gadget->Width -
			((struct Gadget *)vcx->more)->Width -
			((struct Image *)vcx->less_image)->Width
		:
			gadget->LeftEdge,
		( vcx->freedom == FREEVERT ) ?
		(
			( ( gadget->Flags & GFLG_RELBOTTOM ) || ( gadget->Flags & GFLG_RELHEIGHT ) ) ?
				GA_RelBottom
			:
				GA_Top
		)
		:
		(
			( gadget->Flags & GFLG_RELBOTTOM ) ?
				GA_RelBottom
			:
				GA_Top
		),
		( vcx->freedom == FREEVERT ) ?
			gadget->TopEdge + gadget->Height -
			((struct Gadget *)vcx->more)->Height -
			((struct Image *)vcx->less_image)->Height
		:
			gadget->TopEdge,
		GA_Previous, (ULONG)vcx->more,
		ICA_TARGET, (ULONG)object,
		TAG_DONE );
	if( !vcx->less )
		goto terminate;
	vcx->prop = NewObject( NULL, "propgclass",
		PGA_Freedom, vcx->freedom,
		( gadget->Flags & GFLG_RELRIGHT ) ? GA_RelRight : GA_Left,
		gadget->LeftEdge + ( ( vcx->freedom == FREEHORIZ ) ? 1 : 4 ),
		( gadget->Flags & GFLG_RELBOTTOM ) ? GA_RelBottom : GA_Top,
		gadget->TopEdge + ( ( vcx->freedom == FREEHORIZ ) ? 2 : 1 ),
		( vcx->freedom == FREEHORIZ ) ?
		(
			( gadget->Flags & GFLG_RELWIDTH ) ?
				GA_RelWidth
			:
				GA_Width
		)
		:
			GA_Width,
		( vcx->freedom == FREEHORIZ ) ?
			gadget->Width -
			((struct Gadget *)vcx->more)->Width -
			((struct Gadget *)vcx->less)->Width - 4
		:
			((struct Gadget *)vcx->less)->Width - 8,
		( vcx->freedom == FREEVERT ) ?
		(
			( gadget->Flags & GFLG_RELHEIGHT ) ?
				GA_RelHeight
			:
				GA_Height
		)
		:
			GA_Height,
		( vcx->freedom == FREEVERT ) ?
			gadget->Height -
			((struct Gadget *)vcx->more)->Height -
			((struct Gadget *)vcx->less)->Height - 3
		:
			((struct Gadget *)vcx->less)->Height - 4,
		GA_Previous, (ULONG)vcx->less,
		PGA_Total, vcx->total,
		PGA_Top, vcx->top,
		PGA_Visible, vcx->visible,
		PGA_NewLook, 1,
		ICA_TARGET, (ULONG)object,
		TAG_DONE );
	if( !vcx->prop )
		goto terminate;
	success = 1;
terminate:
	return success;
}

static void delete_sub_gadgets( struct VCX *vcx )
{
	if( vcx->prop )
		DisposeObject( vcx->prop );
	if( vcx->less )
		DisposeObject( vcx->less );
	if( vcx->less_image )
		DisposeObject( vcx->less_image );
	if( vcx->more )
		DisposeObject( vcx->more );
	if( vcx->more_image )
		DisposeObject( vcx->more_image );
}

static ULONG newVCX( Class *class, Object *object, struct opSet *ops )
{
	APTR new;
	struct VCX *vcx;
	struct DrawInfo *drawinfo;
	ULONG imagesize;

	if( new = (APTR)DoSuperMethodA( class, object, (Msg)ops ) )
	{
		struct Gadget *gadget = (struct Gadget *)new;
		vcx = INST_DATA( class, new );
		vcx->target = (APTR)GetTagData( ICA_TARGET, 0, ops->ops_AttrList );
		vcx->total = GetTagData( PGA_Total, 2, ops->ops_AttrList );
		vcx->top = GetTagData( PGA_Top, 0, ops->ops_AttrList );
		vcx->visible = GetTagData( PGA_Visible, 0, ops->ops_AttrList );
		vcx->freedom = GetTagData( PGA_Freedom, FREEVERT, ops->ops_AttrList );
		drawinfo = (struct DrawInfo *)GetTagData( SYSIA_DrawInfo, 0, ops->ops_AttrList );
		imagesize = GetTagData( SYSIA_Size, SYSISIZE_MEDRES, ops->ops_AttrList );
		if( create_sub_gadgets( class, new, drawinfo, imagesize ) )
		{
			if( vcx->freedom == FREEHORIZ )
				gadget->Height = ((struct Gadget *)vcx->prop)->Height;
			else
				gadget->Width = ((struct Gadget *)vcx->prop)->Width;
			return (ULONG)new;
		}
		delete_sub_gadgets( vcx );
		DoSuperMethod( class, object, OM_DISPOSE );
	}
	return 0;
}

static ULONG disposeVCX( Class *class, Object *object, Msg msg )
{
	struct VCX *vcx = INST_DATA( class, object );

	delete_sub_gadgets( vcx );
	DoSuperMethodA( class, object, msg );
}

static ULONG setVCX( Class *class, Object *object, struct opSet *ops )
{
	struct VCX *vcx = INST_DATA( class, object );
#ifdef DEBUG
	kprintf( "setVCX : GadgetInfo %08lx, window %08lx, req %08lx\n",
		ops->ops_GInfo, ops->ops_GInfo->gi_Window, ops->ops_GInfo->gi_Requester );
#endif
	DoSuperMethodA( class, object, (Msg)ops );
	vcx->total = GetTagData( PGA_Total, vcx->total, ops->ops_AttrList );
	vcx->top = GetTagData( PGA_Top, vcx->top, ops->ops_AttrList );
	vcx->visible = GetTagData( PGA_Visible, vcx->visible, ops->ops_AttrList );
#ifdef DEBUG
	kprintf( "setVCX : new total %ld top %ld visible %ld\n",
		vcx->total, vcx->top, vcx->visible );
#endif
	return SetGadgetAttrs( (struct Gadget *)vcx->prop,
		ops->ops_GInfo->gi_Window, ops->ops_GInfo->gi_Requester,
		PGA_Total, vcx->total,
		PGA_Top, vcx->top,
		PGA_Visible, vcx->visible,
		TAG_DONE );
}

static void update_target( Class *class, Object *object, struct GadgetInfo *gi, ULONG flags )
{
	struct Gadget *gadget = (struct Gadget *)object;
	struct VCX *vcx = INST_DATA( class, object );
	static struct TagItem attr_list[] = { { GA_ID }, { PGA_Top }, { TAG_DONE } };

	if( vcx->target )
	{
		attr_list[0].ti_Data = gadget->GadgetID;
		attr_list[1].ti_Data = vcx->top;
		DoMethod( vcx->target, OM_UPDATE, attr_list, gi, flags );
	}
}

static ULONG updateVCX( Class *class, Object *object, struct opUpdate *opu )
{
	struct VCX *vcx = INST_DATA( class, object );
	struct TagItem *ti, *tstate = opu->opu_AttrList;

	/* DoSuperMethodA( class, object, (Msg)opu );	we overload this completely */
	while( ti = NextTagItem( &tstate ) )
	{
		switch( ti->ti_Tag )
		{
		case GA_ID:
			switch( ti->ti_Data )
			{
			case LESS_ID:
				if( vcx->top && ( opu->opu_Flags & OPUF_INTERIM ) )
				{
					vcx->top--;
					SetGadgetAttrs( (struct Gadget *)vcx->prop,
						opu->opu_GInfo->gi_Window, opu->opu_GInfo->gi_Requester,
						PGA_Top, vcx->top, TAG_DONE );
				}
				update_target( class, object, opu->opu_GInfo, opu->opu_Flags );
				break;
			case MORE_ID:
				if( ( vcx->top < vcx->total - vcx->visible ) &&
					( opu->opu_Flags & OPUF_INTERIM ) )
				{
					vcx->top++;
					SetGadgetAttrs( (struct Gadget *)vcx->prop,
						opu->opu_GInfo->gi_Window, opu->opu_GInfo->gi_Requester,
						PGA_Top, vcx->top, TAG_DONE );
					update_target( class, object, opu->opu_GInfo, opu->opu_Flags );
				}
				update_target( class, object, opu->opu_GInfo, opu->opu_Flags );
				break;
			}
			break;
		case PGA_Top:
			vcx->top = ti->ti_Data;
			if( !( opu->opu_Flags & OPUF_INTERIM ) )
			{
				SetGadgetAttrs( (struct Gadget *)vcx->prop,
					opu->opu_GInfo->gi_Window, opu->opu_GInfo->gi_Requester,
					PGA_Top, vcx->top, TAG_DONE );
			}
			update_target( class, object, opu->opu_GInfo, opu->opu_Flags );
			break;
		}
	}
	return 1;
}

static ULONG dispatchVCX( Class *class, Object *object, Msg msg )
{
	geta4();
#ifdef DEBUG
	kprintf( "dispatchVCX : MethodID %08lx\n", msg->MethodID );
#endif
	switch( msg->MethodID )
	{
	case OM_NEW:
		return newVCX( class, object, (struct opSet *)msg );
	case OM_SET:
		return setVCX( class, object, (struct opSet *)msg );
	case OM_UPDATE:
		return updateVCX( class, object, (struct opUpdate *)msg );
	case OM_DISPOSE:
		return disposeVCX( class, object, msg );
	case GM_HITTEST:
		return 0;		/* never be hit, never go active, never process input */
	default:
		return DoSuperMethodA( class, object, msg );
	}
}

/***************************** public section **************************/

/*
 *	initVCXClass() and freeVCXClass() do the obvious.
 *	These are the only targets to public reference within this module.
 *	Everything else is private (static) stuff.
 */
Class *initVCXClass( void )
{
	Class *class;

	if( class = MakeClass( NULL, "gadgetclass", NULL, sizeof( struct VCX ), 0 ) )
	{
		SetupHook( &class->cl_Dispatcher, dispatchVCX, NULL );
		class->cl_UserData = 0;
		return class;
	}
	return NULL;
}

int freeVCXClass( Class *class )
{
	if( FreeClass( class ) )
		return 1;
	return 0;
}
