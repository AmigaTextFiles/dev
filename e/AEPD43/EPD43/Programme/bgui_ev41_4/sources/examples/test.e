;/* Execute me to compile.
ec test
quit
*/
/*
**      A small example of BGUI in Amiga E.
**
**      I have little knowledge of the E language so
**      please forgive me if something is wrong or if
**      something could have been done easier.
**/
OPT OSVERSION=37
OPT PREPROCESS

MODULE 'libraries/bgui',
       'libraries/bgui_macros',
       'libraries/gadtools',
       'bgui',
       'tools/boopsi',
       'utility/tagitem',
       'intuition/classes',
       'intuition/classusr',
       'intuition/gadgetclass'

/*
**      Quit gadget/menu ID.
**/
CONST   ID_QUIT = 1

/*
**      And were off.
**/
PROC main()
        DEF     wd_obj, running = TRUE, rc = 0, signal
        DEF     gd_quit, info_text : PTR TO CHAR

        /*
        **      Text for the information class object.
        **/
        info_text := '\ecThis demonstration program shows you\n'+
                     'how you can use BGUI with \ebAmiga E\en.\n\n' +
                     'Since I only have little knowledge about this\n' +
                     'language it might be possible that the code\n' +
                     'looks a bit strange to you. Sorry...'

        /*
        **      Open the library.
        **/
        IF bguibase := OpenLibrary( 'bgui.library', 37 )
                /*
                **      Create a window object.
                **/
                wd_obj := WindowObject,
                        WINDOW_TITLE,         'BGUI in Amiga E',
                        /*
                        **    A very small menu strip.
                        **/
                        WINDOW_MENUSTRIP,
                                [ NM_TITLE, 0, 'Project', NIL, 0, 0, NIL,
                                  NM_ITEM,  0, 'Quit',    'Q', 0, 0, ID_QUIT,
                                  NM_END,   0, NIL,       NIL, 0, 0, NIL ] : newmenu,
                        WINDOW_AUTOASPECT,      TRUE,
                        WINDOW_MASTERGROUP,
                                /*
                                **      A vertical master group.
                                **/
                                VGroupObject, Spacing( 4 ), HOffset( 4 ), VOffset( 4 ), GROUP_BACKFILL, SHINE_RASTER,
                                        StartMember,
                                                InfoFixed( NIL, info_text, NIL, 6 ),
                                        EndMember,
                                        StartMember,
                                                HGroupObject,
                                                        VarSpace( DEFAULT_WEIGHT ),
                                                        StartMember, gd_quit := KeyButton( '_Quit', ID_QUIT ), EndMember,
                                                        VarSpace( DEFAULT_WEIGHT ),
                                                EndObject, FixMinHeight,
                                        EndMember,
                                EndObject,
                        EndObject

                /*
                **      Object created OK?
                **/
                IF wd_obj
                        /*
                        **      Attach hotkey for the quit gadget.
                        **/
                        IF GadgetKey( wd_obj, gd_quit, 'q' )
                                /*
                                **      Open up the window.
                                **/
                                IF WindowOpen( wd_obj )
                                        /*
                                        **      Obtain signal mask.
                                        **/
                                        GetAttr( WINDOW_SIGMASK, wd_obj, {signal} )
                                        /*
                                        **      Poll messages.
                                        **/
                                        WHILE running = TRUE
                                                /*
                                                **      Wait for the signal.
                                                **/
                                                Wait( signal )
                                                /*
                                                **      Call uppon the event handler.
                                                **/
                                                WHILE ( rc := HandleEvent( wd_obj )) <> WMHI_NOMORE
                                                        SELECT rc
                                                                CASE    WMHI_CLOSEWINDOW
                                                                        running := FALSE
                                                                CASE    ID_QUIT
                                                                        running := FALSE
                                                        ENDSELECT
                                                ENDWHILE
                                        ENDWHILE
                                ENDIF
                        ELSE
                                WriteF( 'Unable to attach hotkeys\n' );
                        ENDIF
                        /*
                        **      Disposing of the object
                        **      will automatically close the window
                        **      and dispose of all objects that
                        **      are attached to the window.
                        **/
                        DisposeObject( wd_obj )
                ELSE
                        WriteF( 'Unable to create a window object\n' )
                ENDIF
                CloseLibrary(bguibase)
        ELSE
                WriteF( 'Unable to open the bgui.library\n' )
        ENDIF
ENDPROC NIL
