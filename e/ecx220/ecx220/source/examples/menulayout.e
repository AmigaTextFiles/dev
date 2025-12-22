-> menulayout.e - Example showing how to do menu layout in general.  This
-> example also illustrates handling menu events, including IDCMP_MENUHELP
-> events.
->
-> Note that handling arbitrary fonts is fairly complex.  Applications that
-> require V37 should use the simpler menu layout routines found in the
-> GadTools library.

OPT PREPROCESS

MODULE 'dos/dos',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens'

ENUM ERR_NONE, ERR_DRAW, ERR_FONT, ERR_KICK, ERR_MENU, ERR_PUB, ERR_WIN

RAISE ERR_DRAW IF GetScreenDrawInfo()=NIL,
      ERR_FONT IF OpenFont()=NIL,
      ERR_MENU IF SetMenuStrip()=FALSE,
      ERR_PUB  IF LockPubScreen()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

DEF firstMenu

-> Open all of the required libraries.  Note that we require V37, as the
-> routine uses OpenWindowTags().
PROC main() HANDLE
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)

  doWindow()

EXCEPT DO
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_DRAW; WriteF('Error: Failed to get screen DrawInfo\n')
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  CASE ERR_MENU; WriteF('Error: Failed to attach menu\n')
  CASE ERR_PUB;  WriteF('Error: Failed to lock public screen\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  ENDSELECT
  RETURN IF exception=ERR_NONE THEN RETURN_FAIL ELSE RETURN_OK
ENDPROC

-> Open a window with some properly positioned text.  Layout and set the menus,
-> then process any events received.  Cleanup when done.
PROC doWindow() HANDLE
  -> E-Note: some of these are global arrays in the C version
  DEF settItem, editItem, prtItem, projItem, menus,
      winText0:PTR TO intuitext, winText1:PTR TO intuitext,
      window=NIL:PTR TO window, screen=NIL:PTR TO screen,
      drawinfo=NIL:PTR TO drawinfo,
      win_width, alt_width, win_height

  screen:=LockPubScreen(NIL)
  drawinfo:=GetScreenDrawInfo(screen)

  -> Window Text for Explanation of Program
  -> Get the colors for the window text
  -> Use the screen's font for the text
  -> E-Note: link directly without an array
  winText0:=[drawinfo.pens[TEXTPEN], drawinfo.pens[BACKGROUNDPEN], RP_JAM2,
            0, 0, screen.font, 'How to do a Menu', NIL]:intuitext
  winText1:=[drawinfo.pens[TEXTPEN], drawinfo.pens[BACKGROUNDPEN], RP_JAM2,
            0, 0, screen.font, '(with Style)', winText0]:intuitext

  -> Calculate window size
  win_width:=100+IntuiTextLength(winText0)
  alt_width:=100+IntuiTextLength(winText1)
  IF win_width<alt_width THEN win_width:=alt_width
  win_height:=1+screen.wbortop+screen.wborbottom+(screen.font.ysize*5)

  -> Calculate the correct positions for the text in the window
  winText0.leftedge:=Shr(win_width-IntuiTextLength(winText0), 1)
  winText0.topedge:=1+screen.wbortop+(2*screen.font.ysize)
  winText1.leftedge:=Shr(win_width-IntuiTextLength(winText1), 1)
  winText1.topedge:=winText0.topedge+screen.font.ysize

  -> Open the window
  window:=OpenWindowTagList(NIL,
            [WA_PUBSCREEN, screen,
             WA_IDCMP, IDCMP_MENUPICK OR IDCMP_CLOSEWINDOW OR IDCMP_MENUHELP,
             WA_FLAGS, WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
                         WFLG_ACTIVATE OR WFLG_NOCAREREFRESH,
             WA_LEFT,  10,             WA_TOP,      screen.barheight+1,
             WA_WIDTH, win_width,      WA_HEIGHT,   win_height,
             WA_TITLE, 'Menu Example', WA_MENUHELP, TRUE,
             NIL])

  -> Give a brief explanation of the program
  PrintIText(window.rport, winText1, 0, 0)

  -> E-Note: define the menus using (local) typed lists rather than arrays
  -> E-Note: link menu items in reverse order to layout

  -> Settings Items
  -> 'Eat It Too' (excludes 'Have Your Cake')
  settItem:=[NIL, 0, 0, 0, 0,
             ITEMTEXT OR ITEMENABLED OR HIGHCOMP OR CHECKIT, 4,
              [0, 1, RP_JAM2, CHECKWIDTH, 1, NIL,
               ' Eat It Too', NIL]:intuitext,
             NIL, NIL, NIL, MENUNULL]:menuitem
  -> 'Have Your Cake' (initially selected, excludes 'Eat It Too')
  settItem:=[settItem, 0, 0, 0, 0,
             ITEMTEXT OR ITEMENABLED OR HIGHCOMP OR CHECKIT OR CHECKED, 8,
              [0, 1, RP_JAM2, CHECKWIDTH, 1, NIL,
               ' Have Your Cake', NIL]:intuitext,
             NIL, NIL, NIL, MENUNULL]:menuitem
  -> 'Auto Save' (toggle-select, initially selected)
  settItem:=[settItem, 0, 0, 0, 0,
             ITEMTEXT OR ITEMENABLED OR HIGHCOMP OR CHECKIT OR
               MENUTOGGLE OR CHECKED, 0,
              [0, 1, RP_JAM2, CHECKWIDTH, 1, NIL,
               ' Auto Save', NIL]:intuitext,
             NIL, NIL, NIL, MENUNULL]:menuitem
  -> 'Sound...'
  settItem:=[settItem, 0, 0, 0, 0,
             ITEMTEXT OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL,
               'Sound...', NIL]:intuitext,
             NIL, NIL, NIL, MENUNULL]:menuitem

  -> Edit Menu Items
  -> 'Undo' (key-equivalent: "Z")
  editItem:=[NIL, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Undo', NIL]:intuitext,
             NIL, "Z", NIL, MENUNULL]:menuitem
  -> 'Erase' (disabled)
  editItem:=[editItem, 0, 0, 0, 0,
             ITEMTEXT OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Erase', NIL]:intuitext,
             NIL, NIL, NIL, MENUNULL]:menuitem
  -> 'Paste' (key-equivalent: "V")
  editItem:=[editItem, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Paste', NIL]:intuitext,
             NIL, "V", NIL, MENUNULL]:menuitem
  -> 'Copy' (key-equivalent: "C")
  editItem:=[editItem, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Copy', NIL]:intuitext,
             NIL, "C", NIL, MENUNULL]:menuitem
  -> 'Cut' (key-equivalent: "X")
  editItem:=[editItem, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Cut', NIL]:intuitext,
             NIL, "X", NIL, MENUNULL]:menuitem

  -> Print Sub-Items
  -> 'Draft'
  prtItem:=[NIL, 0, 0, 0, 0,
            ITEMTEXT OR ITEMENABLED OR HIGHCOMP, 0,
             [0, 1, RP_JAM2, 2, 1, NIL, 'Draft', NIL]:intuitext,
            NIL, NIL, NIL, MENUNULL]:menuitem
  -> 'NLQ'
  prtItem:=[prtItem, 0, 0, 0, 0,
            ITEMTEXT OR ITEMENABLED OR HIGHCOMP, 0,
             [0, 1, RP_JAM2, 2, 1, NIL, 'NLQ', NIL]:intuitext,
            NIL, NIL, NIL, MENUNULL]:menuitem

  -> Uses the >> character to indicate a sub-menu item.
  -> This is \273 Octal, 0xBB Hex or Alt-0 from the Keyboard.
  ->
  -> NOTE that standard menus place this character at the right margin of the
  -> menu box.  This may be done by using a second IntuiText structure for the
  -> single character, linking this IntuiText to the first one, and positioning
  -> the IntuiText so that the character appears at the right margin.
  -> GadTools library will provide the correct behavior.

  -> Project Menu Items
  -> 'Quit' (key-equivalent: "Q")
  projItem:=[NIL, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Quit', NIL]:intuitext,
             NIL, "Q", NIL, MENUNULL]:menuitem
  -> 'About...'
  projItem:=[projItem, 0, 0, 0, 0,
             ITEMTEXT OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'About...', NIL]:intuitext,
             NIL, NIL, NIL, MENUNULL]:menuitem
  -> 'Print' (has sub-menu)
  projItem:=[projItem, 0, 0, 0, 0,
             ITEMTEXT OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Print     »', NIL]:intuitext,
             NIL, NIL, prtItem, MENUNULL]:menuitem
  -> 'Save As...' (key-equivalent: "A")
  projItem:=[projItem, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Save As...', NIL]:intuitext,
             NIL, "A", NIL, MENUNULL]:menuitem
  -> 'Save' (key-equivalent: "S")
  projItem:=[projItem, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Save', NIL]:intuitext,
             NIL, "S", NIL, MENUNULL]:menuitem
  -> 'Open...' (key-equivalent: "O")
  projItem:=[projItem, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'Open...', NIL]:intuitext,
             NIL, "O", NIL, MENUNULL]:menuitem
  -> 'New' (key-equivalent: "N")
  projItem:=[projItem, 0, 0, 0, 0,
             ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP, 0,
              [0, 1, RP_JAM2, 2, 1, NIL, 'New', NIL]:intuitext,
             NIL, "N", NIL, MENUNULL]:menuitem

  -> Menu Titles
  -> E-Note: link in reverse order to layout
  -> E-Note: use NEW to zero trailing fields
  menus:=NEW [NIL,  120, 0, 88, 0, MENUENABLED, 'Settings', settItem]:menu
  menus:=NEW [menus, 70, 0, 39, 0, MENUENABLED, 'Edit',     editItem]:menu
  menus:=NEW [menus,  0, 0, 63, 0, MENUENABLED, 'Project',  projItem]:menu

  -> A pointer to the first menu for easy reference
  firstMenu:=menus

  -> Adjust the menu to conform to the font (TextAttr)
  adjustMenus(menus, window.wscreen.font)

  -> Attach the menu to the window
  SetMenuStrip(window, menus)

  REPEAT
  UNTIL handleIDCMP(window)

  -> Clean up everything used here
  ClearMenuStrip(window)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF window THEN CloseWindow(window)
  IF drawinfo THEN FreeScreenDrawInfo(screen, drawinfo)
  IF screen THEN UnlockPubScreen(NIL, screen)
  -> E-Note: pass on error, or else RETURN_OK if no error
  ReThrow()
