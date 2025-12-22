-> MeasureText.e

->>> Header (globals)
MODULE 'asl',
       'diskfont',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'libraries/asl',
       'other/split'

ENUM ERR_NONE, ERR_ARGS, ERR_ASL, ERR_FONT, ERR_KICK, ERR_LIB, ERR_OPEN,
     ERR_READ, ERR_WIN

RAISE ERR_ASL  IF AllocAslRequest()=NIL,
      ERR_FONT IF OpenDiskFont()=NIL,
      ERR_KICK IF KickVersion()=FALSE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_OPEN IF Open()=NIL,
      ERR_READ IF Read()<0,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST BUFSIZE=32000  -> E-Note: 32768 is too big for a static ARRAY

DEF buffer[BUFSIZE]:ARRAY, myfile=NIL, wtbarheight,
    fr=NIL:PTR TO fontrequester, myfont=NIL:PTR TO textfont,
    w=NIL:PTR TO window, myrp:PTR TO rastport
->>>

->>> PROC main()
PROC main() HANDLE
  DEF arglist:PTR TO LONG
  KickVersion(37)  -> Run only on 2.0 machines
  -> E-Note: use argSplit() to get argv-like list (minus command name)
  IF NIL=(arglist:=argSplit()) THEN Raise(ERR_ARGS)
  IF ListLen(arglist)=1  -> E-Note: replaces 'argc==2'
    myfile:=Open(arglist[0], OLDFILE)  -> Open the file to print out.
    diskfontbase:=OpenLibrary('diskfont.library', 37)
    aslbase:=OpenLibrary('asl.library', 37)
    fr:=AllocAslRequest(ASL_FONTREQUEST,  -> Open an ASL font requester.
          -> Supply initial values for requester
          [ASL_FONTNAME,   'topaz.font',
           ASL_FONTHEIGHT, 11,
           ASL_FONTSTYLES, FSF_BOLD OR FSF_ITALIC,
           ASL_FRONTPEN,   1,
           ASL_BACKPEN,    0,

           -> Give us all the gadgetry
           ASL_FUNCFLAGS,  FONF_FRONTCOLOR OR FONF_BACKCOLOR OR
                           FONF_DRAWMODE OR FONF_STYLES,
           NIL])
    -> Pop up the requester
    IF AslRequest(fr, NIL)
      -> Extract the font and display attributes from the fontrequest.
      myfont:=OpenDiskFont([fr.attr.name,  fr.attr.ysize,
                            fr.attr.style, fr.attr.flags]:textattr)
      w:=OpenWindowTagList(NIL, [WA_SIZEGADGET,  TRUE,
                                 WA_MINWIDTH,    200,
                                 WA_MINHEIGHT,   200,
                                 WA_DRAGBAR,     TRUE,
                                 WA_DEPTHGADGET, TRUE,
                                 WA_TITLE,       arglist[0],
                                 NIL])
      myrp:=w.rport
      -> Figure out where the baseline of the uppermost line should be.
      wtbarheight:=w.wscreen.barheight+myfont.baseline+2

      -> Set the font and add software styling to the text if I asked for it
      -> in OpenFont() and didn't get it.  Because most Amiga fonts do not
      -> have styling built into them (with the exception of the CG outline
      -> fonts), if the user selected some kind of styling for the text, it
      -> will to be added algorithmically by calling SetSoftStyle().
      SetFont(myrp, myfont)
      SetSoftStyle(myrp, Eor(fr.attr.style, myfont.style),
                   FSF_BOLD OR FSF_UNDERLINED OR FSF_ITALIC)
      SetDrMd(myrp, fr.drawmode)
      SetAPen(myrp, fr.frontpen)
      SetBPen(myrp, fr.backpen)
      Move(myrp, w.wscreen.wborleft, wtbarheight)

      mainLoop()

      -> Short delay to allow user to see the text before it goes away.
      Delay(25)
    ELSE
      WriteF('Request Cancelled\n')
    ENDIF
  ELSE
    WriteF('Template: MeasureText <file name>\n')
  ENDIF
