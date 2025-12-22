/*
**      CXDEMO.E
**
**      (C) Copyright 1996 Marco Talamelli.
**          All Rights Reserved.
**/

OPT OSVERSION=37
OPT PREPROCESS

MODULE  'libraries/bgui',
        'libraries/bgui_macros',
        'libraries/gadtools',
	'libraries/commodities',
        'bgui',
	'dos/dos',
        'tools/boopsi',
        'utility/tagitem',
	'intuition/screens',
	'intuition/intuition',
        'intuition/classes',
        'intuition/classusr',
        'intuition/gadgetclass'

/*
**      Key ID.
**/
#define CX_F1_PRESSED           1

/*
**      Gadget ID's.
**/
#define ID_HIDE                 1
#define ID_QUIT                 2

PROC main()

DEF	cm_broker, wn_window, ga_hide, ga_quit,
        signal = 0, winsig = 0, sigrec, type, id, rc,
        running = FALSE,infotxt:PTR TO CHAR

/*
**      Information text.
**/
	infotxt := '\ec\eb\ed8'+
                 'CxDemo\n\n\ed2\en'+
                 'This is a small "do-nothing" example of how\n'+
                 'to use the BGUI commodity class.\n'+
                 'In this example F1 is the Hotkey used to\n'+
                 'signal the broker to open the window.'

        /*
        **      Open the library.
        **/
