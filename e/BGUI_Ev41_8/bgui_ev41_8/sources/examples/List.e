/*
**      List1.e
**
**      (C) Copyright 1995-1996 Jaba Development.
**      (C) Copyright 1995-1996 Jan van den Baard.
**          All Rights Reserved.
**
**      Modified by Dominique Dutoit, 5/1/96
**      Updated on 11-Aug-96
*/

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
 *      Object ID's.
 */
CONST   ID_QUIT= 1

/*
 *      Simple button creation macros.
 */
#define FuzzButton(label,id)\
    ButtonObject,\
        LAB_Label,              label,\
        LAB_Underscore,         "_",\
        GA_ID,                  id,\
        FuzzButtonFrame,\
    EndObject

PROC main()
        DEF window
        DEF wo_window, tabs, page
        DEF signal = 0, rc
        DEF running = TRUE
        DEF entries

        entries := [ 'Entry 1',
                     'Entry 2',
                     'Entry 3',
                     'Entry 4',
                     'Entry 5',
                     'Entry 6',
                     'Entry 7',
                     'Entry 8',
                     'Entry 9',
                     'Entry 10',
                     'Entry 11',
                     'Entry 12',
                     'Entry 13',
                     'Entry 14',
                     'Entry 15',
                     'Entry 16',
                     'Entry 17',
                     'Entry 18',
                     'Entry 19',
                     'Entry 20',
                     NIL ]

        /*
        **      Open the library.
        **/
        IF bguibase := OpenLibrary( 'bgui.library', BGUIVERSION )
                /*
                **      Build the window object tree.
                **/
                wo_window := WindowObject,
                        WINDOW_Title,           'Listview DragNDrop',
                        WINDOW_ScaleWidth,      25,
                        WINDOW_ScaleHeight,     20,
                        WINDOW_RMBTrap,         TRUE,
                        WINDOW_AutoAspect,      TRUE,
                        WINDOW_AutoKeyLabel,    TRUE,
                        WINDOW_MasterGroup,
                            VGroupObject, VOffset( 6 ), Spacing( 6 ),
                                StartMember,
                                    tabs := Tabs( NIL, [ 'Single-Select', 'Multi-Select', NIL ], 0, 0),
                                EndMember,
                                StartMember,
                                    page := PageObject,
                                    PageMember,
                                        VGroupObject, HOffset( 6 ), Spacing( 6 ),
                                            StartMember,
                                                InfoFixed( NIL, '\ecSingle-Select Drag-n-Drop\nListview object.', NIL, 2), FixMinHeight,
                                            EndMember,
                                            StartMember,
                                                /*
                                                 *  Create a draggable and droppable listview
                                                 *  and make it show the drop-spot.
                                                 */
                                                ListviewObject,
                                                    LISTV_EntryArray,       entries,
                                                    LISTV_ShowDropSpot,     TRUE,
                                                    BT_DragObject,          TRUE,
                                                    BT_DropObject,          TRUE,
                                                EndObject,
                                            EndMember,
                                        EndObject,
                                    PageMember,
                                        VGroupObject, HOffset( 6 ), Spacing( 6 ),
                                            StartMember,
                                                InfoFixed( NIL, '\ecMulti-Select Drag-n-Drop\nListview object.', NIL, 2 ), FixMinHeight,
                                            EndMember,
                                            StartMember,
                                            /*
                                             *  Create a multi-select, draggable and
                                             *  droppable listview and make it show
                                             *  the drop-spot.
                                             */
                                                ListviewObject,
                                                    LISTV_MultiSelect,  TRUE,
                                                    LISTV_EntryArray,   entries,
                                                    LISTV_ShowDropSpot, TRUE,
                                                    BT_DragObject,      TRUE,
                                                    BT_DropObject,      TRUE,
                                                EndObject,
                                            EndMember,
                                        EndObject,
                                    EndObject,
                                EndMember,
                                StartMember,
                                    HGroupObject,
                                        VarSpace( DEFAULT_WEIGHT ),
                                        StartMember, FuzzButton( '_Quit', ID_QUIT ), EndMember,
                                        VarSpace( DEFAULT_WEIGHT ),
                                    EndObject, FixMinHeight,
                                EndMember,
                            EndObject,
                    EndObject

                /*
                **      Object created OK?
                **/
                IF ( wo_window )
                        /*
                        **  Connect the cycle to page.
                        */
                        AddMap( tabs, page, [ MX_Active, PAGE_Active, TAG_END ] )
                        /*
                        **      Open up the window.
                        **/
                        IF ( window := WindowOpen( wo_window ) )
                                /*
                                **      Obtain signal mask.
                                **/
                                GetAttr( WINDOW_SigMask, wo_window, {signal} )
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
