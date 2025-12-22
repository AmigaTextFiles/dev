#include <proto/exec.h>
#include <proto/asl.h>
#include <proto/intuition.h>
#include <clib/alib_protos.h>
#include <proto/bgui.h>
#include <proto/utility.h>
#include <libraries/bgui_macros.h>
#include "LibPerso:Boopsi/ScreenModeClass.h"
#include <stdio.h>

#ifdef _DCC
#include <lib/misc.h>
#endif

/*
**  Define ID of gadgets
**/
#define GD_BUTTON           0
#define GD_GUI_MODE         1
#define GD_INFO_WIN         2
#define GD_CONTROL_MINSIZE  3
#define GD_DO_WIDTH         4
#define GD_DO_HEIGHT        5
#define GD_DO_OVERSCAN      6
#define GD_DO_AUTOSCROLL    7
#define GD_SLEEP            8
#define GD_MIN_WIDTH        9
#define GD_MIN_HEIGHT       10

#define GAD_CNT             11


/*
**  Datas for the bgui window.
**/
Object          *WO_Main;
struct Window   *MainWnd = NULL;
ULONG           MainMask=NULL;
Object          *MainGad[ GAD_CNT ];


struct Library  *BGUIBase=NULL;

/*
**  Special version of GetAttr.
**/
ULONG GetAttrs( Object *obj, ULONG tag1, ... )
{
struct TagItem          *tstate = ( struct TagItem * )&tag1, *tag;
ULONG                    num = 0L;

        while ( tag = NextTagItem( &tstate ))
                num += GetAttr( tag->ti_Tag, obj, ( ULONG * )tag->ti_Data );

        return( num );
}




