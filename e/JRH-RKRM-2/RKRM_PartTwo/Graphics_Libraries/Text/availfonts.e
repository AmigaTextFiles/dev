-> AvailFonts.e

->>> Header (globals)
MODULE 'diskfont',
       'layers',
       'utility',
       'exec/nodes',
       'exec/ports',
       'graphics/rastport',
       'graphics/gfx',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'libraries/diskfont'

ENUM ERR_NONE, ERR_DRAW, ERR_LIB, ERR_REGN, ERR_WIN

RAISE ERR_DRAW IF GetScreenDrawInfo()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_REGN IF NewRegion()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

OBJECT stringobj
  string
  charcount
  stringwidth
ENDOBJECT

DEF alphabetstring, fname:stringobj, fheight:stringobj, xDPI:stringobj,
    yDPI:stringobj, entrynum:stringobj
DEF mywin=NIL:PTR TO window, mycliprp, myrp:rastport
DEF myrect:rectangle, new_region=NIL, old_region
DEF mydrawinfo=NIL:PTR TO drawinfo, afh=NIL:PTR TO afh, fontheight,
    alphabetcharcount, stringwidth
->>>

->>> PROC main()
PROC main() HANDLE
  DEF defaultfont=NIL, defaultfontattr, afsize, afshortage, cliprectside
  -> E-Note: use the STRLEN short-cut to get string lengths.
  alphabetstring:='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  alphabetcharcount:=STRLEN
  defaultfontattr:=['topaz.font', 9, 0, 0]:textattr
  fname.string:='Font Name:  ';      fname.charcount:=STRLEN
  fheight.string:='Font Height:  ';  fheight.charcount:=STRLEN
  xDPI.string:='X DPI:  ';           xDPI.charcount:=STRLEN
  yDPI.string:='Y DPI:  ';           yDPI.charcount:=STRLEN
  entrynum.string:='Entry #:  ';     entrynum.charcount:=STRLEN
  KickVersion(37)
  diskfontbase:=OpenLibrary('diskfont.library', 37)
  layersbase:=OpenLibrary('layers.library', 37)
  utilitybase:=OpenLibrary('utility.library', 37)
  mywin:=OpenWindowTagList(NIL, [WA_SMARTREFRESH, TRUE,  -> Open that window.
                                 WA_SIZEGADGET,   FALSE,
                                 WA_CLOSEGADGET,  TRUE,
                                 WA_IDCMP,        IDCMP_CLOSEWINDOW,
                                 WA_DRAGBAR,      TRUE,
                                 WA_DEPTHGADGET,  TRUE,
                                 WA_TITLE,        'AvailFonts() example',
                                 NIL])
  -> An object copy: clone my window's rastport.  This rastport will be used
  -> to render the font specs, not the actual font sample.
  CopyMem(mywin.rport, myrp, SIZEOF rastport)
  mydrawinfo:=GetScreenDrawInfo(mywin.wscreen)
  SetFont(myrp, mydrawinfo.font)

  myrect.minx:=mywin.borderleft  -> LAYOUT THE WINDOW
  myrect.miny:=mywin.bordertop
  myrect.maxx:=mywin.width-(mywin.borderright+1)
  myrect.maxy:=mywin.height-(mywin.borderbottom+1)

  cliprectside:=(myrect.maxx-myrect.minx)/20

  fontheight:=myrp.font.ysize+2
  -> If the default screen font is more than one-sixth the size of the window,
  -> use topaz-9.
  IF fontheight>((myrect.maxy-myrect.miny)/6)
    defaultfont:=OpenFont(defaultfontattr)
    SetFont(myrp, defaultfont)
    fontheight:=myrp.font.ysize+2
  ENDIF

  fname.stringwidth:=TextLength(myrp, fname.string, fname.charcount)
  fheight.stringwidth:=TextLength(myrp, fheight.string, fheight.charcount)
  xDPI.stringwidth:=TextLength(myrp, xDPI.string, xDPI.charcount)
  yDPI.stringwidth:=TextLength(myrp, yDPI.string, yDPI.charcount)
  entrynum.stringwidth:=TextLength(myrp, entrynum.string, entrynum.charcount)

  -> What is the largest string length?
  stringwidth:=Max(Max(Max(Max(fname.stringwidth, fheight.stringwidth),
                   xDPI.stringwidth), yDPI.stringwidth), entrynum.stringwidth)
  stringwidth:=stringwidth+mywin.borderleft

  -> If the stringwidth is more than half the viewing area, quit because the
  -> font is just too big.
  IF stringwidth<((myrect.maxx-myrect.minx)/2)
    SetAPen(myrp, mydrawinfo.pens[TEXTPEN])
    SetDrMd(myrp, RP_JAM2)

    Move(myrp, myrect.minx+8+stringwidth-fname.stringwidth,
               myrect.miny+4+myrp.font.baseline)
    Text(myrp, fname.string, fname.charcount)

    Move(myrp, myrect.minx+8+stringwidth-fheight.stringwidth,
               myrp.cp_y+fontheight)
    Text(myrp, fheight.string, fheight.charcount)

    Move(myrp, myrect.minx+8+stringwidth-xDPI.stringwidth,
               myrp.cp_y+fontheight)
    Text(myrp, xDPI.string, xDPI.charcount)

    Move(myrp, myrect.minx+8+stringwidth-yDPI.stringwidth,
               myrp.cp_y+fontheight)
    Text(myrp, yDPI.string, yDPI.charcount)

    Move(myrp, myrect.minx+8+stringwidth-entrynum.stringwidth,
               myrp.cp_y+fontheight)
    Text(myrp, entrynum.string, entrynum.charcount)

    myrect.minx:=myrect.minx+cliprectside
    myrect.maxx:=myrect.maxx-cliprectside
    myrect.miny:=myrect.miny+(5*fontheight)+8
    myrect.maxy:=myrect.maxy-8

    -> Draw a box around the cliprect
    SetAPen(myrp, mydrawinfo.pens[SHINEPEN])
    Move(myrp, myrect.minx-1, myrect.maxy+1)
    Draw(myrp, myrect.maxx+1, myrect.maxy+1)
    Draw(myrp, myrect.maxx+1, myrect.miny-1)

    SetAPen(myrp, mydrawinfo.pens[SHADOWPEN])
    Draw(myrp, myrect.minx-1, myrect.miny-1)
    Draw(myrp, myrect.minx-1, myrect.maxy)

    SetAPen(myrp, mydrawinfo.pens[TEXTPEN])
    -> Fill up a buffer with a LIST of the available fonts.
    afsize:=AvailFonts(afh, 0,
                       AFF_MEMORY OR AFF_DISK OR AFF_SCALED OR AFF_TAGGED)
    REPEAT
      afh:=NewR(afsize)
      afshortage:=AvailFonts(afh, afsize,
                          AFF_MEMORY OR AFF_DISK OR AFF_SCALED OR AFF_TAGGED)
      IF afshortage
        Dispose(afh)
        afsize:=afsize+afshortage
        afh:=-1
      ENDIF
    UNTIL afshortage=0

    -> This is for the layers.library clipping region that gets attached to
    -> the window.  This prevents the application from unnecessarily rendering
    -> beyond the bounds of the inner part of the window. For more information
    -> on clipping, see the Layers chapter of the RKRM.
    new_region:=NewRegion()  -> More layers stuff
    IF OrRectRegion(new_region, myrect)  -> Even more layers stuff
      -> Obtain a pointer to the window's rastport and set up some of the
      -> rastport attributes.  This example obtains the text pen for the
      -> window's screen using the GetScreenDrawInfo() function.
      mycliprp:=mywin.rport
      SetAPen(mycliprp, mydrawinfo.pens[TEXTPEN])
      mainLoop()
    ENDIF
  ENDIF
