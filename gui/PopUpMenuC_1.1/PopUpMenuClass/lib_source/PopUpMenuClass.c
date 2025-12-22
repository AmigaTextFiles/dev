/** ** *** MakeRev Header *** **
**
**  ** PopUpMenu Gadget Class - BOOPSI gadget class. **
**
**  Copyright © 1993 Markus Aalto
**
**  Creation date: 09-Dec-93
**
**  ------------------------------------------------------------------
**  $Filename: PopUpMenuClass.c $
**  $Revision: 1.1 $
**  $Date: 29-Dec-93 $
**
**  $Author: Markus_Aalto $
**  $Comment: Freely distributable. $
**
*/

/* Make sure everything is added from PopUpMenuClass.h */
#define POPUPMENUCLASS_PRIVATE  1

#include    "PopUpMenuClass.h"
#include    <string.h>
#include    <math.h>

/* Version. */
static UBYTE popupmenuclass_version[] = "$VER: PopUpMenuClass 1.1 (29.12.93)";

/* STATIC Protos for real Method functions and for class dispatcher. */
static ULONG    __saveds __asm PUMG_Dispatcher( register __a0 Class *cl,
                                                register __a2 Object *o,
                                                register __a1 Msg msg);

static ULONG    PUMG_NEW( Class *cl,
                          Object *o,
                          struct opSet *ops );

static ULONG    PUMG_DISPOSE( Class *cl,
                              Object *o,
                              Msg msg );

static ULONG    PUMG_SET( Class *cl,
                          Object *o,
                          struct opSet *ops );

static ULONG    PUMG_GET( Class *cl,
                          Object *o,
                          struct opGet *opg );

static ULONG    PUMG_UPDATE( Class *cl,
                             Object *o,
                             struct opUpdate *opu );

static ULONG    PUMG_NOTIFY( Class *cl,
                             Object *o,
                             struct opUpdate *opu );

static ULONG    PUMG_RENDER( Class *cl,
                             Object *o,
                             struct gpRender *gpr );

static ULONG    PUMG_GOACTIVE( Class *cl,
                               Object *o,
                               struct gpInput *gpi );

static ULONG    PUMG_HANDLEINPUT( Class *cl,
                                  Object *o,
                                  struct gpInput *gpi );

static ULONG    PUMG_GOINACTIVE( Class *cl,
                                 Object *o,
                                 struct gpGoInactive *gpgi );

/* Protos for static help functions. */

static void     PUMG_MakeCheckings( PUMGData *PD );

static void     PUMG_GetGadgetRect( Object *o,
                                    struct GadgetInfo *gi,
                                    struct Rectangle *rect );

static void     PUMG_DrawPopupWindow( PUMGData *PD,
                                      struct DrawInfo *dri,
                                      ULONG From,
                                      LONG Count );

static void     PUMG_DrawFrame( struct Window *win,
                                int order,
                                struct DrawInfo *dri,
                                UBYTE *name,
                                struct TextFont *tf,
                                BOOL Active,
                                BOOL NewLook,
                                ULONG ItemHeight );

static void     PUMG_DrawPopupMenuImage( struct RastPort *RP,
                                         ULONG Pen1,
                                         ULONG Pen2,
                                         ULONG Left,
                                         ULONG Top,
                                         LONG Height );

/*******************************************************************/
/*******************************************************************/
/* The real code starts here.                                      */
/*******************************************************************/
/*******************************************************************/

/* Global Create PopUpMenuClass function. */

Class *CreatePopUpMenuClass()
{
    Class *cl;

    cl = MakeClass( NULL, GADGETCLASS, NULL, sizeof(PUMGData), 0);
    if( cl ) {
        cl->cl_Dispatcher.h_Entry = (HookFunction)PUMG_Dispatcher;
    }

    return( cl );
}

/* Global Free PopUpMenuClass function. */
BOOL DisposePopUpMenuClass( Class * cl )
{
    return( FreeClass( cl ) ) ;
}


/*******************************************************************/
/*******************************************************************/
/* PopUpMenu specific class code.                                  */
/*******************************************************************/
/*******************************************************************/

