/*
** ColorWheel.e
**
** Copyright © 1995 Jaba Development.
** Copyright © 1995 Jan van den Baard.
** All rights Reserved.
**
** E version by Dominique Dutoit - ddutoit@arcadis.be
**/
OPT PREPROCESS

MODULE 'exec/types',
       'exec/libraries',
       'exec/memory',
       'dos/dos',
       'libraries/bgui',
       'libraries/bgui_macros',
       'libraries/gadtools',
       'bgui',
       'tools/boopsi',
       'utility/tagitem',
       'intuition/classes',
       'intuition/classusr',
       'intuition/gadgetclass',
       'intuition/intuition',
       'intuition/sghooks',
       'intuition/screens',
       'graphics/displayinfo',
       'graphics/modeid',
       'graphics/view',
       'colorwheel',
       'gadgets/colorwheel',
       'gadgets/gradientslider',
       'workbench/workbench',
       'workbench/startup'

/* Library base pointers */
DEF gradientsliderbase=NIL

/* Object ID's */
CONST ID_QUIT = 1, ID_WHEEL = 2

/* Structure for LoadRGB32() */
OBJECT load32
    len:INT
    pen:INT
    red:LONG
    grn:LONG
    blu:LONG
ENDOBJECT

/* Ensure correct operation on ECS */
CONST GRADCOLORS=4

