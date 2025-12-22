;/* Execute me to compile.
ec dm
quit
*/
/*
**      A small example of BGUI in Amiga E.
**
**      I have little knowledge of the E language so
**      please forgive me if something is wrong or if
**      something could have been done easier.
**
**      GUI stolen from the EasyGUI (dm.e) example. Sorry
**      Wouter, I could not resist ;)
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
**      And were off.
**/
PROC main()
        DEF     wd_obj, running = TRUE, rc = 0, signal

        /*
        **      Open the library.
        **/
        IF bguibase := OpenLibrary( 'bgui.library', 37 )
                /*
                **      Create a window object.
                **/
                wd_obj := WindowObject,
                        WINDOW_TITLE,           'E FileManager v0.1',
                        WINDOW_RMBTRAP,         TRUE,
                        WINDOW_AUTOASPECT,      TRUE,
                        WINDOW_MASTERGROUP,
                                /*
                                **      A vertical master group.
                                **/
                                VGroupObject, Spacing( 4 ), HOffset( 4 ), VOffset( 4 ),
                                        StartMember,
                                                HGroupObject, Spacing( 4 ),
                                                        StartMember,
                                                                VGroupObject,
                                                                        StartMember, ListviewObject, EndObject, EndMember,
                                                                        StartMember, StringG( NIL, '', 200, 0 ), FixMinHeight, EndMember,
                                                                EndObject,
                                                        EndMember,
                                                        StartMember,
                                                                VGroupObject, Spacing( 2 ),
                                                                        StartMember, Button( 'DF0:', 0 ), EndMember,
                                                                        StartMember, Button( 'DF1:', 0 ), EndMember,
                                                                        StartMember, Button( 'HD0:', 0 ), EndMember,
                                                                        StartMember, Button( 'HD1:', 0 ), EndMember,
                                                                        StartMember, Button( 'CD0:', 0 ), EndMember,
                                                                        StartMember, Button( 'Ram:', 0 ), EndMember,
                                                                        StartMember, Button( 'System:', 0 ), EndMember,
                                                                        StartMember, Button( 'Work:', 0 ), EndMember,
                                                                        StartMember, Button( 'E:', 0 ), EndMember,
                                                                EndObject, FixMinHeight, FixMinWidth,
                                                        EndMember,
                                                        StartMember,
                                                                VGroupObject,
                                                                        StartMember, ListviewObject, EndObject, EndMember,
                                                                        StartMember, StringG( NIL, '', 200, 0 ), FixMinHeight, EndMember,
                                                                EndObject,
                                                        EndMember,
                                                EndObject,
                                        EndMember,
                                        StartMember,
                                                HGroupObject, Spacing( 2 ), EqualWidth,
                                                        StartMember, Button( 'Parent', 0 ), EndMember,
                                                        StartMember, Button( 'Copy', 0 ), EndMember,
                                                        StartMember, Button( 'Move', 0 ), EndMember,
                                                        StartMember, Button( 'Rename', 0 ), EndMember,
                                                        StartMember, Button( 'Delete', 0 ), EndMember,
                                                        StartMember, Button( 'MakeDir', 0 ), EndMember,
                                                EndObject, FixMinHeight,
                                        EndMember,
                                        StartMember,
                                                HGroupObject, Spacing( 2 ), EqualWidth,
                                                        StartMember, Button( 'All', 0 ), EndMember,
                                                        StartMember, Button( 'Clear', 0 ), EndMember,
                                                        StartMember, Button( 'Toggle', 0 ), EndMember,
                                                        StartMember, Button( 'Size', 0 ), EndMember,
                                                        StartMember, Button( 'View', 0 ), EndMember,
                                                        StartMember, Button( 'Config', 0 ), EndMember,
                                                EndObject, FixMinHeight,
                                        EndMember,
                                EndObject,
                        EndObject

                /*
                **      Object created OK?
                **/
                IF wd_obj
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
                                                ENDSELECT
                                        ENDWHILE
                                ENDWHILE
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
