/*
**      AddButtons.e
**
**      (C) Copyright 1994 Paul Weterings.
**          All Rights Reserved.
**
**      Modified by Ian J. Einman, 4/26/96
**      Modified by Dominique Dutoit, 5/1/96
*/

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
       'intuition/gadgetclass',
       'graphics/text'
/*
 *      Object ID's. Please note that the ID's are shared
 *      between the menus and the gadget objects.
 */
CONST   ID_ADD = 21,
        ID_QUIT= 22,
        ID_INS=23,
        ID_REM=24
/*
 *      Simple button creation macros.
 */
#define AddButton\
    ButtonObject,\
        LAB_LABEL,              'Added',\
        LAB_STYLE,              FSF_BOLD,\
        FuzzButtonFrame,\
    EndObject

#define InsButton\
    ButtonObject,\
        LAB_LABEL,              'Inserted',\
        LAB_STYLE,              FSF_BOLD,\
        FuzzButtonFrame,\
    EndObject

#define FuzzButton(label,id)\
    ButtonObject,\
        LAB_LABEL,              label,\
        LAB_UNDERSCORE,         "_",\
        GA_ID,                  id,\
        FuzzButtonFrame,\
    EndObject

PROC main()
        DEF window
        DEF wo_window, go_add, go_quit, go_ins, go_rem
        DEF addobj[20]:ARRAY OF LONG, base
        DEF signal = 0, rc
        DEF running = TRUE, ok = FALSE
        DEF x = 0, xx
        DEF simplemenu

        /*
        *      Simple menu strip.
        */
        simplemenu := [ Title( 'Project' ),
                            Item( 'Add',        'A',    ID_ADD ),
                            Item( 'Insert',     'I',    ID_INS ),
                            Item( 'Remove All', 'R',    ID_REM ),
                            ItemBar,
                            Item( 'Quit',       'Q',    ID_QUIT),
                        End ]:newmenu

        /*
        **      Open the library.
        **/
        IF bguibase := OpenLibrary( 'bgui.library', 0 )
                /*
                **      Create a window object.
                **/
                wo_window := WindowObject,
                        WINDOW_TITLE,           'Add/Insert Demo',
                        WINDOW_MENUSTRIP,       simplemenu,
                        WINDOW_LOCKHEIGHT,      TRUE,
                        WINDOW_AUTOASPECT,      TRUE,
                        WINDOW_AUTOKEYLABEL,    TRUE,
                        WINDOW_MASTERGROUP,
                                base := HGroupObject,
                                    StartMember, go_add  := FuzzButton( '_Add',        ID_ADD  ), EndMember,
                                    StartMember, go_ins  := FuzzButton( '_Insert',     ID_INS  ), EndMember,
                                    StartMember, go_rem  := FuzzButton( '_Remove all', ID_REM  ), EndMember,
                                    StartMember, go_quit := FuzzButton( '_Quit',       ID_QUIT ), EndMember,
                                EndObject,
                        EndObject

                /*
                **      Object created OK?
                **/
                IF ( wo_window )
                        /*
                        **      Open up the window.
                        **/
                        IF ( window := WindowOpen( wo_window ) )
                                /*
                                **      Obtain signal mask.
                                **/
                                GetAttr( WINDOW_SIGMASK, wo_window, {signal} )
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
                                        WHILE ( rc := HandleEvent( wo_window )) <> WMHI_NOMORE
                                                SELECT rc
                                                        CASE    WMHI_CLOSEWINDOW
                                                                running := FALSE
                                                        CASE    ID_QUIT
                                                                running := FALSE
                                                        CASE    ID_ADD
                                                                IF ( x = 19 )
                                                                    WriteF( 'Max Nr. of gadgets\n' )
                                                                ELSE
                                                                    INC x
                                                                    WindowClose( wo_window )

                                                                    addobj[ x ] := AddButton

                                                                    ok := domethod( base, [ GRM_ADDMEMBER,      addobj[ x ],
                                                                                            LGO_FIXMINHEIGHT,   FALSE,
                                                                                            LGO_WEIGHT,         DEFAULT_WEIGHT,
                                                                                            TAG_END ] )

                                                                    window := WindowOpen( wo_window )

                                                                    IF ( ok = 0 ) OR ( window = 0 )
                                                                        domethod( base, [ GRM_REMMEMBER, addobj[ x ], TAG_END ] )
                                                                        DEC x
                                                                        window := WindowOpen( wo_window )
                                                                        WriteF( 'Last object did not fit!\n' )
                                                                    ENDIF
                                                                ENDIF
                                                        CASE    ID_REM
                                                                IF ( x > 0 )
                                                                    WindowClose( wo_window )

                                                                    FOR xx := 1 TO x
                                                                        domethod( base, [ GRM_REMMEMBER, addobj[ xx ], TAG_END ] )
                                                                    ENDFOR

                                                                    window := WindowOpen( wo_window )
                                                                    x := 0
                                                                ELSE
                                                                    WriteF( 'Were out of gadgets!\n' )
                                                                ENDIF
                                                        CASE    ID_INS
                                                                IF ( x = 19 )
                                                                    WriteF( 'Max Nr. of gadgets\n' )
                                                                ELSE
                                                                    INC x
                                                                    WindowClose( wo_window )

                                                                    addobj[ x ] := InsButton

                                                                    ok := domethod( base, [ GRM_INSERTMEMBER,   addobj[ x ], go_rem,
                                                                                            LGO_FIXMINHEIGHT,   FALSE,
                                                                                            LGO_WEIGHT,         DEFAULT_WEIGHT,
                                                                                            TAG_END ] )

                                                                    window := WindowOpen( wo_window )

                                                                    IF ( ok = 0 ) OR ( window = 0 )
                                                                        domethod( base, [ GRM_REMMEMBER, addobj[ x ], TAG_END ] )
                                                                        DEC x
                                                                        window := WindowOpen( wo_window )
                                                                        WriteF( 'Last object did not fit!\n' )
                                                                    ENDIF
                                                                ENDIF
                                                ENDSELECT
                                        ENDWHILE
                                ENDWHILE
                        ELSE
                            WriteF( 'Unable to open the window\n' )
                        ENDIF
                        /*
                        **      Disposing of the object
                        **      will automatically close the window
                        **      and dispose of all objects that
                        **      are attached to the window.
                        **/
                        DisposeObject( wo_window )
                ELSE
                        WriteF( 'Unable to create a window object\n' )
                ENDIF
                CloseLibrary(bguibase)
        ELSE
                WriteF( 'Unable to open the bgui.library\n' )
        ENDIF
ENDPROC NIL
