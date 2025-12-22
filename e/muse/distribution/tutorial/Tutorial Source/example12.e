
-> Example12.e
-> A more complex menu.

MODULE 'muse/muse'
ENUM NONE, SELECTION

/* Same handler */
PROC menu_selection() IS request('You selected a menu item!')

PROC main()
DEF mymenus, mywindow, myevents
   mymenus:= [
               ['HEADER','Project'],
                  ['ITEM', ['New'    ,'n',SELECTION]],
                  ['STD_IMAGE', ['OPEN','o',SELECTION]],      -> Images
                  ['ITEM', ['Printer',0,0]],                  -> Sub menu header
                     ['SUBITEM',       ['Print','p',0]],      -> Sub item.
                     ['SUB_STD_IMAGE', ['PRINT','p',0]],      -> Image in a sub-menu
                     ['SUB_STD_IMAGE', ['PRINTSETUP','p',0]],
                  ['BAR',0],
                  ['ITEM', ['Close',  'k',SELECTION]],
                  ['BAR',0],
                  ['ITEM', ['Quit',   'q',QUIT]],
               ['HEADER','Edit'],
                 ['STD_IMAGE', ['MUSE_LOGO',0,0]],
                  ['ITEM', ['Clips',0,0]],
                     ['SUB_STD_IMAGE', ['CUT',  'x',0]],
                     ['SUB_STD_IMAGE', ['COPY', 'c',0]],
                     ['SUB_STD_IMAGE', ['PASTE','v',0]]
             ]
/* NO CHANGES FROM HERE ON */
   mywindow:=[
                [MENUS,    mymenus]
             ]
   myevents:=[
               [SELECTION, {menu_selection}]
             ]
   easy_muse([
               [EVENTS, myevents],
               [WINDOW, mywindow]
             ])
ENDPROC
