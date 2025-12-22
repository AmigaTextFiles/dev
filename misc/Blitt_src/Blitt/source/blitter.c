
/*________________________________________________________________________
 |                                                                        |
 |    blitter.c v1.0  - (c) 1992  Paul Juhasz                             |
 |                                                                        |
 |      Started:    1. Jul. 92                                            |
 |                                                                        |
 |      Object:     to load a picture and experiment with                 |
 |                  blitter values on various colours by using            |
 |                  a brush as a source                                   |
 |________________________________________________________________________*/

#ifndef     LATTICE
#define     LATTICE         1
#endif

#include    "blitdefs.h"
#include    "bits/iff.h"
#include    "bits/ilbm.h"
#include    "bits/readpict.h"
#include    "bits/putpict.h"
#include    "bits/remalloc.h"


#ifdef LATTICE
int CXBRK(void)    { return (0); }    /* Disable Lattice CTRL/C handling  */
int chkabort(void) { return (0); }    /*        Definitely !              */
#endif /* LATTICE */

extern  void    bl_anim();
extern  ULONG   RangeRand();          /*  ( (int)r ) - range 0 to (r-1)   */
extern  struct  WBStartup  *WBenchMsg;

/*          Declare local functions...      */
VOID    main();

ULONG   IconBase = 0;            /* Actually, should be "struct IconBase *"
                                            if there was a ".h" file      */
struct  WBArg               wbArg           = { 0 },
                           *wbArgs          = NULL;

struct  Process            *blProcess       = NULL; /*   For redirecting  */
static  APTR                oldwindowptr    = NULL; /*  System-Requesters */

struct  BlitVar            *phi             = NULL, *bv = NULL;

struct  GfxBase            *GfxBase         = NULL; /* ...and GLOBALS...  */
struct  IntuitionBase      *IntuitionBase   = NULL;
struct  CIA                *cia             = ( struct CIA *) CIA_CHIP;
struct  WBStartup          *wbStartup       = NULL;

struct  Screen             *bl_screen       = NULL;
struct  Window             *bl_window       = NULL;
struct  RastPort            bl_rast_port    = { 0 };
struct  RasInfo             bl_ras_info     = { 0 };
struct  BitMap              bl_bit_map      = { 0 };

struct  Screen             *pan_screen      = NULL;
struct  Window             *pan_window      = NULL;
struct  Window             *text_window     = NULL;

UWORD                      *arr_point       = NULL,
                           *pan_point       = NULL,
                           *clk_point       = NULL, /*  all the pointers  */
                           *src_point       = NULL,
                           *msk_point       = NULL;

UBYTE                      *fl_buff         = NULL, /* the file requester */
                           *fl_undo_buff    = NULL;

struct  RastPort            wk_rast_port    = { 0 };
struct  RasInfo             wk_ras_info     = { 0 };
struct  BitMap              wk_bit_map      = { 0 };

struct  RastPort            bs_rast_port    = { 0 };
struct  RasInfo             bs_ras_info     = { 0 };
struct  BitMap              bs_bit_map      = { 0 };

struct  RastPort            ms_rast_port    = { 0 };
struct  RasInfo             ms_ras_info     = { 0 };
struct  BitMap              ms_bit_map      = { 0 };

/*  this will hold the the IFF picture file - just copy it to the screen  */
struct  BitMap              iff_bitmap      = { 0 };

ILBMFrame                   iFrame          = { 0 };
#define BUFSIZE             16000
#define bufSz               512       /*  size of a temporary buffer used
                                         in unscrambling the ILBM rows.   */

UWORD   c_pan[]     = { 0x000,        /*          0,  Black               */
                        0xbbb,        /*          1,  White               */
                        0xe95,        /*          2,  Beige               */
                        0x631,        /*          3,  Brown               */
                        0x007,        /*          4,  Dark Blue           */
                        0x349,        /*          5,  Medium Blue         */
                        0x78c,        /*          6,  Light Blue          */
                        0x001,        /*          7,  Very dark Blue      */
                        0x500,        /*          8,  Dark Red            */
                        0xF00,        /*          9,  Light red           */
                        0x080,        /*         10,  Green               */
                        0xbbc,        /*         11,   Light Grey         */
                        0x99a,        /*         12,                      */
                        0x778,        /*         13,      ..to..          */
                        0x667,        /*         14,                      */
                        0x445,        /*         15,        Dark Grey     */

                        0x000,        /*          0,  Black               */
                        0xbbb,        /*          1,  White               */
                        0xe95,        /*          2,  Beige               */
                        0x631,        /*          3,  Brown               */
                        0x007,        /*          4,  Dark Blue           */
                        0x349,        /*          5,  Medium Blue         */
                        0x78c,        /*          6,  Light Blue          */
                        0x001,        /*          7,  Very dark Blue      */
                        0x500,        /*          8,  Dark Red            */
                        0xF00,        /*          9,  Light red           */
                        0x080,        /*         10,  Green               */
                        0xbbc,        /*         11,   Light Grey         */
                        0x99a,        /*         12,                      */
                        0x778,        /*         13,      ..to..          */
                        0x667,        /*         14,                      */
                        0x445         /*         15,        Dark Grey     */
    };