static ULONG __saveds __asm PUMG_Dispatcher( register __a0 Class *cl,
                                             register __a2 Object *o,
                                             register __a1 Msg msg)
{
    ULONG retval;

    switch( msg->MethodID )
    {
    case OM_NEW:
        retval = PUMG_NEW(cl, o, (struct opSet *)msg );
        break;
    case OM_DISPOSE:
        retval = PUMG_DISPOSE( cl, o, msg );
        break;
    case OM_SET:
        retval = PUMG_SET(cl, o, (struct opSet *)msg );
        break;
    case OM_GET:
        retval = PUMG_GET( cl, o, (struct opGet *)msg );
        break;
    case OM_UPDATE:
        retval = PUMG_UPDATE( cl, o, (struct opUpdate *)msg );
        break;
    case OM_NOTIFY:
        retval = PUMG_NOTIFY( cl, o, (struct opUpdate *)msg );
        break;
    case GM_RENDER:
        retval = PUMG_RENDER( cl, o, (struct gpRender *)msg );
        break;
    case GM_GOACTIVE:
        retval = PUMG_GOACTIVE( cl, o, (struct gpInput *)msg );
        break;
    case GM_HANDLEINPUT:
        retval = PUMG_HANDLEINPUT( cl, o, (struct gpInput *)msg );
        break;
    case GM_GOINACTIVE:
        retval = PUMG_GOINACTIVE( cl, o, (struct gpGoInactive *)msg );
        break;
    default:
        retval = DoSuperMethodA(cl, o, msg);
        break;
    }


    return(retval);
}

static ULONG PUMG_NEW( Class *cl,
                       Object *o,
                       struct opSet *ops )
{
    Object *object;
    PUMGData *PD;

    object = (Object *)DoSuperMethodA( cl, o, (Msg)ops );
    if( object ) {
        PD = INST_DATA( cl, object );

        PD->Labels = (struct List *)GetTagData( PUMG_Labels, NULL, ops->ops_AttrList );
        PD->Active = GetTagData( PUMG_Active, 0, ops->ops_AttrList );
        PD->NewLook = (BOOL)GetTagData( PUMG_NewLook, FALSE, ops->ops_AttrList);

        PUMG_MakeCheckings( PD );

        PD->Font = (struct TextFont *)GetTagData( PUMG_TextFont, NULL,
            ops->ops_AttrList);

        PD->FrameImage = (struct Image *)NewObject(NULL,"frameiclass",
                IA_Recessed,    FALSE,
                IA_EdgesOnly,   FALSE,
                IA_FrameType,   FRAME_BUTTON,
                TAG_END);
        if( PD->FrameImage == NULL ) {
            CoerceMethod(cl, o, OM_DISPOSE);
            object = NULL;
        }
    }

    return( (ULONG)object );
}


static ULONG PUMG_DISPOSE( Class *cl,
                           Object *o,
                           Msg msg )
{
    PUMGData *PD = INST_DATA( cl, o );

    if( PD->popup_window ) {
        CloseWindow( PD->popup_window );
    }

    if( PD->FrameImage ) DisposeObject( PD->FrameImage );

    return( DoSuperMethodA(cl, o, msg) );
}


static ULONG PUMG_SET( Class *cl,
                       Object *o,
                       struct opSet *ops )
{
    ULONG retval;
    PUMGData *PD = INST_DATA( cl, o );
    struct TagItem *tag, notify;
    UWORD old_active;

    retval = DoSuperMethodA( cl, o, (Msg)ops );

    /* I decided that it would be best that the values which are
    ** specific to this class, could bot be changed when we have
    ** our PopUpMenu window opened. */
    if( (ops->ops_AttrList != NULL) && (PD->popup_window == NULL) ) {
        tag = FindTagItem( PUMG_Labels, ops->ops_AttrList );
        if( tag ) {
            PD->Labels = (struct List *)tag->ti_Data;
            retval = TRUE;
        }

        old_active = PD->Active;

        tag = FindTagItem( PUMG_Active, ops->ops_AttrList );
        if( tag ) {
            PD->Active = tag->ti_Data;
            retval = TRUE;
        }

        PUMG_MakeCheckings( PD );

        tag = FindTagItem( PUMG_TextFont, ops->ops_AttrList );
        if( tag ) {
            PD->Font = (struct TextFont *)tag->ti_Data;
            retval = TRUE;
        }

        if( old_active != PD->Active ) {
            /* We send ourselves a OM_NOTIFY message, which will
            ** eventually be broadcasted as OM_UPDATE message
            ** to the target object. Note that we don't send it
            ** simply to our parent, but to ourselves, so if
            ** we have a children which needs to add it's own
            ** data it will be added. */
            PUMG_SetTagArg( notify, TAG_END, NULL );
            (VOID)DoMethod( o, OM_NOTIFY, &notify, ops->ops_GInfo, 0 );
        }
    }