EXCEPT DO
  IF new_region THEN DisposeRegion(new_region)
  IF afh THEN Dispose(afh)
  -> E-Note: C version forgets to CloseFont()
  IF defaultfont THEN CloseFont(defaultfont)
  IF mydrawinfo THEN FreeScreenDrawInfo(mywin.wscreen, mydrawinfo)
  IF mywin THEN CloseWindow(mywin)
  IF utilitybase THEN CloseLibrary(utilitybase)
  IF layersbase THEN CloseLibrary(layersbase)
  IF diskfontbase THEN CloseLibrary(diskfontbase)
  SELECT exception
  CASE ERR_DRAW;  WriteF('Error: could not get drawinfo from screen\n')
  CASE ERR_LIB;   WriteF('Error: could not open required library\n')
  CASE ERR_REGN;  WriteF('Error: could not allocate new region\n')
  CASE ERR_WIN;   WriteF('Error: could not open window\n')
  CASE "MEM";     WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC
->>>

->>> PROC mainLoop()
PROC mainLoop()
  DEF x, mymsg:PTR TO intuimessage, aok=TRUE, afont:PTR TO taf,
      myfont:PTR TO textfont, buf[8]:STRING, dpi

  -> E-Note: task data not needed since we can use CtrlC()
  afont:=afh+SIZEOF afh

  FOR x:=0 TO afh.numentries-1
    IF aok
      IF myfont:=OpenDiskFont(afont.attr)
        -> Print the TextFont attributes.
        SetAPen(myrp, mydrawinfo.pens[BACKGROUNDPEN])
        RectFill(myrp, stringwidth, mywin.bordertop+4,
                 mywin.width-(mywin.borderright+1), myrect.miny-2)

        SetAPen(myrp, mydrawinfo.pens[TEXTPEN])
        Move(myrp, stringwidth+mywin.borderleft,
             mywin.bordertop+4+myrp.font.baseline)
        Text(myrp, myfont.mn.ln.name, StrLen(myfont.mn.ln.name))

        -> Print the font's Y Size.
        Move(myrp, stringwidth+mywin.borderleft, myrp.cp_y+fontheight)
        StringF(buf, '\d', myfont.ysize)
        Text(myrp, buf, StrLen(buf))

        -> Print the X DPI
        Move(myrp, stringwidth+mywin.borderleft, myrp.cp_y+fontheight)
        dpi:=GetTagData(TA_DEVICEDPI, 0,
                        myfont.mn.replyport::textfontextension.tags)
        IF dpi
          StringF(buf, '\d', Shr(dpi AND $FFFF0000, 16))
          Text(myrp, buf, StrLen(buf))
        ELSE
          Text(myrp, 'NIL', 3)
        ENDIF

        -> Print the Y DPI
        Move(myrp, stringwidth+mywin.borderleft, myrp.cp_y+fontheight)
        IF dpi
          StringF(buf, '\d', dpi AND $0000FFFF)
          Text(myrp, buf, StrLen(buf))
        ELSE
          Text(myrp, 'NIL', 3)
        ENDIF

        -> Print the entrynum
        Move(myrp, stringwidth+mywin.borderleft, myrp.cp_y+fontheight)
        StringF(buf, '\d', x)
        Text(myrp, buf, StrLen(buf))

        SetFont(mycliprp, myfont)
        -> Install clipping rectangle
        old_region:=InstallClipRegion(mywin.wlayer, new_region)

        SetRast(mycliprp, mydrawinfo.pens[BACKGROUNDPEN])
        Move(mycliprp, myrect.minx,
             myrect.maxy-(myfont.ysize-myfont.baseline))
        Text(mycliprp, alphabetstring, alphabetcharcount)

        Delay(100)

        -> Remove clipping rectangle
        new_region:=InstallClipRegion(mywin.wlayer, old_region)

        WHILE mymsg:=GetMsg(mywin.userport)
          aok:=FALSE
          x:=afh.numentries
          ReplyMsg(mymsg)
        ENDWHILE

        -> Did the user hit Ctrl-C?
        IF CtrlC()
          aok:=FALSE
          x:=afh.numentries
          WriteF('Ctrl-C Break\n')
        ENDIF
        CloseFont(myfont)
      ENDIF
    ENDIF
    afont++
  ENDFOR
ENDPROC
->>>

->>> Version string
vers:
  CHAR 0, '$VER: AvailFonts 36.3', 0
->>>
