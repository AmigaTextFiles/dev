-> simplemenu.e: How to use the menu system with a window under all OS versions.

OPT PREPROCESS

MODULE 'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens'

-> These values are based on the ROM font Topaz8. Adjust these values to
-> correctly handle the screen's current font.
CONST MENWIDTH=56+8, -> Longest menu item name * font width + 8 pixels for trim
      MENHEIGHT=10   -> Font height + 2 pixels

-> We only use a single menu, but the code is generalisable to more than
-> one menu.
CONST NUM_MENUS=1

ENUM ERR_NONE, ERR_WIN, ERR_MENU

RAISE ERR_WIN  IF OpenWindow()=NIL,
      ERR_MENU IF SetMenuStrip()=FALSE  -> E-Note: not really necessary...

PROC main() HANDLE
  -> E-Note: some of these are global arrays in the C version
  DEF topaz80, submenu1, menu1, menutitle, menustrip:PTR TO menu,
      win=NIL:PTR TO window, left=2

  win:=OpenWindow([40, 40, 300, 100, 0, 1, IDCMP_CLOSEWINDOW OR IDCMP_MENUPICK,
                   WFLG_DRAGBAR OR WFLG_ACTIVATE OR WFLG_CLOSEGADGET, NIL, NIL,
                   'Menu Test Window', NIL, NIL, 0, 0, 0, 0, WBENCHSCREEN]:nw)

  -> To keep this example simple, we'll hard-code the font used for menu items.
  -> Algorithmic layout can be used to handle arbitrary fonts.  Under Release 2,
  -> GadTools provides font-sensitive menu layout.  Note that we still must
  -> handle fonts for the menu headers.
  topaz80:=['topaz.font', 8, 0, 0]:textattr

  -> E-Note: linking needs to be done in reverse order to layout
  -> Sub-item 1, NLQ
  submenu1:=[NIL, MENWIDTH-2, MENHEIGHT-2, MENWIDTH, MENHEIGHT,
             ITEMTEXT OR MENUTOGGLE OR ITEMENABLED OR HIGHCOMP, 0,
             [0, 1, RP_JAM2, 0, 1, topaz80, 'NLQ', NIL]:intuitext,
             NIL, NIL, NIL, NIL]:menuitem
  -> Sub-item 0, Draft
  submenu1:=[submenu1, MENWIDTH-2, -2, MENWIDTH, MENHEIGHT,
             ITEMTEXT OR MENUTOGGLE OR ITEMENABLED OR HIGHCOMP, 0,
             [0, 1, RP_JAM2, 0, 1, topaz80, 'Draft', NIL]:intuitext,
             NIL, NIL, NIL, NIL]:menuitem

  -> E-Note: linking needs to be done in reverse order to layout
  -> Item 3, Quit
  menu1:=[NIL, 0, 3*MENHEIGHT, MENWIDTH, MENHEIGHT,
          ITEMTEXT OR MENUTOGGLE OR ITEMENABLED OR HIGHCOMP, 0,
          [0, 1, RP_JAM2, 0, 1, topaz80, 'Quit', NIL]:intuitext,
          NIL, NIL, NIL, NIL]:menuitem
  -> Item 2, Print
  menu1:=[menu1, 0, 2*MENHEIGHT, MENWIDTH, MENHEIGHT,
          ITEMTEXT OR MENUTOGGLE OR ITEMENABLED OR HIGHCOMP, 0,
          [0, 1, RP_JAM2, 0, 1, topaz80, 'Print »', NIL]:intuitext,
          NIL, NIL, submenu1, NIL]:menuitem
  -> Item 1, Save
  menu1:=[menu1, 0, MENHEIGHT, MENWIDTH, MENHEIGHT,
          ITEMTEXT OR MENUTOGGLE OR ITEMENABLED OR HIGHCOMP, 0,
          [0, 1, RP_JAM2, 0, 1, topaz80, 'Save', NIL]:intuitext,
          NIL, NIL, NIL, NIL]:menuitem
  -> Item 0, Open...
  menu1:=[menu1, 0, 0, MENWIDTH, MENHEIGHT,
          ITEMTEXT OR MENUTOGGLE OR ITEMENABLED OR HIGHCOMP, 0,
          [0, 1, RP_JAM2, 0, 1, topaz80, 'Open...', NIL]:intuitext,
          NIL, NIL, NIL, NIL]:menuitem

  menutitle:='Project'

  -> E-Note: use NEW, or remember to initialise last elements to 0
  menustrip:=[NIL, left, 0,
              TextLength(win.wscreen.rastport, menutitle, StrLen(menutitle))+8,
              MENHEIGHT, MENUENABLED, menutitle, menu1, 0, 0, 0, 0]:menu

  left:=left+menustrip.width

  SetMenuStrip(win, menustrip)

  handleWindow(win, menustrip)

  ClearMenuStrip(win)

 -> E-Note: exit and clean up via handler
EXCEPT DO
  IF win THEN CloseWindow(win)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  CASE ERR_MENU; WriteF('Error: Failed to attach menu\n')
  ENDSELECT
ENDPROC

-> E-Note: used to convert an INT to unsigned
#define UNSIGNED(x) ((x) AND $FFFF)

-> Wait for the user to select the close gadget.
-> E-Note: E version is simpler, since we use WaitIMessage
PROC handleWindow(win, menuStrip)
  DEF done=FALSE, class, menuNumber, menuNum, itemNum, subNum,
      item:PTR TO menuitem
  REPEAT
    class:=WaitIMessage(win)
    SELECT class
    CASE IDCMP_CLOSEWINDOW
      done:=TRUE
    CASE IDCMP_MENUPICK
      -> E-Note: menuNumber is an unsigned INT
      menuNumber:=UNSIGNED(MsgCode())
      WHILE (menuNumber<>MENUNULL) AND (done=FALSE)
        item:=ItemAddress(menuStrip, menuNumber)

        -> Process this item
        -> If there were no sub-items attached to that item,
        -> SubNumber will equal NOSUB.
        menuNum:=MENUNUM(menuNumber)
        itemNum:=ITEMNUM(menuNumber)
        subNum:=SUBNUM(menuNumber)

        -> Note that we are printing all values, even things like NOMENU,
        -> NOITEM and NOSUB.  An application should check for these cases.
        WriteF('IDCMP_MENUPICK: menu \d, item \d, sub \d\n',
               menuNum, itemNum, subNum)

        -> This one is the quit menu selection...
        -> stop if we get it, and don't process any more.
        -> E-Note: the C version is wrong! QUIT is itemNum = 3
        IF (menuNum=0) AND (itemNum=3) THEN done:=TRUE

        -> E-Note: menuNumber is an unsigned INT
        menuNumber:=UNSIGNED(item.nextselect)
      ENDWHILE
    ENDSELECT
  UNTIL done
ENDPROC
