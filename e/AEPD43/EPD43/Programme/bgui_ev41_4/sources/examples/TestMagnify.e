/*
** TestMagnify.e
**
** Original C codes (c) 1995 Reinhard Katzmann
** E codes (c) 1996 Dominique Dutoit
**
*/

OPT OSVERSION=37
OPT PREPROCESS

MODULE  'exec/types',
        'exec/memory',
        'exec/libraries',
        'libraries/asl',
        'libraries/bgui',
        'libraries/bgui_macros',
        'libraries/gadtools',
        'graphics/gfxmacros',
        'graphics/gfx',
        'graphics/rastport',
        'libraries/iff',
        'intuition/classes',
        'intuition/classusr',
        'intuition/gadgetclass',
        'intuition/intuition',
        'intuition/screens',
        'utility/tagitem',
        'tools/boopsi',

        'intuition',
        'graphics',
        'bgui',
        'iff',

        'gadgets/magnify_bgui',
        'magnify_bgui'

ENUM    ID_QUIT= 1, ID_LOAD, ID_SAVE, ID_ZOOM, ID_GRID, ID_EDIT, ID_REGX, ID_REGY

CONST   GADWIDTH = 320, GADHEIGHT = 150

DEF magnifyclass:PTR TO iclass, go_edit
DEF wo_window, filereq
DEF mbmapp:PTR TO bitmap, window:PTR TO window

PROC closeall()
    IF ( mbmapp)                THEN domethod( go_edit, [ MAGM_FREEBITMAP, {mbmapp} ] )
    IF ( filereq )              THEN DisposeObject( filereq )
    IF ( wo_window )            THEN DisposeObject( wo_window )
    IF ( bguimagnifybase )      THEN CloseLibrary( bguimagnifybase )
    IF ( bguibase )             THEN CloseLibrary( bguibase )
ENDPROC

PROC req( win:PTR TO window, gadgets, body:PTR TO CHAR )
    DEF flags
    flags   := BREQF_LOCKWINDOW OR BREQF_CENTERWINDOW OR BREQF_AUTO_ASPECT OR BREQF_FAST_KEYS
ENDPROC BgUI_RequestA( win, [ flags, NIL, gadgets, body, NIL, NIL, "_", 0, NIL, 0]:bguirequest, NIL)

PROC printifferror()
    DEF text:PTR TO CHAR, i

    i := IfFL_IFFError()

    SELECT i
        CASE    IFFL_ERROR_OPEN
                text := 'Can''t open file'
        CASE    IFFL_ERROR_READ
                text := 'Error reading file'
        CASE    IFFL_ERROR_NOMEM
                text := 'Not enough memory'
        CASE    IFFL_ERROR_NOTIFF
                text := 'Not an IFF file'
        CASE    IFFL_ERROR_NOBMHD
                text := 'No IFF BMHD found'
        CASE    IFFL_ERROR_NOBODY
                text := 'No IFF BODY found'
        CASE    IFFL_ERROR_BADCOMPRESSION
                text := 'Unsupported compression mode'
        DEFAULT
                text := 'Unspecified error'
    ENDSELECT

    req( window, '_Continue', ISEQ_C + text )
ENDPROC

PROC allocbm( width, height )
    DEF bm:PTR TO bitmap
    DEF screen:PTR TO screen
    DEF tbm:bitmap, rp:PTR TO rastport
    DEF attr

    IF ( KickVersion( 39 ) )
        screen := LockPubScreen( NIL )
        rp := screen.rastport
        attr := GetBitMapAttr( rp.bitmap, BMA_FLAGS )
        bm := AllocBitMap( width, height, 2, BMF_CLEAR OR attr, NIL )
        UnlockPubScreen( NIL, screen )
    ELSE
        tbm.bytesperrow := width/8
        tbm.rows := height
        tbm.depth := 2
        domethod( go_edit, [ MAGM_ALLOCBITMAP, {bm}, {tbm} ] )
    ENDIF
ENDPROC bm