ENDPROC RETURN_OK

-> Print out what menu was selected.  Properly handle the IDCMP_MENUHELP
-> events.  Set done to TRUE if quit is selected.
PROC processMenus(selection, done)
  DEF menuNum, itemNum, subNum, item:PTR TO menuitem

  menuNum:=MENUNUM(selection)
  itemNum:=ITEMNUM(selection)
  subNum:=SUBNUM(selection)

  -> When processing IDCMP_MENUHELP, you are not guaranteed to get a menu item.
  IF itemNum<>NOITEM
    item:=ItemAddress(firstMenu, selection)
    IF item.flags AND CHECKED THEN WriteF('(Checked) ')
  ENDIF

  SELECT menuNum
  CASE 0 -> Project Menu
    SELECT itemNum
    CASE NOITEM; WriteF('Project Menu\n')
    CASE 0;      WriteF('New\n')
    CASE 1;      WriteF('Open\n')
    CASE 2;      WriteF('Save\n')
    CASE 3;      WriteF('Save As\n')
    CASE 4;      WriteF('Print ')
      SELECT subNum
      CASE NOSUB; WriteF('Item\n')
      CASE 0;     WriteF('NLQ\n')
      CASE 1;     WriteF('Draft\n')
      ENDSELECT
    CASE 5;      WriteF('About\n')
    CASE 6;      WriteF('Quit\n'); done:=TRUE
    ENDSELECT
  CASE 1 -> Edit Menu
    SELECT itemNum
    CASE NOITEM; WriteF('Edit Menu\n')
    CASE 0;      WriteF('Cut\n')
    CASE 1;      WriteF('Copy\n')
    CASE 2;      WriteF('Paste\n')
    CASE 3;      WriteF('Erase\n')
    CASE 4;      WriteF('Undo\n')
    ENDSELECT
  CASE 2 -> Settings Menu
    SELECT itemNum
    CASE NOITEM; WriteF('Settings Menu\n')
    CASE 0;      WriteF('Sound\n')
    CASE 1;      WriteF('Auto Save\n')
    CASE 2;      WriteF('Have Your Cake\n')
    CASE 3;      WriteF('Eat It Too\n')
    ENDSELECT
  CASE NOMENU -> No menu selected, can happen with IDCMP_MENUHELP
    WriteF('no menu\n')
  ENDSELECT
