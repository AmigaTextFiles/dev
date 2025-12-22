/*
**  $Filename: DateSelectorGadget.c $
**  $Revision: 1.1 $
**  $Date: 93/06/05 $
**
**  Copyright (c) 1993  Markus Aalto
**
**  This code is distributed under the GNU General Public Licence. Please
**  refer to the file COPYING for details.
**
**  1.0:    06.04.1993
**          Supports YEAR, MONTH, DAY, FIXEDPOSITION and SUNDAYFIRST tags.
**
**  1.1:    05.06.1993
**          Supports optimized rendering when DSD_FIXEDPOSITION is enabled.
**          Fixed a (harmless?) bug in handling of OPUF_INTERIM messages.
*/

#include    <exec/types.h>
#include    <exec/memory.h>
#include    <intuition/intuition.h>
#include    <intuition/classes.h>
#include    <intuition/classusr.h>
#include    <intuition/gadgetclass.h>
#include    <intuition/cghooks.h>
#include    <graphics/text.h>
#include    <graphics/gfxmacros.h>
#include    <utility/date.h>
#include    <utility/hooks.h>
#include    <utility/tagitem.h>

#include    <proto/exec.h>
#include    <proto/graphics.h>
#include    <proto/utility.h>
#include    <proto/intuition.h>
#include    <clib/alib_protos.h>
#include    <clib/macros.h>

#include    <dos.h>
#include    <string.h>
#include    "BoopsiObjects/DateSelectorGadClass.h"

struct Number {
    char    array[3];
    WORD    width;
};

struct DateSelectorData {
    struct  TextFont *dsd_TextFont;             /*  Pointer to TextFont structure for this gadget.  */
    UWORD   dsd_Flags;                          /*  See DSD_XXXX for more info.                     */
    UWORD   dsd_Year;                           /*  1978-2099                                       */
    UWORD   dsd_Month;                          /*  1-12                                            */
    UWORD   dsd_MDay;                           /*  1-31                                            */
    UWORD   dsd_FirstMonthDay;                  /*  0-6                                             */
    UWORD   dsd_MaxMDay;                        /*  28-31                                           */
    UWORD   dsd_OldMDay;                        /*  Used in UPDATE rendering.                       */
    UWORD   dsd_RenderFlags;                    /*  Used for optimized rendering.                   */
    struct  Number dsd_numbers[31];
};

/*  Definitions for DateSelectorData.dsd_Flags  */
#define     DSD_FIXEDPOSITION   1
#define     DSD_SUNDAYFIRST     2               /*  Works only if DSD_FIXEDPOSITION is cleared.     */
#define     DSD_NUMBERSREADY    4               /*  For internal use only.  :^)                     */

/*  Definitions for DateSelectorData.dsd_RenderFlags    */
#define     DSDR_OPTIMIZED_REFRESH  1           /*  In Fixed mode we refresh only 29-31 buttons.    */

#define     SET_BETWEEN(val,min,max)    { if( val < min ) { val = min; } else if( val > max) { val = max; } }

ULONG       __saveds dispatchDateSelectorGad(   Class *,
                                                Object *,
                                                Msg );

ULONG       DateSelectorGad_NEW(    Class *cl,
                                    Object *o,
                                    Msg msg );

ULONG       DateSelectorGad_RENDER( Class *cl,
                                    struct Gadget *gad,
                                    struct gpRender *gpr );

VOID        DateSelectorGad_GOACTIVE(   Class *cl,
                                        struct Gadget *gad,
                                        struct gpInput *gpi );

ULONG       DateSelectorGad_SET(    Class *cl,
                                    struct Gadget *gad,
                                    struct opSet *ops );

ULONG       DateSelectorGad_GET(    Class *cl,
                                    Object *o,
                                    struct opGet *opg );

VOID        DateSelectorGad_ButtonPushed(   Class *cl,
                                            struct Gadget *gad,
                                            struct GadgetInfo *gi,
                                            struct DateSelectorData *dsd,
                                            ULONG UpdateType );

UWORD       DateSelectorGad_FirstMonthDay(  UWORD year,
                                            UWORD month );

VOID        DateSelectorGad_DrawNumberBox(  struct RastPort *rp,
                                            UWORD GadgetFlags,
                                            struct GadgetInfo *gi,
                                            struct Number *num,
                                            BOOL Selected,
                                            ULONG X,
                                            ULONG Y,
                                            ULONG W,
                                            ULONG H );

