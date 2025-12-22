/*-- AutoRev header do NOT edit!
*
*   Program         :   Coords.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard.
*   Creation Date   :   15-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   15-Oct-91     1.00            Coordinates routines.
*
*-- REV_END --*/

#include	"defs.h"

extern struct Screen        *MainScreen;
extern struct TextAttr      Topaz80;

UBYTE                        CrdBuf[40];
struct IntuiText             CrdTxt = {
    0, 1, JAM2, 0, 1, &Topaz80, CrdBuf, 0l };

/*
 * --- Set the screen title by  drawing a rectangle
 * --- in the screen it's rastport and rendering the
 * --- text in this rectangle so the title can be read
 * --- when a window overlaps it.
 */
void SetTitle( UBYTE *title )
{
    struct RastPort *rp = &MainScreen->RastPort;
    WORD             ysize;

    ysize = MainScreen->WBorTop + rp->TxHeight;

    SetAPen( rp, 1l );
    SetDrMd( rp, JAM1 );

    RectFill( rp, 0, 0, MainScreen->Width - 1, ysize );

    SetAPen( rp, 0l );
    SetBPen( rp, 1l );
    SetDrMd( rp, JAM2 );

    if ( title ) {
        Move( rp, 1, rp->TxBaseline + 1 );
        Text( rp, title, strlen( title ));
    }
}

/*
 * --- Update the coordinates on the screen.
 */
void UpdateCoords( long how, WORD l, WORD t, WORD w, WORD h )
{
    struct RastPort     *rp = &MainScreen->RastPort;
    WORD                 mx, my;

    if ( how == 0l ) {
        GetMouseXY( &mx, &my );
        sprintf( CrdBuf, "x=%-5ld y=%-5ld", mx, my );
        CrdTxt.LeftEdge = MainScreen->Width - 157;
    } else if ( how == 1l ) {
        sprintf( CrdBuf, "l=%-5ld t=%-5ld w=%-5ld h=%-5ld", l, t, w, h );
        CrdTxt.LeftEdge = 1;
    } else if ( how == 2l ) {
        sprintf( CrdBuf, "l=%-5ld t=%-5ld", l, t );
        CrdTxt.LeftEdge = 1;
    }

    PrintIText( rp, &CrdTxt, 0l, 0l );
}
