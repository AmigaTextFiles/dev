-> cliptext.e

->>> Header (globals)
MODULE 'diskfont',
       'layers',
       'diskfont/diskfonttag',
       'dos/rdargs',
       'graphics/displayinfo',
       'graphics/gfx',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'utility/tagitem'

ENUM ERR_NONE, ERR_ARGS, ERR_FONT, ERR_KICK, ERR_LIB, ERR_OPEN, ERR_READ,
     ERR_REGN, ERR_WIN

RAISE ERR_ARGS IF ReadArgs()=NIL,
      ERR_FONT IF OpenDiskFont()=NIL,
      ERR_KICK IF KickVersion()=FALSE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_OPEN IF Open()=NIL,
      ERR_READ IF Read()<0,
      ERR_REGN IF NewRegion()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST BUFSIZE=4096

ENUM FONT_NAME, FONT_SIZE, FILE_NAME, JAM_MODE, XASP, YASP, NUM_ARGS

CONST DEFAULTFONTSIZE=11, DEFAULTJAMMODE=0, DEFAULTXASP=0, DEFAULTYASP=0

DEF args:PTR TO LONG, tagitem[2]:ARRAY OF tagitem, buffer[BUFSIZE]:ARRAY,
    myfile=NIL, mymsg:PTR TO intuimessage, mydrawinfo:PTR TO drawinfo,
    mywin=NIL:PTR TO window, myrp:PTR TO rastport,
    myfont=NIL:PTR TO textfont, myrectangle:rectangle, new_region=NIL
->>>