/*  We use next two functions quite often in time critical places so
**  we use register parameters here.
*/
VOID        __asm DSG_GetPositions( register __a0 struct DateSelectorData *dsd,
                                    register __a1 ULONG *start,
                                    register __a2 ULONG *end);

VOID        __asm DSG_CalcBoxCoords(register __a0 struct Gadget *gad,
                                    register __d0 ULONG pos,
                                    register __a1 ULONG *X,
                                    register __a2 ULONG *Y,
                                    register __d1 ULONG W,
                                    register __d2 ULONG H );

VOID        DSG_mysprintf(  UBYTE *buffer,
                            UBYTE *Format, ... );

VOID        DSG_stuffChar(  VOID );

UWORD       DSG_MaxNumberOfDays(    UWORD Year,
                                    UWORD Month );

Class __asm *initDateSelectorGadClass()
{
    Class *cl;
    extern ULONG HookEntry();

    cl = MakeClass( NULL, "gadgetclass", NULL, sizeof( struct DateSelectorData ), 0 );
    if( cl ) {
        cl->cl_Dispatcher.h_Entry = HookEntry;
        cl->cl_Dispatcher.h_SubEntry = dispatchDateSelectorGad;
    }

    return(cl);
}

BOOL __asm freeDateSelectorGadClass( register __a0 Class *cl )
{
    return( FreeClass(cl) );
}

BOOL __asm DateSelectorGadDimensions(   register __a0 struct TextFont *tf,
                                        register __a1 ULONG *width,
                                        register __a2 ULONG *height,
                                        register __d0 BOOL IsFixed )
{
    int     i;
    char    number[3];
    struct  RastPort *fake_rp;
    struct  TextExtent te;
    UWORD   widest_number;
    ULONG   temp_width, temp_height;

    fake_rp = (struct RastPort *)AllocVec( sizeof(struct RastPort), MEMF_ANY|MEMF_CLEAR );
    if( fake_rp == NULL ) return( FALSE );

    /*  We don't make any rendering to this RastPort so we don't
    **  set up BitPlanes for it. But we need it to calculate
    **  text sizes.
    */

    InitRastPort(fake_rp);
    SetFont(fake_rp,tf);

    for( i = 1, widest_number = 0; i < 32; i++ ) {
        DSG_mysprintf(number,"%ld",i);
        TextExtent(fake_rp,number,1 + (i > 9),&te);
        widest_number = MAX( widest_number, te.te_Width );
    }

    temp_height = (4 + te.te_Height)*(5 + ( IsFixed == FALSE ) );
    temp_width = 7*(8 + widest_number);

    *height = ( *height > temp_height ) ? ( *height - (*height % (5 + ( IsFixed == FALSE ))) ) : temp_height;
    *width = ( *width > temp_width ) ? ( *width - (*width % 7 ) ) : temp_width;

    FreeVec( (void *)fake_rp);
    return( TRUE );
}

ULONG __saveds dispatchDateSelectorGad( Class *cl, Object *o, Msg msg)
{
    ULONG   retval;

    switch( msg->MethodID )
    {
        case OM_NEW:
            retval = DateSelectorGad_NEW( cl, o, msg );
            break;
        case GM_HITTEST:
            retval = GMR_GADGETHIT;
            break;
        case GM_RENDER:
            retval = DateSelectorGad_RENDER(cl, (struct Gadget *)o, (struct gpRender *)msg);
            break;
        case GM_GOACTIVE:
            DateSelectorGad_GOACTIVE(cl, (struct Gadget *)o, (struct gpInput *)msg);
            retval = GMR_NOREUSE;
        case OM_UPDATE:
        case OM_SET:
            retval = DateSelectorGad_SET(cl, (struct Gadget *)o, (struct opSet *)msg);
            break;
        case OM_GET:
            retval = DateSelectorGad_GET(cl, o, (struct opGet *)msg);
            break;
        default:
            retval = DoSuperMethodA(cl,o, (Msg *)msg);
            break;
    }

    return(retval);
}


