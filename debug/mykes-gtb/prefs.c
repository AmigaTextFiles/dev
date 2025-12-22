/*-- AutoRev header do NOT edit!
*
*   Program         :   Prefs.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   13-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   13-Oct-91     1.00            Preferences requester.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External referenced data.
 */
extern ULONG             Class;
extern UWORD             Code;
extern struct TextAttr   Topaz80;
extern APTR              MainVisualInfo;
extern struct Screen    *MainScreen;
extern struct Window    *MainWindow;
extern struct Gadget    *theObject;
extern struct Prefs      MainPrefs;
extern UWORD             CountFrom;
extern UBYTE             MainFileName[512];

/*
 * --- Gadget ID's
 */
#define GD_STATIC       0
#define GD_RAW          1
#define GD_COORDS       2
#define GD_ICON         3
#define GD_IDFROM       4
#define GD_PREFIX       5
#define GD_SAVE         6
#define GD_LOAD         7
#define GD_USE          8
#define GD_CANCEL       9

/*
 * --- Module data.
 */
struct Window           *pr_Wnd   = NULL;
struct Gadget           *pr_GList = NULL;
struct FileRequester    *pr_Freq  = NULL;
struct Gadget           *pr_Gadgets[6];

BOOL                     pr_Static = FALSE, pr_Raw = FALSE;
BOOL                     pr_Coords = FALSE, pr_Icon = FALSE;

WORD                     pr_Zoom[4];

struct TagItem           pr_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | CHECKBOXIDCMP | INTEGERIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Preferences:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)pr_Zoom,
    TAG_DONE };

UBYTE                   pr_File[32]  = "GadToolsBox.prefs";
UBYTE                   pr_Path[256] = "DEVS:";
UBYTE                   pr_Patt[32]  = "#?.prefs";
UBYTE                   pr_LFile[32]  = "GadToolsBox.prefs";
UBYTE                   pr_LPath[256] = "DEVS:";
UBYTE                   pr_LPatt[32]  = "#?.prefs";
UBYTE                   pr_Buffer[512];

struct TagItem          pr_STags[] = {
    ASL_Hail,           (ULONG)"Save Preferences...",
    ASL_Window,         0l,
    ASL_File,           (ULONG)pr_File,
    ASL_Dir,            (ULONG)pr_Path,
    ASL_Pattern,        (ULONG)pr_Patt,
    ASL_OKText,         (ULONG)"Save",
    ASL_FuncFlags,      FILF_SAVE | FILF_PATGAD,
    TAG_DONE };

struct TagItem          pr_LTags[] = {
    ASL_Hail,           (ULONG)"Load Preferences...",
    ASL_Window,         0l,
    ASL_File,           (ULONG)pr_LFile,
    ASL_Dir,            (ULONG)pr_LPath,
    ASL_Pattern,        (ULONG)pr_LPatt,
    ASL_OKText,         (ULONG)"Load",
    ASL_FuncFlags,      FILF_PATGAD,
    TAG_DONE };

/*
 * --- Set the preferences.
 */
void SetPreferences( struct Prefs *prf )
{
    setmem( (char *)prf, (long)sizeof( struct Prefs ), 0l );

    prf->pr_Version     =   PR_VERSION;

    if ( pr_Static )    prf->pr_PrefFlags0  |= PRF_STATIC;
    if ( pr_Raw    )    prf->pr_PrefFlags0  |= PRF_RAW;
    if ( pr_Coords )    prf->pr_PrefFlags0  |= PRF_COORDS;
    if ( pr_Icon   )    prf->pr_PrefFlags0  |= PRF_WRITEICON;

    prf->pr_CountIDFrom = CountFrom = (( struct StringInfo * )pr_Gadgets[ GD_IDFROM ]->SpecialInfo )->LongInt;
    strcpy( &prf->pr_ProjectPrefix[0], (( struct StringInfo * )pr_Gadgets[ GD_PREFIX ]->SpecialInfo )->Buffer );
}

/*
 * --- Set the preferences gadgets.
 */
