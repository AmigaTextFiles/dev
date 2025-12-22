/* FontParade
   Example to display all fonts available to the system.
   Insert these routines into the "wrapper" code at the end of the chapter.
*/

/*  The buffer for concatenating text strings will be this big.  */
#define FONTSTRINGSIZE (MAXFONTNAME + 40L)
/*  The buffer for the first attempt at AvailFonts() will be this big.  */
#define AFH_SIZE_DEFAULT 400L

/*  Pointer to buffer for AvailFonts() information.  */
struct AvailFontsHeader *afHeader = NULL;
LONG afhSize = AFH_SIZE_DEFAULT;
UBYTE *fontName = NULL, *fontString = NULL;    /*  String pointers.  */


/*
   Allocate a buffer to hold information returned by AvailFonts().
   Call AvailFonts().  If the buffer wasn't large enough, deallocate it,
   allocate a larger buffer and try again.  Allocate memory for text strings.
   Return TRUE if completely successful, FALSE otherwise.
*/
BOOL getMem(VOID)
{
LONG needMore;

/*  AvailFonts() returns a value indicating the amount of memory it
    would need (above what you have given it) to successfully fulfill
    the request.  If this value is greater than zero, it is necessary
    to reallocate a larger chunk of memory and try again.
*/
do
    {
    needMore = 0L;
    afHeader = (struct AvailFontsHeader *)AllocMem(afhSize, MEMF_PUBLIC);
    if (afHeader)
        {
        needMore =
            AvailFonts((UBYTE *)afHeader, afhSize, AFF_MEMORY | AFF_DISK);
        if (needMore)
            {
            FreeMem(afHeader, afhSize);
            afhSize += needMore;
            }
        }
    } while (needMore);

if (afHeader)
    {
    fontString = (UBYTE *)AllocMem(FONTSTRINGSIZE, MEMF_PUBLIC);
    if (fontString)
        {
        fontName = (UBYTE *)AllocMem(MAXFONTNAME, MEMF_PUBLIC);
        if (fontName)
            return(TRUE);
        }
    }
return(FALSE);
}


/*
   Free any memory allocated in getMem().
*/
VOID returnMem(VOID)
{
if (fontName)
    FreeMem(fontName, MAXFONTNAME);
if (fontString)
    FreeMem(fontString, FONTSTRINGSIZE);
if (afHeader)
    FreeMem(afHeader, afhSize);
}