IF bguibase := OpenLibrary( 'bgui.library', 37 )

        /*
        **      Setup a commodity object.
        **/
        cm_broker := CommodityObject,
                COMM_NAME,              'CxDemo',
                COMM_TITLE,             'Simple BGUI broker.',
                COMM_DESCRIPTION,       'Does not do anything usefull.',
                COMM_SHOWHIDE,          TRUE,
        EndObject

        /*
        **      Object OK?
        **/
        IF cm_broker
                /*
                **      Create a small window.
                **/
                wn_window := WindowObject,
                        WINDOW_TITLE,           'CxDemo',
                        WINDOW_RMBTRAP,         TRUE,
                        WINDOW_SIZEGADGET,      FALSE,  /* No use in this window. */
                        WINDOW_AUTOASPECT,      TRUE,
                        WINDOW_MASTERGROUP,
                                VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BACKFILL, SHINE_RASTER,
                                        StartMember,
                                                InfoObject, ButtonFrame,
                                                        FRM_FLAGS,              FRF_RECESSED,
                                                        INFO_TEXTFORMAT,        infotxt,
                                                        INFO_FIXTEXTWIDTH,      TRUE,
                                                        INFO_MINLINES,          6,
                                                EndObject,
                                        EndMember,
                                        StartMember,
                                                HGroupObject, Spacing( 4 ),
                                                        StartMember, ga_hide := KeyButton( '_Hide', ID_HIDE ), EndMember,
                                                        VarSpace( DEFAULT_WEIGHT ),
                                                        StartMember, ga_quit := KeyButton( '_Quit', ID_QUIT ), EndMember,
                                                EndObject, FixMinHeight,
                                        EndMember,
                                EndObject,
                EndObject

                /*
                **      Window OK?
                **/
                IF wn_window
                        /*
                        **      Add F1 as hotkey.
                        **/
                        IF AddHotkey( cm_broker, 'f1', CX_F1_PRESSED, 0 )
                                /*
                                **      Add gadget keys.
                                **/
                                GadgetKey( wn_window, ga_hide, 'h' )
                                GadgetKey( wn_window, ga_quit, 'q' )
                                /*
                                **      Obtain broker signal mask.
                                **/
                                GetAttr( COMM_SIGMASK, cm_broker, {signal} )
                                /*
                                **      Activate the broker.
                                **/
                                EnableBroker( cm_broker )
                                /*
                                **      Open up the window.
                                **/
                                IF WindowOpen( wn_window )
                                        /*
                                        **      Obtain window sigmask.
                                        **/
                                        GetAttr( WINDOW_SIGMASK, wn_window, {winsig} )
                                        /*
                                        **      Wait for messages.
                                        **/
                                        REPEAT
                                                sigrec := Wait( signal OR winsig OR SIGBREAKF_CTRL_C )
                                                /*
                                                **      Broker signal?
                                                **/
                                                IF ( sigrec AND signal )
                                                        /*
                                                        **      Obtain the messages from the
                                                        **      broker.
                                                        **/
                                                        WHILE MsgInfo( cm_broker, {type}, {id}, NIL ) <> CMMI_NOMORE
                                                                /*
                                                                **      Evaluate message.
                                                                **/
                                                                SELECT type

                                                                        CASE    CXM_IEVENT
                                                                                SELECT id

                                                                                        CASE    CX_F1_PRESSED
                                                                                                IF WindowOpen( wn_window )
                                                                                                   GetAttr( WINDOW_SIGMASK, wn_window, {winsig} )
												ENDIF
                                                                                ENDSELECT

                                                                        CASE    CXM_COMMAND
                                                                                SELECT id

                                                                                        CASE    CXCMD_KILL
                                                                                                WriteF( 'bye bye\n' )
                                                                                                running := TRUE

                                                                                        CASE    CXCMD_DISABLE
                                                                                                WriteF( 'broker disabled\n' )
                                                                                                DisableBroker( cm_broker )

                                                                                        CASE    CXCMD_ENABLE
                                                                                                WriteF( 'broker enabled\n' )
                                                                                                EnableBroker( cm_broker )

                                                                                        CASE    CXCMD_UNIQUE
												  IF WindowOpen( wn_window )
                                                                                                        GetAttr( WINDOW_SIGMASK, wn_window, {winsig} )
												  ENDIF
                                                                                        CASE    CXCMD_APPEAR
                                                                                                  IF WindowOpen( wn_window )
                                                                                                        GetAttr( WINDOW_SIGMASK, wn_window, {winsig} )
												  ENDIF

                                                                                        CASE    CXCMD_DISAPPEAR
                                                                                                WindowClose( wn_window )
                                                                                                winsig := 0
                                                                                ENDSELECT
                                                                ENDSELECT
                                                        ENDWHILE
                                                ENDIF

                                                /*
                                                **      Window signal?
                                                **/
                                                IF ( sigrec AND winsig )
                                                        WHILE ( wn_window AND (( rc := HandleEvent( wn_window )) <> WMHI_NOMORE ))
                                                                SELECT rc

                                                                        CASE    ID_HIDE
                                                                                WindowClose( wn_window )
                                                                                winsig := 0
                                                                        CASE    WMHI_CLOSEWINDOW
                                                                                /*
                                                                                **      Hide the window.
                                                                                **/
                                                                                WindowClose( wn_window )
                                                                                winsig := 0

                                                                        CASE    ID_QUIT
                                                                                /*
                                                                                **      The end.
                                                                                **/
                                                                                WriteF( 'bye bye\n' )
                                                                                running := TRUE
                                                                ENDSELECT
                                                        ENDWHILE
                                                ENDIF

                                                /*
                                                **      CTRL+C?
                                                **/
                                                IF ( sigrec AND SIGBREAKF_CTRL_C )
                                                        WriteF( 'bye bye\n' )
                                                        running := TRUE
                                                ENDIF
                                        UNTIL running
                                ELSE
                                        WriteF( 'unable to open the window\n' )
				ENDIF
                        ELSE
                                WriteF( 'unable to add the hotkey\n' )
			ENDIF
                        DisposeObject( wn_window )
                ELSE
                        WriteF( 'unable to create a window object\n' )
		ENDIF
                DisposeObject( cm_broker )
        ELSE
                WriteF( 'unable to create a commodity object\n' )
	ENDIF
	CloseLibrary(bguibase)
ELSE
	WriteF('Could not open the bgui.library\n')
ENDIF
ENDPROC
