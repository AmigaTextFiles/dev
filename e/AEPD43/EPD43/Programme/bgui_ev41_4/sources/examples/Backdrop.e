/*
 *      BACKDROP.e
 *
 *      (C) Copyright 1995 Jaba Development.
 *      (C) Copyright 1995 Jan van den Baard.
 *      (C) Copyright 1996 Marco Talamelli.
 *          All Rights Reserved.
 */

OPT OSVERSION=37
OPT PREPROCESS

MODULE  'libraries/bgui',
        'libraries/bgui_macros',
        'libraries/gadtools',
        'bgui',
        'tools/boopsi',
        'utility/tagitem',
        'intuition/screens',
        'intuition/intuition',
        'intuition/classes',
        'intuition/classusr',
        'intuition/gadgetclass',
        'graphics/displayinfo',
        'graphics/modeid'

/*
 *      Quit object ID.
 */
#define ID_QUIT         1

/*
 *      A borderless window ;)
 */
PROC say( screen:PTR TO screen )

    DEF wo_window, go_ok,
        signal, rc,text:PTR TO CHAR,
        running = TRUE

    text :=  '\ecThis demonstration shows you how to\n'+
             'create a backdrop, borderless window with BGUI.\n\n'+
             'You may recognize the GUI as the main window\n'+
             'of SPOT but that\as because I could not\n'+
             'come up with something original.\n\n'+
             'Just click on \ebQuit\en to exit the demo.'
    /*
     *      Create the window.
     */
    wo_window := WindowObject,
            WINDOW_BORDERLESS,      TRUE,
            WINDOW_SMARTREFRESH,    TRUE,
            WINDOW_RMBTRAP,         TRUE,
            WINDOW_AUTOASPECT,      TRUE,
            WINDOW_AUTOKEYLABEL,    TRUE,
            WINDOW_SCREEN,          screen,
            WINDOW_MASTERGROUP,
                    VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 3 ),
                            FRM_TYPE,       FRTYPE_BUTTON,
                            FRM_BACKFILL,   SHINE_RASTER,
                            StartMember,
                                    InfoObject,
                                            FRM_TYPE,               FRTYPE_BUTTON,
                                            FRM_RECESSED,           TRUE,
                                            INFO_TEXTFORMAT,        text,
                                            INFO_FIXTEXTWIDTH,      TRUE,
                                            INFO_MINLINES,          8,
                                    EndObject,
                            EndMember,
                            StartMember,
                                    HGroupObject,
                                            VarSpace( DEFAULT_WEIGHT ),
                                            StartMember, go_ok := KeyButton( '_OK', ID_QUIT ), EndMember,
                                            VarSpace( DEFAULT_WEIGHT ),
                                    EndObject, FixMinHeight,
                            EndMember,
                    EndObject,
    EndObject

    /*
     *      OK?
     */
    IF wo_window
            /*
             *      Open the window.
             */
            IF WindowOpen( wo_window )
                    GetAttr( WINDOW_SIGMASK, wo_window, {signal} )
                    /*
                     *      Wait for somebody to click
                     *      on the 'OK' gadget.
                     */
                    WHILE running = TRUE
                            Wait( signal )
                            WHILE (rc := HandleEvent( wo_window )) <> WMHI_NOMORE
                                    IF rc = ID_QUIT THEN running := FALSE
                            ENDWHILE
                    ENDWHILE
            ENDIF

            DisposeObject( wo_window )
    ENDIF
ENDPROC

/*
 *      Here we go...
 */
