
/*________________________________________________________________________
 |                                                                        |
 |    blithous.c v1.0  - (c) 1992  Paul Juhasz                            |
 |                                                                        |
 |      Object:     to put up the help and info pages                     |
 |________________________________________________________________________*/


#include    "blitdefs.h"

extern  struct  Screen         *pan_screen;
extern  struct  Window         *pan_window;
extern  struct  Window         *text_window;


/*________________________________________________________________________
 |                                                                        |
 |             1 -  BLITT!-about Gadget selected                          |
 |             2 -  Mask-about Gadget selected                            |
 |             3 -  Minterm-about Gadget selected                         |
 |________________________________________________________________________*/

VOID do_about( WORD what )
{
    extern struct BlitVar      *bv;
    struct  IntuiMessage       *messg   = 0;
    register    UWORD           ctr     = 0, pag = 0;

    ULONG                       class   = 0;
    UWORD                       code    = 0, maxpg = 0,
                                mul     = 0, top1 = 0, top2 = 0;
    static      BOOL            quit    = FALSE;
    static  struct NewWindow    text_win    = {
                                    0,              /* LeftEdge    */
                                    0,              /* TopEdge     */
                                    WIDTH,          /* Width       */
                                    HEIGHT,         /* Height      */
                                    0,              /* DetailPen   */
                                    3,              /* BlockPen    */
                                    VANILLAKEY|
                                    MOUSEBUTTONS,   /* IDCMPFlags  */
                                    ACTIVATE|
                                    NOCAREREFRESH|
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

    static      UBYTE           help[2] [24] [72]   = {
 "  Blitt © `92, a fairly useless utility, just to help programmers find ",
 "Mask / MinTerm values for the BlitBitMap() / BlitMaskBitMapRastPort()  ",
 "commands in 'C' or their equivalents in assembler. It can equally be   ",
 "used for some graphic effects that may not be available otherwise. (?) ",
 "                                                                       ",
 "  Blitt is Copyright of P.Juhasz and is placed into the Public Domain  ",
 "for unrestricted use by any individual at his or her own leisure. It   ",
 "is prohibited to copy or to distribute Blitt for commercial gain, be   ",
 "it on it's own or as part of another package without the prior consent ",
 "of the Author. Any breach of this restriction will cost the peace of   ",
 "mind of the perpetrator - bringing with it BAD karma.                  ",
 "                                                                       ",
 "  Since I think the Amiga is beautiful, I tried to take as much care   ",
 "in writing this program as I could, but as humans are quite fallible,  ",
 "I would appreciate any feedback on the program's usage, features and   ",
 "possibilities, or any likely or unlikely donations.                    ",
 "                                                                       ",
 "                                                                       ",
 "  P. Juhasz                                 Tel.: 081 677 9425         ",
 "  28 Ellora Road                                                       ",
 "  Streatham Common                                                     ",
 "  London SW16 6JF                                                      ",
 "                                                                       ",
 "                                                        More...        ",
 "  Usage is straight forward:                                           ",
 "                                                                       ",
 "    -Click on `brush' icon      - mouse-pointer will change to `Srce'  ",
 "    -Define outline on display  - mouse-pointer will change to `Blitt' ",
 "    -Set Mask and Minterm       - FF/C0 = straight copy                ",
 "    -Put the brush anywhere                                            ",
 "    -Click on `brush' icon      - mouse-pointer changes back to arrow  ",
 "                                                                       ",
 "  Clicking on the `disk' icon will put up a string-requester. Use the  ",
 "  default `T:blitpic' or type in a path and filename. The screen will  ",
 "  be saved in standard IFF ILBM format, compatible with DPaint.        ",
 "                                                                       ",
 "   -to get the panel out of the way, press RMB at any time             ",
 "                                                                       ",
 "   -on the help-pages RMB will take you back a page, while LMB or      ",
 "    any key will advance a page                                        ",
 "                                                                       ",
 "  Key shortcuts:                                                       ",
 "                                                                       ",
 "      q   -   quits                   u   -   undo                     ",
 "      p   -   panel up/down           b   -   start/stop brush         ",
 "      m   -   toggle mask                                              ",
 "      h   -   this help page                                           ",
 "                                                                       "
 },
                                minh[2] [24] [72]   = {
 "  The syntax of the commands should be available from any good book,   ",
 "but here is a quick recap:                                             ",
 "                                                                       ",
 "                                                                       ",
 "  planecnt = BltBitMap( srcBM,           srcX, srcY, dstBM,            ",
 "  D0                    A0               D0:16 D1:16 A1                ",
 "  ULONG    = BltBitMap( struct BitMap *, WORD, WORD, struct BitMap *,  ",
 "                                                                       ",
 "             dstX, dstY, sizX, sizY, Minterm, Mask   [, TempA   ] )    ",
 "             D2:16 D3:16 D4:16 D5:16 D6:8     D7:8   [  A7      ]      ",
 "             WORD, WORD, WORD, WORD, UBYTE,   UBYTE  [, UWORD * ] )    ",
 "                                                                       ",
 "  Most of the parameters are self-explanatory, all coordinates as well ",
 "  as width/height are pixel values.                                    ",
 "                                                                       ",
 "  Minterm specifies the way the source is treated as it is copied to   ",
 "  the destination, whether it is a straight copy ($C0) or whether it   ",
 "  is logically combined with the destination.                          ",
 "                                                                       ",
 "  Mask specifies the bitplanes that are to be affected by the copy.    ",
 "                                                                       ",
 "  TempA is a temporary buffer for blits where source and destination   ",
 "  overlap. It can be left out altogether.                              ",
 "                                                                       ",
 "  void    BltMaskBitMapRastPort( srcBM,           srcX, srcY,          ",
 "                                 A0               D0    D1             ",
 "                               ( struct BitMap *, WORD, WORD,          ",
 "                                                                       ",
 "       dstRP,             dstX, dstY, sizX, sizY, minterm, bltmask )   ",
 "       A1                 D2    D3    D4    D5    D6       A2          ",
 "       struct RastPort *, WORD, WORD, WORD, WORD, UBYTE,   APTR    )   ",
 "                                                                       ",
 "                                                                       ",
 "  In this case minterm is restricted by software to $e0 if you set the ",
 "  dial to >= $a0, otherwise the program uses a minterm value of $20.   ",
 "                                                                       ",
 "  The mask used in this operation, pointed to by bltmask, is a single  ",
 "  bitplane out of the display bitmap - its top left corner defined by  ",
 "  clicking on the display. Any one plane can be selected with the right",
 "  hand wheel of the mask-dial. The Mask will be the same size as the   ",
 "  brush that is subsequently defined.                                  ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       "
 },
                                mash[1] [24] [72]   = {
 "  Normally this parameter specifies the bitplanes that are affected by ",
 "  the blit operation.                                                  ",
 "                                                                       ",
 "  In the case of blitting through a mask, whatever value you set on    ",
 "  the Mask-dial will be logically AND`ed with $07 and limited to the   ",
 "  number of bitplanes of the display to get a single bit-plane of the  ",
 "  display's bitmap to act as the mask.                                 ",
 "                                                                       ",
 "  The mask is selected by clicking on the icon that looks like rows of ",
 "  red, green and blue dots and changes to a `mask' when selected.      ",
 "  The mouse-pointer changes to `Mask' and you can click the top-left   ",
 "  corner of where your mask should be located. Once this is done, the  ",
 "  mouse-pointer changes to the usual `Srce' to let you cut out a brush.",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       ",
 "                                                                       "
 };

    while ( pan_screen->TopEdge < bv->CMISE )
        MoveScreen( pan_screen, 0, 4 );
    text_win.Screen = pan_screen;
    text_win.Height = bv->CMISE;
    if (( text_window = ( struct Window *)OpenWindow( &text_win )) != 0 ) {
        SetBPen( text_window->RPort, BLK );
        SetDrMd( text_window->RPort, JAM1 );
        quit = FALSE;
        pag = 0;
        top1 = ( bv->CMISE == HEIGHT ) ? 30 : 14;
        top2 = ( bv->CMISE == HEIGHT ) ? 29 : 13;
        mul  = ( bv->CMISE == HEIGHT ) ? 9 : 8;
        while ( !quit ) {
            SetRast( text_window->RPort, TAN );
            switch ( what ) {
                case MAIN_HELP:
                    maxpg = 2;
                    for ( ctr = 0; ctr < 24; ctr++ ) {
                        SetAPen( text_window->RPort, PRP );
                        Move( text_window->RPort, 30, top1 + ( ctr * mul ));
                        Text( text_window->RPort, &help[pag] [ctr], 71 );
                        SetAPen( text_window->RPort, DPR );
                        Move( text_window->RPort, 32, top2 + ( ctr * mul ));
                        Text( text_window->RPort, &help[pag] [ctr], 71 );
                    }
                    break;
                case MASK_HELP:
                    maxpg = 1;
                    for ( ctr = 0; ctr < 24; ctr++ ) {
                        SetAPen( text_window->RPort, PRP );
                        Move( text_window->RPort, 30, top1 + ( ctr * mul ));
                        Text( text_window->RPort, &mash[pag] [ctr], 71 );
                        SetAPen( text_window->RPort, DPR );
                        Move( text_window->RPort, 32, top2 + ( ctr * mul ));
                        Text( text_window->RPort, &mash[pag] [ctr], 71 );
                    }
                    break;
                case MINT_HELP:
                    maxpg = 2;
                    for ( ctr = 0; ctr < 24; ctr++ ) {
                        SetAPen( text_window->RPort, PRP );
                        Move( text_window->RPort, 30, top1 + ( ctr * mul ));
                        Text( text_window->RPort, &minh[pag] [ctr], 71 );
                        SetAPen( text_window->RPort, DPR );
                        Move( text_window->RPort, 32, top2 + ( ctr * mul ));
                        Text( text_window->RPort, &minh[pag] [ctr], 71 );
                    }
                    break;
                default:
                    break;
            }
            while ( pan_screen->TopEdge > 2 ) /*     push the screen up   */
                MoveScreen( pan_screen, 0, -4 );
            Wait( 1L << text_window->UserPort->mp_SigBit );
            while( messg = ( struct IntuiMessage *)
                                        GetMsg( text_window->UserPort )) {
                class = messg->Class;
                code  = messg->Code;
                ReplyMsg( messg );
                switch( class ) {
                    case MOUSEBUTTONS: /* The user pressed a mousebutton  */
                        switch( code ) {
                            case SELECTDOWN:
                                pag += ( pag >= maxpg ) ? 0 : 1;
                                quit = ( pag >= maxpg ) ? TRUE : FALSE;
                                break;
                            case MENUDOWN:
                                pag -= ( pag ) ? 1 : 0;
                                quit = ( pag >= maxpg ) ? TRUE : FALSE;
                                break;
                            default:
                                break;
                        }
                        Wait( 1L << text_window->UserPort->mp_SigBit );
                        while( messg = ( struct IntuiMessage *)
                                        GetMsg( text_window->UserPort )) {
                            ReplyMsg( messg );
                        }
                        break;
                    case VANILLAKEY:  /*        The user pressed a key!   */
                        pag += ( pag >= maxpg ) ? 0 : 1;
                        quit = ( pag >= maxpg ) ? TRUE : FALSE;
                        break;
                }
            }
        }
        while ( pan_screen->TopEdge < bv->CMISE ) /*   lower the screen   */
            MoveScreen( pan_screen, 0, 4 );
        CloseWindow( text_window );
    }
    while ( pan_screen->TopEdge > bv->CMISE-57 )
        MoveScreen( pan_screen, 0, -4 );
}


/*                  E N D   O F   B L I T H O U S . C                     */