ENDPROC done

-> E-Note: used to convert an INT to unsigned
#define UNSIGNED(x) ((x) AND $FFFF)

-> Handle the IDCMP messages.  Set done to TRUE if quit or closewindow is
-> selected.
PROC handleIDCMP(win)
  DEF done=FALSE, selection, class, item:PTR TO menuitem
  class:=WaitIMessage(win)
  SELECT class
  CASE IDCMP_CLOSEWINDOW
    done:=TRUE
  CASE IDCMP_MENUHELP
    -> The routine that handles the menus for IDCMP_MENUHELP must be very
    -> careful it can receive menu information that is impossible under
    -> IDCMP_MENUPICK.  For instance, the code value on a IDCMP_MENUHELP may
    -> have a valid number for the menu, then NOITEM and NOSUB. IDCMP_MENUPICK
    -> would get MENUNULL in this case.  IDCMP_MENUHELP never come as
    -> multi-select items, and the event terminates the menu processing session.
    ->
    -> Note that the return value from the processMenus() routine is ignored:
    -> the application should not quit if the user selects "help" over the quit
    -> menu item.
    WriteF('IDCMP_MENUHELP: Help on ')
    processMenus(MsgCode(), done)
  CASE IDCMP_MENUPICK
    -> E-Note: convert message code to an unsigned INT
    selection:=UNSIGNED(MsgCode())
    WHILE selection<>MENUNULL
      WriteF('IDCMP_MENUPICK: Selected ')
      done:=processMenus(selection, done)
      item:=ItemAddress(firstMenu, selection)
      -> E-Note: convert item.nextselect to an unsigned INT
      selection:=UNSIGNED(item.nextselect)
    ENDWHILE
  ENDSELECT
