-> gadtoolsmenu.e
-> Example showing the basic usage of the menu system with a window.
-> Menu layout is done with GadTools, as is recommended for applications.

OPT PREPROCESS

MODULE 'gadtools',
       'intuition/intuition',
       'libraries/gadtools'

ENUM ERR_NONE, ERR_LIB, ERR_MENU, ERR_VIS, ERR_WIN

RAISE ERR_LIB  IF OpenLibrary()=NIL,
      ERR_MENU IF CreateMenusA()=NIL,
      ERR_VIS  IF GetVisualInfoA()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

-> E-Note: used to convert an INT to unsigned
#define UNSIGNED(x) ((x) AND $FFFF)

-> Watch the menus and wait for the user to select the close gadget or quit
-> from the menus.
PROC handle_window_events(win, menuStrip)
  DEF done=FALSE, menuNumber, menuNum, itemNum, subNum,
      item:PTR TO menuitem, class
  REPEAT
    -> E-Note: we can use WaitIMessage in this example
    class:=WaitIMessage(win)
    SELECT class
    CASE IDCMP_CLOSEWINDOW
      done:=TRUE
    CASE IDCMP_MENUPICK
      -> E-Note: convert message code to an unsigned INT
      menuNumber:=UNSIGNED(MsgCode())
      WHILE (menuNumber<>MENUNULL) AND (done=FALSE)
        item:=ItemAddress(menuStrip, menuNumber)

        -> Process the item here!
        menuNum:=MENUNUM(menuNumber)
        itemNum:=ITEMNUM(menuNumber)
        subNum:=SUBNUM(menuNumber)

        -> Stop if quit is selected
        IF (menuNum=0) AND (itemNum=5) THEN done:=TRUE

        -> E-Note: convert item.nextselect to an unsigned INT
        menuNumber:=UNSIGNED(item.nextselect)
      ENDWHILE
    ENDSELECT
  UNTIL done
ENDPROC

-> Open all of the required libraries and set-up the menus
PROC main() HANDLE
  DEF win=NIL:PTR TO window, my_VisualInfo=NIL, menuStrip=NIL
  gadtoolsbase:=OpenLibrary('gadtools.library', 37)
  win:=OpenWindowTagList(NIL, [WA_WIDTH,  400, WA_ACTIVATE,    TRUE,
                               WA_HEIGHT, 100, WA_CLOSEGADGET, TRUE,
                               WA_TITLE,  'Menu Test Window',
                               WA_IDCMP,  IDCMP_CLOSEWINDOW OR IDCMP_MENUPICK,
                               NIL])
  my_VisualInfo:=GetVisualInfoA(win.wscreen, [NIL])
  menuStrip:=CreateMenusA([NM_TITLE, 0, 'Project',     0, 0, 0, 0,
                            NM_ITEM, 0, 'Open...',   'O', 0, 0, 0,
                            NM_ITEM, 0, 'Save',      'S', 0, 0, 0,
                            NM_ITEM, 0, NM_BARLABEL,   0, 0, 0, 0,
                            NM_ITEM, 0, 'Print',       0, 0, 0, 0,
                             NM_SUB, 0, 'Draft',       0, 0, 0, 0,
                             NM_SUB, 0, 'NLQ',         0, 0, 0, 0,
                            NM_ITEM, 0, NM_BARLABEL,   0, 0, 0, 0,
                            NM_ITEM, 0, 'Quit...',   'Q', 0, 0, 0,
                           NM_TITLE, 0, 'Edit',        0, 0, 0, 0,
                            NM_ITEM, 0, 'Cut',       'X', 0, 0, 0,
                            NM_ITEM, 0, 'Copy',      'C', 0, 0, 0,
                            NM_ITEM, 0, 'Paste',     'V', 0, 0, 0,
                            NM_ITEM, 0, NM_BARLABEL,   0, 0, 0, 0,
                            NM_ITEM, 0, 'Undo',      'Z', 0, 0, 0,
                             NM_END, 0, NIL,           0, 0, 0, 0]:newmenu,
                          [NIL])
  IF LayoutMenusA(menuStrip, my_VisualInfo, [NIL])
    IF SetMenuStrip(win, menuStrip)
      handle_window_events(win, menuStrip)

      ClearMenuStrip(win)
    ENDIF
    FreeMenus(menuStrip)
  ENDIF
EXCEPT DO
  IF my_VisualInfo THEN FreeVisualInfo(my_VisualInfo)
  IF win THEN CloseWindow(win)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: Could not open gadtools.library\n')
  CASE ERR_MENU; WriteF('Error: Could not create menu\n')
  CASE ERR_VIS;  WriteF('Error: Could not get visual info\n')
  CASE ERR_WIN;  WriteF('Error: Could not open window\n')
  ENDSELECT
ENDPROC