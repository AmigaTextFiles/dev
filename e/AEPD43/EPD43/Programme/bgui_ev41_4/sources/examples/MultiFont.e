/*
 *  MULTIFONT.E
 *
 *  (C) Copyright 1996 Marco Talamelli.
 *      All Rights Reserved.
 *
 *  Modified by Dominique Dutoit to use more standard fonts (times and helvetica).
 */

OPT OSVERSION=37
OPT PREPROCESS

MODULE  'libraries/bgui',
        'libraries/bgui_macros',
        'libraries/gadtools',
        'bgui',
        'diskfont',
        'tools/boopsi',
        'utility/tagitem',
        'intuition/screens',
        'intuition/intuition',
        'intuition/classes',
        'graphics/text',
        'intuition/classusr',
        'intuition/gadgetclass'

CONST   ID_QUIT=1

PROC main()

    DEF button:PTR TO textfont,info1:PTR TO textfont,info2:PTR TO textfont,
        window:PTR TO window,
        wo_window, go_quit,
        signal, rc,
        running = TRUE

    /*
    **      Open the library.
    **/
    IF bguibase := OpenLibrary( 'bgui.library', BGUIVERSION )

        /*
         *  We need this one to open the fonts.
         */
        IF diskfontbase := OpenLibrary( 'diskfont.library', 36 )
            /*
             *  We open the fonts ourselves since BGUI
             *  opens all fonts with OpenFont() which
             *  means that they have to be resident
             *  in memory.
             */
            IF button := OpenDiskFont( [ 'helvetica.font', 13, FS_NORMAL, FPF_DISKFONT ]:textattr )
                IF info1 := OpenDiskFont( [ 'times.font', 15, FS_NORMAL, FPF_DISKFONT ]:textattr )
                    IF info2 := OpenDiskFont( [ 'helvetica.font', 24,  FS_NORMAL, FPF_DISKFONT ]:textattr )
                        /*
                         *  Create the window object.
                         */
                        wo_window := WindowObject,
                            WINDOW_TITLE,           'Multi-Font Demo',
                            WINDOW_AUTOASPECT,      TRUE,
                            WINDOW_LOCKHEIGHT,      TRUE,
                            WINDOW_RMBTRAP,         TRUE,
                            WINDOW_AUTOKEYLABEL,    TRUE,
                            WINDOW_MASTERGROUP,
                                VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BACKFILL, SHINE_RASTER,
                                    StartMember,
                                        VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 2 ),
                                            FRM_TYPE,       FRTYPE_BUTTON,
                                            FRM_RECESSED,       TRUE,
                                            StartMember,
                                                InfoObject,
                                                    INFO_TEXTFORMAT,    '\ec\ed8MultiFont',
                                                    INFO_HORIZOFFSET,   0,
                                                    INFO_VERTOFFSET,    0,
                                                    INFO_FIXTEXTWIDTH,  TRUE,
                                                    INFO_MINLINES,      1,
                                                    BT_TEXTATTR,        [ 'helvetica.font', 24, FS_NORMAL, FPF_DISKFONT ]:textattr,
                                                EndObject,
                                            EndMember,
                                            StartMember,
                                                SeperatorObject,SEP_HORIZ,TRUE,EndObject, FixMinHeight,
                                            EndMember,

                                            StartMember,
                                                InfoObject,
                                                    INFO_TEXTFORMAT,    '\ecThis demo shows you how you\ncan use different fonts inside a\nsingle window.',
                                                    INFO_HORIZOFFSET,   0,
                                                    INFO_VERTOFFSET,    0,
                                                    INFO_FIXTEXTWIDTH,  TRUE,
                                                    INFO_MINLINES,      3,
                                                    BT_TEXTATTR,        [ 'helvetica.font', 13,  FS_NORMAL, FPF_DISKFONT ]:textattr,
                                                EndObject,
                                            EndMember,

                                        EndObject,
                                    EndMember,
                                    StartMember,
                                        HGroupObject,
                                            VarSpace( 50 ),

                                            StartMember,
                                                go_quit := ButtonObject,
                                                    LAB_LABEL,  '_Quit',
                                                    LAB_UNDERSCORE, "_",
                                                    ButtonFrame,
                                                    GA_ID,      ID_QUIT,
                                                    BT_TEXTATTR,    [ 'times.font', 15, FS_NORMAL, FPF_DISKFONT ]:textattr,
                                                EndObject,
                                            EndMember,
                                            VarSpace( 50 ),
                                        EndObject, FixMinHeight,
                                    EndMember,
                                EndObject,
                        EndObject

                        /*
                         *  Object created OK?
                         */
                        IF wo_window
                            /*
                             *  try to open the window.
                             */
                            IF window := WindowOpen( wo_window )
                                /*
                                 *  Obtain it's wait mask.
                                 */
                                GetAttr( WINDOW_SIGMASK, wo_window, {signal} )
                                /*
                                 *  Event loop...
                                 */
                                WHILE running = TRUE
                                    Wait( signal )
                                    /*
                                     *  Handle events.
                                     */
                                    WHILE ( rc := HandleEvent( wo_window )) <> WMHI_NOMORE
                                        /*
                                         *  Evaluate return code.
                                         */
                                        SELECT rc

                                            CASE    WMHI_CLOSEWINDOW
                                                running := FALSE
                                            CASE    ID_QUIT
                                                running := FALSE
                                        ENDSELECT
                                    ENDWHILE
                                ENDWHILE
                            ELSE
                                WriteF('Could not open the window\n')
                            ENDIF
                            /*
                             *  Disposing of the window object will
                             *  also close the window if it is
                             *  already opened and it will dispose of
                             *  all objects attached to it.
                             */
                            DisposeObject( wo_window )
                        ELSE
                            WriteF('Could not create the window object\n')
                        ENDIF
                        CloseFont( info2 )
                    ELSE
                        WriteF('Could not open helvetica.font, 24\n')
                    ENDIF
                    CloseFont( info1 )
                ELSE
                    WriteF('Could not open times.font, 15\n')
                ENDIF
                CloseFont( button )
            ELSE
                WriteF('Could not open helvetica.font, 13\n')
            ENDIF
            CloseLibrary( diskfontbase )
        ELSE
            WriteF('Could not open diskfont.library\n')
        ENDIF
        CloseLibrary( bguibase )
    ELSE
        WriteF('Could not open the bgui.library\n')
    ENDIF
ENDPROC