/*
   Walk through the linked-list of AvailFont structures filled in by
   AvailFonts().  For each font, use SetSoftStyle() to set it to
   each of eight styles (normal, underlined, italic, bold and all
   logical permutations) in turn.  Create a text string which is
   composed of the font name, size, and style and render it into
   the window in that particular size and style.
*/
BOOL example(struct Window *window)
{
BOOL success, done = FALSE;
SHORT right, left, bottom, xPos;
SHORT style;
UBYTE sizeString[5];
UWORD entry;
struct RastPort *rPort;
struct AvailFonts *aFonts;
struct TextFont *tFont, *oldTextFont;
struct TextAttr tAttr;
struct IntuiMessage *intuiMessage;

/*  The eight different styles, in #define form (from graphics/text.h).  */
static ULONG styles[ ] =
    {
    FS_NORMAL, FSF_UNDERLINED, FSF_ITALIC, FSF_ITALIC | FSF_UNDERLINED,
    FSF_BOLD, FSF_BOLD | FSF_UNDERLINED, FSF_BOLD | FSF_ITALIC,
    FSF_BOLD | FSF_ITALIC | FSF_UNDERLINED
    };

/*  The eight different styles, in descriptive text form.  */
static UBYTE *descriptions[ ] =
    {
    "Normal", "Normal Underlined", "Italic", "Italic Underlined",
    "Bold", "Bold Underlined", "Bold Italic", "Bold Italic Underlined"
    };

/*  Set window title to indicate activity.  */
TITLE(window, "Scanning Fonts:");
if (success = getMem())
    {
    TITLE(window, "FontParade");

    rPort = window->RPort;    /*  Get the window's rastport.  */
    /*  Save the original TextFont pointer.  */
    oldTextFont = rPort->Font;
    SetAPen(rPort, COLOR1);    /*  Set the A pen color.  */
    SetDrMd(rPort, JAM1);    /*  Set the drawing mode.  */

    /*
       Calculate the amount of space to indent from the
       sides of the window, to keep the text from being hidden
       behind the borders.  If this were not a GimmeZeroZero
       window, window->Width and window->Height would be used
       instead of window->GZZWidth and window->GZZHeight.
       Reverse-path fonts are rendered from right to left,
       and so must begin on the right side of the window.
    */
    left = window->BorderLeft;
    right = window->GZZWidth - (SHORT)window->BorderRight;
    bottom = window->GZZHeight - (SHORT)window->BorderBottom;

    /* Skip over the header to the first of the AvailFont structures. */
    aFonts = (struct AvailFonts *)&afHeader[1];

    for (entry = afHeader->afh_NumEntries; entry && !done; entry--, aFonts++)
        {
    /*
       It is possible that AvailFonts() will find two entries for a
       single font, one of "af_Type 1" saying that the font is memory-
       resident, and the other of "af_Type 2" saying the font is disk-based.
       This happens because another process has previously called
       OpenDiskFont() requesting that font.

       The second part of the if-statement lets you tell the two apart if
       you are scanning the list for unique elements; it says "if it's in
       memory and it's also from disk, then don't list it because you'll find
       another entry in the table that says it is not in memory, but is on
       disk".
    */
        if ( ! ((aFonts->af_Attr.ta_Flags & FPF_REMOVED) ||
            (aFonts->af_Type & AFF_MEMORY) &&
                (aFonts->af_Attr.ta_Flags & FPF_DISKFONT)))
            {
            /*
               Copy the contents of the AvailFonts' TextAttr structure
               to tAttr.  Modify this copy to allow for both ROMFONT and
               DISKFONT fonts (because both types are wanted).  Then use
               tAttr to request a font with these attributes from
               OpenDiskFont().  An exact match will be found since all
               the attributes came from an existing font.
            */
            strcpy(fontName, aFonts->af_Attr.ta_Name);
            tAttr.ta_Name = fontName;
            tAttr.ta_YSize = aFonts->af_Attr.ta_YSize;
            tAttr.ta_Style = aFonts->af_Attr.ta_Style;
            tAttr.ta_Flags = aFonts->af_Attr.ta_Flags |
                (FPF_ROMFONT | FPF_DISKFONT);

            tFont = (struct TextFont *)OpenDiskFont(&tAttr);

            if (tFont)
                {
                /*  Make this font the RastPort's font.  */
                SetFont(rPort, tFont);
                /*  Step through the eight styles, one at a time.  */
                for (style=0; style<8; style++)
                    {
                /*
                   The user may want to exit before the program has finished.
                   The following code is a simple method of checking for a
                   single class of message without putting the program to
                   sleep with the Wait() call.  It is not as multitasking-
                   friendly as Wait().  Note that this routine does not check
                   what class of message has arrived since only one class of
                   message was asked for in the window's IDCMP field
                   (CLOSEWINDOW).  See the Intuition chapter for information
                   on fully utilizing Intuition's IDCMP.
                */

                    /*  If a message has arrived...  */
                    intuiMessage =
                        (struct IntuiMessage *)GetMsg(window->UserPort);
                    if (intuiMessage)
                        {
                            /*  reply to it,  */
                            ReplyMsg((struct Message *)intuiMessage);
                            done = TRUE;    /*  set the "done" flag and  */
                            break;    /*  break out of the "for" loop.  */
                        }

                    /* If a font already has certain attributes (bold,
                       italic, etc.) don't bother re-displaying it with
                       those styles.  Those attributes were evident
                       when the font was displayed in its "normal" style.
                    */
                    if (styles[style] & tFont->tf_Style)
                        continue;

                /*  Create a string from the font's name, size and style.  */
                    strcpy(fontString, " ");
                    strcat(fontString, tFont->tf_Message.mn_Node.ln_Name);
                    sprintf(sizeString, " %ld", tFont->tf_YSize);
                    strcat(fontString, sizeString);
                    strcat(fontString, " point, ");
                    strcat(fontString, descriptions[style]);
                    strcat(fontString, " ");

                    /*  Set the style.  */
                    (VOID)SetSoftStyle(rPort, styles[style], ~0L);

                    /*  Set starting point for rendering.  If font is
                        reverse-path, start on the right side.
                    */
                    xPos = (tFont->tf_Flags & FPF_REVPATH) ? right : left;
                    Move(rPort, xPos,
                        bottom-(tFont->tf_YSize-tFont->tf_Baseline));

                    /*
                       Erase any previous text by clearing the window's
                       rastport to the background color.
                    */
                    SetRast(rPort, COLOR0);

                    /*  Render the text string.  */
                    Text(rPort, fontString, (ULONG)strlen(fontString));

                    /*  Pause.  */
                    Delay(1L * TICKS_PER_SECOND);
                    }
                /*  Reset the RastPort's original font.  */
                SetFont(rPort, oldTextFont);
                CloseFont(tFont);
                }
            }
        }
    }
else
/*  Alert the user to the low-memory condition.  */
    TITLE(window, "Not enough free memory.");

    /*  Return any memory that was successfully allocated.  */
    returnMem();

    if (success)
        /*  Close immediately if there was no error.  */
        return(DONT_WAIT);
    else
        /*  Wait for the user to read the error message.  */
        return(WAIT_FOR_CLOSE);
}