PROC picload()
    DEF ifffile, screen:PTR TO screen, bmhd:PTR TO bmh, fname

    IF ( iffbase := OpenLibrary( 'iff.library', 19 ) )
        screen := LockPubScreen( NIL )
        IF ( filereq := FileReqObject, ASLFR_DOPATTERNS, TRUE, EndObject )
            IF ( screen )
                SetAttrsA( filereq, [ ASLFR_INITIALHEIGHT, screen.height-20] )
                UnlockPubScreen( NIL, screen )
            ENDIF
            IF ( ( DoRequest( filereq ) ) = FRQ_OK )
                GetAttr( FRQ_PATH, filereq, {fname} )
            ELSE
                RETURN FALSE
            ENDIF

            IF ( ( ifffile := IfFL_OpenIFF( fname, IFFL_MODE_READ ) ) = NIL )
                req( window, '_Continue', ISEQ_C + 'Not an ILBM picture' )
                RETURN FALSE
            ELSE
                IF ( bmhd := IfFL_GetBMHD( ifffile ) )
                    IF ( mbmapp ) THEN domethod( go_edit, [ MAGM_FREEBITMAP, {mbmapp } ] )
                    IF ( ( mbmapp := allocbm( bmhd.width, bmhd.height ) ) = 0 )
                        WriteF( 'FATAL: Could not allocate Bitmap\n')
                        IF ( ifffile ) THEN IfFL_CloseIFF( ifffile )
                        closeall()
                        quit()
                    ENDIF

                    IF ( IfFL_DecodePic( ifffile, mbmapp ) = 0 )
                        WriteF( 'FATAL: Could not decode picture.\n' )
                        printifferror()
                        IF ( ifffile ) THEN IfFL_CloseIFF( ifffile )
                        closeall()
                        quit()
                    ENDIF
                ELSE
                    printifferror()
                    RETURN FALSE
                ENDIF
            ELSE
                printifferror()
                RETURN FALSE
            ENDIF
        ELSE
            req( window, '_Continue', ISEQ_C + 'Could not open File Requester' )
            RETURN FALSE
        ENDIF
    ELSE
        WriteF( 'Could not open iff.library.\n' )
        RETURN FALSE
    ENDIF

    IF ( ifffile ) THEN IfFL_CloseIFF( ifffile )
ENDPROC TRUE

PROC picsave()
    DEF screen:PTR TO screen
    DEF fname

    IF ( iffbase := OpenLibrary( 'iff.library', 19 ) )
        screen := LockPubScreen( NIL )

        IF ( filereq := FileReqObject, ASLFR_DOPATTERNS, TRUE, EndObject )
            IF ( screen )
                SetAttrsA( filereq, [ ASLFR_INITIALHEIGHT, screen.height-20, TAG_END ] )
                UnlockPubScreen( NIL, screen )
            ENDIF
            SetAttrsA( filereq, [ ASLFR_DOSAVEMODE, TRUE, TAG_END ] )

            IF ( DoRequest( filereq ) )
                GetAttr( FRQ_PATH, filereq, {fname} )
            ELSE
                RETURN FALSE
            ENDIF
        ELSE
            req( window, '_Continue', ISEQ_C + 'Could not open File Requester' )
        ENDIF
    ELSE
        WriteF( 'Could not open iff.library.\n' )
        closeall()
        quit()
    ENDIF
ENDPROC

PROC quit()
    JUMP quitme
ENDPROC

