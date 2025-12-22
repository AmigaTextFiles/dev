/* magnifyclass.c (C) 1995/96 by Reinhard Katzmann. All rights reserved
 * BOOPSI (BGUI) GFXEdit/View gadget class including magnifying.
 * It is FREEWARE. Usage is restricted. Please refer to the included
 * MagnifyClass.readme for more information.
 *
 * Based on paletteclass.c which is (C) 1995 by Jan van den Baard.
 * WARNING: Tabsize=4 ;-)
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>

#include <intuition/intuition.h>
#include <graphics/gfxmacros.h>
#include <graphics/scale.h>
#include <graphics/gfxbase.h>
#include <libraries/bgui.h>

/* #include <stdio.h> */
/* #include <stdlib.h> */

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/bgui.h>
#include <proto/utility.h>
#ifdef RES_TRACK
#include "restrack.h"
#endif

extern void *memset(void *, int, unsigned int);
/* extern KPrintF(const char *,...);
extern int sprintf(char *, const char *, ...); */
#define bzero(a,b) memset(a,0,b)

/* Do not include string.h here! SAS/C function includes a call to exit() */
/* which may NOT be in a shared library !!! */

#include <gadgets/magnifyclass.h>

/*
**  Compiler stuff.
*/
#ifdef _DCC
#define SAVEDS __geta4
#define ASM
#define REG(x) __ ## x
#define REGARGS __regargs
#else
#define SAVEDS __saveds
#define ASM __asm
#define REG(x) register __ ## x
#define REGARGS __regargs
#endif

#ifdef __SLIB
#include <dos.h>
#include "MagnifyClass_rev.h"

UBYTE versiontag[] = VERSTAG;
UBYTE Copyright[] = VERS " Copyright (C) 1995/96 by Reinhard Katzmann. All Rights Reserved";
#endif

/*
** OS Dependencies
*/
#define OSVERSION(ver)  GfxBase->LibNode.lib_Version >= (ver)
#define HAS_AGA         (GfxBase->ChipRevBits0 & GFXF_AA_ALICE)
#define MAXCOLORS       256

/*
**  Simple type-cast.
**/
#define GAD(x)      (( struct Gadget * )x)
#define MINROW  16
#define MINCOL  16

/*
**  Koordinate pair structure
*/
typedef struct {
        UWORD x;
        UWORD y;
} COORD;

/*
**  MagnifyClass object instance data.
**/
typedef struct {
    COORD       md_FrameCoords;     /* Coordinates of Spezial GridFrame     */
    BOOL        md_SpecialFrame;    /* Special Frame for one Pixel          */
    Object  *md_Frame;              /* The frame object for special frame   */
    BOOL        md_Edit;            /* May we edit our picture              */
    UWORD       md_MagFactor;       /* Magnify Factor                       */
    UBYTE       md_CurrentPen;      /* Currently selected Pen.              */
    struct BitMap *md_Picture;      /* Picture                              */
    COORD    md_SRegion;            /* Selected Region of Picture           */
    BOOL        md_Grid;            /* If TRUE use grid around pixels       */
    UBYTE       md_GridPen;         /* Selected GridPen.                    */
    struct IBox md_GraphBox;        /* Bounds of the object without frame.  */
    UWORD       md_GraphWidth;      /* max. Width of Object (fixed!!)       */
    UWORD       md_GraphHeight;     /* max. Height of Object (fixed!!)      */
    UWORD       md_BoxWidth;        /* md_GraphBox.Width (Notify)           */
    UWORD       md_BoxHeight;       /* md_GraphBox.Width (Notify)           */
    UBYTE       md_ScaleWidth;      /* md_GraphBox.Width (Notify)           */
    UBYTE       md_ScaleHeight;     /* md_GraphBox.Width (Notify)           */
    struct BitMap *md_UndoBuffer;   /* UndoBuffer, for application.         */
    struct BitMap *md_InitialBuffer; /* Initial Buffer (Rendering)          */
    BOOL        md_ResetBuffer;     /* Immediate Undo                       */
} MD;

/*
** Free a allocated BitMap (a public function for testmagnify)
*/
STATIC ASM ULONG MyFreeBitMap( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct magmBitMap *mbr )
{
   BOOL nb=FALSE;

    if (OSVERSION(39) )
    {
        if (*(mbr->mbm)) FreeBitMap(*(mbr->mbm));
        else nb=TRUE;
        *(mbr->mbm)=NULL;
    }
    else                    /* Running under V37 */
    {
        LONG    planesize = (*(mbr->mbm))->BytesPerRow * (*(mbr->mbm))->Rows;
        int     i;

        for (i = 0; i < (*(mbr->mbm))->Depth; ++i)
        {
            if ((*(mbr->mbm))->Planes[i])
            {
                FreeMem((*(mbr->mbm))->Planes[i], planesize);
            } else nb = TRUE;
        }
        FreeVec(*(mbr->mbm));
        *(mbr->mbm)=NULL;
    }
   if (nb) return MAGERR_NoBitMap;
   return MAGERR_Ok;
}

/*
** Allocate a BitMap (a public function for testmagnify)
*/
STATIC ASM ULONG MyAllocBitMap( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct magmBitMap *mbr)
{
    if (OSVERSION(39) )
    {

        *(mbr->mbm) = AllocBitMap(GetBitMapAttr(mbr->sbm,BMA_WIDTH), GetBitMapAttr(mbr->sbm,BMA_HEIGHT), GetBitMapAttr(mbr->sbm,BMA_DEPTH), BMF_CLEAR | GetBitMapAttr(mbr->sbm,BMA_FLAGS), NULL);
        if (!*(mbr->mbm)) return MAGERR_AllocFail;
    }
    else
    {
      LONG depth=mbr->sbm->Depth, width=mbr->sbm->BytesPerRow*8, height=mbr->sbm->Rows;
        LONG planesize, bmsize = sizeof(struct BitMap);

        /*
        **  If the bitmap has more than 8 planes, we add the size of the
        **  additional plane pointers to the amount of memory we allocate
        **  for the bitmap structure.
        */
        if (depth > 8)
            bmsize += sizeof(PLANEPTR) * (depth-8);

        if (*(mbr->mbm) = AllocVec(bmsize, MEMF_PUBLIC | MEMF_CLEAR) )
        {
            int i;

            InitBitMap(*(mbr->mbm), depth, width, height);
            planesize = (*(mbr->mbm))->BytesPerRow * (*(mbr->mbm))->Rows;

            for (i = 0; i < depth; ++i)
            {
                if ( (*(mbr->mbm))->Planes[i] = AllocMem(planesize, MEMF_CHIP | MEMF_CLEAR) )
                {
                }
                else
                {
                    DoMethod(obj,MAGM_FreeBitMap,*(mbr->mbm));
                    *(mbr->mbm) = NULL;
                    return MAGERR_AllocFail;
                }
            }
        } else return MAGERR_AllocFail;
    }
   /* if (mygfx) CloseLibrary(( struct Library * )GfxBase ); */
   return MAGERR_Ok;
}


