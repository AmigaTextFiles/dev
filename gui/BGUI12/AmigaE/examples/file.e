;/* Execute me to compile.
ec file
quit
*/
/*
**      A small example of BGUI in Amiga E.
**
**      I have little knowledge of the E language so
**      please forgive me if something is wrong or if
**      something could have been done easier.
**
**      GUI stolen from the EasyGUI (file.e) example. Sorry
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
        DEF     wd_obj, running = TRUE, rc = 0, signal, s1, s2, s3

        /*
        **      Open the library.
        **/
        IF bguibase := OpenLibrary( 'bgui.library', 37 )
                /*
                **      Create a window object.
                **/
                wd_obj := WindowObject,
                        WINDOW_TITLE,           'Select a file:',
                        WINDOW_RMBTRAP,         TRUE,
                        WINDOW_AUTOASPECT,      TRUE,
                        WINDOW_SCALEHEIGHT,     20,
                        WINDOW_MASTERGROUP,
                                /*
                                **      A vertical master group.
                                **/
                                VGroupObject, Spacing( 4 ), HOffset( 4 ), VOffset( 4 ),
                                        StartMember, ListviewObject, EndObject, EndMember,
                                        StartMember, s1 := TabString( 'Pattern', '#?.e', 200, 0 ), FixMinHeight, EndMember,
                                        StartMember, s2 := TabString( 'Drawer',  'E:',   200, 0 ), FixMinHeight, EndMember,
                                        StartMember, s3 := TabString( 'File',    '',     200, 0 ), FixMinHeight, EndMember,
                                        StartMember,
                                                HGroupObject, Spacing( 4 ),
                                                        StartMember, Button( 'OK', 0 ), EndMember,
                                                        StartMember, Button( 'Disks', 0 ), EndMember,
                                                        StartMember, Button( 'Parent', 0 ), EndMember,
                                                        StartMember, Button( 'Cancel', 0 ), EndMember,
                                                EndObject, FixMinHeight,
                                        EndMember,
                                EndObject,
                        EndObject

                /*
                **      Object created OK?
                **/
                IF wd_obj
                        /*
                        **      Setup tab-cycling.
                        **/
                        domethod( wd_obj, [ WM_TABCYCLE_ORDER, s1, s2, s3, NIL ] )
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