ULONG DateSelectorGad_NEW( Class *cl, Object *o, Msg msg )
{
    ULONG   retval;
    struct  TagItem *tags = ((struct opSet *)msg)->ops_AttrList;
    struct  DateSelectorData *dsd;

    retval = (ULONG)DoSuperMethodA(cl,o,(Msg *)msg);
    if( retval ) {
        dsd = INST_DATA(cl,retval);

        dsd->dsd_TextFont = (struct TextFont *)GetTagData(DSG_TEXTFONT, NULL, tags );
        if( dsd->dsd_TextFont == 0 ) {
            DoMethod( (Object *)retval, OM_DISPOSE );
            return(0);
        }

        dsd->dsd_Flags = ( GetTagData(DSG_FIXEDPOSITION,TRUE,tags) ) ? DSD_FIXEDPOSITION : 0;
        if( dsd->dsd_Flags != DSD_FIXEDPOSITION ) {
            dsd->dsd_Flags = ( GetTagData(DSG_SUNDAYFIRST, 0, tags) ) ? DSD_SUNDAYFIRST : 0;
        }
        dsd->dsd_Year = GetTagData(DSG_YEAR, 1978, tags);
        dsd->dsd_Month = GetTagData(DSG_MONTH,1,tags);
        dsd->dsd_MDay = GetTagData(DSG_DAY,1,tags);

        SET_BETWEEN(dsd->dsd_Year, 1978, 2099);
        SET_BETWEEN(dsd->dsd_Month, 1, 12);
        dsd->dsd_MaxMDay = DSG_MaxNumberOfDays( dsd->dsd_Year, dsd->dsd_Month );
        SET_BETWEEN( dsd->dsd_MDay, 1, dsd->dsd_MaxMDay );

        dsd->dsd_FirstMonthDay = DateSelectorGad_FirstMonthDay( dsd->dsd_Year, dsd->dsd_Month );
    }

    return( retval );
}

ULONG DateSelectorGad_RENDER( Class *cl, struct Gadget *gad, struct gpRender *gpr )
{
    struct  RastPort *rp;
    struct  DateSelectorData *dsd = INST_DATA(cl,(Object *)gad);
    int     selected, i;
    ULONG   start, end, rows, X, Y, button_width, button_height;
    UBYTE   BackPen;
    struct  TextFont *old_tf = NULL;
    struct  TextExtent te;

    rp = gpr->gpr_RPort;
    rows = 5 + ( (dsd->dsd_Flags & DSD_FIXEDPOSITION) == 0 );
    button_width = gad->Width / 7;
    button_height = gad->Height / rows;

    /*  If RastPort font is different from our font, we temporarily change it. */
    if(rp->Font != dsd->dsd_TextFont) {
        old_tf = rp->Font;
        SetFont(rp,dsd->dsd_TextFont);
    }

    /*  If we are rendering first time, then we first calculate the Number structures.  */
    if( (dsd->dsd_Flags & DSD_NUMBERSREADY) == 0 ) {
        for( i = 0; i < 31; i++ ) {
            DSG_mysprintf(dsd->dsd_numbers[i].array,"%ld",1+i);
            TextExtent(rp, dsd->dsd_numbers[i].array, 1 + (i > 8), &te);    /* Is same as [ 1 + ( (i+1) > 9 ) ]. */
            dsd->dsd_numbers[i].width = te.te_Width;
        }
        dsd->dsd_Flags |= DSD_NUMBERSREADY;
    }

    DSG_GetPositions(dsd,&start,&end);
    selected = start + dsd->dsd_MDay - 1;

    if( gpr->gpr_Redraw == GREDRAW_REDRAW ) {
        BackPen = gpr->gpr_GInfo->gi_DrInfo->dri_Pens[BACKGROUNDPEN];

        /*  If optimized rendering then we start updating from
        **  29th button. Otherwise we start from 1st.
        */
        i = (dsd->dsd_RenderFlags & DSDR_OPTIMIZED_REFRESH) ? 28 : 0;

        /*  Now we can clear DSDR_OPTIMIZED_REFRESH flag.   */
        dsd->dsd_RenderFlags &= ~DSDR_OPTIMIZED_REFRESH;

        for( ; i < 7*rows; i++ ) {
            if( (i >= start ) && ( i < end) ) {
                DSG_CalcBoxCoords( gad, i, &X, &Y, button_width, button_height );
                DateSelectorGad_DrawNumberBox(  rp, gad->Flags , gpr->gpr_GInfo, &dsd->dsd_numbers[i-start],
                                                (i == selected), X, Y, button_width, button_height );
            }
            else {
                DSG_CalcBoxCoords( gad, i, &X, &Y, button_width, button_height );
                SetAPen(rp, BackPen );
                RectFill(rp, X, Y, X + button_width - 1, Y + button_height -1);
            }
        }
    }
    else {
        /*  Update new selected button. */
        i = dsd->dsd_MDay - 1;
        DSG_CalcBoxCoords( gad, start + i, &X, &Y, button_width, button_height );
        DateSelectorGad_DrawNumberBox(  rp, gad->Flags, gpr->gpr_GInfo, &dsd->dsd_numbers[i], TRUE,
                                        X, Y, button_width, button_height );

        /*  Update old selected button. */
        i = dsd->dsd_OldMDay - 1;
        DSG_CalcBoxCoords( gad, start + i, &X, &Y, button_width, button_height );
        DateSelectorGad_DrawNumberBox(  rp, gad->Flags, gpr->gpr_GInfo, &dsd->dsd_numbers[i], FALSE,
                                        X, Y, button_width, button_height );
    }

    if( old_tf ) SetFont(rp,old_tf);

    return( 0 );
}

