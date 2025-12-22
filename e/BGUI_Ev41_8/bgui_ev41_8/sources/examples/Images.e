/* Updated on 11-Aug-96 */

OPT OSVERSION=37
OPT PREPROCESS

MODULE  'libraries/bgui',
        'libraries/bguim',
        'libraries/gadtools',
        'bgui',
        'tools/boopsi',
        'utility/tagitem',
        'exec/memory',
        'intuition/screens',
        'intuition/intuition',
        'intuition/classes',
        'intuition/classusr',
        'intuition/gadgetclass'

/*
**  Put up a simple requester.
**/
PROC req( win:PTR TO window, gadgets, body:PTR TO CHAR )
    DEF flags
    flags   := BREQF_LOCKWINDOW OR BREQF_CENTERWINDOW OR BREQF_AUTO_ASPECT OR BREQF_FAST_KEYS
ENDPROC BgUI_RequestA( win, [ flags, NIL, gadgets, body, NIL, NIL, "_", 0, NIL, 0]:bguiRequest, NIL)

/*
**  Object ID's.
**/
#define ID_QUIT                 1
#define ID_HELP                 2

PROC copyListToChip(data)
  DEF size, mem
  size:=ListLen(data)*SIZEOF LONG
  mem:=NewM(size, MEMF_CHIP)
  CopyMemQuick(data, mem, size)
ENDPROC mem