PROC main()

    DEF myscreen:PTR TO screen, wblock:PTR TO screen,
        dri:PTR TO drawinfo,
        window:PTR TO window,
        wo_window,
        wlock,
        mode, rc, signal,
        running = TRUE

    /*
    **      Open the library.
    **/
    IF bguibase := OpenLibrary( 'bgui.library', BGUIVERSION )
        /*
         *      Lock the workbench screen.
         */
        IF wblock := LockPubScreen( 'Workbench' )
                /*
                 *      Obtain it's DrawInfo.
                 */
                IF dri := GetScreenDrawInfo( wblock )
                        /*
                         *      And mode ID.
                         */
                        IF ( mode := GetVPModeID( wblock.viewport )) <> INVALID_ID
                                /*
                                 *      Open a screen ala your workbench.
                                 */
                                IF myscreen := OpenScreenTagList( NIL,[SA_DEPTH,         dri.depth,
                                                                      SA_WIDTH,         wblock.width,
                                                                      SA_HEIGHT,        wblock.height,
                                                                      SA_DISPLAYID,     mode,
                                                                      SA_PENS,          dri.pens,
                                                                      SA_TITLE,         'Backdrop Demo.',
                                                                      TAG_END] )
                                        /*
                                         *      Create a simple backdrop window on
                                         *      the screen whilst keeping the screen
                                         *      title visible.
                                         */
                                        wo_window := WindowObject,
                                                WINDOW_SMARTREFRESH,            TRUE,
                                                WINDOW_BACKDROP,                TRUE,
                                                WINDOW_SHOWTITLE,               TRUE,
                                                WINDOW_CLOSEONESC,              TRUE,
                                                WINDOW_AUTOASPECT,              TRUE,
                                                WINDOW_NOBUFFERRP,              TRUE,
                                                WINDOW_SCREEN,                  myscreen,
                                                WINDOW_MASTERGROUP,
                                                        HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
                                                                StartMember,
                                                                        VGroupObject, Spacing( 4 ),
                                                                                StartMember, Button( 'Message list...', 0 ), EndMember,
                                                                                StartMember, Button( 'Messages...',     0 ), EndMember,
                                                                                VarSpace( 40 ),
                                                                                StartMember, Button( 'Import...',       0 ), EndMember,
                                                                                StartMember, Button( 'Export...',       0 ), EndMember,
                                                                                StartMember, Button( 'Maintenance...',  0 ), EndMember,
                                                                                StartMember, Button( 'Optimize...',     0 ), EndMember,
                                                                                VarSpace( 40 ),
                                                                                StartMember, Button( 'Poll...',         0 ), EndMember,
                                                                                StartMember, Button( 'File request...', 0 ), EndMember,
                                                                                VarSpace( 40 ),
                                                                                StartMember, Button( 'Iconify',         0 ), EndMember,
                                                                                StartMember, Button( 'Quit',            ID_QUIT ), EndMember,
                                                                        EndObject, FixMinSize,
                                                                EndMember,
                                                                StartMember, ListviewObject, EndObject, EndMember,
                                                        EndObject,
                                        EndObject

                                        /*
                                         *      Window OK?
                                         */
                                        IF wo_window
                                                /*
                                                 *      Open the window.
                                                 */
                                                IF window := WindowOpen( wo_window )
                                                        /*
                                                         *      Show an explanation window.
                                                         */
                                                        wlock := BgUI_LockWindow( window )
                                                        say( myscreen )
                                                        BgUI_UnlockWindow( wlock )
                                                        /*
                                                         *      Pick up the window signal.
                                                         */
                                                        GetAttr( WINDOW_SIGMASK, wo_window, {signal} )
                                                        /*
                                                         *      Event loop...
                                                         */
                                                        WHILE running = TRUE
                                                                Wait( signal )
                                                                WHILE ( rc := HandleEvent( wo_window )) <> WMHI_NOMORE
                                                                        SELECT rc
                                                                                CASE    WMHI_CLOSEWINDOW
                                                                                        running := FALSE
                                                                                CASE    ID_QUIT
                                                                                        running := FALSE
                                                                        ENDSELECT
                                                                ENDWHILE
                                                        ENDWHILE
                                                ELSE
                                                        WriteF( 'Unable to open the window\n' )
                                                ENDIF
                                                DisposeObject( wo_window )
                                        ELSE
                                            WriteF( 'Unable to create the window object\n' )
                                        ENDIF
                                        CloseScreen( myscreen )
                                ELSE
                                    WriteF( 'Unable to open the screen\n' )
                                ENDIF
                        ELSE
                            WriteF( 'Unknown screen mode\n' )
                        ENDIF
                        FreeScreenDrawInfo( wblock, dri )
                ELSE
                    WriteF( 'Unable to get DrawInfo\n' )
                ENDIF
                UnlockPubScreen( NIL, wblock )
        ELSE
            WriteF( 'Unable to lock the Workbench screen\n' )
        ENDIF
        CloseLibrary(bguibase)
    ELSE
        WriteF('Could not open the bgui.library\n')
    ENDIF
ENDPROC
