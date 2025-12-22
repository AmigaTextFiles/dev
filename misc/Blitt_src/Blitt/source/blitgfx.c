
/*________________________________________________________________________
 |                                                                        |
 |    blitgfx.c v1.0  - (c) 1992  Paul Juhasz                             |
 |                                                                        |
 |      Started:    16. Jun. 92                                           |
 |      Finished:   24. Sep. 92                                           |
 |                                                                        |
 |      Object:     to experiment with the blitter by cut out             |
 |                  brushes which can be overlaid on DPaint graphics      |
 |                  to see the immediate result of minterms               |
 |________________________________________________________________________*/


#include    "blitdefs.h"
#include    <clib/macros.h>

extern  struct  Custom          custom;
extern  struct  CIA            *cia;

extern  struct  IntuitionBase  *IntuitionBase;
extern  struct  GfxBase        *GfxBase;

extern  struct  Screen         *bl_screen;
extern  struct  Window         *bl_window;
extern  struct  RastPort        bl_rast_port;
extern  struct  RasInfo         bl_ras_info;
extern  struct  BitMap          bl_bit_map;

extern  struct  Screen         *pan_screen;
extern  struct  Window         *pan_window;
extern  struct  Window         *text_window;
extern  struct  BitMap          pan_bit_map;
extern  struct  Gadget          pan_close, filerq, brush, bltmode, undo,
                                reso, about, mskhlp, msk_lf, msk_rt,
                                minthlp, mint_lf, mint_rt, depth,
                                no_gadget, string_gad;

extern  struct  RastPort        wk_rast_port;
extern  struct  RasInfo         wk_ras_info;
extern  struct  BitMap          wk_bit_map;

extern  struct  RastPort        bs_rast_port;
extern  struct  RasInfo         bs_ras_info;
extern  struct  BitMap          bs_bit_map;

extern  struct  RastPort        ms_rast_port;
extern  struct  RasInfo         ms_ras_info;
extern  struct  BitMap          ms_bit_map;

extern  struct  BitMap          iff_bitmap;

extern  UWORD  *pan_point, *arr_point, *clk_point, *src_point, *msk_point;


/*________________________________________________________________________
 |                                                                        |
 |           15,  07,  31,  11,       ON           = 99                   |
 |           87,  07,  50,  25,       Files        =  1                   |
 |          149,  07,  50,  25,       Brush        =  2                   |
 |          211,  07,  50,  25,       blit/mask    =  3                   |
 |          273,  07,  50,  25,       undo         =  4                   |
 |           15,  28,  56,  24,       resol        =  5                   |
 |           87,  38, 236,  14,       BLITT        =  6                   |
 |          424,  11,  64,  14,       Mask:        =  7                   |
 |          499,  11,  11,   7,        left top    =  8                   |
 |          499,  18,  11,   7,        left bot    =  8                   |
 |          562,  11,  11,   7,        rght top    =  9                   |
 |          562,  18,  11,   7,        rght bot    =  9                   |
 |          393,  36,  95,  14,       Minterm:     = 10                   |
 |          499,  36,  11,   7,        left top    = 11                   |
 |          499,  43,  11,   7,        left bot    = 11                   |
 |          562,  36,  11,   7,        right top   = 12                   |
 |          562,  43,  11,   7,        right bot   = 12                   |
 |          592,  07,  31,  11,       Depth        = 13                   |
 |            0,   0, 319, 193,       Brush activ  = 77, 75               |
 |          520,  09,  32,  18,       Flgs displ                          |
 |          520,  34,  32,  18,       Mint displ                          |
 |          338,  12,  67,  13,       Mouse displ                         |
 |                                                                        |
 |  struct  BlitVar     {                                                 |
 |              UWORD           mpx, mpy, ppy, brusw, brx, bry,           |
 |                              msx, msy, brw, brh;                       |
 |              WORD            ofx, ofy, LIMX, LIMY, CMISE;              |
 |          };                                                            |
 |                                                                        |
 |________________________________________________________________________*/

