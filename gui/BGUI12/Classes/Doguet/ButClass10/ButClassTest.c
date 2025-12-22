#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/bgui.h>
#include <proto/keymap.h>

#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>
#include <libraries/bgui_beta.h>

#include <clib/alib_protos.h>

#include <boopsi/ButClass.h>

#ifdef _DCC
#include <lib/Misc.h>
#endif

#include <stdio.h>

#define GD_TITLE        0
#define GD_CLIPMODE     1
#define GD_JUSTIFY      2
#define GD_CLIPJUST     3
#define GD_SETTABLE     4
#define GD_STRING       5
#define GD_PEN_SLIDER   6
#define GD_BACK_SLIDER  7

#define GAD_CNT         8

/*
**  Library
**/
struct Library *BGUIBase=NULL;
struct Library *KeymapBase=NULL;

/*
**  Screen data
**/
struct Screen   *Scr=NULL;

/*
**  Object ptr
**/
Object          *WO_Test=NULL;
struct Window   *TestWnd=NULL;
Object          *TestGad[ GAD_CNT ];

/*
**  ButClass data
**/
Class           *ButClass=NULL;
Object          *But1=NULL;
Object          *But2=NULL;
Object          *Clipbut=NULL;

/*
**  TAG for map.
**/
ULONG   String2But[] = { STRINGA_TextVal, BUT_Label, TAG_END };
ULONG   Slider2ButPen[] = { SLIDER_Level,  BUT_LabelPen, TAG_END };
ULONG   Slider2ButBack[] = { SLIDER_Level,  FRM_BackPen, TAG_END };