ENDPROC done

-> Steps through each item to determine the maximum width of the strip
PROC maxLength(textRPort, first_item, char_size)
  DEF maxLength, total_textlen, cur_item:PTR TO menuitem,
      itext:PTR TO intuitext, extra_width, maxCommCharWidth, commCharWidth

  extra_width:=char_size  -> Used as padding for each item

  -> Find the maximum length of a command character, if any.
  -> If found, it will be added to the extra_width field.
  maxCommCharWidth:=0
  cur_item:=first_item
  WHILE cur_item
    IF cur_item.flags AND COMMSEQ
      -> E-Note: requires address of the command character
      commCharWidth:=TextLength(textRPort, [cur_item.command]:CHAR, 1)
      IF commCharWidth>maxCommCharWidth THEN maxCommCharWidth:=commCharWidth
    ENDIF
    cur_item:=cur_item.nextitem
  ENDWHILE

  -> If we found a command sequence, add it to the extra required space.  Add
  -> space for the Amiga key glyph plus space for the command character.  Note
  -> this only works for HIRES screens, for LORES, use LOWCOMMWIDTH.
  IF maxCommCharWidth>0 THEN extra_width:=extra_width+maxCommCharWidth+COMMWIDTH

  -> Find the maximum length of the menu items, given the extra width
  -> calculated above.
  maxLength:=0
  cur_item:=first_item
  WHILE cur_item
    itext:=cur_item.itemfill
    total_textlen:=extra_width+itext.leftedge+
                   TextLength(textRPort, itext.itext, StrLen(itext.itext))

    -> Returns the greater of the two
    IF total_textlen>maxLength THEN maxLength:=total_textlen

    cur_item:=cur_item.nextitem
  ENDWHILE
