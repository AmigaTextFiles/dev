/** ** *** MakeRev Header *** **
**
**  ** Example - PopUpMenuClass example. **
**
**  Copyright © 1993 Markus Aalto
**
**  Creation date: 18-Dec-93
**
**  ------------------------------------------------------------------
**  $Filename: Example.c $
**  $Revision: 1.1 $
**  $Date: 28-Dec-93 $
**
**  $Author: Markus Aalto $
**  $Comment: Very simple example just to show use of PopUpMenuClass. $
**
*/


#include <BoopsiObjects/PopUpMenuClass.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void DoAll( void );
void HandleIDCMP( struct Gadget *gad );

#define PUMG_GADGET_ID  1

long __oslibversion = 37;

Class *PopUpMenuClass;
struct Screen *scr;
struct Window *win;
struct DrawInfo *dri;

UBYTE *names[] = {
    "PopUpMenuClass",
    "Copyright",
    "(c) 1993",
    "Markus Aalto",
    "",
    "Freely",
    "Distributable",
    "Software",
    "",
    "For more info",
    "Write to:",
    "s37732v@vipunen.hut.fi",
    NULL
};

int main( int argc, char **argv )
{
    UWORD Height;

    if( PopUpMenuClass = CreatePopUpMenuClass() ) {
        if( scr = LockPubScreen( NULL ) ) {
            if( dri = GetScreenDrawInfo( scr ) ) {
                Height = 11 + scr->WBorTop + 2*dri->dri_Font->tf_YSize
                         + INTERHEIGHT;

                win = OpenWindowTags(NULL,
                    WA_Left,            0,
                    WA_Top,             scr->BarHeight,
                    WA_Height,          Height,
                    WA_Width,           scr->WBorRight + scr->WBorLeft + PUMG_MinWidth + 100,
                    WA_IDCMP,           IDCMP_CLOSEWINDOW|IDCMP_GADGETUP|IDCMP_REFRESHWINDOW|IDCMP_VANILLAKEY,
                    WA_SizeGadget,      TRUE,
                    WA_CloseGadget,     TRUE,
                    WA_DragBar,         TRUE,
                    WA_Title,           "Example for PopUpMenuClass",
                    WA_PubScreen,       scr,
                    WA_MinWidth,        scr->WBorRight + scr->WBorLeft + PUMG_MinWidth,
                    WA_MinHeight,       Height,
                    WA_MaxWidth,        ~0,
                    WA_MaxHeight,       ~0,
                    WA_SizeBBottom,     TRUE,
                    WA_DepthGadget,     TRUE,
                    WA_Activate,        TRUE,
                    WA_SimpleRefresh,   TRUE,
                    TAG_END );

                if( win ) {
                    DoAll();

                    CloseWindow( win );
                }

                FreeScreenDrawInfo( scr, dri );
            }
        }

        DisposePopUpMenuClass( PopUpMenuClass );
    }
}

void DoAll()
{
    struct Node *node;
    struct List labels;
    UBYTE **strings = names;
    BOOL OK = TRUE;
    struct Gadget *gad;
    ULONG Height;

    NewList( &labels );

    while( *strings ) {
        node = (struct Node *)AllocVec( sizeof(struct Node), MEMF_ANY|MEMF_CLEAR );
        if( node ) {
            node->ln_Name = *strings;
            AddTail( &labels, node );
        }
        else {
            OK = FALSE;
            break;
        }

        strings++;
    }

    if( OK ) {
        Height = max(dri->dri_Font->tf_YSize + INTERHEIGHT, PUMG_MinHeight );

        gad = (struct Gadget *)NewObject(PopUpMenuClass, NULL,
            GA_Left,            win->BorderLeft,
            GA_RelBottom,       1 - win->BorderBottom - Height,
            GA_Height,          Height,
            GA_RelWidth,        -win->BorderLeft - win->BorderRight,
            GA_RelVerify,       TRUE,
            GA_ID,              PUMG_GADGET_ID,
            PUMG_Labels,        &labels,
            PUMG_TextFont,      dri->dri_Font,
            PUMG_NewLook,       TRUE,
            TAG_END);

        if( gad ) {
            AddGadget( win, gad, -1);
            RefreshGList( gad, win, NULL, 1 );

            HandleIDCMP( gad );

            RemoveGadget( win, gad );
        }

        DisposeObject( (Object *)gad );
    }

    while( node = RemHead( &labels ) ) {
        FreeVec( (void *)node );
    }
}

void HandleIDCMP( struct Gadget *gad )
{
    ULONG   signalmask = (1 << win->UserPort->mp_SigBit) |\
                         SIGBREAKF_CTRL_C,
            signal;
    BOOL    END = FALSE;
    struct  IntuiMessage *imsg;
    struct  Gadget *gadget;

    while( !END ) {
        signal = Wait( signalmask );
        if( signal & (1lu << win->UserPort->mp_SigBit) ) {
            while( imsg = (struct IntuiMessage *)GetMsg(win->UserPort) ) {
                switch( imsg->Class )
                {
                case IDCMP_REFRESHWINDOW:
                    BeginRefresh( win );
                    EndRefresh(win, TRUE );
                    break;
                case IDCMP_CLOSEWINDOW:
                    END = TRUE;
                    break;
                case IDCMP_VANILLAKEY:  /* Any keypress will do. */
                    ActivateGadget( gad, win, NULL );
                    break;
                case IDCMP_GADGETUP:
                    gadget = (struct Gadget *)imsg->IAddress;

                    if( gadget->GadgetID == PUMG_GADGET_ID ) {
                        printf("New Active Item is %d\n", imsg->Code );
                    }
                    break;
                }

                ReplyMsg( (struct Message *)imsg );
            }
        }

        if( signal & SIGBREAKF_CTRL_C ) {
            END = TRUE;
        }
    }
}