UWORD   c_tab[]     = { 0x000,        /*        BLK  0, Black             */
                        0x604,        /*        VIN  1, Wine              */
                        0x905,        /*        DPR  2, Dark purple       */
                        0xb08,        /*        PNK  3, Pink              */
                        0xf0f,        /*        PRP  4, Purple            */
                        0xb0d,        /*        MVE  5, Mauve             */
                        0x608,        /*        VIO  6, Violet            */
                        0x600,        /*        DRD  7, Dark red          */
                        0x800,        /*        BRD  8, Red               */
                        0xF00,        /*        LRD  9, Light red         */
                        0xf72,        /*        ORA 10, Orange            */
                        0xff0,        /*        YEL 11, Yellow            */
                        0x643,        /*        DBN 12, Dark brown        */
                        0xd94,        /*        GLD 13, Gold              */
                        0xfc8,        /*        TAN 14,                   */
                        0x0ff,        /*        TRQ 15, Turquoise         */

                        0x000,        /*        TRP 16, Transparent       */
                        0x556,        /*        DGY 17, Dark grey         */
                        0x778,        /*        MGY 18, Medium grey       */
                        0xbbc,        /*        LGY 19, Light grey        */
                        0xfff,        /*        WHT 20, White             */
                        0xddf,        /*        OWT 21, OffWhite          */
                        0x5f5,        /*        LGN 22,                   */
                        0x3c3,        /*        MGN 23,                   */
                        0x191,        /*        GRN 24,                   */
                        0x060,        /*        C25 25, Light red         */
                        0x851,        /*        LBR 26,                   */
                        0x962,        /*        BGE 27,                   */
                        0x006,        /*        DBL 28, Dark blue         */
                        0x008,        /*        MBL 29, Med blue          */
                        0x00a,        /*        BLU 30, Blue              */
                        0x00F         /*        LBL 31, Light Blue        */
    };


/*________________________________________________________________________
 |                                                                        |
 | RangeRand( r ) is a....n integer function provided in "amiga.lib" that |
 | produces a random result in the range 0 to (r-1) given an integer r in |
 | the range 1 to 65535.                                                  |
 |________________________________________________________________________|
 |                                                                        |
 |                                                                        |
 |              return( BLK )     -   no errors                           |
 |              return( LRD )     -   no graphics library                 |
 |              return( YEL )     -   no intuition library                |
 |              return( GLD )     -   no iff library                      |
 |              return( PNK )     -   no icon library                     |
 |              return( WHT )     -   not enough memory                   |
 |              return( VIO )     -   no colourmap                        |
 |              return( TAN )     -   no bitplanes                        |
 |                                                                        |
 |                                                                        |
 |                   T H E   M A I N   R O U T I N E                      |
 |                                                                        |
 |________________________________________________________________________*/

int   main( int argc, char **argv )
{
    WORD                succ    = 0;

    if ( !argc ) {                    /*        Invoked via workbench     */
        if (!(IconBase=(ULONG)OpenLibrary("icon.library",33)))
            exit( PNK );
        wbStartup = WBenchMsg;        /*   modified by Carolyn Scheppner  */
        wbArgs    = wbStartup->sm_ArgList;
        if ( IconBase != 0 )    CloseLibrary((struct Library *)IconBase );
        if ( wbStartup->sm_NumArgs < 2 ) {
            printf( "\nUsage from workbench:\n\n" );
            printf( "  Click mouse on %s, then hold\n", wbArgs->wa_Name );
            printf( "    'SHIFT' key while double-clicking\n" );
            printf( "     on icon of file to be loaded.\n" );
            Delay( 350L );
            exit( BLK );
        }
    } else {
        if ( argc < 2 || argc > 2 ||
                        ( argc == 2 && !( strcmp( argv[1], "?" )))) {
            printf( "\tUsage from CLI:   %s <picfile> \n", argv[0] );
            exit( BLK );
        }
    }

    if (( succ = alloc_res()) != 0 )  /*     are resources available ?    */
        free_res( succ );             /*         ...if not, go home       */

    if ( argc ) {
        wbArg.wa_Lock = 0;            /*            called from CLI       */
        wbArg.wa_Name = argv[1];
        if (( succ = get_screen( &wbArg )) != 0 ) {
            free_res( succ );
        }
    } else {                          /*         called from WorkBench    */
        wbArgs++;
        if (( succ = get_screen( wbArgs )) != 0 ) {
            free_res( succ );
        }
    }

    if ( !( succ = blitt()))          /*  all the action is here   (-:   )*/
        free_res( succ );

    LoadRGB4( &bl_screen->ViewPort, &c_tab[0], 1 << (DEPTH+1));
    Delay( 12L );                     /*       pause for ¼ second...      */
    free_res( BLK );                  /*       ...and finally go home!    */

}


