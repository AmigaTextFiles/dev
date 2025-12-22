/*
 *      COLORS.E
 *
 *      (C) Copyright 1995 Jaba Development.
 *      (C) Copyright 1995 Jan van den Baard.
 *          All Rights Reserved.
 */

OPT OSVERSION=37
OPT PREPROCESS

MODULE 	'libraries/bgui',
       	'libraries/bgui_macros',
       	'libraries/gadtools',
       	'bgui',
       	'tools/boopsi',
       	'utility/tagitem',
	'intuition/screens',
	'intuition/intuition',
       	'intuition/classes',
       	'intuition/classusr',
       	'intuition/gadgetclass'

/*
**      Object ID's.
**/
#define ID_ALT                  1
#define ID_QUIT                 2

PROC main()

DEF	wo_window, window:PTR TO window,go_quit, go_b1,go_b2, go_alt,
        signal, rc, tmp = 0,
         running = FALSE, info_text : PTR TO CHAR

        /*
        **      Text for the information class object.
        **/
        info_text := '\ecThis small demo shows you how you can\n'+
                     'change the background and label colors\n'+
                     'of an object on the fly.\n\n'+
                     'As you can see the colors of the below buttons\n'+
                     'are normal but when the \ebAlternate\en checkbox\n'+
                     'is selected the colors are changed.'

        /*
        **      Open the library.
        **/
        IF bguibase := OpenLibrary( 'bgui.library', 37 )
        /*
         *      Create the window object.
         */
        wo_window := WindowObject,
                WINDOW_TITLE,           'Colors Demo',
                WINDOW_AUTOASPECT,      TRUE,
                WINDOW_SMARTREFRESH,    TRUE,
                WINDOW_RMBTRAP,         TRUE,
                WINDOW_MASTERGROUP,
                                /*
                                **      A vertical master group.
                                **/
                        VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BACKFILL, SHINE_RASTER,
                                StartMember,
                                        InfoFixed( NIL, info_text, NIL, 7 ),
                                EndMember,
                                StartMember,
                                        HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), FRM_TYPE, FRTYPE_BUTTON, FRM_RECESSED, TRUE,
                                                StartMember, go_b1:= Button( 'Colors', 0 ), EndMember,
                                                StartMember, go_b2:=Button( 'Demo',   0 ), EndMember,
                                        EndObject, FixMinHeight,
                                EndMember,
                                StartMember,
                                        HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), FRM_TYPE, FRTYPE_BUTTON, FRM_RECESSED, TRUE,
                                                VarSpace( DEFAULT_WEIGHT ),
                                                StartMember, go_alt := KeyCheckBox( '_Alternate', FALSE, ID_ALT ), EndMember,
                                                VarSpace( DEFAULT_WEIGHT ),
                                        EndObject, FixMinHeight,
                                EndMember,
                                StartMember,
                                        HGroupObject,
                                                VarSpace( DEFAULT_WEIGHT ),
                                                StartMember, go_quit := KeyButton( '_Quit', ID_QUIT ), EndMember,
                                                VarSpace( DEFAULT_WEIGHT ),
                                        EndObject, FixMinHeight,
                                EndMember,
                        EndObject,
        EndObject

        /*
        **      Object created OK?
        **/
        IF wo_window
                /*
                **      Assign the keys to the buttons.
                **/
                tmp :=tmp + GadgetKey( wo_window, go_quit,  'q' )
                tmp :=tmp + GadgetKey( wo_window, go_alt,   'a' )
                /*
                **      OK?
                **/
                IF tmp=2
                        /*
                        **      try to open the window.
                        **/
                        IF window := WindowOpen( wo_window )
                                /*
                                **      Obtain it's wait mask.
                                **/
                                GetAttr( WINDOW_SIGMASK, wo_window, {signal} )
                                /*
                                **      Event loop...
                                **/
                                REPEAT
                                                /*
                                                **      Wait for the signal.
                                                **/
                                        Wait( signal )
                                        /*
                                        **      Handle events.
                                        **/
                                        WHILE ( rc := HandleEvent( wo_window )) <> WMHI_NOMORE
                                                /*
                                                **      Evaluate return code.
                                                **/
                                                SELECT rc

                                                        CASE    WMHI_CLOSEWINDOW
                                                                running := TRUE
                                                        CASE    ID_QUIT
                                                                running := TRUE
                                                        CASE    ID_ALT
                                                                /*
                                                                 *      When the object is selected we use
                                                                 *      alternate coloring on the objects.
                                                                 *      If not we revert to default coloring.
                                                                 */
                                                               GetAttr( GA_SELECTED, go_alt, {tmp})
                                                                /*
                                                                 *      Setup the colors on the buttons.
                                                                 */
                                                                        SetGadgetAttrsA(go_b1, window, NIL,
                                                                                [FRM_BACKDRIPEN, IF tmp THEN TEXTPEN ELSE -1,
                                                                                FRM_SELECTEDBACKDRIPEN, IF tmp THEN SHINEPEN ELSE -1,
                                                                                LAB_DRIPEN, IF tmp THEN SHINEPEN ELSE -1,
                                                                                LAB_SELECTEDDRIPEN, IF tmp THEN TEXTPEN ELSE -1,
                                                                                TAG_END] )
                                                                        SetGadgetAttrsA(go_b2, window, NIL,
                                                                                [FRM_BACKDRIPEN, IF tmp THEN TEXTPEN ELSE -1,
                                                                                FRM_SELECTEDBACKDRIPEN, IF tmp THEN SHINEPEN ELSE -1,
                                                                                LAB_DRIPEN, IF tmp THEN SHINEPEN ELSE -1,
                                                                                LAB_SELECTEDDRIPEN, IF tmp THEN TEXTPEN ELSE -1,
                                                                                TAG_END] )
                                                ENDSELECT
                                        ENDWHILE
                                UNTIL running
                        ELSE
                                WriteF( 'Could not open the window\n' )
			ENDIF
                ELSE
                        WriteF( 'Could not assign gadget keys\n' )
		ENDIF
                /*
                **      Disposing of the window object will
                **      also close the window if it is
                **      already opened and it will dispose of
                **      all objects attached to it.
                **/
                DisposeObject( wo_window )
        ELSE
                WriteF( 'Could not create the window object\n' )
	ENDIF
	CloseLibrary( bguibase )
	ELSE
		WriteF('Could not open the bgui.library\n')
	ENDIF
ENDPROC