PROC main()
    DEF window:PTR TO window
    DEF wo_window, go_quit, go_help
    DEF signal = 0, rc
    DEF running = TRUE
    DEF helpi1:image, helpi2:image

    IF ( bguibase := OpenLibrary( 'bgui.library', BGUIVERSION ) )
        helpi1:=[ 0,   -> Upper left corner
                  0,
                  37,  -> width
                  26,  -> height
                  2,   -> depth
                  copyListToChip( /* Plane 0 */
                            [ $0000,$0020,$0000,$00A0,$0020,$0000,$0143,$E020,
                            $0000,$0A8F,$F820,$0000,$051C,$7C3F,$E000,$0038,
                            $3E00,$0000,$0038,$3E00,$0800,$00FF,$BFFF,$0800,
                            $003C,$3E00,$0800,$07FF,$FF3F,$0800,$0000,$7C00,
                            $0800,$06FF,$7FFD,$0800,$0000,$7000,$0800,$07F7,
                            $FAE7,$0800,$0000,$E000,$0800,$07DE,$FBFD,$0800,
                            $0000,$C000,$0800,$06FD,$F7EF,$0800,$0001,$C000,
                            $0800,$0003,$E000,$0800,$0003,$E1B7,$0800,$0003,
                            $E000,$0800,$0001,$C000,$0800,$0000,$0000,$0800,
                            $0000,$0000,$0800,$7FFF,$FFFF,$F800,
                            /* Plane 1 */
                            $FFFF,$FFD0,$0000,$FEAF,$FFDC,$0000,$FD5C,$1FDF,
                            $0000,$E0B0,$27DF,$C000,$F06B,$9BC0,$0000,$FFD7,
                            $DDFF,$F000,$FFD7,$DDFF,$F000,$FF18,$5C00,$F000,
                            $FFDB,$DDFF,$F000,$F800,$18C0,$F000,$FFFF,$BBFF,
                            $F000,$F900,$B002,$F000,$FFFF,$AFFF,$F000,$F808,
                            $2518,$F000,$FFFF,$5FFF,$F000,$F821,$4402,$F000,
                            $FFFF,$3FFF,$F000,$F902,$8810,$F000,$FFFE,$BFFF,
                            $F000,$FFFD,$DFFF,$F000,$FFFD,$DE48,$F000,$FFFD,
                            $DFFF,$F000,$FFFE,$3FFF,$F000,$FFFF,$FFFF,$F000,
                            $FFFF,$FFFF,$F000,$0000,$0000,$0000 ]:INT), -> image data
                  3, -> planepick
                  0,    -> planeonoff
                  NIL]:image

        helpi2:=[ 0,   -> Upper left corner
                  0,
                  37,  -> width
                  26,  -> height
                  2,   -> depth
                  copyListToChip( /* Plane 0 */
                            [ $0000,$0020,$0000,$00A0,$0020,$0000,$0140,$E020,
                            $0000,$0A81,$F020,$0000,$0501,$F03F,$E000,$0001,
                            $F000,$0000,$0001,$F000,$0800,$00FF,$F7FF,$0800,
                            $0000,$E000,$0800,$07FB,$FF3F,$0800,$0000,$E000,
                            $0800,$06FF,$FFFD,$0800,$0000,$E000,$0800,$07F7,
                            $FAE7,$0800,$0000,$4000,$0800,$07DE,$FBFD,$0800,
                            $0000,$4000,$0800,$06FD,$F7EF,$0800,$0000,$E000,
                            $0800,$0001,$F000,$0800,$0001,$F1B7,$0800,$0001,
                            $F000,$0800,$0000,$E000,$0800,$0000,$0000,$0800,
                            $0000,$0000,$0800,$7FFF,$FFFF,$F800,
                            /* Plane 1 */
                            $FFFF,$FFD0,$0000,$FEAF,$FFDC,$0000,$FD5F,$1FDF,
                            $0000,$E0BE,$EFDF,$C000,$F07E,$EFC0,$0000,$FFFE,
                            $EFFF,$F000,$FFFE,$EFFF,$F000,$FF00,$4800,$F000,
                            $FFFF,$5FFF,$F000,$F804,$40C0,$F000,$FFFF,$5FFF,
                            $F000,$F900,$4002,$F000,$FFFF,$5FFF,$F000,$F808,
                            $0518,$F000,$FFFF,$BFFF,$F000,$F821,$0402,$F000,
                            $FFFF,$BFFF,$F000,$F902,$0810,$F000,$FFFF,$5FFF,
                            $F000,$FFFE,$EFFF,$F000,$FFFE,$EE48,$F000,$FFFE,
                            $EFFF,$F000,$FFFF,$1FFF,$F000,$FFFF,$FFFF,$F000,
                            $FFFF,$FFFF,$F000,$0000,$0000,$0000]:INT), -> image data
                  3, -> planepick
                  0,    -> planeonoff
                  NIL]:image

        wo_window := WindowObject,
            WINDOW_Title,           'Image Demo',
            WINDOW_AutoAspect,      TRUE,
            WINDOW_AutoKeyLabel,    TRUE,
            WINDOW_MasterGroup,
                VGroupObject, NormalOffset, NormalSpacing,
                    StartMember,
                        go_help := ButtonObject,
                            BUTTON_Image,           helpi1,
                            BUTTON_SelectedImage,   helpi2,
                            LAB_Label,              '_Help',
                            LAB_Underscore,         "_",
                            LAB_Place,              PLACE_LEFT,
                            FRM_Type,               FRTYPE_BUTTON,
                            FRM_EdgesOnly,          TRUE,
                            GA_ID,                  ID_HELP,
                        EndObject,
                    EndMember,
                    StartMember,
                        HGroupObject,
                            VarSpace( 50 ),
                            StartMember, go_quit  := KeyButton( '_Quit',  ID_QUIT  ), EndMember,
                            VarSpace( 50 ),
                        EndObject, FixMinHeight,
                    EndMember,
                EndObject,
        EndObject

        /*
        **  Object created OK?
        **/
        IF ( wo_window )
            IF ( window := WindowOpen( wo_window ))
                /*
                **  Obtain it's wait mask.
                **/
                GetAttr( WINDOW_SigMask, wo_window, {signal} );
                /*
                **  Event loop...
                **/
                WHILE running = TRUE
                    Wait( signal )
                    /*
                    **  Handle events.
                    **/
                    WHILE (( rc := HandleEvent( wo_window )) <> WMHI_NOMORE )
                        /*
                        **  Evaluate return code.
                        **/
                        SELECT rc
                            CASE    WMHI_CLOSEWINDOW
                                    running := FALSE
                            CASE    ID_QUIT
                                    running := FALSE
                            CASE    ID_HELP
                                    req( window, '_Continue', ISEQ_C + 'This small demo shows you how to use\n'+
                                              'standard intuition images in button objects.' )
                        ENDSELECT
                    ENDWHILE
                ENDWHILE
            ELSE
                WriteF( 'Could not open the window\n' )
            ENDIF
            /*
            **  Disposing of the window object will
            **  also close the window IF it is
            **  already opened and it will dispose of
            **  all objects attached to it.
            **/
            DisposeObject( wo_window )
        ELSE
            WriteF( 'Could not create the window object\n' )
        ENDIF
        CloseLibrary( bguibase )
    ELSE
        WriteF( 'Can''t open bgui.library v41\n' )
    ENDIF
ENDPROC