    return( retval );
}

static ULONG PUMG_GET( Class *cl,
                       Object *o,
                       struct opGet *opg )
{
    ULONG retval;
    PUMGData *PD = INST_DATA( cl, o );

    switch( opg->opg_AttrID )
    {
    case PUMG_Labels:
        *opg->opg_Storage = (ULONG)PD->Labels;
        retval = TRUE;
        break;
    case PUMG_Active:
        *opg->opg_Storage = (ULONG)PD->Active;
        retval = TRUE;
        break;
    case PUMG_TextFont:
        *opg->opg_Storage = (ULONG)PD->Font;
        retval = TRUE;
        break;
    case PUMG_NewLook:
        *opg->opg_Storage = (ULONG)PD->NewLook;
        retval = TRUE;
        break;
    default:
        retval = DoSuperMethodA(cl, o, (Msg)opg);
        break;
    }

    return( retval );
}


static ULONG PUMG_UPDATE( Class *cl,
                          Object *o,
                          struct opUpdate *opu )
{
    ULONG retval;
    PUMGData *PD = INST_DATA( cl, o );
    struct TagItem *tag, notify;
    struct RastPort *rp;

    retval = DoSuperMethodA(cl, o, opu);

    /* Update only if gadget isn't currently manipulated. */
    if( PD->popup_window == NULL ) {
        if( opu->opu_AttrList ) {
            tag = FindTagItem( PUMG_Active, opu->opu_AttrList );
            if( tag ) {
                if( tag->ti_Data != PD->Active ) {
                    PD->Active = tag->ti_Data;

                    PUMG_MakeCheckings( PD );

                    rp = ObtainGIRPort( opu->opu_GInfo );
                    if( rp ) {
                        DoMethod( o, GM_RENDER, opu->opu_GInfo, rp, GREDRAW_UPDATE );
                        ReleaseGIRPort( rp );
                    }

                    /* Notify the change. */
                    PUMG_SetTagArg( notify, TAG_END, NULL );
                    (void)DoMethod( o, OM_NOTIFY, &notify, opu->opu_GInfo, 0 );
                }
            }
        }
    }

    return( retval );
}


static ULONG PUMG_NOTIFY( Class *cl,
                          Object *o,
                          struct opUpdate *opu )
{
    struct TagItem tags[3];
    PUMGData *PD = INST_DATA( cl, o );

    PUMG_SetTagArg(tags[0], GA_ID, ((struct Gadget *)o)->GadgetID);
    PUMG_SetTagArg(tags[1], PUMG_Active, PD->Active );

    /* If there are no previous tags in OM_NOTIFY message, we
    ** add them there as only ones. Otherwise we tag previous
    ** tags to the end of our tags. Got it? :')
    */
    if( opu->opu_AttrList == NULL ) {
        PUMG_SetTagArg(tags[2], TAG_END, NULL);
    }
    else PUMG_SetTagArg(tags[2], TAG_MORE, opu->opu_AttrList );

    return( DoSuperMethod(cl, o, OM_NOTIFY, tags, opu->opu_GInfo, opu->opu_Flags) );
}

static ULONG PUMG_RENDER( Class *cl,
                          Object *o,
                          struct gpRender *gpr )
{
    ULONG retval, State;
    struct Gadget *gad = (struct Gadget *)o;
    struct Rectangle rect;
    struct DrawInfo *dri;
    struct IBox container;
    struct Node *node;
    struct TextExtent temp_te;
    struct RastPort *RP = gpr->gpr_RPort;
    UWORD BorderWidth, BorderHeight, TextWidth;
    UWORD patterndata[2] = { 0x2222, 0x8888 };
    ULONG TextPen, ImagePen1, ImagePen2;
    PUMGData *PD = INST_DATA( cl, o );

