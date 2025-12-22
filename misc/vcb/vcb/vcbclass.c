#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/cghooks.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <intuition/imageclass.h>
#include <libraries/gadtools.h>
#include <functions.h>
#include <stdlib.h>
#include "vcx.h"
#include "vcb_private.h"

/***************************** private section ***************************/

static int max( int a, int b )
{
	return ( a > b ) ? a : b;
}

static int min( int a, int b )
{
	return ( a < b ) ? a : b;
}

/*
 *	(re-)calculate horiz/vert.real.offset and horiz/vert.real/virtual.size.
 *	According to these new values, modify horizontal and vertical scroller (if there).
 *	This becomes necessary if the host window has changed its dimensions.
 */
static void dimension_vcb( Class *class, Object *object, struct GadgetInfo *gi )
{
	struct Gadget *gadget = (struct Gadget *)object;
	struct VCB *vcb = INST_DATA( class, object );

	vcb->horiz.real.offset = gadget->LeftEdge;
	if( gadget->Flags & GFLG_RELRIGHT )
		vcb->horiz.real.offset += gi->gi_Domain.Width - 1;

	vcb->horiz.real.size = gadget->Width;
	if( gadget->Flags & GFLG_RELWIDTH )
		vcb->horiz.real.size += gi->gi_Domain.Width - 1;

	vcb->vert.real.offset = gadget->TopEdge;
	if( gadget->Flags & GFLG_RELBOTTOM )
		vcb->vert.real.offset += gi->gi_Domain.Height - 1;

	vcb->vert.real.size = gadget->Height;
	if( gadget->Flags & GFLG_RELHEIGHT )
		vcb->vert.real.size += gi->gi_Domain.Height - 1;

	if( vcb->flags & VCBF_HSCROLLER )
		vcb->horiz.real.size -= vcb->size_width;
	vcb->horiz.virtual.size =
		min( vcb->horiz.total, vcb->horiz.real.size / vcb->horiz.unit );

	if( vcb->horiz.virtual.offset > vcb->horiz.total - vcb->horiz.virtual.size )
		vcb->horiz.virtual.offset = max( 0, vcb->horiz.total - vcb->horiz.virtual.size );

	if( vcb->flags & VCBF_VSCROLLER )
		vcb->vert.real.size -= vcb->size_height;
	vcb->vert.virtual.size =
		min( vcb->vert.total, vcb->vert.real.size / vcb->vert.unit );

	if( vcb->vert.virtual.offset > vcb->vert.total - vcb->vert.virtual.size )
		vcb->vert.virtual.offset = max( 0, vcb->vert.total - vcb->vert.virtual.size );

#ifdef DEBUG
	kprintf( "dimension_vcb : GadgetInfo %08lx window %08lx requester %08lx\n",
		gi, gi->gi_Window, gi->gi_Requester );
#endif
	if( vcb->horiz.scroller )
		SetGadgetAttrs( vcb->horiz.scroller,
			gi->gi_Window, gi->gi_Requester,
			PGA_Total, vcb->horiz.total,
			PGA_Visible, vcb->horiz.virtual.size,
			PGA_Top, vcb->horiz.virtual.offset,
			TAG_DONE );

#ifdef DEBUG
	kprintf( "dimension_vcb : vert.total %ld .visible %ld .top %ld\n",
		vcb->vert.total, vcb->vert.virtual.size, vcb->vert.virtual.offset );
#endif
	if( vcb->vert.scroller )
		SetGadgetAttrs( vcb->vert.scroller,
			gi->gi_Window, gi->gi_Requester,
			PGA_Total, vcb->vert.total,
			PGA_Visible, vcb->vert.virtual.size,
			PGA_Top, vcb->vert.virtual.offset,
			TAG_DONE );
#ifdef DEBUG
	kprintf( "dimension_vcb : complete\n" );
#endif
}

static void scroll_vcb( struct RastPort *rp, struct VCB *vcb, int dx, int dy )
{
	ScrollRaster( rp, vcb->horiz.unit * dx, vcb->vert.unit * dy,
		vcb->horiz.real.offset, vcb->vert.real.offset,
		vcb->horiz.real.offset + vcb->horiz.unit * vcb->horiz.virtual.size - 1,
		vcb->vert.real.offset + vcb->vert.unit * vcb->vert.virtual.size - 1 );
}