VOID DateSelectorGad_GOACTIVE(Class *cl, struct Gadget *gad, struct gpInput *gpi)
{
    struct  DateSelectorData *dsd = INST_DATA(cl,(Object *)gad);
    UWORD   new_active, button_width, button_height;
    ULONG   start, end;

    DSG_GetPositions(dsd, &start, &end);
    button_width = gad->Width / 7;
    button_height = gad->Height / (5 + ((dsd->dsd_Flags & DSD_FIXEDPOSITION) == 0));

    /*  If we pressed outside the buttons, but inside the gadget.
    **  Actually this can happen if width's modulo 7 is not equal
    **  to zero. Should not happen if you used DateSelectorGadDimensions()
    **  function before opening the gadget.
    */
    if( button_width*7 < gpi->gpi_Mouse.X ) return;

    new_active = 1 +  7*( gpi->gpi_Mouse.Y / button_height )
                        + ( gpi->gpi_Mouse.X / button_width )  - start;

    if( (new_active > 0) && (new_active <= dsd->dsd_MaxMDay ) && (new_active != dsd->dsd_MDay) ) {
        dsd->dsd_OldMDay = dsd->dsd_MDay;
        dsd->dsd_MDay = new_active;
        DateSelectorGad_ButtonPushed( cl, gad, gpi->gpi_GInfo, dsd, GREDRAW_UPDATE );
    }
}

