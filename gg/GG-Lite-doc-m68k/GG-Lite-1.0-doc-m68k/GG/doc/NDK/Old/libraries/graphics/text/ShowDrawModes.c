/* ShowDrawModes
   Example to illustrate the different DrawModes.
   Insert this routine into the "wrapper" code at the end of the chapter.

   Copyright (c) 1990 Commodore-Amiga, Inc.
  
   This example is provided in electronic form by Commodore-Amiga, Inc. for
   use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
   The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
   information on the correct usage of the techniques and operating system
   functions presented in this example.  The source and executable code of
   this example may only be distributed in free electronic form, via bulletin
   board or as part of a fully non-commercial and freely redistributable
   diskette.  Both the source and executable code (including comments) must
   be included, without modification, in any copy.  This example may not be
   published in printed form or distributed with any commercial product.
   However, the programming techniques and support routines set forth in
   this example may be used in the development of original executable
   software products for Commodore Amiga computers.
   All other rights reserved.
   This example is provided "as-is" and is subject to change; no warranties
   are made.  All use is at your own risk.  No liability or responsibility
   is assumed.
*/


BOOL example(struct Window *window)
{
struct RastPort *rastPort = window->RPort;
/*  x and y will be used to position the text.  d (the amount to move
    down to keep subsequent lines of text from overlapping) is 1 more
    than the height of the default font for this RastPort.
*/
SHORT x = window->BorderLeft;
SHORT y = window->BorderTop + rastPort->TxBaseline;
SHORT d = rastPort->TxHeight + 1;
static UBYTE mode, modes[] =
    {
    JAM1, JAM2, COMPLEMENT
    };
static UBYTE *modeText[] =
    {
    " This is JAM1 DrawMode ",
    " This is JAM2 DrawMode ",
    " This is COMPLEMENT DrawMode "
    };

TITLE(window, "The various DrawModes");

/* Set the A pen color to one which will stand out from both the
   standard foreground and background Workbench colors.
*/
SetAPen(rastPort, COLOR3);
/* The B pen color will be the standard background color. */
SetBPen(rastPort, COLOR0);

/* Fill the RastPort with a color other than the standard background color. */
SetRast(rastPort, COLOR1);

/* Run through the three modes.  y is incremented by d pixels for each line. */
for (mode=0; mode < 3; mode++, y+=d)
    {
    Move(rastPort, x, y);    /* Set the starting position. */
    SetDrMd(rastPort, modes[mode] );    /* Set the draw mode. */
    Text(rastPort, modeText[mode], strlen(modeText[mode]));
    /* cp_x (current position for x) has increased by the length of the
       string (in pixels), cp_y is unchanged.  The text that is about to
       be rendered will begin at this position.
    */
    SetDrMd(rastPort, modes[mode] | INVERSVID );    /* "or" in INVERSVID. */
    Text(rastPort, " and this is it in inverse. ", 28);
    }
return(WAIT_FOR_CLOSE);
}