void MakePreferences( struct Prefs *prf )
{
    long    flg = prf->pr_PrefFlags0;

    if (( flg & PRF_STATIC ) == PRF_STATIC )
        pr_Static = TRUE; else pr_Static = FALSE;
    if (( flg & PRF_RAW ) == PRF_RAW )
        pr_Raw = TRUE; else pr_Raw = FALSE;
    if (( flg & PRF_COORDS ) == PRF_COORDS )
        pr_Coords = TRUE; else pr_Coords = FALSE;
    if (( flg & PRF_WRITEICON ) == PRF_WRITEICON )
        pr_Icon = TRUE; else pr_Icon = FALSE;

    GT_SetGadgetAttrs( pr_Gadgets[ GD_STATIC ], pr_Wnd, 0l, GTCB_Checked, pr_Static, TAG_DONE );
    GT_SetGadgetAttrs( pr_Gadgets[ GD_RAW    ], pr_Wnd, 0l, GTCB_Checked, pr_Raw   , TAG_DONE );
    GT_SetGadgetAttrs( pr_Gadgets[ GD_COORDS ], pr_Wnd, 0l, GTCB_Checked, pr_Coords, TAG_DONE );
    GT_SetGadgetAttrs( pr_Gadgets[ GD_ICON   ], pr_Wnd, 0l, GTCB_Checked, pr_Icon  , TAG_DONE );
    GT_SetGadgetAttrs( pr_Gadgets[ GD_IDFROM ], pr_Wnd, 0l, GTIN_Number, prf->pr_CountIDFrom, TAG_DONE );
    GT_SetGadgetAttrs( pr_Gadgets[ GD_PREFIX ], pr_Wnd, 0l, GTST_String, &prf->pr_ProjectPrefix[0], TAG_DONE );
}

/*
 * --- Load the preferences.
 */
void ReadPreferences( void )
{
    BPTR            file = 0l;
    struct Prefs    prf;

    if ( pr_Freq = AllocAslRequest( ASL_FileRequest, TAG_DONE )) {
        pr_LTags[1].ti_Data = (ULONG)pr_Wnd;
        if ( AslRequest( pr_Freq, pr_LTags )) {

            strcpy( pr_Buffer, MainFileName );
            strcpy( MainFileName, pr_Freq->rf_Dir );
            CheckDirExtension();
            strcat( MainFileName, pr_Freq->rf_File );

            strcpy( pr_LPath, pr_Freq->rf_Dir );
            strcpy( pr_LFile, pr_Freq->rf_File );
            strcpy( pr_LPatt, pr_Freq->rf_Pat );

            if ( file = MyOpen( MODE_OLDFILE )) {
                Read( file, (char *)&prf, (long)sizeof( struct Prefs ));
                MakePreferences( &prf );
            }
        }
    }

    if ( file )     Close( file );
    if ( pr_Freq )  FreeAslRequest( pr_Freq );

    strcpy( MainFileName, pr_Buffer );
    pr_Freq = 0l;
}

/*
 * --- Save the preferences.
 */
void WritePreferences( void )
{
    BPTR            file = 0l;
    struct Prefs    prf;

    SetPreferences( &prf );

    if ( pr_Freq = AllocAslRequest( ASL_FileRequest, TAG_DONE )) {
        pr_STags[1].ti_Data = (ULONG)pr_Wnd;
        if ( AslRequest( pr_Freq, pr_STags )) {

            strcpy( pr_Buffer, MainFileName );
            strcpy( MainFileName, pr_Freq->rf_Dir );
            CheckDirExtension();
            strcat( MainFileName, pr_Freq->rf_File );

            strcpy( pr_Path, pr_Freq->rf_Dir );
            strcpy( pr_File, pr_Freq->rf_File );
            strcpy( pr_Patt, pr_Freq->rf_Pat );

            if ( file = MyOpen( MODE_NEWFILE ))
                Write( file, (char *)&prf, (long)sizeof( struct Prefs ));
        }
    }

    if ( file )     Close( file );
    if ( pr_Freq )  FreeAslRequest( pr_Freq );

    strcpy( MainFileName, pr_Buffer );
    pr_Freq = 0l;
}

/*
 * --- Display the Preferences requester.
 */