->>> PROC main()
PROC main() HANDLE
  DEF myrda=NIL:PTR TO rdargs, mydi:displayinfo, mymodeid,
      mydefaultfontsize=DEFAULTFONTSIZE,
      mydefaultJAMMode=DEFAULTJAMMODE,
      mydefaultXASP=DEFAULTXASP,  -> E-Note: C version fails to use these!
      mydefaultYASP=DEFAULTYASP
  args:=['topaz.font', {mydefaultfontsize}, 's:startup-sequence',
         {mydefaultJAMMode}, {mydefaultXASP}, {mydefaultYASP}]
  -> Run only on 2.0 machines
  KickVersion(36)
  -> dos.library standard command line parsing.  See the dos.library Autodoc
  myrda:=ReadArgs('FontName,FontSize/N,FileName,Jam/N,XASP/N,YASP/N\n',
                  args, NIL)
  myfile:=Open(args[FILE_NAME], OLDFILE)  -> Open the file to display.
  diskfontbase:=OpenLibrary('diskfont.library', 36)   -> Open the libraries.
  layersbase:=OpenLibrary('layers.library', 36)
  -> This application wants to hear about three things: 1) When the user
  -> clicks the window's close gadget, 2) when the user starts to resize the
  -> window, 3) and when the user has finished resizing the window.
  mywin:=OpenWindowTagList(NIL,  -> Open that window.
                          [WA_MINWIDTH,     100,
                           WA_MINHEIGHT,    100,
                           WA_SMARTREFRESH, TRUE,
                           WA_SIZEGADGET,   TRUE,
                           WA_CLOSEGADGET,  TRUE,
                           WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_NEWSIZE OR
                                          IDCMP_SIZEVERIFY,
                           WA_DRAGBAR,      TRUE,
                           WA_DEPTHGADGET,  TRUE,
                           WA_TITLE,        args[FILE_NAME],
                           TAG_END])
  tagitem[0].tag:=OT_DEVICEDPI

  -> See if there is a non-zero value in the XASP or YASP fields.
  -> Diskfont.library will get a divide by zero GURU if you give it a zero
  -> XDPI or YDPI value.
  -> If there is a zero value in one of them...
  IF (Long(args[XASP])=0) OR (Long(args[YASP])=0)
    -> ...use the aspect ratio of the current display as a default...
    mymodeid:=GetVPModeID(mywin.wscreen.viewport)
    IF GetDisplayInfoData(NIL, mydi, SIZEOF displayinfo, DTAG_DISP, mymodeid)
      mydefaultXASP:=mydi.resolution.x
      mydefaultYASP:=mydi.resolution.y
      WriteF('XASP = \d    YAsp = \d\n', mydefaultXASP, mydefaultYASP)
      -> Notice that the X and Y get _swapped_ to keep the look of the font
      -> glyphs the same using screens with different aspect ratios.
      args[YASP]:={mydefaultXASP}
      args[XASP]:={mydefaultYASP}
    ELSE
      -> ...unless something is preventing us from getting the screens
      -> resolution.  In that case, forget about the DPI tag.
      tagitem[0].tag:=TAG_END
    ENDIF
  ENDIF
  -> Here we have to put the X and Y DPI into the OT_DEVICEDPI tags data
  -> field.  THESE ARE NOT REAL X AND Y DPI VALUES FOR THIS FONT OR THE
  -> DISPLAY.  They only serve to supply the diskfont.library with values to
  -> calculate the aspect ratio.  The X value gets stored in the upper word of
  -> the tag value and the Y DPI gets stored in the lower word.  Because
  -> ReadArgs() stores the _address_ of integers it gets from the command
  -> line, you have to dereference the pointer it puts into the argument
  -> array.
  tagitem.data:=Shl(Long(args[XASP]), 16) OR Long(args[YASP])
  tagitem.tag:=TAG_END

  -> Set up myfont to match the font the user requested.
  myfont:=OpenDiskFont([args[FONT_NAME], Long(args[FONT_SIZE]),
                        FSF_TAGGED, 0, tagitem]:ttextattr)  -> Open that font.
  -> This is for the layers.library clipping region that gets attached to the
  -> window.  This prevents the application from unnecessarily rendering
  -> beyond the bounds of the inner part of the window.  For now, you can
  -> ignore the layers stuff if you are just interested in learning about
  -> using text.  For more information on clipping regions and layers, see the
  -> Layers chapter of this manual.
  myrectangle.minx:=mywin.borderleft
  myrectangle.miny:=mywin.bordertop
  myrectangle.maxx:=mywin.width-(mywin.borderright+1)
  myrectangle.maxy:=mywin.height-(mywin.borderbottom+1)

  new_region:=NewRegion()
  IF OrRectRegion(new_region, myrectangle)
    InstallClipRegion(mywin.wlayer, new_region)
    -> Obtain a pointer to the window's rastport and set up some of the
    -> rastport attributes.  This example obtains the text pen for the
    -> window's screen using GetScreenDrawInfo().
    myrp:=mywin.rport
    SetFont(myrp, myfont)
    IF mydrawinfo:=GetScreenDrawInfo(mywin.wscreen)
      SetAPen(myrp, mydrawinfo.pens[TEXTPEN])
      FreeScreenDrawInfo(mywin.wscreen, mydrawinfo)
    ENDIF
    SetDrMd(myrp, Long(args[JAM_MODE]))

    mainLoop()
  ENDIF
EXCEPT DO
  IF new_region THEN DisposeRegion(new_region)
  IF myfont THEN CloseFont(myfont)
  IF mywin THEN CloseWindow(mywin)
  IF layersbase THEN CloseLibrary(layersbase)
  IF diskfontbase THEN CloseLibrary(diskfontbase)
  IF myfile THEN Close(myfile)
  IF myrda THEN FreeArgs(myrda)
  SELECT exception
  CASE ERR_ARGS;  WriteF('Error: ReadArgs() failed\n')
  CASE ERR_FONT;  WriteF('Error: could not open font\n')
  CASE ERR_KICK;  WriteF('Error: requires V36+\n')
  CASE ERR_LIB;   WriteF('Error: could not open required library\n')
  CASE ERR_OPEN;  WriteF('Error: could not open file\n')
  CASE ERR_READ;  WriteF('Error: Read() on the file failed\n')
  CASE ERR_REGN;  WriteF('Error: could not allocate region\n')
  CASE ERR_WIN;   WriteF('Error: could not open window\n')
  ENDSELECT
ENDPROC
->>>