WORD  blitt()
{
    extern struct BlitVar  *bv;
    static      ULONG       signals = 0, panSigMask = 0, blSigMask = 0;
    register    UWORD       gad     = 0;
    static      BOOL        btyp    = FALSE, panup = TRUE;
    static      UBYTE       pmask   = 0x0f, minterm = 0xb0;


    bv->brx = bv->bry = bv->brw = bv->brh = bv->msx = bv->msy =
                        bv->ppy = bv->mpx = bv->mpy = bv->ofx = bv->ofy = 0;
    bv->brusw = gad = 0;
    btyp = FALSE;
    panup = TRUE;

    pmask = do_wheels( pmask, 2, 9 );      /*       Set up mask and       */
    minterm = do_wheels( minterm, 1, 34 ); /*        minterm displays...  */

    do_undo( TRUE );        /*  and copy picture and colourmap to screen  */

    ScreenToFront( pan_screen );
    ActivateWindow( bl_window );
    panSigMask = 1L << pan_window->UserPort->mp_SigBit;
    blSigMask = 1L << bl_window->UserPort->mp_SigBit;

    box_tool( bv, bv->brusw );        /*        initialize box variables  */

    while ( gad != 99 ) {
        signals = Wait( panSigMask | blSigMask );
        if ( signals & panSigMask )     gad = readIDCMP( pan_window, bv );
        else
            if ( signals & blSigMask )  gad = readIDCMP( bl_window, bv );
            else                        gad = 0;

        switch ( gad ) {
            case 77:                  /*      LMB pressed, start brush... */
                if (( bv->brusw < BRSH_FLO ) && ( bv->brusw & BRSH_ON )) {
                    if ( btyp && ( bv->brusw < MASK_DEF )) {
                        bv->msx = bv->mpx;
                        bv->msy = bv->mpy;
                        bv->brusw |= MASK_DEF;
                    }
                    if ( bv->brusw < BRSH_DEF && !( bv->brusw & MASK_DEF )) {
                        bv->brx = bv->mpx;
                        bv->bry = bv->mpy;
                        bv->brusw |= BRSH_DEF;
                        box_tool( bv, bv->brusw );
                    }
                } else {              /*  ...or put down the existing one */
                    if ( bv->brusw & BRSH_FLO ) {
                        box_tool( bv, MSE_MOVE );
                        do_blit( btyp, pmask, minterm );
                        box_tool( bv, bv->brusw );
                    }
                }
                break;
            case 75:                  /*    LMB released, brush defined.  */
                if (( bv->brusw<BRSH_FLO ) && ( bv->brusw&BRSH_ON )) {
                    if ( btyp && ( bv->brusw & MASK_DEF )) {
                        bv->brusw ^= MASK_DEF;
                        bv->brusw |= MASK_END;
                        BltBitMap( &bl_bit_map, bv->msx, bv->msy,
                                    &ms_bit_map,0,0, bv->LIMX, bv->LIMY,
                                    0xc0, 0xff );
                        SetPointer( bl_window,src_point,15,16,0,0 );
                    }
                    if ( bv->brusw & BRSH_DEF ) { /*        brush size    */
                        bv->brw = MIN( bv->mpx - bv->brx+1, bv->LIMX );
                        bv->brh = MIN( bv->mpy - bv->bry+1, bv->LIMY );
                        if ( bv->brw < 1 )      bv->brw = 1;
                        if ( bv->brh < 1 )      bv->brh = 1;
                        box_tool( bv, BRSH_ON );
                        bv->brusw ^= BRSH_DEF;
                        bv->brusw |= BRSH_FLO;
                        BltBitMap( &bl_bit_map, bv->brx, bv->bry,
                                    &bs_bit_map, 0, 0, bv->brw, bv->brh,
                                    0xc0, 0xff );
                        box_tool( bv, bv->brusw );
                        SetPointer( bl_window,pan_point,9,16,0,0 );
                    }
                }
                break;
            case 88:
                if ( panup ) while ( pan_screen->TopEdge < bv->CMISE )
                                MoveScreen( pan_screen, 0, 4 );
                else while ( pan_screen->TopEdge > bv->CMISE-57 )
                        MoveScreen( pan_screen, 0, -4 );
                gad = 0;
                panup = !panup;
                RethinkDisplay();
                break;
            case 99:
                ScreenToBack( pan_screen );
                ScreenToBack( bl_screen );
                RemakeDisplay();
                break;                /*    'Sure to quit?' requester...  */
            case 1:
                if ( filereq() != 0 ) { /*          Save the screen       */
                    DisplayBeep( pan_screen );
                    ScreenToFront( pan_screen );
                }
                ActivateWindow( bl_window );
                break;
            case 2:
                bv->brusw = ( bv->brusw & BRSH_ON ) ? 0 : BRSH_ON;
                if ( !bv->brusw && ( brush.Flags & SELECTED )) {
                    brush.Flags ^= SELECTED;
                    RefreshGList( &brush, pan_window, 0, 1 );
                }
                if ( bv->brusw )
                    if ( btyp )
                        SetPointer( bl_window,msk_point,16,16,0,0 );
                    else
                        SetPointer( bl_window,src_point,15,16,0,0 );
                break;
            case 3:
                if ( brush.Flags & SELECTED ) {
                    bltmode.Flags ^= SELECTED;
                    RefreshGList( &bltmode, pan_window, 0, 1 );
                } else {
                    btyp = !btyp;
                }
                break;
            case 4:
                box_tool( bv, MSE_MOVE );
                do_undo( TRUE );
                box_tool( bv, bv->brusw );
                break;
            case 5:
                break;
            case 6:
                do_about( MAIN_HELP );
                break;
            case 7:
                do_about( MASK_HELP );
                break;
            case 8:
                pmask = do_wheels( pmask, ( bv->ppy<18 ) ? 1 : 2, 9 );
                break;
            case 9:
                pmask = do_wheels( pmask, ( bv->ppy<18 ) ? 3 : 4, 9 );
                break;
            case 10:
                do_about( MINT_HELP );
                break;
            case 11:
                minterm = do_wheels( minterm, ( bv->ppy<43 )?1:2, 34 );
                break;
            case 12:
                minterm = do_wheels( minterm, ( bv->ppy<43 )?3:4, 34 );
                break;
            case 13:
                ScreenToBack( pan_screen );
                ScreenToBack( bl_screen );
                RemakeDisplay();
                break;
            default:
                break;
        }
        if ( bv->brusw & BRSH_ON ) {
            ActivateWindow( bl_window );
        } else {
            bv->brx = bv->bry = bv->brw = bv->brh =
              bv->msx = bv->msy = bv->ppy = bv->ofx = bv->ofy = 0;
            box_tool( bv, bv->brusw );
            SetPointer( bl_window,arr_point,9,16,0,0 );
        }
    }                                 /*        Exit if Close selected    */
    return( BLK );
}