main( int argc, char **argv )
{
Class   *ScreenModeClass=NULL;
Object  *ScreenRequester=NULL;
ULONG   t;
BOOL    done=TRUE;
int     rc;
ULONG   Width, Height, Depth, ModeID, AutoScroll, Overscan;

    /*
    **      Open the bgui.library
    **/
    if( !( BGUIBase = OpenLibrary( "bgui.library", 37 ) ))
    {
        printf("This demo use the bgui.library.\n");
        return( 30 );
    }

    /*
    **      Init. the class.
    **/
    ScreenModeClass=InitScreenModeClass();

    if( ScreenModeClass )
    {

        /*
        **  Create a window.
        **/
        WO_Main = WindowObject,
                    WINDOW_Title,           "ScreenMode class demo",
                    WINDOW_RMBTrap,         TRUE,
                    WINDOW_SmartRefresh,    TRUE,
                    WINDOW_ScaleWidth,      20,
                    WINDOW_AutoAspect,      TRUE,
                    WINDOW_LockHeight,      TRUE,
                    WINDOW_MasterGroup,

                    VGroupObject, VOffset( 2 ), HOffset( 4 ), Spacing( 2 ),

                    /*
                    **  Tags...
                    **/
                    StartMember, HGroupObject, NeXTFrame, FrameTitle( "Tags.."), VOffset( 2 ), BOffset( 4 ), HOffset( 4+4 ), Spacing( 2 ), EqualWidth,
                        StartMember, VGroupObject, Spacing( 4 ),
                            StartMember, MainGad[ GD_GUI_MODE ] = CheckBox( "GUI MODE", 0, GD_GUI_MODE ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_INFO_WIN ] = CheckBox( "Info window", 0, GD_INFO_WIN ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_CONTROL_MINSIZE ] = CheckBox( "SMC_ControlMinSize", 0, GD_CONTROL_MINSIZE ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_SLEEP ] = CheckBox( "Sleep window", 0, GD_SLEEP ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_MIN_WIDTH ] = Integer("Min Width", 0, 3, GD_MIN_WIDTH ), NoAlign, FixMinHeight, EndMember,
                        EndObject, FixMinWidth, EndMember,

                        VarSpace(1),

                        StartMember, VGroupObject, Spacing( 4 ),
                            StartMember, MainGad[ GD_DO_WIDTH ] = CheckBox( "Do Width", 0, GD_DO_WIDTH ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_DO_HEIGHT ] = CheckBox( "Do Height", 0, GD_DO_HEIGHT ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_DO_OVERSCAN ] = CheckBox( "Do Overscan", 0, GD_DO_OVERSCAN ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_DO_AUTOSCROLL ] = CheckBox( "Do AutoScroll", 0, GD_DO_AUTOSCROLL ), FixMinWidth, EndMember,
                            StartMember, MainGad[ GD_MIN_HEIGHT ] = Integer("Min Height", 0, 3, GD_MIN_HEIGHT ), NoAlign, FixMinHeight, EndMember,
                        EndObject, FixMinWidth, EndMember,

                    EndObject, FixMinHeight, EndMember,         /* End of TAG group */

                    StartMember, MainGad[ GD_BUTTON ] = Button( "Screen mode requester", GD_BUTTON ), FixMinHeight, EndMember,

                    EndObject,          /* End of Main VGroup object */

                    EndObject;          /* End of WindowObject */


 


        if( WO_Main )
        {
            /*
            **  Open a window.
            **/
            MainWnd = WindowOpen( WO_Main );
            GetAttr( WINDOW_SigMask, WO_Main, &MainMask );

            /*
            **  Create a ScreenMode object.
            **/
            ScreenRequester=NewObject( ScreenModeClass, NULL,
                        SMC_InitialInfoPos,         SMC_INFOPOS_TopRight,
                        SMC_InfoPosArround,         TRUE,
                        ASLSM_Window,               MainWnd,
                        TAG_END );
        }

        if( MainWnd && ScreenRequester )
        do{
            Wait( MainMask );

            while (( rc = HandleEvent( WO_Main )) != WMHI_NOMORE )
            {
                switch ( rc )
                {
                    case WMHI_CLOSEWINDOW:      done = FALSE;
                                                break;

                    /*
                    **      Tags to set or unset.
                    **/
                    case GD_GUI_MODE:           if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, SMC_GUI_MODES, TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, SMC_GUI_MODES, FALSE, TAG_END );
                                                break;

                    case GD_INFO_WIN:           if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, ASLSM_InitialInfoOpened, TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, ASLSM_InitialInfoOpened, FALSE, TAG_END );
                                                break;

                    case GD_CONTROL_MINSIZE:    if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, SMC_ControlMinSize ,TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, SMC_ControlMinSize, FALSE, TAG_END );
                                                break;   

                    case GD_DO_WIDTH:           if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, ASLSM_DoWidth, TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, ASLSM_DoWidth, FALSE, TAG_END );
                                                break;

                    case GD_DO_HEIGHT:          if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, ASLSM_DoHeight, TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, ASLSM_DoHeight, FALSE, TAG_END );
                                                break;

                    case GD_DO_OVERSCAN:        if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, ASLSM_DoOverscanType,TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, ASLSM_DoOverscanType, FALSE, TAG_END );
                                                break;

                    case GD_DO_AUTOSCROLL:      if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, ASLSM_DoAutoScroll,TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, ASLSM_DoAutoScroll, FALSE, TAG_END );
                                                break;

                    case GD_SLEEP:              if( ((struct Gadget *)MainGad[ rc ])->Flags & GFLG_SELECTED )
                                                    SetAttrs( ScreenRequester, ASLSM_SleepWindow,TRUE, TAG_END );
                                                else
                                                    SetAttrs( ScreenRequester, ASLSM_SleepWindow, FALSE, TAG_END );
                                                break;

                    case GD_MIN_WIDTH:          GetAttr( STRINGA_LongVal, MainGad[ rc ], &t );
                                                SetAttrs( ScreenRequester, ASLSM_MinWidth, t, TAG_END );
                                                break;

                    case GD_MIN_HEIGHT:         GetAttr( STRINGA_LongVal, MainGad[ rc ], &t );
                                                SetAttrs( ScreenRequester, ASLSM_MinHeight, t, TAG_END );
                                                break;

                    /*
                    **  Popup the screen mode requester.
                    **/
                    case GD_BUTTON:             if( ScreenModeReq( ScreenRequester ) )
                                                {
                                                    GetAttrs( ScreenRequester,
                                                                SMC_DisplayWidth,   &Width,
                                                                SMC_DisplayHeight,  &Height,
                                                                SMC_DisplayID,      &ModeID,
                                                                SMC_AutoScroll,     &AutoScroll,
                                                                SMC_OverscanType,   &Overscan,
                                                                SMC_DisplayDepth,   &Depth,
                                                                TAG_END );

                                                    printf("\nModeID= 0x%x\nSize= %d x %d x %d\nAutoScroll=  %s\nOverscanType= %d\n",
                                                                ModeID, Width, Height, Depth,
                                                                AutoScroll ? "TRUE":"FALSE",
                                                                Overscan );
                                                }
                                                break;
                }
            }

        } while( done );

        /*
        **      Close and dispose the window.
        **/
        if( WO_Main )
            DisposeObject( WO_Main );

        /*
        **      Dispose the ScreenMode object.
        **/
        DisposeObject( ScreenRequester );

        /*
        **      Dispose the class.
        **/
        FreeScreenModeClass( ScreenModeClass );
    }

    CloseLibrary( BGUIBase );

    return(0);
}


#ifdef _DCC
int wbmain( struct WBStartup *w )
{
    OpenConsole( "CON:0/450//100/ScreenModeClass demo/AUTO" );
    return( main( 0, NULL ) );
}
#endif