EXCEPT DO
  IF w THEN CloseWindow(w)
  IF myfont THEN CloseFont(myfont)
  IF fr THEN FreeAslRequest(fr)
  IF aslbase THEN CloseLibrary(aslbase)
  IF diskfontbase THEN CloseLibrary(diskfontbase)
  IF myfile THEN Close(myfile)
  SELECT exception
  CASE ERR_ARGS;  WriteF('Error: ran out of memory splitting arguments\n')
  CASE ERR_ASL;   WriteF('Error: could not allocate ASL request\n')
  CASE ERR_FONT;  WriteF('Error: could not open font\n')
  CASE ERR_KICK;  WriteF('Error: requires V37+\n')
  CASE ERR_LIB;   WriteF('Error: could not open required library\n')
  CASE ERR_OPEN;  WriteF('Error: could not open file\n')
  CASE ERR_READ;  WriteF('Error: Read() failed on file\n')
  CASE ERR_WIN;   WriteF('Error: could not open window\n')
  ENDSELECT
ENDPROC
->>>

->>> PROC mainLoop()
PROC mainLoop()
  DEF resulttextent:textextent, fit, actual, count, printable, crrts, aok=TRUE
  -> While there's something to read, fill the buffer.
  WHILE (actual:=Read(myfile, buffer, BUFSIZE)) AND aok
    count:=0

    WHILE count<actual
      crrts:=0
      -> Skip non-printable characters, but account for newline characters.
      WHILE ((buffer[count] < myfont.lochar) OR
             (buffer[count] > myfont.hichar)) AND (count < actual)
        -> Is this character a newline?  If it is, bump up the newline count.
        IF buffer[count]=$0A THEN INC crrts
        INC count
      ENDWHILE

      IF crrts>0  -> If there were any newlines, be sure to display them.
        Move(myrp, w.borderleft, myrp.cp_y+(crrts*(myfont.ysize+1)))
        eop()  -> Did we go past the end of the page?
      ENDIF

      printable:=count
      -> Find the next non-printables.
      WHILE (buffer[printable] >= myfont.lochar) AND
            (buffer[printable] <= myfont.hichar) AND (printable < actual)
        INC printable
      ENDWHILE
      -> Print the string of printable characters wrapping lines to the
      -> beginning of the next line as needed.
      WHILE count<printable
        -> How many characters in the current string of printable characters
        -> will fit between the rastport's current X position and the edge of
        -> the window?
        fit:=TextFit(myrp,            buffer+count,
                     printable-count, resulttextent,
                     NIL,             1,
                     w.width-(myrp.cp_x+w.borderleft+w.borderright),
                     myfont.ysize+1)
        IF fit=0
          -> Nothing else fits on this line, need to wrap to the next line
          Move(myrp, w.borderleft, myrp.cp_y+myfont.ysize+1)
        ELSE
          Text(myrp, buffer+count, fit)
          count:=count+fit
        ENDIF
        eop()
      ENDWHILE

      IF CtrlC()  -> Did the user hit Ctrl-C?
        aok:=FALSE
        WriteF('Ctrl-C Break\n')
        count:=BUFSIZE+1
      ENDIF
    ENDWHILE
  ENDWHILE
ENDPROC
->>>

->>> PROC eop()
PROC eop()
  -> If we reached the page bottom, clear the rastport and move to the top.
  IF myrp.cp_y > (w.height-(w.borderbottom+2))
    Delay(25)
    SetAPen(myrp, 0)
    RectFill(myrp, w.borderleft, w.bordertop, w.width-(w.borderright+1),
             w.height-(w.borderbottom+1))
    SetAPen(myrp, 1)
    Move(myrp, w.borderleft+1, wtbarheight)
    SetAPen(myrp, fr.frontpen)
  ENDIF
ENDPROC
->>>

->>> Version string
vers:
  CHAR 0, '$VER: MeasureText 37.1', 0
->>>

