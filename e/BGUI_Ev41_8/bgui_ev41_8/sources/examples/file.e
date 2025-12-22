;/* Execute me to compile.
ec file
quit
*/
/*
**      A small example of BGUI in Amiga E.
**
**      GUI stolen from the EasyGUI (file.e) example. Sorry
**      Wouter, I could not resist ;)
**
**      Updated on 10-Aug-96
**/
OPT OSVERSION=37
OPT PREPROCESS

MODULE 'libraries/bgui',
       'libraries/bguim',
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
        IF bguibase := OpenLibrary( 'bgui.library', BGUIVERSION )
                /*
                **      Create a window object.
                **/
                wd_obj := WindowObject,
                        WINDOW_Title,           'Select a file:',
                        WINDOW_RMBTrap,         TRUE,
                        WINDOW_AutoAspect,      TRUE,
                        WINDOW_ScaleHeight,     20,
                        WINDOW_AutoKeyLabel,    TRUE,
                        WINDOW_MasterGroup,
                                /*
                                **      A vertical master group.
                                **/
                                VGroupObject, Spacing( 4 ), HOffset( 4 ), VOffset( 4 ),
                                        StartMember, ListviewObject, EndObject, EndMember,
                                        StartMember, s1 := TabKeyString( 'P_attern', '#?.e', 200, 0 ), FixMinHeight, EndMember,
                                        StartMember, s2 := TabKeyString( '_Drawer',  'E:',   200, 0 ), FixMinHeight, EndMember,
                                        StartMember, s3 := TabKeyString( '_File',    '',     200, 0 ), FixMinHeight, EndMember,
                                        StartMember,
                                                HGroupObject, Spacing( 4 ),
                                                        StartMember, KeyButton( '_OK', 0 ), EndMember,
                                                        StartMember, KeyButton( '_Volumes', 0 ), EndMember,
                                                        StartMember, KeyButton( '_Parent', 0 ), EndMember,
                                                        StartMember, KeyButton( '_Cancel', 0 ), EndMember,
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
                                GetAttr( WINDOW_SigMask, wd_obj, {signal} )
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
