#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/bgui.h>
#include <clib/alib_protos.h>
#include <Libraries/bgui.h>
#include <libraries/bgui_macros.h>
// *** Change bellow with your path ***
#include <bgui/Hook/StringHook.h>
#include "NewString_macros.h"
#include <stdio.h>

#ifdef _DCC
#include <Lib/Misc.h>
#endif

struct Library *BGUIBase;

/*
**  Prototypes
**/
ULONG Req( struct Window *, UBYTE *, UBYTE *, UBYTE *, ... );

/*
**  ID of gadgets
**/
enum {

    GD_NORMAL_STR,
    GD_NORMAL_BUT,
    GD_NEWSTR_STR,
    GD_NEWSTR_BUT,

    GD_GAD1,
    GD_GAD2,
    GD_GAD3,

    GD_STR_COMMAND,
    GD_BUTMODE,

    GAD_CNT,

    MN_ABOUT
};

/*
**  Datas for GUI
**/
Object  *WO_Main;
ULONG   MainMask;
struct  Window  *MainWnd;
Object  *MainGad[ GAD_CNT ];

// Menus for windows
struct NewMenu  Menus[] =
{
    Title( "Project " ),
        Item( "About...", "?", MN_ABOUT ),
        ItemBar,
        Item( "Quit", "Q", WMHI_CLOSEWINDOW ),
    End
};