static struct TagItem VCBBoolTags[] =
{
	{ VCBGA_Interim, VCBF_INTERIM },
	{ VCBGA_HScroller, VCBF_HSCROLLER },
	{ VCBGA_VScroller, VCBF_VSCROLLER },
	{ VCBGA_HBorder, VCBF_HBORDER },
	{ VCBGA_VBorder, VCBF_VBORDER },
	{ TAG_DONE }
};

static ULONG newVCB( Class *class, Object *object, struct opSet *ops )
{
	struct VCBperClassData *vpcd = (struct VCBperClassData *)class->cl_UserData;
	APTR new, size_image;
	struct VCB *vcb;
	struct DrawInfo *drawinfo;
	int imagesize;

	if( new = (APTR)DoSuperMethodA( class, object, (Msg)ops ) )
	{
		struct Gadget *gadget = (struct Gadget *)new, *previous;

		vcb = INST_DATA( class, new );
		InitSemaphore( &vcb->semaphore );
		vcb->exposure = (struct Hook *)GetTagData( VCBGA_ExposureHook, 0, ops->ops_AttrList );
		vcb->flags = GetTagData( VCBGA_Flags, 0, ops->ops_AttrList );
		vcb->flags = PackBoolTags( vcb->flags, ops->ops_AttrList, VCBBoolTags );

		/* we (and VCX) need these to create system imagery */
		drawinfo = (struct DrawInfo *)GetTagData( SYSIA_DrawInfo, 0, ops->ops_AttrList );
		imagesize = GetTagData( SYSIA_Size, SYSISIZE_MEDRES, ops->ops_AttrList );

		if( !drawinfo )
			goto failure;

		/* gives new meaning to SIZEIMAGE as it is used here to dimension our geometry :-) */
		size_image = NewObject( NULL, "sysiclass",
								SYSIA_Which, SIZEIMAGE,
								SYSIA_DrawInfo, drawinfo,
								SYSIA_Size, imagesize,
								TAG_DONE );
		if( !size_image )
			goto failure;
		vcb->size_width = ((struct Image *)size_image)->Width;
		vcb->size_height = ((struct Image *)size_image)->Height;
		DisposeObject( size_image );

		vcb->horiz.total = GetTagData( VCBGA_HTotal, 1, ops->ops_AttrList );
		vcb->horiz.unit = GetTagData( VCBGA_HUnit, 1, ops->ops_AttrList );
		vcb->horiz.virtual.offset = GetTagData( VCBGA_HOffset, 0, ops->ops_AttrList );
		vcb->horiz.scroller = NULL;
		vcb->vert.total = GetTagData( VCBGA_VTotal, 1, ops->ops_AttrList );
		vcb->vert.unit = GetTagData( VCBGA_VUnit, 1, ops->ops_AttrList );
		vcb->vert.virtual.offset = GetTagData( VCBGA_VOffset, 0, ops->ops_AttrList );
		vcb->vert.scroller = NULL;

		if( !vcb->horiz.unit || !vcb->vert.unit )
			goto failure;

		dimension_vcb( class, new, ops->ops_GInfo );

		previous = gadget;
		if( vcb->flags & VCBF_HSCROLLER )
		{
			vcb->horiz.scroller = NewObject( vpcd->VCXClass, NULL,
				GA_ID, HORIZ_ID,
				( gadget->Flags & GFLG_RELRIGHT ) ? GA_RelRight : GA_Left, gadget->LeftEdge,
				( ( gadget->Flags & GFLG_RELBOTTOM ) || ( gadget->Flags & GFLG_RELHEIGHT ) ) ?
					GA_RelBottom : GA_Top,
				gadget->TopEdge + gadget->Height - vcb->size_height,
				( gadget->Flags & GFLG_RELWIDTH ) ? GA_RelWidth : GA_Width,
				gadget->Width - vcb->size_width,
				PGA_Freedom, FREEHORIZ,
				ICA_TARGET, new,
				PGA_Total, vcb->horiz.total,
				PGA_Top, vcb->horiz.virtual.offset,
				PGA_Visible, vcb->horiz.virtual.size,
				SYSIA_DrawInfo, drawinfo,
				SYSIA_Size, imagesize,
				GA_Previous, previous,
				GA_BottomBorder, ( vcb->flags & VCBF_HBORDER ),
				TAG_DONE );
			if( !vcb->horiz.scroller )
				goto failure;
			previous = (struct Gadget *)vcb->horiz.scroller;
		}
		else
			vcb->horiz.scroller = NULL;
		if( vcb->flags & VCBF_VSCROLLER )
		{
			vcb->vert.scroller = NewObject( vpcd->VCXClass, NULL,
				GA_ID, VERT_ID,
				( ( gadget->Flags & GFLG_RELRIGHT ) || ( gadget->Flags & GFLG_RELWIDTH ) ) ?
					GA_RelRight : GA_Left,
				gadget->LeftEdge + gadget->Width - vcb->size_width,
				( gadget->Flags & GFLG_RELBOTTOM ) ? GA_RelBottom : GA_Top, gadget->TopEdge,
				( gadget->Flags & GFLG_RELHEIGHT ) ? GA_RelHeight : GA_Height,
				gadget->Height - vcb->size_height,
				PGA_Freedom, FREEVERT,
				PGA_Total, vcb->vert.total,
				PGA_Top, vcb->vert.virtual.offset,
				PGA_Visible, vcb->vert.virtual.size,
				ICA_TARGET, new,
				SYSIA_DrawInfo, drawinfo,
				SYSIA_Size, imagesize,
				GA_Previous, previous,
				GA_RightBorder, ( vcb->flags & VCBF_VBORDER ),
				TAG_DONE );
			if( !vcb->vert.scroller )
				goto failure;
		}
		else
			vcb->vert.scroller = NULL;
	}
	return (ULONG)new;
failure:
	if( vcb->vert.scroller )
		DisposeObject( vcb->vert.scroller );
	if( vcb->horiz.scroller )
		DisposeObject( vcb->horiz.scroller );
	DoSuperMethod( class, new, OM_DISPOSE );
	return 0;
}