/*
**  Create a new magnify object.
**/
STATIC ASM ULONG MagnifyClassNew( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct opSet *ops )
{
    MD          *md;
    struct TagItem      *tstate = ops->ops_AttrList, *tag;
    struct BitMap   *bm;
    Object          *label;
    ULONG            rc, place;

    /*
    **  Let the superclass make the object.
    **/
    if ( rc = DoSuperMethodA( cl, obj, ( Msg )ops )) {
        /*
        **  Get a pointer to the object
        **  it's instance data.
        **/
        md = ( MD * )INST_DATA( cl, rc );

        /*
        **  Preset the data to 0. Don't
        **  know if this is necessary.
        **/
        bzero(( char * )md, sizeof( MD ));

        /*
        **  Setup the default settings.
        **/
        md->md_MagFactor                 = 1; /* No Magnification */
        md->md_Edit                      = TRUE;  /* Drawing is allowed */
        md->md_GraphWidth                = MINCOL;
        md->md_GraphHeight               = MINROW;
        md->md_ScaleWidth                = 0;
        md->md_ScaleHeight               = 0;
        md->md_SpecialFrame              = FALSE;
        md->md_Frame                     = NULL;
        md->md_CurrentPen                = 0;
        md->md_Grid                      = FALSE; /* No Grid */
        md->md_GridPen                   = 0; /* Grid Pen Color "invisible" */

        /*
        **  Setup the instance data.
        **/
        while ( tag = NextTagItem( &tstate )) {
            switch ( tag->ti_Tag ) {

                case    MAGNIFY_MagFactor:
                        if (tag->ti_Data>0) md->md_MagFactor = tag->ti_Data;
                        if (md->md_MagFactor<1) md->md_MagFactor=1;
                        break;

                case    MAGNIFY_Edit:
                        md->md_Edit = tag->ti_Data;
                        break;

                case    MAGNIFY_SpecialFrame:
                        if (( md->md_SpecialFrame=tag->ti_Data ) == TRUE)
                        md->md_Frame = BGUI_NewObject(BGUI_FRAME_IMAGE, FRM_Type, FRTYPE_BUTTON, FRM_Flags, FRF_RECESSED, TAG_END);
                        break;

                case    MAGNIFY_FrameCoordsX:
                        md->md_FrameCoords.x = tag->ti_Data;
                        break;

                case    MAGNIFY_FrameCoordsY:
                        md->md_FrameCoords.y = tag->ti_Data;
                        break;

                /*
                ** Get Picture (Brush) information from a Bitmap
                ** and copy it into the instance data
                */
                case    MAGNIFY_PicArea:
                        bm = (struct BitMap *)tag->ti_Data;
                        DoMethod(obj,MAGM_AllocBitMap, &md->md_Picture, bm);
                        if(md->md_Picture && bm) BltBitMap(bm,0,0,md->md_Picture,0,0,bm->BytesPerRow*8,bm->Rows,0xC0,0xFF,NULL);
                        md->md_GraphWidth=GetBitMapAttr(md->md_Picture,BMA_WIDTH);
                        md->md_GraphHeight=GetBitMapAttr(md->md_Picture,BMA_HEIGHT);
                        break;

                case    MAGNIFY_CurrentPen:
                        md->md_CurrentPen = tag->ti_Data;
                        break;

                case    MAGNIFY_Grid:
                        md->md_Grid = tag->ti_Data;
                        break;

                case    MAGNIFY_GridPen:
                        md->md_GridPen = tag->ti_Data;
                        break;

                case    MAGNIFY_SelectRegionX:
                        md->md_SRegion.x = tag->ti_Data;
                        break;

                case    MAGNIFY_SelectRegionY:
                        md->md_SRegion.y = tag->ti_Data;
                        break;

                case    MAGNIFY_ScaleWidth:
                        md->md_ScaleWidth = tag->ti_Data;
                        if (md->md_ScaleWidth<0) md->md_ScaleWidth=0;
                        else if (md->md_ScaleWidth>100) md->md_ScaleWidth=100;
                        break;

                case    MAGNIFY_ScaleHeight:
                        md->md_ScaleHeight = tag->ti_Data;
                        if (md->md_ScaleHeight<0) md->md_ScaleHeight=0;
                        else if (md->md_ScaleHeight>1100) md->md_ScaleHeight=100;
                        break;
            }
        }

        /*
        **  See if the object has a label
        **  attached to it.
        **/
        DoMethod(( Object * )rc, OM_GET, BT_LabelObject, &label );
        if ( label ) {
            /*
            **  Yes. Query the place because it may
            **  not be PLACE_IN for obvious reasons.
            **/
            DoMethod( label, OM_GET, LAB_Place, &place );
            if ( place == PLACE_IN )
                SetAttrs( label, LAB_Place, PLACE_LEFT, TAG_END );
        }

        return (rc);

        /*
        **   Not yet needed by this class
        **
        CoerceMethod( cl, ( Object * )rc, OM_DISPOSE ); */
    }
    return( 0L);
}

/*
**  Dispose of the object.
**/
STATIC ASM ULONG MagnifyClassDispose( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) Msg msg )
{
    MD          *md = ( MD * )INST_DATA( cl, obj );

    /*
    **  Free Pic Area & Undo Buffer
    **/
    if (md->md_Picture) DoMethod(obj,MAGM_FreeBitMap,&md->md_Picture);
    md->md_Picture=NULL;
    if (md->md_UndoBuffer) DoMethod(obj,MAGM_FreeBitMap,&md->md_UndoBuffer);
    md->md_UndoBuffer=NULL;
    if (md->md_InitialBuffer) DoMethod(obj,MAGM_FreeBitMap,&md->md_InitialBuffer);
    md->md_InitialBuffer=NULL;

    /*
    **  The superclass handles
    **  the rest.
    **/
    return( DoSuperMethodA( cl, obj, msg ));
}