->>> PROC mainLoop()
PROC mainLoop()
  DEF count, actual, position, aok=TRUE, waitfornewsize=FALSE
  -> E-Note: we don't need to find the task since we can use CtrlC()
  Move(myrp, mywin.borderleft+1, mywin.bordertop+myfont.ysize+1)

  -> While there's something to read, fill the buffer
  WHILE ((actual:=Read(myfile, buffer, BUFSIZE)) > 0) AND aok
    position:=0
    count:=0

    WHILE position<=actual
      -> E-Note: logic swapped here...
      IF waitfornewsize
        WaitPort(mywin.userport)
      ELSE
        WHILE (buffer[count]>=myfont.lochar) AND 
              (buffer[count]<=myfont.hichar) AND (count<=actual) DO INC count
        Text(myrp, buffer+position, count-position)

        WHILE ((buffer[count]<myfont.lochar) OR
               (buffer[count]>myfont.hichar)) AND (count<=actual)
          IF buffer[count]=$0A
            Move(myrp, mywin.borderleft, myrp.cp_y+myfont.ysize+1)
          ENDIF
          INC count
        ENDWHILE
        position:=count
      ENDIF

      WHILE mymsg:=GetMsg(mywin.userport)
        -> The user clicked the close gadget.
        IF mymsg.class=IDCMP_CLOSEWINDOW
          aok:=FALSE
          position:=actual+1
          ReplyMsg(mymsg)
        -> The user picked up the window's sizing gagdet.
        ELSEIF mymsg.class=IDCMP_SIZEVERIFY
          -> When the user has picked up the window's sizing gadget when the
          -> IDCMP_SIZEVERIFY flag is set, the application has to reply to
          -> this message to tell Intuition to allow the user to move the
          -> sizing gadget and resize the window.  The reason for using this
          -> here is because the user can resize the window while cliptext.e
          -> is rendering text to the window.  Cliptext.e has to stop
          -> rendering text when it receives an IDCMP_SIZEVERIFY message.
          ->
          -> If this example had instead asked to hear about IDCMP events that
          -> could take place between SIZEVERIFY and NEWSIZE events
          -> (especially INTUITICKS), it should turn off those events here
          -> using ModifyIDCMP().
          ->
          -> After we allow the user to resize the window, we cannot write
          -> into the window until the user has finished resizing it because
          -> we need the window's new size to adjust the clipping area. 
          -> Specifically, we have to wait for an IDCMP_NEWSIZE message which
          -> Intuition will send when the user lets go of the resize gadget. 
          -> For now, we set the waitfornewsize flag to stop rendering until
          -> we get that NEWSIZE message.
          waitfornewsize:=TRUE
          WaitBlit()
          -> The blitter is done, let the user resize the window
          ReplyMsg(mymsg)
        ELSE
          ReplyMsg(mymsg)
          waitfornewsize:=FALSE
          -> The user has resized the window, so get the new window dimensions
          -> and readjust the layers clipping region accordingly.
          myrectangle.minx:=mywin.borderleft
          myrectangle.miny:=mywin.bordertop
          myrectangle.maxx:=mywin.width-(mywin.borderright+1)
          myrectangle.maxy:=mywin.height-(mywin.borderbottom+1)
          InstallClipRegion(mywin.wlayer, NIL)
          ClearRegion(new_region)
          IF OrRectRegion(new_region, myrectangle)
            InstallClipRegion(mywin.wlayer, new_region)
          ELSE
            aok:=FALSE
            position:=actual+1
          ENDIF
        ENDIF
      ENDWHILE
      IF CtrlC()  -> Check for user break.
        aok:=FALSE
        position:=actual+1
      ENDIF

      -> If we reached the bottom of the page, clear the rastport and move
      -> back to the top.
      IF myrp.cp_y>(mywin.height-(mywin.borderbottom+2))
        Delay(25)

        -> Set the entire rastport to colour zero.  This will not include the
        -> window borders because of the layers clipping.
        SetRast(myrp, 0)
        Move(myrp, mywin.borderleft+1, mywin.bordertop+myfont.ysize+1)
      ENDIF
    ENDWHILE
  ENDWHILE
ENDPROC
->>>

->>> Version string
vers:
  CHAR 0, '$VER: cliptext 37.2', 0
->>>