/*
 *	This one does the callback to the hook function which handles the
 *	actual rendition within the virtual coordinate box.
 *
 *	It performs a non-locking arbitration for the right to call the hook.
 *	By obtaining the semaphore the client can savely modify the background data
 *	on which the hook function's work is based (client should run a RefreshGList()
 *	afterwards to get the display updated).
 *
 *	The hook function is passed the object handle. It uses it to retrieve
 *	each necessary geometrical information through GetAttr().
 *
 *	The command ID `VCBCMD_Render´ is only there for compliance with system-wide standards.
 *	The callback function is not supposed to do anything besides rendering.
 *	Arguments l, t, w, h are the left and top coordinates, width and height of the
 *	rectangle that was exposed and has to be re-rendered. These are NOT pixels but
 *	virtual coordinate units. You get pixel coordinates by taking these times horiz.unit
 *	or vert.unit, respectively. The coordinates are relative to the visible box rather
 *	than absolute within the virtual coordinate plane ( 0,0 means the top/left corner of
 *	the box).
 */
static void fix_exposure( Class *class, Object *object, struct RastPort *rp,
	int l, int t, int w, int h )
{
	struct VCB *vcb = INST_DATA( class, object );

	if( vcb->exposure && ( w > 0 ) && ( h > 0 ) )
		if( AttemptSemaphore( &vcb->semaphore ) )
		{
			CallHook( vcb->exposure, object, VCBCMD_RENDER, rp, l, t, w, h );
			ReleaseSemaphore( &vcb->semaphore );
		}
}

static void display( Class *class, Object *object,
	struct RastPort *rp, struct GadgetInfo *gi )
{
	struct VCB *vcb = INST_DATA( class, object );

	/* calculate dimensions */
	dimension_vcb( class, object, gi );

	SetAPen( rp, 0 );
	SetBPen( rp, 0 );
	SetDrMd( rp, JAM2 );
	RectFill( rp,
		vcb->horiz.real.offset,
		vcb->vert.real.offset,
		vcb->horiz.real.offset + vcb->horiz.real.size - 1,
		vcb->vert.real.offset + vcb->vert.real.size - 1 );

	fix_exposure( class, object, rp,
		0, 0, vcb->horiz.virtual.size, vcb->vert.virtual.size );
}

static ULONG renderVCB( Class *class, Object *object, struct gpRender *gpr )
{
	display( class, object, gpr->gpr_RPort, gpr->gpr_GInfo );
	return 1;
}

/* return 1 if at least one offset did truly change */
static int shift_vcb( Class *class, Object *object, int new_hoff, int new_voff,
	struct GadgetInfo *gi, ULONG flags )
{
	struct VCB *vcb = INST_DATA( class, object );
	struct RastPort *rp;
	int ignore, dx, dy, recycle = 0;

