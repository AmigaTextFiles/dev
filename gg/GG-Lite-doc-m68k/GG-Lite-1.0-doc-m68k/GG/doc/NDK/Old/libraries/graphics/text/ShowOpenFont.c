/* ShowOpenFont
   An example illustrating how to request a font from OpenFont().
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
SHORT indentLeft = window->BorderLeft, indentTop = window->BorderTop;
struct RastPort *rastPort = window->RPort;
struct TextAttr textAttr;
struct TextFont *textFont, *oldTextFont;

TITLE(window, "Using OpenFont() to request fonts");

SetAPen(rastPort, COLOR1);

/*  Save the address of the RastPort's current font for replacement later.
    It cannot "disappear" during this time as it still has at least
    one "accessor".
*/
oldTextFont = rastPort->Font;

/*  Fill the TextAttr structure with the desired characteristics.  */
/*  These just happen to be the attributes of the standard topaz 80 font.  */
textAttr.ta_Name = "topaz.font";
textAttr.ta_YSize = 8;
textAttr.ta_Style = FS_NORMAL;
textAttr.ta_Flags = FPF_DESIGNED | FPF_ROMFONT;


/*  Request this font from the system.  */
textFont = OpenFont(&textAttr);
if (textFont)
    {
    /*  Make this font the RastPort's default font.  */
    SetFont(rastPort, textFont);

    /*  Move the pen's current position such that the characters
        will be rendered below the Window's top border.
    */
    indentTop += rastPort->TxBaseline;
    Move(rastPort, indentLeft, indentTop);

    Text(rastPort, "topaz.font, 8 dots high", 23 );

    /*  Set this RastPort's font back to its original font.  */
    SetFont(rastPort, oldTextFont);

    /*  Close the font when completely done with it.  */
    CloseFont(textFont);
    }

textAttr.ta_YSize = 9;    /*  Change the textAttr structure,  */
textFont = OpenFont(&textAttr);    /*  and request this new font.  */
if (textFont)
    {
    SetFont(rastPort,textFont);
    /*  Move down to avoid overlapping with the previous line.
        Use the new font's YSize plus one pixel.
    */
    indentTop += textFont->tf_YSize + 1;
    Move(rastPort, indentLeft, indentTop);
    Text(rastPort, "topaz.font, 9 dots high", 23);
    SetFont(rastPort, oldTextFont);
    CloseFont(textFont);
    }
return(WAIT_FOR_CLOSE);
}