PROC main()
    DEF go_quit, go_s, go_l, go_zoom, go_grid
    DEF go_regx, go_regy, ind
    DEF signal, rc, regx, regy, factor = 1, grid = 0
    DEF running = TRUE, infotxt:PTR TO CHAR

    infotxt := ISEQ_C + ISEQ_B + 'Magnify Demo in AmigaE!\n\n' + ISEQ_N +
                        'You can edit the picture in the big Gadget\n' +
                        'and change the magnification of the picture\n'+
                        'with the scroller beside the Grid gadget.\n'+
                        'Load/Save of brushes into the edit gadget.\n'+
                        '(WARNING: Only 2 Bitplanes are used here.)'

    IF ( bguibase := OpenLibrary( 'bgui.library', BGUIVERSION ) )
        IF ( bguimagnifybase := OpenLibrary( 'gadgets/magnify_bgui.gadget', 39 ) )
            magnifyclass := MaGNIFY_GetClassPtr()

            go_edit := NewObjectA( magnifyclass, NIL, [ FRM_TYPE,               FRTYPE_BUTTON,
                                                        MAGNIFY_GRAPHWIDTH,     GADWIDTH,
                                                        MAGNIFY_GRAPHHEIGHT,    GADHEIGHT,
                                                        MAGNIFY_CURRENTPEN,     1,
                                                        GA_ID,                  ID_EDIT,
                                                        TAG_END ] )
            IF ( go_edit )
                IF ( mbmapp := allocbm( GADWIDTH, GADHEIGHT ) )
                    SetGadgetAttrsA( go_edit, window, NIL, [ MAGNIFY_PICAREA, mbmapp, TAG_END ] )

                    wo_window := WindowObject,
                                    WINDOW_TITLE,           'MagnifyClass Demo',
                                    WINDOW_AUTOASPECT,      TRUE,
                                    WINDOW_SMARTREFRESH,    TRUE,
                                    WINDOW_RMBTRAP,         TRUE,
                                    WINDOW_AUTOKEYLABEL,    TRUE,
                                    WINDOW_IDCMP,           IDCMP_MOUSEMOVE,
                                    WINDOW_MASTERGROUP,
                                        VGroupObject, HOffset(4), VOffset(4), Spacing(4),
                                            GROUP_BACKFILL,         SHINE_RASTER,
                                            StartMember,
                                                InfoFixed( NIL, infotxt, NIL, 7 ),
                                            EndMember,
                                            StartMember,
                                                HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing(4),
                                                    FRM_TYPE,       FRTYPE_BUTTON,
                                                    FRM_RECESSED,   TRUE,
                                                    StartMember, go_grid := KeyCheckBox('_Grid',FALSE,ID_GRID), EndMember,
                                                    StartMember, go_zoom := KeyHorizScroller('_Zoom', 0, 11, 1, ID_ZOOM), EndMember,
                                                    StartMember, ind := IndicatorFormat(0, 10, 0, IDJ_CENTER, '\d'), FixWidth(16), EndMember,
                                                EndObject, FixMinHeight,
                                            EndMember,
                                            StartMember,
                                                VGroupObject, VOffset( 4 ), HOffset( 4 ),
                                                    StartMember, HGroupObject,
                                                        StartMember, go_edit, FixWidth((GADWIDTH/8)*8), FixHeight((GADHEIGHT/8)*8), EndMember,
                                                        StartMember, go_regy := VertScroller(NIL, 0, mbmapp.rows, GADHEIGHT, ID_REGY), FixMinWidth, EndMember,
                                                    EndObject, EndMember,
                                                    StartMember, go_regx := HorizScroller(NIL, 0, Mul(mbmapp.bytesperrow,8), GADWIDTH, ID_REGX), FixMinHeight, FixWidth(Mul(Div(GADWIDTH,8),8)+6), EndMember,
                                                EndObject,
                                            EndMember,
                                            StartMember,
                                                HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing(4),
                                                    StartMember, go_l := KeyButton( '_Load', ID_LOAD ), EndMember,
                                                    StartMember, go_s := KeyButton( '_Save', ID_SAVE ), EndMember,
                                                    StartMember, go_quit := KeyButton( '_Quit', ID_QUIT ), EndMember,
                                                EndObject, FixMinHeight,
                                            EndMember,
                                        EndObject,
                                    EndObject

                    IF ( wo_window )
                        AddMap( go_zoom, ind, [ PGA_TOP, INDIC_LEVEL, TAG_END ] )
                        IF ( window := WindowOpen( wo_window ) )
                            GetAttr( WINDOW_SIGMASK, wo_window, {signal} )

                            WHILE running = TRUE
                                Wait( signal )

                                WHILE ( rc := HandleEvent( wo_window )) <> WMHI_NOMORE
                                    SELECT rc
                                        CASE    WMHI_CLOSEWINDOW
                                                running := FALSE
                                        CASE    ID_QUIT
                                                running := FALSE
                                        CASE    ID_LOAD
                                                IF ( picload() )
                                                    SetGadgetAttrsA( go_edit, window, NIL, [ MAGNIFY_PICAREA, mbmapp, TAG_END ] )
                                                    SetGadgetAttrsA( go_regx, window, NIL, [ PGA_TOTAL, mbmapp.bytesperrow*8, TAG_END ] )
                                                    SetGadgetAttrsA( go_regy, window, NIL, [ PGA_TOTAL, mbmapp.rows, TAG_END ] )
                                                    SetGadgetAttrsA( go_regx, window, NIL, [ PGA_VISIBLE, Div(GADWIDTH,(factor+grid)), TAG_END ] )
                                                    SetGadgetAttrsA( go_regy, window, NIL, [ PGA_VISIBLE, Div(GADHEIGHT,(factor+grid)), TAG_END ] )
                                                ENDIF
                                                IF ( iffbase ) THEN CloseLibrary( iffbase )
                                        CASE    ID_SAVE
                                                picsave()
                                                IF ( iffbase ) THEN CloseLibrary( iffbase )
                                        CASE    ID_REGX
                                                GetAttr( PGA_TOP, go_regx, {regx} )
                                                SetGadgetAttrsA( go_edit, window, NIL, [ MAGNIFY_SELECTREGIONX, regx, TAG_END ] )
                                        CASE    ID_REGY
                                                GetAttr( PGA_TOP, go_regy, {regy} )
                                                SetGadgetAttrsA( go_edit, window, NIL, [ MAGNIFY_SELECTREGIONY, regy, TAG_END ] )
                                        CASE    ID_GRID
                                                GetAttr( GA_SELECTED, go_grid, {grid} )
                                                IF ( grid ) THEN grid := 1
                                                IF ( grid = 1 )
                                                    SetGadgetAttrsA( go_edit, window, NIL, [ MAGNIFY_GRID, TRUE, TAG_END ] )
                                                ELSE
                                                    SetGadgetAttrsA( go_edit, window, NIL, [ MAGNIFY_GRID, FALSE, TAG_END ] )
                                                ENDIF
                                                IF ( ( factor+grid) <> 0 )
                                                    SetGadgetAttrsA( go_regx, window, NIL, [ PGA_VISIBLE, Div(GADWIDTH,(factor+grid)), TAG_END ] )
                                                    SetGadgetAttrsA( go_regy, window, NIL, [ PGA_VISIBLE, Div(GADHEIGHT,(factor+grid)), TAG_END ] )
                                                ENDIF
                                        CASE    ID_ZOOM
                                                GetAttr( PGA_TOP, go_zoom, {factor} )
                                                INC factor
                                                SetGadgetAttrsA( go_edit, window, NIL, [ MAGNIFY_MAGFACTOR, factor, TAG_END ] )
                                                SetGadgetAttrsA( go_regx, window, NIL, [ PGA_VISIBLE, Div(GADWIDTH,(factor+grid)), TAG_END ] )
                                                SetGadgetAttrsA( go_regy, window, NIL, [ PGA_VISIBLE, Div(GADHEIGHT,(factor+grid)), TAG_END ] )
                                    ENDSELECT
                                ENDWHILE
                            ENDWHILE
                        ELSE
                            WriteF( 'Can''t open window.\n' )
                        ENDIF
                    ELSE
                        WriteF( 'Can''t create window.\n' )
                    ENDIF
                ELSE
                    WriteF( 'Can''t allocate bitmap.\n' )
                ENDIF
            ELSE
                WriteF( 'Can''t create Edit Object.\n' )
            ENDIF
        ELSE
            WriteF( 'Can''t open gadget/magnify_bgui.gadget.\n' )
        ENDIF
    ELSE
        WriteF( 'Can''t open bgui.library.\n' )
    ENDIF
    closeall()
quitme:
ENDPROC