ULONG DateSelectorGad_SET( Class *cl, struct Gadget *gad, struct opSet *ops )
{
    struct  TagItem *tags, *tag;
    ULONG   retval;
    BOOL    Update = FALSE, Optimized = FALSE, DayChanged = FALSE;
    struct  DateSelectorData *dsd = INST_DATA(cl,(Object *)gad);

    retval = DoSuperMethodA(cl,(Object *)gad,(Msg *)ops);

    /*  If this is an INTERIM update message, we don't really care about it. */
    if( ops->MethodID == OM_UPDATE ) {
        if( ((struct opUpdate *)ops)->opu_Flags & OPUF_INTERIM ) return(0);
    }

    tags = ops->ops_AttrList;

    /* Year tag.    */
    if( tag = FindTagItem( DSG_YEAR, tags ) ) {
        if( (tag->ti_Data > 1977) && (tag->ti_Data < 2100) ) {
            dsd->dsd_Year = (UWORD)tag->ti_Data;
            Update = TRUE;
            if( dsd->dsd_Flags & DSD_FIXEDPOSITION ) Optimized = TRUE;
        }
        else retval = 1;
    }

    /*  Month tag.  */
    if( tag = FindTagItem( DSG_MONTH, tags ) ) {
        if( (tag->ti_Data > 0) && (tag->ti_Data < 13) ) {
            dsd->dsd_Month = (UWORD)tag->ti_Data;
            Update = TRUE;
            if( dsd->dsd_Flags & DSD_FIXEDPOSITION ) Optimized = TRUE;
        }
        else retval = 1;
    }

    dsd->dsd_MaxMDay = DSG_MaxNumberOfDays( dsd->dsd_Year, dsd->dsd_Month );

    /*  Day tag.    */
    if( tag = FindTagItem( DSG_DAY, tags) ) {
        /*  Check that new day isn't same as old one.   */
        if( (UWORD)tag->ti_Data != dsd->dsd_MDay ) {
            dsd->dsd_OldMDay = dsd->dsd_MDay;
            dsd->dsd_MDay = (UWORD)tag->ti_Data;
            DayChanged = TRUE;
        }
    }

    if( dsd->dsd_MDay > dsd->dsd_MaxMDay ) {
        dsd->dsd_MDay = dsd->dsd_MaxMDay;
        DayChanged = TRUE;
        retval = 1;
    }
    else if( dsd->dsd_MDay < 1 ) {
        dsd->dsd_MDay = 1;
        DayChanged = TRUE;
        retval = 1;
    }

    dsd->dsd_FirstMonthDay = DateSelectorGad_FirstMonthDay( dsd->dsd_Year, dsd->dsd_Month );

    /*  Check if we got GA_Disabled item. If we did then we just
    **  render whole gadget.
    */
    if( FindTagItem( GA_Disabled, tags ) ) {
        Update = TRUE;  Optimized = FALSE;
    }

    if( Update ) {
        /*  If we do optimized rendering we set flag to indicate this in dsd_RenderFlags.   */
        if( Optimized ) {
            /*  If Day was changed then we have to toggle buttons too.  */
            if( DayChanged ) {
                DateSelectorGad_ButtonPushed(cl,gad,ops->ops_GInfo,dsd,GREDRAW_UPDATE);
            }
            dsd->dsd_RenderFlags |= DSDR_OPTIMIZED_REFRESH;
        }

        /*  Well, actually button was not pushed but we could
        **  pretend it was.
        */
        DateSelectorGad_ButtonPushed(cl, gad, ops->ops_GInfo,dsd, GREDRAW_REDRAW);
    }
    else if( DayChanged ) {
        DateSelectorGad_ButtonPushed(cl,gad,ops->ops_GInfo,dsd,GREDRAW_UPDATE);
    }

    return(retval);
}

ULONG DateSelectorGad_GET( Class *cl, Object *o, struct opGet *opg)
{
    struct  DateSelectorData *dsd = INST_DATA(cl,o);
    ULONG   retval = TRUE;  /* We expect no errors. */

    if( opg->opg_AttrID == DSG_YEAR ) {
        *(opg->opg_Storage) = (ULONG)dsd->dsd_Year;
    }
    else if( opg->opg_AttrID == DSG_MONTH ) {
        *(opg->opg_Storage) = (ULONG)dsd->dsd_Month;
    }
    else if( opg->opg_AttrID == DSG_DAY ) {
        *(opg->opg_Storage) = (ULONG)dsd->dsd_MDay;
    }
    else retval = DoSuperMethodA( cl, o, (Msg *)opg );

    return( retval );
}

VOID DateSelectorGad_ButtonPushed(  Class *cl,
                                    struct Gadget *gad,
                                    struct GadgetInfo *gi,
                                    struct DateSelectorData *dsd,
                                    ULONG UpdateType )
{
    struct  RastPort *rp;
    struct  TagItem tags[5];

    /*  Make visual UPDATE renderings, by calling my own GM_RENDER method.  */
    rp = ObtainGIRPort( gi );
    if( rp ) {
        DoMethod((Object *)gad, GM_RENDER, gi, rp, UpdateType);
        ReleaseGIRPort(rp);
    }

    /*  Send notify message to our ICA_TARGET.  */
    tags[0].ti_Tag = GA_ID;
    tags[0].ti_Data = gad->GadgetID;
    tags[1].ti_Tag = DSG_DAY;
    tags[1].ti_Data = (ULONG)dsd->dsd_MDay;
    tags[2].ti_Tag = DSG_MONTH;
    tags[2].ti_Data = (ULONG)dsd->dsd_Month;
    tags[3].ti_Tag = DSG_YEAR;
    tags[3].ti_Data = (ULONG)dsd->dsd_Year;
    tags[4].ti_Tag = TAG_DONE;

    DoSuperMethod( cl, (Object *)gad, OM_NOTIFY, tags, gi, 0 );
}

UWORD DateSelectorGad_FirstMonthDay( UWORD year, UWORD month )
{
    struct  ClockData cd;
    ULONG   amigadate;

    cd.sec = cd.min = cd.hour = 1;
    cd.mday = 1;
    cd.month = month;
    cd.year = year;

    amigadate = CheckDate( &cd );
    Amiga2Date( amigadate, &cd );

    return( cd.wday );
}