	/* if display is locked, do nothing */
	if( !AttemptSemaphore( &vcb->semaphore ) ) return 0;

	rp = ObtainGIRPort( gi );
	if( new_hoff > vcb->horiz.total - vcb->horiz.virtual.size )
		new_hoff = vcb->horiz.total - vcb->horiz.virtual.size;

	if( new_voff > vcb->vert.total - vcb->vert.virtual.size )
		new_voff = vcb->vert.total - vcb->vert.virtual.size;

	/* if the VCBF_INTERIM flag is not set, ignore interim updates */
	ignore = ( !( vcb->flags & VCBF_INTERIM ) && ( flags & OPUF_INTERIM ) );

	dx = new_hoff - vcb->horiz.virtual.offset;
	dy = new_voff - vcb->vert.virtual.offset;

	if( rp && !ignore )
	{
		/* this flags indicates if the shift leaves some old imagery visible */
		recycle = ( abs( dx ) < vcb->horiz.virtual.size ) &&
					( abs( dy ) < vcb->vert.virtual.size );

		/* scroll_vcb() only if sensible to do so */
		if( ( dx || dy ) && recycle )
			scroll_vcb( rp, vcb, dx, dy );
	}
	if( !ignore )
	{
		vcb->horiz.virtual.offset = new_hoff;
		vcb->vert.virtual.offset = new_voff;
	}
	if( rp && !ignore )
	{
		/* now fix the newly exposed areas (max. 2 rectangles) */
		if( !recycle )		/* nothing recyclable, complete re-draw */
			fix_exposure( class, object, rp,
				0, 0, vcb->horiz.virtual.size, vcb->vert.virtual.size );
		else if( dx >= 0 ) /* area exposed by horizontal shift (if any) is at right border */
		{
			if( dx )
				fix_exposure( class, object, rp,
					vcb->horiz.virtual.size - dx, 0, dx, vcb->vert.virtual.size );
			if( dy > 0 ) /* exposed area at the bottom border */
				fix_exposure( class, object, rp,
					0, vcb->vert.virtual.size - dy, vcb->horiz.virtual.size - dx, dy );
			else if( dy < 0 ) /* exposed area at the top border */
				fix_exposure( class, object, rp,
					0, 0, vcb->horiz.virtual.size - dx, -dy );
		}
		else if( dx < 0 ) /* exposed area at the left border */
		{
			fix_exposure( class, object, rp, 0, 0, -dx, vcb->vert.virtual.size );
			if( dy > 0 ) /* exposed area at the bottom border */
				fix_exposure( class, object, rp,
					dx, vcb->vert.virtual.size - dy, vcb->horiz.virtual.size - dx, dy );
			else if( dy < 0 ) /* exposed area at the top border */
				fix_exposure( class, object, rp,
					dx, 0, vcb->horiz.virtual.size - dx, -dy );
		}
	}
	ReleaseSemaphore( &vcb->semaphore );
	ReleaseGIRPort( rp );
	return ( dx || dy );
}

static ULONG updateVCB( Class *class, Object *object, struct opUpdate *opu )
{
	struct VCB *vcb = INST_DATA( class, object );
	struct TagItem *ti, *tstate = opu->opu_AttrList;

	DoSuperMethodA( class, object, (Msg)opu );	/* pass on our ID */
	switch( GetTagData( GA_ID, 0, opu->opu_AttrList ) )
	{
	case HORIZ_ID:
		shift_vcb( class, object,
			GetTagData( PGA_Top, vcb->horiz.virtual.offset, opu->opu_AttrList ),
			vcb->vert.virtual.offset,
			opu->opu_GInfo, opu->opu_Flags );
		break;
	case VERT_ID:
		shift_vcb( class, object,
			vcb->horiz.virtual.offset,
			GetTagData( PGA_Top, vcb->vert.virtual.offset, opu->opu_AttrList ),
			opu->opu_GInfo, opu->opu_Flags );
		break;
	}
	return 1;
}