    retval = DoSuperMethodA(cl, o, gpr);

    /* Get real Min and Max positions. */
    PUMG_GetGadgetRect( o, gpr->gpr_GInfo, &rect );

    /* Calculate real dimensions. */
    container.Left = rect.MinX; container.Top = rect.MinY;
    container.Width = 1 + rect.MaxX - rect.MinX;
    container.Height = 1 + rect.MaxY - rect.MinY;

    dri = gpr->gpr_GInfo->gi_DrInfo;

    if( gad->Flags & GFLG_DISABLED ) {
        State = IDS_DISABLED;
    }
    else if( gad->Flags & GFLG_SELECTED ) {
        State = IDS_SELECTED;
    }
    else State = IDS_NORMAL;

    /* Frame rendering goes here. */
    SetAttrs( PD->FrameImage,
            IA_Left,    container.Left,
            IA_Top,     container.Top,
            IA_Width,   container.Width,
            IA_Height,  container.Height,
            TAG_END);

    DrawImageState( RP, PD->FrameImage, 0, 0, State, dri);

    if( dri ) {
        TextPen = dri->dri_Pens[TEXTPEN];
        ImagePen1 = dri->dri_Pens[SHINEPEN];
        ImagePen2 = dri->dri_Pens[SHADOWPEN];
    }
    else { /* If for some unknown reason Drawinfo is NULL then we
           ** Use these predefined values, which should work atleast
           ** for current OS releases. */
        TextPen = ImagePen2 = 1;
        ImagePen1 = 2;
    }

    /* Draw the PopupMenu Image. */
    PUMG_DrawPopupMenuImage( RP, ImagePen1, ImagePen2,
        5LU + container.Left, 2LU + container.Top, -5L + container.Height);

    /*******************************/
    /* Text rendering starts here. */
    /*******************************/

    /* Do we have a proper font. */
    if( PD->Font == NULL ) {
        /* If not we use the font we have in RastPort. */
        PD->Font = RP->Font;
    }
    else SetFont( RP, PD->Font );

    /* Check if we have nothing to print. */
    if( PD->Count > 0 ) {
        ULONG len, i = 0;
        char *label_name;

        node = PD->Labels->lh_Head;
        while( node->ln_Succ ) {
            if( i == PD->Active ) {
                label_name = node->ln_Name;
                if( label_name ) {
                    len = TextFit( RP, label_name, (ULONG)strlen(label_name),
                        &temp_te, NULL, 1, (ULONG)container.Width - 28,
                        1LU + PD->Font->tf_YSize);

                    TextWidth = 1 + temp_te.te_Extent.MaxX - temp_te.te_Extent.MinX;

                    SetAPen(RP, TextPen);
                    Move( RP, 10L + container.Left + (container.Width - TextWidth)/2
                        - temp_te.te_Extent.MinX, (LONG)
                        PD->Font->tf_Baseline + (1 + container.Top + rect.MaxY
                        - PD->Font->tf_YSize)/2 );

                    Text( RP, label_name, len );
                }

                /* End the drawing. */
                break;
            }
            else {
                i++;
                node = node->ln_Succ;
            }
        }
    }

    /* Disabled pattern rendering is here. */
    if( State == IDS_DISABLED ) {
        BorderHeight = 1;
        BorderWidth = (IntuitionBase->LibNode.lib_Version < 39) ? 1 : 2;

        container.Left += BorderWidth;
        container.Top += BorderHeight;
        container.Width = max( 1, container.Width - 2*BorderWidth );
        container.Height = max( 1, container.Height - 2*BorderHeight );

        SetDrMd(RP,JAM1);
        SetAfPt(RP, patterndata, 1);

        RectFill(RP,  (LONG)container.Left, (LONG)container.Top,
                -1L + container.Left + container.Width,
                -1L + container.Top + container.Height );

        SetAfPt(RP, NULL, 0 );
    }

    /* Copy current Rectangle. */
    PD->rect = rect;

    return( retval );
}


static ULONG PUMG_GOACTIVE( Class *cl,
                            Object *o,
                            struct gpInput *gpi )
{
    ULONG retval = GMR_MEACTIVE, Left, Top;
    struct RastPort *rp;
    PUMGData *PD = INST_DATA( cl, o );
    struct GadgetInfo *gi = gpi->gpi_GInfo;
    struct Gadget *gad = (struct Gadget *)o;