VOID DateSelectorGad_DrawNumberBox( struct RastPort *rp, UWORD GadgetFlags, struct GadgetInfo *gi, struct Number *num,
                                    BOOL Selected, ULONG X, ULONG Y, ULONG W, ULONG H )
{
    USHORT patterndata[2];
    struct  DrawInfo *dri = gi->gi_DrInfo;
    UBYTE   Pen1, Pen2, Pen3, Pen4;

    if( Selected ) {
        Pen1 = dri->dri_Pens[SHADOWPEN];
        Pen2 = dri->dri_Pens[SHINEPEN];
        Pen3 = dri->dri_Pens[FILLTEXTPEN];
        Pen4 = dri->dri_Pens[FILLPEN];
    }
    else {
        Pen1 = dri->dri_Pens[SHINEPEN];
        Pen2 = dri->dri_Pens[SHADOWPEN];
        Pen3 = dri->dri_Pens[TEXTPEN];
        Pen4 = dri->dri_Pens[BACKGROUNDPEN];
    }

    /*  Clear the back. */
    SetAPen(rp,Pen4);
    RectFill(rp,X,Y,X+W-1,Y+H-1);

    SetAPen(rp, Pen1);
    Move(rp,X+W-2,Y);
    Draw(rp,X,Y);
    Draw(rp,X,Y+H-1);
    Move(rp,1+X,Y+H-2);
    Draw(rp,1+X,1+Y);

    SetAPen(rp, Pen2 );
    Move(rp,1+X,Y+H-1);
    Draw(rp,X+W-1,Y+H-1);
    Draw(rp,X+W-1,Y);
    Move(rp,X+W-2,1+Y);
    Draw(rp,X+W-2,Y+H-2);

    SetAPen(rp, Pen3);
    SetBPen(rp, Pen4);

    SetDrMd(rp,JAM2);
    Move(rp, X + (W - num->width)/2, Y + (H - rp->Font->tf_YSize)/2 + rp->Font->tf_Baseline);
    Text(rp, num->array, strlen(num->array));

    /*  If our gadget is DISABLED we have to rectfill this button with ghosted pattern. */
    if( GadgetFlags & GFLG_DISABLED ) {
        patterndata[0] = 0x2222; patterndata[1] = 0x8888;
        SetDrMd(rp,JAM1);
        SetAfPt(rp, patterndata, 1);
        RectFill(rp, 2+X, 1+Y, X+W-3, Y+H-2 );
        SetAfPt(rp, NULL, 0 );
    }
}

VOID __asm DSG_GetPositions(register __a0 struct DateSelectorData *dsd,
                            register __a1 ULONG *start,
                            register __a2 ULONG *end)
{
    if( dsd->dsd_Flags & DSD_FIXEDPOSITION ) {
        *start = 0;
    }
    else if( dsd->dsd_Flags & DSD_SUNDAYFIRST ) {
        *start = dsd->dsd_FirstMonthDay;
    }
    else {
        *start = (6 + dsd->dsd_FirstMonthDay) % 7;
    }
    *end = *start + dsd->dsd_MaxMDay;
}

VOID __asm DSG_CalcBoxCoords(   register __a0 struct Gadget *gad,
                                register __d0 ULONG pos,
                                register __a1 ULONG *X,
                                register __a2 ULONG *Y,
                                register __d1 ULONG W,
                                register __d2 ULONG H )
{
    *X = gad->LeftEdge + (pos % 7)*W;
    *Y = gad->TopEdge + (pos / 7)*H;
}

VOID DSG_mysprintf( UBYTE *buffer, UBYTE *Format, ... )
{
    RawDoFmt( Format, (APTR)(1 + (&Format)), DSG_stuffChar, (APTR)buffer);
}

VOID DSG_stuffChar()
{
    __emit(0x16c0); /*  Is same as ' move.b d0,(a3)+ ' in assembler. */
}

/*  Could be simpler method to do this, but I want to avoid any
**  static data.
*/
UWORD DSG_MaxNumberOfDays( UWORD Year, UWORD Month )
{
    UWORD val;

    switch( Month )
    {
        case 2:
            val = 28 + ((Year % 4) == 0);
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            val = 30;
            break;
        default:
            val = 31;
            break;
    }

    return(val);
}