static ULONG setVCB( Class *class, Object *object, struct opSet *ops )
{
	struct VCB *vcb = INST_DATA( class, object );
	struct RastPort *rp;
	struct TagItem *ti, *tstate = ops->ops_AttrList;

#ifdef DEBUG
	kprintf( "setVCB : GadgetInfo %08lx, gi_Window %08lx, gi_Requester %08lx\n",
		ops->ops_GInfo, ops->ops_GInfo->gi_Window, ops->ops_GInfo->gi_Requester );
#endif
	while( ti = NextTagItem( &tstate ) )
	{
#ifdef DEBUG1
		kprintf( "setVCB : Tag %08lx, Data %08lx\n", ti->ti_Tag, ti->ti_Data );
#endif
		switch( ti->ti_Tag )
		{
		case VCBGA_ExposureHook:
			ObtainSemaphore( &vcb->semaphore );		/* disallow usage of hook */
			vcb->exposure = (struct Hook *)ti->ti_Data;
			ReleaseSemaphore( &vcb->semaphore );	/* permit usage of hook */
			break;
		case VCBGA_HOffset:
			if( shift_vcb( class, object,
				ti->ti_Data, vcb->vert.virtual.offset, ops->ops_GInfo, 0 ) )
			{
				/* now move the scroll bars, too */
				if( vcb->horiz.scroller )
					SetGadgetAttrs( (struct Gadget *)vcb->horiz.scroller,
						ops->ops_GInfo->gi_Window, ops->ops_GInfo->gi_Requester,
						PGA_Top, vcb->horiz.virtual.offset,
						TAG_DONE );
				if( vcb->vert.scroller )
					SetGadgetAttrs( (struct Gadget *)vcb->vert.scroller,
						ops->ops_GInfo->gi_Window, ops->ops_GInfo->gi_Requester,
						PGA_Top, vcb->vert.virtual.offset,
						TAG_DONE );
			}
			break;
		case VCBGA_HTotal:
			vcb->horiz.total = ti->ti_Data;
			if( rp = ObtainGIRPort( ops->ops_GInfo ) )
			{
				display( class, object, rp, ops->ops_GInfo );
				ReleaseGIRPort( rp );
			}
			break;
		case VCBGA_HUnit:
			vcb->horiz.unit = ti->ti_Data;
			if( rp = ObtainGIRPort( ops->ops_GInfo ) )
			{
				display( class, object, rp, ops->ops_GInfo );
				ReleaseGIRPort( rp );
			}
			break;
		case VCBGA_VOffset:
			if( shift_vcb( class, object,
				vcb->horiz.virtual.offset, ti->ti_Data, ops->ops_GInfo, 0 ) )
			{
				/* now move the scroll bars, too */
				if( vcb->horiz.scroller )
					SetGadgetAttrs( (struct Gadget *)vcb->horiz.scroller,
						ops->ops_GInfo->gi_Window, ops->ops_GInfo->gi_Requester,
						PGA_Top, vcb->horiz.virtual.offset,
						TAG_DONE );
				if( vcb->vert.scroller )
					SetGadgetAttrs( (struct Gadget *)vcb->vert.scroller,
						ops->ops_GInfo->gi_Window, ops->ops_GInfo->gi_Requester,
						PGA_Top, vcb->vert.virtual.offset,
						TAG_DONE );
			}
			break;
		case VCBGA_VTotal:
			vcb->vert.total = ti->ti_Data;
			if( rp = ObtainGIRPort( ops->ops_GInfo ) )
			{
				display( class, object, rp, ops->ops_GInfo );
				ReleaseGIRPort( rp );
			}
			break;
		case VCBGA_VUnit:
			vcb->vert.unit = ti->ti_Data;
			if( rp = ObtainGIRPort( ops->ops_GInfo ) )
			{
				display( class, object, rp, ops->ops_GInfo );
				ReleaseGIRPort( rp );
			}
			break;
		case VCBGA_Interim:
			if( ti->ti_Data )
				vcb->flags |= VCBF_INTERIM;
			else
				vcb->flags &= ~VCBF_INTERIM;
			break;
		}
	}
#ifdef DEBUG
	kprintf( "setVCB : complete\n" );
#endif
	return 1;
}