/*________________________________________________________________________
 |                                                                        |
 |              Write an IFF screen to disk                               |
 |________________________________________________________________________*/

WORD put_screen( WORD width, WORD height, UBYTE *outname )
{
    LONG                    file    = 0;
    IFFP                    iffp    = NO_FILE;
    UBYTE                  *buffer  = NULL;
    struct      WBArg       warg;

    /*      buffer for scrambling and packing an IFF for output           */
    if ( !( buffer = (UBYTE *)AllocMem( BUFSIZE, MEMF_PUBLIC|MEMF_CLEAR )))
        return( WHT );

    warg.wa_Lock = 0;
    warg.wa_Name = outname;
    if ( !( file = OpenArg( &warg, MODE_NEWFILE ))) {
        if ( buffer != 0 )
            FreeMem( buffer, BUFSIZE );
        return( GLD );
    }
    iffp = PutPict( file, &iff_bitmap, width, height,
                            &iFrame.colorMap, buffer, BUFSIZE );
    Close( file );
    if ( buffer != 0 )          FreeMem( buffer, BUFSIZE );
    if ( iffp != IFF_DONE )
        return( GLD );
    return( BLK );
}


/*________________________________________________________________________
 |                                                                        |
 |              Get an IFF screen ready for the program                   |
 |________________________________________________________________________*/

WORD  get_screen( struct WBArg  *wa )
{

    LONG                    file        = 0;
    IFFP                    iffp        = NO_FILE;
    UWORD                   Modes       = 0;


    if ( !( file = OpenArg( wa, MODE_OLDFILE ))) /*    load a picture...  */
        return( GLD );

    InitBitMap( &iff_bitmap, DEPTH+1, HWIT, bv->CMISE );
    iffp = ReadPicture( file, &iff_bitmap, &iFrame, ChipAlloc );
                                    /* Allocates BitMap using ChipAlloc() */
    Close( file );
    if ( iffp != IFF_DONE )
        return( GLD );

    if ( iFrame.bmHdr.pageWidth < 640 )     Modes = 0;
    else                                    Modes = HIRES;
    if ( iFrame.bmHdr.pageHeight >= 400 )   Modes |= LACE;
    if ( Modes )                            return( GLD );

    return( BLK );
}


/*________________________________________________________________________
 |                                                                        |
 |     Given a "workbench argument" (a file reference) and an I/O mode    |
 |     It opens the file.                                                 |
 |________________________________________________________________________*/

long OpenArg( struct WBArg *wa, int openmode )
{
    LONG    olddir, file;

    if ( wa->wa_Lock )      olddir = CurrentDir( wa->wa_Lock );
    file = Open( wa->wa_Name, openmode );
    if ( wa->wa_Lock )      CurrentDir( olddir );
    return( file );
}


/*________________________________________________________________________
 |                                                                        |
 |                Undo Gadget selected                                    |
 |________________________________________________________________________*/

VOID  do_undo( BOOL undo )
{
    if ( undo ) { /* Copy the picture and it's colourmap to the screen ...*/
        BltBitMap( &iff_bitmap,0,0,&bl_bit_map,0,0,HWIT,bv->CMISE,0xc0,0xff );
        LoadRGB4( &bl_screen->ViewPort, &iFrame.colorMap, iFrame.nColorRegs );
        RemakeDisplay();
    } else {                  /* Copy the screen to the picture-buffer... */
        BltBitMap( &bl_bit_map,0,0,&iff_bitmap,0,0,HWIT,bv->CMISE,0xc0,0xff );
    }
}


/*________________________________________________________________________
 |                                                                        |
 |                Set up the gadget-panel                                 |
 |________________________________________________________________________*/