/*
**  Get an attribute.
**/
STATIC ASM ULONG MagnifyClassGet( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct opGet *opg )
{
    MD          *md = ( MD * )INST_DATA( cl, obj );
    ULONG            rc = 1L;
    /* char zeile[80]; */
    struct BitMap *bm;

    /*
    **  Handle our attribute.
    **/
    /* sprintf(zeile,"opg->opg_AttrID: %d\n",opg->opg_AttrID);
    KPrintF("%s",zeile); */
    switch ( opg->opg_AttrID) {

        case    MAGNIFY_Edit:
                *( opg->opg_Storage ) = md->md_Edit;
                break;

        case    MAGNIFY_MagFactor:
                *( opg->opg_Storage ) = md->md_MagFactor;
                break;

        case    MAGNIFY_SpecialFrame:
                *( opg->opg_Storage ) = md->md_SpecialFrame;
                break;

        case    MAGNIFY_GraphWidth:
                *( opg->opg_Storage ) = md->md_GraphWidth;
                break;

        case    MAGNIFY_GraphHeight:
                *( opg->opg_Storage ) = md->md_GraphHeight;
                break;

        case    MAGNIFY_FrameCoordsX:
                *( opg->opg_Storage ) = md->md_FrameCoords.x;
                break;

        case    MAGNIFY_FrameCoordsY:
                *( opg->opg_Storage ) = md->md_FrameCoords.y;
                break;

        case    MAGNIFY_PicArea:
                bm = (struct BitMap *)*( opg->opg_Storage);
                if(md->md_Picture && bm) BltBitMap(md->md_Picture,0,0,bm,0,0,md->md_Picture->BytesPerRow*8,md->md_Picture->Rows,0xC0,0xFF,NULL);
                break;

        case    MAGNIFY_CurrentPen:
                *( opg->opg_Storage ) = md->md_CurrentPen;
                break;

        case    MAGNIFY_Grid:
                *( opg->opg_Storage ) = md->md_Grid;
                break;

        case    MAGNIFY_GridPen:
                *( opg->opg_Storage ) = md->md_GridPen;
                break;

       case MAGNIFY_SelectRegionX:
                *( opg->opg_Storage ) = md->md_SRegion.x;
                break;

       case MAGNIFY_SelectRegionY:
                *( opg->opg_Storage ) = md->md_SRegion.y;
                break;


        default:
        /*
        **  Everything else goes
        **  to the superclass.
        **/
        rc = DoSuperMethodA( cl, obj, ( Msg )opg );
        break;
    }

    return( rc );
}

/*
**  Render the BitMap of our object
**/
STATIC ASM BOOL RenderBitMap( REG(a0) MD *md, REG(a1) struct gpRender *gpr, REG(a2) struct IBox *area, REG(a3) struct DrawInfo *dri )
{
    UWORD       colsize, rowsize;
    UWORD       left, top, c, r, color=0;
    ULONG       cx, cy;
    /* char zeile[256]; */
    struct BitScaleArgs mbs;
    struct BitMap *tmpbm; /* temporary BitMap for scaling */
    struct RastPort *rp=gpr->gpr_RPort;

    /*
    **  Get initial left and top offset.
    **/
    left = area->Left + 1;
    top  = area->Top  + 1;

    /*
    **  Calculate Width and Height of the area to blit.
    **  This depends on the MAG_Factor.
    **/

    cx = area->Width/(md->md_MagFactor+(md->md_Grid ? 1 : 0));
    cy = area->Height/(md->md_MagFactor+(md->md_Grid ? 1 : 0));

    md->md_GraphWidth=GetBitMapAttr(md->md_Picture,BMA_WIDTH);
    md->md_GraphHeight=GetBitMapAttr(md->md_Picture,BMA_HEIGHT);

    if ((cx+md->md_SRegion.x) > md->md_GraphWidth) cx=md->md_GraphWidth-md->md_SRegion.x;
    if ((cy+md->md_SRegion.y) > md->md_GraphHeight) cy=md->md_GraphHeight-md->md_SRegion.y;

    /*
    **  No patterns!
    **/
    SetAfPt( rp, NULL, 0 );

    /*
    ** Allocate temporary Bitmap
    ** We cannot use MyAllocBitMap here since we have no BitMap with
    ** the needed Width/Height/Depth Information
    */
    if (OSVERSION(39) )
    {
        if (!(tmpbm=AllocBitMap(cx*(md->md_MagFactor+(md->md_Grid ? 1 : 0))+1+md->md_SRegion.x,cy*(md->md_MagFactor+(md->md_Grid ? 1 : 0))+1+md->md_SRegion.y,md->md_Picture->Depth,BMF_DISPLAYABLE,md->md_Picture)))
            return NULL;
    }
    else
    {
        LONG depth=md->md_Picture->Depth, width=cx*(md->md_MagFactor+(md->md_Grid ? 1 : 0)), height=cx*(md->md_MagFactor+(md->md_Grid ? 1 : 0));
        LONG planesize, bmsize = sizeof(struct BitMap);

        /*
        **  If the bitmap has more than 8 planes, we add the size of the
        **  additional plane pointers to the amount of memory we allocate
        **  for the bitmap structure.
        */
        if (depth > 8)
            bmsize += sizeof(PLANEPTR) * (depth-8);

        if (tmpbm = AllocVec(bmsize, MEMF_PUBLIC | MEMF_CLEAR) )
        {
            int i;

            InitBitMap(tmpbm, depth, width, height);
            planesize = tmpbm->BytesPerRow * tmpbm->Rows;

            for (i = 0; i < depth; ++i)
            {
                if (tmpbm->Planes[i] = AllocMem(planesize, MEMF_CHIP | MEMF_CLEAR) )
                {
                }
                else
                {
                    for (i = 0; i < depth; ++i)
                        if (tmpbm->Planes[i])
                            FreeMem(tmpbm->Planes[i], planesize);
                    FreeVec(tmpbm);
                    return NULL;
                }
            }
        } else return NULL;
    }

    /*
    **  Now Blit the Bitmap and scale if necessary.
    **/

    if (md->md_Picture) {
        mbs.bsa_SrcX=md->md_SRegion.x;
        mbs.bsa_SrcY=md->md_SRegion.y;
        mbs.bsa_SrcWidth=cx;
        mbs.bsa_SrcHeight=cy;
        mbs.bsa_DestX=md->md_SRegion.x;
        mbs.bsa_DestY=md->md_SRegion.y;
        mbs.bsa_DestWidth=cx;
        mbs.bsa_DestHeight=cy;
        mbs.bsa_XSrcFactor=1;
        mbs.bsa_YSrcFactor=1;
        mbs.bsa_XDestFactor=md->md_MagFactor+(md->md_Grid ? 1 : 0);
        mbs.bsa_YDestFactor=md->md_MagFactor+(md->md_Grid ? 1 : 0);
        mbs.bsa_SrcBitMap=md->md_Picture;
        mbs.bsa_DestBitMap=tmpbm;
        mbs.bsa_Flags=NULL;

        /* sprintf(zeile,"w=%d,h=%d,cx=%d, cy=%d, srcx=%d, srcy=%d, xdf=%d, ydf=%d\n",md->md_GraphWidth,md->md_GraphHeight,cx,cy, md->md_SRegion.x,md->md_SRegion.y,(md->md_MagFactor+(md->md_Grid ? 1 : 0)),(md->md_MagFactor+(md->md_Grid ? 1 : 0)));
        KPrintF("%s",zeile); */
        BitMapScale(&mbs);
        BltBitMapRastPort(tmpbm,md->md_SRegion.x,md->md_SRegion.y,rp,left,top,cx*(md->md_MagFactor+(md->md_Grid ? 1 : 0)),cy*(md->md_MagFactor+(md->md_Grid ? 1 : 0)),0xC0);

        /*
        ** Now Draw the grid if necessary
        */
        if (md->md_Grid) {
            colsize=md->md_MagFactor+(md->md_Grid ? 1 : 0);
            rowsize=md->md_MagFactor+(md->md_Grid ? 1 : 0);
            SetAPen( rp, md->md_GridPen );
            /*
            ** Draw the grid
            */
            for ( c = left-1; c < area->Width+left; c+=colsize ) RectFill( rp, c, top, c, top+area->Height-1);
            for ( r = top-1; r < area->Height+top; r+=rowsize ) RectFill( rp, left, r, left+area->Width-1, r);
        }
        /*
        **  The special pixel we want to show off
        **  is done with a frameclass object.
        **/
        if ( md->md_SpecialFrame ) {
            /*
            **  Setup the object.
            **/
            colsize=md->md_MagFactor+(md->md_Grid ? 1 : 0);
            rowsize=md->md_MagFactor+(md->md_Grid ? 1 : 0);
            color = 0; /* Need to change somewhen */
            SetAttrs( md->md_Frame, IA_Left,    md->md_FrameCoords.x*md->md_MagFactor,
                        IA_Top,         md->md_FrameCoords.y*md->md_MagFactor,
                        IA_Width,   colsize,
                        IA_Height,  rowsize,
                        FRM_BackPen,    color,
                        TAG_END );
            /*
            **  Render it.
            **/
            DrawImageState( rp, ( struct Image * )md->md_Frame, 0, 0, IDS_NORMAL, dri );
        }
    }
    if (tmpbm) { /* Free the temporary bitmap */
        if (OSVERSION(39) )
        {
            if (tmpbm) FreeBitMap(tmpbm);
            tmpbm=NULL;
        }
        else                    /* Running under V37 */
        {
            LONG    planesize = tmpbm->BytesPerRow * tmpbm->Rows;
            int     i;

            for (i = 0; i < tmpbm->Depth; ++i)
            {
                if (tmpbm->Planes[i])
                {
                    FreeMem(tmpbm->Planes[i], planesize);
                }
            }
            FreeVec(tmpbm);
            tmpbm=NULL;
        }
    }
    return(TRUE);
}