static ULONG getVCB( Class *class, Object *object, struct opGet *opg )
{
	struct VCB *vcb = INST_DATA( class, object );

	switch( opg->opg_AttrID )
	{
	case VCBGA_ExposureHook:
		*opg->opg_Storage = (ULONG)vcb->exposure;
		return 1;
	case VCBGA_HOffset:
		*opg->opg_Storage = vcb->horiz.virtual.offset;
		return 1;
	case VCBGA_HTotal:
		*opg->opg_Storage = vcb->horiz.total;
		return 1;
	case VCBGA_HUnit:
		*opg->opg_Storage = vcb->horiz.unit;
		return 1;
	case VCBGA_HSize:
		*opg->opg_Storage = vcb->horiz.virtual.size;
		return 1;
	case VCBGA_VOffset:
		*opg->opg_Storage = vcb->vert.virtual.offset;
		return 1;
	case VCBGA_VTotal:
		*opg->opg_Storage = vcb->vert.total;
		return 1;
	case VCBGA_VUnit:
		*opg->opg_Storage = vcb->vert.unit;
		return 1;
	case VCBGA_VSize:
		*opg->opg_Storage = vcb->vert.virtual.size;
		return 1;
	case VCBGA_XOrigin:
		*opg->opg_Storage = vcb->horiz.real.offset;
		return 1;
	case VCBGA_YOrigin:
		*opg->opg_Storage = vcb->vert.real.offset;
		return 1;
	case VCBGA_Flags:
		*opg->opg_Storage = vcb->flags;
		return 1;
	case VCBGA_Interim:
		*opg->opg_Storage = ( vcb->flags & VCBF_INTERIM ) != 0;
		return 1;
	case VCBGA_HScroller:
		*opg->opg_Storage = ( vcb->flags & VCBF_HSCROLLER ) != 0;
		return 1;
	case VCBGA_VScroller:
		*opg->opg_Storage = ( vcb->flags & VCBF_VSCROLLER ) != 0;
		return 1;
	case VCBGA_HBorder:
		*opg->opg_Storage = ( vcb->flags & VCBF_HBORDER ) != 0;
		return 1;
	case VCBGA_VBorder:
		*opg->opg_Storage = ( vcb->flags & VCBF_VBORDER ) != 0;
		return 1;
	case VCBGA_Semaphore:
		*opg->opg_Storage = (ULONG)( &vcb->semaphore );
		return 1;
	default:
		return DoSuperMethodA( class, object, (Msg)opg );
	}
}

static ULONG disposeVCB( Class *class, Object *object, Msg msg )
{
	struct VCB *vcb = INST_DATA( class, object );

	if( vcb->horiz.scroller )
		DisposeObject( vcb->horiz.scroller );
	if( vcb->vert.scroller )
		DisposeObject( vcb->vert.scroller );
	return DoSuperMethodA( class, object, msg );
}

static ULONG dispatchVCB( Class *class, Object *object, Msg msg )
{
	geta4();

#ifdef DEBUG
	kprintf( "dispatchVCB : MethodID %08lx\n", msg->MethodID );
#endif
	switch( msg->MethodID )
	{
	case OM_NEW:
		return newVCB( class, object, (struct opSet *)msg );
	case OM_SET:
		return setVCB( class, object, (struct opSet *)msg );
	case OM_GET:
		return getVCB( class, object, (struct opGet *)msg );
	case OM_UPDATE:
		return updateVCB( class, object, (struct opUpdate *)msg );
	case OM_DISPOSE:
		return disposeVCB( class, object, msg );
	case GM_RENDER:
		return renderVCB( class, object, (struct gpRender *)msg );
	case GM_HITTEST:
		return 0;
	default:
		return DoSuperMethodA( class, object, msg );
	}
}

/***************************** public section ***************************/

/*
 *	initVCBClass() creates our BOOPSI class, freeVCBClass() tries to free it again.
 *
 *	These two functions are the ONLY targets to public reference within this module.
 *	Everything else is PRIVATE (static) stuff.
 */
Class *initVCBClass( void )
{
	struct VCBperClassData *vpcd;
	Class *class;

	if( vpcd = AllocMem( sizeof( struct VCBperClassData ), MEMF_PUBLIC ) )
	{
		if( vpcd->VCXClass = initVCXClass() )
		{
			if( class = MakeClass( NULL, "gadgetclass", NULL, sizeof( struct VCB ), 0 ) )
			{
				SetupHook( &class->cl_Dispatcher, dispatchVCB, NULL );
				class->cl_UserData = (ULONG)vpcd;
				return class;
			}
			freeVCXClass( vpcd->VCXClass );
		}
		FreeMem( vpcd, sizeof( struct VCBperClassData ) );
	}
	return NULL;
}

int freeVCBClass( Class *class )
{
	struct VCBperClassData *vpcd = (struct VCBperClassData *)class->cl_UserData;

	if( FreeClass( class ) )
	{
		if( freeVCXClass( vpcd->VCXClass ) )
		{
			FreeMem( vpcd, sizeof( struct VCBperClassData ) );
			return 1;
		}
	}
	return 0;
}