int main( int argc, char **argv )
{
ULONG           Sig;
BOOL            running=TRUE;
ULONG           rc, t=0;
ULONG           c1=0;

    /*
    **  Open the bgui.library
    **/
    if( !( BGUIBase=OpenLibrary( "bgui.library", 39L ) ))
    {
        printf("Can't open bgui.library v39!\n");
        return(30);
    }

    /*
    **  Open the keymap.library
    **/
    if( !(KeymapBase=OpenLibrary( "keymap.library", 0L ) ))
    {
        printf("Can't open keymap.library\n");
        CloseLibrary( BGUIBase );
        return(30);
    }

    /*
    **  Init. of the ButClass
    **/
    if( !(ButClass=InitButClass()) )
    {
        printf("InitButClass() failed!!\n");
        CloseLibrary( BGUIBase );
        return(30);
    }

    /*
    **  Locking screen (for have the number of color) (see bellow)
    **/
    if( !(Scr = LockPubScreen( "Workbench" ) ))
    {
        printf("Can't lock screen\n");
        FreeButClass( ButClass );
        CloseLibrary( BGUIBase );
        CloseLibrary( KeymapBase );
        return(30);
    }


    /*
    **  Create window..
    **/
    WO_Test= WindowObject,
            WINDOW_Title,           "ButClass test",
            WINDOW_AutoAspect,      TRUE,
            WINDOW_RMBTrap,         TRUE,
            WINDOW_CloseOnEsc,      TRUE,
            WINDOW_ScaleWidth,      20,
            WINDOW_MasterGroup,

            VGroupObject, VOffset(4), HOffset(4), Spacing(4),

            /*
            **  Title ( with Justification mode ;-).
            **/
            StartMember,
                TestGad[ GD_TITLE ] = ButObject( ButClass ),
                            GA_ID,                  GD_TITLE+1,
                            NeXTFrame,
                            BUT_ClipText,           TRUE,
                            BUT_Justify,            TRUE,
                            BUT_Label,              BSEQ_J "ButClass" BSEQ_J " 1.0" BSEQ_J " (C) Doguet Emmanuel" BSEQ_J,
                            BUT_LabelPen,           2,
                            BUT_SelectedLabelPen,   2,
                            FRM_BackFill,           FILL_RASTER,
                    EndObject,
            EndMember,

            /*
            **  ClipText
            **/
            StartMember, VGroupObject, FrameTitle("ClipText"), NeXTFrame, VOffset(2), HOffset(4+4), BOffset(4), Spacing(4),
                StartMember,
                    TestGad[ GD_CLIPMODE ] = ButClip( ButClass, "The button can be smaller than the text width !", GD_CLIPMODE ),
                EndMember,
            EndObject, FixMinHeight, EndMember,

            /*
            **  Justify
            **/
            StartMember, HGroupObject, FrameTitle("Justify"), NeXTFrame, VOffset(2), HOffset(4+4), BOffset(4), Spacing(4),
                StartMember,
                    TestGad[ GD_JUSTIFY ] = ButJustify( ButClass, "_Contact me" BSEQ_J "at:" , GD_JUSTIFY ),
                EndMember,
            EndObject, FixMinHeight, EndMember,

            /*
            **  ClipText and Justify
            **/
            StartMember, HGroupObject, FrameTitle("ClipText + Justify"), NeXTFrame, VOffset(2), HOffset(4+4), BOffset(4), Spacing(4),
                StartMember,
                    TestGad[ GD_CLIPJUST ] = ButClipJust( ButClass, BSEQ_J "manu@ramses.fdn.org" BSEQ_J "or" BSEQ_J "2:320/104.64" BSEQ_J, GD_CLIPJUST ),
                EndMember,
            EndObject, FixMinHeight, EndMember,

            /*
            **  Settable label, colors...
            **/
            StartMember, VGroupObject, FrameTitle("Label is settable..."), NeXTFrame, VOffset(2), HOffset(4+4), BOffset(4), Spacing(4),

                StartMember,
                    TestGad[ GD_SETTABLE ] = ButClip( ButClass, "Nothing", GD_SETTABLE ),
                EndMember,

                StartMember,
                    TestGad[ GD_STRING ] = String( NULL, "Nothing", 256, GD_STRING ),
                EndMember,

                StartMember,
                    TestGad[ GD_PEN_SLIDER ] = HorizSlider( "Pen:", 0, (1<<Scr->BitMap.Depth)-1, 1, GD_PEN_SLIDER ),
                EndMember,

                StartMember,
                    TestGad[ GD_BACK_SLIDER ] = HorizSlider( "Back:", 0, (1<<Scr->BitMap.Depth)-1, 0, GD_BACK_SLIDER ),
                EndMember,

            EndObject, FixMinHeight, EndMember,


        EndObject,              // End of Main VGroup

        EndObject;              // End of MasterGroup


    GadgetKey( WO_Test, TestGad[ GD_JUSTIFY ], "c" );


    if( !WO_Test )
        printf("Failed to create window..\n");
    else
    {

        // Map String contents to button
        AddMap( TestGad[ GD_STRING ], TestGad[ GD_SETTABLE ], String2But );

        // Map sliders to button (color pen and background
        AddMap( TestGad[ GD_PEN_SLIDER ], TestGad[ GD_SETTABLE ], Slider2ButPen );
        AddMap( TestGad[ GD_BACK_SLIDER ], TestGad[ GD_SETTABLE ], Slider2ButBack );

        /*
        **  Open window  and get it's Mask.
        **/
        TestWnd=WindowOpen( WO_Test );
        
        GetAttr( WINDOW_SigMask, WO_Test, &Sig );

        /*
        **  Do until close window...
        **/
        if( TestWnd )

        do {

            Wait( Sig );

            while (( rc = HandleEvent( WO_Test )) != WMHI_NOMORE )
            {
                switch ( rc ) {
                        case    WMHI_CLOSEWINDOW:   running = FALSE;
                                                    break;
                }
            }

        }while ( running );

    }



    /*
    **  Dispose window
    **/
    if( WO_Test)
        DisposeObject( WO_Test );

    /*
    **  Dispose ButClass
    **/
    if( ButClass )
        FreeButClass( ButClass );

    /*
    **  Unlock screen
    **/
    if( Scr )
        UnlockPubScreen( NULL, Scr );

    CloseLibrary( BGUIBase );
    CloseLibrary( KeymapBase );

}


#ifdef _DCC
int wbmain( struct WBStartup *w )
{
    OpenConsole("CON:0/100//100/ButClassTest output/AUTO");
    return(main(0,0));
}
#endif