    /* Test if we are disabled. */
    if( gad->Flags & GFLG_DISABLED ) return( GMR_NOREUSE );

    /* Call first our parent class. */
    (void)DoSuperMethodA(cl, o, gpi);

    /* Chech whether we were activated from mouse or keyboard. */
    PD->ActiveFromMouse = (gpi->gpi_IEvent != NULL);

    /* Select this gadget. */
    gad->Flags |= GFLG_SELECTED;

    /* We make sure that NewLook isn't active if DrawInfo version
    ** isn't high enough. Since V39 DrawInfo version >= 2!! */
    if( PD->NewLook ) {
        if( gi->gi_DrInfo && (gi->gi_DrInfo->dri_Version < 2)) {
            PD->NewLook = FALSE;
        }
    }

    rp = ObtainGIRPort( gi );
    if( rp ) {
        /* Render ourselves as selected gadget. */
        DoMethod( o, GM_RENDER, gi, rp, GREDRAW_UPDATE );
        ReleaseGIRPort( rp );

        /* Get the domain top/left position. */
        Left = gi->gi_Domain.Left;
        Top = gi->gi_Domain.Top;

        /* If this is window, we have to add window Left/Top values too. */
        if( gi->gi_Window ) {
            Left += gi->gi_Window->LeftEdge;
            Top += gi->gi_Window->TopEdge;
        }

        /* If NewLook is ON, then size of one item is smaller. */
        PD->ItemHeight = PD->Font->tf_YSize + (PD->NewLook ? 1 : 5);

        /* Count how many items fits to menu. */
        PD->FitsItems = (gi->gi_Screen->Height - 4) / PD->ItemHeight;
        if( PD->FitsItems > PD->Count ) {
            PD->FitsItems = PD->Count;
        }

        PD->popup_window = OpenWindowTags(NULL,
            WA_Left,            Left + PD->rect.MinX,
            WA_Top,             Top + PD->rect.MaxY,
            WA_Width,           1 + PD->rect.MaxX - PD->rect.MinX,
            WA_Height,          4 + PD->FitsItems*PD->ItemHeight,
            WA_Activate,        FALSE,
            WA_CustomScreen,    gi->gi_Screen,
            WA_SizeGadget,      FALSE,
            WA_DragBar,         FALSE,
            WA_DepthGadget,     FALSE,
            WA_CloseGadget,     FALSE,
            WA_Borderless,      TRUE,
            WA_Flags,           0,
            WA_AutoAdjust,      TRUE,
            WA_RMBTrap,         TRUE,
            WA_SimpleRefresh,   TRUE,
            WA_NoCareRefresh,   TRUE,
            TAG_END );

        if( PD->popup_window == NULL ) {
            retval = GMR_NOREUSE;
        }
        else {
            /* We make sure Active item isn't too large to display. */
            if( PD->FitsItems < PD->Active ) PD->Active = PD->FitsItems-1;

            /* If activated from keyboard we can set temporary value
            ** to currently activated item. Otherwise we set it
            ** to -1 which means that there is no active item. */
            PD->Temp_Active = PD->ActiveFromMouse ? (ULONG)~0 : PD->Active;

            /* Render all items. */
            PUMG_DrawPopupWindow( PD, gi->gi_DrInfo, 0, -1);
        }
    }
    else retval = GMR_NOREUSE;

    return(retval);
}

static ULONG PUMG_HANDLEINPUT( Class *cl,
                               Object *o,
                               struct gpInput *gpi )
{
    ULONG retval = GMR_MEACTIVE;
    struct InputEvent *ie = gpi->gpi_IEvent;
    PUMGData *PD = INST_DATA(cl, o);
    WORD X, Y;
    WORD count, old_active;
    struct GadgetInfo *gi = gpi->gpi_GInfo;
    struct TagItem tags;    /* If our possible child class, doesn't know
                            ** how to handle NULL AttrList ptr, then
                            ** this can save lots of crashes. */