VOID  put_pnl( struct RastPort *rap )
{
    extern  struct Gadget   pan_close;
    extern      UWORD       g_mouspan[DEPTH] [13] [5];
    static  struct Image    i_mouspan    = {
                                0,              /* X Offset from LeftEdge */
                                0,              /* Y Offset from TopEdge */
                                67,             /* Image Width */
                                13,             /* Image Height */
                                DEPTH,          /* Image Depth */
                                &g_mouspan[0] [0] [0],
                                                /*  pointer to Image BPls */
                                0x0F,           /* PlanePick */
                                0x00,           /* PlaneOnOff */
                                NULL };         /* next Image structure */

    SetDrMd( rap, JAM2 );
    SetBPen( rap, 14 );
    SetRast( rap, 14 );
    SetAPen( rap, 12 );
    Move( rap, 0, 0 );
    Draw( rap, 639, 0 );
    Move( rap, 0, 1 );
    Draw( rap, 639, 1 );
    Move( rap, 0, 2 );
    Draw( rap, 0, 57 );
    Move( rap, 1, 2 );
    Draw( rap, 1, 57 );
    Move( rap, 2, 2 );
    Draw( rap, 2, 57 );
    Move( rap, 3, 2 );
    Draw( rap, 3, 57 );
    Move( rap, 4, 58 );
    Draw( rap, 639, 58 );
    Move( rap, 4, 59 );
    Draw( rap, 639, 59 );
    Move( rap, 636, 2 );
    Draw( rap, 636, 57 );
    Move( rap, 637, 2 );
    Draw( rap, 637, 57 );
    Move( rap, 638, 2 );
    Draw( rap, 638, 57 );
    Move( rap, 639, 2 );
    Draw( rap, 639, 57 );
    WritePixel( rap, 633, 56 );
    SetAPen( rap, 13 );
    WritePixel( rap, 4, 3 );
    SetAPen( rap, 11 );
    Move( rap, 635, 30 );
    Draw( rap, 635, 32 );
    SetAPen( rap, 11 );
    Move( rap, 4, 2 );
    Draw( rap, 635, 2 );
    Move( rap, 634, 3 );
    Draw( rap, 634, 56 );
    Move( rap, 635, 3 );
    Draw( rap, 635, 29 );
    SetAPen( rap, 7 );
    Move( rap, 4, 4 );
    Draw( rap, 4, 56 );
    Move( rap, 5, 4 );
    Draw( rap, 5, 56 );
    Move( rap, 4, 57 );
    Draw( rap, 634, 57 );
    DrawImage( rap, &i_mouspan, 338, 12 );
    RefreshGList( &pan_close, pan_window, 0, 14 );
}


/*_________________________________________________________________________
 |                                                                        |
 |              Allocate all needed resources                             |
 |                                                                        |
 |              return( BLK )     -   no errors                           |
 |              return( LRD )     -   no graphics library                 |
 |              return( YEL )     -   no intuition library                |
 |              return( WHT )     -   not enough memory                   |
 |              return( LBL )     -   no message ports                    |
 |________________________________________________________________________*/