/*
**  Notify about an attribute change.
**/
STATIC ULONG NotifyAttrChange( Object *obj, struct GadgetInfo *gi, ULONG flags, Tag tag1, ... )
{
    return( DoMethod( obj, OM_NOTIFY, &tag1, gi, flags ));
}

/*
**  Render the magnify object.
**/
STATIC ASM ULONG MagnifyClassRender( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct gpRender *gpr )
{
    MD              *md = ( MD * )INST_DATA( cl, obj );
    struct RastPort rp = *gpr->gpr_RPort;
    struct DrawInfo *dri = gpr->gpr_GInfo->gi_DrInfo;
    struct IBox     *bounds;
    Object          *frame;
    ULONG           fw = 0, fh = 0;
    static UWORD    dispat[ 2 ] = { 0x2222, 0x8888 };
    ULONG           rc;

    /*
    **  First we let the superclass
    **  render. If it returns 0 we
    **  do not render!
    **/
    if ( rc = DoSuperMethodA( cl, obj, ( Msg )gpr )) {
        /*
        **  Get the hitbox bounds of the object
        **  and copy it's contents. We need to
        **  copy the data because we must adjust
        **  it's contents.
        **/
        DoMethod( obj, OM_GET, BT_HitBox, &bounds );
        md->md_GraphBox = *bounds;

        /*
        **  Do we have a frame?
        **/
        DoMethod( obj, OM_GET, BT_FrameObject, &frame );
        if ( frame ) {
            /*
            **  Find out the frame thickness.
            **/
            DoMethod( frame, OM_GET, FRM_FrameWidth,  &fw );
            DoMethod( frame, OM_GET, FRM_FrameHeight, &fh );
            fw++;
            fh++;

            /*
            **  Adjust bounds accoordingly.
            **/
            md->md_GraphBox.Left      += fw;
            md->md_GraphBox.Top   += fh;
            md->md_GraphBox.Width     -= fw << 1;
            md->md_GraphBox.Height    -= fh << 1;
        }

        /*
        **  Render the pixel rectangles.
        **/
        if (!RenderBitMap( md, gpr , &md->md_GraphBox, dri ))
            return NULL;

        /*
        **  Disabled?
        **/
        md->md_BoxWidth=md->md_GraphBox.Width/(md->md_MagFactor+(md->md_Grid ? 1 : 0));
        md->md_BoxHeight=md->md_GraphBox.Height/(md->md_MagFactor+(md->md_Grid ? 1 : 0));
        NotifyAttrChange( obj, gpr->gpr_GInfo, 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_BoxWidth, md->md_BoxWidth, TAG_END );
        NotifyAttrChange( obj, gpr->gpr_GInfo, 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_BoxHeight, md->md_BoxHeight, TAG_END );
        if ( GAD( obj )->Flags & GFLG_DISABLED ) {
            SetAPen( &rp, dri ? dri->dri_Pens[ SHADOWPEN ] : 2 );
            SetDrMd( &rp, JAM1 );
            SetAfPt( &rp, dispat, 1 );
            RectFill( &rp, bounds->Left,
                       bounds->Top,
                       bounds->Left + bounds->Width  - 1,
                       bounds->Top  + bounds->Height - 1 );
        }

    }
    return( rc );
}

/*
**  Draw a pixel with the currently selected pen.
**/
STATIC ASM VOID DrawPixel( REG(a0) MD *md, REG(a1) struct GadgetInfo *gi, REG(a2) struct IBox *area, REG(d0) COORD newpixel)
{
    struct Window *win=gi->gi_Window;
    struct RastPort *rp=win->RPort;
    UWORD  l, t, colsize, rowsize,left,top;
    /* char zeile[256]; */

    /*
    **  Compute the pixel width and
    **  height of the color rectangles.
    ** Set Grid, if used.
    **/
    colsize = md->md_MagFactor + (md->md_Grid ? 1 : 0);
    rowsize = md->md_MagFactor + (md->md_Grid ? 1 : 0);

    /*
    ** Check if we hit bounds with a pixel with big col/rowsize, if yes return
    */
    if ( ( (l=(newpixel.x/colsize)*colsize) + (colsize>>1)+2) >= md->md_GraphBox.Width ||
          ( (t=(newpixel.y/rowsize)*rowsize) + (rowsize>>1)+2) >= md->md_GraphBox.Height )
        return;

    /* sprintf(zeile,"w=%d,h=%d,l=%d, t=%d, npx=%d, npy=%d, xdf=%d, ydf=%d\n",md->md_GraphWidth,md->md_GraphHeight,l,t,newpixel.x,newpixel.y,(md->md_MagFactor+(md->md_Grid ? 1 : 0)),(md->md_MagFactor+(md->md_Grid ? 1 : 0)));
    KPrintF("%s",zeile); */

    /*
    **  Allocate a rastport.
    **/
    if ( gi && ( rp = ObtainGIRPort( gi ))) {
        /*
        **  First pickup the coordinates
        **  of the currently selected
        **  pixel.
        **/
        l += md->md_GraphBox.Left;
        t += md->md_GraphBox.Top;

        /*
        **  Render this pixel rectangle
        **/
        if ( md->md_SpecialFrame &&
                (l==md->md_FrameCoords.x && t==md->md_FrameCoords.y) ) {
            /*
            **  Setup the object.
            **/
            SetAttrs( md->md_Frame, IA_Left,    l,
                        IA_Top,         t,
                        IA_Width,   colsize-(md->md_Grid ? (md->md_MagFactor) : 0 ),
                        IA_Height,  rowsize-(md->md_Grid ? (md->md_MagFactor) : 0 ),
                        FRM_BackPen,    md->md_CurrentPen,
                        TAG_END );
            /*
            **  Render it.
            **/
            DrawImageState( rp, ( struct Image * )md->md_Frame, 0, 0, IDS_NORMAL, gi->gi_DrInfo );
        } else {
            SetAPen( rp, md->md_CurrentPen );
            RectFill( rp, l+1, t+1, l + colsize - (md->md_Grid ? 1 : 0), t + rowsize - (md->md_Grid ? 1 : 0));

        }
        /*
        ** Set the color also in the Picture Area
        ** Actually does a BltBitMap of the pixel
        */

        left=(l-md->md_GraphBox.Left)/(md->md_MagFactor + (md->md_Grid ? 1 : 0) );
        top=(t-md->md_GraphBox.Top)/(md->md_MagFactor + (md->md_Grid ? 1 : 0) );
        if (md->md_Picture) BltBitMap(rp->BitMap,win->LeftEdge+l+1+(md->md_Grid ? 1 : 0 ),win->TopEdge+t+1+(md->md_Grid ? 1 : 0 ),md->md_Picture,md->md_SRegion.x+left,md->md_SRegion.y+top,1,1,0xC0,0xFF,NULL);

        /*
        **  Free up the rastport.
        **/
        ReleaseGIRPort( rp );
    }
}