    /* If there is anykind of AutoPoint program then our main window
    ** might get inactive and we wouldn't get any more messages.
    ** So we check out that we are active and deactivate ourselves
    ** if our window isn't active anymore. */
    if( gi->gi_Window ) {
        if( (gi->gi_Window->Flags & WFLG_WINDOWACTIVE) == 0 ) {
            return( GMR_NOREUSE );
        }
    }

    if( PD->ActiveFromMouse ) {
        X = PD->popup_window->MouseX;
        Y = PD->popup_window->MouseY;

        count = ( (Y - 2) >= 0 ) ? (Y - 2) / (PD->ItemHeight) : ~0;

        old_active = PD->Temp_Active;

        if( (X > 2) && (X < (PD->popup_window->Width - 2))
                && (count >= 0) && (count < PD->FitsItems) ) {
            PD->Temp_Active = (UWORD)count;
        }
        else PD->Temp_Active = (UWORD)~0;

        if( old_active != (WORD)PD->Temp_Active ) {
            PUMG_DrawPopupWindow( PD, gi->gi_DrInfo,(ULONG)PD->Temp_Active, 1 );
            PUMG_DrawPopupWindow( PD, gi->gi_DrInfo,(ULONG)old_active, 1 );
        }

        while( ie && (retval == GMR_MEACTIVE) ) {
            if( ie->ie_Class == IECLASS_RAWMOUSE ) {
                if( ie->ie_Code == SELECTUP ) {
                    retval = GMR_NOREUSE;

                    if( (PD->Temp_Active != (UWORD)~0) ) {
                        PD->Active = PD->Temp_Active;
                        PUMG_MakeCheckings( PD );

                        PUMG_SetTagArg(tags, TAG_END, NULL);
                        (VOID)DoMethod( o, OM_NOTIFY, &tags, gi, 0);

                        retval |= GMR_VERIFY;
                        *gpi->gpi_Termination = (ULONG)PD->Active;
                    }
                }
            }

            ie = ie->ie_NextEvent;
        }
    }
    else {
        while( ie && (retval == GMR_MEACTIVE) ) {
            switch( ie->ie_Class )
            {
            case IECLASS_RAWMOUSE:
                if( ie->ie_Code != IECODE_NOBUTTON ) {
                    retval = GMR_REUSE; /* Reuse the InputEvent. */
                }
                break;
            case IECLASS_RAWKEY:
                old_active = PD->Temp_Active;
                switch( ie->ie_Code )
                {
                case CURSORDOWN:
                    if( ie->ie_Qualifier & (ALTLEFT|ALTRIGHT) ) {
                        PD->Temp_Active = PD->FitsItems-1;  /* Jump to end. */
                    }
                    else if( PD->Temp_Active < (PD->FitsItems-1) ) {
                        PD->Temp_Active += 1;
                    }
                    break;
                case CURSORUP:
                    if( ie->ie_Qualifier & (ALTLEFT|ALTRIGHT) ) {
                        PD->Temp_Active = 0;    /* Jump to start. */
                    }
                    else if( PD->Temp_Active > 0 ) {
                        PD->Temp_Active -= 1;
                    }
                    break;
                case 0x45:  /* ESC key. */
                    retval = GMR_NOREUSE;
                    break;
                case 0x44:  /* RETURN key. */
                    PD->Active = PD->Temp_Active;
                    PUMG_MakeCheckings( PD );

                    PUMG_SetTagArg(tags, TAG_END, NULL);
                    (VOID)DoMethod( o, OM_NOTIFY, &tags, gi, 0);

                    retval = GMR_NOREUSE|GMR_VERIFY;
                    *gpi->gpi_Termination = (ULONG)PD->Active;
                    break;
                }

                /* Update the popupwindow items, if changes were made. */
                if( old_active != PD->Temp_Active ) {
                    PUMG_DrawPopupWindow( PD, gi->gi_DrInfo,
                        (ULONG)PD->Temp_Active, 1 );
                    PUMG_DrawPopupWindow( PD, gi->gi_DrInfo,
                        (ULONG)old_active, 1 );
                }
            }

            ie = ie->ie_NextEvent;
        }
    }

    return(retval);
}


static ULONG PUMG_GOINACTIVE( Class *cl,
                              Object *o,
                              struct gpGoInactive *gpgi )
{
    ULONG retval;
    struct RastPort *rp;
    PUMGData *PD = INST_DATA(cl, o);