WORD  alloc_res()
{

#define     GRAPHICSNAME        "graphics.library"
#define     INTUINAME           "intuition.library"

    extern  struct Gadget       pan_close;

    register    WORD            ctr     = NULL;
    LONG                        v       = 33;
    ULONG                       large   = NULL;
    UWORD                       hi_cols = NULL, lo_cols = NULL;

    static      UWORD           maus_pan[]   = {
                                    0x0000, 0x0000, 0x2000, 0xc000,
                                    0x4000, 0xc000, 0xbe40, 0x3e00,
                                    0x0000, 0x0000, 0x1245, 0x201a,
                                    0x0800, 0x224a, 0x0000, 0x324a,
                                    0x0a42, 0x2008, 0x0100, 0x324a,
                                    0x0000, 0x0000 },

                                maus_arr[]   = {
                                    0x0000, 0x0000, 0xb000, 0x4000,
                                    0x4000, 0xa000, 0x7000, 0xd000,
                                    0x2800, 0xb800, 0x1400, 0x1800,
                                    0x0300, 0x0d00, 0x0200, 0x0600,
                                    0x0400, 0x0400, 0x0000, 0x0000,
                                    0x0000, 0x0000 },

                                maus_clk[]  = {
                                    0x0000, 0x0000, 0x1808, 0x20b0,
                                    0x04e4, 0x78f8, 0x4824, 0x7938,
                                    0x6048, 0x678c, 0x4814, 0x5fe4,
                                    0x27c8, 0x3930, 0x4fe4, 0x7118,
                                    0x5ef0, 0x611c, 0x9efa, 0xe104,
                                    0xbef8, 0xc106, 0xb6d8, 0xf93e,
                                    0xbff8, 0xc206, 0x9ffa, 0xe406,
                                    0x5ef0, 0x690c, 0x4ee4, 0x711c,
                                    0x47c4, 0x793c, 0x7838, 0x7ffc,
                                    0x07c4, 0x47c0, 0x0000, 0x0000 },

                                maus_msk[]   = {
                                    0x0000, 0x0000, 0xa000, 0x4000,
                                    0x4000, 0xc000, 0x2000, 0xa000,
                                    0x1000, 0x1000, 0x0000, 0x0000,
                                    0x0000, 0x0000, 0xa42a, 0x00c0,
                                    0x0200, 0xe88a, 0x0020, 0xeaca,
                                    0x0400, 0xaa2c, 0x8202, 0x2828,
                                    0x0080, 0xaa6a, 0x0000, 0x0000,
                                    0x0004, 0x0004, 0x0002, 0x0002,
                                    0x0001, 0x0001, 0x0000, 0x0000 },

                                maus_src[]   = {
                                    0x0000, 0x0000, 0xa000, 0x4000,
                                    0x4000, 0xc000, 0x2000, 0xa000,
                                    0x1000, 0x1000, 0x0000, 0x0000,
                                    0x0000, 0x0000, 0x6222, 0x8ccc,
                                    0x0000, 0x8a88, 0x2004, 0xcc88,
                                    0x0200, 0x2888, 0x8022, 0x6acc,
                                    0x0000, 0x0000, 0x0008, 0x0008,
                                    0x0004, 0x0004, 0x0002, 0x0002,
                                    0x0000, 0x0000 };

    static  struct NewScreen    blit_scrn   = {
                                    0,              /* LeftEdge  */
                                    0,              /* TopEdge   */
                                    HWIT,           /* Width     */
                                    HEIGHT,         /* Height    */
                                    DEPTH+1,        /* Depth     */
                                    0,              /* DetailPen */
                                    1,              /* BlockPen  */
                                    NULL,           /* ViewModes */
                                    CUSTOMSCREEN|
                                    CUSTOMBITMAP|
                                    SCREENQUIET,    /* Type      */
                                    NULL,           /* Font      */
                                    NULL,           /* Title     */
                                    NULL,           /* Gadget    */
                                    &bl_bit_map },  /* BitMap    */

                                panel_scrn  = {
                                    0,              /* LeftEdge  */
                                    197,            /* TopEdge   */
                                    WIDTH,          /* Width     */
                                    HEIGHT,         /* Height    */
                                    DEPTH,          /* Depth     */
                                    0,              /* DetailPen */
                                    1,              /* BlockPen  */
                                    HIRES,          /* ViewModes */
                                    CUSTOMSCREEN,   /* Type      */
                                    NULL,           /* Font      */
                                    NULL,           /* Title     */
                                    NULL,           /* Gadget    */
                                    NULL };         /* BitMap    */

    static  struct NewWindow    blit_win    = {
                                    0,              /* LeftEdge    */
                                    0,              /* TopEdge     */
                                    HWIT,           /* Width       */
                                    HEIGHT,         /* Height      */
                                    0,              /* DetailPen   */
                                    1,              /* BlockPen    */
                                    VANILLAKEY|
                                    MOUSEMOVE|
                                    MOUSEBUTTONS,   /* IDCMPFlags  */
                                    SUPER_BITMAP|
                                    BORDERLESS|
                                    BACKDROP|
                                    NOCAREREFRESH|
                                    REPORTMOUSE|
                                    RMBTRAP,        /* Flags       */
                                    NULL,           /* FirstGadget */
                                    NULL,           /* CheckMark   */
                                    NULL,           /* Title       */
                                    NULL,           /* Screen      */
                                    NULL,           /* BitMap      */
                                    0,              /* MinWidth    */
                                    0,              /* MinHeight   */
                                    0,              /* MaxWidth    */
                                    0,              /* MaxHeight   */
                                    CUSTOMSCREEN }, /* Type        */

                                panel_win   = {
                                    0,              /* LeftEdge    */
                                    0,              /* TopEdge     */
                                    WIDTH,          /* Width       */
                                    59,             /* Height      */
                                    0,              /* DetailPen   */
                                    1,              /* BlockPen    */
                                    GADGETDOWN|
                                    GADGETUP|
                                    VANILLAKEY|
                                    MOUSEBUTTONS,   /* IDCMPFlags  */
                                    BORDERLESS|
                                    BACKDROP|
                                    ACTIVATE|
                                    SMART_REFRESH|
                                    RMBTRAP,        /* Flags       */
                                    NULL,           /* FirstGadget */
                                    NULL,           /* CheckMark   */
                                    NULL,           /* Title       */
                                    NULL,           /* Screen      */
                                    NULL,           /* BitMap      */
                                    0,              /* MinWidth    */
                                    0,              /* MinHeight   */
                                    0,              /* MaxWidth    */
                                    0,              /* MaxHeight   */
                                    CUSTOMSCREEN }; /* Type        */


    if ( !( GfxBase = (struct GfxBase *)OpenLibrary( GRAPHICSNAME, v )))
        return( LRD );
    if ( !(IntuitionBase=(struct IntuitionBase *)OpenLibrary(INTUINAME,v)))
        return( YEL );

    /*      Save the old window pointer now, so that we have it later.    */
    oldwindowptr = blProcess->pr_WindowPtr;

    /*_____________________________________________________________________
    |                                                                     |
    |                   Allocate bits of memory                           |
    |_____________________________________________________________________*/

    /*        Memory for storage of the customised sprite-data            */
    if ( !( pan_point = (UWORD *)AllocMem( 44,
                                        ( ULONG )MEMF_CHIP|MEMF_CLEAR )))
        return( WHT );
    CopyMem(( APTR )&maus_pan[0], ( APTR )pan_point, 44 );
    if ( !( arr_point = (UWORD *)AllocMem( 44,
                                        ( ULONG )MEMF_CHIP|MEMF_CLEAR )))
        return( WHT );
    CopyMem(( APTR )&maus_arr[0], ( APTR )arr_point, 44 );
    if ( !( clk_point = (UWORD *)AllocMem( 80,
                                        ( ULONG )MEMF_CHIP|MEMF_CLEAR )))
        return( WHT );
    CopyMem(( APTR )&maus_clk[0], ( APTR )clk_point, 80 );
    if ( !( src_point = (UWORD *)AllocMem( 68,
                                        ( ULONG )MEMF_CHIP|MEMF_CLEAR)))
        return( WHT );
    CopyMem(( APTR )&maus_src[0], ( APTR )src_point, 68 );
    if ( !( msk_point = (UWORD *)AllocMem( 72,
                                        ( ULONG )MEMF_CHIP|MEMF_CLEAR)))
        return( WHT );
    CopyMem(( APTR )&maus_msk[0], ( APTR )msk_point, 72 );

    if ( !( fl_buff = (UBYTE *)AllocMem( 80,
                                        ( ULONG )MEMF_PUBLIC|MEMF_CLEAR)))
        return( WHT );
    if ( !( fl_undo_buff = (UBYTE *)AllocMem( 80,
                                        ( ULONG )MEMF_PUBLIC|MEMF_CLEAR)))
        return( WHT );

    if ( !( phi = ( struct BlitVar *)
            AllocMem( sizeof( struct BlitVar ), MEMF_PUBLIC|MEMF_CLEAR )))
        return( WHT );

    if ( !( bv = ( struct BlitVar *)
            AllocMem( sizeof( struct BlitVar ), MEMF_PUBLIC|MEMF_CLEAR )))
        return( WHT );

    /*____________________________________________________________________
     |                                                                    |
     |         B I T M A P ,   P L A N E S   &   R A S T P O R T          |
     |                                                                    |
     |          return( BLK )     -   no errors                           |
     |          return( WHT )     -   not enough memory                   |
     |          return( VIO )     -   no colourmap                        |
     |          return( TAN )     -   no bitplanes                        |
     |____________________________________________________________________*/

    hi_cols = 1 << DEPTH;
    lo_cols = 1 << ( DEPTH+1 );

    if ( GfxBase->DisplayFlags & PAL )  bv->CMISE = HEIGHT;  /*     PAL   */
    else                                bv->CMISE = NOTALL;  /*     NTSC  */

    large = ( RASSIZE( HWIT, bv->CMISE ) * ( DEPTH + 1 )) << 3;
    if ( AvailMem(( ULONG )MEMF_CHIP|MEMF_LARGEST ) <= large ) {
        bv->LIMX = HWIT >> 1;         /*   limit brush/mask bitmaps to    */
        bv->LIMY = bv->CMISE >> 1;    /*   ¼ screen size if no memory     */
    } else {
        bv->LIMX = HWIT;
        bv->LIMY = bv->CMISE;
    }
    InitBitMap( &bl_bit_map, DEPTH+1, HWIT, bv->CMISE );
    InitBitMap( &wk_bit_map, DEPTH+1, bv->LIMX, bv->LIMY );
    InitBitMap( &bs_bit_map, DEPTH+1, bv->LIMX, bv->LIMY );
    InitBitMap( &ms_bit_map, DEPTH+1, bv->LIMX, bv->LIMY );

    /*        Allocate memory for Raster - first set planes to zero...    */
    for( ctr = 0; ctr < DEPTH+1; ctr++ ) {
        bl_bit_map.Planes[ctr] = ( PLANEPTR )AllocRaster( HWIT,bv->CMISE );
        if ( bl_bit_map.Planes[ctr] == NULL )
            return( TAN );
        BltClear( bl_bit_map.Planes[ctr], RASSIZE( HWIT, bv->CMISE ), 0 );
    }
    for( ctr = 0; ctr < DEPTH+1; ctr++ ) {
        wk_bit_map.Planes[ctr]=( PLANEPTR )AllocRaster( bv->LIMX,bv->LIMY );
        if ( wk_bit_map.Planes[ctr] == NULL )
            return( TAN );
        BltClear( wk_bit_map.Planes[ctr], RASSIZE( bv->LIMX,bv->LIMY ), 0 );
    }
    for( ctr = 0; ctr < DEPTH+1; ctr++ ) {
        bs_bit_map.Planes[ctr]=( PLANEPTR )AllocRaster( bv->LIMX,bv->LIMY );
        if ( bs_bit_map.Planes[ctr] == NULL )
            return( TAN );
        BltClear( bs_bit_map.Planes[ctr], RASSIZE( bv->LIMX,bv->LIMY ), 0 );
    }
    for( ctr = 0; ctr < DEPTH+1; ctr++ ) {
        ms_bit_map.Planes[ctr]=( PLANEPTR )AllocRaster( bv->LIMX,bv->LIMY );
        if ( ms_bit_map.Planes[ctr] == NULL )
            return( TAN );
        BltClear( ms_bit_map.Planes[ctr], RASSIZE( bv->LIMX,bv->LIMY ), 0 );
    }

    InitRastPort( &bl_rast_port );
    InitRastPort( &wk_rast_port );
    InitRastPort( &bs_rast_port );
    InitRastPort( &ms_rast_port );

    bl_rast_port.BitMap  = &bl_bit_map;
    bl_ras_info.BitMap   = &bl_bit_map;
    bl_ras_info.RxOffset = 0;
    bl_ras_info.RyOffset = 0;
    bl_ras_info.Next     = NULL;

    wk_rast_port.BitMap  = &wk_bit_map;
    wk_ras_info.BitMap   = &wk_bit_map;
    wk_ras_info.RxOffset = 0;
    wk_ras_info.RyOffset = 0;
    wk_ras_info.Next     = NULL;

    bs_rast_port.BitMap  = &bs_bit_map;
    bs_ras_info.BitMap   = &bs_bit_map;
    bs_ras_info.RxOffset = 0;
    bs_ras_info.RyOffset = 0;
    bs_ras_info.Next     = NULL;

    ms_rast_port.BitMap  = &ms_bit_map;
    ms_ras_info.BitMap   = &ms_bit_map;
    ms_ras_info.RxOffset = 0;
    ms_ras_info.RyOffset = 0;
    ms_ras_info.Next     = NULL;

    SetDrMd( &bl_rast_port, JAM1 );   /*     initialize the rasters...    */
    SetAPen( &bl_rast_port, WHT );
    BNDRYOFF( &bl_rast_port );
    SetBPen( &bl_rast_port, BLK );
    SetRast( &bl_rast_port, BLK );

    SetDrMd( &wk_rast_port, JAM1 );
    SetAPen( &wk_rast_port, WHT );
    BNDRYOFF( &wk_rast_port );
    SetBPen( &wk_rast_port, BLK );
    SetRast( &wk_rast_port, BLK );

    SetDrMd( &bs_rast_port, JAM1 );
    SetAPen( &bs_rast_port, WHT );
    BNDRYOFF( &bs_rast_port );
    SetBPen( &bs_rast_port, BLK );
    SetRast( &bs_rast_port, BLK );

    SetDrMd( &ms_rast_port, JAM1 );
    SetAPen( &ms_rast_port, WHT );
    BNDRYOFF( &ms_rast_port );
    SetBPen( &ms_rast_port, BLK );
    SetRast( &ms_rast_port, BLK );

    /*____________________________________________________________________
     |                                                                    |
     |         S C R E E N S ,   W I N D O W S   &   G A D G E T S        |
     |                                                                    |
     |          return( BLK )     -   no errors                           |
     |          return( WHT )     -   not enough memory                   |
     |____________________________________________________________________*/

    panel_scrn.Height = bv->CMISE;
    panel_scrn.TopEdge = bv->CMISE - 59;
    if ( !( pan_screen = (struct Screen *) OpenScreen( &panel_scrn )))
        return( WHT );

    panel_win.FirstGadget = &pan_close;
    panel_win.Screen = pan_screen;
    if ( !( pan_window = ( struct Window *)OpenWindow( &panel_win )))
        return( WHT );

    blit_scrn.Height = bv->CMISE;
    if ( !( bl_screen = (struct Screen *) OpenScreen( &blit_scrn )))
        return( WHT );

    blit_win.Screen = bl_screen;
    blit_win.BitMap = &bl_bit_map;
    blit_win.Height = bv->CMISE;
    if ( !( bl_window = ( struct Window *)OpenWindow( &blit_win )))
        return( WHT );

    LoadRGB4( &pan_screen->ViewPort, &c_pan[0], lo_cols );
    LoadRGB4( &bl_screen->ViewPort, &c_tab[0], lo_cols );

    ScreenToFront( bl_screen );
    ShowTitle( bl_screen, ( BOOL )FALSE );
    ShowTitle( pan_screen, ( BOOL )FALSE );
    SetPointer( pan_window, arr_point, 9, 16, 0, 0 );
    SetPointer( bl_window, arr_point, 9, 16, 0, 0 );
    put_pnl( pan_window->RPort );     /*    draw up the panel background  */
    MakeScreen( pan_screen );
    MakeScreen( bl_screen );
    RemakeDisplay();

    /*      Now is the time to redirect system requesters.                */
    blProcess = (struct Process *)FindTask(NULL); /*   Finds our process  */
    blProcess->pr_WindowPtr = (APTR)pan_window;
    /* blProcess->pr_StackSize = 0x4000L; *           increase stack size   */

    return( BLK );

}