/*
**  Draw the special pixel with the currently selected pen.
**/
STATIC ASM VOID DrawFramePixel( REG(a0) MD *md, REG(a1) struct GadgetInfo *gi, REG(a2) struct IBox *area, REG(d0) COORD newpixel)
{
    struct RastPort *rp;
    UWORD           l, t, colsize, rowsize;

    /*
    **  Compute the pixel width and
    **  height of the color rectangles.
    ** Set Grid, if used.
    **/
    colsize = md->md_MagFactor + (md->md_Grid ? 1 : 0);
    rowsize = md->md_MagFactor + (md->md_Grid ? 1 : 0);

    /*
    ** Check if we hit bounds with a pixel with big col/rowsize, if yes return
    */
    if ( ( (l=(newpixel.x/colsize)*colsize) + (colsize>>1)) > md->md_GraphBox.Width ||
          ( (t=(newpixel.y/rowsize)*rowsize) + (rowsize>>1)) > md->md_GraphBox.Height )
        return;

    /*
    **  Allocate a rastport.
    **/
    if ( gi && ( rp = ObtainGIRPort( gi ))) {
        /*
        **  First pickup the coordinates
        **  of the currently selected
        **  pixel.
        **/
        l += md->md_GraphBox.Left;
        t += md->md_GraphBox.Top;


        /*
        **  Setup the object.
        **/
        SetAttrs( md->md_Frame, IA_Left,    l,
                    IA_Top,         t,
                    IA_Width,   colsize-(md->md_Grid ? (md->md_MagFactor) : 0 ),
                    IA_Height,  rowsize-(md->md_Grid ? (md->md_MagFactor) : 0 ),
                    FRM_BackPen,    md->md_CurrentPen,
                    TAG_END );
        /*
        **  Render it.
        **/
        DrawImageState( rp, ( struct Image * )md->md_Frame, 0, 0, IDS_NORMAL, gi->gi_DrInfo );

        /*
        **  Free up the rastport.
        **/
        ReleaseGIRPort( rp );
    }
}