    retval = DoSuperMethodA(cl, o, gpgi);

    ((struct Gadget *)o)->Flags &= ~GFLG_SELECTED;

    rp = ObtainGIRPort( gpgi->gpgi_GInfo );
    if( rp ) {
        DoMethod( o, GM_RENDER, gpgi->gpgi_GInfo, rp, GREDRAW_UPDATE );
        ReleaseGIRPort( rp );
    }

    if( PD->popup_window ) {
        CloseWindow(PD->popup_window);
        PD->popup_window = NULL;
    }

    return(retval);
}

/* Static functions for help with real Method functions. */

static void PUMG_MakeCheckings( PUMGData *PD )
{
    struct Node *node;

    PD->Count = 0;

    if( PD->Labels == NULL ) {
        PD->Active = 0;
    }
    else if( PD->Labels != (struct List *)~0 ) {
        node = (struct Node *)PD->Labels->lh_Head;
        while( node->ln_Succ ) {
            PD->Count += 1;
            node = node->ln_Succ;
        }

        if( PD->Active >= PD->Count ) {
            PD->Active = PD->Count + (PD->Count == 0) - 1;
        }
    }
}

static void PUMG_GetGadgetRect( Object *o,
                                struct GadgetInfo *gi,
                                struct Rectangle *rect )
{
    struct Gadget *gad = (struct Gadget *)o;
    LONG W, H;

    rect->MinX = gad->LeftEdge;
    rect->MinY = gad->TopEdge;
    W = gad->Width;
    H = gad->Height;

    if( gi ) {
        if( gad->Flags & GFLG_RELRIGHT ) rect->MinX += gi->gi_Domain.Width - 1;
        if( gad->Flags & GFLG_RELBOTTOM ) rect->MinY += gi->gi_Domain.Height - 1;
        if( gad->Flags & GFLG_RELWIDTH ) W += gi->gi_Domain.Width;
        if( gad->Flags & GFLG_RELHEIGHT ) H += gi->gi_Domain.Height;
    }

    rect->MaxX = rect->MinX + W - (W > 0);
    rect->MaxY = rect->MinY + H - (H > 0);
}

static void PUMG_DrawPopupWindow( PUMGData *PD,
                                  struct DrawInfo *dri,
                                  ULONG From, LONG Count)
{
    int i, End;
    struct Node *node;
    struct Window *win = PD->popup_window;
    struct RastPort *RP = win->RPort;

    if( PD->Count && dri ) {
        /* If we want to draw all entries then we draw
        ** window borders too. */
        if( Count == -1) {
            Count = PD->FitsItems;

            if( PD->NewLook ) {
                /* Set background to MENU background color. */
                SetRast( RP, (ULONG)dri->dri_Pens[BARBLOCKPEN] );

                SetAPen( RP, (ULONG)dri->dri_Pens[BARDETAILPEN] );
                Move( RP, 0, -1L + win->Height );
                Draw( RP, 0, 0 );
                Draw( RP, -1L + win->Width, 0 );
                Draw( RP, -1L + win->Width, -1L + win->Height);
                Draw( RP, 1, -1L + win->Height);
                Draw( RP, 1, 1);
                Move( RP, -2L + win->Width, 1 );
                Draw( RP, -2L + win->Width, -2L + win->Height);
            }
            else {
                SetAPen( RP, (ULONG)dri->dri_Pens[SHINEPEN]);
                Move( RP, 0, -1L + win->Height);
                Draw( RP, 0, 0 );
                Draw( RP, -1L + win->Width, 0 );
                SetAPen( RP, (ULONG)dri->dri_Pens[SHADOWPEN]);
                Draw( RP, -1L + win->Width, -1L + win->Height);
                Draw( RP, 1, -1L + win->Height);
            }
        }

        SetFont( RP, PD->Font );
        SetDrMd( RP, JAM1);

        node = PD->Labels->lh_Head;

        for( i = 0, End = From + Count; node->ln_Succ ; i++ ) {
            if( i < PD->FitsItems ) {
                if( (i >= From) && ( i < End ) ) {
                    PUMG_DrawFrame( PD->popup_window, i, dri, node->ln_Name,
                        PD->Font, (BOOL)(i == PD->Temp_Active),
                        PD->NewLook, (ULONG)PD->ItemHeight );
                }
                else if( i >= End ) return;
            }

            node = node->ln_Succ;
        }
    }
}