/*________________________________________________________________________
 |                                                                        |
 |             This is the main decision point                            |
 |________________________________________________________________________*/

UWORD readIDCMP( struct Window *win, struct BlitVar *bv )
{
    static   struct Gadget         *gadad   = 0;
    register    UWORD               gad     = 0;
    register struct IntuiMessage   *message = NULL;
    UWORD                           code    = 0;
    ULONG                           class   = 0;
    APTR                            address = 0;

    gad = 0;
    while ( message = ( struct IntuiMessage *)GetMsg( win->UserPort )) {
        class = message->Class;
        code  = message->Code;        /*   get message, store it away...  */
        if ( win == bl_window ) {
            bv->mpx = message->MouseX;
            bv->mpy = message->MouseY;
        } else bv->ppy = message->MouseY;
        address = message->IAddress;
        ReplyMsg( message );          /*         ...and reply to it       */

        switch ( class ) {

            case MOUSEMOVE:
                coords( bv );         /*         print mouse coordinates  */
                box_tool( bv, MSE_MOVE|BRSH_FLO|BRSH_DEF );
                break;

            case GADGETDOWN:          /*            Left button pressed   */
                gadad = ( struct Gadget *)address;
                gad = gadad->GadgetID;
                break;

            case GADGETUP:            /*            Left button released  */
                gadad = ( struct Gadget *)address;
                gad = gadad->GadgetID;
                break;

            case MOUSEBUTTONS:
                switch ( code ) {
                    case SELECTDOWN:  /*  this only goes for bl_window -  */
                        if ( win == bl_window )
                            gad = 77;
                        break;
                    case SELECTUP:    /*        - when starting brush...  */
                        if ( win == bl_window )
                            gad = 75;
                        break;
                    case MENUDOWN:    /*            Right button pressed  */
                        gad = 88;
                        break;
                    case MENUUP:      /*            Right button released */
                        break;
                    default:
                        break;
                }
                break;
            case VANILLAKEY:
                switch ( code ) {
                    case 'q':
                        gad = 99;     /*                   exit program   */
                        pan_close.Flags ^= SELECTED;
                        RefreshGList( &pan_close, pan_window, 0, 1 );
                        break;
                    case 'p':
                        gad = 88;     /*                   panel up/down  */
                        break;
                    case 'b':
                        gad = 02;     /*                   single brush   */
                        brush.Flags ^= SELECTED;
                        RefreshGList( &brush, pan_window, 0, 1 );
                        break;
                    case 'm':
                        gad = 03;     /*                     blitmode     */
                        bltmode.Flags ^= SELECTED;
                        RefreshGList( &bltmode, pan_window, 0, 1 );
                        break;
                    case 'u':
                        gad = 04;     /*                       undo       */
                        undo.Flags ^= SELECTED;
                        RefreshGList( &undo, pan_window, 0, 1 );
                        Delay( 5L );
                        undo.Flags ^= SELECTED;
                        RefreshGList( &undo, pan_window, 0, 1 );
                        break;
                    case 'h':
                        gad = 06;     /*                       about      */
                        about.Flags ^= SELECTED;
                        RefreshGList( &about, pan_window, 0, 1 );
                        Delay( 5L );
                        about.Flags ^= SELECTED;
                        RefreshGList( &about, pan_window, 0, 1 );
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    return( gad );
}


/*________________________________________________________________________
 |                                                                        |
 |               Put the Brush down - with or without Mask                |
 |________________________________________________________________________*/

VOID  do_blit( BOOL btyp, UBYTE pmask, UBYTE minterm )
{
    extern struct BlitVar  *bv;
    static      UBYTE      *msk = 0, mntrm = 0, pln = 0;

    /*             First of all - SAVE the screen for UNDO...             */
    WaitBlit();
    do_undo( FALSE );

    /*                                  ...and then - DO THE BLIT!        */
    pln = pmask & 0x07;
    pln = ( pln > ms_bit_map.Depth ) ? ms_bit_map.Depth : pln;
    msk = ( UBYTE *)ms_bit_map.Planes[pln];
    mntrm = ( minterm >= 0xa0 ) ? 0xe0 : 0x20;
    if ( !btyp )
        BltBitMap( &bs_bit_map, bv->ofx, bv->ofy,
                    &bl_bit_map, bv->mpx + 1 - ( bv->brw - bv->ofx ),
                    bv->mpy + 1 - ( bv->brh - bv->ofy ), bv->brw - bv->ofx,
                    bv->brh - bv->ofy, minterm, pmask );
    else if ( msk != NULL )
            BltMaskBitMapRastPort( &bs_bit_map, bv->ofx, bv->ofy,
                        &bl_rast_port, bv->mpx + 1 - ( bv->brw - bv->ofx ),
                        bv->mpy+1-(bv->brh-bv->ofy),bv->brw-bv->ofx,
                        bv->brh-bv->ofy, mntrm, ( APTR )msk );
}


/*________________________________________________________________________
 |                                                                        |
 |             Print mouse pointer coordinates                            |
 |________________________________________________________________________*/

VOID  coords( struct BlitVar *bv )
{
    static      UBYTE          *mspos   = "         ";
    register  struct RastPort  *rap;

    rap = ( struct RastPort *)pan_window->RPort;
    SetDrMd( rap, JAM2 );
    sprintf( mspos, "%3d:%3d", bv->mpx, bv->mpy );
    SetBPen( rap, BRD );
    SetAPen( rap, LRD );
    Move( rap, 344, 21 );
    Text( rap, mspos, 7 );
}


/*________________________________________________________________________
 |                                                                        |
 |                 File Requester selected                                |
 |                                                                        |
 |   put up file_requester, load or save file, de-select gadget...        |
 |________________________________________________________________________*/

WORD  filereq()
{
    extern      UWORD               c_pan[];
    extern      UBYTE              *fl_buff, *fl_undo_buff;

    static  struct StringInfo       string_info = { NULL, NULL, 0, 80, 0, 0,
                                               0, 0, 0, 0, NULL, 0L, NULL };
    static      WORD                wrt     = 0;
    static      BOOL                first   = TRUE, endit = FALSE;
    static      UBYTE              *outname = "T:blitpic";
    static   struct Gadget         *gadad   = 0;
    register struct IntuiMessage   *fr_msg  = NULL;
    ULONG                           class   = 0;

    static      SHORT               sg_bpts2[] = { 2, 0, 2, 12, 216, 12,
                                                 216, 0, 2,  0 },
                                    sg_bpts1[] = { 0, 13, 0, 0, 1, 0, 1, 13,
                                                 215, 13, 215, 1, 214, 1,
                                                 214, 13, 214, 1,   2, 1 },
                                    fr_bpts2[] = { 0,  0, 233, 0, 233, 44,
                                                 234, 44, 234, 0 },
                                    fr_bpts1[] = { 0,  0, 0, 44, 234, 44,
                                                   1, 44, 1,  1 };

    static  struct Border           sg_brd2 = {
                    11, 16,      /* LeftEdge, TopEdge */
                    11,          /* FrontPen      */
                    0,           /* BackPen       */
                    JAM1,        /* DrawMode      */
                    5,           /* Count         */
                    (SHORT *)&sg_bpts2, /* XY coord */
                    NULL },      /* NextBorder    */
                                    sg_brd1 = {
                    9, 16,       /* LeftEdge, TopEdge */
                    15,          /* FrontPen      */
                    0,           /* BackPen       */
                    JAM1,        /* DrawMode      */
                    10,          /* Count         */
                    (SHORT *)&sg_bpts1, /* XY coord */
                    &sg_brd2 },  /* NextBorder    */
                                    fr_brd2 = {
                    1, 0,        /* LeftEdge, TopEdge */
                    15,          /* FrontPen      */
                    0,           /* BackPen       */
                    JAM1,        /* DrawMode      */
                    5,           /* Count         */
                    (SHORT *)&fr_bpts2, /* XY coord */
                    &sg_brd1 },  /* NextBorder    */
                                    fr_brd1 = {
                    0, 0,        /* LeftEdge, TopEdge */
                    11,          /* FrontPen      */
                    0,           /* BackPen       */
                    JAM1,        /* DrawMode      */
                    5,           /* Count         */
                    (SHORT *)&fr_bpts1, /* XY coord */
                    &fr_brd2 };  /* NextBorder    */

    static  struct Requester        wrt_req = {
                    NULL,
                    87, 07,           /*    LeftEdge, TopEdge   */
                    236, 45,          /*    Width, Height       */
                    0, 0,             /*    RelLeft, RelTop     */
                    &string_gad,      /*    ReqGadget           */
                    &fr_brd1,         /*    ReqBorder           */
                    NULL,             /*    ReqText             */
                    NULL,             /*    Flags               */
                    14,               /*    BackFill            */
                    NULL,             /*    ReqLayer            */
                    { NULL },         /*    ReqPad1             */
                    NULL,             /*    ImageBMap           */
                    NULL,             /*    RWindow             */
                    { NULL }          /*    ReqPad2             */
                };

    if ( first ) {
        first = FALSE;
        strcpy(( char *)fl_buff, ( char *)outname );
        string_info.Buffer = ( UBYTE *)fl_buff;
        string_info.UndoBuffer = ( UBYTE *)fl_undo_buff;
        string_gad.SpecialInfo = ( APTR )&string_info;
        wrt_req.ReqGadget = &string_gad;
    }
    wrt = WHT;
    ModifyIDCMP( pan_window, ( ULONG )GADGETDOWN|GADGETUP|REQSET|REQCLEAR );
    SetDrMd( pan_window->RPort, JAM2 );
    LoadRGB4( &pan_screen->ViewPort, &c_pan[8], 2 );
    ActivateWindow( pan_window );
    if ( Request( &wrt_req, pan_window )) {
        wrt = BLK;
        endit = FALSE;
        do {
            Wait( 1L << pan_window->UserPort->mp_SigBit );
            while( fr_msg = ( struct IntuiMessage *)
                                        GetMsg( pan_window->UserPort )) {
                class = fr_msg->Class;
                gadad = ( struct Gadget *)fr_msg->IAddress;
                ReplyMsg( fr_msg );
                switch( class ) {
                    case GADGETDOWN:
                        break;
                    case GADGETUP:
                        if ( gadad->GadgetID < 22 )     wrt = 0x00ff;
                        break;
                    case REQSET:
                        break;
                    case REQCLEAR:
                        if ( gadad->GadgetID > 21 )     wrt = BLK;
                        endit = TRUE;
                        break;
                    default:
                        break;
                }
            }
        } while ( !endit );
    }
    if ( wrt == 0x00ff ) {
        WaitBlit();
        do_undo( FALSE );
        SetPointer( pan_window, clk_point, 18, 16, 0, 0 );
        wrt = put_screen( bl_bit_map.BytesPerRow << 3, bv->CMISE, fl_buff );
        SetPointer( pan_window, arr_point, 9, 16, 0, 0 );
    }
    LoadRGB4( &pan_screen->ViewPort, &c_pan[0], 2 );
    ModifyIDCMP( pan_window,
                ( ULONG )GADGETDOWN|GADGETUP|VANILLAKEY|MOUSEBUTTONS );
    return( wrt );
}


/*________________________________________________________________________
 |                                                                        |
 |               Minterm-wheel gadgets selected                           |
 |________________________________________________________________________*/

BYTE  do_wheels( BYTE value, WORD qrtr, WORD gy )
{
    extern  UWORD           g_workpan[DEPTH] [18] [2];
    static  WORD            lnew    = 0, rnew = 0, lold = 0, rold = 0,
                            ctr     = 0;
    static  struct Image    a_numpan    = {
                                0,      /* X Offset from LeftEdge */
                                0,      /* Y Offset from TopEdge */
                                32,     /* Image Width */
                                18,     /* Image Height */
                                DEPTH,  /* Image Depth */
                                &g_workpan[0] [0] [0],
                                               /*  pointer to Image BPls  */
                                0x0F,   /* PlanePick */
                                0x00,   /* PlaneOnOff */
                                NULL }; /* next Image structure */
    static  BYTE            minmod  = 0, val = 0;

    switch( qrtr ) {
        case 1:
            minmod = 0x10;
            break;
        case 2:
            minmod = -0x10;
            break;
        case 3:
            minmod = 0x01;
            break;
        case 4:
            minmod = -0x01;
            break;
        default:
            minmod = 0;
            break;
    }
    lold = ( value >> 4 ) & 0x0f;     /*    prepare old set of numbers... */
    rold = value & 0x0f;
    val  = value + minmod;            /*    prepare new set of numbers... */
    lnew = ( val >> 4 ) & 0x0f;
    rnew = val & 0x0f;

    for ( ctr = 1; ctr < 15; ctr++ ) { /*     ...and roll them 'round...  */
        roll_em( rold, rnew, 19, ctr, ( rnew < rold ) ? 1 : 0 );
        roll_em( lold, lnew, 7, ctr, ( lnew < lold ) ? 1 : 0 );
        DrawImage( pan_window->RPort, &a_numpan, 520, gy );
    }
    return( val );
}


VOID  roll_em( WORD old, WORD new, WORD lft, WORD cnt, BOOL up )
{
    extern  UWORD           g_fontl[DEPTH] [14] [8],
                            g_workpan[DEPTH] [18] [2];
    WORD                    ctr         = 0;
    static  struct BitMap   mtfont_bm   = { 16, 14, 0, DEPTH, 0, 0,
                                             0, 0, 0, 0, 0, 0, 0 },
                            work_bm     = {  4, 18, 0, DEPTH, 0, 0,
                                             0, 0, 0, 0, 0, 0, 0 };

    if ( mtfont_bm.Planes[0] == NULL ) {          /*  The JrcIBM 14 font, */
        InitBitMap( &mtfont_bm, DEPTH, 128, 14 );
        for ( ctr = 0; ctr < DEPTH; ctr++ )
            mtfont_bm.Planes[ctr] = (PLANEPTR)&g_fontl[ctr];
    }
    if ( work_bm.Planes[0] == NULL ) {
        InitBitMap( &work_bm, DEPTH, 32, 18 );
        for ( ctr = 0; ctr < DEPTH; ctr++ )
            work_bm.Planes[ctr] = (PLANEPTR)&g_workpan[ctr];
    }
    WaitBlit();
    if (( old != new ) && ( cnt < 14 )) {
        if ( up ) {
            BltBitMap( &mtfont_bm, old<<3, cnt,
                        &work_bm, lft, 2, 8, 14-cnt, 0xc0, 0xff );
            BltBitMap( &mtfont_bm, new<<3, 0,
                        &work_bm, lft, 16-cnt, 8, cnt, 0xc0, 0xff );
        } else {
            BltBitMap( &mtfont_bm, new<<3, 14-cnt,
                        &work_bm, lft, 2, 8, cnt, 0xc0, 0xff );
            BltBitMap( &mtfont_bm, old<<3, 0,
                        &work_bm, lft, 2+cnt, 8, 14-cnt, 0xc0, 0xff );
        }
    } else {
        BltBitMap( &mtfont_bm, new<<3, 0,
                    &work_bm, lft, 2, 8, 14, 0xc0, 0xff );
    }
}


/*________________________________________________________________________
 |                                                                        |
 |             Draw a box or float the brush                              |
 |________________________________________________________________________*/

VOID  box_tool( struct BlitVar  *bv, UWORD bsw )
{
    extern    struct BlitVar   *phi;
    register  struct BlitVar   *phr;
    register  struct RastPort  *rap;
    static    BOOL              box = FALSE, blt = FALSE;

    phr = ( struct BlitVar *)phi;
    rap = ( struct RastPort *)&bl_rast_port;
    if ( box && ( phr->brusw & BRSH_DEF )) {
        SetDrMd( rap, COMPLEMENT );
        SetAPen( rap, 3 );
        Move( rap, phr->brx, phr->bry ); /*                undraw box     */
        Draw( rap, MIN( phr->mpx, phr->brx + 1 + bv->LIMX ), phr->bry );
        Draw( rap, MIN( phr->mpx, phr->brx + 1 + bv->LIMX ),
                    MIN( phr->mpy, phr->bry + 1 + bv->LIMY ));
        Draw( rap, phr->brx, MIN( phr->mpy, phr->bry + 1 + bv->LIMY ));
        Draw( rap, phr->brx, phr->bry );
        SetDrMd( rap, JAM2 );
    }                                 /*                ...redraw pic...  */
    if ( blt && ( phr->brusw & BRSH_FLO )) {
        if (( phr->mpx > 0 ) && ( phr->mpy > 0 )) {
            BltBitMap( &wk_bit_map, 0, 0,
                        &bl_bit_map, phr->mpx+1-(phr->brw-phr->ofx),
                        phr->mpy+1-(phr->brh-phr->ofy),phr->brw-phr->ofx,
                        phr->brh-phr->ofy, 0xc0, 0xff );
        }
    }
    blt = box = FALSE;
    if ( !( bsw & MSE_MOVE )) {
        phr->brusw = bv->brusw;
        if ( !phr->brusw )
            phr->brx = phr->bry = phr->msx = phr->msy = phr->ppy =
            phr->brw = phr->brh = phr->ofx = phr->ofy = 0;
        else {
            phr->brx = bv->brx;
            phr->bry = bv->bry;
            phr->brw = bv->brw;
            phr->brh = bv->brh;
            phr->msx = bv->msx;
            phr->msy = bv->msy;
        }
    }
    phr->mpx = bv->mpx;
    phr->mpy = bv->mpy;
    phr->ofx = phr->brw - MIN( phr->mpx+1, phr->brw );
    phr->ofy = phr->brh - MIN( phr->mpy+1, phr->brh );
    bv->ofx  = phr->ofx; bv->ofy = phr->ofy;

    if (( phr->brusw & BRSH_DEF ) && ( bsw & BRSH_DEF )) {
        SetDrMd( rap, COMPLEMENT );
        SetAPen( rap, 3 );
        Move( rap, phr->brx, phr->bry ); /*                 draw box      */
        Draw( rap, MIN( phr->mpx, phr->brx + 1 + bv->LIMX ), phr->bry );
        Draw( rap, MIN( phr->mpx, phr->brx + 1 + bv->LIMX ),
                    MIN( phr->mpy, phr->bry + 1 + bv->LIMY ));
        Draw( rap, phr->brx, MIN( phr->mpy, phr->bry + 1 + bv->LIMY ));
        Draw( rap, phr->brx, phr->bry );
        SetDrMd( rap, JAM2 );
        box = TRUE;
    }
    if (( phr->brusw & BRSH_FLO ) && ( bsw & BRSH_FLO )) {
                                      /*           brush is floating...   */
        if (( phr->mpx > 0 ) && ( phr->mpy > 0 )) {
            BltBitMap( &bl_bit_map, phr->mpx+1 - (phr->brw - phr->ofx),
                        phr->mpy+1 - (phr->brh - phr->ofy),
                        &wk_bit_map, 0, 0, phr->brw - phr->ofx,
                        phr->brh - phr->ofy, 0xc0, 0xff);
            BltBitMap( &bs_bit_map, phr->ofx, phr->ofy,
                        &bl_bit_map, phr->mpx+1-(phr->brw-phr->ofx),
                        phr->mpy+1-(phr->brh-phr->ofy),
                        phr->brw-phr->ofx,phr->brh-phr->ofy,0xc0,0xff );
            blt = TRUE;
        }
    }
}


/*                    E N D   O F   B L I T G F X . C                     */