/*
**      And were off.
**/
PROC main()
    DEF     wd_obj, running = TRUE, rc = 0, signal
    DEF     ga_wheel, ga_grslider, ga_master, ga_quit, realslider:PTR TO object
    DEF     win:PTR TO window
    DEF     scr:PTR TO screen
    DEF     colortable[ 96 ]:ARRAY OF LONG
    DEF     color_list[ 17 ]:ARRAY OF load32
    DEF     penns[ 17 ]:ARRAY OF INT
    DEF     rgb:colorwheelrgb
    DEF     hsb:colorwheelhsb
    DEF     modeid = HIRES_KEY
    DEF     numpens, i
    DEF     displayhandle
    DEF     scrdimensioninfo:PTR TO dimensioninfo

    IF KickVersion(39) = NIL
        WriteF('\nYou need OS3.x to run this program\n')
    ELSE
        IF bguibase := OpenLibrary( 'bgui.library', BGUIVERSION )
            IF colorwheelbase := OpenLibrary( 'gadgets/colorwheel.gadget', 39 )
                IF gradientsliderbase := OpenLibrary( 'gadgets/gradientslider.gadget', 39 )
                    IF displayhandle := FindDisplayInfo( modeid )
                        IF GetDisplayInfoData( displayhandle, scrdimensioninfo, SIZEOF dimensioninfo, DTAG_DIMS, NIL )
                            IF  scr := OpenScreenTagList( NIL,
                                                           [SA_DEPTH,           scrdimensioninfo.maxdepth,
                                                            SA_SHAREPENS,       TRUE,
                                                            SA_LIKEWORKBENCH,   TRUE,
                                                            SA_INTERLEAVED,     TRUE,
                                                            SA_TITLE,           'Color Wheel Screen',
                                                            TAG_END] )
                                GetRGB32( scr.viewport.colormap, 0, 32, colortable )

                                rgb.red   := colortable[ 0 ]
                                rgb.green := colortable[ 1 ]
                                rgb.blue  := colortable[ 2 ]
                                
                                ConvertRGBToHSB( rgb, hsb )

                                numpens := 0

                                WHILE ( numpens < GRADCOLORS )
                                    hsb.brightness := Shl(Shl($FFFF - (Mul((Div($FFFF,GRADCOLORS)), numpens)),8),8)
                                    /* Convert this dim level to RGB value */
                                    ConvertHSBToRGB( hsb, rgb )
                                    /* Allocate a pen */
                                    penns[ numpens ] := ObtainPen( scr.viewport.colormap, -1, rgb.red, rgb.green, rgb.blue, PEN_EXCLUSIVE )
                                    IF penns[ numpens ] = -1 THEN JUMP endme
                                    /* stuff it in the color list */
                                    color_list[ numpens ].len := 1
                                    color_list[ numpens ].pen := penns[ numpens ]
                                    /* next */
                                    INC numpens
                                ENDWHILE
                            endme:
                                penns[ numpens ] := -1
                                color_list[ numpens ].len := 0

                                ga_grslider := ExternalObject,
                                            EXT_MINWIDTH,       10,
                                            EXT_MINHEIGHT,      10,
                                            EXT_CLASSID,        'gradientslider.gadget',
                                            EXT_NOREBUILD,      TRUE,
                                            GRAD_PENARRAY,      penns,
                                            PGA_FREEDOM,        LORIENT_VERT,
                                            TAG_END,
                                            EndObject

                                IF ( ga_grslider )
                                    GetAttr( EXT_OBJECT, ga_grslider, {realslider} )
                                ENDIF

                                wd_obj := WindowObject,
                                    WINDOW_TITLE,           'Color Wheel',
                                    WINDOW_SCREEN,          scr,
                                    WINDOW_AUTOASPECT,      TRUE,
                                    WINDOW_SCALEWIDTH,      20,
                                    WINDOW_SCALEHEIGHT,     20,
                                    WINDOW_NOBUFFERRP,      TRUE,
                                    WINDOW_RMBTRAP,         TRUE,
                                    WINDOW_AUTOKEYLABEL,    TRUE,
                                    WINDOW_MASTERGROUP,
                                        ga_master := VGroupObject, NormalSpacing, NormalOffset,
                                            StartMember, TitleSeparator( 'Wheel & Slider' ), EndMember,
                                            StartMember,
                                                HGroupObject, NormalSpacing,
                                                     StartMember,
                                                         /*
                                                         **      The EXT_NOREBUILD tag may _not_ be set to
                                                         **      TRUE for a colorwheel object. This is due
                                                         **      to the fact that colorwheels cannot change
                                                         **      size. This is also the reason why we need
                                                         **      to track the attributes of the colorwheel.
                                                         **/
                                                         ga_wheel := ExternalObject,
                                                             EXT_MINWIDTH,           80,
                                                             EXT_MINHEIGHT,          80,
                                                             EXT_CLASSID,            'colorwheel.gadget',
                                                             WHEEL_SCREEN,           scr,
                                                             /*
                                                             **      Pass a pointer to the "real" gradient slider
                                                             **      here.
                                                             **/
                                                             WHEEL_GRADIENTSLIDER,   realslider,
                                                             WHEEL_RED,              colortable[ 0 ],
                                                             WHEEL_GREEN,            colortable[ 1 ],
                                                             WHEEL_BLUE,             colortable[ 2 ],
                                                             GA_FOLLOWMOUSE,         TRUE,
                                                             GA_ID,                  ID_WHEEL,
                                                             /*
                                                             **      These attributes of the colorwheel are
                                                             **      tracked and reset to the object after
                                                             **      it has been rebuild. This way the current
                                                             **      colorwheel internals will not be lost
                                                             **      after the object is re-build.
                                                             **/
                                                             EXT_TRACKATTR,          WHEEL_RED,
                                                             EXT_TRACKATTR,          WHEEL_GREEN,
                                                             EXT_TRACKATTR,          WHEEL_BLUE,
                                                             EXT_TRACKATTR,          WHEEL_HUE,
                                                             EXT_TRACKATTR,          WHEEL_SATURATION,
                                                             EXT_TRACKATTR,          WHEEL_BRIGHTNESS,
                                                         EndObject,
                                                     EndMember,
                                                     /*
                                                     **      Add the externalclass object of the
                                                     **      gradient slider here. Right next to
                                                     **      the colorwheel :)
                                                     **/
                                                     StartMember,
                                                         ga_grslider, FixWidth( 20 ),
                                                     EndMember,
                                                EndObject,
                                            EndMember,
                                            StartMember, HorizSeparator, EndMember,
                                            StartMember,
                                                HGroupObject,
                                                    VarSpace( DEFAULT_WEIGHT ),
                                                    StartMember, ga_quit := KeyButton( '_Quit', ID_QUIT ), EndMember,
                                                    VarSpace( DEFAULT_WEIGHT ),
                                                EndObject, FixMinHeight,
                                            EndMember,
                                        EndObject,
                                EndObject

                                IF wd_obj
                                    IF win := WindowOpen( wd_obj )
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

                                                                    CASE    ID_WHEEL
                                                                            GetAttr( WHEEL_HSB, ga_wheel, hsb )

                                                                            i := 0

                                                                            WHILE ( i < numpens )
                                                                                hsb.brightness := Shl(Shl($FFFF - (Mul((Div($FFFF,numpens)), i)),8),8)

                                                                                ConvertHSBToRGB( hsb, rgb )

                                                                                color_list[ i ].red := rgb.red
                                                                                color_list[ i ].grn := rgb.green
                                                                                color_list[ i ].blu := rgb.blue

                                                                                INC i
                                                                            ENDWHILE

                                                                            LoadRGB32( scr.viewport, color_list )
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

                                    /*
                                    **      Release the allocated pens.
                                    **/
                                    WHILE ( numpens > 0 )
                                        DEC numpens
                                        ReleasePen( scr.viewport.colormap, penns[ numpens ] )
                                    ENDWHILE
                                ELSE
                                    WriteF( 'Unable to create a window object\n' )
                                ENDIF
                                CloseScreen( scr )
                            ELSE
                                WriteF( 'Unable to open your screen\n' )
                            ENDIF
                        ENDIF
                    ENDIF
                    CloseLibrary( gradientsliderbase )
                ENDIF
                CloseLibrary( colorwheelbase )
            ENDIF
            CloseLibrary( bguibase )
        ELSE
            WriteF( 'Unable to open the bgui.library\n' )
        ENDIF
    ENDIF
ENDPROC NIL