/*
**  Set attributes.
**/
STATIC ASM ULONG MagnifyClassSet( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct opUpdate *opu)
{
    MD              *md = ( MD * )INST_DATA( cl, obj );
    struct TagItem  *tag,*merk;
    struct BitMap   *bm;
    struct RastPort *rp=NULL;
    ULONG           rc, new;
    COORD           npix;
    /* char         zeile[256]; */

    /*
    **  First the superclass.
    **/
    merk=opu->opu_AttrList;
    /* while(tag=NextTagItem(&opu->opu_AttrList)) {
         sprintf(zeile,"tag=%X\n",tag);
         KPrintF("%s",zeile);
     } */

    opu->opu_AttrList=merk;
    rc = DoSuperMethodA( cl, obj, ( Msg )opu );

    /*
    **  Frame thickness change? When the window in which
    **  we are located has WINDOW_AutoAspect set to TRUE
    **  the windowclass distributes the FRM_ThinFrame
    **  attribute to the objects in the window. Here we
    **  simply intercept it to set the selected color
    **  frame thickness.
    **/
    if ( tag = FindTagItem( FRM_ThinFrame, opu->opu_AttrList ))
        /*
        **  Set it to the frame.
        **/
        SetAttrs( md->md_Frame, FRM_ThinFrame, tag->ti_Data, TAG_END );


    /*
    ** Magnify Factor change?
    */
    if ( tag = FindTagItem(MAGNIFY_MagFactor, opu->opu_AttrList )) {
        /*
        ** Did it really change ?
        */
        if ( (new=tag->ti_Data) != md->md_MagFactor) {
            /*
            ** Yes. Show it and notify
            ** the change
            */
            if (md->md_MagFactor<1) md->md_MagFactor=1;
            if (new>0) md->md_MagFactor = new;
            if ( rp = ObtainGIRPort( opu->opu_GInfo )) {
                DoMethod(obj, GM_RENDER, opu->opu_GInfo, rp, GREDRAW_REDRAW);
                ReleaseGIRPort( rp );
            }
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_MagFactor, md->md_MagFactor, TAG_END );
        }
    }

    /*
    ** Special Frame X-Coordinate change?
    */
    if ( tag = FindTagItem(MAGNIFY_FrameCoordsX, opu->opu_AttrList )) {
        if ( (new=tag->ti_Data) != md->md_FrameCoords.x) {
            npix.x = md->md_FrameCoords.x = new;
            npix.y = md->md_FrameCoords.x;
            DrawFramePixel(md, opu->opu_GInfo, &md->md_GraphBox, npix);
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_FrameCoordsX, md->md_FrameCoords.x, TAG_END );
        }
    }

    /*
    ** Special Frame Y-Coordinate change?
    */
    if ( tag = FindTagItem(MAGNIFY_FrameCoordsY, opu->opu_AttrList )) {
        if ( (new=tag->ti_Data) != md->md_FrameCoords.y) {
            npix.x = md->md_FrameCoords.x;
            npix.y = md->md_FrameCoords.x = new;
            DrawFramePixel(md, opu->opu_GInfo, &md->md_GraphBox, npix);
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_FrameCoordsY, md->md_FrameCoords.y, TAG_END );
        }
    }

    /*
    ** Get Picture (Brush) information from a Bitmap
    ** and copy it into the instance data
    */
    if (tag = FindTagItem(MAGNIFY_PicArea, opu->opu_AttrList )) {

        /*
        ** Save old Picture BitMap if present
        ** for Undo function and free the BitMap
        */
        if (md->md_Picture) {
            if (md->md_UndoBuffer) DoMethod(obj,MAGM_FreeBitMap,&md->md_UndoBuffer); /* Delete old Buffer if present */
            DoMethod(obj,MAGM_AllocBitMap, &md->md_UndoBuffer, md->md_Picture);
            if (md->md_UndoBuffer) BltBitMap(md->md_Picture,0,0,md->md_UndoBuffer,0,0,md->md_Picture->BytesPerRow*8,md->md_Picture->Rows,0xC0,0xFF,NULL);
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_PicArea, md->md_UndoBuffer, TAG_END );
        }
        if (md->md_Picture) DoMethod(obj,MAGM_FreeBitMap,&md->md_Picture); /* Delete Area for new Picture, if present */

        /*
        ** Allocate new Picture BitMap. Blit the
        ** bm Bitmap to our new allocated BitMap
        */
        bm = (struct BitMap *)tag->ti_Data;
        md->md_Picture=NULL;
        DoMethod(obj,MAGM_AllocBitMap, &md->md_Picture, bm);
        if(md->md_Picture && bm) {
            BltBitMap(bm,0,0,md->md_Picture,0,0,bm->BytesPerRow*8,bm->Rows,0xC0,0xFF,NULL);
            md->md_GraphWidth=GetBitMapAttr(md->md_Picture,BMA_WIDTH);
            md->md_GraphHeight=GetBitMapAttr(md->md_Picture,BMA_HEIGHT);
            /* md->md_GraphWidth=md->md_Picture->BytesPerRow*8;
            md->md_GraphHeight=md->md_Picture->Rows; */
        }
        NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_PicArea, md->md_Picture, TAG_END );
        if ( rp = ObtainGIRPort( opu->opu_GInfo )) {
            DoMethod(obj, GM_RENDER, opu->opu_GInfo, rp, GREDRAW_REDRAW);
            ReleaseGIRPort( rp );
        }
    }

    /*
    ** Change of MAGNIFY_CurrentPen?
    */
    if ( tag = FindTagItem(MAGNIFY_CurrentPen, opu->opu_AttrList )) {
        if ( (new=tag->ti_Data) != md->md_CurrentPen) {
            md->md_CurrentPen = new;
            /* NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_CurrentPen, md->md_CurrentPen, TAG_END ); */
        }
    }

    /*
    ** MAGNIFY_Grid value switched?
    ** (De)Activates the grid around the pixels
    */
    if ( tag = FindTagItem(MAGNIFY_Grid, opu->opu_AttrList )) {
        if ( (new=tag->ti_Data) != md->md_Grid) {
            md->md_Grid = new;
            if ( rp = ObtainGIRPort( opu->opu_GInfo )) {
                DoMethod(obj, GM_RENDER, opu->opu_GInfo, rp, GREDRAW_REDRAW);
                ReleaseGIRPort( rp );
            }
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_Grid, md->md_Grid, TAG_END );
        }
    }

    /*
    ** MAGNIFY_GridPen value switched?
    ** Changes the grid colour
    */
    if ( tag = FindTagItem(MAGNIFY_GridPen, opu->opu_AttrList )) {
        if ( (new=tag->ti_Data) != md->md_GridPen) {
            md->md_GridPen = new;
            if ( rp = ObtainGIRPort( opu->opu_GInfo )) {
                DoMethod(obj, GM_RENDER, opu->opu_GInfo, rp, GREDRAW_REDRAW);
                ReleaseGIRPort( rp );
            }
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_GridPen, md->md_GridPen, TAG_END );
        }
    }

    /*
    ** Select a new region from the Picture Area
    ** MAGNIFY_SelectRegion
    */
    if ( tag = FindTagItem(MAGNIFY_SelectRegionX, opu->opu_AttrList )) {
        if ( (new=tag->ti_Data) != md->md_SRegion.x) {
            md->md_SRegion.x = new;
            if ( rp = ObtainGIRPort( opu->opu_GInfo )) {
                DoMethod(obj, GM_RENDER, opu->opu_GInfo, rp, GREDRAW_REDRAW);
                ReleaseGIRPort( rp );
            }
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_SelectRegionX, md->md_SRegion.x, TAG_END );
        }
    }

    if ( tag = FindTagItem(MAGNIFY_SelectRegionY, opu->opu_AttrList )) {
        if ( (new=tag->ti_Data) != md->md_SRegion.y) {
            md->md_SRegion.y = new;
            if ( rp = ObtainGIRPort( opu->opu_GInfo )) {
                DoMethod(obj, GM_RENDER, opu->opu_GInfo, rp, GREDRAW_REDRAW);
                ReleaseGIRPort( rp );
            }
            NotifyAttrChange( obj, opu->opu_GInfo, opu->MethodID == OM_UPDATE ? opu->opu_Flags : 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_SelectRegionY, md->md_SRegion.y, TAG_END );
        }
    }
    return( rc );
}

/*
** Copy UndoBuffer to Picture->Planes
** Copy Picture->Planes to UndoBuffer
** A bit tricky, eh ? ;-)
*/
STATIC ASM VOID RestoreOldPicture( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct gpRender *gpi )
{
    struct BitMap *tmpbitmap=NULL;
    MD      *md = ( MD * )INST_DATA( cl, obj );

    /*
    ** Do we have a Picture?
    */
    if (!md->md_Picture) return;

    /*
    ** Is there something to be undone?
    */
    if (!md->md_UndoBuffer) return;

    /*
    ** Copy Picture into tmpbuffer
    */
    DoMethod(obj,MAGM_AllocBitMap, &tmpbitmap, md->md_Picture);
    if (tmpbitmap) BltBitMap(md->md_Picture,0,0,tmpbitmap,0,0,md->md_Picture->BytesPerRow*8,md->md_Picture->Rows,0xC0,0xFF,NULL);
    if (md->md_Picture) DoMethod(obj,MAGM_FreeBitMap,&md->md_Picture); /* Delete Picture */

    /*
    ** Do the Undo: Copy UndoBuffer into Picture Area
    */
    DoMethod(obj,MAGM_AllocBitMap, &md->md_Picture, md->md_UndoBuffer);
    if (md->md_Picture) BltBitMap(md->md_UndoBuffer,0,0,md->md_Picture,0,0,md->md_UndoBuffer->BytesPerRow*8,md->md_UndoBuffer->Rows,0xC0,0xFF,NULL);
    if (md->md_UndoBuffer) DoMethod(obj,MAGM_FreeBitMap,&md->md_UndoBuffer); /* Delete UndoBuffer */

    /*
    ** Now copy the tmpbuffer back into the UndoBuffer
    */
    DoMethod(obj,MAGM_AllocBitMap, &md->md_UndoBuffer, tmpbitmap);
    if (md->md_UndoBuffer && tmpbitmap) BltBitMap(tmpbitmap,0,0,md->md_UndoBuffer,0,0,tmpbitmap->BytesPerRow*8,tmpbitmap->Rows,0xC0,0xFF,NULL);
    if (tmpbitmap) DoMethod(obj,MAGM_FreeBitMap,&tmpbitmap); /* Delete tmpbuffer */
}

