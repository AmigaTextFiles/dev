/* ShowDefaultFont
   An example that prints the name and size of the default font.
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
UBYTE textNum[6];    /*  A temporary buffer.  */
struct TextAttr textAttr;
struct RastPort *rastPort = window->RPort;
SHORT indentLeft = window->BorderLeft, indentTop = window->BorderTop;

TITLE(window, "This Window's default font");
SetAPen(rastPort, COLOR1);    /*  Set the pen color.  */

/*  AskFont() will fill textAttr with the default font's attributes.  */
AskFont(rastPort, &textAttr);

/*  Move the pen's current position such that the characters
    will be rendered below the Window's top border.
*/
Move(rastPort, indentLeft, indentTop + rastPort->TxBaseline);

/*  Render this string (which is 20 characters long).  */
Text(rastPort, "The default font is ", 20);

/*  The pen's cp_y has been updated to where the last rendering finished.
    If we don't Move() it, the next string will continue from there.
*/
Text(rastPort, textAttr.ta_Name, strlen(textAttr.ta_Name));

/*  Use sprintf() to copy the numeric value to a string buffer.  */
sprintf(textNum, ", %d", textAttr.ta_YSize);
Text(rastPort, textNum, strlen(textNum));

Text(rastPort, " pixels high.", 13);

/*  Wait for the user to click in the close gadget before returning.  */
return(WAIT_FOR_CLOSE);
}