long Preferences( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running =  TRUE;
    WORD                 l, t, w, h, btop, bleft, fnc, num;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 84;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    pr_Zoom[0] = 0;
    pr_Zoom[1] = btop;
    pr_Zoom[2] = 200;
    pr_Zoom[3] = btop;

    pr_nwTags[0].ti_Data = l;
    pr_nwTags[1].ti_Data = t;
    pr_nwTags[2].ti_Data = w;
    pr_nwTags[3].ti_Data = h;

    pr_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        pr_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        pr_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        pr_nwTags[10].ti_Tag  = TAG_DONE;

    if ( g = CreateContext( &pr_GList )) {

        ng.ng_LeftEdge      =   bleft + 6;
        ng.ng_TopEdge       =   btop + 5;
        ng.ng_GadgetText    =   "_Static data";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_STATIC;
        ng.ng_Flags         =   PLACETEXT_RIGHT;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        pr_Gadgets[ GD_STATIC ] = g;

        ng.ng_LeftEdge      =   bleft + 150;
        ng.ng_GadgetText    =   "_RAW Asm source";
        ng.ng_GadgetID      =   GD_RAW;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        pr_Gadgets[ GD_RAW ] = g;

        ng.ng_LeftEdge      =   bleft + 6;
        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "C_oordinates";
        ng.ng_GadgetID      =   GD_COORDS;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        pr_Gadgets[ GD_COORDS ] = g;

        ng.ng_LeftEdge      =   bleft + 150;
        ng.ng_GadgetText    =   "_Write Icon";
        ng.ng_GadgetID      =   GD_ICON;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        pr_Gadgets[ GD_ICON ] = g;

        ng.ng_TopEdge       =   btop + 35;
        ng.ng_GadgetText    =   "Co_unt ID from  ->";
        ng.ng_Width         =   144;
        ng.ng_Height        =   12;
        ng.ng_GadgetID      =   GD_IDFROM;
        ng.ng_Flags         =   PLACETEXT_LEFT;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_MaxChars, 5l, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        pr_Gadgets[ GD_IDFROM ] = g;

        ng.ng_TopEdge       =   btop + 51;
        ng.ng_GadgetText    =   "_Project Prefix ->";
        ng.ng_GadgetID      =   GD_PREFIX;

        g = CreateGadget( STRING_KIND, g, &ng, GTIN_MaxChars, 5l, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 6;
        ng.ng_TopEdge       =   btop + 67;
        ng.ng_Width         =   60;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "S_ave";
        ng.ng_GadgetID      =   GD_SAVE;
        ng.ng_Flags         =   PLACETEXT_IN;

        SetStringGadget( g );

        pr_Gadgets[ GD_PREFIX ] = g;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 82;
        ng.ng_GadgetText    =   "_Load";
        ng.ng_GadgetID      =   GD_LOAD;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 158;
        ng.ng_GadgetText    =   "Us_e";
        ng.ng_GadgetID      =   GD_USE;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 234;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            pr_nwTags[6].ti_Data = (Tag)pr_GList;

            if ( pr_Wnd = OpenWindowTagList( NULL, pr_nwTags )) {

                pr_Zoom[0] = l;
                pr_Zoom[1] = t;
                pr_Zoom[2] = w;
                pr_Zoom[3] = h;

                GT_RefreshWindow( pr_Wnd, NULL );

                MakePreferences( &MainPrefs );

                do {
                    WaitPort( pr_Wnd->UserPort );

                    while ( ReadIMsg( pr_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( pr_Wnd );
                                GT_EndRefresh( pr_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch ( theObject->GadgetID ) {

                                    case    GD_STATIC:
                                        FlipFlop( 0l, 0l, 0l, &pr_Static );
                                        break;

                                    case    GD_RAW:
                                        FlipFlop( 0l, 0l, 0l, &pr_Raw );
                                        break;

                                    case    GD_COORDS:
                                        FlipFlop( 0l, 0l, 0l, &pr_Coords );
                                        break;

                                    case    GD_ICON:
                                        FlipFlop( 0l, 0l, 0l, &pr_Icon );
                                        break;

                                    case    GD_IDFROM:
                                        num = (( struct StringInfo * )pr_Gadgets[ GD_IDFROM ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( pr_Gadgets[ GD_IDFROM ], pr_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_SAVE:
                                        Save:
                                        WritePreferences();
                                        break;

                                    case    GD_LOAD:
                                        Load:
                                        ReadPreferences();
                                        break;

                                    case    GD_USE:
                                        Use:
                                        running = FALSE;
                                        fnc     = TRUE;
                                        break;

                                    case    GD_CANCEL:
                                        Cancel:
                                        running = FALSE;
                                        fnc     = FALSE;
                                }
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch( Code ) {

                                    case    's':
                                        FlipFlop( pr_Wnd, pr_Gadgets, GD_STATIC, &pr_Static );
                                        break;

                                    case    'r':
                                        FlipFlop( pr_Wnd, pr_Gadgets, GD_RAW, &pr_Raw );
                                        break;

                                    case    'o':
                                        FlipFlop( pr_Wnd, pr_Gadgets, GD_COORDS, &pr_Coords );
                                        break;

                                    case    'w':
                                        FlipFlop( pr_Wnd, pr_Gadgets, GD_ICON, &pr_Icon );
                                        break;

                                    case    'u':
                                        ActivateGadget( pr_Gadgets[ GD_IDFROM ], pr_Wnd, 0l );
                                        break;

                                    case    'p':
                                        ActivateGadget( pr_Gadgets[ GD_PREFIX ], pr_Wnd, 0l );
                                        break;

                                    case    'a':
                                        goto Save;

                                    case    'l':
                                        goto Load;

                                    case    'e':
                                        goto Use;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( fnc ) {
        SetPreferences( &MainPrefs );
        MouseMove( MainWindow, pr_Coords );
    }

    if ( pr_Wnd )           CloseWindow( pr_Wnd );
    if ( pr_GList )         FreeGadgets( pr_GList );

    pr_Wnd   = 0l;
    pr_GList = 0l;

    ClearMsgPort( MainWindow->UserPort );
}