/*
**  Let's go active :)
**/
STATIC ASM ULONG MagnifyClassGoActive( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct gpInput *gpi )
{
    MD          *md = ( MD * )INST_DATA( cl, obj );
    WORD             l, t;
    UWORD            cs,rs;
    COORD        newpixel;
    ULONG            rc = GMR_NOREUSE;

    /*
    ** First check, if we are Edit-Object
    */
    if (md->md_Edit == FALSE) return 0;

    /*
    **  We do not go active when we are
    **  disabled or when we where activated
    **  by the ActivateGadget() call.
    **/
    if (( GAD( obj )->Flags & GFLG_DISABLED ) || ( ! gpi->gpi_IEvent ))
        return( rc );

    /*
    **  Save actual Picture Area when going
    **  active. This way we can reset
    **  the initial buffer when the
    **  gadget activity is aborted by
    **  the user or intuition.
    **/
    if (md->md_InitialBuffer) DoMethod(obj,MAGM_FreeBitMap,&md->md_InitialBuffer);
    if (md->md_Picture)
    DoMethod(obj,MAGM_AllocBitMap, &md->md_InitialBuffer, md->md_Picture);
    if (md->md_InitialBuffer && md->md_Picture) BltBitMap(md->md_Picture,0,0,md->md_InitialBuffer,0,0,md->md_Picture->BytesPerRow*8,md->md_Picture->Rows,0xC0,0xFF,NULL);

    /*
    **  Get the coordinates relative
    **  to the top-left of the GraphBox.
    **/
    l = gpi->gpi_Mouse.X - ( md->md_GraphBox.Left - GAD( obj )->LeftEdge );
    t = gpi->gpi_Mouse.Y - ( md->md_GraphBox.Top  - GAD( obj )->TopEdge  );

    cs = md->md_MagFactor + (md->md_Grid ? 1 : 0);
    rs = md->md_MagFactor + (md->md_Grid ? 1 : 0);

    /*
    **  Are we really hit?
    **/
    if ( l >= 0 && t >= 0  && l < md->md_GraphBox.Width && t < md->md_GraphBox.Height )
        if (l<=(md->md_GraphWidth*rs) && t<=(md->md_GraphHeight*cs)) {
            /*
            ** Draw the new pixel
            */
            newpixel.x=l;
            newpixel.y=t;
            DrawPixel(md, gpi->gpi_GInfo, &md->md_GraphBox, newpixel);
            NotifyAttrChange( obj, gpi->gpi_GInfo, 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_PicArea, md->md_Picture, TAG_END );

            /*
            **  Go active.
            **/
            rc = GMR_MEACTIVE;
        }
    return( rc );
}

/*
**  Handle the user input.
**/
STATIC ASM ULONG MagnifyClassHandleInput( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct gpInput *gpi )
{
    MD          *md = ( MD * )INST_DATA( cl, obj );
    COORD            newpixel;
    WORD             l, t;
    ULONG            rc = GMR_MEACTIVE;

    /*
    ** First check, if we are Edit-Object
    */
    if (md->md_Edit == FALSE) return 0;

    /*
    **  Get the coordinates relative
    **  to the top-left of the GraphBox.
    **/
    l = gpi->gpi_Mouse.X - ( md->md_GraphBox.Left - GAD( obj )->LeftEdge );
    t = gpi->gpi_Mouse.Y - ( md->md_GraphBox.Top  - GAD( obj )->TopEdge  );

    /*
    **  Mouse pointer located over the object?
    **/
    if ( l >= 0 && t >= 0 && l < md->md_GraphBox.Width && t < md->md_GraphBox.Height )
        if (l<=md->md_GraphWidth && t<=md->md_GraphHeight) {

            /*
            ** Draw the new pixel
            */
            newpixel.x=l;
            newpixel.y=t;
            DrawPixel(md, gpi->gpi_GInfo , &md->md_GraphBox, newpixel);
            if (md->md_Picture) NotifyAttrChange( obj, gpi->gpi_GInfo, 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_PicArea, md->md_Picture, TAG_END );
        }

    /*
    **  Check mouse input.
    **/
    if ( gpi->gpi_IEvent->ie_Class == IECLASS_RAWMOUSE ) {
        switch ( gpi->gpi_IEvent->ie_Code ) {

            case    SELECTUP:
                /*
                **  Left-mouse button up means we
                **  return GMR_VERIFY.
                **/
                rc = GMR_NOREUSE | GMR_VERIFY;
                break;

            case    MENUDOWN:
                /*
                **  The menu button aborts the
                **  drawing.
                **/
                md->md_ResetBuffer = TRUE;
                rc = GMR_NOREUSE;
                break;
        }
    }
    return( rc );
}

/*
**  Go inactive.
**/
STATIC ASM ULONG MagnifyClassGoInactive( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct gpGoInactive *ggi )
{
    MD          *md = ( MD * )INST_DATA( cl, obj );

    /*
    **  Reset initial color?
    **/
    if ( md->md_ResetBuffer || ggi->gpgi_Abort == 1 ) {

        /* Reset old area */
        if (md->md_InitialBuffer && md->md_Picture) {
            BltBitMap(md->md_InitialBuffer,0,0,md->md_Picture,0,0,md->md_InitialBuffer->BytesPerRow*8,md->md_InitialBuffer->Rows,0xC0,0xFF,NULL);
            DoMethod(obj,MAGM_FreeBitMap,&md->md_InitialBuffer);
        }

        NotifyAttrChange( obj, ggi->gpgi_GInfo, 0L, GA_ID, GAD( obj )->GadgetID, MAGNIFY_PicArea, md->md_Picture, TAG_END );
        /*
        **  Clear reset flag.
        **/
        md->md_ResetBuffer = FALSE;
    }

    return( DoSuperMethodA( cl, obj, ( Msg )ggi ));
}

/*
**  Tell'm our minimum dimensions.
**/
STATIC ASM ULONG MagnifyClassDimensions( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct grmDimensions *dim )
{
    MD          *md = ( MD * )INST_DATA( cl, obj );
    ULONG        rc,width=md->md_GraphWidth,height=md->md_GraphHeight;

    width=(width*md->md_ScaleWidth)/100;
    height=(height*md->md_ScaleHeight)/100;
    /*
    **  First the superclass.
    **/
    rc = DoSuperMethodA( cl, obj, ( Msg )dim );

    *( dim->grmd_MinSize.Width  ) += (MINROW + width);
    *( dim->grmd_MinSize.Height ) += (MINCOL + height);

    return( rc );
}