ENDPROC maxLength

-> Set all IntuiText in a chain (they are linked through the nexttext field)
-> to the same font.
PROC setITextAttr(first_IText, textAttr)
  DEF cur_IText:PTR TO intuitext
  cur_IText:=first_IText
  WHILE cur_IText
    cur_IText.itextfont:=textAttr
    cur_IText:=cur_IText.nexttext
  ENDWHILE
ENDPROC

-> Adjust the MenuItems and SubItems
PROC adjustItems(textRPort, first_item, textAttr, char_size,
                 height, level, left_edge)
  DEF item_num, cur_item:PTR TO menuitem, strip_width, subitem_edge
  IF first_item=NIL THEN RETURN

  -> The width of this strip is the maximum length of its members.
  strip_width:=maxLength(textRPort, first_item, char_size)

  -> Position the items.
  cur_item:=first_item
  item_num:=0
  WHILE cur_item
    cur_item.topedge:=(item_num*height)-level
    cur_item.leftedge:=left_edge
    cur_item.width:=strip_width
    cur_item.height:=height

    -> Place the sub_item 3/4 of the way over on the item
    subitem_edge:=strip_width-(strip_width/4)

    setITextAttr(cur_item.itemfill, textAttr)
    adjustItems(textRPort, cur_item.subitem, textAttr, char_size,
                height, 1, subitem_edge)

    cur_item:=cur_item.nextitem
    INC item_num
  ENDWHILE
ENDPROC


-> The following routines adjust an entire menu system to conform to the
-> specified font's width and height.  Allows for Proportional Fonts.  This is
-> necessary for a clean look regardless of what the users preference in Fonts
-> may be.  Using these routines, you don't need to specify TopEdge, LeftEdge,
-> Width or Height in the MenuItem structures.
->
-> NOTE that this routine does not work for menus with images, but assumes that
-> all menu items are rendered with IntuiText.
->
-> This set of routines does NOT check/correct if the menu runs off the screen
-> due to large fonts, too many items, lo-res screen.
PROC adjustMenus(first_menu, textAttr) HANDLE
  DEF textrp:PTR TO rastport, cur_menu:PTR TO menu, font=NIL:PTR TO textfont,
      start, char_size, height

  -> E-Note: dynamically allocate a zeroed rastport (might raise exception)
  NEW textrp

  -> Open the font
  font:=OpenFont(textAttr)
  SetFont(textrp, font)  -> Put font in to temporary RastPort

  char_size:=TextLength(textrp, 'n', 1)  -> Get the width of the font

  -> To prevent crowding of the Amiga key when using COMMSEQ, don't allow the
  -> items to be less than 8 pixels high.  Also, add an extra pixel for
  -> inter-line spacing.
  height:=1+(IF font.ysize>8 THEN font.ysize ELSE 8)

  start:=2  -> Set Starting Pixel

  -> Step thru the menu structure and adjust it
  cur_menu:=first_menu
  WHILE cur_menu
    cur_menu.leftedge:=start
    cur_menu.width:=char_size+
                    TextLength(textrp, cur_menu.menuname,
                               StrLen(cur_menu.menuname))
    adjustItems(textrp, cur_menu.firstitem, textAttr, char_size, height, 0, 0)
    start:=start+cur_menu.width+(char_size*2)
    cur_menu:=cur_menu.nextmenu
  ENDWHILE
EXCEPT DO
  IF font THEN CloseFont(font)  -> Close the Font
  -> E-Note: as C version ignores font error we'll ignore any NEW error...
  RETURN exception=ERR_NONE
ENDPROC