/*
**  Main entry
**/
int main( int argc, char **argv )
{
BOOL done=TRUE;
int rc;
ULONG   t;

    /*
    **  Open the bgui.library.
    **/
    if( !( BGUIBase = OpenLibrary( "bgui.library", 37 ) ))
    {
        printf("This demo need the bgui.library  :-(\n");
        return(30);
    }

    /*
    **  Create the window;
    **/
    WO_Main = WindowObject,
                WINDOW_Title,           "Demo of String hook",
                WINDOW_ScaleWidth,      20,
                WINDOW_AutoAspect,      TRUE,
                WINDOW_LockHeight,      TRUE,
                WINDOW_MenuStrip,       Menus,
                WINDOW_SmartRefresh,    TRUE,
                WINDOW_CloseOnEsc,      TRUE,
                WINDOW_MasterGroup,

                VGroupObject, VOffset( 2 ), HOffset( 4 ), Spacing( 4 ),

                StartMember, VGroupObject, NeXTFrame, FrameTitle( "Repair bug" ), HOffset( 4+2 ), VOffset( 4 ), Spacing( 4 ),

                    StartMember, VGroupObject, NeXTFrame, FrameTitle( "Normal string (type 5 chars. and affect-it)"), HOffset( 4+4 ), BOffset( 4 ), TOffset( 2 ), Spacing( 2 ),
                        StartMember, MainGad[ GD_NORMAL_STR ] = String( NULL, "12345", 5, GD_NORMAL_STR ), EndMember,
                        StartMember, MainGad[ GD_NORMAL_BUT ] = Button( "Re-Affect the string contents", GD_NORMAL_BUT ), EndMember,
                    EndObject, FixMinHeight, EndMember,

                    StartMember, VGroupObject, NeXTFrame, FrameTitle( "New String (type 5 chars. and affect-it)"), HOffset( 4+4 ), BOffset( 4 ), TOffset( 2 ), Spacing( 2 ),
                        StartMember, MainGad[ GD_NEWSTR_STR ] = NewString( NULL, "12345", 5, GD_NEWSTR_STR ), EndMember,
                        StartMember, MainGad[ GD_NEWSTR_BUT ] = Button( "Re-Affect the string contents", GD_NEWSTR_BUT ), EndMember,
                    EndObject, FixMinHeight, EndMember,

                EndObject, EndMember,



                StartMember, HGroupObject, Spacing( 4 ),

                    StartMember, VGroupObject, NeXTFrame, FrameTitle( "Return-cycle" ), HOffset( 4+2 ), VOffset( 4 ), Spacing( 4 ),
                        StartMember, MainGad[GD_GAD1] = NewStringReturn( "Gad #1", "Gadget 1", 15, 0 ), FixMinHeight, EndMember,
                        VarSpace( 1 ),
                        StartMember, MainGad[GD_GAD2] = NewStringReturn( "Gad #2", "Gadget 2", 15, 0 ), FixMinHeight, EndMember,
                        VarSpace( 1 ),
                        StartMember, MainGad[GD_GAD3] = NewStringReturn( "Gad #3", "Gadget 3", 15, 0 ), FixMinHeight, EndMember,
                    EndObject, EndMember,

                    StartMember, VGroupObject, NeXTFrame, FrameTitle( "Enable Amiga Command" ), HOffset( 4+2 ), VOffset( 4 ), Spacing( 4 ),
                         StartMember, MainGad[GD_STR_COMMAND] = NewStringCommand( NULL, "Perform Shorcut", 30, GD_STR_COMMAND ), FixMinHeight, EndMember,
                         //VarSpace( 1 ),
                         StartMember, MainGad[GD_BUTMODE] = KeyButton( "_Mode", GD_BUTMODE ), /*FixMinHeight,*/ EndMember,
                    EndObject, EndMember,

                EndObject, EndMember,

                EndObject,

                EndObject;

    /*
    **  Set TAB-CYCLE and RETURN-CYCLE
    **/
    DoMethod( WO_Main, WM_TABCYCLE_ORDER, MainGad[GD_GAD1], MainGad[GD_GAD2], MainGad[GD_GAD3], TAG_END );

    GadgetKey( WO_Main, MainGad[GD_BUTMODE], "M" );

    /*
    **  Open the window.
    **/
    MainWnd= WindowOpen( WO_Main );

    GetAttr( WINDOW_SigMask, WO_Main, &MainMask );

    if( WO_Main && MainWnd )

    /*
    **  Handle window.
    **/
    do{

        Wait( MainMask );

        while (( rc = HandleEvent( WO_Main )) != WMHI_NOMORE )
        {
            switch ( rc )
            {
                case    WMHI_CLOSEWINDOW:   done = FALSE;
                                            break;

                case    GD_NORMAL_BUT:      GetAttr( STRINGA_TextVal, MainGad[ GD_NORMAL_STR ], &t );
                                            SetGadgetAttrs( (struct Gadget *)MainGad[ GD_NORMAL_STR ], MainWnd, NULL, STRINGA_TextVal, t, TAG_END );
                                            break;

                case    GD_NEWSTR_BUT:      GetAttr( STRINGA_TextVal, MainGad[ GD_NEWSTR_STR ], &t );
                                            SetGadgetAttrs( (struct Gadget *)MainGad[ GD_NEWSTR_STR ], MainWnd, NULL, STRINGA_TextVal, t, TAG_END );
                                            break;

                case    GD_BUTMODE:         ActivateGadget( (struct Gadget *)MainGad[GD_STR_COMMAND], MainWnd, NULL );
                                            break;

                case    MN_ABOUT:           Req( MainWnd, NULL, "*_Ok", "About requester..." );
                                            break;

            }
        }

    } while( done );


    /*
    **  Dispose window and its gadgets
    **/
    if( WO_Main )   DisposeObject( WO_Main );

    /*
    **  Close the bgui.library
    **/
    CloseLibrary( BGUIBase );

    return(0);
}

#ifdef _DCC
int wbmain( struct WBStartup *w )
{
    return( main( 0, NULL ) );
}
#endif



/*
**  Requester
**/
/// ULONG Req( struct Window *win, UBYTE *Title, UBYTE *gadgets, UBYTE *body, ... )
ULONG Req( struct Window *win, UBYTE *Title, UBYTE *gadgets, UBYTE *body, ... )
{
struct bguiRequest req={NULL};


        req.br_GadgetFormat     = gadgets;
        req.br_TextFormat       = body;
        req.br_Underscore       = '_';
        req.br_Flags            = BREQF_CENTERWINDOW|BREQF_AUTO_ASPECT| BREQF_FAST_KEYS;
        if( win )
            req.br_Flags        |= BREQF_LOCKWINDOW;
        req.br_Title            = Title;

        return( BGUI_RequestA( win, &req, ( ULONG * )( &body + 1 )));
}
///