/*
**  The class dispatcher. Here's
**  where the fun starts.
**
**  SAS Users: You should either compile this module with
**         stack checking turned off (NOSTACKCHECK) or
**         you must use the "__interrupt" qualifier in
**         this routine.
**/
STATIC SAVEDS ASM ULONG MagnifyClassDispatch( REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) Msg msg )
{
    ULONG           rc;
    /* MD          *md = ( MD * )INST_DATA( cl, obj ); */
    /* char z[80]; */

#ifdef __SLIB
    /*
     *  Storage to put back a6.
     */
    ULONG            rega6 = getreg( REG_A6 );

    /*
     *  The shared library version is compiled with one near data
     *  section for each time the library is opened. This requires
     *  the correct library base in a6 because that needs to be
     *  referenced to load a4 with the near data section for the
     *  current task.
     *
     *  Since the system can not load up a6 for us with the correct
     *  library base pointer we do it ourselves.
     *
     *  When the shared library version initializes the class it
     *  puts a pointer to the library base into the class userdata
     *  field. We put this into a6.
     */
    putreg( REG_A6, cl->cl_UserData );

    /*
     *  Now we load up a4 with the near data section for this task
     *  and we are ready to go.
     */
    geta4();
#endif

    switch ( msg->MethodID ) {

        case    OM_NEW:
            /* KPrintF("Vor New\n"); */
            rc = MagnifyClassNew( cl, obj, ( struct opSet * )msg );
            break;

        case    OM_DISPOSE:
            /* KPrintF("Vor Dispose\n"); */
            rc = MagnifyClassDispose( cl, obj, msg );
            break;

        case    OM_GET:
            /* KPrintF("Vor Get\n"); */
            rc = MagnifyClassGet( cl, obj, ( struct opGet * )msg );
            break;

        case    OM_SET:
            /* KPrintF("Vor Set\n"); */
        case    OM_UPDATE:
            /* KPrintF("Vor Set oder Update\n"); */
            rc = MagnifyClassSet( cl, obj, ( struct opUpdate * )msg);
            break;

        case    GM_RENDER:
            /* KPrintF("Vor Render\n"); */
            rc = MagnifyClassRender( cl, obj, ( struct gpRender * )msg );
            break;

        case    GM_GOACTIVE:
            /* KPrintF("Vor Active\n"); */
            rc = MagnifyClassGoActive( cl, obj, ( struct gpInput * )msg );
            break;

        case    GM_HANDLEINPUT:
            /* KPrintF("Vor HandleInput\n"); */
            rc = MagnifyClassHandleInput( cl, obj, ( struct gpInput * )msg );
            break;

        case    GM_GOINACTIVE:
            /* KPrintF("Vor Inactive\n"); */
            rc = MagnifyClassGoInactive( cl, obj, ( struct gpGoInactive * )msg );
            break;

        case    GRM_DIMENSIONS:
            /* KPrintF("Vor Dimensions\n"); */
            rc = MagnifyClassDimensions( cl, obj, ( struct grmDimensions * )msg );

        /*
        ** Method MAGM_Undo
        ** Restores Picture in Undobuffer to Picture Area
        */
        case MAGM_Undo:
            /* KPrintF("Vor Undo\n"); */
            RestoreOldPicture( cl, obj, ( struct gpRender * )msg);
            break;

        case MAGM_AllocBitMap:
            /* KPrintF("Vor AllocBitMap\n"); */
            rc = MyAllocBitMap( cl, obj, ( struct magmBitMap * )msg);
            break;

        case MAGM_FreeBitMap:
            /* KPrintF("Vor FreeBitMap\n"); */
            rc = MyFreeBitMap( cl, obj, ( struct magmBitMap * )msg);
            break;

        default:
            /* KPrintF("Vor Default\n"); */
            rc = DoSuperMethodA( cl, obj, msg );
            break;
    }
#ifdef __SLIB
    /*
     *  Put back original a6 contents.
     */
    putreg( REG_A6, rega6 );
#endif
    return( rc );
}

/*
**  Initialize the class.
**/
#ifdef __SLIB
ASM Class *SetupMagnifyClass( REG(a6) struct Library *lib )
#else
Class *InitMagnifyClass( void )
#endif
{
    Class           *super, *cl = NULL;

    /*
    **  Obtain the BaseClass pointer which
    **  will be our superclass.
    **/
    if ( super = BGUI_GetClassPtr( BGUI_BASE_GADGET )) {
        /*
        **  Create the class.
        **/
        if ( cl = MakeClass( NULL, NULL, super, sizeof( MD ), 0L )) {
            /*
            **  Setup dispatcher.
            **/
            cl->cl_Dispatcher.h_Entry = ( HOOKFUNC )MagnifyClassDispatch;
#ifdef __SLIB
            /*
             *  Here we put the library base into the class
             *  structure. This pointer is used in the dispatcher
             *  to setup the near data into a4.
             */
            cl->cl_UserData = ( ULONG )lib;
#endif
        }
    }
    return( cl );
}

/*
**  Kill the class.
**/
BOOL FreeMagnifyClass( Class *cl )
{
    return( FreeClass( cl ));
}

/*
 *  The following code is only compiled for the shared library
 *  version of the class.
 */
#ifdef __SLIB
Class           *ClassBase;

struct IntuitionBase    *IntuitionBase;
struct GfxBase      *GfxBase;
struct Library      *LayersBase;
struct Library      *UtilityBase;
struct Library      *BGUIBase;

/*
 *  Called each time the library is opened. It simply opens
 *  the required libraries and set's up the class.
 */
SAVEDS ASM int __UserLibInit( REG(a6) struct Library *lib )
{
    if ( IntuitionBase = ( struct IntuitionBase * )OpenLibrary( "intuition.library", 37 )) {
        if ( GfxBase = ( struct GfxBase * )OpenLibrary( "graphics.library", 37 )) {
            if ( LayersBase = OpenLibrary( "layers.library", 37 )) {
                if ( UtilityBase = OpenLibrary( "utility.library", 37 )) {
                    if ( BGUIBase = OpenLibrary( BGUINAME, 39 )) {
                        if ( ClassBase = SetupMagnifyClass( lib ))
                            return( 0 );
                        CloseLibrary( BGUIBase );
                    }
                    CloseLibrary( UtilityBase );
                }
                CloseLibrary( LayersBase );
             }
            CloseLibrary(( struct Library * )GfxBase );
        }
        CloseLibrary(( struct Library * )IntuitionBase );
    }
    return( 1 );
}

/*
 *  Called each time the library is closed. It simply closes
 *  the required libraries and frees the class.
 */
SAVEDS ASM void __UserLibCleanup( REG(a6) struct Library *lib )
{
    /*
     *  Actually this can fail...
     */
    FreeMagnifyClass( ClassBase );

    CloseLibrary( BGUIBase );
    CloseLibrary( UtilityBase );
    CloseLibrary( LayersBase );
    CloseLibrary(( struct Library * )GfxBase );
    CloseLibrary(( struct Library * )IntuitionBase );
}

/*
 *  Not the only callable routine in the library ;)
 */
SAVEDS Class *LIBF_MAGNIFY_GetClassPtr( void )
{
    return( ClassBase );
}
#endif  /* __SLIB */
