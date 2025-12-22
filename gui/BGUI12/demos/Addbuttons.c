;/*
dcc addbuttons.c -mi -ms -mRR -proto -lbgui
quit
*/
/*
 *      ADDBUTTONS.C
 *
 *      (C) Copyright 1994 Paul Weterings.
 *          All Rights Reserved.
 */

#include "democode.h"

/*
 *      Object ID's. Please note that the ID's are shared
 *      between the menus and the gadget objects.
 */
#define ID_ADD          21
#define ID_QUIT         22
#define ID_INS          23
#define ID_REM          24

/*
 *      Simple menu strip.
 */
struct NewMenu SimpleMenu[] = {
        Title( "Project" ),
                Item( "Add",        "A", ID_ADD ),
                Item( "Insert",     "I", ID_INS ),
                Item( "Remove all", "R", ID_REM ),
                ItemBar,
                Item( "Quit",       "Q", ID_QUIT ),
                End
};

/*
 *      Simple button creation macros.
 */
#define AddButton\
        ButtonObject,\
                LAB_Label,              "Added",\
                LAB_Style,              FSF_BOLD,\
                ButtonFrame,\
        EndObject

#define InsButton\
        ButtonObject,\
                LAB_Label,              "Inserted",\
                LAB_Style,              FSF_BOLD,\
                ButtonFrame,\
        EndObject


VOID StartDemo( void )
{
        struct Window           *window;
        Object                  *WO_Window, *GO_Add, *GO_Quit, *GO_Ins, *GO_Rem, *addobj[20], *base;
        ULONG                    signal = 0, rc, tmp = 0;
        BOOL                     running = TRUE, ok = FALSE;
        int                      x = 0, xx;

        /*
         *      Create window object.
         */
        WO_Window = WindowObject,
                WINDOW_Title,           "Add/Insert Demo",
                WINDOW_MenuStrip,       SimpleMenu,
                WINDOW_LockHeight,      TRUE,
                WINDOW_AutoAspect,      TRUE,
                WINDOW_MasterGroup,
                        base = HGroupObject,
                                StartMember, GO_Add  = XenKeyButton( "_Add",        ID_ADD  ), EndMember,
                                StartMember, GO_Ins  = XenKeyButton( "_Insert",     ID_INS  ), EndMember,
                                StartMember, GO_Rem  = XenKeyButton( "_Remove all", ID_REM  ), EndMember,
                                StartMember, GO_Quit = XenKeyButton( "_Quit",       ID_QUIT ), EndMember,
                        EndObject,
        EndObject;

        /*
         *      OK?
         */
        if ( WO_Window ) {
                /*
                 *      Add gadget hotkeys.
                 */
                tmp += GadgetKey( WO_Window, GO_Add,  "a" );
                tmp += GadgetKey( WO_Window, GO_Quit, "q" );
                tmp += GadgetKey( WO_Window, GO_Ins,  "i" );
                tmp += GadgetKey( WO_Window, GO_Rem,  "r" );
                /*
                 *      Keys OK?
                 */
                if ( tmp == 4 ) {
                        /*
                         *      Open window.
                         */
                        if ( window = WindowOpen( WO_Window )) {
                                /*
                                 *      Get signal mask.
                                 */
                                GetAttr( WINDOW_SigMask, WO_Window, &signal );
                                do {
                                        /*
                                         *      Poll messages.
                                         */
                                        Wait( signal );
                                        while (( rc = HandleEvent( WO_Window )) != WMHI_NOMORE ) {
                                                switch ( rc ) {

                                                        case  WMHI_CLOSEWINDOW:
                                                        case  ID_QUIT:
                                                                /*
                                                                 *      Bye now.
                                                                 */
                                                                running = FALSE;
                                                                break;

                                                        case  ID_ADD:
                                                                if ( x == 19 ) {
                                                                        Tell( "Max Nr. of gadgets\n" );
                                                                        break;
                                                                }
                                                                x++;
                                                                WindowClose( WO_Window );

                                                                addobj[x]  = AddButton;

                                                                ok = DoMethod( base, GRM_ADDMEMBER, addobj[ x ],
                                                                                LGO_FixMinHeight, FALSE,
                                                                                LGO_Weight,       DEFAULT_WEIGHT,
                                                                                TAG_END );

                                                                window = WindowOpen( WO_Window );

                                                                if ( ok && ! window ) {
                                                                        DoMethod( base, GRM_REMMEMBER, addobj[ x ] );
                                                                        x--;
                                                                        window = WindowOpen( WO_Window );
                                                                        Tell( "Last object did not fit!\n" );
                                                                }

                                                                if ( ! window )
                                                                        goto error;
                                                                break;

                                                        case  ID_REM:
                                                                if ( x > 0 ) {
                                                                        WindowClose( WO_Window );

                                                                        for ( xx = 1; xx <= x; xx++ )
                                                                                DoMethod( base, GRM_REMMEMBER, addobj[ xx ] );

                                                                        window = WindowOpen( WO_Window );
                                                                        x = 0;
                                                                } else
                                                                        Tell("Were out of gadgets!\n");

                                                                break;

                                                        case  ID_INS:
                                                                if ( x == 19 ) {
                                                                        Tell( "Max Nr. of gadgets\n" );
                                                                        break;
                                                                }
                                                                x++;
                                                                WindowClose( WO_Window );

                                                                addobj[x]  = InsButton;

                                                                ok = DoMethod( base, GRM_INSERTMEMBER, addobj[ x ], GO_Rem,
                                                                                LGO_FixMinHeight, FALSE,
                                                                                LGO_Weight,       DEFAULT_WEIGHT,
                                                                                TAG_END );

                                                                window = WindowOpen( WO_Window );

                                                                if ( ok && ! window ) {
                                                                        DoMethod( base, GRM_REMMEMBER, addobj[ x ] );
                                                                        x--;
                                                                        window = WindowOpen( WO_Window );
                                                                        Tell( "Last object did not fit!\n" );
                                                                }

                                                                if ( ! window )
                                                                        goto error;
                                                                break;

                                                }
                                        }
                                } while ( running );
                        } else
                                Tell( "Could not open the window\n" );
                } else
                        Tell( "Could not assign gadget keys\n" );
                error:
                DisposeObject( WO_Window );
        } else
                Tell( "Could not create the window object\n" );
}