static void PUMG_DrawFrame( struct Window *win,
                            int order,
                            struct DrawInfo *dri,
                            UBYTE *name,
                            struct TextFont *tf,
                            BOOL Active,
                            BOOL NewLook,
                            ULONG ItemHeight )
{
    ULONG   Pen1, Pen2, TextPen, BPen;
    ULONG   Top, Width, Bottom, MaxX,
            Len, TextWidth,
            font_height = tf->tf_YSize;
    struct  RastPort *RP = win->RPort;
    struct  TextExtent temp_te;

    TextPen = dri->dri_Pens[TEXTPEN];

    if( Active ) {
        if( NewLook ) {
            BPen = dri->dri_Pens[BARDETAILPEN];
            TextPen = dri->dri_Pens[BARBLOCKPEN];   /* Override previous value. */
        }
        else {
            Pen2 = dri->dri_Pens[SHINEPEN];
            Pen1 = dri->dri_Pens[SHADOWPEN];
            BPen = dri->dri_Pens[FILLPEN];
        }
    }
    else {
        if( NewLook ) {
            BPen = dri->dri_Pens[BARBLOCKPEN];
            TextPen = dri->dri_Pens[BARDETAILPEN];  /* Override previous value. */
        }
        else {
            Pen2 = dri->dri_Pens[SHADOWPEN];
            Pen1 = dri->dri_Pens[SHINEPEN];
            BPen = dri->dri_Pens[BACKGROUNDPEN];
        }
    }

    Top = 2 + order * ItemHeight;
    Bottom = Top + ItemHeight - 1;
    MaxX = win->Width - 4;

    SetAPen( RP, BPen );
    RectFill( RP, 4, Top, MaxX - 1, Bottom );

    if( NewLook == FALSE ) {    /* Draw Recessed Border. */
        SetAPen( RP, Pen1);
        Move( RP, 3, Bottom);
        Draw( RP, 3, Top );
        Draw( RP, MaxX, Top );
        SetAPen( RP, Pen2);
        Draw( RP, MaxX, Bottom );
        Draw( RP, 4, Bottom );
    }

    SetAPen( RP, TextPen);

    Width = win->Width - 10;

    Len = TextFit( RP, name, (ULONG)strlen(name), &temp_te, NULL, 1,
        Width, 1 + font_height);

    TextWidth = temp_te.te_Extent.MaxX - temp_te.te_Extent.MinX;

    Move( RP, 5 + (Width - TextWidth)/2 - temp_te.te_Extent.MinX,
        (ItemHeight - font_height)/2 + 1 + Top + tf->tf_Baseline );
    Text( RP, name, Len );
}

static void PUMG_DrawPopupMenuImage( struct RastPort *RP,
                                     ULONG Pen1,
                                     ULONG Pen2,
                                     ULONG Left,
                                     ULONG Top,
                                     LONG Height )
{
    ULONG count, i;

    if( Height > 0 ) {
        SetAPen( RP, Pen1 );
        Move(RP, Left, Top + Height - 1 );
        Draw(RP, Left, Top );

        count = (Height-1) / 4;
        for( i = 0; i <= count; i++ ) {
            Move(RP, Left, Top + i*4);
            Draw(RP, 10 + Left, Top + i*4);
        }

        /* Draw other horizontal bar. */
        Move( RP, 16 + Left, Top);
        Draw( RP, 16 + Left, Top + Height);


        SetAPen( RP, Pen2 );
        Move(RP, 1 + Left, Top + Height - 1);
        Draw(RP, 11 + Left, Top + Height - 1);
        Draw(RP, 11 + Left, Top);

        if( Height >= 4 ) {
            count = (Height-4) / 4;
            for( i = 0; i <= count; i++ ) {
                Move(RP, 1 + Left, 3 + Top + i*4);
                Draw(RP, 11 + Left, 3 + Top + i*4);
            }
        }

        /* Draw other horizontal bar. */
        Move( RP, 15 + Left, Top);
        Draw( RP, 15 + Left, Top + Height );
    }
}