/*________________________________________________________________________
 |                                                                        |
 |      R E T U R N   A L L   A L L O C A T E D   R E S O U R C E S       |
 |________________________________________________________________________*/

VOID  free_res( WORD end )
{
    static  UBYTE              *errms[8]    = { "no graphics.library  ",
                                                "no intuition.library ",
                                                "no icon.library      ",
                                                "not enough memory    ",
                                                "iff file error       ",
                                                "no colourmap         ",
                                                "no bitplanes         ",
                                                "no msgports          " };

    static  WORD                dropout[8]  = {
                                        LRD, YEL, PNK, /*         lib     */
                                        WHT, GLD, VIO, TAN, /*    mem     */
                                        LBL };              /*   msgport  */
    WORD                        ctr         = 0;

    /*  Restore the old window pointer to our process.
        Don't test oldwindowptr since NULL is valid for pr_WindowPtr.     */
    blProcess->pr_WindowPtr = oldwindowptr;

    if ( iff_bitmap.Planes[0] )     RemFree( iff_bitmap.Planes[0] );
        /*  ASSUMES we allocated all planes via a single ChipAlloc call   */


    /*____________________________________________________________________
     |                                                                    |
     |      Drop the screen, free gfx resources and restore old view      |
     |____________________________________________________________________*/


    if ( bl_window != NULL )    CloseWindow( bl_window );
    if ( bl_screen != NULL )    CloseScreen( bl_screen );
    if ( pan_window != NULL )   CloseWindow( pan_window );
    if ( pan_screen != NULL )   CloseScreen( pan_screen );

    /*      Deallocate display memory, BitPlane for BitPlane, reversed    */
    for ( ctr = DEPTH; ctr >= 0; ctr-- )
        if ( ms_bit_map.Planes[ctr] != 0 ) {
            FreeRaster( ms_bit_map.Planes[ctr], bv->LIMX, bv->LIMY );
            ms_bit_map.Planes[ctr] = 0;
        }
    for ( ctr = DEPTH; ctr >= 0; ctr-- )
        if ( bs_bit_map.Planes[ctr] != 0 ) {
            FreeRaster( bs_bit_map.Planes[ctr], bv->LIMX, bv->LIMY );
            bs_bit_map.Planes[ctr] = 0;
        }
    for ( ctr = DEPTH; ctr >= 0; ctr-- )
        if ( wk_bit_map.Planes[ctr] != 0 ) {
            FreeRaster( wk_bit_map.Planes[ctr], bv->LIMX, bv->LIMY );
            wk_bit_map.Planes[ctr] = 0;
        }
    for ( ctr = DEPTH; ctr >= 0; ctr-- )
        if ( bl_bit_map.Planes[ctr] != 0 ) {
            FreeRaster( bl_bit_map.Planes[ctr], HWIT, bv->CMISE );
            bl_bit_map.Planes[ctr] = 0;
        }

    if ( bv != 0 )              FreeMem( bv, sizeof( struct BlitVar ));
    if ( phi != 0 )             FreeMem( phi, sizeof( struct BlitVar ));
    if ( fl_undo_buff != 0 )    FreeMem( fl_undo_buff, 80 );
    if ( fl_buff != 0 )         FreeMem( fl_buff, 80 );
    if ( msk_point != 0 )       FreeMem( msk_point, 72 );
    if ( src_point != 0 )       FreeMem( src_point, 68 );
    if ( clk_point != 0 )       FreeMem( clk_point, 80 );
    if ( arr_point != 0 )       FreeMem( arr_point, 44 );
    if ( pan_point != 0 )       FreeMem( pan_point, 44 );

    if ( IntuitionBase )        CloseLibrary((struct
                                            IntuitionBase *)IntuitionBase);
    if ( GfxBase )              CloseLibrary((struct GfxBase *)GfxBase );

    for ( ctr = 0; ctr < 8; ctr++ )
        if ( end == dropout[ctr] )
            printf( "\t%s\n", errms[ctr] );
    Delay( 240L );
    exit( end );
}


/*                    E N D   O F   B L I T T E R . C                     */



